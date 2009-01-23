Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:61315 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbZAWFyO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 00:54:14 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 21:54:14 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18809.23220.284686.330512@gargle.gargle.HOWL> (sfid-20090123_065434_307785_B87D42F7)
Date: Fri, 23 Jan 2009 11:20:44 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/3] ath9k: Fix MCS rates registration bug for AR9285
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9285 based devices support only single stream MCS rates.
This patch fixes a bug where dual stream stream rates were
also being registered.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 8ad927a..4ff266b 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -860,7 +860,8 @@ static void ath_key_delete(struct ath_softc *sc, struct ieee80211_key_conf *key)
 	}
 }
 
-static void setup_ht_cap(struct ieee80211_sta_ht_cap *ht_info)
+static void setup_ht_cap(struct ath_softc *sc,
+			 struct ieee80211_sta_ht_cap *ht_info)
 {
 #define	ATH9K_HT_CAP_MAXRXAMPDU_65536 0x3	/* 2 ^ 16 */
 #define	ATH9K_HT_CAP_MPDUDENSITY_8 0x6		/* 8 usec */
@@ -873,10 +874,22 @@ static void setup_ht_cap(struct ieee80211_sta_ht_cap *ht_info)
 
 	ht_info->ampdu_factor = ATH9K_HT_CAP_MAXRXAMPDU_65536;
 	ht_info->ampdu_density = ATH9K_HT_CAP_MPDUDENSITY_8;
+
 	/* set up supported mcs set */
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
-	ht_info->mcs.rx_mask[0] = 0xff;
-	ht_info->mcs.rx_mask[1] = 0xff;
+
+	switch(sc->sc_rx_chainmask) {
+	case 1:
+		ht_info->mcs.rx_mask[0] = 0xff;
+		break;
+	case 5:
+	case 7:
+	default:
+		ht_info->mcs.rx_mask[0] = 0xff;
+		ht_info->mcs.rx_mask[1] = 0xff;
+		break;
+	}
+
 	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 }
 
@@ -1545,9 +1558,9 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 	hw->rate_control_algorithm = "ath9k_rate_control";
 
 	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
-		setup_ht_cap(&sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
+		setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
 		if (test_bit(ATH9K_MODE_11A, sc->sc_ah->ah_caps.wireless_modes))
-			setup_ht_cap(&sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
+			setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 	}
 
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =	&sc->sbands[IEEE80211_BAND_2GHZ];
-- 
1.6.1

