Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38030 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab1BQXgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 18:36:16 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: cleanup command ioctls and abstraction layers
Date: Thu, 17 Feb 2011 15:38:32 -0800
Message-Id: <1297985912-5044-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When sending a command, the original driver allocates
an ioctl request and goes through multiple unncessary
abstraction layers before the command is prepared and
sent to the firware.

This patch removes struct mwifiex_ioctl_req, its
allocations, and all of the abstraction layers.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c         |  278 +--
 drivers/net/wireless/mwifiex/11n.h         |   32 +-
 drivers/net/wireless/mwifiex/cfg80211.c    |  161 +-
 drivers/net/wireless/mwifiex/cmdevt.c      |  245 +-
 drivers/net/wireless/mwifiex/debugfs.c     |   31 +-
 drivers/net/wireless/mwifiex/decl.h        |   13 +-
 drivers/net/wireless/mwifiex/fw.h          |    6 +-
 drivers/net/wireless/mwifiex/init.c        |    2 +-
 drivers/net/wireless/mwifiex/ioctl.h       |  225 +--
 drivers/net/wireless/mwifiex/join.c        |   50 +-
 drivers/net/wireless/mwifiex/main.c        |   52 +-
 drivers/net/wireless/mwifiex/main.h        |  243 ++-
 drivers/net/wireless/mwifiex/scan.c        |  213 +-
 drivers/net/wireless/mwifiex/sta_cmd.c     |   16 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  469 ++---
 drivers/net/wireless/mwifiex/sta_ioctl.c   | 4044 +++++++---------------------
 drivers/net/wireless/mwifiex/util.c        |  293 +--
 17 files changed, 1868 insertions(+), 4505 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index eab270c..ee33e69 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -27,67 +27,29 @@
 #include "11n.h"
 
 /*
- * IOCTL request handler to set/get maximum Tx buffer size.
- *
- * Only the following buffer sizes are supported -
- *      - MWIFIEX_TX_DATA_BUF_SIZE_2K : 2 KBytes
- *      - MWIFIEX_TX_DATA_BUF_SIZE_4K : 4 KBytes
- *      - MWIFIEX_TX_DATA_BUF_SIZE_8K : 8 KBytes
- */
-static enum mwifiex_status
-mwifiex_11n_ioctl_max_tx_buf_size(struct mwifiex_adapter *adapter,
-				  struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_11n_cfg *cfg = NULL;
-
-	ENTER();
-
-	cfg = (struct mwifiex_ds_11n_cfg *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_SET) {
-		if ((cfg->param.tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_2K) ||
-		    (cfg->param.tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_4K) ||
-		    (cfg->param.tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_8K)) {
-			adapter->max_tx_buf_size =
-				(u16) cfg->param.tx_buf_size;
-		} else
-			ret = MWIFIEX_STATUS_FAILURE;
-	} else
-		cfg->param.tx_buf_size = (u32) adapter->max_tx_buf_size;
-	ioctl_req->data_read_written =
-		sizeof(u32) + MWIFIEX_SUB_COMMAND_SIZE;
-
-	LEAVE();
-	return ret;
-}
-
-/*
  * IOCTL request handler to set/get 11n HT capability.
  */
-static enum mwifiex_status
-wlan_11n_ioctl_ht_usr_cfg(struct mwifiex_adapter *adapter,
-			struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv, u16 action,
+			      int *htcap_cfg)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_11n_cfg *cfg = NULL;
+	int ret = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
 
 	ENTER();
 
-	cfg = (struct mwifiex_ds_11n_cfg *) ioctl_req->buffer;
-
-	if (ioctl_req->action == MWIFIEX_ACT_SET) {
-		if (((cfg->param.htcap_cfg & ~IGN_HW_DEV_CAP) &
-		     priv->adapter->hw_dot_11n_dev_cap)
-		    != (cfg->param.htcap_cfg & ~IGN_HW_DEV_CAP))
-			ret = MWIFIEX_STATUS_FAILURE;
+	if (action == HostCmd_ACT_GEN_SET) {
+		if (((*htcap_cfg & ~IGN_HW_DEV_CAP) &
+		     adapter->hw_dot_11n_dev_cap)
+		    != (*htcap_cfg & ~IGN_HW_DEV_CAP))
+			ret = -EFAULT;
 		else
-			adapter->usr_dot_11n_dev_cap = cfg->param.htcap_cfg;
+			adapter->usr_dot_11n_dev_cap = *htcap_cfg;
 		PRINTM(MINFO, "UsrDot11nCap 0x%x\n",
 		       adapter->usr_dot_11n_dev_cap);
 	} else {
-		cfg->param.htcap_cfg = adapter->usr_dot_11n_dev_cap;
-		PRINTM(MINFO, "UsrDot11nCap 0x%x\n", cfg->param.htcap_cfg);
+		*htcap_cfg = adapter->usr_dot_11n_dev_cap;
+		PRINTM(MINFO, "UsrDot11nCap 0x%x\n", *htcap_cfg);
 	}
 
 	LEAVE();
@@ -100,31 +62,20 @@ wlan_11n_ioctl_ht_usr_cfg(struct mwifiex_adapter *adapter,
  * This function prepares the correct firmware command and
  * issues it.
  */
-static enum mwifiex_status
+enum mwifiex_status
 mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
-				  struct mwifiex_ioctl_req *ioctl_req)
+				  struct mwifiex_wait_queue *wait_queue,
+				  struct mwifiex_ds_11n_amsdu_aggr_ctrl
+				  *amsdu_aggr_ctrl, u16 action)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_11n_cfg *cfg = NULL;
-	u16 cmd_action = 0;
+	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
 
 	ENTER();
 
-	PRINTM(MERROR, "Prepare the command\n");
-	cfg = (struct mwifiex_ds_11n_cfg *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_SET)
-		cmd_action = HostCmd_ACT_GEN_SET;
-	else
-		cmd_action = HostCmd_ACT_GEN_GET;
-
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_AMSDU_AGGR_CTRL,
-				  cmd_action,
-				  0,
-				  (void *) ioctl_req,
-				  (void *) &cfg->param.amsdu_aggr_ctrl);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_AMSDU_AGGR_CTRL, action, 0,
+				  wait_queue, amsdu_aggr_ctrl);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 
@@ -138,29 +89,19 @@ mwifiex_11n_ioctl_amsdu_aggr_ctrl(struct mwifiex_adapter *adapter,
  * This function prepares the correct firmware command and
  * issues it.
  */
-static enum mwifiex_status
+enum mwifiex_status
 mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
-			  struct mwifiex_ioctl_req *ioctl_req)
+			  struct mwifiex_wait_queue *wait_queue,
+			  struct mwifiex_ds_11n_tx_cfg *tx_cfg,
+			  u16 action)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_11n_cfg *cfg = NULL;
-	u16 cmd_action = 0;
+	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
 
 	ENTER();
 
-	cfg = (struct mwifiex_ds_11n_cfg *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_SET)
-		cmd_action = HostCmd_ACT_GEN_SET;
-	else
-		cmd_action = HostCmd_ACT_GEN_GET;
-
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_11N_CFG,
-				  cmd_action,
-				  0,
-				  (void *) ioctl_req,
-				  (void *) &cfg->param.tx_cfg);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_CFG, action, 0,
+				  wait_queue, tx_cfg);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 
@@ -176,31 +117,31 @@ mwifiex_11n_ioctl_ht_tx_cfg(struct mwifiex_adapter *adapter,
  *      - Rx window size
  *      - Tiemout value
  */
-static enum mwifiex_status
+enum mwifiex_status
 mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
-			      struct mwifiex_ioctl_req *ioctl_req)
+			      struct mwifiex_wait_queue *wait_queue,
+			      struct mwifiex_ds_11n_addba_param *addba_param,
+			      u16 action)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_11n_cfg *cfg = NULL;
+	struct mwifiex_private *priv = adapter->priv[wait_queue->bss_index];
 	u32 timeout;
 
 	ENTER();
 
-	cfg = (struct mwifiex_ds_11n_cfg *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
-		cfg->param.addba_param.timeout = priv->add_ba_param.timeout;
-		cfg->param.addba_param.tx_win_size =
+	if (action == HostCmd_ACT_GEN_GET) {
+		addba_param->timeout = priv->add_ba_param.timeout;
+		addba_param->tx_win_size =
 			priv->add_ba_param.tx_win_size;
-		cfg->param.addba_param.rx_win_size =
+		addba_param->rx_win_size =
 			priv->add_ba_param.rx_win_size;
 	} else {
 		timeout = priv->add_ba_param.timeout;
-		priv->add_ba_param.timeout = cfg->param.addba_param.timeout;
+		priv->add_ba_param.timeout = addba_param->timeout;
 		priv->add_ba_param.tx_win_size =
-			cfg->param.addba_param.tx_win_size;
+			addba_param->tx_win_size;
 		priv->add_ba_param.rx_win_size =
-			cfg->param.addba_param.rx_win_size;
+			addba_param->rx_win_size;
 		if (timeout != priv->add_ba_param.timeout)
 			mwifiex_11n_update_addba_request(priv);
 
@@ -215,22 +156,18 @@ mwifiex_11n_ioctl_addba_param(struct mwifiex_adapter *adapter,
  *
  * The configuration can only be set in disconnected state.
  */
-static enum mwifiex_status
-mwifiex_11n_ioctl_addba_reject(struct mwifiex_adapter *adapter,
-			       struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_set_get_addba_reject(struct mwifiex_private *priv,
+			     u16 action, int *addba_reject)
 {
 	int i = 0;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_11n_cfg *cfg = NULL;
 
 	ENTER();
 
-	cfg = (struct mwifiex_ds_11n_cfg *) ioctl_req->buffer;
-
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
+	if (action == HostCmd_ACT_GEN_GET) {
 		PRINTM(MINFO, "Addba reject GET\n");
-		memcpy(cfg->param.addba_reject, priv->addba_reject,
+		memcpy(addba_reject, priv->addba_reject,
 		       MAX_NUM_TID);
 	} else {
 		if (priv->media_connected) {
@@ -243,13 +180,12 @@ mwifiex_11n_ioctl_addba_reject(struct mwifiex_adapter *adapter,
 
 		for (i = 0; i < MAX_NUM_TID; i++) {
 			/* For AMPDU */
-			if (cfg->param.addba_reject[i] >
-			    ADDBA_RSP_STATUS_REJECT) {
+			if (addba_reject[i] > ADDBA_RSP_STATUS_REJECT) {
 				ret = MWIFIEX_STATUS_FAILURE;
 				break;
 			}
 
-			priv->addba_reject[i] = cfg->param.addba_reject[i];
+			priv->addba_reject[i] = addba_reject[i];
 		}
 	}
 
@@ -263,24 +199,21 @@ mwifiex_11n_ioctl_addba_reject(struct mwifiex_adapter *adapter,
  * The configuration can only be set in disconnected state.
  * Setting of both AMPDU and AMSDU priority tables are supported.
  */
-static enum mwifiex_status
-mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_adapter *adapter,
-				struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_private *priv,
+				struct mwifiex_ds_11n_aggr_prio_tbl
+				*aggr_prio_tbl, u16 action)
 {
 	int i = 0;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_11n_cfg *cfg = NULL;
 
 	ENTER();
 
-	cfg = (struct mwifiex_ds_11n_cfg *) ioctl_req->buffer;
-
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
+	if (action == HostCmd_ACT_GEN_GET) {
 		for (i = 0; i < MAX_NUM_TID; i++) {
-			cfg->param.aggr_prio_tbl.ampdu[i] =
+			aggr_prio_tbl->ampdu[i] =
 				priv->aggr_prio_tbl[i].ampdu_user;
-			cfg->param.aggr_prio_tbl.amsdu[i] =
+			aggr_prio_tbl->amsdu[i] =
 				priv->aggr_prio_tbl[i].amsdu;
 		}
 	} else {
@@ -294,8 +227,8 @@ mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_adapter *adapter,
 
 		for (i = 0; i < MAX_NUM_TID; i++) {
 			/* For AMPDU */
-			if ((cfg->param.aggr_prio_tbl.ampdu[i] > HIGH_PRIO_TID)
-			    && (cfg->param.aggr_prio_tbl.ampdu[i] !=
+			if ((aggr_prio_tbl->ampdu[i] > HIGH_PRIO_TID)
+			    && (aggr_prio_tbl->ampdu[i] !=
 				BA_STREAM_NOT_ALLOWED)) {
 				ret = MWIFIEX_STATUS_FAILURE;
 				break;
@@ -303,17 +236,17 @@ mwifiex_11n_ioctl_aggr_prio_tbl(struct mwifiex_adapter *adapter,
 
 			priv->aggr_prio_tbl[i].ampdu_ap =
 				priv->aggr_prio_tbl[i].ampdu_user =
-				cfg->param.aggr_prio_tbl.ampdu[i];
+				aggr_prio_tbl->ampdu[i];
 
 			/* For AMSDU */
-			if ((cfg->param.aggr_prio_tbl.amsdu[i] > HIGH_PRIO_TID
-			     && cfg->param.aggr_prio_tbl.amsdu[i] !=
+			if ((aggr_prio_tbl->amsdu[i] > HIGH_PRIO_TID
+			     && aggr_prio_tbl->amsdu[i] !=
 			     BA_STREAM_NOT_ALLOWED)) {
 				ret = MWIFIEX_STATUS_FAILURE;
 				break;
 			} else {
 				priv->aggr_prio_tbl[i].amsdu =
-					cfg->param.aggr_prio_tbl.amsdu[i];
+					aggr_prio_tbl->amsdu[i];
 			}
 		}
 	}
@@ -657,16 +590,16 @@ mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 enum mwifiex_status
 mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
 		    struct host_cmd_ds_command *resp,
-		    struct mwifiex_ioctl_req *ioctl_buf)
+		    void *data_buf)
 {
-	struct mwifiex_ds_11n_cfg *cfg = NULL;
+	struct mwifiex_ds_11n_tx_cfg *tx_cfg = NULL;
 	struct host_cmd_ds_11n_cfg *htcfg = &resp->params.htcfg;
 
 	ENTER();
-	if (ioctl_buf) {
-		cfg = (struct mwifiex_ds_11n_cfg *) ioctl_buf->buffer;
-		cfg->param.tx_cfg.tx_htcap = le16_to_cpu(htcfg->ht_tx_cap);
-		cfg->param.tx_cfg.tx_htinfo = le16_to_cpu(htcfg->ht_tx_info);
+	if (data_buf) {
+		tx_cfg = (struct mwifiex_ds_11n_tx_cfg *) data_buf;
+		tx_cfg->tx_htcap = le16_to_cpu(htcfg->ht_tx_cap);
+		tx_cfg->tx_htinfo = le16_to_cpu(htcfg->ht_tx_info);
 	}
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
@@ -756,19 +689,19 @@ mwifiex_cmd_amsdu_aggr_ctrl(struct mwifiex_private *priv,
 enum mwifiex_status
 mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
 			    struct host_cmd_ds_command *resp,
-			    struct mwifiex_ioctl_req *ioctl_buf)
+			    void *data_buf)
 {
-	struct mwifiex_ds_11n_cfg *cfg = NULL;
+	struct mwifiex_ds_11n_amsdu_aggr_ctrl *amsdu_aggr_ctrl = NULL;
 	struct host_cmd_ds_amsdu_aggr_ctrl *amsdu_ctrl =
 		&resp->params.amsdu_aggr_ctrl;
 
 	ENTER();
 
-	if (ioctl_buf) {
-		cfg = (struct mwifiex_ds_11n_cfg *) ioctl_buf->buffer;
-		cfg->param.amsdu_aggr_ctrl.enable =
-			le16_to_cpu(amsdu_ctrl->enable);
-		cfg->param.amsdu_aggr_ctrl.curr_buf_size =
+	if (data_buf) {
+		amsdu_aggr_ctrl =
+			(struct mwifiex_ds_11n_amsdu_aggr_ctrl *) data_buf;
+		amsdu_aggr_ctrl->enable = le16_to_cpu(amsdu_ctrl->enable);
+		amsdu_aggr_ctrl->curr_buf_size =
 			le16_to_cpu(amsdu_ctrl->curr_buf_size);
 	}
 	LEAVE();
@@ -993,73 +926,6 @@ mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to set/get 11n parameters.
- *
- * This function is the generic handler and calls other specific handler
- * function based upon the parameters type.
- *
- * Currently, it supports the following 11n parameter set/get requests -
- *      MWIFIEX_OID_11N_CFG_TX -              Set/get 11n Tx configuration
- *      MWIFIEX_OID_11N_HTCAP_CFG -           Set/get 11n HT capability
- *      MWIFIEX_OID_11N_CFG_AGGR_PRIO_TBL -   Set/get aggregated priority
- *                                            table configurations
- *      MWIFIEX_OID_11N_CFG_ADDBA_REJECT -    Set/get add BA reject
- *                                            configurations
- *      MWIFIEX_OID_11N_CFG_ADDBA_PARAM  -    Set/get add BA parameters
- *      MWIFIEX_OID_11N_CFG_MAX_TX_BUF_SIZE - Set/get maximum Tx buffer size
- *      MWIFIEX_OID_11N_CFG_AMSDU_AGGR_CTRL - Set/get AMSDU aggregation
- *                                            control
- */
-enum mwifiex_status
-mwifiex_11n_cfg_ioctl(struct mwifiex_adapter *adapter,
-		      struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_11n_cfg *cfg = NULL;
-
-	ENTER();
-
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_11n_cfg)) {
-		PRINTM(MINFO, "IOCTL length is too short.\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed = sizeof(struct mwifiex_ds_11n_cfg);
-		LEAVE();
-		return MWIFIEX_STATUS_RESOURCE;
-	}
-	cfg = (struct mwifiex_ds_11n_cfg *) ioctl_req->buffer;
-	switch (cfg->sub_command) {
-	case MWIFIEX_OID_11N_CFG_TX:
-		status = mwifiex_11n_ioctl_ht_tx_cfg(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_11N_HTCAP_CFG:
-		status = wlan_11n_ioctl_ht_usr_cfg(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_11N_CFG_AGGR_PRIO_TBL:
-		status = mwifiex_11n_ioctl_aggr_prio_tbl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_11N_CFG_ADDBA_REJECT:
-		status = mwifiex_11n_ioctl_addba_reject(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_11N_CFG_ADDBA_PARAM:
-		status = mwifiex_11n_ioctl_addba_param(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_11N_CFG_MAX_TX_BUF_SIZE:
-		status = mwifiex_11n_ioctl_max_tx_buf_size(adapter,
-							   ioctl_req);
-		break;
-	case MWIFIEX_OID_11N_CFG_AMSDU_AGGR_CTRL:
-		status = mwifiex_11n_ioctl_amsdu_aggr_ctrl(adapter,
-							   ioctl_req);
-		break;
-	default:
-		status = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-	LEAVE();
-	return status;
-}
-
-/*
  * This function checks if the given pointer is valid entry of
  * Tx BA Stream table.
  */
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 21460c8..9b919d5 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -33,7 +33,7 @@ enum mwifiex_status mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 					      struct host_cmd_ds_command *resp);
 enum mwifiex_status mwifiex_ret_11n_cfg(struct mwifiex_private *priv,
 					struct host_cmd_ds_command *resp,
-					struct mwifiex_ioctl_req *ioctl_buf);
+					void *data_buf);
 enum mwifiex_status mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
 					struct host_cmd_ds_command *cmd,
 					u16 cmd_action, void *data_buf);
@@ -49,8 +49,31 @@ void mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
 			struct mwifiex_bssdescriptor *bss_desc);
 void mwifiex_fill_cap_info(struct mwifiex_private *,
 			   struct mwifiex_ie_types_htcap *);
-enum mwifiex_status mwifiex_11n_cfg_ioctl(struct mwifiex_adapter *adapter,
-					  struct mwifiex_ioctl_req *ioctl_req);
+enum mwifiex_status mwifiex_11n_ioctl_ht_tx_cfg(
+					struct mwifiex_adapter *adapter,
+					struct mwifiex_wait_queue *wait_queue,
+					struct mwifiex_ds_11n_tx_cfg *tx_cfg,
+					u16 action);
+enum mwifiex_status mwifiex_set_get_11n_htcap_cfg(
+					struct mwifiex_private *priv,
+					u16 action, int *htcap_cfg);
+enum mwifiex_status mwifiex_11n_ioctl_aggr_prio_tbl(
+					struct mwifiex_private *priv,
+					struct mwifiex_ds_11n_aggr_prio_tbl
+					*aggr_prio_tbl, u16 action);
+enum mwifiex_status mwifiex_set_get_addba_reject(
+					struct mwifiex_private *priv,
+					u16 action, int *);
+enum mwifiex_status mwifiex_11n_ioctl_addba_param(
+					struct mwifiex_adapter *adapter,
+					struct mwifiex_wait_queue *wait_queue,
+					struct mwifiex_ds_11n_addba_param
+					*addba_param, u16 action);
+enum mwifiex_status mwifiex_11n_ioctl_amsdu_aggr_ctrl(
+					struct mwifiex_adapter *adapter,
+					struct mwifiex_wait_queue *wait_queue,
+					struct mwifiex_ds_11n_amsdu_aggr_ctrl
+					*amsdu_aggr_ctrl, u16 action);
 void mwifiex_11n_delete_tx_ba_stream_tbl_entry(struct mwifiex_private *priv,
 					     struct mwifiex_tx_ba_stream_tbl
 					     *tx_tbl);
@@ -80,8 +103,7 @@ int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 enum mwifiex_status mwifiex_ret_amsdu_aggr_ctrl(struct mwifiex_private *priv,
 						struct host_cmd_ds_command
 						*resp,
-						struct mwifiex_ioctl_req
-						*ioctl_buf);
+						void *data_buf);
 enum mwifiex_status mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
 					     struct host_cmd_ds_command *cmd,
 					     int cmd_action, void *data_buf);
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fc9a116..ef7824b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -358,31 +358,21 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 		       struct ieee80211_channel *chan,
 		       enum nl80211_channel_type channel_type)
 {
-	struct mwifiex_ds_bss *bss = NULL;
-	u32 freq = chan->center_freq;
+	struct mwifiex_chan_freq_power cfp;
 	int ret = 0;
-	struct mwifiex_ioctl_req *req1 = NULL, *req2 = NULL;
-	struct mwifiex_ds_radio_cfg *radio_cfg = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_ds_band_cfg band_cfg;
 	int mode;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 	u32 config_bands = 0;
 	struct wiphy *wiphy = priv->wdev->wiphy;
 
 	ENTER();
 
-	mode = mwifiex_drv_get_mode(priv, MWIFIEX_IOCTL_WAIT);
-
-	req1 = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_radio_cfg));
-	if (req1 == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	radio_cfg = (struct mwifiex_ds_radio_cfg *) req1->buffer;
-	radio_cfg->sub_command = MWIFIEX_OID_BAND_CFG;
-	req1->req_id = MWIFIEX_IOCTL_RADIO_CFG;
+	mode = mwifiex_drv_get_mode(priv, wait_option);
 
 	if (chan) {
-		req1->action = MWIFIEX_ACT_SET;
+		memset(&band_cfg, 0, sizeof(band_cfg));
 		/* Set appropriate bands */
 		if (chan->band == IEEE80211_BAND_2GHZ)
 			config_bands = BAND_B | BAND_G | BAND_GN;
@@ -390,19 +380,19 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 			config_bands = BAND_AN | BAND_A;
 		if (mode == MWIFIEX_BSS_MODE_INFRA
 		    || mode == MWIFIEX_BSS_MODE_AUTO) {
-			radio_cfg->param.band_cfg.config_bands = config_bands;
+			band_cfg.config_bands = config_bands;
 		} else if (mode == MWIFIEX_BSS_MODE_IBSS) {
-			radio_cfg->param.band_cfg.config_bands = config_bands;
-			radio_cfg->param.band_cfg.adhoc_start_band =
-				config_bands;
+			band_cfg.config_bands = config_bands;
+			band_cfg.adhoc_start_band = config_bands;
 		}
 		/* Set channel offset */
-		radio_cfg->param.band_cfg.sec_chan_offset =
+		band_cfg.sec_chan_offset =
 			mwifiex_cfg80211_channel_type_to_mwifiex_channels
 			(channel_type);
+		status = mwifiex_radio_ioctl_band_cfg(priv, HostCmd_ACT_GEN_SET,
+						      &band_cfg);
 
-		if (MWIFIEX_STATUS_SUCCESS !=
-		    mwifiex_request_ioctl(priv, req1, MWIFIEX_IOCTL_WAIT)) {
+		if (status != MWIFIEX_STATUS_SUCCESS) {
 			ret = -EFAULT;
 			goto done;
 		}
@@ -410,38 +400,25 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 	}
 
 	PRINTM(MINFO, "Setting band %d, channel offset %d and mode = %d\n",
-	       config_bands, radio_cfg->param.band_cfg.sec_chan_offset, mode);
-
-	req2 = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req2 == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	bss = (struct mwifiex_ds_bss *) req2->buffer;
+	       config_bands, band_cfg.sec_chan_offset, mode);
 
-	bss->param.bss_chan.freq = freq;
-	/*
-	 *  Convert frequency to  channel
-	 */
-	bss->param.bss_chan.channel =
-		ieee80211_frequency_to_channel(chan->center_freq);
-
-	bss->sub_command = MWIFIEX_OID_BSS_CHANNEL;
-	req2->req_id = MWIFIEX_IOCTL_BSS;
+	if (chan) {
+		memset(&cfp, 0, sizeof(cfp));
+		cfp.freq = chan->center_freq;
+		/* Convert frequency to channel */
+		cfp.channel = ieee80211_frequency_to_channel(chan->center_freq);
+
+		status = mwifiex_bss_ioctl_channel(priv, HostCmd_ACT_GEN_SET,
+						   &cfp);
+		if (MWIFIEX_STATUS_SUCCESS != status) {
+			ret = -EFAULT;
+			goto done;
+		}
 
-	req2->action = MWIFIEX_ACT_SET;
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req2, MWIFIEX_IOCTL_WAIT)) {
-		ret = -EFAULT;
-		goto done;
+		ret = mwifiex_drv_change_adhoc_chan(priv, cfp.channel);
 	}
 
-	ret = mwifiex_drv_change_adhoc_chan(priv, bss->param.bss_chan.channel);
-
 done:
-	kfree(req1);
-	kfree(req2);
 	LEAVE();
 	return ret;
 }
@@ -484,8 +461,10 @@ static int
 mwifiex_set_frag(struct mwifiex_private *priv, u32 frag_thr)
 {
 	int ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_snmp_mib *mib = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+
 	ENTER();
 
 	if (frag_thr < MWIFIEX_FRAG_MIN_VALUE
@@ -494,26 +473,23 @@ mwifiex_set_frag(struct mwifiex_private *priv, u32 frag_thr)
 		goto done;
 	}
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_snmp_mib));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	mib = (struct mwifiex_ds_snmp_mib *) req->buffer;
-	mib->sub_command = cpu_to_le32(MWIFIEX_OID_SNMP_MIB_FRAG_THRESHOLD);
-	mib->param.frag_threshold = cpu_to_le32(frag_thr);
-	req->req_id = MWIFIEX_IOCTL_SNMP_MIB;
-	req->action = MWIFIEX_ACT_SET;
+	status = mwifiex_snmp_mib_ioctl(priv, wait, FRAG_THRESH_I,
+					HostCmd_ACT_GEN_SET, &frag_thr);
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
 		ret = -EFAULT;
 		goto done;
 	}
 
 done:
-	kfree(req);
+	kfree(wait);
 	return ret;
 }
 
@@ -526,36 +502,34 @@ done:
 static int
 mwifiex_set_rts(struct mwifiex_private *priv, u32 rts_thr)
 {
-	struct mwifiex_ds_snmp_mib *mib = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
 	int ret = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
 	ENTER();
 
 	if (rts_thr < MWIFIEX_RTS_MIN_VALUE || rts_thr > MWIFIEX_RTS_MAX_VALUE)
 		rts_thr = MWIFIEX_RTS_MAX_VALUE;
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_snmp_mib));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	mib = (struct mwifiex_ds_snmp_mib *) req->buffer;
-	mib->sub_command = cpu_to_le32(MWIFIEX_OID_SNMP_MIB_RTS_THRESHOLD);
-	mib->param.rts_threshold = cpu_to_le32(rts_thr);
-	req->req_id = MWIFIEX_IOCTL_SNMP_MIB;
-	req->action = MWIFIEX_ACT_SET;
+	status = mwifiex_snmp_mib_ioctl(priv, wait, RTS_THRESH_I,
+					HostCmd_ACT_GEN_SET, &rts_thr);
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
 		ret = -EFAULT;
 		goto done;
 	}
 done:
 	LEAVE();
 
-	kfree(req);
+	kfree(wait);
 	return ret;
 }
 
@@ -599,38 +573,33 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 				     enum nl80211_iftype type, u32 *flags,
 				     struct vif_params *params)
 {
-	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	struct mwifiex_ds_bss *bss = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
 	int ret = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	int mode = -1;
+	struct mwifiex_wait_queue *wait = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	bss = (struct mwifiex_ds_bss *) req->buffer;
-	bss->sub_command = MWIFIEX_OID_BSS_MODE;
-	req->req_id = MWIFIEX_IOCTL_BSS;
-	req->action = MWIFIEX_ACT_SET;
-
-
 	switch (type) {
 	case NL80211_IFTYPE_ADHOC:
-		bss->param.bss_mode = MWIFIEX_BSS_MODE_IBSS;
+		mode = MWIFIEX_BSS_MODE_IBSS;
 		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_ADHOC;
 		PRINTM(MINFO, "Setting interface type to adhoc\n");
 		break;
 	case NL80211_IFTYPE_STATION:
-		bss->param.bss_mode = MWIFIEX_BSS_MODE_INFRA;
+		mode = MWIFIEX_BSS_MODE_INFRA;
 		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_STATION;
 		PRINTM(MINFO, "Setting interface type to managed\n");
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
-		bss->param.bss_mode = MWIFIEX_BSS_MODE_AUTO;
+		mode = MWIFIEX_BSS_MODE_AUTO;
 		dev->ieee80211_ptr->iftype = NL80211_IFTYPE_STATION;
 		PRINTM(MINFO, "Setting interface type to auto\n");
 		break;
@@ -639,15 +608,16 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 	}
 	if (ret)
 		goto done;
+	status = mwifiex_bss_ioctl_mode(priv, wait, HostCmd_ACT_GEN_SET, &mode);
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+	    mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
 		ret = -EFAULT;
 		goto done;
 	}
 
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -668,7 +638,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 			  struct station_info *sinfo)
 {
 	struct mwifiex_ds_get_signal signal;
-	struct mwifiex_ds_rate rate;
+	struct mwifiex_rate_cfg rate;
 	int ret = MWIFIEX_STATUS_SUCCESS;
 
 	sinfo->filled = STATION_INFO_RX_BYTES | STATION_INFO_TX_BYTES |
@@ -684,19 +654,17 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 		ret = -EFAULT;
 	}
 
-
 	if (MWIFIEX_STATUS_SUCCESS != mwifiex_drv_get_data_rate(priv, &rate)) {
 		PRINTM(MERROR, "Error getting data rate\n");
 		ret = -EFAULT;
 	}
 
-
 	sinfo->rx_bytes = priv->stats.rx_bytes;
 	sinfo->tx_bytes = priv->stats.tx_bytes;
 	sinfo->rx_packets = priv->stats.rx_packets;
 	sinfo->tx_packets = priv->stats.tx_packets;
 	sinfo->signal = priv->w_stats.qual.level;
-	sinfo->txrate.legacy = rate.param.rate_cfg.rate;
+	sinfo->txrate.legacy = rate.rate;
 
 	return ret;
 }
@@ -901,7 +869,7 @@ mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 
 	ENTER();
 
-	ret = mwifiex_get_bss_info(priv, MWIFIEX_IOCTL_WAIT, &bss_info);
+	ret = mwifiex_get_bss_info(priv, &bss_info);
 	if (ret) {
 		LEAVE();
 		return ret;
@@ -983,11 +951,8 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 				(priv->adapter->chan_offset));
 	}
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-			mwifiex_set_ewpa_mode(priv, &ssid_bssid)) {
-		ret = -EFAULT;
-		goto done;
-	}
+	/* reset eWPA mode */
+	priv->sec_info.ewpa_enabled = false;
 
 	if (!sme && (mode != MWIFIEX_BSS_MODE_IBSS)) {
 		BUG_ON(sme == NULL);
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index d503eb2..0cb47ac 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -37,11 +37,11 @@
 static void
 mwifiex_init_cmd_node(struct mwifiex_private *priv,
 		      struct cmd_ctrl_node *cmd_node,
-		      u32 cmd_oid, void *ioctl_buf, void *data_buf)
+		      u32 cmd_oid, void *wait_queue, void *data_buf)
 {
 	cmd_node->priv = priv;
 	cmd_node->cmd_oid = cmd_oid;
-	cmd_node->ioctl_buf = ioctl_buf;
+	cmd_node->wq_buf = wait_queue;
 	cmd_node->data_buf = data_buf;
 	cmd_node->cmd_skb = cmd_node->skb;
 }
@@ -90,7 +90,7 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 
 	cmd_node->cmd_oid = 0;
 	cmd_node->cmd_flag = 0;
-	cmd_node->ioctl_buf = NULL;
+	cmd_node->wq_buf = NULL;
 	cmd_node->data_buf = NULL;
 
 	if (cmd_node->resp_skb) {
@@ -109,7 +109,7 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
  */
 static struct cmd_ctrl_node *
 mwifiex_get_pending_ioctl_cmd(struct mwifiex_adapter *adapter,
-			      struct mwifiex_ioctl_req *ioctl_req)
+			      struct mwifiex_wait_queue *wait_queue)
 {
 	unsigned long flags;
 	struct cmd_ctrl_node *cmd_node;
@@ -118,7 +118,7 @@ mwifiex_get_pending_ioctl_cmd(struct mwifiex_adapter *adapter,
 
 	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
 	list_for_each_entry(cmd_node, &adapter->cmd_pending_q, list) {
-		if (cmd_node->ioctl_buf == ioctl_req) {
+		if (cmd_node->wq_buf == wait_queue) {
 			spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
 					       flags);
 			LEAVE();
@@ -132,31 +132,6 @@ mwifiex_get_pending_ioctl_cmd(struct mwifiex_adapter *adapter,
 }
 
 /*
- * This function handles the command response of a host command.
- */
-static enum mwifiex_status
-mwifiex_ret_host_cmd(struct mwifiex_private *priv,
-		     struct host_cmd_ds_command *resp,
-		     struct mwifiex_ioctl_req *ioctl_buf)
-{
-	struct mwifiex_ds_misc_cfg *misc;
-	uint16_t size = le16_to_cpu(resp->size);
-
-	ENTER();
-
-	PRINTM(MINFO, "host command response size = %d\n", size);
-	size = min_t(u16, size, MWIFIEX_SIZE_OF_CMD_BUFFER);
-	if (ioctl_buf) {
-		misc = (struct mwifiex_ds_misc_cfg *) ioctl_buf->buffer;
-		misc->param.hostcmd.len = size;
-		memcpy(misc->param.hostcmd.cmd, (void *) resp, size);
-	}
-
-	LEAVE();
-	return MWIFIEX_STATUS_SUCCESS;
-}
-
-/*
  * This function sends a host command to the firmware.
  *
  * The function copies the host command into the driver command
@@ -195,7 +170,7 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct host_cmd_ds_command *host_cmd;
-	struct mwifiex_ioctl_req *ioctl_buf = NULL;
+	struct mwifiex_wait_queue *wait_queue = NULL;
 	uint16_t cmd_code;
 	uint16_t cmd_size;
 	struct timeval tstamp;
@@ -209,18 +184,17 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	}
 
 	host_cmd = (struct host_cmd_ds_command *) (cmd_node->cmd_skb->data);
-	if (cmd_node->ioctl_buf != NULL)
-		ioctl_buf = (struct mwifiex_ioctl_req *) cmd_node->ioctl_buf;
+	if (cmd_node->wq_buf)
+		wait_queue = (struct mwifiex_wait_queue *) cmd_node->wq_buf;
 
 	/* Sanity test */
 	if (host_cmd == NULL || host_cmd->size == 0) {
 		PRINTM(MERROR,
 		       "DNLD_CMD: host_cmd is null or command size is zero, "
 		       "Not sending\n");
-		if (ioctl_buf != NULL)
-			ioctl_buf->status_code = MWIFIEX_ERROR_CMD_DNLD_FAIL,
-				mwifiex_insert_cmd_to_free_q(adapter,
-							     cmd_node);
+		if (wait_queue)
+			wait_queue->status = MWIFIEX_ERROR_CMD_DNLD_FAIL;
+		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
@@ -257,11 +231,9 @@ mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 
 	if (ret == MWIFIEX_STATUS_FAILURE) {
 		PRINTM(MERROR, "DNLD_CMD: Host to Card Failed\n");
-		if (ioctl_buf != NULL)
-			ioctl_buf->status_code = MWIFIEX_ERROR_CMD_DNLD_FAIL,
-				mwifiex_insert_cmd_to_free_q(adapter,
-							     adapter->
-							     curr_cmd);
+		if (wait_queue)
+			wait_queue->status = MWIFIEX_ERROR_CMD_DNLD_FAIL;
+		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
 
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->curr_cmd = NULL;
@@ -539,7 +511,7 @@ enum mwifiex_status
 mwifiex_prepare_cmd(struct mwifiex_private *priv,
 		    uint16_t cmd_no,
 		    u16 cmd_action,
-		    u32 cmd_oid, void *ioctl_buf, void *data_buf)
+		    u32 cmd_oid, void *wait_queue, void *data_buf)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -549,6 +521,12 @@ mwifiex_prepare_cmd(struct mwifiex_private *priv,
 	ENTER();
 
 	/* Sanity test */
+	if (adapter->is_suspended) {
+		PRINTM(MERROR, "PREP_CMD: Device in suspended state\n");
+		ret = MWIFIEX_STATUS_FAILURE;
+		goto done;
+	}
+
 	if (adapter == NULL) {
 		PRINTM(MERROR, "PREP_CMD: adapter is NULL\n");
 		ret = MWIFIEX_STATUS_FAILURE;
@@ -579,8 +557,7 @@ mwifiex_prepare_cmd(struct mwifiex_private *priv,
 	}
 
 	/* Initialize the command node */
-	mwifiex_init_cmd_node(priv, cmd_node, cmd_oid, ioctl_buf,
-			      data_buf);
+	mwifiex_init_cmd_node(priv, cmd_node, cmd_oid, wait_queue, data_buf);
 
 	if (!cmd_node->cmd_skb) {
 		PRINTM(MERROR, "PREP_CMD: No free cmd buf\n");
@@ -596,11 +573,10 @@ mwifiex_prepare_cmd(struct mwifiex_private *priv,
 	cmd_ptr->result = 0;
 
 	/* Prepare command */
-	if (cmd_no)
+	if (cmd_no) {
 		ret = mwifiex_sta_prepare_cmd(priv, cmd_no, cmd_action,
-					      cmd_oid, ioctl_buf, data_buf,
-					      cmd_ptr);
-	else {
+					      cmd_oid, data_buf, cmd_ptr);
+	} else {
 		ret = mwifiex_cmd_host_cmd(priv, cmd_ptr, data_buf);
 		cmd_node->cmd_flag |= CMD_F_HOSTCMD;
 	}
@@ -634,22 +610,20 @@ void
 mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 			     struct cmd_ctrl_node *cmd_node)
 {
-	struct mwifiex_ioctl_req *ioctl_req = NULL;
+	struct mwifiex_wait_queue *wait_queue = NULL;
 	unsigned long flags;
 
 	ENTER();
 
 	if (cmd_node == NULL)
 		goto done;
-	if (cmd_node->ioctl_buf) {
-		ioctl_req = (struct mwifiex_ioctl_req *) cmd_node->ioctl_buf;
-		if (ioctl_req->status_code != MWIFIEX_ERROR_NO_ERROR)
-			mwifiex_ioctl_complete(adapter,
-					       ioctl_req,
+	if (cmd_node->wq_buf) {
+		wait_queue = (struct mwifiex_wait_queue *) cmd_node->wq_buf;
+		if (wait_queue->status != MWIFIEX_ERROR_NO_ERROR)
+			mwifiex_ioctl_complete(adapter, wait_queue,
 					       MWIFIEX_STATUS_FAILURE);
 		else
-			mwifiex_ioctl_complete(adapter,
-					       ioctl_req,
+			mwifiex_ioctl_complete(adapter, wait_queue,
 					       MWIFIEX_STATUS_SUCCESS);
 	}
 	/* Clean the node */
@@ -689,7 +663,7 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
 
 	command = le16_to_cpu(host_cmd->command);
 
-/* Exit_PS command needs to be queued in the header always. */
+	/* Exit_PS command needs to be queued in the header always. */
 	if (command == HostCmd_CMD_802_11_PS_MODE_ENH) {
 		struct host_cmd_ds_802_11_ps_mode_enh *pm =
 			&host_cmd->params.psmode_enh;
@@ -814,7 +788,7 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	uint16_t orig_cmdresp_no;
 	uint16_t cmdresp_no;
 	uint16_t cmdresp_result;
-	struct mwifiex_ioctl_req *ioctl_buf = NULL;
+	struct mwifiex_wait_queue *wait_queue = NULL;
 	struct timeval tstamp;
 	unsigned long flags;
 
@@ -831,11 +805,9 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		goto done;
 	}
 
-	if (adapter->curr_cmd->ioctl_buf != NULL) {
-		ioctl_buf =
-			(struct mwifiex_ioctl_req *) adapter->curr_cmd->
-			ioctl_buf;
-	}
+	if (adapter->curr_cmd->wq_buf)
+		wait_queue = (struct mwifiex_wait_queue *)
+				adapter->curr_cmd->wq_buf;
 
 	adapter->num_cmd_timeout = 0;
 
@@ -858,7 +830,16 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	if (adapter->curr_cmd->cmd_flag & CMD_F_HOSTCMD) {
 		/* Copy original response back to response buffer */
-		mwifiex_ret_host_cmd(priv, resp, ioctl_buf);
+		struct mwifiex_ds_misc_cmd *hostcmd = NULL;
+		uint16_t size = le16_to_cpu(resp->size);
+		PRINTM(MINFO, "host command response size = %d\n", size);
+		size = min_t(u16, size, MWIFIEX_SIZE_OF_CMD_BUFFER);
+		if (adapter->curr_cmd->data_buf) {
+			hostcmd = (struct mwifiex_ds_misc_cmd *)
+						adapter->curr_cmd->data_buf;
+			hostcmd->len = size;
+			memcpy(hostcmd->cmd, (void *) resp, size);
+		}
 	}
 	orig_cmdresp_no = le16_to_cpu(resp->command);
 
@@ -888,8 +869,8 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	if (!(orig_cmdresp_no & HostCmd_RET_BIT)) {
 		PRINTM(MERROR, "CMD_RESP: Invalid response to command!\n");
-		if (ioctl_buf)
-			ioctl_buf->status_code = MWIFIEX_ERROR_FW_CMDRESP;
+		if (wait_queue)
+			wait_queue->status = MWIFIEX_ERROR_FW_CMDRESP;
 
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
@@ -903,12 +884,11 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		adapter->curr_cmd->cmd_flag &= ~CMD_F_HOSTCMD;
 		if ((cmdresp_result == HostCmd_RESULT_OK)
 		    && (cmdresp_no == HostCmd_CMD_802_11_HS_CFG_ENH))
-			ret = mwifiex_ret_802_11_hs_cfg(priv, resp,
-							ioctl_buf);
+			ret = mwifiex_ret_802_11_hs_cfg(priv, resp);
 	} else {
 		/* handle response */
 		ret = mwifiex_process_sta_cmdresp(priv, cmdresp_no, resp,
-						  ioctl_buf);
+						  wait_queue);
 	}
 
 	/* Check init command response */
@@ -923,13 +903,10 @@ mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	}
 
 	if (adapter->curr_cmd) {
-		ioctl_buf =
-			(struct mwifiex_ioctl_req *) adapter->curr_cmd->
-			ioctl_buf;
-		if (ioctl_buf && (ret == MWIFIEX_STATUS_SUCCESS))
-			ioctl_buf->status_code = MWIFIEX_ERROR_NO_ERROR;
-		else if (ioctl_buf && (ret == MWIFIEX_STATUS_FAILURE))
-			ioctl_buf->status_code = MWIFIEX_ERROR_CMD_RESP_FAIL;
+		if (wait_queue && (ret == MWIFIEX_STATUS_SUCCESS))
+			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
+		else if (wait_queue && (ret == MWIFIEX_STATUS_FAILURE))
+			wait_queue->status = MWIFIEX_ERROR_CMD_RESP_FAIL;
 
 		/* Clean up and put current command back to cmd_free_q */
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
@@ -955,7 +932,7 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	struct mwifiex_adapter *adapter =
 		(struct mwifiex_adapter *) function_context;
 	struct cmd_ctrl_node *cmd_node = NULL;
-	struct mwifiex_ioctl_req *ioctl_buf = NULL;
+	struct mwifiex_wait_queue *wait_queue = NULL;
 	struct timeval tstamp;
 	u8 i;
 
@@ -968,9 +945,9 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 		goto exit;
 	}
 	cmd_node = adapter->curr_cmd;
-	if (cmd_node->ioctl_buf != NULL) {
-		ioctl_buf = (struct mwifiex_ioctl_req *) cmd_node->ioctl_buf;
-		ioctl_buf->status_code = MWIFIEX_ERROR_CMD_TIMEOUT;
+	if (cmd_node->wq_buf) {
+		wait_queue = (struct mwifiex_wait_queue *) cmd_node->wq_buf;
+		wait_queue->status = MWIFIEX_ERROR_CMD_TIMEOUT;
 	}
 
 	if (cmd_node) {
@@ -1049,19 +1026,18 @@ void
 mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
-	struct mwifiex_ioctl_req *ioctl_buf = NULL;
+	struct mwifiex_wait_queue *wait_queue = NULL;
 	unsigned long flags;
 
 	/* Cancel current cmd */
-	if ((adapter->curr_cmd) && (adapter->curr_cmd->ioctl_buf)) {
-		ioctl_buf =
-			(struct mwifiex_ioctl_req *) adapter->curr_cmd->
-			ioctl_buf;
+	if ((adapter->curr_cmd) && (adapter->curr_cmd->wq_buf)) {
+		wait_queue =
+			(struct mwifiex_wait_queue *) adapter->curr_cmd->wq_buf;
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
-		adapter->curr_cmd->ioctl_buf = NULL;
+		adapter->curr_cmd->wq_buf = NULL;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-		ioctl_buf->status_code = MWIFIEX_ERROR_CMD_CANCEL;
-		mwifiex_ioctl_complete(adapter, ioctl_buf,
+		wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
+		mwifiex_ioctl_complete(adapter, wait_queue,
 				       MWIFIEX_STATUS_FAILURE);
 	}
 	/* Cancel all pending command */
@@ -1071,14 +1047,13 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 		list_del(&cmd_node->list);
 		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 
-		if (cmd_node->ioctl_buf) {
-			ioctl_buf =
-				(struct mwifiex_ioctl_req *) cmd_node->
-				ioctl_buf;
-			ioctl_buf->status_code = MWIFIEX_ERROR_CMD_CANCEL;
-			mwifiex_ioctl_complete(adapter, ioctl_buf,
+		if (cmd_node->wq_buf) {
+			wait_queue =
+				(struct mwifiex_wait_queue *) cmd_node->wq_buf;
+			wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
+			mwifiex_ioctl_complete(adapter, wait_queue,
 					       MWIFIEX_STATUS_FAILURE);
-			cmd_node->ioctl_buf = NULL;
+			cmd_node->wq_buf = NULL;
 		}
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
@@ -1092,7 +1067,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 		list_del(&cmd_node->list);
 		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
 
-		cmd_node->ioctl_buf = NULL;
+		cmd_node->wq_buf = NULL;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	}
@@ -1115,31 +1090,30 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
  */
 void
 mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
-			     struct mwifiex_ioctl_req *ioctl_req)
+			     struct mwifiex_wait_queue *wait_queue)
 {
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
 	unsigned long cmd_flags;
 	unsigned long cmd_pending_q_flags;
 	unsigned long scan_pending_q_flags;
+	uint16_t cancel_scan_cmd = false;
 
 	ENTER();
 
-	PRINTM(MCMND, "MWIFIEX Cancel IOCTL: 0x%x sub_id=0x%x action=%d\n",
-	       ioctl_req->req_id, *((u32 *) ioctl_req->buffer),
-	       (int) ioctl_req->action);
-
 	if ((adapter->curr_cmd) &&
-	    (adapter->curr_cmd->ioctl_buf == ioctl_req)) {
+	    (adapter->curr_cmd->wq_buf == wait_queue)) {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 		cmd_node = adapter->curr_cmd;
-		cmd_node->ioctl_buf = NULL;
+		cmd_node->wq_buf = NULL;
 		cmd_node->cmd_flag |= CMD_F_CANCELED;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	}
 
 	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
-	while ((cmd_node =
-		mwifiex_get_pending_ioctl_cmd(adapter, ioctl_req)) != NULL) {
+	while (1) {
+		cmd_node = mwifiex_get_pending_ioctl_cmd(adapter, wait_queue);
+		if (!cmd_node)
+			break;
 
 		spin_lock_irqsave(&adapter->cmd_pending_q_lock,
 				  cmd_pending_q_flags);
@@ -1147,33 +1121,38 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
 		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock,
 				       cmd_pending_q_flags);
 
-		cmd_node->ioctl_buf = NULL;
+		cmd_node->wq_buf = NULL;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 	}
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
-	if (ioctl_req->req_id == MWIFIEX_IOCTL_SCAN) {
-		/* Cancel all pending scan command */
-		spin_lock_irqsave(&adapter->scan_pending_q_lock,
-				  scan_pending_q_flags);
-		list_for_each_entry_safe(cmd_node, tmp_node,
-					 &adapter->scan_pending_q, list) {
+	/* Cancel all pending scan command */
+	spin_lock_irqsave(&adapter->scan_pending_q_lock,
+			  scan_pending_q_flags);
+	list_for_each_entry_safe(cmd_node, tmp_node,
+				 &adapter->scan_pending_q, list) {
+		if (cmd_node->wq_buf == wait_queue) {
 			list_del(&cmd_node->list);
-			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-					       scan_pending_q_flags);
-			cmd_node->ioctl_buf = NULL;
+			spin_unlock_irqrestore(
+					&adapter->scan_pending_q_lock,
+					scan_pending_q_flags);
+			cmd_node->wq_buf = NULL;
 			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-			spin_lock_irqsave(&adapter->scan_pending_q_lock,
-					  scan_pending_q_flags);
+			spin_lock_irqsave(
+					&adapter->scan_pending_q_lock,
+					scan_pending_q_flags);
+			cancel_scan_cmd = true;
 		}
-		spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-				       scan_pending_q_flags);
+	}
+	spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+			       scan_pending_q_flags);
 
+	if (cancel_scan_cmd) {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	}
-	ioctl_req->status_code = MWIFIEX_ERROR_CMD_CANCEL;
-	mwifiex_ioctl_complete(adapter, ioctl_req, MWIFIEX_STATUS_FAILURE);
+	wait_queue->status = MWIFIEX_ERROR_CMD_CANCEL;
+	mwifiex_ioctl_complete(adapter, wait_queue, MWIFIEX_STATUS_FAILURE);
 
 	LEAVE();
 	return;
@@ -1264,8 +1243,7 @@ mwifiex_host_sleep_wakeup_event(struct mwifiex_private *priv)
  */
 enum mwifiex_status
 mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
-			  struct host_cmd_ds_command *resp,
-			  struct mwifiex_ioctl_req *ioctl_buf)
+			  struct host_cmd_ds_command *resp)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_hs_cfg_enh *phs_cfg =
@@ -1486,7 +1464,7 @@ mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 enum mwifiex_status
 mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 			   struct host_cmd_ds_command *resp,
-			   struct mwifiex_ioctl_req *ioctl_buf)
+			   void *data_buf)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_ps_mode_enh *ps_mode =
@@ -1530,16 +1508,15 @@ mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 		else
 			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
 		PRINTM(MCMND, "ps_bitmap=0x%x\n", ps_bitmap);
-		if (ioctl_buf) {
+		if (data_buf) {
+			/* This section is for get power save mode */
 			struct mwifiex_ds_pm_cfg *pm_cfg = (struct
 							    mwifiex_ds_pm_cfg
-							    *)ioctl_buf->buffer;
-			if (pm_cfg->sub_command == MWIFIEX_OID_PM_CFG_IEEE_PS) {
-				if (ps_bitmap & BITMAP_STA_PS)
-					pm_cfg->param.ps_mode = 1;
-				else
-					pm_cfg->param.ps_mode = 0;
-			}
+							    *)data_buf;
+			if (ps_bitmap & BITMAP_STA_PS)
+				pm_cfg->param.ps_mode = 1;
+			else
+				pm_cfg->param.ps_mode = 0;
 		}
 	}
 	return MWIFIEX_STATUS_SUCCESS;
@@ -1593,7 +1570,7 @@ mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
  */
 enum mwifiex_status
 mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *resp, void *ioctl_buf)
+			struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_get_hw_spec *hw_spec = &resp->params.hw_spec;
 	struct mwifiex_adapter *adapter = priv->adapter;
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 597cb26..2cf287d 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -20,6 +20,7 @@
 #include <linux/debugfs.h>
 
 #include "main.h"
+#include "11n.h"
 
 
 static struct dentry *mwifiex_dfs_dir;
@@ -203,7 +204,7 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 	}
 
 	memset(&info, 0, sizeof(info));
-	ret = mwifiex_get_bss_info(priv, MWIFIEX_CMD_WAIT, &info);
+	ret = mwifiex_get_bss_info(priv, &info);
 	if (ret)
 		goto free_and_exit;
 
@@ -303,7 +304,7 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 		goto exit;
 	}
 
-	memset(&stats, 0, sizeof(struct mwifiex_ds_get_stats));
+	memset(&stats, 0, sizeof(stats));
 	ret = mwifiex_get_stats_info(priv, &stats);
 	if (ret)
 		goto free_and_exit;
@@ -339,7 +340,8 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 		     stats.tx_frame,
 		     stats.wep_icv_error[0],
 		     stats.wep_icv_error[1],
-		     stats.wep_icv_error[2], stats.wep_icv_error[3]);
+		     stats.wep_icv_error[2],
+		     stats.wep_icv_error[3]);
 
 
 	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
@@ -422,7 +424,7 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 		goto exit;
 	}
 
-	ret = mwifiex_get_debug_info(priv, MWIFIEX_CMD_WAIT, &info);
+	ret = mwifiex_get_debug_info(priv, &info);
 	if (ret)
 		goto free_and_exit;
 
@@ -783,8 +785,8 @@ mwifiex_hscfg_read(struct file *file, char __user *ubuf,
 	struct mwifiex_ds_hs_cfg hscfg;
 	ENTER();
 
-	mwifiex_set_get_hs_params(priv, MWIFIEX_ACT_GET, MWIFIEX_IOCTL_WAIT,
-									&hscfg);
+	mwifiex_set_get_hs_params(priv, HostCmd_ACT_GEN_GET,
+				  MWIFIEX_IOCTL_WAIT, &hscfg);
 
 	pos += snprintf(buf, PAGE_SIZE, "%d %d\n", hscfg.conditions, hscfg.gap);
 
@@ -1098,7 +1100,7 @@ mwifiex_qoscfg_write(struct file *file,
 
 	sscanf(buf, "%d", &qoscfg);
 
-	ret = mwifiex_set_qos_cfg(priv, qoscfg);
+	priv->wmm_qosinfo = qoscfg;
 
 	if (!ret)
 		ret = count;
@@ -1132,7 +1134,7 @@ mwifiex_qoscfg_read(struct file *file, char __user *ubuf,
 	if (!buf)
 		return -ENOMEM;
 
-	mwifiex_get_qos_cfg(priv, &qoscfg);
+	qoscfg = priv->wmm_qosinfo;
 
 	pos += snprintf(buf, PAGE_SIZE, "%d\n", qoscfg);
 
@@ -1175,10 +1177,9 @@ mwifiex_atimwindow_write(struct file *file,
 
 	sscanf(buf, "%d", &atim);
 
-	ret = mwifiex_set_atim_window(priv, atim);
+	mwifiex_set_atim_window(priv, atim);
 
-	if (!ret)
-		ret = count;
+	ret = count;
 
 done:
 	free_page(addr);
@@ -1507,7 +1508,7 @@ mwifiex_htcapinfo_write(struct file *file,
 
 	sscanf(buf, "%x", &htcap);
 
-	ret = mwifiex_set_11n_htcap_cfg(priv, htcap);
+	ret = mwifiex_set_get_11n_htcap_cfg(priv, HostCmd_ACT_GEN_SET, &htcap);
 
 	if (!ret)
 		ret = count;
@@ -1541,7 +1542,7 @@ mwifiex_htcapinfo_read(struct file *file, char __user *ubuf,
 	if (!buf)
 		return -ENOMEM;
 
-	mwifiex_get_11n_htcap_cfg(priv, &htcap);
+	mwifiex_set_get_11n_htcap_cfg(priv, HostCmd_ACT_GEN_GET, &htcap);
 
 	pos += snprintf(buf, PAGE_SIZE, "%x\n", htcap);
 
@@ -1603,7 +1604,7 @@ mwifiex_addbareject_write(struct file *file,
 		goto done;
 	}
 
-	ret = mwifiex_set_addba_reject(priv, data);
+	ret = mwifiex_set_get_addba_reject(priv, HostCmd_ACT_GEN_SET, data);
 
 	if (!ret)
 		ret = count;
@@ -1640,7 +1641,7 @@ mwifiex_addbareject_read(struct file *file, char __user *ubuf,
 		goto done;
 	}
 
-	mwifiex_get_addba_reject(priv, data);
+	mwifiex_set_get_addba_reject(priv, HostCmd_ACT_GEN_GET, data);
 
 	for (i = 0; i < 8; i++)
 		pos += snprintf(buf + strlen(buf), PAGE_SIZE, "%d ", data[i]);
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 0ffa0d9..347a39d 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -123,6 +123,7 @@ struct mwifiex_802_11_ssid {
 };
 
 struct mwifiex_wait_queue {
+	u32 bss_index;
 	wait_queue_head_t *wait;
 	u16 *condition;
 	u32 start_time;
@@ -130,18 +131,6 @@ struct mwifiex_wait_queue {
 	u32 enabled;
 };
 
-struct mwifiex_ioctl_req {
-	u32 status_code;
-	u32 bss_index;
-	u32 req_id;
-	u32 action;
-	u8 *buffer;
-	u32 buf_len;
-	u32 data_read_written;
-	u32 buf_len_needed;
-	struct mwifiex_wait_queue wq;
-};
-
 struct mwifiex_rxinfo {
 	u8 bss_index;
 	struct sk_buff *parent;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 0c325f5..6c82673 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -781,8 +781,8 @@ struct host_cmd_ds_mac_control {
 struct host_cmd_ds_mac_multicast_adr {
 	__le16 action;
 	__le16 num_of_adrs;
-	u8 mac_list[MWIFIEX_MAC_ADDR_LENGTH *
-		      MWIFIEX_MAX_MULTICAST_LIST_SIZE];
+	u8 mac_list[MWIFIEX_MAX_MULTICAST_LIST_SIZE]
+		[MWIFIEX_MAC_ADDR_LENGTH];
 } __packed;
 
 struct host_cmd_ds_802_11_deauthenticate {
@@ -849,7 +849,7 @@ struct host_cmd_ds_802_11_get_log {
 	__le32 mcast_tx_frame;
 	__le32 failed;
 	__le32 retry;
-	__le32 multiretry;
+	__le32 multi_retry;
 	__le32 frame_dup;
 	__le32 rts_success;
 	__le32 rts_failure;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 9a04f7e..3018963 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -380,7 +380,7 @@ mwifiex_free_adapter(struct mwifiex_adapter *adapter)
  *  This function intializes the lock variables and
  *  the list heads.
  */
-enum mwifiex_status wlan_init_lock_list(struct mwifiex_adapter *adapter)
+enum mwifiex_status mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 {
 	enum mwifiex_status     ret = MWIFIEX_STATUS_SUCCESS;
 	struct mwifiex_private   *priv = NULL;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index f71a09c..e79f8bc 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -22,102 +22,6 @@
 
 #include <net/mac80211.h>
 
-
-enum {
-	MWIFIEX_IOCTL_SCAN = 0x00010000,
-	MWIFIEX_OID_SCAN_NORMAL,
-	MWIFIEX_OID_SCAN_SPECIFIC_SSID,
-	MWIFIEX_OID_SCAN_USER_CONFIG,
-
-	MWIFIEX_IOCTL_BSS = 0x00020000,
-	MWIFIEX_OID_BSS_START,
-	MWIFIEX_OID_BSS_STOP,
-	MWIFIEX_OID_BSS_MODE,
-	MWIFIEX_OID_BSS_CHANNEL,
-	MWIFIEX_OID_BSS_CHANNEL_LIST,
-	MWIFIEX_OID_BSS_MAC_ADDR,
-	MWIFIEX_OID_BSS_MULTICAST_LIST,
-	MWIFIEX_OID_BSS_FIND_BSS,
-	MWIFIEX_OID_IBSS_ATIM_WINDOW,
-	MWIFIEX_OID_IBSS_CHANNEL,
-
-	MWIFIEX_IOCTL_RADIO_CFG = 0x00030000,
-	MWIFIEX_OID_BAND_CFG,
-	MWIFIEX_OID_ANT_CFG,
-
-	MWIFIEX_IOCTL_SNMP_MIB = 0x00040000,
-	MWIFIEX_OID_SNMP_MIB_RTS_THRESHOLD,
-	MWIFIEX_OID_SNMP_MIB_FRAG_THRESHOLD,
-	MWIFIEX_OID_SNMP_MIB_RETRY_COUNT,
-
-	MWIFIEX_IOCTL_GET_INFO = 0x00050000,
-	MWIFIEX_OID_GET_STATS,
-	MWIFIEX_OID_GET_SIGNAL,
-	MWIFIEX_OID_GET_FW_INFO,
-	MWIFIEX_OID_GET_VER_EXT,
-	MWIFIEX_OID_GET_BSS_INFO,
-	MWIFIEX_OID_GET_DEBUG_INFO,
-
-	MWIFIEX_IOCTL_SEC_CFG = 0x00060000,
-	MWIFIEX_OID_SEC_CFG_AUTH_MODE,
-	MWIFIEX_OID_SEC_CFG_ENCRYPT_MODE,
-	MWIFIEX_OID_SEC_CFG_WPA_ENABLED,
-	MWIFIEX_OID_SEC_CFG_ENCRYPT_KEY,
-	MWIFIEX_OID_SEC_CFG_PASSPHRASE,
-	MWIFIEX_OID_SEC_CFG_EWPA_ENABLED,
-	MWIFIEX_OID_SEC_CFG_ESUPP_MODE,
-	MWIFIEX_OID_SEC_CFG_WAPI_ENABLED,
-
-	MWIFIEX_IOCTL_RATE = 0x00070000,
-	MWIFIEX_OID_RATE_CFG,
-	MWIFIEX_OID_GET_DATA_RATE,
-	MWIFIEX_OID_SUPPORTED_RATES,
-
-	MWIFIEX_IOCTL_POWER_CFG = 0x00080000,
-	MWIFIEX_OID_POWER_CFG,
-
-	MWIFIEX_IOCTL_PM_CFG = 0x00090000,
-	MWIFIEX_OID_PM_CFG_IEEE_PS,
-	MWIFIEX_OID_PM_CFG_HS_CFG,
-	MWIFIEX_OID_PM_CFG_DEEP_SLEEP,
-	MWIFIEX_OID_PM_CFG_SLEEP_PD,
-
-	MWIFIEX_IOCTL_WMM_CFG = 0x000A0000,
-	MWIFIEX_OID_WMM_CFG_QOS,
-	MWIFIEX_OID_WMM_CFG_QUEUE_STATUS,
-
-	MWIFIEX_IOCTL_11N_CFG = 0x000C0000,
-	MWIFIEX_OID_11N_CFG_TX,
-	MWIFIEX_OID_11N_HTCAP_CFG,
-	MWIFIEX_OID_11N_CFG_ADDBA_REJECT,
-	MWIFIEX_OID_11N_CFG_AGGR_PRIO_TBL,
-	MWIFIEX_OID_11N_CFG_ADDBA_PARAM,
-	MWIFIEX_OID_11N_CFG_MAX_TX_BUF_SIZE,
-	MWIFIEX_OID_11N_CFG_AMSDU_AGGR_CTRL,
-
-	MWIFIEX_IOCTL_REG_MEM = 0x000E0000,
-	MWIFIEX_OID_REG_RW,
-	MWIFIEX_OID_EEPROM_RD,
-
-	MWIFIEX_IOCTL_MISC_CFG = 0x00200000,
-	MWIFIEX_OID_MISC_GEN_IE,
-	MWIFIEX_OID_MISC_HOST_CMD,
-	MWIFIEX_OID_MISC_INIT_SHUTDOWN,
-};
-
-#define MWIFIEX_SUB_COMMAND_SIZE	4
-
-enum {
-	MWIFIEX_ACT_SET = 1,
-	MWIFIEX_ACT_GET,
-	MWIFIEX_ACT_CANCEL
-};
-
-enum {
-	MWIFIEX_ACT_DISABLE = 0,
-	MWIFIEX_ACT_ENABLE = 1
-};
-
 enum {
 	MWIFIEX_SCAN_MODE_UNCHANGED = 0,
 	MWIFIEX_SCAN_MODE_BSS,
@@ -162,15 +66,6 @@ struct mwifiex_scan_resp {
 	u8 *scan_table;
 };
 
-struct mwifiex_ds_scan {
-	u32 sub_command;
-	union {
-		struct mwifiex_scan_req scan_req;
-		struct mwifiex_scan_resp scan_resp;
-		struct mwifiex_user_scan user_scan;
-	} param;
-};
-
 enum {
 	MWIFIEX_BSS_MODE_INFRA = 1,
 	MWIFIEX_BSS_MODE_IBSS,
@@ -205,20 +100,6 @@ struct mwifiex_ssid_bssid {
 	u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
 };
 
-struct mwifiex_ds_bss {
-	u32 sub_command;
-	union {
-		struct mwifiex_ssid_bssid ssid_bssid;
-		u8 bssid[MWIFIEX_MAC_ADDR_LENGTH];
-		u32 bss_mode;
-		struct mwifiex_chan_freq bss_chan;
-		struct mwifiex_chan_list chan_list;
-		u8 mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
-		struct mwifiex_multicast_list multicast_list;
-		u32 atim_window;
-	} param;
-};
-
 enum {
 	BAND_B = 1,
 	BAND_G = 2,
@@ -238,23 +119,6 @@ struct mwifiex_ds_band_cfg {
 	u32 sec_chan_offset;
 };
 
-struct mwifiex_ds_radio_cfg {
-	u32 sub_command;
-	union {
-		struct mwifiex_ds_band_cfg band_cfg;
-		u32 antenna;
-	} param;
-};
-
-struct mwifiex_ds_snmp_mib {
-	__le32 sub_command;
-	union {
-		__le32 rts_threshold;
-		__le32 frag_threshold;
-		__le32 retry_count;
-	} param;
-};
-
 enum {
 	ADHOC_IDLE,
 	ADHOC_STARTED,
@@ -278,7 +142,6 @@ struct mwifiex_ds_get_stats {
 	u32 wep_icv_error[4];
 };
 
-
 #define BCN_RSSI_LAST_MASK              0x00000001
 #define BCN_RSSI_AVG_MASK               0x00000002
 #define DATA_RSSI_LAST_MASK             0x00000004
@@ -329,7 +192,6 @@ struct mwifiex_ver_ext {
 	char version_str[MWIFIEX_MAX_VER_STR_LEN];
 };
 
-
 struct mwifiex_bss_info {
 	u32 bss_mode;
 	struct mwifiex_802_11_ssid ssid;
@@ -412,18 +274,6 @@ struct mwifiex_debug_info {
 	u8 event_received;
 };
 
-struct mwifiex_ds_get_info {
-	u32 sub_command;
-	union {
-		struct mwifiex_ds_get_signal signal;
-		struct mwifiex_ds_get_stats stats;
-		struct mwifiex_fw_info fw_info;
-		struct mwifiex_ver_ext ver_ext;
-		struct mwifiex_bss_info bss_info;
-		struct mwifiex_debug_info debug_info;
-	} param;
-};
-
 enum {
 	MWIFIEX_AUTH_MODE_OPEN = 0x00,
 	MWIFIEX_AUTH_MODE_SHARED = 0x01,
@@ -489,27 +339,13 @@ struct mwifiex_ds_esupp_mode {
 	u32 act_groupcipher;
 };
 
-struct mwifiex_ds_sec_cfg {
-	u32 sub_command;
-	union {
-		u32 auth_mode;
-		u32 encrypt_mode;
-		u32 wpa_enabled;
-		u32 wapi_enabled;
-		struct mwifiex_ds_encrypt_key encrypt_key;
-		struct mwifiex_ds_passphrase passphrase;
-		u32 ewpa_enabled;
-		struct mwifiex_ds_esupp_mode esupp_mode;
-	} param;
-};
-
-
 enum {
 	MWIFIEX_RATE_INDEX,
 	MWIFIEX_RATE_VALUE
 };
 
 struct mwifiex_rate_cfg {
+	u32 action;
 	u32 is_rate_auto;
 	u32 rate_type;
 	u32 rate;
@@ -520,27 +356,11 @@ struct mwifiex_data_rate {
 	u32 rx_data_rate;
 };
 
-struct mwifiex_ds_rate {
-	u32 sub_command;
-	union {
-		struct mwifiex_rate_cfg rate_cfg;
-		struct mwifiex_data_rate data_rate;
-		u8 rates[IW_MAX_BITRATES];
-	} param;
-};
-
 struct mwifiex_power_cfg {
 	u32 is_power_auto;
 	u32 power_level;
 };
 
-struct mwifiex_ds_power_cfg {
-	u32 sub_command;
-	union {
-		struct mwifiex_power_cfg power_cfg;
-	} param;
-};
-
 struct mwifiex_ds_hs_cfg {
 	u32 is_invoke_hostcmd;
 	/** Bit0: non-unicast data
@@ -573,7 +393,6 @@ struct mwifiex_ds_auto_ds {
 
 
 struct mwifiex_ds_pm_cfg {
-	u32 sub_command;
 	union {
 		u32 ps_mode;
 		struct mwifiex_ds_hs_cfg hs_cfg;
@@ -594,15 +413,6 @@ struct mwifiex_ds_wmm_queue_status {
 		ac_status[IEEE80211_MAX_QUEUES];
 };
 
-
-struct mwifiex_ds_wmm_cfg {
-	u32 sub_command;
-	union {
-		u8 qos_cfg;
-		struct mwifiex_ds_wmm_queue_status q_status;
-	} param;
-};
-
 struct mwifiex_ds_11n_addba_param {
 	u32 timeout;
 	u32 tx_win_size;
@@ -624,20 +434,6 @@ struct mwifiex_ds_11n_aggr_prio_tbl {
 	u8 amsdu[MAX_NUM_TID];
 };
 
-struct mwifiex_ds_11n_cfg {
-	u32 sub_command;
-	union {
-		struct mwifiex_ds_11n_tx_cfg tx_cfg;
-		struct mwifiex_ds_11n_aggr_prio_tbl aggr_prio_tbl;
-		struct mwifiex_ds_11n_addba_param addba_param;
-		u8 addba_reject[MAX_NUM_TID];
-		u32 tx_buf_size;
-		u32 htcap_cfg;
-		struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
-	} param;
-};
-
-
 #define MWIFIEX_NUM_OF_CMD_BUFFER	20
 #define MWIFIEX_SIZE_OF_CMD_BUFFER	2048
 
@@ -668,15 +464,6 @@ struct mwifiex_ds_read_eeprom {
 	u8 value[MAX_EEPROM_DATA];
 };
 
-struct mwifiex_ds_reg_mem {
-	u32 sub_command;
-	union {
-		struct mwifiex_ds_reg_rw reg_rw;
-		struct mwifiex_ds_read_eeprom rd_eeprom;
-	} param;
-};
-
-
 struct mwifiex_ds_misc_gen_ie {
 	u32 type;
 	u32 len;
@@ -699,14 +486,4 @@ enum {
 	MWIFIEX_FUNC_SHUTDOWN,
 };
 
-struct mwifiex_ds_misc_cfg {
-	u32 sub_command;
-	union {
-		struct mwifiex_ds_misc_gen_ie gen_ie;
-		struct mwifiex_ds_misc_cmd hostcmd;
-		u16 ldo_cfg;
-		u32 func_init_shutdown;
-	} param;
-};
-
 #endif /* !_MWIFIEX_IOCTL_H_ */
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 873e9ff..ef9e46b 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -684,11 +684,11 @@ done:
  */
 enum mwifiex_status
 mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
-			     struct host_cmd_ds_command *resp, void *ioctl_buf)
+			     struct host_cmd_ds_command *resp, void *wq_buf)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ioctl_req *ioctl_req =
-		(struct mwifiex_ioctl_req *) ioctl_buf;
+	struct mwifiex_wait_queue *wait_queue =
+		(struct mwifiex_wait_queue *) wq_buf;
 	struct ieee_types_assoc_rsp *assoc_rsp;
 	struct mwifiex_bssdescriptor *bss_desc;
 	u8 enable_data = true;
@@ -818,16 +818,16 @@ mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 
 done:
 	/* Need to indicate IOCTL complete */
-	if (ioctl_req != NULL) {
+	if (wait_queue) {
 		if (ret != MWIFIEX_STATUS_SUCCESS) {
 			if (assoc_rsp->status_code)
-				ioctl_req->status_code =
+				wait_queue->status =
 					le16_to_cpu(assoc_rsp->status_code);
 			else
-				ioctl_req->status_code =
+				wait_queue->status =
 					MWIFIEX_ERROR_ASSOC_FAIL;
 		} else {
-			ioctl_req->status_code = MWIFIEX_ERROR_NO_ERROR;
+			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
 		}
 	}
 
@@ -1467,11 +1467,11 @@ done:
  */
 enum mwifiex_status
 mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
-			  struct host_cmd_ds_command *resp, void *ioctl_buf)
+			  struct host_cmd_ds_command *resp, void *wq_buf)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ioctl_req *ioctl_req =
-		(struct mwifiex_ioctl_req *) ioctl_buf;
+	struct mwifiex_wait_queue *wait_queue =
+		(struct mwifiex_wait_queue *) wq_buf;
 	struct host_cmd_ds_802_11_ad_hoc_result *adhoc_result;
 	struct mwifiex_bssdescriptor *bss_desc;
 	u16 command = le16_to_cpu(resp->command);
@@ -1545,11 +1545,11 @@ mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 
 done:
 	/* Need to indicate IOCTL complete */
-	if (ioctl_req != NULL) {
+	if (wait_queue) {
 		if (ret != MWIFIEX_STATUS_SUCCESS)
-			ioctl_req->status_code = MWIFIEX_ERROR_ASSOC_FAIL;
+			wait_queue->status = MWIFIEX_ERROR_ASSOC_FAIL;
 		else
-			ioctl_req->status_code = MWIFIEX_ERROR_NO_ERROR;
+			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
 
 	}
 
@@ -1566,7 +1566,7 @@ done:
  */
 enum mwifiex_status
 mwifiex_associate(struct mwifiex_private *priv,
-		  void *ioctl_buf, struct mwifiex_bssdescriptor *bss_desc)
+		  void *wait_queue, struct mwifiex_bssdescriptor *bss_desc)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	u8 current_bssid[MWIFIEX_MAC_ADDR_LENGTH];
@@ -1590,7 +1590,7 @@ mwifiex_associate(struct mwifiex_private *priv,
 
 	ret = mwifiex_prepare_cmd(priv,
 				  HostCmd_CMD_802_11_ASSOCIATE,
-				  HostCmd_ACT_GEN_SET, 0, ioctl_buf,
+				  HostCmd_ACT_GEN_SET, 0, wait_queue,
 				  bss_desc);
 
 	LEAVE();
@@ -1604,7 +1604,7 @@ mwifiex_associate(struct mwifiex_private *priv,
  */
 enum mwifiex_status
 mwifiex_adhoc_start(struct mwifiex_private *priv,
-		    void *ioctl_buf, struct mwifiex_802_11_ssid *adhoc_ssid)
+		    void *wait_queue, struct mwifiex_802_11_ssid *adhoc_ssid)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 
@@ -1618,7 +1618,7 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
 
 	ret = mwifiex_prepare_cmd(priv,
 				  HostCmd_CMD_802_11_AD_HOC_START,
-				  HostCmd_ACT_GEN_SET, 0, ioctl_buf,
+				  HostCmd_ACT_GEN_SET, 0, wait_queue,
 				  adhoc_ssid);
 
 	LEAVE();
@@ -1633,7 +1633,7 @@ mwifiex_adhoc_start(struct mwifiex_private *priv,
  */
 enum mwifiex_status
 mwifiex_adhoc_join(struct mwifiex_private *priv,
-		   void *ioctl_buf, struct mwifiex_bssdescriptor *bss_desc)
+		   void *wait_queue, struct mwifiex_bssdescriptor *bss_desc)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 
@@ -1669,7 +1669,7 @@ mwifiex_adhoc_join(struct mwifiex_private *priv,
 
 	ret = mwifiex_prepare_cmd(priv,
 				  HostCmd_CMD_802_11_AD_HOC_JOIN,
-				  HostCmd_ACT_GEN_SET, 0, ioctl_buf,
+				  HostCmd_ACT_GEN_SET, 0, wait_queue,
 				  bss_desc);
 
 	LEAVE();
@@ -1684,7 +1684,7 @@ mwifiex_adhoc_join(struct mwifiex_private *priv,
  */
 enum mwifiex_status
 mwifiex_deauthenticate(struct mwifiex_private *priv,
-		       struct mwifiex_ioctl_req *ioctl_req, u8 *mac)
+		       struct mwifiex_wait_queue *wait, u8 *mac)
 {
 	u8 mac_address[MWIFIEX_MAC_ADDR_LENGTH];
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
@@ -1716,19 +1716,17 @@ mwifiex_deauthenticate(struct mwifiex_private *priv,
 			ret = mwifiex_prepare_cmd(priv,
 					HostCmd_CMD_802_11_DEAUTHENTICATE,
 					HostCmd_ACT_GEN_SET,
-					0, (void *) ioctl_req,
-					&mac_address);
+					0, wait, &mac_address);
 
-			if (ret == MWIFIEX_STATUS_SUCCESS && ioctl_req)
+			if (ret == MWIFIEX_STATUS_SUCCESS && wait)
 				ret = MWIFIEX_STATUS_PENDING;
 
 		} else if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS) {
 			ret = mwifiex_prepare_cmd(priv,
 					HostCmd_CMD_802_11_AD_HOC_STOP,
-					HostCmd_ACT_GEN_SET,
-					0, (void *) ioctl_req, NULL);
+					HostCmd_ACT_GEN_SET, 0, wait, NULL);
 
-			if (ret == MWIFIEX_STATUS_SUCCESS && ioctl_req)
+			if (ret == MWIFIEX_STATUS_SUCCESS && wait)
 				ret = MWIFIEX_STATUS_PENDING;
 		}
 	}
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 9f56ded..3578206 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -20,6 +20,7 @@
 #include "main.h"
 #include "wmm.h"
 #include "cfg80211.h"
+#include "11n.h"
 
 #define VERSION	"1.0"
 
@@ -143,7 +144,7 @@ mwifiex_register(void *card,
 	}
 
 	/* Initialize lock variables */
-	if (wlan_init_lock_list(adapter) != MWIFIEX_STATUS_SUCCESS) {
+	if (mwifiex_init_lock_list(adapter) != MWIFIEX_STATUS_SUCCESS) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto error;
 	}
@@ -906,31 +907,25 @@ error:
 enum mwifiex_status
 mwifiex_shutdown_fw(struct mwifiex_private *priv, u8 wait_option)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_misc_cfg *misc = NULL;
-	enum mwifiex_status status;
+	struct mwifiex_wait_queue *wait = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 
 	ENTER();
 
 	/* Allocate an IOCTL request buffer */
-	req = (struct mwifiex_ioctl_req *)
-		mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_misc_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		status = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
-	/* Fill request buffer */
-	misc = (struct mwifiex_ds_misc_cfg *) req->buffer;
-	misc->sub_command = MWIFIEX_OID_MISC_INIT_SHUTDOWN;
-	misc->param.func_init_shutdown = MWIFIEX_FUNC_SHUTDOWN;
-	req->req_id = MWIFIEX_IOCTL_MISC_CFG;
-	req->action = MWIFIEX_ACT_SET;
+	status = mwifiex_misc_ioctl_init_shutdown(priv->adapter, wait,
+						  MWIFIEX_FUNC_SHUTDOWN);
 
-	status = mwifiex_request_ioctl(priv, req, wait_option);
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return status;
 }
@@ -1098,33 +1093,6 @@ mwifiex_bss_index_to_priv(struct mwifiex_adapter *adapter, u8 bss_index)
 }
 
 /*
- * This function allocates an IOCTL request buffer to be sent to the
- * firmware.
- */
-struct mwifiex_ioctl_req *
-mwifiex_alloc_ioctl_req(u32 size)
-{
-	struct mwifiex_ioctl_req *req = NULL;
-
-	ENTER();
-
-	req = (struct mwifiex_ioctl_req *)
-		kzalloc(sizeof(struct mwifiex_ioctl_req) + size, GFP_ATOMIC);
-	if (!req) {
-		PRINTM(MERROR, "%s: fail to allocate ioctl buffer\n", __func__);
-		LEAVE();
-		return NULL;
-	}
-
-	req->buffer = (u8 *) req + sizeof(struct mwifiex_ioctl_req);
-	req->buf_len = size;
-
-	LEAVE();
-	return req;
-}
-EXPORT_SYMBOL_GPL(mwifiex_alloc_ioctl_req);
-
-/*
  * This is the main work queue function.
  *
  * It handles the main process, which in turn handles the complete
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index c6cdc8e..ae75e8d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -486,7 +486,7 @@ struct cmd_ctrl_node {
 	struct sk_buff *cmd_skb;
 	struct sk_buff *resp_skb;
 	void *data_buf;
-	void *ioctl_buf;
+	void *wq_buf;
 	struct sk_buff *skb;
 };
 
@@ -627,7 +627,7 @@ struct mwifiex_adapter {
 	u32 arp_filter_size;
 };
 
-enum mwifiex_status wlan_init_lock_list(struct mwifiex_adapter *adapter);
+enum mwifiex_status mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
 void mwifiex_free_lock_list(struct mwifiex_adapter *adapter);
 
 enum mwifiex_status mwifiex_init_fw(struct mwifiex_adapter *adapter);
@@ -655,37 +655,33 @@ void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv);
 enum mwifiex_status mwifiex_process_event(struct mwifiex_adapter *adapter);
 
 enum mwifiex_status mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
-				   struct mwifiex_ioctl_req *ioctl_req,
+				   struct mwifiex_wait_queue *ioctl_wq,
 				   enum mwifiex_status status);
 
 enum mwifiex_status mwifiex_prepare_cmd(struct mwifiex_private *priv,
 					uint16_t cmd_no,
 					u16 cmd_action,
 					u32 cmd_oid,
-					void *ioctl_buf, void *data_buf);
+					void *wait_queue, void *data_buf);
 
 void mwifiex_cmd_timeout_func(unsigned long function_context);
 
-enum mwifiex_status mwifiex_misc_ioctl_host_cmd(struct mwifiex_adapter
-						*adapter,
-						struct mwifiex_ioctl_req
-						*ioctl_req);
 enum mwifiex_status mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter
 						     *adapter,
-						     struct mwifiex_ioctl_req
-						     *ioctl_req);
-enum mwifiex_status mwifiex_get_info_debug_info(struct mwifiex_adapter
-						*adapter,
-						struct mwifiex_ioctl_req
-						*ioctl_req);
-
-enum mwifiex_status wlan_set_ewpa_mode(struct mwifiex_private *priv,
-				       struct mwifiex_ds_passphrase *psec_pp);
+						     struct mwifiex_wait_queue
+						     *wait_queue,
+						     u32 func_init_shutdown);
+enum mwifiex_status mwifiex_get_debug_info(struct mwifiex_private *,
+					   struct mwifiex_debug_info *);
+
+enum mwifiex_status mwifiex_set_ewpa_mode_from_passphrase(
+					struct mwifiex_private *priv,
+					struct mwifiex_ds_passphrase *);
 enum mwifiex_status mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter);
 enum mwifiex_status mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
-				  struct mwifiex_ioctl_req *ioctl_req);
+				  struct mwifiex_wait_queue *ioctl_wq);
 
 void mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 				  struct cmd_ctrl_node *cmd_node);
@@ -722,25 +718,19 @@ enum mwifiex_status mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 					       void *data_buf);
 enum mwifiex_status mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 					       struct host_cmd_ds_command *resp,
-					       struct mwifiex_ioctl_req
-					       *ioctl_buf);
+					       void *data_buf);
 void mwifiex_process_hs_config(struct mwifiex_adapter *adapter);
 void mwifiex_hs_activated_event(struct mwifiex_private *priv,
 					u8 activated);
 enum mwifiex_status mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
-					      struct host_cmd_ds_command *resp,
-					      struct mwifiex_ioctl_req
-					      *ioctl_buf);
+					      struct host_cmd_ds_command *resp);
 void mwifiex_host_sleep_wakeup_event(struct mwifiex_private *priv);
 enum mwifiex_status mwifiex_process_rx_packet(struct mwifiex_adapter *adapter,
 					      struct sk_buff *skb);
-enum mwifiex_status mwifiex_sta_ioctl(struct mwifiex_adapter *,
-				      struct mwifiex_ioctl_req *ioctl_req);
 enum mwifiex_status mwifiex_sta_prepare_cmd(struct mwifiex_private *,
-						uint16_t cmd_no,
+					    uint16_t cmd_no,
 					    u16 cmd_action, u32 cmd_oid,
-					    void *ioctl_buf, void *data_buf,
-					    void *cmd_buf);
+					    void *data_buf, void *cmd_buf);
 enum mwifiex_status mwifiex_process_sta_cmdresp(struct mwifiex_private *,
 						u16 cmdresp_no,
 						void *cmd_buf, void *ioctl);
@@ -751,13 +741,14 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
 enum mwifiex_status mwifiex_sta_init_cmd(struct mwifiex_private *,
 						u8 first_sta);
 enum mwifiex_status mwifiex_scan_networks(struct mwifiex_private *priv,
-					  void *ioctl_buf,
+					  void *wait_queue, u16 action,
 					  const struct mwifiex_user_scan_cfg
-					  *user_scan_in);
+					  *user_scan_in,
+					  struct mwifiex_scan_resp *);
 enum mwifiex_status mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
-					       void *ioctl_buf,
-					       struct mwifiex_802_11_ssid
-					       *req_ssid);
+					void *wait, u16 action,
+					struct mwifiex_802_11_ssid *ssid,
+					struct mwifiex_scan_resp *scan_resp);
 enum mwifiex_status mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
 					    struct host_cmd_ds_command *cmd,
 					    void *data_buf);
@@ -765,7 +756,7 @@ void mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 			    struct cmd_ctrl_node *cmd_node);
 enum mwifiex_status mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					    struct host_cmd_ds_command *resp,
-					    void *ioctl_buf);
+					    void *wait_queue);
 s32 mwifiex_find_ssid_in_list(struct mwifiex_private *priv,
 				struct mwifiex_802_11_ssid *ssid, u8 *bssid,
 				u32 mode);
@@ -777,29 +768,28 @@ enum mwifiex_status mwifiex_find_best_network(struct mwifiex_private *priv,
 s32 mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
 		       struct mwifiex_802_11_ssid *ssid2);
 enum mwifiex_status mwifiex_associate(struct mwifiex_private *priv,
-				      void *ioctl_buf,
+				      void *wait_queue,
 				      struct mwifiex_bssdescriptor *bss_desc);
 enum mwifiex_status mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 						 struct host_cmd_ds_command
 						 *cmd, void *data_buf);
 enum mwifiex_status mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 						 struct host_cmd_ds_command
-						 *resp, void *ioctl_buf);
+						 *resp, void *wait_queue);
 void mwifiex_reset_connect_state(struct mwifiex_private *priv);
 void mwifiex_2040_coex_event(struct mwifiex_private *priv);
 u8 mwifiex_band_to_radio_type(u8 band);
 enum mwifiex_status mwifiex_deauthenticate(struct mwifiex_private *priv,
-					   struct mwifiex_ioctl_req *ioctl_req,
+					   struct mwifiex_wait_queue
+					   *wait_queue,
 					   u8 *mac);
 enum mwifiex_status mwifiex_adhoc_start(struct mwifiex_private *priv,
-					void *ioctl_buf,
+					void *wait_queue,
 					struct mwifiex_802_11_ssid
 					*adhoc_ssid);
 enum mwifiex_status mwifiex_adhoc_join(struct mwifiex_private *priv,
-				       void *ioctl_buf,
+				       void *wait_queue,
 				       struct mwifiex_bssdescriptor *bss_desc);
-enum mwifiex_status mwifiex_find_bss(struct mwifiex_private *priv,
-					struct mwifiex_ioctl_req *ioctl_req);
 enum mwifiex_status mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private
 						    *priv,
 						    struct host_cmd_ds_command
@@ -810,7 +800,7 @@ enum mwifiex_status mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private
 						   *cmd, void *data_buf);
 enum mwifiex_status mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 					      struct host_cmd_ds_command *resp,
-					      void *ioctl_buf);
+					      void *wait_queue);
 enum mwifiex_status mwifiex_cmd_802_11_bg_scan_query(struct mwifiex_private
 						     *priv,
 						     struct host_cmd_ds_command
@@ -852,8 +842,7 @@ void mwifiex_free_curr_bcn(struct mwifiex_private *priv);
 enum mwifiex_status mwifiex_cmd_get_hw_spec(struct mwifiex_private *priv,
 					struct host_cmd_ds_command *cmd);
 enum mwifiex_status mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
-					    struct host_cmd_ds_command *resp,
-					    void *ioctl_buf);
+					    struct host_cmd_ds_command *resp);
 int is_command_pending(struct mwifiex_adapter *adapter);
 
 /*
@@ -940,7 +929,9 @@ mwifiex_netdev_get_priv(struct net_device *dev)
 	return (struct mwifiex_private *) (*(unsigned long *) netdev_priv(dev));
 }
 
-struct mwifiex_ioctl_req *mwifiex_alloc_ioctl_req(u32 size);
+struct mwifiex_wait_queue *mwifiex_alloc_fill_wait_queue(
+				struct mwifiex_private *,
+				u8 wait_option);
 struct mwifiex_private *mwifiex_bss_index_to_priv(struct mwifiex_adapter
 						*adapter, u8 bss_index);
 enum mwifiex_status mwifiex_shutdown_fw(struct mwifiex_private *, u8);
@@ -961,19 +952,14 @@ enum mwifiex_status mwifiex_request_set_mac_address(struct mwifiex_private
 void mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 					struct net_device *dev);
 enum mwifiex_status mwifiex_request_ioctl(struct mwifiex_private *priv,
-					  struct mwifiex_ioctl_req *req,
-					  u8 wait_option);
-enum mwifiex_status mwifiex_get_debug_info(struct mwifiex_private *priv,
-					   u8 wait_option,
-					   struct mwifiex_debug_info
-					   *debug_info);
+					  struct mwifiex_wait_queue *req,
+					  enum mwifiex_status, u8 wait_option);
 enum mwifiex_status mwifiex_disconnect(struct mwifiex_private *, u8, u8 *);
 enum mwifiex_status mwifiex_bss_start(struct mwifiex_private *priv,
 				      u8 wait_option,
 				      struct mwifiex_ssid_bssid *ssid_bssid);
 enum mwifiex_status mwifiex_set_get_hs_params(struct mwifiex_private *priv,
-					      u16 action,
-					      u8 wait_option,
+					      u16 action, u8 wait_option,
 					      struct mwifiex_ds_hs_cfg *hscfg);
 enum mwifiex_status mwifiex_cancel_hs(struct mwifiex_private *priv,
 				      u8 wait_option);
@@ -981,27 +967,21 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter);
 int mwifiex_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
 			   bool bdeep_sleep, u16 idletime);
 void mwifiex_process_ioctl_resp(struct mwifiex_private *priv,
-				struct mwifiex_ioctl_req *req);
-void mwifiex_request_get_fw_info(struct mwifiex_private *priv);
+				struct mwifiex_wait_queue *req);
 u32 mwifiex_get_mode(struct mwifiex_private *priv, u8 wait_option);
 enum mwifiex_status mwifiex_get_signal_info(struct mwifiex_private *priv,
 					    u8 wait_option,
 					    struct mwifiex_ds_get_signal
 					    *signal);
 enum mwifiex_status mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
-					      struct mwifiex_ds_rate *datarate);
+					      struct mwifiex_rate_cfg *rate);
 enum mwifiex_status mwifiex_get_channel_list(struct mwifiex_private *priv,
 					     u8 wait_option,
 					     struct mwifiex_chan_list
 					     *chanlist);
-enum mwifiex_status mwifiex_get_bss_info(struct mwifiex_private *priv,
-					 u8 wait_option,
-					 struct mwifiex_bss_info *bss_info);
 enum mwifiex_status mwifiex_get_scan_table(struct mwifiex_private *priv,
 					   u8 wait_option,
 					   struct mwifiex_scan_resp *scanresp);
-enum mwifiex_status mwifiex_set_auth_mode(struct mwifiex_private *priv,
-					  u8 wait_option, u32 auth_mode);
 enum mwifiex_status mwifiex_get_auth_mode(struct mwifiex_private *priv,
 					  u8 wait_option, u32 *auth_mode);
 enum mwifiex_status mwifiex_set_encrypt_mode(struct mwifiex_private *priv,
@@ -1012,10 +992,6 @@ enum mwifiex_status mwifiex_get_encrypt_mode(struct mwifiex_private *priv,
 					     u32 *encrypt_mode);
 enum mwifiex_status mwifiex_enable_wep_key(struct mwifiex_private *priv,
 					   u8 wait_option);
-enum mwifiex_status mwifiex_set_wpa_enable(struct mwifiex_private *priv,
-					   u8 wait_option, u32 enable);
-enum mwifiex_status mwifiex_get_wpa_enable(struct mwifiex_private *priv,
-					   u8 wait_option, u32 *enable);
 enum mwifiex_status mwifiex_find_best_bss(struct mwifiex_private *priv,
 					  u8 wait_option,
 					  struct mwifiex_ssid_bssid
@@ -1049,7 +1025,7 @@ int mwifiex_set_tx_rx_ant(struct mwifiex_private *priv, int antenna);
 int mwifiex_get_tx_rx_ant(struct mwifiex_private *priv, int *antenna);
 
 int mwifiex_get_stats_info(struct mwifiex_private *priv,
-			   struct mwifiex_ds_get_stats *stats);
+			   struct mwifiex_ds_get_stats *log);
 
 int mwifiex_reg_write(struct mwifiex_private *priv, u32 reg_type,
 		      u32 reg_offset, u32 reg_value);
@@ -1060,34 +1036,23 @@ int mwifiex_reg_read(struct mwifiex_private *priv, u32 reg_type,
 int mwifiex_eeprom_read(struct mwifiex_private *priv, u16 offset, u16 bytes,
 			u8 *value);
 
-int mwifiex_set_11n_htcap_cfg(struct mwifiex_private *priv, int data);
-
 int mwifiex_set_11n_httx_cfg(struct mwifiex_private *priv, int data);
 
-int mwifiex_get_11n_htcap_cfg(struct mwifiex_private *priv, int *data);
-
 int mwifiex_get_11n_httx_cfg(struct mwifiex_private *priv, int *data);
 
-int mwifiex_set_atim_window(struct mwifiex_private *priv, int atim);
+void mwifiex_set_atim_window(struct mwifiex_private *priv, int atim);
 
-int mwifiex_get_atim_window(struct mwifiex_private *priv, int *atim);
+void mwifiex_get_atim_window(struct mwifiex_private *priv, int *atim);
 
 int mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_index);
 
 int mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_index);
 
-int mwifiex_set_ewpa_mode(struct mwifiex_private *priv,
-			  struct mwifiex_ssid_bssid *ssid);
-
 int mwifiex_get_addba_param(struct mwifiex_private *priv, int *aaddba_timeout,
 			   int *tx_win_sz, int *rx_win_sz);
 
 int mwifiex_set_addba_param(struct mwifiex_private *priv, int *data);
 
-int mwifiex_set_addba_reject(struct mwifiex_private *priv, int *data);
-
-int mwifiex_get_addba_reject(struct mwifiex_private *priv, int *data);
-
 int mwifiex_drv_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
 			       bool bdeep_sleep, u16 idletime);
 
@@ -1119,10 +1084,6 @@ int mwifiex_get_sleep_pd(struct mwifiex_private *priv, int *sleeppd);
 
 int mwifiex_set_sleep_pd(struct mwifiex_private *priv, int sleeppd);
 
-int mwifiex_set_qos_cfg(struct mwifiex_private *priv, int qoscfg);
-
-int mwifiex_get_qos_cfg(struct mwifiex_private *priv, int *qoscfg);
-
 int mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter,
 				   char *version, int max_len);
 
@@ -1135,6 +1096,122 @@ int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
 
 int mwifiex_get_esupp_mode(struct mwifiex_private *priv,
 			   struct mwifiex_ds_esupp_mode *esupp_mode);
+
+enum mwifiex_status
+mwifiex_bss_ioctl_start(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_ssid_bssid *);
+enum mwifiex_status
+mwifiex_bss_ioctl_stop(struct mwifiex_private *,
+			struct mwifiex_wait_queue *, u8 *);
+enum mwifiex_status
+mwifiex_bss_ioctl_mode(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			u16 action, int *mode);
+enum mwifiex_status
+mwifiex_bss_ioctl_channel(struct mwifiex_private *,
+			  u16 action,
+			  struct mwifiex_chan_freq_power *cfp);
+enum mwifiex_status
+mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			u16 action,
+			struct mwifiex_multicast_list *);
+enum mwifiex_status
+mwifiex_bss_ioctl_mac_address(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			u8 action, u8 *mac);
+enum mwifiex_status
+mwifiex_bss_ioctl_find_bss(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_ssid_bssid *);
+enum mwifiex_status
+mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			u16 action, u16 *chan);
+enum mwifiex_status
+mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *,
+			     u16 action,
+			     struct mwifiex_ds_band_cfg *);
+enum mwifiex_status
+mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			u16 action, u32 *);
+enum mwifiex_status
+mwifiex_snmp_mib_ioctl(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			u32 cmd_oid, u16 action, u32 *value);
+enum mwifiex_status
+mwifiex_get_info_stats(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_ds_get_stats *);
+enum mwifiex_status
+mwifiex_get_info_signal(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_ds_get_signal *);
+enum mwifiex_status
+mwifiex_get_info_ver_ext(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_ver_ext *);
+enum mwifiex_status
+mwifiex_get_bss_info(struct mwifiex_private *,
+			struct mwifiex_bss_info *);
+enum mwifiex_status
+mwifiex_set_auth_mode(struct mwifiex_private *, u32);
+enum mwifiex_status
+mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_ds_esupp_mode *);
+enum mwifiex_status
+mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_ds_encrypt_key *,
+			u16 action);
+enum mwifiex_status
+mwifiex_sec_ioctl_passphrase(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_ds_passphrase *,
+			u16 action);
+
+enum mwifiex_status
+mwifiex_rate_ioctl_cfg(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_rate_cfg *);
+enum mwifiex_status
+mwifiex_power_ioctl_set_power(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_power_cfg *);
+enum mwifiex_status
+mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			u32 *, u16 action);
+enum mwifiex_status
+mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *, struct
+			mwifiex_wait_queue *, u16 action,
+			struct mwifiex_ds_hs_cfg *);
+enum mwifiex_status
+mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_ds_auto_ds *,
+			u16);
+enum mwifiex_status
+mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			u32 *, u16);
+enum mwifiex_status
+mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_ds_reg_rw *,
+			u16 action);
+enum mwifiex_status
+mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *,
+			struct mwifiex_wait_queue *,
+			struct mwifiex_ds_read_eeprom *);
+enum mwifiex_status
+mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *,
+			struct mwifiex_ds_misc_gen_ie *,
+			u16 action);
+
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index bd623cf..4e9941e 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -191,8 +191,9 @@ enum mwifiex_status
 mwifiex_find_best_bss(struct mwifiex_private *priv,
 		      u8 wait_option, struct mwifiex_ssid_bssid *ssid_bssid)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_bss *bss = NULL;
+	struct mwifiex_wait_queue *wait1 = NULL, *wait2 = NULL;
+	struct mwifiex_ssid_bssid tmp_ssid_bssid;
+	struct mwifiex_ds_passphrase passphrase;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	u8 *mac = NULL;
 
@@ -203,25 +204,42 @@ mwifiex_find_best_bss(struct mwifiex_private *priv,
 		goto done;
 	}
 
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req == NULL) {
+	if (priv->ewpa_query) {
+		/* Allocate wait request buffer */
+		wait1 = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+		if (!wait1) {
+			ret = MWIFIEX_STATUS_FAILURE;
+			goto done;
+		}
+
+		memset(&passphrase, 0, sizeof(passphrase));
+		passphrase.psk_type = MWIFIEX_PSK_QUERY;
+		memcpy(&passphrase.ssid, &ssid_bssid->ssid,
+				sizeof(struct mwifiex_802_11_ssid));
+		memcpy(passphrase.bssid, ssid_bssid->bssid,
+				MWIFIEX_MAC_ADDR_LENGTH);
+		ret = mwifiex_sec_ioctl_passphrase(priv, wait1, &passphrase,
+						   HostCmd_ACT_GEN_GET);
+
+		ret = mwifiex_request_ioctl(priv, wait1, ret, wait_option);
+		if (ret != MWIFIEX_STATUS_SUCCESS)
+			goto done;
+		mwifiex_set_ewpa_mode_from_passphrase(priv, &passphrase);
+	}
+
+	/* Allocate wait request buffer */
+	wait2 = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait2) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
-	/* Fill request buffer */
-	bss = (struct mwifiex_ds_bss *) req->buffer;
-	req->req_id = MWIFIEX_IOCTL_BSS;
-	req->action = MWIFIEX_ACT_GET;
-	bss->sub_command = MWIFIEX_OID_BSS_FIND_BSS;
-
-	memcpy(&bss->param.ssid_bssid, ssid_bssid,
+	memcpy(&tmp_ssid_bssid, ssid_bssid,
 	       sizeof(struct mwifiex_ssid_bssid));
+	ret = mwifiex_bss_ioctl_find_bss(priv, wait2, &tmp_ssid_bssid);
 
-	ret = mwifiex_request_ioctl(priv, req, wait_option);
 	if (ret == MWIFIEX_STATUS_SUCCESS) {
-		memcpy(ssid_bssid, &bss->param.ssid_bssid,
+		memcpy(ssid_bssid, &tmp_ssid_bssid,
 		       sizeof(struct mwifiex_ssid_bssid));
 		mac = (u8 *) &ssid_bssid->bssid;
 		PRINTM(MCMND,
@@ -231,7 +249,9 @@ mwifiex_find_best_bss(struct mwifiex_private *priv,
 	}
 
 done:
-	kfree(req);
+	kfree(wait1);
+	kfree(wait2);
+
 	LEAVE();
 	return ret;
 }
@@ -249,34 +269,27 @@ enum mwifiex_status
 mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 		struct mwifiex_user_scan_cfg *scan_req)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_scan *scan = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
 	ENTER();
 
 	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_scan) +
-			sizeof(struct mwifiex_user_scan_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		status = -ENOMEM;
 		goto done;
 	}
 
-	/* Fill request buffer */
-	scan = (struct mwifiex_ds_scan *) req->buffer;
-	scan->sub_command = MWIFIEX_OID_SCAN_USER_CONFIG;
-	req->req_id = MWIFIEX_IOCTL_SCAN;
-	req->action = MWIFIEX_ACT_SET;
-
-	memcpy(scan->param.user_scan.scan_cfg_buf,
-			scan_req, sizeof(struct mwifiex_user_scan_cfg));
+	status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_SET,
+				       scan_req, NULL);
 
-	status = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 
 done:
-	if (req && (status != MWIFIEX_STATUS_PENDING))
-		kfree(req);
+	if (wait && (status != MWIFIEX_STATUS_PENDING))
+		kfree(wait);
 	LEAVE();
 	return status;
 }
@@ -295,9 +308,9 @@ mwifiex_request_scan(struct mwifiex_private *priv,
 		     u8 wait_option, struct mwifiex_802_11_ssid *req_ssid)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ioctl_req *ioctl_req = NULL;
-	struct mwifiex_ds_scan *scan = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+
 	ENTER();
 
 	if (down_interruptible(&priv->async_sem)) {
@@ -307,40 +320,31 @@ mwifiex_request_scan(struct mwifiex_private *priv,
 	}
 	priv->scan_pending_on_block = true;
 
-	/* Allocate an IOCTL request buffer */
-	ioctl_req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_scan));
-	if (ioctl_req == NULL) {
+	/* Allocate wait request buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
-	scan = (struct mwifiex_ds_scan *) ioctl_req->buffer;
-
 	if (req_ssid && req_ssid->ssid_len != 0) {
 		/* Specific SSID scan */
-		ioctl_req->req_id = MWIFIEX_IOCTL_SCAN;
-		ioctl_req->action = MWIFIEX_ACT_SET;
-
-		scan->sub_command = MWIFIEX_OID_SCAN_SPECIFIC_SSID;
-
-		memcpy(scan->param.scan_req.scan_ssid.ssid,
-		       req_ssid->ssid, req_ssid->ssid_len);
-		scan->param.scan_req.scan_ssid.ssid_len = req_ssid->ssid_len;
+		status = mwifiex_scan_specific_ssid(priv, wait,
+						    HostCmd_ACT_GEN_SET,
+						    req_ssid, NULL);
 	} else {
 		/* Normal scan */
-		ioctl_req->req_id = MWIFIEX_IOCTL_SCAN;
-		ioctl_req->action = MWIFIEX_ACT_SET;
-
-		scan->sub_command = MWIFIEX_OID_SCAN_NORMAL;
+		status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_SET,
+					       NULL, NULL);
 	}
-	status = mwifiex_request_ioctl(priv, ioctl_req, wait_option);
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 	if (status == MWIFIEX_STATUS_FAILURE) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 done:
-	if ((ioctl_req) && (status != MWIFIEX_STATUS_PENDING))
-		kfree(ioctl_req);
+	if ((wait) && (status != MWIFIEX_STATUS_PENDING))
+		kfree(wait);
 	if (ret == MWIFIEX_STATUS_FAILURE) {
 		priv->scan_pending_on_block = false;
 		up(&priv->async_sem);
@@ -762,7 +766,7 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
  */
 static enum mwifiex_status
 mwifiex_scan_channel_list(struct mwifiex_private *priv,
-			  void *ioctl_buf,
+			  void *wait_buf,
 			  u32 max_chan_per_scan,
 			  u8 filtered_scan,
 			  struct mwifiex_scan_cmd_config *scan_cfg_out,
@@ -908,7 +912,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 		ret = mwifiex_prepare_cmd(priv,
 					  HostCmd_CMD_802_11_SCAN,
 					  HostCmd_ACT_GEN_SET,
-					  0, ioctl_buf, scan_cfg_out);
+					  0, wait_buf, scan_cfg_out);
 		if (ret)
 			break;
 	}
@@ -2518,18 +2522,17 @@ mwifiex_scan_delete_ssid_table_entry(struct mwifiex_private *priv,
  */
 enum mwifiex_status
 mwifiex_scan_networks(struct mwifiex_private *priv,
-		      void *ioctl_buf,
-		      const struct mwifiex_user_scan_cfg *user_scan_in)
+		      void *wait_buf, u16 action,
+		      const struct mwifiex_user_scan_cfg *user_scan_in,
+		      struct mwifiex_scan_resp *scan_resp)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmd_node = NULL;
-
 	union mwifiex_scan_cmd_config_tlv *scan_cfg_out = NULL;
 	struct mwifiex_ie_types_chan_list_param_set *chan_list_out;
 	u32 buf_size;
 	struct mwifiex_chan_scan_param_set *scan_chan_list;
-
 	u8 keep_previous_scan;
 	u8 filtered_scan;
 	u8 scan_current_chan_only;
@@ -2538,6 +2541,34 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 
 	ENTER();
 
+	if (action == HostCmd_ACT_GEN_GET) {
+		if (scan_resp) {
+			scan_resp->scan_table = (u8 *) adapter->scan_table;
+			scan_resp->num_in_scan_table =
+				adapter->num_in_scan_table;
+		} else {
+			ret = MWIFIEX_STATUS_FAILURE;
+		}
+		LEAVE();
+		return ret;
+	}
+
+	if (adapter->scan_processing && action == HostCmd_ACT_GEN_SET) {
+		PRINTM(MCMND, "Scan already in process...\n");
+		LEAVE();
+		return ret;
+	}
+
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+	adapter->scan_processing = true;
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+
+	if (priv->scan_block && action == HostCmd_ACT_GEN_SET) {
+		PRINTM(MCMND, "Scan is blocked during association...\n");
+		LEAVE();
+		return ret;
+	}
+
 	scan_cfg_out = kzalloc(sizeof(union mwifiex_scan_cmd_config_tlv),
 					GFP_KERNEL);
 	if (!scan_cfg_out) {
@@ -2578,11 +2609,8 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 		adapter->bcn_buf_end = adapter->bcn_buf;
 	}
 
-	ret = mwifiex_scan_channel_list(priv,
-					ioctl_buf,
-					max_chan_per_scan,
-					filtered_scan,
-					&scan_cfg_out->config,
+	ret = mwifiex_scan_channel_list(priv, wait_buf, max_chan_per_scan,
+					filtered_scan, &scan_cfg_out->config,
 					chan_list_out, scan_chan_list);
 
 	/* Get scan command from scan_pending_q and put to cmd_pending_q */
@@ -2594,17 +2622,17 @@ mwifiex_scan_networks(struct mwifiex_private *priv,
 			list_del(&cmd_node->list);
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 									flags);
-
-			spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
-			adapter->scan_processing = true;
-			spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock,
-					       flags);
 			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
 							true);
 		} else {
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
 		}
+		ret = MWIFIEX_STATUS_PENDING;
+	} else {
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->scan_processing = true;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 	}
 
 	kfree(scan_cfg_out);
@@ -2678,12 +2706,11 @@ mwifiex_cmd_802_11_scan(struct mwifiex_private *priv,
  */
 enum mwifiex_status
 mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
-			struct host_cmd_ds_command *resp, void *ioctl_buf)
+			struct host_cmd_ds_command *resp, void *wq_buf)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_ioctl_req *ioctl_req =
-		(struct mwifiex_ioctl_req *) ioctl_buf;
+	struct mwifiex_wait_queue *wait_queue = NULL;
 	struct cmd_ctrl_node *cmd_node = NULL;
 	struct host_cmd_ds_802_11_scan_rsp *scan_rsp = NULL;
 	struct mwifiex_bssdescriptor *bss_new_entry = NULL;
@@ -2938,13 +2965,14 @@ mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		mwifiex_process_scan_results(priv);
 
 		/* Need to indicate IOCTL complete */
-		if (ioctl_req != NULL) {
-			ioctl_req->status_code = MWIFIEX_ERROR_NO_ERROR;
+		wait_queue = (struct mwifiex_wait_queue *) wq_buf;
+		if (wait_queue) {
+			wait_queue->status = MWIFIEX_ERROR_NO_ERROR;
 
 			/* Indicate ioctl complete */
 			mwifiex_ioctl_complete(adapter,
-					       (struct mwifiex_ioctl_req *)
-					       ioctl_buf,
+					       (struct mwifiex_wait_queue *)
+					       wait_queue,
 					       MWIFIEX_STATUS_SUCCESS);
 		}
 		if (priv->report_scan_result)
@@ -3221,9 +3249,11 @@ done:
  */
 enum mwifiex_status
 mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
-			   void *ioctl_buf,
-			   struct mwifiex_802_11_ssid *req_ssid)
+			   void *wait_buf, u16 action,
+			   struct mwifiex_802_11_ssid *req_ssid,
+			   struct mwifiex_scan_resp *scan_resp)
 {
+	struct mwifiex_adapter *adapter = priv->adapter;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct mwifiex_user_scan_cfg *scan_cfg;
 
@@ -3234,6 +3264,31 @@ mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 		goto done;
 	}
 
+	if (action == HostCmd_ACT_GEN_GET) {
+		if (scan_resp) {
+			scan_resp->scan_table =
+				(u8 *) &priv->curr_bss_params.bss_descriptor;
+			scan_resp->num_in_scan_table =
+				adapter->num_in_scan_table;
+		} else {
+			ret = MWIFIEX_STATUS_FAILURE;
+		}
+		LEAVE();
+		return ret;
+	}
+
+	if (adapter->scan_processing && action == HostCmd_ACT_GEN_SET) {
+		PRINTM(MCMND, "Scan already in process...\n");
+		LEAVE();
+		return ret;
+	}
+
+	if (priv->scan_block && action == HostCmd_ACT_GEN_SET) {
+		PRINTM(MCMND, "Scan is blocked during association...\n");
+		LEAVE();
+		return ret;
+	}
+
 	mwifiex_scan_delete_ssid_table_entry(priv, req_ssid);
 
 	scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg), GFP_KERNEL);
@@ -3247,7 +3302,7 @@ mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	       req_ssid->ssid_len);
 	scan_cfg->keep_previous_scan = true;
 
-	ret = mwifiex_scan_networks(priv, ioctl_buf, scan_cfg);
+	ret = mwifiex_scan_networks(priv, wait_buf, action, scan_cfg, NULL);
 
 	kfree(scan_cfg);
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 4d9abb9..d793d14 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1069,9 +1069,11 @@ mwifiex_cmd_802_11_rf_antenna(struct mwifiex_private *priv,
 
 	if (cmd_action == HostCmd_ACT_GEN_SET) {
 		antenna->action = cpu_to_le16(HostCmd_ACT_SET_BOTH);
-		antenna->antenna_mode = cpu_to_le16(*(u16 *) data_buf);
-	} else
+		antenna->antenna_mode = cpu_to_le16(*(u16 *)data_buf);
+	} else {
 		antenna->action = cpu_to_le16(HostCmd_ACT_GET_BOTH);
+	}
+
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
 }
@@ -1259,11 +1261,9 @@ mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
  * routines based upon the command number.
  */
 enum mwifiex_status
-mwifiex_sta_prepare_cmd(struct mwifiex_private *priv,
-			uint16_t cmd_no,
-			u16 cmd_action,
-			u32 cmd_oid,
-			void *ioctl_buf, void *data_buf, void *cmd_buf)
+mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
+			u16 cmd_action, u32 cmd_oid,
+			void *data_buf, void *cmd_buf)
 {
 	struct host_cmd_ds_command *cmd_ptr =
 		(struct host_cmd_ds_command *) cmd_buf;
@@ -1558,7 +1558,7 @@ mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	}
 
 	memset(&amsdu_aggr_ctrl, 0, sizeof(amsdu_aggr_ctrl));
-	amsdu_aggr_ctrl.enable = MWIFIEX_ACT_ENABLE;
+	amsdu_aggr_ctrl.enable = true;
 	/* Send request to firmware */
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_AMSDU_AGGR_CTRL,
 				  HostCmd_ACT_GEN_SET, 0, NULL,
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 05a869c..9273971 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -43,7 +43,7 @@
 static void
 mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp,
-			      struct mwifiex_ioctl_req *ioctl_buf)
+			      struct mwifiex_wait_queue *wq_buf)
 {
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -53,8 +53,8 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 
 	PRINTM(MERROR, "CMD_RESP: cmd %#x error, result=%#x\n", resp->command,
 	       resp->result);
-	if (ioctl_buf)
-		ioctl_buf->status_code = MWIFIEX_ERROR_FW_CMDRESP;
+	if (wq_buf)
+		wq_buf->status = MWIFIEX_ERROR_FW_CMDRESP;
 
 	switch (le16_to_cpu(resp->command)) {
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
@@ -83,7 +83,6 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 			list_del(&cmd_node->list);
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
-			cmd_node->ioctl_buf = NULL;
 			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 			spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 		}
@@ -135,11 +134,11 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 static enum mwifiex_status
 mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 			     struct host_cmd_ds_command *resp,
-			     struct mwifiex_ioctl_req *ioctl_buf)
+			     void *data_buf)
 {
 	struct host_cmd_ds_802_11_rssi_info_rsp *rssi_info_rsp =
 		&resp->params.rssi_info_rsp;
-	struct mwifiex_ds_get_info *get_info = NULL;
+	struct mwifiex_ds_get_signal *signal = NULL;
 
 	ENTER();
 
@@ -156,38 +155,33 @@ mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 	priv->bcn_nf_avg = le16_to_cpu(rssi_info_rsp->bcn_nf_avg);
 
 	/* Need to indicate IOCTL complete */
-	if (ioctl_buf != NULL) {
-		get_info = (struct mwifiex_ds_get_info *) ioctl_buf->buffer;
-
-		memset(&get_info->param.signal, 0,
-			sizeof(struct mwifiex_ds_get_signal));
+	if (data_buf) {
+		signal = (struct mwifiex_ds_get_signal *) data_buf;
+		memset(signal, 0, sizeof(struct mwifiex_ds_get_signal));
 
-		get_info->param.signal.selector = ALL_RSSI_INFO_MASK;
+		signal->selector = ALL_RSSI_INFO_MASK;
 
 		/* RSSI */
-		get_info->param.signal.bcn_rssi_last = priv->bcn_rssi_last;
-		get_info->param.signal.bcn_rssi_avg = priv->bcn_rssi_avg;
-		get_info->param.signal.data_rssi_last = priv->data_rssi_last;
-		get_info->param.signal.data_rssi_avg = priv->data_rssi_avg;
+		signal->bcn_rssi_last = priv->bcn_rssi_last;
+		signal->bcn_rssi_avg = priv->bcn_rssi_avg;
+		signal->data_rssi_last = priv->data_rssi_last;
+		signal->data_rssi_avg = priv->data_rssi_avg;
 
 		/* SNR */
-		get_info->param.signal.bcn_snr_last =
+		signal->bcn_snr_last =
 			CAL_SNR(priv->bcn_rssi_last, priv->bcn_nf_last);
-		get_info->param.signal.bcn_snr_avg =
+		signal->bcn_snr_avg =
 			CAL_SNR(priv->bcn_rssi_avg, priv->bcn_nf_avg);
-		get_info->param.signal.data_snr_last =
+		signal->data_snr_last =
 			CAL_SNR(priv->data_rssi_last, priv->data_nf_last);
-		get_info->param.signal.data_snr_avg =
+		signal->data_snr_avg =
 			CAL_SNR(priv->data_rssi_avg, priv->data_nf_avg);
 
 		/* NF */
-		get_info->param.signal.bcn_nf_last = priv->bcn_nf_last;
-		get_info->param.signal.bcn_nf_avg = priv->bcn_nf_avg;
-		get_info->param.signal.data_nf_last = priv->data_nf_last;
-		get_info->param.signal.data_nf_avg = priv->data_nf_avg;
-
-		ioctl_buf->data_read_written =
-			sizeof(struct mwifiex_ds_get_info);
+		signal->bcn_nf_last = priv->bcn_nf_last;
+		signal->bcn_nf_avg = priv->bcn_nf_avg;
+		signal->data_nf_last = priv->data_nf_last;
+		signal->data_nf_avg = priv->data_nf_avg;
 	}
 
 	LEAVE();
@@ -209,56 +203,38 @@ mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 static enum mwifiex_status
 mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
 			    struct host_cmd_ds_command *resp,
-			    struct mwifiex_ioctl_req *ioctl_buf)
+			    void *data_buf)
 {
 	struct host_cmd_ds_802_11_snmp_mib *smib = &resp->params.smib;
 	u16 oid = le16_to_cpu(smib->oid);
 	u16 query_type = le16_to_cpu(smib->query_type);
 	u32 ul_temp;
-	struct mwifiex_ds_snmp_mib *mib = NULL;
 
 	ENTER();
 
-	if (ioctl_buf)
-		mib = (struct mwifiex_ds_snmp_mib *) ioctl_buf->buffer;
-
 	PRINTM(MINFO, "SNMP_RESP: value of the oid = 0x%x, query_type=0x%x\n",
 	       oid, query_type);
 	PRINTM(MINFO, "SNMP_RESP: Buf size  = 0x%x\n",
 	       le16_to_cpu(smib->buf_size));
 	if (query_type == HostCmd_ACT_GEN_GET) {
+		ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
+		if (data_buf)
+			*(u32 *)data_buf = ul_temp;
 		switch (oid) {
 		case FRAG_THRESH_I:
-			ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
 			PRINTM(MINFO, "SNMP_RESP: FragThsd =%u\n", ul_temp);
-			if (mib)
-				mib->param.frag_threshold
-				= cpu_to_le32(ul_temp);
 			break;
-
 		case RTS_THRESH_I:
-			ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
 			PRINTM(MINFO, "SNMP_RESP: RTSThsd =%u\n", ul_temp);
-			if (mib)
-				mib->param.rts_threshold = cpu_to_le32(ul_temp);
 			break;
-
 		case SHORT_RETRY_LIM_I:
-			ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
 			PRINTM(MINFO, "SNMP_RESP: TxRetryCount=%u\n", ul_temp);
-			if (mib)
-				mib->param.retry_count = cpu_to_le32(ul_temp);
 			break;
 		default:
 			break;
 		}
 	}
 
-	if (ioctl_buf) {
-		/* Indicate ioctl complete */
-		ioctl_buf->data_read_written =
-			sizeof(struct mwifiex_ds_snmp_mib);
-	}
 	return MWIFIEX_STATUS_SUCCESS;
 }
 
@@ -271,48 +247,37 @@ mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
 static enum mwifiex_status
 mwifiex_ret_get_log(struct mwifiex_private *priv,
 		    struct host_cmd_ds_command *resp,
-		    struct mwifiex_ioctl_req *ioctl_buf)
+		    void *data_buf)
 {
 	struct host_cmd_ds_802_11_get_log *get_log =
 		(struct host_cmd_ds_802_11_get_log *) &resp->params.get_log;
-	struct mwifiex_ds_get_info *get_info = NULL;
+	struct mwifiex_ds_get_stats *stats = NULL;
 
 	ENTER();
-	if (ioctl_buf) {
-		get_info = (struct mwifiex_ds_get_info *) ioctl_buf->buffer;
-		get_info->param.stats.mcast_tx_frame =
-			le32_to_cpu(get_log->mcast_tx_frame);
-		get_info->param.stats.failed = le32_to_cpu(get_log->failed);
-		get_info->param.stats.retry = le32_to_cpu(get_log->retry);
-		get_info->param.stats.multi_retry =
-			le32_to_cpu(get_log->multiretry);
-		get_info->param.stats.frame_dup =
-			le32_to_cpu(get_log->frame_dup);
-		get_info->param.stats.rts_success =
-			le32_to_cpu(get_log->rts_success);
-		get_info->param.stats.rts_failure =
-			le32_to_cpu(get_log->rts_failure);
-		get_info->param.stats.ack_failure =
-			le32_to_cpu(get_log->ack_failure);
-		get_info->param.stats.rx_frag = le32_to_cpu(get_log->rx_frag);
-		get_info->param.stats.mcast_rx_frame =
-			le32_to_cpu(get_log->mcast_rx_frame);
-		get_info->param.stats.fcs_error =
-			le32_to_cpu(get_log->fcs_error);
-		get_info->param.stats.tx_frame =
-			le32_to_cpu(get_log->tx_frame);
-		get_info->param.stats.wep_icv_error[0] =
+	if (data_buf) {
+		stats = (struct mwifiex_ds_get_stats *) data_buf;
+		stats->mcast_tx_frame = le32_to_cpu(get_log->mcast_tx_frame);
+		stats->failed = le32_to_cpu(get_log->failed);
+		stats->retry = le32_to_cpu(get_log->retry);
+		stats->multi_retry = le32_to_cpu(get_log->multi_retry);
+		stats->frame_dup = le32_to_cpu(get_log->frame_dup);
+		stats->rts_success = le32_to_cpu(get_log->rts_success);
+		stats->rts_failure = le32_to_cpu(get_log->rts_failure);
+		stats->ack_failure = le32_to_cpu(get_log->ack_failure);
+		stats->rx_frag = le32_to_cpu(get_log->rx_frag);
+		stats->mcast_rx_frame = le32_to_cpu(get_log->mcast_rx_frame);
+		stats->fcs_error = le32_to_cpu(get_log->fcs_error);
+		stats->tx_frame = le32_to_cpu(get_log->tx_frame);
+		stats->wep_icv_error[0] =
 			le32_to_cpu(get_log->wep_icv_err_cnt[0]);
-		get_info->param.stats.wep_icv_error[1] =
+		stats->wep_icv_error[1] =
 			le32_to_cpu(get_log->wep_icv_err_cnt[1]);
-		get_info->param.stats.wep_icv_error[2] =
+		stats->wep_icv_error[2] =
 			le32_to_cpu(get_log->wep_icv_err_cnt[2]);
-		get_info->param.stats.wep_icv_error[3] =
+		stats->wep_icv_error[3] =
 			le32_to_cpu(get_log->wep_icv_err_cnt[3]);
-		/* Indicate ioctl complete */
-		ioctl_buf->data_read_written =
-			sizeof(struct mwifiex_ds_get_info);
 	}
+
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
 }
@@ -335,10 +300,10 @@ mwifiex_ret_get_log(struct mwifiex_private *priv,
 static enum mwifiex_status
 mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 			struct host_cmd_ds_command *resp,
-			struct mwifiex_ioctl_req *ioctl_buf)
+			void *data_buf)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_ds_rate *ds_rate = NULL;
+	struct mwifiex_rate_cfg *ds_rate = NULL;
 	struct host_cmd_ds_tx_rate_cfg *rate_cfg = &resp->params.tx_rate_cfg;
 	struct mwifiex_rate_scope *rate_scope;
 	struct mwifiex_ie_types_header *head = NULL;
@@ -393,30 +358,30 @@ mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 
 	}
 
-	if (ioctl_buf) {
-		ds_rate = (struct mwifiex_ds_rate *) ioctl_buf->buffer;
+	if (data_buf) {
+		ds_rate = (struct mwifiex_rate_cfg *) data_buf;
 		if (le16_to_cpu(rate_cfg->action) == HostCmd_ACT_GEN_GET) {
-			if (priv->is_data_rate_auto)
-				ds_rate->param.rate_cfg.is_rate_auto = 1;
-			else {
-				ds_rate->param.rate_cfg.rate =
+			if (priv->is_data_rate_auto) {
+				ds_rate->is_rate_auto = 1;
+			} else {
+				ds_rate->rate =
 					mwifiex_get_rate_index(adapter,
 							       priv->
 							       bitmap_rates,
 							       sizeof(priv->
 							       bitmap_rates));
-				if (ds_rate->param.rate_cfg.rate >=
+				if (ds_rate->rate >=
 				    MWIFIEX_RATE_BITMAP_OFDM0
-				    && ds_rate->param.rate_cfg.rate <=
+				    && ds_rate->rate <=
 				    MWIFIEX_RATE_BITMAP_OFDM7)
-					ds_rate->param.rate_cfg.rate -=
+					ds_rate->rate -=
 						(MWIFIEX_RATE_BITMAP_OFDM0 -
 						 MWIFIEX_RATE_INDEX_OFDM0);
-				if (ds_rate->param.rate_cfg.rate >=
+				if (ds_rate->rate >=
 				    MWIFIEX_RATE_BITMAP_MCS0
-				    && ds_rate->param.rate_cfg.rate <=
+				    && ds_rate->rate <=
 				    MWIFIEX_RATE_BITMAP_MCS127)
-					ds_rate->param.rate_cfg.rate -=
+					ds_rate->rate -=
 						(MWIFIEX_RATE_BITMAP_MCS0 -
 						 MWIFIEX_RATE_INDEX_MCS0);
 			}
@@ -490,14 +455,13 @@ mwifiex_get_power_level(struct mwifiex_private *priv, void *data_buf)
 static enum mwifiex_status
 mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 			 struct host_cmd_ds_command *resp,
-			 struct mwifiex_ioctl_req *ioctl_buf)
+			 void *data_buf)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_txpwr_cfg *txp_cfg = &resp->params.txp_cfg;
 	struct mwifiex_types_power_group *pg_tlv_hdr = NULL;
 	struct mwifiex_power_group *pg = NULL;
 	u16 action = le16_to_cpu(txp_cfg->action);
-	struct mwifiex_ds_power_cfg *power = NULL;
 
 	ENTER();
 	switch (action) {
@@ -545,25 +509,6 @@ mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 	       priv->tx_power_level, priv->max_tx_power_level,
 	       priv->min_tx_power_level);
 
-	if (ioctl_buf) {
-		power = (struct mwifiex_ds_power_cfg *) ioctl_buf->buffer;
-		if (action == HostCmd_ACT_GEN_GET) {
-			if (power->sub_command == MWIFIEX_OID_POWER_CFG) {
-				ioctl_buf->data_read_written =
-					sizeof(struct mwifiex_power_cfg) +
-					MWIFIEX_SUB_COMMAND_SIZE;
-				power->param.power_cfg.power_level =
-					priv->tx_power_level;
-				if (le32_to_cpu(txp_cfg->mode))
-					power->param.power_cfg.is_power_auto =
-						0;
-				else
-					power->param.power_cfg.is_power_auto =
-						1;
-			}
-		}
-	}
-
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
 }
@@ -579,22 +524,19 @@ mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 static enum mwifiex_status
 mwifiex_ret_802_11_sleep_period(struct mwifiex_private *priv,
 				struct host_cmd_ds_command *resp,
-				struct mwifiex_ioctl_req *ioctl_buf)
+				void *data_buf)
 {
 	struct host_cmd_ds_802_11_sleep_period *cmd_sleep_pd =
 		&resp->params.sleep_pd;
-	struct mwifiex_ds_pm_cfg *pm_cfg = NULL;
+	u32 *sleep_period;
 	u16 sleep_pd = 0;
 
 	ENTER();
 
 	sleep_pd = le16_to_cpu(cmd_sleep_pd->sleep_pd);
-	if (ioctl_buf) {
-		pm_cfg = (struct mwifiex_ds_pm_cfg *) ioctl_buf->buffer;
-		pm_cfg->param.sleep_period = (u32) sleep_pd;
-		ioctl_buf->data_read_written =
-			sizeof(pm_cfg->param.sleep_period)
-			+ MWIFIEX_SUB_COMMAND_SIZE;
+	if (data_buf) {
+		sleep_period = (u32 *) data_buf;
+		*sleep_period = (u32) sleep_pd;
 	}
 	priv->adapter->sleep_period.period = sleep_pd;
 	priv->adapter->pps_uapsd_mode = false;
@@ -618,12 +560,10 @@ mwifiex_ret_802_11_sleep_period(struct mwifiex_private *priv,
  */
 static enum mwifiex_status
 mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
-			       struct host_cmd_ds_command *resp,
-			       struct mwifiex_ioctl_req *ioctl_buf)
+			       struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11_mac_address *cmd_mac_addr =
 		&resp->params.mac_addr;
-	struct mwifiex_ds_bss *bss = NULL;
 
 	ENTER();
 
@@ -634,13 +574,7 @@ mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
 	       priv->curr_addr[0], priv->curr_addr[1], priv->curr_addr[2],
 	       priv->curr_addr[3], priv->curr_addr[4],
 	       priv->curr_addr[5]);
-	if (ioctl_buf) {
-		bss = (struct mwifiex_ds_bss *) ioctl_buf->buffer;
-		memcpy(&bss->param.mac_addr, priv->curr_addr,
-		       MWIFIEX_MAC_ADDR_LENGTH);
-		ioctl_buf->data_read_written =
-			MWIFIEX_MAC_ADDR_LENGTH + MWIFIEX_SUB_COMMAND_SIZE;
-	}
+
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
 }
@@ -651,15 +585,9 @@ mwifiex_ret_802_11_mac_address(struct mwifiex_private *priv,
  */
 static enum mwifiex_status
 mwifiex_ret_mac_multicast_adr(struct mwifiex_private *priv,
-			      struct host_cmd_ds_command *resp,
-			      struct mwifiex_ioctl_req *ioctl_buf)
+			      struct host_cmd_ds_command *resp)
 {
 	ENTER();
-	if (ioctl_buf) {
-		ioctl_buf->data_read_written =
-			sizeof(struct mwifiex_multicast_list) +
-			MWIFIEX_SUB_COMMAND_SIZE;
-	}
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
 }
@@ -675,11 +603,9 @@ mwifiex_ret_mac_multicast_adr(struct mwifiex_private *priv,
  */
 static enum mwifiex_status
 mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
-				 struct host_cmd_ds_command *resp,
-				 struct mwifiex_ioctl_req *ioctl_buf)
+				 struct host_cmd_ds_command *resp)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_ds_rate *rate = NULL;
 	ENTER();
 
 	priv->tx_rate = resp->params.tx_rate.tx_rate;
@@ -690,64 +616,6 @@ mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
 						   priv->tx_htinfo);
 	}
 
-	if (ioctl_buf) {
-		rate = (struct mwifiex_ds_rate *) ioctl_buf->buffer;
-		if (rate->sub_command == MWIFIEX_OID_RATE_CFG) {
-			if (rate->param.rate_cfg.rate_type ==
-			    MWIFIEX_RATE_INDEX) {
-				if (priv->tx_htinfo & BIT(0))
-					rate->param.rate_cfg.rate =
-						priv->tx_rate +
-						MWIFIEX_RATE_INDEX_MCS0;
-				else
-					/* For HostCmd_CMD_802_11_TX_RATE_QUERY
-					   , there is a hole in rate table
-					   between HR/DSSS and OFDM rates, so
-					   minus 1 for OFDM rate index */
-					rate->param.rate_cfg.rate =
-						(priv->tx_rate >
-						 MWIFIEX_RATE_INDEX_OFDM0) ?
-						priv->tx_rate -
-						1 : priv->tx_rate;
-			} else {
-				rate->param.rate_cfg.rate =
-					mwifiex_index_to_data_rate(adapter,
-								   priv->
-								   tx_rate,
-								   priv->
-								   tx_htinfo);
-			}
-		} else if (rate->sub_command == MWIFIEX_OID_GET_DATA_RATE) {
-			if (priv->tx_htinfo & BIT(0))
-				rate->param.data_rate.tx_data_rate =
-					priv->tx_rate +
-					MWIFIEX_RATE_INDEX_MCS0;
-			else
-				/* For HostCmd_CMD_802_11_TX_RATE_QUERY, there
-				   is a hole in rate table between HR/DSSS and
-				   OFDM rates, so minus 1 for OFDM rate
-				   index */
-				rate->param.data_rate.tx_data_rate =
-					(priv->tx_rate >
-					 MWIFIEX_RATE_INDEX_OFDM0) ? priv->
-					tx_rate - 1 : priv->tx_rate;
-			if (priv->rxpd_htinfo & BIT(0))
-				rate->param.data_rate.rx_data_rate =
-					priv->rxpd_rate +
-					MWIFIEX_RATE_INDEX_MCS0;
-			else
-				/* For rate index in rxpd, there is a hole in
-				   rate table between HR/DSSS and OFDM rates,
-				   so minus 1 for OFDM rate index */
-				rate->param.data_rate.rx_data_rate =
-					(priv->rxpd_rate >
-					 MWIFIEX_RATE_INDEX_OFDM0) ? priv->
-					rxpd_rate - 1 : priv->rxpd_rate;
-		}
-		ioctl_buf->data_read_written =
-			sizeof(struct mwifiex_multicast_list) +
-			MWIFIEX_SUB_COMMAND_SIZE;
-	}
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
 }
@@ -761,8 +629,7 @@ mwifiex_ret_802_11_tx_rate_query(struct mwifiex_private *priv,
  */
 static enum mwifiex_status
 mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
-				  struct host_cmd_ds_command *resp,
-				  struct mwifiex_ioctl_req *ioctl_buf)
+				  struct host_cmd_ds_command *resp)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	ENTER();
@@ -784,8 +651,7 @@ mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
  */
 static enum mwifiex_status
 mwifiex_ret_802_11_ad_hoc_stop(struct mwifiex_private *priv,
-			       struct host_cmd_ds_command *resp,
-			       struct mwifiex_ioctl_req *ioctl_buf)
+			       struct host_cmd_ds_command *resp)
 {
 	ENTER();
 
@@ -802,8 +668,7 @@ mwifiex_ret_802_11_ad_hoc_stop(struct mwifiex_private *priv,
  */
 static enum mwifiex_status
 mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *resp,
-				struct mwifiex_ioctl_req *ioctl_buf)
+				struct host_cmd_ds_command *resp)
 {
 	struct host_cmd_ds_802_11_key_material *key =
 		&resp->params.key_material;
@@ -842,12 +707,12 @@ mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
 static enum mwifiex_status
 mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 				  struct host_cmd_ds_command *resp,
-				  struct mwifiex_ioctl_req *pioctl_buf)
+				  void *data_buf)
 {
+	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct host_cmd_ds_802_11_supplicant_pmk *supplicant_pmk_resp =
 		&resp->params.esupp_psk;
-	struct mwifiex_ds_sec_cfg sec_buf;
-	struct mwifiex_ds_sec_cfg *sec = NULL;
+	struct mwifiex_ds_passphrase *passphrase = NULL;
 	struct mwifiex_ie_types_pmk *ppmk_tlv = NULL;
 	struct mwifiex_ie_types_passphrase *passphrase_tlv = NULL;
 	struct mwifiex_ie_types_ssid_param_set *pssid_tlv = NULL;
@@ -856,18 +721,13 @@ mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 	u16 action = le16_to_cpu(supplicant_pmk_resp->action);
 	int  tlv_buf_len = 0;
 	u16 tlv;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 
 	ENTER();
 	tlv_buf_len = le16_to_cpu(resp->size) -
 			(sizeof(struct host_cmd_ds_802_11_supplicant_pmk) +
 			S_DS_GEN-1);
-	if (pioctl_buf) {
-		if (((struct mwifiex_ds_bss *)pioctl_buf->buffer)->sub_command
-				== MWIFIEX_OID_BSS_FIND_BSS)
-			sec = &sec_buf;
-		else
-			sec = (struct mwifiex_ds_sec_cfg *)pioctl_buf->buffer;
+	if (data_buf) {
+		passphrase = (struct mwifiex_ds_passphrase *)data_buf;
 		if (action == HostCmd_ACT_GEN_GET) {
 			while (tlv_buf_len > 0) {
 				tlv = (*tlv_buf) | (*(tlv_buf + 1) << 8);
@@ -882,11 +742,11 @@ mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 						(struct
 						mwifiex_ie_types_ssid_param_set
 						*)tlv_buf;
-					memcpy(sec->param.passphrase.ssid.ssid,
+					memcpy(passphrase->ssid.ssid,
 						pssid_tlv->ssid,
 						le16_to_cpu(
 						pssid_tlv->header.len));
-					sec->param.passphrase.ssid.ssid_len =
+					passphrase->ssid.ssid_len =
 						le16_to_cpu(
 						pssid_tlv->header.len);
 					tlv_buf += le16_to_cpu(
@@ -904,7 +764,7 @@ mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 					pbssid_tlv =
 					       (struct mwifiex_ie_types_bssid *)
 						tlv_buf;
-					memcpy(&sec->param.passphrase.bssid,
+					memcpy(&passphrase->bssid,
 						pbssid_tlv->bssid,
 						MWIFIEX_MAC_ADDR_LENGTH);
 					tlv_buf += le16_to_cpu(
@@ -922,13 +782,13 @@ mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 					passphrase_tlv =
 					  (struct mwifiex_ie_types_passphrase *)
 						tlv_buf;
-					sec->param.passphrase.psk_type =
+					passphrase->psk_type =
 						MWIFIEX_PSK_PASSPHRASE;
-					sec->param.passphrase.psk.passphrase
+					passphrase->psk.passphrase
 						.passphrase_len =
 						le16_to_cpu(
 						passphrase_tlv->header.len);
-					memcpy(sec->param.passphrase.psk
+					memcpy(passphrase->psk
 						.passphrase.passphrase,
 						passphrase_tlv->passphrase,
 						le16_to_cpu(
@@ -949,9 +809,9 @@ mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 					ppmk_tlv =
 						(struct mwifiex_ie_types_pmk *)
 						tlv_buf;
-					sec->param.passphrase.psk_type =
+					passphrase->psk_type =
 						MWIFIEX_PSK_PMK;
-					memcpy(sec->param.passphrase.psk
+					memcpy(passphrase->psk
 						.pmk.pmk, ppmk_tlv->pmk,
 						le16_to_cpu(
 						ppmk_tlv->header.len));
@@ -970,15 +830,6 @@ mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 
 				}
 			}
-			if (((struct mwifiex_ds_bss *)
-					pioctl_buf->buffer)->sub_command
-					== MWIFIEX_OID_BSS_FIND_BSS) {
-				wlan_set_ewpa_mode(priv,
-					&sec->param.passphrase);
-				ret = mwifiex_find_bss(
-					priv,
-					pioctl_buf);
-			}
 		} else if (action == HostCmd_ACT_GEN_SET) {
 			PRINTM(MINFO, "Esupp PMK set: enable ewpa query\n");
 			priv->ewpa_query = true;
@@ -1000,15 +851,15 @@ mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
  */
 static enum mwifiex_status
 mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
-				      struct host_cmd_ds_command   *resp,
-				      struct mwifiex_ioctl_req *pioctl_buf)
+				      struct host_cmd_ds_command *resp,
+				      void *data_buf)
 {
 	struct host_cmd_ds_802_11_supplicant_profile *psup_profile =
 		&resp->params.esupp_profile;
 	struct mwifiex_ie_types_header *head;
 	struct mwifiex_ie_types_encrproto *encr_proto_tlv = NULL;
 	struct mwifiex_ie_types_cipher *pcipher_tlv = NULL;
-	struct mwifiex_ds_sec_cfg *sec = NULL;
+	struct mwifiex_ds_esupp_mode *esupp_mode = NULL;
 	u8 *tlv;
 	int len;
 
@@ -1016,8 +867,8 @@ mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
 
 	len = le16_to_cpu(resp->size) - S_DS_GEN - sizeof(u16);
 	tlv = psup_profile->tlv_buf;
-	if (pioctl_buf) {
-		sec = (struct mwifiex_ds_sec_cfg *)pioctl_buf->buffer;
+	if (data_buf) {
+		esupp_mode = (struct mwifiex_ds_esupp_mode *)data_buf;
 		while (len > 0) {
 			head = (struct mwifiex_ie_types_header *) tlv;
 			switch (le16_to_cpu(head->type)) {
@@ -1025,24 +876,22 @@ mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
 				encr_proto_tlv =
 					(struct mwifiex_ie_types_encrproto *)
 					head;
-				sec->param.esupp_mode.rsn_mode =
+				esupp_mode->rsn_mode =
 					le16_to_cpu(encr_proto_tlv->rsn_mode);
 				PRINTM(MINFO, "rsn_mode=0x%x\n",
-					sec->param.esupp_mode.rsn_mode);
+					esupp_mode->rsn_mode);
 				break;
 			case TLV_TYPE_CIPHER:
 				pcipher_tlv =
 					(struct mwifiex_ie_types_cipher *)head;
-				sec->param.esupp_mode.act_paircipher =
+				esupp_mode->act_paircipher =
 					pcipher_tlv->pair_cipher;
-				sec->param.esupp_mode.act_groupcipher =
+				esupp_mode->act_groupcipher =
 					pcipher_tlv->group_cipher;
 				PRINTM(MINFO, "paircipher=0x%x, "
 					      "groupcipher=0x%x\n",
-					      sec->param.esupp_mode
-					      .act_paircipher,
-					      sec->param.esupp_mode
-					      .act_groupcipher);
+					      esupp_mode->act_paircipher,
+					      esupp_mode->act_groupcipher);
 				break;
 			}
 			len -= (le16_to_cpu(head->len) -
@@ -1117,12 +966,12 @@ mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 static enum mwifiex_status
 mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp,
-			      struct mwifiex_ioctl_req *ioctl_buf)
+			      void *data_buf)
 {
 	struct host_cmd_ds_802_11_rf_channel *rf_channel =
 		&resp->params.rf_channel;
 	u16 new_channel = le16_to_cpu(rf_channel->current_channel);
-	struct mwifiex_ds_bss *bss = NULL;
+
 	ENTER();
 	if (priv->curr_bss_params.bss_descriptor.channel != new_channel) {
 		PRINTM(MCMND, "Channel Switch: %d to %d\n",
@@ -1131,10 +980,9 @@ mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
 		/* Update the channel again */
 		priv->curr_bss_params.bss_descriptor.channel = new_channel;
 	}
-	if (ioctl_buf) {
-		bss = (struct mwifiex_ds_bss *) ioctl_buf->buffer;
-		bss->param.bss_chan.channel = new_channel;
-	}
+	if (data_buf)
+		*((u16 *)data_buf) = new_channel;
+
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
 }
@@ -1148,21 +996,19 @@ mwifiex_ret_802_11_rf_channel(struct mwifiex_private *priv,
 static enum mwifiex_status
 mwifiex_ret_802_11_rf_antenna(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp,
-			      struct mwifiex_ioctl_req *ioctl_buf)
+			      void *data_buf)
 {
 	struct host_cmd_ds_802_11_rf_antenna *antenna = &resp->params.antenna;
-	u16 ant_mode = le16_to_cpu(antenna->antenna_mode);
-	struct mwifiex_ds_radio_cfg *radio = NULL;
+	u32 *ant = (u32 *)data_buf;
 
 	ENTER();
 
 	PRINTM(MINFO, "RF_ANT_RESP: action = 0x%x, Mode = 0x%04x\n",
-	       le16_to_cpu(antenna->action), ant_mode);
+		      le16_to_cpu(antenna->action),
+		      le16_to_cpu(antenna->antenna_mode));
 
-	if (ioctl_buf) {
-		radio = (struct mwifiex_ds_radio_cfg *) ioctl_buf->buffer;
-		radio->param.antenna = ant_mode;
-	}
+	if (data_buf)
+		*ant = (u32)le16_to_cpu(antenna->antenna_mode);
 
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
@@ -1177,15 +1023,15 @@ mwifiex_ret_802_11_rf_antenna(struct mwifiex_private *priv,
 static enum mwifiex_status
 mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 		    struct host_cmd_ds_command *resp,
-		    struct mwifiex_ioctl_req *ioctl_buf)
+		    void *data_buf)
 {
 	struct host_cmd_ds_version_ext *ver_ext = &resp->params.verext;
-	struct mwifiex_ds_get_info *info;
+	struct host_cmd_ds_version_ext *version_ext = NULL;
 	ENTER();
-	if (ioctl_buf) {
-		info = (struct mwifiex_ds_get_info *) ioctl_buf->buffer;
-		info->param.ver_ext.version_str_sel = ver_ext->version_str_sel;
-		memcpy(info->param.ver_ext.version_str, ver_ext->version_str,
+	if (data_buf) {
+		version_ext = (struct host_cmd_ds_version_ext *)data_buf;
+		version_ext->version_str_sel = ver_ext->version_str_sel;
+		memcpy(version_ext->version_str, ver_ext->version_str,
 		       sizeof(char) * 128);
 		memcpy(priv->version_str, ver_ext->version_str, 128);
 	}
@@ -1202,16 +1048,16 @@ mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 static enum mwifiex_status
 mwifiex_ret_reg_access(u16 type,
 		       struct host_cmd_ds_command *resp,
-		       struct mwifiex_ioctl_req *ioctl_buf)
+		       void *data_buf)
 {
-	struct mwifiex_ds_reg_mem *reg_mem = NULL;
 	struct mwifiex_ds_reg_rw *reg_rw = NULL;
+	struct mwifiex_ds_read_eeprom *eeprom = NULL;
 
 	ENTER();
 
-	if (ioctl_buf) {
-		reg_mem = (struct mwifiex_ds_reg_mem *) ioctl_buf->buffer;
-		reg_rw = &reg_mem->param.reg_rw;
+	if (data_buf) {
+		reg_rw = (struct mwifiex_ds_reg_rw *) data_buf;
+		eeprom = (struct mwifiex_ds_read_eeprom *) data_buf;
 		switch (type) {
 		case HostCmd_CMD_MAC_REG_ACCESS:
 			{
@@ -1271,8 +1117,6 @@ mwifiex_ret_reg_access(u16 type,
 			}
 		case HostCmd_CMD_802_11_EEPROM_ACCESS:
 			{
-				struct mwifiex_ds_read_eeprom *eeprom =
-					&reg_mem->param.rd_eeprom;
 				struct host_cmd_ds_802_11_eeprom_access
 					*cmd_eeprom =
 					(struct host_cmd_ds_802_11_eeprom_access
@@ -1305,7 +1149,6 @@ mwifiex_ret_reg_access(u16 type,
 			return MWIFIEX_STATUS_FAILURE;
 		}
 	}
-
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
 }
@@ -1377,109 +1220,107 @@ mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
  */
 enum mwifiex_status
 mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
-			    u16 cmdresp_no, void *cmd_buf, void *ioctl)
+			    u16 cmdresp_no, void *cmd_buf, void *wq_buf)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_command *resp =
 		(struct host_cmd_ds_command *) cmd_buf;
-	struct mwifiex_ioctl_req *ioctl_buf =
-		(struct mwifiex_ioctl_req *) ioctl;
-	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_wait_queue *wait_queue =
+		(struct mwifiex_wait_queue *) wq_buf;
+	void *data_buf = adapter->curr_cmd->data_buf;
 
 	ENTER();
 
 	/* If the command is not successful, cleanup and return failure */
-	if ((resp->result != HostCmd_RESULT_OK)
-		) {
-		mwifiex_process_cmdresp_error(priv, resp, ioctl_buf);
+	if (resp->result != HostCmd_RESULT_OK) {
+		mwifiex_process_cmdresp_error(priv, resp, wait_queue);
 		LEAVE();
 		return MWIFIEX_STATUS_FAILURE;
 	}
 	/* Command successful, handle response */
 	switch (cmdresp_no) {
 	case HostCmd_CMD_GET_HW_SPEC:
-		ret = mwifiex_ret_get_hw_spec(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_get_hw_spec(priv, resp);
 		break;
 	case HostCmd_CMD_MAC_CONTROL:
 		break;
 	case HostCmd_CMD_802_11_MAC_ADDRESS:
-		ret = mwifiex_ret_802_11_mac_address(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_mac_address(priv, resp);
 		break;
 	case HostCmd_CMD_MAC_MULTICAST_ADR:
-		ret = mwifiex_ret_mac_multicast_adr(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_mac_multicast_adr(priv, resp);
 		break;
 	case HostCmd_CMD_TX_RATE_CFG:
-		ret = mwifiex_ret_tx_rate_cfg(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_tx_rate_cfg(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_802_11_SCAN:
-		ret = mwifiex_ret_802_11_scan(priv, resp, ioctl_buf);
-		ioctl_buf = NULL;
-		adapter->curr_cmd->ioctl_buf = NULL;
+		ret = mwifiex_ret_802_11_scan(priv, resp, wait_queue);
+		wait_queue = NULL;
+		adapter->curr_cmd->wq_buf = NULL;
 		break;
 	case HostCmd_CMD_802_11_BG_SCAN_QUERY:
-		ret = mwifiex_ret_802_11_scan(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_scan(priv, resp, wait_queue);
 		PRINTM(MINFO, "CMD_RESP: BG_SCAN result is ready!\n");
 		break;
 	case HostCmd_CMD_TXPWR_CFG:
-		ret = mwifiex_ret_tx_power_cfg(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_tx_power_cfg(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
-		ret = mwifiex_ret_enh_power_mode(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_enh_power_mode(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_802_11_HS_CFG_ENH:
-		ret = mwifiex_ret_802_11_hs_cfg(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_hs_cfg(priv, resp);
 		break;
 	case HostCmd_CMD_802_11_SLEEP_PERIOD:
-		ret = mwifiex_ret_802_11_sleep_period(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_sleep_period(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_802_11_ASSOCIATE:
-		ret = mwifiex_ret_802_11_associate(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_associate(priv, resp, wait_queue);
 		break;
 	case HostCmd_CMD_802_11_DEAUTHENTICATE:
-		ret = mwifiex_ret_802_11_deauthenticate(priv, resp,
-							ioctl_buf);
+		ret = mwifiex_ret_802_11_deauthenticate(priv, resp);
 		break;
 	case HostCmd_CMD_802_11_AD_HOC_START:
 	case HostCmd_CMD_802_11_AD_HOC_JOIN:
-		ret = mwifiex_ret_802_11_ad_hoc(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_ad_hoc(priv, resp, wait_queue);
 		break;
 	case HostCmd_CMD_802_11_AD_HOC_STOP:
-		ret = mwifiex_ret_802_11_ad_hoc_stop(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_ad_hoc_stop(priv, resp);
 		break;
 	case HostCmd_CMD_802_11_GET_LOG:
-		ret = mwifiex_ret_get_log(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_get_log(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_RSSI_INFO:
-		ret = mwifiex_ret_802_11_rssi_info(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_rssi_info(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_802_11_SNMP_MIB:
-		ret = mwifiex_ret_802_11_snmp_mib(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_snmp_mib(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_802_11_TX_RATE_QUERY:
-		ret = mwifiex_ret_802_11_tx_rate_query(priv, resp,
-						       ioctl_buf);
+		ret = mwifiex_ret_802_11_tx_rate_query(priv, resp);
 		break;
 	case HostCmd_CMD_802_11_RF_CHANNEL:
-		ret = mwifiex_ret_802_11_rf_channel(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_rf_channel(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_802_11_RF_ANTENNA:
-		ret = mwifiex_ret_802_11_rf_antenna(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_rf_antenna(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_VERSION_EXT:
-		ret = mwifiex_ret_ver_ext(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_ver_ext(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_FUNC_INIT:
 	case HostCmd_CMD_FUNC_SHUTDOWN:
 		break;
 	case HostCmd_CMD_802_11_KEY_MATERIAL:
-		ret = mwifiex_ret_802_11_key_material(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_key_material(priv, resp);
 		break;
 	case HostCmd_CMD_SUPPLICANT_PMK:
-		ret = mwifiex_ret_802_11_supplicant_pmk(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_802_11_supplicant_pmk(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_SUPPLICANT_PROFILE:
 		ret = mwifiex_ret_802_11_supplicant_profile(priv, resp,
-								ioctl_buf);
+								data_buf);
 		break;
 	case HostCmd_CMD_802_11D_DOMAIN_INFO:
 		ret = mwifiex_ret_802_11d_domain_info(priv, resp);
@@ -1511,7 +1352,7 @@ mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 						mp_end_port));
 		break;
 	case HostCmd_CMD_AMSDU_AGGR_CTRL:
-		ret = mwifiex_ret_amsdu_aggr_ctrl(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_amsdu_aggr_ctrl(priv, resp, data_buf);
 		break;
 	case HostCmd_CMD_WMM_GET_STATUS:
 		ret = mwifiex_ret_wmm_get_status(priv, resp);
@@ -1525,12 +1366,12 @@ mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 	case HostCmd_CMD_PMIC_REG_ACCESS:
 	case HostCmd_CMD_CAU_REG_ACCESS:
 	case HostCmd_CMD_802_11_EEPROM_ACCESS:
-		ret = mwifiex_ret_reg_access(cmdresp_no, resp, ioctl_buf);
+		ret = mwifiex_ret_reg_access(cmdresp_no, resp, data_buf);
 		break;
 	case HostCmd_CMD_SET_BSS_MODE:
 		break;
 	case HostCmd_CMD_11N_CFG:
-		ret = mwifiex_ret_11n_cfg(priv, resp, ioctl_buf);
+		ret = mwifiex_ret_11n_cfg(priv, resp, data_buf);
 		break;
 	default:
 		PRINTM(MERROR, "CMD_RESP: Unknown command response %#x\n",
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index f4fcb74..9a197d0 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -28,34 +28,6 @@
 #include "cfg80211.h"
 
 /*
- * This function performs an IOCTL operation as requested by driver.
- *
- * The function makes sure the IOCTL request is valid and passes it lower to
- * be transferred to the card. This function also handles the cancellation
- * request of IOCTLs.
- */
-static enum mwifiex_status
-mwifiex_ioctl(struct mwifiex_adapter *adapter,
-	      struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status ret;
-
-	ENTER();
-
-	if (ioctl_req->action == MWIFIEX_ACT_CANCEL) {
-		mwifiex_cancel_pending_ioctl(adapter, ioctl_req);
-		ret = MWIFIEX_STATUS_SUCCESS;
-		goto exit;
-	}
-
-	ret = mwifiex_sta_ioctl(adapter, ioctl_req);
-
-exit:
-	LEAVE();
-	return ret;
-}
-
-/*
  * Copies the multicast address list from device to driver.
  *
  * This function does not validate the destination memory for
@@ -76,7 +48,7 @@ mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
 }
 
 /*
- * Fills a wait queue with proper parameters.
+ * Allocate and fills a wait queue with proper parameters.
  *
  * This function needs to be called before an IOCTL request can be made.
  * It can handle the following wait options:
@@ -85,11 +57,21 @@ mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
  *      MWIFIEX_CMD_WAIT    - Waiting is done on command wait queue
  *      MWIFIEX_WSTATS_WAIT - Waiting is done on stats wait queue
  */
-static void
-mwifiex_fill_wait_queue(struct mwifiex_private *priv,
-			struct mwifiex_wait_queue *wait, u8 wait_option)
+struct mwifiex_wait_queue *
+mwifiex_alloc_fill_wait_queue(struct mwifiex_private *priv,
+			      u8 wait_option)
 {
+	struct mwifiex_wait_queue *wait = NULL;
+
 	ENTER();
+	wait = (struct mwifiex_wait_queue *)
+		kzalloc(sizeof(struct mwifiex_wait_queue), GFP_ATOMIC);
+	if (!wait) {
+		PRINTM(MERROR, "%s:Fail to alloc wait buffer\n", __func__);
+		goto done;
+	}
+
+	wait->bss_index = priv->bss_index;
 
 	switch (wait_option) {
 	case MWIFIEX_NO_WAIT:
@@ -118,8 +100,9 @@ mwifiex_fill_wait_queue(struct mwifiex_private *priv,
 		break;
 	}
 
+done:
 	LEAVE();
-	return;
+	return wait;
 }
 
 /*
@@ -131,7 +114,8 @@ mwifiex_fill_wait_queue(struct mwifiex_private *priv,
  */
 static void
 mwifiex_wait_ioctl_complete(struct mwifiex_private *priv,
-			    struct mwifiex_ioctl_req *req, u8 wait_option)
+			    struct mwifiex_wait_queue *wait,
+			    u8 wait_option)
 {
 	bool cancel_flag = false;
 
@@ -160,13 +144,9 @@ mwifiex_wait_ioctl_complete(struct mwifiex_private *priv,
 		break;
 	}
 	if (cancel_flag) {
-		req->action = MWIFIEX_ACT_CANCEL;
-		mwifiex_ioctl(priv->adapter, req);
-		PRINTM(MCMND,
-		       "IOCTL cancel: id=0x%lx, sub_id=0x%lx wait_option=%d, "
-		       "action=%d\n",
-		       req->req_id, (*(u32 *) req->buffer), wait_option,
-		       (int) req->action);
+		mwifiex_cancel_pending_ioctl(priv->adapter, wait);
+		PRINTM(MCMND, "IOCTL cancel: wait=%p, wait_option=%d\n",
+			wait, wait_option);
 	}
 
 	LEAVE();
@@ -174,54 +154,28 @@ mwifiex_wait_ioctl_complete(struct mwifiex_private *priv,
 }
 
 /*
- * Request for an IOCTL.
- *
- * This is the common handler function for every IOCTL requests coming
- * to the driver. This function performs validity checking of the request
- * before filling out the wait queue, and issuing the actual request.
- * Afterward, it waits for the request to complete and issues the
+ * The function waits for the request to complete and issues the
  * completion handler, if required.
  */
 enum mwifiex_status
 mwifiex_request_ioctl(struct mwifiex_private *priv,
-		      struct mwifiex_ioctl_req *req, u8 wait_option)
+		      struct mwifiex_wait_queue *wait,
+		      enum mwifiex_status status, u8 wait_option)
 {
-	enum mwifiex_status status;
-
 	ENTER();
-	if (priv->adapter->surprise_removed) {
-		PRINTM(MERROR,
-		       "IOCTL is not allowed while surprise_removed = TRUE\n");
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-
-	if (priv->adapter->is_suspended) {
-		PRINTM(MERROR, "IOCTL is not allowed while suspended\n");
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-
-	req->bss_index = priv->bss_index;
-
-	mwifiex_fill_wait_queue(priv, &req->wq, wait_option);
 
-	status = mwifiex_ioctl(priv->adapter, req);
 	switch (status) {
 	case MWIFIEX_STATUS_PENDING:
-		PRINTM(MCMND, "IOCTL pending: id=0x%lx, sub_id=0x%lx "
-				"wait_option=%d, action=%d\n",
-				req->req_id, (*(u32 *) req->buffer),
-				wait_option,
-				(int) req->action);
+		PRINTM(MCMND, "IOCTL pending: wait=%p, wait_option=%d\n",
+				wait, wait_option);
 		atomic_inc(&priv->adapter->ioctl_pending);
 		/* Status pending, wake up main process */
 		queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
 
 		/* Wait for completion */
 		if (wait_option) {
-			mwifiex_wait_ioctl_complete(priv, req, wait_option);
-			status = req->wq.status;
+			mwifiex_wait_ioctl_complete(priv, wait, wait_option);
+			status = wait->status;
 		}
 		break;
 	case MWIFIEX_STATUS_SUCCESS:
@@ -244,37 +198,33 @@ EXPORT_SYMBOL_GPL(mwifiex_request_ioctl);
 enum mwifiex_status
 mwifiex_request_set_mac_address(struct mwifiex_private *priv)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_bss *bss = NULL;
-	enum mwifiex_status status;
+	struct mwifiex_wait_queue *wait = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	u8 wait_option = MWIFIEX_CMD_WAIT;
+
 	ENTER();
 
-	/* Allocate an IOCTL request buffer */
-	req = (struct mwifiex_ioctl_req *)
-		mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req == NULL) {
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		status = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
-	/* Fill request buffer */
-	bss = (struct mwifiex_ds_bss *) req->buffer;
-	bss->sub_command = MWIFIEX_OID_BSS_MAC_ADDR;
-	memcpy(&bss->param.mac_addr, priv->curr_addr, MWIFIEX_MAC_ADDR_LENGTH);
-	req->req_id = MWIFIEX_IOCTL_BSS;
-	req->action = MWIFIEX_ACT_SET;
+	status = mwifiex_bss_ioctl_mac_address(priv, wait, HostCmd_ACT_GEN_SET,
+					       NULL);
 
-	status = mwifiex_request_ioctl(priv, req, MWIFIEX_CMD_WAIT);
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 	if (status == MWIFIEX_STATUS_SUCCESS) {
 		memcpy(priv->netdev->dev_addr, priv->curr_addr, ETH_ALEN);
 		HEXDUMP("priv->MacAddr:", priv->curr_addr, ETH_ALEN);
 	} else {
 		PRINTM(MERROR,
 		       "set mac address failed! status=%d, error_code=0x%lx\n",
-		       status, req->status_code);
+		       status, wait->status);
 	}
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return status;
 }
@@ -289,40 +239,35 @@ void
 mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 				   struct net_device *dev)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_bss *bss = NULL;
-	enum mwifiex_status status;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_multicast_list mcast_list;
+	u8 wait_option = MWIFIEX_NO_WAIT;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	ENTER();
 
-	/* Allocate an IOCTL request buffer */
-	req = (struct mwifiex_ioctl_req *)
-		mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req == NULL) {
-		PRINTM(MERROR, "%s:Fail to alloc ioctl req buffer\n", __func__);
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
 		goto done;
-	}
 
-	/* Fill request buffer */
-	bss = (struct mwifiex_ds_bss *) req->buffer;
-	bss->sub_command = MWIFIEX_OID_BSS_MULTICAST_LIST;
-	req->req_id = MWIFIEX_IOCTL_BSS;
-	req->action = MWIFIEX_ACT_SET;
 	if (dev->flags & IFF_PROMISC) {
-		bss->param.multicast_list.mode = MWIFIEX_PROMISC_MODE;
+		mcast_list.mode = MWIFIEX_PROMISC_MODE;
 	} else if (dev->flags & IFF_ALLMULTI ||
 		   netdev_mc_count(dev) > MWIFIEX_MAX_MULTICAST_LIST_SIZE) {
-		bss->param.multicast_list.mode = MWIFIEX_ALL_MULTI_MODE;
+		mcast_list.mode = MWIFIEX_ALL_MULTI_MODE;
 	} else {
-		bss->param.multicast_list.mode = MWIFIEX_MULTICAST_MODE;
+		mcast_list.mode = MWIFIEX_MULTICAST_MODE;
 		if (netdev_mc_count(dev))
-			bss->param.multicast_list.num_multicast_addr =
-				mwifiex_copy_mcast_addr(&bss->param.
-							multicast_list, dev);
+			mcast_list.num_multicast_addr =
+				mwifiex_copy_mcast_addr(&mcast_list, dev);
 	}
+	status = mwifiex_bss_ioctl_multicast_list(priv, wait,
+						  HostCmd_ACT_GEN_SET,
+						  &mcast_list);
 
-	status = mwifiex_request_ioctl(priv, req, MWIFIEX_NO_WAIT);
-	if (status != MWIFIEX_STATUS_PENDING)
-		kfree(req);
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
+	if (wait && status != MWIFIEX_STATUS_PENDING)
+		kfree(wait);
 done:
 	LEAVE();
 	return;
@@ -337,33 +282,24 @@ done:
 enum mwifiex_status
 mwifiex_disconnect(struct mwifiex_private *priv, u8 wait_option, u8 *mac)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_bss *bss = NULL;
-	enum mwifiex_status status;
+	struct mwifiex_wait_queue *wait = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 
 	ENTER();
 
-	/* Allocate an IOCTL request buffer */
-	req = (struct mwifiex_ioctl_req *)
-		mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req == NULL) {
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		status = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
-	/* Fill request buffer */
-	bss = (struct mwifiex_ds_bss *) req->buffer;
-	bss->sub_command = MWIFIEX_OID_BSS_STOP;
-	if (mac)
-		memcpy((u8 *) &bss->param.bssid, mac,
-		       MWIFIEX_MAC_ADDR_LENGTH);
-	req->req_id = MWIFIEX_IOCTL_BSS;
-	req->action = MWIFIEX_ACT_SET;
+	status = mwifiex_bss_ioctl_stop(priv, wait, mac);
 
-	status = mwifiex_request_ioctl(priv, req, wait_option);
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return status;
 }
@@ -379,9 +315,9 @@ enum mwifiex_status
 mwifiex_bss_start(struct mwifiex_private *priv, u8 wait_option,
 		  struct mwifiex_ssid_bssid *ssid_bssid)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_bss *bss = NULL;
-	enum mwifiex_status status;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ssid_bssid tmp_ssid_bssid;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 
 	ENTER();
 
@@ -389,68 +325,21 @@ mwifiex_bss_start(struct mwifiex_private *priv, u8 wait_option,
 	if (!netif_queue_stopped(priv->netdev))
 		netif_stop_queue(priv->netdev);
 
-	/* Allocate an IOCTL request buffer */
-	req = (struct mwifiex_ioctl_req *)
-		mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req == NULL) {
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		status = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
-	/* Fill request buffer */
-	bss = (struct mwifiex_ds_bss *) req->buffer;
-	bss->sub_command = MWIFIEX_OID_BSS_START;
 	if (ssid_bssid)
-		memcpy(&bss->param.ssid_bssid, ssid_bssid,
+		memcpy(&tmp_ssid_bssid, ssid_bssid,
 		       sizeof(struct mwifiex_ssid_bssid));
-	req->req_id = MWIFIEX_IOCTL_BSS;
-	req->action = MWIFIEX_ACT_SET;
+	status = mwifiex_bss_ioctl_start(priv, wait, &tmp_ssid_bssid);
 
-	status = mwifiex_request_ioctl(priv, req, wait_option);
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 done:
-	kfree(req);
-	LEAVE();
-	return status;
-}
-
-/*
- * Sends IOCTL request to retrieve information about a BSS.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-enum mwifiex_status
-mwifiex_get_bss_info(struct mwifiex_private *priv, u8 wait_option,
-		     struct mwifiex_bss_info *bss_info)
-{
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_get_info *info = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	ENTER();
-
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_get_info));
-	if (req == NULL) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-
-	/* Fill request buffer */
-	info = (struct mwifiex_ds_get_info *) req->buffer;
-	info->sub_command = MWIFIEX_OID_GET_BSS_INFO;
-	req->req_id = MWIFIEX_IOCTL_GET_INFO;
-	req->action = MWIFIEX_ACT_GET;
-
-	status = mwifiex_request_ioctl(priv, req, wait_option);
-	if (status == MWIFIEX_STATUS_SUCCESS) {
-		if (bss_info) {
-			memcpy(bss_info, &info->param.bss_info,
-			       sizeof(struct mwifiex_bss_info));
-		}
-	}
-
-	if (req && (status != MWIFIEX_STATUS_PENDING))
-		kfree(req);
+	kfree(wait);
 	LEAVE();
 	return status;
 }
@@ -463,82 +352,42 @@ mwifiex_get_bss_info(struct mwifiex_private *priv, u8 wait_option,
  */
 enum mwifiex_status
 mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
-			  struct mwifiex_ds_rate *data_rate)
+			  struct mwifiex_rate_cfg *rate)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_rate *rate = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_rate));
-	if (req == NULL) {
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
-	rate = (struct mwifiex_ds_rate *) req->buffer;
-	rate->param.rate_cfg.rate_type = MWIFIEX_RATE_VALUE;
-	rate->sub_command = MWIFIEX_OID_RATE_CFG;
-	req->req_id = MWIFIEX_IOCTL_RATE;
-	req->action = MWIFIEX_ACT_GET;
+	memset(rate, 0, sizeof(struct mwifiex_rate_cfg));
+	rate->action = HostCmd_ACT_GEN_GET;
+	rate->rate_type = MWIFIEX_RATE_VALUE;
+	ret = mwifiex_rate_ioctl_cfg(priv, wait, rate);
 
-	if (MWIFIEX_STATUS_SUCCESS ==
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
-		if (data_rate)
-			memcpy(data_rate, rate, sizeof(struct mwifiex_ds_rate));
+	ret = mwifiex_request_ioctl(priv, wait, ret, wait_option);
+	if (ret == MWIFIEX_STATUS_SUCCESS) {
+		if (rate && rate->is_rate_auto)
+			rate->rate = mwifiex_index_to_data_rate(priv->adapter,
+					priv->tx_rate, priv->tx_htinfo);
+		else if (rate)
+			rate->rate = priv->data_rate;
 	} else {
 		ret = MWIFIEX_STATUS_FAILURE;
 	}
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
 
-
-/*
- * Sends IOCTL request to get debug information.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-enum mwifiex_status
-mwifiex_get_debug_info(struct mwifiex_private *priv, u8 wait_option,
-		       struct mwifiex_debug_info *debug_info)
-{
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_get_info *info = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	ENTER();
-
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_get_info));
-	if (req == NULL) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-
-	/* Fill request buffer */
-	info = (struct mwifiex_ds_get_info *) req->buffer;
-	info->sub_command = MWIFIEX_OID_GET_DEBUG_INFO;
-	req->req_id = MWIFIEX_IOCTL_GET_INFO;
-	req->action = MWIFIEX_ACT_GET;
-
-	status = mwifiex_request_ioctl(priv, req, wait_option);
-	if (status == MWIFIEX_STATUS_SUCCESS) {
-		if (debug_info) {
-			memcpy(debug_info, &info->param.debug_info,
-			       sizeof(struct mwifiex_debug_info));
-		}
-	}
-
-	if (req && (status != MWIFIEX_STATUS_PENDING))
-		kfree(req);
-	LEAVE();
-	return status;
-}
-
 /*
  * Sends IOCTL request to get Host Sleep parameters.
  *
@@ -551,37 +400,28 @@ mwifiex_set_get_hs_params(struct mwifiex_private *priv, u16 action,
 			  struct mwifiex_ds_hs_cfg *hscfg)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_pm_cfg *pmcfg = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
 
 	ENTER();
 
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_pm_cfg));
-	if (req == NULL) {
+	if (!hscfg) {
+		ret = -ENOMEM;
+		goto done;
+	}
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	/* Fill request buffer */
-	pmcfg = (struct mwifiex_ds_pm_cfg *) req->buffer;
-	pmcfg->sub_command = MWIFIEX_OID_PM_CFG_HS_CFG;
-	req->req_id = MWIFIEX_IOCTL_PM_CFG;
-	req->action = action;
-	if (action == MWIFIEX_ACT_SET)
-		memcpy(&pmcfg->param.hs_cfg, hscfg,
-					sizeof(struct mwifiex_ds_hs_cfg));
+	ret = mwifiex_pm_ioctl_hs_cfg(priv, wait, action, hscfg);
+
+	ret = mwifiex_request_ioctl(priv, wait, ret, wait_option);
 
-	ret = mwifiex_request_ioctl(priv, req, wait_option);
-	if (ret == MWIFIEX_STATUS_SUCCESS) {
-		if (hscfg && action == MWIFIEX_ACT_GET) {
-			memcpy(hscfg, &pmcfg->param.hs_cfg,
-					sizeof(struct mwifiex_ds_hs_cfg));
-		}
-	}
 done:
-	if (req && (ret != MWIFIEX_STATUS_PENDING))
-		kfree(req);
+	if (wait && (ret != MWIFIEX_STATUS_PENDING))
+		kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -604,8 +444,8 @@ mwifiex_cancel_hs(struct mwifiex_private *priv, u8 wait_option)
 	/* Cancel Host Sleep */
 	hscfg.conditions = HOST_SLEEP_CFG_CANCEL;
 	hscfg.is_invoke_hostcmd = true;
-	ret = mwifiex_set_get_hs_params(priv, MWIFIEX_ACT_SET, wait_option,
-								&hscfg);
+	ret = mwifiex_set_get_hs_params(priv, HostCmd_ACT_GEN_SET,
+					wait_option, &hscfg);
 
 	LEAVE();
 	return ret;
@@ -634,14 +474,14 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 	/* Enable Host Sleep */
 	adapter->hs_activate_wait_q_woken = false;
 
-	memset(&hscfg, 0, sizeof(struct mwifiex_ds_hs_cfg));
+	memset(&hscfg, 0, sizeof(struct mwifiex_hs_config_param));
 	hscfg.is_invoke_hostcmd = true;
 
 	if (mwifiex_set_get_hs_params(mwifiex_get_priv(adapter,
 						       MWIFIEX_BSS_ROLE_STA),
-				      MWIFIEX_ACT_SET,
-				      MWIFIEX_IOCTL_WAIT,
-				      &hscfg) != MWIFIEX_STATUS_SUCCESS) {
+				      HostCmd_ACT_GEN_SET,
+				      MWIFIEX_IOCTL_WAIT, &hscfg)
+				      != MWIFIEX_STATUS_SUCCESS) {
 		PRINTM(MERROR, "IOCTL request HS enable failed\n");
 		goto done;
 	}
@@ -664,34 +504,21 @@ EXPORT_SYMBOL_GPL(mwifiex_enable_hs);
  *
  * This only works in the connected mode.
  */
-static enum mwifiex_status
-mwifiex_get_info_signal(struct mwifiex_adapter *adapter,
-			struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_get_info_signal(struct mwifiex_private *priv,
+			struct mwifiex_wait_queue *wait,
+			struct mwifiex_ds_get_signal *signal)
 {
-	struct mwifiex_private *priv = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 
 	ENTER();
 
-	if (ioctl_req != NULL) {
-		priv = adapter->priv[ioctl_req->bss_index];
-	} else {
-		PRINTM(MERROR, "IOCTL information is not present\n");
+	if (!wait) {
+		PRINTM(MERROR, "WAIT information is not present\n");
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto exit;
 	}
 
-	/* Check information buffer length of IOCTL */
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_get_signal)) {
-		PRINTM(MWARN,
-		       "IOCTL information buffer length is too short.\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed =
-			sizeof(struct mwifiex_ds_get_signal);
-		ret = MWIFIEX_STATUS_RESOURCE;
-		goto exit;
-	}
-
 	/* Signal info can be obtained only if connected */
 	if (!priv->media_connected) {
 		PRINTM(MINFO, "Can not get signal in disconnected state\n");
@@ -700,10 +527,8 @@ mwifiex_get_info_signal(struct mwifiex_adapter *adapter,
 	}
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_RSSI_INFO,
-				  HostCmd_ACT_GEN_GET,
-				  0, (void *) ioctl_req, NULL);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_RSSI_INFO,
+				  HostCmd_ACT_GEN_GET, 0, wait, signal);
 
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
@@ -719,39 +544,24 @@ exit:
  * This function prepares the correct firmware command and
  * issues it to get the statistics (RSSI) information.
  */
-static enum mwifiex_status
-mwifiex_get_info_stats(struct mwifiex_adapter *adapter,
-		       struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_get_info_stats(struct mwifiex_private *priv,
+		       struct mwifiex_wait_queue *wait,
+		       struct mwifiex_ds_get_stats *log)
 {
-	struct mwifiex_private *priv = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 
 	ENTER();
 
-	if (ioctl_req != NULL) {
-		priv = adapter->priv[ioctl_req->bss_index];
-	} else {
+	if (!wait) {
 		PRINTM(MERROR, "MWIFIEX IOCTL information is not present\n");
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto exit;
 	}
 
-	/* Check information buffer length of MWIFIEX IOCTL */
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_get_stats)) {
-		PRINTM(MWARN, "MWIFIEX IOCTL information buffer length "
-				"is too short.\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed =
-			sizeof(struct mwifiex_ds_get_stats);
-		ret = MWIFIEX_STATUS_RESOURCE;
-		goto exit;
-	}
-
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_GET_LOG,
-				  HostCmd_ACT_GEN_GET,
-				  0, (void *) ioctl_req, NULL);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_GET_LOG,
+				  HostCmd_ACT_GEN_GET, 0, wait, log);
 
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
@@ -767,77 +577,74 @@ exit:
  * This function collates the information from different driver structures
  * to send to the user.
  */
-static enum mwifiex_status
-mwifiex_get_info_bss_info(struct mwifiex_adapter *adapter,
-			  struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_get_bss_info(struct mwifiex_private *priv,
+		     struct mwifiex_bss_info *info)
 {
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
+	struct mwifiex_adapter *adapter = priv->adapter;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_get_info *info;
 	struct mwifiex_bssdescriptor *bss_desc;
 	s32 tbl_idx = 0;
 
 	ENTER();
 
+	if (!info)
+		return MWIFIEX_STATUS_FAILURE;
+
 	/* Get current BSS info */
 	bss_desc = &priv->curr_bss_params.bss_descriptor;
-	info = (struct mwifiex_ds_get_info *) ioctl_req->buffer;
 
 	/* BSS mode */
-	info->param.bss_info.bss_mode = priv->bss_mode;
+	info->bss_mode = priv->bss_mode;
 
 	/* SSID */
-	memcpy(&info->param.bss_info.ssid, &bss_desc->ssid,
+	memcpy(&info->ssid, &bss_desc->ssid,
 	       sizeof(struct mwifiex_802_11_ssid));
 
 	/* BSSID */
-	memcpy(&info->param.bss_info.bssid, &bss_desc->mac_address,
-	       MWIFIEX_MAC_ADDR_LENGTH);
+	memcpy(&info->bssid, &bss_desc->mac_address, MWIFIEX_MAC_ADDR_LENGTH);
 
 	/* Channel */
-	info->param.bss_info.bss_chan = bss_desc->channel;
+	info->bss_chan = bss_desc->channel;
 
 	/* Region code */
-	info->param.bss_info.region_code = adapter->region_code;
+	info->region_code = adapter->region_code;
 
 	/* Scan table index if connected */
-	info->param.bss_info.scan_table_idx = 0;
+	info->scan_table_idx = 0;
 	if (priv->media_connected) {
 		tbl_idx =
 			mwifiex_find_ssid_in_list(priv, &bss_desc->ssid,
 						  bss_desc->mac_address,
 						  priv->bss_mode);
 		if (tbl_idx >= 0)
-			info->param.bss_info.scan_table_idx = tbl_idx;
+			info->scan_table_idx = tbl_idx;
 	}
 
 	/* Connection status */
-	info->param.bss_info.media_connected = priv->media_connected;
+	info->media_connected = priv->media_connected;
 
 	/* Radio status */
-	info->param.bss_info.radio_on = adapter->radio_on;
+	info->radio_on = adapter->radio_on;
 
 	/* Tx power information */
-	info->param.bss_info.max_power_level = priv->max_tx_power_level;
-	info->param.bss_info.min_power_level = priv->min_tx_power_level;
+	info->max_power_level = priv->max_tx_power_level;
+	info->min_power_level = priv->min_tx_power_level;
 
 	/* AdHoc state */
-	info->param.bss_info.adhoc_state = priv->adhoc_state;
+	info->adhoc_state = priv->adhoc_state;
 
 	/* Last beacon NF */
-	info->param.bss_info.bcn_nf_last = priv->bcn_nf_last;
+	info->bcn_nf_last = priv->bcn_nf_last;
 
 	/* wep status */
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
-		info->param.bss_info.wep_status = true;
+		info->wep_status = true;
 	else
-		info->param.bss_info.wep_status = false;
-
-	info->param.bss_info.is_hs_configured = adapter->is_hs_configured;
-	info->param.bss_info.is_deep_sleep = adapter->is_deep_sleep;
+		info->wep_status = false;
 
-	ioctl_req->data_read_written =
-		sizeof(struct mwifiex_bss_info) + MWIFIEX_SUB_COMMAND_SIZE;
+	info->is_hs_configured = adapter->is_hs_configured;
+	info->is_deep_sleep = adapter->is_deep_sleep;
 
 	LEAVE();
 	return ret;
@@ -849,25 +656,18 @@ mwifiex_get_info_bss_info(struct mwifiex_adapter *adapter,
  * This function prepares the correct firmware command and
  * issues it to get the extended version information.
  */
-static enum mwifiex_status
-mwifiex_get_info_ver_ext(struct mwifiex_adapter *adapter,
-			 struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_get_info_ver_ext(struct mwifiex_private *priv,
+			 struct mwifiex_wait_queue *wait,
+			 struct mwifiex_ver_ext *ver_ext)
 {
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_get_info *info;
 
 	ENTER();
 
-	info = (struct mwifiex_ds_get_info *) ioctl_req->buffer;
-
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_VERSION_EXT,
-				  HostCmd_ACT_GEN_GET,
-				  0,
-				  (void *) ioctl_req,
-				  &info->param.ver_ext.version_str_sel);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_VERSION_EXT,
+				  HostCmd_ACT_GEN_GET, 0, wait, ver_ext);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 
@@ -876,128 +676,38 @@ mwifiex_get_info_ver_ext(struct mwifiex_adapter *adapter,
 }
 
 /*
- * IOCTL request handler to get information.
- *
- * This function is the generic handler and calls other specific handler
- * function based upon the information type requested.
- *
- * Currently, it supports the following get information requests -
- *      MWIFIEX_OID_GET_STATS -      Get statistics information
- *      MWIFIEX_OID_GET_SIGNAL -     Get signal information
- *      MWIFIEX_OID_GET_FW_INFO -    Get firmware information
- *      MWIFIEX_OID_GET_BSS_INFO -   Get BSS information
- *      MWIFIEX_OID_GET_DEBUG_INFO - Get debug information
- *      MWIFIEX_OID_GET_VER_EXT -    Get extended version information
- */
-static enum mwifiex_status
-mwifiex_get_info_ioctl(struct mwifiex_adapter *adapter,
-		       struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_get_info *get_info = NULL;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-
-	ENTER();
-
-	get_info = (struct mwifiex_ds_get_info *) ioctl_req->buffer;
-
-	switch (get_info->sub_command) {
-	case MWIFIEX_OID_GET_STATS:
-		status = mwifiex_get_info_stats(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_GET_SIGNAL:
-		status = mwifiex_get_info_signal(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_GET_FW_INFO:
-		ioctl_req->data_read_written =
-			sizeof(struct mwifiex_fw_info) +
-			MWIFIEX_SUB_COMMAND_SIZE;
-		get_info->param.fw_info.fw_ver = adapter->fw_release_number;
-		memcpy(&get_info->param.fw_info.mac_addr, priv->curr_addr,
-		       MWIFIEX_MAC_ADDR_LENGTH);
-		break;
-	case MWIFIEX_OID_GET_BSS_INFO:
-		status = mwifiex_get_info_bss_info(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_GET_DEBUG_INFO:
-		status = mwifiex_get_info_debug_info(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_GET_VER_EXT:
-		status = mwifiex_get_info_ver_ext(adapter, ioctl_req);
-		break;
-	default:
-		status = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-
-	LEAVE();
-	return status;
-}
-
-/*
  * IOCTL request handler to set/get SNMP MIB parameters.
  *
  * This function prepares the correct firmware command and
  * issues it.
  *
  * Currently the following parameters are supported -
- *      MWIFIEX_OID_SNMP_MIB_RTS_THRESHOLD -  Set/get RTS Threshold
- *      MWIFIEX_OID_SNMP_MIB_FRAG_THRESHOLD - Set/get fragmentation threshold
- *      MWIFIEX_OID_SNMP_MIB_RETRY_COUNT -    Set/get retry count
+ *      Set/get RTS Threshold
+ *      Set/get fragmentation threshold
+ *      Set/get retry count
  */
-static enum mwifiex_status
-mwifiex_snmp_mib_ioctl(struct mwifiex_adapter *adapter,
-		       struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_snmp_mib_ioctl(struct mwifiex_private *priv,
+		       struct mwifiex_wait_queue *wait,
+		       u32 cmd_oid, u16 action, u32 *value)
 {
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	u16 cmd_action = 0;
-	u16 cmd_oid = 0;
-	struct mwifiex_ds_snmp_mib *mib = NULL;
-	u32 value = 0;
 
 	ENTER();
 
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_snmp_mib)) {
-		PRINTM(MWARN,
-		       "IOCTL information buffer length is too short.\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed = sizeof(struct mwifiex_ds_snmp_mib);
-		ret = MWIFIEX_STATUS_RESOURCE;
-		goto exit;
-	}
-
-	mib = (struct mwifiex_ds_snmp_mib *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_SET)
-		cmd_action = HostCmd_ACT_GEN_SET;
-	else
-		cmd_action = HostCmd_ACT_GEN_GET;
-
-	switch (le32_to_cpu(mib->sub_command)) {
-	case MWIFIEX_OID_SNMP_MIB_RTS_THRESHOLD:
-		value = le32_to_cpu(mib->param.rts_threshold);
-		cmd_oid = RTS_THRESH_I;
-		break;
-	case MWIFIEX_OID_SNMP_MIB_FRAG_THRESHOLD:
-		value = le32_to_cpu(mib->param.frag_threshold);
-		cmd_oid = FRAG_THRESH_I;
-		break;
-	case MWIFIEX_OID_SNMP_MIB_RETRY_COUNT:
-		value = le32_to_cpu(mib->param.retry_count);
-		cmd_oid = SHORT_RETRY_LIM_I;
-		break;
+	if (!value) {
+		ret = MWIFIEX_STATUS_FAILURE;
+		goto done;
 	}
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_SNMP_MIB,
-				  cmd_action, cmd_oid, (void *) ioctl_req,
-				  &value);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				  action, cmd_oid, wait, value);
 
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 
-exit:
+done:
 	LEAVE();
 	return ret;
 }
@@ -1014,23 +724,21 @@ exit:
  *      - Ad-hoc channel
  *      - Secondary channel offset
  */
-static enum mwifiex_status
-mwifiex_radio_ioctl_band_cfg(struct mwifiex_adapter *adapter,
-			     struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_radio_ioctl_band_cfg(struct mwifiex_private *priv,
+			     u16 action, struct mwifiex_ds_band_cfg *radio_cfg)
 {
+	struct mwifiex_adapter *adapter = priv->adapter;
 	u8 infra_band = 0;
 	u8 adhoc_band = 0;
 	u32 adhoc_channel = 0;
-	struct mwifiex_ds_radio_cfg *radio_cfg = NULL;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
 
 	ENTER();
 
-	radio_cfg = (struct mwifiex_ds_radio_cfg *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_SET) {
-		infra_band = (u8) radio_cfg->param.band_cfg.config_bands;
-		adhoc_band = (u8) radio_cfg->param.band_cfg.adhoc_start_band;
-		adhoc_channel = radio_cfg->param.band_cfg.adhoc_channel;
+	if (action == HostCmd_ACT_GEN_SET) {
+		infra_band = (u8) radio_cfg->config_bands;
+		adhoc_band = (u8) radio_cfg->adhoc_start_band;
+		adhoc_channel = radio_cfg->adhoc_channel;
 
 		/* SET Infra band */
 		if ((infra_band | adapter->fw_bands) & ~adapter->fw_bands) {
@@ -1049,7 +757,7 @@ mwifiex_radio_ioctl_band_cfg(struct mwifiex_adapter *adapter,
 		if (adhoc_band)
 			adapter->adhoc_start_band = adhoc_band;
 		adapter->chan_offset =
-			(u8) radio_cfg->param.band_cfg.sec_chan_offset;
+			(u8) radio_cfg->sec_chan_offset;
 		/*
 		 * If no adhoc_channel is supplied verify if the existing adhoc
 		 * channel compiles with new adhoc_band
@@ -1059,13 +767,12 @@ mwifiex_radio_ioctl_band_cfg(struct mwifiex_adapter *adapter,
 			     (priv, adapter->adhoc_start_band,
 			     priv->adhoc_channel)) {
 				/* Pass back the default channel */
-				radio_cfg->param.band_cfg.adhoc_channel =
+				radio_cfg->adhoc_channel =
 					DEFAULT_AD_HOC_CHANNEL;
 				if ((adapter->adhoc_start_band & BAND_A)
 				    || (adapter->adhoc_start_band & BAND_AN)
 					) {
-					radio_cfg->param.band_cfg.
-						adhoc_channel =
+					radio_cfg->adhoc_channel =
 						DEFAULT_AD_HOC_CHANNEL_A;
 				}
 			}
@@ -1088,15 +795,13 @@ mwifiex_radio_ioctl_band_cfg(struct mwifiex_adapter *adapter,
 		}
 	} else {
 		/* Infra Bands */
-		radio_cfg->param.band_cfg.config_bands = adapter->config_bands;
+		radio_cfg->config_bands = adapter->config_bands;
 		/* Adhoc Band */
-		radio_cfg->param.band_cfg.adhoc_start_band =
-			adapter->adhoc_start_band;
+		radio_cfg->adhoc_start_band = adapter->adhoc_start_band;
 		/* Adhoc channel */
-		radio_cfg->param.band_cfg.adhoc_channel = priv->adhoc_channel;
+		radio_cfg->adhoc_channel = priv->adhoc_channel;
 		/* Secondary channel offset */
-		radio_cfg->param.band_cfg.sec_chan_offset =
-			adapter->chan_offset;
+		radio_cfg->sec_chan_offset = adapter->chan_offset;
 	}
 
 	LEAVE();
@@ -1110,45 +815,36 @@ mwifiex_radio_ioctl_band_cfg(struct mwifiex_adapter *adapter,
  * issues it. In addition, it performs validity checking on
  * user input data.
  */
-static enum mwifiex_status
-mwifiex_radio_ioctl_ant_cfg(struct mwifiex_adapter *adapter,
-			    struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_radio_ioctl_ant_cfg(struct mwifiex_private *priv,
+			    struct mwifiex_wait_queue *wait,
+			    u16 action, u32 *antenna)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_radio_cfg *radio_cfg = NULL;
-	u16 cmd_action = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
 	u16 antenna_mode;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
 
 	ENTER();
 
-	radio_cfg = (struct mwifiex_ds_radio_cfg *) ioctl_req->buffer;
-
-	if (ioctl_req->action == MWIFIEX_ACT_SET) {
+	if (action == HostCmd_ACT_GEN_SET) {
 		/* User input validation */
-		if ((radio_cfg->param.antenna < RF_ANTENNA_1 ||
-		     radio_cfg->param.antenna >=
-		     (unsigned) (RF_ANTENNA_1 + adapter->number_of_antenna))
-		    && (radio_cfg->param.antenna != RF_ANTENNA_AUTO
+		if ((*antenna < RF_ANTENNA_1 || *antenna >=
+		     (u16) (RF_ANTENNA_1 + adapter->number_of_antenna))
+		    && (*antenna != RF_ANTENNA_AUTO
 			|| adapter->number_of_antenna <= 1)) {
 			PRINTM(MERROR, "Invalid antenna setting\n");
 			ret = MWIFIEX_STATUS_FAILURE;
 			goto exit;
 		}
-		cmd_action = HostCmd_ACT_GEN_SET;
-	} else
-		cmd_action = HostCmd_ACT_GEN_GET;
+	}
 
 	/* Cast it to u16, antenna mode for command
 	   HostCmd_CMD_802_11_RF_ANTENNA requires 2 bytes */
-	antenna_mode = (u16) radio_cfg->param.antenna;
+	antenna_mode = (u16) *antenna;
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_RF_ANTENNA,
-				  cmd_action,
-				  0, (void *) ioctl_req,
-				  (void *) &antenna_mode);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_RF_ANTENNA,
+				  action, 0, wait, &antenna_mode);
 
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
@@ -1159,82 +855,29 @@ exit:
 }
 
 /*
- * IOCTL request handler to set/get radio parameters.
- *
- * This function is the generic handler and calls other specific handler
- * function based upon the parameters type.
- *
- * Currently, it supports the following radio parameter set/get requests -
- *      MWIFIEX_OID_BAND_CFG - Set/get radio band
- *      MWIFIEX_OID_ANT_CFG  - Set/get radio antenna
- */
-static enum mwifiex_status
-mwifiex_radio_ioctl(struct mwifiex_adapter *adapter,
-		    struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_radio_cfg *radio_cfg = NULL;
-
-	ENTER();
-
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_radio_cfg)) {
-		PRINTM(MWARN,
-		       "IOCTL information buffer length is too short.\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed =
-			sizeof(struct mwifiex_ds_radio_cfg);
-		LEAVE();
-		return MWIFIEX_STATUS_RESOURCE;
-	}
-	radio_cfg = (struct mwifiex_ds_radio_cfg *) ioctl_req->buffer;
-	switch (radio_cfg->sub_command) {
-	case MWIFIEX_OID_BAND_CFG:
-		status = mwifiex_radio_ioctl_band_cfg(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_ANT_CFG:
-		status = mwifiex_radio_ioctl_ant_cfg(adapter, ioctl_req);
-		break;
-	default:
-		status = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-
-	LEAVE();
-	return status;
-}
-
-/*
  * IOCTL request handler to set/get MAC address.
  *
  * This function prepares the correct firmware command and
  * issues it to get the extended version information.
  */
-static enum mwifiex_status
-mwifiex_bss_ioctl_mac_address(struct mwifiex_adapter *adapter,
-			      struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_bss_ioctl_mac_address(struct mwifiex_private *priv,
+			      struct mwifiex_wait_queue *wait,
+			      u8 action, u8 *mac)
 {
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_bss *bss = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	ENTER();
-	bss = (struct mwifiex_ds_bss *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
-		ioctl_req->data_read_written =
-			MWIFIEX_MAC_ADDR_LENGTH + MWIFIEX_SUB_COMMAND_SIZE;
-		memcpy(&bss->param.mac_addr, priv->curr_addr,
+
+	if ((action == HostCmd_ACT_GEN_GET) && mac) {
+		memcpy(mac, priv->curr_addr,
 		       MWIFIEX_MAC_ADDR_LENGTH);
 		ret = MWIFIEX_STATUS_SUCCESS;
 		goto exit;
 	}
 
-	memcpy(priv->curr_addr, &bss->param.mac_addr,
-	       MWIFIEX_MAC_ADDR_LENGTH);
-
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_MAC_ADDRESS,
-				  HostCmd_ACT_GEN_SET,
-				  0, (void *) ioctl_req, NULL);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_MAC_ADDRESS,
+				  action, 0, wait, mac);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 exit:
@@ -1251,27 +894,22 @@ exit:
  * This function can be used to enable promiscuous mode, or enable all
  * multicast packets, or to enable selective multicast.
  */
-static enum mwifiex_status
-mwifiex_bss_ioctl_set_multicast_list(struct mwifiex_adapter *adapter,
-				     struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_bss_ioctl_multicast_list(struct mwifiex_private *priv,
+				 struct mwifiex_wait_queue *wait, u16 action,
+				 struct mwifiex_multicast_list *mcast_list)
 {
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_bss *bss = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	u16 old_pkt_filter;
 
 	ENTER();
 
 	old_pkt_filter = priv->curr_pkt_filter;
-	bss = (struct mwifiex_ds_bss *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
+	if (action == HostCmd_ACT_GEN_GET) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto exit;
 	}
-	ioctl_req->data_read_written =
-		sizeof(struct mwifiex_multicast_list) +
-		MWIFIEX_SUB_COMMAND_SIZE;
-	if (bss->param.multicast_list.mode == MWIFIEX_PROMISC_MODE) {
+	if (mcast_list->mode == MWIFIEX_PROMISC_MODE) {
 		PRINTM(MINFO, "Enable Promiscuous mode\n");
 		priv->curr_pkt_filter |= HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
 		priv->curr_pkt_filter &=
@@ -1279,37 +917,30 @@ mwifiex_bss_ioctl_set_multicast_list(struct mwifiex_adapter *adapter,
 	} else {
 		/* Multicast */
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
-		if (bss->param.multicast_list.mode == MWIFIEX_MULTICAST_MODE) {
+		if (mcast_list->mode == MWIFIEX_MULTICAST_MODE) {
 			PRINTM(MINFO, "Enabling All Multicast!\n");
 			priv->curr_pkt_filter |=
 				HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
 		} else {
 			priv->curr_pkt_filter &=
 				~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
-			if (bss->param.multicast_list.num_multicast_addr) {
+			if (mcast_list->num_multicast_addr) {
 				PRINTM(MINFO, "Set multicast list=%d\n",
-				       bss->param.multicast_list.
-				       num_multicast_addr);
+				       mcast_list->num_multicast_addr);
 				/* Set multicast addresses to firmware */
 				if (old_pkt_filter == priv->curr_pkt_filter) {
 					/* Send request to firmware */
 					ret = mwifiex_prepare_cmd(priv,
 						HostCmd_CMD_MAC_MULTICAST_ADR,
-						HostCmd_ACT_GEN_SET,
-						0, (void *)
-						ioctl_req,
-						&bss->param.
-						multicast_list);
+						action, 0, wait, mcast_list);
 					if (ret == MWIFIEX_STATUS_SUCCESS)
 						ret = MWIFIEX_STATUS_PENDING;
 				} else {
 					/* Send request to firmware */
 					ret = mwifiex_prepare_cmd(priv,
 						HostCmd_CMD_MAC_MULTICAST_ADR,
-						HostCmd_ACT_GEN_SET,
-						0, NULL,
-						&bss->param.
-						multicast_list);
+						action, 0, NULL,
+						mcast_list);
 				}
 			}
 		}
@@ -1317,11 +948,8 @@ mwifiex_bss_ioctl_set_multicast_list(struct mwifiex_adapter *adapter,
 	PRINTM(MINFO, "old_pkt_filter=0x%lx, curr_pkt_filter=0x%lx\n",
 	       old_pkt_filter, priv->curr_pkt_filter);
 	if (old_pkt_filter != priv->curr_pkt_filter) {
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_MAC_CONTROL,
-					  HostCmd_ACT_GEN_SET,
-					  0,
-					  (void *) ioctl_req,
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+					  action, 0, wait,
 					  &priv->curr_pkt_filter);
 		if (ret == MWIFIEX_STATUS_SUCCESS)
 			ret = MWIFIEX_STATUS_PENDING;
@@ -1333,74 +961,22 @@ exit:
 }
 
 /*
- * IOCTL request handler to get channel list.
- */
-static enum mwifiex_status
-mwifiex_bss_ioctl_get_channel_list(struct mwifiex_adapter *adapter,
-				struct mwifiex_ioctl_req *ioctl_req)
-{
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	enum ieee80211_band band;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *ch;
-	struct mwifiex_ds_bss *bss = NULL;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	u32 i;
-
-	ENTER();
-	bss = (struct mwifiex_ds_bss *) ioctl_req->buffer;
-	if (ioctl_req->action != MWIFIEX_ACT_GET) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-
-	for (band = 0; (band < IEEE80211_NUM_BANDS) &&
-		(bss->param.chan_list.num_of_chan <
-			MWIFIEX_MAX_CHANNEL_NUM); band++) {
-
-		if (!priv->wdev->wiphy->bands[band])
-			continue;
-
-		sband = priv->wdev->wiphy->bands[band];
-
-		for (i = 0; (i < sband->n_channels) &&
-			(bss->param.chan_list.num_of_chan <
-				MWIFIEX_MAX_CHANNEL_NUM); i++) {
-			ch = &sband->channels[i];
-			if (ch->flags & IEEE80211_CHAN_DISABLED)
-				continue;
-			bss->param.chan_list.cf[bss->param.chan_list.
-				num_of_chan].channel = (u32) ch->hw_value;
-			bss->param.chan_list.cf[bss->param.chan_list.
-				num_of_chan].freq = (u32) ch->center_freq;
-			bss->param.chan_list.num_of_chan++;
-		}
-	}
-
-	PRINTM(MINFO, "num of channel=%d\n", bss->param.chan_list.num_of_chan);
-
-	LEAVE();
-	return ret;
-}
-
-/*
  * IOCTL request handler to set/get active channel.
  *
  * This function performs validity checking on channel/frequency
  * compatibility and returns failure if not valid.
  */
-static enum mwifiex_status
-mwifiex_bss_ioctl_channel(struct mwifiex_adapter *adapter,
-			  struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_bss_ioctl_channel(struct mwifiex_private *priv, u16 action,
+			  struct mwifiex_chan_freq_power *chan)
 {
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_bss *bss = NULL;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_chan_freq_power *cfp = NULL;
+	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+
 	ENTER();
-	bss = (struct mwifiex_ds_bss *) ioctl_req->buffer;
 
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
+	if (action == HostCmd_ACT_GEN_GET) {
 		cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211(priv,
 							   priv->
 							   curr_bss_params.band,
@@ -1408,18 +984,15 @@ mwifiex_bss_ioctl_channel(struct mwifiex_adapter *adapter,
 							   curr_bss_params.
 							   bss_descriptor.
 							   channel);
-		if (cfp) {
-			bss->param.bss_chan.channel = cfp->channel;
-			bss->param.bss_chan.freq = cfp->freq;
+		if (chan) {
+			chan->channel = cfp->channel;
+			chan->freq = cfp->freq;
 		} else
 			ret = MWIFIEX_STATUS_FAILURE;
-		ioctl_req->data_read_written =
-			sizeof(struct mwifiex_chan_freq) +
-			MWIFIEX_SUB_COMMAND_SIZE;
 		LEAVE();
 		return ret;
 	}
-	if (!bss->param.bss_chan.channel && !bss->param.bss_chan.freq) {
+	if (!chan->channel && !chan->freq) {
 		LEAVE();
 		return MWIFIEX_STATUS_FAILURE;
 	}
@@ -1427,19 +1000,16 @@ mwifiex_bss_ioctl_channel(struct mwifiex_adapter *adapter,
 		adapter->adhoc_start_band = BAND_G | BAND_B | BAND_GN;
 	else if (adapter->adhoc_start_band & BAND_A)
 		adapter->adhoc_start_band = BAND_G | BAND_B;
-	if (bss->param.bss_chan.channel) {
-		if (bss->param.bss_chan.channel <= MAX_CHANNEL_BAND_BG)
+	if (chan->channel) {
+		if (chan->channel <= MAX_CHANNEL_BAND_BG)
 			cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211
 							(priv, 0,
-							(u16) bss->param.
-							bss_chan.channel);
+							(u16) chan->channel);
 		if (!cfp) {
 			cfp = mwifiex_get_cfp_by_band_and_channel_from_cfg80211
 								(priv,
 								BAND_A,
-								(u16) bss
-								->param.
-								bss_chan.
+								(u16) chan->
 								channel);
 			if (cfp) {
 				if (adapter->adhoc_11n_enabled)
@@ -1451,17 +1021,14 @@ mwifiex_bss_ioctl_channel(struct mwifiex_adapter *adapter,
 			}
 		}
 	} else {
-		if (bss->param.bss_chan.freq <= MAX_FREQUENCY_BAND_BG)
+		if (chan->freq <= MAX_FREQUENCY_BAND_BG)
 			cfp = mwifiex_get_cfp_by_band_and_freq_from_cfg80211(
-							priv, 0,
-							bss->param.bss_chan.
-							freq);
+							priv, 0, chan->freq);
 		if (!cfp) {
 			cfp = mwifiex_get_cfp_by_band_and_freq_from_cfg80211
 								(priv,
 								BAND_A,
-								bss->param.
-								bss_chan.freq);
+								chan->freq);
 			if (cfp) {
 				if (adapter->adhoc_11n_enabled)
 					adapter->adhoc_start_band =
@@ -1478,8 +1045,8 @@ mwifiex_bss_ioctl_channel(struct mwifiex_adapter *adapter,
 
 	}
 	priv->adhoc_channel = (u8) cfp->channel;
-	bss->param.bss_chan.channel = cfp->channel;
-	bss->param.bss_chan.freq = cfp->freq;
+	chan->channel = cfp->channel;
+	chan->freq = cfp->freq;
 
 	LEAVE();
 	return ret;
@@ -1494,43 +1061,38 @@ mwifiex_bss_ioctl_channel(struct mwifiex_adapter *adapter,
  * In case the mode is changed, a deauthentication is performed
  * first by the function automatically.
  */
-static enum mwifiex_status
-mwifiex_bss_ioctl_mode(struct mwifiex_adapter *adapter,
-		       struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_bss_ioctl_mode(struct mwifiex_private *priv,
+		       struct mwifiex_wait_queue *wait,
+		       u16 action, int *mode)
 {
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_bss *bss = (struct mwifiex_ds_bss *)
-		ioctl_req->buffer;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 
 	ENTER();
 
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
-		bss->param.bss_mode = priv->bss_mode;
-		ioctl_req->data_read_written =
-			sizeof(u32) + MWIFIEX_SUB_COMMAND_SIZE;
+	if (!mode) {
+		ret = MWIFIEX_STATUS_FAILURE;
+		goto exit;
+	}
+	if (action == HostCmd_ACT_GEN_GET) {
+		*mode = priv->bss_mode;
 		goto exit;
 	}
 
-	if ((priv->bss_mode == bss->param.bss_mode) ||
-	    (bss->param.bss_mode == MWIFIEX_BSS_MODE_AUTO)) {
+	if ((priv->bss_mode == *mode) || (*mode == MWIFIEX_BSS_MODE_AUTO)) {
 		PRINTM(MINFO, "Already set to required mode! No change!\n");
-		priv->bss_mode = bss->param.bss_mode;
+		priv->bss_mode = *mode;
 		goto exit;
 	}
 
 
-	ret = mwifiex_deauthenticate(priv, ioctl_req, NULL);
+	ret = mwifiex_deauthenticate(priv, wait, NULL);
 
 	priv->sec_info.authentication_mode = MWIFIEX_AUTH_MODE_OPEN;
-	priv->bss_mode = bss->param.bss_mode;
+	priv->bss_mode = *mode;
 	if (priv->bss_mode != MWIFIEX_BSS_MODE_AUTO) {
-		ret = mwifiex_prepare_cmd(priv,
-				HostCmd_CMD_SET_BSS_MODE,
-				HostCmd_ACT_GEN_SET,
-				0,
-				(void *)ioctl_req,
-				NULL);
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
+					  HostCmd_ACT_GEN_SET, 0, wait, NULL);
 		if (ret == MWIFIEX_STATUS_SUCCESS)
 			ret = MWIFIEX_STATUS_PENDING;
 	}
@@ -1546,19 +1108,22 @@ exit:
  * In both Ad-Hoc and infra mode, an deauthentication is performed
  * first.
  */
-static enum mwifiex_status
-mwifiex_bss_ioctl_start(struct mwifiex_adapter *adapter,
-			struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_bss_ioctl_start(struct mwifiex_private *priv,
+			struct mwifiex_wait_queue *wait,
+			struct mwifiex_ssid_bssid *ssid_bssid)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_bss *bss = (struct mwifiex_ds_bss *)
-		ioctl_req->buffer;
+	struct mwifiex_adapter *adapter = priv->adapter;
 	s32 i = -1;
 
 	ENTER();
 
 	priv->scan_block = false;
+	if (!ssid_bssid) {
+		ret = MWIFIEX_STATUS_FAILURE;
+		goto start_ssid_done;
+	}
 
 	if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
 		/* Infra mode */
@@ -1567,16 +1132,14 @@ mwifiex_bss_ioctl_start(struct mwifiex_adapter *adapter,
 			goto start_ssid_done;
 
 		/* Search for the requested SSID in the scan table */
-		if (bss->param.ssid_bssid.ssid.ssid_len) {
+		if (ssid_bssid->ssid.ssid_len) {
 			i = mwifiex_find_ssid_in_list(priv,
-						      &bss->param.ssid_bssid.
-						      ssid, NULL,
+						      &ssid_bssid->ssid, NULL,
 						      MWIFIEX_BSS_MODE_INFRA);
 		} else {
 			i = mwifiex_find_bssid_in_list(priv,
-						       (u8 *) &bss->param.
-						       ssid_bssid.bssid,
-						       MWIFIEX_BSS_MODE_INFRA);
+						(u8 *) &ssid_bssid->bssid,
+						MWIFIEX_BSS_MODE_INFRA);
 		}
 
 		if (i >= 0) {
@@ -1586,7 +1149,7 @@ mwifiex_bss_ioctl_start(struct mwifiex_adapter *adapter,
 			/* Clear any past association response stored for
 			   application retrieval */
 			priv->assoc_rsp_size = 0;
-			ret = mwifiex_associate(priv, ioctl_req,
+			ret = mwifiex_associate(priv, wait,
 						&adapter->scan_table[i]);
 			if (ret)
 				goto start_ssid_done;
@@ -1597,10 +1160,10 @@ mwifiex_bss_ioctl_start(struct mwifiex_adapter *adapter,
 	} else {
 		/* Adhoc mode */
 		/* If the requested SSID matches current SSID, return */
-		if (bss->param.ssid_bssid.ssid.ssid_len &&
+		if (ssid_bssid->ssid.ssid_len &&
 		    (!mwifiex_ssid_cmp
 		     (&priv->curr_bss_params.bss_descriptor.ssid,
-		      &bss->param.ssid_bssid.ssid))) {
+		      &ssid_bssid->ssid))) {
 			ret = MWIFIEX_STATUS_SUCCESS;
 			goto start_ssid_done;
 		}
@@ -1614,31 +1177,29 @@ mwifiex_bss_ioctl_start(struct mwifiex_adapter *adapter,
 		priv->adhoc_is_link_sensed = false;
 
 		/* Search for the requested network in the scan table */
-		if (bss->param.ssid_bssid.ssid.ssid_len) {
+		if (ssid_bssid->ssid.ssid_len) {
 			i = mwifiex_find_ssid_in_list(priv,
-						      &bss->param.ssid_bssid.
-						      ssid, NULL,
+						      &ssid_bssid->ssid, NULL,
 						      MWIFIEX_BSS_MODE_IBSS);
 		} else {
 			i = mwifiex_find_bssid_in_list(priv,
-						       (u8 *) &bss->param.
-						       ssid_bssid.bssid,
+						       (u8 *)&ssid_bssid->bssid,
 						       MWIFIEX_BSS_MODE_IBSS);
 		}
 
 		if (i >= 0) {
 			PRINTM(MINFO,
 			       "Network found in scan list ... joining ...\n");
-			ret = mwifiex_adhoc_join(priv, ioctl_req,
+			ret = mwifiex_adhoc_join(priv, wait,
 						 &adapter->scan_table[i]);
 			if (ret)
 				goto start_ssid_done;
 		} else {	/* i >= 0 */
 			PRINTM(MINFO, "Network not found in the list, "
 			       "creating adhoc with ssid = %s\n",
-			       bss->param.ssid_bssid.ssid.ssid);
-			ret = mwifiex_adhoc_start(priv, ioctl_req,
-						  &bss->param.ssid_bssid.ssid);
+			       ssid_bssid->ssid.ssid);
+			ret = mwifiex_adhoc_start(priv, wait,
+						  &ssid_bssid->ssid);
 			if (ret)
 				goto start_ssid_done;
 		}
@@ -1655,21 +1216,15 @@ start_ssid_done:
 /*
  * IOCTL request handler to disconnect from a BSS/IBSS.
  */
-static enum mwifiex_status
-mwifiex_bss_ioctl_stop(struct mwifiex_adapter *adapter,
-		       struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_bss_ioctl_stop(struct mwifiex_private *priv,
+		       struct mwifiex_wait_queue *wait,
+		       u8 *mac)
 {
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_bss *bss = (struct mwifiex_ds_bss *)
-		ioctl_req->buffer;
-
 	ENTER();
 
-	ret = mwifiex_deauthenticate(priv, ioctl_req, bss->param.bssid);
-
 	LEAVE();
-	return ret;
+	return mwifiex_deauthenticate(priv, wait, mac);
 }
 
 /*
@@ -1678,36 +1233,27 @@ mwifiex_bss_ioctl_stop(struct mwifiex_adapter *adapter,
  * This function prepares the correct firmware command and
  * issues it to set or get the ad-hoc channel.
  */
-static enum mwifiex_status
-mwifiex_bss_ioctl_ibss_channel(struct mwifiex_adapter *adapter,
-			       struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
+			       struct mwifiex_wait_queue *wait,
+			       u16 action, u16 *channel)
 {
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_bss *bss = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	u16 cmd_action;
 
 	ENTER();
 
-	bss = (struct mwifiex_ds_bss *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
+	if (action == HostCmd_ACT_GEN_GET) {
 		if (!priv->media_connected) {
-			bss->param.bss_chan.channel = priv->adhoc_channel;
+			*channel = priv->adhoc_channel;
 			goto exit;
 		}
-		cmd_action = HostCmd_ACT_GEN_GET;
 	} else {
-		cmd_action = HostCmd_ACT_GEN_SET;
-		priv->adhoc_channel = (u8) bss->param.bss_chan.channel;
+		priv->adhoc_channel = (u8) *channel;
 	}
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_RF_CHANNEL,
-				  cmd_action,
-				  0,
-				  (void *) ioctl_req,
-				  &bss->param.bss_chan.channel);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_RF_CHANNEL,
+				  action, 0, wait, channel);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 
@@ -1717,110 +1263,31 @@ exit:
 }
 
 /*
- * IOCTL request handler to set/get ATIM window interval.
- */
-static enum mwifiex_status
-mwifiex_bss_ioctl_atim_window(struct mwifiex_adapter *adapter,
-			      struct mwifiex_ioctl_req *ioctl_req)
-{
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_bss *bss = NULL;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	ENTER();
-	bss = (struct mwifiex_ds_bss *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
-		bss->param.atim_window = priv->atim_window;
-		if (priv->media_connected)
-			bss->param.atim_window =
-				priv->curr_bss_params.bss_descriptor.
-				atim_window;
-	} else
-		priv->atim_window = (u16) bss->param.atim_window;
-
-	ioctl_req->data_read_written =
-		sizeof(u32) + MWIFIEX_SUB_COMMAND_SIZE;
-	LEAVE();
-	return ret;
-}
-
-/*
- * IOCTL request handler to query passphrase for specified SSID.
- */
-static enum mwifiex_status
-mwifiex_query_passphrase(struct mwifiex_private *priv,
-			 struct mwifiex_ioctl_req *pioctl_req)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_ds_bss *bss = NULL;
-	struct mwifiex_ssid_bssid *ssid_bssid = NULL;
-	struct mwifiex_ds_passphrase sec_pp;
-	int i = 0;
-	struct mwifiex_bssdescriptor *pbss_desc;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-
-	ENTER();
-
-	bss = (struct mwifiex_ds_bss *)pioctl_req->buffer;
-	ssid_bssid = &bss->param.ssid_bssid;
-
-	memset(&sec_pp, 0, sizeof(struct mwifiex_ds_passphrase));
-	sec_pp.psk_type = MWIFIEX_PSK_QUERY;
-	if (ssid_bssid->ssid.ssid_len == 0) {
-		i = mwifiex_find_bssid_in_list(priv, (u8 *)&ssid_bssid->bssid,
-						MWIFIEX_BSS_MODE_AUTO);
-		if (i >= 0) {
-			pbss_desc = &adapter->scan_table[i];
-			memcpy(&sec_pp.ssid, &pbss_desc->ssid,
-				sizeof(struct mwifiex_802_11_ssid));
-		} else {
-			memcpy(&sec_pp.bssid, &ssid_bssid->bssid,
-				MWIFIEX_MAC_ADDR_LENGTH);
-		}
-	} else {
-		memcpy(&sec_pp.ssid, &ssid_bssid->ssid,
-					sizeof(struct mwifiex_802_11_ssid));
-	}
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-			HostCmd_CMD_SUPPLICANT_PMK,
-			HostCmd_ACT_GEN_GET,
-			0,
-			(void *)pioctl_req,
-			&sec_pp);
-
-	LEAVE();
-	return ret;
-}
-
-/*
  * IOCTL request handler to find a particular BSS.
  *
  * The BSS can be searched with either a BSSID or a SSID. If none of
  * these are provided, just the best BSS (best RSSI) is returned.
  */
 enum mwifiex_status
-mwifiex_find_bss(struct mwifiex_private *priv,
-		 struct mwifiex_ioctl_req *ioctl_req)
+mwifiex_bss_ioctl_find_bss(struct mwifiex_private *priv,
+			   struct mwifiex_wait_queue *wait,
+			   struct mwifiex_ssid_bssid *ssid_bssid)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_bss *bss = NULL;
+	struct mwifiex_bssdescriptor *bss_desc;
 	u8 zero_mac[] = { 0, 0, 0, 0, 0, 0 };
 	u8 mac[MWIFIEX_MAC_ADDR_LENGTH];
 	int i = 0;
-	struct mwifiex_bssdescriptor *bss_desc;
-
 
 	ENTER();
 
-	bss = (struct mwifiex_ds_bss *) ioctl_req->buffer;
-	if (memcmp(&bss->param.ssid_bssid.bssid, zero_mac, sizeof(zero_mac))) {
+	if (memcmp(ssid_bssid->bssid, zero_mac, sizeof(zero_mac))) {
 		i = mwifiex_find_bssid_in_list(priv,
-					       (u8 *) &bss->param.ssid_bssid.
-					       bssid, priv->bss_mode);
+					       (u8 *) ssid_bssid->bssid,
+					       priv->bss_mode);
 		if (i < 0) {
-			memcpy(mac, &bss->param.ssid_bssid.bssid, sizeof(mac));
+			memcpy(mac, ssid_bssid->bssid, sizeof(mac));
 			PRINTM(MERROR, "Can not find bssid "
 					"%02x:%02x:%02x:%02x:%02x:%02x\n",
 					mac[0], mac[1], mac[2],
@@ -1829,24 +1296,23 @@ mwifiex_find_bss(struct mwifiex_private *priv,
 			return MWIFIEX_STATUS_FAILURE;
 		}
 		bss_desc = &adapter->scan_table[i];
-		memcpy(&bss->param.ssid_bssid.ssid, &bss_desc->ssid,
+		memcpy(&ssid_bssid->ssid, &bss_desc->ssid,
 				sizeof(struct mwifiex_802_11_ssid));
-	} else if (bss->param.ssid_bssid.ssid.ssid_len) {
+	} else if (ssid_bssid->ssid.ssid_len) {
 		i = mwifiex_find_ssid_in_list(priv,
-					      &bss->param.ssid_bssid.ssid, NULL,
+					      &ssid_bssid->ssid, NULL,
 					      priv->bss_mode);
 		if (i < 0) {
 			PRINTM(MERROR, "Can not find ssid %s\n",
-					bss->param.ssid_bssid.ssid.ssid);
+					ssid_bssid->ssid.ssid);
 			LEAVE();
 			return MWIFIEX_STATUS_FAILURE;
 		}
 		bss_desc = &adapter->scan_table[i];
-		memcpy((u8 *) &bss->param.ssid_bssid.bssid,
-		       (u8 *) &bss_desc->mac_address,
+		memcpy(ssid_bssid->bssid, bss_desc->mac_address,
 		       MWIFIEX_MAC_ADDR_LENGTH);
 	} else {
-		ret = mwifiex_find_best_network(priv, &bss->param.ssid_bssid);
+		ret = mwifiex_find_best_network(priv, ssid_bssid);
 	}
 
 	LEAVE();
@@ -1854,33 +1320,6 @@ mwifiex_find_bss(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to find a particular BSS.
- */
-static enum mwifiex_status
-mwifiex_bss_ioctl_find_bss(struct mwifiex_adapter *adapter,
-			   struct mwifiex_ioctl_req *ioctl_req)
-{
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-
-	ENTER();
-
-	if (priv->ewpa_query) {
-		if (mwifiex_query_passphrase(priv, ioctl_req) ==
-						MWIFIEX_STATUS_SUCCESS) {
-			PRINTM(MINFO, "Find BSS ioctl: query passphrase\n");
-			LEAVE();
-			return MWIFIEX_STATUS_PENDING;
-		}
-	}
-
-	ret = mwifiex_find_bss(priv, ioctl_req);
-
-	LEAVE();
-	return ret;
-}
-
-/*
  * IOCTL request handler to change Ad-Hoc channel.
  *
  * This function allocates the IOCTL request buffer, fills it
@@ -1901,9 +1340,12 @@ int
 mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	struct mwifiex_bss_info bss_info;
-	struct mwifiex_ds_bss *bss = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+	struct mwifiex_ssid_bssid ssid_bssid;
+	u16 curr_chan = 0;
 
 	ENTER();
 
@@ -1911,35 +1353,32 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 
 	/* Get BSS information */
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_get_bss_info(priv, MWIFIEX_IOCTL_WAIT, &bss_info)) {
+	    mwifiex_get_bss_info(priv, &bss_info)) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req == NULL) {
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
 	/* Get current channel */
-	bss = (struct mwifiex_ds_bss *) req->buffer;
-	bss->sub_command = MWIFIEX_OID_IBSS_CHANNEL;
-	req->req_id = MWIFIEX_IOCTL_BSS;
-	req->action = MWIFIEX_ACT_GET;
+	status = mwifiex_bss_ioctl_ibss_channel(priv, wait, HostCmd_ACT_GEN_GET,
+						&curr_chan);
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
-	if (bss->param.bss_chan.channel == channel) {
+	if (curr_chan == channel) {
 		ret = MWIFIEX_STATUS_SUCCESS;
 		goto done;
 	}
-	PRINTM(MCMND, "Updating Channel from %d to %d\n",
-	       (int) bss->param.bss_chan.channel, channel);
+	PRINTM(MCMND, "Updating Channel from %d to %d\n", curr_chan, channel);
 
 	if (!bss_info.media_connected) {
 		ret = MWIFIEX_STATUS_SUCCESS;
@@ -1947,43 +1386,43 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 	}
 
 	/* Do disonnect */
-	bss->sub_command = MWIFIEX_OID_BSS_STOP;
-	memset((u8 *) &bss->param.bssid, 0, ETH_ALEN);
+	memset(&ssid_bssid, 0, MWIFIEX_MAC_ADDR_LENGTH);
+	status = mwifiex_bss_ioctl_stop(priv, wait, ssid_bssid.bssid);
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
-	bss->sub_command = MWIFIEX_OID_IBSS_CHANNEL;
-	req->action = MWIFIEX_ACT_SET;
-	bss->param.bss_chan.channel = channel;
+	status = mwifiex_bss_ioctl_ibss_channel(priv, wait, HostCmd_ACT_GEN_SET,
+						(u16 *) &channel);
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-			mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+		mwifiex_request_ioctl(priv, wait, status, wait_option)) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 
 	/* Do specific SSID scanning */
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_scan(priv, MWIFIEX_IOCTL_WAIT, &bss_info.ssid)) {
+	    mwifiex_request_scan(priv, wait_option, &bss_info.ssid)) {
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto done;
 	}
 	/* Start/Join Adhoc network */
-	bss->sub_command = MWIFIEX_OID_BSS_START;
-	memset(&bss->param.ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
-	memcpy(&bss->param.ssid_bssid.ssid, &bss_info.ssid,
+	memset(&ssid_bssid, 0, sizeof(struct mwifiex_ssid_bssid));
+	memcpy(&ssid_bssid.ssid, &bss_info.ssid,
 	       sizeof(struct mwifiex_802_11_ssid));
 
+	status = mwifiex_bss_ioctl_start(priv, wait, &ssid_bssid);
+
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT))
+		mwifiex_request_ioctl(priv, wait, status, wait_option))
 		ret = MWIFIEX_STATUS_FAILURE;
 
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -1997,138 +1436,29 @@ done:
 int
 mwifiex_drv_get_mode(struct mwifiex_private *priv, u8 wait_option)
 {
-	struct mwifiex_ds_bss *bss = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	int mode = -1;
 	ENTER();
 
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req == NULL) {
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		LEAVE();
 		return MWIFIEX_STATUS_FAILURE;
 	}
 
-	/* Fill request buffer */
-	bss = (struct mwifiex_ds_bss *) req->buffer;
-	bss->sub_command = MWIFIEX_OID_BSS_MODE;
-	req->req_id = MWIFIEX_IOCTL_BSS;
-	req->action = MWIFIEX_ACT_GET;
+	status = mwifiex_bss_ioctl_mode(priv, wait, HostCmd_ACT_GEN_GET, &mode);
 
-	status = mwifiex_request_ioctl(priv, req, wait_option);
-	if (status == MWIFIEX_STATUS_SUCCESS)
-		mode = bss->param.bss_mode;
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 
-	if (req && (status != MWIFIEX_STATUS_PENDING))
-		kfree(req);
+	if (wait && (status != MWIFIEX_STATUS_PENDING))
+		kfree(wait);
 	LEAVE();
 	return mode;
 }
 
 /*
- * IOCTL request handler to set/get BSS parameters.
- *
- * This function is the generic handler and calls other specific handler
- * function based upon the parameters type.
- *
- * Currently, it supports the following BSS parameter set/get requests -
- *      MWIFIEX_OID_BSS_START -          Join with a BSS
- *      MWIFIEX_OID_BSS_STOP  -          Disconnect from a BSS
- *      MWIFIEX_OID_BSS_MODE  -          Set/get BSS mode
- *      MWIFIEX_OID_BSS_CHANNEL -        Set/get BSS channel
- *      MWIFIEX_OID_BSS_CHANNEL_LIST -   Get BSS channel list
- *      MWIFIEX_OID_BSS_MAC_ADDR -       Set/get MAC address
- *      MWIFIEX_OID_BSS_MULTICAST_LIST - Set multicast list
- *      MWIFIEX_OID_BSS_FIND_BSS -       Find a BSS
- *      MWIFIEX_OID_IBSS_ATIM_WINDOW -   Set/get IBSS ATIM window value
- *      MWIFIEX_OID_IBSS_CHANNEL -       Set/get IBSS channel
- */
-static enum mwifiex_status
-mwifiex_bss_ioctl(struct mwifiex_adapter *adapter,
-		  struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_bss *bss = NULL;
-
-	ENTER();
-
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_bss)) {
-		PRINTM(MWARN, "bss IOCTL length is too short.\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed = sizeof(struct mwifiex_ds_bss);
-		LEAVE();
-		return MWIFIEX_STATUS_RESOURCE;
-	}
-
-	bss = (struct mwifiex_ds_bss *) ioctl_req->buffer;
-
-	switch (bss->sub_command) {
-	case MWIFIEX_OID_BSS_START:
-		status = mwifiex_bss_ioctl_start(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_BSS_STOP:
-		status = mwifiex_bss_ioctl_stop(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_BSS_MODE:
-		status = mwifiex_bss_ioctl_mode(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_BSS_CHANNEL:
-		status = mwifiex_bss_ioctl_channel(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_BSS_CHANNEL_LIST:
-		status = mwifiex_bss_ioctl_get_channel_list(adapter,
-							    ioctl_req);
-		break;
-	case MWIFIEX_OID_BSS_MAC_ADDR:
-		status = mwifiex_bss_ioctl_mac_address(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_BSS_MULTICAST_LIST:
-		status = mwifiex_bss_ioctl_set_multicast_list(adapter,
-							      ioctl_req);
-		break;
-	case MWIFIEX_OID_BSS_FIND_BSS:
-		status = mwifiex_bss_ioctl_find_bss(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_IBSS_ATIM_WINDOW:
-		status = mwifiex_bss_ioctl_atim_window(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_IBSS_CHANNEL:
-		status = mwifiex_bss_ioctl_ibss_channel(adapter, ioctl_req);
-		break;
-	default:
-		status = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-
-	LEAVE();
-	return status;
-}
-
-/*
- * IOCTL request handler to get supported rates.
- */
-static enum mwifiex_status
-mwifiex_rate_ioctl_get_supported_rate(struct mwifiex_adapter *adapter,
-				      struct mwifiex_ioctl_req *ioctl_req)
-{
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_rate *rate = NULL;
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	ENTER();
-	if (ioctl_req->action != MWIFIEX_ACT_GET) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-	rate = (struct mwifiex_ds_rate *) ioctl_req->buffer;
-	mwifiex_get_active_data_rates(priv, rate->param.rates);
-	ioctl_req->data_read_written =
-		IW_MAX_BITRATES + MWIFIEX_SUB_COMMAND_SIZE;
-	LEAVE();
-	return ret;
-}
-
-/*
  * IOCTL request handler to get rate.
  *
  * This function prepares the correct firmware command and
@@ -2137,30 +1467,26 @@ mwifiex_rate_ioctl_get_supported_rate(struct mwifiex_adapter *adapter,
  * for the band.
  */
 static enum mwifiex_status
-mwifiex_rate_ioctl_get_rate_value(struct mwifiex_adapter *adapter,
-				  struct mwifiex_ioctl_req *ioctl_req)
+mwifiex_rate_ioctl_get_rate_value(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait,
+				  struct mwifiex_rate_cfg *rate_cfg)
 {
-	struct mwifiex_ds_rate *rate = NULL;
+	struct mwifiex_adapter *adapter = priv->adapter;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
 
 	ENTER();
 
-	rate = (struct mwifiex_ds_rate *) ioctl_req->buffer;
-	rate->param.rate_cfg.is_rate_auto = priv->is_data_rate_auto;
-	ioctl_req->data_read_written =
-		sizeof(struct mwifiex_rate_cfg) + MWIFIEX_SUB_COMMAND_SIZE;
-
+	rate_cfg->is_rate_auto = priv->is_data_rate_auto;
 	if (!priv->media_connected) {
 		switch (adapter->config_bands) {
 		case BAND_B:
 			/* Return the lowest supported rate for B band */
-			rate->param.rate_cfg.rate = supported_rates_b[0] & 0x7f;
+			rate_cfg->rate = supported_rates_b[0] & 0x7f;
 			break;
 		case BAND_G:
 		case BAND_G | BAND_GN:
 			/* Return the lowest supported rate for G band */
-			rate->param.rate_cfg.rate = supported_rates_g[0] & 0x7f;
+			rate_cfg->rate = supported_rates_g[0] & 0x7f;
 			break;
 		case BAND_B | BAND_G:
 		case BAND_A | BAND_B | BAND_G:
@@ -2168,19 +1494,18 @@ mwifiex_rate_ioctl_get_rate_value(struct mwifiex_adapter *adapter,
 		case BAND_A | BAND_B | BAND_G | BAND_AN | BAND_GN:
 		case BAND_B | BAND_G | BAND_GN:
 			/* Return the lowest supported rate for BG band */
-			rate->param.rate_cfg.rate = supported_rates_bg[0] &
-				0x7f;
+			rate_cfg->rate = supported_rates_bg[0] & 0x7f;
 			break;
 		case BAND_A:
 		case BAND_A | BAND_G:
 		case BAND_A | BAND_G | BAND_AN | BAND_GN:
 		case BAND_A | BAND_AN:
 			/* Return the lowest supported rate for A band */
-			rate->param.rate_cfg.rate = supported_rates_a[0] & 0x7f;
+			rate_cfg->rate = supported_rates_a[0] & 0x7f;
 			break;
 		case BAND_GN:
 			/* Return the lowest supported rate for N band */
-			rate->param.rate_cfg.rate = supported_rates_n[0] & 0x7f;
+			rate_cfg->rate = supported_rates_n[0] & 0x7f;
 			break;
 		default:
 			PRINTM(MMSG, "Invalid Band 0x%x\n",
@@ -2191,8 +1516,7 @@ mwifiex_rate_ioctl_get_rate_value(struct mwifiex_adapter *adapter,
 		/* Send request to firmware */
 		ret = mwifiex_prepare_cmd(priv,
 					  HostCmd_CMD_802_11_TX_RATE_QUERY,
-					  HostCmd_ACT_GEN_GET,
-					  0, (void *) ioctl_req, NULL);
+					  HostCmd_ACT_GEN_GET, 0, wait, NULL);
 		if (ret == MWIFIEX_STATUS_SUCCESS)
 			ret = MWIFIEX_STATUS_PENDING;
 	}
@@ -2210,23 +1534,21 @@ mwifiex_rate_ioctl_get_rate_value(struct mwifiex_adapter *adapter,
  * The function also performs validation checking on the supplied value.
  */
 static enum mwifiex_status
-mwifiex_rate_ioctl_set_rate_value(struct mwifiex_adapter *adapter,
-				  struct mwifiex_ioctl_req *ioctl_req)
+mwifiex_rate_ioctl_set_rate_value(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait,
+				  struct mwifiex_rate_cfg *rate_cfg)
 {
-	struct mwifiex_ds_rate *ds_rate = NULL;
 	u8 rates[MWIFIEX_SUPPORTED_RATES];
 	u8 *rate = NULL;
 	int rate_index = 0;
 	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
 	u32 i = 0;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
+	struct mwifiex_adapter *adapter = priv->adapter;
 
 	ENTER();
 
-	ds_rate = (struct mwifiex_ds_rate *) ioctl_req->buffer;
-
-	if (ds_rate->param.rate_cfg.is_rate_auto) {
+	if (rate_cfg->is_rate_auto) {
 		memset(bitmap_rates, 0, sizeof(bitmap_rates));
 		/* Support all HR/DSSS rates */
 		bitmap_rates[0] = 0x000F;
@@ -2242,23 +1564,20 @@ mwifiex_rate_ioctl_set_rate_value(struct mwifiex_adapter *adapter,
 		rate = rates;
 		for (i = 0; (rate[i] && i < MWIFIEX_SUPPORTED_RATES); i++) {
 			PRINTM(MINFO, "Rate=0x%X  Wanted=0x%X\n", rate[i],
-			       ds_rate->param.rate_cfg.rate);
-			if ((rate[i] & 0x7f) ==
-			    (ds_rate->param.rate_cfg.rate & 0x7f))
+			       rate_cfg->rate);
+			if ((rate[i] & 0x7f) == (rate_cfg->rate & 0x7f))
 				break;
 		}
 		if (!rate[i] || (i == MWIFIEX_SUPPORTED_RATES)) {
 			PRINTM(MERROR, "The fixed data rate 0x%X is out "
-			       "of range\n", ds_rate->param.rate_cfg.rate);
+			       "of range\n", rate_cfg->rate);
 			ret = MWIFIEX_STATUS_FAILURE;
 			goto exit;
 		}
 		memset(bitmap_rates, 0, sizeof(bitmap_rates));
 
 		rate_index =
-			mwifiex_data_rate_to_index(adapter,
-						   ds_rate->param.rate_cfg.
-						   rate);
+			mwifiex_data_rate_to_index(adapter, rate_cfg->rate);
 
 		/* Only allow b/g rates to be set */
 		if (rate_index >= MWIFIEX_RATE_INDEX_HRDSSS0 &&
@@ -2275,10 +1594,8 @@ mwifiex_rate_ioctl_set_rate_value(struct mwifiex_adapter *adapter,
 	}
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_TX_RATE_CFG,
-				  HostCmd_ACT_GEN_SET,
-				  0, (void *) ioctl_req, bitmap_rates);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
+				  HostCmd_ACT_GEN_SET, 0, wait, bitmap_rates);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 
@@ -2294,19 +1611,17 @@ exit:
  * issues it to get the data rate index.
  */
 static enum mwifiex_status
-mwifiex_rate_ioctl_get_rate_index(struct mwifiex_adapter *adapter,
-				  struct mwifiex_ioctl_req *ioctl_req)
+mwifiex_rate_ioctl_get_rate_index(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait,
+				  struct mwifiex_rate_cfg *rate_cfg)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
 
 	ENTER();
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_TX_RATE_CFG,
-				  HostCmd_ACT_GEN_GET,
-				  0, (void *) ioctl_req, NULL);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
+				  HostCmd_ACT_GEN_GET, 0, wait, rate_cfg);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 
@@ -2321,21 +1636,19 @@ mwifiex_rate_ioctl_get_rate_index(struct mwifiex_adapter *adapter,
  * issues it to set the data rate index.
  */
 static enum mwifiex_status
-mwifiex_rate_ioctl_set_rate_index(struct mwifiex_adapter *adapter,
-				  struct mwifiex_ioctl_req *ioctl_req)
+mwifiex_rate_ioctl_set_rate_index(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait,
+				  struct mwifiex_rate_cfg *rate_cfg)
 {
 	int rate_index;
 	u32 i;
-	struct mwifiex_ds_rate *ds_rate = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
 	u16 bitmap_rates[MAX_BITMAP_RATES_SIZE];
 
 	ENTER();
 
-	ds_rate = (struct mwifiex_ds_rate *) ioctl_req->buffer;
-	rate_index = ds_rate->param.rate_cfg.rate;
-	if (ds_rate->param.rate_cfg.is_rate_auto) {
+	rate_index = rate_cfg->rate;
+	if (rate_cfg->is_rate_auto) {
 		memset(bitmap_rates, 0, sizeof(bitmap_rates));
 		/* Support all HR/DSSS rates */
 		bitmap_rates[0] = 0x000F;
@@ -2376,11 +1689,8 @@ mwifiex_rate_ioctl_set_rate_index(struct mwifiex_adapter *adapter,
 	       priv->is_data_rate_auto, priv->data_rate);
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_TX_RATE_CFG,
-				  HostCmd_ACT_GEN_SET,
-				  0, (void *) ioctl_req,
-				  (void *) bitmap_rates);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TX_RATE_CFG,
+				  HostCmd_ACT_GEN_SET, 0, wait, bitmap_rates);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 
@@ -2394,30 +1704,33 @@ mwifiex_rate_ioctl_set_rate_index(struct mwifiex_adapter *adapter,
  * This function can be used to set/get either the rate value or the
  * rate index.
  */
-static enum mwifiex_status
-mwifiex_rate_ioctl_cfg(struct mwifiex_adapter *adapter,
-		       struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_rate_ioctl_cfg(struct mwifiex_private *priv,
+		       struct mwifiex_wait_queue *wait,
+		       struct mwifiex_rate_cfg *rate_cfg)
 {
-	struct mwifiex_ds_rate *rate = NULL;
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 
 	ENTER();
 
-	rate = (struct mwifiex_ds_rate *) ioctl_req->buffer;
-	if (rate->param.rate_cfg.rate_type == MWIFIEX_RATE_VALUE) {
-		if (ioctl_req->action == MWIFIEX_ACT_GET)
-			status = mwifiex_rate_ioctl_get_rate_value(adapter,
-								   ioctl_req);
+	if (!rate_cfg) {
+		LEAVE();
+		return MWIFIEX_STATUS_FAILURE;
+	}
+	if (rate_cfg->rate_type == MWIFIEX_RATE_VALUE) {
+		if (rate_cfg->action == HostCmd_ACT_GEN_GET)
+			status = mwifiex_rate_ioctl_get_rate_value(
+					priv, wait, rate_cfg);
 		else
-			status = mwifiex_rate_ioctl_set_rate_value(adapter,
-								   ioctl_req);
+			status = mwifiex_rate_ioctl_set_rate_value(
+					priv, wait, rate_cfg);
 	} else {
-		if (ioctl_req->action == MWIFIEX_ACT_GET)
-			status = mwifiex_rate_ioctl_get_rate_index(adapter,
-								   ioctl_req);
+		if (rate_cfg->action == HostCmd_ACT_GEN_GET)
+			status = mwifiex_rate_ioctl_get_rate_index(
+					priv, wait, rate_cfg);
 		else
-			status = mwifiex_rate_ioctl_set_rate_index(adapter,
-								   ioctl_req);
+			status = mwifiex_rate_ioctl_set_rate_index(
+					priv, wait, rate_cfg);
 	}
 
 	LEAVE();
@@ -2425,114 +1738,6 @@ mwifiex_rate_ioctl_cfg(struct mwifiex_adapter *adapter,
 }
 
 /*
- * IOCTL request handler to get data rate.
- *
- * This function prepares the correct firmware command and
- * issues it to get the data rate.
- */
-static enum mwifiex_status
-mwifiex_rate_ioctl_get_data_rate(struct mwifiex_adapter *adapter,
-				 struct mwifiex_ioctl_req *ioctl_req)
-{
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-
-	ENTER();
-
-	if (ioctl_req->action != MWIFIEX_ACT_GET) {
-		ret = MWIFIEX_STATUS_FAILURE;
-		goto exit;
-	}
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_TX_RATE_QUERY,
-				  HostCmd_ACT_GEN_GET,
-				  0, (void *) ioctl_req, NULL);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
-
-exit:
-	LEAVE();
-	return ret;
-}
-
-/*
- * IOCTL request handler to set/get rate parameters.
- *
- * This function is the generic handler and calls other specific handler
- * function based upon the parameters type.
- *
- * Currently, it supports the following rate parameter set/get requests -
- *      MWIFIEX_OID_RATE_CFG -        Set/get rate configuration
- *      MWIFIEX_OID_GET_DATA_RATE -   Get data rate
- *      MWIFIEX_OID_SUPPORTED_RATES - Get supported rates
- */
-static enum mwifiex_status
-mwifiex_rate_ioctl(struct mwifiex_adapter *adapter,
-		   struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_rate *rate = NULL;
-
-	ENTER();
-
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_rate)) {
-		PRINTM(MWARN, "IOCTL length is too short.\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed = sizeof(struct mwifiex_ds_rate);
-		LEAVE();
-		return MWIFIEX_STATUS_RESOURCE;
-	}
-	rate = (struct mwifiex_ds_rate *) ioctl_req->buffer;
-	switch (rate->sub_command) {
-	case MWIFIEX_OID_RATE_CFG:
-		status = mwifiex_rate_ioctl_cfg(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_GET_DATA_RATE:
-		status = mwifiex_rate_ioctl_get_data_rate(adapter,
-							  ioctl_req);
-		break;
-	case MWIFIEX_OID_SUPPORTED_RATES:
-		status = mwifiex_rate_ioctl_get_supported_rate(adapter,
-							       ioctl_req);
-		break;
-	default:
-		status = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-	LEAVE();
-	return status;
-}
-
-/*
- * IOCTL request handler to get tx power configuration.
- *
- * This function prepares the correct firmware command and
- * issues it.
- */
-static enum mwifiex_status
-mwifiex_power_ioctl_get_power(struct mwifiex_adapter *adapter,
-			      struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-
-	ENTER();
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_TXPWR_CFG,
-				  HostCmd_ACT_GEN_GET,
-				  0, (void *) ioctl_req, NULL);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
-
-	LEAVE();
-	return ret;
-}
-
-/*
  * IOCTL request handler to set tx power configuration.
  *
  * This function prepares the correct firmware command and
@@ -2544,24 +1749,22 @@ mwifiex_power_ioctl_get_power(struct mwifiex_adapter *adapter,
  *      - Modulation class HTBW20
  *      - Modulation class HTBW40
  */
-static enum mwifiex_status
-mwifiex_power_ioctl_set_power(struct mwifiex_adapter *adapter,
-			      struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_power_ioctl_set_power(struct mwifiex_private *priv,
+			      struct mwifiex_wait_queue *wait,
+			      struct mwifiex_power_cfg *power_cfg)
 {
-	struct mwifiex_ds_power_cfg *power = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
 	struct host_cmd_ds_txpwr_cfg *txp_cfg = NULL;
 	struct mwifiex_types_power_group *pg_tlv = NULL;
 	struct mwifiex_power_group *pg = NULL;
 	u8 *buf = NULL;
 	u16 dbm = 0;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
 
 	ENTER();
 
-	power = (struct mwifiex_ds_power_cfg *) ioctl_req->buffer;
-	if (!power->param.power_cfg.is_power_auto) {
-		dbm = (u16) power->param.power_cfg.power_level;
+	if (!power_cfg->is_power_auto) {
+		dbm = (u16) power_cfg->power_level;
 		if ((dbm < priv->min_tx_power_level) ||
 		    (dbm > priv->max_tx_power_level)) {
 			PRINTM(MERROR, "The set txpower value %d dBm is out of "
@@ -2581,7 +1784,7 @@ mwifiex_power_ioctl_set_power(struct mwifiex_adapter *adapter,
 
 	txp_cfg = (struct host_cmd_ds_txpwr_cfg *) buf;
 	txp_cfg->action = cpu_to_le16(HostCmd_ACT_GEN_SET);
-	if (!power->param.power_cfg.is_power_auto) {
+	if (!power_cfg->is_power_auto) {
 		txp_cfg->mode = cpu_to_le32(1);
 		pg_tlv = (struct mwifiex_types_power_group *) (buf +
 				sizeof
@@ -2630,10 +1833,8 @@ mwifiex_power_ioctl_set_power(struct mwifiex_adapter *adapter,
 		pg->ht_bandwidth = HT_BW_40;
 	}
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_TXPWR_CFG,
-				  HostCmd_ACT_GEN_SET, 0, (void *) ioctl_req,
-				  buf);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_TXPWR_CFG,
+				  HostCmd_ACT_GEN_SET, 0, wait, buf);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 	kfree(buf);
@@ -2644,72 +1845,31 @@ exit:
 }
 
 /*
- * IOCTL request handler to set/get power related parameters.
- *
- * This function is the generic handler and calls other specific handler
- * function based upon the parameters type.
- *
- * Currently, it supports the following power related parameter set/get
- * requests -
- *      MWIFIEX_OID_POWER_CFG - Set/get power configuration
- */
-static enum mwifiex_status
-mwifiex_power_ioctl(struct mwifiex_adapter *adapter,
-		    struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_power_cfg *power = NULL;
-
-	ENTER();
-
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_power_cfg)) {
-		PRINTM(MWARN, "IOCTL length is too short.\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed =
-			sizeof(struct mwifiex_ds_power_cfg);
-		LEAVE();
-		return MWIFIEX_STATUS_RESOURCE;
-	}
-	power = (struct mwifiex_ds_power_cfg *) ioctl_req->buffer;
-	switch (power->sub_command) {
-	case MWIFIEX_OID_POWER_CFG:
-		if (ioctl_req->action == MWIFIEX_ACT_GET)
-			status = mwifiex_power_ioctl_get_power(adapter,
-							       ioctl_req);
-		else
-			status = mwifiex_power_ioctl_set_power(adapter,
-							       ioctl_req);
-		break;
-	default:
-		status = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-	LEAVE();
-	return status;
-}
-
-/*
  * IOCTL request handler to get power save mode.
  *
  * This function prepares the correct firmware command and
  * issues it.
  */
-static enum mwifiex_status
-mwifiex_pm_ioctl_ps_mode(struct mwifiex_adapter *adapter,
-			 struct mwifiex_ioctl_req *ioctl_req, u16 ps_mode)
+enum mwifiex_status
+mwifiex_pm_ioctl_ps_mode(struct mwifiex_private *priv,
+			 struct mwifiex_wait_queue *wait,
+			 u32 *ps_mode,
+			 u16 action)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
+	struct mwifiex_adapter *adapter = priv->adapter;
 	u16 sub_cmd;
 
 	ENTER();
 
-	if (ioctl_req->action == MWIFIEX_ACT_SET) {
-		sub_cmd = (adapter->ps_mode == MWIFIEX_802_11_POWER_MODE_PSP) ?
-						EN_AUTO_PS : DIS_AUTO_PS;
+	if (action == HostCmd_ACT_GEN_SET) {
+		if (*ps_mode)
+			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
+		else
+			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
+		sub_cmd = (*ps_mode) ? EN_AUTO_PS : DIS_AUTO_PS;
 		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
-				sub_cmd, BITMAP_STA_PS, (void *) ioctl_req,
-				NULL);
+					  sub_cmd, BITMAP_STA_PS, wait, NULL);
 		if ((ret == MWIFIEX_STATUS_SUCCESS) &&
 						(sub_cmd == DIS_AUTO_PS)) {
 			ret = mwifiex_prepare_cmd(priv,
@@ -2717,9 +1877,8 @@ mwifiex_pm_ioctl_ps_mode(struct mwifiex_adapter *adapter,
 					0, NULL, NULL);
 		}
 	} else {
-		ret = mwifiex_prepare_cmd(priv,
-				HostCmd_CMD_802_11_PS_MODE_ENH, GET_PS,
-				0, (void *)ioctl_req, NULL);
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH,
+					  GET_PS, 0, wait, NULL);
 	}
 
 	if (ret == MWIFIEX_STATUS_SUCCESS)
@@ -2735,30 +1894,27 @@ mwifiex_pm_ioctl_ps_mode(struct mwifiex_adapter *adapter,
  * This function prepares the correct firmware command and
  * issues it.
  */
-static enum mwifiex_status
-mwifiex_pm_ioctl_hs_cfg(struct mwifiex_adapter *adapter,
-		    struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_pm_ioctl_hs_cfg(struct mwifiex_private *priv,
+			struct mwifiex_wait_queue *wait,
+			u16 action, struct mwifiex_ds_hs_cfg *hs_cfg)
 {
-	struct mwifiex_private    *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_pm_cfg  *pm = NULL;
-	enum mwifiex_status     status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	u32 prev_cond = 0;
 
 	ENTER();
 
-	pm = (struct mwifiex_ds_pm_cfg *)ioctl_req->buffer;
-
-	switch (ioctl_req->action) {
-	case MWIFIEX_ACT_SET:
+	switch (action) {
+	case HostCmd_ACT_GEN_SET:
 		if (adapter->pps_uapsd_mode) {
 			PRINTM(MINFO, "Host Sleep IOCTL is blocked in UAPSD/PPS"
 				      " mode\n");
 			status = MWIFIEX_STATUS_FAILURE;
 			break;
 		}
-		if (pm->param.hs_cfg.is_invoke_hostcmd) {
-			if (pm->param.hs_cfg.conditions ==
-							HOST_SLEEP_CFG_CANCEL) {
+		if (hs_cfg->is_invoke_hostcmd) {
+			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL) {
 				if (!adapter->is_hs_configured) {
 					/* Already cancelled */
 					break;
@@ -2767,17 +1923,15 @@ mwifiex_pm_ioctl_hs_cfg(struct mwifiex_adapter *adapter,
 				prev_cond = le32_to_cpu(adapter->hs_cfg
 							.conditions);
 				adapter->hs_cfg.conditions =
-						cpu_to_le32(
-						pm->param.hs_cfg.conditions);
-			} else if (pm->param.hs_cfg.conditions) {
+						cpu_to_le32(hs_cfg->conditions);
+			} else if (hs_cfg->conditions) {
 				adapter->hs_cfg.conditions =
 						cpu_to_le32(
-						pm->param.hs_cfg.conditions);
+						hs_cfg->conditions);
 				adapter->hs_cfg.gpio =
-						(u8)pm->param.hs_cfg.gpio;
-				if (pm->param.hs_cfg.gap)
-					adapter->hs_cfg.gap = (u8)pm->param
-						.hs_cfg.gap;
+						(u8)hs_cfg->gpio;
+				if (hs_cfg->gap)
+					adapter->hs_cfg.gap = (u8)hs_cfg->gap;
 			} else if (adapter->hs_cfg.conditions ==
 						cpu_to_le32(
 						HOST_SLEEP_CFG_CANCEL)) {
@@ -2789,28 +1943,25 @@ mwifiex_pm_ioctl_hs_cfg(struct mwifiex_adapter *adapter,
 			status = mwifiex_prepare_cmd(priv,
 					HostCmd_CMD_802_11_HS_CFG_ENH,
 					HostCmd_ACT_GEN_SET,
-					0, (void *)ioctl_req,
-					(void *)(&adapter->hs_cfg));
+					0, wait, &adapter->hs_cfg);
 			if (status == MWIFIEX_STATUS_SUCCESS)
 				status = MWIFIEX_STATUS_PENDING;
-			if (pm->param.hs_cfg.conditions ==
-						HOST_SLEEP_CFG_CANCEL) {
+			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL) {
 				/* Restore previous condition */
 				adapter->hs_cfg.conditions =
-							cpu_to_le32(prev_cond);
+						cpu_to_le32(prev_cond);
 			}
 		} else {
 			adapter->hs_cfg.conditions =
-				cpu_to_le32(pm->param.hs_cfg.conditions);
-			adapter->hs_cfg.gpio = (u8)pm->param.hs_cfg.gpio;
-			adapter->hs_cfg.gap = (u8)pm->param.hs_cfg.gap;
+				cpu_to_le32(hs_cfg->conditions);
+			adapter->hs_cfg.gpio = (u8)hs_cfg->gpio;
+			adapter->hs_cfg.gap = (u8)hs_cfg->gap;
 		}
 		break;
-	case MWIFIEX_ACT_GET:
-		pm->param.hs_cfg.conditions =
-					le32_to_cpu(adapter->hs_cfg.conditions);
-		pm->param.hs_cfg.gpio = adapter->hs_cfg.gpio;
-		pm->param.hs_cfg.gap = adapter->hs_cfg.gap;
+	case HostCmd_ACT_GEN_GET:
+		hs_cfg->conditions = le32_to_cpu(adapter->hs_cfg.conditions);
+		hs_cfg->gpio = adapter->hs_cfg.gpio;
+		hs_cfg->gap = adapter->hs_cfg.gap;
 		break;
 	default:
 		status = MWIFIEX_STATUS_FAILURE;
@@ -2822,49 +1973,64 @@ mwifiex_pm_ioctl_hs_cfg(struct mwifiex_adapter *adapter,
 }
 
 /*
- * IOCTL request handler to set auto deep sleep mode.
+ * IOCTL request handler to set/get auto deep sleep mode.
  *
  * This function prepares the correct firmware command and
  * issues it.
  */
-static enum mwifiex_status
-mwifiex_set_auto_deep_sleep(struct mwifiex_adapter *adapter,
-			    struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_pm_ioctl_deep_sleep(struct mwifiex_private *priv,
+			    struct mwifiex_wait_queue *wait,
+			    struct mwifiex_ds_auto_ds *auto_deep_sleep,
+			    u16 action)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_auto_ds auto_ds;
+	struct mwifiex_adapter *adapter = priv->adapter;
 	u32 mode;
 
 	ENTER();
 
-	if (((struct mwifiex_ds_pm_cfg *) ioctl_req->buffer)->param.
-	    auto_deep_sleep.auto_ds == DEEP_SLEEP_ON) {
-		auto_ds.auto_ds = DEEP_SLEEP_ON;
+	if (action == HostCmd_ACT_GEN_GET) {
+		if (adapter->is_deep_sleep)
+			auto_deep_sleep->auto_ds = DEEP_SLEEP_ON;
+		else
+			auto_deep_sleep->auto_ds = DEEP_SLEEP_OFF;
+		LEAVE();
+		return ret;
+	}
+
+	if (adapter->is_deep_sleep && auto_deep_sleep->auto_ds ==
+	    DEEP_SLEEP_ON) {
+		PRINTM(MMSG, "Station already in enhanced deep"
+				" sleep mode\n");
+		LEAVE();
+		return MWIFIEX_STATUS_FAILURE;
+	} else if (!adapter->is_deep_sleep && auto_deep_sleep->auto_ds ==
+		   DEEP_SLEEP_OFF) {
+		PRINTM(MMSG, "Station already not in enhanced "
+				"deep sleep mode\n");
+		LEAVE();
+		return MWIFIEX_STATUS_FAILURE;
+	}
+
+	if (auto_deep_sleep->auto_ds == DEEP_SLEEP_ON) {
+		auto_deep_sleep->auto_ds = DEEP_SLEEP_ON;
 		PRINTM(MINFO, "Auto Deep Sleep: on\n");
 		mode = EN_AUTO_PS;
 	} else {
-		auto_ds.auto_ds = DEEP_SLEEP_OFF;
+		auto_deep_sleep->auto_ds = DEEP_SLEEP_OFF;
 		PRINTM(MINFO, "AutoAUTO_DEEP_SLEEP Deep Sleep: off\n");
 		mode = DIS_AUTO_PS;
 	}
-	auto_ds.idle_time =
-		((struct mwifiex_ds_pm_cfg *) ioctl_req->buffer)->param.
-		auto_deep_sleep.idle_time;
 
 	/* note: the command could be queued and executed later if there is
 	   command in progress. */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_PS_MODE_ENH,
-				  mode, BITMAP_AUTO_DS, (void *) ioctl_req,
-				  &auto_ds);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_PS_MODE_ENH, mode,
+				  BITMAP_AUTO_DS, wait, auto_deep_sleep);
+
+	if (ret == MWIFIEX_STATUS_SUCCESS)
+		ret = MWIFIEX_STATUS_PENDING;
 
-	if (ret) {
-		LEAVE();
-		return ret;
-	}
-	ret = MWIFIEX_STATUS_PENDING;
 	LEAVE();
 	return ret;
 }
@@ -2875,25 +2041,17 @@ mwifiex_set_auto_deep_sleep(struct mwifiex_adapter *adapter,
  * This function prepares the correct firmware command and
  * issues it.
  */
-static enum mwifiex_status
-mwifiex_set_get_sleep_pd(struct mwifiex_adapter *adapter,
-			 struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_pm_ioctl_sleep_pd(struct mwifiex_private *priv,
+			 struct mwifiex_wait_queue *wait,
+			 u32 *sleep_period, u16 action)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_pm_cfg *pm_cfg = NULL;
-	u16 cmd_action = 0;
 
 	ENTER();
 
-	pm_cfg = (struct mwifiex_ds_pm_cfg *) ioctl_req->buffer;
-	cmd_action = HostCmd_ACT_GEN_GET;
-	if (ioctl_req->action == MWIFIEX_ACT_SET)
-		cmd_action = HostCmd_ACT_GEN_SET;
-
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_SLEEP_PERIOD,
-				  cmd_action, 0, (void *) ioctl_req,
-				  &pm_cfg->param.sleep_period);
+				  action, 0, wait, sleep_period);
 
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
@@ -2903,212 +2061,6 @@ mwifiex_set_get_sleep_pd(struct mwifiex_adapter *adapter,
 }
 
 /*
- * IOCTL request handler to set/get power management parameters.
- *
- * This function is the generic handler and calls other specific handler
- * function based upon the parameters type.
- *
- * Currently, it supports the following power management parameter set/get
- * requests -
- *      MWIFIEX_OID_PM_CFG_IEEE_PS - Set/get IEEE power save mode
- *      MWIFIEX_OID_PM_CFG_HS_CFG - Set/get Host Sleep configurations
- *      MWIFIEX_OID_PM_CFG_DEEP_SLEEP - Set/get deep sleep configurations
- *      MWIFIEX_OID_PM_CFG_SLEEP_PD - Set/get sleep PD
- */
-static enum mwifiex_status
-mwifiex_pm_ioctl(struct mwifiex_adapter *adapter,
-		 struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_pm_cfg *pm = NULL;
-
-	ENTER();
-
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_pm_cfg)) {
-		PRINTM(MWARN, "IOCTL length is too short.\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed = sizeof(struct mwifiex_ds_pm_cfg);
-		LEAVE();
-		return MWIFIEX_STATUS_RESOURCE;
-	}
-	pm = (struct mwifiex_ds_pm_cfg *) ioctl_req->buffer;
-	switch (pm->sub_command) {
-	case MWIFIEX_OID_PM_CFG_IEEE_PS:
-		switch (ioctl_req->action) {
-		case MWIFIEX_ACT_SET:
-			if (pm->param.ps_mode)
-				adapter->ps_mode =
-					MWIFIEX_802_11_POWER_MODE_PSP;
-			else
-				adapter->ps_mode =
-					MWIFIEX_802_11_POWER_MODE_CAM;
-			status = mwifiex_pm_ioctl_ps_mode(adapter, ioctl_req,
-							  adapter->ps_mode);
-			break;
-		case MWIFIEX_ACT_GET:
-			status = mwifiex_pm_ioctl_ps_mode(adapter, ioctl_req,
-							  adapter->ps_mode);
-			break;
-		default:
-			status = MWIFIEX_STATUS_FAILURE;
-			break;
-		}
-		break;
-	case MWIFIEX_OID_PM_CFG_HS_CFG:
-		status = mwifiex_pm_ioctl_hs_cfg(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_PM_CFG_DEEP_SLEEP:
-		switch (ioctl_req->action) {
-		case MWIFIEX_ACT_SET:
-			if (adapter->is_deep_sleep &&
-			    pm->param.auto_deep_sleep.auto_ds ==
-			    DEEP_SLEEP_ON) {
-				PRINTM(MMSG, "Station already in enhanced deep"
-						" sleep mode\n");
-				status = MWIFIEX_STATUS_FAILURE;
-				break;
-			} else if (!adapter->is_deep_sleep &&
-				   pm->param.auto_deep_sleep.auto_ds ==
-				   DEEP_SLEEP_OFF) {
-				PRINTM(MMSG, "Station already not in enhanced "
-						"deep sleep mode\n");
-				status = MWIFIEX_STATUS_FAILURE;
-				break;
-			}
-			status = mwifiex_set_auto_deep_sleep(adapter,
-							     ioctl_req);
-			break;
-		case MWIFIEX_ACT_GET:
-			if (adapter->is_deep_sleep)
-				pm->param.auto_deep_sleep.auto_ds =
-					DEEP_SLEEP_ON;
-			else
-				pm->param.auto_deep_sleep.auto_ds =
-					DEEP_SLEEP_OFF;
-			break;
-		default:
-			status = MWIFIEX_STATUS_FAILURE;
-			break;
-		}
-		break;
-	case MWIFIEX_OID_PM_CFG_SLEEP_PD:
-		status = mwifiex_set_get_sleep_pd(adapter, ioctl_req);
-		break;
-	default:
-		status = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-	LEAVE();
-	return status;
-}
-
-/*
- * IOCTL request handler to set/get WMM QoS configuration.
- */
-static enum mwifiex_status
-mwifiex_wmm_ioctl_qos(struct mwifiex_adapter *adapter,
-		      struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_wmm_cfg *wmm = NULL;
-
-	ENTER();
-
-	wmm = (struct mwifiex_ds_wmm_cfg *) ioctl_req->buffer;
-
-	if (ioctl_req->action == MWIFIEX_ACT_GET)
-		wmm->param.qos_cfg = priv->wmm_qosinfo;
-	else
-		priv->wmm_qosinfo = wmm->param.qos_cfg;
-
-	ioctl_req->data_read_written = sizeof(u8) + MWIFIEX_SUB_COMMAND_SIZE;
-
-	LEAVE();
-	return ret;
-}
-
-/*
- * IOCTL request handler to get WMM queue status.
- */
-static enum mwifiex_status
-mwifiex_wmm_ioctl_queue_status(struct mwifiex_adapter *adapter,
-			       struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_wmm_cfg *cfg = NULL;
-	struct mwifiex_ds_wmm_queue_status *q_status = NULL;
-	struct mwifiex_wmm_ac_status *ac_status = NULL;
-	enum mwifiex_wmm_ac_e ac_idx;
-
-	ENTER();
-
-	cfg = (struct mwifiex_ds_wmm_cfg *) ioctl_req->buffer;
-	q_status = (struct mwifiex_ds_wmm_queue_status *) &cfg->param.q_status;
-
-	for (ac_idx = WMM_AC_BK; ac_idx <= WMM_AC_VO; ac_idx++) {
-		ac_status = &priv->wmm.ac_status[ac_idx];
-
-		/* Firmware status */
-		q_status->ac_status[ac_idx].flow_required =
-			ac_status->flow_required;
-		q_status->ac_status[ac_idx].flow_created =
-			ac_status->flow_created;
-		q_status->ac_status[ac_idx].disabled = ac_status->disabled;
-
-		/* ACM bit reflected in firmware status (redundant) */
-		q_status->ac_status[ac_idx].wmm_acm = ac_status->flow_required;
-	}
-
-	LEAVE();
-	return ret;
-}
-
-/*
- * IOCTL request handler to set/get WMM configuration parameters.
- *
- * This function is the generic handler and calls other specific handler
- * function based upon the parameters type.
- *
- * Currently, it supports the following WMM configuration parameter set/get
- * requests -
- *      MWIFIEX_OID_WMM_CFG_QOS - Set/get WMM QoS parameters
- *      MWIFIEX_OID_WMM_CFG_QUEUE_STATUS - Get WMM queue status
- */
-static enum mwifiex_status
-mwifiex_wmm_cfg_ioctl(struct mwifiex_adapter *adapter,
-		      struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_wmm_cfg *wmm = NULL;
-
-	ENTER();
-
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_wmm_cfg)) {
-		PRINTM(MWARN, "IOCTL length is too short.\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed = sizeof(struct mwifiex_ds_wmm_cfg);
-		LEAVE();
-		return MWIFIEX_STATUS_RESOURCE;
-	}
-	wmm = (struct mwifiex_ds_wmm_cfg *) ioctl_req->buffer;
-	switch (wmm->sub_command) {
-	case MWIFIEX_OID_WMM_CFG_QOS:
-		status = mwifiex_wmm_ioctl_qos(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_WMM_CFG_QUEUE_STATUS:
-		status = mwifiex_wmm_ioctl_queue_status(adapter, ioctl_req);
-		break;
-	default:
-		status = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-	LEAVE();
-	return status;
-}
-
-/*
  * IOCTL request handler to set/reset WPA IE.
  *
  * The supplied WPA IE is treated as a opaque buffer. Only the first field
@@ -3191,36 +2143,6 @@ mwifiex_set_wapi_ie(struct mwifiex_private *priv, u8 *ie_data_ptr,
 }
 
 /*
- * IOCTL request handler to disable WAPI or get current WAPI status.
- *
- * This function cannot be used to enable WAPI, for that the WAPI IE
- * must be provided using the appropriate IOCTL.
- */
-static enum mwifiex_status
-mwifiex_sec_ioctl_wapi_enable(struct mwifiex_adapter *adapter,
-			      struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_sec_cfg *sec = NULL;
-	ENTER();
-	sec = (struct mwifiex_ds_sec_cfg *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
-		if (priv->wapi_ie_len)
-			sec->param.wapi_enabled = true;
-		else
-			sec->param.wapi_enabled = false;
-	} else {
-		if (!sec->param.wapi_enabled)
-			mwifiex_set_wapi_ie(priv, NULL, 0);
-	}
-	ioctl_req->data_read_written =
-		sizeof(u32) + MWIFIEX_SUB_COMMAND_SIZE;
-	LEAVE();
-	return ret;
-}
-
-/*
  * IOCTL request handler to set WAPI key.
  *
  * This function prepares the correct firmware command and
@@ -3228,19 +2150,16 @@ mwifiex_sec_ioctl_wapi_enable(struct mwifiex_adapter *adapter,
  */
 static enum mwifiex_status
 mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
-			       struct mwifiex_ioctl_req *ioctl_req)
+			       struct mwifiex_wait_queue *wait,
+			       struct mwifiex_ds_encrypt_key *encrypt_key)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_sec_cfg *sec = NULL;
+	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	ENTER();
 
-	sec = (struct mwifiex_ds_sec_cfg *) ioctl_req->buffer;
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_KEY_MATERIAL,
-				  HostCmd_ACT_GEN_SET,
-				  KEY_INFO_ENABLED,
-				  (void *) ioctl_req, &sec->param.encrypt_key);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+				  HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
+				  wait, encrypt_key);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 
@@ -3251,78 +2170,17 @@ mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
 /*
  * IOCTL request handler to set/get authentication mode.
  */
-static enum mwifiex_status
-mwifiex_sec_ioctl_auth_mode(struct mwifiex_adapter *adapter,
-			    struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_set_auth_mode(struct mwifiex_private *priv, u32 auth_mode)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_sec_cfg *sec = NULL;
 	ENTER();
-	sec = (struct mwifiex_ds_sec_cfg *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_GET)
-		sec->param.auth_mode = priv->sec_info.authentication_mode;
-	else {
-		priv->sec_info.authentication_mode = sec->param.auth_mode;
-		if (priv->sec_info.authentication_mode ==
-		    MWIFIEX_AUTH_MODE_NETWORKEAP)
-			mwifiex_set_wpa_ie_helper(priv, NULL, 0);
-	}
-	ioctl_req->data_read_written =
-		sizeof(u32) + MWIFIEX_SUB_COMMAND_SIZE;
-	LEAVE();
-	return ret;
-}
 
-/*
- * IOCTL request handler to set/get encryption mode.
- */
-static enum mwifiex_status
-mwifiex_sec_ioctl_encrypt_mode(struct mwifiex_adapter *adapter,
-			       struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_sec_cfg *sec = NULL;
-	ENTER();
-	sec = (struct mwifiex_ds_sec_cfg *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_GET)
-		sec->param.encrypt_mode = priv->sec_info.encryption_mode;
-	else
-		priv->sec_info.encryption_mode = sec->param.encrypt_mode;
+	priv->sec_info.authentication_mode = auth_mode;
+	if (priv->sec_info.authentication_mode ==
+			MWIFIEX_AUTH_MODE_NETWORKEAP)
+		ret = mwifiex_set_wpa_ie_helper(priv, NULL, 0);
 
-	ioctl_req->data_read_written =
-		sizeof(u32) + MWIFIEX_SUB_COMMAND_SIZE;
-	LEAVE();
-	return ret;
-}
-
-/*
- * IOCTL request handler to disable WPA or get current WPA status.
- *
- * This function cannot be used to enable WPA, for that the WPA IE
- * must be provided using the appropriate IOCTL.
- */
-static enum mwifiex_status
-mwifiex_sec_ioctl_wpa_enable(struct mwifiex_adapter *adapter,
-			     struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_sec_cfg *sec = NULL;
-	ENTER();
-	sec = (struct mwifiex_ds_sec_cfg *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
-		if (priv->wpa_ie_len)
-			sec->param.wpa_enabled = true;
-		else
-			sec->param.wpa_enabled = false;
-	} else {
-		if (!sec->param.wpa_enabled)
-			mwifiex_set_wpa_ie_helper(priv, NULL, 0);
-	}
-	ioctl_req->data_read_written =
-		sizeof(u32) + MWIFIEX_SUB_COMMAND_SIZE;
 	LEAVE();
 	return ret;
 }
@@ -3335,11 +2193,11 @@ mwifiex_sec_ioctl_wpa_enable(struct mwifiex_adapter *adapter,
  */
 static enum mwifiex_status
 mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
-			      struct mwifiex_ioctl_req *ioctl_req)
+			      struct mwifiex_wait_queue *wait,
+			      struct mwifiex_ds_encrypt_key *encrypt_key)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_sec_cfg *sec = NULL;
+	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	struct mwifiex_wep_key *wep_key = NULL;
 	int index;
 
@@ -3348,14 +2206,13 @@ mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 	if (priv->wep_key_curr_index >= NUM_WEP_KEYS)
 		priv->wep_key_curr_index = 0;
 	wep_key = &priv->wep_key[priv->wep_key_curr_index];
-	sec = (struct mwifiex_ds_sec_cfg *) ioctl_req->buffer;
-	if (sec->param.encrypt_key.is_current_wep_key)
+	if (encrypt_key->is_current_wep_key)
 		index = priv->wep_key_curr_index;
 	else
-		index = sec->param.encrypt_key.key_index;
-	if (sec->param.encrypt_key.key_disable) {
+		index = encrypt_key->key_index;
+	if (encrypt_key->key_disable) {
 		priv->sec_info.wep_status = MWIFIEX_802_11_WEP_DISABLED;
-	} else if (!sec->param.encrypt_key.key_len) {
+	} else if (!encrypt_key->key_len) {
 		/* Copy the required key as the current key */
 		wep_key = &priv->wep_key[index];
 		if (!wep_key->key_length) {
@@ -3371,10 +2228,10 @@ mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 		memset(wep_key, 0, sizeof(struct mwifiex_wep_key));
 		/* Copy the key in the driver */
 		memcpy(wep_key->key_material,
-		       sec->param.encrypt_key.key_material,
-		       sec->param.encrypt_key.key_len);
+		       encrypt_key->key_material,
+		       encrypt_key->key_len);
 		wep_key->key_index = index;
-		wep_key->key_length = sec->param.encrypt_key.key_len;
+		wep_key->key_length = encrypt_key->key_len;
 		if (priv->sec_info.wep_status != MWIFIEX_802_11_WEP_ENABLED) {
 			/*
 			 * The status is set as Key Absent
@@ -3399,10 +2256,8 @@ mwifiex_sec_ioctl_set_wep_key(struct mwifiex_adapter *adapter,
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_WEP_ENABLE;
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_MAC_CONTROL,
-				  HostCmd_ACT_GEN_SET,
-				  0, (void *) ioctl_req,
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_MAC_CONTROL,
+				  HostCmd_ACT_GEN_SET, 0, wait,
 				  &priv->curr_pkt_filter);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
@@ -3424,19 +2279,18 @@ exit:
  */
 static enum mwifiex_status
 mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
-			      struct mwifiex_ioctl_req *ioctl_req)
+			      struct mwifiex_wait_queue *wait,
+			      struct mwifiex_ds_encrypt_key *encrypt_key)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_sec_cfg *sec = NULL;
+	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	u8 remove_key = false;
 	struct host_cmd_ds_802_11_key_material *ibss_key;
 
 	ENTER();
 
-	sec = (struct mwifiex_ds_sec_cfg *) ioctl_req->buffer;
 	/* Current driver only supports key length of up to 32 bytes */
-	if (sec->param.encrypt_key.key_len > MWIFIEX_MAX_KEY_LENGTH) {
+	if (encrypt_key->key_len > MWIFIEX_MAX_KEY_LENGTH) {
 		PRINTM(MERROR, " Error in key length\n");
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto exit;
@@ -3448,12 +2302,12 @@ mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 		 * and sending unicast and multicast packets.
 		 */
 		/* Send the key as PTK to firmware */
-		sec->param.encrypt_key.key_index = MWIFIEX_KEY_INDEX_UNICAST;
+		encrypt_key->key_index = MWIFIEX_KEY_INDEX_UNICAST;
 		ret = mwifiex_prepare_cmd(priv,
 					  HostCmd_CMD_802_11_KEY_MATERIAL,
 					  HostCmd_ACT_GEN_SET,
 					  KEY_INFO_ENABLED,
-					  NULL, &sec->param.encrypt_key);
+					  NULL, encrypt_key);
 		if (ret)
 			goto exit;
 
@@ -3462,10 +2316,10 @@ mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 		       sizeof(struct host_cmd_ds_802_11_key_material));
 		/* Copy the key in the driver */
 		memcpy(ibss_key->key_param_set.key,
-		       sec->param.encrypt_key.key_material,
-		       sec->param.encrypt_key.key_len);
+		       encrypt_key->key_material,
+		       encrypt_key->key_len);
 		memcpy(&ibss_key->key_param_set.key_len,
-		       &sec->param.encrypt_key.key_len,
+		       &encrypt_key->key_len,
 		       sizeof(ibss_key->key_param_set.key_len));
 		ibss_key->key_param_set.key_type_id
 			= cpu_to_le16(KEY_TYPE_ID_TKIP);
@@ -3473,28 +2327,23 @@ mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 			= cpu_to_le16(KEY_INFO_TKIP_ENABLED);
 
 		/* Send the key as GTK to firmware */
-		sec->param.encrypt_key.key_index = ~MWIFIEX_KEY_INDEX_UNICAST;
+		encrypt_key->key_index = ~MWIFIEX_KEY_INDEX_UNICAST;
 	}
 
-	if (!sec->param.encrypt_key.key_index)
-		sec->param.encrypt_key.key_index = MWIFIEX_KEY_INDEX_UNICAST;
+	if (!encrypt_key->key_index)
+		encrypt_key->key_index = MWIFIEX_KEY_INDEX_UNICAST;
 
 	if (remove_key) {
 		/* Send request to firmware */
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_802_11_KEY_MATERIAL,
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
 					  HostCmd_ACT_GEN_SET,
 					  !(KEY_INFO_ENABLED),
-					  (void *) ioctl_req,
-					  &sec->param.encrypt_key);
+					  wait, encrypt_key);
 	} else {
 		/* Send request to firmware */
-		ret = mwifiex_prepare_cmd(priv,
-					  HostCmd_CMD_802_11_KEY_MATERIAL,
-					  HostCmd_ACT_GEN_SET,
-					  KEY_INFO_ENABLED,
-					  (void *) ioctl_req,
-					  &sec->param.encrypt_key);
+		ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_KEY_MATERIAL,
+					  HostCmd_ACT_GEN_SET, KEY_INFO_ENABLED,
+					  wait, encrypt_key);
 	}
 
 	if (ret == MWIFIEX_STATUS_SUCCESS)
@@ -3512,16 +2361,14 @@ exit:
  */
 static enum mwifiex_status
 mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
-			  struct mwifiex_ioctl_req *ioctl_req)
+			  struct mwifiex_wait_queue *wait,
+			  struct mwifiex_ds_encrypt_key *encrypt_key)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_sec_cfg *sec = NULL;
+	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	int index;
 	ENTER();
 
-	sec = (struct mwifiex_ds_sec_cfg *) ioctl_req->buffer;
-
 	if (priv->wep_key_curr_index >= NUM_WEP_KEYS)
 		priv->wep_key_curr_index = 0;
 
@@ -3529,57 +2376,57 @@ mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 	    || (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_KEY_ABSENT)
 	    || priv->sec_info.ewpa_enabled
 	    || priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled) {
-		sec->param.encrypt_key.key_disable = false;
+		encrypt_key->key_disable = false;
 	} else {
-		sec->param.encrypt_key.key_disable = true;
+		encrypt_key->key_disable = true;
 	}
 
-	if (sec->param.encrypt_key.is_current_wep_key) {
+	if (encrypt_key->is_current_wep_key) {
 		if ((priv->wep_key[priv->wep_key_curr_index].key_length) &&
 		    (priv->sec_info.wep_status ==
 		     MWIFIEX_802_11_WEP_ENABLED)) {
 			index = priv->wep_key_curr_index;
-			sec->param.encrypt_key.key_index =
+			encrypt_key->key_index =
 				priv->wep_key[index].key_index;
-			memcpy(sec->param.encrypt_key.key_material,
+			memcpy(encrypt_key->key_material,
 			       priv->wep_key[index].key_material,
 			       priv->wep_key[index].key_length);
-			sec->param.encrypt_key.key_len =
+			encrypt_key->key_len =
 				priv->wep_key[index].key_length;
 		} else if ((priv->sec_info.wpa_enabled)
 			   || (priv->sec_info.ewpa_enabled)
 			   || (priv->sec_info.wpa2_enabled)
 			) {
 			/* Return WPA enabled */
-			sec->param.encrypt_key.key_disable = false;
-			memcpy(sec->param.encrypt_key.key_material,
+			encrypt_key->key_disable = false;
+			memcpy(encrypt_key->key_material,
 			       priv->aes_key.key_param_set.key,
 			       le16_to_cpu(
 			       priv->aes_key.key_param_set.key_len));
-			sec->param.encrypt_key.key_len =
+			encrypt_key->key_len =
 				le16_to_cpu(
 				priv->aes_key.key_param_set.key_len);
 		} else {
-			sec->param.encrypt_key.key_disable = true;
+			encrypt_key->key_disable = true;
 		}
 	} else {
-		index = sec->param.encrypt_key.key_index;
+		index = encrypt_key->key_index;
 		if (priv->wep_key[index].key_length) {
-			sec->param.encrypt_key.key_index =
+			encrypt_key->key_index =
 				priv->wep_key[index].key_index;
-			memcpy(sec->param.encrypt_key.key_material,
+			memcpy(encrypt_key->key_material,
 			       priv->wep_key[index].key_material,
 			       priv->wep_key[index].key_length);
-			sec->param.encrypt_key.key_len =
+			encrypt_key->key_len =
 				priv->wep_key[index].key_length;
 		} else if ((priv->sec_info.wpa_enabled)
 			   || (priv->sec_info.ewpa_enabled)
 			   || (priv->sec_info.wpa2_enabled)
 			) {
 			/* Return WPA enabled */
-			sec->param.encrypt_key.key_disable = false;
+			encrypt_key->key_disable = false;
 		} else {
-			sec->param.encrypt_key.key_disable = true;
+			encrypt_key->key_disable = true;
 		}
 	}
 
@@ -3593,26 +2440,28 @@ mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
  * This is a generic key handling function which supports WEP, WPA
  * and WAPI.
  */
-static enum mwifiex_status
-mwifiex_sec_ioctl_encrypt_key(struct mwifiex_adapter *adapter,
-			      struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
+			      struct mwifiex_wait_queue *wait,
+			      struct mwifiex_ds_encrypt_key *encrypt_key,
+			      u16 action)
 {
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_sec_cfg *sec = NULL;
+	struct mwifiex_adapter *adapter = priv->adapter;
+
 	ENTER();
-	sec = (struct mwifiex_ds_sec_cfg *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_SET) {
-		if (sec->param.encrypt_key.is_wapi_key)
+	if (action == HostCmd_ACT_GEN_SET) {
+		if (encrypt_key->is_wapi_key)
 			status = mwifiex_sec_ioctl_set_wapi_key(adapter,
-								ioctl_req);
-		else if (sec->param.encrypt_key.key_len > WLAN_KEY_LEN_WEP104)
+							wait, encrypt_key);
+		else if (encrypt_key->key_len > WLAN_KEY_LEN_WEP104)
 			status = mwifiex_sec_ioctl_set_wpa_key(adapter,
-							       ioctl_req);
+							wait, encrypt_key);
 		else
 			status = mwifiex_sec_ioctl_set_wep_key(adapter,
-							       ioctl_req);
+							wait, encrypt_key);
 	} else {
-		status = mwifiex_sec_ioctl_get_key(adapter, ioctl_req);
+		status = mwifiex_sec_ioctl_get_key(adapter, wait, encrypt_key);
 	}
 	LEAVE();
 	return status;
@@ -3624,47 +2473,44 @@ mwifiex_sec_ioctl_encrypt_key(struct mwifiex_adapter *adapter,
  * This function prepares corresponding firmware command and
  * issues it.
  */
-static enum mwifiex_status
-mwifiex_sec_ioctl_passphrase(struct mwifiex_adapter *adapter,
-			     struct mwifiex_ioctl_req  *pioctl_req)
+enum mwifiex_status
+mwifiex_sec_ioctl_passphrase(struct mwifiex_private *priv,
+			     struct mwifiex_wait_queue *wait,
+			     struct mwifiex_ds_passphrase *passphrase,
+			     u16 action)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private    *priv =
-					adapter->priv[pioctl_req->bss_index];
-	struct mwifiex_ds_sec_cfg *sec = NULL;
-	u16 cmd_action = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bssdescriptor *pbss_desc;
+	u16 cmd_action = 0;
 	int i = 0;
 
 	ENTER();
 
-	sec = (struct mwifiex_ds_sec_cfg *)pioctl_req->buffer;
-	if (pioctl_req->action == MWIFIEX_ACT_SET) {
-		if (sec->param.passphrase.psk_type == MWIFIEX_PSK_CLEAR)
+	if (action == HostCmd_ACT_GEN_SET) {
+		if (passphrase->psk_type == MWIFIEX_PSK_CLEAR)
 			cmd_action = HostCmd_ACT_GEN_REMOVE;
 		else
 			cmd_action = HostCmd_ACT_GEN_SET;
 	} else {
-		if (sec->param.passphrase.psk_type == MWIFIEX_PSK_QUERY) {
-			if (sec->param.passphrase.ssid.ssid_len == 0) {
+		if (passphrase->psk_type == MWIFIEX_PSK_QUERY) {
+			if (passphrase->ssid.ssid_len == 0) {
 				i = mwifiex_find_bssid_in_list(priv,
-						(u8 *)&sec->param
-						.passphrase.bssid,
+						passphrase->bssid,
 						MWIFIEX_BSS_MODE_AUTO);
 				if (i >= 0) {
 					pbss_desc = &adapter->scan_table[i];
-					memcpy(&sec->param.passphrase.ssid,
+					memcpy(&passphrase->ssid,
 					&pbss_desc->ssid,
 					sizeof(struct mwifiex_802_11_ssid));
-					memset(&sec->param.passphrase.bssid, 0,
+					memset(passphrase->bssid, 0,
 					MWIFIEX_MAC_ADDR_LENGTH);
 					PRINTM(MINFO, "PSK_QUERY: found ssid="
 						      "%s\n",
-						      sec->param.passphrase
-						      .ssid.ssid);
+						      passphrase->ssid.ssid);
 				}
 			} else {
-				memset(&sec->param.passphrase.bssid, 0,
+				memset(passphrase->bssid, 0,
 					MWIFIEX_MAC_ADDR_LENGTH);
 			}
 		}
@@ -3672,12 +2518,8 @@ mwifiex_sec_ioctl_passphrase(struct mwifiex_adapter *adapter,
 	}
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-			HostCmd_CMD_SUPPLICANT_PMK,
-			cmd_action,
-			0,
-			(void *)pioctl_req,
-			&sec->param.passphrase);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SUPPLICANT_PMK, cmd_action,
+				  0, wait, passphrase);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 
@@ -3686,42 +2528,17 @@ mwifiex_sec_ioctl_passphrase(struct mwifiex_adapter *adapter,
 }
 
 /*
- * IOCTL request handler to set/get eWPA mode.
- */
-static enum mwifiex_status
-mwifiex_sec_ioctl_ewpa_enable(struct mwifiex_adapter *adapter,
-			      struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_sec_cfg *sec = NULL;
-	ENTER();
-	sec = (struct mwifiex_ds_sec_cfg *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
-		sec->param.ewpa_enabled = priv->sec_info.ewpa_enabled;
-	} else {
-		priv->sec_info.ewpa_enabled = (u8) sec->param.ewpa_enabled;
-		PRINTM(MCMND, "Set: ewpa_enabled = %d\n",
-		       (int) priv->sec_info.ewpa_enabled);
-	}
-	ioctl_req->data_read_written =
-		sizeof(u32) + MWIFIEX_SUB_COMMAND_SIZE;
-	LEAVE();
-	return ret;
-}
-
-/*
  * IOCTL request handler to get esupplicant mode.
  *
  * This function prepares corresponding firmware command and
  * issues it.
  */
-static enum mwifiex_status
-mwifiex_sec_ioctl_esupp_mode(struct mwifiex_adapter *adapter,
-			     struct mwifiex_ioctl_req *pioctl_req)
+enum mwifiex_status
+mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *priv,
+			     struct mwifiex_wait_queue *wait,
+			     struct mwifiex_ds_esupp_mode *esupp_mode)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[pioctl_req->bss_index];
 
 	ENTER();
 
@@ -3731,12 +2548,9 @@ mwifiex_sec_ioctl_esupp_mode(struct mwifiex_adapter *adapter,
 	}
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-			HostCmd_CMD_SUPPLICANT_PROFILE,
-			HostCmd_ACT_GEN_GET_CURRENT,
-			0,
-			(void *)pioctl_req,
-			NULL);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SUPPLICANT_PROFILE,
+				  HostCmd_ACT_GEN_GET_CURRENT, 0,
+				  wait, esupp_mode);
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
 
@@ -3746,71 +2560,6 @@ exit:
 }
 
 /*
- * IOCTL request handler to set/get security parameters.
- *
- * This function is the generic handler and calls other specific handler
- * function based upon the parameters type.
- *
- * Currently, it supports the following security parameter set/get
- * requests -
- *      MWIFIEX_OID_SEC_CFG_AUTH_MODE -    Set/get authentication mode
- *      MWIFIEX_OID_SEC_CFG_ENCRYPT_MODE - Set/get encryption mode
- *      MWIFIEX_OID_SEC_CFG_WPA_ENABLED -  Enable/disable WPA
- *      MWIFIEX_OID_SEC_CFG_WAPI_ENABLED - Enable/disable WAPI
- *      MWIFIEX_OID_SEC_CFG_ENCRYPT_KEY -  Set/get encryption key
- *      MWIFIEX_OID_SEC_CFG_EWPA_ENABLED - Enable/disable eWPA
- */
-static enum mwifiex_status
-mwifiex_sec_cfg_ioctl(struct mwifiex_adapter *adapter,
-		      struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_sec_cfg *sec = NULL;
-
-	ENTER();
-
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_sec_cfg)) {
-		PRINTM(MWARN, "IOCTL length is too short.\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed = sizeof(struct mwifiex_ds_sec_cfg);
-		LEAVE();
-		return MWIFIEX_STATUS_RESOURCE;
-	}
-	sec = (struct mwifiex_ds_sec_cfg *) ioctl_req->buffer;
-	switch (sec->sub_command) {
-	case MWIFIEX_OID_SEC_CFG_AUTH_MODE:
-		status = mwifiex_sec_ioctl_auth_mode(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_SEC_CFG_ENCRYPT_MODE:
-		status = mwifiex_sec_ioctl_encrypt_mode(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_SEC_CFG_WPA_ENABLED:
-		status = mwifiex_sec_ioctl_wpa_enable(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_SEC_CFG_WAPI_ENABLED:
-		status = mwifiex_sec_ioctl_wapi_enable(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_SEC_CFG_ENCRYPT_KEY:
-		status = mwifiex_sec_ioctl_encrypt_key(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_SEC_CFG_PASSPHRASE:
-		status = mwifiex_sec_ioctl_passphrase(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_SEC_CFG_EWPA_ENABLED:
-		status = mwifiex_sec_ioctl_ewpa_enable(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_SEC_CFG_ESUPP_MODE:
-		status = mwifiex_sec_ioctl_esupp_mode(adapter, ioctl_req);
-		break;
-	default:
-		status = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-	LEAVE();
-	return status;
-}
-
-/*
  * Sends IOCTL request to set deep sleep parameters.
  *
  * This function allocates the IOCTL request buffer, fills it
@@ -3824,45 +2573,38 @@ mwifiex_drv_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
 			   bool bdeep_sleep, u16 idle_time)
 {
 	int ret = 0;
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_pm_cfg *pm = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_auto_ds auto_deep_sleep;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_pm_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		LEAVE();
 		return -ENOMEM;
 	}
-	pm = (struct mwifiex_ds_pm_cfg *) req->buffer;
-	pm->sub_command = MWIFIEX_OID_PM_CFG_DEEP_SLEEP;
-	req->req_id = MWIFIEX_IOCTL_PM_CFG;
 
-	req->action = MWIFIEX_ACT_SET;
 	if (bdeep_sleep) {
 		PRINTM(MCMND, "Deep Sleep: sleep\n");
-		pm->param.auto_deep_sleep.auto_ds = DEEP_SLEEP_ON;
+		auto_deep_sleep.auto_ds = DEEP_SLEEP_ON;
 		if (idle_time)
-			pm->param.auto_deep_sleep.idle_time = idle_time;
-
-		if (MWIFIEX_STATUS_SUCCESS !=
-		    mwifiex_request_ioctl(priv, req, wait_option)) {
-			ret = -EFAULT;
-			goto done;
-		}
+			auto_deep_sleep.idle_time = idle_time;
 	} else {
 		PRINTM(MCMND, "%lu : Deep Sleep: wakeup\n", jiffies);
-		pm->param.auto_deep_sleep.auto_ds = DEEP_SLEEP_OFF;
+		auto_deep_sleep.auto_ds = DEEP_SLEEP_OFF;
+	}
+	status = mwifiex_pm_ioctl_deep_sleep(priv, wait, &auto_deep_sleep,
+					     HostCmd_ACT_GEN_SET);
 
-		if (MWIFIEX_STATUS_SUCCESS !=
-		    mwifiex_request_ioctl(priv, req, wait_option)) {
-			ret = -EFAULT;
-			goto done;
-		}
+	if (MWIFIEX_STATUS_SUCCESS !=
+	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
+		ret = -EFAULT;
+		goto done;
 	}
 
 done:
-	kfree(req);
+	kfree(wait);
 
 	LEAVE();
 	return ret;
@@ -3878,30 +2620,30 @@ int
 mwifiex_drv_get_deep_sleep(struct mwifiex_private *priv, u32 *deep_sleep)
 {
 	int ret = 0;
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_pm_cfg *pm = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_auto_ds auto_deep_sleep;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_pm_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		LEAVE();
 		return -ENOMEM;
 	}
-	pm = (struct mwifiex_ds_pm_cfg *) req->buffer;
-	pm->sub_command = MWIFIEX_OID_PM_CFG_DEEP_SLEEP;
-	req->req_id = MWIFIEX_IOCTL_PM_CFG;
 
-	req->action = MWIFIEX_ACT_GET;
+	status = mwifiex_pm_ioctl_deep_sleep(priv, wait, &auto_deep_sleep,
+					     HostCmd_ACT_GEN_GET);
+
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+	    mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
 		ret = -EFAULT;
 		goto done;
 	}
-	*deep_sleep = pm->param.auto_deep_sleep.auto_ds;
+	*deep_sleep = auto_deep_sleep.auto_ds;
 
 done:
-	kfree(req);
+	kfree(wait);
 
 	LEAVE();
 	return ret;
@@ -3919,16 +2661,13 @@ mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 {
 	int ret = 0;
 	struct mwifiex_ds_hs_cfg hscfg;
-	struct mwifiex_bss_info bss_info;
 
 	ENTER();
 
-	memset(&hscfg, 0, sizeof(struct mwifiex_ds_hs_cfg));
+	memset(&hscfg, 0, sizeof(struct mwifiex_hs_config_param));
 
 	/* HS config is blocked if HS is already activated */
-	memset(&bss_info, 0, sizeof(bss_info));
-	mwifiex_get_bss_info(priv, MWIFIEX_IOCTL_WAIT, &bss_info);
-	if (bss_info.is_hs_configured) {
+	if (priv->adapter->is_hs_configured) {
 		PRINTM(MERROR, "HS already configured\n");
 		ret = -EFAULT;
 		goto done;
@@ -3938,10 +2677,9 @@ mwifiex_set_hs_cfg(struct mwifiex_private *priv, int cond, int gap,
 	if (data_length >= 2)
 		hscfg.gap = gap;
 	hscfg.gpio = HOST_SLEEP_CFG_GPIO_DEF;
-
 	hscfg.is_invoke_hostcmd = invoke_hostcmd;
 	if (MWIFIEX_STATUS_SUCCESS !=
-			mwifiex_set_get_hs_params(priv, MWIFIEX_ACT_SET,
+			mwifiex_set_get_hs_params(priv, HostCmd_ACT_GEN_SET,
 						  MWIFIEX_IOCTL_WAIT,
 						  &hscfg)) {
 		ret = -EFAULT;
@@ -3962,32 +2700,32 @@ int
 mwifiex_11n_get_amsdu_params(struct mwifiex_private *priv, int *amsdu_enable,
 			     int *curr_buf_size)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	int ret = 0;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_CFG_AMSDU_AGGR_CTRL;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_GET;
+	status = mwifiex_11n_ioctl_amsdu_aggr_ctrl(priv->adapter, wait,
+						   &amsdu_aggr_ctrl,
+						   HostCmd_ACT_GEN_GET);
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 
 	if (!ret) {
-		*amsdu_enable = cfg_11n->param.amsdu_aggr_ctrl.enable;
-		*curr_buf_size = cfg_11n->param.amsdu_aggr_ctrl.curr_buf_size;
+		*amsdu_enable = amsdu_aggr_ctrl.enable;
+		*curr_buf_size = amsdu_aggr_ctrl.curr_buf_size;
 	}
 
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 
 	return ret;
@@ -4002,26 +2740,26 @@ done:
 int
 mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	int ret = 0;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_CFG_AMSDU_AGGR_CTRL;
-	cfg_11n->param.amsdu_aggr_ctrl.enable = amsdu_enable;
+	amsdu_aggr_ctrl.enable = amsdu_enable;
 
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_SET;
+	status = mwifiex_11n_ioctl_amsdu_aggr_ctrl(priv->adapter, wait,
+						   &amsdu_aggr_ctrl,
+						   HostCmd_ACT_GEN_SET);
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 
 	if (ret)
 		PRINTM(MERROR, "Failed enabling amsdu aggregation feature\n");
@@ -4029,7 +2767,7 @@ mwifiex_11n_amsdu_aggr_ctrl(struct mwifiex_private *priv, int amsdu_enable)
 		PRINTM(MINFO,
 		       "Successfully enabled amsdu aggregation feature\n");
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -4043,30 +2781,20 @@ done:
 int
 mwifiex_set_drv_txbuf_cfg(struct mwifiex_private *priv, int max_tx_buf_size)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
-	int ret = 0;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (req == NULL) {
-		ret = -ENOMEM;
-		goto done;
+	if ((max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_2K) ||
+	    (max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_4K) ||
+	    (max_tx_buf_size == MWIFIEX_TX_DATA_BUF_SIZE_8K)) {
+		priv->adapter->max_tx_buf_size = (u16) max_tx_buf_size;
+	} else {
+		status = MWIFIEX_STATUS_FAILURE;
 	}
 
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_CFG_MAX_TX_BUF_SIZE;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_SET;
-	cfg_11n->param.tx_buf_size = max_tx_buf_size;
-
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
-
-done:
-	kfree(req);
 	LEAVE();
-	return ret;
+	return status;
 }
 
 /*
@@ -4078,33 +2806,12 @@ done:
 int
 mwifiex_get_drv_txbuf_cfg(struct mwifiex_private *priv, int *max_tx_buf_size)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
-	int ret = 0;
-
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (req == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_CFG_MAX_TX_BUF_SIZE;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_GET;
-
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
-	if (ret)
-		goto done;
-
-	*max_tx_buf_size = cfg_11n->param.tx_buf_size;
+	*max_tx_buf_size = (u32) priv->adapter->max_tx_buf_size;
 
-done:
-	kfree(req);
 	LEAVE();
-	return ret;
+	return 0;
 }
 
 /*
@@ -4116,31 +2823,27 @@ done:
 int
 mwifiex_get_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
+	struct mwifiex_ds_11n_aggr_prio_tbl aggr_prio_tbl;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	int ret = 0, i, j;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (req == NULL) {
-		LEAVE();
-		return -ENOMEM;
+	status = mwifiex_11n_ioctl_aggr_prio_tbl(priv, &aggr_prio_tbl,
+						 HostCmd_ACT_GEN_GET);
+
+	if (status) {
+		ret = -EFAULT;
+		goto done;
 	}
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_CFG_AGGR_PRIO_TBL;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_GET;
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
 
 	for (i = 0, j = 0; i < (MAX_NUM_TID * 2); i = i + 2, ++j) {
-		data[i] = cfg_11n->param.aggr_prio_tbl.ampdu[j];
-		data[i + 1] = cfg_11n->param.aggr_prio_tbl.amsdu[j];
+		data[i] = aggr_prio_tbl.ampdu[j];
+		data[i + 1] = aggr_prio_tbl.amsdu[j];
 
 	}
 
-	kfree(req);
-
+done:
 	LEAVE();
 	return ret;
 }
@@ -4154,32 +2857,22 @@ mwifiex_get_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data)
 int
 mwifiex_tx_aggr_prio_tbl(struct mwifiex_private *priv, int *data, int length)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
+	struct mwifiex_ds_11n_aggr_prio_tbl aggr_prio_tbl;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	int ret = 0, i, j;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (req == NULL) {
-		LEAVE();
-		return -ENOMEM;
-	}
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_CFG_AGGR_PRIO_TBL;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-
 	for (i = 0, j = 0; i < (length); i = i + 2, ++j) {
-		cfg_11n->param.aggr_prio_tbl.ampdu[j] = data[i];
-		cfg_11n->param.aggr_prio_tbl.amsdu[j] = data[i + 1];
+		aggr_prio_tbl.ampdu[j] = data[i];
+		aggr_prio_tbl.amsdu[j] = data[i + 1];
 	}
 
-	req->action = MWIFIEX_ACT_SET;
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
-	if (ret)
+	status = mwifiex_11n_ioctl_aggr_prio_tbl(priv, &aggr_prio_tbl,
+						 HostCmd_ACT_GEN_SET);
+	if (status)
 		ret = -EFAULT;
 
-	kfree(req);
 	LEAVE();
 	return ret;
 }
@@ -4194,34 +2887,31 @@ int
 mwifiex_set_sleep_pd(struct mwifiex_private *priv, int sleeppd)
 {
 	int ret = 0;
-	struct mwifiex_ds_pm_cfg *pm_cfg = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	u32 sleep_period;
+	struct mwifiex_wait_queue *wait = NULL;
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_pm_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
-	pm_cfg = (struct mwifiex_ds_pm_cfg *) req->buffer;
-	pm_cfg->sub_command = MWIFIEX_OID_PM_CFG_SLEEP_PD;
-	req->req_id = MWIFIEX_IOCTL_PM_CFG;
-	req->action = MWIFIEX_ACT_SET;
-
 
 	if ((sleeppd <= MAX_SLEEP_PERIOD && sleeppd >= MIN_SLEEP_PERIOD)
 	    || (sleeppd == 0) || (sleeppd == SLEEP_PERIOD_RESERVED_FF)) {
-		req->action = MWIFIEX_ACT_SET;
-		pm_cfg->param.sleep_period = sleeppd;
+		sleep_period = sleeppd;
 
 	} else {
 		ret = -EINVAL;
 		goto done;
 	}
+	status = mwifiex_pm_ioctl_sleep_pd(priv, wait, &sleep_period,
+					   HostCmd_ACT_GEN_SET);
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -4236,106 +2926,28 @@ int
 mwifiex_get_sleep_pd(struct mwifiex_private *priv, int *sleeppd)
 {
 	int ret = 0;
-	struct mwifiex_ds_pm_cfg *pm_cfg = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	u32 sleep_period;
+	struct mwifiex_wait_queue *wait = NULL;
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_pm_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
-	pm_cfg = (struct mwifiex_ds_pm_cfg *) req->buffer;
-	pm_cfg->sub_command = MWIFIEX_OID_PM_CFG_SLEEP_PD;
-	req->req_id = MWIFIEX_IOCTL_PM_CFG;
-	req->action = MWIFIEX_ACT_GET;
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	status = mwifiex_pm_ioctl_sleep_pd(priv, wait, &sleep_period,
+					   HostCmd_ACT_GEN_GET);
 
-	if (!ret)
-		*sleeppd = pm_cfg->param.sleep_period;
-done:
-	kfree(req);
-	LEAVE();
-	return ret;
-}
-
-/*
- * Sends IOCTL request to get QoS configurations.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_get_qos_cfg(struct mwifiex_private *priv, int *qos_cfg)
-{
-	int ret = 0;
-	struct mwifiex_ds_wmm_cfg *cfg = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
-	ENTER();
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_wmm_cfg));
-	if (req == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-	cfg = (struct mwifiex_ds_wmm_cfg *) req->buffer;
-	cfg->sub_command = MWIFIEX_OID_WMM_CFG_QOS;
-	req->req_id = MWIFIEX_IOCTL_WMM_CFG;
-	req->action = MWIFIEX_ACT_GET;
-
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
-
-	if (ret) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	*qos_cfg = cfg->param.qos_cfg;
-
-done:
-	kfree(req);
-	LEAVE();
-	return ret;
-}
-
-/*
- * Sends IOCTL request to set QoS configurations.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_qos_cfg(struct mwifiex_private *priv, int qos_cfg)
-{
-	int ret = 0;
-	struct mwifiex_ds_wmm_cfg *cfg = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
-	ENTER();
-
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_wmm_cfg));
-	if (req == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-	cfg = (struct mwifiex_ds_wmm_cfg *) req->buffer;
-	cfg->sub_command = MWIFIEX_OID_WMM_CFG_QOS;
-	req->req_id = MWIFIEX_IOCTL_WMM_CFG;
-	req->action = MWIFIEX_ACT_SET;
-	cfg->param.qos_cfg = qos_cfg;
-
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
-
-	if (ret) {
-		ret = -EFAULT;
-		goto done;
-	}
+	if (!ret)
+		*sleeppd = sleep_period;
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
-
-
 }
 
 /*
@@ -4374,33 +2986,31 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 int
 mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm)
 {
-	struct mwifiex_ds_power_cfg *power = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	struct mwifiex_power_cfg power_cfg;
+	struct mwifiex_wait_queue *wait = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	int ret = 0;
 	ENTER();
 
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_power_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	power = (struct mwifiex_ds_power_cfg *) req->buffer;
-	power->sub_command = MWIFIEX_OID_POWER_CFG;
-	req->req_id = MWIFIEX_IOCTL_POWER_CFG;
-	req->action = MWIFIEX_ACT_SET;
-
 	if (type == NL80211_TX_POWER_FIXED) {
-		power->param.power_cfg.is_power_auto = 0;
-		power->param.power_cfg.power_level = dbm;
-	} else
-		power->param.power_cfg.is_power_auto = 1;
+		power_cfg.is_power_auto = 0;
+		power_cfg.power_level = dbm;
+	} else {
+		power_cfg.is_power_auto = 1;
+	}
+	status = mwifiex_power_ioctl_set_power(priv, wait, &power_cfg);
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -4414,9 +3024,8 @@ done:
 int
 mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
 {
-
-	struct mwifiex_ds_misc_cfg *misc = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	struct mwifiex_ds_misc_gen_ie gen_ie;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	int ret = 0;
 	ENTER();
 
@@ -4425,28 +3034,16 @@ mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
 		goto done;
 	}
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_misc_cfg));
-	if (req == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	misc = (struct mwifiex_ds_misc_cfg *) req->buffer;
-	misc->sub_command = MWIFIEX_OID_MISC_GEN_IE;
-	req->req_id = MWIFIEX_IOCTL_MISC_CFG;
-	req->action = MWIFIEX_ACT_SET;
-
-	misc->param.gen_ie.type = MWIFIEX_IE_TYPE_GEN_IE;
-	misc->param.gen_ie.len = ie_len;
-	memcpy(misc->param.gen_ie.ie_data, ie, ie_len);
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+	gen_ie.type = MWIFIEX_IE_TYPE_GEN_IE;
+	gen_ie.len = ie_len;
+	memcpy(gen_ie.ie_data, ie, ie_len);
+	status = mwifiex_misc_ioctl_gen_ie(priv, &gen_ie, HostCmd_ACT_GEN_SET);
+	if (status != MWIFIEX_STATUS_SUCCESS) {
 		ret = -EFAULT;
 		goto done;
 	}
 
 done:
-	kfree(req);
 	LEAVE();
 	return ret;
 }
@@ -4461,73 +3058,32 @@ enum mwifiex_status
 mwifiex_get_scan_table(struct mwifiex_private *priv,
 		       u8 wait_option, struct mwifiex_scan_resp *scan_resp)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_scan *scan = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_scan_resp scan;
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+
 	ENTER();
 
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_scan));
-	if (req == NULL) {
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		LEAVE();
 		return MWIFIEX_STATUS_FAILURE;
 	}
 
-	/* Fill request buffer */
-	scan = (struct mwifiex_ds_scan *) req->buffer;
-	scan->sub_command = MWIFIEX_OID_SCAN_NORMAL;
-	req->req_id = MWIFIEX_IOCTL_SCAN;
-	req->action = MWIFIEX_ACT_GET;
-	memcpy((void *) &scan->param.scan_resp, (void *) scan_resp,
-	       sizeof(struct mwifiex_scan_resp));
+	status = mwifiex_scan_networks(priv, wait, HostCmd_ACT_GEN_GET,
+				       NULL, &scan);
 
-	status = mwifiex_request_ioctl(priv, req, wait_option);
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 	if (status == MWIFIEX_STATUS_SUCCESS) {
 		if (scan_resp) {
-			memcpy(scan_resp, &scan->param.scan_resp,
+			memcpy(scan_resp, &scan,
 			       sizeof(struct mwifiex_scan_resp));
 		}
 	}
 
-	if (req && (status != MWIFIEX_STATUS_PENDING))
-		kfree(req);
-	LEAVE();
-	return status;
-}
-
-/*
- * Sends IOCTL request to set authentication mode.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-enum mwifiex_status
-mwifiex_set_auth_mode(struct mwifiex_private *priv, u8 wait_option,
-		      u32 auth_mode)
-{
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_sec_cfg *sec = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	ENTER();
-
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_sec_cfg));
-	if (req == NULL) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-
-	/* Fill request buffer */
-	sec = (struct mwifiex_ds_sec_cfg *) req->buffer;
-	sec->sub_command = MWIFIEX_OID_SEC_CFG_AUTH_MODE;
-	req->req_id = MWIFIEX_IOCTL_SEC_CFG;
-	req->action = MWIFIEX_ACT_SET;
-	sec->param.auth_mode = auth_mode;
-
-	status = mwifiex_request_ioctl(priv, req, wait_option);
-
-	if (req && (status != MWIFIEX_STATUS_PENDING))
-		kfree(req);
+	if (wait && (status != MWIFIEX_STATUS_PENDING))
+		kfree(wait);
 	LEAVE();
 	return status;
 }
@@ -4540,79 +3096,38 @@ mwifiex_set_auth_mode(struct mwifiex_private *priv, u8 wait_option,
  */
 enum mwifiex_status
 mwifiex_get_signal_info(struct mwifiex_private *priv,
-			u8 wait_option, struct mwifiex_ds_get_signal *signal)
+			u8 wait_option,
+			struct mwifiex_ds_get_signal *signal)
 {
-	struct mwifiex_ds_get_info *info = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	struct mwifiex_ds_get_signal info;
+	struct mwifiex_wait_queue *wait = NULL;
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	ENTER();
 
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_get_info));
-	if (req == NULL) {
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		LEAVE();
 		return MWIFIEX_STATUS_FAILURE;
 	}
 
-	/* Fill request buffer */
-	info = (struct mwifiex_ds_get_info *) req->buffer;
-	info->sub_command = MWIFIEX_OID_GET_SIGNAL;
-	info->param.signal.selector = ALL_RSSI_INFO_MASK;
-	req->req_id = MWIFIEX_IOCTL_GET_INFO;
-	req->action = MWIFIEX_ACT_GET;
+	info.selector = ALL_RSSI_INFO_MASK;
+
+	status = mwifiex_get_info_signal(priv, wait, &info);
 
-	status = mwifiex_request_ioctl(priv, req, wait_option);
+	status = mwifiex_request_ioctl(priv, wait, status, wait_option);
 	if (status == MWIFIEX_STATUS_SUCCESS) {
 		if (signal)
-			memcpy(signal, &info->param.signal,
+			memcpy(signal, &info,
 			       sizeof(struct mwifiex_ds_get_signal));
-		if (info->param.signal.selector & BCN_RSSI_AVG_MASK)
-			priv->w_stats.qual.level =
-				info->param.signal.bcn_rssi_avg;
-		if (info->param.signal.selector & BCN_NF_AVG_MASK)
-			priv->w_stats.qual.noise =
-				info->param.signal.bcn_nf_avg;
-	}
-
-	if (req && (status != MWIFIEX_STATUS_PENDING))
-		kfree(req);
-	LEAVE();
-	return status;
-}
-
-/*
- * Sends IOCTL request to enable/disable WPA.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-enum mwifiex_status
-mwifiex_set_wpa_enable(struct mwifiex_private *priv, u8 wait_option,
-		       u32 enable)
-{
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_sec_cfg *sec = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	ENTER();
-
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_sec_cfg));
-	if (req == NULL) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
+		if (info.selector & BCN_RSSI_AVG_MASK)
+			priv->w_stats.qual.level = info.bcn_rssi_avg;
+		if (info.selector & BCN_NF_AVG_MASK)
+			priv->w_stats.qual.noise = info.bcn_nf_avg;
 	}
 
-	/* Fill request buffer */
-	sec = (struct mwifiex_ds_sec_cfg *) req->buffer;
-	sec->sub_command = MWIFIEX_OID_SEC_CFG_WPA_ENABLED;
-	req->req_id = MWIFIEX_IOCTL_SEC_CFG;
-	req->action = MWIFIEX_ACT_SET;
-	sec->param.wpa_enabled = enable;
-
-	status = mwifiex_request_ioctl(priv, req, wait_option);
-
-	if (req && (status != MWIFIEX_STATUS_PENDING))
-		kfree(req);
+	if (wait && (status != MWIFIEX_STATUS_PENDING))
+		kfree(wait);
 	LEAVE();
 	return status;
 }
@@ -4627,31 +3142,12 @@ enum mwifiex_status
 mwifiex_set_encrypt_mode(struct mwifiex_private *priv,
 			 u8 wait_option, u32 encrypt_mode)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_sec_cfg *sec = NULL;
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	ENTER();
 
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_sec_cfg));
-	if (req == NULL) {
-		LEAVE();
-		return MWIFIEX_STATUS_FAILURE;
-	}
-
-	/* Fill request buffer */
-	sec = (struct mwifiex_ds_sec_cfg *) req->buffer;
-	sec->sub_command = MWIFIEX_OID_SEC_CFG_ENCRYPT_MODE;
-	req->req_id = MWIFIEX_IOCTL_SEC_CFG;
-	req->action = MWIFIEX_ACT_SET;
-	sec->param.encrypt_mode = encrypt_mode;
-
-	status = mwifiex_request_ioctl(priv, req, wait_option);
+	priv->sec_info.encryption_mode = encrypt_mode;
 
-	if (req && (status != MWIFIEX_STATUS_PENDING))
-		kfree(req);
 	LEAVE();
-	return status;
+	return 0;
 }
 
 /*
@@ -4670,15 +3166,9 @@ mwifiex_set_auth(struct mwifiex_private *priv, int encrypt_mode,
 	    mwifiex_set_encrypt_mode(priv, MWIFIEX_IOCTL_WAIT, encrypt_mode))
 		ret = -EFAULT;
 
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_set_auth_mode(priv, MWIFIEX_IOCTL_WAIT, auth_mode))
+	if (MWIFIEX_STATUS_SUCCESS != mwifiex_set_auth_mode(priv, auth_mode))
 		ret = -EFAULT;
 
-	if (wpa_enabled) {
-		if (MWIFIEX_STATUS_SUCCESS !=
-		    mwifiex_set_wpa_enable(priv, MWIFIEX_IOCTL_WAIT, 1))
-			ret = -EFAULT;
-	}
 	LEAVE();
 	return ret;
 }
@@ -4699,23 +3189,20 @@ int
 mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 		   int key_len, u8 key_index, int disable)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_sec_cfg *sec = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_encrypt_key encrypt_key;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	int ret = 0;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_sec_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	sec = (struct mwifiex_ds_sec_cfg *) req->buffer;
-	sec->sub_command = MWIFIEX_OID_SEC_CFG_ENCRYPT_KEY;
-	req->req_id = MWIFIEX_IOCTL_SEC_CFG;
-	req->action = MWIFIEX_ACT_SET;
-	sec->param.encrypt_key.key_len = key_len;
+	encrypt_key.key_len = key_len;
 	if (!disable) {
 		if (cipher != WLAN_CIPHER_SUITE_WEP40 &&
 		    cipher != WLAN_CIPHER_SUITE_WEP104 &&
@@ -4725,27 +3212,33 @@ mwifiex_set_encode(struct mwifiex_private *priv, u32 cipher, const u8 *key,
 			ret = -EINVAL;
 			goto done;
 		}
-		sec->param.encrypt_key.key_index = key_index;
-		memcpy(sec->param.encrypt_key.key_material, key, key_len);
+		encrypt_key.key_index = key_index;
+		memcpy(encrypt_key.key_material, key, key_len);
 
 		if (cipher == WLAN_CIPHER_SUITE_WEP40
 		    || cipher == WLAN_CIPHER_SUITE_WEP104) {
+			status = mwifiex_sec_ioctl_encrypt_key(priv, wait,
+							&encrypt_key,
+							HostCmd_ACT_GEN_SET);
 			if (MWIFIEX_STATUS_SUCCESS !=
-			    mwifiex_request_ioctl(priv, req,
+			    mwifiex_request_ioctl(priv, wait, status,
 						  MWIFIEX_IOCTL_WAIT)) {
 				ret = -EFAULT;
 				goto done;
 			}
-			sec->param.encrypt_key.key_len = 0;
+			encrypt_key.key_len = 0;
 		}
-	} else
-		sec->param.encrypt_key.key_disable = true;
+	} else {
+		encrypt_key.key_disable = true;
+	}
+		status = mwifiex_sec_ioctl_encrypt_key(priv, wait, &encrypt_key,
+						       HostCmd_ACT_GEN_SET);
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT))
+	    mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
 		ret = -EFAULT;
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -4760,28 +3253,26 @@ int
 mwifiex_drv_set_power(struct mwifiex_private *priv, bool power_on)
 {
 	int ret = 0;
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_pm_cfg *pm_cfg = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	u32 ps_mode;
+
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_pm_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	pm_cfg = (struct mwifiex_ds_pm_cfg *) req->buffer;
-	pm_cfg->sub_command = MWIFIEX_OID_PM_CFG_IEEE_PS;
-	req->req_id = MWIFIEX_IOCTL_PM_CFG;
-	req->action = MWIFIEX_ACT_SET;
-
-	pm_cfg->param.ps_mode = power_on;
+	ps_mode = power_on;
+	status = mwifiex_pm_ioctl_ps_mode(priv, wait, &ps_mode,
+					  HostCmd_ACT_GEN_SET);
 
-
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -4795,23 +3286,24 @@ done:
 int
 mwifiex_get_ver_ext(struct mwifiex_private *priv)
 {
-	struct mwifiex_ds_get_info *info;
-	struct mwifiex_ioctl_req *req = NULL;
+	struct mwifiex_ver_ext ver_ext;
+	struct mwifiex_wait_queue *wait = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	int ret = 0;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
-	/* get fw version */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_get_info));
-	if (req == NULL) {
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		LEAVE();
 		return -ENOMEM;
 	}
 
-	info = (struct mwifiex_ds_get_info *) req->buffer;
-	req->req_id = MWIFIEX_IOCTL_GET_INFO;
-	req->action = MWIFIEX_ACT_GET;
-	info->sub_command = MWIFIEX_OID_GET_VER_EXT;
+	/* get fw version */
+	memset(&ver_ext, 0, sizeof(struct host_cmd_ds_version_ext));
+	status = mwifiex_get_info_ver_ext(priv, wait, &ver_ext);
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
 
 	if (ret) {
 		ret = MWIFIEX_STATUS_FAILURE;
@@ -4819,7 +3311,7 @@ mwifiex_get_ver_ext(struct mwifiex_private *priv)
 	}
 
 done:
-	kfree(req);
+	kfree(wait);
 	return ret;
 }
 
@@ -4833,29 +3325,30 @@ int
 mwifiex_set_tx_rx_ant(struct mwifiex_private *priv, int antenna)
 {
 	int ret = 0;
-	struct mwifiex_ds_radio_cfg *radio = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	u32 ant;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
 	ENTER();
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_radio_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
-	radio = (struct mwifiex_ds_radio_cfg *) req->buffer;
-	radio->sub_command = MWIFIEX_OID_ANT_CFG;
-	req->req_id = MWIFIEX_IOCTL_RADIO_CFG;
-	req->action = MWIFIEX_ACT_SET;
-	radio->param.antenna = antenna;
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ant = antenna;
+	status = mwifiex_radio_ioctl_ant_cfg(priv, wait, HostCmd_ACT_GEN_SET,
+					     &ant);
+
+	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
 	if (ret) {
 		ret = -EFAULT;
 		goto done;
 	}
 
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -4870,31 +3363,31 @@ int
 mwifiex_get_tx_rx_ant(struct mwifiex_private *priv, int *antenna)
 {
 	int ret = 0;
-	struct mwifiex_ds_radio_cfg *radio = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	u32 ant;
+	struct mwifiex_wait_queue *wait = NULL;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
 
 	ENTER();
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_radio_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	radio = (struct mwifiex_ds_radio_cfg *) req->buffer;
-	radio->sub_command = MWIFIEX_OID_ANT_CFG;
-	req->req_id = MWIFIEX_IOCTL_RADIO_CFG;
-	req->action = MWIFIEX_ACT_GET;
+	status = mwifiex_radio_ioctl_ant_cfg(priv, wait, HostCmd_ACT_GEN_GET,
+					     &ant);
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
 	if (ret) {
 		ret = -EFAULT;
 		goto done;
 	}
 
-	*antenna = radio->param.antenna;
+	*antenna = ant;
 
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -4907,38 +3400,38 @@ done:
  */
 int
 mwifiex_get_stats_info(struct mwifiex_private *priv,
-		       struct mwifiex_ds_get_stats *stats)
+		       struct mwifiex_ds_get_stats *log)
 {
 	int ret = 0;
-	struct mwifiex_ds_get_info *info = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_get_stats get_log;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+
 	ENTER();
 
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_get_info));
-	if (req == NULL) {
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	/* Fill request buffer */
-	info = (struct mwifiex_ds_get_info *) req->buffer;
-	info->sub_command = MWIFIEX_OID_GET_STATS;
-	req->req_id = MWIFIEX_IOCTL_GET_INFO;
-	req->action = MWIFIEX_ACT_GET;
+	memset(&get_log, 0, sizeof(struct mwifiex_ds_get_stats));
+	status = mwifiex_get_info_stats(priv, wait, &get_log);
 
 	/* Send IOCTL request to MWIFIEX */
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, wait_option);
 	if (ret == MWIFIEX_STATUS_SUCCESS) {
-		if (stats)
-			memcpy(stats, &info->param.stats,
-			       sizeof(struct mwifiex_ds_get_stats));
-		priv->w_stats.discard.fragment = info->param.stats.fcs_error;
-		priv->w_stats.discard.retries = info->param.stats.retry;
-		priv->w_stats.discard.misc = info->param.stats.ack_failure;
+		if (log)
+			memcpy(log, &get_log, sizeof(struct
+					mwifiex_ds_get_stats));
+		priv->w_stats.discard.fragment = get_log.fcs_error;
+		priv->w_stats.discard.retries = get_log.retry;
+		priv->w_stats.discard.misc = get_log.ack_failure;
 	}
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -4954,28 +3447,28 @@ mwifiex_reg_write(struct mwifiex_private *priv, u32 reg_type,
 		  u32 reg_offset, u32 reg_value)
 {
 	int ret = 0;
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_reg_mem *reg = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_reg_rw reg_rw;
+
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_reg_mem));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	reg = (struct mwifiex_ds_reg_mem *) req->buffer;
-	reg->sub_command = MWIFIEX_OID_REG_RW;
-	req->req_id = MWIFIEX_IOCTL_REG_MEM;
-	req->action = MWIFIEX_ACT_SET;
-	reg->param.reg_rw.type = cpu_to_le32(reg_type);
-	reg->param.reg_rw.offset = cpu_to_le32(reg_offset);
-	reg->param.reg_rw.value = cpu_to_le32(reg_value);
+	reg_rw.type = cpu_to_le32(reg_type);
+	reg_rw.offset = cpu_to_le32(reg_offset);
+	reg_rw.value = cpu_to_le32(reg_value);
+	status = mwifiex_reg_mem_ioctl_reg_rw(priv, wait, &reg_rw,
+					      HostCmd_ACT_GEN_SET);
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 
 done:
-	kfree(req);
+	kfree(wait);
 	return ret;
 }
 
@@ -4990,31 +3483,31 @@ mwifiex_reg_read(struct mwifiex_private *priv, u32 reg_type,
 		 u32 reg_offset, u32 *value)
 {
 	int ret = 0;
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_reg_mem *reg = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_reg_rw reg_rw;
+
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_reg_mem));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	reg = (struct mwifiex_ds_reg_mem *) req->buffer;
-	reg->sub_command = MWIFIEX_OID_REG_RW;
-	req->req_id = MWIFIEX_IOCTL_REG_MEM;
-	req->action = MWIFIEX_ACT_GET;
-	reg->param.reg_rw.type = cpu_to_le32(reg_type);
-	reg->param.reg_rw.offset = cpu_to_le32(reg_offset);
+	reg_rw.type = cpu_to_le32(reg_type);
+	reg_rw.offset = cpu_to_le32(reg_offset);
+	status = mwifiex_reg_mem_ioctl_reg_rw(priv, wait, &reg_rw,
+					      HostCmd_ACT_GEN_GET);
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 	if (ret)
 		goto done;
 
-	*value = le32_to_cpu(reg->param.reg_rw.value);
+	*value = le32_to_cpu(reg_rw.value);
 
 done:
-	kfree(req);
+	kfree(wait);
 	return ret;
 }
 
@@ -5029,98 +3522,27 @@ mwifiex_eeprom_read(struct mwifiex_private *priv, u16 offset, u16 bytes,
 		    u8 *value)
 {
 	int ret = 0;
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_reg_mem *reg = NULL;
-
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_reg_mem));
-	if (req == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	reg = (struct mwifiex_ds_reg_mem *) req->buffer;
-	reg->sub_command = MWIFIEX_OID_EEPROM_RD;
-	req->req_id = MWIFIEX_IOCTL_REG_MEM;
-	req->action = MWIFIEX_ACT_GET;
-
-	reg->param.rd_eeprom.offset = cpu_to_le16((u16) offset);
-	reg->param.rd_eeprom.byte_count = cpu_to_le16((u16) bytes);
-
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
-	if (ret)
-		goto done;
-
-	memcpy(value, reg->param.rd_eeprom.value, MAX_EEPROM_DATA);
-done:
-	kfree(req);
-	return ret;
-}
-
-/*
- * Sends IOCTL request to set 11n HT capability configurations.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_11n_htcap_cfg(struct mwifiex_private *priv, int data)
-{
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
-	int ret = 0;
-	ENTER();
-
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (!req) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_HTCAP_CFG;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_SET;
-	cfg_11n->param.htcap_cfg = data;
-
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
-
-done:
-	kfree(req);
-	return ret;
-}
-
-/*
- * Sends IOCTL request to get 11n HT capability configurations.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_get_11n_htcap_cfg(struct mwifiex_private *priv, int *data)
-{
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
-	int ret = 0;
-	ENTER();
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_read_eeprom rd_eeprom;
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (!req) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_HTCAP_CFG;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_GET;
+	rd_eeprom.offset = cpu_to_le16((u16) offset);
+	rd_eeprom.byte_count = cpu_to_le16((u16) bytes);
+	status = mwifiex_reg_mem_ioctl_read_eeprom(priv, wait, &rd_eeprom);
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 	if (ret)
 		goto done;
 
-	*data = cfg_11n->param.htcap_cfg;
+	memcpy(value, rd_eeprom.value, MAX_EEPROM_DATA);
 done:
-	kfree(req);
+	kfree(wait);
 	return ret;
 }
 
@@ -5133,27 +3555,26 @@ done:
 int
 mwifiex_set_11n_httx_cfg(struct mwifiex_private *priv, int data)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_11n_tx_cfg tx_cfg;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	int ret = 0;
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (!req) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_CFG_TX;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_SET;
-	cfg_11n->param.tx_cfg.tx_htcap = data;
+	tx_cfg.tx_htcap = data;
+	status = mwifiex_11n_ioctl_ht_tx_cfg(priv->adapter, wait, &tx_cfg,
+					     HostCmd_ACT_GEN_SET);
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 
 done:
-	kfree(req);
+	kfree(wait);
 	return ret;
 }
 
@@ -5166,29 +3587,28 @@ done:
 int
 mwifiex_get_11n_httx_cfg(struct mwifiex_private *priv, int *data)
 {
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_11n_tx_cfg tx_cfg;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 	int ret = 0;
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (!req) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_CFG_TX;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_GET;
+	status = mwifiex_11n_ioctl_ht_tx_cfg(priv->adapter, wait, &tx_cfg,
+					     HostCmd_ACT_GEN_GET);
 
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
+	ret = mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT);
 	if (ret)
 		goto done;
 
-	*data = cfg_11n->param.tx_cfg.tx_htcap;
+	*data = tx_cfg.tx_htcap;
 done:
-	kfree(req);
+	kfree(wait);
 	return ret;
 }
 
@@ -5198,35 +3618,14 @@ done:
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-int
+void
 mwifiex_set_atim_window(struct mwifiex_private *priv, int atim)
 {
-	struct mwifiex_ds_bss *bss = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
-	int ret = 0;
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-	bss = (struct mwifiex_ds_bss *) req->buffer;
-	bss->sub_command = MWIFIEX_OID_IBSS_ATIM_WINDOW;
-	req->req_id = MWIFIEX_IOCTL_BSS;
-	req->action = MWIFIEX_ACT_SET;
-	bss->param.atim_window = atim;
-
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
-		ret = -EFAULT;
-		goto done;
-	}
+	priv->atim_window = (u16) atim;
 
-done:
-	kfree(req);
 	LEAVE();
-	return ret;
 }
 
 /*
@@ -5235,37 +3634,16 @@ done:
  * This function allocates the IOCTL request buffer, fills it
  * with requisite parameters and calls the IOCTL handler.
  */
-int
+void
 mwifiex_get_atim_window(struct mwifiex_private *priv, int *atim)
 {
-	struct mwifiex_ds_bss *bss = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
-	int ret = 0;
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_bss));
-	if (req == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	bss = (struct mwifiex_ds_bss *) req->buffer;
-	bss->sub_command = MWIFIEX_OID_IBSS_ATIM_WINDOW;
-	req->req_id = MWIFIEX_IOCTL_BSS;
-	req->action = MWIFIEX_ACT_GET;
-
-	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	*atim = bss->param.atim_window;
-done:
-	kfree(req);
+	*atim = priv->atim_window;
+	if (priv->media_connected)
+		*atim = priv->curr_bss_params.bss_descriptor.atim_window;
 
 	LEAVE();
-	return ret;
 }
 
 /*
@@ -5278,41 +3656,44 @@ int
 mwifiex_set_tx_rate_cfg(struct mwifiex_private *priv, int tx_rate_idx)
 {
 	int ret = 0;
-	struct mwifiex_ds_rate *rate = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	struct mwifiex_rate_cfg rate_cfg;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_rate));
-	if (req == NULL) {
+	/* Allocate wait buffer */
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	rate = (struct mwifiex_ds_rate *) req->buffer;
-	rate->param.rate_cfg.rate_type = MWIFIEX_RATE_INDEX;
-	rate->sub_command = MWIFIEX_OID_RATE_CFG;
-	req->req_id = MWIFIEX_IOCTL_RATE;
-	req->action = MWIFIEX_ACT_SET;
-
-	if (tx_rate_idx == AUTO_RATE)
-		rate->param.rate_cfg.is_rate_auto = 1;
-	else {
+	memset(&rate_cfg, 0, sizeof(struct mwifiex_rate_cfg));
+	rate_cfg.action = HostCmd_ACT_GEN_SET;
+	rate_cfg.rate_type = MWIFIEX_RATE_INDEX;
+	if (tx_rate_idx == AUTO_RATE) {
+		rate_cfg.is_rate_auto = 1;
+	} else {
 		if ((tx_rate_idx != MWIFIEX_RATE_INDEX_MCS32) &&
 		    ((tx_rate_idx < 0)
 		     || (tx_rate_idx > MWIFIEX_RATE_INDEX_MCS7))) {
 			ret = -EINVAL;
 			goto done;
 		}
-		rate->param.rate_cfg.rate = tx_rate_idx;
+		rate_cfg.rate = tx_rate_idx;
 	}
+	status = mwifiex_rate_ioctl_cfg(priv, wait, &rate_cfg);
+
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
 		ret = -EFAULT;
 		goto done;
 	}
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -5327,34 +3708,54 @@ int
 mwifiex_get_tx_rate_cfg(struct mwifiex_private *priv, int *tx_rate_idx)
 {
 	int ret = 0;
-	struct mwifiex_ds_rate *rate = NULL;
-	struct mwifiex_ioctl_req *req = NULL;
+	struct mwifiex_rate_cfg rate_cfg;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	u8 wait_option = MWIFIEX_IOCTL_WAIT;
+
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_rate));
-	if (req == NULL) {
+	/* TX rate configuration can be set only if media connected */
+	if (!priv->media_connected) {
+		PRINTM(MINFO, "Can not set txratecfg in disconnected state\n");
+		LEAVE();
+		return MWIFIEX_STATUS_FAILURE;
+	}
+
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	rate = (struct mwifiex_ds_rate *) req->buffer;
-	rate->param.rate_cfg.rate_type = MWIFIEX_RATE_INDEX;
-	rate->sub_command = MWIFIEX_OID_RATE_CFG;
-	req->req_id = MWIFIEX_IOCTL_RATE;
-	req->action = MWIFIEX_ACT_GET;
+	memset(&rate_cfg, 0, sizeof(struct mwifiex_rate_cfg));
+	rate_cfg.action = HostCmd_ACT_GEN_GET;
+	rate_cfg.rate_type = MWIFIEX_RATE_INDEX;
+	status = mwifiex_rate_ioctl_cfg(priv, wait, &rate_cfg);
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+	    mwifiex_request_ioctl(priv, wait, status, wait_option)) {
 		ret = -EFAULT;
 		goto done;
 	}
 
-	if (rate->param.rate_cfg.is_rate_auto)
+	if (priv->tx_htinfo & BIT(0))
+		rate_cfg.rate = priv->tx_rate + MWIFIEX_RATE_INDEX_MCS0;
+	else
+		/* For HostCmd_CMD_802_11_TX_RATE_QUERY
+		   , there is a hole in rate table
+		   between HR/DSSS and OFDM rates, so
+		   minus 1 for OFDM rate index */
+		rate_cfg.rate =
+			(priv->tx_rate > MWIFIEX_RATE_INDEX_OFDM0)
+			? priv->tx_rate - 1 : priv->tx_rate;
+
+	if (priv->is_data_rate_auto)
 		*tx_rate_idx = AUTO_RATE;
 	else
-		*tx_rate_idx = rate->param.rate_cfg.rate;
+		*tx_rate_idx = rate_cfg.rate;
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -5363,13 +3764,13 @@ done:
  * Set eWPA mode if passphrase/psk is set
  */
 enum mwifiex_status
-wlan_set_ewpa_mode(struct mwifiex_private *priv,
+mwifiex_set_ewpa_mode_from_passphrase(struct mwifiex_private *priv,
 		   struct mwifiex_ds_passphrase *psec_pp)
 {
 	ENTER();
 
 	if ((psec_pp->psk_type == MWIFIEX_PSK_PASSPHRASE &&
-				psec_pp->psk.passphrase.passphrase_len > 0) ||
+			psec_pp->psk.passphrase.passphrase_len > 0) ||
 			(psec_pp->psk_type == MWIFIEX_PSK_PMK))
 		priv->sec_info.ewpa_enabled = true;
 	else
@@ -5382,42 +3783,6 @@ wlan_set_ewpa_mode(struct mwifiex_private *priv,
 }
 
 /*
- * Sends IOCTL request to set eWPA mode.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_ewpa_mode(struct mwifiex_private *priv,
-		      struct mwifiex_ssid_bssid *ssid)
-{
-	int ret = 0;
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_sec_cfg *sec = NULL;
-	ENTER();
-
-	/* Allocate an IOCTL request buffer */
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_sec_cfg));
-	if (req == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-	/* Fill request buffer */
-	sec = (struct mwifiex_ds_sec_cfg *) req->buffer;
-	sec->sub_command = MWIFIEX_OID_SEC_CFG_EWPA_ENABLED;
-	req->req_id = MWIFIEX_IOCTL_SEC_CFG;
-	req->action = MWIFIEX_ACT_SET;
-	sec->param.ewpa_enabled = false;
-
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
-
-done:
-	kfree(req);
-	LEAVE();
-	return ret;
-}
-
-/*
  * Sends IOCTL request to set Add BA parameters (Timeout, Tx window size,
  * Rx window size).
  *
@@ -5428,35 +3793,34 @@ int
 mwifiex_set_addba_param(struct mwifiex_private *priv, int *data)
 {
 	int ret = 0;
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_11n_addba_param addba_param;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		LEAVE();
 		return -ENOMEM;
 	}
 
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_CFG_ADDBA_PARAM;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_SET;
-
-	cfg_11n->param.addba_param.timeout = data[0];
-	cfg_11n->param.addba_param.tx_win_size = data[1];
-	cfg_11n->param.addba_param.rx_win_size = data[2];
+	addba_param.timeout = data[0];
+	addba_param.tx_win_size = data[1];
+	addba_param.rx_win_size = data[2];
 	PRINTM(MINFO, "SET: timeout:%d txwinsize:%d rxwinsize:%d\n", data[0],
 	       data[1], data[2]);
+	status = mwifiex_11n_ioctl_addba_param(priv->adapter, wait,
+					       &addba_param,
+					       HostCmd_ACT_GEN_SET);
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+	    mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
 		ret = -EFAULT;
 		goto done;
 	}
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -5473,110 +3837,36 @@ mwifiex_get_addba_param(struct mwifiex_private *priv, int *addba_timeout,
 		       int *tx_win_sz, int *rx_win_sz)
 {
 	int ret = 0;
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue *wait = NULL;
+	struct mwifiex_ds_11n_addba_param addba_param;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		LEAVE();
 		return -ENOMEM;
 	}
 
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_CFG_ADDBA_PARAM;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_GET;
+	status = mwifiex_11n_ioctl_addba_param(priv->adapter, wait,
+					       &addba_param,
+					       HostCmd_ACT_GEN_GET);
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-	    mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+		mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
 		ret = -EFAULT;
 		goto done;
 	}
 
-	*addba_timeout = cfg_11n->param.addba_param.timeout;
-	*tx_win_sz = cfg_11n->param.addba_param.tx_win_size;
-	*rx_win_sz = cfg_11n->param.addba_param.rx_win_size;
+	*addba_timeout = addba_param.timeout;
+	*tx_win_sz = addba_param.tx_win_size;
+	*rx_win_sz = addba_param.rx_win_size;
 
 	PRINTM(MINFO, "GET: timeout:%d txwinsize:%d rxwinsize:%d\n",
 	       addba_timeout, tx_win_sz, rx_win_sz);
 done:
-	kfree(req);
-	LEAVE();
-	return ret;
-}
-
-/*
- * Sends IOCTL request to set Add BA rejection.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_set_addba_reject(struct mwifiex_private *priv, int *data)
-{
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
-	int i, ret = 0;
-
-	ENTER();
-
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (req == NULL) {
-		LEAVE();
-		return -ENOMEM;
-	}
-
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_CFG_ADDBA_REJECT;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_SET;
-
-	for (i = 0; i < 8; i++)
-		cfg_11n->param.addba_reject[i] = data[i];
-
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
-
-	kfree(req);
-	LEAVE();
-	return ret;
-}
-
-/*
- * Sends IOCTL request to get Add BA rejection.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int
-mwifiex_get_addba_reject(struct mwifiex_private *priv, int *data)
-{
-	struct mwifiex_ioctl_req *req = NULL;
-	struct mwifiex_ds_11n_cfg *cfg_11n = NULL;
-	int i, ret = 0;
-
-	ENTER();
-
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_11n_cfg));
-	if (req == NULL) {
-		LEAVE();
-		return -ENOMEM;
-	}
-
-	cfg_11n = (struct mwifiex_ds_11n_cfg *) req->buffer;
-	cfg_11n->sub_command = MWIFIEX_OID_11N_CFG_ADDBA_REJECT;
-	req->req_id = MWIFIEX_IOCTL_11N_CFG;
-	req->action = MWIFIEX_ACT_GET;
-
-	ret = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
-	if (ret)
-		goto done;
-
-	for (i = 0; i < 8; i++)
-		data[i] = cfg_11n->param.addba_reject[i];
-done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -5591,39 +3881,28 @@ int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
 			   struct mwifiex_ds_passphrase *ds_passphrase)
 {
 	int ret = 0;
-	struct mwifiex_ds_sec_cfg *sec = NULL;
-	struct mwifiex_ioctl_req  *req = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_wait_queue  *wait = NULL;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_sec_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		LEAVE();
 		return -ENOMEM;
 	}
-	sec = (struct mwifiex_ds_sec_cfg *)req->buffer;
-	sec->sub_command =  MWIFIEX_OID_SEC_CFG_PASSPHRASE;
-	req->req_id =  MWIFIEX_IOCTL_SEC_CFG;
-	if (action == 0)
-		req->action = MWIFIEX_ACT_GET;
-	else
-		req->action = MWIFIEX_ACT_SET;
 
-	memcpy(&sec->param.passphrase, ds_passphrase,
-				sizeof(struct mwifiex_ds_passphrase));
+	status = mwifiex_sec_ioctl_passphrase(priv, wait, ds_passphrase,
+					      action);
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-			mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+		mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
 		ret = -EFAULT;
 		goto done;
 	}
 
-	if (action == 0)
-		memcpy(ds_passphrase, &sec->param.passphrase,
-				sizeof(struct mwifiex_ds_passphrase));
-
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -5638,33 +3917,31 @@ int mwifiex_get_esupp_mode(struct mwifiex_private *priv,
 				  struct mwifiex_ds_esupp_mode *esupp_mode)
 {
 	int ret = 0;
-	struct mwifiex_ds_sec_cfg     *sec = NULL;
-	struct mwifiex_ioctl_req      *req = NULL;
+	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
+	struct mwifiex_ds_esupp_mode esuppmode;
+	struct mwifiex_wait_queue *wait = NULL;
 
 	ENTER();
 
-	req = mwifiex_alloc_ioctl_req(sizeof(struct mwifiex_ds_sec_cfg));
-	if (req == NULL) {
+	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
+	if (!wait) {
 		LEAVE();
 		return -ENOMEM;
 	}
-	sec = (struct mwifiex_ds_sec_cfg *)req->buffer;
-	sec->sub_command =  MWIFIEX_OID_SEC_CFG_ESUPP_MODE;
-	req->req_id =  MWIFIEX_IOCTL_SEC_CFG;
-	req->action = MWIFIEX_ACT_GET;
+	status = mwifiex_sec_ioctl_esupp_mode(priv, wait, &esuppmode);
 
 	if (MWIFIEX_STATUS_SUCCESS !=
-			mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT)) {
+		mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
 		ret =  -EFAULT;
 		goto done;
 	}
 
 	if (esupp_mode)
-		memcpy(esupp_mode, &sec->param.esupp_mode,
+		memcpy(esupp_mode, &esuppmode,
 				sizeof(struct mwifiex_ds_esupp_mode));
 
 done:
-	kfree(req);
+	kfree(wait);
 	LEAVE();
 	return ret;
 }
@@ -5762,24 +4039,18 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
  *      - PMIC
  *      - CAU
  */
-static enum mwifiex_status
-mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_adapter *adapter,
-			     struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
+			     struct mwifiex_wait_queue *wait,
+			     struct mwifiex_ds_reg_rw *reg_rw,
+			     u16 action)
 {
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_reg_mem *reg_mem = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	u16 cmd_action = 0, cmd_no;
+	u16 cmd_no;
 
 	ENTER();
 
-	reg_mem = (struct mwifiex_ds_reg_mem *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_GET)
-		cmd_action = HostCmd_ACT_GEN_GET;
-	else
-		cmd_action = HostCmd_ACT_GEN_SET;
-
-	switch (le32_to_cpu(reg_mem->param.reg_rw.type)) {
+	switch (le32_to_cpu(reg_rw->type)) {
 	case MWIFIEX_REG_MAC:
 		cmd_no = HostCmd_CMD_MAC_REG_ACCESS;
 		break;
@@ -5801,9 +4072,7 @@ mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_adapter *adapter,
 	}
 
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, cmd_no, cmd_action,
-				  0, (void *) ioctl_req,
-				  (void *) &reg_mem->param.reg_rw);
+	ret = mwifiex_prepare_cmd(priv, cmd_no, action, 0, wait, reg_rw);
 
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
@@ -5819,41 +4088,37 @@ exit:
  * In addition to various generic IEs, this function can also be
  * used to set the ARP filter.
  */
-static enum mwifiex_status
-mwifiex_misc_ioctl_gen_ie(struct mwifiex_adapter *adapter,
-			  struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
+			  struct mwifiex_ds_misc_gen_ie *gen_ie,
+			  u16 action)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_misc_cfg *misc = NULL;
+	struct mwifiex_adapter *adapter = priv->adapter;
 
 	ENTER();
 
-	misc = (struct mwifiex_ds_misc_cfg *) ioctl_req->buffer;
-	switch (misc->param.gen_ie.type) {
+	switch (gen_ie->type) {
 	case MWIFIEX_IE_TYPE_GEN_IE:
-		if (ioctl_req->action == MWIFIEX_ACT_GET) {
-			misc->param.gen_ie.len = priv->wpa_ie_len;
-			memcpy(misc->param.gen_ie.ie_data, priv->wpa_ie,
-			       misc->param.gen_ie.len);
+		if (action == HostCmd_ACT_GEN_GET) {
+			gen_ie->len = priv->wpa_ie_len;
+			memcpy(gen_ie->ie_data, priv->wpa_ie, gen_ie->len);
 		} else {
 			mwifiex_set_gen_ie_helper(priv,
-						  misc->param.gen_ie.ie_data,
-						  (u16) misc->param.gen_ie.
-						  len);
+						  gen_ie->ie_data,
+						  (u16) gen_ie->len);
 		}
 		break;
 	case MWIFIEX_IE_TYPE_ARP_FILTER:
 		memset(adapter->arp_filter, 0, sizeof(adapter->arp_filter));
-		if (misc->param.gen_ie.len > ARP_FILTER_MAX_BUF_SIZE) {
+		if (gen_ie->len > ARP_FILTER_MAX_BUF_SIZE) {
 			adapter->arp_filter_size = 0;
 			PRINTM(MERROR, "Invalid ARP Filter Size\n");
 			ret = MWIFIEX_STATUS_FAILURE;
 		} else {
-			memcpy(adapter->arp_filter,
-			       misc->param.gen_ie.ie_data,
-			       misc->param.gen_ie.len);
-			adapter->arp_filter_size = misc->param.gen_ie.len;
+			memcpy(adapter->arp_filter, gen_ie->ie_data,
+								gen_ie->len);
+			adapter->arp_filter_size = gen_ie->len;
 			HEXDUMP("ArpFilter", adapter->arp_filter,
 				adapter->arp_filter_size);
 		}
@@ -5862,9 +4127,6 @@ mwifiex_misc_ioctl_gen_ie(struct mwifiex_adapter *adapter,
 		PRINTM(MERROR, "Invalid IE type\n");
 		ret = MWIFIEX_STATUS_FAILURE;
 	}
-	ioctl_req->data_read_written =
-		sizeof(struct mwifiex_ds_misc_gen_ie) +
-		MWIFIEX_SUB_COMMAND_SIZE;
 	LEAVE();
 	return ret;
 }
@@ -5875,26 +4137,18 @@ mwifiex_misc_ioctl_gen_ie(struct mwifiex_adapter *adapter,
  * This function prepares the correct firmware command and
  * issues it.
  */
-static enum mwifiex_status
-mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_adapter *adapter,
-				  struct mwifiex_ioctl_req *ioctl_req)
+enum mwifiex_status
+mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_private *priv,
+				  struct mwifiex_wait_queue *wait,
+				  struct mwifiex_ds_read_eeprom *rd_eeprom)
 {
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_reg_mem *reg_mem = NULL;
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	u16 cmd_action = 0;
 
 	ENTER();
 
-	reg_mem = (struct mwifiex_ds_reg_mem *) ioctl_req->buffer;
-	if (ioctl_req->action == MWIFIEX_ACT_GET)
-		cmd_action = HostCmd_ACT_GEN_GET;
-
 	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  HostCmd_CMD_802_11_EEPROM_ACCESS,
-				  cmd_action, 0, (void *) ioctl_req,
-				  (void *) &reg_mem->param.rd_eeprom);
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
+				  HostCmd_ACT_GEN_GET, 0, wait, rd_eeprom);
 
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
@@ -5902,265 +4156,3 @@ mwifiex_reg_mem_ioctl_read_eeprom(struct mwifiex_adapter *adapter,
 	LEAVE();
 	return ret;
 }
-
-/*
- * IOCTL request handler to access registers.
- *
- * This function is the generic handler and calls other specific handler
- * function based upon the parameters type.
- *
- * Currently, it supports the following register access requests -
- *      MWIFIEX_OID_EEPROM_RD - Read EEPROM register
- *      MWIFIEX_OID_REG_RW    - Read/write device register
- */
-static enum mwifiex_status
-mwifiex_reg_mem_ioctl(struct mwifiex_adapter *adapter,
-		      struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_reg_mem *reg_mem = NULL;
-
-	ENTER();
-
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_reg_mem)) {
-		PRINTM(MWARN, "MWIFIEX REG_MEM IOCTL length is too short\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed = sizeof(struct mwifiex_ds_reg_mem);
-		LEAVE();
-		return MWIFIEX_STATUS_RESOURCE;
-	}
-	reg_mem = (struct mwifiex_ds_reg_mem *) ioctl_req->buffer;
-	switch (reg_mem->sub_command) {
-	case MWIFIEX_OID_EEPROM_RD:
-		status = mwifiex_reg_mem_ioctl_read_eeprom(adapter,
-							   ioctl_req);
-		break;
-	case MWIFIEX_OID_REG_RW:
-		status = mwifiex_reg_mem_ioctl_reg_rw(adapter, ioctl_req);
-		break;
-	default:
-		status = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-	LEAVE();
-	return status;
-}
-
-/*
- * IOCTL request handler to set/get miscellaneous parameters.
- *
- * This function is the generic handler and calls other specific handler
- * function based upon the parameters type.
- *
- * Currently, it supports the following miscellaneous parameter set/get
- * requests -
- *      MWIFIEX_OID_MISC_GEN_IE -        Add/get generic IE
- *      MWIFIEX_OID_MISC_HOST_CMD -      Send hostcmd
- *      MWIFIEX_OID_MISC_INIT_SHUTDOWN - Init shutdown
- */
-static enum mwifiex_status
-mwifiex_misc_cfg_ioctl(struct mwifiex_adapter *adapter,
-		       struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_misc_cfg *misc = NULL;
-
-	ENTER();
-
-	if (ioctl_req->buf_len < sizeof(struct mwifiex_ds_misc_cfg)) {
-		PRINTM(MWARN, "IOCTL length is too short.\n");
-		ioctl_req->data_read_written = 0;
-		ioctl_req->buf_len_needed = sizeof(struct mwifiex_ds_misc_cfg);
-		LEAVE();
-		return MWIFIEX_STATUS_RESOURCE;
-	}
-	misc = (struct mwifiex_ds_misc_cfg *) ioctl_req->buffer;
-	switch (misc->sub_command) {
-	case MWIFIEX_OID_MISC_GEN_IE:
-		status = mwifiex_misc_ioctl_gen_ie(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_MISC_HOST_CMD:
-		status = mwifiex_misc_ioctl_host_cmd(adapter, ioctl_req);
-		break;
-	case MWIFIEX_OID_MISC_INIT_SHUTDOWN:
-		status = mwifiex_misc_ioctl_init_shutdown(adapter,
-							  ioctl_req);
-		break;
-
-	default:
-		status = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-	LEAVE();
-	return status;
-}
-
-/*
- * IOCTL request handler to start scan or get scan results.
- *
- * This function is the generic handler and calls other specific handler
- * function based upon the parameters type.
- *
- * Currently, it supports the following scan parameter set/get requests -
- *      MWIFIEX_OID_SCAN_NORMAL -        Perform scan or get scan table
- *      MWIFIEX_OID_SCAN_SPECIFIC_SSID - Perform a specific SSID scan or look
- *                                       for a specific SSID in scan result
- *      MWIFIEX_OID_SCAN_USER_CONFIG -   Perform scan with user provided scan
- *                                       configuration parameters.
- */
-static enum mwifiex_status
-mwifiex_scan_ioctl(struct mwifiex_adapter *adapter,
-		   struct mwifiex_ioctl_req *ioctl_req)
-{
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_scan *scan;
-
-	ENTER();
-
-	scan = (struct mwifiex_ds_scan *) ioctl_req->buffer;
-	if (adapter->scan_processing && ioctl_req->action == MWIFIEX_ACT_SET) {
-		PRINTM(MCMND, "Scan already in process...\n");
-		LEAVE();
-		return status;
-	}
-
-	if (priv->scan_block && ioctl_req->action == MWIFIEX_ACT_SET) {
-		PRINTM(MCMND, "Scan is blocked during association...\n");
-		LEAVE();
-		return status;
-	}
-
-	/* Set scan */
-	if (ioctl_req->action == MWIFIEX_ACT_SET) {
-
-		switch (scan->sub_command) {
-		case MWIFIEX_OID_SCAN_NORMAL:
-			status = mwifiex_scan_networks(priv, ioctl_req,
-						       NULL);
-			break;
-		case MWIFIEX_OID_SCAN_SPECIFIC_SSID:
-			status = mwifiex_scan_specific_ssid(priv, ioctl_req,
-							    &scan->param.
-							    scan_req.scan_ssid);
-			break;
-		case MWIFIEX_OID_SCAN_USER_CONFIG:
-			status = mwifiex_scan_networks(priv, ioctl_req,
-						(struct mwifiex_user_scan_cfg *)
-						scan->param.user_scan.
-						scan_cfg_buf);
-			break;
-		default:
-			status = MWIFIEX_STATUS_FAILURE;
-			break;
-		}
-
-		if (status == MWIFIEX_STATUS_SUCCESS) {
-			PRINTM(MINFO, "mwifiex_scan_ioctl: return "
-					"MWIFIEX_STATUS_PENDING\n");
-			status = MWIFIEX_STATUS_PENDING;
-		}
-	}
-	/* Get scan */
-	else {
-		if (scan->sub_command == MWIFIEX_OID_SCAN_SPECIFIC_SSID) {
-			scan->param.scan_resp.num_in_scan_table =
-				adapter->num_in_scan_table;
-			scan->param.scan_resp.scan_table =
-				(u8 *) &priv->curr_bss_params.
-				bss_descriptor;
-			ioctl_req->data_read_written =
-				sizeof(struct mwifiex_scan_resp) +
-				MWIFIEX_SUB_COMMAND_SIZE;
-		} else {
-			scan->param.scan_resp.scan_table =
-				(u8 *) adapter->scan_table;
-			scan->param.scan_resp.num_in_scan_table =
-				adapter->num_in_scan_table;
-			ioctl_req->data_read_written =
-				sizeof(struct mwifiex_scan_resp) +
-				MWIFIEX_SUB_COMMAND_SIZE;
-		}
-	}
-
-	LEAVE();
-	return status;
-}
-
-/*
- * Top level IOCTL request handler.
- *
- * This is the entry point for all IOCTL requests to be handled.
- * Every IOCTL is put under a specific group and this function
- * calls the respective group handler based upon the type.
- *
- * The following IOCTL groups are supported -
- *      MWIFIEX_IOCTL_SCAN - Scan related IOCTLs
- *      MWIFIEX_IOCTL_BSS - BSS related IOCTLs
- *      MWIFIEX_IOCTL_RADIO_CFG - Radio configuration IOCTLs
- *      MWIFIEX_IOCTL_SNMP_MIB - SNMB MIB IOCTLs
- *      MWIFIEX_IOCTL_GET_INFO - Various GET information IOCTLs
- *      MWIFIEX_IOCTL_SEC_CFG - Security related IOCTLs
- *      MWIFIEX_IOCTL_RATE - Rate related IOCTLs
- *      MWIFIEX_IOCTL_POWER_CFG - Power configuration IOCTLs
- *      MWIFIEX_IOCTL_PM_CFG - Power management IOCTLs
- *      MWIFIEX_IOCTL_WMM_CFG - WMM related IOCTLs
- *      MWIFIEX_IOCTL_11N_CFG - 11N related IOCTLs
- *      MWIFIEX_IOCTL_REG_MEM - Register access IOCTLs
- *      MWIFIEX_IOCTL_MISC_CFG - Other miscellaneous IOCTLs
- */
-enum mwifiex_status
-mwifiex_sta_ioctl(struct mwifiex_adapter *adapter,
-			struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
-
-	ENTER();
-
-	switch (ioctl_req->req_id) {
-	case MWIFIEX_IOCTL_SCAN:
-		status = mwifiex_scan_ioctl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_IOCTL_BSS:
-		status = mwifiex_bss_ioctl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_IOCTL_RADIO_CFG:
-		status = mwifiex_radio_ioctl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_IOCTL_SNMP_MIB:
-		status = mwifiex_snmp_mib_ioctl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_IOCTL_GET_INFO:
-		status = mwifiex_get_info_ioctl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_IOCTL_SEC_CFG:
-		status = mwifiex_sec_cfg_ioctl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_IOCTL_RATE:
-		status = mwifiex_rate_ioctl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_IOCTL_POWER_CFG:
-		status = mwifiex_power_ioctl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_IOCTL_PM_CFG:
-		status = mwifiex_pm_ioctl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_IOCTL_WMM_CFG:
-		status = mwifiex_wmm_cfg_ioctl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_IOCTL_11N_CFG:
-		status = mwifiex_11n_cfg_ioctl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_IOCTL_REG_MEM:
-		status = mwifiex_reg_mem_ioctl(adapter, ioctl_req);
-		break;
-	case MWIFIEX_IOCTL_MISC_CFG:
-		status = mwifiex_misc_cfg_ioctl(adapter, ioctl_req);
-		break;
-	default:
-		status = MWIFIEX_STATUS_FAILURE;
-		break;
-	}
-	LEAVE();
-	return status;
-}
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 0751536..ac7b492 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -63,38 +63,6 @@ mwifiex_shutdown_fw_complete(struct mwifiex_adapter *adapter)
 }
 
 /*
- * IOCTL request handler to send a host command to firmware.
- *
- * This function prepares the correct firmware command and
- * issues it.
- */
-enum mwifiex_status
-mwifiex_misc_ioctl_host_cmd(struct mwifiex_adapter *adapter,
-			    struct mwifiex_ioctl_req *ioctl_req)
-{
-	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
-	struct mwifiex_ds_misc_cfg *misc = NULL;
-
-	ENTER();
-
-	misc = (struct mwifiex_ds_misc_cfg *) ioctl_req->buffer;
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  0,
-				  0,
-				  0,
-				  (void *) ioctl_req,
-				  (void *) &misc->param.hostcmd);
-	if (ret == MWIFIEX_STATUS_SUCCESS)
-		ret = MWIFIEX_STATUS_PENDING;
-
-	LEAVE();
-	return ret;
-}
-
-/*
  * IOCTL request handler to send function init/shutdown command
  * to firmware.
  *
@@ -103,31 +71,28 @@ mwifiex_misc_ioctl_host_cmd(struct mwifiex_adapter *adapter,
  */
 enum mwifiex_status
 mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
-				 struct mwifiex_ioctl_req *ioctl_req)
+				 struct mwifiex_wait_queue *wait,
+				 u32 func_init_shutdown)
 {
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
+	struct mwifiex_private *priv = adapter->priv[wait->bss_index];
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_misc_cfg *misc_cfg = NULL;
 	u16 cmd;
 
 	ENTER();
 
-	misc_cfg = (struct mwifiex_ds_misc_cfg *) ioctl_req->buffer;
-	if (misc_cfg->param.func_init_shutdown == MWIFIEX_FUNC_INIT)
+	if (func_init_shutdown == MWIFIEX_FUNC_INIT) {
 		cmd = HostCmd_CMD_FUNC_INIT;
-	else if (misc_cfg->param.func_init_shutdown == MWIFIEX_FUNC_SHUTDOWN)
+	} else if (func_init_shutdown == MWIFIEX_FUNC_SHUTDOWN) {
 		cmd = HostCmd_CMD_FUNC_SHUTDOWN;
-	else {
+	} else {
 		PRINTM(MERROR, "Unsupported parameter\n");
 		ret = MWIFIEX_STATUS_FAILURE;
 		goto exit;
 	}
 
 	/* Send command to firmware */
-	ret = mwifiex_prepare_cmd(priv,
-				  cmd,
-				  HostCmd_ACT_GEN_SET,
-				  0, (void *) ioctl_req, NULL);
+	ret = mwifiex_prepare_cmd(priv, cmd, HostCmd_ACT_GEN_SET,
+				  0, wait, NULL);
 
 	if (ret == MWIFIEX_STATUS_SUCCESS)
 		ret = MWIFIEX_STATUS_PENDING;
@@ -144,99 +109,69 @@ exit:
  * structures.
  */
 enum mwifiex_status
-mwifiex_get_info_debug_info(struct mwifiex_adapter *adapter,
-			    struct mwifiex_ioctl_req *ioctl_req)
+mwifiex_get_debug_info(struct mwifiex_private *priv,
+			    struct mwifiex_debug_info *info)
 {
-	struct mwifiex_private *priv = adapter->priv[ioctl_req->bss_index];
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	struct mwifiex_ds_get_info *info;
+	struct mwifiex_adapter *adapter = priv->adapter;
 
 	ENTER();
 
-	info = (struct mwifiex_ds_get_info *) ioctl_req->buffer;
-
-	if (ioctl_req->action == MWIFIEX_ACT_GET) {
-		memcpy(info->param.debug_info.packets_out,
+	if (info) {
+		memcpy(info->packets_out,
 		       priv->wmm.packets_out,
 		       sizeof(priv->wmm.packets_out));
-		info->param.debug_info.max_tx_buf_size =
-			(u32) adapter->max_tx_buf_size;
-		info->param.debug_info.tx_buf_size =
-			(u32) adapter->tx_buf_size;
-		info->param.debug_info.rx_tbl_num =
-			mwifiex_get_rx_reorder_tbl(priv,
-						  info->param.debug_info.
-						  rx_tbl);
-		info->param.debug_info.tx_tbl_num =
-			mwifiex_get_tx_ba_stream_tbl(priv,
-						   info->param.debug_info.
-						   tx_tbl);
-		info->param.debug_info.ps_mode = adapter->ps_mode;
-		info->param.debug_info.ps_state = adapter->ps_state;
-		info->param.debug_info.is_deep_sleep = adapter->is_deep_sleep;
-
-		info->param.debug_info.pm_wakeup_card_req =
-			adapter->pm_wakeup_card_req;
-		info->param.debug_info.pm_wakeup_fw_try =
-			adapter->pm_wakeup_fw_try;
-		info->param.debug_info.is_hs_configured =
-			adapter->is_hs_configured;
-		info->param.debug_info.hs_activated = adapter->hs_activated;
-
-		info->param.debug_info.num_cmd_host_to_card_failure
+		info->max_tx_buf_size = (u32) adapter->max_tx_buf_size;
+		info->tx_buf_size = (u32) adapter->tx_buf_size;
+		info->rx_tbl_num = mwifiex_get_rx_reorder_tbl(
+					priv, info->rx_tbl);
+		info->tx_tbl_num = mwifiex_get_tx_ba_stream_tbl(
+					priv, info->tx_tbl);
+		info->ps_mode = adapter->ps_mode;
+		info->ps_state = adapter->ps_state;
+		info->is_deep_sleep = adapter->is_deep_sleep;
+		info->pm_wakeup_card_req = adapter->pm_wakeup_card_req;
+		info->pm_wakeup_fw_try = adapter->pm_wakeup_fw_try;
+		info->is_hs_configured = adapter->is_hs_configured;
+		info->hs_activated = adapter->hs_activated;
+		info->num_cmd_host_to_card_failure
 			= adapter->dbg.num_cmd_host_to_card_failure;
-		info->param.debug_info.num_cmd_sleep_cfm_host_to_card_failure
+		info->num_cmd_sleep_cfm_host_to_card_failure
 			= adapter->dbg.num_cmd_sleep_cfm_host_to_card_failure;
-		info->param.debug_info.num_tx_host_to_card_failure
+		info->num_tx_host_to_card_failure
 			= adapter->dbg.num_tx_host_to_card_failure;
-		info->param.debug_info.num_event_deauth =
-			adapter->dbg.num_event_deauth;
-		info->param.debug_info.num_event_disassoc =
-			adapter->dbg.num_event_disassoc;
-		info->param.debug_info.num_event_link_lost =
-			adapter->dbg.num_event_link_lost;
-		info->param.debug_info.num_cmd_deauth =
-			adapter->dbg.num_cmd_deauth;
-		info->param.debug_info.num_cmd_assoc_success =
+		info->num_event_deauth = adapter->dbg.num_event_deauth;
+		info->num_event_disassoc = adapter->dbg.num_event_disassoc;
+		info->num_event_link_lost = adapter->dbg.num_event_link_lost;
+		info->num_cmd_deauth = adapter->dbg.num_cmd_deauth;
+		info->num_cmd_assoc_success =
 			adapter->dbg.num_cmd_assoc_success;
-		info->param.debug_info.num_cmd_assoc_failure =
+		info->num_cmd_assoc_failure =
 			adapter->dbg.num_cmd_assoc_failure;
-		info->param.debug_info.num_tx_timeout =
-			adapter->dbg.num_tx_timeout;
-		info->param.debug_info.num_cmd_timeout =
-			adapter->dbg.num_cmd_timeout;
-		info->param.debug_info.timeout_cmd_id =
-			adapter->dbg.timeout_cmd_id;
-		info->param.debug_info.timeout_cmd_act =
-			adapter->dbg.timeout_cmd_act;
-		memcpy(info->param.debug_info.last_cmd_id,
+		info->num_tx_timeout = adapter->dbg.num_tx_timeout;
+		info->num_cmd_timeout = adapter->dbg.num_cmd_timeout;
+		info->timeout_cmd_id = adapter->dbg.timeout_cmd_id;
+		info->timeout_cmd_act = adapter->dbg.timeout_cmd_act;
+		memcpy(info->last_cmd_id,
 		       adapter->dbg.last_cmd_id,
 		       sizeof(adapter->dbg.last_cmd_id));
-		memcpy(info->param.debug_info.last_cmd_act,
+		memcpy(info->last_cmd_act,
 		       adapter->dbg.last_cmd_act,
 		       sizeof(adapter->dbg.last_cmd_act));
-		info->param.debug_info.last_cmd_index =
-			adapter->dbg.last_cmd_index;
-		memcpy(info->param.debug_info.last_cmd_resp_id,
+		info->last_cmd_index = adapter->dbg.last_cmd_index;
+		memcpy(info->last_cmd_resp_id,
 		       adapter->dbg.last_cmd_resp_id,
 		       sizeof(adapter->dbg.last_cmd_resp_id));
-		info->param.debug_info.last_cmd_resp_index =
-			adapter->dbg.last_cmd_resp_index;
-		memcpy(info->param.debug_info.last_event,
+		info->last_cmd_resp_index = adapter->dbg.last_cmd_resp_index;
+		memcpy(info->last_event,
 		       adapter->dbg.last_event,
 		       sizeof(adapter->dbg.last_event));
-		info->param.debug_info.last_event_index =
-			adapter->dbg.last_event_index;
-
-		info->param.debug_info.data_sent = adapter->data_sent;
-		info->param.debug_info.cmd_sent = adapter->cmd_sent;
-		info->param.debug_info.cmd_resp_received =
-			adapter->cmd_resp_received;
+		info->last_event_index = adapter->dbg.last_event_index;
+		info->data_sent = adapter->data_sent;
+		info->cmd_sent = adapter->cmd_sent;
+		info->cmd_resp_received = adapter->cmd_resp_received;
 	}
 
-	ioctl_req->data_read_written =
-		sizeof(struct mwifiex_debug_info) + MWIFIEX_SUB_COMMAND_SIZE;
-
 	LEAVE();
 	return ret;
 }
@@ -344,93 +279,6 @@ mwifiex_print(u32 level, s8 *pformat, ...)
 EXPORT_SYMBOL_GPL(mwifiex_print);
 
 /*
- * This function handles get BSS information IOCTL responses.
- *
- * The following information type is currently supported -
- *      - MWIFIEX_OID_BSS_MODE : BSS mode (Infra or Ad-hoc or auto)
- */
-static void
-mwifiex_ioctl_get_bss_resp(struct mwifiex_private *priv,
-			   struct mwifiex_ds_bss *bss)
-{
-	u32 mode = 0;
-
-	ENTER();
-
-	switch (bss->sub_command) {
-	case MWIFIEX_OID_BSS_MODE:
-		if (bss->param.bss_mode == MWIFIEX_BSS_MODE_INFRA)
-			mode = IW_MODE_INFRA;
-		else if (bss->param.bss_mode == MWIFIEX_BSS_MODE_IBSS)
-			mode = IW_MODE_ADHOC;
-		else
-			mode = IW_MODE_AUTO;
-		priv->w_stats.status = mode;
-		break;
-	default:
-		break;
-	}
-
-	LEAVE();
-	return;
-}
-
-/*
- * This function handles get driver information IOCTL responses.
- *
- * The following information type is currently supported -
- *      - MWIFIEX_OID_GET_SIGNAL : Signal quality level and noise
- */
-static void
-mwifiex_ioctl_get_info_resp(struct mwifiex_private *priv,
-			    struct mwifiex_ds_get_info *info)
-{
-	ENTER();
-	switch (info->sub_command) {
-	case MWIFIEX_OID_GET_SIGNAL:
-		if (info->param.signal.selector & BCN_RSSI_AVG_MASK)
-			priv->w_stats.qual.level =
-				info->param.signal.bcn_rssi_avg;
-		if (info->param.signal.selector & BCN_NF_AVG_MASK)
-			priv->w_stats.qual.noise =
-				info->param.signal.bcn_nf_avg;
-		break;
-	default:
-		break;
-	}
-	LEAVE();
-}
-
-/*
- * This function handles IOCTL responses.
- *
- * The following IOCTL responses are supported -
- *      - MWIFIEX_IOCTL_GET_INFO : Get driver information
- *      - MWIFIEX_IOCTL_BSS      : Get BSS information
- */
-void
-mwifiex_process_ioctl_resp(struct mwifiex_private *priv,
-			   struct mwifiex_ioctl_req *req)
-{
-	ENTER();
-
-	switch (req->req_id) {
-	case MWIFIEX_IOCTL_GET_INFO:
-		mwifiex_ioctl_get_info_resp(priv,
-				(struct mwifiex_ds_get_info *) req->buffer);
-		break;
-	case MWIFIEX_IOCTL_BSS:
-		mwifiex_ioctl_get_bss_resp(priv,
-				(struct mwifiex_ds_bss *) req->buffer);
-	default:
-		break;
-	}
-
-	LEAVE();
-	return;
-}
-
-/*
  * IOCTL completion callback handler.
  *
  * This function is called when a pending IOCTL is completed.
@@ -441,49 +289,36 @@ mwifiex_process_ioctl_resp(struct mwifiex_private *priv,
  */
 enum mwifiex_status
 mwifiex_ioctl_complete(struct mwifiex_adapter *adapter,
-		       struct mwifiex_ioctl_req *ioctl_req,
+		       struct mwifiex_wait_queue *wait_queue,
 		       enum mwifiex_status status)
 {
-	struct mwifiex_private *priv = NULL;
-
+	enum mwifiex_error_code status_code =
+		(enum mwifiex_error_code) wait_queue->status;
 	ENTER();
 
 	atomic_dec(&adapter->ioctl_pending);
-	priv = mwifiex_bss_index_to_priv(adapter, ioctl_req->bss_index);
-	if (priv == NULL) {
-		PRINTM(MERROR, "%s: priv is null\n", __func__);
-		kfree(ioctl_req);
-		goto done;
-	}
 
 	PRINTM(MCMND,
-	       "IOCTL completed: id=0x%lx action=%d,  status=%d, "
-	       "status_code=0x%lx\n",
-	       ioctl_req->req_id, (int) ioctl_req->action, status,
-	       ioctl_req->status_code);
-
-	if (ioctl_req->wq.enabled) {
-		*ioctl_req->wq.condition = true;
-		ioctl_req->wq.status = status;
+	       "IOCTL completed: status=%d, status_code=0x%lx\n",
+			status, status_code);
+
+	if (wait_queue->enabled) {
+		*wait_queue->condition = true;
+		wait_queue->status = status;
 		if ((status != MWIFIEX_STATUS_SUCCESS) &&
-		    (ioctl_req->status_code == MWIFIEX_ERROR_CMD_TIMEOUT)) {
+		    (status_code == MWIFIEX_ERROR_CMD_TIMEOUT)) {
 			PRINTM(MERROR, "IOCTL: command timeout\n");
 		} else {
-			wake_up_interruptible(ioctl_req->wq.wait);
+			wake_up_interruptible(wait_queue->wait);
 		}
 	} else {
-		if ((status == MWIFIEX_STATUS_SUCCESS) &&
-		    (ioctl_req->action == MWIFIEX_ACT_GET))
-			mwifiex_process_ioctl_resp(priv, ioctl_req);
 		if (status != MWIFIEX_STATUS_SUCCESS)
 			PRINTM(MERROR,
-			       "IOCTL failed: id=0x%lx, action=%d, "
-			       "status_code=0x%lx\n",
-			       ioctl_req->req_id, (int) ioctl_req->action,
-			       ioctl_req->status_code);
-		kfree(ioctl_req);
+			       "IOCTL failed: status_code=0x%lx\n",
+			       status_code);
+		kfree(wait_queue);
 	}
-done:
+
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
 }
-- 
1.7.0.2

