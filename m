Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51186 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753969AbXLBTFf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2007 14:05:35 -0500
Subject: [RFC][PATCH] mac80211: Use PID controller for TX rate control
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Sun, 02 Dec 2007 20:05:31 +0100
Message-Id: <1196622331.7472.4.camel@localhost> (sfid-20071202_190557_126687_3ADAC58F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the patch below is a first attempt on the PID-controller approach for TX
rate control. It kind of works here, but I haven't spent much time
tuning the coefficients.

I wanted to share this at this early stage so you can experiment with
and comment.

Mattias


Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---
 net/mac80211/ieee80211_rate.h |    3 -
 net/mac80211/rc80211_simple.c |  281 ++++++++++++++++++++++++++++-------------
 2 files changed, 190 insertions(+), 94 deletions(-)

diff --git a/net/mac80211/ieee80211_rate.h b/net/mac80211/ieee80211_rate.h
index 2368813..9948d0f 100644
--- a/net/mac80211/ieee80211_rate.h
+++ b/net/mac80211/ieee80211_rate.h
@@ -18,9 +18,6 @@
 #include "ieee80211_i.h"
 #include "sta_info.h"
 
-#define RATE_CONTROL_NUM_DOWN 20
-#define RATE_CONTROL_NUM_UP   15
-
 
 struct rate_control_extra {
 	/* values from rate_control_get_rate() to the caller: */
diff --git a/net/mac80211/rc80211_simple.c b/net/mac80211/rc80211_simple.c
index da72737..af6f8ff 100644
--- a/net/mac80211/rc80211_simple.c
+++ b/net/mac80211/rc80211_simple.c
@@ -20,52 +20,127 @@
 #include "debugfs.h"
 

-/* This is a minimal implementation of TX rate controlling that can be used
- * as the default when no improved mechanisms are available. */
+/* This is an implementation of TX rate control algorithm that uses a PID
+ * controller. Given a target failed frames rate, the controller decides about
+ * TX rate changes to meet the target failed frames rate.
+ *
+ * The controller basically computes the following:
+ *
+ * adj = CP * err + CI * err_avg + CD * (err - last_err)
+ *
+ * where
+ * 	adj	adjustment value that is used to switch TX rate (see below)
+ * 	err	current error: target vs. current failed frames percentage
+ * 	last_err	last error
+ * 	err_avg	average (i.e. poor man's integral) of recent errors
+ * 	CP	Proportional coefficient
+ * 	CI	Integral coefficient
+ * 	CD	Derivative coefficient
+ *
+ * CP, CI, CD are subject to careful tuning.
+ *
+ * The integral component uses a exponential moving average approach instead of
+ * an actual sliding window. Advantage is that we don't need to keep an array of
+ * the last N error values and computation is easier.
+ *
+ * Once we have the adj value, we need to map it to a TX rate to be selected.
+ * For now, we depend on the rates to be ordered in a way such that more robust
+ * rates (i.e. such that exhibit a lower framed failed percentage) come first.
+ * E.g. for the 802.11b/g case, we first have the b rates in ascending order,
+ * then the g rates. The adj simply decides the index of the TX rate in the list
+ * to switch to (relative to the current TX rate entry).
+ *
+ * Note that for the computations we use a fixed-point representation to avoid
+ * floating point arithmetic. Hence, all values are shifted left by
+ * RATE_CONTROL_ARITH_SHIFT.
+ */
 
+/* Sampling frequency for measuring percentage of failed frames. */
+#define RATE_CONTROL_INTERVAL (HZ / 1)
 
-#define RATE_CONTROL_EMERG_DEC 2
-#define RATE_CONTROL_INTERVAL (HZ / 20)
-#define RATE_CONTROL_MIN_TX 10
+/* Exponential averaging smoothness (used for I part of PID controller) */
+#define RATE_CONTROL_SMOOTHING_SHIFT 3
+#define RATE_CONTROL_SMOOTHING (1 << RATE_CONTROL_SMOOTHING_SHIFT)
 
-static void rate_control_rate_inc(struct ieee80211_local *local,
-				  struct sta_info *sta)
-{
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_hw_mode *mode;
-	int i = sta->txrate;
-	int maxrate;
+/* Fixed point arithmetic shifting amount. */
+#define RATE_CONTROL_ARITH_SHIFT 8
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
-	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
-		/* forced unicast rate - do not change STA rate */
-		return;
-	}
+/* Fixed point arithmetic factor. */
+#define RATE_CONTROL_ARITH_FACTOR (1 << RATE_CONTROL_ARITH_SHIFT)
 
-	mode = local->oper_hw_mode;
-	maxrate = sdata->bss ? sdata->bss->max_ratectrl_rateidx : -1;
+/* Proportional PID component coefficient. */
+#define RATE_CONTROL_COEFF_P 15
+/* Integral PID component coefficient. */
+#define RATE_CONTROL_COEFF_I 10
+/* Derivative PID component coefficient. */
+#define RATE_CONTROL_COEFF_D 15
 
-	if (i > mode->num_rates)
-		i = mode->num_rates - 2;
+/* Target failed frames rate for the PID controller. NB: This effectively gives
+ * maximum failed frames percentage we're willing to accept. If communication is
+ * good, the controller will fail to adjust failed frames percentage to the
+ * target. This is intentional.
+ */
+#define RATE_CONTROL_TARGET_PF (20 << RATE_CONTROL_ARITH_SHIFT)
 
-	while (i + 1 < mode->num_rates) {
-		i++;
-		if (sta->supp_rates & BIT(i) &&
-		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED &&
-		    (maxrate < 0 || i <= maxrate)) {
-			sta->txrate = i;
-			break;
-		}
-	}
-}
+struct sta_rate_control {
+	unsigned long last_change;
+	unsigned long last_sample;
 
+	u32 tx_num_failed;
+	u32 tx_num_xmit;
 
-static void rate_control_rate_dec(struct ieee80211_local *local,
-				  struct sta_info *sta)
+	/*
+	 * Average failed frames percentage error (i.e. actual vs. target
+	 * percentage), scaled by RATE_CONTROL_SMOOTHING. This value is a
+	 * smoothed by using a exponentail weighted average technique:
+	 *
+	 *           (SMOOTHING - 1) * err_avg_old + err
+	 * err_avg = -----------------------------------
+	 *                       SMOOTHING
+	 *
+	 * where err_avg is the new approximation, err_avg_old the previous one
+	 * and err is the error w.r.t. to the current failed frames percentage
+	 * sample. Note that the bigger SMOOTHING the more weight is given to
+	 * the previous estimate, resulting in smoother behavior (i.e.
+	 * corresponding to a longer integration window).
+	 *
+	 * For computation, we actually don't use the above formula, but this
+	 * one:
+	 *
+	 * err_avg_scaled = err_avg_old_scaled - err_avg_old + err
+	 *
+	 * where:
+	 * 	err_avg_scaled = err * SMOOTHING
+	 * 	err_avg_old_scaled = err_avg_old * SMOOTHING
+	 *
+	 * This avoids floating point numbers and the per_failed_old value can
+	 * easily be obtained by shifting per_failed_old_scaled right by
+	 * RATE_CONTROL_SMOOTHING_SHIFT.
+	 */
+	s32 err_avg_sc;
+
+	/* Last framed failes percentage sample */
+	u32 last_pf;
+
+	unsigned long avg_rate_update;
+	u32 tx_avg_rate_sum;
+	u32 tx_avg_rate_num;
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct dentry *tx_avg_rate_sum_dentry;
+	struct dentry *tx_avg_rate_num_dentry;
+#endif
+};
+
+
+static void rate_control_adjust_rate(struct ieee80211_local *local,
+				     struct sta_info *sta, int adj)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hw_mode *mode;
-	int i = sta->txrate;
+	int newidx = sta->txrate + adj;
+	int maxrate;
+	int back = (adj > 0) ? 1 : -1;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
@@ -74,20 +149,29 @@ static void rate_control_rate_dec(struct ieee80211_local *local,
 	}
 
 	mode = local->oper_hw_mode;
-	if (i > mode->num_rates)
-		i = mode->num_rates;
+	maxrate = sdata->bss ? sdata->bss->max_ratectrl_rateidx : -1;
+
+	if (newidx < 0)
+		newidx = 0;
+	else if (newidx >= mode->num_rates)
+		newidx = mode->num_rates - 1;
+
+	while (newidx != sta->txrate) {
+		if (sta->supp_rates & BIT(newidx) &&
+		    mode->rates[newidx].flags & IEEE80211_RATE_SUPPORTED &&
+		    (maxrate < 0 || newidx <= maxrate)) {
+			sta->txrate = newidx;
+
+			printk(KERN_DEBUG "rate_control: new tx rate %d\n",
+			       mode->rates[newidx].rate);
 
-	while (i > 0) {
-		i--;
-		if (sta->supp_rates & BIT(i) &&
-		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED) {
-			sta->txrate = i;
 			break;
 		}
+
+		newidx += back;
 	}
 }
 
-
 static struct ieee80211_rate *
 rate_control_lowest_rate(struct ieee80211_local *local,
 			 struct ieee80211_hw_mode *mode)
@@ -111,22 +195,6 @@ struct global_rate_control {
 	int dummy;
 };
 
-struct sta_rate_control {
-	unsigned long last_rate_change;
-	u32 tx_num_failures;
-	u32 tx_num_xmit;
-
-	unsigned long avg_rate_update;
-	u32 tx_avg_rate_sum;
-	u32 tx_avg_rate_num;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *tx_avg_rate_sum_dentry;
-	struct dentry *tx_avg_rate_num_dentry;
-#endif
-};
-
-
 static void rate_control_simple_tx_status(void *priv, struct net_device *dev,
 					  struct sk_buff *skb,
 					  struct ieee80211_tx_status *status)
@@ -143,8 +211,20 @@ static void rate_control_simple_tx_status(void *priv, struct net_device *dev,
 
 	srctrl = sta->rate_ctrl_priv;
 	srctrl->tx_num_xmit++;
+
+	/* We count frames that totally failed to be transmitted as two bad
+	 * frames, those that made it out but had some retries as one good and
+	 * one bad frame.
+	 */
+	if (status->excessive_retries) {
+		srctrl->tx_num_failed += 2;
+		srctrl->tx_num_xmit++;
+	} else if (status->retry_count) {
+		srctrl->tx_num_failed++;
+		srctrl->tx_num_xmit++;
+	}
+
 	if (status->excessive_retries) {
-		srctrl->tx_num_failures++;
 		sta->tx_retry_failed++;
 		sta->tx_num_consecutive_failures++;
 		sta->tx_num_mpdu_fail++;
@@ -158,40 +238,59 @@ static void rate_control_simple_tx_status(void *priv, struct net_device *dev,
 	sta->tx_retry_count += status->retry_count;
 	sta->tx_num_mpdu_fail += status->retry_count;
 
-	if (time_after(jiffies,
-		       srctrl->last_rate_change + RATE_CONTROL_INTERVAL) &&
-		srctrl->tx_num_xmit > RATE_CONTROL_MIN_TX) {
-		u32 per_failed;
-		srctrl->last_rate_change = jiffies;
-
-		per_failed = (100 * sta->tx_num_mpdu_fail) /
-			(sta->tx_num_mpdu_fail + sta->tx_num_mpdu_ok);
-		/* TODO: calculate average per_failed to make adjusting
-		 * parameters easier */
-#if 0
-		if (net_ratelimit()) {
-			printk(KERN_DEBUG "MPDU fail=%d ok=%d per_failed=%d\n",
-			       sta->tx_num_mpdu_fail, sta->tx_num_mpdu_ok,
-			       per_failed);
-		}
-#endif
-
-		/*
-		 * XXX: Make these configurable once we have an
-		 * interface to the rate control algorithms
+	/*
+	 * Update PID controller state.
+	 */
+	if (time_after(jiffies, srctrl->last_sample + RATE_CONTROL_INTERVAL)) {
+		u32 pf;
+		s32 err_avg;
+		s32 err_prop;
+		s32 err_int;
+		s32 err_der;
+		int adj;
+
+		srctrl->last_sample = jiffies;
+
+		/* If no frames were transmitted, we assume the old sample is
+		 * still a good measurement and copy it.
 		 */
-		if (per_failed > RATE_CONTROL_NUM_DOWN) {
-			rate_control_rate_dec(local, sta);
-		} else if (per_failed < RATE_CONTROL_NUM_UP) {
-			rate_control_rate_inc(local, sta);
+		if (srctrl->tx_num_xmit == 0)
+			pf = srctrl->last_pf;
+		else {
+			pf = srctrl->tx_num_failed * 100 / srctrl->tx_num_xmit;
+			pf <<= RATE_CONTROL_ARITH_SHIFT;
+
+			srctrl->tx_num_xmit = 0;
+			srctrl->tx_num_failed = 0;
 		}
-		srctrl->tx_avg_rate_sum += status->control.rate->rate;
-		srctrl->tx_avg_rate_num++;
-		srctrl->tx_num_failures = 0;
-		srctrl->tx_num_xmit = 0;
-	} else if (sta->tx_num_consecutive_failures >=
-		   RATE_CONTROL_EMERG_DEC) {
-		rate_control_rate_dec(local, sta);
+
+		/* Compute the proportional, integral and derivative errors. */
+		err_prop = RATE_CONTROL_TARGET_PF - pf;
+
+		err_avg = srctrl->err_avg_sc >> RATE_CONTROL_SMOOTHING_SHIFT;
+		srctrl->err_avg_sc = srctrl->err_avg_sc - err_avg + err_prop;
+		err_int = srctrl->err_avg_sc >> RATE_CONTROL_SMOOTHING_SHIFT;
+
+		err_der = pf - srctrl->last_pf;
+		srctrl->last_pf = pf;
+
+		/* Compute the controller output. */
+		adj = (err_prop * RATE_CONTROL_COEFF_P
+		      + err_int * RATE_CONTROL_COEFF_I
+		      + err_der * RATE_CONTROL_COEFF_D)
+			>> (2 * RATE_CONTROL_ARITH_SHIFT);
+
+		printk(KERN_DEBUG "rate_control: sample %d "
+		       "err_prop %d err_int %d err_der %d adj %d\n",
+		       pf >> RATE_CONTROL_ARITH_SHIFT,
+		       err_prop >> RATE_CONTROL_ARITH_SHIFT,
+		       err_int >> RATE_CONTROL_ARITH_SHIFT,
+		       err_der >> RATE_CONTROL_ARITH_SHIFT,
+		       adj);
+
+		/* Change rate. */
+		if (adj)
+			rate_control_adjust_rate(local, sta, adj);
 	}
 
 	if (srctrl->avg_rate_update + 60 * HZ < jiffies) {
-- 
1.5.3.4

