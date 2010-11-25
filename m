Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52944 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab0KYOsp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 09:48:45 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/5] compat-wireless: correct rt2x00 config options
Date: Thu, 25 Nov 2010 15:48:34 +0100
Message-Id: <1290696517-20437-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1290696517-20437-1-git-send-email-hauke@hauke-m.de>
References: <1290696517-20437-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Do not add PCI IDs for not jet supported devices.
* remove some not included config options and add some newly introduced
options

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/config.mk b/config.mk
index ee20543..0f58320 100644
--- a/config.mk
+++ b/config.mk
@@ -312,10 +312,8 @@ CONFIG_RT2400PCI=m
 CONFIG_RT2500PCI=m
 ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800PCI=m
-CONFIG_RT2800PCI_PCI=y
-# CONFIG_RT2800PCI_RT30XX=y
+# CONFIG_RT2800PCI_RT33XX=y
 # CONFIG_RT2800PCI_RT35XX=y
-# CONFIG_RT2800PCI_SOC=y
 endif #CONFIG_CRC_CCITT
 NEED_RT2X00=y
 
@@ -324,7 +322,6 @@ NEED_RT2X00=y
 # driver as we're in the PCI section.
 ifdef CONFIG_CRC_ITU_T
 CONFIG_RT61PCI=m
-NEED_RT2X00_FIRMWARE=y
 endif #CONFIG_CRC_ITU_T
 
 CONFIG_MWL8K=m
@@ -435,8 +432,8 @@ CONFIG_ATH9K_HTC=m
 CONFIG_RT2500USB=m
 ifdef CONFIG_CRC_CCITT
 CONFIG_RT2800USB=m
-CONFIG_RT2800USB_RT30XX=y
-CONFIG_RT2800USB_RT35XX=y
+# CONFIG_RT2800USB_RT33XX=y
+# CONFIG_RT2800USB_RT35XX=y
 CONFIG_RT2800USB_UNKNOWN=y
 endif #CONFIG_CRC_CCITT
 CONFIG_RT2X00_LIB_USB=m
@@ -444,7 +441,6 @@ NEED_RT2X00=y
 # RT73USB requires firmware
 ifdef CONFIG_CRC_ITU_T
 CONFIG_RT73USB=m
-NEED_RT2X00_FIRMWARE=y
 endif #CONFIG_CRC_ITU_T
 
 ifdef CONFIG_COMPAT_KERNEL_27
@@ -550,6 +546,7 @@ CONFIG_RT2800_LIB=m
 CONFIG_RT2X00_LIB_HT=y
 CONFIG_RT2X00_LIB_FIRMWARE=y
 CONFIG_RT2X00_LIB_CRYPTO=y
+# CONFIG_RT2X00_LIB_SOC=y
 ifdef CONFIG_COMPAT_KERNEL_25
 CONFIG_RT2X00_LIB_LEDS=n
 else #CONFIG_COMPAT_KERNEL_25
@@ -559,10 +556,6 @@ endif #CONFIG_COMPAT_KERNEL_25
 # CONFIG_RT2X00_LIB_DEBUGFS
 endif
 
-ifeq ($(NEED_RT2X00_FIRMWARE),y)
-CONFIG_RT2X00_LIB_FIRMWARE=y
-endif
-
 # p54
 CONFIG_P54_COMMON=m
 CONFIG_P54_LEDS=y
-- 
1.7.1

