Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36316 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755288AbdDFUUN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 16:20:13 -0400
Received: by mail-oi0-f65.google.com with SMTP id b187so8910467oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 13:20:12 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 10/11] rtlwifi: btcoex: 23b 2ant: notify more bt information
Date: Thu,  6 Apr 2017 15:19:57 -0500
Message-Id: <20170406201958.25642-11-Larry.Finger@lwfinger.net> (sfid-20170406_222543_688392_7CF63299)
In-Reply-To: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
References: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

These bt information are displayed in display coex

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c      | 20 ++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h      |  2 ++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h         | 15 +++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 9092de2d2c7c..1c823a71ce9f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -4145,9 +4145,19 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_sta->bt_retry_cnt =
 			coex_sta->bt_info_c2h[rsp_source][2] & 0xf;
 
+		if (coex_sta->bt_retry_cnt >= 1)
+			coex_sta->pop_event_cnt++;
+
 		coex_sta->bt_rssi =
 			coex_sta->bt_info_c2h[rsp_source][3] * 2 + 10;
 
+		coex_sta->bt_info_ext = coex_sta->bt_info_c2h[rsp_source][4];
+
+		if (coex_sta->bt_info_c2h[rsp_source][2] & 0x20)
+			coex_sta->c2h_bt_remote_name_req = true;
+		else
+			coex_sta->c2h_bt_remote_name_req = false;
+
 		if (coex_sta->bt_info_c2h[rsp_source][1] == 0x49)
 			coex_sta->a2dp_bit_pool =
 				coex_sta->bt_info_c2h[rsp_source][6];
@@ -4222,6 +4232,16 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 			coex_sta->sco_exist = true;
 		else
 			coex_sta->sco_exist = false;
+
+		if ((!coex_sta->hid_exist) &&
+		    (!coex_sta->c2h_bt_inquiry_page) &&
+		    (!coex_sta->sco_exist)) {
+			if (coex_sta->high_priority_tx +
+				    coex_sta->high_priority_rx >= 160) {
+				coex_sta->hid_exist = true;
+				bt_info = bt_info | 0x28;
+			}
+		}
 	}
 
 	btc8723b2ant_update_bt_link_info(btcoexist);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index 9e29f85304cc..18a35c7faba9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -151,12 +151,14 @@ struct coex_sta_8723b_2ant {
 	u32 low_priority_tx;
 	u32 low_priority_rx;
 	u8 bt_rssi;
+	bool bt_tx_rx_mask;
 	u8 pre_bt_rssi_state;
 	u8 pre_wifi_rssi_state[4];
 	bool c2h_bt_info_req_sent;
 	u8 bt_info_c2h[BT_INFO_SRC_8723B_2ANT_MAX][10];
 	u32 bt_info_c2h_cnt[BT_INFO_SRC_8723B_2ANT_MAX];
 	bool c2h_bt_inquiry_page;
+	bool c2h_bt_remote_name_req;
 	u8 bt_retry_cnt;
 	u8 bt_info_ext;
 	u32 pop_event_cnt;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index d31e6df5b1bf..c8271135aaaa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -66,6 +66,15 @@
 #define		BTC_ANT_WIFI_AT_CPL_MAIN		0
 #define		BTC_ANT_WIFI_AT_CPL_AUX			1
 
+enum btc_bt_reg_type {
+	BTC_BT_REG_RF		= 0,
+	BTC_BT_REG_MODEM	= 1,
+	BTC_BT_REG_BLUEWIZE	= 2,
+	BTC_BT_REG_VENDOR	= 3,
+	BTC_BT_REG_LE		= 4,
+	BTC_BT_REG_MAX
+};
+
 enum btc_chip_interface {
 	BTC_INTF_UNKNOWN	= 0,
 	BTC_INTF_PCI		= 1,
@@ -251,6 +260,7 @@ enum btc_set_type {
 	BTC_SET_BL_TO_REJ_AP_AGG_PKT,
 	BTC_SET_BL_BT_CTRL_AGG_SIZE,
 	BTC_SET_BL_INC_SCAN_DEV_NUM,
+	BTC_SET_BL_BT_TX_RX_MASK,
 	BTC_SET_BL_MIRACAST_PLUS_BT,
 
 	/* type u1Byte */
@@ -392,6 +402,9 @@ typedef	bool (*bfp_btc_get)(void *btcoexist, u8 get_type, void *out_buf);
 
 typedef	bool (*bfp_btc_set)(void *btcoexist, u8 set_type, void *in_buf);
 
+typedef void (*bfp_btc_set_bt_reg)(void *btc_context, u8 reg_type, u32 offset,
+				   u32 value);
+
 typedef void (*bfp_btc_disp_dbg_msg)(void *btcoexist, u8 disp_type);
 
 struct btc_bt_info {
@@ -511,6 +524,8 @@ struct btc_coexist {
 
 	bfp_btc_get btc_get;
 	bfp_btc_set btc_set;
+
+	bfp_btc_set_bt_reg btc_set_bt_reg;
 };
 
 bool halbtc_is_wifi_uplink(struct rtl_priv *adapter);
-- 
2.12.0
