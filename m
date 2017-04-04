Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35562 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932205AbdDDQu0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:26 -0400
Received: by mail-oi0-f66.google.com with SMTP id d2so18372919oig.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:25 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 03/13] rtlwifi: btcoex: 23b 2ant: detect ap num and set GNT_BT properly
Date: Tue,  4 Apr 2017 11:49:56 -0500
Message-Id: <20170404165006.14329-4-Larry.Finger@lwfinger.net> (sfid-20170404_185035_593523_EFA9C67B)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

If ap num < 10, let wifi and bt transmit simultaneously, otherwise set
wifi into standy when bt is transmitting

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index d4bac17..ae02be8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -2831,6 +2831,7 @@ void ex_btc8723b2ant_media_status_notify(struct btc_coexist *btcoexist,
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_central_chnl;
+	u8 ap_num = 0;
 
 	if (BTC_MEDIA_CONNECT == type)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -2848,10 +2849,16 @@ void ex_btc8723b2ant_media_status_notify(struct btc_coexist *btcoexist,
 		h2c_parameter[1] = wifi_central_chnl;
 		btcoexist->btc_get(btcoexist,
 			BTC_GET_U4_WIFI_BW, &wifi_bw);
-		if (BTC_WIFI_BW_HT40 == wifi_bw)
+		if (wifi_bw == BTC_WIFI_BW_HT40) {
 			h2c_parameter[2] = 0x30;
-		else
-			h2c_parameter[2] = 0x20;
+		} else {
+			btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM,
+					   &ap_num);
+			if (ap_num < 10)
+				h2c_parameter[2] = 0x30;
+			else
+				h2c_parameter[2] = 0x20;
+		}
 	}
 
 	coex_dm->wifi_chnl_info[0] = h2c_parameter[0];
-- 
2.10.2
