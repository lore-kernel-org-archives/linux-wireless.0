Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:64679 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaBZJEI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 04:04:08 -0500
Received: from ultralex.lan ([93.218.100.117]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0Lpgew-1WvVWy2PTy-00fPrC for
 <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 10:04:06 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linville@tuxdriver.com, sujith@msujith.org,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 1/3] ath9k: remove unused listen_interval and sleepduration.
Date: Wed, 26 Feb 2014 10:03:43 +0100
Message-Id: <1393405425-16371-2-git-send-email-linux@rempel-privat.de> (sfid-20140226_100421_958125_1972AEEC)
In-Reply-To: <1393405425-16371-1-git-send-email-linux@rempel-privat.de>
References: <1393405425-16371-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this variable never changed.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  1 -
 drivers/net/wireless/ath/ath9k/beacon.c | 21 +++++++--------------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index e703ddad..f995c37 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -410,7 +410,6 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 
 struct ath_beacon_config {
 	int beacon_interval;
-	u16 listen_interval;
 	u16 dtim_period;
 	u16 bmiss_timeout;
 	u8 dtim_count;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 6569528..02eb4f1 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -519,7 +519,7 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_beacon_state bs;
-	int dtim_intval, sleepduration;
+	int dtim_intval;
 	u32 nexttbtt = 0, intval;
 	u64 tsf;
 
@@ -538,7 +538,6 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	 * last beacon we received (which may be none).
 	 */
 	dtim_intval = intval * conf->dtim_period;
-	sleepduration = conf->listen_interval * intval;
 
 	/*
 	 * Pull nexttbtt forward to reflect the current
@@ -560,16 +559,11 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	 * need calculate based	on the beacon interval.  Note that we clamp the
 	 * result to at most 15 beacons.
 	 */
-	if (sleepduration > intval) {
-		bs.bs_bmissthreshold = conf->listen_interval *
-			ATH_DEFAULT_BMISS_LIMIT / 2;
-	} else {
-		bs.bs_bmissthreshold = DIV_ROUND_UP(conf->bmiss_timeout, intval);
-		if (bs.bs_bmissthreshold > 15)
-			bs.bs_bmissthreshold = 15;
-		else if (bs.bs_bmissthreshold <= 0)
-			bs.bs_bmissthreshold = 1;
-	}
+	bs.bs_bmissthreshold = DIV_ROUND_UP(conf->bmiss_timeout, intval);
+	if (bs.bs_bmissthreshold > 15)
+		bs.bs_bmissthreshold = 15;
+	else if (bs.bs_bmissthreshold <= 0)
+		bs.bs_bmissthreshold = 1;
 
 	/*
 	 * Calculate sleep duration. The configuration is given in ms.
@@ -581,7 +575,7 @@ static void ath9k_beacon_config_sta(struct ath_softc *sc,
 	 */
 
 	bs.bs_sleepduration = TU_TO_USEC(roundup(IEEE80211_MS_TO_TU(100),
-						 sleepduration));
+						 intval));
 	if (bs.bs_sleepduration > bs.bs_dtimperiod)
 		bs.bs_sleepduration = bs.bs_dtimperiod;
 
@@ -677,7 +671,6 @@ static void ath9k_cache_beacon_config(struct ath_softc *sc,
 
 	cur_conf->beacon_interval = bss_conf->beacon_int;
 	cur_conf->dtim_period = bss_conf->dtim_period;
-	cur_conf->listen_interval = 1;
 	cur_conf->dtim_count = 1;
 	cur_conf->ibss_creator = bss_conf->ibss_creator;
 	cur_conf->bmiss_timeout =
-- 
1.9.0

