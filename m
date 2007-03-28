Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbXC2LIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:08:41 -0400
Subject: cfg80211 wext compat w/o wext code changes, rtnl locking
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: James Ketrenos <jketreno@linux.intel.com>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 01:00:14 +0200
Message-Id: <1175122815.8807.21.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Doh! /me smacks forehead. It could've been so easy.

How about we simply use do_ioctl for cfg80211/wext compat? wext still
calls that "for old devices" and we'll need to take a bit more care than
usual, but it should be much simpler than trying to assign all
callbacks. And less code to boot.

It doesn't really matter that we then seize do_ioctl, the ioctls you can
do aren't interesting for wireless devices.

As for locking issues... Once mac80211 doesn't use the rtnl any more (I
firmly believe it has no business using it) we'll need to make wext not
acquire rtnl or we'll run into ABBA deadlock issues. Below is an
untested patch to achieve this.

For building external modules, we'll have to carry a small patch to make
cfg80211 acquire the rtnl for each call, and a small patch to mac80211
use the locked variants for registering netdevs etc.

But all that once mac80211 actually doesn't use the rtnl any more.

johannes

---
 include/net/iw_handler.h   |    3 +
 net/wireless/wext-common.c |    6 ---
 net/wireless/wext-old.c    |   70 ++++++++++++++++++++++++++++-----------------
 3 files changed, 47 insertions(+), 32 deletions(-)

--- wireless-dev.orig/include/net/iw_handler.h	2007-03-29 00:52:50.965831178 +0200
+++ wireless-dev/include/net/iw_handler.h	2007-03-29 00:53:21.455831178 +0200
@@ -345,6 +345,9 @@ struct iw_handler_def
 	 * The old pointer in struct net_device will be gradually phased
 	 * out, and drivers are encouraged to use this one... */
 	struct iw_statistics*	(*get_wireless_stats)(struct net_device *dev);
+
+	/* can live without rtnl locking? */
+	int no_locking;
 };
 
 /* ---------------------- IOCTL DESCRIPTION ---------------------- */
--- wireless-dev.orig/net/wireless/wext-common.c	2007-03-29 00:52:50.995831178 +0200
+++ wireless-dev/net/wireless/wext-common.c	2007-03-29 00:53:21.475831178 +0200
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
--- wireless-dev.orig/net/wireless/wext-old.c	2007-03-29 00:52:51.105831178 +0200
+++ wireless-dev/net/wireless/wext-old.c	2007-03-29 00:58:25.455831178 +0200
@@ -526,64 +526,82 @@ int wireless_process_ioctl(struct ifreq 
 {
 	struct net_device *dev;
 	iw_handler	handler;
+	int err;
 
 	/* Permissions are already checked in dev_ioctl() before calling us.
 	 * The copy_to/from_user() of ifr is also dealt with in there */
 
 	/* Make sure the device exist */
-	if ((dev = __dev_get_by_name(ifr->ifr_name)) == NULL)
+	if ((dev = dev_get_by_name(ifr->ifr_name)) == NULL)
 		return -ENODEV;
 
 	/* A bunch of special cases, then the generic case...
 	 * Note that 'cmd' is already filtered in dev_ioctl() with
 	 * (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) */
-	switch(cmd) {
+	switch (cmd) {
 		case SIOCGIWSTATS:
 			/* Get Wireless Stats */
-			return ioctl_standard_call(dev,
-						   ifr,
-						   cmd,
-						   &iw_handler_get_iwstats);
-
+			err = ioctl_standard_call(dev,
+						  ifr,
+						  cmd,
+						  &iw_handler_get_iwstats);
+			break;
 		case SIOCGIWPRIV:
 			/* Check if we have some wireless handlers defined */
-			if(dev->wireless_handlers != NULL) {
+			if (dev->wireless_handlers) {
 				/* We export to user space the definition of
 				 * the private handler ourselves */
-				return ioctl_standard_call(dev,
-							   ifr,
-							   cmd,
-							   &iw_handler_get_private);
+				err = ioctl_standard_call(dev,
+							  ifr,
+							  cmd,
+							  &iw_handler_get_private);
+				break;
 			}
 			// ## Fall-through for old API ##
 		default:
 			/* Generic IOCTL */
 			/* Basic check */
-			if (!netif_device_present(dev))
-				return -ENODEV;
+			if (!netif_device_present(dev)) {
+				err = -ENODEV;
+				break;
+			}
 			/* New driver API : try to find the handler */
 			handler = get_handler(dev, cmd);
-			if(handler != NULL) {
+			if (handler) {
+				if (!dev->wireless_handlers->no_locking)
+					rtnl_lock();
 				/* Standard and private are not the same */
-				if(cmd < SIOCIWFIRSTPRIV)
-					return ioctl_standard_call(dev,
-								   ifr,
-								   cmd,
-								   handler);
-				else
-					return ioctl_private_call(dev,
+				if (cmd < SIOCIWFIRSTPRIV)
+					err = ioctl_standard_call(dev,
 								  ifr,
 								  cmd,
 								  handler);
+				else
+					err = ioctl_private_call(dev,
+								 ifr,
+								 cmd,
+								 handler);
+				if (!dev->wireless_handlers->no_locking)
+					rtnl_unlock();
+				break;
 			}
 			/* Old driver API : call driver ioctl handler */
 			if (dev->do_ioctl) {
-				return dev->do_ioctl(dev, ifr, cmd);
+				if (dev->wireless_handlers &&
+				    dev->wireless_handlers->no_locking)
+					err = dev->do_ioctl(dev, ifr, cmd);
+				else {
+					rtnl_lock();
+					err = dev->do_ioctl(dev, ifr, cmd);
+					rtnl_unlock();
+				}
+				break;
 			}
-			return -EOPNOTSUPP;
+			err = -EOPNOTSUPP;
 	}
-	/* Not reached */
-	return -EINVAL;
+
+	dev_put(dev);
+	return err;
 }
 
 /********************** ENHANCED IWSPY SUPPORT **********************/


