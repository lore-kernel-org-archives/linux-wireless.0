Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49530 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3HAG06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 02:26:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/8] ath9k: Use a subroutine to check for short scan
Date: Thu,  1 Aug 2013 11:53:18 +0530
Message-Id: <1375338204-2021-2-git-send-email-sujith@msujith.org> (sfid-20130801_082704_078845_3F2AAC40)
In-Reply-To: <1375338204-2021-1-git-send-email-sujith@msujith.org>
References: <1375338204-2021-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 37 ++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 0ba5b86..130e983 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -579,6 +579,27 @@ static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf,
 	}
 }
 
+static bool ath_ant_short_scan_check(struct ath_ant_comb *antcomb)
+{
+	int alt_ratio;
+
+	if (!antcomb->scan || !antcomb->alt_good)
+		return false;
+
+	if (time_after(jiffies, antcomb->scan_start_time +
+		       msecs_to_jiffies(ATH_ANT_DIV_COMB_SHORT_SCAN_INTR)))
+		return true;
+
+	if (antcomb->total_pkt_count == ATH_ANT_DIV_COMB_SHORT_SCAN_PKTCOUNT) {
+		alt_ratio = ((antcomb->alt_recv_cnt * 100) /
+			     antcomb->total_pkt_count);
+		if (alt_ratio < ATH_ANT_DIV_COMB_ALT_ANT_RATIO)
+			return true;
+	}
+
+	return false;
+}
+
 void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 {
 	struct ath_hw_antcomb_conf div_ant_conf;
@@ -613,22 +634,10 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	}
 
 	/* Short scan check */
-	if (antcomb->scan && antcomb->alt_good) {
-		if (time_after(jiffies, antcomb->scan_start_time +
-		    msecs_to_jiffies(ATH_ANT_DIV_COMB_SHORT_SCAN_INTR)))
-			short_scan = true;
-		else
-			if (antcomb->total_pkt_count ==
-			    ATH_ANT_DIV_COMB_SHORT_SCAN_PKTCOUNT) {
-				alt_ratio = ((antcomb->alt_recv_cnt * 100) /
-					    antcomb->total_pkt_count);
-				if (alt_ratio < ATH_ANT_DIV_COMB_ALT_ANT_RATIO)
-					short_scan = true;
-			}
-	}
+	short_scan = ath_ant_short_scan_check(antcomb);
 
 	if (((antcomb->total_pkt_count < ATH_ANT_DIV_COMB_MAX_PKTCOUNT) ||
-	    rs->rs_moreaggr) && !short_scan)
+	     rs->rs_moreaggr) && !short_scan)
 		return;
 
 	if (antcomb->total_pkt_count) {
-- 
1.8.3.4

