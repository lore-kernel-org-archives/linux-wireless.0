Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34019 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754931AbdDOUcR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:17 -0400
Received: by mail-oi0-f65.google.com with SMTP id t14so12826086oif.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:17 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>
Subject: [PATCH 12/14] rtlwifi: btcoex: 21a 2ant: do not limit rx agg size
Date: Sat, 15 Apr 2017 15:31:58 -0500
Message-Id: <20170415203200.22979-13-Larry.Finger@lwfinger.net> (sfid-20170415_223232_443407_F1A7AF62)
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For bt profiling, we do not need to limit the rx agg size.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 5a8e4b80006b..22cb8aa8208d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3148,7 +3148,6 @@ static void btc8821a2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist,
 				2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
 
-	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-- 
2.12.0
