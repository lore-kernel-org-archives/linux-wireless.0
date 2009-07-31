Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57041 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbZGaSwf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:52:35 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] [compat-2.6] Fix building on 2.6.31
Date: Fri, 31 Jul 2009 20:52:29 +0200
Message-Id: <1249066349-24956-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The netdevice.h header file should be loaded before dev_change_net_namespace is overwritten.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.32.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.32.h b/compat/compat-2.6.32.h
index 4f5d0c7..f7081f2 100644
--- a/compat/compat-2.6.32.h
+++ b/compat/compat-2.6.32.h
@@ -7,6 +7,8 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
 
+#include <linux/netdevice.h>
+
 #define SDIO_VENDOR_ID_INTEL			0x0089
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIFI	0x1403
-- 
1.6.2.1

