Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34975 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753886AbdDOUcI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:08 -0400
Received: by mail-oi0-f65.google.com with SMTP id a21so5610617oic.2
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:08 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>
Subject: [PATCH 02/14] rtlwifi: btcoex: 21a 2ant: add threshold to examine bt rssi
Date: Sat, 15 Apr 2017 15:31:48 -0500
Message-Id: <20170415203200.22979-3-Larry.Finger@lwfinger.net> (sfid-20170415_223224_016890_CCF89DFC)
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

The threshold is used to adjust the base line for the rssi state.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 7b5dbc62906e..b880bc2eaf85 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -2711,7 +2711,8 @@ static void btc8821a2ant_action_hid(struct btc_coexist *btcoexist)
 	u32 wifi_bw;
 
 	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
-	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist,
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
 
 	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-- 
2.12.0
