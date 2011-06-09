Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33100 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751Ab1FIWEY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 18:04:24 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, jonas.gorski@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 11/11] compat-wireless: add bcma
Date: Fri, 10 Jun 2011 00:03:42 +0200
Message-Id: <1307657022-23808-12-git-send-email-hauke@hauke-m.de> (sfid-20110610_000438_212324_52959788)
In-Reply-To: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
References: <1307657022-23808-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Makefile                    |    2 +-
 config.mk                   |    5 +++++
 defconfigs/atheros-debug.mk |    5 +++++
 scripts/admin-update.sh     |    3 +++
 4 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 9e97b50..9c95292 100644
--- a/Makefile
+++ b/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_COMPAT_WIRELESS_MODULES) += drivers/net/wireless/
 obj-$(CONFIG_COMPAT_NET_USB_MODULES) += drivers/net/usb/
 
 obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/
-obj-$(CONFIG_COMPAT_VAR_MODULES) +=  drivers/ssb/ drivers/misc/eeprom/
+obj-$(CONFIG_COMPAT_VAR_MODULES) +=  drivers/ssb/ drivers/bcma/ drivers/misc/eeprom/
 
 ifeq ($(CONFIG_STAGING_EXCLUDE_BUILD),)
 obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/ath6kl/
diff --git a/config.mk b/config.mk
index da1ebeb..0692c6e 100644
--- a/config.mk
+++ b/config.mk
@@ -325,6 +325,11 @@ endif #CONFIG_PCMCIA
 CONFIG_SSB_DRIVER_PCICORE=y
 endif #CONFIG_SSB
 
+CONFIG_BCMA=m
+CONFIG_BCMA_BLOCKIO=y
+CONFIG_BCMA_HOST_PCI=y
+# CONFIG_BCMA_DEBUG=y
+
 CONFIG_P54_PCI=m
 
 CONFIG_B44=m
diff --git a/defconfigs/atheros-debug.mk b/defconfigs/atheros-debug.mk
index fb884aa..285b231 100644
--- a/defconfigs/atheros-debug.mk
+++ b/defconfigs/atheros-debug.mk
@@ -325,6 +325,11 @@ endif #CONFIG_PCMCIA
 CONFIG_SSB_DRIVER_PCICORE=y
 endif #CONFIG_SSB
 
+CONFIG_BCMA=m
+CONFIG_BCMA_BLOCKIO=y
+CONFIG_BCMA_HOST_PCI=y
+# CONFIG_BCMA_DEBUG=y
+
 CONFIG_P54_PCI=m
 
 CONFIG_B44=m
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index df7056e..7b2d1f8 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -220,6 +220,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/ath/carl9170"
 DRIVERS="$DRIVERS drivers/net/wireless/ath/ath5k"
 DRIVERS="$DRIVERS drivers/net/wireless/ath/ath9k"
 DRIVERS="$DRIVERS drivers/ssb"
+DRIVERS="$DRIVERS drivers/bcma"
 DRIVERS="$DRIVERS drivers/net/wireless/b43"
 DRIVERS="$DRIVERS drivers/net/wireless/b43legacy"
 DRIVERS="$DRIVERS drivers/net/wireless/iwlegacy"
@@ -273,6 +274,7 @@ mkdir -p include/linux/ include/net/ include/linux/usb \
 	net/mac80211/ net/wireless/ \
 	net/rfkill/ \
 	drivers/ssb/ \
+	drivers/bcma/ \
 	drivers/net/usb/ \
 	drivers/net/wireless/
 mkdir -p include/net/bluetooth/
@@ -285,6 +287,7 @@ for i in $INCLUDE_LINUX; do
 done
 
 cp -a $GIT_TREE/include/linux/ssb include/linux/
+cp -a $GIT_TREE/include/linux/bcma include/linux/
 cp -a $GIT_TREE/include/linux/rfkill.h include/linux/rfkill_backport.h
 
 # include/net
-- 
1.7.4.1

