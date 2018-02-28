Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52463 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbeB1DHl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 22:07:41 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/15] rtlwifi: btcoex: new definitions introduced by 8822be
Date: Wed, 28 Feb 2018 11:07:13 +0800
Message-ID: <20180228030718.19510-11-pkshih@realtek.com> (sfid-20180228_040755_409497_C1384471)
In-Reply-To: <20180228030718.19510-1-pkshih@realtek.com>
References: <20180228030718.19510-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

New constant and variables definitions are used by btcoex of 8822b, so
this commit add them.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 0a7b09305bc3..049e92a8afbe 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -62,6 +62,8 @@
 #define		BTC_ANT_PATH_WIFI			0
 #define		BTC_ANT_PATH_BT				1
 #define		BTC_ANT_PATH_PTA			2
+#define		BTC_ANT_PATH_WIFI5G			3
+#define		BTC_ANT_PATH_AUTO			4
 /* dual Antenna definition */
 #define		BTC_ANT_WIFI_AT_MAIN			0
 #define		BTC_ANT_WIFI_AT_AUX			1
@@ -205,6 +207,7 @@ enum btc_wifi_traffic_dir {
 enum btc_wifi_pnp {
 	BTC_WIFI_PNP_WAKE_UP = 0x0,
 	BTC_WIFI_PNP_SLEEP = 0x1,
+	BTC_WIFI_PNP_SLEEP_KEEP_ANT = 0x2,
 	BTC_WIFI_PNP_MAX
 };
 
@@ -387,6 +390,7 @@ enum btc_notify_type_lps {
 enum btc_notify_type_scan {
 	BTC_SCAN_FINISH = 0x0,
 	BTC_SCAN_START = 0x1,
+	BTC_SCAN_START_2G = 0x2,
 	BTC_SCAN_MAX
 };
 
@@ -561,6 +565,7 @@ struct btc_bt_info {
 	u16 bt_hci_ver;
 	u16 bt_real_fw_ver;
 	u8 bt_fw_ver;
+	u32 bt_get_fw_ver;
 
 	bool bt_disable_low_pwr;
 
@@ -632,6 +637,7 @@ struct btc_bt_link_info {
 	bool pan_exist;
 	bool pan_only;
 	bool slave_role;
+	bool acl_busy;
 };
 
 enum btc_antenna_pos {
-- 
2.15.1
