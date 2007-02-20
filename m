Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030423AbXBTVO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Feb 2007 16:14:29 -0500
Subject: [PATCH] add add_iface/remove_iface back to sysfs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 22:14:16 +0100
Message-Id: <1172006056.15489.220.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the wiphy add_iface/remove_iface sysfs attributes back
into sysfs. However, they are implemented on top of cfg80211 now and
nl80211 userspace should work as well.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This is temporary API. Before the merge, we should clean up all sysfs
stuff that we have and probably move most of it to debugfs.

Tested to work by Michael Buesch, thanks!

---
 net/d80211/ieee80211_cfg.c |   76 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/sysfs.c       |   47 +++++++++++++++++++++++++++
 2 files changed, 122 insertions(+), 1 deletion(-)

--- wireless-dev.orig/net/d80211/ieee80211_cfg.c	2007-02-20 21:27:35.121648675 +0100
+++ wireless-dev/net/d80211/ieee80211_cfg.c	2007-02-20 21:38:58.171648675 +0100
@@ -6,10 +6,24 @@
  * This file is GPLv2 as found in COPYING.
  */
 
+#include <linux/nl80211.h>
+#include <linux/rtnetlink.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "ieee80211_cfg.h"
 
+/* copied from ieee80211_sysfs.c for now ... */
+static inline int rtnl_lock_local(struct ieee80211_local *local)
+{
+	rtnl_lock();
+	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED)) {
+		rtnl_unlock();
+		return -ENODEV;
+	}
+	return 0;
+}
+
+
 static int ieee80211_list_interfaces(struct wiphy *wiphy, void *data,
 				     int (*one)(void *data, int ifindex))
 {
@@ -27,6 +41,68 @@ static int ieee80211_list_interfaces(str
 	return err;
 }
 
+static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
+			       unsigned int type)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct net_device *new_dev;
+	int res, itype;
+
+	switch (type) {
+	case NL80211_IFTYPE_UNSPECIFIED:
+		itype = IEEE80211_IF_TYPE_STA;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		itype = IEEE80211_IF_TYPE_IBSS;
+		break;
+	case NL80211_IFTYPE_STATION:
+		itype = IEEE80211_IF_TYPE_STA;
+		break;
+	case NL80211_IFTYPE_AP:
+		itype = IEEE80211_IF_TYPE_AP;
+		break;
+	case NL80211_IFTYPE_WDS:
+		itype = IEEE80211_IF_TYPE_WDS;
+		break;
+	case NL80211_IFTYPE_MONITOR:
+		itype = IEEE80211_IF_TYPE_MNTR;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	res = rtnl_lock_local(local);
+	if (res)
+		return res;
+
+	res = ieee80211_if_add(local->mdev, name, 0, &new_dev);
+	if (res == 0)
+		ieee80211_if_set_type(new_dev, itype);
+	rtnl_unlock();
+	return res;
+}
+
+static int ieee80211_del_iface(struct wiphy *wiphy, int ifindex)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	int res;
+	struct net_device *dev;
+	char *name;
+
+	res = rtnl_lock_local(local);
+	if (res)
+		return res;
+	dev = dev_get_by_index(ifindex);
+	name = dev->name;
+	dev_put(dev);
+
+	res = ieee80211_if_remove(local->mdev, name, -1);
+	rtnl_unlock();
+	return res;
+}
+
 struct cfg80211_ops d80211_config_ops = {
 	.list_interfaces = ieee80211_list_interfaces,
+	.add_virtual_intf = ieee80211_add_iface,
+	.del_virtual_intf = ieee80211_del_iface,
 };
--- wireless-dev.orig/net/wireless/sysfs.c	2007-02-20 21:40:48.181648675 +0100
+++ wireless-dev/net/wireless/sysfs.c	2007-02-20 22:03:28.111648675 +0100
@@ -10,6 +10,8 @@
 
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/nl80211.h>
 #include <net/cfg80211.h>
 #include "core.h"
 
@@ -32,10 +34,53 @@ static ssize_t _show_permaddr(struct cla
 		       addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
 }
 
+static ssize_t _store_add_iface(struct class_device *dev,
+				const char *buf, size_t len)
+{
+	struct cfg80211_registered_device *rdev = cdev_to_dev(dev);
+	int res;
+
+	if (len > IFNAMSIZ)
+		return -EINVAL;
+
+	if (!rdev->ops->add_virtual_intf)
+		return -ENOSYS;
+
+	res = rdev->ops->add_virtual_intf(&rdev->wiphy, (char*)buf,
+					  NL80211_IFTYPE_UNSPECIFIED);
+
+	return res ? res : len;
+}
+
+static ssize_t _store_remove_iface(struct class_device *dev,
+				   const char *buf, size_t len)
+{
+	struct cfg80211_registered_device *rdev = cdev_to_dev(dev);
+	int res, ifidx;
+	struct net_device *netdev;
+
+	if (len > IFNAMSIZ)
+		return -EINVAL;
+
+	if (!rdev->ops->del_virtual_intf)
+		return -ENOSYS;
+
+	netdev = dev_get_by_name(buf);
+	if (!netdev)
+		return -ENODEV;
+	ifidx = netdev->ifindex;
+	dev_put(netdev);
+
+	res = rdev->ops->del_virtual_intf(&rdev->wiphy, ifidx);
+
+	return res ? res : len;
+}
+
 static struct class_device_attribute ieee80211_class_dev_attrs[] = {
 	__ATTR(index, S_IRUGO, _show_index, NULL),
 	__ATTR(macaddress, S_IRUGO, _show_permaddr, NULL),
-
+	__ATTR(add_iface, S_IWUGO, NULL, _store_add_iface),
+	__ATTR(remove_iface, S_IWUGO, NULL, _store_remove_iface),
 	{}
 };
 


