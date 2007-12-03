Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:36081 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751008AbXLCDTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2007 22:19:52 -0500
Date: Mon, 3 Dec 2007 04:16:08 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Message-ID: <20071203041608.3af3b462@morte> (sfid-20071203_032007_327730_0568A185)
In-Reply-To: <1196622331.7472.4.camel@localhost>
References: <1196622331.7472.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 02 Dec 2007 20:05:31 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> Hi,
> 
> the patch below is a first attempt on the PID-controller approach for TX
> rate control. It kind of works here, but I haven't spent much time
> tuning the coefficients.

It looks good! I tested it a bit with different TX powers and moving around
with a microwave oven turned on [1]. It looks like we don't have the
rollercoaster effect anymore, and overall quality of the algorithm seems
just fine. However, I noticed about two issues:

1) as soon as I loaded mac80211 it took a lot of time to get up with rate,
and this actually happens every time I'm not sending frames for a while
(including get down with rate here).
	- IMHO, it doesn't make sense to check for RSSI of previous packets
as soon as we get associated, because it's very likely that we just switched
between two APs.
	- Here, either we know that something happened (such an association)
and we need to react quite quickly, either we don't know what's happening
and relying solely on interpolation seems not to work so well.
So I thought rather of a "sharpening" factor to be taken into account
when some important events (i.e. association) or interpolation happened.
This seems to work quite well, so in perfect conditions and average load I
need ~6 seconds vs ~11 to get up to 54M, while still maintaining smoothness
during regular operation (thus it looks like there aren't rollercoasting
risks - obviously this will need more testing):
[this patch applies on top of yours]

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
@@ -252,10 +262,12 @@ static void rate_control_simple_tx_statu
 		srctrl->last_sample = jiffies;
 
 		/* If no frames were transmitted, we assume the old sample is
-		 * still a good measurement and copy it.
+		 * still a good measurement and copy it, and turn the
+		 * sharpening factor on.
 		 */
-		if (srctrl->tx_num_xmit == 0)
+		if (srctrl->tx_num_xmit == 0) {
 			pf = srctrl->last_pf;
+			srctrl->sharp_cnt = RATE_CONTROL_SHARPENING_DURATION;
 		else {
 			pf = srctrl->tx_num_failed * 100 / srctrl->tx_num_xmit;
 			pf <<= RATE_CONTROL_ARITH_SHIFT;
@@ -271,8 +283,11 @@ static void rate_control_simple_tx_statu
 		srctrl->err_avg_sc = srctrl->err_avg_sc - err_avg + err_prop;
 		err_int = srctrl->err_avg_sc >> RATE_CONTROL_SMOOTHING_SHIFT;
 
-		err_der = pf - srctrl->last_pf;
+		err_der = pf - srctrl->last_pf
+			  + RATE_CONTROL_SHARPENING * srctrl->sharp;
 		srctrl->last_pf = pf;
+		if (srctrl->sharp)
+			srctrl->sharp--;
 
 		/* Compute the controller output. */
 		adj = (err_prop * RATE_CONTROL_COEFF_P


2) It seems that most of the devices out there have better sensitivity at 6
and 9M than at 11M, while others haven't, e.g.:
Rate [Mbps]	Sensitivity [dBm]
	(1)	(2)	(3)	(4)
1	-97	-91	-90	-96
2	-96		-90	-95
5.5	-95		-86	-94
11	-92	-88	-82	-94
6	-94	-85	-90	-91
9	-93		-89	-90
12	-91		-86	-88
18	-90		-82	-86
24	-86		-79	-83
36	-83		-76	-78
48	-77		-72	-76
54	-74	-69	-72	-75

(1) Ubiquiti SR2, Atheros-based
(2) Marvell 88W8686 SM module
(3) Cheap Atheros based access point
(4) Cheap Broadcom 4318E device

So, I guess we can't think of a preset ordering for rates. I tested this
with a Broadcom based device (which should be pretty similar to (4)), but the
only other wireless card which supports both 802.11b and 802.11g I got is
an Intel IPW2200 (which is not supported by any mac80211 driver). So,
testing this with an Atheros, e.g., or some new Intel device, could lead to
unexpected behaviour and thus we may need to keep some table like: rate <->
recent failed frames. But we would really need more testers here!

I'll try to provide more comments and tuning in a few days.


[1] Always remember: put at least 20cc (426 U.S. microbarrels) of water in
the microwave oven before turning it on. Failing to do so could cause kitchen
regressions.


--
Ciao
Stefano
