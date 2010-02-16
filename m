Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42755 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933336Ab0BPVDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 16:03:16 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: backport some netdevice.h defs
Date: Tue, 16 Feb 2010 22:03:01 +0100
Message-Id: <1266354181-5317-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1266354181-5317-1-git-send-email-hauke@hauke-m.de>
References: <1266354181-5317-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.34.h |   70 +++++++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.h    |    1 +
 2 files changed, 71 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/compat-2.6.34.h

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
new file mode 100644
index 0000000..4229a22
--- /dev/null
+++ b/include/linux/compat-2.6.34.h
@@ -0,0 +1,70 @@
+#ifndef LINUX_26_34_COMPAT_H
+#define LINUX_26_34_COMPAT_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34))
+
+#include <linux/netdevice.h>
+
+#define netdev_mc_count(dev) ((dev)->mc_count)
+#define netdev_mc_empty(dev) (netdev_mc_count(dev) == 0)
+
+#define netdev_for_each_mc_addr(mclist, dev) \
+	for (mclist = dev->mc_list; mclist; mclist = mclist->next)
+/* source: include/linux/netdevice.h */
+
+
+/* Logging, debugging and troubleshooting/diagnostic helpers. */
+
+/* netdev_printk helpers, similar to dev_printk */
+
+static inline const char *netdev_name(const struct net_device *dev)
+{
+	if (dev->reg_state != NETREG_REGISTERED)
+		return "(unregistered net_device)";
+	return dev->name;
+}
+
+#define netdev_printk(level, netdev, format, args...)		\
+	dev_printk(level, (netdev)->dev.parent,			\
+		   "%s: " format,				\
+		   netdev_name(netdev), ##args)
+
+#define netdev_emerg(dev, format, args...)			\
+	netdev_printk(KERN_EMERG, dev, format, ##args)
+#define netdev_alert(dev, format, args...)			\
+	netdev_printk(KERN_ALERT, dev, format, ##args)
+#define netdev_crit(dev, format, args...)			\
+	netdev_printk(KERN_CRIT, dev, format, ##args)
+#define netdev_err(dev, format, args...)			\
+	netdev_printk(KERN_ERR, dev, format, ##args)
+#define netdev_warn(dev, format, args...)			\
+	netdev_printk(KERN_WARNING, dev, format, ##args)
+#define netdev_notice(dev, format, args...)			\
+	netdev_printk(KERN_NOTICE, dev, format, ##args)
+#define netdev_info(dev, format, args...)			\
+	netdev_printk(KERN_INFO, dev, format, ##args)
+
+#if defined(DEBUG)
+#define netdev_dbg(__dev, format, args...)			\
+	netdev_printk(KERN_DEBUG, __dev, format, ##args)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+#define netdev_dbg(__dev, format, args...)			\
+do {								\
+	dynamic_dev_dbg((__dev)->dev.parent, "%s: " format,	\
+			netdev_name(__dev), ##args);		\
+} while (0)
+#else
+#define netdev_dbg(__dev, format, args...)			\
+({								\
+	if (0)							\
+		netdev_printk(KERN_DEBUG, __dev, format, ##args); \
+	0;							\
+})
+#endif
+/* source: include/linux/netdevice.h */
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
+
+#endif /* LINUX_26_34_COMPAT_H */
diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index 81224de..ceca997 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -26,5 +26,6 @@
 #include <linux/compat-2.6.31.h>
 #include <linux/compat-2.6.32.h>
 #include <linux/compat-2.6.33.h>
+#include <linux/compat-2.6.34.h>
 
 #endif /* LINUX_26_COMPAT_H */
-- 
1.6.3.3

