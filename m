Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41483 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab0ENNQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 09:16:26 -0400
Received: by pvh1 with SMTP id 1so517748pvh.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 06:16:26 -0700 (PDT)
From: tom.leiming@gmail.com
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/2] ath9k: fix dma sync in rx path
Date: Fri, 14 May 2010 21:16:09 +0800
Message-Id: <1273842969-3435-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1273842938-3401-1-git-send-email-tom.leiming@gmail.com>
References: <1273842938-3401-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

If buffer is to be accessed by cpu after dma transfer is over, but
between dma mapping and dma unmapping, we should use
dma_sync_single_for_cpu to sync the buffer between cpu with
device. And dma_sync_single_for_device is used to let
device gain the buffer again.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a3fe6e1..96f5d83 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -694,7 +694,7 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
 	bf = SKB_CB_ATHBUF(skb);
 	BUG_ON(!bf);
 
-	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+	dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
 				common->rx_bufsize, DMA_FROM_DEVICE);
 
 	ret = ath9k_hw_process_rxdesc_edma(ah, NULL, skb->data);
@@ -808,7 +808,7 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 	 * 1. accessing the frame
 	 * 2. requeueing the same buffer to h/w
 	 */
-	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+	dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
 			common->rx_bufsize,
 			DMA_FROM_DEVICE);
 
-- 
1.6.2.5

