Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54669 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab0IDPHO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Sep 2010 11:07:14 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/5] compat-wireless: fix for CONFIG_WIRELESS_EXT=n
Date: Sat,  4 Sep 2010 17:06:48 +0200
Message-Id: <1283612809-6798-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1283612809-6798-1-git-send-email-hauke@hauke-m.de>
References: <1283612809-6798-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some modules need CONFIG_WIRELESS_EXT to be set. They should not be
build if CONFIG_WIRELESS_EXT was not set.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index 3e09763..3fee3fe 100644
--- a/config.mk
+++ b/config.mk
@@ -253,6 +253,7 @@ CONFIG_LIBIPW=m
 # CONFIG_LIBIPW_DEBUG=y
 
 
+ifdef CONFIG_WIRELESS_EXT
 CONFIG_IPW2100=m
 CONFIG_IPW2100_MONITOR=y
 # CONFIG_IPW2100_DEBUG=y
@@ -274,6 +275,7 @@ CONFIG_IPW2200_QOS=y
 # it on via sysfs:
 #
 # % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
+endif #CONFIG_WIRELESS_EXT
 
 ifdef CONFIG_SSB
 # Sonics Silicon Backplane
@@ -331,6 +333,7 @@ else #CONFIG_COMPAT_KERNEL_27
 CONFIG_ATL1C=m
 endif #CONFIG_COMPAT_KERNEL_27
 
+ifdef CONFIG_WIRELESS_EXT
 CONFIG_HERMES=m
 CONFIG_HERMES_CACHE_FW_ON_INIT=y
 ifdef CONFIG_PPC_PMAC
@@ -344,6 +347,7 @@ ifdef CONFIG_PCMCIA
 CONFIG_PCMCIA_HERMES=m
 CONFIG_PCMCIA_SPECTRUM=m
 endif #CONFIG_PCMCIA
+endif #CONFIG_WIRELESS_EXT
 
 endif #CONFIG_PCI
 ## end of PCI
@@ -490,6 +494,7 @@ CONFIG_BT_HCIBTSDIO=m
 CONFIG_BT_MRVL_SDIO=m
 
 ifneq ($(CONFIG_COMPAT_STAGING),)
+ifdef CONFIG_WIRELESS_EXT
 CONFIG_ATH6KL_CFG80211=y
 CONFIG_ATH6KL_DEBUG=y
 # CONFIG_ATH6KL_DISABLE_TARGET_DBGLOGS is not set
@@ -501,6 +506,7 @@ CONFIG_ATH6KL_ENABLE_TARGET_DEBUG_PRINTS=y
 # CONFIG_ATH6KL_SKIP_ABI_VERSION_CHECK is not set
 CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
 CONFIG_ATH6K_LEGACY=m
+endif #CONFIG_WIRELESS_EXT
 endif #CONFIG_MMC
 
 
-- 
1.7.0.4

