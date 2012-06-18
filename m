Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:46961 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464Ab2FROtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 10:49:50 -0400
Received: by ghbz13 with SMTP id z13so3835541ghb.12
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 07:49:48 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH 1/7] nl80211/cfg80211: add radar detection command/event
Date: Mon, 18 Jun 2012 17:46:32 +0300
Message-Id: <1340030798-28992-2-git-send-email-victorg@ti.com> (sfid-20120618_164953_937820_0593DCCE)
In-Reply-To: <1340030798-28992-1-git-send-email-victorg@ti.com>
References: <1340030798-28992-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new NL80211_CMD_RADAR_DETECT, which triggers radar
detection in the driver/FW, this command will also notify
usermode with 'radar detected' event.
Once radar detection has started it should continuously
monitor for radars as long as the channel is active.

Add new NL80211_FEATURE_DFS attribute which indicates
that driver/HW supports radar detection.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/linux/nl80211.h |    7 +++++
 include/net/cfg80211.h  |   20 +++++++++++++
 net/wireless/core.h     |    6 ++++
 net/wireless/mlme.c     |   36 ++++++++++++++++++++++++
 net/wireless/nl80211.c  |   69 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 +++
 6 files changed, 143 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a6959f7..ea6ce93 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -553,6 +553,9 @@
  *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ with
  *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE.
  *
+ * @NL80211_CMD_RADAR_DETECT: Start radar detection in the driver/HW. Once
+ *	radar detected usermode notified with this event.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -696,6 +699,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CH_SWITCH_NOTIFY,
 
+	NL80211_CMD_RADAR_DETECT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2867,11 +2872,13 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_HT_IBSS: This driver supports IBSS with HT datarates.
  * @NL80211_FEATURE_INACTIVITY_TIMER: This driver takes care of freeing up
  *	the connected inactive stations in AP mode.
+ * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
 	NL80211_FEATURE_HT_IBSS		= 1 << 1,
 	NL80211_FEATURE_INACTIVITY_TIMER = 1 << 2,
+	NL80211_FEATURE_DFS		= 1 << 3,
 };
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0289d4c..32dfc1f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -127,6 +127,9 @@ enum ieee80211_channel_flags {
  *	to enable this, this is useful only on 5 GHz band.
  * @orig_mag: internal use
  * @orig_mpwr: internal use
+ * @radar_detect_timeout: this timeout indicates the end of the channel
+ *	availability check for radar channels, only after this period the
+ *	user may initiate the tx on the channel.
  */
 struct ieee80211_channel {
 	enum ieee80211_band band;
@@ -139,6 +142,7 @@ struct ieee80211_channel {
 	bool beacon_found;
 	u32 orig_flags;
 	int orig_mag, orig_mpwr;
+	unsigned long radar_detect_timeout;
 };
 
 /**
@@ -1525,6 +1529,8 @@ struct cfg80211_gtk_rekey_data {
  * @get_et_strings:  Ethtool API to get a set of strings to describe stats
  *	and perhaps other supported types of ethtool data-sets.
  *	See @ethtool_ops.get_strings
+ *
+ * @start_radar_detection: Start radar detection in the driver.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1730,6 +1736,10 @@ struct cfg80211_ops {
 				struct ethtool_stats *stats, u64 *data);
 	void	(*get_et_strings)(struct wiphy *wiphy, struct net_device *dev,
 				  u32 sset, u8 *data);
+
+	int    (*start_radar_detection)(struct wiphy *wiphy,
+					struct net_device *dev,
+					struct ieee80211_channel *chan);
 };
 
 /*
@@ -3268,6 +3278,16 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      gfp_t gfp);
 
 /**
+ * cfg80211_radar_detected - radar detection event
+ * @dev: network device
+ * @freq: radar detected on this channel frequency (in MHz)
+ * @gfp: context flags
+ *
+ * This function is called when a radar is detected on the current channel.
+ */
+void cfg80211_radar_detected(struct net_device *dev, u16 freq, gfp_t gfp);
+
+/**
  * cfg80211_cqm_pktloss_notify - notify userspace about packetloss to peer
  * @dev: network device
  * @peer: peer's MAC address
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 8523f38..03e9744 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -445,6 +445,12 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev, int freq,
 		      enum nl80211_channel_type channel_type);
 
+int cfg80211_start_radar_detection(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev,
+				   struct ieee80211_channel *chan);
+
+u16 cfg80211_calculate_bitrate(struct rate_info *rate);
+
 int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 			   const u8 *rates, unsigned int n_rates,
 			   u32 *mask);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index eb90988..a641db6 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -16,6 +16,8 @@
 #include "core.h"
 #include "nl80211.h"
 
+#define IEEE80211_DFS_MIN_CAC_TIME_MS	60000
+
 void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
@@ -982,3 +984,37 @@ bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
 	return nl80211_unexpected_4addr_frame(dev, addr, gfp);
 }
 EXPORT_SYMBOL(cfg80211_rx_unexpected_4addr_frame);
+
+int cfg80211_start_radar_detection(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev,
+				   struct ieee80211_channel *chan)
+{
+	int err;
+
+	if (!rdev->ops->start_radar_detection)
+		return -EOPNOTSUPP;
+
+	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, chan);
+	if (!err)
+		chan->radar_detect_timeout = jiffies +
+			msecs_to_jiffies(IEEE80211_DFS_MIN_CAC_TIME_MS);
+	else
+		chan->radar_detect_timeout = 0;
+
+	return err;
+}
+
+void cfg80211_radar_detected(struct net_device *dev, u16 freq, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct ieee80211_channel *chan;
+
+	chan = ieee80211_get_channel(&rdev->wiphy, freq);
+	if (chan)
+		chan->radar_detect_timeout = 0;
+
+	nl80211_radar_detected_notify(rdev, freq, dev, gfp);
+}
+EXPORT_SYMBOL(cfg80211_radar_detected);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 206465d..573c966 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4248,6 +4248,31 @@ static int nl80211_stop_sched_scan(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_start_radar_detection(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	bool dfs_supported = !!(rdev->wiphy.features & NL80211_FEATURE_DFS);
+	int freq;
+	struct ieee80211_channel *chan;
+
+	if (!dfs_supported)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
+		return -EINVAL;
+
+	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+
+	chan = ieee80211_get_channel(&rdev->wiphy, freq);
+
+	if (!chan || !(chan->flags & IEEE80211_CHAN_RADAR))
+		return -EINVAL;
+
+	return cfg80211_start_radar_detection(rdev, dev, chan);
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -6997,6 +7022,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_RADAR_DETECT,
+		.doit = nl80211_start_radar_detection,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 
 };
 
@@ -8101,6 +8134,42 @@ void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 }
 
 void
+nl80211_radar_detected_notify(struct cfg80211_registered_device *rdev,
+			      u16 freq, struct net_device *netdev, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_RADAR_DETECT);
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
index 01a1122..a333261 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -105,6 +105,11 @@ nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev,
 			     enum nl80211_cqm_rssi_threshold_event rssi_event,
 			     gfp_t gfp);
+
+void
+nl80211_radar_detected_notify(struct cfg80211_registered_device *rdev,
+			      u16 freq, struct net_device *netdev, gfp_t gfp);
+
 void
 nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
-- 
1.7.5.4

