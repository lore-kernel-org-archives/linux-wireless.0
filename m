Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:55142 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaC1HkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 03:40:23 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so3741251eek.32
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 00:40:22 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/3] ath10k: convert pci_alloc_consistent() to dma_alloc_coherent()
Date: Fri, 28 Mar 2014 08:34:23 +0100
Message-Id: <1395992065-10086-2-git-send-email-michal.kazior@tieto.com> (sfid-20140328_084028_199898_0A606EE7)
In-Reply-To: <1395992065-10086-1-git-send-email-michal.kazior@tieto.com>
References: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com>
 <1395992065-10086-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows to use GFP_KERNEL allocation. This
should decrease chance of allocation failure, e.g.
during firmware recovery.

Reported-By: Avery Pennarun <apenwarr@gmail.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 53 +++++++++++++++++------------------
 drivers/net/wireless/ath/ath10k/pci.c | 22 ++++++++-------
 2 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index a79499c..653a240 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -843,7 +843,6 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 				   struct ath10k_ce_pipe *ce_state,
 				   const struct ce_attr *attr)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_ce_ring *src_ring;
 	unsigned int nentries = attr->src_nentries;
 	unsigned int ce_nbytes;
@@ -885,10 +884,10 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 	 * coherent DMA are unsupported
 	 */
 	src_ring->base_addr_owner_space_unaligned =
-		pci_alloc_consistent(ar_pci->pdev,
-				     (nentries * sizeof(struct ce_desc) +
-				      CE_DESC_RING_ALIGN),
-				     &base_addr);
+		dma_alloc_coherent(ar->dev,
+				   (nentries * sizeof(struct ce_desc) +
+				    CE_DESC_RING_ALIGN),
+				   &base_addr, GFP_KERNEL);
 	if (!src_ring->base_addr_owner_space_unaligned) {
 		kfree(ce_state->src_ring);
 		ce_state->src_ring = NULL;
@@ -912,11 +911,11 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 		kmalloc((nentries * sizeof(struct ce_desc) +
 			 CE_DESC_RING_ALIGN), GFP_KERNEL);
 	if (!src_ring->shadow_base_unaligned) {
-		pci_free_consistent(ar_pci->pdev,
-				    (nentries * sizeof(struct ce_desc) +
-				     CE_DESC_RING_ALIGN),
-				    src_ring->base_addr_owner_space,
-				    src_ring->base_addr_ce_space);
+		dma_free_coherent(ar->dev,
+				  (nentries * sizeof(struct ce_desc) +
+				   CE_DESC_RING_ALIGN),
+				  src_ring->base_addr_owner_space,
+				  src_ring->base_addr_ce_space);
 		kfree(ce_state->src_ring);
 		ce_state->src_ring = NULL;
 		return -ENOMEM;
@@ -946,7 +945,6 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 				    struct ath10k_ce_pipe *ce_state,
 				    const struct ce_attr *attr)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_ce_ring *dest_ring;
 	unsigned int nentries = attr->dest_nentries;
 	unsigned int ce_nbytes;
@@ -986,10 +984,10 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 	 * coherent DMA are unsupported
 	 */
 	dest_ring->base_addr_owner_space_unaligned =
-		pci_alloc_consistent(ar_pci->pdev,
-				     (nentries * sizeof(struct ce_desc) +
-				      CE_DESC_RING_ALIGN),
-				     &base_addr);
+		dma_alloc_coherent(ar->dev,
+				   (nentries * sizeof(struct ce_desc) +
+				    CE_DESC_RING_ALIGN),
+				   &base_addr, GFP_KERNEL);
 	if (!dest_ring->base_addr_owner_space_unaligned) {
 		kfree(ce_state->dest_ring);
 		ce_state->dest_ring = NULL;
@@ -1112,26 +1110,25 @@ out:
 void ath10k_ce_deinit(struct ath10k_ce_pipe *ce_state)
 {
 	struct ath10k *ar = ce_state->ar;
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
 	if (ce_state->src_ring) {
 		kfree(ce_state->src_ring->shadow_base_unaligned);
-		pci_free_consistent(ar_pci->pdev,
-				    (ce_state->src_ring->nentries *
-				     sizeof(struct ce_desc) +
-				     CE_DESC_RING_ALIGN),
-				    ce_state->src_ring->base_addr_owner_space,
-				    ce_state->src_ring->base_addr_ce_space);
+		dma_free_coherent(ar->dev,
+				  (ce_state->src_ring->nentries *
+				   sizeof(struct ce_desc) +
+				   CE_DESC_RING_ALIGN),
+				  ce_state->src_ring->base_addr_owner_space,
+				  ce_state->src_ring->base_addr_ce_space);
 		kfree(ce_state->src_ring);
 	}
 
 	if (ce_state->dest_ring) {
-		pci_free_consistent(ar_pci->pdev,
-				    (ce_state->dest_ring->nentries *
-				     sizeof(struct ce_desc) +
-				     CE_DESC_RING_ALIGN),
-				    ce_state->dest_ring->base_addr_owner_space,
-				    ce_state->dest_ring->base_addr_ce_space);
+		dma_free_coherent(ar->dev,
+				  (ce_state->dest_ring->nentries *
+				   sizeof(struct ce_desc) +
+				   CE_DESC_RING_ALIGN),
+				  ce_state->dest_ring->base_addr_owner_space,
+				  ce_state->dest_ring->base_addr_ce_space);
 		kfree(ce_state->dest_ring);
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 9d242d8..f167ceb 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -346,9 +346,10 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 	 *   2) Buffer in DMA-able space
 	 */
 	orig_nbytes = nbytes;
-	data_buf = (unsigned char *)pci_alloc_consistent(ar_pci->pdev,
-							 orig_nbytes,
-							 &ce_data_base);
+	data_buf = (unsigned char *)dma_alloc_coherent(ar->dev,
+						       orig_nbytes,
+						       &ce_data_base,
+						       GFP_ATOMIC);
 
 	if (!data_buf) {
 		ret = -ENOMEM;
@@ -446,8 +447,8 @@ done:
 			   __func__, address);
 
 	if (data_buf)
-		pci_free_consistent(ar_pci->pdev, orig_nbytes,
-				    data_buf, ce_data_base);
+		dma_free_coherent(ar->dev, orig_nbytes, data_buf,
+				  ce_data_base);
 
 	return ret;
 }
@@ -490,9 +491,10 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	 *   2) Buffer in DMA-able space
 	 */
 	orig_nbytes = nbytes;
-	data_buf = (unsigned char *)pci_alloc_consistent(ar_pci->pdev,
-							 orig_nbytes,
-							 &ce_data_base);
+	data_buf = (unsigned char *)dma_alloc_coherent(ar->dev,
+						       orig_nbytes,
+						       &ce_data_base,
+						       GFP_ATOMIC);
 	if (!data_buf) {
 		ret = -ENOMEM;
 		goto done;
@@ -588,8 +590,8 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 
 done:
 	if (data_buf) {
-		pci_free_consistent(ar_pci->pdev, orig_nbytes, data_buf,
-				    ce_data_base);
+		dma_free_coherent(ar->dev, orig_nbytes, data_buf,
+				  ce_data_base);
 	}
 
 	if (ret != 0)
-- 
1.8.5.3

