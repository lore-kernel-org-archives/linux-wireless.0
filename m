Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39693 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab1BHVgl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 16:36:41 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: build zd1211rw only for kernel >= 2.6.29
Date: Tue,  8 Feb 2011 22:36:21 +0100
Message-Id: <1297200981-22971-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1297200981-22971-1-git-send-email-hauke@hauke-m.de>
References: <1297200981-22971-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd1211rw uses usb_queue_reset_device() which is not backported now.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index 7c337bb..ad05a3d 100644
--- a/config.mk
+++ b/config.mk
@@ -387,8 +387,10 @@ CONFIG_EEPROM_93CX6=m
 
 # USB Drivers
 ifdef CONFIG_USB
+ifndef CONFIG_COMPAT_KERNEL_29
 CONFIG_ZD1211RW=m
 # CONFIG_ZD1211RW_DEBUG=y
+endif #CONFIG_COMPAT_KERNEL_29
 
 # Sorry, rndis_wlan uses cancel_work_sync which is new and can't be done in compat...
 
-- 
1.7.1

