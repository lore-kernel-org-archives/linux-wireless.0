Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44422 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3HDIzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Aug 2013 04:55:36 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/11] ath9k: Fix antenna diversity for CUS198
Date: Sun,  4 Aug 2013 14:21:54 +0530
Message-Id: <1375606322-9983-3-git-send-email-sujith@msujith.org> (sfid-20130804_105558_359934_5ADC4114)
In-Reply-To: <1375606322-9983-1-git-send-email-sujith@msujith.org>
References: <1375606322-9983-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

CUS198/CUS230 need a few tweaks in the antenna diversity
algorithm to accomodate RSSI variation. Add a couple
of knobs to control low RSSI threshold and fast antenna
diversity bias values.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 73 ++++++++++++++++++++------------
 drivers/net/wireless/ath/ath9k/ath9k.h   | 10 +++++
 drivers/net/wireless/ath/ath9k/init.c    |  2 +
 3 files changed, 59 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 4cd2bce..8de314c 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -68,16 +68,27 @@
  * enable_ant_fast_div      ==> bit 7
  */
 
-static inline bool ath_is_alt_ant_ratio_better(int alt_ratio, int maxdelta,
+static inline bool ath_is_alt_ant_ratio_better(struct ath_ant_comb *antcomb,
+					       int alt_ratio, int maxdelta,
 					       int mindelta, int main_rssi_avg,
 					       int alt_rssi_avg, int pkt_count)
 {
-	return (((alt_ratio >= ATH_ANT_DIV_COMB_ALT_ANT_RATIO2) &&
-		 (alt_rssi_avg > main_rssi_avg + maxdelta)) ||
-		(alt_rssi_avg > main_rssi_avg + mindelta)) && (pkt_count > 50);
+	if (pkt_count <= 50)
+		return false;
+
+	if (alt_rssi_avg > main_rssi_avg + mindelta)
+		return true;
+
+	if (alt_ratio >= antcomb->ant_ratio2 &&
+	    alt_rssi_avg >= antcomb->low_rssi_thresh &&
+	    (alt_rssi_avg > main_rssi_avg + maxdelta))
+		return true;
+
+	return false;
 }
 
 static inline bool ath_ant_div_comb_alt_check(struct ath_hw_antcomb_conf *conf,
+					      struct ath_ant_comb *antcomb,
 					      int alt_ratio, int alt_rssi_avg,
 					      int main_rssi_avg)
 {
@@ -100,20 +111,22 @@ static inline bool ath_ant_div_comb_alt_check(struct ath_hw_antcomb_conf *conf,
 		break;
 	case 1:
 	case 2:
-		if (alt_rssi_avg < 4)
+		if (alt_rssi_avg < 4 || alt_rssi_avg < antcomb->low_rssi_thresh)
 			break;
 
 		if ((set1 && (alt_rssi_avg >= (main_rssi_avg - 5))) ||
-		    (set2 && (alt_rssi_avg >= (main_rssi_avg - 2))))
+		    (set2 && (alt_rssi_avg >= (main_rssi_avg - 2))) ||
+		    (alt_ratio > antcomb->ant_ratio))
 			result = true;
 
 		break;
 	case 3:
-		if (alt_rssi_avg < 4)
+		if (alt_rssi_avg < 4 || alt_rssi_avg < antcomb->low_rssi_thresh)
 			break;
 
 		if ((set1 && (alt_rssi_avg >= (main_rssi_avg - 3))) ||
-		    (set2 && (alt_rssi_avg >= (main_rssi_avg + 3))))
+		    (set2 && (alt_rssi_avg >= (main_rssi_avg + 3))) ||
+		    (alt_ratio > antcomb->ant_ratio))
 			result = true;
 
 		break;
@@ -266,7 +279,7 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 
 		if (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA1) {
 			/* main is LNA1 */
-			if (ath_is_alt_ant_ratio_better(alt_ratio,
+			if (ath_is_alt_ant_ratio_better(antcomb, alt_ratio,
 						ATH_ANT_DIV_COMB_LNA1_DELTA_HI,
 						ATH_ANT_DIV_COMB_LNA1_DELTA_LOW,
 						main_rssi_avg, alt_rssi_avg,
@@ -275,7 +288,7 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 			else
 				antcomb->first_ratio = false;
 		} else if (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA2) {
-			if (ath_is_alt_ant_ratio_better(alt_ratio,
+			if (ath_is_alt_ant_ratio_better(antcomb, alt_ratio,
 						ATH_ANT_DIV_COMB_LNA1_DELTA_MID,
 						ATH_ANT_DIV_COMB_LNA1_DELTA_LOW,
 						main_rssi_avg, alt_rssi_avg,
@@ -284,7 +297,7 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 			else
 				antcomb->first_ratio = false;
 		} else {
-			if (ath_is_alt_ant_ratio_better(alt_ratio,
+			if (ath_is_alt_ant_ratio_better(antcomb, alt_ratio,
 						ATH_ANT_DIV_COMB_LNA1_DELTA_HI,
 						0,
 						main_rssi_avg, alt_rssi_avg,
@@ -325,7 +338,7 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 			div_ant_conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA1;
 
 		if (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA1) {
-			if (ath_is_alt_ant_ratio_better(alt_ratio,
+			if (ath_is_alt_ant_ratio_better(antcomb, alt_ratio,
 						ATH_ANT_DIV_COMB_LNA1_DELTA_HI,
 						ATH_ANT_DIV_COMB_LNA1_DELTA_LOW,
 						main_rssi_avg, alt_rssi_avg,
@@ -334,7 +347,7 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 			else
 				antcomb->second_ratio = false;
 		} else if (antcomb->main_conf == ATH_ANT_DIV_COMB_LNA2) {
-			if (ath_is_alt_ant_ratio_better(alt_ratio,
+			if (ath_is_alt_ant_ratio_better(antcomb, alt_ratio,
 						ATH_ANT_DIV_COMB_LNA1_DELTA_MID,
 						ATH_ANT_DIV_COMB_LNA1_DELTA_LOW,
 						main_rssi_avg, alt_rssi_avg,
@@ -343,7 +356,7 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 			else
 				antcomb->second_ratio = false;
 		} else {
-			if (ath_is_alt_ant_ratio_better(alt_ratio,
+			if (ath_is_alt_ant_ratio_better(antcomb, alt_ratio,
 						ATH_ANT_DIV_COMB_LNA1_DELTA_HI,
 						0,
 						main_rssi_avg, alt_rssi_avg,
@@ -484,8 +497,7 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 			ant_conf->fast_div_bias = 0x1;
 			break;
 		case 0x10: /* LNA2 A-B */
-			if (!(antcomb->scan) &&
-				(alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO))
+			if (!antcomb->scan && (alt_ratio > antcomb->ant_ratio))
 				ant_conf->fast_div_bias = 0x1;
 			else
 				ant_conf->fast_div_bias = 0x2;
@@ -494,15 +506,13 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 			ant_conf->fast_div_bias = 0x1;
 			break;
 		case 0x13: /* LNA2 A+B */
-			if (!(antcomb->scan) &&
-				(alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO))
+			if (!antcomb->scan && (alt_ratio > antcomb->ant_ratio))
 				ant_conf->fast_div_bias = 0x1;
 			else
 				ant_conf->fast_div_bias = 0x2;
 			break;
 		case 0x20: /* LNA1 A-B */
-			if (!(antcomb->scan) &&
-				(alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO))
+			if (!antcomb->scan && (alt_ratio > antcomb->ant_ratio))
 				ant_conf->fast_div_bias = 0x1;
 			else
 				ant_conf->fast_div_bias = 0x2;
@@ -511,8 +521,7 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 			ant_conf->fast_div_bias = 0x1;
 			break;
 		case 0x23: /* LNA1 A+B */
-			if (!(antcomb->scan) &&
-				(alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO))
+			if (!antcomb->scan && (alt_ratio > antcomb->ant_ratio))
 				ant_conf->fast_div_bias = 0x1;
 			else
 				ant_conf->fast_div_bias = 0x2;
@@ -529,6 +538,9 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 		default:
 			break;
 		}
+
+		if (antcomb->fast_div_bias)
+			ant_conf->fast_div_bias = antcomb->fast_div_bias;
 	} else if (ant_conf->div_group == 3) {
 		switch ((ant_conf->main_lna_conf << 4) |
 			ant_conf->alt_lna_conf) {
@@ -668,13 +680,14 @@ static void ath_ant_try_scan(struct ath_ant_comb *antcomb,
 }
 
 static bool ath_ant_try_switch(struct ath_hw_antcomb_conf *div_ant_conf,
+			       struct ath_ant_comb *antcomb,
 			       int alt_ratio, int alt_rssi_avg,
 			       int main_rssi_avg, int curr_main_set,
 			       int curr_alt_set)
 {
 	bool ret = false;
 
-	if (ath_ant_div_comb_alt_check(div_ant_conf, alt_ratio,
+	if (ath_ant_div_comb_alt_check(div_ant_conf, antcomb, alt_ratio,
 				       alt_rssi_avg, main_rssi_avg)) {
 		if (curr_alt_set == ATH_ANT_DIV_COMB_LNA2) {
 			/*
@@ -718,7 +731,7 @@ static bool ath_ant_short_scan_check(struct ath_ant_comb *antcomb)
 	if (antcomb->total_pkt_count == ATH_ANT_DIV_COMB_SHORT_SCAN_PKTCOUNT) {
 		alt_ratio = ((antcomb->alt_recv_cnt * 100) /
 			     antcomb->total_pkt_count);
-		if (alt_ratio < ATH_ANT_DIV_COMB_ALT_ANT_RATIO)
+		if (alt_ratio < antcomb->ant_ratio)
 			return true;
 	}
 
@@ -741,6 +754,14 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	main_ant_conf = (rs->rs_rssi_ctl2 >> ATH_ANT_RX_MAIN_SHIFT) &
 			 ATH_ANT_RX_MASK;
 
+	if (alt_rssi >= antcomb->low_rssi_thresh) {
+		antcomb->ant_ratio = ATH_ANT_DIV_COMB_ALT_ANT_RATIO;
+		antcomb->ant_ratio2 = ATH_ANT_DIV_COMB_ALT_ANT_RATIO2;
+	} else {
+		antcomb->ant_ratio = ATH_ANT_DIV_COMB_ALT_ANT_RATIO_LOW_RSSI;
+		antcomb->ant_ratio2 = ATH_ANT_DIV_COMB_ALT_ANT_RATIO2_LOW_RSSI;
+	}
+
 	/* Record packet only when both main_rssi and  alt_rssi is positive */
 	if (main_rssi > 0 && alt_rssi > 0) {
 		antcomb->total_pkt_count++;
@@ -783,7 +804,7 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	antcomb->count++;
 
 	if (antcomb->count == ATH_ANT_DIV_COMB_MAX_COUNT) {
-		if (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO) {
+		if (alt_ratio > antcomb->ant_ratio) {
 			ath_lnaconf_alt_good_scan(antcomb, div_ant_conf,
 						  main_rssi_avg);
 			antcomb->alt_good = true;
@@ -797,7 +818,7 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	}
 
 	if (!antcomb->scan) {
-		ret = ath_ant_try_switch(&div_ant_conf, alt_ratio,
+		ret = ath_ant_try_switch(&div_ant_conf, antcomb, alt_ratio,
 					 alt_rssi_avg, main_rssi_avg,
 					 curr_main_set, curr_alt_set);
 		if (ret)
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ed8f8ef..74009f1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -585,6 +585,8 @@ static inline void ath_fill_led_pin(struct ath_softc *sc)
 #define ATH_ANT_DIV_COMB_MAX_COUNT 100
 #define ATH_ANT_DIV_COMB_ALT_ANT_RATIO 30
 #define ATH_ANT_DIV_COMB_ALT_ANT_RATIO2 20
+#define ATH_ANT_DIV_COMB_ALT_ANT_RATIO_LOW_RSSI 50
+#define ATH_ANT_DIV_COMB_ALT_ANT_RATIO2_LOW_RSSI 50
 
 #define ATH_ANT_DIV_COMB_LNA1_LNA2_SWITCH_DELTA -1
 #define ATH_ANT_DIV_COMB_LNA1_DELTA_HI -4
@@ -607,6 +609,8 @@ struct ath_ant_comb {
 	int rssi_first;
 	int rssi_second;
 	int rssi_third;
+	int ant_ratio;
+	int ant_ratio2;
 	bool alt_good;
 	int quick_scan_cnt;
 	enum ath9k_ant_div_comb_lna_conf main_conf;
@@ -615,6 +619,12 @@ struct ath_ant_comb {
 	bool first_ratio;
 	bool second_ratio;
 	unsigned long scan_start_time;
+
+	/*
+	 * Card-specific config values.
+	 */
+	int low_rssi_thresh;
+	int fast_div_bias;
 };
 
 void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 16f8b20..7ded9d6 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -525,6 +525,8 @@ static void ath9k_init_platform(struct ath_softc *sc)
 			       ATH9K_PCI_CUS230)) {
 		ah->config.xlna_gpio = 9;
 		ah->config.xatten_margin_cfg = true;
+		sc->ant_comb.low_rssi_thresh = 20;
+		sc->ant_comb.fast_div_bias = 3;
 
 		ath_info(common, "Set parameters for %s\n",
 			 (sc->driver_data & ATH9K_PCI_CUS198) ?
-- 
1.8.3.4

