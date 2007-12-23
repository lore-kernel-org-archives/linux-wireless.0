Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:50010 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755986AbXLWDqs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 22:46:48 -0500
Date: Sun, 23 Dec 2007 04:44:56 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: [PATCH 5/7] rc80211-pid: pf_target tuning
Message-ID: <20071223044456.6db17d0c@morte> (sfid-20071223_034711_592452_3609125B)
In-Reply-To: <20071223033633.710907923@polimi.it>
References: <20071223033633.710907923@polimi.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set a better value for percentage target for failed frames. The previous value
slowed down too much rate increases in case of permanently low activity. While
at it, increase readability.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
 rc80211_pid.h |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: wireless-2.6/net/mac80211/rc80211_pid.h
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid.h
+++ wireless-2.6/net/mac80211/rc80211_pid.h
@@ -11,41 +11,41 @@
 #define RC80211_PID_H

 /* Sampling period for measuring percentage of failed frames. */
-#define RC_PID_INTERVAL (HZ / 8)
+#define RC_PID_INTERVAL			(HZ / 8)

 /* Exponential averaging smoothness (used for I part of PID controller) */
-#define RC_PID_SMOOTHING_SHIFT 3
-#define RC_PID_SMOOTHING (1 << RC_PID_SMOOTHING_SHIFT)
+#define RC_PID_SMOOTHING_SHIFT		3
+#define RC_PID_SMOOTHING		(1 << RC_PID_SMOOTHING_SHIFT)

 /* Sharpening factor (used for D part of PID controller) */
-#define RC_PID_SHARPENING_FACTOR 0
-#define RC_PID_SHARPENING_DURATION 0
+#define RC_PID_SHARPENING_FACTOR	0
+#define RC_PID_SHARPENING_DURATION	0

 /* Fixed point arithmetic shifting amount. */
-#define RC_PID_ARITH_SHIFT 8
+#define RC_PID_ARITH_SHIFT		8

 /* Fixed point arithmetic factor. */
-#define RC_PID_ARITH_FACTOR (1 << RC_PID_ARITH_SHIFT)
+#define RC_PID_ARITH_FACTOR		(1 << RC_PID_ARITH_SHIFT)

 /* Proportional PID component coefficient. */
-#define RC_PID_COEFF_P 15
+#define RC_PID_COEFF_P			15
 /* Integral PID component coefficient. */
-#define RC_PID_COEFF_I 9
+#define RC_PID_COEFF_I			9
 /* Derivative PID component coefficient. */
-#define RC_PID_COEFF_D 15
+#define RC_PID_COEFF_D			15

 /* Target failed frames rate for the PID controller. NB: This effectively gives
  * maximum failed frames percentage we're willing to accept. If the wireless
  * link quality is good, the controller will fail to adjust failed frames
  * percentage to the target. This is intentional.
  */
-#define RC_PID_TARGET_PF 11
+#define RC_PID_TARGET_PF		14

 /* Rate behaviour normalization quantity over time. */
-#define RC_PID_NORM_OFFSET 3
+#define RC_PID_NORM_OFFSET		3

 /* Push high rates right after loading. */
-#define RC_PID_FAST_START 0
+#define RC_PID_FAST_START		0

 /* Arithmetic right shift for positive and negative values for ISO C. */
 #define RC_PID_DO_ARITH_RIGHT_SHIFT(x, y) \

-- 
Ciao
Stefano
