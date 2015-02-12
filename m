Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58657 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755034AbbBLMqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 07:46:25 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1CCe8QQ028092
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 04:46:24 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1sfwqx466v-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 04:46:24 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/3] mwifiex: WMM AC parameter configuration for AP mode
Date: Thu, 12 Feb 2015 23:45:53 +0530
Message-ID: <1423764954-30412-2-git-send-email-patila@marvell.com> (sfid-20150212_134629_066891_9CEEAE40)
In-Reply-To: <1423764954-30412-1-git-send-email-patila@marvell.com>
References: <1423764954-30412-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add cfg80211 set_txq_params handler for mwifiex.
This will be used to configure WMM AC parameters in AP mode.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    | 70 ++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/decl.h        | 11 +++++
 drivers/net/wireless/mwifiex/fw.h          |  2 +
 drivers/net/wireless/mwifiex/ioctl.h       |  1 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 37 ++++++++++++++++
 drivers/net/wireless/mwifiex/uap_cmd.c     | 20 +++++++++
 drivers/net/wireless/mwifiex/wmm.h         | 11 -----
 7 files changed, 141 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ab7643d..f933159 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1552,6 +1552,75 @@ static int mwifiex_cfg80211_change_beacon(struct wiphy *wiphy,
 	return 0;
 }
 
+/* cfg80211 operation handler for set_txq_params.
+ * Function retrieves and sets modified AP WMM params to FW.
+ */
+static int mwifiex_cfg80211_set_txq_params(struct wiphy *wiphy,
+					   struct net_device *dev,
+					   struct ieee80211_txq_params *params)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_types_wmm_info *wmm_info;
+	u8 ac;
+
+	if (!priv || !params)
+		return -EINVAL;
+
+	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_UAP) {
+		wiphy_err(wiphy, "%s: bss_type mismatched\n", __func__);
+		return -EINVAL;
+	}
+
+	wmm_info = &priv->bss_cfg.ap_wmm_params;
+	memset(wmm_info, 0, sizeof(*wmm_info));
+
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
+			     HostCmd_ACT_GEN_GET,
+			     UAP_WMM_PARAMS_I, wmm_info, true)) {
+		wiphy_err(wiphy, "Failed to Get AP wmm params\n");
+		return -1;
+	}
+
+	switch (params->ac) {
+	case NL80211_AC_VO:
+		ac = 3;
+		break;
+	case NL80211_AC_VI:
+		ac = 2;
+		break;
+	case NL80211_AC_BK:
+		ac = 1;
+		break;
+	case NL80211_AC_BE:
+		ac = 0;
+		break;
+	default:
+		wiphy_err(wiphy, "unknown ac in set_txq_params\n");
+		return -EINVAL;
+	}
+
+	wiphy_dbg(wiphy,
+		  "set_txq_params ac=%d, txop=%d, cw min=%d, max=%d, aifs=%d\n",
+		  ac, params->txop, params->cwmin, params->cwmax, params->aifs);
+
+	memset(&wmm_info->ac_params[ac], 0, sizeof(wmm_info->ac_params[ac]));
+	wmm_info->ac_params[ac].aci_aifsn_bitmap = params->aifs & MWIFIEX_AIFSN;
+	wmm_info->ac_params[ac].ecw_bitmap |= ilog2(params->cwmin + 1) &
+								MWIFIEX_ECW_MIN;
+	wmm_info->ac_params[ac].ecw_bitmap |= (ilog2(params->cwmax + 1) << 4) &
+								MWIFIEX_ECW_MAX;
+	wmm_info->ac_params[ac].tx_op_limit = cpu_to_le16(params->txop);
+
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
+			     HostCmd_ACT_GEN_SET,
+			     UAP_WMM_PARAMS_I, wmm_info, false)) {
+		wiphy_err(wiphy, "Failed to set AP wmm params\n");
+		return -1;
+	}
+
+	return 0;
+}
+
 /* cfg80211 operation handler for del_station.
  * Function deauthenticates station which value is provided in mac parameter.
  * If mac is NULL/broadcast, all stations in associated station list are
@@ -3304,6 +3373,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.start_ap = mwifiex_cfg80211_start_ap,
 	.stop_ap = mwifiex_cfg80211_stop_ap,
 	.change_beacon = mwifiex_cfg80211_change_beacon,
+	.set_txq_params = mwifiex_cfg80211_set_txq_params,
 	.set_cqm_rssi_config = mwifiex_cfg80211_set_cqm_rssi_config,
 	.set_antenna = mwifiex_cfg80211_set_antenna,
 	.del_station = mwifiex_cfg80211_del_station,
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 88d0ead..0059d6f 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -183,6 +183,17 @@ struct mwifiex_txinfo {
 	u64 cookie;
 };
 
+enum ieee_types_wmm_aciaifsn_bitmasks {
+	MWIFIEX_AIFSN = (BIT(0) | BIT(1) | BIT(2) | BIT(3)),
+	MWIFIEX_ACM = BIT(4),
+	MWIFIEX_ACI = (BIT(5) | BIT(6)),
+};
+
+enum ieee_types_wmm_ecw_bitmasks {
+	MWIFIEX_ECW_MIN = (BIT(0) | BIT(1) | BIT(2) | BIT(3)),
+	MWIFIEX_ECW_MAX = (BIT(4) | BIT(5) | BIT(6) | BIT(7)),
+};
+
 enum mwifiex_wmm_ac_e {
 	WMM_AC_BK,
 	WMM_AC_BE,
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index df553e8..2a38964 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -116,6 +116,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 #define UAP_BSS_PARAMS_I			0
 #define UAP_CUSTOM_IE_I				1
+#define UAP_WMM_PARAMS_I				2
 #define MWIFIEX_AUTO_IDX_MASK			0xffff
 #define MWIFIEX_DELETE_MASK			0x0000
 #define MGMT_MASK_ASSOC_REQ			0x01
@@ -174,6 +175,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_SCAN_CHANNEL_GAP   (PROPRIETARY_TLV_BASE_ID + 197)
 #define TLV_TYPE_API_REV            (PROPRIETARY_TLV_BASE_ID + 199)
 #define TLV_TYPE_CHANNEL_STATS      (PROPRIETARY_TLV_BASE_ID + 198)
+#define TLV_TYPE_AP_WMM_PARAM     (PROPRIETARY_TLV_BASE_ID + 208)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index d2b05c3..9795220 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -114,6 +114,7 @@ struct mwifiex_uap_bss_param {
 	u32 ps_sta_ao_timer;
 	u8 qos_info;
 	struct mwifiex_types_wmm_info wmm_info;
+	struct mwifiex_types_wmm_info ap_wmm_params;
 };
 
 enum {
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 5f8da59..4a7b1a6 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -943,6 +943,42 @@ static int mwifiex_ret_cfg_data(struct mwifiex_private *priv,
 	return 0;
 }
 
+/* This function handles the command response of set_cfg_data */
+static int mwifiex_ret_uap_sys_config(struct mwifiex_private *priv,
+				      struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_sys_config *uap_sys_config =
+				&resp->params.uap_sys_config;
+	struct mwifiex_ie_types_wmmcap *wmm_cap =
+				(void *)uap_sys_config->tlv;
+	struct mwifiex_types_wmm_info *wmm_info = &wmm_cap->wmm_info;
+	int ac;
+
+	if (le16_to_cpu(uap_sys_config->action) != HostCmd_ACT_GEN_GET ||
+	    le16_to_cpu(wmm_cap->header.type) != TLV_TYPE_AP_WMM_PARAM)
+		return 0;
+
+	if (le16_to_cpu(wmm_cap->header.len) < sizeof(*wmm_info)) {
+		dev_err(priv->adapter->dev,
+			"fw don't support ap wmm parameter configuration\n");
+		return -1;
+	}
+
+	for (ac = 0; ac < 4; ac++) {
+		dev_dbg(priv->adapter->dev,
+			"ac=%d, tx_op=%d, cw_min=%d, cw_max=%d, aci_aifsn=%d\n",
+			ac, le16_to_cpu(wmm_info->ac_params[ac].tx_op_limit),
+			wmm_info->ac_params[ac].ecw_bitmap & MWIFIEX_ECW_MIN,
+			wmm_info->ac_params[ac].ecw_bitmap &
+							MWIFIEX_ECW_MAX >> 4,
+			wmm_info->ac_params[ac].aci_aifsn_bitmap);
+	}
+
+	memcpy(&priv->bss_cfg.ap_wmm_params, wmm_info, sizeof(*wmm_info));
+
+	return 0;
+}
+
 /*
  * This function handles the command responses.
  *
@@ -1103,6 +1139,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		ret = mwifiex_ret_subsc_evt(priv, resp);
 		break;
 	case HostCmd_CMD_UAP_SYS_CONFIG:
+		ret = mwifiex_ret_uap_sys_config(priv, resp);
 		break;
 	case HostCmd_CMD_UAP_BSS_START:
 		adapter->tx_lock_flag = false;
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index f5c2af0..82e4797 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -661,6 +661,22 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	return 0;
 }
 
+/* This function parses WMM IE  */
+static int mwifiex_uap_wmm_ie_prepare(u8 *tlv, void *cmd_buf, u16 *cmd_size)
+{
+	struct mwifiex_types_wmm_info *wmm_info  = cmd_buf;
+	struct mwifiex_ie_types_wmmcap *wmm_cap = (void *)tlv;
+
+	wmm_cap->header.type = cpu_to_le16(TLV_TYPE_AP_WMM_PARAM);
+	wmm_cap->header.len = cpu_to_le16(sizeof(wmm_cap->wmm_info));
+	memcpy(&wmm_cap->wmm_info, wmm_info,
+	       sizeof(wmm_cap->wmm_info));
+	*cmd_size += sizeof(struct mwifiex_ie_types_wmmcap);
+	tlv += sizeof(struct mwifiex_ie_types_wmmcap);
+
+	return 0;
+}
+
 /* This function parses custom IEs from IE list and prepares command buffer */
 static int mwifiex_uap_custom_ie_prepare(u8 *tlv, void *cmd_buf, u16 *ie_size)
 {
@@ -712,6 +728,10 @@ mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd, u16 cmd_action,
 			return -1;
 		cmd->size = cpu_to_le16(ie_size);
 		break;
+	case UAP_WMM_PARAMS_I:
+		mwifiex_uap_wmm_ie_prepare(tlv, cmd_buf, &cmd_size);
+		cmd->size = cpu_to_le16(cmd_size);
+		break;
 	default:
 		return -1;
 	}
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 569bd73..a8e615f 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -20,17 +20,6 @@
 #ifndef _MWIFIEX_WMM_H_
 #define _MWIFIEX_WMM_H_
 
-enum ieee_types_wmm_aciaifsn_bitmasks {
-	MWIFIEX_AIFSN = (BIT(0) | BIT(1) | BIT(2) | BIT(3)),
-	MWIFIEX_ACM = BIT(4),
-	MWIFIEX_ACI = (BIT(5) | BIT(6)),
-};
-
-enum ieee_types_wmm_ecw_bitmasks {
-	MWIFIEX_ECW_MIN = (BIT(0) | BIT(1) | BIT(2) | BIT(3)),
-	MWIFIEX_ECW_MAX = (BIT(4) | BIT(5) | BIT(6) | BIT(7)),
-};
-
 static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 
 /*
-- 
1.8.1.4

