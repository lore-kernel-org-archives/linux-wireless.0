Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:35462 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342Ab0ENNP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 09:15:57 -0400
Received: by pzk42 with SMTP id 42so1329911pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 06:15:55 -0700 (PDT)
From: tom.leiming@gmail.com
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/2] ath9k: fix dma direction for map/unmap in ath_rx_tasklet
Date: Fri, 14 May 2010 21:15:38 +0800
Message-Id: <1273842938-3401-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

For edma, we should use DMA_BIDIRECTIONAL, or else use
DMA_FROM_DEVICE.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ba13913..a3fe6e1 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -838,9 +838,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	int dma_type;
 
 	if (edma)
-		dma_type = DMA_FROM_DEVICE;
-	else
 		dma_type = DMA_BIDIRECTIONAL;
+	else
+		dma_type = DMA_FROM_DEVICE;
 
 	qtype = hp ? ATH9K_RX_QUEUE_HP : ATH9K_RX_QUEUE_LP;
 	spin_lock_bh(&sc->rx.rxbuflock);
-- 
1.6.2.5

