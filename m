Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:58647 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751650AbeDIHwB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 03:52:01 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <gustavo@embeddedor.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] rtlwifi: btcoex: remove identical statements within if-else branches
Date: Mon, 9 Apr 2018 15:51:31 +0800
Message-ID: <20180409075131.7535-1-pkshih@realtek.com> (sfid-20180409_095204_992097_4E7059A9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Since the statements are identical, we can safely remove the statements.
The commit 42e74946f016 ("rtlwifi: btcoexist: Fix if == else warnings in
halbtc8821a1ant.c") had fixed the statements, but the commit c6821613e653
("rtlwifi: btcoex: follow linux coding style") that converted coding style
and upgraded btcoex didn't include the fix.

Reported-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c       | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index d3eb717078bf..f29bf4f3a905 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1578,11 +1578,7 @@ static void btc8821a1ant_act_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
 	/* tdma and coex table */
 	btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
 
-	if (BT_8821A_1ANT_WIFI_STATUS_NON_CONNECTED_ASSO_AUTH_SCAN ==
-	    wifi_status)
-		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
-	else
-		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+	btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 }
 
 static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
@@ -1992,16 +1988,9 @@ static void btc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 			wifi_rssi_state =
 				btc8821a1ant_wifi_rssi_state(btcoexist, 1, 2,
 							     30, 0);
-			if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-			    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-				btc8821a1ant_limited_tx(btcoexist,
-							NORMAL_EXEC, 1, 1,
-							0, 1);
-			} else {
-				btc8821a1ant_limited_tx(btcoexist,
-							NORMAL_EXEC, 1, 1,
-							0, 1);
-			}
+			btc8821a1ant_limited_tx(btcoexist,
+						NORMAL_EXEC, 1, 1,
+						0, 1);
 		} else {
 			btc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC,
 						0, 0, 0, 0);
-- 
2.15.1
