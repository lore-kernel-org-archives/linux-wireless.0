Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53806 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZK0LBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 06:01:40 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis@phoenix3.szarvasnet.hu, R.Rodriguez@phoenix3.szarvasnet.hu,
	lrodriguez@atheros.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2] ath9k: enable 2GHz band only if the device supports it
Date: Fri, 27 Nov 2009 12:01:35 +0100
Message-Id: <1259319695-15826-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the 2GHz band is enabled unconditionally, even if the device
does not support it.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes since v1:
  * rebased against master-2009-11-25 of wireless-testing
  * an error message has been added, and the driver fail if neither band 
    has been marked as supported in the EEPROM

 drivers/net/wireless/ath/ath9k/hw.c   |   15 +++++++++++++--
 drivers/net/wireless/ath/ath9k/hw.h   |    2 +-
 drivers/net/wireless/ath/ath9k/main.c |   28 +++++++++++++++++-----------
 3 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 493160c..2ec61f0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -976,7 +976,10 @@ int ath9k_hw_init(struct ath_hw *ah)
 		return r;
 
 	ath9k_hw_init_mode_gain_regs(ah);
-	ath9k_hw_fill_cap_info(ah);
+	r = ath9k_hw_fill_cap_info(ah);
+	if (r)
+		return r;
+
 	ath9k_hw_init_11a_eeprom_fix(ah);
 
 	r = ath9k_hw_init_macaddr(ah);
@@ -3112,7 +3115,7 @@ EXPORT_SYMBOL(ath9k_hw_set_sta_beacon_timers);
 /* HW Capabilities */
 /*******************/
 
-void ath9k_hw_fill_cap_info(struct ath_hw *ah)
+int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
@@ -3143,6 +3146,12 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_OP_MODE);
+	if ((eeval & (AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A)) == 0) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "no band has been marked as supported in EEPROM.\n");
+		return -EINVAL;
+	}
+
 	bitmap_zero(pCap->wireless_modes, ATH9K_MODE_MAX);
 
 	if (eeval & AR5416_OPFLAGS_11A) {
@@ -3306,6 +3315,8 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	} else {
 		btcoex_hw->scheme = ATH_BTCOEX_CFG_NONE;
 	}
+
+	return 0;
 }
 
 bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 46e1572..e2b0c73 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -620,7 +620,7 @@ void ath9k_hw_detach(struct ath_hw *ah);
 int ath9k_hw_init(struct ath_hw *ah);
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   bool bChannelChange);
-void ath9k_hw_fill_cap_info(struct ath_hw *ah);
+int ath9k_hw_fill_cap_info(struct ath_hw *ah);
 bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result);
 bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b959814..c487434 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1793,13 +1793,15 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 
 	/* setup channels and rates */
 
-	sc->sbands[IEEE80211_BAND_2GHZ].channels = ath9k_2ghz_chantable;
-	sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
-	sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
-		ARRAY_SIZE(ath9k_2ghz_chantable);
-	sc->sbands[IEEE80211_BAND_2GHZ].bitrates = ath9k_legacy_rates;
-	sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates =
-		ARRAY_SIZE(ath9k_legacy_rates);
+	if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes)) {
+		sc->sbands[IEEE80211_BAND_2GHZ].channels = ath9k_2ghz_chantable;
+		sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
+		sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
+			ARRAY_SIZE(ath9k_2ghz_chantable);
+		sc->sbands[IEEE80211_BAND_2GHZ].bitrates = ath9k_legacy_rates;
+		sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates =
+			ARRAY_SIZE(ath9k_legacy_rates);
+	}
 
 	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes)) {
 		sc->sbands[IEEE80211_BAND_5GHZ].channels = ath9k_5ghz_chantable;
@@ -1876,8 +1878,9 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	hw->rate_control_algorithm = "ath9k_rate_control";
 
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-		&sc->sbands[IEEE80211_BAND_2GHZ];
+	if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes))
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+			&sc->sbands[IEEE80211_BAND_2GHZ];
 	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&sc->sbands[IEEE80211_BAND_5GHZ];
@@ -1916,9 +1919,12 @@ int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
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

