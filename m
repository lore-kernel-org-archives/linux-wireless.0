Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36569 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753144AbdDJQXZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:25 -0400
Received: by mail-oi0-f67.google.com with SMTP id b187so23324973oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:25 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 05/14] rtlwifi: btcoex: 21a 1ant: remove setting for 2 antennas
Date: Mon, 10 Apr 2017 11:23:01 -0500
Message-Id: <20170410162310.7515-6-Larry.Finger@lwfinger.net> (sfid-20170410_182334_553910_94725767)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

The antenna position setting is useless for 1 antenna chip.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 88bf70f27669..b84c1a5be40a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -994,9 +994,6 @@ static void btc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
 			h2c_parameter[1] = 1;
 			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
 						h2c_parameter);
-			/* Main Ant to  BT for IPS case 0x4c[23] = 1 */
-			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x64,
-							   0x1, 0x1);
 		} else {
 			/* tell firmware "no antenna inverse"
 			 * WRONG firmware antenna control code, need fw to fix
@@ -1005,9 +1002,6 @@ static void btc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
 			h2c_parameter[1] = 1;
 			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
 						h2c_parameter);
-			/* Aux Ant to BT for IPS case 0x4c[23] = 1 */
-			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x64,
-							   0x1, 0x0);
 		}
 	} else if (wifi_off) {
 		/* 0x4c[24:23] = 00, Set Antenna control
-- 
2.12.0
