Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15994 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbcCVLyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 07:54:19 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 7/9] ath10k: cleanup copy engine receive next completion
Date: Tue, 22 Mar 2016 17:22:17 +0530
Message-ID: <1458647539-17213-8-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160322_125421_843148_C9EFB3B5)
In-Reply-To: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The physical address necessary to unmap DMA ('bufferp') is stored
in ath10k_skb_cb as 'paddr'. For diag register read and write
operations, 'paddr' is stored in transfer context. ath10k doesn't rely
on the meta/transfer_id. So the unused output arguments {bufferp, nbytesp
and transfer_idp} are removed from CE recv_next completion.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 21 +++--------------
 drivers/net/wireless/ath/ath10k/ce.h  | 10 ++------
 drivers/net/wireless/ath/ath10k/pci.c | 43 ++++++++++++++---------------------
 3 files changed, 22 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index edf3629..d6da404 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -444,14 +444,10 @@ int ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr)
  */
 int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
 					 void **per_transfer_contextp,
-					 u32 *bufferp,
-					 unsigned int *nbytesp,
-					 unsigned int *transfer_idp,
-					 unsigned int *flagsp)
+					 unsigned int *nbytesp)
 {
 	struct ath10k_ce_ring *dest_ring = ce_state->dest_ring;
 	unsigned int nentries_mask = dest_ring->nentries_mask;
-	struct ath10k *ar = ce_state->ar;
 	unsigned int sw_index = dest_ring->sw_index;
 
 	struct ce_desc *base = dest_ring->base_addr_owner_space;
@@ -476,14 +472,7 @@ int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
 	desc->nbytes = 0;
 
 	/* Return data from completed destination descriptor */
-	*bufferp = __le32_to_cpu(sdesc.addr);
 	*nbytesp = nbytes;
-	*transfer_idp = MS(__le16_to_cpu(sdesc.flags), CE_DESC_FLAGS_META_DATA);
-
-	if (__le16_to_cpu(sdesc.flags) & CE_DESC_FLAGS_BYTE_SWAP)
-		*flagsp = CE_RECV_FLAG_SWAPPED;
-	else
-		*flagsp = 0;
 
 	if (per_transfer_contextp)
 		*per_transfer_contextp =
@@ -501,10 +490,7 @@ int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
 
 int ath10k_ce_completed_recv_next(struct ath10k_ce_pipe *ce_state,
 				  void **per_transfer_contextp,
-				  u32 *bufferp,
-				  unsigned int *nbytesp,
-				  unsigned int *transfer_idp,
-				  unsigned int *flagsp)
+				  unsigned int *nbytesp)
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -513,8 +499,7 @@ int ath10k_ce_completed_recv_next(struct ath10k_ce_pipe *ce_state,
 	spin_lock_bh(&ar_pci->ce_lock);
 	ret = ath10k_ce_completed_recv_next_nolock(ce_state,
 						   per_transfer_contextp,
-						   bufferp, nbytesp,
-						   transfer_idp, flagsp);
+						   nbytesp);
 	spin_unlock_bh(&ar_pci->ce_lock);
 
 	return ret;
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index dac6768..68717e5 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -177,10 +177,7 @@ int ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr);
  */
 int ath10k_ce_completed_recv_next(struct ath10k_ce_pipe *ce_state,
 				  void **per_transfer_contextp,
-				  u32 *bufferp,
-				  unsigned int *nbytesp,
-				  unsigned int *transfer_idp,
-				  unsigned int *flagsp);
+				  unsigned int *nbytesp);
 /*
  * Supply data for the next completed unprocessed send descriptor.
  * Pops 1 completed send buffer from Source ring.
@@ -212,10 +209,7 @@ int ath10k_ce_revoke_recv_next(struct ath10k_ce_pipe *ce_state,
 
 int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
 					 void **per_transfer_contextp,
-					 u32 *bufferp,
-					 unsigned int *nbytesp,
-					 unsigned int *transfer_idp,
-					 unsigned int *flagsp);
+					 unsigned int *nbytesp);
 
 /*
  * Support clean shutdown by allowing the caller to cancel
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index b3cff1d..290a61a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -870,10 +870,8 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret = 0;
-	u32 buf;
+	u32 *buf;
 	unsigned int completed_nbytes, orig_nbytes, remaining_bytes;
-	unsigned int id;
-	unsigned int flags;
 	struct ath10k_ce_pipe *ce_diag;
 	/* Host buffer address in CE space */
 	u32 ce_data;
@@ -909,7 +907,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		nbytes = min_t(unsigned int, remaining_bytes,
 			       DIAG_TRANSFER_LIMIT);
 
-		ret = __ath10k_ce_rx_post_buf(ce_diag, NULL, ce_data);
+		ret = __ath10k_ce_rx_post_buf(ce_diag, &ce_data, ce_data);
 		if (ret != 0)
 			goto done;
 
@@ -940,9 +938,10 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		}
 
 		i = 0;
-		while (ath10k_ce_completed_recv_next_nolock(ce_diag, NULL, &buf,
-							    &completed_nbytes,
-							    &id, &flags) != 0) {
+		while (ath10k_ce_completed_recv_next_nolock(ce_diag,
+							    (void **)&buf,
+							    &completed_nbytes)
+								!= 0) {
 			mdelay(1);
 
 			if (i++ > DIAG_ACCESS_CE_TIMEOUT_MS) {
@@ -956,7 +955,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 			goto done;
 		}
 
-		if (buf != ce_data) {
+		if (*buf != ce_data) {
 			ret = -EIO;
 			goto done;
 		}
@@ -1026,10 +1025,8 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret = 0;
-	u32 buf;
+	u32 *buf;
 	unsigned int completed_nbytes, orig_nbytes, remaining_bytes;
-	unsigned int id;
-	unsigned int flags;
 	struct ath10k_ce_pipe *ce_diag;
 	void *data_buf = NULL;
 	u32 ce_data;	/* Host buffer address in CE space */
@@ -1078,7 +1075,7 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		nbytes = min_t(int, remaining_bytes, DIAG_TRANSFER_LIMIT);
 
 		/* Set up to receive directly into Target(!) address */
-		ret = __ath10k_ce_rx_post_buf(ce_diag, NULL, address);
+		ret = __ath10k_ce_rx_post_buf(ce_diag, &address, address);
 		if (ret != 0)
 			goto done;
 
@@ -1103,9 +1100,10 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		}
 
 		i = 0;
-		while (ath10k_ce_completed_recv_next_nolock(ce_diag, NULL, &buf,
-							    &completed_nbytes,
-							    &id, &flags) != 0) {
+		while (ath10k_ce_completed_recv_next_nolock(ce_diag,
+							    (void **)&buf,
+							    &completed_nbytes)
+								!= 0) {
 			mdelay(1);
 
 			if (i++ > DIAG_ACCESS_CE_TIMEOUT_MS) {
@@ -1119,7 +1117,7 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 			goto done;
 		}
 
-		if (buf != address) {
+		if (*buf != address) {
 			ret = -EIO;
 			goto done;
 		}
@@ -1181,15 +1179,11 @@ static void ath10k_pci_process_rx_cb(struct ath10k_ce_pipe *ce_state,
 	struct sk_buff *skb;
 	struct sk_buff_head list;
 	void *transfer_context;
-	u32 ce_data;
 	unsigned int nbytes, max_nbytes;
-	unsigned int transfer_id;
-	unsigned int flags;
 
 	__skb_queue_head_init(&list);
 	while (ath10k_ce_completed_recv_next(ce_state, &transfer_context,
-					     &ce_data, &nbytes, &transfer_id,
-					     &flags) == 0) {
+					     &nbytes) == 0) {
 		skb = transfer_context;
 		max_nbytes = skb->len + skb_tailroom(skb);
 		dma_unmap_single(ar->dev, ATH10K_SKB_RXCB(skb)->paddr,
@@ -1835,13 +1829,10 @@ static void ath10k_pci_bmi_recv_data(struct ath10k_ce_pipe *ce_state)
 {
 	struct ath10k *ar = ce_state->ar;
 	struct bmi_xfer *xfer;
-	u32 ce_data;
 	unsigned int nbytes;
-	unsigned int transfer_id;
-	unsigned int flags;
 
-	if (ath10k_ce_completed_recv_next(ce_state, (void **)&xfer, &ce_data,
-					  &nbytes, &transfer_id, &flags))
+	if (ath10k_ce_completed_recv_next(ce_state, (void **)&xfer,
+					  &nbytes))
 		return;
 
 	if (WARN_ON_ONCE(!xfer))
-- 
2.7.4

