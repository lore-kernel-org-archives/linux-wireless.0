Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36630 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752615AbdBGDaY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 22:30:24 -0500
Received: by mail-oi0-f67.google.com with SMTP id u143so7925940oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2017 19:30:24 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 06/11 V4] rtlwifi: rtl8723be: btcoexist: Add single_ant_path
Date: Mon,  6 Feb 2017 21:30:03 -0600
Message-Id: <20170120212716.29887-7-Larry.Finger@lwfinger.net> (sfid-20170207_043047_390703_D48895B3)
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Some devices with RTL8732BE wifi/Bluetooth adapters are shipped with only
a single antenna. On a subset of these, the EEPROM is incorectly coded
to indicate the wrong connection. The resulting problems have been fixed
for wifi. This change handles them for BT.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - no changes
V3 - no changes
V4 - no changes
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 5 +++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h      | 1 +
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c           | 1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h                   | 1 +
 4 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 8a0e773..8e382a8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -146,6 +146,11 @@ static u8 halbtc_get_wifi_central_chnl(struct btc_coexist *btcoexist)
 	return chnl;
 }
 
+u8 rtl_get_hwpg_single_ant_path(struct rtl_priv *rtlpriv)
+{
+	return rtlpriv->btcoexist.btc_info.single_ant_path;
+}
+
 static void halbtc_leave_lps(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
index ccd5a0f..65c1c52 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
@@ -49,6 +49,7 @@ struct rtl_btc_ops *rtl_btc_get_ops_pointer(void);
 u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv);
 u8 rtl_get_hwpg_bt_exist(struct rtl_priv *rtlpriv);
 u8 rtl_get_hwpg_bt_type(struct rtl_priv *rtlpriv);
+u8 rtl_get_hwpg_single_ant_path(struct rtl_priv *rtlpriv);
 enum rt_media_status mgnt_link_status_query(struct ieee80211_hw *hw);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 7b4c66c..8e82c0c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -2657,6 +2657,7 @@ void rtl8723be_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
 		rtlpriv->btcoexist.btc_info.btcoexist = 0;
 		rtlpriv->btcoexist.btc_info.bt_type = BT_RTL8723B;
 		rtlpriv->btcoexist.btc_info.ant_num = ANT_X2;
+		rtlpriv->btcoexist.btc_info.single_ant_path = 0;
 	}
 
 	/* override ant_num / ant_path */
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 310fa90..9a5a8a9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2454,6 +2454,7 @@ struct rtl_btc_info {
 	u8 bt_type;
 	u8 btcoexist;
 	u8 ant_num;
+	u8 single_ant_path;
 };
 
 struct bt_coexist_info {
-- 
2.10.2
