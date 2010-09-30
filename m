Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:52883 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab0I3XG6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 19:06:58 -0400
Message-ID: <4CA5180D.3010702@openwrt.org>
Date: Fri, 01 Oct 2010 01:06:53 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix channel flag / regd issues with multiple cards
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the regulatory code touches the channel array, it needs to be
copied for each device instance. That way the original channel array
can also be made const.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org [all]
---
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -57,7 +57,7 @@ MODULE_PARM_DESC(blink, "Enable LED blin
  * on 5 MHz steps, we support the channels which we know
  * we have calibration data for all cards though to make
  * this static */
-static struct ieee80211_channel ath9k_2ghz_chantable[] = {
+static const struct ieee80211_channel ath9k_2ghz_chantable[] = {
 	CHAN2G(2412, 0), /* Channel 1 */
 	CHAN2G(2417, 1), /* Channel 2 */
 	CHAN2G(2422, 2), /* Channel 3 */
@@ -78,7 +78,7 @@ static struct ieee80211_channel ath9k_2g
  * on 5 MHz steps, we support the channels which we know
  * we have calibration data for all cards though to make
  * this static */
-static struct ieee80211_channel ath9k_5ghz_chantable[] = {
+static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
 	/* _We_ call this UNII 1 */
 	CHAN5G(5180, 14), /* Channel 36 */
 	CHAN5G(5200, 15), /* Channel 40 */
@@ -478,10 +478,17 @@ err:
 	return -EIO;
 }
 
-static void ath9k_init_channels_rates(struct ath_softc *sc)
+static int ath9k_init_channels_rates(struct ath_softc *sc)
 {
+	void *channels;
+
 	if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes)) {
-		sc->sbands[IEEE80211_BAND_2GHZ].channels = ath9k_2ghz_chantable;
+		channels = kmemdup(ath9k_2ghz_chantable,
+			sizeof(ath9k_2ghz_chantable), GFP_KERNEL);
+		if (!channels)
+		    return -ENOMEM;
+
+		sc->sbands[IEEE80211_BAND_2GHZ].channels = channels;
 		sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
 		sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
 			ARRAY_SIZE(ath9k_2ghz_chantable);
@@ -491,7 +498,15 @@ static void ath9k_init_channels_rates(st
 	}
 
 	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes)) {
-		sc->sbands[IEEE80211_BAND_5GHZ].channels = ath9k_5ghz_chantable;
+		channels = kmemdup(ath9k_5ghz_chantable,
+			sizeof(ath9k_5ghz_chantable), GFP_KERNEL);
+		if (!channels) {
+			if (sc->sbands[IEEE80211_BAND_2GHZ].channels)
+				kfree(sc->sbands[IEEE80211_BAND_2GHZ].channels);
+			return -ENOMEM;
+		}
+
+		sc->sbands[IEEE80211_BAND_5GHZ].channels = channels;
 		sc->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
 		sc->sbands[IEEE80211_BAND_5GHZ].n_channels =
 			ARRAY_SIZE(ath9k_5ghz_chantable);
@@ -500,6 +515,7 @@ static void ath9k_init_channels_rates(st
 		sc->sbands[IEEE80211_BAND_5GHZ].n_bitrates =
 			ARRAY_SIZE(ath9k_legacy_rates) - 4;
 	}
+	return 0;
 }
 
 static void ath9k_init_misc(struct ath_softc *sc)
@@ -602,8 +618,11 @@ static int ath9k_init_softc(u16 devid, s
 	if (ret)
 		goto err_btcoex;
 
+	ret = ath9k_init_channels_rates(sc);
+	if (ret)
+		goto err_btcoex;
+
 	ath9k_init_crypto(sc);
-	ath9k_init_channels_rates(sc);
 	ath9k_init_misc(sc);
 
 	return 0;
@@ -784,6 +803,12 @@ static void ath9k_deinit_softc(struct at
 {
 	int i = 0;
 
+	if (sc->sbands[IEEE80211_BAND_2GHZ].channels)
+		kfree(sc->sbands[IEEE80211_BAND_2GHZ].channels);
+
+	if (sc->sbands[IEEE80211_BAND_5GHZ].channels)
+		kfree(sc->sbands[IEEE80211_BAND_5GHZ].channels);
+
         if ((sc->btcoex.no_stomp_timer) &&
 	    sc->sc_ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
