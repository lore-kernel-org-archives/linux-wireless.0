Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34818 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbbALTsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 14:48:45 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 7/8] ath10k:  start using htt/pci/ce transfer_id properly.
Date: Mon, 12 Jan 2015 10:32:43 -0800
Message-Id: <1421087564-10384-7-git-send-email-greearb@candelatech.com> (sfid-20150112_204849_625515_13CAB049)
In-Reply-To: <1421087564-10384-1-git-send-email-greearb@candelatech.com>
References: <1421087564-10384-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Upstream firmware may ingore, but someone hacking on firmware
can use this (and similar instrumentation on the firmware side)
to help determine what is happening when there are communication
issues between firmware and host.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/ce.c     |  1 +
 drivers/net/wireless/ath/ath10k/ce.h     |  7 +++++++
 drivers/net/wireless/ath/ath10k/htc.c    |  2 +-
 drivers/net/wireless/ath/ath10k/htc.h    |  1 +
 drivers/net/wireless/ath/ath10k/htt.h    |  1 +
 drivers/net/wireless/ath/ath10k/htt_tx.c |  6 ++++--
 drivers/net/wireless/ath/ath10k/pci.c    | 31 +++++++++++++++++++++++--------
 7 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index a156e6e..ecc6d0c 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -319,6 +319,7 @@ int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 		ath10k_ce_src_ring_write_index_set(ar, ctrl_addr, write_index);
 
 	src_ring->write_index = write_index;
+	ce_state->last_tx_transfer_id = transfer_id;
 exit:
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 617a151..f4919e9 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -120,6 +120,13 @@ struct ath10k_ce_pipe {
 	unsigned int src_sz_max;
 	struct ath10k_ce_ring *src_ring;
 	struct ath10k_ce_ring *dest_ring;
+
+	/* Some fields used for debugging */
+	unsigned int last_rx_transfer_id;
+	unsigned int last_ce_send_done_transfer_id;
+	unsigned int last_tx_transfer_id;
+	unsigned int last_bmi_send_done_transfer_id;
+	unsigned int last_bmi_recv_transfer_id;
 };
 
 /* Copy Engine settable attributes */
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 16b939a..97139ce 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -160,7 +160,7 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 	if (ret)
 		goto err_credits;
 
-	sg_item.transfer_id = ep->eid;
+	sg_item.transfer_id = ep->next_transfer_id++;
 	sg_item.transfer_context = skb;
 	sg_item.vaddr = skb->data;
 	sg_item.paddr = skb_cb->paddr;
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 527179c..db99593 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -316,6 +316,7 @@ struct ath10k_htc_ep {
 	int dl_is_polled; /* call HIF to fetch rx (not implemented) */
 
 	u8 seq_no; /* for debugging */
+	u16 next_transfer_id; /* for debugging */
 	int tx_credits;
 	int tx_credit_size;
 	int tx_credits_per_max_message;
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 4dede95..5ebf968 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1223,6 +1223,7 @@ struct ath10k_htt {
 	int max_throughput_mbps;
 	u8 target_version_major;
 	u8 target_version_minor;
+	u16 htt_transfer_id;
 	struct completion target_version_received;
 
 	struct {
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index b7937b9..bd1236e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -456,6 +456,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	dma_addr_t paddr;
 	u32 frags_paddr;
 	bool use_frags;
+	unsigned int htt_transfer_id;
 
 	res = ath10k_htt_tx_inc_pending(htt);
 	if (res)
@@ -469,6 +470,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	}
 	msdu_id = res;
 	htt->pending_tx[msdu_id] = msdu;
+	htt_transfer_id = htt->htt_transfer_id++;
 	spin_unlock_bh(&htt->tx_lock);
 
 	prefetch_len = min(htt->prefetch_len, msdu->len);
@@ -569,7 +571,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	trace_ath10k_tx_hdr(ar, msdu->data, msdu->len);
 	trace_ath10k_tx_payload(ar, msdu->data, msdu->len);
 
-	sg_items[0].transfer_id = 0;
+	sg_items[0].transfer_id = htt_transfer_id;
 	sg_items[0].transfer_context = NULL;
 	sg_items[0].vaddr = &skb_cb->htt.txbuf->htc_hdr;
 	sg_items[0].paddr = skb_cb->htt.txbuf_paddr +
@@ -578,7 +580,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 			  sizeof(skb_cb->htt.txbuf->cmd_hdr) +
 			  sizeof(skb_cb->htt.txbuf->cmd_tx);
 
-	sg_items[1].transfer_id = 0;
+	sg_items[1].transfer_id = sg_items[0].transfer_id;
 	sg_items[1].transfer_context = NULL;
 	sg_items[1].vaddr = msdu->data;
 	sg_items[1].paddr = skb_cb->paddr;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index dee0d5a..b35590e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -846,11 +846,11 @@ static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state)
 	struct sk_buff *skb;
 	u32 ce_data;
 	unsigned int nbytes;
-	unsigned int transfer_id;
 
 	__skb_queue_head_init(&list);
 	while (ath10k_ce_completed_send_next(ce_state, (void **)&skb, &ce_data,
-					     &nbytes, &transfer_id) == 0) {
+					     &nbytes,
+					     &ce_state->last_ce_send_done_transfer_id) == 0) {
 		/* no need to call tx completion for NULL pointers */
 		if (skb == NULL)
 			continue;
@@ -874,12 +874,11 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 	void *transfer_context;
 	u32 ce_data;
 	unsigned int nbytes, max_nbytes;
-	unsigned int transfer_id;
 	unsigned int flags;
 
 	__skb_queue_head_init(&list);
 	while (ath10k_ce_completed_recv_next(ce_state, &transfer_context,
-					     &ce_data, &nbytes, &transfer_id,
+					     &ce_data, &nbytes, &ce_state->last_rx_transfer_id,
 					     &flags) == 0) {
 		skb = transfer_context;
 		max_nbytes = skb->len + skb_tailroom(skb);
@@ -1209,6 +1208,8 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 {
 	struct ath10k_fw_crash_data *crash_data;
 	char uuid[50];
+	struct ath10k_pci *pci;
+	int i;
 
 	spin_lock_bh(&ar->data_lock);
 
@@ -1234,6 +1235,19 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 
 	spin_unlock_bh(&ar->data_lock);
 
+	/* Print out some info on the CE pipes */
+	pci = ath10k_pci_priv(ar);
+	for (i = 0; i<CE_COUNT_MAX; i++) {
+		ath10k_err(ar, "ce-pipe [%i] rx-id: %i  ce-send-done: %d tx-id: %d bmi-send-done: %d bmi-recv: %d\n",
+			   i,
+			   pci->ce_states[i].last_rx_transfer_id,
+			   pci->ce_states[i].last_ce_send_done_transfer_id,
+			   pci->ce_states[i].last_tx_transfer_id,
+			   pci->ce_states[i].last_bmi_send_done_transfer_id,
+			   pci->ce_states[i].last_bmi_recv_transfer_id);
+	}
+	ath10k_err(ar, "last htt-tx-id: %d\n", ar->htt.htt_transfer_id);
+
 	queue_work(ar->workqueue, &ar->restart_work);
 }
 
@@ -1640,10 +1654,10 @@ static void ath10k_pci_bmi_send_done(struct ath10k_ce_pipe *ce_state)
 	struct bmi_xfer *xfer;
 	u32 ce_data;
 	unsigned int nbytes;
-	unsigned int transfer_id;
 
 	if (ath10k_ce_completed_send_next(ce_state, (void **)&xfer, &ce_data,
-					  &nbytes, &transfer_id))
+					  &nbytes,
+					  &ce_state->last_bmi_send_done_transfer_id))
 		return;
 
 	xfer->tx_done = true;
@@ -1655,11 +1669,12 @@ static void ath10k_pci_bmi_recv_data(struct ath10k_ce_pipe *ce_state)
 	struct bmi_xfer *xfer;
 	u32 ce_data;
 	unsigned int nbytes;
-	unsigned int transfer_id;
 	unsigned int flags;
 
 	if (ath10k_ce_completed_recv_next(ce_state, (void **)&xfer, &ce_data,
-					  &nbytes, &transfer_id, &flags))
+					  &nbytes,
+					  &ce_state->last_bmi_recv_transfer_id,
+					  &flags))
 		return;
 
 	if (WARN_ON_ONCE(!xfer))
-- 
1.7.11.7

