Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46501 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257Ab0BCNAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 08:00:05 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Nceps-00064v-Ij
	for linux-wireless@vger.kernel.org; Wed, 03 Feb 2010 14:00:04 +0100
Subject: [RFC/RFT] mac80211: allow station add/remove to sleep
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 13:59:58 +0100
Message-ID: <1265201998.29119.91.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many drivers would like to sleep during station
addition and removal, and currently have a high
complexity there from not being able to.

This introduces two new callbacks sta_add() and
sta_remove() that drivers can implement instead
of using sta_notify() and that can sleep, and
the new sta_add() callback is also allowed to
fail.

The reason we didn't do this previously is that
the IBSS code wants to insert stations from the
RX path, which is a tasklet, so cannot sleep.
This patch will keep the station allocation in
that path, but moves adding the station to the
driver out of line. Since the addition can now
fail, we can have IBSS peer structs the driver
rejected -- in that case we still talk to the
station but never tell the driver about it in
the control.sta pointer. If there will ever be
a driver that has a low limit on the number of
stations and that cannot talk to any stations
that are not known to it, we need to do come up
with a new strategy of handling larger IBSSs,
maybe quicker expiry or rejecting peers.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h      |   21 -
 net/mac80211/cfg.c          |   23 -
 net/mac80211/driver-ops.h   |   34 ++
 net/mac80211/driver-trace.h |   52 +++
 net/mac80211/ibss.c         |   22 -
 net/mac80211/ieee80211_i.h  |   18 -
 net/mac80211/mesh_plink.c   |   17 -
 net/mac80211/mlme.c         |   14 
 net/mac80211/pm.c           |   10 
 net/mac80211/rx.c           |    4 
 net/mac80211/sta_info.c     |  735 +++++++++++++++++++++-----------------------
 net/mac80211/sta_info.h     |   32 -
 net/mac80211/tx.c           |    2 
 net/mac80211/util.c         |   16 
 14 files changed, 528 insertions(+), 472 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-02-03 13:56:31.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-02-03 13:56:40.000000000 +0100
@@ -688,15 +688,18 @@ struct ieee80211_local {
 
 	/* Station data */
 	/*
-	 * The lock only protects the list, hash, timer and counter
-	 * against manipulation, reads are done in RCU. Additionally,
-	 * the lock protects each BSS's TIM bitmap.
+	 * The mutex only protects the list and counter,
+	 * reads are done in RCU.
+	 * Additionally, the lock protects the hash table,
+	 * the pending list and each BSS's TIM bitmap.
 	 */
+	struct mutex sta_mtx;
 	spinlock_t sta_lock;
 	unsigned long num_sta;
-	struct list_head sta_list;
+	struct list_head sta_list, sta_pending_list;
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
+	struct work_struct sta_finish_work;
 	int sta_generation;
 
 	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
@@ -770,10 +773,6 @@ struct ieee80211_local {
 	     assoc_led_name[32], radio_led_name[32];
 #endif
 
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct work_struct sta_debugfs_add;
-#endif
-
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	/* TX/RX handler statistics */
 	unsigned int tx_handlers_drop;
@@ -985,7 +984,8 @@ void ieee80211_ibss_setup_sdata(struct i
 ieee80211_rx_result
 ieee80211_ibss_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid, u8 *addr, u32 supp_rates);
+					u8 *bssid, u8 *addr, u32 supp_rates,
+					gfp_t gfp);
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params);
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
--- wireless-testing.orig/net/mac80211/pm.c	2010-02-03 13:56:30.000000000 +0100
+++ wireless-testing/net/mac80211/pm.c	2010-02-03 13:56:40.000000000 +0100
@@ -11,7 +11,6 @@ int __ieee80211_suspend(struct ieee80211
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
-	unsigned long flags;
 
 	ieee80211_scan_cancel(local);
 
@@ -55,22 +54,21 @@ int __ieee80211_suspend(struct ieee80211
 	rcu_read_unlock();
 
 	/* remove STAs */
-	spin_lock_irqsave(&local->sta_lock, flags);
+	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
-		if (local->ops->sta_notify) {
+		if (sta->uploaded) {
 			sdata = sta->sdata;
 			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 				sdata = container_of(sdata->bss,
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
-			drv_sta_notify(local, sdata, STA_NOTIFY_REMOVE,
-				       &sta->sta);
+			drv_sta_remove(local, sdata, &sta->sta);
 		}
 
 		mesh_plink_quiesce(sta);
 	}
-	spin_unlock_irqrestore(&local->sta_lock, flags);
+	mutex_unlock(&local->sta_mtx);
 
 	/* remove all interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
--- wireless-testing.orig/net/mac80211/sta_info.c	2010-02-03 13:56:30.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2010-02-03 13:56:40.000000000 +0100
@@ -32,49 +32,33 @@
  * for faster lookup and a list for iteration. They are managed using
  * RCU, i.e. access to the list and hash table is protected by RCU.
  *
- * Upon allocating a STA info structure with sta_info_alloc(), the caller owns
- * that structure. It must then either destroy it using sta_info_destroy()
- * (which is pretty useless) or insert it into the hash table using
- * sta_info_insert() which demotes the reference from ownership to a regular
- * RCU-protected reference; if the function is called without protection by an
- * RCU critical section the reference is instantly invalidated. Note that the
- * caller may not do much with the STA info before inserting it, in particular,
- * it may not start any mesh peer link management or add encryption keys.
+ * Upon allocating a STA info structure with sta_info_alloc(), the caller
+ * owns that structure. It must then insert it into the hash table using
+ * either sta_info_insert() or sta_info_insert_rcu(); only in the latter
+ * case (which acquires an rcu read section but must not be called from
+ * within one) will the pointer still be valid after the call. Note that
+ * the caller may not do much with the STA info before inserting it, in
+ * particular, it may not start any mesh peer link management or add
+ * encryption keys.
  *
  * When the insertion fails (sta_info_insert()) returns non-zero), the
  * structure will have been freed by sta_info_insert()!
  *
- * sta entries are added by mac80211 when you establish a link with a
+ * Station entries are added by mac80211 when you establish a link with a
  * peer. This means different things for the different type of interfaces
  * we support. For a regular station this mean we add the AP sta when we
  * receive an assocation response from the AP. For IBSS this occurs when
- * we receive a probe response or a beacon from target IBSS network. For
- * WDS we add the sta for the peer imediately upon device open. When using
- * AP mode we add stations for each respective station upon request from
- * userspace through nl80211.
- *
- * Because there are debugfs entries for each station, and adding those
- * must be able to sleep, it is also possible to "pin" a station entry,
- * that means it can be removed from the hash table but not be freed.
- * See the comment in __sta_info_unlink() for more information, this is
- * an internal capability only.
- *
- * In order to remove a STA info structure, the caller needs to first
- * unlink it (sta_info_unlink()) from the list and hash tables and
- * then destroy it; sta_info_destroy() will wait for an RCU grace period
- * to elapse before actually freeing it. Due to the pinning and the
- * possibility of multiple callers trying to remove the same STA info at
- * the same time, sta_info_unlink() can clear the STA info pointer it is
- * passed to indicate that the STA info is owned by somebody else now.
- *
- * If sta_info_unlink() did not clear the pointer then the caller owns
- * the STA info structure now and is responsible of destroying it with
- * a call to sta_info_destroy().
- *
- * In all other cases, there is no concept of ownership on a STA entry,
- * each structure is owned by the global hash table/list until it is
- * removed. All users of the structure need to be RCU protected so that
- * the structure won't be freed before they are done using it.
+ * get to know about a peer on the same IBSS. For WDS we add the sta for
+ * the peer imediately upon device open. When using AP mode we add stations
+ * for each respective station upon request from userspace through nl80211.
+ *
+ * In order to remove a STA info structure, various sta_info_destroy_*()
+ * calls are available.
+ *
+ * There is no concept of ownership on a STA entry, each structure is
+ * owned by the global hash table/list until it is removed. All users of
+ * the structure need to be RCU protected so that the structure won't be
+ * freed before they are done using it.
  */
 
 /* Caller must hold local->sta_lock */
@@ -185,101 +169,6 @@ static void __sta_info_free(struct ieee8
 	kfree(sta);
 }
 
-void sta_info_destroy(struct sta_info *sta)
-{
-	struct ieee80211_local *local;
-	struct sk_buff *skb;
-	int i;
-
-	might_sleep();
-
-	if (!sta)
-		return;
-
-	local = sta->local;
-
-	cancel_work_sync(&sta->drv_unblock_wk);
-
-	rate_control_remove_sta_debugfs(sta);
-	ieee80211_sta_debugfs_remove(sta);
-
-#ifdef CONFIG_MAC80211_MESH
-	if (ieee80211_vif_is_mesh(&sta->sdata->vif))
-		mesh_plink_deactivate(sta);
-#endif
-
-	/*
-	 * We have only unlinked the key, and actually destroying it
-	 * may mean it is removed from hardware which requires that
-	 * the key->sta pointer is still valid, so flush the key todo
-	 * list here.
-	 *
-	 * ieee80211_key_todo() will synchronize_rcu() so after this
-	 * nothing can reference this sta struct any more.
-	 */
-	ieee80211_key_todo();
-
-#ifdef CONFIG_MAC80211_MESH
-	if (ieee80211_vif_is_mesh(&sta->sdata->vif))
-		del_timer_sync(&sta->plink_timer);
-#endif
-
-	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
-		local->total_ps_buffered--;
-		dev_kfree_skb_any(skb);
-	}
-
-	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL)
-		dev_kfree_skb_any(skb);
-
-	for (i = 0; i <  STA_TID_NUM; i++) {
-		struct tid_ampdu_rx *tid_rx;
-		struct tid_ampdu_tx *tid_tx;
-
-		spin_lock_bh(&sta->lock);
-		tid_rx = sta->ampdu_mlme.tid_rx[i];
-		/* Make sure timer won't free the tid_rx struct, see below */
-		if (tid_rx)
-			tid_rx->shutdown = true;
-
-		spin_unlock_bh(&sta->lock);
-
-		/*
-		 * Outside spinlock - shutdown is true now so that the timer
-		 * won't free tid_rx, we have to do that now. Can't let the
-		 * timer do it because we have to sync the timer outside the
-		 * lock that it takes itself.
-		 */
-		if (tid_rx) {
-			del_timer_sync(&tid_rx->session_timer);
-			kfree(tid_rx);
-		}
-
-		/*
-		 * No need to do such complications for TX agg sessions, the
-		 * path leading to freeing the tid_tx struct goes via a call
-		 * from the driver, and thus needs to look up the sta struct
-		 * again, which cannot be found when we get here. Hence, we
-		 * just need to delete the timer and free the aggregation
-		 * info; we won't be telling the peer about it then but that
-		 * doesn't matter if we're not talking to it again anyway.
-		 */
-		tid_tx = sta->ampdu_mlme.tid_tx[i];
-		if (tid_tx) {
-			del_timer_sync(&tid_tx->addba_resp_timer);
-			/*
-			 * STA removed while aggregation session being
-			 * started? Bit odd, but purge frames anyway.
-			 */
-			skb_queue_purge(&tid_tx->pending);
-			kfree(tid_tx);
-		}
-	}
-
-	__sta_info_free(local, sta);
-}
-
-
 /* Caller must hold local->sta_lock */
 static void sta_info_hash_add(struct ieee80211_local *local,
 			      struct sta_info *sta)
@@ -376,7 +265,7 @@ struct sta_info *sta_info_alloc(struct i
 	return sta;
 }
 
-int sta_info_insert(struct sta_info *sta)
+static int sta_info_finish_insert(struct sta_info *sta, bool async)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -384,6 +273,91 @@ int sta_info_insert(struct sta_info *sta
 	unsigned long flags;
 	int err = 0;
 
+	WARN_ON(!mutex_is_locked(&local->sta_mtx));
+
+	/* notify driver */
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		sdata = container_of(sdata->bss,
+				     struct ieee80211_sub_if_data,
+				     u.ap);
+	err = drv_sta_add(local, sdata, &sta->sta);
+	if (err) {
+		if (!async)
+			return err;
+		printk(KERN_DEBUG "%s: failed to add IBSS STA %pM to driver (%d)"
+				  " - keeping it anyway.\n",
+		       sdata->name, sta->sta.addr, err);
+	} else {
+		sta->uploaded = true;
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+		if (async)
+			printk(KERN_DEBUG "%s: Finished adding IBSS STA %pM\n",
+			       wiphy_name(local->hw.wiphy), sta->sta.addr);
+#endif
+	}
+
+	sdata = sta->sdata;
+
+	if (!async) {
+		local->num_sta++;
+		local->sta_generation++;
+		smp_mb();
+
+		/* make the station visible */
+		spin_lock_irqsave(&local->sta_lock, flags);
+		sta_info_hash_add(local, sta);
+		spin_unlock_irqrestore(&local->sta_lock, flags);
+	}
+
+	list_add(&sta->list, &local->sta_list);
+
+	ieee80211_sta_debugfs_add(sta);
+	rate_control_add_sta_debugfs(sta);
+
+	sinfo.filled = 0;
+	sinfo.generation = local->sta_generation;
+	cfg80211_new_sta(sdata->dev, sta->sta.addr, &sinfo, GFP_KERNEL);
+
+
+	return 0;
+}
+
+static void sta_info_finish_pending(struct ieee80211_local *local)
+{
+	struct sta_info *sta;
+	unsigned long flags;
+
+	spin_lock_irqsave(&local->sta_lock, flags);
+	while (!list_empty(&local->sta_pending_list)) {
+		sta = list_first_entry(&local->sta_pending_list,
+				       struct sta_info, list);
+		list_del(&sta->list);
+		spin_unlock_irqrestore(&local->sta_lock, flags);
+
+		sta_info_finish_insert(sta, true);
+
+		spin_lock_irqsave(&local->sta_lock, flags);
+	}
+	spin_unlock_irqrestore(&local->sta_lock, flags);
+}
+
+static void sta_info_finish_work(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, sta_finish_work);
+
+	mutex_lock(&local->sta_mtx);
+	sta_info_finish_pending(local);
+	mutex_unlock(&local->sta_mtx);
+}
+
+int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
+{
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	unsigned long flags;
+	int err = 0;
+
 	/*
 	 * Can't be a WARN_ON because it can be triggered through a race:
 	 * something inserts a STA (on one CPU) without holding the RTNL
@@ -391,36 +365,87 @@ int sta_info_insert(struct sta_info *sta
 	 */
 	if (unlikely(!ieee80211_sdata_running(sdata))) {
 		err = -ENETDOWN;
+		rcu_read_lock();
 		goto out_free;
 	}
 
 	if (WARN_ON(compare_ether_addr(sta->sta.addr, sdata->vif.addr) == 0 ||
 		    is_multicast_ether_addr(sta->sta.addr))) {
 		err = -EINVAL;
+		rcu_read_lock();
 		goto out_free;
 	}
 
+	/*
+	 * In ad-hoc mode, we sometimes need to insert stations
+	 * from tasklet context from the RX path. To avoid races,
+	 * always do so in that case -- see the comment below.
+	 */
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		spin_lock_irqsave(&local->sta_lock, flags);
+		/* check if STA exists already */
+		if (sta_info_get_bss(sdata, sta->sta.addr)) {
+			spin_unlock_irqrestore(&local->sta_lock, flags);
+			rcu_read_lock();
+			err = -EEXIST;
+			goto out_free;
+		}
+
+		local->num_sta++;
+		local->sta_generation++;
+		smp_mb();
+		sta_info_hash_add(local, sta);
+
+		list_add_tail(&sta->list, &local->sta_pending_list);
+
+		rcu_read_lock();
+		spin_unlock_irqrestore(&local->sta_lock, flags);
+
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+		printk(KERN_DEBUG "%s: Added IBSS STA %pM\n",
+		       wiphy_name(local->hw.wiphy), sta->sta.addr);
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+
+		ieee80211_queue_work(&local->hw, &local->sta_finish_work);
+
+		return 0;
+	}
+
+	/*
+	 * On first glance, this will look racy, because the code
+	 * below this point, which inserts a station with sleeping,
+	 * unlocks the sta_lock between checking existence in the
+	 * hash table and inserting into it.
+	 *
+	 * However, it is not racy against itself because it keeps
+	 * the mutex locked. It still seems to race against the
+	 * above code that atomically inserts the station... That,
+	 * however, is not true because the above code can only
+	 * be invoked for IBSS interfaces, and the below code will
+	 * not be -- and the two do not race against each other as
+	 * the hash table also keys off the interface.
+	 */
+
+	might_sleep();
+
+	mutex_lock(&local->sta_mtx);
+
 	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
-	if (sta_info_get(sdata, sta->sta.addr)) {
+	if (sta_info_get_bss(sdata, sta->sta.addr)) {
 		spin_unlock_irqrestore(&local->sta_lock, flags);
+		rcu_read_lock();
 		err = -EEXIST;
 		goto out_free;
 	}
-	list_add(&sta->list, &local->sta_list);
-	local->sta_generation++;
-	local->num_sta++;
-	sta_info_hash_add(local, sta);
 
-	/* notify driver */
-	if (local->ops->sta_notify) {
-		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-			sdata = container_of(sdata->bss,
-					     struct ieee80211_sub_if_data,
-					     u.ap);
+	spin_unlock_irqrestore(&local->sta_lock, flags);
 
-		drv_sta_notify(local, sdata, STA_NOTIFY_ADD, &sta->sta);
-		sdata = sta->sdata;
+	err = sta_info_finish_insert(sta, false);
+	if (err) {
+		mutex_unlock(&local->sta_mtx);
+		rcu_read_lock();
+		goto out_free;
 	}
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -428,22 +453,9 @@ int sta_info_insert(struct sta_info *sta
 	       wiphy_name(local->hw.wiphy), sta->sta.addr);
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
-	spin_unlock_irqrestore(&local->sta_lock, flags);
-
-	sinfo.filled = 0;
-	sinfo.generation = local->sta_generation;
-	cfg80211_new_sta(sdata->dev, sta->sta.addr, &sinfo, GFP_ATOMIC);
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	/*
-	 * Debugfs entry adding might sleep, so schedule process
-	 * context task for adding entry for STAs that do not yet
-	 * have one.
-	 * NOTE: due to auto-freeing semantics this may only be done
-	 *       if the insertion is successful!
-	 */
-	schedule_work(&local->sta_debugfs_add);
-#endif
+	/* move reference to rcu-protected */
+	rcu_read_lock();
+	mutex_unlock(&local->sta_mtx);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
@@ -455,6 +467,15 @@ int sta_info_insert(struct sta_info *sta
 	return err;
 }
 
+int sta_info_insert(struct sta_info *sta)
+{
+	int err = sta_info_insert_rcu(sta);
+
+	rcu_read_unlock();
+
+	return err;
+}
+
 static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
 {
 	/*
@@ -523,108 +544,6 @@ void sta_info_clear_tim_bit(struct sta_i
 	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
 }
 
-static void __sta_info_unlink(struct sta_info **sta)
-{
-	struct ieee80211_local *local = (*sta)->local;
-	struct ieee80211_sub_if_data *sdata = (*sta)->sdata;
-	/*
-	 * pull caller's reference if we're already gone.
-	 */
-	if (sta_info_hash_del(local, *sta)) {
-		*sta = NULL;
-		return;
-	}
-
-	if ((*sta)->key) {
-		ieee80211_key_free((*sta)->key);
-		WARN_ON((*sta)->key);
-	}
-
-	list_del(&(*sta)->list);
-	(*sta)->dead = true;
-
-	if (test_and_clear_sta_flags(*sta,
-				WLAN_STA_PS_STA | WLAN_STA_PS_DRIVER)) {
-		BUG_ON(!sdata->bss);
-
-		atomic_dec(&sdata->bss->num_sta_ps);
-		__sta_info_clear_tim_bit(sdata->bss, *sta);
-	}
-
-	local->num_sta--;
-	local->sta_generation++;
-
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		rcu_assign_pointer(sdata->u.vlan.sta, NULL);
-
-	if (local->ops->sta_notify) {
-		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-			sdata = container_of(sdata->bss,
-					     struct ieee80211_sub_if_data,
-					     u.ap);
-
-		drv_sta_notify(local, sdata, STA_NOTIFY_REMOVE,
-			       &(*sta)->sta);
-		sdata = (*sta)->sdata;
-	}
-
-	if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		mesh_accept_plinks_update(sdata);
-#ifdef CONFIG_MAC80211_MESH
-		del_timer(&(*sta)->plink_timer);
-#endif
-	}
-
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: Removed STA %pM\n",
-	       wiphy_name(local->hw.wiphy), (*sta)->sta.addr);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-
-	/*
-	 * Finally, pull caller's reference if the STA is pinned by the
-	 * task that is adding the debugfs entries. In that case, we
-	 * leave the STA "to be freed".
-	 *
-	 * The rules are not trivial, but not too complex either:
-	 *  (1) pin_status is only modified under the sta_lock
-	 *  (2) STAs may only be pinned under the RTNL so that
-	 *	sta_info_flush() is guaranteed to actually destroy
-	 *	all STAs that are active for a given interface, this
-	 *	is required for correctness because otherwise we
-	 *	could notify a driver that an interface is going
-	 *	away and only after that (!) notify it about a STA
-	 *	on that interface going away.
-	 *  (3) sta_info_debugfs_add_work() will set the status
-	 *	to PINNED when it found an item that needs a new
-	 *	debugfs directory created. In that case, that item
-	 *	must not be freed although all *RCU* users are done
-	 *	with it. Hence, we tell the caller of _unlink()
-	 *	that the item is already gone (as can happen when
-	 *	two tasks try to unlink/destroy at the same time)
-	 *  (4) We set the pin_status to DESTROY here when we
-	 *	find such an item.
-	 *  (5) sta_info_debugfs_add_work() will reset the pin_status
-	 *	from PINNED to NORMAL when it is done with the item,
-	 *	but will check for DESTROY before resetting it in
-	 *	which case it will free the item.
-	 */
-	if ((*sta)->pin_status == STA_INFO_PIN_STAT_PINNED) {
-		(*sta)->pin_status = STA_INFO_PIN_STAT_DESTROY;
-		*sta = NULL;
-		return;
-	}
-}
-
-void sta_info_unlink(struct sta_info **sta)
-{
-	struct ieee80211_local *local = (*sta)->local;
-	unsigned long flags;
-
-	spin_lock_irqsave(&local->sta_lock, flags);
-	__sta_info_unlink(sta);
-	spin_unlock_irqrestore(&local->sta_lock, flags);
-}
-
 static int sta_info_buffer_expired(struct sta_info *sta,
 				   struct sk_buff *skb)
 {
@@ -681,109 +600,209 @@ static void sta_info_cleanup_expire_buff
 	}
 }
 
-
-static void sta_info_cleanup(unsigned long data)
+static int __must_check __sta_info_destroy(struct sta_info *sta)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *) data;
-	struct sta_info *sta;
+	struct ieee80211_local *local;
+	struct ieee80211_sub_if_data *sdata;
+	struct sk_buff *skb;
+	unsigned long flags;
+	int ret, i;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(sta, &local->sta_list, list)
-		sta_info_cleanup_expire_buffered(local, sta);
-	rcu_read_unlock();
+	might_sleep();
 
-	if (local->quiescing)
-		return;
+	if (!sta)
+		return -ENOENT;
 
-	local->sta_cleanup.expires =
-		round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL);
-	add_timer(&local->sta_cleanup);
-}
+	local = sta->local;
+	sdata = sta->sdata;
 
-#ifdef CONFIG_MAC80211_DEBUGFS
-/*
- * See comment in __sta_info_unlink,
- * caller must hold local->sta_lock.
- */
-static void __sta_info_pin(struct sta_info *sta)
-{
-	WARN_ON(sta->pin_status != STA_INFO_PIN_STAT_NORMAL);
-	sta->pin_status = STA_INFO_PIN_STAT_PINNED;
+	spin_lock_irqsave(&local->sta_lock, flags);
+	ret = sta_info_hash_del(local, sta);
+	/* this might still be the pending list ... which is fine */
+	if (!ret)
+		list_del(&sta->list);
+	spin_unlock_irqrestore(&local->sta_lock, flags);
+	if (ret)
+		return ret;
+
+	if (sta->key) {
+		ieee80211_key_free(sta->key);
+		/*
+		 * We have only unlinked the key, and actually destroying it
+		 * may mean it is removed from hardware which requires that
+		 * the key->sta pointer is still valid, so flush the key todo
+		 * list here.
+		 *
+		 * ieee80211_key_todo() will synchronize_rcu() so after this
+		 * nothing can reference this sta struct any more.
+		 */
+		ieee80211_key_todo();
+
+		WARN_ON(sta->key);
+	}
+
+	sta->dead = true;
+
+	if (test_and_clear_sta_flags(sta,
+				WLAN_STA_PS_STA | WLAN_STA_PS_DRIVER)) {
+		BUG_ON(!sdata->bss);
+
+		atomic_dec(&sdata->bss->num_sta_ps);
+		__sta_info_clear_tim_bit(sdata->bss, sta);
+	}
+
+	local->num_sta--;
+	local->sta_generation++;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		rcu_assign_pointer(sdata->u.vlan.sta, NULL);
+
+	if (sta->uploaded) {
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			sdata = container_of(sdata->bss,
+					     struct ieee80211_sub_if_data,
+					     u.ap);
+		drv_sta_remove(local, sdata, &sta->sta);
+		sdata = sta->sdata;
+	}
+
+#ifdef CONFIG_MAC80211_MESH
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		mesh_accept_plinks_update(sdata);
+		del_timer(&sta->plink_timer);
+	}
+#endif
+
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: Removed STA %pM\n",
+	       wiphy_name(local->hw.wiphy), sta->sta.addr);
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+	cancel_work_sync(&sta->drv_unblock_wk);
+
+	rate_control_remove_sta_debugfs(sta);
+	ieee80211_sta_debugfs_remove(sta);
+
+#ifdef CONFIG_MAC80211_MESH
+	if (ieee80211_vif_is_mesh(&sta->sdata->vif)) {
+		mesh_plink_deactivate(sta);
+		del_timer_sync(&sta->plink_timer);
+	}
+#endif
+
+	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
+		local->total_ps_buffered--;
+		dev_kfree_skb_any(skb);
+	}
+
+	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL)
+		dev_kfree_skb_any(skb);
+
+	for (i = 0; i <  STA_TID_NUM; i++) {
+		struct tid_ampdu_rx *tid_rx;
+		struct tid_ampdu_tx *tid_tx;
+
+		spin_lock_bh(&sta->lock);
+		tid_rx = sta->ampdu_mlme.tid_rx[i];
+		/* Make sure timer won't free the tid_rx struct, see below */
+		if (tid_rx)
+			tid_rx->shutdown = true;
+
+		spin_unlock_bh(&sta->lock);
+
+		/*
+		 * Outside spinlock - shutdown is true now so that the timer
+		 * won't free tid_rx, we have to do that now. Can't let the
+		 * timer do it because we have to sync the timer outside the
+		 * lock that it takes itself.
+		 */
+		if (tid_rx) {
+			del_timer_sync(&tid_rx->session_timer);
+			kfree(tid_rx);
+		}
+
+		/*
+		 * No need to do such complications for TX agg sessions, the
+		 * path leading to freeing the tid_tx struct goes via a call
+		 * from the driver, and thus needs to look up the sta struct
+		 * again, which cannot be found when we get here. Hence, we
+		 * just need to delete the timer and free the aggregation
+		 * info; we won't be telling the peer about it then but that
+		 * doesn't matter if we're not talking to it again anyway.
+		 */
+		tid_tx = sta->ampdu_mlme.tid_tx[i];
+		if (tid_tx) {
+			del_timer_sync(&tid_tx->addba_resp_timer);
+			/*
+			 * STA removed while aggregation session being
+			 * started? Bit odd, but purge frames anyway.
+			 */
+			skb_queue_purge(&tid_tx->pending);
+			kfree(tid_tx);
+		}
+	}
+
+	__sta_info_free(local, sta);
+
+	return 0;
 }
 
-/*
- * See comment in __sta_info_unlink, returns sta if it
- * needs to be destroyed.
- */
-static struct sta_info *__sta_info_unpin(struct sta_info *sta)
+int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 {
-	struct sta_info *ret = NULL;
-	unsigned long flags;
+	struct sta_info *sta;
+	int ret;
 
-	spin_lock_irqsave(&sta->local->sta_lock, flags);
-	WARN_ON(sta->pin_status != STA_INFO_PIN_STAT_DESTROY &&
-		sta->pin_status != STA_INFO_PIN_STAT_PINNED);
-	if (sta->pin_status == STA_INFO_PIN_STAT_DESTROY)
-		ret = sta;
-	sta->pin_status = STA_INFO_PIN_STAT_NORMAL;
-	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
+	mutex_lock(&sdata->local->sta_mtx);
+	sta = sta_info_get(sdata, addr);
+	ret = __sta_info_destroy(sta);
+	mutex_unlock(&sdata->local->sta_mtx);
 
 	return ret;
 }
 
-static void sta_info_debugfs_add_work(struct work_struct *work)
+int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
+			      const u8 *addr)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, sta_debugfs_add);
-	struct sta_info *sta, *tmp;
-	unsigned long flags;
+	struct sta_info *sta;
+	int ret;
 
-	/* We need to keep the RTNL across the whole pinned status. */
-	rtnl_lock();
-	while (1) {
-		sta = NULL;
+	mutex_lock(&sdata->local->sta_mtx);
+	sta = sta_info_get_bss(sdata, addr);
+	ret = __sta_info_destroy(sta);
+	mutex_unlock(&sdata->local->sta_mtx);
 
-		spin_lock_irqsave(&local->sta_lock, flags);
-		list_for_each_entry(tmp, &local->sta_list, list) {
-			/*
-			 * debugfs.add_has_run will be set by
-			 * ieee80211_sta_debugfs_add regardless
-			 * of what else it does.
-			 */
-			if (!tmp->debugfs.add_has_run) {
-				sta = tmp;
-				__sta_info_pin(sta);
-				break;
-			}
-		}
-		spin_unlock_irqrestore(&local->sta_lock, flags);
+	return ret;
+}
 
-		if (!sta)
-			break;
+static void sta_info_cleanup(unsigned long data)
+{
+	struct ieee80211_local *local = (struct ieee80211_local *) data;
+	struct sta_info *sta;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &local->sta_list, list)
+		sta_info_cleanup_expire_buffered(local, sta);
+	rcu_read_unlock();
 
-		ieee80211_sta_debugfs_add(sta);
-		rate_control_add_sta_debugfs(sta);
+	if (local->quiescing)
+		return;
 
-		sta = __sta_info_unpin(sta);
-		sta_info_destroy(sta);
-	}
-	rtnl_unlock();
+	local->sta_cleanup.expires =
+		round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL);
+	add_timer(&local->sta_cleanup);
 }
-#endif
 
 void sta_info_init(struct ieee80211_local *local)
 {
 	spin_lock_init(&local->sta_lock);
+	mutex_init(&local->sta_mtx);
 	INIT_LIST_HEAD(&local->sta_list);
+	INIT_LIST_HEAD(&local->sta_pending_list);
+	INIT_WORK(&local->sta_finish_work, sta_info_finish_work);
 
 	setup_timer(&local->sta_cleanup, sta_info_cleanup,
 		    (unsigned long)local);
 	local->sta_cleanup.expires =
 		round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL);
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	INIT_WORK(&local->sta_debugfs_add, sta_info_debugfs_add_work);
-#endif
 }
 
 int sta_info_start(struct ieee80211_local *local)
@@ -795,16 +814,6 @@ int sta_info_start(struct ieee80211_loca
 void sta_info_stop(struct ieee80211_local *local)
 {
 	del_timer(&local->sta_cleanup);
-#ifdef CONFIG_MAC80211_DEBUGFS
-	/*
-	 * Make sure the debugfs adding work isn't pending after this
-	 * because we're about to be destroyed. It doesn't matter
-	 * whether it ran or not since we're going to flush all STAs
-	 * anyway.
-	 */
-	cancel_work_sync(&local->sta_debugfs_add);
-#endif
-
 	sta_info_flush(local, NULL);
 }
 
@@ -820,26 +829,19 @@ int sta_info_flush(struct ieee80211_loca
 		   struct ieee80211_sub_if_data *sdata)
 {
 	struct sta_info *sta, *tmp;
-	LIST_HEAD(tmp_list);
 	int ret = 0;
-	unsigned long flags;
 
 	might_sleep();
 
-	spin_lock_irqsave(&local->sta_lock, flags);
+	mutex_lock(&local->sta_mtx);
+
+	sta_info_finish_pending(local);
+
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
-		if (!sdata || sdata == sta->sdata) {
-			__sta_info_unlink(&sta);
-			if (sta) {
-				list_add_tail(&sta->list, &tmp_list);
-				ret++;
-			}
-		}
+		if (!sdata || sdata == sta->sdata)
+			WARN_ON(__sta_info_destroy(sta));
 	}
-	spin_unlock_irqrestore(&local->sta_lock, flags);
-
-	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
-		sta_info_destroy(sta);
+	mutex_unlock(&local->sta_mtx);
 
 	return ret;
 }
@@ -849,24 +851,17 @@ void ieee80211_sta_expire(struct ieee802
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta, *tmp;
-	LIST_HEAD(tmp_list);
-	unsigned long flags;
 
-	spin_lock_irqsave(&local->sta_lock, flags);
+	mutex_lock(&local->sta_mtx);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
 		if (time_after(jiffies, sta->last_rx + exp_time)) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 			printk(KERN_DEBUG "%s: expiring inactive STA %pM\n",
 			       sdata->name, sta->sta.addr);
 #endif
-			__sta_info_unlink(&sta);
-			if (sta)
-				list_add(&sta->list, &tmp_list);
+			WARN_ON(__sta_info_destroy(sta));
 		}
-	spin_unlock_irqrestore(&local->sta_lock, flags);
-
-	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
-		sta_info_destroy(sta);
+	mutex_unlock(&local->sta_mtx);
 }
 
 struct ieee80211_sta *ieee80211_find_sta_by_hw(struct ieee80211_hw *hw,
--- wireless-testing.orig/net/mac80211/sta_info.h	2010-02-03 13:56:30.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2010-02-03 13:56:40.000000000 +0100
@@ -162,11 +162,6 @@ struct sta_ampdu_mlme {
 };
 
 
-/* see __sta_info_unlink */
-#define STA_INFO_PIN_STAT_NORMAL	0
-#define STA_INFO_PIN_STAT_PINNED	1
-#define STA_INFO_PIN_STAT_DESTROY	2
-
 /**
  * struct sta_info - STA information
  *
@@ -187,7 +182,6 @@ struct sta_ampdu_mlme {
  * @flaglock: spinlock for flags accesses
  * @drv_unblock_wk: used for driver PS unblocking
  * @listen_interval: listen interval of this station, when we're acting as AP
- * @pin_status: used internally for pinning a STA struct into memory
  * @flags: STA flags, see &enum ieee80211_sta_info_flags
  * @ps_tx_buf: buffer of frames to transmit to this station
  *	when it leaves power saving state
@@ -226,6 +220,7 @@ struct sta_ampdu_mlme {
  * @debugfs: debug filesystem info
  * @sta: station information we share with the driver
  * @dead: set to true when sta is unlinked
+ * @uploaded: set to true when sta is uploaded to the driver
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -245,11 +240,7 @@ struct sta_info {
 
 	bool dead;
 
-	/*
-	 * for use by the internal lifetime management,
-	 * see __sta_info_unlink
-	 */
-	u8 pin_status;
+	bool uploaded;
 
 	/*
 	 * frequently updated, locked with own spinlock (flaglock),
@@ -449,18 +440,19 @@ struct sta_info *sta_info_alloc(struct i
  * Insert STA info into hash table/list, returns zero or a
  * -EEXIST if (if the same MAC address is already present).
  *
- * Calling this without RCU protection makes the caller
- * relinquish its reference to @sta.
+ * Calling the non-rcu version makes the caller relinquish,
+ * the _rcu version calls read_lock_rcu() and must be called
+ * without it held.
  */
 int sta_info_insert(struct sta_info *sta);
-/*
- * Unlink a STA info from the hash table/list.
- * This can NULL the STA pointer if somebody else
- * has already unlinked it.
- */
-void sta_info_unlink(struct sta_info **sta);
+int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU);
+int sta_info_insert_atomic(struct sta_info *sta);
+
+int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata,
+			  const u8 *addr);
+int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
+			      const u8 *addr);
 
-void sta_info_destroy(struct sta_info *sta);
 void sta_info_set_tim_bit(struct sta_info *sta);
 void sta_info_clear_tim_bit(struct sta_info *sta);
 
--- wireless-testing.orig/net/mac80211/tx.c	2010-02-03 13:56:36.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2010-02-03 13:56:40.000000000 +0100
@@ -571,7 +571,7 @@ ieee80211_tx_h_sta(struct ieee80211_tx_d
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 
-	if (tx->sta)
+	if (tx->sta && tx->sta->uploaded)
 		info->control.sta = &tx->sta->sta;
 
 	return TX_CONTINUE;
--- wireless-testing.orig/net/mac80211/util.c	2010-02-03 13:56:30.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2010-02-03 13:56:40.000000000 +0100
@@ -1082,7 +1082,6 @@ int ieee80211_reconfig(struct ieee80211_
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
-	unsigned long flags;
 	int res;
 
 	if (local->suspended)
@@ -1116,20 +1115,19 @@ int ieee80211_reconfig(struct ieee80211_
 	}
 
 	/* add STAs back */
-	if (local->ops->sta_notify) {
-		spin_lock_irqsave(&local->sta_lock, flags);
-		list_for_each_entry(sta, &local->sta_list, list) {
+	mutex_lock(&local->sta_mtx);
+	list_for_each_entry(sta, &local->sta_list, list) {
+		if (sta->uploaded) {
 			sdata = sta->sdata;
 			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 				sdata = container_of(sdata->bss,
 					     struct ieee80211_sub_if_data,
 					     u.ap);
 
-			drv_sta_notify(local, sdata, STA_NOTIFY_ADD,
-				       &sta->sta);
+			WARN_ON(drv_sta_add(local, sdata, &sta->sta));
 		}
-		spin_unlock_irqrestore(&local->sta_lock, flags);
 	}
+	mutex_unlock(&local->sta_mtx);
 
 	/* Clear Suspend state so that ADDBA requests can be processed */
 
@@ -1219,10 +1217,10 @@ int ieee80211_reconfig(struct ieee80211_
 
 	add_timer(&local->sta_cleanup);
 
-	spin_lock_irqsave(&local->sta_lock, flags);
+	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list)
 		mesh_plink_restart(sta);
-	spin_unlock_irqrestore(&local->sta_lock, flags);
+	mutex_unlock(&local->sta_mtx);
 #else
 	WARN_ON(1);
 #endif
--- wireless-testing.orig/net/mac80211/cfg.c	2010-02-03 13:56:31.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2010-02-03 13:56:40.000000000 +0100
@@ -747,9 +747,7 @@ static int ieee80211_add_station(struct 
 	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
 		sdata->vif.type == NL80211_IFTYPE_AP;
 
-	rcu_read_lock();
-
-	err = sta_info_insert(sta);
+	err = sta_info_insert_rcu(sta);
 	if (err) {
 		rcu_read_unlock();
 		return err;
@@ -768,26 +766,13 @@ static int ieee80211_del_station(struct 
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
-	struct sta_info *sta;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (mac) {
-		rcu_read_lock();
-
-		sta = sta_info_get_bss(sdata, mac);
-		if (!sta) {
-			rcu_read_unlock();
-			return -ENOENT;
-		}
-
-		sta_info_unlink(&sta);
-		rcu_read_unlock();
-
-		sta_info_destroy(sta);
-	} else
-		sta_info_flush(local, sdata);
+	if (mac)
+		return sta_info_destroy_addr_bss(sdata, mac);
 
+	sta_info_flush(local, sdata);
 	return 0;
 }
 
--- wireless-testing.orig/net/mac80211/ibss.c	2010-02-03 13:56:30.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2010-02-03 13:56:40.000000000 +0100
@@ -275,10 +275,12 @@ static void ieee80211_rx_bss_info(struct
 				    (unsigned long long) supp_rates,
 				    (unsigned long long) sta->sta.supp_rates[band]);
 #endif
-		} else
-			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
-
-		rcu_read_unlock();
+			rcu_read_unlock();
+		} else {
+			rcu_read_unlock();
+			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
+					       supp_rates, GFP_KERNEL);
+		}
 	}
 
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
@@ -368,7 +370,8 @@ static void ieee80211_rx_bss_info(struct
 		       sdata->name, mgmt->bssid);
 #endif
 		ieee80211_sta_join_ibss(sdata, bss);
-		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
+		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
+				       supp_rates, GFP_KERNEL);
 	}
 
  put_bss:
@@ -381,7 +384,8 @@ static void ieee80211_rx_bss_info(struct
  * must be callable in atomic context.
  */
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid,u8 *addr, u32 supp_rates)
+					u8 *bssid,u8 *addr, u32 supp_rates,
+					gfp_t gfp)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
@@ -410,7 +414,7 @@ struct sta_info *ieee80211_ibss_add_sta(
 	       wiphy_name(local->hw.wiphy), addr, sdata->name);
 #endif
 
-	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
+	sta = sta_info_alloc(sdata, addr, gfp);
 	if (!sta)
 		return NULL;
 
@@ -422,9 +426,9 @@ struct sta_info *ieee80211_ibss_add_sta(
 
 	rate_control_rate_init(sta);
 
+	/* If it fails, maybe we raced another insertion? */
 	if (sta_info_insert(sta))
-		return NULL;
-
+		return sta_info_get(sdata, addr);
 	return sta;
 }
 
--- wireless-testing.orig/net/mac80211/driver-ops.h	2010-02-03 13:56:30.000000000 +0100
+++ wireless-testing/net/mac80211/driver-ops.h	2010-02-03 13:56:40.000000000 +0100
@@ -243,6 +243,40 @@ static inline void drv_sta_notify(struct
 	trace_drv_sta_notify(local, sdata, cmd, sta);
 }
 
+static inline int drv_sta_add(struct ieee80211_local *local,
+			      struct ieee80211_sub_if_data *sdata,
+			      struct ieee80211_sta *sta)
+{
+	int ret = 0;
+
+	might_sleep();
+
+	if (local->ops->sta_add)
+		ret = local->ops->sta_add(&local->hw, &sdata->vif, sta);
+	else if (local->ops->sta_notify)
+		local->ops->sta_notify(&local->hw, &sdata->vif,
+					STA_NOTIFY_ADD, sta);
+
+	trace_drv_sta_add(local, sdata, sta, ret);
+
+	return ret;
+}
+
+static inline void drv_sta_remove(struct ieee80211_local *local,
+				  struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_sta *sta)
+{
+	might_sleep();
+
+	if (local->ops->sta_remove)
+		local->ops->sta_remove(&local->hw, &sdata->vif, sta);
+	else if (local->ops->sta_notify)
+		local->ops->sta_notify(&local->hw, &sdata->vif,
+					STA_NOTIFY_REMOVE, sta);
+
+	trace_drv_sta_remove(local, sdata, sta);
+}
+
 static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
 			      const struct ieee80211_tx_queue_params *params)
 {
--- wireless-testing.orig/net/mac80211/mlme.c	2010-02-03 13:56:34.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2010-02-03 13:56:40.000000000 +0100
@@ -822,19 +822,7 @@ static void ieee80211_set_disassoc(struc
 	changed |= BSS_CHANGED_BSSID;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
-	rcu_read_lock();
-
-	sta = sta_info_get(sdata, bssid);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-
-	sta_info_unlink(&sta);
-
-	rcu_read_unlock();
-
-	sta_info_destroy(sta);
+	sta_info_destroy_addr(sdata, bssid);
 }
 
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/include/net/mac80211.h	2010-02-03 13:56:31.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2010-02-03 13:56:40.000000000 +0100
@@ -814,7 +814,7 @@ enum set_key_cmd {
  * mac80211, any ieee80211_sta pointer you get access to must
  * either be protected by rcu_read_lock() explicitly or implicitly,
  * or you must take good care to not use such a pointer after a
- * call to your sta_notify callback that removed it.
+ * call to your sta_remove callback that removed it.
  *
  * @addr: MAC address
  * @aid: AID we assigned to the station if we're an AP
@@ -840,8 +840,8 @@ struct ieee80211_sta {
  * indicates addition and removal of a station to station table,
  * or if a associated station made a power state transition.
  *
- * @STA_NOTIFY_ADD: a station was added to the station table
- * @STA_NOTIFY_REMOVE: a station being removed from the station table
+ * @STA_NOTIFY_ADD: (DEPRECATED) a station was added to the station table
+ * @STA_NOTIFY_REMOVE: (DEPRECATED) a station being removed from the station table
  * @STA_NOTIFY_SLEEP: a station is now sleeping
  * @STA_NOTIFY_AWAKE: a sleeping station woke up
  */
@@ -1534,9 +1534,14 @@ enum ieee80211_ampdu_mlme_action {
  * @set_rts_threshold: Configuration of RTS threshold (if device needs it)
  *	The callback can sleep.
  *
- * @sta_notify: Notifies low level driver about addition, removal or power
- *	state transition of an associated station, AP,  IBSS/WDS/mesh peer etc.
- *	Must be atomic.
+ * @sta_add: Notifies low level driver about addition of an associated station,
+ *	AP, IBSS/WDS/mesh peer etc. This callback can sleep.
+ *
+ * @sta_remove: Notifies low level driver about removal of an associated
+ *	station, AP, IBSS/WDS/mesh peer etc. This callback can sleep.
+ *
+ * @sta_notify: Notifies low level driver about power state transition of an
+ *	associated station, AP,  IBSS/WDS/mesh peer etc. Must be atomic.
  *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
@@ -1635,6 +1640,10 @@ struct ieee80211_ops {
 	void (*get_tkip_seq)(struct ieee80211_hw *hw, u8 hw_key_idx,
 			     u32 *iv32, u16 *iv16);
 	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
+	int (*sta_add)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta);
+	int (*sta_remove)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
 	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
--- wireless-testing.orig/net/mac80211/driver-trace.h	2010-02-03 13:56:30.000000000 +0100
+++ wireless-testing/net/mac80211/driver-trace.h	2010-02-03 13:56:40.000000000 +0100
@@ -545,6 +545,58 @@ TRACE_EVENT(drv_sta_notify,
 	)
 );
 
+TRACE_EVENT(drv_sta_add,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta, int ret),
+
+	TP_ARGS(local, sdata, sta, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " ret:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_sta_remove,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+
+	TP_ARGS(local, sdata, sta),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG
+	)
+);
+
 TRACE_EVENT(drv_conf_tx,
 	TP_PROTO(struct ieee80211_local *local, u16 queue,
 		 const struct ieee80211_tx_queue_params *params,
--- wireless-testing.orig/net/mac80211/mesh_plink.c	2010-02-03 13:56:30.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_plink.c	2010-02-03 13:56:40.000000000 +0100
@@ -102,7 +102,7 @@ static struct sta_info *mesh_plink_alloc
 	if (local->num_sta >= MESH_MAX_PLINKS)
 		return NULL;
 
-	sta = sta_info_alloc(sdata, hw_addr, GFP_ATOMIC);
+	sta = sta_info_alloc(sdata, hw_addr, GFP_KERNEL);
 	if (!sta)
 		return NULL;
 
@@ -236,12 +236,12 @@ void mesh_neighbour_update(u8 *hw_addr, 
 
 	sta = sta_info_get(sdata, hw_addr);
 	if (!sta) {
+		rcu_read_unlock();
+
 		sta = mesh_plink_alloc(sdata, hw_addr, rates);
-		if (!sta) {
-			rcu_read_unlock();
+		if (!sta)
 			return;
-		}
-		if (sta_info_insert(sta)) {
+		if (sta_info_insert_rcu(sta)) {
 			rcu_read_unlock();
 			return;
 		}
@@ -485,9 +485,11 @@ void mesh_rx_plink_frame(struct ieee8021
 	} else if (!sta) {
 		/* ftype == PLINK_OPEN */
 		u32 rates;
+
+		rcu_read_unlock();
+
 		if (!mesh_plink_free_count(sdata)) {
 			mpl_dbg("Mesh plink error: no more free plinks\n");
-			rcu_read_unlock();
 			return;
 		}
 
@@ -495,10 +497,9 @@ void mesh_rx_plink_frame(struct ieee8021
 		sta = mesh_plink_alloc(sdata, mgmt->sa, rates);
 		if (!sta) {
 			mpl_dbg("Mesh plink error: plink table full\n");
-			rcu_read_unlock();
 			return;
 		}
-		if (sta_info_insert(sta)) {
+		if (sta_info_insert_rcu(sta)) {
 			rcu_read_unlock();
 			return;
 		}
--- wireless-testing.orig/net/mac80211/rx.c	2010-02-03 13:56:31.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2010-02-03 13:56:40.000000000 +0100
@@ -2244,8 +2244,8 @@ static int prepare_for_handlers(struct i
 				rate_idx = 0; /* TODO: HT rates */
 			else
 				rate_idx = status->rate_idx;
-			rx->sta = ieee80211_ibss_add_sta(sdata, bssid, hdr->addr2,
-				BIT(rate_idx));
+			rx->sta = ieee80211_ibss_add_sta(sdata, bssid,
+					hdr->addr2, BIT(rate_idx), GFP_ATOMIC);
 		}
 		break;
 	case NL80211_IFTYPE_MESH_POINT:


