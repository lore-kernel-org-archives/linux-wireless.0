Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33411 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751582AbdDOUcL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:11 -0400
Received: by mail-oi0-f65.google.com with SMTP id t63so22231365oih.0
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:10 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>
Subject: [PATCH 05/14] rtlwifi: btcoex: 21a 2ant: fix some coding style issues
Date: Sat, 15 Apr 2017 15:31:51 -0500
Message-Id: <20170415203200.22979-6-Larry.Finger@lwfinger.net> (sfid-20170415_223241_279621_77BE3B20)
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Fix some ident and naming for linux coding style.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 62c3556e83b5..bbce0cbe2e9a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3512,8 +3512,7 @@ static void btc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		return;
 	}
 
-	btcoexist->btc_get(btcoexist,
-		BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
 
 	if (wifi_under_5g) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -3629,15 +3628,15 @@ void ex_btc8821a2ant_init_hwconfig(struct btc_coexist *btcoexist)
 	u1tmp |= 0x5;
 	btcoexist->btc_write_1byte(btcoexist, 0x790, u1tmp);
 
-	/*Antenna config */
+	/* Antenna config */
 	btc8821a2ant_set_ant_path(btcoexist, BTC_ANT_WIFI_AT_MAIN, true, false);
 
 	/* PTA parameter */
 	btc8821a2ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 
 	/* Enable counter statistics */
-	/*0x76e[3] = 1, WLAN_Act control by PTA*/
-	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
+	/* 0x76e[3] = 1, WLAN_Act control by PTA */
+	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0x4);
 	btcoexist->btc_write_1byte(btcoexist, 0x778, 0x3);
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
 }
-- 
2.12.0
