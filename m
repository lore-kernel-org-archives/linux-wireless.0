Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57259 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbZEQMry (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 08:47:54 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, stecklum@tls-tautenburg.de,
	me@bobcopeland.com, breusshe@hotmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] compat-2.6: Add libertas_spi module.
Date: Sun, 17 May 2009 14:47:42 +0200
Message-Id: <1242564463-9120-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1242564463-9120-1-git-send-email-hauke@hauke-m.de>
References: <1242564463-9120-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up libertas stuff in config.mk

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk               |   35 +++++++++++++++++++++++------------
 scripts/admin-update.sh |    2 +-
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/config.mk b/config.mk
index f94b37b..0a2cbb3 100644
--- a/config.mk
+++ b/config.mk
@@ -235,6 +235,14 @@ CONFIG_MWL8K=m
 endif
 ## end of PCI
 
+ifneq ($(CONFIG_PCMCIA),)
+
+CONFIG_LIBERTAS_CS=m
+NEED_LIBERTAS=y
+
+endif
+## end of PCMCIA
+
 # This is required for some cards
 CONFIG_EEPROM_93CX6=m
 
@@ -278,14 +286,27 @@ CONFIG_RT73USB=m
 NEED_RT2X00_FIRMWARE=y
 endif
 
+CONFIG_LIBERTAS_THINFIRM_USB=m
+CONFIG_LIBERTAS_USB=m
+NEED_LIBERTAS=y
+
 endif # end of USB driver list
 
 ifneq ($(CONFIG_SPI_MASTER),)
 
 CONFIG_WL12XX=m
+CONFIG_LIBERTAS_SPI=m
+NEED_LIBERTAS=y
 
 endif # end of SPI driver list
 
+ifneq ($(CONFIG_MMC),)
+
+CONFIG_LIBERTAS_SDIO=m
+NEED_LIBERTAS=y
+
+endif # end of SDIO driver list
+
 # Common rt2x00 requirements
 ifeq ($(NEED_RT2X00),y)
 CONFIG_RT2X00=m
@@ -317,19 +338,9 @@ CONFIG_SSB=m
 CONFIG_SSB_SPROM=y
 # CONFIG_SSB_DEBUG=y
 
-ifneq ($(CONFIG_USB),)
-ifneq ($(CONFIG_LIBERTAS_THINFIRM_USB),m)
-CONFIG_LIBERTAS_USB=m
-NEED_LIBERTAS=y
-endif
-endif
-ifneq ($(CONFIG_PCMCIA),)
-CONFIG_LIBERTAS_CS=m
-NEED_LIBERTAS=y
-endif
 ifeq ($(NEED_LIBERTAS),y)
+CONFIG_LIBERTAS_THINFIRM=m
 CONFIG_LIBERTAS=m
-# Libertas uses the old stack but not fully, it will soon 
-# be cleaned.
+# CONFIG_LIBERTAS_DEBUG=y
 endif
 
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 1616844..ae42894 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -24,7 +24,7 @@ INCLUDE_LINUX="$INCLUDE_LINUX ath9k_platform.h"
 # For rndis_wext
 INCLUDE_LINUX_USB="usbnet.h rndis_host.h"
 
-INCLUDE_LINUX_SPI="wl12xx.h"
+INCLUDE_LINUX_SPI="wl12xx.h libertas_spi.h"
 
 # The good new yummy stuff
 INCLUDE_NET="cfg80211.h ieee80211_radiotap.h iw_handler.h"
-- 
1.6.2.1

