Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:37063 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755967Ab2HHMAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:00:19 -0400
Received: by obbuo13 with SMTP id uo13so1026250obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:00:17 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 1/7] nl80211/cfg80211: add radar detection command/event
Date: Wed,  8 Aug 2012 14:53:37 +0300
Message-Id: <1344426823-1795-2-git-send-email-victorg@ti.com> (sfid-20120808_140049_334973_80C3118E)
In-Reply-To: <1344426823-1795-1-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
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
 include/linux/nl80211.h |    7 ++++
 include/net/cfg80211.h  |   24 ++++++++++++++
 net/wireless/core.h     |    4 ++
 net/wireless/mlme.c     |   38 ++++++++++++++++++++++
 net/wireless/nl80211.c  |   80 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    6 +++
 6 files changed, 159 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2f38788..773ba68 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -565,6 +565,9 @@
  *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ with
  *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE.
  *
+ * @NL80211_CMD_RADAR_DETECT: Start radar detection in the driver/HW. Once
+ *	radar detected usermode notified with this event.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -708,6 +711,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CH_SWITCH_NOTIFY,
 
+	NL80211_CMD_RADAR_DETECT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2994,12 +2999,14 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_CELL_BASE_REG_HINTS: This driver has been tested
  *	to work properly to suppport receiving regulatory hints from
  *	cellular base stations.
+ * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
 	NL80211_FEATURE_HT_IBSS		= 1 << 1,
 	NL80211_FEATURE_INACTIVITY_TIMER = 1 << 2,
 	NL80211_FEATURE_CELL_BASE_REG_HINTS = 1 << 3,
+	NL80211_FEATURE_DFS		= 1 << 4,
 };
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3d254e1..c40a05d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -131,6 +131,11 @@ enum ieee80211_channel_flags {
  *	to enable this, this is useful only on 5 GHz band.
  * @orig_mag: internal use
  * @orig_mpwr: internal use
+ * @radar_detect_timeout: this timeout indicates the end of the channel
+ *	availability check for radar channels (in jiffies), only after this
+ *	period the user may initiate the tx on the channel.
+ * @cac_type: indicates that channel availability check is started for this
+ *	channel type.
  */
 struct ieee80211_channel {
 	enum ieee80211_band band;
@@ -143,6 +148,8 @@ struct ieee80211_channel {
 	bool beacon_found;
 	u32 orig_flags;
 	int orig_mag, orig_mpwr;
+	unsigned long radar_detect_timeout;
+	enum nl80211_channel_type cac_type;
 };
 
 /**
@@ -1618,6 +1625,8 @@ struct cfg80211_gtk_rekey_data {
  * @get_channel: Get the current operating channel for the virtual interface.
  *	For monitor interfaces, it should return %NULL unless there's a single
  *	current monitoring channel.
+ *
+ * @start_radar_detection: Start radar detection in the driver.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1834,6 +1843,10 @@ struct cfg80211_ops {
 		(*get_channel)(struct wiphy *wiphy,
 			       struct wireless_dev *wdev,
 			       enum nl80211_channel_type *type);
+
+	int	(*start_radar_detection)(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 struct ieee80211_channel *chan);
 };
 
 /*
@@ -3392,6 +3405,17 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      gfp_t gfp);
 
 /**
+ * cfg80211_radar_detected - radar detection event
+ * @dev: network device
+ * @chan: radar detected on this channel.
+ * @gfp: context flags
+ *
+ * This function is called when a radar is detected on the current channel.
+ */
+void cfg80211_radar_detected(struct net_device *dev,
+			     struct ieee80211_channel *chan, gfp_t gfp);
+
+/**
  * cfg80211_cqm_pktloss_notify - notify userspace about packetloss to peer
  * @dev: network device
  * @peer: peer's MAC address
diff --git a/net/wireless/core.h b/net/wireless/core.h
index bc7430b..06d8609 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -471,6 +471,10 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 				 int freq, enum nl80211_channel_type chantype);
 
+int cfg80211_start_radar_detection(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev,
+				   struct ieee80211_channel *chan);
+
 int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 			   const u8 *rates, unsigned int n_rates,
 			   u32 *mask);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 1cdb1d5..6530af3 100644
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
@@ -1006,3 +1008,39 @@ bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
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
+	else {
+		chan->radar_detect_timeout = 0;
+		chan->cac_type = 0;
+	}
+
+	return err;
+}
+
+void cfg80211_radar_detected(struct net_device *dev,
+			     struct ieee80211_channel *chan, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+
+	chan->radar_detect_timeout = 0;
+	chan->cac_type = 0;
+
+	nl80211_radar_detected_notify(rdev, chan, dev, gfp);
+}
+EXPORT_SYMBOL(cfg80211_radar_detected);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 97026f3..74e65d7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4581,6 +4581,41 @@ static int nl80211_stop_sched_scan(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_start_radar_detection(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	bool dfs_supported = (rdev->wiphy.features & NL80211_FEATURE_DFS);
+	int freq;
+	struct ieee80211_channel *chan;
+	enum nl80211_channel_type cac_type;
+
+	if (!dfs_supported)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
+	    !info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE])
+		return -EINVAL;
+
+	cac_type = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+	if (cac_type != NL80211_CHAN_HT20)
+		return -EOPNOTSUPP;
+
+	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+	chan = ieee80211_get_channel(&rdev->wiphy, freq);
+
+	if (!chan || !(chan->flags & IEEE80211_CHAN_RADAR))
+		return -EINVAL;
+
+	if (chan->cac_type)
+		return -EBUSY;
+
+	chan->cac_type = cac_type;
+
+	return cfg80211_start_radar_detection(rdev, dev, chan);
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -7439,6 +7474,14 @@ static struct genl_ops nl80211_ops[] = {
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
 
@@ -8602,6 +8645,43 @@ nl80211_send_cqm_txe_notify(struct cfg80211_registered_device *rdev,
 }
 
 void
+nl80211_radar_detected_notify(struct cfg80211_registered_device *rdev,
+			      struct ieee80211_channel *chan,
+			      struct net_device *netdev, gfp_t gfp)
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
+	    nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ, chan->center_freq))
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
index 9f2616f..e4b6d1a 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -105,6 +105,12 @@ nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev,
 			     enum nl80211_cqm_rssi_threshold_event rssi_event,
 			     gfp_t gfp);
+
+void
+nl80211_radar_detected_notify(struct cfg80211_registered_device *rdev,
+			      struct ieee80211_channel *chan,
+			      struct net_device *netdev, gfp_t gfp);
+
 void
 nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
-- 
1.7.5.4

