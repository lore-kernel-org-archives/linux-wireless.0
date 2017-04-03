Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36273 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752355AbdDCSlz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 14:41:55 -0400
Received: by mail-oi0-f65.google.com with SMTP id b187so21137431oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 11:41:55 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v3 05/12] rtlwifi: btcoex: 23b 2ant: monitor wifi counter for allocate tdma time
Date: Mon,  3 Apr 2017 13:41:35 -0500
Message-Id: <20170403184147.18409-5-Larry.Finger@lwfinger.net> (sfid-20170403_204220_006490_5D81A867)
In-Reply-To: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
References: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

If there are too many CRC error packets, it means the wifi is operating
under low quality circumstances. If so, we need to reallocate the
resources of wifi and bt

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - No changes.
v3 - No changes.
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 40 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    | 10 ++++++
 2 files changed, 50 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 2c9f626c3ec7..e9c692a5b13e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -309,6 +309,43 @@ static void btc8723b2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
 }
 
+static void btc8723b2ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
+{
+	if (coex_sta->under_ips) {
+		coex_sta->crc_ok_cck = 0;
+		coex_sta->crc_ok_11g = 0;
+		coex_sta->crc_ok_11n = 0;
+		coex_sta->crc_ok_11n_agg = 0;
+
+		coex_sta->crc_err_cck = 0;
+		coex_sta->crc_err_11g = 0;
+		coex_sta->crc_err_11n = 0;
+		coex_sta->crc_err_11n_agg = 0;
+	} else {
+		coex_sta->crc_ok_cck =
+			btcoexist->btc_read_4byte(btcoexist, 0xf88);
+		coex_sta->crc_ok_11g =
+			btcoexist->btc_read_2byte(btcoexist, 0xf94);
+		coex_sta->crc_ok_11n =
+			btcoexist->btc_read_2byte(btcoexist, 0xf90);
+		coex_sta->crc_ok_11n_agg =
+			btcoexist->btc_read_2byte(btcoexist, 0xfb8);
+
+		coex_sta->crc_err_cck =
+			btcoexist->btc_read_4byte(btcoexist, 0xf84);
+		coex_sta->crc_err_11g =
+			btcoexist->btc_read_2byte(btcoexist, 0xf96);
+		coex_sta->crc_err_11n =
+			btcoexist->btc_read_2byte(btcoexist, 0xf92);
+		coex_sta->crc_err_11n_agg =
+			btcoexist->btc_read_2byte(btcoexist, 0xfba);
+	}
+
+	/* reset counter */
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xf16, 0x1, 0x1);
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xf16, 0x1, 0x0);
+}
+
 static void btc8723b2ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -2875,6 +2912,9 @@ void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist)
 #if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 0)
 	btc8723b2ant_query_bt_info(btcoexist);
 #else
+	btc8723b2ant_monitor_bt_ctr(btcoexist);
+	btc8723b2ant_monitor_wifi_ctr(btcoexist);
+
 	if (btc8723b2ant_is_wifi_status_changed(btcoexist) ||
 	    coex_dm->auto_tdma_adjust)
 		btc8723b2ant_run_coexist_mechanism(btcoexist);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index d787ae3bced2..d1bfdbec82b0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -149,6 +149,16 @@ struct coex_sta_8723b_2ant {
 	u8 bt_retry_cnt;
 	u8 bt_info_ext;
 	u32 pop_event_cnt;
+
+	u32 crc_ok_cck;
+	u32 crc_ok_11g;
+	u32 crc_ok_11n;
+	u32 crc_ok_11n_agg;
+
+	u32 crc_err_cck;
+	u32 crc_err_11g;
+	u32 crc_err_11n;
+	u32 crc_err_11n_agg;
 };
 
 /*********************************************************************
-- 
2.12.0
