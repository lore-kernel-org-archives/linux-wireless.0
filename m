Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56804 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab3DWGye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 02:54:34 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] ath9k: Use lockless variants for the RX fifo queue
Date: Tue, 23 Apr 2013 12:22:18 +0530
Message-Id: <1366699939-14076-3-git-send-email-sujith@msujith.org> (sfid-20130423_085439_708654_243FBD8C)
In-Reply-To: <1366699939-14076-1-git-send-email-sujith@msujith.org>
References: <1366699939-14076-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The RX fifo can be accessed from the common tasklet or it can
be reaped/cleaned when RX is stopped, which is done when doing
a reset or channel change - this happens in process context.

Since it is ensured that there are no pending tasklets when
stopping RX and cleaning the FIFO, there is no need to use
SKB queue functions which take internal locks.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c8265a7..9c0045e 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -124,7 +124,7 @@ static bool ath_rx_edma_buf_link(struct ath_softc *sc,
 
 	SKB_CB_ATHBUF(skb) = bf;
 	ath9k_hw_addrxbuf_edma(ah, bf->bf_buf_addr, qtype);
-	skb_queue_tail(&rx_edma->rx_fifo, skb);
+	__skb_queue_tail(&rx_edma->rx_fifo, skb);
 
 	return true;
 }
@@ -155,7 +155,7 @@ static void ath_rx_remove_buffer(struct ath_softc *sc,
 
 	rx_edma = &sc->rx.rx_edma[qtype];
 
-	while ((skb = skb_dequeue(&rx_edma->rx_fifo)) != NULL) {
+	while ((skb = __skb_dequeue(&rx_edma->rx_fifo)) != NULL) {
 		bf = SKB_CB_ATHBUF(skb);
 		BUG_ON(!bf);
 		list_add_tail(&bf->list, &sc->rx.rxbuf);
-- 
1.8.2.1

