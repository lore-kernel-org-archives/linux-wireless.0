Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16016 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933119AbbFVIIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:08:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M7xr3h032680
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:08:05 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1v57pduf44-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:08:05 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 14/17] mwifiex: support to set multichannel policy to FW
Date: Mon, 22 Jun 2015 19:06:20 +0530
Message-ID: <1434980183-2901-15-git-send-email-patila@marvell.com> (sfid-20150622_103354_829735_D8C764E3)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for setting multichannel policy as module parameter
to FW. Value of 1 indicates Multichannel support is enabled
and value of 0 disables it.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h          |  8 ++++++++
 drivers/net/wireless/mwifiex/sta_cmd.c     | 31 ++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  1 +
 3 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 427e363..976b585 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -201,6 +201,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 #define ISSUPP_11NENABLED(FwCapInfo) (FwCapInfo & BIT(11))
 #define ISSUPP_TDLS_ENABLED(FwCapInfo) (FwCapInfo & BIT(14))
+#define ISSUPP_DRCS_ENABLED(FwCapInfo) (FwCapInfo & BIT(15))
 #define ISSUPP_SDIO_SPA_ENABLED(FwCapInfo) (FwCapInfo & BIT(16))
 
 #define MWIFIEX_DEF_HT_CAP	(IEEE80211_HT_CAP_DSSSCCK40 | \
@@ -361,6 +362,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_REMAIN_ON_CHAN                    0x010d
 #define HostCmd_CMD_11AC_CFG			      0x0112
 #define HostCmd_CMD_TDLS_CONFIG                       0x0100
+#define HostCmd_CMD_MC_POLICY                         0x0121
 #define HostCmd_CMD_TDLS_OPER                         0x0122
 #define HostCmd_CMD_SDIO_SP_RX_AGGR_CFG               0x0223
 
@@ -2039,6 +2041,11 @@ struct host_cmd_ds_coalesce_cfg {
 	struct coalesce_receive_filt_rule rule[0];
 } __packed;
 
+struct host_cmd_ds_multi_chan_policy {
+	__le16 action;
+	__le16 policy;
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -2107,6 +2114,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_tdls_oper tdls_oper;
 		struct host_cmd_ds_chan_rpt_req chan_rpt_req;
 		struct host_cmd_sdio_sp_rx_aggr_cfg sdio_rx_aggr_cfg;
+		struct host_cmd_ds_multi_chan_policy mc_policy;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 82e6c6e..f250b61 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -26,6 +26,10 @@
 #include "11n.h"
 #include "11ac.h"
 
+static bool drcs;
+module_param(drcs, bool, 0644);
+MODULE_PARM_DESC(drcs, "multi-channel operation:1, single-channel operation:0");
+
 static bool disable_auto_ds;
 module_param(disable_auto_ds, bool, 0);
 MODULE_PARM_DESC(disable_auto_ds,
@@ -1512,6 +1516,22 @@ static int mwifiex_cmd_cfg_data(struct mwifiex_private *priv,
 }
 
 static int
+mwifiex_cmd_set_mc_policy(struct mwifiex_private *priv,
+			  struct host_cmd_ds_command *cmd,
+			  u16 cmd_action, void *data_buf)
+{
+	struct host_cmd_ds_multi_chan_policy *mc_pol = &cmd->params.mc_policy;
+	const u16 *drcs_info = data_buf;
+
+	mc_pol->action = cpu_to_le16(cmd_action);
+	mc_pol->policy = cpu_to_le16(*drcs_info);
+	cmd->command = cpu_to_le16(HostCmd_CMD_MC_POLICY);
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_multi_chan_policy) +
+				S_DS_GEN);
+	return 0;
+}
+
+static int
 mwifiex_cmd_coalesce_cfg(struct mwifiex_private *priv,
 			 struct host_cmd_ds_command *cmd,
 			 u16 cmd_action, void *data_buf)
@@ -2014,6 +2034,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_sdio_rx_aggr_cfg(cmd_ptr, cmd_action,
 						   data_buf);
 		break;
+	case HostCmd_CMD_MC_POLICY:
+		ret = mwifiex_cmd_set_mc_policy(priv, cmd_ptr, cmd_action,
+						data_buf);
+		break;
 	default:
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "PREP_CMD: unknown cmd- %#x\n", cmd_no);
@@ -2130,6 +2154,13 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 			if (ret)
 				return -1;
 		}
+
+		if (ISSUPP_DRCS_ENABLED(adapter->fw_cap_info))
+			ret = mwifiex_send_cmd(priv, HostCmd_CMD_MC_POLICY,
+					       HostCmd_ACT_GEN_SET, 0, &drcs,
+					       true);
+			if (ret)
+				return -1;
 	}
 
 	/* get tx rate */
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 18f269e..89e8daf 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1193,6 +1193,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_TDLS_OPER:
 		ret = mwifiex_ret_tdls_oper(priv, resp);
+	case HostCmd_CMD_MC_POLICY:
 		break;
 	case HostCmd_CMD_CHAN_REPORT_REQUEST:
 		break;
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
