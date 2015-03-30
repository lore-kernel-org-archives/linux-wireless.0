Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48361 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbbC3SUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 14:20:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use rhashtable for station table
Date: Mon, 30 Mar 2015 20:20:02 +0200
Message-Id: <1427739602-13509-1-git-send-email-johannes@sipsolutions.net> (sfid-20150330_202013_302466_E116EB40)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We currently have a hand-rolled table with 256 entries and are
using the last byte of the MAC address as the hash. This hash
is obviously very fast, but collisions are easily created and
we waste a lot of space in the common case of just connecting
as a client to an AP where we just have a single station. The
other common case of an AP is also suboptimal due to the size
of the hash table and the ease of causing collisions.

Convert all of this to use rhashtable with jhash, which gives
us the advantage of a far better hash function (with random
perturbation to avoid hash collision attacks) and of course
that the hash table grows and shrinks dynamically with chain
length, improving both cases above.

Use a specialised hash function (using jhash, but with fixed
length) to achieve better compiler optimisation as suggested
by Sergey Ryazanov.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |   3 +-
 net/mac80211/main.c        |   9 ++--
 net/mac80211/rx.c          |   9 +++-
 net/mac80211/sta_info.c    | 104 +++++++++++++++++++++++----------------------
 net/mac80211/sta_info.h    |  38 ++++++-----------
 net/mac80211/status.c      |   8 +++-
 6 files changed, 86 insertions(+), 85 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 487f5e2a9283..3c1512b0442c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -26,6 +26,7 @@
 #include <linux/etherdevice.h>
 #include <linux/leds.h>
 #include <linux/idr.h>
+#include <linux/rhashtable.h>
 #include <net/ieee80211_radiotap.h>
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
@@ -1187,7 +1188,7 @@ struct ieee80211_local {
 	spinlock_t tim_lock;
 	unsigned long num_sta;
 	struct list_head sta_list;
-	struct sta_info __rcu *sta_hash[STA_HASH_SIZE];
+	struct rhashtable sta_hash;
 	struct timer_list sta_cleanup;
 	int sta_generation;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4977967c8b00..51e0332a4589 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -557,6 +557,9 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 
 	local = wiphy_priv(wiphy);
 
+	if (sta_info_init(local))
+		goto err_free;
+
 	local->hw.wiphy = wiphy;
 
 	local->hw.priv = (char *)local + ALIGN(sizeof(*local), NETDEV_ALIGN);
@@ -629,8 +632,6 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	spin_lock_init(&local->ack_status_lock);
 	idr_init(&local->ack_status_frames);
 
-	sta_info_init(local);
-
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
 		skb_queue_head_init(&local->pending[i]);
 		atomic_set(&local->agg_queue_stop[i], 0);
@@ -650,6 +651,9 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	ieee80211_roc_setup(local);
 
 	return &local->hw;
+ err_free:
+	wiphy_free(wiphy);
+	return NULL;
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw_nm);
 
@@ -1173,7 +1177,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
-	sta_info_stop(local);
 	ieee80211_wep_free(local);
 	ieee80211_led_exit(local);
 	kfree(local->int_scan_req);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4f7b922cfda4..5b60bcf00ec3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3423,7 +3423,8 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	__le16 fc;
 	struct ieee80211_rx_data rx;
 	struct ieee80211_sub_if_data *prev;
-	struct sta_info *sta, *tmp, *prev_sta;
+	struct sta_info *sta, *prev_sta;
+	struct rhash_head *tmp;
 	int err = 0;
 
 	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
@@ -3458,9 +3459,13 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		ieee80211_scan_rx(local, skb);
 
 	if (ieee80211_is_data(fc)) {
+		const struct bucket_table *tbl;
+
 		prev_sta = NULL;
 
-		for_each_sta_info(local, hdr->addr2, sta, tmp) {
+		tbl = rht_dereference_rcu(local->sta_hash.tbl, &local->sta_hash);
+
+		for_each_sta_info(local, tbl, hdr->addr2, sta, tmp) {
 			if (!prev_sta) {
 				prev_sta = sta;
 				continue;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index aacaa1a85e63..2f25a192febb 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -64,32 +64,20 @@
  * freed before they are done using it.
  */
 
+struct rhashtable_params sta_rht_params = {
+	.nelem_hint = 3, /* start small */
+	.head_offset = offsetof(struct sta_info, hash_node),
+	.key_offset = offsetof(struct sta_info, sta.addr),
+	.key_len = ETH_ALEN,
+	.hashfn = sta_addr_hash,
+};
+
 /* Caller must hold local->sta_mtx */
 static int sta_info_hash_del(struct ieee80211_local *local,
 			     struct sta_info *sta)
 {
-	struct sta_info *s;
-
-	s = rcu_dereference_protected(local->sta_hash[STA_HASH(sta->sta.addr)],
-				      lockdep_is_held(&local->sta_mtx));
-	if (!s)
-		return -ENOENT;
-	if (s == sta) {
-		rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)],
-				   s->hnext);
-		return 0;
-	}
-
-	while (rcu_access_pointer(s->hnext) &&
-	       rcu_access_pointer(s->hnext) != sta)
-		s = rcu_dereference_protected(s->hnext,
-					lockdep_is_held(&local->sta_mtx));
-	if (rcu_access_pointer(s->hnext)) {
-		rcu_assign_pointer(s->hnext, sta->hnext);
-		return 0;
-	}
-
-	return -ENOENT;
+	return rhashtable_remove_fast(&local->sta_hash, &sta->hash_node,
+				      sta_rht_params);
 }
 
 static void __cleanup_single_sta(struct sta_info *sta)
@@ -159,18 +147,8 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
 
-	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
-				    lockdep_is_held(&local->sta_mtx));
-	while (sta) {
-		if (sta->sdata == sdata &&
-		    ether_addr_equal(sta->sta.addr, addr))
-			break;
-		sta = rcu_dereference_check(sta->hnext,
-					    lockdep_is_held(&local->sta_mtx));
-	}
-	return sta;
+	return rhashtable_lookup_fast(&local->sta_hash, addr, sta_rht_params);
 }
 
 /*
@@ -182,18 +160,25 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
+	struct rhash_head *tmp;
+	const struct bucket_table *tbl;
 
-	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
-				    lockdep_is_held(&local->sta_mtx));
-	while (sta) {
-		if ((sta->sdata == sdata ||
-		     (sta->sdata->bss && sta->sdata->bss == sdata->bss)) &&
-		    ether_addr_equal(sta->sta.addr, addr))
-			break;
-		sta = rcu_dereference_check(sta->hnext,
-					    lockdep_is_held(&local->sta_mtx));
+	/* XXX: this is only for rhashtable ... */
+	rcu_read_lock();
+	tbl = rht_dereference_rcu(local->sta_hash.tbl, &local->sta_hash);
+
+	for_each_sta_info(local, tbl, addr, sta, tmp) {
+		if (sta->sdata == sdata ||
+		    (sta->sdata->bss && sta->sdata->bss == sdata->bss)) {
+			rcu_read_unlock();
+			/* this is safe as the caller must already hold
+			 * rcu read side section or the mutex
+			 */
+			return sta;
+		}
 	}
-	return sta;
+	rcu_read_unlock();
+	return NULL;
 }
 
 struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
@@ -242,9 +227,8 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 static void sta_info_hash_add(struct ieee80211_local *local,
 			      struct sta_info *sta)
 {
-	lockdep_assert_held(&local->sta_mtx);
-	sta->hnext = local->sta_hash[STA_HASH(sta->sta.addr)];
-	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)], sta);
+	rhashtable_insert_fast(&local->sta_hash, &sta->hash_node,
+			       sta_rht_params);
 }
 
 static void sta_deliver_ps_frames(struct work_struct *wk)
@@ -948,19 +932,32 @@ static void sta_info_cleanup(unsigned long data)
 		  round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL));
 }
 
-void sta_info_init(struct ieee80211_local *local)
+u32 sta_addr_hash(const void *key, u32 length, u32 seed)
+{
+	return jhash(key, ETH_ALEN, seed);
+}
+
+int sta_info_init(struct ieee80211_local *local)
 {
+	int err;
+
+	err = rhashtable_init(&local->sta_hash, &sta_rht_params);
+	if (err)
+		return err;
+
 	spin_lock_init(&local->tim_lock);
 	mutex_init(&local->sta_mtx);
 	INIT_LIST_HEAD(&local->sta_list);
 
 	setup_timer(&local->sta_cleanup, sta_info_cleanup,
 		    (unsigned long)local);
+	return 0;
 }
 
 void sta_info_stop(struct ieee80211_local *local)
 {
 	del_timer_sync(&local->sta_cleanup);
+	rhashtable_destroy(&local->sta_hash);
 }
 
 
@@ -1024,16 +1021,21 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 }
 
 struct ieee80211_sta *ieee80211_find_sta_by_ifaddr(struct ieee80211_hw *hw,
-					       const u8 *addr,
-					       const u8 *localaddr)
+						   const u8 *addr,
+						   const u8 *localaddr)
 {
-	struct sta_info *sta, *nxt;
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct sta_info *sta;
+	struct rhash_head *tmp;
+	const struct bucket_table *tbl;
+
+	tbl = rht_dereference_rcu(local->sta_hash.tbl, &local->sta_hash);
 
 	/*
 	 * Just return a random station if localaddr is NULL
 	 * ... first in list.
 	 */
-	for_each_sta_info(hw_to_local(hw), addr, sta, nxt) {
+	for_each_sta_info(local, tbl, addr, sta, tmp) {
 		if (localaddr &&
 		    !ether_addr_equal(sta->sdata->vif.addr, localaddr))
 			continue;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 248f56e59ebc..97f25b9e52be 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -16,6 +16,7 @@
 #include <linux/workqueue.h>
 #include <linux/average.h>
 #include <linux/etherdevice.h>
+#include <linux/rhashtable.h>
 #include "key.h"
 
 /**
@@ -246,7 +247,7 @@ struct sta_ampdu_mlme {
  *
  * @list: global linked list entry
  * @free_list: list entry for keeping track of stations to free
- * @hnext: hash table linked list pointer
+ * @hash_node: hash node for rhashtable
  * @local: pointer to the global information
  * @sdata: virtual interface this station belongs to
  * @ptk: peer keys negotiated with this station, if any
@@ -339,7 +340,7 @@ struct sta_info {
 	/* General information, mostly static */
 	struct list_head list, free_list;
 	struct rcu_head rcu_head;
-	struct sta_info __rcu *hnext;
+	struct rhash_head hash_node;
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
@@ -535,10 +536,6 @@ rcu_dereference_protected_tid_tx(struct sta_info *sta, int tid)
 					 lockdep_is_held(&sta->ampdu_mlme.mtx));
 }
 
-#define STA_HASH_SIZE 256
-#define STA_HASH(sta) (sta[5])
-
-
 /* Maximum number of frames to buffer per power saving station per AC */
 #define STA_MAX_TX_BUFFER	64
 
@@ -559,26 +556,15 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 				  const u8 *addr);
 
-static inline
-void for_each_sta_info_type_check(struct ieee80211_local *local,
-				  const u8 *addr,
-				  struct sta_info *sta,
-				  struct sta_info *nxt)
-{
-}
+u32 sta_addr_hash(const void *key, u32 length, u32 seed);
+
+#define _sta_bucket_idx(_tbl, _a)					\
+	rht_bucket_index(_tbl, sta_addr_hash(_a, ETH_ALEN, (_tbl)->hash_rnd))
 
-#define for_each_sta_info(local, _addr, _sta, nxt)			\
-	for (	/* initialise loop */					\
-		_sta = rcu_dereference(local->sta_hash[STA_HASH(_addr)]),\
-		nxt = _sta ? rcu_dereference(_sta->hnext) : NULL;	\
-		/* typecheck */						\
-		for_each_sta_info_type_check(local, (_addr), _sta, nxt),\
-		/* continue condition */				\
-		_sta;							\
-		/* advance loop */					\
-		_sta = nxt,						\
-		nxt = _sta ? rcu_dereference(_sta->hnext) : NULL	\
-	     )								\
+#define for_each_sta_info(local, tbl, _addr, _sta, _tmp)		\
+	rht_for_each_entry_rcu(_sta, _tmp, tbl, 			\
+			       _sta_bucket_idx(tbl, _addr),		\
+			       hash_node)				\
 	/* compare address and run code only if it matches */		\
 	if (ether_addr_equal(_sta->sta.addr, (_addr)))
 
@@ -615,7 +601,7 @@ int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
 
 void sta_info_recalc_tim(struct sta_info *sta);
 
-void sta_info_init(struct ieee80211_local *local);
+int sta_info_init(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
 
 /**
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 2c51742428d5..005fdbe39a8b 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -654,7 +654,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata;
 	struct net_device *prev_dev = NULL;
-	struct sta_info *sta, *tmp;
+	struct sta_info *sta;
+	struct rhash_head *tmp;
 	int retry_count;
 	int rates_idx;
 	bool send_to_cooked;
@@ -663,6 +664,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	int rtap_len;
 	int shift = 0;
 	int tid = IEEE80211_NUM_TIDS;
+	const struct bucket_table *tbl;
 
 	rates_idx = ieee80211_tx_get_rates(hw, info, &retry_count);
 
@@ -671,7 +673,9 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	sband = local->hw.wiphy->bands[info->band];
 	fc = hdr->frame_control;
 
-	for_each_sta_info(local, hdr->addr1, sta, tmp) {
+	tbl = rht_dereference_rcu(local->sta_hash.tbl, &local->sta_hash);
+
+	for_each_sta_info(local, tbl, hdr->addr1, sta, tmp) {
 		/* skip wrong virtual interface */
 		if (!ether_addr_equal(hdr->addr2, sta->sdata->vif.addr))
 			continue;
-- 
2.1.4

