Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:35030 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3HAG06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 02:26:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] ath9k: Add ALT check for cards with GROUP-3 config
Date: Thu,  1 Aug 2013 11:53:19 +0530
Message-Id: <1375338204-2021-3-git-send-email-sujith@msujith.org> (sfid-20130801_082706_663250_BE4145F4)
In-Reply-To: <1375338204-2021-1-git-send-email-sujith@msujith.org>
References: <1375338204-2021-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 50 +++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 130e983..ee25165 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -64,28 +64,45 @@ static inline bool ath_is_alt_ant_ratio_better(int alt_ratio, int maxdelta,
 		(alt_rssi_avg > main_rssi_avg + mindelta)) && (pkt_count > 50);
 }
 
-static inline bool ath_ant_div_comb_alt_check(u8 div_group, int alt_ratio,
-					      int curr_main_set, int curr_alt_set,
-					      int alt_rssi_avg, int main_rssi_avg)
+static inline bool ath_ant_div_comb_alt_check(struct ath_hw_antcomb_conf conf,
+					      int alt_ratio, int alt_rssi_avg,
+					      int main_rssi_avg)
 {
-	bool result = false;
-	switch (div_group) {
+	bool result, set1, set2;
+
+	result = set1 = set2 = false;
+
+	if (conf.main_lna_conf == ATH_ANT_DIV_COMB_LNA2 &&
+	    conf.alt_lna_conf == ATH_ANT_DIV_COMB_LNA1)
+		set1 = true;
+
+	if (conf.main_lna_conf == ATH_ANT_DIV_COMB_LNA1 &&
+	    conf.alt_lna_conf == ATH_ANT_DIV_COMB_LNA2)
+		set2 = true;
+
+	switch (conf.div_group) {
 	case 0:
 		if (alt_ratio > ATH_ANT_DIV_COMB_ALT_ANT_RATIO)
 			result = true;
 		break;
 	case 1:
 	case 2:
-		if ((((curr_main_set == ATH_ANT_DIV_COMB_LNA2) &&
-		      (curr_alt_set == ATH_ANT_DIV_COMB_LNA1) &&
-		      (alt_rssi_avg >= (main_rssi_avg - 5))) ||
-		     ((curr_main_set == ATH_ANT_DIV_COMB_LNA1) &&
-		      (curr_alt_set == ATH_ANT_DIV_COMB_LNA2) &&
-		      (alt_rssi_avg >= (main_rssi_avg - 2)))) &&
-		    (alt_rssi_avg >= 4))
+		if (alt_rssi_avg < 4)
+			break;
+
+		if ((set1 && (alt_rssi_avg >= (main_rssi_avg - 5))) ||
+		    (set2 && (alt_rssi_avg >= (main_rssi_avg - 2))))
 			result = true;
-		else
-			result = false;
+
+		break;
+	case 3:
+		if (alt_rssi_avg < 4)
+			break;
+
+		if ((set1 && (alt_rssi_avg >= (main_rssi_avg - 3))) ||
+		    (set2 && (alt_rssi_avg >= (main_rssi_avg + 3))))
+			result = true;
+
 		break;
 	}
 
@@ -671,9 +688,8 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	}
 
 	if (!antcomb->scan) {
-		if (ath_ant_div_comb_alt_check(div_ant_conf.div_group,
-					alt_ratio, curr_main_set, curr_alt_set,
-					alt_rssi_avg, main_rssi_avg)) {
+		if (ath_ant_div_comb_alt_check(div_ant_conf, alt_ratio,
+					       alt_rssi_avg, main_rssi_avg)) {
 			if (curr_alt_set == ATH_ANT_DIV_COMB_LNA2) {
 				/* Switch main and alt LNA */
 				div_ant_conf.main_lna_conf =
-- 
1.8.3.4

