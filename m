Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34028 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1LSVZT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:19 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 15/15] initvals: add script for regenerating ath9k header files
Date: Mon, 19 Dec 2011 22:25:00 +0100
Message-Id: <1324329900-3923-16-git-send-email-juhosg@openwrt.org> (sfid-20111219_222525_897774_3A177D88)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The script helps to regenerate initval header files for ath9k.

screenshot:
$ ./gen_ath9k_headers.sh ar5008
ar5008 => ar5008_initvals.h

$ ./gen_ath9k_headers.sh
ar5008 => ar5008_initvals.h
ar9001 => ar9001_initvals.h
ar9002 => ar9002_initvals.h
ar9003-2p2 => ar9003_2p2_initvals.h
ar9330-1p1 => ar9330_1p1_initvals.h
ar9330-1p2 => ar9330_1p2_initvals.h
ar9485 => ar9485_initvals.h
ar9580-1p0 => ar9580_1p0_initvals.h

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 gen_ath9k_headers.sh |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)
 create mode 100755 gen_ath9k_headers.sh

diff --git a/gen_ath9k_headers.sh b/gen_ath9k_headers.sh
new file mode 100755
index 0000000..fb7c313
--- /dev/null
+++ b/gen_ath9k_headers.sh
@@ -0,0 +1,36 @@
+#!/bin/sh
+
+gen_ath9k_header()
+{
+	local family="$1"
+	local ath9k_hdr
+
+	case $family in
+	ar5008 |\
+	ar9001 |\
+	ar9002 |\
+	ar9003-2p2|\
+	ar9330-1p1|\
+	ar9330-1p2|\
+	ar9485|\
+	ar9580-1p0)
+		ath9k_hdr="$(echo $family | tr '-' '_')_initvals.h"
+		;;
+	*)
+		echo "unknown family: '$family'" 1>&2
+		return 1
+		;;
+	esac
+	
+	echo "$family => $ath9k_hdr"
+	./initvals -w -f $family > "./$ath9k_hdr"
+}
+
+FAMILIES="$@"
+[ -z "$FAMILIES" ] && FAMILIES="ar5008 ar9001 ar9002 ar9003-2p2 ar9330-1p1 ar9330-1p2 ar9485 ar9580-1p0"
+
+make clean all ATHEROS=1 >/dev/null
+
+for family in $FAMILIES; do
+	gen_ath9k_header $family
+done
-- 
1.7.2.1

