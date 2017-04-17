Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32989 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932394AbdDQALW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:22 -0400
Received: by mail-oi0-f68.google.com with SMTP id a189so587276oib.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:22 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 06/27] rtlwifi: btcoex: 23b 1ant: monitor bt is enabled or disabled
Date: Sun, 16 Apr 2017 19:10:50 -0500
Message-Id: <20170417001111.29384-7-Larry.Finger@lwfinger.net> (sfid-20170417_021128_145851_CE6A2146)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Check BT's status, and record it in field bt_disabled. When BT is disabled,
We do special action called wifi_only.  Also, we move the field from
'struct btc_coexist' to 'struct coex_sta_8723b_1ant'.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 62 ++++++++++++++++++++--
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  1 +
 2 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 52b138d548f3..dc9231516e24 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1393,6 +1393,60 @@ static void halbtc8723b1ant_power_save_state(struct btc_coexist *btcoexist,
 	}
 }
 
+#if (BT_AUTO_REPORT_ONLY_8723B_1ANT == 0)
+static void halbtc8723b1ant_action_wifi_only(struct btc_coexist *btcoexist)
+{
+	halbtc8723b1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
+	halbtc8723b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
+	halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA, FORCE_EXEC,
+				     false, false);
+}
+
+/* check if BT is disabled */
+static void halbtc8723b1ant_monitor_bt_enable_disable(struct btc_coexist
+						      *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	static u32 bt_disable_cnt;
+	bool bt_active = true, bt_disabled;
+
+	if (coex_sta->high_priority_tx == 0 &&
+	    coex_sta->high_priority_rx == 0 && coex_sta->low_priority_tx == 0 &&
+	    coex_sta->low_priority_rx == 0)
+		bt_active = false;
+	if (coex_sta->high_priority_tx == 0xffff &&
+	    coex_sta->high_priority_rx == 0xffff &&
+	    coex_sta->low_priority_tx == 0xffff &&
+	    coex_sta->low_priority_rx == 0xffff)
+		bt_active = false;
+	if (bt_active) {
+		bt_disable_cnt = 0;
+		bt_disabled = false;
+	} else {
+		bt_disable_cnt++;
+		if (bt_disable_cnt >= 2)
+			bt_disabled = true;
+	}
+	if (coex_sta->bt_disabled != bt_disabled) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT is from %s to %s!!\n",
+			 (coex_sta->bt_disabled ? "disabled" : "enabled"),
+			 (bt_disabled ? "disabled" : "enabled"));
+
+		coex_sta->bt_disabled = bt_disabled;
+		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
+				   &bt_disabled);
+		if (bt_disabled) {
+			halbtc8723b1ant_action_wifi_only(btcoexist);
+			btcoexist->btc_set(btcoexist, BTC_SET_ACT_LEAVE_LPS,
+					   NULL);
+			btcoexist->btc_set(btcoexist, BTC_SET_ACT_NORMAL_LPS,
+					   NULL);
+		}
+	}
+}
+#endif
+
 /*****************************************************
  *
  *	Non-Software Coex Mechanism start
@@ -2055,7 +2109,7 @@ void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = [%s/ %d/ %d] ",
 		 "BT [status/ rssi/ retryCnt]",
-		 ((btcoexist->bt_info.bt_disabled) ? ("disabled") :
+		 ((coex_sta->bt_disabled) ? ("disabled") :
 		  ((coex_sta->c2h_bt_inquiry_page) ? ("inquiry/page scan") :
 		   ((BT_8723B_1ANT_BT_STATUS_NON_CONNECTED_IDLE ==
 		     coex_dm->bt_status) ?
@@ -2342,7 +2396,7 @@ void ex_halbtc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 	u8 agg_buf_size = 5;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	    coex_sta->bt_disabled)
 		return;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
@@ -2392,7 +2446,7 @@ void ex_halbtc8723b1ant_media_status_notify(struct btc_coexist *btcoexist,
 	u8 wifi_central_chnl;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	    coex_sta->bt_disabled)
 		return;
 
 	if (BTC_MEDIA_CONNECT == type)
@@ -2439,7 +2493,7 @@ void ex_halbtc8723b1ant_special_packet_notify(struct btc_coexist *btcoexist,
 	u8 agg_buf_size = 5;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	    coex_sta->bt_disabled)
 		return;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index b86a28f519aa..5683ddf49911 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -138,6 +138,7 @@ struct coex_dm_8723b_1ant {
 };
 
 struct coex_sta_8723b_1ant {
+	bool bt_disabled;
 	bool bt_link_exist;
 	bool sco_exist;
 	bool a2dp_exist;
-- 
2.12.0
