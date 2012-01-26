Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:56809 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab2AZMjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:39:32 -0500
Received: by ggnp4 with SMTP id p4so172487ggn.6
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:39:30 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>
Subject: [RFC 5/9] nl80211/cfg80211: add ap channel switch command/event
Date: Thu, 26 Jan 2012 14:38:00 +0200
Message-Id: <1327581484-22047-6-git-send-email-victorg@ti.com> (sfid-20120126_133952_829566_8C4D8D26)
In-Reply-To: <1327581484-22047-1-git-send-email-victorg@ti.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new NL80211_CMD_AP_CHANNEL_SWITCH command which
triggers a channel switch process, this command also
notifies usermode about channel switch complete event.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/linux/nl80211.h |   23 +++++++++++++
 include/net/cfg80211.h  |   16 +++++++++
 net/wireless/mlme.c     |   11 ++++++
 net/wireless/nl80211.c  |   80 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    4 ++
 5 files changed, 134 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index b45ceb1..8a004fc 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -551,6 +551,15 @@
  *	radar interference is detected during this period the dfs master may
  *	initiate the tx.
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
@@ -694,6 +703,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_DFS_ENABLE_TX,
 
+	NL80211_CMD_AP_CHANNEL_SWITCH,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1207,6 +1218,14 @@ enum nl80211_commands {
  * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
  *      up to 16 TIDs.
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
@@ -1452,6 +1471,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_NOACK_MAP,
 
+	NL80211_ATTR_CH_SWITCH_COUNT,
+	NL80211_ATTR_CH_SWITCH_BLOCK_TX,
+	NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fbd5b7a..824883a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1486,6 +1486,8 @@ struct cfg80211_gtk_rekey_data {
  * @set_noack_map: Set the NoAck Map for the TIDs.
  *
  * @dfs_start_radar_detection: Start radar detection in the driver.
+ *
+ * @ap_channel_switch: Perform a channel switch (for AP/GO).
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1688,6 +1690,10 @@ struct cfg80211_ops {
 	int    (*dfs_start_radar_detection)(struct wiphy *wiphy,
 					    struct net_device *dev);
 	int    (*dfs_en_tx)(struct wiphy *wiphy, struct net_device *dev);
+
+	int    (*ap_channel_switch)(struct wiphy *wiphy, struct net_device *dev,
+				    u32 count, bool block_tx,
+				    bool post_switch_block_tx, u32 freq);
 };
 
 /*
@@ -3235,6 +3241,16 @@ void cfg80211_radar_detected_notify(struct net_device *dev,
 				    u16 freq, gfp_t gfp);
 
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
index 6ef723d..c9837a2 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1119,6 +1119,17 @@ void cfg80211_radar_detected_notify(struct net_device *dev, u16 freq, gfp_t gfp)
 }
 EXPORT_SYMBOL(cfg80211_radar_detected_notify);
 
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
+
 void cfg80211_cqm_pktloss_notify(struct net_device *dev,
 				 const u8 *peer, u32 num_packets, gfp_t gfp)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 66dfcef..8fe7e59 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -204,6 +204,9 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 		.len = NL80211_HT_CAPABILITY_LEN
 	},
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
+	[NL80211_ATTR_CH_SWITCH_COUNT] = { .type = NLA_U32 },
+	[NL80211_ATTR_CH_SWITCH_BLOCK_TX] = { .type = NLA_FLAG },
+	[NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -4072,6 +4075,39 @@ static int nl80211_dfs_en_tx(struct sk_buff *skb, struct genl_info *info)
 	return rdev->ops->dfs_en_tx(&rdev->wiphy, dev);
 }
 
+static int nl80211_ap_channel_switch(struct sk_buff *skb,
+				     struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	u32 freq = 0, count = 0, post_switch_block_tx = 0, block_tx = 0;
+
+	ASSERT_RDEV_LOCK(rdev);
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
+	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
+		block_tx = true;
+
+	if (info->attrs[NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX])
+		post_switch_block_tx = true;
+
+	return rdev->ops->ap_channel_switch(&rdev->wiphy, dev, count, block_tx,
+					    post_switch_block_tx, freq);
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -6755,6 +6791,14 @@ static struct genl_ops nl80211_ops[] = {
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
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -7827,6 +7871,42 @@ nl80211_send_radar_detected_notify(struct cfg80211_registered_device *rdev,
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
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
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
index 075bcc9..2dd37d2 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -109,6 +109,10 @@ void
 nl80211_send_radar_detected_notify(struct cfg80211_registered_device *rdev,
 				   u16 freq, struct net_device *netdev,
 				   gfp_t gfp);
+void
+nl80211_ap_ch_switch_complete_notify(struct cfg80211_registered_device *rdev,
+				     u16 freq, struct net_device *netdev,
+				     gfp_t gfp);
 
 void
 nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
-- 
1.7.5.4

