Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52034 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762658Ab0HGNfB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 09:35:01 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: activate more bluetooth drivers
Date: Sat,  7 Aug 2010 15:34:44 +0200
Message-Id: <1281188084-7232-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1281188084-7232-1-git-send-email-hauke@hauke-m.de>
References: <1281188084-7232-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/config.mk b/config.mk
index 733ea33..777ebd3 100644
--- a/config.mk
+++ b/config.mk
@@ -154,14 +154,33 @@ CONFIG_BT=m
 CONFIG_BT_L2CAP=m
 CONFIG_BT_SCO=m
 CONFIG_BT_RFCOMM=m
+CONFIG_BT_RFCOMM_TTY=y
 CONFIG_BT_BNEP=m
-CONFIG_BT_ATH3K=m
+CONFIG_BT_BNEP_MC_FILTER=y
+CONFIG_BT_BNEP_PROTO_FILTER=y
 # CONFIG_BT_CMTP depends on ISDN_CAPI
-ifneq ($(CONFIG_BT_CMTP),)
+ifneq ($(CONFIG_ISDN_CAPI),)
 CONFIG_BT_CMTP=m
 endif
 CONFIG_BT_HIDP=m
 
+CONFIG_BT_HCIUART=M
+CONFIG_BT_HCIUART_H4=y
+CONFIG_BT_HCIUART_BCSP=y
+CONFIG_BT_HCIUART_ATH3K=y
+CONFIG_BT_HCIUART_LL=y
+
+CONFIG_BT_HCIVHCI=m
+CONFIG_BT_MRVL=m
+
+ifneq ($(CONFIG_PCMCIA),)
+CONFIG_BT_HCIDTL1=m
+CONFIG_BT_HCIBT3C=m
+CONFIG_BT_HCIBLUECARD=m
+CONFIG_BT_HCIBTUART=m
+endif
+
+
 # CONFIG_CFG80211_WEXT will be resepected for
 # future kernels but for older kenrels we need
 # to enable it against the the old CONFIG_WIRELESS_EXT.
@@ -192,6 +211,7 @@ CONFIG_ATH9K=m
 # as you could then have ath9k disabled but ath9k_htc enabled.
 CONFIG_ATH9K_COMMON=m
 # CONFIG_ATH9K_DEBUGFS=y
+# CONFIG_ATH9K_PKTLOG=y
 
 
 CONFIG_IWLWIFI=m
@@ -377,6 +397,7 @@ CONFIG_AR9170_LEDS=y
 endif
 
 CONFIG_ATH9K_HTC=m
+# CONFIG_ATH9K_HTC_DEBUGFS=y
 
 # RT2500USB does not require firmware
 CONFIG_RT2500USB=m
@@ -406,6 +427,12 @@ endif
 
 CONFIG_ORINOCO_USB=m
 
+CONFIG_BT_HCIBTUSB=m
+CONFIG_BT_HCIBCM203X=m
+CONFIG_BT_HCIBPA10X=m
+CONFIG_BT_HCIBFUSB=m
+CONFIG_BT_ATH3K=m
+
 endif # end of USB driver list
 
 ifneq ($(CONFIG_SPI_MASTER),)
@@ -448,6 +475,9 @@ endif
 CONFIG_IWM=m
 # CONFIG_IWM_DEBUG=y
 
+CONFIG_BT_HCIBTSDIO=m
+CONFIG_BT_MRVL_SDIO=m
+
 endif # end of SDIO driver list
 
 # Common rt2x00 requirements
-- 
1.7.0.4

