Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48773 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3LRJNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 04:13:50 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sw@simonwunderlich.de, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix iflist_mtx/mtx locking in radar detection
Date: Wed, 18 Dec 2013 10:13:46 +0100
Message-Id: <1387358026-25741-1-git-send-email-johannes@sipsolutions.net> (sfid-20131218_101402_308695_6F3F6D15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The scan code creates an iflist_mtx -> mtx locking dependency,
and a few other places, notably radar detection, were creating
the opposite dependency, causing lockdep to complain. As scan
and radar detection are mutually exclusive, the deadlock can't
really happen in practice, but it's still bad form.

A similar issue exists in the monitor mode code, but this is
only used by channel-context drivers right now and those have
to have hardware scan, so that also can't happen.

Still, fix these issues by making some of the channel context
code require the mtx to be held rather than acquiring it, thus
allowing the monitor/radar callers to keep the iflist_mtx->mtx
lock ordering.

While at it, also fix access to the local->scanning variable
in the radar code, and document that radar_detect_enabled is
now properly protected by the mtx.

Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c   | 26 ++++++++++++++++++++++----
 net/mac80211/chan.c  | 21 +++++++++++----------
 net/mac80211/ibss.c  |  6 ++++++
 net/mac80211/iface.c |  6 ++++++
 net/mac80211/mlme.c  | 15 ++++++++++++++-
 net/mac80211/util.c  |  2 ++
 6 files changed, 61 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ac18528..7925881 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -828,6 +828,7 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 	if (cfg80211_chandef_identical(&local->monitor_chandef, chandef))
 		return 0;
 
+	mutex_lock(&local->mtx);
 	mutex_lock(&local->iflist_mtx);
 	if (local->use_chanctx) {
 		sdata = rcu_dereference_protected(
@@ -846,6 +847,7 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 	if (ret == 0)
 		local->monitor_chandef = *chandef;
 	mutex_unlock(&local->iflist_mtx);
+	mutex_unlock(&local->mtx);
 
 	return ret;
 }
@@ -951,6 +953,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			      struct cfg80211_ap_settings *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct beacon_data *old;
 	struct ieee80211_sub_if_data *vlan;
 	u32 changed = BSS_CHANGED_BEACON_INT |
@@ -969,8 +972,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 	sdata->radar_required = params->radar_required;
 
+	mutex_lock(&local->mtx);
 	err = ieee80211_vif_use_channel(sdata, &params->chandef,
 					IEEE80211_CHANCTX_SHARED);
+	mutex_unlock(&local->mtx);
 	if (err)
 		return err;
 	ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
@@ -1121,7 +1126,9 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	skb_queue_purge(&sdata->u.ap.ps.bc_buf);
 
 	ieee80211_vif_copy_chanctx_to_vlans(sdata, true);
+	mutex_lock(&local->mtx);
 	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&local->mtx);
 
 	return 0;
 }
@@ -1944,8 +1951,10 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
+	mutex_lock(&local->mtx);
 	err = ieee80211_vif_use_channel(sdata, &setup->chandef,
 					IEEE80211_CHANCTX_SHARED);
+	mutex_unlock(&local->mtx);
 	if (err)
 		return err;
 
@@ -1957,7 +1966,9 @@ static int ieee80211_leave_mesh(struct wiphy *wiphy, struct net_device *dev)
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	ieee80211_stop_mesh(sdata);
+	mutex_lock(&local->mtx);
 	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&local->mtx);
 
 	return 0;
 }
@@ -2895,8 +2906,11 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	unsigned long timeout;
 	int err;
 
-	if (!list_empty(&local->roc_list) || local->scanning)
-		return -EBUSY;
+	mutex_lock(&local->mtx);
+	if (!list_empty(&local->roc_list) || local->scanning) {
+		err = -EBUSY;
+		goto out_unlock;
+	}
 
 	/* whatever, but channel contexts should not complain about that one */
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
@@ -2908,13 +2922,15 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 					IEEE80211_CHANCTX_SHARED);
 	mutex_unlock(&local->iflist_mtx);
 	if (err)
-		return err;
+		goto out_unlock;
 
 	timeout = msecs_to_jiffies(IEEE80211_DFS_MIN_CAC_TIME_MS);
 	ieee80211_queue_delayed_work(&sdata->local->hw,
 				     &sdata->dfs_cac_timer_work, timeout);
 
-	return 0;
+ out_unlock:
+	mutex_unlock(&local->mtx);
+	return err;
 }
 
 static struct cfg80211_beacon_data *
@@ -2990,7 +3006,9 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 		goto unlock;
 
 	sdata->radar_required = sdata->csa_radar_required;
+	mutex_lock(&local->mtx);
 	err = ieee80211_vif_change_channel(sdata, &changed);
+	mutex_unlock(&local->mtx);
 	if (WARN_ON(err < 0))
 		goto unlock;
 
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f20a98a..f43613a 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -232,8 +232,8 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	if (!local->use_chanctx)
 		local->hw.conf.radar_enabled = ctx->conf.radar_enabled;
 
-	/* acquire mutex to prevent idle from changing */
-	mutex_lock(&local->mtx);
+	/* we hold the mutex to prevent idle from changing */
+	lockdep_assert_held(&local->mtx);
 	/* turn idle off *before* setting channel -- some drivers need that */
 	changed = ieee80211_idle_off(local);
 	if (changed)
@@ -246,19 +246,14 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 		err = drv_add_chanctx(local, ctx);
 		if (err) {
 			kfree(ctx);
-			ctx = ERR_PTR(err);
-
 			ieee80211_recalc_idle(local);
-			goto out;
+			return ERR_PTR(err);
 		}
 	}
 
 	/* and keep the mutex held until the new chanctx is on the list */
 	list_add_rcu(&ctx->list, &local->chanctx_list);
 
- out:
-	mutex_unlock(&local->mtx);
-
 	return ctx;
 }
 
@@ -294,9 +289,7 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 	/* throw a warning if this wasn't the only channel context. */
 	WARN_ON(check_single_channel && !list_empty(&local->chanctx_list));
 
-	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(local);
-	mutex_unlock(&local->mtx);
 }
 
 static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
@@ -364,6 +357,8 @@ static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
 	bool radar_enabled;
 
 	lockdep_assert_held(&local->chanctx_mtx);
+	/* for setting local->radar_detect_enabled */
+	lockdep_assert_held(&local->mtx);
 
 	radar_enabled = ieee80211_is_radar_required(local);
 
@@ -518,6 +513,8 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx *ctx;
 	int ret;
 
+	lockdep_assert_held(&local->mtx);
+
 	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
 
 	mutex_lock(&local->chanctx_mtx);
@@ -558,6 +555,8 @@ int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
 	int ret;
 	u32 chanctx_changed = 0;
 
+	lockdep_assert_held(&local->mtx);
+
 	/* should never be called if not performing a channel switch. */
 	if (WARN_ON(!sdata->vif.csa_active))
 		return -EINVAL;
@@ -655,6 +654,8 @@ void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 {
 	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
 
+	lockdep_assert_held(&sdata->local->mtx);
+
 	mutex_lock(&sdata->local->chanctx_mtx);
 	__ieee80211_vif_release_channel(sdata);
 	mutex_unlock(&sdata->local->chanctx_mtx);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d6ba8414..058e178 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -293,6 +293,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		radar_required = true;
 	}
 
+	mutex_lock(&local->mtx);
 	ieee80211_vif_release_channel(sdata);
 	if (ieee80211_vif_use_channel(sdata, &chandef,
 				      ifibss->fixed_channel ?
@@ -301,6 +302,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		sdata_info(sdata, "Failed to join IBSS, no channel context\n");
 		return;
 	}
+	mutex_unlock(&local->mtx);
 
 	memcpy(ifibss->bssid, bssid, ETH_ALEN);
 
@@ -363,7 +365,9 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.ssid_len = 0;
 		RCU_INIT_POINTER(ifibss->presp, NULL);
 		kfree_rcu(presp, rcu_head);
+		mutex_lock(&local->mtx);
 		ieee80211_vif_release_channel(sdata);
+		mutex_unlock(&local->mtx);
 		sdata_info(sdata, "Failed to join IBSS, driver failure: %d\n",
 			   err);
 		return;
@@ -747,7 +751,9 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_IBSS);
 	drv_leave_ibss(local, sdata);
+	mutex_lock(&local->mtx);
 	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&local->mtx);
 }
 
 static void ieee80211_csa_connection_drop_work(struct work_struct *work)
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3d2168c..d2b6bfc 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -418,8 +418,10 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 		return ret;
 	}
 
+	mutex_lock(&local->mtx);
 	ret = ieee80211_vif_use_channel(sdata, &local->monitor_chandef,
 					IEEE80211_CHANCTX_EXCLUSIVE);
+	mutex_unlock(&local->mtx);
 	if (ret) {
 		drv_remove_interface(local, sdata);
 		kfree(sdata);
@@ -456,7 +458,9 @@ void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 
 	synchronize_net();
 
+	mutex_lock(&local->mtx);
 	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&local->mtx);
 
 	drv_remove_interface(local, sdata);
 
@@ -826,9 +830,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	if (sdata->wdev.cac_started) {
 		chandef = sdata->vif.bss_conf.chandef;
 		WARN_ON(local->suspended);
+		mutex_lock(&local->mtx);
 		mutex_lock(&local->iflist_mtx);
 		ieee80211_vif_release_channel(sdata);
 		mutex_unlock(&local->iflist_mtx);
+		mutex_unlock(&local->mtx);
 		cfg80211_cac_event(sdata->dev, &chandef,
 				   NL80211_RADAR_CAC_ABORTED,
 				   GFP_KERNEL);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9c2c7ee..93792d7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -888,7 +888,9 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
+	mutex_lock(&local->mtx);
 	ret = ieee80211_vif_change_channel(sdata, &changed);
+	mutex_unlock(&local->mtx);
 	if (ret) {
 		sdata_info(sdata,
 			   "vif channel switch failed, disconnecting\n");
@@ -1401,7 +1403,9 @@ void ieee80211_dfs_cac_timer_work(struct work_struct *work)
 			     dfs_cac_timer_work);
 	struct cfg80211_chan_def chandef = sdata->vif.bss_conf.chandef;
 
+	mutex_lock(&sdata->local->mtx);
 	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&sdata->local->mtx);
 	cfg80211_cac_event(sdata->dev, &chandef,
 			   NL80211_RADAR_CAC_FINISHED,
 			   GFP_KERNEL);
@@ -1747,7 +1751,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	ifmgd->have_beacon = false;
 
 	ifmgd->flags = 0;
+	mutex_lock(&local->mtx);
 	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&local->mtx);
 
 	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
 }
@@ -2070,7 +2076,9 @@ static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
 		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 		sdata->u.mgd.flags = 0;
+		mutex_lock(&sdata->local->mtx);
 		ieee80211_vif_release_channel(sdata);
+		mutex_unlock(&sdata->local->mtx);
 	}
 
 	cfg80211_put_bss(sdata->local->hw.wiphy, auth_data->bss);
@@ -2319,7 +2327,9 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
 		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 		sdata->u.mgd.flags = 0;
+		mutex_lock(&sdata->local->mtx);
 		ieee80211_vif_release_channel(sdata);
+		mutex_unlock(&sdata->local->mtx);
 	}
 
 	kfree(assoc_data);
@@ -3670,6 +3680,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	/* will change later if needed */
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 
+	mutex_lock(&local->mtx);
 	/*
 	 * If this fails (possibly due to channel context sharing
 	 * on incompatible channels, e.g. 80+80 and 160 sharing the
@@ -3681,13 +3692,15 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	/* don't downgrade for 5 and 10 MHz channels, though. */
 	if (chandef.width == NL80211_CHAN_WIDTH_5 ||
 	    chandef.width == NL80211_CHAN_WIDTH_10)
-		return ret;
+		goto out;
 
 	while (ret && chandef.width != NL80211_CHAN_WIDTH_20_NOHT) {
 		ifmgd->flags |= ieee80211_chandef_downgrade(&chandef);
 		ret = ieee80211_vif_use_channel(sdata, &chandef,
 						IEEE80211_CHANCTX_SHARED);
 	}
+ out:
+	mutex_unlock(&local->mtx);
 	return ret;
 }
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 656648b..bc3685e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2315,6 +2315,7 @@ void ieee80211_dfs_cac_cancel(struct ieee80211_local *local)
 	struct ieee80211_sub_if_data *sdata;
 	struct cfg80211_chan_def chandef;
 
+	mutex_lock(&local->mtx);
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
@@ -2329,6 +2330,7 @@ void ieee80211_dfs_cac_cancel(struct ieee80211_local *local)
 		}
 	}
 	mutex_unlock(&local->iflist_mtx);
+	mutex_unlock(&local->mtx);
 }
 
 void ieee80211_dfs_radar_detected_work(struct work_struct *work)
-- 
1.8.5.1

