Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24066 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752844AbcHIOvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 10:51:35 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u79EnN8A019949
	for <linux-wireless@vger.kernel.org>; Tue, 9 Aug 2016 07:51:35 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 24nd8q5cw9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2016 07:51:34 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/3] mwifiex: add CHAN_REGION_CFG command
Date: Tue, 9 Aug 2016 20:20:45 +0530
Message-ID: <1470754246-635-2-git-send-email-akarwar@marvell.com> (sfid-20160809_165138_767055_59C9C2FA)
In-Reply-To: <1470754246-635-1-git-send-email-akarwar@marvell.com>
References: <1470754246-635-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds command preparation and response handling for
CHAN_REGION_CFG command. These changes are prerequisites for adding
custom regulatory domain support.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h          |  7 ++++
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     | 21 +++++++++++
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 41 ++++++++++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index a88030a..085db99 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -190,6 +190,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_BTCOEX_WL_SCANTIME      (PROPRIETARY_TLV_BASE_ID + 203)
 #define TLV_TYPE_BSS_MODE           (PROPRIETARY_TLV_BASE_ID + 206)
 #define TLV_TYPE_RANDOM_MAC         (PROPRIETARY_TLV_BASE_ID + 236)
+#define TLV_TYPE_CHAN_ATTR_CFG      (PROPRIETARY_TLV_BASE_ID + 237)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
@@ -382,6 +383,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_MC_POLICY                         0x0121
 #define HostCmd_CMD_TDLS_OPER                         0x0122
 #define HostCmd_CMD_SDIO_SP_RX_AGGR_CFG               0x0223
+#define HostCmd_CMD_CHAN_REGION_CFG		      0x0242
 
 #define PROTOCOL_NO_SECURITY        0x01
 #define PROTOCOL_STATIC_WEP         0x02
@@ -2224,6 +2226,10 @@ struct host_cmd_ds_gtk_rekey_params {
 	__le32 replay_ctr_high;
 } __packed;
 
+struct host_cmd_ds_chan_region_cfg {
+	__le16 action;
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -2298,6 +2304,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_robust_coex coex;
 		struct host_cmd_ds_wakeup_reason hs_wakeup_reason;
 		struct host_cmd_ds_gtk_rekey_params rekey;
+		struct host_cmd_ds_chan_region_cfg reg_cfg;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 1d8f284..49048b4 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -1594,6 +1594,21 @@ static int mwifiex_cmd_gtk_rekey_offload(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int mwifiex_cmd_chan_region_cfg(struct mwifiex_private *priv,
+				       struct host_cmd_ds_command *cmd,
+				       u16 cmd_action)
+{
+	struct host_cmd_ds_chan_region_cfg *reg = &cmd->params.reg_cfg;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_CHAN_REGION_CFG);
+	cmd->size = cpu_to_le16(sizeof(*reg) + S_DS_GEN);
+
+	if (cmd_action == HostCmd_ACT_GEN_GET)
+		reg->action = cpu_to_le16(cmd_action);
+
+	return 0;
+}
+
 static int
 mwifiex_cmd_coalesce_cfg(struct mwifiex_private *priv,
 			 struct host_cmd_ds_command *cmd,
@@ -2134,6 +2149,9 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_gtk_rekey_offload(priv, cmd_ptr, cmd_action,
 						    data_buf);
 		break;
+	case HostCmd_CMD_CHAN_REGION_CFG:
+		ret = mwifiex_cmd_chan_region_cfg(priv, cmd_ptr, cmd_action);
+		break;
 	default:
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "PREP_CMD: unknown cmd- %#x\n", cmd_no);
@@ -2271,6 +2289,9 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 			if (ret)
 				return -1;
 		}
+
+		mwifiex_send_cmd(priv, HostCmd_CMD_CHAN_REGION_CFG,
+				 HostCmd_ACT_GEN_GET, 0, NULL, true);
 	}
 
 	/* get tx rate */
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 90e191b..db85330 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -1022,6 +1022,44 @@ static int mwifiex_ret_robust_coex(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int mwifiex_ret_chan_region_cfg(struct mwifiex_private *priv,
+				       struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_chan_region_cfg *reg = &resp->params.reg_cfg;
+	u16 action = le16_to_cpu(reg->action);
+	u16 tlv, tlv_buf_len, tlv_buf_left;
+	struct mwifiex_ie_types_header *head;
+	u8 *tlv_buf;
+
+	if (action != HostCmd_ACT_GEN_GET)
+		return 0;
+
+	tlv_buf = (u8 *)reg + sizeof(*reg);
+	tlv_buf_left = le16_to_cpu(resp->size) - S_DS_GEN - sizeof(*reg);
+
+	while (tlv_buf_left >= sizeof(*head)) {
+		head = (struct mwifiex_ie_types_header *)tlv_buf;
+		tlv = le16_to_cpu(head->type);
+		tlv_buf_len = le16_to_cpu(head->len);
+
+		if (tlv_buf_left < (sizeof(*head) + tlv_buf_len))
+			break;
+
+		switch (tlv) {
+		case TLV_TYPE_CHAN_ATTR_CFG:
+			mwifiex_dbg_dump(priv->adapter, CMD_D, "CHAN:",
+					 (u8 *)head + sizeof(*head),
+					 tlv_buf_len);
+			break;
+		}
+
+		tlv_buf += (sizeof(*head) + tlv_buf_len);
+		tlv_buf_left -= (sizeof(*head) + tlv_buf_len);
+	}
+
+	return 0;
+}
+
 /*
  * This function handles the command responses.
  *
@@ -1239,6 +1277,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_GTK_REKEY_OFFLOAD_CFG:
 		break;
+	case HostCmd_CMD_CHAN_REGION_CFG:
+		ret = mwifiex_ret_chan_region_cfg(priv, resp);
+		break;
 	default:
 		mwifiex_dbg(adapter, ERROR,
 			    "CMD_RESP: unknown cmd response %#x\n",
-- 
1.9.1

