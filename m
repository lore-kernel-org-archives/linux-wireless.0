Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9323 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbbJWMcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 08:32:13 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 3/4] ath10k: cleanup copy engine send completion
Date: Fri, 23 Oct 2015 18:01:05 +0530
Message-ID: <1445603466-14138-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151023_143222_610920_AA0AFCD7)
In-Reply-To: <1445603466-14138-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1445603466-14138-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The physical address necessary to unmap DMA ('bufferp') is stored
in ath10k_skb_cb as 'paddr'. ath10k doesn't rely on the meta/transfer_id
when handling send completion (htc ep id is stored in sk_buff control
buffer). So the unused output arguments {bufferp, nbytesp and transfer_idp}
are removed from CE send completion. This change is needed before removing
the shadow copy of copy engine (CE) descriptors in follow up patch.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 24 +++---------------------
 drivers/net/wireless/ath/ath10k/ce.h  | 10 ++--------
 drivers/net/wireless/ath/ath10k/pci.c | 28 +++++++---------------------
 3 files changed, 12 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index f63376b..52021a9 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -578,17 +578,13 @@ int ath10k_ce_revoke_recv_next(struct ath10k_ce_pipe *ce_state,
  * The caller takes responsibility for any necessary locking.
  */
 int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
-					 void **per_transfer_contextp,
-					 u32 *bufferp,
-					 unsigned int *nbytesp,
-					 unsigned int *transfer_idp)
+					 void **per_transfer_contextp)
 {
 	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
 	u32 ctrl_addr = ce_state->ctrl_addr;
 	struct ath10k *ar = ce_state->ar;
 	unsigned int nentries_mask = src_ring->nentries_mask;
 	unsigned int sw_index = src_ring->sw_index;
-	struct ce_desc *sdesc, *sbase;
 	unsigned int read_index;
 
 	if (src_ring->hw_index == sw_index) {
@@ -613,15 +609,6 @@ int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 	if (read_index == sw_index)
 		return -EIO;
 
-	sbase = src_ring->base_addr_owner_space;
-	sdesc = CE_SRC_RING_TO_DESC(sbase, sw_index);
-
-	/* Return data from completed source descriptor */
-	*bufferp = __le32_to_cpu(sdesc->addr);
-	*nbytesp = __le16_to_cpu(sdesc->nbytes);
-	*transfer_idp = MS(__le16_to_cpu(sdesc->flags),
-			   CE_DESC_FLAGS_META_DATA);
-
 	if (per_transfer_contextp)
 		*per_transfer_contextp =
 			src_ring->per_transfer_context[sw_index];
@@ -696,10 +683,7 @@ int ath10k_ce_cancel_send_next(struct ath10k_ce_pipe *ce_state,
 }
 
 int ath10k_ce_completed_send_next(struct ath10k_ce_pipe *ce_state,
-				  void **per_transfer_contextp,
-				  u32 *bufferp,
-				  unsigned int *nbytesp,
-				  unsigned int *transfer_idp)
+				  void **per_transfer_contextp)
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -707,9 +691,7 @@ int ath10k_ce_completed_send_next(struct ath10k_ce_pipe *ce_state,
 
 	spin_lock_bh(&ar_pci->ce_lock);
 	ret = ath10k_ce_completed_send_next_nolock(ce_state,
-						   per_transfer_contextp,
-						   bufferp, nbytesp,
-						   transfer_idp);
+						   per_transfer_contextp);
 	spin_unlock_bh(&ar_pci->ce_lock);
 
 	return ret;
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index dbb94fd..67f90ec 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -192,16 +192,10 @@ int ath10k_ce_completed_recv_next(struct ath10k_ce_pipe *ce_state,
  * Pops 1 completed send buffer from Source ring.
  */
 int ath10k_ce_completed_send_next(struct ath10k_ce_pipe *ce_state,
-				  void **per_transfer_contextp,
-				  u32 *bufferp,
-				  unsigned int *nbytesp,
-				  unsigned int *transfer_idp);
+				  void **per_transfer_contextp);
 
 int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
-					 void **per_transfer_contextp,
-					 u32 *bufferp,
-					 unsigned int *nbytesp,
-					 unsigned int *transfer_idp);
+					 void **per_transfer_contextp);
 
 /*==================CE Engine Initialization=======================*/
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 6f3c3e0..8100025 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -910,9 +910,8 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 			goto done;
 
 		i = 0;
-		while (ath10k_ce_completed_send_next_nolock(ce_diag, NULL, &buf,
-							    &completed_nbytes,
-							    &id) != 0) {
+		while (ath10k_ce_completed_send_next_nolock(ce_diag,
+							    NULL) != 0) {
 			mdelay(1);
 			if (i++ > DIAG_ACCESS_CE_TIMEOUT_MS) {
 				ret = -EBUSY;
@@ -1073,9 +1072,8 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 			goto done;
 
 		i = 0;
-		while (ath10k_ce_completed_send_next_nolock(ce_diag, NULL, &buf,
-							    &completed_nbytes,
-							    &id) != 0) {
+		while (ath10k_ce_completed_send_next_nolock(ce_diag,
+							    NULL) != 0) {
 			mdelay(1);
 
 			if (i++ > DIAG_ACCESS_CE_TIMEOUT_MS) {
@@ -1139,13 +1137,9 @@ static void ath10k_pci_htc_tx_cb(struct ath10k_ce_pipe *ce_state)
 	struct ath10k *ar = ce_state->ar;
 	struct sk_buff_head list;
 	struct sk_buff *skb;
-	u32 ce_data;
-	unsigned int nbytes;
-	unsigned int transfer_id;
 
 	__skb_queue_head_init(&list);
-	while (ath10k_ce_completed_send_next(ce_state, (void **)&skb, &ce_data,
-					     &nbytes, &transfer_id) == 0) {
+	while (ath10k_ce_completed_send_next(ce_state, (void **)&skb) == 0) {
 		/* no need to call tx completion for NULL pointers */
 		if (skb == NULL)
 			continue;
@@ -1215,12 +1209,8 @@ static void ath10k_pci_htt_tx_cb(struct ath10k_ce_pipe *ce_state)
 {
 	struct ath10k *ar = ce_state->ar;
 	struct sk_buff *skb;
-	u32 ce_data;
-	unsigned int nbytes;
-	unsigned int transfer_id;
 
-	while (ath10k_ce_completed_send_next(ce_state, (void **)&skb, &ce_data,
-					     &nbytes, &transfer_id) == 0) {
+	while (ath10k_ce_completed_send_next(ce_state, (void **)&skb) == 0) {
 		/* no need to call tx completion for NULL pointers */
 		if (!skb)
 			continue;
@@ -1796,12 +1786,8 @@ err_dma:
 static void ath10k_pci_bmi_send_done(struct ath10k_ce_pipe *ce_state)
 {
 	struct bmi_xfer *xfer;
-	u32 ce_data;
-	unsigned int nbytes;
-	unsigned int transfer_id;
 
-	if (ath10k_ce_completed_send_next(ce_state, (void **)&xfer, &ce_data,
-					  &nbytes, &transfer_id))
+	if (ath10k_ce_completed_send_next(ce_state, (void **)&xfer))
 		return;
 
 	xfer->tx_done = true;
-- 
2.6.1

