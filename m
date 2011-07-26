Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:52188 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab1GZVbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 17:31:25 -0400
Received: by eye22 with SMTP id 22so1213684eye.2
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 14:31:24 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: fix race condition between assoc_done and first EAP packet
Date: Wed, 27 Jul 2011 00:29:32 +0300
Message-Id: <1311715772-8855-2-git-send-email-guy@wizery.com> (sfid-20110726_233130_459018_770A6242)
In-Reply-To: <1311715772-8855-1-git-send-email-guy@wizery.com>
References: <1311715772-8855-1-git-send-email-guy@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When associating to an AP, the station might miss the first EAP
packet that the AP sends due to a race condition between the association
success procedure and the rx flow in mac80211.
In such cases, the packet might fall in ieee80211_rx_h_check due to
the fact that the relevant rx->sta wasn't allocated yet.
Allocation of the relevant station info struct before actually
sending the association request and setting it with a new
dummy_sta flag solve this problem.
The station will accept only EAP packets from the AP while it
is in the pre-association/dummy state.
This dummy station entry is not seen by normal sta_info_get()
calls, only by sta_info_get_bss_rx().
The driver is not notified for the first insertion of the
dummy station. The driver is notified only after the association
is complete and the dummy flag is removed from the station entry.
That way, all the rest of the code flow should be untouched by
this change.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 net/mac80211/mlme.c     |   60 +++++++++++++--
 net/mac80211/rx.c       |   20 ++++-
 net/mac80211/sta_info.c |  192 ++++++++++++++++++++++++++++++++++-------------
 net/mac80211/sta_info.h |   30 +++++++-
 4 files changed, 240 insertions(+), 62 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a497718..8a2fff1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1495,10 +1495,14 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 
 	ifmgd->aid = aid;
 
-	sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
-	if (!sta) {
-		printk(KERN_DEBUG "%s: failed to alloc STA entry for"
-		       " the AP\n", sdata->name);
+	mutex_lock(&sdata->local->sta_mtx);
+	/*
+	 * station info was already allocated and inserted before
+	 * the association and should be available to us
+	 */
+	sta = sta_info_get_rx(sdata, cbss->bssid);
+	if (WARN_ON(!sta)) {
+		mutex_unlock(&sdata->local->sta_mtx);
 		return false;
 	}
 
@@ -1569,8 +1573,10 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 	if (elems.wmm_param)
 		set_sta_flags(sta, WLAN_STA_WME);
 
-	err = sta_info_insert(sta);
+	err = sta_info_insert_notify(sta);
 	sta = NULL;
+	/* sta_info_insert_notify changed the mutex lock with rcu lock */
+	rcu_read_unlock();
 	if (err) {
 		printk(KERN_DEBUG "%s: failed to insert STA entry for"
 		       " the AP (error %d)\n", sdata->name, err);
@@ -2387,15 +2393,43 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+/* create and insert a dummy station entry */
+static int ieee80211_pre_assoc(struct ieee80211_sub_if_data *sdata,
+				u8 *bssid) {
+	struct sta_info *sta;
+	int err;
+
+	sta = sta_info_alloc(sdata, bssid, GFP_KERNEL);
+	if (!sta) {
+		printk(KERN_DEBUG "%s: failed to alloc STA entry for"
+			   " the AP\n", sdata->name);
+		return -ENOMEM;
+	}
+
+	sta->dummy = true;
+
+	err = sta_info_insert(sta);
+	sta = NULL;
+	if (err) {
+		printk(KERN_DEBUG "%s: failed to insert Dummy STA entry for"
+		       " the AP (error %d)\n", sdata->name, err);
+		return err;
+	}
+
+	return 0;
+}
+
 static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 						  struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_rx_status *rx_status;
 	struct ieee802_11_elems elems;
+	struct cfg80211_bss *cbss = wk->assoc.bss;
 	u16 status;
 
 	if (!skb) {
+		sta_info_destroy_addr(wk->sdata, cbss->bssid);
 		cfg80211_send_assoc_timeout(wk->sdata->dev, wk->filter_ta);
 		return WORK_DONE_DESTROY;
 	}
@@ -2421,12 +2455,16 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 		if (!ieee80211_assoc_success(wk, mgmt, skb->len)) {
 			mutex_unlock(&wk->sdata->u.mgd.mtx);
 			/* oops -- internal error -- send timeout for now */
+			sta_info_destroy_addr(wk->sdata, cbss->bssid);
 			cfg80211_send_assoc_timeout(wk->sdata->dev,
 						    wk->filter_ta);
 			return WORK_DONE_DESTROY;
 		}
 
 		mutex_unlock(&wk->sdata->u.mgd.mtx);
+	} else {
+		/* assoc failed - destroy the dummy station entry */
+		sta_info_destroy_addr(wk->sdata, cbss->bssid);
 	}
 
 	cfg80211_send_rx_assoc(wk->sdata->dev, skb->data, skb->len);
@@ -2440,7 +2478,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_bss *bss = (void *)req->bss->priv;
 	struct ieee80211_work *wk;
 	const u8 *ssid;
-	int i;
+	int i, err;
 
 	mutex_lock(&ifmgd->mtx);
 	if (ifmgd->associated) {
@@ -2465,6 +2503,16 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	if (!wk)
 		return -ENOMEM;
 
+	/*
+	 * create a dummy station info entry in order
+	 * to start accepting incoming EAPOL packets from the station
+	 */
+	err = ieee80211_pre_assoc(sdata, req->bss->bssid);
+	if (err) {
+		kfree(wk);
+		return err;
+	}
+
 	ifmgd->flags &= ~IEEE80211_STA_DISABLE_11N;
 	ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e8e67dc..3146891 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -842,8 +842,20 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 		      ieee80211_is_pspoll(hdr->frame_control)) &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_WDS &&
-		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC))))
+		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC)))) {
+		if (rx->sta->dummy && ieee80211_is_data(hdr->frame_control)) {
+			u16 ethertype;
+			u8 *payload;
+
+			payload = rx->skb->data +
+				ieee80211_hdrlen(hdr->frame_control);
+			ethertype = (payload[6] << 8) | payload[7];
+			if (cpu_to_be16(ethertype) ==
+				rx->sdata->control_port_protocol)
+				return RX_CONTINUE;
+		}
 		return RX_DROP_MONITOR;
+	}
 
 	return RX_CONTINUE;
 }
@@ -2782,7 +2794,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	if (ieee80211_is_data(fc)) {
 		prev_sta = NULL;
 
-		for_each_sta_info(local, hdr->addr2, sta, tmp) {
+		for_each_sta_info_rx(local, hdr->addr2, sta, tmp) {
 			if (!prev_sta) {
 				prev_sta = sta;
 				continue;
@@ -2826,7 +2838,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 			continue;
 		}
 
-		rx.sta = sta_info_get_bss(prev, hdr->addr2);
+		rx.sta = sta_info_get_bss_rx(prev, hdr->addr2);
 		rx.sdata = prev;
 		ieee80211_prepare_and_rx_handle(&rx, skb, false);
 
@@ -2834,7 +2846,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	}
 
 	if (prev) {
-		rx.sta = sta_info_get_bss(prev, hdr->addr2);
+		rx.sta = sta_info_get_bss_rx(prev, hdr->addr2);
 		rx.sdata = prev;
 
 		if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index b4549f2..b27a61b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -102,6 +102,30 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 				    lockdep_is_held(&local->sta_mtx));
 	while (sta) {
 		if (sta->sdata == sdata &&
+		    !sta->dummy &&
+		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
+			break;
+		sta = rcu_dereference_check(sta->hnext,
+					    rcu_read_lock_held() ||
+					    lockdep_is_held(&local->sta_lock) ||
+					    lockdep_is_held(&local->sta_mtx));
+	}
+	return sta;
+}
+
+/* get a station info entry even if it is a dummy station*/
+struct sta_info *sta_info_get_rx(struct ieee80211_sub_if_data *sdata,
+			      const u8 *addr)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
+				    rcu_read_lock_held() ||
+				    lockdep_is_held(&local->sta_lock) ||
+				    lockdep_is_held(&local->sta_mtx));
+	while (sta) {
+		if (sta->sdata == sdata &&
 		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
 		sta = rcu_dereference_check(sta->hnext,
@@ -129,6 +153,34 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 	while (sta) {
 		if ((sta->sdata == sdata ||
 		     (sta->sdata->bss && sta->sdata->bss == sdata->bss)) &&
+		    !sta->dummy &&
+		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
+			break;
+		sta = rcu_dereference_check(sta->hnext,
+					    rcu_read_lock_held() ||
+					    lockdep_is_held(&local->sta_lock) ||
+					    lockdep_is_held(&local->sta_mtx));
+	}
+	return sta;
+}
+
+/*
+ * Get sta info either from the specified interface
+ * or from one of its vlans (including dummy stations)
+ */
+struct sta_info *sta_info_get_bss_rx(struct ieee80211_sub_if_data *sdata,
+				  const u8 *addr)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
+				    rcu_read_lock_held() ||
+				    lockdep_is_held(&local->sta_lock) ||
+				    lockdep_is_held(&local->sta_mtx));
+	while (sta) {
+		if ((sta->sdata == sdata ||
+		     (sta->sdata->bss && sta->sdata->bss == sdata->bss)) &&
 		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
 		sta = rcu_dereference_check(sta->hnext,
@@ -284,7 +336,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	return sta;
 }
 
-static int sta_info_finish_insert(struct sta_info *sta, bool async)
+static int sta_info_finish_insert(struct sta_info *sta,
+				bool async, bool sta_list_add)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -294,50 +347,55 @@ static int sta_info_finish_insert(struct sta_info *sta, bool async)
 
 	lockdep_assert_held(&local->sta_mtx);
 
-	/* notify driver */
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		sdata = container_of(sdata->bss,
-				     struct ieee80211_sub_if_data,
-				     u.ap);
-	err = drv_sta_add(local, sdata, &sta->sta);
-	if (err) {
-		if (!async)
-			return err;
-		printk(KERN_DEBUG "%s: failed to add IBSS STA %pM to driver (%d)"
-				  " - keeping it anyway.\n",
-		       sdata->name, sta->sta.addr, err);
-	} else {
-		sta->uploaded = true;
+	if (!sta->dummy) {
+		/* notify driver */
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			sdata = container_of(sdata->bss,
+					     struct ieee80211_sub_if_data,
+					     u.ap);
+		err = drv_sta_add(local, sdata, &sta->sta);
+		if (err) {
+			if (!async)
+				return err;
+			printk(KERN_DEBUG "%s: failed to add IBSS STA %pM to "
+					  "driver (%d) - keeping it anyway.\n",
+			       sdata->name, sta->sta.addr, err);
+		} else {
+			sta->uploaded = true;
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-		if (async)
-			wiphy_debug(local->hw.wiphy,
-				    "Finished adding IBSS STA %pM\n",
-				    sta->sta.addr);
+			if (async)
+				wiphy_debug(local->hw.wiphy,
+					    "Finished adding IBSS STA %pM\n",
+					    sta->sta.addr);
 #endif
+		}
+
+		sdata = sta->sdata;
 	}
 
-	sdata = sta->sdata;
+	if (sta_list_add) {
+		if (!async) {
+			local->num_sta++;
+			local->sta_generation++;
+			smp_mb();
 
-	if (!async) {
-		local->num_sta++;
-		local->sta_generation++;
-		smp_mb();
+			/* make the station visible */
+			spin_lock_irqsave(&local->sta_lock, flags);
+			sta_info_hash_add(local, sta);
+			spin_unlock_irqrestore(&local->sta_lock, flags);
+		}
 
-		/* make the station visible */
-		spin_lock_irqsave(&local->sta_lock, flags);
-		sta_info_hash_add(local, sta);
-		spin_unlock_irqrestore(&local->sta_lock, flags);
+		list_add(&sta->list, &local->sta_list);
 	}
 
-	list_add(&sta->list, &local->sta_list);
-
-	ieee80211_sta_debugfs_add(sta);
-	rate_control_add_sta_debugfs(sta);
-
-	sinfo.filled = 0;
-	sinfo.generation = local->sta_generation;
-	cfg80211_new_sta(sdata->dev, sta->sta.addr, &sinfo, GFP_KERNEL);
+	if (!sta->dummy) {
+		ieee80211_sta_debugfs_add(sta);
+		rate_control_add_sta_debugfs(sta);
 
+		sinfo.filled = 0;
+		sinfo.generation = local->sta_generation;
+		cfg80211_new_sta(sdata->dev, sta->sta.addr, &sinfo, GFP_KERNEL);
+	}
 
 	return 0;
 }
@@ -354,7 +412,7 @@ static void sta_info_finish_pending(struct ieee80211_local *local)
 		list_del(&sta->list);
 		spin_unlock_irqrestore(&local->sta_lock, flags);
 
-		sta_info_finish_insert(sta, true);
+		sta_info_finish_insert(sta, true, true);
 
 		spin_lock_irqsave(&local->sta_lock, flags);
 	}
@@ -398,7 +456,7 @@ static int sta_info_insert_adhoc(struct sta_info *sta) __acquires(RCU)
 
 	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
-	if (sta_info_get_bss(sdata, sta->sta.addr)) {
+	if (sta_info_get_bss_rx(sdata, sta->sta.addr)) {
 		spin_unlock_irqrestore(&local->sta_lock, flags);
 		rcu_read_lock();
 		__sta_info_free(local, sta);
@@ -430,11 +488,13 @@ static int sta_info_insert_adhoc(struct sta_info *sta) __acquires(RCU)
  * this function replaces the mutex lock
  * with a RCU lock
  */
-static int sta_info_insert_mgd(struct sta_info *sta) __acquires(RCU)
+static int sta_info_insert_mgd(struct sta_info *sta,
+				bool sta_list_add) __acquires(RCU)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	unsigned long flags;
+	struct sta_info *exist_sta;
 	int err = 0;
 
 	lockdep_assert_held(&local->sta_mtx);
@@ -450,17 +510,28 @@ static int sta_info_insert_mgd(struct sta_info *sta) __acquires(RCU)
 	 */
 
 	spin_lock_irqsave(&local->sta_lock, flags);
-	/* check if STA exists already */
-	if (sta_info_get_bss(sdata, sta->sta.addr)) {
-		spin_unlock_irqrestore(&local->sta_lock, flags);
-		mutex_unlock(&local->sta_mtx);
-		rcu_read_lock();
-		return -EEXIST;
+	/*
+	 * check if STA exists already.
+	 * only accept a scenario of a second call to sta_info_insert_mgd
+	 * with a dummy station entry that was inserted earlier
+	 * in that case - assume that the dummy station flag should
+	 * be removed.
+	 */
+	exist_sta = sta_info_get_bss_rx(sdata, sta->sta.addr);
+	if (exist_sta) {
+		if (exist_sta == sta && sta->dummy && !sta_list_add) {
+			sta->dummy = false;
+		} else {
+			spin_unlock_irqrestore(&local->sta_lock, flags);
+			mutex_unlock(&local->sta_mtx);
+			rcu_read_lock();
+			return -EEXIST;
+		}
 	}
 
 	spin_unlock_irqrestore(&local->sta_lock, flags);
 
-	err = sta_info_finish_insert(sta, false);
+	err = sta_info_finish_insert(sta, false, sta_list_add);
 	if (err) {
 		mutex_unlock(&local->sta_mtx);
 		rcu_read_lock();
@@ -468,14 +539,15 @@ static int sta_info_insert_mgd(struct sta_info *sta) __acquires(RCU)
 	}
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	wiphy_debug(local->hw.wiphy, "Inserted STA %pM\n", sta->sta.addr);
+	wiphy_debug(local->hw.wiphy, "Inserted %sSTA %pM\n",
+			sta->dummy ? "Dummy " : "", sta->sta.addr);
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 	/* move reference to rcu-protected */
 	rcu_read_lock();
 	mutex_unlock(&local->sta_mtx);
 
-	if (ieee80211_vif_is_mesh(&sdata->vif))
+	if (ieee80211_vif_is_mesh(&sdata->vif) && !sta->dummy)
 		mesh_accept_plinks_update(sdata);
 
 	return 0;
@@ -514,7 +586,7 @@ int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 
 	mutex_lock(&local->sta_mtx);
 
-	err = sta_info_insert_mgd(sta);
+	err = sta_info_insert_mgd(sta, true);
 	if (err)
 		goto out_free;
 
@@ -534,6 +606,24 @@ int sta_info_insert(struct sta_info *sta)
 	return err;
 }
 
+/* Caller must hold sta->local->sta_mtx */
+int sta_info_insert_notify(struct sta_info *sta) __acquires(RCU)
+{
+	struct ieee80211_local *local = sta->local;
+	int err = 0;
+
+	err = sta_info_insert_check(sta);
+	if (err) {
+		mutex_unlock(&local->sta_mtx);
+		rcu_read_lock();
+		return err;
+	}
+
+	might_sleep();
+
+	return sta_info_insert_mgd(sta, false);
+}
+
 static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
 {
 	/*
@@ -774,7 +864,7 @@ int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 	int ret;
 
 	mutex_lock(&sdata->local->sta_mtx);
-	sta = sta_info_get(sdata, addr);
+	sta = sta_info_get_rx(sdata, addr);
 	ret = __sta_info_destroy(sta);
 	mutex_unlock(&sdata->local->sta_mtx);
 
@@ -788,7 +878,7 @@ int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
 	int ret;
 
 	mutex_lock(&sdata->local->sta_mtx);
-	sta = sta_info_get_bss(sdata, addr);
+	sta = sta_info_get_bss_rx(sdata, addr);
 	ret = __sta_info_destroy(sta);
 	mutex_unlock(&sdata->local->sta_mtx);
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index a06d64e..b1b104b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -238,10 +238,12 @@ struct sta_ampdu_mlme {
  * @plink_timer: peer link watch timer
  * @plink_timer_was_running: used by suspend/resume to restore timers
  * @debugfs: debug filesystem info
- * @sta: station information we share with the driver
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
  * @lost_packets: number of consecutive lost packets
+ * @dummy: indicate a dummy station created for receiving
+ *	EAP frames before association
+ * @sta: station information we share with the driver
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -335,6 +337,9 @@ struct sta_info {
 
 	unsigned int lost_packets;
 
+	/* should be right in front of sta to be in the same cache line */
+	bool dummy;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
@@ -435,9 +440,15 @@ rcu_dereference_protected_tid_tx(struct sta_info *sta, int tid)
 struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr);
 
+struct sta_info *sta_info_get_rx(struct ieee80211_sub_if_data *sdata,
+			      const u8 *addr);
+
 struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 				  const u8 *addr);
 
+struct sta_info *sta_info_get_bss_rx(struct ieee80211_sub_if_data *sdata,
+				  const u8 *addr);
+
 static inline
 void for_each_sta_info_type_check(struct ieee80211_local *local,
 				  const u8 *addr,
@@ -458,6 +469,22 @@ void for_each_sta_info_type_check(struct ieee80211_local *local,
 		_sta = nxt,						\
 		nxt = _sta ? rcu_dereference(_sta->hnext) : NULL	\
 	     )								\
+	/* run code only if address matches and it's not a dummy sta */	\
+	if (memcmp(_sta->sta.addr, (_addr), ETH_ALEN) == 0 &&\
+		!_sta->dummy)
+
+#define for_each_sta_info_rx(local, _addr, _sta, nxt)			\
+	for (/* initialise loop */\
+		_sta = rcu_dereference(local->sta_hash[STA_HASH(_addr)]),\
+		nxt = _sta ? rcu_dereference(_sta->hnext) : NULL;	\
+		/* typecheck */						\
+		for_each_sta_info_type_check(local, (_addr), _sta, nxt),\
+		/* continue condition */				\
+		_sta;							\
+		/* advance loop */					\
+		_sta = nxt,						\
+		nxt = _sta ? rcu_dereference(_sta->hnext) : NULL	\
+		)							   \
 	/* compare address and run code only if it matches */		\
 	if (memcmp(_sta->sta.addr, (_addr), ETH_ALEN) == 0)
 
@@ -483,6 +510,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 int sta_info_insert(struct sta_info *sta);
 int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU);
 int sta_info_insert_atomic(struct sta_info *sta);
+int sta_info_insert_notify(struct sta_info *sta)  __acquires(RCU);
 
 int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata,
 			  const u8 *addr);
-- 
1.7.4.1

