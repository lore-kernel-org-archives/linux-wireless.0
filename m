Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYBYPb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:31:58 -0500
Message-Id: <20080225153007.918098000@sipsolutions.net> (sfid-20080225_153207_962839_B3B94CE1)
References: <20080225152740.360393000@sipsolutions.net>
Date: Mon, 25 Feb 2008 16:27:47 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 07/10] mac80211: split sta_info_add
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
cfg.c). More documentation on the existing races will be in
a follow-up patch.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c           |   42 +++++++++++++++++++------
 net/mac80211/ieee80211.c     |   18 ++++++----
 net/mac80211/ieee80211_sta.c |   44 +++++++++++++++++++-------
 net/mac80211/mesh.h          |    4 +-
 net/mac80211/mesh_plink.c    |   43 ++++++++++++++-----------
 net/mac80211/sta_info.c      |   72 +++++++++++++++++++++++++++++--------------
 net/mac80211/sta_info.h      |   17 +++++++---
 7 files changed, 166 insertions(+), 74 deletions(-)

--- everything.orig/net/mac80211/sta_info.c	2008-02-25 16:25:11.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-25 16:25:12.000000000 +0100
@@ -31,12 +31,13 @@
  * for faster lookup and a list for iteration. They are managed using
  * RCU, i.e. access to the list and hash table is protected by RCU.
  *
- * STA info structures are always "alive" when they are added with
- * @sta_info_add() [this may be changed in the future to allow allocating
- * outside of a critical section!], they are then added to the hash
- * table and list. Therefore, @sta_info_add() must also be RCU protected,
- * also, the caller of @sta_info_add() cannot assume that it owns the
- * structure.
+ * Upon allocating a STA info structure with @sta_info_alloc() or
+ * mesh_plink_alloc(), the caller owns that structure. It must then either
+ * destroy it using @sta_info_destroy() (which is pretty useless) or insert
+ * it into the hash table using @sta_info_insert() which demotes the reference
+ * from ownership to a regular RCU-protected reference; if the function
+ * is called without protection by an RCU critical section the reference
+ * is instantly invalidated.
  *
  * Because there are debugfs entries for each station, and adding those
  * must be able to sleep, it is also possible to "pin" a station entry,
@@ -131,6 +132,10 @@ void sta_info_destroy(struct sta_info *s
 	struct ieee80211_local *local = sta->local;
 	struct sk_buff *skb;
 	int i;
+	DECLARE_MAC_BUF(mbuf);
+
+	if (!sta)
+		return;
 
 	ASSERT_RTNL();
 	might_sleep();
@@ -167,6 +172,11 @@ void sta_info_destroy(struct sta_info *s
 	rate_control_free_sta(sta->rate_ctrl, sta->rate_ctrl_priv);
 	rate_control_put(sta->rate_ctrl);
 
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: Destroyed STA %s\n",
+	       wiphy_name(local->hw.wiphy), print_mac(mbuf, sta->addr));
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+
 	kfree(sta);
 }
 
@@ -179,18 +189,17 @@ static void sta_info_hash_add(struct iee
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
@@ -198,11 +207,11 @@ struct sta_info *sta_info_add(struct iee
 
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
@@ -229,11 +238,27 @@ struct sta_info *sta_info_add(struct iee
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
@@ -245,16 +270,16 @@ struct sta_info *sta_info_add(struct iee
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
@@ -262,7 +287,10 @@ struct sta_info *sta_info_add(struct iee
 	queue_work(local->hw.workqueue, &local->sta_debugfs_add);
 #endif
 
-	return sta;
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		mesh_accept_plinks_update(sdata);
+
+	return 0;
 }
 
 static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
--- everything.orig/net/mac80211/sta_info.h	2008-02-25 16:25:11.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-25 16:25:12.000000000 +0100
@@ -283,12 +283,19 @@ struct sta_info *sta_info_get(struct iee
 struct sta_info *sta_info_get_by_idx(struct ieee80211_local *local, int idx,
 				      struct net_device *dev);
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
--- everything.orig/net/mac80211/cfg.c	2008-02-25 16:25:11.000000000 +0100
+++ everything/net/mac80211/cfg.c	2008-02-25 16:25:12.000000000 +0100
@@ -577,6 +577,12 @@ static void sta_apply_parameters(struct 
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	/*
+	 * FIXME: updating the flags is racy when this function is
+	 *	  called from ieee80211_change_station(), this will
+	 *	  be resolved in a future patch.
+	 */
+
 	if (params->station_flags & STATION_FLAG_CHANGED) {
 		sta->flags &= ~WLAN_STA_AUTHORIZED;
 		if (params->station_flags & STATION_FLAG_AUTHORIZED)
@@ -591,6 +597,13 @@ static void sta_apply_parameters(struct 
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
@@ -632,6 +645,7 @@ static int ieee80211_add_station(struct 
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
+	int err;
 
 	/* Prevent a race with changing the rate control algorithm */
 	if (!netif_running(dev))
@@ -647,16 +661,11 @@ static int ieee80211_add_station(struct 
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
-		sta = mesh_plink_add(mac, DEFAULT_RATES, sdata);
+		sta = mesh_plink_alloc(sdata, mac, DEFAULT_RATES, GFP_KERNEL);
 	else
-		sta = sta_info_add(sdata, mac);
-
-	if (IS_ERR(sta))
-		return PTR_ERR(sta);
-
-	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN ||
-	    sdata->vif.type == IEEE80211_IF_TYPE_AP)
-		ieee80211_send_layer2_update(sta);
+		sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
+	if (!sta)
+		return -ENOMEM;
 
 	sta->flags = WLAN_STA_AUTH | WLAN_STA_ASSOC;
 
@@ -664,6 +673,21 @@ static int ieee80211_add_station(struct 
 
 	rate_control_rate_init(sta, local);
 
+	rcu_read_lock();
+
+	err = sta_info_insert(sta);
+	if (err) {
+		sta_info_destroy(sta);
+		rcu_read_unlock();
+		return err;
+	}
+
+	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN ||
+	    sdata->vif.type == IEEE80211_IF_TYPE_AP)
+		ieee80211_send_layer2_update(sta);
+
+	rcu_read_unlock();
+
 	return 0;
 }
 
--- everything.orig/net/mac80211/ieee80211.c	2008-02-25 16:25:11.000000000 +0100
+++ everything/net/mac80211/ieee80211.c	2008-02-25 16:25:12.000000000 +0100
@@ -899,6 +899,7 @@ int ieee80211_if_update_wds(struct net_d
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
+	int err;
 	DECLARE_MAC_BUF(mac);
 
 	might_sleep();
@@ -906,16 +907,19 @@ int ieee80211_if_update_wds(struct net_d
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
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-02-25 16:25:11.000000000 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-02-25 16:25:12.000000000 +0100
@@ -1453,7 +1453,7 @@ void sta_addba_resp_timer_expired(unsign
 {
 	/* not an elegant detour, but there is no choice as the timer passes
 	 * only one argument, and both sta_info and TID are needed, so init
-	 * flow in sta_info_add gives the TID as data, while the timer_to_id
+	 * flow in sta_info_create gives the TID as data, while the timer_to_id
 	 * array gives the sta through container_of */
 	u16 tid = *(int *)data;
 	struct sta_info *temp_sta = container_of((void *)data,
@@ -1504,7 +1504,7 @@ void sta_rx_agg_session_timer_expired(un
 {
 	/* not an elegant detour, but there is no choice as the timer passes
 	 * only one argument, and verious sta_info are needed here, so init
-	 * flow in sta_info_add gives the TID as data, while the timer_to_id
+	 * flow in sta_info_create gives the TID as data, while the timer_to_id
 	 * array gives the sta through container_of */
 	u8 *ptid = (u8 *)data;
 	u8 *timer_to_id = ptid - *ptid;
@@ -1828,11 +1828,12 @@ static void ieee80211_rx_mgmt_assoc_resp
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
@@ -1845,8 +1846,27 @@ static void ieee80211_rx_mgmt_assoc_resp
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
 
@@ -2587,10 +2607,8 @@ static void ieee80211_rx_bss_info(struct
 				       dev->name, print_mac(mac, mgmt->bssid));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 			ieee80211_sta_join_ibss(dev, &sdata->u.sta, bss);
-			rcu_read_lock();
 			ieee80211_ibss_add_sta(dev, NULL,
 					       mgmt->bssid, mgmt->sa);
-			rcu_read_unlock();
 		}
 	}
 
@@ -4022,7 +4040,6 @@ int ieee80211_sta_set_extra_ie(struct ne
 }
 
 
-/* must be called under RCU read lock */
 struct sta_info * ieee80211_ibss_add_sta(struct net_device *dev,
 					 struct sk_buff *skb, u8 *bssid,
 					 u8 *addr)
@@ -4045,8 +4062,8 @@ struct sta_info * ieee80211_ibss_add_sta
 	printk(KERN_DEBUG "%s: Adding new IBSS station %s (dev=%s)\n",
 	       wiphy_name(local->hw.wiphy), print_mac(mac, addr), dev->name);
 
-	sta = sta_info_add(sdata, addr);
-	if (IS_ERR(sta))
+	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
+	if (!sta)
 		return NULL;
 
 	sta->flags |= WLAN_STA_AUTHORIZED;
@@ -4056,6 +4073,11 @@ struct sta_info * ieee80211_ibss_add_sta
 
 	rate_control_rate_init(sta, local);
 
+	if (sta_info_insert(sta)) {
+		sta_info_destroy(sta);
+		return NULL;
+	}
+
 	return sta;
 }
 
--- everything.orig/net/mac80211/mesh.h	2008-02-25 16:25:11.000000000 +0100
+++ everything/net/mac80211/mesh.h	2008-02-25 16:25:12.000000000 +0100
@@ -232,8 +232,8 @@ void mesh_neighbour_update(u8 *hw_addr, 
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie,
 			      struct net_device *dev);
 void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
-struct sta_info *mesh_plink_add(u8 *hw_addr, u64 rates,
-				struct ieee80211_sub_if_data *sdata);
+struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
+				  u8 *hw_addr, u64 rates, gfp_t gfp);
 void mesh_plink_broken(struct sta_info *sta);
 void mesh_plink_deactivate(struct sta_info *sta);
 int mesh_plink_open(struct sta_info *sta);
--- everything.orig/net/mac80211/mesh_plink.c	2008-02-25 16:25:11.000000000 +0100
+++ everything/net/mac80211/mesh_plink.c	2008-02-25 16:25:12.000000000 +0100
@@ -89,44 +89,41 @@ static inline void mesh_plink_fsm_restar
 }
 
 /**
- * mesh_plink_add - allocate and add a new mesh peer link
+ * mesh_plink_alloc - allocate a new mesh peer link
  *
+ * @sdata: local mesh interface
  * @hw_addr: hardware address (ETH_ALEN length)
  * @rates: rates the mesh peer supports
- * @dev: local mesh interface
  *
  * The initial state of the new plink is set to LISTEN
  *
- * Returns: non-NULL on success, ERR_PTR() on error.
+ * Returns: NULL on error.
  */
-struct sta_info *mesh_plink_add(u8 *hw_addr, u64 rates,
-				struct ieee80211_sub_if_data *sdata)
+struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
+				  u8 *hw_addr, u64 rates, gfp_t gfp)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
 	if (compare_ether_addr(hw_addr, sdata->dev->dev_addr) == 0)
 		/* never add ourselves as neighbours */
-		return ERR_PTR(-EINVAL);
+		return NULL;
 
 	if (is_multicast_ether_addr(hw_addr))
-		return ERR_PTR(-EINVAL);
+		return NULL;
 
 	if (local->num_sta >= MESH_MAX_PLINKS)
-		return ERR_PTR(-ENOSPC);
+		return NULL;
 
-	sta = sta_info_add(sdata, hw_addr);
-	if (IS_ERR(sta))
-		return sta;
+	sta = sta_info_alloc(sdata, hw_addr, gfp);
+	if (!sta)
+		return NULL;
 
 	sta->plink_state = LISTEN;
 	spin_lock_init(&sta->plink_lock);
 	init_timer(&sta->plink_timer);
 	sta->flags |= WLAN_STA_AUTHORIZED;
 	sta->supp_rates[local->hw.conf.channel->band] = rates;
-	rate_control_rate_init(sta, local);
-
-	mesh_accept_plinks_update(sdata);
 
 	return sta;
 }
@@ -252,8 +249,13 @@ void mesh_neighbour_update(u8 *hw_addr, 
 
 	sta = sta_info_get(local, hw_addr);
 	if (!sta) {
-		sta = mesh_plink_add(hw_addr, rates, sdata);
-		if (IS_ERR(sta)) {
+		sta = mesh_plink_alloc(sdata, hw_addr, rates, GFP_ATOMIC);
+		if (!sta) {
+			rcu_read_unlock();
+			return;
+		}
+		if (sta_info_insert(sta)) {
+			sta_info_destroy(sta);
 			rcu_read_unlock();
 			return;
 		}
@@ -516,12 +518,17 @@ void mesh_rx_plink_frame(struct net_devi
 		}
 
 		rates = ieee80211_sta_get_rates(local, &elems, rx_status->band);
-		sta = mesh_plink_add(mgmt->sa, rates, sdata);
-		if (IS_ERR(sta)) {
+		sta = mesh_plink_alloc(sdata, mgmt->sa, rates, GFP_ATOMIC);
+		if (!sta) {
 			mpl_dbg("Mesh plink error: plink table full\n");
 			rcu_read_unlock();
 			return;
 		}
+		if (sta_info_insert(sta)) {
+			sta_info_destroy(sta);
+			rcu_read_unlock();
+			return;
+		}
 		event = OPN_ACPT;
 		spin_lock_bh(&sta->plink_lock);
 	} else {

-- 

