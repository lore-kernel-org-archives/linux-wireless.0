Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:42227 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaCYLSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 07:18:20 -0400
Received: by mail-ee0-f53.google.com with SMTP id b57so303727eek.40
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 04:18:19 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: convert pci_alloc_consistent() to dma_alloc_coherent()
Date: Tue, 25 Mar 2014 12:12:22 +0100
Message-Id: <1395745943-29492-2-git-send-email-michal.kazior@tieto.com> (sfid-20140325_121824_731434_AB44D0FC)
In-Reply-To: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com>
References: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com>
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
index 783cfa0..4cd3537 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -355,9 +355,10 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
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
@@ -455,8 +456,8 @@ done:
 			    address, ret);
 
 	if (data_buf)
-		pci_free_consistent(ar_pci->pdev, orig_nbytes,
-				    data_buf, ce_data_base);
+		dma_free_coherent(ar->dev, orig_nbytes, data_buf,
+				  ce_data_base);
 
 	return ret;
 }
@@ -499,9 +500,10 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
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
@@ -597,8 +599,8 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 
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

