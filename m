Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:47978 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3GHNO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 09:14:27 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv3 1/5] nl80211/cfg80211: add channel switch command
Date: Mon,  8 Jul 2013 15:14:06 +0200
Message-Id: <1373289250-12259-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130708_151442_636506_87F50EC9)
In-Reply-To: <1373289250-12259-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373289250-12259-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To allow channel switch announcements within beacons, add
the channel switch command to nl80211/cfg80211. This is
implementation is intended for AP and (later) IBSS mode.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
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
 net/wireless/nl80211.c       |  126 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 184 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4940960..249ac42 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -639,6 +639,30 @@ struct cfg80211_ap_settings {
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
@@ -2311,6 +2335,9 @@ struct cfg80211_ops {
 				    u16 duration);
 	void	(*crit_proto_stop)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+	int	(*channel_switch)(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  struct cfg80211_csa_settings *params);
 };
 
 /*
@@ -2376,6 +2403,8 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
  * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
  * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
+ * @WIPHY_FLAG_HAS_CHANNEL_SWITCH_BEACON: Device supports channel switch in
+ *	beaconing mode (AP, IBSS, Mesh, ...).
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -2400,6 +2429,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
+	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index de0ce80..4049cb8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -648,6 +648,16 @@
  * @NL80211_CMD_CRIT_PROTOCOL_STOP: Indicates the connection reliability can
  *	return back to normal.
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
@@ -810,6 +820,7 @@ enum nl80211_commands {
 	NL80211_CMD_CRIT_PROTOCOL_START,
 	NL80211_CMD_CRIT_PROTOCOL_STOP,
 
+	NL80211_CMD_CHANNEL_SWITCH,
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1436,6 +1447,18 @@ enum nl80211_commands {
  *	allowed to be used with the first @NL80211_CMD_SET_STATION command to
  *	update a TDLS peer STA entry.
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
@@ -1736,6 +1759,12 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PEER_AID,
 
+	NL80211_ATTR_CH_SWITCH_COUNT,
+	NL80211_ATTR_CH_SWITCH_BLOCK_TX,
+	NL80211_ATTR_CSA_IES,
+	NL80211_ATTR_CSA_C_OFF_BEACON,
+	NL80211_ATTR_CSA_C_OFF_PRESP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index be64cd4..4e86a56 100644
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
@@ -1393,6 +1398,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		if (state->split) {
 			CMD(crit_proto_start, CRIT_PROTOCOL_START);
 			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
+			if (dev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH)
+				CMD(channel_switch, CHANNEL_SWITCH);
 		}
 
 #ifdef CONFIG_NL80211_TESTMODE
@@ -5576,6 +5583,115 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_channel_switch(struct sk_buff *skb,
+				  struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_csa_settings params;
+	/* csa_ies is defined static to avoid waste of stack size - this
+	 * function is called under RTNL lock, so this should not be a problem.
+	 */
+	static struct nlattr *csa_ies[NL80211_ATTR_MAX+1];
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
+	err = nla_parse_nested(csa_ies, NL80211_ATTR_MAX,
+			       info->attrs[NL80211_ATTR_CSA_IES],
+			       nl80211_policy);
+	if (err)
+		return err;
+
+	err = nl80211_parse_beacon(csa_ies, &params.beacon_csa);
+	if (err)
+		return err;
+
+	if (!csa_ies[NL80211_ATTR_CSA_C_OFF_BEACON])
+		return -EINVAL;
+
+	params.counter_offset_beacon =
+		nla_get_u16(csa_ies[NL80211_ATTR_CSA_C_OFF_BEACON]);
+	if (params.counter_offset_beacon > params.beacon_csa.tail_len)
+		return -EINVAL;
+
+	/* sanity check - counter should be the same this should be the same */
+	if (params.beacon_csa.tail[params.counter_offset_beacon] !=
+	    params.count)
+		return -EINVAL;
+
+	if (csa_ies[NL80211_ATTR_CSA_C_OFF_PRESP]) {
+		params.counter_offset_presp =
+			nla_get_u16(csa_ies[NL80211_ATTR_CSA_C_OFF_PRESP]);
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
+	err = rdev->ops->channel_switch(&rdev->wiphy, dev, &params);
+
+	return err;
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -9048,7 +9164,15 @@ static struct genl_ops nl80211_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
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
-- 
1.7.10.4

