Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51279 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755843AbbE2L2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 07:28:31 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4TBSUpe015510
	for <linux-wireless@vger.kernel.org>; Fri, 29 May 2015 04:28:30 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1upn7d87ta-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 29 May 2015 04:28:30 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv3 09/16] mwifiex: add sta_list firmware command
Date: Fri, 29 May 2015 22:26:30 +0530
Message-ID: <1432918598-27769-10-git-send-email-patila@marvell.com> (sfid-20150529_132834_934218_09482892)
In-Reply-To: <1432918598-27769-1-git-send-email-patila@marvell.com>
References: <1432918598-27769-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add sta_list firmware command, which can be used
to get power status and rssi for the stations associated to
mwifiex micro AP.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c      |  1 +
 drivers/net/wireless/mwifiex/fw.h          | 14 ++++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 24 ++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/uap_cmd.c     |  1 +
 4 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index b5033d1..b8f6aa1 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -575,6 +575,7 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 		case HostCmd_CMD_UAP_BSS_STOP:
 		case HostCmd_CMD_UAP_STA_DEAUTH:
 		case HOST_CMD_APCMD_SYS_RESET:
+		case HOSTCMD_CMD_UAP_STA_LIST:
 			ret = mwifiex_uap_prepare_cmd(priv, cmd_no, cmd_action,
 						      cmd_oid, data_buf,
 						      cmd_ptr);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index b6bbf9a..734551c 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -334,6 +334,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_UAP_SYS_CONFIG                    0x00b0
 #define HostCmd_CMD_UAP_BSS_START                     0x00b1
 #define HostCmd_CMD_UAP_BSS_STOP                      0x00b2
+#define HOSTCMD_CMD_UAP_STA_LIST                      0x00b3
 #define HostCmd_CMD_UAP_STA_DEAUTH                    0x00b5
 #define HostCmd_CMD_11N_CFG                           0x00cd
 #define HostCmd_CMD_11N_ADDBA_REQ                     0x00ce
@@ -1465,6 +1466,18 @@ struct host_cmd_ds_sta_deauth {
 	__le16 reason;
 } __packed;
 
+struct mwifiex_ie_types_sta_info {
+	struct mwifiex_ie_types_header header;
+	u8 mac[ETH_ALEN];
+	u8 power_mfg_status;
+	s8 rssi;
+};
+
+struct host_cmd_ds_sta_list {
+	u16 sta_count;
+	u8 tlv[0];
+} __packed;
+
 struct mwifiex_ie_types_pwr_capability {
 	struct mwifiex_ie_types_header header;
 	s8 min_pwr;
@@ -1994,6 +2007,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_802_11_subsc_evt subsc_evt;
 		struct host_cmd_ds_sys_config uap_sys_config;
 		struct host_cmd_ds_sta_deauth sta_deauth;
+		struct host_cmd_ds_sta_list sta_list;
 		struct host_cmd_11ac_vht_cfg vht_cfg;
 		struct host_cmd_ds_coalesce_cfg coalesce_cfg;
 		struct host_cmd_ds_tdls_oper tdls_oper;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index f20a09e..166e7de 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -958,6 +958,27 @@ static int mwifiex_ret_subsc_evt(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int mwifiex_ret_uap_sta_list(struct mwifiex_private *priv,
+				    struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_sta_list *sta_list =
+		&resp->params.sta_list;
+	struct mwifiex_ie_types_sta_info *sta_info = (void *)&sta_list->tlv;
+	int i;
+	struct mwifiex_sta_node *sta_node;
+
+	for (i = 0; i < sta_list->sta_count; i++) {
+		sta_node = mwifiex_get_sta_entry(priv, sta_info->mac);
+		if (unlikely(!sta_node))
+			continue;
+
+		sta_node->stats.rssi = sta_info->rssi;
+		sta_info++;
+	}
+
+	return 0;
+}
+
 /* This function handles the command response of set_cfg_data */
 static int mwifiex_ret_cfg_data(struct mwifiex_private *priv,
 				struct host_cmd_ds_command *resp)
@@ -1148,6 +1169,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_UAP_SYS_CONFIG:
 		break;
+	case HOSTCMD_CMD_UAP_STA_LIST:
+		ret = mwifiex_ret_uap_sta_list(priv, resp);
+		break;
 	case HostCmd_CMD_UAP_BSS_START:
 		adapter->tx_lock_flag = false;
 		adapter->pps_uapsd_mode = false;
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 68fbdf6..865b363 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -755,6 +755,7 @@ int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
 	case HostCmd_CMD_UAP_BSS_START:
 	case HostCmd_CMD_UAP_BSS_STOP:
 	case HOST_CMD_APCMD_SYS_RESET:
+	case HOSTCMD_CMD_UAP_STA_LIST:
 		cmd->command = cpu_to_le16(cmd_no);
 		cmd->size = cpu_to_le16(S_DS_GEN);
 		break;
-- 
1.8.1.4

