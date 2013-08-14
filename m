Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:55877 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379Ab3HNDp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 23:45:27 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/14] ath9k: Handle corrupt descriptors properly
Date: Wed, 14 Aug 2013 09:11:20 +0530
Message-Id: <1376451682-25862-12-git-send-email-sujith@msujith.org> (sfid-20130814_060909_370195_0ABB0B3B)
In-Reply-To: <1376451682-25862-1-git-send-email-sujith@msujith.org>
References: <1376451682-25862-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The MIC/PHYERR/CRC error bits are valid only for
the last desc. for chained packets. Check this early
in the preprocess() routine and bail out.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 5b84ce4..30cb726 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1099,6 +1099,16 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	if (rx_stats->rs_more)
 		return 0;
 
+	/*
+	 * Return immediately if the RX descriptor has been marked
+	 * as corrupt based on the various error bits.
+	 *
+	 * This is different from the other corrupt descriptor
+	 * condition handled above.
+	 */
+	if (rx_stats->rs_status & ATH9K_RXERR_CORRUPT_DESC)
+		return -EINVAL;
+
 	hdr = (struct ieee80211_hdr *) (skb->data + ah->caps.rx_status_len);
 
 	ath9k_process_tsf(rx_stats, rx_status, tsf);
@@ -1335,8 +1345,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			sc->rx.frag = skb;
 			goto requeue;
 		}
-		if (rs.rs_status & ATH9K_RXERR_CORRUPT_DESC)
-			goto requeue_drop_frag;
 
 		if (sc->rx.frag) {
 			int space = skb->len - skb_tailroom(hdr_skb);
-- 
1.8.3.4

