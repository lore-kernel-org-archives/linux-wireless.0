Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:44094 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbaEGNHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 09:07:13 -0400
Received: by mail-ee0-f44.google.com with SMTP id c41so719835eek.31
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 06:07:12 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, apenwarr@gmail.com,
	greearb@candelatech.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: fix htt rx ring clean up
Date: Wed,  7 May 2014 14:33:25 +0200
Message-Id: <1399466006-5556-2-git-send-email-michal.kazior@tieto.com> (sfid-20140507_150725_689216_3DB8CFCE)
In-Reply-To: <1399466006-5556-1-git-send-email-michal.kazior@tieto.com>
References: <1399466006-5556-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

msdu_payId was read before txrx tasklet was killed
so it was possible to end up using an invalid
sk_buff pointer leading to a panic.

Make sure to sanitize rx ring sk_buff pointers and
make the clean up go through all possible entries
and not rely on coherent-DMA mapped u32 index
which could be (in theory) corrupted by the device
as well.

Reported-By: Avery Pennarun <apenwarr@gmail.com>
Reported-By: Ben Greear <greearb@candelatech.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 36 +++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f85a3cf..db6c8af 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -225,10 +225,26 @@ static void ath10k_htt_rx_ring_refill_retry(unsigned long arg)
 	ath10k_htt_rx_msdu_buff_replenish(htt);
 }
 
-void ath10k_htt_rx_detach(struct ath10k_htt *htt)
+static void ath10k_htt_rx_ring_clean_up(struct ath10k_htt *htt)
 {
-	int sw_rd_idx = htt->rx_ring.sw_rd_idx.msdu_payld;
+	struct sk_buff *skb;
+	int i;
+
+	for (i = 0; i < htt->rx_ring.size; i++) {
+		skb = htt->rx_ring.netbufs_ring[i];
+		if (!skb)
+			continue;
+
+		dma_unmap_single(htt->ar->dev, ATH10K_SKB_CB(skb)->paddr,
+				 skb->len + skb_tailroom(skb),
+				 DMA_FROM_DEVICE);
+		dev_kfree_skb_any(skb);
+		htt->rx_ring.netbufs_ring[i] = NULL;
+	}
+}
 
+void ath10k_htt_rx_detach(struct ath10k_htt *htt)
+{
 	del_timer_sync(&htt->rx_ring.refill_retry_timer);
 	tasklet_kill(&htt->rx_replenish_task);
 	tasklet_kill(&htt->txrx_compl_task);
@@ -236,18 +252,7 @@ void ath10k_htt_rx_detach(struct ath10k_htt *htt)
 	skb_queue_purge(&htt->tx_compl_q);
 	skb_queue_purge(&htt->rx_compl_q);
 
-	while (sw_rd_idx != __le32_to_cpu(*(htt->rx_ring.alloc_idx.vaddr))) {
-		struct sk_buff *skb =
-				htt->rx_ring.netbufs_ring[sw_rd_idx];
-		struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
-
-		dma_unmap_single(htt->ar->dev, cb->paddr,
-				 skb->len + skb_tailroom(skb),
-				 DMA_FROM_DEVICE);
-		dev_kfree_skb_any(htt->rx_ring.netbufs_ring[sw_rd_idx]);
-		sw_rd_idx++;
-		sw_rd_idx &= htt->rx_ring.size_mask;
-	}
+	ath10k_htt_rx_ring_clean_up(htt);
 
 	dma_free_coherent(htt->ar->dev,
 			  (htt->rx_ring.size *
@@ -277,6 +282,7 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 
 	idx = htt->rx_ring.sw_rd_idx.msdu_payld;
 	msdu = htt->rx_ring.netbufs_ring[idx];
+	htt->rx_ring.netbufs_ring[idx] = NULL;
 
 	idx++;
 	idx &= htt->rx_ring.size_mask;
@@ -494,7 +500,7 @@ int ath10k_htt_rx_attach(struct ath10k_htt *htt)
 	htt->rx_ring.fill_level = ath10k_htt_rx_ring_fill_level(htt);
 
 	htt->rx_ring.netbufs_ring =
-		kmalloc(htt->rx_ring.size * sizeof(struct sk_buff *),
+		kzalloc(htt->rx_ring.size * sizeof(struct sk_buff *),
 			GFP_KERNEL);
 	if (!htt->rx_ring.netbufs_ring)
 		goto err_netbuf;
-- 
1.8.5.3

