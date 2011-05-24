Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.dotsterhost.com ([72.5.54.120]:47915 "EHLO
	mail6.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab1EXNo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 09:44:26 -0400
From: Fabrice Deyber <fabricedeyber@agilemesh.com>
To: linville@tuxdriver.com
Cc: devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	nbd@openwrt.org, Fabrice Deyber <fabricedeyber@agilemesh.com>
Subject: [PATCH] ath9k: Further fix for mesh beaconing
Date: Tue, 24 May 2011 08:44:35 -0500
Message-Id: <1306244675-26109-1-git-send-email-fabricedeyber@agilemesh.com> (sfid-20110524_154438_696817_F99510D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fix ensure the timers to be set at beacon interval boundaries.
Without this change timers can be set improperly resulting in the absence of beacons.

Signed-off-by: Fabrice Deyber <fabricedeyber@agilemesh.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index d4d8cec..b7864e0 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -656,19 +656,10 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 
 	ath9k_reset_beacon_status(sc);
 
-	tsf = ath9k_hw_gettsf32(ah) + TU_TO_USEC(FUDGE);
 	intval = TU_TO_USEC(conf->beacon_interval & ATH9K_BEACON_PERIOD);
-
-	if (!sc->beacon.bc_tstamp)
-		nexttbtt = tsf + intval;
-	else {
-		if (tsf > sc->beacon.bc_tstamp)
-			delta = (tsf - sc->beacon.bc_tstamp);
-		else
-			delta = (tsf + 1 + (~0U - sc->beacon.bc_tstamp));
-		nexttbtt = tsf + intval - (delta % intval);
-	}
-
+	tsf = roundup(ath9k_hw_gettsf32(ah) + TU_TO_USEC(FUDGE), intval);
+	nexttbtt = tsf + intval;
+	
 	ath_dbg(common, ATH_DBG_BEACON,
 		"IBSS nexttbtt %u intval %u (%u)\n",
 		nexttbtt, intval, conf->beacon_interval);
-- 
1.7.0.4

