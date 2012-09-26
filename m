Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:42022 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab2IZD31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:29:27 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 09/15] mwifiex: send firmware initialization commands synchronously
Date: Tue, 25 Sep 2012 20:23:39 -0700
Message-Id: <1348629825-12001-10-git-send-email-bzhao@marvell.com> (sfid-20120926_052929_990325_E4B3953D)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

The driver will send some commands to firmware during the
initialization. Currently these commands are sent asynchronously,
which means that we firstly insert all of them to a pre-allocated
command queue, and then start to process them one by one. The
command queue will soon be exhausted if we keep adding new
initialization commands.

This issue can be resolved by sending initialization commands
synchronously because each command is consumed and the buffer is
recycled before queuing next command.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmd.c |   65 ++++++++++++++++----------------
 1 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 0252446..c2198a7 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1302,35 +1302,35 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 
 	if (first_sta) {
 		if (priv->adapter->iface_type == MWIFIEX_PCIE) {
-			ret = mwifiex_send_cmd_async(priv,
+			ret = mwifiex_send_cmd_sync(priv,
 						HostCmd_CMD_PCIE_DESC_DETAILS,
 						HostCmd_ACT_GEN_SET, 0, NULL);
 			if (ret)
 				return -1;
 		}
 
-		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_FUNC_INIT,
-					     HostCmd_ACT_GEN_SET, 0, NULL);
+		ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_FUNC_INIT,
+					    HostCmd_ACT_GEN_SET, 0, NULL);
 		if (ret)
 			return -1;
 		/* Read MAC address from HW */
-		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_GET_HW_SPEC,
-					     HostCmd_ACT_GEN_GET, 0, NULL);
+		ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_GET_HW_SPEC,
+					    HostCmd_ACT_GEN_GET, 0, NULL);
 		if (ret)
 			return -1;
 
 		/* Reconfigure tx buf size */
-		ret = mwifiex_send_cmd_async(priv,
-					     HostCmd_CMD_RECONFIGURE_TX_BUFF,
-					     HostCmd_ACT_GEN_SET, 0,
-					     &priv->adapter->tx_buf_size);
+		ret = mwifiex_send_cmd_sync(priv,
+					    HostCmd_CMD_RECONFIGURE_TX_BUFF,
+					    HostCmd_ACT_GEN_SET, 0,
+					    &priv->adapter->tx_buf_size);
 		if (ret)
 			return -1;
 
 		if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
 			/* Enable IEEE PS by default */
 			priv->adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
-			ret = mwifiex_send_cmd_async(
+			ret = mwifiex_send_cmd_sync(
 					priv, HostCmd_CMD_802_11_PS_MODE_ENH,
 					EN_AUTO_PS, BITMAP_STA_PS, NULL);
 			if (ret)
@@ -1339,21 +1339,21 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	}
 
 	/* get tx rate */
-	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_TX_RATE_CFG,
-				     HostCmd_ACT_GEN_GET, 0, NULL);
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_TX_RATE_CFG,
+				    HostCmd_ACT_GEN_GET, 0, NULL);
 	if (ret)
 		return -1;
 	priv->data_rate = 0;
 
 	/* get tx power */
-	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_RF_TX_PWR,
-				     HostCmd_ACT_GEN_GET, 0, NULL);
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_RF_TX_PWR,
+				    HostCmd_ACT_GEN_GET, 0, NULL);
 	if (ret)
 		return -1;
 
 	if (priv->bss_type == MWIFIEX_BSS_TYPE_STA) {
 		/* set ibss coalescing_status */
-		ret = mwifiex_send_cmd_async(
+		ret = mwifiex_send_cmd_sync(
 				priv, HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
 				HostCmd_ACT_GEN_SET, 0, &enable);
 		if (ret)
@@ -1363,16 +1363,16 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	memset(&amsdu_aggr_ctrl, 0, sizeof(amsdu_aggr_ctrl));
 	amsdu_aggr_ctrl.enable = true;
 	/* Send request to firmware */
-	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_AMSDU_AGGR_CTRL,
-				     HostCmd_ACT_GEN_SET, 0,
-				     &amsdu_aggr_ctrl);
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_AMSDU_AGGR_CTRL,
+				    HostCmd_ACT_GEN_SET, 0,
+				    &amsdu_aggr_ctrl);
 	if (ret)
 		return -1;
 	/* MAC Control must be the last command in init_fw */
 	/* set MAC Control */
-	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
-				     HostCmd_ACT_GEN_SET, 0,
-				     &priv->curr_pkt_filter);
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_MAC_CONTROL,
+				    HostCmd_ACT_GEN_SET, 0,
+				    &priv->curr_pkt_filter);
 	if (ret)
 		return -1;
 
@@ -1381,10 +1381,10 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 		/* Enable auto deep sleep */
 		auto_ds.auto_ds = DEEP_SLEEP_ON;
 		auto_ds.idle_time = DEEP_SLEEP_IDLE_TIME;
-		ret = mwifiex_send_cmd_async(priv,
-					     HostCmd_CMD_802_11_PS_MODE_ENH,
-					     EN_AUTO_PS, BITMAP_AUTO_DS,
-					     &auto_ds);
+		ret = mwifiex_send_cmd_sync(priv,
+					    HostCmd_CMD_802_11_PS_MODE_ENH,
+					    EN_AUTO_PS, BITMAP_AUTO_DS,
+					    &auto_ds);
 		if (ret)
 			return -1;
 	}
@@ -1392,23 +1392,24 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
 		/* Send cmd to FW to enable/disable 11D function */
 		state_11d = ENABLE_11D;
-		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11_SNMP_MIB,
-					     HostCmd_ACT_GEN_SET, DOT11D_I,
-					     &state_11d);
+		ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
+					    HostCmd_ACT_GEN_SET, DOT11D_I,
+					    &state_11d);
 		if (ret)
 			dev_err(priv->adapter->dev,
 				"11D: failed to enable 11D\n");
 	}
 
+	/* set last_init_cmd before sending the command */
+	priv->adapter->last_init_cmd = HostCmd_CMD_11N_CFG;
+
 	/* Send cmd to FW to configure 11n specific configuration
 	 * (Short GI, Channel BW, Green field support etc.) for transmit
 	 */
 	tx_cfg.tx_htcap = MWIFIEX_FW_DEF_HTTXCFG;
-	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_CFG,
-				     HostCmd_ACT_GEN_SET, 0, &tx_cfg);
+	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_11N_CFG,
+				    HostCmd_ACT_GEN_SET, 0, &tx_cfg);
 
-	/* set last_init_cmd */
-	priv->adapter->last_init_cmd = HostCmd_CMD_11N_CFG;
 	ret = -EINPROGRESS;
 
 	return ret;
-- 
1.7.0.2

