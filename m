Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:54313 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759369Ab3HNDpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 23:45:25 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/14] ath9k: Move the RX poll check to preprocess()
Date: Wed, 14 Aug 2013 09:11:19 +0530
Message-Id: <1376451682-25862-11-git-send-email-sujith@msujith.org> (sfid-20130814_060909_487548_70E95C78)
In-Reply-To: <1376451682-25862-1-git-send-email-sujith@msujith.org>
References: <1376451682-25862-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 090c27e..5b84ce4 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1124,6 +1124,10 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		return -EINVAL;
 
 	rx_stats->is_mybeacon = ath9k_is_mybeacon(sc, hdr);
+	if (rx_stats->is_mybeacon) {
+		sc->hw_busy_count = 0;
+		ath_start_rx_poll(sc, 3);
+	}
 
 	if (ath9k_process_rate(common, hw, rx_stats, rx_status))
 		return -EINVAL;
@@ -1278,10 +1282,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (retval)
 			goto requeue_drop_frag;
 
-		if (rs.is_mybeacon) {
-			sc->hw_busy_count = 0;
-			ath_start_rx_poll(sc, 3);
-		}
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
 		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
-- 
1.8.3.4

