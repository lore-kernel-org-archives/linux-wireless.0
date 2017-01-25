Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47598 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdAYLcF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jan 2017 06:32:05 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [RFC 3/3] cfg80211: Share Channel DFS state across wiphys of same DFS domain
Date: Wed, 25 Jan 2017 17:01:10 +0530
Message-ID: <1485343870-23601-4-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20170125_123209_065553_4811997B)
In-Reply-To: <1485343870-23601-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1485343870-23601-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sharing DFS channel state across multiple wiphys (radios) could
be useful with multiple radios on the system. When one radio
completes CAC and marks the channel available another radio
can use this information and start beaconing without really doing
CAC.

Whenever there is a state change in DFS channel associated to
a particular wiphy the the same state change is propagated to
other wiphys having the same DFS reg domain configuration.
Also when a new wiphy is created the DFS channel state of
other existing wiphys of same DFS domain is copied.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 net/wireless/chan.c |  24 +++++++++--
 net/wireless/core.c |  37 +++++++++++++++++
 net/wireless/core.h |   6 +++
 net/wireless/mlme.c |  11 +++++-
 net/wireless/reg.c  | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/reg.h  |  22 +++++++++++
 6 files changed, 207 insertions(+), 5 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 090309a..40f1097 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -532,21 +532,37 @@ bool cfg80211_beaconing_iface_active(struct wireless_dev *wdev)
 	return active;
 }
 
+static bool cfg80211_5ghz_is_wiphy_oper_chan(struct wiphy *wiphy,
+					     struct ieee80211_channel *chan)
+{
+	struct wireless_dev *wdev;
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
+
 bool cfg80211_5ghz_any_wiphy_oper_chan(struct wiphy *wiphy,
 				       struct ieee80211_channel *chan)
 {
-	struct wireless_dev *wdev;
+	struct cfg80211_registered_device *rdev;
 
 	ASSERT_RTNL();
 
 	if (!(chan->flags & IEEE80211_CHAN_RADAR))
 		return false;
 
-	list_for_each_entry(wdev, &wiphy->wdev_list, list) {
-		if (!cfg80211_beaconing_iface_active(wdev))
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		if (!reg_dfs_domain_same(wiphy, &rdev->wiphy))
 			continue;
 
-		if (cfg80211_5ghz_sub_chan(&wdev->chandef, chan))
+		if (cfg80211_5ghz_is_wiphy_oper_chan(&rdev->wiphy, chan))
 			return true;
 	}
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 903fc419..c3fe44b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -357,6 +357,38 @@ static void cfg80211_sched_scan_stop_wk(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static void cfg80211_propagate_radar_detect_wk(struct work_struct *work)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = container_of(work, struct cfg80211_registered_device,
+			    porpagate_radar_detect_wk);
+
+	rtnl_lock();
+
+	regulatory_propagate_dfs_state(&rdev->wiphy, &rdev->radar_chandef,
+				       NL80211_DFS_UNAVAILABLE,
+				       NL80211_RADAR_DETECTED);
+
+	rtnl_unlock();
+}
+
+static void cfg80211_propagate_cac_done_wk(struct work_struct *work)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = container_of(work, struct cfg80211_registered_device,
+			    propagate_cac_done_wk);
+
+	rtnl_lock();
+
+	regulatory_propagate_dfs_state(&rdev->wiphy, &rdev->cac_done_chandef,
+				       NL80211_DFS_AVAILABLE,
+				       NL80211_RADAR_CAC_FINISHED);
+
+	rtnl_unlock();
+}
+
 /* exported functions */
 
 struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
@@ -456,6 +488,9 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	spin_lock_init(&rdev->destroy_list_lock);
 	INIT_WORK(&rdev->destroy_work, cfg80211_destroy_iface_wk);
 	INIT_WORK(&rdev->sched_scan_stop_wk, cfg80211_sched_scan_stop_wk);
+	INIT_WORK(&rdev->porpagate_radar_detect_wk,
+		  cfg80211_propagate_radar_detect_wk);
+	INIT_WORK(&rdev->propagate_cac_done_wk, cfg80211_propagate_cac_done_wk);
 
 #ifdef CONFIG_CFG80211_DEFAULT_PS
 	rdev->wiphy.flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
@@ -914,6 +949,8 @@ void wiphy_unregister(struct wiphy *wiphy)
 	flush_work(&rdev->destroy_work);
 	flush_work(&rdev->sched_scan_stop_wk);
 	flush_work(&rdev->mlme_unreg_wk);
+	flush_work(&rdev->porpagate_radar_detect_wk);
+	flush_work(&rdev->propagate_cac_done_wk);
 
 #ifdef CONFIG_PM
 	if (rdev->wiphy.wowlan_config && rdev->ops->set_wakeup)
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 327fe95..607c8be 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -97,6 +97,12 @@ struct cfg80211_registered_device {
 
 	struct work_struct sched_scan_stop_wk;
 
+	struct cfg80211_chan_def radar_chandef;
+	struct work_struct porpagate_radar_detect_wk;
+
+	struct cfg80211_chan_def cac_done_chandef;
+	struct work_struct propagate_cac_done_wk;
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __aligned(NETDEV_ALIGN);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 3c7e155..596d523 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -18,7 +18,6 @@
 #include "nl80211.h"
 #include "rdev-ops.h"
 
-
 void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 			    const u8 *buf, size_t len, int uapsd_queues)
 {
@@ -811,6 +810,10 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work)
 				nl80211_radar_notify(rdev, &chandef,
 						     radar_event, NULL,
 						     GFP_ATOMIC);
+
+				regulatory_propagate_dfs_state(wiphy, &chandef,
+							       c->dfs_state,
+							       radar_event);
 				continue;
 			}
 
@@ -847,6 +850,9 @@ void cfg80211_radar_event(struct wiphy *wiphy,
 	cfg80211_sched_dfs_chan_update(rdev);
 
 	nl80211_radar_notify(rdev, chandef, NL80211_RADAR_DETECTED, NULL, gfp);
+
+	memcpy(&rdev->radar_chandef, chandef, sizeof(struct cfg80211_chan_def));
+	queue_work(cfg80211_wq, &rdev->porpagate_radar_detect_wk);
 }
 EXPORT_SYMBOL(cfg80211_radar_event);
 
@@ -873,6 +879,9 @@ void cfg80211_cac_event(struct net_device *netdev,
 			  msecs_to_jiffies(wdev->cac_time_ms);
 		WARN_ON(!time_after_eq(jiffies, timeout));
 		cfg80211_set_dfs_state(wiphy, chandef, NL80211_DFS_AVAILABLE);
+		memcpy(&rdev->cac_done_chandef, chandef,
+		       sizeof(struct cfg80211_chan_def));
+		queue_work(cfg80211_wq, &rdev->propagate_cac_done_wk);
 		cfg80211_sched_dfs_chan_update(rdev);
 		break;
 	case NL80211_RADAR_CAC_ABORTED:
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6d0d004..e41ffff 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2067,6 +2067,83 @@ static void reg_set_request_processed(void)
 	return REG_REQ_IGNORE;
 }
 
+bool reg_dfs_domain_same(struct wiphy *wiphy1, struct wiphy *wiphy2)
+{
+	const struct ieee80211_regdomain *wiphy1_regd = NULL;
+	const struct ieee80211_regdomain *wiphy2_regd = NULL;
+	const struct ieee80211_regdomain *cfg80211_regd = NULL;
+	bool dfs_domain_same = false;
+
+	rcu_read_lock();
+
+	cfg80211_regd = rcu_dereference(cfg80211_regdomain);
+	wiphy1_regd = rcu_dereference(wiphy1->regd);
+	if (!wiphy1_regd)
+		wiphy1_regd = cfg80211_regd;
+
+	wiphy2_regd = rcu_dereference(wiphy2->regd);
+	if (!wiphy2_regd)
+		wiphy2_regd = cfg80211_regd;
+
+	if (wiphy1_regd->dfs_region == wiphy2_regd->dfs_region)
+		dfs_domain_same = true;
+
+	rcu_read_unlock();
+
+	return dfs_domain_same;
+}
+
+static void reg_copy_dfs_chan_state(struct ieee80211_channel *dst_chan,
+				    struct ieee80211_channel *src_chan)
+{
+	if (!(dst_chan->flags & IEEE80211_CHAN_RADAR) ||
+	    !(src_chan->flags & IEEE80211_CHAN_RADAR))
+		return;
+
+	if (dst_chan->flags & IEEE80211_CHAN_DISABLED ||
+	    src_chan->flags & IEEE80211_CHAN_DISABLED)
+		return;
+
+	if (src_chan->center_freq == dst_chan->center_freq &&
+	    dst_chan->dfs_state == NL80211_DFS_USABLE) {
+		dst_chan->dfs_state = src_chan->dfs_state;
+		dst_chan->dfs_state_entered = src_chan->dfs_state_entered;
+	}
+}
+
+static void wiphy_share_dfs_chan_state(struct wiphy *dst_wiphy,
+				       struct wiphy *src_wiphy)
+{
+	struct ieee80211_supported_band *src_sband, *dst_sband;
+	int i, j;
+
+	dst_sband = dst_wiphy->bands[NL80211_BAND_5GHZ];
+	src_sband = src_wiphy->bands[NL80211_BAND_5GHZ];
+	if (!dst_sband || !src_sband)
+		return;
+
+	if (!reg_dfs_domain_same(dst_wiphy, src_wiphy))
+		return;
+
+	for (i = 0; i < dst_sband->n_channels; i++)
+		for (j = 0; j < src_sband->n_channels; j++)
+			reg_copy_dfs_chan_state(&dst_sband->channels[i],
+						&src_sband->channels[j]);
+}
+
+static void wiphy_all_share_dfs_chan_state(struct wiphy *wiphy)
+{
+	struct cfg80211_registered_device *rdev;
+
+	ASSERT_RTNL();
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		if (wiphy == &rdev->wiphy)
+			continue;
+		wiphy_share_dfs_chan_state(wiphy, &rdev->wiphy);
+	}
+}
+
 /* This processes *all* regulatory hints */
 static void reg_process_hint(struct regulatory_request *reg_request)
 {
@@ -2110,6 +2187,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	if (treatment == REG_REQ_ALREADY_SET && wiphy &&
 	    wiphy->regulatory_flags & REGULATORY_STRICT_REG) {
 		wiphy_update_regulatory(wiphy, reg_request->initiator);
+		wiphy_all_share_dfs_chan_state(wiphy);
 		reg_check_channels();
 	}
 
@@ -3061,6 +3139,7 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 
 	lr = get_last_request();
 	wiphy_update_regulatory(wiphy, lr->initiator);
+	wiphy_all_share_dfs_chan_state(wiphy);
 }
 
 void wiphy_regulatory_deregister(struct wiphy *wiphy)
@@ -3167,6 +3246,39 @@ unsigned long regulatory_get_pre_cac_timeout(struct wiphy *wiphy)
 	return -1;
 }
 
+void regulatory_propagate_dfs_state(struct wiphy *wiphy,
+				    struct cfg80211_chan_def *chandef,
+				    enum nl80211_dfs_state dfs_state,
+				    enum nl80211_radar_event event)
+{
+	struct cfg80211_registered_device *rdev;
+
+	ASSERT_RTNL();
+
+	if (WARN_ON(!(chandef->chan->flags & IEEE80211_CHAN_RADAR)))
+		return;
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		if (wiphy == &rdev->wiphy)
+			continue;
+
+		if (!reg_dfs_domain_same(wiphy, &rdev->wiphy))
+			continue;
+
+		if (!ieee80211_get_channel(&rdev->wiphy,
+					   chandef->chan->center_freq))
+			continue;
+
+		cfg80211_set_dfs_state(&rdev->wiphy, chandef, dfs_state);
+
+		if (event == NL80211_RADAR_DETECTED ||
+		    event == NL80211_RADAR_CAC_FINISHED)
+			cfg80211_sched_dfs_chan_update(rdev);
+
+		nl80211_radar_notify(rdev, chandef, event, NULL, GFP_KERNEL);
+	}
+}
+
 int __init regulatory_init(void)
 {
 	int err = 0;
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 1fded3d..d9c7eff 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -157,4 +157,26 @@ void regulatory_hint_country_ie(struct wiphy *wiphy,
  *	applied on the dfs channels associated to this wiphy.
  */
 unsigned long regulatory_get_pre_cac_timeout(struct wiphy *wiphy);
+
+/**
+ * regulatory_propagate_dfs_state - Propagate DFS channel state to other wiphys
+ * @wiphy - wiphy on which radar is detected and the event will be propagated
+ *	to other available wiphys having the same DFS domain
+ * @chandef - Channel definition of radar detected channel
+ * @dfs_state - DFS channel state to be set
+ * @event - Type of radar event which triggered this DFS state change
+ *
+ * This function should be called with rtnl lock held.
+ */
+void regulatory_propagate_dfs_state(struct wiphy *wiphy,
+				    struct cfg80211_chan_def *chandef,
+				    enum nl80211_dfs_state dfs_state,
+				    enum nl80211_radar_event event);
+
+/**
+ * reg_dfs_domain_same - Checks if both wiphy have same DFS domain configured
+ * @wiphy1 - wiphy it's dfs_region to be checked against that of wiphy2
+ * @wiphy2 - wiphy it's dfs_region to be checked against that of wiphy1
+ */
+bool reg_dfs_domain_same(struct wiphy *wiphy1, struct wiphy *wiphy2);
 #endif  /* __NET_WIRELESS_REG_H */
-- 
1.9.1
