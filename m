Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34609 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754704AbdDFUUH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 16:20:07 -0400
Received: by mail-oi0-f66.google.com with SMTP id c23so4627200oig.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 13:20:07 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 04/11] rtlwifi: btcoex: 23b 2ant: need those information when scan
Date: Thu,  6 Apr 2017 15:19:51 -0500
Message-Id: <20170406201958.25642-5-Larry.Finger@lwfinger.net> (sfid-20170406_222055_867358_A1B73479)
In-Reply-To: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
References: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For scan notify, we need to supervise some registers to make sure that
coexistence is operating as we expected.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c   | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 9c169d094b51..93dbbc507ba1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -3934,6 +3934,12 @@ void ex_btc8723b2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8723b2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u32 u32tmp;
+	u8 u8tmpa, u8tmpb;
+
+	u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x948);
+	u8tmpa = btcoexist->btc_read_1byte(btcoexist, 0x765);
+	u8tmpb = btcoexist->btc_read_1byte(btcoexist, 0x76e);
 
 	if (BTC_SCAN_START == type)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -3943,6 +3949,10 @@ void ex_btc8723b2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 			 "[BTCoex], SCAN FINISH notify\n");
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM,
 			   &coex_sta->scan_ap_num);
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "############# [BTCoex], 0x948=0x%x, 0x765=0x%x, 0x76e=0x%x\n",
+		u32tmp, u8tmpa, u8tmpb);
 }
 
 void ex_btc8723b2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
-- 
2.12.0
