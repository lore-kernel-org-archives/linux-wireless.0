Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51862 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0LPA6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 19:58:00 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: remove wrapper functions for spin_lock/spin_unlock
Date: Wed, 15 Dec 2010 16:57:56 -0800
Message-Id: <1292461079-26318-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Call spin_lock/spin_unlock functions directly instead of driver
specific wrapper functions. Use sparse annotations (__acquires()
/__releases()) to fix context imbalance sparse warnings.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |    7 +-
 drivers/net/wireless/mwifiex/11n_aggr.c      |   27 ++++---
 drivers/net/wireless/mwifiex/11n_aggr.h      |    3 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   20 +++--
 drivers/net/wireless/mwifiex/cmdevt.c        |   54 +++++++------
 drivers/net/wireless/mwifiex/init.c          |   78 +++----------------
 drivers/net/wireless/mwifiex/main.c          |   11 ++-
 drivers/net/wireless/mwifiex/main.h          |   21 +++--
 drivers/net/wireless/mwifiex/scan.c          |   22 +++--
 drivers/net/wireless/mwifiex/sdio.c          |   10 ++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |    9 +-
 drivers/net/wireless/mwifiex/txrx.c          |    7 +-
 drivers/net/wireless/mwifiex/util.c          |  110 ++++++--------------------
 drivers/net/wireless/mwifiex/util.h          |   16 +---
 drivers/net/wireless/mwifiex/wmm.c           |   72 ++++++++++-------
 15 files changed, 193 insertions(+), 274 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index d1494bf..73d2fb7 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -1102,9 +1102,11 @@ void
 mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 		struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl)
 {
+	unsigned long flags;
+
 	ENTER();
 
-	mwifiex_spin_lock(priv->tx_ba_stream_tbl_ptr.lock);
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_ptr.lock, flags);
 
 	if (!tx_ba_tsr_tbl &&
 			mwifiex_is_tx_ba_stream_ptr_valid(priv, tx_ba_tsr_tbl))
@@ -1119,7 +1121,8 @@ mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 	kfree(tx_ba_tsr_tbl);
 
 exit:
-	mwifiex_spin_unlock(priv->tx_ba_stream_tbl_ptr.lock);
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_ptr.lock, flags);
+
 	LEAVE();
 }
 
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index e100ffc..ca24d54 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -306,7 +306,8 @@ done:
 int
 mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			  struct mwifiex_ra_list_tbl *pra_list, int headroom,
-			  int ptrindex)
+			  int ptrindex, unsigned long flags)
+			  __releases(&priv->wmm.ra_list_spinlock)
 {
 	int pkt_size = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -317,6 +318,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	struct timeval tstamp;
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
+
 	ENTER();
 
 	PRINTM(MDAT_D, "Handling Aggr packet\n");
@@ -329,6 +331,8 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		if (!mbuf_aggr) {
 			PRINTM(MERROR,
 			       "Error allocating struct mwifiex_buffer\n");
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       flags);
 			return MWIFIEX_STATUS_FAILURE;
 		}
 
@@ -347,6 +351,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
 			ptx_pd = (struct txpd *)mbuf_aggr->buffer;
 	} else {
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 		goto exit;
 	}
 
@@ -359,7 +364,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 		pra_list->total_pkts_size -= mbuf_src->data_len;
 
-		mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 		pkt_size += mwifiex_11n_form_amsdu_pkt(adapter,
 						       (data + pkt_size),
 						       mbuf_src->buffer +
@@ -372,10 +377,11 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		mwifiex_write_data_complete(adapter, mbuf_src,
 					     MWIFIEX_STATUS_SUCCESS);
 
-		mwifiex_spin_lock(priv->wmm.ra_list_spinlock);
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 
 		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
-			mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       flags);
 			LEAVE();
 			return MWIFIEX_STATUS_FAILURE;
 		}
@@ -385,7 +391,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			mwifiex_util_peek_list(&pra_list->buf_head, true);
 	}
 
-	mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 
 	/* Last AMSDU packet does not need padding */
 	pkt_size -= pad;
@@ -402,10 +408,11 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 					     mbuf_aggr, &tx_param);
 	switch (ret) {
 	case MWIFIEX_STATUS_RESOURCE:
-		mwifiex_spin_lock(priv->wmm.ra_list_spinlock);
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 
 		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
-			mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       flags);
 			mwifiex_write_data_complete(adapter, mbuf_aggr,
 						    MWIFIEX_STATUS_FAILURE);
 			LEAVE();
@@ -424,7 +431,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		pra_list->total_pkts_size += mbuf_aggr->data_len;
 
 		mbuf_aggr->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
-		mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 		PRINTM(MDATA, "MWIFIEX_STATUS_RESOURCE is returned\n");
 		break;
 	case MWIFIEX_STATUS_FAILURE:
@@ -444,7 +451,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		break;
 	}
 	if (ret != MWIFIEX_STATUS_RESOURCE) {
-		mwifiex_spin_lock(priv->wmm.ra_list_spinlock);
+		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 		if (mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			priv->wmm.packets_out[ptrindex]++;
 			priv->wmm.tid_tbl_ptr[ptrindex].ra_list_curr = pra_list;
@@ -452,7 +459,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
 			adapter->bss_prio_tbl[priv->bss_priority]
 			.bss_prio_cur->next;
-		mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 	}
 	do_gettimeofday(&tstamp);
 	PRINTM(MDATA, "%lu.%lu : Data => kernel\n",
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.h b/drivers/net/wireless/mwifiex/11n_aggr.h
index 7f190ad..5b076f2 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.h
+++ b/drivers/net/wireless/mwifiex/11n_aggr.h
@@ -26,6 +26,7 @@ enum mwifiex_status mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 						struct mwifiex_buffer *mbuf);
 int mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			      struct mwifiex_ra_list_tbl *ptr, int headroom,
-			      int ptr_index);
+			      int ptr_index, unsigned long flags)
+			      __releases(&priv->wmm.ra_list_spinlock);
 
 #endif /* !_MWIFIEX_11N_AGGR_H_ */
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 8fdb1fb..9d72135 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -57,6 +57,7 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 	int no_pkt_to_send, i, xchg;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	void *rx_tmp_ptr = NULL;
+	unsigned long flags;
 
 	ENTER();
 
@@ -65,18 +66,18 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 		    rx_reor_tbl_ptr->win_size) : rx_reor_tbl_ptr->win_size;
 
 	for (i = 0; i < no_pkt_to_send; ++i) {
-		mwifiex_spin_lock(priv->rx_pkt_lock);
+		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
 		rx_tmp_ptr = NULL;
 		if (rx_reor_tbl_ptr->rx_reorder_ptr[i]) {
 			rx_tmp_ptr = rx_reor_tbl_ptr->rx_reorder_ptr[i];
 			rx_reor_tbl_ptr->rx_reorder_ptr[i] = NULL;
 		}
-		mwifiex_spin_unlock(priv->rx_pkt_lock);
+		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 		if (rx_tmp_ptr)
 			mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
 	}
 
-	mwifiex_spin_lock(priv->rx_pkt_lock);
+	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
 	/*
 	 * We don't have a circular buffer, hence use rotation to simulate
 	 * circular buffer
@@ -89,7 +90,7 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 	}
 
 	rx_reor_tbl_ptr->start_win = start_win;
-	mwifiex_spin_unlock(priv->rx_pkt_lock);
+	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 
 	LEAVE();
 	return ret;
@@ -125,22 +126,23 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 	int i, j, xchg;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	void *rx_tmp_ptr = NULL;
+	unsigned long flags;
 
 	ENTER();
 
 	for (i = 0; i < rx_reor_tbl_ptr->win_size; ++i) {
-		mwifiex_spin_lock(priv->rx_pkt_lock);
+		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
 		if (!rx_reor_tbl_ptr->rx_reorder_ptr[i]) {
-			mwifiex_spin_unlock(priv->rx_pkt_lock);
+			spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 			break;
 		}
 		rx_tmp_ptr = rx_reor_tbl_ptr->rx_reorder_ptr[i];
 		rx_reor_tbl_ptr->rx_reorder_ptr[i] = NULL;
-		mwifiex_spin_unlock(priv->rx_pkt_lock);
+		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 		mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
 	}
 
-	mwifiex_spin_lock(priv->rx_pkt_lock);
+	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
 	/*
 	 * We don't have a circular buffer, hence use rotation to simulate
 	 * circular buffer
@@ -155,7 +157,7 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 	}
 	rx_reor_tbl_ptr->start_win = (rx_reor_tbl_ptr->start_win + i)
 		&(MAX_TID_VALUE - 1);
-	mwifiex_spin_unlock(priv->rx_pkt_lock);
+	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 	LEAVE();
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 873de93..cfdf206 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -227,6 +227,7 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	uint16_t cmd_code;
 	uint16_t cmd_size;
 	struct timeval tstamp;
+	unsigned long flags;
 
 	ENTER();
 
@@ -260,9 +261,9 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 			    (adapter->seq_num, cmd_node->priv->bss_num,
 			     cmd_node->priv->bss_type));
 
-	mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 	adapter->curr_cmd = cmd_node;
-	mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
 	cmd_code = le16_to_cpu(host_cmd->command);
 	cmd_size = le16_to_cpu(host_cmd->size);
@@ -291,9 +292,9 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 							     adapter->
 							     curr_cmd);
 
-		mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd = NULL;
-		mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
 		adapter->dbg.num_cmd_host_to_card_failure++;
 		ret = MWIFIEX_STATUS_FAILURE;
@@ -813,6 +814,7 @@ mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 	struct cmd_ctrl_node *cmd_node = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct host_cmd_ds_command *host_cmd;
+	unsigned long flags;
 
 	ENTER();
 
@@ -830,7 +832,7 @@ mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 		goto done;
 	}
 
-	mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 	/* Check if any command is pending */
 	cmd_node =
 		(struct cmd_ctrl_node *) mwifiex_util_peek_list(&adapter->
@@ -846,14 +848,15 @@ mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 		if (adapter->ps_state != PS_STATE_AWAKE) {
 			PRINTM(MERROR, "Cannot send command in sleep state"
 					", this should not happen\n");
-			mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+			spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock,
+					       flags);
 			goto done;
 		}
 
 		mwifiex_util_unlink_list(&adapter->cmd_pending_q,
 					 (struct mwifiex_linked_list *)
 					 cmd_node, true);
-		mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 		ret = mwifiex_dnld_cmd_to_fw(priv, cmd_node);
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 		/* Any command sent to the firmware when host is in sleep
@@ -871,7 +874,7 @@ mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 		}
 		goto done;
 	} else {
-		mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 	}
 	ret = MWIFIEX_STATUS_SUCCESS;
 done:
@@ -897,6 +900,7 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	uint16_t cmdresp_result;
 	struct mwifiex_ioctl_req *ioctl_buf = NULL;
 	struct timeval tstamp;
+	unsigned long flags;
 
 	ENTER();
 
@@ -939,9 +943,9 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		PRINTM(MERROR, "CMD_RESP: 0x%x been canceled!\n",
 				le16_to_cpu(resp->command));
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
-		mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd = NULL;
-		mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
@@ -982,9 +986,9 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 			ioctl_buf->status_code = MWIFIEX_ERROR_FW_CMDRESP;
 
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
-		mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd = NULL;
-		mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
@@ -1024,9 +1028,9 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		/* Clean up and put current command back to cmd_free_q */
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
 
-		mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd = NULL;
-		mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 	}
 
 done:
@@ -1141,15 +1145,16 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_node = NULL;
 	struct mwifiex_ioctl_req *ioctl_buf = NULL;
+	unsigned long flags;
 
 	/* Cancel current cmd */
 	if ((adapter->curr_cmd) && (adapter->curr_cmd->ioctl_buf)) {
 		ioctl_buf =
 			(struct mwifiex_ioctl_req *) adapter->curr_cmd->
 			ioctl_buf;
-		mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd->ioctl_buf = NULL;
-		mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 		ioctl_buf->status_code = MWIFIEX_ERROR_CMD_CANCEL;
 		mwifiex_ioctl_complete(adapter, ioctl_buf,
 				       MWIFIEX_STATUS_FAILURE);
@@ -1184,9 +1189,9 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 		cmd_node->ioctl_buf = NULL;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 	}
-	mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 	adapter->scan_processing = false;
-	mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 }
 
 /*
@@ -1204,6 +1209,7 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 			     struct mwifiex_ioctl_req *ioctl_req)
 {
 	struct cmd_ctrl_node *cmd_node = NULL;
+	unsigned long flags;
 
 	ENTER();
 
@@ -1213,14 +1219,14 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 
 	if ((adapter->curr_cmd) &&
 	    (adapter->curr_cmd->ioctl_buf == ioctl_req)) {
-		mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		cmd_node = adapter->curr_cmd;
 		cmd_node->ioctl_buf = NULL;
 		cmd_node->cmd_flag |= CMD_F_CANCELED;
-		mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 	}
 
-	mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 	while ((cmd_node =
 		mwifiex_get_pending_ioctl_cmd(adapter, ioctl_req)) != NULL) {
 		mwifiex_util_unlink_list(&adapter->cmd_pending_q,
@@ -1229,7 +1235,7 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 		cmd_node->ioctl_buf = NULL;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 	}
-	mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 	if (ioctl_req->req_id == MWIFIEX_IOCTL_SCAN) {
 		/* Cancel all pending scan command */
 		while ((cmd_node =
@@ -1242,9 +1248,9 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 			cmd_node->ioctl_buf = NULL;
 			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		}
-		mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = false;
-		mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 	}
 	ioctl_req->status_code = MWIFIEX_ERROR_CMD_CANCEL;
 	mwifiex_ioctl_complete(adapter, ioctl_req, MWIFIEX_STATUS_FAILURE);
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 51ce799..b7fdd18 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -391,44 +391,16 @@ enum mwifiex_status wlan_init_lock_list(struct mwifiex_adapter *adapter)
 
 	ENTER();
 
-	if (mwifiex_init_lock(&adapter->mwifiex_lock)
-			!= MWIFIEX_STATUS_SUCCESS) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto error;
-	}
-	if (mwifiex_init_lock(&adapter->int_lock)
-			!= MWIFIEX_STATUS_SUCCESS) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto error;
-	}
-	if (mwifiex_init_lock(&adapter->main_proc_lock)
-			!= MWIFIEX_STATUS_SUCCESS) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto error;
-	}
-	if (mwifiex_init_lock(&adapter->mwifiex_cmd_lock)
-			!= MWIFIEX_STATUS_SUCCESS) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto error;
-	}
+	spin_lock_init(&adapter->mwifiex_lock);
+	spin_lock_init(&adapter->int_lock);
+	spin_lock_init(&adapter->main_proc_lock);
+	spin_lock_init(&adapter->mwifiex_cmd_lock);
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
 			priv = adapter->priv[i];
-			if (mwifiex_init_lock(&priv->rx_pkt_lock)
-					!= MWIFIEX_STATUS_SUCCESS) {
-				ret = MWIFIEX_STATUS_FAILURE;
-				goto error;
-			}
-			if (mwifiex_init_lock(&priv->wmm.ra_list_spinlock)
-					!= MWIFIEX_STATUS_SUCCESS) {
-				ret = MWIFIEX_STATUS_FAILURE;
-				goto error;
-			}
-			if (mwifiex_init_lock(&priv->curr_bcn_buf_lock)
-					!= MWIFIEX_STATUS_SUCCESS) {
-				ret = MWIFIEX_STATUS_FAILURE;
-				goto error;
-			}
+			spin_lock_init(&priv->rx_pkt_lock);
+			spin_lock_init(&priv->wmm.ra_list_spinlock);
+			spin_lock_init(&priv->curr_bcn_buf_lock);
 		}
 	}
 
@@ -458,7 +430,6 @@ enum mwifiex_status wlan_init_lock_list(struct mwifiex_adapter *adapter)
 		}
 	}
 
-error:
 	LEAVE();
 	return ret;
 }
@@ -475,27 +446,6 @@ void wlan_free_lock_list(struct mwifiex_adapter *adapter)
 
 	ENTER();
 
-	if (adapter->mwifiex_lock)
-		mwifiex_free_lock(adapter->mwifiex_lock);
-	if (adapter->int_lock)
-		mwifiex_free_lock(adapter->int_lock);
-	if (adapter->main_proc_lock)
-		mwifiex_free_lock(adapter->main_proc_lock);
-	if (adapter->mwifiex_cmd_lock)
-		mwifiex_free_lock(adapter->mwifiex_cmd_lock);
-
-	for (i = 0; i < adapter->priv_num; i++) {
-		if (adapter->priv[i]) {
-			priv = adapter->priv[i];
-			if (priv->rx_pkt_lock)
-				mwifiex_free_lock(priv->rx_pkt_lock);
-			if (priv->wmm.ra_list_spinlock)
-				mwifiex_free_lock(priv->wmm.ra_list_spinlock);
-			if (priv->curr_bcn_buf_lock)
-				mwifiex_free_lock(priv->curr_bcn_buf_lock);
-		}
-	}
-
 	/* Free lists */
 	mwifiex_util_free_list_head(&adapter->cmd_free_q);
 
@@ -608,6 +558,7 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 	enum mwifiex_status ret = MWIFIEX_STATUS_PENDING;
 	struct mwifiex_private *priv = NULL;
 	s32 i = 0;
+	unsigned long flags;
 
 	ENTER();
 
@@ -635,25 +586,16 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 		}
 	}
 
-	if (mwifiex_spin_lock(adapter->mwifiex_lock)
-	    != MWIFIEX_STATUS_SUCCESS) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto exit_shutdown_fw;
-	}
+	spin_lock_irqsave(&adapter->mwifiex_lock, flags);
 
 	/* Free adapter structure */
 	mwifiex_free_adapter(adapter);
 
-	if (mwifiex_spin_unlock(adapter->mwifiex_lock)
-	    != MWIFIEX_STATUS_SUCCESS) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto exit_shutdown_fw;
-	}
+	spin_unlock_irqrestore(&adapter->mwifiex_lock, flags);
 
 	/* Notify completion */
 	ret = mwifiex_shutdown_fw_complete(adapter);
 
-exit_shutdown_fw:
 	LEAVE();
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 686567e..09319db 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -263,18 +263,19 @@ enum mwifiex_status
 mwifiex_main_process(struct mwifiex_adapter *adapter)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	unsigned long flags;
 
 	ENTER();
 
-	mwifiex_spin_lock(adapter->main_proc_lock);
+	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 
 	/* Check if already processing */
 	if (adapter->mwifiex_processing) {
-		mwifiex_spin_unlock(adapter->main_proc_lock);
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 		goto exit_main_proc;
 	} else {
 		adapter->mwifiex_processing = true;
-		mwifiex_spin_unlock(adapter->main_proc_lock);
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 	}
 process_start:
 	do {
@@ -393,9 +394,9 @@ process_start:
 	if ((adapter->int_status) || IS_CARD_RX_RCVD(adapter))
 		goto process_start;
 
-	mwifiex_spin_lock(adapter->main_proc_lock);
+	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 	adapter->mwifiex_processing = false;
-	mwifiex_spin_unlock(adapter->main_proc_lock);
+	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 
 exit_main_proc:
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING)
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 010a68a..be7156c 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -237,7 +237,8 @@ struct mwifiex_tid_tbl {
 struct mwifiex_wmm_desc {
 	struct mwifiex_tid_tbl tid_tbl_ptr[MAX_NUM_TID];
 	u32 packets_out[MAX_NUM_TID];
-	void *ra_list_spinlock;
+	/* spin lock to protect ra_list */
+	spinlock_t ra_list_spinlock;
 	struct mwifiex_wmm_ac_status ac_status[IEEE80211_MAX_QUEUES];
 	enum mwifiex_wmm_ac_e ac_down_graded_vals[IEEE80211_MAX_QUEUES];
 	u32 drv_pkt_delay_max;
@@ -388,7 +389,8 @@ struct mwifiex_private {
 	struct mwifiex_add_ba_param add_ba_param;
 	u16 rx_seq[MAX_NUM_TID];
 	struct mwifiex_list_head rx_reorder_tbl_ptr;
-	void *rx_pkt_lock;
+	/* spin lock for Rx packets */
+	spinlock_t rx_pkt_lock;
 
 #define MWIFIEX_ASSOC_RSP_BUF_SIZE  500
 	u8 assoc_rsp_buf[MWIFIEX_ASSOC_RSP_BUF_SIZE];
@@ -406,7 +408,8 @@ struct mwifiex_private {
 
 	u8 *curr_bcn_buf;
 	u32 curr_bcn_size;
-	void *curr_bcn_buf_lock;
+	/* spin lock for beacon buffer */
+	spinlock_t curr_bcn_buf_lock;
 	u16 ioctl_wait_q_woken;
 	wait_queue_head_t ioctl_wait_q;
 	u16 cmd_wait_q_woken;
@@ -564,8 +567,10 @@ struct mwifiex_adapter {
 	struct workqueue_struct *workqueue;
 	struct work_struct main_work;
 	struct mwifiex_bss_prio_tbl bss_prio_tbl[MWIFIEX_MAX_BSS_NUM];
-	void *mwifiex_lock;
-	void *main_proc_lock;
+	/* spin lock for init/shutdown */
+	spinlock_t mwifiex_lock;
+	/* spin lock for main process */
+	spinlock_t main_proc_lock;
 	u32 mwifiex_processing;
 	u16 max_tx_buf_size;
 	u16 tx_buf_size;
@@ -575,7 +580,8 @@ struct mwifiex_adapter {
 	u16 radio_on;
 	u16 number_of_antenna;
 	u32 fw_cap_info;
-	void *int_lock;
+	/* spin lock for interrupt handling */
+	spinlock_t int_lock;
 	u8 int_status;
 	u32 event_cause;
 	struct mwifiex_buffer *mwifiex_buffer_event;
@@ -589,7 +595,8 @@ struct mwifiex_adapter {
 	u16 seq_num;
 	struct cmd_ctrl_node *cmd_pool;
 	struct cmd_ctrl_node *curr_cmd;
-	void *mwifiex_cmd_lock;
+	/* spin lock for command */
+	spinlock_t mwifiex_cmd_lock;
 	u32 num_cmd_timeout;
 	u16 last_init_cmd;
 	struct mwifiex_drv_timer *mwifiex_cmd_timer;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index fc63922..23be1de 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2222,6 +2222,7 @@ mwifiex_process_scan_results(struct mwifiex_private *priv)
 	struct mwifiex_adapter *adapter = priv->adapter;
 	s32 j;
 	u32 i;
+	unsigned long flags;
 
 	ENTER();
 
@@ -2235,7 +2236,7 @@ mwifiex_process_scan_results(struct mwifiex_private *priv)
 					      priv->bss_mode);
 
 		if (j >= 0) {
-			mwifiex_spin_lock(priv->curr_bcn_buf_lock);
+			spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
 			priv->curr_bss_params.bss_descriptor.bcn_wpa_ie = NULL;
 			priv->curr_bss_params.bss_descriptor.wpa_offset = 0;
 			priv->curr_bss_params.bss_descriptor.bcn_rsn_ie = NULL;
@@ -2275,7 +2276,8 @@ mwifiex_process_scan_results(struct mwifiex_private *priv)
 			       sizeof(priv->curr_bss_params.bss_descriptor));
 
 			mwifiex_save_curr_bcn(priv);
-			mwifiex_spin_unlock(priv->curr_bcn_buf_lock);
+			spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
+
 		} else {
 			mwifiex_restore_curr_bcn(priv);
 		}
@@ -2536,6 +2538,7 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 	u8 filtered_scan;
 	u8 scan_current_chan_only;
 	u8 max_chan_per_scan;
+	unsigned long flags;
 
 	ENTER();
 
@@ -2592,9 +2595,10 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 			cmd_node = (struct cmd_ctrl_node *)
 				mwifiex_util_dequeue_list(&adapter->
 							  scan_pending_q, true);
-			mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+			spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 			adapter->scan_processing = true;
-			mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+			spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock,
+					       flags);
 			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
 							true);
 		}
@@ -2695,6 +2699,7 @@ mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	struct chan_band_param_set *chan_band;
 	u8 band;
 	u8 is_bgscan_resp;
+	unsigned long flags;
 
 	ENTER();
 
@@ -2917,9 +2922,9 @@ mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	adapter->num_in_scan_table = num_in_table;
 
 	if (!mwifiex_util_peek_list(&adapter->scan_pending_q, true)) {
-		mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = false;
-		mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 		/*
 		 * Process the resulting scan table:
 		 *   - Remove any bad ssids
@@ -3348,12 +3353,13 @@ mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bssdescriptor *curr_bss =
 		&priv->curr_bss_params.bss_descriptor;
+	unsigned long flags;
 
 	if (priv->curr_bcn_buf &&
 	    ((adapter->bcn_buf_end + priv->curr_bcn_size) <
 	     (adapter->bcn_buf + sizeof(adapter->bcn_buf)))) {
 
-		mwifiex_spin_lock(priv->curr_bcn_buf_lock);
+		spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
 
 		/* restore the current beacon buffer */
 		memcpy(adapter->bcn_buf_end, priv->curr_bcn_buf,
@@ -3408,7 +3414,7 @@ mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
 				 curr_bss->overlap_bss_offset);
 		}
 
-		mwifiex_spin_unlock(priv->curr_bcn_buf_lock);
+		spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
 
 		PRINTM(MINFO, "current beacon restored %d\n",
 		       priv->curr_bcn_size);
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index c06e662..d0d9ed7 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -954,6 +954,7 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 	struct sdio_mmc_card *card = adapter->card;
 	struct mwifiex_buffer mbuf;
 	u32 sdio_ireg = 0;
+	unsigned long flags;
 
 	ENTER();
 
@@ -978,9 +979,9 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 		 * Clear the interrupt status register
 		 */
 		PRINTM(MINTR, "sdio_ireg = 0x%x\n", sdio_ireg);
-		mwifiex_spin_lock(adapter->int_lock);
+		spin_lock_irqsave(&adapter->int_lock, flags);
 		adapter->int_status |= sdio_ireg;
-		mwifiex_spin_unlock(adapter->int_lock);
+		spin_unlock_irqrestore(&adapter->int_lock, flags);
 	}
 done:
 	LEAVE();
@@ -1312,13 +1313,14 @@ mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 	u32 len_reg_l, len_reg_u;
 	u32 rx_blocks;
 	u16 rx_len;
+	unsigned long flags;
 
 	ENTER();
 
-	mwifiex_spin_lock(adapter->int_lock);
+	spin_lock_irqsave(&adapter->int_lock, flags);
 	sdio_ireg = adapter->int_status;
 	adapter->int_status = 0;
-	mwifiex_spin_unlock(adapter->int_lock);
+	spin_unlock_irqrestore(&adapter->int_lock, flags);
 
 	if (!sdio_ireg)
 		goto done;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index d5b8ef0..c1b646e 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -47,6 +47,7 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 {
 	struct cmd_ctrl_node *cmd_node = NULL;
 	struct mwifiex_adapter *adapter = priv->adapter;
+	unsigned long flags;
 
 	ENTER();
 
@@ -86,9 +87,9 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 			cmd_node->ioctl_buf = NULL;
 			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		}
-		mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = false;
-		mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 		mwifiex_recv_event(priv, MWIFIEX_EVENT_ID_DRV_SCAN_REPORT,
 				   NULL);
 		break;
@@ -104,9 +105,9 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 	 */
 	mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
 
-	mwifiex_spin_lock(adapter->mwifiex_cmd_lock);
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 	adapter->curr_cmd = NULL;
-	mwifiex_spin_unlock(adapter->mwifiex_cmd_lock);
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
 	LEAVE();
 	return;
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index a05f2d8..25a3205 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -181,6 +181,7 @@ mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct mwifiex_private *priv;
 	struct mwifiex_buffer *mbuf_parent;
+	unsigned long flags;
 
 	ENTER();
 
@@ -189,15 +190,15 @@ mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
 	if (mbuf->parent) {
 		mbuf_parent = mbuf->parent;
 
-		mwifiex_spin_lock(priv->rx_pkt_lock);
+		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
 		--mbuf_parent->use_count;
 		if (!mbuf_parent->use_count) {
-			mwifiex_spin_unlock(priv->rx_pkt_lock);
+			spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 			mwifiex_recv_complete(adapter,
 					      mbuf_parent, adapter->ioport,
 					      status);
 		} else {
-			mwifiex_spin_unlock(priv->rx_pkt_lock);
+			spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 		}
 
 		mwifiex_free_buffer(mbuf);
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 73fe3c4..9af28b3 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -63,73 +63,6 @@ mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function initializes a spin lock.
- */
-enum mwifiex_status
-mwifiex_init_lock(void **lock)
-{
-	struct mwifiex_lock *mlock = NULL;
-
-	mlock = kmalloc(sizeof(struct mwifiex_lock), GFP_KERNEL);
-	if (!mlock)
-		return MWIFIEX_STATUS_FAILURE;
-
-	spin_lock_init(&mlock->lock);
-	*lock = (void *) mlock;
-
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
- * This function frees a spin lock.
- */
-enum mwifiex_status
-mwifiex_free_lock(void *lock)
-{
-	struct mwifiex_lock *mlock = lock;
-
-	kfree(mlock);
-
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
- * This function requests a spin lock.
- */
-inline enum mwifiex_status
-mwifiex_spin_lock(void *lock)
-{
-	struct mwifiex_lock *mlock = lock;
-	unsigned long flags = 0;
-
-	if (mlock) {
-		spin_lock_irqsave(&mlock->lock, flags);
-		mlock->flags = flags;
-		return MWIFIEX_STATUS_SUCCESS;
-	} else {
-		return MWIFIEX_STATUS_FAILURE;
-	}
-}
-EXPORT_SYMBOL_GPL(mwifiex_spin_lock);
-
-/*
- * This function requests a spin unlock.
- */
-inline enum mwifiex_status
-mwifiex_spin_unlock(void *lock)
-{
-	struct mwifiex_lock *mlock = (struct mwifiex_lock *) lock;
-
-	if (mlock) {
-		spin_unlock_irqrestore(&mlock->lock, mlock->flags);
-		return MWIFIEX_STATUS_SUCCESS;
-	} else {
-		return MWIFIEX_STATUS_FAILURE;
-	}
-}
-EXPORT_SYMBOL_GPL(mwifiex_spin_unlock);
-
-/*
  * This function peeks into a list.
  *
  * A pointer to the next node in the list is returned, but the node
@@ -139,15 +72,17 @@ struct mwifiex_linked_list *
 mwifiex_util_peek_list(struct mwifiex_list_head *head, u8 lock_required)
 {
 	struct mwifiex_linked_list *node = NULL;
+	unsigned long flags;
 
-	if (lock_required)
-		mwifiex_spin_lock(head->lock);
-
-	if (head->next != (struct mwifiex_linked_list *) head)
-		node = head->next;
-
-	if (lock_required)
-		mwifiex_spin_unlock(head->lock);
+	if (lock_required) {
+		spin_lock_irqsave(&head->lock, flags);
+		if (head->next != (struct mwifiex_linked_list *) head)
+			node = head->next;
+		spin_unlock_irqrestore(&head->lock, flags);
+	} else {
+		if (head->next != (struct mwifiex_linked_list *) head)
+			node = head->next;
+	}
 
 	return node;
 }
@@ -161,11 +96,8 @@ inline void
 mwifiex_util_init_list_head(struct mwifiex_list_head *head, u8 lock_required)
 {
 	mwifiex_util_init_list((struct mwifiex_linked_list *) head);
-
 	if (lock_required)
-		mwifiex_init_lock(&head->lock);
-	else
-		head->lock = NULL;
+		spin_lock_init(&head->lock);
 }
 
 /*
@@ -177,9 +109,10 @@ mwifiex_util_enqueue_list_tail(struct mwifiex_list_head *head,
 			       u8 lock_required)
 {
 	struct mwifiex_linked_list *old_last;
+	unsigned long flags = 0;
 
 	if (lock_required)
-		mwifiex_spin_lock(head->lock);
+		spin_lock_irqsave(&head->lock, flags);
 
 	old_last = head->prev;
 	node->prev = old_last;
@@ -189,7 +122,7 @@ mwifiex_util_enqueue_list_tail(struct mwifiex_list_head *head,
 	head->prev = old_last->next;
 
 	if (lock_required)
-		mwifiex_spin_unlock(head->lock);
+		spin_unlock_irqrestore(&head->lock, flags);
 }
 
 /*
@@ -201,9 +134,10 @@ mwifiex_util_enqueue_list_head(struct mwifiex_list_head *head,
 			       u8 lock_required)
 {
 	struct mwifiex_linked_list *old_first;
+	unsigned long flags = 0;
 
 	if (lock_required)
-		mwifiex_spin_lock(head->lock);
+		spin_lock_irqsave(&head->lock, flags);
 
 	old_first = head->next;
 	node->prev = (struct mwifiex_linked_list *) head;
@@ -213,7 +147,7 @@ mwifiex_util_enqueue_list_head(struct mwifiex_list_head *head,
 	head->next = old_first->prev;
 
 	if (lock_required)
-		mwifiex_spin_unlock(head->lock);
+		spin_unlock_irqrestore(&head->lock, flags);
 }
 
 /*
@@ -228,9 +162,10 @@ mwifiex_util_unlink_list(struct mwifiex_list_head *head,
 {
 	struct mwifiex_linked_list *my_prev;
 	struct mwifiex_linked_list *my_next;
+	unsigned long flags = 0;
 
 	if (lock_required)
-		mwifiex_spin_lock(head->lock);
+		spin_lock_irqsave(&head->lock, flags);
 
 	my_prev = node->prev;
 	my_next = node->next;
@@ -241,7 +176,7 @@ mwifiex_util_unlink_list(struct mwifiex_list_head *head,
 	node->next = node->prev;
 
 	if (lock_required)
-		mwifiex_spin_unlock(head->lock);
+		spin_unlock_irqrestore(&head->lock, flags);
 }
 
 /*
@@ -251,9 +186,10 @@ inline struct mwifiex_linked_list *
 mwifiex_util_dequeue_list(struct mwifiex_list_head *head, u8 lock_required)
 {
 	struct mwifiex_linked_list *node;
+	unsigned long flags = 0;
 
 	if (lock_required)
-		mwifiex_spin_lock(head->lock);
+		spin_lock_irqsave(&head->lock, flags);
 
 	node = head->next;
 	if (node != (struct mwifiex_linked_list *) head)
@@ -262,7 +198,7 @@ mwifiex_util_dequeue_list(struct mwifiex_list_head *head, u8 lock_required)
 		node = NULL;
 
 	if (lock_required)
-		mwifiex_spin_unlock(head->lock);
+		spin_unlock_irqrestore(&head->lock, flags);
 
 	return node;
 }
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index aaae399..9996398 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -103,12 +103,6 @@ do {                \
 	mwifiex_print(MHEX_DUMP | MINFO, x, y, z); \
 } while (0)
 
-
-struct mwifiex_lock {
-	spinlock_t lock;	/* lock for mutual exclusion access */
-	unsigned long flags;
-};
-
 struct mwifiex_linked_list {
 	struct mwifiex_linked_list *prev;
 	struct mwifiex_linked_list *next;
@@ -117,13 +111,10 @@ struct mwifiex_linked_list {
 struct mwifiex_list_head {
 	struct mwifiex_linked_list *prev;
 	struct mwifiex_linked_list *next;
-	void *lock;
+	/* spin lock used for linked list operations */
+	spinlock_t lock;
 };
 
-enum mwifiex_status mwifiex_init_lock(void **lock);
-enum mwifiex_status mwifiex_free_lock(void *lock);
-enum mwifiex_status mwifiex_spin_lock(void *lock);
-enum mwifiex_status mwifiex_spin_unlock(void *lock);
 void mwifiex_util_init_list_head(struct mwifiex_list_head *head,
 				u8 lock_required);
 void mwifiex_util_enqueue_list_tail(struct mwifiex_list_head *head,
@@ -157,9 +148,6 @@ mwifiex_util_free_list_head(struct mwifiex_list_head *head)
 {
 	head->next = NULL;
 	head->prev = head->next;
-
-	if (head->lock)
-		mwifiex_free_lock(head->lock);
 }
 
 struct mwifiex_drv_timer {
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 3993845..4cdaaa4 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -147,10 +147,12 @@ done:
 void
 mwifiex_clean_txrx(struct mwifiex_private *priv)
 {
+	unsigned long flags;
+
 	ENTER();
 
 	mwifiex_11n_cleanup_reorder_tbl(priv);
-	mwifiex_spin_lock(priv->wmm.ra_list_spinlock);
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 
 	mwifiex_wmm_cleanup_queues(priv);
 	mwifiex_11n_delete_all_tx_ba_stream_tbl(priv);
@@ -161,7 +163,7 @@ mwifiex_clean_txrx(struct mwifiex_private *priv)
 	mwifiex_wmm_delete_all_ralist(priv);
 	memcpy(tos_to_tid, ac_to_tid, sizeof(tos_to_tid));
 
-	mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 
 	LEAVE();
 }
@@ -666,7 +668,7 @@ mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
 		}
 
 		mwifiex_util_init_list((struct mwifiex_linked_list *)
-				       &priv->wmm.tid_tbl_ptr[i].ra_list);
+					&priv->wmm.tid_tbl_ptr[i].ra_list);
 		priv->wmm.tid_tbl_ptr[i].ra_list_curr = NULL;
 	}
 
@@ -773,6 +775,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 	u32 tid;
 	struct mwifiex_ra_list_tbl *ra_list;
 	u8 ra[MWIFIEX_MAC_ADDR_LENGTH], tid_down;
+	unsigned long flags;
 
 	ENTER();
 
@@ -788,7 +791,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 
 	tid = mbuf->priority;
 
-	mwifiex_spin_lock(priv->wmm.ra_list_spinlock);
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 
 	tid_down = mwifiex_wmm_downgrade_tid(priv, tid);
 
@@ -807,7 +810,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 	}
 
 	if (!ra_list) {
-		mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 		mwifiex_send_packet_complete(adapter, mbuf,
 					     MWIFIEX_STATUS_FAILURE);
 		LEAVE();
@@ -821,7 +824,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 
 	ra_list->total_pkts_size += mbuf->data_len;
 
-	mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 
 	LEAVE();
 }
@@ -1150,7 +1153,9 @@ mwifiex_num_pkts_in_txq(struct mwifiex_private *priv,
  */
 static void
 mwifiex_send_single_packet(struct mwifiex_private *priv,
-			   struct mwifiex_ra_list_tbl *ptr, int ptr_index)
+			   struct mwifiex_ra_list_tbl *ptr, int ptr_index,
+			   unsigned long flags)
+			   __releases(&priv->wmm.ra_list_spinlock)
 {
 	struct mwifiex_buffer *mbuf;
 	struct mwifiex_buffer *mbuf_next;
@@ -1170,7 +1175,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 			(struct mwifiex_buffer *) mwifiex_util_peek_list(&ptr->
 								buf_head,
 								false);
-		mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 
 		tx_param.next_pkt_len =
 			((mbuf_next) ? mbuf_next->data_len +
@@ -1181,10 +1186,12 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 			/** Queue the packet back at the head */
 			PRINTM(MDAT_D, "Queuing pkt back to raList %p %p\n",
 			       ptr, mbuf);
-			mwifiex_spin_lock(priv->wmm.ra_list_spinlock);
+			spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 
 			if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-				mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+				spin_unlock_irqrestore(
+						&priv->wmm.ra_list_spinlock,
+						flags);
 				mwifiex_write_data_complete(adapter, mbuf,
 						MWIFIEX_STATUS_FAILURE);
 				LEAVE();
@@ -1196,9 +1203,10 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 
 			ptr->total_pkts_size += mbuf->data_len;
 			mbuf->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
-			mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       flags);
 		} else {
-			mwifiex_spin_lock(priv->wmm.ra_list_spinlock);
+			spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 			if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
 				priv->wmm.packets_out[ptr_index]++;
 				priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr =
@@ -1207,10 +1215,11 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 			adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
 				adapter->bss_prio_tbl[priv->bss_priority].
 				bss_prio_cur->next;
-			mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       flags);
 		}
 	} else {
-		mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 		PRINTM(MDATA, "Nothing to send\n");
 	}
 
@@ -1241,7 +1250,9 @@ mwifiex_is_ptr_processed(struct mwifiex_private *priv,
  */
 static void
 mwifiex_send_processed_packet(struct mwifiex_private *priv,
-			      struct mwifiex_ra_list_tbl *ptr, int ptr_index)
+			      struct mwifiex_ra_list_tbl *ptr, int ptr_index,
+			      unsigned long flags)
+				__releases(&priv->wmm.ra_list_spinlock)
 {
 	struct mwifiex_buffer *mbuf_next;
 	struct mwifiex_tx_param tx_param;
@@ -1258,7 +1269,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 			(struct mwifiex_buffer *) mwifiex_util_peek_list(&ptr->
 								buf_head,
 								false);
-		mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 		tx_param.next_pkt_len =
 			((mbuf_next) ? mbuf_next->data_len +
 			 sizeof(struct txpd) : 0);
@@ -1268,10 +1279,12 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 		switch (ret) {
 		case MWIFIEX_STATUS_RESOURCE:
 			PRINTM(MDATA, "MWIFIEX_STATUS_RESOURCE is returned\n");
-			mwifiex_spin_lock(priv->wmm.ra_list_spinlock);
+			spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 
 			if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-				mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+				spin_unlock_irqrestore(
+						&priv->wmm.ra_list_spinlock,
+						flags);
 				mwifiex_write_data_complete(adapter, mbuf,
 						MWIFIEX_STATUS_FAILURE);
 				LEAVE();
@@ -1282,7 +1295,8 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 						mbuf, true);
 
 			mbuf->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
-			mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       flags);
 			break;
 		case MWIFIEX_STATUS_FAILURE:
 			adapter->data_sent = false;
@@ -1297,7 +1311,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 			break;
 		}
 		if (ret != MWIFIEX_STATUS_RESOURCE) {
-			mwifiex_spin_lock(priv->wmm.ra_list_spinlock);
+			spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 			if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
 				priv->wmm.packets_out[ptr_index]++;
 				priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr =
@@ -1306,10 +1320,11 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 			adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
 				adapter->bss_prio_tbl[priv->bss_priority].
 				bss_prio_cur->next;
-			mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       flags);
 		}
 	} else {
-		mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 	}
 
 	LEAVE();
@@ -1327,6 +1342,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 	int ptr_index = 0;
 	u8 ra[MWIFIEX_MAC_ADDR_LENGTH];
 	int tid_del = 0, tid = 0;
+	unsigned long flags;
 
 	ENTER();
 
@@ -1341,15 +1357,15 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 
 	PRINTM(MDATA, "tid=%d\n", tid);
 
-	mwifiex_spin_lock(priv->wmm.ra_list_spinlock);
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 	if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-		mwifiex_spin_unlock(priv->wmm.ra_list_spinlock);
+		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 		LEAVE();
 		return MWIFIEX_STATUS_FAILURE;
 	}
 
 	if (mwifiex_is_ptr_processed(priv, ptr)) {
-		mwifiex_send_processed_packet(priv, ptr, ptr_index);
+		mwifiex_send_processed_packet(priv, ptr, ptr_index, flags);
 		/* ra_list_spinlock has been freed in
 		   mwifiex_send_processed_packet() */
 		LEAVE();
@@ -1361,7 +1377,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		((priv->sec_info.wpa_enabled
 		  || priv->sec_info.wpa2_enabled) && !priv->wpa_is_gtk_set))
 		) {
-		mwifiex_send_single_packet(priv, ptr, ptr_index);
+		mwifiex_send_single_packet(priv, ptr, ptr_index, flags);
 		/* ra_list_spinlock has been freed in
 		   mwifiex_send_single_packet() */
 	} else {
@@ -1388,11 +1404,11 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 					     adapter->tx_buf_size) >=
 		     MIN_NUM_AMSDU)) {
 			mwifiex_11n_aggregate_pkt(priv, ptr, INTF_HEADER_LEN,
-						  ptr_index);
+						  ptr_index, flags);
 			/* ra_list_spinlock has been freed in
 			   mwifiex_11n_aggregate_pkt() */
 		} else {
-			mwifiex_send_single_packet(priv, ptr, ptr_index);
+			mwifiex_send_single_packet(priv, ptr, ptr_index, flags);
 			/* ra_list_spinlock has been freed in
 			   mwifiex_send_single_packet() */
 		}
-- 
1.7.0.2

