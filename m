Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51143 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab1LSVZo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:44 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 14/15] initvals: add a script for simplifying checksum verification
Date: Mon, 19 Dec 2011 22:24:59 +0100
Message-Id: <1324329900-3923-15-git-send-email-juhosg@openwrt.org> (sfid-20111219_222549_958719_376B52B3)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The script helps to verify checksum values between the
atheros and ath9k initvals.

screenshot:
./verify_checksums.sh
ar5008         12f508dd13320697291eacdd276888188ff0bd1c pass
ar9001         b3489b0d3d7e5a20496a133cc36a1c47e42b28f4 pass
ar9002         908154dbc2a659809a32a23f3ee124afd5d20901 pass
ar9003-2p2     52159266be9751dd2fac9e47c92bb3507c5d5a1d pass
ar9330-1p1     3ce64df7a3121eab71a13ba9c8e9d9075ab9bae5 pass
ar9330-1p2     0b90668b470a08b3ae3c24fb3924c7d4401debe7 pass
ar9485         1d4011e162d8349a0b4f2a9dfab86e306ad33cc0 pass
ar9580-1p0     2364145b178ff42b8c5b14879feabd3cda2ca4d3 pass

$ ./verify_checksums.sh  ar5008
ar5008         12f508dd13320697291eacdd276888188ff0bd1c pass
$ vi ar5416.ini
$ ./verify_checksums.sh  ar5008
ar5008         b0df6fd03e1c677d9701524a8eed46d02497ef3d fail
+0x00000000aa44d980        ar5416Modes
+0x000000004d845983        ar5416Common
+0x00000000009fa667        ar5416Addac
$

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 verify_checksums.sh |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100755 verify_checksums.sh

diff --git a/verify_checksums.sh b/verify_checksums.sh
new file mode 100755
index 0000000..88915e4
--- /dev/null
+++ b/verify_checksums.sh
@@ -0,0 +1,40 @@
+#!/bin/sh
+
+CSUM_DIR=".tmp_checksum"
+get_family_checksum()
+{
+	local family="$1"
+	local suffix="$2"
+	local flag
+
+	[ "$suffix" == "hal" ] && flag="ATHEROS=1"
+
+	make clean all $flag >/dev/null
+	./initvals -f $family > "$CSUM_DIR/${family}_$suffix.txt"
+	./initvals -f $family | sha1sum | sed -e 's/[ -]//g'
+}
+
+verify_family_checksum()
+{
+	local family="$1"
+	local sum_hal
+	local sum_ath9k
+	local res
+
+	sum_hal=$(get_family_checksum $family hal)
+	sum_ath9k=$(get_family_checksum $family ath9k)
+
+	[ "$sum_hal" == "$sum_ath9k" ] && res="pass" || res="fail"
+	printf "%-14s %-40s %s\n" "$family" "$sum_hal" "$res"
+	[ "$res" == "fail" ] && \
+		diff -Nurw "$CSUM_DIR/${family}_hal.txt" "$CSUM_DIR/${family}_ath9k.txt" | grep '^+0'
+}
+
+FAMILIES="$@"
+[ -z "$FAMILIES" ] && FAMILIES="ar5008 ar9001 ar9002 ar9003-2p2 ar9330-1p1 ar9330-1p2 ar9485 ar9580-1p0"
+
+mkdir -p "$CSUM_DIR"
+for family in $FAMILIES; do
+	verify_family_checksum $family
+done
+rm -rf "$CSUM_DIR"
-- 
1.7.2.1

