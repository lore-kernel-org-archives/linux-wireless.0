Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:53310 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751054AbXLIUZp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 15:25:45 -0500
Date: Sun, 9 Dec 2007 21:19:31 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour learning
 algorithm
Message-ID: <20071209211931.26ff42fa@morte> (sfid-20071209_202549_268087_C5AD0A49)
In-Reply-To: <20071209211547.2d7fca32@morte>
References: <20071209211547.2d7fca32@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces a learning algorithm in order for the PID controller
to learn how to map adjustment values to rates. This is better described in
code comments.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

Index: wireless-2.6/net/mac80211/rc80211_pid.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid.c
+++ wireless-2.6/net/mac80211/rc80211_pid.c
@@ -2,6 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
  * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
+ * Copyright 2007, Stefano Brivio <stefano.brivio@polimi.it>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -39,12 +40,18 @@
  * an actual sliding window. Advantage is that we don't need to keep an array of
  * the last N error values and computation is easier.
  *
- * Once we have the adj value, we need to map it to a TX rate to be selected.
- * For now, we depend on the rates to be ordered in a way such that more robust
- * rates (i.e. such that exhibit a lower framed failed percentage) come first.
- * E.g. for the 802.11b/g case, we first have the b rates in ascending order,
- * then the g rates. The adj simply decides the index of the TX rate in the list
- * to switch to (relative to the current TX rate entry).
+ * Once we have the adj value, we map it to a rate by means of a learning
+ * algorithm. This algorithm keeps the state of the percentual failed frames
+ * difference between rates. The behaviour of the lowest available rate is kept
+ * as a reference value, and every time we switch between two rates, we compute
+ * the difference between the failed frames each rate exhibited. By doing so,
+ * we compare behaviours which different rates exhibited in adjacent timeslices,
+ * thus the comparison is minimally affected by external conditions. This
+ * difference gets propagated to the whole set of measurements, so that the
+ * reference is always the same. Periodically, we normalize this set so that
+ * recent events weigh the most. By comparing the adj value with this set, we
+ * avoid pejorative switches to lower rates and allow for switches to higher
+ * rates if they behaved well.
  *
  * Note that for the computations we use a fixed-point representation to avoid
  * floating point arithmetic. Hence, all values are shifted left by
@@ -71,6 +78,12 @@
 /* Derivative PID component coefficient. */
 #define RC_PID_COEFF_D 15
 
+/* Rate behaviour normalization quantity over time. */
+#define RC_PID_NORM_FACTOR 3
+
+/* Push high rates right after loading. */
+#define RC_PID_FAST_START 0
+
 /* Target failed frames rate for the PID controller. NB: This effectively gives
  * maximum failed frames percentage we're willing to accept. If communication is
  * good, the controller will fail to adjust failed frames percentage to the
@@ -121,6 +134,18 @@ struct rc_pid_sta_info {
 /* Algorithm parameters. We keep them on a per-algorithm approach, so they can
  * be tuned individually for each interface.
  */
+struct rc_pid_rateinfo {
+
+	/* The rate index in ieee80211_hw_mode. */
+	int index;
+
+	/* Did we do any measurement on this rate? */
+	bool valid;
+
+	/* Comparison with the lowest rate. */
+	int diff;
+};
+
 struct rc_pid_info {
 
 	/* The failed frames percentage target. */
@@ -130,15 +155,59 @@ struct rc_pid_info {
 	s32 coeff_p;
 	s32 coeff_i;
 	s32 coeff_d;
+
+	/* Rates information. */
+	struct rc_pid_rateinfo *rinfo;
+
+	/* Index of the last used rate. */
+	int oldrate;
 };
 
+/* Shift the adjustment so that we won't switch to a lower rate if it exhibited
+ * a worse failed frames behaviour and we'll choose the highest rate whose
+ * failed frames behaviour is not worse than the one of the original rate
+ * target. While at it, check that the adjustment is within the ranges. Then,
+ * provide the new rate index. */
+static int rate_control_pid_shift_adjust(struct rc_pid_rateinfo *r,
+					 int adj, int cur, int l)
+{
+	int i, j, k, tmp;
+
+	if (cur + adj < 0)
+		return 0;
+	if (cur + adj >= l)
+		return l - 1;
+
+	for (i = 0; i < l; i++)
+		if (r[i].index == cur + adj)
+			break;
+	if (unlikely(!r[i].valid))
+		return cur + adj;
+	for (j = 0; j < l; j++)
+		if (r[j].index == cur)
+			break;
+
+	if (adj < 0) {
+		if (r[i].diff > r[j].diff)
+			return cur;
+	} else {
+		tmp = r[i].diff;
+		for (k = i + 1; k + cur < l; k++)
+			if (r[k].valid && r[k].diff <= tmp) {
+				tmp = r[k].diff;
+				adj = k;
+			}
+	}
+	return cur + adj;
+}
 
 static void rate_control_pid_adjust_rate(struct ieee80211_local *local,
-					 struct sta_info *sta, int adj)
+					 struct sta_info *sta, int adj,
+					 struct rc_pid_rateinfo *rinfo)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hw_mode *mode;
-	int newidx = sta->txrate + adj;
+	int newidx;
 	int maxrate;
 	int back = (adj > 0) ? 1 : -1;
 
@@ -151,10 +220,8 @@ static void rate_control_pid_adjust_rate
 	mode = local->oper_hw_mode;
 	maxrate = sdata->bss ? sdata->bss->max_ratectrl_rateidx : -1;
 
-	if (newidx < 0)
-		newidx = 0;
-	else if (newidx >= mode->num_rates)
-		newidx = mode->num_rates - 1;
+	newidx = rate_control_pid_shift_adjust(rinfo, adj, sta->txrate,
+					       mode->num_rates);
 
 	while (newidx != sta->txrate) {
 		if (rate_supported(sta, mode, newidx) &&
@@ -167,18 +234,39 @@ static void rate_control_pid_adjust_rate
 	}
 }
 
+/* Normalize the failed frames per-rate differences. */
+static void rate_control_pid_normalize(struct rc_pid_rateinfo *r, int l)
+{
+	int i;
+
+	if (r[0].diff > RC_PID_NORM_FACTOR)
+		r[0].diff -= RC_PID_NORM_FACTOR;
+	else if (r[0].diff < -RC_PID_NORM_FACTOR)
+		r[0].diff += RC_PID_NORM_FACTOR;
+	for (i = 0; i < l - 1; i++)
+		if (likely(r[i + 1].valid)) {
+			if (r[i + 1].diff > r[i].diff + RC_PID_NORM_FACTOR)
+				r[i + 1].diff -= RC_PID_NORM_FACTOR;
+			else if (r[i + 1].diff <= r[i].diff)
+				r[i + 1].diff += RC_PID_NORM_FACTOR;
+		}
+}
+
 static void rate_control_pid_sample(struct rc_pid_info *pinfo,
 				    struct ieee80211_local *local,
 				    struct sta_info *sta)
 {
 	struct rc_pid_sta_info *spinfo = sta->rate_ctrl_priv;
+	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
+	struct ieee80211_hw_mode *mode;
 	u32 pf;
 	s32 err_avg;
 	s32 err_prop;
 	s32 err_int;
 	s32 err_der;
-	int adj;
+	int adj, i, j, tmp;
 
+	mode = local->oper_hw_mode;
 	spinfo = sta->rate_ctrl_priv;
 	spinfo->last_sample = jiffies;
 
@@ -194,6 +282,31 @@ static void rate_control_pid_sample(stru
 		spinfo->tx_num_failed = 0;
 	}
 
+	/* If we just switched rate, update the rate behaviour info. */
+	if (pinfo->oldrate != sta->txrate) {
+		for (i = 0; i < mode->num_rates; i++)
+			if (rinfo[i].index == pinfo->oldrate)
+				break;
+		for (j = 0; j < mode->num_rates; j++)
+			if (rinfo[j].index == sta->txrate) {
+				rinfo[j].valid = 1;
+				break;
+			}
+
+		tmp = (pf - spinfo->last_pf);
+
+		/* We need to do an arithmetic right shift. ISO C says this is
+		 * implementation defined for negative left operands. Hence, be
+		 * careful to get it right, also for negative values. */
+		tmp = (tmp < 0) ? -((-tmp) >> (RC_PID_ARITH_SHIFT)) :
+			  tmp >> (RC_PID_ARITH_SHIFT);
+
+		rinfo[j].diff = rinfo[i].diff + tmp;
+		rinfo[j].valid = 1;
+		pinfo->oldrate = sta->txrate;
+	}
+	rate_control_pid_normalize(rinfo, mode->num_rates);
+
 	/* Compute the proportional, integral and derivative errors. */
 	err_prop = RC_PID_TARGET_PF - pf;
 
@@ -208,15 +321,13 @@ static void rate_control_pid_sample(stru
 	adj = (err_prop * pinfo->coeff_p + err_int * pinfo->coeff_i
 	      + err_der * pinfo->coeff_d);
 
-	/* We need to do an arithmetic right shift. ISO C says this is
-	 * implementation defined for negative left operands. Hence, be
-	 * careful to get it right, also for negative values. */
+	/* Arithmetic right shift, see above. */
 	adj = (adj < 0) ? -((-adj) >> (2 * RC_PID_ARITH_SHIFT)) :
 			  adj >> (2 * RC_PID_ARITH_SHIFT);
 
 	/* Change rate. */
 	if (adj)
-		rate_control_pid_adjust_rate(local, sta, adj);
+		rate_control_pid_adjust_rate(local, sta, adj, rinfo);
 }
 
 static void rate_control_pid_tx_status(void *priv, struct net_device *dev,
@@ -315,13 +426,55 @@ static void rate_control_pid_rate_init(v
 static void *rate_control_pid_alloc(struct ieee80211_local *local)
 {
 	struct rc_pid_info *pinfo;
+	struct rc_pid_rateinfo *rinfo;
+	struct ieee80211_hw_mode *mode;
+	int i, j, tmp;
+	bool s;
 
 	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
+	if (!pinfo)
+		return NULL;
+
+	mode = local->oper_hw_mode;
+	rinfo = kmalloc(sizeof(*rinfo) * mode->num_rates, GFP_ATOMIC);
+	if (!rinfo) {
+		kfree(pinfo);
+		return NULL;
+	}
+
+	/* Sort the rates. This is optimized for the most common case (i.e.
+	 * almost-sorted CCK+OFDM rates). */
+	for (i = 0; i < mode->num_rates; i++) {
+		rinfo[i].index = i;
+		if (RC_PID_FAST_START) {
+			rinfo[i].valid = 1;
+			rinfo[i].diff = 0;
+		} else
+			rinfo[i].valid = 0;
+	}
+	for (i = 1; i < mode->num_rates; i++) {
+		s = 0;
+		for (j = 0; j < mode->num_rates - i; j++)
+			if (unlikely(mode->rates[rinfo[j].index].rate >
+				     mode->rates[rinfo[j + 1].index].rate)) {
+				tmp = rinfo[j].index;
+				rinfo[j].index = rinfo[j + 1].index;
+				rinfo[j + 1].index = tmp;
+				s = 1;
+			}
+		if (!s)
+			break;
+	}
+
+	rinfo[0].diff = 0;
+	rinfo[0].valid = 1;
 
 	pinfo->target = RC_PID_TARGET_PF;
 	pinfo->coeff_p = RC_PID_COEFF_P;
 	pinfo->coeff_i = RC_PID_COEFF_I;
 	pinfo->coeff_d = RC_PID_COEFF_D;
+	pinfo->rinfo = rinfo;
+	pinfo->oldrate = 0;
 
 	return pinfo;
 }
@@ -330,6 +483,7 @@ static void *rate_control_pid_alloc(stru
 static void rate_control_pid_free(void *priv)
 {
 	struct rc_pid_info *pinfo = priv;
+	kfree(pinfo->rinfo);
 	kfree(pinfo);
 }
 


--
Ciao
Stefano
