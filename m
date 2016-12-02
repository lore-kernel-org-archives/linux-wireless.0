Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36148 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755886AbcLBBs5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:57 -0500
Received: by mail-oi0-f65.google.com with SMTP id u15so25526068oie.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:56 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 12/14] rtlwifi: btcoexist: Add vendor definition for new btcoexist
Date: Thu,  1 Dec 2016 19:48:31 -0600
Message-Id: <20161202014833.6856-13-Larry.Finger@lwfinger.net> (sfid-20161202_024904_605890_E8C26B52)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Routine halbtc_get() will need to be able to get the vendor ID.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 3 +++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index be451473..9a89ae0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -364,6 +364,9 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 	case BTC_GET_U4_BT_PATCH_VER:
 		*u32_tmp = halbtc_get_bt_patch_version(btcoexist);
 		break;
+	case BTC_GET_U4_VENDOR:
+		*u32_tmp = BTC_VENDOR_OTHER;
+		break;
 	case BTC_GET_U1_WIFI_DOT11_CHNL:
 		*u8_tmp = rtlphy->current_channel;
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index d4da3a1..103abd8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -251,6 +251,7 @@ enum btc_get_type {
 	BTC_GET_U4_WIFI_FW_VER,
 	BTC_GET_U4_WIFI_LINK_STATUS,
 	BTC_GET_U4_BT_PATCH_VER,
+	BTC_GET_U4_VENDOR,
 
 	/* type u1Byte */
 	BTC_GET_U1_WIFI_DOT11_CHNL,
@@ -268,6 +269,12 @@ enum btc_get_type {
 	BTC_GET_MAX
 };
 
+enum btc_vendor {
+	BTC_VENDOR_LENOVO,
+	BTC_VENDOR_ASUS,
+	BTC_VENDOR_OTHER
+};
+
 enum btc_set_type {
 	/* type bool */
 	BTC_SET_BL_BT_DISABLE,
-- 
2.10.2
