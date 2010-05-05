Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49889 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab0EEW1s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 18:27:48 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: backport eth_change_mtu and eth_validate_addr
Date: Thu,  6 May 2010 00:27:37 +0200
Message-Id: <1273098457-21658-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.29.c        |   26 ++++++++++++++++++++++++++
 include/linux/compat-2.6.29.h |    2 ++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.29.c b/compat/compat-2.6.29.c
index 5ee1e44..8c725ee 100644
--- a/compat/compat-2.6.29.c
+++ b/compat/compat-2.6.29.c
@@ -98,6 +98,32 @@ int eth_mac_addr(struct net_device *dev, void *p)
 	return 0;
 }
 EXPORT_SYMBOL(eth_mac_addr);
+
+/**
+ * eth_change_mtu - set new MTU size
+ * @dev: network device
+ * @new_mtu: new Maximum Transfer Unit
+ *
+ * Allow changing MTU size. Needs to be overridden for devices
+ * supporting jumbo frames.
+ */
+int eth_change_mtu(struct net_device *dev, int new_mtu)
+{
+	if (new_mtu < 68 || new_mtu > ETH_DATA_LEN)
+		return -EINVAL;
+	dev->mtu = new_mtu;
+	return 0;
+}
+EXPORT_SYMBOL(eth_change_mtu);
+
+int eth_validate_addr(struct net_device *dev)
+{
+	if (!is_valid_ether_addr(dev->dev_addr))
+		return -EADDRNOTAVAIL;
+
+	return 0;
+}
+EXPORT_SYMBOL(eth_validate_addr);
 /* Source: net/ethernet/eth.c */
 
 
diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index 165b78c..f063e24 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -246,6 +246,8 @@ extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
 )
 
 extern int eth_mac_addr(struct net_device *dev, void *p);
+extern int eth_change_mtu(struct net_device *dev, int new_mtu);
+extern int eth_validate_addr(struct net_device *dev);
 
 #else
 
-- 
1.7.0.4

