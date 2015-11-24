Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:44260
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753529AbbKXKg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 05:36:59 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath10k@lists.infradead.org,
	poh@codeaurora.org
Subject: [PATCH] ath10k: stop abusing GFP_DMA
Date: Tue, 24 Nov 2015 11:36:52 +0100
Message-Id: <1448361412-22589-1-git-send-email-nbd@openwrt.org> (sfid-20151124_113708_290952_38407E00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allocations from the DMA zone were originally added for legacy ISA
stuff, or PCI devices that have specific limitations in their DMA
addressing capabilities. It has no place in ath10k, which can do
full 32-bit DMA.

Fixes memory allocation errors on some platforms.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 4 ++--
 drivers/net/wireless/ath/ath10k/htt_tx.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 396645b..8f240e1 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -536,7 +536,7 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 
 	size = htt->rx_ring.size * sizeof(htt->rx_ring.paddrs_ring);
 
-	vaddr = dma_alloc_coherent(htt->ar->dev, size, &paddr, GFP_DMA);
+	vaddr = dma_alloc_coherent(htt->ar->dev, size, &paddr, GFP_KERNEL);
 	if (!vaddr)
 		goto err_dma_ring;
 
@@ -545,7 +545,7 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 
 	vaddr = dma_alloc_coherent(htt->ar->dev,
 				   sizeof(*htt->rx_ring.alloc_idx.vaddr),
-				   &paddr, GFP_DMA);
+				   &paddr, GFP_KERNEL);
 	if (!vaddr)
 		goto err_dma_idx;
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 8f76b9d..ed62ec8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -111,7 +111,7 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 	size = htt->max_num_pending_tx * sizeof(struct ath10k_htt_txbuf);
 	htt->txbuf.vaddr = dma_alloc_coherent(ar->dev, size,
 						  &htt->txbuf.paddr,
-						  GFP_DMA);
+						  GFP_KERNEL);
 	if (!htt->txbuf.vaddr) {
 		ath10k_err(ar, "failed to alloc tx buffer\n");
 		ret = -ENOMEM;
@@ -124,7 +124,7 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 	size = htt->max_num_pending_tx * sizeof(struct htt_msdu_ext_desc);
 	htt->frag_desc.vaddr = dma_alloc_coherent(ar->dev, size,
 						  &htt->frag_desc.paddr,
-						  GFP_DMA);
+						  GFP_KERNEL);
 	if (!htt->frag_desc.vaddr) {
 		ath10k_warn(ar, "failed to alloc fragment desc memory\n");
 		ret = -ENOMEM;
-- 
2.2.2

