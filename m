Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55306 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbZGLSJD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 14:09:03 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] [compat-2.6] Fix problems with kernel 2.6.31.
Date: Sun, 12 Jul 2009 20:08:49 +0200
Message-Id: <1247422129-652-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

__dev_addr_sync and __dev_addr_unsync are not exported in kernel < 2.6.32.

Now this is compiling and loading with kernel 2.6.31.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.29.c |    2 +-
 compat/compat-2.6.30.c |    2 +-
 compat/compat-2.6.31.c |  110 +-----------------------------------------
 compat/compat-2.6.32.c |  124 ++++++++++++++++++++++++++++++++++++++++++++++++
 compat/compat-2.6.32.h |   12 +++++
 compat/compat.diff     |   23 +++++----
 6 files changed, 152 insertions(+), 121 deletions(-)
 create mode 100644 compat/compat-2.6.32.c
 create mode 100644 compat/compat-2.6.32.h
 delete mode 100644 compat/compat.c

diff --git a/compat/compat-2.6.29.c b/compat/compat-2.6.29.c
index 82439a5..e0f1e30 100644
--- a/compat/compat-2.6.29.c
+++ b/compat/compat-2.6.29.c
@@ -12,7 +12,7 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
 
-/* 2.6.28 compat code goes here */
+/* 2.6.29 compat code goes here */
 
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29) */
 
diff --git a/compat/compat-2.6.30.c b/compat/compat-2.6.30.c
index 0220fb1..ce25dfd 100644
--- a/compat/compat-2.6.30.c
+++ b/compat/compat-2.6.30.c
@@ -12,7 +12,7 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
 
-/* 2.6.28 compat code goes here */
+/* 2.6.30 compat code goes here */
 
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30) */
 
diff --git a/compat/compat-2.6.31.c b/compat/compat-2.6.31.c
index 5c51bde..a102115 100644
--- a/compat/compat-2.6.31.c
+++ b/compat/compat-2.6.31.c
@@ -10,116 +10,10 @@
 
 #include <net/compat.h>
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31))
 
 #include <linux/netdevice.h>
 
-int __dev_addr_add(struct dev_addr_list **list, int *count,
-		   void *addr, int alen, int glbl)
-{
-	struct dev_addr_list *da;
-
-	for (da = *list; da != NULL; da = da->next) {
-		if (memcmp(da->da_addr, addr, da->da_addrlen) == 0 &&
-		    da->da_addrlen == alen) {
-			if (glbl) {
-				int old_glbl = da->da_gusers;
-				da->da_gusers = 1;
-				if (old_glbl)
-					return 0;
-			}
-			da->da_users++;
-			return 0;
-		}
-	}
-
-	da = kzalloc(sizeof(*da), GFP_ATOMIC);
-	if (da == NULL)
-		return -ENOMEM;
-	memcpy(da->da_addr, addr, alen);
-	da->da_addrlen = alen;
-	da->da_users = 1;
-	da->da_gusers = glbl ? 1 : 0;
-	da->next = *list;
-	*list = da;
-	(*count)++;
-	return 0;
-}
-
-int __dev_addr_delete(struct dev_addr_list **list, int *count,
-		      void *addr, int alen, int glbl)
-{
-	struct dev_addr_list *da;
-
-	for (; (da = *list) != NULL; list = &da->next) {
-		if (memcmp(da->da_addr, addr, da->da_addrlen) == 0 &&
-		    alen == da->da_addrlen) {
-			if (glbl) {
-				int old_glbl = da->da_gusers;
-				da->da_gusers = 0;
-				if (old_glbl == 0)
-					break;
-			}
-			if (--da->da_users)
-				return 0;
-
-			*list = da->next;
-			kfree(da);
-			(*count)--;
-			return 0;
-		}
-	}
-	return -ENOENT;
-}
-
-int __dev_addr_sync(struct dev_addr_list **to, int *to_count,
-		    struct dev_addr_list **from, int *from_count)
-{
-	struct dev_addr_list *da, *next;
-	int err = 0;
-
-	da = *from;
-	while (da != NULL) {
-		next = da->next;
-		if (!da->da_synced) {
-			err = __dev_addr_add(to, to_count,
-					     da->da_addr, da->da_addrlen, 0);
-			if (err < 0)
-				break;
-			da->da_synced = 1;
-			da->da_users++;
-		} else if (da->da_users == 1) {
-			__dev_addr_delete(to, to_count,
-					  da->da_addr, da->da_addrlen, 0);
-			__dev_addr_delete(from, from_count,
-					  da->da_addr, da->da_addrlen, 0);
-		}
-		da = next;
-	}
-	return err;
-}
-EXPORT_SYMBOL_GPL(__dev_addr_sync);
-
-void __dev_addr_unsync(struct dev_addr_list **to, int *to_count,
-		       struct dev_addr_list **from, int *from_count)
-{
-	struct dev_addr_list *da, *next;
-
-	da = *from;
-	while (da != NULL) {
-		next = da->next;
-		if (da->da_synced) {
-			__dev_addr_delete(to, to_count,
-					  da->da_addr, da->da_addrlen, 0);
-			da->da_synced = 0;
-			__dev_addr_delete(from, from_count,
-					  da->da_addr, da->da_addrlen, 0);
-		}
-		da = next;
-	}
-}
-EXPORT_SYMBOL_GPL(__dev_addr_unsync);
-
 /**
  * genl_register_family_with_ops - register a generic netlink family
  * @family: generic netlink family
@@ -166,5 +60,5 @@ err_out:
 }
 EXPORT_SYMBOL(genl_register_family_with_ops);
 
-#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
 
diff --git a/compat/compat-2.6.32.c b/compat/compat-2.6.32.c
new file mode 100644
index 0000000..91d03b2
--- /dev/null
+++ b/compat/compat-2.6.32.c
@@ -0,0 +1,124 @@
+/*
+ * Copyright 2007	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 2.6.32.
+ */
+
+#include <net/compat.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
+
+#include <linux/netdevice.h>
+
+int __dev_addr_add(struct dev_addr_list **list, int *count,
+		   void *addr, int alen, int glbl)
+{
+	struct dev_addr_list *da;
+
+	for (da = *list; da != NULL; da = da->next) {
+		if (memcmp(da->da_addr, addr, da->da_addrlen) == 0 &&
+		    da->da_addrlen == alen) {
+			if (glbl) {
+				int old_glbl = da->da_gusers;
+				da->da_gusers = 1;
+				if (old_glbl)
+					return 0;
+			}
+			da->da_users++;
+			return 0;
+		}
+	}
+
+	da = kzalloc(sizeof(*da), GFP_ATOMIC);
+	if (da == NULL)
+		return -ENOMEM;
+	memcpy(da->da_addr, addr, alen);
+	da->da_addrlen = alen;
+	da->da_users = 1;
+	da->da_gusers = glbl ? 1 : 0;
+	da->next = *list;
+	*list = da;
+	(*count)++;
+	return 0;
+}
+
+int __dev_addr_delete(struct dev_addr_list **list, int *count,
+		      void *addr, int alen, int glbl)
+{
+	struct dev_addr_list *da;
+
+	for (; (da = *list) != NULL; list = &da->next) {
+		if (memcmp(da->da_addr, addr, da->da_addrlen) == 0 &&
+		    alen == da->da_addrlen) {
+			if (glbl) {
+				int old_glbl = da->da_gusers;
+				da->da_gusers = 0;
+				if (old_glbl == 0)
+					break;
+			}
+			if (--da->da_users)
+				return 0;
+
+			*list = da->next;
+			kfree(da);
+			(*count)--;
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
+int __dev_addr_sync(struct dev_addr_list **to, int *to_count,
+		    struct dev_addr_list **from, int *from_count)
+{
+	struct dev_addr_list *da, *next;
+	int err = 0;
+
+	da = *from;
+	while (da != NULL) {
+		next = da->next;
+		if (!da->da_synced) {
+			err = __dev_addr_add(to, to_count,
+					     da->da_addr, da->da_addrlen, 0);
+			if (err < 0)
+				break;
+			da->da_synced = 1;
+			da->da_users++;
+		} else if (da->da_users == 1) {
+			__dev_addr_delete(to, to_count,
+					  da->da_addr, da->da_addrlen, 0);
+			__dev_addr_delete(from, from_count,
+					  da->da_addr, da->da_addrlen, 0);
+		}
+		da = next;
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(__dev_addr_sync);
+
+void __dev_addr_unsync(struct dev_addr_list **to, int *to_count,
+		       struct dev_addr_list **from, int *from_count)
+{
+	struct dev_addr_list *da, *next;
+
+	da = *from;
+	while (da != NULL) {
+		next = da->next;
+		if (da->da_synced) {
+			__dev_addr_delete(to, to_count,
+					  da->da_addr, da->da_addrlen, 0);
+			da->da_synced = 0;
+			__dev_addr_delete(from, from_count,
+					  da->da_addr, da->da_addrlen, 0);
+		}
+		da = next;
+	}
+}
+EXPORT_SYMBOL_GPL(__dev_addr_unsync);
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
+
diff --git a/compat/compat-2.6.32.h b/compat/compat-2.6.32.h
new file mode 100644
index 0000000..53fea83
--- /dev/null
+++ b/compat/compat-2.6.32.h
@@ -0,0 +1,12 @@
+#ifndef LINUX_26_32_COMPAT_H
+#define LINUX_26_32_COMPAT_H
+
+#include <linux/autoconf.h>
+#include <linux/version.h>
+#include <linux/compat_autoconf.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
+
+#endif /* LINUX_26_32_COMPAT_H */
diff --git a/compat/compat.c b/compat/compat.c
deleted file mode 100644
index e69de29..0000000
diff --git a/compat/compat.diff b/compat/compat.diff
index 9b73788..1661382 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -1,10 +1,10 @@
---- a/drivers/misc/eeprom/Makefile	2009-07-02 00:23:37.993293412 -0700
-+++ b/drivers/misc/eeprom/Makefile	2009-07-02 00:23:38.053296505 -0700
-@@ -1,5 +1,2 @@
+--- a/drivers/misc/eeprom/Makefile
++++ b/drivers/misc/eeprom/Makefile
+@@ -1,5 +1 @@
 -obj-$(CONFIG_EEPROM_AT24)	+= at24.o
 -obj-$(CONFIG_EEPROM_AT25)	+= at25.o
 -obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
- obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
+-obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 --- a/drivers/net/b44.c
 +++ b/drivers/net/b44.c
@@ -51,9 +51,9 @@
  	dev->irq = sdev->irq;
  	SET_ETHTOOL_OPS(dev, &b44_ethtool_ops);
  
---- a/drivers/net/usb/Makefile	2009-07-02 00:23:37.969259980 -0700
-+++ b/drivers/net/usb/Makefile	2009-07-02 00:23:38.057293452 -0700
-@@ -2,23 +2,8 @@
+--- a/drivers/net/usb/Makefile
++++ b/drivers/net/usb/Makefile
+@@ -2,23 +2,7 @@
  # Makefile for USB Network drivers
  #
  
@@ -75,7 +75,7 @@
 -obj-$(CONFIG_USB_NET_ZAURUS)	+= zaurus.o
 -obj-$(CONFIG_USB_NET_MCS7830)	+= mcs7830.o
  obj-$(CONFIG_USB_USBNET)	+= usbnet.o
- obj-$(CONFIG_USB_NET_INT51X1)	+= int51x1.o
+-obj-$(CONFIG_USB_NET_INT51X1)	+= int51x1.o
  
 --- a/drivers/net/usb/rndis_host.c
 +++ b/drivers/net/usb/rndis_host.c
@@ -141,9 +141,9 @@
  	net->watchdog_timeo = TX_TIMEOUT_JIFFIES;
  	net->ethtool_ops = &usbnet_ethtool_ops;
  
---- a/net/wireless/Makefile	2009-07-08 16:35:31.392259166 -0700
-+++ b/net/wireless/Makefile	2009-07-08 16:35:56.036284948 -0700
-@@ -10,3 +10,10 @@
+--- a/net/wireless/Makefile
++++ b/net/wireless/Makefile
+@@ -10,3 +10,11 @@ cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
  cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o wext-sme.o
  
  ccflags-y += -D__CHECK_ENDIAN__
@@ -153,6 +153,7 @@
 +cfg80211-y += compat-2.6.29.o
 +cfg80211-y += compat-2.6.30.o
 +cfg80211-y += compat-2.6.31.o
++cfg80211-y += compat-2.6.32.o
 +
 --- a/drivers/net/wireless/ath/ath5k/base.h
 +++ b/drivers/net/wireless/ath/ath5k/base.h
-- 
1.6.2.1

