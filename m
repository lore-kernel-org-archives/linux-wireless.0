Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42623 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab1KXTsi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 14:48:38 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: add config var for CORDIC and CRC8
Date: Thu, 24 Nov 2011 20:48:33 +0100
Message-Id: <1322164113-22180-1-git-send-email-hauke@hauke-m.de> (sfid-20111124_204841_368304_5651759B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes the kernel version compat-wireless is build against has
support for cordic and crc8 in its source, but these modules where not
build when the kernel was build, because no one selected them. They are
needed for the bcmsmac driver and they should be build every time when
there is not an kernel module already.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/compat/Makefile b/compat/Makefile
index fc43ba1..1a3c977 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -34,7 +34,7 @@ compat-$(CONFIG_COMPAT_KERNEL_2_6_39) += \
 	compat-2.6.39.o \
 	kstrtox.o
 compat-$(CONFIG_COMPAT_KERNEL_3_0) += compat-3.0.o
-compat-$(CONFIG_COMPAT_KERNEL_3_1) += \
-	cordic.o \
-	crc8.o
+
+compat-$(CONFIG_COMPAT_CORDIC) += cordic.o
+compat-$(CONFIG_COMPAT_CRC8) += crc8.o
 
-- 
1.7.5.4

