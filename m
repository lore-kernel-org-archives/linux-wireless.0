Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35566 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754294AbdDFUUG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 16:20:06 -0400
Received: by mail-oi0-f68.google.com with SMTP id d2so8884573oig.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 13:20:06 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 03/11] rtlwifi: btcoex: 23b 2ant: remove debugging code for 0x948
Date: Thu,  6 Apr 2017 15:19:50 -0500
Message-Id: <20170406201958.25642-4-Larry.Finger@lwfinger.net> (sfid-20170406_222055_347253_63CADE06)
In-Reply-To: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
References: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c | 6 ------
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h | 2 --
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 82a5e5357cb7..9c169d094b51 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -3486,12 +3486,6 @@ static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 			 "[BTCoex], BT is under inquiry/page scan !!\n");
 		btc8723b2ant_action_bt_inquiry(btcoexist);
 		return;
-	} else {
-		if (coex_dm->need_recover_0x948) {
-			coex_dm->need_recover_0x948 = false;
-			btcoexist->btc_write_2byte(btcoexist, 0x948,
-						   coex_dm->backup_0x948);
-		}
 	}
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index 2c2113482481..9e29f85304cc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -134,8 +134,6 @@ struct coex_dm_8723b_2ant {
 
 	bool is_switch_to_1dot5_ant;
 	u8 switch_thres_offset;
-	bool need_recover_0x948;
-	u16 backup_0x948;
 };
 
 struct coex_sta_8723b_2ant {
-- 
2.12.0
