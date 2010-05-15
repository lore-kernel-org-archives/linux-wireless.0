Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46548 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab0EOK0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 May 2010 06:26:05 -0400
Received: by pvh1 with SMTP id 1so965687pvh.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 May 2010 03:26:03 -0700 (PDT)
Date: Sat, 15 May 2010 18:25:40 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k: fix dma sync in rx path
Message-ID: <20100515182540.6f4e140c@tom-lei>
In-Reply-To: <AANLkTikFtb1j7x9-d-SpV8AAODQAxNAobIZePCQNLbip@mail.gmail.com>
References: <1273842938-3401-1-git-send-email-tom.leiming@gmail.com>
 <1273842969-3435-1-git-send-email-tom.leiming@gmail.com>
 <4BED5E08.3050000@openwrt.org>
 <AANLkTikVkBdTopPJlU2lGkafLIkiiviUHe8J-lTy67y9@mail.gmail.com>
 <4BED7809.3090204@openwrt.org>
 <AANLkTikV8cAc4Njpa1cXq1BHRExkwbaKwjlyyH52rgqO@mail.gmail.com>
 <4BEE689A.9060102@openwrt.org>
 <AANLkTikFtb1j7x9-d-SpV8AAODQAxNAobIZePCQNLbip@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From edd368e7436e7a80c5a43e7ad40cff1f3fa20806 Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Fri, 14 May 2010 17:35:51 +0800
Subject: [PATCH 2/2] ath9k: fix dma sync in rx path(v2)

If buffer is to be accessed by cpu after dma is over, but
between dma mapping and dma unmapping, we should use
dma_sync_single_for_cpu to sync the buffer between cpu with
device. And dma_sync_single_for_device is used to let
device gain the buffer again.

v2: Felix pointed out dma_sync_single_for_device is needed to return
buffer to device if an unsuccessful status bit check is found.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a3fe6e1..f4453f0 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -694,12 +694,16 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
 	bf = SKB_CB_ATHBUF(skb);
 	BUG_ON(!bf);
 
-	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+	dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
 				common->rx_bufsize, DMA_FROM_DEVICE);
 
 	ret = ath9k_hw_process_rxdesc_edma(ah, NULL, skb->data);
-	if (ret == -EINPROGRESS)
+	if (ret == -EINPROGRESS) {
+		/*let device gain the buffer again*/
+		dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+				common->rx_bufsize, DMA_FROM_DEVICE);
 		return false;
+	}
 
 	__skb_unlink(skb, &rx_edma->rx_fifo);
 	if (ret == -EINVAL) {
@@ -808,7 +812,7 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 	 * 1. accessing the frame
 	 * 2. requeueing the same buffer to h/w
 	 */
-	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+	dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
 			common->rx_bufsize,
 			DMA_FROM_DEVICE);
 
-- 
1.6.2.5

