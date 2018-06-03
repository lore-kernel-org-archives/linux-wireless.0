Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:37985 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbeFCSWP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Jun 2018 14:22:15 -0400
Received: by mail-lf0-f68.google.com with SMTP id i83-v6so9617548lfh.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2018 11:22:14 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v5 06/12] ath10k: DMA related fixes for high latency devices
Date: Sun,  3 Jun 2018 20:20:23 +0200
Message-Id: <20180603182029.8914-7-erik.stromdahl@gmail.com> (sfid-20180603_202219_187274_9497E2FC)
In-Reply-To: <20180603182029.8914-1-erik.stromdahl@gmail.com>
References: <20180603182029.8914-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several DMA related functions (such as the dma_map_xxx functions)
are not used with high latency devices and don't need to be invoked
in this case.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.c    | 19 ++++++++++++-------
 drivers/net/wireless/ath/ath10k/htt_tx.c |  3 ++-
 drivers/net/wireless/ath/ath10k/txrx.c   |  3 ++-
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 8902720b4e49..b47e0547f767 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -53,7 +53,8 @@ static inline void ath10k_htc_restore_tx_skb(struct ath10k_htc *htc,
 {
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 
-	dma_unmap_single(htc->ar->dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
+	if (htc->ar->dev_type != ATH10K_DEV_TYPE_HL)
+		dma_unmap_single(htc->ar->dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
 	skb_pull(skb, sizeof(struct ath10k_htc_hdr));
 }
 
@@ -137,11 +138,14 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 	ath10k_htc_prepare_tx_skb(ep, skb);
 
 	skb_cb->eid = eid;
-	skb_cb->paddr = dma_map_single(dev, skb->data, skb->len, DMA_TO_DEVICE);
-	ret = dma_mapping_error(dev, skb_cb->paddr);
-	if (ret) {
-		ret = -EIO;
-		goto err_credits;
+	if (ar->dev_type != ATH10K_DEV_TYPE_HL) {
+		skb_cb->paddr = dma_map_single(dev, skb->data, skb->len,
+					       DMA_TO_DEVICE);
+		ret = dma_mapping_error(dev, skb_cb->paddr);
+		if (ret) {
+			ret = -EIO;
+			goto err_credits;
+		}
 	}
 
 	sg_item.transfer_id = ep->eid;
@@ -157,7 +161,8 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 	return 0;
 
 err_unmap:
-	dma_unmap_single(dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
+	if (ar->dev_type != ATH10K_DEV_TYPE_HL)
+		dma_unmap_single(dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
 err_credits:
 	if (ep->tx_credit_flow_enabled) {
 		spin_lock_bh(&htc->tx_lock);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 5d8b97a0ccaa..79a8eca46e88 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1125,7 +1125,8 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	return 0;
 
 err_unmap_msdu:
-	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
+	if (ar->dev_type != ATH10K_DEV_TYPE_HL)
+		dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 err_free_txdesc:
 	dev_kfree_skb_any(txdesc);
 err_free_msdu_id:
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index cda164f6e9f6..23606b6972d0 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -95,7 +95,8 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
-	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
+	if (ar->dev_type != ATH10K_DEV_TYPE_HL)
+		dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
 	ath10k_report_offchan_tx(htt->ar, msdu);
 
-- 
2.17.0
