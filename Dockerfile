FROM alpine:3.16.3 AS with-mysql

USER root

RUN apk add --update --no-cache mysql
RUN apk add --update --no-cache mysql-client

COPY --chmod=644 conf/mysql_startup.sh /mysql_startup.sh
COPY --chmod=644 conf/mysql_connection_test.sh /mysql_connection_test.sh
COPY --chmod=644 conf/mysql_query_test.sh /mysql_query_test.sh
COPY --chmod=644 conf/my.cnf /etc/mysql/my.cnf
COPY --chmod=644 conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf


FROM with-mysql AS testing

CMD sh /mysql_startup.sh && sh -c | \
    until sh /mysql_connection_test.sh; do \
        sleep 10; \
    done; \
    sh /mysql_query_test.sh
