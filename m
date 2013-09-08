Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:34783 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab3IHPgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 11:36:14 -0400
Subject: [PATCH] ath10k: delete struct ce_sendlist
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Sep 2013 18:36:11 +0300
Message-ID: <20130908153611.4572.43965.stgit@localhost6.localdomain6> (sfid-20130908_173625_220172_38FC2830)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct ce_sendlist is useless as we always add just one buffer onto it.
And most importantly, it's ugly as it doesn't use skb properly.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |   48 ++++++---------------------------
 drivers/net/wireless/ath/ath10k/ce.h  |   44 +++---------------------------
 drivers/net/wireless/ath/ath10k/pci.c |   40 +++++++++-------------------
 3 files changed, 25 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 4f8373c..834e29e 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -338,33 +338,19 @@ int ath10k_ce_send(struct ath10k_ce_pipe *ce_state,
 	return ret;
 }
 
-void ath10k_ce_sendlist_buf_add(struct ce_sendlist *sendlist, u32 buffer,
-				unsigned int nbytes, u32 flags)
-{
-	unsigned int num_items = sendlist->num_items;
-	struct ce_sendlist_item *item;
-
-	item = &sendlist->item[num_items];
-	item->data = buffer;
-	item->u.nbytes = nbytes;
-	item->flags = flags;
-	sendlist->num_items++;
-}
-
 int ath10k_ce_sendlist_send(struct ath10k_ce_pipe *ce_state,
 			    void *per_transfer_context,
-			    struct ce_sendlist *sendlist,
-			    unsigned int transfer_id)
+			    unsigned int transfer_id,
+			    u32 paddr, unsigned int nbytes,
+			    u32 flags)
 {
 	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
-	struct ce_sendlist_item *item;
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	unsigned int nentries_mask = src_ring->nentries_mask;
-	unsigned int num_items = sendlist->num_items;
 	unsigned int sw_index;
 	unsigned int write_index;
-	int i, delta, ret = -ENOMEM;
+	int delta, ret = -ENOMEM;
 
 	spin_lock_bh(&ar_pci->ce_lock);
 
@@ -373,30 +359,12 @@ int ath10k_ce_sendlist_send(struct ath10k_ce_pipe *ce_state,
 
 	delta = CE_RING_DELTA(nentries_mask, write_index, sw_index - 1);
 
-	if (delta >= num_items) {
-		/*
-		 * Handle all but the last item uniformly.
-		 */
-		for (i = 0; i < num_items - 1; i++) {
-			item = &sendlist->item[i];
-			ret = ath10k_ce_send_nolock(ce_state,
-						    CE_SENDLIST_ITEM_CTXT,
-						    (u32) item->data,
-						    item->u.nbytes, transfer_id,
-						    item->flags |
-						    CE_SEND_FLAG_GATHER);
-			if (ret)
-				ath10k_warn("CE send failed for item: %d\n", i);
-		}
-		/*
-		 * Provide valid context pointer for final item.
-		 */
-		item = &sendlist->item[i];
+	if (delta >= 1) {
 		ret = ath10k_ce_send_nolock(ce_state, per_transfer_context,
-					    (u32) item->data, item->u.nbytes,
-					    transfer_id, item->flags);
+					    paddr, nbytes,
+					    transfer_id, flags);
 		if (ret)
-			ath10k_warn("CE send failed for last item: %d\n", i);
+			ath10k_warn("CE send failed: %d\n", ret);
 	}
 
 	spin_unlock_bh(&ar_pci->ce_lock);
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index fb22361..aec8028 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -27,7 +27,6 @@
 
 /* Descriptor rings must be aligned to this boundary */
 #define CE_DESC_RING_ALIGN	8
-#define CE_SENDLIST_ITEMS_MAX	12
 #define CE_SEND_FLAG_GATHER	0x00010000
 
 /*
@@ -124,24 +123,6 @@ struct ath10k_ce_pipe {
 	struct ath10k_ce_ring *dest_ring;
 };
 
-struct ce_sendlist_item {
-	/* e.g. buffer or desc list */
-	dma_addr_t data;
-	union {
-		/* simple buffer */
-		unsigned int nbytes;
-		/* Rx descriptor list */
-		unsigned int ndesc;
-	} u;
-	/* externally-specified flags; OR-ed with internal flags */
-	u32 flags;
-};
-
-struct ce_sendlist {
-	unsigned int num_items;
-	struct ce_sendlist_item item[CE_SENDLIST_ITEMS_MAX];
-};
-
 /* Copy Engine settable attributes */
 struct ce_attr;
 
@@ -175,13 +156,6 @@ void ath10k_ce_send_cb_register(struct ath10k_ce_pipe *ce_state,
 				void (*send_cb)(struct ath10k_ce_pipe *),
 				int disable_interrupts);
 
-/* Append a simple buffer (address/length) to a sendlist. */
-void ath10k_ce_sendlist_buf_add(struct ce_sendlist *sendlist,
-				u32 buffer,
-				unsigned int nbytes,
-				/* OR-ed with internal flags */
-				u32 flags);
-
 /*
  * Queue a "sendlist" of buffers to be sent using gather to a single
  * anonymous destination buffer
@@ -193,10 +167,10 @@ void ath10k_ce_sendlist_buf_add(struct ce_sendlist *sendlist,
  * Implemenation note: Pushes multiple buffers with Gather to Source ring.
  */
 int ath10k_ce_sendlist_send(struct ath10k_ce_pipe *ce_state,
-			    void *per_transfer_send_context,
-			    struct ce_sendlist *sendlist,
-			    /* 14 bits */
-			    unsigned int transfer_id);
+			    void *per_transfer_context,
+			    unsigned int transfer_id,
+			    u32 paddr, unsigned int nbytes,
+			    u32 flags);
 
 /*==================Recv=======================*/
 
@@ -307,16 +281,6 @@ struct ce_attr {
 	unsigned int dest_nentries;
 };
 
-/*
- * When using sendlist_send to transfer multiple buffer fragments, the
- * transfer context of each fragment, except last one, will be filled
- * with CE_SENDLIST_ITEM_CTXT. ce_completed_send will return success for
- * each fragment done with send and the transfer context would be
- * CE_SENDLIST_ITEM_CTXT. Upper layer could use this to identify the
- * status of a send completion.
- */
-#define CE_SENDLIST_ITEM_CTXT	((void *)0xcecebeef)
-
 #define SR_BA_ADDRESS		0x0000
 #define SR_SIZE_ADDRESS		0x0004
 #define DR_BA_ADDRESS		0x0008
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 899a8c0..ecaf213 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -626,17 +626,9 @@ static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state)
 	while (ath10k_ce_completed_send_next(ce_state, &transfer_context,
 					     &ce_data, &nbytes,
 					     &transfer_id) == 0) {
-		/*
-		 * For the send completion of an item in sendlist, just
-		 * increment num_sends_allowed. The upper layer callback will
-		 * be triggered when last fragment is done with send.
-		 */
-		if (transfer_context == CE_SENDLIST_ITEM_CTXT) {
-			spin_lock_bh(&pipe_info->pipe_lock);
-			pipe_info->num_sends_allowed++;
-			spin_unlock_bh(&pipe_info->pipe_lock);
-			continue;
-		}
+		spin_lock_bh(&pipe_info->pipe_lock);
+		pipe_info->num_sends_allowed++;
+		spin_unlock_bh(&pipe_info->pipe_lock);
 
 		compl = get_free_compl(pipe_info);
 		if (!compl)
@@ -714,13 +706,10 @@ static int ath10k_pci_hif_send_head(struct ath10k *ar, u8 pipe_id,
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_pipe *pipe_info = &(ar_pci->pipe_info[pipe_id]);
 	struct ath10k_ce_pipe *ce_hdl = pipe_info->ce_hdl;
-	struct ce_sendlist sendlist;
 	unsigned int len;
 	u32 flags = 0;
 	int ret;
 
-	memset(&sendlist, 0, sizeof(struct ce_sendlist));
-
 	len = min(bytes, nbuf->len);
 	bytes -= len;
 
@@ -735,8 +724,6 @@ static int ath10k_pci_hif_send_head(struct ath10k *ar, u8 pipe_id,
 			"ath10k tx: data: ",
 			nbuf->data, nbuf->len);
 
-	ath10k_ce_sendlist_buf_add(&sendlist, skb_cb->paddr, len, flags);
-
 	/* Make sure we have resources to handle this request */
 	spin_lock_bh(&pipe_info->pipe_lock);
 	if (!pipe_info->num_sends_allowed) {
@@ -747,7 +734,8 @@ static int ath10k_pci_hif_send_head(struct ath10k *ar, u8 pipe_id,
 	pipe_info->num_sends_allowed--;
 	spin_unlock_bh(&pipe_info->pipe_lock);
 
-	ret = ath10k_ce_sendlist_send(ce_hdl, nbuf, &sendlist, transfer_id);
+	ret = ath10k_ce_sendlist_send(ce_hdl, nbuf, transfer_id,
+				      skb_cb->paddr, len, flags);
 	if (ret)
 		ath10k_warn("CE send failed: %p\n", nbuf);
 
@@ -1302,16 +1290,14 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
 
 	while (ath10k_ce_cancel_send_next(ce_hdl, (void **)&netbuf,
 					  &ce_data, &nbytes, &id) == 0) {
-		if (netbuf != CE_SENDLIST_ITEM_CTXT) {
-			/*
-			 * Indicate the completion to higer layer to free
-			 * the buffer
-			 */
-			ATH10K_SKB_CB(netbuf)->is_aborted = true;
-			ar_pci->msg_callbacks_current.tx_completion(ar,
-								    netbuf,
-								    id);
-		}
+		/*
+		 * Indicate the completion to higer layer to free
+		 * the buffer
+		 */
+		ATH10K_SKB_CB(netbuf)->is_aborted = true;
+		ar_pci->msg_callbacks_current.tx_completion(ar,
+							    netbuf,
+							    id);
 	}
 }
 

