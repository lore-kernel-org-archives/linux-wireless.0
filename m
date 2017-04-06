Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34594 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753541AbdDFUUE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 16:20:04 -0400
Received: by mail-oi0-f65.google.com with SMTP id c23so4627057oig.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 13:20:04 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 01/11] rtlwifi: btcoex: 23b 2ant: set coex table when wifi is idle
Date: Thu,  6 Apr 2017 15:19:48 -0500
Message-Id: <20170406201958.25642-2-Larry.Finger@lwfinger.net> (sfid-20170406_222054_308265_88BA419D)
In-Reply-To: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
References: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When wifi is idle, the bt should have more resource to transmit.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 61 ++++++++++++++++------
 1 file changed, 44 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index c9f04454b19b..327609e3a309 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1613,6 +1613,47 @@ static void btc8723b2ant_action_wifi_link_process(struct btc_coexist
 		 u32tmp, u8tmpa, u8tmpb);
 }
 
+static bool btc8723b2ant_action_wifi_idle_process(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 ap_num = 0;
+	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
+		 coex_dm->switch_thres_offset - coex_dm->switch_thres_offset;
+
+	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
+							tmp, 0);
+	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
+	      coex_dm->switch_thres_offset - coex_dm->switch_thres_offset;
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM, &ap_num);
+
+	/* office environment */
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && (coex_sta->hid_exist) &&
+	    (coex_sta->a2dp_exist)) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi  idle process for BT HID+A2DP exist!!\n");
+
+		btc8723b2ant_dac_swing(btcoexist, NORMAL_EXEC, true, 0x6);
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+		/* sw all off */
+		btc8723b2ant_sw_mechanism(btcoexist, false, false, false,
+					  false);
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+
+		return true;
+	}
+
+	btc8723b2ant_dac_swing(btcoexist, NORMAL_EXEC, true, 0x18);
+	return false;
+}
+
 static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -1710,26 +1751,12 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 					 "[BTCoex], Wifi Connected-Busy + BT Busy!!\n");
 				common = false;
 			} else {
-				if (bt_hs_on)
-					return false;
-
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], Wifi Connected-Idle + BT Busy!!\n");
 
-				btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A,
-							  0x1, 0xfffff, 0x0);
-				btc8723b2ant_coex_table_with_type(btcoexist,
-								  NORMAL_EXEC,
-								  7);
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, 21);
-				btc8723b2ant_fw_dac_swing_lvl(btcoexist,
-							      NORMAL_EXEC,
-							      0xb);
-				btc8723b2ant_sw_mechanism(btcoexist, false,
-							  false, false,
-							  false);
-				common = true;
+				common =
+				    btc8723b2ant_action_wifi_idle_process(
+						btcoexist);
 			}
 		}
 	}
-- 
2.12.0
