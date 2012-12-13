Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38929 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab2LMN7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 08:59:05 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 3/8] nl80211/cfg80211: add radar detection command/event
Date: Thu, 13 Dec 2012 14:58:28 +0100
Message-Id: <1355407113-27006-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121213_145916_726972_2A83DBDF)
In-Reply-To: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

Add new NL80211_CMD_RADAR_DETECT, which triggers radar
detection in the driver/FW, this command will also notify
usermode with 'radar detected' event.
Once radar detection has started it should continuously
monitor for radars as long as the channel is active.

Add new NL80211_FEATURE_20MHZ_DFS attribute which
indicates that driver/HW supports radar detection
on 20MHz channel bandwidth.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
[changes:
 * change to chandef
 * add dfs_nlportid and check it
 * rebase on current master]
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/net/cfg80211.h       |   26 ++++++++++++
 include/uapi/linux/nl80211.h |   10 +++++
 net/wireless/mlme.c          |   13 ++++++
 net/wireless/nl80211.c       |   96 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h       |    6 +++
 5 files changed, 151 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1d22919..3740b57 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -133,6 +133,11 @@ enum ieee80211_channel_flags {
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
@@ -145,6 +150,9 @@ struct ieee80211_channel {
 	bool beacon_found;
 	u32 orig_flags;
 	int orig_mag, orig_mpwr;
+	unsigned long radar_detect_timeout;
+	enum nl80211_channel_type cac_type;
+	bool cac_started;
 };
 
 /**
@@ -1763,6 +1771,8 @@ struct cfg80211_gtk_rekey_data {
  *
  * @start_p2p_device: Start the given P2P device.
  * @stop_p2p_device: Stop the given P2P device.
+ *
+ * @start_radar_detection: Start radar detection in the driver.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1983,6 +1993,10 @@ struct cfg80211_ops {
 				    struct wireless_dev *wdev);
 	void	(*stop_p2p_device)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+
+	int	(*start_radar_detection)(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 struct cfg80211_chan_def *chandef);
 };
 
 /*
@@ -2598,6 +2612,7 @@ struct wireless_dev {
 	int beacon_interval;
 
 	u32 ap_unexpected_nlportid;
+	u32 dfs_nlportid;
 
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
@@ -3575,6 +3590,17 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
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
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e3e19f8..2303f86 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -586,6 +586,9 @@
  * @NL80211_CMD_SET_MCAST_RATE: Change the rate used to send multicast frames
  *	for IBSS or MESH vif.
  *
+ * @NL80211_CMD_RADAR_DETECT: Start radar detection in the driver/HW. Once
+ *	radar detected usermode notified with this event.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -736,6 +739,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_MCAST_RATE,
 
+	NL80211_CMD_RADAR_DETECT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1635,6 +1640,8 @@ enum nl80211_attrs {
 
 #define NL80211_CQM_TXE_MAX_INTVL		1800
 
+#define NL80211_DFS_MIN_CAC_TIME_MS		60000
+
 /**
  * enum nl80211_iftype - (virtual) interface types
  *
@@ -3140,6 +3147,8 @@ enum nl80211_ap_sme_features {
  *	setting
  * @NL80211_FEATURE_P2P_GO_OPPPS: P2P GO implementation supports opportunistic
  *	powersave
+ * @NL80211_FEATURE_20MHZ_DFS: Radar detection is supported in the
+ *	HW/driver on 20 MHz channel bandwidth.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3155,6 +3164,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_NEED_OBSS_SCAN			= 1 << 10,
 	NL80211_FEATURE_P2P_GO_CTWIN			= 1 << 11,
 	NL80211_FEATURE_P2P_GO_OPPPS			= 1 << 12,
+	NL80211_FEATURE_20MHZ_DFS			= 1 << 13,
 };
 
 /**
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 5e8123e..02666e3 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1049,3 +1049,16 @@ bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
 	return ret;
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
index aeea068..d49c0c2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4802,6 +4802,57 @@ static int nl80211_stop_sched_scan(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_start_radar_detection(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_chan_def chandef;
+	int err;
+
+	if (!(rdev->wiphy.features & NL80211_FEATURE_20MHZ_DFS))
+		return -EOPNOTSUPP;
+
+	err = nl80211_parse_chandef(rdev, info, &chandef);
+	if (err)
+		return err;
+
+	if (chandef.width > NL80211_CHAN_WIDTH_20)
+		return -EOPNOTSUPP;
+
+	if (!(chandef.chan->flags & IEEE80211_CHAN_RADAR))
+		return -EINVAL;
+
+	if (chandef.chan->cac_started)
+		return -EBUSY;
+
+	if (!rdev->ops->start_radar_detection)
+		return -EOPNOTSUPP;
+
+	if (wdev->dfs_nlportid && info->snd_portid != wdev->dfs_nlportid)
+		return -EBUSY;
+
+	mutex_lock(&rdev->devlist_mtx);
+	err = cfg80211_can_use_chan(rdev, wdev, chandef.chan,
+				    CHAN_MODE_SINGLE_ONLY);
+	mutex_unlock(&rdev->devlist_mtx);
+
+	if (err)
+		return err;
+
+	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
+	if (!err) {
+		wdev->preset_chandef = chandef;
+		chandef.chan->cac_started = true;
+		chandef.chan->radar_detect_timeout = jiffies +
+			msecs_to_jiffies(NL80211_DFS_MIN_CAC_TIME_MS);
+		wdev->dfs_nlportid = info->snd_portid;
+	}
+
+	return err;
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -7785,6 +7836,14 @@ static struct genl_ops nl80211_ops[] = {
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
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -8982,6 +9041,43 @@ nl80211_send_cqm_txe_notify(struct cfg80211_registered_device *rdev,
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
index 2acba84..28b9a34 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -108,6 +108,12 @@ nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
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
1.7.10.4

