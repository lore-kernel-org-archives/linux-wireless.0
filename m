Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48332 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbZKZVbK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 16:31:10 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] [compat-2.6] add split mwl8k
Date: Thu, 26 Nov 2009 22:31:04 +0100
Message-Id: <1259271064-11298-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1259271064-11298-1-git-send-email-hauke@hauke-m.de>
References: <1259271064-11298-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk               |    7 +++++--
 scripts/admin-update.sh |    2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/config.mk b/config.mk
index e9e85d7..3ee9e53 100644
--- a/config.mk
+++ b/config.mk
@@ -155,7 +155,7 @@ CONFIG_ATH9K=m
 # CONFIG_ATH9K_COMMON to an area that doesn't depend on PCI
 # as you could then have ath9k disabled but ath9k_htc enabled.
 CONFIG_ATH9K_COMMON=m
-# CONFIG_ATH9K_DEBUG=y
+# CONFIG_ATH9K_DEBUGFS=y
 
 
 CONFIG_IWLWIFI=m
@@ -272,7 +272,10 @@ endif
 CONFIG_ATMEL=m
 CONFIG_PCI_ATMEL=m
 
-CONFIG_MWL8K=m
+CONFIG_MWL8K=y
+CONFIG_MWL8K_COMMON=m
+CONFIG_MWL8687=m
+CONFIG_MWL8366=m
 
 endif
 ## end of PCI
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index f85dacf..a6965a3 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -75,13 +75,13 @@ DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
 DRIVERS="$DRIVERS drivers/net/wireless/ipw2x00"
 DRIVERS="$DRIVERS drivers/net/wireless/wl12xx"
 DRIVERS="$DRIVERS drivers/net/wireless/iwmc3200wifi"
+DRIVERS="$DRIVERS drivers/net/wireless/mwl8k"
 
 # Drivers that belong the the wireless directory
 DRIVER_FILES="adm8211.c  adm8211.h"
 DRIVER_FILES="$DRIVER_FILES rndis_wlan.c"
 DRIVER_FILES="$DRIVER_FILES mac80211_hwsim.c"
 DRIVER_FILES="$DRIVER_FILES at76c50x-usb.c at76c50x-usb.h"
-DRIVER_FILES="$DRIVER_FILES mwl8k.c"
 
 mkdir -p include/linux/ include/net/ include/linux/usb \
 	include/linux/unaligned \
-- 
1.6.3.3

