Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35283 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbdDJQXY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:24 -0400
Received: by mail-oi0-f68.google.com with SMTP id g204so13131781oib.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:23 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 09/14] rtlwifi: btcoex: 21a 1ant: If wifi only, do not initiate coex mechanism
Date: Mon, 10 Apr 2017 11:23:05 -0500
Message-Id: <20170410162310.7515-10-Larry.Finger@lwfinger.net> (sfid-20170410_182342_266145_8AC9F382)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

If the device has wifi mode only, there is no need to initiate the
hardware for wifi and bt coexistence, so just return to avoid it.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c  | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 05e33d38d49c..86eab6a4ada2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1990,7 +1990,7 @@ static void btc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
 }
 
 static void btc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
-					bool back_up)
+					bool back_up, bool wifi_only)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 u1_tmp = 0;
@@ -1999,6 +1999,9 @@ static void btc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], 1Ant Init HW Config!!\n");
 
+	if (wifi_only)
+		return;
+
 	if (back_up) {
 		coex_dm->backup_arfr_cnt1 = btcoexist->btc_read_4byte(btcoexist,
 								      0x430);
@@ -2039,9 +2042,9 @@ static void btc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
 /**************************************************************
  * extern function start with ex_btc8821a1ant_
  **************************************************************/
-void ex_btc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist)
+void ex_btc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist, bool wifionly)
 {
-	btc8821a1ant_init_hw_config(btcoexist, true);
+	btc8821a1ant_init_hw_config(btcoexist, true, wifionly);
 }
 
 void ex_btc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
@@ -2783,7 +2786,7 @@ void ex_btc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Pnp notify to WAKE UP\n");
 		btcoexist->stop_coex_dm = false;
-		btc8821a1ant_init_hw_config(btcoexist, false);
+		btc8821a1ant_init_hw_config(btcoexist, false, false);
 		btc8821a1ant_init_coex_dm(btcoexist);
 		btc8821a1ant_query_bt_info(btcoexist);
 	}
-- 
2.12.0
