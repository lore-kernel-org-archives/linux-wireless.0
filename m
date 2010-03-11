Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47386 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab0CKVdO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 16:33:14 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/5] compat-wireless: update config symbols
Date: Thu, 11 Mar 2010 22:32:47 +0100
Message-Id: <1268343167-2961-8-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
References: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove some not used config symbols and add some new ones

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/config.mk b/config.mk
index 431940e..357cae9 100644
--- a/config.mk
+++ b/config.mk
@@ -110,7 +110,6 @@ endif
 CONFIG_MAC80211=m
 
 # CONFIG_MAC80211_DEBUGFS=y
-# CONFIG_MAC80211_DEBUG_MENU=y
 # CONFIG_MAC80211_NOINLINE=y
 # CONFIG_MAC80211_VERBOSE_DEBUG=y
 # CONFIG_MAC80211_HT_DEBUG=y
@@ -150,8 +149,6 @@ CONFIG_LIB80211_CRYPT_CCMP=m
 CONFIG_LIB80211_CRYPT_TKIP=m
 # CONFIG_LIB80211_DEBUG=y
 
-CONFIG_WIRELESS_OLD_REGULATORY=n
-
 CONFIG_BT=m
 CONFIG_BT_L2CAP=m
 CONFIG_BT_SCO=m
@@ -217,6 +214,7 @@ endif
 CONFIG_B43_LEDS=y
 CONFIG_B43_PHY_LP=y
 CONFIG_B43_NPHY=y
+# CONFIG_B43_FORCE_PIO=y
 # CONFIG_B43_DEBUG=y
 
 CONFIG_B43LEGACY=m
@@ -284,6 +282,9 @@ CONFIG_RT2500PCI=m
 ifneq ($(CONFIG_CRC_CCITT),)
 CONFIG_RT2800PCI=m
 CONFIG_RT2800PCI_PCI=y
+# CONFIG_RT2800PCI_RT30XX=y
+# CONFIG_RT2800PCI_RT35XX=y
+# CONFIG_RT2800PCI_SOC=y
 endif
 NEED_RT2X00=y
 
@@ -376,6 +377,9 @@ endif
 CONFIG_RT2500USB=m
 ifneq ($(CONFIG_CRC_CCITT),)
 CONFIG_RT2800USB=m
+# CONFIG_RT2800USB_RT30XX=y
+# CONFIG_RT2800USB_RT35XX=y
+# CONFIG_RT2800USB_UNKNOWN=y
 endif
 CONFIG_RT2X00_LIB_USB=m
 NEED_RT2X00=y
@@ -403,6 +407,7 @@ CONFIG_WL1251=m
 ifneq ($(CONFIG_CRC7),)
 CONFIG_WL1251_SPI=m
 endif
+CONFIG_WL1271_SPI=m
 CONFIG_P54_SPI=m
 
 ifdef CONFIG_COMPAT_KERNEL_27
@@ -421,6 +426,10 @@ CONFIG_SSB_SDIOHOST=y
 CONFIG_B43_SDIO=y
 CONFIG_WL1251_SDIO=m
 
+ifneq ($(CONFIG_ARM),)
+CONFIG_WL1271_SDIO=m
+endif
+
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_SDIO=n
 NEED_LIBERTAS=n
-- 
1.6.3.3

