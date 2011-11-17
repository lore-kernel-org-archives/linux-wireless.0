Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43427 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab1KQVXg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 16:23:36 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: add support for kernel 3.2
Date: Thu, 17 Nov 2011 22:23:09 +0100
Message-Id: <1321564991-7249-1-git-send-email-hauke@hauke-m.de> (sfid-20111117_222341_875384_EA78EF4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds suport for kernel 3.2.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.2.h |   17 -----------------
 include/linux/compat-3.3.h |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/linux/compat-3.2.h b/include/linux/compat-3.2.h
index ceaaecc..db0f648 100644
--- a/include/linux/compat-3.2.h
+++ b/include/linux/compat-3.2.h
@@ -8,23 +8,6 @@
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
 
-/*
- * This is not part of The 2.6.37 kernel yet but we
- * we use it to optimize the backport code we
- * need to implement. Instead of using ifdefs
- * to check what version of the check we use
- * we just replace all checks on current code
- * with this. I'll submit this upstream too, that
- * way all we'd have to do is to implement this
- * for older kernels, then we would not have to
- * edit the upstrema code for backport efforts.
- */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
-#define br_port_exists(dev)	(dev->priv_flags & IFF_BRIDGE_PORT)
-#else
-#define br_port_exists(dev)	(dev->br_port)
-#endif
-
 #define PMSG_IS_AUTO(msg)	(((msg).event & PM_EVENT_AUTO) != 0)
 
 /**
diff --git a/include/linux/compat-3.3.h b/include/linux/compat-3.3.h
index 2e1e6d3..4e96ddc 100644
--- a/include/linux/compat-3.3.h
+++ b/include/linux/compat-3.3.h
@@ -8,6 +8,22 @@
 /* include to override NL80211_FEATURE_SK_TX_STATUS */
 #include <linux/nl80211.h>
 
+/*
+ * This is not part of The 2.6.37 kernel yet but we
+ * we use it to optimize the backport code we
+ * need to implement. Instead of using ifdefs
+ * to check what version of the check we use
+ * we just replace all checks on current code
+ * with this. I'll submit this upstream too, that
+ * way all we'd have to do is to implement this
+ * for older kernels, then we would not have to
+ * edit the upstrema code for backport efforts.
+ */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+#define br_port_exists(dev)	(dev->priv_flags & IFF_BRIDGE_PORT)
+#else
+#define br_port_exists(dev)	(dev->br_port)
+#endif
 
 static inline void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
 {
-- 
1.7.4.1

