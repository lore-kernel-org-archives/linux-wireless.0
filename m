Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36897 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab0BUOcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2010 09:32:25 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: backport some more of the netdev debug printk
Date: Sun, 21 Feb 2010 15:32:18 +0100
Message-Id: <1266762738-6516-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.34.h |   74 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 4229a22..b5d1903 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -63,6 +63,80 @@ do {								\
 	0;							\
 })
 #endif
+
+#if defined(VERBOSE_DEBUG)
+#define netdev_vdbg	netdev_dbg
+#else
+
+#define netdev_vdbg(dev, format, args...)			\
+({								\
+	if (0)							\
+		netdev_printk(KERN_DEBUG, dev, format, ##args);	\
+	0;							\
+})
+#endif
+
+/*
+ * netdev_WARN() acts like dev_printk(), but with the key difference
+ * of using a WARN/WARN_ON to get the message out, including the
+ * file/line information and a backtrace.
+ */
+#define netdev_WARN(dev, format, args...)			\
+	WARN(1, "netdevice: %s\n" format, netdev_name(dev), ##args);
+
+/* netif printk helpers, similar to netdev_printk */
+
+#define netif_printk(priv, type, level, dev, fmt, args...)	\
+do {					  			\
+	if (netif_msg_##type(priv))				\
+		netdev_printk(level, (dev), fmt, ##args);	\
+} while (0)
+
+#define netif_emerg(priv, type, dev, fmt, args...)		\
+	netif_printk(priv, type, KERN_EMERG, dev, fmt, ##args)
+#define netif_alert(priv, type, dev, fmt, args...)		\
+	netif_printk(priv, type, KERN_ALERT, dev, fmt, ##args)
+#define netif_crit(priv, type, dev, fmt, args...)		\
+	netif_printk(priv, type, KERN_CRIT, dev, fmt, ##args)
+#define netif_err(priv, type, dev, fmt, args...)		\
+	netif_printk(priv, type, KERN_ERR, dev, fmt, ##args)
+#define netif_warn(priv, type, dev, fmt, args...)		\
+	netif_printk(priv, type, KERN_WARNING, dev, fmt, ##args)
+#define netif_notice(priv, type, dev, fmt, args...)		\
+	netif_printk(priv, type, KERN_NOTICE, dev, fmt, ##args)
+#define netif_info(priv, type, dev, fmt, args...)		\
+	netif_printk(priv, type, KERN_INFO, (dev), fmt, ##args)
+
+#if defined(DEBUG)
+#define netif_dbg(priv, type, dev, format, args...)		\
+	netif_printk(priv, type, KERN_DEBUG, dev, format, ##args)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+#define netif_dbg(priv, type, netdev, format, args...)		\
+do {								\
+	if (netif_msg_##type(priv))				\
+		dynamic_dev_dbg((netdev)->dev.parent,		\
+				"%s: " format,			\
+				netdev_name(netdev), ##args);	\
+} while (0)
+#else
+#define netif_dbg(priv, type, dev, format, args...)			\
+({									\
+	if (0)								\
+		netif_printk(priv, type, KERN_DEBUG, dev, format, ##args); \
+	0;								\
+})
+#endif
+
+#if defined(VERBOSE_DEBUG)
+#define netif_vdbg	netdev_dbg
+#else
+#define netif_vdbg(priv, type, dev, format, args...)		\
+({								\
+	if (0)							\
+		netif_printk(KERN_DEBUG, dev, format, ##args);	\
+	0;							\
+})
+#endif
 /* source: include/linux/netdevice.h */
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
-- 
1.6.3.3

