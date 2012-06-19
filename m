Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:55920 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129Ab2FSNOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 09:14:41 -0400
Received: by yhp26 with SMTP id 26so4907568yhp.12
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 06:14:40 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v2 5/7] nl80211/cfg80211: add ap channel switch command/event
Date: Tue, 19 Jun 2012 16:11:01 +0300
Message-Id: <1340111463-4554-5-git-send-email-victorg@ti.com> (sfid-20120619_151451_113079_AFF3BB19)
In-Reply-To: <1340111463-4554-1-git-send-email-victorg@ti.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add NL80211_CMD_AP_CHANNEL_SWITCH command/event
which triggers an AP channel switch process and
notifies usermode about channel switch complete
event, once it completed.

Usermode (hostapd) is responsible to update the
channel switch announcement IE in the beacon
prior and after the channel switch operation.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/linux/nl80211.h |   25 ++++++++++++++
 include/net/cfg80211.h  |   17 +++++++++
 net/wireless/mlme.c     |   11 ++++++
 net/wireless/nl80211.c  |   84 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 +++
 5 files changed, 142 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2f869a4..4279507 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -565,6 +565,15 @@
  *	the time passed sines the beginning of the CAC is less than
  *	NL80211_DFS_MIN_CAC_TIME_MS, -EPERM is returned.
  *
+ * @NL80211_CMD_AP_CHANNEL_SWITCH: Perform a channel switch in the driver (for
+ *	AP/GO).
+ *	%NL80211_ATTR_WIPHY_FREQ: new channel frequency.
+ *	%NL80211_ATTR_CH_SWITCH_BLOCK_TX: block tx on the current channel.
+ *	%NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX: block tx on the target channel.
+ *	%NL80211_FREQ_ATTR_CH_SWITCH_COUNT: number of TBTT's until the channel
+ *	switch event.
+ *	This command will also notify about channel switch complete event.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -712,6 +721,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_DFS_ENABLE_TX,
 
+	NL80211_CMD_AP_CHANNEL_SWITCH,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1238,6 +1249,14 @@ enum nl80211_commands {
  * @NL80211_ATTR_BG_SCAN_PERIOD: Background scan period in seconds
  *      or 0 to disable background scan.
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
@@ -1489,6 +1508,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BG_SCAN_PERIOD,
 
+	NL80211_ATTR_CH_SWITCH_COUNT,
+	NL80211_ATTR_CH_SWITCH_BLOCK_TX,
+	NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2884,12 +2907,14 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_INACTIVITY_TIMER: This driver takes care of freeing up
  *	the connected inactive stations in AP mode.
  * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
+ * @NL80211_FEATURE_AP_CH_SWITCH: This driver supports AP channel switch.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
 	NL80211_FEATURE_HT_IBSS		= 1 << 1,
 	NL80211_FEATURE_INACTIVITY_TIMER = 1 << 2,
 	NL80211_FEATURE_DFS		= 1 << 3,
+	NL80211_FEATURE_AP_CH_SWITCH	= 1 << 4,
 };
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f7fe44e..a4994a3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1533,6 +1533,8 @@ struct cfg80211_gtk_rekey_data {
  * @start_radar_detection: Start radar detection in the driver.
  *
  * @dfs_en_tx: Enable tx after radar interference check.
+ *
+ * @ap_channel_switch: Perform AP channel switch.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1745,6 +1747,11 @@ struct cfg80211_ops {
 
 	int	(*dfs_en_tx)(struct wiphy *wiphy, struct net_device *dev,
 			     struct ieee80211_channel *chan);
+
+	int	(*ap_channel_switch)(struct wiphy *wiphy, struct net_device *dev,
+				     u32 count, bool block_tx,
+				     bool post_switch_block_tx,
+				     struct ieee80211_channel *new_ch);
 };
 
 /*
@@ -3293,6 +3300,16 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 void cfg80211_radar_detected(struct net_device *dev, u16 freq, gfp_t gfp);
 
 /**
+ * cfg80211_ap_ch_switch_complete_notify - channel switch complete event
+ * @dev: network device
+ * @gfp: context flags
+ *
+ * Notify userspace about channel switch complete event.
+ */
+void cfg80211_ap_ch_switch_complete_notify(struct net_device *dev,
+					   u16 freq, gfp_t gfp);
+
+/**
  * cfg80211_cqm_pktloss_notify - notify userspace about packetloss to peer
  * @dev: network device
  * @peer: peer's MAC address
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index a641db6..d45c875 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1018,3 +1018,14 @@ void cfg80211_radar_detected(struct net_device *dev, u16 freq, gfp_t gfp)
 	nl80211_radar_detected_notify(rdev, freq, dev, gfp);
 }
 EXPORT_SYMBOL(cfg80211_radar_detected);
+
+void cfg80211_ap_ch_switch_complete_notify(struct net_device *dev,
+					   u16 freq, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_ap_ch_switch_complete_notify(rdev, freq, dev, gfp);
+}
+EXPORT_SYMBOL(cfg80211_ap_ch_switch_complete_notify);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 966f7cc..c09a9b7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -206,6 +206,9 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
 	[NL80211_ATTR_INACTIVITY_TIMEOUT] = { .type = NLA_U16 },
 	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
+	[NL80211_ATTR_CH_SWITCH_COUNT] = { .type = NLA_U32 },
+	[NL80211_ATTR_CH_SWITCH_BLOCK_TX] = { .type = NLA_FLAG },
+	[NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -4301,6 +4304,42 @@ static int nl80211_dfs_en_tx(struct sk_buff *skb, struct genl_info *info)
 	return rdev->ops->dfs_en_tx(&rdev->wiphy, dev, chan);
 }
 
+static int nl80211_ap_channel_switch(struct sk_buff *skb,
+				     struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	u32 freq = 0, count = 0, post_switch_block_tx = 0, block_tx = 0;
+	struct ieee80211_channel *new_ch;
+
+	if (!rdev->ops->ap_channel_switch)
+		return -EOPNOTSUPP;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_CH_SWITCH_COUNT] ||
+	    !info->attrs[NL80211_ATTR_WIPHY_FREQ])
+		return -EINVAL;
+
+	count = nla_get_u32(info->attrs[NL80211_ATTR_CH_SWITCH_COUNT]);
+	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+
+	new_ch = ieee80211_get_channel(&rdev->wiphy, freq);
+	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED)
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
+		block_tx = true;
+
+	if (info->attrs[NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX])
+		post_switch_block_tx = true;
+
+	return rdev->ops->ap_channel_switch(&rdev->wiphy, dev, count, block_tx,
+					    post_switch_block_tx, new_ch);
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -7066,6 +7105,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_AP_CHANNEL_SWITCH,
+		.doit = nl80211_ap_channel_switch,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 
 };
 
@@ -8206,6 +8253,43 @@ nl80211_radar_detected_notify(struct cfg80211_registered_device *rdev,
 }
 
 void
+nl80211_ap_ch_switch_complete_notify(struct cfg80211_registered_device *rdev,
+				     u16 freq, struct net_device *netdev,
+				     gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_AP_CHANNEL_SWITCH);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
+	    nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ, freq))
+		goto nla_put_failure;
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
+void
 nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
 				u32 num_packets, gfp_t gfp)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index a333261..aca0de3 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -111,6 +111,11 @@ nl80211_radar_detected_notify(struct cfg80211_registered_device *rdev,
 			      u16 freq, struct net_device *netdev, gfp_t gfp);
 
 void
+nl80211_ap_ch_switch_complete_notify(struct cfg80211_registered_device *rdev,
+				     u16 freq, struct net_device *netdev,
+				     gfp_t gfp);
+
+void
 nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
 				u32 num_packets, gfp_t gfp);
-- 
1.7.5.4

