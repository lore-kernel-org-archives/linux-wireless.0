Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33388 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbbBMVrf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 16:47:35 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Thomas Graf <tgraf@suug.ch>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: use rhashtable for station table
Date: Fri, 13 Feb 2015 22:47:29 +0100
Message-Id: <1423864049-8961-1-git-send-email-johannes@sipsolutions.net> (sfid-20150213_224739_263486_C407C0CE)
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

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  3 +-
 net/mac80211/main.c        |  9 +++--
 net/mac80211/rx.c          |  4 +--
 net/mac80211/sta_info.c    | 87 ++++++++++++++++++++--------------------------
 net/mac80211/sta_info.h    | 37 ++++++--------------
 net/mac80211/status.c      |  4 +--
 6 files changed, 59 insertions(+), 85 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3afe36824703..798392398ab5 100644
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
@@ -1195,7 +1196,7 @@ struct ieee80211_local {
 	spinlock_t tim_lock;
 	unsigned long num_sta;
 	struct list_head sta_list;
-	struct sta_info __rcu *sta_hash[STA_HASH_SIZE];
+	struct rhashtable sta_hash;
 	struct timer_list sta_cleanup;
 	int sta_generation;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5e09d354c5a5..95d59d24b271 100644
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
index ed38d8302659..aa238a66ae2e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3417,7 +3417,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	__le16 fc;
 	struct ieee80211_rx_data rx;
 	struct ieee80211_sub_if_data *prev;
-	struct sta_info *sta, *tmp, *prev_sta;
+	struct sta_info *sta, *prev_sta;
 	int err = 0;
 
 	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
@@ -3454,7 +3454,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	if (ieee80211_is_data(fc)) {
 		prev_sta = NULL;
 
-		for_each_sta_info(local, hdr->addr2, sta, tmp) {
+		for_each_sta_info(local, hdr->addr2, sta) {
 			if (!prev_sta) {
 				prev_sta = sta;
 				continue;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 00ca8dcc2bcf..0535bf89e115 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -68,28 +68,7 @@
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
+	return rhashtable_remove(&local->sta_hash, &sta->hash_node) ? 0 : -ENOENT;
 }
 
 static void __cleanup_single_sta(struct sta_info *sta)
@@ -159,18 +138,8 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
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
+	return rhashtable_lookup(&local->sta_hash, addr);
 }
 
 /*
@@ -183,17 +152,11 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
-	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
-				    lockdep_is_held(&local->sta_mtx));
-	while (sta) {
-		if ((sta->sdata == sdata ||
-		     (sta->sdata->bss && sta->sdata->bss == sdata->bss)) &&
-		    ether_addr_equal(sta->sta.addr, addr))
-			break;
-		sta = rcu_dereference_check(sta->hnext,
-					    lockdep_is_held(&local->sta_mtx));
-	}
-	return sta;
+	for_each_sta_info(local, addr, sta)
+		if (sta->sdata == sdata ||
+		    (sta->sdata->bss && sta->sdata->bss == sdata->bss))
+			return sta;
+	return NULL;
 }
 
 struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
@@ -250,9 +213,7 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 static void sta_info_hash_add(struct ieee80211_local *local,
 			      struct sta_info *sta)
 {
-	lockdep_assert_held(&local->sta_mtx);
-	sta->hnext = local->sta_hash[STA_HASH(sta->sta.addr)];
-	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)], sta);
+	rhashtable_insert(&local->sta_hash, &sta->hash_node);
 }
 
 static void sta_deliver_ps_frames(struct work_struct *wk)
@@ -992,19 +953,45 @@ static void sta_info_cleanup(unsigned long data)
 		  round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL));
 }
 
-void sta_info_init(struct ieee80211_local *local)
+#ifdef CONFIG_PROVE_LOCKING
+static int sta_info_mutex_is_held(void *parent)
 {
+	struct ieee80211_local *local = parent;
+	return lockdep_is_held(&local->sta_mtx);
+}
+#endif
+
+int sta_info_init(struct ieee80211_local *local)
+{
+	struct rhashtable_params params = {
+		.head_offset = offsetof(struct sta_info, hash_node),
+		.key_offset = offsetof(struct sta_info, sta.addr),
+		.key_len = ETH_ALEN,
+		.hashfn = jhash,
+#ifdef CONFIG_PROVE_LOCKING
+		.mutex_is_held = sta_info_mutex_is_held,
+		.parent = local,
+#endif
+	};
+	int err;
+
+	err = rhashtable_init(&local->sta_hash, &params);
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
 
 
@@ -1071,13 +1058,13 @@ struct ieee80211_sta *ieee80211_find_sta_by_ifaddr(struct ieee80211_hw *hw,
 					       const u8 *addr,
 					       const u8 *localaddr)
 {
-	struct sta_info *sta, *nxt;
+	struct sta_info *sta;
 
 	/*
 	 * Just return a random station if localaddr is NULL
 	 * ... first in list.
 	 */
-	for_each_sta_info(hw_to_local(hw), addr, sta, nxt) {
+	for_each_sta_info(hw_to_local(hw), addr, sta) {
 		if (localaddr &&
 		    !ether_addr_equal(sta->sdata->vif.addr, localaddr))
 			continue;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 925e68fe64c7..dd8a15e6ede4 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -16,6 +16,7 @@
 #include <linux/workqueue.h>
 #include <linux/average.h>
 #include <linux/etherdevice.h>
+#include <linux/rhashtable.h>
 #include "key.h"
 
 /**
@@ -265,7 +266,7 @@ struct ieee80211_tx_latency_stat {
  *
  * @list: global linked list entry
  * @free_list: list entry for keeping track of stations to free
- * @hnext: hash table linked list pointer
+ * @hash_node: hash node for rhashtable
  * @local: pointer to the global information
  * @sdata: virtual interface this station belongs to
  * @ptk: peer keys negotiated with this station, if any
@@ -359,7 +360,7 @@ struct sta_info {
 	/* General information, mostly static */
 	struct list_head list, free_list;
 	struct rcu_head rcu_head;
-	struct sta_info __rcu *hnext;
+	struct rhash_head hash_node;
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
@@ -557,10 +558,6 @@ rcu_dereference_protected_tid_tx(struct sta_info *sta, int tid)
 					 lockdep_is_held(&sta->ampdu_mlme.mtx));
 }
 
-#define STA_HASH_SIZE 256
-#define STA_HASH(sta) (sta[5])
-
-
 /* Maximum number of frames to buffer per power saving station per AC */
 #define STA_MAX_TX_BUFFER	64
 
@@ -581,28 +578,14 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 				  const u8 *addr);
 
-static inline
-void for_each_sta_info_type_check(struct ieee80211_local *local,
-				  const u8 *addr,
-				  struct sta_info *sta,
-				  struct sta_info *nxt)
-{
-}
+#define sta_bucket(sh, _a)						\
+	rht_dereference_rcu((sh)->tbl, sh)->buckets[rhashtable_hashfn(sh, _a, ETH_ALEN)]
 
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
+#define for_each_sta_info(local, _a, _sta)				\
+	rht_for_each_entry_rcu(_sta, sta_bucket(&local->sta_hash, (_a)),\
+			       hash_node)				\
 	/* compare address and run code only if it matches */		\
-	if (ether_addr_equal(_sta->sta.addr, (_addr)))
+	if (ether_addr_equal(_sta->sta.addr, (_a)))
 
 /*
  * Get STA info by index, BROKEN!
@@ -637,7 +620,7 @@ int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
 
 void sta_info_recalc_tim(struct sta_info *sta);
 
-void sta_info_init(struct ieee80211_local *local);
+int sta_info_init(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
 
 /**
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index e679b7c9b160..f8719cf55a01 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -722,7 +722,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata;
 	struct net_device *prev_dev = NULL;
-	struct sta_info *sta, *tmp;
+	struct sta_info *sta;
 	int retry_count;
 	int rates_idx;
 	bool send_to_cooked;
@@ -739,7 +739,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	sband = local->hw.wiphy->bands[info->band];
 	fc = hdr->frame_control;
 
-	for_each_sta_info(local, hdr->addr1, sta, tmp) {
+	for_each_sta_info(local, hdr->addr1, sta) {
 		/* skip wrong virtual interface */
 		if (!ether_addr_equal(hdr->addr2, sta->sdata->vif.addr))
 			continue;
-- 
2.1.4

