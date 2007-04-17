Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbXDRJII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2007 05:08:08 -0400
Subject: [PATCH] wext: allow wext users without rtnl
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 17:50:10 +0200
Message-Id: <1176825010.3902.28.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch modifies wext adding a flag that allows drivers to specify that
they do not wish their wext calls made under rtnl. The default is to still
acquire the rtnl.

Warning: a device reference is held for the new no_locking API,
therefore it is not safe to call unregister_netdev on the passed device!

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/iw_handler.h   |    3 +
 net/wireless/wext-common.c |    6 --
 net/wireless/wext-old.c    |  127 ++++++++++++++++++++++++---------------------
 3 files changed, 72 insertions(+), 64 deletions(-)

--- wireless-dev.orig/include/net/iw_handler.h	2007-04-13 23:20:56.755356880 +0200
+++ wireless-dev/include/net/iw_handler.h	2007-04-13 23:36:48.635356880 +0200
@@ -349,6 +349,9 @@ struct iw_handler_def
 	 * The old pointer in struct net_device will be gradually phased
 	 * out, and drivers are encouraged to use this one... */
 	struct iw_statistics*	(*get_wireless_stats)(struct net_device *dev);
+
+	/* can live without rtnl locking? */
+	int no_locking;
 };
 
 /* ---------------------- IOCTL DESCRIPTION ---------------------- */
--- wireless-dev.orig/net/wireless/wext-common.c	2007-04-13 23:20:56.785356880 +0200
+++ wireless-dev/net/wireless/wext-common.c	2007-04-13 23:36:48.635356880 +0200
@@ -631,15 +631,9 @@ int wext_ioctl(unsigned int cmd, struct 
 #ifdef CONFIG_WIRELESS_EXT
 	dev_load(ifr->ifr_name);
 
-	/* we could change the code to not hold the rtnl but
-	 * some callees might require it held */
-	rtnl_lock();
-
 	/* Follow me in wext-old.c */
 	ret = wireless_process_ioctl(ifr, cmd);
 
-	rtnl_unlock();
-
 	/* haha, I cheat here by allowing a driver or stack to have both WE and
 	 * CFG80211-WE for a little while during conversion... wext returns
 	 * -EOPNOTSUPP if a handler is not assigned, so we can in that case try
--- wireless-dev.orig/net/wireless/wext-old.c	2007-04-13 23:20:56.925356880 +0200
+++ wireless-dev/net/wireless/wext-old.c	2007-04-17 17:45:57.752028444 +0200
@@ -516,74 +516,85 @@ static inline int ioctl_private_call(str
 	return ret;
 }
 
-/* ---------------------------------------------------------------- */
+static int ioctl_call(struct net_device *dev, struct ifreq *ifr,
+		      unsigned int cmd, iw_handler handler)
+{
+	/* Standard and private are not the same */
+	if (cmd >= SIOCIWFIRSTPRIV)
+		return ioctl_private_call(dev, ifr, cmd, handler);
+
+	return ioctl_standard_call(dev, ifr, cmd, handler);
+}
+
+static int dev_process_ioctl(struct net_device *dev, struct ifreq *ifr,
+			     unsigned int cmd)
+{
+	iw_handler handler;
+
+	if (cmd == SIOCGIWSTATS) {
+		/* Get Wireless Stats */
+		return ioctl_standard_call(dev, ifr, cmd,
+					   &iw_handler_get_iwstats);
+	}
+
+	if (cmd == SIOCGIWPRIV && dev->wireless_handlers) {
+		/* We export to user space the definition of
+		 * the private handler ourselves */
+		return ioctl_standard_call(dev, ifr, cmd,
+					   &iw_handler_get_private);
+	}
+
+	/* Basic check */
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	/* New driver API : try to find the handler */
+	handler = get_handler(dev, cmd);
+	if (handler)
+		return ioctl_call(dev, ifr, cmd, handler);
+
+	/* Old driver API : call driver ioctl handler */
+	if (dev->do_ioctl)
+		return dev->do_ioctl(dev, ifr, cmd);
+
+	return -EOPNOTSUPP;
+}
+
 /*
- * Main IOCTl dispatcher. Called from the main networking code
- * (dev_ioctl() in net/core/dev.c).
- * Check the type of IOCTL and call the appropriate wrapper...
+ * Main ioctl dispatcher. Called from the common wireless code
+ * in net/wireless/wext-common.c.
  */
 int wireless_process_ioctl(struct ifreq *ifr, unsigned int cmd)
 {
 	struct net_device *dev;
-	iw_handler	handler;
+	int err;
 
-	/* Permissions are already checked in dev_ioctl() before calling us.
-	 * The copy_to/from_user() of ifr is also dealt with in there */
+	/* Get device reference so it doesn't go away */
+	dev = dev_get_by_name(ifr->ifr_name);
 
-	/* Make sure the device exist */
-	if ((dev = __dev_get_by_name(ifr->ifr_name)) == NULL)
+	if (!dev)
 		return -ENODEV;
 
-	/* A bunch of special cases, then the generic case...
-	 * Note that 'cmd' is already filtered in dev_ioctl() with
-	 * (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) */
-	switch(cmd) {
-		case SIOCGIWSTATS:
-			/* Get Wireless Stats */
-			return ioctl_standard_call(dev,
-						   ifr,
-						   cmd,
-						   &iw_handler_get_iwstats);
-
-		case SIOCGIWPRIV:
-			/* Check if we have some wireless handlers defined */
-			if(dev->wireless_handlers != NULL) {
-				/* We export to user space the definition of
-				 * the private handler ourselves */
-				return ioctl_standard_call(dev,
-							   ifr,
-							   cmd,
-							   &iw_handler_get_private);
-			}
-			// ## Fall-through for old API ##
-		default:
-			/* Generic IOCTL */
-			/* Basic check */
-			if (!netif_device_present(dev))
-				return -ENODEV;
-			/* New driver API : try to find the handler */
-			handler = get_handler(dev, cmd);
-			if(handler != NULL) {
-				/* Standard and private are not the same */
-				if(cmd < SIOCIWFIRSTPRIV)
-					return ioctl_standard_call(dev,
-								   ifr,
-								   cmd,
-								   handler);
-				else
-					return ioctl_private_call(dev,
-								  ifr,
-								  cmd,
-								  handler);
-			}
-			/* Old driver API : call driver ioctl handler */
-			if (dev->do_ioctl) {
-				return dev->do_ioctl(dev, ifr, cmd);
-			}
-			return -EOPNOTSUPP;
+	/*
+	 * Check for the new no_locking API and if no locking is wanted then
+	 * call the handler without ever touching rtnl.
+	 * It needs to be this way to avoid ABBA type deadlocks.
+	 */
+	if (dev->wireless_handlers && dev->wireless_handlers->no_locking) {
+		err = dev_process_ioctl(dev, ifr, cmd);
+		dev_put(dev);
+	} else {
+		rtnl_lock();
+		/*
+		 * put device before calling handler, it might expect a
+		 * device with no held references in its own call path.
+		 */
+		dev_put(dev);
+		err = dev_process_ioctl(dev, ifr, cmd);
+		rtnl_unlock();
 	}
-	/* Not reached */
-	return -EINVAL;
+
+	return err;
 }
 
 /********************** ENHANCED IWSPY SUPPORT **********************/


