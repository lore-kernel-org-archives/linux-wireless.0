Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49944 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946621AbXBIQdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 11:33:23 -0500
Message-Id: <20070209162826.930724000@sipsolutions.net>
References: <20070209162711.375886000@sipsolutions.net>
Date: Fri, 09 Feb 2007 17:27:12 +0100
From: johannes@sipsolutions.net
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/4] create cfg80211
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds cfg80211, a new configuration system for wireless
hardware.

It currently features a bunch of configuration requests, support for
adding and removing virtual interfaces and lots more. It also takes
ownership of a new ieee80211_ptr in struct net_device with a newly
created struct wiphy.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/netdevice.h |    3 
 include/net/cfg80211.h    |  235 ++++++++++++++++++++++++++++++++++++++++++++++
 net/Kconfig               |    3 
 net/Makefile              |    1 
 net/wireless/Makefile     |    3 
 net/wireless/core.c       |  160 +++++++++++++++++++++++++++++++
 net/wireless/core.h       |   68 +++++++++++++
 net/wireless/sysfs.c      |   65 ++++++++++++
 net/wireless/sysfs.h      |   10 +
 9 files changed, 548 insertions(+)

--- linux-2.6.orig/include/linux/netdevice.h	2007-02-09 16:58:57.853840519 +0100
+++ linux-2.6/include/linux/netdevice.h	2007-02-09 17:05:52.723840519 +0100
@@ -42,6 +42,8 @@
 struct vlan_group;
 struct ethtool_ops;
 struct netpoll_info;
+/* 802.11 specific */
+struct wiphy;
 					/* source back-compat hooks */
 #define SET_ETHTOOL_OPS(netdev,ops) \
 	( (netdev)->ethtool_ops = (ops) )
@@ -398,6 +400,7 @@ struct net_device
 	void                    *ip6_ptr;       /* IPv6 specific data */
 	void			*ec_ptr;	/* Econet specific data	*/
 	void			*ax25_ptr;	/* AX.25 specific data */
+	struct wiphy		*ieee80211_ptr;	/* IEEE 802.11 specific data */
 
 /*
  * Cache line mostly used on receive path (including eth_type_trans())
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/net/cfg80211.h	2007-02-09 16:59:00.363840519 +0100
@@ -0,0 +1,235 @@
+#ifndef __NET_CFG80211_H
+#define __NET_CFG80211_H
+
+#include <linux/netlink.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <net/genetlink.h>
+#include <linux/wireless.h>
+#include <linux/device.h>
+
+/*
+ * 802.11 configuration and wiphy management in-kernel interface
+ *
+ * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ */
+
+/**
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
+};
+
+#define WIPHY_PRIV_ALIGN	32
+#define WIPHY_PRIV_ALIGN_CONST	(WIPHY_PRIV_ALIGN-1)
+
+/**
+ * struct cfg80211_config - description of a configuration (request)
+ */
+struct cfg80211_config {
+	/* see below */
+	u32 valid;
+
+	s8 ssid_len;
+	u8 *ssid;
+
+	u16 network_id;
+	s32 rx_sensitivity;
+	u32 transmit_power;
+	u32 fragmentation_threshold;
+	u32 channel;
+};
+
+#define CFG80211_CFG_VALID_SSID			(1<<0)
+#define CFG80211_CFG_VALID_NWID			(1<<1)
+#define CFG80211_CFG_VALID_RX_SENSITIVITY	(1<<2)
+#define CFG80211_CFG_VALID_TRANSMIT_POWER	(1<<3)
+#define CFG80211_CFG_VALID_FRAG_THRESHOLD	(1<<4)
+#define CFG80211_CFG_VALID_CHANNEL		(1<<5)
+
+struct scan_channel {
+	u32 channel;
+	int active;
+};
+
+struct scan_params {
+	/* number of items in 'channels' array
+	 * or -1 to indicate scanning all channels
+	 * (in that case 'channels' is NULL) */
+	int n_channels;
+
+	/* use only when n_channels is -1 to determine
+	 * whether scanning should be active or not */
+	int active;
+
+	/* the channel list if any */
+	struct scan_channel *channels;
+};
+
+/**
+ * struct cfg80211_ops - backend description for wireless configuration
+ *
+ * This struct is registered by fullmac card drivers and/or wireless stacks
+ * in order to handle configuration requests on their interfaces.
+ *
+ * All callbacks except where otherwise noted should return 0
+ * on success or a negative error code.
+ *
+ * @list_interfaces: Call the one() function with the given data and the
+ *                   ifindex for each interface belonging to the wiphy.
+ *		     This callback is required.
+ *
+ * @add_virtual_intf: create a new virtual interface with the given name
+ *
+ * @del_virtual_intf: remove the virtual interface determined by ifindex.
+ *
+ * @configure: configure the given interface as requested in the config struct.
+ *	       must not ignore any configuration item, if something is
+ *	       is requested that cannot be fulfilled return an error.
+ *             This call does not actually initiate any association or such.
+ *
+ * @get_config: fill the given config structure with the current configuration
+ *
+ * @get_config_valid: return a bitmask of CFG80211_CFG_VALID_* indicating
+ *		      which parameters can be set.
+ *
+ * @associate: associate with previously given settings (SSID, BSSID
+ *             if userspace roaming is enabled)
+ *
+ * @reassociate: reassociate with current settings (SSID, BSSID if
+ *		 userspace roaming is enabled)
+ *
+ * @disassociate: disassociate from current AP
+ *
+ * @deauth: deauth from current AP
+ *
+ * @initiate_scan: ...
+ *
+ * @set_roaming: set who gets to control roaming, the roaming_control
+ *		 parameter is passed NL80211_ROAMING_CONTROL_* values.
+ *
+ * @get_roaming: return where roaming control currently is done or
+ *		 a negative error.
+ *
+ * @set_fixed_bssid: set BSSID to use with userspace roaming, forces
+ *		     reassociation if changing.
+ * @get_fixed_bssid: get BSSID that is used with userspace roaming,
+ *		     the bssid parameter has space for 6 bytes
+ *
+ * @get_association: get BSSID of the BSS that the device is currently
+ *		     associated to and return 1, or return 0 if not
+ *		     associated (or a negative error code)
+ * @get_auth_list: get list of BSSIDs of all BSSs the device has
+ *		   authenticated with, must call next_bssid for each,
+ *		   next_bssid returns non-zero on error, the given data
+ *		   is to be passed to that callback
+ */
+struct cfg80211_ops {
+	int	(*list_interfaces)(struct wiphy *wiphy, void *data,
+				   int (*one)(void *data, int ifindex));
+
+
+	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
+				    unsigned int type);
+	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
+
+
+	int	(*configure)(struct wiphy *wiphy, struct net_device *dev,
+			     struct cfg80211_config *cfg);
+	void	(*get_config)(struct wiphy *wiphy, struct net_device *dev,
+			      struct cfg80211_config *cfg);
+	u32	(*get_config_valid)(struct wiphy *wiphy,
+				    struct net_device *dev);
+
+
+	int	(*associate)(struct wiphy *wiphy, struct net_device *dev);
+	int	(*reassociate)(struct wiphy *wiphy, struct net_device *dev);
+	int	(*disassociate)(struct wiphy *wiphy, struct net_device *dev);
+	int	(*deauth)(struct wiphy *wiphy, struct net_device *dev);
+
+
+	int	(*initiate_scan)(struct wiphy *wiphy, struct net_device *dev,
+				 struct scan_params *params);
+
+
+	int	(*set_roaming)(struct wiphy *wiphy, struct net_device *dev,
+			       int roaming_control);
+	int	(*get_roaming)(struct wiphy *wiphy, struct net_device *dev);
+	int	(*set_fixed_bssid)(struct wiphy *wiphy, struct net_device *dev,
+				   u8 *bssid);
+	int	(*get_fixed_bssid)(struct wiphy *wiphy, struct net_device *dev,
+				   u8 *bssid);
+
+
+	int	(*get_association)(struct wiphy *wiphy, struct net_device *dev,
+				   u8 *bssid);
+
+	int	(*get_auth_list)(struct wiphy *wiphy, struct net_device *dev,
+				 void *data,
+				 int (*next_bssid)(void *data, u8 *bssid));
+};
+
+/**
+ * wiphy_priv - return priv from wiphy
+ */
+static inline void *wiphy_priv(struct wiphy *wiphy)
+{
+	return (char *)wiphy +
+		((sizeof(struct wiphy)+WIPHY_PRIV_ALIGN_CONST)
+			& ~WIPHY_PRIV_ALIGN_CONST);
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
+ * cfg80211_free - free wiphy
+ */
+extern void wiphy_free(struct wiphy *wiphy);
+
+#endif /* __NET_CFG80211_H */
--- linux-2.6.orig/net/Kconfig	2007-02-09 16:58:57.963840519 +0100
+++ linux-2.6/net/Kconfig	2007-02-09 17:05:52.853840519 +0100
@@ -226,6 +226,9 @@ config WIRELESS_EXT
 config FIB_RULES
 	bool
 
+config CFG80211
+	tristate "Improved wireless configuration API"
+
 endif   # if NET
 endmenu # Networking
 
--- linux-2.6.orig/net/Makefile	2007-02-09 16:58:57.983840519 +0100
+++ linux-2.6/net/Makefile	2007-02-09 17:05:55.643840519 +0100
@@ -44,6 +44,7 @@ obj-$(CONFIG_ECONET)		+= econet/
 obj-$(CONFIG_VLAN_8021Q)	+= 8021q/
 obj-$(CONFIG_IP_DCCP)		+= dccp/
 obj-$(CONFIG_IP_SCTP)		+= sctp/
+obj-$(CONFIG_CFG80211)		+= wireless/
 obj-$(CONFIG_IEEE80211)		+= ieee80211/
 obj-$(CONFIG_TIPC)		+= tipc/
 obj-$(CONFIG_NETLABEL)		+= netlabel/
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/net/wireless/Makefile	2007-02-09 17:05:55.863840519 +0100
@@ -0,0 +1,3 @@
+obj-$(CONFIG_CFG80211) += cfg80211.o
+
+cfg80211-y += core.o sysfs.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/net/wireless/core.c	2007-02-09 17:06:41.513840519 +0100
@@ -0,0 +1,160 @@
+/*
+ * This is the linux wireless configuration interface.
+ *
+ * Copyright 2006, 2007		Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include <linux/if.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <net/genetlink.h>
+#include <net/cfg80211.h>
+#include "core.h"
+#include "sysfs.h"
+
+MODULE_AUTHOR("Johannes Berg");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("wireless configuration support");
+
+/* RCU might be appropriate here since we usually
+ * only read the list, and that can happen quite
+ * often because we need to do it for each command */
+LIST_HEAD(cfg80211_drv_list);
+DEFINE_MUTEX(cfg80211_drv_mutex);
+static int wiphy_counter;
+
+struct cfg80211_registered_driver *
+cfg80211_get_drv_from_ifindex(int ifindex)
+{
+	struct cfg80211_registered_driver *drv = ERR_PTR(-ENODEV);
+	struct net_device *dev;
+
+	mutex_lock(&cfg80211_drv_mutex);
+	dev = dev_get_by_index(ifindex);
+	if (!dev)
+		goto out;
+	drv = wiphy_to_drv(dev->ieee80211_ptr);
+	if (drv)
+		mutex_lock(&drv->mtx);
+	else
+		drv = ERR_PTR(-ENODEV);
+	dev_put(dev);
+ out:
+	mutex_unlock(&cfg80211_drv_mutex);
+	return drv;
+}
+
+void cfg80211_put_drv(struct cfg80211_registered_driver *drv)
+{
+	BUG_ON(IS_ERR(drv));
+	mutex_unlock(&drv->mtx);
+}
+
+/* exported functions */
+
+struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
+{
+	struct cfg80211_registered_driver *result;
+	int alloc_size;
+
+	if (!ops->list_interfaces)
+		return NULL;
+
+	alloc_size = sizeof(*result) + sizeof_priv;
+
+	result = kzalloc(alloc_size, GFP_KERNEL);
+	if (!result)
+		return NULL;
+
+	result->ops = ops;
+	mutex_init(&result->mtx);
+	/* special index -1: newly created */
+	result->wiphy.wiphy_index = -1;
+
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
+
+	if (unlikely(wiphy_counter<0)) {
+		/* ugh, wrapped! */
+		res = -ENOSPC;
+		goto out_unlock;
+	}
+	drv->wiphy.wiphy_index = wiphy_counter;
+	list_add(&drv->list, &cfg80211_drv_list);
+
+	/* give it a proper name */
+	snprintf(drv->wiphy.class_dev.class_id, BUS_ID_SIZE,
+		 "wiphy%d", drv->wiphy.wiphy_index);
+
+	res = wiphy_sysfs_add(&drv->wiphy);
+	if (res)
+		goto out_unlock;
+
+	/* now increase counter for the next time */
+	wiphy_counter++;
+
+	/* return wiphy number */
+	res = drv->wiphy.wiphy_index;
+
+ out_unlock:
+	mutex_unlock(&cfg80211_drv_mutex);
+	return res;
+}
+EXPORT_SYMBOL(wiphy_register);
+
+void wiphy_unregister(struct wiphy *wiphy)
+{
+	struct cfg80211_registered_driver *drv = wiphy_to_drv(wiphy);
+
+	mutex_lock(&cfg80211_drv_mutex);
+
+	/* hold registered driver mutex during list removal as well
+	 * to make sure no commands are in progress at the moment */
+	mutex_lock(&drv->mtx);
+	list_del(&drv->list);
+	mutex_unlock(&drv->mtx);
+
+	mutex_unlock(&cfg80211_drv_mutex);
+}
+EXPORT_SYMBOL(wiphy_unregister);
+
+void cfg80211_drv_free(struct cfg80211_registered_driver *drv)
+{
+	mutex_destroy(&drv->mtx);
+	kfree(drv);
+}
+
+void wiphy_free(struct wiphy *wiphy)
+{
+	if (wiphy->wiphy_index != -1)
+		wiphy_sysfs_del(wiphy);
+	else
+		cfg80211_drv_free(wiphy_to_drv(wiphy));
+}
+EXPORT_SYMBOL(wiphy_free);
+
+
+static int cfg80211_init(void)
+{
+	return wiphy_sysfs_init();
+}
+module_init(cfg80211_init);
+
+static void cfg80211_exit(void)
+{
+	wiphy_sysfs_exit();
+}
+module_exit(cfg80211_exit);
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/net/wireless/core.h	2007-02-09 17:05:53.073840519 +0100
@@ -0,0 +1,68 @@
+/*
+ * Wireless configuration interface internals.
+ *
+ * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ */
+#ifndef __NET_WIRELESS_CORE_H
+#define __NET_WIRELESS_CORE_H
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/netdevice.h>
+#include <net/genetlink.h>
+#include <net/cfg80211.h>
+
+struct cfg80211_registered_driver {
+	struct cfg80211_ops *ops;
+	struct list_head list;
+	/* we hold this mutex during any call so that
+	 * we cannot do multiple calls at once, and also
+	 * to avoid the deregister call to proceed while
+	 * any call is in progress */
+	struct mutex mtx;
+
+	/* must be last because of the way we do wiphy_priv(),
+	 * and it should at least be aligned to NETDEV_ALIGN */
+	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
+};
+
+static inline struct cfg80211_registered_driver *wiphy_to_drv(struct wiphy *wiphy)
+{
+	return container_of(wiphy, struct cfg80211_registered_driver, wiphy);
+}
+
+extern struct mutex cfg80211_drv_mutex;
+extern struct list_head cfg80211_drv_list;
+
+/*
+ * This function returns a pointer to the driver
+ * that the genl_info item that is passed refers to.
+ * If successful, it returns non-NULL and also locks
+ * the driver's mutex!
+ *
+ * This means that you need to call cfg80211_put_drv()
+ * before being allowed to acquire &cfg80211_drv_mutex!
+ *
+ * This is necessary because we need to lock the global
+ * mutex to get an item off the list safely, and then
+ * we lock the drv mutex so it doesn't go away under us.
+ *
+ * We don't want to keep cfg80211_drv_mutex locked
+ * for all the time in order to allow requests on
+ * other interfaces to go through at the same time.
+ *
+ * The result of this can be a PTR_ERR and hence must
+ * be checked with IS_ERR() for errors.
+ */
+extern struct cfg80211_registered_driver *
+cfg80211_get_drv_from_info(struct genl_info *info);
+
+/* identical to cfg80211_get_drv_from_info but only operate on ifindex */
+extern struct cfg80211_registered_driver *
+cfg80211_get_drv_from_ifindex(int ifindex);
+
+extern void cfg80211_put_drv(struct cfg80211_registered_driver *drv);
+
+/* free object */
+extern void cfg80211_drv_free(struct cfg80211_registered_driver *drv);
+
+#endif /* __NET_WIRELESS_CORE_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/net/wireless/sysfs.c	2007-02-09 16:59:00.373840519 +0100
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
+++ linux-2.6/net/wireless/sysfs.h	2007-02-09 16:59:00.383840519 +0100
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

--

