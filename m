Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:47358 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759108AbZKYUzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 15:55:54 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: enable 2GHz band only if the device supports it
Date: Wed, 25 Nov 2009 21:29:15 +0100
Message-Id: <1259180955-2145-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the 2GHz band is enabled unconditionally, even if the device
does not support it.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cbf5d2a..c0daef0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1826,12 +1826,14 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 
 	/* setup channels and rates */
 
-	sc->sbands[IEEE80211_BAND_2GHZ].channels = ath9k_2ghz_chantable;
-	sc->sbands[IEEE80211_BAND_2GHZ].bitrates =
-		sc->rates[IEEE80211_BAND_2GHZ];
-	sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
-	sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
-		ARRAY_SIZE(ath9k_2ghz_chantable);
+	if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes)) {
+		sc->sbands[IEEE80211_BAND_2GHZ].channels = ath9k_2ghz_chantable;
+		sc->sbands[IEEE80211_BAND_2GHZ].bitrates =
+			sc->rates[IEEE80211_BAND_2GHZ];
+		sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
+		sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
+			ARRAY_SIZE(ath9k_2ghz_chantable);
+	}
 
 	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes)) {
 		sc->sbands[IEEE80211_BAND_5GHZ].channels = ath9k_5ghz_chantable;
@@ -1906,8 +1908,9 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	hw->rate_control_algorithm = "ath9k_rate_control";
 
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-		&sc->sbands[IEEE80211_BAND_2GHZ];
+	if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes))
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+			&sc->sbands[IEEE80211_BAND_2GHZ];
 	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&sc->sbands[IEEE80211_BAND_5GHZ];
@@ -1946,9 +1949,12 @@ int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 	reg = &common->regulatory;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
-		setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
+		if (test_bit(ATH9K_MODE_11G, ah->caps.wireless_modes))
+			setup_ht_cap(sc,
+				     &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
 		if (test_bit(ATH9K_MODE_11A, ah->caps.wireless_modes))
-			setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
+			setup_ht_cap(sc,
+				     &sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 	}
 
 	/* initialize tx/rx engine */
-- 
1.5.3.2

