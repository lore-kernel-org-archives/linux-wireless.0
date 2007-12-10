Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:36968 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750955AbXLJChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 21:37:31 -0500
Date: Mon, 10 Dec 2007 03:31:08 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC/T][PATCH v2 3/3] rc80211-pid: allow for parameters to be set
 through sysfs
Message-ID: <20071210033108.1f8d034c@morte> (sfid-20071210_023733_357595_C45DB4D4)
In-Reply-To: <1197239410.7543.19.camel@localhost>
References: <20071209211547.2d7fca32@morte>
	<20071209212842.1515704c@morte>
	<1197239410.7543.19.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows for tuning parameters to be set through sysfs. Note that
this lacks locking, as another copy of the whole parameters data would have
been needed and this won't be the final approach anyway, so don't bother
too much.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

This applies on top of previous v2 patches.

---

Index: wireless-2.6/net/mac80211/rc80211_pid.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid.c
+++ wireless-2.6/net/mac80211/rc80211_pid.c
@@ -61,17 +61,50 @@
  * RC_PID_ARITH_SHIFT.
  */
 
-/* Sampling frequency for measuring percentage of failed frames. */
-#define RC_PID_INTERVAL (HZ / 1)
-
-/* Exponential averaging smoothness (used for I part of PID controller) */
-#define RC_PID_SMOOTHING_SHIFT 3
-#define RC_PID_SMOOTHING (1 << RC_PID_SMOOTHING_SHIFT)
-
-/* Sharpening factor (used for D part of PID controller) */
-#define RATE_CONTROL_SHARPENING_SHIFT 2
-#define RATE_CONTROL_SHARPENING (1 << RATE_CONTROL_SHARPENING_SHIFT)
-#define RATE_CONTROL_SHARPENING_DURATION 1
+static int modparam_rc_imul = 1;
+module_param_named(rc_imul, modparam_rc_imul, int, 0644);
+MODULE_PARM_DESC(rc_imul, "PID rate control interval multiplier");
+
+static int modparam_rc_idiv = 1;
+module_param_named(rc_idiv, modparam_rc_idiv, int, 0644);
+MODULE_PARM_DESC(rc_idiv, "PID rate control interval divider");
+
+static int modparam_rc_pf = 1;
+module_param_named(rc_pf, modparam_rc_pf, int, 0644);
+MODULE_PARM_DESC(rc_pf, "PID rate control failed frames percentage target");
+
+static int modparam_rc_p = 1;
+module_param_named(rc_p, modparam_rc_p, int, 0644);
+MODULE_PARM_DESC(rc_p, "PID rate control proportional coefficient");
+
+static int modparam_rc_i = 1;
+module_param_named(rc_i, modparam_rc_i, int, 0644);
+MODULE_PARM_DESC(rc_i, "PID rate control integral coefficient");
+
+static int modparam_rc_d = 1;
+module_param_named(rc_d, modparam_rc_d, int, 0644);
+MODULE_PARM_DESC(rc_d, "PID rate control derivative coefficient");
+
+static int modparam_rc_sm_s = 3;
+module_param_named(rc_sm_s, modparam_rc_sm_s, int, 0644);
+MODULE_PARM_DESC(rc_sm_s, "PID rate control smoothing factor shift");
+
+static int modparam_rc_sh_s = 2;
+module_param_named(rc_sh_s, modparam_rc_sh_s, int, 0644);
+MODULE_PARM_DESC(rc_sh_s, "PID rate control sharpening factor shift");
+
+static int modparam_rc_sh_d = 3;
+module_param_named(rc_sh_d, modparam_rc_sh_d, int, 0644);
+MODULE_PARM_DESC(rc_sh_d, "PID rate control sharpening factor duration");
+
+static int modparam_rc_norm_offset = 3;
+module_param_named(rc_norm_offset, modparam_rc_norm_offset, int, 0644);
+MODULE_PARM_DESC(rc_norm_offset, "PID rate behaviour normalization offset");
+
+static int modparam_rc_fast_start = 0;
+module_param_named(rc_fast_start, modparam_rc_fast_start, int, 0644);
+MODULE_PARM_DESC(rc_fast_start, "PID allowance for high rates right after"
+				"loading");
 
 /* Fixed point arithmetic shifting amount. */
 #define RC_PID_ARITH_SHIFT 8
@@ -79,26 +112,6 @@
 /* Fixed point arithmetic factor. */
 #define RC_PID_ARITH_FACTOR (1 << RC_PID_ARITH_SHIFT)
 
-/* Proportional PID component coefficient. */
-#define RC_PID_COEFF_P 15
-/* Integral PID component coefficient. */
-#define RC_PID_COEFF_I 10
-/* Derivative PID component coefficient. */
-#define RC_PID_COEFF_D 15
-
-/* Target failed frames rate for the PID controller. NB: This effectively gives
- * maximum failed frames percentage we're willing to accept. If communication is
- * good, the controller will fail to adjust failed frames percentage to the
- * target. This is intentional.
- */
-#define RC_PID_TARGET_PF (20 << RC_PID_ARITH_SHIFT)
-
-/* Rate behaviour normalization quantity over time. */
-#define RC_PID_NORM_OFFSET 3
-
-/* Push high rates right after loading. */
-#define RC_PID_FAST_START 0
-
 /* Arithmetic right shift for positive and negative values for ISO C. */
 #define RC_PID_DO_ARITH_RIGHT_SHIFT(x, y) \
 	(x) < 0 ? -((-(x))) >> (y) : (x) >> (y)
@@ -163,13 +176,28 @@ struct rc_pid_rateinfo {
 
 struct rc_pid_info {
 
+	/* Rate control interval multiplier and divider. */
+	int imul;
+	int idiv;
+
 	/* The failed frames percentage target. */
-	u32 target;
+	int target;
 
 	/* P, I and D coefficients. */
-	s32 coeff_p;
-	s32 coeff_i;
-	s32 coeff_d;
+	int coeff_p;
+	int coeff_i;
+	int coeff_d;
+
+	/* Smoothing and sharpening factors. */
+	int sm_s;
+	int sh_s;
+	int sh_d;
+
+	/* Rate behaviour normalization factor. */
+	int norm_offset;
+
+	/* Fast start. */
+	bool fast_start;
 
 	/* Rates information. */
 	struct rc_pid_rateinfo *rinfo;
@@ -260,20 +288,27 @@ static void rate_control_pid_adjust_rate
 }
 
 /* Normalize the failed frames per-rate differences. */
-static void rate_control_pid_normalize(struct rc_pid_rateinfo *r, int l)
+static void rate_control_pid_normalize(struct rc_pid_info *p, int l)
 {
-	int i;
+	int i, no;
+	struct rc_pid_rateinfo *r = p->rinfo;
 
-	if (r[0].diff > RC_PID_NORM_OFFSET)
-		r[0].diff -= RC_PID_NORM_OFFSET;
-	else if (r[0].diff < -RC_PID_NORM_OFFSET)
-		r[0].diff += RC_PID_NORM_OFFSET;
+	/* TODO: RCU lock needed here when implemented properly. */
+	p->norm_offset = modparam_rc_norm_offset;
+	/* TODO: RCU unlock. */
+
+	no = p->norm_offset;
+
+	if (r[0].diff > no)
+		r[0].diff -= no;
+	else if (r[0].diff < -no)
+		r[0].diff += no;
 	for (i = 0; i < l - 1; i++)
 		if (likely(r[i + 1].valid)) {
-			if (r[i + 1].diff > r[i].diff + RC_PID_NORM_OFFSET)
-				r[i + 1].diff -= RC_PID_NORM_OFFSET;
+			if (r[i + 1].diff > r[i].diff + no)
+				r[i + 1].diff -= no;
 			else if (r[i + 1].diff <= r[i].diff)
-				r[i + 1].diff += RC_PID_NORM_OFFSET;
+				r[i + 1].diff += no;
 		}
 }
 
@@ -294,10 +329,22 @@ static void rate_control_pid_sample(stru
 	mode = local->oper_hw_mode;
 	spinfo = sta->rate_ctrl_priv;
 
+	/* TODO: RCU lock needed here when implemented properly. */
+	pinfo->imul = modparam_rc_imul;
+	pinfo->idiv = modparam_rc_idiv;
+	pinfo->target = modparam_rc_pf;
+	pinfo->coeff_p = modparam_rc_p;
+	pinfo->coeff_i = modparam_rc_i;
+	pinfo->coeff_d = modparam_rc_d;
+	pinfo->sm_s = modparam_rc_sm_s;
+	pinfo->sh_s = modparam_rc_sh_s;
+	pinfo->sh_d = modparam_rc_sh_d;
+	/* TODO: RCU unlock. */
+
 	/* In case nothing happened during the previous control interval, turn
 	 * on the sharpening factor. */
-	if (jiffies - spinfo->last_sample > RC_PID_INTERVAL)
-		spinfo->sharp_cnt = RATE_CONTROL_SHARPENING_DURATION;
+	if (jiffies - spinfo->last_sample > (HZ * pinfo->imul) / pinfo->idiv)
+		spinfo->sharp_cnt = pinfo->sh_d;
 
 	spinfo->last_sample = jiffies;
 
@@ -323,17 +370,17 @@ static void rate_control_pid_sample(stru
 		rinfo[j].valid = 1;
 		pinfo->oldrate = sta->txrate;
 	}
-	rate_control_pid_normalize(rinfo, mode->num_rates);
+	rate_control_pid_normalize(pinfo, mode->num_rates);
 
 	/* Compute the proportional, integral and derivative errors. */
-	err_prop = RC_PID_TARGET_PF - pf;
+	err_prop = (20 << pinfo->target) - pf;
 
-	err_avg = spinfo->err_avg_sc >> RC_PID_SMOOTHING_SHIFT;
+	err_avg = spinfo->err_avg_sc >> pinfo->sm_s;
 	spinfo->err_avg_sc = spinfo->err_avg_sc - err_avg + err_prop;
-	err_int = spinfo->err_avg_sc >> RC_PID_SMOOTHING_SHIFT;
+	err_int = spinfo->err_avg_sc >> pinfo->sm_s;
 
 	err_der = pf - spinfo->last_pf
-		  * (1 + RATE_CONTROL_SHARPENING * spinfo->sharp_cnt);
+		  * (1 + (1 << pinfo->sh_s) * spinfo->sharp_cnt);
 	spinfo->last_pf = pf;
 	if (spinfo->sharp_cnt)
 			spinfo->sharp_cnt--;
@@ -392,7 +439,12 @@ static void rate_control_pid_tx_status(v
 	sta->tx_num_mpdu_fail += status->retry_count;
 
 	/* Update PID controller state. */
-	if (time_after(jiffies, spinfo->last_sample + RC_PID_INTERVAL))
+	/* TODO: RCU lock needed here when implemented properly. */
+	pinfo->imul = modparam_rc_imul;
+	pinfo->idiv = modparam_rc_idiv;
+	/* TODO: RCU unlock. */
+	if (time_after(jiffies, spinfo->last_sample
+				+ (HZ * pinfo->imul) / pinfo->idiv))
 		rate_control_pid_sample(pinfo, local, sta);
 
 	sta_info_put(sta);
@@ -460,11 +512,14 @@ static void *rate_control_pid_alloc(stru
 		return NULL;
 	}
 
+	/* TODO: RCU lock needed here when implemented properly. */
+	pinfo->fast_start = modparam_rc_fast_start;
+	/* TODO: RCU unlock. */
 	/* Sort the rates. This is optimized for the most common case (i.e.
 	 * almost-sorted CCK+OFDM rates). */
 	for (i = 0; i < mode->num_rates; i++) {
 		rinfo[i].index = i;
-		if (RC_PID_FAST_START) {
+		if (pinfo->fast_start) {
 			rinfo[i].valid = 1;
 			rinfo[i].diff = 0;
 		} else
@@ -487,10 +542,6 @@ static void *rate_control_pid_alloc(stru
 	rinfo[0].diff = 0;
 	rinfo[0].valid = 1;
 
-	pinfo->target = RC_PID_TARGET_PF;
-	pinfo->coeff_p = RC_PID_COEFF_P;
-	pinfo->coeff_i = RC_PID_COEFF_I;
-	pinfo->coeff_d = RC_PID_COEFF_D;
 	pinfo->rinfo = rinfo;
 	pinfo->oldrate = 0;
 



-- 
Ciao
Stefano
