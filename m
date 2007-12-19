Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:44269 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755511AbXLSAb5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 19:31:57 -0500
Date: Wed, 19 Dec 2007 01:26:52 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: [PATCH v3 5/8] rc80211-pid: add sharpening factor
Message-ID: <20071219012652.25a45c5e@morte> (sfid-20071219_003207_252084_DEC80796)
In-Reply-To: <20071219001955.055692620@polimi.it>
References: <20071219001955.055692620@polimi.it>>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces a PID sharpening factor for faster response after
association and low activity events.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---
 rc80211_pid.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

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
@@ -65,6 +68,10 @@
 #define RC_PID_SMOOTHING_SHIFT 3
 #define RC_PID_SMOOTHING (1 << RC_PID_SMOOTHING_SHIFT)

+/* Sharpening factor (used for D part of PID controller) */
+#define RC_PID_SHARPENING_FACTOR 0
+#define RC_PID_SHARPENING_DURATION 0
+
 /* Fixed point arithmetic shifting amount. */
 #define RC_PID_ARITH_SHIFT 8

@@ -131,8 +138,11 @@ struct rc_pid_sta_info {
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
@@ -267,20 +277,26 @@ static void rate_control_pid_sample(stru

 	mode = local->oper_hw_mode;
 	spinfo = sta->rate_ctrl_priv;
+
+	/* In case nothing happened during the previous control interval, turn
+	 * the sharpening factor on. */
+	if (jiffies - spinfo->last_sample > 2 * RC_PID_INTERVAL)
+		spinfo->sharp_cnt = RC_PID_SHARPENING_DURATION;
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

@@ -302,8 +318,11 @@ static void rate_control_pid_sample(stru
 	spinfo->err_avg_sc = spinfo->err_avg_sc - err_avg + err_prop;
 	err_int = spinfo->err_avg_sc >> RC_PID_SMOOTHING_SHIFT;

-	err_der = pf - spinfo->last_pf;
+	err_der = pf - spinfo->last_pf
+		  * (1 + RC_PID_SHARPENING_FACTOR * spinfo->sharp_cnt);
 	spinfo->last_pf = pf;
+	if (spinfo->sharp_cnt)
+			spinfo->sharp_cnt--;

 	/* Compute the controller output. */
 	adj = (err_prop * pinfo->coeff_p + err_int * pinfo->coeff_i

-- 
Ciao
Stefano
