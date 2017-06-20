Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33009 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752693AbdFTAce (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 20:32:34 -0400
Received: by mail-oi0-f67.google.com with SMTP id j63so971365oiy.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jun 2017 17:32:34 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 09/10] rtlwifi: Add in_4way field for btcoexist
Date: Mon, 19 Jun 2017 19:32:17 -0500
Message-Id: <20170620003218.17010-10-Larry.Finger@lwfinger.net> (sfid-20170620_023239_121089_704D4AA5)
In-Reply-To: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
References: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

If wifi is in 4way, btcoex give wifi higher priority to use antenna.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 3 +--
 drivers/net/wireless/realtek/rtlwifi/wifi.h                   | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 9dbb35f190d1..e6024b013ca5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -428,8 +428,7 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 			*bool_tmp = false;
 		break;
 	case BTC_GET_BL_WIFI_4_WAY_PROGRESS:
-		/* TODO */
-		*bool_tmp = false;
+		*bool_tmp = rtlpriv->btcoexist.btc_info.in_4way;
 		break;
 	case BTC_GET_BL_WIFI_UNDER_5G:
 		if (rtlhal->current_bandtype == BAND_ON_5G)
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 98183dc707aa..fb1ebb01133f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2484,6 +2484,7 @@ struct rtl_btc_info {
 	u8 single_ant_path;
 
 	u8 ap_num;
+	bool in_4way;
 };
 
 struct bt_coexist_info {
-- 
2.12.3
