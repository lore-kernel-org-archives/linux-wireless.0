Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50262 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYIJWLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:11:39 -0400
Message-Id: <20080910220427.674985000@sipsolutions.net> (sfid-20080911_001143_730763_88F6FD73)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:02:02 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>
Subject: [PATCH 17/18] mac80211: share STA information with driver
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes mac80211 to share some more data about
stations with drivers. Should help iwlwifi and ath9k when
 they get around to updating, and might also help with
implementing rate control algorithms without internals.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c         |   30 +++++++--------
 drivers/net/wireless/b43/main.c           |    5 +-
 drivers/net/wireless/b43legacy/main.c     |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   12 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   12 +++---
 drivers/net/wireless/mac80211_hwsim.c     |    3 +
 include/net/mac80211.h                    |   53 ++++++++++++++++++++++++--
 net/mac80211/cfg.c                        |   12 +++---
 net/mac80211/debugfs_key.c                |    3 +
 net/mac80211/debugfs_sta.c                |    6 +--
 net/mac80211/ht.c                         |   22 +++++------
 net/mac80211/iface.c                      |    3 +
 net/mac80211/key.c                        |    2 -
 net/mac80211/mesh_hwmp.c                  |    8 ++--
 net/mac80211/mesh_plink.c                 |   44 +++++++++++-----------
 net/mac80211/mlme.c                       |    2 -
 net/mac80211/rx.c                         |   12 +++---
 net/mac80211/sta_info.c                   |   59 ++++++++++++++++++------------
 net/mac80211/sta_info.h                   |    7 ++-
 net/mac80211/tkip.c                       |    2 -
 net/mac80211/tx.c                         |   10 ++---
 net/mac80211/wme.c                        |    2 -
 net/mac80211/wpa.c                        |    2 -
 23 files changed, 187 insertions(+), 126 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-09-10 23:58:04.000000000 +0200
+++ everything/include/net/mac80211.h	2008-09-10 23:58:12.000000000 +0200
@@ -300,6 +300,9 @@ enum mac80211_tx_control_flags {
  *  (2) driver internal use (if applicable)
  *  (3) TX status information - driver tells mac80211 what happened
  *
+ * The TX control's sta pointer is only valid during the ->tx call,
+ * it may be NULL.
+ *
  * @flags: transmit info flags, defined above
  * @band: TBD
  * @tx_rate_idx: TBD
@@ -329,8 +332,8 @@ struct ieee80211_tx_info {
 		struct {
 			struct ieee80211_vif *vif;
 			struct ieee80211_key_conf *hw_key;
+			struct ieee80211_sta *sta;
 			unsigned long jiffies;
-			u16 aid;
 			s8 rts_cts_rate_idx, alt_retry_rate_idx;
 			u8 retry_limit;
 			u8 icv_len;
@@ -652,6 +655,29 @@ enum set_key_cmd {
 };
 
 /**
+ * struct ieee80211_sta - station table entry
+ *
+ * A station table entry represents a station we are possibly
+ * communicating with. Since stations are RCU-managed in
+ * mac80211, any ieee80211_sta pointer you get access to must
+ * either be protected by rcu_read_lock() explicitly or implicitly,
+ * or you must take good care to not use such a pointer after a
+ * call to your sta_notify callback that removed it.
+ *
+ * @addr: MAC address
+ * @aid: AID we assigned to the station if we're an AP
+ * @drv_priv: data area for driver use, will always be aligned to
+ *	sizeof(void *), size is determined in hw information.
+ */
+struct ieee80211_sta {
+	u8 addr[ETH_ALEN];
+	u16 aid;
+
+	/* must be last */
+	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
+};
+
+/**
  * enum sta_notify_cmd - sta notify command
  *
  * Used with the sta_notify() callback in &struct ieee80211_ops, this
@@ -795,6 +821,8 @@ enum ieee80211_hw_flags {
  *
  * @vif_data_size: size (in bytes) of the drv_priv data area
  *	within &struct ieee80211_vif.
+ * @sta_data_size: size (in bytes) of the drv_priv data area
+ *	within &struct ieee80211_sta.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -806,6 +834,7 @@ struct ieee80211_hw {
 	unsigned int extra_tx_headroom;
 	int channel_change_time;
 	int vif_data_size;
+	int sta_data_size;
 	u16 queues;
 	u16 ampdu_queues;
 	u16 max_listen_interval;
@@ -1087,7 +1116,7 @@ enum ieee80211_ampdu_mlme_action {
  *	This callback must be implemented and atomic.
  *
  * @set_tim: Set TIM bit. mac80211 calls this function when a TIM bit
- * 	must be set or cleared for a given AID. Must be atomic.
+ * 	must be set or cleared for a given STA. Must be atomic.
  *
  * @set_key: See the section "Hardware crypto acceleration"
  *	This callback can sleep, and is only called between add_interface
@@ -1173,7 +1202,8 @@ struct ieee80211_ops {
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
 				 int mc_count, struct dev_addr_list *mc_list);
-	int (*set_tim)(struct ieee80211_hw *hw, int aid, int set);
+	int (*set_tim)(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+		       bool set);
 	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		       const u8 *local_address, const u8 *address,
 		       struct ieee80211_key_conf *key);
@@ -1190,7 +1220,7 @@ struct ieee80211_ops {
 	int (*set_retry_limit)(struct ieee80211_hw *hw,
 			       u32 short_retry, u32 long_retr);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			enum sta_notify_cmd, const u8 *addr);
+			enum sta_notify_cmd, struct ieee80211_sta *sta);
 	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
 	int (*get_tx_stats)(struct ieee80211_hw *hw,
@@ -1200,7 +1230,7 @@ struct ieee80211_ops {
 	int (*tx_last_beacon)(struct ieee80211_hw *hw);
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    enum ieee80211_ampdu_mlme_action action,
-			    const u8 *addr, u16 tid, u16 *ssn);
+			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 };
 
 /**
@@ -1750,4 +1780,17 @@ void ieee80211_stop_tx_ba_cb_irqsafe(str
  */
 void ieee80211_notify_mac(struct ieee80211_hw *hw,
 			  enum ieee80211_notification_types  notif_type);
+
+/**
+ * ieee80211_find_sta - find a station
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @addr: station's address
+ *
+ * This function must be called under RCU lock and the
+ * resulting pointer is only valid under RCU lock as well.
+ */
+struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
+					 const u8 *addr);
+
 #endif /* MAC80211_H */
--- everything.orig/net/mac80211/sta_info.h	2008-09-10 23:57:50.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-09-10 23:58:12.000000000 +0200
@@ -218,6 +218,7 @@ struct sta_ampdu_mlme {
  * @plink_timeout: TBD
  * @plink_timer: TBD
  * @debugfs: debug filesystem info
+ * @sta: station information we share with the driver
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -232,8 +233,7 @@ struct sta_info {
 	spinlock_t flaglock;
 	struct ieee80211_ht_info ht_info;
 	u64 supp_rates[IEEE80211_NUM_BANDS];
-	u8 addr[ETH_ALEN];
-	u16 aid;
+
 	u16 listen_interval;
 
 	/*
@@ -327,6 +327,9 @@ struct sta_info {
 		struct dentry *agg_status;
 	} debugfs;
 #endif
+
+	/* keep last! */
+	struct ieee80211_sta sta;
 };
 
 static inline enum plink_state sta_plink_state(struct sta_info *sta)
--- everything.orig/net/mac80211/sta_info.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-09-10 23:58:12.000000000 +0200
@@ -73,11 +73,11 @@ static int sta_info_hash_del(struct ieee
 {
 	struct sta_info *s;
 
-	s = local->sta_hash[STA_HASH(sta->addr)];
+	s = local->sta_hash[STA_HASH(sta->sta.addr)];
 	if (!s)
 		return -ENOENT;
 	if (s == sta) {
-		rcu_assign_pointer(local->sta_hash[STA_HASH(sta->addr)],
+		rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)],
 				   s->hnext);
 		return 0;
 	}
@@ -94,13 +94,13 @@ static int sta_info_hash_del(struct ieee
 
 /* protected by RCU */
 static struct sta_info *__sta_info_find(struct ieee80211_local *local,
-					u8 *addr)
+					const u8 *addr)
 {
 	struct sta_info *sta;
 
 	sta = rcu_dereference(local->sta_hash[STA_HASH(addr)]);
 	while (sta) {
-		if (compare_ether_addr(sta->addr, addr) == 0)
+		if (compare_ether_addr(sta->sta.addr, addr) == 0)
 			break;
 		sta = rcu_dereference(sta->hnext);
 	}
@@ -151,7 +151,7 @@ static void __sta_info_free(struct ieee8
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Destroyed STA %s\n",
-	       wiphy_name(local->hw.wiphy), print_mac(mbuf, sta->addr));
+	       wiphy_name(local->hw.wiphy), print_mac(mbuf, sta->sta.addr));
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 	kfree(sta);
@@ -219,8 +219,8 @@ void sta_info_destroy(struct sta_info *s
 static void sta_info_hash_add(struct ieee80211_local *local,
 			      struct sta_info *sta)
 {
-	sta->hnext = local->sta_hash[STA_HASH(sta->addr)];
-	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->addr)], sta);
+	sta->hnext = local->sta_hash[STA_HASH(sta->sta.addr)];
+	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)], sta);
 }
 
 struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
@@ -231,14 +231,14 @@ struct sta_info *sta_info_alloc(struct i
 	int i;
 	DECLARE_MAC_BUF(mbuf);
 
-	sta = kzalloc(sizeof(*sta), gfp);
+	sta = kzalloc(sizeof(*sta) + local->hw.sta_data_size, gfp);
 	if (!sta)
 		return NULL;
 
 	spin_lock_init(&sta->lock);
 	spin_lock_init(&sta->flaglock);
 
-	memcpy(sta->addr, addr, ETH_ALEN);
+	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;
 	sta->sdata = sdata;
 
@@ -271,7 +271,7 @@ struct sta_info *sta_info_alloc(struct i
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Allocated STA %s\n",
-	       wiphy_name(local->hw.wiphy), print_mac(mbuf, sta->addr));
+	       wiphy_name(local->hw.wiphy), print_mac(mbuf, sta->sta.addr));
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 #ifdef CONFIG_MAC80211_MESH
@@ -300,15 +300,15 @@ int sta_info_insert(struct sta_info *sta
 		goto out_free;
 	}
 
-	if (WARN_ON(compare_ether_addr(sta->addr, sdata->dev->dev_addr) == 0 ||
-	            is_multicast_ether_addr(sta->addr))) {
+	if (WARN_ON(compare_ether_addr(sta->sta.addr, sdata->dev->dev_addr) == 0 ||
+	            is_multicast_ether_addr(sta->sta.addr))) {
 		err = -EINVAL;
 		goto out_free;
 	}
 
 	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
-	if (__sta_info_find(local, sta->addr)) {
+	if (__sta_info_find(local, sta->sta.addr)) {
 		spin_unlock_irqrestore(&local->sta_lock, flags);
 		err = -EEXIST;
 		goto out_free;
@@ -325,12 +325,12 @@ int sta_info_insert(struct sta_info *sta
 					     u.ap);
 
 		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
-				       STA_NOTIFY_ADD, sta->addr);
+				       STA_NOTIFY_ADD, &sta->sta);
 	}
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Inserted STA %s\n",
-	       wiphy_name(local->hw.wiphy), print_mac(mac, sta->addr));
+	       wiphy_name(local->hw.wiphy), print_mac(mac, sta->sta.addr));
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 	spin_unlock_irqrestore(&local->sta_lock, flags);
@@ -379,11 +379,12 @@ static void __sta_info_set_tim_bit(struc
 {
 	BUG_ON(!bss);
 
-	__bss_tim_set(bss, sta->aid);
+	__bss_tim_set(bss, sta->sta.aid);
 
 	if (sta->local->ops->set_tim) {
 		sta->local->tim_in_locked_section = true;
-		sta->local->ops->set_tim(local_to_hw(sta->local), sta->aid, 1);
+		sta->local->ops->set_tim(local_to_hw(sta->local),
+					 &sta->sta, true);
 		sta->local->tim_in_locked_section = false;
 	}
 }
@@ -404,11 +405,12 @@ static void __sta_info_clear_tim_bit(str
 {
 	BUG_ON(!bss);
 
-	__bss_tim_clear(bss, sta->aid);
+	__bss_tim_clear(bss, sta->sta.aid);
 
 	if (sta->local->ops->set_tim) {
 		sta->local->tim_in_locked_section = true;
-		sta->local->ops->set_tim(local_to_hw(sta->local), sta->aid, 0);
+		sta->local->ops->set_tim(local_to_hw(sta->local),
+					 &sta->sta, false);
 		sta->local->tim_in_locked_section = false;
 	}
 }
@@ -462,7 +464,7 @@ static void __sta_info_unlink(struct sta
 					     u.ap);
 
 		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
-				       STA_NOTIFY_REMOVE, (*sta)->addr);
+				       STA_NOTIFY_REMOVE, &(*sta)->sta);
 	}
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
@@ -474,7 +476,7 @@ static void __sta_info_unlink(struct sta
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Removed STA %s\n",
-	       wiphy_name(local->hw.wiphy), print_mac(mbuf, (*sta)->addr));
+	       wiphy_name(local->hw.wiphy), print_mac(mbuf, (*sta)->sta.addr));
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 	/*
@@ -570,7 +572,7 @@ static void sta_info_cleanup_expire_buff
 		local->total_ps_buffered--;
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "Buffered frame expired (STA "
-		       "%s)\n", print_mac(mac, sta->addr));
+		       "%s)\n", print_mac(mac, sta->sta.addr));
 #endif
 		dev_kfree_skb(skb);
 
@@ -817,7 +819,7 @@ void ieee80211_sta_expire(struct ieee802
 		if (time_after(jiffies, sta->last_rx + exp_time)) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 			printk(KERN_DEBUG "%s: expiring inactive STA %s\n",
-			       sdata->dev->name, print_mac(mac, sta->addr));
+			       sdata->dev->name, print_mac(mac, sta->sta.addr));
 #endif
 			__sta_info_unlink(&sta);
 			if (sta)
@@ -828,3 +830,14 @@ void ieee80211_sta_expire(struct ieee802
 	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
 		sta_info_destroy(sta);
 }
+
+struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
+                                         const u8 *addr)
+{
+	struct sta_info *sta = __sta_info_find(hw_to_local(hw), addr);
+
+	if (!sta)
+		return NULL;
+	return &sta->sta;
+}
+EXPORT_SYMBOL(ieee80211_find_sta);
--- everything.orig/net/mac80211/cfg.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-09-10 23:58:12.000000000 +0200
@@ -357,7 +357,7 @@ static int ieee80211_dump_station(struct
 	sta = sta_info_get_by_idx(local, idx, dev);
 	if (sta) {
 		ret = 0;
-		memcpy(mac, sta->addr, ETH_ALEN);
+		memcpy(mac, sta->sta.addr, ETH_ALEN);
 		sta_set_sinfo(sta, sinfo);
 	}
 
@@ -586,7 +586,7 @@ static void ieee80211_send_layer2_update
 	 * Update response frame; IEEE Std 802.2-1998, 5.4.1.2.1 */
 
 	memset(msg->da, 0xff, ETH_ALEN);
-	memcpy(msg->sa, sta->addr, ETH_ALEN);
+	memcpy(msg->sa, sta->sta.addr, ETH_ALEN);
 	msg->len = htons(6);
 	msg->dsap = 0;
 	msg->ssap = 0x01;	/* NULL LSAP, CR Bit: Response */
@@ -641,9 +641,9 @@ static void sta_apply_parameters(struct 
 	 */
 
 	if (params->aid) {
-		sta->aid = params->aid;
-		if (sta->aid > IEEE80211_MAX_AID)
-			sta->aid = 0; /* XXX: should this be an error? */
+		sta->sta.aid = params->aid;
+		if (sta->sta.aid > IEEE80211_MAX_AID)
+			sta->sta.aid = 0; /* XXX: should this be an error? */
 	}
 
 	if (params->listen_interval >= 0)
@@ -912,7 +912,7 @@ static void mpath_set_pinfo(struct mesh_
 			    struct mpath_info *pinfo)
 {
 	if (mpath->next_hop)
-		memcpy(next_hop, mpath->next_hop->addr, ETH_ALEN);
+		memcpy(next_hop, mpath->next_hop->sta.addr, ETH_ALEN);
 	else
 		memset(next_hop, 0, ETH_ALEN);
 
--- everything.orig/net/mac80211/debugfs_key.c	2008-09-10 23:50:17.000000000 +0200
+++ everything/net/mac80211/debugfs_key.c	2008-09-10 23:58:12.000000000 +0200
@@ -206,7 +206,8 @@ void ieee80211_debugfs_key_add(struct ie
 	rcu_read_lock();
 	sta = rcu_dereference(key->sta);
 	if (sta)
-		sprintf(buf, "../../stations/%s", print_mac(mac, sta->addr));
+		sprintf(buf, "../../stations/%s",
+			print_mac(mac, sta->sta.addr));
 	rcu_read_unlock();
 
 	/* using sta as a boolean is fine outside RCU lock */
--- everything.orig/net/mac80211/debugfs_sta.c	2008-09-10 23:50:17.000000000 +0200
+++ everything/net/mac80211/debugfs_sta.c	2008-09-10 23:58:12.000000000 +0200
@@ -50,7 +50,7 @@ static const struct file_operations sta_
 		STA_READ_##format(name, field)				\
 		STA_OPS(name)
 
-STA_FILE(aid, aid, D);
+STA_FILE(aid, sta.aid, D);
 STA_FILE(dev, sdata->dev->name, S);
 STA_FILE(rx_packets, rx_packets, LU);
 STA_FILE(tx_packets, tx_packets, LU);
@@ -176,7 +176,7 @@ static ssize_t sta_agg_status_write(stru
 	struct net_device *dev = sta->sdata->dev;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
-	u8 *da = sta->addr;
+	u8 *da = sta->sta.addr;
 	static int tid_static_tx[16] = {0, 0, 0, 0, 0, 0, 0, 0,
 					0, 0, 0, 0, 0, 0, 0, 0};
 	static int tid_static_rx[16] = {1, 1, 1, 1, 1, 1, 1, 1,
@@ -253,7 +253,7 @@ void ieee80211_sta_debugfs_add(struct st
 	if (!stations_dir)
 		return;
 
-	mac = print_mac(mbuf, sta->addr);
+	mac = print_mac(mbuf, sta->sta.addr);
 
 	sta->debugfs.dir = debugfs_create_dir(mac, stations_dir);
 	if (!sta->debugfs.dir)
--- everything.orig/net/mac80211/ht.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/net/mac80211/ht.c	2008-09-10 23:58:12.000000000 +0200
@@ -274,7 +274,7 @@ void ieee80211_sta_stop_rx_ba_session(st
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
-					ra, tid, NULL);
+				       &sta->sta, tid, NULL);
 	if (ret)
 		printk(KERN_DEBUG "HW problem - can not stop rx "
 				"aggregation for tid %d\n", tid);
@@ -328,7 +328,7 @@ static void sta_addba_resp_timer_expired
 
 	rcu_read_lock();
 
-	sta = sta_info_get(local, temp_sta->addr);
+	sta = sta_info_get(local, temp_sta->sta.addr);
 	if (!sta) {
 		rcu_read_unlock();
 		return;
@@ -354,7 +354,7 @@ static void sta_addba_resp_timer_expired
 	/* go through the state check in stop_BA_session */
 	*state = HT_AGG_STATE_OPERATIONAL;
 	spin_unlock_bh(&sta->lock);
-	ieee80211_stop_tx_ba_session(hw, temp_sta->addr, tid,
+	ieee80211_stop_tx_ba_session(hw, temp_sta->sta.addr, tid,
 				     WLAN_BACK_INITIATOR);
 
 timer_expired_exit:
@@ -465,7 +465,7 @@ int ieee80211_start_tx_ba_session(struct
 
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
-						ra, tid, &start_seq_num);
+					       &sta->sta, tid, &start_seq_num);
 
 	if (ret) {
 		/* No need to requeue the packets in the agg queue, since we
@@ -557,7 +557,7 @@ int ieee80211_stop_tx_ba_session(struct 
 
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_STOP,
-						ra, tid, NULL);
+					       &sta->sta, tid, NULL);
 
 	/* case HW denied going back to legacy */
 	if (ret) {
@@ -767,7 +767,7 @@ static void sta_rx_agg_session_timer_exp
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
 #endif
-	ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->addr,
+	ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->sta.addr,
 					 (u16)*ptid, WLAN_BACK_TIMER,
 					 WLAN_REASON_QSTA_TIMEOUT);
 }
@@ -874,7 +874,7 @@ void ieee80211_process_addba_request(str
 
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_START,
-					       sta->addr, tid, &start_seq_num);
+					       &sta->sta, tid, &start_seq_num);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Rx A-MPDU request on tid %d result %d\n", tid, ret);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
@@ -899,7 +899,7 @@ end:
 	spin_unlock_bh(&sta->lock);
 
 end_no_lock:
-	ieee80211_send_addba_resp(sta->sdata, sta->addr, tid,
+	ieee80211_send_addba_resp(sta->sdata, sta->sta.addr, tid,
 				  dialog_token, status, 1, buf_size, timeout);
 }
 
@@ -952,7 +952,7 @@ void ieee80211_process_addba_resp(struct
 		/* this will allow the state check in stop_BA_session */
 		*state = HT_AGG_STATE_OPERATIONAL;
 		spin_unlock_bh(&sta->lock);
-		ieee80211_stop_tx_ba_session(hw, sta->addr, tid,
+		ieee80211_stop_tx_ba_session(hw, sta->sta.addr, tid,
 					     WLAN_BACK_INITIATOR);
 	}
 }
@@ -979,14 +979,14 @@ void ieee80211_process_delba(struct ieee
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	if (initiator == WLAN_BACK_INITIATOR)
-		ieee80211_sta_stop_rx_ba_session(sdata, sta->addr, tid,
+		ieee80211_sta_stop_rx_ba_session(sdata, sta->sta.addr, tid,
 						 WLAN_BACK_INITIATOR, 0);
 	else { /* WLAN_BACK_RECIPIENT */
 		spin_lock_bh(&sta->lock);
 		sta->ampdu_mlme.tid_state_tx[tid] =
 				HT_AGG_STATE_OPERATIONAL;
 		spin_unlock_bh(&sta->lock);
-		ieee80211_stop_tx_ba_session(&local->hw, sta->addr, tid,
+		ieee80211_stop_tx_ba_session(&local->hw, sta->sta.addr, tid,
 					     WLAN_BACK_RECIPIENT);
 	}
 }
--- everything.orig/net/mac80211/iface.c	2008-09-10 23:58:08.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-09-10 23:58:12.000000000 +0200
@@ -336,7 +336,8 @@ static int ieee80211_stop(struct net_dev
 
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
 		if (sta->sdata == sdata)
-			ieee80211_sta_tear_down_BA_sessions(sdata, sta->addr);
+			ieee80211_sta_tear_down_BA_sessions(sdata,
+							    sta->sta.addr);
 	}
 
 	rcu_read_unlock();
--- everything.orig/net/mac80211/key.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/net/mac80211/key.c	2008-09-10 23:58:12.000000000 +0200
@@ -123,7 +123,7 @@ static const u8 *get_mac_for_key(struct 
 		addr = zero_addr;
 
 	if (key->sta)
-		addr = key->sta->addr;
+		addr = key->sta->sta.addr;
 
 	return addr;
 }
--- everything.orig/net/mac80211/mesh_hwmp.c	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/mesh_hwmp.c	2008-09-10 23:58:12.000000000 +0200
@@ -517,7 +517,7 @@ static void hwmp_prep_frame_process(stru
 		spin_unlock_bh(&mpath->state_lock);
 		goto fail;
 	}
-	memcpy(next_hop, mpath->next_hop->addr, ETH_ALEN);
+	memcpy(next_hop, mpath->next_hop->sta.addr, ETH_ALEN);
 	spin_unlock_bh(&mpath->state_lock);
 	--ttl;
 	flags = PREP_IE_FLAGS(prep_elem);
@@ -529,7 +529,7 @@ static void hwmp_prep_frame_process(stru
 
 	mesh_path_sel_frame_tx(MPATH_PREP, flags, orig_addr,
 		cpu_to_le32(orig_dsn), 0, dst_addr,
-		cpu_to_le32(dst_dsn), mpath->next_hop->addr, hopcount, ttl,
+		cpu_to_le32(dst_dsn), mpath->next_hop->sta.addr, hopcount, ttl,
 		cpu_to_le32(lifetime), cpu_to_le32(metric),
 		0, sdata);
 	rcu_read_unlock();
@@ -557,7 +557,7 @@ static void hwmp_perr_frame_process(stru
 	if (mpath) {
 		spin_lock_bh(&mpath->state_lock);
 		if (mpath->flags & MESH_PATH_ACTIVE &&
-		    memcmp(ta, mpath->next_hop->addr, ETH_ALEN) == 0 &&
+		    memcmp(ta, mpath->next_hop->sta.addr, ETH_ALEN) == 0 &&
 		    (!(mpath->flags & MESH_PATH_DSN_VALID) ||
 		    DSN_GT(dst_dsn, mpath->dsn))) {
 			mpath->flags &= ~MESH_PATH_ACTIVE;
@@ -799,7 +799,7 @@ int mesh_nexthop_lookup(struct sk_buff *
 			mesh_queue_preq(mpath,
 					PREQ_Q_F_START | PREQ_Q_F_REFRESH);
 		}
-		memcpy(hdr->addr1, mpath->next_hop->addr,
+		memcpy(hdr->addr1, mpath->next_hop->sta.addr,
 				ETH_ALEN);
 	} else {
 		if (!(mpath->flags & MESH_PATH_RESOLVING)) {
--- everything.orig/net/mac80211/mesh_plink.c	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/mesh_plink.c	2008-09-10 23:58:12.000000000 +0200
@@ -275,7 +275,7 @@ static void mesh_plink_timer(unsigned lo
 		return;
 	}
 	mpl_dbg("Mesh plink timer for %s fired on state %d\n",
-			print_mac(mac, sta->addr), sta->plink_state);
+			print_mac(mac, sta->sta.addr), sta->plink_state);
 	reason = 0;
 	llid = sta->llid;
 	plid = sta->plid;
@@ -288,7 +288,7 @@ static void mesh_plink_timer(unsigned lo
 		if (sta->plink_retries < dot11MeshMaxRetries(sdata)) {
 			u32 rand;
 			mpl_dbg("Mesh plink for %s (retry, timeout): %d %d\n",
-					print_mac(mac, sta->addr),
+					print_mac(mac, sta->sta.addr),
 					sta->plink_retries, sta->plink_timeout);
 			get_random_bytes(&rand, sizeof(u32));
 			sta->plink_timeout = sta->plink_timeout +
@@ -296,7 +296,7 @@ static void mesh_plink_timer(unsigned lo
 			++sta->plink_retries;
 			mod_plink_timer(sta, sta->plink_timeout);
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_OPEN, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_OPEN, sta->sta.addr, llid,
 					    0, 0);
 			break;
 		}
@@ -309,7 +309,7 @@ static void mesh_plink_timer(unsigned lo
 		sta->plink_state = PLINK_HOLDING;
 		mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 		spin_unlock_bh(&sta->lock);
-		mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->addr, llid, plid,
+		mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid, plid,
 				    reason);
 		break;
 	case PLINK_HOLDING:
@@ -352,10 +352,10 @@ int mesh_plink_open(struct sta_info *sta
 	mesh_plink_timer_set(sta, dot11MeshRetryTimeout(sdata));
 	spin_unlock_bh(&sta->lock);
 	mpl_dbg("Mesh plink: starting establishment with %s\n",
-		print_mac(mac, sta->addr));
+		print_mac(mac, sta->sta.addr));
 
 	return mesh_plink_frame_tx(sdata, PLINK_OPEN,
-				   sta->addr, llid, 0, 0);
+				   sta->sta.addr, llid, 0, 0);
 }
 
 void mesh_plink_block(struct sta_info *sta)
@@ -379,7 +379,7 @@ int mesh_plink_close(struct sta_info *st
 #endif
 
 	mpl_dbg("Mesh plink: closing link with %s\n",
-			print_mac(mac, sta->addr));
+			print_mac(mac, sta->sta.addr));
 	spin_lock_bh(&sta->lock);
 	sta->reason = cpu_to_le16(MESH_LINK_CANCELLED);
 	reason = sta->reason;
@@ -400,7 +400,7 @@ int mesh_plink_close(struct sta_info *st
 	llid = sta->llid;
 	plid = sta->plid;
 	spin_unlock_bh(&sta->lock);
-	mesh_plink_frame_tx(sta->sdata, PLINK_CLOSE, sta->addr, llid,
+	mesh_plink_frame_tx(sta->sdata, PLINK_CLOSE, sta->sta.addr, llid,
 			    plid, reason);
 	return 0;
 }
@@ -577,9 +577,9 @@ void mesh_rx_plink_frame(struct ieee8021
 			sta->llid = llid;
 			mesh_plink_timer_set(sta, dot11MeshRetryTimeout(sdata));
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_OPEN, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_OPEN, sta->sta.addr, llid,
 					    0, 0);
-			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->addr,
+			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->sta.addr,
 					    llid, plid, 0);
 			break;
 		default:
@@ -604,7 +604,7 @@ void mesh_rx_plink_frame(struct ieee8021
 
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid,
 					    plid, reason);
 			break;
 		case OPN_ACPT:
@@ -613,7 +613,7 @@ void mesh_rx_plink_frame(struct ieee8021
 			sta->plid = plid;
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->sta.addr, llid,
 					    plid, 0);
 			break;
 		case CNF_ACPT:
@@ -646,13 +646,13 @@ void mesh_rx_plink_frame(struct ieee8021
 
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid,
 					    plid, reason);
 			break;
 		case OPN_ACPT:
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->sta.addr, llid,
 					    plid, 0);
 			break;
 		case CNF_ACPT:
@@ -661,7 +661,7 @@ void mesh_rx_plink_frame(struct ieee8021
 			mesh_plink_inc_estab_count(sdata);
 			spin_unlock_bh(&sta->lock);
 			mpl_dbg("Mesh plink with %s ESTABLISHED\n",
-					print_mac(mac, sta->addr));
+					print_mac(mac, sta->sta.addr));
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
@@ -685,7 +685,7 @@ void mesh_rx_plink_frame(struct ieee8021
 
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid,
 					    plid, reason);
 			break;
 		case OPN_ACPT:
@@ -694,8 +694,8 @@ void mesh_rx_plink_frame(struct ieee8021
 			mesh_plink_inc_estab_count(sdata);
 			spin_unlock_bh(&sta->lock);
 			mpl_dbg("Mesh plink with %s ESTABLISHED\n",
-					print_mac(mac, sta->addr));
-			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->addr, llid,
+					print_mac(mac, sta->sta.addr));
+			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->sta.addr, llid,
 					    plid, 0);
 			break;
 		default:
@@ -714,13 +714,13 @@ void mesh_rx_plink_frame(struct ieee8021
 			llid = sta->llid;
 			mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr, llid,
 					    plid, reason);
 			break;
 		case OPN_ACPT:
 			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->addr, llid,
+			mesh_plink_frame_tx(sdata, PLINK_CONFIRM, sta->sta.addr, llid,
 					    plid, 0);
 			break;
 		default:
@@ -743,8 +743,8 @@ void mesh_rx_plink_frame(struct ieee8021
 			llid = sta->llid;
 			reason = sta->reason;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->addr, llid,
-					    plid, reason);
+			mesh_plink_frame_tx(sdata, PLINK_CLOSE, sta->sta.addr,
+					    llid, plid, reason);
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
--- everything.orig/net/mac80211/mlme.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-10 23:58:12.000000000 +0200
@@ -835,7 +835,7 @@ static void ieee80211_set_disassoc(struc
 	netif_tx_stop_all_queues(sdata->dev);
 	netif_carrier_off(sdata->dev);
 
-	ieee80211_sta_tear_down_BA_sessions(sdata, sta->addr);
+	ieee80211_sta_tear_down_BA_sessions(sdata, sta->sta.addr);
 
 	if (self_disconnected) {
 		if (deauth)
--- everything.orig/net/mac80211/rx.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-09-10 23:58:12.000000000 +0200
@@ -661,7 +661,7 @@ static void ap_sta_ps_start(struct net_d
 	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
-	       dev->name, print_mac(mac, sta->addr), sta->aid);
+	       dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 }
 
@@ -685,7 +685,7 @@ static int ap_sta_ps_end(struct net_devi
 
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d exits power save mode\n",
-	       dev->name, print_mac(mac, sta->addr), sta->aid);
+	       dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 
 	/* Send all buffered frames to the station */
@@ -702,7 +702,7 @@ static int ap_sta_ps_end(struct net_devi
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "%s: STA %s aid %d send PS frame "
 		       "since STA not sleeping anymore\n", dev->name,
-		       print_mac(mac, sta->addr), sta->aid);
+		       print_mac(mac, sta->sta.addr), sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 		info->flags |= IEEE80211_TX_CTL_REQUEUE;
 		dev_queue_xmit(skb);
@@ -1007,7 +1007,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "STA %s aid %d: PS Poll (entries after %d)\n",
-		       print_mac(mac, rx->sta->addr), rx->sta->aid,
+		       print_mac(mac, rx->sta->sta.addr), rx->sta->sta.aid,
 		       skb_queue_len(&rx->sta->ps_tx_buf));
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 
@@ -1032,7 +1032,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 		 */
 		printk(KERN_DEBUG "%s: STA %s sent PS Poll even "
 		       "though there are no buffered frames for it\n",
-		       rx->dev->name, print_mac(mac, rx->sta->addr));
+		       rx->dev->name, print_mac(mac, rx->sta->sta.addr));
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 	}
 
@@ -2140,7 +2140,7 @@ static u8 ieee80211_rx_reorder_ampdu(str
 	/* if this mpdu is fragmented - terminate rx aggregation session */
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	if (sc & IEEE80211_SCTL_FRAG) {
-		ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->addr,
+		ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->sta.addr,
 			tid, 0, WLAN_REASON_QSTA_REQUIRE_SETUP);
 		ret = 1;
 		goto end_reorder;
--- everything.orig/net/mac80211/tkip.c	2008-09-10 23:50:17.000000000 +0200
+++ everything/net/mac80211/tkip.c	2008-09-10 23:58:12.000000000 +0200
@@ -304,7 +304,7 @@ int ieee80211_tkip_decrypt_data(struct c
 			key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 			u8 bcast[ETH_ALEN] =
 				{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-			u8 *sta_addr = key->sta->addr;
+			u8 *sta_addr = key->sta->sta.addr;
 
 			if (is_multicast_ether_addr(ra))
 				sta_addr = bcast;
--- everything.orig/net/mac80211/tx.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-10 23:58:12.000000000 +0200
@@ -381,7 +381,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "STA %s aid %d: PS buffer (entries "
 		       "before %d)\n",
-		       print_mac(mac, sta->addr), sta->aid,
+		       print_mac(mac, sta->sta.addr), sta->sta.aid,
 		       skb_queue_len(&sta->ps_tx_buf));
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
@@ -392,7 +392,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 			if (net_ratelimit()) {
 				printk(KERN_DEBUG "%s: STA %s TX "
 				       "buffer full - dropping oldest frame\n",
-				       tx->dev->name, print_mac(mac, sta->addr));
+				       tx->dev->name, print_mac(mac, sta->sta.addr));
 			}
 #endif
 			dev_kfree_skb(old);
@@ -411,7 +411,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 	else if (unlikely(test_sta_flags(sta, WLAN_STA_PS))) {
 		printk(KERN_DEBUG "%s: STA %s in PS mode, but pspoll "
 		       "set -> send frame\n", tx->dev->name,
-		       print_mac(mac, sta->addr));
+		       print_mac(mac, sta->sta.addr));
 	}
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 	clear_sta_flags(sta, WLAN_STA_PSPOLL);
@@ -528,7 +528,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
 	if (tx->sta)
-		info->control.aid = tx->sta->aid;
+		info->control.sta = &tx->sta->sta;
 
 	if (!info->control.retry_limit) {
 		if (!is_multicast_ether_addr(hdr->addr1)) {
@@ -608,7 +608,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 	}
 
 	if (tx->sta)
-		info->control.aid = tx->sta->aid;
+		info->control.sta = &tx->sta->sta;
 
 	return TX_CONTINUE;
 }
--- everything.orig/net/mac80211/wme.c	2008-09-10 23:50:17.000000000 +0200
+++ everything/net/mac80211/wme.c	2008-09-10 23:58:12.000000000 +0200
@@ -210,7 +210,7 @@ int ieee80211_ht_agg_queue_add(struct ie
 				DECLARE_MAC_BUF(mac);
 				printk(KERN_DEBUG "allocated aggregation queue"
 					" %d tid %d addr %s pool=0x%lX\n",
-					i, tid, print_mac(mac, sta->addr),
+					i, tid, print_mac(mac, sta->sta.addr),
 					local->queue_pool[0]);
 			}
 #endif /* CONFIG_MAC80211_HT_DEBUG */
--- everything.orig/net/mac80211/wpa.c	2008-09-10 23:50:17.000000000 +0200
+++ everything/net/mac80211/wpa.c	2008-09-10 23:58:12.000000000 +0200
@@ -256,7 +256,7 @@ ieee80211_crypto_tkip_decrypt(struct iee
 
 	res = ieee80211_tkip_decrypt_data(rx->local->wep_rx_tfm,
 					  key, skb->data + hdrlen,
-					  skb->len - hdrlen, rx->sta->addr,
+					  skb->len - hdrlen, rx->sta->sta.addr,
 					  hdr->addr1, hwaccel, rx->queue,
 					  &rx->tkip_iv32,
 					  &rx->tkip_iv16);
--- everything.orig/drivers/net/wireless/b43/main.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/drivers/net/wireless/b43/main.c	2008-09-10 23:58:12.000000000 +0200
@@ -4234,7 +4234,8 @@ out_unlock:
 	return err;
 }
 
-static int b43_op_beacon_set_tim(struct ieee80211_hw *hw, int aid, int set)
+static int b43_op_beacon_set_tim(struct ieee80211_hw *hw,
+				 struct ieee80211_sta *sta, bool set)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	unsigned long flags;
@@ -4249,7 +4250,7 @@ static int b43_op_beacon_set_tim(struct 
 static void b43_op_sta_notify(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      enum sta_notify_cmd notify_cmd,
-			      const u8 *addr)
+			      struct ieee80211_sta *sta)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 
--- everything.orig/drivers/net/wireless/b43legacy/main.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/main.c	2008-09-10 23:58:12.000000000 +0200
@@ -3403,7 +3403,7 @@ out_unlock:
 }
 
 static int b43legacy_op_beacon_set_tim(struct ieee80211_hw *hw,
-				       int aid, int set)
+				       struct ieee80211_sta *sta, bool set)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	unsigned long flags;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-10 23:58:12.000000000 +0200
@@ -366,8 +366,8 @@ static void rs_tl_turn_on_agg_for_tid(st
 	if (state == HT_AGG_STATE_IDLE &&
 	    rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {
 		IWL_DEBUG_HT("Starting Tx agg: STA: %s tid: %d\n",
-				print_mac(mac, sta->addr), tid);
-		ieee80211_start_tx_ba_session(priv->hw, sta->addr, tid);
+				print_mac(mac, sta->sta.addr), tid);
+		ieee80211_start_tx_ba_session(priv->hw, sta->sta.addr, tid);
 	}
 }
 
@@ -2244,17 +2244,17 @@ static void rs_rate_init(void *priv_rate
 
 	lq_sta->ibss_sta_added = 0;
 	if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		u8 sta_id = iwl_find_station(priv, sta->addr);
+		u8 sta_id = iwl_find_station(priv, sta->sta.addr);
 		DECLARE_MAC_BUF(mac);
 
 		/* for IBSS the call are from tasklet */
 		IWL_DEBUG_RATE("LQ: ADD station %s\n",
-			     print_mac(mac, sta->addr));
+			     print_mac(mac, sta->sta.addr));
 
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_RATE("LQ: ADD station %s\n",
-				       print_mac(mac, sta->addr));
-			sta_id = iwl_add_station_flags(priv, sta->addr,
+				       print_mac(mac, sta->sta.addr));
+			sta_id = iwl_add_station_flags(priv, sta->sta.addr,
 							0, CMD_ASYNC, NULL);
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
--- everything.orig/drivers/net/wireless/mac80211_hwsim.c	2008-09-10 23:58:11.000000000 +0200
+++ everything/drivers/net/wireless/mac80211_hwsim.c	2008-09-10 23:58:12.000000000 +0200
@@ -390,7 +390,8 @@ static void mac80211_hwsim_bss_info_chan
 
 static void mac80211_hwsim_sta_notify(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
-				      enum sta_notify_cmd cmd, const u8 *addr)
+				      enum sta_notify_cmd cmd,
+				      struct ieee80211_sta *sta)
 {
 	hwsim_check_magic(vif);
 }
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-09-10 23:58:12.000000000 +0200
@@ -3413,13 +3413,13 @@ static int iwl4965_mac_conf_tx(struct ie
 
 static int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 			     enum ieee80211_ampdu_mlme_action action,
-			     const u8 *addr, u16 tid, u16 *ssn)
+			     struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
 	struct iwl_priv *priv = hw->priv;
 	DECLARE_MAC_BUF(mac);
 
 	IWL_DEBUG_HT("A-MPDU action on addr %s tid %d\n",
-		     print_mac(mac, addr), tid);
+		     print_mac(mac, sta->addr), tid);
 
 	if (!(priv->cfg->sku & IWL_SKU_N))
 		return -EACCES;
@@ -3427,16 +3427,16 @@ static int iwl4965_mac_ampdu_action(stru
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		IWL_DEBUG_HT("start Rx\n");
-		return iwl_rx_agg_start(priv, addr, tid, *ssn);
+		return iwl_rx_agg_start(priv, sta->addr, tid, *ssn);
 	case IEEE80211_AMPDU_RX_STOP:
 		IWL_DEBUG_HT("stop Rx\n");
-		return iwl_rx_agg_stop(priv, addr, tid);
+		return iwl_rx_agg_stop(priv, sta->addr, tid);
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT("start Tx\n");
-		return iwl_tx_agg_start(priv, addr, tid, ssn);
+		return iwl_tx_agg_start(priv, sta->addr, tid, ssn);
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT("stop Tx\n");
-		return iwl_tx_agg_stop(priv, addr, tid);
+		return iwl_tx_agg_stop(priv, sta->addr, tid);
 	default:
 		IWL_DEBUG_HT("unknown\n");
 		return -EINVAL;
--- everything.orig/drivers/net/wireless/ath9k/main.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/drivers/net/wireless/ath9k/main.c	2008-09-10 23:58:12.000000000 +0200
@@ -686,7 +686,7 @@ static void ath9k_configure_filter(struc
 static void ath9k_sta_notify(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     enum sta_notify_cmd cmd,
-			     const u8 *addr)
+			     struct ieee80211_sta *sta)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_node *an;
@@ -694,19 +694,18 @@ static void ath9k_sta_notify(struct ieee
 	DECLARE_MAC_BUF(mac);
 
 	spin_lock_irqsave(&sc->node_lock, flags);
-	an = ath_node_find(sc, (u8 *) addr);
+	an = ath_node_find(sc, sta->addr);
 	spin_unlock_irqrestore(&sc->node_lock, flags);
 
 	switch (cmd) {
 	case STA_NOTIFY_ADD:
 		spin_lock_irqsave(&sc->node_lock, flags);
 		if (!an) {
-			ath_node_attach(sc, (u8 *)addr, 0);
+			ath_node_attach(sc, sta->addr, 0);
 			DPRINTF(sc, ATH_DBG_CONFIG, "%s: Attach a node: %s\n",
-				__func__,
-				print_mac(mac, addr));
+				__func__, print_mac(mac, sta->addr));
 		} else {
-			ath_node_get(sc, (u8 *)addr);
+			ath_node_get(sc, sta->addr);
 		}
 		spin_unlock_irqrestore(&sc->node_lock, flags);
 		break;
@@ -719,7 +718,7 @@ static void ath9k_sta_notify(struct ieee
 			ath_node_put(sc, an, ATH9K_BH_STATUS_INTACT);
 			DPRINTF(sc, ATH_DBG_CONFIG, "%s: Put a node: %s\n",
 				__func__,
-				print_mac(mac, addr));
+				print_mac(mac, sta->addr));
 		}
 		break;
 	default:
@@ -973,45 +972,44 @@ static void ath9k_reset_tsf(struct ieee8
 
 static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 		       enum ieee80211_ampdu_mlme_action action,
-		       const u8 *addr,
-		       u16 tid,
-		       u16 *ssn)
+		       struct ieee80211_sta *sta,
+		       u16 tid, u16 *ssn)
 {
 	struct ath_softc *sc = hw->priv;
 	int ret = 0;
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		ret = ath_rx_aggr_start(sc, addr, tid, ssn);
+		ret = ath_rx_aggr_start(sc, sta->addr, tid, ssn);
 		if (ret < 0)
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to start RX aggregation\n",
 				__func__);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
-		ret = ath_rx_aggr_stop(sc, addr, tid);
+		ret = ath_rx_aggr_stop(sc, sta->addr, tid);
 		if (ret < 0)
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to stop RX aggregation\n",
 				__func__);
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		ret = ath_tx_aggr_start(sc, addr, tid, ssn);
+		ret = ath_tx_aggr_start(sc, sta->addr, tid, ssn);
 		if (ret < 0)
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to start TX aggregation\n",
 				__func__);
 		else
-			ieee80211_start_tx_ba_cb_irqsafe(hw, (u8 *)addr, tid);
+			ieee80211_start_tx_ba_cb_irqsafe(hw, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
-		ret = ath_tx_aggr_stop(sc, addr, tid);
+		ret = ath_tx_aggr_stop(sc, sta->addr, tid);
 		if (ret < 0)
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to stop TX aggregation\n",
 				__func__);
 
-		ieee80211_stop_tx_ba_cb_irqsafe(hw, (u8 *)addr, tid);
+		ieee80211_stop_tx_ba_cb_irqsafe(hw, sta->addr, tid);
 		break;
 	default:
 		DPRINTF(sc, ATH_DBG_FATAL,

-- 

