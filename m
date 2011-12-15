Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab1LOKYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 05:24:23 -0500
Subject: [PATCH v2 2/2] mac80211: reduce station management complexity
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20111214130549.188381247@sipsolutions.net> (sfid-20111214_140822_872604_0A03F5B8)
References: <20111214130338.347106528@sipsolutions.net>
	 <20111214130549.188381247@sipsolutions.net>
	 (sfid-20111214_140822_872604_0A03F5B8)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 11:24:20 +0100
Message-ID: <1323944660.3337.21.camel@jlt3.sipsolutions.net> (sfid-20111215_112429_192915_A3020BD6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that IBSS no longer needs to insert stations
from atomic context, we can get rid of all the
special cases for that, and even get rid of the
sta_lock (though it needs to stay as tim_lock.)

This makes the station management code much more
straight-forward.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |   11 -
 net/mac80211/sta_info.c    |  251 ++++++++++-----------------------------------
 net/mac80211/tx.c          |    4 
 3 files changed, 63 insertions(+), 203 deletions(-)

--- a/net/mac80211/sta_info.c	2011-12-15 11:16:35.000000000 +0100
+++ b/net/mac80211/sta_info.c	2011-12-15 11:22:52.000000000 +0100
@@ -62,14 +62,14 @@
  * freed before they are done using it.
  */
 
-/* Caller must hold local->sta_lock */
+/* Caller must hold local->sta_mtx */
 static int sta_info_hash_del(struct ieee80211_local *local,
 			     struct sta_info *sta)
 {
 	struct sta_info *s;
 
 	s = rcu_dereference_protected(local->sta_hash[STA_HASH(sta->sta.addr)],
-				      lockdep_is_held(&local->sta_lock));
+				      lockdep_is_held(&local->sta_mtx));
 	if (!s)
 		return -ENOENT;
 	if (s == sta) {
@@ -81,7 +81,7 @@ static int sta_info_hash_del(struct ieee
 	while (rcu_access_pointer(s->hnext) &&
 	       rcu_access_pointer(s->hnext) != sta)
 		s = rcu_dereference_protected(s->hnext,
-					lockdep_is_held(&local->sta_lock));
+					lockdep_is_held(&local->sta_mtx));
 	if (rcu_access_pointer(s->hnext)) {
 		RCU_INIT_POINTER(s->hnext, sta->hnext);
 		return 0;
@@ -98,14 +98,12 @@ struct sta_info *sta_info_get(struct iee
 	struct sta_info *sta;
 
 	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
-				    lockdep_is_held(&local->sta_lock) ||
 				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
 		if (sta->sdata == sdata && !sta->dummy &&
 		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
 		sta = rcu_dereference_check(sta->hnext,
-					    lockdep_is_held(&local->sta_lock) ||
 					    lockdep_is_held(&local->sta_mtx));
 	}
 	return sta;
@@ -119,14 +117,12 @@ struct sta_info *sta_info_get_rx(struct
 	struct sta_info *sta;
 
 	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
-				    lockdep_is_held(&local->sta_lock) ||
 				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
 		if (sta->sdata == sdata &&
 		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
 		sta = rcu_dereference_check(sta->hnext,
-					    lockdep_is_held(&local->sta_lock) ||
 					    lockdep_is_held(&local->sta_mtx));
 	}
 	return sta;
@@ -143,7 +139,6 @@ struct sta_info *sta_info_get_bss(struct
 	struct sta_info *sta;
 
 	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
-				    lockdep_is_held(&local->sta_lock) ||
 				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
 		if ((sta->sdata == sdata ||
@@ -152,7 +147,6 @@ struct sta_info *sta_info_get_bss(struct
 		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
 		sta = rcu_dereference_check(sta->hnext,
-					    lockdep_is_held(&local->sta_lock) ||
 					    lockdep_is_held(&local->sta_mtx));
 	}
 	return sta;
@@ -169,7 +163,6 @@ struct sta_info *sta_info_get_bss_rx(str
 	struct sta_info *sta;
 
 	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
-				    lockdep_is_held(&local->sta_lock) ||
 				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
 		if ((sta->sdata == sdata ||
@@ -177,7 +170,6 @@ struct sta_info *sta_info_get_bss_rx(str
 		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
 		sta = rcu_dereference_check(sta->hnext,
-					    lockdep_is_held(&local->sta_lock) ||
 					    lockdep_is_held(&local->sta_mtx));
 	}
 	return sta;
@@ -228,10 +220,11 @@ void sta_info_free(struct ieee80211_loca
 	kfree(sta);
 }
 
-/* Caller must hold local->sta_lock */
+/* Caller must hold local->sta_mtx */
 static void sta_info_hash_add(struct ieee80211_local *local,
 			      struct sta_info *sta)
 {
+	lockdep_assert_held(&local->sta_mtx);
 	sta->hnext = local->sta_hash[STA_HASH(sta->sta.addr)];
 	RCU_INIT_POINTER(local->sta_hash[STA_HASH(sta->sta.addr)], sta);
 }
@@ -339,89 +332,6 @@ struct sta_info *sta_info_alloc(struct i
 	return sta;
 }
 
-static int sta_info_finish_insert(struct sta_info *sta,
-				bool async, bool dummy_reinsert)
-{
-	struct ieee80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct station_info sinfo;
-	unsigned long flags;
-	int err = 0;
-
-	lockdep_assert_held(&local->sta_mtx);
-
-	if (!sta->dummy || dummy_reinsert) {
-		/* notify driver */
-		err = drv_sta_add(local, sdata, &sta->sta);
-		if (err) {
-			if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
-				return err;
-			printk(KERN_DEBUG "%s: failed to add IBSS STA %pM to "
-					  "driver (%d) - keeping it anyway.\n",
-			       sdata->name, sta->sta.addr, err);
-		} else
-			sta->uploaded = true;
-
-		sdata = sta->sdata;
-	}
-
-	if (!dummy_reinsert) {
-		local->num_sta++;
-		local->sta_generation++;
-		smp_mb();
-
-		/* make the station visible */
-		spin_lock_irqsave(&local->sta_lock, flags);
-		sta_info_hash_add(local, sta);
-		spin_unlock_irqrestore(&local->sta_lock, flags);
-
-		list_add(&sta->list, &local->sta_list);
-	} else {
-		sta->dummy = false;
-	}
-
-	if (!sta->dummy) {
-		ieee80211_sta_debugfs_add(sta);
-		rate_control_add_sta_debugfs(sta);
-
-		memset(&sinfo, 0, sizeof(sinfo));
-		sinfo.filled = 0;
-		sinfo.generation = local->sta_generation;
-		cfg80211_new_sta(sdata->dev, sta->sta.addr, &sinfo, GFP_KERNEL);
-	}
-
-	return 0;
-}
-
-static void sta_info_finish_pending(struct ieee80211_local *local)
-{
-	struct sta_info *sta;
-	unsigned long flags;
-
-	spin_lock_irqsave(&local->sta_lock, flags);
-	while (!list_empty(&local->sta_pending_list)) {
-		sta = list_first_entry(&local->sta_pending_list,
-				       struct sta_info, list);
-		list_del(&sta->list);
-		spin_unlock_irqrestore(&local->sta_lock, flags);
-
-		sta_info_finish_insert(sta, true, false);
-
-		spin_lock_irqsave(&local->sta_lock, flags);
-	}
-	spin_unlock_irqrestore(&local->sta_lock, flags);
-}
-
-static void sta_info_finish_work(struct work_struct *work)
-{
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, sta_finish_work);
-
-	mutex_lock(&local->sta_mtx);
-	sta_info_finish_pending(local);
-	mutex_unlock(&local->sta_mtx);
-}
-
 static int sta_info_insert_check(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -441,50 +351,15 @@ static int sta_info_insert_check(struct
 	return 0;
 }
 
-static int sta_info_insert_ibss(struct sta_info *sta) __acquires(RCU)
-{
-	struct ieee80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	unsigned long flags;
-
-	spin_lock_irqsave(&local->sta_lock, flags);
-	/* check if STA exists already */
-	if (sta_info_get_bss_rx(sdata, sta->sta.addr)) {
-		spin_unlock_irqrestore(&local->sta_lock, flags);
-		rcu_read_lock();
-		return -EEXIST;
-	}
-
-	local->num_sta++;
-	local->sta_generation++;
-	smp_mb();
-	sta_info_hash_add(local, sta);
-
-	list_add_tail(&sta->list, &local->sta_pending_list);
-
-	rcu_read_lock();
-	spin_unlock_irqrestore(&local->sta_lock, flags);
-
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	wiphy_debug(local->hw.wiphy, "Added IBSS STA %pM\n",
-			sta->sta.addr);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-
-	ieee80211_queue_work(&local->hw, &local->sta_finish_work);
-
-	return 0;
-}
-
 /*
  * should be called with sta_mtx locked
  * this function replaces the mutex lock
  * with a RCU lock
  */
-static int sta_info_insert_non_ibss(struct sta_info *sta) __acquires(RCU)
+static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	unsigned long flags;
 	struct sta_info *exist_sta;
 	bool dummy_reinsert = false;
 	int err = 0;
@@ -492,19 +367,8 @@ static int sta_info_insert_non_ibss(stru
 	lockdep_assert_held(&local->sta_mtx);
 
 	/*
-	 * On first glance, this will look racy, because the code
-	 * in this function, which inserts a station with sleeping,
-	 * unlocks the sta_lock between checking existence in the
-	 * hash table and inserting into it.
-	 *
-	 * However, it is not racy against itself because it keeps
-	 * the mutex locked.
-	 */
-
-	spin_lock_irqsave(&local->sta_lock, flags);
-	/*
 	 * check if STA exists already.
-	 * only accept a scenario of a second call to sta_info_insert_non_ibss
+	 * only accept a scenario of a second call to sta_info_insert_finish
 	 * with a dummy station entry that was inserted earlier
 	 * in that case - assume that the dummy station flag should
 	 * be removed.
@@ -514,20 +378,47 @@ static int sta_info_insert_non_ibss(stru
 		if (exist_sta == sta && sta->dummy) {
 			dummy_reinsert = true;
 		} else {
-			spin_unlock_irqrestore(&local->sta_lock, flags);
-			mutex_unlock(&local->sta_mtx);
-			rcu_read_lock();
-			return -EEXIST;
+			err = -EEXIST;
+			goto out_err;
 		}
 	}
 
-	spin_unlock_irqrestore(&local->sta_lock, flags);
+	if (!sta->dummy || dummy_reinsert) {
+		/* notify driver */
+		err = drv_sta_add(local, sdata, &sta->sta);
+		if (err) {
+			if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
+				goto out_err;
+			printk(KERN_DEBUG "%s: failed to add IBSS STA %pM to "
+					  "driver (%d) - keeping it anyway.\n",
+			       sdata->name, sta->sta.addr, err);
+		} else
+			sta->uploaded = true;
+	}
 
-	err = sta_info_finish_insert(sta, false, dummy_reinsert);
-	if (err) {
-		mutex_unlock(&local->sta_mtx);
-		rcu_read_lock();
-		return err;
+	if (!dummy_reinsert) {
+		local->num_sta++;
+		local->sta_generation++;
+		smp_mb();
+
+		/* make the station visible */
+		sta_info_hash_add(local, sta);
+
+		list_add(&sta->list, &local->sta_list);
+	} else {
+		sta->dummy = false;
+	}
+
+	if (!sta->dummy) {
+		struct station_info sinfo;
+
+		ieee80211_sta_debugfs_add(sta);
+		rate_control_add_sta_debugfs(sta);
+
+		memset(&sinfo, 0, sizeof(sinfo));
+		sinfo.filled = 0;
+		sinfo.generation = local->sta_generation;
+		cfg80211_new_sta(sdata->dev, sta->sta.addr, &sinfo, GFP_KERNEL);
 	}
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -543,47 +434,28 @@ static int sta_info_insert_non_ibss(stru
 		mesh_accept_plinks_update(sdata);
 
 	return 0;
+ out_err:
+	mutex_unlock(&local->sta_mtx);
+	rcu_read_lock();
+	return err;
 }
 
 int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 {
 	struct ieee80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	int err = 0;
 
+	might_sleep();
+
 	err = sta_info_insert_check(sta);
 	if (err) {
 		rcu_read_lock();
 		goto out_free;
 	}
 
-	/*
-	 * In ad-hoc mode, we sometimes need to insert stations
-	 * from tasklet context from the RX path. To avoid races,
-	 * always do so in that case -- see the comment below.
-	 */
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		err = sta_info_insert_ibss(sta);
-		if (err)
-			goto out_free;
-
-		return 0;
-	}
-
-	/*
-	 * It might seem that the function called below is in race against
-	 * the function call above that atomically inserts the station... That,
-	 * however, is not true because the above code can only
-	 * be invoked for IBSS interfaces, and the below code will
-	 * not be -- and the two do not race against each other as
-	 * the hash table also keys off the interface.
-	 */
-
-	might_sleep();
-
 	mutex_lock(&local->sta_mtx);
 
-	err = sta_info_insert_non_ibss(sta);
+	err = sta_info_insert_finish(sta);
 	if (err)
 		goto out_free;
 
@@ -617,7 +489,7 @@ int sta_info_reinsert(struct sta_info *s
 
 	might_sleep();
 
-	err = sta_info_insert_non_ibss(sta);
+	err = sta_info_insert_finish(sta);
 	rcu_read_unlock();
 	return err;
 }
@@ -704,7 +576,7 @@ void sta_info_recalc_tim(struct sta_info
 	}
 
  done:
-	spin_lock_irqsave(&local->sta_lock, flags);
+	spin_lock_irqsave(&local->tim_lock, flags);
 
 	if (indicate_tim)
 		__bss_tim_set(bss, sta->sta.aid);
@@ -717,7 +589,7 @@ void sta_info_recalc_tim(struct sta_info
 		local->tim_in_locked_section = false;
 	}
 
-	spin_unlock_irqrestore(&local->sta_lock, flags);
+	spin_unlock_irqrestore(&local->tim_lock, flags);
 }
 
 static bool sta_info_buffer_expired(struct sta_info *sta, struct sk_buff *skb)
@@ -841,7 +713,6 @@ static int __must_check __sta_info_destr
 {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
-	unsigned long flags;
 	int ret, i, ac;
 	struct tid_ampdu_tx *tid_tx;
 
@@ -862,15 +733,12 @@ static int __must_check __sta_info_destr
 	set_sta_flag(sta, WLAN_STA_BLOCK_BA);
 	ieee80211_sta_tear_down_BA_sessions(sta, true);
 
-	spin_lock_irqsave(&local->sta_lock, flags);
 	ret = sta_info_hash_del(local, sta);
-	/* this might still be the pending list ... which is fine */
-	if (!ret)
-		list_del(&sta->list);
-	spin_unlock_irqrestore(&local->sta_lock, flags);
 	if (ret)
 		return ret;
 
+	list_del(&sta->list);
+
 	mutex_lock(&local->key_mtx);
 	for (i = 0; i < NUM_DEFAULT_KEYS; i++)
 		__ieee80211_key_free(key_mtx_dereference(local, sta->gtk[i]));
@@ -1025,11 +893,9 @@ static void sta_info_cleanup(unsigned lo
 
 void sta_info_init(struct ieee80211_local *local)
 {
-	spin_lock_init(&local->sta_lock);
+	spin_lock_init(&local->tim_lock);
 	mutex_init(&local->sta_mtx);
 	INIT_LIST_HEAD(&local->sta_list);
-	INIT_LIST_HEAD(&local->sta_pending_list);
-	INIT_WORK(&local->sta_finish_work, sta_info_finish_work);
 
 	setup_timer(&local->sta_cleanup, sta_info_cleanup,
 		    (unsigned long)local);
@@ -1058,9 +924,6 @@ int sta_info_flush(struct ieee80211_loca
 	might_sleep();
 
 	mutex_lock(&local->sta_mtx);
-
-	sta_info_finish_pending(local);
-
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
 		if (!sdata || sdata == sta->sdata)
 			WARN_ON(__sta_info_destroy(sta));
--- a/net/mac80211/ieee80211_i.h	2011-12-15 11:16:35.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2011-12-15 11:17:21.000000000 +0100
@@ -855,18 +855,15 @@ struct ieee80211_local {
 
 	/* Station data */
 	/*
-	 * The mutex only protects the list and counter,
-	 * reads are done in RCU.
-	 * Additionally, the lock protects the hash table,
-	 * the pending list and each BSS's TIM bitmap.
+	 * The mutex only protects the list, hash table and
+	 * counter, reads are done with RCU.
 	 */
 	struct mutex sta_mtx;
-	spinlock_t sta_lock;
+	spinlock_t tim_lock;
 	unsigned long num_sta;
-	struct list_head sta_list, sta_pending_list;
+	struct list_head sta_list;
 	struct sta_info __rcu *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
-	struct work_struct sta_finish_work;
 	int sta_generation;
 
 	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
--- a/net/mac80211/tx.c	2011-12-15 11:16:25.000000000 +0100
+++ b/net/mac80211/tx.c	2011-12-15 11:17:21.000000000 +0100
@@ -2333,9 +2333,9 @@ struct sk_buff *ieee80211_beacon_get_tim
 			} else {
 				unsigned long flags;
 
-				spin_lock_irqsave(&local->sta_lock, flags);
+				spin_lock_irqsave(&local->tim_lock, flags);
 				ieee80211_beacon_add_tim(ap, skb, beacon);
-				spin_unlock_irqrestore(&local->sta_lock, flags);
+				spin_unlock_irqrestore(&local->tim_lock, flags);
 			}
 
 			if (tim_offset)


