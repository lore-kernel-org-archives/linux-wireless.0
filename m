Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55820 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002Ab0JWSOU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 14:14:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: add empty implementation for usb_enable_autosuspend
Date: Sat, 23 Oct 2010 20:14:01 +0200
Message-Id: <1287857641-7882-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1287857641-7882-1-git-send-email-hauke@hauke-m.de>
References: <1287857641-7882-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by drivers/bluetooth/btusb.c

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.34.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 763abca..93fc4ef 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -6,6 +6,7 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34))
 
 #include <linux/netdevice.h>
+#include <linux/usb.h>
 
 #define netdev_mc_count(dev) ((dev)->mc_count)
 #define netdev_mc_empty(dev) (netdev_mc_count(dev) == 0)
@@ -236,6 +237,12 @@ static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
 	return 0;
 }
 
+/* USB autosuspend and autoresume */
+static inline int usb_enable_autosuspend(struct usb_device *udev)
+{ return 0; }
+static inline int usb_disable_autosuspend(struct usb_device *udev)
+{ return 0; }
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
 #endif /* LINUX_26_34_COMPAT_H */
-- 
1.7.0.4

