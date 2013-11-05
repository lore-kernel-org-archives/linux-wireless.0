Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:37219 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3KENtD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 08:49:03 -0500
Received: by mail-ea0-f175.google.com with SMTP id l15so3456364eak.34
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 05:49:01 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 1/5] cfg80211/mac80211: DFS setup chandef for cac event
Date: Tue,  5 Nov 2013 14:48:45 +0100
Message-Id: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131105_144907_844500_12E77C1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To report channel width correctly we have
to send correct channel parameters from
mac80211 when calling cfg80211_cac_event().

This is required in case of using channel width
higher than 20MHz and we have to set correct
dfs channel state after CAC (NL80211_DFS_AVAILABLE).

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/net/cfg80211.h |    2 ++
 net/mac80211/cfg.c     |    5 ++++-
 net/mac80211/iface.c   |    5 ++++-
 net/mac80211/mlme.c    |    6 ++++--
 net/mac80211/util.c    |    3 +++
 net/wireless/mlme.c    |    8 +++-----
 6 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c1b8874..dc7de24 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4145,6 +4145,7 @@ void cfg80211_radar_event(struct wiphy *wiphy,
 /**
  * cfg80211_cac_event - Channel availability check (CAC) event
  * @netdev: network device
+ * @chandef: chandef for the current channel
  * @event: type of event
  * @gfp: context flags
  *
@@ -4153,6 +4154,7 @@ void cfg80211_radar_event(struct wiphy *wiphy,
  * also by full-MAC drivers.
  */
 void cfg80211_cac_event(struct net_device *netdev,
+			struct cfg80211_chan_def *chandef,
 			enum nl80211_radar_event event, gfp_t gfp);
 
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ed1e9a8..fcdc357 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1050,6 +1050,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	struct ieee80211_local *local = sdata->local;
 	struct beacon_data *old_beacon;
 	struct probe_resp *old_probe_resp;
+	struct cfg80211_chan_def chandef;
 
 	old_beacon = rtnl_dereference(sdata->u.ap.beacon);
 	if (!old_beacon)
@@ -1091,8 +1092,10 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
 	if (sdata->wdev.cac_started) {
+		chandef = sdata->vif.bss_conf.chandef;
 		cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
-		cfg80211_cac_event(sdata->dev, NL80211_RADAR_CAC_ABORTED,
+		cfg80211_cac_event(sdata->dev, &chandef,
+				   NL80211_RADAR_CAC_ABORTED,
 				   GFP_KERNEL);
 	}
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ff101ea..c9b0442 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -749,6 +749,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	u32 hw_reconf_flags = 0;
 	int i, flushed;
 	struct ps_data *ps;
+	struct cfg80211_chan_def chandef;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
@@ -823,11 +824,13 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
 
 	if (sdata->wdev.cac_started) {
+		chandef = sdata->vif.bss_conf.chandef;
 		WARN_ON(local->suspended);
 		mutex_lock(&local->iflist_mtx);
 		ieee80211_vif_release_channel(sdata);
 		mutex_unlock(&local->iflist_mtx);
-		cfg80211_cac_event(sdata->dev, NL80211_RADAR_CAC_ABORTED,
+		cfg80211_cac_event(sdata->dev, &chandef,
+				   NL80211_RADAR_CAC_ABORTED,
 				   GFP_KERNEL);
 	}
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1305ff9..e75c82c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1398,10 +1398,12 @@ void ieee80211_dfs_cac_timer_work(struct work_struct *work)
 	struct ieee80211_sub_if_data *sdata =
 		container_of(delayed_work, struct ieee80211_sub_if_data,
 			     dfs_cac_timer_work);
+	struct cfg80211_chan_def chandef = sdata->vif.bss_conf.chandef;
 
 	ieee80211_vif_release_channel(sdata);
-
-	cfg80211_cac_event(sdata->dev, NL80211_RADAR_CAC_FINISHED, GFP_KERNEL);
+	cfg80211_cac_event(sdata->dev, &chandef,
+			   NL80211_RADAR_CAC_FINISHED,
+			   GFP_KERNEL);
 }
 
 /* MLME */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a38d582..6110be9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2258,14 +2258,17 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 void ieee80211_dfs_cac_cancel(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
+	struct cfg80211_chan_def chandef;
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
 
 		if (sdata->wdev.cac_started) {
+			chandef = sdata->vif.bss_conf.chandef;
 			ieee80211_vif_release_channel(sdata);
 			cfg80211_cac_event(sdata->dev,
+					   &chandef,
 					   NL80211_RADAR_CAC_ABORTED,
 					   GFP_KERNEL);
 		}
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 8d49c1c..b2276f5 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -761,12 +761,12 @@ void cfg80211_radar_event(struct wiphy *wiphy,
 EXPORT_SYMBOL(cfg80211_radar_event);
 
 void cfg80211_cac_event(struct net_device *netdev,
+			struct cfg80211_chan_def *chandef,
 			enum nl80211_radar_event event, gfp_t gfp)
 {
 	struct wireless_dev *wdev = netdev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	struct cfg80211_chan_def chandef;
 	unsigned long timeout;
 
 	trace_cfg80211_cac_event(netdev, event);
@@ -777,14 +777,12 @@ void cfg80211_cac_event(struct net_device *netdev,
 	if (WARN_ON(!wdev->channel))
 		return;
 
-	cfg80211_chandef_create(&chandef, wdev->channel, NL80211_CHAN_NO_HT);
-
 	switch (event) {
 	case NL80211_RADAR_CAC_FINISHED:
 		timeout = wdev->cac_start_time +
 			  msecs_to_jiffies(IEEE80211_DFS_MIN_CAC_TIME_MS);
 		WARN_ON(!time_after_eq(jiffies, timeout));
-		cfg80211_set_dfs_state(wiphy, &chandef, NL80211_DFS_AVAILABLE);
+		cfg80211_set_dfs_state(wiphy, chandef, NL80211_DFS_AVAILABLE);
 		break;
 	case NL80211_RADAR_CAC_ABORTED:
 		break;
@@ -794,6 +792,6 @@ void cfg80211_cac_event(struct net_device *netdev,
 	}
 	wdev->cac_started = false;
 
-	nl80211_radar_notify(rdev, &chandef, event, netdev, gfp);
+	nl80211_radar_notify(rdev, chandef, event, netdev, gfp);
 }
 EXPORT_SYMBOL(cfg80211_cac_event);
-- 
1.7.9.5

