Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36357 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754742AbdDOUcM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:12 -0400
Received: by mail-oi0-f65.google.com with SMTP id b187so22210908oif.3
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:12 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 07/14] rtlwifi: btcoex: 21a 2ant: add multiport action for p2p/miracast
Date: Sat, 15 Apr 2017 15:31:53 -0500
Message-Id: <20170415203200.22979-8-Larry.Finger@lwfinger.net> (sfid-20170415_223236_102768_DD4DFB65)
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For p2p/miracast, the wifi may have multiple ports for different roles.
Under this, we need extra settings for turning off the tdma and proper
coex table parameters.

We monnitor the number of links on a port to determine if it is for
p2p/miracast or not.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 9df5b4c195ff..4471bd66a2e5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3495,11 +3495,31 @@ static void btc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 	}
 }
 
+static void btc8821a2ant_action_wifi_multi_port(struct btc_coexist *btcoexist)
+{
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+	/* sw all off */
+	btc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	btc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
+
+	/* hw all off */
+	btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+
+	btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+}
+
 static void btc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_under_5g = false;
 	u8 algorithm = 0;
+	u32 num_of_wifi_link = 0;
+	u32 wifi_link_status = 0;
+	bool miracast_plus_bt = false;
 
 	if (btcoexist->manual_control) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -3525,6 +3545,33 @@ static void btc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		return;
 	}
 
+	/* for P2P */
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
+			   &wifi_link_status);
+	num_of_wifi_link = wifi_link_status >> 16;
+
+	if ((num_of_wifi_link >= 2) ||
+	    (wifi_link_status & WIFI_P2P_GO_CONNECTED)) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "############# [BTCoex],  Multi-Port num_of_wifi_link = %d, wifi_link_status = 0x%x\n",
+			 num_of_wifi_link, wifi_link_status);
+
+		if (bt_link_info->bt_link_exist)
+			miracast_plus_bt = true;
+		else
+			miracast_plus_bt = false;
+
+		btcoexist->btc_set(btcoexist, BTC_SET_BL_MIRACAST_PLUS_BT,
+				   &miracast_plus_bt);
+		btc8821a2ant_action_wifi_multi_port(btcoexist);
+
+		return;
+	}
+
+	miracast_plus_bt = false;
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_MIRACAST_PLUS_BT,
+			   &miracast_plus_bt);
+
 	coex_dm->cur_algorithm = algorithm;
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Algorithm = %d\n", coex_dm->cur_algorithm);
-- 
2.12.0
