Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33349 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755421AbdDMSHa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:30 -0400
Received: by mail-oi0-f66.google.com with SMTP id t63so13604091oih.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:29 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 15/19] rtlwifi: btcoex: 21a 2ant: slot time fine tune
Date: Thu, 13 Apr 2017 13:07:06 -0500
Message-Id: <20170413180710.19953-16-Larry.Finger@lwfinger.net> (sfid-20170413_202544_737412_DFF6D5B8)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Tune the wifi/bt slot time to get better performance.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 52 +++++++++++-----------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 6faa53ee821d..5991a2cd8678 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -1168,12 +1168,12 @@ static void btc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 		switch (type) {
 		case 1:
 		default:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x3c,
+						    0x03, 0xf1, 0x90);
 			break;
 		case 2:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
-						    0x12, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x2d,
+						    0x03, 0xf1, 0x90);
 			break;
 		case 3:
 			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
@@ -1184,12 +1184,12 @@ static void btc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 						    0x03, 0xf1, 0x90);
 			break;
 		case 5:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x3c,
+						    0x3, 0x70, 0x90);
 			break;
 		case 6:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
-						    0x12, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x2d,
+						    0x3, 0x70, 0x90);
 			break;
 		case 7:
 			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
@@ -1200,44 +1200,44 @@ static void btc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 						    0x3, 0x70, 0x90);
 			break;
 		case 9:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x3c,
+						    0x03, 0xf1, 0x90);
 			break;
 		case 10:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
-						    0x12, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x2d,
+						    0x03, 0xf1, 0x90);
 			break;
 		case 11:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0xa,
-						    0xa, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
+						    0x3, 0xf1, 0x90);
 			break;
 		case 12:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x5,
-						    0x5, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x10,
+						    0x3, 0xf1, 0x90);
 			break;
 		case 13:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x3c,
+						    0x3, 0x70, 0x90);
 			break;
 		case 14:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3,
-						    0x12, 0x12, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x2d,
+						    0x3, 0x70, 0x90);
 			break;
 		case 15:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0xa,
-						    0xa, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
+						    0x3, 0x70, 0x90);
 			break;
 		case 16:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x5,
-						    0x5, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x10,
+						    0x3, 0x70, 0x90);
 			break;
 		case 17:
 			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xa3, 0x2f,
 						    0x2f, 0x60, 0x90);
 			break;
 		case 18:
-			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x5,
-						    0x5, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x5, 0x5,
+						    0xe1, 0x90);
 			break;
 		case 19:
 			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x25,
-- 
2.12.0
