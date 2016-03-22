Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52650 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbcCVLyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 07:54:31 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 8/9] ath10k: reuse copy engine 5 (htt rx) descriptors
Date: Tue, 22 Mar 2016 17:22:18 +0530
Message-ID: <1458647539-17213-9-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160322_125434_124845_BB41C88D)
In-Reply-To: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever htt rx indication i.e target to host messages are received
on rx copy engine (CE5), the message will be freed after processing
the response. Then CE 5 will be refilled with new descriptors at
post rx processing. This memory alloc and free operations can be avoided
by reusing the same descriptors.

During CE pipe allocation, full ring is not initialized i.e n-1 entries
are filled up. So for CE 5 full ring should be filled up to reuse
descriptors. Moreover CE 5 write index will be updated in single shot
instead of incremental access. This could avoid multiple pci_write and
ce_ring access. From experiments, It improves CPU usage by ~3% in IPQ4019
platform.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 23 +++++++++++--
 drivers/net/wireless/ath/ath10k/ce.h  |  3 ++
 drivers/net/wireless/ath/ath10k/pci.c | 63 +++++++++++++++++++++++++++++++++--
 3 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index d6da404..7212802 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -411,7 +411,8 @@ int __ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr)
 
 	lockdep_assert_held(&ar_pci->ce_lock);
 
-	if (CE_RING_DELTA(nentries_mask, write_index, sw_index - 1) == 0)
+	if ((pipe->id != 5) &&
+	    CE_RING_DELTA(nentries_mask, write_index, sw_index - 1) == 0)
 		return -ENOSPC;
 
 	desc->addr = __cpu_to_le32(paddr);
@@ -425,6 +426,19 @@ int __ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr)
 	return 0;
 }
 
+void ath10k_ce_rx_update_write_idx(struct ath10k_ce_pipe *pipe, u32 nentries)
+{
+	struct ath10k *ar = pipe->ar;
+	struct ath10k_ce_ring *dest_ring = pipe->dest_ring;
+	unsigned int nentries_mask = dest_ring->nentries_mask;
+	unsigned int write_index = dest_ring->write_index;
+	u32 ctrl_addr = pipe->ctrl_addr;
+
+	write_index = CE_RING_IDX_ADD(nentries_mask, write_index, nentries);
+	ath10k_ce_dest_ring_write_index_set(ar, ctrl_addr, write_index);
+	dest_ring->write_index = write_index;
+}
+
 int ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr)
 {
 	struct ath10k *ar = pipe->ar;
@@ -478,8 +492,11 @@ int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
 		*per_transfer_contextp =
 			dest_ring->per_transfer_context[sw_index];
 
-	/* sanity */
-	dest_ring->per_transfer_context[sw_index] = NULL;
+	/* Copy engine 5 (HTT Rx) will reuse the same transfer context.
+	 * So update transfer context all CEs except CE5.
+	 */
+	if (ce_state->id != 5)
+		dest_ring->per_transfer_context[sw_index] = NULL;
 
 	/* Update sw_index */
 	sw_index = CE_RING_IDX_INCR(nentries_mask, sw_index);
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 68717e5..25cafcf 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -166,6 +166,7 @@ int ath10k_ce_num_free_src_entries(struct ath10k_ce_pipe *pipe);
 int __ath10k_ce_rx_num_free_bufs(struct ath10k_ce_pipe *pipe);
 int __ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr);
 int ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr);
+void ath10k_ce_rx_update_write_idx(struct ath10k_ce_pipe *pipe, u32 nentries);
 
 /* recv flags */
 /* Data is byte-swapped */
@@ -410,6 +411,8 @@ static inline u32 ath10k_ce_base_address(struct ath10k *ar, unsigned int ce_id)
 	(((int)(toidx)-(int)(fromidx)) & (nentries_mask))
 
 #define CE_RING_IDX_INCR(nentries_mask, idx) (((idx) + 1) & (nentries_mask))
+#define CE_RING_IDX_ADD(nentries_mask, idx, num) \
+		(((idx) + (num)) & (nentries_mask))
 
 #define CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_LSB \
 				ar->regs->ce_wrap_intr_sum_host_msi_lsb
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 290a61a..0b305ef 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -809,7 +809,8 @@ static void ath10k_pci_rx_post_pipe(struct ath10k_pci_pipe *pipe)
 	spin_lock_bh(&ar_pci->ce_lock);
 	num = __ath10k_ce_rx_num_free_bufs(ce_pipe);
 	spin_unlock_bh(&ar_pci->ce_lock);
-	while (num--) {
+
+	while (num >= 0) {
 		ret = __ath10k_pci_rx_post_buf(pipe);
 		if (ret) {
 			if (ret == -ENOSPC)
@@ -819,6 +820,7 @@ static void ath10k_pci_rx_post_pipe(struct ath10k_pci_pipe *pipe)
 				  ATH10K_PCI_RX_POST_RETRY_MS);
 			break;
 		}
+		num--;
 	}
 }
 
@@ -1212,6 +1214,63 @@ static void ath10k_pci_process_rx_cb(struct ath10k_ce_pipe *ce_state,
 	ath10k_pci_rx_post_pipe(pipe_info);
 }
 
+static void ath10k_pci_process_htt_rx_cb(struct ath10k_ce_pipe *ce_state,
+					 void (*callback)(struct ath10k *ar,
+							  struct sk_buff *skb))
+{
+	struct ath10k *ar = ce_state->ar;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_pci_pipe *pipe_info =  &ar_pci->pipe_info[ce_state->id];
+	struct ath10k_ce_pipe *ce_pipe = pipe_info->ce_hdl;
+	struct sk_buff *skb;
+	struct sk_buff_head list;
+	void *transfer_context;
+	unsigned int nbytes, max_nbytes, nentries;
+	int orig_len;
+
+	/* No need to aquire ce_lock for CE5, since this is the only place CE5
+	 * is processed other than init and deinit. Before releasing CE5
+	 * buffers, interrupts are disabled. Thus CE5 access is serialized.
+	 */
+	__skb_queue_head_init(&list);
+	while (ath10k_ce_completed_recv_next_nolock(ce_state, &transfer_context,
+						    &nbytes) == 0) {
+		skb = transfer_context;
+		max_nbytes = skb->len + skb_tailroom(skb);
+
+		if (unlikely(max_nbytes < nbytes)) {
+			ath10k_warn(ar, "rxed more than expected (nbytes %d, max %d)",
+				    nbytes, max_nbytes);
+			continue;
+		}
+
+		dma_sync_single_for_cpu(ar->dev, ATH10K_SKB_RXCB(skb)->paddr,
+					max_nbytes, DMA_FROM_DEVICE);
+		skb_put(skb, nbytes);
+		__skb_queue_tail(&list, skb);
+	}
+
+	nentries = skb_queue_len(&list);
+	while ((skb = __skb_dequeue(&list))) {
+		ath10k_dbg(ar, ATH10K_DBG_PCI, "pci rx ce pipe %d len %d\n",
+			   ce_state->id, skb->len);
+		ath10k_dbg_dump(ar, ATH10K_DBG_PCI_DUMP, NULL, "pci rx: ",
+				skb->data, skb->len);
+
+		orig_len = skb->len;
+		callback(ar, skb);
+		skb_push(skb, orig_len - skb->len);
+		skb_reset_tail_pointer(skb);
+		skb_trim(skb, 0);
+
+		/*let device gain the buffer again*/
+		dma_sync_single_for_device(ar->dev, ATH10K_SKB_RXCB(skb)->paddr,
+					   skb->len + skb_tailroom(skb),
+					   DMA_FROM_DEVICE);
+	}
+	ath10k_ce_rx_update_write_idx(ce_pipe, nentries);
+}
+
 /* Called by lower (CE) layer when data is received from the Target. */
 static void ath10k_pci_htc_rx_cb(struct ath10k_ce_pipe *ce_state)
 {
@@ -1268,7 +1327,7 @@ static void ath10k_pci_htt_rx_cb(struct ath10k_ce_pipe *ce_state)
 	 */
 	ath10k_ce_per_engine_service(ce_state->ar, 4);
 
-	ath10k_pci_process_rx_cb(ce_state, ath10k_pci_htt_rx_deliver);
+	ath10k_pci_process_htt_rx_cb(ce_state, ath10k_pci_htt_rx_deliver);
 }
 
 int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
-- 
2.7.4

