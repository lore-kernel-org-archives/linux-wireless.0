Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34750 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759925Ab2EKQj7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 12:39:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/6] atheros-initvals: remove the old script for generating ath9k headers
Date: Fri, 11 May 2012 18:39:52 +0200
Message-Id: <1336754396-30216-2-git-send-email-nbd@openwrt.org> (sfid-20120511_184019_361327_CE0C5A29)
In-Reply-To: <1336754396-30216-1-git-send-email-nbd@openwrt.org>
References: <1336754396-30216-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 gen_ath9k_headers.sh |   37 -------------------------------------
 1 files changed, 0 insertions(+), 37 deletions(-)
 delete mode 100755 gen_ath9k_headers.sh

diff --git a/gen_ath9k_headers.sh b/gen_ath9k_headers.sh
deleted file mode 100755
index b941b51..0000000
--- a/gen_ath9k_headers.sh
+++ /dev/null
@@ -1,37 +0,0 @@
-#!/bin/sh
-
-gen_ath9k_header()
-{
-	local family="$1"
-	local ath9k_hdr
-
-	case $family in
-	ar5008 |\
-	ar9001 |\
-	ar9002 |\
-	ar9003-2p2|\
-	ar9330-1p1|\
-	ar9330-1p2|\
-	ar9485|\
-	ar9580-1p0|\
-	ar9462-2p0)
-		ath9k_hdr="$(echo $family | tr '-' '_')_initvals.h"
-		;;
-	*)
-		echo "unknown family: '$family'" 1>&2
-		return 1
-		;;
-	esac
-
-	echo "$family => $ath9k_hdr"
-	./initvals -w -f $family > "./$ath9k_hdr"
-}
-
-FAMILIES="$@"
-[ -z "$FAMILIES" ] && FAMILIES="ar5008 ar9001 ar9002 ar9003-2p2 ar9330-1p1 ar9330-1p2 ar9485 ar9580-1p0 ar9462-2p0"
-
-make clean all ATHEROS=1 >/dev/null
-
-for family in $FAMILIES; do
-	gen_ath9k_header $family
-done
-- 
1.7.3.2

