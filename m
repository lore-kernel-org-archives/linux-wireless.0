Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56956 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3HAG1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 02:27:01 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/8] ath9k: Use a subroutine to try LNA switch
Date: Thu,  1 Aug 2013 11:53:20 +0530
Message-Id: <1375338204-2021-4-git-send-email-sujith@msujith.org> (sfid-20130801_082734_438769_3B4079A0)
In-Reply-To: <1375338204-2021-1-git-send-email-sujith@msujith.org>
References: <1375338204-2021-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 92 ++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index ee25165..8675c3f 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -64,7 +64,7 @@ static inline bool ath_is_alt_ant_ratio_better(int alt_ratio, int maxdelta,
 		(alt_rssi_avg > main_rssi_avg + mindelta)) && (pkt_count > 50);
 }
 
-static inline bool ath_ant_div_comb_alt_check(struct ath_hw_antcomb_conf conf,
+static inline bool ath_ant_div_comb_alt_check(struct ath_hw_antcomb_conf *conf,
 					      int alt_ratio, int alt_rssi_avg,
 					      int main_rssi_avg)
 {
@@ -72,15 +72,15 @@ static inline bool ath_ant_div_comb_alt_check(struct ath_hw_antcomb_conf conf,
 
 	result = set1 = set2 = false;
 
-	if (conf.main_lna_conf == ATH_ANT_DIV_COMB_LNA2 &&
-	    conf.alt_lna_conf == ATH_ANT_DIV_COMB_LNA1)
+	if (conf->main_lna_conf == ATH_ANT_DIV_COMB_LNA2 &&
+	    conf->alt_lna_conf == ATH_ANT_DIV_COMB_LNA1)
 		set1 = true;
 
-	if (conf.main_lna_conf == ATH_ANT_DIV_COMB_LNA1 &&
-	    conf.alt_lna_conf == ATH_ANT_DIV_COMB_LNA2)
+	if (conf->main_lna_conf == ATH_ANT_DIV_COMB_LNA1 &&
+	    conf->alt_lna_conf == ATH_ANT_DIV_COMB_LNA2)
 		set2 = true;
 
-	switch (conf.div_group) {
+	switch (conf->div_group) {
 	case 0:
 		if (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)
 			result = true;
@@ -596,6 +596,43 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 	}
 }
 
+static bool ath_ant_try_switch(struct ath_hw_antcomb_conf *div_ant_conf,
+			       int alt_ratio, int alt_rssi_avg,
+			       int main_rssi_avg, int curr_main_set,
+			       int curr_alt_set)
+{
+	bool ret = false;
+
+	if (ath_ant_div_comb_alt_check(div_ant_conf, alt_ratio,
+				       alt_rssi_avg, main_rssi_avg)) {
+		if (curr_alt_set == ATH_ANT_DIV_COMB_LNA2) {
+			/*
+			 * Switch main and alt LNA.
+			 */
+			div_ant_conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+			div_ant_conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+		} else if (curr_alt_set == ATH_ANT_DIV_COMB_LNA1) {
+			div_ant_conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+			div_ant_conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+		}
+
+		ret = true;
+	} else if ((curr_alt_set != ATH_ANT_DIV_COMB_LNA1) &&
+		   (curr_alt_set != ATH_ANT_DIV_COMB_LNA2)) {
+		/*
+		  Set alt to another LNA.
+		*/
+		if (curr_main_set == ATH_ANT_DIV_COMB_LNA2)
+			div_ant_conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1;
+		else if (curr_main_set == ATH_ANT_DIV_COMB_LNA1)
+			div_ant_conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA2;
+
+		ret = true;
+	}
+
+	return ret;
+}
+
 static bool ath_ant_short_scan_check(struct ath_ant_comb *antcomb)
 {
 	int alt_ratio;
@@ -626,7 +663,7 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	int main_rssi = rs->rs_rssi_ctl0;
 	int alt_rssi = rs->rs_rssi_ctl1;
 	int rx_ant_conf,  main_ant_conf;
-	bool short_scan = false;
+	bool short_scan = false, ret;
 
 	rx_ant_conf = (rs->rs_rssi_ctl2 >> ATH_ANT_RX_CURRENT_SHIFT) &
 		       ATH_ANT_RX_MASK;
@@ -666,11 +703,9 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 				 antcomb->total_pkt_count);
 	}
 
-
 	ath9k_hw_antdiv_comb_conf_get(sc->sc_ah, &div_ant_conf);
 	curr_alt_set = div_ant_conf.alt_lna_conf;
 	curr_main_set = div_ant_conf.main_lna_conf;
-
 	antcomb->count++;
 
 	if (antcomb->count == ATH_ANT_DIV_COMB_MAX_COUNT) {
@@ -688,40 +723,17 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	}
 
 	if (!antcomb->scan) {
-		if (ath_ant_div_comb_alt_check(div_ant_conf, alt_ratio,
-					       alt_rssi_avg, main_rssi_avg)) {
-			if (curr_alt_set == ATH_ANT_DIV_COMB_LNA2) {
-				/* Switch main and alt LNA */
-				div_ant_conf.main_lna_conf =
-						ATH_ANT_DIV_COMB_LNA2;
-				div_ant_conf.alt_lna_conf  =
-						ATH_ANT_DIV_COMB_LNA1;
-			} else if (curr_alt_set == ATH_ANT_DIV_COMB_LNA1) {
-				div_ant_conf.main_lna_conf =
-						ATH_ANT_DIV_COMB_LNA1;
-				div_ant_conf.alt_lna_conf  =
-						ATH_ANT_DIV_COMB_LNA2;
-			}
-
-			goto div_comb_done;
-		} else if ((curr_alt_set != ATH_ANT_DIV_COMB_LNA1) &&
-			   (curr_alt_set != ATH_ANT_DIV_COMB_LNA2)) {
-			/* Set alt to another LNA */
-			if (curr_main_set == ATH_ANT_DIV_COMB_LNA2)
-				div_ant_conf.alt_lna_conf =
-						ATH_ANT_DIV_COMB_LNA1;
-			else if (curr_main_set == ATH_ANT_DIV_COMB_LNA1)
-				div_ant_conf.alt_lna_conf =
-						ATH_ANT_DIV_COMB_LNA2;
-
-			goto div_comb_done;
-		}
-
-		if ((alt_rssi_avg < (main_rssi_avg +
-				     div_ant_conf.lna1_lna2_delta)))
+		ret = ath_ant_try_switch(&div_ant_conf, alt_ratio,
+					 alt_rssi_avg, main_rssi_avg,
+					 curr_main_set, curr_alt_set);
+		if (ret)
 			goto div_comb_done;
 	}
 
+	if (!antcomb->scan &&
+	    (alt_rssi_avg < (main_rssi_avg + div_ant_conf.lna1_lna2_delta)))
+		goto div_comb_done;
+
 	if (!antcomb->scan_not_start) {
 		switch (curr_alt_set) {
 		case ATH_ANT_DIV_COMB_LNA2:
-- 
1.8.3.4

