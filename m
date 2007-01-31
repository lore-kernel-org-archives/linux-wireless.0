Return-path: <wireless-bounces@tuxdriver.com>
Received: from ra.tuxdriver.com (ra.tuxdriver.com [127.0.0.1])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V247fs002993
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 21:04:14 -0500
Received: (from uucp@localhost)
	by ra.tuxdriver.com (8.13.7/8.13.6/Submit) with UUCP id l0V1jPNt002608
	for wireless@lists.tuxdriver.org; Tue, 30 Jan 2007 20:45:25 -0500
Received: from linville-t43.mobile (linville-t43.mobile [127.0.0.1])
	by linville-t43.mobile (8.13.8/8.13.8) with ESMTP id l0V1ceHC028253
	for <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 20:38:40 -0500
Received: (from linville@localhost)
	by linville-t43.mobile (8.13.8/8.13.8/Submit) id l0V1ce1a028252
	for wireless@lists.tuxdriver.org; Tue, 30 Jan 2007 20:38:40 -0500
Date: Tue, 30 Jan 2007 20:38:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: wireless@lists.tuxdriver.org
Subject: [RFC PATCH 1/3] cfg80211 and nl80211
Message-ID: <20070131013840.GB28076@tuxdriver.com>
References: <20070131013717.GA28076@tuxdriver.com>
Mime-Version: 1.0
In-Reply-To: <20070131013717.GA28076@tuxdriver.com>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com

From: Johannes Berg <johannes@sipsolutions.net>

This patch adds cfg80211, a new configuration system for wireless hardware
as well as nl80211, the netlink-based userspace interface for it.

It currently features a bunch of configuration requests, support for
adding and removing virtual interfaces, the ability to inject packets and
more.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/linux/Kbuild       |    1 +
 include/linux/netdevice.h  |    1 +
 include/linux/nl80211.h    |  276 ++++++++++++
 include/net/cfg80211.h     |  193 ++++++++
 net/Kconfig                |    3 +
 net/Makefile               |    1 +
 net/wireless/Makefile      |    4 +
 net/wireless/core.c        |  235 ++++++++++
 net/wireless/core.h        |   57 +++
 net/wireless/nl80211.c     | 1049 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h     |    7 +
 net/wireless/wext-compat.c |   25 +
 12 files changed, 1852 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 157db77..a0657c6 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -115,6 +115,7 @@ header-y += netrom.h
 header-y += nfs2.h
 header-y += nfs4_mount.h
 header-y += nfs_mount.h
+header-y += nl80211.h
 header-y += oom.h
 header-y += param.h
 header-y += pci_regs.h
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
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
new file mode 100644
index 0000000..7bb84bb
--- /dev/null
+++ b/include/linux/nl80211.h
@@ -0,0 +1,276 @@
+#ifndef __LINUX_NL80211_H
+#define __LINUX_NL80211_H
+/*
+ * 802.11 netlink interface public header
+ *
+ * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ */
+
+/* currently supported commands
+ * don't change the order or add anything inbetween, this is ABI! */
+enum {
+	/* There's no technical reason to not use command 0 but malformed
+	 * zeroed messages may have it and this catches that */
+	NL80211_CMD_UNSPEC,
+
+	/* Get supported commands by ifindex,
+	 * uses NL80211_ATTR_CMDS (output) and NL80211_ATTR_IFINDEX (input) */
+	NL80211_CMD_GET_CMDLIST,
+
+	/* Supported commands returned */
+	NL80211_CMD_NEW_CMDLIST,
+
+	/* Inject a frame using NL80211_ATTR_FLAGS and NL80211_ATTR_FRAME.
+	 * If kernel sends this, it's a status notification for the injected
+	 * frame. */
+	NL80211_CMD_INJECT,
+
+	/* add a virtual interface to a group that is identified by any
+	 * other ifindex in the group of a wiphy index, needs the
+	 * NL80211_IF_NAME attribute */
+	NL80211_CMD_ADD_VIRTUAL_INTERFACE,
+
+	/* remove a given (with NL80211_ATTR_IFINDEX) virtual device */
+	NL80211_CMD_DEL_VIRTUAL_INTERFACE,
+
+	/* get list of all wiphys */
+	NL80211_CMD_GET_WIPHYS,
+
+	/* get list of all wiphys */
+	NL80211_CMD_NEW_WIPHYS,
+
+	/* get list of all interfaces belonging to a wiphy */
+	NL80211_CMD_GET_INTERFACES,
+
+	/* get list of all interfaces belonging to a wiphy */
+	NL80211_CMD_NEW_INTERFACES,
+
+	/* configure device */
+	NL80211_CMD_CONFIGURE,
+
+	/* request configuration */
+	NL80211_CMD_GET_CONFIG,
+
+	/* configuration sent from kernel */
+	NL80211_CMD_NEW_CONFIG,
+
+	/* initiate scan.
+	 * Takes a CHANNEL_LIST attribute containing nested
+	 * attributes which in turn contain CHANNEL and FLAGS
+	 * attributes.
+	 * The top level can also contain a FLAGS attribute
+	 * which is then the default for each channel.
+	 * If no channel list is given (or it is empty)
+	 * all channels shall be scanned. */
+	NL80211_CMD_INITIATE_SCAN,
+
+	/* scan result (kernel -> userspace) */
+	NL80211_CMD_SCAN_RESULT,
+
+	/* change roaming control */
+	NL80211_CMD_SET_ROAMING_CONTROL,
+
+	/* get roaming control setting */
+	NL80211_CMD_GET_ROAMING_CONTROL,
+
+	/* answer to that */
+	NL80211_CMD_ROAMING_CONTROL,
+
+	/* set access point BSSID for userspace roaming */
+	NL80211_CMD_SET_FIXED_BSSID,
+
+	/* get currently set userspace roaming BSSID */
+	NL80211_CMD_GET_FIXED_BSSID,
+
+	/* currently set roaming BSSID */
+	NL80211_CMD_FIXED_BSSID,
+
+	/* get current association information, if not associated then
+	 * the BSSID attribute is not present in response */
+	NL80211_CMD_GET_ASSOCIATION,
+
+	/* association notification and response to GET_BSSID */
+	NL80211_CMD_ASSOCIATION_CHANGED,
+
+	/* disassociate from current AP */
+	NL80211_CMD_DISASSOCIATE,
+
+	/* deauth from current AP */
+	NL80211_CMD_DEAUTH,
+
+	/* re-associate with current settings
+	 * (SSID and BSSID if roaming control in userspace) */
+	NL80211_CMD_REASSOCIATE,
+
+	/* request the full list of BSSs the device is
+	 * authenticated with */
+	NL80211_CMD_GET_AUTH_LIST,
+
+	/* sent as a response to GET_AUTH_LIST containing
+	 * an ATTR_BSSID_LIST */
+	NL80211_CMD_AUTH_LIST,
+
+	/* sent when authenticating/deauthenticating.
+	 * contains an ATTR_BSSID and possibly an
+	 * ATTR_DEAUTHENTICATED */
+	NL80211_CMD_AUTHENTICATION_CHANGED,
+
+	/* add commands here */
+
+	/* used to define NL80211_CMD_MAX below */
+	__NL80211_CMD_AFTER_LAST,
+};
+#define NL80211_CMD_MAX (__NL80211_CMD_AFTER_LAST - 1)
+
+
+/* currently supported attributes.
+ * don't change the order or add anything inbetween, this is ABI! */
+enum {
+	NL80211_ATTR_UNSPEC,
+
+	/* network device (ifindex) to operate on */
+	NL80211_ATTR_IFINDEX,
+
+	/* wiphy index to operate on */
+	NL80211_ATTR_WIPHY,
+
+	/* list of u8 cmds that a given device implements */
+	NL80211_ATTR_CMDS,
+
+	/* flags for injection and other commands, see below */
+	NL80211_ATTR_FLAGS,
+
+	/* which hardware queue to use */
+	NL80211_ATTR_QUEUE,
+
+	/* frame to inject or received frame for mgmt frame subscribers */
+	NL80211_ATTR_FRAME,
+
+	/* interface name */
+	NL80211_ATTR_IFNAME,
+
+	/* type of (virtual) interface */
+	NL80211_ATTR_IFTYPE,
+
+	/* interface list */
+	NL80211_ATTR_INTERFACE_LIST,
+
+	/* wiphy list */
+	NL80211_ATTR_WIPHY_LIST,
+
+	/* attributes used for configuration */
+	/* network ID (pre 802.11 HW) */
+	NL80211_ATTR_NETWORK_ID,
+
+	/* channel, 1-14 are B/G */
+	NL80211_ATTR_CHANNEL,
+
+	/* channel list for scan determination */
+	NL80211_ATTR_CHANNEL_LIST,
+
+	/* receiver sensitivity in dBm */
+	NL80211_ATTR_RX_SENSITIVITY,
+
+	/* BSSID to associate to, only used when roaming control
+	 * is in userspace */
+	NL80211_ATTR_BSSID,
+
+	/* list of multiple BSSIDs, this is a nested attribute
+	 * containing an index->(attrs) mapping */
+	NL80211_ATTR_BSSID_LIST,
+
+	/* this is a flag for when an authentication is lost */
+	NL80211_ATTR_DEAUTHENTICATED,
+
+	/* SSID of ESS to associate to */
+	NL80211_ATTR_SSID,
+
+	/* transmit power in mW */
+	NL80211_ATTR_TRANSMIT_POWER,
+
+	/* fragmentation threshold in bytes */
+	NL80211_ATTR_FRAG_THRESHOLD,
+
+	/* one or more information elements */
+	NL80211_ATTR_INFORMATION_ELEMENT,
+
+	NL80211_ATTR_ROAMING_CONTROL,
+
+	NL80211_ATTR_SCAN_TYPE,
+
+	/* add attributes here */
+
+	/* used to define NL80211_ATTR_MAX below */
+	__NL80211_ATTR_AFTER_LAST,
+};
+#define NL80211_ATTR_MAX (__NL80211_ATTR_AFTER_LAST - 1)
+
+/**
+ * NL80211_FLAG_TXSTATUS - send transmit status indication
+ */
+#define NL80211_FLAG_TXSTATUS		(1<<0)
+/**
+ * NL80211_FLAG_ENCRYPT - encrypt this packet
+ * Warning: This looks inside the packet header!
+ */
+#define NL80211_FLAG_ENCRYPT		(1<<1)
+
+/**
+ * NL80211_FLAG_SCAN_TYPE_ACTIVE - set this with a scan
+ * request to have it scan actively, can also be used
+ * within the nested CHANNEL_LIST...
+ */
+#define NL80211_FLAG_SCAN_TYPE_ACTIVE	(1<<2)
+
+/**
+ * maximum length of a frame that can be injected
+ */
+#define NL80211_MAX_FRAME_LEN 2500
+
+/* this is an arbitrary limit, 516 means two full-length
+ * IEs would fit... */
+/**
+ * maximum length of IE(s) passed in an NL80211_ATTR_INFORMATION_ELEMENT.
+ */
+#define NL80211_MAX_IE_LEN 516
+
+/* may need to be bumped? */
+/**
+ * maximum number of items in an ATTR_CHANNEL_LIST
+ */
+#define NL80211_MAX_CHANNEL_LIST_ITEM 20
+
+/**
+ * &enum nl80211_iftype - (virtual) interface types
+ *
+ * This structure is used with the NL80211_ATTR_IFTYPE
+ * to set the type of an interface.
+ * Note that these are intentionally compatible with
+ * the IW_MODE_* constants except for the removal of
+ * IW_MODE_AUTO.
+ *
+ */
+enum {
+	NL80211_IFTYPE_UNSPECIFIED,
+	NL80211_IFTYPE_ADHOC,
+	NL80211_IFTYPE_STATION,
+	NL80211_IFTYPE_AP,
+	NL80211_IFTYPE_WDS,
+	NL80211_IFTYPE_SECONDARY,
+	NL80211_IFTYPE_MONITOR,
+
+	/* keep last */
+	__NL80211_IFTYPE_AFTER_LAST
+};
+#define NL80211_IFTYPE_MAX (__NL80211_IFTYPE_AFTER_LAST - 1)
+
+enum {
+	NL80211_ROAMING_CONTROL_KERNEL,
+	NL80211_ROAMING_CONTROL_USERSPACE,
+
+	/* keep last */
+	__NL80211_ROAMING_CONTROL_AFTER_LAST
+};
+#define NL80211_ROAMING_CONTROL_MAX (__NL80211_ROAMING_CONTROL_AFTER_LAST-1)
+
+#endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
new file mode 100644
index 0000000..d83c47f
--- /dev/null
+++ b/include/net/cfg80211.h
@@ -0,0 +1,193 @@
+#ifndef __NET_CFG80211_H
+#define __NET_CFG80211_H
+
+#include <linux/netlink.h>
+#include <linux/nl80211.h>
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
+/* helper functions specific to nl80211 */
+extern void *nl80211hdr_put(struct sk_buff *skb, u32 pid,
+			    u32 seq, int flags, u8 cmd);
+extern void *nl80211msg_new(struct sk_buff **skb, u32 pid,
+			    u32 seq, int flags, u8 cmd);
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
index 0000000..c030b12
--- /dev/null
+++ b/net/wireless/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_CFG80211) += cfg80211.o
+
+cfg80211-objs := \
+	core.o nl80211.o
diff --git a/net/wireless/core.c b/net/wireless/core.c
new file mode 100644
index 0000000..4a10ec2
--- /dev/null
+++ b/net/wireless/core.c
@@ -0,0 +1,235 @@
+/*
+ * This is the new wireless configuration interface.
+ *
+ * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include "core.h"
+#include "nl80211.h"
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
+/* requires nl80211_drv_mutex to be held! */
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
+/* requires cfg80211_drv_mutex to be held! */
+static struct cfg80211_registered_driver *cfg80211_drv_by_wiphy(int wiphy)
+{
+	struct cfg80211_registered_driver *result = NULL, *drv;
+
+	list_for_each_entry(drv, &cfg80211_drv_list, list) {
+		if (drv->wiphy == wiphy) {
+			result = drv;
+			break;
+		}
+	}
+
+	return result;
+}
+
+/* requires cfg80211_drv_mutex to be held! */
+static struct cfg80211_registered_driver *
+__cfg80211_drv_from_info(struct genl_info *info)
+{
+	int ifindex;
+	struct cfg80211_registered_driver *bywiphy = NULL, *byifidx = NULL;
+	struct net_device *dev;
+	int err = -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_WIPHY]) {
+		bywiphy = cfg80211_drv_by_wiphy(
+				nla_get_u32(info->attrs[NL80211_ATTR_WIPHY]));
+		err = -ENODEV;
+	}
+
+	if (info->attrs[NL80211_ATTR_IFINDEX]) {
+		ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
+		dev = dev_get_by_index(ifindex);
+		if (dev) {
+			byifidx = cfg80211_drv_by_priv(dev->ieee80211_ptr);
+			dev_put(dev);
+		}
+		err = -ENODEV;
+	}
+
+	if (bywiphy && byifidx) {
+		if (bywiphy != byifidx)
+			return ERR_PTR(-EINVAL);
+		else
+			return bywiphy; /* == byifidx */
+	}
+	if (bywiphy)
+		return bywiphy;
+
+	if (byifidx)
+		return byifidx;
+
+	return ERR_PTR(err);
+}
+
+struct cfg80211_registered_driver *
+cfg80211_get_drv_from_info(struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+
+	mutex_lock(&cfg80211_drv_mutex);
+	drv = __cfg80211_drv_from_info(info);
+
+	/* if it is not an error we grab the lock on
+	 * it to assure it won't be going away while
+	 * we operate on it */
+	if (!IS_ERR(drv))
+		mutex_lock(&drv->mtx);
+
+	mutex_unlock(&cfg80211_drv_mutex);
+
+	return drv;
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
+	return nl80211_init();
+}
+
+static void cfg80211_exit(void)
+{
+	/* possibly need to do more later */
+	nl80211_exit();
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
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
new file mode 100644
index 0000000..7a1a888
--- /dev/null
+++ b/net/wireless/nl80211.c
@@ -0,0 +1,1049 @@
+/*
+ * This is the new netlink-based wireless configuration interface.
+ *
+ * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include <linux/if.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <net/genetlink.h>
+#include <net/cfg80211.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/if_ether.h>
+#include "core.h"
+#include "nl80211.h"
+
+/* the netlink family */
+static struct genl_family nl80211_fam = {
+	.id = GENL_ID_GENERATE,	/* don't bother with a hardcoded ID */
+	.name = "nl80211",	/* have users key off the name instead */
+	.hdrsize = 0,		/* no private header */
+	.version = 1,		/* no particular meaning now */
+	.maxattr = NL80211_ATTR_MAX,
+};
+
+/* internal helper: validate an information element attribute */
+static int check_information_element(struct nlattr *nla)
+{
+	int len = nla_len(nla);
+	u8 *data = nla_data(nla);
+	int elementlen;
+
+	while (len >= 2) {
+		/* 1 byte ID, 1 byte len, `len' bytes data */
+		elementlen = *(data+1) + 2;
+		data += elementlen;
+		len -= elementlen;
+	}
+	return len ? -EINVAL : 0;
+}
+
+/* internal helper: get drv and dev */
+static int get_drv_dev_by_info_ifindex(struct genl_info *info,
+				       struct cfg80211_registered_driver **drv,
+				       struct net_device **dev)
+{
+	int ifindex;
+
+	if (!info->attrs[NL80211_ATTR_IFINDEX])
+		return -EINVAL;
+
+	ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
+	*dev = dev_get_by_index(ifindex);
+	if (!dev)
+		return -ENODEV;
+
+	*drv = cfg80211_get_drv_from_ifindex(ifindex);
+	if (IS_ERR(*drv)) {
+		dev_put(*dev);
+		return PTR_ERR(*drv);
+	}
+
+	return 0;
+}
+
+/* policy for the attributes */
+static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
+	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
+	[NL80211_ATTR_FLAGS] = { .type = NLA_U32 },
+	[NL80211_ATTR_QUEUE] = { .type = NLA_U32 },
+	[NL80211_ATTR_FRAME] = { .type = NLA_STRING,
+				 .len = NL80211_MAX_FRAME_LEN },
+	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
+	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_NETWORK_ID] = { .type = NLA_U16 },
+	[NL80211_ATTR_CHANNEL] = { .type = NLA_U32 },
+	[NL80211_ATTR_RX_SENSITIVITY] = { .type = NLA_U32 },
+	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
+	[NL80211_ATTR_SSID] = { .type = NLA_STRING, .len = 32 },
+	[NL80211_ATTR_TRANSMIT_POWER] = { .type = NLA_U32 },
+	[NL80211_ATTR_FRAG_THRESHOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_INFORMATION_ELEMENT] = { .type = NLA_STRING,
+					       .len = NL80211_MAX_IE_LEN },
+	[NL80211_ATTR_ROAMING_CONTROL] = { .type = NLA_U32 },
+	[NL80211_ATTR_SCAN_TYPE] = { .type = NLA_U32 },
+};
+
+/* netlink command implementations */
+
+#define CHECK_CMD(ptr, cmd)				\
+	if (drv->ops->ptr)				\
+		NLA_PUT_FLAG(msg, NL80211_CMD_##cmd);
+
+static int nl80211_get_cmdlist(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+	struct nlattr *start;
+
+	drv = cfg80211_get_drv_from_info(info);
+	if (IS_ERR(drv))
+		return PTR_ERR(drv);
+
+	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_NEW_CMDLIST);
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto put_drv;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->wiphy);
+
+	start = nla_nest_start(msg, NL80211_ATTR_CMDS);
+	if (!start)
+		goto nla_put_failure;
+
+	/* unconditionally allow some common commands we handle centrally
+	 * or where we require the implementation */
+	NLA_PUT_FLAG(msg, NL80211_CMD_GET_CMDLIST);
+	NLA_PUT_FLAG(msg, NL80211_CMD_GET_WIPHYS);
+	NLA_PUT_FLAG(msg, NL80211_CMD_GET_INTERFACES);
+
+	CHECK_CMD(inject_packet, INJECT);
+	CHECK_CMD(add_virtual_intf, ADD_VIRTUAL_INTERFACE);
+	CHECK_CMD(del_virtual_intf, DEL_VIRTUAL_INTERFACE);
+	CHECK_CMD(configure, CONFIGURE);
+	CHECK_CMD(get_config, GET_CONFIG);
+	CHECK_CMD(reassociate, REASSOCIATE);
+	CHECK_CMD(disassociate, DISASSOCIATE);
+	CHECK_CMD(deauth, DEAUTH);
+	CHECK_CMD(initiate_scan, INITIATE_SCAN);
+	CHECK_CMD(set_roaming, SET_ROAMING_CONTROL);
+	CHECK_CMD(get_roaming, GET_ROAMING_CONTROL);
+	CHECK_CMD(set_fixed_bssid, SET_FIXED_BSSID);
+	CHECK_CMD(get_fixed_bssid, GET_FIXED_BSSID);
+	CHECK_CMD(get_association, GET_ASSOCIATION);
+	CHECK_CMD(get_auth_list, GET_AUTH_LIST);
+
+	nla_nest_end(msg, start);
+
+	genlmsg_end(msg, hdr);
+
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto put_drv;
+
+ nla_put_failure:
+ 	err = -ENOBUFS;
+	nlmsg_free(msg);
+ put_drv:
+	cfg80211_put_drv(drv);
+	return err;
+}
+#undef CHECK_CMD
+
+static int nl80211_get_wiphys(struct sk_buff *skb, struct genl_info *info)
+{
+	struct sk_buff *msg;
+	void *hdr;
+	struct nlattr *start, *indexstart;
+	struct cfg80211_registered_driver *drv;
+	int idx = 1;
+
+	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_NEW_WIPHYS);
+	if (IS_ERR(hdr))
+		return PTR_ERR(hdr);
+
+	start = nla_nest_start(msg, NL80211_ATTR_WIPHY_LIST);
+	if (!start)
+		goto nla_outer_nest_failure;
+
+	mutex_lock(&cfg80211_drv_mutex);
+	list_for_each_entry(drv, &cfg80211_drv_list, list) {
+		indexstart = nla_nest_start(msg, idx++);
+		if (!indexstart)
+			goto nla_put_failure;
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->wiphy);
+		nla_nest_end(msg, indexstart);
+	}
+	mutex_unlock(&cfg80211_drv_mutex);
+
+	nla_nest_end(msg, start);
+
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_unicast(msg, info->snd_pid);
+
+ nla_put_failure:
+	mutex_unlock(&cfg80211_drv_mutex);
+ nla_outer_nest_failure:
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+
+struct add_cb_data {
+	int idx;
+	struct sk_buff *skb;
+};
+
+static int addifidx(void *data, int ifidx)
+{
+	struct add_cb_data *cb = data;
+	struct net_device *dev = dev_get_by_index(ifidx);
+	int err = -ENOBUFS;
+	struct nlattr *start;
+
+	/* not that this can happen, since the caller
+	 * should hold the device open... */
+	if (!dev)
+		return -ENODEV;
+
+	start = nla_nest_start(cb->skb, cb->idx++);
+	if (!start)
+		goto nla_put_failure;
+
+	NLA_PUT_U32(cb->skb, NL80211_ATTR_IFINDEX, ifidx);
+	NLA_PUT_STRING(cb->skb, NL80211_ATTR_IFNAME, dev->name);
+
+	nla_nest_end(cb->skb, start);
+	err = 0;
+
+ nla_put_failure:
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_get_intfs(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+	struct nlattr *start;
+	struct add_cb_data cb;
+
+	drv = cfg80211_get_drv_from_info(info);
+	if (IS_ERR(drv))
+		return PTR_ERR(drv);
+
+	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_NEW_INTERFACES);
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto put_drv;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, drv->wiphy);
+
+	start = nla_nest_start(msg, NL80211_ATTR_INTERFACE_LIST);
+	if (!start) {
+		err = -ENOBUFS;
+		goto msg_free;
+	}
+
+	cb.skb = msg;
+	cb.idx = 1;
+	err = drv->ops->list_interfaces(drv->priv, &cb, addifidx);
+	if (err)
+		goto msg_free;
+
+	nla_nest_end(msg, start);
+
+	genlmsg_end(msg, hdr);
+
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto put_drv;
+
+ nla_put_failure:
+	err = -ENOBUFS;
+ msg_free:
+	nlmsg_free(msg);
+ put_drv:
+	cfg80211_put_drv(drv);
+	return err;
+}
+
+static int nl80211_do_inject(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	u32 flags = 0;
+	int err, queue = -1;
+
+	if (!info->attrs[NL80211_ATTR_FRAME])
+		return -EINVAL;
+	if (info->attrs[NL80211_ATTR_FLAGS])
+		flags = nla_get_u32(info->attrs[NL80211_ATTR_FLAGS]);
+	if (info->attrs[NL80211_ATTR_QUEUE])
+		queue = (int) nla_get_u32(info->attrs[NL80211_ATTR_QUEUE]);
+
+	drv = cfg80211_get_drv_from_info(info);
+	if (IS_ERR(drv))
+		return PTR_ERR(drv);
+
+	if (!drv->ops->inject_packet) {
+		err = -ENOSYS;
+		goto unlock;
+	}
+
+	err = drv->ops->inject_packet(drv->priv,
+		nla_data(info->attrs[NL80211_ATTR_FRAME]),
+		nla_len(info->attrs[NL80211_ATTR_FRAME]),
+		flags,
+		queue);
+ unlock:
+	cfg80211_put_drv(drv);
+	return err;
+}
+
+static int nl80211_add_virt_intf(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+	unsigned int type = NL80211_IFTYPE_UNSPECIFIED;
+
+	if (!info->attrs[NL80211_ATTR_IFNAME])
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_IFTYPE]) {
+		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
+		if (type > NL80211_IFTYPE_MAX)
+			return -EINVAL;
+	}
+
+	drv = cfg80211_get_drv_from_info(info);
+	if (IS_ERR(drv))
+		return PTR_ERR(drv);
+
+	if (!drv->ops->add_virtual_intf) {
+		err = -ENOSYS;
+		goto unlock;
+	}
+
+	err = drv->ops->add_virtual_intf(drv->priv,
+		nla_data(info->attrs[NL80211_ATTR_IFNAME]), type);
+
+ unlock:
+	cfg80211_put_drv(drv);
+	return err;
+}
+
+static int nl80211_del_virt_intf(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	int ifindex, err;
+	struct net_device *dev;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+	ifindex = dev->ifindex;
+	dev_put(dev);
+
+	if (!drv->ops->del_virtual_intf) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	err = drv->ops->del_virtual_intf(drv->priv, ifindex);
+
+ out:
+	cfg80211_put_drv(drv);
+	return err;
+}
+
+static int nl80211_configure(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+	struct net_device *dev;
+	struct cfg80211_config config;
+	struct nlattr *attr;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->configure) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	memset(&config, 0, sizeof(config));
+
+	attr = info->attrs[NL80211_ATTR_SSID];
+	if (attr) {
+		config.ssid = nla_data(attr);
+		config.ssid_len = nla_len(attr);
+	}
+
+	attr = info->attrs[NL80211_ATTR_NETWORK_ID];
+	if (attr) {
+		config.valid |= CFG80211_CFG_VALID_NWID;
+		config.network_id = nla_get_u16(attr);
+	}
+
+	attr = info->attrs[NL80211_ATTR_RX_SENSITIVITY];
+	if (attr) {
+		config.valid |= CFG80211_CFG_VALID_RX_SENSITIVITY;
+		config.rx_sensitivity = (s32) nla_get_u32(attr);
+	}
+
+	attr = info->attrs[NL80211_ATTR_TRANSMIT_POWER];
+	if (attr) {
+		config.valid |= CFG80211_CFG_VALID_TRANSMIT_POWER;
+		config.transmit_power = nla_get_u32(attr);
+	}
+
+	attr = info->attrs[NL80211_ATTR_FRAG_THRESHOLD];
+	if (attr) {
+		config.valid |= CFG80211_CFG_VALID_FRAG_THRESHOLD;
+		config.fragmentation_threshold = nla_get_u32(attr);
+	}
+
+	attr = info->attrs[NL80211_ATTR_CHANNEL];
+	if (attr) {
+		config.valid |= CFG80211_CFG_VALID_CHANNEL;
+		config.channel = nla_get_u32(attr);
+	}
+
+	err = drv->ops->configure(drv->priv, dev, &config);
+ out:
+	cfg80211_put_drv(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_get_config(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+	struct net_device *dev;
+	struct cfg80211_config config;
+	struct sk_buff *msg;
+	void *hdr;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->get_config) {
+		err = -EOPNOTSUPP;
+		goto out_put_drv;
+	}
+
+	memset(&config, 0, sizeof(config));
+
+	drv->ops->get_config(drv->priv, dev, &config);
+
+	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_NEW_CONFIG);
+
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto out_put_drv;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+
+	if (config.ssid)
+		NLA_PUT_STRING(msg, NL80211_ATTR_SSID, config.ssid);
+
+	if (config.valid & CFG80211_CFG_VALID_NWID)
+		NLA_PUT_U16(msg, NL80211_ATTR_NETWORK_ID, config.network_id);
+
+	if (config.valid & CFG80211_CFG_VALID_RX_SENSITIVITY)
+		NLA_PUT_U32(msg, NL80211_ATTR_RX_SENSITIVITY, (u32)config.rx_sensitivity);
+
+	if (config.valid & CFG80211_CFG_VALID_TRANSMIT_POWER)
+		NLA_PUT_U32(msg, NL80211_ATTR_TRANSMIT_POWER, config.transmit_power);
+
+	if (config.valid & CFG80211_CFG_VALID_FRAG_THRESHOLD)
+		NLA_PUT_U32(msg, NL80211_ATTR_FRAG_THRESHOLD, config.fragmentation_threshold);
+
+	if (config.valid & CFG80211_CFG_VALID_CHANNEL)
+		NLA_PUT_U32(msg, NL80211_ATTR_CHANNEL, config.channel);
+
+	genlmsg_end(msg, hdr);
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto out_put_drv;
+
+ nla_put_failure:
+	err = -ENOBUFS;
+	nlmsg_free(msg);
+ out_put_drv:
+	cfg80211_put_drv(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_set_roaming(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+	struct net_device *dev;
+	int roaming_control;
+
+	if (!info->attrs[NL80211_ATTR_ROAMING_CONTROL])
+		return -EINVAL;
+	roaming_control = nla_get_u32(info->attrs[NL80211_ATTR_ROAMING_CONTROL]);
+
+	if (roaming_control > NL80211_ROAMING_CONTROL_MAX)
+		return -EINVAL;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->set_roaming) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	err = drv->ops->set_roaming(drv->priv, dev, roaming_control);
+ out:
+	cfg80211_put_drv(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_get_roaming(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+	struct net_device *dev;
+	struct sk_buff *msg;
+	void *hdr;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->get_roaming) {
+		err = -EOPNOTSUPP;
+		goto out_put_drv;
+	}
+
+	err = drv->ops->get_roaming(drv->priv, dev);
+	if (err < 0)
+		goto out_put_drv;
+
+	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_ROAMING_CONTROL);
+
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto out_put_drv;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_ROAMING_CONTROL, err);
+
+	genlmsg_end(msg, hdr);
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto out_put_drv;
+
+ nla_put_failure:
+	err = -ENOBUFS;
+	nlmsg_free(msg);
+ out_put_drv:
+	cfg80211_put_drv(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_set_fixed_bssid(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+	struct net_device *dev;
+	u8 *bssid;
+
+	if (!info->attrs[NL80211_ATTR_BSSID])
+		return -EINVAL;
+	bssid = nla_data(info->attrs[NL80211_ATTR_BSSID]);
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->set_fixed_bssid) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	err = drv->ops->set_fixed_bssid(drv->priv, dev, bssid);
+ out:
+	cfg80211_put_drv(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_get_fixed_bssid(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+	struct net_device *dev;
+	struct sk_buff *msg;
+	void *hdr;
+	u8 bssid[ETH_ALEN];
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->get_fixed_bssid) {
+		err = -EOPNOTSUPP;
+		goto out_put_drv;
+	}
+
+	err = drv->ops->get_fixed_bssid(drv->priv, dev, bssid);
+	if (err < 0)
+		goto out_put_drv;
+
+	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_FIXED_BSSID);
+
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto out_put_drv;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_BSSID, ETH_ALEN, bssid);
+
+	genlmsg_end(msg, hdr);
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto out_put_drv;
+
+ nla_put_failure:
+	err = -ENOBUFS;
+	nlmsg_free(msg);
+ out_put_drv:
+	cfg80211_put_drv(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_get_association(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+	struct net_device *dev;
+	struct sk_buff *msg;
+	void *hdr;
+	u8 bssid[ETH_ALEN];
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->get_association) {
+		err = -EOPNOTSUPP;
+		goto out_put_drv;
+	}
+
+	err = drv->ops->get_association(drv->priv, dev, bssid);
+	if (err < 0)
+		goto out_put_drv;
+
+	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_ASSOCIATION_CHANGED);
+
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto out_put_drv;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	if (err == 1)
+		NLA_PUT(msg, NL80211_ATTR_BSSID, ETH_ALEN, bssid);
+
+	genlmsg_end(msg, hdr);
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto out_put_drv;
+
+ nla_put_failure:
+	err = -ENOBUFS;
+	nlmsg_free(msg);
+ out_put_drv:
+	cfg80211_put_drv(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_assoc_deauth(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+	struct net_device *dev;
+	int (*act)(void *priv, struct net_device *dev);
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	switch (info->genlhdr->cmd) {
+	case NL80211_CMD_DISASSOCIATE:
+		act = drv->ops->disassociate;
+		break;
+	case NL80211_CMD_REASSOCIATE:
+		act = drv->ops->reassociate;
+		break;
+	case NL80211_CMD_DEAUTH:
+		act = drv->ops->deauth;
+		break;
+	default:
+		act = NULL;
+	}
+
+	if (!act) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	err = act(drv->priv, dev);
+ out:
+	cfg80211_put_drv(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int add_bssid(void *data, u8 *bssid)
+{
+	struct add_cb_data *cb = data;
+	int err = -ENOBUFS;
+	struct nlattr *start;
+
+	start = nla_nest_start(cb->skb, cb->idx++);
+	if (!start)
+		goto nla_put_failure;
+
+	NLA_PUT(cb->skb, NL80211_ATTR_BSSID, ETH_ALEN, bssid);
+
+	nla_nest_end(cb->skb, start);
+	err = 0;
+
+ nla_put_failure:
+	return err;
+}
+
+static int nl80211_get_auth_list(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	struct net_device *dev;
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+	struct nlattr *start;
+	struct add_cb_data cb;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->get_auth_list) {
+		err = -EOPNOTSUPP;
+		goto put_drv;
+	}
+
+	hdr = nl80211msg_new(&msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_AUTH_LIST);
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto put_drv;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+
+	start = nla_nest_start(msg, NL80211_ATTR_BSSID_LIST);
+	if (!start) {
+		err = -ENOBUFS;
+		goto msg_free;
+	}
+
+	cb.skb = msg;
+	cb.idx = 1;
+	err = drv->ops->get_auth_list(drv->priv, dev, &cb, add_bssid);
+	if (err)
+		goto msg_free;
+
+	nla_nest_end(msg, start);
+
+	genlmsg_end(msg, hdr);
+
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto put_drv;
+
+ nla_put_failure:
+	err = -ENOBUFS;
+ msg_free:
+	nlmsg_free(msg);
+ put_drv:
+	cfg80211_put_drv(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_initiate_scan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+	struct net_device *dev;
+	struct scan_params params;
+	struct scan_channel *channels = NULL;
+	int count = -1;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->initiate_scan) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	params.active = 0;
+
+	if (info->attrs[NL80211_ATTR_FLAGS])
+		params.active = !!(nla_get_u32(info->attrs[NL80211_ATTR_FLAGS])
+					& NL80211_FLAG_SCAN_TYPE_ACTIVE);
+
+	if (info->attrs[NL80211_ATTR_CHANNEL_LIST]) {
+		struct nlattr *attr = info->attrs[NL80211_ATTR_CHANNEL_LIST];
+		struct nlattr *nla;
+		int rem;
+		struct nlattr **tb;
+
+		/* let's count first */
+		count = 0;
+		nla_for_each_attr(nla, nla_data(attr), nla_len(attr), rem)
+			count++;
+
+		if (count == 0) {
+			/* assume we should actually scan all channels,
+			 * scanning no channels make no sense */
+			count = -1;
+			goto done_channels;
+		}
+
+		channels = kmalloc(count * sizeof(struct scan_channel),
+				   GFP_KERNEL);
+		tb = kmalloc((NL80211_ATTR_MAX+1) * sizeof(struct nlattr),
+			     GFP_KERNEL);
+
+		count = 0;
+		nla_for_each_attr(nla, nla_data(attr), nla_len(attr), rem) {
+			err = nla_parse(tb, NL80211_ATTR_MAX, nla_data(nla),
+					nla_len(nla), nl80211_policy);
+			if (err || !tb[NL80211_ATTR_CHANNEL]) {
+				err = -EINVAL;
+				kfree(tb);
+				kfree(channels);
+				goto out;
+			}
+			channels[count].channel =
+				nla_get_u32(tb[NL80211_ATTR_CHANNEL]);
+
+			channels[count].active = params.active;
+
+			if (tb[NL80211_ATTR_FLAGS])
+				channels[count].active =
+					!!(nla_get_u32(tb[NL80211_ATTR_FLAGS])
+					     & NL80211_FLAG_SCAN_TYPE_ACTIVE);
+			count++;
+		}
+		kfree(tb);
+	}
+
+ done_channels:
+	params.channels = channels;
+	params.n_channels = count;
+
+	err = drv->ops->initiate_scan(drv->priv, dev, &params);
+
+	kfree(channels);
+ out:
+	cfg80211_put_drv(drv);
+	dev_put(dev);
+	return err;
+}
+
+static struct genl_ops nl80211_ops[] = {
+	{
+		.cmd = NL80211_CMD_GET_CMDLIST,
+		.doit = nl80211_get_cmdlist,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = NL80211_CMD_GET_WIPHYS,
+		.doit = nl80211_get_wiphys,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = NL80211_CMD_GET_INTERFACES,
+		.doit = nl80211_get_intfs,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = NL80211_CMD_INJECT,
+		.doit = nl80211_do_inject,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_ADD_VIRTUAL_INTERFACE,
+		.doit = nl80211_add_virt_intf,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_DEL_VIRTUAL_INTERFACE,
+		.doit = nl80211_del_virt_intf,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_CONFIGURE,
+		.doit = nl80211_configure,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_GET_CONFIG,
+		.doit = nl80211_get_config,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = NL80211_CMD_SET_ROAMING_CONTROL,
+		.doit = nl80211_set_roaming,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_GET_ROAMING_CONTROL,
+		.doit = nl80211_get_roaming,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = NL80211_CMD_SET_FIXED_BSSID,
+		.doit = nl80211_set_fixed_bssid,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_GET_FIXED_BSSID,
+		.doit = nl80211_get_fixed_bssid,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = NL80211_CMD_GET_ASSOCIATION,
+		.doit = nl80211_get_association,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = NL80211_CMD_DISASSOCIATE,
+		.doit = nl80211_assoc_deauth,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_DEAUTH,
+		.doit = nl80211_assoc_deauth,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_REASSOCIATE,
+		.doit = nl80211_assoc_deauth,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_GET_AUTH_LIST,
+		.doit = nl80211_get_auth_list,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = NL80211_CMD_INITIATE_SCAN,
+		.doit = nl80211_initiate_scan,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+};
+
+
+/* exported functions */
+
+void *nl80211hdr_put(struct sk_buff *skb, u32 pid, u32 seq, int flags, u8 cmd)
+{
+	/* since there is no private header just add the generic one */
+	return genlmsg_put(skb, pid, seq, &nl80211_fam, flags, cmd);
+}
+EXPORT_SYMBOL_GPL(nl80211hdr_put);
+
+void *nl80211msg_new(struct sk_buff **skb, u32 pid, u32 seq, int flags, u8 cmd)
+{
+	void *hdr;
+
+	*skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!*skb)
+		return ERR_PTR(-ENOBUFS);
+
+	hdr = nl80211hdr_put(*skb, pid, seq, flags, cmd);
+	if (!hdr) {
+		nlmsg_free(*skb);
+		return ERR_PTR(-ENOBUFS);
+	}
+
+	return hdr;
+}
+EXPORT_SYMBOL_GPL(nl80211msg_new);
+
+/* initialisation/exit functions */
+
+int nl80211_init(void)
+{
+	int err, i;
+
+	err = genl_register_family(&nl80211_fam);
+	if (err)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(nl80211_ops); i++) {
+		err = genl_register_ops(&nl80211_fam, &nl80211_ops[i]);
+		if (err)
+			goto err_out;
+	}
+	return 0;
+ err_out:
+ 	genl_unregister_family(&nl80211_fam);
+	return err;
+}
+
+void nl80211_exit(void)
+{
+	genl_unregister_family(&nl80211_fam);
+}
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
new file mode 100644
index 0000000..0edc7a4
--- /dev/null
+++ b/net/wireless/nl80211.h
@@ -0,0 +1,7 @@
+#ifndef __NET_WIRELESS_NL80211_H
+#define __NET_WIRELESS_NL80211_H
+
+extern int nl80211_init(void);
+extern void nl80211_exit(void);
+
+#endif /* __NET_WIRELESS_NL80211_H */
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
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
