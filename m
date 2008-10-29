Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51562 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbYJ2Et3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:49:29 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:49:29 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.60092.575797.975549@gargle.gargle.HOWL> (sfid-20081029_054932_483896_45824289)
Date: Wed, 29 Oct 2008 10:16:52 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 09/16] ath9k: Remove unused function ath_get_currentCountry()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |   23 -----------------------
 drivers/net/wireless/ath9k/core.h |    2 --
 2 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index aa1f1fc..b45953f 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -17,8 +17,6 @@
 #include "core.h"
 #include "regd.h"
 
-static int ath_outdoor;		/* enable outdoor use */
-
 static u32 ath_chainmask_sel_up_rssi_thres =
 	ATH_CHAINMASK_SEL_UP_RSSI_THRES;
 static u32 ath_chainmask_sel_down_rssi_thres =
@@ -1349,27 +1347,6 @@ void ath_update_txpow(struct ath_softc *sc)
 	}
 }
 
-/* Return the current country and domain information */
-void ath_get_currentCountry(struct ath_softc *sc,
-	struct ath9k_country_entry *ctry)
-{
-	ath9k_regd_get_current_country(sc->sc_ah, ctry);
-
-	/* If HAL not specific yet, since it is band dependent,
-	 * use the one we passed in. */
-	if (ctry->countryCode == CTRY_DEFAULT) {
-		ctry->iso[0] = 0;
-		ctry->iso[1] = 0;
-	} else if (ctry->iso[0] && ctry->iso[1]) {
-		if (!ctry->iso[2]) {
-			if (ath_outdoor)
-				ctry->iso[2] = 'O';
-			else
-				ctry->iso[2] = 'I';
-		}
-	}
-}
-
 /**************************/
 /* Slow Antenna Diversity */
 /**************************/
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index c03acf7..fdaecb1 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -1018,8 +1018,6 @@ int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
 void ath_setslottime(struct ath_softc *sc);
 void ath_update_txpow(struct ath_softc *sc);
 int ath_cabq_update(struct ath_softc *);
-void ath_get_currentCountry(struct ath_softc *sc,
-	struct ath9k_country_entry *ctry);
 u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp);
 
 #endif /* CORE_H */
-- 
1.6.0.3

