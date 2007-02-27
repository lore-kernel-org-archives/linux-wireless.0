Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60770 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbXB0XSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 18:18:48 -0500
Subject: [PATCH] make cfg80211 manage wiphy netdev list
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	James Ketrenos <jketreno@linux.intel.com>
Content-Type: text/plain
Date: Wed, 28 Feb 2007 00:18:17 +0100
Message-Id: <1172618298.3681.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes cfg80211 handle the list of netdevices associated with
a wiphy. It does this by watching NETDEV_REGISTER/UNREGISTER events.

One effect of this patch is that cfg80211 users no longer need to
provide a list_devices hook. Another effect is that all cfg80211 users
will get a "phy80211" symlink in all their netdevices pointing to the
802.11 phy this netdev is associated to, thereby standardising this.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
James, are you ok with the "phy80211" name? The wiphy* names can be
changed too, but they shall ultimately be changeable from userspace so
people can have stable names there.

---
 include/linux/netdevice.h      |    3 +-
 include/net/cfg80211.h         |    7 ----
 include/net/wireless.h         |    3 ++
 net/mac80211/ieee80211_cfg.c   |   18 ------------
 net/mac80211/ieee80211_sysfs.c |   13 +-------
 net/wireless/core.c            |   61 ++++++++++++++++++++++++++++++++++-------
 net/wireless/core.h            |    3 ++
 net/wireless/nl80211.c         |   42 ++++++++++++----------------
 8 files changed, 80 insertions(+), 70 deletions(-)

--- wireless-dev.orig/include/linux/netdevice.h	2007-02-27 23:01:32.645643616 +0100
+++ wireless-dev/include/linux/netdevice.h	2007-02-27 23:02:06.065643616 +0100
@@ -401,7 +401,8 @@ struct net_device
 	void                    *ip6_ptr;       /* IPv6 specific data */
 	void			*ec_ptr;	/* Econet specific data	*/
 	void			*ax25_ptr;	/* AX.25 specific data */
-	struct wireless_dev	*ieee80211_ptr;	/* IEEE 802.11 specific data */
+	struct wireless_dev	*ieee80211_ptr;	/* IEEE 802.11 specific data,
+						   assign before registering */
 
 /*
  * Cache line mostly used on receive path (including eth_type_trans())
--- wireless-dev.orig/net/wireless/core.c	2007-02-27 23:03:44.625643616 +0100
+++ wireless-dev/net/wireless/core.c	2007-02-27 23:34:16.505643616 +0100
@@ -11,6 +11,7 @@
 #include <linux/list.h>
 #include <linux/nl80211.h>
 #include <linux/debugfs.h>
+#include <linux/notifier.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include <net/wireless.h>
@@ -143,9 +144,6 @@ struct wiphy *wiphy_new(struct cfg80211_
 	struct cfg80211_registered_device *drv;
 	int alloc_size;
 
-	if (!ops->list_interfaces)
-		return NULL;
-
 	alloc_size = sizeof(*drv) + sizeof_priv;
 
 	drv = kzalloc(alloc_size, GFP_KERNEL);
@@ -172,6 +170,7 @@ struct wiphy *wiphy_new(struct cfg80211_
 	mutex_unlock(&cfg80211_drv_mutex);
 
 	mutex_init(&drv->mtx);
+	INIT_LIST_HEAD(&drv->netdev_list);
 
 	device_initialize(&drv->wiphy.dev);
 	drv->wiphy.dev.class = &ieee80211_class;
@@ -238,30 +237,73 @@ void wiphy_free(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(wiphy_free);
 
+static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
+					 unsigned long state,
+					 void *ndev)
+{
+	struct net_device *dev = ndev;
+	struct cfg80211_registered_device *rdev;
+
+	if (!dev->ieee80211_ptr)
+		return 0;
+
+	rdev = wiphy_to_dev(dev->ieee80211_ptr->wiphy);
+
+	switch (state) {
+	case NETDEV_REGISTER:
+		mutex_lock(&rdev->mtx);
+		list_add(&dev->ieee80211_ptr->list, &rdev->netdev_list);
+		if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
+				      "phy80211")) {
+			printk(KERN_ERR "wireless: failed to add phy80211 symlink to netdev!\n");
+		}
+		dev->ieee80211_ptr->netdev = dev;
+		mutex_unlock(&rdev->mtx);
+		break;
+	case NETDEV_UNREGISTER:
+		mutex_lock(&rdev->mtx);
+		sysfs_remove_link(&dev->dev.kobj, "phy80211");
+		list_del(&dev->ieee80211_ptr->list);
+		mutex_unlock(&rdev->mtx);
+		break;
+	}
+
+	return 0;
+}
+
+static struct notifier_block cfg80211_netdev_notifier = {
+	.notifier_call = cfg80211_netdev_notifier_call,
+};
 
 static int cfg80211_init(void)
 {
 	int err = wiphy_sysfs_init();
 	if (err)
-		return err;
+		goto out_fail_sysfs;
+
+	err = register_netdevice_notifier(&cfg80211_netdev_notifier);
+	if (err)
+		goto out_fail_notifier;
 
 	err = cfg80211_wext_init();
 	if (err)
-		goto out_exit_sysfs;
+		goto out_fail_wext;
 
 	err = nl80211_init();
 	if (err)
-		goto out_nl80211;
+		goto out_fail_nl80211;
 
 	ieee80211_debugfs_dir = debugfs_create_dir("ieee80211", NULL);
 
 	return 0;
 
- out_nl80211:
+ out_fail_nl80211:
 	cfg80211_wext_exit();
- out_exit_sysfs:
+ out_fail_wext:
+	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
+ out_fail_notifier:
 	wiphy_sysfs_exit();
-
+ out_fail_sysfs:
 	return err;
 }
 module_init(cfg80211_init);
@@ -271,6 +313,7 @@ static void cfg80211_exit(void)
 	debugfs_remove(ieee80211_debugfs_dir);
 	nl80211_exit();
 	cfg80211_wext_exit();
+	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
 	wiphy_sysfs_exit();
 }
 module_exit(cfg80211_exit);
--- wireless-dev.orig/net/mac80211/ieee80211_sysfs.c	2007-02-27 23:09:43.335643616 +0100
+++ wireless-dev/net/mac80211/ieee80211_sysfs.c	2007-02-27 23:42:01.185643616 +0100
@@ -699,23 +699,15 @@ int ieee80211_sysfs_change_if_type(struc
 
 int ieee80211_sysfs_add_netdevice(struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int res;
 
-	res = sysfs_create_link(&dev->dev.kobj,
-				&local->hw.wiphy->dev.kobj,
-				"wiphy");
-	if (res)
-		goto err_out;
 	res = ieee80211_add_if_group(&dev->dev.kobj, dev);
 	if (res)
-		goto err_link;
+		goto err_fail_if_group;
 	res = ieee80211_key_kset_sysfs_register(IEEE80211_DEV_TO_SUB_IF(dev));
 	return res;
 
-err_link:
-	sysfs_remove_link(&dev->dev.kobj, "wiphy");
-err_out:
+err_fail_if_group:
 	return res;
 }
 
@@ -723,5 +715,4 @@ void ieee80211_sysfs_remove_netdevice(st
 {
 	ieee80211_key_kset_sysfs_unregister(IEEE80211_DEV_TO_SUB_IF(dev));
 	ieee80211_remove_if_group(&dev->dev.kobj, dev);
-	sysfs_remove_link(&dev->dev.kobj, "wiphy");
 }
--- wireless-dev.orig/include/net/wireless.h	2007-02-27 23:01:22.395643616 +0100
+++ wireless-dev/include/net/wireless.h	2007-02-27 23:34:22.035643616 +0100
@@ -9,6 +9,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/debugfs.h>
+#include <linux/list.h>
 #include <net/cfg80211.h>
 
 /**
@@ -48,6 +49,8 @@ struct wireless_dev {
 
 	/* private to the generic wireless code */
 	struct cfg80211_config pending_config;
+	struct list_head list;
+	struct net_device *netdev;
 };
 
 /**
--- wireless-dev.orig/net/wireless/core.h	2007-02-27 23:18:35.045643616 +0100
+++ wireless-dev/net/wireless/core.h	2007-02-27 23:40:02.925643616 +0100
@@ -24,6 +24,9 @@ struct cfg80211_registered_device {
 	/* wiphy index, internal only */
 	int idx;
 
+	/* associate netdev list */
+	struct list_head netdev_list;
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
--- wireless-dev.orig/include/net/cfg80211.h	2007-02-27 23:22:55.315643616 +0100
+++ wireless-dev/include/net/cfg80211.h	2007-02-27 23:23:03.035643616 +0100
@@ -66,9 +66,6 @@ struct wiphy;
  * All callbacks except where otherwise noted should return 0
  * on success or a negative error code.
  *
- * @list_interfaces: Call the one() function with the given data and the
- *                   ifindex for each interface belonging to the wiphy.
- *		     This callback is required.
  * @inject_packet: inject the given frame with the NL80211_FLAG_*
  *		   flags onto the given queue.
  *
@@ -118,10 +115,6 @@ struct wiphy;
  *		   is to be passed to that callback
  */
 struct cfg80211_ops {
-	int	(*list_interfaces)(struct wiphy *wiphy, void *data,
-				   int (*one)(void *data, int ifindex));
-
-
 	int	(*inject_packet)(struct wiphy *wiphy, void *frame, int framelen,
 				 u32 flags, int queue);
 
--- wireless-dev.orig/net/mac80211/ieee80211_cfg.c	2007-02-27 23:22:36.495643616 +0100
+++ wireless-dev/net/mac80211/ieee80211_cfg.c	2007-02-27 23:22:48.195643616 +0100
@@ -24,23 +24,6 @@ static inline int rtnl_lock_local(struct
 }
 
 
-static int ieee80211_list_interfaces(struct wiphy *wiphy, void *data,
-				     int (*one)(void *data, int ifindex))
-{
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_sub_if_data *subif;
-	int err = 0;
-
-	spin_lock_bh(&local->sub_if_lock);
-	list_for_each_entry(subif, &local->sub_if_list, list) {
-		err = one(data, subif->dev->ifindex);
-		if (err)
-			break;
-	}
-	spin_unlock_bh(&local->sub_if_lock);
-	return err;
-}
-
 static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
 			       unsigned int type)
 {
@@ -102,7 +85,6 @@ static int ieee80211_del_iface(struct wi
 }
 
 struct cfg80211_ops mac80211_config_ops = {
-	.list_interfaces = ieee80211_list_interfaces,
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
 };
--- wireless-dev.orig/net/wireless/nl80211.c	2007-02-27 23:23:19.825643616 +0100
+++ wireless-dev/net/wireless/nl80211.c	2007-02-27 23:40:36.735643616 +0100
@@ -197,31 +197,21 @@ static int nl80211_get_wiphys(struct sk_
 	return -ENOBUFS;
 }
 
-struct add_cb_data {
-	int idx;
-	struct sk_buff *skb;
-};
-
-static int addifidx(void *data, int ifidx)
+static int addifidx(struct net_device *dev, struct sk_buff *skb, int *idx)
 {
-	struct add_cb_data *cb = data;
-	struct net_device *dev = dev_get_by_index(ifidx);
 	int err = -ENOBUFS;
 	struct nlattr *start;
 
-	/* not that this can happen, since the caller
-	 * should hold the device open... */
-	if (!dev)
-		return -ENODEV;
+	dev_hold(dev);
 
-	start = nla_nest_start(cb->skb, cb->idx++);
+	start = nla_nest_start(skb, *idx++);
 	if (!start)
 		goto nla_put_failure;
 
-	NLA_PUT_U32(cb->skb, NL80211_ATTR_IFINDEX, ifidx);
-	NLA_PUT_STRING(cb->skb, NL80211_ATTR_IFNAME, dev->name);
+	NLA_PUT_U32(skb, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT_STRING(skb, NL80211_ATTR_IFNAME, dev->name);
 
-	nla_nest_end(cb->skb, start);
+	nla_nest_end(skb, start);
 	err = 0;
 
  nla_put_failure:
@@ -234,9 +224,9 @@ static int nl80211_get_intfs(struct sk_b
 	struct cfg80211_registered_device *drv;
 	struct sk_buff *msg;
 	void *hdr;
-	int err;
+	int err, array_idx;
 	struct nlattr *start;
-	struct add_cb_data cb;
+	struct wireless_dev *wdev;
 
 	drv = cfg80211_get_dev_from_info(info);
 	if (IS_ERR(drv))
@@ -257,12 +247,11 @@ static int nl80211_get_intfs(struct sk_b
 		goto msg_free;
 	}
 
-	cb.skb = msg;
-	cb.idx = 1;
-	err = drv->ops->list_interfaces(&drv->wiphy, &cb, addifidx);
-	if (err)
-		goto msg_free;
-
+	array_idx = 1;
+	list_for_each_entry(wdev, &drv->netdev_list, list) {
+		if (addifidx(wdev->netdev, msg, &array_idx))
+			goto msg_free;
+	}
 	nla_nest_end(msg, start);
 
 	genlmsg_end(msg, hdr);
@@ -718,6 +707,11 @@ static int nl80211_assoc_deauth(struct s
 	return err;
 }
 
+struct add_cb_data {
+	int idx;
+	struct sk_buff *skb;
+};
+
 static int add_bssid(void *data, u8 *bssid)
 {
 	struct add_cb_data *cb = data;


