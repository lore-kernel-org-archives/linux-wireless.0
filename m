Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34441 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbdBLAqS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Feb 2017 19:46:18 -0500
Received: by mail-ot0-f195.google.com with SMTP id 73so7463620otj.1
        for <linux-wireless@vger.kernel.org>; Sat, 11 Feb 2017 16:46:18 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 3/3] rtlwifi: btcoexist: Fix if == else warnings in halbtc8723b1ant.c
Date: Sat, 11 Feb 2017 18:46:05 -0600
Message-Id: <20170212004605.1308-4-Larry.Finger@lwfinger.net> (sfid-20170212_014628_922219_EB85954A)
In-Reply-To: <20170212004605.1308-1-Larry.Finger@lwfinger.net>
References: <20170212004605.1308-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 0-DAY kernel test infrastructure reports the following:
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c:1875:2-4: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c:2253:3-5: WARNING: possible condition with no effect (if == else)

Reported-by: kbuild-all@01.org
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 24 ++++------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index e9f0a76..d67bbfb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1872,16 +1872,8 @@ static void halbtc8723b1ant_action_wifi_connected_bt_acl_busy(
 		}
 	} else if (bt_link_info->hid_exist &&
 			bt_link_info->a2dp_exist) { /*HID+A2DP */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->auto_tdma_adjust = false;
-		} else { /*for low BT RSSI*/
-			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->auto_tdma_adjust = false;
-		}
+		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
+		coex_dm->auto_tdma_adjust = false;
 
 		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 6);
 	 /*PAN(OPP,FTP), HID+PAN(OPP,FTP) */
@@ -2250,16 +2242,8 @@ static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 			wifi_rssi_state =
 				halbtc8723b1ant_wifi_rssi_state(btcoexist,
 								1, 2, 30, 0);
-			if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-			    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-				halbtc8723b1ant_limited_tx(btcoexist,
-							   NORMAL_EXEC,
-							   1, 1, 1, 1);
-			} else {
-				halbtc8723b1ant_limited_tx(btcoexist,
-							   NORMAL_EXEC,
-							   1, 1, 1, 1);
-			}
+			halbtc8723b1ant_limited_tx(btcoexist,
+						   NORMAL_EXEC, 1, 1, 1, 1);
 		} else {
 			halbtc8723b1ant_limited_tx(btcoexist, NORMAL_EXEC,
 						   0, 0, 0, 0);
-- 
2.10.2
