Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35765 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757038AbdDQAHS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:07:18 -0400
Received: by mail-oi0-f68.google.com with SMTP id a21so8751790oic.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:07:18 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 13/13] rtlwifi: btcoex: 21a 1ant: add bt_tx_rx_mask into bt info
Date: Sun, 16 Apr 2017 19:07:00 -0500
Message-Id: <20170417000700.29057-14-Larry.Finger@lwfinger.net> (sfid-20170417_020749_351691_EC296E77)
In-Reply-To: <20170417000700.29057-1-Larry.Finger@lwfinger.net>
References: <20170417000700.29057-1-Larry.Finger@lwfinger.net>
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
index 8022779004fb..bf9c66d571a0 100644
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
index 8d6ee81586fd..06ca55d5e647 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
@@ -156,6 +156,7 @@ struct coex_sta_8821a_1ant {
 	u32	low_priority_tx;
 	u32	low_priority_rx;
 	u8	bt_rssi;
+	bool	bt_tx_rx_mask;
 	u8	pre_bt_rssi_state;
 	u8	pre_wifi_rssi_state[4];
 	bool	c2h_bt_info_req_sent;
-- 
2.12.0
