Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:36681 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbcESIgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 04:36:08 -0400
Received: by mail-lf0-f42.google.com with SMTP id u64so31682413lff.3
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2016 01:36:07 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, apenwarr@gmail.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv5 4/5] mac80211: implement codel on fair queuing flows
Date: Thu, 19 May 2016 10:37:51 +0200
Message-Id: <1463647072-16201-5-git-send-email-michal.kazior@tieto.com> (sfid-20160519_103624_383811_EDC1D336)
In-Reply-To: <1463647072-16201-1-git-send-email-michal.kazior@tieto.com>
References: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
 <1463647072-16201-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no other limit other than a global
packet count limit when using software queuing.
This means a single flow queue can grow insanely
long. This is particularly bad for TCP congestion
algorithms which requires a little more
sophisticated frame dropping scheme than a mere
headdrop on limit overflow.

Hence apply (a slighly modified, to fit the knobs)
CoDel5 on flow queues. This improves TCP
convergence and stability when combined with
wireless driver which keeps its own tx queue/fifo
at a minimum fill level for given link conditions.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v4:
     * removed internal codel.h and re-used in-kernel one

 include/net/mac80211.h     |  14 +++++-
 net/mac80211/ieee80211_i.h |   5 +++
 net/mac80211/tx.c          | 109 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a8683aec6dbe..a52009ffc19f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -21,6 +21,7 @@
 #include <linux/skbuff.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
+#include <net/codel.h>
 #include <asm/unaligned.h>
 
 /**
@@ -895,7 +896,18 @@ struct ieee80211_tx_info {
 				unsigned long jiffies;
 			};
 			/* NB: vif can be NULL for injected frames */
-			struct ieee80211_vif *vif;
+			union {
+				/* NB: vif can be NULL for injected frames */
+				struct ieee80211_vif *vif;
+
+				/* When packets are enqueued on txq it's easy
+				 * to re-construct the vif pointer. There's no
+				 * more space in tx_info so it can be used to
+				 * store the necessary enqueue time for packet
+				 * sojourn time computation.
+				 */
+				codel_time_t enqueue_time;
+			};
 			struct ieee80211_key_conf *hw_key;
 			u32 flags;
 			/* 4 bytes free */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6f8375f1df88..54edfb6fc1d1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -812,10 +812,12 @@ enum txq_info_flags {
  * @tin: contains packets split into multiple flows
  * @def_flow: used as a fallback flow when a packet destined to @tin hashes to
  *	a fq_flow which is already owned by a different tin
+ * @def_cvars: codel vars for @def_flow
  */
 struct txq_info {
 	struct fq_tin tin;
 	struct fq_flow def_flow;
+	struct codel_vars def_cvars;
 	unsigned long flags;
 
 	/* keep last! */
@@ -1108,6 +1110,9 @@ struct ieee80211_local {
 	struct ieee80211_hw hw;
 
 	struct fq fq;
+	struct codel_vars *cvars;
+	struct codel_params cparams;
+	struct codel_stats cstats;
 
 	const struct ieee80211_ops *ops;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2b60b10e6990..a7c9b6704ffb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -25,6 +25,8 @@
 #include <net/ieee80211_radiotap.h>
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
+#include <net/codel.h>
+#include <net/codel_impl.h>
 #include <asm/unaligned.h>
 #include <net/fq_impl.h>
 
@@ -1273,11 +1275,92 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	return to_txq_info(txq);
 }
 
+static void ieee80211_set_skb_enqueue_time(struct sk_buff *skb)
+{
+	IEEE80211_SKB_CB(skb)->control.enqueue_time = codel_get_time();
+}
+
+static void ieee80211_set_skb_vif(struct sk_buff *skb, struct txq_info *txqi)
+{
+	IEEE80211_SKB_CB(skb)->control.vif = txqi->txq.vif;
+}
+
+static u32 codel_skb_len_func(const struct sk_buff *skb)
+{
+	return skb->len;
+}
+
+static codel_time_t codel_skb_time_func(const struct sk_buff *skb)
+{
+	const struct ieee80211_tx_info *info;
+
+	info = (const struct ieee80211_tx_info *)skb->cb;
+	return info->control.enqueue_time;
+}
+
+static struct sk_buff *codel_dequeue_func(struct codel_vars *cvars,
+					  void *ctx)
+{
+	struct ieee80211_local *local;
+	struct txq_info *txqi;
+	struct fq *fq;
+	struct fq_flow *flow;
+
+	txqi = ctx;
+	local = vif_to_sdata(txqi->txq.vif)->local;
+	fq = &local->fq;
+
+	if (cvars == &txqi->def_cvars)
+		flow = &txqi->def_flow;
+	else
+		flow = &fq->flows[cvars - local->cvars];
+
+	return fq_flow_dequeue(fq, flow);
+}
+
+static void codel_drop_func(struct sk_buff *skb,
+			    void *ctx)
+{
+	struct ieee80211_local *local;
+	struct ieee80211_hw *hw;
+	struct txq_info *txqi;
+
+	txqi = ctx;
+	local = vif_to_sdata(txqi->txq.vif)->local;
+	hw = &local->hw;
+
+	ieee80211_free_txskb(hw, skb);
+}
+
 static struct sk_buff *fq_tin_dequeue_func(struct fq *fq,
 					   struct fq_tin *tin,
 					   struct fq_flow *flow)
 {
-	return fq_flow_dequeue(fq, flow);
+	struct ieee80211_local *local;
+	struct txq_info *txqi;
+	struct codel_vars *cvars;
+	struct codel_params *cparams;
+	struct codel_stats *cstats;
+
+	local = container_of(fq, struct ieee80211_local, fq);
+	txqi = container_of(tin, struct txq_info, tin);
+	cparams = &local->cparams;
+	cstats = &local->cstats;
+
+	if (flow == &txqi->def_flow)
+		cvars = &txqi->def_cvars;
+	else
+		cvars = &local->cvars[flow - fq->flows];
+
+	return codel_dequeue(txqi,
+			     &flow->backlog,
+			     cparams,
+			     cvars,
+			     cstats,
+			     codel_skb_len_func,
+			     codel_skb_time_func,
+			     codel_drop_func,
+			     codel_dequeue_func);
 }
 
 static void fq_skb_free_func(struct fq *fq,
@@ -1309,6 +1392,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
 
+	ieee80211_set_skb_enqueue_time(skb);
 	fq_tin_enqueue(fq, tin, skb,
 		       fq_skb_free_func,
 		       fq_flow_get_default_func);
@@ -1320,6 +1404,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 {
 	fq_tin_init(&txqi->tin);
 	fq_flow_init(&txqi->def_flow);
+	codel_vars_init(&txqi->def_cvars);
 
 	txqi->txq.vif = &sdata->vif;
 
@@ -1348,6 +1433,7 @@ int ieee80211_txq_setup_flows(struct ieee80211_local *local)
 {
 	struct fq *fq = &local->fq;
 	int ret;
+	int i;
 
 	if (!local->ops->wake_tx_queue)
 		return 0;
@@ -1356,6 +1442,22 @@ int ieee80211_txq_setup_flows(struct ieee80211_local *local)
 	if (ret)
 		return ret;
 
+	codel_params_init(&local->cparams);
+	codel_stats_init(&local->cstats);
+	local->cparams.interval = MS2TIME(100);
+	local->cparams.target = MS2TIME(20);
+	local->cparams.ecn = true;
+
+	local->cvars = kcalloc(fq->flows_cnt, sizeof(local->cvars[0]),
+			       GFP_KERNEL);
+	if (!local->cvars) {
+		fq_reset(fq, fq_skb_free_func);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < fq->flows_cnt; i++)
+		codel_vars_init(&local->cvars[i]);
+
 	return 0;
 }
 
@@ -1366,6 +1468,9 @@ void ieee80211_txq_teardown_flows(struct ieee80211_local *local)
 	if (!local->ops->wake_tx_queue)
 		return;
 
+	kfree(local->cvars);
+	local->cvars = NULL;
+
 	fq_reset(fq, fq_skb_free_func);
 }
 
@@ -1388,6 +1493,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	if (!skb)
 		goto out;
 
+	ieee80211_set_skb_vif(skb, txqi);
+
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
 		struct sta_info *sta = container_of(txq->sta, struct sta_info,
-- 
2.1.4

