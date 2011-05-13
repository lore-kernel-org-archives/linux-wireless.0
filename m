Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab1EMMPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 08:15:52 -0400
Subject: [PATCH] mac80211: sparse RCU annotations
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 14:15:49 +0200
Message-ID: <1305288949.3487.17.camel@jlt3.sipsolutions.net> (sfid-20110513_141556_686251_6D64E37B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This adds sparse RCU annotations to most of
mac80211, only the mesh code remains to be
done.

Due the the previous patches, the annotations
are pretty simple. The only thing that this
actually changes is removing the RCU usage of
key->sta in debugfs since this pointer isn't
actually an RCU-managed pointer (it only has
a single assignment done before the key even
goes live). As that is otherwise harmless, I
decided to make it part of this patch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c      |    3 ++-
 net/mac80211/agg-tx.c      |   36 +++++++++++++++++++++---------------
 net/mac80211/cfg.c         |   17 +++++++----------
 net/mac80211/debugfs_key.c |   21 +++++++++------------
 net/mac80211/ht.c          |    2 +-
 net/mac80211/ibss.c        |   11 ++++++++---
 net/mac80211/ieee80211_i.h |   16 +++++++++-------
 net/mac80211/iface.c       |    3 ++-
 net/mac80211/key.c         |   22 ++++++++++++++--------
 net/mac80211/key.h         |    3 +++
 net/mac80211/main.c        |    2 ++
 net/mac80211/mesh.h        |    2 +-
 net/mac80211/mesh_hwmp.c   |   20 +++++++++++++++++---
 net/mac80211/sta_info.c    |   15 +++++++++------
 net/mac80211/sta_info.h    |   17 ++++++++++++-----
 net/mac80211/tx.c          |    2 +-
 16 files changed, 118 insertions(+), 74 deletions(-)

--- a/net/mac80211/agg-rx.c	2011-05-13 13:40:22.000000000 +0200
+++ b/net/mac80211/agg-rx.c	2011-05-13 13:40:29.000000000 +0200
@@ -63,7 +63,8 @@ void ___ieee80211_stop_rx_ba_session(str
 
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
-	tid_rx = sta->ampdu_mlme.tid_rx[tid];
+	tid_rx = rcu_dereference_protected(sta->ampdu_mlme.tid_rx[tid],
+					lockdep_is_held(&sta->ampdu_mlme.mtx));
 
 	if (!tid_rx)
 		return;
--- a/net/mac80211/agg-tx.c	2011-05-13 13:40:28.000000000 +0200
+++ b/net/mac80211/agg-tx.c	2011-05-13 13:40:29.000000000 +0200
@@ -157,16 +157,19 @@ int ___ieee80211_stop_tx_ba_session(stru
 				    bool tx)
 {
 	struct ieee80211_local *local = sta->local;
-	struct tid_ampdu_tx *tid_tx = sta->ampdu_mlme.tid_tx[tid];
+	struct tid_ampdu_tx *tid_tx;
 	int ret;
 
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
-	if (!tid_tx)
-		return -ENOENT;
-
 	spin_lock_bh(&sta->lock);
 
+	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+	if (!tid_tx) {
+		spin_unlock_bh(&sta->lock);
+		return -ENOENT;
+	}
+
 	if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/* not even started yet! */
 		ieee80211_assign_tid_tx(sta, tid, NULL);
@@ -291,13 +294,13 @@ ieee80211_wake_queue_agg(struct ieee8021
 
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
-	struct tid_ampdu_tx *tid_tx = sta->ampdu_mlme.tid_tx[tid];
+	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u16 start_seq_num;
 	int ret;
 
-	lockdep_assert_held(&sta->ampdu_mlme.mtx);
+	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
 	/*
 	 * While we're asking the driver about the aggregation,
@@ -404,7 +407,7 @@ int ieee80211_start_tx_ba_session(struct
 		goto err_unlock_sta;
 	}
 
-	tid_tx = sta->ampdu_mlme.tid_tx[tid];
+	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 	/* check if the TID is not in aggregation flow already */
 	if (tid_tx || sta->ampdu_mlme.tid_start_tx[tid]) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -491,16 +494,19 @@ ieee80211_agg_splice_finish(struct ieee8
 static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 					 struct sta_info *sta, u16 tid)
 {
+	struct tid_ampdu_tx *tid_tx;
+
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
+	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Aggregation is on for tid %d\n", tid);
 #endif
 
 	drv_ampdu_action(local, sta->sdata,
 			 IEEE80211_AMPDU_TX_OPERATIONAL,
-			 &sta->sta, tid, NULL,
-			 sta->ampdu_mlme.tid_tx[tid]->buf_size);
+			 &sta->sta, tid, NULL, tid_tx->buf_size);
 
 	/*
 	 * synchronize with TX path, while splicing the TX path
@@ -508,13 +514,13 @@ static void ieee80211_agg_tx_operational
 	 */
 	spin_lock_bh(&sta->lock);
 
-	ieee80211_agg_splice_packets(local, sta->ampdu_mlme.tid_tx[tid], tid);
+	ieee80211_agg_splice_packets(local, tid_tx, tid);
 	/*
 	 * Now mark as operational. This will be visible
 	 * in the TX path, and lets it go lock-free in
 	 * the common case.
 	 */
-	set_bit(HT_AGG_STATE_OPERATIONAL, &sta->ampdu_mlme.tid_tx[tid]->state);
+	set_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state);
 	ieee80211_agg_splice_finish(local, tid);
 
 	spin_unlock_bh(&sta->lock);
@@ -548,7 +554,7 @@ void ieee80211_start_tx_ba_cb(struct iee
 	}
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
-	tid_tx = sta->ampdu_mlme.tid_tx[tid];
+	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
 	if (WARN_ON(!tid_tx)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -626,7 +632,7 @@ int ieee80211_stop_tx_ba_session(struct
 		return -EINVAL;
 
 	spin_lock_bh(&sta->lock);
-	tid_tx = sta->ampdu_mlme.tid_tx[tid];
+	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
 	if (!tid_tx) {
 		ret = -ENOENT;
@@ -682,7 +688,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
 	spin_lock_bh(&sta->lock);
-	tid_tx = sta->ampdu_mlme.tid_tx[tid];
+	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 
 	if (!tid_tx || !test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -763,7 +769,7 @@ void ieee80211_process_addba_resp(struct
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
 
-	tid_tx = sta->ampdu_mlme.tid_tx[tid];
+	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 	if (!tid_tx)
 		goto out;
 
--- a/net/mac80211/cfg.c	2011-05-13 13:40:22.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-05-13 13:40:29.000000000 +0200
@@ -177,11 +177,11 @@ static int ieee80211_del_key(struct wiph
 			goto out_unlock;
 
 		if (pairwise)
-			key = sta->ptk;
+			key = key_mtx_dereference(local, sta->ptk);
 		else
-			key = sta->gtk[key_idx];
+			key = key_mtx_dereference(local, sta->gtk[key_idx]);
 	} else
-		key = sdata->keys[key_idx];
+		key = key_mtx_dereference(local, sdata->keys[key_idx]);
 
 	if (!key) {
 		ret = -ENOENT;
@@ -463,7 +463,7 @@ static int ieee80211_config_beacon(struc
 	int size;
 	int err = -EINVAL;
 
-	old = sdata->u.ap.beacon;
+	old = rtnl_dereference(sdata->u.ap.beacon);
 
 	/* head must not be zero-length */
 	if (params->head && !params->head_len)
@@ -558,8 +558,7 @@ static int ieee80211_add_beacon(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	old = sdata->u.ap.beacon;
-
+	old = rtnl_dereference(sdata->u.ap.beacon);
 	if (old)
 		return -EALREADY;
 
@@ -574,8 +573,7 @@ static int ieee80211_set_beacon(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	old = sdata->u.ap.beacon;
-
+	old = rtnl_dereference(sdata->u.ap.beacon);
 	if (!old)
 		return -ENOENT;
 
@@ -589,8 +587,7 @@ static int ieee80211_del_beacon(struct w
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	old = sdata->u.ap.beacon;
-
+	old = rtnl_dereference(sdata->u.ap.beacon);
 	if (!old)
 		return -ENOENT;
 
--- a/net/mac80211/ieee80211_i.h	2011-05-13 13:40:23.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-05-13 13:40:29.000000000 +0200
@@ -214,7 +214,7 @@ struct beacon_data {
 };
 
 struct ieee80211_if_ap {
-	struct beacon_data *beacon;
+	struct beacon_data __rcu *beacon;
 
 	struct list_head vlans;
 
@@ -237,7 +237,7 @@ struct ieee80211_if_vlan {
 	struct list_head list;
 
 	/* used for all tx if the VLAN is configured to 4-addr mode */
-	struct sta_info *sta;
+	struct sta_info __rcu *sta;
 };
 
 struct mesh_stats {
@@ -442,7 +442,8 @@ struct ieee80211_if_ibss {
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
-	struct sk_buff *presp, *skb;
+	struct sk_buff __rcu *presp;
+	struct sk_buff *skb;
 
 	enum {
 		IEEE80211_IBSS_MLME_SEARCH,
@@ -567,9 +568,10 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
 
-	struct ieee80211_key *keys[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
-	struct ieee80211_key *default_unicast_key, *default_multicast_key;
-	struct ieee80211_key *default_mgmt_key;
+	struct ieee80211_key __rcu *keys[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
+	struct ieee80211_key __rcu *default_unicast_key;
+	struct ieee80211_key __rcu *default_multicast_key;
+	struct ieee80211_key __rcu *default_mgmt_key;
 
 	u16 sequence_number;
 	__be16 control_port_protocol;
@@ -805,7 +807,7 @@ struct ieee80211_local {
 	spinlock_t sta_lock;
 	unsigned long num_sta;
 	struct list_head sta_list, sta_pending_list;
-	struct sta_info *sta_hash[STA_HASH_SIZE];
+	struct sta_info __rcu *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 	struct work_struct sta_finish_work;
 	int sta_generation;
--- a/net/mac80211/iface.c	2011-05-13 13:40:21.000000000 +0200
+++ b/net/mac80211/iface.c	2011-05-13 13:40:29.000000000 +0200
@@ -449,7 +449,8 @@ static void ieee80211_do_stop(struct iee
 	/* APs need special treatment */
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		struct ieee80211_sub_if_data *vlan, *tmpsdata;
-		struct beacon_data *old_beacon = sdata->u.ap.beacon;
+		struct beacon_data *old_beacon =
+			rtnl_dereference(sdata->u.ap.beacon);
 
 		/* sdata_running will return false, so this will disable */
 		ieee80211_bss_info_change_notify(sdata,
--- a/net/mac80211/mesh.h	2011-05-13 13:40:21.000000000 +0200
+++ b/net/mac80211/mesh.h	2011-05-13 13:40:29.000000000 +0200
@@ -92,7 +92,7 @@ struct mesh_path {
 	u8 dst[ETH_ALEN];
 	u8 mpp[ETH_ALEN];	/* used for MPP or MAP */
 	struct ieee80211_sub_if_data *sdata;
-	struct sta_info *next_hop;
+	struct sta_info __rcu *next_hop;
 	struct timer_list timer;
 	struct sk_buff_head frame_queue;
 	struct rcu_head rcu;
--- a/net/mac80211/sta_info.c	2011-05-13 13:40:21.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-05-13 13:40:29.000000000 +0200
@@ -67,7 +67,8 @@ static int sta_info_hash_del(struct ieee
 {
 	struct sta_info *s;
 
-	s = local->sta_hash[STA_HASH(sta->sta.addr)];
+	s = rcu_dereference_protected(local->sta_hash[STA_HASH(sta->sta.addr)],
+				      lockdep_is_held(&local->sta_lock));
 	if (!s)
 		return -ENOENT;
 	if (s == sta) {
@@ -76,9 +77,11 @@ static int sta_info_hash_del(struct ieee
 		return 0;
 	}
 
-	while (s->hnext && s->hnext != sta)
-		s = s->hnext;
-	if (s->hnext) {
+	while (rcu_access_pointer(s->hnext) &&
+	       rcu_access_pointer(s->hnext) != sta)
+		s = rcu_dereference_protected(s->hnext,
+					lockdep_is_held(&local->sta_lock));
+	if (rcu_access_pointer(s->hnext)) {
 		rcu_assign_pointer(s->hnext, sta->hnext);
 		return 0;
 	}
@@ -654,9 +657,9 @@ static int __must_check __sta_info_destr
 
 	mutex_lock(&local->key_mtx);
 	for (i = 0; i < NUM_DEFAULT_KEYS; i++)
-		__ieee80211_key_free(sta->gtk[i]);
+		__ieee80211_key_free(key_mtx_dereference(local, sta->gtk[i]));
 	if (sta->ptk)
-		__ieee80211_key_free(sta->ptk);
+		__ieee80211_key_free(key_mtx_dereference(local, sta->ptk));
 	mutex_unlock(&local->key_mtx);
 
 	sta->dead = true;
--- a/net/mac80211/sta_info.h	2011-05-13 13:40:28.000000000 +0200
+++ b/net/mac80211/sta_info.h	2011-05-13 13:40:29.000000000 +0200
@@ -164,11 +164,11 @@ struct tid_ampdu_rx {
 struct sta_ampdu_mlme {
 	struct mutex mtx;
 	/* rx */
-	struct tid_ampdu_rx *tid_rx[STA_TID_NUM];
+	struct tid_ampdu_rx __rcu *tid_rx[STA_TID_NUM];
 	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(STA_TID_NUM)];
 	/* tx */
 	struct work_struct work;
-	struct tid_ampdu_tx *tid_tx[STA_TID_NUM];
+	struct tid_ampdu_tx __rcu *tid_tx[STA_TID_NUM];
 	struct tid_ampdu_tx *tid_start_tx[STA_TID_NUM];
 	u8 addba_req_num[STA_TID_NUM];
 	u8 dialog_token_allocator;
@@ -243,11 +243,11 @@ struct sta_ampdu_mlme {
 struct sta_info {
 	/* General information, mostly static */
 	struct list_head list;
-	struct sta_info *hnext;
+	struct sta_info __rcu *hnext;
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_key *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
-	struct ieee80211_key *ptk;
+	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
+	struct ieee80211_key __rcu *ptk;
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
 	spinlock_t lock;
@@ -403,6 +403,13 @@ static inline u32 get_sta_flags(struct s
 void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
 			     struct tid_ampdu_tx *tid_tx);
 
+static inline struct tid_ampdu_tx *
+rcu_dereference_protected_tid_tx(struct sta_info *sta, int tid)
+{
+	return rcu_dereference_protected(sta->ampdu_mlme.tid_tx[tid],
+					 lockdep_is_held(&sta->lock) ||
+					 lockdep_is_held(&sta->ampdu_mlme.mtx));
+}
 
 #define STA_HASH_SIZE 256
 #define STA_HASH(sta) (sta[5])
--- a/net/mac80211/ibss.c	2011-05-13 13:40:22.000000000 +0200
+++ b/net/mac80211/ibss.c	2011-05-13 13:40:29.000000000 +0200
@@ -662,12 +662,16 @@ static void ieee80211_rx_mgmt_probe_req(
 	int tx_last_beacon, len = req->len;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *resp;
+	struct sk_buff *presp;
 	u8 *pos, *end;
 
 	lockdep_assert_held(&ifibss->mtx);
 
+	presp = rcu_dereference_protected(ifibss->presp,
+					  lockdep_is_held(&ifibss->mtx));
+
 	if (ifibss->state != IEEE80211_IBSS_MLME_JOINED ||
-	    len < 24 + 2 || !ifibss->presp)
+	    len < 24 + 2 || !presp)
 		return;
 
 	tx_last_beacon = drv_tx_last_beacon(local);
@@ -705,7 +709,7 @@ static void ieee80211_rx_mgmt_probe_req(
 	}
 
 	/* Reply with ProbeResp */
-	skb = skb_copy(ifibss->presp, GFP_KERNEL);
+	skb = skb_copy(presp, GFP_KERNEL);
 	if (!skb)
 		return;
 
@@ -985,7 +989,8 @@ int ieee80211_ibss_leave(struct ieee8021
 
 	/* remove beacon */
 	kfree(sdata->u.ibss.ie);
-	skb = sdata->u.ibss.presp;
+	skb = rcu_dereference_protected(sdata->u.ibss.presp,
+					lockdep_is_held(&sdata->u.ibss.mtx));
 	rcu_assign_pointer(sdata->u.ibss.presp, NULL);
 	sdata->vif.bss_conf.ibss_joined = false;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
--- a/net/mac80211/tx.c	2011-05-13 13:40:22.000000000 +0200
+++ b/net/mac80211/tx.c	2011-05-13 13:40:29.000000000 +0200
@@ -1151,7 +1151,7 @@ static bool ieee80211_tx_prep_agg(struct
 		 *     packet pass through because splicing the frames
 		 *     back is already done.
 		 */
-		tid_tx = tx->sta->ampdu_mlme.tid_tx[tid];
+		tid_tx = rcu_dereference_protected_tid_tx(tx->sta, tid);
 
 		if (!tid_tx) {
 			/* do nothing, let packet pass through */
--- a/net/mac80211/main.c	2011-05-13 13:40:21.000000000 +0200
+++ b/net/mac80211/main.c	2011-05-13 13:40:29.000000000 +0200
@@ -871,8 +871,10 @@ int ieee80211_register_hw(struct ieee802
 	 * and we need some headroom for passing the frame to monitor
 	 * interfaces, but never both at the same time.
 	 */
+#ifndef __CHECKER__
 	BUILD_BUG_ON(IEEE80211_TX_STATUS_HEADROOM !=
 			sizeof(struct ieee80211_tx_status_rtap_hdr));
+#endif
 	local->tx_headroom = max_t(unsigned int , local->hw.extra_tx_headroom,
 				   sizeof(struct ieee80211_tx_status_rtap_hdr));
 
--- a/net/mac80211/mesh_hwmp.c	2011-05-13 13:40:21.000000000 +0200
+++ b/net/mac80211/mesh_hwmp.c	2011-05-13 13:40:29.000000000 +0200
@@ -560,6 +560,14 @@ static void hwmp_preq_frame_process(stru
 }
 
 
+static inline struct sta_info *
+next_hop_deref_protected(struct mesh_path *mpath)
+{
+	return rcu_dereference_protected(mpath->next_hop,
+					 lockdep_is_held(&mpath->state_lock));
+}
+
+
 static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
 				    u8 *prep_elem, u32 metric)
@@ -599,7 +607,7 @@ static void hwmp_prep_frame_process(stru
 		spin_unlock_bh(&mpath->state_lock);
 		goto fail;
 	}
-	memcpy(next_hop, mpath->next_hop->sta.addr, ETH_ALEN);
+	memcpy(next_hop, next_hop_deref_protected(mpath)->sta.addr, ETH_ALEN);
 	spin_unlock_bh(&mpath->state_lock);
 	--ttl;
 	flags = PREP_IE_FLAGS(prep_elem);
@@ -651,7 +659,8 @@ static void hwmp_perr_frame_process(stru
 	if (mpath) {
 		spin_lock_bh(&mpath->state_lock);
 		if (mpath->flags & MESH_PATH_ACTIVE &&
-		    memcmp(ta, mpath->next_hop->sta.addr, ETH_ALEN) == 0 &&
+		    memcmp(ta, next_hop_deref_protected(mpath)->sta.addr,
+							ETH_ALEN) == 0 &&
 		    (!(mpath->flags & MESH_PATH_SN_VALID) ||
 		    SN_GT(target_sn, mpath->sn))) {
 			mpath->flags &= ~MESH_PATH_ACTIVE;
@@ -913,6 +922,7 @@ int mesh_nexthop_lookup(struct sk_buff *
 {
 	struct sk_buff *skb_to_free = NULL;
 	struct mesh_path *mpath;
+	struct sta_info *next_hop;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u8 *target_addr = hdr->addr3;
 	int err = 0;
@@ -940,7 +950,11 @@ int mesh_nexthop_lookup(struct sk_buff *
 			mesh_queue_preq(mpath,
 					PREQ_Q_F_START | PREQ_Q_F_REFRESH);
 		}
-		memcpy(hdr->addr1, mpath->next_hop->sta.addr, ETH_ALEN);
+		next_hop = rcu_dereference(mpath->next_hop);
+		if (next_hop)
+			memcpy(hdr->addr1, next_hop->sta.addr, ETH_ALEN);
+		else
+			err = -ENOENT;
 	} else {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		if (!(mpath->flags & MESH_PATH_RESOLVING)) {
--- a/net/mac80211/key.c	2011-05-13 13:40:22.000000000 +0200
+++ b/net/mac80211/key.c	2011-05-13 13:40:29.000000000 +0200
@@ -195,7 +195,7 @@ static void __ieee80211_set_default_key(
 	assert_key_lock(sdata->local);
 
 	if (idx >= 0 && idx < NUM_DEFAULT_KEYS)
-		key = sdata->keys[idx];
+		key = key_mtx_dereference(sdata->local, sdata->keys[idx]);
 
 	if (uni)
 		rcu_assign_pointer(sdata->default_unicast_key, key);
@@ -222,7 +222,7 @@ __ieee80211_set_default_mgmt_key(struct
 
 	if (idx >= NUM_DEFAULT_KEYS &&
 	    idx < NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
-		key = sdata->keys[idx];
+		key = key_mtx_dereference(sdata->local, sdata->keys[idx]);
 
 	rcu_assign_pointer(sdata->default_mgmt_key, key);
 
@@ -266,9 +266,15 @@ static void __ieee80211_key_replace(stru
 		else
 			idx = new->conf.keyidx;
 
-		defunikey = old && sdata->default_unicast_key == old;
-		defmultikey = old && sdata->default_multicast_key == old;
-		defmgmtkey = old && sdata->default_mgmt_key == old;
+		defunikey = old &&
+			old == key_mtx_dereference(sdata->local,
+						sdata->default_unicast_key);
+		defmultikey = old &&
+			old == key_mtx_dereference(sdata->local,
+						sdata->default_multicast_key);
+		defmgmtkey = old &&
+			old == key_mtx_dereference(sdata->local,
+						sdata->default_mgmt_key);
 
 		if (defunikey && !new)
 			__ieee80211_set_default_key(sdata, -1, true, false);
@@ -451,11 +457,11 @@ int ieee80211_key_link(struct ieee80211_
 	mutex_lock(&sdata->local->key_mtx);
 
 	if (sta && pairwise)
-		old_key = sta->ptk;
+		old_key = key_mtx_dereference(sdata->local, sta->ptk);
 	else if (sta)
-		old_key = sta->gtk[idx];
+		old_key = key_mtx_dereference(sdata->local, sta->gtk[idx]);
 	else
-		old_key = sdata->keys[idx];
+		old_key = key_mtx_dereference(sdata->local, sdata->keys[idx]);
 
 	__ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
 	__ieee80211_key_destroy(old_key);
--- a/net/mac80211/debugfs_key.c	2011-05-13 13:40:22.000000000 +0200
+++ b/net/mac80211/debugfs_key.c	2011-05-13 13:40:29.000000000 +0200
@@ -241,16 +241,12 @@ void ieee80211_debugfs_key_add(struct ie
 	if (!key->debugfs.dir)
 		return;
 
-	rcu_read_lock();
-	sta = rcu_dereference(key->sta);
-	if (sta)
+	sta = key->sta;
+	if (sta) {
 		sprintf(buf, "../../stations/%pM", sta->sta.addr);
-	rcu_read_unlock();
-
-	/* using sta as a boolean is fine outside RCU lock */
-	if (sta)
 		key->debugfs.stalink =
 			debugfs_create_symlink("station", key->debugfs.dir, buf);
+	}
 
 	DEBUGFS_ADD(keylen);
 	DEBUGFS_ADD(flags);
@@ -286,7 +282,8 @@ void ieee80211_debugfs_key_update_defaul
 	lockdep_assert_held(&sdata->local->key_mtx);
 
 	if (sdata->default_unicast_key) {
-		key = sdata->default_unicast_key;
+		key = key_mtx_dereference(sdata->local,
+					  sdata->default_unicast_key);
 		sprintf(buf, "../keys/%d", key->debugfs.cnt);
 		sdata->debugfs.default_unicast_key =
 			debugfs_create_symlink("default_unicast_key",
@@ -297,7 +294,8 @@ void ieee80211_debugfs_key_update_defaul
 	}
 
 	if (sdata->default_multicast_key) {
-		key = sdata->default_multicast_key;
+		key = key_mtx_dereference(sdata->local,
+					  sdata->default_multicast_key);
 		sprintf(buf, "../keys/%d", key->debugfs.cnt);
 		sdata->debugfs.default_multicast_key =
 			debugfs_create_symlink("default_multicast_key",
@@ -316,9 +314,8 @@ void ieee80211_debugfs_key_add_mgmt_defa
 	if (!sdata->debugfs.dir)
 		return;
 
-	/* this is running under the key lock */
-
-	key = sdata->default_mgmt_key;
+	key = key_mtx_dereference(sdata->local,
+				  sdata->default_mgmt_key);
 	if (key) {
 		sprintf(buf, "../keys/%d", key->debugfs.cnt);
 		sdata->debugfs.default_mgmt_key =
--- a/net/mac80211/key.h	2011-05-13 13:40:21.000000000 +0200
+++ b/net/mac80211/key.h	2011-05-13 13:40:29.000000000 +0200
@@ -146,4 +146,7 @@ void ieee80211_free_keys(struct ieee8021
 void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata);
 void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata);
 
+#define key_mtx_dereference(local, ref) \
+	rcu_dereference_protected(ref, lockdep_is_held(&((local)->key_mtx)))
+
 #endif /* IEEE80211_KEY_H */
--- a/net/mac80211/ht.c	2011-05-13 13:40:28.000000000 +0200
+++ b/net/mac80211/ht.c	2011-05-13 13:40:29.000000000 +0200
@@ -160,7 +160,7 @@ void ieee80211_ba_session_work(struct wo
 			continue;
 		}
 
-		tid_tx = sta->ampdu_mlme.tid_tx[tid];
+		tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 		if (tid_tx && test_and_clear_bit(HT_AGG_STATE_WANT_STOP,
 						 &tid_tx->state))
 			___ieee80211_stop_tx_ba_session(sta, tid,


