Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33921 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751267AbdFBV2K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 17:28:10 -0400
Received: by mail-oi0-f65.google.com with SMTP id d99so2085877oic.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 14:28:09 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 8/9] rtlwifi: btcoex: remove unused display functions
Date: Fri,  2 Jun 2017 16:27:47 -0500
Message-Id: <20170602212748.23857-9-Larry.Finger@lwfinger.net> (sfid-20170602_232816_231926_01A44EBD)
In-Reply-To: <20170602212748.23857-1-Larry.Finger@lwfinger.net>
References: <20170602212748.23857-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

These display functions are useless and will not be called in the
future.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 38 ----------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 5ad9c180bc28..53a43dfdecba 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -485,22 +485,6 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 	return true;
 }
 
-static void halbtc_display_coex_statistics(struct btc_coexist *btcoexist)
-{
-}
-
-static void halbtc_display_bt_link_info(struct btc_coexist *btcoexist)
-{
-}
-
-static void halbtc_display_bt_fw_info(struct btc_coexist *btcoexist)
-{
-}
-
-static void halbtc_display_fw_pwr_mode_cmd(struct btc_coexist *btcoexist)
-{
-}
-
 /************************************************************
  *		IO related function
  ************************************************************/
@@ -619,27 +603,6 @@ static void halbtc_fill_h2c_cmd(void *bt_context, u8 element_id,
 					cmd_len, cmd_buf);
 }
 
-static void halbtc_display_dbg_msg(void *bt_context, u8 disp_type)
-{
-	struct btc_coexist *btcoexist =	(struct btc_coexist *)bt_context;
-	switch (disp_type) {
-	case BTC_DBG_DISP_COEX_STATISTICS:
-		halbtc_display_coex_statistics(btcoexist);
-		break;
-	case BTC_DBG_DISP_BT_LINK_INFO:
-		halbtc_display_bt_link_info(btcoexist);
-		break;
-	case BTC_DBG_DISP_BT_FW_VER:
-		halbtc_display_bt_fw_info(btcoexist);
-		break;
-	case BTC_DBG_DISP_FW_PWR_MODE_CMD:
-		halbtc_display_fw_pwr_mode_cmd(btcoexist);
-		break;
-	default:
-		break;
-	}
-}
-
 bool halbtc_under_ips(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -696,7 +659,6 @@ bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
 	btcoexist->btc_get_rf_reg = halbtc_get_rfreg;
 
 	btcoexist->btc_fill_h2c = halbtc_fill_h2c_cmd;
-	btcoexist->btc_disp_dbg_msg = halbtc_display_dbg_msg;
 
 	btcoexist->btc_get = halbtc_get;
 	btcoexist->btc_set = halbtc_set;
-- 
2.13.0
