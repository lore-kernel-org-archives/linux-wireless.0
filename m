Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:35362 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab1CaBJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 21:09:46 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: cleanup power save related struct and macros
Date: Wed, 30 Mar 2011 18:12:44 -0700
Message-Id: <1301533965-10878-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

remove redundant structures and unused macros

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c      |   37 +++++++++++++------------
 drivers/net/wireless/mwifiex/fw.h          |   41 +++++-----------------------
 drivers/net/wireless/mwifiex/init.c        |    2 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   23 +++++++---------
 4 files changed, 37 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 3865dd1..a9aeb31 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -275,14 +275,14 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 	}
 	if (GET_BSS_ROLE(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY))
 			== MWIFIEX_BSS_ROLE_STA) {
-		if (!sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl)
+		if (!sleep_cfm_buf->ps_cfm_sleep.resp_ctrl)
 			/* Response is not needed for sleep
 			   confirm command */
 			adapter->ps_state = PS_STATE_SLEEP;
 		else
 			adapter->ps_state = PS_STATE_SLEEP_CFM;
 
-		if (!sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl
+		if (!sleep_cfm_buf->ps_cfm_sleep.resp_ctrl
 				&& (adapter->is_hs_configured
 					&& !adapter->sleep_period.period)) {
 			adapter->pm_wakeup_card_req = true;
@@ -1211,15 +1211,18 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 	if (cmd_action == DIS_AUTO_PS) {
 		psmode_enh->action = cpu_to_le16(DIS_AUTO_PS);
 		psmode_enh->params.ps_bitmap = cpu_to_le16(ps_bitmap);
-		cmd->size = cpu_to_le16(S_DS_GEN + AUTO_PS_FIX_SIZE);
+		cmd->size = cpu_to_le16(S_DS_GEN + sizeof(psmode_enh->action) +
+				sizeof(psmode_enh->params.ps_bitmap));
 	} else if (cmd_action == GET_PS) {
 		psmode_enh->action = cpu_to_le16(GET_PS);
 		psmode_enh->params.ps_bitmap = cpu_to_le16(ps_bitmap);
-		cmd->size = cpu_to_le16(S_DS_GEN + AUTO_PS_FIX_SIZE);
+		cmd->size = cpu_to_le16(S_DS_GEN + sizeof(psmode_enh->action) +
+				sizeof(psmode_enh->params.ps_bitmap));
 	} else if (cmd_action == EN_AUTO_PS) {
 		psmode_enh->action = cpu_to_le16(EN_AUTO_PS);
-		psmode_enh->params.auto_ps.ps_bitmap = cpu_to_le16(ps_bitmap);
-		cmd_size = S_DS_GEN + AUTO_PS_FIX_SIZE;
+		psmode_enh->params.ps_bitmap = cpu_to_le16(ps_bitmap);
+		cmd_size = S_DS_GEN + sizeof(psmode_enh->action) +
+				sizeof(psmode_enh->params.ps_bitmap);
 		tlv = (u8 *) cmd + cmd_size;
 		if (ps_bitmap & BITMAP_STA_PS) {
 			struct mwifiex_adapter *adapter = priv->adapter;
@@ -1249,24 +1252,23 @@ int mwifiex_cmd_enh_power_mode(struct mwifiex_private *priv,
 
 		}
 		if (ps_bitmap & BITMAP_AUTO_DS) {
-			struct mwifiex_ie_types_auto_ds_param *auto_ps_tlv =
+			struct mwifiex_ie_types_auto_ds_param *auto_ds_tlv =
 				(struct mwifiex_ie_types_auto_ds_param *) tlv;
-			struct mwifiex_auto_ds_param *auto_ds =
-				&auto_ps_tlv->param;
 			u16 idletime = 0;
-			auto_ps_tlv->header.type =
+
+			auto_ds_tlv->header.type =
 				cpu_to_le16(TLV_TYPE_AUTO_DS_PARAM);
-			auto_ps_tlv->header.len =
-				cpu_to_le16(sizeof(*auto_ps_tlv) -
+			auto_ds_tlv->header.len =
+				cpu_to_le16(sizeof(*auto_ds_tlv) -
 					sizeof(struct mwifiex_ie_types_header));
-			cmd_size += sizeof(*auto_ps_tlv);
-			tlv += sizeof(*auto_ps_tlv);
+			cmd_size += sizeof(*auto_ds_tlv);
+			tlv += sizeof(*auto_ds_tlv);
 			if (data_buf)
 				idletime = ((struct mwifiex_ds_auto_ds *)
 					     data_buf)->idle_time;
 			dev_dbg(priv->adapter->dev,
 					"cmd: PS Command: Enter Auto Deep Sleep\n");
-			auto_ds->deep_sleep_timeout = cpu_to_le16(idletime);
+			auto_ds_tlv->deep_sleep_timeout = cpu_to_le16(idletime);
 		}
 		cmd->size = cpu_to_le16(cmd_size);
 	}
@@ -1290,7 +1292,7 @@ int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 	uint16_t action = le16_to_cpu(ps_mode->action);
 	uint16_t ps_bitmap = le16_to_cpu(ps_mode->params.ps_bitmap);
 	uint16_t auto_ps_bitmap =
-		le16_to_cpu(ps_mode->params.auto_ps.ps_bitmap);
+		le16_to_cpu(ps_mode->params.ps_bitmap);
 
 	dev_dbg(adapter->dev, "info: %s: PS_MODE cmd reply result=%#x action=%#X\n",
 					__func__, resp->result, action);
@@ -1318,8 +1320,7 @@ int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 			}
 		}
 	} else if (action == GET_PS) {
-		if (ps_bitmap & (BITMAP_STA_PS | BITMAP_UAP_INACT_PS
-							| BITMAP_UAP_DTIM_PS))
+		if (ps_bitmap & BITMAP_STA_PS)
 			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
 		else
 			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index b4e4991..d981265 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -127,11 +127,14 @@ enum MWIFIEX_802_11_WEP_STATUS {
 #define TLV_TYPE_WMMQSTATUS         (PROPRIETARY_TLV_BASE_ID + 16)
 #define TLV_TYPE_WILDCARDSSID       (PROPRIETARY_TLV_BASE_ID + 18)
 #define TLV_TYPE_TSFTIMESTAMP       (PROPRIETARY_TLV_BASE_ID + 19)
-
 #define TLV_TYPE_AUTH_TYPE          (PROPRIETARY_TLV_BASE_ID + 31)
-
 #define TLV_TYPE_CHANNELBANDLIST    (PROPRIETARY_TLV_BASE_ID + 42)
+#define TLV_TYPE_RATE_DROP_CONTROL  (PROPRIETARY_TLV_BASE_ID + 82)
+#define TLV_TYPE_RATE_SCOPE         (PROPRIETARY_TLV_BASE_ID + 83)
+#define TLV_TYPE_POWER_GROUP        (PROPRIETARY_TLV_BASE_ID + 84)
 #define TLV_TYPE_WAPI_IE            (PROPRIETARY_TLV_BASE_ID + 94)
+#define TLV_TYPE_AUTO_DS_PARAM      (PROPRIETARY_TLV_BASE_ID + 113)
+#define TLV_TYPE_PS_PARAM           (PROPRIETARY_TLV_BASE_ID + 114)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
@@ -184,11 +187,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 
 #define LLC_SNAP_LEN    8
 
-#define TLV_TYPE_RATE_DROP_CONTROL  (PROPRIETARY_TLV_BASE_ID + 82)
-#define TLV_TYPE_RATE_SCOPE         (PROPRIETARY_TLV_BASE_ID + 83)
-
-#define TLV_TYPE_POWER_GROUP        (PROPRIETARY_TLV_BASE_ID + 84)
-
 #define MOD_CLASS_HR_DSSS       0x03
 #define MOD_CLASS_OFDM          0x07
 #define MOD_CLASS_HT            0x08
@@ -553,34 +551,12 @@ struct mwifiex_ps_param {
 	__le16 delay_to_ps;
 };
 
-struct mwifiex_auto_ds_param {
-	__le16 deep_sleep_timeout;
-};
-
-struct sleep_confirm_param {
-	__le16 resp_ctrl;
-};
-
 #define BITMAP_AUTO_DS         0x01
 #define BITMAP_STA_PS          0x10
-#define BITMAP_UAP_INACT_PS    0x100
-#define BITMAP_UAP_DTIM_PS     0x200
-struct auto_ps_param {
-	__le16 ps_bitmap;
-	/* auto deep sleep parameter,
-	 * sta power save parameter
-	 * uap inactivity parameter
-	 * uap DTIM parameter */
-};
-
-#define AUTO_PS_FIX_SIZE    4
-
-#define TLV_TYPE_AUTO_DS_PARAM        (PROPRIETARY_TLV_BASE_ID + 113)
-#define TLV_TYPE_PS_PARAM             (PROPRIETARY_TLV_BASE_ID + 114)
 
 struct mwifiex_ie_types_auto_ds_param {
 	struct mwifiex_ie_types_header header;
-	struct mwifiex_auto_ds_param param;
+	__le16 deep_sleep_timeout;
 } __packed;
 
 struct mwifiex_ie_types_ps_param {
@@ -593,10 +569,7 @@ struct host_cmd_ds_802_11_ps_mode_enh {
 
 	union {
 		struct mwifiex_ps_param opt_ps;
-		struct mwifiex_auto_ds_param auto_ds;
-		struct sleep_confirm_param sleep_cfm;
 		__le16 ps_bitmap;
-		struct auto_ps_param auto_ps;
 	} params;
 } __packed;
 
@@ -1260,7 +1233,7 @@ struct mwifiex_opt_sleep_confirm {
 	__le16 seq_num;
 	__le16 result;
 	__le16 action;
-	struct sleep_confirm_param sleep_cfm;
+	__le16 resp_ctrl;
 } __packed;
 
 struct mwifiex_opt_sleep_confirm_buffer {
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 6fcdaa9..43ea87d 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -280,7 +280,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 			cpu_to_le16(adapter->sleep_cfm->len);
 		sleep_cfm_buf->ps_cfm_sleep.result = 0;
 		sleep_cfm_buf->ps_cfm_sleep.action = cpu_to_le16(SLEEP_CONFIRM);
-		sleep_cfm_buf->ps_cfm_sleep.sleep_cfm.resp_ctrl =
+		sleep_cfm_buf->ps_cfm_sleep.resp_ctrl =
 			cpu_to_le16(RESP_NEEDED);
 	}
 	memset(&adapter->sleep_params, 0, sizeof(adapter->sleep_params));
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index b220b8b..74add45 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -46,6 +46,7 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 {
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
 	struct mwifiex_adapter *adapter = priv->adapter;
+	struct host_cmd_ds_802_11_ps_mode_enh *pm;
 	unsigned long flags;
 
 	dev_err(adapter->dev, "CMD_RESP: cmd %#x error, result=%#x\n",
@@ -55,20 +56,16 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 
 	switch (le16_to_cpu(resp->command)) {
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
-		{
-			struct host_cmd_ds_802_11_ps_mode_enh *pm =
-				&resp->params.psmode_enh;
-			dev_err(adapter->dev, "PS_MODE_ENH cmd failed: "
-				"result=0x%x action=0x%X\n",
+		pm = &resp->params.psmode_enh;
+		dev_err(adapter->dev, "PS_MODE_ENH cmd failed: "
+					"result=0x%x action=0x%X\n",
 				resp->result, le16_to_cpu(pm->action));
-			/* We do not re-try enter-ps command in ad-hoc mode. */
-			if (le16_to_cpu(pm->action) == EN_AUTO_PS &&
-				(le16_to_cpu(pm->params.auto_ps.ps_bitmap) &
-				 BITMAP_STA_PS)
-				&& priv->bss_mode == NL80211_IFTYPE_ADHOC)
-				adapter->ps_mode =
-					MWIFIEX_802_11_POWER_MODE_CAM;
-		}
+		/* We do not re-try enter-ps command in ad-hoc mode. */
+		if (le16_to_cpu(pm->action) == EN_AUTO_PS &&
+			(le16_to_cpu(pm->params.ps_bitmap) & BITMAP_STA_PS) &&
+				priv->bss_mode == NL80211_IFTYPE_ADHOC)
+			adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_CAM;
+
 		break;
 	case HostCmd_CMD_802_11_SCAN:
 		/* Cancel all pending scan command */
-- 
1.7.0.2

