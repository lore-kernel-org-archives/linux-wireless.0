Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZI1JeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 05:34:12 -0400
Subject: [PATCH] wext: add back wireless/ dir in sysfs for cfg80211
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Sep 2009 11:34:13 +0200
Message-Id: <1254130453.6583.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The move away from wireless handlers the drivers assign
to wireless handlers being assigned by cfg80211 broke
the sysfs registration (the wireless/ dir went missing)
because the handlers were assigned only after sysfs
registration and thus the registration never noticed a
device was wireless.

Fix this by special-casing cfg80211-based devices, all
of which are required to have an ieee80211_ptr, in the
sysfs code, and also using get_wireless_stats() to have
the same values reported as in procfs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
 include/net/wext.h   |    1 +
 net/core/net-sysfs.c |   12 +++++-------
 net/wireless/wext.c  |    2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

--- wireless-testing.orig/net/core/net-sysfs.c	2009-09-28 10:41:50.000000000 +0200
+++ wireless-testing/net/core/net-sysfs.c	2009-09-28 11:24:12.000000000 +0200
@@ -16,7 +16,7 @@
 #include <net/sock.h>
 #include <linux/rtnetlink.h>
 #include <linux/wireless.h>
-#include <net/iw_handler.h>
+#include <net/wext.h>
 
 #include "net-sysfs.h"
 
@@ -363,15 +363,13 @@ static ssize_t wireless_show(struct devi
 					       char *))
 {
 	struct net_device *dev = to_net_dev(d);
-	const struct iw_statistics *iw = NULL;
+	const struct iw_statistics *iw;
 	ssize_t ret = -EINVAL;
 
 	read_lock(&dev_base_lock);
 	if (dev_isalive(dev)) {
-		if (dev->wireless_handlers &&
-		    dev->wireless_handlers->get_wireless_stats)
-			iw = dev->wireless_handlers->get_wireless_stats(dev);
-		if (iw != NULL)
+		iw = get_wireless_stats(dev);
+		if (iw)
 			ret = (*format)(iw, buf);
 	}
 	read_unlock(&dev_base_lock);
@@ -505,7 +503,7 @@ int netdev_register_kobject(struct net_d
 	*groups++ = &netstat_group;
 
 #ifdef CONFIG_WIRELESS_EXT_SYSFS
-	if (net->wireless_handlers && net->wireless_handlers->get_wireless_stats)
+	if (net->wireless_handlers || net->ieee80211_ptr)
 		*groups++ = &wireless_group;
 #endif
 #endif /* CONFIG_SYSFS */
--- wireless-testing.orig/include/net/wext.h	2009-09-28 10:41:50.000000000 +0200
+++ wireless-testing/include/net/wext.h	2009-09-28 11:09:06.000000000 +0200
@@ -14,6 +14,7 @@ extern int wext_handle_ioctl(struct net 
 			     void __user *arg);
 extern int compat_wext_handle_ioctl(struct net *net, unsigned int cmd,
 				    unsigned long arg);
+extern struct iw_statistics *get_wireless_stats(struct net_device *dev);
 #else
 static inline int wext_proc_init(struct net *net)
 {
--- wireless-testing.orig/net/wireless/wext.c	2009-09-28 10:41:50.000000000 +0200
+++ wireless-testing/net/wireless/wext.c	2009-09-28 11:09:07.000000000 +0200
@@ -470,7 +470,7 @@ static iw_handler get_handler(struct net
 /*
  * Get statistics out of the driver
  */
-static struct iw_statistics *get_wireless_stats(struct net_device *dev)
+struct iw_statistics *get_wireless_stats(struct net_device *dev)
 {
 	/* New location */
 	if ((dev->wireless_handlers != NULL) &&


