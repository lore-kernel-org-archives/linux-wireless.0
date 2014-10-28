Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:51589 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaJ1JoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 05:44:04 -0400
Received: by mail-la0-f46.google.com with SMTP id hs14so248224lab.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2014 02:44:02 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 1/4] ath10k: change ce ring cleanup logic
Date: Tue, 28 Oct 2014 10:32:05 +0100
Message-Id: <1414488728-31489-2-git-send-email-michal.kazior@tieto.com> (sfid-20141028_104416_185381_18D032F2)
In-Reply-To: <1414488728-31489-1-git-send-email-michal.kazior@tieto.com>
References: <1414488728-31489-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make ath10k_pci_init_pipes() effectively only
alter shared target-host data.

The per_transfer_context is a host-only thing.
It is necessary to preserve it's contents for a
more robust ring cleanup.

This is required for future warm reset fixes.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v3:
     * introduced to fix memleak - warm reset will
       reinit rings/pipes in the future so it was
       necessary to rework how clean up of CE rings is
       performed

 drivers/net/wireless/ath/ath10k/ce.c  |  6 ---
 drivers/net/wireless/ath/ath10k/pci.c | 82 ++++++++++++++++++++---------------
 2 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 9b89ac1..878e1ec 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -835,9 +835,6 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 
 	nentries = roundup_pow_of_two(attr->src_nentries);
 
-	memset(src_ring->per_transfer_context, 0,
-	       nentries * sizeof(*src_ring->per_transfer_context));
-
 	src_ring->sw_index = ath10k_ce_src_ring_read_index_get(ar, ctrl_addr);
 	src_ring->sw_index &= src_ring->nentries_mask;
 	src_ring->hw_index = src_ring->sw_index;
@@ -872,9 +869,6 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 
 	nentries = roundup_pow_of_two(attr->dest_nentries);
 
-	memset(dest_ring->per_transfer_context, 0,
-	       nentries * sizeof(*dest_ring->per_transfer_context));
-
 	dest_ring->sw_index = ath10k_ce_dest_ring_read_index_get(ar, ctrl_addr);
 	dest_ring->sw_index &= dest_ring->nentries_mask;
 	dest_ring->write_index =
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 4a4740b..a8a3e1b 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1196,64 +1196,74 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 	return 0;
 }
 
-static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
+static void ath10k_pci_rx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
 {
 	struct ath10k *ar;
-	struct ath10k_pci *ar_pci;
-	struct ath10k_ce_pipe *ce_hdl;
-	u32 buf_sz;
-	struct sk_buff *netbuf;
-	u32 ce_data;
+	struct ath10k_ce_pipe *ce_pipe;
+	struct ath10k_ce_ring *ce_ring;
+	struct sk_buff *skb;
+	int i;
 
-	buf_sz = pipe_info->buf_sz;
+	ar = pci_pipe->hif_ce_state;
+	ce_pipe = pci_pipe->ce_hdl;
+	ce_ring = ce_pipe->dest_ring;
 
-	/* Unused Copy Engine */
-	if (buf_sz == 0)
+	if (!ce_ring)
 		return;
 
-	ar = pipe_info->hif_ce_state;
-	ar_pci = ath10k_pci_priv(ar);
-	ce_hdl = pipe_info->ce_hdl;
+	if (!pci_pipe->buf_sz)
+		return;
 
-	while (ath10k_ce_revoke_recv_next(ce_hdl, (void **)&netbuf,
-					  &ce_data) == 0) {
-		dma_unmap_single(ar->dev, ATH10K_SKB_CB(netbuf)->paddr,
-				 netbuf->len + skb_tailroom(netbuf),
+	for (i = 0; i < ce_ring->nentries; i++) {
+		skb = ce_ring->per_transfer_context[i];
+		if (!skb)
+			continue;
+
+		ce_ring->per_transfer_context[i] = NULL;
+
+		dma_unmap_single(ar->dev, ATH10K_SKB_CB(skb)->paddr,
+				 skb->len + skb_tailroom(skb),
 				 DMA_FROM_DEVICE);
-		dev_kfree_skb_any(netbuf);
+		dev_kfree_skb_any(skb);
 	}
 }
 
-static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
+static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
 {
 	struct ath10k *ar;
 	struct ath10k_pci *ar_pci;
-	struct ath10k_ce_pipe *ce_hdl;
-	struct sk_buff *netbuf;
-	u32 ce_data;
-	unsigned int nbytes;
+	struct ath10k_ce_pipe *ce_pipe;
+	struct ath10k_ce_ring *ce_ring;
+	struct ce_desc *ce_desc;
+	struct sk_buff *skb;
 	unsigned int id;
-	u32 buf_sz;
+	int i;
 
-	buf_sz = pipe_info->buf_sz;
+	ar = pci_pipe->hif_ce_state;
+	ar_pci = ath10k_pci_priv(ar);
+	ce_pipe = pci_pipe->ce_hdl;
+	ce_ring = ce_pipe->src_ring;
 
-	/* Unused Copy Engine */
-	if (buf_sz == 0)
+	if (!ce_ring)
 		return;
 
-	ar = pipe_info->hif_ce_state;
-	ar_pci = ath10k_pci_priv(ar);
-	ce_hdl = pipe_info->ce_hdl;
+	if (!pci_pipe->buf_sz)
+		return;
 
-	while (ath10k_ce_cancel_send_next(ce_hdl, (void **)&netbuf,
-					  &ce_data, &nbytes, &id) == 0) {
-		/* no need to call tx completion for NULL pointers */
-		if (!netbuf)
+	ce_desc = ce_ring->shadow_base;
+	if (WARN_ON(!ce_desc))
+		return;
+
+	for (i = 0; i < ce_ring->nentries; i++) {
+		skb = ce_ring->per_transfer_context[i];
+		if (!skb)
 			continue;
 
-		ar_pci->msg_callbacks_current.tx_completion(ar,
-							    netbuf,
-							    id);
+		ce_ring->per_transfer_context[i] = NULL;
+		id = MS(__le16_to_cpu(ce_desc[i].flags),
+			CE_DESC_FLAGS_META_DATA);
+
+		ar_pci->msg_callbacks_current.tx_completion(ar, skb, id);
 	}
 }
 
-- 
1.8.5.3

