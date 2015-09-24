Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47542 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbbIXRyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 13:54:37 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: use pre-allocated DMA buffer in Tx
Date: Thu, 24 Sep 2015 10:54:30 -0700
Message-ID: <1443117270-16790-1-git-send-email-poh@qca.qualcomm.com> (sfid-20150924_195441_223164_E31CD851)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k driver is using dma_pool_alloc per packet and dma_pool_free
in coresponding at Tx completion.
Use of pre-allocated DMA buffer in Tx will improve saving CPU resource
by 5% while it consumes about 56KB memory more as trade off.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |  6 ++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 43 +++++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/txrx.c   |  5 ----
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 5a8e4ea..db0a99b 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1488,7 +1488,6 @@ struct ath10k_htt {
 	int num_pending_mgmt_tx;
 	struct idr pending_tx;
 	wait_queue_head_t empty_tx_wq;
-	struct dma_pool *tx_pool;
 
 	/* set if host-fw communication goes haywire
 	 * used to avoid further failures */
@@ -1509,6 +1508,11 @@ struct ath10k_htt {
 		dma_addr_t paddr;
 		struct htt_msdu_ext_desc *vaddr;
 	} frag_desc;
+
+	struct {
+		dma_addr_t paddr;
+		struct ath10k_htt_txbuf *vaddr;
+	} txbuf;
 };
 
 #define RX_HTT_HDR_STATUS_LEN 64
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index eb5ba9b..5bed087 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -108,9 +108,12 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 	spin_lock_init(&htt->tx_lock);
 	idr_init(&htt->pending_tx);
 
-	htt->tx_pool = dma_pool_create("ath10k htt tx pool", htt->ar->dev,
-				       sizeof(struct ath10k_htt_txbuf), 4, 0);
-	if (!htt->tx_pool) {
+	size = htt->max_num_pending_tx * sizeof(struct ath10k_htt_txbuf);
+	htt->txbuf.vaddr = dma_alloc_coherent(ar->dev, size,
+						  &htt->txbuf.paddr,
+						  GFP_DMA);
+	if (!htt->txbuf.vaddr) {
+		ath10k_err(ar, "failed to alloc tx buffer\n");
 		ret = -ENOMEM;
 		goto free_idr_pending_tx;
 	}
@@ -125,14 +128,17 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 	if (!htt->frag_desc.vaddr) {
 		ath10k_warn(ar, "failed to alloc fragment desc memory\n");
 		ret = -ENOMEM;
-		goto free_tx_pool;
+		goto free_txbuf;
 	}
 
 skip_frag_desc_alloc:
 	return 0;
 
-free_tx_pool:
-	dma_pool_destroy(htt->tx_pool);
+free_txbuf:
+	size = htt->max_num_pending_tx *
+			  sizeof(struct ath10k_htt_txbuf);
+	dma_free_coherent(htt->ar->dev, size, htt->txbuf.vaddr,
+		  htt->txbuf.paddr);
 free_idr_pending_tx:
 	idr_destroy(&htt->pending_tx);
 	return ret;
@@ -160,7 +166,13 @@ void ath10k_htt_tx_free(struct ath10k_htt *htt)
 
 	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
 	idr_destroy(&htt->pending_tx);
-	dma_pool_destroy(htt->tx_pool);
+
+	if (htt->txbuf.vaddr) {
+		size = htt->max_num_pending_tx *
+				  sizeof(struct ath10k_htt_txbuf);
+		dma_free_coherent(htt->ar->dev, size, htt->txbuf.vaddr,
+				  htt->txbuf.paddr);
+	}
 
 	if (htt->frag_desc.vaddr) {
 		size = htt->max_num_pending_tx *
@@ -521,7 +533,6 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	int res;
 	u8 flags0 = 0;
 	u16 msdu_id, flags1 = 0;
-	dma_addr_t paddr = 0;
 	u32 frags_paddr = 0;
 	struct htt_msdu_ext_desc *ext_desc = NULL;
 	bool limit_mgmt_desc = false;
@@ -550,13 +561,9 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	prefetch_len = min(htt->prefetch_len, msdu->len);
 	prefetch_len = roundup(prefetch_len, 4);
 
-	skb_cb->htt.txbuf = dma_pool_alloc(htt->tx_pool, GFP_ATOMIC,
-					   &paddr);
-	if (!skb_cb->htt.txbuf) {
-		res = -ENOMEM;
-		goto err_free_msdu_id;
-	}
-	skb_cb->htt.txbuf_paddr = paddr;
+	skb_cb->htt.txbuf = &htt->txbuf.vaddr[msdu_id];
+	skb_cb->htt.txbuf_paddr = htt->txbuf.paddr +
+		(sizeof(struct ath10k_htt_txbuf) * msdu_id);
 
 	if ((ieee80211_is_action(hdr->frame_control) ||
 	     ieee80211_is_deauth(hdr->frame_control) ||
@@ -574,7 +581,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	res = dma_mapping_error(dev, skb_cb->paddr);
 	if (res) {
 		res = -EIO;
-		goto err_free_txbuf;
+		goto err_free_msdu_id;
 	}
 
 	switch (skb_cb->txmode) {
@@ -706,10 +713,6 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 err_unmap_msdu:
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
-err_free_txbuf:
-	dma_pool_free(htt->tx_pool,
-		      skb_cb->htt.txbuf,
-		      skb_cb->htt.txbuf_paddr);
 err_free_msdu_id:
 	spin_lock_bh(&htt->tx_lock);
 	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 7db7d50..6d1105a 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -92,11 +92,6 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	skb_cb = ATH10K_SKB_CB(msdu);
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
-	if (skb_cb->htt.txbuf)
-		dma_pool_free(htt->tx_pool,
-			      skb_cb->htt.txbuf,
-			      skb_cb->htt.txbuf_paddr);
-
 	ath10k_report_offchan_tx(htt->ar, msdu);
 
 	info = IEEE80211_SKB_CB(msdu);
-- 
1.9.1

