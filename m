Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34379 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbcLBBsx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:53 -0500
Received: by mail-oi0-f65.google.com with SMTP id m75so25564970oig.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:53 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 07/14] rtlwifi: move btcoex's ant_num declaration
Date: Thu,  1 Dec 2016 19:48:26 -0600
Message-Id: <20161202014833.6856-8-Larry.Finger@lwfinger.net> (sfid-20161202_024857_114989_71048661)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

File halbtcoutsrc.c is a better place for routine rtl_get_hwpg_ant_num()
than file rtl_btc.c.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c    | 12 ++++++++++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c     | 11 -----------
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h     |  2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c          |  2 ++
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 0a47f135..d69bf32 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -151,6 +151,18 @@ u8 rtl_get_hwpg_single_ant_path(struct rtl_priv *rtlpriv)
 	return rtlpriv->btcoexist.btc_info.single_ant_path;
 }
 
+u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv)
+{
+	u8 num;
+
+	if (rtlpriv->btcoexist.btc_info.ant_num == ANT_X2)
+		num = 2;
+	else
+		num = 1;
+
+	return num;
+}
+
 static void halbtc_leave_lps(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index d3fd921..54e893c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -178,17 +178,6 @@ struct rtl_btc_ops *rtl_btc_get_ops_pointer(void)
 }
 EXPORT_SYMBOL(rtl_btc_get_ops_pointer);
 
-u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv)
-{
-	u8 num;
-
-	if (rtlpriv->btcoexist.btc_info.ant_num == ANT_X2)
-		num = 2;
-	else
-		num = 1;
-
-	return num;
-}
 
 enum rt_media_status mgnt_link_status_query(struct ieee80211_hw *hw)
 {
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
index 65c1c52..bba7e23e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
@@ -46,9 +46,9 @@ void rtl_btc_special_packet_notify(struct rtl_priv *rtlpriv, u8 pkt_type);
 
 struct rtl_btc_ops *rtl_btc_get_ops_pointer(void);
 
-u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv);
 u8 rtl_get_hwpg_bt_exist(struct rtl_priv *rtlpriv);
 u8 rtl_get_hwpg_bt_type(struct rtl_priv *rtlpriv);
+u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv);
 u8 rtl_get_hwpg_single_ant_path(struct rtl_priv *rtlpriv);
 enum rt_media_status mgnt_link_status_query(struct ieee80211_hw *hw);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 5e98c26..54a26da 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -2657,6 +2657,8 @@ void rtl8723be_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
 		value = hwinfo[EEPROM_RF_BT_SETTING_8723B];
 		rtlpriv->btcoexist.btc_info.bt_type = BT_RTL8723B;
 		rtlpriv->btcoexist.btc_info.ant_num = (value & 0x1);
+		rtlpriv->btcoexist.btc_info.single_ant_path =
+			 (value & 0x40);	/*0xc3[6]*/
 	} else {
 		rtlpriv->btcoexist.btc_info.btcoexist = 0;
 		rtlpriv->btcoexist.btc_info.bt_type = BT_RTL8723B;
-- 
2.10.2
