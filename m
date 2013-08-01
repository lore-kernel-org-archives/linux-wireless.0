Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34449 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab3HAG1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 02:27:05 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] ath9k: Simplify checks in quick_scan
Date: Thu,  1 Aug 2013 11:53:22 +0530
Message-Id: <1375338204-2021-6-git-send-email-sujith@msujith.org> (sfid-20130801_082721_900980_77941ED6)
In-Reply-To: <1375338204-2021-1-git-send-email-sujith@msujith.org>
References: <1375338204-2021-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

There is a function to do a ratio comparison for ALT,
so make use of it.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index c52959b..82839b0 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -203,11 +203,11 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 			else
 				antcomb->first_ratio = false;
 		} else {
-			if ((((alt_ratio >= ATH_ANT_DIV_COMB_ALT_ANT_RATIO2) &&
-			      (alt_rssi_avg > main_rssi_avg +
-			       ATH_ANT_DIV_COMB_LNA1_DELTA_HI)) ||
-			     (alt_rssi_avg > main_rssi_avg)) &&
-			    (antcomb->total_pkt_count > 50))
+			if (ath_is_alt_ant_ratio_better(alt_ratio,
+						ATH_ANT_DIV_COMB_LNA1_DELTA_HI,
+						0,
+						main_rssi_avg, alt_rssi_avg,
+						antcomb->total_pkt_count))
 				antcomb->first_ratio = true;
 			else
 				antcomb->first_ratio = false;
@@ -258,11 +258,11 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 			else
 				antcomb->second_ratio = false;
 		} else {
-			if ((((alt_ratio >= ATH_ANT_DIV_COMB_ALT_ANT_RATIO2) &&
-			      (alt_rssi_avg > main_rssi_avg +
-			       ATH_ANT_DIV_COMB_LNA1_DELTA_HI)) ||
-			     (alt_rssi_avg > main_rssi_avg)) &&
-			    (antcomb->total_pkt_count > 50))
+			if (ath_is_alt_ant_ratio_better(alt_ratio,
+						ATH_ANT_DIV_COMB_LNA1_DELTA_HI,
+						0,
+						main_rssi_avg, alt_rssi_avg,
+						antcomb->total_pkt_count))
 				antcomb->second_ratio = true;
 			else
 				antcomb->second_ratio = false;
-- 
1.8.3.4

