Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35648 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbcDNMQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 08:16:31 -0400
Received: by mail-lf0-f50.google.com with SMTP id c126so106252625lfb.2
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2016 05:16:30 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	apenwarr@gmail.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv3 2/5] mac80211: implement fair queueing per txq
Date: Thu, 14 Apr 2016 14:18:19 +0200
Message-Id: <1460636302-31161-3-git-send-email-michal.kazior@tieto.com> (sfid-20160414_141639_178216_C96B749A)
In-Reply-To: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
 <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
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
 net/mac80211/agg-tx.c      |   8 +-
 net/mac80211/fq.h          | 265 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/fq_i.h        |  75 +++++++++++++
 net/mac80211/ieee80211_i.h |  25 ++++-
 net/mac80211/iface.c       |  12 +-
 net/mac80211/main.c        |   7 ++
 net/mac80211/rx.c          |   2 +-
 net/mac80211/sta_info.c    |  14 +--
 net/mac80211/tx.c          | 110 ++++++++++++++++---
 net/mac80211/util.c        |  23 +---
 10 files changed, 481 insertions(+), 60 deletions(-)
 create mode 100644 net/mac80211/fq.h
 create mode 100644 net/mac80211/fq_i.h

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 4932e9f243a2..908ac84a1962 100644
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
diff --git a/net/mac80211/fq.h b/net/mac80211/fq.h
new file mode 100644
index 000000000000..fa98576e1825
--- /dev/null
+++ b/net/mac80211/fq.h
@@ -0,0 +1,265 @@
+/*
+ * Copyright (c) 2016 Qualcomm Atheros, Inc
+ *
+ * GPL v2
+ *
+ * Based on net/sched/sch_fq_codel.c
+ */
+#ifndef FQ_H
+#define FQ_H
+
+#include "fq_i.h"
+
+/* forward declarations the includer must implement */
+
+static struct sk_buff *fq_tin_dequeue_fn(struct fq *,
+					 struct fq_tin *,
+					 struct fq_flow *flow);
+
+static void fq_skb_free_fn(struct fq *,
+			   struct fq_tin *,
+			   struct fq_flow *,
+			   struct sk_buff *);
+
+static struct fq_flow *fq_flow_get_default_fn(struct fq *,
+					      struct fq_tin *,
+					      int idx,
+					      struct sk_buff *);
+
+/* functions that are embedded into includer */
+
+static struct sk_buff *fq_flow_dequeue(struct fq *fq,
+				       struct fq_flow *flow)
+{
+	struct fq_tin *tin = flow->tin;
+	struct fq_flow *i;
+	struct sk_buff *skb;
+
+	lockdep_assert_held(&fq->lock);
+
+	skb = __skb_dequeue(&flow->queue);
+	if (!skb)
+		return NULL;
+
+	tin->backlog_bytes -= skb->len;
+	tin->backlog_packets--;
+	flow->backlog -= skb->len;
+	fq->backlog--;
+
+	if (flow->backlog == 0) {
+		list_del_init(&flow->backlogchain);
+	} else {
+		i = flow;
+
+		list_for_each_entry_continue(i, &fq->backlogs, backlogchain)
+			if (i->backlog < flow->backlog)
+				break;
+
+		list_move_tail(&flow->backlogchain,
+			       &i->backlogchain);
+	}
+
+	return skb;
+}
+
+static struct sk_buff *fq_tin_dequeue(struct fq *fq,
+				      struct fq_tin *tin)
+{
+	struct fq_flow *flow;
+	struct list_head *head;
+	struct sk_buff *skb;
+
+	lockdep_assert_held(&fq->lock);
+
+begin:
+	head = &tin->new_flows;
+	if (list_empty(head)) {
+		head = &tin->old_flows;
+		if (list_empty(head))
+			return NULL;
+	}
+
+	flow = list_first_entry(head, struct fq_flow, flowchain);
+
+	if (flow->deficit <= 0) {
+		flow->deficit += fq->quantum;
+		list_move_tail(&flow->flowchain,
+			       &tin->old_flows);
+		goto begin;
+	}
+
+	skb = fq_tin_dequeue_fn(fq, tin, flow);
+	if (!skb) {
+		/* force a pass through old_flows to prevent starvation */
+		if ((head == &tin->new_flows) &&
+		    !list_empty(&tin->old_flows)) {
+			list_move_tail(&flow->flowchain, &tin->old_flows);
+		} else {
+			list_del_init(&flow->flowchain);
+			flow->tin = NULL;
+		}
+		goto begin;
+	}
+
+	flow->deficit -= skb->len;
+
+	return skb;
+}
+
+static struct fq_flow *fq_flow_classify(struct fq *fq,
+					struct fq_tin *tin,
+					struct sk_buff *skb)
+{
+	struct fq_flow *flow;
+	u32 hash;
+	u32 idx;
+
+	lockdep_assert_held(&fq->lock);
+
+	hash = skb_get_hash_perturb(skb, fq->perturbation);
+	idx = reciprocal_scale(hash, fq->flows_cnt);
+	flow = &fq->flows[idx];
+
+	if (flow->tin && flow->tin != tin)
+		flow = fq_flow_get_default_fn(fq, tin, idx, skb);
+
+	return flow;
+}
+
+static void fq_tin_enqueue(struct fq *fq,
+			   struct fq_tin *tin,
+			   struct sk_buff *skb)
+{
+	struct fq_flow *flow;
+	struct fq_flow *i;
+
+	lockdep_assert_held(&fq->lock);
+
+	flow = fq_flow_classify(fq, tin, skb);
+
+	flow->tin = tin;
+	flow->backlog += skb->len;
+	tin->backlog_bytes += skb->len;
+	tin->backlog_packets++;
+	fq->backlog++;
+
+	if (list_empty(&flow->backlogchain))
+		list_add_tail(&flow->backlogchain, &fq->backlogs);
+
+	i = flow;
+	list_for_each_entry_continue_reverse(i, &fq->backlogs,
+					     backlogchain)
+		if (i->backlog > flow->backlog)
+			break;
+
+	list_move(&flow->backlogchain, &i->backlogchain);
+
+	if (list_empty(&flow->flowchain)) {
+		flow->deficit = fq->quantum;
+		list_add_tail(&flow->flowchain,
+			      &tin->new_flows);
+	}
+
+	__skb_queue_tail(&flow->queue, skb);
+
+	if (fq->backlog > fq->limit) {
+		flow = list_first_entry_or_null(&fq->backlogs,
+						struct fq_flow,
+						backlogchain);
+		if (!flow)
+			return;
+
+		skb = fq_flow_dequeue(fq, flow);
+		if (!skb)
+			return;
+
+		fq_skb_free_fn(fq, flow->tin, flow, skb);
+	}
+}
+
+static void fq_flow_reset(struct fq *fq, struct fq_flow *flow)
+{
+	struct sk_buff *skb;
+
+	while ((skb = fq_flow_dequeue(fq, flow)))
+		fq_skb_free_fn(fq, flow->tin, flow, skb);
+
+	if (!list_empty(&flow->flowchain))
+		list_del_init(&flow->flowchain);
+
+	if (!list_empty(&flow->backlogchain))
+		list_del_init(&flow->backlogchain);
+
+	flow->tin = NULL;
+
+	WARN_ON_ONCE(flow->backlog);
+}
+
+static void fq_tin_reset(struct fq *fq, struct fq_tin *tin)
+{
+	struct list_head *head;
+	struct fq_flow *flow;
+
+	for (;;) {
+		head = &tin->new_flows;
+		if (list_empty(head)) {
+			head = &tin->old_flows;
+			if (list_empty(head))
+				break;
+		}
+
+		flow = list_first_entry(head, struct fq_flow, flowchain);
+		fq_flow_reset(fq, flow);
+	}
+
+	WARN_ON_ONCE(tin->backlog_bytes);
+	WARN_ON_ONCE(tin->backlog_packets);
+}
+
+static void fq_flow_init(struct fq_flow *flow)
+{
+	INIT_LIST_HEAD(&flow->flowchain);
+	INIT_LIST_HEAD(&flow->backlogchain);
+	__skb_queue_head_init(&flow->queue);
+}
+
+static void fq_tin_init(struct fq_tin *tin)
+{
+	INIT_LIST_HEAD(&tin->new_flows);
+	INIT_LIST_HEAD(&tin->old_flows);
+}
+
+static int fq_init(struct fq *fq, int flows_cnt)
+{
+	int i;
+
+	memset(fq, 0, sizeof(fq[0]));
+	INIT_LIST_HEAD(&fq->backlogs);
+	spin_lock_init(&fq->lock);
+	fq->flows_cnt = max_t(u32, flows_cnt, 1);
+	fq->perturbation = prandom_u32();
+	fq->quantum = 300;
+	fq->limit = 8192;
+
+	fq->flows = kcalloc(fq->flows_cnt, sizeof(fq->flows[0]), GFP_KERNEL);
+	if (!fq->flows)
+		return -ENOMEM;
+
+	for (i = 0; i < fq->flows_cnt; i++)
+		fq_flow_init(&fq->flows[i]);
+
+	return 0;
+}
+
+static void fq_reset(struct fq *fq)
+{
+	int i;
+
+	for (i = 0; i < fq->flows_cnt; i++)
+		fq_flow_reset(fq, &fq->flows[i]);
+
+	kfree(fq->flows);
+	fq->flows = NULL;
+}
+
+#endif
diff --git a/net/mac80211/fq_i.h b/net/mac80211/fq_i.h
new file mode 100644
index 000000000000..5d8423f22e8d
--- /dev/null
+++ b/net/mac80211/fq_i.h
@@ -0,0 +1,75 @@
+/*
+ * Copyright (c) 2016 Qualcomm Atheros, Inc
+ *
+ * GPL v2
+ *
+ * Based on net/sched/sch_fq_codel.c
+ */
+#ifndef FQ_I_H
+#define FQ_I_H
+
+struct fq_tin;
+struct fq_flow;
+
+/**
+ * struct fq_flow - per traffic flow queue
+ *
+ * @tin: owner of this flow. Used to manage collisions, i.e. when a packet
+ *	hashes to an index which points to a flow that is already owned by a
+ *	different tin the packet is destined to. In such case the implementer
+ *	must provide a fallback flow
+ * @flowchain: can be linked to fq_tin's new_flows or old_flows. Used for DRR++
+ *	(deficit round robin) based round robin queuing similar to the one
+ *	found in net/sched/sch_fq_codel.c
+ * @backlogchain: can be linked to other fq_flow and fq. Used to keep track of
+ *	fat flows and efficient head-dropping if packet limit is reached
+ * @queue: sk_buff queue to hold packets
+ * @backlog: number of bytes pending in the queue. The number of packets can be
+ *	found in @queue.qlen
+ * @deficit: used for DRR++
+ */
+struct fq_flow {
+	struct fq_tin *tin;
+	struct list_head flowchain;
+	struct list_head backlogchain;
+	struct sk_buff_head queue;
+	u32 backlog;
+	int deficit;
+};
+
+/**
+ * struct fq_tin - a logical container of fq_flows
+ *
+ * Used to group fq_flows into a logical aggregate. DRR++ scheme is used to
+ * pull interleaved packets out of the associated flows.
+ *
+ * @new_flows: linked list of fq_flow
+ * @old_flows: linked list of fq_flow
+ */
+struct fq_tin {
+	struct list_head new_flows;
+	struct list_head old_flows;
+	u32 backlog_bytes;
+	u32 backlog_packets;
+};
+
+/**
+ * struct fq - main container for fair queuing purposes
+ *
+ * @backlogs: linked to fq_flows. Used to maintain fat flows for efficient
+ *	head-dropping when @backlog reaches @limit
+ * @limit: max number of packets that can be queued across all flows
+ * @backlog: number of packets queued across all flows
+ */
+struct fq {
+	struct fq_flow *flows;
+	struct list_head backlogs;
+	spinlock_t lock;
+	u32 flows_cnt;
+	u32 perturbation;
+	u32 limit;
+	u32 quantum;
+	u32 backlog;
+};
+
+#endif
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b2570aa66d33..49396d13ba9a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -30,6 +30,7 @@
 #include <net/ieee80211_radiotap.h>
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
+#include "fq_i.h"
 #include "key.h"
 #include "sta_info.h"
 #include "debug.h"
@@ -804,10 +805,17 @@ enum txq_info_flags {
 	IEEE80211_TXQ_AMPDU,
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
@@ -1097,6 +1105,8 @@ struct ieee80211_local {
 	 * it first anyway so they become a no-op */
 	struct ieee80211_hw hw;
 
+	struct fq fq;
+
 	const struct ieee80211_ops *ops;
 
 	/*
@@ -1117,7 +1127,6 @@ struct ieee80211_local {
 	    fif_probe_req;
 	int probe_req_reg;
 	unsigned int filter_flags; /* FIF_* */
-	atomic_t num_tx_queued;
 
 	bool wiphy_ciphers_allocated;
 
@@ -1925,9 +1934,13 @@ static inline bool ieee80211_can_run_worker(struct ieee80211_local *local)
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
index 67c9b1e565ad..a7ac80944ae6 100644
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
-		atomic_sub(n, &local->num_tx_queued);
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
index 609abc39e454..a1b19297ac22 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1084,6 +1084,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	rtnl_unlock();
 
+	result = ieee80211_txq_setup_flows(local);
+	if (result)
+		goto fail_flows;
+
 #ifdef CONFIG_INET
 	local->ifa_notifier.notifier_call = ieee80211_ifa_changed;
 	result = register_inetaddr_notifier(&local->ifa_notifier);
@@ -1109,6 +1113,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
  fail_ifa:
 #endif
+	ieee80211_txq_teardown_flows(local);
+ fail_flows:
 	rtnl_lock();
 	rate_control_deinitialize(local);
 	ieee80211_remove_interfaces(local);
@@ -1167,6 +1173,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	skb_queue_purge(&local->skb_queue);
 	skb_queue_purge(&local->skb_queue_unreliable);
 	skb_queue_purge(&local->skb_queue_tdls_chsw);
+	ieee80211_txq_teardown_flows(local);
 
 	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 91279576f4a7..5c52fc14a0e9 100644
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
index 4ab97d454bc1..15a1265d20b0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -89,6 +89,7 @@ static void __cleanup_single_sta(struct sta_info *sta)
 	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
+	struct fq *fq = &local->fq;
 	struct ps_data *ps;
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
@@ -112,11 +113,10 @@ static void __cleanup_single_sta(struct sta_info *sta)
 	if (sta->sta.txq[0]) {
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			struct txq_info *txqi = to_txq_info(sta->sta.txq[i]);
-			int n = skb_queue_len(&txqi->queue);
 
-			ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
-			atomic_sub(n, &local->num_tx_queued);
-			txqi->byte_cnt = 0;
+			spin_lock_bh(&fq->lock);
+			ieee80211_txq_purge(local, txqi);
+			spin_unlock_bh(&fq->lock);
 		}
 	}
 
@@ -357,7 +357,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			struct txq_info *txq = txq_data + i * size;
 
-			ieee80211_init_tx_queue(sdata, sta, txq, i);
+			ieee80211_txq_init(sdata, sta, txq, i);
 		}
 	}
 
@@ -1193,7 +1193,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			struct txq_info *txqi = to_txq_info(sta->sta.txq[i]);
 
-			if (!skb_queue_len(&txqi->queue))
+			if (!txqi->tin.backlog_packets)
 				continue;
 
 			drv_wake_tx_queue(local, txqi);
@@ -1630,7 +1630,7 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
 			struct txq_info *txqi = to_txq_info(sta->sta.txq[tid]);
 
-			if (!(tids & BIT(tid)) || skb_queue_len(&txqi->queue))
+			if (!(tids & BIT(tid)) || txqi->tin.backlog_packets)
 				continue;
 
 			sta_info_recalc_tim(sta);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8de3d2676397..d4e0c87ecec5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -34,6 +34,7 @@
 #include "wpa.h"
 #include "wme.h"
 #include "rate.h"
+#include "fq.h"
 
 /* misc utils */
 
@@ -1258,21 +1259,98 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	return NULL;
 }
 
+static struct sk_buff *fq_tin_dequeue_fn(struct fq *fq,
+					 struct fq_tin *tin,
+					 struct fq_flow *flow)
+{
+	return fq_flow_dequeue(fq, flow);
+}
+
+static void fq_skb_free_fn(struct fq *fq,
+			   struct fq_tin *tin,
+			   struct fq_flow *flow,
+			   struct sk_buff *skb)
+{
+	struct ieee80211_local *local;
+
+	local = container_of(fq, struct ieee80211_local, fq);
+	ieee80211_free_txskb(&local->hw, skb);
+}
+
+static struct fq_flow *fq_flow_get_default_fn(struct fq *fq,
+					      struct fq_tin *tin,
+					      int idx,
+					      struct sk_buff *skb)
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
-	lockdep_assert_held(&txqi->queue.lock);
+	struct fq *fq = &local->fq;
+	struct fq_tin *tin = &txqi->tin;
 
-	if (atomic_read(&local->num_tx_queued) >= TOTAL_MAX_TX_BUFFER ||
-	    txqi->queue.qlen >= STA_MAX_TX_BUFFER) {
-		ieee80211_free_txskb(&local->hw, skb);
-		return;
+	fq_tin_enqueue(fq, tin, skb);
+}
+
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
 
-	atomic_inc(&local->num_tx_queued);
-	txqi->byte_cnt += skb->len;
-	__skb_queue_tail(&txqi->queue, skb);
+void ieee80211_txq_purge(struct ieee80211_local *local,
+			 struct txq_info *txqi)
+{
+	struct fq *fq = &local->fq;
+	struct fq_tin *tin = &txqi->tin;
+
+	fq_tin_reset(fq, tin);
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
+	fq_reset(fq);
 }
 
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
@@ -1282,19 +1360,18 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
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
+	skb = fq_tin_dequeue(fq, tin);
 	if (!skb)
 		goto out;
 
-	atomic_dec(&local->num_tx_queued);
-	txqi->byte_cnt -= skb->len;
-
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
 		struct sta_info *sta = container_of(txq->sta, struct sta_info,
@@ -1309,7 +1386,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	}
 
 out:
-	spin_unlock_bh(&txqi->queue.lock);
+	spin_unlock_bh(&fq->lock);
 
 	return skb;
 }
@@ -1322,6 +1399,7 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 			       bool txpending)
 {
 	struct ieee80211_tx_control control = {};
+	struct fq *fq = &local->fq;
 	struct sk_buff *skb, *tmp;
 	struct txq_info *txqi;
 	unsigned long flags;
@@ -1344,9 +1422,9 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 
 			__skb_unlink(skb, skbs);
 
-			spin_lock_bh(&txqi->queue.lock);
+			spin_lock_bh(&fq->lock);
 			ieee80211_txq_enqueue(local, txqi, skb);
-			spin_unlock_bh(&txqi->queue.lock);
+			spin_unlock_bh(&fq->lock);
 
 			drv_wake_tx_queue(local, txqi);
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f13b08896238..bee776e46612 100644
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

