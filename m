Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lirone.symas.net ([64.71.152.235]:43056 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbZC2VtJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 17:49:09 -0400
Received: from [76.91.220.157] (helo=[192.168.1.20])
	by lirone.symas.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <hyc@symas.com>)
	id 1Lo2JS-0004rQ-4C
	for linux-wireless@vger.kernel.org; Sun, 29 Mar 2009 14:13:02 -0700
Message-ID: <49CFE458.6090708@symas.com> (sfid-20090329_234912_817024_F0E2012B)
Date: Sun, 29 Mar 2009 14:12:56 -0700
From: Howard Chu <hyc@symas.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 2.6.29 ath9k calibration
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I noticed while running powertop that I was always seeing wakeups due to ath9k 
like so:

    2.7% ( 10.0)              phy4 : ath9k_bss_info_changed (ath_ani_calibrate)

It struck me as odd that this calibration never completed. This is on an HP 
dv5z, the driver reports

[   12.343107] phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: 
mem=0xffffc20005460000, irq=17

I recompiled the module with debugging enabled to see what it was doing, and used

insmod ath9k.ko debug=0x0110

(ANI and CALIBRATION)

It basically looks like short calibration never completes. I added a few more 
debug messages as well:

[ 3230.147303] ath9k: Writing ofdmbase=12582412   cckbase=12582712
[ 3230.747582] ath9k: Writing ofdmbase=12582412   cckbase=12582712
[ 3230.946444] ath9k: shortcal @4295846580
[ 3230.946509] ath9k: ah_calSamples: 0, calNumSamples 1
[ 3230.946539] ath9k: ath9k_hw_per_cal: isCalDone: 0
[ 3230.946556] ath9k: calibrate chan 2447/500e0 nf: -115
[ 3231.347291] ath9k: Writing ofdmbase=12582412   cckbase=12582712
[ 3231.946418] ath9k: shortcal @4295846880
[ 3231.946475] ath9k: Writing ofdmbase=12582412   cckbase=12582712
[ 3231.946519] ath9k: ah_calSamples: 0, calNumSamples 1
[ 3231.946542] ath9k: ath9k_hw_per_cal: isCalDone: 0
[ 3231.946557] ath9k: calibrate chan 2447/500e0 nf: -115
[ 3232.546444] ath9k: Writing ofdmbase=12582412   cckbase=12582712
[ 3232.946425] ath9k: shortcal @4295847180
[ 3232.946496] ath9k: ah_calSamples: 0, calNumSamples 1
[ 3232.946519] ath9k: ath9k_hw_per_cal: isCalDone: 0
[ 3232.946535] ath9k: calibrate chan 2447/500e0 nf: -115
[ 3233.146461] ath9k: Writing ofdmbase=12582412   cckbase=12582712
[ 3233.746450] ath9k: Writing ofdmbase=12582412   cckbase=12582712
[ 3233.947255] ath9k: shortcal @4295847480

It seems that in calib.c ath9k_hw_per_calibration() this REG_READ test always 
fails:
 >>>
         *isCalDone = false;

         if (currCal->calState == CAL_RUNNING) {
                 DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
                         "ah_calSamples: %d, calNumSamples %d\n",
                         ahp->ah_CalSamples, currCal->calData->calNumSamples);
                 if (!(REG_READ(ah, AR_PHY_TIMING_CTRL4(0)) &
                       AR_PHY_TIMING_CTRL4_DO_CAL)) {

                         currCal->calData->calCollect(ah);
                         ahp->ah_CalSamples++;
<<<

(I added the DPRINTF there)

How is this intended to work, and why isn't it getting what it wants?

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
