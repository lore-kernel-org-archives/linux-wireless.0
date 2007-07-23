Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:17577 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759747AbXGWD27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2007 23:28:59 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH wireless-2.6] mac80211: improve locking of sta_info related structures
Date: Sun, 22 Jul 2007 20:27:27 -0700
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>,
	Michael Buesch <mb@bu3sch.de>
Message-Id: <200707222027.28064.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

The sta_info code has some awkward locking which prevents some driver
callbacks from being allowed to sleep. This patch makes the locking more
focused so code that calls driver callbacks are allowed to sleep. It also
converts sta_lock to a rwlock.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 include/net/mac80211.h         |    3 -
 net/mac80211/ieee80211.c       |   14 ++-
 net/mac80211/ieee80211_i.h     |   11 +-
 net/mac80211/ieee80211_iface.c |    2 
 net/mac80211/ieee80211_sta.c   |   20 +++-
 net/mac80211/sta_info.c        |  182 ++++++++++++++++------------------------
 net/mac80211/sta_info.h        |   11 ++
 7 files changed, 108 insertions(+), 135 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c34fd9a..8a086a8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -626,8 +626,7 @@ struct ieee80211_ops {
 	 * station hwaddr for individual keys. aid of the station is given
 	 * to help low-level driver in selecting which key->hw_key_idx to use
 	 * for this key. TX control data will use the hw_key_idx selected by
-	 * the low-level driver.
-	 * Must be atomic. */
+	 * the low-level driver. */
 	int (*set_key)(struct ieee80211_hw *hw, set_key_cmd cmd,
 		       u8 *addr, struct ieee80211_key_conf *key, int aid);
 
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 2ddf4ef..4066c3f 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1012,7 +1012,7 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 	}
 	read_unlock(&local->sub_if_lock);
 
-	spin_lock_bh(&local->sta_lock);
+	read_lock_bh(&local->sta_lock);
 	list_for_each_entry(sta, &local->sta_list, list) {
 		skb = skb_dequeue(&sta->ps_tx_buf);
 		if (skb) {
@@ -1021,7 +1021,7 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 		}
 		total += skb_queue_len(&sta->ps_tx_buf);
 	}
-	spin_unlock_bh(&local->sta_lock);
+	read_unlock_bh(&local->sta_lock);
 
 	local->total_ps_buffered = total;
 	printk(KERN_DEBUG "%s: PS buffers full - purged %d frames\n",
@@ -1984,7 +1984,7 @@ static void ieee80211_beacon_add_tim(struct ieee80211_local *local,
 
 	/* Generate bitmap for TIM only if there are any STAs in power save
 	 * mode. */
-	spin_lock_bh(&local->sta_lock);
+	read_lock_bh(&local->sta_lock);
 	if (atomic_read(&bss->num_sta_ps) > 0)
 		/* in the hope that this is faster than
 		 * checking byte-for-byte */
@@ -2035,7 +2035,7 @@ static void ieee80211_beacon_add_tim(struct ieee80211_local *local,
 		*pos++ = aid0; /* Bitmap control */
 		*pos++ = 0; /* Part Virt Bitmap */
 	}
-	spin_unlock_bh(&local->sta_lock);
+	read_unlock_bh(&local->sta_lock);
 }
 
 
@@ -4283,13 +4283,13 @@ static void ieee80211_stat_refresh(unsigned long data)
 		return;
 
 	/* go through all stations */
-	spin_lock_bh(&local->sta_lock);
+	read_lock_bh(&local->sta_lock);
 	list_for_each_entry(sta, &local->sta_list, list) {
 		sta->channel_use = (sta->channel_use_raw / local->stat_time) /
 			CHAN_UTIL_PER_10MS;
 		sta->channel_use_raw = 0;
 	}
-	spin_unlock_bh(&local->sta_lock);
+	read_unlock_bh(&local->sta_lock);
 
 	/* go through all subinterfaces */
 	read_lock(&local->sub_if_lock);
@@ -4761,8 +4761,8 @@ int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr)
 	/* Remove STA entry for the old peer */
 	sta = sta_info_get(local, sdata->u.wds.remote_addr);
 	if (sta) {
+		sta_info_free(sta);
 		sta_info_put(sta);
-		sta_info_free(sta, 0);
 	} else {
 		printk(KERN_DEBUG "%s: could not find STA entry for WDS link "
 		       "peer " MAC_FMT "\n",
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 055a2a9..c14d86d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -416,10 +416,9 @@ struct ieee80211_local {
 	struct sk_buff_head skb_queue_unreliable;
 
 	/* Station data structures */
-	spinlock_t sta_lock; /* mutex for STA data structures */
+	rwlock_t sta_lock; /* protects STA data structures */
 	int num_sta; /* number of stations in sta_list */
 	struct list_head sta_list;
-	struct list_head deleted_sta_list;
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 
@@ -668,9 +667,9 @@ static inline void __bss_tim_set(struct ieee80211_if_ap *bss, int aid)
 static inline void bss_tim_set(struct ieee80211_local *local,
 			       struct ieee80211_if_ap *bss, int aid)
 {
-	spin_lock_bh(&local->sta_lock);
+	read_lock_bh(&local->sta_lock);
 	__bss_tim_set(bss, aid);
-	spin_unlock_bh(&local->sta_lock);
+	read_unlock_bh(&local->sta_lock);
 }
 
 static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, int aid)
@@ -685,9 +684,9 @@ static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, int aid)
 static inline void bss_tim_clear(struct ieee80211_local *local,
 				 struct ieee80211_if_ap *bss, int aid)
 {
-	spin_lock_bh(&local->sta_lock);
+	read_lock_bh(&local->sta_lock);
 	__bss_tim_clear(bss, aid);
-	spin_unlock_bh(&local->sta_lock);
+	read_unlock_bh(&local->sta_lock);
 }
 
 /**
diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index 8532a5c..6db6776 100644
--- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -272,8 +272,8 @@ void ieee80211_if_reinit(struct net_device *dev)
 	case IEEE80211_IF_TYPE_WDS:
 		sta = sta_info_get(local, sdata->u.wds.remote_addr);
 		if (sta) {
+			sta_info_free(sta);
 			sta_info_put(sta);
-			sta_info_free(sta, 0);
 		} else {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			printk(KERN_DEBUG "%s: Someone had deleted my STA "
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 952d8dd..b342746 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -773,7 +773,7 @@ static void ieee80211_associated(struct net_device *dev,
 				       "range\n",
 				       dev->name, MAC_ARG(ifsta->bssid));
 				disassoc = 1;
-				sta_info_free(sta, 0);
+				sta_info_free(sta);
 				ifsta->probereq_poll = 0;
 			} else {
 				ieee80211_send_probe_req(dev, ifsta->bssid,
@@ -1891,7 +1891,7 @@ static int ieee80211_sta_active_ibss(struct net_device *dev)
 	int active = 0;
 	struct sta_info *sta;
 
-	spin_lock_bh(&local->sta_lock);
+	read_lock_bh(&local->sta_lock);
 	list_for_each_entry(sta, &local->sta_list, list) {
 		if (sta->dev == dev &&
 		    time_after(sta->last_rx + IEEE80211_IBSS_MERGE_INTERVAL,
@@ -1900,7 +1900,7 @@ static int ieee80211_sta_active_ibss(struct net_device *dev)
 			break;
 		}
 	}
-	spin_unlock_bh(&local->sta_lock);
+	read_unlock_bh(&local->sta_lock);
 
 	return active;
 }
@@ -1910,16 +1910,24 @@ static void ieee80211_sta_expire(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta, *tmp;
+	LIST_HEAD(tmp_list);
 
-	spin_lock_bh(&local->sta_lock);
+	write_lock_bh(&local->sta_lock);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
 		if (time_after(jiffies, sta->last_rx +
 			       IEEE80211_IBSS_INACTIVITY_LIMIT)) {
 			printk(KERN_DEBUG "%s: expiring inactive STA " MAC_FMT
 			       "\n", dev->name, MAC_ARG(sta->addr));
-			sta_info_free(sta, 1);
+			__sta_info_get(sta);
+			sta_info_remove(sta);
+			list_add(&sta->list, &tmp_list);
 		}
-	spin_unlock_bh(&local->sta_lock);
+	write_unlock_bh(&local->sta_lock);
+
+	list_for_each_entry_safe(sta, tmp, &tmp_list, list) {
+		sta_info_free(sta);
+		sta_info_put(sta);
+	}
 }
 
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index ab7b1f0..82b8007 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -32,38 +32,34 @@ static void sta_info_hash_add(struct ieee80211_local *local,
 
 
 /* Caller must hold local->sta_lock */
-static void sta_info_hash_del(struct ieee80211_local *local,
+static int sta_info_hash_del(struct ieee80211_local *local,
 			      struct sta_info *sta)
 {
 	struct sta_info *s;
 
 	s = local->sta_hash[STA_HASH(sta->addr)];
 	if (!s)
-		return;
-	if (memcmp(s->addr, sta->addr, ETH_ALEN) == 0) {
+		return -ENOENT;
+	if (s == sta) {
 		local->sta_hash[STA_HASH(sta->addr)] = s->hnext;
-		return;
+		return 0;
 	}
 
-	while (s->hnext && memcmp(s->hnext->addr, sta->addr, ETH_ALEN) != 0)
+	while (s->hnext && s->hnext != sta)
 		s = s->hnext;
-	if (s->hnext)
-		s->hnext = s->hnext->hnext;
-	else
-		printk(KERN_ERR "%s: could not remove STA " MAC_FMT " from "
-		       "hash table\n", local->mdev->name, MAC_ARG(sta->addr));
-}
+	if (s->hnext) {
+		s->hnext = sta->hnext;
+		return 0;
+	}
 
-static inline void __sta_info_get(struct sta_info *sta)
-{
-	kref_get(&sta->kref);
+	return -ENOENT;
 }
 
 struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr)
 {
 	struct sta_info *sta;
 
-	spin_lock_bh(&local->sta_lock);
+	read_lock_bh(&local->sta_lock);
 	sta = local->sta_hash[STA_HASH(addr)];
 	while (sta) {
 		if (memcmp(sta->addr, addr, ETH_ALEN) == 0) {
@@ -72,7 +68,7 @@ struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr)
 		}
 		sta = sta->hnext;
 	}
-	spin_unlock_bh(&local->sta_lock);
+	read_unlock_bh(&local->sta_lock);
 
 	return sta;
 }
@@ -85,7 +81,7 @@ int sta_info_min_txrate_get(struct ieee80211_local *local)
 	int min_txrate = 9999999;
 	int i;
 
-	spin_lock_bh(&local->sta_lock);
+	read_lock_bh(&local->sta_lock);
 	mode = local->oper_hw_mode;
 	for (i = 0; i < STA_HASH_SIZE; i++) {
 		sta = local->sta_hash[i];
@@ -95,7 +91,7 @@ int sta_info_min_txrate_get(struct ieee80211_local *local)
 			sta = sta->hnext;
 		}
 	}
-	spin_unlock_bh(&local->sta_lock);
+	read_unlock_bh(&local->sta_lock);
 	if (min_txrate == 9999999)
 		min_txrate = 0;
 
@@ -150,7 +146,6 @@ struct sta_info * sta_info_add(struct ieee80211_local *local,
 	sta->rate_ctrl_priv = rate_control_alloc_sta(sta->rate_ctrl, gfp);
 	if (!sta->rate_ctrl_priv) {
 		rate_control_put(sta->rate_ctrl);
-		kref_put(&sta->kref, sta_info_release);
 		kfree(sta);
 		return NULL;
 	}
@@ -162,14 +157,14 @@ struct sta_info * sta_info_add(struct ieee80211_local *local,
 	skb_queue_head_init(&sta->tx_filtered);
 	__sta_info_get(sta);	/* sta used by caller, decremented by
 				 * sta_info_put() */
-	spin_lock_bh(&local->sta_lock);
+	write_lock_bh(&local->sta_lock);
 	list_add(&sta->list, &local->sta_list);
 	local->num_sta++;
 	sta_info_hash_add(local, sta);
-	spin_unlock_bh(&local->sta_lock);
 	if (local->ops->sta_table_notification)
 		local->ops->sta_table_notification(local_to_hw(local),
 						  local->num_sta);
+	write_unlock_bh(&local->sta_lock);
 	sta->key_idx_compression = HW_KEY_IDX_INVALID;
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -178,47 +173,25 @@ struct sta_info * sta_info_add(struct ieee80211_local *local,
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-	if (!in_interrupt()) {
-		sta->debugfs_registered = 1;
-		ieee80211_sta_debugfs_add(sta);
-		rate_control_add_sta_debugfs(sta);
-	} else {
-		/* debugfs entry adding might sleep, so schedule process
-		 * context task for adding entry for STAs that do not yet
-		 * have one. */
-		queue_work(local->hw.workqueue, &local->sta_debugfs_add);
-	}
+	/* debugfs entry adding might sleep, so schedule process
+	 * context task for adding entry for STAs that do not yet
+	 * have one. */
+	queue_work(local->hw.workqueue, &local->sta_debugfs_add);
 #endif
 
 	return sta;
 }
 
-static void finish_sta_info_free(struct ieee80211_local *local,
-				 struct sta_info *sta)
-{
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: Removed STA " MAC_FMT "\n",
-	       local->mdev->name, MAC_ARG(sta->addr));
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-
-	if (sta->key) {
-		ieee80211_debugfs_key_remove(sta->key);
-		ieee80211_key_free(sta->key);
-		sta->key = NULL;
-	}
-
-	rate_control_remove_sta_debugfs(sta);
-	ieee80211_sta_debugfs_remove(sta);
-
-	sta_info_put(sta);
-}
-
-static void sta_info_remove(struct sta_info *sta)
+/* Caller must hold local->sta_lock */
+void sta_info_remove(struct sta_info *sta)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata;
 
-	sta_info_hash_del(local, sta);
+	/* don't do anything if we've been removed already */
+	if (sta_info_hash_del(local, sta))
+		return;
+
 	list_del(&sta->list);
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 	if (sta->flags & WLAN_STA_PS) {
@@ -228,30 +201,29 @@ static void sta_info_remove(struct sta_info *sta)
 	}
 	local->num_sta--;
 	sta_info_remove_aid_ptr(sta);
+
+	if (local->ops->sta_table_notification)
+		local->ops->sta_table_notification(local_to_hw(local),
+						  local->num_sta);
 }
 
-void sta_info_free(struct sta_info *sta, int locked)
+void sta_info_free(struct sta_info *sta)
 {
 	struct sk_buff *skb;
 	struct ieee80211_local *local = sta->local;
 
-	if (!locked) {
-		spin_lock_bh(&local->sta_lock);
-		sta_info_remove(sta);
-		spin_unlock_bh(&local->sta_lock);
-	} else {
-		sta_info_remove(sta);
-	}
-	if (local->ops->sta_table_notification)
-		local->ops->sta_table_notification(local_to_hw(local),
-						  local->num_sta);
+	might_sleep();
+
+	write_lock_bh(&local->sta_lock);
+	sta_info_remove(sta);
+	write_unlock_bh(&local->sta_lock);
 
 	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
 		local->total_ps_buffered--;
-		dev_kfree_skb_any(skb);
+		dev_kfree_skb(skb);
 	}
 	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
-		dev_kfree_skb_any(skb);
+		dev_kfree_skb(skb);
 	}
 
 	if (sta->key) {
@@ -276,13 +248,21 @@ void sta_info_free(struct sta_info *sta, int locked)
 		sta->key_idx_compression = HW_KEY_IDX_INVALID;
 	}
 
-#ifdef CONFIG_MAC80211_DEBUGFS
-	if (in_atomic()) {
-		list_add(&sta->list, &local->deleted_sta_list);
-		queue_work(local->hw.workqueue, &local->sta_debugfs_add);
-	} else
-#endif
-		finish_sta_info_free(local, sta);
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: Removed STA " MAC_FMT "\n",
+	       local->mdev->name, MAC_ARG(sta->addr));
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+
+	if (sta->key) {
+		ieee80211_debugfs_key_remove(sta->key);
+		ieee80211_key_free(sta->key);
+		sta->key = NULL;
+	}
+
+	rate_control_remove_sta_debugfs(sta);
+	ieee80211_sta_debugfs_remove(sta);
+
+	sta_info_put(sta);
 }
 
 
@@ -343,13 +323,13 @@ static void sta_info_cleanup(unsigned long data)
 	struct ieee80211_local *local = (struct ieee80211_local *) data;
 	struct sta_info *sta;
 
-	spin_lock_bh(&local->sta_lock);
+	read_lock_bh(&local->sta_lock);
 	list_for_each_entry(sta, &local->sta_list, list) {
 		__sta_info_get(sta);
 		sta_info_cleanup_expire_buffered(local, sta);
 		sta_info_put(sta);
 	}
-	spin_unlock_bh(&local->sta_lock);
+	read_unlock_bh(&local->sta_lock);
 
 	local->sta_cleanup.expires = jiffies + STA_INFO_CLEANUP_INTERVAL;
 	add_timer(&local->sta_cleanup);
@@ -363,35 +343,20 @@ static void sta_info_debugfs_add_task(struct work_struct *work)
 	struct sta_info *sta, *tmp;
 
 	while (1) {
-		spin_lock_bh(&local->sta_lock);
-		if (!list_empty(&local->deleted_sta_list)) {
-			sta = list_entry(local->deleted_sta_list.next,
-					 struct sta_info, list);
-			list_del(local->deleted_sta_list.next);
-		} else
-			sta = NULL;
-		spin_unlock_bh(&local->sta_lock);
-		if (!sta)
-			break;
-		finish_sta_info_free(local, sta);
-	}
-
-	while (1) {
 		sta = NULL;
-		spin_lock_bh(&local->sta_lock);
+		read_lock_bh(&local->sta_lock);
 		list_for_each_entry(tmp, &local->sta_list, list) {
-			if (!tmp->debugfs_registered) {
+			if (!tmp->debugfs.dir) {
 				sta = tmp;
 				__sta_info_get(sta);
 				break;
 			}
 		}
-		spin_unlock_bh(&local->sta_lock);
+		read_unlock_bh(&local->sta_lock);
 
 		if (!sta)
 			break;
 
-		sta->debugfs_registered = 1;
 		ieee80211_sta_debugfs_add(sta);
 		rate_control_add_sta_debugfs(sta);
 		sta_info_put(sta);
@@ -401,9 +366,8 @@ static void sta_info_debugfs_add_task(struct work_struct *work)
 
 void sta_info_init(struct ieee80211_local *local)
 {
-	spin_lock_init(&local->sta_lock);
+	rwlock_init(&local->sta_lock);
 	INIT_LIST_HEAD(&local->sta_list);
-	INIT_LIST_HEAD(&local->deleted_sta_list);
 
 	init_timer(&local->sta_cleanup);
 	local->sta_cleanup.expires = jiffies + STA_INFO_CLEANUP_INTERVAL;
@@ -423,17 +387,8 @@ int sta_info_start(struct ieee80211_local *local)
 
 void sta_info_stop(struct ieee80211_local *local)
 {
-	struct sta_info *sta, *tmp;
-
 	del_timer(&local->sta_cleanup);
-
-	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
-		/* sta_info_free must be called with 0 as the last
-		 * parameter to ensure all debugfs sta entries are
-		 * unregistered. We don't need locking at this
-		 * point. */
-		sta_info_free(sta, 0);
-	}
+	sta_info_flush(local, NULL);
 }
 
 void sta_info_remove_aid_ptr(struct sta_info *sta)
@@ -461,10 +416,19 @@ void sta_info_remove_aid_ptr(struct sta_info *sta)
 void sta_info_flush(struct ieee80211_local *local, struct net_device *dev)
 {
 	struct sta_info *sta, *tmp;
+	LIST_HEAD(tmp_list);
 
-	spin_lock_bh(&local->sta_lock);
+	write_lock_bh(&local->sta_lock);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
-		if (!dev || dev == sta->dev)
-			sta_info_free(sta, 1);
-	spin_unlock_bh(&local->sta_lock);
+		if (!dev || dev == sta->dev) {
+			__sta_info_get(sta);
+			sta_info_remove(sta);
+			list_add_tail(&sta->list, &tmp_list);
+		}
+	write_unlock_bh(&local->sta_lock);
+
+	list_for_each_entry_safe(sta, tmp, &tmp_list, list) {
+		sta_info_free(sta);
+		sta_info_put(sta);
+	}
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index b5591d2..b5ef723 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -98,9 +98,6 @@ struct sta_info {
 				  * filtering; used only if sta->key is not
 				  * set */
 
-#ifdef CONFIG_MAC80211_DEBUGFS
-	int debugfs_registered;
-#endif
 	int assoc_ap; /* whether this is an AP that we are
 		       * associated with as a client */
 
@@ -149,12 +146,18 @@ struct sta_info {
  */
 #define STA_INFO_CLEANUP_INTERVAL (10 * HZ)
 
+static inline void __sta_info_get(struct sta_info *sta)
+{
+	kref_get(&sta->kref);
+}
+
 struct sta_info * sta_info_get(struct ieee80211_local *local, u8 *addr);
 int sta_info_min_txrate_get(struct ieee80211_local *local);
 void sta_info_put(struct sta_info *sta);
 struct sta_info * sta_info_add(struct ieee80211_local *local,
 			       struct net_device *dev, u8 *addr, gfp_t gfp);
-void sta_info_free(struct sta_info *sta, int locked);
+void sta_info_remove(struct sta_info *sta);
+void sta_info_free(struct sta_info *sta);
 void sta_info_init(struct ieee80211_local *local);
 int sta_info_start(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);

