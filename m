Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38951 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab2LMN7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 08:59:06 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 6/8] nl80211/cfg80211: add ap channel switch command
Date: Thu, 13 Dec 2012 14:58:31 +0100
Message-Id: <1355407113-27006-7-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121213_145933_467910_AB8374FD)
In-Reply-To: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

Add NL80211_CMD_AP_CH_SWITCH command which
triggers an AP channel switch process.

Usermode notified about channel switch complete
event with NL80211_CMD_CH_SWITCH_NOTIFY.

Usermode (hostapd) is responsible to update the
channel switch announcement IE in the beacon
prior and after the channel switch operation.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
[Changes:
 * change to chandef
 * stop ap when moving to a DFS channel
 * document channel switch new behaviour
 * rebase on current master]
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/net/cfg80211.h       |   38 +++++++++++++++++++++++-
 include/uapi/linux/nl80211.h |   29 ++++++++++++++++++
 net/wireless/mlme.c          |    8 +++--
 net/wireless/nl80211.c       |   67 ++++++++++++++++++++++++++++++++++++++++--
 net/wireless/nl80211.h       |    3 +-
 5 files changed, 139 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3740b57..7cfa08d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -331,6 +331,36 @@ struct cfg80211_chan_def {
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
+ * @chandef: the new channel to switch to
+ * @count: the number of TBTT's until the channel switch event
+ */
+struct ieee80211_ap_ch_switch {
+	u64 timestamp;
+	bool block_tx;
+	bool post_switch_block_tx;
+	struct cfg80211_chan_def chandef;
+	u8 count;
+};
+
+
+
+/**
  * cfg80211_get_chandef_type - return old channel type from chandef
  * @chandef: the channel definition
  *
@@ -1773,6 +1803,7 @@ struct cfg80211_gtk_rekey_data {
  * @stop_p2p_device: Stop the given P2P device.
  *
  * @start_radar_detection: Start radar detection in the driver.
+ * @ap_channel_switch: Perform AP channel switch.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1997,6 +2028,9 @@ struct cfg80211_ops {
 	int	(*start_radar_detection)(struct wiphy *wiphy,
 					 struct net_device *dev,
 					 struct cfg80211_chan_def *chandef);
+	int	(*ap_channel_switch)(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     struct ieee80211_ap_ch_switch *ap_ch_sw);
 };
 
 /*
@@ -3723,11 +3757,13 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
  * cfg80211_ch_switch_notify - update wdev channel and notify userspace
  * @dev: the device which switched channels
  * @chandef: the new channel definition
+ * @stop_ap: stop the access point
  *
  * Acquires wdev_lock, so must only be called from sleepable driver context!
  */
 void cfg80211_ch_switch_notify(struct net_device *dev,
-			       struct cfg80211_chan_def *chandef);
+			       struct cfg80211_chan_def *chandef,
+			       bool stop_ap);
 
 /*
  * cfg80211_tdls_oper_request - request userspace to perform TDLS operation
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2303f86..7a98735 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -589,6 +589,21 @@
  * @NL80211_CMD_RADAR_DETECT: Start radar detection in the driver/HW. Once
  *	radar detected usermode notified with this event.
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
+ *	If the target channel is a DFS channel, the AP will be stopped (stop_ap)
+ *	and NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX will be sent back with the
+ *	%NL80211_CMD_CH_SWITCH_NOTIFY event to reflect this. Userspace may then
+ *	start another Channel Availability Check (CAC) to use the new channel.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -740,6 +755,7 @@ enum nl80211_commands {
 	NL80211_CMD_SET_MCAST_RATE,
 
 	NL80211_CMD_RADAR_DETECT,
+	NL80211_CMD_AP_CH_SWITCH,
 
 	/* add new commands above here */
 
@@ -1314,6 +1330,14 @@ enum nl80211_commands {
  *	START_AP and SET_BSS commands. This can have the values 0 or 1;
  *	if not given in START_AP 0 is assumed, if not given in SET_BSS
  *	no change is made.
+ * @NL80211_ATTR_CH_SWITCH_COUNT: u32 attribute specifying the number of TBTT's
+ *	until the channel switch event.
+ * @NL80211_ATTR_CH_SWITCH_BLOCK_TX: flag attribute specifying that transmission
+ *	must be blocked on the current channel (before the channel switch
+ *	operation).
+ * @NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX: flag attribute specifying that
+ *	transmission must be blocked on the target channel after the channel
+ *	switch operation, should be set if the target channel is DFS channel.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1585,6 +1609,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_P2P_CTWINDOW,
 	NL80211_ATTR_P2P_OPPPS,
 
+	NL80211_ATTR_CH_SWITCH_COUNT,
+	NL80211_ATTR_CH_SWITCH_BLOCK_TX,
+	NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3165,6 +3193,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_P2P_GO_CTWIN			= 1 << 11,
 	NL80211_FEATURE_P2P_GO_OPPPS			= 1 << 12,
 	NL80211_FEATURE_20MHZ_DFS			= 1 << 13,
+	NL80211_FEATURE_AP_CH_SWITCH			= 1 << 14,
 };
 
 /**
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 02666e3..8cdbdd0e 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -989,7 +989,8 @@ void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
 EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
 
 void cfg80211_ch_switch_notify(struct net_device *dev,
-			       struct cfg80211_chan_def *chandef)
+			       struct cfg80211_chan_def *chandef,
+			       bool stop_ap)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -997,6 +998,9 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 
 	trace_cfg80211_ch_switch_notify(dev, chandef);
 
+	if (stop_ap)
+		cfg80211_stop_ap(rdev, dev);
+
 	wdev_lock(wdev);
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
@@ -1004,7 +1008,7 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 		goto out;
 
 	wdev->channel = chandef->chan;
-	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL);
+	nl80211_ch_switch_notify(rdev, dev, chandef, stop_ap, GFP_KERNEL);
 out:
 	wdev_unlock(wdev);
 	return;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d49c0c2..898d829 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -365,6 +365,9 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
 	[NL80211_ATTR_P2P_CTWINDOW] = { .type = NLA_U8 },
 	[NL80211_ATTR_P2P_OPPPS] = { .type = NLA_U8 },
+	[NL80211_ATTR_CH_SWITCH_COUNT] = { .type = NLA_U32 },
+	[NL80211_ATTR_CH_SWITCH_BLOCK_TX] = { .type = NLA_FLAG },
+	[NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -4811,7 +4814,8 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct cfg80211_chan_def chandef;
 	int err;
 
-	if (!(rdev->wiphy.features & NL80211_FEATURE_20MHZ_DFS))
+	if (!(rdev->wiphy.features & NL80211_FEATURE_20MHZ_DFS) ||
+	    !(rdev->wiphy.features & NL80211_FEATURE_AP_CH_SWITCH))
 		return -EOPNOTSUPP;
 
 	err = nl80211_parse_chandef(rdev, info, &chandef);
@@ -4853,6 +4857,51 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_ap_channel_switch(struct sk_buff *skb,
+				     struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct ieee80211_ap_ch_switch ap_ch_sw;
+	int err;
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
+	err = nl80211_parse_chandef(rdev, info, &ap_ch_sw.chandef);
+	if (err)
+		return err;
+
+	/* DFS is currently supported for 20 MHz only. */
+	if (ap_ch_sw.chandef.width > NL80211_CHAN_WIDTH_20)
+		return -EOPNOTSUPP;
+
+	if (!ap_ch_sw.chandef.chan ||
+	    ap_ch_sw.chandef.chan->flags & IEEE80211_CHAN_DISABLED)
+		return -EINVAL;
+
+	ap_ch_sw.count = nla_get_u32(info->attrs[NL80211_ATTR_CH_SWITCH_COUNT]);
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
@@ -7844,6 +7893,14 @@ static struct genl_ops nl80211_ops[] = {
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
@@ -8958,7 +9015,8 @@ void nl80211_pmksa_candidate_notify(struct cfg80211_registered_device *rdev,
 
 void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 			      struct net_device *netdev,
-			      struct cfg80211_chan_def *chandef, gfp_t gfp)
+			      struct cfg80211_chan_def *chandef,
+			      bool ap_stopped, gfp_t gfp)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -8979,6 +9037,11 @@ void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 	if (nl80211_send_chandef(msg, chandef))
 		goto nla_put_failure;
 
+	if (ap_stopped &&
+	    nla_put_flag(msg, NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX))
+		goto nla_put_failure;
+
+
 	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 28b9a34..68ac459 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -134,7 +134,8 @@ void nl80211_pmksa_candidate_notify(struct cfg80211_registered_device *rdev,
 
 void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 			      struct net_device *dev,
-			      struct cfg80211_chan_def *chandef, gfp_t gfp);
+			      struct cfg80211_chan_def *chandef,
+			      bool ap_stopped, gfp_t gfp);
 
 bool nl80211_unexpected_frame(struct net_device *dev,
 			      const u8 *addr, gfp_t gfp);
-- 
1.7.10.4

