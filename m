Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36499 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab0KLSOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 13:14:54 -0500
Date: Fri, 12 Nov 2010 13:11:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: [PATCH] compat: support building on RHEL 6 kernels
Message-ID: <20101112181154.GF2338@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RHEL kernels in general (and RHEL 6 kernels in particular) often
contain features backported from later upstream kernels.  This means
that the normal KERNEL_VERSION checks are not always correct for RHEL
kernels.  This patch augments a number of such tests to be compatible
with building compat-wireless on RHEL 6 kernels.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
This patch contains the general compat portions...

diff -up compat-wireless-2.6.36-4/compat/compat_firmware_class.c.orig compat-wireless-2.6.36-4/compat/compat_firmware_class.c
--- compat-wireless-2.6.36-4/compat/compat_firmware_class.c.orig	2010-11-12 12:00:39.050193706 -0500
+++ compat-wireless-2.6.36-4/compat/compat_firmware_class.c	2010-11-12 12:10:47.288513373 -0500
@@ -314,9 +314,15 @@ static ssize_t firmware_loading_store(st
 
 static DEVICE_ATTR(loading, 0644, firmware_loading_show, firmware_loading_store);
 
+#if !defined(RHEL_MAJOR) || (RHEL_MAJOR != 6)
 static ssize_t firmware_data_read(struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *buffer, loff_t offset, size_t count)
+#else
+static ssize_t firmware_data_read(struct file *filp, struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buffer, loff_t offset, size_t count)
+#endif
 {
 	struct device *dev = to_dev(kobj);
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
@@ -407,9 +413,15 @@ static int fw_realloc_buffer(struct firm
  *	Data written to the 'data' attribute will be later handed to
  *	the driver as a firmware image.
  **/
+#if !defined(RHEL_MAJOR) || (RHEL_MAJOR != 6)
 static ssize_t firmware_data_write(struct kobject *kobj,
 				   struct bin_attribute *bin_attr,
 				   char *buffer, loff_t offset, size_t count)
+#else
+static ssize_t firmware_data_write(struct file *filp, struct kobject *kobj,
+				   struct bin_attribute *bin_attr,
+				   char *buffer, loff_t offset, size_t count)
+#endif
 {
 	struct device *dev = to_dev(kobj);
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
diff -up compat-wireless-2.6.36-4/include/linux/compat-2.6.33.h.orig compat-wireless-2.6.36-4/include/linux/compat-2.6.33.h
--- compat-wireless-2.6.36-4/include/linux/compat-2.6.33.h.orig	2010-11-12 10:25:13.561172060 -0500
+++ compat-wireless-2.6.36-4/include/linux/compat-2.6.33.h	2010-11-12 11:19:10.369172382 -0500
@@ -47,7 +47,9 @@ static inline void compat_release_firmwa
 }
 #endif
 
+#if (!defined(RHEL_MAJOR) || (RHEL_MAJOR != 6))
 #define KEY_RFKILL		247	/* Key that controls all radios */
+#endif
 
 #define IFF_DONT_BRIDGE 0x800		/* disallow bridging this ether dev */
 /* source: include/linux/if.h */
@@ -55,6 +57,7 @@ static inline void compat_release_firmwa
 /* this will never happen on older kernels */
 #define NETDEV_POST_INIT 0xffff
 
+#if (!defined(RHEL_MAJOR) || (RHEL_MAJOR != 6))
 static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
                 unsigned int length)
 {
@@ -64,6 +67,7 @@ static inline struct sk_buff *netdev_all
 		skb_reserve(skb, NET_IP_ALIGN);
 	return skb;
 }
+#endif
 
 #if defined(CONFIG_PCCARD) || defined(CONFIG_PCCARD_MODULE)
 
diff -up compat-wireless-2.6.36-4/include/linux/compat-2.6.34.h.orig compat-wireless-2.6.36-4/include/linux/compat-2.6.34.h
--- compat-wireless-2.6.36-4/include/linux/compat-2.6.34.h.orig	2010-11-12 10:25:44.165172202 -0500
+++ compat-wireless-2.6.36-4/include/linux/compat-2.6.34.h	2010-11-12 11:19:29.315182613 -0500
@@ -19,12 +19,14 @@
 
 /* netdev_printk helpers, similar to dev_printk */
 
+#if (!defined(RHEL_MAJOR) || (RHEL_MAJOR != 6))
 static inline const char *netdev_name(const struct net_device *dev)
 {
 	if (dev->reg_state != NETREG_REGISTERED)
 		return "(unregistered net_device)";
 	return dev->name;
 }
+#endif
 
 #define netdev_printk(level, netdev, format, args...)		\
 	dev_printk(level, (netdev)->dev.parent,			\
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
