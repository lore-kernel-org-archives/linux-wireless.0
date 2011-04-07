Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52674 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1DGOkN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 10:40:13 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: integrate kfifo into compat.ko
Date: Thu,  7 Apr 2011 16:39:16 +0200
Message-Id: <1302187158-15298-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/compat/Makefile b/compat/Makefile
index f87b024..f92ac34 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -2,7 +2,6 @@ obj-m += compat.o
 #compat-objs :=
 
 obj-$(CONFIG_COMPAT_FIRMWARE_CLASS) += compat_firmware_class.o
-obj-$(CONFIG_COMPAT_KFIFO) += kfifo.o
 
 compat-y += main.o
 
@@ -14,7 +13,6 @@ compat-$(CONFIG_COMPAT_KERNEL_21) += compat-2.6.21.o
 compat-$(CONFIG_COMPAT_KERNEL_22) += compat-2.6.22.o
 compat-$(CONFIG_COMPAT_KERNEL_23) += compat-2.6.23.o
 compat-$(CONFIG_COMPAT_KERNEL_24) += compat-2.6.24.o
-
 compat-$(CONFIG_COMPAT_KERNEL_25) += \
 	compat-2.6.25.o \
 	pm_qos_params.o
@@ -26,7 +24,10 @@ compat-$(CONFIG_COMPAT_KERNEL_29) += compat-2.6.29.o
 compat-$(CONFIG_COMPAT_KERNEL_32) += compat-2.6.32.o
 compat-$(CONFIG_COMPAT_KERNEL_33) += compat-2.6.33.o
 compat-$(CONFIG_COMPAT_KERNEL_35) += compat-2.6.35.o
-compat-$(CONFIG_COMPAT_KERNEL_36) += compat-2.6.36.o
+compat-$(CONFIG_COMPAT_KERNEL_36) += \
+	compat-2.6.36.o \
+	kfifo.o
+
 compat-$(CONFIG_COMPAT_KERNEL_37) += compat-2.6.37.o
 compat-$(CONFIG_COMPAT_KERNEL_38) += compat-2.6.38.o
 compat-$(CONFIG_COMPAT_KERNEL_39) += compat-2.6.39.o
-- 
1.7.1

