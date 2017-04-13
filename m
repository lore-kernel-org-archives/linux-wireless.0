Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35573 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755198AbdDMSHT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:19 -0400
Received: by mail-oi0-f65.google.com with SMTP id g204so13596968oib.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:18 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 03/19] rtlwifi: btcoex: 21a 2ant: monitor wifi counter to check network status
Date: Thu, 13 Apr 2017 13:06:54 -0500
Message-Id: <20170413180710.19953-4-Larry.Finger@lwfinger.net> (sfid-20170413_200801_253951_71311B74)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

If there are a lot of low-rate packets, then the connection of wifi is
unstable. If so, we should switch resource to bt to have a higher
transmission quality, or wifi resource will be wasted

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 38 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    | 10 ++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 7f685a02d865..e23670a23e4d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -306,6 +306,43 @@ static void btc8821a2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
 }
 
+static void btc8821a2ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
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
 static void btc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -2888,4 +2925,5 @@ void ex_btc8821a2ant_periodical(struct btc_coexist *btcoexist)
 
 	btc8821a2ant_query_bt_info(btcoexist);
 	btc8821a2ant_monitor_bt_ctr(btcoexist);
+	btc8821a2ant_monitor_wifi_ctr(btcoexist);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index b4cf1f53d510..ce8e0d719e78 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -141,6 +141,16 @@ struct coex_sta_8821a_2ant {
 	bool	c2h_bt_inquiry_page;
 	u8	bt_retry_cnt;
 	u8	bt_info_ext;
+
+	u32	crc_ok_cck;
+	u32	crc_ok_11g;
+	u32	crc_ok_11n;
+	u32	crc_ok_11n_agg;
+
+	u32	crc_err_cck;
+	u32	crc_err_11g;
+	u32	crc_err_11n;
+	u32	crc_err_11n_agg;
 };
 
 /*===========================================
-- 
2.12.0
