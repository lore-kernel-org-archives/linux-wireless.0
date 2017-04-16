Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35012 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756679AbdDPTEm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 15:04:42 -0400
Received: by mail-oi0-f65.google.com with SMTP id a21so8126867oic.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 12:04:41 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 08/10] rtlwifi: btcoex: 21a 2ant: refine bt info notify to have more profilings
Date: Sun, 16 Apr 2017 14:04:26 -0500
Message-Id: <20170416190428.23857-9-Larry.Finger@lwfinger.net> (sfid-20170416_210451_961239_29B4653B)
In-Reply-To: <20170416190428.23857-1-Larry.Finger@lwfinger.net>
References: <20170416190428.23857-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

We add some profiling combinations when the bt notifies the coex
mechanism to detect more situations and adjust the coex to fit to it.

Also monitro if the wifi is under 5G mode, if so, the signals do net
intefere each other, bt can just ignore it

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 167 +++++++++++++++------
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |   4 +
 2 files changed, 124 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 531598366327..1307099a02f3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -4019,9 +4019,12 @@ void ex_btc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	u8 bt_info = 0;
 	u8 i, rsp_source = 0;
 	bool bt_busy = false, limited_dig = false;
-	bool wifi_connected = false, bt_hs_on = false;
+	bool wifi_connected = false, wifi_under_5g = false;
 
 	coex_sta->c2h_bt_info_req_sent = false;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
 
 	rsp_source = tmp_buf[0] & 0xf;
 	if (rsp_source >= BT_INFO_SRC_8821A_2ANT_MAX)
@@ -4044,16 +4047,35 @@ void ex_btc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		}
 	}
 
+	if (btcoexist->manual_control) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), return for Manual CTRL<===\n");
+		return;
+	}
+
 	if (BT_INFO_SRC_8821A_2ANT_WIFI_FW != rsp_source) {
 		/* [3:0] */
 		coex_sta->bt_retry_cnt =
 			coex_sta->bt_info_c2h[rsp_source][2]&0xf;
 
 		coex_sta->bt_rssi =
-			coex_sta->bt_info_c2h[rsp_source][3]*2+10;
+			coex_sta->bt_info_c2h[rsp_source][3] * 2 + 10;
 
-		coex_sta->bt_info_ext =
-			coex_sta->bt_info_c2h[rsp_source][4];
+		coex_sta->bt_info_ext = coex_sta->bt_info_c2h[rsp_source][4];
+
+		coex_sta->bt_tx_rx_mask =
+			(coex_sta->bt_info_c2h[rsp_source][2] & 0x40);
+		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TX_RX_MASK,
+				   &coex_sta->bt_tx_rx_mask);
+		if (coex_sta->bt_tx_rx_mask) {
+			/* BT into is responded by BT FW and BT RF REG 0x3C !=
+			 * 0x01 => Need to switch BT TRx Mask
+			 */
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Switch BT TRx Mask since BT RF REG 0x3C != 0x01\n");
+			btcoexist->btc_set_bt_reg(btcoexist, BTC_BT_REG_RF,
+						  0x3c, 0x01);
+		}
 
 		/* Here we need to resend some wifi info to BT
 		 * because bt is reset and loss of the info
@@ -4071,70 +4093,121 @@ void ex_btc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 
 		}
 
-		if ((coex_sta->bt_info_ext & BIT3)) {
-			btc8821a2ant_ignore_wlan_act(btcoexist,
-						     FORCE_EXEC, false);
-		} else {
-			/* BT already NOT ignore Wlan active, do nothing here.*/
+		if (!btcoexist->manual_control && !wifi_under_5g) {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT ext info = 0x%x!!\n",
+				    coex_sta->bt_info_ext);
+			if ((coex_sta->bt_info_ext & BIT(3))) {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT ext info bit3=1, wifi_connected=%d\n",
+					 wifi_connected);
+				if (wifi_connected) {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT ext info bit3 check, set BT NOT to ignore Wlan active!!\n");
+					btc8821a2ant_ignore_wlan_act(btcoexist,
+								     FORCE_EXEC,
+								     false);
+				}
+			} else {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT ext info bit3=0, wifi_connected=%d\n",
+					 wifi_connected);
+				/* BT already NOT ignore Wlan active, do nothing
+				 * here.
+				 */
+				if (!wifi_connected) {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						"[BTCoex], BT ext info bit3 check, set BT to ignore Wlan active!!\n");
+					btc8821a2ant_ignore_wlan_act(
+						btcoexist, FORCE_EXEC, true);
+				}
+			}
 		}
 	}
 
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	/* check BIT2 first ==> check if bt is under inquiry or page scan*/
 	if (bt_info & BT_INFO_8821A_2ANT_B_INQ_PAGE) {
 		coex_sta->c2h_bt_inquiry_page = true;
-		coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_NON_IDLE;
 	} else {
 		coex_sta->c2h_bt_inquiry_page = false;
-		if (bt_info == 0x1) {
-			/* connection exists but not busy*/
-			coex_sta->bt_link_exist = true;
-			coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_CON_IDLE;
-		} else if (bt_info & BT_INFO_8821A_2ANT_B_CONNECTION) {
-			/* connection exists and some link is busy*/
-			coex_sta->bt_link_exist = true;
-			if (bt_info & BT_INFO_8821A_2ANT_B_FTP)
-				coex_sta->pan_exist = true;
-			else
-				coex_sta->pan_exist = false;
-			if (bt_info & BT_INFO_8821A_2ANT_B_A2DP)
-				coex_sta->a2dp_exist = true;
-			else
-				coex_sta->a2dp_exist = false;
-			if (bt_info & BT_INFO_8821A_2ANT_B_HID)
-				coex_sta->hid_exist = true;
-			else
-				coex_sta->hid_exist = false;
-			if (bt_info & BT_INFO_8821A_2ANT_B_SCO_ESCO)
-				coex_sta->sco_exist = true;
-			else
-				coex_sta->sco_exist = false;
-			coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_NON_IDLE;
-		} else {
-			coex_sta->bt_link_exist = false;
+	}
+	/* set link exist status */
+	if (!(bt_info & BT_INFO_8821A_2ANT_B_CONNECTION)) {
+		coex_sta->bt_link_exist = false;
+		coex_sta->pan_exist = false;
+		coex_sta->a2dp_exist = false;
+		coex_sta->hid_exist = false;
+		coex_sta->sco_exist = false;
+	} else { /* connection exists */
+		coex_sta->bt_link_exist = true;
+		if (bt_info & BT_INFO_8821A_2ANT_B_FTP)
+			coex_sta->pan_exist = true;
+		else
 			coex_sta->pan_exist = false;
+		if (bt_info & BT_INFO_8821A_2ANT_B_A2DP)
+			coex_sta->a2dp_exist = true;
+		else
 			coex_sta->a2dp_exist = false;
+		if (bt_info & BT_INFO_8821A_2ANT_B_HID)
+			coex_sta->hid_exist = true;
+		else
 			coex_sta->hid_exist = false;
+		if (bt_info & BT_INFO_8821A_2ANT_B_SCO_ESCO)
+			coex_sta->sco_exist = true;
+		else
 			coex_sta->sco_exist = false;
-			coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_IDLE;
+
+		if ((!coex_sta->hid_exist) &&
+		    (!coex_sta->c2h_bt_inquiry_page) &&
+		    (!coex_sta->sco_exist)) {
+			if (coex_sta->high_priority_tx +
+				    coex_sta->high_priority_rx >= 160)
+				coex_sta->hid_exist = true;
 		}
+	}
+
+	btc8821a2ant_update_bt_link_info(btcoexist);
 
-		btc8821a2ant_update_bt_link_info(btcoexist);
+	if (!(bt_info & BT_INFO_8821A_2ANT_B_CONNECTION)) {
+		coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_IDLE;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT Non-Connected idle!!!\n");
+	} else if (bt_info == BT_INFO_8821A_2ANT_B_CONNECTION) {
+		/* connection exists but no busy */
+		coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_CON_IDLE;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT Connected-idle!!!\n");
+	} else if ((bt_info & BT_INFO_8821A_2ANT_B_SCO_ESCO) ||
+		   (bt_info & BT_INFO_8821A_2ANT_B_SCO_BUSY)) {
+		coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_SCO_BUSY;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT SCO busy!!!\n");
+	} else if (bt_info & BT_INFO_8821A_2ANT_B_ACL_BUSY) {
+		coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_ACL_BUSY;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT ACL busy!!!\n");
+	} else {
+		coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_MAX;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT Non-Defined state!!!\n");
 	}
 
-	if (BT_8821A_2ANT_BT_STATUS_NON_IDLE == coex_dm->bt_status)
+	if ((coex_dm->bt_status == BT_8821A_2ANT_BT_STATUS_ACL_BUSY) ||
+	    (coex_dm->bt_status == BT_8821A_2ANT_BT_STATUS_SCO_BUSY) ||
+	    (coex_dm->bt_status == BT_8821A_2ANT_BT_STATUS_ACL_SCO_BUSY)) {
 		bt_busy = true;
-	else
+		limited_dig = true;
+	} else {
 		bt_busy = false;
+		limited_dig = false;
+	}
+
 	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TRAFFIC_BUSY, &bt_busy);
 
-	if (BT_8821A_2ANT_BT_STATUS_IDLE != coex_dm->bt_status)
-		limited_dig = true;
-	else
-		limited_dig = false;
 	coex_dm->limited_dig = limited_dig;
-	btcoexist->btc_set(btcoexist,
-		BTC_SET_BL_BT_LIMITED_DIG, &limited_dig);
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_LIMITED_DIG, &limited_dig);
 
 	btc8821a2ant_run_coexist_mechanism(btcoexist);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index 535ca10e910b..d268f424249f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -54,6 +54,9 @@ enum _BT_8821A_2ANT_BT_STATUS {
 	BT_8821A_2ANT_BT_STATUS_IDLE		= 0x0,
 	BT_8821A_2ANT_BT_STATUS_CON_IDLE	= 0x1,
 	BT_8821A_2ANT_BT_STATUS_NON_IDLE	= 0x2,
+	BT_8821A_2ANT_BT_STATUS_ACL_BUSY	= 0x3,
+	BT_8821A_2ANT_BT_STATUS_SCO_BUSY	= 0x4,
+	BT_8821A_2ANT_BT_STATUS_ACL_SCO_BUSY	= 0x5,
 	BT_8821A_2ANT_BT_STATUS_MAX
 };
 
@@ -143,6 +146,7 @@ struct coex_sta_8821a_2ant {
 	u32	low_priority_tx;
 	u32	low_priority_rx;
 	u8	bt_rssi;
+	bool	bt_tx_rx_mask;
 	u8	pre_bt_rssi_state;
 	u8	pre_wifi_rssi_state[4];
 	bool	c2h_bt_info_req_sent;
-- 
2.12.0
