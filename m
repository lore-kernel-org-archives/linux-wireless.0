Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25184 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758287AbZC3KCz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:55 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:02:53 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38867.997551.983464@gargle.gargle.HOWL> (sfid-20090330_120316_648460_61360475)
Date: Mon, 30 Mar 2009 15:28:43 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 11/17] ath9k: Remove TIM from the interrupt mask
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We never handle TIM, TIM_TIMER is used instead.
Remove this and the unnecessary swBeaconProcess variable.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath9k/main.c  |   14 --------------
 2 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index bdd5c6b..6aba991 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -70,7 +70,6 @@ struct ath_config {
 	u32 ath_aggr_prot;
 	u16 txpowlimit;
 	u8 cabqReadytime;
-	u8 swBeaconProcess;
 };
 
 /*************************/
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index b252a1f..d510c4e 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1543,9 +1543,6 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 		sc->beacon.bslot_aphy[i] = NULL;
 	}
 
-	/* save MISC configurations */
-	sc->config.swBeaconProcess = 1;
-
 	/* setup channels and rates */
 
 	sc->sbands[IEEE80211_BAND_2GHZ].channels = ath9k_2ghz_chantable;
@@ -2254,17 +2251,6 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		sc->imask |= ATH9K_INT_TSFOOR;
 	}
 
-	/*
-	 * Some hardware processes the TIM IE and fires an
-	 * interrupt when the TIM bit is set.  For hardware
-	 * that does, if not overridden by configuration,
-	 * enable the TIM interrupt when operating as station.
-	 */
-	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
-	    (conf->type == NL80211_IFTYPE_STATION) &&
-	    !sc->config.swBeaconProcess)
-		sc->imask |= ATH9K_INT_TIM;
-
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
 	if (conf->type == NL80211_IFTYPE_AP) {
-- 
1.6.2.1

