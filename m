Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36533 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752265AbdFURPs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 13:15:48 -0400
Received: by mail-oi0-f68.google.com with SMTP id g14so16355977oib.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2017 10:15:48 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 4/8] rtlwifi: Update some cases in btc_get function -- roam, 5G, AP mode, and return value.
Date: Wed, 21 Jun 2017 12:15:34 -0500
Message-Id: <20170621171538.4462-5-Larry.Finger@lwfinger.net> (sfid-20170621_191551_933115_46DA1BA4)
In-Reply-To: <20170621171538.4462-1-Larry.Finger@lwfinger.net>
References: <20170621171538.4462-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Return value may be false in some situations.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 24 +++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index eaa916a0727b..d8fb2442f795 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -381,6 +381,7 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 	u32 *u32_tmp = (u32 *)out_buf;
 	u8 *u8_tmp = (u8 *)out_buf;
 	bool tmp = false;
+	bool ret = true;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return false;
@@ -388,9 +389,11 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 	switch (get_type) {
 	case BTC_GET_BL_HS_OPERATION:
 		*bool_tmp = false;
+		ret = false;
 		break;
 	case BTC_GET_BL_HS_CONNECTING:
 		*bool_tmp = false;
+		ret = false;
 		break;
 	case BTC_GET_BL_WIFI_CONNECTED:
 		if (rtlpriv->mac80211.opmode == NL80211_IFTYPE_STATION &&
@@ -429,11 +432,16 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 		*bool_tmp = false;
 		break;
 	case BTC_GET_BL_WIFI_UNDER_5G:
-		/* TODO */
-		*bool_tmp = false;
+		if (rtlhal->current_bandtype == BAND_ON_5G)
+			*bool_tmp = true;
+		else
+			*bool_tmp = false;
 		break;
 	case BTC_GET_BL_WIFI_AP_MODE_ENABLE:
-		*bool_tmp = false;
+		if (mac->opmode == NL80211_IFTYPE_AP)
+			*bool_tmp = true;
+		else
+			*bool_tmp = false;
 		break;
 	case BTC_GET_BL_WIFI_ENABLE_ENCRYPTION:
 		if (NO_ENCRYPTION == rtlpriv->sec.pairwise_enc_algorithm)
@@ -460,8 +468,8 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 		*s32_tmp = halbtc_get_wifi_rssi(rtlpriv);
 		break;
 	case BTC_GET_S4_HS_RSSI:
-		/* TODO */
-		*s32_tmp = halbtc_get_wifi_rssi(rtlpriv);
+		*s32_tmp = 0;
+		ret = false;
 		break;
 	case BTC_GET_U4_WIFI_BW:
 		*u32_tmp = halbtc_get_wifi_bw(btcoexist);
@@ -491,7 +499,8 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 		*u8_tmp = halbtc_get_wifi_central_chnl(btcoexist);
 		break;
 	case BTC_GET_U1_WIFI_HS_CHNL:
-		*u8_tmp = 1;
+		*u8_tmp = 0;
+		ret = false;
 		break;
 	case BTC_GET_U1_AP_NUM:
 		/* driver do not know AP num,
@@ -512,10 +521,11 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 		break;
 
 	default:
+		ret = false;
 		break;
 	}
 
-	return true;
+	return ret;
 }
 
 static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
-- 
2.12.3
