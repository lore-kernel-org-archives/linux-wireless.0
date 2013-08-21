Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:60603 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab3HUG5h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:57:37 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/6] ath10k: rename ce_state to ath10k_ce_pipe
Date: Wed, 21 Aug 2013 08:57:28 +0200
Message-ID: <1377068249-26025-6-git-send-email-michal.kazior@tieto.com> (sfid-20130821_085742_486700_1282A311)
In-Reply-To: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
References: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new naming makes more sense.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |   48 ++++++++++++++++-----------------
 drivers/net/wireless/ath/ath10k/ce.h  |   35 ++++++++++++------------
 drivers/net/wireless/ath/ath10k/pci.c |   26 +++++++++---------
 drivers/net/wireless/ath/ath10k/pci.h |    8 +++---
 4 files changed, 58 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index c391f46..112897b 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -256,7 +256,7 @@ static inline void ath10k_ce_engine_int_status_clear(struct ath10k *ar,
  * ath10k_ce_sendlist_send.
  * The caller takes responsibility for any needed locking.
  */
-static int ath10k_ce_send_nolock(struct ce_state *ce_state,
+static int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 				 void *per_transfer_context,
 				 u32 buffer,
 				 unsigned int nbytes,
@@ -317,7 +317,7 @@ exit:
 	return ret;
 }
 
-int ath10k_ce_send(struct ce_state *ce_state,
+int ath10k_ce_send(struct ath10k_ce_pipe *ce_state,
 		   void *per_transfer_context,
 		   u32 buffer,
 		   unsigned int nbytes,
@@ -349,7 +349,7 @@ void ath10k_ce_sendlist_buf_add(struct ce_sendlist *sendlist, u32 buffer,
 	sendlist->num_items++;
 }
 
-int ath10k_ce_sendlist_send(struct ce_state *ce_state,
+int ath10k_ce_sendlist_send(struct ath10k_ce_pipe *ce_state,
 			    void *per_transfer_context,
 			    struct ce_sendlist *sendlist,
 			    unsigned int transfer_id)
@@ -402,7 +402,7 @@ int ath10k_ce_sendlist_send(struct ce_state *ce_state,
 	return ret;
 }
 
-int ath10k_ce_recv_buf_enqueue(struct ce_state *ce_state,
+int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
 			       void *per_recv_context,
 			       u32 buffer)
 {
@@ -450,7 +450,7 @@ int ath10k_ce_recv_buf_enqueue(struct ce_state *ce_state,
  * Guts of ath10k_ce_completed_recv_next.
  * The caller takes responsibility for any necessary locking.
  */
-static int ath10k_ce_completed_recv_next_nolock(struct ce_state *ce_state,
+static int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
 						void **per_transfer_contextp,
 						u32 *bufferp,
 						unsigned int *nbytesp,
@@ -506,7 +506,7 @@ static int ath10k_ce_completed_recv_next_nolock(struct ce_state *ce_state,
 	return 0;
 }
 
-int ath10k_ce_completed_recv_next(struct ce_state *ce_state,
+int ath10k_ce_completed_recv_next(struct ath10k_ce_pipe *ce_state,
 				  void **per_transfer_contextp,
 				  u32 *bufferp,
 				  unsigned int *nbytesp,
@@ -527,7 +527,7 @@ int ath10k_ce_completed_recv_next(struct ce_state *ce_state,
 	return ret;
 }
 
-int ath10k_ce_revoke_recv_next(struct ce_state *ce_state,
+int ath10k_ce_revoke_recv_next(struct ath10k_ce_pipe *ce_state,
 			       void **per_transfer_contextp,
 			       u32 *bufferp)
 {
@@ -583,7 +583,7 @@ int ath10k_ce_revoke_recv_next(struct ce_state *ce_state,
  * Guts of ath10k_ce_completed_send_next.
  * The caller takes responsibility for any necessary locking.
  */
-static int ath10k_ce_completed_send_next_nolock(struct ce_state *ce_state,
+static int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 						void **per_transfer_contextp,
 						u32 *bufferp,
 						unsigned int *nbytesp,
@@ -640,7 +640,7 @@ static int ath10k_ce_completed_send_next_nolock(struct ce_state *ce_state,
 }
 
 /* NB: Modeled after ath10k_ce_completed_send_next */
-int ath10k_ce_cancel_send_next(struct ce_state *ce_state,
+int ath10k_ce_cancel_send_next(struct ath10k_ce_pipe *ce_state,
 			       void **per_transfer_contextp,
 			       u32 *bufferp,
 			       unsigned int *nbytesp,
@@ -698,7 +698,7 @@ int ath10k_ce_cancel_send_next(struct ce_state *ce_state,
 	return ret;
 }
 
-int ath10k_ce_completed_send_next(struct ce_state *ce_state,
+int ath10k_ce_completed_send_next(struct ath10k_ce_pipe *ce_state,
 				  void **per_transfer_contextp,
 				  u32 *bufferp,
 				  unsigned int *nbytesp,
@@ -727,7 +727,7 @@ int ath10k_ce_completed_send_next(struct ce_state *ce_state,
 void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ce_state *ce_state = &ar_pci->ce_states[ce_id];
+	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
 	u32 ctrl_addr = ce_state->ctrl_addr;
 	void *transfer_context;
 	u32 buf;
@@ -820,7 +820,7 @@ void ath10k_ce_per_engine_service_any(struct ath10k *ar)
  *
  * Called with ce_lock held.
  */
-static void ath10k_ce_per_engine_handler_adjust(struct ce_state *ce_state,
+static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state,
 						int disable_copy_compl_intr)
 {
 	u32 ctrl_addr = ce_state->ctrl_addr;
@@ -846,7 +846,7 @@ void ath10k_ce_disable_interrupts(struct ath10k *ar)
 
 	ath10k_pci_wake(ar);
 	for (ce_id = 0; ce_id < ar_pci->ce_count; ce_id++) {
-		struct ce_state *ce_state = &ar_pci->ce_states[ce_id];
+		struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
 		u32 ctrl_addr = ce_state->ctrl_addr;
 
 		ath10k_ce_copy_complete_intr_disable(ar, ctrl_addr);
@@ -854,8 +854,8 @@ void ath10k_ce_disable_interrupts(struct ath10k *ar)
 	ath10k_pci_sleep(ar);
 }
 
-void ath10k_ce_send_cb_register(struct ce_state *ce_state,
-				void (*send_cb) (struct ce_state *ce_state,
+void ath10k_ce_send_cb_register(struct ath10k_ce_pipe *ce_state,
+				void (*send_cb) (struct ath10k_ce_pipe *ce_state,
 						 void *transfer_context,
 						 u32 buffer,
 						 unsigned int nbytes,
@@ -871,8 +871,8 @@ void ath10k_ce_send_cb_register(struct ce_state *ce_state,
 	spin_unlock_bh(&ar_pci->ce_lock);
 }
 
-void ath10k_ce_recv_cb_register(struct ce_state *ce_state,
-				void (*recv_cb) (struct ce_state *ce_state,
+void ath10k_ce_recv_cb_register(struct ath10k_ce_pipe *ce_state,
+				void (*recv_cb) (struct ath10k_ce_pipe *ce_state,
 						 void *transfer_context,
 						 u32 buffer,
 						 unsigned int nbytes,
@@ -890,7 +890,7 @@ void ath10k_ce_recv_cb_register(struct ce_state *ce_state,
 
 static int ath10k_ce_init_src_ring(struct ath10k *ar,
 				   unsigned int ce_id,
-				   struct ce_state *ce_state,
+				   struct ath10k_ce_pipe *ce_state,
 				   const struct ce_attr *attr)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -993,7 +993,7 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 
 static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 				    unsigned int ce_id,
-				    struct ce_state *ce_state,
+				    struct ath10k_ce_pipe *ce_state,
 				    const struct ce_attr *attr)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1076,12 +1076,12 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 	return 0;
 }
 
-static struct ce_state *ath10k_ce_init_state(struct ath10k *ar,
+static struct ath10k_ce_pipe *ath10k_ce_init_state(struct ath10k *ar,
 					     unsigned int ce_id,
 					     const struct ce_attr *attr)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ce_state *ce_state = &ar_pci->ce_states[ce_id];
+	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
 	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
 
 	spin_lock_bh(&ar_pci->ce_lock);
@@ -1104,11 +1104,11 @@ static struct ce_state *ath10k_ce_init_state(struct ath10k *ar,
  * initialization. It may be that only one side or the other is
  * initialized by software/firmware.
  */
-struct ce_state *ath10k_ce_init(struct ath10k *ar,
+struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
 				unsigned int ce_id,
 				const struct ce_attr *attr)
 {
-	struct ce_state *ce_state;
+	struct ath10k_ce_pipe *ce_state;
 	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
 	int ret;
 
@@ -1146,7 +1146,7 @@ struct ce_state *ath10k_ce_init(struct ath10k *ar,
 	return ce_state;
 }
 
-void ath10k_ce_deinit(struct ce_state *ce_state)
+void ath10k_ce_deinit(struct ath10k_ce_pipe *ce_state)
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index ce4cbbf..1267b49 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -36,7 +36,7 @@
  * how to use copy engines.
  */
 
-struct ce_state;
+struct ath10k_ce_pipe;
 
 
 #define CE_DESC_FLAGS_GATHER         (1 << 0)
@@ -109,8 +109,7 @@ struct ce_ring_state {
 	void **per_transfer_context;
 };
 
-/* Copy Engine internal state */
-struct ce_state {
+struct ath10k_ce_pipe {
 	struct ath10k *ar;
 	unsigned int id;
 
@@ -118,12 +117,12 @@ struct ce_state {
 
 	u32 ctrl_addr;
 
-	void (*send_cb) (struct ce_state *ce_state,
+	void (*send_cb) (struct ath10k_ce_pipe *ce_state,
 			 void *per_transfer_send_context,
 			 u32 buffer,
 			 unsigned int nbytes,
 			 unsigned int transfer_id);
-	void (*recv_cb) (struct ce_state *ce_state,
+	void (*recv_cb) (struct ath10k_ce_pipe *ce_state,
 			 void *per_transfer_recv_context,
 			 u32 buffer,
 			 unsigned int nbytes,
@@ -174,7 +173,7 @@ struct ce_attr;
  *
  * Implementation note: pushes 1 buffer to Source ring
  */
-int ath10k_ce_send(struct ce_state *ce_state,
+int ath10k_ce_send(struct ath10k_ce_pipe *ce_state,
 		   void *per_transfer_send_context,
 		   u32 buffer,
 		   unsigned int nbytes,
@@ -182,8 +181,8 @@ int ath10k_ce_send(struct ce_state *ce_state,
 		   unsigned int transfer_id,
 		   unsigned int flags);
 
-void ath10k_ce_send_cb_register(struct ce_state *ce_state,
-				void (*send_cb) (struct ce_state *ce_state,
+void ath10k_ce_send_cb_register(struct ath10k_ce_pipe *ce_state,
+				void (*send_cb) (struct ath10k_ce_pipe *ce_state,
 						 void *transfer_context,
 						 u32 buffer,
 						 unsigned int nbytes,
@@ -207,7 +206,7 @@ void ath10k_ce_sendlist_buf_add(struct ce_sendlist *sendlist,
  *
  * Implemenation note: Pushes multiple buffers with Gather to Source ring.
  */
-int ath10k_ce_sendlist_send(struct ce_state *ce_state,
+int ath10k_ce_sendlist_send(struct ath10k_ce_pipe *ce_state,
 			    void *per_transfer_send_context,
 			    struct ce_sendlist *sendlist,
 			    /* 14 bits */
@@ -225,12 +224,12 @@ int ath10k_ce_sendlist_send(struct ce_state *ce_state,
  *
  * Implemenation note: Pushes a buffer to Dest ring.
  */
-int ath10k_ce_recv_buf_enqueue(struct ce_state *ce_state,
+int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
 			       void *per_transfer_recv_context,
 			       u32 buffer);
 
-void ath10k_ce_recv_cb_register(struct ce_state *ce_state,
-				void (*recv_cb) (struct ce_state *ce_state,
+void ath10k_ce_recv_cb_register(struct ath10k_ce_pipe *ce_state,
+				void (*recv_cb) (struct ath10k_ce_pipe *ce_state,
 						 void *transfer_context,
 						 u32 buffer,
 						 unsigned int nbytes,
@@ -245,7 +244,7 @@ void ath10k_ce_recv_cb_register(struct ce_state *ce_state,
  * Supply data for the next completed unprocessed receive descriptor.
  * Pops buffer from Dest ring.
  */
-int ath10k_ce_completed_recv_next(struct ce_state *ce_state,
+int ath10k_ce_completed_recv_next(struct ath10k_ce_pipe *ce_state,
 				  void **per_transfer_contextp,
 				  u32 *bufferp,
 				  unsigned int *nbytesp,
@@ -255,7 +254,7 @@ int ath10k_ce_completed_recv_next(struct ce_state *ce_state,
  * Supply data for the next completed unprocessed send descriptor.
  * Pops 1 completed send buffer from Source ring.
  */
-int ath10k_ce_completed_send_next(struct ce_state *ce_state,
+int ath10k_ce_completed_send_next(struct ath10k_ce_pipe *ce_state,
 			   void **per_transfer_contextp,
 			   u32 *bufferp,
 			   unsigned int *nbytesp,
@@ -264,7 +263,7 @@ int ath10k_ce_completed_send_next(struct ce_state *ce_state,
 /*==================CE Engine Initialization=======================*/
 
 /* Initialize an instance of a CE */
-struct ce_state *ath10k_ce_init(struct ath10k *ar,
+struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
 				unsigned int ce_id,
 				const struct ce_attr *attr);
 
@@ -274,7 +273,7 @@ struct ce_state *ath10k_ce_init(struct ath10k *ar,
  * receive buffers.  Target DMA must be stopped before using
  * this API.
  */
-int ath10k_ce_revoke_recv_next(struct ce_state *ce_state,
+int ath10k_ce_revoke_recv_next(struct ath10k_ce_pipe *ce_state,
 			       void **per_transfer_contextp,
 			       u32 *bufferp);
 
@@ -283,13 +282,13 @@ int ath10k_ce_revoke_recv_next(struct ce_state *ce_state,
  * pending sends.  Target DMA must be stopped before using
  * this API.
  */
-int ath10k_ce_cancel_send_next(struct ce_state *ce_state,
+int ath10k_ce_cancel_send_next(struct ath10k_ce_pipe *ce_state,
 			       void **per_transfer_contextp,
 			       u32 *bufferp,
 			       unsigned int *nbytesp,
 			       unsigned int *transfer_idp);
 
-void ath10k_ce_deinit(struct ce_state *ce_state);
+void ath10k_ce_deinit(struct ath10k_ce_pipe *ce_state);
 
 /*==================CE Interrupt Handlers====================*/
 void ath10k_ce_per_engine_service_any(struct ath10k *ar);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index b740960..e29213b 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -112,7 +112,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 	unsigned int completed_nbytes, orig_nbytes, remaining_bytes;
 	unsigned int id;
 	unsigned int flags;
-	struct ce_state *ce_diag;
+	struct ath10k_ce_pipe *ce_diag;
 	/* Host buffer address in CE space */
 	u32 ce_data;
 	dma_addr_t ce_data_base = 0;
@@ -276,7 +276,7 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	unsigned int completed_nbytes, orig_nbytes, remaining_bytes;
 	unsigned int id;
 	unsigned int flags;
-	struct ce_state *ce_diag;
+	struct ath10k_ce_pipe *ce_diag;
 	void *data_buf = NULL;
 	u32 ce_data;	/* Host buffer address in CE space */
 	dma_addr_t ce_data_base = 0;
@@ -509,7 +509,7 @@ exit:
 }
 
 /* Called by lower (CE) layer when a send to Target completes. */
-static void ath10k_pci_ce_send_done(struct ce_state *ce_state,
+static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state,
 				    void *transfer_context,
 				    u32 ce_data,
 				    unsigned int nbytes,
@@ -571,7 +571,7 @@ static void ath10k_pci_ce_send_done(struct ce_state *ce_state,
 }
 
 /* Called by lower (CE) layer when data is received from the Target. */
-static void ath10k_pci_ce_recv_data(struct ce_state *ce_state,
+static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state,
 				    void *transfer_context, u32 ce_data,
 				    unsigned int nbytes,
 				    unsigned int transfer_id,
@@ -624,7 +624,7 @@ static int ath10k_pci_hif_send_head(struct ath10k *ar, u8 pipe_id,
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(nbuf);
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_pipe *pipe_info = &(ar_pci->pipe_info[pipe_id]);
-	struct ce_state *ce_hdl = pipe_info->ce_hdl;
+	struct ath10k_ce_pipe *ce_hdl = pipe_info->ce_hdl;
 	struct ce_sendlist sendlist;
 	unsigned int len;
 	u32 flags = 0;
@@ -762,7 +762,7 @@ static void ath10k_pci_hif_set_callbacks(struct ath10k *ar,
 static int ath10k_pci_start_ce(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ce_state *ce_diag = ar_pci->ce_diag;
+	struct ath10k_ce_pipe *ce_diag = ar_pci->ce_diag;
 	const struct ce_attr *attr;
 	struct ath10k_pci_pipe *pipe_info;
 	struct ath10k_pci_compl *compl;
@@ -1049,7 +1049,7 @@ static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 {
 	struct ath10k *ar = pipe_info->hif_ce_state;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ce_state *ce_state = pipe_info->ce_hdl;
+	struct ath10k_ce_pipe *ce_state = pipe_info->ce_hdl;
 	struct sk_buff *skb;
 	dma_addr_t ce_data;
 	int i, ret = 0;
@@ -1158,7 +1158,7 @@ static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
 {
 	struct ath10k *ar;
 	struct ath10k_pci *ar_pci;
-	struct ce_state *ce_hdl;
+	struct ath10k_ce_pipe *ce_hdl;
 	u32 buf_sz;
 	struct sk_buff *netbuf;
 	u32 ce_data;
@@ -1190,7 +1190,7 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
 {
 	struct ath10k *ar;
 	struct ath10k_pci *ar_pci;
-	struct ce_state *ce_hdl;
+	struct ath10k_ce_pipe *ce_hdl;
 	struct sk_buff *netbuf;
 	u32 ce_data;
 	unsigned int nbytes;
@@ -1300,8 +1300,8 @@ static int ath10k_pci_hif_exchange_bmi_msg(struct ath10k *ar,
 					   void *resp, u32 *resp_len)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ce_state *ce_tx = ar_pci->pipe_info[BMI_CE_NUM_TO_TARG].ce_hdl;
-	struct ce_state *ce_rx = ar_pci->pipe_info[BMI_CE_NUM_TO_HOST].ce_hdl;
+	struct ath10k_ce_pipe *ce_tx = ar_pci->pipe_info[BMI_CE_NUM_TO_TARG].ce_hdl;
+	struct ath10k_ce_pipe *ce_rx = ar_pci->pipe_info[BMI_CE_NUM_TO_HOST].ce_hdl;
 	dma_addr_t req_paddr = 0;
 	dma_addr_t resp_paddr = 0;
 	struct bmi_xfer xfer = {};
@@ -1385,7 +1385,7 @@ err_dma:
 	return ret;
 }
 
-static void ath10k_pci_bmi_send_done(struct ce_state *ce_state,
+static void ath10k_pci_bmi_send_done(struct ath10k_ce_pipe *ce_state,
 				     void *transfer_context,
 				     u32 data,
 				     unsigned int nbytes,
@@ -1399,7 +1399,7 @@ static void ath10k_pci_bmi_send_done(struct ce_state *ce_state,
 	complete(&xfer->done);
 }
 
-static void ath10k_pci_bmi_recv_data(struct ce_state *ce_state,
+static void ath10k_pci_bmi_recv_data(struct ath10k_ce_pipe *ce_state,
 				     void *transfer_context,
 				     u32 data,
 				     unsigned int nbytes,
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index de26311..c65fe1b 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -52,7 +52,7 @@ enum ath10k_pci_compl_state {
 struct ath10k_pci_compl {
 	struct list_head list;
 	enum ath10k_pci_compl_state state;
-	struct ce_state *ce_state;
+	struct ath10k_ce_pipe *ce_state;
 	struct ath10k_pci_pipe *pipe_info;
 	void *transfer_context;
 	unsigned int nbytes;
@@ -162,7 +162,7 @@ enum ath10k_pci_features {
 /* Per-pipe state. */
 struct ath10k_pci_pipe {
 	/* Handle of underlying Copy Engine */
-	struct ce_state *ce_hdl;
+	struct ath10k_ce_pipe *ce_hdl;
 
 	/* Our pipe number; facilitiates use of pipe_info ptrs. */
 	u8 pipe_num;
@@ -227,13 +227,13 @@ struct ath10k_pci {
 	u32 fw_indicator_address;
 
 	/* Copy Engine used for Diagnostic Accesses */
-	struct ce_state *ce_diag;
+	struct ath10k_ce_pipe *ce_diag;
 
 	/* FIXME: document what this really protects */
 	spinlock_t ce_lock;
 
 	/* Map CE id to ce_state */
-	struct ce_state ce_states[CE_COUNT_MAX];
+	struct ath10k_ce_pipe ce_states[CE_COUNT_MAX];
 
 	/* makes sure that dummy reads are atomic */
 	spinlock_t hw_v1_workaround_lock;
-- 
1.7.9.5

