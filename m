Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43639 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965667AbXBOO7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 09:59:50 -0500
Message-Id: <20070215144257.530315000@sipsolutions.net>
References: <20070215144241.847938000@sipsolutions.net>
Date: Thu, 15 Feb 2007 15:42:44 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 03/10] introduce wiphy concept
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces struct wiphy and struct wireless_dev. The latter
is added to struct net_device as ieee80211_ptr and keeps wireless per-netdev
state, the wiphy keeps wireless per-device (hardware) state and is
accessible from struct wireless_dev.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
I think we should go with this for now. I've tested it quite a bit and
it all seems to work pretty well.

For the future:

Maybe instead of having ieee80211_ptr point to a struct wireless_dev
(which can be allocated along with the netdev) we should mandate that
each wireless netdev is allocated via a new function that puts the
wireless_dev struct as the first part of the private area of the netdev,
that way getting to it is just a simple addition instead of following
a pointer... and we can also drop ieee80211_ptr from struct net_device.

We'd provide functions to go from netdev to wdev and from wdev to
priv. Also, we could then keep track of all wdevs that have been added
to a certain wiphy and get rid of the cfg80211 list_interfaces callback.
And we could pass a wdev to all calls there...

Another thing to do is allowing renaming of the wiphy via cfg80211...

Well, if anybody read this far I'd appreciate comments, if not, well,
who cares? :)

---
 include/linux/netdevice.h  |    4 
 include/net/cfg80211.h     |   73 +++++------------
 include/net/wireless.h     |  124 ++++++++++++++++++++++++++++++
 net/wireless/Makefile      |    2 
 net/wireless/core.c        |  184 ++++++++++++++++++++++++++-------------------
 net/wireless/core.h        |   39 ++++++---
 net/wireless/nl80211.c     |  115 ++++++++++++++--------------
 net/wireless/sysfs.c       |   85 ++++++++++++++++++++
 net/wireless/sysfs.h       |   10 ++
 net/wireless/wext-compat.c |   96 +++++++++++------------
 10 files changed, 489 insertions(+), 243 deletions(-)

--- wireless-dev.orig/net/wireless/core.h	2007-02-15 14:29:54.467629166 +0100
+++ wireless-dev/net/wireless/core.h	2007-02-15 15:32:22.534331360 +0100
@@ -5,16 +5,15 @@
  */
 #ifndef __NET_WIRELESS_CORE_H
 #define __NET_WIRELESS_CORE_H
-#include <net/cfg80211.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/netdevice.h>
 #include <net/genetlink.h>
-#include <linux/module.h>
+#include <net/wireless.h>
+#include <net/cfg80211.h>
 
-struct cfg80211_registered_driver {
+struct cfg80211_registered_device {
 	struct cfg80211_ops *ops;
-	int wiphy;
-	void *priv;
 	struct list_head list;
 	/* we hold this mutex during any call so that
 	 * we cannot do multiple calls at once, and also
@@ -22,12 +21,25 @@ struct cfg80211_registered_driver {
 	 * any call is in progress */
 	struct mutex mtx;
 
+	/* wiphy index, internal only */
+	int idx;
+
 #ifdef CONFIG_CFG80211_WEXT_COMPAT
 	/* wext compat */
 	struct cfg80211_config *wext_pending_config;
 #endif
+
+	/* must be last because of the way we do wiphy_priv(),
+	 * and it should at least be aligned to NETDEV_ALIGN */
+	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
 };
 
+static inline struct cfg80211_registered_device *wiphy_to_dev(struct wiphy *wiphy)
+{
+	BUG_ON(!wiphy);
+	return container_of(wiphy, struct cfg80211_registered_device, wiphy);
+}
+
 extern struct mutex cfg80211_drv_mutex;
 extern struct list_head cfg80211_drv_list;
 
@@ -37,7 +49,7 @@ extern struct list_head cfg80211_drv_lis
  * If successful, it returns non-NULL and also locks
  * the driver's mutex!
  *
- * This means that you need to call cfg80211_put_drv()
+ * This means that you need to call cfg80211_put_dev()
  * before being allowed to acquire &cfg80211_drv_mutex!
  *
  * This is necessary because we need to lock the global
@@ -51,13 +63,16 @@ extern struct list_head cfg80211_drv_lis
  * The result of this can be a PTR_ERR and hence must
  * be checked with IS_ERR() for errors.
  */
-extern struct cfg80211_registered_driver *
-cfg80211_get_drv_from_info(struct genl_info *info);
+extern struct cfg80211_registered_device *
+cfg80211_get_dev_from_info(struct genl_info *info);
+
+/* identical to cfg80211_get_dev_from_info but only operate on ifindex */
+extern struct cfg80211_registered_device *
+cfg80211_get_dev_from_ifindex(int ifindex);
 
-/* identical to cfg80211_get_drv_from_info but only operate on ifindex */
-extern struct cfg80211_registered_driver *
-cfg80211_get_drv_from_ifindex(int ifindex);
+extern void cfg80211_put_dev(struct cfg80211_registered_device *drv);
 
-extern void cfg80211_put_drv(struct cfg80211_registered_driver *drv);
+/* free object */
+extern void cfg80211_dev_free(struct cfg80211_registered_device *drv);
 
 #endif /* __NET_WIRELESS_CORE_H */
--- wireless-dev.orig/include/linux/netdevice.h	2007-02-15 14:29:54.437629166 +0100
+++ wireless-dev/include/linux/netdevice.h	2007-02-15 14:29:54.557629166 +0100
@@ -42,6 +42,8 @@
 struct vlan_group;
 struct ethtool_ops;
 struct netpoll_info;
+/* 802.11 specific */
+struct wireless_dev;
 					/* source back-compat hooks */
 #define SET_ETHTOOL_OPS(netdev,ops) \
 	( (netdev)->ethtool_ops = (ops) )
@@ -399,7 +401,7 @@ struct net_device
 	void                    *ip6_ptr;       /* IPv6 specific data */
 	void			*ec_ptr;	/* Econet specific data	*/
 	void			*ax25_ptr;	/* AX.25 specific data */
-	void			*ieee80211_ptr;	/* IEEE 802.11 specific data */
+	struct wireless_dev	*ieee80211_ptr;	/* IEEE 802.11 specific data */
 
 /*
  * Cache line mostly used on receive path (including eth_type_trans())
--- wireless-dev.orig/include/net/cfg80211.h	2007-02-15 14:29:54.437629166 +0100
+++ wireless-dev/include/net/cfg80211.h	2007-02-15 15:32:26.034331360 +0100
@@ -2,11 +2,8 @@
 #define __NET_CFG80211_H
 
 #include <linux/netlink.h>
-#include <linux/nl80211.h>
 #include <linux/skbuff.h>
-#include <linux/netdevice.h>
 #include <net/genetlink.h>
-#include <linux/wireless.h>
 
 /*
  * 802.11 configuration in-kernel interface
@@ -57,22 +54,21 @@ struct scan_params {
 	struct scan_channel *channels;
 };
 
+/* from net/wireless.h */
+struct wiphy;
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
  * in order to handle configuration requests on their interfaces.
  *
- * The priv pointer passed to each call is the pointer that was
- * registered in cfg80211_register_driver().
- *
  * All callbacks except where otherwise noted should return 0
  * on success or a negative error code.
  *
- * @list_interfaces: for each interfaces belonging to the wiphy identified
- *		     by the priv pointer, call the one() function with the
- *		     given data and the ifindex. This callback is required.
- *
+ * @list_interfaces: Call the one() function with the given data and the
+ *                   ifindex for each interface belonging to the wiphy.
+ *		     This callback is required.
  * @inject_packet: inject the given frame with the NL80211_FLAG_*
  *		   flags onto the given queue.
  *
@@ -118,74 +114,53 @@ struct scan_params {
  *		   is to be passed to that callback
  */
 struct cfg80211_ops {
-	int	(*list_interfaces)(void *priv, void *data,
+	int	(*list_interfaces)(struct wiphy *wiphy, void *data,
 				   int (*one)(void *data, int ifindex));
 
 
-	int	(*inject_packet)(void *priv, void *frame, int framelen,
+	int	(*inject_packet)(struct wiphy *wiphy, void *frame, int framelen,
 				 u32 flags, int queue);
 
 
-	int	(*add_virtual_intf)(void *priv, char *name,
+	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
 				    unsigned int type);
-	int	(*del_virtual_intf)(void *priv, int ifindex);
+	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
 
 
-	int	(*configure)(void *priv, struct net_device *dev,
+	int	(*configure)(struct wiphy *wiphy, struct net_device *dev,
 			     struct cfg80211_config *cfg);
-	void	(*get_config)(void *priv, struct net_device *dev,
+	void	(*get_config)(struct wiphy *wiphy, struct net_device *dev,
 			      struct cfg80211_config *cfg);
-	u32	(*get_config_valid)(void *priv, struct net_device *dev);
+	u32	(*get_config_valid)(struct wiphy *wiphy,
+				    struct net_device *dev);
 
 
-	int	(*reassociate)(void *priv, struct net_device *dev);
-	int	(*disassociate)(void *priv, struct net_device *dev);
-	int	(*deauth)(void *priv, struct net_device *dev);
+	int	(*reassociate)(struct wiphy *wiphy, struct net_device *dev);
+	int	(*disassociate)(struct wiphy *wiphy, struct net_device *dev);
+	int	(*deauth)(struct wiphy *wiphy, struct net_device *dev);
 
 
-	int	(*initiate_scan)(void *priv, struct net_device *dev,
+	int	(*initiate_scan)(struct wiphy *wiphy, struct net_device *dev,
 				 struct scan_params *params);
 
 
-	int	(*set_roaming)(void *priv, struct net_device *dev,
+	int	(*set_roaming)(struct wiphy *wiphy, struct net_device *dev,
 			       int roaming_control);
-	int	(*get_roaming)(void *priv, struct net_device *dev);
-	int	(*set_fixed_bssid)(void *priv, struct net_device *dev,
+	int	(*get_roaming)(struct wiphy *wiphy, struct net_device *dev);
+	int	(*set_fixed_bssid)(struct wiphy *wiphy, struct net_device *dev,
 				   u8 *bssid);
-	int	(*get_fixed_bssid)(void *priv, struct net_device *dev,
+	int	(*get_fixed_bssid)(struct wiphy *wiphy, struct net_device *dev,
 				   u8 *bssid);
 
 
-	int	(*get_association)(void *priv, struct net_device *dev,
+	int	(*get_association)(struct wiphy *wiphy, struct net_device *dev,
 				   u8 *bssid);
 
-	int	(*get_auth_list)(void *priv, struct net_device *dev,
+	int	(*get_auth_list)(struct wiphy *wiphy, struct net_device *dev,
 				 void *data,
 				 int (*next_bssid)(void *data, u8 *bssid));
 };
 
-/**
- * cfg80211_register - register a wiphy with cfg80211
- *
- * register a given method structure with the cfg80211 system
- * and associate the 'priv' pointer with it.
- *
- * Returns a non-negative wiphy index or a negative error code.
- *
- * NOTE: for proper operation, this priv pointer MUST also be
- * assigned to each &struct net_device's @ieee80211_ptr member!
- */
-extern int cfg80211_register(struct cfg80211_ops *ops, void *priv);
-
-/**
- * cfg80211_unregister - deregister a wiphy from cfg80211
- *
- * unregister a device with the given priv pointer.
- * After this call, no more requests can be made with this priv
- * pointer, but the call may sleep to wait for an outstanding
- * request that is being handled.
- */
-extern void cfg80211_unregister(void *priv);
 
 /* helper functions specific to nl80211 */
 extern void *nl80211hdr_put(struct sk_buff *skb, u32 pid,
--- wireless-dev.orig/net/wireless/core.c	2007-02-15 14:29:54.457629166 +0100
+++ wireless-dev/net/wireless/core.c	2007-02-15 15:35:42.484331360 +0100
@@ -10,11 +10,14 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/nl80211.h>
+#include <linux/debugfs.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
+#include <net/wireless.h>
 #include "nl80211.h"
 #include "core.h"
 #include "wext.h"
+#include "sysfs.h"
 
 MODULE_AUTHOR("Johannes Berg");
 MODULE_LICENSE("GPL");
@@ -27,31 +30,16 @@ LIST_HEAD(cfg80211_drv_list);
 DEFINE_MUTEX(cfg80211_drv_mutex);
 static int wiphy_counter;
 
-/* requires nl80211_drv_mutex to be held! */
-static struct cfg80211_registered_driver *cfg80211_drv_by_priv(void *priv)
-{
-	struct cfg80211_registered_driver *result = NULL, *drv;
-
-	if (!priv)
-		return NULL;
-
-	list_for_each_entry(drv, &cfg80211_drv_list, list) {
-		if (drv->priv == priv) {
-			result = drv;
-			break;
-		}
-	}
-
-	return result;
-}
+/* for debugfs */
+static struct dentry *ieee80211_debugfs_dir;
 
 /* requires cfg80211_drv_mutex to be held! */
-static struct cfg80211_registered_driver *cfg80211_drv_by_wiphy(int wiphy)
+static struct cfg80211_registered_device *cfg80211_drv_by_wiphy(int wiphy)
 {
-	struct cfg80211_registered_driver *result = NULL, *drv;
+	struct cfg80211_registered_device *result = NULL, *drv;
 
 	list_for_each_entry(drv, &cfg80211_drv_list, list) {
-		if (drv->wiphy == wiphy) {
+		if (drv->idx == wiphy) {
 			result = drv;
 			break;
 		}
@@ -61,11 +49,11 @@ static struct cfg80211_registered_driver
 }
 
 /* requires cfg80211_drv_mutex to be held! */
-static struct cfg80211_registered_driver *
+static struct cfg80211_registered_device *
 __cfg80211_drv_from_info(struct genl_info *info)
 {
 	int ifindex;
-	struct cfg80211_registered_driver *bywiphy = NULL, *byifidx = NULL;
+	struct cfg80211_registered_device *bywiphy = NULL, *byifidx = NULL;
 	struct net_device *dev;
 	int err = -EINVAL;
 
@@ -79,7 +67,9 @@ __cfg80211_drv_from_info(struct genl_inf
 		ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
 		dev = dev_get_by_index(ifindex);
 		if (dev) {
-			byifidx = cfg80211_drv_by_priv(dev->ieee80211_ptr);
+			if (dev->ieee80211_ptr)
+				byifidx =
+					wiphy_to_dev(dev->ieee80211_ptr->wiphy);
 			dev_put(dev);
 		}
 		err = -ENODEV;
@@ -100,10 +90,10 @@ __cfg80211_drv_from_info(struct genl_inf
 	return ERR_PTR(err);
 }
 
-struct cfg80211_registered_driver *
-cfg80211_get_drv_from_info(struct genl_info *info)
+struct cfg80211_registered_device *
+cfg80211_get_dev_from_info(struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 
 	mutex_lock(&cfg80211_drv_mutex);
 	drv = __cfg80211_drv_from_info(info);
@@ -119,28 +109,28 @@ cfg80211_get_drv_from_info(struct genl_i
 	return drv;
 }
 
-struct cfg80211_registered_driver *
-cfg80211_get_drv_from_ifindex(int ifindex)
+struct cfg80211_registered_device *
+cfg80211_get_dev_from_ifindex(int ifindex)
 {
-	struct cfg80211_registered_driver *drv = ERR_PTR(-ENODEV);
+	struct cfg80211_registered_device *drv = ERR_PTR(-ENODEV);
 	struct net_device *dev;
 
 	mutex_lock(&cfg80211_drv_mutex);
 	dev = dev_get_by_index(ifindex);
 	if (!dev)
 		goto out;
-	drv = cfg80211_drv_by_priv(dev->ieee80211_ptr);
-	if (drv)
+	if (dev->ieee80211_ptr) {
+		drv = wiphy_to_dev(dev->ieee80211_ptr->wiphy);
 		mutex_lock(&drv->mtx);
-	else
-		drv = ERR_PTR(-ENOSYS);
+	} else
+		drv = ERR_PTR(-ENODEV);
 	dev_put(dev);
  out:
 	mutex_unlock(&cfg80211_drv_mutex);
 	return drv;
 }
 
-void cfg80211_put_drv(struct cfg80211_registered_driver *drv)
+void cfg80211_put_dev(struct cfg80211_registered_device *drv)
 {
 	BUG_ON(IS_ERR(drv));
 	mutex_unlock(&drv->mtx);
@@ -148,63 +138,78 @@ void cfg80211_put_drv(struct cfg80211_re
 
 /* exported functions */
 
-int cfg80211_register(struct cfg80211_ops *ops, void *priv)
+struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
 {
-	struct cfg80211_registered_driver *drv;
-	int res;
+	struct cfg80211_registered_device *result;
+	int alloc_size;
 
-	if (!priv || !ops->list_interfaces)
-		return -EINVAL;
+	if (!ops->list_interfaces)
+		return NULL;
 
-	mutex_lock(&cfg80211_drv_mutex);
+	alloc_size = sizeof(*result) + sizeof_priv;
 
-	if (cfg80211_drv_by_priv(priv)) {
-		res = -EALREADY;
-		goto out_unlock;
-	}
+	result = kzalloc(alloc_size, GFP_KERNEL);
+	if (!result)
+		return NULL;
 
-	drv = kzalloc(sizeof(struct cfg80211_registered_driver), GFP_KERNEL);
-	if (!drv) {
-		res = -ENOMEM;
-		goto out_unlock;
-	}
+	result->ops = ops;
 
-	drv->ops = ops;
-	drv->priv = priv;
+	mutex_lock(&cfg80211_drv_mutex);
 
 	if (unlikely(wiphy_counter<0)) {
 		/* ugh, wrapped! */
-		kfree(drv);
-		res = -ENOSPC;
-		goto out_unlock;
+		kfree(result);
+		return NULL;
 	}
-	mutex_init(&drv->mtx);
-	drv->wiphy = wiphy_counter;
-	list_add(&drv->list, &cfg80211_drv_list);
-	/* return wiphy number */
-	res = drv->wiphy;
+	drv->idx = wiphy_counter;
+
+	/* give it a proper name */
+	snprintf(drv->wiphy.class_dev.class_id, BUS_ID_SIZE,
+		 "wiphy%d", drv->idx);
 
 	/* now increase counter for the next time */
 	wiphy_counter++;
+	mutex_unlock(&cfg80211_drv_mutex);
+
+	mutex_init(&result->mtx);
+
+	class_device_initialize(&result->wiphy.class_dev);
+
+	return &result->wiphy;
+}
+EXPORT_SYMBOL(wiphy_new);
+
+int wiphy_register(struct wiphy *wiphy)
+{
+	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
+	int res;
 
+	mutex_lock(&cfg80211_drv_mutex);
+
+
+	res = wiphy_sysfs_add(&drv->wiphy);
+	if (res)
+		goto out_unlock;
+
+	list_add(&drv->list, &cfg80211_drv_list);
+
+	/* add to debugfs */
+	drv->wiphy.debugfsdir =
+		debugfs_create_dir(wiphy_name(&drv->wiphy),
+				   ieee80211_debugfs_dir);
+
+	res = 0;
  out_unlock:
 	mutex_unlock(&cfg80211_drv_mutex);
 	return res;
 }
-EXPORT_SYMBOL_GPL(cfg80211_register);
+EXPORT_SYMBOL(wiphy_register);
 
-void cfg80211_unregister(void *priv)
+void wiphy_unregister(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
 
 	mutex_lock(&cfg80211_drv_mutex);
-	drv = cfg80211_drv_by_priv(priv);
-	if (!drv) {
-		printk(KERN_ERR "deregistering cfg80211 backend that "
-		       " was never registered!\n");
-		mutex_unlock(&cfg80211_drv_mutex);
-		return;
-	}
 
 	/* hold registered driver mutex during list removal as well
 	 * to make sure no commands are in progress at the moment */
@@ -212,24 +217,53 @@ void cfg80211_unregister(void *priv)
 	list_del(&drv->list);
 	mutex_unlock(&drv->mtx);
 
+	wiphy_sysfs_del(wiphy);
+	debugfs_remove(drv->wiphy.debugfsdir);
+
 	mutex_unlock(&cfg80211_drv_mutex);
+}
+EXPORT_SYMBOL(wiphy_unregister);
 
+void cfg80211_dev_free(struct cfg80211_registered_device *drv)
+{
 	mutex_destroy(&drv->mtx);
 	kfree(drv);
 }
-EXPORT_SYMBOL_GPL(cfg80211_unregister);
 
-/* module initialisation/exit functions */
+void wiphy_free(struct wiphy *wiphy)
+{
+	class_device_put(&wiphy->class_dev);
+}
+EXPORT_SYMBOL(wiphy_free);
+
 
 static int cfg80211_init(void)
 {
-	return nl80211_init();
+	int err = wiphy_sysfs_init();
+
+	if (err)
+		return err;
+
+	err = cfg80211_wext_init();
+
+	if (err)
+		goto out_exit_sysfs;
+
+	ieee80211_debugfs_dir = debugfs_create_dir("ieee80211", NULL);
+
+	return 0;
+
+ out_exit_sysfs:
+ 	wiphy_sysfs_exit();
+
+	return err;
 }
+module_init(cfg80211_init);
 
 static void cfg80211_exit(void)
 {
-	nl80211_exit();
+	debugfs_remove(ieee80211_debugfs_dir);
+	cfg80211_wext_exit();
+	wiphy_sysfs_exit();
 }
-
-module_init(cfg80211_init);
 module_exit(cfg80211_exit);
--- wireless-dev.orig/net/wireless/nl80211.c	2007-02-15 14:29:49.667629166 +0100
+++ wireless-dev/net/wireless/nl80211.c	2007-02-15 15:32:26.134331360 +0100
@@ -7,11 +7,12 @@
 #include <linux/if.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <net/genetlink.h>
-#include <net/cfg80211.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/if_ether.h>
+#include <linux/nl80211.h>
+#include <net/genetlink.h>
+#include <net/cfg80211.h>
 #include "core.h"
 #include "nl80211.h"
 
@@ -42,7 +43,7 @@ static int check_information_element(str
 
 /* internal helper: get drv and dev */
 static int get_drv_dev_by_info_ifindex(struct genl_info *info,
-				       struct cfg80211_registered_driver **drv,
+				       struct cfg80211_registered_device **drv,
 				       struct net_device **dev)
 {
 	int ifindex;
@@ -55,7 +56,7 @@ static int get_drv_dev_by_info_ifindex(s
 	if (!dev)
 		return -ENODEV;
 
-	*drv = cfg80211_get_drv_from_ifindex(ifindex);
+	*drv = cfg80211_get_dev_from_ifindex(ifindex);
 	if (IS_ERR(*drv)) {
 		dev_put(*dev);
 		return PTR_ERR(*drv);
@@ -95,13 +96,13 @@ static struct nla_policy nl80211_policy[
 
 static int nl80211_get_cmdlist(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	struct sk_buff *msg;
 	void *hdr;
 	int err;
 	struct nlattr *start;
 
-	drv = cfg80211_get_drv_from_info(info);
+	drv = cfg80211_get_dev_from_info(info);
 	if (IS_ERR(drv))
 		return PTR_ERR(drv);
 
@@ -112,7 +113,7 @@ static int nl80211_get_cmdlist(struct sk
 		goto put_drv;
 	}
 
-	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->wiphy);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->idx);
 
 	start = nla_nest_start(msg, NL80211_ATTR_CMDS);
 	if (!start)
@@ -151,7 +152,7 @@ static int nl80211_get_cmdlist(struct sk
  	err = -ENOBUFS;
 	nlmsg_free(msg);
  put_drv:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	return err;
 }
 #undef CHECK_CMD
@@ -161,7 +162,7 @@ static int nl80211_get_wiphys(struct sk_
 	struct sk_buff *msg;
 	void *hdr;
 	struct nlattr *start, *indexstart;
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int idx = 1;
 
 	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
@@ -178,7 +179,7 @@ static int nl80211_get_wiphys(struct sk_
 		indexstart = nla_nest_start(msg, idx++);
 		if (!indexstart)
 			goto nla_put_failure;
-		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->wiphy);
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->idx);
 		nla_nest_end(msg, indexstart);
 	}
 	mutex_unlock(&cfg80211_drv_mutex);
@@ -230,14 +231,14 @@ static int addifidx(void *data, int ifid
 
 static int nl80211_get_intfs(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	struct sk_buff *msg;
 	void *hdr;
 	int err;
 	struct nlattr *start;
 	struct add_cb_data cb;
 
-	drv = cfg80211_get_drv_from_info(info);
+	drv = cfg80211_get_dev_from_info(info);
 	if (IS_ERR(drv))
 		return PTR_ERR(drv);
 
@@ -248,7 +249,7 @@ static int nl80211_get_intfs(struct sk_b
 		goto put_drv;
 	}
 
-	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->wiphy);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->idx);
 
 	start = nla_nest_start(msg, NL80211_ATTR_INTERFACE_LIST);
 	if (!start) {
@@ -258,7 +259,7 @@ static int nl80211_get_intfs(struct sk_b
 
 	cb.skb = msg;
 	cb.idx = 1;
-	err = drv->ops->list_interfaces(drv->priv, &cb, addifidx);
+	err = drv->ops->list_interfaces(&drv->wiphy, &cb, addifidx);
 	if (err)
 		goto msg_free;
 
@@ -274,13 +275,13 @@ static int nl80211_get_intfs(struct sk_b
  msg_free:
 	nlmsg_free(msg);
  put_drv:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	return err;
 }
 
 static int nl80211_do_inject(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	u32 flags = 0;
 	int err, queue = -1;
 
@@ -291,7 +292,7 @@ static int nl80211_do_inject(struct sk_b
 	if (info->attrs[NL80211_ATTR_QUEUE])
 		queue = (int) nla_get_u32(info->attrs[NL80211_ATTR_QUEUE]);
 
-	drv = cfg80211_get_drv_from_info(info);
+	drv = cfg80211_get_dev_from_info(info);
 	if (IS_ERR(drv))
 		return PTR_ERR(drv);
 
@@ -300,19 +301,19 @@ static int nl80211_do_inject(struct sk_b
 		goto unlock;
 	}
 
-	err = drv->ops->inject_packet(drv->priv,
+	err = drv->ops->inject_packet(&drv->wiphy,
 		nla_data(info->attrs[NL80211_ATTR_FRAME]),
 		nla_len(info->attrs[NL80211_ATTR_FRAME]),
 		flags,
 		queue);
  unlock:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	return err;
 }
 
 static int nl80211_add_virt_intf(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int err;
 	unsigned int type = NL80211_IFTYPE_UNSPECIFIED;
 
@@ -325,7 +326,7 @@ static int nl80211_add_virt_intf(struct 
 			return -EINVAL;
 	}
 
-	drv = cfg80211_get_drv_from_info(info);
+	drv = cfg80211_get_dev_from_info(info);
 	if (IS_ERR(drv))
 		return PTR_ERR(drv);
 
@@ -334,17 +335,17 @@ static int nl80211_add_virt_intf(struct 
 		goto unlock;
 	}
 
-	err = drv->ops->add_virtual_intf(drv->priv,
+	err = drv->ops->add_virtual_intf(&drv->wiphy,
 		nla_data(info->attrs[NL80211_ATTR_IFNAME]), type);
 
  unlock:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	return err;
 }
 
 static int nl80211_del_virt_intf(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int ifindex, err;
 	struct net_device *dev;
 
@@ -359,16 +360,16 @@ static int nl80211_del_virt_intf(struct 
 		goto out;
 	}
 
-	err = drv->ops->del_virtual_intf(drv->priv, ifindex);
+	err = drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
 
  out:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	return err;
 }
 
 static int nl80211_configure(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int err;
 	struct net_device *dev;
 	struct cfg80211_config config;
@@ -421,16 +422,16 @@ static int nl80211_configure(struct sk_b
 		config.channel = nla_get_u32(attr);
 	}
 
-	err = drv->ops->configure(drv->priv, dev, &config);
+	err = drv->ops->configure(&drv->wiphy, dev, &config);
  out:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	dev_put(dev);
 	return err;
 }
 
 static int nl80211_get_config(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int err;
 	struct net_device *dev;
 	struct cfg80211_config config;
@@ -448,7 +449,7 @@ static int nl80211_get_config(struct sk_
 
 	memset(&config, 0, sizeof(config));
 
-	drv->ops->get_config(drv->priv, dev, &config);
+	drv->ops->get_config(&drv->wiphy, dev, &config);
 
 	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
 			     NL80211_CMD_NEW_CONFIG);
@@ -486,14 +487,14 @@ static int nl80211_get_config(struct sk_
 	err = -ENOBUFS;
 	nlmsg_free(msg);
  out_put_drv:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	dev_put(dev);
 	return err;
 }
 
 static int nl80211_set_roaming(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int err;
 	struct net_device *dev;
 	int roaming_control;
@@ -514,16 +515,16 @@ static int nl80211_set_roaming(struct sk
 		goto out;
 	}
 
-	err = drv->ops->set_roaming(drv->priv, dev, roaming_control);
+	err = drv->ops->set_roaming(&drv->wiphy, dev, roaming_control);
  out:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	dev_put(dev);
 	return err;
 }
 
 static int nl80211_get_roaming(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int err;
 	struct net_device *dev;
 	struct sk_buff *msg;
@@ -538,7 +539,7 @@ static int nl80211_get_roaming(struct sk
 		goto out_put_drv;
 	}
 
-	err = drv->ops->get_roaming(drv->priv, dev);
+	err = drv->ops->get_roaming(&drv->wiphy, dev);
 	if (err < 0)
 		goto out_put_drv;
 
@@ -561,14 +562,14 @@ static int nl80211_get_roaming(struct sk
 	err = -ENOBUFS;
 	nlmsg_free(msg);
  out_put_drv:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	dev_put(dev);
 	return err;
 }
 
 static int nl80211_set_fixed_bssid(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int err;
 	struct net_device *dev;
 	u8 *bssid;
@@ -586,16 +587,16 @@ static int nl80211_set_fixed_bssid(struc
 		goto out;
 	}
 
-	err = drv->ops->set_fixed_bssid(drv->priv, dev, bssid);
+	err = drv->ops->set_fixed_bssid(&drv->wiphy, dev, bssid);
  out:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	dev_put(dev);
 	return err;
 }
 
 static int nl80211_get_fixed_bssid(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int err;
 	struct net_device *dev;
 	struct sk_buff *msg;
@@ -611,7 +612,7 @@ static int nl80211_get_fixed_bssid(struc
 		goto out_put_drv;
 	}
 
-	err = drv->ops->get_fixed_bssid(drv->priv, dev, bssid);
+	err = drv->ops->get_fixed_bssid(&drv->wiphy, dev, bssid);
 	if (err < 0)
 		goto out_put_drv;
 
@@ -634,14 +635,14 @@ static int nl80211_get_fixed_bssid(struc
 	err = -ENOBUFS;
 	nlmsg_free(msg);
  out_put_drv:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	dev_put(dev);
 	return err;
 }
 
 static int nl80211_get_association(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int err;
 	struct net_device *dev;
 	struct sk_buff *msg;
@@ -657,7 +658,7 @@ static int nl80211_get_association(struc
 		goto out_put_drv;
 	}
 
-	err = drv->ops->get_association(drv->priv, dev, bssid);
+	err = drv->ops->get_association(&drv->wiphy, dev, bssid);
 	if (err < 0)
 		goto out_put_drv;
 
@@ -681,17 +682,17 @@ static int nl80211_get_association(struc
 	err = -ENOBUFS;
 	nlmsg_free(msg);
  out_put_drv:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	dev_put(dev);
 	return err;
 }
 
 static int nl80211_assoc_deauth(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int err;
 	struct net_device *dev;
-	int (*act)(void *priv, struct net_device *dev);
+	int (*act)(struct wiphy *wiphy, struct net_device *dev);
 
 	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
 	if (err)
@@ -716,9 +717,9 @@ static int nl80211_assoc_deauth(struct s
 		goto out;
 	}
 
-	err = act(drv->priv, dev);
+	err = act(&drv->wiphy, dev);
  out:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	dev_put(dev);
 	return err;
 }
@@ -744,7 +745,7 @@ static int add_bssid(void *data, u8 *bss
 
 static int nl80211_get_auth_list(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	struct net_device *dev;
 	struct sk_buff *msg;
 	void *hdr;
@@ -778,7 +779,7 @@ static int nl80211_get_auth_list(struct 
 
 	cb.skb = msg;
 	cb.idx = 1;
-	err = drv->ops->get_auth_list(drv->priv, dev, &cb, add_bssid);
+	err = drv->ops->get_auth_list(&drv->wiphy, dev, &cb, add_bssid);
 	if (err)
 		goto msg_free;
 
@@ -794,14 +795,14 @@ static int nl80211_get_auth_list(struct 
  msg_free:
 	nlmsg_free(msg);
  put_drv:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	dev_put(dev);
 	return err;
 }
 
 static int nl80211_initiate_scan(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int err;
 	struct net_device *dev;
 	struct scan_params params;
@@ -874,11 +875,11 @@ static int nl80211_initiate_scan(struct 
 	params.channels = channels;
 	params.n_channels = count;
 
-	err = drv->ops->initiate_scan(drv->priv, dev, &params);
+	err = drv->ops->initiate_scan(&drv->wiphy, dev, &params);
 
 	kfree(channels);
  out:
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
 	dev_put(dev);
 	return err;
 }
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/wireless/sysfs.c	2007-02-15 14:29:54.567629166 +0100
@@ -0,0 +1,85 @@
+/*
+ * This file provides /sys/class/ieee80211/<wiphy name>/
+ * and some default attributes.
+ *
+ * Copyright 2005-2006	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2006	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This file is GPLv2 as found in COPYING.
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <net/cfg80211.h>
+#include "core.h"
+
+static inline struct cfg80211_registered_device *cdev_to_dev(
+	struct class_device *cdev)
+{
+	return container_of(cdev, struct cfg80211_registered_device, wiphy.class_dev);
+}
+
+static ssize_t _show_index(struct class_device *cdev, char *buf)
+{
+	return sprintf(buf, "%d\n", cdev_to_dev(cdev)->idx);
+}
+
+static ssize_t _show_permaddr(struct class_device *cdev, char *buf)
+{
+	char *addr = cdev_to_dev(cdev)->wiphy.perm_addr;
+
+	return sprintf(buf, "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
+		       addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
+}
+
+static struct class_device_attribute ieee80211_class_dev_attrs[] = {
+	__ATTR(index, S_IRUGO, _show_index, NULL),
+	__ATTR(macaddress, S_IRUGO, _show_permaddr, NULL),
+
+	{}
+};
+
+static void wiphy_class_dev_release(struct class_device *cdev)
+{
+	struct cfg80211_registered_device *dev = cdev_to_dev(cdev);
+
+	cfg80211_dev_free(dev);
+}
+
+static int wiphy_uevent(struct class_device *cdev, char **envp,
+			int num_envp, char *buf, int size)
+{
+	return 0;
+}
+
+static struct class ieee80211_class = {
+	.name = "ieee80211",
+	.owner = THIS_MODULE,
+	.release = wiphy_class_dev_release,
+	.class_dev_attrs = ieee80211_class_dev_attrs,
+#ifdef CONFIG_HOTPLUG
+	.uevent = wiphy_uevent,
+#endif
+};
+
+int wiphy_sysfs_init(void)
+{
+	return class_register(&ieee80211_class);
+}
+
+void wiphy_sysfs_exit(void)
+{
+	class_unregister(&ieee80211_class);
+}
+
+int wiphy_sysfs_add(struct wiphy *wiphy)
+{
+	wiphy->class_dev.class = &ieee80211_class;
+	wiphy->class_dev.class_data = wiphy;
+	return class_device_add(&wiphy->class_dev);
+}
+
+void wiphy_sysfs_del(struct wiphy *wiphy)
+{
+	class_device_del(&wiphy->class_dev);
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/wireless/sysfs.h	2007-02-15 14:29:54.567629166 +0100
@@ -0,0 +1,10 @@
+#ifndef __WIRELESS_SYSFS_H
+#define __WIRELESS_SYSFS_H
+
+extern int wiphy_sysfs_init(void);
+extern void wiphy_sysfs_exit(void);
+
+extern int wiphy_sysfs_add(struct wiphy *wiphy);
+extern void wiphy_sysfs_del(struct wiphy *wiphy);
+
+#endif /* __WIRELESS_SYSFS_H */
--- wireless-dev.orig/net/wireless/Makefile	2007-02-15 14:29:54.477629166 +0100
+++ wireless-dev/net/wireless/Makefile	2007-02-15 14:29:54.577629166 +0100
@@ -1,6 +1,6 @@
 obj-$(CONFIG_CFG80211) += cfg80211.o
 
-cfg80211-y += core.o nl80211.o
+cfg80211-y += core.o sysfs.o nl80211.o
 cfg80211-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-compat.o
 
 ifeq ($(CONFIG_CFG80211),m)
--- wireless-dev.orig/include/net/wireless.h	2007-02-15 14:29:54.437629166 +0100
+++ wireless-dev/include/net/wireless.h	2007-02-15 15:32:22.414331360 +0100
@@ -2,6 +2,130 @@
 #define __NET_WIRELESS_H
 
 /*
+ * 802.11 device management
+ *
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include <linux/netdevice.h>
+#include <linux/debugfs.h>
+#include <net/cfg80211.h>
+
+/**
+ * struct wiphy - wireless hardware description
+ * @idx: the wiphy index assigned to this item
+ * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
+ */
+struct wiphy {
+	/* assign these fields before you register the wiphy */
+
+	/* permanent MAC address */
+	u8 perm_addr[ETH_ALEN];
+
+	/* fields below are read-only, assigned by cfg80211 */
+
+	/* dir in /sys/class/ieee80211/, you need
+	 * to assign its dev pointer */
+	struct class_device class_dev;
+
+	/* dir in debugfs: ieee80211/<wiphyname> */
+	struct dentry *debugfsdir;
+
+	char priv[0] __attribute__((__aligned__(NETDEV_ALIGN)));
+};
+
+/** struct wireless_dev - wireless per-netdev state
+ *
+ * This structure must be allocated by the driver/stack
+ * that uses the ieee80211_ptr field in struct net_device
+ * (this is intentional so it can be allocated along with
+ * the netdev.)
+ *
+ * @wiphy: pointer to hardware description
+ */
+struct wireless_dev {
+	struct wiphy *wiphy;
+};
+
+/**
+ * wiphy_priv - return priv from wiphy
+ */
+static inline void *wiphy_priv(struct wiphy *wiphy)
+{
+	BUG_ON(!wiphy);
+	return &wiphy->priv;
+}
+
+/**
+ * set_wiphy_dev - set device pointer for wiphy
+ */
+static inline void set_wiphy_dev(struct wiphy *wiphy, struct device *dev)
+{
+	wiphy->class_dev.dev = dev;
+}
+
+/**
+ * wiphy_dev - get wiphy dev pointer
+ */
+static inline struct device *wiphy_dev(struct wiphy *wiphy)
+{
+	return wiphy->class_dev.dev;
+}
+
+/**
+ * wiphy_name - get wiphy name
+ */
+static inline char *wiphy_name(struct wiphy *wiphy)
+{
+	return wiphy->class_dev.class_id;
+}
+
+/**
+ * wdev_priv - return wiphy priv from wireless_dev
+ */
+static inline void *wdev_priv(struct wireless_dev *wdev)
+{
+	BUG_ON(!wdev);
+	return wiphy_priv(wdev->wiphy);
+}
+
+/**
+ * wiphy_new - create a new wiphy for use with cfg80211
+ *
+ * create a new wiphy and associate the given operations with it.
+ * @sizeof_priv bytes are allocated for private use.
+ *
+ * the returned pointer must be assigned to each netdev's
+ * ieee80211_ptr for proper operation.
+ */
+struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv);
+
+/**
+ * wiphy_register - register a wiphy with cfg80211
+ *
+ * register the given wiphy
+ *
+ * Returns a non-negative wiphy index or a negative error code.
+ */
+extern int wiphy_register(struct wiphy *wiphy);
+
+/**
+ * wiphy_unregister - deregister a wiphy from cfg80211
+ *
+ * unregister a device with the given priv pointer.
+ * After this call, no more requests can be made with this priv
+ * pointer, but the call may sleep to wait for an outstanding
+ * request that is being handled.
+ */
+extern void wiphy_unregister(struct wiphy *wiphy);
+
+/**
+ * wiphy_free - free wiphy
+ */
+extern void wiphy_free(struct wiphy *wiphy);
+
+
+/*
  * internal definitions for wireless
  */
 
--- wireless-dev.orig/net/wireless/wext-compat.c	2007-02-15 14:29:54.427629166 +0100
+++ wireless-dev/net/wireless/wext-compat.c	2007-02-15 15:32:22.654331360 +0100
@@ -68,7 +68,7 @@ static void cfg80211_wx_start_commit_tim
 }
 
 static struct cfg80211_config *cfg80211_ensure_pending_cfg(
-	struct cfg80211_registered_driver *drv)
+	struct cfg80211_registered_device *drv)
 {
 	struct cfg80211_config *cfg = drv->wext_pending_config;
 	if (!cfg)
@@ -80,7 +80,7 @@ static struct cfg80211_config *cfg80211_
 	return cfg;
 }
 
-static int cfg80211_wx_set_commit(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_commit(struct cfg80211_registered_device *drv,
 				  struct net_device *net_dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *data,
@@ -103,7 +103,7 @@ static int cfg80211_wx_set_commit(struct
 	return err;
 }
 
-static int cfg80211_wx_get_name(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_name(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -114,7 +114,7 @@ static int cfg80211_wx_get_name(struct c
 	return err;
 }
 
-static int cfg80211_wx_set_nwid(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_nwid(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -125,7 +125,7 @@ static int cfg80211_wx_set_nwid(struct c
 	return err;
 }
 
-static int cfg80211_wx_get_nwid(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_nwid(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -136,7 +136,7 @@ static int cfg80211_wx_get_nwid(struct c
 	return err;
 }
 
-static int cfg80211_wx_set_freq(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_freq(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -147,7 +147,7 @@ static int cfg80211_wx_set_freq(struct c
 	return err;
 }
 
-static int cfg80211_wx_get_freq(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_freq(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -158,7 +158,7 @@ static int cfg80211_wx_get_freq(struct c
 	return err;
 }
 
-static int cfg80211_wx_set_mode(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_mode(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -169,7 +169,7 @@ static int cfg80211_wx_set_mode(struct c
 	return err;
 }
 
-static int cfg80211_wx_get_mode(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_mode(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -180,7 +180,7 @@ static int cfg80211_wx_get_mode(struct c
 	return err;
 }
 
-static int cfg80211_wx_set_sens(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_sens(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -191,7 +191,7 @@ static int cfg80211_wx_set_sens(struct c
 	return err;
 }
 
-static int cfg80211_wx_get_sens(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_sens(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -202,7 +202,7 @@ static int cfg80211_wx_get_sens(struct c
 	return err;
 }
 
-static int cfg80211_wx_set_range(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_range(struct cfg80211_registered_device *drv,
 				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
@@ -213,7 +213,7 @@ static int cfg80211_wx_set_range(struct 
 	return err;
 }
 
-static int cfg80211_wx_get_range(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_range(struct cfg80211_registered_device *drv,
 				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
@@ -224,7 +224,7 @@ static int cfg80211_wx_get_range(struct 
 	return err;
 }
 
-static int cfg80211_wx_set_ap(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_ap(struct cfg80211_registered_device *drv,
 			      struct net_device *net_dev,
 			      struct iw_request_info *info,
 			      union iwreq_data *data,
@@ -242,7 +242,7 @@ static int cfg80211_wx_set_ap(struct cfg
 	return err;
 }
 
-static int cfg80211_wx_get_ap(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_ap(struct cfg80211_registered_device *drv,
 			      struct net_device *net_dev,
 			      struct iw_request_info *info,
 			      union iwreq_data *data,
@@ -258,7 +258,7 @@ static int cfg80211_wx_get_ap(struct cfg
 	return err;
 }
 
-static int cfg80211_wx_set_mlme(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_mlme(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -269,7 +269,7 @@ static int cfg80211_wx_set_mlme(struct c
 	return err;
 }
 
-static int cfg80211_wx_get_waplist(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_waplist(struct cfg80211_registered_device *drv,
 				   struct net_device *net_dev,
 				   struct iw_request_info *info,
 				   union iwreq_data *data,
@@ -280,7 +280,7 @@ static int cfg80211_wx_get_waplist(struc
 	return err;
 }
 
-static int cfg80211_wx_set_scan(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_scan(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -291,7 +291,7 @@ static int cfg80211_wx_set_scan(struct c
 	return err;
 }
 
-static int cfg80211_wx_get_scan(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_scan(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -302,7 +302,7 @@ static int cfg80211_wx_get_scan(struct c
 	return err;
 }
 
-static int cfg80211_wx_set_essid(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_essid(struct cfg80211_registered_device *drv,
 				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
@@ -333,7 +333,7 @@ static int cfg80211_wx_set_essid(struct 
 	return err;
 }
 
-static int cfg80211_wx_get_essid(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_essid(struct cfg80211_registered_device *drv,
 				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
@@ -344,7 +344,7 @@ static int cfg80211_wx_get_essid(struct 
 	return err;
 }
 
-static int cfg80211_wx_set_rate(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_rate(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -355,7 +355,7 @@ static int cfg80211_wx_set_rate(struct c
 	return err;
 }
 
-static int cfg80211_wx_get_rate(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_rate(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -366,7 +366,7 @@ static int cfg80211_wx_get_rate(struct c
 	return err;
 }
 
-static int cfg80211_wx_set_rts(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_rts(struct cfg80211_registered_device *drv,
 			       struct net_device *net_dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *data,
@@ -377,7 +377,7 @@ static int cfg80211_wx_set_rts(struct cf
 	return err;
 }
 
-static int cfg80211_wx_get_rts(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_rts(struct cfg80211_registered_device *drv,
 			       struct net_device *net_dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *data,
@@ -388,7 +388,7 @@ static int cfg80211_wx_get_rts(struct cf
 	return err;
 }
 
-static int cfg80211_wx_set_frag(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_frag(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -399,7 +399,7 @@ static int cfg80211_wx_set_frag(struct c
 	return err;
 }
 
-static int cfg80211_wx_get_frag(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_frag(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -410,7 +410,7 @@ static int cfg80211_wx_get_frag(struct c
 	return err;
 }
 
-static int cfg80211_wx_set_txpow(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_txpow(struct cfg80211_registered_device *drv,
 				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
@@ -421,7 +421,7 @@ static int cfg80211_wx_set_txpow(struct 
 	return err;
 }
 
-static int cfg80211_wx_get_txpow(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_txpow(struct cfg80211_registered_device *drv,
 				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
@@ -432,7 +432,7 @@ static int cfg80211_wx_get_txpow(struct 
 	return err;
 }
 
-static int cfg80211_wx_set_retry(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_retry(struct cfg80211_registered_device *drv,
 				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
@@ -443,7 +443,7 @@ static int cfg80211_wx_set_retry(struct 
 	return err;
 }
 
-static int cfg80211_wx_get_retry(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_retry(struct cfg80211_registered_device *drv,
 				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
@@ -454,7 +454,7 @@ static int cfg80211_wx_get_retry(struct 
 	return err;
 }
 
-static int cfg80211_wx_set_encode(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_encode(struct cfg80211_registered_device *drv,
 				  struct net_device *net_dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *data,
@@ -465,7 +465,7 @@ static int cfg80211_wx_set_encode(struct
 	return err;
 }
 
-static int cfg80211_wx_get_encode(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_encode(struct cfg80211_registered_device *drv,
 				  struct net_device *net_dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *data,
@@ -476,7 +476,7 @@ static int cfg80211_wx_get_encode(struct
 	return err;
 }
 
-static int cfg80211_wx_set_power(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_power(struct cfg80211_registered_device *drv,
 				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
@@ -487,7 +487,7 @@ static int cfg80211_wx_set_power(struct 
 	return err;
 }
 
-static int cfg80211_wx_get_power(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_power(struct cfg80211_registered_device *drv,
 				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
@@ -498,7 +498,7 @@ static int cfg80211_wx_get_power(struct 
 	return err;
 }
 
-static int cfg80211_wx_set_genie(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_genie(struct cfg80211_registered_device *drv,
 				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
@@ -509,7 +509,7 @@ static int cfg80211_wx_set_genie(struct 
 	return err;
 }
 
-static int cfg80211_wx_get_genie(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_genie(struct cfg80211_registered_device *drv,
 				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
@@ -520,7 +520,7 @@ static int cfg80211_wx_get_genie(struct 
 	return err;
 }
 
-static int cfg80211_wx_set_auth(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_auth(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -531,7 +531,7 @@ static int cfg80211_wx_set_auth(struct c
 	return err;
 }
 
-static int cfg80211_wx_get_auth(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_auth(struct cfg80211_registered_device *drv,
 				struct net_device *net_dev,
 				struct iw_request_info *info,
 				union iwreq_data *data,
@@ -542,7 +542,7 @@ static int cfg80211_wx_get_auth(struct c
 	return err;
 }
 
-static int cfg80211_wx_set_encodeext(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_encodeext(struct cfg80211_registered_device *drv,
 				     struct net_device *net_dev,
 				     struct iw_request_info *info,
 				     union iwreq_data *data,
@@ -553,7 +553,7 @@ static int cfg80211_wx_set_encodeext(str
 	return err;
 }
 
-static int cfg80211_wx_get_encodeext(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_get_encodeext(struct cfg80211_registered_device *drv,
 				     struct net_device *net_dev,
 				     struct iw_request_info *info,
 				     union iwreq_data *data,
@@ -564,7 +564,7 @@ static int cfg80211_wx_get_encodeext(str
 	return err;
 }
 
-static int cfg80211_wx_set_wpmksa(struct cfg80211_registered_driver *drv,
+static int cfg80211_wx_set_wpmksa(struct cfg80211_registered_device *drv,
 				  struct net_device *net_dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *data,
@@ -576,7 +576,7 @@ static int cfg80211_wx_set_wpmksa(struct
 }
 
 
-typedef int (*iw_compat_handler)(struct cfg80211_registered_driver *drv,
+typedef int (*iw_compat_handler)(struct cfg80211_registered_device *drv,
 				 struct net_device *dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *wrqu,
@@ -644,7 +644,7 @@ static iw_compat_handler get_handler(uns
  * this is sort of backwards and wouldn't need to call
  * get_wireless_stats, but it was easier to just copy the code...
  */
-static int iw_handler_get_iwstats(struct cfg80211_registered_driver *drv,
+static int iw_handler_get_iwstats(struct cfg80211_registered_device *drv,
 				  struct net_device *dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *wrqu,
@@ -674,7 +674,7 @@ static int iw_handler_get_iwstats(struct
  * We do various checks and also take care of moving data between
  * user space and kernel space.
  */
-static int ioctl_standard_call(struct cfg80211_registered_driver *drv,
+static int ioctl_standard_call(struct cfg80211_registered_device *drv,
 			       struct net_device *dev,
 			       struct ifreq *ifr,
 			       unsigned int cmd,
@@ -809,7 +809,7 @@ int cfg80211_wext_ioctl(struct ifreq *if
 {
 	struct net_device *dev;
 	iw_compat_handler handler;
-	struct cfg80211_registered_driver *drv;
+	struct cfg80211_registered_device *drv;
 	int err;
 
 	/* Permissions are already checked in dev_ioctl() before calling us.
@@ -819,7 +819,7 @@ int cfg80211_wext_ioctl(struct ifreq *if
 	if (!dev)
 		return -ENODEV;
 
-	drv = cfg80211_get_drv_from_ifindex(dev->ifindex);
+	drv = cfg80211_get_dev_from_ifindex(dev->ifindex);
 	if (IS_ERR(drv)) {
 		err = PTR_ERR(drv);
 		goto out_put_dev;
@@ -846,7 +846,7 @@ int cfg80211_wext_ioctl(struct ifreq *if
 				err = -EOPNOTSUPP;
 	}
 
-	cfg80211_put_drv(drv);
+	cfg80211_put_dev(drv);
  out_put_dev:
 	dev_put(dev);
 	return err;

--

