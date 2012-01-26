Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51996 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab2AZWxG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 17:53:06 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: move br_port_exists() to compat-2.6.36.h
Date: Thu, 26 Jan 2012 23:51:45 +0100
Message-Id: <1327618305-23077-1-git-send-email-hauke@hauke-m.de> (sfid-20120126_235311_057961_DDCE51C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

br_port_exists() was moved to a new compat-*.h file for every new
kernel release, as it is not in mainline. This patch moves it to compat-
2.6.36.h so it has not to be moved any more for a new kernel version.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.36.h |   15 +++++++++++++++
 include/linux/compat-3.3.h    |   17 -----------------
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index b5d9975..314fb35 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -142,6 +142,8 @@ extern struct workqueue_struct *system_nrt_wq;
 void compat_system_workqueue_create(void);
 void compat_system_workqueue_destroy(void);
 
+#define br_port_exists(dev)	(dev->br_port)
+
 #else
 
 static inline void compat_system_workqueue_create(void)
@@ -152,6 +154,19 @@ static inline void compat_system_workqueue_destroy(void)
 {
 }
 
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
+#define br_port_exists(dev)	(dev->priv_flags & IFF_BRIDGE_PORT)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
diff --git a/include/linux/compat-3.3.h b/include/linux/compat-3.3.h
index 821333c..4965f23 100644
--- a/include/linux/compat-3.3.h
+++ b/include/linux/compat-3.3.h
@@ -8,23 +8,6 @@
 /* include to override NL80211_FEATURE_SK_TX_STATUS */
 #include <linux/nl80211.h>
 
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
 static inline void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
 {
 	WARN_ON(1);
-- 
1.7.5.4

