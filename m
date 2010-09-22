Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60284 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab0IVKfI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 06:35:08 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/3] ath9k_hw: simplify revision checks for AR9285
Date: Wed, 22 Sep 2010 12:34:53 +0200
Message-Id: <1285151694-39227-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1285151694-39227-1-git-send-email-nbd@openwrt.org>
References: <1285151694-39227-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since AR9285 v1.0 and v1.1 were never sold (and the initvals removed),
its revision checks can be simplified similar to AR9280

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |   11 +----------
 drivers/net/wireless/ath/ath9k/eeprom_4k.c    |    6 ------
 drivers/net/wireless/ath/ath9k/hw.c           |    8 ++++----
 drivers/net/wireless/ath/ath9k/recv.c         |    2 +-
 drivers/net/wireless/ath/ath9k/reg.h          |   16 +---------------
 6 files changed, 8 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 9318ae7..79dfe9d 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -701,7 +701,7 @@ static void ar5008_hw_set_channel_regs(struct ath_hw *ah,
 	u32 phymode;
 	u32 enableDacFifo = 0;
 
-	if (AR_SREV_9285_10_OR_LATER(ah))
+	if (AR_SREV_9285_12_OR_LATER(ah))
 		enableDacFifo = (REG_READ(ah, AR_PHY_TURBO) &
 					 AR_PHY_FC_ENABLE_DAC_FIFO);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index dc64afe..5d08151 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -567,11 +567,6 @@ static inline void ar9285_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 	    AR5416_EEP_TXGAIN_HIGH_POWER)
 		return;
 
-	if (AR_SREV_9285_11(ah)) {
-		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
-		udelay(10);
-	}
-
 	for (i = 0; i < ARRAY_SIZE(regList); i++)
 		regList[i][1] = REG_READ(ah, regList[i][0]);
 
@@ -651,10 +646,6 @@ static inline void ar9285_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 		REG_WRITE(ah, regList[i][0], regList[i][1]);
 
 	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_CCOMP, ccomp_org);
-
-	if (AR_SREV_9285_11(ah))
-		REG_WRITE(ah, AR9285_AN_TOP4, AR9285_AN_TOP4_DEFAULT);
-
 }
 
 static void ar9002_hw_pa_cal(struct ath_hw *ah, bool is_reset)
@@ -664,7 +655,7 @@ static void ar9002_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 			ar9271_hw_pa_cal(ah, is_reset);
 		else
 			ah->pacal_info.skipcount--;
-	} else if (AR_SREV_9285_11_OR_LATER(ah)) {
+	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
 		if (is_reset || !ah->pacal_info.skipcount)
 			ar9285_hw_pa_cal(ah, is_reset);
 		else
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 677e0c9..d6eed1f 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -909,9 +909,6 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 		      AR9280_PHY_RXGAIN_TXRX_ATTEN, txRxAttenLocal);
 	REG_RMW_FIELD(ah, AR_PHY_RXGAIN + 0x1000,
 		      AR9280_PHY_RXGAIN_TXRX_MARGIN, pModal->rxTxMarginCh[0]);
-
-	if (AR_SREV_9285_11(ah))
-		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
 }
 
 /*
@@ -1109,9 +1106,6 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 	}
 
 
-	if (AR_SREV_9285_11(ah))
-		REG_WRITE(ah, AR9285_AN_TOP4, AR9285_AN_TOP4_DEFAULT);
-
 	REG_RMW_FIELD(ah, AR_PHY_SETTLING, AR_PHY_SETTLING_SWITCH,
 		      pModal->switchSettling);
 	REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ, AR_PHY_DESIRED_SZ_ADC,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f2255a2..1f41b45 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1190,7 +1190,7 @@ bool ath9k_hw_check_alive(struct ath_hw *ah)
 	int count = 50;
 	u32 reg;
 
-	if (AR_SREV_9285_10_OR_LATER(ah))
+	if (AR_SREV_9285_12_OR_LATER(ah))
 		return true;
 
 	do {
@@ -1787,7 +1787,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	regulatory->current_rd = eeval;
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_1);
-	if (AR_SREV_9285_10_OR_LATER(ah))
+	if (AR_SREV_9285_12_OR_LATER(ah))
 		eeval |= AR9285_RDEXT_DEFAULT;
 	regulatory->current_rd_ext = eeval;
 
@@ -1893,7 +1893,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->num_gpio_pins = AR9271_NUM_GPIO;
 	else if (AR_DEVID_7010(ah))
 		pCap->num_gpio_pins = AR7010_NUM_GPIO;
-	else if (AR_SREV_9285_10_OR_LATER(ah))
+	else if (AR_SREV_9285_12_OR_LATER(ah))
 		pCap->num_gpio_pins = AR9285_NUM_GPIO;
 	else if (AR_SREV_9280_20_OR_LATER(ah))
 		pCap->num_gpio_pins = AR928X_NUM_GPIO;
@@ -2075,7 +2075,7 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 		return MS_REG_READ(AR9271, gpio) != 0;
 	else if (AR_SREV_9287_10_OR_LATER(ah))
 		return MS_REG_READ(AR9287, gpio) != 0;
-	else if (AR_SREV_9285_10_OR_LATER(ah))
+	else if (AR_SREV_9285_12_OR_LATER(ah))
 		return MS_REG_READ(AR9285, gpio) != 0;
 	else if (AR_SREV_9280_20_OR_LATER(ah))
 		return MS_REG_READ(AR928X, gpio) != 0;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 7b6f66b..0014048 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -455,7 +455,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	if ((AR_SREV_9280_20_OR_LATER(sc->sc_ah) ||
-	    AR_SREV_9285_10_OR_LATER(sc->sc_ah)) &&
+	    AR_SREV_9285_12_OR_LATER(sc->sc_ah)) &&
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_AP) &&
 	    (sc->rx.rxfilter & FIF_PSPOLL))
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index cabfa03..7ff814d 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -826,22 +826,8 @@
 
 #define AR_SREV_9285(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9285))
-#define AR_SREV_9285_10_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9285))
-#define AR_SREV_9285_11(_ah) \
-	(AR_SREV_9285(ah) && \
-	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9285_11))
-#define AR_SREV_9285_11_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9285) || \
-	 (AR_SREV_9285(ah) && ((_ah)->hw_version.macRev >= \
-			       AR_SREV_REVISION_9285_11)))
-#define AR_SREV_9285_12(_ah) \
-	(AR_SREV_9285(ah) && \
-	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9285_12))
 #define AR_SREV_9285_12_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9285) || \
-	 (AR_SREV_9285(ah) && ((_ah)->hw_version.macRev >= \
-			       AR_SREV_REVISION_9285_12)))
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9285))
 
 #define AR_SREV_9287(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287))
-- 
1.7.2.2

