Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:35991 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbcDNMQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 08:16:34 -0400
Received: by mail-lf0-f44.google.com with SMTP id g184so106239875lfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2016 05:16:33 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	apenwarr@gmail.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv3 4/5] mac80211: implement codel on fair queuing flows
Date: Thu, 14 Apr 2016 14:18:21 +0200
Message-Id: <1460636302-31161-5-git-send-email-michal.kazior@tieto.com> (sfid-20160414_141640_848212_B017618D)
In-Reply-To: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
 <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
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
 include/net/mac80211.h     |  13 ++-
 net/mac80211/codel.h       | 265 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/codel_i.h     | 100 +++++++++++++++++
 net/mac80211/ieee80211_i.h |   5 +
 net/mac80211/tx.c          |  99 ++++++++++++++++-
 5 files changed, 480 insertions(+), 2 deletions(-)
 create mode 100644 net/mac80211/codel.h
 create mode 100644 net/mac80211/codel_i.h

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c24d0b8e4deb..d53b14bc4e79 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -889,7 +889,18 @@ struct ieee80211_tx_info {
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
+				u64 enqueue_time;
+			};
 			struct ieee80211_key_conf *hw_key;
 			u32 flags;
 			/* 4 bytes free */
diff --git a/net/mac80211/codel.h b/net/mac80211/codel.h
new file mode 100644
index 000000000000..63ccedcbce04
--- /dev/null
+++ b/net/mac80211/codel.h
@@ -0,0 +1,265 @@
+#ifndef __NET_MAC80211_CODEL_H
+#define __NET_MAC80211_CODEL_H
+
+/*
+ * Codel - The Controlled-Delay Active Queue Management algorithm
+ *
+ *  Copyright (C) 2011-2012 Kathleen Nichols <nichols@pollere.com>
+ *  Copyright (C) 2011-2012 Van Jacobson <van@pollere.net>
+ *  Copyright (C) 2016 Michael D. Taht <dave.taht@bufferbloat.net>
+ *  Copyright (C) 2012 Eric Dumazet <edumazet@google.com>
+ *  Copyright (C) 2015 Jonathan Morton <chromatix99@gmail.com>
+ *  Copyright (C) 2016 Michal Kazior <michal.kazior@tieto.com>
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The names of the authors may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ *
+ * Alternatively, provided that this notice is retained in full, this
+ * software may be distributed under the terms of the GNU General
+ * Public License ("GPL") version 2, in which case the provisions of the
+ * GPL apply INSTEAD OF those given above.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
+ * DAMAGE.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/ktime.h>
+#include <linux/skbuff.h>
+#include <net/pkt_sched.h>
+#include <net/inet_ecn.h>
+#include <linux/reciprocal_div.h>
+
+#include "codel_i.h"
+
+/* Controlling Queue Delay (CoDel) algorithm
+ * =========================================
+ * Source : Kathleen Nichols and Van Jacobson
+ * http://queue.acm.org/detail.cfm?id=2209336
+ *
+ * Implemented on linux by Dave Taht and Eric Dumazet
+ */
+
+/* CoDel5 uses a real clock, unlike codel */
+
+static inline u64 codel_get_time(void)
+{
+	return ktime_get_ns();
+}
+
+static inline u32 codel_time_to_us(u64 val)
+{
+	do_div(val, NSEC_PER_USEC);
+	return (u32)val;
+}
+
+/* sizeof_in_bits(rec_inv_sqrt) */
+#define REC_INV_SQRT_BITS (8 * sizeof(u16))
+/* needed shift to get a Q0.32 number from rec_inv_sqrt */
+#define REC_INV_SQRT_SHIFT (32 - REC_INV_SQRT_BITS)
+
+/* Newton approximation method needs more iterations at small inputs,
+ * so cache them.
+ */
+
+static void codel_vars_init(struct codel_vars *vars)
+{
+	memset(vars, 0, sizeof(*vars));
+}
+
+/*
+ * http://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Iterative_methods_for_reciprocal_square_roots
+ * new_invsqrt = (invsqrt / 2) * (3 - count * invsqrt^2)
+ *
+ * Here, invsqrt is a fixed point number (< 1.0), 32bit mantissa, aka Q0.32
+ */
+static inline void codel_Newton_step(struct codel_vars *vars)
+{
+	u32 invsqrt = ((u32)vars->rec_inv_sqrt) << REC_INV_SQRT_SHIFT;
+	u32 invsqrt2 = ((u64)invsqrt * invsqrt) >> 32;
+	u64 val = (3LL << 32) - ((u64)vars->count * invsqrt2);
+
+	val >>= 2; /* avoid overflow in following multiply */
+	val = (val * invsqrt) >> (32 - 2 + 1);
+
+	vars->rec_inv_sqrt = val >> REC_INV_SQRT_SHIFT;
+}
+
+/*
+ * CoDel control_law is t + interval/sqrt(count)
+ * We maintain in rec_inv_sqrt the reciprocal value of sqrt(count) to avoid
+ * both sqrt() and divide operation.
+ */
+static u64 codel_control_law(u64 t,
+			     u64 interval,
+			     u32 rec_inv_sqrt)
+{
+	return t + reciprocal_scale(interval, rec_inv_sqrt <<
+				    REC_INV_SQRT_SHIFT);
+}
+
+/* Forward declaration of this for use elsewhere */
+
+static u64 codel_get_enqueue_time_fn(void *ctx,
+				     struct sk_buff *skb);
+static struct sk_buff *codel_dequeue_fn(void *ctx,
+					struct codel_vars *vars);
+static void codel_drop_fn(void *ctx,
+			  struct codel_vars *vars,
+			  struct sk_buff *skb);
+
+static bool codel_should_drop(void *ctx,
+			      struct sk_buff *skb,
+			      u32 *backlog,
+			      u32 backlog_thr,
+			      struct codel_vars *vars,
+			      const struct codel_params *p,
+			      u64 now)
+{
+	if (!skb) {
+		vars->first_above_time = 0;
+		return false;
+	}
+
+	if (now - codel_get_enqueue_time_fn(ctx, skb) < p->target ||
+	    *backlog <= backlog_thr) {
+		/* went below - stay below for at least interval */
+		vars->first_above_time = 0;
+		return false;
+	}
+
+	if (vars->first_above_time == 0) {
+		/* just went above from below; mark the time */
+		vars->first_above_time = now + p->interval;
+
+	} else if (now > vars->first_above_time) {
+		return true;
+	}
+
+	return false;
+}
+
+static struct sk_buff *codel_dequeue(void *ctx,
+				     u32 *backlog,
+				     u32 backlog_thr,
+				     struct codel_vars *vars,
+				     struct codel_params *p,
+				     u64 now,
+				     bool overloaded)
+{
+	struct sk_buff *skb = codel_dequeue_fn(ctx, vars);
+	bool drop;
+
+	if (!skb) {
+		vars->dropping = false;
+		return skb;
+	}
+	drop = codel_should_drop(ctx, skb, backlog, backlog_thr, vars, p, now);
+	if (vars->dropping) {
+		if (!drop) {
+			/* sojourn time below target - leave dropping state */
+			vars->dropping = false;
+		} else if (now >= vars->drop_next) {
+			/* It's time for the next drop. Drop the current
+			 * packet and dequeue the next. The dequeue might
+			 * take us out of dropping state.
+			 * If not, schedule the next drop.
+			 * A large backlog might result in drop rates so high
+			 * that the next drop should happen now,
+			 * hence the while loop.
+			 */
+
+			/* saturating increment */
+			vars->count++;
+			if (!vars->count)
+				vars->count--;
+
+			codel_Newton_step(vars);
+			vars->drop_next = codel_control_law(vars->drop_next,
+							    p->interval,
+							    vars->rec_inv_sqrt);
+			do {
+				if (INET_ECN_set_ce(skb) && !overloaded) {
+					vars->ecn_mark++;
+					/* and schedule the next drop */
+					vars->drop_next = codel_control_law(
+						vars->drop_next, p->interval,
+						vars->rec_inv_sqrt);
+					goto end;
+				}
+				codel_drop_fn(ctx, vars, skb);
+				vars->drop_count++;
+				skb = codel_dequeue_fn(ctx, vars);
+				if (skb && !codel_should_drop(ctx, skb,
+							      backlog,
+							      backlog_thr,
+							      vars, p, now)) {
+					/* leave dropping state */
+					vars->dropping = false;
+				} else {
+					/* schedule the next drop */
+					vars->drop_next = codel_control_law(
+						vars->drop_next, p->interval,
+						vars->rec_inv_sqrt);
+				}
+			} while (skb && vars->dropping && now >=
+				 vars->drop_next);
+
+			/* Mark the packet regardless */
+			if (skb && INET_ECN_set_ce(skb))
+				vars->ecn_mark++;
+		}
+	} else if (drop) {
+		if (INET_ECN_set_ce(skb) && !overloaded) {
+			vars->ecn_mark++;
+		} else {
+			codel_drop_fn(ctx, vars, skb);
+			vars->drop_count++;
+
+			skb = codel_dequeue_fn(ctx, vars);
+			drop = codel_should_drop(ctx, skb, backlog,
+						 backlog_thr, vars, p, now);
+			if (skb && INET_ECN_set_ce(skb))
+				vars->ecn_mark++;
+		}
+		vars->dropping = true;
+		/* if min went above target close to when we last went below
+		 * assume that the drop rate that controlled the queue on the
+		 * last cycle is a good starting point to control it now.
+		 */
+		if (vars->count > 2 &&
+		    now - vars->drop_next < 8 * p->interval) {
+			vars->count -= 2;
+			codel_Newton_step(vars);
+		} else {
+			vars->count = 1;
+			vars->rec_inv_sqrt = ~0U >> REC_INV_SQRT_SHIFT;
+		}
+		codel_Newton_step(vars);
+		vars->drop_next = codel_control_law(now, p->interval,
+						    vars->rec_inv_sqrt);
+	}
+end:
+	return skb;
+}
+#endif
diff --git a/net/mac80211/codel_i.h b/net/mac80211/codel_i.h
new file mode 100644
index 000000000000..57369d78d131
--- /dev/null
+++ b/net/mac80211/codel_i.h
@@ -0,0 +1,100 @@
+#ifndef __NET_MAC80211_CODEL_I_H
+#define __NET_MAC80211_CODEL_I_H
+
+/*
+ * Codel - The Controlled-Delay Active Queue Management algorithm
+ *
+ *  Copyright (C) 2011-2012 Kathleen Nichols <nichols@pollere.com>
+ *  Copyright (C) 2011-2012 Van Jacobson <van@pollere.net>
+ *  Copyright (C) 2016 Michael D. Taht <dave.taht@bufferbloat.net>
+ *  Copyright (C) 2012 Eric Dumazet <edumazet@google.com>
+ *  Copyright (C) 2015 Jonathan Morton <chromatix99@gmail.com>
+ *  Copyright (C) 2016 Michal Kazior <michal.kazior@tieto.com>
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The names of the authors may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ *
+ * Alternatively, provided that this notice is retained in full, this
+ * software may be distributed under the terms of the GNU General
+ * Public License ("GPL") version 2, in which case the provisions of the
+ * GPL apply INSTEAD OF those given above.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
+ * DAMAGE.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/ktime.h>
+#include <linux/skbuff.h>
+#include <net/pkt_sched.h>
+#include <net/inet_ecn.h>
+#include <linux/reciprocal_div.h>
+
+/* Controlling Queue Delay (CoDel) algorithm
+ * =========================================
+ * Source : Kathleen Nichols and Van Jacobson
+ * http://queue.acm.org/detail.cfm?id=2209336
+ *
+ * Implemented on linux by Dave Taht and Eric Dumazet
+ */
+
+/* CoDel5 uses a real clock, unlike codel */
+
+#define MS2TIME(a) (a * (u64)NSEC_PER_MSEC)
+#define US2TIME(a) (a * (u64)NSEC_PER_USEC)
+
+/**
+ * struct codel_vars - contains codel variables
+ * @count:		how many drops we've done since the last time we
+ *			entered dropping state
+ * @dropping:		set to > 0 if in dropping state
+ * @rec_inv_sqrt:	reciprocal value of sqrt(count) >> 1
+ * @first_above_time:	when we went (or will go) continuously above target
+ *			for interval
+ * @drop_next:		time to drop next packet, or when we dropped last
+ * @drop_count:	temp count of dropped packets in dequeue()
+ * @ecn_mark:	number of packets we ECN marked instead of dropping
+ */
+
+struct codel_vars {
+	u32	count;
+	u16	dropping;
+	u16	rec_inv_sqrt;
+	u64	first_above_time;
+	u64	drop_next;
+	u16	drop_count;
+	u16	ecn_mark;
+};
+
+/**
+ * struct codel_params - stores codel parameters
+ *
+ * @interval: initial drop rate
+ * @target: maximum persistent sojourn time
+ */
+struct codel_params {
+	u64 interval;
+	u64 target;
+};
+
+#endif
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 49396d13ba9a..78953b495a25 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -31,6 +31,7 @@
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
 #include "fq_i.h"
+#include "codel_i.h"
 #include "key.h"
 #include "sta_info.h"
 #include "debug.h"
@@ -811,10 +812,12 @@ enum txq_info_flags {
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
@@ -1106,6 +1109,8 @@ struct ieee80211_local {
 	struct ieee80211_hw hw;
 
 	struct fq fq;
+	struct codel_vars *cvars;
+	struct codel_params cparams;
 
 	const struct ieee80211_ops *ops;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 396d0d17edeb..238cb8e979fd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -36,6 +36,7 @@
 #include "wme.h"
 #include "rate.h"
 #include "fq.h"
+#include "codel.h"
 
 static unsigned int fq_flows_cnt = 4096;
 module_param(fq_flows_cnt, uint, 0644);
@@ -1265,11 +1266,86 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	return NULL;
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
+static u64 codel_get_enqueue_time_fn(void *ctx,
+				     struct sk_buff *skb)
+{
+	return IEEE80211_SKB_CB(skb)->control.enqueue_time;
+}
+
+static struct sk_buff *codel_dequeue_fn(void *ctx,
+					struct codel_vars *cvars)
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
+static void codel_drop_fn(void *ctx,
+			  struct codel_vars *cvars,
+			  struct sk_buff *skb)
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
 static struct sk_buff *fq_tin_dequeue_fn(struct fq *fq,
 					 struct fq_tin *tin,
 					 struct fq_flow *flow)
 {
-	return fq_flow_dequeue(fq, flow);
+	struct ieee80211_local *local;
+	struct txq_info *txqi;
+	struct codel_vars *cvars;
+	struct codel_params *cparams;
+	bool overloaded;
+
+	local = container_of(fq, struct ieee80211_local, fq);
+	txqi = container_of(tin, struct txq_info, tin);
+	cparams = &local->cparams;
+
+	if (flow == &txqi->def_flow)
+		cvars = &txqi->def_cvars;
+	else
+		cvars = &local->cvars[flow - fq->flows];
+
+	/* TODO */
+	overloaded = false;
+
+	return codel_dequeue(txqi,
+			     &flow->backlog,
+			     0,
+			     cvars,
+			     cparams,
+			     codel_get_time(),
+			     overloaded);
 }
 
 static void fq_skb_free_fn(struct fq *fq,
@@ -1301,6 +1377,7 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
 
+	ieee80211_set_skb_enqueue_time(skb);
 	fq_tin_enqueue(fq, tin, skb);
 }
 
@@ -1310,6 +1387,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 {
 	fq_tin_init(&txqi->tin);
 	fq_flow_init(&txqi->def_flow);
+	codel_vars_init(&txqi->def_cvars);
 
 	txqi->txq.vif = &sdata->vif;
 
@@ -1338,6 +1416,7 @@ int ieee80211_txq_setup_flows(struct ieee80211_local *local)
 {
 	struct fq *fq = &local->fq;
 	int ret;
+	int i;
 
 	if (!local->ops->wake_tx_queue)
 		return 0;
@@ -1346,6 +1425,19 @@ int ieee80211_txq_setup_flows(struct ieee80211_local *local)
 	if (ret)
 		return ret;
 
+	local->cparams.interval = MS2TIME(100);
+	local->cparams.target = MS2TIME(20);
+
+	local->cvars = kcalloc(fq->flows_cnt, sizeof(local->cvars[0]),
+			       GFP_KERNEL);
+	if (!local->cvars) {
+		fq_reset(fq);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < fq->flows_cnt; i++)
+		codel_vars_init(&local->cvars[i]);
+
 	return 0;
 }
 
@@ -1356,6 +1448,9 @@ void ieee80211_txq_teardown_flows(struct ieee80211_local *local)
 	if (!local->ops->wake_tx_queue)
 		return;
 
+	kfree(local->cvars);
+	local->cvars = NULL;
+
 	fq_reset(fq);
 }
 
@@ -1378,6 +1473,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	if (!skb)
 		goto out;
 
+	ieee80211_set_skb_vif(skb, txqi);
+
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
 		struct sta_info *sta = container_of(txq->sta, struct sta_info,
-- 
2.1.4

