Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:45257 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756439Ab2CMCfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:35:53 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 06/15] mwifiex: rename fuctions and variables for better readability
Date: Mon, 12 Mar 2012 19:35:13 -0700
Message-Id: <1331606116-32745-7-git-send-email-bzhao@marvell.com> (sfid-20120313_033557_442440_D9314384)
In-Reply-To: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
References: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Renaming the long fuctions and variable names from 11n_rxreoder.c
file to shorter ones for better readability.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |  160 ++++++++++++--------------
 1 files changed, 73 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 491cd85..06f5d36 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -27,31 +27,31 @@
 #include "11n_rxreorder.h"
 
 /*
- * This function dispatches all packets in the Rx reorder table.
+ * This function dispatches all packets in the Rx reorder table until the
+ * start window.
  *
  * There could be holes in the buffer, which are skipped by the function.
  * Since the buffer is linear, the function uses rotation to simulate
  * circular buffer.
  */
 static void
-mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
-					 struct mwifiex_rx_reorder_tbl
-					 *rx_reor_tbl_ptr, int start_win)
+mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv,
+			 struct mwifiex_rx_reorder_tbl *tbl, int start_win)
 {
-	int no_pkt_to_send, i;
+	int pkt_to_send, i;
 	void *rx_tmp_ptr;
 	unsigned long flags;
 
-	no_pkt_to_send = (start_win > rx_reor_tbl_ptr->start_win) ?
-		min((start_win - rx_reor_tbl_ptr->start_win),
-		    rx_reor_tbl_ptr->win_size) : rx_reor_tbl_ptr->win_size;
+	pkt_to_send = (start_win > tbl->start_win) ?
+		      min((start_win - tbl->start_win), tbl->win_size) :
+		      tbl->win_size;
 
-	for (i = 0; i < no_pkt_to_send; ++i) {
+	for (i = 0; i < pkt_to_send; ++i) {
 		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
 		rx_tmp_ptr = NULL;
-		if (rx_reor_tbl_ptr->rx_reorder_ptr[i]) {
-			rx_tmp_ptr = rx_reor_tbl_ptr->rx_reorder_ptr[i];
-			rx_reor_tbl_ptr->rx_reorder_ptr[i] = NULL;
+		if (tbl->rx_reorder_ptr[i]) {
+			rx_tmp_ptr = tbl->rx_reorder_ptr[i];
+			tbl->rx_reorder_ptr[i] = NULL;
 		}
 		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 		if (rx_tmp_ptr)
@@ -63,13 +63,12 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 	 * We don't have a circular buffer, hence use rotation to simulate
 	 * circular buffer
 	 */
-	for (i = 0; i < rx_reor_tbl_ptr->win_size - no_pkt_to_send; ++i) {
-		rx_reor_tbl_ptr->rx_reorder_ptr[i] =
-			rx_reor_tbl_ptr->rx_reorder_ptr[no_pkt_to_send + i];
-		rx_reor_tbl_ptr->rx_reorder_ptr[no_pkt_to_send + i] = NULL;
+	for (i = 0; i < tbl->win_size - pkt_to_send; ++i) {
+		tbl->rx_reorder_ptr[i] = tbl->rx_reorder_ptr[pkt_to_send + i];
+		tbl->rx_reorder_ptr[pkt_to_send + i] = NULL;
 	}
 
-	rx_reor_tbl_ptr->start_win = start_win;
+	tbl->start_win = start_win;
 	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 }
 
@@ -83,20 +82,20 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
  */
 static void
 mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
-			      struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr)
+			      struct mwifiex_rx_reorder_tbl *tbl)
 {
 	int i, j, xchg;
 	void *rx_tmp_ptr;
 	unsigned long flags;
 
-	for (i = 0; i < rx_reor_tbl_ptr->win_size; ++i) {
+	for (i = 0; i < tbl->win_size; ++i) {
 		spin_lock_irqsave(&priv->rx_pkt_lock, flags);
-		if (!rx_reor_tbl_ptr->rx_reorder_ptr[i]) {
+		if (!tbl->rx_reorder_ptr[i]) {
 			spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 			break;
 		}
-		rx_tmp_ptr = rx_reor_tbl_ptr->rx_reorder_ptr[i];
-		rx_reor_tbl_ptr->rx_reorder_ptr[i] = NULL;
+		rx_tmp_ptr = tbl->rx_reorder_ptr[i];
+		tbl->rx_reorder_ptr[i] = NULL;
 		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 		mwifiex_process_rx_packet(priv->adapter, rx_tmp_ptr);
 	}
@@ -107,15 +106,13 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 	 * circular buffer
 	 */
 	if (i > 0) {
-		xchg = rx_reor_tbl_ptr->win_size - i;
+		xchg = tbl->win_size - i;
 		for (j = 0; j < xchg; ++j) {
-			rx_reor_tbl_ptr->rx_reorder_ptr[j] =
-				rx_reor_tbl_ptr->rx_reorder_ptr[i + j];
-			rx_reor_tbl_ptr->rx_reorder_ptr[i + j] = NULL;
+			tbl->rx_reorder_ptr[j] = tbl->rx_reorder_ptr[i + j];
+			tbl->rx_reorder_ptr[i + j] = NULL;
 		}
 	}
-	rx_reor_tbl_ptr->start_win = (rx_reor_tbl_ptr->start_win + i)
-		&(MAX_TID_VALUE - 1);
+	tbl->start_win = (tbl->start_win + i) & (MAX_TID_VALUE - 1);
 	spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 }
 
@@ -126,28 +123,25 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
  * pending packets in the Rx reorder table before deletion.
  */
 static void
-mwifiex_11n_delete_rx_reorder_tbl_entry(struct mwifiex_private *priv,
-				       struct mwifiex_rx_reorder_tbl
-				       *rx_reor_tbl_ptr)
+mwifiex_del_rx_reorder_entry(struct mwifiex_private *priv,
+			     struct mwifiex_rx_reorder_tbl *tbl)
 {
 	unsigned long flags;
 
-	if (!rx_reor_tbl_ptr)
+	if (!tbl)
 		return;
 
-	mwifiex_11n_dispatch_pkt_until_start_win(priv, rx_reor_tbl_ptr,
-						 (rx_reor_tbl_ptr->start_win +
-						  rx_reor_tbl_ptr->win_size)
-						 &(MAX_TID_VALUE - 1));
+	mwifiex_11n_dispatch_pkt(priv, tbl, (tbl->start_win + tbl->win_size) &
+					    (MAX_TID_VALUE - 1));
 
-	del_timer(&rx_reor_tbl_ptr->timer_context.timer);
+	del_timer(&tbl->timer_context.timer);
 
 	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
-	list_del(&rx_reor_tbl_ptr->list);
+	list_del(&tbl->list);
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
 
-	kfree(rx_reor_tbl_ptr->rx_reorder_ptr);
-	kfree(rx_reor_tbl_ptr);
+	kfree(tbl->rx_reorder_ptr);
+	kfree(tbl);
 }
 
 /*
@@ -157,16 +151,15 @@ mwifiex_11n_delete_rx_reorder_tbl_entry(struct mwifiex_private *priv,
 static struct mwifiex_rx_reorder_tbl *
 mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta)
 {
-	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
+	struct mwifiex_rx_reorder_tbl *tbl;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
-	list_for_each_entry(rx_reor_tbl_ptr, &priv->rx_reorder_tbl_ptr, list) {
-		if ((!memcmp(rx_reor_tbl_ptr->ta, ta, ETH_ALEN))
-		    && (rx_reor_tbl_ptr->tid == tid)) {
+	list_for_each_entry(tbl, &priv->rx_reorder_tbl_ptr, list) {
+		if (!memcmp(tbl->ta, ta, ETH_ALEN) && tbl->tid == tid) {
 			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
 					       flags);
-			return rx_reor_tbl_ptr;
+			return tbl;
 		}
 	}
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
@@ -200,22 +193,19 @@ mwifiex_11n_find_last_seq_num(struct mwifiex_rx_reorder_tbl *rx_reorder_tbl_ptr)
 static void
 mwifiex_flush_data(unsigned long context)
 {
-	struct reorder_tmr_cnxt *reorder_cnxt =
+	struct reorder_tmr_cnxt *ctx =
 		(struct reorder_tmr_cnxt *) context;
 	int start_win;
 
-	start_win = mwifiex_11n_find_last_seq_num(reorder_cnxt->ptr);
+	start_win = mwifiex_11n_find_last_seq_num(ctx->ptr);
 
 	if (start_win < 0)
 		return;
 
-	dev_dbg(reorder_cnxt->priv->adapter->dev, "info: flush data %d\n",
-		start_win);
-		mwifiex_11n_dispatch_pkt_until_start_win(reorder_cnxt->priv,
-				reorder_cnxt->ptr,
-						 ((reorder_cnxt->ptr->start_win
-						   + start_win + 1) &
-						  (MAX_TID_VALUE - 1)));
+	dev_dbg(ctx->priv->adapter->dev, "info: flush data %d\n", start_win);
+	mwifiex_11n_dispatch_pkt(ctx->priv, ctx->ptr,
+				 (ctx->ptr->start_win + start_win + 1) &
+				 (MAX_TID_VALUE - 1));
 }
 
 /*
@@ -233,7 +223,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 				 int tid, int win_size, int seq_num)
 {
 	int i;
-	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr, *new_node;
+	struct mwifiex_rx_reorder_tbl *tbl, *new_node;
 	u16 last_seq = 0;
 	unsigned long flags;
 
@@ -241,13 +231,12 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	 * If we get a TID, ta pair which is already present dispatch all the
 	 * the packets and move the window size until the ssn
 	 */
-	rx_reor_tbl_ptr = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
-	if (rx_reor_tbl_ptr) {
-		mwifiex_11n_dispatch_pkt_until_start_win(priv, rx_reor_tbl_ptr,
-							 seq_num);
+	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
+	if (tbl) {
+		mwifiex_11n_dispatch_pkt(priv, tbl, seq_num);
 		return;
 	}
-	/* if !rx_reor_tbl_ptr then create one */
+	/* if !tbl then create one */
 	new_node = kzalloc(sizeof(struct mwifiex_rx_reorder_tbl), GFP_KERNEL);
 	if (!new_node) {
 		dev_err(priv->adapter->dev, "%s: failed to alloc new_node\n",
@@ -404,24 +393,23 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 				u16 seq_num, u16 tid,
 				u8 *ta, u8 pkt_type, void *payload)
 {
-	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
+	struct mwifiex_rx_reorder_tbl *tbl;
 	int start_win, end_win, win_size;
 	u16 pkt_index;
 
-	rx_reor_tbl_ptr =
-		mwifiex_11n_get_rx_reorder_tbl((struct mwifiex_private *) priv,
-						tid, ta);
-	if (!rx_reor_tbl_ptr) {
+	tbl = mwifiex_11n_get_rx_reorder_tbl((struct mwifiex_private *) priv,
+					     tid, ta);
+	if (!tbl) {
 		if (pkt_type != PKT_TYPE_BAR)
 			mwifiex_process_rx_packet(priv->adapter, payload);
 		return 0;
 	}
-	start_win = rx_reor_tbl_ptr->start_win;
-	win_size = rx_reor_tbl_ptr->win_size;
+	start_win = tbl->start_win;
+	win_size = tbl->win_size;
 	end_win = ((start_win + win_size) - 1) & (MAX_TID_VALUE - 1);
-	del_timer(&rx_reor_tbl_ptr->timer_context.timer);
-	mod_timer(&rx_reor_tbl_ptr->timer_context.timer, jiffies
-			+ (MIN_FLUSH_TIMER_MS * win_size * HZ) / 1000);
+	del_timer(&tbl->timer_context.timer);
+	mod_timer(&tbl->timer_context.timer,
+		  jiffies + (MIN_FLUSH_TIMER_MS * win_size * HZ) / 1000);
 
 	/*
 	 * If seq_num is less then starting win then ignore and drop the
@@ -452,8 +440,7 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 			start_win = (end_win - win_size) + 1;
 		else
 			start_win = (MAX_TID_VALUE - (win_size - seq_num)) + 1;
-		mwifiex_11n_dispatch_pkt_until_start_win(priv,
-						rx_reor_tbl_ptr, start_win);
+		mwifiex_11n_dispatch_pkt(priv, tbl, start_win);
 	}
 
 	if (pkt_type != PKT_TYPE_BAR) {
@@ -462,17 +449,17 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		else
 			pkt_index = (seq_num+MAX_TID_VALUE) - start_win;
 
-		if (rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index])
+		if (tbl->rx_reorder_ptr[pkt_index])
 			return -1;
 
-		rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index] = payload;
+		tbl->rx_reorder_ptr[pkt_index] = payload;
 	}
 
 	/*
 	 * Dispatch all packets sequentially from start_win until a
 	 * hole is found and adjust the start_win appropriately
 	 */
-	mwifiex_11n_scan_and_dispatch(priv, rx_reor_tbl_ptr);
+	mwifiex_11n_scan_and_dispatch(priv, tbl);
 
 	return 0;
 }
@@ -486,7 +473,7 @@ void
 mwifiex_del_ba_tbl(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 		   u8 type, int initiator)
 {
-	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
+	struct mwifiex_rx_reorder_tbl *tbl;
 	struct mwifiex_tx_ba_stream_tbl *ptx_tbl;
 	u8 cleanup_rx_reorder_tbl;
 	unsigned long flags;
@@ -500,14 +487,14 @@ mwifiex_del_ba_tbl(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 	       "initiator=%d\n", peer_mac, tid, initiator);
 
 	if (cleanup_rx_reorder_tbl) {
-		rx_reor_tbl_ptr = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
+		tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
 								 peer_mac);
-		if (!rx_reor_tbl_ptr) {
+		if (!tbl) {
 			dev_dbg(priv->adapter->dev,
 					"event: TID, TA not found in table\n");
 			return;
 		}
-		mwifiex_11n_delete_rx_reorder_tbl_entry(priv, rx_reor_tbl_ptr);
+		mwifiex_del_rx_reorder_entry(priv, tbl);
 	} else {
 		ptx_tbl = mwifiex_get_ba_tbl(priv, tid, peer_mac);
 		if (!ptx_tbl) {
@@ -535,7 +522,7 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 		(struct host_cmd_ds_11n_addba_rsp *)
 		&resp->params.add_ba_rsp;
 	int tid, win_size;
-	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
+	struct mwifiex_rx_reorder_tbl *tbl;
 	uint16_t block_ack_param_set;
 
 	block_ack_param_set = le16_to_cpu(add_ba_rsp->block_ack_param_set);
@@ -557,13 +544,12 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 		       tid, add_ba_rsp->ssn, win_size);
 	} else {
 		dev_err(priv->adapter->dev, "ADDBA RSP: failed %pM tid=%d)\n",
-					add_ba_rsp->peer_mac_addr, tid);
+				add_ba_rsp->peer_mac_addr, tid);
 
-		rx_reor_tbl_ptr = mwifiex_11n_get_rx_reorder_tbl(priv,
-					tid, add_ba_rsp->peer_mac_addr);
-		if (rx_reor_tbl_ptr)
-			mwifiex_11n_delete_rx_reorder_tbl_entry(priv,
-				rx_reor_tbl_ptr);
+		tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
+						     add_ba_rsp->peer_mac_addr);
+		if (tbl)
+			mwifiex_del_rx_reorder_entry(priv, tbl);
 	}
 
 	return 0;
@@ -602,7 +588,7 @@ void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv)
 	list_for_each_entry_safe(del_tbl_ptr, tmp_node,
 				 &priv->rx_reorder_tbl_ptr, list) {
 		spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
-		mwifiex_11n_delete_rx_reorder_tbl_entry(priv, del_tbl_ptr);
+		mwifiex_del_rx_reorder_entry(priv, del_tbl_ptr);
 		spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
 	}
 	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
-- 
1.7.0.2

