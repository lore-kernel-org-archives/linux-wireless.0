Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32781 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932277AbdDDQuc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:32 -0400
Received: by mail-oi0-f68.google.com with SMTP id f193so25704247oib.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:31 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 09/13] rtlwifi: btcoex: 23b 2ant: tell fw if external or internal switch is used
Date: Tue,  4 Apr 2017 11:50:02 -0500
Message-Id: <20170404165006.14329-10-Larry.Finger@lwfinger.net> (sfid-20170404_185041_431361_4A016E02)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Some chips use an external antenna switch, but fw may not realize it.
Here we tell fw exactly that which type of switch we are using.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 8098676..2cdcf82 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1106,14 +1106,19 @@ static void btc8723b2ant_set_ant_path(struct btc_coexist *btcoexist,
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT) {
 			/* tell firmware "no antenna inverse" */
 			h2c_parameter[0] = 0;
-			h2c_parameter[1] = 1;  /* ext switch type */
-			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
-						h2c_parameter);
-			btcoexist->btc_write_2byte(btcoexist, 0x948, 0x0);
 		} else {
 			/* tell firmware "antenna inverse" */
 			h2c_parameter[0] = 1;
 		}
+
+		if (use_ext_switch) {
+			/* ext switch type */
+			h2c_parameter[1] = 1;
+		} else {
+			/* int switch type */
+			h2c_parameter[1] = 0;
+		}
+		btcoexist->btc_fill_h2c(btcoexist, 0x65, 2, h2c_parameter);
 	} else {
 		if (fw_ver >= 0x180000) {
 			/* Use H2C to set GNT_BT to "Control by PTA"*/
-- 
2.10.2
