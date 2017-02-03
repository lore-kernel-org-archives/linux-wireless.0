Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33064 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751376AbdBCRcz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 12:32:55 -0500
Received: by mail-oi0-f67.google.com with SMTP id j15so1916509oih.0
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2017 09:32:55 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 04/11 V3] rtlwifi: btcoexist: Add vendor definition for new btcoexist
Date: Fri,  3 Feb 2017 11:32:25 -0600
Message-Id: <20170120212716.29887-5-Larry.Finger@lwfinger.net> (sfid-20170203_183306_624185_7AB0AC70)
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Routine halbtc_get() will need to be able to get the vendor ID.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - no changes
V3 - no changes
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 3 +++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 91cc139..8a0e773 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -335,6 +335,9 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
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
index eb89011..f9e7c5e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -228,6 +228,7 @@ enum btc_get_type {
 	BTC_GET_U4_WIFI_FW_VER,
 	BTC_GET_U4_WIFI_LINK_STATUS,
 	BTC_GET_U4_BT_PATCH_VER,
+	BTC_GET_U4_VENDOR,
 
 	/* type u1Byte */
 	BTC_GET_U1_WIFI_DOT11_CHNL,
@@ -245,6 +246,12 @@ enum btc_get_type {
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
