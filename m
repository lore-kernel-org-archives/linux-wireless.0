Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30151 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdAYLbj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jan 2017 06:31:39 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [RFC 1/3] cfg80211: Make pre-CAC results valid only for ETSI domain
Date: Wed, 25 Jan 2017 17:01:08 +0530
Message-ID: <1485343870-23601-2-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20170125_123144_130033_16C497CA)
In-Reply-To: <1485343870-23601-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1485343870-23601-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DFS requirement for ETSI domain (section 4.7.1.4 in
ETSI EN 301 893 V1.8.1) is the only one which explicitly
states that once DFS channel is marked as available afer
the CAC, this channel will remain in available state even
moving to a different operating channel. But the same is
not explicitly stated in FCC DFS requirement. Also, Pre-CAC
requriements are not explicitly mentioned in FCC requirement.
Current implementation in keeping DFS channel in available
state is same as described in ETSI domain.

For ETSI DFS domain, this patch gives a grace period of 2 seconds
since the completion of successful CAC before moving the channel's
DFS state to 'usable' from 'available' state. The same grace period
is checked against the channel's dfs_state_entered timestamp while
deciding if a DFS channel is available for operation. There is a new
radar event, NL80211_RADAR_PRE_CAC_EXPIRED, reported when DFS channel
is moved from available to usable state after the grace period. Also
make sure the DFS channel state is reset to usable once the beaconing
operation on that channel is brought down (like stop_ap, leave_ibss
and leave_mesh) in non-ETSI domain.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 include/uapi/linux/nl80211.h |  5 +++
 net/wireless/ap.c            |  5 +++
 net/wireless/chan.c          | 96 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h          |  7 ++++
 net/wireless/ibss.c          |  1 +
 net/wireless/mesh.c          |  1 +
 net/wireless/mlme.c          | 41 ++++++++++++++-----
 net/wireless/reg.c           | 47 ++++++++++++++++++++++
 net/wireless/reg.h           | 14 +++++++
 9 files changed, 208 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d6c62ee..9d2d2b1 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4893,12 +4893,17 @@ enum nl80211_smps_mode {
  *	change to the channel status.
  * @NL80211_RADAR_NOP_FINISHED: The Non-Occupancy Period for this channel is
  *	over, channel becomes usable.
+ * @NL80211_RADAR_PRE_CAC_EXPIRED: Channel Availability Check done on this
+ *	non-operating channel is expired and no longer valid. New CAC must
+ *	be done on this channel before starting the operation. This is not
+ *	applicable for ETSI dfs domain where pre-CAC is valid for ever.
  */
 enum nl80211_radar_event {
 	NL80211_RADAR_DETECTED,
 	NL80211_RADAR_CAC_FINISHED,
 	NL80211_RADAR_CAC_ABORTED,
 	NL80211_RADAR_NOP_FINISHED,
+	NL80211_RADAR_PRE_CAC_EXPIRED,
 };
 
 /**
diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index bdad1f9..25666d3 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -32,6 +32,11 @@ int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		rdev_set_qos_map(rdev, dev, NULL);
 		if (notify)
 			nl80211_send_ap_stopped(wdev);
+
+		/* Should we apply the grace period during beaconing interface
+		 * shutdown also?
+		 */
+		cfg80211_sched_dfs_chan_update(rdev);
 	}
 
 	return err;
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 5497d022..090309a 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -456,6 +456,102 @@ bool cfg80211_chandef_dfs_usable(struct wiphy *wiphy,
 	return (r1 + r2 > 0);
 }
 
+static bool cfg80211_5ghz_sub_chan(struct cfg80211_chan_def *chandef,
+				   struct ieee80211_channel *chan)
+{
+	u32 start_freq_seg0 = 0, end_freq_seg0 = 0;
+	u32 start_freq_seg1 = 0, end_freq_seg1 = 0;
+
+	if (chandef->chan->center_freq == chan->center_freq)
+		return true;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_40:
+		start_freq_seg0 = chandef->center_freq1 - 20;
+		end_freq_seg0 = chandef->center_freq1 + 20;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+		start_freq_seg1 = chandef->center_freq2 - 40;
+		end_freq_seg1 = chandef->center_freq2 + 40;
+		/* fall through */
+	case NL80211_CHAN_WIDTH_80:
+		start_freq_seg0 = chandef->center_freq1 - 40;
+		end_freq_seg0 = chandef->center_freq1 + 40;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		start_freq_seg0 = chandef->center_freq1 - 80;
+		end_freq_seg0 = chandef->center_freq1 + 80;
+		break;
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
+		break;
+	}
+
+	if (chan->center_freq > start_freq_seg0 &&
+	    chan->center_freq < end_freq_seg0)
+		return true;
+
+	return chan->center_freq > start_freq_seg1 &&
+		chan->center_freq < end_freq_seg1;
+}
+
+bool cfg80211_beaconing_iface_active(struct wireless_dev *wdev)
+{
+	bool active = false;
+
+	if (!wdev->chandef.chan)
+		return false;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		active = wdev->beacon_interval != 0;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		active = wdev->ssid_len != 0;
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		active = wdev->mesh_id_len != 0;
+		break;
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_OCB:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_NAN:
+		break;
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NUM_NL80211_IFTYPES:
+		WARN_ON(1);
+	}
+
+	return active;
+}
+
+bool cfg80211_5ghz_any_wiphy_oper_chan(struct wiphy *wiphy,
+				       struct ieee80211_channel *chan)
+{
+	struct wireless_dev *wdev;
+
+	ASSERT_RTNL();
+
+	if (!(chan->flags & IEEE80211_CHAN_RADAR))
+		return false;
+
+	list_for_each_entry(wdev, &wiphy->wdev_list, list) {
+		if (!cfg80211_beaconing_iface_active(wdev))
+			continue;
+
+		if (cfg80211_5ghz_sub_chan(&wdev->chandef, chan))
+			return true;
+	}
+
+	return false;
+}
 
 static bool cfg80211_get_chans_dfs_available(struct wiphy *wiphy,
 					     u32 center_freq,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 58ca206..327fe95 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -459,6 +459,13 @@ void cfg80211_set_dfs_state(struct wiphy *wiphy,
 cfg80211_chandef_dfs_cac_time(struct wiphy *wiphy,
 			      const struct cfg80211_chan_def *chandef);
 
+void cfg80211_sched_dfs_chan_update(struct cfg80211_registered_device *rdev);
+
+bool cfg80211_5ghz_any_wiphy_oper_chan(struct wiphy *wiphy,
+				       struct ieee80211_channel *chan);
+
+bool cfg80211_beaconing_iface_active(struct wireless_dev *wdev);
+
 static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
 {
 	unsigned long end = jiffies;
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 364f900..10bf040 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -190,6 +190,7 @@ static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 	if (!nowext)
 		wdev->wext.ibss.ssid_len = 0;
 #endif
+	cfg80211_sched_dfs_chan_update(rdev);
 }
 
 void cfg80211_clear_ibss(struct net_device *dev, bool nowext)
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 2d8518a..ec0b1c2 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -262,6 +262,7 @@ int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 		wdev->beacon_interval = 0;
 		memset(&wdev->chandef, 0, sizeof(wdev->chandef));
 		rdev_set_qos_map(rdev, dev, NULL);
+		cfg80211_sched_dfs_chan_update(rdev);
 	}
 
 	return err;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 22b3d99..3c7e155 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -745,6 +745,12 @@ bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
 }
 EXPORT_SYMBOL(cfg80211_rx_mgmt);
 
+void cfg80211_sched_dfs_chan_update(struct cfg80211_registered_device *rdev)
+{
+	cancel_delayed_work(&rdev->dfs_update_channels_wk);
+	queue_delayed_work(cfg80211_wq, &rdev->dfs_update_channels_wk, 0);
+}
+
 void cfg80211_dfs_channels_update_work(struct work_struct *work)
 {
 	struct delayed_work *delayed_work = to_delayed_work(work);
@@ -755,6 +761,8 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 	struct wiphy *wiphy;
 	bool check_again = false;
 	unsigned long timeout, next_time = 0;
+	unsigned long time_dfs_update;
+	enum nl80211_radar_event radar_event;
 	int bandid, i;
 
 	rdev = container_of(delayed_work, struct cfg80211_registered_device,
@@ -770,11 +778,28 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 		for (i = 0; i < sband->n_channels; i++) {
 			c = &sband->channels[i];
 
-			if (c->dfs_state != NL80211_DFS_UNAVAILABLE)
+			if (!(c->flags & IEEE80211_CHAN_RADAR))
+				continue;
+
+			if (c->dfs_state != NL80211_DFS_UNAVAILABLE &&
+			    c->dfs_state != NL80211_DFS_AVAILABLE)
 				continue;
 
-			timeout = c->dfs_state_entered + msecs_to_jiffies(
-					IEEE80211_DFS_MIN_NOP_TIME_MS);
+			if (c->dfs_state == NL80211_DFS_UNAVAILABLE) {
+				time_dfs_update = IEEE80211_DFS_MIN_NOP_TIME_MS;
+				radar_event = NL80211_RADAR_NOP_FINISHED;
+			} else {
+				if (regulatory_pre_cac_allowed(wiphy) ||
+				    cfg80211_5ghz_any_wiphy_oper_chan(wiphy, c))
+					continue;
+
+				time_dfs_update =
+					regulatory_get_pre_cac_timeout(wiphy);
+				radar_event = NL80211_RADAR_PRE_CAC_EXPIRED;
+			}
+
+			timeout = c->dfs_state_entered +
+				  msecs_to_jiffies(time_dfs_update);
 
 			if (time_after_eq(jiffies, timeout)) {
 				c->dfs_state = NL80211_DFS_USABLE;
@@ -784,8 +809,8 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 							NL80211_CHAN_NO_HT);
 
 				nl80211_radar_notify(rdev, &chandef,
-						     NL80211_RADAR_NOP_FINISHED,
-						     NULL, GFP_ATOMIC);
+						     radar_event, NULL,
+						     GFP_ATOMIC);
 				continue;
 			}
 
@@ -810,7 +835,6 @@ void cfg80211_radar_event(struct wiphy *wiphy,
 			  gfp_t gfp)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
-	unsigned long timeout;
 
 	trace_cfg80211_radar_event(wiphy, chandef);
 
@@ -820,9 +844,7 @@ void cfg80211_radar_event(struct wiphy *wiphy,
 	 */
 	cfg80211_set_dfs_state(wiphy, chandef, NL80211_DFS_UNAVAILABLE);
 
-	timeout = msecs_to_jiffies(IEEE80211_DFS_MIN_NOP_TIME_MS);
-	queue_delayed_work(cfg80211_wq, &rdev->dfs_update_channels_wk,
-			   timeout);
+	cfg80211_sched_dfs_chan_update(rdev);
 
 	nl80211_radar_notify(rdev, chandef, NL80211_RADAR_DETECTED, NULL, gfp);
 }
@@ -851,6 +873,7 @@ void cfg80211_cac_event(struct net_device *netdev,
 			  msecs_to_jiffies(wdev->cac_time_ms);
 		WARN_ON(!time_after_eq(jiffies, timeout));
 		cfg80211_set_dfs_state(wiphy, chandef, NL80211_DFS_AVAILABLE);
+		cfg80211_sched_dfs_chan_update(rdev);
 		break;
 	case NL80211_RADAR_CAC_ABORTED:
 		break;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 753efcd..6d0d004 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3120,6 +3120,53 @@ bool regulatory_indoor_allowed(void)
 	return reg_is_indoor;
 }
 
+/*
+ * Grace period to timeout pre-CAC results on the dfs channels. This timeout
+ * value is used for Non-ETSI domain.
+ * TODO: May be make this timeout available through regdb?
+ */
+#define REG_PRE_CAC_EXPIRY_GRACE_MS 2000
+
+bool regulatory_pre_cac_allowed(struct wiphy *wiphy)
+{
+	const struct ieee80211_regdomain *regd = NULL;
+	const struct ieee80211_regdomain *wiphy_regd = NULL;
+	bool pre_cac_allowed = false;
+
+	rcu_read_lock();
+
+	regd = rcu_dereference(cfg80211_regdomain);
+	wiphy_regd = rcu_dereference(wiphy->regd);
+	if (!wiphy_regd) {
+		if (regd->dfs_region == NL80211_DFS_ETSI)
+			pre_cac_allowed = true;
+
+		rcu_read_unlock();
+
+		return pre_cac_allowed;
+	}
+
+	if (regd->dfs_region == wiphy_regd->dfs_region &&
+	    wiphy_regd->dfs_region == NL80211_DFS_ETSI)
+		pre_cac_allowed = true;
+
+	rcu_read_unlock();
+
+	return pre_cac_allowed;
+}
+
+unsigned long regulatory_get_pre_cac_timeout(struct wiphy *wiphy)
+{
+	if (!regulatory_pre_cac_allowed(wiphy))
+		return REG_PRE_CAC_EXPIRY_GRACE_MS;
+
+	/*
+	 * Return the maximum pre-CAC timeout when pre-CAC is allowed
+	 * in the current dfs domain (ETSI).
+	 */
+	return -1;
+}
+
 int __init regulatory_init(void)
 {
 	int err = 0;
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index f6ced31..1fded3d 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -143,4 +143,18 @@ void regulatory_hint_country_ie(struct wiphy *wiphy,
  */
 bool regulatory_indoor_allowed(void);
 
+/**
+ * regulatory_pre_cac_allowed - if pre-CAC allowed in the current dfs domain
+ * @wiphy: wiphy for which pre-CAC capability is checked.
+
+ * Pre-CAC is allowed only in ETSI domain.
+ */
+bool regulatory_pre_cac_allowed(struct wiphy *wiphy);
+
+/**
+ * regulatory_get_pre_cac_timeout - time in msec to timeout pre-CAC results
+ * @wiphy: wiphy for which pre-CAC timeout is needed. This timeout value is
+ *	applied on the dfs channels associated to this wiphy.
+ */
+unsigned long regulatory_get_pre_cac_timeout(struct wiphy *wiphy);
 #endif  /* __NET_WIRELESS_REG_H */
-- 
1.9.1
