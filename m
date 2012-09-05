Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36859 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2IERX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 13:23:56 -0400
Received: by wibhr14 with SMTP id hr14so441230wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2012 10:23:55 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: use call_rcu() on sta deletion
Date: Wed,  5 Sep 2012 20:23:57 +0300
Message-Id: <1346865837-32265-3-git-send-email-eliad@wizery.com> (sfid-20120905_192359_784842_1A2440E5)
In-Reply-To: <1346865837-32265-1-git-send-email-eliad@wizery.com>
References: <1346865837-32265-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 calls synchronize_rcu() on sta deletion,
which increase the roaming time significantly.

Convert it into a call_rcu() mechanism, in order
to avoid blocking. Since some of the cleanup
functions might sleep, schedule from the call_rcu
callback a new work that will do the actual cleanup.

In order to make sure the cleanup occurs before
the interface went down, flush local->workqueue
on ieee80211_do_stop().

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/iface.c    |    4 ++
 net/mac80211/sta_info.c |  121 ++++++++++++++++++++++++++---------------------
 net/mac80211/sta_info.h |    2 +
 3 files changed, 73 insertions(+), 54 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 513b85e..d13bde4 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -774,6 +774,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		 * frames at this very time on another CPU.
 		 */
 		synchronize_rcu();
+
+		/* flush any remaining cleanup work */
+		flush_workqueue(local->workqueue);
+
 		skb_queue_purge(&sdata->skb_queue);
 
 		/*
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 06fa75c..354326d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -91,6 +91,70 @@ static int sta_info_hash_del(struct ieee80211_local *local,
 	return -ENOENT;
 }
 
+static void free_sta_work(struct work_struct *wk)
+{
+	struct sta_info *sta = container_of(wk, struct sta_info, free_sta_wk);
+	int ac, i;
+	struct tid_ampdu_tx *tid_tx;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+
+	/*
+	 * At this point, after we wait for an RCU grace period,
+	 * neither mac80211 nor the driver can reference this
+	 * sta struct any more except by still existing timers
+	 * associated with this station that we clean up below.
+	 */
+
+	if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
+		BUG_ON(!sdata->bss);
+
+		clear_sta_flag(sta, WLAN_STA_PS_STA);
+
+		atomic_dec(&sdata->bss->num_sta_ps);
+		sta_info_recalc_tim(sta);
+	}
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		local->total_ps_buffered -= skb_queue_len(&sta->ps_tx_buf[ac]);
+		__skb_queue_purge(&sta->ps_tx_buf[ac]);
+		__skb_queue_purge(&sta->tx_filtered[ac]);
+	}
+
+#ifdef CONFIG_MAC80211_MESH
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		mesh_accept_plinks_update(sdata);
+		mesh_plink_deactivate(sta);
+		del_timer_sync(&sta->plink_timer);
+	}
+#endif
+
+	cancel_work_sync(&sta->drv_unblock_wk);
+
+	/*
+	 * Destroy aggregation state here. It would be nice to wait for the
+	 * driver to finish aggregation stop and then clean up, but for now
+	 * drivers have to handle aggregation stop being requested, followed
+	 * directly by station destruction.
+	 */
+	for (i = 0; i < STA_TID_NUM; i++) {
+		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
+		if (!tid_tx)
+			continue;
+		__skb_queue_purge(&tid_tx->pending);
+		kfree(tid_tx);
+	}
+
+	sta_info_free(local, sta);
+}
+
+static void free_sta_rcu(struct rcu_head *h)
+{
+	struct sta_info *sta = container_of(h, struct sta_info, rcu_head);
+
+	ieee80211_queue_work(&sta->local->hw, &sta->free_sta_wk);
+}
+
 /* protected by RCU */
 struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr)
@@ -241,6 +305,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	spin_lock_init(&sta->lock);
 	INIT_WORK(&sta->drv_unblock_wk, sta_unblock);
+	INIT_WORK(&sta->free_sta_wk, free_sta_work);
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
 	mutex_init(&sta->ampdu_mlme.mtx);
 
@@ -654,8 +719,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
-	int ret, i, ac;
-	struct tid_ampdu_tx *tid_tx;
+	int ret, i;
 
 	might_sleep();
 
@@ -711,65 +775,14 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 		WARN_ON_ONCE(ret != 0);
 	}
 
-	/*
-	 * At this point, after we wait for an RCU grace period,
-	 * neither mac80211 nor the driver can reference this
-	 * sta struct any more except by still existing timers
-	 * associated with this station that we clean up below.
-	 */
-	synchronize_rcu();
-
-	if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
-		BUG_ON(!sdata->bss);
-
-		clear_sta_flag(sta, WLAN_STA_PS_STA);
-
-		atomic_dec(&sdata->bss->num_sta_ps);
-		sta_info_recalc_tim(sta);
-	}
-
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		local->total_ps_buffered -= skb_queue_len(&sta->ps_tx_buf[ac]);
-		__skb_queue_purge(&sta->ps_tx_buf[ac]);
-		__skb_queue_purge(&sta->tx_filtered[ac]);
-	}
-
-#ifdef CONFIG_MAC80211_MESH
-	if (ieee80211_vif_is_mesh(&sdata->vif))
-		mesh_accept_plinks_update(sdata);
-#endif
-
 	sta_dbg(sdata, "Removed STA %pM\n", sta->sta.addr);
 
-	cancel_work_sync(&sta->drv_unblock_wk);
-
 	cfg80211_del_sta(sdata->dev, sta->sta.addr, GFP_KERNEL);
 
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
 
-#ifdef CONFIG_MAC80211_MESH
-	if (ieee80211_vif_is_mesh(&sta->sdata->vif)) {
-		mesh_plink_deactivate(sta);
-		del_timer_sync(&sta->plink_timer);
-	}
-#endif
-
-	/*
-	 * Destroy aggregation state here. It would be nice to wait for the
-	 * driver to finish aggregation stop and then clean up, but for now
-	 * drivers have to handle aggregation stop being requested, followed
-	 * directly by station destruction.
-	 */
-	for (i = 0; i < STA_TID_NUM; i++) {
-		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
-		if (!tid_tx)
-			continue;
-		__skb_queue_purge(&tid_tx->pending);
-		kfree(tid_tx);
-	}
-
-	sta_info_free(local, sta);
+	call_rcu(&sta->rcu_head, free_sta_rcu);
 
 	return 0;
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index a470e11..c88f161f 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -287,6 +287,7 @@ struct sta_ampdu_mlme {
 struct sta_info {
 	/* General information, mostly static */
 	struct list_head list;
+	struct rcu_head rcu_head;
 	struct sta_info __rcu *hnext;
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
@@ -297,6 +298,7 @@ struct sta_info {
 	spinlock_t lock;
 
 	struct work_struct drv_unblock_wk;
+	struct work_struct free_sta_wk;
 
 	u16 listen_interval;
 
-- 
1.7.6.401.g6a319

