Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:35602 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757505Ab2HHMAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:00:37 -0400
Received: by yhjj56 with SMTP id j56so590153yhj.6
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:00:36 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 5/7] nl80211/cfg80211: add ap channel switch command
Date: Wed,  8 Aug 2012 14:53:41 +0300
Message-Id: <1344426823-1795-6-git-send-email-victorg@ti.com> (sfid-20120808_140055_853664_95174EAE)
In-Reply-To: <1344426823-1795-1-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add NL80211_CMD_AP_CH_SWITCH command which
triggers an AP channel switch process.

Usermode notified about channel switch complete
event with NL80211_CMD_CH_SWITCH_NOTIFY.

Usermode (hostapd) is responsible to update the
channel switch announcement IE in the beacon
prior and after the channel switch operation.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/linux/nl80211.h |   24 ++++++++++++++++++++
 include/net/cfg80211.h  |   34 +++++++++++++++++++++++++++++
 net/wireless/nl80211.c  |   55 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 6c2884c..5a193b3 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -565,6 +565,14 @@
  *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ with
  *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE.
  *
+ * @NL80211_CMD_AP_CH_SWITCH: Perform a channel switch in the driver (for
+ *	AP/GO).
+ *	%NL80211_ATTR_WIPHY_FREQ: new channel frequency.
+ *	%NL80211_ATTR_CH_SWITCH_BLOCK_TX: block tx on the current channel.
+ *	%NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX: block tx on the target channel.
+ *	%NL80211_FREQ_ATTR_CH_SWITCH_COUNT: number of TBTT's until the channel
+ *	switch event.
+ *
  * @NL80211_CMD_RADAR_DETECT: Start radar detection in the driver/HW. Once
  *	radar detected usermode notified with this event.
  *
@@ -720,6 +728,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CH_SWITCH_NOTIFY,
 
+	NL80211_CMD_AP_CH_SWITCH,
+
 	NL80211_CMD_RADAR_DETECT,
 
 	NL80211_CMD_DFS_ENABLE_TX,
@@ -1267,6 +1277,14 @@ enum nl80211_commands {
  *	was used to provide the hint. For the different types of
  *	allowed user regulatory hints see nl80211_user_reg_hint_type.
  *
+ * @NL80211_ATTR_CH_SWITCH_COUNT: the number of TBTT's until the channel
+ *	switch event
+ * @NL80211_ATTR_CH_SWITCH_BLOCK_TX: block tx on the current channel before the
+ *	channel switch operation.
+ * @NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX: block tx on the target channel after
+ *	the channel switch operation, should be set if the target channel is
+ *	DFS channel.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1522,6 +1540,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_USER_REG_HINT_TYPE,
 
+	NL80211_ATTR_CH_SWITCH_COUNT,
+	NL80211_ATTR_CH_SWITCH_BLOCK_TX,
+	NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3011,6 +3033,7 @@ enum nl80211_ap_sme_features {
  *	to work properly to suppport receiving regulatory hints from
  *	cellular base stations.
  * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
+ * @NL80211_FEATURE_AP_CH_SWITCH: This driver supports AP channel switch.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
@@ -3018,6 +3041,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_INACTIVITY_TIMER = 1 << 2,
 	NL80211_FEATURE_CELL_BASE_REG_HINTS = 1 << 3,
 	NL80211_FEATURE_DFS		= 1 << 4,
+	NL80211_FEATURE_AP_CH_SWITCH	= 1 << 5,
 };
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3a56601..66c8c9b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -153,6 +153,34 @@ struct ieee80211_channel {
 };
 
 /**
+ * struct ieee80211_ap_ch_switch - holds the ap channel switch data
+ *
+ * The information provided in this structure is required for the ap channel
+ * switch operation.
+ *
+ * @timestamp: value in microseconds of the 64-bit Time Synchronization
+ *	Function (TSF) timer when the frame containing the channel switch
+ *	announcement was received. This is simply the rx.mactime parameter
+ *	the driver passed into mac80211.
+ * @block_tx: Indicates whether transmission must be blocked before the
+ *	scheduled channel switch, as indicated by the AP.
+ * @post_switch_block_tx: Indicates whether transmission must be blocked after
+ *	the scheduled channel switch, this should be set if the target channel
+ *	is DFS channel.
+ * @channel: the new channel to switch to
+ * @channel_type: the type of the new channel
+ * @count: the number of TBTT's until the channel switch event
+ */
+struct ieee80211_ap_ch_switch {
+	u64 timestamp;
+	bool block_tx;
+	bool post_switch_block_tx;
+	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
+	u8 count;
+};
+
+/**
  * enum ieee80211_rate_flags - rate flags
  *
  * Hardware/specification flags for rates. These are structured
@@ -1629,6 +1657,8 @@ struct cfg80211_gtk_rekey_data {
  * @start_radar_detection: Start radar detection in the driver.
  *
  * @dfs_en_tx: Enable tx after radar interference check.
+ *
+ * @ap_channel_switch: Perform AP channel switch.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1852,6 +1882,10 @@ struct cfg80211_ops {
 
 	int	(*dfs_en_tx)(struct wiphy *wiphy, struct net_device *dev,
 			     struct ieee80211_channel *chan);
+
+	int	(*ap_channel_switch)(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     struct ieee80211_ap_ch_switch *ap_ch_sw);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 869d271..14d05d0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -355,6 +355,9 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
 	[NL80211_ATTR_WDEV] = { .type = NLA_U64 },
 	[NL80211_ATTR_USER_REG_HINT_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_CH_SWITCH_COUNT] = { .type = NLA_U32 },
+	[NL80211_ATTR_CH_SWITCH_BLOCK_TX] = { .type = NLA_FLAG },
+	[NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -4644,6 +4647,50 @@ static int nl80211_dfs_en_tx(struct sk_buff *skb, struct genl_info *info)
 	return rdev->ops->dfs_en_tx(&rdev->wiphy, dev, chan);
 }
 
+static int nl80211_ap_channel_switch(struct sk_buff *skb,
+				     struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	u32 freq = 0;
+	struct ieee80211_ap_ch_switch ap_ch_sw;
+
+	if (!rdev->ops->ap_channel_switch)
+		return -EOPNOTSUPP;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_CH_SWITCH_COUNT] ||
+	    !info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
+	    !info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE])
+		return -EINVAL;
+
+	memset(&ap_ch_sw, 0, sizeof(ap_ch_sw));
+
+	ap_ch_sw.channel_type =
+		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+	if (ap_ch_sw.channel_type != NL80211_CHAN_HT20)
+		return -EOPNOTSUPP;
+
+	ap_ch_sw.count = nla_get_u32(info->attrs[NL80211_ATTR_CH_SWITCH_COUNT]);
+	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+
+	ap_ch_sw.channel = ieee80211_get_channel(&rdev->wiphy, freq);
+	if (!ap_ch_sw.channel ||
+	    ap_ch_sw.channel->flags & IEEE80211_CHAN_DISABLED)
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
+		ap_ch_sw.block_tx = true;
+
+	if (info->attrs[NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX])
+		ap_ch_sw.post_switch_block_tx = true;
+
+	return rdev->ops->ap_channel_switch(&rdev->wiphy, dev, &ap_ch_sw);
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -7518,6 +7565,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_AP_CH_SWITCH,
+		.doit = nl80211_ap_channel_switch,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 
 };
 
-- 
1.7.5.4

