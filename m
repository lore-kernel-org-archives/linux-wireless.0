Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50711 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaBZJEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 04:04:13 -0500
Received: from ultralex.lan ([93.218.100.117]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0MWQSM-1Wlm9Q2H5G-00XfUo for
 <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 10:04:10 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linville@tuxdriver.com, sujith@msujith.org,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 2/3] ath9k_htc: remove unused variable sleepduration
Date: Wed, 26 Feb 2014 10:03:44 +0100
Message-Id: <1393405425-16371-3-git-send-email-linux@rempel-privat.de> (sfid-20140226_100454_217561_92E7B6FF)
In-Reply-To: <1393405425-16371-1-git-send-email-linux@rempel-privat.de>
References: <1393405425-16371-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sleepduration is always = intval.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 8b57577..a00ddb9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -69,7 +69,7 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_beacon_state bs;
 	enum ath9k_int imask = 0;
-	int dtimperiod, dtimcount, sleepduration;
+	int dtimperiod, dtimcount;
 	int bmiss_timeout;
 	u32 nexttbtt = 0, intval, tsftu;
 	__be32 htc_imask = 0;
@@ -94,10 +94,6 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	if (dtimcount >= dtimperiod)	/* NB: sanity check */
 		dtimcount = 0;
 
-	sleepduration = intval;
-	if (sleepduration <= 0)
-		sleepduration = intval;
-
 	/*
 	 * Pull nexttbtt forward to reflect the current
 	 * TSF and calculate dtim state for the result.
@@ -128,15 +124,11 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	 * need calculate based	on the beacon interval.  Note that we clamp the
 	 * result to at most 15 beacons.
 	 */
-	if (sleepduration > intval) {
-		bs.bs_bmissthreshold = ATH_DEFAULT_BMISS_LIMIT / 2;
-	} else {
-		bs.bs_bmissthreshold = DIV_ROUND_UP(bmiss_timeout, intval);
-		if (bs.bs_bmissthreshold > 15)
-			bs.bs_bmissthreshold = 15;
-		else if (bs.bs_bmissthreshold <= 0)
-			bs.bs_bmissthreshold = 1;
-	}
+	bs.bs_bmissthreshold = DIV_ROUND_UP(bmiss_timeout, intval);
+	if (bs.bs_bmissthreshold > 15)
+		bs.bs_bmissthreshold = 15;
+	else if (bs.bs_bmissthreshold <= 0)
+		bs.bs_bmissthreshold = 1;
 
 	/*
 	 * Calculate sleep duration. The configuration is given in ms.
@@ -148,7 +140,7 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	 */
 
 	bs.bs_sleepduration = TU_TO_USEC(roundup(IEEE80211_MS_TO_TU(100),
-						 sleepduration));
+						 intval));
 	if (bs.bs_sleepduration > bs.bs_dtimperiod)
 		bs.bs_sleepduration = bs.bs_dtimperiod;
 
-- 
1.9.0

