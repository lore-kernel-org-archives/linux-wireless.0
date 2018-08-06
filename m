Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:42051 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726726AbeHFHDc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 03:03:32 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <Larry.Finger@lwfinger.net>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <colin.king@canonical.com>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rtlwifi: btcoex: Fix if == else warnings in halbtc8723b2ant.c
Date: Mon, 6 Aug 2018 12:54:40 +0800
Message-ID: <20180806045440.11920-1-yuehaibing@huawei.com> (sfid-20180806_065629_830333_9DFAB1E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix following coccinelle warning:

./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2952:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2961:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3011:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3020:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3439:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3448:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3339:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3348:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3074:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3083:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3192:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3201:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3267:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3276:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3124:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3133:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2821:2-4: WARNING: possible condition with no effect (if == else)
./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2830:2-4: WARNING: possible condition with no effect (if == else)

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 180 +++++----------------
 1 file changed, 36 insertions(+), 144 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index df3facc..6597f7c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -2818,23 +2818,11 @@ static void btc8723b2ant_action_sco(struct btc_coexist *btcoexist)
 
 	/* sw mechanism */
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, true, true,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, true, true,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, true, true,
+					  false, false);
 	} else {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, false, true,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, false, true,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, false, true,
+					  false, false);
 	}
 }
 
@@ -2949,23 +2937,11 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 	/* sw mechanism */
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, true, false,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, true, false,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, true, false,
+					  false, false);
 	} else {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, false, false,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, false, false,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, false, false,
+					  false, false);
 	}
 }
 
@@ -3008,23 +2984,11 @@ static void btc8723b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 	/* sw mechanism */
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, true, false,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, true, false,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, true, false,
+					  false, false);
 	} else {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, false, false,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, false, false,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, false, false,
+					  false, false);
 	}
 }
 
@@ -3071,23 +3035,11 @@ static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 	/* sw mechanism */
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, true, false,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, true, false,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, true, false,
+					  false, false);
 	} else {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, false, false,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, false, false,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, false, false,
+					  false, false);
 	}
 }
 
@@ -3121,23 +3073,11 @@ static void btc8723b2ant_action_pan_hs(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, true, false,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, true, false,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, true, false,
+					  false, false);
 	} else {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, false, false,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, false, false,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, false, false,
+					  false, false);
 	}
 }
 
@@ -3189,23 +3129,11 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 	/* sw mechanism	*/
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, true, false,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, true, false,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, true, false,
+					  false, false);
 	} else {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, false, false,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, false, false,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, false, false,
+					  false, false);
 	}
 }
 
@@ -3264,23 +3192,11 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 
 	/* sw mechanism */
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, true, true,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, true, true,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, true, true,
+					  false, false);
 	} else {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, false, true,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, false, true,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, false, true,
+					  false, false);
 	}
 }
 
@@ -3336,23 +3252,11 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 	/* sw mechanism */
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, true, true,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, true, true,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, true, true,
+					  false, false);
 	} else {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, false, true,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, false, true,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, false, true,
+					  false, false);
 	}
 }
 
@@ -3436,23 +3340,11 @@ static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 
 	/* sw mechanism */
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, true, true,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, true, true,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, true, true,
+					  false, false);
 	} else {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, false, true,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, false, true,
-						  false, false);
-		}
+		btc8723b2ant_sw_mechanism(btcoexist, false, true,
+					  false, false);
 	}
 }
 
-- 
2.7.0
