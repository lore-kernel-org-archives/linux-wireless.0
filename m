Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44884 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3HAG1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 02:27:07 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] ath9k: Use a subroutine to calculate ALT ratio
Date: Thu,  1 Aug 2013 11:53:23 +0530
Message-Id: <1375338204-2021-7-git-send-email-sujith@msujith.org> (sfid-20130801_082721_217940_F5787E1C)
In-Reply-To: <1375338204-2021-1-git-send-email-sujith@msujith.org>
References: <1375338204-2021-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 173 ++++++++++++++-----------------
 1 file changed, 79 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 82839b0..42f3b87 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -164,6 +164,74 @@ static void ath_lnaconf_alt_good_scan(struct ath_ant_comb *antcomb,
 	}
 }
 
+static void ath_ant_set_alt_ratio(struct ath_ant_comb *antcomb,
+				  struct ath_hw_antcomb_conf *conf)
+{
+	/* set alt to the conf with maximun ratio */
+	if (antcomb->first_ratio && antcomb->second_ratio) {
+		if (antcomb->rssi_second > antcomb->rssi_third) {
+			/* first alt*/
+			if ((antcomb->first_quick_scan_conf == ATH_ANT_DIV_COMB_LNA1) ||
+			    (antcomb->first_quick_scan_conf == ATH_ANT_DIV_COMB_LNA2))
+				/* Set alt LNA1 or LNA2*/
+				if (conf->main_lna_conf == ATH_ANT_DIV_COMB_LNA2)
+					conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+				else
+					conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+			else
+				/* Set alt to A+B or A-B */
+				conf->alt_lna_conf =
+					antcomb->first_quick_scan_conf;
+		} else if ((antcomb->second_quick_scan_conf == ATH_ANT_DIV_COMB_LNA1) ||
+			   (antcomb->second_quick_scan_conf == ATH_ANT_DIV_COMB_LNA2)) {
+			/* Set alt LNA1 or LNA2 */
+			if (conf->main_lna_conf == ATH_ANT_DIV_COMB_LNA2)
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+			else
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+		} else {
+			/* Set alt to A+B or A-B */
+			conf->alt_lna_conf = antcomb->second_quick_scan_conf;
+		}
+	} else if (antcomb->first_ratio) {
+		/* first alt */
+		if ((antcomb->first_quick_scan_conf == ATH_ANT_DIV_COMB_LNA1) ||
+		    (antcomb->first_quick_scan_conf == ATH_ANT_DIV_COMB_LNA2))
+			/* Set alt LNA1 or LNA2 */
+			if (conf->main_lna_conf == ATH_ANT_DIV_COMB_LNA2)
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+			else
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+		else
+			/* Set alt to A+B or A-B */
+			conf->alt_lna_conf = antcomb->first_quick_scan_conf;
+	} else if (antcomb->second_ratio) {
+		/* second alt */
+		if ((antcomb->second_quick_scan_conf == ATH_ANT_DIV_COMB_LNA1) ||
+		    (antcomb->second_quick_scan_conf == ATH_ANT_DIV_COMB_LNA2))
+			/* Set alt LNA1 or LNA2 */
+			if (conf->main_lna_conf == ATH_ANT_DIV_COMB_LNA2)
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+			else
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+		else
+			/* Set alt to A+B or A-B */
+			conf->alt_lna_conf = antcomb->second_quick_scan_conf;
+	} else {
+		/* main is largest */
+		if ((antcomb->main_conf == ATH_ANT_DIV_COMB_LNA1) ||
+		    (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA2))
+			/* Set alt LNA1 or LNA2 */
+			if (conf->main_lna_conf == ATH_ANT_DIV_COMB_LNA2)
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+			else
+				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+		else
+			/* Set alt to A+B or A-B */
+			conf->alt_lna_conf = antcomb->main_conf;
+	}
+}
+
 static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 				       struct ath_hw_antcomb_conf *div_ant_conf,
 				       int main_rssi_avg, int alt_rssi_avg,
@@ -220,17 +288,21 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 		antcomb->rssi_first = main_rssi_avg;
 		antcomb->rssi_third = alt_rssi_avg;
 
-		if (antcomb->second_quick_scan_conf == ATH_ANT_DIV_COMB_LNA1)
+		switch(antcomb->second_quick_scan_conf) {
+		case ATH_ANT_DIV_COMB_LNA1:
 			antcomb->rssi_lna1 = alt_rssi_avg;
-		else if (antcomb->second_quick_scan_conf ==
-			 ATH_ANT_DIV_COMB_LNA2)
+			break;
+		case ATH_ANT_DIV_COMB_LNA2:
 			antcomb->rssi_lna2 = alt_rssi_avg;
-		else if (antcomb->second_quick_scan_conf ==
-			 ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2) {
+			break;
+		case ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2:
 			if (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA2)
 				antcomb->rssi_lna2 = main_rssi_avg;
 			else if (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA1)
 				antcomb->rssi_lna1 = main_rssi_avg;
+			break;
+		default:
+			break;
 		}
 
 		if (antcomb->rssi_lna2 > antcomb->rssi_lna1 +
@@ -268,95 +340,8 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 				antcomb->second_ratio = false;
 		}
 
-		/* set alt to the conf with maximun ratio */
-		if (antcomb->first_ratio && antcomb->second_ratio) {
-			if (antcomb->rssi_second > antcomb->rssi_third) {
-				/* first alt*/
-				if ((antcomb->first_quick_scan_conf ==
-				    ATH_ANT_DIV_COMB_LNA1) ||
-				    (antcomb->first_quick_scan_conf ==
-				    ATH_ANT_DIV_COMB_LNA2))
-					/* Set alt LNA1 or LNA2*/
-					if (div_ant_conf->main_lna_conf ==
-					    ATH_ANT_DIV_COMB_LNA2)
-						div_ant_conf->alt_lna_conf =
-							ATH_ANT_DIV_COMB_LNA1;
-					else
-						div_ant_conf->alt_lna_conf =
-							ATH_ANT_DIV_COMB_LNA2;
-				else
-					/* Set alt to A+B or A-B */
-					div_ant_conf->alt_lna_conf =
-						antcomb->first_quick_scan_conf;
-			} else if ((antcomb->second_quick_scan_conf ==
-				   ATH_ANT_DIV_COMB_LNA1) ||
-				   (antcomb->second_quick_scan_conf ==
-				   ATH_ANT_DIV_COMB_LNA2)) {
-				/* Set alt LNA1 or LNA2 */
-				if (div_ant_conf->main_lna_conf ==
-				    ATH_ANT_DIV_COMB_LNA2)
-					div_ant_conf->alt_lna_conf =
-						ATH_ANT_DIV_COMB_LNA1;
-				else
-					div_ant_conf->alt_lna_conf =
-						ATH_ANT_DIV_COMB_LNA2;
-			} else {
-				/* Set alt to A+B or A-B */
-				div_ant_conf->alt_lna_conf =
-					antcomb->second_quick_scan_conf;
-			}
-		} else if (antcomb->first_ratio) {
-			/* first alt */
-			if ((antcomb->first_quick_scan_conf ==
-			    ATH_ANT_DIV_COMB_LNA1) ||
-			    (antcomb->first_quick_scan_conf ==
-			    ATH_ANT_DIV_COMB_LNA2))
-					/* Set alt LNA1 or LNA2 */
-				if (div_ant_conf->main_lna_conf ==
-				    ATH_ANT_DIV_COMB_LNA2)
-					div_ant_conf->alt_lna_conf =
-							ATH_ANT_DIV_COMB_LNA1;
-				else
-					div_ant_conf->alt_lna_conf =
-							ATH_ANT_DIV_COMB_LNA2;
-			else
-				/* Set alt to A+B or A-B */
-				div_ant_conf->alt_lna_conf =
-						antcomb->first_quick_scan_conf;
-		} else if (antcomb->second_ratio) {
-				/* second alt */
-			if ((antcomb->second_quick_scan_conf ==
-			    ATH_ANT_DIV_COMB_LNA1) ||
-			    (antcomb->second_quick_scan_conf ==
-			    ATH_ANT_DIV_COMB_LNA2))
-				/* Set alt LNA1 or LNA2 */
-				if (div_ant_conf->main_lna_conf ==
-				    ATH_ANT_DIV_COMB_LNA2)
-					div_ant_conf->alt_lna_conf =
-						ATH_ANT_DIV_COMB_LNA1;
-				else
-					div_ant_conf->alt_lna_conf =
-						ATH_ANT_DIV_COMB_LNA2;
-			else
-				/* Set alt to A+B or A-B */
-				div_ant_conf->alt_lna_conf =
-						antcomb->second_quick_scan_conf;
-		} else {
-			/* main is largest */
-			if ((antcomb->main_conf == ATH_ANT_DIV_COMB_LNA1) ||
-			    (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA2))
-				/* Set alt LNA1 or LNA2 */
-				if (div_ant_conf->main_lna_conf ==
-				    ATH_ANT_DIV_COMB_LNA2)
-					div_ant_conf->alt_lna_conf =
-							ATH_ANT_DIV_COMB_LNA1;
-				else
-					div_ant_conf->alt_lna_conf =
-							ATH_ANT_DIV_COMB_LNA2;
-			else
-				/* Set alt to A+B or A-B */
-				div_ant_conf->alt_lna_conf = antcomb->main_conf;
-		}
+		ath_ant_set_alt_ratio(antcomb, div_ant_conf);
+
 		break;
 	default:
 		break;
-- 
1.8.3.4

