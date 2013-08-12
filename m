Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:43477 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab3HLJpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 05:45:41 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 13/15] ath9k: Handle corrupt descriptors properly
Date: Mon, 12 Aug 2013 15:11:40 +0530
Message-Id: <1376300502-2741-14-git-send-email-sujith@msujith.org> (sfid-20130812_120908_798939_4AACE883)
In-Reply-To: <1376300502-2741-1-git-send-email-sujith@msujith.org>
References: <1376300502-2741-1-git-send-email-sujith@msujith.org>
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
index 7f327e9..0965bf6 100644
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

