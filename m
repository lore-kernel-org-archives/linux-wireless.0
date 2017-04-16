Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34993 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756663AbdDPTEh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 15:04:37 -0400
Received: by mail-oi0-f65.google.com with SMTP id a21so8126717oic.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 12:04:37 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 03/10] rtlwifi: btcoex: 21a 2ant: set wifi standby when halting of entering ips
Date: Sun, 16 Apr 2017 14:04:21 -0500
Message-Id: <20170416190428.23857-4-Larry.Finger@lwfinger.net> (sfid-20170416_210442_738673_E42FC1D4)
In-Reply-To: <20170416190428.23857-1-Larry.Finger@lwfinger.net>
References: <20170416190428.23857-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

If the wifi is going to halt or entering power saving, set it standby
and allocate resource to bt.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 60386c7571e8..162d40ddf06d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3555,6 +3555,26 @@ static void btc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	}
 }
 
+static void btc8821a2ant_wifi_off_hw_cfg(struct btc_coexist *btcoexist)
+{
+	u8 h2c_parameter[2] = {0};
+	u32 fw_ver = 0;
+
+	/* set wlan_act to low */
+	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0x4);
+
+	/* WiFi goto standby while GNT_BT 0-->1 */
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x780);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
+	if (fw_ver >= 0x180000) {
+		/* Use H2C to set GNT_BT to HIGH */
+		h2c_parameter[0] = 1;
+		btcoexist->btc_fill_h2c(btcoexist, 0x6E, 1, h2c_parameter);
+	} else {
+		btcoexist->btc_write_1byte(btcoexist, 0x765, 0x18);
+	}
+}
+
 /**************************************************************
  * extern function start with ex_btc8821a2ant_
  **************************************************************/
@@ -3841,6 +3861,7 @@ void ex_btc8821a2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], IPS ENTER notify\n");
 		coex_sta->under_ips = true;
+		btc8821a2ant_wifi_off_hw_cfg(btcoexist);
 		btc8821a2ant_coex_all_off(btcoexist);
 	} else if (BTC_IPS_LEAVE == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -4084,6 +4105,7 @@ void ex_btc8821a2ant_halt_notify(struct btc_coexist *btcoexist)
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Halt notify\n");
 
+	btc8821a2ant_wifi_off_hw_cfg(btcoexist);
 	btc8821a2ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
 	ex_btc8821a2ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
 }
-- 
2.12.0
