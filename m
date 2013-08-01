Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:55764 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3HAG06 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 02:26:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/8] ath9k: Do a quick scan only when scan_not_start is true
Date: Thu,  1 Aug 2013 11:53:17 +0530
Message-Id: <1375338204-2021-1-git-send-email-sujith@msujith.org> (sfid-20130801_082702_001898_82EAF40B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Right now, it is being done for all cases.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 2785dc3..0ba5b86 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -798,14 +798,12 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 			}
 			goto div_comb_done;
 		}
+		ath_select_ant_div_from_quick_scan(antcomb, &div_ant_conf,
+						   main_rssi_avg, alt_rssi_avg,
+						   alt_ratio);
+		antcomb->quick_scan_cnt++;
 	}
 
-	ath_select_ant_div_from_quick_scan(antcomb, &div_ant_conf,
-					   main_rssi_avg, alt_rssi_avg,
-					   alt_ratio);
-
-	antcomb->quick_scan_cnt++;
-
 div_comb_done:
 	ath_ant_div_conf_fast_divbias(&div_ant_conf, antcomb, alt_ratio);
 	ath9k_hw_antdiv_comb_conf_set(sc->sc_ah, &div_ant_conf);
-- 
1.8.3.4

