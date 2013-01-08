Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40428 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab3AHNEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 08:04:52 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 3/6] nl80211/cfg80211: add radar detection command/event
Date: Tue,  8 Jan 2013 14:04:08 +0100
Message-Id: <1357650251-17425-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130108_140457_561731_179CE731)
In-Reply-To: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

Add new NL80211_CMD_RADAR_DETECT, which triggers radar
detection in the driver/FW, this command will also notify
usermode with 'radar detected' event.
Once radar detection has started it should continuously
monitor for radars as long as the channel is active.

Add new NL80211_FEATURE_DFS attribute which
indicates that driver/HW supports radar detection.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
[changes:
 * change to chandef
 * rebase on current master]
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
Changes to PATCHv5:
 * remove unused cac_type
 * fix doc for cac_started
 * remove dfs_nlportid
---
 include/net/cfg80211.h       |   24 +++++++++++
 include/uapi/linux/nl80211.h |    9 +++++
 net/wireless/chan.c          |   14 ++++---
 net/wireless/mlme.c          |   13 ++++++
 net/wireless/nl80211.c       |   90 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h       |    6 +++
 6 files changed, 151 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8671feb..00d8f2c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -133,6 +133,11 @@ enum ieee80211_channel_flags {
  *	to enable this, this is useful only on 5 GHz band.
  * @orig_mag: internal use
  * @orig_mpwr: internal use
+ * @radar_detect_timeout: this timeout indicates the end of the channel
+ *	availability check for radar channels (in jiffies), only after this
+ *	period the user may initiate the tx on the channel.
+ * @cac_started: indicates that channel availability check is started for this
+ *	channel type.
  */
 struct ieee80211_channel {
 	enum ieee80211_band band;
@@ -145,6 +150,8 @@ struct ieee80211_channel {
 	bool beacon_found;
 	u32 orig_flags;
 	int orig_mag, orig_mpwr;
+	unsigned long radar_detect_timeout;
+	bool cac_started;
 };
 
 /**
@@ -1763,6 +1770,8 @@ struct cfg80211_gtk_rekey_data {
  *
  * @start_p2p_device: Start the given P2P device.
  * @stop_p2p_device: Stop the given P2P device.
+ *
+ * @start_radar_detection: Start radar detection in the driver.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1983,6 +1992,10 @@ struct cfg80211_ops {
 				    struct wireless_dev *wdev);
 	void	(*stop_p2p_device)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+
+	int	(*start_radar_detection)(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 struct cfg80211_chan_def *chandef);
 };
 
 /*
@@ -3571,6 +3584,17 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
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
index c8730d2..3a14310 100644
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
@@ -3158,6 +3165,7 @@ enum nl80211_ap_sme_features {
  *	Note that even for drivers that support this, the default is to add
  *	stations in authenticated/associated state, so to add unauthenticated
  *	stations the authenticated/associated bits have to be set in the mask.
+ * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3174,6 +3182,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_P2P_GO_CTWIN			= 1 << 11,
 	NL80211_FEATURE_P2P_GO_OPPPS			= 1 << 12,
 	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 13,
+	NL80211_FEATURE_DFS				= 1 << 14,
 };
 
 /**
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 396373f..eefb1f2 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -287,14 +287,18 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 			     struct cfg80211_chan_def *chandef)
 {
 	bool res;
+	u32 prohibited_flags;
 
 	trace_cfg80211_reg_can_beacon(wiphy, chandef);
 
-	res = cfg80211_chandef_usable(wiphy, chandef,
-				      IEEE80211_CHAN_DISABLED |
-				      IEEE80211_CHAN_PASSIVE_SCAN |
-				      IEEE80211_CHAN_NO_IBSS |
-				      IEEE80211_CHAN_RADAR);
+	prohibited_flags = IEEE80211_CHAN_DISABLED;
+
+	if (!(wiphy->features & NL80211_FEATURE_DFS))
+		prohibited_flags |= IEEE80211_CHAN_PASSIVE_SCAN |
+				    IEEE80211_CHAN_NO_IBSS |
+				    IEEE80211_CHAN_RADAR;
+
+	res = cfg80211_chandef_usable(wiphy, chandef, prohibited_flags);
 
 	trace_cfg80211_return_bool(res);
 	return res;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 461e692..6b63ffb 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -987,3 +987,16 @@ void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
 	nl80211_pmksa_candidate_notify(rdev, dev, index, bssid, preauth, gfp);
 }
 EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
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
index ea7d492..d98c1d3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4812,6 +4812,51 @@ static int nl80211_stop_sched_scan(struct sk_buff *skb,
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
+	if (!(rdev->wiphy.features & NL80211_FEATURE_DFS))
+		return -EOPNOTSUPP;
+
+	err = nl80211_parse_chandef(rdev, info, &chandef);
+	if (err)
+		return err;
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
+	mutex_lock(&rdev->devlist_mtx);
+	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+					   chandef.chan, CHAN_MODE_SHARED,
+					   BIT(chandef.width));
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
+	}
+
+	return err;
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
@@ -7805,6 +7850,14 @@ static struct genl_ops nl80211_ops[] = {
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
@@ -9002,6 +9055,43 @@ nl80211_send_cqm_txe_notify(struct cfg80211_registered_device *rdev,
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

