Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46191 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758973Ab3HNPtk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 11:49:40 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] ath9k: Use lockless variant to initialize RX fifo
Date: Wed, 14 Aug 2013 21:15:57 +0530
Message-Id: <1376495157-18983-4-git-send-email-sujith@msujith.org> (sfid-20130814_174947_294162_F1504000)
In-Reply-To: <1376495157-18983-1-git-send-email-sujith@msujith.org>
References: <1376495157-18983-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since the rx_fifo queue is accessed only using the various
lockless SKB queue routines, there is no need to initialize
the lock and __skb_queue_head_init() can be used.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6161d14..653f7fc 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -190,7 +190,7 @@ static void ath_rx_edma_cleanup(struct ath_softc *sc)
 
 static void ath_rx_edma_init_queue(struct ath_rx_edma *rx_edma, int size)
 {
-	skb_queue_head_init(&rx_edma->rx_fifo);
+	__skb_queue_head_init(&rx_edma->rx_fifo);
 	rx_edma->rx_fifo_hwsize = size;
 }
 
-- 
1.8.3.4

