Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab2ATM6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 07:58:54 -0500
Message-Id: <20120120125741.255524436@sipsolutions.net> (sfid-20120120_135858_990016_9392B0CC)
Date: Fri, 20 Jan 2012 13:55:24 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/11] mac80211: remove dummy STA support
References: <20120120125516.000124996@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The dummy STA support was added because I didn't
want to change the driver API at the time. Now
that we have state transitions triggering station
add/remove in the driver, we only call add once a
station reaches ASSOCIATED, so we can remove the
dummy station stuff again.

While at it, tighten the RX check and accept only
port control (EAP) frames from the AP station if
it's not associated yet -- in other cases there's
no race.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c     |   15 +----
 net/mac80211/rx.c       |   13 +++-
 net/mac80211/sta_info.c |  135 ++++++++----------------------------------------
 net/mac80211/sta_info.h |   30 ----------
 4 files changed, 38 insertions(+), 155 deletions(-)

--- a/net/mac80211/sta_info.h	2012-01-20 13:54:20.000000000 +0100
+++ b/net/mac80211/sta_info.h	2012-01-20 13:54:20.000000000 +0100
@@ -267,8 +267,6 @@ struct sta_ampdu_mlme {
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
  * @lost_packets: number of consecutive lost packets
- * @dummy: indicate a dummy station created for receiving
- *	EAP frames before association
  * @sta: station information we share with the driver
  * @sta_state: duplicates information about station state (for debug)
  * @beacon_loss_count: number of times beacon loss has triggered
@@ -366,9 +364,6 @@ struct sta_info {
 	unsigned int lost_packets;
 	unsigned int beacon_loss_count;
 
-	/* should be right in front of sta to be in the same cache line */
-	bool dummy;
-
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
@@ -470,15 +465,9 @@ rcu_dereference_protected_tid_tx(struct
 struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr);
 
-struct sta_info *sta_info_get_rx(struct ieee80211_sub_if_data *sdata,
-			      const u8 *addr);
-
 struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 				  const u8 *addr);
 
-struct sta_info *sta_info_get_bss_rx(struct ieee80211_sub_if_data *sdata,
-				  const u8 *addr);
-
 static inline
 void for_each_sta_info_type_check(struct ieee80211_local *local,
 				  const u8 *addr,
@@ -487,23 +476,7 @@ void for_each_sta_info_type_check(struct
 {
 }
 
-#define for_each_sta_info(local, _addr, _sta, nxt) 			\
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
-	/* run code only if address matches and it's not a dummy sta */	\
-	if (memcmp(_sta->sta.addr, (_addr), ETH_ALEN) == 0 &&		\
-		!_sta->dummy)
-
-#define for_each_sta_info_rx(local, _addr, _sta, nxt)			\
+#define for_each_sta_info(local, _addr, _sta, nxt)			\
 	for (	/* initialise loop */					\
 		_sta = rcu_dereference(local->sta_hash[STA_HASH(_addr)]),\
 		nxt = _sta ? rcu_dereference(_sta->hnext) : NULL;	\
@@ -542,7 +515,6 @@ void sta_info_free(struct ieee80211_loca
  */
 int sta_info_insert(struct sta_info *sta);
 int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU);
-int sta_info_reinsert(struct sta_info *sta);
 
 int __must_check __sta_info_destroy(struct sta_info *sta);
 int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata,
--- a/net/mac80211/sta_info.c	2012-01-20 13:54:20.000000000 +0100
+++ b/net/mac80211/sta_info.c	2012-01-20 13:54:20.000000000 +0100
@@ -100,25 +100,6 @@ struct sta_info *sta_info_get(struct iee
 	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
 				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
-		if (sta->sdata == sdata && !sta->dummy &&
-		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
-			break;
-		sta = rcu_dereference_check(sta->hnext,
-					    lockdep_is_held(&local->sta_mtx));
-	}
-	return sta;
-}
-
-/* get a station info entry even if it is a dummy station*/
-struct sta_info *sta_info_get_rx(struct ieee80211_sub_if_data *sdata,
-			      const u8 *addr)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
-
-	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
-				    lockdep_is_held(&local->sta_mtx));
-	while (sta) {
 		if (sta->sdata == sdata &&
 		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
@@ -143,30 +124,6 @@ struct sta_info *sta_info_get_bss(struct
 	while (sta) {
 		if ((sta->sdata == sdata ||
 		     (sta->sdata->bss && sta->sdata->bss == sdata->bss)) &&
-		    !sta->dummy &&
-		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
-			break;
-		sta = rcu_dereference_check(sta->hnext,
-					    lockdep_is_held(&local->sta_mtx));
-	}
-	return sta;
-}
-
-/*
- * Get sta info either from the specified interface
- * or from one of its vlans (including dummy stations)
- */
-struct sta_info *sta_info_get_bss_rx(struct ieee80211_sub_if_data *sdata,
-				  const u8 *addr)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
-
-	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
-				    lockdep_is_held(&local->sta_mtx));
-	while (sta) {
-		if ((sta->sdata == sdata ||
-		     (sta->sdata->bss && sta->sdata->bss == sdata->bss)) &&
 		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
 		sta = rcu_dereference_check(sta->hnext,
@@ -397,66 +354,43 @@ static int sta_info_insert_finish(struct
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct sta_info *exist_sta;
-	bool dummy_reinsert = false;
+	struct station_info sinfo;
 	int err = 0;
 
 	lockdep_assert_held(&local->sta_mtx);
 
-	/*
-	 * check if STA exists already.
-	 * only accept a scenario of a second call to sta_info_insert_finish
-	 * with a dummy station entry that was inserted earlier
-	 * in that case - assume that the dummy station flag should
-	 * be removed.
-	 */
-	exist_sta = sta_info_get_bss_rx(sdata, sta->sta.addr);
-	if (exist_sta) {
-		if (exist_sta == sta && sta->dummy) {
-			dummy_reinsert = true;
-		} else {
-			err = -EEXIST;
-			goto out_err;
-		}
+	/* check if STA exists already */
+	if (sta_info_get_bss(sdata, sta->sta.addr)) {
+		err = -EEXIST;
+		goto out_err;
 	}
 
-	if (!sta->dummy || dummy_reinsert) {
-		/* notify driver */
-		err = sta_info_insert_drv_state(local, sdata, sta);
-		if (err)
-			goto out_err;
-	}
-
-	if (!dummy_reinsert) {
-		local->num_sta++;
-		local->sta_generation++;
-		smp_mb();
+	/* notify driver */
+	err = sta_info_insert_drv_state(local, sdata, sta);
+	if (err)
+		goto out_err;
 
-		/* make the station visible */
-		sta_info_hash_add(local, sta);
+	local->num_sta++;
+	local->sta_generation++;
+	smp_mb();
 
-		list_add(&sta->list, &local->sta_list);
+	/* make the station visible */
+	sta_info_hash_add(local, sta);
 
-		set_sta_flag(sta, WLAN_STA_INSERTED);
-	} else {
-		sta->dummy = false;
-	}
+	list_add(&sta->list, &local->sta_list);
 
-	if (!sta->dummy) {
-		struct station_info sinfo;
+	set_sta_flag(sta, WLAN_STA_INSERTED);
 
-		ieee80211_sta_debugfs_add(sta);
-		rate_control_add_sta_debugfs(sta);
+	ieee80211_sta_debugfs_add(sta);
+	rate_control_add_sta_debugfs(sta);
 
-		memset(&sinfo, 0, sizeof(sinfo));
-		sinfo.filled = 0;
-		sinfo.generation = local->sta_generation;
-		cfg80211_new_sta(sdata->dev, sta->sta.addr, &sinfo, GFP_KERNEL);
-	}
+	memset(&sinfo, 0, sizeof(sinfo));
+	sinfo.filled = 0;
+	sinfo.generation = local->sta_generation;
+	cfg80211_new_sta(sdata->dev, sta->sta.addr, &sinfo, GFP_KERNEL);
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	wiphy_debug(local->hw.wiphy, "Inserted %sSTA %pM\n",
-			sta->dummy ? "dummy " : "", sta->sta.addr);
+	wiphy_debug(local->hw.wiphy, "Inserted STA %pM\n", sta->sta.addr);
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 	/* move reference to rcu-protected */
@@ -508,25 +442,6 @@ int sta_info_insert(struct sta_info *sta
 	return err;
 }
 
-/* Caller must hold sta->local->sta_mtx */
-int sta_info_reinsert(struct sta_info *sta)
-{
-	struct ieee80211_local *local = sta->local;
-	int err = 0;
-
-	err = sta_info_insert_check(sta);
-	if (err) {
-		mutex_unlock(&local->sta_mtx);
-		return err;
-	}
-
-	might_sleep();
-
-	err = sta_info_insert_finish(sta);
-	rcu_read_unlock();
-	return err;
-}
-
 static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
 {
 	/*
@@ -875,7 +790,7 @@ int sta_info_destroy_addr(struct ieee802
 	int ret;
 
 	mutex_lock(&sdata->local->sta_mtx);
-	sta = sta_info_get_rx(sdata, addr);
+	sta = sta_info_get(sdata, addr);
 	ret = __sta_info_destroy(sta);
 	mutex_unlock(&sdata->local->sta_mtx);
 
@@ -889,7 +804,7 @@ int sta_info_destroy_addr_bss(struct iee
 	int ret;
 
 	mutex_lock(&sdata->local->sta_mtx);
-	sta = sta_info_get_bss_rx(sdata, addr);
+	sta = sta_info_get_bss(sdata, addr);
 	ret = __sta_info_destroy(sta);
 	mutex_unlock(&sdata->local->sta_mtx);
 
--- a/net/mac80211/mlme.c	2012-01-20 13:54:18.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-01-20 13:54:20.000000000 +0100
@@ -1581,7 +1581,7 @@ static bool ieee80211_assoc_success(stru
 	 * station info was already allocated and inserted before
 	 * the association and should be available to us
 	 */
-	sta = sta_info_get_rx(sdata, cbss->bssid);
+	sta = sta_info_get(sdata, cbss->bssid);
 	if (WARN_ON(!sta)) {
 		mutex_unlock(&sdata->local->sta_mtx);
 		return false;
@@ -1648,14 +1648,7 @@ static bool ieee80211_assoc_success(stru
 		return false;
 	}
 
-	/* sta_info_reinsert will also unlock the mutex lock */
-	err = sta_info_reinsert(sta);
-	sta = NULL;
-	if (err) {
-		printk(KERN_DEBUG "%s: failed to insert STA entry for"
-		       " the AP (error %d)\n", sdata->name, err);
-		return false;
-	}
+	mutex_unlock(&sdata->local->sta_mtx);
 
 	/*
 	 * Always handle WMM once after association regardless
@@ -2536,12 +2529,10 @@ static int ieee80211_pre_assoc(struct ie
 	if (!sta)
 		return -ENOMEM;
 
-	sta->dummy = true;
-
 	err = sta_info_insert(sta);
 	sta = NULL;
 	if (err) {
-		printk(KERN_DEBUG "%s: failed to insert Dummy STA entry for"
+		printk(KERN_DEBUG "%s: failed to insert STA entry for"
 		       " the AP (error %d)\n", sdata->name, err);
 		return err;
 	}
--- a/net/mac80211/rx.c	2012-01-20 13:54:18.000000000 +0100
+++ b/net/mac80211/rx.c	2012-01-20 13:54:20.000000000 +0100
@@ -859,7 +859,12 @@ ieee80211_rx_h_check(struct ieee80211_rx
 		     rx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_WDS &&
 		     (!rx->sta || !test_sta_flag(rx->sta, WLAN_STA_ASSOC)))) {
-		if (rx->sta && rx->sta->dummy &&
+		/*
+		 * accept port control frames from the AP even when it's not
+		 * yet marked ASSOC to prevent a race where we don't set the
+		 * assoc bit quickly enough before it sends the first frame
+		 */
+		if (rx->sta && rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
 		    ieee80211_is_data_present(hdr->frame_control)) {
 			u16 ethertype;
 			u8 *payload;
@@ -2953,7 +2958,7 @@ static void __ieee80211_rx_handle_packet
 	if (ieee80211_is_data(fc)) {
 		prev_sta = NULL;
 
-		for_each_sta_info_rx(local, hdr->addr2, sta, tmp) {
+		for_each_sta_info(local, hdr->addr2, sta, tmp) {
 			if (!prev_sta) {
 				prev_sta = sta;
 				continue;
@@ -2997,7 +3002,7 @@ static void __ieee80211_rx_handle_packet
 			continue;
 		}
 
-		rx.sta = sta_info_get_bss_rx(prev, hdr->addr2);
+		rx.sta = sta_info_get_bss(prev, hdr->addr2);
 		rx.sdata = prev;
 		ieee80211_prepare_and_rx_handle(&rx, skb, false);
 
@@ -3005,7 +3010,7 @@ static void __ieee80211_rx_handle_packet
 	}
 
 	if (prev) {
-		rx.sta = sta_info_get_bss_rx(prev, hdr->addr2);
+		rx.sta = sta_info_get_bss(prev, hdr->addr2);
 		rx.sdata = prev;
 
 		if (ieee80211_prepare_and_rx_handle(&rx, skb, true))


