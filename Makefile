DOCKER_NETWORK = hbase
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)
hadoop_branch := 2.0.0-hadoop3.3.1-java8
build_base:
	docker build -t zll5267/hbase-base:$(current_branch) ./base
build_hmaster:
	docker build -t zll5267/hbase-master:$(current_branch) ./hmaster
build_hregionserver:
	docker build -t zll5267/hbase-regionserver:$(current_branch) ./hregionserver
build_standalone:
	docker build -t zll5267/hbase-standalone:$(current_branch) ./standalone
build:
	docker build -t zll5267/hbase-base:$(current_branch) ./base
	docker build -t zll5267/hbase-master:$(current_branch) ./hmaster
	docker build -t zll5267/hbase-regionserver:$(current_branch) ./hregionserver
	docker build -t zll5267/hbase-standalone:$(current_branch) ./standalone

wordcount:
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} zll5267/hadoop-base:$(hadoop_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} zll5267/hadoop-base:$(hadoop_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-3.3.1/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} zll5267/hadoop-base:$(hadoop_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} zll5267/hadoop-base:$(hadoop_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} zll5267/hadoop-base:$(hadoop_branch) hdfs dfs -rm -r /input
