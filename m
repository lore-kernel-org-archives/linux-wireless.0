Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35279 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756136AbdESP7p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 11:59:45 -0400
Received: by mail-oi0-f65.google.com with SMTP id m17so13044381oik.2
        for <linux-wireless@vger.kernel.org>; Fri, 19 May 2017 08:59:44 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 02/10] rtlwifi: btcoex: 23b 1ant: need these information when scan
Date: Fri, 19 May 2017 10:59:29 -0500
Message-Id: <20170519155937.17526-3-Larry.Finger@lwfinger.net> (sfid-20170519_175951_545122_06BD20EC)
In-Reply-To: <20170519155937.17526-1-Larry.Finger@lwfinger.net>
References: <20170519155937.17526-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Log the scan procedure, and update ap_num for future usage when scan done.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 30 ++++++++++++++++++++--
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  1 +
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 3ff0d55e8f22..cd7dd620c264 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2424,13 +2424,39 @@ void ex_halbtc8723b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool wifi_connected = false, bt_hs_on = false;
+	u8 u8tmpa, u8tmpb;
+	u32 u32tmp;
 	u32 wifi_link_status = 0;
 	u32 num_of_wifi_link = 0;
 	bool bt_ctrl_agg_buf_size = false;
 	u8 agg_buf_size = 5;
 
-	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
+		return;
+
+	if (type == BTC_SCAN_START) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN START notify\n");
+		/* Force antenna setup for no scan result issue */
+		halbtc8723b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
+		halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
+					     FORCE_EXEC, false, false);
+		u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x948);
+		u8tmpa = btcoexist->btc_read_1byte(btcoexist, 0x765);
+		u8tmpb = btcoexist->btc_read_1byte(btcoexist, 0x67);
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], 0x948=0x%x, 0x765=0x%x, 0x67=0x%x\n",
+			 u32tmp, u8tmpa, u8tmpb);
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN FINISH notify\n");
+
+		btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM,
+				   &coex_sta->scan_ap_num);
+	}
+
+	if (coex_sta->bt_disabled)
 		return;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index da99addc8474..9909db880c26 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -163,6 +163,7 @@ struct coex_sta_8723b_1ant {
 	bool c2h_bt_inquiry_page;
 	u8 bt_retry_cnt;
 	u8 bt_info_ext;
+	u8 scan_ap_num;
 	bool cck_ever_lock;
 	bool force_lps_on;
 	u32 pop_event_cnt;
-- 
2.12.0
