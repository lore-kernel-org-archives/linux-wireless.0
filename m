Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:57768 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756724AbZETS4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 14:56:43 -0400
Date: Wed, 20 May 2009 21:56:39 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Optimize TBTT/DTIM calculation for timers
Message-ID: <20090520185639.GA25436@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous version used a simple loop to go through all Beacon
frames when determining the next TBTT and DTIM count. This is not too
bad for the case where the setup happens before timesync (i.e., very
small TSF), but this can become very heavy operation if a short Beacon
interval is used and the current TSF is large.

In preparation for a patch to update timer setup based on Beacon
timestamp, optimize this routine to take fixed time regardless of the
actual TSF value.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/beacon.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/beacon.c	2009-05-20 21:19:31.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/beacon.c	2009-05-20 21:26:10.000000000 +0300
@@ -559,6 +559,7 @@ static void ath_beacon_config_sta(struct
 	int cfpperiod, cfpcount;
 	u32 nexttbtt = 0, intval, tsftu;
 	u64 tsf;
+	int num_beacons, offset, dtim_dec_count, cfp_dec_count;
 
 	memset(&bs, 0, sizeof(bs));
 	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
@@ -586,14 +587,27 @@ static void ath_beacon_config_sta(struct
 	 */
 	tsf = ath9k_hw_gettsf64(sc->sc_ah);
 	tsftu = TSF_TO_TU(tsf>>32, tsf) + FUDGE;
-	do {
+
+	num_beacons = tsftu / intval + 1;
+	offset = tsftu % intval;
+	nexttbtt = tsftu - offset;
+	if (offset)
 		nexttbtt += intval;
-		if (--dtimcount < 0) {
-			dtimcount = dtimperiod - 1;
-			if (--cfpcount < 0)
-				cfpcount = cfpperiod - 1;
-		}
-	} while (nexttbtt < tsftu);
+
+	/* DTIM Beacon every dtimperiod Beacon */
+	dtim_dec_count = num_beacons % dtimperiod;
+	/* CFP every cfpperiod DTIM Beacon */
+	cfp_dec_count = (num_beacons / dtimperiod) % cfpperiod;
+	if (dtim_dec_count)
+		cfp_dec_count++;
+
+	dtimcount -= dtim_dec_count;
+	if (dtimcount < 0)
+		dtimcount += dtimperiod;
+
+	cfpcount -= cfp_dec_count;
+	if (cfpcount < 0)
+		cfpcount += cfpperiod;
 
 	bs.bs_intval = intval;
 	bs.bs_nexttbtt = nexttbtt;

-- 
Jouni Malinen                                            PGP id EFC895FA
