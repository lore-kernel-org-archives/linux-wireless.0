Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36306 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755221AbdDFUUL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 16:20:11 -0400
Received: by mail-oi0-f66.google.com with SMTP id b187so8910376oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 13:20:10 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 08/11] rtlwifi: btcoex: 23b 2ant: fine tune for bt pan_edr_a2dp
Date: Thu,  6 Apr 2017 15:19:55 -0500
Message-Id: <20170406201958.25642-9-Larry.Finger@lwfinger.net> (sfid-20170406_222056_385433_70D34B56)
In-Reply-To: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
References: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

If we don't limit the rx aggregation size, and set tdma instead, the bt profile can
get more stable.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 06f70944bdac..a76c8d20e093 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -3140,7 +3140,6 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
-	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
@@ -3167,7 +3166,7 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 							  false, 3);
 	} else {
 		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
-		btc8723b2ant_tdma_duration_adjust(btcoexist, false, true, 3);
+		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
 	}
 
 	/* sw mechanism	*/
-- 
2.12.0
