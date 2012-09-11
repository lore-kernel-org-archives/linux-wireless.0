Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60283 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2IKFRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 01:17:33 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20558.51510.106199.356401@gargle.gargle.HOWL> (sfid-20120911_071735_802820_A2202C04)
Date: Tue, 11 Sep 2012 10:46:38 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k_hw: Rename antenna diversity macros
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The register macros for antenna diversity are common for
AR9462 and AR9565, rename them.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 27 +++++++---------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 45 +++++++++++++-------------
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    | 34 +++++++++----------
 3 files changed, 51 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 87ace71..e17f69c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3631,19 +3631,16 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 		regval &= (~AR_ANT_DIV_CTRL_ALL);
 		regval |= (value & 0x3f) << AR_ANT_DIV_CTRL_ALL_S;
 		/* enable_lnadiv */
-		regval &= (~AR_PHY_9485_ANT_DIV_LNADIV);
-		regval |= ((value >> 6) & 0x1) <<
-				AR_PHY_9485_ANT_DIV_LNADIV_S;
+		regval &= (~AR_PHY_ANT_DIV_LNADIV);
+		regval |= ((value >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
 		REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
 
 		/*enable fast_div */
 		regval = REG_READ(ah, AR_PHY_CCK_DETECT);
 		regval &= (~AR_FAST_DIV_ENABLE);
-		regval |= ((value >> 7) & 0x1) <<
-				AR_FAST_DIV_ENABLE_S;
+		regval |= ((value >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
 		REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
-		ant_div_ctl1 =
-			ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
+		ant_div_ctl1 = ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
 		/* check whether antenna diversity is enabled */
 		if ((ant_div_ctl1 >> 0x6) == 0x3) {
 			regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
@@ -3651,15 +3648,15 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 			 * clear bits 25-30 main_lnaconf, alt_lnaconf,
 			 * main_tb, alt_tb
 			 */
-			regval &= (~(AR_PHY_9485_ANT_DIV_MAIN_LNACONF |
-					AR_PHY_9485_ANT_DIV_ALT_LNACONF |
-					AR_PHY_9485_ANT_DIV_ALT_GAINTB |
-					AR_PHY_9485_ANT_DIV_MAIN_GAINTB));
+			regval &= (~(AR_PHY_ANT_DIV_MAIN_LNACONF |
+				     AR_PHY_ANT_DIV_ALT_LNACONF |
+				     AR_PHY_ANT_DIV_ALT_GAINTB |
+				     AR_PHY_ANT_DIV_MAIN_GAINTB));
 			/* by default use LNA1 for the main antenna */
-			regval |= (AR_PHY_9485_ANT_DIV_LNA1 <<
-					AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S);
-			regval |= (AR_PHY_9485_ANT_DIV_LNA2 <<
-					AR_PHY_9485_ANT_DIV_ALT_LNACONF_S);
+			regval |= (AR_PHY_ANT_DIV_LNA1 <<
+				   AR_PHY_ANT_DIV_MAIN_LNACONF_S);
+			regval |= (AR_PHY_ANT_DIV_LNA2 <<
+				   AR_PHY_ANT_DIV_ALT_LNACONF_S);
 			REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
 		}
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 05d0ac0..0d800c6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1276,17 +1276,17 @@ static void ar9003_hw_set_radar_conf(struct ath_hw *ah)
 }
 
 static void ar9003_hw_antdiv_comb_conf_get(struct ath_hw *ah,
-				   struct ath_hw_antcomb_conf *antconf)
+					   struct ath_hw_antcomb_conf *antconf)
 {
 	u32 regval;
 
 	regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
-	antconf->main_lna_conf = (regval & AR_PHY_9485_ANT_DIV_MAIN_LNACONF) >>
-				  AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S;
-	antconf->alt_lna_conf = (regval & AR_PHY_9485_ANT_DIV_ALT_LNACONF) >>
-				 AR_PHY_9485_ANT_DIV_ALT_LNACONF_S;
-	antconf->fast_div_bias = (regval & AR_PHY_9485_ANT_FAST_DIV_BIAS) >>
-				  AR_PHY_9485_ANT_FAST_DIV_BIAS_S;
+	antconf->main_lna_conf = (regval & AR_PHY_ANT_DIV_MAIN_LNACONF) >>
+				  AR_PHY_ANT_DIV_MAIN_LNACONF_S;
+	antconf->alt_lna_conf = (regval & AR_PHY_ANT_DIV_ALT_LNACONF) >>
+				 AR_PHY_ANT_DIV_ALT_LNACONF_S;
+	antconf->fast_div_bias = (regval & AR_PHY_ANT_FAST_DIV_BIAS) >>
+				  AR_PHY_ANT_FAST_DIV_BIAS_S;
 
 	if (AR_SREV_9330_11(ah)) {
 		antconf->lna1_lna2_delta = -9;
@@ -1306,22 +1306,21 @@ static void ar9003_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 	u32 regval;
 
 	regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
-	regval &= ~(AR_PHY_9485_ANT_DIV_MAIN_LNACONF |
-		    AR_PHY_9485_ANT_DIV_ALT_LNACONF |
-		    AR_PHY_9485_ANT_FAST_DIV_BIAS |
-		    AR_PHY_9485_ANT_DIV_MAIN_GAINTB |
-		    AR_PHY_9485_ANT_DIV_ALT_GAINTB);
-	regval |= ((antconf->main_lna_conf <<
-					AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S)
-		   & AR_PHY_9485_ANT_DIV_MAIN_LNACONF);
-	regval |= ((antconf->alt_lna_conf << AR_PHY_9485_ANT_DIV_ALT_LNACONF_S)
-		   & AR_PHY_9485_ANT_DIV_ALT_LNACONF);
-	regval |= ((antconf->fast_div_bias << AR_PHY_9485_ANT_FAST_DIV_BIAS_S)
-		   & AR_PHY_9485_ANT_FAST_DIV_BIAS);
-	regval |= ((antconf->main_gaintb << AR_PHY_9485_ANT_DIV_MAIN_GAINTB_S)
-		   & AR_PHY_9485_ANT_DIV_MAIN_GAINTB);
-	regval |= ((antconf->alt_gaintb << AR_PHY_9485_ANT_DIV_ALT_GAINTB_S)
-		   & AR_PHY_9485_ANT_DIV_ALT_GAINTB);
+	regval &= ~(AR_PHY_ANT_DIV_MAIN_LNACONF |
+		    AR_PHY_ANT_DIV_ALT_LNACONF |
+		    AR_PHY_ANT_FAST_DIV_BIAS |
+		    AR_PHY_ANT_DIV_MAIN_GAINTB |
+		    AR_PHY_ANT_DIV_ALT_GAINTB);
+	regval |= ((antconf->main_lna_conf << AR_PHY_ANT_DIV_MAIN_LNACONF_S)
+		   & AR_PHY_ANT_DIV_MAIN_LNACONF);
+	regval |= ((antconf->alt_lna_conf << AR_PHY_ANT_DIV_ALT_LNACONF_S)
+		   & AR_PHY_ANT_DIV_ALT_LNACONF);
+	regval |= ((antconf->fast_div_bias << AR_PHY_ANT_FAST_DIV_BIAS_S)
+		   & AR_PHY_ANT_FAST_DIV_BIAS);
+	regval |= ((antconf->main_gaintb << AR_PHY_ANT_DIV_MAIN_GAINTB_S)
+		   & AR_PHY_ANT_DIV_MAIN_GAINTB);
+	regval |= ((antconf->alt_gaintb << AR_PHY_ANT_DIV_ALT_GAINTB_S)
+		   & AR_PHY_ANT_DIV_ALT_GAINTB);
 
 	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index ff5899e..accb2ab 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -280,23 +280,23 @@
 #define AR_ANT_DIV_ENABLE_S	24
 
 
-#define AR_PHY_9485_ANT_FAST_DIV_BIAS			0x00007e00
-#define AR_PHY_9485_ANT_FAST_DIV_BIAS_S                  9
-#define AR_PHY_9485_ANT_DIV_LNADIV			0x01000000
-#define AR_PHY_9485_ANT_DIV_LNADIV_S			24
-#define AR_PHY_9485_ANT_DIV_ALT_LNACONF			0x06000000
-#define AR_PHY_9485_ANT_DIV_ALT_LNACONF_S		25
-#define AR_PHY_9485_ANT_DIV_MAIN_LNACONF		0x18000000
-#define AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S		27
-#define AR_PHY_9485_ANT_DIV_ALT_GAINTB			0x20000000
-#define AR_PHY_9485_ANT_DIV_ALT_GAINTB_S		29
-#define AR_PHY_9485_ANT_DIV_MAIN_GAINTB			0x40000000
-#define AR_PHY_9485_ANT_DIV_MAIN_GAINTB_S		30
-
-#define AR_PHY_9485_ANT_DIV_LNA1_MINUS_LNA2		0x0
-#define AR_PHY_9485_ANT_DIV_LNA2			0x1
-#define AR_PHY_9485_ANT_DIV_LNA1			0x2
-#define AR_PHY_9485_ANT_DIV_LNA1_PLUS_LNA2		0x3
+#define AR_PHY_ANT_FAST_DIV_BIAS                0x00007e00
+#define AR_PHY_ANT_FAST_DIV_BIAS_S              9
+#define AR_PHY_ANT_DIV_LNADIV                   0x01000000
+#define AR_PHY_ANT_DIV_LNADIV_S                 24
+#define AR_PHY_ANT_DIV_ALT_LNACONF              0x06000000
+#define AR_PHY_ANT_DIV_ALT_LNACONF_S            25
+#define AR_PHY_ANT_DIV_MAIN_LNACONF             0x18000000
+#define AR_PHY_ANT_DIV_MAIN_LNACONF_S           27
+#define AR_PHY_ANT_DIV_ALT_GAINTB               0x20000000
+#define AR_PHY_ANT_DIV_ALT_GAINTB_S             29
+#define AR_PHY_ANT_DIV_MAIN_GAINTB              0x40000000
+#define AR_PHY_ANT_DIV_MAIN_GAINTB_S            30
+
+#define AR_PHY_ANT_DIV_LNA1_MINUS_LNA2          0x0
+#define AR_PHY_ANT_DIV_LNA2                     0x1
+#define AR_PHY_ANT_DIV_LNA1                     0x2
+#define AR_PHY_ANT_DIV_LNA1_PLUS_LNA2           0x3
 
 #define AR_PHY_EXTCHN_PWRTHR1   (AR_AGC_BASE + 0x2c)
 #define AR_PHY_EXT_CHN_WIN      (AR_AGC_BASE + 0x30)
-- 
1.7.12

