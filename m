Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33602 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751076AbdBLAqQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Feb 2017 19:46:16 -0500
Received: by mail-ot0-f196.google.com with SMTP id f9so7469647otd.0
        for <linux-wireless@vger.kernel.org>; Sat, 11 Feb 2017 16:46:16 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/3] rtlwifi: btcoexist: Fix if == else warnings in halbtc8821a2ant.c
Date: Sat, 11 Feb 2017 18:46:03 -0600
Message-Id: <20170212004605.1308-2-Larry.Finger@lwfinger.net> (sfid-20170212_014628_310379_E09F5A65)
In-Reply-To: <20170212004605.1308-1-Larry.Finger@lwfinger.net>
References: <20170212004605.1308-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 0-DAY kernel test infrastructure reports the following:
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3023:1-3: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3035:2-4: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3037:3-5: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3047:3-5: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3075:3-5: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3085:3-5: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3129:1-3: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3141:2-4: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3143:3-5: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3153:3-5: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3179:2-4: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3181:3-5: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:3192:3-5: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2677:1-3: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2833:1-3: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2847:3-5: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2857:3-5: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2885:3-5: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2895:3-5: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2940:1-3: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2788:2-4: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2391:2-4: WARNING: possible condition with no effect (if == else)
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:2417:2-4: WARNING: possible condition with no effect (if == else)

Reported-by: kbuild-all@01.org
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 185 +++------------------
 1 file changed, 24 insertions(+), 161 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index b5daa48..1717e9c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -2388,14 +2388,8 @@ static void halbtc8821a2ant_action_sco(struct btc_coexist *btcoexist)
 		 * halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
 		 */
 
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 0); /*for voice quality*/
-		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 0); /*for voice quality*/
-		}
+		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					false, 0); /*for voice quality*/
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -2785,14 +2779,7 @@ static void halbtc8821a2ant_action_pan_hs(struct btc_coexist *btcoexist)
 						   NORMAL_EXEC, false);
 		}
 
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
-		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
-		}
+		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -2830,40 +2817,18 @@ static void halbtc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
-		/* for HID at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5afa5afa, 0xffff, 0x3);
-	} else {
-		/* for HID quality & wifi performance balance at 11n mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5afa5afa, 0xffff, 0x3);
-	}
+	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+				   0x5afa5afa, 0xffff, 0x3);
 
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  false, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  false, 3);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  true, 3);
-			}
-		}
+		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
+			btc8821a2ant_tdma_dur_adj(btcoexist, false,
+						  false, 3);
+		else
+			btc8821a2ant_tdma_dur_adj(btcoexist, false,
+						  true, 3);
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -2881,27 +2846,10 @@ static void halbtc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 	} else {
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  false, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  false, 3);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  true, 3);
-			}
-		}
+		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
+			btc8821a2ant_tdma_dur_adj(btcoexist, false, false, 3);
+		else
+			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 3);
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -2937,15 +2885,8 @@ static void halbtc8821a2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
-		/* for HID at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5a5f5a5f, 0xffff, 0x3);
-	} else {
-		/* for HID quality & wifi performance balance at 11n mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5a5f5a5f, 0xffff, 0x3);
-	}
+	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+				   0x5a5f5a5f, 0xffff, 0x3);
 
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 3);
@@ -3020,40 +2961,12 @@ static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
-		/* for HID at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5a5a5a5a, 0xffff, 0x3);
-	} else {
-		/* for HID quality & wifi performance balance at 11n mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5a5a5a5a, 0xffff, 0x3);
-	}
+	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+				   0x5a5a5a5a, 0xffff, 0x3);
 
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  true, 3);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  true, 3);
-			}
-		}
+		btc8821a2ant_tdma_dur_adj(btcoexist, true, true, 3);
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -3126,40 +3039,12 @@ static void halbtc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
-		/* for HID at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5f5b5f5b, 0xffffff, 0x3);
-	} else {
-		/*for HID quality & wifi performance balance at 11n mode*/
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5f5b5f5b, 0xffffff, 0x3);
-	}
+	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+				   0x5f5b5f5b, 0xffffff, 0x3);
 
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			}
-		}
+		btc8821a2ant_tdma_dur_adj(btcoexist, true, true, 2);
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -3176,29 +3061,7 @@ static void halbtc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 		}
 	} else {
 		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/*a2dp basic rate*/
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			} else {
-				/*a2dp edr rate*/
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			}
-		}
+		btc8821a2ant_tdma_dur_adj(btcoexist, true, true, 2);
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-- 
2.10.2
