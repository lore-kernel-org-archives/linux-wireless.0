Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbYBYPcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:32:12 -0500
Message-Id: <20080225153007.340533000@sipsolutions.net> (sfid-20080225_153221_663598_BD4CFF6F)
References: <20080225152740.360393000@sipsolutions.net>
Date: Mon, 25 Feb 2008 16:27:46 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 06/10] mac80211: RCU-ify STA info structure access
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes access to the STA hash table/list use RCU to protect
against freeing of items. However, it's not a true RCU, the
copy step is missing: whenever somebody changes a STA item it
is simply updated. This is an existing race condition that is
now somewhat understandable.

This patch also fixes the race key freeing vs. STA destruction
by making sure that sta_info_destroy() is always called under
RTNL and frees the key.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   31 +-
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   27 +-
 net/mac80211/cfg.c                         |  110 ++++----
 net/mac80211/debugfs_sta.c                 |    4 
 net/mac80211/debugfs_sta.h                 |    2 
 net/mac80211/ieee80211.c                   |   78 +++--
 net/mac80211/ieee80211_i.h                 |   13 
 net/mac80211/ieee80211_iface.c             |   11 
 net/mac80211/ieee80211_ioctl.c             |   42 +--
 net/mac80211/ieee80211_rate.c              |    8 
 net/mac80211/ieee80211_rate.h              |    1 
 net/mac80211/ieee80211_sta.c               |  127 ++++++---
 net/mac80211/key.c                         |    8 
 net/mac80211/mesh.c                        |    5 
 net/mac80211/mesh.h                        |   16 -
 net/mac80211/mesh_hwmp.c                   |    6 
 net/mac80211/mesh_pathtbl.c                |   30 +-
 net/mac80211/mesh_plink.c                  |  101 +++----
 net/mac80211/rc80211_pid_algo.c            |   25 +
 net/mac80211/rc80211_simple.c              |   18 -
 net/mac80211/rx.c                          |   24 -
 net/mac80211/sta_info.c                    |  383 +++++++++++++++++------------
 net/mac80211/sta_info.h                    |   61 +++-
 net/mac80211/tx.c                          |   48 +--
 net/mac80211/wme.c                         |    8 
 25 files changed, 699 insertions(+), 488 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-02-25 16:15:22.000000000 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-02-25 16:15:22.000000000 +0100
@@ -574,6 +574,7 @@ struct ieee80211_local {
 	unsigned int filter_flags; /* FIF_* */
 	struct iw_statistics wstats;
 	u8 wstats_flags;
+	bool tim_in_locked_section; /* see ieee80211_beacon_get() */
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	enum {
@@ -591,9 +592,15 @@ struct ieee80211_local {
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
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-02-25 16:14:08.000000000 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-02-25 16:15:22.000000000 +0100
@@ -24,6 +24,7 @@
 #include <linux/wireless.h>
 #include <linux/random.h>
 #include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
 #include <net/iw_handler.h>
 #include <asm/types.h>
 
@@ -845,6 +846,8 @@ static void ieee80211_associated(struct 
 
 	ifsta->state = IEEE80211_ASSOCIATED;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
 		printk(KERN_DEBUG "%s: No STA entry for own AP %s\n",
@@ -860,7 +863,7 @@ static void ieee80211_associated(struct 
 				       "range\n",
 				       dev->name, print_mac(mac, ifsta->bssid));
 				disassoc = 1;
-				sta_info_free(sta);
+				sta_info_unlink(&sta);
 			} else
 				ieee80211_send_probe_req(dev, ifsta->bssid,
 							 local->scan_ssid,
@@ -876,8 +879,17 @@ static void ieee80211_associated(struct 
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
+		rtnl_lock();
+		sta_info_destroy(sta);
+		rtnl_unlock();
+	}
+
 	if (disassoc) {
 		ifsta->state = IEEE80211_DISABLED;
 		ieee80211_set_associated(dev, ifsta, 0);
@@ -1103,9 +1115,13 @@ static void ieee80211_sta_process_addba_
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
@@ -1196,9 +1212,9 @@ end:
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
@@ -1212,9 +1228,13 @@ static void ieee80211_sta_process_addba_
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
@@ -1229,7 +1249,7 @@ static void ieee80211_sta_process_addba_
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -1243,7 +1263,7 @@ static void ieee80211_sta_process_addba_
 			spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
 			printk(KERN_DEBUG "state not HT_ADDBA_REQUESTED_MSK:"
 				"%d\n", *state);
-			sta_info_put(sta);
+			rcu_read_unlock();
 			return;
 		}
 
@@ -1270,7 +1290,7 @@ static void ieee80211_sta_process_addba_
 		ieee80211_stop_tx_ba_session(hw, sta->addr, tid,
 					     WLAN_BACK_INITIATOR);
 	}
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 
 void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
@@ -1325,16 +1345,20 @@ void ieee80211_sta_stop_rx_ba_session(st
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
@@ -1373,7 +1397,7 @@ void ieee80211_sta_stop_rx_ba_session(st
 	kfree(sta->ampdu_mlme.tid_rx[tid].reorder_buf);
 
 	sta->ampdu_mlme.tid_rx[tid].state = HT_AGG_STATE_IDLE;
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 
 
@@ -1386,9 +1410,13 @@ static void ieee80211_sta_process_delba(
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
@@ -1413,7 +1441,7 @@ static void ieee80211_sta_process_delba(
 		ieee80211_stop_tx_ba_session(&local->hw, sta->addr, tid,
 					     WLAN_BACK_RECIPIENT);
 	}
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 
 /*
@@ -1436,9 +1464,13 @@ void sta_addba_resp_timer_expired(unsign
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
@@ -1460,7 +1492,7 @@ void sta_addba_resp_timer_expired(unsign
 				     WLAN_BACK_INITIATOR);
 
 timer_expired_exit:
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 
 /*
@@ -1480,8 +1512,8 @@ void sta_rx_agg_session_timer_expired(un
 					 timer_to_tid[0]);
 
 	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
-	ieee80211_sta_stop_rx_ba_session(sta->dev, sta->addr, (u16)*ptid,
-					 WLAN_BACK_TIMER,
+	ieee80211_sta_stop_rx_ba_session(sta->sdata->dev, sta->addr,
+					 (u16)*ptid, WLAN_BACK_TIMER,
 					 WLAN_REASON_QSTA_TIMEOUT);
 }
 
@@ -1790,14 +1822,18 @@ static void ieee80211_rx_mgmt_assoc_resp
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
@@ -1811,7 +1847,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 		}
 	}
 
-	sta->dev = dev;
 	sta->flags |= WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP |
 		      WLAN_STA_AUTHORIZED;
 
@@ -1882,7 +1917,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	bss_conf->aid = aid;
 	ieee80211_set_associated(dev, ifsta, 1);
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	ieee80211_associated(dev, ifsta);
 }
@@ -2328,6 +2363,8 @@ static void ieee80211_rx_bss_info(struct
 				      mesh_peer_accepts_plinks(&elems, dev));
 	}
 
+	rcu_read_lock();
+
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
 	    (sta = sta_info_get(local, mgmt->sa))) {
@@ -2353,9 +2390,10 @@ static void ieee80211_rx_bss_info(struct
 			       (unsigned long long) supp_rates,
 			       (unsigned long long) sta->supp_rates[rx_status->band]);
 		}
-		sta_info_put(sta);
 	}
 
+	rcu_read_unlock();
+
 	if (elems.ds_params && elems.ds_params_len == 1)
 		freq = ieee80211_channel_to_frequency(elems.ds_params[0]);
 	else
@@ -2549,8 +2587,10 @@ static void ieee80211_rx_bss_info(struct
 				       dev->name, print_mac(mac, mgmt->bssid));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 			ieee80211_sta_join_ibss(dev, &sdata->u.sta, bss);
+			rcu_read_lock();
 			ieee80211_ibss_add_sta(dev, NULL,
 					       mgmt->bssid, mgmt->sa);
+			rcu_read_unlock();
 		}
 	}
 
@@ -2892,17 +2932,20 @@ static int ieee80211_sta_active_ibss(str
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int active = 0;
 	struct sta_info *sta;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	read_lock_bh(&local->sta_lock);
-	list_for_each_entry(sta, &local->sta_list, list) {
-		if (sta->dev == dev &&
+	rcu_read_lock();
+
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
@@ -2914,22 +2957,25 @@ static void ieee80211_sta_expire(struct 
 	struct sta_info *sta, *tmp;
 	LIST_HEAD(tmp_list);
 	DECLARE_MAC_BUF(mac);
+	unsigned long flags;
 
-	write_lock_bh(&local->sta_lock);
+	spin_lock_irqsave(&local->sta_lock, flags);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
 		if (time_after(jiffies, sta->last_rx + exp_time)) {
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
+	rtnl_lock();
+	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
+		sta_info_destroy(sta);
+	rtnl_unlock();
 }
 
 
@@ -3976,6 +4022,7 @@ int ieee80211_sta_set_extra_ie(struct ne
 }
 
 
+/* must be called under RCU read lock */
 struct sta_info * ieee80211_ibss_add_sta(struct net_device *dev,
 					 struct sk_buff *skb, u8 *bssid,
 					 u8 *addr)
@@ -3998,7 +4045,7 @@ struct sta_info * ieee80211_ibss_add_sta
 	printk(KERN_DEBUG "%s: Adding new IBSS station %s (dev=%s)\n",
 	       wiphy_name(local->hw.wiphy), print_mac(mac, addr), dev->name);
 
-	sta = sta_info_add(local, dev, addr, GFP_ATOMIC);
+	sta = sta_info_add(sdata, addr);
 	if (IS_ERR(sta))
 		return NULL;
 
@@ -4009,7 +4056,7 @@ struct sta_info * ieee80211_ibss_add_sta
 
 	rate_control_rate_init(sta, local);
 
-	return sta; /* caller will call sta_info_put() */
+	return sta;
 }
 
 
--- everything.orig/net/mac80211/sta_info.c	2008-02-25 16:15:22.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-25 16:15:22.000000000 +0100
@@ -15,6 +15,7 @@
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
 #include <linux/timer.h>
+#include <linux/rtnetlink.h>
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
@@ -23,14 +24,43 @@
 #include "debugfs_sta.h"
 #include "mesh.h"
 
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
+ * course. Note that sta_info_destroy() must be protected by the RTNL.
+ *
+ * In all other cases, there is no concept of ownership on a STA entry,
+ * each structure is owned by the global hash table/list until it is
+ * removed. All users of the structure need to be RCU protected so that
+ * the structure won't be freed before they are done using it.
+ */
 
 /* Caller must hold local->sta_lock */
 static int sta_info_hash_del(struct ieee80211_local *local,
@@ -42,46 +72,39 @@ static int sta_info_hash_del(struct ieee
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
 
@@ -91,81 +114,97 @@ struct sta_info *sta_info_get_by_idx(str
 	struct sta_info *sta;
 	int i = 0;
 
-	read_lock_bh(&local->sta_lock);
-	list_for_each_entry(sta, &local->sta_list, list) {
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		if (i < idx) {
 			++i;
 			continue;
-		} else if (!dev || dev == sta->dev) {
-			__sta_info_get(sta);
-			read_unlock_bh(&local->sta_lock);
+		} else if (!dev || dev == sta->sdata->dev) {
 			return sta;
 		}
 	}
-	read_unlock_bh(&local->sta_lock);
 
 	return NULL;
 }
 
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
+	ASSERT_RTNL();
+	might_sleep();
+
+	rate_control_remove_sta_debugfs(sta);
+	ieee80211_sta_debugfs_remove(sta);
+
+	if (ieee80211_vif_is_mesh(&sta->sdata->vif))
+		mesh_plink_deactivate(sta);
+
+	/*
+	 * NOTE: This will call synchronize_rcu() internally to
+	 * make sure no key references can be in use. We rely on
+	 * that here for the mesh code!
+	 */
+	ieee80211_key_free(sta->key);
+	WARN_ON(sta->key);
+
+	if (ieee80211_vif_is_mesh(&sta->sdata->vif))
+		del_timer_sync(&sta->plink_timer);
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
+	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->addr)], sta);
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
@@ -190,29 +229,26 @@ struct sta_info *sta_info_add(struct iee
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
@@ -252,19 +288,20 @@ static void __sta_info_set_tim_bit(struc
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
@@ -272,93 +309,135 @@ static void __sta_info_clear_tim_bit(str
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
-
-	if (ieee80211_vif_is_mesh(&sdata->vif))
-		mesh_accept_plinks_update(sdata->dev);
+	return ret;
 }
 
-void sta_info_free(struct sta_info *sta)
+static void __sta_info_unlink(struct sta_info **sta)
 {
-	struct sk_buff *skb;
-	struct ieee80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
-
-	DECLARE_MAC_BUF(mac);
-
-	might_sleep();
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
 
-	write_lock_bh(&local->sta_lock);
-	sta_info_remove(sta);
-	write_unlock_bh(&local->sta_lock);
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
 
-	if (ieee80211_vif_is_mesh(&sdata->vif))
-		mesh_plink_deactivate(sta);
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
-	WARN_ON(sta->key);
+	local->num_sta--;
 
 	if (local->ops->sta_notify) {
-
 		if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
 			sdata = sdata->u.vlan.ap;
 
 		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
-				       STA_NOTIFY_REMOVE, sta->addr);
+				       STA_NOTIFY_REMOVE, (*sta)->addr);
 	}
 
-	rate_control_remove_sta_debugfs(sta);
-	ieee80211_sta_debugfs_remove(sta);
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		mesh_accept_plinks_update(sdata);
+#ifdef CONFIG_MAC80211_MESH
+		del_timer(&(*sta)->plink_timer);
+#endif
+	}
 
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
@@ -404,7 +483,7 @@ static void sta_info_cleanup_expire_buff
 		if (!skb)
 			break;
 
-		sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+		sdata = sta->sdata;
 		local->total_ps_buffered--;
 		printk(KERN_DEBUG "Buffered frame expired (STA "
 		       "%s)\n", print_mac(mac, sta->addr));
@@ -421,13 +500,10 @@ static void sta_info_cleanup(unsigned lo
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
@@ -435,37 +511,45 @@ static void sta_info_cleanup(unsigned lo
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
@@ -474,7 +558,7 @@ void sta_info_init(struct ieee80211_loca
 		round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-	INIT_WORK(&local->sta_debugfs_add, sta_info_debugfs_add_task);
+	INIT_WORK(&local->sta_debugfs_add, sta_info_debugfs_add_work);
 #endif
 }
 
@@ -493,24 +577,29 @@ void sta_info_stop(struct ieee80211_loca
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
--- everything.orig/net/mac80211/sta_info.h	2008-02-25 16:15:22.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-25 16:19:33.000000000 +0100
@@ -12,7 +12,6 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
-#include <linux/kref.h>
 #include "ieee80211_key.h"
 
 /**
@@ -134,8 +133,14 @@ struct sta_ampdu_mlme {
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
 
@@ -166,8 +171,8 @@ struct sta_info {
 	/* last rates used to send a frame to this STA */
 	int last_txrate_idx, last_nonerp_txrate_idx;
 
-	struct net_device *dev; /* which net device is this station associated
-				 * to */
+	/* sub_if_data this sta belongs to */
+	struct ieee80211_sub_if_data *sdata;
 
 	struct ieee80211_key *key;
 
@@ -199,6 +204,12 @@ struct sta_info {
 
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
@@ -262,25 +273,37 @@ static inline enum plink_state sta_plink
  */
 #define STA_INFO_CLEANUP_INTERVAL (10 * HZ)
 
-static inline void __sta_info_get(struct sta_info *sta)
-{
-	kref_get(&sta->kref);
-}
-
-struct sta_info * sta_info_get(struct ieee80211_local *local, u8 *addr);
+/*
+ * Get a STA info, must have be under RCU read lock.
+ */
+struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr);
+/*
+ * Get STA info by index, BROKEN!
+ */
 struct sta_info *sta_info_get_by_idx(struct ieee80211_local *local, int idx,
 				      struct net_device *dev);
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
--- everything.orig/net/mac80211/tx.c	2008-02-25 16:15:22.000000000 +0100
+++ everything/net/mac80211/tx.c	2008-02-25 16:15:22.000000000 +0100
@@ -327,10 +327,8 @@ static void purge_old_ps_buffers(struct 
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
@@ -338,7 +336,8 @@ static void purge_old_ps_buffers(struct 
 		}
 		total += skb_queue_len(&sta->ps_tx_buf);
 	}
-	read_unlock_bh(&local->sta_lock);
+
+	rcu_read_unlock();
 
 	local->total_ps_buffered = total;
 	printk(KERN_DEBUG "%s: PS buffers full - purged %d frames\n",
@@ -1141,20 +1140,17 @@ static int ieee80211_tx(struct net_devic
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
 	tx.channel = local->hw.conf.channel;
 
@@ -1167,9 +1163,6 @@ static int ieee80211_tx(struct net_devic
 
 	skb = tx.skb; /* handlers are allowed to change skb */
 
-	if (sta)
-		sta_info_put(sta);
-
 	if (unlikely(res == TX_DROP)) {
 		I802_DEBUG_INC(local->tx_handlers_drop);
 		goto drop;
@@ -1489,11 +1482,11 @@ int ieee80211_subif_start_xmit(struct sk
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
@@ -1722,7 +1715,6 @@ static void ieee80211_beacon_add_tim(str
 
 	/* Generate bitmap for TIM only if there are any STAs in power save
 	 * mode. */
-	read_lock_bh(&local->sta_lock);
 	if (atomic_read(&bss->num_sta_ps) > 0)
 		/* in the hope that this is faster than
 		 * checking byte-for-byte */
@@ -1773,7 +1765,6 @@ static void ieee80211_beacon_add_tim(str
 		*pos++ = aid0; /* Bitmap control */
 		*pos++ = 0; /* Part Virt Bitmap */
 	}
-	read_unlock_bh(&local->sta_lock);
 }
 
 struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
@@ -1821,7 +1812,22 @@ struct sk_buff *ieee80211_beacon_get(str
 			ieee80211_include_sequence(sdata,
 					(struct ieee80211_hdr *)skb->data);
 
-			ieee80211_beacon_add_tim(local, ap, skb, beacon);
+			/*
+			 * Not very nice, but we want to allow the driver to call
+			 * ieee80211_beacon_get() as a response to the set_tim()
+			 * callback. That, however, is already invoked under the
+			 * sta_lock to guarantee consistent and race-free update
+			 * of the tim bitmap in mac80211 and the driver.
+			 */
+			if (local->tim_in_locked_section) {
+				ieee80211_beacon_add_tim(local, ap, skb, beacon);
+			} else {
+				unsigned long flags;
+
+				spin_lock_irqsave(&local->sta_lock, flags);
+				ieee80211_beacon_add_tim(local, ap, skb, beacon);
+				spin_unlock_irqrestore(&local->sta_lock, flags);
+			}
 
 			if (beacon->tail)
 				memcpy(skb_put(skb, beacon->tail_len),
@@ -1965,7 +1971,6 @@ ieee80211_get_buffered_bc(struct ieee802
 		rcu_read_unlock();
 		return NULL;
 	}
-	rcu_read_unlock();
 
 	if (bss->dtim_count != 0)
 		return NULL; /* send buffered bc/mc only after DTIM beacon */
@@ -2010,8 +2015,7 @@ ieee80211_get_buffered_bc(struct ieee802
 		skb = NULL;
 	}
 
-	if (sta)
-		sta_info_put(sta);
+	rcu_read_unlock();
 
 	return skb;
 }
--- everything.orig/net/mac80211/cfg.c	2008-02-25 16:15:22.000000000 +0100
+++ everything/net/mac80211/cfg.c	2008-02-25 16:15:22.000000000 +0100
@@ -142,7 +142,6 @@ static int ieee80211_add_key(struct wiph
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta = NULL;
 	enum ieee80211_key_alg alg;
-	int ret;
 	struct ieee80211_key *key;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -176,12 +175,7 @@ static int ieee80211_add_key(struct wiph
 
 	ieee80211_key_link(key, sdata, sta);
 
-	ret = 0;
-
-	if (sta)
-		sta_info_put(sta);
-
-	return ret;
+	return 0;
 }
 
 static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
@@ -190,7 +184,6 @@ static int ieee80211_del_key(struct wiph
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	int ret;
-	struct ieee80211_key *key;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -201,21 +194,18 @@ static int ieee80211_del_key(struct wiph
 
 		ret = 0;
 		if (sta->key) {
-			key = sta->key;
-			ieee80211_key_free(key);
+			ieee80211_key_free(sta->key);
 			WARN_ON(sta->key);
 		} else
 			ret = -ENOENT;
 
-		sta_info_put(sta);
 		return ret;
 	}
 
 	if (!sdata->keys[key_idx])
 		return -ENOENT;
 
-	key = sdata->keys[key_idx];
-	ieee80211_key_free(key);
+	ieee80211_key_free(sdata->keys[key_idx]);
 	WARN_ON(sdata->keys[key_idx]);
 
 	return 0;
@@ -298,8 +288,6 @@ static int ieee80211_get_key(struct wiph
 	err = 0;
 
  out:
-	if (sta)
-		sta_info_put(sta);
 	return err;
 }
 
@@ -317,7 +305,7 @@ static int ieee80211_config_default_key(
 
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
 	sinfo->filled = STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
@@ -346,16 +334,20 @@ static int ieee80211_dump_station(struct
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
+	int ret = -ENOENT;
+
+	rcu_read_lock();
 
 	sta = sta_info_get_by_idx(local, idx, dev);
-	if (!sta)
-		return -ENOENT;
+	if (sta) {
+		ret = 0;
+		memcpy(mac, sta->addr, ETH_ALEN);
+		sta_set_sinfo(sta, sinfo);
+	}
 
-	memcpy(mac, sta->addr, ETH_ALEN);
-	sta_set_sinfo(sta, sinfo);
-	sta_info_put(sta);
+	rcu_read_unlock();
 
-	return 0;
+	return ret;
 }
 
 static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
@@ -363,16 +355,21 @@ static int ieee80211_get_station(struct 
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
+	int ret = -ENOENT;
 
-	sta = sta_info_get(local, mac);
-	if (!sta)
-		return -ENOENT;
+	rcu_read_lock();
 
 	/* XXX: verify sta->dev == dev */
-	sta_set_sinfo(sta, sinfo);
-	sta_info_put(sta);
 
-	return 0;
+	sta = sta_info_get(local, mac);
+	if (sta) {
+		ret = 0;
+		sta_set_sinfo(sta, sinfo);
+	}
+
+	rcu_read_unlock();
+
+	return ret;
 }
 
 /*
@@ -565,8 +562,8 @@ static void ieee80211_send_layer2_update
 	msg->xid_info[1] = 1;	/* LLC types/classes: Type 1 LLC */
 	msg->xid_info[2] = 0;	/* XID sender's receive window size (RW) */
 
-	skb->dev = sta->dev;
-	skb->protocol = eth_type_trans(skb, sta->dev);
+	skb->dev = sta->sdata->dev;
+	skb->protocol = eth_type_trans(skb, sta->sdata->dev);
 	memset(skb->cb, 0, sizeof(skb->cb));
 	netif_rx(skb);
 }
@@ -578,7 +575,7 @@ static void sta_apply_parameters(struct 
 	u32 rates;
 	int i, j;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
 	if (params->station_flags & STATION_FLAG_CHANGED) {
 		sta->flags &= ~WLAN_STA_AUTHORIZED;
@@ -650,14 +647,13 @@ static int ieee80211_add_station(struct 
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
-		sta = mesh_plink_add(mac, DEFAULT_RATES, dev);
+		sta = mesh_plink_add(mac, DEFAULT_RATES, sdata);
 	else
-		sta = sta_info_add(local, dev, mac, GFP_KERNEL);
+		sta = sta_info_add(sdata, mac);
 
 	if (IS_ERR(sta))
 		return PTR_ERR(sta);
 
-	sta->dev = sdata->dev;
 	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN ||
 	    sdata->vif.type == IEEE80211_IF_TYPE_AP)
 		ieee80211_send_layer2_update(sta);
@@ -668,15 +664,14 @@ static int ieee80211_add_station(struct 
 
 	rate_control_rate_init(sta, local);
 
-	sta_info_put(sta);
-
 	return 0;
 }
 
 static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
 	if (mac) {
@@ -685,10 +680,14 @@ static int ieee80211_del_station(struct 
 		if (!sta)
 			return -ENOENT;
 
-		sta_info_free(sta);
-		sta_info_put(sta);
+		sta_info_unlink(&sta);
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
@@ -707,21 +706,19 @@ static int ieee80211_change_station(stru
 	if (!sta)
 		return -ENOENT;
 
-	if (params->vlan && params->vlan != sta->dev) {
+	if (params->vlan && params->vlan != sta->sdata->dev) {
 		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 
 		if (vlansdata->vif.type != IEEE80211_IF_TYPE_VLAN ||
 		    vlansdata->vif.type != IEEE80211_IF_TYPE_AP)
 			return -EINVAL;
 
-		sta->dev = params->vlan;
+		sta->sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
 		ieee80211_send_layer2_update(sta);
 	}
 
 	sta_apply_parameters(local, sta, params);
 
-	sta_info_put(sta);
-
 	return 0;
 }
 
@@ -741,23 +738,26 @@ static int ieee80211_add_mpath(struct wi
 	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
 		return -ENOTSUPP;
 
+	rcu_read_lock();
 	sta = sta_info_get(local, next_hop);
-	if (!sta)
+	if (!sta) {
+		rcu_read_unlock();
 		return -ENOENT;
+	}
 
 	err = mesh_path_add(dst, dev);
-	if (err)
+	if (err) {
+		rcu_read_unlock();
 		return err;
+	}
 
-	rcu_read_lock();
 	mpath = mesh_path_lookup(dst, dev);
 	if (!mpath) {
 		rcu_read_unlock();
-		sta_info_put(sta);
 		return -ENXIO;
 	}
 	mesh_path_fix_nexthop(mpath, sta);
-	sta_info_put(sta);
+
 	rcu_read_unlock();
 	return 0;
 }
@@ -766,7 +766,7 @@ static int ieee80211_del_mpath(struct wi
 				 u8 *dst)
 {
 	if (dst)
-		return mesh_path_del(dst, dev);
+		return mesh_path_del(dst, dev, false);
 
 	mesh_path_flush(dev);
 	return 0;
@@ -787,20 +787,22 @@ static int ieee80211_change_mpath(struct
 	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
 		return -ENOTSUPP;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, next_hop);
-	if (!sta)
+	if (!sta) {
+		rcu_read_unlock();
 		return -ENOENT;
+	}
 
-	rcu_read_lock();
 	mpath = mesh_path_lookup(dst, dev);
 	if (!mpath) {
 		rcu_read_unlock();
-		sta_info_put(sta);
 		return -ENOENT;
 	}
 
 	mesh_path_fix_nexthop(mpath, sta);
-	sta_info_put(sta);
+
 	rcu_read_unlock();
 	return 0;
 }
--- everything.orig/net/mac80211/ieee80211.c	2008-02-25 16:14:09.000000000 +0100
+++ everything/net/mac80211/ieee80211.c	2008-02-25 16:15:22.000000000 +0100
@@ -375,15 +375,19 @@ static int ieee80211_stop(struct net_dev
 
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
@@ -449,7 +453,7 @@ static int ieee80211_stop(struct net_dev
 		netif_tx_unlock_bh(local->mdev);
 		break;
 	case IEEE80211_IF_TYPE_MESH_POINT:
-		sta_info_flush(local, dev);
+		sta_info_flush(local, sdata);
 		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
@@ -522,9 +526,12 @@ int ieee80211_start_tx_ba_session(struct
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
 
@@ -564,7 +571,7 @@ int ieee80211_start_tx_ba_session(struct
 		spin_unlock_bh(&local->mdev->queue_lock);
 		goto start_ba_exit;
 	}
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = sta->sdata;
 
 	/* Ok, the Addba frame hasn't been sent yet, but if the driver calls the
 	 * call back right away, it must see that the flow has begun */
@@ -601,7 +608,7 @@ int ieee80211_start_tx_ba_session(struct
 			sta->ampdu_mlme.dialog_token_allocator;
 	sta->ampdu_mlme.tid_tx[tid].ssn = start_seq_num;
 
-	ieee80211_send_addba_request(sta->dev, ra, tid,
+	ieee80211_send_addba_request(sta->sdata->dev, ra, tid,
 			 sta->ampdu_mlme.tid_tx[tid].dialog_token,
 			 sta->ampdu_mlme.tid_tx[tid].ssn,
 			 0x40, 5000);
@@ -614,7 +621,7 @@ int ieee80211_start_tx_ba_session(struct
 
 start_ba_exit:
 	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
-	sta_info_put(sta);
+	rcu_read_unlock();
 	return ret;
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
@@ -637,9 +644,12 @@ int ieee80211_stop_tx_ba_session(struct 
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
@@ -673,7 +683,7 @@ int ieee80211_stop_tx_ba_session(struct 
 
 stop_BA_exit:
 	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
-	sta_info_put(sta);
+	rcu_read_unlock();
 	return ret;
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
@@ -691,8 +701,10 @@ void ieee80211_start_tx_ba_cb(struct iee
 		return;
 	}
 
+	rcu_read_lock();
 	sta = sta_info_get(local, ra);
 	if (!sta) {
+		rcu_read_unlock();
 		printk(KERN_DEBUG "Could not find station: %s\n",
 				print_mac(mac, ra));
 		return;
@@ -705,7 +717,7 @@ void ieee80211_start_tx_ba_cb(struct iee
 		printk(KERN_DEBUG "addBA was not requested yet, state is %d\n",
 				*state);
 		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
-		sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -718,7 +730,7 @@ void ieee80211_start_tx_ba_cb(struct iee
 		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
 	}
 	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb);
 
@@ -739,10 +751,12 @@ void ieee80211_stop_tx_ba_cb(struct ieee
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
@@ -750,13 +764,13 @@ void ieee80211_stop_tx_ba_cb(struct ieee
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
@@ -777,7 +791,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	sta->ampdu_mlme.tid_tx[tid].addba_req_num = 0;
 	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb);
 
@@ -887,32 +901,41 @@ int ieee80211_if_update_wds(struct net_d
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
 
@@ -1330,6 +1353,8 @@ void ieee80211_tx_status(struct ieee8021
 		return;
 	}
 
+	rcu_read_lock();
+
 	if (status->excessive_retries) {
 		struct sta_info *sta;
 		sta = sta_info_get(local, hdr->addr1);
@@ -1343,10 +1368,9 @@ void ieee80211_tx_status(struct ieee8021
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
 
@@ -1356,12 +1380,14 @@ void ieee80211_tx_status(struct ieee8021
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
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-02-25 16:15:22.000000000 +0100
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-02-25 16:15:22.000000000 +0100
@@ -77,7 +77,7 @@ static void rate_control_pid_adjust_rate
 	int cur_sorted, new_sorted, probe, tmp, n_bitrates, band;
 	int cur = sta->txrate_idx;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = sta->sdata;
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	band = sband->band;
 	n_bitrates = sband->n_bitrates;
@@ -149,7 +149,7 @@ static void rate_control_pid_sample(stru
 				    struct sta_info *sta)
 {
 #ifdef CONFIG_MAC80211_MESH
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 #endif
 	struct rc_pid_sta_info *spinfo = sta->rate_ctrl_priv;
 	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
@@ -249,23 +249,25 @@ static void rate_control_pid_tx_status(v
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
@@ -303,8 +305,8 @@ static void rate_control_pid_tx_status(v
 	if (time_after(jiffies, spinfo->last_sample + period))
 		rate_control_pid_sample(pinfo, local, sta);
 
-ignore:
-	sta_info_put(sta);
+ unlock:
+	rcu_read_unlock();
 }
 
 static void rate_control_pid_get_rate(void *priv, struct net_device *dev,
@@ -319,6 +321,8 @@ static void rate_control_pid_get_rate(vo
 	int rateidx;
 	u16 fc;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, hdr->addr1);
 
 	/* Send management frames and broadcast/multicast data using lowest
@@ -327,8 +331,7 @@ static void rate_control_pid_get_rate(vo
 	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
 	    is_multicast_ether_addr(hdr->addr1) || !sta) {
 		sel->rate = rate_lowest(local, sband, sta);
-		if (sta)
-			sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -344,7 +347,7 @@ static void rate_control_pid_get_rate(vo
 
 	sta->last_txrate_idx = rateidx;
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	sel->rate = &sband->bitrates[rateidx];
 
--- everything.orig/net/mac80211/rc80211_simple.c	2008-02-25 16:15:22.000000000 +0100
+++ everything/net/mac80211/rc80211_simple.c	2008-02-25 16:15:22.000000000 +0100
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
@@ -191,7 +193,8 @@ static void rate_control_simple_tx_statu
 		}
 	}
 
-	sta_info_put(sta);
+ unlock:
+	rcu_read_unlock();
 }
 
 
@@ -208,6 +211,8 @@ rate_control_simple_get_rate(void *priv,
 	int rateidx;
 	u16 fc;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, hdr->addr1);
 
 	/* Send management frames and broadcast/multicast data using lowest
@@ -216,8 +221,7 @@ rate_control_simple_get_rate(void *priv,
 	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
 	    is_multicast_ether_addr(hdr->addr1) || !sta) {
 		sel->rate = rate_lowest(local, sband, sta);
-		if (sta)
-			sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -233,7 +237,7 @@ rate_control_simple_get_rate(void *priv,
 
 	sta->last_txrate_idx = rateidx;
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 
 	sel->rate = &sband->bitrates[rateidx];
 }
--- everything.orig/net/mac80211/rx.c	2008-02-25 16:15:22.000000000 +0100
+++ everything/net/mac80211/rx.c	2008-02-25 16:15:22.000000000 +0100
@@ -631,7 +631,7 @@ static void ap_sta_ps_start(struct net_d
 	struct ieee80211_sub_if_data *sdata;
 	DECLARE_MAC_BUF(mac);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = sta->sdata;
 
 	if (sdata->bss)
 		atomic_inc(&sdata->bss->num_sta_ps);
@@ -652,7 +652,7 @@ static int ap_sta_ps_end(struct net_devi
 	struct ieee80211_tx_packet_data *pkt_data;
 	DECLARE_MAC_BUF(mac);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = sta->sdata;
 
 	if (sdata->bss)
 		atomic_dec(&sdata->bss->num_sta_ps);
@@ -1287,7 +1287,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 				       "multicast frame\n", dev->name);
 		} else {
 			dsta = sta_info_get(local, skb->data);
-			if (dsta && dsta->dev == dev) {
+			if (dsta && dsta->sdata->dev == dev) {
 				/*
 				 * The destination station is associated to
 				 * this AP (in this VLAN), so send the frame
@@ -1297,8 +1297,6 @@ ieee80211_deliver_skb(struct ieee80211_r
 				xmit_skb = skb;
 				skb = NULL;
 			}
-			if (dsta)
-				sta_info_put(dsta);
 		}
 	}
 
@@ -1905,13 +1903,13 @@ static void __ieee80211_rx_handle_packet
 
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
@@ -1970,10 +1968,6 @@ static void __ieee80211_rx_handle_packet
 		ieee80211_invoke_rx_handlers(prev, &rx, skb);
 	} else
 		dev_kfree_skb(skb);
-
- end:
-	if (rx.sta)
-		sta_info_put(rx.sta);
 }
 
 #define SEQ_MODULO 0x1000
@@ -2150,7 +2144,7 @@ static u8 ieee80211_rx_reorder_ampdu(str
 	/* if this mpdu is fragmented - terminate rx aggregation session */
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	if (sc & IEEE80211_SCTL_FRAG) {
-		ieee80211_sta_stop_rx_ba_session(sta->dev, sta->addr,
+		ieee80211_sta_stop_rx_ba_session(sta->sdata->dev, sta->addr,
 			tid, 0, WLAN_REASON_QSTA_REQUIRE_SETUP);
 		ret = 1;
 		goto end_reorder;
@@ -2160,9 +2154,7 @@ static u8 ieee80211_rx_reorder_ampdu(str
 	mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
 	ret = ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb,
 						mpdu_seq_num, 0);
-end_reorder:
-	if (sta)
-		sta_info_put(sta);
+ end_reorder:
 	return ret;
 }
 
--- everything.orig/net/mac80211/ieee80211_ioctl.c	2008-02-25 16:15:22.000000000 +0100
+++ everything/net/mac80211/ieee80211_ioctl.c	2008-02-25 16:15:22.000000000 +0100
@@ -33,8 +33,7 @@ static int ieee80211_set_encryption(stru
 				    size_t key_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	int ret;
-	struct sta_info *sta = NULL;
+	struct sta_info *sta;
 	struct ieee80211_key *key;
 	struct ieee80211_sub_if_data *sdata;
 
@@ -51,24 +50,23 @@ static int ieee80211_set_encryption(stru
 			key = sdata->keys[idx];
 		} else {
 			sta = sta_info_get(local, sta_addr);
-			if (!sta) {
-				ret = -ENOENT;
-				key = NULL;
-				goto err_out;
-			}
-
+			if (!sta)
+				return -ENOENT;
 			key = sta->key;
 		}
 
 		if (!key)
-			ret = -ENOENT;
-		else
-			ret = 0;
+			return -ENOENT;
+
+		ieee80211_key_free(key);
+		return 0;
 	} else {
 		key = ieee80211_key_alloc(alg, idx, key_len, _key);
 		if (!key)
 			return -ENOMEM;
 
+		sta = NULL;
+
 		if (!is_broadcast_ether_addr(sta_addr)) {
 			set_tx_key = 0;
 			/*
@@ -78,14 +76,14 @@ static int ieee80211_set_encryption(stru
 			 * work around this.
 			 */
 			if (idx != 0 && alg != ALG_WEP) {
-				ret = -EINVAL;
-				goto err_out;
+				ieee80211_key_free(key);
+				return -EINVAL;
 			}
 
 			sta = sta_info_get(local, sta_addr);
 			if (!sta) {
-				ret = -ENOENT;
-				goto err_out;
+				ieee80211_key_free(key);
+				return -ENOENT;
 			}
 		}
 
@@ -93,18 +91,9 @@ static int ieee80211_set_encryption(stru
 
 		if (set_tx_key || (!sta && !sdata->default_key && key))
 			ieee80211_set_default_key(sdata, idx);
-
-		/* don't free key later */
-		key = NULL;
-
-		ret = 0;
 	}
 
- err_out:
-	if (sta)
-		sta_info_put(sta);
-	ieee80211_key_free(key);
-	return ret;
+	return 0;
 }
 
 static int ieee80211_ioctl_siwgenie(struct net_device *dev,
@@ -628,7 +617,7 @@ static int ieee80211_ioctl_giwrate(struc
 	else
 		rate->value = 0;
 	rate->value *= 100000;
-	sta_info_put(sta);
+
 	return 0;
 }
 
@@ -1003,7 +992,6 @@ static struct iw_statistics *ieee80211_g
 		wstats->qual.qual = sta->last_signal;
 		wstats->qual.noise = sta->last_noise;
 		wstats->qual.updated = local->wstats_flags;
-		sta_info_put(sta);
 	}
 	return wstats;
 }
--- everything.orig/net/mac80211/ieee80211_iface.c	2008-02-25 16:15:22.000000000 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2008-02-25 16:15:22.000000000 +0100
@@ -240,16 +240,21 @@ void ieee80211_if_reinit(struct net_devi
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
 	case IEEE80211_IF_TYPE_MESH_POINT:
 	case IEEE80211_IF_TYPE_STA:
@@ -275,7 +280,7 @@ void ieee80211_if_reinit(struct net_devi
 	}
 
 	/* remove all STAs that are bound to this virtual interface */
-	sta_info_flush(local, dev);
+	sta_info_flush(local, sdata);
 
 	memset(&sdata->u, 0, sizeof(sdata->u));
 	ieee80211_if_sdata_init(sdata);
--- everything.orig/net/mac80211/ieee80211_rate.c	2008-02-25 16:14:08.000000000 +0100
+++ everything/net/mac80211/ieee80211_rate.c	2008-02-25 16:15:22.000000000 +0100
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
--- everything.orig/net/mac80211/ieee80211_rate.h	2008-02-25 16:14:08.000000000 +0100
+++ everything/net/mac80211/ieee80211_rate.h	2008-02-25 16:15:22.000000000 +0100
@@ -14,6 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
+#include <linux/kref.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "sta_info.h"
--- everything.orig/net/mac80211/key.c	2008-02-25 16:15:22.000000000 +0100
+++ everything/net/mac80211/key.c	2008-02-25 16:15:22.000000000 +0100
@@ -233,14 +233,17 @@ void ieee80211_key_link(struct ieee80211
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
 
@@ -277,6 +280,9 @@ void ieee80211_key_free(struct ieee80211
 		 */
 		__ieee80211_key_replace(key->sdata, key->sta, key, NULL);
 
+		/*
+		 * Do NOT remove this without looking at sta_info_destroy()
+		 */
 		synchronize_rcu();
 
 		/*
--- everything.orig/net/mac80211/debugfs_sta.c	2008-02-25 16:15:22.000000000 +0100
+++ everything/net/mac80211/debugfs_sta.c	2008-02-25 16:15:22.000000000 +0100
@@ -51,7 +51,7 @@ static const struct file_operations sta_
 		STA_OPS(name)
 
 STA_FILE(aid, aid, D);
-STA_FILE(dev, dev->name, S);
+STA_FILE(dev, sdata->dev->name, S);
 STA_FILE(rx_packets, rx_packets, LU);
 STA_FILE(tx_packets, tx_packets, LU);
 STA_FILE(rx_bytes, rx_bytes, LU);
@@ -200,7 +200,7 @@ static ssize_t sta_agg_status_write(stru
 		const char __user *user_buf, size_t count, loff_t *ppos)
 {
 	struct sta_info *sta = file->private_data;
-	struct net_device *dev = sta->dev;
+	struct net_device *dev = sta->sdata->dev;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 	u8 *da = sta->addr;
--- everything.orig/net/mac80211/wme.c	2008-02-25 16:14:08.000000000 +0100
+++ everything/net/mac80211/wme.c	2008-02-25 16:15:22.000000000 +0100
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
--- everything.orig/net/mac80211/debugfs_sta.h	2008-02-25 16:14:08.000000000 +0100
+++ everything/net/mac80211/debugfs_sta.h	2008-02-25 16:15:22.000000000 +0100
@@ -1,6 +1,8 @@
 #ifndef __MAC80211_DEBUGFS_STA_H
 #define __MAC80211_DEBUGFS_STA_H
 
+#include "sta_info.h"
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_sta_debugfs_add(struct sta_info *sta);
 void ieee80211_sta_debugfs_remove(struct sta_info *sta);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-02-25 16:14:09.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-02-25 16:15:22.000000000 +0100
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
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-02-25 16:14:09.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-02-25 16:15:22.000000000 +0100
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
 
--- everything.orig/net/mac80211/mesh.h	2008-02-25 16:14:08.000000000 +0100
+++ everything/net/mac80211/mesh.h	2008-02-25 16:15:22.000000000 +0100
@@ -65,9 +65,10 @@ enum mesh_path_flags {
  * @state_lock: mesh pat state lock
  *
  *
- * The combination of dst and dev is unique in the mesh path table. A reference
- * to the next_hop sta will be kept and in case this sta is removed, the
- * mesh_path structure must be also removed or substitued in a rcu safe way
+ * The combination of dst and dev is unique in the mesh path table. Since the
+ * next_hop STA is only protected by RCU as well, deleting the STA must also
+ * remove/substitute the mesh_path structure and wait until that is no longer
+ * reachable before destroying the STA completely.
  */
 struct mesh_path {
 	u8 dst[ETH_ALEN];
@@ -230,8 +231,9 @@ void mesh_neighbour_update(u8 *hw_addr, 
 		bool add);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie,
 			      struct net_device *dev);
-void mesh_accept_plinks_update(struct net_device *dev);
-struct sta_info *mesh_plink_add(u8 *hw_addr, u64 rates, struct net_device *dev);
+void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
+struct sta_info *mesh_plink_add(u8 *hw_addr, u64 rates,
+				struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
 void mesh_plink_deactivate(struct sta_info *sta);
 int mesh_plink_open(struct sta_info *sta);
@@ -254,7 +256,7 @@ void mesh_path_flush_pending(struct mesh
 void mesh_path_tx_pending(struct mesh_path *mpath);
 int mesh_pathtbl_init(void);
 void mesh_pathtbl_unregister(void);
-int mesh_path_del(u8 *addr, struct net_device *dev);
+int mesh_path_del(u8 *addr, struct net_device *dev, bool force);
 void mesh_path_timer(unsigned long data);
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
 void mesh_path_discard_frame(struct sk_buff *skb, struct net_device *dev);
@@ -270,7 +272,7 @@ static inline int mesh_plink_free_count(
 
 static inline bool mesh_plink_availables(struct ieee80211_sub_if_data *sdata)
 {
-	return (min(mesh_plink_free_count(sdata),
+	return (min_t(long, mesh_plink_free_count(sdata),
 		   MESH_MAX_PLINKS - sdata->local->num_sta)) > 0;
 }
 
--- everything.orig/net/mac80211/mesh.c	2008-02-25 16:14:08.000000000 +0100
+++ everything/net/mac80211/mesh.c	2008-02-25 16:15:22.000000000 +0100
@@ -83,11 +83,10 @@ bool mesh_peer_accepts_plinks(struct iee
 /**
  * mesh_accept_plinks_update: update accepting_plink in local mesh beacons
  *
- * @dev: mesh interface in which mesh beacons are going to be updated
+ * @sdata: mesh interface in which mesh beacons are going to be updated
  */
-void mesh_accept_plinks_update(struct net_device *dev)
+void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	bool free_plinks;
 
 	/* In case mesh_plink_free_count > 0 and mesh_plinktbl_capacity == 0,
--- everything.orig/net/mac80211/mesh_pathtbl.c	2008-02-25 16:14:15.000000000 +0100
+++ everything/net/mac80211/mesh_pathtbl.c	2008-02-25 16:19:30.000000000 +0100
@@ -55,10 +55,7 @@ static DEFINE_RWLOCK(pathtbl_resize_lock
  */
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 {
-	__sta_info_get(sta);
-	if (mpath->next_hop)
-		sta_info_put(mpath->next_hop);
-	mpath->next_hop = sta;
+	rcu_assign_pointer(mpath->next_hop, sta);
 }
 
 
@@ -236,7 +233,7 @@ void mesh_plink_broken(struct sta_info *
 	struct mesh_path *mpath;
 	struct mpath_node *node;
 	struct hlist_node *p;
-	struct net_device *dev = sta->dev;
+	struct net_device *dev = sta->sdata->dev;
 	int i;
 
 	rcu_read_lock();
@@ -266,9 +263,9 @@ EXPORT_SYMBOL(mesh_plink_broken);
  *
  * RCU notes: this function is called when a mesh plink transitions from ESTAB
  * to any other state, since ESTAB state is the only one that allows path
- * creation. This will happen before the sta can be freed (since we hold
- * a reference to it) so any reader in a rcu read block will be protected
- * against the plink dissapearing.
+ * creation. This will happen before the sta can be freed (because
+ * sta_info_destroy() calls this) so any reader in a rcu read block will be
+ * protected against the plink disappearing.
  */
 void mesh_path_flush_by_nexthop(struct sta_info *sta)
 {
@@ -280,7 +277,7 @@ void mesh_path_flush_by_nexthop(struct s
 	for_each_mesh_entry(mesh_paths, p, node, i) {
 		mpath = node->mpath;
 		if (mpath->next_hop == sta)
-			mesh_path_del(mpath->dst, mpath->dev);
+			mesh_path_del(mpath->dst, mpath->dev, true);
 	}
 }
 
@@ -294,7 +291,7 @@ void mesh_path_flush(struct net_device *
 	for_each_mesh_entry(mesh_paths, p, node, i) {
 		mpath = node->mpath;
 		if (mpath->dev == dev)
-			mesh_path_del(mpath->dst, mpath->dev);
+			mesh_path_del(mpath->dst, mpath->dev, false);
 	}
 }
 
@@ -303,8 +300,8 @@ static void mesh_path_node_reclaim(struc
 	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
 	struct ieee80211_sub_if_data *sdata =
 		IEEE80211_DEV_TO_SUB_IF(node->mpath->dev);
-	if (node->mpath->next_hop)
-		sta_info_put(node->mpath->next_hop);
+
+	rcu_assign_pointer(node->mpath->next_hop, NULL);
 	atomic_dec(&sdata->u.sta.mpaths);
 	kfree(node->mpath);
 	kfree(node);
@@ -319,9 +316,10 @@ static void mesh_path_node_reclaim(struc
  * Returns: 0 if succesful
  *
  * State: if the path is being resolved, the deletion will be postponed until
- * the path resolution completes or times out.
+ * the path resolution completes or times out, unless the force parameter
+ * is given.
  */
-int mesh_path_del(u8 *addr, struct net_device *dev)
+int mesh_path_del(u8 *addr, struct net_device *dev, bool force)
 {
 	struct mesh_path *mpath;
 	struct mpath_node *node;
@@ -340,7 +338,7 @@ int mesh_path_del(u8 *addr, struct net_d
 		if (mpath->dev == dev &&
 				memcmp(addr, mpath->dst, ETH_ALEN) == 0) {
 			spin_lock_bh(&mpath->state_lock);
-			if (mpath->flags & MESH_PATH_RESOLVING) {
+			if (!force && mpath->flags & MESH_PATH_RESOLVING) {
 				mpath->flags |= MESH_PATH_DELETE;
 			} else {
 				mpath->flags |= MESH_PATH_RESOLVING;
@@ -510,7 +508,7 @@ void mesh_path_expire(struct net_device 
 			time_after(jiffies,
 			 mpath->exp_time + MESH_PATH_EXPIRE)) {
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_del(mpath->dst, mpath->dev);
+			mesh_path_del(mpath->dst, mpath->dev, false);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
 	}
--- everything.orig/net/mac80211/mesh_plink.c	2008-02-25 16:14:08.000000000 +0100
+++ everything/net/mac80211/mesh_plink.c	2008-02-25 16:15:22.000000000 +0100
@@ -65,14 +65,14 @@ static inline
 void mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
 {
 	atomic_inc(&sdata->u.sta.mshstats.estab_plinks);
-	mesh_accept_plinks_update(sdata->dev);
+	mesh_accept_plinks_update(sdata);
 }
 
 static inline
 void mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
 {
 	atomic_dec(&sdata->u.sta.mshstats.estab_plinks);
-	mesh_accept_plinks_update(sdata->dev);
+	mesh_accept_plinks_update(sdata);
 }
 
 /**
@@ -99,12 +99,13 @@ static inline void mesh_plink_fsm_restar
  *
  * Returns: non-NULL on success, ERR_PTR() on error.
  */
-struct sta_info *mesh_plink_add(u8 *hw_addr, u64 rates, struct net_device *dev)
+struct sta_info *mesh_plink_add(u8 *hw_addr, u64 rates,
+				struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
-	if (memcmp(hw_addr, dev->dev_addr, ETH_ALEN) == 0)
+	if (compare_ether_addr(hw_addr, sdata->dev->dev_addr) == 0)
 		/* never add ourselves as neighbours */
 		return ERR_PTR(-EINVAL);
 
@@ -114,7 +115,7 @@ struct sta_info *mesh_plink_add(u8 *hw_a
 	if (local->num_sta >= MESH_MAX_PLINKS)
 		return ERR_PTR(-ENOSPC);
 
-	sta = sta_info_add(local, dev, hw_addr, GFP_KERNEL);
+	sta = sta_info_add(sdata, hw_addr);
 	if (IS_ERR(sta))
 		return sta;
 
@@ -125,7 +126,7 @@ struct sta_info *mesh_plink_add(u8 *hw_a
 	sta->supp_rates[local->hw.conf.channel->band] = rates;
 	rate_control_rate_init(sta, local);
 
-	mesh_accept_plinks_update(dev);
+	mesh_accept_plinks_update(sdata);
 
 	return sta;
 }
@@ -141,7 +142,8 @@ struct sta_info *mesh_plink_add(u8 *hw_a
  */
 static void __mesh_plink_deactivate(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+
 	if (sta->plink_state == ESTAB)
 		mesh_plink_dec_estab_count(sdata);
 	sta->plink_state = BLOCKED;
@@ -246,11 +248,15 @@ void mesh_neighbour_update(u8 *hw_addr, 
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, hw_addr);
 	if (!sta) {
-		sta = mesh_plink_add(hw_addr, rates, dev);
-		if (IS_ERR(sta))
+		sta = mesh_plink_add(hw_addr, rates, sdata);
+		if (IS_ERR(sta)) {
+			rcu_read_unlock();
 			return;
+		}
 	}
 
 	sta->last_rx = jiffies;
@@ -260,7 +266,7 @@ void mesh_neighbour_update(u8 *hw_addr, 
 			sdata->u.sta.mshcfg.auto_open_plinks)
 		mesh_plink_open(sta);
 
-	sta_info_put(sta);
+	rcu_read_unlock();
 }
 
 static void mesh_plink_timer(unsigned long data)
@@ -273,6 +279,11 @@ static void mesh_plink_timer(unsigned lo
 	DECLARE_MAC_BUF(mac);
 #endif
 
+	/*
+	 * This STA is valid because sta_info_destroy() will
+	 * del_timer_sync() this timer after having made sure
+	 * it cannot be readded (by deleting the plink.)
+	 */
 	sta = (struct sta_info *) data;
 
 	spin_lock_bh(&sta->plink_lock);
@@ -286,8 +297,8 @@ static void mesh_plink_timer(unsigned lo
 	reason = 0;
 	llid = sta->llid;
 	plid = sta->plid;
-	dev = sta->dev;
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	sdata = sta->sdata;
+	dev = sdata->dev;
 
 	switch (sta->plink_state) {
 	case OPN_RCVD:
@@ -302,8 +313,7 @@ static void mesh_plink_timer(unsigned lo
 			sta->plink_timeout = sta->plink_timeout +
 					     rand % sta->plink_timeout;
 			++sta->plink_retries;
-			if (!mod_plink_timer(sta, sta->plink_timeout))
-				__sta_info_get(sta);
+			mod_plink_timer(sta, sta->plink_timeout);
 			spin_unlock_bh(&sta->plink_lock);
 			mesh_plink_frame_tx(dev, PLINK_OPEN, sta->addr, llid,
 					    0, 0);
@@ -316,16 +326,14 @@ static void mesh_plink_timer(unsigned lo
 		if (!reason)
 			reason = cpu_to_le16(MESH_CONFIRM_TIMEOUT);
 		sta->plink_state = HOLDING;
-		if (!mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata)))
-			__sta_info_get(sta);
+		mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 		spin_unlock_bh(&sta->plink_lock);
 		mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid, plid,
 				    reason);
 		break;
 	case HOLDING:
 		/* holding timer */
-		if (del_timer(&sta->plink_timer))
-			sta_info_put(sta);
+		del_timer(&sta->plink_timer);
 		mesh_plink_fsm_restart(sta);
 		spin_unlock_bh(&sta->plink_lock);
 		break;
@@ -333,8 +341,6 @@ static void mesh_plink_timer(unsigned lo
 		spin_unlock_bh(&sta->plink_lock);
 		break;
 	}
-
-	sta_info_put(sta);
 }
 
 static inline void mesh_plink_timer_set(struct sta_info *sta, int timeout)
@@ -343,14 +349,13 @@ static inline void mesh_plink_timer_set(
 	sta->plink_timer.data = (unsigned long) sta;
 	sta->plink_timer.function = mesh_plink_timer;
 	sta->plink_timeout = timeout;
-	__sta_info_get(sta);
 	add_timer(&sta->plink_timer);
 }
 
 int mesh_plink_open(struct sta_info *sta)
 {
 	__le16 llid;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 #ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
 	DECLARE_MAC_BUF(mac);
 #endif
@@ -360,7 +365,6 @@ int mesh_plink_open(struct sta_info *sta
 	sta->llid = llid;
 	if (sta->plink_state != LISTEN) {
 		spin_unlock_bh(&sta->plink_lock);
-		sta_info_put(sta);
 		return -EBUSY;
 	}
 	sta->plink_state = OPN_SNT;
@@ -369,7 +373,8 @@ int mesh_plink_open(struct sta_info *sta
 	mpl_dbg("Mesh plink: starting establishment with %s\n",
 		print_mac(mac, sta->addr));
 
-	return mesh_plink_frame_tx(sta->dev, PLINK_OPEN, sta->addr, llid, 0, 0);
+	return mesh_plink_frame_tx(sdata->dev, PLINK_OPEN,
+				   sta->addr, llid, 0, 0);
 }
 
 void mesh_plink_block(struct sta_info *sta)
@@ -386,7 +391,7 @@ void mesh_plink_block(struct sta_info *s
 
 int mesh_plink_close(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	int llid, plid, reason;
 #ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
 	DECLARE_MAC_BUF(mac);
@@ -401,13 +406,11 @@ int mesh_plink_close(struct sta_info *st
 	if (sta->plink_state == LISTEN || sta->plink_state == BLOCKED) {
 		mesh_plink_fsm_restart(sta);
 		spin_unlock_bh(&sta->plink_lock);
-		sta_info_put(sta);
 		return 0;
 	} else if (sta->plink_state == ESTAB) {
 		__mesh_plink_deactivate(sta);
 		/* The timer should not be running */
-		if (!mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata)))
-			__sta_info_get(sta);
+		mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 	} else if (!mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata)))
 		sta->ignore_plink_timer = true;
 
@@ -415,15 +418,16 @@ int mesh_plink_close(struct sta_info *st
 	llid = sta->llid;
 	plid = sta->plid;
 	spin_unlock_bh(&sta->plink_lock);
-	mesh_plink_frame_tx(sta->dev, PLINK_CLOSE, sta->addr, llid, plid,
-			    reason);
+	mesh_plink_frame_tx(sta->sdata->dev, PLINK_CLOSE, sta->addr, llid,
+			    plid, reason);
 	return 0;
 }
 
 void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 			 size_t len, struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee802_11_elems elems;
 	struct sta_info *sta;
 	enum plink_event event;
@@ -435,7 +439,6 @@ void mesh_rx_plink_frame(struct net_devi
 #ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
 	DECLARE_MAC_BUF(mac);
 #endif
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (is_multicast_ether_addr(mgmt->da)) {
 		mpl_dbg("Mesh plink: ignore frame from multicast address");
@@ -474,14 +477,17 @@ void mesh_rx_plink_frame(struct net_devi
 	if (ftype == PLINK_CONFIRM || (ftype == PLINK_CLOSE && ie_len == 7))
 		memcpy(&llid, PLINK_GET_PLID(elems.peer_link), 2);
 
+	rcu_read_lock();
+
 	sta = sta_info_get(local, mgmt->sa);
 	if (!sta && ftype != PLINK_OPEN) {
 		mpl_dbg("Mesh plink: cls or cnf from unknown peer\n");
+		rcu_read_unlock();
 		return;
 	}
 
 	if (sta && sta->plink_state == BLOCKED) {
-		sta_info_put(sta);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -505,13 +511,15 @@ void mesh_rx_plink_frame(struct net_devi
 		u64 rates;
 		if (!mesh_plink_free_count(sdata)) {
 			mpl_dbg("Mesh plink error: no more free plinks\n");
+			rcu_read_unlock();
 			return;
 		}
 
 		rates = ieee80211_sta_get_rates(local, &elems, rx_status->band);
-		sta = mesh_plink_add(mgmt->sa, rates, dev);
+		sta = mesh_plink_add(mgmt->sa, rates, sdata);
 		if (IS_ERR(sta)) {
 			mpl_dbg("Mesh plink error: plink table full\n");
+			rcu_read_unlock();
 			return;
 		}
 		event = OPN_ACPT;
@@ -521,14 +529,14 @@ void mesh_rx_plink_frame(struct net_devi
 		switch (ftype) {
 		case PLINK_OPEN:
 			if (!mesh_plink_free_count(sdata) ||
-					(sta->plid && sta->plid != plid))
+			    (sta->plid && sta->plid != plid))
 				event = OPN_IGNR;
 			else
 				event = OPN_ACPT;
 			break;
 		case PLINK_CONFIRM:
 			if (!mesh_plink_free_count(sdata) ||
-				(sta->llid != llid || sta->plid != plid))
+			    (sta->llid != llid || sta->plid != plid))
 				event = CNF_IGNR;
 			else
 				event = CNF_ACPT;
@@ -555,7 +563,7 @@ void mesh_rx_plink_frame(struct net_devi
 		default:
 			mpl_dbg("Mesh plink: unknown frame subtype\n");
 			spin_unlock_bh(&sta->plink_lock);
-			sta_info_put(sta);
+			rcu_read_unlock();
 			return;
 		}
 	}
@@ -659,8 +667,7 @@ void mesh_rx_plink_frame(struct net_devi
 					    plid, 0);
 			break;
 		case CNF_ACPT:
-			if (del_timer(&sta->plink_timer))
-				sta_info_put(sta);
+			del_timer(&sta->plink_timer);
 			sta->plink_state = ESTAB;
 			mesh_plink_inc_estab_count(sdata);
 			spin_unlock_bh(&sta->plink_lock);
@@ -693,8 +700,7 @@ void mesh_rx_plink_frame(struct net_devi
 					    plid, reason);
 			break;
 		case OPN_ACPT:
-			if (del_timer(&sta->plink_timer))
-				sta_info_put(sta);
+			del_timer(&sta->plink_timer);
 			sta->plink_state = ESTAB;
 			mesh_plink_inc_estab_count(sdata);
 			spin_unlock_bh(&sta->plink_lock);
@@ -717,9 +723,7 @@ void mesh_rx_plink_frame(struct net_devi
 			__mesh_plink_deactivate(sta);
 			sta->plink_state = HOLDING;
 			llid = sta->llid;
-			if (!mod_plink_timer(sta,
-					dot11MeshHoldingTimeout(sdata)))
-				__sta_info_get(sta);
+			mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 			spin_unlock_bh(&sta->plink_lock);
 			mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid,
 					    plid, reason);
@@ -738,10 +742,8 @@ void mesh_rx_plink_frame(struct net_devi
 	case HOLDING:
 		switch (event) {
 		case CLS_ACPT:
-			if (del_timer(&sta->plink_timer)) {
+			if (del_timer(&sta->plink_timer))
 				sta->ignore_plink_timer = 1;
-				sta_info_put(sta);
-			}
 			mesh_plink_fsm_restart(sta);
 			spin_unlock_bh(&sta->plink_lock);
 			break;
@@ -766,5 +768,6 @@ void mesh_rx_plink_frame(struct net_devi
 		spin_unlock_bh(&sta->plink_lock);
 		break;
 	}
-	sta_info_put(sta);
+
+	rcu_read_unlock();
 }
--- everything.orig/net/mac80211/mesh_hwmp.c	2008-02-25 16:14:08.000000000 +0100
+++ everything/net/mac80211/mesh_hwmp.c	2008-02-25 16:15:22.000000000 +0100
@@ -294,7 +294,6 @@ static u32 hwmp_route_info_get(struct ne
 		orig_metric = PREP_IE_METRIC(hwmp_ie);
 		break;
 	default:
-		sta_info_put(sta);
 		rcu_read_unlock();
 		return 0;
 	}
@@ -330,7 +329,6 @@ static u32 hwmp_route_info_get(struct ne
 			mpath = mesh_path_lookup(orig_addr, dev);
 			if (!mpath) {
 				rcu_read_unlock();
-				sta_info_put(sta);
 				return 0;
 			}
 			spin_lock_bh(&mpath->state_lock);
@@ -372,7 +370,6 @@ static u32 hwmp_route_info_get(struct ne
 			mpath = mesh_path_lookup(ta, dev);
 			if (!mpath) {
 				rcu_read_unlock();
-				sta_info_put(sta);
 				return 0;
 			}
 			spin_lock_bh(&mpath->state_lock);
@@ -391,7 +388,6 @@ static u32 hwmp_route_info_get(struct ne
 			spin_unlock_bh(&mpath->state_lock);
 	}
 
-	sta_info_put(sta);
 	rcu_read_unlock();
 
 	return process ? new_metric : 0;
@@ -861,5 +857,5 @@ void mesh_path_timer(unsigned long data)
 endmpathtimer:
 	rcu_read_unlock();
 	if (delete)
-		mesh_path_del(mpath->dst, mpath->dev);
+		mesh_path_del(mpath->dst, mpath->dev, false);
 }

-- 

