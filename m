Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52360 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753939AbeDTCai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 22:30:38 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] rtlwifi: cleanup 8723be ant_sel definition
Date: Fri, 20 Apr 2018 10:30:09 +0800
Message-ID: <20180420023009.3182-1-pkshih@realtek.com> (sfid-20180420_043049_937298_FC651522)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The module parameter ant_sel is used to control antenna number and path.
There is an existing enum ANT_{X2,X1} defined the antenna number, so
add a new enum ANT_{MAIN,AUX} to make it readable. After this work,
incorrect given values depend on ant_sel were exposed, so refill values
according following definition:
  ant_sel   ant_num   ant_path  print_label
     1      ANT_X1    ANT_AUX        #2
     2      ANT_X2    ANT_MAIN       #1
Then, a workaround resulted from the incorrect values in halbtcoutsrc.c was
removed. These is a existing bug in the workaround while ant_sel=2, but the
case is rare use so user is hard to observe this bug.

The experimental results with single antenna connected to specific path
are in following:
  ant_sel  ANT_MAIN(#1)  ANT_AUX(#2)
     0        -8            -62
     1        -62           -10
     2        -6            -60

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Cc: Stable <stable@vger.kernel.org> # 4.7+
Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>
---
v2: Add more description about fixed bugs in end of first paragraph.

---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 15 ---------------
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c       | 11 +++++++----
 drivers/net/wireless/realtek/rtlwifi/wifi.h               |  5 +++++
 3 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index e0f9985582f9..738a7ea7dc4a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -158,16 +158,6 @@ static u8 halbtc_get_wifi_central_chnl(struct btc_coexist *btcoexist)
 
 static u8 rtl_get_hwpg_single_ant_path(struct rtl_priv *rtlpriv)
 {
-	struct rtl_mod_params *mod_params = rtlpriv->cfg->mod_params;
-
-	/* override ant_num / ant_path */
-	if (mod_params->ant_sel) {
-		rtlpriv->btcoexist.btc_info.ant_num =
-			(mod_params->ant_sel == 1 ? ANT_X2 : ANT_X1);
-
-		rtlpriv->btcoexist.btc_info.single_ant_path =
-			(mod_params->ant_sel == 1 ? 0 : 1);
-	}
 	return rtlpriv->btcoexist.btc_info.single_ant_path;
 }
 
@@ -178,7 +168,6 @@ static u8 rtl_get_hwpg_bt_type(struct rtl_priv *rtlpriv)
 
 static u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv)
 {
-	struct rtl_mod_params *mod_params = rtlpriv->cfg->mod_params;
 	u8 num;
 
 	if (rtlpriv->btcoexist.btc_info.ant_num == ANT_X2)
@@ -186,10 +175,6 @@ static u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv)
 	else
 		num = 1;
 
-	/* override ant_num / ant_path */
-	if (mod_params->ant_sel)
-		num = (mod_params->ant_sel == 1 ? ANT_X2 : ANT_X1) + 1;
-
 	return num;
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index e7bbbc95cdb1..b4f3f91b590e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -848,6 +848,9 @@ static bool _rtl8723be_init_mac(struct ieee80211_hw *hw)
 		return false;
 	}
 
+	if (rtlpriv->cfg->ops->get_btc_status())
+		rtlpriv->btcoexist.btc_ops->btc_power_on_setting(rtlpriv);
+
 	bytetmp = rtl_read_byte(rtlpriv, REG_MULTI_FUNC_CTRL);
 	rtl_write_byte(rtlpriv, REG_MULTI_FUNC_CTRL, bytetmp | BIT(3));
 
@@ -2696,21 +2699,21 @@ void rtl8723be_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
 		rtlpriv->btcoexist.btc_info.bt_type = BT_RTL8723B;
 		rtlpriv->btcoexist.btc_info.ant_num = (value & 0x1);
 		rtlpriv->btcoexist.btc_info.single_ant_path =
-			 (value & 0x40);	/*0xc3[6]*/
+			 (value & 0x40 ? ANT_AUX : ANT_MAIN);	/*0xc3[6]*/
 	} else {
 		rtlpriv->btcoexist.btc_info.btcoexist = 0;
 		rtlpriv->btcoexist.btc_info.bt_type = BT_RTL8723B;
 		rtlpriv->btcoexist.btc_info.ant_num = ANT_X2;
-		rtlpriv->btcoexist.btc_info.single_ant_path = 0;
+		rtlpriv->btcoexist.btc_info.single_ant_path = ANT_MAIN;
 	}
 
 	/* override ant_num / ant_path */
 	if (mod_params->ant_sel) {
 		rtlpriv->btcoexist.btc_info.ant_num =
-			(mod_params->ant_sel == 1 ? ANT_X2 : ANT_X1);
+			(mod_params->ant_sel == 1 ? ANT_X1 : ANT_X2);
 
 		rtlpriv->btcoexist.btc_info.single_ant_path =
-			(mod_params->ant_sel == 1 ? 0 : 1);
+			(mod_params->ant_sel == 1 ? ANT_AUX : ANT_MAIN);
 	}
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index c32985cfe48d..ab32a62ead81 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2882,6 +2882,11 @@ enum bt_ant_num {
 	ANT_X1 = 1,
 };
 
+enum bt_ant_path {
+	ANT_MAIN = 0,
+	ANT_AUX = 1,
+};
+
 enum bt_co_type {
 	BT_2WIRE = 0,
 	BT_ISSC_3WIRE = 1,
-- 
2.15.1
