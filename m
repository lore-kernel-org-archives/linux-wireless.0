Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:35594 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab1CHASj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 19:18:39 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: code cleanup: save some extra lines
Date: Mon,  7 Mar 2011 16:21:36 -0800
Message-Id: <1299543697-15152-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1299543697-15152-1-git-send-email-bzhao@marvell.com>
References: <1299543697-15152-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

using code rearrangment.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |   79 +++-----
 drivers/net/wireless/mwifiex/11n.h           |    3 +-
 drivers/net/wireless/mwifiex/11n_aggr.c      |   10 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   56 +++----
 drivers/net/wireless/mwifiex/cfg80211.c      |   29 +--
 drivers/net/wireless/mwifiex/cfp.c           |   21 +--
 drivers/net/wireless/mwifiex/cmdevt.c        |   73 +++-----
 drivers/net/wireless/mwifiex/debugfs.c       |   38 ++---
 drivers/net/wireless/mwifiex/init.c          |   11 +-
 drivers/net/wireless/mwifiex/join.c          |   81 +++-----
 drivers/net/wireless/mwifiex/main.c          |   11 +-
 drivers/net/wireless/mwifiex/scan.c          |  259 +++++++++-----------------
 drivers/net/wireless/mwifiex/sdio.c          |   43 ++---
 drivers/net/wireless/mwifiex/sta_cmd.c       |  200 ++++++++-------------
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   33 +---
 drivers/net/wireless/mwifiex/sta_event.c     |    5 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   78 +++-----
 drivers/net/wireless/mwifiex/sta_rx.c        |   11 +-
 drivers/net/wireless/mwifiex/sta_tx.c        |    6 +-
 drivers/net/wireless/mwifiex/txrx.c          |   10 +-
 drivers/net/wireless/mwifiex/util.c          |   12 +-
 drivers/net/wireless/mwifiex/wmm.c           |   73 +++-----
 drivers/net/wireless/mwifiex/wmm.h           |    3 +-
 23 files changed, 413 insertions(+), 732 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 9076ef8..bbfce33 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -114,17 +114,13 @@ int mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
 
 	if (action == HostCmd_ACT_GEN_GET) {
 		addba_param->timeout = priv->add_ba_param.timeout;
-		addba_param->tx_win_size =
-			priv->add_ba_param.tx_win_size;
-		addba_param->rx_win_size =
-			priv->add_ba_param.rx_win_size;
+		addba_param->tx_win_size = priv->add_ba_param.tx_win_size;
+		addba_param->rx_win_size = priv->add_ba_param.rx_win_size;
 	} else {
 		timeout = priv->add_ba_param.timeout;
 		priv->add_ba_param.timeout = addba_param->timeout;
-		priv->add_ba_param.tx_win_size =
-			addba_param->tx_win_size;
-		priv->add_ba_param.rx_win_size =
-			addba_param->rx_win_size;
+		priv->add_ba_param.tx_win_size = addba_param->tx_win_size;
+		priv->add_ba_param.rx_win_size = addba_param->rx_win_size;
 		if (timeout != priv->add_ba_param.timeout)
 			mwifiex_11n_update_addba_request(priv);
 
@@ -455,8 +451,7 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 	tid = del_ba_param_set >> DELBA_TID_POS;
 	if (del_ba->del_result == BA_RESULT_SUCCESS) {
 		mwifiex_11n_delete_ba_stream_tbl(priv, tid,
-				del_ba->peer_mac_addr,
-				TYPE_DELBA_SENT,
+				del_ba->peer_mac_addr, TYPE_DELBA_SENT,
 				INITIATOR_BIT(del_ba_param_set));
 
 		tx_ba_tbl = mwifiex_11n_get_tx_ba_stream_status(priv,
@@ -470,18 +465,15 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 		  */
 		if (INITIATOR_BIT(del_ba_param_set)) {
 			mwifiex_11n_create_tx_ba_stream_tbl(priv,
-					del_ba->
-					peer_mac_addr, tid,
+					del_ba->peer_mac_addr, tid,
 					BA_STREAM_SETUP_INPROGRESS);
 
 			tx_ba_tbl = mwifiex_11n_get_tx_ba_stream_status(priv,
 					BA_STREAM_SETUP_INPROGRESS);
 			if (tx_ba_tbl)
 				mwifiex_11n_delete_ba_stream_tbl(priv,
-						tx_ba_tbl->tid,
-						tx_ba_tbl->ra,
-						TYPE_DELBA_SENT,
-						true);
+						tx_ba_tbl->tid, tx_ba_tbl->ra,
+						TYPE_DELBA_SENT, true);
 		}
 	}
 
@@ -511,8 +503,7 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 		& IEEE80211_ADDBA_PARAM_TID_MASK)
 		>> BLOCKACKPARAM_TID_POS;
 	if (le16_to_cpu(add_ba_rsp->status_code) == BA_RESULT_SUCCESS) {
-		tx_ba_tbl = mwifiex_11n_get_tx_ba_stream_tbl(priv,
-						tid,
+		tx_ba_tbl = mwifiex_11n_get_tx_ba_stream_tbl(priv, tid,
 						add_ba_rsp->peer_mac_addr);
 		if (tx_ba_tbl) {
 			dev_dbg(priv->adapter->dev, "info: BA stream complete\n");
@@ -846,9 +837,8 @@ mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
  * This function checks if the given pointer is valid entry of
  * Tx BA Stream table.
  */
-static int
-mwifiex_is_tx_ba_stream_ptr_valid(struct mwifiex_private *priv,
-			       struct mwifiex_tx_ba_stream_tbl *tx_tbl_ptr)
+static int mwifiex_is_tx_ba_stream_ptr_valid(struct mwifiex_private *priv,
+				struct mwifiex_tx_ba_stream_tbl *tx_tbl_ptr)
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
 
@@ -866,9 +856,8 @@ mwifiex_is_tx_ba_stream_ptr_valid(struct mwifiex_private *priv,
  * The function also performs a validity check on the supplied
  * pointer before trying to delete.
  */
-void
-mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
-		struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl)
+void mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
+				struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl)
 {
 	if (!tx_ba_tsr_tbl &&
 			mwifiex_is_tx_ba_stream_ptr_valid(priv, tx_ba_tsr_tbl))
@@ -886,8 +875,7 @@ mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 /*
  * This function deletes all the entries in Tx BA Stream table.
  */
-void
-mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv)
+void mwifiex_11n_delete_all_tx_ba_stream_tbl(struct mwifiex_private *priv)
 {
 	int i;
 	struct mwifiex_tx_ba_stream_tbl *del_tbl_ptr, *tmp_node;
@@ -935,7 +923,7 @@ mwifiex_11n_get_tx_ba_stream_status(struct mwifiex_private *priv,
  */
 struct mwifiex_tx_ba_stream_tbl *
 mwifiex_11n_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
-		int tid, u8 *ra)
+				 int tid, u8 *ra)
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
 	unsigned long flags;
@@ -957,17 +945,16 @@ mwifiex_11n_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
  * This function creates an entry in Tx BA stream table for the
  * given RA/TID pair.
  */
-void
-mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
-				  u8 *ra, int tid,
-				  enum mwifiex_ba_status ba_status)
+void mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
+					 u8 *ra, int tid,
+					 enum mwifiex_ba_status ba_status)
 {
 	struct mwifiex_tx_ba_stream_tbl *new_node;
 	unsigned long flags;
 
 	if (!mwifiex_11n_get_tx_ba_stream_tbl(priv, tid, ra)) {
 		new_node = kzalloc(sizeof(struct mwifiex_tx_ba_stream_tbl),
-					GFP_ATOMIC);
+				   GFP_ATOMIC);
 		if (!new_node) {
 			dev_err(priv->adapter->dev,
 				"%s: failed to alloc new_node\n", __func__);
@@ -991,8 +978,7 @@ mwifiex_11n_create_tx_ba_stream_tbl(struct mwifiex_private *priv,
 /*
  * This function sends an add BA request to the given TID/RA pair.
  */
-int
-mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
+int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 {
 	struct host_cmd_ds_11n_addba_req add_ba_req;
 	static u8 dialog_tok;
@@ -1025,9 +1011,8 @@ mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 /*
  * This function sends a delete BA request to the given TID/RA pair.
  */
-int
-mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
-		   int initiator)
+int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
+		       int initiator)
 {
 	struct host_cmd_ds_11n_delba delba;
 	int ret;
@@ -1054,8 +1039,7 @@ mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 /*
  * This function handles the command response of a delete BA request.
  */
-void
-mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba)
+void mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba)
 {
 	struct host_cmd_ds_11n_delba *cmd_del_ba =
 		(struct host_cmd_ds_11n_delba *) del_ba;
@@ -1065,16 +1049,15 @@ mwifiex_11n_delete_ba_stream(struct mwifiex_private *priv, u8 *del_ba)
 	tid = del_ba_param_set >> DELBA_TID_POS;
 
 	mwifiex_11n_delete_ba_stream_tbl(priv, tid, cmd_del_ba->peer_mac_addr,
-			TYPE_DELBA_RECEIVE,
-			INITIATOR_BIT(del_ba_param_set));
+					 TYPE_DELBA_RECEIVE,
+					 INITIATOR_BIT(del_ba_param_set));
 }
 
 /*
  * This function resends add BA requests to all peers in
  * the Tx BA stream table.
  */
-void
-mwifiex_11n_update_addba_request(struct mwifiex_private *priv)
+void mwifiex_11n_update_addba_request(struct mwifiex_private *priv)
 {
 
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
@@ -1096,9 +1079,8 @@ mwifiex_11n_update_addba_request(struct mwifiex_private *priv)
 /*
  * This function retrieves the Rx reordering table.
  */
-int
-mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
-			  struct mwifiex_ds_rx_reorder_tbl *buf)
+int mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
+			       struct mwifiex_ds_rx_reorder_tbl *buf)
 {
 	int i;
 	struct mwifiex_ds_rx_reorder_tbl *rx_reo_tbl = buf;
@@ -1134,9 +1116,8 @@ mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
 /*
  * This function retrieves the Tx BA stream table.
  */
-int
-mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
-			   struct mwifiex_ds_tx_ba_stream_tbl *buf)
+int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
+				 struct mwifiex_ds_tx_ba_stream_tbl *buf)
 {
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tsr_tbl;
 	struct mwifiex_ds_tx_ba_stream_tbl *rx_reo_tbl = buf;
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 0bd8bb9..68a5549 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -25,8 +25,7 @@
 #include "wmm.h"
 
 void mwifiex_show_dot_11n_dev_cap(struct mwifiex_adapter *adapter, u32 cap);
-void mwifiex_show_dev_mcs_support(struct mwifiex_adapter *adapter,
-				u8 support);
+void mwifiex_show_dev_mcs_support(struct mwifiex_adapter *adapter, u8 support);
 int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 			  struct host_cmd_ds_command *resp);
 int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 340cc8e..7e7e8c1 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -152,10 +152,8 @@ mwifiex_11n_get_num_aggr_pkts(u8 *data, int total_pkt_len)
 
 	while (total_pkt_len > 0) {
 		/* Length will be in network format, change it to host */
-		pkt_len = ntohs((*(__be16 *)
-					(data
-					 +
-					 (2 * MWIFIEX_MAC_ADDR_LENGTH))));
+		pkt_len = ntohs((*(__be16 *)(data +
+				(2 * MWIFIEX_MAC_ADDR_LENGTH))));
 		pad = (((pkt_len + sizeof(struct ethhdr)) & 3)) ?
 			(4 - ((pkt_len + sizeof(struct ethhdr)) & 3)) : 0;
 		data += pkt_len + pad + sizeof(struct ethhdr);
@@ -192,8 +190,8 @@ int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 	struct rx_packet_hdr *rx_pkt_hdr;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u8 rfc1042_eth_hdr[MWIFIEX_MAC_ADDR_LENGTH] = { 0xaa, 0xaa, 0x03,
-		0x00, 0x00, 0x00
-	};
+							0x00, 0x00, 0x00
+							};
 
 	data = (u8 *) (local_rx_pd + local_rx_pd->rx_pkt_offset);
 	total_pkt_len = local_rx_pd->rx_pkt_length;
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index f2ee1d6..63f5205 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -36,8 +36,7 @@ static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
-	ret = mwifiex_process_rx_packet(adapter,
-					(struct sk_buff *) payload);
+	ret = mwifiex_process_rx_packet(adapter, (struct sk_buff *) payload);
 	return ret;
 }
 
@@ -278,8 +277,8 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		if (mwifiex_queuing_ra_based(priv))
 			/* TODO for adhoc */
 			dev_dbg(priv->adapter->dev,
-					"info: ADHOC:last_seq=%d start_win=%d\n",
-					last_seq, new_node->start_win);
+				"info: ADHOC:last_seq=%d start_win=%d\n",
+				last_seq, new_node->start_win);
 		else
 			last_seq = priv->rx_seq[tid];
 
@@ -301,8 +300,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 		new_node->timer_context.priv = priv;
 
 		init_timer(&new_node->timer_context.timer);
-		new_node->timer_context.timer.function =
-				mwifiex_flush_data;
+		new_node->timer_context.timer.function = mwifiex_flush_data;
 		new_node->timer_context.timer.data =
 				(unsigned long) &new_node->timer_context;
 
@@ -333,9 +331,8 @@ int mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
 		&cmd->params.add_ba_req;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_11N_ADDBA_REQ);
-	cmd->size =
-		cpu_to_le16(sizeof(struct host_cmd_ds_11n_addba_req) +
-			    S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_11n_addba_req) +
+				S_DS_GEN);
 
 	memcpy(add_ba_req, data_buf,
 	       sizeof(struct host_cmd_ds_11n_addba_req));
@@ -365,9 +362,8 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 	uint16_t block_ack_param_set;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_11N_ADDBA_RSP);
-	cmd->size =
-		cpu_to_le16(sizeof(struct host_cmd_ds_11n_addba_rsp) +
-			    S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_11n_addba_rsp) +
+				S_DS_GEN);
 
 	memcpy(add_ba_rsp->peer_mac_addr, cmd_addba_req->peer_mac_addr,
 	       MWIFIEX_MAC_ADDR_LENGTH);
@@ -469,8 +465,7 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		 */
 		if ((start_win + TWOPOW11) > (MAX_TID_VALUE - 1)) {/* Wrap */
 			if (seq_num >= ((start_win + (TWOPOW11)) &
-					(MAX_TID_VALUE - 1))
-			    && (seq_num < start_win))
+			    (MAX_TID_VALUE - 1)) && (seq_num < start_win))
 				return -1;
 		} else if ((seq_num < start_win) ||
 			   (seq_num > (start_win + (TWOPOW11)))) {
@@ -482,26 +477,21 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 		 * WinStart = seq_num
 		 */
 		if (pkt_type == PKT_TYPE_BAR)
-			seq_num =
-				((seq_num + win_size) - 1) & (MAX_TID_VALUE -
-							      1);
-
-		if (((end_win < start_win) && (seq_num < (TWOPOW11 -
-							  (MAX_TID_VALUE -
-							   start_win)))
-		     && (seq_num > end_win))
-		    || ((end_win > start_win) &&
+			seq_num = ((seq_num + win_size) - 1) &
+				   (MAX_TID_VALUE - 1);
+
+		if (((end_win < start_win)
+		     && (seq_num < (TWOPOW11 - (MAX_TID_VALUE - start_win)))
+		     && (seq_num > end_win)) || ((end_win > start_win) &&
 			((seq_num > end_win) || (seq_num < start_win)))) {
 			end_win = seq_num;
 			if (((seq_num - win_size) + 1) >= 0)
 				start_win = (end_win - win_size) + 1;
 			else
-				start_win =
-					(MAX_TID_VALUE - (win_size - seq_num)) +
-					1;
+				start_win = (MAX_TID_VALUE -
+					     (win_size - seq_num)) + 1;
 			ret = mwifiex_11n_dispatch_pkt_until_start_win(priv,
-					rx_reor_tbl_ptr,
-					start_win);
+						rx_reor_tbl_ptr, start_win);
 
 			if (ret)
 				return ret;
@@ -553,7 +543,7 @@ mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int tid,
 
 	if (cleanup_rx_reorder_tbl) {
 		rx_reor_tbl_ptr = mwifiex_11n_get_rx_reorder_tbl(priv, tid,
-							peer_mac);
+								 peer_mac);
 		if (!rx_reor_tbl_ptr) {
 			dev_dbg(priv->adapter->dev,
 					"event: TID, TA not found in table\n");
@@ -625,9 +615,8 @@ int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
  * This function handles BA stream timeout event by preparing and sending
  * a command to the firmware.
  */
-void
-mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
-			      struct host_cmd_ds_11n_batimeout *event)
+void mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
+				   struct host_cmd_ds_11n_batimeout *event)
 {
 	struct host_cmd_ds_11n_delba delba;
 
@@ -649,8 +638,7 @@ mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
  * This function cleans up the Rx reorder table by deleting all the entries
  * and re-initializing.
  */
-void
-mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv)
+void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv)
 {
 	struct mwifiex_rx_reorder_tbl *del_tbl_ptr, *tmp_node;
 	unsigned long flags;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 049eb59..e6ba12b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -335,9 +335,8 @@ static int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 
 	domain_info->no_of_triplet = no_of_triplet;
 	/* Send cmd to FW to set domain info */
-	ret = mwifiex_prepare_cmd(priv,
-			HostCmd_CMD_802_11D_DOMAIN_INFO,
-			HostCmd_ACT_GEN_SET, 0, NULL, NULL);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
+				  HostCmd_ACT_GEN_SET, 0, NULL, NULL);
 	if (ret)
 		wiphy_err(wiphy, "11D: setting domain info in FW\n");
 
@@ -454,8 +453,7 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
  * This function can only be used when station is not connected.
  */
 static int
-mwifiex_cfg80211_set_channel(struct wiphy *wiphy,
-			     struct net_device *dev,
+mwifiex_cfg80211_set_channel(struct wiphy *wiphy, struct net_device *dev,
 			     struct ieee80211_channel *chan,
 			     enum nl80211_channel_type channel_type)
 {
@@ -671,8 +669,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
  * requested station information, if available.
  */
 static int
-mwifiex_cfg80211_get_station(struct wiphy *wiphy,
-			     struct net_device *dev,
+mwifiex_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 			     u8 *mac, struct station_info *sinfo)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
@@ -898,7 +895,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
  *      - RSN IE
  */
 static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
-		struct mwifiex_802_11_ssid *ssid)
+					       struct mwifiex_802_11_ssid *ssid)
 {
 	struct mwifiex_scan_resp scan_resp;
 	struct mwifiex_bssdescriptor *scan_table;
@@ -1105,9 +1102,8 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 			ret = mwifiex_set_gen_ie(priv, sme->ie, sme->ie_len);
 
 		if (sme->key) {
-			alg_is_wep =
-				mwifiex_is_alg_wep(pairwise_encrypt_mode) |
-				mwifiex_is_alg_wep(group_encrypt_mode);
+			alg_is_wep = mwifiex_is_alg_wep(pairwise_encrypt_mode) |
+				     mwifiex_is_alg_wep(group_encrypt_mode);
 			if (alg_is_wep) {
 				dev_dbg(priv->adapter->dev,
 					"info: setting wep encryption"
@@ -1148,8 +1144,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 			return -EFAULT;
 		/* Inform the BSS information to kernel, otherwise
 		 * kernel will give a panic after successful assoc */
-		if (mwifiex_inform_bss_from_scan_result(priv,
-					&req_ssid))
+		if (mwifiex_inform_bss_from_scan_result(priv, &req_ssid))
 			return -EFAULT;
 	}
 
@@ -1376,9 +1371,8 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
  * default parameters and handler function pointers, and finally
  * registers the device.
  */
-int
-mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
-				struct mwifiex_private *priv)
+int mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
+			      struct mwifiex_private *priv)
 {
 	int ret = 0;
 	void *wdev_priv = NULL;
@@ -1446,8 +1440,7 @@ mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 
 	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
 	dev->watchdog_timeo = MWIFIEX_DEFAULT_WATCHDOG_TIMEOUT;
-	dev->hard_header_len +=
-		MWIFIEX_MIN_DATA_HEADER_LEN;
+	dev->hard_header_len += MWIFIEX_MIN_DATA_HEADER_LEN;
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index 017b0b9..5093764 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -76,9 +76,8 @@ u8 supported_rates_n[N_SUPPORTED_RATES] = { 0x02, 0x04, 0 };
  * This function maps an index in supported rates table into
  * the corresponding data rate.
  */
-u32
-mwifiex_index_to_data_rate(struct mwifiex_adapter *adapter, u8 index,
-			   u8 ht_info)
+u32 mwifiex_index_to_data_rate(struct mwifiex_adapter *adapter, u8 index,
+			       u8 ht_info)
 {
 	u16 mcs_rate[4][8] = {
 		{0x1b, 0x36, 0x51, 0x6c, 0xa2, 0xd8, 0xf3, 0x10e}
@@ -128,8 +127,7 @@ mwifiex_index_to_data_rate(struct mwifiex_adapter *adapter, u8 index,
  * This function maps a data rate value into corresponding index in supported
  * rates table.
  */
-u8
-mwifiex_data_rate_to_index(struct mwifiex_adapter *adapter, u32 rate)
+u8 mwifiex_data_rate_to_index(struct mwifiex_adapter *adapter, u32 rate)
 {
 	u16 *ptr;
 
@@ -147,8 +145,7 @@ mwifiex_data_rate_to_index(struct mwifiex_adapter *adapter, u32 rate)
  *
  * The result may vary depending upon connection status.
  */
-u32
-mwifiex_get_active_data_rates(struct mwifiex_private *priv, u8 *rates)
+u32 mwifiex_get_active_data_rates(struct mwifiex_private *priv, u8 *rates)
 {
 	u32 k;
 
@@ -168,9 +165,7 @@ mwifiex_get_active_data_rates(struct mwifiex_private *priv, u8 *rates)
  */
 struct mwifiex_chan_freq_power *
 mwifiex_get_cfp_by_band_and_channel_from_cfg80211(struct mwifiex_private
-			*priv,
-			u8 band,
-			u16 channel)
+						  *priv, u8 band, u16 channel)
 {
 	struct mwifiex_chan_freq_power *cfp = NULL;
 	struct ieee80211_supported_band *sband;
@@ -213,7 +208,7 @@ mwifiex_get_cfp_by_band_and_channel_from_cfg80211(struct mwifiex_private
  */
 struct mwifiex_chan_freq_power *
 mwifiex_get_cfp_by_band_and_freq_from_cfg80211(struct mwifiex_private *priv,
-							u8 band, u32 freq)
+					       u8 band, u32 freq)
 {
 	struct mwifiex_chan_freq_power *cfp = NULL;
 	struct ieee80211_supported_band *sband;
@@ -290,12 +285,10 @@ mwifiex_get_rate_index(struct mwifiex_adapter *adapter, u16 *rate_bitmap,
  * The function works in both Ad-Hoc and infra mode by printing the
  * band and returning the data rates.
  */
-u32
-mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
+u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 {
 	u32 k = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
-
 	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
 		/* Infra. mode */
 		switch (adapter->config_bands) {
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 6a5da48..90d6617 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -181,8 +181,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 
 	/* Set command sequence number */
 	adapter->seq_num++;
-	host_cmd->seq_num =
-		cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
+	host_cmd->seq_num = cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
 			    (adapter->seq_num, cmd_node->priv->bss_num,
 			     cmd_node->priv->bss_type));
 
@@ -332,8 +331,7 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 
 	/* Allocate and initialize command buffers */
 	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++) {
-		cmd_array[i].skb =
-			dev_alloc_skb(MWIFIEX_SIZE_OF_CMD_BUFFER);
+		cmd_array[i].skb = dev_alloc_skb(MWIFIEX_SIZE_OF_CMD_BUFFER);
 		if (!cmd_array[i].skb) {
 			dev_err(adapter->dev, "ALLOC_CMD_BUF: out of memory\n");
 			return -1;
@@ -453,10 +451,9 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
  *      - Fill up the non-default parameters and buffer pointers
  *      - Add the command to pending queue
  */
-int mwifiex_prepare_cmd(struct mwifiex_private *priv,
-			uint16_t cmd_no,
-			u16 cmd_action,
-			u32 cmd_oid, void *wait_queue, void *data_buf)
+int mwifiex_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
+			u16 cmd_action, u32 cmd_oid,
+			void *wait_queue, void *data_buf)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -503,8 +500,7 @@ int mwifiex_prepare_cmd(struct mwifiex_private *priv,
 
 	skb_put(cmd_node->cmd_skb, sizeof(struct host_cmd_ds_command));
 
-	cmd_ptr =
-		(struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
+	cmd_ptr = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 	cmd_ptr->command = cpu_to_le16(cmd_no);
 	cmd_ptr->result = 0;
 
@@ -653,15 +649,13 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
 			       cmd_pending_q_flags);
 
-	host_cmd = (struct host_cmd_ds_command *)
-				(cmd_node->cmd_skb->data);
+	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
 	priv = cmd_node->priv;
 
 	if (adapter->ps_state != PS_STATE_AWAKE) {
 		dev_err(adapter->dev, "%s: cannot send cmd in sleep state,"
 				" this should not happen\n", __func__);
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock,
-				       cmd_flags);
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 		return ret;
 	}
 
@@ -677,8 +671,7 @@ int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 	 * mode should de-configure host sleep. We should skip the
 	 * host sleep configuration command itself though
 	 */
-	if (priv &&
-	    (host_cmd->command !=
+	if (priv && (host_cmd->command !=
 	     cpu_to_le16(HostCmd_CMD_802_11_HS_CFG_ENH))) {
 		if (adapter->hs_activated) {
 			adapter->is_hs_configured = false;
@@ -724,8 +717,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	adapter->num_cmd_timeout = 0;
 
-	resp = (struct host_cmd_ds_command *)
-					adapter->curr_cmd->resp_skb->data;
+	resp = (struct host_cmd_ds_command *) adapter->curr_cmd->resp_skb->data;
 	if (adapter->curr_cmd->cmd_flag & CMD_F_CANCELED) {
 		dev_err(adapter->dev, "CMD_RESP: %#x been canceled\n",
 				le16_to_cpu(resp->command));
@@ -854,11 +846,9 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 
 	if (cmd_node) {
 		adapter->dbg.timeout_cmd_id =
-			adapter->dbg.last_cmd_id[adapter->dbg.
-						   last_cmd_index];
+			adapter->dbg.last_cmd_id[adapter->dbg.last_cmd_index];
 		adapter->dbg.timeout_cmd_act =
-			adapter->dbg.last_cmd_act[adapter->dbg.
-						    last_cmd_index];
+			adapter->dbg.last_cmd_act[adapter->dbg.last_cmd_index];
 		do_gettimeofday(&tstamp);
 		dev_err(adapter->dev, "%s: Timeout cmd id (%lu.%lu) = %#x,"
 			" act = %#x\n", __func__,
@@ -1018,14 +1008,12 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 				 &adapter->scan_pending_q, list) {
 		if (cmd_node->wq_buf == wait_queue) {
 			list_del(&cmd_node->list);
-			spin_unlock_irqrestore(
-					&adapter->scan_pending_q_lock,
-					scan_pending_q_flags);
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       scan_pending_q_flags);
 			cmd_node->wq_buf = NULL;
 			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-			spin_lock_irqsave(
-					&adapter->scan_pending_q_lock,
-					scan_pending_q_flags);
+			spin_lock_irqsave(&adapter->scan_pending_q_lock,
+					  scan_pending_q_flags);
 			cancel_scan_cmd = true;
 		}
 	}
@@ -1158,9 +1146,8 @@ mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
 	adapter->if_ops.wakeup(adapter);
 	adapter->hs_activated = false;
 	adapter->is_hs_configured = false;
-	mwifiex_hs_activated_event(mwifiex_get_priv
-					   (adapter, MWIFIEX_BSS_ROLE_ANY),
-					   false);
+	mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
+				   MWIFIEX_BSS_ROLE_ANY), false);
 	return;
 }
 
@@ -1186,9 +1173,8 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 	}
 
 	/* Get BSS number and corresponding priv */
-	priv = mwifiex_get_priv_by_id(adapter,
-					HostCmd_GET_BSS_NO(seq_num),
-					HostCmd_GET_BSS_TYPE(seq_num));
+	priv = mwifiex_get_priv_by_id(adapter, HostCmd_GET_BSS_NO(seq_num),
+				      HostCmd_GET_BSS_TYPE(seq_num));
 	if (!priv)
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
@@ -1199,8 +1185,7 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 
 	if (command != HostCmd_CMD_802_11_PS_MODE_ENH) {
 		dev_err(adapter->dev, "%s: received unexpected response for"
-				" cmd %x, result = %x\n", __func__,
-				command, result);
+			" cmd %x, result = %x\n", __func__, command, result);
 		return;
 	}
 
@@ -1213,10 +1198,8 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 	}
 	adapter->pm_wakeup_card_req = true;
 	if (adapter->is_hs_configured)
-		mwifiex_hs_activated_event(mwifiex_get_priv
-						   (adapter,
-						    MWIFIEX_BSS_ROLE_ANY),
-						   true);
+		mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
+					   MWIFIEX_BSS_ROLE_ANY), true);
 	adapter->ps_state = PS_STATE_SLEEP;
 	cmd->command = cpu_to_le16(command);
 	cmd->seq_num = cpu_to_le16(seq_num);
@@ -1308,9 +1291,8 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 				sizeof(struct mwifiex_ie_types_auto_ds_param);
 			tlv += sizeof(struct mwifiex_ie_types_auto_ds_param);
 			if (data_buf)
-				idletime =
-					((struct mwifiex_ds_auto_ds *)
-					 data_buf)->idle_time;
+				idletime = ((struct mwifiex_ds_auto_ds *)
+					     data_buf)->idle_time;
 			dev_dbg(priv->adapter->dev,
 					"cmd: PS Command: Enter Auto Deep Sleep\n");
 			auto_ds->deep_sleep_timeout = cpu_to_le16(idletime);
@@ -1375,9 +1357,8 @@ int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 
 		if (data_buf) {
 			/* This section is for get power save mode */
-			struct mwifiex_ds_pm_cfg *pm_cfg = (struct
-							    mwifiex_ds_pm_cfg
-							    *)data_buf;
+			struct mwifiex_ds_pm_cfg *pm_cfg =
+					(struct mwifiex_ds_pm_cfg *)data_buf;
 			if (ps_bitmap & BITMAP_STA_PS)
 				pm_cfg->param.ps_mode = 1;
 			else
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 9a53364..6207f6b 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -453,10 +453,9 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 		for (i = 0; i < info.tx_tbl_num; i++)
 			p += sprintf(p, "tid = %d, "
 				     "ra = %02x:%02x:%02x:%02x:%02x:%02x\n",
-				     info.tx_tbl[i].tid,
-				     info.tx_tbl[i].ra[0], info.tx_tbl[i].ra[1],
-				     info.tx_tbl[i].ra[2], info.tx_tbl[i].ra[3],
-				     info.tx_tbl[i].ra[4],
+				     info.tx_tbl[i].tid, info.tx_tbl[i].ra[0],
+				     info.tx_tbl[i].ra[1], info.tx_tbl[i].ra[2],
+				     info.tx_tbl[i].ra[3], info.tx_tbl[i].ra[4],
 				     info.tx_tbl[i].ra[5]);
 	}
 
@@ -500,9 +499,8 @@ free_and_exit:
  * This function can be used to set the Tx aggregation parameters.
  */
 static ssize_t
-mwifiex_txaggrprio_write(struct file *file,
-			    const char __user *ubuf, size_t count,
-			    loff_t *ppos)
+mwifiex_txaggrprio_write(struct file *file, const char __user *ubuf,
+			 size_t count, loff_t *ppos)
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
@@ -602,9 +600,8 @@ done:
  * This function can be used to set the AMSDU aggregation control parameters.
  */
 static ssize_t
-mwifiex_amsduaggrctrl_write(struct file *file,
-			  const char __user *ubuf, size_t count,
-			  loff_t *ppos)
+mwifiex_amsduaggrctrl_write(struct file *file, const char __user *ubuf,
+			    size_t count, loff_t *ppos)
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
@@ -1175,9 +1172,8 @@ mwifiex_atimwindow_read(struct file *file, char __user *ubuf,
  * This function can be used to set the Tx rate configuration.
  */
 static ssize_t
-mwifiex_txratecfg_write(struct file *file,
-			const char __user *ubuf, size_t count,
-			loff_t *ppos)
+mwifiex_txratecfg_write(struct file *file, const char __user *ubuf,
+			size_t count, loff_t *ppos)
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
@@ -1246,9 +1242,8 @@ mwifiex_txratecfg_read(struct file *file, char __user *ubuf,
  * This function can be used to set the add BA parameters.
  */
 static ssize_t
-mwifiex_addbapara_write(struct file *file,
-			const char __user *ubuf, size_t count,
-			loff_t *ppos)
+mwifiex_addbapara_write(struct file *file, const char __user *ubuf,
+			size_t count, loff_t *ppos)
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
@@ -1479,9 +1474,8 @@ mwifiex_htcapinfo_read(struct file *file, char __user *ubuf,
  * This function can be used to set the add BA reject parameters.
  */
 static ssize_t
-mwifiex_addbareject_write(struct file *file,
-			  const char __user *ubuf, size_t count,
-			  loff_t *ppos)
+mwifiex_addbareject_write(struct file *file, const char __user *ubuf,
+			  size_t count, loff_t *ppos)
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
@@ -1838,9 +1832,8 @@ done:
  * This function can be used to set the Tx buffer size.
  */
 static ssize_t
-mwifiex_txbufcfg_write(struct file *file,
-			     const char __user *ubuf, size_t count,
-			     loff_t *ppos)
+mwifiex_txbufcfg_write(struct file *file, const char __user *ubuf,
+		       size_t count, loff_t *ppos)
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
@@ -1948,7 +1941,6 @@ mwifiex_passphrase_write(struct file *file,
 		ret = -EINVAL;
 		goto done;
 	}
-
 	while (begin) {
 		end = mwifiex_strsep(&begin, ';', '/');
 		opt = mwifiex_strsep(&end, '=', '/');
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index e505714..915d01c 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -92,9 +92,8 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 		memset(&priv->wep_key[i], 0, sizeof(struct mwifiex_wep_key));
 	priv->wep_key_curr_index = 0;
 	priv->ewpa_query = false;
-	priv->curr_pkt_filter =
-		HostCmd_ACT_MAC_RX_ON | HostCmd_ACT_MAC_TX_ON |
-		HostCmd_ACT_MAC_ETHERNETII_ENABLE;
+	priv->curr_pkt_filter = HostCmd_ACT_MAC_RX_ON | HostCmd_ACT_MAC_TX_ON |
+				HostCmd_ACT_MAC_ETHERNETII_ENABLE;
 
 	priv->beacon_period = 100; /* beacon interval */ ;
 	priv->attempted_bss_desc = NULL;
@@ -211,8 +210,7 @@ mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	struct mwifiex_opt_sleep_confirm_buffer *sleep_cfm_buf = NULL;
 
 	skb_put(adapter->sleep_cfm, sizeof(sleep_cfm_buf->ps_cfm_sleep));
-	sleep_cfm_buf =
-		(struct mwifiex_opt_sleep_confirm_buffer *)
+	sleep_cfm_buf = (struct mwifiex_opt_sleep_confirm_buffer *)
 						(adapter->sleep_cfm->data);
 
 	adapter->cmd_sent = false;
@@ -489,8 +487,7 @@ int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 	}
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
-			ret = mwifiex_sta_init_cmd(adapter->priv[i],
-						   first_sta);
+			ret = mwifiex_sta_init_cmd(adapter->priv[i], first_sta);
 			if (ret == -1)
 				return -1;
 
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 3317099..9b34fcb 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -137,8 +137,7 @@ mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *priv, u8 **buffer,
  * NOTE: Setting the MSB of the basic rates needs to be taken
  * care of, either before or after calling this function.
  */
-static int mwifiex_get_common_rates(struct mwifiex_private *priv,
-				    u8 *rate1,
+static int mwifiex_get_common_rates(struct mwifiex_private *priv, u8 *rate1,
 				    u32 rate1_size, u8 *rate2, u32 rate2_size)
 {
 	int ret = 0;
@@ -208,9 +207,8 @@ mwifiex_setup_rates_from_bssdesc(struct mwifiex_private *priv,
 	/* Get the STA supported rates */
 	card_rates_size = mwifiex_get_active_data_rates(priv, card_rates);
 	/* Get the common rates between AP and STA supported rates */
-	if (mwifiex_get_common_rates
-	    (priv, out_rates, MWIFIEX_SUPPORTED_RATES, card_rates,
-	     card_rates_size)) {
+	if (mwifiex_get_common_rates(priv, out_rates, MWIFIEX_SUPPORTED_RATES,
+				     card_rates, card_rates_size)) {
 		*out_rates_size = 0;
 		dev_err(priv->adapter->dev, "%s: cannot get common rates\n",
 						__func__);
@@ -518,9 +516,8 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 		auth_tlv->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
 		auth_tlv->header.len = cpu_to_le16(sizeof(auth_tlv->auth_type));
 		if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
-			auth_tlv->auth_type =
-				cpu_to_le16((u16) priv->sec_info.
-					    authentication_mode);
+			auth_tlv->auth_type = cpu_to_le16((u16) priv->sec_info.
+							  authentication_mode);
 		else
 			auth_tlv->auth_type =
 				cpu_to_le16(MWIFIEX_AUTH_MODE_OPEN);
@@ -804,8 +801,7 @@ done:
 				wait_queue->status =
 					le16_to_cpu(assoc_rsp->status_code);
 			else
-				wait_queue->status =
-					MWIFIEX_ERROR_ASSOC_FAIL;
+				wait_queue->status = MWIFIEX_ERROR_ASSOC_FAIL;
 		} else {
 			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
 		}
@@ -855,9 +851,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		0x00, 0x00, 0x50, 0xf2, 0x00, 0x01, 0x00, 0x00,
 		0x50, 0xf2, 0x00
 	};
-	u8 *pos =
-		(u8 *) adhoc_start +
-		sizeof(struct host_cmd_ds_802_11_ad_hoc_start);
+	u8 *pos = (u8 *) adhoc_start +
+			sizeof(struct host_cmd_ds_802_11_ad_hoc_start);
 
 	if (!adapter)
 		return -1;
@@ -914,8 +909,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				priv->adhoc_channel)) {
 		struct mwifiex_chan_freq_power *cfp;
 		cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
-				adapter->adhoc_start_band,
-				FIRST_VALID_CHANNEL);
+				adapter->adhoc_start_band, FIRST_VALID_CHANNEL);
 		if (cfp)
 			priv->adhoc_channel = (u8) cfp->channel;
 	}
@@ -935,8 +929,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	adhoc_start->phy_param_set.ds_param_set.current_chan =
 		priv->adhoc_channel;
 
-	memcpy(&bss_desc->phy_param_set,
-	       &adhoc_start->phy_param_set,
+	memcpy(&bss_desc->phy_param_set, &adhoc_start->phy_param_set,
 	       sizeof(union ieee_types_phy_param_set));
 
 	/* Set IBSS param set */
@@ -950,8 +943,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	adhoc_start->ss_param_set.ibss_param_set.atim_window
 		= cpu_to_le16(priv->atim_window);
 	bss_desc->atim_window = priv->atim_window;
-	memcpy(&bss_desc->ss_param_set,
-	       &adhoc_start->ss_param_set,
+	memcpy(&bss_desc->ss_param_set, &adhoc_start->ss_param_set,
 	       sizeof(union ieee_types_ss_param_set));
 
 	/* Set Capability info */
@@ -979,8 +971,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	mwifiex_get_active_data_rates(priv, adhoc_start->DataRate);
 	if ((adapter->adhoc_start_band & BAND_G) &&
 	    (priv->curr_pkt_filter & HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON)) {
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_MAC_CONTROL,
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
 					  HostCmd_ACT_GEN_SET,
 					  0, NULL, &priv->curr_pkt_filter);
 
@@ -1024,9 +1015,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		       chan_tlv->chan_scan_param[0].chan_number);
 
 		chan_tlv->chan_scan_param[0].radio_type
-			=
-			mwifiex_band_to_radio_type(priv->curr_bss_params.
-						   band);
+		       = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
 		if (adapter->adhoc_start_band & BAND_GN
 		    || adapter->adhoc_start_band & BAND_AN) {
 			if (adapter->chan_offset == SEC_CHANNEL_ABOVE)
@@ -1046,9 +1035,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	}
 
 	/* Append vendor specific IE TLV */
-	cmd_append_size +=
-		mwifiex_cmd_append_vsie_tlv(priv, MWIFIEX_VSIE_MASK_ADHOC,
-					    &pos);
+	cmd_append_size += mwifiex_cmd_append_vsie_tlv(priv,
+				MWIFIEX_VSIE_MASK_ADHOC, &pos);
 
 	if (priv->sec_info.ewpa_enabled) {
 		memcpy(priv->wpa_ie, wpa_ie, sizeof(wpa_ie));
@@ -1113,8 +1101,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		}
 	}
 
-	cmd->size =
-		cpu_to_le16((u16)
+	cmd->size = cpu_to_le16((u16)
 			    (sizeof(struct host_cmd_ds_802_11_ad_hoc_start)
 			     + S_DS_GEN + cmd_append_size));
 
@@ -1169,8 +1156,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			priv->
 			curr_pkt_filter | HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON;
 
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_MAC_CONTROL,
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
 					  HostCmd_ACT_GEN_SET, 0, NULL,
 					  &curr_pkt_filter);
 		if (ret) {
@@ -1253,44 +1239,38 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: TLV Chan = %d\n",
 		       chan_tlv->chan_scan_param[0].chan_number);
 
-		chan_tlv->chan_scan_param[0].radio_type
-			=
+		chan_tlv->chan_scan_param[0].radio_type =
 			mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
 
 		dev_dbg(priv->adapter->dev, "info: ADHOC_J_CMD: TLV Band = %d\n",
 		       chan_tlv->chan_scan_param[0].radio_type);
 		pos += sizeof(chan_tlv->header) +
 			sizeof(struct mwifiex_chan_scan_param_set);
-		cmd_append_size +=
-			sizeof(chan_tlv->header) +
+		cmd_append_size += sizeof(chan_tlv->header) +
 			sizeof(struct mwifiex_chan_scan_param_set);
 	}
 
 	if (priv->sec_info.wpa_enabled)
 		rsn_ie_len = mwifiex_append_rsn_ie_wpa_wpa2(priv, &pos);
 	else if (priv->sec_info.ewpa_enabled)
-		rsn_ie_len = mwifiex_append_rsn_ie_ewpa(priv, &pos,
-							bss_desc);
+		rsn_ie_len = mwifiex_append_rsn_ie_ewpa(priv, &pos, bss_desc);
 	if (rsn_ie_len == -1)
 		return -1;
 	cmd_append_size += rsn_ie_len;
 
 	if (ISSUPP_11NENABLED(priv->adapter->fw_cap_info))
-		cmd_append_size +=
-			mwifiex_cmd_append_11n_tlv(priv, bss_desc, &pos);
+		cmd_append_size += mwifiex_cmd_append_11n_tlv(priv,
+			bss_desc, &pos);
 
 	/* Append vendor specific IE TLV */
-	cmd_append_size +=
-		mwifiex_cmd_append_vsie_tlv(priv, MWIFIEX_VSIE_MASK_ADHOC,
-					    &pos);
+	cmd_append_size += mwifiex_cmd_append_vsie_tlv(priv,
+			MWIFIEX_VSIE_MASK_ADHOC, &pos);
 
-	cmd->size =
-		cpu_to_le16((u16)
+	cmd->size = cpu_to_le16((u16)
 			    (sizeof(struct host_cmd_ds_802_11_ad_hoc_join)
 			     + S_DS_GEN + cmd_append_size));
 
-	adhoc_join->bss_descriptor.cap_info_bitmap =
-				cpu_to_le16(tmp_cap);
+	adhoc_join->bss_descriptor.cap_info_bitmap = cpu_to_le16(tmp_cap);
 
 	return ret;
 }
@@ -1413,8 +1393,7 @@ int mwifiex_associate(struct mwifiex_private *priv,
 	   retrieval */
 	priv->assoc_rsp_size = 0;
 
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_ASSOCIATE,
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_ASSOCIATE,
 				  HostCmd_ACT_GEN_SET, 0, wait_queue,
 				  bss_desc);
 
@@ -1439,8 +1418,7 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %d\n",
 	       priv->curr_bss_params.band);
 
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_AD_HOC_START,
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_AD_HOC_START,
 				  HostCmd_ACT_GEN_SET, 0, wait_queue,
 				  adhoc_ssid);
 
@@ -1483,8 +1461,7 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev, "info: curr_bss_params.band = %c\n",
 	       priv->curr_bss_params.band);
 
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_AD_HOC_JOIN,
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_AD_HOC_JOIN,
 				  HostCmd_ACT_GEN_SET, 0, wait_queue,
 				  bss_desc);
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 1b9d396..0201263 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -65,8 +65,7 @@ static struct mwifiex_drv_mode mwifiex_drv_mode_tbl[] = {
  * In case of any errors during inittialization, this function also ensures
  * proper cleanup before exiting.
  */
-static int mwifiex_register(void *card,
-			    struct mwifiex_if_ops *if_ops,
+static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 			    struct mwifiex_device *mdevice, void **padapter)
 {
 	int ret = 0;
@@ -251,8 +250,7 @@ process_start:
 			if (adapter->scan_processing || adapter->data_sent
 			    || mwifiex_wmm_lists_empty(adapter)) {
 				if (adapter->cmd_sent || adapter->curr_cmd
-				    ||
-				    (!is_command_pending(adapter)))
+				    || (!is_command_pending(adapter)))
 					break;
 			}
 		}
@@ -1075,9 +1073,8 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	}
 	/* Add interfaces */
 	for (i = 0; i < drv_mode_info->intf_num; i++) {
-		if (!mwifiex_add_interface
-		    (adapter, i,
-		     adapter->drv_mode->bss_attr[i].bss_type)) {
+		if (!mwifiex_add_interface(adapter, i,
+				adapter->drv_mode->bss_attr[i].bss_type)) {
 			status = -1;
 			break;
 		}
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index bc8f73b..f463711 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -99,8 +99,7 @@ mwifiex_search_oui_in_ie(struct ie_body *iebody, u8 *oui)
 
 		--count;
 		if (count)
-			iebody =
-				(struct ie_body *) ((u8 *) iebody +
+			iebody = (struct ie_body *) ((u8 *) iebody +
 						sizeof(iebody->ptk_body));
 	}
 
@@ -124,9 +123,8 @@ mwifiex_is_rsn_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 
 	if (((bss_desc->bcn_rsn_ie) && ((*(bss_desc->bcn_rsn_ie)).
 					ieee_hdr.element_id == WLAN_EID_RSN))) {
-		iebody =
-			(struct ie_body *)
-			(((u8 *) bss_desc->bcn_rsn_ie->data) +
+		iebody = (struct ie_body *)
+			 (((u8 *) bss_desc->bcn_rsn_ie->data) +
 			 RSN_GTK_OUI_OFFSET);
 		oui = &mwifiex_rsn_oui[cipher][0];
 		ret = mwifiex_search_oui_in_ie(iebody, oui);
@@ -544,8 +542,7 @@ mwifiex_is_network_compatible_for_dynamic_wep(struct mwifiex_private *priv,
  * Compatibility is not matched while roaming, except for mode.
  */
 static s32
-mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
-			      u32 mode)
+mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index, u32 mode)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bssdescriptor *bss_desc;
@@ -554,8 +551,7 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 	bss_desc->disable_11n = false;
 
 	/* Don't check for compatibility if roaming */
-	if (priv->media_connected
-	    && (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA)
+	if (priv->media_connected && (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA)
 	    && (bss_desc->bss_mode == MWIFIEX_BSS_MODE_INFRA))
 		return index;
 
@@ -709,8 +705,7 @@ mwifiex_find_best_network_in_list(struct mwifiex_private *priv)
 			if (mwifiex_is_network_compatible(priv, i, mode) >= 0) {
 				if (SCAN_RSSI(adapter->scan_table[i].rssi) >
 				    best_rssi) {
-					best_rssi =
-						SCAN_RSSI(adapter->
+					best_rssi = SCAN_RSSI(adapter->
 							  scan_table[i].rssi);
 					best_net = i;
 				}
@@ -720,9 +715,8 @@ mwifiex_find_best_network_in_list(struct mwifiex_private *priv)
 		default:
 			if (SCAN_RSSI(adapter->scan_table[i].rssi) >
 			    best_rssi) {
-				best_rssi =
-					SCAN_RSSI(adapter->scan_table[i].
-						  rssi);
+				best_rssi = SCAN_RSSI(adapter->scan_table[i].
+						      rssi);
 				best_net = i;
 			}
 			break;
@@ -774,12 +768,10 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 					chan_list[0].scan_time);
 			else if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
 				scan_chan_list[chan_idx].max_scan_time =
-					cpu_to_le16(adapter->
-							passive_scan_time);
+					cpu_to_le16(adapter->passive_scan_time);
 			else
 				scan_chan_list[chan_idx].max_scan_time =
-					cpu_to_le16(adapter->
-							active_scan_time);
+					cpu_to_le16(adapter->active_scan_time);
 			if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
 				scan_chan_list[chan_idx].chan_scan_mode_bitmap
 					|= MWIFIEX_PASSIVE_SCAN;
@@ -809,10 +801,8 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
  * along with the other TLVs, to the firmware.
  */
 static int
-mwifiex_scan_channel_list(struct mwifiex_private *priv,
-			  void *wait_buf,
-			  u32 max_chan_per_scan,
-			  u8 filtered_scan,
+mwifiex_scan_channel_list(struct mwifiex_private *priv, void *wait_buf,
+			  u32 max_chan_per_scan, u8 filtered_scan,
 			  struct mwifiex_scan_cmd_config *scan_cfg_out,
 			  struct mwifiex_ie_types_chan_list_param_set
 			  *chan_tlv_out,
@@ -891,9 +881,8 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			 * of the tlv buffer.  This compensates for any TLVs
 			 * that were appended before the channel list.
 			 */
-			scan_cfg_out->tlv_buf_len =
-				(u32) ((u8 *) chan_tlv_out -
-					 scan_cfg_out->tlv_buf);
+			scan_cfg_out->tlv_buf_len = (u32) ((u8 *) chan_tlv_out -
+							scan_cfg_out->tlv_buf);
 
 			/* Add the size of the channel tlv header and the data
 			   length */
@@ -914,8 +903,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			/* Stop the loop if the *current* channel is in the
 			   1,6,11 set and we are not filtering on a BSSID
 			   or SSID. */
-			if (!filtered_scan
-			    && (tmp_chan_list->chan_number == 1
+			if (!filtered_scan && (tmp_chan_list->chan_number == 1
 				|| tmp_chan_list->chan_number == 6
 				|| tmp_chan_list->chan_number == 11))
 				done_early = true;
@@ -927,8 +915,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			/* Stop the loop if the *next* channel is in the 1,6,11
 			   set.  This will cause it to be the only channel
 			   scanned on the next interation */
-			if (!filtered_scan
-			    && (tmp_chan_list->chan_number == 1
+			if (!filtered_scan && (tmp_chan_list->chan_number == 1
 				|| tmp_chan_list->chan_number == 6
 				|| tmp_chan_list->chan_number == 11))
 				done_early = true;
@@ -948,8 +935,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 
 		/* Send the scan command to the firmware with the specified
 		   cfg */
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_802_11_SCAN,
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SCAN,
 					  HostCmd_ACT_GEN_SET,
 					  0, wait_buf, scan_cfg_out);
 		if (ret)
@@ -984,8 +970,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
  */
 static void
 mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
-			       const struct mwifiex_user_scan_cfg
-			       *user_scan_in,
+			       const struct mwifiex_user_scan_cfg *user_scan_in,
 			       struct mwifiex_scan_cmd_config *scan_cfg_out,
 			       struct mwifiex_ie_types_chan_list_param_set
 			       **chan_list_out,
@@ -1068,20 +1053,17 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 			  || user_scan_in->ssid_list[ssid_idx].max_len));
 		     ssid_idx++) {
 
-			ssid_len =
-				strlen(user_scan_in->ssid_list[ssid_idx].
-				       ssid) + 1;
+			ssid_len = strlen(user_scan_in->ssid_list[ssid_idx].
+					  ssid) + 1;
 
-			wildcard_ssid_tlv
-				=
+			wildcard_ssid_tlv =
 				(struct mwifiex_ie_types_wildcard_ssid_params *)
 				tlv_pos;
 			wildcard_ssid_tlv->header.type =
 				cpu_to_le16(TLV_TYPE_WILDCARDSSID);
 			wildcard_ssid_tlv->header.len = cpu_to_le16(
-				(u16) (ssid_len +
-					 sizeof(wildcard_ssid_tlv->
-						max_ssid_length)));
+				(u16) (ssid_len + sizeof(wildcard_ssid_tlv->
+							 max_ssid_length)));
 			wildcard_ssid_tlv->max_ssid_length =
 				user_scan_in->ssid_list[ssid_idx].max_len;
 
@@ -1093,9 +1075,8 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 				+ le16_to_cpu(wildcard_ssid_tlv->header.len));
 
 			dev_dbg(adapter->dev, "info: scan: ssid_list[%d]: %s, %d\n",
-			       ssid_idx,
-			       wildcard_ssid_tlv->ssid,
-			       wildcard_ssid_tlv->max_ssid_length);
+				ssid_idx, wildcard_ssid_tlv->ssid,
+				wildcard_ssid_tlv->max_ssid_length);
 
 			/* Empty wildcard ssid with a maxlen will match many or
 			   potentially all SSIDs (maxlen == 32), therefore do
@@ -1137,15 +1118,13 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		dev_dbg(adapter->dev, "info: scan: num_probes = %d\n",
 						num_probes);
 
-		num_probes_tlv =
-			(struct mwifiex_ie_types_num_probes *) tlv_pos;
+		num_probes_tlv = (struct mwifiex_ie_types_num_probes *) tlv_pos;
 		num_probes_tlv->header.type = cpu_to_le16(TLV_TYPE_NUMPROBES);
 		num_probes_tlv->header.len =
 			cpu_to_le16(sizeof(num_probes_tlv->num_probes));
 		num_probes_tlv->num_probes = cpu_to_le16((u16) num_probes);
 
-		tlv_pos +=
-			sizeof(num_probes_tlv->header) +
+		tlv_pos += sizeof(num_probes_tlv->header) +
 			le16_to_cpu(num_probes_tlv->header.len);
 
 	}
@@ -1196,16 +1175,14 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		     && user_scan_in->chan_list[chan_idx].chan_number;
 		     chan_idx++) {
 
-			channel =
-				user_scan_in->chan_list[chan_idx].chan_number;
+			channel = user_scan_in->chan_list[chan_idx].chan_number;
 			(scan_chan_list + chan_idx)->chan_number = channel;
 
 			radio_type =
 				user_scan_in->chan_list[chan_idx].radio_type;
 			(scan_chan_list + chan_idx)->radio_type = radio_type;
 
-			scan_type =
-				user_scan_in->chan_list[chan_idx].scan_type;
+			scan_type = user_scan_in->chan_list[chan_idx].scan_type;
 
 			if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
 				(scan_chan_list +
@@ -1217,15 +1194,13 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 					&= ~MWIFIEX_PASSIVE_SCAN;
 
 			if (user_scan_in->chan_list[chan_idx].scan_time) {
-				scan_dur =
-					(u16) user_scan_in->
+				scan_dur = (u16) user_scan_in->
 					chan_list[chan_idx].scan_time;
 			} else {
 				if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
 					scan_dur = adapter->passive_scan_time;
 				else if (*filtered_scan)
-					scan_dur =
-						adapter->specific_scan_time;
+					scan_dur = adapter->specific_scan_time;
 				else
 					scan_dur = adapter->active_scan_time;
 			}
@@ -1266,8 +1241,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 static void
 mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
 				     struct mwifiex_ie_types_data *tlv,
-				     u32 tlv_buf_size,
-				     u32 req_tlv_type,
+				     u32 tlv_buf_size, u32 req_tlv_type,
 				     struct mwifiex_ie_types_data **tlv_data)
 {
 	struct mwifiex_ie_types_data *current_tlv;
@@ -1485,7 +1459,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			ret = -1;
 			continue;
 		}
-
 		switch (element_id) {
 		case WLAN_EID_SSID:
 			bss_entry->ssid.ssid_len = element_len;
@@ -1571,9 +1544,8 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_VENDOR_SPECIFIC:
-			vendor_ie =
-				(struct ieee_types_vendor_specific *)
-				current_ptr;
+			vendor_ie = (struct ieee_types_vendor_specific *)
+					current_ptr;
 
 			if (!memcmp
 			    (vendor_ie->vend_hdr.oui, wpa_oui,
@@ -1581,11 +1553,9 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				bss_entry->bcn_wpa_ie =
 					(struct ieee_types_vendor_specific *)
 					current_ptr;
-				bss_entry->wpa_offset =
-					(u16) (current_ptr -
-						 bss_entry->beacon_buf);
-			} else if (!memcmp
-				   (vendor_ie->vend_hdr.oui, wmm_oui,
+				bss_entry->wpa_offset = (u16) (current_ptr -
+							bss_entry->beacon_buf);
+			} else if (!memcmp(vendor_ie->vend_hdr.oui, wmm_oui,
 				    sizeof(wmm_oui))) {
 				if (total_ie_len ==
 				    sizeof(struct ieee_types_wmm_parameter)
@@ -1603,16 +1573,14 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		case WLAN_EID_RSN:
 			bss_entry->bcn_rsn_ie =
 				(struct ieee_types_generic *) current_ptr;
-			bss_entry->rsn_offset =
-				(u16) (current_ptr -
-					 bss_entry->beacon_buf);
+			bss_entry->rsn_offset = (u16) (current_ptr -
+							bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_BSS_AC_ACCESS_DELAY:
 			bss_entry->bcn_wapi_ie =
 				(struct ieee_types_generic *) current_ptr;
-			bss_entry->wapi_offset =
-				(u16) (current_ptr -
-					 bss_entry->beacon_buf);
+			bss_entry->wapi_offset = (u16) (current_ptr -
+							bss_entry->beacon_buf);
 			break;
 		case WLAN_EID_HT_CAPABILITY:
 			bss_entry->bcn_ht_cap = (struct ieee80211_ht_cap *)
@@ -1648,9 +1616,8 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			bss_entry->bcn_obss_scan =
 				(struct ieee_types_obss_scan_param *)
 				current_ptr;
-			bss_entry->overlap_bss_offset =
-				(u16) (current_ptr -
-					 bss_entry->beacon_buf);
+			bss_entry->overlap_bss_offset = (u16) (current_ptr -
+							bss_entry->beacon_buf);
 			break;
 		default:
 			break;
@@ -1694,15 +1661,12 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
  *      - Overlapping BSS scan parameter IE pointer
  */
 static void
-mwifiex_adjust_beacon_buffer_ptrs(struct mwifiex_private *priv,
-				     u8 advance,
-				     u8 *bcn_store,
-				     u32 rem_bcn_size,
-				     u32 num_of_ent)
+mwifiex_adjust_beacon_buffer_ptrs(struct mwifiex_private *priv, u8 advance,
+				  u8 *bcn_store, u32 rem_bcn_size,
+				  u32 num_of_ent)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u32 adj_idx;
-
 	for (adj_idx = 0; adj_idx < num_of_ent; adj_idx++) {
 		if (adapter->scan_table[adj_idx].beacon_buf > bcn_store) {
 
@@ -1821,8 +1785,7 @@ mwifiex_update_beacon_buffer_ptrs(struct mwifiex_bssdescriptor *beacon)
  */
 static void
 mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
-				     u32 beacon_idx,
-				     u32 num_of_ent,
+				     u32 beacon_idx, u32 num_of_ent,
 				     struct mwifiex_bssdescriptor *new_beacon)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -1834,23 +1797,19 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 	if (adapter->scan_table[beacon_idx].beacon_buf) {
 
 		new_bcn_size = new_beacon->beacon_buf_size;
-		old_bcn_size =
-			adapter->scan_table[beacon_idx].beacon_buf_size;
-		bcn_space =
-			adapter->scan_table[beacon_idx].beacon_buf_size_max;
+		old_bcn_size = adapter->scan_table[beacon_idx].beacon_buf_size;
+		bcn_space = adapter->scan_table[beacon_idx].beacon_buf_size_max;
 		bcn_store = adapter->scan_table[beacon_idx].beacon_buf;
 
 		/* Set the max to be the same as current entry unless changed
 		   below */
 		new_beacon->beacon_buf_size_max = bcn_space;
-
 		if (new_bcn_size == old_bcn_size) {
 			/*
 			 * Beacon is the same size as the previous entry.
 			 *   Replace the previous contents with the scan result
 			 */
-			memcpy(bcn_store,
-			       new_beacon->beacon_buf,
+			memcpy(bcn_store, new_beacon->beacon_buf,
 			       new_beacon->beacon_buf_size);
 
 		} else if (new_bcn_size <= bcn_space) {
@@ -1860,8 +1819,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 			 */
 
 			/* Copy the new beacon buffer entry over the old one */
-			memcpy(bcn_store, new_beacon->beacon_buf,
-			       new_bcn_size);
+			memcpy(bcn_store, new_beacon->beacon_buf, new_bcn_size);
 
 			/*
 			 *  If the old beacon size was less than the maximum
@@ -1945,12 +1903,10 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 			 */
 			memmove(bcn_store + new_bcn_size,
 				bcn_store + bcn_space,
-				adapter->bcn_buf_end - (bcn_store +
-							   bcn_space));
+				adapter->bcn_buf_end - (bcn_store + bcn_space));
 
 			/* Copy the new beacon buffer entry over the old one */
-			memcpy(bcn_store, new_beacon->beacon_buf,
-			       new_bcn_size);
+			memcpy(bcn_store, new_beacon->beacon_buf, new_bcn_size);
 
 			/* Move the beacon end pointer by the amount of new
 			   beacon data we are adding */
@@ -1965,9 +1921,9 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 
 			/* Adjust beacon buffer pointers that are past the
 			   current */
-			mwifiex_adjust_beacon_buffer_ptrs(priv, 1,
-				bcn_store, (new_bcn_size - bcn_space),
-				num_of_ent);
+			mwifiex_adjust_beacon_buffer_ptrs(priv, 1, bcn_store,
+						(new_bcn_size - bcn_space),
+						num_of_ent);
 		} else {
 			/*
 			 * Beacon is larger than the previously allocated space,
@@ -2033,8 +1989,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 			 * the adapter dev struct buffer space used to store
 			 * the raw beacon data for each entry in the scan table
 			 */
-			memcpy(adapter->bcn_buf_end,
-			       new_beacon->beacon_buf,
+			memcpy(adapter->bcn_buf_end, new_beacon->beacon_buf,
 			       new_beacon->beacon_buf_size);
 
 			/* Update the beacon ptr to point to the table save
@@ -2047,8 +2002,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 			mwifiex_update_beacon_buffer_ptrs(new_beacon);
 
 			/* Increment the end pointer by the size reserved */
-			adapter->bcn_buf_end +=
-				new_beacon->beacon_buf_size_max;
+			adapter->bcn_buf_end += new_beacon->beacon_buf_size_max;
 
 			dev_dbg(adapter->dev, "info: AppControl: beacon[%02d]"
 				" sz=%03d, used = %04d, left = %04d\n",
@@ -2114,8 +2068,7 @@ mwifiex_process_scan_results(struct mwifiex_private *priv)
 
 	if (priv->media_connected) {
 
-		j = mwifiex_find_ssid_in_list(priv,
-					      &priv->curr_bss_params.
+		j = mwifiex_find_ssid_in_list(priv, &priv->curr_bss_params.
 					      bss_descriptor.ssid,
 					      priv->curr_bss_params.
 					      bss_descriptor.mac_address,
@@ -2140,14 +2093,12 @@ mwifiex_process_scan_results(struct mwifiex_private *priv)
 			priv->curr_bss_params.bss_descriptor.
 				bss_co_2040_offset = 0;
 			priv->curr_bss_params.bss_descriptor.bcn_ext_cap = NULL;
-			priv->curr_bss_params.bss_descriptor.ext_cap_offset =
-				0;
+			priv->curr_bss_params.bss_descriptor.ext_cap_offset = 0;
 			priv->curr_bss_params.bss_descriptor.
 				bcn_obss_scan = NULL;
 			priv->curr_bss_params.bss_descriptor.
 				overlap_bss_offset = 0;
-			priv->curr_bss_params.bss_descriptor.beacon_buf =
-				NULL;
+			priv->curr_bss_params.bss_descriptor.beacon_buf = NULL;
 			priv->curr_bss_params.bss_descriptor.beacon_buf_size =
 				0;
 			priv->curr_bss_params.bss_descriptor.
@@ -2235,8 +2186,7 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
 
 		dev_dbg(adapter->dev, "info: scan: delete entry %d,"
 			" compact data: %p <- %p (sz = %d)\n",
-		       table_idx,
-		       beacon_buf,
+		       table_idx, beacon_buf,
 		       beacon_buf + beacon_buf_adj,
 		       (int)(adapter->bcn_buf_end - beacon_buf));
 
@@ -2250,8 +2200,7 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
 		 *
 		 * Use memmove since the dest/src memory regions overlap.
 		 */
-		memmove(beacon_buf,
-			beacon_buf + beacon_buf_adj,
+		memmove(beacon_buf, beacon_buf + beacon_buf_adj,
 			adapter->bcn_buf_end - beacon_buf);
 	}
 
@@ -2359,9 +2308,7 @@ mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
 	/* If the requested SSID is found in the table, delete it.  Then keep
 	   searching the table for multiple entires for the SSID until no
 	   more are found */
-	while ((table_idx = mwifiex_find_ssid_in_list(priv,
-						      del_ssid,
-						      NULL,
+	while ((table_idx = mwifiex_find_ssid_in_list(priv, del_ssid, NULL,
 						      MWIFIEX_BSS_MODE_AUTO)) >=
 	       0) {
 		dev_dbg(priv->adapter->dev,
@@ -2433,9 +2380,8 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 		return -1;
 	}
 
-	buf_size =
-		sizeof(struct mwifiex_chan_scan_param_set) *
-		MWIFIEX_USER_SCAN_CHAN_MAX;
+	buf_size = sizeof(struct mwifiex_chan_scan_param_set) *
+			MWIFIEX_USER_SCAN_CHAN_MAX;
 	scan_chan_list = kzalloc(buf_size, GFP_KERNEL);
 	if (!scan_chan_list) {
 		dev_err(adapter->dev, "failed to alloc scan_chan_list\n");
@@ -2445,12 +2391,9 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 
 	keep_previous_scan = false;
 
-	mwifiex_scan_setup_scan_config(priv,
-				       user_scan_in,
-				       &scan_cfg_out->config,
-				       &chan_list_out,
-				       scan_chan_list,
-				       &max_chan_per_scan,
+	mwifiex_scan_setup_scan_config(priv, user_scan_in,
+				       &scan_cfg_out->config, &chan_list_out,
+				       scan_chan_list, &max_chan_per_scan,
 				       &filtered_scan, &scan_current_chan_only);
 
 	if (user_scan_in)
@@ -2521,8 +2464,7 @@ int mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
 	scan_cmd->bss_mode = scan_cfg->bss_mode;
 	memcpy(scan_cmd->bssid, scan_cfg->specific_bssid,
 	       sizeof(scan_cmd->bssid));
-	memcpy(scan_cmd->tlv_buffer, scan_cfg->tlv_buf,
-	       scan_cfg->tlv_buf_len);
+	memcpy(scan_cmd->tlv_buffer, scan_cfg->tlv_buf, scan_cfg->tlv_buf_len);
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SCAN);
 
@@ -2624,18 +2566,14 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 	/* Search the TLV buffer space in the scan response for any valid
 	   TLVs */
-	mwifiex_ret_802_11_scan_get_tlv_ptrs(adapter,
-					     tlv_data,
-					     tlv_buf_size,
+	mwifiex_ret_802_11_scan_get_tlv_ptrs(adapter, tlv_data, tlv_buf_size,
 					     TLV_TYPE_TSFTIMESTAMP,
 					     (struct mwifiex_ie_types_data **)
 					     &tsf_tlv);
 
 	/* Search the TLV buffer space in the scan response for any valid
 	   TLVs */
-	mwifiex_ret_802_11_scan_get_tlv_ptrs(adapter,
-					     tlv_data,
-					     tlv_buf_size,
+	mwifiex_ret_802_11_scan_get_tlv_ptrs(adapter, tlv_data, tlv_buf_size,
 					     TLV_TYPE_CHANNELBANDLIST,
 					     (struct mwifiex_ie_types_data **)
 					     &chan_band_tlv);
@@ -2659,10 +2597,9 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		       sizeof(struct mwifiex_bssdescriptor));
 
 		/* Process the data fields and IEs returned for this BSS */
-		if (!mwifiex_interpret_bss_desc_with_ie(adapter,
-						       bss_new_entry,
-						       &bss_info,
-						       &bytes_left)) {
+		if (!mwifiex_interpret_bss_desc_with_ie(adapter, bss_new_entry,
+							&bss_info,
+							&bytes_left)) {
 
 			dev_dbg(adapter->dev, "info: SCAN_RESP: BSSID = %pM\n",
 			       bss_new_entry->mac_address);
@@ -2717,8 +2654,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			 * application retrieval.  Duplicate beacon/probe
 			 * responses are updated if possible
 			 */
-			mwifiex_ret_802_11_scan_store_beacon(priv,
-							     bss_idx,
+			mwifiex_ret_802_11_scan_store_beacon(priv, bss_idx,
 							     num_in_table,
 							     bss_new_entry);
 			/*
@@ -2739,24 +2675,18 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			if (chan_band_tlv) {
 				chan_band =
 					&chan_band_tlv->chan_band_param[idx];
-				band = mwifiex_radio_type_to_band(chan_band->
-								  radio_type &
-								  (BIT(0) |
-								   BIT(1)));
+				band = mwifiex_radio_type_to_band(
+							chan_band->radio_type &
+							(BIT(0) | BIT(1)));
 			}
 
 			/* Save the band designation for this entry for use in
 			   join */
 			bss_new_entry->bss_band = band;
 			cfp =
-			mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-								(priv,
-								   (u8)
-								   bss_new_entry
-								   ->bss_band,
-								   (u16)
-								  bss_new_entry
-								   ->channel);
+			mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
+						(u8) bss_new_entry->bss_band,
+						(u16)bss_new_entry->channel);
 
 			if (cfp)
 				bss_new_entry->freq = cfp->freq;
@@ -2765,8 +2695,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 			/* Copy the locally created bss_new_entry to the scan
 			   table */
-			memcpy(&adapter->scan_table[bss_idx],
-			       bss_new_entry,
+			memcpy(&adapter->scan_table[bss_idx], bss_new_entry,
 			       sizeof(adapter->scan_table[bss_idx]));
 
 		} else {
@@ -2849,9 +2778,8 @@ int mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
 		&cmd->params.bg_scan_query;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_BG_SCAN_QUERY);
-	cmd->size =
-		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_bg_scan_query) +
-			    S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_bg_scan_query)
+				+ S_DS_GEN);
 
 	bg_query->flush = 1;
 
@@ -2904,8 +2832,7 @@ mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
 					if (SCAN_RSSI
 					    (adapter->scan_table[i].rssi) >
 					    best_rssi) {
-						best_rssi =
-							SCAN_RSSI(adapter->
+						best_rssi = SCAN_RSSI(adapter->
 								  scan_table
 								  [i].rssi);
 						net = i;
@@ -2925,8 +2852,7 @@ mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
 				 */
 				if (SCAN_RSSI(adapter->scan_table[i].rssi) >
 				    best_rssi) {
-					best_rssi =
-						SCAN_RSSI(adapter->
+					best_rssi = SCAN_RSSI(adapter->
 							  scan_table[i].rssi);
 					net = i;
 				}
@@ -3136,12 +3062,10 @@ mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv,
 				& 0x00FF) + 2);
 			memcpy(vs_param_set->ie, priv->vs_ie[id].ie,
 			       le16_to_cpu(vs_param_set->header.len));
-			*buffer +=
-				le16_to_cpu(vs_param_set->header.len) +
-				sizeof(struct mwifiex_ie_types_header);
-			ret_len +=
-				le16_to_cpu(vs_param_set->header.len) +
-				sizeof(struct mwifiex_ie_types_header);
+			*buffer += le16_to_cpu(vs_param_set->header.len) +
+				   sizeof(struct mwifiex_ie_types_header);
+			ret_len += le16_to_cpu(vs_param_set->header.len) +
+				   sizeof(struct mwifiex_ie_types_header);
 		}
 	}
 	return ret_len;
@@ -3204,7 +3128,6 @@ mwifiex_restore_curr_bcn(struct mwifiex_private *priv)
 	if (priv->curr_bcn_buf &&
 	    ((adapter->bcn_buf_end + priv->curr_bcn_size) <
 	     (adapter->bcn_buf + sizeof(adapter->bcn_buf)))) {
-
 		spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
 
 		/* restore the current beacon buffer */
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 00158ff..4ad1dfb 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -620,9 +620,8 @@ static int mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
  * This function sends a data buffer to the card.
  */
 static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
-				     u32 *type, u32 *nb,
-				     u8 *buffer, u32 npayload,
-				     u32 ioport)
+				     u32 *type, u32 *nb, u8 *buffer,
+				     u32 npayload, u32 ioport)
 {
 	int ret = 0;
 
@@ -692,8 +691,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	do {
 		/* The host polls for the DN_LD_CARD_RDY and CARD_IO_READY
 		   bits */
-		ret = mwifiex_sdio_poll_card_status(adapter,
-						    CARD_IO_READY |
+		ret = mwifiex_sdio_poll_card_status(adapter, CARD_IO_READY |
 						    DN_LD_CARD_RDY);
 		if (ret) {
 			dev_err(adapter->dev, "FW download with helper:"
@@ -706,18 +704,16 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			break;
 
 		for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
-			ret = mwifiex_read_reg(adapter,
-						HOST_F1_RD_BASE_0,
-						&base0);
+			ret = mwifiex_read_reg(adapter, HOST_F1_RD_BASE_0,
+					       &base0);
 			if (ret) {
 				dev_err(adapter->dev, "dev BASE0 register read"
 					" failed: base0=0x%04X(%d). Terminating "
 				       "download\n", base0, base0);
 				goto done;
 			}
-			ret = mwifiex_read_reg(adapter,
-						 HOST_F1_RD_BASE_1,
-						&base1);
+			ret = mwifiex_read_reg(adapter, HOST_F1_RD_BASE_1,
+					       &base1);
 			if (ret) {
 				dev_err(adapter->dev, "dev BASE1 register read"
 					" failed: base1=0x%04X(%d). Terminating "
@@ -764,9 +760,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			if (firmware_len - offset < txlen)
 				txlen = firmware_len - offset;
 
-			tx_blocks =
-				(txlen + MWIFIEX_SDIO_BLOCK_SIZE -
-				 1) / MWIFIEX_SDIO_BLOCK_SIZE;
+			tx_blocks = (txlen + MWIFIEX_SDIO_BLOCK_SIZE -
+					1) / MWIFIEX_SDIO_BLOCK_SIZE;
 
 			/* Copy payload to buffer */
 			memmove(fwbuf, &firmware[offset], txlen);
@@ -1323,9 +1318,7 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 			adapter->data_sent = false;
 	} else {
 		if (type == MWIFIEX_TYPE_DATA) {
-			if (!
-			    (card->
-			     mp_wr_bitmap & (1 << card->curr_wr_port)))
+			if (!(card->mp_wr_bitmap & (1 << card->curr_wr_port)))
 				adapter->data_sent = true;
 			else
 				adapter->data_sent = false;
@@ -1774,10 +1767,8 @@ mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
 				card->mpa_rx.buf_size = data[3];
 
 			if (mwifiex_alloc_sdio_mpa_buffers(adapter,
-							   card->mpa_tx.
-							   buf_size,
-							   card->mpa_rx.
-							   buf_size)) {
+						       card->mpa_tx.buf_size,
+						       card->mpa_rx.buf_size)) {
 				dev_err(adapter->dev, "failed to alloc "
 				       "sdio mp-a buffers\n");
 				return -EINVAL;
@@ -1804,12 +1795,10 @@ mwifiex_sdio_mpactrl(struct mwifiex_private *priv, u8 write, int *data,
 		}
 
 		dev_dbg(adapter->dev, "info: new param: %d %d %d %d %d %d\n",
-		       card->mpa_tx.enabled,
-		       card->mpa_rx.enabled,
-		       card->mpa_tx.buf_size,
-		       card->mpa_rx.buf_size,
-		       card->mpa_tx.pkt_aggr_limit,
-		       card->mpa_rx.pkt_aggr_limit);
+			card->mpa_tx.enabled, card->mpa_rx.enabled,
+			card->mpa_tx.buf_size, card->mpa_rx.buf_size,
+			card->mpa_tx.pkt_aggr_limit,
+			card->mpa_rx.pkt_aggr_limit);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index f44427f..b072d06 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -40,9 +40,8 @@ mwifiex_cmd_802_11_rssi_info(struct mwifiex_private *priv,
 			     struct host_cmd_ds_command *cmd, u16 cmd_action)
 {
 	cmd->command = cpu_to_le16(HostCmd_CMD_RSSI_INFO);
-	cmd->size =
-		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_rssi_info) +
-			    S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_rssi_info) +
+				S_DS_GEN);
 	cmd->params.rssi_info.action = cpu_to_le16(cmd_action);
 	cmd->params.rssi_info.ndata = cpu_to_le16(priv->data_avg_factor);
 	cmd->params.rssi_info.nbcn = cpu_to_le16(priv->bcn_avg_factor);
@@ -127,8 +126,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	case FRAG_THRESH_I:
 		snmp_mib->oid = cpu_to_le16((u16) FRAG_THRESH_I);
 		if (cmd_action == HostCmd_ACT_GEN_SET) {
-			snmp_mib->query_type =
-				cpu_to_le16(HostCmd_ACT_GEN_SET);
+			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
 			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
 			ul_temp = *((u32 *) data_buf);
 			*((__le16 *) (snmp_mib->value)) =
@@ -140,8 +138,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	case RTS_THRESH_I:
 		snmp_mib->oid = cpu_to_le16((u16) RTS_THRESH_I);
 		if (cmd_action == HostCmd_ACT_GEN_SET) {
-			snmp_mib->query_type =
-				cpu_to_le16(HostCmd_ACT_GEN_SET);
+			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
 			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
 			ul_temp = *((u32 *) data_buf);
 			*(__le16 *) (snmp_mib->value) =
@@ -154,8 +151,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	case SHORT_RETRY_LIM_I:
 		snmp_mib->oid = cpu_to_le16((u16) SHORT_RETRY_LIM_I);
 		if (cmd_action == HostCmd_ACT_GEN_SET) {
-			snmp_mib->query_type =
-				cpu_to_le16(HostCmd_ACT_GEN_SET);
+			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
 			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
 			ul_temp = (*(u32 *) data_buf);
 			*((__le16 *) (snmp_mib->value)) =
@@ -167,8 +163,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	case DOT11D_I:
 		snmp_mib->oid = cpu_to_le16((u16) DOT11D_I);
 		if (cmd_action == HostCmd_ACT_GEN_SET) {
-			snmp_mib->query_type = cpu_to_le16(
-				HostCmd_ACT_GEN_SET);
+			snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
 			snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
 			ul_temp = *(u32 *) data_buf;
 			*((__le16 *) (snmp_mib->value)) =
@@ -200,9 +195,8 @@ mwifiex_cmd_802_11_get_log(struct mwifiex_private *priv,
 			   struct host_cmd_ds_command *cmd)
 {
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_GET_LOG);
-	cmd->size =
-		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_get_log) +
-			    S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_get_log) +
+				S_DS_GEN);
 	return 0;
 }
 
@@ -232,8 +226,7 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 	rate_cfg->cfg_index = 0;
 
 	rate_scope = (struct mwifiex_rate_scope *) ((u8 *) rate_cfg +
-			sizeof(struct
-				host_cmd_ds_tx_rate_cfg));
+		      sizeof(struct host_cmd_ds_tx_rate_cfg));
 	rate_scope->type = cpu_to_le16(TLV_TYPE_RATE_SCOPE);
 	rate_scope->length = cpu_to_le16(sizeof(struct mwifiex_rate_scope) -
 			sizeof(struct mwifiex_ie_types_header));
@@ -258,8 +251,7 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 	}
 
 	rate_drop = (struct mwifiex_rate_drop_pattern *) ((u8 *) rate_scope +
-			sizeof(struct
-				mwifiex_rate_scope));
+			sizeof(struct mwifiex_rate_scope));
 	rate_drop->type = cpu_to_le16(TLV_TYPE_RATE_DROP_CONTROL);
 	rate_drop->length = cpu_to_le16(sizeof(rate_drop->rate_drop_mode));
 	rate_drop->rate_drop_mode = 0;
@@ -296,25 +288,20 @@ static int mwifiex_cmd_tx_power_cfg(struct mwifiex_private *priv,
 	case HostCmd_ACT_GEN_SET:
 		txp = (struct host_cmd_ds_txpwr_cfg *) data_buf;
 		if (txp->mode) {
-			pg_tlv =
-				(struct mwifiex_types_power_group
-				 *) ((unsigned long)
-				     data_buf +
+			pg_tlv = (struct mwifiex_types_power_group
+				  *) ((unsigned long) data_buf +
 				     sizeof(struct host_cmd_ds_txpwr_cfg));
 			memmove(cmd_txp_cfg, data_buf,
 				sizeof(struct host_cmd_ds_txpwr_cfg) +
 				sizeof(struct mwifiex_types_power_group) +
 				pg_tlv->length);
 
-			pg_tlv =
-				(struct mwifiex_types_power_group *) ((u8 *)
-						cmd_txp_cfg +
-						sizeof
-						(struct
-						 host_cmd_ds_txpwr_cfg));
+			pg_tlv = (struct mwifiex_types_power_group *) ((u8 *)
+				  cmd_txp_cfg +
+				  sizeof(struct host_cmd_ds_txpwr_cfg));
 			cmd->size = cpu_to_le16(le16_to_cpu(cmd->size) +
-			sizeof(struct mwifiex_types_power_group) +
-			pg_tlv->length);
+				  sizeof(struct mwifiex_types_power_group) +
+				  pg_tlv->length);
 		} else {
 			memmove(cmd_txp_cfg, data_buf,
 				sizeof(struct host_cmd_ds_txpwr_cfg));
@@ -363,14 +350,11 @@ static int mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 		memcpy(((u8 *) hs_cfg) +
 		       sizeof(struct host_cmd_ds_802_11_hs_cfg_enh),
 		       adapter->arp_filter, adapter->arp_filter_size);
-		cmd->size =
-			cpu_to_le16(adapter->arp_filter_size +
+		cmd->size = cpu_to_le16(adapter->arp_filter_size +
 				    sizeof(struct host_cmd_ds_802_11_hs_cfg_enh)
 				    + S_DS_GEN);
 	} else {
-		cmd->size =
-			cpu_to_le16(S_DS_GEN +
-				    sizeof(struct
+		cmd->size = cpu_to_le16(S_DS_GEN + sizeof(struct
 					   host_cmd_ds_802_11_hs_cfg_enh));
 	}
 	if (hs_activate) {
@@ -378,10 +362,8 @@ static int mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 		hs_cfg->params.hs_activate.resp_ctrl = RESP_NEEDED;
 	} else {
 		hs_cfg->action = cpu_to_le16(HS_CONFIGURE);
-		hs_cfg->params.hs_config.conditions =
-			data_buf->conditions;
-		hs_cfg->params.hs_config.gpio =
-			data_buf->gpio;
+		hs_cfg->params.hs_config.conditions = data_buf->conditions;
+		hs_cfg->params.hs_config.gpio = data_buf->gpio;
 		hs_cfg->params.hs_config.gap = data_buf->gap;
 		dev_dbg(adapter->dev,
 			"cmd: HS_CFG_CMD: condition:0x%x gpio:0x%x gap:0x%x\n",
@@ -406,9 +388,8 @@ static int mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
 					  u16 cmd_action)
 {
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_MAC_ADDRESS);
-	cmd->size =
-		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_mac_address) +
-			    S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_mac_address) +
+				S_DS_GEN);
 	cmd->result = 0;
 
 	cmd->params.mac_addr.action = cpu_to_le16(cmd_action);
@@ -435,9 +416,8 @@ static int mwifiex_cmd_802_11_sleep_period(struct mwifiex_private *priv,
 		&cmd->params.sleep_pd;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SLEEP_PERIOD);
-	cmd->size =
-		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_sleep_period) +
-			    S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_sleep_period) +
+				S_DS_GEN);
 	if (cmd_action == HostCmd_ACT_GEN_SET)
 		cmd_sleep_pd->sleep_pd = cpu_to_le16(*(u16 *) data_buf);
 
@@ -462,9 +442,8 @@ static int mwifiex_cmd_mac_multicast_adr(struct mwifiex_private *priv,
 		(struct mwifiex_multicast_list *) data_buf;
 	struct host_cmd_ds_mac_multicast_adr *mcast_addr = &cmd->params.mc_addr;
 
-	cmd->size =
-		cpu_to_le16(sizeof(struct host_cmd_ds_mac_multicast_adr) +
-			    S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_mac_multicast_adr) +
+				S_DS_GEN);
 	cmd->command = cpu_to_le16(HostCmd_CMD_MAC_MULTICAST_ADR);
 
 	mcast_addr->action = cpu_to_le16(cmd_action);
@@ -491,9 +470,8 @@ static int mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_deauthenticate *deauth = &cmd->params.deauth;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_DEAUTHENTICATE);
-	cmd->size =
-		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_deauthenticate) +
-			    S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_deauthenticate)
+				+ S_DS_GEN);
 
 	/* Set AP MAC address */
 	memcpy(deauth->mac_addr, (u8 *) data_buf, MWIFIEX_MAC_ADDR_LENGTH);
@@ -573,9 +551,7 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 			*key_param_len += (u16) cur_key_param_len;
 			key_param_set =
 				(struct mwifiex_ie_type_key_param_set *)
-						((u8 *)
-						key_param_set
-						+
+						((u8 *)key_param_set +
 						cur_key_param_len);
 		} else if (!priv->wep_key[i].key_length) {
 			continue;
@@ -628,8 +604,7 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		ret = mwifiex_set_keyparamset_wep(priv,
 						  &key_material->key_param_set,
 						  &key_param_len);
-		cmd->size =
-			cpu_to_le16(key_param_len +
+		cmd->size = cpu_to_le16(key_param_len +
 				    sizeof(key_material->action) + S_DS_GEN);
 		return ret;
 	} else
@@ -668,19 +643,16 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		key_material->key_param_set.key_len =
 			cpu_to_le16(WAPI_KEY_LEN);
 		memcpy(&key_material->key_param_set.key[2],
-		       enc_key->key_material,
-		       enc_key->key_len);
+		       enc_key->key_material, enc_key->key_len);
 		memcpy(&key_material->key_param_set.key[2 + enc_key->key_len],
 		       enc_key->wapi_rxpn, WAPI_RXPN_LEN);
 		key_material->key_param_set.length =
 			cpu_to_le16(WAPI_KEY_LEN + KEYPARAMSET_FIXED_LEN);
 
-		key_param_len =
-			(WAPI_KEY_LEN + KEYPARAMSET_FIXED_LEN) +
-			sizeof(struct mwifiex_ie_types_header);
-		cmd->size =
-			cpu_to_le16(key_param_len +
-				    sizeof(key_material->action) + S_DS_GEN);
+		key_param_len = (WAPI_KEY_LEN + KEYPARAMSET_FIXED_LEN) +
+				 sizeof(struct mwifiex_ie_types_header);
+		cmd->size = cpu_to_le16(key_param_len +
+				sizeof(key_material->action) + S_DS_GEN);
 		return ret;
 	}
 	if (enc_key->key_len == WLAN_KEY_LEN_CCMP) {
@@ -728,12 +700,10 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 			cpu_to_le16((u16) enc_key->key_len +
 				    KEYPARAMSET_FIXED_LEN);
 
-		key_param_len =
-			(u16) (enc_key->key_len + KEYPARAMSET_FIXED_LEN) +
-			sizeof(struct mwifiex_ie_types_header);
+		key_param_len = (u16) (enc_key->key_len + KEYPARAMSET_FIXED_LEN)
+				      + sizeof(struct mwifiex_ie_types_header);
 
-		cmd->size =
-			cpu_to_le16(key_param_len +
+		cmd->size = cpu_to_le16(key_param_len +
 				    sizeof(key_material->action) + S_DS_GEN);
 	}
 
@@ -748,11 +718,10 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
  *      - Setting SSID, passphrase and cmd action
  *      - Ensuring correct endian-ness
  */
-static int mwifiex_cmd_802_11_supplicant_pmk(
-		struct mwifiex_private  *priv,
-		struct host_cmd_ds_command   *cmd,
-		u16 cmd_action,
-		void *pdata_buf)
+static int
+mwifiex_cmd_802_11_supplicant_pmk(struct mwifiex_private  *priv,
+				  struct host_cmd_ds_command *cmd,
+				  u16 cmd_action, void *pdata_buf)
 {
 	struct mwifiex_ie_types_pmk *ppmk_tlv = NULL;
 	struct mwifiex_ie_types_passphrase *ppassphrase_tlv = NULL;
@@ -902,20 +871,18 @@ int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11D_DOMAIN_INFO);
 	domain_info->action = cpu_to_le16(cmd_action);
 	if (cmd_action == HostCmd_ACT_GEN_GET) {
-		cmd->size = cpu_to_le16(sizeof(domain_info->action) +
-							S_DS_GEN);
+		cmd->size = cpu_to_le16(sizeof(domain_info->action) + S_DS_GEN);
 		return 0;
 	}
 
 	/* Set domain info fields */
 	domain->header.type = cpu_to_le16(WLAN_EID_COUNTRY);
-	memcpy(domain->country_code,
-			adapter->domain_reg.country_code,
+	memcpy(domain->country_code, adapter->domain_reg.country_code,
 			sizeof(domain->country_code));
 
 	domain->header.len = cpu_to_le16((no_of_triplet *
 				sizeof(struct ieee80211_country_ie_triplet)) +
-			sizeof(domain->country_code));
+				sizeof(domain->country_code));
 
 	if (no_of_triplet) {
 		memcpy(domain->triplet, adapter->domain_reg.triplet,
@@ -927,8 +894,7 @@ int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 				sizeof(struct mwifiex_ie_types_header)
 				+ S_DS_GEN);
 	} else {
-		cmd->size = cpu_to_le16(sizeof(domain_info->action) +
-				S_DS_GEN);
+		cmd->size = cpu_to_le16(sizeof(domain_info->action) + S_DS_GEN);
 	}
 
 	return 0;
@@ -961,8 +927,7 @@ static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
 				cpu_to_le16(HostCmd_SCAN_RADIO_TYPE_A);
 
 		rf_type = le16_to_cpu(rf_chan->rf_type);
-		SET_SECONDARYCHAN(rf_type,
-				  priv->adapter->chan_offset);
+		SET_SECONDARYCHAN(rf_type, priv->adapter->chan_offset);
 		rf_chan->current_channel = cpu_to_le16(*((u16 *) data_buf));
 	}
 	rf_chan->action = cpu_to_le16(cmd_action);
@@ -984,9 +949,8 @@ static int mwifiex_cmd_802_11_rf_antenna(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_rf_antenna *antenna = &cmd->params.antenna;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_RF_ANTENNA);
-	cmd->size =
-		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_rf_antenna) +
-			    S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_rf_antenna) +
+				S_DS_GEN);
 
 	if (cmd_action == HostCmd_ACT_GEN_SET) {
 		antenna->action = cpu_to_le16(HostCmd_ACT_SET_BOTH);
@@ -1015,9 +979,8 @@ static int mwifiex_cmd_ibss_coalescing_status(struct mwifiex_private *priv,
 	u16 enable = 0;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_IBSS_COALESCING_STATUS);
-	cmd->size =
-		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_ibss_status) +
-			    S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_ibss_status) +
+				S_DS_GEN);
 	cmd->result = 0;
 	ibss_coal->action = cpu_to_le16(cmd_action);
 
@@ -1064,13 +1027,11 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 	case HostCmd_CMD_MAC_REG_ACCESS:
 		{
 			struct host_cmd_ds_mac_reg_access *mac_reg;
-			cmd->size =
-				cpu_to_le16(sizeof
+			cmd->size = cpu_to_le16(sizeof
 					    (struct host_cmd_ds_mac_reg_access)
 					    + S_DS_GEN);
-			mac_reg =
-				(struct host_cmd_ds_mac_reg_access *) &cmd->
-				params.mac_reg;
+			mac_reg = (struct host_cmd_ds_mac_reg_access *) &cmd->
+					params.mac_reg;
 			mac_reg->action = cpu_to_le16(cmd_action);
 			mac_reg->offset =
 				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
@@ -1080,13 +1041,11 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 	case HostCmd_CMD_BBP_REG_ACCESS:
 		{
 			struct host_cmd_ds_bbp_reg_access *bbp_reg;
-			cmd->size =
-				cpu_to_le16(sizeof
+			cmd->size = cpu_to_le16(sizeof
 					    (struct host_cmd_ds_bbp_reg_access)
 					    + S_DS_GEN);
-			bbp_reg =
-				(struct host_cmd_ds_bbp_reg_access *) &cmd->
-				params.bbp_reg;
+			bbp_reg = (struct host_cmd_ds_bbp_reg_access *) &cmd->
+					params.bbp_reg;
 			bbp_reg->action = cpu_to_le16(cmd_action);
 			bbp_reg->offset =
 				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
@@ -1096,8 +1055,7 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 	case HostCmd_CMD_RF_REG_ACCESS:
 		{
 			struct host_cmd_ds_rf_reg_access *rf_reg;
-			cmd->size =
-				cpu_to_le16(sizeof
+			cmd->size = cpu_to_le16(sizeof
 					    (struct host_cmd_ds_rf_reg_access) +
 					    S_DS_GEN);
 			rf_reg = (struct host_cmd_ds_rf_reg_access *) &cmd->
@@ -1111,13 +1069,11 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 	case HostCmd_CMD_PMIC_REG_ACCESS:
 		{
 			struct host_cmd_ds_pmic_reg_access *pmic_reg;
-			cmd->size =
-				cpu_to_le16(sizeof
+			cmd->size = cpu_to_le16(sizeof
 					    (struct host_cmd_ds_pmic_reg_access)
 					    + S_DS_GEN);
-			pmic_reg =
-				(struct host_cmd_ds_pmic_reg_access *) &cmd->
-				params.pmic_reg;
+			pmic_reg = (struct host_cmd_ds_pmic_reg_access *) &cmd->
+					params.pmic_reg;
 			pmic_reg->action = cpu_to_le16(cmd_action);
 			pmic_reg->offset =
 				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
@@ -1127,13 +1083,11 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 	case HostCmd_CMD_CAU_REG_ACCESS:
 		{
 			struct host_cmd_ds_rf_reg_access *cau_reg;
-			cmd->size =
-				cpu_to_le16(sizeof
+			cmd->size = cpu_to_le16(sizeof
 					    (struct host_cmd_ds_rf_reg_access) +
 					    S_DS_GEN);
-			cau_reg =
-				(struct host_cmd_ds_rf_reg_access *) &cmd->
-				params.rf_reg;
+			cau_reg = (struct host_cmd_ds_rf_reg_access *) &cmd->
+					params.rf_reg;
 			cau_reg->action = cpu_to_le16(cmd_action);
 			cau_reg->offset =
 				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
@@ -1147,8 +1101,7 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 			struct host_cmd_ds_802_11_eeprom_access *cmd_eeprom =
 				(struct host_cmd_ds_802_11_eeprom_access *)
 				&cmd->params.eeprom;
-			cmd->size =
-				cpu_to_le16(sizeof
+			cmd->size = cpu_to_le16(sizeof
 					    (struct
 					     host_cmd_ds_802_11_eeprom_access) +
 					    S_DS_GEN);
@@ -1307,8 +1260,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		break;
 	case HostCmd_CMD_SUPPLICANT_PMK:
 		ret = mwifiex_cmd_802_11_supplicant_pmk(priv, cmd_ptr,
-						cmd_action,
-						data_buf);
+						cmd_action, data_buf);
 		break;
 	case HostCmd_CMD_SUPPLICANT_PROFILE:
 		ret = mwifiex_cmd_802_11_supplicant_profile(priv, cmd_ptr,
@@ -1411,8 +1363,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 			return -1;
 
 		/* Reconfigure tx buf size */
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_RECONFIGURE_TX_BUFF,
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_RECONFIGURE_TX_BUFF,
 					  HostCmd_ACT_GEN_SET, 0, NULL,
 					  &priv->adapter->tx_buf_size);
 		if (ret)
@@ -1420,8 +1371,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 
 		/* Enable IEEE PS by default */
 		priv->adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_802_11_PS_MODE_ENH,
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
 					  EN_AUTO_PS, BITMAP_STA_PS, NULL,
 					  NULL);
 		if (ret)
@@ -1429,16 +1379,14 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	}
 
 	/* get tx rate */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_TX_RATE_CFG,
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
 				  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
 	if (ret)
 		return -1;
 	priv->data_rate = 0;
 
 	/* get tx power */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_TXPWR_CFG,
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TXPWR_CFG,
 				  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
 	if (ret)
 		return -1;
@@ -1480,9 +1428,9 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 
 	/* Send cmd to FW to enable/disable 11D function */
 	state_11d = ENABLE_11D;
-	ret = mwifiex_prepare_cmd(priv,
-			HostCmd_CMD_802_11_SNMP_MIB,
-			HostCmd_ACT_GEN_SET, DOT11D_I, NULL, &state_11d);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				  HostCmd_ACT_GEN_SET, DOT11D_I,
+				  NULL, &state_11d);
 	if (ret)
 		dev_err(priv->adapter->dev, "11D: failed to enable 11D\n");
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 50788bb..60b039c 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -296,9 +296,8 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 	u32 i;
 	int ret = 0;
 
-	tlv_buf =
-		(u8 *) ((u8 *) rate_cfg) +
-		sizeof(struct host_cmd_ds_tx_rate_cfg);
+	tlv_buf = (u8 *) ((u8 *) rate_cfg) +
+			sizeof(struct host_cmd_ds_tx_rate_cfg);
 	tlv_buf_len = *(u16 *) (tlv_buf + sizeof(u16));
 
 	while (tlv_buf && tlv_buf_len > 0) {
@@ -386,12 +385,9 @@ static int mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
 	if (data_buf) {
 		pg_tlv_hdr =
 			(struct mwifiex_types_power_group *) ((u8 *) data_buf
-					+
-					sizeof(struct
-						host_cmd_ds_txpwr_cfg));
+					+ sizeof(struct host_cmd_ds_txpwr_cfg));
 		pg = (struct mwifiex_power_group *) ((u8 *) pg_tlv_hdr +
-				sizeof(struct
-					mwifiex_types_power_group));
+				sizeof(struct mwifiex_types_power_group));
 		length = pg_tlv_hdr->length;
 		if (length > 0) {
 			max_power = pg->power_max;
@@ -928,8 +924,7 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
  * The register value and offset are returned to the user. For EEPROM
  * access, the byte count is also returned.
  */
-static int mwifiex_ret_reg_access(u16 type,
-				  struct host_cmd_ds_command *resp,
+static int mwifiex_ret_reg_access(u16 type, struct host_cmd_ds_command *resp,
 				  void *data_buf)
 {
 	struct mwifiex_ds_reg_rw *reg_rw = NULL;
@@ -944,8 +939,7 @@ static int mwifiex_ret_reg_access(u16 type,
 				struct host_cmd_ds_mac_reg_access *reg;
 				reg = (struct host_cmd_ds_mac_reg_access *)
 					&resp->params.mac_reg;
-				reg_rw->offset =
-					cpu_to_le32(
+				reg_rw->offset = cpu_to_le32(
 					(u32) le16_to_cpu(reg->offset));
 				reg_rw->value = reg->value;
 				break;
@@ -955,8 +949,7 @@ static int mwifiex_ret_reg_access(u16 type,
 				struct host_cmd_ds_bbp_reg_access *reg;
 				reg = (struct host_cmd_ds_bbp_reg_access *)
 					&resp->params.bbp_reg;
-				reg_rw->offset =
-					cpu_to_le32(
+				reg_rw->offset = cpu_to_le32(
 					(u32) le16_to_cpu(reg->offset));
 				reg_rw->value = cpu_to_le32((u32) reg->value);
 				break;
@@ -967,8 +960,7 @@ static int mwifiex_ret_reg_access(u16 type,
 				struct host_cmd_ds_rf_reg_access *reg;
 				reg = (struct host_cmd_ds_rf_reg_access *)
 					&resp->params.rf_reg;
-				reg_rw->offset =
-					cpu_to_le32(
+				reg_rw->offset = cpu_to_le32(
 					(u32) le16_to_cpu(reg->offset));
 				reg_rw->value = cpu_to_le32((u32) reg->value);
 				break;
@@ -978,8 +970,7 @@ static int mwifiex_ret_reg_access(u16 type,
 				struct host_cmd_ds_pmic_reg_access *reg;
 				reg = (struct host_cmd_ds_pmic_reg_access *)
 					&resp->params.pmic_reg;
-				reg_rw->offset =
-					cpu_to_le32(
+				reg_rw->offset = cpu_to_le32(
 					(u32) le16_to_cpu(reg->offset));
 				reg_rw->value = cpu_to_le32((u32) reg->value);
 				break;
@@ -989,8 +980,7 @@ static int mwifiex_ret_reg_access(u16 type,
 				struct host_cmd_ds_rf_reg_access *reg;
 				reg = (struct host_cmd_ds_rf_reg_access *)
 					&resp->params.rf_reg;
-				reg_rw->offset =
-					cpu_to_le32(
+				reg_rw->offset = cpu_to_le32(
 					(u32) le16_to_cpu(reg->offset));
 				reg_rw->value = cpu_to_le32((u32) reg->value);
 				break;
@@ -1067,8 +1057,7 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 			= le16_to_cpu(ibss_coal_resp->atim_window);
 
 		/* ERP Information */
-		priv->curr_bss_params.bss_descriptor.erp_flags
-			=
+		priv->curr_bss_params.bss_descriptor.erp_flags =
 			(u8) le16_to_cpu(ibss_coal_resp->use_g_rate_protect);
 
 		priv->adhoc_state = ADHOC_COALESCED;
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index bdea2fc..e41c947 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -274,8 +274,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_HS_ACT_REQ:
 		dev_dbg(adapter->dev, "event: HS_ACT_REQ\n");
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_802_11_HS_CFG_ENH,
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_HS_CFG_ENH,
 					  0, 0, NULL, NULL);
 		break;
 
@@ -319,7 +318,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 	case EVENT_WMM_STATUS_CHANGE:
 		dev_dbg(adapter->dev, "event: WMM status changed\n");
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_WMM_GET_STATUS,
-				0, 0, NULL, NULL);
+					  0, 0, NULL, NULL);
 		break;
 
 	case EVENT_RSSI_LOW:
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index dd926f3..4fdf28c 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -838,9 +838,8 @@ int mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
 		"info: old_pkt_filter=%#x, curr_pkt_filter=%#x\n",
 	       old_pkt_filter, priv->curr_pkt_filter);
 	if (old_pkt_filter != priv->curr_pkt_filter) {
-		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
-					  action, 0, wait,
-					  &priv->curr_pkt_filter);
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL, action,
+					  0, wait, &priv->curr_pkt_filter);
 		if (!ret)
 			ret = -EINPROGRESS;
 	}
@@ -889,10 +888,8 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 							(u16) chan->channel);
 		if (!cfp) {
 			cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211
-								(priv,
-								BAND_A,
-								(u16) chan->
-								channel);
+							(priv, BAND_A,
+							(u16) chan->channel);
 			if (cfp) {
 				if (adapter->adhoc_11n_enabled)
 					adapter->adhoc_start_band =
@@ -907,9 +904,7 @@ int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 							priv, 0, chan->freq);
 		if (!cfp) {
 			cfp = mwifiex_get_cfp_by_band_and_freq_from_cfg80211
-								(priv,
-								BAND_A,
-								chan->freq);
+						  (priv, BAND_A, chan->freq);
 			if (cfp) {
 				if (adapter->adhoc_11n_enabled)
 					adapter->adhoc_start_band =
@@ -1144,8 +1139,7 @@ int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 		memcpy(&ssid_bssid->ssid, &bss_desc->ssid,
 				sizeof(struct mwifiex_802_11_ssid));
 	} else if (ssid_bssid->ssid.ssid_len) {
-		i = mwifiex_find_ssid_in_list(priv,
-					      &ssid_bssid->ssid, NULL,
+		i = mwifiex_find_ssid_in_list(priv, &ssid_bssid->ssid, NULL,
 					      priv->bss_mode);
 		if (i < 0) {
 			dev_err(adapter->dev, "cannot find ssid %s\n",
@@ -1406,9 +1400,8 @@ static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 			rate_index -= 1; /* There is a 0x00 in the table */
 			if (rate_index >= MWIFIEX_RATE_INDEX_OFDM0 &&
 			    rate_index <= MWIFIEX_RATE_INDEX_OFDM7)
-				bitmap_rates[1] =
-					1 << (rate_index -
-					      MWIFIEX_RATE_INDEX_OFDM0);
+				bitmap_rates[1] = 1 << (rate_index -
+						   MWIFIEX_RATE_INDEX_OFDM0);
 		}
 	}
 
@@ -1588,17 +1581,12 @@ int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
 	if (!power_cfg->is_power_auto) {
 		txp_cfg->mode = cpu_to_le32(1);
 		pg_tlv = (struct mwifiex_types_power_group *) (buf +
-				sizeof
-				(struct
-				 host_cmd_ds_txpwr_cfg));
+				sizeof(struct host_cmd_ds_txpwr_cfg));
 		pg_tlv->type = TLV_TYPE_POWER_GROUP;
 		pg_tlv->length = 4 * sizeof(struct mwifiex_power_group);
 		pg = (struct mwifiex_power_group *) (buf +
-				sizeof(struct
-					host_cmd_ds_txpwr_cfg)
-				+
-				sizeof(struct
-					mwifiex_types_power_group));
+				sizeof(struct host_cmd_ds_txpwr_cfg) +
+				sizeof(struct mwifiex_types_power_group));
 		/* Power group for modulation class HR/DSSS */
 		pg->first_rate_code = 0x00;
 		pg->last_rate_code = 0x03;
@@ -1651,8 +1639,7 @@ int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
  */
 int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
 			     struct mwifiex_wait_queue *wait,
-			     u32 *ps_mode,
-			     u16 action)
+			     u32 *ps_mode, u16 action)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -1715,10 +1702,8 @@ int mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
 						cpu_to_le32(hs_cfg->conditions);
 			} else if (hs_cfg->conditions) {
 				adapter->hs_cfg.conditions =
-						cpu_to_le32(
-						hs_cfg->conditions);
-				adapter->hs_cfg.gpio =
-						(u8)hs_cfg->gpio;
+						cpu_to_le32(hs_cfg->conditions);
+				adapter->hs_cfg.gpio = (u8)hs_cfg->gpio;
 				if (hs_cfg->gap)
 					adapter->hs_cfg.gap = (u8)hs_cfg->gap;
 			} else if (adapter->hs_cfg.conditions ==
@@ -1942,8 +1927,7 @@ int mwifiex_set_auth_mode(struct mwifiex_private *priv, u32 auth_mode)
 	int ret = 0;
 
 	priv->sec_info.authentication_mode = auth_mode;
-	if (priv->sec_info.authentication_mode ==
-			MWIFIEX_AUTH_MODE_NETWORKEAP)
+	if (priv->sec_info.authentication_mode == MWIFIEX_AUTH_MODE_NETWORKEAP)
 		ret = mwifiex_set_wpa_ie_helper(priv, NULL, 0);
 
 	return ret;
@@ -2004,8 +1988,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 	}
 	if (wep_key->key_length) {
 		/* Send request to firmware */
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_802_11_KEY_MATERIAL,
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
 					  HostCmd_ACT_GEN_SET, 0, NULL, NULL);
 		if (ret)
 			return ret;
@@ -2057,10 +2040,8 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 		 */
 		/* Send the key as PTK to firmware */
 		encrypt_key->key_index = MWIFIEX_KEY_INDEX_UNICAST;
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_802_11_KEY_MATERIAL,
-					  HostCmd_ACT_GEN_SET,
-					  KEY_INFO_ENABLED,
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+					  HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
 					  NULL, encrypt_key);
 		if (ret)
 			return ret;
@@ -2069,11 +2050,9 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 		memset(ibss_key, 0,
 		       sizeof(struct host_cmd_ds_802_11_key_material));
 		/* Copy the key in the driver */
-		memcpy(ibss_key->key_param_set.key,
-		       encrypt_key->key_material,
+		memcpy(ibss_key->key_param_set.key, encrypt_key->key_material,
 		       encrypt_key->key_len);
-		memcpy(&ibss_key->key_param_set.key_len,
-		       &encrypt_key->key_len,
+		memcpy(&ibss_key->key_param_set.key_len, &encrypt_key->key_len,
 		       sizeof(ibss_key->key_param_set.key_len));
 		ibss_key->key_param_set.key_type_id
 			= cpu_to_le16(KEY_TYPE_ID_TKIP);
@@ -2150,8 +2129,7 @@ static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 			       priv->aes_key.key_param_set.key,
 			       le16_to_cpu(
 			       priv->aes_key.key_param_set.key_len));
-			encrypt_key->key_len =
-				le16_to_cpu(
+			encrypt_key->key_len = le16_to_cpu(
 				priv->aes_key.key_param_set.key_len);
 		} else {
 			encrypt_key->key_disable = true;
@@ -2159,13 +2137,11 @@ static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 	} else {
 		index = encrypt_key->key_index;
 		if (priv->wep_key[index].key_length) {
-			encrypt_key->key_index =
-				priv->wep_key[index].key_index;
+			encrypt_key->key_index = priv->wep_key[index].key_index;
 			memcpy(encrypt_key->key_material,
 			       priv->wep_key[index].key_material,
 			       priv->wep_key[index].key_length);
-			encrypt_key->key_len =
-				priv->wep_key[index].key_length;
+			encrypt_key->key_len = priv->wep_key[index].key_length;
 		} else if ((priv->sec_info.wpa_enabled)
 			   || (priv->sec_info.ewpa_enabled)
 			   || (priv->sec_info.wpa2_enabled)
@@ -3302,9 +3278,8 @@ mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_idx)
 		   , there is a hole in rate table
 		   between HR/DSSS and OFDM rates, so
 		   minus 1 for OFDM rate index */
-		rate_cfg.rate =
-			(priv->tx_rate > MWIFIEX_RATE_INDEX_OFDM0)
-			? priv->tx_rate - 1 : priv->tx_rate;
+		rate_cfg.rate = (priv->tx_rate > MWIFIEX_RATE_INDEX_OFDM0)
+				 ? priv->tx_rate - 1 : priv->tx_rate;
 
 	if (priv->is_data_rate_auto)
 		*tx_rate_idx = AUTO_RATE;
@@ -3616,8 +3591,7 @@ int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 			gen_ie->len = priv->wpa_ie_len;
 			memcpy(gen_ie->ie_data, priv->wpa_ie, gen_ie->len);
 		} else {
-			mwifiex_set_gen_ie_helper(priv,
-						  gen_ie->ie_data,
+			mwifiex_set_gen_ie_helper(priv, gen_ie->ie_data,
 						  (u16) gen_ie->len);
 		}
 		break;
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index f57c481..f645d52 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -54,9 +54,8 @@ int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 
 	local_rx_pd = (struct rxpd *) (skb->data);
 
-	rx_pkt_hdr =
-		(struct rx_packet_hdr *) ((u8 *) local_rx_pd +
-					local_rx_pd->rx_pkt_offset);
+	rx_pkt_hdr = (struct rx_packet_hdr *) ((u8 *) local_rx_pd +
+				local_rx_pd->rx_pkt_offset);
 
 	if (!memcmp(&rx_pkt_hdr->rfc1042_hdr,
 		    rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr))) {
@@ -132,8 +131,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 	local_rx_pd = (struct rxpd *) (skb->data);
 	rx_pkt_type = local_rx_pd->rx_pkt_type;
 
-	rx_pkt_hdr =
-		(struct rx_packet_hdr *) ((u8 *) local_rx_pd +
+	rx_pkt_hdr = (struct rx_packet_hdr *) ((u8 *) local_rx_pd +
 					local_rx_pd->rx_pkt_offset);
 
 	if ((local_rx_pd->rx_pkt_offset + local_rx_pd->rx_pkt_length) >
@@ -167,8 +165,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 		if (rx_pkt_type != PKT_TYPE_BAR)
 			priv->rx_seq[local_rx_pd->priority] =
 						local_rx_pd->seq_num;
-		memcpy(ta,
-		       priv->curr_bss_params.bss_descriptor.mac_address,
+		memcpy(ta, priv->curr_bss_params.bss_descriptor.mac_address,
 		       MWIFIEX_MAC_ADDR_LENGTH);
 	}
 
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index f819928..08710bb 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -42,8 +42,7 @@
  *      - Priority specific Tx control
  *      - Flags
  */
-void *
-mwifiex_process_sta_txpd(struct mwifiex_private *priv,
+void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 				struct sk_buff *skb)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -77,8 +76,7 @@ mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 		 * Set the priority specific tx_control field, setting of 0 will
 		 *   cause the default value to be used later in this function
 		 */
-		local_tx_pd->tx_control
-			=
+		local_tx_pd->tx_control =
 			cpu_to_le32(priv->wmm.user_pri_pkt_tx_ctrl[local_tx_pd->
 							 priority]);
 
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index f10b90c..a7835ff 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -46,8 +46,7 @@ int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 	local_rx_pd = (struct rxpd *) (skb->data);
 	/* Get the BSS number from rxpd, get corresponding priv */
 	priv = mwifiex_get_priv_by_id(adapter, local_rx_pd->bss_num &
-				      BSS_NUM_MASK,
-				      local_rx_pd->bss_type);
+				      BSS_NUM_MASK, local_rx_pd->bss_type);
 	if (!priv)
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
@@ -123,8 +122,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
  * wakes up stalled traffic queue if required, and then frees the buffer.
  */
 int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
-				struct sk_buff *skb,
-				int status)
+				struct sk_buff *skb, int status)
 {
 	struct mwifiex_private *priv = NULL, *tpriv = NULL;
 	struct mwifiex_txinfo *tx_info = NULL;
@@ -153,7 +151,6 @@ int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 
 		if ((GET_BSS_ROLE(tpriv) == MWIFIEX_BSS_ROLE_STA)
 				&& (tpriv->media_connected)) {
-
 			if (netif_queue_stopped(tpriv->netdev))
 				netif_wake_queue(tpriv->netdev);
 		}
@@ -172,8 +169,7 @@ done:
  * use count before freeing the received packet.
  */
 int mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
-				 struct sk_buff *skb,
-				 int status)
+				 struct sk_buff *skb, int status)
 {
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct mwifiex_rxinfo *rx_info_parent = NULL;
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index fbd3238..892c21c 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -135,19 +135,15 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 		info->num_cmd_timeout = adapter->dbg.num_cmd_timeout;
 		info->timeout_cmd_id = adapter->dbg.timeout_cmd_id;
 		info->timeout_cmd_act = adapter->dbg.timeout_cmd_act;
-		memcpy(info->last_cmd_id,
-		       adapter->dbg.last_cmd_id,
+		memcpy(info->last_cmd_id, adapter->dbg.last_cmd_id,
 		       sizeof(adapter->dbg.last_cmd_id));
-		memcpy(info->last_cmd_act,
-		       adapter->dbg.last_cmd_act,
+		memcpy(info->last_cmd_act, adapter->dbg.last_cmd_act,
 		       sizeof(adapter->dbg.last_cmd_act));
 		info->last_cmd_index = adapter->dbg.last_cmd_index;
-		memcpy(info->last_cmd_resp_id,
-		       adapter->dbg.last_cmd_resp_id,
+		memcpy(info->last_cmd_resp_id, adapter->dbg.last_cmd_resp_id,
 		       sizeof(adapter->dbg.last_cmd_resp_id));
 		info->last_cmd_resp_index = adapter->dbg.last_cmd_resp_index;
-		memcpy(info->last_event,
-		       adapter->dbg.last_event,
+		memcpy(info->last_event, adapter->dbg.last_event,
 		       sizeof(adapter->dbg.last_event));
 		info->last_event_index = adapter->dbg.last_event_index;
 		info->data_sent = adapter->data_sent;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 6ef2a9b..947aa6b 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -246,8 +246,7 @@ mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 	for (num_ac = 0; num_ac < ARRAY_SIZE(wmm_ie->ac_params); num_ac++) {
 		cw_min = (1 << (wmm_ie->ac_params[num_ac].ecw_bitmap &
 			MWIFIEX_ECW_MIN)) - 1;
-		avg_back_off =
-			(cw_min >> 1) +
+		avg_back_off = (cw_min >> 1) +
 			(wmm_ie->ac_params[num_ac].aci_aifsn_bitmap &
 			MWIFIEX_AIFSN);
 
@@ -344,12 +343,9 @@ mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv)
 		for (ac_val = WMM_AC_BK; ac_val <= WMM_AC_VO; ac_val++) {
 			priv->wmm.ac_down_graded_vals[ac_val]
 				= mwifiex_wmm_eval_downgrade_ac(priv,
-							(enum
-							 mwifiex_wmm_ac_e)
-							ac_val);
+						(enum mwifiex_wmm_ac_e) ac_val);
 			dev_dbg(priv->adapter->dev, "info: WMM: AC PRIO %d maps to %d\n",
-				ac_val,
-			       priv->wmm.ac_down_graded_vals[ac_val]);
+				ac_val, priv->wmm.ac_down_graded_vals[ac_val]);
 		}
 	}
 }
@@ -458,10 +454,7 @@ mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter)
 		if (priv) {
 			for (i = 0; i < MAX_NUM_TID; i++)
 				if (!mwifiex_wmm_is_ra_list_empty(adapter,
-								  &priv->wmm.
-								  tid_tbl_ptr
-								  [i].
-								  ra_list))
+					     &priv->wmm.tid_tbl_ptr[i].ra_list))
 					return false;
 		}
 	}
@@ -513,9 +506,8 @@ mwifiex_wmm_cleanup_queues(struct mwifiex_private *priv)
 	int i;
 
 	for (i = 0; i < MAX_NUM_TID; i++)
-		mwifiex_wmm_del_pkts_in_ralist(priv,
-					       &priv->wmm.tid_tbl_ptr[i].
-					       ra_list);
+		mwifiex_wmm_del_pkts_in_ralist(priv, &priv->wmm.tid_tbl_ptr[i].
+						     ra_list);
 }
 
 /*
@@ -569,8 +561,7 @@ mwifiex_wmm_get_ralist_node(struct mwifiex_private *priv, u8 tid,
  * retrieved.
  */
 static struct mwifiex_ra_list_tbl *
-mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid,
-			    u8 *ra_addr)
+mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid, u8 *ra_addr)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 
@@ -705,9 +696,8 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 			       tlv_wmm_qstatus->flow_required,
 			       tlv_wmm_qstatus->disabled);
 
-			ac_status =
-				&priv->wmm.ac_status[tlv_wmm_qstatus->
-						     queue_index];
+			ac_status = &priv->wmm.ac_status[tlv_wmm_qstatus->
+							 queue_index];
 			ac_status->disabled = tlv_wmm_qstatus->disabled;
 			ac_status->flow_required =
 				tlv_wmm_qstatus->flow_required;
@@ -881,8 +871,7 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 						 list);
 			bssprio_head = bssprio_node;
 		} else {
-			bssprio_node =
-				adapter->bss_prio_tbl[j].bss_prio_cur;
+			bssprio_node = adapter->bss_prio_tbl[j].bss_prio_cur;
 			bssprio_head = bssprio_node;
 		}
 
@@ -891,8 +880,7 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 
 			for (i = HIGH_PRIO_TID; i >= LOW_PRIO_TID; --i) {
 
-				tid_ptr =
-					&(priv_tmp)->wmm.
+				tid_ptr = &(priv_tmp)->wmm.
 					tid_tbl_ptr[tos_to_tid[i]];
 
 				spin_lock_irqsave(&tid_ptr->tid_tbl_lock,
@@ -1022,9 +1010,8 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
-	tx_param.next_pkt_len =
-		((skb_next) ? skb_next->len +
-		 sizeof(struct txpd) : 0);
+	tx_param.next_pkt_len = ((skb_next) ? skb_next->len +
+				sizeof(struct txpd) : 0);
 
 	status = mwifiex_process_tx(priv, skb, &tx_param);
 
@@ -1033,9 +1020,8 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-			spin_unlock_irqrestore(
-					&priv->wmm.ra_list_spinlock,
-					ra_list_flags);
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       ra_list_flags);
 			mwifiex_write_data_complete(adapter, skb, -1);
 			return;
 		}
@@ -1050,8 +1036,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 		if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
 			priv->wmm.packets_out[ptr_index]++;
-			priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr =
-				ptr;
+			priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr = ptr;
 		}
 		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
 			list_first_entry(
@@ -1122,19 +1107,16 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 	tx_param.next_pkt_len =
 		((skb_next) ? skb_next->len +
 		 sizeof(struct txpd) : 0);
-	ret = adapter->if_ops.host_to_card(adapter,
-					     MWIFIEX_TYPE_DATA,
-					     skb->data, skb->len,
-					     &tx_param);
+	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
+					   skb->data, skb->len, &tx_param);
 	switch (ret) {
 	case -EBUSY:
 		dev_dbg(adapter->dev, "data: -EBUSY is returned\n");
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-			spin_unlock_irqrestore(
-					&priv->wmm.ra_list_spinlock,
-					ra_list_flags);
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       ra_list_flags);
 			mwifiex_write_data_complete(adapter, skb, -1);
 			return;
 		}
@@ -1160,8 +1142,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 		if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
 			priv->wmm.packets_out[ptr_index]++;
-			priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr =
-				ptr;
+			priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr = ptr;
 		}
 		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
 			list_first_entry(
@@ -1188,8 +1169,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 	int tid_del = 0, tid = 0;
 	unsigned long flags;
 
-	ptr = mwifiex_wmm_get_highest_priolist_ptr(adapter, &priv,
-							&ptr_index);
+	ptr = mwifiex_wmm_get_highest_priolist_ptr(adapter, &priv, &ptr_index);
 	if (!ptr)
 		return -1;
 
@@ -1222,15 +1202,13 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		if (mwifiex_is_ampdu_allowed(priv, ptr, tid)) {
 			if (mwifiex_is_ba_stream_avail(priv)) {
 				mwifiex_11n_create_tx_ba_stream_tbl(priv,
-						ptr->ra,
-						tid,
+						ptr->ra, tid,
 						BA_STREAM_SETUP_INPROGRESS);
 				mwifiex_send_addba(priv, tid, ptr->ra);
 			} else if (mwifiex_find_stream_to_delete
 				   (priv, ptr, tid, &tid_del, ra)) {
 				mwifiex_11n_create_tx_ba_stream_tbl(priv,
-						ptr->ra,
-						tid,
+						ptr->ra, tid,
 						BA_STREAM_SETUP_INPROGRESS);
 				mwifiex_send_delba(priv, tid_del, ra, 1);
 			}
@@ -1238,8 +1216,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 /* Minimum number of AMSDU */
 #define MIN_NUM_AMSDU 2
 		if (mwifiex_is_amsdu_allowed(priv, ptr, tid) &&
-		    (mwifiex_num_pkts_in_txq(priv, ptr,
-					     adapter->tx_buf_size) >=
+		    (mwifiex_num_pkts_in_txq(priv, ptr, adapter->tx_buf_size) >=
 		     MIN_NUM_AMSDU))
 			mwifiex_11n_aggregate_pkt(priv, ptr, INTF_HEADER_LEN,
 						  ptr_index, flags);
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 24cc472..3a45f0f 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -41,8 +41,7 @@ mwifiex_get_tid(struct mwifiex_adapter *adapter,
  * This function gets the length of a list.
  */
 static inline int
-mwifiex_wmm_list_len(struct mwifiex_adapter *adapter,
-		     struct list_head *head)
+mwifiex_wmm_list_len(struct mwifiex_adapter *adapter, struct list_head *head)
 {
 	struct list_head *pos;
 	int count = 0;
-- 
1.7.0.2

