Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:51759 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759079Ab3HNDpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 23:45:08 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 02/14] ath9k: Fix phy error handling for DFS
Date: Wed, 14 Aug 2013 09:11:10 +0530
Message-Id: <1376451682-25862-2-git-send-email-sujith@msujith.org> (sfid-20130814_054513_718510_2CDC7F71)
In-Reply-To: <1376451682-25862-1-git-send-email-sujith@msujith.org>
References: <1376451682-25862-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since the DFS code appears to process the phy errors
ATH9K_PHYERR_RADAR and ATH9K_PHYERR_FALSE_RADAR_EXT,
check for the correct phyerr status in the main RX
tasklet routine.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0c23053..83b3fc5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1256,10 +1256,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
-		if (rs.rs_phyerr == ATH9K_PHYERR_RADAR)
+		if (rs.rs_status & ATH9K_RXERR_PHY) {
 			ath9k_dfs_process_phyerr(sc, hdr, &rs, rxs->mactime);
 
-		if (rs.rs_status & ATH9K_RXERR_PHY) {
 			if (ath_process_fft(sc, hdr, &rs, rxs->mactime)) {
 				RX_STAT_INC(rx_spectral);
 				goto requeue_drop_frag;
-- 
1.8.3.4

