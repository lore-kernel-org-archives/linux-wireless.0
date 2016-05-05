Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33948 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091AbcEEK6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2016 06:58:53 -0400
Received: by mail-lf0-f42.google.com with SMTP id m64so91475298lfd.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2016 03:58:51 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	apenwarr@gmail.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv4 2/5] mac80211: implement fair queueing per txq
Date: Thu,  5 May 2016 13:00:36 +0200
Message-Id: <1462446039-1070-3-git-send-email-michal.kazior@tieto.com> (sfid-20160505_125857_229920_F4AF625C)
In-Reply-To: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
References: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
 <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211's software queues were designed to work
very closely with device tx queues. They are
required to make use of 802.11 packet aggregation
easily and efficiently.

Due to the way 802.11 aggregation is designed it
only makes sense to keep fair queuing as close to
hardware as possible to reduce induced latency and
inertia and provide the best flow responsivness.

This change doesn't translate directly to
immediate and significant gains. End result
depends on driver's induced latency. Best results
can be achieved if driver keeps its own tx
queue/fifo fill level to a minimum.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v4:
     * removed internal fq.h and re-used in-kernel one

 net/mac80211/agg-tx.c      |   8 ++-
 net/mac80211/ieee80211_i.h |  24 ++++++--
 net/mac80211/iface.c       |  12 ++--
 net/mac80211/main.c        |   7 +++
 net/mac80211/rx.c          |   2 +-
 net/mac80211/sta_info.c    |  14 ++---
 net/mac80211/tx.c          | 137 ++++++++++++++++++++++++++++++++++++++-------
 net/mac80211/util.c        |  23 +-------
 8 files changed, 163 insertions(+), 64 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 42fa81031dfa..5650c46bf91a 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -194,17 +194,21 @@ static void
 ieee80211_agg_stop_txq(struct sta_info *sta, int tid)
 {
 	struct ieee80211_txq *txq = sta->sta.txq[tid];
+	struct ieee80211_sub_if_data *sdata;
+	struct fq *fq;
 	struct txq_info *txqi;
 
 	if (!txq)
 		return;
 
 	txqi = to_txq_info(txq);
+	sdata = vif_to_sdata(txq->vif);
+	fq = &sdata->local->fq;
 
 	/* Lock here to protect against further seqno updates on dequeue */
-	spin_lock_bh(&txqi->queue.lock);
+	spin_lock_bh(&fq->lock);
 	set_bit(IEEE80211_TXQ_STOP, &txqi->flags);
-	spin_unlock_bh(&txqi->queue.lock);
+	spin_unlock_bh(&fq->lock);
 }
 
 static void
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 634603320374..6f8375f1df88 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -30,6 +30,7 @@
 #include <net/ieee80211_radiotap.h>
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
+#include <net/fq.h>
 #include "key.h"
 #include "sta_info.h"
 #include "debug.h"
@@ -805,10 +806,17 @@ enum txq_info_flags {
 	IEEE80211_TXQ_NO_AMSDU,
 };
 
+/**
+ * struct txq_info - per tid queue
+ *
+ * @tin: contains packets split into multiple flows
+ * @def_flow: used as a fallback flow when a packet destined to @tin hashes to
+ *	a fq_flow which is already owned by a different tin
+ */
 struct txq_info {
-	struct sk_buff_head queue;
+	struct fq_tin tin;
+	struct fq_flow def_flow;
 	unsigned long flags;
-	unsigned long byte_cnt;
 
 	/* keep last! */
 	struct ieee80211_txq txq;
@@ -1099,6 +1107,8 @@ struct ieee80211_local {
 	 * it first anyway so they become a no-op */
 	struct ieee80211_hw hw;
 
+	struct fq fq;
+
 	const struct ieee80211_ops *ops;
 
 	/*
@@ -1931,9 +1941,13 @@ static inline bool ieee80211_can_run_worker(struct ieee80211_local *local)
 	return true;
 }
 
-void ieee80211_init_tx_queue(struct ieee80211_sub_if_data *sdata,
-			     struct sta_info *sta,
-			     struct txq_info *txq, int tid);
+int ieee80211_txq_setup_flows(struct ieee80211_local *local);
+void ieee80211_txq_teardown_flows(struct ieee80211_local *local);
+void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
+			struct sta_info *sta,
+			struct txq_info *txq, int tid);
+void ieee80211_txq_purge(struct ieee80211_local *local,
+			 struct txq_info *txqi);
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *bssid,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 609c5174d798..b123a9e325b3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -779,6 +779,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			      bool going_down)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct fq *fq = &local->fq;
 	unsigned long flags;
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
@@ -976,13 +977,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	if (sdata->vif.txq) {
 		struct txq_info *txqi = to_txq_info(sdata->vif.txq);
-		int n = skb_queue_len(&txqi->queue);
 
-		spin_lock_bh(&txqi->queue.lock);
-		ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
-		atomic_sub(n, &sdata->num_tx_queued);
-		txqi->byte_cnt = 0;
-		spin_unlock_bh(&txqi->queue.lock);
+		spin_lock_bh(&fq->lock);
+		ieee80211_txq_purge(local, txqi);
+		spin_unlock_bh(&fq->lock);
 	}
 
 	if (local->open_count == 0)
@@ -1792,7 +1790,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		if (txq_size) {
 			txqi = netdev_priv(ndev) + size;
-			ieee80211_init_tx_queue(sdata, NULL, txqi, 0);
+			ieee80211_txq_init(sdata, NULL, txqi, 0);
 		}
 
 		sdata->dev = ndev;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 160ac6b8b9a1..d00ea9b13f49 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1086,6 +1086,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	rtnl_unlock();
 
+	result = ieee80211_txq_setup_flows(local);
+	if (result)
+		goto fail_flows;
+
 #ifdef CONFIG_INET
 	local->ifa_notifier.notifier_call = ieee80211_ifa_changed;
 	result = register_inetaddr_notifier(&local->ifa_notifier);
@@ -1111,6 +1115,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
  fail_ifa:
 #endif
+	ieee80211_txq_teardown_flows(local);
+ fail_flows:
 	rtnl_lock();
 	rate_control_deinitialize(local);
 	ieee80211_remove_interfaces(local);
@@ -1169,6 +1175,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	skb_queue_purge(&local->skb_queue);
 	skb_queue_purge(&local->skb_queue_unreliable);
 	skb_queue_purge(&local->skb_queue_tdls_chsw);
+	ieee80211_txq_teardown_flows(local);
 
 	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c5678703921e..14aae75a5c75 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1268,7 +1268,7 @@ static void sta_ps_start(struct sta_info *sta)
 	for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
 		struct txq_info *txqi = to_txq_info(sta->sta.txq[tid]);
 
-		if (!skb_queue_len(&txqi->queue))
+		if (!txqi->tin.backlog_packets)
 			set_bit(tid, &sta->txq_buffered_tids);
 		else
 			clear_bit(tid, &sta->txq_buffered_tids);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 177cc6cd6416..76b737dcc36f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -90,6 +90,7 @@ static void __cleanup_single_sta(struct sta_info *sta)
 	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
+	struct fq *fq = &local->fq;
 	struct ps_data *ps;
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
@@ -113,11 +114,10 @@ static void __cleanup_single_sta(struct sta_info *sta)
 	if (sta->sta.txq[0]) {
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			struct txq_info *txqi = to_txq_info(sta->sta.txq[i]);
-			int n = skb_queue_len(&txqi->queue);
 
-			ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
-			atomic_sub(n, &sdata->num_tx_queued);
-			txqi->byte_cnt = 0;
+			spin_lock_bh(&fq->lock);
+			ieee80211_txq_purge(local, txqi);
+			spin_unlock_bh(&fq->lock);
 		}
 	}
 
@@ -368,7 +368,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			struct txq_info *txq = txq_data + i * size;
 
-			ieee80211_init_tx_queue(sdata, sta, txq, i);
+			ieee80211_txq_init(sdata, sta, txq, i);
 		}
 	}
 
@@ -1211,7 +1211,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			struct txq_info *txqi = to_txq_info(sta->sta.txq[i]);
 
-			if (!skb_queue_len(&txqi->queue))
+			if (!txqi->tin.backlog_packets)
 				continue;
 
 			drv_wake_tx_queue(local, txqi);
@@ -1648,7 +1648,7 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
 			struct txq_info *txqi = to_txq_info(sta->sta.txq[tid]);
 
-			if (!(tids & BIT(tid)) || skb_queue_len(&txqi->queue))
+			if (!(tids & BIT(tid)) || txqi->tin.backlog_packets)
 				continue;
 
 			sta_info_recalc_tim(sta);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 792f01721d65..56633b012ba1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -25,6 +25,7 @@
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
 #include <asm/unaligned.h>
+#include <net/fq_impl.h>
 
 #include "ieee80211_i.h"
 #include "driver-ops.h"
@@ -1262,45 +1263,121 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	return NULL;
 }
 
+static struct sk_buff *fq_tin_dequeue_func(struct fq *fq,
+					   struct fq_tin *tin,
+					   struct fq_flow *flow)
+{
+	return fq_flow_dequeue(fq, flow);
+}
+
+static void fq_skb_free_func(struct fq *fq,
+			     struct fq_tin *tin,
+			     struct fq_flow *flow,
+			     struct sk_buff *skb)
+{
+	struct ieee80211_local *local;
+
+	local = container_of(fq, struct ieee80211_local, fq);
+	ieee80211_free_txskb(&local->hw, skb);
+}
+
+static struct fq_flow *fq_flow_get_default_func(struct fq *fq,
+						struct fq_tin *tin,
+						int idx,
+						struct sk_buff *skb)
+{
+	struct txq_info *txqi;
+
+	txqi = container_of(tin, struct txq_info, tin);
+	return &txqi->def_flow;
+}
+
 static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 				  struct txq_info *txqi,
 				  struct sk_buff *skb)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txqi->txq.vif);
+	struct fq *fq = &local->fq;
+	struct fq_tin *tin = &txqi->tin;
 
-	lockdep_assert_held(&txqi->queue.lock);
+	fq_tin_enqueue(fq, tin, skb,
+		       fq_skb_free_func,
+		       fq_flow_get_default_func);
+}
 
-	if (atomic_read(&sdata->num_tx_queued) >= TOTAL_MAX_TX_BUFFER ||
-	    txqi->queue.qlen >= STA_MAX_TX_BUFFER) {
-		ieee80211_free_txskb(&local->hw, skb);
-		return;
+void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
+			struct sta_info *sta,
+			struct txq_info *txqi, int tid)
+{
+	fq_tin_init(&txqi->tin);
+	fq_flow_init(&txqi->def_flow);
+
+	txqi->txq.vif = &sdata->vif;
+
+	if (sta) {
+		txqi->txq.sta = &sta->sta;
+		sta->sta.txq[tid] = &txqi->txq;
+		txqi->txq.tid = tid;
+		txqi->txq.ac = ieee802_1d_to_ac[tid & 7];
+	} else {
+		sdata->vif.txq = &txqi->txq;
+		txqi->txq.tid = 0;
+		txqi->txq.ac = IEEE80211_AC_BE;
 	}
+}
 
-	atomic_inc(&sdata->num_tx_queued);
-	txqi->byte_cnt += skb->len;
-	__skb_queue_tail(&txqi->queue, skb);
+void ieee80211_txq_purge(struct ieee80211_local *local,
+			 struct txq_info *txqi)
+{
+	struct fq *fq = &local->fq;
+	struct fq_tin *tin = &txqi->tin;
+
+	fq_tin_reset(fq, tin, fq_skb_free_func);
+}
+
+int ieee80211_txq_setup_flows(struct ieee80211_local *local)
+{
+	struct fq *fq = &local->fq;
+	int ret;
+
+	if (!local->ops->wake_tx_queue)
+		return 0;
+
+	ret = fq_init(fq, 4096);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+void ieee80211_txq_teardown_flows(struct ieee80211_local *local)
+{
+	struct fq *fq = &local->fq;
+
+	if (!local->ops->wake_tx_queue)
+		return;
+
+	fq_reset(fq, fq_skb_free_func);
 }
 
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 				     struct ieee80211_txq *txq)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->vif);
+	struct ieee80211_local *local = hw_to_local(hw);
 	struct txq_info *txqi = container_of(txq, struct txq_info, txq);
 	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb = NULL;
+	struct fq *fq = &local->fq;
+	struct fq_tin *tin = &txqi->tin;
 
-	spin_lock_bh(&txqi->queue.lock);
+	spin_lock_bh(&fq->lock);
 
 	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
 		goto out;
 
-	skb = __skb_dequeue(&txqi->queue);
+	skb = fq_tin_dequeue(fq, tin, fq_tin_dequeue_func);
 	if (!skb)
 		goto out;
 
-	atomic_dec(&sdata->num_tx_queued);
-	txqi->byte_cnt -= skb->len;
-
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
 		struct sta_info *sta = container_of(txq->sta, struct sta_info,
@@ -1315,7 +1392,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	}
 
 out:
-	spin_unlock_bh(&txqi->queue.lock);
+	spin_unlock_bh(&fq->lock);
 
 	if (skb && skb_has_frag_list(skb) &&
 	    !ieee80211_hw_check(&local->hw, TX_FRAG_LIST))
@@ -1332,6 +1409,7 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 			       bool txpending)
 {
 	struct ieee80211_tx_control control = {};
+	struct fq *fq = &local->fq;
 	struct sk_buff *skb, *tmp;
 	struct txq_info *txqi;
 	unsigned long flags;
@@ -1354,9 +1432,9 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 
 			__skb_unlink(skb, skbs);
 
-			spin_lock_bh(&txqi->queue.lock);
+			spin_lock_bh(&fq->lock);
 			ieee80211_txq_enqueue(local, txqi, skb);
-			spin_unlock_bh(&txqi->queue.lock);
+			spin_unlock_bh(&fq->lock);
 
 			drv_wake_tx_queue(local, txqi);
 
@@ -2888,6 +2966,9 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 				      struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct fq *fq = &local->fq;
+	struct fq_tin *tin;
+	struct fq_flow *flow;
 	u8 tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 	struct ieee80211_txq *txq = sta->sta.txq[tid];
 	struct txq_info *txqi;
@@ -2899,6 +2980,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	__be16 len;
 	void *data;
 	bool ret = false;
+	unsigned int orig_len;
 	int n = 1, nfrags;
 
 	if (!ieee80211_hw_check(&local->hw, TX_AMSDU))
@@ -2915,12 +2997,20 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 		max_amsdu_len = min_t(int, max_amsdu_len,
 				      sta->sta.max_rc_amsdu_len);
 
-	spin_lock_bh(&txqi->queue.lock);
+	spin_lock_bh(&fq->lock);
 
-	head = skb_peek_tail(&txqi->queue);
+	/* TODO: Ideally aggregation should be done on dequeue to remain
+	 * responsive to environment changes.
+	 */
+
+	tin = &txqi->tin;
+	flow = fq_flow_classify(fq, tin, skb, fq_flow_get_default_func);
+	head = skb_peek_tail(&flow->queue);
 	if (!head)
 		goto out;
 
+	orig_len = head->len;
+
 	if (skb->len + head->len > max_amsdu_len)
 		goto out;
 
@@ -2959,8 +3049,13 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	head->data_len += skb->len;
 	*frag_tail = skb;
 
+	flow->backlog += head->len - orig_len;
+	tin->backlog_bytes += head->len - orig_len;
+
+	fq_recalc_backlog(fq, tin, flow);
+
 out:
-	spin_unlock_bh(&txqi->queue.lock);
+	spin_unlock_bh(&fq->lock);
 
 	return ret;
 }
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 8903285337da..7a50086fb84a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3389,25 +3389,6 @@ u8 *ieee80211_add_wmm_info_ie(u8 *buf, u8 qosinfo)
 	return buf;
 }
 
-void ieee80211_init_tx_queue(struct ieee80211_sub_if_data *sdata,
-			     struct sta_info *sta,
-			     struct txq_info *txqi, int tid)
-{
-	skb_queue_head_init(&txqi->queue);
-	txqi->txq.vif = &sdata->vif;
-
-	if (sta) {
-		txqi->txq.sta = &sta->sta;
-		sta->sta.txq[tid] = &txqi->txq;
-		txqi->txq.tid = tid;
-		txqi->txq.ac = ieee802_1d_to_ac[tid & 7];
-	} else {
-		sdata->vif.txq = &txqi->txq;
-		txqi->txq.tid = 0;
-		txqi->txq.ac = IEEE80211_AC_BE;
-	}
-}
-
 void ieee80211_txq_get_depth(struct ieee80211_txq *txq,
 			     unsigned long *frame_cnt,
 			     unsigned long *byte_cnt)
@@ -3415,9 +3396,9 @@ void ieee80211_txq_get_depth(struct ieee80211_txq *txq,
 	struct txq_info *txqi = to_txq_info(txq);
 
 	if (frame_cnt)
-		*frame_cnt = txqi->queue.qlen;
+		*frame_cnt = txqi->tin.backlog_packets;
 
 	if (byte_cnt)
-		*byte_cnt = txqi->byte_cnt;
+		*byte_cnt = txqi->tin.backlog_bytes;
 }
 EXPORT_SYMBOL(ieee80211_txq_get_depth);
-- 
2.1.4

