Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:36531 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbdBLAqR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Feb 2017 19:46:17 -0500
Received: by mail-ot0-f193.google.com with SMTP id 36so7471053otx.3
        for <linux-wireless@vger.kernel.org>; Sat, 11 Feb 2017 16:46:17 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 2/3] rtlwifi: btcoexist: Fix if == else warnings in halbtc8821a1ant.c
Date: Sat, 11 Feb 2017 18:46:04 -0600
Message-Id: <20170212004605.1308-3-Larry.Finger@lwfinger.net> (sfid-20170212_014628_622499_C5369380)
In-Reply-To: <20170212004605.1308-1-Larry.Finger@lwfinger.net>
References: <20170212004605.1308-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 0-DAY kernel test infrastructure reports the following:
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c:1771:1-3: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c:2126:3-5: WARNING: possible condition with no effect (if == else)

Reported-by: kbuild-all@01.org
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c        | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 20562f0..8b689ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1768,11 +1768,7 @@ static void btc8821a1ant_act_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
 	/* tdma and coex table*/
 	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
 
-	if (BT_8821A_1ANT_WIFI_STATUS_NON_CONNECTED_ASSO_AUTH_SCAN ==
-	    wifi_status)
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
-	else
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+	halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 }
 
 static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
@@ -2123,16 +2119,8 @@ static void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 			wifi_rssi_state =
 				 halbtc8821a1ant_WifiRssiState(btcoexist, 1, 2,
 							       30, 0);
-			if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-			    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-				halbtc8821a1ant_limited_tx(btcoexist,
-							   NORMAL_EXEC, 1, 1,
-							   1, 1);
-			} else {
-				halbtc8821a1ant_limited_tx(btcoexist,
-							   NORMAL_EXEC, 1, 1,
-							   1, 1);
-			}
+			halbtc8821a1ant_limited_tx(btcoexist,
+						   NORMAL_EXEC, 1, 1, 1, 1);
 		} else {
 			halbtc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC,
 						   0, 0, 0, 0);
-- 
2.10.2
