Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946626AbXBIQdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 11:33:44 -0500
Received: from [84.135.215.182] (helo=johannes.berg)
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HFYdX-0003cv-Hb
	for linux-wireless@vger.kernel.org; Fri, 09 Feb 2007 16:30:19 +0000
Message-Id: <20070209162526.489839000@sipsolutions.net>
References: <20070209162414.043158000@sipsolutions.net>
Date: Fri, 09 Feb 2007 17:24:15 +0100
From: johannes@sipsolutions.net
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] cfg80211: update to code submitted to mainline
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This updates cfg80211 to be really similar to the code
I submitted for mainline.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/netdevice.h  |    8 
 include/linux/nl80211.h    |    5 
 include/net/cfg80211.h     |  134 +++-
 include/net/iw_handler.h   |    3 
 include/net/wireless.h     |   23 
 net/Kconfig                |   14 
 net/core/dev.c             |   67 --
 net/wireless/Makefile      |   24 
 net/wireless/core.c        |  166 +++---
 net/wireless/core.h        |   43 -
 net/wireless/nl80211.c     |   78 --
 net/wireless/sysfs.c       |   65 ++
 net/wireless/sysfs.h       |   10 
 net/wireless/wext-common.c |   65 ++
 net/wireless/wext-compat.c | 1231 ++++++++-------------------------------------
 net/wireless/wext-export.c |   29 +
 net/wireless/wext-mod.c    |   20 
 net/wireless/wext-old.c    |   14 
 net/wireless/wext.h        |   42 +
 19 files changed, 701 insertions(+), 1340 deletions(-)

--- wireless-dev.orig/include/linux/netdevice.h	2007-02-09 17:08:25.543840519 +0100
+++ wireless-dev/include/linux/netdevice.h	2007-02-09 17:08:44.023840519 +0100
@@ -42,6 +42,8 @@
 struct vlan_group;
 struct ethtool_ops;
 struct netpoll_info;
+/* 802.11 specific */
+struct wiphy;
 					/* source back-compat hooks */
 #define SET_ETHTOOL_OPS(netdev,ops) \
 	( (netdev)->ethtool_ops = (ops) )
@@ -355,10 +357,6 @@ struct net_device
 	/* Instance data managed by the core of Wireless Extensions. */
 	struct iw_public_data *	wireless_data;
 #endif
-#ifdef CONFIG_CFG80211_WEXT_COMPAT
-	/* pending config used by cfg80211/wext compat code only */
-	void *cfg80211_wext_pending_config;
-#endif
 	const struct ethtool_ops *ethtool_ops;
 
 	/*
@@ -403,7 +401,7 @@ struct net_device
 	void                    *ip6_ptr;       /* IPv6 specific data */
 	void			*ec_ptr;	/* Econet specific data	*/
 	void			*ax25_ptr;	/* AX.25 specific data */
-	void			*ieee80211_ptr;	/* IEEE 802.11 specific data */
+	struct wiphy		*ieee80211_ptr;	/* IEEE 802.11 specific data */
 
 /*
  * Cache line mostly used on receive path (including eth_type_trans())
--- wireless-dev.orig/include/net/cfg80211.h	2007-02-09 17:08:25.833840519 +0100
+++ wireless-dev/include/net/cfg80211.h	2007-02-09 17:08:44.033840519 +0100
@@ -2,19 +2,45 @@
 #define __NET_CFG80211_H
 
 #include <linux/netlink.h>
-#include <linux/nl80211.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <net/genetlink.h>
 #include <linux/wireless.h>
+#include <linux/device.h>
 
 /*
- * 802.11 configuration in-kernel interface
+ * 802.11 configuration and wiphy management in-kernel interface
  *
  * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
  */
 
 /**
+ * struct wiphy
+ *
+ * @wiphy_index: the wiphy index assigned to this item
+ * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
+ * @name: name of this wiphy
+ */
+struct wiphy {
+	/* assign these fields before you register the wiphy */
+
+	/* permanent MAC address */
+	u8 perm_addr[ETH_ALEN];
+
+	/* the actual hardware */
+	struct device *dev;
+
+	/* fields below are read-only, assigned by cfg80211 */
+
+	/* index assigned to this wiphy */
+	int wiphy_index;
+	/* dir in /sys/class/ieee80211/ */
+	struct class_device class_dev;
+
+	char priv[0] __attribute__((__aligned__(NETDEV_ALIGN)));
+};
+
+/**
  * struct cfg80211_config - description of a configuration (request)
  */
 struct cfg80211_config {
@@ -63,18 +89,12 @@ struct scan_params {
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
- * @inject_packet: inject the given frame with the NL80211_FLAG_*
- *		   flags onto the given queue.
+ * @list_interfaces: Call the one() function with the given data and the
+ *                   ifindex for each interface belonging to the wiphy.
+ *		     This callback is required.
  *
  * @add_virtual_intf: create a new virtual interface with the given name
  *
@@ -82,13 +102,17 @@ struct scan_params {
  *
  * @configure: configure the given interface as requested in the config struct.
  *	       must not ignore any configuration item, if something is
- *	       is requested that cannot be fulfilled return an error
+ *	       is requested that cannot be fulfilled return an error.
+ *             This call does not actually initiate any association or such.
  *
  * @get_config: fill the given config structure with the current configuration
  *
  * @get_config_valid: return a bitmask of CFG80211_CFG_VALID_* indicating
  *		      which parameters can be set.
  *
+ * @associate: associate with previously given settings (SSID, BSSID
+ *             if userspace roaming is enabled)
+ *
  * @reassociate: reassociate with current settings (SSID, BSSID if
  *		 userspace roaming is enabled)
  *
@@ -118,74 +142,93 @@ struct scan_params {
  *		   is to be passed to that callback
  */
 struct cfg80211_ops {
-	int	(*list_interfaces)(void *priv, void *data,
+	int	(*list_interfaces)(struct wiphy *wiphy, void *data,
 				   int (*one)(void *data, int ifindex));
 
 
-	int	(*inject_packet)(void *priv, void *frame, int framelen,
-				 u32 flags, int queue);
-
-
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
+	int	(*associate)(struct wiphy *wiphy, struct net_device *dev);
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
 
 /**
- * cfg80211_register - register a wiphy with cfg80211
+ * wiphy_priv - return priv from wiphy
+ */
+static inline void *wiphy_priv(struct wiphy *wiphy)
+{
+	return &wiphy->priv;
+}
+
+/**
+ * wiphy_new - create a new wiphy for use with cfg80211
  *
- * register a given method structure with the cfg80211 system
- * and associate the 'priv' pointer with it.
+ * create a new wiphy and associate the given operations with it.
+ * @sizeof_priv bytes are allocated for private use.
  *
- * Returns a non-negative wiphy index or a negative error code.
+ * the returned pointer must be assigned to each netdev's
+ * ieee80211_ptr for proper operation.
+ */
+struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv);
+
+/**
+ * wiphy_register - register a wiphy with cfg80211
  *
- * NOTE: for proper operation, this priv pointer MUST also be
- * assigned to each &struct net_device's @ieee80211_ptr member!
+ * register the given wiphy
+ *
+ * Returns a non-negative wiphy index or a negative error code.
  */
-extern int cfg80211_register(struct cfg80211_ops *ops, void *priv);
+extern int wiphy_register(struct wiphy *wiphy);
 
 /**
- * cfg80211_unregister - deregister a wiphy from cfg80211
+ * wiphy_unregister - deregister a wiphy from cfg80211
  *
  * unregister a device with the given priv pointer.
  * After this call, no more requests can be made with this priv
  * pointer, but the call may sleep to wait for an outstanding
  * request that is being handled.
  */
-extern void cfg80211_unregister(void *priv);
+extern void wiphy_unregister(struct wiphy *wiphy);
+
+/**
+ * wiphy_free - free wiphy
+ */
+extern void wiphy_free(struct wiphy *wiphy);
+
 
 /* helper functions specific to nl80211 */
 extern void *nl80211hdr_put(struct sk_buff *skb, u32 pid,
@@ -193,13 +236,4 @@ extern void *nl80211hdr_put(struct sk_bu
 extern void *nl80211msg_new(struct sk_buff **skb, u32 pid,
 			    u32 seq, int flags, u8 cmd);
 
-#ifdef CONFIG_CFG80211_WEXT_COMPAT
-extern int cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
-#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
-int cfg80211_wext_nl_set(struct net_device *dev, char *data, int len);
-int cfg80211_wext_nl_get(struct net_device *dev, char *data, int len,
-			 char **p_buf, int *p_len);
-#endif
-#endif
-
 #endif /* __NET_CFG80211_H */
--- wireless-dev.orig/net/wireless/Makefile	2007-02-09 17:08:26.033840519 +0100
+++ wireless-dev/net/wireless/Makefile	2007-02-09 17:08:44.033840519 +0100
@@ -1,16 +1,16 @@
 obj-$(CONFIG_CFG80211) += cfg80211.o
 
-cfg80211-objs := \
-	core.o nl80211.o
+cfg80211-y += core.o sysfs.o nl80211.o
+cfg80211-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-compat.o
 
-obj-$(CONFIG_WIRELESS_EXT) += wext-old.o
+ifeq ($(CONFIG_CFG80211),m)
+obj-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-export.o
+cfg80211-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-mod.o
+# we need something to tell us what's up...
+# but we can't use #ifdef MODULE because we also need to
+# know in the part that is built in (namely wext-common.c)
+CFLAGS += -DCFG80211_MODULE
+endif
 
-obj-nn :=
-obj-yy :=
-obj-yn :=
-obj-ny :=
-
-# this needs to be compiled in...
-obj-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-compat.o
-obj-$(CONFIG_CFG80211_WEXT_COMPAT)$(CONFIG_NET_WIRELESS) += wext-common.o
-obj-y += $(obj-yy) $(obj-yn) $(obj-ny)
+obj-$(CONFIG_WIRELESS_EXT) += wext-common.o wext-old.o
+obj-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-common.o
--- wireless-dev.orig/net/wireless/core.c	2007-02-09 17:08:26.093840519 +0100
+++ wireless-dev/net/wireless/core.c	2007-02-09 17:08:44.033840519 +0100
@@ -1,21 +1,24 @@
 /*
- * This is the new wireless configuration interface.
+ * This is the linux wireless configuration interface.
  *
- * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006, 2007		Johannes Berg <johannes@sipsolutions.net>
  */
 
-#include "core.h"
-#include "nl80211.h"
 #include <linux/if.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <net/genetlink.h>
-#include <net/cfg80211.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/nl80211.h>
+#include <net/genetlink.h>
+#include <net/cfg80211.h>
+#include "core.h"
+#include "sysfs.h"
+#include "wext.h"
 
 MODULE_AUTHOR("Johannes Berg");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("wireless configuration support");
 
 /* RCU might be appropriate here since we usually
  * only read the list, and that can happen quite
@@ -24,31 +27,13 @@ LIST_HEAD(cfg80211_drv_list);
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
-
 /* requires cfg80211_drv_mutex to be held! */
 static struct cfg80211_registered_driver *cfg80211_drv_by_wiphy(int wiphy)
 {
 	struct cfg80211_registered_driver *result = NULL, *drv;
 
 	list_for_each_entry(drv, &cfg80211_drv_list, list) {
-		if (drv->wiphy == wiphy) {
+		if (drv->wiphy.wiphy_index == wiphy) {
 			result = drv;
 			break;
 		}
@@ -76,7 +61,8 @@ __cfg80211_drv_from_info(struct genl_inf
 		ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
 		dev = dev_get_by_index(ifindex);
 		if (dev) {
-			byifidx = cfg80211_drv_by_priv(dev->ieee80211_ptr);
+			if (dev->ieee80211_ptr)
+				byifidx = wiphy_to_drv(dev->ieee80211_ptr);
 			dev_put(dev);
 		}
 		err = -ENODEV;
@@ -116,7 +102,6 @@ cfg80211_get_drv_from_info(struct genl_i
 	return drv;
 }
 
-/* wext will need this */
 struct cfg80211_registered_driver *
 cfg80211_get_drv_from_ifindex(int ifindex)
 {
@@ -127,11 +112,11 @@ cfg80211_get_drv_from_ifindex(int ifinde
 	dev = dev_get_by_index(ifindex);
 	if (!dev)
 		goto out;
-	drv = cfg80211_drv_by_priv(dev->ieee80211_ptr);
+	drv = wiphy_to_drv(dev->ieee80211_ptr);
 	if (drv)
 		mutex_lock(&drv->mtx);
 	else
-		drv = ERR_PTR(-ENOSYS);
+		drv = ERR_PTR(-ENODEV);
 	dev_put(dev);
  out:
 	mutex_unlock(&cfg80211_drv_mutex);
@@ -146,63 +131,72 @@ void cfg80211_put_drv(struct cfg80211_re
 
 /* exported functions */
 
-int cfg80211_register(struct cfg80211_ops *ops, void *priv)
+struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
 {
-	struct cfg80211_registered_driver *drv;
-	int res;
+	struct cfg80211_registered_driver *result;
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
+	mutex_init(&result->mtx);
+	/* special index -1: newly created */
+	result->wiphy.wiphy_index = -1;
 
-	drv->ops = ops;
-	drv->priv = priv;
+	return &result->wiphy;
+}
+EXPORT_SYMBOL(wiphy_new);
+
+int wiphy_register(struct wiphy *wiphy)
+{
+	struct cfg80211_registered_driver *drv = wiphy_to_drv(wiphy);
+	int res;
+
+	if (wiphy->wiphy_index != -1)
+		return -EINVAL;
+
+	mutex_lock(&cfg80211_drv_mutex);
 
 	if (unlikely(wiphy_counter<0)) {
 		/* ugh, wrapped! */
-		kfree(drv);
 		res = -ENOSPC;
 		goto out_unlock;
 	}
-	mutex_init(&drv->mtx);
-	drv->wiphy = wiphy_counter;
+	drv->wiphy.wiphy_index = wiphy_counter;
 	list_add(&drv->list, &cfg80211_drv_list);
-	/* return wiphy number */
-	res = drv->wiphy;
+
+	/* give it a proper name */
+	snprintf(drv->wiphy.class_dev.class_id, BUS_ID_SIZE,
+		 "wiphy%d", drv->wiphy.wiphy_index);
+
+	res = wiphy_sysfs_add(&drv->wiphy);
+	if (res)
+		goto out_unlock;
 
 	/* now increase counter for the next time */
 	wiphy_counter++;
 
+	/* return wiphy number */
+	res = drv->wiphy.wiphy_index;
+
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
+	struct cfg80211_registered_driver *drv = wiphy_to_drv(wiphy);
 
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
@@ -211,35 +205,49 @@ void cfg80211_unregister(void *priv)
 	mutex_unlock(&drv->mtx);
 
 	mutex_unlock(&cfg80211_drv_mutex);
+}
+EXPORT_SYMBOL(wiphy_unregister);
 
+void cfg80211_drv_free(struct cfg80211_registered_driver *drv)
+{
 	mutex_destroy(&drv->mtx);
 	kfree(drv);
 }
-EXPORT_SYMBOL_GPL(cfg80211_unregister);
 
-/* module initialisation/exit functions */
+void wiphy_free(struct wiphy *wiphy)
+{
+	if (wiphy->wiphy_index != -1)
+		wiphy_sysfs_del(wiphy);
+	else
+		cfg80211_drv_free(wiphy_to_drv(wiphy));
+}
+EXPORT_SYMBOL(wiphy_free);
+
 
 static int cfg80211_init(void)
 {
-#ifdef CONFIG_CFG80211_WEXT_COMPAT
-	cfg80211_core_ops.get_drv_from_ifidx = cfg80211_get_drv_from_ifindex;
-	cfg80211_core_ops.put_drv = cfg80211_put_drv;
-	cfg80211_core_ops.module = THIS_MODULE;
-	cfg80211_core_ops.loaded = 1;
-#endif
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
-#ifdef CONFIG_CFG80211_WEXT_COMPAT
-	cfg80211_core_ops.loaded = 0;
-	cfg80211_core_ops.module = NULL;
-	cfg80211_core_ops.get_drv_from_ifidx = NULL;
-	cfg80211_core_ops.put_drv = NULL;
-#endif
-	nl80211_exit();
+	cfg80211_wext_exit();
+	wiphy_sysfs_exit();
 }
-
-module_init(cfg80211_init);
 module_exit(cfg80211_exit);
--- wireless-dev.orig/net/wireless/core.h	2007-02-09 17:08:26.133840519 +0100
+++ wireless-dev/net/wireless/core.h	2007-02-09 17:08:44.033840519 +0100
@@ -5,47 +5,39 @@
  */
 #ifndef __NET_WIRELESS_CORE_H
 #define __NET_WIRELESS_CORE_H
-#include <net/cfg80211.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/netdevice.h>
 #include <net/genetlink.h>
-#include <linux/module.h>
+#include <net/cfg80211.h>
 
 struct cfg80211_registered_driver {
 	struct cfg80211_ops *ops;
-	int wiphy;
-	void *priv;
 	struct list_head list;
 	/* we hold this mutex during any call so that
 	 * we cannot do multiple calls at once, and also
 	 * to avoid the deregister call to proceed while
 	 * any call is in progress */
 	struct mutex mtx;
+
+#ifdef CONFIG_CFG80211_WEXT_COMPAT
+	/* wext compat */
+	struct cfg80211_config *wext_pending_config;
+#endif
+
+	/* must be last because of the way we do wiphy_priv(),
+	 * and it should at least be aligned to NETDEV_ALIGN */
+	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
 };
 
+static inline struct cfg80211_registered_driver *wiphy_to_drv(struct wiphy *wiphy)
+{
+	return container_of(wiphy, struct cfg80211_registered_driver, wiphy);
+}
+
 extern struct mutex cfg80211_drv_mutex;
 extern struct list_head cfg80211_drv_list;
 
-#ifdef CONFIG_CFG80211_WEXT_COMPAT
-/* wext compatibility must be compiled in...
- * this extern is in wext-compat.c */
-struct cfg80211_core_ops {
-	/* flag to see if cfg80211 is there.
-	 * FIXME: isn't that racy? */
-	int loaded;
-
-	/* used to make sure the module isn't going away
-	 * can't really happen, except if no driver has cfg80211
-	 * in use, but in that case  */
-	struct module *module;
-
-	/* and finally these are used to do work */
-	struct cfg80211_registered_driver *(*get_drv_from_ifidx)(int ifidx);
-	void (*put_drv)(struct cfg80211_registered_driver *drv);
-};
-extern struct cfg80211_core_ops cfg80211_core_ops;
-#endif
-
 /*
  * This function returns a pointer to the driver
  * that the genl_info item that is passed refers to.
@@ -75,4 +67,7 @@ cfg80211_get_drv_from_ifindex(int ifinde
 
 extern void cfg80211_put_drv(struct cfg80211_registered_driver *drv);
 
+/* free object */
+extern void cfg80211_drv_free(struct cfg80211_registered_driver *drv);
+
 #endif /* __NET_WIRELESS_CORE_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/wireless/sysfs.c	2007-02-09 17:08:44.033840519 +0100
@@ -0,0 +1,65 @@
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
+static inline struct cfg80211_registered_driver *cdev_to_drv(
+	struct class_device *cdev)
+{
+	return container_of(cdev, struct cfg80211_registered_driver, wiphy.class_dev);
+}
+
+static void wiphy_class_dev_release(struct class_device *cdev)
+{
+	struct cfg80211_registered_driver *drv = cdev_to_drv(cdev);
+
+	cfg80211_drv_free(drv);
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
+	class_device_initialize(&wiphy->class_dev);
+	return class_device_add(&wiphy->class_dev);
+}
+
+void wiphy_sysfs_del(struct wiphy *wiphy)
+{
+	class_device_del(&wiphy->class_dev);
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/wireless/sysfs.h	2007-02-09 17:08:44.033840519 +0100
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
--- wireless-dev.orig/include/net/iw_handler.h	2007-02-09 17:08:25.863840519 +0100
+++ wireless-dev/include/net/iw_handler.h	2007-02-09 17:08:44.043840519 +0100
@@ -433,9 +433,6 @@ struct iw_public_data {
 extern int dev_get_wireless_info(char * buffer, char **start, off_t offset,
 				 int length);
 
-/* Handle IOCTLs, called in net/core/dev.c */
-extern int wireless_process_ioctl(struct ifreq *ifr, unsigned int cmd);
-
 /* Handle RtNetlink requests, called in net/core/rtnetlink.c */
 extern int wireless_rtnetlink_set(struct net_device *	dev,
 				  char *		data,
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/include/net/wireless.h	2007-02-09 17:08:44.043840519 +0100
@@ -0,0 +1,23 @@
+#ifndef __NET_WIRELESS_H
+#define __NET_WIRELESS_H
+
+/*
+ * internal definitions for wireless
+ */
+
+#if defined(CONFIG_CFG80211_WEXT_COMPAT) || defined(CONFIG_WIRELESS_EXT)
+int wext_ioctl(unsigned int cmd, struct ifreq *ifreq, void __user *arg);
+int wireless_proc_init(void);
+#else
+static inline
+int wext_ioctl(unsigned int cmd, struct ifreq *ifreq, void __user *arg)
+{
+	return -EINVAL;
+}
+static inline int wireless_proc_init(void)
+{
+	return 0;
+}
+#endif
+
+#endif /* __NET_WIRELESS_H */
--- wireless-dev.orig/net/Kconfig	2007-02-09 17:08:26.843840519 +0100
+++ wireless-dev/net/Kconfig	2007-02-09 17:08:44.043840519 +0100
@@ -244,20 +244,6 @@ config CFG80211_WEXT_COMPAT
 
 	If unsure, say Y.
 
-config CFG80211_WEXTNL_COMPAT
-	bool "cfg80211 WE-netlink compatibility"
-	depends CFG80211 && CFG80211_WEXT_COMPAT
-	---help---
-	This option allows using devices whose drivers have been
-	converted to use the new cfg80211 with wireless extensions
-	over rtnetlink, providing WE-20 compatibility. Note that
-	cfg80211's "native" interface is nl80211 using generic netlink.
-	The wireless extensions are being deprecated and the netlink
-	based API for WE was never configured by default, nor do any
-	userspace tools use this feature.
-
-	This option exists only to make Jean happy. Say N.
-
 endif   # if NET
 endmenu # Networking
 
--- wireless-dev.orig/net/core/dev.c	2007-02-09 17:08:26.873840519 +0100
+++ wireless-dev/net/core/dev.c	2007-02-09 17:08:44.043840519 +0100
@@ -116,7 +116,7 @@
 #include <linux/dmaengine.h>
 #include <linux/err.h>
 #include <linux/ctype.h>
-#include <net/cfg80211.h>
+#include <net/wireless.h>
 
 /*
  *	The list of packet types we will receive (as opposed to discard)
@@ -2229,12 +2229,6 @@ static struct file_operations softnet_se
 	.release = seq_release,
 };
 
-#if defined(CONFIG_WIRELESS_EXT) || defined(CFG80211_WEXT_COMPAT)
-extern int wireless_proc_init(void);
-#else
-#define wireless_proc_init() 0
-#endif
-
 static int __init dev_proc_init(void)
 {
 	int rc = -ENOMEM;
@@ -2799,62 +2793,9 @@ int dev_ioctl(unsigned int cmd, void __u
 					ret = -EFAULT;
 				return ret;
 			}
-#ifdef CONFIG_CFG80211_WEXT_COMPAT
-			/* Take care of cfg80211 WE compatibility */
-			if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) {
-				/* If command is `set a parameter', or
-				 * `get the encoding parameters', check if
-				 * the user has the right to do it */
-				if (IW_IS_SET(cmd) || cmd == SIOCGIWENCODE
-				    || cmd == SIOCGIWENCODEEXT) {
-					if (!capable(CAP_NET_ADMIN))
-						return -EPERM;
-				}
-				dev_load(ifr.ifr_name);
-				rtnl_lock();
-				/* Follow me in net/wireless/wext-compat.c */
-				ret = cfg80211_wext_ioctl(&ifr, cmd);
-				rtnl_unlock();
-				if (ret == 0 && IW_IS_GET(cmd) &&
-				    copy_to_user(arg, &ifr,
-					    	 sizeof(struct ifreq)))
-					ret = -EFAULT;
-				/* haha, I cheat here by allowing a driver or
-				 * stack to have both WE or CFG80211-WE for
-				 * a little while during conversion... hope that
-				 * ENOSYS is only used to indicate not implemented
-				 *
-				 * if wireless extensions are not configured
-				 * then this is the last thing here so that
-				 * if we fall through we return -EINVAL
-				 */
-				if (ret != -ENOSYS)
-					return ret;
-			}
-#endif
-#ifdef CONFIG_WIRELESS_EXT
-			/* Take care of Wireless Extensions */
-			if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) {
-				/* If command is `set a parameter', or
-				 * `get the encoding parameters', check if
-				 * the user has the right to do it */
-				if (IW_IS_SET(cmd) || cmd == SIOCGIWENCODE
-				    || cmd == SIOCGIWENCODEEXT) {
-					if (!capable(CAP_NET_ADMIN))
-						return -EPERM;
-				}
-				dev_load(ifr.ifr_name);
-				rtnl_lock();
-				/* Follow me in net/wireless/wext-old.c */
-				ret = wireless_process_ioctl(&ifr, cmd);
-				rtnl_unlock();
-				if (ret == 0 && IW_IS_GET(cmd) &&
-				    copy_to_user(arg, &ifr,
-					    	 sizeof(struct ifreq)))
-					ret = -EFAULT;
-				return ret;
-			}
-#endif	/* CONFIG_WIRELESS_EXT */
+			/* Take care of wireless extensions */
+			if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST)
+				return wext_ioctl(cmd, &ifr, arg);
 			return -EINVAL;
 	}
 }
--- wireless-dev.orig/net/wireless/wext-common.c	2007-02-09 17:08:26.233840519 +0100
+++ wireless-dev/net/wireless/wext-common.c	2007-02-09 17:08:44.043840519 +0100
@@ -1,4 +1,12 @@
-/* common wext support routines, proc interface and events */
+/*
+ * common wext support routines, proc interface and events
+ *
+ *
+ * Most code is from the original wireless.c:
+ * Copyright 1997-2006  Jean Tourrilhes <jt@hpl.hp.com>
+ *
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ */
 
 #include <linux/proc_fs.h>
 #include <linux/netdevice.h>
@@ -16,7 +24,7 @@
  * Meta-data about all the standard Wireless Extension request we
  * know about.
  */
-const struct iw_ioctl_description standard_ioctl[] = {
+const struct iw_ioctl_description wext_standard_ioctl[] = {
 	[SIOCSIWCOMMIT	- SIOCIWFIRST] = {
 		.header_type	= IW_HEADER_TYPE_NULL,
 	},
@@ -243,8 +251,7 @@ const struct iw_ioctl_description standa
 		.max_tokens	= sizeof(struct iw_pmksa),
 	},
 };
-const unsigned standard_ioctl_num = (sizeof(standard_ioctl) /
-					sizeof(struct iw_ioctl_description));
+const unsigned wext_standard_ioctl_num = ARRAY_SIZE(wext_standard_ioctl);
 
 /*
  * Meta-data about all the additional standard Wireless Extension events
@@ -297,6 +304,7 @@ const struct iw_ioctl_description standa
 unsigned standard_event_num = (sizeof(standard_event) /
 					sizeof(struct iw_ioctl_description));
 
+
 /* Size (in bytes) of various events */
 const int event_type_size[] = {
 	IW_EV_LCP_LEN,			/* IW_HEADER_TYPE_NULL */
@@ -545,8 +553,8 @@ void wireless_send_event(struct net_devi
 	/* Get the description of the Event */
 	if(cmd <= SIOCIWLAST) {
 		cmd_index = cmd - SIOCIWFIRST;
-		if(cmd_index < standard_ioctl_num)
-			descr = &(standard_ioctl[cmd_index]);
+		if(cmd_index < wext_standard_ioctl_num)
+			descr = &(wext_standard_ioctl[cmd_index]);
 	} else {
 		cmd_index = cmd - IWEVFIRST;
 		if(cmd_index < standard_event_num)
@@ -608,3 +616,48 @@ void wireless_send_event(struct net_devi
 
 	return;		/* Always success, I guess ;-) */
 }
+EXPORT_SYMBOL(wireless_send_event);
+
+/* common code to handle wireless extension ioctls */
+int wext_ioctl(unsigned int cmd, struct ifreq *ifr, void __user *arg)
+{
+	int ret = -EINVAL;
+
+	/* If command is `set a parameter', or `get the encoding parameters',
+	 * check if the user is allowed to do it */
+	if (IW_IS_SET(cmd) || cmd == SIOCGIWENCODE || cmd == SIOCGIWENCODEEXT)
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+
+	dev_load(ifr->ifr_name);
+
+#ifdef CONFIG_WIRELESS_EXT
+	rtnl_lock();
+	/* Follow me in wext-old.c */
+	ret = wireless_process_ioctl(ifr, cmd);
+	rtnl_unlock();
+
+	if (ret == 0 && IW_IS_GET(cmd) &&
+	    copy_to_user(arg, &ifr, sizeof(struct ifreq)))
+		ret = -EFAULT;
+	/* haha, I cheat here by allowing a driver or stack to have both WE and
+	 * CFG80211-WE for a little while during conversion... wext returns
+	 * -EOPNOTSUPP if a handler is not assigned, so we can in that case try
+	 * calling cfg80211's compat code instead.
+	 */
+	if (ret != -EOPNOTSUPP)
+		return ret;
+#endif
+
+#ifdef CONFIG_CFG80211_WEXT_COMPAT
+	rtnl_lock();
+	ret = call_cfg80211_wext_ioctl(ifr, cmd);
+	rtnl_unlock();
+
+	if (ret == 0 && IW_IS_GET(cmd) &&
+	    copy_to_user(arg, ifr, sizeof(struct ifreq)))
+		ret = -EFAULT;
+#endif
+
+	return ret;
+}
--- wireless-dev.orig/net/wireless/wext-compat.c	2007-02-09 17:08:26.273840519 +0100
+++ wireless-dev/net/wireless/wext-compat.c	2007-02-09 17:08:44.053840519 +0100
@@ -4,7 +4,7 @@
  * Lots of code from the original wireless.c:
  * Copyright 1997-2006	Jean Tourrilhes <jt@hpl.hp.com>
  *
- * Copyright 2006	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006,2007	Johannes Berg <johannes@sipsolutions.net>
  *
  * GPLv2.
  *
@@ -45,7 +45,6 @@
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
 #include <linux/wireless.h>
-#include <net/iw_handler.h>
 #include <net/netlink.h>
 #include <asm/uaccess.h>
 #include <net/cfg80211.h>
@@ -53,29 +52,6 @@
 #include "core.h"
 #include "wext.h"
 
-/* The cfg80211 driver assigns callbacks in this
- * if it is loaded. If not, then we can't config
- * anything anyway... */
-struct cfg80211_core_ops cfg80211_core_ops;
-EXPORT_SYMBOL_GPL(cfg80211_core_ops);
-
-static struct cfg80211_registered_driver *cfg80211_wx_setup(int ifindex)
-{
-	if (!cfg80211_core_ops.loaded)
-		return ERR_PTR(-ENOSYS);
-	if (!try_module_get(cfg80211_core_ops.module))
-		return ERR_PTR(-ENOSYS);
-
-	return cfg80211_core_ops.get_drv_from_ifidx(ifindex);
-}
-
-static void cfg80211_wx_teardown(struct cfg80211_registered_driver *drv)
-{
-	if (!IS_ERR(drv))
-		cfg80211_core_ops.put_drv(drv);
-	module_put(cfg80211_core_ops.module);
-}
-
 /* internal API: use this function when changing
  * some parameter that needs to be committed */
 static void cfg80211_wx_start_commit_timer(int ifindex)
@@ -91,302 +67,170 @@ static void cfg80211_wx_start_commit_tim
 	 * as well as taking the rtnl lock (due to wext)! */
 }
 
-static void cfg80211_ensure_netdev_pending_cfg(struct net_device *dev)
+static struct cfg80211_config *cfg80211_ensure_pending_cfg(
+	struct cfg80211_registered_driver *drv)
 {
-	struct cfg80211_config *cfg = dev->cfg80211_wext_pending_config;
-	if (!cfg) {
+	struct cfg80211_config *cfg = drv->wext_pending_config;
+	if (!cfg)
 		cfg = kmalloc(sizeof(*cfg)+32, GFP_KERNEL);
+	if (cfg) {
 		cfg->ssid = (char*)cfg + sizeof(*cfg);
-		dev->cfg80211_wext_pending_config = cfg;
+		drv->wext_pending_config = cfg;
 	}
+	return cfg;
 }
 
-/* operations we implement. whew, I machine-generated these */
-static int cfg80211_wx_set_commit(struct net_device *net_dev,
+static int cfg80211_wx_set_commit(struct cfg80211_registered_driver *drv,
+				  struct net_device *net_dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *data,
 				  char *extra)
 {
-	struct cfg80211_registered_driver *drv;
 	int err;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	if (!net_dev->cfg80211_wext_pending_config) {
+	if (!drv->wext_pending_config) {
 		err = 0;
 		goto out;
 	}
 
-	err = drv->ops->configure(drv->priv, net_dev,
-				  net_dev->cfg80211_wext_pending_config);
+	err = drv->ops->configure(&drv->wiphy, net_dev,
+				  drv->wext_pending_config);
 
-	kfree(net_dev->cfg80211_wext_pending_config);
-	net_dev->cfg80211_wext_pending_config = NULL;
+	kfree(drv->wext_pending_config);
+	drv->wext_pending_config = NULL;
 
  out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_name(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_name(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_nwid(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_nwid(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_nwid(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_nwid(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_freq(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_freq(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_freq(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_freq(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_mode(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_mode(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_mode(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_mode(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_sens(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_sens(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_sens(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_sens(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_range(struct net_device *net_dev,
+static int cfg80211_wx_set_range(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_range(struct net_device *net_dev,
+static int cfg80211_wx_get_range(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_ap(struct net_device *net_dev,
+static int cfg80211_wx_set_ap(struct cfg80211_registered_driver *drv,
+			      struct net_device *net_dev,
 			      struct iw_request_info *info,
 			      union iwreq_data *data,
 			      char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
 	/* TODO: DO SOMETHING */
 	/* SIOCSIWAP
@@ -394,150 +238,86 @@ static int cfg80211_wx_set_ap(struct net
 	 *   -> if bssid is all-zeroes: set roaming to kernel
 	 *   -> otherwise: set roaming to userspace, set bssid
 	 */
-	err = -ENOSYS;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_ap(struct net_device *net_dev,
+static int cfg80211_wx_get_ap(struct cfg80211_registered_driver *drv,
+			      struct net_device *net_dev,
 			      struct iw_request_info *info,
 			      union iwreq_data *data,
 			      char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
 	/* TODO: DO SOMETHING */
 	/* SIOCGIWAP
 	 *   -> get association parameters and fill return bssid appropriately
 	 */
-	err = -ENOSYS;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_mlme(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_mlme(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_waplist(struct net_device *net_dev,
+static int cfg80211_wx_get_waplist(struct cfg80211_registered_driver *drv,
+				   struct net_device *net_dev,
 				   struct iw_request_info *info,
 				   union iwreq_data *data,
 				   char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_scan(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_scan(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_scan(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_scan(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_essid(struct net_device *net_dev,
+static int cfg80211_wx_set_essid(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 	struct cfg80211_config *cfg;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	err = -ENOSYS;
 	if (!drv->ops->configure || !drv->ops->get_config_valid)
 		goto out;
-	if (!(drv->ops->get_config_valid(drv->priv, net_dev)
+	if (!(drv->ops->get_config_valid(&drv->wiphy, net_dev)
 			& CFG80211_CFG_VALID_SSID))
 		goto out;
 
-	cfg80211_ensure_netdev_pending_cfg(net_dev);
-	cfg = net_dev->cfg80211_wext_pending_config;
+	cfg = cfg80211_ensure_pending_cfg(drv);
 	if (!cfg) {
 		err = -ENOMEM;
 		goto out;
@@ -550,502 +330,264 @@ static int cfg80211_wx_set_essid(struct 
 	cfg80211_wx_start_commit_timer(net_dev->ifindex);
 	err = 0;
  out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_essid(struct net_device *net_dev,
+static int cfg80211_wx_get_essid(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_rate(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_rate(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_rate(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_rate(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_rts(struct net_device *net_dev,
+static int cfg80211_wx_set_rts(struct cfg80211_registered_driver *drv,
+			       struct net_device *net_dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *data,
 			       char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_rts(struct net_device *net_dev,
+static int cfg80211_wx_get_rts(struct cfg80211_registered_driver *drv,
+			       struct net_device *net_dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *data,
 			       char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_frag(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_frag(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_frag(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_frag(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_txpow(struct net_device *net_dev,
+static int cfg80211_wx_set_txpow(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_txpow(struct net_device *net_dev,
+static int cfg80211_wx_get_txpow(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_retry(struct net_device *net_dev,
+static int cfg80211_wx_set_retry(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_retry(struct net_device *net_dev,
+static int cfg80211_wx_get_retry(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_encode(struct net_device *net_dev,
+static int cfg80211_wx_set_encode(struct cfg80211_registered_driver *drv,
+				  struct net_device *net_dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *data,
 				  char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_encode(struct net_device *net_dev,
+static int cfg80211_wx_get_encode(struct cfg80211_registered_driver *drv,
+				  struct net_device *net_dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *data,
 				  char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_power(struct net_device *net_dev,
+static int cfg80211_wx_set_power(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_power(struct net_device *net_dev,
+static int cfg80211_wx_get_power(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_genie(struct net_device *net_dev,
+static int cfg80211_wx_set_genie(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_genie(struct net_device *net_dev,
+static int cfg80211_wx_get_genie(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_auth(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_auth(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_auth(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_auth(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_encodeext(struct net_device *net_dev,
+static int cfg80211_wx_set_encodeext(struct cfg80211_registered_driver *drv,
+				     struct net_device *net_dev,
 				     struct iw_request_info *info,
 				     union iwreq_data *data,
 				     char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_encodeext(struct net_device *net_dev,
+static int cfg80211_wx_get_encodeext(struct cfg80211_registered_driver *drv,
+				     struct net_device *net_dev,
 				     struct iw_request_info *info,
 				     union iwreq_data *data,
 				     char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_wpmksa(struct net_device *net_dev,
+static int cfg80211_wx_set_wpmksa(struct cfg80211_registered_driver *drv,
+				  struct net_device *net_dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *data,
 				  char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
 
+typedef int (*iw_compat_handler)(struct cfg80211_registered_driver *drv,
+				 struct net_device *dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *wrqu,
+				 char *extra);
 
 /* operations array */
 #ifdef WX
 # undef WX
 #endif
 #define WX(ioctl)  [(ioctl) - SIOCIWFIRST]
-static const iw_handler cfg80211_wx_handlers[] = {
+static const iw_compat_handler cfg80211_wx_handlers[] = {
 	WX(SIOCSIWCOMMIT)	= cfg80211_wx_set_commit,
 	WX(SIOCGIWNAME)		= cfg80211_wx_get_name,
 	WX(SIOCSIWNWID)		= cfg80211_wx_set_nwid,
@@ -1090,7 +632,7 @@ static const iw_handler cfg80211_wx_hand
 };
 
 /* dummy so I didn't have to change that much code... */
-static iw_handler get_handler(struct net_device *dev, unsigned int cmd)
+static iw_compat_handler get_handler(unsigned int cmd)
 {
 	int idx = cmd - SIOCIWFIRST;
 	if (idx < ARRAY_SIZE(cfg80211_wx_handlers))
@@ -1102,10 +644,11 @@ static iw_handler get_handler(struct net
  * this is sort of backwards and wouldn't need to call
  * get_wireless_stats, but it was easier to just copy the code...
  */
-static int iw_handler_get_iwstats(struct net_device *		dev,
-				  struct iw_request_info *	info,
-				  union iwreq_data *		wrqu,
-				  char *			extra)
+static int iw_handler_get_iwstats(struct cfg80211_registered_driver *drv,
+				  struct net_device *dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *wrqu,
+				  char *extra)
 {
 	/* Get stats from the driver */
 	struct iw_statistics stats_buf;
@@ -1126,348 +669,16 @@ static int iw_handler_get_iwstats(struct
 		return -EOPNOTSUPP;
 }
 
-#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
-/*
- * Wrapper to call a standard Wireless Extension GET handler.
- * We do various checks and call the handler with the proper args.
- */
-static int rtnetlink_standard_get(struct net_device *	dev,
-				  struct iw_event *	request,
-				  int			request_len,
-				  iw_handler		handler,
-				  char **		p_buf,
-				  int *			p_len)
-{
-	const struct iw_ioctl_description *	descr = NULL;
-	unsigned int				cmd;
-	union iwreq_data *			wrqu;
-	int					hdr_len;
-	struct iw_request_info			info;
-	char *					buffer = NULL;
-	int					buffer_size = 0;
-	int					ret = -EINVAL;
-
-	/* Get the description of the Request */
-	cmd = request->cmd;
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
-		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
-
-	/* Check if wrqu is complete */
-	hdr_len = event_type_size[descr->header_type];
-	if(request_len < hdr_len)
-		return -EINVAL;
-
-	/* Prepare the call */
-	info.cmd = cmd;
-	info.flags = 0;
-
-	/* Check if we have extra data in the reply or not */
-	if(descr->header_type != IW_HEADER_TYPE_POINT) {
-
-		/* Create the kernel buffer that we will return.
-		 * It's at an offset to match the TYPE_POINT case... */
-		buffer_size = request_len + IW_EV_POINT_OFF;
-		buffer = kmalloc(buffer_size, GFP_KERNEL);
-		if (buffer == NULL) {
-			return -ENOMEM;
-		}
-		/* Copy event data */
-		memcpy(buffer + IW_EV_POINT_OFF, request, request_len);
-		/* Use our own copy of wrqu */
-		wrqu = (union iwreq_data *) (buffer + IW_EV_POINT_OFF
-					     + IW_EV_LCP_LEN);
-
-		/* No extra arguments. Trivial to handle */
-		ret = handler(dev, &info, wrqu, NULL);
-
-	} else {
-		union iwreq_data	wrqu_point;
-		char *			extra = NULL;
-		int			extra_size = 0;
-
-		/* Get a temp copy of wrqu (skip pointer) */
-		memcpy(((char *) &wrqu_point) + IW_EV_POINT_OFF,
-		       ((char *) request) + IW_EV_LCP_LEN,
-		       IW_EV_POINT_LEN - IW_EV_LCP_LEN);
-
-		/* Calculate space needed by arguments. Always allocate
-		 * for max space. Easier, and won't last long... */
-		extra_size = descr->max_tokens * descr->token_size;
-		/* Support for very large requests */
-		if((descr->flags & IW_DESCR_FLAG_NOMAX) &&
-		   (wrqu_point.data.length > descr->max_tokens))
-			extra_size = (wrqu_point.data.length
-				      * descr->token_size);
-		buffer_size = extra_size + IW_EV_POINT_LEN + IW_EV_POINT_OFF;
-
-		/* Create the kernel buffer that we will return */
-		buffer = kmalloc(buffer_size, GFP_KERNEL);
-		if (buffer == NULL) {
-			return -ENOMEM;
-		}
-
-		/* Put wrqu in the right place (just before extra).
-		 * Leave space for IWE header and dummy pointer...
-		 * Note that IW_EV_LCP_LEN==4 bytes, so it's still aligned...
-		 */
-		memcpy(buffer + IW_EV_LCP_LEN + IW_EV_POINT_OFF,
-		       ((char *) &wrqu_point) + IW_EV_POINT_OFF,
-		       IW_EV_POINT_LEN - IW_EV_LCP_LEN);
-		wrqu = (union iwreq_data *) (buffer + IW_EV_LCP_LEN);
-
-		/* Extra comes logically after that. Offset +12 bytes. */
-		extra = buffer + IW_EV_POINT_OFF + IW_EV_POINT_LEN;
-
-		/* Call the handler */
-		ret = handler(dev, &info, wrqu, extra);
-
-		/* Calculate real returned length */
-		extra_size = (wrqu->data.length * descr->token_size);
-		/* Re-adjust reply size */
-		request->len = extra_size + IW_EV_POINT_LEN;
-
-		/* Put the iwe header where it should, i.e. scrap the
-		 * dummy pointer. */
-		memcpy(buffer + IW_EV_POINT_OFF, request, IW_EV_LCP_LEN);
-
-		/* Check if there is enough buffer up there */
-		if(wrqu_point.data.length < wrqu->data.length)
-			ret = -E2BIG;
-	}
-
-	/* Return the buffer to the caller */
-	if (!ret) {
-		*p_buf = buffer;
-		*p_len = request->len;
-	} else {
-		/* Cleanup */
-		if(buffer)
-			kfree(buffer);
-	}
-
-	return ret;
-}
-
-/*
- * Wrapper to call a standard Wireless Extension SET handler.
- * We do various checks and call the handler with the proper args.
- */
-static inline int rtnetlink_standard_set(struct net_device *	dev,
-					 struct iw_event *	request,
-					 int			request_len,
-					 iw_handler		handler)
-{
-	const struct iw_ioctl_description *	descr = NULL;
-	unsigned int				cmd;
-	union iwreq_data *			wrqu;
-	union iwreq_data			wrqu_point;
-	int					hdr_len;
-	char *					extra = NULL;
-	int					extra_size = 0;
-	struct iw_request_info			info;
-	int					ret = -EINVAL;
-
-	/* Get the description of the Request */
-	cmd = request->cmd;
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
-		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
-
-	/* Extract fixed header from request. This is properly aligned. */
-	wrqu = &request->u;
-
-	/* Check if wrqu is complete */
-	hdr_len = event_type_size[descr->header_type];
-	if(request_len < hdr_len)
-		return -EINVAL;
-
-	/* Prepare the call */
-	info.cmd = cmd;
-	info.flags = 0;
-
-	/* Check if we have extra data in the request or not */
-	if(descr->header_type != IW_HEADER_TYPE_POINT) {
-
-		/* No extra arguments. Trivial to handle */
-		ret = handler(dev, &info, wrqu, NULL);
-
-	} else {
-		int	extra_len;
-
-		/* Put wrqu in the right place (skip pointer) */
-		memcpy(((char *) &wrqu_point) + IW_EV_POINT_OFF,
-		       wrqu, IW_EV_POINT_LEN - IW_EV_LCP_LEN);
-		/* Don't forget about the event code... */
-		wrqu = &wrqu_point;
-
-		/* Check if number of token fits within bounds */
-		if(wrqu_point.data.length > descr->max_tokens)
-			return -E2BIG;
-		if(wrqu_point.data.length < descr->min_tokens)
-			return -EINVAL;
-
-		/* Real length of payload */
-		extra_len = wrqu_point.data.length * descr->token_size;
-
-		/* Check if request is self consistent */
-		if((request_len - hdr_len) < extra_len)
-			return -EINVAL;
-
-		/* Always allocate for max space. Easier, and won't last
-		 * long... */
-		extra_size = descr->max_tokens * descr->token_size;
-		extra = kmalloc(extra_size, GFP_KERNEL);
-		if (extra == NULL)
-			return -ENOMEM;
-
-		/* Copy extra in aligned buffer */
-		memcpy(extra, ((char *) request) + hdr_len, extra_len);
-
-		/* Call the handler */
-		ret = handler(dev, &info, &wrqu_point, extra);
-	}
-
-        /* Generate an event to notify listeners of the change */
-	if ((descr->flags & IW_DESCR_FLAG_EVENT) &&
-	    ((ret == 0) || (ret == -EIWCOMMIT))) {
-		if(descr->flags & IW_DESCR_FLAG_RESTRICT)
-			/* If the event is restricted, don't
-			 * export the payload */
-			wireless_send_event(dev, cmd, wrqu, NULL);
-		else
-			wireless_send_event(dev, cmd, wrqu, extra);
-	}
-
-	/* Cleanup - I told you it wasn't that long ;-) */
-	if(extra)
-		kfree(extra);
-
-	return ret;
-}
-
-/*
- * Main RtNetlink dispatcher. Called from the main networking code
- * (do_getlink() in net/core/rtnetlink.c).
- * Check the type of Request and call the appropriate wrapper...
- */
-int cfg80211_wext_nl_get(struct net_device *	dev,
-			 char *			data,
-			 int			len,
-			 char **		p_buf,
-			 int *			p_len)
-{
-	struct iw_event *	request = (struct iw_event *) data;
-	iw_handler		handler;
-
-	/* Check length */
-	if(len < IW_EV_LCP_LEN) {
-		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request too short (%d)\n",
-		       dev->name, len);
-		return -EINVAL;
-	}
-
-	/* ReCheck length (len may have padding) */
-	if(request->len > len) {
-		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request len invalid (%d-%d)\n",
-		       dev->name, request->len, len);
-		return -EINVAL;
-	}
-
-	/* Only accept GET requests in here */
-	if(!IW_IS_GET(request->cmd))
-		return -EOPNOTSUPP;
-
-	/* If command is `get the encoding parameters', check if
-	 * the user has the right to do it */
-	if (request->cmd == SIOCGIWENCODE ||
-	    request->cmd == SIOCGIWENCODEEXT) {
-		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
-	}
-
-	/* Special cases */
-	if(request->cmd == SIOCGIWSTATS)
-		/* Get Wireless Stats */
-		return rtnetlink_standard_get(dev,
-					      request,
-					      request->len,
-					      &iw_handler_get_iwstats,
-					      p_buf, p_len);
-	if(request->cmd == SIOCGIWPRIV)
-		return -EOPNOTSUPP;
-
-	/* Basic check */
-	if (!netif_device_present(dev))
-		return -ENODEV;
-
-	/* Try to find the handler */
-	handler = get_handler(dev, request->cmd);
-	if (handler != NULL && request->cmd < SIOCIWFIRSTPRIV)
-		return rtnetlink_standard_get(dev,
-					      request,
-					      request->len,
-					      handler,
-					      p_buf, p_len);
-
-	return -EOPNOTSUPP;
-}
-
-/*
- * Main RtNetlink dispatcher. Called from the main networking code
- * (do_setlink() in net/core/rtnetlink.c).
- * Check the type of Request and call the appropriate wrapper...
- */
-int cfg80211_wext_nl_set(struct net_device *	dev,
-			 char *			data,
-			 int			len)
-{
-	struct iw_event *	request = (struct iw_event *) data;
-	iw_handler		handler;
-
-	/* Check length */
-	if(len < IW_EV_LCP_LEN) {
-		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request too short (%d)\n",
-		       dev->name, len);
-		return -EINVAL;
-	}
-
-	/* ReCheck length (len may have padding) */
-	if(request->len > len) {
-		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request len invalid (%d-%d)\n",
-		       dev->name, request->len, len);
-		return -EINVAL;
-	}
-
-	/* Only accept SET requests in here */
-	if(!IW_IS_SET(request->cmd))
-		return -EOPNOTSUPP;
-
-	/* Basic check */
-	if (!netif_device_present(dev))
-		return -ENODEV;
-
-	/* New driver API : try to find the handler */
-	handler = get_handler(dev, request->cmd);
-	if(handler != NULL && request->cmd < SIOCIWFIRSTPRIV)
-		return rtnetlink_standard_set(dev,
-					      request,
-					      request->len,
-					      handler);
-
-	return -EOPNOTSUPP;
-}
-#endif
-
 /*
  * Wrapper to call a standard Wireless Extension handler.
  * We do various checks and also take care of moving data between
  * user space and kernel space.
  */
-static int ioctl_standard_call(struct net_device *	dev,
-			       struct ifreq *		ifr,
-			       unsigned int		cmd,
-			       iw_handler		handler)
+static int ioctl_standard_call(struct cfg80211_registered_driver *drv,
+			       struct net_device *dev,
+			       struct ifreq *ifr,
+			       unsigned int cmd,
+			       iw_compat_handler handler)
 {
 	struct iwreq *				iwr = (struct iwreq *) ifr;
 	const struct iw_ioctl_description *	descr;
@@ -1475,9 +686,9 @@ static int ioctl_standard_call(struct ne
 	int					ret = -EINVAL;
 
 	/* Get the description of the IOCTL */
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+	if((cmd - SIOCIWFIRST) >= wext_standard_ioctl_num)
 		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
 	/* Prepare the call */
 	info.cmd = cmd;
@@ -1487,7 +698,7 @@ static int ioctl_standard_call(struct ne
 	if(descr->header_type != IW_HEADER_TYPE_POINT) {
 
 		/* No extra arguments. Trivial to handle */
-		ret = handler(dev, &info, &(iwr->u), NULL);
+		ret = handler(drv, dev, &info, &(iwr->u), NULL);
 
 		/* Generate an event to notify listeners of the change */
 		if((descr->flags & IW_DESCR_FLAG_EVENT) &&
@@ -1557,7 +768,7 @@ static int ioctl_standard_call(struct ne
 		}
 
 		/* Call the handler */
-		ret = handler(dev, &info, &(iwr->u), extra);
+		ret = handler(drv, dev, &info, &(iwr->u), extra);
 
 		/* If we have something to return to the user */
 		if (!ret && IW_IS_GET(cmd)) {
@@ -1597,7 +808,8 @@ static int ioctl_standard_call(struct ne
 int cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd)
 {
 	struct net_device *dev;
-	iw_handler	handler;
+	iw_compat_handler handler;
+	struct cfg80211_registered_driver *drv;
 
 	/* Permissions are already checked in dev_ioctl() before calling us.
 	 * The copy_to/from_user() of ifr is also dealt with in there */
@@ -1606,26 +818,25 @@ int cfg80211_wext_ioctl(struct ifreq *if
 	if ((dev = __dev_get_by_name(ifr->ifr_name)) == NULL)
 		return -ENODEV;
 
+	drv = cfg80211_get_drv_from_ifindex(dev->ifindex);
+	if (!IS_ERR(drv))
+		return PTR_ERR(drv);
+
 	/* A bunch of special cases, then the generic case...
 	 * Note that 'cmd' is already filtered in dev_ioctl() with
 	 * (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) */
 	switch(cmd) {
 		case SIOCGIWSTATS:
 			/* Get Wireless Stats */
-			return ioctl_standard_call(dev,
-						   ifr,
-						   cmd,
+			return ioctl_standard_call(drv, dev, ifr, cmd,
 						   &iw_handler_get_iwstats);
 
 		case SIOCGIWPRIV:
 			return -EOPNOTSUPP;
 		default:
-			/* Basic check */
-			if (!netif_device_present(dev))
-				return -ENODEV;
-			handler = get_handler(dev, cmd);
+			handler = get_handler(cmd);
 			if(cmd < SIOCIWFIRSTPRIV && handler != NULL)
-				return ioctl_standard_call(dev, ifr, cmd,
+				return ioctl_standard_call(drv, dev, ifr, cmd,
 							   handler);
 			return -EOPNOTSUPP;
 	}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/wireless/wext-export.c	2007-02-09 17:08:44.053840519 +0100
@@ -0,0 +1,29 @@
+/*
+ * things we only need in the kernel when cfg80211 is modular.
+ *
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include "wext.h"
+
+EXPORT_SYMBOL_GPL(wext_standard_ioctl);
+EXPORT_SYMBOL_GPL(wext_standard_ioctl_num);
+EXPORT_SYMBOL_GPL(get_wireless_stats);
+
+struct cfg80211_ioctl_ops cfg80211_ioctl_ops;
+EXPORT_SYMBOL_GPL(cfg80211_ioctl_ops);
+
+int call_cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd)
+{
+	int err = -ENOSYS;
+
+	if (!try_module_get(cfg80211_ioctl_ops.module))
+		return -ENOSYS;
+
+	if (cfg80211_ioctl_ops.do_wext_ioctl)
+		err = cfg80211_ioctl_ops.do_wext_ioctl(ifr, cmd);
+
+	module_put(cfg80211_ioctl_ops.module);
+
+	return err;
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/wireless/wext-mod.c	2007-02-09 17:08:44.053840519 +0100
@@ -0,0 +1,20 @@
+/*
+ * things we only need in cfg80211 when it is modular.
+ *
+ * Copyright 2007       Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include "wext.h"
+
+int cfg80211_wext_init(void)
+{
+	cfg80211_ioctl_ops.do_wext_ioctl = cfg80211_wext_ioctl;
+	cfg80211_ioctl_ops.module = THIS_MODULE;
+	return 0;
+}
+
+void cfg80211_wext_exit(void)
+{
+	cfg80211_ioctl_ops.module = NULL;
+	cfg80211_ioctl_ops.do_wext_ioctl = NULL;
+}
--- wireless-dev.orig/net/wireless/wext-old.c	2007-02-09 17:08:26.583840519 +0100
+++ wireless-dev/net/wireless/wext-old.c	2007-02-09 17:08:44.063840519 +0100
@@ -124,6 +124,7 @@ static const char iw_priv_type_size[] = 
 	0,				/* Not defined */
 };
 
+
 /************************ COMMON SUBROUTINES ************************/
 /*
  * Stuff that may be used in various place or doesn't fit in one
@@ -308,9 +309,9 @@ static int ioctl_standard_call(struct ne
 	int					ret = -EINVAL;
 
 	/* Get the description of the IOCTL */
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+	if((cmd - SIOCIWFIRST) >= wext_standard_ioctl_num)
 		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
 #ifdef WE_IOCTL_DEBUG
 	printk(KERN_DEBUG "%s (WE) : Found standard handler for 0x%04X\n",
@@ -769,9 +770,9 @@ static int rtnetlink_standard_get(struct
 
 	/* Get the description of the Request */
 	cmd = request->cmd;
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+	if((cmd - SIOCIWFIRST) >= wext_standard_ioctl_num)
 		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
 #ifdef WE_RTNETLINK_DEBUG
 	printk(KERN_DEBUG "%s (WE.r) : Found standard handler for 0x%04X\n",
@@ -911,9 +912,9 @@ static inline int rtnetlink_standard_set
 
 	/* Get the description of the Request */
 	cmd = request->cmd;
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+	if((cmd - SIOCIWFIRST) >= wext_standard_ioctl_num)
 		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
 #ifdef WE_RTNETLINK_DEBUG
 	printk(KERN_DEBUG "%s (WE.r) : Found standard SET handler for 0x%04X\n",
@@ -1726,5 +1727,4 @@ EXPORT_SYMBOL(iw_handler_get_spy);
 EXPORT_SYMBOL(iw_handler_get_thrspy);
 EXPORT_SYMBOL(iw_handler_set_spy);
 EXPORT_SYMBOL(iw_handler_set_thrspy);
-EXPORT_SYMBOL(wireless_send_event);
 EXPORT_SYMBOL(wireless_spy_update);
--- wireless-dev.orig/net/wireless/wext.h	2007-02-09 17:08:26.623840519 +0100
+++ wireless-dev/net/wireless/wext.h	2007-02-09 17:08:44.063840519 +0100
@@ -3,11 +3,45 @@
  */
 #ifndef _WEXT_H
 #define _WEXT_H
+#include <linux/netdevice.h>
+#include <linux/if.h>
 #include <linux/wireless.h>
-extern struct iw_statistics *get_wireless_stats(struct net_device *dev,
-						struct iw_statistics *out);
-extern const struct iw_ioctl_description standard_ioctl[];
-extern const unsigned standard_ioctl_num;
+#include <net/iw_handler.h>
+
+/* wext compatibility must be compiled in...
+ * this extern is in wext-compat.c */
+struct cfg80211_ioctl_ops {
+	/* used to make sure the module isn't going away
+	 * can't really happen, except if no driver has cfg80211
+	 * in use, but in that case  */
+	struct module *module;
+
+	/* and finally this is used to do work */
+	int (*do_wext_ioctl)(struct ifreq *ifr, unsigned int cmd);
+};
+extern struct cfg80211_ioctl_ops cfg80211_ioctl_ops;
+
+
+struct iw_statistics *get_wireless_stats(struct net_device *dev,
+					 struct iw_statistics *out);
+int wireless_process_ioctl(struct ifreq *ifr, unsigned int cmd);
+
+int cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
+#ifdef CFG80211_MODULE
+int call_cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
+int cfg80211_wext_init(void);
+void cfg80211_wext_exit(void);
+#else
+#define call_cfg80211_wext_ioctl cfg80211_wext_ioctl
+static inline int cfg80211_wext_init(void)
+{
+	return 0;
+}
+static inline void cfg80211_wext_exit(void) {}
+#endif
+
+extern const struct iw_ioctl_description wext_standard_ioctl[];
+extern const unsigned wext_standard_ioctl_num;
 extern const struct iw_ioctl_description standard_event[];
 extern const int event_type_size[];
 #endif /* _WEXT_H */
--- wireless-dev.orig/net/wireless/nl80211.c	2007-02-09 17:08:26.663840519 +0100
+++ wireless-dev/net/wireless/nl80211.c	2007-02-09 17:08:44.063840519 +0100
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
 
@@ -112,7 +113,7 @@ static int nl80211_get_cmdlist(struct sk
 		goto put_drv;
 	}
 
-	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->wiphy);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->wiphy.wiphy_index);
 
 	start = nla_nest_start(msg, NL80211_ATTR_CMDS);
 	if (!start)
@@ -124,7 +125,6 @@ static int nl80211_get_cmdlist(struct sk
 	NLA_PUT_FLAG(msg, NL80211_CMD_GET_WIPHYS);
 	NLA_PUT_FLAG(msg, NL80211_CMD_GET_INTERFACES);
 
-	CHECK_CMD(inject_packet, INJECT);
 	CHECK_CMD(add_virtual_intf, ADD_VIRTUAL_INTERFACE);
 	CHECK_CMD(del_virtual_intf, DEL_VIRTUAL_INTERFACE);
 	CHECK_CMD(configure, CONFIGURE);
@@ -178,7 +178,7 @@ static int nl80211_get_wiphys(struct sk_
 		indexstart = nla_nest_start(msg, idx++);
 		if (!indexstart)
 			goto nla_put_failure;
-		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->wiphy);
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->wiphy.wiphy_index);
 		nla_nest_end(msg, indexstart);
 	}
 	mutex_unlock(&cfg80211_drv_mutex);
@@ -248,7 +248,7 @@ static int nl80211_get_intfs(struct sk_b
 		goto put_drv;
 	}
 
-	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->wiphy);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->wiphy.wiphy_index);
 
 	start = nla_nest_start(msg, NL80211_ATTR_INTERFACE_LIST);
 	if (!start) {
@@ -258,7 +258,7 @@ static int nl80211_get_intfs(struct sk_b
 
 	cb.skb = msg;
 	cb.idx = 1;
-	err = drv->ops->list_interfaces(drv->priv, &cb, addifidx);
+	err = drv->ops->list_interfaces(&drv->wiphy, &cb, addifidx);
 	if (err)
 		goto msg_free;
 
@@ -278,38 +278,6 @@ static int nl80211_get_intfs(struct sk_b
 	return err;
 }
 
-static int nl80211_do_inject(struct sk_buff *skb, struct genl_info *info)
-{
-	struct cfg80211_registered_driver *drv;
-	u32 flags = 0;
-	int err, queue = -1;
-
-	if (!info->attrs[NL80211_ATTR_FRAME])
-		return -EINVAL;
-	if (info->attrs[NL80211_ATTR_FLAGS])
-		flags = nla_get_u32(info->attrs[NL80211_ATTR_FLAGS]);
-	if (info->attrs[NL80211_ATTR_QUEUE])
-		queue = (int) nla_get_u32(info->attrs[NL80211_ATTR_QUEUE]);
-
-	drv = cfg80211_get_drv_from_info(info);
-	if (IS_ERR(drv))
-		return PTR_ERR(drv);
-
-	if (!drv->ops->inject_packet) {
-		err = -ENOSYS;
-		goto unlock;
-	}
-
-	err = drv->ops->inject_packet(drv->priv,
-		nla_data(info->attrs[NL80211_ATTR_FRAME]),
-		nla_len(info->attrs[NL80211_ATTR_FRAME]),
-		flags,
-		queue);
- unlock:
-	cfg80211_put_drv(drv);
-	return err;
-}
-
 static int nl80211_add_virt_intf(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_driver *drv;
@@ -334,7 +302,7 @@ static int nl80211_add_virt_intf(struct 
 		goto unlock;
 	}
 
-	err = drv->ops->add_virtual_intf(drv->priv,
+	err = drv->ops->add_virtual_intf(&drv->wiphy,
 		nla_data(info->attrs[NL80211_ATTR_IFNAME]), type);
 
  unlock:
@@ -359,7 +327,7 @@ static int nl80211_del_virt_intf(struct 
 		goto out;
 	}
 
-	err = drv->ops->del_virtual_intf(drv->priv, ifindex);
+	err = drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
 
  out:
 	cfg80211_put_drv(drv);
@@ -421,7 +389,7 @@ static int nl80211_configure(struct sk_b
 		config.channel = nla_get_u32(attr);
 	}
 
-	err = drv->ops->configure(drv->priv, dev, &config);
+	err = drv->ops->configure(&drv->wiphy, dev, &config);
  out:
 	cfg80211_put_drv(drv);
 	dev_put(dev);
@@ -448,7 +416,7 @@ static int nl80211_get_config(struct sk_
 
 	memset(&config, 0, sizeof(config));
 
-	drv->ops->get_config(drv->priv, dev, &config);
+	drv->ops->get_config(&drv->wiphy, dev, &config);
 
 	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
 			     NL80211_CMD_NEW_CONFIG);
@@ -514,7 +482,7 @@ static int nl80211_set_roaming(struct sk
 		goto out;
 	}
 
-	err = drv->ops->set_roaming(drv->priv, dev, roaming_control);
+	err = drv->ops->set_roaming(&drv->wiphy, dev, roaming_control);
  out:
 	cfg80211_put_drv(drv);
 	dev_put(dev);
@@ -538,7 +506,7 @@ static int nl80211_get_roaming(struct sk
 		goto out_put_drv;
 	}
 
-	err = drv->ops->get_roaming(drv->priv, dev);
+	err = drv->ops->get_roaming(&drv->wiphy, dev);
 	if (err < 0)
 		goto out_put_drv;
 
@@ -586,7 +554,7 @@ static int nl80211_set_fixed_bssid(struc
 		goto out;
 	}
 
-	err = drv->ops->set_fixed_bssid(drv->priv, dev, bssid);
+	err = drv->ops->set_fixed_bssid(&drv->wiphy, dev, bssid);
  out:
 	cfg80211_put_drv(drv);
 	dev_put(dev);
@@ -611,7 +579,7 @@ static int nl80211_get_fixed_bssid(struc
 		goto out_put_drv;
 	}
 
-	err = drv->ops->get_fixed_bssid(drv->priv, dev, bssid);
+	err = drv->ops->get_fixed_bssid(&drv->wiphy, dev, bssid);
 	if (err < 0)
 		goto out_put_drv;
 
@@ -657,7 +625,7 @@ static int nl80211_get_association(struc
 		goto out_put_drv;
 	}
 
-	err = drv->ops->get_association(drv->priv, dev, bssid);
+	err = drv->ops->get_association(&drv->wiphy, dev, bssid);
 	if (err < 0)
 		goto out_put_drv;
 
@@ -691,7 +659,7 @@ static int nl80211_assoc_deauth(struct s
 	struct cfg80211_registered_driver *drv;
 	int err;
 	struct net_device *dev;
-	int (*act)(void *priv, struct net_device *dev);
+	int (*act)(struct wiphy *wiphy, struct net_device *dev);
 
 	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
 	if (err)
@@ -716,7 +684,7 @@ static int nl80211_assoc_deauth(struct s
 		goto out;
 	}
 
-	err = act(drv->priv, dev);
+	err = act(&drv->wiphy, dev);
  out:
 	cfg80211_put_drv(drv);
 	dev_put(dev);
@@ -778,7 +746,7 @@ static int nl80211_get_auth_list(struct 
 
 	cb.skb = msg;
 	cb.idx = 1;
-	err = drv->ops->get_auth_list(drv->priv, dev, &cb, add_bssid);
+	err = drv->ops->get_auth_list(&drv->wiphy, dev, &cb, add_bssid);
 	if (err)
 		goto msg_free;
 
@@ -874,7 +842,7 @@ static int nl80211_initiate_scan(struct 
 	params.channels = channels;
 	params.n_channels = count;
 
-	err = drv->ops->initiate_scan(drv->priv, dev, &params);
+	err = drv->ops->initiate_scan(&drv->wiphy, dev, &params);
 
 	kfree(channels);
  out:
@@ -903,12 +871,6 @@ static struct genl_ops nl80211_ops[] = {
 		/* can be retrieved by unprivileged users */
 	},
 	{
-		.cmd = NL80211_CMD_INJECT,
-		.doit = nl80211_do_inject,
-		.policy = nl80211_policy,
-		.flags = GENL_ADMIN_PERM,
-	},
-	{
 		.cmd = NL80211_CMD_ADD_VIRTUAL_INTERFACE,
 		.doit = nl80211_add_virt_intf,
 		.policy = nl80211_policy,
--- wireless-dev.orig/include/linux/nl80211.h	2007-02-09 17:08:25.813840519 +0100
+++ wireless-dev/include/linux/nl80211.h	2007-02-09 17:08:44.063840519 +0100
@@ -20,11 +20,6 @@ enum {
 	/* Supported commands returned */
 	NL80211_CMD_NEW_CMDLIST,
 
-	/* Inject a frame using NL80211_ATTR_FLAGS and NL80211_ATTR_FRAME.
-	 * If kernel sends this, it's a status notification for the injected
-	 * frame. */
-	NL80211_CMD_INJECT,
-
 	/* add a virtual interface to a group that is identified by any
 	 * other ifindex in the group of a wiphy index, needs the
 	 * NL80211_IF_NAME attribute */

--

