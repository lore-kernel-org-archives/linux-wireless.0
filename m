Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:64185 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaBQJh7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 04:37:59 -0500
Received: by mail-ea0-f177.google.com with SMTP id m10so4412205eaj.8
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 01:37:58 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT 4/7] ath10k: bypass htc for htt tx path
Date: Mon, 17 Feb 2014 10:32:40 +0100
Message-Id: <1392629563-31046-5-git-send-email-michal.kazior@tieto.com> (sfid-20140217_103819_915101_466D96B9)
In-Reply-To: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Going through full HTC tx path for HTT tx is a
waste of resources. By skipping it it's possible
to easily submit scatter-gather to the PCI HIF for
reduced host CPU load and improved performance.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c     |   4 +-
 drivers/net/wireless/ath/ath10k/ce.h     |   2 +-
 drivers/net/wireless/ath/ath10k/core.h   |   5 +-
 drivers/net/wireless/ath/ath10k/htc.c    |   4 +-
 drivers/net/wireless/ath/ath10k/htt.h    |   8 ++
 drivers/net/wireless/ath/ath10k/htt_tx.c | 190 ++++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/pci.c    |  12 +-
 drivers/net/wireless/ath/ath10k/txrx.c   |   6 +-
 8 files changed, 122 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index a0b1a8c..a79499c 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1067,9 +1067,9 @@ struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
 	 *
 	 * For the lack of a better place do the check here.
 	 */
-	BUILD_BUG_ON(TARGET_NUM_MSDU_DESC >
+	BUILD_BUG_ON(2*TARGET_NUM_MSDU_DESC >
 		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
-	BUILD_BUG_ON(TARGET_10X_NUM_MSDU_DESC >
+	BUILD_BUG_ON(2*TARGET_10X_NUM_MSDU_DESC >
 		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
 
 	ret = ath10k_pci_wake(ar);
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 322e929..8eb7f99 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -23,7 +23,7 @@
 
 /* Maximum number of Copy Engine's supported */
 #define CE_COUNT_MAX 8
-#define CE_HTT_H2T_MSG_SRC_NENTRIES 2048
+#define CE_HTT_H2T_MSG_SRC_NENTRIES 4096
 
 /* Descriptor rings must be aligned to this boundary */
 #define CE_DESC_RING_ALIGN	8
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7cf022d..f34019f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -67,9 +67,8 @@ struct ath10k_skb_cb {
 	struct {
 		u8 tid;
 		bool is_offchan;
-
-		u8 frag_len;
-		u8 pad_len;
+		struct ath10k_htt_txbuf *txbuf;
+		u32 txbuf_paddr;
 	} __packed htt;
 
 	struct {
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 64ab8d6..1491ce7 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -202,10 +202,8 @@ static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
 	struct ath10k_htc *htc = &ar->htc;
 	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
 
-	if (!skb) {
-		ath10k_warn("invalid sk_buff completion - NULL pointer. firmware crashed?\n");
+	if (WARN_ON(!skb))
 		return 0;
-	}
 
 	ath10k_htc_notify_tx_completion(ep, skb);
 	/* the skb now belongs to the completion handler */
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 02c009d..782a449 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1188,6 +1188,13 @@ struct htt_rx_info {
 	bool mic_err;
 };
 
+struct ath10k_htt_txbuf {
+	struct htt_data_tx_desc_frag frags[2];
+	struct ath10k_htc_hdr htc_hdr;
+	struct htt_cmd_hdr cmd_hdr;
+	struct htt_data_tx_desc cmd_tx;
+} __packed;
+
 struct ath10k_htt {
 	struct ath10k *ar;
 	enum ath10k_htc_ep_id eid;
@@ -1269,6 +1276,7 @@ struct ath10k_htt {
 	struct sk_buff **pending_tx;
 	unsigned long *used_msdu_ids; /* bitmap */
 	wait_queue_head_t empty_tx_wq;
+	struct dma_pool *tx_pool;
 
 	/* set if host-fw communication goes haywire
 	 * used to avoid further failures */
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index f5960c5..0e24f51 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -109,6 +109,14 @@ int ath10k_htt_tx_attach(struct ath10k_htt *htt)
 		return -ENOMEM;
 	}
 
+	htt->tx_pool = dma_pool_create("ath10k htt tx pool", htt->ar->dev,
+				       sizeof(struct ath10k_htt_txbuf), 4, 0);
+	if (!htt->tx_pool) {
+		kfree(htt->used_msdu_ids);
+		kfree(htt->pending_tx);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -139,6 +147,7 @@ void ath10k_htt_tx_detach(struct ath10k_htt *htt)
 	ath10k_htt_tx_cleanup_pending(htt);
 	kfree(htt->pending_tx);
 	kfree(htt->used_msdu_ids);
+	dma_pool_destroy(htt->tx_pool);
 	return;
 }
 
@@ -350,8 +359,7 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	memcpy(cmd->mgmt_tx.hdr, msdu->data,
 	       min_t(int, msdu->len, HTT_MGMT_FRM_HDR_DOWNLOAD_LEN));
 
-	skb_cb->htt.frag_len = 0;
-	skb_cb->htt.pad_len = 0;
+	skb_cb->htt.txbuf = NULL;
 
 	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
 	if (res)
@@ -377,19 +385,18 @@ err:
 int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 {
 	struct device *dev = htt->ar->dev;
-	struct htt_cmd *cmd;
-	struct htt_data_tx_desc_frag *tx_frags;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(msdu);
-	struct sk_buff *txdesc = NULL;
-	bool use_frags;
-	u8 vdev_id = ATH10K_SKB_CB(msdu)->vdev_id;
-	u8 tid;
-	int prefetch_len, desc_len;
-	int msdu_id = -1;
+	struct ath10k_hif_sg_item sg_items[2];
+	u8 vdev_id = skb_cb->vdev_id;
+	u8 tid = skb_cb->htt.tid;
+	int prefetch_len;
 	int res;
-	u8 flags0;
-	u16 flags1;
+	u8 flags0 = 0;
+	u16 msdu_id, flags1 = 0;
+	dma_addr_t paddr;
+	u32 frags_paddr;
+	bool use_frags;
 
 	res = ath10k_htt_tx_inc_pending(htt);
 	if (res)
@@ -408,105 +415,110 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	prefetch_len = min(htt->prefetch_len, msdu->len);
 	prefetch_len = roundup(prefetch_len, 4);
 
-	desc_len = sizeof(cmd->hdr) + sizeof(cmd->data_tx) + prefetch_len;
-
-	txdesc = ath10k_htc_alloc_skb(desc_len);
-	if (!txdesc) {
-		res = -ENOMEM;
-		goto err_free_msdu_id;
-	}
-
 	/* Since HTT 3.0 there is no separate mgmt tx command. However in case
 	 * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
 	 * fragment list host driver specifies directly frame pointer. */
 	use_frags = htt->target_version_major < 3 ||
 		    !ieee80211_is_mgmt(hdr->frame_control);
 
-	if (!IS_ALIGNED((unsigned long)txdesc->data, 4)) {
-		ath10k_warn("htt alignment check failed. dropping packet.\n");
-		res = -EIO;
-		goto err_free_txdesc;
-	}
-
-	if (use_frags) {
-		skb_cb->htt.frag_len = sizeof(*tx_frags) * 2;
-		skb_cb->htt.pad_len = (unsigned long)msdu->data -
-				      round_down((unsigned long)msdu->data, 4);
-
-		skb_push(msdu, skb_cb->htt.frag_len + skb_cb->htt.pad_len);
-	} else {
-		skb_cb->htt.frag_len = 0;
-		skb_cb->htt.pad_len = 0;
-	}
+	skb_cb->htt.txbuf = dma_pool_alloc(htt->tx_pool, GFP_ATOMIC,
+					   &paddr);
+	if (!skb_cb->htt.txbuf)
+		goto err_free_msdu_id;
+	skb_cb->htt.txbuf_paddr = paddr;
 
 	skb_cb->paddr = dma_map_single(dev, msdu->data, msdu->len,
 				       DMA_TO_DEVICE);
 	res = dma_mapping_error(dev, skb_cb->paddr);
 	if (res)
-		goto err_pull_txfrag;
-
-	if (use_frags) {
-		dma_sync_single_for_cpu(dev, skb_cb->paddr, msdu->len,
-					DMA_TO_DEVICE);
-
-		/* tx fragment list must be terminated with zero-entry */
-		tx_frags = (struct htt_data_tx_desc_frag *)msdu->data;
-		tx_frags[0].paddr = __cpu_to_le32(skb_cb->paddr +
-						  skb_cb->htt.frag_len +
-						  skb_cb->htt.pad_len);
-		tx_frags[0].len   = __cpu_to_le32(msdu->len -
-						  skb_cb->htt.frag_len -
-						  skb_cb->htt.pad_len);
-		tx_frags[1].paddr = __cpu_to_le32(0);
-		tx_frags[1].len   = __cpu_to_le32(0);
-
-		dma_sync_single_for_device(dev, skb_cb->paddr, msdu->len,
-					   DMA_TO_DEVICE);
-	}
+		goto err_free_txbuf;
 
-	ath10k_dbg(ATH10K_DBG_HTT, "tx-msdu 0x%llx\n",
-		   (unsigned long long) ATH10K_SKB_CB(msdu)->paddr);
-	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "tx-msdu: ",
-			msdu->data, msdu->len);
+	if (likely(use_frags)) {
+		skb_cb->htt.txbuf->frags[0].paddr = __cpu_to_le32(skb_cb->paddr);
+		skb_cb->htt.txbuf->frags[0].len = __cpu_to_le32(msdu->len);
+		skb_cb->htt.txbuf->frags[1].paddr = 0;
+		skb_cb->htt.txbuf->frags[1].len = 0;
 
-	skb_put(txdesc, desc_len);
-	cmd = (struct htt_cmd *)txdesc->data;
+		flags0 |= SM(ATH10K_HW_TXRX_NATIVE_WIFI,
+			     HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
 
-	tid = ATH10K_SKB_CB(msdu)->htt.tid;
+		frags_paddr = skb_cb->htt.txbuf_paddr;
+	} else {
+		flags0 |= SM(ATH10K_HW_TXRX_MGMT,
+			     HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
 
-	ath10k_dbg(ATH10K_DBG_HTT, "htt data tx using tid %hhu\n", tid);
+		frags_paddr = skb_cb->paddr;
+	}
+
+	/* Normally all commands go through HTC which manages tx credits for
+	 * each endpoint and notifies when tx is completed.
+	 *
+	 * HTT endpoint is creditless so there's no need to care about HTC
+	 * flags. In that case it is trivial to fill the HTC header here.
+	 *
+	 * MSDU transmission is considered completed upon HTT event. Receiving
+	 * HTT tx completion event implicitly means TX_FRM command itself has
+	 * been HTC tx-completed thus it is pointless to care about the HTC tx
+	 * completion for TX_FRM at all. That's why transfer_context for all
+	 * partials are NULL to avoid HTC tx completion handler from being
+	 * unnecessarily called.
+	 *
+	 * There is simply no point in pushing HTT TX_FRM through HTC tx path
+	 * as it's a waste of resources. By bypassing HTC it is possible to
+	 * avoid extra memory allocations, compress data structures and thus
+	 * improve performance. */
+
+	skb_cb->htt.txbuf->htc_hdr.eid = htt->eid;
+	skb_cb->htt.txbuf->htc_hdr.len = __cpu_to_le16(
+			sizeof(skb_cb->htt.txbuf->cmd_hdr) +
+			sizeof(skb_cb->htt.txbuf->cmd_tx) +
+			prefetch_len);
+	skb_cb->htt.txbuf->htc_hdr.flags = 0;
 
-	flags0  = 0;
 	if (!ieee80211_has_protected(hdr->frame_control))
 		flags0 |= HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT;
-	flags0 |= HTT_DATA_TX_DESC_FLAGS0_MAC_HDR_PRESENT;
 
-	if (use_frags)
-		flags0 |= SM(ATH10K_HW_TXRX_NATIVE_WIFI,
-			     HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
-	else
-		flags0 |= SM(ATH10K_HW_TXRX_MGMT,
-			     HTT_DATA_TX_DESC_FLAGS0_PKT_TYPE);
+	flags0 |= HTT_DATA_TX_DESC_FLAGS0_MAC_HDR_PRESENT;
 
-	flags1  = 0;
 	flags1 |= SM((u16)vdev_id, HTT_DATA_TX_DESC_FLAGS1_VDEV_ID);
 	flags1 |= SM((u16)tid, HTT_DATA_TX_DESC_FLAGS1_EXT_TID);
 	flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L3_OFFLOAD;
 	flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L4_OFFLOAD;
 
-	cmd->hdr.msg_type        = HTT_H2T_MSG_TYPE_TX_FRM;
-	cmd->data_tx.flags0      = flags0;
-	cmd->data_tx.flags1      = __cpu_to_le16(flags1);
-	cmd->data_tx.len         = __cpu_to_le16(msdu->len -
-						 skb_cb->htt.frag_len -
-						 skb_cb->htt.pad_len);
-	cmd->data_tx.id          = __cpu_to_le16(msdu_id);
-	cmd->data_tx.frags_paddr = __cpu_to_le32(skb_cb->paddr);
-	cmd->data_tx.peerid      = __cpu_to_le32(HTT_INVALID_PEERID);
-
-	memcpy(cmd->data_tx.prefetch, hdr, prefetch_len);
+	skb_cb->htt.txbuf->cmd_hdr.msg_type   = HTT_H2T_MSG_TYPE_TX_FRM;
+	skb_cb->htt.txbuf->cmd_tx.flags0      = flags0;
+	skb_cb->htt.txbuf->cmd_tx.flags1      = __cpu_to_le16(flags1);
+	skb_cb->htt.txbuf->cmd_tx.len         = __cpu_to_le16(msdu->len);
+	skb_cb->htt.txbuf->cmd_tx.id          = __cpu_to_le16(msdu_id);
+	skb_cb->htt.txbuf->cmd_tx.frags_paddr = __cpu_to_le32(frags_paddr);
+	skb_cb->htt.txbuf->cmd_tx.peerid      = __cpu_to_le32(HTT_INVALID_PEERID);
+
+	ath10k_dbg(ATH10K_DBG_HTT,
+		   "htt tx flags0 %hhu flags1 %hu len %d id %hu frags_paddr %08x, msdu_paddr %08x vdev %hhu tid %hhu\n",
+		   flags0, flags1, msdu->len, msdu_id, frags_paddr,
+		   (u32)skb_cb->paddr, vdev_id, tid);
+	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt tx msdu: ",
+			msdu->data, msdu->len);
 
-	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
+	sg_items[0].transfer_id = 0;
+	sg_items[0].transfer_context = NULL;
+	sg_items[0].vaddr = skb_cb->htt.txbuf +
+			    sizeof(skb_cb->htt.txbuf->frags);
+	sg_items[0].paddr = skb_cb->htt.txbuf_paddr +
+			    sizeof(skb_cb->htt.txbuf->frags);
+	sg_items[0].len = sizeof(skb_cb->htt.txbuf->htc_hdr) +
+			  sizeof(skb_cb->htt.txbuf->cmd_hdr) +
+			  sizeof(skb_cb->htt.txbuf->cmd_tx);
+
+	sg_items[1].transfer_id = 0;
+	sg_items[1].transfer_context = NULL;
+	sg_items[1].vaddr = msdu->data;
+	sg_items[1].paddr = skb_cb->paddr;
+	sg_items[1].len = prefetch_len;
+
+	res = ath10k_hif_tx_sg(htt->ar,
+			       htt->ar->htc.endpoint[htt->eid].ul_pipe_id,
+			       sg_items, ARRAY_SIZE(sg_items));
 	if (res)
 		goto err_unmap_msdu;
 
@@ -514,10 +526,10 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 err_unmap_msdu:
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
-err_pull_txfrag:
-	skb_pull(msdu, skb_cb->htt.frag_len + skb_cb->htt.pad_len);
-err_free_txdesc:
-	dev_kfree_skb_any(txdesc);
+err_free_txbuf:
+	dma_pool_free(htt->tx_pool,
+		      skb_cb->htt.txbuf,
+		      skb_cb->htt.txbuf_paddr);
 err_free_msdu_id:
 	spin_lock_bh(&htt->tx_lock);
 	htt->pending_tx[msdu_id] = NULL;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 713c18e..2305d58 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -714,6 +714,7 @@ static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state)
 	while (ath10k_ce_completed_send_next(ce_state, &transfer_context,
 					     &ce_data, &nbytes,
 					     &transfer_id) == 0) {
+		/* no need to call tx completion for NULL pointers */
 		if (transfer_context == NULL)
 			continue;
 
@@ -1423,16 +1424,9 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pipe_info)
 
 	while (ath10k_ce_cancel_send_next(ce_hdl, (void **)&netbuf,
 					  &ce_data, &nbytes, &id) == 0) {
-		/*
-		 * Indicate the completion to higer layer to free
-		 * the buffer
-		 */
-
-		if (!netbuf) {
-			ath10k_warn("invalid sk_buff on CE %d - NULL pointer. firmware crashed?\n",
-				    ce_hdl->id);
+		/* no need to call tx completion for NULL pointers */
+		if (!netbuf)
 			continue;
-		}
 
 		ar_pci->msg_callbacks_current.tx_completion(ar,
 							    netbuf,
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 8fd0680..0158ce0 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -66,8 +66,10 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
-	if (skb_cb->htt.frag_len)
-		skb_pull(msdu, skb_cb->htt.frag_len + skb_cb->htt.pad_len);
+	if (skb_cb->htt.txbuf)
+		dma_pool_free(htt->tx_pool,
+			      skb_cb->htt.txbuf,
+			      skb_cb->htt.txbuf_paddr);
 
 	ath10k_report_offchan_tx(htt->ar, msdu);
 
-- 
1.8.5.3

