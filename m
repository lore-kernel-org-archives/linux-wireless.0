Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35579 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754719AbdDFUUI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 16:20:08 -0400
Received: by mail-oi0-f68.google.com with SMTP id d2so8884668oig.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 13:20:08 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 05/11] rtlwifi: btcoex: 23b 2ant: wifi is not actually off in mp mode
Date: Thu,  6 Apr 2017 15:19:52 -0500
Message-Id: <20170406201958.25642-6-Larry.Finger@lwfinger.net> (sfid-20170406_222543_830056_8991B03A)
In-Reply-To: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
References: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

In mp mode, the wifi will not turn off and still has control of the PTA,
so the driver needs to distinguish whether it is mp mode or not

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c   | 10 ++++++++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h  |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 93dbbc507ba1..70f21059ddc3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -3606,6 +3606,7 @@ static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_wifioff_hwcfg(struct btc_coexist *btcoexist)
 {
+	bool is_in_mp_mode = false;
 	u8 h2c_parameter[2] = {0};
 	u32 fw_ver = 0;
 
@@ -3623,6 +3624,15 @@ static void btc8723b2ant_wifioff_hwcfg(struct btc_coexist *btcoexist)
 	} else {
 		btcoexist->btc_write_1byte(btcoexist, 0x765, 0x18);
 	}
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_IS_IN_MP_MODE,
+			   &is_in_mp_mode);
+	if (!is_in_mp_mode)
+		/* BT select s0/s1 is controlled by BT */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x67, 0x20, 0x0);
+	else
+		/* BT select s0/s1 is controlled by WiFi */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x67, 0x20, 0x1);
 }
 
 /*********************************************************************
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 022658cafbca..0b90e7f0b722 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -205,6 +205,7 @@ enum btc_get_type {
 	BTC_GET_BL_WIFI_ENABLE_ENCRYPTION,
 	BTC_GET_BL_WIFI_UNDER_B_MODE,
 	BTC_GET_BL_EXT_SWITCH,
+	BTC_GET_BL_WIFI_IS_IN_MP_MODE,
 
 	/* type s4Byte */
 	BTC_GET_S4_WIFI_RSSI,
-- 
2.12.0
