Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:36125 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab2AZMjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:39:08 -0500
Received: by mail-yx0-f173.google.com with SMTP id l8so190120yen.32
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:39:07 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>
Subject: [RFC 1/9] nl80211/cfg80211: add radar detection command/event
Date: Thu, 26 Jan 2012 14:37:56 +0200
Message-Id: <1327581484-22047-2-git-send-email-victorg@ti.com> (sfid-20120126_133911_792458_B8899139)
In-Reply-To: <1327581484-22047-1-git-send-email-victorg@ti.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add start radar detection command, which triggers radar
detection in the driver/FW, this command will also notify
usermode with 'radar detected' event.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/linux/nl80211.h |    5 ++++
 include/net/cfg80211.h  |   16 ++++++++++++
 net/wireless/mlme.c     |   10 ++++++++
 net/wireless/nl80211.c  |   59 ++++++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h  |    6 ++++
 5 files changed, 95 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 0f5ff37..5bffba0 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -541,6 +541,9 @@
  * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs whether
  *      No Acknowledgement Policy should be applied.
  *
+ * @NL80211_CMD_DFS_RADAR_DETECTION: Start radar detection in the
+ *	driver/HW. Once radar detected usermode notified with this event.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -680,6 +683,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_NOACK_MAP,
 
+	NL80211_CMD_DFS_RADAR_DETECTION,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 15f4be7..b47217b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1482,6 +1482,8 @@ struct cfg80211_gtk_rekey_data {
  *	later passes to cfg80211_probe_status().
  *
  * @set_noack_map: Set the NoAck Map for the TIDs.
+ *
+ * @dfs_start_radar_detection: Start radar detection in the driver.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1680,6 +1682,9 @@ struct cfg80211_ops {
 				  u16 noack_map);
 
 	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy);
+
+	int    (*dfs_start_radar_detection)(struct wiphy *wiphy,
+					    struct net_device *dev);
 };
 
 /*
@@ -3216,6 +3221,17 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      gfp_t gfp);
 
 /**
+ * cfg80211_radar_detected_notify - radar detection event
+ * @dev: network device
+ * @freq: radar detected on this channel frequency
+ * @gfp: context flags
+ *
+ * This function is called when a radar is detected on the current channel.
+ */
+void cfg80211_radar_detected_notify(struct net_device *dev,
+				    u16 freq, gfp_t gfp);
+
+/**
  * cfg80211_cqm_pktloss_notify - notify userspace about packetloss to peer
  * @dev: network device
  * @peer: peer's MAC address
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 438dfc1..6ef723d 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1109,6 +1109,16 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 }
 EXPORT_SYMBOL(cfg80211_cqm_rssi_notify);
 
+void cfg80211_radar_detected_notify(struct net_device *dev, u16 freq, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_send_radar_detected_notify(rdev, freq, dev, gfp);
+}
+EXPORT_SYMBOL(cfg80211_radar_detected_notify);
+
 void cfg80211_cqm_pktloss_notify(struct net_device *dev,
 				 const u8 *peer, u32 num_packets, gfp_t gfp)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b3d3cf8..e96bfc5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4044,6 +4044,20 @@ static int nl80211_stop_sched_scan(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_dfs_start_radar_detection(struct sk_buff *skb,
+					     struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+
+	ASSERT_RDEV_LOCK(rdev);
+
+	if (!rdev->ops->dfs_start_radar_detection)
+		return -EOPNOTSUPP;
+
+	return rdev->ops->dfs_start_radar_detection(&rdev->wiphy, dev);
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -6711,7 +6725,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
-
+	{
+		.cmd = NL80211_CMD_DFS_RADAR_DETECTION,
+		.doit = nl80211_dfs_start_radar_detection,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -7748,6 +7769,42 @@ void nl80211_pmksa_candidate_notify(struct cfg80211_registered_device *rdev,
 }
 
 void
+nl80211_send_radar_detected_notify(struct cfg80211_registered_device *rdev,
+				   u16 freq, struct net_device *netdev,
+				   gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_DFS_RADAR_DETECTION);
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
index 12bf4d1..075bcc9 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -104,6 +104,12 @@ nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev,
 			     enum nl80211_cqm_rssi_threshold_event rssi_event,
 			     gfp_t gfp);
+
+void
+nl80211_send_radar_detected_notify(struct cfg80211_registered_device *rdev,
+				   u16 freq, struct net_device *netdev,
+				   gfp_t gfp);
+
 void
 nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
-- 
1.7.5.4

