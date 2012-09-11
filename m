Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:57444 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756649Ab2IKBbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 21:31:39 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 02/10] mwifiex: remove 11N_CFG command response handler
Date: Mon, 10 Sep 2012 18:30:41 -0700
Message-Id: <1347327049-13665-3-git-send-email-bzhao@marvell.com> (sfid-20120911_033142_663603_75A16608)
In-Reply-To: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
References: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

HostCmd_CMD_11N_CFG is never called with GET action. So the code in
mwifiex_ret_11n_cfg() becomes redundant.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c         |   17 -----------------
 drivers/net/wireless/mwifiex/11n.h         |    2 --
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    1 -
 3 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index d273273..754b554 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -176,23 +176,6 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 }
 
 /*
- * This function handles the command response of 11n configuration request.
- *
- * Handling includes changing the header fields into CPU format.
- */
-int mwifiex_ret_11n_cfg(struct host_cmd_ds_command *resp,
-			struct mwifiex_ds_11n_tx_cfg *tx_cfg)
-{
-	struct host_cmd_ds_11n_cfg *htcfg = &resp->params.htcfg;
-
-	if (tx_cfg) {
-		tx_cfg->tx_htcap = le16_to_cpu(htcfg->ht_tx_cap);
-		tx_cfg->tx_htinfo = le16_to_cpu(htcfg->ht_tx_info);
-	}
-	return 0;
-}
-
-/*
  * This function prepares command of reconfigure Tx buffer.
  *
  * Preparation includes -
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 67c087c..dbcf384 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -28,8 +28,6 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 			  struct host_cmd_ds_command *resp);
 int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp);
-int mwifiex_ret_11n_cfg(struct host_cmd_ds_command *resp,
-			struct mwifiex_ds_11n_tx_cfg *tx_cfg);
 int mwifiex_cmd_11n_cfg(struct host_cmd_ds_command *cmd, u16 cmd_action,
 			struct mwifiex_ds_11n_tx_cfg *txcfg);
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 364b608..3addf76 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -928,7 +928,6 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_SET_BSS_MODE:
 		break;
 	case HostCmd_CMD_11N_CFG:
-		ret = mwifiex_ret_11n_cfg(resp, data_buf);
 		break;
 	case HostCmd_CMD_PCIE_DESC_DETAILS:
 		break;
-- 
1.7.0.2

