Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:39650 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaBQJh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 04:37:58 -0500
Received: by mail-ea0-f172.google.com with SMTP id l9so6487677eaj.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 01:37:56 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT 3/7] ath10k: replace send_head() with tx_sg()
Date: Mon, 17 Feb 2014 10:32:39 +0100
Message-Id: <1392629563-31046-4-git-send-email-michal.kazior@tieto.com> (sfid-20140217_103807_534878_E337E89B)
In-Reply-To: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PCI is capable of handling scatter-gather lists.
This can be used to avoid copying memory.

Change the name of the callback while at to
reflect its purpose.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 12 ++---
 drivers/net/wireless/ath/ath10k/ce.h  |  7 +++
 drivers/net/wireless/ath/ath10k/hif.h | 25 ++++++-----
 drivers/net/wireless/ath/ath10k/htc.c | 10 ++++-
 drivers/net/wireless/ath/ath10k/pci.c | 84 +++++++++++++++++++++++------------
 5 files changed, 92 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index d44d618..a0b1a8c 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -266,12 +266,12 @@ static inline void ath10k_ce_engine_int_status_clear(struct ath10k *ar,
  * ath10k_ce_sendlist_send.
  * The caller takes responsibility for any needed locking.
  */
-static int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
-				 void *per_transfer_context,
-				 u32 buffer,
-				 unsigned int nbytes,
-				 unsigned int transfer_id,
-				 unsigned int flags)
+int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
+			  void *per_transfer_context,
+			  u32 buffer,
+			  unsigned int nbytes,
+			  unsigned int transfer_id,
+			  unsigned int flags)
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 67dbde6..322e929 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -152,6 +152,13 @@ int ath10k_ce_send(struct ath10k_ce_pipe *ce_state,
 		   unsigned int transfer_id,
 		   unsigned int flags);
 
+int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
+			  void *per_transfer_context,
+			  u32 buffer,
+			  unsigned int nbytes,
+			  unsigned int transfer_id,
+			  unsigned int flags);
+
 void ath10k_ce_send_cb_register(struct ath10k_ce_pipe *ce_state,
 				void (*send_cb)(struct ath10k_ce_pipe *),
 				int disable_interrupts);
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index dcdea68..3a0ba21 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -21,6 +21,14 @@
 #include <linux/kernel.h>
 #include "core.h"
 
+struct ath10k_hif_sg_item {
+	u16 transfer_id;
+	void *transfer_context;
+	void *vaddr; /* for debugging mostly */
+	u32 paddr;
+	u16 len;
+};
+
 struct ath10k_hif_cb {
 	int (*tx_completion)(struct ath10k *ar,
 			     struct sk_buff *wbuf,
@@ -31,11 +39,9 @@ struct ath10k_hif_cb {
 };
 
 struct ath10k_hif_ops {
-	/* Send the head of a buffer to HIF for transmission to the target. */
-	int (*send_head)(struct ath10k *ar, u8 pipe_id,
-			 unsigned int transfer_id,
-			 unsigned int nbytes,
-			 struct sk_buff *buf);
+	/* send a scatter-gather list to the target */
+	int (*tx_sg)(struct ath10k *ar, u8 pipe_id,
+		     struct ath10k_hif_sg_item *items, int n_items);
 
 	/*
 	 * API to handle HIF-specific BMI message exchanges, this API is
@@ -86,12 +92,11 @@ struct ath10k_hif_ops {
 };
 
 
-static inline int ath10k_hif_send_head(struct ath10k *ar, u8 pipe_id,
-				       unsigned int transfer_id,
-				       unsigned int nbytes,
-				       struct sk_buff *buf)
+static inline int ath10k_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
+				   struct ath10k_hif_sg_item *items,
+				   int n_items)
 {
-	return ar->hif.ops->send_head(ar, pipe_id, transfer_id, nbytes, buf);
+	return ar->hif.ops->tx_sg(ar, pipe_id, items, n_items);
 }
 
 static inline int ath10k_hif_exchange_bmi_msg(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 69f1f46..64ab8d6 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -125,6 +125,7 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 {
 	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
+	struct ath10k_hif_sg_item sg_item;
 	struct device *dev = htc->ar->dev;
 	int credits = 0;
 	int ret;
@@ -166,8 +167,13 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 	if (ret)
 		goto err_credits;
 
-	ret = ath10k_hif_send_head(htc->ar, ep->ul_pipe_id, ep->eid,
-				   skb->len, skb);
+	sg_item.transfer_id = ep->eid;
+	sg_item.transfer_context = skb;
+	sg_item.vaddr = skb->data;
+	sg_item.paddr = skb_cb->paddr;
+	sg_item.len = skb->len;
+
+	ret = ath10k_hif_tx_sg(htc->ar, ep->ul_pipe_id, &sg_item, 1);
 	if (ret)
 		goto err_unmap;
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d973975..713c18e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -714,6 +714,9 @@ static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state)
 	while (ath10k_ce_completed_send_next(ce_state, &transfer_context,
 					     &ce_data, &nbytes,
 					     &transfer_id) == 0) {
+		if (transfer_context == NULL)
+			continue;
+
 		compl = get_free_compl(pipe_info);
 		if (!compl)
 			break;
@@ -781,39 +784,64 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 	ath10k_pci_process_ce(ar);
 }
 
-/* Send the first nbytes bytes of the buffer */
-static int ath10k_pci_hif_send_head(struct ath10k *ar, u8 pipe_id,
-				    unsigned int transfer_id,
-				    unsigned int bytes, struct sk_buff *nbuf)
+static int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
+				struct ath10k_hif_sg_item *items, int n_items)
 {
-	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(nbuf);
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_pci_pipe *pipe_info = &(ar_pci->pipe_info[pipe_id]);
-	struct ath10k_ce_pipe *ce_hdl = pipe_info->ce_hdl;
-	unsigned int len;
-	u32 flags = 0;
-	int ret;
+	struct ath10k_pci_pipe *pci_pipe = &ar_pci->pipe_info[pipe_id];
+	struct ath10k_ce_pipe *ce_pipe = pci_pipe->ce_hdl;
+	struct ath10k_ce_ring *src_ring = ce_pipe->src_ring;
+	unsigned int nentries_mask = src_ring->nentries_mask;
+	unsigned int sw_index = src_ring->sw_index;
+	unsigned int write_index = src_ring->write_index;
+	int err, i;
 
-	len = min(bytes, nbuf->len);
-	bytes -= len;
+	spin_lock_bh(&ar_pci->ce_lock);
 
-	if (len & 3)
-		ath10k_warn("skb not aligned to 4-byte boundary (%d)\n", len);
+	if (unlikely(CE_RING_DELTA(nentries_mask,
+				   write_index, sw_index - 1) < n_items)) {
+		err = -ENOBUFS;
+		goto unlock;
+	}
 
-	ath10k_dbg(ATH10K_DBG_PCI,
-		   "pci send data vaddr %p paddr 0x%llx len %d as %d bytes\n",
-		   nbuf->data, (unsigned long long) skb_cb->paddr,
-		   nbuf->len, len);
-	ath10k_dbg_dump(ATH10K_DBG_PCI_DUMP, NULL,
-			"ath10k tx: data: ",
-			nbuf->data, nbuf->len);
-
-	ret = ath10k_ce_send(ce_hdl, nbuf, skb_cb->paddr, len, transfer_id,
-			     flags);
-	if (ret)
-		ath10k_warn("failed to send sk_buff to CE: %p\n", nbuf);
+	for (i = 0; i < n_items - 1; i++) {
+		ath10k_dbg(ATH10K_DBG_PCI,
+			   "pci tx item %d paddr 0x%08x len %d n_items %d\n",
+			   i, items[i].paddr, items[i].len, n_items);
+		ath10k_dbg_dump(ATH10K_DBG_PCI_DUMP, NULL, "item data: ",
+				items[i].vaddr, items[i].len);
 
-	return ret;
+		err = ath10k_ce_send_nolock(ce_pipe,
+					    items[i].transfer_context,
+					    items[i].paddr,
+					    items[i].len,
+					    items[i].transfer_id,
+					    CE_SEND_FLAG_GATHER);
+		if (err)
+			goto unlock;
+	}
+
+	/* `i` is equal to `n_items -1` after for() */
+
+	ath10k_dbg(ATH10K_DBG_PCI,
+		   "pci tx item %d paddr 0x%08x len %d n_items %d\n",
+		   i, items[i].paddr, items[i].len, n_items);
+	ath10k_dbg_dump(ATH10K_DBG_PCI_DUMP, NULL, "item data: ",
+			items[i].vaddr, items[i].len);
+
+	err = ath10k_ce_send_nolock(ce_pipe,
+				    items[i].transfer_context,
+				    items[i].paddr,
+				    items[i].len,
+				    items[i].transfer_id,
+				    0);
+	if (err)
+		goto unlock;
+
+	err = 0;
+unlock:
+	spin_unlock_bh(&ar_pci->ce_lock);
+	return err;
 }
 
 static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
@@ -2249,7 +2277,7 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
 #endif
 
 static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
-	.send_head		= ath10k_pci_hif_send_head,
+	.tx_sg			= ath10k_pci_hif_tx_sg,
 	.exchange_bmi_msg	= ath10k_pci_hif_exchange_bmi_msg,
 	.start			= ath10k_pci_hif_start,
 	.stop			= ath10k_pci_hif_stop,
-- 
1.8.5.3

