Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33145 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBV2J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 17:28:09 -0400
Received: by mail-oi0-f68.google.com with SMTP id h4so13681199oib.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 14:28:08 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 7/9] rtlwifi: btcoex: bind BT coex information with wifi driver
Date: Fri,  2 Jun 2017 16:27:46 -0500
Message-Id: <20170602212748.23857-8-Larry.Finger@lwfinger.net> (sfid-20170602_232813_996379_4ADE75EF)
In-Reply-To: <20170602212748.23857-1-Larry.Finger@lwfinger.net>
References: <20170602212748.23857-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When initializing, gather BT information in struct btcoexist and
provide them to wifi driver.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 56 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  8 ++++
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   | 29 ++++-------
 3 files changed, 72 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 9832405c5e26..5ad9c180bc28 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -708,6 +708,56 @@ bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
 	return true;
 }
 
+bool exhalbtc_bind_bt_coex_withadapter(void *adapter)
+{
+	struct btc_coexist *btcoexist = &gl_bt_coexist;
+	struct rtl_priv *rtlpriv = adapter;
+	u8 ant_num = 2, chip_type, single_ant_path = 0;
+
+	if (btcoexist->binded)
+		return false;
+
+	btcoexist->binded = true;
+	btcoexist->statistics.cnt_bind++;
+
+	btcoexist->adapter = adapter;
+
+	btcoexist->stack_info.profile_notified = false;
+
+	btcoexist->bt_info.bt_ctrl_agg_buf_size = false;
+	btcoexist->bt_info.agg_buf_size = 5;
+
+	btcoexist->bt_info.increase_scan_dev_num = false;
+	btcoexist->bt_info.miracast_plus_bt = false;
+
+	chip_type = rtl_get_hwpg_bt_type(rtlpriv);
+	exhalbtc_set_chip_type(chip_type);
+	ant_num = rtl_get_hwpg_ant_num(rtlpriv);
+	exhalbtc_set_ant_num(rtlpriv, BT_COEX_ANT_TYPE_PG, ant_num);
+
+	/* set default antenna position to main  port */
+	btcoexist->board_info.btdm_ant_pos = BTC_ANTENNA_AT_MAIN_PORT;
+
+	single_ant_path = rtl_get_hwpg_single_ant_path(rtlpriv);
+	exhalbtc_set_single_ant_path(single_ant_path);
+
+	if (rtl_get_hwpg_package_type(rtlpriv) == 0)
+		btcoexist->board_info.tfbga_package = false;
+	else if (rtl_get_hwpg_package_type(rtlpriv) == 1)
+		btcoexist->board_info.tfbga_package = false;
+	else
+		btcoexist->board_info.tfbga_package = true;
+
+	if (btcoexist->board_info.tfbga_package)
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Package Type = TFBGA\n");
+	else
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Package Type = Non-TFBGA\n");
+
+	return true;
+}
+
 void exhalbtc_power_on_setting(struct btc_coexist *btcoexist)
 {
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -1296,6 +1346,12 @@ void exhalbtc_set_ant_num(struct rtl_priv *rtlpriv, u8 type, u8 ant_num)
 	}
 }
 
+/* Currently used by 8723b only, S0 or S1 */
+void exhalbtc_set_single_ant_path(u8 single_ant_path)
+{
+	gl_bt_coexist.board_info.single_ant_path = single_ant_path;
+}
+
 void exhalbtc_display_bt_coex_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 9b0a6e9c5b20..3d34cf83d7fc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -153,6 +153,7 @@ struct btc_board_info {
 	u8 btdm_ant_pos;
 	u8 single_ant_path; /* current used for 8723b only, 1=>s0,  0=>s1 */
 	bool bt_exist;
+	bool tfbga_package;
 };
 
 enum btc_dbg_opcode {
@@ -433,12 +434,18 @@ struct btc_bt_info {
 	bool bt_disabled;
 	u8 rssi_adjust_for_agc_table_on;
 	u8 rssi_adjust_for_1ant_coex_type;
+	bool pre_bt_ctrl_agg_buf_size;
 	bool bt_busy;
+	u8 pre_agg_buf_size;
 	u8 agg_buf_size;
 	bool limited_dig;
+	bool pre_reject_agg_pkt;
 	bool reject_agg_pkt;
 	bool bt_ctrl_buf_size;
 	bool increase_scan_dev_num;
+	bool miracast_plus_bt;
+	bool bt_ctrl_agg_buf_size;
+	bool bt_tx_rx_mask;
 	u16 bt_hci_ver;
 	u16 bt_real_fw_ver;
 	u8 bt_fw_ver;
@@ -593,5 +600,6 @@ void exhalbtc_signal_compensation(struct btc_coexist *btcoexist,
 				  u8 *rssi_wifi, u8 *rssi_bt);
 void exhalbtc_lps_leave(struct btc_coexist *btcoexist);
 void exhalbtc_low_wifi_traffic_notify(struct btc_coexist *btcoexist);
+void exhalbtc_set_single_ant_path(u8 single_ant_path);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index 46e0fa6be273..dec9d83f87af 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -54,32 +54,19 @@ void rtl_btc_init_variables(struct rtl_priv *rtlpriv)
 
 void rtl_btc_init_hal_vars(struct rtl_priv *rtlpriv)
 {
-	u8 ant_num;
-	u8 bt_exist;
-	u8 bt_type;
+	/* move ant_num, bt_type and single_ant_path to
+	 * exhalbtc_bind_bt_coex_withadapter()
+	 */
+}
 
-	ant_num = rtl_get_hwpg_ant_num(rtlpriv);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		 "%s, antNum is %d\n", __func__, ant_num);
+void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv)
+{
+	u8 bt_exist;
 
 	bt_exist = rtl_get_hwpg_bt_exist(rtlpriv);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		 "%s, bt_exist is %d\n", __func__, bt_exist);
-	exhalbtc_set_bt_exist(bt_exist);
+		"%s, bt_exist is %d\n", __func__, bt_exist);
 
-	bt_type = rtl_get_hwpg_bt_type(rtlpriv);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "%s, bt_type is %d\n",
-		 __func__, bt_type);
-	exhalbtc_set_chip_type(bt_type);
-
-	if (rtlpriv->cfg->mod_params->ant_sel == 1)
-		exhalbtc_set_ant_num(rtlpriv, BT_COEX_ANT_TYPE_DETECTED, 1);
-	else
-		exhalbtc_set_ant_num(rtlpriv, BT_COEX_ANT_TYPE_PG, ant_num);
-}
-
-void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv)
-{
 	exhalbtc_init_hw_config(&gl_bt_coexist);
 	exhalbtc_init_coex_dm(&gl_bt_coexist);
 }
-- 
2.13.0
