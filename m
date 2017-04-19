Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35064 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932779AbdDSCVu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 22:21:50 -0400
Received: by mail-oi0-f65.google.com with SMTP id g11so2116479oib.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Apr 2017 19:21:49 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 2/2] rtlwifi: btcoex: fix compiler warnings for unused functions
Date: Tue, 18 Apr 2017 21:21:43 -0500
Message-Id: <20170419022143.15484-3-Larry.Finger@lwfinger.net> (sfid-20170419_042157_846989_A79D084C)
In-Reply-To: <20170419022143.15484-1-Larry.Finger@lwfinger.net>
References: <20170419022143.15484-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Add if define ... endif to fix the unused warnings for 21a 2ant. The
routines in question are not needed at the moment, but will be
needed in the near future.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c   | 10 +++++++++-
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h   |  2 ++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 3b4c892fc233..93a264380016 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -265,6 +265,8 @@ void btc8821a2ant_limited_rx(struct btc_coexist *btcoexist, bool force_exec,
 	btcoexist->btc_set(btcoexist, BTC_SET_ACT_AGGREGATE_CTRL, NULL);
 }
 
+#if (BT_AUTO_REPORT_ONLY_8821A_2ANT != 0)
+
 static void btc8821a2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -343,6 +345,8 @@ static void btc8821a2ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xf16, 0x1, 0x0);
 }
 
+#endif
+
 static void btc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -359,7 +363,9 @@ static void btc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
-bool btc8821a2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
+#if (BT_AUTO_REPORT_ONLY_8821A_2ANT != 0)
+
+static bool btc8821a2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
 {
 	static bool pre_wifi_busy = true;
 	static bool pre_under_4way = true;
@@ -400,6 +406,8 @@ bool btc8821a2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
 	return false;
 }
 
+#endif
+
 static void btc8821a2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index a839d5574422..006f139f4882 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -43,6 +43,8 @@
 /* BT RSSI Threshold for 2-Ant TDMA/1-Ant PS-TDMA translation */
 #define BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES	46
 
+#define BT_AUTO_REPORT_ONLY_8821A_2ANT		0
+
 enum _BT_INFO_SRC_8821A_2ANT {
 	BT_INFO_SRC_8821A_2ANT_WIFI_FW		= 0x0,
 	BT_INFO_SRC_8821A_2ANT_BT_RSP		= 0x1,
-- 
2.12.0
