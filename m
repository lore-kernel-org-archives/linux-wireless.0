Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52450 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbeB1DHj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 22:07:39 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/15] rtlwifi: btcoex: Get status of multichannel concurrence
Date: Wed, 28 Feb 2018 11:07:08 +0800
Message-ID: <20180228030718.19510-6-pkshih@realtek.com> (sfid-20180228_040756_221926_1AA13437)
In-Reply-To: <20180228030718.19510-1-pkshih@realtek.com>
References: <20180228030718.19510-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

btcoex does different decision according to MCC or SCC status, but
driver is still SCC currently.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 3 +++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 823694cb4fdb..1a24aed34094 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -577,6 +577,9 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 			tmp = true;
 		*bool_tmp = tmp;
 		break;
+	case BTC_GET_BL_WIFI_DUAL_BAND_CONNECTED:
+		*u8_tmp = BTC_MULTIPORT_SCC;
+		break;
 	case BTC_GET_BL_WIFI_BUSY:
 		if (halbtc_is_wifi_busy(rtlpriv))
 			*bool_tmp = true;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 3c6a1e8851ec..fe793b787716 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -251,6 +251,7 @@ enum btc_get_type {
 	BTC_GET_BL_HS_OPERATION,
 	BTC_GET_BL_HS_CONNECTING,
 	BTC_GET_BL_WIFI_CONNECTED,
+	BTC_GET_BL_WIFI_DUAL_BAND_CONNECTED,
 	BTC_GET_BL_WIFI_BUSY,
 	BTC_GET_BL_WIFI_SCAN,
 	BTC_GET_BL_WIFI_LINK,
@@ -436,6 +437,13 @@ enum btc_notify_type_stack_operation {
 	BTC_STACK_OP_MAX
 };
 
+enum {
+	BTC_MULTIPORT_SCC,
+	BTC_MULTIPORT_MCC_2CHANNEL,
+	BTC_MULTIPORT_MCC_2BAND,
+	BTC_MULTIPORT_MAX
+};
+
 struct btc_bt_info {
 	bool bt_disabled;
 	u8 rssi_adjust_for_agc_table_on;
-- 
2.15.1
