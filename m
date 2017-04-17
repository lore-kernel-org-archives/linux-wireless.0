Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36043 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932425AbdDQAL3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:29 -0400
Received: by mail-oi0-f67.google.com with SMTP id b187so25356492oif.3
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:29 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 13/27] rtlwifi: btcoex: 23b 1ant: parse more BT information from C2H
Date: Sun, 16 Apr 2017 19:10:57 -0500
Message-Id: <20170417001111.29384-14-Larry.Finger@lwfinger.net> (sfid-20170417_021141_159482_5D5E249A)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

BT FW provide more BT's status to be clues, and we also display them in coex log
to help debug in field.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 98 +++++++++++++++++++---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  5 ++
 2 files changed, 91 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 6580af0ade39..51c92e5603a5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2861,12 +2861,48 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_sta->bt_retry_cnt = /* [3:0] */
 			coex_sta->bt_info_c2h[rsp_source][2] & 0xf;
 
+		if (coex_sta->bt_retry_cnt >= 1)
+			coex_sta->pop_event_cnt++;
+
+		if (coex_sta->bt_info_c2h[rsp_source][2] & 0x20)
+			coex_sta->c2h_bt_remote_name_req = true;
+		else
+			coex_sta->c2h_bt_remote_name_req = false;
+
 		coex_sta->bt_rssi =
-			coex_sta->bt_info_c2h[rsp_source][3] * 2 + 10;
+			coex_sta->bt_info_c2h[rsp_source][3] * 2 - 90;
 
 		coex_sta->bt_info_ext =
 			coex_sta->bt_info_c2h[rsp_source][4];
 
+		if (coex_sta->bt_info_c2h[rsp_source][1] == 0x49) {
+			coex_sta->a2dp_bit_pool =
+				coex_sta->bt_info_c2h[rsp_source][6];
+		} else {
+			coex_sta->a2dp_bit_pool = 0;
+		}
+
+		coex_sta->bt_tx_rx_mask =
+			(coex_sta->bt_info_c2h[rsp_source][2] & 0x40);
+		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TX_RX_MASK,
+				   &coex_sta->bt_tx_rx_mask);
+
+		if (!coex_sta->bt_tx_rx_mask) {
+			/* BT into is responded by BT FW and BT RF REG
+			 * 0x3C != 0x15 => Need to switch BT TRx Mask
+			 */
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Switch BT TRx Mask since BT RF REG 0x3C != 0x15\n");
+			btcoexist->btc_set_bt_reg(btcoexist, BTC_BT_REG_RF,
+						  0x3c, 0x15);
+
+			/* BT TRx Mask lock 0x2c[0], 0x30[0] = 0 */
+			btcoexist->btc_set_bt_reg(btcoexist, BTC_BT_REG_RF,
+						  0x2c, 0x7c44);
+			btcoexist->btc_set_bt_reg(btcoexist, BTC_BT_REG_RF,
+						  0x30, 0x7c44);
+		}
+
 		/* Here we need to resend some wifi info to BT
 		 * because bt is reset and loss of the info.
 		 */
@@ -2911,6 +2947,8 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 	else
 		coex_sta->c2h_bt_inquiry_page = false;
 
+	coex_sta->num_of_profile = 0;
+
 	/* set link exist status */
 	if (!(bt_info & BT_INFO_8723B_1ANT_B_CONNECTION)) {
 		coex_sta->bt_link_exist = false;
@@ -2923,22 +2961,43 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 	} else {
 		/* connection exists */
 		coex_sta->bt_link_exist = true;
-		if (bt_info & BT_INFO_8723B_1ANT_B_FTP)
+		if (bt_info & BT_INFO_8723B_1ANT_B_FTP) {
 			coex_sta->pan_exist = true;
-		else
+			coex_sta->num_of_profile++;
+		} else {
 			coex_sta->pan_exist = false;
-		if (bt_info & BT_INFO_8723B_1ANT_B_A2DP)
+		}
+		if (bt_info & BT_INFO_8723B_1ANT_B_A2DP) {
 			coex_sta->a2dp_exist = true;
-		else
+			coex_sta->num_of_profile++;
+		} else {
 			coex_sta->a2dp_exist = false;
-		if (bt_info & BT_INFO_8723B_1ANT_B_HID)
+		}
+		if (bt_info & BT_INFO_8723B_1ANT_B_HID) {
 			coex_sta->hid_exist = true;
-		else
+			coex_sta->num_of_profile++;
+		} else {
 			coex_sta->hid_exist = false;
-		if (bt_info & BT_INFO_8723B_1ANT_B_SCO_ESCO)
+		}
+		if (bt_info & BT_INFO_8723B_1ANT_B_SCO_ESCO) {
 			coex_sta->sco_exist = true;
-		else
+			coex_sta->num_of_profile++;
+		} else {
 			coex_sta->sco_exist = false;
+		}
+
+		if ((!coex_sta->hid_exist) &&
+		    (!coex_sta->c2h_bt_inquiry_page) &&
+		    (!coex_sta->sco_exist)) {
+			if (coex_sta->high_priority_tx +
+				    coex_sta->high_priority_rx >=
+			    160) {
+				coex_sta->hid_exist = true;
+				coex_sta->wrong_profile_notification++;
+				coex_sta->num_of_profile++;
+				bt_info = bt_info | 0x28;
+			}
+		}
 
 		/* Add Hi-Pri Tx/Rx counter to avoid false detection */
 		if (((coex_sta->hid_exist) || (coex_sta->sco_exist)) &&
@@ -2947,11 +3006,27 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 		    (!coex_sta->c2h_bt_inquiry_page))
 			coex_sta->bt_hi_pri_link_exist = true;
 
+		if ((bt_info & BT_INFO_8723B_1ANT_B_ACL_BUSY) &&
+		    (coex_sta->num_of_profile == 0)) {
+			if (coex_sta->low_priority_tx +
+				    coex_sta->low_priority_rx >=
+			    160) {
+				coex_sta->pan_exist = true;
+				coex_sta->num_of_profile++;
+				coex_sta->wrong_profile_notification++;
+				bt_info = bt_info | 0x88;
+			}
+		}
 	}
 
 	halbtc8723b1ant_update_bt_link_info(btcoexist);
 
-	if (!(bt_info&BT_INFO_8723B_1ANT_B_CONNECTION)) {
+	/* mask profile bit for connect-ilde identification
+	 * ( for CSR case: A2DP idle --> 0x41)
+	 */
+	bt_info = bt_info & 0x1f;
+
+	if (!(bt_info & BT_INFO_8723B_1ANT_B_CONNECTION)) {
 		coex_dm->bt_status = BT_8723B_1ANT_BT_STATUS_NON_CONNECTED_IDLE;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], BtInfoNotify(), BT Non-Connected idle!\n");
@@ -2973,8 +3048,7 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], BtInfoNotify(), BT ACL busy!!!\n");
 	} else {
-		coex_dm->bt_status =
-			BT_8723B_1ANT_BT_STATUS_MAX;
+		coex_dm->bt_status = BT_8723B_1ANT_BT_STATUS_MAX;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], BtInfoNotify(), BT Non-Defined state!!\n");
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index d7c1806b094a..b48cd5bb0ece 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -148,6 +148,7 @@ struct coex_sta_8723b_1ant {
 	bool hid_exist;
 	bool pan_exist;
 	bool bt_hi_pri_link_exist;
+	u8 num_of_profile;
 
 	bool under_lps;
 	bool under_ips;
@@ -159,10 +160,12 @@ struct coex_sta_8723b_1ant {
 	u8 bt_rssi;
 	u8 pre_bt_rssi_state;
 	u8 pre_wifi_rssi_state[4];
+	bool bt_tx_rx_mask;
 	bool c2h_bt_info_req_sent;
 	u8 bt_info_c2h[BT_INFO_SRC_8723B_1ANT_MAX][10];
 	u32 bt_info_c2h_cnt[BT_INFO_SRC_8723B_1ANT_MAX];
 	bool c2h_bt_inquiry_page;
+	bool c2h_bt_remote_name_req;
 	u8 bt_retry_cnt;
 	u8 bt_info_ext;
 	u8 scan_ap_num;
@@ -183,6 +186,8 @@ struct coex_sta_8723b_1ant {
 	bool cck_lock;
 	bool pre_ccklock;
 
+	u32 wrong_profile_notification;
+
 	u8 a2dp_bit_pool;
 	u8 cut_version;
 };
-- 
2.12.0
