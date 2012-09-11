Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:45770 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756998Ab2IKBbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 21:31:44 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 03/10] mwifiex: remove AMSDU_AGGR_CTRL command response handler
Date: Mon, 10 Sep 2012 18:30:42 -0700
Message-Id: <1347327049-13665-4-git-send-email-bzhao@marvell.com> (sfid-20120911_033147_298094_11F2EFD9)
In-Reply-To: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
References: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

HostCmd_CMD_AMSDU_AGGR_CTRL is never called with GET action.
So the code in mwifiex_ret_amsdu_aggr_ctrl() becomes redundant.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c         |   21 ---------------------
 drivers/net/wireless/mwifiex/11n.h         |    3 ---
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    1 -
 3 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 754b554..245a371 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -241,27 +241,6 @@ int mwifiex_cmd_amsdu_aggr_ctrl(struct host_cmd_ds_command *cmd,
 }
 
 /*
- * This function handles the command response of AMSDU aggregation
- * control request.
- *
- * Handling includes changing the header fields into CPU format.
- */
-int mwifiex_ret_amsdu_aggr_ctrl(struct host_cmd_ds_command *resp,
-				struct mwifiex_ds_11n_amsdu_aggr_ctrl
-				*amsdu_aggr_ctrl)
-{
-	struct host_cmd_ds_amsdu_aggr_ctrl *amsdu_ctrl =
-		&resp->params.amsdu_aggr_ctrl;
-
-	if (amsdu_aggr_ctrl) {
-		amsdu_aggr_ctrl->enable = le16_to_cpu(amsdu_ctrl->enable);
-		amsdu_aggr_ctrl->curr_buf_size =
-			le16_to_cpu(amsdu_ctrl->curr_buf_size);
-	}
-	return 0;
-}
-
-/*
  * This function prepares 11n configuration command.
  *
  * Preparation includes -
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index dbcf384..46006a5 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -58,9 +58,6 @@ int mwifiex_get_rx_reorder_tbl(struct mwifiex_private *priv,
 			      struct mwifiex_ds_rx_reorder_tbl *buf);
 int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 			       struct mwifiex_ds_tx_ba_stream_tbl *buf);
-int mwifiex_ret_amsdu_aggr_ctrl(struct host_cmd_ds_command *resp,
-				struct mwifiex_ds_11n_amsdu_aggr_ctrl
-				*amsdu_aggr_ctrl);
 int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
 			     struct host_cmd_ds_command *cmd,
 			     int cmd_action, u16 *buf_size);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 3addf76..31f80e1 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -909,7 +909,6 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 				le16_to_cpu(resp->params.tx_buf.mp_end_port));
 		break;
 	case HostCmd_CMD_AMSDU_AGGR_CTRL:
-		ret = mwifiex_ret_amsdu_aggr_ctrl(resp, data_buf);
 		break;
 	case HostCmd_CMD_WMM_GET_STATUS:
 		ret = mwifiex_ret_wmm_get_status(priv, resp);
-- 
1.7.0.2

