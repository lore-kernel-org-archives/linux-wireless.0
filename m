Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36540 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753160AbdDJQX0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:26 -0400
Received: by mail-oi0-f68.google.com with SMTP id b187so23324657oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:21 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 01/14] rtlwifi: btcoex: 21a 1ant: fw settings for softap mode
Date: Mon, 10 Apr 2017 11:22:57 -0500
Message-Id: <20170410162310.7515-2-Larry.Finger@lwfinger.net> (sfid-20170410_182345_215386_CDC723C2)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For ap mode, adjust fw settings to operate properly.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 25 ++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 6f6ab0738fbb..5b8f4ed5ce62 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -843,18 +843,35 @@ static void btc8821a1ant_set_fw_ps_tdma(struct btc_coexist *btcoexist, u8 byte1,
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[5] = {0};
+	u8 real_byte1 = byte1, real_byte5 = byte5;
+	bool ap_enable = false;
 
-	h2c_parameter[0] = byte1;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_AP_MODE_ENABLE,
+			   &ap_enable);
+
+	if (ap_enable) {
+		if (byte1 & BIT4 && !(byte1 & BIT5)) {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], FW for 1Ant AP mode\n");
+			real_byte1 &= ~BIT4;
+			real_byte1 |= BIT5;
+
+			real_byte5 |= BIT5;
+			real_byte5 &= ~BIT6;
+		}
+	}
+
+	h2c_parameter[0] = real_byte1;
 	h2c_parameter[1] = byte2;
 	h2c_parameter[2] = byte3;
 	h2c_parameter[3] = byte4;
-	h2c_parameter[4] = byte5;
+	h2c_parameter[4] = real_byte5;
 
-	coex_dm->ps_tdma_para[0] = byte1;
+	coex_dm->ps_tdma_para[0] = real_byte1;
 	coex_dm->ps_tdma_para[1] = byte2;
 	coex_dm->ps_tdma_para[2] = byte3;
 	coex_dm->ps_tdma_para[3] = byte4;
-	coex_dm->ps_tdma_para[4] = byte5;
+	coex_dm->ps_tdma_para[4] = real_byte5;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], PS-TDMA H2C cmd =0x%x%08x\n",
-- 
2.12.0
