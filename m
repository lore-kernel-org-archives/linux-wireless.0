Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab0HLNjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Aug 2010 09:39:16 -0400
Subject: [PATCH] cfg80211/mac80211: extensible frame processing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 15:38:38 +0200
Message-ID: <1281620318.3803.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Allow userspace to register for more than just
action frames by giving the frame subtype, and
make it possible to use this in various modes
as well.

With some tweaks and some added functionality
this will, in the future, also be usable in AP
mode and be able to replace the cooked monitor
interface currently used in that case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h    |   93 +++++++++++++++++++++++------
 include/net/cfg80211.h     |   56 ++++++++++-------
 net/mac80211/cfg.c         |   12 +--
 net/mac80211/ieee80211_i.h |    1 
 net/mac80211/iface.c       |    6 -
 net/mac80211/main.c        |   37 +++++++++++
 net/mac80211/rx.c          |  137 ++++++++++++++++++++++++++++++------------
 net/mac80211/status.c      |    2 
 net/mac80211/util.c        |    6 -
 net/wireless/core.c        |    8 +-
 net/wireless/core.h        |   21 +++---
 net/wireless/mlme.c        |  144 +++++++++++++++++++++++++++++----------------
 net/wireless/nl80211.c     |  108 +++++++++++++++++++++++++--------
 net/wireless/nl80211.h     |   14 ++--
 net/wireless/util.c        |    2 
 15 files changed, 452 insertions(+), 195 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2010-08-12 13:56:32.000000000 +0200
@@ -40,6 +40,43 @@
  */
 
 /**
+ * DOC: Frame transmission/registration support
+ *
+ * Frame transmission and registration support exists to allow userspace
+ * management entities such as wpa_supplicant react to management frames
+ * that are not being handled by the kernel. This includes, for example,
+ * certain classes of action frames that cannot be handled in the kernel
+ * for various reasons.
+ *
+ * Frame registration is done on a per-interface basis and registrations
+ * cannot be removed other than by closing the socket. It is possible to
+ * specify a registration filter to register, for example, only for a
+ * certain type of action frame. In particular with action frames, those
+ * that userspace registers for will not be returned as unhandled by the
+ * driver, so that the registered application has to take responsibility
+ * for doing that.
+ *
+ * The type of frame that can be registered for is also dependent on the
+ * driver and interface type. The frame types are advertised in wiphy
+ * attributes so applications know what to expect.
+ *
+ * NOTE: When an interface changes type while registrations are active,
+ *       these registrations are ignored until the interface type is
+ *       changed again. This means that changing the interface type can
+ *       lead to a situation that couldn't otherwise be produced, but
+ *       any such registrations will be dormant in the sense that they
+ *       will not be serviced, i.e. they will not receive any frames.
+ *
+ * Frame transmission allows userspace to send for example the required
+ * responses to action frames. It is subject to some sanity checking,
+ * but many frames can be transmitted. When a frame was transmitted, its
+ * status is indicated to the sending socket.
+ *
+ * For more technical details, see the corresponding command descriptions
+ * below.
+ */
+
+/**
  * enum nl80211_commands - supported nl80211 commands
  *
  * @NL80211_CMD_UNSPEC: unspecified command to catch errors
@@ -301,16 +338,18 @@
  *	rate selection. %NL80211_ATTR_IFINDEX is used to specify the interface
  *	and @NL80211_ATTR_TX_RATES the set of allowed rates.
  *
- * @NL80211_CMD_REGISTER_ACTION: Register for receiving certain action frames
- *	(via @NL80211_CMD_ACTION) for processing in userspace. This command
- *	requires an interface index and a match attribute containing the first
- *	few bytes of the frame that should match, e.g. a single byte for only
- *	a category match or four bytes for vendor frames including the OUI.
- *	The registration cannot be dropped, but is removed automatically
- *	when the netlink socket is closed. Multiple registrations can be made.
- * @NL80211_CMD_ACTION: Action frame TX request and RX notification. This
- *	command is used both as a request to transmit an Action frame and as an
- *	event indicating reception of an Action frame that was not processed in
+ * @NL80211_CMD_REGISTER_FRAME: Register for receiving certain mgmt frames
+ *	(via @NL80211_CMD_FRAME) for processing in userspace. This command
+ *	requires an interface index, a frame type attribute (optional for
+ *	backward compatibility reasons, if not given assumes action frames)
+ *	and a match attribute containing the first few bytes of the frame
+ *	that should match, e.g. a single byte for only a category match or
+ *	four bytes for vendor frames including the OUI. The registration
+ *	cannot be dropped, but is removed automatically when the netlink
+ *	socket is closed. Multiple registrations can be made.
+ * @NL80211_CMD_FRAME: Management frame TX request and RX notification. This
+ *	command is used both as a request to transmit a management frame and
+ *	as an event indicating reception of a frame that was not processed in
  *	kernel code, but is for us (i.e., which may need to be processed in a
  *	user space application). %NL80211_ATTR_FRAME is used to specify the
  *	frame contents (including header). %NL80211_ATTR_WIPHY_FREQ (and
@@ -320,8 +359,8 @@
  *	operational channel). When called, this operation returns a cookie
  *	(%NL80211_ATTR_COOKIE) that will be included with the TX status event
  *	pertaining to the TX request.
- * @NL80211_CMD_ACTION_TX_STATUS: Report TX status of an Action frame
- *	transmitted with %NL80211_CMD_ACTION. %NL80211_ATTR_COOKIE identifies
+ * @NL80211_CMD_FRAME_TX_STATUS: Report TX status of a management frame
+ *	transmitted with %NL80211_CMD_FRAME. %NL80211_ATTR_COOKIE identifies
  *	the TX command and %NL80211_ATTR_FRAME includes the contents of the
  *	frame. %NL80211_ATTR_ACK flag is included if the recipient acknowledged
  *	the frame.
@@ -429,9 +468,12 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_TX_BITRATE_MASK,
 
-	NL80211_CMD_REGISTER_ACTION,
-	NL80211_CMD_ACTION,
-	NL80211_CMD_ACTION_TX_STATUS,
+	NL80211_CMD_REGISTER_FRAME,
+	NL80211_CMD_REGISTER_ACTION = NL80211_CMD_REGISTER_FRAME,
+	NL80211_CMD_FRAME,
+	NL80211_CMD_ACTION = NL80211_CMD_FRAME,
+	NL80211_CMD_FRAME_TX_STATUS,
+	NL80211_CMD_ACTION_TX_STATUS = NL80211_CMD_FRAME_TX_STATUS,
 
 	NL80211_CMD_SET_POWER_SAVE,
 	NL80211_CMD_GET_POWER_SAVE,
@@ -708,7 +750,16 @@ enum nl80211_commands {
  *	is used with %NL80211_CMD_SET_TX_BITRATE_MASK.
  *
  * @NL80211_ATTR_FRAME_MATCH: A binary attribute which typically must contain
- *	at least one byte, currently used with @NL80211_CMD_REGISTER_ACTION.
+ *	at least one byte, currently used with @NL80211_CMD_REGISTER_FRAME.
+ * @NL80211_ATTR_FRAME_TYPE: A u16 indicating the frame type/subtype for the
+ *	@NL80211_CMD_REGISTER_FRAME command.
+ * @NL80211_ATTR_TX_FRAME_TYPES: wiphy capability attribute, which is a
+ *	nested attribute of %NL80211_ATTR_FRAME_TYPE attributes, containing
+ *	information about which frame types can be transmitted with
+ *	%NL80211_CMD_FRAME.
+ * @NL80211_ATTR_RX_FRAME_TYPES: wiphy capability attribute, which is a
+ *	nested attribute of %NL80211_ATTR_FRAME_TYPE attributes, containing
+ *	information about which frame types can be registered for RX.
  *
  * @NL80211_ATTR_ACK: Flag attribute indicating that the frame was
  *	acknowledged by the recipient.
@@ -891,6 +942,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_TX_POWER_SETTING,
 	NL80211_ATTR_WIPHY_TX_POWER_LEVEL,
 
+	NL80211_ATTR_TX_FRAME_TYPES,
+	NL80211_ATTR_RX_FRAME_TYPES,
+	NL80211_ATTR_FRAME_TYPE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -947,7 +1002,7 @@ enum nl80211_attrs {
  * @NL80211_IFTYPE_MONITOR: monitor interface receiving all frames
  * @NL80211_IFTYPE_MESH_POINT: mesh point
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
- * @__NL80211_IFTYPE_AFTER_LAST: internal use
+ * @NUM_NL80211_IFTYPES: number of defined interface types
  *
  * These values are used with the %NL80211_ATTR_IFTYPE
  * to set the type of an interface.
@@ -964,8 +1019,8 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_MESH_POINT,
 
 	/* keep last */
-	__NL80211_IFTYPE_AFTER_LAST,
-	NL80211_IFTYPE_MAX = __NL80211_IFTYPE_AFTER_LAST - 1
+	NUM_NL80211_IFTYPES,
+	NL80211_IFTYPE_MAX = NUM_NL80211_IFTYPES - 1
 };
 
 /**
--- wireless-testing.orig/include/net/cfg80211.h	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-08-12 14:17:29.000000000 +0200
@@ -1020,7 +1020,7 @@ struct cfg80211_pmksa {
  * @cancel_remain_on_channel: Cancel an on-going remain-on-channel operation.
  *	This allows the operation to be terminated prior to timeout based on
  *	the duration value.
- * @action: Transmit an action frame
+ * @mgmt_tx: Transmit a management frame
  *
  * @testmode_cmd: run a test mode command
  *
@@ -1172,7 +1172,7 @@ struct cfg80211_ops {
 					    struct net_device *dev,
 					    u64 cookie);
 
-	int	(*action)(struct wiphy *wiphy, struct net_device *dev,
+	int	(*mgmt_tx)(struct wiphy *wiphy, struct net_device *dev,
 			  struct ieee80211_channel *chan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid,
@@ -1236,6 +1236,10 @@ struct mac_address {
 	u8 addr[ETH_ALEN];
 };
 
+struct ieee80211_txrx_stypes {
+	u16 tx, rx;
+};
+
 /**
  * struct wiphy - wireless hardware description
  * @reg_notifier: the driver's regulatory notification callback
@@ -1286,6 +1290,10 @@ struct mac_address {
  * @privid: a pointer that drivers can use to identify if an arbitrary
  *	wiphy is theirs, e.g. in global notifiers
  * @bands: information about bands/channels supported by this device
+ *
+ * @mgmt_stypes: bitmasks of frame subtypes that can be subscribed to or
+ *	transmitted through nl80211, points to an array indexed by interface
+ *	type
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -1294,9 +1302,12 @@ struct wiphy {
 	u8 perm_addr[ETH_ALEN];
 	u8 addr_mask[ETH_ALEN];
 
-	u16 n_addresses;
 	struct mac_address *addresses;
 
+	const struct ieee80211_txrx_stypes *mgmt_stypes;
+
+	u16 n_addresses;
+
 	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
 	u16 interface_modes;
 
@@ -1492,8 +1503,8 @@ struct cfg80211_cached_keys;
  *	set by driver (if supported) on add_interface BEFORE registering the
  *	netdev and may otherwise be used by driver read-only, will be update
  *	by cfg80211 on change_interface
- * @action_registrations: list of registrations for action frames
- * @action_registrations_lock: lock for the list
+ * @mgmt_registrations: list of registrations for management frames
+ * @mgmt_registrations_lock: lock for the list
  * @mtx: mutex used to lock data in this struct
  * @cleanup_work: work struct used for cleanup that can't be done directly
  */
@@ -1505,8 +1516,8 @@ struct wireless_dev {
 	struct list_head list;
 	struct net_device *netdev;
 
-	struct list_head action_registrations;
-	spinlock_t action_registrations_lock;
+	struct list_head mgmt_registrations;
+	spinlock_t mgmt_registrations_lock;
 
 	struct mutex mtx;
 
@@ -2373,38 +2384,39 @@ void cfg80211_new_sta(struct net_device
 		      struct station_info *sinfo, gfp_t gfp);
 
 /**
- * cfg80211_rx_action - notification of received, unprocessed Action frame
+ * cfg80211_rx_mgmt - notification of received, unprocessed management frame
  * @dev: network device
  * @freq: Frequency on which the frame was received in MHz
- * @buf: Action frame (header + body)
+ * @buf: Management frame (header + body)
  * @len: length of the frame data
  * @gfp: context flags
- * Returns %true if a user space application is responsible for rejecting the
- *	unrecognized Action frame; %false if no such application is registered
- *	(i.e., the driver is responsible for rejecting the unrecognized Action
- *	frame)
+ *
+ * Returns %true if a user space application has registered for this frame.
+ * For action frames, that makes it responsible for rejecting unrecognized
+ * action frames; %false otherwise, in which case for action frames the
+ * driver is responsible for rejecting the frame.
  *
  * This function is called whenever an Action frame is received for a station
  * mode interface, but is not processed in kernel.
  */
-bool cfg80211_rx_action(struct net_device *dev, int freq, const u8 *buf,
-			size_t len, gfp_t gfp);
+bool cfg80211_rx_mgmt(struct net_device *dev, int freq, const u8 *buf,
+		      size_t len, gfp_t gfp);
 
 /**
- * cfg80211_action_tx_status - notification of TX status for Action frame
+ * cfg80211_mgmt_tx_status - notification of TX status for management frame
  * @dev: network device
- * @cookie: Cookie returned by cfg80211_ops::action()
- * @buf: Action frame (header + body)
+ * @cookie: Cookie returned by cfg80211_ops::mgmt_tx()
+ * @buf: Management frame (header + body)
  * @len: length of the frame data
  * @ack: Whether frame was acknowledged
  * @gfp: context flags
  *
- * This function is called whenever an Action frame was requested to be
- * transmitted with cfg80211_ops::action() to report the TX status of the
+ * This function is called whenever a management frame was requested to be
+ * transmitted with cfg80211_ops::mgmt_tx() to report the TX status of the
  * transmission attempt.
  */
-void cfg80211_action_tx_status(struct net_device *dev, u64 cookie,
-			       const u8 *buf, size_t len, bool ack, gfp_t gfp);
+void cfg80211_mgmt_tx_status(struct net_device *dev, u64 cookie,
+			     const u8 *buf, size_t len, bool ack, gfp_t gfp);
 
 
 /**
--- wireless-testing.orig/net/wireless/nl80211.c	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-08-12 13:56:32.000000000 +0200
@@ -156,6 +156,7 @@ static const struct nla_policy nl80211_p
 
 	[NL80211_ATTR_WIPHY_TX_POWER_SETTING] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_TX_POWER_LEVEL] = { .type = NLA_U32 },
+	[NL80211_ATTR_FRAME_TYPE] = { .type = NLA_U16 },
 };
 
 /* policy for the attributes */
@@ -437,6 +438,8 @@ static int nl80211_send_wiphy(struct sk_
 	struct ieee80211_rate *rate;
 	int i;
 	u16 ifmodes = dev->wiphy.interface_modes;
+	const struct ieee80211_txrx_stypes *mgmt_stypes =
+				dev->wiphy.mgmt_stypes;
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_WIPHY);
 	if (!hdr)
@@ -587,7 +590,7 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(flush_pmksa, FLUSH_PMKSA);
 	CMD(remain_on_channel, REMAIN_ON_CHANNEL);
 	CMD(set_bitrate_mask, SET_TX_BITRATE_MASK);
-	CMD(action, ACTION);
+	CMD(mgmt_tx, FRAME);
 	if (dev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
 		i++;
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
@@ -608,6 +611,53 @@ static int nl80211_send_wiphy(struct sk_
 
 	nla_nest_end(msg, nl_cmds);
 
+	if (mgmt_stypes) {
+		u16 stypes;
+		struct nlattr *nl_ftypes, *nl_ifs;
+		enum nl80211_iftype ift;
+
+		nl_ifs = nla_nest_start(msg, NL80211_ATTR_TX_FRAME_TYPES);
+		if (!nl_ifs)
+			goto nla_put_failure;
+
+		for (ift = 0; ift < NUM_NL80211_IFTYPES; ift++) {
+			nl_ftypes = nla_nest_start(msg, ift);
+			if (!nl_ftypes)
+				goto nla_put_failure;
+			i = 0;
+			stypes = mgmt_stypes[ift].tx;
+			while (stypes) {
+				if (stypes & 1)
+					NLA_PUT_U16(msg, NL80211_ATTR_FRAME_TYPE,
+						    (i << 4) | IEEE80211_FTYPE_MGMT);
+				stypes >>= 1;
+				i++;
+			}
+			nla_nest_end(msg, nl_ftypes);
+		}
+
+		nl_ifs = nla_nest_start(msg, NL80211_ATTR_RX_FRAME_TYPES);
+		if (!nl_ifs)
+			goto nla_put_failure;
+
+		for (ift = 0; ift < NUM_NL80211_IFTYPES; ift++) {
+			nl_ftypes = nla_nest_start(msg, ift);
+			if (!nl_ftypes)
+				goto nla_put_failure;
+			i = 0;
+			stypes = mgmt_stypes[ift].rx;
+			while (stypes) {
+				if (stypes & 1)
+					NLA_PUT_U16(msg, NL80211_ATTR_FRAME_TYPE,
+						    (i << 4) | IEEE80211_FTYPE_MGMT);
+				stypes >>= 1;
+				i++;
+			}
+			nla_nest_end(msg, nl_ftypes);
+		}
+		nla_nest_end(msg, nl_ifs);
+	}
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
@@ -4717,17 +4767,18 @@ static int nl80211_set_tx_bitrate_mask(s
 	return err;
 }
 
-static int nl80211_register_action(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
+	u16 frame_type = IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ACTION;
 	int err;
 
 	if (!info->attrs[NL80211_ATTR_FRAME_MATCH])
 		return -EINVAL;
 
-	if (nla_len(info->attrs[NL80211_ATTR_FRAME_MATCH]) < 1)
-		return -EINVAL;
+	if (info->attrs[NL80211_ATTR_FRAME_TYPE])
+		frame_type = nla_get_u16(info->attrs[NL80211_ATTR_FRAME_TYPE]);
 
 	rtnl_lock();
 
@@ -4742,12 +4793,13 @@ static int nl80211_register_action(struc
 	}
 
 	/* not much point in registering if we can't reply */
-	if (!rdev->ops->action) {
+	if (!rdev->ops->mgmt_tx) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	err = cfg80211_mlme_register_action(dev->ieee80211_ptr, info->snd_pid,
+	err = cfg80211_mlme_register_mgmt(dev->ieee80211_ptr, info->snd_pid,
+			frame_type,
 			nla_data(info->attrs[NL80211_ATTR_FRAME_MATCH]),
 			nla_len(info->attrs[NL80211_ATTR_FRAME_MATCH]));
  out:
@@ -4758,7 +4810,7 @@ static int nl80211_register_action(struc
 	return err;
 }
 
-static int nl80211_action(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
@@ -4781,7 +4833,7 @@ static int nl80211_action(struct sk_buff
 	if (err)
 		goto unlock_rtnl;
 
-	if (!rdev->ops->action) {
+	if (!rdev->ops->mgmt_tx) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -4824,17 +4876,17 @@ static int nl80211_action(struct sk_buff
 	}
 
 	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_ACTION);
+			     NL80211_CMD_FRAME);
 
 	if (IS_ERR(hdr)) {
 		err = PTR_ERR(hdr);
 		goto free_msg;
 	}
-	err = cfg80211_mlme_action(rdev, dev, chan, channel_type,
-				   channel_type_valid,
-				   nla_data(info->attrs[NL80211_ATTR_FRAME]),
-				   nla_len(info->attrs[NL80211_ATTR_FRAME]),
-				   &cookie);
+	err = cfg80211_mlme_mgmt_tx(rdev, dev, chan, channel_type,
+				    channel_type_valid,
+				    nla_data(info->attrs[NL80211_ATTR_FRAME]),
+				    nla_len(info->attrs[NL80211_ATTR_FRAME]),
+				    &cookie);
 	if (err)
 		goto free_msg;
 
@@ -5333,14 +5385,14 @@ static struct genl_ops nl80211_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_REGISTER_ACTION,
-		.doit = nl80211_register_action,
+		.cmd = NL80211_CMD_REGISTER_FRAME,
+		.doit = nl80211_register_mgmt,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_ACTION,
-		.doit = nl80211_action,
+		.cmd = NL80211_CMD_FRAME,
+		.doit = nl80211_tx_mgmt,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
@@ -6040,9 +6092,9 @@ void nl80211_send_sta_event(struct cfg80
 				nl80211_mlme_mcgrp.id, gfp);
 }
 
-int nl80211_send_action(struct cfg80211_registered_device *rdev,
-			struct net_device *netdev, u32 nlpid,
-			int freq, const u8 *buf, size_t len, gfp_t gfp)
+int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
+		      struct net_device *netdev, u32 nlpid,
+		      int freq, const u8 *buf, size_t len, gfp_t gfp)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -6052,7 +6104,7 @@ int nl80211_send_action(struct cfg80211_
 	if (!msg)
 		return -ENOMEM;
 
-	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_ACTION);
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_FRAME);
 	if (!hdr) {
 		nlmsg_free(msg);
 		return -ENOMEM;
@@ -6080,10 +6132,10 @@ int nl80211_send_action(struct cfg80211_
 	return -ENOBUFS;
 }
 
-void nl80211_send_action_tx_status(struct cfg80211_registered_device *rdev,
-				   struct net_device *netdev, u64 cookie,
-				   const u8 *buf, size_t len, bool ack,
-				   gfp_t gfp)
+void nl80211_send_mgmt_tx_status(struct cfg80211_registered_device *rdev,
+				 struct net_device *netdev, u64 cookie,
+				 const u8 *buf, size_t len, bool ack,
+				 gfp_t gfp)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -6092,7 +6144,7 @@ void nl80211_send_action_tx_status(struc
 	if (!msg)
 		return;
 
-	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_ACTION_TX_STATUS);
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_FRAME_TX_STATUS);
 	if (!hdr) {
 		nlmsg_free(msg);
 		return;
@@ -6179,7 +6231,7 @@ static int nl80211_netlink_notify(struct
 
 	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list)
 		list_for_each_entry_rcu(wdev, &rdev->netdev_list, list)
-			cfg80211_mlme_unregister_actions(wdev, notify->pid);
+			cfg80211_mlme_unregister_socket(wdev, notify->pid);
 
 	rcu_read_unlock();
 
--- wireless-testing.orig/net/wireless/core.c	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2010-08-12 13:56:32.000000000 +0200
@@ -433,7 +433,7 @@ int wiphy_register(struct wiphy *wiphy)
 
 	/* sanity check ifmodes */
 	WARN_ON(!ifmodes);
-	ifmodes &= ((1 << __NL80211_IFTYPE_AFTER_LAST) - 1) & ~1;
+	ifmodes &= ((1 << NUM_NL80211_IFTYPES) - 1) & ~1;
 	if (WARN_ON(ifmodes != wiphy->interface_modes))
 		wiphy->interface_modes = ifmodes;
 
@@ -685,8 +685,8 @@ static int cfg80211_netdev_notifier_call
 		INIT_WORK(&wdev->cleanup_work, wdev_cleanup_work);
 		INIT_LIST_HEAD(&wdev->event_list);
 		spin_lock_init(&wdev->event_lock);
-		INIT_LIST_HEAD(&wdev->action_registrations);
-		spin_lock_init(&wdev->action_registrations_lock);
+		INIT_LIST_HEAD(&wdev->mgmt_registrations);
+		spin_lock_init(&wdev->mgmt_registrations_lock);
 
 		mutex_lock(&rdev->devlist_mtx);
 		list_add_rcu(&wdev->list, &rdev->netdev_list);
@@ -806,7 +806,7 @@ static int cfg80211_netdev_notifier_call
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
 			list_del_rcu(&wdev->list);
 			rdev->devlist_generation++;
-			cfg80211_mlme_purge_actions(wdev);
+			cfg80211_mlme_purge_registrations(wdev);
 #ifdef CONFIG_CFG80211_WEXT
 			kfree(wdev->wext.keys);
 #endif
--- wireless-testing.orig/net/wireless/core.h	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2010-08-12 13:48:00.000000000 +0200
@@ -331,16 +331,17 @@ void __cfg80211_connect_result(struct ne
 			       const u8 *resp_ie, size_t resp_ie_len,
 			       u16 status, bool wextev,
 			       struct cfg80211_bss *bss);
-int cfg80211_mlme_register_action(struct wireless_dev *wdev, u32 snd_pid,
-				  const u8 *match_data, int match_len);
-void cfg80211_mlme_unregister_actions(struct wireless_dev *wdev, u32 nlpid);
-void cfg80211_mlme_purge_actions(struct wireless_dev *wdev);
-int cfg80211_mlme_action(struct cfg80211_registered_device *rdev,
-			 struct net_device *dev,
-			 struct ieee80211_channel *chan,
-			 enum nl80211_channel_type channel_type,
-			 bool channel_type_valid,
-			 const u8 *buf, size_t len, u64 *cookie);
+int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_pid,
+				u16 frame_type, const u8 *match_data,
+				int match_len);
+void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlpid);
+void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev);
+int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev,
+			  struct ieee80211_channel *chan,
+			  enum nl80211_channel_type channel_type,
+			  bool channel_type_valid,
+			  const u8 *buf, size_t len, u64 *cookie);
 
 /* SME */
 int __cfg80211_connect(struct cfg80211_registered_device *rdev,
--- wireless-testing.orig/net/wireless/mlme.c	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2010-08-12 14:06:14.000000000 +0200
@@ -748,31 +748,51 @@ void cfg80211_new_sta(struct net_device
 }
 EXPORT_SYMBOL(cfg80211_new_sta);
 
-struct cfg80211_action_registration {
+struct cfg80211_mgmt_registration {
 	struct list_head list;
 
 	u32 nlpid;
 
 	int match_len;
 
+	__le16 frame_type;
+
 	u8 match[];
 };
 
-int cfg80211_mlme_register_action(struct wireless_dev *wdev, u32 snd_pid,
-				  const u8 *match_data, int match_len)
+int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_pid,
+				u16 frame_type, const u8 *match_data,
+				int match_len)
 {
-	struct cfg80211_action_registration *reg, *nreg;
+	struct cfg80211_mgmt_registration *reg, *nreg;
 	int err = 0;
+	u16 mgmt_type;
+
+	if (!wdev->wiphy->mgmt_stypes)
+		return -EOPNOTSUPP;
+
+	if ((frame_type & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT)
+		return -EINVAL;
+
+	if (frame_type & ~(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE))
+		return -EINVAL;
+
+	mgmt_type = (frame_type & IEEE80211_FCTL_STYPE) >> 4;
+	if (!(wdev->wiphy->mgmt_stypes[wdev->iftype].rx & BIT(mgmt_type)))
+		return -EINVAL;
 
 	nreg = kzalloc(sizeof(*reg) + match_len, GFP_KERNEL);
 	if (!nreg)
 		return -ENOMEM;
 
-	spin_lock_bh(&wdev->action_registrations_lock);
+	spin_lock_bh(&wdev->mgmt_registrations_lock);
 
-	list_for_each_entry(reg, &wdev->action_registrations, list) {
+	list_for_each_entry(reg, &wdev->mgmt_registrations, list) {
 		int mlen = min(match_len, reg->match_len);
 
+		if (frame_type != le16_to_cpu(reg->frame_type))
+			continue;
+
 		if (memcmp(reg->match, match_data, mlen) == 0) {
 			err = -EALREADY;
 			break;
@@ -787,62 +807,75 @@ int cfg80211_mlme_register_action(struct
 	memcpy(nreg->match, match_data, match_len);
 	nreg->match_len = match_len;
 	nreg->nlpid = snd_pid;
-	list_add(&nreg->list, &wdev->action_registrations);
+	nreg->frame_type = cpu_to_le16(frame_type);
+	list_add(&nreg->list, &wdev->mgmt_registrations);
 
  out:
-	spin_unlock_bh(&wdev->action_registrations_lock);
+	spin_unlock_bh(&wdev->mgmt_registrations_lock);
 	return err;
 }
 
-void cfg80211_mlme_unregister_actions(struct wireless_dev *wdev, u32 nlpid)
+void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlpid)
 {
-	struct cfg80211_action_registration *reg, *tmp;
+	struct cfg80211_mgmt_registration *reg, *tmp;
 
-	spin_lock_bh(&wdev->action_registrations_lock);
+	spin_lock_bh(&wdev->mgmt_registrations_lock);
 
-	list_for_each_entry_safe(reg, tmp, &wdev->action_registrations, list) {
+	list_for_each_entry_safe(reg, tmp, &wdev->mgmt_registrations, list) {
 		if (reg->nlpid == nlpid) {
 			list_del(&reg->list);
 			kfree(reg);
 		}
 	}
 
-	spin_unlock_bh(&wdev->action_registrations_lock);
+	spin_unlock_bh(&wdev->mgmt_registrations_lock);
 }
 
-void cfg80211_mlme_purge_actions(struct wireless_dev *wdev)
+void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev)
 {
-	struct cfg80211_action_registration *reg, *tmp;
+	struct cfg80211_mgmt_registration *reg, *tmp;
 
-	spin_lock_bh(&wdev->action_registrations_lock);
+	spin_lock_bh(&wdev->mgmt_registrations_lock);
 
-	list_for_each_entry_safe(reg, tmp, &wdev->action_registrations, list) {
+	list_for_each_entry_safe(reg, tmp, &wdev->mgmt_registrations, list) {
 		list_del(&reg->list);
 		kfree(reg);
 	}
 
-	spin_unlock_bh(&wdev->action_registrations_lock);
+	spin_unlock_bh(&wdev->mgmt_registrations_lock);
 }
 
-int cfg80211_mlme_action(struct cfg80211_registered_device *rdev,
-			 struct net_device *dev,
-			 struct ieee80211_channel *chan,
-			 enum nl80211_channel_type channel_type,
-			 bool channel_type_valid,
-			 const u8 *buf, size_t len, u64 *cookie)
+int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev,
+			  struct ieee80211_channel *chan,
+			  enum nl80211_channel_type channel_type,
+			  bool channel_type_valid,
+			  const u8 *buf, size_t len, u64 *cookie)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	const struct ieee80211_mgmt *mgmt;
+	u16 stype;
 
-	if (rdev->ops->action == NULL)
+	if (!wdev->wiphy->mgmt_stypes)
 		return -EOPNOTSUPP;
+
+	if (!rdev->ops->mgmt_tx)
+		return -EOPNOTSUPP;
+
 	if (len < 24 + 1)
 		return -EINVAL;
 
 	mgmt = (const struct ieee80211_mgmt *) buf;
-	if (!ieee80211_is_action(mgmt->frame_control))
+
+	if (!ieee80211_is_mgmt(mgmt->frame_control))
+		return -EINVAL;
+
+	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
+	if (!(wdev->wiphy->mgmt_stypes[wdev->iftype].tx & BIT(stype >> 4)))
 		return -EINVAL;
-	if (mgmt->u.action.category != WLAN_CATEGORY_PUBLIC) {
+
+	if (ieee80211_is_action(mgmt->frame_control) &&
+	    mgmt->u.action.category != WLAN_CATEGORY_PUBLIC) {
 		/* Verify that we are associated with the destination AP */
 		wdev_lock(wdev);
 
@@ -863,64 +896,75 @@ int cfg80211_mlme_action(struct cfg80211
 		return -EINVAL;
 
 	/* Transmit the Action frame as requested by user space */
-	return rdev->ops->action(&rdev->wiphy, dev, chan, channel_type,
-				 channel_type_valid, buf, len, cookie);
+	return rdev->ops->mgmt_tx(&rdev->wiphy, dev, chan, channel_type,
+				  channel_type_valid, buf, len, cookie);
 }
 
-bool cfg80211_rx_action(struct net_device *dev, int freq, const u8 *buf,
-			size_t len, gfp_t gfp)
+bool cfg80211_rx_mgmt(struct net_device *dev, int freq, const u8 *buf,
+		      size_t len, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	struct cfg80211_action_registration *reg;
-	const u8 *action_data;
-	int action_data_len;
+	struct cfg80211_mgmt_registration *reg;
+	const struct ieee80211_txrx_stypes *stypes =
+		&wiphy->mgmt_stypes[wdev->iftype];
+	struct ieee80211_mgmt *mgmt = (void *)buf;
+	const u8 *data;
+	int data_len;
 	bool result = false;
+	__le16 ftype = mgmt->frame_control &
+		cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE);
+	u16 stype;
+
+	stype = (le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE) >> 4;
 
-	/* frame length - min size excluding category */
-	action_data_len = len - (IEEE80211_MIN_ACTION_SIZE - 1);
+	if (!(stypes->rx & BIT(stype)))
+		return false;
 
-	/* action data starts with category */
-	action_data = buf + IEEE80211_MIN_ACTION_SIZE - 1;
+	data = buf + ieee80211_hdrlen(mgmt->frame_control);
+	data_len = len - ieee80211_hdrlen(mgmt->frame_control);
 
-	spin_lock_bh(&wdev->action_registrations_lock);
+	spin_lock_bh(&wdev->mgmt_registrations_lock);
+
+	list_for_each_entry(reg, &wdev->mgmt_registrations, list) {
+		if (reg->frame_type != ftype)
+			continue;
 
-	list_for_each_entry(reg, &wdev->action_registrations, list) {
-		if (reg->match_len > action_data_len)
+		if (reg->match_len > data_len)
 			continue;
 
-		if (memcmp(reg->match, action_data, reg->match_len))
+		if (memcmp(reg->match, data, reg->match_len))
 			continue;
 
 		/* found match! */
 
 		/* Indicate the received Action frame to user space */
-		if (nl80211_send_action(rdev, dev, reg->nlpid, freq,
-					buf, len, gfp))
+		if (nl80211_send_mgmt(rdev, dev, reg->nlpid, freq,
+				      buf, len, gfp))
 			continue;
 
 		result = true;
 		break;
 	}
 
-	spin_unlock_bh(&wdev->action_registrations_lock);
+	spin_unlock_bh(&wdev->mgmt_registrations_lock);
 
 	return result;
 }
-EXPORT_SYMBOL(cfg80211_rx_action);
+EXPORT_SYMBOL(cfg80211_rx_mgmt);
 
-void cfg80211_action_tx_status(struct net_device *dev, u64 cookie,
-			       const u8 *buf, size_t len, bool ack, gfp_t gfp)
+void cfg80211_mgmt_tx_status(struct net_device *dev, u64 cookie,
+			     const u8 *buf, size_t len, bool ack, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
 	/* Indicate TX status of the Action frame to user space */
-	nl80211_send_action_tx_status(rdev, dev, cookie, buf, len, ack, gfp);
+	nl80211_send_mgmt_tx_status(rdev, dev, cookie, buf, len, ack, gfp);
 }
-EXPORT_SYMBOL(cfg80211_action_tx_status);
+EXPORT_SYMBOL(cfg80211_mgmt_tx_status);
 
 void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      enum nl80211_cqm_rssi_threshold_event rssi_event,
--- wireless-testing.orig/net/wireless/nl80211.h	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.h	2010-08-12 13:48:00.000000000 +0200
@@ -74,13 +74,13 @@ void nl80211_send_sta_event(struct cfg80
 			    struct net_device *dev, const u8 *mac_addr,
 			    struct station_info *sinfo, gfp_t gfp);
 
-int nl80211_send_action(struct cfg80211_registered_device *rdev,
-			struct net_device *netdev, u32 nlpid, int freq,
-			const u8 *buf, size_t len, gfp_t gfp);
-void nl80211_send_action_tx_status(struct cfg80211_registered_device *rdev,
-				   struct net_device *netdev, u64 cookie,
-				   const u8 *buf, size_t len, bool ack,
-				   gfp_t gfp);
+int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
+		      struct net_device *netdev, u32 nlpid, int freq,
+		      const u8 *buf, size_t len, gfp_t gfp);
+void nl80211_send_mgmt_tx_status(struct cfg80211_registered_device *rdev,
+				 struct net_device *netdev, u64 cookie,
+				 const u8 *buf, size_t len, bool ack,
+				 gfp_t gfp);
 
 void
 nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
--- wireless-testing.orig/net/mac80211/cfg.c	2010-08-12 13:42:54.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-08-12 13:56:31.000000000 +0200
@@ -1541,11 +1541,11 @@ static int ieee80211_cancel_remain_on_ch
 	return ieee80211_wk_cancel_remain_on_channel(sdata, cookie);
 }
 
-static int ieee80211_action(struct wiphy *wiphy, struct net_device *dev,
-			    struct ieee80211_channel *chan,
-			    enum nl80211_channel_type channel_type,
-			    bool channel_type_valid,
-			    const u8 *buf, size_t len, u64 *cookie)
+static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
+			     struct ieee80211_channel *chan,
+			     enum nl80211_channel_type channel_type,
+			     bool channel_type_valid,
+			     const u8 *buf, size_t len, u64 *cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -1645,6 +1645,6 @@ struct cfg80211_ops mac80211_config_ops
 	.set_bitrate_mask = ieee80211_set_bitrate_mask,
 	.remain_on_channel = ieee80211_remain_on_channel,
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
-	.action = ieee80211_action,
+	.mgmt_tx = ieee80211_mgmt_tx,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
 };
--- wireless-testing.orig/net/mac80211/rx.c	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-08-12 13:56:31.000000000 +0200
@@ -1929,13 +1929,36 @@ static void ieee80211_process_sa_query_r
 }
 
 static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_mgmt_check(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
+
+	/*
+	 * From here on, look only at management frames.
+	 * Data and control frames are already handled,
+	 * and unknown (reserved) frames are useless.
+	 */
+	if (rx->skb->len < 24)
+		return RX_DROP_MONITOR;
+
+	if (!ieee80211_is_mgmt(mgmt->frame_control))
+		return RX_DROP_MONITOR;
+
+	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
+		return RX_DROP_MONITOR;
+
+	if (ieee80211_drop_unencrypted_mgmt(rx))
+		return RX_DROP_UNUSABLE;
+
+	return RX_CONTINUE;
+}
+
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
-	struct sk_buff *nskb;
-	struct ieee80211_rx_status *status;
 	int len = rx->skb->len;
 
 	if (!ieee80211_is_action(mgmt->frame_control))
@@ -1951,9 +1974,6 @@ ieee80211_rx_h_action(struct ieee80211_r
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_UNUSABLE;
 
-	if (ieee80211_drop_unencrypted_mgmt(rx))
-		return RX_DROP_UNUSABLE;
-
 	switch (mgmt->u.action.category) {
 	case WLAN_CATEGORY_BACK:
 		/*
@@ -2044,17 +2064,36 @@ ieee80211_rx_h_action(struct ieee80211_r
 		goto queue;
 	}
 
+	return RX_CONTINUE;
+
  invalid:
-	/*
-	 * For AP mode, hostapd is responsible for handling any action
-	 * frames that we didn't handle, including returning unknown
-	 * ones. For all other modes we will return them to the sender,
-	 * setting the 0x80 bit in the action category, as required by
-	 * 802.11-2007 7.3.1.11.
-	 */
-	if (sdata->vif.type == NL80211_IFTYPE_AP ||
-	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		return RX_DROP_MONITOR;
+	rx->flags |= IEEE80211_MALFORMED_ACTION_FRM;
+	/* will return in the next handlers */
+	return RX_CONTINUE;
+
+ handled:
+	if (rx->sta)
+		rx->sta->rx_packets++;
+	dev_kfree_skb(rx->skb);
+	return RX_QUEUED;
+
+ queue:
+	rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
+	skb_queue_tail(&sdata->skb_queue, rx->skb);
+	ieee80211_queue_work(&local->hw, &sdata->work);
+	if (rx->sta)
+		rx->sta->rx_packets++;
+	return RX_QUEUED;
+}
+
+static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_rx_status *status;
+
+	/* skip known-bad action frames and return them in the next handler */
+	if (rx->flags & IEEE80211_MALFORMED_ACTION_FRM)
+		return RX_CONTINUE;
 
 	/*
 	 * Getting here means the kernel doesn't know how to handle
@@ -2064,10 +2103,44 @@ ieee80211_rx_h_action(struct ieee80211_r
 	 */
 	status = IEEE80211_SKB_RXCB(rx->skb);
 
-	if (cfg80211_rx_action(rx->sdata->dev, status->freq,
-			       rx->skb->data, rx->skb->len,
-			       GFP_ATOMIC))
-		goto handled;
+	if (cfg80211_rx_mgmt(rx->sdata->dev, status->freq,
+			     rx->skb->data, rx->skb->len,
+			     GFP_ATOMIC)) {
+		if (rx->sta)
+			rx->sta->rx_packets++;
+		dev_kfree_skb(rx->skb);
+		return RX_QUEUED;
+	}
+
+
+	return RX_CONTINUE;
+}
+
+static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_local *local = rx->local;
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
+	struct sk_buff *nskb;
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
+
+	if (!ieee80211_is_action(mgmt->frame_control))
+		return RX_CONTINUE;
+
+	/*
+	 * For AP mode, hostapd is responsible for handling any action
+	 * frames that we didn't handle, including returning unknown
+	 * ones. For all other modes we will return them to the sender,
+	 * setting the 0x80 bit in the action category, as required by
+	 * 802.11-2007 7.3.1.11.
+	 * Newer versions of hostapd shall also use the management frame
+	 * registration mechanisms, but older ones still use cooked
+	 * monitor interfaces so push all frames there.
+	 */
+	if (!(rx->flags & IEEE80211_MALFORMED_ACTION_FRM) &&
+	    (sdata->vif.type == NL80211_IFTYPE_AP ||
+	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
+		return RX_DROP_MONITOR;
 
 	/* do not return rejected action frames */
 	if (mgmt->u.action.category & 0x80)
@@ -2086,20 +2159,8 @@ ieee80211_rx_h_action(struct ieee80211_r
 
 		ieee80211_tx_skb(rx->sdata, nskb);
 	}
-
- handled:
-	if (rx->sta)
-		rx->sta->rx_packets++;
 	dev_kfree_skb(rx->skb);
 	return RX_QUEUED;
-
- queue:
-	rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
-	skb_queue_tail(&sdata->skb_queue, rx->skb);
-	ieee80211_queue_work(&local->hw, &sdata->work);
-	if (rx->sta)
-		rx->sta->rx_packets++;
-	return RX_QUEUED;
 }
 
 static ieee80211_rx_result debug_noinline
@@ -2110,15 +2171,6 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 	struct ieee80211_mgmt *mgmt = (void *)rx->skb->data;
 	__le16 stype;
 
-	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
-		return RX_DROP_MONITOR;
-
-	if (rx->skb->len < 24)
-		return RX_DROP_MONITOR;
-
-	if (ieee80211_drop_unencrypted_mgmt(rx))
-		return RX_DROP_UNUSABLE;
-
 	rxs = ieee80211_work_rx_mgmt(rx->sdata, rx->skb);
 	if (rxs != RX_CONTINUE)
 		return rxs;
@@ -2346,7 +2398,10 @@ static void ieee80211_invoke_rx_handlers
 		if (res != RX_CONTINUE)
 			goto rxh_next;
 
+		CALL_RXH(ieee80211_rx_h_mgmt_check)
 		CALL_RXH(ieee80211_rx_h_action)
+		CALL_RXH(ieee80211_rx_h_userspace_mgmt)
+		CALL_RXH(ieee80211_rx_h_action_return)
 		CALL_RXH(ieee80211_rx_h_mgmt)
 
 #undef CALL_RXH
@@ -2453,7 +2508,7 @@ static int prepare_for_handlers(struct i
 		break;
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_UNSPECIFIED:
-	case __NL80211_IFTYPE_AFTER_LAST:
+	case NUM_NL80211_IFTYPES:
 		/* should never get here */
 		WARN_ON(1);
 		break;
--- wireless-testing.orig/net/mac80211/status.c	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/net/mac80211/status.c	2010-08-12 13:48:00.000000000 +0200
@@ -296,7 +296,7 @@ void ieee80211_tx_status(struct ieee8021
 	}
 
 	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX)
-		cfg80211_action_tx_status(
+		cfg80211_mgmt_tx_status(
 			skb->dev, (unsigned long) skb, skb->data, skb->len,
 			!!(info->flags & IEEE80211_TX_STAT_ACK), GFP_ATOMIC);
 
--- wireless-testing.orig/net/mac80211/main.c	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-08-12 13:56:31.000000000 +0200
@@ -390,6 +390,41 @@ static int ieee80211_ifa_changed(struct
 }
 #endif
 
+/* There isn't a lot of sense in it, but you can transmit anything you like */
+static const struct ieee80211_txrx_stypes
+ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
+	[NL80211_IFTYPE_ADHOC] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4),
+	},
+	[NL80211_IFTYPE_STATION] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
+	},
+	[NL80211_IFTYPE_AP] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+			BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_DEAUTH >> 4) |
+			BIT(IEEE80211_STYPE_ACTION >> 4),
+	},
+	[NL80211_IFTYPE_AP_VLAN] = {
+		/* copy AP */
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+			BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_DEAUTH >> 4) |
+			BIT(IEEE80211_STYPE_ACTION >> 4),
+	},
+};
+
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
@@ -419,6 +454,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	if (!wiphy)
 		return NULL;
 
+	wiphy->mgmt_stypes = ieee80211_default_mgmt_stypes;
+
 	wiphy->flags |= WIPHY_FLAG_NETNS_OK |
 			WIPHY_FLAG_4ADDR_AP |
 			WIPHY_FLAG_4ADDR_STATION;
--- wireless-testing.orig/net/wireless/util.c	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/net/wireless/util.c	2010-08-12 14:17:29.000000000 +0200
@@ -823,7 +823,7 @@ int cfg80211_change_iface(struct cfg8021
 			/* monitor can't bridge anyway */
 			break;
 		case NL80211_IFTYPE_UNSPECIFIED:
-		case __NL80211_IFTYPE_AFTER_LAST:
+		case NUM_NL80211_IFTYPES:
 			/* not happening */
 			break;
 		}
--- wireless-testing.orig/net/mac80211/iface.c	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-08-12 13:56:31.000000000 +0200
@@ -177,7 +177,7 @@ static int ieee80211_open(struct net_dev
 		/* no special treatment */
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
-	case __NL80211_IFTYPE_AFTER_LAST:
+	case NUM_NL80211_IFTYPES:
 		/* cannot happen */
 		WARN_ON(1);
 		break;
@@ -630,7 +630,7 @@ static void ieee80211_teardown_sdata(str
 	case NL80211_IFTYPE_MONITOR:
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
-	case __NL80211_IFTYPE_AFTER_LAST:
+	case NUM_NL80211_IFTYPES:
 		BUG();
 		break;
 	}
@@ -882,7 +882,7 @@ static void ieee80211_setup_sdata(struct
 	case NL80211_IFTYPE_AP_VLAN:
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
-	case __NL80211_IFTYPE_AFTER_LAST:
+	case NUM_NL80211_IFTYPES:
 		BUG();
 		break;
 	}
--- wireless-testing.orig/net/mac80211/util.c	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-08-12 13:56:31.000000000 +0200
@@ -471,7 +471,7 @@ void ieee80211_iterate_active_interfaces
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
-		case __NL80211_IFTYPE_AFTER_LAST:
+		case NUM_NL80211_IFTYPES:
 		case NL80211_IFTYPE_UNSPECIFIED:
 		case NL80211_IFTYPE_MONITOR:
 		case NL80211_IFTYPE_AP_VLAN:
@@ -505,7 +505,7 @@ void ieee80211_iterate_active_interfaces
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
-		case __NL80211_IFTYPE_AFTER_LAST:
+		case NUM_NL80211_IFTYPES:
 		case NL80211_IFTYPE_UNSPECIFIED:
 		case NL80211_IFTYPE_MONITOR:
 		case NL80211_IFTYPE_AP_VLAN:
@@ -1189,7 +1189,7 @@ int ieee80211_reconfig(struct ieee80211_
 			/* ignore virtual */
 			break;
 		case NL80211_IFTYPE_UNSPECIFIED:
-		case __NL80211_IFTYPE_AFTER_LAST:
+		case NUM_NL80211_IFTYPES:
 			WARN_ON(1);
 			break;
 		}
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-08-12 13:36:55.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-08-12 13:48:00.000000000 +0200
@@ -170,6 +170,7 @@ typedef unsigned __bitwise__ ieee80211_r
 #define IEEE80211_RX_RA_MATCH		BIT(1)
 #define IEEE80211_RX_AMSDU		BIT(2)
 #define IEEE80211_RX_FRAGMENTED		BIT(3)
+#define IEEE80211_MALFORMED_ACTION_FRM	BIT(4)
 /* only add flags here that do not change with subframes of an aMPDU */
 
 struct ieee80211_rx_data {


