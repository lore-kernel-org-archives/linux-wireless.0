Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35186 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756729AbdEKXZD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 19:25:03 -0400
Received: by mail-oi0-f66.google.com with SMTP id m17so6445195oik.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 16:25:03 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 06/10] rtlwifi: btcoex: 21a 1ant: wifi slot time adjustment
Date: Thu, 11 May 2017 18:24:34 -0500
Message-Id: <20170511232438.23159-7-Larry.Finger@lwfinger.net> (sfid-20170512_012529_833359_556EF2F3)
In-Reply-To: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
References: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Adjust wifi slot time to tune the performance of coexistence

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 38 ++++++++++++++++------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 6a434334a418..834cf08103b2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1107,8 +1107,8 @@ static void btc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 						    0x3, 0x11, 0x10);
 			break;
 		case 6:
-			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x13, 0xa,
-						    0x3, 0x0, 0x0);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x61, 0x20,
+						    0x3, 0x11, 0x13);
 			break;
 		case 7:
 			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x13, 0xc,
@@ -1128,8 +1128,8 @@ static void btc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 						    0xa, 0x0, 0x40);
 			break;
 		case 11:
-			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x14,
-						    0x03, 0x10, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x15,
+						    0x03, 0x10, 0x50);
 			rssi_adjust_val = 20;
 			break;
 		case 12:
@@ -1137,8 +1137,8 @@ static void btc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 						    0x0a, 0x0, 0x50);
 			break;
 		case 13:
-			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x18,
-						    0x18, 0x0, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x12,
+						    0x12, 0x0, 0x50);
 			break;
 		case 14:
 			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x1e,
@@ -1163,8 +1163,8 @@ static void btc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 						    0x03, 0x11, 0x10);
 			break;
 		case 21:
-			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x61, 0x15,
-						    0x03, 0x11, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x61, 0x25,
+						    0x03, 0x11, 0x11);
 			break;
 		case 22:
 			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x61, 0x25,
@@ -1204,8 +1204,8 @@ static void btc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 						    0x1a, 0x1, 0x10);
 			break;
 		case 30:
-			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x14,
-						    0x3, 0x10, 0x50);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x30,
+						    0x3, 0x10, 0x10);
 			break;
 		case 31:
 			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x1a,
@@ -1231,6 +1231,24 @@ static void btc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x12,
 						    0x3, 0x14, 0x50);
 			break;
+		case 40:
+			/* SoftAP only with no sta associated, BT disable, TDMA
+			 * mode for power saving
+			 *
+			 * here softap mode screen off will cost 70-80mA for
+			 * phone
+			 */
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x23, 0x18,
+						    0x00, 0x10, 0x24);
+			break;
+		case 41:
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x15,
+						    0x3, 0x11, 0x11);
+			break;
+		case 42:
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x20,
+						    0x3, 0x11, 0x11);
+			break;
 		case 43:
 			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x30,
 						    0x3, 0x10, 0x11);
-- 
2.12.2
