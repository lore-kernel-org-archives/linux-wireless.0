Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:57407 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751116AbXLCDab (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2007 22:30:31 -0500
Date: Mon, 3 Dec 2007 04:26:56 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Message-ID: <20071203042656.1aad7ad6@morte> (sfid-20071203_033112_503688_FCB487EE)
In-Reply-To: <20071203041608.3af3b462@morte>
References: <1196622331.7472.4.camel@localhost>
	<20071203041608.3af3b462@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, it looks like I didn't refresh the patch I just inlined:

Index: wireless-2.6/net/mac80211/rc80211_simple.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_simple.c
+++ wireless-2.6/net/mac80211/rc80211_simple.c
@@ -26,13 +26,15 @@
  *
  * The controller basically computes the following:
  *
- * adj = CP * err + CI * err_avg + CD * (err - last_err)
+ * adj = CP * err + CI * err_avg + CD * (1 + sharpening) * (err - last_err)
  *
  * where
  * 	adj	adjustment value that is used to switch TX rate (see below)
  * 	err	current error: target vs. current failed frames percentage
  * 	last_err	last error
  * 	err_avg	average (i.e. poor man's integral) of recent errors
+ *	sharpening	non-zero when fast response is needed (i.e. right after
+ *			association or interpolation)
  * 	CP	Proportional coefficient
  * 	CI	Integral coefficient
  * 	CD	Derivative coefficient
@@ -62,6 +64,11 @@
 #define RATE_CONTROL_SMOOTHING_SHIFT 3
 #define RATE_CONTROL_SMOOTHING (1 << RATE_CONTROL_SMOOTHING_SHIFT)
 
+/* Sharpening factor (used for D part of PID controller) */
+#define RATE_CONTROL_SHARPENING_SHIFT 2
+#define RATE_CONTROL_SHARPENING (1 << RATE_CONTROL_SHARPENING_SHIFT)
+#define RATE_CONTROL_SHARPENING_DURATION 3
+
 /* Fixed point arithmetic shifting amount. */
 #define RATE_CONTROL_ARITH_SHIFT 8
 
@@ -122,6 +129,9 @@ struct sta_rate_control {
 	/* Last framed failes percentage sample */
 	u32 last_pf;
 
+	/* Sharpening needed */
+	u8 sharp_cnt;
+
 	unsigned long avg_rate_update;
 	u32 tx_avg_rate_sum;
 	u32 tx_avg_rate_num;
@@ -252,11 +262,13 @@ static void rate_control_simple_tx_statu
 		srctrl->last_sample = jiffies;
 
 		/* If no frames were transmitted, we assume the old sample is
-		 * still a good measurement and copy it.
+		 * still a good measurement and copy it, and turn the
+		 * sharpening factor on.
 		 */
-		if (srctrl->tx_num_xmit == 0)
+		if (srctrl->tx_num_xmit == 0) {
 			pf = srctrl->last_pf;
-		else {
+			srctrl->sharp_cnt = RATE_CONTROL_SHARPENING_DURATION;
+		} else {
 			pf = srctrl->tx_num_failed * 100 / srctrl->tx_num_xmit;
 			pf <<= RATE_CONTROL_ARITH_SHIFT;
 
@@ -271,8 +283,11 @@ static void rate_control_simple_tx_statu
 		srctrl->err_avg_sc = srctrl->err_avg_sc - err_avg + err_prop;
 		err_int = srctrl->err_avg_sc >> RATE_CONTROL_SMOOTHING_SHIFT;
 
-		err_der = pf - srctrl->last_pf;
+		err_der = (pf - srctrl->last_pf) *
+			  (1 + RATE_CONTROL_SHARPENING * srctrl->sharp_cnt);
 		srctrl->last_pf = pf;
+		if (srctrl->sharp_cnt)
+			srctrl->sharp_cnt--;
 
 		/* Compute the controller output. */
 		adj = (err_prop * RATE_CONTROL_COEFF_P


-- 
Ciao
Stefano
