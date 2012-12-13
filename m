Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64316 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab2LMSwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 13:52:14 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1756275pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 10:52:14 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Subject: [PATCH 5/6] {cfg,nl}80211: mesh power mode primitives and userspace access
Date: Thu, 13 Dec 2012 10:51:57 -0800
Message-Id: <1355424718-2982-6-git-send-email-marco@cozybit.com> (sfid-20121213_195223_513936_57DD82A1)
In-Reply-To: <1355424718-2982-1-git-send-email-marco@cozybit.com>
References: <1355424718-2982-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the nl80211_mesh_power_mode enumeration which holds possible values for
the mesh power mode. These modes are unknown, active, light sleep and
deep sleep.

Add power_mode entry to the mesh config structure to hold the user-configured
default mesh power mode. This value will be used for new peer links.

Add the dot11MeshAwakeWindowDuration value to the mesh config. The awake window
is a duration in TU describing how long the STA will stay awake after
transmitting its beacon in PS mode.

Add access routines to:
get/set local link-specific power mode (STA)
get remote STA's link-specific power mode (STA)
get remote STA's non-peer power mode (STA)

get/set default mesh power mode (mesh config)
get/set mesh awake window duration (mesh config)

All config changes may be done at mesh runtime and take effect immediately.

Signed-off-by: Marco Porsch <marco@cozybit.com>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
---
 include/net/cfg80211.h       |   21 +++++++++++++++++++
 include/uapi/linux/nl80211.h |   47 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/mesh.c          |    3 +++
 net/wireless/nl80211.c       |   43 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4e4b1b0..ecafecb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -608,6 +608,8 @@ enum station_parameters_apply_mask {
  * @sta_modify_mask: bitmap indicating which parameters changed
  *	(for those that don't have a natural "no change" value),
  *	see &enum station_parameters_apply_mask
+ * @local_pm: local link-specific mesh power save mode (no change when set
+ *	to unknown)
  */
 struct station_parameters {
 	u8 *supported_rates;
@@ -623,6 +625,7 @@ struct station_parameters {
 	struct ieee80211_vht_cap *vht_capa;
 	u8 uapsd_queues;
 	u8 max_sp;
+	enum nl80211_mesh_power_mode local_pm;
 };
 
 /**
@@ -653,6 +656,9 @@ struct station_parameters {
  * @STATION_INFO_STA_FLAGS: @sta_flags filled
  * @STATION_INFO_BEACON_LOSS_COUNT: @beacon_loss_count filled
  * @STATION_INFO_T_OFFSET: @t_offset filled
+ * @STATION_INFO_LOCAL_PM: @local_pm filled
+ * @STATION_INFO_PEER_PM: @peer_pm filled
+ * @STATION_INFO_NONPEER_PM: @nonpeer_pm filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -676,6 +682,9 @@ enum station_info_flags {
 	STATION_INFO_STA_FLAGS		= 1<<18,
 	STATION_INFO_BEACON_LOSS_COUNT	= 1<<19,
 	STATION_INFO_T_OFFSET		= 1<<20,
+	STATION_INFO_LOCAL_PM		= 1<<21,
+	STATION_INFO_PEER_PM		= 1<<22,
+	STATION_INFO_NONPEER_PM		= 1<<23,
 };
 
 /**
@@ -789,6 +798,9 @@ struct sta_bss_parameters {
  * @sta_flags: station flags mask & values
  * @beacon_loss_count: Number of times beacon loss event has triggered.
  * @t_offset: Time offset of the station relative to this host.
+ * @local_pm: local mesh STA power save mode
+ * @peer_pm: peer mesh STA power save mode
+ * @nonpeer_pm: non-peer mesh STA power save mode
  */
 struct station_info {
 	u32 filled;
@@ -818,6 +830,9 @@ struct station_info {
 
 	u32 beacon_loss_count;
 	s64 t_offset;
+	enum nl80211_mesh_power_mode local_pm;
+	enum nl80211_mesh_power_mode peer_pm;
+	enum nl80211_mesh_power_mode nonpeer_pm;
 
 	/*
 	 * Note: Add a new enum station_info_flags value for each new field and
@@ -993,6 +1008,10 @@ struct bss_parameters {
  * @dot11MeshHWMPconfirmationInterval: The minimum interval of time (in TUs)
  *	during which a mesh STA can send only one Action frame containing
  *	a PREQ element for root path confirmation.
+ * @power_mode: The default mesh power save mode which will be the initial
+ *	setting for new peer links.
+ * @dot11MeshAwakeWindowDuration: The duration in TUs the STA will remain awake
+ *	after transmitting its beacon.
  */
 struct mesh_config {
 	u16 dot11MeshRetryTimeout;
@@ -1020,6 +1039,8 @@ struct mesh_config {
 	u32 dot11MeshHWMPactivePathToRootTimeout;
 	u16 dot11MeshHWMProotInterval;
 	u16 dot11MeshHWMPconfirmationInterval;
+	enum nl80211_mesh_power_mode power_mode;
+	u16 dot11MeshAwakeWindowDuration;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e3e19f8..863fc8e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1310,6 +1310,9 @@ enum nl80211_commands {
  *	if not given in START_AP 0 is assumed, if not given in SET_BSS
  *	no change is made.
  *
+ * @NL80211_ATTR_LOCAL_MESH_POWER_MODE: local mesh STA link-specific power mode
+ *	defined in &enum nl80211_mesh_power_mode.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1580,6 +1583,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_P2P_CTWINDOW,
 	NL80211_ATTR_P2P_OPPPS,
 
+	NL80211_ATTR_LOCAL_MESH_POWER_MODE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1834,6 +1839,10 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_STA_FLAGS: Contains a struct nl80211_sta_flag_update.
  * @NL80211_STA_INFO_BEACON_LOSS: count of times beacon loss was detected (u32)
  * @NL80211_STA_INFO_T_OFFSET: timing offset with respect to this STA (s64)
+ * @NL80211_STA_INFO_LOCAL_PM: local mesh STA link-specific power mode
+ * @NL80211_STA_INFO_PEER_PM: peer mesh STA link-specific power mode
+ * @NL80211_STA_INFO_NONPEER_PM: neighbor mesh STA power save mode towards
+ *	non-peer STA
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1858,6 +1867,9 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_STA_FLAGS,
 	NL80211_STA_INFO_BEACON_LOSS,
 	NL80211_STA_INFO_T_OFFSET,
+	NL80211_STA_INFO_LOCAL_PM,
+	NL80211_STA_INFO_PEER_PM,
+	NL80211_STA_INFO_NONPEER_PM,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -2249,6 +2261,34 @@ enum nl80211_mntr_flags {
 };
 
 /**
+ * enum nl80211_mesh_power_mode - mesh power save modes
+ *
+ * @NL80211_MESH_POWER_UNKNOWN: The mesh power mode of the mesh STA is
+ *	not known or has not been set yet.
+ * @NL80211_MESH_POWER_ACTIVE: Active mesh power mode. The mesh STA is
+ *	in Awake state all the time.
+ * @NL80211_MESH_POWER_LIGHT_SLEEP: Light sleep mode. The mesh STA will
+ *	alternate between Active and Doze states, but will wake up for
+ *	neighbor's beacons.
+ * @NL80211_MESH_POWER_DEEP_SLEEP: Deep sleep mode. The mesh STA will
+ *	alternate between Active and Doze states, but may not wake up
+ *	for neighbor's beacons.
+ *
+ * @__NL80211_MESH_POWER_AFTER_LAST - internal use
+ * @NL80211_MESH_POWER_MAX - highest possible power save level
+ */
+
+enum nl80211_mesh_power_mode {
+	NL80211_MESH_POWER_UNKNOWN,
+	NL80211_MESH_POWER_ACTIVE,
+	NL80211_MESH_POWER_LIGHT_SLEEP,
+	NL80211_MESH_POWER_DEEP_SLEEP,
+
+	__NL80211_MESH_POWER_AFTER_LAST,
+	NL80211_MESH_POWER_MAX = __NL80211_MESH_POWER_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_meshconf_params - mesh configuration parameters
  *
  * Mesh configuration parameters. These can be changed while the mesh is
@@ -2342,6 +2382,11 @@ enum nl80211_mntr_flags {
  *	(in TUs) during which a mesh STA can send only one Action frame
  *	containing a PREQ element for root path confirmation.
  *
+ * @NL80211_MESHCONF_POWER_MODE: Default mesh power mode for new peer links.
+ *	type &enum nl80211_mesh_power_mode (u32)
+ *
+ * @NL80211_MESHCONF_AWAKE_WINDOW: awake window duration (in TUs)
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2371,6 +2416,8 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
 	NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
+	NL80211_MESHCONF_POWER_MODE,
+	NL80211_MESHCONF_AWAKE_WINDOW,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 0fe8ceb..55957a2 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -46,6 +46,7 @@
 
 #define MESH_DEFAULT_BEACON_INTERVAL	1000	/* in 1024 us units (=TUs) */
 #define MESH_DEFAULT_DTIM_PERIOD	2
+#define MESH_DEFAULT_AWAKE_WINDOW	10	/* in 1024 us units (=TUs) */
 
 const struct mesh_config default_mesh_config = {
 	.dot11MeshRetryTimeout = MESH_RET_T,
@@ -72,6 +73,8 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshHWMPactivePathToRootTimeout = MESH_PATH_TO_ROOT_TIMEOUT,
 	.dot11MeshHWMProotInterval = MESH_ROOT_INTERVAL,
 	.dot11MeshHWMPconfirmationInterval = MESH_ROOT_CONFIRMATION_INTERVAL,
+	.power_mode = NL80211_MESH_POWER_ACTIVE,
+	.dot11MeshAwakeWindowDuration = MESH_DEFAULT_AWAKE_WINDOW,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 31fa8cf..2423269 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3001,6 +3001,18 @@ static int nl80211_send_station(struct sk_buff *msg, u32 portid, u32 seq,
 	    nla_put_u32(msg, NL80211_STA_INFO_BEACON_LOSS,
 			sinfo->beacon_loss_count))
 		goto nla_put_failure;
+	if ((sinfo->filled & STATION_INFO_LOCAL_PM) &&
+	    nla_put_u32(msg, NL80211_STA_INFO_LOCAL_PM,
+			sinfo->local_pm))
+		goto nla_put_failure;
+	if ((sinfo->filled & STATION_INFO_PEER_PM) &&
+	    nla_put_u32(msg, NL80211_STA_INFO_PEER_PM,
+			sinfo->peer_pm))
+		goto nla_put_failure;
+	if ((sinfo->filled & STATION_INFO_NONPEER_PM) &&
+	    nla_put_u32(msg, NL80211_STA_INFO_NONPEER_PM,
+			sinfo->nonpeer_pm))
+		goto nla_put_failure;
 	if (sinfo->filled & STATION_INFO_BSS_PARAM) {
 		bss_param = nla_nest_start(msg, NL80211_STA_INFO_BSS_PARAM);
 		if (!bss_param)
@@ -3210,6 +3222,17 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		params.plink_state =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
 
+	if (info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]) {
+		enum nl80211_mesh_power_mode pm = nla_get_u32(
+			info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]);
+
+		if (pm <= NL80211_MESH_POWER_UNKNOWN ||
+		    pm > NL80211_MESH_POWER_MAX)
+			return -EINVAL;
+
+		params.local_pm = pm;
+	}
+
 	switch (dev->ieee80211_ptr->iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
@@ -3217,6 +3240,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		/* disallow mesh-specific things */
 		if (params.plink_action)
 			return -EINVAL;
+		if (params.local_pm)
+			err = -EINVAL;
 
 		/* TDLS can't be set, ... */
 		if (params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
@@ -3259,6 +3284,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 		if (params.listen_interval >= 0)
 			return -EINVAL;
+		if (params.local_pm)
+			err = -EINVAL;
 		/* reject any changes other than AUTHORIZED */
 		if (params.sta_flags_mask & ~BIT(NL80211_STA_FLAG_AUTHORIZED))
 			return -EINVAL;
@@ -3908,7 +3935,11 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 			cur_params.dot11MeshHWMProotInterval) ||
 	    nla_put_u16(msg, NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
-			cur_params.dot11MeshHWMPconfirmationInterval))
+			cur_params.dot11MeshHWMPconfirmationInterval) ||
+	    nla_put_u32(msg, NL80211_MESHCONF_POWER_MODE,
+			cur_params.power_mode) ||
+	    nla_put_u16(msg, NL80211_MESHCONF_AWAKE_WINDOW,
+			cur_params.dot11MeshAwakeWindowDuration))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -3947,6 +3978,8 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_HWMP_ROOT_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_POWER_MODE] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_AWAKE_WINDOW] = { .type = NLA_U16 },
 };
 
 static const struct nla_policy
@@ -4074,6 +4107,14 @@ do { \
 				  1, 65535, mask,
 				  NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, power_mode,
+				  NL80211_MESH_POWER_ACTIVE,
+				  NL80211_MESH_POWER_MAX,
+				  mask, NL80211_MESHCONF_POWER_MODE,
+				  nla_get_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshAwakeWindowDuration,
+				  0, 65535, mask,
+				  NL80211_MESHCONF_AWAKE_WINDOW, nla_get_u16);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.9.5

