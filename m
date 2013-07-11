Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:58573 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab3GKOJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 10:09:17 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 1/4] nl80211/cfg80211: add channel switch command
Date: Thu, 11 Jul 2013 16:09:05 +0200
Message-Id: <1373551749-5107-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130711_160939_726360_C6867A83)
In-Reply-To: <1373551749-5107-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373551749-5107-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To allow channel switch announcements within beacons, add
the channel switch command to nl80211/cfg80211. This is
implementation is intended for AP and (later) IBSS mode.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
Changes to PATCHv4:
 * add tracing
 * rename csa_ies to csa_attrs

Changes to PATCHv2:
 * define csa_ies as static to save stack size
 * add wiphy flag and cmd for channel_switch
 * move NL80211_ATTR_CSA_C_OFF_BEACON into csa_ies

Changes to RFCv1:
 * accept and pass CSA IEs and after-change IEs
 * use parameter structure instead of individual parameters
---
 include/net/cfg80211.h       |   30 ++++++++++
 include/uapi/linux/nl80211.h |   29 ++++++++++
 net/wireless/nl80211.c       |  124 +++++++++++++++++++++++++++++++++++++++++-
 net/wireless/rdev-ops.h      |   12 ++++
 net/wireless/trace.h         |   33 +++++++++++
 5 files changed, 227 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index aeaf6df..9aa7918 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -666,6 +666,30 @@ struct cfg80211_ap_settings {
 };
 
 /**
+ * struct cfg80211_csa_settings - channel switch settings
+ *
+ * Used for channel switch
+ *
+ * @chandef: defines the channel to use after the switch
+ * @beacon_csa: beacon data while performing the switch
+ * @counter_offset_beacon: offset for the counter within the beacon (tail)
+ * @counter_offset_presp: offset for the counter within the probe response
+ * @beacon_after: beacon data to be used on the new channel
+ * @radar_required: whether radar detection is required on the new channel
+ * @block_tx: whether transmissions should be blocked while changing
+ * @count: number of beacons until switch
+ */
+struct cfg80211_csa_settings {
+	struct cfg80211_chan_def chandef;
+	struct cfg80211_beacon_data beacon_csa;
+	u16 counter_offset_beacon, counter_offset_presp;
+	struct cfg80211_beacon_data beacon_after;
+	bool radar_required;
+	bool block_tx;
+	u8 count;
+};
+
+/**
  * enum station_parameters_apply_mask - station parameter values to apply
  * @STATION_PARAM_APPLY_UAPSD: apply new uAPSD parameters (uapsd_queues, max_sp)
  * @STATION_PARAM_APPLY_CAPABILITY: apply new capability
@@ -2376,6 +2400,9 @@ struct cfg80211_ops {
 				   struct wireless_dev *wdev);
 	int	(*set_coalesce)(struct wiphy *wiphy,
 				struct cfg80211_coalesce *coalesce);
+	int	(*channel_switch)(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  struct cfg80211_csa_settings *params);
 };
 
 /*
@@ -2441,6 +2468,8 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
  * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
  * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
+ * @WIPHY_FLAG_HAS_CHANNEL_SWITCH: Device supports channel switch in
+ *	beaconing mode (AP, IBSS, Mesh, ...).
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -2465,6 +2494,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
+	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index eb68735..8d07ee0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -676,6 +676,16 @@
  * @NL80211_CMD_GET_COALESCE: Get currently supported coalesce rules.
  * @NL80211_CMD_SET_COALESCE: Configure coalesce rules or clear existing rules.
  *
+ * @NL80211_CMD_CHANNEL_SWITCH: Perform a channel switch by announcing the
+ *	the new channel information (Channel Switch Announcement - CSA)
+ *	in the beacon for some time (as defined in the
+ *	%NL80211_ATTR_CH_SWITCH_COUNT parameter) and then change to the
+ *	new channel. Userspace provides the new channel information (using
+ *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel
+ *	width). %NL80211_ATTR_CH_SWITCH_BLOCK_TX may be supplied to inform
+ *	other station that transmission must be blocked until the channel
+ *	switch is complete.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -841,6 +851,7 @@ enum nl80211_commands {
 	NL80211_CMD_GET_COALESCE,
 	NL80211_CMD_SET_COALESCE,
 
+	NL80211_CMD_CHANNEL_SWITCH,
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1469,6 +1480,18 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_COALESCE_RULE: Coalesce rule information.
  *
+ * @NL80211_ATTR_CH_SWITCH_COUNT: u32 attribute specifying the number of TBTT's
+ *	until the channel switch event.
+ * @NL80211_ATTR_CH_SWITCH_BLOCK_TX: flag attribute specifying that transmission
+ *	must be blocked on the current channel (before the channel switch
+ *	operation).
+ * @NL80211_ATTR_CSA_IES: Nested set of attributes containing the IE information
+ *	for the time while performing a channel switch.
+ * @NL80211_ATTR_CSA_C_OFF_BEACON: Offset of the channel switch counter
+ *	field in the beacons tail (%NL80211_ATTR_BEACON_TAIL).
+ * @NL80211_ATTR_CSA_C_OFF_PRESP: Offset of the channel switch counter
+ *	field in the probe response (%NL80211_ATTR_PROBE_RESP).
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1771,6 +1794,12 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_COALESCE_RULE,
 
+	NL80211_ATTR_CH_SWITCH_COUNT,
+	NL80211_ATTR_CH_SWITCH_BLOCK_TX,
+	NL80211_ATTR_CSA_IES,
+	NL80211_ATTR_CSA_C_OFF_BEACON,
+	NL80211_ATTR_CSA_C_OFF_PRESP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a9444cd..f08b058 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -349,6 +349,11 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_IE_RIC] = { .type = NLA_BINARY,
 				  .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_PEER_AID] = { .type = NLA_U16 },
+	[NL80211_ATTR_CH_SWITCH_COUNT] = { .type = NLA_U32 },
+	[NL80211_ATTR_CH_SWITCH_BLOCK_TX] = { .type = NLA_FLAG },
+	[NL80211_ATTR_CSA_IES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_CSA_C_OFF_BEACON] = { .type = NLA_U16 },
+	[NL80211_ATTR_CSA_C_OFF_PRESP] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -1422,6 +1427,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		if (state->split) {
 			CMD(crit_proto_start, CRIT_PROTOCOL_START);
 			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
+			if (dev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH)
+				CMD(channel_switch, CHANNEL_SWITCH);
 		}
 
 #ifdef CONFIG_NL80211_TESTMODE
@@ -5611,6 +5618,113 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_channel_switch(struct sk_buff *skb,
+				  struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_csa_settings params;
+	/* csa_attrs is defined static to avoid waste of stack size - this
+	 * function is called under RTNL lock, so this should not be a problem.
+	 */
+	static struct nlattr *csa_attrs[NL80211_ATTR_MAX+1];
+	u8 radar_detect_width = 0;
+	int err;
+
+	if (!rdev->ops->channel_switch ||
+	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH))
+		return -EOPNOTSUPP;
+
+	/* may add IBSS support later */
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	memset(&params, 0, sizeof(params));
+
+	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
+	    !info->attrs[NL80211_ATTR_CH_SWITCH_COUNT])
+		return -EINVAL;
+
+	/* only important for AP, IBSS and mesh create IEs internally */
+	if (!info->attrs[NL80211_ATTR_CSA_IES])
+		return -EINVAL;
+
+	/* useless if AP is not running */
+	if (!wdev->beacon_interval)
+		return -EINVAL;
+
+	params.count = nla_get_u32(info->attrs[NL80211_ATTR_CH_SWITCH_COUNT]);
+
+	err = nl80211_parse_beacon(info->attrs, &params.beacon_after);
+	if (err)
+		return err;
+
+	err = nla_parse_nested(csa_attrs, NL80211_ATTR_MAX,
+			       info->attrs[NL80211_ATTR_CSA_IES],
+			       nl80211_policy);
+	if (err)
+		return err;
+
+	err = nl80211_parse_beacon(csa_attrs, &params.beacon_csa);
+	if (err)
+		return err;
+
+	if (!csa_attrs[NL80211_ATTR_CSA_C_OFF_BEACON])
+		return -EINVAL;
+
+	params.counter_offset_beacon =
+		nla_get_u16(csa_attrs[NL80211_ATTR_CSA_C_OFF_BEACON]);
+	if (params.counter_offset_beacon > params.beacon_csa.tail_len)
+		return -EINVAL;
+
+	/* sanity check - counters should be the same */
+	if (params.beacon_csa.tail[params.counter_offset_beacon] !=
+	    params.count)
+		return -EINVAL;
+
+	if (csa_attrs[NL80211_ATTR_CSA_C_OFF_PRESP]) {
+		params.counter_offset_presp =
+			nla_get_u16(csa_attrs[NL80211_ATTR_CSA_C_OFF_PRESP]);
+		if (params.counter_offset_presp >
+		    params.beacon_csa.probe_resp_len)
+			return -EINVAL;
+
+		if (params.beacon_csa.probe_resp[params.counter_offset_presp] !=
+		    params.count)
+			return -EINVAL;
+	}
+
+	err = nl80211_parse_chandef(rdev, info, &params.chandef);
+	if (err)
+		return err;
+
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
+		return -EINVAL;
+
+	err = cfg80211_chandef_dfs_required(wdev->wiphy, &params.chandef);
+	if (err < 0)
+		return err;
+
+	if (err)
+		radar_detect_width = BIT(params.chandef.width);
+	else
+		radar_detect_width = 0;
+
+	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+					   params.chandef.chan,
+					   CHAN_MODE_SHARED,
+					   radar_detect_width);
+	if (err)
+		return err;
+
+	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
+		params.block_tx = true;
+
+	return rdev_channel_switch(rdev, dev, &params);
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -9359,7 +9473,15 @@ static struct genl_ops nl80211_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
 				  NL80211_FLAG_NEED_RTNL,
-	}
+	},
+	{
+		.cmd = NL80211_CMD_CHANNEL_SWITCH,
+		.doit = nl80211_channel_switch,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 9f15f0a..de870d4 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -923,4 +923,16 @@ static inline void rdev_crit_proto_stop(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int rdev_channel_switch(struct cfg80211_registered_device *rdev,
+				      struct net_device *dev,
+				      struct cfg80211_csa_settings *params)
+{
+	int ret;
+
+	trace_rdev_channel_switch(&rdev->wiphy, dev, params);
+	ret = rdev->ops->channel_switch(&rdev->wiphy, dev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 09af6eb..f0ebdcd 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1841,6 +1841,39 @@ TRACE_EVENT(rdev_crit_proto_stop,
 		  WIPHY_PR_ARG, WDEV_PR_ARG)
 );
 
+TRACE_EVENT(rdev_channel_switch,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_csa_settings *params),
+	TP_ARGS(wiphy, netdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		CHAN_DEF_ENTRY
+		__field(u16, counter_offset_beacon)
+		__field(u16, counter_offset_presp)
+		__field(bool, radar_required)
+		__field(bool, block_tx)
+		__field(u8, count)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		CHAN_DEF_ASSIGN(&params->chandef);
+		__entry->counter_offset_beacon = params->counter_offset_beacon;
+		__entry->counter_offset_presp = params->counter_offset_presp;
+		__entry->radar_required = params->radar_required;
+		__entry->block_tx = params->block_tx;
+		__entry->count = params->count;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " CHAN_DEF_PR_FMT
+		  ", block_tx: %d, count: %u, radar_required: %d"
+		  ", counter offsets (beacon/presp): %u/%u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, CHAN_DEF_PR_ARG,
+		  __entry->block_tx, __entry->count, __entry->radar_required,
+		  __entry->counter_offset_beacon,
+		  __entry->counter_offset_presp)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
1.7.10.4

