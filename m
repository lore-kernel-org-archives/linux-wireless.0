Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:37375 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbaHGJO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:14:28 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so3888669wgg.24
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:14:27 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/5] ath10k: rework posting pci rx buffers
Date: Thu,  7 Aug 2014 11:05:04 +0200
Message-Id: <1407402308-29899-2-git-send-email-michal.kazior@tieto.com> (sfid-20140807_111433_744713_305F1DC3)
In-Reply-To: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com>
References: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible on a host system running low on
memory to end up with no rx buffers on pci pipes.

This also cleans up the code a bit and, as a side
effect, makes it possible to call
ath10k_hif_start() more than once.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |  71 +++++++----
 drivers/net/wireless/ath/ath10k/ce.h  |  16 +--
 drivers/net/wireless/ath/ath10k/pci.c | 234 ++++++++++++++++++----------------
 drivers/net/wireless/ath/ath10k/pci.h |   2 +
 4 files changed, 175 insertions(+), 148 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 8cbc0ab..f666816 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -385,44 +385,59 @@ int ath10k_ce_num_free_src_entries(struct ath10k_ce_pipe *pipe)
 	return delta;
 }
 
-int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
-			       void *per_recv_context,
-			       u32 buffer)
+
+int __ath10k_ce_rx_num_free_bufs(struct ath10k_ce_pipe *pipe)
 {
-	struct ath10k_ce_ring *dest_ring = ce_state->dest_ring;
-	u32 ctrl_addr = ce_state->ctrl_addr;
-	struct ath10k *ar = ce_state->ar;
+	struct ath10k *ar = pipe->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_ce_ring *dest_ring = pipe->dest_ring;
 	unsigned int nentries_mask = dest_ring->nentries_mask;
-	unsigned int write_index;
-	unsigned int sw_index;
-	int ret;
+	unsigned int write_index = dest_ring->write_index;
+	unsigned int sw_index = dest_ring->sw_index;
 
-	spin_lock_bh(&ar_pci->ce_lock);
-	write_index = dest_ring->write_index;
-	sw_index = dest_ring->sw_index;
+	lockdep_assert_held(&ar_pci->ce_lock);
 
-	if (CE_RING_DELTA(nentries_mask, write_index, sw_index - 1) > 0) {
-		struct ce_desc *base = dest_ring->base_addr_owner_space;
-		struct ce_desc *desc = CE_DEST_RING_TO_DESC(base, write_index);
+	return CE_RING_DELTA(nentries_mask, write_index, sw_index - 1);
+}
+
+int __ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr)
+{
+	struct ath10k *ar = pipe->ar;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_ce_ring *dest_ring = pipe->dest_ring;
+	unsigned int nentries_mask = dest_ring->nentries_mask;
+	unsigned int write_index = dest_ring->write_index;
+	unsigned int sw_index = dest_ring->sw_index;
+	struct ce_desc *base = dest_ring->base_addr_owner_space;
+	struct ce_desc *desc = CE_DEST_RING_TO_DESC(base, write_index);
+	u32 ctrl_addr = pipe->ctrl_addr;
 
-		/* Update destination descriptor */
-		desc->addr    = __cpu_to_le32(buffer);
-		desc->nbytes = 0;
+	lockdep_assert_held(&ar_pci->ce_lock);
 
-		dest_ring->per_transfer_context[write_index] =
-							per_recv_context;
+	if (CE_RING_DELTA(nentries_mask, write_index, sw_index - 1) == 0)
+		return -EIO;
 
-		/* Update Destination Ring Write Index */
-		write_index = CE_RING_IDX_INCR(nentries_mask, write_index);
-		ath10k_ce_dest_ring_write_index_set(ar, ctrl_addr, write_index);
-		dest_ring->write_index = write_index;
-		ret = 0;
-	} else {
-		ret = -EIO;
-	}
+	desc->addr = __cpu_to_le32(paddr);
+	desc->nbytes = 0;
+
+	dest_ring->per_transfer_context[write_index] = ctx;
+	write_index = CE_RING_IDX_INCR(nentries_mask, write_index);
+	ath10k_ce_dest_ring_write_index_set(ar, ctrl_addr, write_index);
+	dest_ring->write_index = write_index;
 
+	return 0;
+}
+
+int ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr)
+{
+	struct ath10k *ar = pipe->ar;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int ret;
+
+	spin_lock_bh(&ar_pci->ce_lock);
+	ret = __ath10k_ce_rx_post_buf(pipe, ctx, paddr);
 	spin_unlock_bh(&ar_pci->ce_lock);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index d48dbb9..82d1f23 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -166,19 +166,9 @@ int ath10k_ce_num_free_src_entries(struct ath10k_ce_pipe *pipe);
 
 /*==================Recv=======================*/
 
-/*
- * Make a buffer available to receive. The buffer must be at least of a
- * minimal size appropriate for this copy engine (src_sz_max attribute).
- *   ce                    - which copy engine to use
- *   per_transfer_recv_context  - context passed back to caller's recv_cb
- *   buffer                     - address of buffer in CE space
- * Returns 0 on success; otherwise an error status.
- *
- * Implemenation note: Pushes a buffer to Dest ring.
- */
-int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
-			       void *per_transfer_recv_context,
-			       u32 buffer);
+int __ath10k_ce_rx_num_free_bufs(struct ath10k_ce_pipe *pipe);
+int __ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr);
+int ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr);
 
 /* recv flags */
 /* Data is byte-swapped */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c157717..7efcf8e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -67,10 +67,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath10k_pci_id_table) = {
 static int ath10k_pci_diag_read_access(struct ath10k *ar, u32 address,
 				       u32 *data);
 
-static int ath10k_pci_post_rx(struct ath10k *ar);
-static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
-					     int num);
-static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info);
+static void ath10k_pci_buffer_cleanup(struct ath10k *ar);
 static int ath10k_pci_cold_reset(struct ath10k *ar);
 static int ath10k_pci_warm_reset(struct ath10k *ar);
 static int ath10k_pci_wait_for_target_init(struct ath10k *ar);
@@ -278,6 +275,123 @@ static inline const char *ath10k_pci_get_irq_method(struct ath10k *ar)
 		return "legacy";
 }
 
+static int __ath10k_pci_rx_post_buf(struct ath10k_pci_pipe *pipe)
+{
+	struct ath10k *ar = pipe->hif_ce_state;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_ce_pipe *ce_pipe = pipe->ce_hdl;
+	struct sk_buff *skb;
+	dma_addr_t paddr;
+	int ret;
+
+	lockdep_assert_held(&ar_pci->ce_lock);
+
+	skb = dev_alloc_skb(pipe->buf_sz);
+	if (!skb)
+		return -ENOMEM;
+
+	WARN_ONCE((unsigned long)skb->data & 3, "unaligned skb");
+
+	paddr = dma_map_single(ar->dev, skb->data,
+			       skb->len + skb_tailroom(skb),
+			       DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(ar->dev, paddr))) {
+		ath10k_warn("failed to dma map pci rx buf\n");
+		dev_kfree_skb_any(skb);
+		return -EIO;
+	}
+
+	ATH10K_SKB_CB(skb)->paddr = paddr;
+
+	ret = __ath10k_ce_rx_post_buf(ce_pipe, skb, paddr);
+	if (ret) {
+		ath10k_warn("failed to post pci rx buf: %d\n", ret);
+		dma_unmap_single(ar->dev, paddr, skb->len + skb_tailroom(skb),
+				 DMA_FROM_DEVICE);
+		dev_kfree_skb_any(skb);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __ath10k_pci_rx_post_pipe(struct ath10k_pci_pipe *pipe)
+{
+	struct ath10k *ar = pipe->hif_ce_state;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_ce_pipe *ce_pipe = pipe->ce_hdl;
+	int ret, num;
+
+	lockdep_assert_held(&ar_pci->ce_lock);
+
+	if (pipe->buf_sz == 0)
+		return 0;
+
+	if (!ce_pipe->dest_ring)
+		return 0;
+
+	num = __ath10k_ce_rx_num_free_bufs(ce_pipe);
+	while (num--) {
+		ret = __ath10k_pci_rx_post_buf(pipe);
+		if (ret) {
+			ath10k_warn("failed to post pci rx buf: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int ath10k_pci_rx_post(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_pci_pipe *pipe;
+	int i, ret;
+
+	spin_lock_bh(&ar_pci->ce_lock);
+	for (i = 0; i < CE_COUNT; i++) {
+		pipe = &ar_pci->pipe_info[i];
+
+		ret = __ath10k_pci_rx_post_pipe(pipe);
+		if (ret) {
+			ath10k_warn("failed to post pci rx pipe %d: %d\n",
+				    i, ret);
+			break;
+		}
+	}
+	spin_unlock_bh(&ar_pci->ce_lock);
+
+	return ret;
+}
+
+static void ath10k_pci_rx_replenish(struct ath10k_pci_pipe *pipe)
+{
+	struct ath10k *ar = pipe->hif_ce_state;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int ret;
+
+	spin_lock_bh(&ar_pci->ce_lock);
+	ret = __ath10k_pci_rx_post_pipe(pipe);
+	spin_unlock_bh(&ar_pci->ce_lock);
+
+	if (ret) {
+		ath10k_warn("failed to replenish pci rx pipe %d: %d, arming retry timer\n",
+			    pipe->pipe_num, ret);
+		mod_timer(&ar_pci->rx_replenish_retry,
+			  ATH10K_PCI_RX_REPLENISH_RETRY_MS);
+	}
+}
+
+static void ath10k_pci_rx_replenish_retry(unsigned long ptr)
+{
+	struct ath10k *ar = (void *)ptr;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int i;
+
+	for (i = 0; i < CE_COUNT; i++)
+		ath10k_pci_rx_replenish(&ar_pci->pipe_info[i]);
+}
+
 /*
  * Diagnostic read/write access is provided for startup/config/debug usage.
  * Caller must guarantee proper alignment, when applicable, and single user
@@ -344,7 +458,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		nbytes = min_t(unsigned int, remaining_bytes,
 			       DIAG_TRANSFER_LIMIT);
 
-		ret = ath10k_ce_recv_buf_enqueue(ce_diag, NULL, ce_data);
+		ret = ath10k_ce_rx_post_buf(ce_diag, NULL, ce_data);
 		if (ret != 0)
 			goto done;
 
@@ -501,7 +615,7 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		nbytes = min_t(int, remaining_bytes, DIAG_TRANSFER_LIMIT);
 
 		/* Set up to receive directly into Target(!) address */
-		ret = ath10k_ce_recv_buf_enqueue(ce_diag, NULL, address);
+		ret = ath10k_ce_rx_post_buf(ce_diag, NULL, address);
 		if (ret != 0)
 			goto done;
 
@@ -663,12 +777,10 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 	unsigned int nbytes, max_nbytes;
 	unsigned int transfer_id;
 	unsigned int flags;
-	int err, num_replenish = 0;
 
 	while (ath10k_ce_completed_recv_next(ce_state, &transfer_context,
 					     &ce_data, &nbytes, &transfer_id,
 					     &flags) == 0) {
-		num_replenish++;
 		skb = transfer_context;
 		max_nbytes = skb->len + skb_tailroom(skb);
 		dma_unmap_single(ar->dev, ATH10K_SKB_CB(skb)->paddr,
@@ -685,12 +797,7 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 		cb->rx_completion(ar, skb, pipe_info->pipe_num);
 	}
 
-	err = ath10k_pci_post_rx_pipe(pipe_info, num_replenish);
-	if (unlikely(err)) {
-		/* FIXME: retry */
-		ath10k_warn("failed to replenish CE rx ring %d (%d bufs): %d\n",
-			    pipe_info->pipe_num, num_replenish, err);
-	}
+	ath10k_pci_rx_replenish(pipe_info);
 }
 
 static int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
@@ -944,94 +1051,6 @@ static void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
 						 &dl_is_polled);
 }
 
-static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
-				   int num)
-{
-	struct ath10k *ar = pipe_info->hif_ce_state;
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_ce_pipe *ce_state = pipe_info->ce_hdl;
-	struct sk_buff *skb;
-	dma_addr_t ce_data;
-	int i, ret = 0;
-
-	if (pipe_info->buf_sz == 0)
-		return 0;
-
-	for (i = 0; i < num; i++) {
-		skb = dev_alloc_skb(pipe_info->buf_sz);
-		if (!skb) {
-			ath10k_warn("failed to allocate skbuff for pipe %d\n",
-				    num);
-			ret = -ENOMEM;
-			goto err;
-		}
-
-		WARN_ONCE((unsigned long)skb->data & 3, "unaligned skb");
-
-		ce_data = dma_map_single(ar->dev, skb->data,
-					 skb->len + skb_tailroom(skb),
-					 DMA_FROM_DEVICE);
-
-		if (unlikely(dma_mapping_error(ar->dev, ce_data))) {
-			ath10k_warn("failed to DMA map sk_buff\n");
-			dev_kfree_skb_any(skb);
-			ret = -EIO;
-			goto err;
-		}
-
-		ATH10K_SKB_CB(skb)->paddr = ce_data;
-
-		pci_dma_sync_single_for_device(ar_pci->pdev, ce_data,
-					       pipe_info->buf_sz,
-					       PCI_DMA_FROMDEVICE);
-
-		ret = ath10k_ce_recv_buf_enqueue(ce_state, (void *)skb,
-						 ce_data);
-		if (ret) {
-			ath10k_warn("failed to enqueue to pipe %d: %d\n",
-				    num, ret);
-			goto err;
-		}
-	}
-
-	return ret;
-
-err:
-	ath10k_pci_rx_pipe_cleanup(pipe_info);
-	return ret;
-}
-
-static int ath10k_pci_post_rx(struct ath10k *ar)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_pci_pipe *pipe_info;
-	const struct ce_attr *attr;
-	int pipe_num, ret = 0;
-
-	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
-		pipe_info = &ar_pci->pipe_info[pipe_num];
-		attr = &host_ce_config_wlan[pipe_num];
-
-		if (attr->dest_nentries == 0)
-			continue;
-
-		ret = ath10k_pci_post_rx_pipe(pipe_info,
-					      attr->dest_nentries - 1);
-		if (ret) {
-			ath10k_warn("failed to post RX buffer for pipe %d: %d\n",
-				    pipe_num, ret);
-
-			for (; pipe_num >= 0; pipe_num--) {
-				pipe_info = &ar_pci->pipe_info[pipe_num];
-				ath10k_pci_rx_pipe_cleanup(pipe_info);
-			}
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
 static int ath10k_pci_hif_start(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1039,11 +1058,10 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif start\n");
 
-	/* Post buffers once to start things off. */
-	ret = ath10k_pci_post_rx(ar);
+	ret = ath10k_pci_rx_post(ar);
 	if (ret) {
-		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
-			    ret);
+		ath10k_warn("failed to post pci rx buffers: %d\n", ret);
+		ath10k_pci_buffer_cleanup(ar);
 		return ret;
 	}
 
@@ -1232,7 +1250,7 @@ static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 		xfer.wait_for_resp = true;
 		xfer.resp_len = 0;
 
-		ath10k_ce_recv_buf_enqueue(ce_rx, &xfer, resp_paddr);
+		ath10k_ce_rx_post_buf(ce_rx, &xfer, resp_paddr);
 	}
 
 	ret = ath10k_ce_send(ce_tx, &xfer, req_paddr, req_len, -1, 0);
@@ -2427,6 +2445,8 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ar_pci->ar = ar;
 
 	spin_lock_init(&ar_pci->ce_lock);
+	setup_timer(&ar_pci->rx_replenish_retry, ath10k_pci_rx_replenish_retry,
+		    (unsigned long)ar);
 
 	ret = ath10k_pci_claim(ar);
 	if (ret) {
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 662bca3..68fcb4f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -185,6 +185,7 @@ struct ath10k_pci {
 
 	/* Map CE id to ce_state */
 	struct ath10k_ce_pipe ce_states[CE_COUNT_MAX];
+	struct timer_list rx_replenish_retry;
 };
 
 static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
@@ -192,6 +193,7 @@ static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
 	return (struct ath10k_pci *)ar->drv_priv;
 }
 
+#define ATH10K_PCI_RX_REPLENISH_RETRY_MS 50
 #define ATH_PCI_RESET_WAIT_MAX 10 /* ms */
 #define PCIE_WAKE_TIMEOUT 5000	/* 5ms */
 
-- 
1.8.5.3

