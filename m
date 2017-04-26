Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54540 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1956653AbdDZH7L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 03:59:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Johannes Berg <johannes.berg@intel.com>
Date: Wed, 26 Apr 2017 10:58:53 +0300
Message-Id: <20170426075854.13546-9-luca@coelho.fi> (sfid-20170426_095927_405003_EFC8BD9D)
In-Reply-To: <20170426075854.13546-1-luca@coelho.fi>
References: <20170426075854.13546-1-luca@coelho.fi>
Subject: [PATCH 8/9] mac80211: disentangle iflist_mtx and chanctx_mtx
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

At least on iwlwifi, sometimes lockdep complains that we can
lock
 chanctx_mtx -> mvm.mutex -> iflist_mtx
 (due to iterate_interfaces)
and
 iflist_mtx -> chanctx_mtx

Remove the latter dependency in mac80211 by using the RTNL
that we already hold in one case, and can relatively easily
achieve in the other case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c  | 6 +-----
 net/mac80211/main.c | 2 ++
 net/mac80211/util.c | 9 ++++++---
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d041f78ecee6..bdcb82c2ab74 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -739,11 +739,8 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 		return 0;
 
 	mutex_lock(&local->mtx);
-	mutex_lock(&local->iflist_mtx);
 	if (local->use_chanctx) {
-		sdata = rcu_dereference_protected(
-				local->monitor_sdata,
-				lockdep_is_held(&local->iflist_mtx));
+		sdata = rtnl_dereference(local->monitor_sdata);
 		if (sdata) {
 			ieee80211_vif_release_channel(sdata);
 			ret = ieee80211_vif_use_channel(sdata, chandef,
@@ -756,7 +753,6 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 
 	if (ret == 0)
 		local->monitor_chandef = *chandef;
-	mutex_unlock(&local->iflist_mtx);
 	mutex_unlock(&local->mtx);
 
 	return ret;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ae408a96c407..8aa1f5b6a051 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -253,6 +253,7 @@ static void ieee80211_restart_work(struct work_struct *work)
 	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
 	     "%s called with hardware scan in progress\n", __func__);
 
+	flush_work(&local->radar_detected_work);
 	rtnl_lock();
 	list_for_each_entry(sdata, &local->interfaces, list)
 		flush_delayed_work(&sdata->dec_tailroom_needed_wk);
@@ -1187,6 +1188,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	cancel_work_sync(&local->reconfig_filter);
 	cancel_work_sync(&local->tdls_chsw_work);
 	flush_work(&local->sched_scan_stopped_work);
+	flush_work(&local->radar_detected_work);
 
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1b8e54444c36..27a27070a751 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2800,8 +2800,10 @@ void ieee80211_dfs_cac_cancel(struct ieee80211_local *local)
 	struct ieee80211_sub_if_data *sdata;
 	struct cfg80211_chan_def chandef;
 
+	/* for interface list, to avoid linking iflist_mtx and chanctx_mtx */
+	ASSERT_RTNL();
+
 	mutex_lock(&local->mtx);
-	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		/* it might be waiting for the local->mtx, but then
 		 * by the time it gets it, sdata->wdev.cac_started
@@ -2818,7 +2820,6 @@ void ieee80211_dfs_cac_cancel(struct ieee80211_local *local)
 					   GFP_KERNEL);
 		}
 	}
-	mutex_unlock(&local->iflist_mtx);
 	mutex_unlock(&local->mtx);
 }
 
@@ -2840,7 +2841,9 @@ void ieee80211_dfs_radar_detected_work(struct work_struct *work)
 	}
 	mutex_unlock(&local->chanctx_mtx);
 
+	rtnl_lock();
 	ieee80211_dfs_cac_cancel(local);
+	rtnl_unlock();
 
 	if (num_chanctx > 1)
 		/* XXX: multi-channel is not supported yet */
@@ -2855,7 +2858,7 @@ void ieee80211_radar_detected(struct ieee80211_hw *hw)
 
 	trace_api_radar_detected(local);
 
-	ieee80211_queue_work(hw, &local->radar_detected_work);
+	schedule_work(&local->radar_detected_work);
 }
 EXPORT_SYMBOL(ieee80211_radar_detected);
 
-- 
2.11.0
