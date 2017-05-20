Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33091 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932268AbdETPtS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 May 2017 11:49:18 -0400
Received: by mail-oi0-f67.google.com with SMTP id h4so16702500oib.0
        for <linux-wireless@vger.kernel.org>; Sat, 20 May 2017 08:49:17 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 06/10] rtlwifi: btcoex: 23b 1ant: coex table fine tune
Date: Sat, 20 May 2017 10:49:03 -0500
Message-Id: <20170520154907.15590-7-Larry.Finger@lwfinger.net> (sfid-20170520_174928_747866_B1CF9AD9)
In-Reply-To: <20170520154907.15590-1-Larry.Finger@lwfinger.net>
References: <20170520154907.15590-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Set register settings for coex table fine tune.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 56 +++++++++++++++++++---
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 80d577cd6549..9c4feb89144d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -587,24 +587,68 @@ static void halbtc8723b1ant_coex_table_with_type(struct btc_coexist *btcoexist,
 		break;
 	case 3:
 		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x55555555,
-					   0xaaaaaaaa, 0xffffff, 0x3);
+					   0x5a5a5a5a, 0xffffff, 0x3);
 		break;
 	case 4:
-		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x55555555,
-					   0x5aaa5aaa, 0xffffff, 0x3);
+		if ((coex_sta->cck_ever_lock) && (coex_sta->scan_ap_num <= 5))
+			halbtc8723b1ant_coex_table(btcoexist, force_exec,
+						   0x55555555, 0xaaaa5a5a,
+						   0xffffff, 0x3);
+		else
+			halbtc8723b1ant_coex_table(btcoexist, force_exec,
+						   0x55555555, 0x5a5a5a5a,
+						   0xffffff, 0x3);
 		break;
 	case 5:
-		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x5a5a5a5a,
-					   0xaaaa5a5a, 0xffffff, 0x3);
+		if ((coex_sta->cck_ever_lock) && (coex_sta->scan_ap_num <= 5))
+			halbtc8723b1ant_coex_table(btcoexist, force_exec,
+						   0x5a5a5a5a, 0x5aaa5a5a,
+						   0xffffff, 0x3);
+		else
+			halbtc8723b1ant_coex_table(btcoexist, force_exec,
+						   0x5a5a5a5a, 0x5aaa5a5a,
+						   0xffffff, 0x3);
 		break;
 	case 6:
 		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x55555555,
-					   0xaaaa5a5a, 0xffffff, 0x3);
+					   0xaaaaaaaa, 0xffffff, 0x3);
 		break;
 	case 7:
 		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0xaaaaaaaa,
 					   0xaaaaaaaa, 0xffffff, 0x3);
 		break;
+	case 8:
+		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 9:
+		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 10:
+		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 11:
+		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 12:
+		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 13:
+		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
+					   0xaaaaaaaa, 0xffffff, 0x3);
+		break;
+	case 14:
+		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 15:
+		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0xaaaaaaaa, 0xffffff, 0x3);
+		break;
 	default:
 		break;
 	}
-- 
2.12.0
