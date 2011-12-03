Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50384 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab1LCOtd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Dec 2011 09:49:33 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: add config var for CORDIC and CRC8
Date: Sat,  3 Dec 2011 15:49:25 +0100
Message-Id: <1322923766-14379-1-git-send-email-hauke@hauke-m.de> (sfid-20111203_154936_601231_3081CC76)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes the kernel version compat-wireless is build against has
support for cordic and crc8 in its source, but these modules were not
build when the kernel was build, because no one selected them. The modules are
needed for the bcmsmac driver and they should be build every time when
they were not already build while the kernel was build.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/compat/Makefile b/compat/Makefile
index 9e4db44..fa9c6cb 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -34,9 +34,9 @@ compat-$(CONFIG_COMPAT_KERNEL_2_6_39) += \
 	compat-2.6.39.o \
 	kstrtox.o
 compat-$(CONFIG_COMPAT_KERNEL_3_0) += compat-3.0.o
-compat-$(CONFIG_COMPAT_KERNEL_3_1) += \
-	cordic.o \
-	crc8.o
+
+compat-$(CONFIG_COMPAT_CORDIC) += cordic.o
+compat-$(CONFIG_COMPAT_CRC8) += crc8.o
 
 ifndef CONFIG_64BIT
 ifndef CONFIG_GENERIC_ATOMIC64
-- 
1.7.5.4

