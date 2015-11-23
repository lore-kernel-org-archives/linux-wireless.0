Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:40619
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752263AbbKWNiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 08:38:16 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath10k@lists.infradead.org
Subject: [PATCH 2/2] ath10k: do not use coherent memory for tx buffers
Date: Mon, 23 Nov 2015 14:18:49 +0100
Message-Id: <1448284729-98078-2-git-send-email-nbd@openwrt.org> (sfid-20151123_143819_917009_2EC97DF3)
In-Reply-To: <1448284729-98078-1-git-send-email-nbd@openwrt.org>
References: <1448284729-98078-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Coherent memory is expensive to access, since all memory accesses bypass
the cache. It is also completely unnecessary for this case.
Convert to mapped memory instead and use the DMA API to flush the cache
where necessary.
Fixes allocation failures on embedded devices.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 77 +++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 8f76b9d..99d9793 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -100,7 +100,7 @@ void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id)
 int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 {
 	struct ath10k *ar = htt->ar;
-	int ret, size;
+	int size;
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "htt tx max num pending tx %d\n",
 		   htt->max_num_pending_tx);
@@ -109,39 +109,41 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 	idr_init(&htt->pending_tx);
 
 	size = htt->max_num_pending_tx * sizeof(struct ath10k_htt_txbuf);
-	htt->txbuf.vaddr = dma_alloc_coherent(ar->dev, size,
-						  &htt->txbuf.paddr,
-						  GFP_DMA);
-	if (!htt->txbuf.vaddr) {
-		ath10k_err(ar, "failed to alloc tx buffer\n");
-		ret = -ENOMEM;
+	htt->txbuf.vaddr = kzalloc(size, GFP_KERNEL);
+	if (!htt->txbuf.vaddr)
 		goto free_idr_pending_tx;
-	}
+
+	htt->txbuf.paddr = dma_map_single(ar->dev, htt->txbuf.vaddr, size,
+					  DMA_TO_DEVICE);
+	if (dma_mapping_error(ar->dev, htt->txbuf.paddr))
+		goto free_txbuf_vaddr;
 
 	if (!ar->hw_params.continuous_frag_desc)
-		goto skip_frag_desc_alloc;
+		return 0;
 
 	size = htt->max_num_pending_tx * sizeof(struct htt_msdu_ext_desc);
-	htt->frag_desc.vaddr = dma_alloc_coherent(ar->dev, size,
-						  &htt->frag_desc.paddr,
-						  GFP_DMA);
-	if (!htt->frag_desc.vaddr) {
-		ath10k_warn(ar, "failed to alloc fragment desc memory\n");
-		ret = -ENOMEM;
+	htt->frag_desc.vaddr = kzalloc(size, GFP_KERNEL);
+	if (!htt->frag_desc.vaddr)
 		goto free_txbuf;
-	}
 
-skip_frag_desc_alloc:
+	htt->frag_desc.paddr = dma_map_single(ar->dev, htt->frag_desc.vaddr,
+					      size, DMA_TO_DEVICE);
+	if (dma_mapping_error(ar->dev, htt->txbuf.paddr))
+		goto free_frag_desc;
+
 	return 0;
 
+free_frag_desc:
+	kfree(htt->frag_desc.vaddr);
 free_txbuf:
 	size = htt->max_num_pending_tx *
 			  sizeof(struct ath10k_htt_txbuf);
-	dma_free_coherent(htt->ar->dev, size, htt->txbuf.vaddr,
-			  htt->txbuf.paddr);
+	dma_unmap_single(htt->ar->dev, htt->txbuf.paddr, size, DMA_TO_DEVICE);
+free_txbuf_vaddr:
+	kfree(htt->txbuf.vaddr);
 free_idr_pending_tx:
 	idr_destroy(&htt->pending_tx);
-	return ret;
+	return -ENOMEM;
 }
 
 static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
@@ -170,15 +172,17 @@ void ath10k_htt_tx_free(struct ath10k_htt *htt)
 	if (htt->txbuf.vaddr) {
 		size = htt->max_num_pending_tx *
 				  sizeof(struct ath10k_htt_txbuf);
-		dma_free_coherent(htt->ar->dev, size, htt->txbuf.vaddr,
-				  htt->txbuf.paddr);
+		dma_unmap_single(htt->ar->dev, htt->txbuf.paddr, size,
+				 DMA_TO_DEVICE);
+		kfree(htt->txbuf.vaddr);
 	}
 
 	if (htt->frag_desc.vaddr) {
 		size = htt->max_num_pending_tx *
 				  sizeof(struct htt_msdu_ext_desc);
-		dma_free_coherent(htt->ar->dev, size, htt->frag_desc.vaddr,
-				  htt->frag_desc.paddr);
+		dma_unmap_single(htt->ar->dev, htt->frag_desc.paddr, size,
+				 DMA_TO_DEVICE);
+		kfree(htt->frag_desc.vaddr);
 	}
 }
 
@@ -550,6 +554,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	struct htt_msdu_ext_desc *ext_desc = NULL;
 	bool limit_mgmt_desc = false;
 	bool is_probe_resp = false;
+	int txbuf_offset, frag_offset, frag_size;
 
 	if (unlikely(ieee80211_is_mgmt(hdr->frame_control)) &&
 	    ar->hw_params.max_probe_resp_desc_thres) {
@@ -574,9 +579,11 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	prefetch_len = min(htt->prefetch_len, msdu->len);
 	prefetch_len = roundup(prefetch_len, 4);
 
+	frag_size = sizeof(struct htt_msdu_ext_desc);
+	frag_offset = frag_size * msdu_id;
+	txbuf_offset = sizeof(struct ath10k_htt_txbuf) * msdu_id;
 	skb_cb->htt.txbuf = &htt->txbuf.vaddr[msdu_id];
-	skb_cb->htt.txbuf_paddr = htt->txbuf.paddr +
-		(sizeof(struct ath10k_htt_txbuf) * msdu_id);
+	skb_cb->htt.txbuf_paddr = htt->txbuf.paddr + txbuf_offset;
 
 	if ((ieee80211_is_action(hdr->frame_control) ||
 	     ieee80211_is_deauth(hdr->frame_control) ||
@@ -597,6 +604,15 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		goto err_free_msdu_id;
 	}
 
+	dma_sync_single_range_for_cpu(dev, htt->txbuf.paddr, txbuf_offset,
+				      sizeof(struct ath10k_htt_txbuf),
+				      DMA_TO_DEVICE);
+
+	if (ar->hw_params.continuous_frag_desc)
+		dma_sync_single_range_for_cpu(dev, htt->frag_desc.paddr,
+					      frag_offset, frag_size,
+					      DMA_TO_DEVICE);
+
 	switch (skb_cb->txmode) {
 	case ATH10K_HW_TXRX_RAW:
 	case ATH10K_HW_TXRX_NATIVE_WIFI:
@@ -723,6 +739,15 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	sg_items[1].paddr = skb_cb->paddr;
 	sg_items[1].len = prefetch_len;
 
+	if (ar->hw_params.continuous_frag_desc)
+		dma_sync_single_range_for_device(dev, htt->frag_desc.paddr,
+						 frag_offset, frag_size,
+						 DMA_TO_DEVICE);
+
+	dma_sync_single_range_for_device(dev, htt->txbuf.paddr, txbuf_offset,
+					 sizeof(struct ath10k_htt_txbuf),
+					 DMA_TO_DEVICE);
+
 	res = ath10k_hif_tx_sg(htt->ar,
 			       htt->ar->htc.endpoint[htt->eid].ul_pipe_id,
 			       sg_items, ARRAY_SIZE(sg_items));
-- 
2.2.2

