Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36395 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbZDPTXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 15:23:52 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] [compat-2.6] Add include/linux/mmc/sdio_ids.h
Date: Thu, 16 Apr 2009 21:23:41 +0200
Message-Id: <1239909821-18401-1-git-send-email-hauke@hauke-m.de> (sfid-20090416_212357_686606_5F292D08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The libertas driver needs some definitions out of sdio_ids.h.
Without this it will not compile on kernel 2.6.27 to 2.6.29.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 46ba4d5..2f4d31b 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -24,6 +24,8 @@ INCLUDE_LINUX="$INCLUDE_LINUX ath9k_platform.h"
 # For rndis_wext
 INCLUDE_LINUX_USB="usbnet.h rndis_host.h"
 
+INCLUDE_LINUX_MMC="sdio_ids.h"
+
 # The good new yummy stuff
 INCLUDE_NET="cfg80211.h ieee80211_radiotap.h iw_handler.h"
 INCLUDE_NET="$INCLUDE_NET mac80211.h wext.h wireless.h lib80211.h"
@@ -70,7 +72,7 @@ DRIVER_FILES="$DRIVER_FILES at76c50x-usb.c at76c50x-usb.h"
 DRIVER_FILES="$DRIVER_FILES mwl8k.c"
 
 mkdir -p include/linux/ include/net/ include/linux/usb \
-	include/linux/unaligned \
+	include/linux/unaligned include/linux/mmc \
 	net/mac80211/ net/wireless/ \
 	drivers/ssb/ \
 	drivers/net/usb/ \
@@ -98,6 +100,12 @@ for i in $INCLUDE_LINUX_USB; do
 	cp $GIT_TREE/$DIR/$i $DIR/
 done
 
+DIR="include/linux/mmc"
+for i in $INCLUDE_LINUX_MMC; do
+	echo "Copying $GIT_TREE/$DIR/$i"
+	cp $GIT_TREE/$DIR/$i $DIR/
+done
+
 # net/wireless and net/mac80211
 for i in $NET_DIRS; do
 	echo "Copying $GIT_TREE/net/$i/*.[ch]"
-- 
1.6.2.1

