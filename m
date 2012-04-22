Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51658 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab2DVWDj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 18:03:39 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/7] compat-wireless: brcmfmac: add usb config option
Date: Mon, 23 Apr 2012 00:03:15 +0200
Message-Id: <1335132199-21320-3-git-send-email-hauke@hauke-m.de> (sfid-20120423_000341_392122_00A2CE81)
In-Reply-To: <1335132199-21320-1-git-send-email-hauke@hauke-m.de>
References: <1335132199-21320-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This activates the usb part of brcmfmac.
---
 config.mk |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/config.mk b/config.mk
index 012a59f..d2373b9 100644
--- a/config.mk
+++ b/config.mk
@@ -502,6 +502,8 @@ export CONFIG_COMPAT_USB_URB_THREAD_FIX=y
 export CONFIG_ATH9K_HTC=m
 # export CONFIG_ATH9K_HTC_DEBUGFS=y
 
+export CONFIG_BRCMFMAC_USB=y
+
 # RT2500USB does not require firmware
 export CONFIG_RT2500USB=m
 ifdef CONFIG_CRC_CCITT
@@ -591,10 +593,7 @@ export CONFIG_ATH6KL=m
 # export CONFIG_ATH6KL_DEBUG=y
 endif #CONFIG_COMPAT_KERNEL_2_6_27
 
-ifndef CONFIG_COMPAT_KERNEL_2_6_29
-export CONFIG_BRCMFMAC=m
 export CONFIG_BRCMFMAC_SDIO=y
-endif #CONFIG_COMPAT_KERNEL_2_6_29
 
 endif #CONFIG_MMC
 
@@ -633,6 +632,10 @@ export CONFIG_ATH_COMMON=m
 export CONFIG_BRCMUTIL=m
 # export CONFIG_BRCMDBG=y
 
+ifndef CONFIG_COMPAT_KERNEL_2_6_29
+export CONFIG_BRCMFMAC=m
+endif #CONFIG_COMPAT_KERNEL_2_6_29
+
 export CONFIG_WL_TI=y
 export CONFIG_WLCORE=m
 
-- 
1.7.9.5

