Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33712 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdGUEYy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 00:24:54 -0400
Received: by mail-oi0-f68.google.com with SMTP id e124so879434oig.0
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 21:24:54 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 06/10] rtlwifi: btcoex: Add send_bt_mp common function, and modify related functions.
Date: Thu, 20 Jul 2017 23:24:36 -0500
Message-Id: <20170721042440.15839-7-Larry.Finger@lwfinger.net> (sfid-20170721_062507_280921_31F2EA7E)
In-Reply-To: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
References: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The older related functions are get_bt_patch_version and set_bt_reg.
The new functions are get_supported_feature, get_supported_version,
get_ant_det_val, ble_scan_type and ble_scan_para.
Also, add a wait parameter, so it can be a synchronized call.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 228 ++++++++++++++++++---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  49 +++++
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  29 ++-
 3 files changed, 273 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 62fbd704d080..e26bbdf3a733 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -200,6 +200,93 @@ u8 rtl_get_hwpg_package_type(struct rtl_priv *rtlpriv)
 	return rtlhal->package_type;
 }
 
+/* ************************************
+ *         Hal helper function
+ * ************************************
+ */
+static
+bool halbtc_is_hw_mailbox_exist(struct btc_coexist *btcoexist)
+{
+	if (IS_HARDWARE_TYPE_8812(btcoexist->adapter))
+		return false;
+	else
+		return true;
+}
+
+static
+bool halbtc_send_bt_mp_operation(struct btc_coexist *btcoexist, u8 op_code,
+				 u8 *cmd, u32 len, unsigned long wait_ms)
+{
+	struct rtl_priv *rtlpriv;
+	const u8 oper_ver = 0;
+	u8 req_num;
+
+	if (!halbtc_is_hw_mailbox_exist(btcoexist))
+		return false;
+
+	if (wait_ms)	/* before h2c to avoid race condition */
+		reinit_completion(&btcoexist->bt_mp_comp);
+
+	rtlpriv = btcoexist->adapter;
+
+	/*
+	 * fill req_num by op_code, and rtl_btc_btmpinfo_notify() use it
+	 * to know message type
+	 */
+	switch (op_code) {
+	case BT_OP_GET_BT_VERSION:
+		req_num = BT_SEQ_GET_BT_VERSION;
+		break;
+	case BT_OP_GET_BT_COEX_SUPPORTED_FEATURE:
+		req_num = BT_SEQ_GET_BT_COEX_SUPPORTED_FEATURE;
+		break;
+	case BT_OP_GET_BT_COEX_SUPPORTED_VERSION:
+		req_num = BT_SEQ_GET_BT_COEX_SUPPORTED_VERSION;
+		break;
+	case BT_OP_GET_BT_ANT_DET_VAL:
+		req_num = BT_SEQ_GET_BT_ANT_DET_VAL;
+		break;
+	case BT_OP_GET_BT_BLE_SCAN_PARA:
+		req_num = BT_SEQ_GET_BT_BLE_SCAN_PARA;
+		break;
+	case BT_OP_GET_BT_BLE_SCAN_TYPE:
+		req_num = BT_SEQ_GET_BT_BLE_SCAN_TYPE;
+		break;
+	case BT_OP_WRITE_REG_ADDR:
+	case BT_OP_WRITE_REG_VALUE:
+	case BT_OP_READ_REG:
+	default:
+		req_num = BT_SEQ_DONT_CARE;
+		break;
+	}
+
+	cmd[0] |= (oper_ver & 0x0f);		/* Set OperVer */
+	cmd[0] |= ((req_num << 4) & 0xf0);	/* Set ReqNum */
+	cmd[1] = op_code;
+	rtlpriv->cfg->ops->fill_h2c_cmd(rtlpriv->mac80211.hw, 0x67, len, cmd);
+
+	/* wait? */
+	if (!wait_ms)
+		return true;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "btmpinfo wait req_num=%d wait=%ld\n", req_num, wait_ms);
+
+	if (in_interrupt())
+		return false;
+
+	if (wait_for_completion_timeout(&btcoexist->bt_mp_comp,
+					msecs_to_jiffies(wait_ms)) == 0) {
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
+			 "btmpinfo wait (req_num=%d) timeout\n", req_num);
+
+		return false;	/* timeout */
+	}
+
+	return true;
+}
+
 static void halbtc_leave_lps(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv;
@@ -327,24 +414,53 @@ static void halbtc_aggregation_check(struct btc_coexist *btcoexist)
 
 static u32 halbtc_get_bt_patch_version(struct btc_coexist *btcoexist)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 cmd_buffer[4] = {0};
-	u8 oper_ver = 0;
-	u8 req_num = 0x0E;
 
 	if (btcoexist->bt_info.bt_real_fw_ver)
 		goto label_done;
 
-	cmd_buffer[0] |= (oper_ver & 0x0f);	/* Set OperVer */
-	cmd_buffer[0] |= ((req_num << 4) & 0xf0);	/* Set ReqNum */
-	cmd_buffer[1] = 0; /* BT_OP_GET_BT_VERSION = 0 */
-	rtlpriv->cfg->ops->fill_h2c_cmd(rtlpriv->mac80211.hw, 0x67, 4,
-					&cmd_buffer[0]);
+	/* cmd_buffer[0] and [1] is filled by halbtc_send_bt_mp_operation() */
+	halbtc_send_bt_mp_operation(btcoexist, BT_OP_GET_BT_VERSION,
+				    cmd_buffer, 4, 200);
 
 label_done:
 	return btcoexist->bt_info.bt_real_fw_ver;
 }
 
+static u32 halbtc_get_bt_coex_supported_feature(void *btc_context)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	u8 cmd_buffer[4] = {0};
+
+	if (btcoexist->bt_info.bt_supported_feature)
+		goto label_done;
+
+	/* cmd_buffer[0] and [1] is filled by halbtc_send_bt_mp_operation() */
+	halbtc_send_bt_mp_operation(btcoexist,
+				    BT_OP_GET_BT_COEX_SUPPORTED_FEATURE,
+				    cmd_buffer, 4, 200);
+
+label_done:
+	return btcoexist->bt_info.bt_supported_feature;
+}
+
+static u32 halbtc_get_bt_coex_supported_version(void *btc_context)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	u8 cmd_buffer[4] = {0};
+
+	if (btcoexist->bt_info.bt_supported_version)
+		goto label_done;
+
+	/* cmd_buffer[0] and [1] is filled by halbtc_send_bt_mp_operation() */
+	halbtc_send_bt_mp_operation(btcoexist,
+				    BT_OP_GET_BT_COEX_SUPPORTED_VERSION,
+				    cmd_buffer, 4, 200);
+
+label_done:
+	return btcoexist->bt_info.bt_supported_version;
+}
+
 u32 halbtc_get_wifi_link_status(struct btc_coexist *btcoexist)
 {
 	/* return value:
@@ -506,6 +622,12 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 	case BTC_GET_U4_VENDOR:
 		*u32_tmp = BTC_VENDOR_OTHER;
 		break;
+	case BTC_GET_U4_SUPPORTED_VERSION:
+		*u32_tmp = halbtc_get_bt_coex_supported_version(btcoexist);
+		break;
+	case BTC_GET_U4_SUPPORTED_FEATURE:
+		*u32_tmp = halbtc_get_bt_coex_supported_feature(btcoexist);
+		break;
 	case BTC_GET_U1_WIFI_DOT11_CHNL:
 		*u8_tmp = rtlphy->current_channel;
 		break;
@@ -887,32 +1009,20 @@ static void halbtc_fill_h2c_cmd(void *bt_context, u8 element_id,
 void halbtc_set_bt_reg(void *btc_context, u8 reg_type, u32 offset, u32 set_val)
 {
 	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 cmd_buffer1[4] = {0};
 	u8 cmd_buffer2[4] = {0};
-	u8 *addr_to_set = (u8 *)&offset;
-	u8 *value_to_set = (u8 *)&set_val;
-	u8 oper_ver = 0;
-	u8 req_num = 0;
 
-	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
-		cmd_buffer1[0] |= (oper_ver & 0x0f);	/* Set OperVer */
-		cmd_buffer1[0] |= ((req_num << 4) & 0xf0);	/* Set ReqNum */
-		cmd_buffer1[1] = 0x0d;	/* OpCode: BT_LO_OP_WRITE_REG_VALUE */
-		cmd_buffer1[2] = value_to_set[0];	/* Set WriteRegValue */
-		rtlpriv->cfg->ops->fill_h2c_cmd(rtlpriv->mac80211.hw, 0x67, 4,
-						&cmd_buffer1[0]);
-
-		msleep(200);
-		req_num++;
-
-		cmd_buffer2[0] |= (oper_ver & 0x0f);	/* Set OperVer */
-		cmd_buffer2[0] |= ((req_num << 4) & 0xf0);	/* Set ReqNum */
-		cmd_buffer2[1] = 0x0c;	/* OpCode: BT_LO_OP_WRITE_REG_ADDR */
-		cmd_buffer2[3] = addr_to_set[0];	/* Set WriteRegAddr */
-		rtlpriv->cfg->ops->fill_h2c_cmd(rtlpriv->mac80211.hw, 0x67, 4,
-						&cmd_buffer2[0]);
-	}
+	/* cmd_buffer[0] and [1] is filled by halbtc_send_bt_mp_operation() */
+	*((__le16 *)&cmd_buffer1[2]) = cpu_to_le16((u16)set_val);
+	if (!halbtc_send_bt_mp_operation(btcoexist, BT_OP_WRITE_REG_VALUE,
+					 cmd_buffer1, 4, 200))
+		return;
+
+	/* cmd_buffer[0] and [1] is filled by halbtc_send_bt_mp_operation() */
+	cmd_buffer2[2] = reg_type;
+	*((u8 *)&cmd_buffer2[3]) = (u8)offset;
+	halbtc_send_bt_mp_operation(btcoexist, BT_OP_WRITE_REG_ADDR,
+				    cmd_buffer2, 4, 200);
 }
 
 static void halbtc_display_dbg_msg(void *bt_context, u8 disp_type,
@@ -953,6 +1063,48 @@ bool halbtc_under_ips(struct btc_coexist *btcoexist)
 	return false;
 }
 
+static u8 halbtc_get_ant_det_val_from_bt(void *btc_context)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	u8 cmd_buffer[4] = {0};
+
+	/* cmd_buffer[0] and [1] is filled by halbtc_send_bt_mp_operation() */
+	halbtc_send_bt_mp_operation(btcoexist, BT_OP_GET_BT_ANT_DET_VAL,
+				    cmd_buffer, 4, 200);
+
+	/* need wait completion to return correct value */
+
+	return btcoexist->bt_info.bt_ant_det_val;
+}
+
+static u8 halbtc_get_ble_scan_type_from_bt(void *btc_context)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	u8 cmd_buffer[4] = {0};
+
+	/* cmd_buffer[0] and [1] is filled by halbtc_send_bt_mp_operation() */
+	halbtc_send_bt_mp_operation(btcoexist, BT_OP_GET_BT_BLE_SCAN_TYPE,
+				    cmd_buffer, 4, 200);
+
+	/* need wait completion to return correct value */
+
+	return btcoexist->bt_info.bt_ble_scan_type;
+}
+
+static u32 halbtc_get_ble_scan_para_from_bt(void *btc_context, u8 scan_type)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	u8 cmd_buffer[4] = {0};
+
+	/* cmd_buffer[0] and [1] is filled by halbtc_send_bt_mp_operation() */
+	halbtc_send_bt_mp_operation(btcoexist, BT_OP_GET_BT_BLE_SCAN_PARA,
+				    cmd_buffer, 4, 200);
+
+	/* need wait completion to return correct value */
+
+	return btcoexist->bt_info.bt_ble_scan_para;
+}
+
 /*****************************************************************
  *         Extern functions called by other module
  *****************************************************************/
@@ -984,11 +1136,23 @@ bool exhalbtc_initlize_variables(void)
 	btcoexist->btc_set = halbtc_set;
 	btcoexist->btc_set_bt_reg = halbtc_set_bt_reg;
 
-
 	btcoexist->bt_info.bt_ctrl_buf_size = false;
 	btcoexist->bt_info.agg_buf_size = 5;
 
 	btcoexist->bt_info.increase_scan_dev_num = false;
+
+	btcoexist->btc_get_bt_coex_supported_feature =
+					halbtc_get_bt_coex_supported_feature;
+	btcoexist->btc_get_bt_coex_supported_version =
+					halbtc_get_bt_coex_supported_version;
+	btcoexist->btc_get_ant_det_val_from_bt = halbtc_get_ant_det_val_from_bt;
+	btcoexist->btc_get_ble_scan_type_from_bt =
+					halbtc_get_ble_scan_type_from_bt;
+	btcoexist->btc_get_ble_scan_para_from_bt =
+					halbtc_get_ble_scan_para_from_bt;
+
+	init_completion(&btcoexist->bt_mp_comp);
+
 	return true;
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index bc523af7ef88..8704d632bac8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -461,6 +461,16 @@ typedef	bool (*bfp_btc_get)(void *btcoexist, u8 get_type, void *out_buf);
 
 typedef	bool (*bfp_btc_set)(void *btcoexist, u8 set_type, void *in_buf);
 
+typedef u32 (*bfp_btc_get_bt_coex_supported_feature)(void *btcoexist);
+
+typedef u32 (*bfp_btc_get_bt_coex_supported_version)(void *btcoexist);
+
+typedef u8 (*bfp_btc_get_ant_det_val_from_bt)(void *btcoexist);
+
+typedef u8 (*bfp_btc_get_ble_scan_type_from_bt)(void *btcoexist);
+
+typedef u32 (*bfp_btc_get_ble_scan_para_from_bt)(void *btcoexist, u8 scan_type);
+
 typedef void (*bfp_btc_set_bt_reg)(void *btc_context, u8 reg_type, u32 offset,
 				   u32 value);
 
@@ -498,6 +508,12 @@ struct btc_bt_info {
 	u8 lps_val;
 	u8 rpwm_val;
 	u32 ra_mask;
+
+	u32 bt_supported_feature;
+	u32 bt_supported_version;
+	u8 bt_ant_det_val;
+	u8 bt_ble_scan_type;
+	u32 bt_ble_scan_para;
 };
 
 struct btc_stack_info {
@@ -553,6 +569,31 @@ enum btc_antenna_pos {
 	BTC_ANTENNA_AT_AUX_PORT = 0x2,
 };
 
+enum btc_mp_h2c_op_code {
+	BT_OP_GET_BT_VERSION			= 0,
+	BT_OP_WRITE_REG_ADDR			= 12,
+	BT_OP_WRITE_REG_VALUE			= 13,
+	BT_OP_READ_REG				= 17,
+	BT_OP_GET_BT_COEX_SUPPORTED_FEATURE	= 42,
+	BT_OP_GET_BT_COEX_SUPPORTED_VERSION	= 43,
+	BT_OP_GET_BT_ANT_DET_VAL		= 44,
+	BT_OP_GET_BT_BLE_SCAN_PARA		= 45,
+	BT_OP_GET_BT_BLE_SCAN_TYPE		= 46,
+	BT_OP_MAX
+};
+
+enum btc_mp_h2c_req_num {
+	/* 4 bits only */
+	BT_SEQ_DONT_CARE			= 0,
+	BT_SEQ_GET_BT_VERSION			= 0xE,
+	BT_SEQ_GET_BT_COEX_SUPPORTED_FEATURE	= 0x7,
+	BT_SEQ_GET_BT_COEX_SUPPORTED_VERSION	= 0x8,
+	BT_SEQ_GET_BT_ANT_DET_VAL		= 0x2,
+	BT_SEQ_GET_BT_BLE_SCAN_PARA		= 0x3,
+	BT_SEQ_GET_BT_BLE_SCAN_TYPE		= 0x4,
+};
+
+
 struct btc_coexist {
 	/* make sure only one adapter can bind the data context  */
 	bool binded;
@@ -576,6 +617,8 @@ struct btc_coexist {
 	struct btc_statistics statistics;
 	u8 pwr_mode_val[10];
 
+	struct completion bt_mp_comp;
+
 	/* function pointers - io related */
 	bfp_btc_r1 btc_read_1byte;
 	bfp_btc_w1 btc_write_1byte;
@@ -600,6 +643,12 @@ struct btc_coexist {
 	bfp_btc_set btc_set;
 
 	bfp_btc_set_bt_reg btc_set_bt_reg;
+
+	bfp_btc_get_bt_coex_supported_feature btc_get_bt_coex_supported_feature;
+	bfp_btc_get_bt_coex_supported_version btc_get_bt_coex_supported_version;
+	bfp_btc_get_ant_det_val_from_bt btc_get_ant_det_val_from_bt;
+	bfp_btc_get_ble_scan_type_from_bt btc_get_ble_scan_type_from_bt;
+	bfp_btc_get_ble_scan_para_from_bt btc_get_ble_scan_para_from_bt;
 };
 
 bool halbtc_is_wifi_uplink(struct rtl_priv *adapter);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index 9e3623b0423c..b97fda263f62 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -196,13 +196,40 @@ void rtl_btc_btmpinfo_notify(struct rtl_priv *rtlpriv, u8 *tmp_buf, u8 length)
 	seq = tmp_buf[2] >> 4;
 
 	/* BT Firmware version response */
-	if (seq == 0x0E) {
+	switch (seq) {
+	case BT_SEQ_GET_BT_VERSION:
 		bt_real_fw_ver = tmp_buf[3] | (tmp_buf[4] << 8);
 		bt_fw_ver = tmp_buf[5];
 
 		gl_bt_coexist.bt_info.bt_real_fw_ver = bt_real_fw_ver;
 		gl_bt_coexist.bt_info.bt_fw_ver = bt_fw_ver;
+		break;
+	case BT_SEQ_GET_BT_COEX_SUPPORTED_FEATURE:
+		gl_bt_coexist.bt_info.bt_supported_feature = tmp_buf[3] |
+							     (tmp_buf[4] << 8);
+		break;
+	case BT_SEQ_GET_BT_COEX_SUPPORTED_VERSION:
+		gl_bt_coexist.bt_info.bt_supported_version = tmp_buf[3] |
+							     (tmp_buf[4] << 8);
+		break;
+	case BT_SEQ_GET_BT_ANT_DET_VAL:
+		gl_bt_coexist.bt_info.bt_ant_det_val = tmp_buf[3];
+		break;
+	case BT_SEQ_GET_BT_BLE_SCAN_PARA:
+		gl_bt_coexist.bt_info.bt_ble_scan_para = tmp_buf[3] |
+							 (tmp_buf[4] << 8) |
+							 (tmp_buf[5] << 16) |
+							 (tmp_buf[6] << 24);
+		break;
+	case BT_SEQ_GET_BT_BLE_SCAN_TYPE:
+		gl_bt_coexist.bt_info.bt_ble_scan_type = tmp_buf[3];
+		break;
 	}
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "btmpinfo complete req_num=%d\n", seq);
+
+	complete(&gl_bt_coexist.bt_mp_comp);
 }
 
 bool rtl_btc_is_limited_dig(struct rtl_priv *rtlpriv)
-- 
2.12.3
