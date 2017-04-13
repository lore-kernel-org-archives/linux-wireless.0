Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33330 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755416AbdDMSH3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:29 -0400
Received: by mail-oi0-f68.google.com with SMTP id t63so13603995oih.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:28 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 14/19] rtlwifi: btcoex: 21a 2ant: let PTA circuit control the switch
Date: Thu, 13 Apr 2017 13:07:05 -0500
Message-Id: <20170413180710.19953-15-Larry.Finger@lwfinger.net> (sfid-20170413_200804_623047_CB35EB83)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Register 0xcb4 determines if the PTA circuit can control the swtich

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 7b2fb62947da..6faa53ee821d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -1109,7 +1109,6 @@ static void btc8821a2ant_set_ant_path(struct btc_coexist *btcoexist,
 		btcoexist->btc_write_4byte(btcoexist, 0x4c, u4tmp);
 
 		btcoexist->btc_write_4byte(btcoexist, 0x974, 0x3ff);
-		btcoexist->btc_write_1byte(btcoexist, 0xcb4, 0x77);
 
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT) {
 			/* tell firmware "antenna inverse"  ==> WRONG firmware
-- 
2.12.0
