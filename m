Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44509 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab2GKTVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 15:21:13 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] cfg80211: support TX error rate CQM
Date: Wed, 11 Jul 2012 12:20:58 -0700
Message-ID: <1342034458-3889-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120711_212117_797307_224A96B1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let the user configure serveral TX error conection quality monitoring
parameters: % error rate, survey interval, and # of attempted packets.

On exceeding the TX failure rate over the given interval, the driver
will send a CQM notify event with the actual TX failure rate and
packets attempted.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 include/linux/nl80211.h |   14 ++++++++
 include/net/cfg80211.h  |   20 +++++++++++
 net/wireless/mlme.c     |   12 +++++++
 net/wireless/nl80211.c  |   81 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 +++
 5 files changed, 132 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index db961a5..8d5fa32 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2584,6 +2584,17 @@ enum nl80211_ps_state {
  * @NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT: RSSI threshold event
  * @NL80211_ATTR_CQM_PKT_LOSS_EVENT: a u32 value indicating that this many
  *	consecutive packets were not acknowledged by the peer
+ * @NL80211_ATTR_CQM_TXE_RATE: TX error rate in %. Minimum % of TX failures
+ *	during the given %NL80211_ATTR_CQM_TXE_INTVL before an
+ *	%NL80211_CMD_NOTIFY_CQM with reported %NL80211_ATTR_CQM_TXE_RATE and
+ *	%NL80211_ATTR_CQM_TXE_PKTS is generated.
+ * @NL80211_ATTR_CQM_TXE_PKTS: number of TX attempts in a given
+ *	%NL80211_ATTR_CQM_TXE_INTVL before %NL80211_ATTR_CQM_TXE_RATE is
+ *	checked.
+ * @NL80211_ATTR_CQM_TXE_INTVL: interval in seconds. Specifies the periodic
+ *	interval in which %NL80211_ATTR_CQM_TXE_PKTS and
+ *	%NL80211_ATTR_CQM_TXE_RATE must be satisfied before generating an
+ *	%NL80211_CMD_NOTIFY_CQM.
  * @__NL80211_ATTR_CQM_AFTER_LAST: internal
  * @NL80211_ATTR_CQM_MAX: highest key attribute
  */
@@ -2593,6 +2604,9 @@ enum nl80211_attr_cqm {
 	NL80211_ATTR_CQM_RSSI_HYST,
 	NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT,
 	NL80211_ATTR_CQM_PKT_LOSS_EVENT,
+	NL80211_ATTR_CQM_TXE_RATE,
+	NL80211_ATTR_CQM_TXE_PKTS,
+	NL80211_ATTR_CQM_TXE_INTVL,
 
 	/* keep last */
 	__NL80211_ATTR_CQM_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 51f67a9..84ccdb2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1574,6 +1574,8 @@ struct cfg80211_gtk_rekey_data {
  * @set_power_mgmt: Configure WLAN power management. A timeout value of -1
  *	allows the driver to adjust the dynamic ps timeout value.
  * @set_cqm_rssi_config: Configure connection quality monitor RSSI threshold.
+ * @set_cqm_txe_config: Configure connection quality monitor TX error
+ *	thresholds.
  * @sched_scan_start: Tell the driver to start a scheduled scan.
  * @sched_scan_stop: Tell the driver to stop an ongoing scheduled
  *	scan.  The driver_initiated flag specifies whether the driver
@@ -1779,6 +1781,10 @@ struct cfg80211_ops {
 				       struct net_device *dev,
 				       s32 rssi_thold, u32 rssi_hyst);
 
+	int	(*set_cqm_txe_config)(struct wiphy *wiphy,
+				      struct net_device *dev,
+				      u32 rate, u32 pkts, u32 intvl);
+
 	void	(*mgmt_frame_register)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       u16 frame_type, bool reg);
@@ -3380,6 +3386,20 @@ void cfg80211_cqm_pktloss_notify(struct net_device *dev,
 				 const u8 *peer, u32 num_packets, gfp_t gfp);
 
 /**
+ * cfg80211_cqm_txe_notify - TX error rate event
+ * @dev: network device
+ * @peer: peer's MAC address
+ * @num_packets: how many packets were lost
+ * @rate: % of packets which failed transmission
+ * @gfp: context flags
+ *
+ * Notify userspace when configured % TX failures over number of packets in a
+ * given interval is exceeded.
+ */
+void cfg80211_cqm_txe_notify(struct net_device *dev, const u8 *peer,
+			     u32 num_packets, u32 rate, gfp_t gfp);
+
+/**
  * cfg80211_gtk_rekey_notify - notify userspace about driver rekeying
  * @dev: network device
  * @bssid: BSSID of AP (to avoid races)
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index d4fece3..b6fe83a 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -923,6 +923,18 @@ void cfg80211_cqm_pktloss_notify(struct net_device *dev,
 }
 EXPORT_SYMBOL(cfg80211_cqm_pktloss_notify);
 
+void cfg80211_cqm_txe_notify(struct net_device *dev,
+			     const u8 *peer, u32 num_packets,
+			     u32 rate, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_send_cqm_txe_notify(rdev, dev, peer, num_packets, rate, gfp);
+}
+EXPORT_SYMBOL(cfg80211_cqm_txe_notify);
+
 void cfg80211_gtk_rekey_notify(struct net_device *dev, const u8 *bssid,
 			       const u8 *replay_ctr, gfp_t gfp)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2a5cdb6..70a3ef9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6158,8 +6158,34 @@ nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1] __read_mostly = {
 	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_RSSI_HYST] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_TXE_RATE] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_TXE_PKTS] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_TXE_INTVL] = { .type = NLA_U32 },
 };
 
+static int nl80211_set_cqm_txe(struct genl_info *info,
+				u32 rate, u32 pkts, u32 intvl)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev;
+	struct net_device *dev = info->user_ptr[1];
+
+	if (rate < 0 || rate > 100)
+		return -EINVAL;
+
+	wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->set_cqm_txe_config)
+		return -EOPNOTSUPP;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+		return -EOPNOTSUPP;
+
+	return rdev->ops->set_cqm_txe_config(wdev->wiphy, dev,
+					     rate, pkts, intvl);
+}
+
 static int nl80211_set_cqm_rssi(struct genl_info *info,
 				s32 threshold, u32 hysteresis)
 {
@@ -6207,6 +6233,14 @@ static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
 		threshold = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
 		hysteresis = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_HYST]);
 		err = nl80211_set_cqm_rssi(info, threshold, hysteresis);
+	} else if (attrs[NL80211_ATTR_CQM_TXE_RATE] &&
+		   attrs[NL80211_ATTR_CQM_TXE_PKTS] &&
+		   attrs[NL80211_ATTR_CQM_TXE_INTVL]) {
+		u32 rate, pkts, intvl;
+		rate = nla_get_u32(attrs[NL80211_ATTR_CQM_TXE_RATE]);
+		pkts = nla_get_u32(attrs[NL80211_ATTR_CQM_TXE_PKTS]);
+		intvl = nla_get_u32(attrs[NL80211_ATTR_CQM_TXE_INTVL]);
+		err = nl80211_set_cqm_txe(info, rate, pkts, intvl);
 	} else
 		err = -EINVAL;
 
@@ -8343,6 +8377,53 @@ void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 }
 
 void
+nl80211_send_cqm_txe_notify(struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev, const u8 *peer,
+			    u32 num_packets, u32 rate, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	struct nlattr *pinfoattr;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NOTIFY_CQM);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, peer))
+		goto nla_put_failure;
+
+	pinfoattr = nla_nest_start(msg, NL80211_ATTR_CQM);
+	if (!pinfoattr)
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_CQM_TXE_PKTS, num_packets))
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_CQM_TXE_RATE, rate))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, pinfoattr);
+
+	genlmsg_end(msg, hdr);
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
index 01a1122..c6b738a 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -110,6 +110,11 @@ nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
 				u32 num_packets, gfp_t gfp);
 
+void
+nl80211_send_cqm_txe_notify(struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev, const u8 *peer,
+			    u32 num_packets, u32 rate, gfp_t gfp);
+
 void nl80211_gtk_rekey_notify(struct cfg80211_registered_device *rdev,
 			      struct net_device *netdev, const u8 *bssid,
 			      const u8 *replay_ctr, gfp_t gfp);
-- 
1.7.4.1

