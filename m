Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:49051 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab3I0Oii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 10:38:38 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/4] ath10k: remove num_sends_allowed
Date: Fri, 27 Sep 2013 16:38:26 +0200
Message-ID: <1380292706-3609-5-git-send-email-michal.kazior@tieto.com> (sfid-20130927_163843_891977_8C49E900)
In-Reply-To: <1380292706-3609-1-git-send-email-michal.kazior@tieto.com>
References: <1380292706-3609-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The value provided by num_sends_allowed is now
derived from CE source ringbuffer state.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |   17 ++++++++++++++++-
 drivers/net/wireless/ath/ath10k/ce.h  |    1 +
 drivers/net/wireless/ath/ath10k/pci.c |   21 +--------------------
 drivers/net/wireless/ath/ath10k/pci.h |    3 ---
 4 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 9e6daa9..e46951b 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -283,7 +283,7 @@ static int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 
 	if (unlikely(CE_RING_DELTA(nentries_mask,
 				   write_index, sw_index - 1) <= 0)) {
-		ret = -EIO;
+		ret = -ENOSR;
 		goto exit;
 	}
 
@@ -338,6 +338,21 @@ int ath10k_ce_send(struct ath10k_ce_pipe *ce_state,
 	return ret;
 }
 
+int ath10k_ce_num_free_src_entries(struct ath10k_ce_pipe *pipe)
+{
+	struct ath10k *ar = pipe->ar;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int delta;
+
+	spin_lock_bh(&ar_pci->ce_lock);
+	delta = CE_RING_DELTA(pipe->src_ring->nentries_mask,
+			      pipe->src_ring->write_index,
+			      pipe->src_ring->sw_index - 1);
+	spin_unlock_bh(&ar_pci->ce_lock);
+
+	return delta;
+}
+
 int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
 			       void *per_recv_context,
 			       u32 buffer)
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 949b174..15d45b5 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -156,6 +156,7 @@ void ath10k_ce_send_cb_register(struct ath10k_ce_pipe *ce_state,
 				void (*send_cb)(struct ath10k_ce_pipe *),
 				int disable_interrupts);
 
+int ath10k_ce_num_free_src_entries(struct ath10k_ce_pipe *pipe);
 
 /*==================Recv=======================*/
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 4f6a978..f8d59c7 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -720,16 +720,6 @@ static int ath10k_pci_hif_send_head(struct ath10k *ar, u8 pipe_id,
 			"ath10k tx: data: ",
 			nbuf->data, nbuf->len);
 
-	/* Make sure we have resources to handle this request */
-	spin_lock_bh(&pipe_info->pipe_lock);
-	if (!pipe_info->num_sends_allowed) {
-		ath10k_warn("Pipe: %d is full\n", pipe_id);
-		spin_unlock_bh(&pipe_info->pipe_lock);
-		return -ENOSR;
-	}
-	pipe_info->num_sends_allowed--;
-	spin_unlock_bh(&pipe_info->pipe_lock);
-
 	ret = ath10k_ce_send(ce_hdl, nbuf, skb_cb->paddr, len, transfer_id,
 			     flags);
 	if (ret)
@@ -741,14 +731,7 @@ static int ath10k_pci_hif_send_head(struct ath10k *ar, u8 pipe_id,
 static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_pci_pipe *pipe_info = &(ar_pci->pipe_info[pipe]);
-	int ret;
-
-	spin_lock_bh(&pipe_info->pipe_lock);
-	ret = pipe_info->num_sends_allowed;
-	spin_unlock_bh(&pipe_info->pipe_lock);
-
-	return ret;
+	return ath10k_ce_num_free_src_entries(ar_pci->pipe_info[pipe].ce_hdl);
 }
 
 static void ath10k_pci_hif_dump_area(struct ath10k *ar)
@@ -863,7 +846,6 @@ static int ath10k_pci_start_ce(struct ath10k *ar)
 						   ath10k_pci_ce_send_done,
 						   disable_interrupts);
 			completions += attr->src_nentries;
-			pipe_info->num_sends_allowed = attr->src_nentries - 1;
 		}
 
 		if (attr->dest_nentries) {
@@ -1033,7 +1015,6 @@ static void ath10k_pci_process_ce(struct ath10k *ar)
 		 */
 		spin_lock_bh(&compl->pipe_info->pipe_lock);
 		list_add_tail(&compl->list, &compl->pipe_info->compl_free);
-		compl->pipe_info->num_sends_allowed += send_done;
 		spin_unlock_bh(&compl->pipe_info->pipe_lock);
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 7c49f6f..52fb7b9 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -178,9 +178,6 @@ struct ath10k_pci_pipe {
 	/* List of free CE completion slots */
 	struct list_head compl_free;
 
-	/* Limit the number of outstanding send requests. */
-	int num_sends_allowed;
-
 	struct ath10k_pci *ar_pci;
 	struct tasklet_struct intr;
 };
-- 
1.7.9.5

