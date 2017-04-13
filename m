Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35627 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755032AbdDMSHV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:21 -0400
Received: by mail-oi0-f65.google.com with SMTP id g204so13597249oib.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:21 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 06/19] rtlwifi: btcoex: 21a 2ant: move from bt_stack_info to bt_link_info
Date: Thu, 13 Apr 2017 13:06:57 -0500
Message-Id: <20170413180710.19953-7-Larry.Finger@lwfinger.net> (sfid-20170413_200802_366320_76AFE357)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Gather variables to the 8821a2ant coex structure.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 112 ++++++++++-----------
 1 file changed, 55 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index a074d480166d..4abfddcf2d11 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -410,50 +410,43 @@ static void btc8821a2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 static u8 btc8821a2ant_action_algorithm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct btc_stack_info *stack_info = &btcoexist->stack_info;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 	u8 algorithm = BT_8821A_2ANT_COEX_ALGO_UNDEFINED;
 	u8 num_of_diff_profile = 0;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
-	/* sync  BTInfo with BT firmware and stack */
-	if (!stack_info->hid_exist)
-		stack_info->hid_exist = coex_sta->hid_exist;
-	/* when stack HID report error, here we use the info from bt fw. */
-	if (!stack_info->bt_link_exist)
-		stack_info->bt_link_exist = coex_sta->bt_link_exist;
-
-	if (!coex_sta->bt_link_exist) {
+	if (!bt_link_info->bt_link_exist) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], No profile exists!!!\n");
+			"[BTCoex], No BT link exists!!!\n");
 		return algorithm;
 	}
 
-	if (coex_sta->sco_exist)
+	if (bt_link_info->sco_exist)
 		num_of_diff_profile++;
-	if (coex_sta->hid_exist)
+	if (bt_link_info->hid_exist)
 		num_of_diff_profile++;
-	if (coex_sta->pan_exist)
+	if (bt_link_info->pan_exist)
 		num_of_diff_profile++;
-	if (coex_sta->a2dp_exist)
+	if (bt_link_info->a2dp_exist)
 		num_of_diff_profile++;
 
 	if (num_of_diff_profile == 1) {
-		if (coex_sta->sco_exist) {
+		if (bt_link_info->sco_exist) {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], SCO only\n");
 			algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 		} else {
-			if (coex_sta->hid_exist) {
+			if (bt_link_info->hid_exist) {
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], HID only\n");
 				algorithm = BT_8821A_2ANT_COEX_ALGO_HID;
-			} else if (coex_sta->a2dp_exist) {
+			} else if (bt_link_info->a2dp_exist) {
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], A2DP only\n");
 				algorithm = BT_8821A_2ANT_COEX_ALGO_A2DP;
-			} else if (coex_sta->pan_exist) {
+			} else if (bt_link_info->pan_exist) {
 				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
@@ -468,16 +461,16 @@ static u8 btc8821a2ant_action_algorithm(struct btc_coexist *btcoexist)
 			}
 		}
 	} else if (num_of_diff_profile == 2) {
-		if (coex_sta->sco_exist) {
-			if (coex_sta->hid_exist) {
+		if (bt_link_info->sco_exist) {
+			if (bt_link_info->hid_exist) {
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], SCO + HID\n");
-				algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
-			} else if (coex_sta->a2dp_exist) {
+				algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
+			} else if (bt_link_info->a2dp_exist) {
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], SCO + A2DP ==> SCO\n");
-				algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
-			} else if (coex_sta->pan_exist) {
+				algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
+			} else if (bt_link_info->pan_exist) {
 				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
@@ -487,99 +480,104 @@ static u8 btc8821a2ant_action_algorithm(struct btc_coexist *btcoexist)
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "[BTCoex], SCO + PAN(EDR)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				}
 			}
 		} else {
-			if (coex_sta->hid_exist &&
-			    coex_sta->a2dp_exist) {
+			if (bt_link_info->hid_exist &&
+			    bt_link_info->a2dp_exist) {
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], HID + A2DP\n");
 				algorithm = BT_8821A_2ANT_COEX_ALGO_HID_A2DP;
-			} else if (coex_sta->hid_exist &&
-				coex_sta->pan_exist) {
+			} else if (bt_link_info->hid_exist &&
+				bt_link_info->pan_exist) {
 				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "[BTCoex], HID + PAN(HS)\n");
-					algorithm =  BT_8821A_2ANT_COEX_ALGO_HID;
+					algorithm = BT_8821A_2ANT_COEX_ALGO_HID;
 				} else {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "[BTCoex], HID + PAN(EDR)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					algorithm =
+					    BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
 				}
-			} else if (coex_sta->pan_exist &&
-				coex_sta->a2dp_exist) {
+			} else if (bt_link_info->pan_exist &&
+				bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "[BTCoex], A2DP + PAN(HS)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_A2DP_PANHS;
+					algorithm =
+					    BT_8821A_2ANT_COEX_ALGO_A2DP_PANHS;
 				} else {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "[BTCoex], A2DP + PAN(EDR)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_A2DP;
+					algorithm =
+					    BT_8821A_2ANT_COEX_ALGO_PANEDR_A2DP;
 				}
 			}
 		}
 	} else if (num_of_diff_profile == 3) {
-		if (coex_sta->sco_exist) {
-			if (coex_sta->hid_exist &&
-			    coex_sta->a2dp_exist) {
+		if (bt_link_info->sco_exist) {
+			if (bt_link_info->hid_exist &&
+			    bt_link_info->a2dp_exist) {
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], SCO + HID + A2DP ==> HID\n");
-				algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
-			} else if (coex_sta->hid_exist &&
-				coex_sta->pan_exist) {
+				algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
+			} else if (bt_link_info->hid_exist &&
+				bt_link_info->pan_exist) {
 				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "[BTCoex], SCO + HID + PAN(HS)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				} else {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "[BTCoex], SCO + HID + PAN(EDR)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				}
-			} else if (coex_sta->pan_exist &&
-				   coex_sta->a2dp_exist) {
+			} else if (bt_link_info->pan_exist &&
+				   bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "[BTCoex], SCO + A2DP + PAN(HS)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				} else {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "[BTCoex], SCO + A2DP + PAN(EDR) ==> HID\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				}
 			}
 		} else {
-			if (coex_sta->hid_exist &&
-			    coex_sta->pan_exist &&
-			    coex_sta->a2dp_exist) {
+			if (bt_link_info->hid_exist &&
+			    bt_link_info->pan_exist &&
+			    bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "[BTCoex], HID + A2DP + PAN(HS)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_HID_A2DP;
+					algorithm =
+					    BT_8821A_2ANT_COEX_ALGO_HID_A2DP;
 				} else {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "[BTCoex], HID + A2DP + PAN(EDR)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_HID_A2DP_PANEDR;
+					algorithm =
+					BT_8821A_2ANT_COEX_ALGO_HID_A2DP_PANEDR;
 				}
 			}
 		}
 	} else if (num_of_diff_profile >= 3) {
-		if (coex_sta->sco_exist) {
-			if (coex_sta->hid_exist &&
-			    coex_sta->pan_exist &&
-			    coex_sta->a2dp_exist) {
+		if (bt_link_info->sco_exist) {
+			if (bt_link_info->hid_exist &&
+			    bt_link_info->pan_exist &&
+			    bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
@@ -589,7 +587,7 @@ static u8 btc8821a2ant_action_algorithm(struct btc_coexist *btcoexist)
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "[BTCoex], SCO + HID + A2DP + PAN(EDR)==>PAN(EDR)+HID\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				}
 			}
 		}
-- 
2.12.0
