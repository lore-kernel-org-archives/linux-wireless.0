Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36834 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755501AbdDMSHg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:36 -0400
Received: by mail-oi0-f65.google.com with SMTP id b187so13576975oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:35 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 16/19] rtlwifi: btcoex: 21a 2ant: tdma cases for low wifi/bt rssi
Date: Thu, 13 Apr 2017 13:07:07 -0500
Message-Id: <20170413180710.19953-17-Larry.Finger@lwfinger.net> (sfid-20170413_202543_810048_778C34BA)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

If the wifi or bt has low rssi, they need extra parameter settings for
the tdma.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 91 +++++++++++++++++++++-
 1 file changed, 89 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 5991a2cd8678..c0537d0268e6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -1145,6 +1145,20 @@ static void btc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
+	u8 wifi_rssi_state, bt_rssi_state;
+
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 1, 2,
+				BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2,
+				BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
+
+	if (!(BTC_RSSI_HIGH(wifi_rssi_state) &&
+	      BTC_RSSI_HIGH(bt_rssi_state)) &&
+	    turn_on) {
+		/* for WiFi RSSI low or BT RSSI low */
+		type = type + 100;
+	}
+
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn %s PS TDMA, type = %d\n",
 		 (force_exec ? "force to" : ""), (turn_on ? "ON" : "OFF"),
@@ -1251,9 +1265,82 @@ static void btc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x15,
 						    0x03, 0x70, 0x90);
 			break;
+		case 23:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1e,
+						    0x03, 0xf0, 0x14);
+			break;
+		case 24:
+		case 124:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x3c,
+						    0x03, 0x70, 0x50);
+			break;
+		case 25:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x14,
+						    0x03, 0xf1, 0x90);
+			break;
+		case 26:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x30,
+						    0x03, 0xf1, 0x90);
+			break;
 		case 71:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x3c,
+						    0x03, 0xf1, 0x90);
+			break;
+		case 101:
+		case 105:
+		case 171:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x3a,
+						    0x03, 0x70, 0x50);
+			break;
+		case 102:
+		case 106:
+		case 110:
+		case 114:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x2d,
+						    0x03, 0x70, 0x50);
+			break;
+		case 103:
+		case 107:
+		case 111:
+		case 115:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x1c,
+						    0x03, 0x70, 0x50);
+			break;
+		case 104:
+		case 108:
+		case 112:
+		case 116:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x10,
+						    0x03, 0x70, 0x50);
+			break;
+		case 109:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x3c,
+						    0x03, 0xf1, 0x90);
+			break;
+		case 113:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x3c,
+						    0x03, 0x70, 0x90);
+			break;
+		case 121:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x15,
+						    0x03, 0x70, 0x90);
+			break;
+		case 22:
+		case 122:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x35,
+						    0x03, 0x71, 0x11);
+			break;
+		case 123:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x1c,
+						    0x03, 0x70, 0x54);
+			break;
+		case 125:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x14,
+						    0x03, 0x70, 0x50);
+			break;
+		case 126:
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x30,
+						    0x03, 0x70, 0x50);
 			break;
 		}
 	} else {
-- 
2.12.0
