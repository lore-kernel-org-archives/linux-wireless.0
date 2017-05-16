Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34941 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752575AbdEPNUE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 09:20:04 -0400
Received: by mail-oi0-f68.google.com with SMTP id m17so3304013oik.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 06:20:04 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 03/10] rtlwifi: btcoex: 21a 1ant: add bt_tx_rx_mask into bt info
Date: Tue, 16 May 2017 08:19:50 -0500
Message-Id: <20170516131957.9513-4-Larry.Finger@lwfinger.net> (sfid-20170516_152015_573119_45774493)
In-Reply-To: <20170516131957.9513-1-Larry.Finger@lwfinger.net>
References: <20170516131957.9513-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Set rf register if the tx rx mask is switched.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c   | 14 ++++++++++++++
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h   |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 93644bedaa0f..4efac5fe9982 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2848,6 +2848,20 @@ void ex_btc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 
 		coex_sta->bt_info_ext = coex_sta->bt_info_c2h[rsp_source][4];
 
+		coex_sta->bt_tx_rx_mask =
+			(coex_sta->bt_info_c2h[rsp_source][2] & 0x40);
+		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TX_RX_MASK,
+				   &coex_sta->bt_tx_rx_mask);
+		if (!coex_sta->bt_tx_rx_mask) {
+			/* BT into is responded by BT FW and BT RF REG 0x3C !=
+			 * 0x15 => Need to switch BT TRx Mask
+			 */
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Switch BT TRx Mask since BT RF REG 0x3C != 0x15\n");
+			btcoexist->btc_set_bt_reg(btcoexist, BTC_BT_REG_RF,
+						  0x3c, 0x15);
+		}
+
 		/* Here we need to resend some wifi info to BT
 		 * because bt is reset and lost the info
 		 */
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
index 1eba3b0d32ae..cb32e7a64ae6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
@@ -154,6 +154,7 @@ struct coex_sta_8821a_1ant {
 	u32	low_priority_tx;
 	u32	low_priority_rx;
 	u8	bt_rssi;
+	bool	bt_tx_rx_mask;
 	u8	pre_bt_rssi_state;
 	u8	pre_wifi_rssi_state[4];
 	bool	c2h_bt_info_req_sent;
-- 
2.12.0
