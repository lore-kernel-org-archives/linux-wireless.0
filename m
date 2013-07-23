Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57423 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab3GWK6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 06:58:45 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix diversity combining for AR9285
Date: Tue, 23 Jul 2013 16:25:17 +0530
Message-Id: <1374576917-26636-1-git-send-email-sujith@msujith.org> (sfid-20130723_125849_133923_03A7C279)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When antenna diversity combining is enabled in the EEPROM,
the initial values for the MAIN/ALT config have to be
programmed correctly. This patch adds it for AR9285.

Since the diversity combining macros are common to all chip
families, remove the redundant AR9285 macros and move the
definitions to phy.h.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.h    |  4 ----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  4 ++--
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    |  4 ++--
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |  5 -----
 drivers/net/wireless/ath/ath9k/ath9k.h         |  7 -------
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     | 19 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/phy.h           |  7 +++++++
 7 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
index f9eb2c3..d3f0928 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -317,10 +317,6 @@
 #define AR_PHY_9285_ANT_DIV_ALT_GAINTB_S    29
 #define AR_PHY_9285_ANT_DIV_MAIN_GAINTB     0x40000000
 #define AR_PHY_9285_ANT_DIV_MAIN_GAINTB_S   30
-#define AR_PHY_9285_ANT_DIV_LNA1            2
-#define AR_PHY_9285_ANT_DIV_LNA2            1
-#define AR_PHY_9285_ANT_DIV_LNA1_PLUS_LNA2  3
-#define AR_PHY_9285_ANT_DIV_LNA1_MINUS_LNA2 0
 #define AR_PHY_9285_ANT_DIV_GAINTB_0        0
 #define AR_PHY_9285_ANT_DIV_GAINTB_1        1
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d105e43..a98e6a3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3673,9 +3673,9 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 				     AR_PHY_ANT_DIV_ALT_GAINTB |
 				     AR_PHY_ANT_DIV_MAIN_GAINTB));
 			/* by default use LNA1 for the main antenna */
-			regval |= (AR_PHY_ANT_DIV_LNA1 <<
+			regval |= (ATH_ANT_DIV_COMB_LNA1 <<
 				   AR_PHY_ANT_DIV_MAIN_LNACONF_S);
-			regval |= (AR_PHY_ANT_DIV_LNA2 <<
+			regval |= (ATH_ANT_DIV_COMB_LNA2 <<
 				   AR_PHY_ANT_DIV_ALT_LNACONF_S);
 			REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
 		}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 2db4ddf..3ec33ce 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1465,8 +1465,8 @@ static void ar9003_hw_antctrl_shared_chain_lnadiv(struct ath_hw *ah,
 			AR_PHY_ANT_DIV_ALT_LNACONF |
 			AR_PHY_ANT_DIV_MAIN_GAINTB |
 			AR_PHY_ANT_DIV_ALT_GAINTB);
-		regval |= (AR_PHY_ANT_DIV_LNA1 << AR_PHY_ANT_DIV_MAIN_LNACONF_S);
-		regval |= (AR_PHY_ANT_DIV_LNA2 << AR_PHY_ANT_DIV_ALT_LNACONF_S);
+		regval |= (ATH_ANT_DIV_COMB_LNA1 << AR_PHY_ANT_DIV_MAIN_LNACONF_S);
+		regval |= (ATH_ANT_DIV_COMB_LNA2 << AR_PHY_ANT_DIV_ALT_LNACONF_S);
 		REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index d4d39f3..23c019d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -296,11 +296,6 @@
 #define AR_PHY_ANT_DIV_MAIN_GAINTB              0x40000000
 #define AR_PHY_ANT_DIV_MAIN_GAINTB_S            30
 
-#define AR_PHY_ANT_DIV_LNA1_MINUS_LNA2          0x0
-#define AR_PHY_ANT_DIV_LNA2                     0x1
-#define AR_PHY_ANT_DIV_LNA1                     0x2
-#define AR_PHY_ANT_DIV_LNA1_PLUS_LNA2           0x3
-
 #define AR_PHY_EXTCHN_PWRTHR1   (AR_AGC_BASE + 0x2c)
 #define AR_PHY_EXT_CHN_WIN      (AR_AGC_BASE + 0x30)
 #define AR_PHY_20_40_DET_THR    (AR_AGC_BASE + 0x34)
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index c1224b5..76e38d3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -591,13 +591,6 @@ static inline void ath_fill_led_pin(struct ath_softc *sc)
 #define ATH_ANT_DIV_COMB_LNA1_DELTA_MID -2
 #define ATH_ANT_DIV_COMB_LNA1_DELTA_LOW 2
 
-enum ath9k_ant_div_comb_lna_conf {
-	ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2,
-	ATH_ANT_DIV_COMB_LNA2,
-	ATH_ANT_DIV_COMB_LNA1,
-	ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2,
-};
-
 struct ath_ant_comb {
 	u16 count;
 	u16 total_pkt_count;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index c2bfd748..9ea8e4b 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -812,6 +812,7 @@ static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 					 struct ath9k_channel *chan)
 {
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct modal_eep_4k_header *pModal;
 	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
 	struct base_eep_header_4k *pBase = &eep->baseEepHeader;
@@ -858,6 +859,24 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 
 		REG_WRITE(ah, AR_PHY_CCK_DETECT, regVal);
 		regVal = REG_READ(ah, AR_PHY_CCK_DETECT);
+
+		if (pCap->hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
+			/*
+			 * If diversity combining is enabled,
+			 * set MAIN to LNA1 and ALT to LNA2 initially.
+			 */
+			regVal = REG_READ(ah, AR_PHY_MULTICHAIN_GAIN_CTL);
+			regVal &= (~(AR_PHY_9285_ANT_DIV_MAIN_LNACONF |
+				     AR_PHY_9285_ANT_DIV_ALT_LNACONF));
+
+			regVal |= (ATH_ANT_DIV_COMB_LNA1 <<
+				   AR_PHY_9285_ANT_DIV_MAIN_LNACONF_S);
+			regVal |= (ATH_ANT_DIV_COMB_LNA2 <<
+				   AR_PHY_9285_ANT_DIV_ALT_LNACONF_S);
+			regVal &= (~(AR_PHY_9285_FAST_DIV_BIAS));
+			regVal |= (0 << AR_PHY_9285_FAST_DIV_BIAS_S);
+			REG_WRITE(ah, AR_PHY_MULTICHAIN_GAIN_CTL, regVal);
+		}
 	}
 
 	if (pModal->version >= 2) {
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 8b38030..4a1b992 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -48,4 +48,11 @@
 #define AR_PHY_PLL_CONTROL 0x16180
 #define AR_PHY_PLL_MODE 0x16184
 
+enum ath9k_ant_div_comb_lna_conf {
+	ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2,
+	ATH_ANT_DIV_COMB_LNA2,
+	ATH_ANT_DIV_COMB_LNA1,
+	ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2,
+};
+
 #endif
-- 
1.8.3.3

