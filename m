Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35500 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755694AbcLBBsz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:55 -0500
Received: by mail-oi0-f68.google.com with SMTP id v84so25421938oie.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:54 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 09/14] rtlwifi: ibtcoex: move bt_type declaration
Date: Thu,  1 Dec 2016 19:48:28 -0600
Message-Id: <20161202014833.6856-10-Larry.Finger@lwfinger.net> (sfid-20161202_024900_201841_1FE587F2)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Routine rtl_get_hwpg_bt_type() is better in halbtcoutsrc.c than in
rtl_btc.c.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 5 +++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c      | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index d2e4960..be451473 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -151,6 +151,11 @@ u8 rtl_get_hwpg_single_ant_path(struct rtl_priv *rtlpriv)
 	return rtlpriv->btcoexist.btc_info.single_ant_path;
 }
 
+u8 rtl_get_hwpg_bt_type(struct rtl_priv *rtlpriv)
+{
+	return rtlpriv->btcoexist.btc_info.bt_type;
+}
+
 u8 rtl_get_hwpg_ant_num(struct rtl_priv *rtlpriv)
 {
 	u8 num;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index 54e893c..46e0fa6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -198,11 +198,6 @@ u8 rtl_get_hwpg_bt_exist(struct rtl_priv *rtlpriv)
 	return rtlpriv->btcoexist.btc_info.btcoexist;
 }
 
-u8 rtl_get_hwpg_bt_type(struct rtl_priv *rtlpriv)
-{
-	return rtlpriv->btcoexist.btc_info.bt_type;
-}
-
 MODULE_AUTHOR("Page He	<page_he@realsil.com.cn>");
 MODULE_AUTHOR("Realtek WlanFAE	<wlanfae@realtek.com>");
 MODULE_AUTHOR("Larry Finger	<Larry.FInger@lwfinger.net>");
-- 
2.10.2
