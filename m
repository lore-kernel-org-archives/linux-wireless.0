Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52032 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab2AZWzv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 17:55:51 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: fix some config options
Date: Thu, 26 Jan 2012 23:55:44 +0100
Message-Id: <1327618544-23163-1-git-send-email-hauke@hauke-m.de> (sfid-20120126_235555_289866_6BE25926)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds some missing config options interceded in the last time and remove
some old now unused config options.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/config.mk b/config.mk
index 4d2ad5c..9433ce9 100644
--- a/config.mk
+++ b/config.mk
@@ -281,6 +281,8 @@ CONFIG_ATH9K_COMMON=m
 # for long range considerations.
 CONFIG_ATH9K_RATE_CONTROL=y
 
+CONFIG_ATH9K_BTCOEX_SUPPORT=y
+
 # PCI Drivers
 ifdef CONFIG_PCI
 
@@ -288,10 +290,10 @@ CONFIG_ATH5K_PCI=y
 CONFIG_ATH9K_PCI=y
 
 CONFIG_IWLWIFI=m
+CONFIG_IWLWIFI_P2P=y
 # CONFIG_IWLWIFI_DEBUG=y
 # CONFIG_IWLWIFI_DEBUGFS=y
 # CONFIG_IWLWIFI_DEVICE_TRACING=y
-# CONFIG_IWLWIFI_DEVICE_SVTOOL=y
 # CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE=y
 
 CONFIG_IWLEGACY=m
@@ -314,7 +316,6 @@ CONFIG_B43_PHY_LP=y
 CONFIG_B43_PHY_N=y
 CONFIG_B43_PHY_HT=y
 # CONFIG_B43_PHY_LCN=y
-# CONFIG_B43_FORCE_PIO=y
 # CONFIG_B43_DEBUG=y
 
 CONFIG_B43LEGACY=m
@@ -375,7 +376,7 @@ CONFIG_BCMA_BLOCKIO=y
 CONFIG_BCMA_HOST_PCI=y
 # CONFIG_BCMA_DEBUG=y
 CONFIG_B43_BCMA=y
-CONFIG_B43_BCMA_PIO=y
+CONFIG_B43_BCMA_EXTRA=y
 
 CONFIG_P54_PCI=m
 
@@ -614,6 +615,7 @@ endif #CONFIG_COMPAT_KERNEL_2_6_27
 
 ifndef CONFIG_COMPAT_KERNEL_2_6_29
 CONFIG_BRCMFMAC=m
+CONFIG_BRCMFMAC_SDIO=y
 endif #CONFIG_COMPAT_KERNEL_2_6_29
 
 endif #CONFIG_MMC
-- 
1.7.5.4

