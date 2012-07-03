Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:36165 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750920Ab2GCCdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 22:33:25 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: add set_antenna handler support
Date: Mon,  2 Jul 2012 19:32:33 -0700
Message-Id: <1341282753-2013-1-git-send-email-bzhao@marvell.com> (sfid-20120703_043329_896329_60AD5738)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This enables user to set mode of Tx/Rx path using "iw set antenna"
command. For non MIMO chips, the command will be used for selecting
specific antenna or configuring antenna diversity mode.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |   40 ++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/fw.h          |   21 ++++++++++++++
 drivers/net/wireless/mwifiex/ioctl.h       |    5 +++
 drivers/net/wireless/mwifiex/sta_cmd.c     |   37 +++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   30 +++++++++++++++++++++
 5 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 647ade3..3875b1a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -941,6 +941,42 @@ static int mwifiex_cfg80211_change_beacon(struct wiphy *wiphy,
 	return 0;
 }
 
+static int
+mwifiex_cfg80211_set_antenna(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant)
+{
+	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
+	struct mwifiex_private *priv = mwifiex_get_priv(adapter,
+							MWIFIEX_BSS_ROLE_ANY);
+	struct mwifiex_ds_ant_cfg ant_cfg;
+
+	if (!tx_ant || !rx_ant)
+		return -EOPNOTSUPP;
+
+	if (adapter->hw_dev_mcs_support != HT_STREAM_2X2) {
+		/* Not a MIMO chip. User should provide specific antenna number
+		 * for Tx/Rx path or enable all antennas for diversity
+		 */
+		if (tx_ant != rx_ant)
+			return -EOPNOTSUPP;
+
+		if ((tx_ant & (tx_ant - 1)) &&
+		    (tx_ant != BIT(adapter->number_of_antenna) - 1))
+			return -EOPNOTSUPP;
+
+		if ((tx_ant == BIT(adapter->number_of_antenna) - 1) &&
+		    (priv->adapter->number_of_antenna > 1)) {
+			tx_ant = RF_ANTENNA_AUTO;
+			rx_ant = RF_ANTENNA_AUTO;
+		}
+	}
+
+	ant_cfg.tx_ant = tx_ant;
+	ant_cfg.rx_ant = rx_ant;
+
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_RF_ANTENNA,
+				     HostCmd_ACT_GEN_SET, 0, &ant_cfg);
+}
+
 /* cfg80211 operation handler for stop ap.
  * Function stops BSS running at uAP interface.
  */
@@ -1725,6 +1761,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.stop_ap = mwifiex_cfg80211_stop_ap,
 	.change_beacon = mwifiex_cfg80211_change_beacon,
 	.set_cqm_rssi_config = mwifiex_cfg80211_set_cqm_rssi_config,
+	.set_antenna = mwifiex_cfg80211_set_antenna,
 };
 
 /*
@@ -1777,6 +1814,9 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2;
 
+	wiphy->available_antennas_tx = BIT(adapter->number_of_antenna) - 1;
+	wiphy->available_antennas_rx = BIT(adapter->number_of_antenna) - 1;
+
 	/* Reserve space for mwifiex specific private data for BSS */
 	wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index ffb6cdf..14e985d 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -227,6 +227,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_PMIC_REG_ACCESS                   0x00ad
 #define HostCmd_CMD_802_11_RF_CHANNEL                 0x001d
 #define HostCmd_CMD_RF_TX_PWR                         0x001e
+#define HostCmd_CMD_RF_ANTENNA                        0x0020
 #define HostCmd_CMD_802_11_DEAUTHENTICATE             0x0024
 #define HostCmd_CMD_MAC_CONTROL                       0x0028
 #define HostCmd_CMD_802_11_AD_HOC_START               0x002b
@@ -322,6 +323,12 @@ enum ENH_PS_MODES {
 
 #define HostCmd_BSS_TYPE_MASK           0xf000
 
+#define HostCmd_ACT_SET_RX              0x0001
+#define HostCmd_ACT_SET_TX              0x0002
+#define HostCmd_ACT_SET_BOTH            0x0003
+
+#define RF_ANTENNA_AUTO                 0xFFFF
+
 #define HostCmd_SET_SEQ_NO_BSS_INFO(seq, num, type) {   \
 	(((seq) & 0x00ff) |                             \
 	 (((num) & 0x000f) << 8)) |                     \
@@ -884,6 +891,18 @@ struct host_cmd_ds_rf_tx_pwr {
 	u8 min_power;
 } __packed;
 
+struct host_cmd_ds_rf_ant_mimo {
+	__le16 action_tx;
+	__le16 tx_ant_mode;
+	__le16 action_rx;
+	__le16 rx_ant_mode;
+};
+
+struct host_cmd_ds_rf_ant_siso {
+	__le16 action;
+	__le16 ant_mode;
+};
+
 struct mwifiex_bcn_param {
 	u8 bssid[ETH_ALEN];
 	u8 rssi;
@@ -1370,6 +1389,8 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_tx_rate_cfg tx_rate_cfg;
 		struct host_cmd_ds_txpwr_cfg txp_cfg;
 		struct host_cmd_ds_rf_tx_pwr txp;
+		struct host_cmd_ds_rf_ant_mimo ant_mimo;
+		struct host_cmd_ds_rf_ant_siso ant_siso;
 		struct host_cmd_ds_802_11_ps_mode_enh psmode_enh;
 		struct host_cmd_ds_802_11_hs_cfg_enh opt_hs_cfg;
 		struct host_cmd_ds_802_11_scan scan;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 9f088fb..e121294 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -277,6 +277,11 @@ struct mwifiex_ds_11n_amsdu_aggr_ctrl {
 	u16 curr_buf_size;
 };
 
+struct mwifiex_ds_ant_cfg {
+	u32 tx_ant;
+	u32 rx_ant;
+};
+
 #define MWIFIEX_NUM_OF_CMD_BUFFER	20
 #define MWIFIEX_SIZE_OF_CMD_BUFFER	2048
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 2d4319a..75eaa6f 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -277,6 +277,39 @@ static int mwifiex_cmd_rf_tx_power(struct mwifiex_private *priv,
 }
 
 /*
+ * This function prepares command to set rf antenna.
+ */
+static int mwifiex_cmd_rf_antenna(struct mwifiex_private *priv,
+				  struct host_cmd_ds_command *cmd,
+				  u16 cmd_action,
+				  struct mwifiex_ds_ant_cfg *ant_cfg)
+{
+	struct host_cmd_ds_rf_ant_mimo *ant_mimo = &cmd->params.ant_mimo;
+	struct host_cmd_ds_rf_ant_siso *ant_siso = &cmd->params.ant_siso;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_RF_ANTENNA);
+
+	if (cmd_action != HostCmd_ACT_GEN_SET)
+		return 0;
+
+	if (priv->adapter->hw_dev_mcs_support == HT_STREAM_2X2) {
+		cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_rf_ant_mimo) +
+					S_DS_GEN);
+		ant_mimo->action_tx = cpu_to_le16(HostCmd_ACT_SET_TX);
+		ant_mimo->tx_ant_mode = cpu_to_le16((u16)ant_cfg->tx_ant);
+		ant_mimo->action_rx = cpu_to_le16(HostCmd_ACT_SET_RX);
+		ant_mimo->rx_ant_mode = cpu_to_le16((u16)ant_cfg->rx_ant);
+	} else {
+		cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_rf_ant_siso) +
+					S_DS_GEN);
+		ant_siso->action = cpu_to_le16(HostCmd_ACT_SET_BOTH);
+		ant_siso->ant_mode = cpu_to_le16((u16)ant_cfg->tx_ant);
+	}
+
+	return 0;
+}
+
+/*
  * This function prepares command to set Host Sleep configuration.
  *
  * Preparation includes -
@@ -1076,6 +1109,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_rf_tx_power(priv, cmd_ptr, cmd_action,
 					      data_buf);
 		break;
+	case HostCmd_CMD_RF_ANTENNA:
+		ret = mwifiex_cmd_rf_antenna(priv, cmd_ptr, cmd_action,
+					     data_buf);
+		break;
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
 		ret = mwifiex_cmd_enh_power_mode(priv, cmd_ptr, cmd_action,
 						 (uint16_t)cmd_oid, data_buf);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 4cb2c1c..71c9b5b 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -475,6 +475,33 @@ static int mwifiex_ret_rf_tx_power(struct mwifiex_private *priv,
 }
 
 /*
+ * This function handles the command response of set rf antenna
+ */
+static int mwifiex_ret_rf_antenna(struct mwifiex_private *priv,
+				  struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_rf_ant_mimo *ant_mimo = &resp->params.ant_mimo;
+	struct host_cmd_ds_rf_ant_siso *ant_siso = &resp->params.ant_siso;
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	if (adapter->hw_dev_mcs_support == HT_STREAM_2X2)
+		dev_dbg(adapter->dev,
+			"RF_ANT_RESP: Tx action = 0x%x, Tx Mode = 0x%04x"
+			" Rx action = 0x%x, Rx Mode = 0x%04x\n",
+			le16_to_cpu(ant_mimo->action_tx),
+			le16_to_cpu(ant_mimo->tx_ant_mode),
+			le16_to_cpu(ant_mimo->action_rx),
+			le16_to_cpu(ant_mimo->rx_ant_mode));
+	else
+		dev_dbg(adapter->dev,
+			"RF_ANT_RESP: action = 0x%x, Mode = 0x%04x\n",
+			le16_to_cpu(ant_siso->action),
+			le16_to_cpu(ant_siso->ant_mode));
+
+	return 0;
+}
+
+/*
  * This function handles the command response of set/get MAC address.
  *
  * Handling includes saving the MAC address in driver.
@@ -874,6 +901,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_RF_TX_PWR:
 		ret = mwifiex_ret_rf_tx_power(priv, resp);
 		break;
+	case HostCmd_CMD_RF_ANTENNA:
+		ret = mwifiex_ret_rf_antenna(priv, resp);
+		break;
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
 		ret = mwifiex_ret_enh_power_mode(priv, resp, data_buf);
 		break;
-- 
1.7.0.2

