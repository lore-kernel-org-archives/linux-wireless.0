Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52465 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbeB1DHl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 22:07:41 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/15] rtlwifi: btcoex: Add new but dummy definitions introduced by 8822b
Date: Wed, 28 Feb 2018 11:07:14 +0800
Message-ID: <20180228030718.19510-12-pkshih@realtek.com> (sfid-20180228_040758_004808_A252D776)
In-Reply-To: <20180228030718.19510-1-pkshih@realtek.com>
References: <20180228030718.19510-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

btcoex support multiple platforms, but this drivers doesn't support full
functions yet, so this commit adds dummy definitions.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 9 +++++++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 05300b466d34..8b6b07a936f5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -656,6 +656,9 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 	case BTC_GET_BL_IS_ASUS_8723B:
 		*bool_tmp = false;
 		break;
+	case BTC_GET_BL_RF4CE_CONNECTED:
+		*bool_tmp = false;
+		break;
 	case BTC_GET_S4_WIFI_RSSI:
 		*s32_tmp = halbtc_get_wifi_rssi(rtlpriv);
 		break;
@@ -1141,6 +1144,11 @@ static void halbtc_display_dbg_msg(void *bt_context, u8 disp_type,
 	}
 }
 
+static u32 halbtc_get_bt_reg(void *btc_context, u8 reg_type, u32 offset)
+{
+	return 0;
+}
+
 static bool halbtc_under_ips(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -1291,6 +1299,7 @@ bool exhalbtc_initlize_variables(struct rtl_priv *rtlpriv)
 	btcoexist->btc_get = halbtc_get;
 	btcoexist->btc_set = halbtc_set;
 	btcoexist->btc_set_bt_reg = halbtc_set_bt_reg;
+	btcoexist->btc_get_bt_reg = halbtc_get_bt_reg;
 
 	btcoexist->bt_info.bt_ctrl_buf_size = false;
 	btcoexist->bt_info.agg_buf_size = 5;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 049e92a8afbe..9eae87d19120 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -338,6 +338,7 @@ enum btc_set_type {
 	BTC_SET_ACT_GET_BT_RSSI,
 	BTC_SET_ACT_AGGREGATE_CTRL,
 	BTC_SET_ACT_ANTPOSREGRISTRY_CTRL,
+	BTC_SET_MIMO_PS_MODE,
 
 	/********* for 1Ant **********/
 	/* type bool */
@@ -356,6 +357,7 @@ enum btc_set_type {
 	BTC_SET_ACT_POST_NORMAL_LPS,
 	BTC_SET_ACT_INC_FORCE_EXEC_PWR_CMD_CNT,
 	BTC_SET_ACT_DISABLE_LOW_POWER,
+	BTC_SET_BL_BT_LNA_CONSTRAIN_LEVEL,
 	BTC_SET_ACT_UPDATE_RAMASK,
 	BTC_SET_ACT_SEND_MIMO_PS,
 	/* BT Coex related */
@@ -738,6 +740,7 @@ struct btc_coexist {
 
 	void (*btc_set_bt_reg)(void *btc_context, u8 reg_type, u32 offset,
 			       u32 value);
+	u32 (*btc_get_bt_reg)(void *btc_context, u8 reg_type, u32 offset);
 	u32 (*btc_get_bt_coex_supported_feature)(void *btcoexist);
 	u32 (*btc_get_bt_coex_supported_version)(void *btcoexist);
 	u32 (*btc_get_bt_phydm_version)(void *btcoexist);
-- 
2.15.1
