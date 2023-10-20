FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN
COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/
ARG db_url
ARG db_username
ARG db_password
RUN sed -i 's|10.0.12.9:3306|'${db_url}'|g' /tmp/src/main/resources/application.properties
RUN sed -i 's|username|'${db_username}'|2' /tmp/src/main/resources/application.properties
RUN sed -i 's|passwordQ1@|'${db_password}'|g' /tmp/src/main/resources/application.properties

RUN mvn package -Dmaven.test.skip=true

FROM openjdk:8-jdk-alpine
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/eschool.jar eschool.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "eschool.jar"]
