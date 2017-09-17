Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35873 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdIQTkb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Sep 2017 15:40:31 -0400
Received: by mail-lf0-f65.google.com with SMTP id l196so3535715lfl.3
        for <linux-wireless@vger.kernel.org>; Sun, 17 Sep 2017 12:40:30 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v3 07/11] ath10k: various fixes for high latency devices
Date: Sun, 17 Sep 2017 21:40:09 +0200
Message-Id: <20170917194013.8658-8-erik.stromdahl@gmail.com> (sfid-20170917_214037_712660_05840708)
In-Reply-To: <20170917194013.8658-1-erik.stromdahl@gmail.com>
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several DMA related functions (such as the dma_map_xxx functions)
are not used with high latency devices and don't need to be invoked
in this case.

A few other execution paths are not applicable for high latency
devices and can be skipped.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.c    | 19 ++++++++++++-------
 drivers/net/wireless/ath/ath10k/htt_rx.c |  3 ++-
 drivers/net/wireless/ath/ath10k/htt_tx.c |  9 +++++++--
 drivers/net/wireless/ath/ath10k/txrx.c   |  5 +++--
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index e5c80f582ff5..75c2a3ea7ec9 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -53,7 +53,8 @@ static inline void ath10k_htc_restore_tx_skb(struct ath10k_htc *htc,
 {
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 
-	dma_unmap_single(htc->ar->dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
+	if (!htc->ar->is_high_latency)
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
+	if (!ar->is_high_latency) {
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
+	if (!ar->is_high_latency)
+		dma_unmap_single(dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
 err_credits:
 	if (ep->tx_credit_flow_enabled) {
 		spin_lock_bh(&htc->tx_lock);
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 7461555ccad5..569edd0720c6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2541,7 +2541,8 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_TX_COMPL_IND:
-		ath10k_htt_rx_tx_compl_ind(htt->ar, skb);
+		if (!ar->is_high_latency)
+			ath10k_htt_rx_tx_compl_ind(htt->ar, skb);
 		break;
 	case HTT_T2H_MSG_TYPE_SEC_IND: {
 		struct ath10k *ar = htt->ar;
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index a3d69f852e38..82d01139ff92 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -409,6 +409,9 @@ int ath10k_htt_tx_start(struct ath10k_htt *htt)
 	if (htt->tx_mem_allocated)
 		return 0;
 
+	if (ar->is_high_latency)
+		return 0;
+
 	ret = ath10k_htt_tx_alloc_buf(htt);
 	if (ret)
 		goto free_idr_pending_tx;
@@ -445,7 +448,8 @@ void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
 		return;
 
 	ath10k_htt_tx_free_cont_txbuf(htt);
-	ath10k_htt_tx_free_txq(htt);
+	if (!htt->ar->is_high_latency)
+		ath10k_htt_tx_free_txq(htt);
 	ath10k_htt_tx_free_cont_frag_desc(htt);
 	ath10k_htt_tx_free_txdone_fifo(htt);
 	htt->tx_mem_allocated = false;
@@ -935,7 +939,8 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	return 0;
 
 err_unmap_msdu:
-	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
+	if (!ar->is_high_latency)
+		dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 err_free_txdesc:
 	dev_kfree_skb_any(txdesc);
 err_free_msdu_id:
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index d4986f626c35..fae143e4dcfa 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -90,11 +90,12 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
 	ath10k_htt_tx_dec_pending(htt);
-	if (htt->num_pending_tx == 0)
+	if (!ar->is_high_latency && (htt->num_pending_tx == 0))
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
-	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
+	if (!ar->is_high_latency)
+		dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
 	ath10k_report_offchan_tx(htt->ar, msdu);
 
-- 
2.14.1
