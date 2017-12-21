Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37114 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbdLUJBy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 04:01:54 -0500
From: Govind Singh <govinds@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@qti.qualcomm.com>
Subject: [PATCH 09/10] ath10k: Use dma_addr_t for ce buffers to support 64bit target
Date: Thu, 21 Dec 2017 14:30:58 +0530
Message-Id: <1513846859-23639-10-git-send-email-govinds@qti.qualcomm.com> (sfid-20171221_100205_021681_81DACD97)
In-Reply-To: <1513846859-23639-1-git-send-email-govinds@qti.qualcomm.com>
References: <1513846859-23639-1-git-send-email-govinds@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CE send and receive API's are using u32 ring address, which
truncates the address for target with 64bit addressing range.
Use dma_addr_t for ce buffers to support target with extended
addressing range.

Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 14 ++++++++------
 drivers/net/wireless/ath/ath10k/ce.h  | 14 ++++++++------
 drivers/net/wireless/ath/ath10k/pci.c |  4 ++--
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index a8afd69..9aa214b 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -329,7 +329,7 @@ static inline void ath10k_ce_engine_int_status_clear(struct ath10k *ar,
  */
 int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 			  void *per_transfer_context,
-			  u32 buffer,
+			  dma_addr_t buffer,
 			  unsigned int nbytes,
 			  unsigned int transfer_id,
 			  unsigned int flags)
@@ -413,7 +413,7 @@ void __ath10k_ce_send_revert(struct ath10k_ce_pipe *pipe)
 
 int ath10k_ce_send(struct ath10k_ce_pipe *ce_state,
 		   void *per_transfer_context,
-		   u32 buffer,
+		    dma_addr_t buffer,
 		   unsigned int nbytes,
 		   unsigned int transfer_id,
 		   unsigned int flags)
@@ -459,7 +459,8 @@ int __ath10k_ce_rx_num_free_bufs(struct ath10k_ce_pipe *pipe)
 	return CE_RING_DELTA(nentries_mask, write_index, sw_index - 1);
 }
 
-int __ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr)
+int __ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx,
+			    dma_addr_t paddr)
 {
 	struct ath10k *ar = pipe->ar;
 	struct ath10k_ce *ce = ath10k_ce_priv(ar);
@@ -508,7 +509,8 @@ void ath10k_ce_rx_update_write_idx(struct ath10k_ce_pipe *pipe, u32 nentries)
 	dest_ring->write_index = write_index;
 }
 
-int ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr)
+int ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx,
+			  dma_addr_t paddr)
 {
 	struct ath10k *ar = pipe->ar;
 	struct ath10k_ce *ce = ath10k_ce_priv(ar);
@@ -593,7 +595,7 @@ int ath10k_ce_completed_recv_next(struct ath10k_ce_pipe *ce_state,
 
 int ath10k_ce_revoke_recv_next(struct ath10k_ce_pipe *ce_state,
 			       void **per_transfer_contextp,
-			       u32 *bufferp)
+			       dma_addr_t *bufferp)
 {
 	struct ath10k_ce_ring *dest_ring;
 	unsigned int nentries_mask;
@@ -701,7 +703,7 @@ int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 /* NB: Modeled after ath10k_ce_completed_send_next */
 int ath10k_ce_cancel_send_next(struct ath10k_ce_pipe *ce_state,
 			       void **per_transfer_contextp,
-			       u32 *bufferp,
+			       dma_addr_t *bufferp,
 			       unsigned int *nbytesp,
 			       unsigned int *transfer_idp)
 {
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index bdec794..f36ad51 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -160,7 +160,7 @@ struct ath10k_ce {
  */
 int ath10k_ce_send(struct ath10k_ce_pipe *ce_state,
 		   void *per_transfer_send_context,
-		   u32 buffer,
+		   dma_addr_t buffer,
 		   unsigned int nbytes,
 		   /* 14 bits */
 		   unsigned int transfer_id,
@@ -168,7 +168,7 @@ int ath10k_ce_send(struct ath10k_ce_pipe *ce_state,
 
 int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 			  void *per_transfer_context,
-			  u32 buffer,
+			  dma_addr_t buffer,
 			  unsigned int nbytes,
 			  unsigned int transfer_id,
 			  unsigned int flags);
@@ -180,8 +180,10 @@ int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 /*==================Recv=======================*/
 
 int __ath10k_ce_rx_num_free_bufs(struct ath10k_ce_pipe *pipe);
-int __ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr);
-int ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr);
+int __ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx,
+			    dma_addr_t paddr);
+int ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx,
+			  dma_addr_t paddr);
 void ath10k_ce_rx_update_write_idx(struct ath10k_ce_pipe *pipe, u32 nentries);
 
 /* recv flags */
@@ -222,7 +224,7 @@ int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
  */
 int ath10k_ce_revoke_recv_next(struct ath10k_ce_pipe *ce_state,
 			       void **per_transfer_contextp,
-			       u32 *bufferp);
+			       dma_addr_t *bufferp);
 
 int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
 					 void **per_transfer_contextp,
@@ -235,7 +237,7 @@ int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
  */
 int ath10k_ce_cancel_send_next(struct ath10k_ce_pipe *ce_state,
 			       void **per_transfer_contextp,
-			       u32 *bufferp,
+			       dma_addr_t *bufferp,
 			       unsigned int *nbytesp,
 			       unsigned int *transfer_idp);
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index ffea348..4e3e7a8 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1858,7 +1858,7 @@ int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 
 	ret = ath10k_pci_bmi_wait(ar, ce_tx, ce_rx, &xfer);
 	if (ret) {
-		u32 unused_buffer;
+		dma_addr_t unused_buffer;
 		unsigned int unused_nbytes;
 		unsigned int unused_id;
 
@@ -1871,7 +1871,7 @@ int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 
 err_resp:
 	if (resp) {
-		u32 unused_buffer;
+		dma_addr_t unused_buffer;
 
 		ath10k_ce_revoke_recv_next(ce_rx, NULL, &unused_buffer);
 		dma_unmap_single(ar->dev, resp_paddr,
-- 
1.9.1
