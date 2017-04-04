Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35593 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932205AbdDDQua (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:30 -0400
Received: by mail-oi0-f65.google.com with SMTP id d2so18373360oig.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:29 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 07/13] rtlwifi: btcoex: 23b 2ant: check more cases when bt is queuing
Date: Tue,  4 Apr 2017 11:50:00 -0500
Message-Id: <20170404165006.14329-8-Larry.Finger@lwfinger.net> (sfid-20170404_185049_356878_8DE23CBA)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

If bt is queing, we need to set the packet priority properly.
Originally we only consider if wifi was connected or not, but now we
also consider if bt is under abnormal scan or wifi is scanning, roaming
or linking, and set the coex table.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 24 +++++++++++++++++++---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |  1 +
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 735bba9..8b2bef8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1464,17 +1464,35 @@ static void btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool wifi_connected = false;
 	bool low_pwr_disable = true;
+	bool scan = false, link = false, roam = false;
 
 	btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 			   &low_pwr_disable);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 			   &wifi_connected);
 
-	if (wifi_connected) {
-		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
-		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
+
+	btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+
+	if (coex_sta->bt_abnormal_scan) {
+		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 23);
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 3);
+	} else if (scan || link || roam) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi link process + BT Inq/Page!!\n");
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 15);
+		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+	} else if (wifi_connected) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi connected + BT Inq/Page!!\n");
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 15);
+		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
 	} else {
 		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index 57eac22..f5e091f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -137,6 +137,7 @@ struct coex_sta_8723b_2ant {
 	bool a2dp_exist;
 	bool hid_exist;
 	bool pan_exist;
+	bool bt_abnormal_scan;
 
 	bool under_lps;
 	bool under_ips;
-- 
2.10.2
