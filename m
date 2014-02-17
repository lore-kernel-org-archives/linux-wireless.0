Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:47580 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaBQJiC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 04:38:02 -0500
Received: by mail-ea0-f178.google.com with SMTP id a15so7207172eae.9
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 01:38:01 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT 6/7] ath10k: remove pci completion list
Date: Mon, 17 Feb 2014 10:32:42 +0100
Message-Id: <1392629563-31046-7-git-send-email-michal.kazior@tieto.com> (sfid-20140217_103816_037764_7F3BCFE9)
In-Reply-To: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of the premises was to guarantee serialized
completion handling for upper layers
(HTC/WMI/HTT). Since quite some time now it is no
longer necessary.

The other premise was to batch up tx/rx
completions to take advantage of hot caches.
However frame tx/rx completion indications come in
on a single pipe already so they are already
batched up. More meaningful batching is done in
HTT itself.

This means PCI completion is no longer necessary
to keep around. It just wastes memory, cycles and
SLOC.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 275 +++-------------------------------
 drivers/net/wireless/ath/ath10k/pci.h |  28 ----
 2 files changed, 24 insertions(+), 279 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 2305d58..9d242d8 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -58,7 +58,6 @@ static DEFINE_PCI_DEVICE_TABLE(ath10k_pci_id_table) = {
 static int ath10k_pci_diag_read_access(struct ath10k *ar, u32 address,
 				       u32 *data);
 
-static void ath10k_pci_process_ce(struct ath10k *ar);
 static int ath10k_pci_post_rx(struct ath10k *ar);
 static int ath10k_pci_post_rx_pipe(struct ath10k_pci_pipe *pipe_info,
 					     int num);
@@ -73,7 +72,6 @@ static void ath10k_pci_free_irq(struct ath10k *ar);
 static int ath10k_pci_bmi_wait(struct ath10k_ce_pipe *tx_pipe,
 			       struct ath10k_ce_pipe *rx_pipe,
 			       struct bmi_xfer *xfer);
-static void ath10k_pci_cleanup_ce(struct ath10k *ar);
 
 static const struct ce_attr host_ce_config_wlan[] = {
 	/* CE0: host->target HTC control and raw streams */
@@ -678,34 +676,12 @@ void ath10k_do_pci_sleep(struct ath10k *ar)
 	}
 }
 
-/*
- * FIXME: Handle OOM properly.
- */
-static inline
-struct ath10k_pci_compl *get_free_compl(struct ath10k_pci_pipe *pipe_info)
-{
-	struct ath10k_pci_compl *compl = NULL;
-
-	spin_lock_bh(&pipe_info->pipe_lock);
-	if (list_empty(&pipe_info->compl_free)) {
-		ath10k_warn("Completion buffers are full\n");
-		goto exit;
-	}
-	compl = list_first_entry(&pipe_info->compl_free,
-				 struct ath10k_pci_compl, list);
-	list_del(&compl->list);
-exit:
-	spin_unlock_bh(&pipe_info->pipe_lock);
-	return compl;
-}
-
 /* Called by lower (CE) layer when a send to Target completes. */
 static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state)
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_pci_pipe *pipe_info =  &ar_pci->pipe_info[ce_state->id];
-	struct ath10k_pci_compl *compl;
+	struct ath10k_hif_cb *cb = &ar_pci->msg_callbacks_current;
 	void *transfer_context;
 	u32 ce_data;
 	unsigned int nbytes;
@@ -718,27 +694,8 @@ static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state)
 		if (transfer_context == NULL)
 			continue;
 
-		compl = get_free_compl(pipe_info);
-		if (!compl)
-			break;
-
-		compl->state = ATH10K_PCI_COMPL_SEND;
-		compl->ce_state = ce_state;
-		compl->pipe_info = pipe_info;
-		compl->skb = transfer_context;
-		compl->nbytes = nbytes;
-		compl->transfer_id = transfer_id;
-		compl->flags = 0;
-
-		/*
-		 * Add the completion to the processing queue.
-		 */
-		spin_lock_bh(&ar_pci->compl_lock);
-		list_add_tail(&compl->list, &ar_pci->compl_process);
-		spin_unlock_bh(&ar_pci->compl_lock);
+		cb->tx_completion(ar, transfer_context, transfer_id);
 	}
-
-	ath10k_pci_process_ce(ar);
 }
 
 /* Called by lower (CE) layer when data is received from the Target. */
@@ -747,42 +704,40 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_pipe *pipe_info =  &ar_pci->pipe_info[ce_state->id];
-	struct ath10k_pci_compl *compl;
+	struct ath10k_hif_cb *cb = &ar_pci->msg_callbacks_current;
 	struct sk_buff *skb;
 	void *transfer_context;
 	u32 ce_data;
-	unsigned int nbytes;
+	unsigned int nbytes, max_nbytes;
 	unsigned int transfer_id;
 	unsigned int flags;
+	int err;
 
 	while (ath10k_ce_completed_recv_next(ce_state, &transfer_context,
 					     &ce_data, &nbytes, &transfer_id,
 					     &flags) == 0) {
-		compl = get_free_compl(pipe_info);
-		if (!compl)
-			break;
-
-		compl->state = ATH10K_PCI_COMPL_RECV;
-		compl->ce_state = ce_state;
-		compl->pipe_info = pipe_info;
-		compl->skb = transfer_context;
-		compl->nbytes = nbytes;
-		compl->transfer_id = transfer_id;
-		compl->flags = flags;
+		err = ath10k_pci_post_rx_pipe(pipe_info, 1);
+		if (unlikely(err)) {
+			/* FIXME: retry */
+			ath10k_warn("failed to replenish CE rx ring %d: %d\n",
+				    pipe_info->pipe_num, err);
+		}
 
 		skb = transfer_context;
+		max_nbytes = skb->len + skb_tailroom(skb);
 		dma_unmap_single(ar->dev, ATH10K_SKB_CB(skb)->paddr,
-				 skb->len + skb_tailroom(skb),
-				 DMA_FROM_DEVICE);
-		/*
-		 * Add the completion to the processing queue.
-		 */
-		spin_lock_bh(&ar_pci->compl_lock);
-		list_add_tail(&compl->list, &ar_pci->compl_process);
-		spin_unlock_bh(&ar_pci->compl_lock);
-	}
+				 max_nbytes, DMA_FROM_DEVICE);
 
-	ath10k_pci_process_ce(ar);
+		if (unlikely(max_nbytes < nbytes)) {
+			ath10k_warn("rxed more than expected (nbytes %d, max %d)",
+				    nbytes, max_nbytes);
+			dev_kfree_skb_any(skb);
+			continue;
+		}
+
+		skb_put(skb, nbytes);
+		cb->rx_completion(ar, skb, pipe_info->pipe_num);
+	}
 }
 
 static int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
@@ -931,52 +886,6 @@ static void ath10k_pci_hif_set_callbacks(struct ath10k *ar,
 	       sizeof(ar_pci->msg_callbacks_current));
 }
 
-static int ath10k_pci_alloc_compl(struct ath10k *ar)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	const struct ce_attr *attr;
-	struct ath10k_pci_pipe *pipe_info;
-	struct ath10k_pci_compl *compl;
-	int i, pipe_num, completions;
-
-	spin_lock_init(&ar_pci->compl_lock);
-	INIT_LIST_HEAD(&ar_pci->compl_process);
-
-	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
-		pipe_info = &ar_pci->pipe_info[pipe_num];
-
-		spin_lock_init(&pipe_info->pipe_lock);
-		INIT_LIST_HEAD(&pipe_info->compl_free);
-
-		/* Handle Diagnostic CE specially */
-		if (pipe_info->ce_hdl == ar_pci->ce_diag)
-			continue;
-
-		attr = &host_ce_config_wlan[pipe_num];
-		completions = 0;
-
-		if (attr->src_nentries)
-			completions += attr->src_nentries;
-
-		if (attr->dest_nentries)
-			completions += attr->dest_nentries;
-
-		for (i = 0; i < completions; i++) {
-			compl = kmalloc(sizeof(*compl), GFP_KERNEL);
-			if (!compl) {
-				ath10k_warn("No memory for completion state\n");
-				ath10k_pci_cleanup_ce(ar);
-				return -ENOMEM;
-			}
-
-			compl->state = ATH10K_PCI_COMPL_FREE;
-			list_add_tail(&compl->list, &pipe_info->compl_free);
-		}
-	}
-
-	return 0;
-}
-
 static int ath10k_pci_setup_ce_irq(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1021,131 +930,6 @@ static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 		tasklet_kill(&ar_pci->pipe_info[i].intr);
 }
 
-static void ath10k_pci_cleanup_ce(struct ath10k *ar)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_pci_compl *compl, *tmp;
-	struct ath10k_pci_pipe *pipe_info;
-	struct sk_buff *netbuf;
-	int pipe_num;
-
-	/* Free pending completions. */
-	spin_lock_bh(&ar_pci->compl_lock);
-	if (!list_empty(&ar_pci->compl_process))
-		ath10k_warn("pending completions still present! possible memory leaks.\n");
-
-	list_for_each_entry_safe(compl, tmp, &ar_pci->compl_process, list) {
-		list_del(&compl->list);
-		netbuf = compl->skb;
-		dev_kfree_skb_any(netbuf);
-		kfree(compl);
-	}
-	spin_unlock_bh(&ar_pci->compl_lock);
-
-	/* Free unused completions for each pipe. */
-	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
-		pipe_info = &ar_pci->pipe_info[pipe_num];
-
-		spin_lock_bh(&pipe_info->pipe_lock);
-		list_for_each_entry_safe(compl, tmp,
-					 &pipe_info->compl_free, list) {
-			list_del(&compl->list);
-			kfree(compl);
-		}
-		spin_unlock_bh(&pipe_info->pipe_lock);
-	}
-}
-
-static void ath10k_pci_process_ce(struct ath10k *ar)
-{
-	struct ath10k_pci *ar_pci = ar->hif.priv;
-	struct ath10k_hif_cb *cb = &ar_pci->msg_callbacks_current;
-	struct ath10k_pci_compl *compl;
-	struct sk_buff *skb;
-	unsigned int nbytes;
-	int ret, send_done = 0;
-
-	/* Upper layers aren't ready to handle tx/rx completions in parallel so
-	 * we must serialize all completion processing. */
-
-	spin_lock_bh(&ar_pci->compl_lock);
-	if (ar_pci->compl_processing) {
-		spin_unlock_bh(&ar_pci->compl_lock);
-		return;
-	}
-	ar_pci->compl_processing = true;
-	spin_unlock_bh(&ar_pci->compl_lock);
-
-	for (;;) {
-		spin_lock_bh(&ar_pci->compl_lock);
-		if (list_empty(&ar_pci->compl_process)) {
-			spin_unlock_bh(&ar_pci->compl_lock);
-			break;
-		}
-		compl = list_first_entry(&ar_pci->compl_process,
-					 struct ath10k_pci_compl, list);
-		list_del(&compl->list);
-		spin_unlock_bh(&ar_pci->compl_lock);
-
-		switch (compl->state) {
-		case ATH10K_PCI_COMPL_SEND:
-			cb->tx_completion(ar,
-					  compl->skb,
-					  compl->transfer_id);
-			send_done = 1;
-			break;
-		case ATH10K_PCI_COMPL_RECV:
-			ret = ath10k_pci_post_rx_pipe(compl->pipe_info, 1);
-			if (ret) {
-				ath10k_warn("failed to post RX buffer for pipe %d: %d\n",
-					    compl->pipe_info->pipe_num, ret);
-				break;
-			}
-
-			skb = compl->skb;
-			nbytes = compl->nbytes;
-
-			ath10k_dbg(ATH10K_DBG_PCI,
-				   "ath10k_pci_ce_recv_data netbuf=%p  nbytes=%d\n",
-				   skb, nbytes);
-			ath10k_dbg_dump(ATH10K_DBG_PCI_DUMP, NULL,
-					"ath10k rx: ", skb->data, nbytes);
-
-			if (skb->len + skb_tailroom(skb) >= nbytes) {
-				skb_trim(skb, 0);
-				skb_put(skb, nbytes);
-				cb->rx_completion(ar, skb,
-						  compl->pipe_info->pipe_num);
-			} else {
-				ath10k_warn("rxed more than expected (nbytes %d, max %d)",
-					    nbytes,
-					    skb->len + skb_tailroom(skb));
-			}
-			break;
-		case ATH10K_PCI_COMPL_FREE:
-			ath10k_warn("free completion cannot be processed\n");
-			break;
-		default:
-			ath10k_warn("invalid completion state (%d)\n",
-				    compl->state);
-			break;
-		}
-
-		compl->state = ATH10K_PCI_COMPL_FREE;
-
-		/*
-		 * Add completion back to the pipe's free list.
-		 */
-		spin_lock_bh(&compl->pipe_info->pipe_lock);
-		list_add_tail(&compl->list, &compl->pipe_info->compl_free);
-		spin_unlock_bh(&compl->pipe_info->pipe_lock);
-	}
-
-	spin_lock_bh(&ar_pci->compl_lock);
-	ar_pci->compl_processing = false;
-	spin_unlock_bh(&ar_pci->compl_lock);
-}
-
 /* TODO - temporary mapping while we have too few CE's */
 static int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar,
 					      u16 service_id, u8 *ul_pipe,
@@ -1317,17 +1101,11 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 
-	ret = ath10k_pci_alloc_compl(ar);
-	if (ret) {
-		ath10k_warn("failed to allocate CE completions: %d\n", ret);
-		goto err_early_irq;
-	}
-
 	ret = ath10k_pci_request_irq(ar);
 	if (ret) {
 		ath10k_warn("failed to post RX buffers for all pipes: %d\n",
 			    ret);
-		goto err_free_compl;
+		goto err_early_irq;
 	}
 
 	ret = ath10k_pci_setup_ce_irq(ar);
@@ -1351,9 +1129,6 @@ err_stop:
 	ath10k_ce_disable_interrupts(ar);
 	ath10k_pci_free_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
-	ath10k_pci_process_ce(ar);
-err_free_compl:
-	ath10k_pci_cleanup_ce(ar);
 err_early_irq:
 	/* Though there should be no interrupts (device was reset)
 	 * power_down() expects the early IRQ to be installed as per the
@@ -1494,8 +1269,6 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	 * not DMA nor interrupt. We process the leftovers and then free
 	 * everything else up. */
 
-	ath10k_pci_process_ce(ar);
-	ath10k_pci_cleanup_ce(ar);
 	ath10k_pci_buffer_cleanup(ar);
 
 	/* Make the sure the device won't access any structures on the host by
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index a4f3203..b43fdb4 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -43,23 +43,6 @@ struct bmi_xfer {
 	u32 resp_len;
 };
 
-enum ath10k_pci_compl_state {
-	ATH10K_PCI_COMPL_FREE = 0,
-	ATH10K_PCI_COMPL_SEND,
-	ATH10K_PCI_COMPL_RECV,
-};
-
-struct ath10k_pci_compl {
-	struct list_head list;
-	enum ath10k_pci_compl_state state;
-	struct ath10k_ce_pipe *ce_state;
-	struct ath10k_pci_pipe *pipe_info;
-	struct sk_buff *skb;
-	unsigned int nbytes;
-	unsigned int transfer_id;
-	unsigned int flags;
-};
-
 /*
  * PCI-specific Target state
  *
@@ -175,9 +158,6 @@ struct ath10k_pci_pipe {
 	/* protects compl_free and num_send_allowed */
 	spinlock_t pipe_lock;
 
-	/* List of free CE completion slots */
-	struct list_head compl_free;
-
 	struct ath10k_pci *ar_pci;
 	struct tasklet_struct intr;
 };
@@ -205,14 +185,6 @@ struct ath10k_pci {
 	atomic_t keep_awake_count;
 	bool verified_awake;
 
-	/* List of CE completions to be processed */
-	struct list_head compl_process;
-
-	/* protects compl_processing and compl_process */
-	spinlock_t compl_lock;
-
-	bool compl_processing;
-
 	struct ath10k_pci_pipe pipe_info[CE_COUNT_MAX];
 
 	struct ath10k_hif_cb msg_callbacks_current;
-- 
1.8.5.3

