Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46466 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab0DSUHG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 16:07:06 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	proski@gnu.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] compat: backport convert multicast list to list_head.
Date: Mon, 19 Apr 2010 22:06:55 +0200
Message-Id: <1271707616-4150-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <4BCCA1D9.30208@hauke-m.de>
References: <4BCCA1D9.30208@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.35.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index 964e8dc..4d3483a 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -4,6 +4,7 @@
 #include <linux/version.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
+#include <linux/etherdevice.h>
 
 #define IW_HANDLER(id, func)			\
 	[IW_IOCTL_IDX(id)] = func
@@ -11,6 +12,8 @@
 #define  SDIO_BUS_ECSI		0x20	/* Enable continuous SPI interrupt */
 #define  SDIO_BUS_SCSI		0x40	/* Support continuous SPI interrupt */
 
+#define netdev_hw_addr dev_mc_list
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
 
 #endif /* LINUX_26_35_COMPAT_H */
-- 
1.6.3.3

