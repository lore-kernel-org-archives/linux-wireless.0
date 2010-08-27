Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42139 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250Ab0H0SlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 14:41:16 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/7] compat-wireless: multiple changes to config file
Date: Fri, 27 Aug 2010 20:40:50 +0200
Message-Id: <1282934453-18093-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
References: <1282934453-18093-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 *	deactivate SPI drivers for kernel < 2.6.25 because linux/gpio.h
	is missing
 * 	CONFIG_WL1251 and CONFIG_WL1271 both need CRC7
 * 	CONFIG_RT2X00_LIB_LEDS does not work for kernel < 2.6.25
	because of missing blink_set

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/config.mk b/config.mk
index edfeca2..4c4a111 100644
--- a/config.mk
+++ b/config.mk
@@ -436,12 +436,12 @@ CONFIG_BT_ATH3K=m
 endif # end of USB driver list
 
 ifneq ($(CONFIG_SPI_MASTER),)
+ifndef CONFIG_COMPAT_KERNEL_25
 
-CONFIG_WL1251=m
 ifneq ($(CONFIG_CRC7),)
 CONFIG_WL1251_SPI=m
-endif
 CONFIG_WL1271_SPI=m
+endif
 CONFIG_P54_SPI=m
 
 ifdef CONFIG_COMPAT_KERNEL_27
@@ -452,18 +452,23 @@ CONFIG_LIBERTAS_SPI=m
 NEED_LIBERTAS=y
 endif
 
+endif
 endif # end of SPI driver list
 
 ifneq ($(CONFIG_MMC),)
 
 CONFIG_SSB_SDIOHOST=y
 CONFIG_B43_SDIO=y
+
+ifneq ($(CONFIG_CRC7),)
 CONFIG_WL1251_SDIO=m
 
 ifndef CONFIG_COMPAT_KERNEL_32
 CONFIG_WL1271_SDIO=m
 endif
 
+endif
+
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_SDIO=n
 NEED_LIBERTAS=n
@@ -488,7 +493,11 @@ CONFIG_RT2800_LIB=m
 CONFIG_RT2X00_LIB_HT=y
 CONFIG_RT2X00_LIB_FIRMWARE=y
 CONFIG_RT2X00_LIB_CRYPTO=y
+ifdef CONFIG_COMPAT_KERNEL_25
+CONFIG_RT2X00_LIB_LEDS=n
+else
 CONFIG_RT2X00_LIB_LEDS=y
+endif
 # CONFIG_RT2X00_DEBUG=y
 # CONFIG_RT2X00_LIB_DEBUGFS
 endif
@@ -506,8 +515,8 @@ CONFIG_ATH_COMMON=m
 # CONFIG_ATH_DEBUG=y
 
 CONFIG_WL12XX=y
-CONFIG_WL1251=m
 ifneq ($(CONFIG_CRC7),)
+CONFIG_WL1251=m
 CONFIG_WL1271=m
 endif
 
-- 
1.7.0.4

