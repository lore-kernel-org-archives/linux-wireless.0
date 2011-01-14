Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:41948 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1ANDpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 22:45:39 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3] mwifiex: remove linked list implementation
Date: Thu, 13 Jan 2011 19:46:36 -0800
Message-Id: <1294976796-28296-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Use linked list functions available in include/linux/list.h

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v3: remove type casting

 drivers/net/wireless/mwifiex/11n.c           |  134 +++-----
 drivers/net/wireless/mwifiex/11n.h           |   19 +-
 drivers/net/wireless/mwifiex/11n_aggr.c      |  124 +++++---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   53 ++--
 drivers/net/wireless/mwifiex/cmdevt.c        |  228 +++++++------
 drivers/net/wireless/mwifiex/decl.h          |    3 +-
 drivers/net/wireless/mwifiex/init.c          |  113 ++++---
 drivers/net/wireless/mwifiex/main.c          |   32 ++-
 drivers/net/wireless/mwifiex/main.h          |   56 ++--
 drivers/net/wireless/mwifiex/scan.c          |   34 ++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   18 +-
 drivers/net/wireless/mwifiex/sta_tx.c        |    2 +-
 drivers/net/wireless/mwifiex/util.c          |  141 --------
 drivers/net/wireless/mwifiex/util.h          |   46 ---
 drivers/net/wireless/mwifiex/wmm.c           |  450 ++++++++++++++------------
 drivers/net/wireless/mwifiex/wmm.h           |   37 ++-
 16 files changed, 696 insertions(+), 794 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index b1fd5a9..2922528 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -1073,23 +1073,11 @@ mwifiex_is_tx_ba_stream_ptr_valid(struct mwifiex_private *priv,
 
 	ENTER();
 
-	tx_ba_tsr_tbl = (struct mwifiex_tx_ba_stream_tbl *)
-			mwifiex_util_peek_list(&priv->tx_ba_stream_tbl_ptr,
-						false);
-	if (!tx_ba_tsr_tbl) {
-		LEAVE();
-		return false;
-	}
-
-	while (tx_ba_tsr_tbl !=
-			(struct mwifiex_tx_ba_stream_tbl *)
-			&priv->tx_ba_stream_tbl_ptr) {
+	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
 		if (tx_ba_tsr_tbl == tx_tbl_ptr) {
 			LEAVE();
 			return true;
 		}
-
-		tx_ba_tsr_tbl = tx_ba_tsr_tbl->next;
 	}
 
 	LEAVE();
@@ -1106,26 +1094,19 @@ void
 mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 		struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl)
 {
-	unsigned long flags;
-
 	ENTER();
 
-	spin_lock_irqsave(&priv->tx_ba_stream_tbl_ptr.lock, flags);
-
 	if (!tx_ba_tsr_tbl &&
 			mwifiex_is_tx_ba_stream_ptr_valid(priv, tx_ba_tsr_tbl))
 		goto exit;
 
-
 	PRINTM(MINFO, "tx_ba_stream_tbl_ptr %p\n", tx_ba_tsr_tbl);
 
-	mwifiex_util_unlink_list(&priv->tx_ba_stream_tbl_ptr,
-			(struct mwifiex_linked_list *) tx_ba_tsr_tbl, false);
+	list_del(&tx_ba_tsr_tbl->list);
 
 	kfree(tx_ba_tsr_tbl);
 
 exit:
-	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_ptr.lock, flags);
 
 	LEAVE();
 }
@@ -1137,16 +1118,18 @@ void
 mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv)
 {
 	int i;
-	struct mwifiex_tx_ba_stream_tbl *del_tbl_ptr;
+	struct mwifiex_tx_ba_stream_tbl *del_tbl_ptr, *tmp_node;
+	unsigned long flags;
 
 	ENTER();
 
-	while ((del_tbl_ptr = (struct mwifiex_tx_ba_stream_tbl *)
-		mwifiex_util_peek_list(&priv->tx_ba_stream_tbl_ptr, true)))
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	list_for_each_entry_safe(del_tbl_ptr, tmp_node,
+				 &priv->tx_ba_stream_tbl_ptr, list)
 		mwifiex_11n_delete_tx_ba_stream_tbl_entry(priv, del_tbl_ptr);
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 
-	mwifiex_util_init_list((struct mwifiex_linked_list *) &priv->
-			       tx_ba_stream_tbl_ptr);
+	INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
 
 	for (i = 0; i < MAX_NUM_TID; ++i) {
 		priv->aggr_prio_tbl[i].ampdu_ap =
@@ -1165,27 +1148,20 @@ mwifiex_11n_get_tx_ba_stream_status(struct mwifiex_private *priv,
 				  enum mwifiex_ba_status ba_status)
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
+	unsigned long flags;
 
 	ENTER();
 
-	tx_ba_tsr_tbl = (struct mwifiex_tx_ba_stream_tbl *)
-			mwifiex_util_peek_list(&priv->tx_ba_stream_tbl_ptr,
-						true);
-	if (!tx_ba_tsr_tbl) {
-		LEAVE();
-		return NULL;
-	}
-
-	while (tx_ba_tsr_tbl !=
-			(struct mwifiex_tx_ba_stream_tbl *)
-			&priv->tx_ba_stream_tbl_ptr) {
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
 		if (tx_ba_tsr_tbl->ba_status == ba_status) {
+			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
+					       flags);
 			LEAVE();
 			return tx_ba_tsr_tbl;
 		}
-
-		tx_ba_tsr_tbl = tx_ba_tsr_tbl->next;
 	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 
 	LEAVE();
 	return NULL;
@@ -1200,34 +1176,25 @@ mwifiex_11n_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 		int tid, u8 *ra)
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
+	unsigned long flags;
 
 	ENTER();
 
-	tx_ba_tsr_tbl = (struct mwifiex_tx_ba_stream_tbl *)
-			mwifiex_util_peek_list(&priv->tx_ba_stream_tbl_ptr,
-						true);
-	if (!tx_ba_tsr_tbl) {
-		LEAVE();
-		return NULL;
-	}
-
-	while (tx_ba_tsr_tbl !=
-			(struct mwifiex_tx_ba_stream_tbl *)
-			&priv->tx_ba_stream_tbl_ptr) {
-
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
 		PRINTM(MDAT_D, "get_tx_ba_stream_tbl TID %d\n",
 				tx_ba_tsr_tbl->tid);
 		DBG_HEXDUMP(MDAT_D, "RA", tx_ba_tsr_tbl->ra,
 				MWIFIEX_MAC_ADDR_LENGTH);
-
 		if ((!memcmp(tx_ba_tsr_tbl->ra, ra, MWIFIEX_MAC_ADDR_LENGTH))
 		    && (tx_ba_tsr_tbl->tid == tid)) {
+			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
+					       flags);
 			LEAVE();
 			return tx_ba_tsr_tbl;
 		}
-
-		tx_ba_tsr_tbl = tx_ba_tsr_tbl->next;
 	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 
 	LEAVE();
 	return NULL;
@@ -1243,6 +1210,7 @@ mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
 				  enum mwifiex_ba_status ba_status)
 {
 	struct mwifiex_tx_ba_stream_tbl *new_node;
+	unsigned long flags;
 
 	ENTER();
 
@@ -1258,15 +1226,15 @@ mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
 			goto exit;
 		}
 
-		mwifiex_util_init_list((struct mwifiex_linked_list *) new_node);
+		INIT_LIST_HEAD(&new_node->list);
 
 		new_node->tid = tid;
 		new_node->ba_status = ba_status;
 		memcpy(new_node->ra, ra, MWIFIEX_MAC_ADDR_LENGTH);
 
-		mwifiex_util_enqueue_list_tail(&priv->tx_ba_stream_tbl_ptr,
-					       (struct mwifiex_linked_list *)
-					       new_node, true);
+		spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+		list_add_tail(&new_node->list, &priv->tx_ba_stream_tbl_ptr);
+		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 	}
 
 exit:
@@ -1376,23 +1344,19 @@ mwifiex_11n_update_addba_request(struct mwifiex_private *priv)
 {
 
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
+	unsigned long flags;
 
 	ENTER();
 
-	tx_ba_tsr_tbl = (struct mwifiex_tx_ba_stream_tbl *)
-			mwifiex_util_peek_list(&priv->tx_ba_stream_tbl_ptr,
-						true);
-	if (!tx_ba_tsr_tbl) {
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	if (list_empty(&priv->tx_ba_stream_tbl_ptr)) {
+		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 		LEAVE();
 		return;
 	}
-
-	while (tx_ba_tsr_tbl !=
-			(struct mwifiex_tx_ba_stream_tbl *)
-			&priv->tx_ba_stream_tbl_ptr) {
+	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list)
 		mwifiex_send_addba(priv, tx_ba_tsr_tbl->tid, tx_ba_tsr_tbl->ra);
-		tx_ba_tsr_tbl = tx_ba_tsr_tbl->next;
-	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 
 	mwifiex_main_process(priv->adapter);
 	LEAVE();
@@ -1410,16 +1374,13 @@ mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
 	struct mwifiex_ds_rx_reorder_tbl *rx_reo_tbl = buf;
 	struct mwifiex_rx_reorder_tbl *rx_reorder_tbl_ptr;
 	int count = 0;
+	unsigned long flags;
+
 	ENTER();
-	rx_reorder_tbl_ptr = (struct mwifiex_rx_reorder_tbl *)
-		mwifiex_util_peek_list(&priv->rx_reorder_tbl_ptr,
-				true);
-	if (!rx_reorder_tbl_ptr) {
-		LEAVE();
-		return count;
-	}
-	while (rx_reorder_tbl_ptr !=
-	       (struct mwifiex_rx_reorder_tbl *) &priv->rx_reorder_tbl_ptr) {
+
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	list_for_each_entry(rx_reorder_tbl_ptr, &priv->rx_reorder_tbl_ptr,
+			    list) {
 		rx_reo_tbl->tid = (u16) rx_reorder_tbl_ptr->tid;
 		memcpy(rx_reo_tbl->ta, rx_reorder_tbl_ptr->ta,
 				MWIFIEX_MAC_ADDR_LENGTH);
@@ -1431,13 +1392,14 @@ mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
 			else
 				rx_reo_tbl->buffer[i] = false;
 		}
-		rx_reorder_tbl_ptr = rx_reorder_tbl_ptr->next;
 		rx_reo_tbl++;
 		count++;
 
 		if (count >= MWIFIEX_MAX_RX_BASTREAM_SUPPORTED)
 			break;
 	}
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
+
 	LEAVE();
 	return count;
 }
@@ -1452,30 +1414,22 @@ mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
 	struct mwifiex_ds_tx_ba_stream_tbl *rx_reo_tbl = buf;
 	int count = 0;
+	unsigned long flags;
 
 	ENTER();
 
-	tx_ba_tsr_tbl = (struct mwifiex_tx_ba_stream_tbl *)
-			mwifiex_util_peek_list(&priv->tx_ba_stream_tbl_ptr,
-						true);
-	if (!tx_ba_tsr_tbl) {
-		LEAVE();
-		return count;
-	}
-
-	while (tx_ba_tsr_tbl !=
-			(struct mwifiex_tx_ba_stream_tbl *)
-			&priv->tx_ba_stream_tbl_ptr) {
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
 		rx_reo_tbl->tid = (u16) tx_ba_tsr_tbl->tid;
 		PRINTM(MDATA, "tid=%d\n", rx_reo_tbl->tid);
 		memcpy(rx_reo_tbl->ra, tx_ba_tsr_tbl->ra,
 				MWIFIEX_MAC_ADDR_LENGTH);
-		tx_ba_tsr_tbl = tx_ba_tsr_tbl->next;
 		rx_reo_tbl++;
 		count++;
 		if (count >= MWIFIEX_MAX_TX_BASTREAM_SUPPORTED)
 			break;
 	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 
 	LEAVE();
 	return count;
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 65f9ae8..21460c8 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -129,7 +129,7 @@ mwifiex_is_ba_stream_avail(struct mwifiex_private *priv)
 		if (pmpriv)
 			ba_stream_num +=
 				mwifiex_wmm_list_len(priv->adapter,
-						     (struct mwifiex_list_head
+						     (struct list_head
 						      *) &pmpriv->
 						     tx_ba_stream_tbl_ptr);
 	}
@@ -151,31 +151,22 @@ mwifiex_find_stream_to_delete(struct mwifiex_private *priv,
 	int tid;
 	u8 ret = false;
 	struct mwifiex_tx_ba_stream_tbl *tx_tbl;
+	unsigned long flags;
 
 	ENTER();
 
-	tx_tbl = (struct mwifiex_tx_ba_stream_tbl *)
-			mwifiex_util_peek_list(&priv->tx_ba_stream_tbl_ptr,
-						true);
-	if (!tx_tbl) {
-		LEAVE();
-		return ret;
-	}
-
 	tid = priv->aggr_prio_tbl[ptr_tid].ampdu_user;
 
-	while (tx_tbl !=
-			(struct mwifiex_tx_ba_stream_tbl *)
-			&priv->tx_ba_stream_tbl_ptr) {
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	list_for_each_entry(tx_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
 		if (tid > priv->aggr_prio_tbl[tx_tbl->tid].ampdu_user) {
 			tid = priv->aggr_prio_tbl[tx_tbl->tid].ampdu_user;
 			*ptid = tx_tbl->tid;
 			memcpy(ra, tx_tbl->ra, MWIFIEX_MAC_ADDR_LENGTH);
 			ret = true;
 		}
-
-		tx_tbl = tx_tbl->next;
 	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 
 	LEAVE();
 	return ret;
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index ca24d54..56f4531 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -306,7 +306,7 @@ done:
 int
 mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			  struct mwifiex_ra_list_tbl *pra_list, int headroom,
-			  int ptrindex, unsigned long flags)
+			  int ptrindex, unsigned long ra_list_flags)
 			  __releases(&priv->wmm.ra_list_spinlock)
 {
 	int pkt_size = 0;
@@ -318,53 +318,68 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	struct timeval tstamp;
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
+	unsigned long ra_list_tbl_flags;
 
 	ENTER();
 
 	PRINTM(MDAT_D, "Handling Aggr packet\n");
 
-	mbuf_src = (struct mwifiex_buffer *)
-			mwifiex_util_peek_list(&pra_list->buf_head,
-						true);
-	if (mbuf_src) {
-		mbuf_aggr = mwifiex_alloc_buffer(adapter->tx_buf_size);
-		if (!mbuf_aggr) {
-			PRINTM(MERROR,
-			       "Error allocating struct mwifiex_buffer\n");
-			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
-					       flags);
-			return MWIFIEX_STATUS_FAILURE;
-		}
+	spin_lock_irqsave(&pra_list->ra_list_tbl_lock, ra_list_tbl_flags);
+	if (list_empty(&pra_list->buf_head)) {
+		spin_unlock_irqrestore(&pra_list->ra_list_tbl_lock,
+				       ra_list_tbl_flags);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		goto exit;
+	}
+	mbuf_src = list_first_entry(&pra_list->buf_head,
+				    struct mwifiex_buffer, list);
+	spin_unlock_irqrestore(&pra_list->ra_list_tbl_lock, ra_list_tbl_flags);
+
+	mbuf_aggr = mwifiex_alloc_buffer(adapter->tx_buf_size);
+	if (!mbuf_aggr) {
+		PRINTM(MERROR,
+		       "Error allocating struct mwifiex_buffer\n");
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		return MWIFIEX_STATUS_FAILURE;
+	}
 
-		data = mbuf_aggr->buffer + headroom;
+	data = mbuf_aggr->buffer + headroom;
 
-		mbuf_aggr->bss_index = mbuf_src->bss_index;
-		mbuf_aggr->buf_type = mbuf_src->buf_type;
-		mbuf_aggr->priority = mbuf_src->priority;
+	mbuf_aggr->bss_index = mbuf_src->bss_index;
+	mbuf_aggr->buf_type = mbuf_src->buf_type;
+	mbuf_aggr->priority = mbuf_src->priority;
 
-		mbuf_aggr->buffer = data;
-		mbuf_aggr->data_offset = 0;
+	mbuf_aggr->buffer = data;
+	mbuf_aggr->data_offset = 0;
 
-		/* Form AMSDU */
-		mwifiex_11n_form_amsdu_txpd(priv, mbuf_aggr);
-		pkt_size = sizeof(struct txpd);
-		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
-			ptx_pd = (struct txpd *)mbuf_aggr->buffer;
-	} else {
-		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
-		goto exit;
-	}
+	/* Form AMSDU */
+	mwifiex_11n_form_amsdu_txpd(priv, mbuf_aggr);
+	pkt_size = sizeof(struct txpd);
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
+		ptx_pd = (struct txpd *)mbuf_aggr->buffer;
 
 	while (mbuf_src && ((pkt_size + (mbuf_src->data_len + LLC_SNAP_LEN)
 			      + headroom)
 			     <= adapter->tx_buf_size)) {
 
-		mbuf_src = (struct mwifiex_buffer *)
-			mwifiex_util_dequeue_list(&pra_list->buf_head, true);
+		spin_lock_irqsave(&pra_list->ra_list_tbl_lock,
+				  ra_list_tbl_flags);
+		if (!list_empty(&pra_list->buf_head)) {
+			mbuf_src = list_first_entry(&pra_list->buf_head,
+					struct mwifiex_buffer, list);
+			list_del(&mbuf_src->list);
+		} else {
+			mbuf_src = NULL;
+		}
+		spin_unlock_irqrestore(&pra_list->ra_list_tbl_lock,
+				       ra_list_tbl_flags);
 
 		pra_list->total_pkts_size -= mbuf_src->data_len;
 
-		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
 		pkt_size += mwifiex_11n_form_amsdu_pkt(adapter,
 						       (data + pkt_size),
 						       mbuf_src->buffer +
@@ -377,21 +392,27 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		mwifiex_write_data_complete(adapter, mbuf_src,
 					     MWIFIEX_STATUS_SUCCESS);
 
-		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
-					       flags);
+					       ra_list_flags);
 			LEAVE();
 			return MWIFIEX_STATUS_FAILURE;
 		}
 
-		mbuf_src =
-			(struct mwifiex_buffer *)
-			mwifiex_util_peek_list(&pra_list->buf_head, true);
+		spin_lock_irqsave(&pra_list->ra_list_tbl_lock,
+				  ra_list_tbl_flags);
+		if (!list_empty(&pra_list->buf_head))
+			mbuf_src = list_first_entry(&pra_list->buf_head,
+					struct mwifiex_buffer, list);
+		else
+			mbuf_src = NULL;
+		spin_unlock_irqrestore(&pra_list->ra_list_tbl_lock,
+				       ra_list_tbl_flags);
 	}
 
-	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 	/* Last AMSDU packet does not need padding */
 	pkt_size -= pad;
@@ -408,11 +429,10 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 					     mbuf_aggr, &tx_param);
 	switch (ret) {
 	case MWIFIEX_STATUS_RESOURCE:
-		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
-
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
-					       flags);
+					       ra_list_flags);
 			mwifiex_write_data_complete(adapter, mbuf_aggr,
 						    MWIFIEX_STATUS_FAILURE);
 			LEAVE();
@@ -424,14 +444,18 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 				priv->adapter->tx_lock_flag = false;
 				ptx_pd->flags = 0;
 		}
-		mwifiex_util_enqueue_list_head(&pra_list->buf_head,
-					       (struct mwifiex_linked_list *)
-					       mbuf_aggr, true);
+
+		spin_lock_irqsave(&pra_list->ra_list_tbl_lock,
+				  ra_list_tbl_flags);
+		list_add(&mbuf_aggr->list, &pra_list->buf_head);
+		spin_unlock_irqrestore(&pra_list->ra_list_tbl_lock,
+				       ra_list_tbl_flags);
 
 		pra_list->total_pkts_size += mbuf_aggr->data_len;
 
 		mbuf_aggr->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
-		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
 		PRINTM(MDATA, "MWIFIEX_STATUS_RESOURCE is returned\n");
 		break;
 	case MWIFIEX_STATUS_FAILURE:
@@ -451,15 +475,19 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		break;
 	}
 	if (ret != MWIFIEX_STATUS_RESOURCE) {
-		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 		if (mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			priv->wmm.packets_out[ptrindex]++;
 			priv->wmm.tid_tbl_ptr[ptrindex].ra_list_curr = pra_list;
 		}
+		/* Now bss_prio_cur pointer points to next node */
 		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
-			adapter->bss_prio_tbl[priv->bss_priority]
-			.bss_prio_cur->next;
-		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+			list_first_entry(
+				&adapter->bss_prio_tbl[priv->bss_priority]
+				.bss_prio_cur->list,
+				struct mwifiex_bss_prio_node, list);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
 	}
 	do_gettimeofday(&tstamp);
 	PRINTM(MDATA, "%lu.%lu : Data => kernel\n",
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index e783a2e..567c93d 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -158,6 +158,8 @@ mwifiex_11n_delete_rx_reorder_tbl_entry(struct mwifiex_private *priv,
 				       struct mwifiex_rx_reorder_tbl
 				       *rx_reor_tbl_ptr)
 {
+	unsigned long flags;
+
 	ENTER();
 
 	if (!rx_reor_tbl_ptr) {
@@ -173,9 +175,10 @@ mwifiex_11n_delete_rx_reorder_tbl_entry(struct mwifiex_private *priv,
 	del_timer(&rx_reor_tbl_ptr->timer_context.timer);
 
 	PRINTM(MDAT_D, "Delete rx_reor_tbl_ptr: %p\n", rx_reor_tbl_ptr);
-	mwifiex_util_unlink_list(&priv->rx_reorder_tbl_ptr,
-				 (struct mwifiex_linked_list *) rx_reor_tbl_ptr,
-				 true);
+
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	list_del(&rx_reor_tbl_ptr->list);
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
 	kfree(rx_reor_tbl_ptr->rx_reorder_ptr);
 	kfree(rx_reor_tbl_ptr);
@@ -191,27 +194,21 @@ static struct mwifiex_rx_reorder_tbl *
 mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta)
 {
 	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
+	unsigned long flags;
 
 	ENTER();
 
-	rx_reor_tbl_ptr = (struct mwifiex_rx_reorder_tbl *)
-			mwifiex_util_peek_list(&priv->rx_reorder_tbl_ptr,
-						true);
-	if (!rx_reor_tbl_ptr) {
-		LEAVE();
-		return NULL;
-	}
-
-	while (rx_reor_tbl_ptr !=
-	       (struct mwifiex_rx_reorder_tbl *) &priv->rx_reorder_tbl_ptr) {
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	list_for_each_entry(rx_reor_tbl_ptr, &priv->rx_reorder_tbl_ptr, list) {
 		if ((!memcmp(rx_reor_tbl_ptr->ta, ta, MWIFIEX_MAC_ADDR_LENGTH))
 		    && (rx_reor_tbl_ptr->tid == tid)) {
+			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
+					       flags);
 			LEAVE();
 			return rx_reor_tbl_ptr;
 		}
-
-		rx_reor_tbl_ptr = rx_reor_tbl_ptr->next;
 	}
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
 	LEAVE();
 	return NULL;
@@ -276,6 +273,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	int i;
 	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr, *new_node;
 	u16 last_seq = 0;
+	unsigned long flags;
 
 	ENTER();
 
@@ -301,7 +299,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 			goto exit;
 		}
 
-		mwifiex_util_init_list((struct mwifiex_linked_list *) new_node);
+		INIT_LIST_HEAD(&new_node->list);
 		new_node->tid = tid;
 		memcpy(new_node->ta, ta, MWIFIEX_MAC_ADDR_LENGTH);
 		new_node->start_win = seq_num;
@@ -342,9 +340,9 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		for (i = 0; i < win_size; ++i)
 			new_node->rx_reorder_ptr[i] = NULL;
 
-		mwifiex_util_enqueue_list_tail(&priv->rx_reorder_tbl_ptr,
-					       (struct mwifiex_linked_list *)
-					       new_node, true);
+		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+		list_add_tail(&new_node->list, &priv->rx_reorder_tbl_ptr);
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 	}
 
 exit:
@@ -610,6 +608,7 @@ mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int tid,
 	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
 	struct mwifiex_tx_ba_stream_tbl *ptx_tbl;
 	u8 cleanup_rx_reorder_tbl;
+	unsigned long flags;
 
 	ENTER();
 
@@ -641,7 +640,9 @@ mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int tid,
 			return;
 		}
 
+		spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 		mwifiex_11n_delete_tx_ba_stream_tbl_entry(priv, ptx_tbl);
+		spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
 	}
 
 	LEAVE();
@@ -747,17 +748,21 @@ mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
 void
 mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv)
 {
-	struct mwifiex_rx_reorder_tbl *del_tbl_ptr;
+	struct mwifiex_rx_reorder_tbl *del_tbl_ptr, *tmp_node;
+	unsigned long flags;
 
 	ENTER();
 
-	while ((del_tbl_ptr = (struct mwifiex_rx_reorder_tbl *)
-		mwifiex_util_peek_list(&priv->rx_reorder_tbl_ptr, true))) {
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	list_for_each_entry_safe(del_tbl_ptr, tmp_node,
+				 &priv->rx_reorder_tbl_ptr, list) {
+		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 		mwifiex_11n_delete_rx_reorder_tbl_entry(priv, del_tbl_ptr);
+		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	}
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
-	mwifiex_util_init_list((struct mwifiex_linked_list *) &priv->
-			       rx_reorder_tbl_ptr);
+	INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
 	memset(priv->rx_seq, 0, sizeof(priv->rx_seq));
 
 	LEAVE();
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index dee8550..60aeea4 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -70,6 +70,7 @@ static struct cmd_ctrl_node *
 mwifiex_get_cmd_node(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_node;
+	unsigned long flags;
 
 	ENTER();
 
@@ -78,15 +79,17 @@ mwifiex_get_cmd_node(struct mwifiex_adapter *adapter)
 		return NULL;
 	}
 
-	if (mwifiex_util_peek_list(&adapter->cmd_free_q, true)) {
-		cmd_node =
-			(struct cmd_ctrl_node *)
-			mwifiex_util_dequeue_list(&adapter->cmd_free_q, true);
-	} else {
+	spin_lock_irqsave(&adapter->cmd_free_q_lock, flags);
+	if (list_empty(&adapter->cmd_free_q)) {
 		PRINTM(MERROR,
 		       "GET_CMD_NODE: struct cmd_ctrl_node is not available\n");
-		cmd_node = NULL;
+		spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
+		return NULL;
 	}
+	cmd_node = list_first_entry(&adapter->cmd_free_q,
+			struct cmd_ctrl_node, list);
+	list_del(&cmd_node->list);
+	spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
 
 	LEAVE();
 	return cmd_node;
@@ -137,24 +140,22 @@ static struct cmd_ctrl_node *
 mwifiex_get_pending_ioctl_cmd(struct mwifiex_adapter *adapter,
 			      struct mwifiex_ioctl_req *ioctl_req)
 {
-	struct cmd_ctrl_node *cmd_node = NULL;
+	unsigned long flags;
+	struct cmd_ctrl_node *cmd_node;
 
 	ENTER();
 
-	cmd_node = (struct cmd_ctrl_node *)
-			mwifiex_util_peek_list(&adapter->cmd_pending_q,
-						true);
-	if (!cmd_node) {
-		LEAVE();
-		return NULL;
-	}
-	while (cmd_node != (struct cmd_ctrl_node *) &adapter->cmd_pending_q) {
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
+	list_for_each_entry(cmd_node, &adapter->cmd_pending_q, list) {
 		if (cmd_node->ioctl_buf == ioctl_req) {
+			spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
+					       flags);
 			LEAVE();
 			return cmd_node;
 		}
-		cmd_node = cmd_node->next;
 	}
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
+
 	LEAVE();
 	return NULL;
 }
@@ -673,6 +674,8 @@ mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 			     struct cmd_ctrl_node *cmd_node)
 {
 	struct mwifiex_ioctl_req *ioctl_req = NULL;
+	unsigned long flags;
+
 	ENTER();
 
 	if (cmd_node == NULL)
@@ -692,9 +695,10 @@ mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 	mwifiex_clean_cmd_node(adapter, cmd_node);
 
 	/* Insert node into cmd_free_q */
-	mwifiex_util_enqueue_list_tail(&adapter->cmd_free_q,
-				       (struct mwifiex_linked_list *) cmd_node,
-				       true);
+	spin_lock_irqsave(&adapter->cmd_free_q_lock, flags);
+	list_add_tail(&cmd_node->list, &adapter->cmd_free_q);
+	spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
+
 done:
 	LEAVE();
 }
@@ -712,6 +716,7 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 {
 	struct host_cmd_ds_command *host_cmd = NULL;
 	u16 command;
+	unsigned long flags;
 
 	ENTER();
 
@@ -740,15 +745,12 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 		}
 	}
 
-	if (add_tail) {
-		mwifiex_util_enqueue_list_tail(&adapter->cmd_pending_q,
-					       (struct mwifiex_linked_list *)
-					       cmd_node, true);
-	} else {
-		mwifiex_util_enqueue_list_head(&adapter->cmd_pending_q,
-					       (struct mwifiex_linked_list *)
-					       cmd_node, true);
-	}
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
+	if (add_tail)
+		list_add_tail(&cmd_node->list, &adapter->cmd_pending_q);
+	else
+		list_add(&cmd_node->list, &adapter->cmd_pending_q);
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 
 	PRINTM(MCMND, "QUEUE_CMD: cmd=0x%x is queued\n", command);
 
@@ -775,7 +777,8 @@ mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 	struct cmd_ctrl_node *cmd_node = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct host_cmd_ds_command *host_cmd;
-	unsigned long flags;
+	unsigned long cmd_flags;
+	unsigned long cmd_pending_q_flags;
 
 	ENTER();
 
@@ -793,51 +796,55 @@ mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 		goto done;
 	}
 
-	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 	/* Check if any command is pending */
-	cmd_node =
-		(struct cmd_ctrl_node *) mwifiex_util_peek_list(&adapter->
-								cmd_pending_q,
-								true);
-
-	if (cmd_node) {
-		host_cmd = (struct host_cmd_ds_command *)
-					(cmd_node->cmd_buf->buffer +
-					 cmd_node->cmd_buf->data_offset);
-		priv = cmd_node->priv;
-
-		if (adapter->ps_state != PS_STATE_AWAKE) {
-			PRINTM(MERROR, "Cannot send command in sleep state"
-					", this should not happen\n");
-			spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock,
-					       flags);
-			goto done;
-		}
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, cmd_pending_q_flags);
+	if (list_empty(&adapter->cmd_pending_q)) {
+		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
+				       cmd_pending_q_flags);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+		ret = MWIFIEX_STATUS_SUCCESS;
+		goto done;
+	}
+	cmd_node = list_first_entry(&adapter->cmd_pending_q,
+				    struct cmd_ctrl_node, list);
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
+			       cmd_pending_q_flags);
+
+	host_cmd = (struct host_cmd_ds_command *)
+				(cmd_node->cmd_buf->buffer +
+				 cmd_node->cmd_buf->data_offset);
+	priv = cmd_node->priv;
+
+	if (adapter->ps_state != PS_STATE_AWAKE) {
+		PRINTM(MERROR, "Cannot send command in sleep state"
+				", this should not happen\n");
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock,
+				       cmd_flags);
+		goto done;
+	}
 
-		mwifiex_util_unlink_list(&adapter->cmd_pending_q,
-					 (struct mwifiex_linked_list *)
-					 cmd_node, true);
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-		ret = mwifiex_dnld_cmd_to_fw(priv, cmd_node);
-		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
-		/* Any command sent to the firmware when host is in sleep
-		   mode, should
-		   de-configure host sleep */
-		/* We should skip the host sleep configuration command
-		   itself though */
-		if (priv &&
-		    (host_cmd->command !=
-		     cpu_to_le16(HostCmd_CMD_802_11_HS_CFG_ENH))) {
-			if (adapter->hs_activated) {
-				adapter->is_hs_configured = false;
-				mwifiex_hs_activated_event(priv, false);
-			}
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, cmd_pending_q_flags);
+	list_del(&cmd_node->list);
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
+			       cmd_pending_q_flags);
+
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+	ret = mwifiex_dnld_cmd_to_fw(priv, cmd_node);
+	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+	/* Any command sent to the firmware when host is in sleep
+	 * mode should de-configure host sleep. We should skip the
+	 * host sleep configuration command itself though
+	 */
+	if (priv &&
+	    (host_cmd->command !=
+	     cpu_to_le16(HostCmd_CMD_802_11_HS_CFG_ENH))) {
+		if (adapter->hs_activated) {
+			adapter->is_hs_configured = false;
+			mwifiex_hs_activated_event(priv, false);
 		}
-		goto done;
-	} else {
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 	}
-	ret = MWIFIEX_STATUS_SUCCESS;
+
 done:
 	LEAVE();
 	return ret;
@@ -1096,7 +1103,7 @@ exit:
 void
 mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 {
-	struct cmd_ctrl_node *cmd_node = NULL;
+	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
 	struct mwifiex_ioctl_req *ioctl_buf = NULL;
 	unsigned long flags;
 
@@ -1113,13 +1120,12 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 				       MWIFIEX_STATUS_FAILURE);
 	}
 	/* Cancel all pending command */
-	while ((cmd_node =
-		(struct cmd_ctrl_node *) mwifiex_util_peek_list(&adapter->
-								cmd_pending_q,
-								true))) {
-		mwifiex_util_unlink_list(&adapter->cmd_pending_q,
-					 (struct mwifiex_linked_list *)
-					 cmd_node, true);
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
+	list_for_each_entry_safe(cmd_node, tmp_node,
+				 &adapter->cmd_pending_q, list) {
+		list_del(&cmd_node->list);
+		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
+
 		if (cmd_node->ioctl_buf) {
 			ioctl_buf =
 				(struct mwifiex_ioctl_req *) cmd_node->
@@ -1130,18 +1136,23 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 			cmd_node->ioctl_buf = NULL;
 		}
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
 	}
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
+
 	/* Cancel all pending scan command */
-	while ((cmd_node =
-		(struct cmd_ctrl_node *) mwifiex_util_peek_list(&adapter->
-								scan_pending_q,
-								true))) {
-		mwifiex_util_unlink_list(&adapter->scan_pending_q,
-					 (struct mwifiex_linked_list *)
-					 cmd_node, true);
+	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+	list_for_each_entry_safe(cmd_node, tmp_node,
+				 &adapter->scan_pending_q, list) {
+		list_del(&cmd_node->list);
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+
 		cmd_node->ioctl_buf = NULL;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	}
+	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+
 	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 	adapter->scan_processing = false;
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
@@ -1161,8 +1172,10 @@ void
 mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 			     struct mwifiex_ioctl_req *ioctl_req)
 {
-	struct cmd_ctrl_node *cmd_node = NULL;
-	unsigned long flags;
+	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
+	unsigned long cmd_flags;
+	unsigned long cmd_pending_q_flags;
+	unsigned long scan_pending_q_flags;
 
 	ENTER();
 
@@ -1172,38 +1185,47 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 
 	if ((adapter->curr_cmd) &&
 	    (adapter->curr_cmd->ioctl_buf == ioctl_req)) {
-		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 		cmd_node = adapter->curr_cmd;
 		cmd_node->ioctl_buf = NULL;
 		cmd_node->cmd_flag |= CMD_F_CANCELED;
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	}
 
-	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 	while ((cmd_node =
 		mwifiex_get_pending_ioctl_cmd(adapter, ioctl_req)) != NULL) {
-		mwifiex_util_unlink_list(&adapter->cmd_pending_q,
-					 (struct mwifiex_linked_list *)
-					 cmd_node, true);
+
+		spin_lock_irqsave(&adapter->cmd_pending_q_lock,
+				  cmd_pending_q_flags);
+		list_del(&cmd_node->list);
+		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
+				       cmd_pending_q_flags);
+
 		cmd_node->ioctl_buf = NULL;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 	}
-	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	if (ioctl_req->req_id == MWIFIEX_IOCTL_SCAN) {
 		/* Cancel all pending scan command */
-		while ((cmd_node =
-			(struct cmd_ctrl_node *)
-			mwifiex_util_peek_list(&adapter->scan_pending_q,
-					       true))) {
-			mwifiex_util_unlink_list(&adapter->scan_pending_q,
-						 (struct mwifiex_linked_list *)
-						 cmd_node, true);
+		spin_lock_irqsave(&adapter->scan_pending_q_lock,
+				  scan_pending_q_flags);
+		list_for_each_entry_safe(cmd_node, tmp_node,
+					 &adapter->scan_pending_q, list) {
+			list_del(&cmd_node->list);
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       scan_pending_q_flags);
 			cmd_node->ioctl_buf = NULL;
 			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+			spin_lock_irqsave(&adapter->scan_pending_q_lock,
+					  scan_pending_q_flags);
 		}
-		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+				       scan_pending_q_flags);
+
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 		adapter->scan_processing = false;
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	}
 	ioctl_req->status_code = MWIFIEX_ERROR_CMD_CANCEL;
 	mwifiex_ioctl_complete(adapter, ioctl_req, MWIFIEX_STATUS_FAILURE);
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 30d66c0..467eccc 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -150,8 +150,7 @@ struct mwifiex_ioctl_req {
 };
 
 struct mwifiex_buffer {
-	struct mwifiex_buffer *prev;
-	struct mwifiex_buffer *next;
+	struct list_head list;
 	u32 status_code;
 	u32 flags;
 	u32 bss_index;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 7b0b10c..de670c7 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -38,6 +38,7 @@ mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bss_prio_node *bss_prio;
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	unsigned long flags;
 
 	ENTER();
 
@@ -49,18 +50,18 @@ mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 	}
 
 	bss_prio->priv = priv;
-
-	mwifiex_util_init_list((struct mwifiex_linked_list *) bss_prio);
-
+	INIT_LIST_HEAD(&bss_prio->list);
 	if (!adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur)
 		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
 			bss_prio;
 
-	mwifiex_util_enqueue_list_tail(&adapter->
-				       bss_prio_tbl[priv->bss_priority].
-				       bss_prio_head,
-				       (struct mwifiex_linked_list *) bss_prio,
-				       true);
+	spin_lock_irqsave(&adapter->bss_prio_tbl[priv->bss_priority]
+			.bss_prio_lock, flags);
+	list_add_tail(&bss_prio->list,
+			&adapter->bss_prio_tbl[priv->bss_priority]
+			.bss_prio_head);
+	spin_unlock_irqrestore(&adapter->bss_prio_tbl[priv->bss_priority]
+			.bss_prio_lock, flags);
 
 exit:
 	LEAVE();
@@ -366,6 +367,9 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 
 	mwifiex_free_buffer(adapter->sleep_cfm);
 
+	/* Free lock variables */
+	mwifiex_free_lock_list(adapter);
+
 	LEAVE();
 	return;
 }
@@ -397,28 +401,36 @@ enum mwifiex_status wlan_init_lock_list(struct mwifiex_adapter *adapter)
 	}
 
 	/* Initialize cmd_free_q */
-	mwifiex_util_init_list_head(&adapter->cmd_free_q, true);
+	INIT_LIST_HEAD(&adapter->cmd_free_q);
 	/* Initialize cmd_pending_q */
-	mwifiex_util_init_list_head(&adapter->cmd_pending_q, true);
+	INIT_LIST_HEAD(&adapter->cmd_pending_q);
 	/* Initialize scan_pending_q */
-	mwifiex_util_init_list_head(&adapter->scan_pending_q, true);
+	INIT_LIST_HEAD(&adapter->scan_pending_q);
+
+	spin_lock_init(&adapter->cmd_free_q_lock);
+	spin_lock_init(&adapter->cmd_pending_q_lock);
+	spin_lock_init(&adapter->scan_pending_q_lock);
 
 	for (i = 0; i < adapter->priv_num; ++i) {
-		mwifiex_util_init_list_head(&adapter->bss_prio_tbl[i]
-							.bss_prio_head, true);
+		INIT_LIST_HEAD(&adapter->bss_prio_tbl[i].bss_prio_head);
 		adapter->bss_prio_tbl[i].bss_prio_cur = NULL;
+		spin_lock_init(&adapter->bss_prio_tbl[i].bss_prio_lock);
 	}
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
 			priv = adapter->priv[i];
-			for (j = 0; j < MAX_NUM_TID; ++j)
-				mwifiex_util_init_list_head(&priv->wmm
-					.tid_tbl_ptr[j].ra_list, true);
-			mwifiex_util_init_list_head(&priv->tx_ba_stream_tbl_ptr,
-									true);
-			mwifiex_util_init_list_head(&priv->rx_reorder_tbl_ptr,
-									true);
+			for (j = 0; j < MAX_NUM_TID; ++j) {
+				INIT_LIST_HEAD(&priv->wmm.tid_tbl_ptr[j]
+						.ra_list);
+				spin_lock_init(&priv->wmm.tid_tbl_ptr[j]
+						.tid_tbl_lock);
+			}
+			INIT_LIST_HEAD(&priv->tx_ba_stream_tbl_ptr);
+			INIT_LIST_HEAD(&priv->rx_reorder_tbl_ptr);
+
+			spin_lock_init(&priv->tx_ba_stream_tbl_lock);
+			spin_lock_init(&priv->rx_reorder_tbl_lock);
 		}
 	}
 
@@ -430,7 +442,7 @@ enum mwifiex_status wlan_init_lock_list(struct mwifiex_adapter *adapter)
  *  This function releases the lock variables and frees the locks and
  *  associated locks.
  */
-void wlan_free_lock_list(struct mwifiex_adapter *adapter)
+void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_private *priv = NULL;
 	s32           i = 0;
@@ -439,25 +451,20 @@ void wlan_free_lock_list(struct mwifiex_adapter *adapter)
 	ENTER();
 
 	/* Free lists */
-	mwifiex_util_free_list_head(&adapter->cmd_free_q);
-
-	mwifiex_util_free_list_head(&adapter->cmd_pending_q);
-
-	mwifiex_util_free_list_head(&adapter->scan_pending_q);
+	list_del(&adapter->cmd_free_q);
+	list_del(&adapter->cmd_pending_q);
+	list_del(&adapter->scan_pending_q);
 
 	for (i = 0; i < adapter->priv_num; i++)
-		mwifiex_util_free_list_head(&adapter->bss_prio_tbl[i]
-							.bss_prio_head);
+		list_del(&adapter->bss_prio_tbl[i].bss_prio_head);
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
 			priv = adapter->priv[i];
 			for (j = 0; j < MAX_NUM_TID; ++j)
-				mwifiex_util_free_list_head(&priv->wmm
-						.tid_tbl_ptr[j].ra_list);
-			mwifiex_util_free_list_head(
-						&priv->tx_ba_stream_tbl_ptr);
-			mwifiex_util_free_list_head(&priv->rx_reorder_tbl_ptr);
+				list_del(&priv->wmm.tid_tbl_ptr[j].ra_list);
+			list_del(&priv->tx_ba_stream_tbl_ptr);
+			list_del(&priv->rx_reorder_tbl_ptr);
 		}
 	}
 
@@ -483,6 +490,8 @@ mwifiex_init_fw(struct mwifiex_adapter *adapter)
 	struct mwifiex_private *priv = NULL;
 	u8 i = 0;
 	u8 first_sta = true;
+	int is_cmd_pend_q_empty;
+	unsigned long flags;
 
 	ENTER();
 
@@ -521,7 +530,10 @@ mwifiex_init_fw(struct mwifiex_adapter *adapter)
 		}
 	}
 
-	if (mwifiex_util_peek_list(&adapter->cmd_pending_q, true)) {
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
+	is_cmd_pend_q_empty = list_empty(&adapter->cmd_pending_q);
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
+	if (!is_cmd_pend_q_empty) {
 		/* Send the first command in queue and return */
 		if (mwifiex_main_process(adapter) != MWIFIEX_STATUS_FAILURE)
 			ret = MWIFIEX_STATUS_PENDING;
@@ -672,37 +684,40 @@ mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bss_prio_node *bssprio_node = NULL, *tmp_node = NULL,
 								**cur = NULL;
-	struct mwifiex_list_head *head;
+	struct list_head *head;
+	spinlock_t *lock;
+	unsigned long flags;
 
 	ENTER();
 
 	for (i = 0; i < adapter->priv_num; ++i) {
 		head = &adapter->bss_prio_tbl[i].bss_prio_head;
 		cur = &adapter->bss_prio_tbl[i].bss_prio_cur;
+		lock = &adapter->bss_prio_tbl[i].bss_prio_lock;
 		PRINTM(MINFO, "Delete BSS priority table, index = %d, i = %d, "
 			      "head = %p, cur = %p\n",
 			      priv->bss_index, i, head, *cur);
 		if (*cur) {
-			bssprio_node = (struct mwifiex_bss_prio_node *)
-				mwifiex_util_peek_list(head, true);
-			while (bssprio_node
-			       && ((struct mwifiex_list_head *) bssprio_node !=
-				   head)) {
-				tmp_node = bssprio_node->next;
+			spin_lock_irqsave(lock, flags);
+			if (list_empty(head)) {
+				spin_unlock_irqrestore(lock, flags);
+				continue;
+			}
+			bssprio_node = list_first_entry(head,
+					struct mwifiex_bss_prio_node, list);
+			spin_unlock_irqrestore(lock, flags);
+
+			list_for_each_entry_safe(bssprio_node, tmp_node, head,
+						 list) {
 				if (bssprio_node->priv == priv) {
 					PRINTM(MINFO, "Delete node, node = %p,"
 						      " next = %p\n",
 						      bssprio_node, tmp_node);
-					mwifiex_util_unlink_list(head,
-							(struct
-							 mwifiex_linked_list
-							 *)
-							bssprio_node,
-							true);
-
+					spin_lock_irqsave(lock, flags);
+					list_del(&bssprio_node->list);
+					spin_unlock_irqrestore(lock, flags);
 					kfree(bssprio_node);
 				}
-				bssprio_node = tmp_node;
 			}
 			*cur = (struct mwifiex_bss_prio_node *)head;
 		}
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 36bb35d..0f26068 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -160,7 +160,7 @@ error:
 	PRINTM(MINFO, "Leave mwifiex_register with error\n");
 
 	/* Free lock variables */
-	wlan_free_lock_list(adapter);
+	mwifiex_free_lock_list(adapter);
 	for (i = 0; i < MWIFIEX_MAX_BSS_NUM; i++)
 		kfree(adapter->priv[i]);
 	kfree(adapter);
@@ -177,7 +177,6 @@ exit_register:
  *
  * The following cleanup operations are performed -
  *      - Free the timers
- *      - Free the locks
  *      - Free beacon buffers
  *      - Free private structures
  *      - Free adapter structure
@@ -191,9 +190,6 @@ mwifiex_unregister(struct mwifiex_adapter *adapter)
 
 	del_timer(&adapter->cmd_timer);
 
-	/* Free lock variables */
-	wlan_free_lock_list(adapter);
-
 	/* Free private structures */
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
@@ -258,7 +254,7 @@ process_start:
 		if ((adapter->ps_state == PS_STATE_SLEEP) &&
 		    (adapter->pm_wakeup_card_req &&
 		     !adapter->pm_wakeup_fw_try) &&
-		    (mwifiex_util_peek_list(&adapter->cmd_pending_q, true)
+		    (is_command_pending(adapter)
 		     || !mwifiex_wmm_lists_empty(adapter))) {
 			adapter->pm_wakeup_fw_try = true;
 			adapter->if_ops.wakeup(adapter);
@@ -280,8 +276,7 @@ process_start:
 			    || mwifiex_wmm_lists_empty(adapter)) {
 				if (adapter->cmd_sent || adapter->curr_cmd
 				    ||
-				    (!mwifiex_util_peek_list
-				     (&adapter->cmd_pending_q, true)))
+				    (!is_command_pending(adapter)))
 					break;
 			}
 		}
@@ -341,7 +336,7 @@ process_start:
 		}
 
 		if (adapter->delay_null_pkt && !adapter->cmd_sent &&
-		    !adapter->curr_cmd && !IS_COMMAND_PENDING(adapter)
+		    !adapter->curr_cmd && !is_command_pending(adapter)
 		    && mwifiex_wmm_lists_empty(adapter)) {
 			if (mwifiex_send_null_packet
 			    (mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
@@ -424,8 +419,8 @@ mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
 /*
  * This function frees the adapter structure.
  *
- * Additionally, this closes the netlink socket, frees the timers,
- * locks and private structures.
+ * Additionally, this closes the netlink socket, frees the timers
+ * and private structures.
  */
 static void mwifiex_free_adapter(struct mwifiex_adapter *adapter)
 {
@@ -1080,6 +1075,21 @@ void mwifiex_mac2u8(u8 *mac_addr, char *buf)
 }
 
 /*
+ * This function check if command is pending.
+ */
+int is_command_pending(struct mwifiex_adapter *adapter)
+{
+	unsigned long flags;
+	int is_cmd_pend_q_empty;
+
+	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
+	is_cmd_pend_q_empty = list_empty(&adapter->cmd_pending_q);
+	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
+
+	return !is_cmd_pend_q_empty;
+}
+
+/*
  * This function returns the correct private structure pointer based
  * upon the BSS number.
  */
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index eb17ced..6c85bf4 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -203,16 +203,20 @@ struct mwifiex_tx_aggr {
 };
 
 struct mwifiex_ra_list_tbl {
-	struct mwifiex_ra_list_tbl *prev;
-	struct mwifiex_ra_list_tbl *next;
-	struct mwifiex_list_head buf_head;
+	struct list_head list;
+	struct list_head buf_head;
+	/* spin lock for ra list table */
+	spinlock_t ra_list_tbl_lock;
+
 	u8 ra[MWIFIEX_MAC_ADDR_LENGTH];
 	u32 total_pkts_size;
 	u32 is_11n_enabled;
 };
 
 struct mwifiex_tid_tbl {
-	struct mwifiex_list_head ra_list;
+	struct list_head ra_list;
+	/* spin lock for tid table */
+	spinlock_t tid_tbl_lock;
 	struct mwifiex_ra_list_tbl *ra_list_curr;
 };
 
@@ -369,12 +373,16 @@ struct mwifiex_private {
 	u8 wmm_enabled;
 	u8 wmm_qosinfo;
 	struct mwifiex_wmm_desc wmm;
-	struct mwifiex_list_head tx_ba_stream_tbl_ptr;
+	struct list_head tx_ba_stream_tbl_ptr;
+	/* spin lock for tx_ba_stream_tbl_ptr queue */
+	spinlock_t tx_ba_stream_tbl_lock;
 	struct mwifiex_tx_aggr aggr_prio_tbl[MAX_NUM_TID];
 	u8 addba_reject[MAX_NUM_TID];
 	struct mwifiex_add_ba_param add_ba_param;
 	u16 rx_seq[MAX_NUM_TID];
-	struct mwifiex_list_head rx_reorder_tbl_ptr;
+	struct list_head rx_reorder_tbl_ptr;
+	/* spin lock for rx_reorder_tbl_ptr queue */
+	spinlock_t rx_reorder_tbl_lock;
 	/* spin lock for Rx packets */
 	spinlock_t rx_pkt_lock;
 
@@ -437,8 +445,7 @@ enum mwifiex_ba_status {
 };
 
 struct mwifiex_tx_ba_stream_tbl {
-	struct mwifiex_tx_ba_stream_tbl *prev;
-	struct mwifiex_tx_ba_stream_tbl *next;
+	struct list_head list;
 	int tid;
 	u8 ra[MWIFIEX_MAC_ADDR_LENGTH];
 	enum mwifiex_ba_status ba_status;
@@ -453,8 +460,7 @@ struct reorder_tmr_cnxt {
 };
 
 struct mwifiex_rx_reorder_tbl {
-	struct mwifiex_rx_reorder_tbl *prev;
-	struct mwifiex_rx_reorder_tbl *next;
+	struct list_head list;
 	int tid;
 	u8 ta[MWIFIEX_MAC_ADDR_LENGTH];
 	int start_win;
@@ -464,19 +470,19 @@ struct mwifiex_rx_reorder_tbl {
 };
 
 struct mwifiex_bss_prio_node {
-	struct mwifiex_bss_prio_node *prev;
-	struct mwifiex_bss_prio_node *next;
+	struct list_head list;
 	struct mwifiex_private *priv;
 };
 
 struct mwifiex_bss_prio_tbl {
-	struct mwifiex_list_head     bss_prio_head;
+	struct list_head bss_prio_head;
+	/* spin lock for bss priority  */
+	spinlock_t bss_prio_lock;
 	struct mwifiex_bss_prio_node *bss_prio_cur;
 };
 
 struct cmd_ctrl_node {
-	struct cmd_ctrl_node *prev;
-	struct cmd_ctrl_node *next;
+	struct list_head list;
 	struct mwifiex_private *priv;
 	u32 cmd_oid;
 	u32 cmd_flag;
@@ -561,9 +567,15 @@ struct mwifiex_adapter {
 	u32 num_cmd_timeout;
 	u16 last_init_cmd;
 	struct timer_list cmd_timer;
-	struct mwifiex_list_head cmd_free_q;
-	struct mwifiex_list_head cmd_pending_q;
-	struct mwifiex_list_head scan_pending_q;
+	struct list_head cmd_free_q;
+	/* spin lock for cmd_free_q */
+	spinlock_t cmd_free_q_lock;
+	struct list_head cmd_pending_q;
+	/* spin lock for cmd_pending_q */
+	spinlock_t cmd_pending_q_lock;
+	struct list_head scan_pending_q;
+	/* spin lock for scan_pending_q */
+	spinlock_t scan_pending_q_lock;
 	u32 scan_processing;
 	u16 region_code;
 	struct mwifiex_802_11d_domain_reg domain_reg;
@@ -619,7 +631,7 @@ struct mwifiex_adapter {
 };
 
 enum mwifiex_status wlan_init_lock_list(struct mwifiex_adapter *adapter);
-void wlan_free_lock_list(struct mwifiex_adapter *adapter);
+void mwifiex_free_lock_list(struct mwifiex_adapter *adapter);
 
 enum mwifiex_status mwifiex_init_fw(struct mwifiex_adapter *adapter);
 
@@ -855,6 +867,7 @@ enum mwifiex_status mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
 enum mwifiex_status mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 					    struct host_cmd_ds_command *resp,
 					    void *ioctl_buf);
+int is_command_pending(struct mwifiex_adapter *adapter);
 
 /*
  * This function checks if the queuing is RA based or not.
@@ -890,11 +903,6 @@ mwifiex_copy_rates(u8 *dest, u32 pos, u8 *src, int len)
 	return pos;
 }
 
-
-#define IS_COMMAND_PENDING(adapter) ((struct cmd_ctrl_node *)\
-					mwifiex_util_peek_list( \
-					&adapter->cmd_pending_q, true))
-
 /*
  * This function returns the correct private structure pointer based
  * upon the BSS type and BSS number.
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 83e466e..df4a77c 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2589,16 +2589,23 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 
 	/* Get scan command from scan_pending_q and put to cmd_pending_q */
 	if (ret == MWIFIEX_STATUS_SUCCESS) {
-		if (mwifiex_util_peek_list(&adapter->scan_pending_q, true)) {
-			cmd_node = (struct cmd_ctrl_node *)
-				mwifiex_util_dequeue_list(&adapter->
-							  scan_pending_q, true);
+		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+		if (!list_empty(&adapter->scan_pending_q)) {
+			cmd_node = list_first_entry(&adapter->scan_pending_q,
+						struct cmd_ctrl_node, list);
+			list_del(&cmd_node->list);
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+									flags);
+
 			spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 			adapter->scan_processing = true;
 			spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock,
 					       flags);
 			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
 							true);
+		} else {
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       flags);
 		}
 	}
 
@@ -2919,7 +2926,9 @@ mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	/* Update the total number of BSSIDs in the scan table */
 	adapter->num_in_scan_table = num_in_table;
 
-	if (!mwifiex_util_peek_list(&adapter->scan_pending_q, true)) {
+	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+	if (list_empty(&adapter->scan_pending_q)) {
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
@@ -2950,10 +2959,10 @@ mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	} else {
 		/* Get scan command from scan_pending_q and put to
 		   cmd_pending_q */
-		cmd_node =
-			(struct cmd_ctrl_node *)
-			mwifiex_util_dequeue_list(&adapter->scan_pending_q,
-						  true);
+		cmd_node = list_first_entry(&adapter->scan_pending_q,
+					    struct cmd_ctrl_node, list);
+		list_del(&cmd_node->list);
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
 
 		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
 	}
@@ -3149,15 +3158,16 @@ mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 		       struct cmd_ctrl_node *cmd_node)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
+	unsigned long flags;
 
 	ENTER();
 
 	if (cmd_node == NULL)
 		goto done;
-	mwifiex_util_enqueue_list_tail(&adapter->scan_pending_q,
-				       (struct mwifiex_linked_list *) cmd_node,
-				       true);
 
+	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+	list_add_tail(&cmd_node->list, &adapter->scan_pending_q);
+	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
 done:
 	LEAVE();
 }
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index a83c72a..05a869c 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -45,7 +45,7 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp,
 			      struct mwifiex_ioctl_req *ioctl_buf)
 {
-	struct cmd_ctrl_node *cmd_node = NULL;
+	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	unsigned long flags;
 
@@ -77,16 +77,18 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 		break;
 	case HostCmd_CMD_802_11_SCAN:
 		/* Cancel all pending scan command */
-		while ((cmd_node =
-			(struct cmd_ctrl_node *)
-			mwifiex_util_peek_list(&adapter->scan_pending_q,
-					       true))) {
-			mwifiex_util_unlink_list(&adapter->scan_pending_q,
-						 (struct mwifiex_linked_list *)
-						 cmd_node, true);
+		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+		list_for_each_entry_safe(cmd_node, tmp_node,
+					 &adapter->scan_pending_q, list) {
+			list_del(&cmd_node->list);
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       flags);
 			cmd_node->ioctl_buf = NULL;
 			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+			spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 		}
+		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index b80d245..c4385ef 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -234,7 +234,7 @@ mwifiex_check_last_packet_indication(struct mwifiex_private *priv)
 	}
 
 	if (ret && !adapter->cmd_sent && !adapter->curr_cmd
-	    && !IS_COMMAND_PENDING(adapter)) {
+	    && !is_command_pending(adapter)) {
 		adapter->delay_null_pkt = false;
 		ret = true;
 	} else {
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 55d912d..7e1bc9b 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -63,147 +63,6 @@ mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function peeks into a list.
- *
- * A pointer to the next node in the list is returned, but the node
- * is not dequeued.
- */
-struct mwifiex_linked_list *
-mwifiex_util_peek_list(struct mwifiex_list_head *head, u8 lock_required)
-{
-	struct mwifiex_linked_list *node = NULL;
-	unsigned long flags;
-
-	if (lock_required) {
-		spin_lock_irqsave(&head->lock, flags);
-		if (head->next != (struct mwifiex_linked_list *) head)
-			node = head->next;
-		spin_unlock_irqrestore(&head->lock, flags);
-	} else {
-		if (head->next != (struct mwifiex_linked_list *) head)
-			node = head->next;
-	}
-
-	return node;
-}
-
-/*
- * This function initializes a list.
- *
- * It also initializes the associated lock if required.
- */
-inline void
-mwifiex_util_init_list_head(struct mwifiex_list_head *head, u8 lock_required)
-{
-	mwifiex_util_init_list((struct mwifiex_linked_list *) head);
-	if (lock_required)
-		spin_lock_init(&head->lock);
-}
-
-/*
- * This function queues a new node at the list tail.
- */
-inline void
-mwifiex_util_enqueue_list_tail(struct mwifiex_list_head *head,
-			       struct mwifiex_linked_list *node,
-			       u8 lock_required)
-{
-	struct mwifiex_linked_list *old_last;
-	unsigned long flags = 0;
-
-	if (lock_required)
-		spin_lock_irqsave(&head->lock, flags);
-
-	old_last = head->prev;
-	node->prev = old_last;
-	node->next = (struct mwifiex_linked_list *) head;
-
-	old_last->next = node;
-	head->prev = old_last->next;
-
-	if (lock_required)
-		spin_unlock_irqrestore(&head->lock, flags);
-}
-
-/*
- * This function queues a new node at the list head.
- */
-inline void
-mwifiex_util_enqueue_list_head(struct mwifiex_list_head *head,
-			       struct mwifiex_linked_list *node,
-			       u8 lock_required)
-{
-	struct mwifiex_linked_list *old_first;
-	unsigned long flags = 0;
-
-	if (lock_required)
-		spin_lock_irqsave(&head->lock, flags);
-
-	old_first = head->next;
-	node->prev = (struct mwifiex_linked_list *) head;
-	node->next = old_first;
-
-	old_first->prev = node;
-	head->next = old_first->prev;
-
-	if (lock_required)
-		spin_unlock_irqrestore(&head->lock, flags);
-}
-
-/*
- * This function removes a node from the list.
- *
- * The node can be removed from any location within the list,
- * the other node pointers are adjusted accordingly.
- */
-inline void
-mwifiex_util_unlink_list(struct mwifiex_list_head *head,
-			 struct mwifiex_linked_list *node, u8 lock_required)
-{
-	struct mwifiex_linked_list *my_prev;
-	struct mwifiex_linked_list *my_next;
-	unsigned long flags = 0;
-
-	if (lock_required)
-		spin_lock_irqsave(&head->lock, flags);
-
-	my_prev = node->prev;
-	my_next = node->next;
-	my_next->prev = my_prev;
-	my_prev->next = my_next;
-
-	node->prev = NULL;
-	node->next = node->prev;
-
-	if (lock_required)
-		spin_unlock_irqrestore(&head->lock, flags);
-}
-
-/*
- * This function dequeues a node from the list.
- */
-inline struct mwifiex_linked_list *
-mwifiex_util_dequeue_list(struct mwifiex_list_head *head, u8 lock_required)
-{
-	struct mwifiex_linked_list *node;
-	unsigned long flags = 0;
-
-	if (lock_required)
-		spin_lock_irqsave(&head->lock, flags);
-
-	node = head->next;
-	if (node != (struct mwifiex_linked_list *) head)
-		mwifiex_util_unlink_list(head, node, false);
-	else
-		node = NULL;
-
-	if (lock_required)
-		spin_unlock_irqrestore(&head->lock, flags);
-
-	return node;
-}
-
-/*
  * IOCTL request handler to send a host command to firmware.
  *
  * This function prepares the correct firmware command and
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index 12ba9f9..eaf4b06 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -103,50 +103,4 @@ do {                \
 	mwifiex_print(MHEX_DUMP | MINFO, x, y, z); \
 } while (0)
 
-struct mwifiex_linked_list {
-	struct mwifiex_linked_list *prev;
-	struct mwifiex_linked_list *next;
-};
-
-struct mwifiex_list_head {
-	struct mwifiex_linked_list *prev;
-	struct mwifiex_linked_list *next;
-	/* spin lock used for linked list operations */
-	spinlock_t lock;
-};
-
-void mwifiex_util_init_list_head(struct mwifiex_list_head *head,
-				u8 lock_required);
-void mwifiex_util_enqueue_list_tail(struct mwifiex_list_head *head,
-			       struct mwifiex_linked_list *node,
-			       u8 lock_required);
-void mwifiex_util_unlink_list(struct mwifiex_list_head *head,
-			 struct mwifiex_linked_list *node, u8 lock_required);
-void mwifiex_util_enqueue_list_head(struct mwifiex_list_head *head,
-			       struct mwifiex_linked_list *node,
-			       u8 lock_required);
-struct mwifiex_linked_list *mwifiex_util_dequeue_list(struct mwifiex_list_head
-				*head, u8 lock_required);
-struct mwifiex_linked_list *mwifiex_util_peek_list(struct mwifiex_list_head
-				*head, u8 lock_required);
-
-/*
- * This function initializes a list without locking.
- */
-static inline void
-mwifiex_util_init_list(struct mwifiex_linked_list *head)
-{
-	head->next = (struct mwifiex_linked_list *) head;
-	head->prev = head->next;
-}
-
-/*
- * This function frees a list and the associated lock.
- */
-static inline void
-mwifiex_util_free_list_head(struct mwifiex_list_head *head)
-{
-	head->next = NULL;
-	head->prev = head->next;
-}
 #endif /* !_MWIFIEX_UTIL_H_ */
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 2a403ae..a0c29b4 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -121,8 +121,9 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 		PRINTM(MERROR, "%s: failed to alloc ra_list\n", __func__);
 		goto done;
 	}
-	mwifiex_util_init_list((struct mwifiex_linked_list *) ra_list);
-	mwifiex_util_init_list_head(&ra_list->buf_head, false);
+	INIT_LIST_HEAD(&ra_list->list);
+	INIT_LIST_HEAD(&ra_list->buf_head);
+	spin_lock_init(&ra_list->ra_list_tbl_lock);
 
 	memcpy(ra_list->ra, ra, MWIFIEX_MAC_ADDR_LENGTH);
 
@@ -196,10 +197,8 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 		PRINTM(MDATA, "ralist %p: is_11n_enabled=%d\n", ra_list,
 		       ra_list->is_11n_enabled);
 
-		mwifiex_util_enqueue_list_tail(&priv->wmm.tid_tbl_ptr[i].
-					       ra_list,
-					       (struct mwifiex_linked_list *)
-					       ra_list, false);
+		list_add_tail(&ra_list->list,
+				&priv->wmm.tid_tbl_ptr[i].ra_list);
 
 		if (!priv->wmm.tid_tbl_ptr[i].ra_list_curr)
 			priv->wmm.tid_tbl_ptr[i].ra_list_curr = ra_list;
@@ -548,23 +547,17 @@ static void
 mwifiex_wmm_del_pkts_in_ralist_node(struct mwifiex_private *priv,
 				    struct mwifiex_ra_list_tbl *ra_list)
 {
-	struct mwifiex_buffer *mbuf;
+	struct mwifiex_buffer *mbuf, *tmp_node;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	ENTER();
 
-	while ((mbuf =
-		(struct mwifiex_buffer *) mwifiex_util_peek_list(&ra_list->
-								 buf_head,
-								 false))) {
-		mwifiex_util_unlink_list(&ra_list->buf_head,
-					 (struct mwifiex_linked_list *) mbuf,
-					 false);
-
+	list_for_each_entry_safe(mbuf, tmp_node, &ra_list->buf_head, list) {
+		list_del(&mbuf->list);
 		mwifiex_write_data_complete(adapter, mbuf,
-					     MWIFIEX_STATUS_FAILURE);
+				MWIFIEX_STATUS_FAILURE);
 	}
-	mwifiex_util_free_list_head(&ra_list->buf_head);
+	list_del(&ra_list->buf_head);
 
 	LEAVE();
 }
@@ -577,23 +570,15 @@ mwifiex_wmm_del_pkts_in_ralist_node(struct mwifiex_private *priv,
  */
 static void
 mwifiex_wmm_del_pkts_in_ralist(struct mwifiex_private *priv,
-			       struct mwifiex_list_head *ra_list_head)
+			       struct list_head *ra_list_head)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 
 	ENTER();
 
-	ra_list =
-		(struct mwifiex_ra_list_tbl *)
-		mwifiex_util_peek_list(ra_list_head, false);
-
-	while (ra_list
-	       && ra_list != (struct mwifiex_ra_list_tbl *) ra_list_head) {
+	list_for_each_entry(ra_list, ra_list_head, list)
 		mwifiex_wmm_del_pkts_in_ralist_node(priv, ra_list);
 
-		ra_list = ra_list->next;
-	}
-
 	LEAVE();
 }
 
@@ -622,27 +607,21 @@ mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv)
 void
 mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
 {
-	struct mwifiex_ra_list_tbl *ra_list;
+	struct mwifiex_ra_list_tbl *ra_list, *tmp_node;
 	int i;
 
 	ENTER();
 
 	for (i = 0; i < MAX_NUM_TID; ++i) {
 		PRINTM(MINFO, "RAList: Freeing buffers for TID %d\n", i);
-		while ((ra_list =
-			(struct mwifiex_ra_list_tbl *)
-			mwifiex_util_peek_list(&priv->wmm.tid_tbl_ptr[i].
-					       ra_list, false))) {
-			mwifiex_util_unlink_list(&priv->wmm.tid_tbl_ptr[i].
-						 ra_list,
-						 (struct mwifiex_linked_list *)
-						 ra_list, false);
-
+		list_for_each_entry_safe(ra_list, tmp_node,
+				&priv->wmm.tid_tbl_ptr[i].ra_list, list) {
+			list_del(&ra_list->list);
 			kfree(ra_list);
 		}
 
-		mwifiex_util_init_list((struct mwifiex_linked_list *)
-					&priv->wmm.tid_tbl_ptr[i].ra_list);
+		INIT_LIST_HEAD(&priv->wmm.tid_tbl_ptr[i].ra_list);
+
 		priv->wmm.tid_tbl_ptr[i].ra_list_curr = NULL;
 	}
 
@@ -658,22 +637,17 @@ mwifiex_wmm_get_ralist_node(struct mwifiex_private *priv, u8 tid,
 			    u8 *ra_addr)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
+
 	ENTER();
-	ra_list =
-		(struct mwifiex_ra_list_tbl *) mwifiex_util_peek_list(&priv->
-								wmm.
-								tid_tbl_ptr
-								[tid].
-								ra_list,
-								false);
-	while (ra_list && (ra_list != (struct mwifiex_ra_list_tbl *)
-			   &priv->wmm.tid_tbl_ptr[tid].ra_list)) {
+
+	list_for_each_entry(ra_list, &priv->wmm.tid_tbl_ptr[tid].ra_list,
+			    list) {
 		if (!memcmp(ra_list->ra, ra_addr, MWIFIEX_MAC_ADDR_LENGTH)) {
 			LEAVE();
 			return ra_list;
 		}
-		ra_list = ra_list->next;
 	}
+
 	LEAVE();
 	return NULL;
 }
@@ -714,19 +688,10 @@ mwifiex_is_ralist_valid(struct mwifiex_private *priv,
 {
 	struct mwifiex_ra_list_tbl *rlist;
 
-	rlist = (struct mwifiex_ra_list_tbl *) mwifiex_util_peek_list(&priv->
-								wmm.
-								tid_tbl_ptr
-								[ptr_index].
-								ra_list,
-								false);
-
-	while (rlist && (rlist != (struct mwifiex_ra_list_tbl *)
-			 &priv->wmm.tid_tbl_ptr[ptr_index].ra_list)) {
+	list_for_each_entry(rlist, &priv->wmm.tid_tbl_ptr[ptr_index].ra_list,
+			    list) {
 		if (rlist == ra_list)
 			return true;
-
-		rlist = rlist->next;
 	}
 
 	return false;
@@ -773,10 +738,14 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 	   association we just don't have to call get_queue_raptr, we will
 	   have only 1 raptr for a tid in case of infra */
 	if (!mwifiex_queuing_ra_based(priv)) {
-		ra_list =
-			(struct mwifiex_ra_list_tbl *)
-			mwifiex_util_peek_list(&priv->wmm.tid_tbl_ptr[tid_down].
-					       ra_list, false);
+		if (!list_empty(&priv->wmm.tid_tbl_ptr[tid_down].ra_list))
+			ra_list = list_first_entry(&priv->wmm
+						   .tid_tbl_ptr[tid_down]
+						   .ra_list,
+						   struct mwifiex_ra_list_tbl,
+						   list);
+		else
+			ra_list = NULL;
 	} else {
 		memcpy(ra, mbuf->buffer + mbuf->data_offset,
 		       MWIFIEX_MAC_ADDR_LENGTH);
@@ -792,9 +761,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 	}
 
 	PRINTM(MDAT_D, "Adding pkt to ra_list %p %p\n", ra_list, mbuf);
-	mwifiex_util_enqueue_list_tail(&ra_list->buf_head,
-				       (struct mwifiex_linked_list *) mbuf,
-				       false);
+	list_add_tail(&mbuf->list, &ra_list->buf_head);
 
 	ra_list->total_pkts_size += mbuf->data_len;
 
@@ -1016,22 +983,31 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 	struct mwifiex_ra_list_tbl *ptr, *head;
 	struct mwifiex_bss_prio_node *bssprio_node, *bssprio_head;
 	struct mwifiex_tid_tbl *tid_ptr;
+	int is_list_empty;
+	unsigned long flags;
 	int i, j;
 
 	ENTER();
 
 	PRINTM(MDAT_D, "POP\n");
 	for (j = adapter->priv_num - 1; j >= 0; --j) {
-		if (!
-		    (mwifiex_util_peek_list
-		     (&adapter->bss_prio_tbl[j].bss_prio_head, true)))
+		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
+				flags);
+		is_list_empty = list_empty(&adapter->bss_prio_tbl[j]
+				.bss_prio_head);
+		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
+				flags);
+		if (is_list_empty)
 			continue;
 
 		if (adapter->bss_prio_tbl[j].bss_prio_cur ==
 		    (struct mwifiex_bss_prio_node *)
 		    &adapter->bss_prio_tbl[j].bss_prio_head) {
 			bssprio_node =
-				adapter->bss_prio_tbl[j].bss_prio_cur->next;
+				list_first_entry(&adapter->bss_prio_tbl[j]
+						 .bss_prio_head,
+						 struct mwifiex_bss_prio_node,
+						 list);
 			bssprio_head = bssprio_node;
 		} else {
 			bssprio_node =
@@ -1047,8 +1023,15 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				tid_ptr =
 					&(priv_tmp)->wmm.
 					tid_tbl_ptr[tos_to_tid[i]];
-				if (!mwifiex_util_peek_list
-				    (&tid_ptr->ra_list, true))
+
+				spin_lock_irqsave(&tid_ptr->tid_tbl_lock,
+						  flags);
+				is_list_empty =
+					list_empty(&adapter->bss_prio_tbl[j]
+						   .bss_prio_head);
+				spin_unlock_irqrestore(&tid_ptr->tid_tbl_lock,
+						       flags);
+				if (is_list_empty)
 					continue;
 
 				/*
@@ -1056,38 +1039,64 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				 * last time, this way we pick the ra's in
 				 * round robin fashion.
 				 */
-				ptr = tid_ptr->ra_list_curr->next;
+				ptr = list_first_entry(
+						&tid_ptr->ra_list_curr->list,
+						struct mwifiex_ra_list_tbl,
+						list);
+
 				head = ptr;
 				if (ptr == (struct mwifiex_ra_list_tbl *)
 						&tid_ptr->ra_list) {
-					ptr = ptr->next;
+					/* Get next ra */
+					ptr = list_first_entry(&ptr->list,
+					    struct mwifiex_ra_list_tbl, list);
 					head = ptr;
 				}
 
 				do {
-					if (mwifiex_util_peek_list
-					    (&ptr->buf_head, true)) {
+					spin_lock_irqsave(
+							&ptr->ra_list_tbl_lock,
+							flags);
+					is_list_empty =
+						list_empty(&ptr->buf_head);
+					spin_unlock_irqrestore(
+							&ptr->ra_list_tbl_lock,
+							flags);
+					if (!is_list_empty) {
 						*priv = priv_tmp;
 						*tid = tos_to_tid[i];
 						LEAVE();
 						return ptr;
 					}
-					ptr = ptr->next;
+					/* Get next ra */
+					ptr = list_first_entry(&ptr->list,
+						 struct mwifiex_ra_list_tbl,
+						 list);
 					if (ptr ==
 					    (struct mwifiex_ra_list_tbl *)
 					    &tid_ptr->ra_list)
-						ptr = ptr->next;
+						ptr = list_first_entry(
+						    &ptr->list,
+						    struct mwifiex_ra_list_tbl,
+						    list);
 				} while (ptr != head);
 			}
 
-			bssprio_node = bssprio_node->next;
+			/* Get next bss priority node */
+			bssprio_node = list_first_entry(&bssprio_node->list,
+						struct mwifiex_bss_prio_node,
+						list);
+
 			if (bssprio_node ==
 			    (struct mwifiex_bss_prio_node *)
 			    &adapter->bss_prio_tbl[j].bss_prio_head)
-				bssprio_node = bssprio_node->next;
+				/* Get next bss priority node */
+				bssprio_node = list_first_entry(
+						&bssprio_node->list,
+						struct mwifiex_bss_prio_node,
+						list);
 		} while (bssprio_node != bssprio_head);
 	}
-
 	LEAVE();
 	return NULL;
 }
@@ -1105,10 +1114,7 @@ mwifiex_num_pkts_in_txq(struct mwifiex_private *priv,
 
 	ENTER();
 
-	for (mbuf = (struct mwifiex_buffer *) ptr->buf_head.next;
-	     mbuf != (struct mwifiex_buffer *) (&ptr->buf_head);
-	     mbuf = mbuf->next) {
-
+	list_for_each_entry(mbuf, &ptr->buf_head, list) {
 		total_size += mbuf->data_len;
 		if (total_size < max_buf_size)
 			++count;
@@ -1126,7 +1132,7 @@ mwifiex_num_pkts_in_txq(struct mwifiex_private *priv,
 static void
 mwifiex_send_single_packet(struct mwifiex_private *priv,
 			   struct mwifiex_ra_list_tbl *ptr, int ptr_index,
-			   unsigned long flags)
+			   unsigned long ra_list_flags)
 			   __releases(&priv->wmm.ra_list_spinlock)
 {
 	struct mwifiex_buffer *mbuf;
@@ -1134,65 +1140,81 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 	struct mwifiex_tx_param tx_param;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	unsigned long ra_list_tbl_flags;
 
 	ENTER();
 
-	mbuf = (struct mwifiex_buffer *)
-		mwifiex_util_dequeue_list(&ptr->buf_head, true);
-	if (mbuf) {
-		PRINTM(MDATA, "Dequeuing the packet %p %p\n", ptr, mbuf);
+	spin_lock_irqsave(&ptr->ra_list_tbl_lock, ra_list_tbl_flags);
+	if (list_empty(&ptr->buf_head)) {
+		spin_unlock_irqrestore(&ptr->ra_list_tbl_lock,
+				       ra_list_tbl_flags);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		PRINTM(MDATA, "Nothing to send\n");
+		return;
+	}
+	mbuf = list_first_entry(&ptr->buf_head,
+				struct mwifiex_buffer, list);
+	list_del(&mbuf->list);
+	spin_unlock_irqrestore(&ptr->ra_list_tbl_lock, ra_list_tbl_flags);
+
+	PRINTM(MDATA, "Dequeuing the packet %p %p\n", ptr, mbuf);
+
+	ptr->total_pkts_size -= mbuf->data_len;
+
+	if (!list_empty(&ptr->buf_head))
+		mbuf_next = list_first_entry(&ptr->buf_head,
+					     struct mwifiex_buffer, list);
+	else
+		mbuf_next = NULL;
+
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
+
+	tx_param.next_pkt_len =
+		((mbuf_next) ? mbuf_next->data_len +
+		 sizeof(struct txpd) : 0);
+	status = mwifiex_process_tx(priv, mbuf, &tx_param);
+
+	if (status == MWIFIEX_STATUS_RESOURCE) {
+		/** Queue the packet back at the head */
+		PRINTM(MDAT_D, "Queuing pkt back to raList %p %p\n",
+		       ptr, mbuf);
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
+
+		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
+			spin_unlock_irqrestore(
+					&priv->wmm.ra_list_spinlock,
+					ra_list_flags);
+			mwifiex_write_data_complete(adapter, mbuf,
+					MWIFIEX_STATUS_FAILURE);
+			LEAVE();
+			return;
+		}
 
-		ptr->total_pkts_size -= mbuf->data_len;
-		mbuf_next =
-			(struct mwifiex_buffer *) mwifiex_util_peek_list(&ptr->
-								buf_head,
-								false);
-		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+		spin_lock_irqsave(&ptr->ra_list_tbl_lock, ra_list_tbl_flags);
+		list_add(&mbuf->list, &ptr->buf_head);
+		spin_unlock_irqrestore(&ptr->ra_list_tbl_lock,
+				       ra_list_tbl_flags);
 
-		tx_param.next_pkt_len =
-			((mbuf_next) ? mbuf_next->data_len +
-			 sizeof(struct txpd) : 0);
-		status = mwifiex_process_tx(priv, mbuf, &tx_param);
-
-		if (status == MWIFIEX_STATUS_RESOURCE) {
-			/** Queue the packet back at the head */
-			PRINTM(MDAT_D, "Queuing pkt back to raList %p %p\n",
-			       ptr, mbuf);
-			spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
-
-			if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-				spin_unlock_irqrestore(
-						&priv->wmm.ra_list_spinlock,
-						flags);
-				mwifiex_write_data_complete(adapter, mbuf,
-						MWIFIEX_STATUS_FAILURE);
-				LEAVE();
-				return;
-			}
-			mwifiex_util_enqueue_list_head(&ptr->buf_head,
-					(struct mwifiex_linked_list *)
-					mbuf, true);
-
-			ptr->total_pkts_size += mbuf->data_len;
-			mbuf->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
-			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
-					       flags);
-		} else {
-			spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
-			if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-				priv->wmm.packets_out[ptr_index]++;
-				priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr =
-					ptr;
-			}
-			adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
-				adapter->bss_prio_tbl[priv->bss_priority].
-				bss_prio_cur->next;
-			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
-					       flags);
-		}
+		ptr->total_pkts_size += mbuf->data_len;
+		mbuf->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
 	} else {
-		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
-		PRINTM(MDATA, "Nothing to send\n");
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
+		if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
+			priv->wmm.packets_out[ptr_index]++;
+			priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr =
+				ptr;
+		}
+		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
+			list_first_entry(
+				&adapter->bss_prio_tbl[priv->bss_priority]
+				.bss_prio_cur->list,
+				struct mwifiex_bss_prio_node,
+				list);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
 	}
 
 	LEAVE();
@@ -1208,9 +1230,12 @@ mwifiex_is_ptr_processed(struct mwifiex_private *priv,
 {
 	struct mwifiex_buffer *mbuf;
 
-	mbuf = (struct mwifiex_buffer *)
-		mwifiex_util_peek_list(&ptr->buf_head, false);
-	if (mbuf && (mbuf->flags & MWIFIEX_BUF_FLAG_REQUEUED_PKT))
+	if (list_empty(&ptr->buf_head))
+		return false;
+
+	mbuf = list_first_entry(&ptr->buf_head, struct mwifiex_buffer, list);
+
+	if (mbuf->flags & MWIFIEX_BUF_FLAG_REQUEUED_PKT)
 		return true;
 
 	return false;
@@ -1223,7 +1248,7 @@ mwifiex_is_ptr_processed(struct mwifiex_private *priv,
 static void
 mwifiex_send_processed_packet(struct mwifiex_private *priv,
 			      struct mwifiex_ra_list_tbl *ptr, int ptr_index,
-			      unsigned long flags)
+			      unsigned long ra_list_flags)
 				__releases(&priv->wmm.ra_list_spinlock)
 {
 	struct mwifiex_buffer *mbuf_next;
@@ -1231,72 +1256,89 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 	struct mwifiex_buffer *mbuf;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	enum mwifiex_status ret = MWIFIEX_STATUS_FAILURE;
+	unsigned long ra_list_tbl_flags;
 
 	ENTER();
 
-	mbuf = (struct mwifiex_buffer *)
-		mwifiex_util_dequeue_list(&ptr->buf_head, true);
-	if (mbuf) {
-		mbuf_next =
-			(struct mwifiex_buffer *) mwifiex_util_peek_list(&ptr->
-								buf_head,
-								false);
-		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
-		tx_param.next_pkt_len =
-			((mbuf_next) ? mbuf_next->data_len +
-			 sizeof(struct txpd) : 0);
-		ret = adapter->if_ops.host_to_card(adapter,
-						     MWIFIEX_TYPE_DATA, mbuf,
-						     &tx_param);
-		switch (ret) {
-		case MWIFIEX_STATUS_RESOURCE:
-			PRINTM(MDATA, "MWIFIEX_STATUS_RESOURCE is returned\n");
-			spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
-
-			if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-				spin_unlock_irqrestore(
-						&priv->wmm.ra_list_spinlock,
-						flags);
-				mwifiex_write_data_complete(adapter, mbuf,
-						MWIFIEX_STATUS_FAILURE);
-				LEAVE();
-				return;
-			}
-			mwifiex_util_enqueue_list_head(&ptr->buf_head,
-						(struct mwifiex_linked_list *)
-						mbuf, true);
+	spin_lock_irqsave(&ptr->ra_list_tbl_lock, ra_list_tbl_flags);
+	if (list_empty(&ptr->buf_head)) {
+		spin_unlock_irqrestore(&ptr->ra_list_tbl_lock,
+				       ra_list_tbl_flags);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		return;
+	}
 
-			mbuf->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
-			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
-					       flags);
-			break;
-		case MWIFIEX_STATUS_FAILURE:
-			adapter->data_sent = false;
-			PRINTM(MERROR,
-			       "Error: mwifiex_write_data failed: 0x%X\n", ret);
-			adapter->dbg.num_tx_host_to_card_failure++;
-			mwifiex_write_data_complete(adapter, mbuf, ret);
-			break;
-		case MWIFIEX_STATUS_PENDING:
-			adapter->data_sent = false;
-		default:
-			break;
+	mbuf = list_first_entry(&ptr->buf_head, struct mwifiex_buffer, list);
+
+	list_del(&mbuf->list);
+	spin_unlock_irqrestore(&ptr->ra_list_tbl_lock, ra_list_tbl_flags);
+
+	if (!list_empty(&ptr->buf_head))
+		mbuf_next = list_first_entry(&ptr->buf_head,
+					     struct mwifiex_buffer, list);
+	else
+		mbuf_next = NULL;
+
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
+	tx_param.next_pkt_len =
+		((mbuf_next) ? mbuf_next->data_len +
+		 sizeof(struct txpd) : 0);
+	ret = adapter->if_ops.host_to_card(adapter,
+					     MWIFIEX_TYPE_DATA, mbuf,
+					     &tx_param);
+	switch (ret) {
+	case MWIFIEX_STATUS_RESOURCE:
+		PRINTM(MDATA, "MWIFIEX_STATUS_RESOURCE is returned\n");
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
+
+		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
+			spin_unlock_irqrestore(
+					&priv->wmm.ra_list_spinlock,
+					ra_list_flags);
+			mwifiex_write_data_complete(adapter, mbuf,
+					MWIFIEX_STATUS_FAILURE);
+			LEAVE();
+			return;
 		}
-		if (ret != MWIFIEX_STATUS_RESOURCE) {
-			spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
-			if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-				priv->wmm.packets_out[ptr_index]++;
-				priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr =
-					ptr;
-			}
-			adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
-				adapter->bss_prio_tbl[priv->bss_priority].
-				bss_prio_cur->next;
-			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
-					       flags);
+
+		spin_lock_irqsave(&ptr->ra_list_tbl_lock, ra_list_tbl_flags);
+		list_add(&mbuf->list, &ptr->buf_head);
+		spin_unlock_irqrestore(&ptr->ra_list_tbl_lock,
+				       ra_list_tbl_flags);
+
+		mbuf->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
+		break;
+	case MWIFIEX_STATUS_FAILURE:
+		adapter->data_sent = false;
+		PRINTM(MERROR,
+		       "Error: mwifiex_write_data failed: 0x%X\n", ret);
+		adapter->dbg.num_tx_host_to_card_failure++;
+		mwifiex_write_data_complete(adapter, mbuf, ret);
+		break;
+	case MWIFIEX_STATUS_PENDING:
+		adapter->data_sent = false;
+	default:
+		break;
+	}
+	if (ret != MWIFIEX_STATUS_RESOURCE) {
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
+		if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
+			priv->wmm.packets_out[ptr_index]++;
+			priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr =
+				ptr;
 		}
-	} else {
-		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+		/* Now bss_prio_cur pointer points to next node */
+		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
+			list_first_entry(
+				&adapter->bss_prio_tbl[priv->bss_priority]
+				.bss_prio_cur->list,
+				struct mwifiex_bss_prio_node,
+				list);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+				       ra_list_flags);
 	}
 
 	LEAVE();
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 88f4480..1dce042 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -28,11 +28,17 @@ mwifiex_get_tid(struct mwifiex_adapter *adapter,
 		struct mwifiex_ra_list_tbl *ptr)
 {
 	struct mwifiex_buffer *mbuf;
+	unsigned long flags;
 
 	ENTER();
 
-	mbuf = (struct mwifiex_buffer *) mwifiex_util_peek_list(&ptr->buf_head,
-								true);
+	spin_lock_irqsave(&ptr->ra_list_tbl_lock, flags);
+	if (list_empty(&ptr->buf_head)) {
+		spin_unlock_irqrestore(&ptr->ra_list_tbl_lock, flags);
+		return 0;
+	}
+	mbuf = list_first_entry(&ptr->buf_head, struct mwifiex_buffer, list);
+	spin_unlock_irqrestore(&ptr->ra_list_tbl_lock, flags);
 
 	LEAVE();
 	return mbuf->priority;
@@ -43,19 +49,15 @@ mwifiex_get_tid(struct mwifiex_adapter *adapter,
  */
 static inline int
 mwifiex_wmm_list_len(struct mwifiex_adapter *adapter,
-		     struct mwifiex_list_head *head)
+		     struct list_head *head)
 {
-	struct mwifiex_linked_list *pos;
+	struct list_head *pos;
 	int count = 0;
 
 	ENTER();
 
-	pos = head->next;
-
-	while (pos != (struct mwifiex_linked_list *) head) {
+	list_for_each(pos, head)
 		++count;
-		pos = pos->next;
-	}
 
 	LEAVE();
 	return count;
@@ -66,17 +68,18 @@ mwifiex_wmm_list_len(struct mwifiex_adapter *adapter,
  */
 static inline u8
 mwifiex_wmm_is_ra_list_empty(struct mwifiex_adapter *adapter,
-			     struct mwifiex_list_head *ra_list_hhead)
+			     struct list_head *ra_list_hhead)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
-
-	ra_list = (struct mwifiex_ra_list_tbl *) ra_list_hhead->next;
-
-	while (ra_list != (struct mwifiex_ra_list_tbl *) ra_list_hhead) {
-		if (mwifiex_util_peek_list(&ra_list->buf_head, true))
+	int is_list_empty;
+	unsigned long flags;
+
+	list_for_each_entry(ra_list, ra_list_hhead, list) {
+		spin_lock_irqsave(&ra_list->ra_list_tbl_lock, flags);
+		is_list_empty = list_empty(&ra_list->buf_head);
+		spin_unlock_irqrestore(&ra_list->ra_list_tbl_lock, flags);
+		if (!is_list_empty)
 			return false;
-
-		ra_list = (struct mwifiex_ra_list_tbl *) ra_list->next;
 	}
 
 	return true;
-- 
1.7.0.2

