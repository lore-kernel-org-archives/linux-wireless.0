Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:43659 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab3IBIdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 04:33:02 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 5/8] ath9k: Add support for AR9565 v1.0.1 LNA diversity
Date: Mon,  2 Sep 2013 13:59:03 +0530
Message-Id: <1378110546-22305-5-git-send-email-sujith@msujith.org> (sfid-20130902_103309_766291_2D2D35B5)
In-Reply-To: <1378110546-22305-1-git-send-email-sujith@msujith.org>
References: <21028.19411.335796.192256@gargle.gargle.HOWL>
 <1378110546-22305-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c    | 36 +++++++----------------------
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |  1 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  6 ++++-
 drivers/net/wireless/ath/ath9k/ath9k.h      |  1 -
 drivers/net/wireless/ath/ath9k/hw.h         |  1 +
 5 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index dd1cc73..bd048cc 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -332,7 +332,7 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 		}
 
 		if (antcomb->rssi_lna2 > antcomb->rssi_lna1 +
-		    ATH_ANT_DIV_COMB_LNA1_LNA2_SWITCH_DELTA)
+		    div_ant_conf->lna1_lna2_switch_delta)
 			div_ant_conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA2;
 		else
 			div_ant_conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA1;
@@ -554,42 +554,22 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 			ant_conf->fast_div_bias = 0x1;
 			break;
 		case 0x10: /* LNA2 A-B */
-			if ((antcomb->scan == 0) &&
-			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
-				ant_conf->fast_div_bias = 0x3f;
-			} else {
-				ant_conf->fast_div_bias = 0x1;
-			}
+			ant_conf->fast_div_bias = 0x2;
 			break;
 		case 0x12: /* LNA2 LNA1 */
-			ant_conf->fast_div_bias = 0x39;
+			ant_conf->fast_div_bias = 0x3f;
 			break;
 		case 0x13: /* LNA2 A+B */
-			if ((antcomb->scan == 0) &&
-			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
-				ant_conf->fast_div_bias = 0x3f;
-			} else {
-				ant_conf->fast_div_bias = 0x1;
-			}
+			ant_conf->fast_div_bias = 0x2;
 			break;
 		case 0x20: /* LNA1 A-B */
-			if ((antcomb->scan == 0) &&
-			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
-				ant_conf->fast_div_bias = 0x3f;
-			} else {
-				ant_conf->fast_div_bias = 0x4;
-			}
+			ant_conf->fast_div_bias = 0x3;
 			break;
 		case 0x21: /* LNA1 LNA2 */
-			ant_conf->fast_div_bias = 0x6;
+			ant_conf->fast_div_bias = 0x3;
 			break;
 		case 0x23: /* LNA1 A+B */
-			if ((antcomb->scan == 0) &&
-			    (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)) {
-				ant_conf->fast_div_bias = 0x3f;
-			} else {
-				ant_conf->fast_div_bias = 0x6;
-			}
+			ant_conf->fast_div_bias = 0x3;
 			break;
 		case 0x30: /* A+B A-B */
 			ant_conf->fast_div_bias = 0x1;
@@ -638,7 +618,7 @@ static void ath_ant_try_scan(struct ath_ant_comb *antcomb,
 		antcomb->rssi_sub = alt_rssi_avg;
 		antcomb->scan = false;
 		if (antcomb->rssi_lna2 >
-		    (antcomb->rssi_lna1 + ATH_ANT_DIV_COMB_LNA1_LNA2_SWITCH_DELTA)) {
+		    (antcomb->rssi_lna1 + conf->lna1_lna2_switch_delta)) {
 			/* use LNA2 as main LNA */
 			if ((antcomb->rssi_add > antcomb->rssi_lna1) &&
 			    (antcomb->rssi_add > antcomb->rssi_sub)) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 1fc1fa9..7a5569b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -532,6 +532,7 @@ static void ar9002_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 				 AR_PHY_9285_ANT_DIV_ALT_LNACONF_S;
 	antconf->fast_div_bias = (regval & AR_PHY_9285_FAST_DIV_BIAS) >>
 				  AR_PHY_9285_FAST_DIV_BIAS_S;
+	antconf->lna1_lna2_switch_delta = -1;
 	antconf->lna1_lna2_delta = -3;
 	antconf->div_group = 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 9ca9b2c..b8a279e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1375,15 +1375,19 @@ static void ar9003_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 				  AR_PHY_ANT_FAST_DIV_BIAS_S;
 
 	if (AR_SREV_9330_11(ah)) {
+		antconf->lna1_lna2_switch_delta = -1;
 		antconf->lna1_lna2_delta = -9;
 		antconf->div_group = 1;
 	} else if (AR_SREV_9485(ah)) {
+		antconf->lna1_lna2_switch_delta = -1;
 		antconf->lna1_lna2_delta = -9;
 		antconf->div_group = 2;
 	} else if (AR_SREV_9565(ah)) {
-		antconf->lna1_lna2_delta = -3;
+		antconf->lna1_lna2_switch_delta = 3;
+		antconf->lna1_lna2_delta = -9;
 		antconf->div_group = 3;
 	} else {
+		antconf->lna1_lna2_switch_delta = -1;
 		antconf->lna1_lna2_delta = -3;
 		antconf->div_group = 0;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2ee35f6..74a8770 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -581,7 +581,6 @@ static inline void ath_fill_led_pin(struct ath_softc *sc)
 #define ATH_ANT_DIV_COMB_ALT_ANT_RATIO_LOW_RSSI 50
 #define ATH_ANT_DIV_COMB_ALT_ANT_RATIO2_LOW_RSSI 50
 
-#define ATH_ANT_DIV_COMB_LNA1_LNA2_SWITCH_DELTA -1
 #define ATH_ANT_DIV_COMB_LNA1_DELTA_HI -4
 #define ATH_ANT_DIV_COMB_LNA1_DELTA_MID -2
 #define ATH_ANT_DIV_COMB_LNA1_DELTA_LOW 2
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 69a907b..88f67c3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -558,6 +558,7 @@ struct ath_hw_antcomb_conf {
 	u8 main_gaintb;
 	u8 alt_gaintb;
 	int lna1_lna2_delta;
+	int lna1_lna2_switch_delta;
 	u8 div_group;
 };
 
-- 
1.8.4

