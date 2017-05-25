Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36437 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764862AbdEYRs0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 13:48:26 -0400
Received: by mail-oi0-f65.google.com with SMTP id w138so38629262oiw.3
        for <linux-wireless@vger.kernel.org>; Thu, 25 May 2017 10:48:26 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 6/7] rtlwifi: btcoex: Fix logic error in 21a 1ant
Date: Thu, 25 May 2017 12:48:13 -0500
Message-Id: <20170525174814.25005-7-Larry.Finger@lwfinger.net> (sfid-20170525_194904_131805_0724B8B0)
In-Reply-To: <20170525174814.25005-1-Larry.Finger@lwfinger.net>
References: <20170525174814.25005-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An edit mistake introduced a logic error.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 2740129a86cd..30364966b938 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1613,7 +1613,7 @@ static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
 			btc8821a1ant_coex_table_with_type(btcoexist,
 							  NORMAL_EXEC, 1);
 			coex_dm->auto_tdma_adjust = false;
-		} else if ((bt_rssi_state != BTC_RSSI_STATE_HIGH) &&
+		} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 			   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
 			btc8821a1ant_coex_table_with_type(btcoexist,
-- 
2.12.0
