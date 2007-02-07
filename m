Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3478 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965634AbXBGBOu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 20:14:50 -0500
Date: Tue, 6 Feb 2007 19:47:47 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 1/3] wireless: add cfg80211
Message-ID: <20070207004747.GB23096@tuxdriver.com>
References: <20070131013717.GA28076@tuxdriver.com> <20070207004626.GA23096@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070207004626.GA23096@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This patch adds cfg80211, a new configuration system for wireless
hardware.

It currently features a bunch of configuration requests, support for
adding and removing virtual interfaces, the ability to inject packets and
more.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/linux/netdevice.h  |    1 +
 include/net/cfg80211.h     |  186 ++++++++++++++++++++++++++++++++++++++++++++
 net/Kconfig                |    3 +
 net/Makefile               |    1 +
 net/wireless/Makefile      |    4 +
 net/wireless/core.c        |  158 +++++++++++++++++++++++++++++++++++++
 net/wireless/core.h        |   57 ++++++++++++++
 net/wireless/wext-compat.c |   25 ++++++
 8 files changed, 435 insertions(+), 0 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fea0d9d..c1e9962 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -398,6 +398,7 @@ struct net_device
 	void                    *ip6_ptr;       /* IPv6 specific data */
 	void			*ec_ptr;	/* Econet specific data	*/
 	void			*ax25_ptr;	/* AX.25 specific data */
+	void			*ieee80211_ptr;	/* IEEE 802.11 specific data */
 
 /*
  * Cache line mostly used on receive path (including eth_type_trans())
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
new file mode 100644
index 0000000..c0bc9d4
--- /dev/null
+++ b/include/net/cfg80211.h
@@ -0,0 +1,186 @@
+#ifndef __NET_CFG80211_H
+#define __NET_CFG80211_H
+
+#include <linux/netlink.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <net/genetlink.h>
+
+/*
+ * 802.11 configuration in-kernel interface
+ *
+ * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ */
+
+/**
+ * struct cfg80211_config - description of a configuration (request)
+ */
+struct cfg80211_config {
+	/* first fields with 'internal' validity */
+
+	/* SSID to use, valid if not NULL, ssid_len then
+	 * contains the length. change forces reassociation */
+	s8 ssid_len;
+	u8 *ssid;
+
+	/* now fields with explicit validity */
+#define CFG80211_CFG_VALID_NWID			(1<<0)
+#define CFG80211_CFG_VALID_RX_SENSITIVITY	(1<<1)
+#define CFG80211_CFG_VALID_TRANSMIT_POWER	(1<<2)
+#define CFG80211_CFG_VALID_FRAG_THRESHOLD	(1<<3)
+#define CFG80211_CFG_VALID_CHANNEL		(1<<4)
+	unsigned int valid;
+
+	u16 network_id;
+	s32 rx_sensitivity;
+	u32 transmit_power;
+	u32 fragmentation_threshold;
+	u32 channel;
+};
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
+ * The priv pointer passed to each call is the pointer that was
+ * registered in cfg80211_register_driver().
+ *
+ * All callbacks except where otherwise noted should return 0
+ * on success or a negative error code.
+ *
+ * @list_interfaces: for each interfaces belonging to the wiphy identified
+ *		     by the priv pointer, call the one() function with the
+ *		     given data and the ifindex. This callback is required.
+ *
+ * @inject_packet: inject the given frame with the NL80211_FLAG_*
+ *		   flags onto the given queue.
+ *
+ * @add_virtual_intf: create a new virtual interface with the given name
+ *
+ * @del_virtual_intf: remove the virtual interface determined by ifindex.
+ *
+ * @configure: configure the given interface as requested in the config struct.
+ *	       must not ignore any configuration item, if something is
+ *	       is requested that cannot be fulfilled return an error
+ *
+ * @get_config: fill the given config structure with the current configuration
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
+	int	(*list_interfaces)(void *priv, void *data,
+				   int (*one)(void *data, int ifindex));
+
+
+	int	(*inject_packet)(void *priv, void *frame, int framelen,
+				 u32 flags, int queue);
+
+
+	int	(*add_virtual_intf)(void *priv, char *name,
+				    unsigned int type);
+	int	(*del_virtual_intf)(void *priv, int ifindex);
+
+
+	int	(*configure)(void *priv, struct net_device *dev,
+			     struct cfg80211_config *cfg);
+	void	(*get_config)(void *priv, struct net_device *dev,
+			      struct cfg80211_config *cfg);
+
+
+	int	(*reassociate)(void *priv, struct net_device *dev);
+	int	(*disassociate)(void *priv, struct net_device *dev);
+	int	(*deauth)(void *priv, struct net_device *dev);
+
+
+	int	(*initiate_scan)(void *priv, struct net_device *dev,
+				 struct scan_params *params);
+
+
+	int	(*set_roaming)(void *priv, struct net_device *dev,
+			       int roaming_control);
+	int	(*get_roaming)(void *priv, struct net_device *dev);
+	int	(*set_fixed_bssid)(void *priv, struct net_device *dev,
+				   u8 *bssid);
+	int	(*get_fixed_bssid)(void *priv, struct net_device *dev,
+				   u8 *bssid);
+
+
+	int	(*get_association)(void *priv, struct net_device *dev,
+				   u8 *bssid);
+
+	int	(*get_auth_list)(void *priv, struct net_device *dev,
+				 void *data,
+				 int (*next_bssid)(void *data, u8 *bssid));
+};
+
+/**
+ * cfg80211_register - register a wiphy with cfg80211
+ *
+ * register a given method structure with the cfg80211 system
+ * and associate the 'priv' pointer with it.
+ *
+ * Returns a non-negative wiphy index or a negative error code.
+ *
+ * NOTE: for proper operation, this priv pointer MUST also be
+ * assigned to each &struct net_device's @ieee80211_ptr member!
+ */
+extern int cfg80211_register(struct cfg80211_ops *ops, void *priv);
+
+/**
+ * cfg80211_unregister - deregister a wiphy from cfg80211
+ *
+ * unregister a device with the given priv pointer.
+ * After this call, no more requests can be made with this priv
+ * pointer, but the call may sleep to wait for an outstanding
+ * request that is being handled.
+ */
+extern void cfg80211_unregister(void *priv);
+
+#endif /* __NET_CFG80211_H */
diff --git a/net/Kconfig b/net/Kconfig
index 7dfc949..8d121a5 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -226,6 +226,9 @@ config WIRELESS_EXT
 config FIB_RULES
 	bool
 
+config CFG80211
+	tristate "Improved wireless configuration API"
+
 endif   # if NET
 endmenu # Networking
 
diff --git a/net/Makefile b/net/Makefile
index ad4d14f..278d6bf 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_ECONET)		+= econet/
 obj-$(CONFIG_VLAN_8021Q)	+= 8021q/
 obj-$(CONFIG_IP_DCCP)		+= dccp/
 obj-$(CONFIG_IP_SCTP)		+= sctp/
+obj-$(CONFIG_CFG80211)		+= wireless/
 obj-$(CONFIG_IEEE80211)		+= ieee80211/
 obj-$(CONFIG_TIPC)		+= tipc/
 obj-$(CONFIG_NETLABEL)		+= netlabel/
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
new file mode 100644
index 0000000..4a87dce
--- /dev/null
+++ b/net/wireless/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_CFG80211) += cfg80211.o
+
+cfg80211-objs := \
+	core.o
diff --git a/net/wireless/core.c b/net/wireless/core.c
new file mode 100644
index 0000000..60b280e
--- /dev/null
+++ b/net/wireless/core.c
@@ -0,0 +1,158 @@
+/*
+ * This is the new wireless configuration interface.
+ *
+ * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include "core.h"
+#include <linux/if.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <net/genetlink.h>
+#include <net/cfg80211.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+
+MODULE_AUTHOR("Johannes Berg");
+MODULE_LICENSE("GPL");
+
+/* RCU might be appropriate here since we usually
+ * only read the list, and that can happen quite
+ * often because we need to do it for each command */
+LIST_HEAD(cfg80211_drv_list);
+DEFINE_MUTEX(cfg80211_drv_mutex);
+static int wiphy_counter;
+
+/* requires cfg80211_drv_mutex to be held! */
+static struct cfg80211_registered_driver *cfg80211_drv_by_priv(void *priv)
+{
+	struct cfg80211_registered_driver *result = NULL, *drv;
+
+	if (!priv)
+		return NULL;
+
+	list_for_each_entry(drv, &cfg80211_drv_list, list) {
+		if (drv->priv == priv) {
+			result = drv;
+			break;
+		}
+	}
+
+	return result;
+}
+
+/* wext will need this */
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
+	drv = cfg80211_drv_by_priv(dev->ieee80211_ptr);
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
+int cfg80211_register(struct cfg80211_ops *ops, void *priv)
+{
+	struct cfg80211_registered_driver *drv;
+	int res;
+
+	if (!priv || !ops->list_interfaces)
+		return -EINVAL;
+
+	mutex_lock(&cfg80211_drv_mutex);
+
+	if (cfg80211_drv_by_priv(priv)) {
+		res = -EALREADY;
+		goto out_unlock;
+	}
+
+	drv = kzalloc(sizeof(struct cfg80211_registered_driver), GFP_KERNEL);
+	if (!drv) {
+		res = -ENOMEM;
+		goto out_unlock;
+	}
+
+	drv->ops = ops;
+	drv->priv = priv;
+
+	if (unlikely(wiphy_counter<0)) {
+		/* ugh, wrapped! */
+		kfree(drv);
+		res = -ENOSPC;
+		goto out_unlock;
+	}
+	mutex_init(&drv->mtx);
+	drv->wiphy = wiphy_counter;
+	list_add(&drv->list, &cfg80211_drv_list);
+	/* return wiphy number */
+	res = drv->wiphy;
+
+	/* now increase counter for the next time */
+	wiphy_counter++;
+
+ out_unlock:
+	mutex_unlock(&cfg80211_drv_mutex);
+	return res;
+}
+EXPORT_SYMBOL_GPL(cfg80211_register);
+
+void cfg80211_unregister(void *priv)
+{
+	struct cfg80211_registered_driver *drv;
+
+	mutex_lock(&cfg80211_drv_mutex);
+	drv = cfg80211_drv_by_priv(priv);
+	if (!drv) {
+		printk(KERN_ERR "deregistering cfg80211 backend that "
+		       " was never registered!\n");
+		mutex_unlock(&cfg80211_drv_mutex);
+		return;
+	}
+
+	/* hold registered driver mutex during list removal as well
+	 * to make sure no commands are in progress at the moment */
+	mutex_lock(&drv->mtx);
+	list_del(&drv->list);
+	mutex_unlock(&drv->mtx);
+
+	mutex_unlock(&cfg80211_drv_mutex);
+
+	mutex_destroy(&drv->mtx);
+	kfree(drv);
+}
+EXPORT_SYMBOL_GPL(cfg80211_unregister);
+
+/* module initialisation/exit functions */
+
+static int cfg80211_init(void)
+{
+	/* possibly need to do more later */
+	return 0;
+}
+
+static void cfg80211_exit(void)
+{
+}
+
+module_init(cfg80211_init);
+module_exit(cfg80211_exit);
diff --git a/net/wireless/core.h b/net/wireless/core.h
new file mode 100644
index 0000000..562c476
--- /dev/null
+++ b/net/wireless/core.h
@@ -0,0 +1,57 @@
+/*
+ * Wireless configuration interface internals.
+ *
+ * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ */
+#ifndef __NET_WIRELESS_CORE_H
+#define __NET_WIRELESS_CORE_H
+#include <net/cfg80211.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <net/genetlink.h>
+
+struct cfg80211_registered_driver {
+	struct cfg80211_ops *ops;
+	int wiphy;
+	void *priv;
+	struct list_head list;
+	/* we hold this mutex during any call so that
+	 * we cannot do multiple calls at once, and also
+	 * to avoid the deregister call to proceed while
+	 * any call is in progress */
+	struct mutex mtx;
+};
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
+#endif /* __NET_WIRELESS_CORE_H */
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
new file mode 100644
index 0000000..1c7c361
--- /dev/null
+++ b/net/wireless/wext-compat.c
@@ -0,0 +1,25 @@
+/* NOT YET */
+
+To implement compatibility, we add a new field to struct net_device
+that contains the pending configuration structure. This is dynamically
+allocated when needed and freed when committed.
+In a way it replaces the wireless_handlers field in there which is now
+done by dynamic lookup. No worries. No one is going to have thousands
+of wireless devices, and if that changes we can still trivially change
+this assumption :)
+
+Commit is done some time after the last parameter was changed
+(with each parameter change simply (re-)schedule a timer) or
+if explicitly asked for. This is probably not what most people
+would expect, but perfectly fine in the WE API.
+
+compatibility mappings:
+
+SIOCSIWAP
+  -> if bssid is all-ones: set roaming to kernel, reassociate
+  -> if bssid is all-zeroes: set roaming to kernel
+  -> otherwise: set roaming to userspace, set bssid
+
+SIOCGIWAP
+  -> get association parameters and fill return bssid appropriately
+
-- 
1.4.4.2

-- 
John W. Linville
linville@tuxdriver.com
