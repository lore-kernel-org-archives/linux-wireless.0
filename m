Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35622 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753980AbdDDQue (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:34 -0400
Received: by mail-oi0-f65.google.com with SMTP id d2so18373713oig.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:34 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 11/13] rtlwifi: btcoex: 23b 2ant: turn off ps and tdma mechanism when in concurrent mode
Date: Tue,  4 Apr 2017 11:50:04 -0500
Message-Id: <20170404165006.14329-12-Larry.Finger@lwfinger.net> (sfid-20170404_185050_177997_A54CB776)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When wifi is in concurrent mode, we can not distinguish if it is the
real PS or just a fake one by sending null data, so we turn it off
in case of miracast scenario.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 46 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  1 +
 2 files changed, 47 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 31f8a59..88cd28f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -3168,10 +3168,29 @@ static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 	}
 }
 
+static void btc8723b2ant_action_wifi_multi_port(struct btc_coexist *btcoexist)
+{
+	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+	/* sw all off */
+	btc8723b2ant_sw_mechanism(btcoexist, false, false, false, false);
+
+	/* hw all off */
+	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+
+	btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+}
+
 static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 algorithm = 0;
+	u32 num_of_wifi_link = 0;
+	u32 wifi_link_status = 0;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool miracast_plus_bt = false;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], RunCoexistMechanism()===>\n");
@@ -3203,6 +3222,33 @@ static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		}
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
+		btc8723b2ant_action_wifi_multi_port(btcoexist);
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
 		 "[BTCoex], Algorithm = %d\n",
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index d7ba6ad..022658c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -249,6 +249,7 @@ enum btc_set_type {
 	BTC_SET_BL_TO_REJ_AP_AGG_PKT,
 	BTC_SET_BL_BT_CTRL_AGG_SIZE,
 	BTC_SET_BL_INC_SCAN_DEV_NUM,
+	BTC_SET_BL_MIRACAST_PLUS_BT,
 
 	/* type u1Byte */
 	BTC_SET_U1_RSSI_ADJ_VAL_FOR_AGC_TABLE_ON,
-- 
2.10.2
