Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51747 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab3LEMgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 07:36:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/8] mac80211: don't delay station destruction
Date: Thu,  5 Dec 2013 13:35:52 +0100
Message-Id: <1386246956-14257-5-git-send-email-johannes@sipsolutions.net> (sfid-20131205_133611_081370_7286B45F)
In-Reply-To: <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
 <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If we can assume that stations are never referenced by the
driver after sta_state returns (and this is true since the
previous iwlmvm patch and for all other drivers) then we
don't need to delay station destruction, and don't need to
play tricks with rcu_barrier() etc.

This should speed up some scenarios like hostapd shutdown.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         | 10 +++-----
 net/mac80211/ieee80211_i.h |  4 ----
 net/mac80211/iface.c       | 27 ++++-----------------
 net/mac80211/mlme.c        |  2 +-
 net/mac80211/pm.c          |  3 +--
 net/mac80211/sta_info.c    | 58 ++--------------------------------------------
 net/mac80211/sta_info.h    | 27 +--------------------
 7 files changed, 12 insertions(+), 119 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 754069c..f47c7c0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1098,15 +1098,11 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		kfree_rcu(old_probe_resp, rcu_head);
 
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
-		sta_info_flush_defer(vlan);
-	sta_info_flush_defer(sdata);
+		sta_info_flush(vlan);
+	sta_info_flush(sdata);
 	synchronize_net();
-	rcu_barrier();
-	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
-		sta_info_flush_cleanup(vlan);
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		ieee80211_free_keys(vlan);
-	}
-	sta_info_flush_cleanup(sdata);
 	ieee80211_free_keys(sdata);
 
 	sdata->vif.bss_conf.enable_beacon = false;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8cd84ce..2251111 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -800,10 +800,6 @@ struct ieee80211_sub_if_data {
 		u32 mntr_flags;
 	} u;
 
-	spinlock_t cleanup_stations_lock;
-	struct list_head cleanup_stations;
-	struct work_struct cleanup_stations_wk;
-
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct {
 		struct dentry *subdir_stations;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3e5c89a..c5e9a11 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -786,10 +786,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	 * This is relevant only in WDS mode, in all other modes we've
 	 * already removed all stations when disconnecting or similar,
 	 * so warn otherwise.
-	 *
-	 * We call sta_info_flush_cleanup() later, to combine RCU waits.
 	 */
-	flushed = sta_info_flush_defer(sdata);
+	flushed = sta_info_flush(sdata);
 	WARN_ON_ONCE((sdata->vif.type != NL80211_IFTYPE_WDS && flushed > 0) ||
 		     (sdata->vif.type == NL80211_IFTYPE_WDS && flushed != 1));
 
@@ -892,16 +890,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		/*
 		 * When we get here, the interface is marked down.
 		 *
-		 * sta_info_flush_cleanup() requires rcu_barrier()
-		 * first to wait for the station call_rcu() calls
-		 * to complete, and we also need synchronize_rcu()
-		 * to wait for the RX path in case it is using the
-		 * interface and enqueuing frames at this very time on
-		 * another CPU.
+		 * We need synchronize_rcu() to wait for the RX path in
+		 * case it is using the interface and enqueuing frames
+		 * at this very time on another CPU.
 		 */
 		synchronize_rcu();
-		rcu_barrier();
-		sta_info_flush_cleanup(sdata);
 
 		/*
 		 * Free all remaining keys, there shouldn't be any,
@@ -1569,15 +1562,6 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
-static void ieee80211_cleanup_sdata_stas_wk(struct work_struct *wk)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	sdata = container_of(wk, struct ieee80211_sub_if_data, cleanup_stations_wk);
-
-	ieee80211_cleanup_sdata_stas(sdata);
-}
-
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct wireless_dev **new_wdev, enum nl80211_iftype type,
 		     struct vif_params *params)
@@ -1650,9 +1634,6 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 	INIT_LIST_HEAD(&sdata->key_list);
 
-	spin_lock_init(&sdata->cleanup_stations_lock);
-	INIT_LIST_HEAD(&sdata->cleanup_stations);
-	INIT_WORK(&sdata->cleanup_stations_wk, ieee80211_cleanup_sdata_stas_wk);
 	INIT_DELAYED_WORK(&sdata->dfs_cac_timer_work,
 			  ieee80211_dfs_cac_timer_work);
 	INIT_DELAYED_WORK(&sdata->dec_tailroom_needed_wk,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dcec1bd..37b09d2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1698,7 +1698,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	memset(ifmgd->bssid, 0, ETH_ALEN);
 
 	/* remove AP and TDLS peers */
-	sta_info_flush_defer(sdata);
+	sta_info_flush(sdata);
 
 	/* finally reset all BSS / config parameters */
 	changed |= ieee80211_reset_erp_info(sdata);
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 3401262..af64fb8 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -37,9 +37,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
-	/* flush out all packets and station cleanup call_rcu()s */
+	/* flush out all packets */
 	synchronize_net();
-	rcu_barrier();
 
 	ieee80211_flush_queues(local, NULL);
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 557ac25..7241f322 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -99,23 +99,6 @@ static void cleanup_single_sta(struct sta_info *sta)
 	struct ieee80211_local *local = sdata->local;
 	struct ps_data *ps;
 
-	/*
-	 * At this point, when being called as call_rcu callback,
-	 * neither mac80211 nor the driver can reference this
-	 * sta struct any more except by still existing timers
-	 * associated with this station that we clean up below.
-	 *
-	 * Note though that this still uses the sdata and even
-	 * calls the driver in AP and mesh mode, so interfaces
-	 * of those types mush use call sta_info_flush_cleanup()
-	 * (typically via sta_info_flush()) before deconfiguring
-	 * the driver.
-	 *
-	 * In station mode, nothing happens here so it doesn't
-	 * have to (and doesn't) do that, this is intentional to
-	 * speed up roaming.
-	 */
-
 	if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
 		if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
 		    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -160,37 +143,6 @@ static void cleanup_single_sta(struct sta_info *sta)
 	sta_info_free(local, sta);
 }
 
-void ieee80211_cleanup_sdata_stas(struct ieee80211_sub_if_data *sdata)
-{
-	struct sta_info *sta;
-
-	spin_lock_bh(&sdata->cleanup_stations_lock);
-	while (!list_empty(&sdata->cleanup_stations)) {
-		sta = list_first_entry(&sdata->cleanup_stations,
-				       struct sta_info, list);
-		list_del(&sta->list);
-		spin_unlock_bh(&sdata->cleanup_stations_lock);
-
-		cleanup_single_sta(sta);
-
-		spin_lock_bh(&sdata->cleanup_stations_lock);
-	}
-
-	spin_unlock_bh(&sdata->cleanup_stations_lock);
-}
-
-static void free_sta_rcu(struct rcu_head *h)
-{
-	struct sta_info *sta = container_of(h, struct sta_info, rcu_head);
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-
-	spin_lock(&sdata->cleanup_stations_lock);
-	list_add_tail(&sta->list, &sdata->cleanup_stations);
-	spin_unlock(&sdata->cleanup_stations_lock);
-
-	ieee80211_queue_work(&sdata->local->hw, &sdata->cleanup_stations_wk);
-}
-
 /* protected by RCU */
 struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr)
@@ -909,7 +861,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	ieee80211_sta_debugfs_remove(sta);
 	ieee80211_recalc_min_chandef(sdata);
 
-	call_rcu(&sta->rcu_head, free_sta_rcu);
+	cleanup_single_sta(sta);
 
 	return 0;
 }
@@ -979,7 +931,7 @@ void sta_info_stop(struct ieee80211_local *local)
 }
 
 
-int sta_info_flush_defer(struct ieee80211_sub_if_data *sdata)
+int sta_info_flush(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta, *tmp;
@@ -999,12 +951,6 @@ int sta_info_flush_defer(struct ieee80211_sub_if_data *sdata)
 	return ret;
 }
 
-void sta_info_flush_cleanup(struct ieee80211_sub_if_data *sdata)
-{
-	ieee80211_cleanup_sdata_stas(sdata);
-	cancel_work_sync(&sdata->cleanup_stations_wk);
-}
-
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time)
 {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 0218caf..9104f81 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -605,21 +605,6 @@ void sta_info_recalc_tim(struct sta_info *sta);
 
 void sta_info_init(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
-int sta_info_flush_defer(struct ieee80211_sub_if_data *sdata);
-
-/**
- * sta_info_flush_cleanup - flush the sta_info cleanup queue
- * @sdata: the interface
- *
- * Flushes the sta_info cleanup queue for a given interface;
- * this is necessary before the interface is removed or, for
- * AP/mesh interfaces, before it is deconfigured.
- *
- * Note an rcu_barrier() must precede the function, after all
- * stations have been flushed/removed to ensure the call_rcu()
- * calls that add stations to the cleanup queue have completed.
- */
-void sta_info_flush_cleanup(struct ieee80211_sub_if_data *sdata);
 
 /**
  * sta_info_flush - flush matching STA entries from the STA table
@@ -628,15 +613,7 @@ void sta_info_flush_cleanup(struct ieee80211_sub_if_data *sdata);
  *
  * @sdata: sdata to remove all stations from
  */
-static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata)
-{
-	int ret = sta_info_flush_defer(sdata);
-
-	rcu_barrier();
-	sta_info_flush_cleanup(sdata);
-
-	return ret;
-}
+int sta_info_flush(struct ieee80211_sub_if_data *sdata);
 
 void sta_set_rate_info_tx(struct sta_info *sta,
 			  const struct ieee80211_tx_rate *rate,
@@ -651,6 +628,4 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
 
-void ieee80211_cleanup_sdata_stas(struct ieee80211_sub_if_data *sdata);
-
 #endif /* STA_INFO_H */
-- 
1.8.4.rc3

