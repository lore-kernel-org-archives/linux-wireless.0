Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbYBVOId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 09:08:33 -0500
Message-Id: <20080222111750.613304000@sipsolutions.net> (sfid-20080222_140849_607480_717D65FD)
References: <20080222111644.183587000@sipsolutions.net>
Date: Fri, 22 Feb 2008 12:16:50 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 6/8] mac80211: split sta_info_add
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sta_info_add() has two functions: allocating a station info
structure and inserting it into the hash table/list. Splitting
these two functions allows allocating with GFP_KERNEL in many
places instead of GFP_ATOMIC which is now required by the RCU
protection. Additionally, in many places RCU protection is now
no longer needed at all because between sta_info_alloc() and
sta_info_insert() the caller owns the structure.

This fixes a few race conditions with setting initial flags
and similar, but not all (see comments in ieee80211_sta.c and
cfg.c).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c           |   38 ++++++++++++++++-------
 net/mac80211/ieee80211.c     |   18 ++++++-----
 net/mac80211/ieee80211_sta.c |   44 ++++++++++++++++++++-------
 net/mac80211/sta_info.c      |   69 +++++++++++++++++++++++++++++--------------
 net/mac80211/sta_info.h      |   17 +++++++---
 5 files changed, 129 insertions(+), 57 deletions(-)

--- everything.orig/net/mac80211/sta_info.c	2008-02-22 11:53:23.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-22 11:54:34.000000000 +0100
@@ -29,12 +29,13 @@
  * for faster lookup and a list for iteration. They are managed using
  * RCU, i.e. access to the list and hash table is protected by RCU.
  *
- * STA info structures are always "alive" when they are added with
- * @sta_info_add() [this may be changed in the future to allow allocating
- * outside of a critical section!], they are then added to the hash
- * table and list. Therefore, @sta_info_add() must also be RCU protected,
- * also, the caller of @sta_info_add() cannot assume that it owns the
- * structure.
+ * Upon allocating a STA info structure with @sta_info_alloc(), the
+ * caller owns that structure. It must then either destroy it using
+ * @sta_info_destroy() (which is pretty useless) or insert it into
+ * the hash table using @sta_info_insert() which demotes the reference
+ * from ownership to a regular RCU-protected reference, if the function
+ * is called without protection by an RCU critical section the reference
+ * is instantly invalidated.
  *
  * Because there are debugfs entries for each station, and adding those
  * must be able to sleep, it is also possible to "pin" a station entry,
@@ -112,6 +113,10 @@ void sta_info_destroy(struct sta_info *s
 	struct ieee80211_local *local = sta->local;
 	struct sk_buff *skb;
 	int i;
+	DECLARE_MAC_BUF(mbuf);
+
+	if (!sta)
+		return;
 
 	ieee80211_key_free(sta->key);
 	sta->key = NULL;
@@ -134,6 +139,11 @@ void sta_info_destroy(struct sta_info *s
 	rate_control_free_sta(sta->rate_ctrl, sta->rate_ctrl_priv);
 	rate_control_put(sta->rate_ctrl);
 
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: Destroyed STA %s\n",
+	       wiphy_name(local->hw.wiphy), print_mac(mbuf, sta->addr));
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+
 	kfree(sta);
 }
 
@@ -146,18 +156,17 @@ static void sta_info_hash_add(struct iee
 	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->addr)], sta);
 }
 
-struct sta_info *sta_info_add(struct ieee80211_sub_if_data *sdata,
-			      u8 *addr)
+struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
+				u8 *addr, gfp_t gfp)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int i;
-	DECLARE_MAC_BUF(mac);
-	unsigned long flags;
+	DECLARE_MAC_BUF(mbuf);
 
-	sta = kzalloc(sizeof(*sta), GFP_ATOMIC);
+	sta = kzalloc(sizeof(*sta), gfp);
 	if (!sta)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	memcpy(sta->addr, addr, ETH_ALEN);
 	sta->local = local;
@@ -165,11 +174,11 @@ struct sta_info *sta_info_add(struct iee
 
 	sta->rate_ctrl = rate_control_get(local->rate_ctrl);
 	sta->rate_ctrl_priv = rate_control_alloc_sta(sta->rate_ctrl,
-						     GFP_ATOMIC);
+						     gfp);
 	if (!sta->rate_ctrl_priv) {
 		rate_control_put(sta->rate_ctrl);
 		kfree(sta);
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	}
 
 	spin_lock_init(&sta->ampdu_mlme.ampdu_rx);
@@ -196,11 +205,27 @@ struct sta_info *sta_info_add(struct iee
 	}
 	skb_queue_head_init(&sta->ps_tx_buf);
 	skb_queue_head_init(&sta->tx_filtered);
+
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: Allocated STA %s\n",
+	       wiphy_name(local->hw.wiphy), print_mac(mbuf, sta->addr));
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+
+	return sta;
+}
+
+int sta_info_insert(struct sta_info *sta)
+{
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	unsigned long flags;
+	DECLARE_MAC_BUF(mac);
+
 	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
-	if (__sta_info_find(local, addr)) {
+	if (__sta_info_find(local, sta->addr)) {
 		spin_unlock_irqrestore(&local->sta_lock, flags);
-		return ERR_PTR(-EEXIST);
+		return -EEXIST;
 	}
 	list_add(&sta->list, &local->sta_list);
 	local->num_sta++;
@@ -212,16 +237,16 @@ struct sta_info *sta_info_add(struct iee
 			sdata = sdata->u.vlan.ap;
 
 		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
-				       STA_NOTIFY_ADD, addr);
+				       STA_NOTIFY_ADD, sta->addr);
 	}
 
-	spin_unlock_irqrestore(&local->sta_lock, flags);
-
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: Added STA %s\n",
-	       wiphy_name(local->hw.wiphy), print_mac(mac, addr));
+	printk(KERN_DEBUG "%s: Inserted STA %s\n",
+	       wiphy_name(local->hw.wiphy), print_mac(mac, sta->addr));
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
+	spin_unlock_irqrestore(&local->sta_lock, flags);
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* debugfs entry adding might sleep, so schedule process
 	 * context task for adding entry for STAs that do not yet
@@ -229,7 +254,7 @@ struct sta_info *sta_info_add(struct iee
 	queue_work(local->hw.workqueue, &local->sta_debugfs_add);
 #endif
 
-	return sta;
+	return 0;
 }
 
 static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
--- everything.orig/net/mac80211/sta_info.h	2008-02-22 11:53:23.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-22 11:54:34.000000000 +0100
@@ -248,12 +248,19 @@ struct sta_info {
  */
 struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr);
 /*
- * Add a new STA info, must be under RCU read lock
- * because otherwise the returned reference isn't
- * necessarily valid long enough.
+ * Create a new STA info, caller owns returned structure
+ * until sta_info_insert().
  */
-struct sta_info *sta_info_add(struct ieee80211_sub_if_data *sdata,
-			      u8 *addr);
+struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
+				u8 *addr, gfp_t gfp);
+/*
+ * Insert STA info into hash table/list, returns zero or a
+ * -EEXIST if (if the same MAC address is already present).
+ *
+ * Calling this without RCU protection makes the caller
+ * relinquish its reference to @sta.
+ */
+int sta_info_insert(struct sta_info *sta);
 /*
  * Unlink a STA info from the hash table/list.
  * This can NULL the STA pointer if somebody else
--- everything.orig/net/mac80211/cfg.c	2008-02-22 11:53:23.000000000 +0100
+++ everything/net/mac80211/cfg.c	2008-02-22 12:03:23.000000000 +0100
@@ -533,6 +533,12 @@ static void sta_apply_parameters(struct 
 	int i, j;
 	struct ieee80211_supported_band *sband;
 
+	/*
+	 * FIXME: updating the flags is racy when this function is
+	 *	  called from ieee80211_change_station(), this will
+	 *	  be resolved in a future patch.
+	 */
+
 	if (params->station_flags & STATION_FLAG_CHANGED) {
 		sta->flags &= ~WLAN_STA_AUTHORIZED;
 		if (params->station_flags & STATION_FLAG_AUTHORIZED)
@@ -547,6 +553,13 @@ static void sta_apply_parameters(struct 
 			sta->flags |= WLAN_STA_WME;
 	}
 
+	/*
+	 * FIXME: updating the following information is racy when this
+	 *	  function is called from ieee80211_change_station().
+	 *	  However, all this information should be static so
+	 *	  maybe we should just reject attemps to change it.
+	 */
+
 	if (params->aid) {
 		sta->aid = params->aid;
 		if (sta->aid > IEEE80211_MAX_AID)
@@ -577,6 +590,7 @@ static int ieee80211_add_station(struct 
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
+	int err;
 
 	/* Prevent a race with changing the rate control algorithm */
 	if (!netif_running(dev))
@@ -591,17 +605,9 @@ static int ieee80211_add_station(struct 
 	} else
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	rcu_read_lock();
-
-	sta = sta_info_add(sdata, mac);
-	if (IS_ERR(sta)) {
-		rcu_read_unlock();
-		return PTR_ERR(sta);
-	}
-
-	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN ||
-	    sdata->vif.type == IEEE80211_IF_TYPE_AP)
-		ieee80211_send_layer2_update(sta);
+	sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
+	if (!sta)
+		return -ENOMEM;
 
 	sta->flags = WLAN_STA_AUTH | WLAN_STA_ASSOC;
 
@@ -609,7 +615,15 @@ static int ieee80211_add_station(struct 
 
 	rate_control_rate_init(sta, local);
 
-	rcu_read_unlock();
+	err = sta_info_insert(sta);
+	if (err) {
+		sta_info_destroy(sta);
+		return err;
+	}
+
+	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN ||
+	    sdata->vif.type == IEEE80211_IF_TYPE_AP)
+		ieee80211_send_layer2_update(sta);
 
 	return 0;
 }
--- everything.orig/net/mac80211/ieee80211.c	2008-02-22 11:53:23.000000000 +0100
+++ everything/net/mac80211/ieee80211.c	2008-02-22 11:54:34.000000000 +0100
@@ -888,6 +888,7 @@ int ieee80211_if_update_wds(struct net_d
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
+	int err;
 	DECLARE_MAC_BUF(mac);
 
 	might_sleep();
@@ -895,16 +896,19 @@ int ieee80211_if_update_wds(struct net_d
 	if (compare_ether_addr(remote_addr, sdata->u.wds.remote_addr) == 0)
 		return 0;
 
-	rcu_read_lock();
-
 	/* Create STA entry for the new peer */
-	sta = sta_info_add(sdata, remote_addr);
-	if (IS_ERR(sta)) {
-		rcu_read_unlock();
-		return PTR_ERR(sta);
-	}
+	sta = sta_info_alloc(sdata, remote_addr, GFP_KERNEL);
+	if (!sta)
+		return -ENOMEM;
 
 	sta->flags |= WLAN_STA_AUTHORIZED;
+	err = sta_info_insert(sta);
+	if (err) {
+		sta_info_destroy(sta);
+		return err;
+	}
+
+	rcu_read_lock();
 
 	/* Remove STA entry for the old peer */
 	sta = sta_info_get(local, sdata->u.wds.remote_addr);
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-02-22 11:53:23.000000000 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-02-22 11:56:41.000000000 +0100
@@ -1461,7 +1461,7 @@ void sta_addba_resp_timer_expired(unsign
 {
 	/* not an elegant detour, but there is no choice as the timer passes
 	 * only one argument, and both sta_info and TID are needed, so init
-	 * flow in sta_info_add gives the TID as data, while the timer_to_id
+	 * flow in sta_info_create gives the TID as data, while the timer_to_id
 	 * array gives the sta through container_of */
 	u16 tid = *(int *)data;
 	struct sta_info *temp_sta = container_of((void *)data,
@@ -1512,7 +1512,7 @@ void sta_rx_agg_session_timer_expired(un
 {
 	/* not an elegant detour, but there is no choice as the timer passes
 	 * only one argument, and verious sta_info are needed here, so init
-	 * flow in sta_info_add gives the TID as data, while the timer_to_id
+	 * flow in sta_info_create gives the TID as data, while the timer_to_id
 	 * array gives the sta through container_of */
 	u8 *ptid = (u8 *)data;
 	u8 *timer_to_id = ptid - *ptid;
@@ -1836,11 +1836,12 @@ static void ieee80211_rx_mgmt_assoc_resp
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
 		struct ieee80211_sta_bss *bss;
+		int err;
 
-		sta = sta_info_add(sdata, ifsta->bssid);
-		if (IS_ERR(sta)) {
-			printk(KERN_DEBUG "%s: failed to add STA entry for the"
-			       " AP (error %ld)\n", dev->name, PTR_ERR(sta));
+		sta = sta_info_alloc(sdata, ifsta->bssid, GFP_ATOMIC);
+		if (!sta) {
+			printk(KERN_DEBUG "%s: failed to alloc STA entry for"
+			       " the AP\n", dev->name);
 			rcu_read_unlock();
 			return;
 		}
@@ -1853,8 +1854,27 @@ static void ieee80211_rx_mgmt_assoc_resp
 			sta->last_noise = bss->noise;
 			ieee80211_rx_bss_put(dev, bss);
 		}
+
+		err = sta_info_insert(sta);
+		if (err) {
+			printk(KERN_DEBUG "%s: failed to insert STA entry for"
+			       " the AP (error %d)\n", dev->name, err);
+			sta_info_destroy(sta);
+			rcu_read_unlock();
+			return;
+		}
 	}
 
+	/*
+	 * FIXME: Do we really need to update the sta_info's information here?
+	 *	  We already know about the AP (we found it in our list) so it
+	 *	  should already be filled with the right info, no?
+	 *	  As is stands, all this is racy because typically we assume
+	 *	  the information that is filled in here (except flags) doesn't
+	 *	  change while a STA structure is alive. As such, it should move
+	 *	  to between the sta_info_alloc() and sta_info_insert() above.
+	 */
+
 	sta->flags |= WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP |
 		      WLAN_STA_AUTHORIZED;
 
@@ -2494,10 +2514,8 @@ static void ieee80211_rx_bss_info(struct
 				       "local TSF - IBSS merge with BSSID %s\n",
 				       dev->name, print_mac(mac, mgmt->bssid));
 			ieee80211_sta_join_ibss(dev, &sdata->u.sta, bss);
-			rcu_read_lock();
 			ieee80211_ibss_add_sta(dev, NULL,
 					       mgmt->bssid, mgmt->sa);
-			rcu_read_unlock();
 		}
 	}
 
@@ -3837,7 +3855,6 @@ int ieee80211_sta_set_extra_ie(struct ne
 }
 
 
-/* must be called under RCU read lock */
 struct sta_info * ieee80211_ibss_add_sta(struct net_device *dev,
 					 struct sk_buff *skb, u8 *bssid,
 					 u8 *addr)
@@ -3860,8 +3877,8 @@ struct sta_info * ieee80211_ibss_add_sta
 	printk(KERN_DEBUG "%s: Adding new IBSS station %s (dev=%s)\n",
 	       wiphy_name(local->hw.wiphy), print_mac(mac, addr), dev->name);
 
-	sta = sta_info_add(sdata, addr);
-	if (IS_ERR(sta))
+	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
+	if (!sta)
 		return NULL;
 
 	sta->flags |= WLAN_STA_AUTHORIZED;
@@ -3871,6 +3888,11 @@ struct sta_info * ieee80211_ibss_add_sta
 
 	rate_control_rate_init(sta, local);
 
+	if (sta_info_insert(sta)) {
+		sta_info_destroy(sta);
+		return NULL;
+	}
+
 	return sta;
 }
 

-- 

