Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35308 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756377AbdESP7u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 11:59:50 -0400
Received: by mail-oi0-f67.google.com with SMTP id m17so13044733oik.2
        for <linux-wireless@vger.kernel.org>; Fri, 19 May 2017 08:59:49 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 07/10] rtlwifi: btcoex: 23b 1ant: Setup register for BT WHCK test
Date: Fri, 19 May 2017 10:59:34 -0500
Message-Id: <20170519155937.17526-8-Larry.Finger@lwfinger.net> (sfid-20170519_175954_537369_60355CC6)
In-Reply-To: <20170519155937.17526-1-Larry.Finger@lwfinger.net>
References: <20170519155937.17526-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

If BT is under WHCK, we enter a special mode.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 25 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 9509bf4a4635..4279678502d9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1701,6 +1701,18 @@ static void halbtc8723b1ant_monitor_bt_enable_disable(struct btc_coexist
  *	Non-Software Coex Mechanism start
  *
  *****************************************************/
+
+static void halbtc8723b1ant_action_bt_whck_test(struct btc_coexist *btcoexist)
+{
+	halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
+
+	halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+	halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA, NORMAL_EXEC,
+				     false, false);
+	halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+}
+
 static void halbtc8723b1ant_action_wifi_multiport(struct btc_coexist *btcoexist)
 {
 	halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
@@ -2074,6 +2086,13 @@ static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		return;
 	}
 
+	if (coex_sta->bt_whck_test) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], wifi is under IPS !!!\n");
+		halbtc8723b1ant_action_bt_whck_test(btcoexist);
+		return;
+	}
+
 	if (coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_ACL_BUSY ||
 	    coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_SCO_BUSY ||
 	    coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY)
@@ -2883,6 +2902,12 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 				 "0x%02x, ", tmp_buf[i]);
 	}
 
+	/* if 0xff, it means BT is under WHCK test */
+	if (bt_info == 0xff)
+		coex_sta->bt_whck_test = true;
+	else
+		coex_sta->bt_whck_test = false;
+
 	if (rsp_source != BT_INFO_SRC_8723B_1ANT_WIFI_FW) {
 		coex_sta->bt_retry_cnt = /* [3:0] */
 			coex_sta->bt_info_c2h[rsp_source][2] & 0xf;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index 1cac98e3cc85..47b709159146 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -162,6 +162,7 @@ struct coex_sta_8723b_1ant {
 	bool c2h_bt_info_req_sent;
 	u8 bt_info_c2h[BT_INFO_SRC_8723B_1ANT_MAX][10];
 	u32 bt_info_c2h_cnt[BT_INFO_SRC_8723B_1ANT_MAX];
+	bool bt_whck_test;
 	bool c2h_bt_inquiry_page;
 	bool c2h_bt_remote_name_req;
 	u8 bt_retry_cnt;
-- 
2.12.0
