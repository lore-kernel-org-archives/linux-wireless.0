Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:53331 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755773AbXLKXix (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 18:38:53 -0500
Date: Wed, 12 Dec 2007 00:31:47 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC/T][PATCH v3 2/3] rc80211-pid: introduce PID sharpening factor
Message-ID: <20071212003147.10da06be@morte> (sfid-20071211_233905_020595_ECE8979C)
In-Reply-To: <1197272696.7490.31.camel@localhost>
References: <20071209211547.2d7fca32@morte>
	<20071209212133.43030d03@morte>
	<1197239361.7543.17.camel@localhost>
	<20071210003120.0078db1d@morte>
	<1197244416.7543.27.camel@localhost>
	<20071210032811.5cea4909@morte>
	<1197268081.7490.10.camel@localhost>
	<20071210082154.015f6e6a@morte>
	<1197272696.7490.31.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces a PID sharpening factor for faster response on
association and interpolation.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

Index: wireless-2.6/net/mac80211/rc80211_pid.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid.c
+++ wireless-2.6/net/mac80211/rc80211_pid.c
@@ -23,13 +23,16 @@
  *
  * The controller basically computes the following:
  *
- * adj = CP * err + CI * err_avg + CD * (err - last_err)
+ * adj = CP * err + CI * err_avg + CD * (err - last_err) * (1 + sharpening)
  *
  * where
  * 	adj	adjustment value that is used to switch TX rate (see below)
  * 	err	current error: target vs. current failed frames percentage
  * 	last_err	last error
  * 	err_avg	average (i.e. poor man's integral) of recent errors
+ *	sharpening	non-zero when fast response is needed (i.e. right after
+ *			association or no frames sent for a long time), heading
+ * 			to zero over time
  * 	CP	Proportional coefficient
  * 	CI	Integral coefficient
  * 	CD	Derivative coefficient
@@ -65,6 +68,11 @@
 #define RC_PID_SMOOTHING_SHIFT 3
 #define RC_PID_SMOOTHING (1 << RC_PID_SMOOTHING_SHIFT)
 
+/* Sharpening factor (used for D part of PID controller) */
+#define RATE_CONTROL_SHARPENING_SHIFT 2
+#define RATE_CONTROL_SHARPENING (1 << RATE_CONTROL_SHARPENING_SHIFT)
+#define RATE_CONTROL_SHARPENING_DURATION 1
+
 /* Fixed point arithmetic shifting amount. */
 #define RC_PID_ARITH_SHIFT 8
 
@@ -131,8 +139,11 @@ struct rc_pid_sta_info {
 	 */
 	s32 err_avg_sc;
 
-	/* Last framed failes percentage sample */
+	/* Last framed failes percentage sample. */
 	u32 last_pf;
+
+	/* Sharpening needed. */
+	u8 sharp_cnt;
 };
 
 /* Algorithm parameters. We keep them on a per-algorithm approach, so they can
@@ -275,20 +286,26 @@ static void rate_control_pid_sample(stru
 
 	mode = local->oper_hw_mode;
 	spinfo = sta->rate_ctrl_priv;
+
+	/* In case nothing happened during the previous control interval, turn
+	 * on the sharpening factor. */
+	if (jiffies - spinfo->last_sample > RC_PID_INTERVAL)
+		spinfo->sharp_cnt = RATE_CONTROL_SHARPENING_DURATION;
+
 	spinfo->last_sample = jiffies;
 
-	/* If no frames were transmitted, we assume the old sample is
+	/* This should never happen, but in case, we assume the old sample is
 	 * still a good measurement and copy it. */
-	if (spinfo->tx_num_xmit == 0)
+	if (unlikely(spinfo->tx_num_xmit == 0))
 		pf = spinfo->last_pf;
 	else {
 		pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
 		pf <<= RC_PID_ARITH_SHIFT;
-
-		spinfo->tx_num_xmit = 0;
-		spinfo->tx_num_failed = 0;
 	}
 
+	spinfo->tx_num_xmit = 0;
+	spinfo->tx_num_failed = 0;
+
 	/* If we just switched rate, update the rate behaviour info. */
 	if (pinfo->oldrate != sta->txrate) {
 
@@ -313,8 +330,11 @@ static void rate_control_pid_sample(stru
 	spinfo->err_avg_sc = spinfo->err_avg_sc - err_avg + err_prop;
 	err_int = spinfo->err_avg_sc >> RC_PID_SMOOTHING_SHIFT;
 
-	err_der = pf - spinfo->last_pf;
+	err_der = pf - spinfo->last_pf
+		  * (1 + RATE_CONTROL_SHARPENING * spinfo->sharp_cnt);
 	spinfo->last_pf = pf;
+	if (spinfo->sharp_cnt)
+			spinfo->sharp_cnt--;
 
 	/* Compute the controller output. */
 	adj = (err_prop * pinfo->coeff_p + err_int * pinfo->coeff_i



-- 
Ciao
Stefano
