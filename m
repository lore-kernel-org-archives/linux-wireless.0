Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:57354 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab3HUG5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:57:40 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/6] ath10k: rename ce_ring_state to ath10k_ce_ring
Date: Wed, 21 Aug 2013 08:57:29 +0200
Message-ID: <1377068249-26025-7-git-send-email-michal.kazior@tieto.com> (sfid-20130821_085743_398956_3E9FCAB2)
In-Reply-To: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
References: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new naming makes more sense.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c |   30 +++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/ce.h |    7 +++----
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 112897b..16be8c2 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -264,7 +264,7 @@ static int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 				 unsigned int flags)
 {
 	struct ath10k *ar = ce_state->ar;
-	struct ce_ring_state *src_ring = ce_state->src_ring;
+	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
 	struct ce_desc *desc, *sdesc;
 	unsigned int nentries_mask = src_ring->nentries_mask;
 	unsigned int sw_index = src_ring->sw_index;
@@ -354,7 +354,7 @@ int ath10k_ce_sendlist_send(struct ath10k_ce_pipe *ce_state,
 			    struct ce_sendlist *sendlist,
 			    unsigned int transfer_id)
 {
-	struct ce_ring_state *src_ring = ce_state->src_ring;
+	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
 	struct ce_sendlist_item *item;
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -406,7 +406,7 @@ int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
 			       void *per_recv_context,
 			       u32 buffer)
 {
-	struct ce_ring_state *dest_ring = ce_state->dest_ring;
+	struct ath10k_ce_ring *dest_ring = ce_state->dest_ring;
 	u32 ctrl_addr = ce_state->ctrl_addr;
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -457,7 +457,7 @@ static int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
 						unsigned int *transfer_idp,
 						unsigned int *flagsp)
 {
-	struct ce_ring_state *dest_ring = ce_state->dest_ring;
+	struct ath10k_ce_ring *dest_ring = ce_state->dest_ring;
 	unsigned int nentries_mask = dest_ring->nentries_mask;
 	unsigned int sw_index = dest_ring->sw_index;
 
@@ -531,7 +531,7 @@ int ath10k_ce_revoke_recv_next(struct ath10k_ce_pipe *ce_state,
 			       void **per_transfer_contextp,
 			       u32 *bufferp)
 {
-	struct ce_ring_state *dest_ring;
+	struct ath10k_ce_ring *dest_ring;
 	unsigned int nentries_mask;
 	unsigned int sw_index;
 	unsigned int write_index;
@@ -589,7 +589,7 @@ static int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 						unsigned int *nbytesp,
 						unsigned int *transfer_idp)
 {
-	struct ce_ring_state *src_ring = ce_state->src_ring;
+	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
 	u32 ctrl_addr = ce_state->ctrl_addr;
 	struct ath10k *ar = ce_state->ar;
 	unsigned int nentries_mask = src_ring->nentries_mask;
@@ -646,7 +646,7 @@ int ath10k_ce_cancel_send_next(struct ath10k_ce_pipe *ce_state,
 			       unsigned int *nbytesp,
 			       unsigned int *transfer_idp)
 {
-	struct ce_ring_state *src_ring;
+	struct ath10k_ce_ring *src_ring;
 	unsigned int nentries_mask;
 	unsigned int sw_index;
 	unsigned int write_index;
@@ -894,7 +894,7 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 				   const struct ce_attr *attr)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ce_ring_state *src_ring;
+	struct ath10k_ce_ring *src_ring;
 	unsigned int nentries = attr->src_nentries;
 	unsigned int ce_nbytes;
 	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
@@ -908,15 +908,15 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 		return 0;
 	}
 
-	ce_nbytes = sizeof(struct ce_ring_state) + (nentries * sizeof(void *));
+	ce_nbytes = sizeof(struct ath10k_ce_ring) + (nentries * sizeof(void *));
 	ptr = kzalloc(ce_nbytes, GFP_KERNEL);
 	if (ptr == NULL)
 		return -ENOMEM;
 
-	ce_state->src_ring = (struct ce_ring_state *)ptr;
+	ce_state->src_ring = (struct ath10k_ce_ring *)ptr;
 	src_ring = ce_state->src_ring;
 
-	ptr += sizeof(struct ce_ring_state);
+	ptr += sizeof(struct ath10k_ce_ring);
 	src_ring->nentries = nentries;
 	src_ring->nentries_mask = nentries - 1;
 
@@ -997,7 +997,7 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 				    const struct ce_attr *attr)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ce_ring_state *dest_ring;
+	struct ath10k_ce_ring *dest_ring;
 	unsigned int nentries = attr->dest_nentries;
 	unsigned int ce_nbytes;
 	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
@@ -1011,15 +1011,15 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 		return 0;
 	}
 
-	ce_nbytes = sizeof(struct ce_ring_state) + (nentries * sizeof(void *));
+	ce_nbytes = sizeof(struct ath10k_ce_ring) + (nentries * sizeof(void *));
 	ptr = kzalloc(ce_nbytes, GFP_KERNEL);
 	if (ptr == NULL)
 		return -ENOMEM;
 
-	ce_state->dest_ring = (struct ce_ring_state *)ptr;
+	ce_state->dest_ring = (struct ath10k_ce_ring *)ptr;
 	dest_ring = ce_state->dest_ring;
 
-	ptr += sizeof(struct ce_ring_state);
+	ptr += sizeof(struct ath10k_ce_ring);
 	dest_ring->nentries = nentries;
 	dest_ring->nentries_mask = nentries - 1;
 
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 1267b49..0ccf235 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -50,8 +50,7 @@ struct ce_desc {
 	__le16 flags; /* %CE_DESC_FLAGS_ */
 };
 
-/* Copy Engine Ring internal state */
-struct ce_ring_state {
+struct ath10k_ce_ring {
 	/* Number of entries in this ring; must be power of 2 */
 	unsigned int nentries;
 	unsigned int nentries_mask;
@@ -130,8 +129,8 @@ struct ath10k_ce_pipe {
 			 unsigned int flags);
 
 	unsigned int src_sz_max;
-	struct ce_ring_state *src_ring;
-	struct ce_ring_state *dest_ring;
+	struct ath10k_ce_ring *src_ring;
+	struct ath10k_ce_ring *dest_ring;
 };
 
 struct ce_sendlist_item {
-- 
1.7.9.5

