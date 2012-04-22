Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51646 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab2DVWDf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 18:03:35 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/7] compat-wireless: ath6kl: add config options for SDIO and USB
Date: Mon, 23 Apr 2012 00:03:16 +0200
Message-Id: <1335132199-21320-4-git-send-email-hauke@hauke-m.de> (sfid-20120423_000337_504030_7562C978)
In-Reply-To: <1335132199-21320-1-git-send-email-hauke@hauke-m.de>
References: <1335132199-21320-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl now supports USB and SDIO based devices, this patch adds the
config options for them.
---
 config.mk |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/config.mk b/config.mk
index d2373b9..a718257 100644
--- a/config.mk
+++ b/config.mk
@@ -265,6 +265,11 @@ export CONFIG_COMPAT_ATH9K_RATE_CONTROL=y
 
 export CONFIG_ATH9K_BTCOEX_SUPPORT=y
 
+ifndef CONFIG_COMPAT_KERNEL_2_6_27
+export CONFIG_ATH6KL=m
+# export CONFIG_ATH6KL_DEBUG=y
+endif #CONFIG_COMPAT_KERNEL_2_6_27
+
 # PCI Drivers
 ifdef CONFIG_PCI
 
@@ -502,6 +507,8 @@ export CONFIG_COMPAT_USB_URB_THREAD_FIX=y
 export CONFIG_ATH9K_HTC=m
 # export CONFIG_ATH9K_HTC_DEBUGFS=y
 
+export CONFIG_ATH6KL_USB=m
+
 export CONFIG_BRCMFMAC_USB=y
 
 # RT2500USB does not require firmware
@@ -588,10 +595,7 @@ export CONFIG_IWM=m
 export CONFIG_BT_HCIBTSDIO=m
 export CONFIG_BT_MRVL_SDIO=m
 
-ifndef CONFIG_COMPAT_KERNEL_2_6_27
-export CONFIG_ATH6KL=m
-# export CONFIG_ATH6KL_DEBUG=y
-endif #CONFIG_COMPAT_KERNEL_2_6_27
+export CONFIG_ATH6KL_SDIO=m
 
 export CONFIG_BRCMFMAC_SDIO=y
 
-- 
1.7.9.5

