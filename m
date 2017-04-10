Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35262 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753101AbdDJQXV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:21 -0400
Received: by mail-oi0-f66.google.com with SMTP id g204so13131562oib.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:20 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 06/14] rtlwifi: btcoex: 21a 1ant: set antenna control path for PTA
Date: Mon, 10 Apr 2017 11:23:02 -0500
Message-Id: <20170410162310.7515-7-Larry.Finger@lwfinger.net> (sfid-20170410_182325_863330_5708C09A)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Set antenna control path if PTA is in control of the packet path of wifi
and bt. If wifi is turned off, tell the PTA about it.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index b84c1a5be40a..5b374c7728ba 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1011,11 +1011,18 @@ static void btc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
 		u4_tmp &= ~BIT23;
 		u4_tmp &= ~BIT24;
 		btcoexist->btc_write_4byte(btcoexist, 0x4c, u4_tmp);
+
+		/* 0x765 = 0x18 */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x765, 0x18, 0x3);
+	} else {
+		/* 0x765 = 0x0 */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x765, 0x18, 0x0);
 	}
 
 	/* ext switch setting */
 	switch (ant_pos_type) {
 	case BTC_ANT_PATH_WIFI:
+		btcoexist->btc_write_1byte(btcoexist, 0xcb4, 0x77);
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT)
 			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcb7,
 							   0x30, 0x1);
@@ -1024,6 +1031,7 @@ static void btc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
 							   0x30, 0x2);
 		break;
 	case BTC_ANT_PATH_BT:
+		btcoexist->btc_write_1byte(btcoexist, 0xcb4, 0x77);
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT)
 			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcb7,
 							   0x30, 0x2);
@@ -1033,6 +1041,7 @@ static void btc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
 		break;
 	default:
 	case BTC_ANT_PATH_PTA:
+		btcoexist->btc_write_1byte(btcoexist, 0xcb4, 0x66);
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT)
 			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcb7,
 							   0x30, 0x1);
-- 
2.12.0
