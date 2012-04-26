Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39364 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042Ab2DZSIm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:08:42 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC c 8/9] compat: move code from compat-3.3.h
Date: Thu, 26 Apr 2012 20:07:53 +0200
Message-Id: <1335463674-13003-13-git-send-email-hauke@hauke-m.de> (sfid-20120426_202904_027086_6582B59B)
In-Reply-To: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat: move __pskb_copy() and skb_complete_wifi_ack()

compat: move netdev_features_t

compat: move module_driver()

compat: move module_usb_driver()

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.3.h      |   44 ---------------------------------------
 include/linux/device.h          |   38 +++++++++++++++++++++++++++++++++
 include/linux/netdev_features.h |   22 ++++++++++++++++++++
 include/linux/netdevice.h       |   10 +++++++--
 include/linux/skbuff.h          |   11 ++++++++++
 include/linux/usb.h             |   24 +++++++++++++++++++++
 6 files changed, 103 insertions(+), 46 deletions(-)
 create mode 100644 include/linux/device.h
 create mode 100644 include/linux/netdev_features.h
 create mode 100644 include/linux/usb.h

diff --git a/include/linux/compat-3.3.h b/include/linux/compat-3.3.h
index 69bdcd0..ea331f5 100644
--- a/include/linux/compat-3.3.h
+++ b/include/linux/compat-3.3.h
@@ -9,52 +9,8 @@
 #include <linux/nl80211.h>
 #include <linux/skbuff.h>
 
-extern struct sk_buff *__pskb_copy(struct sk_buff *skb,
-				   int headroom, gfp_t gfp_mask);
-
-static inline void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
-{
-	WARN_ON(1);
-}
 #define NL80211_FEATURE_SK_TX_STATUS 0
 
-typedef u32 netdev_features_t;
-
-/* source include/linux/device.h */
-/**
- * module_driver() - Helper macro for drivers that don't do anything
- * special in module init/exit. This eliminates a lot of boilerplate.
- * Each module may only use this macro once, and calling it replaces
- * module_init() and module_exit().
- *
- * Use this macro to construct bus specific macros for registering
- * drivers, and do not use it on its own.
- */
-#define module_driver(__driver, __register, __unregister) \
-static int __init __driver##_init(void) \
-{ \
-	return __register(&(__driver)); \
-} \
-module_init(__driver##_init); \
-static void __exit __driver##_exit(void) \
-{ \
-	__unregister(&(__driver)); \
-} \
-module_exit(__driver##_exit);
-
-/* source include/linux/usb.h */
-/**
- * module_usb_driver() - Helper macro for registering a USB driver
- * @__usb_driver: usb_driver struct
- *
- * Helper macro for USB drivers which do not do anything special in module
- * init/exit. This eliminates a lot of boilerplate. Each module may only
- * use this macro once, and calling it replaces module_init() and module_exit()
- */
-#define module_usb_driver(__usb_driver) \
-	module_driver(__usb_driver, usb_register, \
-		       usb_deregister)
-
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)) */
 
 #endif /* LINUX_3_3_COMPAT_H */
diff --git a/include/linux/device.h b/include/linux/device.h
new file mode 100644
index 0000000..e4efd9a
--- /dev/null
+++ b/include/linux/device.h
@@ -0,0 +1,38 @@
+#ifndef _COMPAT_LINUX_DEVICE_H
+#define _COMPAT_LINUX_DEVICE_H
+
+#include_next <linux/device.h>
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0))
+
+/**
+ * module_driver() - Helper macro for drivers that don't do anything
+ * special in module init/exit. This eliminates a lot of boilerplate.
+ * Each module may only use this macro once, and calling it replaces
+ * module_init() and module_exit().
+ *
+ * @__driver: driver name
+ * @__register: register function for this driver type
+ * @__unregister: unregister function for this driver type
+ * @...: Additional arguments to be passed to __register and __unregister.
+ *
+ * Use this macro to construct bus specific macros for registering
+ * drivers, and do not use it on its own.
+ */
+#define module_driver(__driver, __register, __unregister, ...) \
+static int __init __driver##_init(void) \
+{ \
+	return __register(&(__driver) , ##__VA_ARGS__); \
+} \
+module_init(__driver##_init); \
+static void __exit __driver##_exit(void) \
+{ \
+	__unregister(&(__driver) , ##__VA_ARGS__); \
+} \
+module_exit(__driver##_exit);
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)) */
+
+#endif	/* _COMPAT_LINUX_DEVICE_H */
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
new file mode 100644
index 0000000..2b702e9
--- /dev/null
+++ b/include/linux/netdev_features.h
@@ -0,0 +1,22 @@
+#ifndef _COMPAT_LINUX_NETDEV_FEATURES_H
+#define _COMPAT_LINUX_NETDEV_FEATURES_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0))
+#include <linux/netdevice.h>
+#else
+#include_next <linux/netdev_features.h>
+#endif
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0))
+
+#include <linux/types.h>
+
+typedef u32 netdev_features_t;
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)) */
+
+#endif	/* _COMPAT_LINUX_NETDEV_FEATURES_H */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6c0582d..97153ba 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1,10 +1,16 @@
 #ifndef _COMPAT_LINUX_NETDEVICE_H
 #define _COMPAT_LINUX_NETDEVICE_H
 
-#include_next <linux/netdevice.h>
-
 #include <linux/version.h>
 
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0))
+
+#include <linux/netdev_features.h>
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)) */
+
+#include_next <linux/netdevice.h>
+
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
 
 /*
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e505f6a..8b5188c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5,6 +5,17 @@
 
 #include <linux/version.h>
 
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0))
+
+extern struct sk_buff *__pskb_copy(struct sk_buff *skb,
+				   int headroom, gfp_t gfp_mask);
+
+static inline void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
+{
+	WARN_ON(1);
+}
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)) */
+
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0))
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28))
diff --git a/include/linux/usb.h b/include/linux/usb.h
new file mode 100644
index 0000000..43e0683
--- /dev/null
+++ b/include/linux/usb.h
@@ -0,0 +1,24 @@
+#ifndef _COMPAT_LINUX_USB_H
+#define _COMPAT_LINUX_USB_H
+
+#include_next <linux/usb.h>
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0))
+
+/**
+ * module_usb_driver() - Helper macro for registering a USB driver
+ * @__usb_driver: usb_driver struct
+ *
+ * Helper macro for USB drivers which do not do anything special in module
+ * init/exit. This eliminates a lot of boilerplate. Each module may only
+ * use this macro once, and calling it replaces module_init() and module_exit()
+ */
+#define module_usb_driver(__usb_driver) \
+	module_driver(__usb_driver, usb_register, \
+		       usb_deregister)
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)) */
+
+#endif	/* _COMPAT_LINUX_USB_H */
-- 
1.7.9.5

