Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36758 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966141AbcCPKPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 06:15:53 -0400
Received: by mail-lf0-f49.google.com with SMTP id l83so15474741lfd.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 03:15:51 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, johannes@sipsolutions.net,
	netdev@vger.kernel.org, dave.taht@gmail.com,
	emmanuel.grumbach@intel.com, nbd@openwrt.org,
	Tim Shepard <shep@alum.mit.edu>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFCv2 1/3] mac80211: implement fq_codel for software queuing
Date: Wed, 16 Mar 2016 11:17:56 +0100
Message-Id: <1458123478-1795-2-git-send-email-michal.kazior@tieto.com> (sfid-20160316_111603_830000_FD69FA4E)
In-Reply-To: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
References: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 11n aggregation become important to get the
best out of txops. However aggregation inherently
requires buffering and queuing. Once variable
medium conditions to different associated stations
is considered it became apparent that bufferbloat
can't be simply fought with qdiscs for wireless
drivers.

This bases on codel5 and sch_fq_codel.c. It may
not be the Right Thing yet but it should at least
provide a framework for more improvements.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h     |  96 ++++++-
 net/mac80211/agg-tx.c      |   8 +-
 net/mac80211/cfg.c         |   2 +-
 net/mac80211/codel.h       | 264 ++++++++++++++++++
 net/mac80211/codel_i.h     |  89 ++++++
 net/mac80211/debugfs.c     | 267 ++++++++++++++++++
 net/mac80211/ieee80211_i.h |  45 +++-
 net/mac80211/iface.c       |  25 +-
 net/mac80211/main.c        |   9 +-
 net/mac80211/rx.c          |   2 +-
 net/mac80211/sta_info.c    |  10 +-
 net/mac80211/sta_info.h    |  27 ++
 net/mac80211/status.c      |  64 +++++
 net/mac80211/tx.c          | 658 ++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/util.c        |  21 +-
 15 files changed, 1503 insertions(+), 84 deletions(-)
 create mode 100644 net/mac80211/codel.h
 create mode 100644 net/mac80211/codel_i.h

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a53333cb1528..947d827f254b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -565,6 +565,16 @@ struct ieee80211_bss_conf {
 	struct ieee80211_p2p_noa_attr p2p_noa_attr;
 };
 
+/*
+ * struct codel_params - contains codel parameters
+ * @interval:	initial drop rate
+ * @target:     maximum persistent sojourn time
+ */
+struct codel_params {
+	u64	interval;
+	u64	target;
+};
+
 /**
  * enum mac80211_tx_info_flags - flags to describe transmission information/status
  *
@@ -853,6 +863,8 @@ ieee80211_rate_get_vht_nss(const struct ieee80211_tx_rate *rate)
  * @band: the band to transmit on (use for checking for races)
  * @hw_queue: HW queue to put the frame on, skb_get_queue_mapping() gives the AC
  * @ack_frame_id: internal frame ID for TX status, used internally
+ * @expected_duration: number of microseconds the stack expects this frame to
+ *	take to tx. Used for fair queuing.
  * @control: union for control data
  * @status: union for status data
  * @driver_data: array of driver_data pointers
@@ -865,11 +877,10 @@ ieee80211_rate_get_vht_nss(const struct ieee80211_tx_rate *rate)
 struct ieee80211_tx_info {
 	/* common information */
 	u32 flags;
-	u8 band;
-
-	u8 hw_queue;
-
-	u16 ack_frame_id;
+	u32 band:2,
+	    hw_queue:5,
+	    ack_frame_id:15,
+	    expected_duration:10;
 
 	union {
 		struct {
@@ -888,8 +899,18 @@ struct ieee80211_tx_info {
 				/* only needed before rate control */
 				unsigned long jiffies;
 			};
-			/* NB: vif can be NULL for injected frames */
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
@@ -2114,8 +2135,8 @@ enum ieee80211_hw_flags {
  * @cipher_schemes: a pointer to an array of cipher scheme definitions
  *	supported by HW.
  *
- * @txq_ac_max_pending: maximum number of frames per AC pending in all txq
- *	entries for a vif.
+ * @txq_cparams: codel parameters to control tx queueing dropping behavior
+ * @txq_limit: maximum number of frames queuesd
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -2145,7 +2166,8 @@ struct ieee80211_hw {
 	u8 uapsd_max_sp_len;
 	u8 n_cipher_schemes;
 	const struct ieee80211_cipher_scheme *cipher_schemes;
-	int txq_ac_max_pending;
+	struct codel_params txq_cparams;
+	u32 txq_limit;
 };
 
 static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
@@ -5633,6 +5655,9 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
  * txq state can change half-way of this function and the caller may end up
  * with "new" frame_cnt and "old" byte_cnt or vice-versa.
  *
+ * Moreover returned values are best-case, i.e. assuming queueing algorithm
+ * will not drop frames due to excess latency.
+ *
  * @txq: pointer obtained from station or virtual interface
  * @frame_cnt: pointer to store frame count
  * @byte_cnt: pointer to store byte count
@@ -5640,4 +5665,55 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 void ieee80211_txq_get_depth(struct ieee80211_txq *txq,
 			     unsigned long *frame_cnt,
 			     unsigned long *byte_cnt);
+
+/**
+ * ieee80211_recalc_fq_period - recalculate fair-queuing period
+ *
+ * This is used to alter the dropping rate to react to possibly changing
+ * (active) station-tid service period and air conditions.
+ *
+ * Driver which implement wake_tx_queue() but don't use ieee80211_tx_schedule()
+ * are encouraged to call this function periodically.
+ *
+* @hw: pointer as obtained from ieee80211_alloc_hw()
+ */
+void ieee80211_recalc_fq_period(struct ieee80211_hw *hw);
+
+/**
+ * ieee80211_tx_schedule - schedule next transmission burst
+ *
+ * This function can be (and should be, preferably) called by drivers that use
+ * wake_tx_queue op. It uses fq-codel like algorithm to maintain fairness.
+ *
+ * This function may call in back to driver (get_expected_throughput op) so
+ * be careful with locking.
+ *
+ * Driver should take care of serializing calls to this functions. Otherwise
+ * fairness can't be guaranteed.
+ *
+ * This function returns the following values:
+ *	-EBUSY		Software queues are not empty yet. The function should
+ *			not be called until after driver's next tx completion.
+ *	-ENOENT		Software queues are empty.
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @wake: callback to driver to handle burst for given txq within given (byte)
+ *	budget. The driver is expected to either call ieee80211_tx_dequeue() or
+ *	use its internal queues (if any). The budget should be respected only
+ *	for frames comming from ieee80211_tx_dequeue(). On termination it is
+ *	expected to return number of frames put onto hw queue that were taken
+ *	via ieee80211_tx_dequeue(). Frames from internal retry queues shall not
+ *	be included in the returned count. If hw queues become/are busy/full
+ *	the driver shall return a negative value which will prompt
+ *	ieee80211_tx_schedule() to terminate. If hw queues become full after at
+ *	least 1 frame dequeued via ieee80211_tx_dequeue() was sent the driver
+ *	is free to report either number of sent frames up until that point or a
+ *	negative value. The driver may return 0 if it wants to skip the txq
+ *	(e.g. target station is in powersave).
+ */
+int ieee80211_tx_schedule(struct ieee80211_hw *hw,
+			  int (*wake)(struct ieee80211_hw *hw,
+				      struct ieee80211_txq *txq,
+				      int budget));
+
 #endif /* MAC80211_H */
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 4932e9f243a2..b9d0cee2a786 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -194,17 +194,21 @@ static void
 ieee80211_agg_stop_txq(struct sta_info *sta, int tid)
 {
 	struct ieee80211_txq *txq = sta->sta.txq[tid];
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_fq *fq;
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
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b37adb60c9cb..238d7bbd275e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3029,7 +3029,7 @@ int ieee80211_attach_ack_skb(struct ieee80211_local *local, struct sk_buff *skb,
 
 	spin_lock_irqsave(&local->ack_status_lock, spin_flags);
 	id = idr_alloc(&local->ack_status_frames, ack_skb,
-		       1, 0x10000, GFP_ATOMIC);
+		       1, 0x8000, GFP_ATOMIC);
 	spin_unlock_irqrestore(&local->ack_status_lock, spin_flags);
 
 	if (id < 0) {
diff --git a/net/mac80211/codel.h b/net/mac80211/codel.h
new file mode 100644
index 000000000000..e6470dbe5b0b
--- /dev/null
+++ b/net/mac80211/codel.h
@@ -0,0 +1,264 @@
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
+#include <linux/version.h>
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
+static inline u64
+custom_codel_get_enqueue_time(struct sk_buff *skb);
+
+static inline struct sk_buff *
+custom_dequeue(struct codel_vars *vars, void *ptr);
+
+static inline void
+custom_drop(struct sk_buff *skb, void *ptr);
+
+static bool codel_should_drop(struct sk_buff *skb,
+			      __u32 *backlog,
+			      __u32 backlog_thr,
+			      struct codel_vars *vars,
+			      const struct codel_params *p,
+			      u64 now)
+{
+	if (!skb) {
+		vars->first_above_time = 0;
+		return false;
+	}
+
+	if (now - custom_codel_get_enqueue_time(skb) < p->target ||
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
+static struct sk_buff *codel_dequeue(void *ptr,
+				     __u32 *backlog,
+				     __u32 backlog_thr,
+				     struct codel_vars *vars,
+				     struct codel_params *p,
+				     u64 now,
+				     bool overloaded)
+{
+	struct sk_buff *skb = custom_dequeue(vars, ptr);
+	bool drop;
+
+	if (!skb) {
+		vars->dropping = false;
+		return skb;
+	}
+	drop = codel_should_drop(skb, backlog, backlog_thr, vars, p, now);
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
+				custom_drop(skb, ptr);
+				vars->drop_count++;
+				skb = custom_dequeue(vars, ptr);
+				if (skb && !codel_should_drop(skb, backlog,
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
+			custom_drop(skb, ptr);
+			vars->drop_count++;
+
+			skb = custom_dequeue(vars, ptr);
+			drop = codel_should_drop(skb, backlog, backlog_thr,
+						 vars, p, now);
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
index 000000000000..a7d23e45dee9
--- /dev/null
+++ b/net/mac80211/codel_i.h
@@ -0,0 +1,89 @@
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
+#include <linux/version.h>
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
+#define MS2TIME(a) (a * (u64) NSEC_PER_MSEC)
+#define US2TIME(a) (a * (u64) NSEC_PER_USEC)
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
+#endif
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 4ab5c522ceee..9b0b8c3d23cd 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -31,6 +31,30 @@ int mac80211_format_buffer(char __user *userbuf, size_t count,
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 
+static int mac80211_parse_buffer(const char __user *userbuf,
+				 size_t count,
+				 loff_t *ppos,
+				 char *fmt, ...)
+{
+	va_list args;
+	char buf[DEBUGFS_FORMAT_BUFFER_SIZE] = {};
+	int res;
+
+	if (count > sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(buf, userbuf, count))
+		return -EFAULT;
+
+	buf[sizeof(buf) - 1] = '\0';
+
+	va_start(args, fmt);
+	res = vsscanf(buf, fmt, args);
+	va_end(args);
+
+	return count;
+}
+
 #define DEBUGFS_READONLY_FILE_FN(name, fmt, value...)			\
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
@@ -70,6 +94,62 @@ DEBUGFS_READONLY_FILE(wep_iv, "%#08x",
 DEBUGFS_READONLY_FILE(rate_ctrl_alg, "%s",
 	local->rate_ctrl ? local->rate_ctrl->ops->name : "hw/driver");
 
+DEBUGFS_READONLY_FILE(fq_drop_overlimit, "%d",
+		      local->fq.drop_overlimit);
+DEBUGFS_READONLY_FILE(fq_drop_codel, "%d",
+		      local->fq.drop_codel);
+DEBUGFS_READONLY_FILE(fq_backlog, "%d",
+		      local->fq.backlog);
+DEBUGFS_READONLY_FILE(fq_in_flight_usec, "%d",
+		      atomic_read(&local->fq.in_flight_usec));
+DEBUGFS_READONLY_FILE(fq_txq_limit, "%d",
+		      local->hw.txq_limit);
+DEBUGFS_READONLY_FILE(fq_txq_interval, "%llu",
+		      local->hw.txq_cparams.interval);
+DEBUGFS_READONLY_FILE(fq_txq_target, "%llu",
+		      local->hw.txq_cparams.target);
+DEBUGFS_READONLY_FILE(fq_ave_period, "%d",
+		      (int)ewma_fq_period_read(&local->fq.ave_period));
+
+#define DEBUGFS_RW_FILE_FN(name, expr)				\
+static ssize_t name## _write(struct file *file,			\
+			     const char __user *userbuf,	\
+			     size_t count,			\
+			     loff_t *ppos)			\
+{								\
+	struct ieee80211_local *local = file->private_data;	\
+	return expr;						\
+}
+
+#define DEBUGFS_RW_FILE(name, expr, fmt, value...)	\
+	DEBUGFS_READONLY_FILE_FN(name, fmt, value)	\
+	DEBUGFS_RW_FILE_FN(name, expr)			\
+	DEBUGFS_RW_FILE_OPS(name)
+
+#define DEBUGFS_RW_FILE_OPS(name)			\
+static const struct file_operations name## _ops = {	\
+	.read = name## _read,				\
+	.write = name## _write,				\
+	.open = simple_open,				\
+	.llseek = generic_file_llseek,			\
+};
+
+#define DEBUGFS_RW_EXPR_FQ(name)					\
+({									\
+	int res;							\
+	res = mac80211_parse_buffer(userbuf, count, ppos, "%d", &name);	\
+	ieee80211_recalc_fq_period(&local->hw);				\
+	res;								\
+})
+
+DEBUGFS_RW_FILE(fq_min_txops_target,   DEBUGFS_RW_EXPR_FQ(local->fq.min_txops_target),   "%d",  local->fq.min_txops_target);
+DEBUGFS_RW_FILE(fq_max_txops_per_txq,  DEBUGFS_RW_EXPR_FQ(local->fq.max_txops_per_txq),  "%d",  local->fq.max_txops_per_txq);
+DEBUGFS_RW_FILE(fq_min_txops_per_hw,   DEBUGFS_RW_EXPR_FQ(local->fq.min_txops_per_hw),   "%d",  local->fq.min_txops_per_hw);
+DEBUGFS_RW_FILE(fq_max_txops_per_hw,   DEBUGFS_RW_EXPR_FQ(local->fq.max_txops_per_hw),   "%d",  local->fq.max_txops_per_hw);
+DEBUGFS_RW_FILE(fq_txop_mixed_usec,    DEBUGFS_RW_EXPR_FQ(local->fq.txop_mixed_usec),    "%d",  local->fq.txop_mixed_usec);
+DEBUGFS_RW_FILE(fq_txop_green_usec,    DEBUGFS_RW_EXPR_FQ(local->fq.txop_green_usec),    "%d",  local->fq.txop_green_usec);
+
+
 #ifdef CONFIG_PM
 static ssize_t reset_write(struct file *file, const char __user *user_buf,
 			   size_t count, loff_t *ppos)
@@ -177,8 +257,178 @@ static ssize_t queues_read(struct file *file, char __user *user_buf,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
 }
 
+static ssize_t fq_read(struct file *file, char __user *user_buf,
+		       size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+	struct txq_flow *flow;
+	struct txq_info *txqi;
+	void *buf;
+	int new_flows;
+	int old_flows;
+	int len;
+	int i;
+	int rv;
+	int res = 0;
+	static const u8 zeroaddr[ETH_ALEN];
+
+	len = 32 * 1024;
+	buf = kzalloc(len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	spin_lock_bh(&local->fq.lock);
+	rcu_read_lock();
+
+	list_for_each_entry(txqi, &local->fq.new_flows, flowchain) {
+		res += scnprintf(buf + res, len - res,
+				 "sched new txqi vif %s sta %pM tid %d deficit %d\n",
+				 container_of(txqi->txq.vif, struct ieee80211_sub_if_data, vif)->name,
+				 txqi->txq.sta ? txqi->txq.sta->addr : zeroaddr,
+				 txqi->txq.tid,
+				 txqi->deficit);
+	}
+
+	list_for_each_entry(txqi, &local->fq.old_flows, flowchain) {
+		res += scnprintf(buf + res, len - res,
+				 "sched old txqi vif %s sta %pM tid %d deficit %d\n",
+				 container_of(txqi->txq.vif, struct ieee80211_sub_if_data, vif)->name,
+				 txqi->txq.sta ? txqi->txq.sta->addr : zeroaddr,
+				 txqi->txq.tid,
+				 txqi->deficit);
+	}
+
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+			if (!sta->sta.txq[i])
+				continue;
+
+			txqi = container_of(sta->sta.txq[i], struct txq_info, txq);
+			if (!txqi->backlog_bytes)
+				continue;
+
+			new_flows = 0;
+			old_flows = 0;
+
+			list_for_each_entry(flow, &txqi->new_flows, flowchain)
+				new_flows++;
+			list_for_each_entry(flow, &txqi->old_flows, flowchain)
+				old_flows++;
+
+			res += scnprintf(buf + res, len - res,
+					 "sta %pM tid %d backlog (%db %dp) flows (%d new %d old) burst %d bpu %d in-flight %d\n",
+					 sta->sta.addr,
+					 i,
+					 txqi->backlog_bytes,
+					 txqi->backlog_packets,
+					 new_flows,
+					 old_flows,
+					 txqi->bytes_per_burst,
+					 txqi->bytes_per_usec,
+					 atomic_read(&txqi->in_flight_usec)
+					);
+
+			flow = &txqi->flow;
+			res += scnprintf(buf + res, len - res,
+					 "sta %pM def flow %p backlog (%db %dp)\n",
+					 sta->sta.addr,
+					 flow,
+					 flow->backlog,
+					 flow->queue.qlen
+				);
+
+			list_for_each_entry(flow, &txqi->new_flows, flowchain)
+				res += scnprintf(buf + res, len - res,
+						 "sta %pM tid %d new flow %p backlog (%db %dp)\n",
+						 sta->sta.addr,
+						 i,
+						 flow,
+						 flow->backlog,
+						 flow->queue.qlen
+					);
+
+			list_for_each_entry(flow, &txqi->old_flows, flowchain)
+				res += scnprintf(buf + res, len - res,
+						 "sta %pM tid %d old flow %p backlog (%db %dp)\n",
+						 sta->sta.addr,
+						 i,
+						 flow,
+						 flow->backlog,
+						 flow->queue.qlen
+					);
+		}
+	}
+
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!sdata->vif.txq)
+			continue;
+
+		txqi = container_of(sdata->vif.txq, struct txq_info, txq);
+		if (!txqi->backlog_bytes)
+			continue;
+
+		new_flows = 0;
+		old_flows = 0;
+
+		list_for_each_entry(flow, &txqi->new_flows, flowchain)
+			new_flows++;
+		list_for_each_entry(flow, &txqi->old_flows, flowchain)
+			old_flows++;
+
+		res += scnprintf(buf + res, len - res,
+				 "vif %s backlog (%db %dp) flows (%d new %d old) burst %d bpu %d in-flight %d\n",
+				 sdata->name,
+				 txqi->backlog_bytes,
+				 txqi->backlog_packets,
+				 new_flows,
+				 old_flows,
+				 txqi->bytes_per_burst,
+				 txqi->bytes_per_usec,
+				 atomic_read(&txqi->in_flight_usec)
+				);
+
+		flow = &txqi->flow;
+		res += scnprintf(buf + res, len - res,
+				 "vif %s def flow %p backlog (%db %dp)\n",
+				 sdata->name,
+				 flow,
+				 flow->backlog,
+				 flow->queue.qlen
+			);
+
+		list_for_each_entry(flow, &txqi->new_flows, flowchain)
+			res += scnprintf(buf + res, len - res,
+					 "vif %s new flow %p backlog (%db %dp)\n",
+					 sdata->name,
+					 flow,
+					 flow->backlog,
+					 flow->queue.qlen
+				);
+
+		list_for_each_entry(flow, &txqi->old_flows, flowchain)
+			res += scnprintf(buf + res, len - res,
+					 "vif %s old flow %p backlog (%db %dp)\n",
+					 sdata->name,
+					 flow,
+					 flow->backlog,
+					 flow->queue.qlen
+				);
+	}
+
+	rcu_read_unlock();
+	spin_unlock_bh(&local->fq.lock);
+
+	rv = simple_read_from_buffer(user_buf, count, ppos, buf, res);
+	kfree(buf);
+
+	return rv;
+}
+
 DEBUGFS_READONLY_FILE_OPS(hwflags);
 DEBUGFS_READONLY_FILE_OPS(queues);
+DEBUGFS_READONLY_FILE_OPS(fq);
 
 /* statistics stuff */
 
@@ -247,6 +497,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(queues);
+	DEBUGFS_ADD(fq);
 #ifdef CONFIG_PM
 	DEBUGFS_ADD_MODE(reset, 0200);
 #endif
@@ -254,6 +505,22 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
 
+	DEBUGFS_ADD(fq_drop_overlimit);
+	DEBUGFS_ADD(fq_drop_codel);
+	DEBUGFS_ADD(fq_backlog);
+	DEBUGFS_ADD(fq_in_flight_usec);
+	DEBUGFS_ADD(fq_txq_limit);
+	DEBUGFS_ADD(fq_txq_interval);
+	DEBUGFS_ADD(fq_txq_target);
+	DEBUGFS_ADD(fq_ave_period);
+
+	DEBUGFS_ADD(fq_min_txops_target);
+	DEBUGFS_ADD(fq_max_txops_per_txq);
+	DEBUGFS_ADD(fq_min_txops_per_hw);
+	DEBUGFS_ADD(fq_max_txops_per_hw);
+	DEBUGFS_ADD(fq_txop_mixed_usec);
+	DEBUGFS_ADD(fq_txop_green_usec);
+
 	statsd = debugfs_create_dir("statistics", phyd);
 
 	/* if the dir failed, don't put all the other things into the root! */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f1565ce35273..443c941d5917 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -805,9 +805,18 @@ enum txq_info_flags {
 };
 
 struct txq_info {
-	struct sk_buff_head queue;
+	struct txq_flow flow;
+	struct list_head flowchain;
+	struct list_head new_flows;
+	struct list_head old_flows;
+	int backlog_bytes;
+	int backlog_packets;
+	int bytes_per_burst;
+	int bytes_per_usec;
+	int deficit;
+	int in_flight_delta_usec;
+	atomic_t in_flight_usec;
 	unsigned long flags;
-	unsigned long byte_cnt;
 
 	/* keep last! */
 	struct ieee80211_txq txq;
@@ -855,7 +864,6 @@ struct ieee80211_sub_if_data {
 	bool control_port_no_encrypt;
 	int encrypt_headroom;
 
-	atomic_t txqs_len[IEEE80211_NUM_ACS];
 	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
 	struct mac80211_qos_map __rcu *qos_map;
 
@@ -1092,11 +1100,37 @@ enum mac80211_scan_state {
 	SCAN_ABORT,
 };
 
+DECLARE_EWMA(fq_period, 16, 4)
+
+struct ieee80211_fq {
+	struct txq_flow *flows;
+	struct list_head backlogs;
+	struct list_head old_flows;
+	struct list_head new_flows;
+	struct ewma_fq_period ave_period;
+	spinlock_t lock;
+	atomic_t in_flight_usec;
+	int flows_cnt;
+	int perturbation;
+	int quantum;
+	int backlog;
+	int min_txops_target;
+	int max_txops_per_txq;
+	int min_txops_per_hw;
+	int max_txops_per_hw;
+	int txop_mixed_usec;
+	int txop_green_usec;
+
+	int drop_overlimit;
+	int drop_codel;
+};
+
 struct ieee80211_local {
 	/* embed the driver visible part.
 	 * don't cast (use the static inlines below), but we keep
 	 * it first anyway so they become a no-op */
 	struct ieee80211_hw hw;
+	struct ieee80211_fq fq;
 
 	const struct ieee80211_ops *ops;
 
@@ -1928,6 +1962,11 @@ static inline bool ieee80211_can_run_worker(struct ieee80211_local *local)
 void ieee80211_init_tx_queue(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta,
 			     struct txq_info *txq, int tid);
+void ieee80211_purge_txq(struct ieee80211_local *local, struct txq_info *txqi);
+void ieee80211_init_flow(struct txq_flow *flow);
+int ieee80211_setup_flows(struct ieee80211_local *local);
+void ieee80211_teardown_flows(struct ieee80211_local *local);
+
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *bssid,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 453b4e741780..d1063b50f12c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -779,6 +779,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			      bool going_down)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_fq *fq = &local->fq;
 	unsigned long flags;
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
@@ -977,12 +978,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.txq) {
 		struct txq_info *txqi = to_txq_info(sdata->vif.txq);
 
-		spin_lock_bh(&txqi->queue.lock);
-		ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
-		txqi->byte_cnt = 0;
-		spin_unlock_bh(&txqi->queue.lock);
-
-		atomic_set(&sdata->txqs_len[txqi->txq.ac], 0);
+		spin_lock_bh(&fq->lock);
+		ieee80211_purge_txq(local, txqi);
+		spin_unlock_bh(&fq->lock);
 	}
 
 	if (local->open_count == 0)
@@ -1198,6 +1196,13 @@ static void ieee80211_if_setup(struct net_device *dev)
 	dev->destructor = ieee80211_if_free;
 }
 
+static void ieee80211_if_setup_no_queue(struct net_device *dev)
+{
+	ieee80211_if_setup(dev);
+	dev->priv_flags |= IFF_NO_QUEUE;
+	/* Note for backporters: use dev->tx_queue_len = 0 instead of IFF_ */
+}
+
 static void ieee80211_iface_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -1707,6 +1712,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	struct net_device *ndev = NULL;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct txq_info *txqi;
+	void (*if_setup)(struct net_device *dev);
 	int ret, i;
 	int txqs = 1;
 
@@ -1734,12 +1740,17 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			txq_size += sizeof(struct txq_info) +
 				    local->hw.txq_data_size;
 
+		if (local->ops->wake_tx_queue)
+			if_setup = ieee80211_if_setup_no_queue;
+		else
+			if_setup = ieee80211_if_setup;
+
 		if (local->hw.queues >= IEEE80211_NUM_ACS)
 			txqs = IEEE80211_NUM_ACS;
 
 		ndev = alloc_netdev_mqs(size + txq_size,
 					name, name_assign_type,
-					ieee80211_if_setup, txqs, 1);
+					if_setup, txqs, 1);
 		if (!ndev)
 			return -ENOMEM;
 		dev_net_set(ndev, wiphy_net(local->hw.wiphy));
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8190bf27ebff..9fd3b10ae52b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1053,9 +1053,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	local->dynamic_ps_forced_timeout = -1;
 
-	if (!local->hw.txq_ac_max_pending)
-		local->hw.txq_ac_max_pending = 64;
-
 	result = ieee80211_wep_init(local);
 	if (result < 0)
 		wiphy_debug(local->hw.wiphy, "Failed to initialize wep: %d\n",
@@ -1087,6 +1084,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	rtnl_unlock();
 
+	result = ieee80211_setup_flows(local);
+	if (result)
+		goto fail_flows;
+
 #ifdef CONFIG_INET
 	local->ifa_notifier.notifier_call = ieee80211_ifa_changed;
 	result = register_inetaddr_notifier(&local->ifa_notifier);
@@ -1112,6 +1113,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
  fail_ifa:
 #endif
+	ieee80211_teardown_flows(local);
+ fail_flows:
 	rtnl_lock();
 	rate_control_deinitialize(local);
 	ieee80211_remove_interfaces(local);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index dc27becb9b71..70f8f7949bf2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1268,7 +1268,7 @@ static void sta_ps_start(struct sta_info *sta)
 	for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
 		struct txq_info *txqi = to_txq_info(sta->sta.txq[tid]);
 
-		if (!skb_queue_len(&txqi->queue))
+		if (!txqi->backlog_packets)
 			set_bit(tid, &sta->txq_buffered_tids);
 		else
 			clear_bit(tid, &sta->txq_buffered_tids);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 00c82fb152c0..0729046a0144 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -112,11 +112,7 @@ static void __cleanup_single_sta(struct sta_info *sta)
 	if (sta->sta.txq[0]) {
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			struct txq_info *txqi = to_txq_info(sta->sta.txq[i]);
-			int n = skb_queue_len(&txqi->queue);
-
-			ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
-			atomic_sub(n, &sdata->txqs_len[txqi->txq.ac]);
-			txqi->byte_cnt = 0;
+			ieee80211_purge_txq(local, txqi);
 		}
 	}
 
@@ -1193,7 +1189,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 			struct txq_info *txqi = to_txq_info(sta->sta.txq[i]);
 
-			if (!skb_queue_len(&txqi->queue))
+			if (!txqi->backlog_packets)
 				continue;
 
 			drv_wake_tx_queue(local, txqi);
@@ -1630,7 +1626,7 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		for (tid = 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
 			struct txq_info *txqi = to_txq_info(sta->sta.txq[tid]);
 
-			if (!(tids & BIT(tid)) || skb_queue_len(&txqi->queue))
+			if (!(tids & BIT(tid)) || txqi->backlog_packets)
 				continue;
 
 			sta_info_recalc_tim(sta);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 053f5c4fa495..dd9d5f754c57 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -19,6 +19,7 @@
 #include <linux/etherdevice.h>
 #include <linux/rhashtable.h>
 #include "key.h"
+#include "codel_i.h"
 
 /**
  * enum ieee80211_sta_info_flags - Stations flags
@@ -330,6 +331,32 @@ struct mesh_sta {
 
 DECLARE_EWMA(signal, 1024, 8)
 
+struct txq_info;
+
+/**
+ * struct txq_flow - per traffic flow queue
+ *
+ * This structure is used to distinguish and queue different traffic flows
+ * separately for fair queueing/AQM purposes.
+ *
+ * @txqi: txq_info structure it is associated at given time
+ * @flowchain: can be linked to other flows for RR purposes
+ * @backlogchain: can be linked to other flows for backlog sorting purposes
+ * @queue: sk_buff queue
+ * @cvars: codel state vars
+ * @backlog: number of bytes pending in the queue
+ * @deficit: used for fair queueing balancing
+ */
+struct txq_flow {
+	struct txq_info *txqi;
+	struct list_head flowchain;
+	struct list_head backlogchain;
+	struct sk_buff_head queue;
+	struct codel_vars cvars;
+	int backlog;
+	int deficit;
+};
+
 /**
  * struct sta_info - STA information
  *
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 8b1b2ea03eb5..2cd898f8a658 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -502,6 +502,67 @@ static void ieee80211_report_ack_skb(struct ieee80211_local *local,
 	}
 }
 
+static void ieee80211_report_txq_skb(struct ieee80211_local *local,
+				     struct ieee80211_hdr *hdr,
+				     struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_fq *fq = &local->fq;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_txq *txq = NULL;
+	struct sta_info *sta;
+	struct txq_info *txqi;
+	struct rhash_head *tmp;
+	const struct bucket_table *tbl;
+	int tid;
+	__le16 fc = hdr->frame_control;
+	u8 *addr;
+	static const u8 zeroaddr[ETH_ALEN];
+
+	if (!ieee80211_is_data(fc))
+		return;
+
+	rcu_read_lock();
+
+	tbl = rht_dereference_rcu(local->sta_hash.tbl, &local->sta_hash);
+	for_each_sta_info(local, tbl, hdr->addr1, sta, tmp) {
+		/* skip wrong virtual interface */
+		if (!ether_addr_equal(hdr->addr2, sta->sdata->vif.addr))
+			continue;
+
+		tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
+		txq = sta->sta.txq[tid];
+
+		break;
+	}
+
+	if (!txq) {
+		addr = ieee80211_get_DA(hdr);
+		if (is_multicast_ether_addr(addr)) {
+			sdata = ieee80211_sdata_from_skb(local, skb);
+			txq = sdata->vif.txq;
+		}
+	}
+
+	if (txq) {
+		txqi = container_of(txq, struct txq_info, txq);
+		atomic_sub(info->expected_duration, &txqi->in_flight_usec);
+		if (atomic_read(&txqi->in_flight_usec) < 0) {
+			WARN_ON_ONCE(1);
+			print_hex_dump(KERN_DEBUG, "skb: ", DUMP_PREFIX_OFFSET, 16, 1,
+						skb->data, skb->len, 0);
+			printk("underflow: txq tid %d sta %pM vif %s\n",
+					txq->tid,
+					txq->sta ? txq->sta->addr : zeroaddr,
+					container_of(txq->vif, struct ieee80211_sub_if_data, vif)->name);
+		}
+	}
+
+	atomic_sub(info->expected_duration, &fq->in_flight_usec);
+
+	rcu_read_unlock();
+}
+
 static void ieee80211_report_used_skb(struct ieee80211_local *local,
 				      struct sk_buff *skb, bool dropped)
 {
@@ -512,6 +573,9 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 	if (dropped)
 		acked = false;
 
+	if (local->ops->wake_tx_queue)
+		ieee80211_report_txq_skb(local, hdr, skb);
+
 	if (info->flags & IEEE80211_TX_INTFL_MLME_CONN_TX) {
 		struct ieee80211_sub_if_data *sdata;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6040c29a9e17..3072e460e82a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -34,6 +34,7 @@
 #include "wpa.h"
 #include "wme.h"
 #include "rate.h"
+#include "codel.h"
 
 /* misc utils */
 
@@ -1232,27 +1233,335 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	return TX_CONTINUE;
 }
 
-static void ieee80211_drv_tx(struct ieee80211_local *local,
-			     struct ieee80211_vif *vif,
-			     struct ieee80211_sta *pubsta,
-			     struct sk_buff *skb)
+static inline u64
+custom_codel_get_enqueue_time(struct sk_buff *skb)
+{
+	return IEEE80211_SKB_CB(skb)->control.enqueue_time;
+}
+
+static inline struct sk_buff *
+flow_dequeue(struct ieee80211_local *local, struct txq_flow *flow)
+{
+	struct ieee80211_fq *fq = &local->fq;
+	struct txq_info *txqi = flow->txqi;
+	struct txq_flow *i;
+	struct sk_buff *skb;
+
+	skb = __skb_dequeue(&flow->queue);
+	if (!skb)
+		return NULL;
+
+	txqi->backlog_bytes -= skb->len;
+	txqi->backlog_packets--;
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
+		list_move_tail(&flow->backlogchain, &i->backlogchain);
+	}
+
+	return skb;
+}
+
+static inline struct sk_buff *
+custom_dequeue(struct codel_vars *vars, void *ptr)
+{
+	struct txq_flow *flow = ptr;
+	struct txq_info *txqi = flow->txqi;
+	struct ieee80211_vif *vif = txqi->txq.vif;
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+
+	return flow_dequeue(local, flow);
+}
+
+static inline void
+custom_drop(struct sk_buff *skb, void *ptr)
+{
+	struct txq_flow *flow = ptr;
+	struct txq_info *txqi = flow->txqi;
+	struct ieee80211_vif *vif = txqi->txq.vif;
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_hw *hw = &local->hw;
+
+	ieee80211_free_txskb(hw, skb);
+	local->fq.drop_codel++;
+}
+
+static u32 fq_hash(struct ieee80211_fq *fq, struct sk_buff *skb)
+{
+	u32 hash = skb_get_hash_perturb(skb, fq->perturbation);
+	return reciprocal_scale(hash, fq->flows_cnt);
+}
+
+static void fq_drop(struct ieee80211_local *local)
+{
+	struct ieee80211_hw *hw = &local->hw;
+	struct ieee80211_fq *fq = &local->fq;
+	struct txq_flow *flow;
+	struct sk_buff *skb;
+
+	flow = list_first_entry_or_null(&fq->backlogs, struct txq_flow,
+					backlogchain);
+	if (WARN_ON_ONCE(!flow))
+		return;
+
+	skb = flow_dequeue(local, flow);
+	if (WARN_ON_ONCE(!skb))
+		return;
+
+	ieee80211_free_txskb(hw, skb);
+	fq->drop_overlimit++;
+}
+
+void ieee80211_init_flow(struct txq_flow *flow)
+{
+	INIT_LIST_HEAD(&flow->flowchain);
+	INIT_LIST_HEAD(&flow->backlogchain);
+	__skb_queue_head_init(&flow->queue);
+	codel_vars_init(&flow->cvars);
+}
+
+#define MIN_FQ_TARGET_USEC(fq) ((fq)->min_txops_target * (fq)->txop_mixed_usec)
+
+int ieee80211_setup_flows(struct ieee80211_local *local)
+{
+	struct ieee80211_fq *fq = &local->fq;
+	int i;
+
+	if (!local->ops->wake_tx_queue)
+		return 0;
+
+	if (!local->hw.txq_limit)
+		local->hw.txq_limit = 8192;
+
+	memset(fq, 0, sizeof(fq[0]));
+	INIT_LIST_HEAD(&fq->backlogs);
+	INIT_LIST_HEAD(&fq->old_flows);
+	INIT_LIST_HEAD(&fq->new_flows);
+	ewma_fq_period_init(&fq->ave_period);
+	atomic_set(&fq->in_flight_usec, 0);
+	spin_lock_init(&fq->lock);
+	fq->flows_cnt = 4096;
+	fq->perturbation = prandom_u32();
+	fq->quantum = 300;
+	fq->txop_mixed_usec = 5484;
+	fq->txop_green_usec = 10000;
+	fq->min_txops_target = 2;
+	fq->max_txops_per_txq = 1;
+	fq->min_txops_per_hw = 3;
+	fq->max_txops_per_hw = 4;
+
+	if (!local->hw.txq_cparams.target)
+		local->hw.txq_cparams.target = US2TIME(MIN_FQ_TARGET_USEC(fq));
+
+	if (!local->hw.txq_cparams.interval)
+		local->hw.txq_cparams.interval = MS2TIME(100);
+
+	fq->flows = kzalloc(fq->flows_cnt * sizeof(fq->flows[0]), GFP_KERNEL);
+	if (!fq->flows)
+		return -ENOMEM;
+
+	for (i = 0; i < fq->flows_cnt; i++)
+		ieee80211_init_flow(&fq->flows[i]);
+
+	return 0;
+}
+
+static void ieee80211_reset_flow(struct ieee80211_local *local,
+				 struct txq_flow *flow)
+{
+	if (!list_empty(&flow->flowchain))
+		list_del_init(&flow->flowchain);
+
+	if (!list_empty(&flow->backlogchain))
+		list_del_init(&flow->backlogchain);
+
+	ieee80211_purge_tx_queue(&local->hw, &flow->queue);
+
+	flow->deficit = 0;
+	flow->txqi = NULL;
+}
+
+void ieee80211_purge_txq(struct ieee80211_local *local, struct txq_info *txqi)
+{
+	struct txq_flow *flow;
+	int i;
+
+	for (i = 0; i < local->fq.flows_cnt; i++) {
+		flow = &local->fq.flows[i];
+
+		if (flow->txqi != txqi)
+			continue;
+
+		ieee80211_reset_flow(local, flow);
+	}
+
+	ieee80211_reset_flow(local, &txqi->flow);
+
+	txqi->backlog_bytes = 0;
+	txqi->backlog_packets = 0;
+}
+
+void ieee80211_teardown_flows(struct ieee80211_local *local)
+{
+	struct ieee80211_fq *fq = &local->fq;
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+	int i;
+
+	if (!local->ops->wake_tx_queue)
+		return;
+
+	list_for_each_entry_rcu(sta, &local->sta_list, list)
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++)
+			ieee80211_purge_txq(local,
+					    to_txq_info(sta->sta.txq[i]));
+
+	list_for_each_entry_rcu(sdata, &local->interfaces, list)
+		ieee80211_purge_txq(local, to_txq_info(sdata->vif.txq));
+
+	for (i = 0; i < fq->flows_cnt; i++)
+		ieee80211_reset_flow(local, &fq->flows[i]);
+
+	kfree(fq->flows);
+
+	fq->flows = NULL;
+	fq->flows_cnt = 0;
+}
+
+static void ieee80211_txq_enqueue(struct ieee80211_local *local,
+				  struct txq_info *txqi,
+				  struct sk_buff *skb)
+{
+	struct ieee80211_fq *fq = &local->fq;
+	struct ieee80211_hw *hw = &local->hw;
+	struct txq_flow *flow;
+	struct txq_flow *i;
+	size_t idx = fq_hash(fq, skb);
+
+	lockdep_assert_held(&fq->lock);
+
+	flow = &fq->flows[idx];
+
+	if (flow->txqi && flow->txqi != txqi)
+		flow = &txqi->flow;
+
+	/* The following overwrites `vif` pointer effectively. It is later
+	 * restored using txq structure.
+	 */
+	IEEE80211_SKB_CB(skb)->control.enqueue_time = codel_get_time();
+
+	flow->txqi = txqi;
+	flow->backlog += skb->len;
+	txqi->backlog_bytes += skb->len;
+	txqi->backlog_packets++;
+	fq->backlog++;
+
+	if (list_empty(&flow->backlogchain))
+		list_add_tail(&flow->backlogchain, &fq->backlogs);
+
+	i = flow;
+	list_for_each_entry_continue_reverse(i, &fq->backlogs, backlogchain)
+		if (i->backlog > flow->backlog)
+			break;
+
+	list_move(&flow->backlogchain, &i->backlogchain);
+
+	if (list_empty(&flow->flowchain)) {
+		flow->deficit = fq->quantum;
+		list_add_tail(&flow->flowchain, &txqi->new_flows);
+	}
+
+	if (list_empty(&txqi->flowchain)) {
+		txqi->deficit = fq->quantum;
+		list_add_tail(&txqi->flowchain, &fq->new_flows);
+	}
+
+	__skb_queue_tail(&flow->queue, skb);
+
+	if (fq->backlog > hw->txq_limit)
+		fq_drop(local);
+}
+
+static struct sk_buff *ieee80211_txq_dequeue(struct ieee80211_local *local,
+					     struct txq_info *txqi)
+{
+	struct ieee80211_fq *fq = &local->fq;
+	struct ieee80211_hw *hw = &local->hw;
+	struct txq_flow *flow;
+	struct list_head *head;
+	struct sk_buff *skb;
+
+begin:
+	head = &txqi->new_flows;
+	if (list_empty(head)) {
+		head = &txqi->old_flows;
+		if (list_empty(head))
+			return NULL;
+	}
+
+	flow = list_first_entry(head, struct txq_flow, flowchain);
+
+	if (flow->deficit <= 0) {
+		flow->deficit += fq->quantum;
+		list_move_tail(&flow->flowchain, &txqi->old_flows);
+		goto begin;
+	}
+
+	skb = codel_dequeue(flow,
+			    &flow->backlog,
+			    txqi->bytes_per_burst,
+			    &flow->cvars,
+			    &hw->txq_cparams,
+			    codel_get_time(),
+			    false);
+	if (!skb) {
+		if ((head == &txqi->new_flows) &&
+		    !list_empty(&txqi->old_flows)) {
+			list_move_tail(&flow->flowchain, &txqi->old_flows);
+		} else {
+			list_del_init(&flow->flowchain);
+			flow->txqi = NULL;
+		}
+		goto begin;
+	}
+
+	flow->deficit -= skb->len;
+
+	/* The `vif` pointer was overwritten with enqueue time during
+	 * enqueuing. Restore it before handing to driver.
+	 */
+	IEEE80211_SKB_CB(skb)->control.vif = flow->txqi->txq.vif;
+
+	return skb;
+}
+
+static struct txq_info *
+ieee80211_get_txq(struct ieee80211_local *local,
+		  struct ieee80211_vif *vif,
+		  struct ieee80211_sta *pubsta,
+		  struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_tx_control control = {
-		.sta = pubsta,
-	};
 	struct ieee80211_txq *txq = NULL;
-	struct txq_info *txqi;
-	u8 ac;
 
 	if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
 	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
-		goto tx_normal;
+		return NULL;
 
 	if (!ieee80211_is_data(hdr->frame_control))
-		goto tx_normal;
+		return NULL;
 
 	if (pubsta) {
 		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
@@ -1263,57 +1572,48 @@ static void ieee80211_drv_tx(struct ieee80211_local *local,
 	}
 
 	if (!txq)
-		goto tx_normal;
+		return NULL;
 
-	ac = txq->ac;
-	txqi = to_txq_info(txq);
-	atomic_inc(&sdata->txqs_len[ac]);
-	if (atomic_read(&sdata->txqs_len[ac]) >= local->hw.txq_ac_max_pending)
-		netif_stop_subqueue(sdata->dev, ac);
-
-	spin_lock_bh(&txqi->queue.lock);
-	txqi->byte_cnt += skb->len;
-	__skb_queue_tail(&txqi->queue, skb);
-	spin_unlock_bh(&txqi->queue.lock);
-
-	drv_wake_tx_queue(local, txqi);
-
-	return;
-
-tx_normal:
-	drv_tx(local, &control, skb);
+	return to_txq_info(txq);
 }
 
+#define TXQI_BYTES_TO_USEC(txqi, bytes) \
+		DIV_ROUND_UP((bytes), max_t(int, 1, (txqi)->bytes_per_usec))
+
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 				     struct ieee80211_txq *txq)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->vif);
+	struct ieee80211_fq *fq = &local->fq;
+	struct ieee80211_tx_info *info;
 	struct txq_info *txqi = container_of(txq, struct txq_info, txq);
 	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb = NULL;
-	u8 ac = txq->ac;
+	int duration_usec;
 
-	spin_lock_bh(&txqi->queue.lock);
+	spin_lock_bh(&fq->lock);
 
 	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
 		goto out;
 
-	skb = __skb_dequeue(&txqi->queue);
+	skb = ieee80211_txq_dequeue(local, txqi);
 	if (!skb)
 		goto out;
 
-	txqi->byte_cnt -= skb->len;
+	duration_usec = TXQI_BYTES_TO_USEC(txqi, skb->len);
+	duration_usec = min_t(int, BIT(10) - 1, duration_usec);
 
-	atomic_dec(&sdata->txqs_len[ac]);
-	if (__netif_subqueue_stopped(sdata->dev, ac))
-		ieee80211_propagate_queue_wake(local, sdata->vif.hw_queue[ac]);
+	info = IEEE80211_SKB_CB(skb);
+	info->expected_duration = duration_usec;
+
+	txqi->in_flight_delta_usec += duration_usec;
+	atomic_add(duration_usec, &txqi->in_flight_usec);
+	atomic_add(duration_usec, &fq->in_flight_usec);
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
 		struct sta_info *sta = container_of(txq->sta, struct sta_info,
 						    sta);
-		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 		hdr->seq_ctrl = ieee80211_tx_next_seq(sta, txq->tid);
 		if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
@@ -1323,19 +1623,274 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	}
 
 out:
-	spin_unlock_bh(&txqi->queue.lock);
+	spin_unlock_bh(&fq->lock);
 
 	return skb;
 }
 EXPORT_SYMBOL(ieee80211_tx_dequeue);
 
+static u16 ieee80211_get_txop_usec(struct ieee80211_local *local,
+				   struct txq_info *txqi)
+{
+	struct ieee80211_sub_if_data *sdata;
+	u16 txop_usec;
+
+	sdata = container_of(txqi->txq.vif, struct ieee80211_sub_if_data, vif);
+	txop_usec = sdata->tx_conf[txqi->txq.ac].txop * 32;
+
+	/* How to pick between mixed/greenfield txops? */
+	if (txop_usec == 0)
+		txop_usec = local->fq.txop_mixed_usec;
+
+	return txop_usec;
+}
+
+static u32 ieee80211_get_tput_kbps(struct ieee80211_local *local,
+				   struct txq_info *txqi)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	enum ieee80211_band band;
+	struct rate_control_ref *ref = NULL;
+	struct sta_info *sta;
+	int idx;
+	u32 tput;
+
+	if (txqi->txq.sta) {
+		sta = container_of(txqi->txq.sta, struct sta_info, sta);
+
+		if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
+			ref = local->rate_ctrl;
+
+		if (ref)
+			tput = ref->ops->get_expected_throughput(sta->rate_ctrl_priv);
+		else if (local->ops->get_expected_throughput)
+			tput = drv_get_expected_throughput(local, &sta->sta);
+		else
+			tput = 0;
+	} else {
+		sdata = container_of(txqi->txq.vif, struct ieee80211_sub_if_data, vif);
+
+		rcu_read_lock();
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		band = chanctx_conf->def.chan->band;
+		rcu_read_unlock();
+
+		sband = local->hw.wiphy->bands[band];
+		idx = sdata->vif.bss_conf.mcast_rate[band];
+		if (idx > 0) {
+			/* Convert units from 100Kbps and assume 20% MAC
+			 * overhead, i.e. 80% efficiency.
+			 */
+			tput = sband[band].bitrates[idx].bitrate * 100;
+			tput = (tput * 8) / 10;
+		} else {
+			tput = 1000;
+		}
+	}
+
+	return tput;
+}
+
+static void ieee80211_recalc_txqi_tput(struct ieee80211_local *local,
+				       struct txq_info *txqi)
+{
+	struct ieee80211_fq *fq = &local->fq;
+	int tput_kbps;
+	int txop_usec;
+
+	lockdep_assert_held(&fq->lock);
+
+	tput_kbps = ieee80211_get_tput_kbps(local, txqi);
+	txop_usec = ieee80211_get_txop_usec(local, txqi);
+	txqi->bytes_per_usec = max_t(int, 1, DIV_ROUND_UP(1024 * (tput_kbps/8),
+							  USEC_PER_SEC));
+	txqi->bytes_per_burst = max_t(int, 1, txop_usec * txqi->bytes_per_usec);
+}
+
+void ieee80211_recalc_fq_period(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_fq *fq = &local->fq;
+	struct txq_info *txqi;
+	int period = 0;
+	int target_usec;
+
+	spin_lock_bh(&fq->lock);
+
+	list_for_each_entry(txqi, &fq->new_flows, flowchain) {
+		ieee80211_recalc_txqi_tput(local, txqi);
+
+		period += TXQI_BYTES_TO_USEC(txqi, min(txqi->backlog_bytes,
+						       txqi->bytes_per_burst));
+	}
+
+	list_for_each_entry(txqi, &fq->old_flows, flowchain) {
+		ieee80211_recalc_txqi_tput(local, txqi);
+
+		period += TXQI_BYTES_TO_USEC(txqi, min(txqi->backlog_bytes,
+						       txqi->bytes_per_burst));
+	}
+
+	ewma_fq_period_add(&fq->ave_period, period);
+
+	target_usec = ewma_fq_period_read(&fq->ave_period);
+	target_usec = max_t(u64, target_usec, MIN_FQ_TARGET_USEC(fq));
+	hw->txq_cparams.target = US2TIME(target_usec);
+
+	spin_unlock_bh(&fq->lock);
+}
+EXPORT_SYMBOL(ieee80211_recalc_fq_period);
+
+static int ieee80211_tx_sched_budget(struct ieee80211_local *local,
+				     struct txq_info *txqi)
+{
+	int txop_usec;
+	int budget;
+
+	/* XXX: Should this consider per-txq or per-sta in flight duration? */
+	txop_usec = ieee80211_get_txop_usec(local, txqi);
+	budget = local->fq.max_txops_per_txq * txop_usec;
+	budget -= atomic_read(&txqi->in_flight_usec);
+	budget = min(budget, txop_usec);
+	budget *= min_t(int, 1, txqi->bytes_per_usec);
+
+	return budget;
+}
+
+static void ieee80211_tx_sched_next_txqi(struct ieee80211_local *local,
+					 struct list_head **list,
+					 struct list_head **head)
+{
+	struct ieee80211_fq *fq = &local->fq;
+
+	if (!*list) {
+		*head = &fq->new_flows;
+		*list = *head;
+	}
+
+	*list = (*list)->next;
+
+	if (*list != *head)
+		return;
+
+	if (*head == &fq->new_flows) {
+		*head = &fq->old_flows;
+		*list = *head;
+		ieee80211_tx_sched_next_txqi(local, list, head);
+		return;
+	}
+
+	*head = NULL;
+	*list = NULL;
+}
+
+int ieee80211_tx_schedule(struct ieee80211_hw *hw,
+			  int (*wake)(struct ieee80211_hw *hw,
+				      struct ieee80211_txq *txq,
+				      int budget))
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_fq *fq = &local->fq;
+	struct list_head *list = NULL;
+	struct list_head *head = NULL;
+	struct txq_info *txqi = NULL;
+	int min_in_flight_usec;
+	int max_in_flight_usec;
+	int in_flight_usec;
+	int ret = 0;
+	int budget;
+
+	rcu_read_lock();
+	spin_lock_bh(&fq->lock);
+
+	min_in_flight_usec = fq->min_txops_per_hw * fq->txop_mixed_usec;
+	max_in_flight_usec = fq->max_txops_per_hw * fq->txop_mixed_usec;
+	in_flight_usec = atomic_read(&fq->in_flight_usec);
+
+	if (in_flight_usec >= min_in_flight_usec) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	for (;;) {
+		if (in_flight_usec >= max_in_flight_usec) {
+			ret = -EBUSY;
+			break;
+		}
+
+		if (list && list_is_last(list, &fq->old_flows)) {
+			ret = -EBUSY;
+			break;
+		}
+
+		ieee80211_tx_sched_next_txqi(local, &list, &head);
+		if (!list) {
+			ret = -ENOENT;
+			break;
+		}
+
+		txqi = list_entry(list, struct txq_info, flowchain);
+
+		if (txqi->deficit < 0) {
+			txqi->deficit += fq->quantum;
+			list_move_tail(&txqi->flowchain, &fq->old_flows);
+			list = NULL;
+			continue;
+		}
+
+		budget = ieee80211_tx_sched_budget(local, txqi);
+		txqi->in_flight_delta_usec = 0;
+
+		spin_unlock_bh(&fq->lock);
+		ret = wake(hw, &txqi->txq, budget);
+		spin_lock_bh(&fq->lock);
+
+		if (ret > 0) {
+			txqi->deficit -= txqi->in_flight_delta_usec;
+			in_flight_usec += txqi->in_flight_delta_usec;
+		}
+
+		if (!txqi->backlog_bytes) {
+			if (head == &fq->new_flows && !list_empty(&fq->old_flows)) {
+				list_move_tail(&txqi->flowchain, &fq->old_flows);
+			} else {
+				list_del_init(&txqi->flowchain);
+			}
+
+			list = NULL;
+		}
+
+		if (ret < 0) {
+			ret = -EBUSY;
+			break;
+		} else if (ret == 0 && txqi) {
+			/* `list` is not reset to skip over */
+			continue;
+		}
+
+		list = NULL;
+	}
+
+unlock:
+	spin_unlock_bh(&fq->lock);
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(ieee80211_tx_schedule);
+
 static bool ieee80211_tx_frags(struct ieee80211_local *local,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
 			       struct sk_buff_head *skbs,
 			       bool txpending)
 {
+	struct ieee80211_fq *fq = &local->fq;
+	struct ieee80211_tx_control control = {};
 	struct sk_buff *skb, *tmp;
+	struct txq_info *txqi;
 	unsigned long flags;
 
 	skb_queue_walk_safe(skbs, skb, tmp) {
@@ -1350,6 +1905,24 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		}
 #endif
 
+		/* XXX: This changes behavior for offchan-tx. Is this really a
+		 *      problem with per-sta-tid queueing now?
+		 */
+		txqi = ieee80211_get_txq(local, vif, sta, skb);
+		if (txqi) {
+			info->control.vif = vif;
+
+			__skb_unlink(skb, skbs);
+
+			spin_lock_bh(&fq->lock);
+			ieee80211_txq_enqueue(local, txqi, skb);
+			spin_unlock_bh(&fq->lock);
+
+			drv_wake_tx_queue(local, txqi);
+
+			continue;
+		}
+
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		if (local->queue_stop_reasons[q] ||
 		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
@@ -1392,9 +1965,10 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 		info->control.vif = vif;
+		control.sta = sta;
 
 		__skb_unlink(skb, skbs);
-		ieee80211_drv_tx(local, vif, sta, skb);
+		drv_tx(local, &control, skb);
 	}
 
 	return true;
@@ -2381,7 +2955,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 			spin_lock_irqsave(&local->ack_status_lock, flags);
 			id = idr_alloc(&local->ack_status_frames, ack_skb,
-				       1, 0x10000, GFP_ATOMIC);
+				       1, 0x8000, GFP_ATOMIC);
 			spin_unlock_irqrestore(&local->ack_status_lock, flags);
 
 			if (id >= 0) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0319d6d4f863..afb1bbf9b3f4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -244,6 +244,9 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 	struct ieee80211_sub_if_data *sdata;
 	int n_acs = IEEE80211_NUM_ACS;
 
+	if (local->ops->wake_tx_queue)
+		return;
+
 	if (local->hw.queues < IEEE80211_NUM_ACS)
 		n_acs = 1;
 
@@ -260,11 +263,6 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 		for (ac = 0; ac < n_acs; ac++) {
 			int ac_queue = sdata->vif.hw_queue[ac];
 
-			if (local->ops->wake_tx_queue &&
-			    (atomic_read(&sdata->txqs_len[ac]) >
-			     local->hw.txq_ac_max_pending))
-				continue;
-
 			if (ac_queue == queue ||
 			    (sdata->vif.cab_queue == queue &&
 			     local->queue_stop_reasons[ac_queue] == 0 &&
@@ -352,6 +350,9 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 	if (__test_and_set_bit(reason, &local->queue_stop_reasons[queue]))
 		return;
 
+	if (local->ops->wake_tx_queue)
+		return;
+
 	if (local->hw.queues < IEEE80211_NUM_ACS)
 		n_acs = 1;
 
@@ -3392,8 +3393,12 @@ void ieee80211_init_tx_queue(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta,
 			     struct txq_info *txqi, int tid)
 {
-	skb_queue_head_init(&txqi->queue);
+	INIT_LIST_HEAD(&txqi->flowchain);
+	INIT_LIST_HEAD(&txqi->old_flows);
+	INIT_LIST_HEAD(&txqi->new_flows);
+	ieee80211_init_flow(&txqi->flow);
 	txqi->txq.vif = &sdata->vif;
+	txqi->flow.txqi = txqi;
 
 	if (sta) {
 		txqi->txq.sta = &sta->sta;
@@ -3414,9 +3419,9 @@ void ieee80211_txq_get_depth(struct ieee80211_txq *txq,
 	struct txq_info *txqi = to_txq_info(txq);
 
 	if (frame_cnt)
-		*frame_cnt = txqi->queue.qlen;
+		*frame_cnt = txqi->backlog_packets;
 
 	if (byte_cnt)
-		*byte_cnt = txqi->byte_cnt;
+		*byte_cnt = txqi->backlog_bytes;
 }
 EXPORT_SYMBOL(ieee80211_txq_get_depth);
-- 
2.1.4

