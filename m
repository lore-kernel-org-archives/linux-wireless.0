Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34479 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab2JNOzu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 10:55:50 -0400
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v4 5/6] nl80211/cfg80211: add ap channel switch command
Date: Sun, 14 Oct 2012 16:48:56 +0200
Message-ID: <1350226137-13704-6-git-send-email-victorg@ti.com> (sfid-20121014_165559_322459_33664E19)
In-Reply-To: <1350226137-13704-1-git-send-email-victorg@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
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
 include/linux/nl80211.h |   27 ++++++++++++++++++++
 include/net/cfg80211.h  |   36 +++++++++++++++++++++++++++
 net/wireless/nl80211.c  |   62 +++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index ee3336c..0538300 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -590,6 +590,17 @@
  *	the time passed since the beginning of the CAC is less than
  *	NL80211_DFS_MIN_CAC_TIME_MS, -EPERM is returned.
  *
+ * @NL80211_CMD_AP_CH_SWITCH: Perform a channel switch in the driver (for
+ *	AP/GO). Userspace daemon is responsible to update the CSA IE in the
+ *	beacon prior and after the channel switch operation. Userspace notified
+ *	about channel switch complete event with %NL80211_CMD_CH_SWITCH_NOTIFY.
+ *	%NL80211_ATTR_WIPHY_FREQ is used to specify the new channel frequency.
+ *	%NL80211_ATTR_CH_SWITCH_BLOCK_TX is used to specify that tx must be
+ *	blocked on the current channel. %NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX
+ *	is used to specify that tx must be blocked on the target channel.
+ *	%NL80211_FREQ_ATTR_CH_SWITCH_COUNT to specify the number of TBTT's until
+ *	the device switches to the target channel.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -742,6 +753,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_DFS_ENABLE_TX,
 
+	NL80211_CMD_AP_CH_SWITCH,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1289,6 +1302,15 @@ enum nl80211_commands {
  *	the connection request from a station. nl80211_connect_failed_reason
  *	enum has different reasons of connection failure.
  *
+ * @NL80211_ATTR_CH_SWITCH_COUNT: u32 attribute specifying the number of TBTT's
+ *	until the channel switch event.
+ * @NL80211_ATTR_CH_SWITCH_BLOCK_TX: flag attribute specifying that transmission
+ *	must be blocked on the current channel (before the channel switch
+ *	operation).
+ * @NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX: flag attribute specifying that
+ *	transmission must be blocked on the target channel after the channel
+ *	switch operation, should be set if the target channel is DFS channel.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1546,6 +1568,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_CONN_FAILED_REASON,
 
+	NL80211_ATTR_CH_SWITCH_COUNT,
+	NL80211_ATTR_CH_SWITCH_BLOCK_TX,
+	NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3056,6 +3082,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_CELL_BASE_REG_HINTS		= 1 << 3,
 	NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL	= 1 << 4,
 	NL80211_FEATURE_20MHZ_DFS			= 1 << 5,
+	NL80211_FEATURE_AP_CH_SWITCH			= 1 << 6,
 };
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f2d4bde..ceff832 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -154,6 +154,36 @@ struct ieee80211_channel {
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
+ *	scheduled channel switch, setting this flag will rise Channel Switch
+ *	Mode bit in the AP CSA IE which means that all STAs in a BSS shall
+ *	stop transmitting immediately.
+ * @post_switch_block_tx: Indicates whether the AP transmission must be blocked
+ *	after the scheduled channel switch, this should be set if the target
+ *	channel is DFS channel.
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
@@ -1633,6 +1663,8 @@ struct cfg80211_gtk_rekey_data {
  * @start_radar_detection: Start radar detection in the driver.
  *
  * @dfs_en_tx: Enable tx after radar interference check.
+ *
+ * @ap_channel_switch: Perform AP channel switch.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1860,6 +1892,10 @@ struct cfg80211_ops {
 
 	int	(*dfs_en_tx)(struct wiphy *wiphy, struct net_device *dev,
 			     struct ieee80211_channel *chan);
+
+	int	(*ap_channel_switch)(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     struct ieee80211_ap_ch_switch *ap_ch_sw);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index be4e160..a40e81e 100644
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
@@ -4614,7 +4617,8 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct ieee80211_channel *chan;
 	enum nl80211_channel_type cac_type;
 
-	if (!(rdev->wiphy.features & NL80211_FEATURE_20MHZ_DFS))
+	if (!(rdev->wiphy.features & NL80211_FEATURE_20MHZ_DFS) ||
+	    !(rdev->wiphy.features & NL80211_FEATURE_AP_CH_SWITCH))
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
@@ -4656,7 +4660,8 @@ static int nl80211_dfs_en_tx(struct sk_buff *skb, struct genl_info *info)
 	int freq;
 
 	if (!rdev->ops->dfs_en_tx ||
-	    !(rdev->wiphy.features & NL80211_FEATURE_20MHZ_DFS))
+	    !(rdev->wiphy.features & NL80211_FEATURE_20MHZ_DFS) ||
+	    !(rdev->wiphy.features & NL80211_FEATURE_AP_CH_SWITCH))
 		return -EOPNOTSUPP;
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ])
@@ -4677,6 +4682,51 @@ static int nl80211_dfs_en_tx(struct sk_buff *skb, struct genl_info *info)
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
+	if ((ap_ch_sw.channel_type != NL80211_CHAN_HT20) &&
+	    (ap_ch_sw.channel_type != NL80211_CHAN_NO_HT))
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
@@ -7641,6 +7691,14 @@ static struct genl_ops nl80211_ops[] = {
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
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
-- 
1.7.5.4

