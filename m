Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36364 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753886AbdDOUcO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:14 -0400
Received: by mail-oi0-f67.google.com with SMTP id b187so22210979oif.3
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:14 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 09/14] rtlwifi: btcoex: 21a 2ant: notify fw the number of APs
Date: Sat, 15 Apr 2017 15:31:55 -0500
Message-Id: <20170415203200.22979-10-Larry.Finger@lwfinger.net> (sfid-20170415_223223_477812_94A9617B)
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Use h2c to tell the firmware if the number of AP is more than 10 or
not.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c   | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index b93a4f7ce17a..9e152117730c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3982,6 +3982,7 @@ void ex_btc8821a2ant_media_status_notify(struct btc_coexist *btcoexist,
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_central_chnl;
+	u8 ap_num = 0;
 
 	if (BTC_MEDIA_CONNECT == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -3999,10 +4000,15 @@ void ex_btc8821a2ant_media_status_notify(struct btc_coexist *btcoexist,
 		h2c_parameter[0] = 0x1;
 		h2c_parameter[1] = wifi_central_chnl;
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-		if (BTC_WIFI_BW_HT40 == wifi_bw)
+		if (wifi_bw == BTC_WIFI_BW_HT40) {
 			h2c_parameter[2] = 0x30;
-		else
+		} else {
 			h2c_parameter[2] = 0x20;
+			if (ap_num < 10)
+				h2c_parameter[2] = 0x30;
+			else
+				h2c_parameter[2] = 0x20;
+		}
 	}
 
 	coex_dm->wifi_chnl_info[0] = h2c_parameter[0];
-- 
2.12.0
