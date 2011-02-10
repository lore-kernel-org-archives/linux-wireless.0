Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36785 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1BJP05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 10:26:57 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] compat-wireless: build zd1211rw only for kernel >= 2.6.29
Date: Thu, 10 Feb 2011 16:26:29 +0100
Message-Id: <1297351590-24019-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1297351590-24019-1-git-send-email-hauke@hauke-m.de>
References: <1297351590-24019-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd1211rw uses usb_queue_reset_device() which is not backported now.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index d8712e8..9a206d9 100644
--- a/config.mk
+++ b/config.mk
@@ -387,8 +387,12 @@ CONFIG_EEPROM_93CX6=m
 
 # USB Drivers
 ifdef CONFIG_USB
+ifndef CONFIG_COMPAT_KERNEL_29
 CONFIG_ZD1211RW=m
 # CONFIG_ZD1211RW_DEBUG=y
+else
+CONFIG_ZD1211RW=n
+endif #CONFIG_COMPAT_KERNEL_29
 
 # Sorry, rndis_wlan uses cancel_work_sync which is new and can't be done in compat...
 
-- 
1.7.1

