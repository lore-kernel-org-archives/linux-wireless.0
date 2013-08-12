Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:43709 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3HLJpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 05:45:39 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 12/15] ath9k: Move the RX poll check to preprocess()
Date: Mon, 12 Aug 2013 15:11:39 +0530
Message-Id: <1376300502-2741-13-git-send-email-sujith@msujith.org> (sfid-20130812_120908_979974_112B931B)
In-Reply-To: <1376300502-2741-1-git-send-email-sujith@msujith.org>
References: <1376300502-2741-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 44f5a2b..7f327e9 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1127,6 +1127,11 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		return -EINVAL;
 
 	rx_stats->is_mybeacon = ath9k_is_mybeacon(sc, hdr);
+	if (rx_stats->is_mybeacon) {
+		sc->hw_busy_count = 0;
+		ath_start_rx_poll(sc, 3);
+	}
+
 	ath9k_process_rssi(common, hw, hdr, rx_stats);
 
 	rx_status->band = hw->conf.chandef.chan->band;
@@ -1277,10 +1282,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
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

