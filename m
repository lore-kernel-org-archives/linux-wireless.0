Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36123 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755026AbcLBBsw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:52 -0500
Received: by mail-oi0-f65.google.com with SMTP id u15so25525819oie.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:52 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 06/14] rtlwifi: rtl8723be: btcoexist: Add single_ant_path
Date: Thu,  1 Dec 2016 19:48:25 -0600
Message-Id: <20161202014833.6856-7-Larry.Finger@lwfinger.net> (sfid-20161202_025212_457148_2A542FBA)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
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
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 5 +++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h      | 1 +
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c           | 1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h                   | 1 +
 4 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 91cc139..0a47f135 100644
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
index aba60c3..5e98c26 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -2661,6 +2661,7 @@ void rtl8723be_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
 		rtlpriv->btcoexist.btc_info.btcoexist = 0;
 		rtlpriv->btcoexist.btc_info.bt_type = BT_RTL8723B;
 		rtlpriv->btcoexist.btc_info.ant_num = ANT_X2;
+		rtlpriv->btcoexist.btc_info.single_ant_path = 0;
 	}
 
 	/* override ant_num / ant_path */
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 80e6f5e..4e3b441 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2471,6 +2471,7 @@ struct rtl_btc_info {
 	u8 bt_type;
 	u8 btcoexist;
 	u8 ant_num;
+	u8 single_ant_path;
 };
 
 struct bt_coexist_info {
-- 
2.10.2
