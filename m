Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46360 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1BSEKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 23:10:15 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove enum mwifiex_status
Date: Fri, 18 Feb 2011 20:12:29 -0800
Message-Id: <1298088749-8025-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

and use corresponding errno codes

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |  135 ++---
 drivers/net/wireless/mwifiex/11n.h           |   92 ++--
 drivers/net/wireless/mwifiex/11n_aggr.c      |   41 +-
 drivers/net/wireless/mwifiex/11n_aggr.h      |    4 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   53 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h |   32 +-
 drivers/net/wireless/mwifiex/cfg80211.c      |   92 ++--
 drivers/net/wireless/mwifiex/cmdevt.c        |  168 +++---
 drivers/net/wireless/mwifiex/decl.h          |    9 +-
 drivers/net/wireless/mwifiex/init.c          |   67 +--
 drivers/net/wireless/mwifiex/join.c          |  122 ++---
 drivers/net/wireless/mwifiex/main.c          |  110 ++--
 drivers/net/wireless/mwifiex/main.h          |  572 ++++++++-----------
 drivers/net/wireless/mwifiex/scan.c          |  159 +++---
 drivers/net/wireless/mwifiex/sdio.c          |  344 +++++-------
 drivers/net/wireless/mwifiex/sdio.h          |   15 +-
 drivers/net/wireless/mwifiex/sta_cmd.c       |  220 ++++----
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |  194 +++----
 drivers/net/wireless/mwifiex/sta_event.c     |   12 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  786 ++++++++++++--------------
 drivers/net/wireless/mwifiex/sta_rx.c        |   18 +-
 drivers/net/wireless/mwifiex/sta_tx.c        |   21 +-
 drivers/net/wireless/mwifiex/txrx.c          |   50 +-
 drivers/net/wireless/mwifiex/util.c          |   66 +--
 drivers/net/wireless/mwifiex/wmm.c           |   46 +-
 drivers/net/wireless/mwifiex/wmm.h           |    7 +-
 26 files changed, 1543 insertions(+), 1892 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index ee33e69..1ec734e 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -29,9 +29,8 @@
 /*
  * IOCTL request handler to set/get 11n HT capability.
  */
-enum mwifiex_status
-mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv, u16 action,
-			      int *htcap_cfg)
+int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv, u16 action,
+				  int *htcap_cfg)
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -62,13 +61,12 @@ mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv, u16 action,
  * This function prepares the correct firmware command and
  * issues it.
  */
-enum mwifiex_status
-mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
-				  struct mwifiex_wait_queue *wait_queue,
-				  struct mwifiex_ds_11n_amsdu_aggr_ctrl
-				  *amsdu_aggr_ctrl, u16 action)
+int mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
+				      struct mwifiex_wait_queue *wait_queue,
+				      struct mwifiex_ds_11n_amsdu_aggr_ctrl
+				      *amsdu_aggr_ctrl, u16 action)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
 
 	ENTER();
@@ -76,8 +74,8 @@ mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_AMSDU_AGGR_CTRL, action, 0,
 				  wait_queue, amsdu_aggr_ctrl);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 	LEAVE();
 	return ret;
@@ -89,21 +87,20 @@ mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
  * This function prepares the correct firmware command and
  * issues it.
  */
-enum mwifiex_status
-mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
-			  struct mwifiex_wait_queue *wait_queue,
-			  struct mwifiex_ds_11n_tx_cfg *tx_cfg,
-			  u16 action)
+int mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
+				struct mwifiex_wait_queue *wait_queue,
+				struct mwifiex_ds_11n_tx_cfg *tx_cfg,
+				u16 action)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
 
 	ENTER();
 
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_CFG, action, 0,
 				  wait_queue, tx_cfg);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 	LEAVE();
 	return ret;
@@ -117,13 +114,12 @@ mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
  *      - Rx window size
  *      - Tiemout value
  */
-enum mwifiex_status
-mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
-			      struct mwifiex_wait_queue *wait_queue,
-			      struct mwifiex_ds_11n_addba_param *addba_param,
-			      u16 action)
+int mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
+				  struct mwifiex_wait_queue *wait_queue,
+				  struct mwifiex_ds_11n_addba_param
+				  *addba_param, u16 action)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
 	u32 timeout;
 
@@ -156,12 +152,11 @@ mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
  *
  * The configuration can only be set in disconnected state.
  */
-enum mwifiex_status
-mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
-			     u16 action, int *addba_reject)
+int mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
+				 u16 action, int *addba_reject)
 {
 	int i = 0;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -175,13 +170,13 @@ mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
 			       "Can not set aggr priority table in connected"
 			       " state\n");
 			LEAVE();
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 
 		for (i = 0; i < MAX_NUM_TID; i++) {
 			/* For AMPDU */
 			if (addba_reject[i] > ADDBA_RSP_STATUS_REJECT) {
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 				break;
 			}
 
@@ -199,13 +194,12 @@ mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
  * The configuration can only be set in disconnected state.
  * Setting of both AMPDU and AMSDU priority tables are supported.
  */
-enum mwifiex_status
-mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
-				struct mwifiex_ds_11n_aggr_prio_tbl
-				*aggr_prio_tbl, u16 action)
+int mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
+				    struct mwifiex_ds_11n_aggr_prio_tbl
+				    *aggr_prio_tbl, u16 action)
 {
 	int i = 0;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -222,7 +216,7 @@ mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
 			       "Can not set aggr priority table in connected"
 			       " state\n");
 			LEAVE();
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 
 		for (i = 0; i < MAX_NUM_TID; i++) {
@@ -230,7 +224,7 @@ mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
 			if ((aggr_prio_tbl->ampdu[i] > HIGH_PRIO_TID)
 			    && (aggr_prio_tbl->ampdu[i] !=
 				BA_STREAM_NOT_ALLOWED)) {
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 				break;
 			}
 
@@ -242,7 +236,7 @@ mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
 			if ((aggr_prio_tbl->amsdu[i] > HIGH_PRIO_TID
 			     && aggr_prio_tbl->amsdu[i] !=
 			     BA_STREAM_NOT_ALLOWED)) {
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 				break;
 			} else {
 				priv->aggr_prio_tbl[i].amsdu =
@@ -485,9 +479,8 @@ mwifiex_show_dev_mcs_support(struct mwifiex_adapter *adapter, u8 support)
  * the deleted stream in case of failure, if the add BA was also
  * initiated by us).
  */
-enum mwifiex_status
-mwifiex_ret_11n_delba(struct mwifiex_private *priv,
-		      struct host_cmd_ds_command *resp)
+int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
+			  struct host_cmd_ds_command *resp)
 {
 	int tid;
 	struct mwifiex_tx_ba_stream_tbl *tx_ba_tbl;
@@ -531,7 +524,7 @@ mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -542,9 +535,8 @@ mwifiex_ret_11n_delba(struct mwifiex_private *priv,
  * the response success status and taking actions accordingly (delete the
  * BA stream table in case of failure).
  */
-enum mwifiex_status
-mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
-			  struct host_cmd_ds_command *resp)
+int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp)
 {
 	int tid;
 	struct host_cmd_ds_11n_addba_rsp *add_ba_rsp =
@@ -579,7 +571,7 @@ mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -587,10 +579,9 @@ mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
  *
  * Handling includes changing the header fields into CPU format.
  */
-enum mwifiex_status
-mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
-		    struct host_cmd_ds_command *resp,
-		    void *data_buf)
+int mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *resp,
+			void *data_buf)
 {
 	struct mwifiex_ds_11n_tx_cfg *tx_cfg = NULL;
 	struct host_cmd_ds_11n_cfg *htcfg = &resp->params.htcfg;
@@ -602,7 +593,7 @@ mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
 		tx_cfg->tx_htinfo = le16_to_cpu(htcfg->ht_tx_info);
 	}
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -613,10 +604,9 @@ mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
  *      - Setting Tx buffer size (for SET only)
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
-mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
-			 struct host_cmd_ds_command *cmd, int cmd_action,
-			 void *data_buf)
+int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
+			     struct host_cmd_ds_command *cmd, int cmd_action,
+			     void *data_buf)
 {
 	struct host_cmd_ds_txbuf_cfg *tx_buf = &cmd->params.tx_buf;
 	u16 action = (u16) cmd_action;
@@ -638,7 +628,7 @@ mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
 		break;
 	}
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -649,10 +639,9 @@ mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
  *      - Setting AMSDU control parameters (for SET only)
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
-mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
-			    struct host_cmd_ds_command *cmd,
-			    int cmd_action, void *data_buf)
+int mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *cmd,
+				int cmd_action, void *data_buf)
 {
 	struct host_cmd_ds_amsdu_aggr_ctrl *amsdu_ctrl =
 		&cmd->params.amsdu_aggr_ctrl;
@@ -677,7 +666,7 @@ mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
 		break;
 	}
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -686,10 +675,9 @@ mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
  *
  * Handling includes changing the header fields into CPU format.
  */
-enum mwifiex_status
-mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
-			    struct host_cmd_ds_command *resp,
-			    void *data_buf)
+int mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *resp,
+				void *data_buf)
 {
 	struct mwifiex_ds_11n_amsdu_aggr_ctrl *amsdu_aggr_ctrl = NULL;
 	struct host_cmd_ds_amsdu_aggr_ctrl *amsdu_ctrl =
@@ -705,7 +693,7 @@ mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
 			le16_to_cpu(amsdu_ctrl->curr_buf_size);
 	}
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -716,10 +704,9 @@ mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
  *      - Setting HT Tx capability and HT Tx information fields
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
-mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
-		    struct host_cmd_ds_command *cmd,
-		    u16 cmd_action, void *data_buf)
+int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *cmd,
+			u16 cmd_action, void *data_buf)
 {
 	struct host_cmd_ds_11n_cfg *htcfg = &cmd->params.htcfg;
 	struct mwifiex_ds_11n_tx_cfg *txcfg =
@@ -730,7 +717,7 @@ mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
 	htcfg->action = cpu_to_le16(cmd_action);
 	htcfg->ht_tx_cap = cpu_to_le16(txcfg->tx_htcap);
 	htcfg->ht_tx_info = cpu_to_le16(txcfg->tx_htinfo);
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1113,7 +1100,7 @@ mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 {
 	struct host_cmd_ds_11n_addba_req add_ba_req;
 	static u8 dialog_tok;
-	enum mwifiex_status ret;
+	int ret;
 
 	ENTER();
 
@@ -1151,7 +1138,7 @@ mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 		   int initiator)
 {
 	struct host_cmd_ds_11n_delba delba;
-	enum mwifiex_status ret;
+	int ret;
 	uint16_t del_ba_param_set;
 
 	ENTER();
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 9b919d5..57664ad 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -27,20 +27,20 @@
 void mwifiex_show_dot_11n_dev_cap(struct mwifiex_adapter *adapter, u32 cap);
 void mwifiex_show_dev_mcs_support(struct mwifiex_adapter *adapter,
 				u8 support);
-enum mwifiex_status mwifiex_ret_11n_delba(struct mwifiex_private *priv,
-					  struct host_cmd_ds_command *resp);
-enum mwifiex_status mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
-					      struct host_cmd_ds_command *resp);
-enum mwifiex_status mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
-					struct host_cmd_ds_command *resp,
-					void *data_buf);
-enum mwifiex_status mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
-					struct host_cmd_ds_command *cmd,
-					u16 cmd_action, void *data_buf);
-
-enum mwifiex_status mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
-					struct host_cmd_ds_command *cmd,
-					u16 cmd_action, void *data_buf);
+int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
+			  struct host_cmd_ds_command *resp);
+int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp);
+int mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *resp,
+			void *data_buf);
+int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *cmd,
+			u16 cmd_action, void *data_buf);
+
+int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *cmd,
+			u16 cmd_action, void *data_buf);
 
 int mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			       struct mwifiex_bssdescriptor *bss_desc,
@@ -49,31 +49,25 @@ void mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 			struct mwifiex_bssdescriptor *bss_desc);
 void mwifiex_fill_cap_info(struct mwifiex_private *,
 			   struct mwifiex_ie_types_htcap *);
-enum mwifiex_status mwifiex_11n_ioctl_ht_tx_cfg(
-					struct mwifiex_adapter *adapter,
-					struct mwifiex_wait_queue *wait_queue,
-					struct mwifiex_ds_11n_tx_cfg *tx_cfg,
-					u16 action);
-enum mwifiex_status mwifiex_set_get_11n_htcap_cfg(
-					struct mwifiex_private *priv,
-					u16 action, int *htcap_cfg);
-enum mwifiex_status mwifiex_11n_ioctl_aggr_prio_tbl(
-					struct mwifiex_private *priv,
-					struct mwifiex_ds_11n_aggr_prio_tbl
-					*aggr_prio_tbl, u16 action);
-enum mwifiex_status mwifiex_set_get_addba_reject(
-					struct mwifiex_private *priv,
-					u16 action, int *);
-enum mwifiex_status mwifiex_11n_ioctl_addba_param(
-					struct mwifiex_adapter *adapter,
-					struct mwifiex_wait_queue *wait_queue,
-					struct mwifiex_ds_11n_addba_param
-					*addba_param, u16 action);
-enum mwifiex_status mwifiex_11n_ioctl_amsdu_aggr_ctrl(
-					struct mwifiex_adapter *adapter,
-					struct mwifiex_wait_queue *wait_queue,
-					struct mwifiex_ds_11n_amsdu_aggr_ctrl
-					*amsdu_aggr_ctrl, u16 action);
+int mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
+				struct mwifiex_wait_queue *wait_queue,
+				struct mwifiex_ds_11n_tx_cfg *tx_cfg,
+				u16 action);
+int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv,
+				  u16 action, int *htcap_cfg);
+int mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
+				    struct mwifiex_ds_11n_aggr_prio_tbl
+				    *aggr_prio_tbl, u16 action);
+int mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
+				 u16 action, int *);
+int mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
+				  struct mwifiex_wait_queue *wait_queue,
+				  struct mwifiex_ds_11n_addba_param
+				  *addba_param, u16 action);
+int mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
+				      struct mwifiex_wait_queue *wait_queue,
+				      struct mwifiex_ds_11n_amsdu_aggr_ctrl
+				      *amsdu_aggr_ctrl, u16 action);
 void mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 					     struct mwifiex_tx_ba_stream_tbl
 					     *tx_tbl);
@@ -100,17 +94,17 @@ int mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
 			      struct mwifiex_ds_rx_reorder_tbl *buf);
 int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 			       struct mwifiex_ds_tx_ba_stream_tbl *buf);
-enum mwifiex_status mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
-						struct host_cmd_ds_command
-						*resp,
-						void *data_buf);
-enum mwifiex_status mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
-					     struct host_cmd_ds_command *cmd,
-					     int cmd_action, void *data_buf);
-enum mwifiex_status mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
-						struct host_cmd_ds_command *cmd,
-						int cmd_action,
-						void *data_buf);
+int mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
+				struct host_cmd_ds_command
+				*resp,
+				void *data_buf);
+int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
+			     struct host_cmd_ds_command *cmd,
+			     int cmd_action, void *data_buf);
+int mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *cmd,
+				int cmd_action,
+				void *data_buf);
 
 /*
  * This function checks whether AMPDU is allowed or not for a particular TID.
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index b122f2c..890d913 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -185,9 +185,8 @@ mwifiex_11n_get_num_aggr_pkts(u8 *data, int total_pkt_len)
  * upper layer after processing. The function also performs sanity tests on
  * the received buffer.
  */
-enum mwifiex_status
-mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
-			    struct sk_buff *skb)
+int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
+				struct sk_buff *skb)
 {
 	u16 pkt_len;
 	int total_pkt_len;
@@ -197,7 +196,7 @@ mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 	struct rxpd *local_rx_pd = (struct rxpd *) skb->data;
 	struct sk_buff *skb_daggr;
 	struct mwifiex_rxinfo *rx_info_daggr = NULL;
-	enum mwifiex_status ret = MWIFIEX_STATUS_FAILURE;
+	int ret = -1;
 	struct rx_packet_hdr *rx_pkt_hdr;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u8 rfc1042_eth_hdr[MWIFIEX_MAC_ADDR_LENGTH] = { 0xaa, 0xaa, 0x03,
@@ -250,7 +249,7 @@ mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 		if (!skb_daggr) {
 			PRINTM(MERROR, "%s: failed to alloc mbuf_daggr\n",
 			       __func__);
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 		rx_info_daggr = MWIFIEX_SKB_RXCB(skb_daggr);
@@ -265,11 +264,11 @@ mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 		ret = mwifiex_recv_packet(adapter, skb_daggr);
 
 		switch (ret) {
-		case MWIFIEX_STATUS_PENDING:
+		case -EINPROGRESS:
 			break;
-		case MWIFIEX_STATUS_FAILURE:
+		case -1:
 			PRINTM(MERROR, "Deaggr, send to mwifiex failed\n");
-		case MWIFIEX_STATUS_SUCCESS:
+		case 0:
 			mwifiex_recv_packet_complete(adapter, skb_daggr, ret);
 			break;
 		default:
@@ -310,7 +309,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	struct sk_buff *skb_aggr, *skb_src;
 	struct mwifiex_txinfo *tx_info_aggr, *tx_info_src;
 	int pad = 0;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
 
@@ -330,7 +329,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		PRINTM(MERROR, "Error allocating SKB\n");
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 	skb_reserve(skb_aggr, headroom + sizeof(struct txpd));
 	tx_info_aggr =  MWIFIEX_SKB_TXCB(skb_aggr);
@@ -353,8 +352,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 				       ra_list_flags);
 		mwifiex_11n_form_amsdu_pkt(adapter, skb_aggr, skb_src, &pad);
 
-		mwifiex_write_data_complete(adapter, skb_src,
-					     MWIFIEX_STATUS_SUCCESS);
+		mwifiex_write_data_complete(adapter, skb_src, 0);
 
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
@@ -362,7 +360,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 					       ra_list_flags);
 			LEAVE();
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 
 		if (!skb_queue_empty(&pra_list->skb_head))
@@ -392,15 +390,14 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 					     skb_aggr->data,
 					     skb_aggr->len, &tx_param);
 	switch (ret) {
-	case MWIFIEX_STATUS_RESOURCE:
+	case -EBUSY:
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 					       ra_list_flags);
-			mwifiex_write_data_complete(adapter, skb_aggr,
-						    MWIFIEX_STATUS_FAILURE);
+			mwifiex_write_data_complete(adapter, skb_aggr, -1);
 			LEAVE();
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
 			(adapter->pps_uapsd_mode) &&
@@ -416,25 +413,25 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		tx_info_aggr->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
-		PRINTM(MDATA, "MWIFIEX_STATUS_RESOURCE is returned\n");
+		PRINTM(MDATA, "-EBUSY is returned\n");
 		break;
-	case MWIFIEX_STATUS_FAILURE:
+	case -1:
 		adapter->data_sent = false;
 		PRINTM(MERROR, "Error: mwifiex_write_data_async failed: 0x%X\n",
 		       ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb_aggr, ret);
 		goto exit;
-	case MWIFIEX_STATUS_PENDING:
+	case -EINPROGRESS:
 		adapter->data_sent = false;
 		break;
-	case MWIFIEX_STATUS_SUCCESS:
+	case 0:
 		mwifiex_write_data_complete(adapter, skb_aggr, ret);
 		break;
 	default:
 		break;
 	}
-	if (ret != MWIFIEX_STATUS_RESOURCE) {
+	if (ret != -EBUSY) {
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 		if (mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			priv->wmm.packets_out[ptrindex]++;
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.h b/drivers/net/wireless/mwifiex/11n_aggr.h
index 5639aa8..8dcc2b5 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.h
+++ b/drivers/net/wireless/mwifiex/11n_aggr.h
@@ -22,8 +22,8 @@
 
 #define PKT_TYPE_AMSDU	0xE6
 
-enum mwifiex_status mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
-						struct sk_buff *skb);
+int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
+				struct sk_buff *skb);
 int mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			      struct mwifiex_ra_list_tbl *ptr, int headroom,
 			      int ptr_index, unsigned long flags)
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index 6d6a280..d11ec84 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -31,10 +31,9 @@
  * This function processes a received packet and forwards
  * it to the kernel/upper layer.
  */
-static enum mwifiex_status
-mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
+static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	ret = mwifiex_process_rx_packet(adapter,
@@ -49,13 +48,13 @@ mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
  * Since the buffer is linear, the function uses rotation to simulate
  * circular buffer.
  */
-static enum mwifiex_status
+static int
 mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 					 struct mwifiex_rx_reorder_tbl
 					 *rx_reor_tbl_ptr, int start_win)
 {
 	int no_pkt_to_send, i, xchg;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	void *rx_tmp_ptr = NULL;
 	unsigned long flags;
 
@@ -104,12 +103,12 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
  * Since the buffer is linear, the function uses rotation to simulate
  * circular buffer.
  */
-static enum mwifiex_status
+static int
 mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 			      struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr)
 {
 	int i, j, xchg;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	void *rx_tmp_ptr = NULL;
 	unsigned long flags;
 
@@ -357,9 +356,8 @@ exit:
  *      - Setting add BA request buffer
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
-mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
-			  struct host_cmd_ds_command *cmd, void *data_buf)
+int mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *cmd, void *data_buf)
 {
 	struct host_cmd_ds_11n_addba_req *add_ba_req =
 		(struct host_cmd_ds_11n_addba_req *)
@@ -375,7 +373,7 @@ mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
 	       sizeof(struct host_cmd_ds_11n_addba_req));
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -386,9 +384,9 @@ mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
  *      - Setting add BA response buffer
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
-mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
-			     struct host_cmd_ds_command *cmd, void *data_buf)
+int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
+				  struct host_cmd_ds_command *cmd,
+				  void *data_buf)
 {
 	struct host_cmd_ds_11n_addba_rsp *add_ba_rsp =
 		(struct host_cmd_ds_11n_addba_rsp *)
@@ -434,7 +432,7 @@ mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 	mwifiex_11n_create_rx_reorder_tbl(priv, cmd_addba_req->peer_mac_addr,
 			    tid, win_size, le16_to_cpu(cmd_addba_req->ssn));
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -445,9 +443,8 @@ mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
  *      - Setting del BA request buffer
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
-mwifiex_cmd_11n_delba(struct mwifiex_private *priv,
-		      struct host_cmd_ds_command *cmd, void *data_buf)
+int mwifiex_cmd_11n_delba(struct mwifiex_private *priv,
+			  struct host_cmd_ds_command *cmd, void *data_buf)
 {
 	struct host_cmd_ds_11n_delba *del_ba = (struct host_cmd_ds_11n_delba *)
 		&cmd->params.del_ba;
@@ -461,7 +458,7 @@ mwifiex_cmd_11n_delba(struct mwifiex_private *priv,
 	memcpy(del_ba, data_buf, sizeof(struct host_cmd_ds_11n_delba));
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -477,14 +474,13 @@ mwifiex_cmd_11n_delba(struct mwifiex_private *priv,
  *
  * For sequence number less than the starting window, the packet is dropped.
  */
-enum mwifiex_status
-mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
+int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 				u16 seq_num, u16 tid,
 				u8 *ta, u8 pkt_type, void *payload)
 {
 	struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
 	int start_win, end_win, win_size;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u16 pkt_index = 0;
 
 	ENTER();
@@ -525,12 +521,12 @@ mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 					(MAX_TID_VALUE - 1))
 			    && (seq_num < start_win)) {
 				LEAVE();
-				return MWIFIEX_STATUS_FAILURE;
+				return -1;
 			}
 		} else if ((seq_num < start_win) ||
 			   (seq_num > (start_win + (TWOPOW11)))) {
 			LEAVE();
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 
 		/*
@@ -580,7 +576,7 @@ mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 			if (rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index]) {
 				PRINTM(MDAT_D, "Drop Duplicate Pkt\n");
 				LEAVE();
-				return MWIFIEX_STATUS_FAILURE;
+				return -1;
 			}
 			rx_reor_tbl_ptr->rx_reorder_ptr[pkt_index] = payload;
 		}
@@ -654,9 +650,8 @@ mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int tid,
  * Handling includes changing the header fields into CPU format and
  * creating the stream, provided the add BA is accepted.
  */
-enum mwifiex_status
-mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
-			   struct host_cmd_ds_command *resp)
+int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_11n_addba_rsp *add_ba_rsp =
 		(struct host_cmd_ds_11n_addba_rsp *)
@@ -709,7 +704,7 @@ mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index fb5c695..1638543 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -38,27 +38,27 @@
 #define ADDBA_RSP_STATUS_REJECT 1
 #define ADDBA_RSP_STATUS_ACCEPT 0
 
-enum mwifiex_status mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *,
-						u16 seqNum,
-					      u16 tid, u8 *ta,
-					      u8 pkttype, void *payload);
+int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *,
+			       u16 seqNum,
+			       u16 tid, u8 *ta,
+			       u8 pkttype, void *payload);
 void mwifiex_11n_delete_ba_stream_tbl(struct mwifiex_private *priv, int Tid,
 				     u8 *PeerMACAddr, u8 type,
 				     int initiator);
 void mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
 				   struct host_cmd_ds_11n_batimeout *event);
-enum mwifiex_status mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
-					       struct host_cmd_ds_command
-					       *resp);
-enum mwifiex_status mwifiex_cmd_11n_delba(struct mwifiex_private *priv,
-					  struct host_cmd_ds_command *cmd,
-					  void *data_buf);
-enum mwifiex_status mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
-						 struct host_cmd_ds_command
-						 *cmd, void *data_buf);
-enum mwifiex_status mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
-					      struct host_cmd_ds_command *cmd,
-					      void *data_buf);
+int mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command
+			       *resp);
+int mwifiex_cmd_11n_delba(struct mwifiex_private *priv,
+			  struct host_cmd_ds_command *cmd,
+			  void *data_buf);
+int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
+				  struct host_cmd_ds_command
+				  *cmd, void *data_buf);
+int mwifiex_cmd_11n_addba_req(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *cmd,
+			      void *data_buf);
 void mwifiex_11n_cleanup_reorder_tbl(struct mwifiex_private *priv);
 struct mwifiex_rx_reorder_tbl *mwifiex_11n_get_rxreorder_tbl(struct
 							   mwifiex_private
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ef7824b..6a8f9e1 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -73,9 +73,8 @@ static int mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 static int mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 					 enum nl80211_tx_power_setting type,
 					 int dbm);
-static enum mwifiex_status
-mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
-		struct mwifiex_802_11_ssid *ssid);
+static int mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
+					struct mwifiex_802_11_ssid *ssid);
 
 /*
  * This function maps the nl802.11 channel type into driver channel type.
@@ -360,7 +359,7 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 {
 	struct mwifiex_chan_freq_power cfp;
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_ds_band_cfg band_cfg;
 	int mode;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
@@ -392,7 +391,7 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 		status = mwifiex_radio_ioctl_band_cfg(priv, HostCmd_ACT_GEN_SET,
 						      &band_cfg);
 
-		if (status != MWIFIEX_STATUS_SUCCESS) {
+		if (status) {
 			ret = -EFAULT;
 			goto done;
 		}
@@ -410,7 +409,7 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 
 		status = mwifiex_bss_ioctl_channel(priv, HostCmd_ACT_GEN_SET,
 						   &cfp);
-		if (MWIFIEX_STATUS_SUCCESS != status) {
+		if (status) {
 			ret = -EFAULT;
 			goto done;
 		}
@@ -460,8 +459,8 @@ mwifiex_cfg80211_set_channel(struct wiphy *wiphy,
 static int
 mwifiex_set_frag(struct mwifiex_private *priv, u32 frag_thr)
 {
-	int ret = MWIFIEX_STATUS_SUCCESS;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
@@ -482,8 +481,7 @@ mwifiex_set_frag(struct mwifiex_private *priv, u32 frag_thr)
 	status = mwifiex_snmp_mib_ioctl(priv, wait, FRAG_THRESH_I,
 					HostCmd_ACT_GEN_SET, &frag_thr);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -502,9 +500,9 @@ done:
 static int
 mwifiex_set_rts(struct mwifiex_private *priv, u32 rts_thr)
 {
-	int ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_wait_queue *wait = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
 	ENTER();
@@ -521,8 +519,7 @@ mwifiex_set_rts(struct mwifiex_private *priv, u32 rts_thr)
 	status = mwifiex_snmp_mib_ioctl(priv, wait, RTS_THRESH_I,
 					HostCmd_ACT_GEN_SET, &rts_thr);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -545,7 +542,7 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) mwifiex_cfg80211_get_priv(wiphy);
 
-	int ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD)
 		ret = mwifiex_set_rts(priv, wiphy->rts_threshold);
@@ -573,11 +570,11 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 				     enum nl80211_iftype type, u32 *flags,
 				     struct vif_params *params)
 {
-	int ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	int mode = -1;
 	struct mwifiex_wait_queue *wait = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 
 	ENTER();
 
@@ -610,8 +607,7 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		goto done;
 	status = mwifiex_bss_ioctl_mode(priv, wait, HostCmd_ACT_GEN_SET, &mode);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
+	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -639,7 +635,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 {
 	struct mwifiex_ds_get_signal signal;
 	struct mwifiex_rate_cfg rate;
-	int ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	sinfo->filled = STATION_INFO_RX_BYTES | STATION_INFO_TX_BYTES |
 		STATION_INFO_RX_PACKETS |
@@ -648,13 +644,12 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 
 	/* Get signal information from the firmware */
 	memset(&signal, 0, sizeof(struct mwifiex_ds_get_signal));
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_get_signal_info(priv, MWIFIEX_IOCTL_WAIT, &signal)) {
+	if (mwifiex_get_signal_info(priv, MWIFIEX_IOCTL_WAIT, &signal)) {
 		PRINTM(MERROR, "Error getting signal information\n");
 		ret = -EFAULT;
 	}
 
-	if (MWIFIEX_STATUS_SUCCESS != mwifiex_drv_get_data_rate(priv, &rate)) {
+	if (mwifiex_drv_get_data_rate(priv, &rate)) {
 		PRINTM(MERROR, "Error getting data rate\n");
 		ret = -EFAULT;
 	}
@@ -681,7 +676,7 @@ mwifiex_cfg80211_get_station(struct wiphy *wiphy,
 			     u8 *mac, struct station_info *sinfo)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	int ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	mwifiex_dump_station_info(priv, sinfo);
 
@@ -810,8 +805,7 @@ mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		return -EBUSY;
 
 	priv->disconnect = 1;
-	if (mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL) !=
-	    MWIFIEX_STATUS_SUCCESS)
+	if (mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL))
 		return -EFAULT;
 
 	PRINTM(MINFO, "Successfully disconnected from %pM: Reason code %d\n",
@@ -858,10 +852,9 @@ mwifiex_set_wep_keys(struct mwifiex_private *priv, const u8 *key, int key_len,
  *      - BSSID
  *      - Channel
  */
-static enum mwifiex_status
-mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
+static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct ieee80211_channel *chan;
 	struct mwifiex_bss_info bss_info;
 	int ie_len = 0;
@@ -1019,8 +1012,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	}
 
 	/* Do specific SSID scanning */
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_scan(priv, MWIFIEX_IOCTL_WAIT, &req_ssid)) {
+	if (mwifiex_request_scan(priv, MWIFIEX_IOCTL_WAIT, &req_ssid)) {
 		PRINTM(MERROR, "Scan error\n");
 		ret = -EFAULT;
 		goto done;
@@ -1030,16 +1022,14 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	memcpy(&ssid_bssid.ssid, &req_ssid, sizeof(struct mwifiex_802_11_ssid));
 
 	if (mode != MWIFIEX_BSS_MODE_IBSS) {
-		if (MWIFIEX_STATUS_SUCCESS !=
-				mwifiex_find_best_bss(priv,
-					MWIFIEX_IOCTL_WAIT, &ssid_bssid)) {
+		if (mwifiex_find_best_bss(priv, MWIFIEX_IOCTL_WAIT,
+					  &ssid_bssid)) {
 			ret = -EFAULT;
 			goto done;
 		}
 		/* Inform the BSS information to kernel, otherwise
 		 * kernel will give a panic after successful assoc */
-		if (MWIFIEX_STATUS_SUCCESS !=
-				mwifiex_inform_bss_from_scan_result(priv,
+		if (mwifiex_inform_bss_from_scan_result(priv,
 					&req_ssid)) {
 			ret = -EFAULT;
 			goto done;
@@ -1054,9 +1044,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	/* Connect to BSS by ESSID */
 	memset(&ssid_bssid.bssid, 0, MWIFIEX_MAC_ADDR_LENGTH);
 
-	if (MWIFIEX_STATUS_SUCCESS != mwifiex_bss_start(priv,
-							MWIFIEX_IOCTL_WAIT,
-							&ssid_bssid)) {
+	if (mwifiex_bss_start(priv, MWIFIEX_IOCTL_WAIT, &ssid_bssid)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -1064,8 +1052,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	if (mode == MWIFIEX_BSS_MODE_IBSS) {
 		/* Inform the BSS information to kernel, otherwise
 		 * kernel will give a panic after successful assoc */
-		if (MWIFIEX_STATUS_SUCCESS !=
-			mwifiex_cfg80211_inform_ibss_bss(priv)) {
+		if (mwifiex_cfg80211_inform_ibss_bss(priv)) {
 			ret = -EFAULT;
 			goto done;
 		}
@@ -1179,8 +1166,7 @@ mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	priv->disconnect = 1;
 
 	PRINTM(MINFO, "Disconnecting from essid %pM\n", priv->cfg_bssid);
-	if (mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL) !=
-	    MWIFIEX_STATUS_SUCCESS)
+	if (mwifiex_disconnect(priv, MWIFIEX_IOCTL_WAIT, NULL))
 		return -EFAULT;
 
 	queue_work(priv->workqueue, &priv->cfg_workqueue);
@@ -1208,7 +1194,7 @@ mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
  *      - WPA IE
  *      - RSN IE
  */
-static enum mwifiex_status
+static int
 mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 		struct mwifiex_802_11_ssid *ssid)
 {
@@ -1226,9 +1212,7 @@ mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 
 	ENTER();
 	memset(&scan_resp, 0, sizeof(scan_resp));
-	if (MWIFIEX_STATUS_SUCCESS != mwifiex_get_scan_table(priv,
-							     MWIFIEX_IOCTL_WAIT,
-							     &scan_resp)) {
+	if (mwifiex_get_scan_table(priv, MWIFIEX_IOCTL_WAIT, &scan_resp)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -1536,14 +1520,11 @@ mwifiex_cfg80211_results(struct work_struct *work)
 					MWIFIEX_SCAN_TYPE_ACTIVE;
 			scan_req.chan_list[i].scan_time = 0;
 		}
-		if (MWIFIEX_STATUS_SUCCESS !=
-				mwifiex_set_user_scan_ioctl(priv, &scan_req)) {
+		if (mwifiex_set_user_scan_ioctl(priv, &scan_req)) {
 			ret = -EFAULT;
 			goto done;
 		}
-		if (MWIFIEX_STATUS_SUCCESS !=
-				mwifiex_inform_bss_from_scan_result(priv,
-								    NULL)) {
+		if (mwifiex_inform_bss_from_scan_result(priv, NULL)) {
 			ret = -EFAULT;
 			goto done;
 		}
@@ -1598,10 +1579,9 @@ done:
  *  This function prepares the set domain info command and sends
  *  it to firmware.
  */
-static enum mwifiex_status
-mwifiex_11d_set_domain_info(struct mwifiex_private *priv)
+static int mwifiex_11d_set_domain_info(struct mwifiex_private *priv)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -1637,7 +1617,7 @@ void mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 					mwifiex_cfg80211_get_priv(wiphy);
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_802_11d_domain_reg *domain_info = &adapter->domain_reg;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 	/* Set country code */
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 0cb47ac..c218197 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -94,8 +94,7 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 	cmd_node->data_buf = NULL;
 
 	if (cmd_node->resp_skb) {
-		mwifiex_recv_complete(adapter, cmd_node->resp_skb,
-				      MWIFIEX_STATUS_SUCCESS);
+		mwifiex_recv_complete(adapter, cmd_node->resp_skb, 0);
 		cmd_node->resp_skb = NULL;
 	}
 
@@ -138,9 +137,8 @@ mwifiex_get_pending_ioctl_cmd(struct mwifiex_adapter *adapter,
  * buffer, which will be transferred to the firmware later by the
  * main thread.
  */
-static enum mwifiex_status
-mwifiex_cmd_host_cmd(struct mwifiex_private *priv,
-		     struct host_cmd_ds_command *cmd, void *data_buf)
+static int mwifiex_cmd_host_cmd(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *cmd, void *data_buf)
 {
 	struct mwifiex_ds_misc_cmd *pcmd_ptr =
 		(struct mwifiex_ds_misc_cmd *) data_buf;
@@ -151,7 +149,7 @@ mwifiex_cmd_host_cmd(struct mwifiex_private *priv,
 	memcpy((void *) cmd, pcmd_ptr->cmd, pcmd_ptr->len);
 	PRINTM(MCMND, "Host command size = %d\n", pcmd_ptr->len);
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -162,13 +160,12 @@ mwifiex_cmd_host_cmd(struct mwifiex_private *priv,
  * sending. Afterwards, it logs the command ID and action for debugging
  * and sets up the command timeout timer.
  */
-static enum mwifiex_status
-mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
-		       struct cmd_ctrl_node *cmd_node)
+static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
+				  struct cmd_ctrl_node *cmd_node)
 {
 
 	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct host_cmd_ds_command *host_cmd;
 	struct mwifiex_wait_queue *wait_queue = NULL;
 	uint16_t cmd_code;
@@ -179,7 +176,7 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	ENTER();
 
 	if (!adapter || !cmd_node) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -195,7 +192,7 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		if (wait_queue)
 			wait_queue->status = MWIFIEX_ERROR_CMD_DNLD_FAIL;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -229,7 +226,7 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 					     cmd_node->cmd_skb->data,
 					     cmd_node->cmd_skb->len, NULL);
 
-	if (ret == MWIFIEX_STATUS_FAILURE) {
+	if (ret == -1) {
 		PRINTM(MERROR, "DNLD_CMD: Host to Card Failed\n");
 		if (wait_queue)
 			wait_queue->status = MWIFIEX_ERROR_CMD_DNLD_FAIL;
@@ -240,7 +237,7 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
 		adapter->dbg.num_cmd_host_to_card_failure++;
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -258,7 +255,7 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	mod_timer(&adapter->cmd_timer,
 		jiffies + (MWIFIEX_TIMER_10S * HZ) / 1000);
 
-	ret = MWIFIEX_STATUS_SUCCESS;
+	ret = 0;
 
 done:
 	LEAVE();
@@ -274,10 +271,9 @@ done:
  *
  * No responses are needed for sleep confirm command.
  */
-static enum mwifiex_status
-mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
+static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	static u32 i;
 	u16 cmd_len = 0;
 	struct mwifiex_private *priv;
@@ -300,7 +296,7 @@ mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 					     adapter->sleep_cfm->len +
 					     INTF_HEADER_LEN, NULL);
 
-	if (ret == MWIFIEX_STATUS_FAILURE) {
+	if (ret == -1) {
 		PRINTM(MERROR, "SLEEP_CFM: failed\n");
 		adapter->dbg.num_cmd_sleep_cfm_host_to_card_failure++;
 		goto done;
@@ -349,10 +345,9 @@ done:
  * command buffers already in use and awaiting handling. Command buffers
  * are returned to the free queue after use.
  */
-enum mwifiex_status
-mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
+int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct cmd_ctrl_node *cmd_array;
 	u32 buf_size;
 	u32 i;
@@ -364,7 +359,7 @@ mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 	cmd_array = kzalloc(buf_size, GFP_KERNEL);
 	if (!cmd_array) {
 		PRINTM(MERROR, "%s: failed to alloc cmd_array\n", __func__);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -378,14 +373,14 @@ mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 		if (!cmd_array[i].skb) {
 			PRINTM(MERROR,
 			       "ALLOC_CMD_BUF: pcmd_buf: out of memory\n");
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 	}
 
 	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++)
 		mwifiex_insert_cmd_to_free_q(adapter, &cmd_array[i]);
-	ret = MWIFIEX_STATUS_SUCCESS;
+	ret = 0;
 done:
 	LEAVE();
 	return ret;
@@ -397,8 +392,7 @@ done:
  * The function calls the completion callback for all the command
  * buffers that still have response buffers associated with them.
  */
-enum mwifiex_status
-mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
+int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_array;
 	u32 i;
@@ -421,7 +415,7 @@ mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 		}
 		if (cmd_array[i].resp_skb) {
 			mwifiex_recv_complete(adapter, cmd_array[i].resp_skb,
-					      MWIFIEX_STATUS_SUCCESS);
+					      0);
 		}
 	}
 	/* Release struct cmd_ctrl_node */
@@ -433,7 +427,7 @@ mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter)
 
 done:
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -446,10 +440,9 @@ done:
  * After processing, the function calls the completion callback
  * for cleanup.
  */
-enum mwifiex_status
-mwifiex_process_event(struct mwifiex_adapter *adapter)
+int mwifiex_process_event(struct mwifiex_adapter *adapter)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_private *priv =
 		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	struct sk_buff *skb = adapter->event_skb;
@@ -490,7 +483,7 @@ mwifiex_process_event(struct mwifiex_adapter *adapter)
 	adapter->event_cause = 0;
 	adapter->event_skb = NULL;
 
-	mwifiex_recv_complete(adapter, skb, MWIFIEX_STATUS_SUCCESS);
+	mwifiex_recv_complete(adapter, skb, 0);
 
 	LEAVE();
 	return ret;
@@ -507,13 +500,12 @@ mwifiex_process_event(struct mwifiex_adapter *adapter)
  *      - Fill up the non-default parameters and buffer pointers
  *      - Add the command to pending queue
  */
-enum mwifiex_status
-mwifiex_prepare_cmd(struct mwifiex_private *priv,
-		    uint16_t cmd_no,
-		    u16 cmd_action,
-		    u32 cmd_oid, void *wait_queue, void *data_buf)
+int mwifiex_prepare_cmd(struct mwifiex_private *priv,
+			uint16_t cmd_no,
+			u16 cmd_action,
+			u32 cmd_oid, void *wait_queue, void *data_buf)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmd_node = NULL;
 	struct host_cmd_ds_command *cmd_ptr = NULL;
@@ -523,26 +515,26 @@ mwifiex_prepare_cmd(struct mwifiex_private *priv,
 	/* Sanity test */
 	if (adapter->is_suspended) {
 		PRINTM(MERROR, "PREP_CMD: Device in suspended state\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
 	if (adapter == NULL) {
 		PRINTM(MERROR, "PREP_CMD: adapter is NULL\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
 	if (adapter->surprise_removed) {
 		PRINTM(MERROR, "PREP_CMD: Card is Removed\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_RESET) {
 		if (cmd_no != HostCmd_CMD_FUNC_INIT) {
 			PRINTM(MERROR, "PREP_CMD: FW is in reset state\n");
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 	}
@@ -552,7 +544,7 @@ mwifiex_prepare_cmd(struct mwifiex_private *priv,
 
 	if (cmd_node == NULL) {
 		PRINTM(MERROR, "PREP_CMD: No free cmd node\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -561,7 +553,7 @@ mwifiex_prepare_cmd(struct mwifiex_private *priv,
 
 	if (!cmd_node->cmd_skb) {
 		PRINTM(MERROR, "PREP_CMD: No free cmd buf\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -582,11 +574,11 @@ mwifiex_prepare_cmd(struct mwifiex_private *priv,
 	}
 
 	/* Return error, since the command preparation failed */
-	if (ret != MWIFIEX_STATUS_SUCCESS) {
+	if (ret) {
 		PRINTM(MERROR, "PREP_CMD: Command 0x%x preparation failed\n",
 		       cmd_no);
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -620,11 +612,9 @@ mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 	if (cmd_node->wq_buf) {
 		wait_queue = (struct mwifiex_wait_queue *) cmd_node->wq_buf;
 		if (wait_queue->status != MWIFIEX_ERROR_NO_ERROR)
-			mwifiex_ioctl_complete(adapter, wait_queue,
-					       MWIFIEX_STATUS_FAILURE);
+			mwifiex_ioctl_complete(adapter, wait_queue, -1);
 		else
-			mwifiex_ioctl_complete(adapter, wait_queue,
-					       MWIFIEX_STATUS_SUCCESS);
+			mwifiex_ioctl_complete(adapter, wait_queue, 0);
 	}
 	/* Clean the node */
 	mwifiex_clean_cmd_node(adapter, cmd_node);
@@ -699,12 +689,11 @@ done:
  * host sleep configuration command will de-activate the host sleep. For PS
  * mode, the function will put the firmware back to sleep if applicable.
  */
-enum mwifiex_status
-mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
+int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_private *priv = NULL;
 	struct cmd_ctrl_node *cmd_node = NULL;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct host_cmd_ds_command *host_cmd;
 	unsigned long cmd_flags;
 	unsigned long cmd_pending_q_flags;
@@ -715,7 +704,7 @@ mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 	if (adapter->curr_cmd) {
 		PRINTM(MERROR,
 		       "EXEC_NEXT_CMD: there is command in processing!\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -726,7 +715,7 @@ mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter)
 		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
 				       cmd_pending_q_flags);
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
-		ret = MWIFIEX_STATUS_SUCCESS;
+		ret = 0;
 		goto done;
 	}
 	cmd_node = list_first_entry(&adapter->cmd_pending_q,
@@ -778,13 +767,12 @@ done:
  * After processing, the function cleans the command node and puts
  * it back to the command free queue.
  */
-enum mwifiex_status
-mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
+int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 {
 	struct host_cmd_ds_command *resp = NULL;
 	struct mwifiex_private *priv =
 		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	uint16_t orig_cmdresp_no;
 	uint16_t cmdresp_no;
 	uint16_t cmdresp_result;
@@ -801,7 +789,7 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		resp = (struct host_cmd_ds_command *) adapter->upld_buf;
 		PRINTM(MERROR, "CMD_RESP: NULL curr_cmd, 0x%x\n",
 		       le16_to_cpu(resp->command));
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -824,7 +812,7 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd = NULL;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -876,7 +864,7 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd = NULL;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -893,7 +881,7 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	/* Check init command response */
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING) {
-		if (ret == MWIFIEX_STATUS_FAILURE) {
+		if (ret == -1) {
 			PRINTM(MERROR, "cmd 0x%02x failed during "
 				       "initialization\n", cmdresp_no);
 			mwifiex_init_fw_complete(adapter);
@@ -903,9 +891,9 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	}
 
 	if (adapter->curr_cmd) {
-		if (wait_queue && (ret == MWIFIEX_STATUS_SUCCESS))
+		if (wait_queue && (!ret))
 			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
-		else if (wait_queue && (ret == MWIFIEX_STATUS_FAILURE))
+		else if (wait_queue && (ret == -1))
 			wait_queue->status = MWIFIEX_ERROR_CMD_RESP_FAIL;
 
 		/* Clean up and put current command back to cmd_free_q */
@@ -1037,8 +1025,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 		adapter->curr_cmd->wq_buf = NULL;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 		wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
-		mwifiex_ioctl_complete(adapter, wait_queue,
-				       MWIFIEX_STATUS_FAILURE);
+		mwifiex_ioctl_complete(adapter, wait_queue, -1);
 	}
 	/* Cancel all pending command */
 	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
@@ -1051,8 +1038,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 			wait_queue =
 				(struct mwifiex_wait_queue *) cmd_node->wq_buf;
 			wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
-			mwifiex_ioctl_complete(adapter, wait_queue,
-					       MWIFIEX_STATUS_FAILURE);
+			mwifiex_ioctl_complete(adapter, wait_queue, -1);
 			cmd_node->wq_buf = NULL;
 		}
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
@@ -1152,7 +1138,7 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	}
 	wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
-	mwifiex_ioctl_complete(adapter, wait_queue, MWIFIEX_STATUS_FAILURE);
+	mwifiex_ioctl_complete(adapter, wait_queue, -1);
 
 	LEAVE();
 	return;
@@ -1241,9 +1227,8 @@ mwifiex_host_sleep_wakeup_event(struct mwifiex_private *priv)
  * In case host sleep status change, the function generates an event to
  * notify the applications.
  */
-enum mwifiex_status
-mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
-			  struct host_cmd_ds_command *resp)
+int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_hs_cfg_enh *phs_cfg =
@@ -1272,7 +1257,7 @@ mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 	}
 done:
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1337,7 +1322,7 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 	}
 	PRINTM(MEVENT, "#\n");
 
-	if (result != MWIFIEX_STATUS_SUCCESS) {
+	if (result) {
 		PRINTM(MERROR, "Sleep confirm command failed\n");
 		adapter->pm_wakeup_card_req = false;
 		adapter->ps_state = PS_STATE_AWAKE;
@@ -1370,10 +1355,10 @@ EXPORT_SYMBOL_GPL(mwifiex_process_sleep_confirm_resp);
  *        auto deep sleep TLV (as required)
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
-mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
-			   struct host_cmd_ds_command *cmd,
-			   u16 cmd_action, uint16_t ps_bitmap, void *data_buf)
+int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *cmd,
+			       u16 cmd_action, uint16_t ps_bitmap,
+			       void *data_buf)
 {
 	struct host_cmd_ds_802_11_ps_mode_enh *psmode_enh =
 		&cmd->params.psmode_enh;
@@ -1451,7 +1436,7 @@ mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 		}
 		cmd->size = cpu_to_le16(cmd_size);
 	}
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1461,10 +1446,9 @@ mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
  * Handling includes changing the header fields into CPU format
  * and setting the current enhanced power mode in driver.
  */
-enum mwifiex_status
-mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
-			   struct host_cmd_ds_command *resp,
-			   void *data_buf)
+int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *resp,
+			       void *data_buf)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_ps_mode_enh *ps_mode =
@@ -1519,7 +1503,7 @@ mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 				pm_cfg->param.ps_mode = 0;
 		}
 	}
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1530,9 +1514,8 @@ mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
  *      - Setting permanent address parameter
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
-mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *cmd)
+int mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *cmd)
 {
 	struct host_cmd_ds_get_hw_spec *hw_spec = &cmd->params.hw_spec;
 
@@ -1545,7 +1528,7 @@ mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
 	       MWIFIEX_MAC_ADDR_LENGTH);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1568,13 +1551,12 @@ mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
  *      - MCS support fields
  *      - MP end port
  */
-enum mwifiex_status
-mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *resp)
+int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_get_hw_spec *hw_spec = &resp->params.hw_spec;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	int i;
 
 	ENTER();
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 347a39d..b9d6535 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -65,13 +65,6 @@
 
 #define MWIFIEX_BUF_FLAG_REQUEUED_PKT      BIT(0)
 
-enum mwifiex_status {
-	MWIFIEX_STATUS_FAILURE = 0xffffffff,
-	MWIFIEX_STATUS_SUCCESS = 0,
-	MWIFIEX_STATUS_PENDING,
-	MWIFIEX_STATUS_RESOURCE,
-};
-
 enum mwifiex_error_code {
 	MWIFIEX_ERROR_NO_ERROR = 0,
 	MWIFIEX_ERROR_FW_NOT_READY = 0x00000001,
@@ -127,7 +120,7 @@ struct mwifiex_wait_queue {
 	wait_queue_head_t *wait;
 	u16 *condition;
 	u32 start_time;
-	enum mwifiex_status status;
+	int status;
 	u32 enabled;
 };
 
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 3018963..0580775 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -32,12 +32,11 @@
  * The function allocates a new BSS priority table node and adds it to
  * the end of BSS priority table list, kept in driver memory.
  */
-static enum mwifiex_status
-mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
+static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bss_prio_node *bss_prio;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	unsigned long flags;
 
 	ENTER();
@@ -45,7 +44,7 @@ mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 	bss_prio = kzalloc(sizeof(struct mwifiex_bss_prio_node), GFP_KERNEL);
 	if (!bss_prio) {
 		PRINTM(MERROR, "%s: failed to alloc bss_prio\n", __func__);
-		status = MWIFIEX_STATUS_FAILURE;
+		status = -1;
 		goto exit;
 	}
 
@@ -75,11 +74,10 @@ exit:
  * Additionally, it also initializes all the locks and sets up all the
  * lists.
  */
-static enum mwifiex_status
-mwifiex_init_priv(struct mwifiex_private *priv)
+static int mwifiex_init_priv(struct mwifiex_private *priv)
 {
 	u32 i;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -168,10 +166,9 @@ mwifiex_init_priv(struct mwifiex_private *priv)
  * sleep confirm command buffer. In addition, the queues are
  * also initialized.
  */
-static enum mwifiex_status
-mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
+static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u32 buf_size;
 	struct mwifiex_bssdescriptor *temp_scan_table;
 
@@ -184,17 +181,17 @@ mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 		PRINTM(MERROR, "%s: failed to alloc temp_scan_table\n",
 		       __func__);
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	adapter->scan_table = temp_scan_table;
 
 	/* Allocate command buffer */
 	ret = mwifiex_alloc_cmd_buffer(adapter);
-	if (ret != MWIFIEX_STATUS_SUCCESS) {
+	if (ret) {
 		PRINTM(MERROR, "Failed to allocate command buffer\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	adapter->sleep_cfm =
@@ -203,12 +200,12 @@ mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 
 	if (!adapter->sleep_cfm) {
 		PRINTM(MERROR, "Failed to allocate sleep cfm\n");
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 	skb_reserve(adapter->sleep_cfm, INTF_HEADER_LEN);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -380,9 +377,9 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
  *  This function intializes the lock variables and
  *  the list heads.
  */
-enum mwifiex_status mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
+int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 {
-	enum mwifiex_status     ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_private   *priv = NULL;
 	s32           i = 0;
 	u32           j = 0;
@@ -485,10 +482,9 @@ void mwifiex_free_lock_list(struct mwifiex_adapter *adapter)
  *      - For each interface, send the init commands to firmware
  *      - Send the first command in command pending queue, if available
  */
-enum mwifiex_status
-mwifiex_init_fw(struct mwifiex_adapter *adapter)
+int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_private *priv = NULL;
 	u8 i = 0;
 	u8 first_sta = true;
@@ -502,7 +498,7 @@ mwifiex_init_fw(struct mwifiex_adapter *adapter)
 	/* Allocate memory for member of adapter structure */
 	ret = mwifiex_allocate_adapter(adapter);
 	if (ret) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -516,7 +512,7 @@ mwifiex_init_fw(struct mwifiex_adapter *adapter)
 			/* Initialize private structure */
 			ret = mwifiex_init_priv(priv);
 			if (ret) {
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 				goto done;
 			}
 		}
@@ -525,7 +521,7 @@ mwifiex_init_fw(struct mwifiex_adapter *adapter)
 		if (adapter->priv[i]) {
 			ret = mwifiex_sta_init_cmd(adapter->priv[i],
 						   first_sta);
-			if (ret == MWIFIEX_STATUS_FAILURE)
+			if (ret == -1)
 				goto done;
 
 			first_sta = false;
@@ -537,8 +533,8 @@ mwifiex_init_fw(struct mwifiex_adapter *adapter)
 	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 	if (!is_cmd_pend_q_empty) {
 		/* Send the first command in queue and return */
-		if (mwifiex_main_process(adapter) != MWIFIEX_STATUS_FAILURE)
-			ret = MWIFIEX_STATUS_PENDING;
+		if (mwifiex_main_process(adapter) != -1)
+			ret = -EINPROGRESS;
 	} else {
 		adapter->hw_status = MWIFIEX_HW_STATUS_READY;
 	}
@@ -558,10 +554,10 @@ done:
  *      - Free the adapter
  *      - Notify completion
  */
-enum mwifiex_status
+int
 mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_PENDING;
+	int ret = -EINPROGRESS;
 	struct mwifiex_private *priv = NULL;
 	s32 i = 0;
 	unsigned long flags;
@@ -570,7 +566,7 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 
 	/* mwifiex already shutdown */
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY)
-		return MWIFIEX_STATUS_SUCCESS;
+		return 0;
 
 	adapter->hw_status = MWIFIEX_HW_STATUS_CLOSING;
 	/* wait for mwifiex_process to complete */
@@ -618,11 +614,10 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
  *
  * After download is successfully completed, the host interrupts are enabled.
  */
-enum mwifiex_status
-mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
-		struct mwifiex_fw_image *pmfw)
+int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
+		    struct mwifiex_fw_image *pmfw)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u32 poll_num = 1;
 	int winner;
 
@@ -630,7 +625,7 @@ mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 
 	/* Check if firmware is already running */
 	ret = adapter->if_ops.check_fw_status(adapter, poll_num, &winner);
-	if (ret == MWIFIEX_STATUS_SUCCESS) {
+	if (!ret) {
 		PRINTM(MMSG, "WLAN FW already running! Skip FW download\n");
 		goto done;
 	}
@@ -646,7 +641,7 @@ mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 	if (pmfw) {
 		/* Download firmware with helper */
 		ret = adapter->if_ops.prog_fw(adapter, pmfw);
-		if (ret != MWIFIEX_STATUS_SUCCESS) {
+		if (ret) {
 			PRINTM(MERROR, "%s: mwifiex_prog_fw_w_helper failed "
 					"with ret=0x%x\n",
 					__func__, ret);
@@ -658,9 +653,9 @@ mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 poll_fw:
 	/* Check if the firmware is downloaded successfully or not */
 	ret = adapter->if_ops.check_fw_status(adapter, poll_num, NULL);
-	if (ret != MWIFIEX_STATUS_SUCCESS) {
+	if (ret) {
 		PRINTM(MFATAL, "FW failed to be active in time!\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		LEAVE();
 		return ret;
 	}
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index ef9e46b..35a3c51 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -137,12 +137,11 @@ mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *pmriv, u8 **buffer,
  * NOTE: Setting the MSB of the basic rates needs to be taken
  * care of, either before or after calling this function.
  */
-static enum mwifiex_status
-mwifiex_get_common_rates(struct mwifiex_private *priv,
-			 u8 *rate1,
-			 u32 rate1_size, u8 *rate2, u32 rate2_size)
+static int mwifiex_get_common_rates(struct mwifiex_private *priv,
+				    u8 *rate1,
+				    u32 rate1_size, u8 *rate2, u32 rate2_size)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u8 *ptr = rate1;
 	u8 *tmp = NULL;
 	u32 i, j;
@@ -152,7 +151,7 @@ mwifiex_get_common_rates(struct mwifiex_private *priv,
 	tmp = kmalloc(rate1_size, GFP_KERNEL);
 	if (!tmp) {
 		PRINTM(MERROR, "%s: failed to alloc tmp\n", __func__);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -178,7 +177,7 @@ mwifiex_get_common_rates(struct mwifiex_private *priv,
 	if (!priv->is_data_rate_auto) {
 		while (*ptr) {
 			if ((*ptr & 0x7f) == priv->data_rate) {
-				ret = MWIFIEX_STATUS_SUCCESS;
+				ret = 0;
 				goto done;
 			}
 			ptr++;
@@ -186,11 +185,11 @@ mwifiex_get_common_rates(struct mwifiex_private *priv,
 		PRINTM(MMSG, "Previously set fixed data rate %#x is not "
 		       "compatible with the network\n", priv->data_rate);
 
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
-	ret = MWIFIEX_STATUS_SUCCESS;
+	ret = 0;
 done:
 	kfree(tmp);
 
@@ -202,7 +201,7 @@ done:
  * This function creates the intersection of the rates supported by a
  * target BSS and our adapter settings for use in an assoc/join command.
  */
-static enum mwifiex_status
+static int
 mwifiex_setup_rates_from_bssdesc(struct mwifiex_private *priv,
 				 struct mwifiex_bssdescriptor *bss_desc,
 				 u8 *out_rates, u32 *out_rates_size)
@@ -221,14 +220,14 @@ mwifiex_setup_rates_from_bssdesc(struct mwifiex_private *priv,
 		*out_rates_size = 0;
 		PRINTM(MERROR, "mwifiex_get_common_rates failed\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	*out_rates_size =
 		min_t(size_t, strlen(out_rates), MWIFIEX_SUPPORTED_RATES);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -341,11 +340,11 @@ mwifiex_cmd_append_wapi_ie(struct mwifiex_private *priv, u8 **buffer)
  *      - Setting command ID and proper size
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
-mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
-			     struct host_cmd_ds_command *cmd, void *data_buf)
+int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
+				 struct host_cmd_ds_command *cmd,
+				 void *data_buf)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct host_cmd_ds_802_11_associate *assoc = &cmd->params.associate;
 	struct mwifiex_bssdescriptor *bss_desc;
 	struct mwifiex_ie_types_ssid_param_set *ssid_tlv;
@@ -409,7 +408,7 @@ mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	/* Get the common rates supported between the driver and the BSS Desc */
 	if (mwifiex_setup_rates_from_bssdesc
 	    (priv, bss_desc, rates, &rates_size)) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -492,7 +491,7 @@ mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 				memcpy(rsn_ie_tlv->rsn_ie, &priv->wpa_ie[2],
 					le16_to_cpu(rsn_ie_tlv->header.len));
 			else {
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 				goto done;
 			}
 			HEXDUMP("ASSOC_CMD: RSN IE", (u8 *) rsn_ie_tlv,
@@ -530,7 +529,7 @@ mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 							rsn_ie_tlv->header
 							.len));
 				} else {
-					ret = MWIFIEX_STATUS_FAILURE;
+					ret = -1;
 					goto done;
 				}
 
@@ -569,7 +568,7 @@ mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 						le16_to_cpu(
 						rsn_ie_tlv->header.len));
 				} else {
-					ret = MWIFIEX_STATUS_FAILURE;
+					ret = -1;
 					goto done;
 				}
 
@@ -682,11 +681,10 @@ done:
  * For simplistic handling, the status_code field can be used to determine
  * an association success (0) or failure (non-zero).
  */
-enum mwifiex_status
-mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
+int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 			     struct host_cmd_ds_command *resp, void *wq_buf)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_wait_queue *wait_queue =
 		(struct mwifiex_wait_queue *) wq_buf;
 	struct ieee_types_assoc_rsp *assoc_rsp;
@@ -713,7 +711,7 @@ mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 		       le16_to_cpu(assoc_rsp->cap_info_bitmap),
 		       le16_to_cpu(assoc_rsp->a_id));
 
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -819,7 +817,7 @@ mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 done:
 	/* Need to indicate IOCTL complete */
 	if (wait_queue) {
-		if (ret != MWIFIEX_STATUS_SUCCESS) {
+		if (ret) {
 			if (assoc_rsp->status_code)
 				wait_queue->status =
 					le16_to_cpu(assoc_rsp->status_code);
@@ -853,11 +851,11 @@ done:
  *      - Setting command ID and proper size
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
+int
 mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				struct host_cmd_ds_command *cmd, void *data_buf)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_ad_hoc_start *adhoc_start =
 		&cmd->params.adhoc_start;
@@ -884,7 +882,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	ENTER();
 
 	if (!adapter) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -947,7 +945,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	if (!priv->adhoc_channel) {
 		PRINTM(MERROR, "ADHOC_S_CMD: adhoc_channel cannot be 0\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -1012,7 +1010,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		if (ret) {
 			PRINTM(MERROR,
 			       "ADHOC_S_CMD: G Protection config failed\n");
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 	}
@@ -1096,7 +1094,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			memcpy(rsn_ie_tlv->rsn_ie, &priv->wpa_ie[2],
 			       le16_to_cpu(rsn_ie_tlv->header.len));
 		else {
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 
@@ -1179,7 +1177,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	adhoc_start->cap_info_bitmap = cpu_to_le16(tmp_cap);
 
-	ret = MWIFIEX_STATUS_SUCCESS;
+	ret = 0;
 done:
 	LEAVE();
 	return ret;
@@ -1201,11 +1199,11 @@ done:
  *      - Setting command ID and proper size
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
+int
 mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			       struct host_cmd_ds_command *cmd, void *data_buf)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct host_cmd_ds_802_11_ad_hoc_join *adhoc_join =
 		&cmd->params.adhoc_join;
 	struct mwifiex_bssdescriptor *bss_desc =
@@ -1236,7 +1234,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 		if (ret) {
 			PRINTM(MERROR,
 			       "ADHOC_J_CMD: G Protection config failed\n");
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 	}
@@ -1352,7 +1350,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			memcpy(rsn_ie_tlv->rsn_ie, &priv->wpa_ie[2],
 			       le16_to_cpu(rsn_ie_tlv->header.len));
 		else {
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 
@@ -1386,7 +1384,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 					 oui[0]),
 					le16_to_cpu(rsn_ie_tlv->header.len));
 			} else {
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 				goto done;
 			}
 
@@ -1420,7 +1418,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 				       &((*(bss_desc->bcn_rsn_ie)).data[0])
 				       , le16_to_cpu(rsn_ie_tlv->header.len));
 			} else {
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 				goto done;
 			}
 
@@ -1465,11 +1463,10 @@ done:
  * the applications, in case of successful ad-hoc start/join, and
  * saves the beacon buffer.
  */
-enum mwifiex_status
-mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
-			  struct host_cmd_ds_command *resp, void *wq_buf)
+int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp, void *wq_buf)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_wait_queue *wait_queue =
 		(struct mwifiex_wait_queue *) wq_buf;
 	struct host_cmd_ds_802_11_ad_hoc_result *adhoc_result;
@@ -1494,7 +1491,7 @@ mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 		memset(&priv->curr_bss_params.bss_descriptor,
 		       0x00, sizeof(struct mwifiex_bssdescriptor));
 
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -1546,7 +1543,7 @@ mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 done:
 	/* Need to indicate IOCTL complete */
 	if (wait_queue) {
-		if (ret != MWIFIEX_STATUS_SUCCESS)
+		if (ret)
 			wait_queue->status = MWIFIEX_ERROR_ASSOC_FAIL;
 		else
 			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
@@ -1564,11 +1561,10 @@ done:
  * retrieval and calls the command preparation routine to send the
  * command to firmware.
  */
-enum mwifiex_status
-mwifiex_associate(struct mwifiex_private *priv,
-		  void *wait_queue, struct mwifiex_bssdescriptor *bss_desc)
+int mwifiex_associate(struct mwifiex_private *priv,
+		      void *wait_queue, struct mwifiex_bssdescriptor *bss_desc)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u8 current_bssid[MWIFIEX_MAC_ADDR_LENGTH];
 
 	ENTER();
@@ -1577,7 +1573,7 @@ mwifiex_associate(struct mwifiex_private *priv,
 	if ((priv->bss_mode != MWIFIEX_BSS_MODE_INFRA) ||
 	    (bss_desc->bss_mode != MWIFIEX_BSS_MODE_INFRA)) {
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	memcpy(&current_bssid,
@@ -1602,11 +1598,11 @@ mwifiex_associate(struct mwifiex_private *priv,
  *
  * It calls the command preparation routine to send the command to firmware.
  */
-enum mwifiex_status
+int
 mwifiex_adhoc_start(struct mwifiex_private *priv,
 		    void *wait_queue, struct mwifiex_802_11_ssid *adhoc_ssid)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -1631,11 +1627,10 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
  * It calls the command preparation routine to send the command to firmware,
  * if already not connected to the requested SSID.
  */
-enum mwifiex_status
-mwifiex_adhoc_join(struct mwifiex_private *priv,
-		   void *wait_queue, struct mwifiex_bssdescriptor *bss_desc)
+int mwifiex_adhoc_join(struct mwifiex_private *priv,
+		       void *wait_queue, struct mwifiex_bssdescriptor *bss_desc)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -1659,7 +1654,7 @@ mwifiex_adhoc_join(struct mwifiex_private *priv,
 		       "not attempting to re-join\n");
 
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	PRINTM(MINFO, "curr_bss_params.channel = %d\n",
@@ -1682,12 +1677,11 @@ mwifiex_adhoc_join(struct mwifiex_private *priv,
  * In case of infra made, it sends deauthentication request, and
  * in case of ad-hoc mode, a stop network request is sent to the firmware.
  */
-enum mwifiex_status
-mwifiex_deauthenticate(struct mwifiex_private *priv,
-		       struct mwifiex_wait_queue *wait, u8 *mac)
+int mwifiex_deauthenticate(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait, u8 *mac)
 {
 	u8 mac_address[MWIFIEX_MAC_ADDR_LENGTH];
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u8 zero_mac[] = { 0, 0, 0, 0, 0, 0 };
 
 	ENTER();
@@ -1718,16 +1712,16 @@ mwifiex_deauthenticate(struct mwifiex_private *priv,
 					HostCmd_ACT_GEN_SET,
 					0, wait, &mac_address);
 
-			if (ret == MWIFIEX_STATUS_SUCCESS && wait)
-				ret = MWIFIEX_STATUS_PENDING;
+			if (!ret && wait)
+				ret = -EINPROGRESS;
 
 		} else if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS) {
 			ret = mwifiex_prepare_cmd(priv,
 					HostCmd_CMD_802_11_AD_HOC_STOP,
 					HostCmd_ACT_GEN_SET, 0, wait, NULL);
 
-			if (ret == MWIFIEX_STATUS_SUCCESS && wait)
-				ret = MWIFIEX_STATUS_PENDING;
+			if (!ret && wait)
+				ret = -EINPROGRESS;
 		}
 	}
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 3578206..812c1e6 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -68,12 +68,11 @@ u32 ifdbg;
  * In case of any errors during inittialization, this function also ensures
  * proper cleanup before exiting.
  */
-static enum mwifiex_status
-mwifiex_register(void *card,
-		 struct mwifiex_if_ops *if_ops,
-		 struct mwifiex_device *mdevice, void **padapter)
+static int mwifiex_register(void *card,
+			    struct mwifiex_if_ops *if_ops,
+			    struct mwifiex_device *mdevice, void **padapter)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = NULL;
 	u8 i = 0;
 
@@ -82,7 +81,7 @@ mwifiex_register(void *card,
 	adapter = kzalloc(sizeof(struct mwifiex_adapter), GFP_KERNEL);
 	/* Allocate memory for adapter structure */
 	if (!adapter) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit_register;
 	}
 
@@ -94,8 +93,8 @@ mwifiex_register(void *card,
 
 	/* card specific initialization has been deferred until now .. */
 	ret = adapter->if_ops.init_if(adapter);
-	if (ret != MWIFIEX_STATUS_SUCCESS) {
-		ret = MWIFIEX_STATUS_FAILURE;
+	if (ret) {
+		ret = -1;
 		goto error;
 	}
 
@@ -112,7 +111,7 @@ mwifiex_register(void *card,
 				PRINTM(MERROR,
 				       "%s: failed to allocate priv[]\n",
 				       __func__);
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 				goto error;
 			}
 
@@ -144,8 +143,8 @@ mwifiex_register(void *card,
 	}
 
 	/* Initialize lock variables */
-	if (mwifiex_init_lock_list(adapter) != MWIFIEX_STATUS_SUCCESS) {
-		ret = MWIFIEX_STATUS_FAILURE;
+	if (mwifiex_init_lock_list(adapter)) {
+		ret = -1;
 		goto error;
 	}
 
@@ -182,8 +181,7 @@ exit_register:
  *      - Free private structures
  *      - Free adapter structure
  */
-static enum mwifiex_status
-mwifiex_unregister(struct mwifiex_adapter *adapter)
+static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 {
 	s32 i = 0;
 
@@ -202,7 +200,7 @@ mwifiex_unregister(struct mwifiex_adapter *adapter)
 	kfree(adapter);
 	LEAVE();
 
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -220,10 +218,9 @@ mwifiex_unregister(struct mwifiex_adapter *adapter)
  *      - Execute pending commands
  *      - Transmit pending data packets
  */
-enum mwifiex_status
-mwifiex_main_process(struct mwifiex_adapter *adapter)
+int mwifiex_main_process(struct mwifiex_adapter *adapter)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	unsigned long flags;
 
 	ENTER();
@@ -317,9 +314,8 @@ process_start:
 			continue;
 
 		if (!adapter->cmd_sent && !adapter->curr_cmd) {
-			if (mwifiex_exec_next_cmd(adapter) ==
-			    MWIFIEX_STATUS_FAILURE) {
-				ret = MWIFIEX_STATUS_FAILURE;
+			if (mwifiex_exec_next_cmd(adapter) == -1) {
+				ret = -1;
 				break;
 			}
 		}
@@ -339,11 +335,10 @@ process_start:
 		if (adapter->delay_null_pkt && !adapter->cmd_sent &&
 		    !adapter->curr_cmd && !is_command_pending(adapter)
 		    && mwifiex_wmm_lists_empty(adapter)) {
-			if (mwifiex_send_null_packet
+			if (!mwifiex_send_null_packet
 			    (mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
 			     MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET |
-			     MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET)
-			    == MWIFIEX_STATUS_SUCCESS) {
+			     MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET)) {
 				adapter->delay_null_pkt = false;
 				adapter->ps_state = PS_STATE_SLEEP;
 			}
@@ -371,10 +366,10 @@ exit_main_proc:
  * The main work includes allocating and initializing the adapter structure
  * and initializing the private structures.
  */
-static enum mwifiex_status
+static int
 mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	int i;
 	struct mwifiex_device device;
 	struct mwifiex_drv_mode *drv_mode_ptr;
@@ -393,7 +388,7 @@ mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
 	if (!drv_mode_ptr) {
 		PRINTM(MERROR, "Invalid drv_mode_ptr=%d\n", drv_mode);
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	memset(&device, 0, sizeof(struct mwifiex_device));
@@ -409,9 +404,8 @@ mwifiex_init_sw(void *card, struct mwifiex_if_ops *if_ops, void **pmwifiex)
 		device.bss_attr[i].bss_num = drv_mode_ptr->bss_attr[i].bss_num;
 	}
 
-	if (mwifiex_register(card, if_ops, &device, pmwifiex)
-	    != MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_FAILURE;
+	if (mwifiex_register(card, if_ops, &device, pmwifiex))
+		ret = -1;
 
 	LEAVE();
 	return ret;
@@ -447,10 +441,9 @@ static void mwifiex_free_adapter(struct mwifiex_adapter *adapter)
  *      - Initialize the private structures
  *      - Issue the init commands to firmware
  */
-static enum mwifiex_status
-mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
+static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	int err;
 	struct mwifiex_fw_image fw;
 
@@ -476,23 +469,23 @@ mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 	if (err < 0) {
 		PRINTM(MFATAL, "request_firmware() failed, error code =%#x\n",
 		       err);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 	fw.fw_buf = (u8 *) adapter->firmware->data;
 	fw.fw_len = adapter->firmware->size;
 
 	ret = mwifiex_dnld_fw(adapter, &fw);
-	if (ret == MWIFIEX_STATUS_FAILURE)
+	if (ret == -1)
 		goto done;
 
 	PRINTM(MMSG, "WLAN FW is active\n");
 
 	adapter->init_wait_q_woken = false;
 	ret = mwifiex_init_fw(adapter);
-	if (ret == MWIFIEX_STATUS_FAILURE) {
+	if (ret == -1) {
 		goto done;
-	} else if (ret == MWIFIEX_STATUS_SUCCESS) {
+	} else if (!ret) {
 		adapter->hw_status = MWIFIEX_HW_STATUS_READY;
 		goto done;
 	}
@@ -500,16 +493,16 @@ mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 	wait_event_interruptible(adapter->init_wait_q,
 				 adapter->init_wait_q_woken);
 	if (adapter->hw_status != MWIFIEX_HW_STATUS_READY) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
-	ret = MWIFIEX_STATUS_SUCCESS;
+	ret = 0;
 
 done:
 	if (adapter->firmware)
 		release_firmware(adapter->firmware);
-	if (ret != MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_FAILURE;
+	if (ret)
+		ret = -1;
 	LEAVE();
 	return ret;
 }
@@ -671,7 +664,7 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
 
 	HEXDUMP("addr:", (u8 *) hw_addr->sa_data, ETH_ALEN);
 	memcpy(priv->curr_addr, hw_addr->sa_data, ETH_ALEN);
-	if (MWIFIEX_STATUS_SUCCESS != mwifiex_request_set_mac_address(priv)) {
+	if (mwifiex_request_set_mac_address(priv)) {
 		PRINTM(MERROR, "Set MAC address failed\n");
 		ret = -EFAULT;
 		goto done;
@@ -904,18 +897,17 @@ error:
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-enum mwifiex_status
-mwifiex_shutdown_fw(struct mwifiex_private *priv, u8 wait_option)
+int mwifiex_shutdown_fw(struct mwifiex_private *priv, u8 wait_option)
 {
 	struct mwifiex_wait_queue *wait = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 
 	ENTER();
 
 	/* Allocate an IOCTL request buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
-		status = MWIFIEX_STATUS_FAILURE;
+		status = -1;
 		goto done;
 	}
 
@@ -1148,7 +1140,7 @@ int
 mwifiex_add_card(void *card, struct semaphore *sem,
 		 struct mwifiex_if_ops *if_ops)
 {
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	int i;
 	struct mwifiex_adapter *adapter = NULL;
 	struct mwifiex_drv_mode *drv_mode_info = &mwifiex_drv_mode_tbl[0];
@@ -1158,8 +1150,7 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	if (down_interruptible(sem))
 		goto exit_sem_err;
 
-	if (mwifiex_init_sw(card, if_ops, (void **) &adapter)
-	    != MWIFIEX_STATUS_SUCCESS) {
+	if (mwifiex_init_sw(card, if_ops, (void **) &adapter)) {
 		PRINTM(MFATAL, "Software Init Failed\n");
 		goto err_init_sw;
 	}
@@ -1183,13 +1174,13 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 
 	/* Register the device. Fill up the private data structure with relevant
 	   information from the card and request for the required IRQ. */
-	if (adapter->if_ops.register_dev(adapter) != MWIFIEX_STATUS_SUCCESS) {
+	if (adapter->if_ops.register_dev(adapter)) {
 		PRINTM(MFATAL, "Failed to register mwifiex device!\n");
 		goto err_registerdev;
 	}
 
 	/* Init FW and HW */
-	if (MWIFIEX_STATUS_SUCCESS != mwifiex_init_hw_fw(adapter)) {
+	if (mwifiex_init_hw_fw(adapter)) {
 		PRINTM(MFATAL, "Firmware Init Failed\n");
 		goto err_init_fw;
 	}
@@ -1198,17 +1189,17 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 		if (!mwifiex_add_interface
 		    (adapter, i,
 		     adapter->drv_mode->bss_attr[i].bss_type)) {
-			status = MWIFIEX_STATUS_FAILURE;
+			status = -1;
 			break;
 		}
 	}
-	if (status != MWIFIEX_STATUS_SUCCESS)
+	if (status)
 		goto err_add_intf;
 
 	up(sem);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 
 err_add_intf:
 	for (i = 0; i < adapter->priv_num; i++)
@@ -1226,7 +1217,7 @@ err_kmalloc:
 		PRINTM(MINFO, "shutdown mwifiex\n");
 		adapter->init_wait_q_woken = false;
 		status = mwifiex_shutdown_drv(adapter);
-		if (status == MWIFIEX_STATUS_PENDING)
+		if (status == -EINPROGRESS)
 			wait_event_interruptible(adapter->init_wait_q,
 						 adapter->init_wait_q_woken);
 	}
@@ -1238,7 +1229,7 @@ err_init_sw:
 
 exit_sem_err:
 	LEAVE();
-	return MWIFIEX_STATUS_FAILURE;
+	return -1;
 }
 EXPORT_SYMBOL_GPL(mwifiex_add_card);
 
@@ -1253,11 +1244,10 @@ EXPORT_SYMBOL_GPL(mwifiex_add_card);
  *      - Unregister the device
  *      - Free the adapter structure
  */
-enum mwifiex_status
-mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
+int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 {
 	struct mwifiex_private *priv = NULL;
-	enum mwifiex_status status;
+	int status;
 	int i;
 
 	ENTER();
@@ -1285,7 +1275,7 @@ mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	PRINTM(MCMND, "mwifiex_shutdown_drv.....\n");
 	adapter->init_wait_q_woken = false;
 	status = mwifiex_shutdown_drv(adapter);
-	if (status == MWIFIEX_STATUS_PENDING)
+	if (status == -EINPROGRESS)
 		wait_event_interruptible(adapter->init_wait_q,
 					 adapter->init_wait_q_woken);
 	PRINTM(MCMND, "mwifiex_shutdown_drv done!\n");
@@ -1316,7 +1306,7 @@ exit_remove:
 	up(sem);
 exit_sem_err:
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mwifiex_remove_card);
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index ae75e8d..e5fd6e0 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -491,21 +491,19 @@ struct cmd_ctrl_node {
 };
 
 struct mwifiex_if_ops {
-	enum mwifiex_status (*init_if) (struct mwifiex_adapter *);
+	int (*init_if) (struct mwifiex_adapter *);
 	void (*cleanup_if) (struct mwifiex_adapter *);
-	enum mwifiex_status (*check_fw_status) (struct mwifiex_adapter *, u32,
-						int *);
-	enum mwifiex_status (*prog_fw) (struct mwifiex_adapter *,
-					struct mwifiex_fw_image *);
-	enum mwifiex_status (*register_dev) (struct mwifiex_adapter *);
+	int (*check_fw_status) (struct mwifiex_adapter *, u32, int *);
+	int (*prog_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
+	int (*register_dev) (struct mwifiex_adapter *);
 	void (*unregister_dev) (struct mwifiex_adapter *);
-	enum mwifiex_status (*enable_int) (struct mwifiex_adapter *);
-	enum mwifiex_status (*process_int_status) (struct mwifiex_adapter *);
-	enum mwifiex_status (*host_to_card) (struct mwifiex_adapter *, u8,
-					     u8 *payload, u32 pkt_len,
-					     struct mwifiex_tx_param *);
-	enum mwifiex_status (*wakeup) (struct mwifiex_adapter *);
-	enum mwifiex_status (*wakeup_complete) (struct mwifiex_adapter *);
+	int (*enable_int) (struct mwifiex_adapter *);
+	int (*process_int_status) (struct mwifiex_adapter *);
+	int (*host_to_card) (struct mwifiex_adapter *, u8,
+			     u8 *payload, u32 pkt_len,
+			     struct mwifiex_tx_param *);
+	int (*wakeup) (struct mwifiex_adapter *);
+	int (*wakeup_complete) (struct mwifiex_adapter *);
 
 	void (*update_mp_end_port) (struct mwifiex_adapter *, u16);
 	int (*sdio_mpa_ctrl) (struct mwifiex_private *, u8, int *, int);
@@ -627,58 +625,52 @@ struct mwifiex_adapter {
 	u32 arp_filter_size;
 };
 
-enum mwifiex_status mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
+int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
 void mwifiex_free_lock_list(struct mwifiex_adapter *adapter);
 
-enum mwifiex_status mwifiex_init_fw(struct mwifiex_adapter *adapter);
+int mwifiex_init_fw(struct mwifiex_adapter *adapter);
 
-enum mwifiex_status mwifiex_init_fw_complete(struct mwifiex_adapter *adapter);
+int mwifiex_init_fw_complete(struct mwifiex_adapter *adapter);
 
-enum mwifiex_status mwifiex_shutdown_drv(struct mwifiex_adapter *adapter);
+int mwifiex_shutdown_drv(struct mwifiex_adapter *adapter);
 
-enum mwifiex_status mwifiex_shutdown_fw_complete(struct mwifiex_adapter
-						 *adapter);
+int mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter);
 
-enum mwifiex_status mwifiex_dnld_fw(struct mwifiex_adapter *,
-				    struct mwifiex_fw_image *);
+int mwifiex_dnld_fw(struct mwifiex_adapter *, struct mwifiex_fw_image *);
 
-enum mwifiex_status mwifiex_recv_complete(struct mwifiex_adapter *,
-					  struct sk_buff *skb,
-					  enum mwifiex_status status);
+int mwifiex_recv_complete(struct mwifiex_adapter *,
+			  struct sk_buff *skb,
+			  int status);
 
-enum mwifiex_status mwifiex_recv_packet(struct mwifiex_adapter *,
-					struct sk_buff *skb);
+int mwifiex_recv_packet(struct mwifiex_adapter *, struct sk_buff *skb);
 
 void mwifiex_init_adapter(struct mwifiex_adapter *adapter);
 void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv);
 
-enum mwifiex_status mwifiex_process_event(struct mwifiex_adapter *adapter);
+int mwifiex_process_event(struct mwifiex_adapter *adapter);
 
-enum mwifiex_status mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
-				   struct mwifiex_wait_queue *ioctl_wq,
-				   enum mwifiex_status status);
+int mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
+			   struct mwifiex_wait_queue *ioctl_wq,
+			   int status);
 
-enum mwifiex_status mwifiex_prepare_cmd(struct mwifiex_private *priv,
-					uint16_t cmd_no,
-					u16 cmd_action,
-					u32 cmd_oid,
-					void *wait_queue, void *data_buf);
+int mwifiex_prepare_cmd(struct mwifiex_private *priv,
+			uint16_t cmd_no,
+			u16 cmd_action,
+			u32 cmd_oid,
+			void *wait_queue, void *data_buf);
 
 void mwifiex_cmd_timeout_func(unsigned long function_context);
 
-enum mwifiex_status mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter
-						     *adapter,
-						     struct mwifiex_wait_queue
-						     *wait_queue,
-						     u32 func_init_shutdown);
-enum mwifiex_status mwifiex_get_debug_info(struct mwifiex_private *,
-					   struct mwifiex_debug_info *);
-
-enum mwifiex_status mwifiex_set_ewpa_mode_from_passphrase(
-					struct mwifiex_private *priv,
-					struct mwifiex_ds_passphrase *);
-enum mwifiex_status mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter);
-enum mwifiex_status mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter);
+int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
+				     struct mwifiex_wait_queue *wait_queue,
+				     u32 func_init_shutdown);
+int mwifiex_get_debug_info(struct mwifiex_private *,
+			   struct mwifiex_debug_info *);
+
+int mwifiex_set_ewpa_mode_from_passphrase(struct mwifiex_private *priv,
+					  struct mwifiex_ds_passphrase *);
+int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter);
+int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 				  struct mwifiex_wait_queue *ioctl_wq);
@@ -690,130 +682,107 @@ void mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 				     struct cmd_ctrl_node *cmd_node,
 				     u32 addtail);
 
-enum mwifiex_status mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter);
-enum mwifiex_status mwifiex_process_cmdresp(struct mwifiex_adapter *adapter);
-enum mwifiex_status mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
-					     struct sk_buff *skb);
-enum mwifiex_status mwifiex_process_tx(struct mwifiex_private *priv,
-				       struct sk_buff *skb,
-				       struct mwifiex_tx_param *tx_param);
-enum mwifiex_status mwifiex_send_null_packet(struct mwifiex_private *priv,
-					     u8 flags);
-enum mwifiex_status mwifiex_write_data_complete(struct mwifiex_adapter
-						*adapter,
-						struct sk_buff *skb,
-						enum mwifiex_status status);
-enum mwifiex_status mwifiex_recv_packet_complete(struct mwifiex_adapter *,
-						 struct sk_buff *skb,
-						 enum mwifiex_status status);
+int mwifiex_exec_next_cmd(struct mwifiex_adapter *adapter);
+int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter);
+int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
+			     struct sk_buff *skb);
+int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
+		       struct mwifiex_tx_param *tx_param);
+int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags);
+int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
+				struct sk_buff *skb, int status);
+int mwifiex_recv_packet_complete(struct mwifiex_adapter *,
+				 struct sk_buff *skb, int status);
 void mwifiex_clean_txrx(struct mwifiex_private *priv);
 u8 mwifiex_check_last_packet_indication(struct mwifiex_private *priv);
 void mwifiex_check_ps_cond(struct mwifiex_adapter *adapter);
 void mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *, u8 *,
 					u32);
-enum mwifiex_status mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
-					       struct host_cmd_ds_command *cmd,
-					       u16 cmd_action,
-					       uint16_t ps_bitmap,
-					       void *data_buf);
-enum mwifiex_status mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
-					       struct host_cmd_ds_command *resp,
-					       void *data_buf);
+int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *cmd,
+			       u16 cmd_action, uint16_t ps_bitmap,
+			       void *data_buf);
+int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *resp,
+			       void *data_buf);
 void mwifiex_process_hs_config(struct mwifiex_adapter *adapter);
 void mwifiex_hs_activated_event(struct mwifiex_private *priv,
 					u8 activated);
-enum mwifiex_status mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
-					      struct host_cmd_ds_command *resp);
+int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp);
 void mwifiex_host_sleep_wakeup_event(struct mwifiex_private *priv);
-enum mwifiex_status mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
-					      struct sk_buff *skb);
-enum mwifiex_status mwifiex_sta_prepare_cmd(struct mwifiex_private *,
-					    uint16_t cmd_no,
-					    u16 cmd_action, u32 cmd_oid,
-					    void *data_buf, void *cmd_buf);
-enum mwifiex_status mwifiex_process_sta_cmdresp(struct mwifiex_private *,
-						u16 cmdresp_no,
-						void *cmd_buf, void *ioctl);
-enum mwifiex_status mwifiex_process_sta_rx_packet(struct mwifiex_adapter *,
-						  struct sk_buff *skb);
-enum mwifiex_status mwifiex_process_sta_event(struct mwifiex_private *);
+int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
+			      struct sk_buff *skb);
+int mwifiex_sta_prepare_cmd(struct mwifiex_private *, uint16_t cmd_no,
+			    u16 cmd_action, u32 cmd_oid,
+			    void *data_buf, void *cmd_buf);
+int mwifiex_process_sta_cmdresp(struct mwifiex_private *, u16 cmdresp_no,
+				void *cmd_buf, void *ioctl);
+int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *,
+				  struct sk_buff *skb);
+int mwifiex_process_sta_event(struct mwifiex_private *);
 void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
-enum mwifiex_status mwifiex_sta_init_cmd(struct mwifiex_private *,
-						u8 first_sta);
-enum mwifiex_status mwifiex_scan_networks(struct mwifiex_private *priv,
-					  void *wait_queue, u16 action,
-					  const struct mwifiex_user_scan_cfg
-					  *user_scan_in,
-					  struct mwifiex_scan_resp *);
-enum mwifiex_status mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
-					void *wait, u16 action,
-					struct mwifiex_802_11_ssid *ssid,
-					struct mwifiex_scan_resp *scan_resp);
-enum mwifiex_status mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
-					    struct host_cmd_ds_command *cmd,
-					    void *data_buf);
+int mwifiex_sta_init_cmd(struct mwifiex_private *, u8 first_sta);
+int mwifiex_scan_networks(struct mwifiex_private *priv, void *wait_queue,
+			  u16 action,
+			  const struct mwifiex_user_scan_cfg
+			  *user_scan_in, struct mwifiex_scan_resp *);
+int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
+			       void *wait, u16 action,
+			       struct mwifiex_802_11_ssid *ssid,
+			       struct mwifiex_scan_resp *scan_resp);
+int mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *cmd,
+			    void *data_buf);
 void mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 			    struct cmd_ctrl_node *cmd_node);
-enum mwifiex_status mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
-					    struct host_cmd_ds_command *resp,
-					    void *wait_queue);
+int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *resp,
+			    void *wait_queue);
 s32 mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
 				struct mwifiex_802_11_ssid *ssid, u8 *bssid,
 				u32 mode);
 s32 mwifiex_find_bssid_in_list(struct mwifiex_private *priv, u8 *bssid,
 				 u32 mode);
-enum mwifiex_status mwifiex_find_best_network(struct mwifiex_private *priv,
-					      struct mwifiex_ssid_bssid
-					      *req_ssid_bssid);
+int mwifiex_find_best_network(struct mwifiex_private *priv,
+			      struct mwifiex_ssid_bssid *req_ssid_bssid);
 s32 mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
 		       struct mwifiex_802_11_ssid *ssid2);
-enum mwifiex_status mwifiex_associate(struct mwifiex_private *priv,
-				      void *wait_queue,
-				      struct mwifiex_bssdescriptor *bss_desc);
-enum mwifiex_status mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
-						 struct host_cmd_ds_command
-						 *cmd, void *data_buf);
-enum mwifiex_status mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
-						 struct host_cmd_ds_command
-						 *resp, void *wait_queue);
+int mwifiex_associate(struct mwifiex_private *priv, void *wait_queue,
+		      struct mwifiex_bssdescriptor *bss_desc);
+int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
+				 struct host_cmd_ds_command
+				 *cmd, void *data_buf);
+int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
+				 struct host_cmd_ds_command *resp,
+				 void *wait_queue);
 void mwifiex_reset_connect_state(struct mwifiex_private *priv);
 void mwifiex_2040_coex_event(struct mwifiex_private *priv);
 u8 mwifiex_band_to_radio_type(u8 band);
-enum mwifiex_status mwifiex_deauthenticate(struct mwifiex_private *priv,
-					   struct mwifiex_wait_queue
-					   *wait_queue,
-					   u8 *mac);
-enum mwifiex_status mwifiex_adhoc_start(struct mwifiex_private *priv,
-					void *wait_queue,
-					struct mwifiex_802_11_ssid
-					*adhoc_ssid);
-enum mwifiex_status mwifiex_adhoc_join(struct mwifiex_private *priv,
-				       void *wait_queue,
-				       struct mwifiex_bssdescriptor *bss_desc);
-enum mwifiex_status mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private
-						    *priv,
-						    struct host_cmd_ds_command
-						    *cmd, void *data_buf);
-enum mwifiex_status mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private
-						   *priv,
-						   struct host_cmd_ds_command
-						   *cmd, void *data_buf);
-enum mwifiex_status mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
-					      struct host_cmd_ds_command *resp,
-					      void *wait_queue);
-enum mwifiex_status mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private
-						     *priv,
-						     struct host_cmd_ds_command
-						     *cmd, void *data_buf);
-enum mwifiex_status mwifiex_cmd_802_11d_domain_info(struct mwifiex_private
-						*priv,
-						struct host_cmd_ds_command
-						*cmd,
-						u16 cmd_action);
-enum mwifiex_status mwifiex_ret_802_11d_domain_info(struct mwifiex_private
-						*priv,
-						struct host_cmd_ds_command
-						*resp);
+int mwifiex_deauthenticate(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait_queue,
+			   u8 *mac);
+int mwifiex_adhoc_start(struct mwifiex_private *priv, void *wait_queue,
+			struct mwifiex_802_11_ssid *adhoc_ssid);
+int mwifiex_adhoc_join(struct mwifiex_private *priv, void *wait_queue,
+		       struct mwifiex_bssdescriptor *bss_desc);
+int mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
+				    struct host_cmd_ds_command *cmd,
+				    void *data_buf);
+int mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *cmd,
+				   void *data_buf);
+int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
+			      struct host_cmd_ds_command *resp,
+			      void *wait_queue);
+int mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
+				     struct host_cmd_ds_command *cmd,
+				     void *data_buf);
+int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
+				    struct host_cmd_ds_command *cmd,
+				    u16 cmd_action);
+int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
+				    struct host_cmd_ds_command *resp);
 struct mwifiex_chan_freq_power *
 			mwifiex_get_cfp_by_band_and_channel_from_cfg80211(
 						struct mwifiex_private *priv,
@@ -839,10 +808,10 @@ extern u16 region_code_index[MWIFIEX_MAX_REGION_CODE];
 void mwifiex_save_curr_bcn(struct mwifiex_private *priv);
 void mwifiex_restore_curr_bcn(struct mwifiex_private *priv);
 void mwifiex_free_curr_bcn(struct mwifiex_private *priv);
-enum mwifiex_status mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
-					struct host_cmd_ds_command *cmd);
-enum mwifiex_status mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
-					    struct host_cmd_ds_command *resp);
+int mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *cmd);
+int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *resp);
 int is_command_pending(struct mwifiex_adapter *adapter);
 
 /*
@@ -934,7 +903,7 @@ struct mwifiex_wait_queue *mwifiex_alloc_fill_wait_queue(
 				u8 wait_option);
 struct mwifiex_private *mwifiex_bss_index_to_priv(struct mwifiex_adapter
 						*adapter, u8 bss_index);
-enum mwifiex_status mwifiex_shutdown_fw(struct mwifiex_private *, u8);
+int mwifiex_shutdown_fw(struct mwifiex_private *, u8);
 
 char *mwifiex_strsep(char **s, char delim, char esc);
 int mwifiex_atox(char *a);
@@ -942,68 +911,58 @@ void mwifiex_mac2u8(u8 *mac_addr, char *buf);
 int mwifiex_ascii2hex(u8 *d, char *s, u32 dlen);
 
 int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *);
-enum mwifiex_status mwifiex_remove_card(struct mwifiex_adapter *,
-					struct semaphore *);
+int mwifiex_remove_card(struct mwifiex_adapter *, struct semaphore *);
 
 void mwifiex_get_version(struct mwifiex_adapter *adapter, char *version,
 			 int maxlen);
-enum mwifiex_status mwifiex_request_set_mac_address(struct mwifiex_private
-						    *priv);
+int mwifiex_request_set_mac_address(struct mwifiex_private *priv);
 void mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 					struct net_device *dev);
-enum mwifiex_status mwifiex_request_ioctl(struct mwifiex_private *priv,
-					  struct mwifiex_wait_queue *req,
-					  enum mwifiex_status, u8 wait_option);
-enum mwifiex_status mwifiex_disconnect(struct mwifiex_private *, u8, u8 *);
-enum mwifiex_status mwifiex_bss_start(struct mwifiex_private *priv,
-				      u8 wait_option,
-				      struct mwifiex_ssid_bssid *ssid_bssid);
-enum mwifiex_status mwifiex_set_get_hs_params(struct mwifiex_private *priv,
-					      u16 action, u8 wait_option,
-					      struct mwifiex_ds_hs_cfg *hscfg);
-enum mwifiex_status mwifiex_cancel_hs(struct mwifiex_private *priv,
-				      u8 wait_option);
+int mwifiex_request_ioctl(struct mwifiex_private *priv,
+			  struct mwifiex_wait_queue *req,
+			  int, u8 wait_option);
+int mwifiex_disconnect(struct mwifiex_private *, u8, u8 *);
+int mwifiex_bss_start(struct mwifiex_private *priv,
+		      u8 wait_option,
+		      struct mwifiex_ssid_bssid *ssid_bssid);
+int mwifiex_set_get_hs_params(struct mwifiex_private *priv,
+			      u16 action, u8 wait_option,
+			      struct mwifiex_ds_hs_cfg *hscfg);
+int mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option);
 int mwifiex_enable_hs(struct mwifiex_adapter *adapter);
 int mwifiex_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
 			   bool bdeep_sleep, u16 idletime);
 void mwifiex_process_ioctl_resp(struct mwifiex_private *priv,
 				struct mwifiex_wait_queue *req);
 u32 mwifiex_get_mode(struct mwifiex_private *priv, u8 wait_option);
-enum mwifiex_status mwifiex_get_signal_info(struct mwifiex_private *priv,
-					    u8 wait_option,
-					    struct mwifiex_ds_get_signal
-					    *signal);
-enum mwifiex_status mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
-					      struct mwifiex_rate_cfg *rate);
-enum mwifiex_status mwifiex_get_channel_list(struct mwifiex_private *priv,
-					     u8 wait_option,
-					     struct mwifiex_chan_list
-					     *chanlist);
-enum mwifiex_status mwifiex_get_scan_table(struct mwifiex_private *priv,
-					   u8 wait_option,
-					   struct mwifiex_scan_resp *scanresp);
-enum mwifiex_status mwifiex_get_auth_mode(struct mwifiex_private *priv,
-					  u8 wait_option, u32 *auth_mode);
-enum mwifiex_status mwifiex_set_encrypt_mode(struct mwifiex_private *priv,
-					     u8 wait_option,
-					     u32 encrypt_mode);
-enum mwifiex_status mwifiex_get_encrypt_mode(struct mwifiex_private *priv,
-					     u8 wait_option,
-					     u32 *encrypt_mode);
-enum mwifiex_status mwifiex_enable_wep_key(struct mwifiex_private *priv,
-					   u8 wait_option);
-enum mwifiex_status mwifiex_find_best_bss(struct mwifiex_private *priv,
-					  u8 wait_option,
-					  struct mwifiex_ssid_bssid
-					  *ssid_bssid);
-enum mwifiex_status mwifiex_request_scan(struct mwifiex_private *priv,
-					 u8 wait_option,
-					 struct mwifiex_802_11_ssid *req_ssid);
-enum mwifiex_status mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
-					struct mwifiex_user_scan_cfg
-					*scan_req);
-enum mwifiex_status mwifiex_change_adhoc_chan(struct mwifiex_private *priv,
-					      int channel);
+int mwifiex_get_signal_info(struct mwifiex_private *priv,
+			    u8 wait_option,
+			    struct mwifiex_ds_get_signal *signal);
+int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
+			      struct mwifiex_rate_cfg *rate);
+int mwifiex_get_channel_list(struct mwifiex_private *priv,
+			     u8 wait_option,
+			     struct mwifiex_chan_list *chanlist);
+int mwifiex_get_scan_table(struct mwifiex_private *priv,
+			   u8 wait_option,
+			   struct mwifiex_scan_resp *scanresp);
+int mwifiex_get_auth_mode(struct mwifiex_private *priv,
+			  u8 wait_option, u32 *auth_mode);
+int mwifiex_set_encrypt_mode(struct mwifiex_private *priv,
+			     u8 wait_option,
+			     u32 encrypt_mode);
+int mwifiex_get_encrypt_mode(struct mwifiex_private *priv,
+			     u8 wait_option,
+			     u32 *encrypt_mode);
+int mwifiex_enable_wep_key(struct mwifiex_private *priv, u8 wait_option);
+int mwifiex_find_best_bss(struct mwifiex_private *priv, u8 wait_option,
+			  struct mwifiex_ssid_bssid *ssid_bssid);
+int mwifiex_request_scan(struct mwifiex_private *priv,
+			 u8 wait_option,
+			 struct mwifiex_802_11_ssid *req_ssid);
+int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
+				struct mwifiex_user_scan_cfg *scan_req);
+int mwifiex_change_adhoc_chan(struct mwifiex_private *priv, int channel);
 int mwifiex_set_radio(struct mwifiex_private *priv, u8 option);
 
 int mwifiex_drv_get_mode(struct mwifiex_private *priv, u8 wait_option);
@@ -1089,7 +1048,7 @@ int mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter,
 
 int mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm);
 
-enum mwifiex_status mwifiex_main_process(struct mwifiex_adapter *);
+int mwifiex_main_process(struct mwifiex_adapter *);
 
 int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
 			   struct mwifiex_ds_passphrase *ds_passphrase);
@@ -1097,120 +1056,91 @@ int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
 int mwifiex_get_esupp_mode(struct mwifiex_private *priv,
 			   struct mwifiex_ds_esupp_mode *esupp_mode);
 
-enum mwifiex_status
-mwifiex_bss_ioctl_start(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_ssid_bssid *);
-enum mwifiex_status
-mwifiex_bss_ioctl_stop(struct mwifiex_private *,
-			struct mwifiex_wait_queue *, u8 *);
-enum mwifiex_status
-mwifiex_bss_ioctl_mode(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			u16 action, int *mode);
-enum mwifiex_status
-mwifiex_bss_ioctl_channel(struct mwifiex_private *,
-			  u16 action,
-			  struct mwifiex_chan_freq_power *cfp);
-enum mwifiex_status
-mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			u16 action,
-			struct mwifiex_multicast_list *);
-enum mwifiex_status
-mwifiex_bss_ioctl_mac_address(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			u8 action, u8 *mac);
-enum mwifiex_status
-mwifiex_bss_ioctl_find_bss(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_ssid_bssid *);
-enum mwifiex_status
-mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			u16 action, u16 *chan);
-enum mwifiex_status
-mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *,
-			     u16 action,
-			     struct mwifiex_ds_band_cfg *);
-enum mwifiex_status
-mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			u16 action, u32 *);
-enum mwifiex_status
-mwifiex_snmp_mib_ioctl(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			u32 cmd_oid, u16 action, u32 *value);
-enum mwifiex_status
-mwifiex_get_info_stats(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_ds_get_stats *);
-enum mwifiex_status
-mwifiex_get_info_signal(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_ds_get_signal *);
-enum mwifiex_status
-mwifiex_get_info_ver_ext(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_ver_ext *);
-enum mwifiex_status
-mwifiex_get_bss_info(struct mwifiex_private *,
-			struct mwifiex_bss_info *);
-enum mwifiex_status
-mwifiex_set_auth_mode(struct mwifiex_private *, u32);
-enum mwifiex_status
-mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_ds_esupp_mode *);
-enum mwifiex_status
-mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_ds_encrypt_key *,
-			u16 action);
-enum mwifiex_status
-mwifiex_sec_ioctl_passphrase(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_ds_passphrase *,
-			u16 action);
-
-enum mwifiex_status
-mwifiex_rate_ioctl_cfg(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_rate_cfg *);
-enum mwifiex_status
-mwifiex_power_ioctl_set_power(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_power_cfg *);
-enum mwifiex_status
-mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			u32 *, u16 action);
-enum mwifiex_status
-mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *, struct
-			mwifiex_wait_queue *, u16 action,
-			struct mwifiex_ds_hs_cfg *);
-enum mwifiex_status
-mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_ds_auto_ds *,
-			u16);
-enum mwifiex_status
-mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			u32 *, u16);
-enum mwifiex_status
-mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_ds_reg_rw *,
-			u16 action);
-enum mwifiex_status
-mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *,
-			struct mwifiex_wait_queue *,
-			struct mwifiex_ds_read_eeprom *);
-enum mwifiex_status
-mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *,
-			struct mwifiex_ds_misc_gen_ie *,
-			u16 action);
+int mwifiex_bss_ioctl_start(struct mwifiex_private *,
+			    struct mwifiex_wait_queue *,
+			    struct mwifiex_ssid_bssid *);
+int mwifiex_bss_ioctl_stop(struct mwifiex_private *,
+			   struct mwifiex_wait_queue *, u8 *);
+int mwifiex_bss_ioctl_mode(struct mwifiex_private *,
+			   struct mwifiex_wait_queue *,
+			   u16 action, int *mode);
+int mwifiex_bss_ioctl_channel(struct mwifiex_private *,
+			      u16 action,
+			      struct mwifiex_chan_freq_power *cfp);
+int mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *,
+				     struct mwifiex_wait_queue *,
+				     u16 action,
+				     struct mwifiex_multicast_list *);
+int mwifiex_bss_ioctl_mac_address(struct mwifiex_private *,
+				  struct mwifiex_wait_queue *,
+				  u8 action, u8 *mac);
+int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *,
+			       struct mwifiex_wait_queue *,
+			       struct mwifiex_ssid_bssid *);
+int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *,
+				   struct mwifiex_wait_queue *,
+				   u16 action, u16 *chan);
+int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *,
+				 u16 action,
+				 struct mwifiex_ds_band_cfg *);
+int mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *,
+				struct mwifiex_wait_queue *,
+				u16 action, u32 *);
+int mwifiex_snmp_mib_ioctl(struct mwifiex_private *,
+			   struct mwifiex_wait_queue *,
+			   u32 cmd_oid, u16 action, u32 *value);
+int mwifiex_get_info_stats(struct mwifiex_private *,
+			   struct mwifiex_wait_queue *,
+			   struct mwifiex_ds_get_stats *);
+int mwifiex_get_info_signal(struct mwifiex_private *,
+			    struct mwifiex_wait_queue *,
+			    struct mwifiex_ds_get_signal *);
+int mwifiex_get_info_ver_ext(struct mwifiex_private *,
+			     struct mwifiex_wait_queue *,
+			     struct mwifiex_ver_ext *);
+int mwifiex_get_bss_info(struct mwifiex_private *,
+			 struct mwifiex_bss_info *);
+int mwifiex_set_auth_mode(struct mwifiex_private *, u32);
+int mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *,
+				 struct mwifiex_wait_queue *,
+				 struct mwifiex_ds_esupp_mode *);
+int mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *,
+				  struct mwifiex_wait_queue *,
+				  struct mwifiex_ds_encrypt_key *,
+				  u16 action);
+int mwifiex_sec_ioctl_passphrase(struct mwifiex_private *,
+				 struct mwifiex_wait_queue *,
+				 struct mwifiex_ds_passphrase *,
+				 u16 action);
+
+int mwifiex_rate_ioctl_cfg(struct mwifiex_private *,
+			   struct mwifiex_wait_queue *,
+			   struct mwifiex_rate_cfg *);
+int mwifiex_power_ioctl_set_power(struct mwifiex_private *,
+				  struct mwifiex_wait_queue *,
+				  struct mwifiex_power_cfg *);
+int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *,
+			     struct mwifiex_wait_queue *,
+			     u32 *, u16 action);
+int mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *, struct
+			    mwifiex_wait_queue *, u16 action,
+			    struct mwifiex_ds_hs_cfg *);
+int mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *,
+				struct mwifiex_wait_queue *,
+				struct mwifiex_ds_auto_ds *, u16);
+int mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *,
+			      struct mwifiex_wait_queue *,
+			      u32 *, u16);
+int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *,
+				 struct mwifiex_wait_queue *,
+				 struct mwifiex_ds_reg_rw *,
+				 u16 action);
+int mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *,
+				      struct mwifiex_wait_queue *,
+				      struct mwifiex_ds_read_eeprom *);
+int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *,
+			      struct mwifiex_ds_misc_gen_ie *,
+			      u16 action);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 4e9941e..461d3fb 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -187,20 +187,19 @@ mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-enum mwifiex_status
-mwifiex_find_best_bss(struct mwifiex_private *priv,
-		      u8 wait_option, struct mwifiex_ssid_bssid *ssid_bssid)
+int mwifiex_find_best_bss(struct mwifiex_private *priv,
+			  u8 wait_option, struct mwifiex_ssid_bssid *ssid_bssid)
 {
 	struct mwifiex_wait_queue *wait1 = NULL, *wait2 = NULL;
 	struct mwifiex_ssid_bssid tmp_ssid_bssid;
 	struct mwifiex_ds_passphrase passphrase;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u8 *mac = NULL;
 
 	ENTER();
 
 	if (!ssid_bssid) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -208,7 +207,7 @@ mwifiex_find_best_bss(struct mwifiex_private *priv,
 		/* Allocate wait request buffer */
 		wait1 = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 		if (!wait1) {
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 
@@ -222,7 +221,7 @@ mwifiex_find_best_bss(struct mwifiex_private *priv,
 						   HostCmd_ACT_GEN_GET);
 
 		ret = mwifiex_request_ioctl(priv, wait1, ret, wait_option);
-		if (ret != MWIFIEX_STATUS_SUCCESS)
+		if (ret)
 			goto done;
 		mwifiex_set_ewpa_mode_from_passphrase(priv, &passphrase);
 	}
@@ -230,7 +229,7 @@ mwifiex_find_best_bss(struct mwifiex_private *priv,
 	/* Allocate wait request buffer */
 	wait2 = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait2) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -238,7 +237,7 @@ mwifiex_find_best_bss(struct mwifiex_private *priv,
 	       sizeof(struct mwifiex_ssid_bssid));
 	ret = mwifiex_bss_ioctl_find_bss(priv, wait2, &tmp_ssid_bssid);
 
-	if (ret == MWIFIEX_STATUS_SUCCESS) {
+	if (!ret) {
 		memcpy(ssid_bssid, &tmp_ssid_bssid,
 		       sizeof(struct mwifiex_ssid_bssid));
 		mac = (u8 *) &ssid_bssid->bssid;
@@ -265,12 +264,11 @@ done:
  * Upon completion, it also generates a wireless event to notify
  * applications.
  */
-enum mwifiex_status
-mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
-		struct mwifiex_user_scan_cfg *scan_req)
+int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
+				struct mwifiex_user_scan_cfg *scan_req)
 {
 	struct mwifiex_wait_queue *wait = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
 	ENTER();
@@ -288,7 +286,7 @@ mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 
 done:
-	if (wait && (status != MWIFIEX_STATUS_PENDING))
+	if (wait && (status != -EINPROGRESS))
 		kfree(wait);
 	LEAVE();
 	return status;
@@ -303,27 +301,26 @@ done:
  * Scan command can be issued for both normal scan and specific SSID
  * scan, depending upon whether an SSID is provided or not.
  */
-enum mwifiex_status
-mwifiex_request_scan(struct mwifiex_private *priv,
-		     u8 wait_option, struct mwifiex_802_11_ssid *req_ssid)
+int mwifiex_request_scan(struct mwifiex_private *priv, u8 wait_option,
+			 struct mwifiex_802_11_ssid *req_ssid)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_wait_queue *wait = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 
 	ENTER();
 
 	if (down_interruptible(&priv->async_sem)) {
 		PRINTM(MERROR, "Acquire semaphore error, request_scan\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 	priv->scan_pending_on_block = true;
 
 	/* Allocate wait request buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -338,14 +335,12 @@ mwifiex_request_scan(struct mwifiex_private *priv,
 					       NULL, NULL);
 	}
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (status == MWIFIEX_STATUS_FAILURE) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto done;
-	}
+	if (status == -1)
+		ret = -1;
 done:
-	if ((wait) && (status != MWIFIEX_STATUS_PENDING))
+	if ((wait) && (status != -EINPROGRESS))
 		kfree(wait);
-	if (ret == MWIFIEX_STATUS_FAILURE) {
+	if (ret == -1) {
 		priv->scan_pending_on_block = false;
 		up(&priv->async_sem);
 	}
@@ -764,7 +759,7 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
  * channels supported per scan lists and sends the portion of the channel TLV,
  * along with the other TLVs, to the firmware.
  */
-static enum mwifiex_status
+static int
 mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			  void *wait_buf,
 			  u32 max_chan_per_scan,
@@ -774,7 +769,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			  *chan_tlv_out,
 			  struct mwifiex_chan_scan_param_set *scan_chan_list)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_chan_scan_param_set *tmp_chan_list;
 	struct mwifiex_chan_scan_param_set *start_chan;
 
@@ -788,7 +783,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 		PRINTM(MINFO, "Scan: Null detect: %p, %p, %p\n",
 		       scan_cfg_out, chan_tlv_out, scan_chan_list);
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	chan_tlv_out->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
@@ -901,7 +896,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			       "Total scan time %d ms is over limit (%d ms), "
 			       "scan skipped\n",
 			       total_scan_time, MWIFIEX_MAX_TOTAL_SCAN_TIME);
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			break;
 		}
 
@@ -920,10 +915,10 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 	LEAVE();
 
 	if (ret)
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 
 
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1331,12 +1326,12 @@ mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
  *      - Extended capability
  *      - Overlapping BSS scan parameters
  */
-static enum mwifiex_status
+static int
 mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				   struct mwifiex_bssdescriptor *bss_entry,
 				   u8 **beacon_info, u32 *bytes_left)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u8 element_id;
 	struct ieee_types_fh_param_set *fh_param_set;
 	struct ieee_types_ds_param_set *ds_param_set;
@@ -1375,7 +1370,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		*bytes_left = 0;
 
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	/* Initialize the current working beacon pointer for this BSS
@@ -1401,7 +1396,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	if (bytes_left_for_current_beacon < 12) {
 		PRINTM(MERROR, "InterpretIE: Not enough bytes left\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	/*
@@ -1473,7 +1468,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			PRINTM(MERROR, "InterpretIE: Error in processing IE, "
 			       "bytes left < IE length\n");
 			bytes_left_for_current_beacon = 0;
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			continue;
 		}
 
@@ -2483,11 +2478,11 @@ mwifiex_scan_delete_table_entry(struct mwifiex_private *priv, s32 table_idx)
  * This iterates through the scan table and deletes all entries that match
  * the given SSID. It also compacts the remaining scan table entries.
  */
-static enum mwifiex_status
+static int
 mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
 				     struct mwifiex_802_11_ssid *del_ssid)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_FAILURE;
+	int ret = -1;
 	s32 table_idx;
 
 	ENTER();
@@ -2504,7 +2499,7 @@ mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
 	       0) {
 		PRINTM(MINFO, "Scan: Delete SSID Entry: Found Idx = %d\n",
 		       table_idx);
-		ret = MWIFIEX_STATUS_SUCCESS;
+		ret = 0;
 		mwifiex_scan_delete_table_entry(priv, table_idx);
 	}
 
@@ -2520,13 +2515,12 @@ mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
  * order to send the appropriate scan commands to firmware to populate or
  * update the internal driver scan table.
  */
-enum mwifiex_status
-mwifiex_scan_networks(struct mwifiex_private *priv,
-		      void *wait_buf, u16 action,
-		      const struct mwifiex_user_scan_cfg *user_scan_in,
-		      struct mwifiex_scan_resp *scan_resp)
+int mwifiex_scan_networks(struct mwifiex_private *priv,
+			  void *wait_buf, u16 action,
+			  const struct mwifiex_user_scan_cfg *user_scan_in,
+			  struct mwifiex_scan_resp *scan_resp)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmd_node = NULL;
 	union mwifiex_scan_cmd_config_tlv *scan_cfg_out = NULL;
@@ -2547,7 +2541,7 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 			scan_resp->num_in_scan_table =
 				adapter->num_in_scan_table;
 		} else {
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 		}
 		LEAVE();
 		return ret;
@@ -2574,7 +2568,7 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 	if (!scan_cfg_out) {
 		PRINTM(MERROR, "%s: failed to alloc scan_cfg_out\n", __func__);
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	buf_size =
@@ -2585,7 +2579,7 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 		PRINTM(MERROR, "%s: failed to alloc scan_cfg_out\n", __func__);
 		kfree(scan_cfg_out);
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	keep_previous_scan = false;
@@ -2614,7 +2608,7 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 					chan_list_out, scan_chan_list);
 
 	/* Get scan command from scan_pending_q and put to cmd_pending_q */
-	if (ret == MWIFIEX_STATUS_SUCCESS) {
+	if (!ret) {
 		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 		if (!list_empty(&adapter->scan_pending_q)) {
 			cmd_node = list_first_entry(&adapter->scan_pending_q,
@@ -2628,7 +2622,7 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
 		}
-		ret = MWIFIEX_STATUS_PENDING;
+		ret = -EINPROGRESS;
 	} else {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = true;
@@ -2656,9 +2650,8 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
  *      - Setting command ID, and proper size
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
-mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *cmd, void *data_buf)
+int mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *cmd, void *data_buf)
 {
 	struct host_cmd_ds_802_11_scan *scan_cmd = &cmd->params.scan;
 	struct mwifiex_scan_cmd_config *scan_cfg;
@@ -2682,7 +2675,7 @@ mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
 					  + scan_cfg->tlv_buf_len + S_DS_GEN));
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -2704,11 +2697,10 @@ mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
  *      |            BufSize and sizeof the fixed fields above)       |
  *      .-------------------------------------------------------------.
  */
-enum mwifiex_status
-mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *resp, void *wq_buf)
+int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
+			    struct host_cmd_ds_command *resp, void *wq_buf)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_wait_queue *wait_queue = NULL;
 	struct cmd_ctrl_node *cmd_node = NULL;
@@ -2745,7 +2737,7 @@ mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		PRINTM(MERROR,
 		       "SCAN_RESP: Invalid number of AP returned (%d)!!\n",
 		       scan_rsp->number_of_sets);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -2803,7 +2795,7 @@ mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 				GFP_KERNEL);
 	if (!bss_new_entry) {
 		PRINTM(MERROR, "%s: failed to alloc bss_new_entry\n", __func__);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -2813,11 +2805,10 @@ mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		       sizeof(struct mwifiex_bssdescriptor));
 
 		/* Process the data fields and IEs returned for this BSS */
-		if (mwifiex_interpret_bss_desc_with_ie(adapter,
+		if (!mwifiex_interpret_bss_desc_with_ie(adapter,
 						       bss_new_entry,
 						       &bss_info,
-						       &bytes_left) ==
-		    MWIFIEX_STATUS_SUCCESS) {
+						       &bytes_left)) {
 
 			PRINTM(MINFO,
 			       "SCAN_RESP: BSSID = %02x:%02x:"
@@ -2972,8 +2963,7 @@ mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			/* Indicate ioctl complete */
 			mwifiex_ioctl_complete(adapter,
 					       (struct mwifiex_wait_queue *)
-					       wait_queue,
-					       MWIFIEX_STATUS_SUCCESS);
+					       wait_queue, 0);
 		}
 		if (priv->report_scan_result)
 			priv->report_scan_result = false;
@@ -3008,10 +2998,9 @@ done:
  *      - Setting background scan flush parameter
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
-mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
-				 struct host_cmd_ds_command *cmd,
-				 void *data_buf)
+int mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
+				     struct host_cmd_ds_command *cmd,
+				     void *data_buf)
 {
 	struct host_cmd_ds_802_11_bg_scan_query *bg_query =
 		&cmd->params.bg_scan_query;
@@ -3026,7 +3015,7 @@ mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private *priv,
 	bg_query->flush = 1;
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -3198,12 +3187,11 @@ mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 /*
  * This function finds an AP with specific ssid in the scan list.
  */
-enum mwifiex_status
-mwifiex_find_best_network(struct mwifiex_private *priv,
-			  struct mwifiex_ssid_bssid *req_ssid_bssid)
+int mwifiex_find_best_network(struct mwifiex_private *priv,
+			      struct mwifiex_ssid_bssid *req_ssid_bssid)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_bssdescriptor *req_bss;
 	s32 i;
 
@@ -3227,7 +3215,7 @@ mwifiex_find_best_network(struct mwifiex_private *priv,
 	}
 
 	if (!req_ssid_bssid->ssid.ssid_len) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -3247,20 +3235,19 @@ done:
  * This function sends a scan command for all available channels to the
  * firmware, filtered on a specific SSID.
  */
-enum mwifiex_status
-mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
-			   void *wait_buf, u16 action,
-			   struct mwifiex_802_11_ssid *req_ssid,
-			   struct mwifiex_scan_resp *scan_resp)
+int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
+			       void *wait_buf, u16 action,
+			       struct mwifiex_802_11_ssid *req_ssid,
+			       struct mwifiex_scan_resp *scan_resp)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_user_scan_cfg *scan_cfg;
 
 	ENTER();
 
 	if (!req_ssid) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -3271,7 +3258,7 @@ mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 			scan_resp->num_in_scan_table =
 				adapter->num_in_scan_table;
 		} else {
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 		}
 		LEAVE();
 		return ret;
@@ -3294,7 +3281,7 @@ mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg), GFP_KERNEL);
 	if (!scan_cfg) {
 		PRINTM(MERROR, "%s: failed to alloc scan_cfg\n", __func__);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 420ecce..c948c04 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -47,7 +47,7 @@ static struct semaphore add_remove_card_sem;
 static int
 mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 {
-	int ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct sdio_mmc_card *card = NULL;
 
 	ENTER();
@@ -77,14 +77,13 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		return -EIO;
 	}
 
-	if (mwifiex_add_card(card, &add_remove_card_sem, &sdio_ops)
-	    != MWIFIEX_STATUS_SUCCESS) {
+	if (mwifiex_add_card(card, &add_remove_card_sem, &sdio_ops)) {
 		PRINTM(MERROR, "%s failed\n", __func__);
 		kfree(card);
 		sdio_claim_host(func);
 		ret = sdio_disable_func(func);
 		sdio_release_host(func);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 	}
 
 	LEAVE();
@@ -135,7 +134,7 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	mmc_pm_flag_t pm_flag = 0;
 	int hs_actived = 0;
 	int i;
-	int ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -157,12 +156,12 @@ static int mwifiex_sdio_suspend(struct device *dev)
 			PRINTM(MERROR,
 			       "Card or moal_handle structure is not valid\n");
 			LEAVE();
-			return MWIFIEX_STATUS_SUCCESS;
+			return 0;
 		}
 	} else {
 		PRINTM(MERROR, "sdio_func is not specified\n");
 		LEAVE();
-		return MWIFIEX_STATUS_SUCCESS;
+		return 0;
 	}
 
 	adapter = card->adapter;
@@ -211,12 +210,12 @@ static int mwifiex_sdio_resume(struct device *dev)
 			PRINTM(MERROR,
 			       "Card or moal_handle structure is not valid\n");
 			LEAVE();
-			return MWIFIEX_STATUS_SUCCESS;
+			return 0;
 		}
 	} else {
 		PRINTM(MERROR, "sdio_func is not specified\n");
 		LEAVE();
-		return MWIFIEX_STATUS_SUCCESS;
+		return 0;
 	}
 
 	adapter = card->adapter;
@@ -224,7 +223,7 @@ static int mwifiex_sdio_resume(struct device *dev)
 	if (!adapter->is_suspended) {
 		PRINTM(MWARN, "Device already resumed\n");
 		LEAVE();
-		return MWIFIEX_STATUS_SUCCESS;
+		return 0;
 	}
 
 	adapter->is_suspended = false;
@@ -238,7 +237,7 @@ static int mwifiex_sdio_resume(struct device *dev)
 			      MWIFIEX_NO_WAIT);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /** Device ID for SD8787 */
@@ -275,7 +274,7 @@ static int
 mwifiex_write_reg(struct mwifiex_adapter *adapter, u32 reg, u32 data)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	int ret = MWIFIEX_STATUS_FAILURE;
+	int ret = -1;
 
 	sdio_claim_host(card->func);
 	sdio_writeb(card->func, (u8) data, reg, &ret);
@@ -291,7 +290,7 @@ static int
 mwifiex_read_reg(struct mwifiex_adapter *adapter, u32 reg, u32 *data)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	int ret = MWIFIEX_STATUS_FAILURE;
+	int ret = -1;
 	u8 val;
 
 	sdio_claim_host(card->func);
@@ -308,12 +307,12 @@ mwifiex_read_reg(struct mwifiex_adapter *adapter, u32 reg, u32 *data)
  *
  * This does not work in suspended mode.
  */
-static enum mwifiex_status
+static int
 mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
 			u8 *buffer, u32 pkt_len, u32 port, u32 timeout)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	enum mwifiex_status ret = MWIFIEX_STATUS_FAILURE;
+	int ret = -1;
 	u8 blk_mode =
 		(port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE : BLOCK_MODE;
 	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
@@ -325,13 +324,13 @@ mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
 
 	if (adapter->is_suspended) {
 		PRINTM(MERROR, "%s is not allowed while suspended\n", __func__);
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	sdio_claim_host(card->func);
 
 	if (!sdio_writesb(card->func, ioport, buffer, blk_cnt * blk_size))
-		ret = MWIFIEX_STATUS_SUCCESS;
+		ret = 0;
 
 	sdio_release_host(card->func);
 
@@ -341,13 +340,12 @@ mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
 /*
  * This function reads multiple data from SDIO card memory.
  */
-static enum mwifiex_status
-mwifiex_read_data_sync(struct mwifiex_adapter *adapter,
-		       u8 *buffer, u32 len,
+static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter,
+				  u8 *buffer, u32 len,
 		       u32 port, u32 timeout, u8 claim)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	enum mwifiex_status ret = MWIFIEX_STATUS_FAILURE;
+	int ret = -1;
 	u8 blk_mode =
 		(port & MWIFIEX_SDIO_BYTE_MODE_MASK) ? BYTE_MODE : BLOCK_MODE;
 	u32 blk_size = (blk_mode == BLOCK_MODE) ? MWIFIEX_SDIO_BLOCK_SIZE : 1;
@@ -360,7 +358,7 @@ mwifiex_read_data_sync(struct mwifiex_adapter *adapter,
 		sdio_claim_host(card->func);
 
 	if (!sdio_readsb(card->func, buffer, ioport, blk_cnt * blk_size))
-		ret = MWIFIEX_STATUS_SUCCESS;
+		ret = 0;
 
 	if (claim)
 		sdio_release_host(card->func);
@@ -374,10 +372,9 @@ mwifiex_read_data_sync(struct mwifiex_adapter *adapter,
  * A host power up command is written to the card configuration
  * register to wake up the card.
  */
-static enum mwifiex_status
-mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
+static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
-	enum mwifiex_status ret;
+	int ret;
 
 	ENTER();
 
@@ -393,10 +390,9 @@ mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
  *
  * The card configuration register is reset.
  */
-static enum mwifiex_status
-mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
+static int mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
 {
-	enum mwifiex_status ret;
+	int ret;
 
 	ENTER();
 
@@ -415,79 +411,72 @@ mwifiex_pm_wakeup_card_complete(struct mwifiex_adapter *adapter)
  *      - Set host interrupt Reset-To-Read to clear
  *      - Set auto re-enable interrupt
  */
-static enum mwifiex_status
-mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
+static int mwifiex_init_sdio_ioport(struct mwifiex_adapter *adapter)
 {
 	u32 reg;
 
 	adapter->ioport = 0;
 
 	/* Read the IO port */
-	if (MWIFIEX_STATUS_SUCCESS ==
-	    mwifiex_read_reg(adapter, IO_PORT_0_REG, &reg))
+	if (!mwifiex_read_reg(adapter, IO_PORT_0_REG, &reg))
 		adapter->ioport |= (reg & 0xff);
 	else
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 
-	if (MWIFIEX_STATUS_SUCCESS ==
-	    mwifiex_read_reg(adapter, IO_PORT_1_REG, &reg))
+	if (!mwifiex_read_reg(adapter, IO_PORT_1_REG, &reg))
 		adapter->ioport |= ((reg & 0xff) << 8);
 	else
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 
-	if (MWIFIEX_STATUS_SUCCESS ==
-	    mwifiex_read_reg(adapter, IO_PORT_2_REG, &reg))
+	if (!mwifiex_read_reg(adapter, IO_PORT_2_REG, &reg))
 		adapter->ioport |= ((reg & 0xff) << 16);
 	else
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 
 	PRINTM(MINFO, "SDIO FUNC1 IO port: 0x%x\n", adapter->ioport);
 
 	/* Set Host interrupt reset to read to clear */
-	if (MWIFIEX_STATUS_SUCCESS ==
-	    mwifiex_read_reg(adapter, HOST_INT_RSR_REG, &reg)) {
+	if (!mwifiex_read_reg(adapter, HOST_INT_RSR_REG, &reg)) {
 		mwifiex_write_reg(adapter, HOST_INT_RSR_REG,
 				  reg | SDIO_INT_MASK);
 	} else
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 
 	/* Dnld/Upld ready set to auto reset */
-	if (MWIFIEX_STATUS_SUCCESS ==
-	    mwifiex_read_reg(adapter, CARD_MISC_CFG_REG, &reg)) {
+	if (!mwifiex_read_reg(adapter, CARD_MISC_CFG_REG, &reg)) {
 		mwifiex_write_reg(adapter, CARD_MISC_CFG_REG,
 				  reg | AUTO_RE_ENABLE_INT);
 	} else
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
  * This function sends data to the card.
  */
-static enum mwifiex_status
-mwifiex_write_data_to_card(struct mwifiex_adapter *adapter,
-			   u8 *payload, u32 pkt_len, u32 port)
+static int mwifiex_write_data_to_card(struct mwifiex_adapter *adapter,
+				      u8 *payload, u32 pkt_len, u32 port)
 {
 	u32 i = 0;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	do {
 		ret = mwifiex_write_data_sync(adapter, payload, pkt_len,
 								port, 0);
-		if (ret != MWIFIEX_STATUS_SUCCESS) {
+		if (ret) {
 			i++;
 			PRINTM(MERROR, "host_to_card, write iomem (%d) failed:"
 				       " %d\n", i, ret);
-			if (MWIFIEX_STATUS_SUCCESS != mwifiex_write_reg(adapter,
-						CONFIGURATION_REG, 0x04)) {
+			if (mwifiex_write_reg(adapter,
+					      CONFIGURATION_REG, 0x04)) {
 				PRINTM(MERROR, "write CFG reg failed\n");
 			}
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			if (i > MAX_WRITE_IOMEM_RETRY)
 				goto exit;
 		}
-	} while (ret == MWIFIEX_STATUS_FAILURE);
+	} while (ret == -1);
 
 exit:
 	return ret;
@@ -501,8 +490,7 @@ exit:
  * the value is increased (provided it does not reach the maximum
  * limit, in which case it is reset to 1)
  */
-static enum mwifiex_status
-mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
+static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	u16 rd_bitmap = card->mp_rd_bitmap;
@@ -510,7 +498,7 @@ mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 	PRINTM(MDATA, "mwifiex_get_rd_port: mp_rd_bitmap=0x%04x\n", rd_bitmap);
 
 	if (!(rd_bitmap & (CTRL_PORT_MASK | DATA_PORT_MASK)))
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 
 	if (card->mp_rd_bitmap & CTRL_PORT_MASK) {
 		card->mp_rd_bitmap &= (u16) (~CTRL_PORT_MASK);
@@ -527,13 +515,13 @@ mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
 			if (++card->curr_rd_port == MAX_PORT)
 				card->curr_rd_port = 1;
 		} else {
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 
 		PRINTM(MDATA, "port=%d mp_rd_bitmap=0x%04x -> 0x%04x\n",
 		       *port, rd_bitmap, card->mp_rd_bitmap);
 	}
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -543,8 +531,7 @@ mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
  * increased (provided it does not reach the maximum limit, in which
  * case it is reset to 1)
  */
-static enum mwifiex_status
-mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
+static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	u16 wr_bitmap = card->mp_wr_bitmap;
@@ -553,7 +540,7 @@ mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
 	       wr_bitmap);
 
 	if (!(wr_bitmap & card->mp_data_port_mask))
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 
 	if (card->mp_wr_bitmap & (1 << card->curr_wr_port)) {
 		card->mp_wr_bitmap &= (u16) (~(1 << card->curr_wr_port));
@@ -562,7 +549,7 @@ mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
 			card->curr_wr_port = 1;
 	} else {
 		adapter->data_sent = true;
-		return MWIFIEX_STATUS_RESOURCE;
+		return -EBUSY;
 	}
 
 	if (*port == CTRL_PORT) {
@@ -570,61 +557,58 @@ mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
 				"0x%04x -> 0x%04x\n",
 				*port, card->curr_wr_port, wr_bitmap,
 				card->mp_wr_bitmap);
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	PRINTM(MDATA, "port=%d mp_wr_bitmap=0x%04x -> 0x%04x\n",
 	       *port, wr_bitmap, card->mp_wr_bitmap);
 
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
  * This function polls the card status.
  */
-static enum mwifiex_status
+static int
 mwifiex_sdio_poll_card_status(struct mwifiex_adapter *adapter, u8 bits)
 {
 	u32 tries;
 	u32 cs = 0;
 
 	for (tries = 0; tries < MAX_POLL_TRIES; tries++) {
-		if (mwifiex_read_reg(adapter, CARD_STATUS_REG, &cs) !=
-		    MWIFIEX_STATUS_SUCCESS)
+		if (mwifiex_read_reg(adapter, CARD_STATUS_REG, &cs))
 			break;
 		else if ((cs & bits) == bits)
-			return MWIFIEX_STATUS_SUCCESS;
+			return 0;
 
 		udelay(10);
 	}
 
 	PRINTM(MWARN, "mwifiex_sdio_poll_card_status failed, tries = %d\n",
 	       tries);
-	return MWIFIEX_STATUS_FAILURE;
+	return -1;
 }
 
 /*
  * This function reads the firmware status.
  */
-static enum mwifiex_status
+static int
 mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
 {
 	u32 fws0 = 0, fws1 = 0;
 
 	ENTER();
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_read_reg(adapter, CARD_FW_STATUS0_REG, &fws0))
-		return MWIFIEX_STATUS_FAILURE;
+	if (mwifiex_read_reg(adapter, CARD_FW_STATUS0_REG, &fws0))
+		return -1;
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_read_reg(adapter, CARD_FW_STATUS1_REG, &fws1))
-		return MWIFIEX_STATUS_FAILURE;
+	if (mwifiex_read_reg(adapter, CARD_FW_STATUS1_REG, &fws1))
+		return -1;
 
 	*dat = (u16) ((fws1 << 8) | fws0);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -633,32 +617,29 @@ mwifiex_sdio_read_fw_status(struct mwifiex_adapter *adapter, u16 *dat)
  * The host interrupt mask is read, the disable bit is reset and
  * written back to the card host interrupt mask register.
  */
-static enum mwifiex_status
-mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
+static int mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
 {
 	u32 host_int_mask = 0;
 
 	ENTER();
 
 	/* Read back the host_int_mask register */
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_read_reg(adapter, HOST_INT_MASK_REG, &host_int_mask)) {
+	if (mwifiex_read_reg(adapter, HOST_INT_MASK_REG, &host_int_mask)) {
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	/* Update with the mask and write back to the register */
 	host_int_mask &= ~HOST_INT_DISABLE;
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_write_reg(adapter, HOST_INT_MASK_REG, host_int_mask)) {
+	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG, host_int_mask)) {
 		PRINTM(MWARN, "Disable host interrupt failed\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -667,48 +648,45 @@ mwifiex_sdio_disable_host_int(struct mwifiex_adapter *adapter)
  * The host interrupt enable mask is written to the card
  * host interrupt mask register.
  */
-static enum mwifiex_status
-mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
+static int mwifiex_sdio_enable_host_int(struct mwifiex_adapter *adapter)
 {
 
 	ENTER();
 
 	/* Simply write the mask to the register */
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_write_reg(adapter, HOST_INT_MASK_REG, HOST_INT_ENABLE)) {
+	if (mwifiex_write_reg(adapter, HOST_INT_MASK_REG, HOST_INT_ENABLE)) {
 		PRINTM(MWARN, "Enable host interrupt failed\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
  * This function sends a data buffer to the card.
  */
-static enum mwifiex_status
-mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
-			  u32 *type, u32 *nb,
-			  u8 *buffer, u32 npayload,
-			  u32 ioport)
+static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
+				     u32 *type, u32 *nb,
+				     u8 *buffer, u32 npayload,
+				     u32 ioport)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
 	if (!buffer) {
 		PRINTM(MWARN, "skb NULL pointer received!\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 
 	ret = mwifiex_read_data_sync(adapter, buffer, npayload, ioport, 0, 1);
 
-	if (ret != MWIFIEX_STATUS_SUCCESS) {
+	if (ret) {
 		PRINTM(MERROR, "card_to_host, read iomem failed: %d\n", ret);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 
@@ -716,7 +694,7 @@ mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 	if (*nb > npayload) {
 		PRINTM(MERROR, "invalid packet, *nb=%d, npayload=%d\n", *nb,
 		       npayload);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 
@@ -737,11 +715,10 @@ exit:
  * is tested for CRC errors, and retried a number of times before
  * returning failure.
  */
-static enum mwifiex_status
-mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
-			 struct mwifiex_fw_image *fw)
+static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
+				    struct mwifiex_fw_image *fw)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u8 *firmware = fw->fw_buf;
 	u32 firmware_len = fw->fw_len;
 	u32 offset = 0;
@@ -756,7 +733,7 @@ mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	if (!firmware_len) {
 		PRINTM(MMSG, "No firmware image found! Terminating download\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	PRINTM(MINFO, "Downloading FW image (%d bytes)\n", firmware_len);
@@ -768,7 +745,7 @@ mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		       "Unable to allocate buffer for firmware. Terminating "
 		       "download\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	/* Perform firmware data transfer */
@@ -778,7 +755,7 @@ mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		ret = mwifiex_sdio_poll_card_status(adapter,
 						    CARD_IO_READY |
 						    DN_LD_CARD_RDY);
-		if (ret != MWIFIEX_STATUS_SUCCESS) {
+		if (ret) {
 			PRINTM(MFATAL,
 			       "FW download with helper poll status timeout @ "
 			       "%d\n",
@@ -794,7 +771,7 @@ mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			ret = mwifiex_read_reg(adapter,
 						HOST_F1_RD_BASE_0,
 						&base0);
-			if (ret != MWIFIEX_STATUS_SUCCESS) {
+			if (ret) {
 				PRINTM(MWARN,
 				       "Dev BASE0 register read failed:"
 				       " base0=0x%04X(%d). Terminating "
@@ -805,7 +782,7 @@ mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			ret = mwifiex_read_reg(adapter,
 						 HOST_F1_RD_BASE_1,
 						&base1);
-			if (ret != MWIFIEX_STATUS_SUCCESS) {
+			if (ret) {
 				PRINTM(MWARN,
 				       "Dev BASE1 register read failed:"
 				       " base1=0x%04X(%d). Terminating "
@@ -827,7 +804,7 @@ mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			PRINTM(MFATAL,
 			       "FW download failure @ %d, invalid length %d\n",
 			       offset, len);
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 
@@ -840,7 +817,7 @@ mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 				       "FW download failure @ %d, over max "
 				       "retry count\n",
 				       offset);
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 				goto done;
 			}
 			PRINTM(MERROR, "FW CRC error indicated by the helper:"
@@ -869,16 +846,15 @@ mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		ret = mwifiex_write_data_sync(adapter, fwbuf, tx_blocks *
 					      MWIFIEX_SDIO_BLOCK_SIZE,
 					      adapter->ioport, 0);
-		if (ret != MWIFIEX_STATUS_SUCCESS) {
+		if (ret) {
 			PRINTM(MERROR,
 			       "FW download, write iomem (%d) failed @ %d\n"
 			       , i, offset);
-			if (mwifiex_write_reg
-			    (adapter, CONFIGURATION_REG,
-			     0x04) != MWIFIEX_STATUS_SUCCESS) {
+			if (mwifiex_write_reg(adapter, CONFIGURATION_REG,
+			    0x04)) {
 				PRINTM(MERROR, "write CFG reg failed\n");
 			}
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 
@@ -887,7 +863,7 @@ mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 
 	PRINTM(MINFO, "\nFW download over, size %d bytes\n", offset);
 
-	ret = MWIFIEX_STATUS_SUCCESS;
+	ret = 0;
 done:
 
 	kfree(fwbuf);
@@ -901,11 +877,10 @@ done:
  *
  * The winner interface is also determined by this function.
  */
-static enum mwifiex_status
-mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num,
-			int *winner)
+static int mwifiex_check_fw_status(struct mwifiex_adapter *adapter,
+				   u32 poll_num, int *winner)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u16 firmware_stat;
 	u32 tries;
 	u32 winner_status;
@@ -915,14 +890,14 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num,
 	/* Wait for firmware initialization event */
 	for (tries = 0; tries < poll_num; tries++) {
 		ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
-		if (MWIFIEX_STATUS_SUCCESS != ret)
+		if (ret)
 			continue;
 		if (firmware_stat == FIRMWARE_READY) {
-			ret = MWIFIEX_STATUS_SUCCESS;
+			ret = 0;
 			break;
 		} else {
 			mdelay(100);
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 		}
 	}
 
@@ -931,7 +906,7 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num,
 		    (adapter, CARD_FW_STATUS0_REG, &winner_status))
 			winner_status = 0;
 
-		if (winner_status != 0)
+		if (winner_status)
 			*winner = 0;
 		else
 			*winner = 1;
@@ -952,8 +927,7 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 
 	ENTER();
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_read_data_sync(adapter, card->mp_regs, MAX_MP_REGS,
+	if (mwifiex_read_data_sync(adapter, card->mp_regs, MAX_MP_REGS,
 				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK, 0,
 				   0)) {
 		PRINTM(MWARN,
@@ -1022,9 +996,8 @@ exit:
  * a command response, or an event, and the correct handler
  * function is invoked.
  */
-static enum mwifiex_status
-mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
-			 struct sk_buff *skb, u32 upld_typ)
+static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
+				    struct sk_buff *skb, u32 upld_typ)
 {
 	u8 *cmd_buf;
 
@@ -1080,7 +1053,7 @@ mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 		break;
 	}
 
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1092,12 +1065,11 @@ mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
  * is enabled and required, the buffers are copied onto an aggregation buffer,
  * provided there is space left, processed and finally uploaded.
  */
-static enum mwifiex_status
-mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
-				  struct sk_buff *skb, u8 port)
+static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
+					     struct sk_buff *skb, u8 port)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	s32 f_do_rx_aggr = 0;
 	s32 f_do_rx_cur = 0;
 	s32 f_aggr_cur = 0;
@@ -1180,13 +1152,12 @@ mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		PRINTM(MINFO, "do_rx_aggr: num of packets: %d\n",
 		       card->mpa_rx.pkt_cnt);
 
-		if (MWIFIEX_STATUS_SUCCESS !=
-		    mwifiex_read_data_sync(adapter, card->mpa_rx.buf,
+		if (mwifiex_read_data_sync(adapter, card->mpa_rx.buf,
 					   card->mpa_rx.buf_len,
 					   (adapter->ioport | 0x1000 |
 					    (card->mpa_rx.ports << 4)) +
 					   card->mpa_rx.start_port, 0, 1)) {
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 
@@ -1230,12 +1201,11 @@ rx_curr_single:
 		PRINTM(MINFO, "RX: f_do_rx_cur: port: %d rx_len: %d\n", port,
 		       rx_len);
 
-		if (MWIFIEX_STATUS_SUCCESS !=
-		    mwifiex_sdio_card_to_host(adapter, &pkt_type,
+		if (mwifiex_sdio_card_to_host(adapter, &pkt_type,
 					      (u32 *) &adapter->upld_len,
 					      skb->data, skb->len,
 					      adapter->ioport + port)) {
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 
@@ -1264,11 +1234,10 @@ done:
  * In case of Rx packets received, the packets are uploaded from card to
  * host and processed accordingly.
  */
-static enum mwifiex_status
-mwifiex_process_int_status(struct mwifiex_adapter *adapter)
+static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u8 sdio_ireg;
 	struct sk_buff *skb = NULL;
 	u8 port = CTRL_PORT;
@@ -1320,7 +1289,7 @@ mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 
 		while (true) {
 			ret = mwifiex_get_rd_port(adapter, &port);
-			if (ret != MWIFIEX_STATUS_SUCCESS) {
+			if (ret) {
 				PRINTM(MINFO, "no more rd_port available\n");
 				break;
 			}
@@ -1336,7 +1305,7 @@ mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			    || (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE) >
 			    MWIFIEX_RX_DATA_BUF_SIZE) {
 				PRINTM(MERROR, "invalid rx_len=%d\n", rx_len);
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 				goto done;
 			}
 			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
@@ -1346,7 +1315,7 @@ mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			if (!skb) {
 				PRINTM(MERROR, "%s: failed to alloc skb",
 								__func__);
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 				goto done;
 			}
 
@@ -1355,42 +1324,38 @@ mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 			PRINTM(MINFO, "rx_len = %d skb->len = %d\n", rx_len,
 					skb->len);
 
-			if (MWIFIEX_STATUS_SUCCESS !=
-			    mwifiex_sdio_card_to_host_mp_aggr(adapter, skb,
+			if (mwifiex_sdio_card_to_host_mp_aggr(adapter, skb,
 							      port)) {
 				u32 cr = 0;
 
 				PRINTM(MERROR,
 				       "Card to host failed: int status=0x%x\n",
 				       sdio_ireg);
-				if (MWIFIEX_STATUS_SUCCESS !=
-				    mwifiex_read_reg(adapter,
+				if (mwifiex_read_reg(adapter,
 						     CONFIGURATION_REG, &cr))
 					PRINTM(MERROR, "read CFG reg failed\n");
 
 				PRINTM(MINFO, "Config Reg val = %d\n", cr);
-				if (MWIFIEX_STATUS_SUCCESS !=
-				    mwifiex_write_reg(adapter,
+				if (mwifiex_write_reg(adapter,
 						      CONFIGURATION_REG,
 						      (cr | 0x04)))
 					PRINTM(MERROR,
 					       "write CFG reg failed\n");
 
 				PRINTM(MINFO, "write success\n");
-				if (MWIFIEX_STATUS_SUCCESS !=
-				    mwifiex_read_reg(adapter,
+				if (mwifiex_read_reg(adapter,
 						     CONFIGURATION_REG, &cr))
 					PRINTM(MERROR, "read CFG reg failed\n");
 
 				PRINTM(MINFO, "Config reg val =%x\n", cr);
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 				dev_kfree_skb_any(skb);
 				goto done;
 			}
 		}
 	}
 
-	ret = MWIFIEX_STATUS_SUCCESS;
+	ret = 0;
 done:
 
 	LEAVE();
@@ -1407,13 +1372,12 @@ done:
  * before transferring. The header contains the length of the packet and
  * the type. The firmware handles the packets based upon this set type.
  */
-static enum mwifiex_status
-mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
-			  u8 type, u8 *payload, u32 pkt_len,
-			  struct mwifiex_tx_param *tx_param)
+static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
+				     u8 type, u8 *payload, u32 pkt_len,
+				     struct mwifiex_tx_param *tx_param)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u32 buf_block_len;
 	u32 blk_size;
 	u8 port = CTRL_PORT;
@@ -1434,7 +1398,7 @@ mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	 */
 	if (type == MWIFIEX_TYPE_DATA) {
 		ret = mwifiex_get_wr_port_data(adapter, &port);
-		if (ret != MWIFIEX_STATUS_SUCCESS) {
+		if (ret) {
 			PRINTM(MERROR, "no wr_port available: %d\n", ret);
 			goto exit;
 		}
@@ -1459,7 +1423,7 @@ mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 		ret = mwifiex_host_to_card_mp_aggr(adapter, payload, pkt_len,
 				port, 0);
 
-	if (ret != MWIFIEX_STATUS_SUCCESS) {
+	if (ret) {
 		if (type == MWIFIEX_TYPE_CMD)
 			adapter->cmd_sent = false;
 		if (type == MWIFIEX_TYPE_DATA)
@@ -1497,13 +1461,12 @@ exit:
  * stops, otherwise it will just aggregate the packet in aggregation buffer
  * and return.
  */
-enum mwifiex_status
-mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
-			     u8 *payload, u32 pkt_len, u8 port,
-			     u32 next_pkt_len)
+int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
+				 u8 *payload, u32 pkt_len, u8 port,
+				 u32 next_pkt_len)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	s32 f_send_aggr_buf = 0;
 	s32 f_send_cur_buf = 0;
 	s32 f_precopy_cur_buf = 0;
@@ -1621,12 +1584,11 @@ tx_curr_single:
 /*
  * This function allocates the MPA Tx and Rx buffers.
  */
-enum mwifiex_status
-mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
-			       u32 mpa_tx_buf_size, u32 mpa_rx_buf_size)
+int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
+				   u32 mpa_tx_buf_size, u32 mpa_rx_buf_size)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -1634,7 +1596,7 @@ mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
 	if (!card->mpa_tx.buf) {
 		PRINTM(MERROR,
 		       "Could not allocate buffer for SDIO MP TX aggr\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto error;
 	}
 
@@ -1644,14 +1606,14 @@ mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
 	if (!card->mpa_rx.buf) {
 		PRINTM(MERROR,
 		       "Could not allocate buffer for SDIO MP RX aggr\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto error;
 	}
 
 	card->mpa_rx.buf_size = mpa_rx_buf_size;
 
 error:
-	if (ret != MWIFIEX_STATUS_SUCCESS) {
+	if (ret) {
 		kfree(card->mpa_tx.buf);
 		kfree(card->mpa_rx.buf);
 	}
@@ -1693,10 +1655,9 @@ mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
  *
  * SDIO IRQ is claimed, block size is set and driver data is initialized.
  */
-static enum mwifiex_status
-mwifiex_register_dev(struct mwifiex_adapter *adapter)
+static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 {
-	int ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct sdio_mmc_card *card = adapter->card;
 	struct sdio_func *func = card->func;
 
@@ -1719,7 +1680,7 @@ mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	if (ret) {
 		PRINTM(MERROR,
 		       "sdio_set_block_seize(): cannot set SDIO block size\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto release_irq;
 	}
 
@@ -1729,7 +1690,7 @@ mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	adapter->hotplug_device = &func->dev;
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 
 release_irq:
 	sdio_release_irq(func);
@@ -1739,7 +1700,7 @@ disable_func:
 	adapter->card = NULL;
 
 	LEAVE();
-	return MWIFIEX_STATUS_FAILURE;
+	return -1;
 }
 
 /*
@@ -1755,11 +1716,10 @@ disable_func:
  *      - Allocate MP registers
  *      - Allocate MPA Tx and Rx buffers
  */
-static enum mwifiex_status
-mwifiex_init_sdio(struct mwifiex_adapter *adapter)
+static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
-	enum mwifiex_status ret;
+	int ret;
 	u32 sdio_ireg = 0;
 
 	/*
@@ -1805,17 +1765,17 @@ mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	card->mp_regs = kzalloc(MAX_MP_REGS, GFP_KERNEL);
 	if (!card->mp_regs) {
 		PRINTM(MERROR, "%s: failed to allocate mp_regs\n", __func__);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
 	ret = mwifiex_alloc_sdio_mpa_buffers(adapter,
 					     SDIO_MP_TX_AGGR_DEF_BUF_SIZE,
 					     SDIO_MP_RX_AGGR_DEF_BUF_SIZE);
-	if (ret != MWIFIEX_STATUS_SUCCESS) {
+	if (ret) {
 		PRINTM(MERROR, "Failed to allocate sdio mp-a buffers\n");
 		kfree(card->mp_regs);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index b5d9166..03614b3 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -282,17 +282,16 @@ struct mwifiex_sdio_mpa_rx {
 	u32 pkt_aggr_limit;
 };
 
-enum mwifiex_status mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter
-						 *adapter,
-						 u8 *payload, u32 pkt_len,
-						 u8 port, u32 next_pkt_len);
+int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
+				 u8 *payload, u32 pkt_len,
+				 u8 port, u32 next_pkt_len);
 
-enum mwifiex_status mwifiex_bus_register(void);
+int mwifiex_bus_register(void);
 void mwifiex_bus_unregister(void);
 
-enum mwifiex_status mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *,
-						   u32 mpa_tx_buf_size,
-						   u32 mpa_rx_buf_size);
+int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *,
+				   u32 mpa_tx_buf_size,
+				   u32 mpa_rx_buf_size);
 
 struct sdio_mmc_card {
 	struct sdio_func *func;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index d793d14..d64f6b9 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -35,7 +35,7 @@
  *      - Resetting SNR/NF/RSSI values in private structure
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
+static int
 mwifiex_cmd_802_11_rssi_info(struct mwifiex_private *priv,
 			     struct host_cmd_ds_command *cmd, u16 cmd_action)
 {
@@ -60,7 +60,7 @@ mwifiex_cmd_802_11_rssi_info(struct mwifiex_private *priv,
 	priv->bcn_nf_avg = 0;
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -70,10 +70,9 @@ mwifiex_cmd_802_11_rssi_info(struct mwifiex_private *priv,
  *      - Setting command ID, action and proper size
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_mac_control(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *cmd,
-			u16 cmd_action, void *data_buf)
+static int mwifiex_cmd_mac_control(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *cmd,
+				   u16 cmd_action, void *data_buf)
 {
 	struct host_cmd_ds_mac_control *mac_ctrl = &cmd->params.mac_ctrl;
 	u16 action = *((u16 *) data_buf);
@@ -84,7 +83,7 @@ mwifiex_cmd_mac_control(struct mwifiex_private *priv,
 		PRINTM(MERROR,
 		       "mwifiex_cmd_mac_control(): support SET only.\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_MAC_CONTROL);
@@ -93,7 +92,7 @@ mwifiex_cmd_mac_control(struct mwifiex_private *priv,
 	mac_ctrl->action = cpu_to_le16(action);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -111,10 +110,10 @@ mwifiex_cmd_mac_control(struct mwifiex_private *priv,
  *      - SHORT_RETRY_LIM_I : Short retry limit
  *      - DOT11D_I          : 11d support
  */
-static enum mwifiex_status
-mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
-			    struct host_cmd_ds_command *cmd,
-			    u16 cmd_action, u32 cmd_oid, void *data_buf)
+static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
+				       struct host_cmd_ds_command *cmd,
+				       u16 cmd_action, u32 cmd_oid,
+				       void *data_buf)
 {
 	struct host_cmd_ds_802_11_snmp_mib *snmp_mib = &cmd->params.smib;
 	u32 ul_temp;
@@ -194,7 +193,7 @@ mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	       cmd_action, cmd_oid, le16_to_cpu(snmp_mib->buf_size),
 	       le16_to_cpu(*(__le16 *) snmp_mib->value));
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -204,7 +203,7 @@ mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
  *      - Setting command ID and proper size
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
+static int
 mwifiex_cmd_802_11_get_log(struct mwifiex_private *priv,
 			   struct host_cmd_ds_command *cmd)
 {
@@ -214,7 +213,7 @@ mwifiex_cmd_802_11_get_log(struct mwifiex_private *priv,
 		cpu_to_le16(sizeof(struct host_cmd_ds_802_11_get_log) +
 			    S_DS_GEN);
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -226,10 +225,9 @@ mwifiex_cmd_802_11_get_log(struct mwifiex_private *priv,
  *        parameters (as required)
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *cmd,
-			u16 cmd_action, void *data_buf)
+static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *cmd,
+				   u16 cmd_action, void *data_buf)
 {
 	struct host_cmd_ds_tx_rate_cfg *rate_cfg = &cmd->params.tx_rate_cfg;
 	struct mwifiex_rate_scope *rate_scope;
@@ -284,7 +282,7 @@ mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 			    sizeof(struct mwifiex_rate_drop_pattern));
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -296,10 +294,9 @@ mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
  *        (as required)
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_tx_power_cfg(struct mwifiex_private *priv,
-			 struct host_cmd_ds_command *cmd,
-			 u16 cmd_action, void *data_buf)
+static int mwifiex_cmd_tx_power_cfg(struct mwifiex_private *priv,
+				    struct host_cmd_ds_command *cmd,
+				    u16 cmd_action, void *data_buf)
 {
 	struct mwifiex_types_power_group *pg_tlv = NULL;
 	struct host_cmd_ds_txpwr_cfg *txp = NULL;
@@ -345,7 +342,7 @@ mwifiex_cmd_tx_power_cfg(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -357,11 +354,10 @@ mwifiex_cmd_tx_power_cfg(struct mwifiex_private *priv,
  *        (as required)
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
-			  struct host_cmd_ds_command *cmd,
-			  u16 cmd_action,
-			  struct mwifiex_hs_config_param *data_buf)
+static int mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
+				     struct host_cmd_ds_command *cmd,
+				     u16 cmd_action,
+				     struct mwifiex_hs_config_param *data_buf)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_hs_cfg_enh *hs_cfg = &cmd->params.opt_hs_cfg;
@@ -412,7 +408,7 @@ mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -423,10 +419,9 @@ mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
  *      - Setting MAC address (for SET only)
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
-			       struct host_cmd_ds_command *cmd,
-			       u16 cmd_action)
+static int mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
+					  struct host_cmd_ds_command *cmd,
+					  u16 cmd_action)
 {
 	ENTER();
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_MAC_ADDRESS);
@@ -442,7 +437,7 @@ mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
 		       MWIFIEX_MAC_ADDR_LENGTH);
 	}
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -453,10 +448,9 @@ mwifiex_cmd_802_11_mac_address(struct mwifiex_private *priv,
  *      - Setting sleep period value (for SET only)
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_802_11_sleep_period(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *cmd,
-				u16 cmd_action, u16 *data_buf)
+static int mwifiex_cmd_802_11_sleep_period(struct mwifiex_private *priv,
+					   struct host_cmd_ds_command *cmd,
+					   u16 cmd_action, u16 *data_buf)
 {
 	struct host_cmd_ds_802_11_sleep_period *cmd_sleep_pd =
 		&cmd->params.sleep_pd;
@@ -473,7 +467,7 @@ mwifiex_cmd_802_11_sleep_period(struct mwifiex_private *priv,
 	cmd_sleep_pd->action = cpu_to_le16(cmd_action);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -484,10 +478,9 @@ mwifiex_cmd_802_11_sleep_period(struct mwifiex_private *priv,
  *      - Setting MAC multicast address
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_mac_multicast_adr(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *cmd,
-			      u16 cmd_action, void *data_buf)
+static int mwifiex_cmd_mac_multicast_adr(struct mwifiex_private *priv,
+					 struct host_cmd_ds_command *cmd,
+					 u16 cmd_action, void *data_buf)
 {
 	struct mwifiex_multicast_list *mcast_list =
 		(struct mwifiex_multicast_list *) data_buf;
@@ -506,7 +499,7 @@ mwifiex_cmd_mac_multicast_adr(struct mwifiex_private *priv,
 	       mcast_list->num_multicast_addr * MWIFIEX_MAC_ADDR_LENGTH);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -517,10 +510,9 @@ mwifiex_cmd_mac_multicast_adr(struct mwifiex_private *priv,
  *      - Setting AP MAC address and reason code
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
-				  struct host_cmd_ds_command *cmd,
-				  void *data_buf)
+static int mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
+					     struct host_cmd_ds_command *cmd,
+					     void *data_buf)
 {
 	struct host_cmd_ds_802_11_deauthenticate *deauth = &cmd->params.deauth;
 
@@ -542,7 +534,7 @@ mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
 	deauth->reason_code = cpu_to_le16(WLAN_REASON_DEAUTH_LEAVING);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -552,9 +544,8 @@ mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
  *      - Setting command ID and proper size
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_802_11_ad_hoc_stop(struct mwifiex_private *priv,
-			       struct host_cmd_ds_command *cmd)
+static int mwifiex_cmd_802_11_ad_hoc_stop(struct mwifiex_private *priv,
+					  struct host_cmd_ds_command *cmd)
 {
 	ENTER();
 
@@ -562,7 +553,7 @@ mwifiex_cmd_802_11_ad_hoc_stop(struct mwifiex_private *priv,
 	cmd->size = cpu_to_le16(S_DS_GEN);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -571,14 +562,14 @@ mwifiex_cmd_802_11_ad_hoc_stop(struct mwifiex_private *priv,
  * Multi-key parameter TLVs are supported, so we can send multiple
  * WEP keys in a single buffer.
  */
-static enum mwifiex_status
+static int
 mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 			    struct mwifiex_ie_type_key_param_set *key_param_set,
 			    u16 *key_param_len)
 {
 	int cur_key_param_len = 0;
 	u8 i;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -630,7 +621,7 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 		} else {
 			PRINTM(MERROR, "key%d Length = %d is incorrect\n",
 			       (i + 1), priv->wep_key[i].key_length);
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 	}
@@ -649,18 +640,17 @@ done:
  *        encryption (TKIP, AES) (as required)
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *cmd,
-				u16 cmd_action,
-				u32 cmd_oid, void *data_buf)
+static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
+					   struct host_cmd_ds_command *cmd,
+					   u16 cmd_action,
+					   u32 cmd_oid, void *data_buf)
 {
 	struct host_cmd_ds_802_11_key_material *key_material =
 		&cmd->params.key_material;
 	struct mwifiex_ds_encrypt_key *enc_key =
 		(struct mwifiex_ds_encrypt_key *) data_buf;
 	u16 key_param_len = 0;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	const u8 bc_mac[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 	ENTER();
@@ -806,7 +796,7 @@ done:
  *      - Setting SSID, passphrase and cmd action
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status mwifiex_cmd_802_11_supplicant_pmk(
+static int mwifiex_cmd_802_11_supplicant_pmk(
 		struct mwifiex_private  *priv,
 		struct host_cmd_ds_command   *cmd,
 		u16 cmd_action,
@@ -906,13 +896,13 @@ static enum mwifiex_status mwifiex_cmd_802_11_supplicant_pmk(
 		PRINTM(MERROR, "Invalid case,ssid/bssid present without pmk "
 			       "or passphrase\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 	cmd->command = cpu_to_le16(HostCmd_CMD_SUPPLICANT_PMK);
 	pesupp_psk->action = cpu_to_le16(cmd_action);
 	pesupp_psk->cache_result = 0;
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -922,7 +912,7 @@ static enum mwifiex_status mwifiex_cmd_802_11_supplicant_pmk(
  *      - Setting command ID and proper size
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status mwifiex_cmd_802_11_supplicant_profile(
+static int mwifiex_cmd_802_11_supplicant_profile(
 		struct mwifiex_private *priv,
 		struct host_cmd_ds_command *cmd,
 		u16 cmd_action)
@@ -938,7 +928,7 @@ static enum mwifiex_status mwifiex_cmd_802_11_supplicant_profile(
 	cmd->command = cpu_to_le16(HostCmd_CMD_SUPPLICANT_PROFILE);
 	sup_profile->action = cpu_to_le16(cmd_action);
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -949,9 +939,9 @@ static enum mwifiex_status mwifiex_cmd_802_11_supplicant_profile(
  *      - Setting domain information fields (for SET only)
  *      - Ensuring correct endian-ness
  */
-enum mwifiex_status
-mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *cmd, u16 cmd_action)
+int mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
+				    struct host_cmd_ds_command *cmd,
+				    u16 cmd_action)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11d_domain_info *domain_info =
@@ -973,7 +963,7 @@ mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 		HEXDUMP("11D: 802_11D_DOMAIN_INFO", (u8 *) cmd,
 				le16_to_cpu(cmd->size));
 		LEAVE();
-		return MWIFIEX_STATUS_SUCCESS;
+		return 0;
 	}
 
 	/* Set domain info fields */
@@ -1004,7 +994,7 @@ mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 			le16_to_cpu(cmd->size));
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1015,10 +1005,9 @@ mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
  *      - Setting RF type and current RF channel (for SET only)
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *cmd,
-			      u16 cmd_action, void *data_buf)
+static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
+					 struct host_cmd_ds_command *cmd,
+					 u16 cmd_action, void *data_buf)
 {
 	struct host_cmd_ds_802_11_rf_channel *rf_chan =
 		&cmd->params.rf_channel;
@@ -1043,7 +1032,7 @@ mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
 	}
 	rf_chan->action = cpu_to_le16(cmd_action);
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1054,10 +1043,9 @@ mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
  *      - Setting antenna mode (for SET only)
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_802_11_rf_antenna(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *cmd,
-			      u16 cmd_action, void *data_buf)
+static int mwifiex_cmd_802_11_rf_antenna(struct mwifiex_private *priv,
+					 struct host_cmd_ds_command *cmd,
+					 u16 cmd_action, void *data_buf)
 {
 	struct host_cmd_ds_802_11_rf_antenna *antenna = &cmd->params.antenna;
 
@@ -1075,7 +1063,7 @@ mwifiex_cmd_802_11_rf_antenna(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1086,10 +1074,9 @@ mwifiex_cmd_802_11_rf_antenna(struct mwifiex_private *priv,
  *      - Setting status to enable or disable (for SET only)
  *      - Ensuring correct endian-ness
  */
-static enum mwifiex_status
-mwifiex_cmd_ibss_coalescing_status(struct mwifiex_private *priv,
-				   struct host_cmd_ds_command *cmd,
-				   u16 cmd_action, void *data_buf)
+static int mwifiex_cmd_ibss_coalescing_status(struct mwifiex_private *priv,
+					      struct host_cmd_ds_command *cmd,
+					      u16 cmd_action, void *data_buf)
 {
 	struct host_cmd_ds_802_11_ibss_status *ibss_coal =
 		&(cmd->params.ibss_coalescing);
@@ -1118,7 +1105,7 @@ mwifiex_cmd_ibss_coalescing_status(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1138,9 +1125,8 @@ mwifiex_cmd_ibss_coalescing_status(struct mwifiex_private *priv,
  *      - CAU register
  *      - EEPROM
  */
-static enum mwifiex_status
-mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
-		       u16 cmd_action, void *data_buf)
+static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
+				  u16 cmd_action, void *data_buf)
 {
 	struct mwifiex_ds_reg_rw *reg_rw;
 
@@ -1247,11 +1233,11 @@ mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 		}
 	default:
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1260,14 +1246,13 @@ mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
  * This is a generic function which calls specific command preparation
  * routines based upon the command number.
  */
-enum mwifiex_status
-mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
-			u16 cmd_action, u32 cmd_oid,
-			void *data_buf, void *cmd_buf)
+int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
+			    u16 cmd_action, u32 cmd_oid,
+			    void *data_buf, void *cmd_buf)
 {
 	struct host_cmd_ds_command *cmd_ptr =
 		(struct host_cmd_ds_command *) cmd_buf;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	/* Prepare command */
 	switch (cmd_no) {
@@ -1353,7 +1338,7 @@ mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 			cpu_to_le16(sizeof(struct host_cmd_ds_tx_rate_query) +
 				    S_DS_GEN);
 		priv->tx_rate = 0;
-		ret = MWIFIEX_STATUS_SUCCESS;
+		ret = 0;
 		break;
 	case HostCmd_CMD_VERSION_EXT:
 		cmd_ptr->command = cpu_to_le16(cmd_no);
@@ -1364,7 +1349,7 @@ mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		cmd_ptr->size =
 			cpu_to_le16(sizeof(struct host_cmd_ds_version_ext) +
 				    S_DS_GEN);
-		ret = MWIFIEX_STATUS_SUCCESS;
+		ret = 0;
 		break;
 	case HostCmd_CMD_802_11_RF_CHANNEL:
 		ret = mwifiex_cmd_802_11_rf_channel(priv, cmd_ptr, cmd_action,
@@ -1426,7 +1411,7 @@ mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		cmd_ptr->size =
 			cpu_to_le16(sizeof(struct host_cmd_ds_wmm_get_status) +
 				    S_DS_GEN);
-		ret = MWIFIEX_STATUS_SUCCESS;
+		ret = 0;
 		break;
 	case HostCmd_CMD_802_11_IBSS_COALESCING_STATUS:
 		ret = mwifiex_cmd_ibss_coalescing_status(priv, cmd_ptr,
@@ -1450,11 +1435,11 @@ mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 				CONNECTION_TYPE_INFRA;
 		cmd_ptr->size = cpu_to_le16(sizeof(struct
 				host_cmd_ds_set_bss_mode) + S_DS_GEN);
-		ret = MWIFIEX_STATUS_SUCCESS;
+		ret = 0;
 		break;
 	default:
 		PRINTM(MERROR, "PREP_CMD: unknown command- %#x\n", cmd_no);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		break;
 	}
 	return ret;
@@ -1478,10 +1463,9 @@ mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
  *      - Set 11d control
  *      - Set MAC control (this must be the last command to initialize firmware)
  */
-enum mwifiex_status
-mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
+int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u16 enable = true;
 	struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
 	struct mwifiex_ds_auto_ds auto_ds;
@@ -1494,7 +1478,7 @@ mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_FUNC_INIT,
 					  HostCmd_ACT_GEN_SET, 0, NULL, NULL);
 		if (ret) {
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 		/*
@@ -1503,7 +1487,7 @@ mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_GET_HW_SPEC,
 					  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
 		if (ret) {
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 
@@ -1513,7 +1497,7 @@ mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 					  HostCmd_ACT_GEN_SET, 0, NULL,
 					  &priv->adapter->tx_buf_size);
 		if (ret) {
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 
@@ -1524,7 +1508,7 @@ mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 					  EN_AUTO_PS, BITMAP_STA_PS, NULL,
 					  NULL);
 		if (ret) {
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 	}
@@ -1534,7 +1518,7 @@ mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 				  HostCmd_CMD_TX_RATE_CFG,
 				  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
 	if (ret) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 	priv->data_rate = 0;
@@ -1544,7 +1528,7 @@ mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 				  HostCmd_CMD_TXPWR_CFG,
 				  HostCmd_ACT_GEN_GET, 0, NULL, NULL);
 	if (ret) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -1553,7 +1537,7 @@ mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 				  HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
 				  HostCmd_ACT_GEN_SET, 0, NULL, &enable);
 	if (ret) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -1564,7 +1548,7 @@ mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 				  HostCmd_ACT_GEN_SET, 0, NULL,
 				  (void *) &amsdu_aggr_ctrl);
 	if (ret) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 	/* MAC Control must be the last command in init_fw */
@@ -1573,7 +1557,7 @@ mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 				  HostCmd_ACT_GEN_SET, 0, NULL,
 				  &priv->curr_pkt_filter);
 	if (ret) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -1586,7 +1570,7 @@ mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 				EN_AUTO_PS, BITMAP_AUTO_DS, NULL,
 				&auto_ds);
 		if (ret) {
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto done;
 		}
 	}
@@ -1601,7 +1585,7 @@ mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 
 	/** set last_init_cmd */
 	priv->adapter->last_init_cmd = HostCmd_CMD_802_11_SNMP_MIB;
-	ret = MWIFIEX_STATUS_PENDING;
+	ret = -EINPROGRESS;
 done:
 	LEAVE();
 	return ret;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 9273971..1d08629 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -131,10 +131,9 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
  * The parameters are send to the application as well, along with
  * calculated SNR values.
  */
-static enum mwifiex_status
-mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
-			     struct host_cmd_ds_command *resp,
-			     void *data_buf)
+static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
+					struct host_cmd_ds_command *resp,
+					void *data_buf)
 {
 	struct host_cmd_ds_802_11_rssi_info_rsp *rssi_info_rsp =
 		&resp->params.rssi_info_rsp;
@@ -185,7 +184,7 @@ mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -200,10 +199,9 @@ mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
  *      - RTS threshold
  *      - Short retry limit
  */
-static enum mwifiex_status
-mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
-			    struct host_cmd_ds_command *resp,
-			    void *data_buf)
+static int mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
+				       struct host_cmd_ds_command *resp,
+				       void *data_buf)
 {
 	struct host_cmd_ds_802_11_snmp_mib *smib = &resp->params.smib;
 	u16 oid = le16_to_cpu(smib->oid);
@@ -235,7 +233,7 @@ mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
 		}
 	}
 
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -244,10 +242,9 @@ mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
  * Handling includes changing the header fields into CPU format
  * and sending the received parameters to application.
  */
-static enum mwifiex_status
-mwifiex_ret_get_log(struct mwifiex_private *priv,
-		    struct host_cmd_ds_command *resp,
-		    void *data_buf)
+static int mwifiex_ret_get_log(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *resp,
+			       void *data_buf)
 {
 	struct host_cmd_ds_802_11_get_log *get_log =
 		(struct host_cmd_ds_802_11_get_log *) &resp->params.get_log;
@@ -279,7 +276,7 @@ mwifiex_ret_get_log(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -297,10 +294,9 @@ mwifiex_ret_get_log(struct mwifiex_private *priv,
  * query to the firmware to get the current Tx data rate and updates
  * the driver value.
  */
-static enum mwifiex_status
-mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *resp,
-			void *data_buf)
+static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *resp,
+				   void *data_buf)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_rate_cfg *ds_rate = NULL;
@@ -310,7 +306,7 @@ mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 	u16 tlv, tlv_buf_len;
 	u8 *tlv_buf;
 	u32 i;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -398,8 +394,7 @@ mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
  * Handling includes saving the maximum and minimum Tx power levels
  * in driver, as well as sending the values to user.
  */
-static enum mwifiex_status
-mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
+static int mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
 {
 	int length = -1, max_power = -1, min_power = -1;
 	struct mwifiex_types_power_group *pg_tlv_hdr = NULL;
@@ -438,11 +433,11 @@ mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
 		}
 	} else {
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -452,10 +447,9 @@ mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
  * Handling includes changing the header fields into CPU format
  * and saving the current Tx power level in driver.
  */
-static enum mwifiex_status
-mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
-			 struct host_cmd_ds_command *resp,
-			 void *data_buf)
+static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
+				    struct host_cmd_ds_command *resp,
+				    void *data_buf)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_txpwr_cfg *txp_cfg = &resp->params.txp_cfg;
@@ -502,7 +496,7 @@ mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 	default:
 		PRINTM(MERROR, "CMD_RESP: unknown command action %d\n", action);
 		LEAVE();
-		return MWIFIEX_STATUS_SUCCESS;
+		return 0;
 	}
 	PRINTM(MINFO,
 	       "Current TxPower Level = %d, Max Power=%d, Min Power=%d\n",
@@ -510,7 +504,7 @@ mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 	       priv->min_tx_power_level);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -521,10 +515,9 @@ mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
  * and setting the current sleep period and associated parameters
  * in driver.
  */
-static enum mwifiex_status
-mwifiex_ret_802_11_sleep_period(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *resp,
-				void *data_buf)
+static int mwifiex_ret_802_11_sleep_period(struct mwifiex_private *priv,
+					   struct host_cmd_ds_command *resp,
+					   void *data_buf)
 {
 	struct host_cmd_ds_802_11_sleep_period *cmd_sleep_pd =
 		&resp->params.sleep_pd;
@@ -550,7 +543,7 @@ mwifiex_ret_802_11_sleep_period(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -558,9 +551,8 @@ mwifiex_ret_802_11_sleep_period(struct mwifiex_private *priv,
  *
  * Handling includes saving the MAC address in driver.
  */
-static enum mwifiex_status
-mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
-			       struct host_cmd_ds_command *resp)
+static int mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
+					  struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11_mac_address *cmd_mac_addr =
 		&resp->params.mac_addr;
@@ -576,20 +568,19 @@ mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
 	       priv->curr_addr[5]);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
  * This function handles the command response of set/get MAC multicast
  * address.
  */
-static enum mwifiex_status
-mwifiex_ret_mac_multicast_adr(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *resp)
+static int mwifiex_ret_mac_multicast_adr(struct mwifiex_private *priv,
+					 struct host_cmd_ds_command *resp)
 {
 	ENTER();
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -601,9 +592,8 @@ mwifiex_ret_mac_multicast_adr(struct mwifiex_private *priv,
  * Both rate configuration and current data rate can be retrieved
  * with this request.
  */
-static enum mwifiex_status
-mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
-				 struct host_cmd_ds_command *resp)
+static int mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
+					    struct host_cmd_ds_command *resp)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	ENTER();
@@ -617,7 +607,7 @@ mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -627,9 +617,8 @@ mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
  * If the deauthenticated MAC matches the current BSS MAC, the connection
  * state is reset.
  */
-static enum mwifiex_status
-mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
-				  struct host_cmd_ds_command *resp)
+static int mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
+					     struct host_cmd_ds_command *resp)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	ENTER();
@@ -641,7 +630,7 @@ mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
 		mwifiex_reset_connect_state(priv);
 	}
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -649,15 +638,14 @@ mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
  *
  * The function resets the connection state in driver.
  */
-static enum mwifiex_status
-mwifiex_ret_802_11_ad_hoc_stop(struct mwifiex_private *priv,
-			       struct host_cmd_ds_command *resp)
+static int mwifiex_ret_802_11_ad_hoc_stop(struct mwifiex_private *priv,
+					  struct host_cmd_ds_command *resp)
 {
 	ENTER();
 
 	mwifiex_reset_connect_state(priv);
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -666,9 +654,8 @@ mwifiex_ret_802_11_ad_hoc_stop(struct mwifiex_private *priv,
  * Handling includes updating the driver parameters to reflect the
  * changes.
  */
-static enum mwifiex_status
-mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *resp)
+static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
+					   struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11_key_material *key =
 		&resp->params.key_material;
@@ -694,7 +681,7 @@ mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
 		priv->aes_key.key_param_set.key_len);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -704,12 +691,11 @@ mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
  * SET) and retrieving passphrase (for action GET) for specified
  * SSID
  */
-static enum mwifiex_status
-mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
-				  struct host_cmd_ds_command *resp,
-				  void *data_buf)
+static int mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
+					     struct host_cmd_ds_command *resp,
+					     void *data_buf)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct host_cmd_ds_802_11_supplicant_pmk *supplicant_pmk_resp =
 		&resp->params.esupp_psk;
 	struct mwifiex_ds_passphrase *passphrase = NULL;
@@ -849,10 +835,9 @@ mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
  *         - pairwise cipher
  *         - group cipher
  */
-static enum mwifiex_status
-mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
-				      struct host_cmd_ds_command *resp,
-				      void *data_buf)
+static int mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
+						 struct host_cmd_ds_command
+						 *resp, void *data_buf)
 {
 	struct host_cmd_ds_802_11_supplicant_profile *psup_profile =
 		&resp->params.esupp_profile;
@@ -902,17 +887,16 @@ mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
  * This function handles the command response of get 11d domain information.
  */
-enum mwifiex_status
-mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *resp)
+int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
+				    struct host_cmd_ds_command *resp)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct host_cmd_ds_802_11d_domain_info_rsp *domain_info =
 		&resp->params.domain_info_resp;
 	struct mwifiex_ietypes_domain_param_set *domain = &domain_info->domain;
@@ -938,7 +922,7 @@ mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 				"returned!!\n",
 				no_of_triplet);
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	switch (action) {
@@ -949,7 +933,7 @@ mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 	default:
 		PRINTM(MERROR, "11D: Invalid Action:%d\n",
 			domain_info->action);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		break;
 	}
 
@@ -963,10 +947,9 @@ mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
  * Handling includes changing the header fields into CPU format
  * and saving the new channel in driver.
  */
-static enum mwifiex_status
-mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *resp,
-			      void *data_buf)
+static int mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
+					 struct host_cmd_ds_command *resp,
+					 void *data_buf)
 {
 	struct host_cmd_ds_802_11_rf_channel *rf_channel =
 		&resp->params.rf_channel;
@@ -984,7 +967,7 @@ mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
 		*((u16 *)data_buf) = new_channel;
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -993,10 +976,9 @@ mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
  * Handling includes changing the header fields into CPU format
  * and forwarding the antenna mode to application.
  */
-static enum mwifiex_status
-mwifiex_ret_802_11_rf_antenna(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *resp,
-			      void *data_buf)
+static int mwifiex_ret_802_11_rf_antenna(struct mwifiex_private *priv,
+					 struct host_cmd_ds_command *resp,
+					 void *data_buf)
 {
 	struct host_cmd_ds_802_11_rf_antenna *antenna = &resp->params.antenna;
 	u32 *ant = (u32 *)data_buf;
@@ -1011,7 +993,7 @@ mwifiex_ret_802_11_rf_antenna(struct mwifiex_private *priv,
 		*ant = (u32)le16_to_cpu(antenna->antenna_mode);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1020,10 +1002,9 @@ mwifiex_ret_802_11_rf_antenna(struct mwifiex_private *priv,
  * Handling includes forming the extended version string and sending it
  * to application.
  */
-static enum mwifiex_status
-mwifiex_ret_ver_ext(struct mwifiex_private *priv,
-		    struct host_cmd_ds_command *resp,
-		    void *data_buf)
+static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
+			       struct host_cmd_ds_command *resp,
+			       void *data_buf)
 {
 	struct host_cmd_ds_version_ext *ver_ext = &resp->params.verext;
 	struct host_cmd_ds_version_ext *version_ext = NULL;
@@ -1036,7 +1017,7 @@ mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 		memcpy(priv->version_str, ver_ext->version_str, 128);
 	}
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1045,10 +1026,9 @@ mwifiex_ret_ver_ext(struct mwifiex_private *priv,
  * The register value and offset are returned to the user. For EEPROM
  * access, the byte count is also returned.
  */
-static enum mwifiex_status
-mwifiex_ret_reg_access(u16 type,
-		       struct host_cmd_ds_command *resp,
-		       void *data_buf)
+static int mwifiex_ret_reg_access(u16 type,
+				  struct host_cmd_ds_command *resp,
+				  void *data_buf)
 {
 	struct mwifiex_ds_reg_rw *reg_rw = NULL;
 	struct mwifiex_ds_read_eeprom *eeprom = NULL;
@@ -1130,7 +1110,7 @@ mwifiex_ret_reg_access(u16 type,
 					PRINTM(MINFO, "EEPROM read return "
 							"length is too big\n");
 					LEAVE();
-					return MWIFIEX_STATUS_FAILURE;
+					return -1;
 				}
 				eeprom->offset = cmd_eeprom->offset;
 				eeprom->byte_count = cmd_eeprom->byte_count;
@@ -1146,11 +1126,11 @@ mwifiex_ret_reg_access(u16 type,
 			}
 		default:
 			LEAVE();
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 	}
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1160,9 +1140,8 @@ mwifiex_ret_reg_access(u16 type,
  * beacon interval, ATIM window and ERP information are updated, along with
  * changing the ad-hoc state accordingly.
  */
-static enum mwifiex_status
-mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
-				   struct host_cmd_ds_command *resp)
+static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
+					      struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11_ibss_status *ibss_coal_resp =
 		&(resp->params.ibss_coalescing);
@@ -1172,7 +1151,7 @@ mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 
 	if (le16_to_cpu(ibss_coal_resp->action) == HostCmd_ACT_GEN_SET) {
 		LEAVE();
-		return MWIFIEX_STATUS_SUCCESS;
+		return 0;
 	}
 
 	PRINTM(MINFO, "New BSSID %02x:%02x:%02x:%02x:%02x:%02x\n",
@@ -1184,7 +1163,7 @@ mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 	if (!memcmp(ibss_coal_resp->bssid, zero_mac, MWIFIEX_MAC_ADDR_LENGTH)) {
 		PRINTM(MMSG, "New BSSID is NULL\n");
 		LEAVE();
-		return MWIFIEX_STATUS_SUCCESS;
+		return 0;
 	}
 
 	/* If BSSID is diff, modify current BSS parameters */
@@ -1209,7 +1188,7 @@ mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1218,11 +1197,10 @@ mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
  * This is a generic function, which calls command specific
  * response handlers based on the command ID.
  */
-enum mwifiex_status
-mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
-			    u16 cmdresp_no, void *cmd_buf, void *wq_buf)
+int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
+				u16 cmdresp_no, void *cmd_buf, void *wq_buf)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_command *resp =
 		(struct host_cmd_ds_command *) cmd_buf;
@@ -1236,7 +1214,7 @@ mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 	if (resp->result != HostCmd_RESULT_OK) {
 		mwifiex_process_cmdresp_error(priv, resp, wait_queue);
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 	/* Command successful, handle response */
 	switch (cmdresp_no) {
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 47140dc..a6e99d7 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -195,11 +195,10 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
  *      - EVENT_BA_STREAM_TIEMOUT
  *      - EVENT_AMSDU_AGGR_CTRL
  */
-enum mwifiex_status
-mwifiex_process_sta_event(struct mwifiex_private *priv)
+int mwifiex_process_sta_event(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u32 eventcause = adapter->event_cause;
 
 	ENTER();
@@ -260,14 +259,13 @@ mwifiex_process_sta_event(struct mwifiex_private *priv)
 		if (adapter->pps_uapsd_mode && adapter->gen_null_pkt) {
 			if (mwifiex_check_last_packet_indication(priv)) {
 				if (!adapter->data_sent) {
-					if (mwifiex_send_null_packet(priv,
+					if (!mwifiex_send_null_packet(priv,
 					MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET
 					|
-					MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET)
-					== MWIFIEX_STATUS_SUCCESS)
+					MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET))
 						adapter->ps_state =
 							PS_STATE_SLEEP;
-					return MWIFIEX_STATUS_SUCCESS;
+					return 0;
 				}
 			}
 		}
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 9a197d0..0a851fb 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -157,15 +157,14 @@ mwifiex_wait_ioctl_complete(struct mwifiex_private *priv,
  * The function waits for the request to complete and issues the
  * completion handler, if required.
  */
-enum mwifiex_status
-mwifiex_request_ioctl(struct mwifiex_private *priv,
-		      struct mwifiex_wait_queue *wait,
-		      enum mwifiex_status status, u8 wait_option)
+int mwifiex_request_ioctl(struct mwifiex_private *priv,
+			  struct mwifiex_wait_queue *wait,
+			  int status, u8 wait_option)
 {
 	ENTER();
 
 	switch (status) {
-	case MWIFIEX_STATUS_PENDING:
+	case -EINPROGRESS:
 		PRINTM(MCMND, "IOCTL pending: wait=%p, wait_option=%d\n",
 				wait, wait_option);
 		atomic_inc(&priv->adapter->ioctl_pending);
@@ -178,9 +177,9 @@ mwifiex_request_ioctl(struct mwifiex_private *priv,
 			status = wait->status;
 		}
 		break;
-	case MWIFIEX_STATUS_SUCCESS:
-	case MWIFIEX_STATUS_FAILURE:
-	case MWIFIEX_STATUS_RESOURCE:
+	case 0:
+	case -1:
+	case -EBUSY:
 	default:
 		break;
 	}
@@ -195,11 +194,10 @@ EXPORT_SYMBOL_GPL(mwifiex_request_ioctl);
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-enum mwifiex_status
-mwifiex_request_set_mac_address(struct mwifiex_private *priv)
+int mwifiex_request_set_mac_address(struct mwifiex_private *priv)
 {
 	struct mwifiex_wait_queue *wait = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	u8 wait_option = MWIFIEX_CMD_WAIT;
 
 	ENTER();
@@ -207,7 +205,7 @@ mwifiex_request_set_mac_address(struct mwifiex_private *priv)
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
-		status = MWIFIEX_STATUS_FAILURE;
+		status = -1;
 		goto done;
 	}
 
@@ -215,7 +213,7 @@ mwifiex_request_set_mac_address(struct mwifiex_private *priv)
 					       NULL);
 
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (status == MWIFIEX_STATUS_SUCCESS) {
+	if (!status) {
 		memcpy(priv->netdev->dev_addr, priv->curr_addr, ETH_ALEN);
 		HEXDUMP("priv->MacAddr:", priv->curr_addr, ETH_ALEN);
 	} else {
@@ -242,7 +240,7 @@ mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_multicast_list mcast_list;
 	u8 wait_option = MWIFIEX_NO_WAIT;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	ENTER();
 
 	/* Allocate wait buffer */
@@ -266,7 +264,7 @@ mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 						  &mcast_list);
 
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (wait && status != MWIFIEX_STATUS_PENDING)
+	if (wait && status != -EINPROGRESS)
 		kfree(wait);
 done:
 	LEAVE();
@@ -279,18 +277,17 @@ done:
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-enum mwifiex_status
-mwifiex_disconnect(struct mwifiex_private *priv, u8 wait_option, u8 *mac)
+int mwifiex_disconnect(struct mwifiex_private *priv, u8 wait_option, u8 *mac)
 {
 	struct mwifiex_wait_queue *wait = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 
 	ENTER();
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
-		status = MWIFIEX_STATUS_FAILURE;
+		status = -1;
 		goto done;
 	}
 
@@ -311,13 +308,12 @@ EXPORT_SYMBOL_GPL(mwifiex_disconnect);
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-enum mwifiex_status
-mwifiex_bss_start(struct mwifiex_private *priv, u8 wait_option,
-		  struct mwifiex_ssid_bssid *ssid_bssid)
+int mwifiex_bss_start(struct mwifiex_private *priv, u8 wait_option,
+		      struct mwifiex_ssid_bssid *ssid_bssid)
 {
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ssid_bssid tmp_ssid_bssid;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 
 	ENTER();
 
@@ -328,7 +324,7 @@ mwifiex_bss_start(struct mwifiex_private *priv, u8 wait_option,
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
-		status = MWIFIEX_STATUS_FAILURE;
+		status = -1;
 		goto done;
 	}
 
@@ -350,11 +346,10 @@ done:
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-enum mwifiex_status
-mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
-			  struct mwifiex_rate_cfg *rate)
+int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
+			      struct mwifiex_rate_cfg *rate)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
@@ -363,7 +358,7 @@ mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -373,14 +368,14 @@ mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
 	ret = mwifiex_rate_ioctl_cfg(priv, wait, rate);
 
 	ret = mwifiex_request_ioctl(priv, wait, ret, wait_option);
-	if (ret == MWIFIEX_STATUS_SUCCESS) {
+	if (!ret) {
 		if (rate && rate->is_rate_auto)
 			rate->rate = mwifiex_index_to_data_rate(priv->adapter,
 					priv->tx_rate, priv->tx_htinfo);
 		else if (rate)
 			rate->rate = priv->data_rate;
 	} else {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 	}
 done:
 	kfree(wait);
@@ -394,12 +389,11 @@ done:
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-enum mwifiex_status
-mwifiex_set_get_hs_params(struct mwifiex_private *priv, u16 action,
-			  u8 wait_option,
-			  struct mwifiex_ds_hs_cfg *hscfg)
+int mwifiex_set_get_hs_params(struct mwifiex_private *priv, u16 action,
+			      u8 wait_option,
+			      struct mwifiex_ds_hs_cfg *hscfg)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 
 	ENTER();
@@ -420,7 +414,7 @@ mwifiex_set_get_hs_params(struct mwifiex_private *priv, u16 action,
 	ret = mwifiex_request_ioctl(priv, wait, ret, wait_option);
 
 done:
-	if (wait && (ret != MWIFIEX_STATUS_PENDING))
+	if (wait && (ret != -EINPROGRESS))
 		kfree(wait);
 	LEAVE();
 	return ret;
@@ -433,10 +427,9 @@ EXPORT_SYMBOL_GPL(mwifiex_set_get_hs_params);
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-enum mwifiex_status
-mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option)
+int mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_ds_hs_cfg hscfg;
 
 	ENTER();
@@ -480,8 +473,7 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 	if (mwifiex_set_get_hs_params(mwifiex_get_priv(adapter,
 						       MWIFIEX_BSS_ROLE_STA),
 				      HostCmd_ACT_GEN_SET,
-				      MWIFIEX_IOCTL_WAIT, &hscfg)
-				      != MWIFIEX_STATUS_SUCCESS) {
+				      MWIFIEX_IOCTL_WAIT, &hscfg)) {
 		PRINTM(MERROR, "IOCTL request HS enable failed\n");
 		goto done;
 	}
@@ -504,25 +496,24 @@ EXPORT_SYMBOL_GPL(mwifiex_enable_hs);
  *
  * This only works in the connected mode.
  */
-enum mwifiex_status
-mwifiex_get_info_signal(struct mwifiex_private *priv,
-			struct mwifiex_wait_queue *wait,
-			struct mwifiex_ds_get_signal *signal)
+int mwifiex_get_info_signal(struct mwifiex_private *priv,
+			    struct mwifiex_wait_queue *wait,
+			    struct mwifiex_ds_get_signal *signal)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
 	if (!wait) {
 		PRINTM(MERROR, "WAIT information is not present\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 
 	/* Signal info can be obtained only if connected */
 	if (!priv->media_connected) {
 		PRINTM(MINFO, "Can not get signal in disconnected state\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 
@@ -530,8 +521,8 @@ mwifiex_get_info_signal(struct mwifiex_private *priv,
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_RSSI_INFO,
 				  HostCmd_ACT_GEN_GET, 0, wait, signal);
 
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 exit:
 	LEAVE();
@@ -544,18 +535,17 @@ exit:
  * This function prepares the correct firmware command and
  * issues it to get the statistics (RSSI) information.
  */
-enum mwifiex_status
-mwifiex_get_info_stats(struct mwifiex_private *priv,
-		       struct mwifiex_wait_queue *wait,
-		       struct mwifiex_ds_get_stats *log)
+int mwifiex_get_info_stats(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait,
+			   struct mwifiex_ds_get_stats *log)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
 	if (!wait) {
 		PRINTM(MERROR, "MWIFIEX IOCTL information is not present\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 
@@ -563,8 +553,8 @@ mwifiex_get_info_stats(struct mwifiex_private *priv,
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_GET_LOG,
 				  HostCmd_ACT_GEN_GET, 0, wait, log);
 
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 exit:
 	LEAVE();
@@ -577,19 +567,18 @@ exit:
  * This function collates the information from different driver structures
  * to send to the user.
  */
-enum mwifiex_status
-mwifiex_get_bss_info(struct mwifiex_private *priv,
-		     struct mwifiex_bss_info *info)
+int mwifiex_get_bss_info(struct mwifiex_private *priv,
+			 struct mwifiex_bss_info *info)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_bssdescriptor *bss_desc;
 	s32 tbl_idx = 0;
 
 	ENTER();
 
 	if (!info)
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 
 	/* Get current BSS info */
 	bss_desc = &priv->curr_bss_params.bss_descriptor;
@@ -656,20 +645,19 @@ mwifiex_get_bss_info(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it to get the extended version information.
  */
-enum mwifiex_status
-mwifiex_get_info_ver_ext(struct mwifiex_private *priv,
-			 struct mwifiex_wait_queue *wait,
-			 struct mwifiex_ver_ext *ver_ext)
+int mwifiex_get_info_ver_ext(struct mwifiex_private *priv,
+			     struct mwifiex_wait_queue *wait,
+			     struct mwifiex_ver_ext *ver_ext)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_VERSION_EXT,
 				  HostCmd_ACT_GEN_GET, 0, wait, ver_ext);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 	LEAVE();
 	return ret;
@@ -686,17 +674,16 @@ mwifiex_get_info_ver_ext(struct mwifiex_private *priv,
  *      Set/get fragmentation threshold
  *      Set/get retry count
  */
-enum mwifiex_status
-mwifiex_snmp_mib_ioctl(struct mwifiex_private *priv,
-		       struct mwifiex_wait_queue *wait,
-		       u32 cmd_oid, u16 action, u32 *value)
+int mwifiex_snmp_mib_ioctl(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait,
+			   u32 cmd_oid, u16 action, u32 *value)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
 	if (!value) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -704,8 +691,8 @@ mwifiex_snmp_mib_ioctl(struct mwifiex_private *priv,
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
 				  action, cmd_oid, wait, value);
 
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 done:
 	LEAVE();
@@ -724,9 +711,9 @@ done:
  *      - Ad-hoc channel
  *      - Secondary channel offset
  */
-enum mwifiex_status
-mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
-			     u16 action, struct mwifiex_ds_band_cfg *radio_cfg)
+int mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
+				 u16 action,
+				 struct mwifiex_ds_band_cfg *radio_cfg)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u8 infra_band = 0;
@@ -743,7 +730,7 @@ mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
 		/* SET Infra band */
 		if ((infra_band | adapter->fw_bands) & ~adapter->fw_bands) {
 			LEAVE();
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 
 		adapter->config_bands = infra_band;
@@ -751,7 +738,7 @@ mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
 		/* SET Ad-hoc Band */
 		if ((adhoc_band | adapter->fw_bands) & ~adapter->fw_bands) {
 			LEAVE();
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 
 		if (adhoc_band)
@@ -782,7 +769,7 @@ mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
 			    (priv, adapter->adhoc_start_band,
 			     (u16) adhoc_channel)) {
 				LEAVE();
-				return MWIFIEX_STATUS_FAILURE;
+				return -1;
 			}
 			priv->adhoc_channel = (u8) adhoc_channel;
 		}
@@ -805,7 +792,7 @@ mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -815,12 +802,11 @@ mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
  * issues it. In addition, it performs validity checking on
  * user input data.
  */
-enum mwifiex_status
-mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
-			    struct mwifiex_wait_queue *wait,
-			    u16 action, u32 *antenna)
+int mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
+				struct mwifiex_wait_queue *wait,
+				u16 action, u32 *antenna)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u16 antenna_mode;
 
@@ -833,7 +819,7 @@ mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
 		    && (*antenna != RF_ANTENNA_AUTO
 			|| adapter->number_of_antenna <= 1)) {
 			PRINTM(MERROR, "Invalid antenna setting\n");
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto exit;
 		}
 	}
@@ -846,8 +832,8 @@ mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_RF_ANTENNA,
 				  action, 0, wait, &antenna_mode);
 
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 exit:
 	LEAVE();
@@ -860,26 +846,25 @@ exit:
  * This function prepares the correct firmware command and
  * issues it to get the extended version information.
  */
-enum mwifiex_status
-mwifiex_bss_ioctl_mac_address(struct mwifiex_private *priv,
-			      struct mwifiex_wait_queue *wait,
-			      u8 action, u8 *mac)
+int mwifiex_bss_ioctl_mac_address(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait,
+				  u8 action, u8 *mac)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	ENTER();
 
 	if ((action == HostCmd_ACT_GEN_GET) && mac) {
 		memcpy(mac, priv->curr_addr,
 		       MWIFIEX_MAC_ADDR_LENGTH);
-		ret = MWIFIEX_STATUS_SUCCESS;
+		ret = 0;
 		goto exit;
 	}
 
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_MAC_ADDRESS,
 				  action, 0, wait, mac);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 exit:
 	LEAVE();
 	return ret;
@@ -894,19 +879,19 @@ exit:
  * This function can be used to enable promiscuous mode, or enable all
  * multicast packets, or to enable selective multicast.
  */
-enum mwifiex_status
-mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
-				 struct mwifiex_wait_queue *wait, u16 action,
-				 struct mwifiex_multicast_list *mcast_list)
+int mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
+				     struct mwifiex_wait_queue *wait,
+				     u16 action,
+				     struct mwifiex_multicast_list *mcast_list)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u16 old_pkt_filter;
 
 	ENTER();
 
 	old_pkt_filter = priv->curr_pkt_filter;
 	if (action == HostCmd_ACT_GEN_GET) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 	if (mcast_list->mode == MWIFIEX_PROMISC_MODE) {
@@ -933,8 +918,8 @@ mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
 					ret = mwifiex_prepare_cmd(priv,
 						HostCmd_CMD_MAC_MULTICAST_ADR,
 						action, 0, wait, mcast_list);
-					if (ret == MWIFIEX_STATUS_SUCCESS)
-						ret = MWIFIEX_STATUS_PENDING;
+					if (!ret)
+						ret = -EINPROGRESS;
 				} else {
 					/* Send request to firmware */
 					ret = mwifiex_prepare_cmd(priv,
@@ -951,8 +936,8 @@ mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
 					  action, 0, wait,
 					  &priv->curr_pkt_filter);
-		if (ret == MWIFIEX_STATUS_SUCCESS)
-			ret = MWIFIEX_STATUS_PENDING;
+		if (!ret)
+			ret = -EINPROGRESS;
 	}
 
 exit:
@@ -966,13 +951,12 @@ exit:
  * This function performs validity checking on channel/frequency
  * compatibility and returns failure if not valid.
  */
-enum mwifiex_status
-mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
-			  struct mwifiex_chan_freq_power *chan)
+int mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
+			      struct mwifiex_chan_freq_power *chan)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_chan_freq_power *cfp = NULL;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -988,13 +972,13 @@ mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 			chan->channel = cfp->channel;
 			chan->freq = cfp->freq;
 		} else
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 		LEAVE();
 		return ret;
 	}
 	if (!chan->channel && !chan->freq) {
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 	if (adapter->adhoc_start_band & BAND_AN)
 		adapter->adhoc_start_band = BAND_G | BAND_B | BAND_GN;
@@ -1041,7 +1025,7 @@ mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
 	if (!cfp || !cfp->channel) {
 		PRINTM(MERROR, "Invalid channel/freq\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 
 	}
 	priv->adhoc_channel = (u8) cfp->channel;
@@ -1061,17 +1045,16 @@ mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
  * In case the mode is changed, a deauthentication is performed
  * first by the function automatically.
  */
-enum mwifiex_status
-mwifiex_bss_ioctl_mode(struct mwifiex_private *priv,
-		       struct mwifiex_wait_queue *wait,
-		       u16 action, int *mode)
+int mwifiex_bss_ioctl_mode(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait,
+			   u16 action, int *mode)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
 	if (!mode) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 	if (action == HostCmd_ACT_GEN_GET) {
@@ -1093,8 +1076,8 @@ mwifiex_bss_ioctl_mode(struct mwifiex_private *priv,
 	if (priv->bss_mode != MWIFIEX_BSS_MODE_AUTO) {
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
 					  HostCmd_ACT_GEN_SET, 0, wait, NULL);
-		if (ret == MWIFIEX_STATUS_SUCCESS)
-			ret = MWIFIEX_STATUS_PENDING;
+		if (!ret)
+			ret = -EINPROGRESS;
 	}
 exit:
 	LEAVE();
@@ -1108,12 +1091,11 @@ exit:
  * In both Ad-Hoc and infra mode, an deauthentication is performed
  * first.
  */
-enum mwifiex_status
-mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
-			struct mwifiex_wait_queue *wait,
-			struct mwifiex_ssid_bssid *ssid_bssid)
+int mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
+			    struct mwifiex_wait_queue *wait,
+			    struct mwifiex_ssid_bssid *ssid_bssid)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	s32 i = -1;
 
@@ -1121,7 +1103,7 @@ mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 
 	priv->scan_block = false;
 	if (!ssid_bssid) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto start_ssid_done;
 	}
 
@@ -1154,7 +1136,7 @@ mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 			if (ret)
 				goto start_ssid_done;
 		} else {	/* i >= 0 */
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto start_ssid_done;
 		}
 	} else {
@@ -1164,7 +1146,7 @@ mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 		    (!mwifiex_ssid_cmp
 		     (&priv->curr_bss_params.bss_descriptor.ssid,
 		      &ssid_bssid->ssid))) {
-			ret = MWIFIEX_STATUS_SUCCESS;
+			ret = 0;
 			goto start_ssid_done;
 		}
 
@@ -1205,8 +1187,8 @@ mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
 		}
 	}
 
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 start_ssid_done:
 	LEAVE();
@@ -1216,10 +1198,9 @@ start_ssid_done:
 /*
  * IOCTL request handler to disconnect from a BSS/IBSS.
  */
-enum mwifiex_status
-mwifiex_bss_ioctl_stop(struct mwifiex_private *priv,
-		       struct mwifiex_wait_queue *wait,
-		       u8 *mac)
+int mwifiex_bss_ioctl_stop(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait,
+			   u8 *mac)
 {
 	ENTER();
 
@@ -1233,12 +1214,11 @@ mwifiex_bss_ioctl_stop(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it to set or get the ad-hoc channel.
  */
-enum mwifiex_status
-mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
-			       struct mwifiex_wait_queue *wait,
-			       u16 action, u16 *channel)
+int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
+				   struct mwifiex_wait_queue *wait,
+				   u16 action, u16 *channel)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -1254,8 +1234,8 @@ mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_RF_CHANNEL,
 				  action, 0, wait, channel);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 exit:
 	LEAVE();
@@ -1268,13 +1248,12 @@ exit:
  * The BSS can be searched with either a BSSID or a SSID. If none of
  * these are provided, just the best BSS (best RSSI) is returned.
  */
-enum mwifiex_status
-mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
-			   struct mwifiex_wait_queue *wait,
-			   struct mwifiex_ssid_bssid *ssid_bssid)
+int mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
+			       struct mwifiex_wait_queue *wait,
+			       struct mwifiex_ssid_bssid *ssid_bssid)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_bssdescriptor *bss_desc;
 	u8 zero_mac[] = { 0, 0, 0, 0, 0, 0 };
 	u8 mac[MWIFIEX_MAC_ADDR_LENGTH];
@@ -1293,7 +1272,7 @@ mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 					mac[0], mac[1], mac[2],
 					mac[3], mac[4], mac[5]);
 			LEAVE();
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 		bss_desc = &adapter->scan_table[i];
 		memcpy(&ssid_bssid->ssid, &bss_desc->ssid,
@@ -1306,7 +1285,7 @@ mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 			PRINTM(MERROR, "Can not find ssid %s\n",
 					ssid_bssid->ssid.ssid);
 			LEAVE();
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 		bss_desc = &adapter->scan_table[i];
 		memcpy(ssid_bssid->bssid, bss_desc->mac_address,
@@ -1339,8 +1318,8 @@ mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
 int
 mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
+	int status = 0;
 	struct mwifiex_bss_info bss_info;
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
@@ -1352,16 +1331,15 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 	memset(&bss_info, 0, sizeof(bss_info));
 
 	/* Get BSS information */
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_get_bss_info(priv, &bss_info)) {
-		ret = MWIFIEX_STATUS_FAILURE;
+	if (mwifiex_get_bss_info(priv, &bss_info)) {
+		ret = -1;
 		goto done;
 	}
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -1369,19 +1347,18 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 	status = mwifiex_bss_ioctl_ibss_channel(priv, wait, HostCmd_ACT_GEN_GET,
 						&curr_chan);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
-		ret = MWIFIEX_STATUS_FAILURE;
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+		ret = -1;
 		goto done;
 	}
 	if (curr_chan == channel) {
-		ret = MWIFIEX_STATUS_SUCCESS;
+		ret = 0;
 		goto done;
 	}
 	PRINTM(MCMND, "Updating Channel from %d to %d\n", curr_chan, channel);
 
 	if (!bss_info.media_connected) {
-		ret = MWIFIEX_STATUS_SUCCESS;
+		ret = 0;
 		goto done;
 	}
 
@@ -1389,25 +1366,22 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 	memset(&ssid_bssid, 0, MWIFIEX_MAC_ADDR_LENGTH);
 	status = mwifiex_bss_ioctl_stop(priv, wait, ssid_bssid.bssid);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
-		ret = MWIFIEX_STATUS_FAILURE;
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+		ret = -1;
 		goto done;
 	}
 
 	status = mwifiex_bss_ioctl_ibss_channel(priv, wait, HostCmd_ACT_GEN_SET,
 						(u16 *) &channel);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-		mwifiex_request_ioctl(priv, wait, status, wait_option)) {
-		ret = MWIFIEX_STATUS_FAILURE;
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+		ret = -1;
 		goto done;
 	}
 
 	/* Do specific SSID scanning */
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_scan(priv, wait_option, &bss_info.ssid)) {
-		ret = MWIFIEX_STATUS_FAILURE;
+	if (mwifiex_request_scan(priv, wait_option, &bss_info.ssid)) {
+		ret = -1;
 		goto done;
 	}
 	/* Start/Join Adhoc network */
@@ -1417,9 +1391,8 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 
 	status = mwifiex_bss_ioctl_start(priv, wait, &ssid_bssid);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-		mwifiex_request_ioctl(priv, wait, status, wait_option))
-		ret = MWIFIEX_STATUS_FAILURE;
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option))
+		ret = -1;
 
 done:
 	kfree(wait);
@@ -1437,7 +1410,7 @@ int
 mwifiex_drv_get_mode(struct mwifiex_private *priv, u8 wait_option)
 {
 	struct mwifiex_wait_queue *wait = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	int mode = -1;
 	ENTER();
 
@@ -1445,14 +1418,14 @@ mwifiex_drv_get_mode(struct mwifiex_private *priv, u8 wait_option)
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	status = mwifiex_bss_ioctl_mode(priv, wait, HostCmd_ACT_GEN_GET, &mode);
 
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 
-	if (wait && (status != MWIFIEX_STATUS_PENDING))
+	if (wait && (status != -EINPROGRESS))
 		kfree(wait);
 	LEAVE();
 	return mode;
@@ -1466,13 +1439,12 @@ mwifiex_drv_get_mode(struct mwifiex_private *priv, u8 wait_option)
  * otherwise, the function returns the lowest supported rate
  * for the band.
  */
-static enum mwifiex_status
-mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
-				  struct mwifiex_wait_queue *wait,
-				  struct mwifiex_rate_cfg *rate_cfg)
+static int mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
+					     struct mwifiex_wait_queue *wait,
+					     struct mwifiex_rate_cfg *rate_cfg)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -1517,8 +1489,9 @@ mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
 		ret = mwifiex_prepare_cmd(priv,
 					  HostCmd_CMD_802_11_TX_RATE_QUERY,
 					  HostCmd_ACT_GEN_GET, 0, wait, NULL);
-		if (ret == MWIFIEX_STATUS_SUCCESS)
-			ret = MWIFIEX_STATUS_PENDING;
+		if (!ret)
+			ret = -EINPROGRESS;
+
 	}
 
 	LEAVE();
@@ -1533,17 +1506,16 @@ mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
  *
  * The function also performs validation checking on the supplied value.
  */
-static enum mwifiex_status
-mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
-				  struct mwifiex_wait_queue *wait,
-				  struct mwifiex_rate_cfg *rate_cfg)
+static int mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
+					     struct mwifiex_wait_queue *wait,
+					     struct mwifiex_rate_cfg *rate_cfg)
 {
 	u8 rates[MWIFIEX_SUPPORTED_RATES];
 	u8 *rate = NULL;
 	int rate_index = 0;
 	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
 	u32 i = 0;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	ENTER();
@@ -1571,7 +1543,7 @@ mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 		if (!rate[i] || (i == MWIFIEX_SUPPORTED_RATES)) {
 			PRINTM(MERROR, "The fixed data rate 0x%X is out "
 			       "of range\n", rate_cfg->rate);
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto exit;
 		}
 		memset(bitmap_rates, 0, sizeof(bitmap_rates));
@@ -1596,8 +1568,8 @@ mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
 				  HostCmd_ACT_GEN_SET, 0, wait, bitmap_rates);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 exit:
 	LEAVE();
@@ -1610,20 +1582,19 @@ exit:
  * This function prepares the correct firmware command and
  * issues it to get the data rate index.
  */
-static enum mwifiex_status
-mwifiex_rate_ioctl_get_rate_index(struct mwifiex_private *priv,
-				  struct mwifiex_wait_queue *wait,
-				  struct mwifiex_rate_cfg *rate_cfg)
+static int mwifiex_rate_ioctl_get_rate_index(struct mwifiex_private *priv,
+					     struct mwifiex_wait_queue *wait,
+					     struct mwifiex_rate_cfg *rate_cfg)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
 				  HostCmd_ACT_GEN_GET, 0, wait, rate_cfg);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 	LEAVE();
 	return ret;
@@ -1635,14 +1606,13 @@ mwifiex_rate_ioctl_get_rate_index(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it to set the data rate index.
  */
-static enum mwifiex_status
-mwifiex_rate_ioctl_set_rate_index(struct mwifiex_private *priv,
-				  struct mwifiex_wait_queue *wait,
-				  struct mwifiex_rate_cfg *rate_cfg)
+static int mwifiex_rate_ioctl_set_rate_index(struct mwifiex_private *priv,
+					     struct mwifiex_wait_queue *wait,
+					     struct mwifiex_rate_cfg *rate_cfg)
 {
 	int rate_index;
 	u32 i;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
 
 	ENTER();
@@ -1691,8 +1661,8 @@ mwifiex_rate_ioctl_set_rate_index(struct mwifiex_private *priv,
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
 				  HostCmd_ACT_GEN_SET, 0, wait, bitmap_rates);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 	LEAVE();
 	return ret;
@@ -1704,18 +1674,17 @@ mwifiex_rate_ioctl_set_rate_index(struct mwifiex_private *priv,
  * This function can be used to set/get either the rate value or the
  * rate index.
  */
-enum mwifiex_status
-mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
-		       struct mwifiex_wait_queue *wait,
-		       struct mwifiex_rate_cfg *rate_cfg)
+int mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait,
+			   struct mwifiex_rate_cfg *rate_cfg)
 {
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 
 	ENTER();
 
 	if (!rate_cfg) {
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 	if (rate_cfg->rate_type == MWIFIEX_RATE_VALUE) {
 		if (rate_cfg->action == HostCmd_ACT_GEN_GET)
@@ -1749,12 +1718,11 @@ mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
  *      - Modulation class HTBW20
  *      - Modulation class HTBW40
  */
-enum mwifiex_status
-mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
-			      struct mwifiex_wait_queue *wait,
-			      struct mwifiex_power_cfg *power_cfg)
+int mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait,
+				  struct mwifiex_power_cfg *power_cfg)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct host_cmd_ds_txpwr_cfg *txp_cfg = NULL;
 	struct mwifiex_types_power_group *pg_tlv = NULL;
 	struct mwifiex_power_group *pg = NULL;
@@ -1771,14 +1739,14 @@ mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
 					"range (%d dBm-%d dBm)!\n",
 					dbm, priv->min_tx_power_level,
 					priv->max_tx_power_level);
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto exit;
 		}
 	}
 	buf = kzalloc(MWIFIEX_SIZE_OF_CMD_BUFFER, GFP_KERNEL);
 	if (!buf) {
 		PRINTM(MERROR, "%s: failed to alloc cmd buffer\n", __func__);
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 
@@ -1835,8 +1803,8 @@ mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TXPWR_CFG,
 				  HostCmd_ACT_GEN_SET, 0, wait, buf);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 	kfree(buf);
 
 exit:
@@ -1850,13 +1818,12 @@ exit:
  * This function prepares the correct firmware command and
  * issues it.
  */
-enum mwifiex_status
-mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
-			 struct mwifiex_wait_queue *wait,
-			 u32 *ps_mode,
-			 u16 action)
+int mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
+			     struct mwifiex_wait_queue *wait,
+			     u32 *ps_mode,
+			     u16 action)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u16 sub_cmd;
 
@@ -1870,8 +1837,7 @@ mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
 		sub_cmd = (*ps_mode) ? EN_AUTO_PS : DIS_AUTO_PS;
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
 					  sub_cmd, BITMAP_STA_PS, wait, NULL);
-		if ((ret == MWIFIEX_STATUS_SUCCESS) &&
-						(sub_cmd == DIS_AUTO_PS)) {
+		if ((!ret) && (sub_cmd == DIS_AUTO_PS)) {
 			ret = mwifiex_prepare_cmd(priv,
 					HostCmd_CMD_802_11_PS_MODE_ENH, GET_PS,
 					0, NULL, NULL);
@@ -1881,8 +1847,8 @@ mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
 					  GET_PS, 0, wait, NULL);
 	}
 
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 	LEAVE();
 	return ret;
@@ -1894,13 +1860,12 @@ mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it.
  */
-enum mwifiex_status
-mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
-			struct mwifiex_wait_queue *wait,
-			u16 action, struct mwifiex_ds_hs_cfg *hs_cfg)
+int mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
+			    struct mwifiex_wait_queue *wait,
+			    u16 action, struct mwifiex_ds_hs_cfg *hs_cfg)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	u32 prev_cond = 0;
 
 	ENTER();
@@ -1910,7 +1875,7 @@ mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
 		if (adapter->pps_uapsd_mode) {
 			PRINTM(MINFO, "Host Sleep IOCTL is blocked in UAPSD/PPS"
 				      " mode\n");
-			status = MWIFIEX_STATUS_FAILURE;
+			status = -1;
 			break;
 		}
 		if (hs_cfg->is_invoke_hostcmd) {
@@ -1937,15 +1902,15 @@ mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
 						HOST_SLEEP_CFG_CANCEL)) {
 				/* Return failure if no parameters for HS
 				   enable */
-				status = MWIFIEX_STATUS_FAILURE;
+				status = -1;
 				break;
 			}
 			status = mwifiex_prepare_cmd(priv,
 					HostCmd_CMD_802_11_HS_CFG_ENH,
 					HostCmd_ACT_GEN_SET,
 					0, wait, &adapter->hs_cfg);
-			if (status == MWIFIEX_STATUS_SUCCESS)
-				status = MWIFIEX_STATUS_PENDING;
+			if (!status)
+				status = -EINPROGRESS;
 			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL) {
 				/* Restore previous condition */
 				adapter->hs_cfg.conditions =
@@ -1964,7 +1929,7 @@ mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
 		hs_cfg->gap = adapter->hs_cfg.gap;
 		break;
 	default:
-		status = MWIFIEX_STATUS_FAILURE;
+		status = -1;
 		break;
 	}
 
@@ -1978,13 +1943,12 @@ mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it.
  */
-enum mwifiex_status
-mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
-			    struct mwifiex_wait_queue *wait,
-			    struct mwifiex_ds_auto_ds *auto_deep_sleep,
-			    u16 action)
+int mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
+				struct mwifiex_wait_queue *wait,
+				struct mwifiex_ds_auto_ds *auto_deep_sleep,
+				u16 action)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u32 mode;
 
@@ -2004,13 +1968,13 @@ mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
 		PRINTM(MMSG, "Station already in enhanced deep"
 				" sleep mode\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	} else if (!adapter->is_deep_sleep && auto_deep_sleep->auto_ds ==
 		   DEEP_SLEEP_OFF) {
 		PRINTM(MMSG, "Station already not in enhanced "
 				"deep sleep mode\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	if (auto_deep_sleep->auto_ds == DEEP_SLEEP_ON) {
@@ -2028,8 +1992,8 @@ mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH, mode,
 				  BITMAP_AUTO_DS, wait, auto_deep_sleep);
 
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 	LEAVE();
 	return ret;
@@ -2041,20 +2005,19 @@ mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it.
  */
-enum mwifiex_status
-mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *priv,
-			 struct mwifiex_wait_queue *wait,
-			 u32 *sleep_period, u16 action)
+int mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *priv,
+			      struct mwifiex_wait_queue *wait,
+			      u32 *sleep_period, u16 action)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SLEEP_PERIOD,
 				  action, 0, wait, sleep_period);
 
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 	LEAVE();
 	return ret;
@@ -2067,9 +2030,8 @@ mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *priv,
  * is checked to determine WPA version. If buffer length is zero, the existing
  * WPA IE is reset.
  */
-static enum mwifiex_status
-mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
-			  u16 ie_len)
+static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
+				     u8 *ie_data_ptr, u16 ie_len)
 {
 	ENTER();
 
@@ -2077,7 +2039,7 @@ mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 		if (ie_len > sizeof(priv->wpa_ie)) {
 			PRINTM(MERROR, "failed to copy WPA IE, too big\n");
 			LEAVE();
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 		memcpy(priv->wpa_ie, ie_data_ptr, ie_len);
 		priv->wpa_ie_len = (u8) ie_len;
@@ -2102,7 +2064,7 @@ mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -2112,16 +2074,15 @@ mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
  * is checked to internally enable WAPI. If buffer length is zero, the existing
  * WAPI IE is reset.
  */
-static enum mwifiex_status
-mwifiex_set_wapi_ie(struct mwifiex_private *priv, u8 *ie_data_ptr,
-		    u16 ie_len)
+static int mwifiex_set_wapi_ie(struct mwifiex_private *priv,
+			       u8 *ie_data_ptr, u16 ie_len)
 {
 	ENTER();
 	if (ie_len) {
 		if (ie_len > sizeof(priv->wapi_ie)) {
 			PRINTM(MINFO, "failed to copy WAPI IE, too big\n");
 			LEAVE();
-			return MWIFIEX_STATUS_FAILURE;
+			return -1;
 		}
 		memcpy(priv->wapi_ie, ie_data_ptr, ie_len);
 		priv->wapi_ie_len = ie_len;
@@ -2139,7 +2100,7 @@ mwifiex_set_wapi_ie(struct mwifiex_private *priv, u8 *ie_data_ptr,
 		priv->sec_info.wapi_enabled = false;
 	}
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -2148,20 +2109,19 @@ mwifiex_set_wapi_ie(struct mwifiex_private *priv, u8 *ie_data_ptr,
  * This function prepares the correct firmware command and
  * issues it.
  */
-static enum mwifiex_status
-mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
+static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
 			       struct mwifiex_wait_queue *wait,
 			       struct mwifiex_ds_encrypt_key *encrypt_key)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	ENTER();
 
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
 				  HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
 				  wait, encrypt_key);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 	LEAVE();
 	return ret;
@@ -2170,10 +2130,9 @@ mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
 /*
  * IOCTL request handler to set/get authentication mode.
  */
-enum mwifiex_status
-mwifiex_set_auth_mode(struct mwifiex_private *priv, u32 auth_mode)
+int mwifiex_set_auth_mode(struct mwifiex_private *priv, u32 auth_mode)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	ENTER();
 
 	priv->sec_info.authentication_mode = auth_mode;
@@ -2191,12 +2150,11 @@ mwifiex_set_auth_mode(struct mwifiex_private *priv, u32 auth_mode)
  * This function prepares the correct firmware command and
  * issues it, after validation checks.
  */
-static enum mwifiex_status
-mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
+static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 			      struct mwifiex_wait_queue *wait,
 			      struct mwifiex_ds_encrypt_key *encrypt_key)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	struct mwifiex_wep_key *wep_key = NULL;
 	int index;
@@ -2217,7 +2175,7 @@ mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 		wep_key = &priv->wep_key[index];
 		if (!wep_key->key_length) {
 			PRINTM(MERROR, "Key not set, so cannot enable it\n");
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 			goto exit;
 		}
 		priv->wep_key_curr_index = (u16) index;
@@ -2259,8 +2217,8 @@ mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
 				  HostCmd_ACT_GEN_SET, 0, wait,
 				  &priv->curr_pkt_filter);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 exit:
 	LEAVE();
@@ -2277,12 +2235,11 @@ exit:
  *
  * This function can also be used to disable a currently set key.
  */
-static enum mwifiex_status
-mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
+static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 			      struct mwifiex_wait_queue *wait,
 			      struct mwifiex_ds_encrypt_key *encrypt_key)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	u8 remove_key = false;
 	struct host_cmd_ds_802_11_key_material *ibss_key;
@@ -2292,7 +2249,7 @@ mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 	/* Current driver only supports key length of up to 32 bytes */
 	if (encrypt_key->key_len > MWIFIEX_MAX_KEY_LENGTH) {
 		PRINTM(MERROR, " Error in key length\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 
@@ -2346,8 +2303,8 @@ mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 					  wait, encrypt_key);
 	}
 
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 exit:
 	LEAVE();
@@ -2359,12 +2316,11 @@ exit:
  *
  * This function works with both WEP and WPA keys.
  */
-static enum mwifiex_status
-mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
+static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 			  struct mwifiex_wait_queue *wait,
 			  struct mwifiex_ds_encrypt_key *encrypt_key)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	int index;
 	ENTER();
@@ -2440,13 +2396,12 @@ mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
  * This is a generic key handling function which supports WEP, WPA
  * and WAPI.
  */
-enum mwifiex_status
-mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
-			      struct mwifiex_wait_queue *wait,
-			      struct mwifiex_ds_encrypt_key *encrypt_key,
-			      u16 action)
+int mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait,
+				  struct mwifiex_ds_encrypt_key *encrypt_key,
+				  u16 action)
 {
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	ENTER();
@@ -2473,13 +2428,12 @@ mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
  * This function prepares corresponding firmware command and
  * issues it.
  */
-enum mwifiex_status
-mwifiex_sec_ioctl_passphrase(struct mwifiex_private *priv,
-			     struct mwifiex_wait_queue *wait,
-			     struct mwifiex_ds_passphrase *passphrase,
-			     u16 action)
+int mwifiex_sec_ioctl_passphrase(struct mwifiex_private *priv,
+				 struct mwifiex_wait_queue *wait,
+				 struct mwifiex_ds_passphrase *passphrase,
+				 u16 action)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bssdescriptor *pbss_desc;
 	u16 cmd_action = 0;
@@ -2520,8 +2474,8 @@ mwifiex_sec_ioctl_passphrase(struct mwifiex_private *priv,
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SUPPLICANT_PMK, cmd_action,
 				  0, wait, passphrase);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 	LEAVE();
 	return ret;
@@ -2533,17 +2487,16 @@ mwifiex_sec_ioctl_passphrase(struct mwifiex_private *priv,
  * This function prepares corresponding firmware command and
  * issues it.
  */
-enum mwifiex_status
-mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *priv,
-			     struct mwifiex_wait_queue *wait,
-			     struct mwifiex_ds_esupp_mode *esupp_mode)
+int mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *priv,
+				 struct mwifiex_wait_queue *wait,
+				 struct mwifiex_ds_esupp_mode *esupp_mode)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
 	if (priv->media_connected != true) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 
@@ -2551,8 +2504,8 @@ mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *priv,
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SUPPLICANT_PROFILE,
 				  HostCmd_ACT_GEN_GET_CURRENT, 0,
 				  wait, esupp_mode);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 exit:
 	LEAVE();
@@ -2573,7 +2526,7 @@ mwifiex_drv_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
 			   bool bdeep_sleep, u16 idle_time)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_auto_ds auto_deep_sleep;
 
@@ -2597,8 +2550,7 @@ mwifiex_drv_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
 	status = mwifiex_pm_ioctl_deep_sleep(priv, wait, &auto_deep_sleep,
 					     HostCmd_ACT_GEN_SET);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -2620,7 +2572,7 @@ int
 mwifiex_drv_get_deep_sleep(struct mwifiex_private *priv, u32 *deep_sleep)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_auto_ds auto_deep_sleep;
 
@@ -2635,8 +2587,7 @@ mwifiex_drv_get_deep_sleep(struct mwifiex_private *priv, u32 *deep_sleep)
 	status = mwifiex_pm_ioctl_deep_sleep(priv, wait, &auto_deep_sleep,
 					     HostCmd_ACT_GEN_GET);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
+	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -2678,10 +2629,8 @@ mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 		hscfg.gap = gap;
 	hscfg.gpio = HOST_SLEEP_CFG_GPIO_DEF;
 	hscfg.is_invoke_hostcmd = invoke_hostcmd;
-	if (MWIFIEX_STATUS_SUCCESS !=
-			mwifiex_set_get_hs_params(priv, HostCmd_ACT_GEN_SET,
-						  MWIFIEX_IOCTL_WAIT,
-						  &hscfg)) {
+	if (mwifiex_set_get_hs_params(priv, HostCmd_ACT_GEN_SET,
+				      MWIFIEX_IOCTL_WAIT, &hscfg)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -2702,7 +2651,7 @@ mwifiex_11n_get_amsdu_params(struct mwifiex_private *priv, int *amsdu_enable,
 {
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	int ret = 0;
 
 	ENTER();
@@ -2742,7 +2691,7 @@ mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable)
 {
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	int ret = 0;
 
 	ENTER();
@@ -2781,7 +2730,7 @@ done:
 int
 mwifiex_set_drv_txbuf_cfg(struct mwifiex_private *priv, int max_tx_buf_size)
 {
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 
 	ENTER();
 
@@ -2790,7 +2739,7 @@ mwifiex_set_drv_txbuf_cfg(struct mwifiex_private *priv, int max_tx_buf_size)
 	    (max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_8K)) {
 		priv->adapter->max_tx_buf_size = (u16) max_tx_buf_size;
 	} else {
-		status = MWIFIEX_STATUS_FAILURE;
+		status = -1;
 	}
 
 	LEAVE();
@@ -2824,7 +2773,7 @@ int
 mwifiex_get_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data)
 {
 	struct mwifiex_ds_11n_aggr_prio_tbl aggr_prio_tbl;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	int ret = 0, i, j;
 
 	ENTER();
@@ -2858,7 +2807,7 @@ int
 mwifiex_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data, int length)
 {
 	struct mwifiex_ds_11n_aggr_prio_tbl aggr_prio_tbl;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	int ret = 0, i, j;
 
 	ENTER();
@@ -2887,7 +2836,7 @@ int
 mwifiex_set_sleep_pd(struct mwifiex_private *priv, int sleeppd)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	u32 sleep_period;
 	struct mwifiex_wait_queue *wait = NULL;
 	ENTER();
@@ -2926,7 +2875,7 @@ int
 mwifiex_get_sleep_pd(struct mwifiex_private *priv, int *sleeppd)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	u32 sleep_period;
 	struct mwifiex_wait_queue *wait = NULL;
 	ENTER();
@@ -2988,7 +2937,7 @@ mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm)
 {
 	struct mwifiex_power_cfg power_cfg;
 	struct mwifiex_wait_queue *wait = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	int ret = 0;
 	ENTER();
 
@@ -3025,7 +2974,7 @@ int
 mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
 {
 	struct mwifiex_ds_misc_gen_ie gen_ie;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	int ret = 0;
 	ENTER();
 
@@ -3038,7 +2987,7 @@ mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
 	gen_ie.len = ie_len;
 	memcpy(gen_ie.ie_data, ie, ie_len);
 	status = mwifiex_misc_ioctl_gen_ie(priv, &gen_ie, HostCmd_ACT_GEN_SET);
-	if (status != MWIFIEX_STATUS_SUCCESS) {
+	if (status) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -3054,13 +3003,12 @@ done:
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-enum mwifiex_status
-mwifiex_get_scan_table(struct mwifiex_private *priv,
-		       u8 wait_option, struct mwifiex_scan_resp *scan_resp)
+int mwifiex_get_scan_table(struct mwifiex_private *priv, u8 wait_option,
+			   struct mwifiex_scan_resp *scan_resp)
 {
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_scan_resp scan;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 
 	ENTER();
 
@@ -3068,21 +3016,21 @@ mwifiex_get_scan_table(struct mwifiex_private *priv,
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_GET,
 				       NULL, &scan);
 
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (status == MWIFIEX_STATUS_SUCCESS) {
+	if (!status) {
 		if (scan_resp) {
 			memcpy(scan_resp, &scan,
 			       sizeof(struct mwifiex_scan_resp));
 		}
 	}
 
-	if (wait && (status != MWIFIEX_STATUS_PENDING))
+	if (wait && (status != -EINPROGRESS))
 		kfree(wait);
 	LEAVE();
 	return status;
@@ -3094,21 +3042,19 @@ mwifiex_get_scan_table(struct mwifiex_private *priv,
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-enum mwifiex_status
-mwifiex_get_signal_info(struct mwifiex_private *priv,
-			u8 wait_option,
-			struct mwifiex_ds_get_signal *signal)
+int mwifiex_get_signal_info(struct mwifiex_private *priv, u8 wait_option,
+			    struct mwifiex_ds_get_signal *signal)
 {
 	struct mwifiex_ds_get_signal info;
 	struct mwifiex_wait_queue *wait = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	ENTER();
 
 	/* Allocate wait buffer */
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
 	if (!wait) {
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	info.selector = ALL_RSSI_INFO_MASK;
@@ -3116,7 +3062,7 @@ mwifiex_get_signal_info(struct mwifiex_private *priv,
 	status = mwifiex_get_info_signal(priv, wait, &info);
 
 	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (status == MWIFIEX_STATUS_SUCCESS) {
+	if (!status) {
 		if (signal)
 			memcpy(signal, &info,
 			       sizeof(struct mwifiex_ds_get_signal));
@@ -3126,7 +3072,7 @@ mwifiex_get_signal_info(struct mwifiex_private *priv,
 			priv->w_stats.qual.noise = info.bcn_nf_avg;
 	}
 
-	if (wait && (status != MWIFIEX_STATUS_PENDING))
+	if (wait && (status != -EINPROGRESS))
 		kfree(wait);
 	LEAVE();
 	return status;
@@ -3138,9 +3084,8 @@ mwifiex_get_signal_info(struct mwifiex_private *priv,
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-enum mwifiex_status
-mwifiex_set_encrypt_mode(struct mwifiex_private *priv,
-			 u8 wait_option, u32 encrypt_mode)
+int mwifiex_set_encrypt_mode(struct mwifiex_private *priv,
+			     u8 wait_option, u32 encrypt_mode)
 {
 	ENTER();
 
@@ -3158,15 +3103,14 @@ int
 mwifiex_set_auth(struct mwifiex_private *priv, int encrypt_mode,
 		 int auth_mode, int wpa_enabled)
 {
-	int ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_set_encrypt_mode(priv, MWIFIEX_IOCTL_WAIT, encrypt_mode))
+	if (mwifiex_set_encrypt_mode(priv, MWIFIEX_IOCTL_WAIT, encrypt_mode))
 		ret = -EFAULT;
 
-	if (MWIFIEX_STATUS_SUCCESS != mwifiex_set_auth_mode(priv, auth_mode))
+	if (mwifiex_set_auth_mode(priv, auth_mode))
 		ret = -EFAULT;
 
 	LEAVE();
@@ -3191,7 +3135,7 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 {
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_encrypt_key encrypt_key;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	int ret = 0;
 
 	ENTER();
@@ -3220,8 +3164,7 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 			status = mwifiex_sec_ioctl_encrypt_key(priv, wait,
 							&encrypt_key,
 							HostCmd_ACT_GEN_SET);
-			if (MWIFIEX_STATUS_SUCCESS !=
-			    mwifiex_request_ioctl(priv, wait, status,
+			if (mwifiex_request_ioctl(priv, wait, status,
 						  MWIFIEX_IOCTL_WAIT)) {
 				ret = -EFAULT;
 				goto done;
@@ -3234,8 +3177,7 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 		status = mwifiex_sec_ioctl_encrypt_key(priv, wait, &encrypt_key,
 						       HostCmd_ACT_GEN_SET);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
+	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
 		ret = -EFAULT;
 done:
 	kfree(wait);
@@ -3253,7 +3195,7 @@ int
 mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	u32 ps_mode;
 
@@ -3288,7 +3230,7 @@ mwifiex_get_ver_ext(struct mwifiex_private *priv)
 {
 	struct mwifiex_ver_ext ver_ext;
 	struct mwifiex_wait_queue *wait = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	int ret = 0;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
@@ -3306,7 +3248,7 @@ mwifiex_get_ver_ext(struct mwifiex_private *priv)
 	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
 
 	if (ret) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -3326,7 +3268,7 @@ mwifiex_set_tx_rx_ant(struct mwifiex_private *priv, int antenna)
 {
 	int ret = 0;
 	u32 ant;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
@@ -3363,7 +3305,7 @@ int
 mwifiex_get_tx_rx_ant(struct mwifiex_private *priv, int *antenna)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	u32 ant;
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
@@ -3403,7 +3345,7 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
 		       struct mwifiex_ds_get_stats *log)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_get_stats get_log;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
@@ -3422,7 +3364,7 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
 
 	/* Send IOCTL request to MWIFIEX */
 	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
-	if (ret == MWIFIEX_STATUS_SUCCESS) {
+	if (!ret) {
 		if (log)
 			memcpy(log, &get_log, sizeof(struct
 					mwifiex_ds_get_stats));
@@ -3447,7 +3389,7 @@ mwifiex_reg_write(struct mwifiex_private *priv, u32 reg_type,
 		  u32 reg_offset, u32 reg_value)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_reg_rw reg_rw;
 
@@ -3483,7 +3425,7 @@ mwifiex_reg_read(struct mwifiex_private *priv, u32 reg_type,
 		 u32 reg_offset, u32 *value)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_reg_rw reg_rw;
 
@@ -3522,7 +3464,7 @@ mwifiex_eeprom_read(struct mwifiex_private *priv, u16 offset, u16 bytes,
 		    u8 *value)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_read_eeprom rd_eeprom;
 
@@ -3557,7 +3499,7 @@ mwifiex_set_11n_httx_cfg(struct mwifiex_private *priv, int data)
 {
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_11n_tx_cfg tx_cfg;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	int ret = 0;
 	ENTER();
 
@@ -3589,7 +3531,7 @@ mwifiex_get_11n_httx_cfg(struct mwifiex_private *priv, int *data)
 {
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_11n_tx_cfg tx_cfg;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	int ret = 0;
 	ENTER();
 
@@ -3657,7 +3599,7 @@ mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_idx)
 {
 	int ret = 0;
 	struct mwifiex_rate_cfg rate_cfg;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
@@ -3687,8 +3629,7 @@ mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_idx)
 	status = mwifiex_rate_ioctl_cfg(priv, wait, &rate_cfg);
 
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -3709,7 +3650,7 @@ mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_idx)
 {
 	int ret = 0;
 	struct mwifiex_rate_cfg rate_cfg;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
@@ -3719,7 +3660,7 @@ mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_idx)
 	if (!priv->media_connected) {
 		PRINTM(MINFO, "Can not set txratecfg in disconnected state\n");
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
@@ -3733,8 +3674,7 @@ mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_idx)
 	rate_cfg.rate_type = MWIFIEX_RATE_INDEX;
 	status = mwifiex_rate_ioctl_cfg(priv, wait, &rate_cfg);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+	if (mwifiex_request_ioctl(priv, wait, status, wait_option)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -3763,9 +3703,8 @@ done:
 /*
  * Set eWPA mode if passphrase/psk is set
  */
-enum mwifiex_status
-mwifiex_set_ewpa_mode_from_passphrase(struct mwifiex_private *priv,
-		   struct mwifiex_ds_passphrase *psec_pp)
+int mwifiex_set_ewpa_mode_from_passphrase(struct mwifiex_private *priv,
+					  struct mwifiex_ds_passphrase *psec_pp)
 {
 	ENTER();
 
@@ -3779,7 +3718,7 @@ mwifiex_set_ewpa_mode_from_passphrase(struct mwifiex_private *priv,
 	PRINTM(MINFO, "Set ewpa mode = %d\n", priv->sec_info.ewpa_enabled);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -3793,7 +3732,7 @@ int
 mwifiex_set_addba_param(struct mwifiex_private *priv, int *data)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_11n_addba_param addba_param;
 
@@ -3814,8 +3753,7 @@ mwifiex_set_addba_param(struct mwifiex_private *priv, int *data)
 					       &addba_param,
 					       HostCmd_ACT_GEN_SET);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
+	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -3837,7 +3775,7 @@ mwifiex_get_addba_param(struct mwifiex_private *priv, int *addba_timeout,
 		       int *tx_win_sz, int *rx_win_sz)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ds_11n_addba_param addba_param;
 
@@ -3853,8 +3791,7 @@ mwifiex_get_addba_param(struct mwifiex_private *priv, int *addba_timeout,
 					       &addba_param,
 					       HostCmd_ACT_GEN_GET);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-		mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
+	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -3881,7 +3818,7 @@ int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
 			   struct mwifiex_ds_passphrase *ds_passphrase)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_wait_queue  *wait = NULL;
 
 	ENTER();
@@ -3895,8 +3832,7 @@ int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
 	status = mwifiex_sec_ioctl_passphrase(priv, wait, ds_passphrase,
 					      action);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-		mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
+	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
 		ret = -EFAULT;
 		goto done;
 	}
@@ -3917,7 +3853,7 @@ int mwifiex_get_esupp_mode(struct mwifiex_private *priv,
 				  struct mwifiex_ds_esupp_mode *esupp_mode)
 {
 	int ret = 0;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_ds_esupp_mode esuppmode;
 	struct mwifiex_wait_queue *wait = NULL;
 
@@ -3930,8 +3866,7 @@ int mwifiex_get_esupp_mode(struct mwifiex_private *priv,
 	}
 	status = mwifiex_sec_ioctl_esupp_mode(priv, wait, &esuppmode);
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-		mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
+	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
 		ret =  -EFAULT;
 		goto done;
 	}
@@ -3954,7 +3889,7 @@ static int
 mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 			  u16 ie_len)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct ieee_types_vendor_header *pvendor_ie;
 	const u8 wpa_oui[] = { 0x00, 0x50, 0xf2, 0x01 };
 	const u8 wps_oui[] = { 0x00, 0x50, 0xf2, 0x04 };
@@ -3966,7 +3901,7 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 		priv->gen_ie_buf_len = 0;
 		priv->wps.session_enable = false;
 	} else if (!ie_data_ptr) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 	} else {
 		pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
 		/* Test to see if it is a WPA IE, if not, then it is a gen IE */
@@ -4015,12 +3950,12 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 			} else {
 				/* Passed data does not fit in the remaining
 				   buffer space */
-				ret = MWIFIEX_STATUS_FAILURE;
+				ret = -1;
 			}
 		}
 	}
 
-	/* Return MWIFIEX_STATUS_SUCCESS, or MWIFIEX_STATUS_FAILURE for error
+	/* Return 0, or -1 for error
 	   case */
 	LEAVE();
 	return ret;
@@ -4039,13 +3974,12 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
  *      - PMIC
  *      - CAU
  */
-enum mwifiex_status
-mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
-			     struct mwifiex_wait_queue *wait,
-			     struct mwifiex_ds_reg_rw *reg_rw,
-			     u16 action)
+int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
+				 struct mwifiex_wait_queue *wait,
+				 struct mwifiex_ds_reg_rw *reg_rw,
+				 u16 action)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u16 cmd_no;
 
 	ENTER();
@@ -4067,15 +4001,15 @@ mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
 		cmd_no = HostCmd_CMD_CAU_REG_ACCESS;
 		break;
 	default:
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, cmd_no, action, 0, wait, reg_rw);
 
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 exit:
 	LEAVE();
@@ -4088,12 +4022,11 @@ exit:
  * In addition to various generic IEs, this function can also be
  * used to set the ARP filter.
  */
-enum mwifiex_status
-mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
-			  struct mwifiex_ds_misc_gen_ie *gen_ie,
-			  u16 action)
+int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
+			      struct mwifiex_ds_misc_gen_ie *gen_ie,
+			      u16 action)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	ENTER();
@@ -4114,7 +4047,7 @@ mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 		if (gen_ie->len > ARP_FILTER_MAX_BUF_SIZE) {
 			adapter->arp_filter_size = 0;
 			PRINTM(MERROR, "Invalid ARP Filter Size\n");
-			ret = MWIFIEX_STATUS_FAILURE;
+			ret = -1;
 		} else {
 			memcpy(adapter->arp_filter, gen_ie->ie_data,
 								gen_ie->len);
@@ -4125,7 +4058,7 @@ mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
 		break;
 	default:
 		PRINTM(MERROR, "Invalid IE type\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 	}
 	LEAVE();
 	return ret;
@@ -4137,12 +4070,11 @@ mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
  * This function prepares the correct firmware command and
  * issues it.
  */
-enum mwifiex_status
-mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *priv,
-				  struct mwifiex_wait_queue *wait,
-				  struct mwifiex_ds_read_eeprom *rd_eeprom)
+int mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *priv,
+				      struct mwifiex_wait_queue *wait,
+				      struct mwifiex_ds_read_eeprom *rd_eeprom)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 
 	ENTER();
 
@@ -4150,8 +4082,8 @@ mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *priv,
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
 				  HostCmd_ACT_GEN_GET, 0, wait, rd_eeprom);
 
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 	LEAVE();
 	return ret;
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 8165513..b84ac6b 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -39,11 +39,10 @@
  *
  * The completion callback is called after processing in complete.
  */
-enum mwifiex_status
-mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
-			  struct sk_buff *skb)
+int mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
+			      struct sk_buff *skb)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct mwifiex_private *priv = adapter->priv[rx_info->bss_index];
 	struct rx_packet_hdr *rx_pkt_hdr;
@@ -106,7 +105,7 @@ mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 	priv->rxpd_htinfo = local_rx_pd->ht_info;
 
 	ret = mwifiex_recv_packet(adapter, skb);
-	if (ret == MWIFIEX_STATUS_FAILURE) {
+	if (ret == -1) {
 		PRINTM(MERROR,
 		       "RX Error: mwifiex_recv_packet" " returns failure\n");
 	}
@@ -128,11 +127,10 @@ mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
  *
  * The completion callback is called after processing in complete.
  */
-enum mwifiex_status
-mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
-				struct sk_buff *skb)
+int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
+				  struct sk_buff *skb)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct rxpd *local_rx_pd;
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct rx_packet_hdr *rx_pkt_hdr;
@@ -193,7 +191,7 @@ mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 						(void *) skb);
 
 	if (ret || (rx_pkt_type == PKT_TYPE_BAR)) {
-		if (priv && (ret == MWIFIEX_STATUS_FAILURE))
+		if (priv && (ret == -1))
 			priv->stats.rx_dropped++;
 
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 9dd05e1..0469da1 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -111,8 +111,7 @@ done:
  * The function creates a NULL data packet with TxPD and sends to the
  * firmware for transmission, with highest priority setting.
  */
-enum mwifiex_status
-mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
+int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct txpd *local_tx_pd;
@@ -120,29 +119,29 @@ mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 #define NULL_PACKET_HDR 64
 	u32 data_len = NULL_PACKET_HDR;
 	struct sk_buff *skb = NULL;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_txinfo *tx_info = NULL;
 
 	ENTER();
 
 	if (adapter->surprise_removed) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
 	if (!priv->media_connected) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
 	if (adapter->data_sent) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
 	skb = dev_alloc_skb(data_len);
 	if (!skb) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -164,22 +163,22 @@ mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
 					     skb->data, skb->len, NULL);
 	switch (ret) {
-	case MWIFIEX_STATUS_RESOURCE:
+	case -EBUSY:
 		adapter->data_sent = true;
 		/* Fall through FAILURE handling */
-	case MWIFIEX_STATUS_FAILURE:
+	case -1:
 		dev_kfree_skb_any(skb);
 		PRINTM(MERROR,
 		       "TX Error: mwifiex_send_null_packet failed! ret=%d\n",
 		       ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		goto done;
-	case MWIFIEX_STATUS_SUCCESS:
+	case 0:
 		dev_kfree_skb_any(skb);
 		PRINTM(MDATA, "TX: mwifiex_send_null_packet succeeded!\n");
 		adapter->tx_lock_flag = true;
 		break;
-	case MWIFIEX_STATUS_PENDING:
+	case -EINPROGRESS:
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index ceaf6b7..ed37437 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -34,11 +34,10 @@
  * packet will be further processed and sent to kernel/upper layer
  * if required.
  */
-enum mwifiex_status
-mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
-			 struct sk_buff *skb)
+int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
+			     struct sk_buff *skb)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_private *priv =
 		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	struct rxpd *local_rx_pd;
@@ -71,11 +70,10 @@ EXPORT_SYMBOL_GPL(mwifiex_handle_rx_packet);
  * On successful completion, the function calls the completion callback
  * and logs the time.
  */
-enum mwifiex_status
-mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
-		   struct mwifiex_tx_param *tx_param)
+int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
+		       struct mwifiex_tx_param *tx_param)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u8 *head_ptr = NULL;
 	struct txpd *local_tx_pd = NULL;
@@ -84,7 +82,7 @@ mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 
 	head_ptr = (u8 *) mwifiex_process_sta_txpd(priv, skb);
 	if (!head_ptr) {
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto done;
 	}
 
@@ -96,26 +94,26 @@ mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 done:
 
 	switch (ret) {
-	case MWIFIEX_STATUS_RESOURCE:
+	case -EBUSY:
 		if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
 			(adapter->pps_uapsd_mode) &&
 			(adapter->tx_lock_flag)) {
 				priv->adapter->tx_lock_flag = false;
 				local_tx_pd->flags = 0;
 		}
-		PRINTM(MDATA, "MWIFIEX_STATUS_RESOURCE is returned\n");
+		PRINTM(MDATA, "-EBUSY is returned\n");
 		break;
-	case MWIFIEX_STATUS_FAILURE:
+	case -1:
 		adapter->data_sent = false;
 		PRINTM(MERROR, "Error: mwifiex_write_data_async failed: 0x%X\n",
 		       ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, ret);
 		break;
-	case MWIFIEX_STATUS_PENDING:
+	case -EINPROGRESS:
 		adapter->data_sent = false;
 		break;
-	case MWIFIEX_STATUS_SUCCESS:
+	case 0:
 		mwifiex_write_data_complete(adapter, skb, ret);
 		break;
 	default:
@@ -133,17 +131,16 @@ done:
  * completion callback which checks conditions, updates statistics,
  * wakes up stalled traffic queue if required, and then frees the buffer.
  */
-enum mwifiex_status
-mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
-			    struct sk_buff *skb,
-			    enum mwifiex_status status)
+int mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
+				struct sk_buff *skb,
+				int status)
 {
 	struct mwifiex_private *priv = NULL, *tpriv = NULL;
 	struct mwifiex_txinfo *tx_info = NULL;
 	int i;
 
 	if (!skb)
-		return MWIFIEX_STATUS_SUCCESS;
+		return 0;
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
 	priv = mwifiex_bss_index_to_priv(adapter, tx_info->bss_index);
@@ -151,7 +148,7 @@ mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 		goto done;
 
 	priv->netdev->trans_start = jiffies;
-	if (status == MWIFIEX_STATUS_SUCCESS) {
+	if (!status) {
 		priv->stats.tx_packets++;
 		priv->stats.tx_bytes += skb->len;
 	} else {
@@ -173,7 +170,7 @@ mwifiex_write_data_complete(struct mwifiex_adapter *adapter,
 done:
 	dev_kfree_skb_any(skb);
 
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -183,12 +180,11 @@ done:
  * updates the statistics, and optionally updates the parent buffer
  * use count before freeing the received packet.
  */
-enum mwifiex_status
-mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
-			     struct sk_buff *skb,
-			     enum mwifiex_status status)
+int mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
+				 struct sk_buff *skb,
+				 int status)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
 	struct mwifiex_rxinfo *rx_info_parent = NULL;
 	struct mwifiex_private *priv;
@@ -199,7 +195,7 @@ mwifiex_recv_packet_complete(struct mwifiex_adapter *adapter,
 
 	priv = adapter->priv[rx_info->bss_index];
 
-	if (priv && (status == MWIFIEX_STATUS_FAILURE))
+	if (priv && (status == -1))
 		priv->stats.rx_dropped++;
 
 	if (rx_info->parent) {
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index ac7b492..3180542 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -32,8 +32,7 @@
  * This function wakes up the function waiting on the init
  * wait queue for the firmware initialization to complete.
  */
-enum mwifiex_status
-mwifiex_init_fw_complete(struct mwifiex_adapter *adapter)
+int mwifiex_init_fw_complete(struct mwifiex_adapter *adapter)
 {
 
 	ENTER();
@@ -41,7 +40,7 @@ mwifiex_init_fw_complete(struct mwifiex_adapter *adapter)
 	adapter->init_wait_q_woken = true;
 	wake_up_interruptible(&adapter->init_wait_q);
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -51,15 +50,14 @@ mwifiex_init_fw_complete(struct mwifiex_adapter *adapter)
  * the function waiting on the init wait queue for the firmware
  * shutdown to complete.
  */
-enum mwifiex_status
-mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter)
+int mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter)
 {
 	ENTER();
 	adapter->hw_status = MWIFIEX_HW_STATUS_NOT_READY;
 	adapter->init_wait_q_woken = true;
 	wake_up_interruptible(&adapter->init_wait_q);
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -69,13 +67,12 @@ mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter)
  * This function prepares the correct firmware command and
  * issues it.
  */
-enum mwifiex_status
-mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
-				 struct mwifiex_wait_queue *wait,
-				 u32 func_init_shutdown)
+int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
+				     struct mwifiex_wait_queue *wait,
+				     u32 func_init_shutdown)
 {
 	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	u16 cmd;
 
 	ENTER();
@@ -86,7 +83,7 @@ mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
 		cmd = HostCmd_CMD_FUNC_SHUTDOWN;
 	} else {
 		PRINTM(MERROR, "Unsupported parameter\n");
-		ret = MWIFIEX_STATUS_FAILURE;
+		ret = -1;
 		goto exit;
 	}
 
@@ -94,8 +91,8 @@ mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
 	ret = mwifiex_prepare_cmd(priv, cmd, HostCmd_ACT_GEN_SET,
 				  0, wait, NULL);
 
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
+	if (!ret)
+		ret = -EINPROGRESS;
 
 exit:
 	LEAVE();
@@ -108,11 +105,10 @@ exit:
  * This function collates/sets the information from/to different driver
  * structures.
  */
-enum mwifiex_status
-mwifiex_get_debug_info(struct mwifiex_private *priv,
-			    struct mwifiex_debug_info *info)
+int mwifiex_get_debug_info(struct mwifiex_private *priv,
+			   struct mwifiex_debug_info *info)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	ENTER();
@@ -185,20 +181,19 @@ mwifiex_get_debug_info(struct mwifiex_private *priv,
  * the function creates a blank SKB, fills it with the data from the
  * received buffer and then sends this new SKB to the kernel.
  */
-enum mwifiex_status
-mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
+int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 {
 	struct mwifiex_rxinfo *rx_info = NULL;
 	struct mwifiex_private *priv = NULL;
 	ENTER();
 
 	if (!skb)
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 
 	rx_info = MWIFIEX_SKB_RXCB(skb);
 	priv = mwifiex_bss_index_to_priv(adapter, rx_info->bss_index);
 	if (!priv)
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 
 	skb->dev = priv->netdev;
 	skb->protocol = eth_type_trans(skb, priv->netdev);
@@ -211,7 +206,7 @@ mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		netif_rx_ni(skb);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -219,25 +214,24 @@ mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
  *
  * This function updates the statistics and frees the buffer SKB.
  */
-enum mwifiex_status
-mwifiex_recv_complete(struct mwifiex_adapter *adapter,
-		struct sk_buff *skb, enum mwifiex_status status)
+int mwifiex_recv_complete(struct mwifiex_adapter *adapter,
+			  struct sk_buff *skb, int status)
 {
 	struct mwifiex_private *priv = NULL;
 	struct mwifiex_rxinfo *rx_info = NULL;
 
 	if (!skb)
-		return MWIFIEX_STATUS_SUCCESS;
+		return 0;
 
 	rx_info = MWIFIEX_SKB_RXCB(skb);
 	priv = mwifiex_bss_index_to_priv(adapter, rx_info->bss_index);
 
-	if (priv && (status == MWIFIEX_STATUS_FAILURE))
+	if (priv && (status == -1))
 		priv->stats.rx_dropped++;
 
 	dev_kfree_skb_any(skb);
 
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -287,10 +281,9 @@ EXPORT_SYMBOL_GPL(mwifiex_print);
  * corresponding waiting function. Otherwise, it processes the
  * IOCTL response and frees the response buffer.
  */
-enum mwifiex_status
-mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
-		       struct mwifiex_wait_queue *wait_queue,
-		       enum mwifiex_status status)
+int mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
+			   struct mwifiex_wait_queue *wait_queue,
+			   int status)
 {
 	enum mwifiex_error_code status_code =
 		(enum mwifiex_error_code) wait_queue->status;
@@ -305,14 +298,13 @@ mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
 	if (wait_queue->enabled) {
 		*wait_queue->condition = true;
 		wait_queue->status = status;
-		if ((status != MWIFIEX_STATUS_SUCCESS) &&
-		    (status_code == MWIFIEX_ERROR_CMD_TIMEOUT)) {
+		if (status && (status_code == MWIFIEX_ERROR_CMD_TIMEOUT)) {
 			PRINTM(MERROR, "IOCTL: command timeout\n");
 		} else {
 			wake_up_interruptible(wait_queue->wait);
 		}
 	} else {
-		if (status != MWIFIEX_STATUS_SUCCESS)
+		if (status)
 			PRINTM(MERROR,
 			       "IOCTL failed: status_code=0x%lx\n",
 			       status_code);
@@ -320,5 +312,5 @@ mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
 	}
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 0b3d71d..63d682e 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -550,8 +550,7 @@ mwifiex_wmm_del_pkts_in_ralist_node(struct mwifiex_private *priv,
 	struct sk_buff *skb, *tmp;
 
 	skb_queue_walk_safe(&ra_list->skb_head, skb, tmp) {
-		mwifiex_write_data_complete(adapter, skb,
-					     MWIFIEX_STATUS_FAILURE);
+		mwifiex_write_data_complete(adapter, skb, -1);
 	}
 }
 
@@ -714,8 +713,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 
 	if (!priv->media_connected) {
 		PRINTM(MWARN, "Drop packet in disconnect\n");
-		mwifiex_write_data_complete(adapter, skb,
-					    MWIFIEX_STATUS_FAILURE);
+		mwifiex_write_data_complete(adapter, skb, -1);
 		LEAVE();
 		return;
 	}
@@ -745,8 +743,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 
 	if (!ra_list) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
-		mwifiex_write_data_complete(adapter, skb,
-					     MWIFIEX_STATUS_FAILURE);
+		mwifiex_write_data_complete(adapter, skb, -1);
 		LEAVE();
 		return;
 	}
@@ -772,9 +769,8 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
  * This function parses the TLVs and then calls further specific functions
  * to process any changes in the queue prioritize or state.
  */
-enum mwifiex_status
-mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
-			   const struct host_cmd_ds_command *resp)
+int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
+			       const struct host_cmd_ds_command *resp)
 {
 	u8 *curr = (u8 *) &resp->params.get_wmm_status;
 	uint16_t resp_len = le16_to_cpu(resp->size), tlv_len;
@@ -854,7 +850,7 @@ mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 	mwifiex_wmm_setup_ac_downgrade(priv);
 
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
@@ -1122,7 +1118,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 	struct sk_buff *skb, *skb_next;
 	struct mwifiex_tx_param tx_param;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	int status = 0;
 	struct mwifiex_txinfo *tx_info;
 
 	ENTER();
@@ -1154,7 +1150,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 
 	status = mwifiex_process_tx(priv, skb, &tx_param);
 
-	if (status == MWIFIEX_STATUS_RESOURCE) {
+	if (status == -EBUSY) {
 		/** Queue the packet back at the head */
 		PRINTM(MDAT_D, "Queuing pkt back to raList %p %p\n",
 		       ptr, skb);
@@ -1164,8 +1160,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 			spin_unlock_irqrestore(
 					&priv->wmm.ra_list_spinlock,
 					ra_list_flags);
-			mwifiex_write_data_complete(adapter, skb,
-					MWIFIEX_STATUS_FAILURE);
+			mwifiex_write_data_complete(adapter, skb, -1);
 			LEAVE();
 			return;
 		}
@@ -1231,7 +1226,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 {
 	struct mwifiex_tx_param tx_param;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	enum mwifiex_status ret = MWIFIEX_STATUS_FAILURE;
+	int ret = -1;
 	struct sk_buff *skb, *skb_next;
 	struct mwifiex_txinfo *tx_info;
 
@@ -1261,16 +1256,15 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 					     skb->data, skb->len,
 					     &tx_param);
 	switch (ret) {
-	case MWIFIEX_STATUS_RESOURCE:
-		PRINTM(MDATA, "MWIFIEX_STATUS_RESOURCE is returned\n");
+	case -EBUSY:
+		PRINTM(MDATA, "-EBUSY is returned\n");
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
 		if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
 			spin_unlock_irqrestore(
 					&priv->wmm.ra_list_spinlock,
 					ra_list_flags);
-			mwifiex_write_data_complete(adapter, skb,
-					MWIFIEX_STATUS_FAILURE);
+			mwifiex_write_data_complete(adapter, skb, -1);
 			LEAVE();
 			return;
 		}
@@ -1281,19 +1275,19 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		break;
-	case MWIFIEX_STATUS_FAILURE:
+	case -1:
 		adapter->data_sent = false;
 		PRINTM(MERROR,
 		       "Error: mwifiex_write_data failed: 0x%X\n", ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, ret);
 		break;
-	case MWIFIEX_STATUS_PENDING:
+	case -EINPROGRESS:
 		adapter->data_sent = false;
 	default:
 		break;
 	}
-	if (ret != MWIFIEX_STATUS_RESOURCE) {
+	if (ret != -EBUSY) {
 		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
 		if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
 			priv->wmm.packets_out[ptr_index]++;
@@ -1333,7 +1327,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 							&ptr_index);
 	if (!ptr) {
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	tid = mwifiex_get_tid(priv->adapter, ptr);
@@ -1344,7 +1338,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 	if (!mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		return -1;
 	}
 
 	if (mwifiex_is_ptr_processed(priv, ptr)) {
@@ -1352,7 +1346,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		/* ra_list_spinlock has been freed in
 		   mwifiex_send_processed_packet() */
 		LEAVE();
-		return MWIFIEX_STATUS_SUCCESS;
+		return 0;
 	}
 
 	if (!ptr->is_11n_enabled || mwifiex_is_ba_stream_setup(priv, ptr, tid)
@@ -1397,7 +1391,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		}
 	}
 	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
+	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 37c6032..8e7785f 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -104,10 +104,7 @@ void mwifiex_wmm_setup_queue_priorities(struct mwifiex_private *priv,
 					struct ieee_types_wmm_parameter
 					*wmm_ie);
 void mwifiex_wmm_setup_ac_downgrade(struct mwifiex_private *priv);
-extern enum mwifiex_status mwifiex_ret_wmm_get_status(struct mwifiex_private
-						      *priv,
-						      const struct
-						      host_cmd_ds_command
-						      *resp);
+extern int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
+				      const struct host_cmd_ds_command *resp);
 
 #endif /* !_MWIFIEX_WMM_H_ */
-- 
1.7.0.2

