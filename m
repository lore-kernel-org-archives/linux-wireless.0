Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbYBWOVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 09:21:06 -0500
Message-Id: <20080223142009.317099000@sipsolutions.net> (sfid-20080223_142116_060744_D57F44B6)
References: <20080223141703.194775000@sipsolutions.net>
Date: Sat, 23 Feb 2008 15:17:06 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 03/18] nl80211/cfg80211: support for mesh, sta dumping
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis Carlos Cobo <luisca@cozybit.com>

Added support for mesh id and mesh path operation as well as
station structure dumping.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h |  121 +++++++++++--
 include/net/cfg80211.h  |  141 +++++++++++++--
 net/mac80211/cfg.c      |   22 +-
 net/wireless/nl80211.c  |  436 +++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 652 insertions(+), 68 deletions(-)

--- everything.orig/include/linux/nl80211.h	2008-02-23 14:47:07.000000000 +0100
+++ everything/include/linux/nl80211.h	2008-02-23 14:47:16.000000000 +0100
@@ -78,6 +78,18 @@
  *	or, if no MAC address given, all stations, on the interface identified
  *	by %NL80211_ATTR_IFINDEX.
  *
+ * @NL80211_CMD_GET_MPATH: Get mesh path attributes for mesh path to
+ * 	destination %NL80211_ATTR_MAC on the interface identified by
+ * 	%NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_SET_MPATH:  Set mesh path attributes for mesh path to
+ * 	destination %NL80211_ATTR_MAC on the interface identified by
+ * 	%NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_NEW_PATH: Add a mesh path with given attributes to the
+ *	the interface identified by %NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_DEL_PATH: Remove a mesh path identified by %NL80211_ATTR_MAC
+ *	or, if no MAC address given, all mesh paths, on the interface identified
+ *	by %NL80211_ATTR_IFINDEX.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -112,6 +124,11 @@ enum nl80211_commands {
 
 	/* add commands here */
 
+	NL80211_CMD_GET_MPATH,
+	NL80211_CMD_SET_MPATH,
+	NL80211_CMD_NEW_MPATH,
+	NL80211_CMD_DEL_MPATH,
+
 	/* used to define NL80211_CMD_MAX below */
 	__NL80211_CMD_AFTER_LAST,
 	NL80211_CMD_MAX = __NL80211_CMD_AFTER_LAST - 1
@@ -157,13 +174,21 @@ enum nl80211_commands {
  *	restriction (at most %NL80211_MAX_SUPP_RATES).
  * @NL80211_ATTR_STA_VLAN: interface index of VLAN interface to move station
  *	to, or the AP interface the station was originally added to to.
- * @NL80211_ATTR_STA_STATS: statistics for a station, part of station info
+ * @NL80211_ATTR_STA_INFO: information about a station, part of station info
  *	given for %NL80211_CMD_GET_STATION, nested attribute containing
- *	info as possible, see &enum nl80211_sta_stats.
+ *	info as possible, see &enum nl80211_sta_info.
  *
  * @NL80211_ATTR_WIPHY_BANDS: Information about an operating bands,
  *	consisting of a nested array.
  *
+ * @NL80211_ATTR_MESH_ID: mesh id (1-32 bytes).
+ * @NL80211_ATTR_PLINK_ACTION: action to perform on the mesh peer link.
+ * @NL80211_ATTR_MPATH_NEXT_HOP: MAC address of the next hop for a mesh path.
+ * @NL80211_ATTR_MPATH_INFO: information about a mesh_path, part of mesh path
+ * 	info given for %NL80211_CMD_GET_MPATH, nested attribute described at
+ *	&enum nl80211_mpath_info.
+ *
+ *
  * @NL80211_ATTR_MNTR_FLAGS: flags, nested element with NLA_FLAG attributes of
  *      &enum nl80211_mntr_flags.
  *
@@ -199,7 +224,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_STA_LISTEN_INTERVAL,
 	NL80211_ATTR_STA_SUPPORTED_RATES,
 	NL80211_ATTR_STA_VLAN,
-	NL80211_ATTR_STA_STATS,
+	NL80211_ATTR_STA_INFO,
 
 	NL80211_ATTR_WIPHY_BANDS,
 
@@ -207,6 +232,11 @@ enum nl80211_attrs {
 
 	/* add attributes here, update the policy in nl80211.c */
 
+	NL80211_ATTR_MESH_ID,
+	NL80211_ATTR_STA_PLINK_ACTION,
+	NL80211_ATTR_MPATH_NEXT_HOP,
+	NL80211_ATTR_MPATH_INFO,
+
 	__NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
@@ -223,6 +253,7 @@ enum nl80211_attrs {
  * @NL80211_IFTYPE_AP_VLAN: VLAN interface for access points
  * @NL80211_IFTYPE_WDS: wireless distribution interface
  * @NL80211_IFTYPE_MONITOR: monitor interface receiving all frames
+ * @NL80211_IFTYPE_MESH_POINT: mesh point
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @__NL80211_IFTYPE_AFTER_LAST: internal use
  *
@@ -238,6 +269,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_AP_VLAN,
 	NL80211_IFTYPE_WDS,
 	NL80211_IFTYPE_MONITOR,
+	NL80211_IFTYPE_MESH_POINT,
 
 	/* keep last */
 	__NL80211_IFTYPE_AFTER_LAST,
@@ -267,27 +299,78 @@ enum nl80211_sta_flags {
 };
 
 /**
- * enum nl80211_sta_stats - station statistics
+ * enum nl80211_sta_info - station information
  *
- * These attribute types are used with %NL80211_ATTR_STA_STATS
+ * These attribute types are used with %NL80211_ATTR_STA_INFO
  * when getting information about a station.
  *
- * @__NL80211_STA_STAT_INVALID: attribute number 0 is reserved
- * @NL80211_STA_STAT_INACTIVE_TIME: time since last activity (u32, msecs)
- * @NL80211_STA_STAT_RX_BYTES: total received bytes (u32, from this station)
- * @NL80211_STA_STAT_TX_BYTES: total transmitted bytes (u32, to this station)
- * @__NL80211_STA_STAT_AFTER_LAST: internal
- * @NL80211_STA_STAT_MAX: highest possible station stats attribute
- */
-enum nl80211_sta_stats {
-	__NL80211_STA_STAT_INVALID,
-	NL80211_STA_STAT_INACTIVE_TIME,
-	NL80211_STA_STAT_RX_BYTES,
-	NL80211_STA_STAT_TX_BYTES,
+ * @__NL80211_STA_INFO_INVALID: attribute number 0 is reserved
+ * @NL80211_STA_INFO_INACTIVE_TIME: time since last activity (u32, msecs)
+ * @NL80211_STA_INFO_RX_BYTES: total received bytes (u32, from this station)
+ * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this station)
+ * @__NL80211_STA_INFO_AFTER_LAST: internal
+ * @NL80211_STA_INFO_MAX: highest possible station info attribute
+ */
+enum nl80211_sta_info {
+	__NL80211_STA_INFO_INVALID,
+	NL80211_STA_INFO_INACTIVE_TIME,
+	NL80211_STA_INFO_RX_BYTES,
+	NL80211_STA_INFO_TX_BYTES,
+	NL80211_STA_INFO_LLID,
+	NL80211_STA_INFO_PLID,
+	NL80211_STA_INFO_PLINK_STATE,
+
+	/* keep last */
+	__NL80211_STA_INFO_AFTER_LAST,
+	NL80211_STA_INFO_MAX = __NL80211_STA_INFO_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_mpath_flags - nl80211 mesh path flags
+ *
+ * @NL80211_MPATH_FLAG_ACTIVE: the mesh path is active
+ * @NL80211_MPATH_FLAG_RESOLVING: the mesh path discovery process is running
+ * @NL80211_MPATH_FLAG_DSN_VALID: the mesh path contains a valid DSN
+ * @NL80211_MPATH_FLAG_FIXED: the mesh path has been manually set
+ * @NL80211_MPATH_FLAG_RESOLVED: the mesh path discovery process succeeded
+ */
+enum nl80211_mpath_flags {
+	NL80211_MPATH_FLAG_ACTIVE =	1<<0,
+	NL80211_MPATH_FLAG_RESOLVING =	1<<1,
+	NL80211_MPATH_FLAG_DSN_VALID =	1<<2,
+	NL80211_MPATH_FLAG_FIXED =	1<<3,
+	NL80211_MPATH_FLAG_RESOLVED =	1<<4,
+};
+
+/**
+ * enum nl80211_mpath_info - mesh path information
+ *
+ * These attribute types are used with %NL80211_ATTR_MPATH_INFO when getting
+ * information about a mesh path.
+ *
+ * @__NL80211_MPATH_INFO_INVALID: attribute number 0 is reserved
+ * @NL80211_ATTR_MPATH_FRAME_QLEN: number of queued frames for this destination
+ * @NL80211_ATTR_MPATH_DSN: destination sequence number
+ * @NL80211_ATTR_MPATH_METRIC: metric (cost) of this mesh path
+ * @NL80211_ATTR_MPATH_EXPTIME: expiration time for the path, in msec from now
+ * @NL80211_ATTR_MPATH_FLAGS: mesh path flags, enumerated in
+ * 	&enum nl80211_mpath_flags;
+ * @NL80211_ATTR_MPATH_DISCOVERY_TIMEOUT: total path discovery timeout, in msec
+ * @NL80211_ATTR_MPATH_DISCOVERY_RETRIES: mesh path discovery retries
+ */
+enum nl80211_mpath_info {
+	__NL80211_MPATH_INFO_INVALID,
+	NL80211_MPATH_INFO_FRAME_QLEN,
+	NL80211_MPATH_INFO_DSN,
+	NL80211_MPATH_INFO_METRIC,
+	NL80211_MPATH_INFO_EXPTIME,
+	NL80211_MPATH_INFO_FLAGS,
+	NL80211_MPATH_INFO_DISCOVERY_TIMEOUT,
+	NL80211_MPATH_INFO_DISCOVERY_RETRIES,
 
 	/* keep last */
-	__NL80211_STA_STAT_AFTER_LAST,
-	NL80211_STA_STAT_MAX = __NL80211_STA_STAT_AFTER_LAST - 1
+	__NL80211_MPATH_INFO_AFTER_LAST,
+	NL80211_MPATH_INFO_MAX = __NL80211_MPATH_INFO_AFTER_LAST - 1
 };
 
 /**
--- everything.orig/include/net/cfg80211.h	2008-02-23 14:47:07.000000000 +0100
+++ everything/include/net/cfg80211.h	2008-02-23 14:47:16.000000000 +0100
@@ -12,6 +12,16 @@
  * Copyright 2006, 2007	Johannes Berg <johannes@sipsolutions.net>
  */
 
+/**
+ * struct vif_params - describes virtual interface parameters
+ * @mesh_id: mesh ID to use
+ * @mesh_id_len: length of the mesh ID
+ */
+struct vif_params {
+       u8 *mesh_id;
+       int mesh_id_len;
+};
+
 /* Radiotap header iteration
  *   implemented in net/wireless/radiotap.c
  *   docs in Documentation/networking/radiotap-headers.txt
@@ -109,6 +119,19 @@ enum station_flags {
 };
 
 /**
+ * enum plink_action - actions to perform in mesh peers
+ *
+ * @PLINK_ACTION_INVALID: action 0 is reserved
+ * @PLINK_ACTION_OPEN: start mesh peer link establishment
+ * @PLINK_ACTION_BLOCL: block traffic from this mesh peer
+ */
+enum plink_actions {
+	PLINK_ACTION_INVALID,
+	PLINK_ACTION_OPEN,
+	PLINK_ACTION_BLOCK,
+};
+
+/**
  * struct station_parameters - station parameters
  *
  * Used to change and create a new station.
@@ -128,39 +151,52 @@ struct station_parameters {
 	int listen_interval;
 	u16 aid;
 	u8 supported_rates_len;
+	u8 plink_action;
 };
 
 /**
- * enum station_stats_flags - station statistics flags
+ * enum station_info_flags - station information flags
  *
- * Used by the driver to indicate which info in &struct station_stats
- * it has filled in during get_station().
+ * Used by the driver to indicate which info in &struct station_info
+ * it has filled in during get_station() or dump_station().
  *
- * @STATION_STAT_INACTIVE_TIME: @inactive_time filled
- * @STATION_STAT_RX_BYTES: @rx_bytes filled
- * @STATION_STAT_TX_BYTES: @tx_bytes filled
- */
-enum station_stats_flags {
-	STATION_STAT_INACTIVE_TIME	= 1<<0,
-	STATION_STAT_RX_BYTES		= 1<<1,
-	STATION_STAT_TX_BYTES		= 1<<2,
+ * @STATION_INFO_INACTIVE_TIME: @inactive_time filled
+ * @STATION_INFO_RX_BYTES: @rx_bytes filled
+ * @STATION_INFO_TX_BYTES: @tx_bytes filled
+ * @STATION_INFO_LLID: @llid filled
+ * @STATION_INFO_PLID: @plid filled
+ * @STATION_INFO_PLINK_STATE: @plink_state filled
+ */
+enum station_info_flags {
+	STATION_INFO_INACTIVE_TIME	= 1<<0,
+	STATION_INFO_RX_BYTES		= 1<<1,
+	STATION_INFO_TX_BYTES		= 1<<2,
+	STATION_INFO_LLID		= 1<<3,
+	STATION_INFO_PLID		= 1<<4,
+	STATION_INFO_PLINK_STATE	= 1<<5,
 };
 
 /**
- * struct station_stats - station statistics
+ * struct station_info - station information
  *
- * Station information filled by driver for get_station().
+ * Station information filled by driver for get_station() and dump_station.
  *
- * @filled: bitflag of flags from &enum station_stats_flags
+ * @filled: bitflag of flags from &enum station_info_flags
  * @inactive_time: time since last station activity (tx/rx) in milliseconds
  * @rx_bytes: bytes received from this station
  * @tx_bytes: bytes transmitted to this station
+ * @llid: mesh local link id
+ * @plid: mesh peer link id
+ * @plink_state: mesh peer link state
  */
-struct station_stats {
+struct station_info {
 	u32 filled;
 	u32 inactive_time;
 	u32 rx_bytes;
 	u32 tx_bytes;
+	u16 llid;
+	u16 plid;
+	u8 plink_state;
 };
 
 /**
@@ -183,6 +219,56 @@ enum monitor_flags {
 	MONITOR_FLAG_COOK_FRAMES	= 1<<NL80211_MNTR_FLAG_COOK_FRAMES,
 };
 
+/**
+ * enum mpath_info_flags -  mesh path information flags
+ *
+ * Used by the driver to indicate which info in &struct mpath_info it has filled
+ * in during get_station() or dump_station().
+ *
+ * MPATH_INFO_FRAME_QLEN: @frame_qlen filled
+ * MPATH_INFO_DSN: @dsn filled
+ * MPATH_INFO_METRIC: @metric filled
+ * MPATH_INFO_EXPTIME: @exptime filled
+ * MPATH_INFO_DISCOVERY_TIMEOUT: @discovery_timeout filled
+ * MPATH_INFO_DISCOVERY_RETRIES: @discovery_retries filled
+ * MPATH_INFO_FLAGS: @flags filled
+ */
+enum mpath_info_flags {
+	MPATH_INFO_FRAME_QLEN		= BIT(0),
+	MPATH_INFO_DSN			= BIT(1),
+	MPATH_INFO_METRIC		= BIT(2),
+	MPATH_INFO_EXPTIME		= BIT(3),
+	MPATH_INFO_DISCOVERY_TIMEOUT	= BIT(4),
+	MPATH_INFO_DISCOVERY_RETRIES	= BIT(5),
+	MPATH_INFO_FLAGS		= BIT(6),
+};
+
+/**
+ * struct mpath_info - mesh path information
+ *
+ * Mesh path information filled by driver for get_mpath() and dump_mpath().
+ *
+ * @filled: bitfield of flags from &enum mpath_info_flags
+ * @frame_qlen: number of queued frames for this destination
+ * @dsn: destination sequence number
+ * @metric: metric (cost) of this mesh path
+ * @exptime: expiration time for the mesh path from now, in msecs
+ * @flags: mesh path flags
+ * @discovery_timeout: total mesh path discovery timeout, in msecs
+ * @discovery_retries: mesh path discovery retries
+ */
+struct mpath_info {
+	u32 filled;
+	u32 frame_qlen;
+	u32 dsn;
+	u32 metric;
+	u32 exptime;
+	u32 discovery_timeout;
+	u8 discovery_retries;
+	u8 flags;
+};
+
+
 /* from net/wireless.h */
 struct wiphy;
 
@@ -230,13 +316,17 @@ struct wiphy;
  * @del_station: Remove a station; @mac may be NULL to remove all stations.
  *
  * @change_station: Modify a given station.
+ *
+ * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
-				    enum nl80211_iftype type, u32 *flags);
+				    enum nl80211_iftype type, u32 *flags,
+				    struct vif_params *params);
 	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
 	int	(*change_virtual_intf)(struct wiphy *wiphy, int ifindex,
-				       enum nl80211_iftype type, u32 *flags);
+				       enum nl80211_iftype type, u32 *flags,
+				       struct vif_params *params);
 
 	int	(*add_key)(struct wiphy *wiphy, struct net_device *netdev,
 			   u8 key_index, u8 *mac_addr,
@@ -264,7 +354,22 @@ struct cfg80211_ops {
 	int	(*change_station)(struct wiphy *wiphy, struct net_device *dev,
 				  u8 *mac, struct station_parameters *params);
 	int	(*get_station)(struct wiphy *wiphy, struct net_device *dev,
-			       u8 *mac, struct station_stats *stats);
+			       u8 *mac, struct station_info *sinfo);
+	int	(*dump_station)(struct wiphy *wiphy, struct net_device *dev,
+			       int idx, u8 *mac, struct station_info *sinfo);
+
+	int	(*add_mpath)(struct wiphy *wiphy, struct net_device *dev,
+			       u8 *dst, u8 *next_hop);
+	int	(*del_mpath)(struct wiphy *wiphy, struct net_device *dev,
+			       u8 *dst);
+	int	(*change_mpath)(struct wiphy *wiphy, struct net_device *dev,
+				  u8 *dst, u8 *next_hop);
+	int	(*get_mpath)(struct wiphy *wiphy, struct net_device *dev,
+			       u8 *dst, u8 *next_hop,
+			       struct mpath_info *pinfo);
+	int	(*dump_mpath)(struct wiphy *wiphy, struct net_device *dev,
+			       int idx, u8 *dst, u8 *next_hop,
+			       struct mpath_info *pinfo);
 };
 
 #endif /* __NET_CFG80211_H */
--- everything.orig/net/wireless/nl80211.c	2008-02-23 14:47:07.000000000 +0100
+++ everything/net/wireless/nl80211.c	2008-02-23 14:47:27.000000000 +0100
@@ -81,8 +81,12 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_STA_LISTEN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_ATTR_STA_SUPPORTED_RATES] = { .type = NLA_BINARY,
 					       .len = NL80211_MAX_SUPP_RATES },
+	[NL80211_ATTR_STA_PLINK_ACTION] = { .type = NLA_U8 },
 	[NL80211_ATTR_STA_VLAN] = { .type = NLA_U32 },
 	[NL80211_ATTR_MNTR_FLAGS] = { .type = NLA_NESTED },
+	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
+				.len = IEEE80211_MAX_MESH_ID_LEN },
+	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
 };
 
 /* message building helper */
@@ -369,11 +373,14 @@ static int parse_monitor_flags(struct nl
 static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
+	struct vif_params params;
 	int err, ifindex;
 	enum nl80211_iftype type;
 	struct net_device *dev;
 	u32 flags;
 
+	memset(&params, 0, sizeof(params));
+
 	if (info->attrs[NL80211_ATTR_IFTYPE]) {
 		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
 		if (type > NL80211_IFTYPE_MAX)
@@ -392,12 +399,18 @@ static int nl80211_set_interface(struct 
 		goto unlock;
 	}
 
+	if (type == NL80211_IFTYPE_MESH_POINT &&
+	    info->attrs[NL80211_ATTR_MESH_ID]) {
+		params.mesh_id = nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
+		params.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
+	}
+
 	rtnl_lock();
 	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
 				  &flags);
 	err = drv->ops->change_virtual_intf(&drv->wiphy, ifindex,
-					    type, err ? NULL : &flags);
+					    type, err ? NULL : &flags, &params);
 	rtnl_unlock();
 
  unlock:
@@ -408,10 +421,13 @@ static int nl80211_set_interface(struct 
 static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
+	struct vif_params params;
 	int err;
 	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
 	u32 flags;
 
+	memset(&params, 0, sizeof(params));
+
 	if (!info->attrs[NL80211_ATTR_IFNAME])
 		return -EINVAL;
 
@@ -430,15 +446,22 @@ static int nl80211_new_interface(struct 
 		goto unlock;
 	}
 
+	if (type == NL80211_IFTYPE_MESH_POINT &&
+	    info->attrs[NL80211_ATTR_MESH_ID]) {
+		params.mesh_id = nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
+		params.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
+	}
+
 	rtnl_lock();
 	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
 				  &flags);
 	err = drv->ops->add_virtual_intf(&drv->wiphy,
 		nla_data(info->attrs[NL80211_ATTR_IFNAME]),
-		type, err ? NULL : &flags);
+		type, err ? NULL : &flags, &params);
 	rtnl_unlock();
 
+
  unlock:
 	cfg80211_put_dev(drv);
 	return err;
@@ -866,10 +889,10 @@ static int parse_station_flags(struct nl
 
 static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 				int flags, struct net_device *dev,
-				u8 *mac_addr, struct station_stats *stats)
+				u8 *mac_addr, struct station_info *sinfo)
 {
 	void *hdr;
-	struct nlattr *statsattr;
+	struct nlattr *sinfoattr;
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
 	if (!hdr)
@@ -878,20 +901,29 @@ static int nl80211_send_station(struct s
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
 	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
 
-	statsattr = nla_nest_start(msg, NL80211_ATTR_STA_STATS);
-	if (!statsattr)
+	sinfoattr = nla_nest_start(msg, NL80211_ATTR_STA_INFO);
+	if (!sinfoattr)
 		goto nla_put_failure;
-	if (stats->filled & STATION_STAT_INACTIVE_TIME)
-		NLA_PUT_U32(msg, NL80211_STA_STAT_INACTIVE_TIME,
-			    stats->inactive_time);
-	if (stats->filled & STATION_STAT_RX_BYTES)
-		NLA_PUT_U32(msg, NL80211_STA_STAT_RX_BYTES,
-			    stats->rx_bytes);
-	if (stats->filled & STATION_STAT_TX_BYTES)
-		NLA_PUT_U32(msg, NL80211_STA_STAT_TX_BYTES,
-			    stats->tx_bytes);
+	if (sinfo->filled & STATION_INFO_INACTIVE_TIME)
+		NLA_PUT_U32(msg, NL80211_STA_INFO_INACTIVE_TIME,
+			    sinfo->inactive_time);
+	if (sinfo->filled & STATION_INFO_RX_BYTES)
+		NLA_PUT_U32(msg, NL80211_STA_INFO_RX_BYTES,
+			    sinfo->rx_bytes);
+	if (sinfo->filled & STATION_INFO_TX_BYTES)
+		NLA_PUT_U32(msg, NL80211_STA_INFO_TX_BYTES,
+			    sinfo->tx_bytes);
+	if (sinfo->filled & STATION_INFO_LLID)
+		NLA_PUT_U16(msg, NL80211_STA_INFO_LLID,
+			    sinfo->llid);
+	if (sinfo->filled & STATION_INFO_PLID)
+		NLA_PUT_U16(msg, NL80211_STA_INFO_PLID,
+			    sinfo->plid);
+	if (sinfo->filled & STATION_INFO_PLINK_STATE)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
+			    sinfo->plink_state);
 
-	nla_nest_end(msg, statsattr);
+	nla_nest_end(msg, sinfoattr);
 
 	return genlmsg_end(msg, hdr);
 
@@ -899,17 +931,80 @@ static int nl80211_send_station(struct s
 	return genlmsg_cancel(msg, hdr);
 }
 
+static int nl80211_dump_station(struct sk_buff *skb,
+		struct netlink_callback *cb)
+{
+	int wp_idx = 0;
+	int if_idx = 0;
+	int sta_idx = cb->args[2];
+	int wp_start = cb->args[0];
+	int if_start = cb->args[1];
+	struct station_info sinfo;
+	struct cfg80211_registered_device *dev;
+	struct wireless_dev *wdev;
+	u8 mac_addr[ETH_ALEN];
+	int err;
+	int exit = 0;
+
+	/* TODO: filter by device */
+	mutex_lock(&cfg80211_drv_mutex);
+	list_for_each_entry(dev, &cfg80211_drv_list, list) {
+		if (exit)
+			break;
+		if (++wp_idx < wp_start)
+			continue;
+		if_idx = 0;
+
+		mutex_lock(&dev->devlist_mtx);
+		list_for_each_entry(wdev, &dev->netdev_list, list) {
+			if (exit)
+				break;
+			if (++if_idx < if_start)
+				continue;
+			if (!dev->ops->dump_station)
+				continue;
+
+			for (;; ++sta_idx) {
+				rtnl_lock();
+				err = dev->ops->dump_station(&dev->wiphy,
+						wdev->netdev, sta_idx, mac_addr,
+						&sinfo);
+				rtnl_unlock();
+				if (err) {
+					sta_idx = 0;
+					break;
+				}
+				if (nl80211_send_station(skb,
+						NETLINK_CB(cb->skb).pid,
+						cb->nlh->nlmsg_seq, NLM_F_MULTI,
+						wdev->netdev, mac_addr,
+						&sinfo) < 0) {
+					exit = 1;
+					break;
+				}
+			}
+		}
+		mutex_unlock(&dev->devlist_mtx);
+	}
+	mutex_unlock(&cfg80211_drv_mutex);
+
+	cb->args[0] = wp_idx;
+	cb->args[1] = if_idx;
+	cb->args[2] = sta_idx;
+
+	return skb->len;
+}
 
 static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
 	int err;
 	struct net_device *dev;
-	struct station_stats stats;
+	struct station_info sinfo;
 	struct sk_buff *msg;
 	u8 *mac_addr = NULL;
 
-	memset(&stats, 0, sizeof(stats));
+	memset(&sinfo, 0, sizeof(sinfo));
 
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
@@ -926,15 +1021,18 @@ static int nl80211_get_station(struct sk
 	}
 
 	rtnl_lock();
-	err = drv->ops->get_station(&drv->wiphy, dev, mac_addr, &stats);
+	err = drv->ops->get_station(&drv->wiphy, dev, mac_addr, &sinfo);
 	rtnl_unlock();
 
+	if (err)
+		goto out;
+
 	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!msg)
 		goto out;
 
 	if (nl80211_send_station(msg, info->snd_pid, info->snd_seq, 0,
-				 dev, mac_addr, &stats) < 0)
+				 dev, mac_addr, &sinfo) < 0)
 		goto out_free;
 
 	err = genlmsg_unicast(msg, info->snd_pid);
@@ -1005,6 +1103,10 @@ static int nl80211_set_station(struct sk
 				&params.station_flags))
 		return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION])
+		params.plink_action =
+		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
+
 	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
 	if (err)
 		return err;
@@ -1119,6 +1221,273 @@ static int nl80211_del_station(struct sk
 	return err;
 }
 
+static int nl80211_send_mpath(struct sk_buff *msg, u32 pid, u32 seq,
+				int flags, struct net_device *dev,
+				u8 *dst, u8 *next_hop,
+				struct mpath_info *pinfo)
+{
+	void *hdr;
+	struct nlattr *pinfoattr;
+
+	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
+	if (!hdr)
+		return -1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, dst);
+	NLA_PUT(msg, NL80211_ATTR_MPATH_NEXT_HOP, ETH_ALEN, next_hop);
+
+	pinfoattr = nla_nest_start(msg, NL80211_ATTR_MPATH_INFO);
+	if (!pinfoattr)
+		goto nla_put_failure;
+	if (pinfo->filled & MPATH_INFO_FRAME_QLEN)
+		NLA_PUT_U32(msg, NL80211_MPATH_INFO_FRAME_QLEN,
+			    pinfo->frame_qlen);
+	if (pinfo->filled & MPATH_INFO_DSN)
+		NLA_PUT_U32(msg, NL80211_MPATH_INFO_DSN,
+			    pinfo->dsn);
+	if (pinfo->filled & MPATH_INFO_METRIC)
+		NLA_PUT_U32(msg, NL80211_MPATH_INFO_METRIC,
+			    pinfo->metric);
+	if (pinfo->filled & MPATH_INFO_EXPTIME)
+		NLA_PUT_U32(msg, NL80211_MPATH_INFO_EXPTIME,
+			    pinfo->exptime);
+	if (pinfo->filled & MPATH_INFO_FLAGS)
+		NLA_PUT_U8(msg, NL80211_MPATH_INFO_FLAGS,
+			    pinfo->flags);
+	if (pinfo->filled & MPATH_INFO_DISCOVERY_TIMEOUT)
+		NLA_PUT_U32(msg, NL80211_MPATH_INFO_DISCOVERY_TIMEOUT,
+			    pinfo->discovery_timeout);
+	if (pinfo->filled & MPATH_INFO_DISCOVERY_RETRIES)
+		NLA_PUT_U8(msg, NL80211_MPATH_INFO_DISCOVERY_RETRIES,
+			    pinfo->discovery_retries);
+
+	nla_nest_end(msg, pinfoattr);
+
+	return genlmsg_end(msg, hdr);
+
+ nla_put_failure:
+	return genlmsg_cancel(msg, hdr);
+}
+
+static int nl80211_dump_mpath(struct sk_buff *skb,
+		struct netlink_callback *cb)
+{
+	int wp_idx = 0;
+	int if_idx = 0;
+	int sta_idx = cb->args[2];
+	int wp_start = cb->args[0];
+	int if_start = cb->args[1];
+	struct mpath_info pinfo;
+	struct cfg80211_registered_device *dev;
+	struct wireless_dev *wdev;
+	u8 dst[ETH_ALEN];
+	u8 next_hop[ETH_ALEN];
+	int err;
+	int exit = 0;
+
+	/* TODO: filter by device */
+	mutex_lock(&cfg80211_drv_mutex);
+	list_for_each_entry(dev, &cfg80211_drv_list, list) {
+		if (exit)
+			break;
+		if (++wp_idx < wp_start)
+			continue;
+		if_idx = 0;
+
+		mutex_lock(&dev->devlist_mtx);
+		list_for_each_entry(wdev, &dev->netdev_list, list) {
+			if (exit)
+				break;
+			if (++if_idx < if_start)
+				continue;
+			if (!dev->ops->dump_mpath)
+				continue;
+
+			for (;; ++sta_idx) {
+				rtnl_lock();
+				err = dev->ops->dump_mpath(&dev->wiphy,
+						wdev->netdev, sta_idx, dst,
+						next_hop, &pinfo);
+				rtnl_unlock();
+				if (err) {
+					sta_idx = 0;
+					break;
+				}
+				if (nl80211_send_mpath(skb,
+						NETLINK_CB(cb->skb).pid,
+						cb->nlh->nlmsg_seq, NLM_F_MULTI,
+						wdev->netdev, dst, next_hop,
+						&pinfo) < 0) {
+					exit = 1;
+					break;
+				}
+			}
+		}
+		mutex_unlock(&dev->devlist_mtx);
+	}
+	mutex_unlock(&cfg80211_drv_mutex);
+
+	cb->args[0] = wp_idx;
+	cb->args[1] = if_idx;
+	cb->args[2] = sta_idx;
+
+	return skb->len;
+}
+
+static int nl80211_get_mpath(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	struct mpath_info pinfo;
+	struct sk_buff *msg;
+	u8 *dst = NULL;
+	u8 next_hop[ETH_ALEN];
+
+	memset(&pinfo, 0, sizeof(pinfo));
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	dst = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->get_mpath) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->get_mpath(&drv->wiphy, dev, dst, next_hop, &pinfo);
+	rtnl_unlock();
+
+	if (err)
+		goto out;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		goto out;
+
+	if (nl80211_send_mpath(msg, info->snd_pid, info->snd_seq, 0,
+				 dev, dst, next_hop, &pinfo) < 0)
+		goto out_free;
+
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto out;
+
+ out_free:
+	nlmsg_free(msg);
+
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_set_mpath(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	u8 *dst = NULL;
+	u8 *next_hop = NULL;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_MPATH_NEXT_HOP])
+		return -EINVAL;
+
+	dst = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	next_hop = nla_data(info->attrs[NL80211_ATTR_MPATH_NEXT_HOP]);
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->change_mpath) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->change_mpath(&drv->wiphy, dev, dst, next_hop);
+	rtnl_unlock();
+
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+static int nl80211_new_mpath(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	u8 *dst = NULL;
+	u8 *next_hop = NULL;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_MPATH_NEXT_HOP])
+		return -EINVAL;
+
+	dst = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	next_hop = nla_data(info->attrs[NL80211_ATTR_MPATH_NEXT_HOP]);
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->add_mpath) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->add_mpath(&drv->wiphy, dev, dst, next_hop);
+	rtnl_unlock();
+
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_del_mpath(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	u8 *dst = NULL;
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		dst = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->del_mpath) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->del_mpath(&drv->wiphy, dev, dst);
+	rtnl_unlock();
+
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -1203,7 +1572,7 @@ static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_STATION,
 		.doit = nl80211_get_station,
-		/* TODO: implement dumpit */
+		.dumpit = nl80211_dump_station,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
@@ -1225,6 +1594,31 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_GET_MPATH,
+		.doit = nl80211_get_mpath,
+		.dumpit = nl80211_dump_mpath,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_SET_MPATH,
+		.doit = nl80211_set_mpath,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_NEW_MPATH,
+		.doit = nl80211_new_mpath,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_DEL_MPATH,
+		.doit = nl80211_del_mpath,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 /* multicast groups */
--- everything.orig/net/mac80211/cfg.c	2008-02-23 14:47:07.000000000 +0100
+++ everything/net/mac80211/cfg.c	2008-02-23 14:47:16.000000000 +0100
@@ -34,7 +34,8 @@ nl80211_type_to_mac80211_type(enum nl802
 }
 
 static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
-			       enum nl80211_iftype type, u32 *flags)
+			       enum nl80211_iftype type, u32 *flags,
+			       struct vif_params *params)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	enum ieee80211_if_types itype;
@@ -78,7 +79,8 @@ static int ieee80211_del_iface(struct wi
 }
 
 static int ieee80211_change_iface(struct wiphy *wiphy, int ifindex,
-				  enum nl80211_iftype type, u32 *flags)
+				  enum nl80211_iftype type, u32 *flags,
+				  struct vif_params *params)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct net_device *dev;
@@ -285,7 +287,7 @@ static int ieee80211_config_default_key(
 }
 
 static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
-				 u8 *mac, struct station_stats *stats)
+				 u8 *mac, struct station_info *sinfo)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
@@ -296,13 +298,13 @@ static int ieee80211_get_station(struct 
 
 	/* XXX: verify sta->dev == dev */
 
-	stats->filled = STATION_STAT_INACTIVE_TIME |
-			STATION_STAT_RX_BYTES |
-			STATION_STAT_TX_BYTES;
-
-	stats->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
-	stats->rx_bytes = sta->rx_bytes;
-	stats->tx_bytes = sta->tx_bytes;
+	sinfo->filled = STATION_INFO_INACTIVE_TIME |
+			STATION_INFO_RX_BYTES |
+			STATION_INFO_TX_BYTES;
+
+	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
+	sinfo->rx_bytes = sta->rx_bytes;
+	sinfo->tx_bytes = sta->tx_bytes;
 
 	sta_info_put(sta);
 

-- 

