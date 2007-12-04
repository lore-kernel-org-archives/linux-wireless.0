Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:41272 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751400AbXLDBpx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 20:45:53 -0500
Date: Tue, 4 Dec 2007 02:41:46 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Cc: "Mattias Nissler" <mattias.nissler@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Message-ID: <20071204024146.15689ee3@morte> (sfid-20071204_014558_424216_26D2B9A7)
In-Reply-To: <40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com>
References: <1196622331.7472.4.camel@localhost>
	<20071203041608.3af3b462@morte>
	<1196679780.7470.9.camel@localhost>
	<20071203125402.76562f26@morte>
	<1196683144.7470.14.camel@localhost>
	<20071203130602.49ab7234@morte>
	<40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would say that these results show that the derivative coefficient is too
high, or that the sharpening factor I introduced doesn't work that good.
Anyway, just by a lowering a bit the failed frames target, results should be
far better than the plain -simple algorithm.

I hacked up a quick patch as to speed up testing for tuning.

You can use a bashscript such as the one below for an automated test. It
takes two parameters, the first one is a file (described below) with
tunings, and the second one is the file with the output results. The input
file is a list of tunings separated by a newline; each tuning value is
separated by an underscore (_). Tuning values are: rc_imul (control interval
multiplier), rc_idiv (control interval divider), rc_pf (failed frames
percentage target), rc_p (P coefficient), rc_i (I coefficient), rc_d (D
coefficient), rc_sm_s (smoothing shift), rc_sh_s (sharpening shift) and
rc_sh_d (sharpening duration). It'd be great if you could test it with this
input file:

1_1_25_15_10_15_3_0_0
1_1_25_15_10_5_3_0_1
1_1_25_15_10_5_3_1_1
1_2_25_15_10_15_3_0_0

[such as ./pid_tuning.sh file_above test_output, where file_above is the file
whose contents are listed above :) ]

Here comes the bashscript (please replace variable values at the beginning):

---

#!/bin/bash

# How to start the interface
IF_START_CMD="wpa_supplicant -Dwext -iwlan0 -c /etc/wpa_supplicant.conf -B"
# How to stop the interface
IF_STOP_CMD="killall wpa_supplicant"
# How to get an IP address - leave blank if not needed
IFCONFIG_CMD="ifconfig wlan0 192.168.1.3"
# Create a default route - leave blank if not needed
ROUTE_CMD="route add default gw 192.168.1.1"
# Module which depends on mac80211
DEPMODS="b43"
# iperf command
IPERF_CMD="iperf -c 192.168.1.100"

echo PID tuning test started at `date` > $2
echo >> $2
for i in `cat $1`; do
	echo -e 'rc_imul\trc_idiv\trc_pf\trc_p\trc_i\trc_d\trc_sm_s\trc_sh_s\trc_sh_d' >> $2
	echo -e `echo -n $i | cut -d'_' -f1`'\t'`echo -n $i | cut -d'_' -f2`'\t' \
	 `echo -n $i | cut -d'_' -f3`'\t'`echo -n $i | cut -d'_' -f4`'\t' \
	 `echo -n $i | cut -d'_' -f5`'\t'`echo -n $i | cut -d'_' -f6`'\t' \
	 `echo -n $i | cut -d'_' -f7`'\t'`echo -n $i | cut -d'_' -f8`'\t' \
	 `echo -n $i | cut -d'_' -f9`'\t' >> $2
	$IF_STOP_CMD
	for j in $DEPMODS; do
		/sbin/modprobe -r $j; done
	/sbin/modprobe -r mac80211
	/sbin/modprobe mac80211 rc_imul=`echo $i | cut -d'_' -f1` \
		rc_idiv=`echo $i | cut -d'_' -f2`
		rc_pf=`echo $i | cut -d'_' -f3` \
		rc_p=`echo $i | cut -d'_' -f4` \
		rc_i=`echo $i | cut -d'_' -f5` \
		rc_d=`echo $i | cut -d'_' -f6` \
		rc_sm_s=`echo $i | cut -d'_' -f7` \
		rc_sh_s=`echo $i | cut -d'_' -f8` \
		rc_sh_d=`echo $i | cut -d'_' -f9`
	for j in $DEPMODS; do
		/sbin/modprobe $j; done
	echo $IF_START_CMD
	$IF_START_CMD
	$IFCONFIG_CMD
	$ROUTE_CMD
	$IPERF_CMD >> $2
	echo >> $2
	echo ---- >> $2
	echo >> $2
done

---

And here comes the patch (applies on top of the original patch by Mattias and
the one I sent yesterday - ask me for a complete patch if needed):

---

Index: wireless-2.6/net/mac80211/rc80211_simple.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_simple.c
+++ wireless-2.6/net/mac80211/rc80211_simple.c
@@ -19,6 +19,41 @@
 #include "ieee80211_rate.h"
 #include "debugfs.h"
 
+static int modparam_rc_imul = 1;
+module_param_named(rc_imul, modparam_rc_imul, int, 0444);
+MODULE_PARM_DESC(rc_imul, "PID rate control interval multiplier");
+
+static int modparam_rc_idiv = 1;
+module_param_named(rc_idiv, modparam_rc_idiv, int, 0444);
+MODULE_PARM_DESC(rc_idiv, "PID rate control interval divider");
+
+static int modparam_rc_pf = 20;
+module_param_named(rc_pf, modparam_rc_pf, int, 0444);
+MODULE_PARM_DESC(rc_pf, "PID rate control failed frames percentage target");
+
+static int modparam_rc_p = 15;
+module_param_named(rc_p, modparam_rc_p, int, 0444);
+MODULE_PARM_DESC(rc_p, "PID rate control proportional coefficient");
+
+static int modparam_rc_i = 10;
+module_param_named(rc_i, modparam_rc_i, int, 0444);
+MODULE_PARM_DESC(rc_i, "PID rate control integral coefficient");
+
+static int modparam_rc_d = 15;
+module_param_named(rc_d, modparam_rc_d, int, 0444);
+MODULE_PARM_DESC(rc_d, "PID rate control derivative coefficient");
+
+static int modparam_rc_sm_s = 3;
+module_param_named(rc_sm_s, modparam_rc_sm_s, int, 0444);
+MODULE_PARM_DESC(rc_sm_s, "PID rate control smoothing factor shift");
+
+static int modparam_rc_sh_s = 2;
+module_param_named(rc_sh_s, modparam_rc_sh_s, int, 0444);
+MODULE_PARM_DESC(rc_sh_s, "PID rate control sharpening factor shift");
+
+static int modparam_rc_sh_d = 3;
+module_param_named(rc_sh_d, modparam_rc_sh_d, int, 0444);
+MODULE_PARM_DESC(rc_sh_d, "PID rate control sharpening factor duration");
 
 /* This is an implementation of TX rate control algorithm that uses a PID
  * controller. Given a target failed frames rate, the controller decides about
@@ -251,7 +286,8 @@ static void rate_control_simple_tx_statu
 	/*
 	 * Update PID controller state.
 	 */
-	if (time_after(jiffies, srctrl->last_sample + RATE_CONTROL_INTERVAL)) {
+	if (time_after(jiffies, srctrl->last_sample +
+	    (HZ * modparam_rc_imul) / modparam_rc_idiv)) {
 		u32 pf;
 		s32 err_avg;
 		s32 err_prop;
@@ -267,7 +303,7 @@ static void rate_control_simple_tx_statu
 		 */
 		if (srctrl->tx_num_xmit == 0) {
 			pf = srctrl->last_pf;
-			srctrl->sharp_cnt = RATE_CONTROL_SHARPENING_DURATION;
+			srctrl->sharp_cnt = modparam_rc_sh_d;
 		} else {
 			pf = srctrl->tx_num_failed * 100 / srctrl->tx_num_xmit;
 			pf <<= RATE_CONTROL_ARITH_SHIFT;
@@ -277,22 +313,22 @@ static void rate_control_simple_tx_statu
 		}
 
 		/* Compute the proportional, integral and derivative errors. */
-		err_prop = RATE_CONTROL_TARGET_PF - pf;
+		err_prop = (modparam_rc_pf << RATE_CONTROL_ARITH_SHIFT) - pf;
 
-		err_avg = srctrl->err_avg_sc >> RATE_CONTROL_SMOOTHING_SHIFT;
+		err_avg = srctrl->err_avg_sc >> modparam_rc_sh_s;
 		srctrl->err_avg_sc = srctrl->err_avg_sc - err_avg + err_prop;
-		err_int = srctrl->err_avg_sc >> RATE_CONTROL_SMOOTHING_SHIFT;
+		err_int = srctrl->err_avg_sc >> modparam_rc_sh_s;
 
 		err_der = (pf - srctrl->last_pf) *
-			  (1 + RATE_CONTROL_SHARPENING * srctrl->sharp_cnt);
+			  (1 + (1 << modparam_rc_sh_s) * srctrl->sharp_cnt);
 		srctrl->last_pf = pf;
 		if (srctrl->sharp_cnt)
 			srctrl->sharp_cnt--;
 
 		/* Compute the controller output. */
-		adj = (err_prop * RATE_CONTROL_COEFF_P
-		      + err_int * RATE_CONTROL_COEFF_I
-		      + err_der * RATE_CONTROL_COEFF_D)
+		adj = (err_prop * modparam_rc_p
+		      + err_int * modparam_rc_i
+		      + err_der * modparam_rc_d)
 			>> (2 * RATE_CONTROL_ARITH_SHIFT);
 
 		printk(KERN_DEBUG "rate_control: sample %d "


---

I'm privately sending you both as attachments for your convenience. Thank
you for testing.


-- 
Ciao
Stefano
