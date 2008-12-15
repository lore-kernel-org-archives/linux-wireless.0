Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32671 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYLOPMx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 10:12:53 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 07:12:53 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Synchronize DMA transfer with CPU at right place
Date: Mon, 15 Dec 2008 20:40:46 +0530
Message-ID: <1229353846-6531-2-git-send-email-vasanth@atheros.com> (sfid-20081215_161303_128673_5F8E545D)
In-Reply-To: <1229353846-6531-1-git-send-email-vasanth@atheros.com>
References: <1229353846-6531-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch does pci_dma_sync_single_for_cpu() before accessing
the header of the frame and queueing the same buffer into h/w.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/recv.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 6a91d04..6f81feb 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -525,6 +525,15 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			continue;
 
 		/*
+		 * Synchronize the DMA transfer with CPU before
+		 * 1. accessing the frame
+		 * 2. requeueing the same buffer to h/w
+		 */
+		pci_dma_sync_single_for_cpu(sc->pdev, bf->bf_buf_addr,
+				sc->rx.bufsize,
+				PCI_DMA_FROMDEVICE);
+
+		/*
 		 * If we're asked to flush receive queue, directly
 		 * chain it back at the queue without processing it.
 		 */
@@ -558,10 +567,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		if (!requeue_skb)
 			goto requeue;
 
-		/* Sync and unmap the frame */
-		pci_dma_sync_single_for_cpu(sc->pdev, bf->bf_buf_addr,
-					    sc->rx.bufsize,
-					    PCI_DMA_FROMDEVICE);
+		/* Unmap the frame */
 		pci_unmap_single(sc->pdev, bf->bf_buf_addr,
 				 sc->rx.bufsize,
 				 PCI_DMA_FROMDEVICE);
-- 
1.5.5.1

