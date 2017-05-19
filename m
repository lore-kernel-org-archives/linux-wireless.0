Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35311 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756420AbdESP7u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 11:59:50 -0400
Received: by mail-oi0-f68.google.com with SMTP id m17so13044782oik.2
        for <linux-wireless@vger.kernel.org>; Fri, 19 May 2017 08:59:50 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 08/10] rtlwifi: btcoex: 23b 1ant: Add rf status notification
Date: Fri, 19 May 2017 10:59:35 -0500
Message-Id: <20170519155937.17526-9-Larry.Finger@lwfinger.net> (sfid-20170519_175957_305633_AA17A4D0)
In-Reply-To: <20170519155937.17526-1-Larry.Finger@lwfinger.net>
References: <20170519155937.17526-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

If driver announce wifi RF status is off, btc can switch antenna to BT.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 37 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  2 ++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  3 ++
 3 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 4279678502d9..5b44e32bf5b3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -3116,6 +3116,43 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 	halbtc8723b1ant_run_coexist_mechanism(btcoexist);
 }
 
+void ex_halbtc8723b1ant_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u32 u32tmp;
+	u8 u8tmpa, u8tmpb, u8tmpc;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], RF Status notify\n");
+
+	if (type == BTC_RF_ON) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RF is turned ON!!\n");
+		btcoexist->stop_coex_dm = false;
+	} else if (type == BTC_RF_OFF) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RF is turned OFF!!\n");
+
+		halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+		halbtc8723b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 0);
+		halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT,
+					     FORCE_EXEC, false, true);
+
+		halbtc8723b1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
+		btcoexist->stop_coex_dm = true;
+
+		u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x948);
+		u8tmpa = btcoexist->btc_read_1byte(btcoexist, 0x765);
+		u8tmpb = btcoexist->btc_read_1byte(btcoexist, 0x67);
+		u8tmpc = btcoexist->btc_read_1byte(btcoexist, 0x76e);
+
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "############# [BTCoex], 0x948=0x%x, 0x765=0x%x, 0x67=0x%x, 0x76e=0x%x\n",
+			 u32tmp, u8tmpa, u8tmpb, u8tmpc);
+	}
+}
+
 void ex_halbtc8723b1ant_halt_notify(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index 47b709159146..592a289c993c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -208,6 +208,8 @@ void ex_halbtc8723b1ant_special_packet_notify(struct btc_coexist *btcoexist,
 					      u8 type);
 void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 				       u8 *tmpbuf, u8 length);
+void ex_halbtc8723b1ant_rf_status_notify(struct btc_coexist *btcoexist,
+					 u8 type);
 void ex_halbtc8723b1ant_halt_notify(struct btc_coexist *btcoexist);
 void ex_halbtc8723b1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnpstate);
 void ex_halbtc8723b1ant_coex_dm_reset(struct btc_coexist *btcoexist);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 6ce2fcadc144..e221adc0c048 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -30,6 +30,9 @@
 #define		NORMAL_EXEC				false
 #define		FORCE_EXEC				true
 
+#define		BTC_RF_OFF				0x0
+#define		BTC_RF_ON				0x1
+
 #define		BTC_RF_A				RF90_PATH_A
 #define		BTC_RF_B				RF90_PATH_B
 #define		BTC_RF_C				RF90_PATH_C
-- 
2.12.0
