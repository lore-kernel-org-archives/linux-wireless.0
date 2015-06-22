Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57527 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932896AbbFVIHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:07:13 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M7xp6A015529
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:13 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1v55hgut7a-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:12 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 06/17] mwifiex: add tdls config command
Date: Mon, 22 Jun 2015 19:06:12 +0530
Message-ID: <1434980183-2901-7-git-send-email-patila@marvell.com> (sfid-20150622_100717_279885_12EDCC8A)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add support for a new tdls configuration command
which is used for configuration of tdls channel switch parameters.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h          | 45 +++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h        |  7 ++++
 drivers/net/wireless/mwifiex/sta_cmd.c     | 48 ++++++++++++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  2 +
 drivers/net/wireless/mwifiex/tdls.c        | 64 ++++++++++++++++++++++++++++++
 5 files changed, 166 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 0785e64..427e363 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -360,6 +360,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_MGMT_FRAME_REG                    0x010c
 #define HostCmd_CMD_REMAIN_ON_CHAN                    0x010d
 #define HostCmd_CMD_11AC_CFG			      0x0112
+#define HostCmd_CMD_TDLS_CONFIG                       0x0100
 #define HostCmd_CMD_TDLS_OPER                         0x0122
 #define HostCmd_CMD_SDIO_SP_RX_AGGR_CFG               0x0223
 
@@ -556,6 +557,19 @@ enum P2P_MODES {
 #define TDLS_BASE_CHANNEL	       0
 #define TDLS_OFF_CHANNEL	       1
 
+#define ACT_TDLS_CS_ENABLE_CONFIG 0x00
+#define ACT_TDLS_CS_INIT	  0x06
+#define ACT_TDLS_CS_STOP	  0x07
+#define ACT_TDLS_CS_PARAMS	  0x08
+
+#define MWIFIEX_DEF_CS_UNIT_TIME	2
+#define MWIFIEX_DEF_CS_THR_OTHERLINK	10
+#define MWIFIEX_DEF_THR_DIRECTLINK	0
+#define MWIFIEX_DEF_CS_TIME		10
+#define MWIFIEX_DEF_CS_TIMEOUT		16
+#define MWIFIEX_DEF_CS_REG_CLASS	12
+#define MWIFIEX_DEF_CS_PERIODICITY	1
+
 #define MWIFIEX_FW_V15		   15
 
 #define MWIFIEX_MASTER_RADAR_DET_MASK BIT(1)
@@ -1265,6 +1279,36 @@ struct host_cmd_ds_tdls_oper {
 	u8 peer_mac[ETH_ALEN];
 } __packed;
 
+struct mwifiex_tdls_config {
+	__le16 enable;
+};
+
+struct mwifiex_tdls_config_cs_params {
+	u8 unit_time;
+	u8 thr_otherlink;
+	u8 thr_directlink;
+};
+
+struct mwifiex_tdls_init_cs_params {
+	u8 peer_mac[ETH_ALEN];
+	u8 primary_chan;
+	u8 second_chan_offset;
+	u8 band;
+	__le16 switch_time;
+	__le16 switch_timeout;
+	u8 reg_class;
+	u8 periodicity;
+} __packed;
+
+struct mwifiex_tdls_stop_cs_params {
+	u8 peer_mac[ETH_ALEN];
+};
+
+struct host_cmd_ds_tdls_config {
+	__le16 tdls_action;
+	u8 tdls_data[1];
+} __packed;
+
 struct mwifiex_chan_desc {
 	__le16 start_freq;
 	u8 chan_width;
@@ -2059,6 +2103,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_sta_list sta_list;
 		struct host_cmd_11ac_vht_cfg vht_cfg;
 		struct host_cmd_ds_coalesce_cfg coalesce_cfg;
+		struct host_cmd_ds_tdls_config tdls_config;
 		struct host_cmd_ds_tdls_oper tdls_oper;
 		struct host_cmd_ds_chan_rpt_req chan_rpt_req;
 		struct host_cmd_sdio_sp_rx_aggr_cfg sdio_rx_aggr_cfg;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d27e6aa..da227522 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1494,6 +1494,13 @@ void mwifiex_check_auto_tdls(unsigned long context);
 void mwifiex_add_auto_tdls_peer(struct mwifiex_private *priv, const u8 *mac);
 void mwifiex_setup_auto_tdls_timer(struct mwifiex_private *priv);
 void mwifiex_clean_auto_tdls(struct mwifiex_private *priv);
+int mwifiex_config_tdls_enable(struct mwifiex_private *priv);
+int mwifiex_config_tdls_disable(struct mwifiex_private *priv);
+int mwifiex_config_tdls_cs_params(struct mwifiex_private *priv);
+int mwifiex_stop_tdls_cs(struct mwifiex_private *priv, const u8 *peer_mac);
+int mwifiex_start_tdls_cs(struct mwifiex_private *priv, const u8 *peer_mac,
+			  u8 primary_chan, u8 second_chan_offset, u8 band);
+
 int mwifiex_cmd_issue_chan_report_request(struct mwifiex_private *priv,
 					  struct host_cmd_ds_command *cmd,
 					  void *data_buf);
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 037adcd..82e6c6e 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1576,6 +1576,50 @@ mwifiex_cmd_coalesce_cfg(struct mwifiex_private *priv,
 }
 
 static int
+mwifiex_cmd_tdls_config(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *cmd,
+			u16 cmd_action, void *data_buf)
+{
+	struct host_cmd_ds_tdls_config *tdls_config = &cmd->params.tdls_config;
+	struct mwifiex_tdls_init_cs_params *config;
+	struct mwifiex_tdls_config *init_config;
+	u16 len;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_TDLS_CONFIG);
+	cmd->size = cpu_to_le16(S_DS_GEN);
+	tdls_config->tdls_action = cpu_to_le16(cmd_action);
+	le16_add_cpu(&cmd->size, sizeof(tdls_config->tdls_action));
+
+	switch (cmd_action) {
+	case ACT_TDLS_CS_ENABLE_CONFIG:
+		init_config = data_buf;
+		len = sizeof(*init_config);
+		memcpy(tdls_config->tdls_data, init_config, len);
+		break;
+	case ACT_TDLS_CS_INIT:
+		config = data_buf;
+		len = sizeof(*config);
+		memcpy(tdls_config->tdls_data, config, len);
+		break;
+	case ACT_TDLS_CS_STOP:
+		len = sizeof(struct mwifiex_tdls_stop_cs_params);
+		memcpy(tdls_config->tdls_data, data_buf, len);
+		break;
+	case ACT_TDLS_CS_PARAMS:
+		len = sizeof(struct mwifiex_tdls_config_cs_params);
+		memcpy(tdls_config->tdls_data, data_buf, len);
+		break;
+	default:
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "Unknown TDLS configuration\n");
+		return -ENOTSUPP;
+	}
+
+	le16_add_cpu(&cmd->size, len);
+	return 0;
+}
+
+static int
 mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 		      struct host_cmd_ds_command *cmd,
 		      void *data_buf)
@@ -1958,6 +2002,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	case HostCmd_CMD_TDLS_OPER:
 		ret = mwifiex_cmd_tdls_oper(priv, cmd_ptr, data_buf);
 		break;
+	case HostCmd_CMD_TDLS_CONFIG:
+		ret = mwifiex_cmd_tdls_config(priv, cmd_ptr, cmd_action,
+					      data_buf);
+		break;
 	case HostCmd_CMD_CHAN_REPORT_REQUEST:
 		ret = mwifiex_cmd_issue_chan_report_request(priv, cmd_ptr,
 							    data_buf);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index b645884..6a85c77 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1197,6 +1197,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_SDIO_SP_RX_AGGR_CFG:
 		ret = mwifiex_ret_sdio_rx_aggr_cfg(priv, resp);
 		break;
+	case HostCmd_CMD_TDLS_CONFIG:
+		break;
 	default:
 		mwifiex_dbg(adapter, ERROR,
 			    "CMD_RESP: unknown cmd response %#x\n",
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 2faa1bc..03eabd7 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -1416,3 +1416,67 @@ void mwifiex_clean_auto_tdls(struct mwifiex_private *priv)
 		mwifiex_flush_auto_tdls_list(priv);
 	}
 }
+
+static int mwifiex_config_tdls(struct mwifiex_private *priv, u8 enable)
+{
+	struct mwifiex_tdls_config config;
+
+	config.enable = cpu_to_le16(enable);
+	return mwifiex_send_cmd(priv, HostCmd_CMD_TDLS_CONFIG,
+				ACT_TDLS_CS_ENABLE_CONFIG, 0, &config, true);
+}
+
+int mwifiex_config_tdls_enable(struct mwifiex_private *priv)
+{
+	return mwifiex_config_tdls(priv, true);
+}
+
+int mwifiex_config_tdls_disable(struct mwifiex_private *priv)
+{
+	return mwifiex_config_tdls(priv, false);
+}
+
+int mwifiex_config_tdls_cs_params(struct mwifiex_private *priv)
+{
+	struct mwifiex_tdls_config_cs_params config_tdls_cs_params;
+
+	config_tdls_cs_params.unit_time = MWIFIEX_DEF_CS_UNIT_TIME;
+	config_tdls_cs_params.thr_otherlink = MWIFIEX_DEF_CS_THR_OTHERLINK;
+	config_tdls_cs_params.thr_directlink = MWIFIEX_DEF_THR_DIRECTLINK;
+
+	return mwifiex_send_cmd(priv, HostCmd_CMD_TDLS_CONFIG,
+				ACT_TDLS_CS_PARAMS, 0,
+				&config_tdls_cs_params, true);
+}
+
+int mwifiex_stop_tdls_cs(struct mwifiex_private *priv, const u8 *peer_mac)
+{
+	struct mwifiex_tdls_stop_cs_params stop_tdls_cs_params;
+
+	ether_addr_copy(stop_tdls_cs_params.peer_mac, peer_mac);
+
+	return mwifiex_send_cmd(priv, HostCmd_CMD_TDLS_CONFIG,
+				ACT_TDLS_CS_STOP, 0,
+				&stop_tdls_cs_params, true);
+}
+
+int mwifiex_start_tdls_cs(struct mwifiex_private *priv, const u8 *peer_mac,
+			  u8 primary_chan, u8 second_chan_offset, u8 band)
+{
+	struct mwifiex_tdls_init_cs_params start_tdls_cs_params;
+
+	ether_addr_copy(start_tdls_cs_params.peer_mac, peer_mac);
+	start_tdls_cs_params.primary_chan = primary_chan;
+	start_tdls_cs_params.second_chan_offset = second_chan_offset;
+	start_tdls_cs_params.band = band;
+
+	start_tdls_cs_params.switch_time = cpu_to_le16(MWIFIEX_DEF_CS_TIME);
+	start_tdls_cs_params.switch_timeout =
+					cpu_to_le16(MWIFIEX_DEF_CS_TIMEOUT);
+	start_tdls_cs_params.reg_class = MWIFIEX_DEF_CS_REG_CLASS;
+	start_tdls_cs_params.periodicity = MWIFIEX_DEF_CS_PERIODICITY;
+
+	return mwifiex_send_cmd(priv, HostCmd_CMD_TDLS_CONFIG,
+				ACT_TDLS_CS_INIT, 0,
+				&start_tdls_cs_params, true);
+}
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
