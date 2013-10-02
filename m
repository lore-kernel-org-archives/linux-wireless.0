Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:58257 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380Ab3JBJDx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 05:03:53 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/4] ath10k: remove ce_sendlist_send
Date: Wed, 2 Oct 2013 11:03:40 +0200
Message-ID: <1380704621-4670-4-git-send-email-michal.kazior@tieto.com> (sfid-20131002_110400_270200_A58A8984)
In-Reply-To: <1380704621-4670-1-git-send-email-michal.kazior@tieto.com>
References: <1380292706-3609-1-git-send-email-michal.kazior@tieto.com>
 <1380704621-4670-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is completely pointless to keep this function
around. It doesn't do anything different than
ce_send except it introduces more overhead.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |   34 ---------------------------------
 drivers/net/wireless/ath/ath10k/ce.h  |   15 ---------------
 drivers/net/wireless/ath/ath10k/pci.c |    4 ++--
 3 files changed, 2 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 834e29e..9e6daa9 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -338,40 +338,6 @@ int ath10k_ce_send(struct ath10k_ce_pipe *ce_state,
 	return ret;
 }
 
-int ath10k_ce_sendlist_send(struct ath10k_ce_pipe *ce_state,
-			    void *per_transfer_context,
-			    unsigned int transfer_id,
-			    u32 paddr, unsigned int nbytes,
-			    u32 flags)
-{
-	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
-	struct ath10k *ar = ce_state->ar;
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	unsigned int nentries_mask = src_ring->nentries_mask;
-	unsigned int sw_index;
-	unsigned int write_index;
-	int delta, ret = -ENOMEM;
-
-	spin_lock_bh(&ar_pci->ce_lock);
-
-	sw_index = src_ring->sw_index;
-	write_index = src_ring->write_index;
-
-	delta = CE_RING_DELTA(nentries_mask, write_index, sw_index - 1);
-
-	if (delta >= 1) {
-		ret = ath10k_ce_send_nolock(ce_state, per_transfer_context,
-					    paddr, nbytes,
-					    transfer_id, flags);
-		if (ret)
-			ath10k_warn("CE send failed: %d\n", ret);
-	}
-
-	spin_unlock_bh(&ar_pci->ce_lock);
-
-	return ret;
-}
-
 int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
 			       void *per_recv_context,
 			       u32 buffer)
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index aec8028..949b174 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -156,21 +156,6 @@ void ath10k_ce_send_cb_register(struct ath10k_ce_pipe *ce_state,
 				void (*send_cb)(struct ath10k_ce_pipe *),
 				int disable_interrupts);
 
-/*
- * Queue a "sendlist" of buffers to be sent using gather to a single
- * anonymous destination buffer
- *   ce         - which copy engine to use
- *   sendlist        - list of simple buffers to send using gather
- *   transfer_id     - arbitrary ID; reflected to destination
- * Returns 0 on success; otherwise an error status.
- *
- * Implemenation note: Pushes multiple buffers with Gather to Source ring.
- */
-int ath10k_ce_sendlist_send(struct ath10k_ce_pipe *ce_state,
-			    void *per_transfer_context,
-			    unsigned int transfer_id,
-			    u32 paddr, unsigned int nbytes,
-			    u32 flags);
 
 /*==================Recv=======================*/
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index dff23d9..4f6a978 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -730,8 +730,8 @@ static int ath10k_pci_hif_send_head(struct ath10k *ar, u8 pipe_id,
 	pipe_info->num_sends_allowed--;
 	spin_unlock_bh(&pipe_info->pipe_lock);
 
-	ret = ath10k_ce_sendlist_send(ce_hdl, nbuf, transfer_id,
-				      skb_cb->paddr, len, flags);
+	ret = ath10k_ce_send(ce_hdl, nbuf, skb_cb->paddr, len, transfer_id,
+			     flags);
 	if (ret)
 		ath10k_warn("CE send failed: %p\n", nbuf);
 
-- 
1.7.9.5

