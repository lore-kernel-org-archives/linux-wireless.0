Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64518 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbbAPLRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 06:17:52 -0500
Received: by mail-wi0-f180.google.com with SMTP id bs8so3139037wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 03:17:50 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: introduce struct ath10k_skb_rxcb
Date: Fri, 16 Jan 2015 12:17:08 +0100
Message-Id: <1421407029-23967-1-git-send-email-michal.kazior@tieto.com> (sfid-20150116_121755_989087_F5C7B77C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to share the
ath10k_skb_cb with Rx path. The Rx path doesn't
need to keep any mac80211's data.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   | 10 ++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 10 +++++-----
 drivers/net/wireless/ath/ath10k/pci.c    |  6 +++---
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c5686122..739d9d69 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -97,6 +97,10 @@ struct ath10k_skb_cb {
 	} bcn;
 } __packed;
 
+struct ath10k_skb_rxcb {
+	dma_addr_t paddr;
+};
+
 static inline struct ath10k_skb_cb *ATH10K_SKB_CB(struct sk_buff *skb)
 {
 	BUILD_BUG_ON(sizeof(struct ath10k_skb_cb) >
@@ -104,6 +108,12 @@ static inline struct ath10k_skb_cb *ATH10K_SKB_CB(struct sk_buff *skb)
 	return (struct ath10k_skb_cb *)&IEEE80211_SKB_CB(skb)->driver_data;
 }
 
+static inline struct ath10k_skb_rxcb *ATH10K_SKB_RXCB(struct sk_buff *skb)
+{
+	BUILD_BUG_ON(sizeof(struct ath10k_skb_rxcb) > sizeof(skb->cb));
+	return (struct ath10k_skb_rxcb *)skb->cb;
+}
+
 static inline u32 host_interest_item_address(u32 item_offset)
 {
 	return QCA988X_HOST_INTEREST_ADDRESS + item_offset;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index baa1c44..2e55ed7 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -37,12 +37,12 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr);
 static void ath10k_htt_rx_ring_free(struct ath10k_htt *htt)
 {
 	struct sk_buff *skb;
-	struct ath10k_skb_cb *cb;
+	struct ath10k_skb_rxcb *cb;
 	int i;
 
 	for (i = 0; i < htt->rx_ring.fill_cnt; i++) {
 		skb = htt->rx_ring.netbufs_ring[i];
-		cb = ATH10K_SKB_CB(skb);
+		cb = ATH10K_SKB_RXCB(skb);
 		dma_unmap_single(htt->ar->dev, cb->paddr,
 				 skb->len + skb_tailroom(skb),
 				 DMA_FROM_DEVICE);
@@ -86,7 +86,7 @@ static int __ath10k_htt_rx_ring_fill_n(struct ath10k_htt *htt, int num)
 			goto fail;
 		}
 
-		ATH10K_SKB_CB(skb)->paddr = paddr;
+		ATH10K_SKB_RXCB(skb)->paddr = paddr;
 		htt->rx_ring.netbufs_ring[idx] = skb;
 		htt->rx_ring.paddrs_ring[idx] = __cpu_to_le32(paddr);
 		htt->rx_ring.fill_cnt++;
@@ -168,7 +168,7 @@ static void ath10k_htt_rx_ring_clean_up(struct ath10k_htt *htt)
 		if (!skb)
 			continue;
 
-		dma_unmap_single(htt->ar->dev, ATH10K_SKB_CB(skb)->paddr,
+		dma_unmap_single(htt->ar->dev, ATH10K_SKB_RXCB(skb)->paddr,
 				 skb->len + skb_tailroom(skb),
 				 DMA_FROM_DEVICE);
 		dev_kfree_skb_any(skb);
@@ -224,7 +224,7 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 	htt->rx_ring.fill_cnt--;
 
 	dma_unmap_single(htt->ar->dev,
-			 ATH10K_SKB_CB(msdu)->paddr,
+			 ATH10K_SKB_RXCB(msdu)->paddr,
 			 msdu->len + skb_tailroom(msdu),
 			 DMA_FROM_DEVICE);
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt rx netbuf pop: ",
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 3b40a86..b98354c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -403,7 +403,7 @@ static int __ath10k_pci_rx_post_buf(struct ath10k_pci_pipe *pipe)
 		return -EIO;
 	}
 
-	ATH10K_SKB_CB(skb)->paddr = paddr;
+	ATH10K_SKB_RXCB(skb)->paddr = paddr;
 
 	ret = __ath10k_ce_rx_post_buf(ce_pipe, skb, paddr);
 	if (ret) {
@@ -872,7 +872,7 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 					     &flags) == 0) {
 		skb = transfer_context;
 		max_nbytes = skb->len + skb_tailroom(skb);
-		dma_unmap_single(ar->dev, ATH10K_SKB_CB(skb)->paddr,
+		dma_unmap_single(ar->dev, ATH10K_SKB_RXCB(skb)->paddr,
 				 max_nbytes, DMA_FROM_DEVICE);
 
 		if (unlikely(max_nbytes < nbytes)) {
@@ -1238,7 +1238,7 @@ static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
 
 		ce_ring->per_transfer_context[i] = NULL;
 
-		dma_unmap_single(ar->dev, ATH10K_SKB_CB(skb)->paddr,
+		dma_unmap_single(ar->dev, ATH10K_SKB_RXCB(skb)->paddr,
 				 skb->len + skb_tailroom(skb),
 				 DMA_FROM_DEVICE);
 		dev_kfree_skb_any(skb);
-- 
1.8.5.3

