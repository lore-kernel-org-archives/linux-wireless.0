Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34994 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbZLZVot (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Dec 2009 16:44:49 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: Backport eth_mac_addr
Date: Sat, 26 Dec 2009 22:44:35 +0100
Message-Id: <1261863875-2730-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1261863875-2730-1-git-send-email-hauke@hauke-m.de>
References: <1261863875-2730-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

eth_mac_addr is needed by net/mac80211/iface.c

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.29.c        |   24 ++++++++++++++++++++++++
 include/linux/compat-2.6.29.h |    2 ++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.29.c b/compat/compat-2.6.29.c
index 669ad35..ea2a991 100644
--- a/compat/compat-2.6.29.c
+++ b/compat/compat-2.6.29.c
@@ -13,6 +13,7 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
 
 #include <linux/usb.h>
+#include <linux/etherdevice.h>
 
 /**
  * usb_unpoison_anchored_urbs - let an anchor be used successfully again
@@ -35,6 +36,29 @@ void usb_unpoison_anchored_urbs(struct usb_anchor *anchor)
 }
 EXPORT_SYMBOL_GPL(usb_unpoison_anchored_urbs);
 
+/**
+ * eth_mac_addr - set new Ethernet hardware address
+ * @dev: network device
+ * @p: socket address
+ * Change hardware address of device.
+ *
+ * This doesn't change hardware matching, so needs to be overridden
+ * for most real devices.
+ */
+int eth_mac_addr(struct net_device *dev, void *p)
+{
+	struct sockaddr *addr = p;
+
+	if (netif_running(dev))
+		return -EBUSY;
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
+	return 0;
+}
+EXPORT_SYMBOL(eth_mac_addr);
+/* Source: net/ethernet/eth.c */
+
 
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29) */
 
diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index 8a968fa..690fb93 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -55,6 +55,8 @@ extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
 }							\
 )
 
+extern int eth_mac_addr(struct net_device *dev, void *p);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
 
 #endif /*  LINUX_26_29_COMPAT_H */
-- 
1.6.3.3

