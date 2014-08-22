Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:55671 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbaHVMnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:43:07 -0400
Received: by mail-la0-f45.google.com with SMTP id ty20so9969629lab.32
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:43:05 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/5] ath10k: rework posting pci rx buffers
Date: Fri, 22 Aug 2014 14:33:14 +0200
Message-Id: <1408710798-25198-2-git-send-email-michal.kazior@tieto.com> (sfid-20140822_144315_942875_961D0C2B)
In-Reply-To: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com>
References: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible on a host system running low on
memory to end up with no rx buffers on pci pipes.

This makes the driver more robust as it won't fail
to start if it can't allocate all rx buffers right
away. If it is fatal then upper layers will notice
trouble anyway.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * fix mod_timer() to use absolute time instead of an offset [Kalle]
     * add missing del_timer_sync()
     * ignore rx post errors in hif_start for more robustness

 drivers/net/wireless/ath/ath10k/ce.c  |  71 +++++++----
 drivers/net/wireless/ath/ath10k/ce.h  |  16 +--
 drivers/net/wireless/ath/ath10k/pci.c | 232 ++++++++++++++++------------------
 drivers/net/wireless/ath/ath10k/pci.h |   2 +
 4 files changed, 160 insertions(+), 161 deletions(-)

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
index ffb980c..21f7dc3 100644
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
@@ -278,6 +275,101 @@ static inline const char *ath10k_pci_get_irq_method(struct ath10k *ar)
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
+static void __ath10k_pci_rx_post_pipe(struct ath10k_pci_pipe *pipe)
+{
+	struct ath10k *ar = pipe->hif_ce_state;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_ce_pipe *ce_pipe = pipe->ce_hdl;
+	int ret, num;
+
+	lockdep_assert_held(&ar_pci->ce_lock);
+
+	if (pipe->buf_sz == 0)
+		return;
+
+	if (!ce_pipe->dest_ring)
+		return;
+
+	num = __ath10k_ce_rx_num_free_bufs(ce_pipe);
+	while (num--) {
+		ret = __ath10k_pci_rx_post_buf(pipe);
+		if (ret) {
+			ath10k_warn("failed to post pci rx buf: %d\n", ret);
+			mod_timer(&ar_pci->rx_post_retry, jiffies +
+				  ATH10K_PCI_RX_POST_RETRY_MS);
+			break;
+		}
+	}
+}
+
+static void ath10k_pci_rx_post_pipe(struct ath10k_pci_pipe *pipe)
+{
+	struct ath10k *ar = pipe->hif_ce_state;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	spin_lock_bh(&ar_pci->ce_lock);
+	__ath10k_pci_rx_post_pipe(pipe);
+	spin_unlock_bh(&ar_pci->ce_lock);
+}
+
+static void ath10k_pci_rx_post(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int i;
+
+	spin_lock_bh(&ar_pci->ce_lock);
+	for (i = 0; i < CE_COUNT; i++)
+		__ath10k_pci_rx_post_pipe(&ar_pci->pipe_info[i]);
+	spin_unlock_bh(&ar_pci->ce_lock);
+}
+
+static void ath10k_pci_rx_replenish_retry(unsigned long ptr)
+{
+	struct ath10k *ar = (void *)ptr;
+
+	ath10k_pci_rx_post(ar);
+}
+
 /*
  * Diagnostic read/write access is provided for startup/config/debug usage.
  * Caller must guarantee proper alignment, when applicable, and single user
@@ -344,7 +436,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		nbytes = min_t(unsigned int, remaining_bytes,
 			       DIAG_TRANSFER_LIMIT);
 
-		ret = ath10k_ce_recv_buf_enqueue(ce_diag, NULL, ce_data);
+		ret = ath10k_ce_rx_post_buf(ce_diag, NULL, ce_data);
 		if (ret != 0)
 			goto done;
 
@@ -534,7 +626,7 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		nbytes = min_t(int, remaining_bytes, DIAG_TRANSFER_LIMIT);
 
 		/* Set up to receive directly into Target(!) address */
-		ret = ath10k_ce_recv_buf_enqueue(ce_diag, NULL, address);
+		ret = ath10k_ce_rx_post_buf(ce_diag, NULL, address);
 		if (ret != 0)
 			goto done;
 
@@ -696,12 +788,10 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
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
@@ -718,12 +808,7 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 		cb->rx_completion(ar, skb, pipe_info->pipe_num);
 	}
 
-	err = ath10k_pci_post_rx_pipe(pipe_info, num_replenish);
-	if (unlikely(err)) {
-		/* FIXME: retry */
-		ath10k_warn("failed to replenish CE rx ring %d (%d bufs): %d\n",
-			    pipe_info->pipe_num, num_replenish, err);
-	}
+	ath10k_pci_rx_post_pipe(pipe_info);
 }
 
 static int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
@@ -911,6 +996,8 @@ static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 
 	for (i = 0; i < CE_COUNT; i++)
 		tasklet_kill(&ar_pci->pipe_info[i].intr);
+
+	del_timer_sync(&ar_pci->rx_post_retry);
 }
 
 /* TODO - temporary mapping while we have too few CE's */
@@ -992,94 +1079,6 @@ static void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
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
 static void ath10k_pci_irq_disable(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1117,28 +1116,14 @@ static void ath10k_pci_irq_enable(struct ath10k *ar)
 static int ath10k_pci_hif_start(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int ret;
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot hif start\n");
 
 	ath10k_pci_irq_enable(ar);
-
-	/* Post buffers once to start things off. */
-	ret = ath10k_pci_post_rx(ar);
-	if (ret) {
-		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
-			    ret);
-		goto err_stop;
-	}
+	ath10k_pci_rx_post(ar);
 
 	ar_pci->started = 1;
 	return 0;
-
-err_stop:
-	ath10k_pci_irq_disable(ar);
-	ath10k_pci_kill_tasklet(ar);
-
-	return ret;
 }
 
 static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
@@ -1240,6 +1225,12 @@ static void ath10k_pci_ce_deinit(struct ath10k *ar)
 		ath10k_ce_deinit_pipe(ar, i);
 }
 
+static void ath10k_pci_flush(struct ath10k *ar)
+{
+	ath10k_pci_kill_tasklet(ar);
+	ath10k_pci_buffer_cleanup(ar);
+}
+
 static void ath10k_pci_hif_stop(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1250,8 +1241,7 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 		return;
 
 	ath10k_pci_irq_disable(ar);
-	ath10k_pci_kill_tasklet(ar);
-	ath10k_pci_buffer_cleanup(ar);
+	ath10k_pci_flush(ar);
 
 	/* Make the sure the device won't access any structures on the host by
 	 * resetting it. The device was fed with PCI CE ringbuffer
@@ -1311,7 +1301,7 @@ static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 		xfer.wait_for_resp = true;
 		xfer.resp_len = 0;
 
-		ath10k_ce_recv_buf_enqueue(ce_rx, &xfer, resp_paddr);
+		ath10k_ce_rx_post_buf(ce_rx, &xfer, resp_paddr);
 	}
 
 	ret = ath10k_ce_send(ce_tx, &xfer, req_paddr, req_len, -1, 0);
@@ -2513,6 +2503,8 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ar_pci->ar = ar;
 
 	spin_lock_init(&ar_pci->ce_lock);
+	setup_timer(&ar_pci->rx_post_retry, ath10k_pci_rx_replenish_retry,
+		    (unsigned long)ar);
 
 	ret = ath10k_pci_claim(ar);
 	if (ret) {
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index caed918..b9aa692 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -181,6 +181,7 @@ struct ath10k_pci {
 
 	/* Map CE id to ce_state */
 	struct ath10k_ce_pipe ce_states[CE_COUNT_MAX];
+	struct timer_list rx_post_retry;
 };
 
 static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
@@ -188,6 +189,7 @@ static inline struct ath10k_pci *ath10k_pci_priv(struct ath10k *ar)
 	return (struct ath10k_pci *)ar->drv_priv;
 }
 
+#define ATH10K_PCI_RX_POST_RETRY_MS 50
 #define ATH_PCI_RESET_WAIT_MAX 10 /* ms */
 #define PCIE_WAKE_TIMEOUT 5000	/* 5ms */
 
-- 
1.8.5.3

