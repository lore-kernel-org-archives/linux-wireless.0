Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35020 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754522AbdDOUcQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:16 -0400
Received: by mail-oi0-f67.google.com with SMTP id a21so5610984oic.2
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:16 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>
Subject: [PATCH 11/14] rtlwifi: btcoex: 21a 2ant: macro for bt rssi threshold
Date: Sat, 15 Apr 2017 15:31:57 -0500
Message-Id: <20170415203200.22979-12-Larry.Finger@lwfinger.net> (sfid-20170415_223232_393920_0B47D936)
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Using macro to control the bt threshold.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 626b73fd97a5..5a8e4b80006b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3145,7 +3145,8 @@ static void btc8821a2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 	u32 wifi_bw;
 
 	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
-	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist,
+				2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
 
 	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-- 
2.12.0
