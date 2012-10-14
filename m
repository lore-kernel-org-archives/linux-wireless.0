Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47610 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2JNOz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 10:55:59 -0400
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v4 1/6] nl80211/cfg80211: add radar detection command/event
Date: Sun, 14 Oct 2012 16:48:52 +0200
Message-ID: <1350226137-13704-2-git-send-email-victorg@ti.com> (sfid-20121014_165604_530007_3826F30A)
In-Reply-To: <1350226137-13704-1-git-send-email-victorg@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new NL80211_CMD_RADAR_DETECT, which triggers radar
detection in the driver/FW, this command will also notify
usermode with 'radar detected' event.
Once radar detection has started it should continuously
monitor for radars as long as the channel is active.

Add new NL80211_FEATURE_20MHZ_DFS attribute which
indicates that driver/HW supports radar detection
on 20MHz channel bandwidth.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/linux/nl80211.h |   10 +++++
 include/net/cfg80211.h  |   24 +++++++++++++
 net/wireless/mlme.c     |   13 +++++++
 net/wireless/nl80211.c  |   89 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    6 +++
 5 files changed, 142 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 7df9b50..ba4c697 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -578,6 +578,9 @@
  *	station, due to particular reason. %NL80211_ATTR_CONN_FAILED_REASON
  *	is used for this.
  *
+ * @NL80211_CMD_RADAR_DETECT: Start radar detection in the driver/HW. Once
+ *	radar detected usermode notified with this event.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -726,6 +729,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CONN_FAILED,
 
+	NL80211_CMD_RADAR_DETECT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1584,6 +1589,8 @@ enum nl80211_attrs {
 
 #define NL80211_CQM_TXE_MAX_INTVL		1800
 
+#define NL80211_DFS_MIN_CAC_TIME_MS		60000
+
 /**
  * enum nl80211_iftype - (virtual) interface types
  *
@@ -3028,6 +3035,8 @@ enum nl80211_ap_sme_features {
  *	in the interface combinations, even when it's only used for scan
  *	and remain-on-channel. This could be due to, for example, the
  *	remain-on-channel implementation requiring a channel context.
+ * @NL80211_FEATURE_20MHZ_DFS: Radar detection is supported in the
+ *	HW/driver on 20 MHz channel bandwidth.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3035,6 +3044,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_INACTIVITY_TIMER		= 1 << 2,
 	NL80211_FEATURE_CELL_BASE_REG_HINTS		= 1 << 3,
 	NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL	= 1 << 4,
+	NL80211_FEATURE_20MHZ_DFS			= 1 << 5,
 };
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ab78b53..238d0e2 100644
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
@@ -143,6 +148,9 @@ struct ieee80211_channel {
 	bool beacon_found;
 	u32 orig_flags;
 	int orig_mag, orig_mpwr;
+	unsigned long radar_detect_timeout;
+	enum nl80211_channel_type cac_type;
+	bool cac_started;
 };
 
 /**
@@ -1621,6 +1629,8 @@ struct cfg80211_gtk_rekey_data {
  *
  * @start_p2p_device: Start the given P2P device.
  * @stop_p2p_device: Stop the given P2P device.
+ *
+ * @start_radar_detection: Start radar detection in the driver.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1842,6 +1852,9 @@ struct cfg80211_ops {
 				    struct wireless_dev *wdev);
 	void	(*stop_p2p_device)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+	int	(*start_radar_detection)(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 struct ieee80211_channel *chan);
 };
 
 /*
@@ -3430,6 +3443,17 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
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
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 3df195a..1a732a8 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1021,3 +1021,16 @@ bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
 	return nl80211_unexpected_4addr_frame(dev, addr, gfp);
 }
 EXPORT_SYMBOL(cfg80211_rx_unexpected_4addr_frame);
+
+void cfg80211_radar_detected(struct net_device *dev,
+			     struct ieee80211_channel *chan, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	chan->cac_started = false;
+
+	nl80211_radar_detected_notify(rdev, chan, dev, gfp);
+}
+EXPORT_SYMBOL(cfg80211_radar_detected);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f1047ae..4c83c28 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1411,6 +1411,7 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 			result = -EINVAL;
 			break;
 		}
+		channel->cac_started = false;
 		wdev->preset_chan = channel;
 		wdev->preset_chantype = channel_type;
 		result = 0;
@@ -4604,6 +4605,49 @@ static int nl80211_stop_sched_scan(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_start_radar_detection(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	int freq, err;
+	struct ieee80211_channel *chan;
+	enum nl80211_channel_type cac_type;
+
+	if (!(rdev->wiphy.features & NL80211_FEATURE_20MHZ_DFS))
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
+	    !info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE])
+		return -EINVAL;
+
+	cac_type = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+	if ((cac_type != NL80211_CHAN_HT20) && (cac_type != NL80211_CHAN_NO_HT))
+		return -EOPNOTSUPP;
+
+	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+	chan = ieee80211_get_channel(&rdev->wiphy, freq);
+
+	if (!chan || !(chan->flags & IEEE80211_CHAN_RADAR))
+		return -EINVAL;
+
+	if (chan->cac_started)
+		return -EBUSY;
+
+	if (!rdev->ops->start_radar_detection)
+		return -EOPNOTSUPP;
+
+	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, chan);
+	if (!err) {
+		chan->cac_type = cac_type;
+		chan->cac_started = true;
+		chan->radar_detect_timeout = jiffies +
+			msecs_to_jiffies(NL80211_DFS_MIN_CAC_TIME_MS);
+	}
+
+	return err;
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -7552,6 +7596,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
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
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -8748,6 +8800,43 @@ nl80211_send_cqm_txe_notify(struct cfg80211_registered_device *rdev,
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
index f615351..42203ae 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -110,6 +110,12 @@ nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
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

