Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37985 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbaFYUWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:22:04 -0400
Received: by mail-wi0-f175.google.com with SMTP id r20so8611403wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:22:02 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 34/34] staging: vt6656: remove unneeded config and headers
Date: Wed, 25 Jun 2014 21:20:11 +0100
Message-Id: <1403727611-6825-35-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223003_830552_318E20EF)
In-Reply-To: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
References: <1403727611-6825-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove WIRELESS_EXT and WEXT_PRIV

remove net/iw_handler.h, linux/etherdevice.h and net/cfg80211.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/Kconfig  | 2 --
 drivers/staging/vt6656/device.h | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/drivers/staging/vt6656/Kconfig b/drivers/staging/vt6656/Kconfig
index 839db3a..b602ef1 100644
--- a/drivers/staging/vt6656/Kconfig
+++ b/drivers/staging/vt6656/Kconfig
@@ -1,8 +1,6 @@
 config VT6656
 	tristate "VIA Technologies VT6656 support"
 	depends on MAC80211 && USB && WLAN && m
-	select WIRELESS_EXT
-	select WEXT_PRIV
 	select FW_LOADER
 	---help---
 	This is a vendor-written driver for VIA VT6656.
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 9d4c5e7..0bba96f 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -35,12 +35,9 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
-#include <linux/etherdevice.h>
 #include <linux/suspend.h>
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
-#include <net/iw_handler.h>
-#include <net/cfg80211.h>
 #include <linux/timer.h>
 #include <linux/usb.h>
 #include <linux/crc32.h>
-- 
1.9.1

