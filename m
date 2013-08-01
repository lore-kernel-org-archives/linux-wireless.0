Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44857 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3HAG1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 02:27:03 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/8] ath9k: Use a helper function for checking LNA options
Date: Thu,  1 Aug 2013 11:53:21 +0530
Message-Id: <1375338204-2021-5-git-send-email-sujith@msujith.org> (sfid-20130801_082736_324618_F6D75BA3)
In-Reply-To: <1375338204-2021-1-git-send-email-sujith@msujith.org>
References: <1375338204-2021-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 166 +++++++++++++++----------------
 1 file changed, 79 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 8675c3f..c52959b 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -596,6 +596,79 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 	}
 }
 
+static void ath_ant_try_scan(struct ath_ant_comb *antcomb,
+			     struct ath_hw_antcomb_conf *conf,
+			     int curr_alt_set, int alt_rssi_avg,
+			     int main_rssi_avg)
+{
+	switch (curr_alt_set) {
+	case ATH_ANT_DIV_COMB_LNA2:
+		antcomb->rssi_lna2 = alt_rssi_avg;
+		antcomb->rssi_lna1 = main_rssi_avg;
+		antcomb->scan = true;
+		/* set to A+B */
+		conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+		conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+		break;
+	case ATH_ANT_DIV_COMB_LNA1:
+		antcomb->rssi_lna1 = alt_rssi_avg;
+		antcomb->rssi_lna2 = main_rssi_avg;
+		antcomb->scan = true;
+		/* set to A+B */
+		conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+		conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+		break;
+	case ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2:
+		antcomb->rssi_add = alt_rssi_avg;
+		antcomb->scan = true;
+		/* set to A-B */
+		conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
+		break;
+	case ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2:
+		antcomb->rssi_sub = alt_rssi_avg;
+		antcomb->scan = false;
+		if (antcomb->rssi_lna2 >
+		    (antcomb->rssi_lna1 + ATH_ANT_DIV_COMB_LNA1_LNA2_SWITCH_DELTA)) {
+			/* use LNA2 as main LNA */
+			if ((antcomb->rssi_add > antcomb->rssi_lna1) &&
+			    (antcomb->rssi_add > antcomb->rssi_sub)) {
+				/* set to A+B */
+				conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+			} else if (antcomb->rssi_sub >
+				   antcomb->rssi_lna1) {
+				/* set to A-B */
+				conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
+			} else {
+				/* set to LNA1 */
+				conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+			}
+		} else {
+			/* use LNA1 as main LNA */
+			if ((antcomb->rssi_add > antcomb->rssi_lna2) &&
+			    (antcomb->rssi_add > antcomb->rssi_sub)) {
+				/* set to A+B */
+				conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
+			} else if (antcomb->rssi_sub >
+				   antcomb->rssi_lna1) {
+				/* set to A-B */
+				conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
+			} else {
+				/* set to LNA2 */
+				conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+			}
+		}
+		break;
+	default:
+		break;
+	}
+}
+
 static bool ath_ant_try_switch(struct ath_hw_antcomb_conf *div_ant_conf,
 			       int alt_ratio, int alt_rssi_avg,
 			       int main_rssi_avg, int curr_main_set,
@@ -735,103 +808,22 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 		goto div_comb_done;
 
 	if (!antcomb->scan_not_start) {
-		switch (curr_alt_set) {
-		case ATH_ANT_DIV_COMB_LNA2:
-			antcomb->rssi_lna2 = alt_rssi_avg;
-			antcomb->rssi_lna1 = main_rssi_avg;
-			antcomb->scan = true;
-			/* set to A+B */
-			div_ant_conf.main_lna_conf =
-				ATH_ANT_DIV_COMB_LNA1;
-			div_ant_conf.alt_lna_conf  =
-				ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
-			break;
-		case ATH_ANT_DIV_COMB_LNA1:
-			antcomb->rssi_lna1 = alt_rssi_avg;
-			antcomb->rssi_lna2 = main_rssi_avg;
-			antcomb->scan = true;
-			/* set to A+B */
-			div_ant_conf.main_lna_conf = ATH_ANT_DIV_COMB_LNA2;
-			div_ant_conf.alt_lna_conf  =
-				ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
-			break;
-		case ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2:
-			antcomb->rssi_add = alt_rssi_avg;
-			antcomb->scan = true;
-			/* set to A-B */
-			div_ant_conf.alt_lna_conf =
-				ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
-			break;
-		case ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2:
-			antcomb->rssi_sub = alt_rssi_avg;
-			antcomb->scan = false;
-			if (antcomb->rssi_lna2 >
-			    (antcomb->rssi_lna1 +
-			    ATH_ANT_DIV_COMB_LNA1_LNA2_SWITCH_DELTA)) {
-				/* use LNA2 as main LNA */
-				if ((antcomb->rssi_add > antcomb->rssi_lna1) &&
-				    (antcomb->rssi_add > antcomb->rssi_sub)) {
-					/* set to A+B */
-					div_ant_conf.main_lna_conf =
-						ATH_ANT_DIV_COMB_LNA2;
-					div_ant_conf.alt_lna_conf  =
-						ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
-				} else if (antcomb->rssi_sub >
-					   antcomb->rssi_lna1) {
-					/* set to A-B */
-					div_ant_conf.main_lna_conf =
-						ATH_ANT_DIV_COMB_LNA2;
-					div_ant_conf.alt_lna_conf =
-						ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
-				} else {
-					/* set to LNA1 */
-					div_ant_conf.main_lna_conf =
-						ATH_ANT_DIV_COMB_LNA2;
-					div_ant_conf.alt_lna_conf =
-						ATH_ANT_DIV_COMB_LNA1;
-				}
-			} else {
-				/* use LNA1 as main LNA */
-				if ((antcomb->rssi_add > antcomb->rssi_lna2) &&
-				    (antcomb->rssi_add > antcomb->rssi_sub)) {
-					/* set to A+B */
-					div_ant_conf.main_lna_conf =
-						ATH_ANT_DIV_COMB_LNA1;
-					div_ant_conf.alt_lna_conf  =
-						ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
-				} else if (antcomb->rssi_sub >
-					   antcomb->rssi_lna1) {
-					/* set to A-B */
-					div_ant_conf.main_lna_conf =
-						ATH_ANT_DIV_COMB_LNA1;
-					div_ant_conf.alt_lna_conf =
-						ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
-				} else {
-					/* set to LNA2 */
-					div_ant_conf.main_lna_conf =
-						ATH_ANT_DIV_COMB_LNA1;
-					div_ant_conf.alt_lna_conf =
-						ATH_ANT_DIV_COMB_LNA2;
-				}
-			}
-			break;
-		default:
-			break;
-		}
+		ath_ant_try_scan(antcomb, &div_ant_conf, curr_alt_set,
+				 alt_rssi_avg, main_rssi_avg);
 	} else {
 		if (!antcomb->alt_good) {
 			antcomb->scan_not_start = false;
 			/* Set alt to another LNA */
 			if (curr_main_set == ATH_ANT_DIV_COMB_LNA2) {
 				div_ant_conf.main_lna_conf =
-						ATH_ANT_DIV_COMB_LNA2;
+					ATH_ANT_DIV_COMB_LNA2;
 				div_ant_conf.alt_lna_conf =
-						ATH_ANT_DIV_COMB_LNA1;
+					ATH_ANT_DIV_COMB_LNA1;
 			} else if (curr_main_set == ATH_ANT_DIV_COMB_LNA1) {
 				div_ant_conf.main_lna_conf =
-						ATH_ANT_DIV_COMB_LNA1;
+					ATH_ANT_DIV_COMB_LNA1;
 				div_ant_conf.alt_lna_conf =
-						ATH_ANT_DIV_COMB_LNA2;
+					ATH_ANT_DIV_COMB_LNA2;
 			}
 			goto div_comb_done;
 		}
-- 
1.8.3.4

