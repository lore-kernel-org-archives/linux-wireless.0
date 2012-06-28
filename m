Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:38779 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932236Ab2F1C7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 22:59:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: use correct firmware command to get power limits
Date: Wed, 27 Jun 2012 19:57:57 -0700
Message-Id: <1340852279-24964-3-git-send-email-bzhao@marvell.com> (sfid-20120628_045925_846051_E41F547E)
In-Reply-To: <1340852279-24964-1-git-send-email-bzhao@marvell.com>
References: <1340852279-24964-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

"priv->max_tx_power_level" and "priv->min_tx_power_level" variables
are initialized to maximum and minimum power levels supported by
hardware by sending correct firmware command.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h          |    9 +++++++++
 drivers/net/wireless/mwifiex/sta_cmd.c     |   23 ++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   27 +++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 1184141..ffb6cdf 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -226,6 +226,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_RF_REG_ACCESS                     0x001b
 #define HostCmd_CMD_PMIC_REG_ACCESS                   0x00ad
 #define HostCmd_CMD_802_11_RF_CHANNEL                 0x001d
+#define HostCmd_CMD_RF_TX_PWR                         0x001e
 #define HostCmd_CMD_802_11_DEAUTHENTICATE             0x0024
 #define HostCmd_CMD_MAC_CONTROL                       0x0028
 #define HostCmd_CMD_802_11_AD_HOC_START               0x002b
@@ -876,6 +877,13 @@ struct host_cmd_ds_txpwr_cfg {
 	__le32 mode;
 } __packed;
 
+struct host_cmd_ds_rf_tx_pwr {
+	__le16 action;
+	__le16 cur_level;
+	u8 max_power;
+	u8 min_power;
+} __packed;
+
 struct mwifiex_bcn_param {
 	u8 bssid[ETH_ALEN];
 	u8 rssi;
@@ -1361,6 +1369,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_tx_rate_query tx_rate;
 		struct host_cmd_ds_tx_rate_cfg tx_rate_cfg;
 		struct host_cmd_ds_txpwr_cfg txp_cfg;
+		struct host_cmd_ds_rf_tx_pwr txp;
 		struct host_cmd_ds_802_11_ps_mode_enh psmode_enh;
 		struct host_cmd_ds_802_11_hs_cfg_enh opt_hs_cfg;
 		struct host_cmd_ds_802_11_scan scan;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 40e025d..2d4319a 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -260,6 +260,23 @@ static int mwifiex_cmd_tx_power_cfg(struct host_cmd_ds_command *cmd,
 }
 
 /*
+ * This function prepares command to get RF Tx power.
+ */
+static int mwifiex_cmd_rf_tx_power(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *cmd,
+				   u16 cmd_action, void *data_buf)
+{
+	struct host_cmd_ds_rf_tx_pwr *txp = &cmd->params.txp;
+
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_rf_tx_pwr)
+				+ S_DS_GEN);
+	cmd->command = cpu_to_le16(HostCmd_CMD_RF_TX_PWR);
+	txp->action = cpu_to_le16(cmd_action);
+
+	return 0;
+}
+
+/*
  * This function prepares command to set Host Sleep configuration.
  *
  * Preparation includes -
@@ -1055,6 +1072,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_tx_power_cfg(cmd_ptr, cmd_action,
 					       data_buf);
 		break;
+	case HostCmd_CMD_RF_TX_PWR:
+		ret = mwifiex_cmd_rf_tx_power(priv, cmd_ptr, cmd_action,
+					      data_buf);
+		break;
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
 		ret = mwifiex_cmd_enh_power_mode(priv, cmd_ptr, cmd_action,
 						 (uint16_t)cmd_oid, data_buf);
@@ -1283,7 +1304,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	priv->data_rate = 0;
 
 	/* get tx power */
-	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_TXPWR_CFG,
+	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_RF_TX_PWR,
 				     HostCmd_ACT_GEN_GET, 0, NULL);
 	if (ret)
 		return -1;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index a79ed9b..4cb2c1c 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -451,6 +451,30 @@ static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 }
 
 /*
+ * This function handles the command response of get RF Tx power.
+ */
+static int mwifiex_ret_rf_tx_power(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_rf_tx_pwr *txp = &resp->params.txp;
+	u16 action = le16_to_cpu(txp->action);
+
+	priv->tx_power_level = le16_to_cpu(txp->cur_level);
+
+	if (action == HostCmd_ACT_GEN_GET) {
+		priv->max_tx_power_level = txp->max_power;
+		priv->min_tx_power_level = txp->min_power;
+	}
+
+	dev_dbg(priv->adapter->dev,
+		"Current TxPower Level=%d, Max Power=%d, Min Power=%d\n",
+		priv->tx_power_level, priv->max_tx_power_level,
+		priv->min_tx_power_level);
+
+	return 0;
+}
+
+/*
  * This function handles the command response of set/get MAC address.
  *
  * Handling includes saving the MAC address in driver.
@@ -847,6 +871,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_TXPWR_CFG:
 		ret = mwifiex_ret_tx_power_cfg(priv, resp);
 		break;
+	case HostCmd_CMD_RF_TX_PWR:
+		ret = mwifiex_ret_rf_tx_power(priv, resp);
+		break;
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
 		ret = mwifiex_ret_enh_power_mode(priv, resp, data_buf);
 		break;
-- 
1.7.0.2

