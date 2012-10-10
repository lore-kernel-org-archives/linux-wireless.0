Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:43290 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab2JJTkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 15:40:08 -0400
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, bob@cozybit.com,
	devel@lists.open80211s.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [PATCH] mac80211: make powersave independent of interface type
Date: Wed, 10 Oct 2012 12:39:50 -0700
Message-Id: <1349897990-9589-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121010_214014_152718_C09E4CF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch prepares mac80211 for a later implementation of mesh or ad-hoc
powersave clients.
The structures related to powersave (buffer, TIM map, counters) are moved
from the AP-specific interface structure to a generic structure that can
be embedded into any interface type.
The functions related to powersave are prepared to allow easy extension
with different interface types. For example with:

+ } else if (sta->sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
+			ps = &sdata->u.mesh.ps;

Some references to the AP's beacon structure are removed where they were
obviously not used.

The patch compiles without warning and has been briefly tested as AP
interface with one client in PS mode.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/debugfs_netdev.c |    6 +--
 net/mac80211/ieee80211_i.h    |   20 +++++----
 net/mac80211/iface.c          |    6 +--
 net/mac80211/rx.c             |   21 ++++++---
 net/mac80211/sta_info.c       |   43 +++++++++++++-----
 net/mac80211/tx.c             |   96 +++++++++++++++++++++++------------------
 6 files changed, 119 insertions(+), 73 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 6d5aec9..c83b8ca 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -395,14 +395,14 @@ __IEEE80211_IF_FILE_W(uapsd_max_sp_len);
 
 /* AP attributes */
 IEEE80211_IF_FILE(num_mcast_sta, u.ap.num_mcast_sta, ATOMIC);
-IEEE80211_IF_FILE(num_sta_ps, u.ap.num_sta_ps, ATOMIC);
-IEEE80211_IF_FILE(dtim_count, u.ap.dtim_count, DEC);
+IEEE80211_IF_FILE(num_sta_ps, u.ap.ps.num_sta_ps, ATOMIC);
+IEEE80211_IF_FILE(dtim_count, u.ap.ps.dtim_count, DEC);
 
 static ssize_t ieee80211_if_fmt_num_buffered_multicast(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
 {
 	return scnprintf(buf, buflen, "%u\n",
-			 skb_queue_len(&sdata->u.ap.ps_bc_buf));
+			 skb_queue_len(&sdata->u.ap.ps.bc_buf));
 }
 __IEEE80211_IF_FILE(num_buffered_multicast, NULL);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8c80455..c430302 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -280,23 +280,27 @@ struct probe_resp {
 	u8 data[0];
 };
 
-struct ieee80211_if_ap {
-	struct beacon_data __rcu *beacon;
-	struct probe_resp __rcu *probe_resp;
-
-	struct list_head vlans;
-
+struct ps_data {
 	/* yes, this looks ugly, but guarantees that we can later use
 	 * bitmap_empty :)
 	 * NB: don't touch this bitmap, use sta_info_{set,clear}_tim_bit */
 	u8 tim[sizeof(unsigned long) * BITS_TO_LONGS(IEEE80211_MAX_AID + 1)];
-	struct sk_buff_head ps_bc_buf;
+	struct sk_buff_head bc_buf;
 	atomic_t num_sta_ps; /* number of stations in PS mode */
-	atomic_t num_mcast_sta; /* number of stations receiving multicast */
 	int dtim_count;
 	bool dtim_bc_mc;
 };
 
+struct ieee80211_if_ap {
+	struct beacon_data __rcu *beacon;
+	struct probe_resp __rcu *probe_resp;
+
+	struct list_head vlans;
+
+	struct ps_data ps;
+	atomic_t num_mcast_sta; /* number of stations receiving multicast */
+};
+
 struct ieee80211_if_wds {
 	struct sta_info *sta;
 	u8 remote_addr[ETH_ALEN];
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6f8a73c..f41b5cf 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -755,8 +755,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
 
 		/* free all potentially still buffered bcast frames */
-		local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps_bc_buf);
-		skb_queue_purge(&sdata->u.ap.ps_bc_buf);
+		local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps.bc_buf);
+		skb_queue_purge(&sdata->u.ap.ps.bc_buf);
 	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		ieee80211_mgd_stop(sdata);
 	}
@@ -1157,7 +1157,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.p2p = true;
 		/* fall through */
 	case NL80211_IFTYPE_AP:
-		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
+		skb_queue_head_init(&sdata->u.ap.ps.bc_buf);
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 61c621e..0573b1b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1141,12 +1141,19 @@ ieee80211_rx_h_check_more_data(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 }
 
-static void ap_sta_ps_start(struct sta_info *sta)
+static void sta_ps_start(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
+	struct ps_data *ps;
 
-	atomic_inc(&sdata->bss->num_sta_ps);
+	if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		ps = &sdata->bss->ps;
+	else
+		return;
+
+	atomic_inc(&ps->num_sta_ps);
 	set_sta_flag(sta, WLAN_STA_PS_STA);
 	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_SLEEP, &sta->sta);
@@ -1154,7 +1161,7 @@ static void ap_sta_ps_start(struct sta_info *sta)
 	       sta->sta.addr, sta->sta.aid);
 }
 
-static void ap_sta_ps_end(struct sta_info *sta)
+static void sta_ps_end(struct sta_info *sta)
 {
 	ps_dbg(sta->sdata, "STA %pM aid %d exits power save mode\n",
 	       sta->sta.addr, sta->sta.aid);
@@ -1181,9 +1188,9 @@ int ieee80211_sta_ps_transition(struct ieee80211_sta *sta, bool start)
 		return -EINVAL;
 
 	if (start)
-		ap_sta_ps_start(sta_inf);
+		sta_ps_start(sta_inf);
 	else
-		ap_sta_ps_end(sta_inf);
+		sta_ps_end(sta_inf);
 
 	return 0;
 }
@@ -1335,10 +1342,10 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 			 */
 			if (ieee80211_is_data(hdr->frame_control) &&
 			    !ieee80211_has_pm(hdr->frame_control))
-				ap_sta_ps_end(sta);
+				sta_ps_end(sta);
 		} else {
 			if (ieee80211_has_pm(hdr->frame_control))
-				ap_sta_ps_start(sta);
+				sta_ps_start(sta);
 		}
 	}
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 797dd36..8b4fadf 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -98,6 +98,7 @@ static void free_sta_work(struct work_struct *wk)
 	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
+	struct ps_data *ps;
 
 	/*
 	 * At this point, when being called as call_rcu callback,
@@ -107,11 +108,15 @@ static void free_sta_work(struct work_struct *wk)
 	 */
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
-		BUG_ON(!sdata->bss);
+		if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
+		    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			ps = &sdata->bss->ps;
+		else
+			return;
 
 		clear_sta_flag(sta, WLAN_STA_PS_STA);
 
-		atomic_dec(&sdata->bss->num_sta_ps);
+		atomic_dec(&ps->num_sta_ps);
 		sta_info_recalc_tim(sta);
 	}
 
@@ -502,22 +507,22 @@ int sta_info_insert(struct sta_info *sta)
 	return err;
 }
 
-static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
+static inline void __bss_tim_set(u8 *tim, u16 id)
 {
 	/*
 	 * This format has been mandated by the IEEE specifications,
 	 * so this line may not be changed to use the __set_bit() format.
 	 */
-	bss->tim[aid / 8] |= (1 << (aid % 8));
+	tim[id / 8] |= (1 << (id % 8));
 }
 
-static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, u16 aid)
+static inline void __bss_tim_clear(u8 *tim, u16 id)
 {
 	/*
 	 * This format has been mandated by the IEEE specifications,
 	 * so this line may not be changed to use the __clear_bit() format.
 	 */
-	bss->tim[aid / 8] &= ~(1 << (aid % 8));
+	tim[id / 8] &= ~(1 << (id % 8));
 }
 
 static unsigned long ieee80211_tids_for_ac(int ac)
@@ -541,14 +546,23 @@ static unsigned long ieee80211_tids_for_ac(int ac)
 void sta_info_recalc_tim(struct sta_info *sta)
 {
 	struct ieee80211_local *local = sta->local;
-	struct ieee80211_if_ap *bss = sta->sdata->bss;
+	struct ps_data *ps;
 	unsigned long flags;
 	bool indicate_tim = false;
 	u8 ignore_for_tim = sta->sta.uapsd_queues;
 	int ac;
+	u16 id;
+
+	if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		if (WARN_ON_ONCE(!sta->sdata->bss))
+			return;
 
-	if (WARN_ON_ONCE(!sta->sdata->bss))
+		ps = &sta->sdata->bss->ps;
+		id = sta->sta.aid;
+	} else {
 		return;
+	}
 
 	/* No need to do anything if the driver does all */
 	if (local->hw.flags & IEEE80211_HW_AP_LINK_PS)
@@ -587,9 +601,9 @@ void sta_info_recalc_tim(struct sta_info *sta)
 	spin_lock_irqsave(&local->tim_lock, flags);
 
 	if (indicate_tim)
-		__bss_tim_set(bss, sta->sta.aid);
+		__bss_tim_set(ps->tim, id);
 	else
-		__bss_tim_clear(bss, sta->sta.aid);
+		__bss_tim_clear(ps->tim, id);
 
 	if (local->ops->set_tim) {
 		local->tim_in_locked_section = true;
@@ -948,10 +962,17 @@ static void clear_sta_ps_flags(void *_sta)
 {
 	struct sta_info *sta = _sta;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ps_data *ps;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		ps = &sdata->bss->ps;
+	else
+		return;
 
 	clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
 	if (test_and_clear_sta_flag(sta, WLAN_STA_PS_STA))
-		atomic_dec(&sdata->bss->num_sta_ps);
+		atomic_dec(&ps->num_sta_ps);
 }
 
 /* powersave support code */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e0e0d1d..70c1a43 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -330,16 +330,19 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		struct ieee80211_if_ap *ap;
-		if (sdata->vif.type != NL80211_IFTYPE_AP)
+		struct ps_data *ps;
+
+		if (sdata->vif.type == NL80211_IFTYPE_AP)
+			ps = &sdata->u.ap.ps;
+		else
 			continue;
-		ap = &sdata->u.ap;
-		skb = skb_dequeue(&ap->ps_bc_buf);
+
+		skb = skb_dequeue(&ps->bc_buf);
 		if (skb) {
 			purged++;
 			dev_kfree_skb(skb);
 		}
-		total += skb_queue_len(&ap->ps_bc_buf);
+		total += skb_queue_len(&ps->bc_buf);
 	}
 
 	/*
@@ -371,6 +374,7 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+	struct ps_data *ps;
 
 	/*
 	 * broadcast/multicast frame
@@ -380,16 +384,24 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	 * This is done either by the hardware or us.
 	 */
 
-	/* powersaving STAs only in AP/VLAN mode */
-	if (!tx->sdata->bss)
+	/* powersaving STAs currently only in AP/VLAN mode */
+	if (tx->sdata->vif.type == NL80211_IFTYPE_AP ||
+	    tx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		if (!tx->sdata->bss)
+			return TX_CONTINUE;
+
+		ps = &tx->sdata->bss->ps;
+	} else {
 		return TX_CONTINUE;
+	}
+
 
 	/* no buffering for ordered frames */
 	if (ieee80211_has_order(hdr->frame_control))
 		return TX_CONTINUE;
 
 	/* no stations in PS mode */
-	if (!atomic_read(&tx->sdata->bss->num_sta_ps))
+	if (!atomic_read(&ps->num_sta_ps))
 		return TX_CONTINUE;
 
 	info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
@@ -404,14 +416,14 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
 		purge_old_ps_buffers(tx->local);
 
-	if (skb_queue_len(&tx->sdata->bss->ps_bc_buf) >= AP_MAX_BC_BUFFER) {
+	if (skb_queue_len(&ps->bc_buf) >= AP_MAX_BC_BUFFER) {
 		ps_dbg(tx->sdata,
 		       "BC TX buffer full - dropping the oldest frame\n");
-		dev_kfree_skb(skb_dequeue(&tx->sdata->bss->ps_bc_buf));
+		dev_kfree_skb(skb_dequeue(&ps->bc_buf));
 	} else
 		tx->local->total_ps_buffered++;
 
-	skb_queue_tail(&tx->sdata->bss->ps_bc_buf, tx->skb);
+	skb_queue_tail(&ps->bc_buf, tx->skb);
 
 	return TX_QUEUED;
 }
@@ -2209,9 +2221,8 @@ void ieee80211_tx_pending(unsigned long data)
 /* functions for drivers to get certain frames */
 
 static void ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_ap *bss,
-				     struct sk_buff *skb,
-				     struct beacon_data *beacon)
+				     struct ps_data *ps,
+				     struct sk_buff *skb)
 {
 	u8 *pos, *tim;
 	int aid0 = 0;
@@ -2219,27 +2230,27 @@ static void ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 
 	/* Generate bitmap for TIM only if there are any STAs in power save
 	 * mode. */
-	if (atomic_read(&bss->num_sta_ps) > 0)
+	if (atomic_read(&ps->num_sta_ps) > 0)
 		/* in the hope that this is faster than
 		 * checking byte-for-byte */
-		have_bits = !bitmap_empty((unsigned long*)bss->tim,
+		have_bits = !bitmap_empty((unsigned long*)ps->tim,
 					  IEEE80211_MAX_AID+1);
 
-	if (bss->dtim_count == 0)
-		bss->dtim_count = sdata->vif.bss_conf.dtim_period - 1;
+	if (ps->dtim_count == 0)
+		ps->dtim_count = sdata->vif.bss_conf.dtim_period - 1;
 	else
-		bss->dtim_count--;
+		ps->dtim_count--;
 
 	tim = pos = (u8 *) skb_put(skb, 6);
 	*pos++ = WLAN_EID_TIM;
 	*pos++ = 4;
-	*pos++ = bss->dtim_count;
+	*pos++ = ps->dtim_count;
 	*pos++ = sdata->vif.bss_conf.dtim_period;
 
-	if (bss->dtim_count == 0 && !skb_queue_empty(&bss->ps_bc_buf))
+	if (ps->dtim_count == 0 && !skb_queue_empty(&ps->bc_buf))
 		aid0 = 1;
 
-	bss->dtim_bc_mc = aid0 == 1;
+	ps->dtim_bc_mc = aid0 == 1;
 
 	if (have_bits) {
 		/* Find largest even number N1 so that bits numbered 1 through
@@ -2247,14 +2258,14 @@ static void ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 		 * (N2 + 1) x 8 through 2007 are 0. */
 		n1 = 0;
 		for (i = 0; i < IEEE80211_MAX_TIM_LEN; i++) {
-			if (bss->tim[i]) {
+			if (ps->tim[i]) {
 				n1 = i & 0xfe;
 				break;
 			}
 		}
 		n2 = n1;
 		for (i = IEEE80211_MAX_TIM_LEN - 1; i >= n1; i--) {
-			if (bss->tim[i]) {
+			if (ps->tim[i]) {
 				n2 = i;
 				break;
 			}
@@ -2264,7 +2275,7 @@ static void ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 		*pos++ = n1 | aid0;
 		/* Part Virt Bitmap */
 		skb_put(skb, n2 - n1);
-		memcpy(pos, bss->tim + n1, n2 - n1 + 1);
+		memcpy(pos, ps->tim + n1, n2 - n1 + 1);
 
 		tim[1] = n2 - n1 + 4;
 	} else {
@@ -2281,8 +2292,6 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	struct sk_buff *skb = NULL;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata = NULL;
-	struct ieee80211_if_ap *ap = NULL;
-	struct beacon_data *beacon;
 	enum ieee80211_band band = local->oper_channel->band;
 	struct ieee80211_tx_rate_control txrc;
 
@@ -2299,8 +2308,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		*tim_length = 0;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		ap = &sdata->u.ap;
-		beacon = rcu_dereference(ap->beacon);
+		struct ieee80211_if_ap *ap = &sdata->u.ap;
+		struct beacon_data *beacon = rcu_dereference(ap->beacon);
+
 		if (beacon) {
 			/*
 			 * headroom, head length,
@@ -2324,14 +2334,12 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 			 * of the tim bitmap in mac80211 and the driver.
 			 */
 			if (local->tim_in_locked_section) {
-				ieee80211_beacon_add_tim(sdata, ap, skb,
-							 beacon);
+				ieee80211_beacon_add_tim(sdata, &ap->ps, skb);
 			} else {
 				unsigned long flags;
 
 				spin_lock_irqsave(&local->tim_lock, flags);
-				ieee80211_beacon_add_tim(sdata, ap, skb,
-							 beacon);
+				ieee80211_beacon_add_tim(sdata, &ap->ps, skb);
 				spin_unlock_irqrestore(&local->tim_lock, flags);
 			}
 
@@ -2651,29 +2659,35 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	struct sk_buff *skb = NULL;
 	struct ieee80211_tx_data tx;
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_ap *bss = NULL;
-	struct beacon_data *beacon;
+	struct ps_data *ps;
 	struct ieee80211_tx_info *info;
 
 	sdata = vif_to_sdata(vif);
-	bss = &sdata->u.ap;
 
 	rcu_read_lock();
-	beacon = rcu_dereference(bss->beacon);
 
-	if (sdata->vif.type != NL80211_IFTYPE_AP || !beacon || !beacon->head)
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		struct beacon_data *beacon =
+				rcu_dereference(sdata->u.ap.beacon);
+
+		if (!beacon || !beacon->head)
+			goto out;
+
+		ps = &sdata->u.ap.ps;
+	} else {
 		goto out;
+	}
 
-	if (bss->dtim_count != 0 || !bss->dtim_bc_mc)
+	if (ps->dtim_count != 0 || !ps->dtim_bc_mc)
 		goto out; /* send buffered bc/mc only after DTIM beacon */
 
 	while (1) {
-		skb = skb_dequeue(&bss->ps_bc_buf);
+		skb = skb_dequeue(&ps->bc_buf);
 		if (!skb)
 			goto out;
 		local->total_ps_buffered--;
 
-		if (!skb_queue_empty(&bss->ps_bc_buf) && skb->len >= 2) {
+		if (!skb_queue_empty(&ps->bc_buf) && skb->len >= 2) {
 			struct ieee80211_hdr *hdr =
 				(struct ieee80211_hdr *) skb->data;
 			/* more buffered multicast/broadcast frames ==> set
-- 
1.7.9.5

