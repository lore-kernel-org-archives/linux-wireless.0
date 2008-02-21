Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014AbYBUUGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 15:06:23 -0500
Subject: [RFC] mac80211: RCU-ify sta_info lifetime
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 21:06:09 +0100
Message-Id: <1203624369.26341.12.camel@johannes.berg> (sfid-20080221_200652_624578_CF5A6FDF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Comments welcome. I think it's an improvement because not only does it
change sta info to not be reference counted but also documents the new
lifetime rules.

johannes
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   31 +-
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   27 +-
 net/mac80211/cfg.c                         |   82 ++++--
 net/mac80211/debugfs_sta.c                 |    4 
 net/mac80211/debugfs_sta.h                 |    2 
 net/mac80211/ieee80211.c                   |   76 ++++--
 net/mac80211/ieee80211_i.h                 |   13 -
 net/mac80211/ieee80211_iface.c             |   11 
 net/mac80211/ieee80211_ioctl.c             |   60 +++-
 net/mac80211/ieee80211_rate.c              |    8 
 net/mac80211/ieee80211_rate.h              |    1 
 net/mac80211/ieee80211_sta.c               |  126 ++++++----
 net/mac80211/key.c                         |    5 
 net/mac80211/rc80211_pid_algo.c            |   23 +
 net/mac80211/rc80211_simple.c              |   18 -
 net/mac80211/rx.c                          |   24 -
 net/mac80211/sta_info.c                    |  350 +++++++++++++++++------------
 net/mac80211/sta_info.h                    |   58 +++-
 net/mac80211/tx.c                          |   48 ++-
 net/mac80211/wme.c                         |    8 
 20 files changed, 612 insertions(+), 363 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-02-21 20:33:29.000000000 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-02-21 20:55:10.000000000 +0100
@@ -426,6 +426,7 @@ struct ieee80211_local {
 	unsigned int filter_flags; /* FIF_* */
 	struct iw_statistics wstats;
 	u8 wstats_flags;
+	bool tim_in_locked_section; /* see ieee80211_beacon_get() */
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	enum {
@@ -443,9 +444,15 @@ struct ieee80211_local {
 	struct sk_buff_head skb_queue;
 	struct sk_buff_head skb_queue_unreliable;
 
-	/* Station data structures */
-	rwlock_t sta_lock; /* protects STA data structures */
-	int num_sta; /* number of stations in sta_list */
+	/* Station data */
+	/*
+	 * The lock only protects the list, hash, timer and counter
+	 * against manipulation, reads are done in RCU. Additionally,
+	 * the lock protects each BSS's TIM bitmap and a few items
+	 * in a STA info structure.
+	 */
+	spinlock_t sta_lock;
+	unsigned long num_sta;
 	struct list_head sta_list;
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-02-21 20:33:29.000000000 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-02-21 20:55:10.000000000 +0100
@@ -856,6 +856,8 @@ static void ieee80211_associated(struct 
 
 	ifsta->state = IEEE80211_ASSOCIATED;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
 		printk(KERN_DEBUG "%s: No STA entry for own AP %s\n",
@@ -871,7 +873,7 @@ static void ieee80211_associated(struct 
 				       "range\n",
 				       dev->name, print_mac(mac, ifsta->bssid));
 				disassoc = 1;
-				sta_info_free(sta);
+				sta_info_unlink(&sta);
 			} else
 				ieee80211_send_probe_req(dev, ifsta->bssid,
 							 local->scan_ssid,
@@ -887,8 +889,15 @@ static void ieee80211_associated(struct 
 							 ifsta->ssid_len);
 			}
 		}
-		sta_info_put(sta);
 	}
+
+	rcu_read_unlock();
+
+	if (disassoc && sta) {
+		synchronize_rcu();
+		sta_info_destroy(sta);
+	}
+
 	if (disassoc) {
 		ifsta->state = IEEE80211_DISABLED;
 		ieee80211_set_associated(dev, ifsta, 0);
@@ -1114,9 +1123,13 @@ static void ieee80211_sta_process_addba_
 	int ret = -EOPNOTSUPP;
 	DECLARE_MAC_BUF(mac);
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, mgmt->sa);
-	if (!sta)
+	if (!sta) {
+		rcu_read_unlock();
 		return;
+	}
 
 	/* extract session parameters from addba request frame */
 	dialog_token = mgmt->u.action.u.addba_req.dialog_token;
@@ -1207,9 +1220,9 @@ end:
 	spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
 
 end_no_lock:
-	ieee80211_send_addba_resp(sta->dev, sta->addr, tid, dialog_token,
-				status, 1, buf_size, timeout);
-	sta_info_put(sta);
+	ieee80211_send_addba_resp(sta->sdata->dev, sta->addr, tid,
+				  dialog_token, status, 1, buf_size, timeout);
+	rcu_read_unlock();
 }
 
 static void ieee80211_sta_process_addba_resp(struct net_device *dev,
@@ -1223,9 +1236,13 @@ static void ieee80211_sta_process_addba_
 	u16 tid;
 	u8 *state;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, mgmt->sa);
-	if (!sta)
+	if (!sta) {
+		rcu_read_unlock();
 		return;
+	}
 
 	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
 	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
@@ -1240,7 +1257,7 @@ static void ieee80211_sta_process_addba_
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -1254,7 +1271,7 @@ static void ieee80211_sta_process_addba_
 			spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
 			printk(KERN_DEBUG "state not HT_ADDBA_REQUESTED_MSK:"
 				"%d\n", *state);
-			sta_info_put(sta);
+			rcu_read_unlock();
 			return;
 		}
 
@@ -1281,7 +1298,7 @@ static void ieee80211_sta_process_addba_
 		ieee80211_stop_tx_ba_session(hw, sta->addr, tid,
 					     WLAN_BACK_INITIATOR);
 	}
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 
 void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
@@ -1336,16 +1353,20 @@ void ieee80211_sta_stop_rx_ba_session(st
 	struct sta_info *sta;
 	int ret, i;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, ra);
-	if (!sta)
+	if (!sta) {
+		rcu_read_unlock();
 		return;
+	}
 
 	/* check if TID is in operational state */
 	spin_lock_bh(&sta->ampdu_mlme.ampdu_rx);
 	if (sta->ampdu_mlme.tid_rx[tid].state
 				!= HT_AGG_STATE_OPERATIONAL) {
 		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
-		sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 	sta->ampdu_mlme.tid_rx[tid].state =
@@ -1384,7 +1405,7 @@ void ieee80211_sta_stop_rx_ba_session(st
 	kfree(sta->ampdu_mlme.tid_rx[tid].reorder_buf);
 
 	sta->ampdu_mlme.tid_rx[tid].state = HT_AGG_STATE_IDLE;
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 
 
@@ -1397,9 +1418,13 @@ static void ieee80211_sta_process_delba(
 	u16 initiator;
 	DECLARE_MAC_BUF(mac);
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, mgmt->sa);
-	if (!sta)
+	if (!sta) {
+		rcu_read_unlock();
 		return;
+	}
 
 	params = le16_to_cpu(mgmt->u.action.u.delba.params);
 	tid = (params & IEEE80211_DELBA_PARAM_TID_MASK) >> 12;
@@ -1424,7 +1449,7 @@ static void ieee80211_sta_process_delba(
 		ieee80211_stop_tx_ba_session(&local->hw, sta->addr, tid,
 					     WLAN_BACK_RECIPIENT);
 	}
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 
 /*
@@ -1447,9 +1472,13 @@ void sta_addba_resp_timer_expired(unsign
 	struct sta_info *sta;
 	u8 *state;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, temp_sta->addr);
-	if (!sta)
+	if (!sta) {
+		rcu_read_unlock();
 		return;
+	}
 
 	state = &sta->ampdu_mlme.tid_tx[tid].state;
 	/* check if the TID waits for addBA response */
@@ -1471,7 +1500,7 @@ void sta_addba_resp_timer_expired(unsign
 				     WLAN_BACK_INITIATOR);
 
 timer_expired_exit:
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 
 /*
@@ -1491,8 +1520,8 @@ void sta_rx_agg_session_timer_expired(un
 					 timer_to_tid[0]);
 
 	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
-	ieee80211_sta_stop_rx_ba_session(sta->dev, sta->addr, (u16)*ptid,
-					 WLAN_BACK_TIMER,
+	ieee80211_sta_stop_rx_ba_session(sta->sdata->dev, sta->addr,
+					 (u16)*ptid, WLAN_BACK_TIMER,
 					 WLAN_REASON_QSTA_TIMEOUT);
 }
 
@@ -1801,14 +1830,18 @@ static void ieee80211_rx_mgmt_assoc_resp
 	if (ifsta->assocresp_ies)
 		memcpy(ifsta->assocresp_ies, pos, ifsta->assocresp_ies_len);
 
+	rcu_read_lock();
+
 	/* Add STA entry for the AP */
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
 		struct ieee80211_sta_bss *bss;
-		sta = sta_info_add(local, dev, ifsta->bssid, GFP_KERNEL);
+
+		sta = sta_info_add(sdata, ifsta->bssid);
 		if (IS_ERR(sta)) {
 			printk(KERN_DEBUG "%s: failed to add STA entry for the"
 			       " AP (error %ld)\n", dev->name, PTR_ERR(sta));
+			rcu_read_unlock();
 			return;
 		}
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
@@ -1822,7 +1855,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 		}
 	}
 
-	sta->dev = dev;
 	sta->flags |= WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP |
 		      WLAN_STA_AUTHORIZED;
 
@@ -1893,7 +1925,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	bss_conf->aid = aid;
 	ieee80211_set_associated(dev, ifsta, 1);
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	ieee80211_associated(dev, ifsta);
 }
@@ -2218,6 +2250,8 @@ static void ieee80211_rx_bss_info(struct
 	beacon_timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
+	rcu_read_lock();
+
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
 	    (sta = sta_info_get(local, mgmt->sa))) {
@@ -2272,9 +2306,10 @@ static void ieee80211_rx_bss_info(struct
 			       (unsigned long long) supp_rates,
 			       (unsigned long long) sta->supp_rates[rx_status->band]);
 		}
-		sta_info_put(sta);
 	}
 
+	rcu_read_unlock();
+
 	if (!elems.ssid)
 		return;
 
@@ -2459,8 +2494,10 @@ static void ieee80211_rx_bss_info(struct
 				       "local TSF - IBSS merge with BSSID %s\n",
 				       dev->name, print_mac(mac, mgmt->bssid));
 			ieee80211_sta_join_ibss(dev, &sdata->u.sta, bss);
+			rcu_read_lock();
 			ieee80211_ibss_add_sta(dev, NULL,
 					       mgmt->bssid, mgmt->sa);
+			rcu_read_unlock();
 		}
 	}
 
@@ -2788,45 +2825,49 @@ static int ieee80211_sta_active_ibss(str
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int active = 0;
 	struct sta_info *sta;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	rcu_read_lock();
 
-	read_lock_bh(&local->sta_lock);
-	list_for_each_entry(sta, &local->sta_list, list) {
-		if (sta->dev == dev &&
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sta->sdata == sdata &&
 		    time_after(sta->last_rx + IEEE80211_IBSS_MERGE_INTERVAL,
 			       jiffies)) {
 			active++;
 			break;
 		}
 	}
-	read_unlock_bh(&local->sta_lock);
+
+	rcu_read_unlock();
 
 	return active;
 }
 
 
-static void ieee80211_sta_expire(struct net_device *dev)
+static void ieee80211_sta_expire_ibss(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta, *tmp;
 	LIST_HEAD(tmp_list);
 	DECLARE_MAC_BUF(mac);
+	unsigned long flags;
 
-	write_lock_bh(&local->sta_lock);
+	spin_lock_irqsave(&local->sta_lock, flags);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
 		if (time_after(jiffies, sta->last_rx +
 			       IEEE80211_IBSS_INACTIVITY_LIMIT)) {
 			printk(KERN_DEBUG "%s: expiring inactive STA %s\n",
 			       dev->name, print_mac(mac, sta->addr));
-			__sta_info_get(sta);
-			sta_info_remove(sta);
-			list_add(&sta->list, &tmp_list);
-		}
-	write_unlock_bh(&local->sta_lock);
-
-	list_for_each_entry_safe(sta, tmp, &tmp_list, list) {
-		sta_info_free(sta);
-		sta_info_put(sta);
-	}
+			sta_info_unlink(&sta);
+			if (sta)
+				list_add(&sta->list, &tmp_list);
+		}
+	spin_unlock_irqrestore(&local->sta_lock, flags);
+
+	synchronize_rcu();
+
+	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
+		sta_info_destroy(sta);
 }
 
 
@@ -2835,7 +2876,7 @@ static void ieee80211_sta_merge_ibss(str
 {
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
 
-	ieee80211_sta_expire(dev);
+	ieee80211_sta_expire_ibss(dev);
 	if (ieee80211_sta_active_ibss(dev))
 		return;
 
@@ -3796,6 +3837,7 @@ int ieee80211_sta_set_extra_ie(struct ne
 }
 
 
+/* must be called under RCU read lock */
 struct sta_info * ieee80211_ibss_add_sta(struct net_device *dev,
 					 struct sk_buff *skb, u8 *bssid,
 					 u8 *addr)
@@ -3818,7 +3860,7 @@ struct sta_info * ieee80211_ibss_add_sta
 	printk(KERN_DEBUG "%s: Adding new IBSS station %s (dev=%s)\n",
 	       wiphy_name(local->hw.wiphy), print_mac(mac, addr), dev->name);
 
-	sta = sta_info_add(local, dev, addr, GFP_ATOMIC);
+	sta = sta_info_add(sdata, addr);
 	if (IS_ERR(sta))
 		return NULL;
 
@@ -3829,7 +3871,7 @@ struct sta_info * ieee80211_ibss_add_sta
 
 	rate_control_rate_init(sta, local);
 
-	return sta; /* caller will call sta_info_put() */
+	return sta;
 }
 
 
--- everything.orig/net/mac80211/sta_info.c	2008-02-21 20:33:29.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-21 21:05:04.000000000 +0100
@@ -22,14 +22,43 @@
 #include "sta_info.h"
 #include "debugfs_sta.h"
 
-/* Caller must hold local->sta_lock */
-static void sta_info_hash_add(struct ieee80211_local *local,
-			      struct sta_info *sta)
-{
-	sta->hnext = local->sta_hash[STA_HASH(sta->addr)];
-	local->sta_hash[STA_HASH(sta->addr)] = sta;
-}
-
+/**
+ * DOC: STA information lifetime rules
+ *
+ * STA info structures (&struct sta_info) are managed in a hash table
+ * for faster lookup and a list for iteration. They are managed using
+ * RCU, i.e. access to the list and hash table is protected by RCU.
+ *
+ * STA info structures are always "alive" when they are added with
+ * @sta_info_add() [this may be changed in the future to allow allocating
+ * outside of a critical section!], they are then added to the hash
+ * table and list. Therefore, @sta_info_add() must also be RCU protected,
+ * also, the caller of @sta_info_add() cannot assume that it owns the
+ * structure.
+ *
+ * Because there are debugfs entries for each station, and adding those
+ * must be able to sleep, it is also possible to "pin" a station entry,
+ * that means it can be removed from the hash table but not be freed.
+ * See the comment in @__sta_info_unlink() for more information.
+ *
+ * In order to remove a STA info structure, the caller needs to first
+ * unlink it (@sta_info_unlink()) from the list and hash tables and
+ * then wait for an RCU synchronisation before it can be freed. Due to
+ * the pinning and the possibility of multiple callers trying to remove
+ * the same STA info at the same time, @sta_info_unlink() can clear the
+ * STA info pointer it is passed to indicate that the STA info is owned
+ * by somebody else now.
+ *
+ * If @sta_info_unlink() did not clear the pointer then the caller owns
+ * the STA info structure now and is responsible of destroying it with
+ * a call to @sta_info_destroy(), not before RCU synchronisation, of
+ * course.
+ *
+ * In all other cases, there is no concept of ownership on a STA entry,
+ * each structure is owned by the global hash table/list until it is
+ * removed. All users of the structure need to be RCU protected so that
+ * the structure won't be freed before they are done using it.
+ */
 
 /* Caller must hold local->sta_lock */
 static int sta_info_hash_del(struct ieee80211_local *local,
@@ -41,109 +70,108 @@ static int sta_info_hash_del(struct ieee
 	if (!s)
 		return -ENOENT;
 	if (s == sta) {
-		local->sta_hash[STA_HASH(sta->addr)] = s->hnext;
+		rcu_assign_pointer(local->sta_hash[STA_HASH(sta->addr)],
+				   s->hnext);
 		return 0;
 	}
 
 	while (s->hnext && s->hnext != sta)
 		s = s->hnext;
 	if (s->hnext) {
-		s->hnext = sta->hnext;
+		rcu_assign_pointer(s->hnext, sta->hnext);
 		return 0;
 	}
 
 	return -ENOENT;
 }
 
-/* must hold local->sta_lock */
+/* protected by RCU */
 static struct sta_info *__sta_info_find(struct ieee80211_local *local,
 					u8 *addr)
 {
 	struct sta_info *sta;
 
-	sta = local->sta_hash[STA_HASH(addr)];
+	sta = rcu_dereference(local->sta_hash[STA_HASH(addr)]);
 	while (sta) {
 		if (compare_ether_addr(sta->addr, addr) == 0)
 			break;
-		sta = sta->hnext;
+		sta = rcu_dereference(sta->hnext);
 	}
 	return sta;
 }
 
 struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr)
 {
-	struct sta_info *sta;
-
-	read_lock_bh(&local->sta_lock);
-	sta = __sta_info_find(local, addr);
-	if (sta)
-		__sta_info_get(sta);
-	read_unlock_bh(&local->sta_lock);
-
-	return sta;
+	return __sta_info_find(local, addr);
 }
 EXPORT_SYMBOL(sta_info_get);
 
 
-static void sta_info_release(struct kref *kref)
+void sta_info_destroy(struct sta_info *sta)
 {
-	struct sta_info *sta = container_of(kref, struct sta_info, kref);
 	struct ieee80211_local *local = sta->local;
 	struct sk_buff *skb;
 	int i;
 
-	/* free sta structure; it has already been removed from
-	 * hash table etc. external structures. Make sure that all
-	 * buffered frames are release (one might have been added
-	 * after sta_info_free() was called). */
+	ieee80211_key_free(sta->key);
+	sta->key = NULL;
+
+	rate_control_remove_sta_debugfs(sta);
+	ieee80211_sta_debugfs_remove(sta);
+
 	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
 		local->total_ps_buffered--;
 		dev_kfree_skb_any(skb);
 	}
-	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
+
+	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL)
 		dev_kfree_skb_any(skb);
-	}
+
 	for (i = 0; i <  STA_TID_NUM; i++) {
 		del_timer_sync(&sta->ampdu_mlme.tid_rx[i].session_timer);
 		del_timer_sync(&sta->ampdu_mlme.tid_tx[i].addba_resp_timer);
 	}
 	rate_control_free_sta(sta->rate_ctrl, sta->rate_ctrl_priv);
 	rate_control_put(sta->rate_ctrl);
+
 	kfree(sta);
 }
 
 
-void sta_info_put(struct sta_info *sta)
+/* Caller must hold local->sta_lock */
+static void sta_info_hash_add(struct ieee80211_local *local,
+			      struct sta_info *sta)
 {
-	kref_put(&sta->kref, sta_info_release);
+	sta->hnext = local->sta_hash[STA_HASH(sta->addr)];
+	local->sta_hash[STA_HASH(sta->addr)] = sta;
 }
-EXPORT_SYMBOL(sta_info_put);
-
 
-struct sta_info *sta_info_add(struct ieee80211_local *local,
-			      struct net_device *dev, u8 *addr, gfp_t gfp)
+struct sta_info *sta_info_add(struct ieee80211_sub_if_data *sdata,
+			      u8 *addr)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int i;
 	DECLARE_MAC_BUF(mac);
+	unsigned long flags;
 
-	sta = kzalloc(sizeof(*sta), gfp);
+	sta = kzalloc(sizeof(*sta), GFP_ATOMIC);
 	if (!sta)
 		return ERR_PTR(-ENOMEM);
 
-	kref_init(&sta->kref);
+	memcpy(sta->addr, addr, ETH_ALEN);
+	sta->local = local;
+	sta->sdata = sdata;
 
 	sta->rate_ctrl = rate_control_get(local->rate_ctrl);
-	sta->rate_ctrl_priv = rate_control_alloc_sta(sta->rate_ctrl, gfp);
+	sta->rate_ctrl_priv = rate_control_alloc_sta(sta->rate_ctrl,
+						     GFP_ATOMIC);
 	if (!sta->rate_ctrl_priv) {
 		rate_control_put(sta->rate_ctrl);
 		kfree(sta);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	memcpy(sta->addr, addr, ETH_ALEN);
-	sta->local = local;
-	sta->dev = dev;
 	spin_lock_init(&sta->ampdu_mlme.ampdu_rx);
 	spin_lock_init(&sta->ampdu_mlme.ampdu_tx);
 	for (i = 0; i < STA_TID_NUM; i++) {
@@ -168,29 +196,26 @@ struct sta_info *sta_info_add(struct iee
 	}
 	skb_queue_head_init(&sta->ps_tx_buf);
 	skb_queue_head_init(&sta->tx_filtered);
-	write_lock_bh(&local->sta_lock);
-	/* mark sta as used (by caller) */
-	__sta_info_get(sta);
+	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
 	if (__sta_info_find(local, addr)) {
-		write_unlock_bh(&local->sta_lock);
-		sta_info_put(sta);
+		spin_unlock_irqrestore(&local->sta_lock, flags);
 		return ERR_PTR(-EEXIST);
 	}
 	list_add(&sta->list, &local->sta_list);
 	local->num_sta++;
 	sta_info_hash_add(local, sta);
-	if (local->ops->sta_notify) {
-		struct ieee80211_sub_if_data *sdata;
 
-		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	/* notify driver */
+	if (local->ops->sta_notify) {
 		if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
 			sdata = sdata->u.vlan.ap;
 
 		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
 				       STA_NOTIFY_ADD, addr);
 	}
-	write_unlock_bh(&local->sta_lock);
+
+	spin_unlock_irqrestore(&local->sta_lock, flags);
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Added STA %s\n",
@@ -230,19 +255,20 @@ static void __sta_info_set_tim_bit(struc
 {
 	if (bss)
 		__bss_tim_set(bss, sta->aid);
-	if (sta->local->ops->set_tim)
+	if (sta->local->ops->set_tim) {
+		sta->local->tim_in_locked_section = true;
 		sta->local->ops->set_tim(local_to_hw(sta->local), sta->aid, 1);
+		sta->local->tim_in_locked_section = false;
+	}
 }
 
 void sta_info_set_tim_bit(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	unsigned long flags;
 
-	read_lock_bh(&sta->local->sta_lock);
-	__sta_info_set_tim_bit(sdata->bss, sta);
-	read_unlock_bh(&sta->local->sta_lock);
+	spin_lock_irqsave(&sta->local->sta_lock, flags);
+	__sta_info_set_tim_bit(sta->sdata->bss, sta);
+	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
 }
 
 static void __sta_info_clear_tim_bit(struct ieee80211_if_ap *bss,
@@ -250,88 +276,128 @@ static void __sta_info_clear_tim_bit(str
 {
 	if (bss)
 		__bss_tim_clear(bss, sta->aid);
-	if (sta->local->ops->set_tim)
+	if (sta->local->ops->set_tim) {
+		sta->local->tim_in_locked_section = true;
 		sta->local->ops->set_tim(local_to_hw(sta->local), sta->aid, 0);
+		sta->local->tim_in_locked_section = false;
+	}
 }
 
 void sta_info_clear_tim_bit(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata;
+	unsigned long flags;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	spin_lock_irqsave(&sta->local->sta_lock, flags);
+	__sta_info_clear_tim_bit(sta->sdata->bss, sta);
+	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
+}
 
-	read_lock_bh(&sta->local->sta_lock);
-	__sta_info_clear_tim_bit(sdata->bss, sta);
-	read_unlock_bh(&sta->local->sta_lock);
+/*
+ * See comment in __sta_info_unlink,
+ * caller must hold local->sta_lock.
+ */
+static void __sta_info_pin(struct sta_info *sta)
+{
+	WARN_ON(sta->pin_status != STA_INFO_PIN_STAT_NORMAL);
+	sta->pin_status = STA_INFO_PIN_STAT_PINNED;
 }
 
-/* Caller must hold local->sta_lock */
-void sta_info_remove(struct sta_info *sta)
+/*
+ * See comment in __sta_info_unlink, returns sta if it
+ * needs to be destroyed.
+ */
+static struct sta_info *__sta_info_unpin(struct sta_info *sta)
 {
-	struct ieee80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *ret = NULL;
+	unsigned long flags;
 
-	/* don't do anything if we've been removed already */
-	if (sta_info_hash_del(local, sta))
-		return;
+	spin_lock_irqsave(&sta->local->sta_lock, flags);
+	WARN_ON(sta->pin_status != STA_INFO_PIN_STAT_DESTROY &&
+		sta->pin_status != STA_INFO_PIN_STAT_PINNED);
+	if (sta->pin_status == STA_INFO_PIN_STAT_DESTROY)
+		ret = sta;
+	sta->pin_status = STA_INFO_PIN_STAT_NORMAL;
+	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
 
-	list_del(&sta->list);
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
-	if (sta->flags & WLAN_STA_PS) {
-		sta->flags &= ~WLAN_STA_PS;
-		if (sdata->bss)
-			atomic_dec(&sdata->bss->num_sta_ps);
-		__sta_info_clear_tim_bit(sdata->bss, sta);
-	}
-	local->num_sta--;
+	return ret;
 }
 
-void sta_info_free(struct sta_info *sta)
+static void __sta_info_unlink(struct sta_info **sta)
 {
-	struct sk_buff *skb;
-	struct ieee80211_local *local = sta->local;
-	DECLARE_MAC_BUF(mac);
+	struct ieee80211_local *local = (*sta)->local;
+	struct ieee80211_sub_if_data *sdata = (*sta)->sdata;
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	DECLARE_MAC_BUF(mbuf);
+#endif
+	/*
+	 * pull caller's reference if we're already gone.
+	 */
+	if (sta_info_hash_del(local, *sta)) {
+		*sta = NULL;
+		return;
+	}
 
-	might_sleep();
+	/*
+	 * Also pull caller's reference if the STA is pinned by the
+	 * task that is adding the debugfs entries. In that case, we
+	 * leave the STA "to be freed".
+	 *
+	 * The rules are not trivial, but not too complex either:
+	 *  (1) pin_status is only modified under the sta_lock
+	 *  (2) sta_info_debugfs_add_work() will set the status
+	 *	to PINNED when it found an item that needs a new
+	 *	debugfs directory created. In that case, that item
+	 *	must not be freed although all *RCU* users are done
+	 *	with it. Hence, we tell the caller of _unlink()
+	 *	that the item is already gone (as can happen when
+	 *	two tasks try to unlink/destroy at the same time)
+	 *  (3) We set the pin_status to DESTROY here when we
+	 *	find such an item.
+	 *  (4) sta_info_debugfs_add_work() will reset the pin_status
+	 *	from PINNED to NORMAL when it is done with the item,
+	 *	but will check for DESTROY before resetting it in
+	 *	which case it will free the item.
+	 */
+	if ((*sta)->pin_status == STA_INFO_PIN_STAT_PINNED) {
+		(*sta)->pin_status = STA_INFO_PIN_STAT_DESTROY;
+		*sta = NULL;
+		return;
+	}
 
-	write_lock_bh(&local->sta_lock);
-	sta_info_remove(sta);
-	write_unlock_bh(&local->sta_lock);
+	list_del(&(*sta)->list);
 
-	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
-		local->total_ps_buffered--;
-		dev_kfree_skb(skb);
-	}
-	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
-		dev_kfree_skb(skb);
+	if ((*sta)->flags & WLAN_STA_PS) {
+		(*sta)->flags &= ~WLAN_STA_PS;
+		if (sdata->bss)
+			atomic_dec(&sdata->bss->num_sta_ps);
+		__sta_info_clear_tim_bit(sdata->bss, *sta);
 	}
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: Removed STA %s\n",
-	       wiphy_name(local->hw.wiphy), print_mac(mac, sta->addr));
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-
-	ieee80211_key_free(sta->key);
-	sta->key = NULL;
+	local->num_sta--;
 
 	if (local->ops->sta_notify) {
-		struct ieee80211_sub_if_data *sdata;
-
-		sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
-
 		if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
 			sdata = sdata->u.vlan.ap;
 
 		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
-				       STA_NOTIFY_REMOVE, sta->addr);
+				       STA_NOTIFY_REMOVE, (*sta)->addr);
 	}
 
-	rate_control_remove_sta_debugfs(sta);
-	ieee80211_sta_debugfs_remove(sta);
-
-	sta_info_put(sta);
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: Removed STA %s\n",
+	       wiphy_name(local->hw.wiphy), print_mac(mbuf, (*sta)->addr));
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 }
 
+void sta_info_unlink(struct sta_info **sta)
+{
+	struct ieee80211_local *local = (*sta)->local;
+	unsigned long flags;
+
+	spin_lock_irqsave(&local->sta_lock, flags);
+	__sta_info_unlink(sta);
+	spin_unlock_irqrestore(&local->sta_lock, flags);
+}
 
 static inline int sta_info_buffer_expired(struct ieee80211_local *local,
 					  struct sta_info *sta,
@@ -377,7 +443,7 @@ static void sta_info_cleanup_expire_buff
 		if (!skb)
 			break;
 
-		sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+		sdata = sta->sdata;
 		local->total_ps_buffered--;
 		printk(KERN_DEBUG "Buffered frame expired (STA "
 		       "%s)\n", print_mac(mac, sta->addr));
@@ -394,13 +460,10 @@ static void sta_info_cleanup(unsigned lo
 	struct ieee80211_local *local = (struct ieee80211_local *) data;
 	struct sta_info *sta;
 
-	read_lock_bh(&local->sta_lock);
-	list_for_each_entry(sta, &local->sta_list, list) {
-		__sta_info_get(sta);
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &local->sta_list, list)
 		sta_info_cleanup_expire_buffered(local, sta);
-		sta_info_put(sta);
-	}
-	read_unlock_bh(&local->sta_lock);
+	rcu_read_unlock();
 
 	local->sta_cleanup.expires =
 		round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL);
@@ -408,37 +471,45 @@ static void sta_info_cleanup(unsigned lo
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-static void sta_info_debugfs_add_task(struct work_struct *work)
+static void sta_info_debugfs_add_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, sta_debugfs_add);
 	struct sta_info *sta, *tmp;
+	unsigned long flags;
 
 	while (1) {
 		sta = NULL;
-		read_lock_bh(&local->sta_lock);
+
+		spin_lock_irqsave(&local->sta_lock, flags);
 		list_for_each_entry(tmp, &local->sta_list, list) {
 			if (!tmp->debugfs.dir) {
 				sta = tmp;
-				__sta_info_get(sta);
+				__sta_info_pin(sta);
 				break;
 			}
 		}
-		read_unlock_bh(&local->sta_lock);
+		spin_unlock_irqrestore(&local->sta_lock, flags);
 
 		if (!sta)
 			break;
 
 		ieee80211_sta_debugfs_add(sta);
 		rate_control_add_sta_debugfs(sta);
-		sta_info_put(sta);
+
+		sta = __sta_info_unpin(sta);
+
+		if (sta) {
+			synchronize_rcu();
+			sta_info_destroy(sta);
+		}
 	}
 }
 #endif
 
 void sta_info_init(struct ieee80211_local *local)
 {
-	rwlock_init(&local->sta_lock);
+	spin_lock_init(&local->sta_lock);
 	INIT_LIST_HEAD(&local->sta_list);
 
 	setup_timer(&local->sta_cleanup, sta_info_cleanup,
@@ -447,7 +518,7 @@ void sta_info_init(struct ieee80211_loca
 		round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-	INIT_WORK(&local->sta_debugfs_add, sta_info_debugfs_add_task);
+	INIT_WORK(&local->sta_debugfs_add, sta_info_debugfs_add_work);
 #endif
 }
 
@@ -466,24 +537,29 @@ void sta_info_stop(struct ieee80211_loca
 /**
  * sta_info_flush - flush matching STA entries from the STA table
  * @local: local interface data
- * @dev: matching rule for the net device (sta->dev) or %NULL to match all STAs
+ * @sdata: matching rule for the net device (sta->dev) or %NULL to match all STAs
  */
-void sta_info_flush(struct ieee80211_local *local, struct net_device *dev)
+void sta_info_flush(struct ieee80211_local *local,
+		    struct ieee80211_sub_if_data *sdata)
 {
 	struct sta_info *sta, *tmp;
 	LIST_HEAD(tmp_list);
+	unsigned long flags;
 
-	write_lock_bh(&local->sta_lock);
-	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
-		if (!dev || dev == sta->dev) {
-			__sta_info_get(sta);
-			sta_info_remove(sta);
-			list_add_tail(&sta->list, &tmp_list);
-		}
-	write_unlock_bh(&local->sta_lock);
+	might_sleep();
 
-	list_for_each_entry_safe(sta, tmp, &tmp_list, list) {
-		sta_info_free(sta);
-		sta_info_put(sta);
+	spin_lock_irqsave(&local->sta_lock, flags);
+	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
+		if (!sdata || sdata == sta->sdata) {
+			__sta_info_unlink(&sta);
+			if (sta)
+				list_add_tail(&sta->list, &tmp_list);
+		}
 	}
+	spin_unlock_irqrestore(&local->sta_lock, flags);
+
+	synchronize_rcu();
+
+	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
+		sta_info_destroy(sta);
 }
--- everything.orig/net/mac80211/sta_info.h	2008-02-21 20:33:28.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-21 20:55:09.000000000 +0100
@@ -12,7 +12,6 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
-#include <linux/kref.h>
 #include "ieee80211_key.h"
 
 /**
@@ -124,8 +123,14 @@ struct sta_ampdu_mlme {
 	u8 dialog_token_allocator;
 };
 
+
+/* see __sta_info_unlink */
+#define STA_INFO_PIN_STAT_NORMAL	0
+#define STA_INFO_PIN_STAT_PINNED	1
+#define STA_INFO_PIN_STAT_DESTROY	2
+
+
 struct sta_info {
-	struct kref kref;
 	struct list_head list;
 	struct sta_info *hnext; /* next entry in hash table list */
 
@@ -154,8 +159,8 @@ struct sta_info {
 	/* last rates used to send a frame to this STA */
 	int last_txrate_idx, last_nonerp_txrate_idx;
 
-	struct net_device *dev; /* which net device is this station associated
-				 * to */
+	/* sub_if_data this sta belongs to */
+	struct ieee80211_sub_if_data *sdata;
 
 	struct ieee80211_key *key;
 
@@ -189,6 +194,12 @@ struct sta_info {
 
 	u16 listen_interval;
 
+	/*
+	 * for use by the internal lifetime management,
+	 * see __sta_info_unlink
+	 */
+	u8 pin_status;
+
 	struct ieee80211_ht_info ht_info; /* 802.11n HT capabilities
 					     of this STA */
 	struct sta_ampdu_mlme ampdu_mlme;
@@ -232,23 +243,32 @@ struct sta_info {
  */
 #define STA_INFO_CLEANUP_INTERVAL (10 * HZ)
 
-static inline void __sta_info_get(struct sta_info *sta)
-{
-	kref_get(&sta->kref);
-}
-
-struct sta_info * sta_info_get(struct ieee80211_local *local, u8 *addr);
-void sta_info_put(struct sta_info *sta);
-struct sta_info *sta_info_add(struct ieee80211_local *local,
-			      struct net_device *dev, u8 *addr, gfp_t gfp);
-void sta_info_remove(struct sta_info *sta);
-void sta_info_free(struct sta_info *sta);
-void sta_info_init(struct ieee80211_local *local);
-int sta_info_start(struct ieee80211_local *local);
-void sta_info_stop(struct ieee80211_local *local);
-void sta_info_flush(struct ieee80211_local *local, struct net_device *dev);
+/*
+ * Get a STA info, must have be under RCU read lock.
+ */
+struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr);
+/*
+ * Add a new STA info, must be under RCU read lock
+ * because otherwise the returned reference isn't
+ * necessarily valid long enough.
+ */
+struct sta_info *sta_info_add(struct ieee80211_sub_if_data *sdata,
+			      u8 *addr);
+/*
+ * Unlink a STA info from the hash table/list.
+ * This can NULL the STA pointer if somebody else
+ * has already unlinked it.
+ */
+void sta_info_unlink(struct sta_info **sta);
 
+void sta_info_destroy(struct sta_info *sta);
 void sta_info_set_tim_bit(struct sta_info *sta);
 void sta_info_clear_tim_bit(struct sta_info *sta);
 
+void sta_info_init(struct ieee80211_local *local);
+int sta_info_start(struct ieee80211_local *local);
+void sta_info_stop(struct ieee80211_local *local);
+void sta_info_flush(struct ieee80211_local *local,
+		    struct ieee80211_sub_if_data *sdata);
+
 #endif /* STA_INFO_H */
--- everything.orig/net/mac80211/tx.c	2008-02-21 20:33:29.000000000 +0100
+++ everything/net/mac80211/tx.c	2008-02-21 20:55:10.000000000 +0100
@@ -323,10 +323,8 @@ static void purge_old_ps_buffers(struct 
 		}
 		total += skb_queue_len(&ap->ps_bc_buf);
 	}
-	rcu_read_unlock();
 
-	read_lock_bh(&local->sta_lock);
-	list_for_each_entry(sta, &local->sta_list, list) {
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		skb = skb_dequeue(&sta->ps_tx_buf);
 		if (skb) {
 			purged++;
@@ -334,7 +332,8 @@ static void purge_old_ps_buffers(struct 
 		}
 		total += skb_queue_len(&sta->ps_tx_buf);
 	}
-	read_unlock_bh(&local->sta_lock);
+
+	rcu_read_unlock();
 
 	local->total_ps_buffered = total;
 	printk(KERN_DEBUG "%s: PS buffers full - purged %d frames\n",
@@ -1137,20 +1136,17 @@ static int ieee80211_tx(struct net_devic
 		return 0;
 	}
 
+	rcu_read_lock();
+
 	/* initialises tx */
 	res_prepare = __ieee80211_tx_prepare(&tx, skb, dev, control);
 
 	if (res_prepare == TX_DROP) {
 		dev_kfree_skb(skb);
+		rcu_read_unlock();
 		return 0;
 	}
 
-	/*
-	 * key references are protected using RCU and this requires that
-	 * we are in a read-site RCU section during receive processing
-	 */
-	rcu_read_lock();
-
 	sta = tx.sta;
 	tx.u.tx.channel = local->hw.conf.channel;
 
@@ -1163,9 +1159,6 @@ static int ieee80211_tx(struct net_devic
 
 	skb = tx.skb; /* handlers are allowed to change skb */
 
-	if (sta)
-		sta_info_put(sta);
-
 	if (unlikely(res == TX_DROP)) {
 		I802_DEBUG_INC(local->tx_handlers_drop);
 		goto drop;
@@ -1453,11 +1446,11 @@ int ieee80211_subif_start_xmit(struct sk
 	 * in AP mode)
 	 */
 	if (!is_multicast_ether_addr(hdr.addr1)) {
+		rcu_read_lock();
 		sta = sta_info_get(local, hdr.addr1);
-		if (sta) {
+		if (sta)
 			sta_flags = sta->flags;
-			sta_info_put(sta);
-		}
+		rcu_read_unlock();
 	}
 
 	/* receiver is QoS enabled, use a QoS type frame */
@@ -1680,7 +1673,6 @@ static void ieee80211_beacon_add_tim(str
 
 	/* Generate bitmap for TIM only if there are any STAs in power save
 	 * mode. */
-	read_lock_bh(&local->sta_lock);
 	if (atomic_read(&bss->num_sta_ps) > 0)
 		/* in the hope that this is faster than
 		 * checking byte-for-byte */
@@ -1731,7 +1723,6 @@ static void ieee80211_beacon_add_tim(str
 		*pos++ = aid0; /* Bitmap control */
 		*pos++ = 0; /* Part Virt Bitmap */
 	}
-	read_unlock_bh(&local->sta_lock);
 }
 
 struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
@@ -1779,7 +1770,22 @@ struct sk_buff *ieee80211_beacon_get(str
 
 	ieee80211_include_sequence(sdata, (struct ieee80211_hdr *)skb->data);
 
-	ieee80211_beacon_add_tim(local, ap, skb, beacon);
+	/*
+	 * Not very nice, but we want to allow the driver to call
+	 * ieee80211_beacon_get() as a response to the set_tim()
+	 * callback. That, however, is already invoked under the
+	 * sta_lock to guarantee consistent and race-free update
+	 * of the tim bitmap in mac80211 and the driver.
+	 */
+	if (local->tim_in_locked_section) {
+		ieee80211_beacon_add_tim(local, ap, skb, beacon);
+	} else {
+		unsigned long flags;
+
+		spin_lock_irqsave(&local->sta_lock, flags);
+		ieee80211_beacon_add_tim(local, ap, skb, beacon);
+		spin_unlock_irqrestore(&local->sta_lock, flags);
+	}
 
 	if (beacon->tail)
 		memcpy(skb_put(skb, beacon->tail_len), beacon->tail,
@@ -1881,7 +1887,6 @@ ieee80211_get_buffered_bc(struct ieee802
 		rcu_read_unlock();
 		return NULL;
 	}
-	rcu_read_unlock();
 
 	if (bss->dtim_count != 0)
 		return NULL; /* send buffered bc/mc only after DTIM beacon */
@@ -1926,8 +1931,7 @@ ieee80211_get_buffered_bc(struct ieee802
 		skb = NULL;
 	}
 
-	if (sta)
-		sta_info_put(sta);
+	rcu_read_unlock();
 
 	return skb;
 }
--- everything.orig/net/mac80211/cfg.c	2008-02-21 20:33:46.000000000 +0100
+++ everything/net/mac80211/cfg.c	2008-02-21 20:34:01.000000000 +0100
@@ -128,7 +128,6 @@ static int ieee80211_add_key(struct wiph
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta = NULL;
 	enum ieee80211_key_alg alg;
-	int ret;
 	struct ieee80211_key *key;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -152,21 +151,22 @@ static int ieee80211_add_key(struct wiph
 	if (!key)
 		return -ENOMEM;
 
+	rcu_read_lock();
+
 	if (mac_addr) {
 		sta = sta_info_get(sdata->local, mac_addr);
 		if (!sta) {
 			ieee80211_key_free(key);
+			rcu_read_unlock();
 			return -ENOENT;
 		}
 	}
 
 	ieee80211_key_link(key, sdata, sta);
-	ret = 0;
 
-	if (sta)
-		sta_info_put(sta);
+	rcu_read_unlock();
 
-	return ret;
+	return 0;
 }
 
 static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
@@ -179,9 +179,13 @@ static int ieee80211_del_key(struct wiph
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (mac_addr) {
+		rcu_read_lock();
+
 		sta = sta_info_get(sdata->local, mac_addr);
-		if (!sta)
+		if (!sta) {
+			rcu_read_unlock();
 			return -ENOENT;
+		}
 
 		ret = 0;
 		if (sta->key)
@@ -189,7 +193,7 @@ static int ieee80211_del_key(struct wiph
 		else
 			ret = -ENOENT;
 
-		sta_info_put(sta);
+		rcu_read_unlock();
 		return ret;
 	}
 
@@ -215,6 +219,8 @@ static int ieee80211_get_key(struct wiph
 	u16 iv16;
 	int err = -ENOENT;
 
+	rcu_read_lock();
+
 	if (mac_addr) {
 		sta = sta_info_get(sdata->local, mac_addr);
 		if (!sta)
@@ -278,8 +284,7 @@ static int ieee80211_get_key(struct wiph
 	err = 0;
 
  out:
-	if (sta)
-		sta_info_put(sta);
+	rcu_read_unlock();
 	return err;
 }
 
@@ -301,9 +306,13 @@ static int ieee80211_get_station(struct 
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, mac);
-	if (!sta)
+	if (!sta) {
+		rcu_read_unlock();
 		return -ENOENT;
+	}
 
 	/* XXX: verify sta->dev == dev */
 
@@ -315,7 +324,7 @@ static int ieee80211_get_station(struct 
 	stats->rx_bytes = sta->rx_bytes;
 	stats->tx_bytes = sta->tx_bytes;
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	return 0;
 }
@@ -510,8 +519,8 @@ static void ieee80211_send_layer2_update
 	msg->xid_info[1] = 1;	/* LLC types/classes: Type 1 LLC */
 	msg->xid_info[2] = 0;	/* XID sender's receive window size (RW) */
 
-	skb->dev = sta->dev;
-	skb->protocol = eth_type_trans(skb, sta->dev);
+	skb->dev = sta->sdata->dev;
+	skb->protocol = eth_type_trans(skb, sta->sdata->dev);
 	memset(skb->cb, 0, sizeof(skb->cb));
 	netif_rx(skb);
 }
@@ -582,11 +591,14 @@ static int ieee80211_add_station(struct 
 	} else
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	sta = sta_info_add(local, dev, mac, GFP_KERNEL);
-	if (IS_ERR(sta))
+	rcu_read_lock();
+
+	sta = sta_info_add(sdata, mac);
+	if (IS_ERR(sta)) {
+		rcu_read_unlock();
 		return PTR_ERR(sta);
+	}
 
-	sta->dev = sdata->dev;
 	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN ||
 	    sdata->vif.type == IEEE80211_IF_TYPE_AP)
 		ieee80211_send_layer2_update(sta);
@@ -597,7 +609,7 @@ static int ieee80211_add_station(struct 
 
 	rate_control_rate_init(sta, local);
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	return 0;
 }
@@ -605,19 +617,29 @@ static int ieee80211_add_station(struct 
 static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
 	if (mac) {
 		/* XXX: get sta belonging to dev */
+		rcu_read_lock();
 		sta = sta_info_get(local, mac);
-		if (!sta)
+		if (!sta) {
+			rcu_read_unlock();
 			return -ENOENT;
+		}
+
+		sta_info_unlink(&sta);
 
-		sta_info_free(sta);
-		sta_info_put(sta);
+		rcu_read_unlock();
+
+		if (sta) {
+			synchronize_rcu();
+			sta_info_destroy(sta);
+		}
 	} else
-		sta_info_flush(local, dev);
+		sta_info_flush(local, sdata);
 
 	return 0;
 }
@@ -631,25 +653,31 @@ static int ieee80211_change_station(stru
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *vlansdata;
 
+	rcu_read_lock();
+
 	/* XXX: get sta belonging to dev */
 	sta = sta_info_get(local, mac);
-	if (!sta)
+	if (!sta) {
+		rcu_read_unlock();
 		return -ENOENT;
+	}
 
-	if (params->vlan && params->vlan != sta->dev) {
+	if (params->vlan && params->vlan != sta->sdata->dev) {
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
 		if (vlansdata->vif.type != IEEE80211_IF_TYPE_VLAN ||
-		    vlansdata->vif.type != IEEE80211_IF_TYPE_AP)
+		    vlansdata->vif.type != IEEE80211_IF_TYPE_AP) {
+		    	rcu_read_unlock();
 			return -EINVAL;
+		}
 
-		sta->dev = params->vlan;
+		sta->sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 		ieee80211_send_layer2_update(sta);
 	}
 
 	sta_apply_parameters(local, sta, params);
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	return 0;
 }
--- everything.orig/net/mac80211/ieee80211.c	2008-02-21 20:33:29.000000000 +0100
+++ everything/net/mac80211/ieee80211.c	2008-02-21 20:55:10.000000000 +0100
@@ -367,15 +367,19 @@ static int ieee80211_stop(struct net_dev
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	list_for_each_entry(sta, &local->sta_list, list) {
-		if (sta->dev == dev)
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sta->sdata == sdata)
 			for (i = 0; i <  STA_TID_NUM; i++)
-				ieee80211_sta_stop_rx_ba_session(sta->dev,
+				ieee80211_sta_stop_rx_ba_session(sdata->dev,
 						sta->addr, i,
 						WLAN_BACK_RECIPIENT,
 						WLAN_REASON_QSTA_LEAVE_QBSS);
 	}
 
+	rcu_read_unlock();
+
 	netif_stop_queue(dev);
 
 	/*
@@ -511,9 +515,12 @@ int ieee80211_start_tx_ba_session(struct
 				print_mac(mac, ra), tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, ra);
 	if (!sta) {
 		printk(KERN_DEBUG "Could not find the station\n");
+		rcu_read_unlock();
 		return -ENOENT;
 	}
 
@@ -553,7 +560,7 @@ int ieee80211_start_tx_ba_session(struct
 		spin_unlock_bh(&local->mdev->queue_lock);
 		goto start_ba_exit;
 	}
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = sta->sdata;
 
 	/* Ok, the Addba frame hasn't been sent yet, but if the driver calls the
 	 * call back right away, it must see that the flow has begun */
@@ -590,7 +597,7 @@ int ieee80211_start_tx_ba_session(struct
 			sta->ampdu_mlme.dialog_token_allocator;
 	sta->ampdu_mlme.tid_tx[tid].ssn = start_seq_num;
 
-	ieee80211_send_addba_request(sta->dev, ra, tid,
+	ieee80211_send_addba_request(sta->sdata->dev, ra, tid,
 			 sta->ampdu_mlme.tid_tx[tid].dialog_token,
 			 sta->ampdu_mlme.tid_tx[tid].ssn,
 			 0x40, 5000);
@@ -603,7 +610,7 @@ int ieee80211_start_tx_ba_session(struct
 
 start_ba_exit:
 	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
-	sta_info_put(sta);
+	rcu_read_unlock();
 	return ret;
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
@@ -626,9 +633,12 @@ int ieee80211_stop_tx_ba_session(struct 
 				print_mac(mac, ra), tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
+	rcu_read_lock();
 	sta = sta_info_get(local, ra);
-	if (!sta)
+	if (!sta) {
+		rcu_read_unlock();
 		return -ENOENT;
+	}
 
 	/* check if the TID is in aggregation */
 	state = &sta->ampdu_mlme.tid_tx[tid].state;
@@ -662,7 +672,7 @@ int ieee80211_stop_tx_ba_session(struct 
 
 stop_BA_exit:
 	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
-	sta_info_put(sta);
+	rcu_read_unlock();
 	return ret;
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
@@ -680,8 +690,10 @@ void ieee80211_start_tx_ba_cb(struct iee
 		return;
 	}
 
+	rcu_read_lock();
 	sta = sta_info_get(local, ra);
 	if (!sta) {
+		rcu_read_unlock();
 		printk(KERN_DEBUG "Could not find station: %s\n",
 				print_mac(mac, ra));
 		return;
@@ -694,7 +706,7 @@ void ieee80211_start_tx_ba_cb(struct iee
 		printk(KERN_DEBUG "addBA was not requested yet, state is %d\n",
 				*state);
 		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
-		sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -707,7 +719,7 @@ void ieee80211_start_tx_ba_cb(struct iee
 		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
 	}
 	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb);
 
@@ -728,10 +740,12 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	printk(KERN_DEBUG "Stop a BA session requested on DA %s tid %d\n",
 				print_mac(mac, ra), tid);
 
+	rcu_read_lock();
 	sta = sta_info_get(local, ra);
 	if (!sta) {
 		printk(KERN_DEBUG "Could not find station: %s\n",
 				print_mac(mac, ra));
+		rcu_read_unlock();
 		return;
 	}
 	state = &sta->ampdu_mlme.tid_tx[tid].state;
@@ -739,13 +753,13 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
 	if ((*state & HT_AGG_STATE_REQ_STOP_BA_MSK) == 0) {
 		printk(KERN_DEBUG "unexpected callback to A-MPDU stop\n");
-		sta_info_put(sta);
 		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		rcu_read_unlock();
 		return;
 	}
 
 	if (*state & HT_AGG_STATE_INITIATOR_MSK)
-		ieee80211_send_delba(sta->dev, ra, tid,
+		ieee80211_send_delba(sta->sdata->dev, ra, tid,
 			WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
 
 	agg_queue = sta->tid_to_tx_q[tid];
@@ -766,7 +780,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	sta->ampdu_mlme.tid_tx[tid].addba_req_num = 0;
 	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb);
 
@@ -876,32 +890,41 @@ int ieee80211_if_update_wds(struct net_d
 	struct sta_info *sta;
 	DECLARE_MAC_BUF(mac);
 
+	might_sleep();
+
 	if (compare_ether_addr(remote_addr, sdata->u.wds.remote_addr) == 0)
 		return 0;
 
+	rcu_read_lock();
+
 	/* Create STA entry for the new peer */
-	sta = sta_info_add(local, dev, remote_addr, GFP_KERNEL);
-	if (IS_ERR(sta))
+	sta = sta_info_add(sdata, remote_addr);
+	if (IS_ERR(sta)) {
+		rcu_read_unlock();
 		return PTR_ERR(sta);
+	}
 
 	sta->flags |= WLAN_STA_AUTHORIZED;
 
-	sta_info_put(sta);
-
 	/* Remove STA entry for the old peer */
 	sta = sta_info_get(local, sdata->u.wds.remote_addr);
-	if (sta) {
-		sta_info_free(sta);
-		sta_info_put(sta);
-	} else {
+	if (sta)
+		sta_info_unlink(&sta);
+	else
 		printk(KERN_DEBUG "%s: could not find STA entry for WDS link "
 		       "peer %s\n",
 		       dev->name, print_mac(mac, sdata->u.wds.remote_addr));
-	}
 
 	/* Update WDS link data */
 	memcpy(&sdata->u.wds.remote_addr, remote_addr, ETH_ALEN);
 
+	rcu_read_unlock();
+
+	if (sta) {
+		synchronize_rcu();
+		sta_info_destroy(sta);
+	}
+
 	return 0;
 }
 
@@ -1311,6 +1334,8 @@ void ieee80211_tx_status(struct ieee8021
 		return;
 	}
 
+	rcu_read_lock();
+
 	if (status->excessive_retries) {
 		struct sta_info *sta;
 		sta = sta_info_get(local, hdr->addr1);
@@ -1324,10 +1349,9 @@ void ieee80211_tx_status(struct ieee8021
 				status->flags |= IEEE80211_TX_STATUS_TX_FILTERED;
 				ieee80211_handle_filtered_frame(local, sta,
 								skb, status);
-				sta_info_put(sta);
+				rcu_read_unlock();
 				return;
 			}
-			sta_info_put(sta);
 		}
 	}
 
@@ -1337,12 +1361,14 @@ void ieee80211_tx_status(struct ieee8021
 		if (sta) {
 			ieee80211_handle_filtered_frame(local, sta, skb,
 							status);
-			sta_info_put(sta);
+			rcu_read_unlock();
 			return;
 		}
 	} else
 		rate_control_tx_status(local->mdev, skb, status);
 
+	rcu_read_unlock();
+
 	ieee80211_led_tx(local, 0);
 
 	/* SNMP counters
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-02-21 20:33:28.000000000 +0100
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-02-21 20:34:01.000000000 +0100
@@ -77,7 +77,7 @@ static void rate_control_pid_adjust_rate
 	int cur_sorted, new_sorted, probe, tmp, n_bitrates, band;
 	int cur = sta->txrate_idx;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = sta->sdata;
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	band = sband->band;
 	n_bitrates = sband->n_bitrates;
@@ -239,23 +239,25 @@ static void rate_control_pid_tx_status(v
 	unsigned long period;
 	struct ieee80211_supported_band *sband;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, hdr->addr1);
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	if (!sta)
-		return;
+		goto unlock;
 
 	/* Don't update the state if we're not controlling the rate. */
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = sta->sdata;
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
 		sta->txrate_idx = sdata->bss->max_ratectrl_rateidx;
-		return;
+		goto unlock;
 	}
 
 	/* Ignore all frames that were sent with a different rate than the rate
 	 * we currently advise mac80211 to use. */
 	if (status->control.tx_rate != &sband->bitrates[sta->txrate_idx])
-		goto ignore;
+		goto unlock;
 
 	spinfo = sta->rate_ctrl_priv;
 	spinfo->tx_num_xmit++;
@@ -296,8 +298,8 @@ static void rate_control_pid_tx_status(v
 	if (time_after(jiffies, spinfo->last_sample + period))
 		rate_control_pid_sample(pinfo, local, sta);
 
-ignore:
-	sta_info_put(sta);
+ unlock:
+	rcu_read_unlock();
 }
 
 static void rate_control_pid_get_rate(void *priv, struct net_device *dev,
@@ -312,6 +314,8 @@ static void rate_control_pid_get_rate(vo
 	int rateidx;
 	u16 fc;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, hdr->addr1);
 
 	/* Send management frames and broadcast/multicast data using lowest
@@ -320,8 +324,7 @@ static void rate_control_pid_get_rate(vo
 	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
 	    is_multicast_ether_addr(hdr->addr1) || !sta) {
 		sel->rate = rate_lowest(local, sband, sta);
-		if (sta)
-			sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -337,7 +340,7 @@ static void rate_control_pid_get_rate(vo
 
 	sta->last_txrate_idx = rateidx;
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	sel->rate = &sband->bitrates[rateidx];
 
--- everything.orig/net/mac80211/rc80211_simple.c	2008-02-21 20:33:28.000000000 +0100
+++ everything/net/mac80211/rc80211_simple.c	2008-02-21 20:34:01.000000000 +0100
@@ -40,7 +40,7 @@ static void rate_control_rate_inc(struct
 	int i = sta->txrate_idx;
 	int maxrate;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = sta->sdata;
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
 		/* forced unicast rate - do not change STA rate */
 		return;
@@ -70,7 +70,7 @@ static void rate_control_rate_dec(struct
 	struct ieee80211_supported_band *sband;
 	int i = sta->txrate_idx;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = sta->sdata;
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
 		/* forced unicast rate - do not change STA rate */
 		return;
@@ -118,10 +118,12 @@ static void rate_control_simple_tx_statu
 	struct sta_info *sta;
 	struct sta_rate_control *srctrl;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, hdr->addr1);
 
 	if (!sta)
-	    return;
+		goto unlock;
 
 	srctrl = sta->rate_ctrl_priv;
 	srctrl->tx_num_xmit++;
@@ -194,7 +196,8 @@ static void rate_control_simple_tx_statu
 		}
 	}
 
-	sta_info_put(sta);
+ unlock:
+	rcu_read_unlock();
 }
 
 
@@ -211,6 +214,8 @@ rate_control_simple_get_rate(void *priv,
 	int rateidx;
 	u16 fc;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, hdr->addr1);
 
 	/* Send management frames and broadcast/multicast data using lowest
@@ -219,8 +224,7 @@ rate_control_simple_get_rate(void *priv,
 	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
 	    is_multicast_ether_addr(hdr->addr1) || !sta) {
 		sel->rate = rate_lowest(local, sband, sta);
-		if (sta)
-			sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -236,7 +240,7 @@ rate_control_simple_get_rate(void *priv,
 
 	sta->last_txrate_idx = rateidx;
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	sel->rate = &sband->bitrates[rateidx];
 }
--- everything.orig/net/mac80211/rx.c	2008-02-21 20:33:28.000000000 +0100
+++ everything/net/mac80211/rx.c	2008-02-21 20:55:10.000000000 +0100
@@ -574,7 +574,7 @@ static void ap_sta_ps_start(struct net_d
 	struct ieee80211_sub_if_data *sdata;
 	DECLARE_MAC_BUF(mac);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = sta->sdata;
 
 	if (sdata->bss)
 		atomic_inc(&sdata->bss->num_sta_ps);
@@ -595,7 +595,7 @@ static int ap_sta_ps_end(struct net_devi
 	struct ieee80211_tx_packet_data *pkt_data;
 	DECLARE_MAC_BUF(mac);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = sta->sdata;
 
 	if (sdata->bss)
 		atomic_dec(&sdata->bss->num_sta_ps);
@@ -1212,7 +1212,7 @@ ieee80211_deliver_skb(struct ieee80211_t
 				       "multicast frame\n", dev->name);
 		} else {
 			dsta = sta_info_get(local, skb->data);
-			if (dsta && dsta->dev == dev) {
+			if (dsta && dsta->sdata->dev == dev) {
 				/*
 				 * The destination station is associated to
 				 * this AP (in this VLAN), so send the frame
@@ -1222,8 +1222,6 @@ ieee80211_deliver_skb(struct ieee80211_t
 				xmit_skb = skb;
 				skb = NULL;
 			}
-			if (dsta)
-				sta_info_put(dsta);
 		}
 	}
 
@@ -1786,13 +1784,13 @@ static void __ieee80211_rx_handle_packet
 
 	rx.sta = sta_info_get(local, hdr->addr2);
 	if (rx.sta) {
-		rx.dev = rx.sta->dev;
-		rx.sdata = IEEE80211_DEV_TO_SUB_IF(rx.dev);
+		rx.sdata = rx.sta->sdata;
+		rx.dev = rx.sta->sdata->dev;
 	}
 
 	if ((status->flag & RX_FLAG_MMIC_ERROR)) {
 		ieee80211_rx_michael_mic_report(local->mdev, hdr, &rx);
-		goto end;
+		return;
 	}
 
 	if (unlikely(local->sta_sw_scanning || local->sta_hw_scanning))
@@ -1851,10 +1849,6 @@ static void __ieee80211_rx_handle_packet
 		ieee80211_invoke_rx_handlers(prev, &rx, skb);
 	} else
 		dev_kfree_skb(skb);
-
- end:
-	if (rx.sta)
-		sta_info_put(rx.sta);
 }
 
 #define SEQ_MODULO 0x1000
@@ -2031,7 +2025,7 @@ static u8 ieee80211_rx_reorder_ampdu(str
 	/* if this mpdu is fragmented - terminate rx aggregation session */
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	if (sc & IEEE80211_SCTL_FRAG) {
-		ieee80211_sta_stop_rx_ba_session(sta->dev, sta->addr,
+		ieee80211_sta_stop_rx_ba_session(sta->sdata->dev, sta->addr,
 			tid, 0, WLAN_REASON_QSTA_REQUIRE_SETUP);
 		ret = 1;
 		goto end_reorder;
@@ -2041,9 +2035,7 @@ static u8 ieee80211_rx_reorder_ampdu(str
 	mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
 	ret = ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb,
 						mpdu_seq_num, 0);
-end_reorder:
-	if (sta)
-		sta_info_put(sta);
+ end_reorder:
 	return ret;
 }
 
--- everything.orig/net/mac80211/ieee80211_ioctl.c	2008-02-21 20:33:46.000000000 +0100
+++ everything/net/mac80211/ieee80211_ioctl.c	2008-02-21 20:34:01.000000000 +0100
@@ -47,14 +47,15 @@ static int ieee80211_set_encryption(stru
 	}
 
 	if (remove) {
+		rcu_read_lock();
+
 		if (is_broadcast_ether_addr(sta_addr)) {
 			key = sdata->keys[idx];
 		} else {
 			sta = sta_info_get(local, sta_addr);
 			if (!sta) {
 				ret = -ENOENT;
-				key = NULL;
-				goto err_out;
+				goto out_rcu_unlock;
 			}
 
 			key = sta->key;
@@ -64,11 +65,18 @@ static int ieee80211_set_encryption(stru
 			ret = -ENOENT;
 		else
 			ret = 0;
+
+		ieee80211_key_free(key);
+ out_rcu_unlock:
+		rcu_read_unlock();
+
+		return ret;
 	} else {
 		key = ieee80211_key_alloc(alg, idx, key_len, _key);
 		if (!key)
 			return -ENOMEM;
 
+		rcu_read_lock();
 		if (!is_broadcast_ether_addr(sta_addr)) {
 			set_tx_key = 0;
 			/*
@@ -79,13 +87,13 @@ static int ieee80211_set_encryption(stru
 			 */
 			if (idx != 0 && alg != ALG_WEP) {
 				ret = -EINVAL;
-				goto err_out;
+				goto out_free_unlock;
 			}
 
 			sta = sta_info_get(local, sta_addr);
 			if (!sta) {
 				ret = -ENOENT;
-				goto err_out;
+				goto out_free_unlock;
 			}
 		}
 
@@ -95,17 +103,17 @@ static int ieee80211_set_encryption(stru
 		if (set_tx_key || (!sta && !sdata->default_key && key))
 			ieee80211_set_default_key(sdata, idx);
 
+		ret = 0;
+
 		/* don't free key later */
 		key = NULL;
 
-		ret = 0;
-	}
+ out_free_unlock:
+		ieee80211_key_free(key);
+		rcu_read_unlock();
 
- err_out:
-	if (sta)
-		sta_info_put(sta);
-	ieee80211_key_free(key);
-	return ret;
+		return ret;
+	}
 }
 
 static int ieee80211_ioctl_siwgenie(struct net_device *dev,
@@ -611,15 +619,22 @@ static int ieee80211_ioctl_giwrate(struc
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_supported_band *sband;
+	int ret = 0;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
+	rcu_read_lock();
+
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
 		sta = sta_info_get(local, sdata->u.sta.bssid);
-	else
-		return -EOPNOTSUPP;
-	if (!sta)
-		return -ENODEV;
+	} else {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+	if (!sta) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
@@ -628,8 +643,11 @@ static int ieee80211_ioctl_giwrate(struc
 	else
 		rate->value = 0;
 	rate->value *= 100000;
-	sta_info_put(sta);
-	return 0;
+
+ out_unlock:
+	rcu_read_unlock();
+
+	return ret;
 }
 
 static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
@@ -988,6 +1006,8 @@ static struct iw_statistics *ieee80211_g
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta = NULL;
 
+	rcu_read_lock();
+
 	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
 	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS)
 		sta = sta_info_get(local, sdata->u.sta.bssid);
@@ -1003,8 +1023,10 @@ static struct iw_statistics *ieee80211_g
 		wstats->qual.qual = sta->last_signal;
 		wstats->qual.noise = sta->last_noise;
 		wstats->qual.updated = local->wstats_flags;
-		sta_info_put(sta);
 	}
+
+	rcu_read_unlock();
+
 	return wstats;
 }
 
--- everything.orig/net/mac80211/ieee80211_iface.c	2008-02-21 20:33:42.000000000 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2008-02-21 20:34:01.000000000 +0100
@@ -224,16 +224,21 @@ void ieee80211_if_reinit(struct net_devi
 		break;
 	}
 	case IEEE80211_IF_TYPE_WDS:
+		rcu_read_lock();
 		sta = sta_info_get(local, sdata->u.wds.remote_addr);
 		if (sta) {
-			sta_info_free(sta);
-			sta_info_put(sta);
+			sta_info_unlink(&sta);
 		} else {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			printk(KERN_DEBUG "%s: Someone had deleted my STA "
 			       "entry for the WDS link\n", dev->name);
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 		}
+		rcu_read_unlock();
+		if (sta) {
+			synchronize_rcu();
+			sta_info_destroy(sta);
+		}
 		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
@@ -258,7 +263,7 @@ void ieee80211_if_reinit(struct net_devi
 	}
 
 	/* remove all STAs that are bound to this virtual interface */
-	sta_info_flush(local, dev);
+	sta_info_flush(local, sdata);
 
 	memset(&sdata->u, 0, sizeof(sdata->u));
 	ieee80211_if_sdata_init(sdata);
--- everything.orig/net/mac80211/ieee80211_rate.c	2008-02-21 20:33:28.000000000 +0100
+++ everything/net/mac80211/ieee80211_rate.c	2008-02-21 20:34:01.000000000 +0100
@@ -170,9 +170,12 @@ void rate_control_get_rate(struct net_de
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct rate_control_ref *ref = local->rate_ctrl;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct sta_info *sta = sta_info_get(local, hdr->addr1);
+	struct sta_info *sta;
 	int i;
 
+	rcu_read_lock();
+	sta = sta_info_get(local, hdr->addr1);
+
 	memset(sel, 0, sizeof(struct rate_selection));
 
 	ref->ops->get_rate(ref->priv, dev, sband, skb, sel);
@@ -190,8 +193,7 @@ void rate_control_get_rate(struct net_de
 		}
 	}
 
-	if (sta)
-		sta_info_put(sta);
+	rcu_read_unlock();
 }
 
 struct rate_control_ref *rate_control_get(struct rate_control_ref *ref)
--- everything.orig/net/mac80211/ieee80211_rate.h	2008-02-21 20:33:28.000000000 +0100
+++ everything/net/mac80211/ieee80211_rate.h	2008-02-21 20:34:01.000000000 +0100
@@ -14,6 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
+#include <linux/kref.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "sta_info.h"
--- everything.orig/net/mac80211/key.c	2008-02-21 20:33:46.000000000 +0100
+++ everything/net/mac80211/key.c	2008-02-21 20:34:01.000000000 +0100
@@ -186,14 +186,17 @@ void ieee80211_key_link(struct ieee80211
 		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
 			struct sta_info *ap;
 
+			rcu_read_lock();
+
 			/* same here, the AP could be using QoS */
 			ap = sta_info_get(key->local, key->sdata->u.sta.bssid);
 			if (ap) {
 				if (ap->flags & WLAN_STA_WME)
 					key->conf.flags |=
 						IEEE80211_KEY_FLAG_WMM_STA;
-				sta_info_put(ap);
 			}
+
+			rcu_read_unlock();
 		}
 	}
 
--- everything.orig/net/mac80211/debugfs_sta.c	2008-02-21 20:33:28.000000000 +0100
+++ everything/net/mac80211/debugfs_sta.c	2008-02-21 20:55:10.000000000 +0100
@@ -51,7 +51,7 @@ static const struct file_operations sta_
 		STA_OPS(name)
 
 STA_FILE(aid, aid, D);
-STA_FILE(dev, dev->name, S);
+STA_FILE(dev, sdata->dev->name, S);
 STA_FILE(rx_packets, rx_packets, LU);
 STA_FILE(tx_packets, tx_packets, LU);
 STA_FILE(rx_bytes, rx_bytes, LU);
@@ -225,7 +225,7 @@ static ssize_t sta_agg_status_write(stru
 		const char __user *user_buf, size_t count, loff_t *ppos)
 {
 	struct sta_info *sta = file->private_data;
-	struct net_device *dev = sta->dev;
+	struct net_device *dev = sta->sdata->dev;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 	u8 *da = sta->addr;
--- everything.orig/net/mac80211/wme.c	2008-02-21 20:33:29.000000000 +0100
+++ everything/net/mac80211/wme.c	2008-02-21 20:55:10.000000000 +0100
@@ -153,6 +153,7 @@ static int wme_qdiscop_enqueue(struct sk
 
 	if (pkt_data->flags & IEEE80211_TXPD_REQUEUE) {
 		queue = pkt_data->queue;
+		rcu_read_lock();
 		sta = sta_info_get(local, hdr->addr1);
 		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
 		if (sta) {
@@ -164,8 +165,8 @@ static int wme_qdiscop_enqueue(struct sk
 			} else {
 				pkt_data->flags &= ~IEEE80211_TXPD_AMPDU;
 			}
-			sta_info_put(sta);
 		}
+		rcu_read_unlock();
 		skb_queue_tail(&q->requeued[queue], skb);
 		qd->q.qlen++;
 		return 0;
@@ -187,6 +188,8 @@ static int wme_qdiscop_enqueue(struct sk
 		p++;
 		*p = 0;
 
+		rcu_read_lock();
+
 		sta = sta_info_get(local, hdr->addr1);
 		if (sta) {
 			int ampdu_queue = sta->tid_to_tx_q[tid];
@@ -197,8 +200,9 @@ static int wme_qdiscop_enqueue(struct sk
 			} else {
 				pkt_data->flags &= ~IEEE80211_TXPD_AMPDU;
 			}
-			sta_info_put(sta);
 		}
+
+		rcu_read_unlock();
 	}
 
 	if (unlikely(queue >= local->hw.queues)) {
--- everything.orig/net/mac80211/debugfs_sta.h	2008-02-21 20:33:28.000000000 +0100
+++ everything/net/mac80211/debugfs_sta.h	2008-02-21 20:34:01.000000000 +0100
@@ -1,6 +1,8 @@
 #ifndef __MAC80211_DEBUGFS_STA_H
 #define __MAC80211_DEBUGFS_STA_H
 
+#include "sta_info.h"
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_sta_debugfs_add(struct sta_info *sta);
 void ieee80211_sta_debugfs_remove(struct sta_info *sta);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-02-21 20:33:29.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-02-21 20:34:01.000000000 +0100
@@ -471,10 +471,11 @@ static void rs_tx_status(void *priv_rate
 		return;
 	}
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, hdr->addr1);
 	if (!sta || !sta->rate_ctrl_priv) {
-		if (sta)
-			sta_info_put(sta);
+		rcu_read_unlock();
 		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
 		return;
 	}
@@ -547,7 +548,7 @@ static void rs_tx_status(void *priv_rate
 
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	IWL_DEBUG_RATE("leave\n");
 
@@ -658,6 +659,8 @@ static void rs_get_rate(void *priv_rate,
 
 	IWL_DEBUG_RATE("enter\n");
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, hdr->addr1);
 
 	/* Send management frames and broadcast/multicast data using lowest
@@ -668,8 +671,7 @@ static void rs_get_rate(void *priv_rate,
 	    !sta || !sta->rate_ctrl_priv) {
 		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
 		sel->rate = rate_lowest(local, band, sta);
-		if (sta)
-			sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -811,7 +813,7 @@ static void rs_get_rate(void *priv_rate,
 	else
 		sta->txrate_idx = sta->last_txrate_idx;
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	IWL_DEBUG_RATE("leave: %d\n", index);
 
@@ -843,13 +845,15 @@ int iwl3945_fill_rs_info(struct ieee8021
 	unsigned long now = jiffies;
 	u32 max_time = 0;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, priv->stations[sta_id].sta.sta.addr);
 	if (!sta || !sta->rate_ctrl_priv) {
-		if (sta) {
-			sta_info_put(sta);
+		if (sta)
 			IWL_DEBUG_RATE("leave - no private rate data!\n");
-		} else
+		else
 			IWL_DEBUG_RATE("leave - no station!\n");
+		rcu_read_unlock();
 		return sprintf(buf, "station %d not found\n", sta_id);
 	}
 
@@ -890,7 +894,7 @@ int iwl3945_fill_rs_info(struct ieee8021
 		i = j;
 	}
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	/* Display the average rate of all samples taken.
 	 *
@@ -927,11 +931,12 @@ void iwl3945_rate_scale_init(struct ieee
 		return;
 	}
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, priv->stations[sta_id].sta.sta.addr);
 	if (!sta || !sta->rate_ctrl_priv) {
-		if (sta)
-			sta_info_put(sta);
 		IWL_DEBUG_RATE("leave - no private rate data!\n");
+		rcu_read_unlock();
 		return;
 	}
 
@@ -958,7 +963,7 @@ void iwl3945_rate_scale_init(struct ieee
 		break;
 	}
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 	rssi = priv->last_rx_rssi;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-02-21 20:33:29.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-02-21 20:34:01.000000000 +0100
@@ -847,12 +847,12 @@ static void rs_tx_status(void *priv_rate
 	if (retries > 15)
 		retries = 15;
 
+	rcu_read_lock();
 
 	sta = sta_info_get(local, hdr->addr1);
 
 	if (!sta || !sta->rate_ctrl_priv) {
-		if (sta)
-			sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -891,7 +891,7 @@ static void rs_tx_status(void *priv_rate
 	if ((rs_index < 0) || (rs_index >= IWL_RATE_COUNT)) {
 		IWL_DEBUG_RATE("bad rate index at: %d rate 0x%X\n",
 			     rs_index, tx_mcs.rate_n_flags);
-		sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -909,7 +909,7 @@ static void rs_tx_status(void *priv_rate
 		IWL_DEBUG_RATE("initial rate does not match 0x%x 0x%x\n",
 				tx_mcs.rate_n_flags,
 				le32_to_cpu(table->rs_table[0].rate_n_flags));
-		sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -1025,7 +1025,7 @@ static void rs_tx_status(void *priv_rate
 
 	/* See if there's a better rate or modulation mode to try. */
 	rs_rate_scale_perform(priv, dev, hdr, sta);
-	sta_info_put(sta);
+	rcu_read_unlock();
 	return;
 }
 
@@ -2219,6 +2219,8 @@ static void rs_get_rate(void *priv_rate,
 
 	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, hdr->addr1);
 
 	/* Send management frames and broadcast/multicast data using lowest
@@ -2227,8 +2229,7 @@ static void rs_get_rate(void *priv_rate,
 	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !sta->rate_ctrl_priv) {
 		sel->rate = rate_lowest(local, sband, sta);
-		if (sta)
-			sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -2261,7 +2262,7 @@ static void rs_get_rate(void *priv_rate,
 		sel->rate = rate_lowest(local, sband, sta);
 		return;
 	}
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	sel->rate = &priv->ieee_rates[i];
 }
@@ -2735,13 +2736,15 @@ int iwl4965_fill_rs_info(struct ieee8021
 	u32 max_time = 0;
 	u8 lq_type, antenna;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, priv->stations[sta_id].sta.sta.addr);
 	if (!sta || !sta->rate_ctrl_priv) {
-		if (sta) {
-			sta_info_put(sta);
+		if (sta)
 			IWL_DEBUG_RATE("leave - no private rate data!\n");
-		} else
+		else
 			IWL_DEBUG_RATE("leave - no station!\n");
+		rcu_read_unlock();
 		return sprintf(buf, "station %d not found\n", sta_id);
 	}
 
@@ -2808,7 +2811,7 @@ int iwl4965_fill_rs_info(struct ieee8021
 			 "active_search %d rate index %d\n", lq_type, antenna,
 			 lq_sta->search_better_tbl, sta->last_txrate_idx);
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 	return cnt;
 }
 


