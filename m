Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35236 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdDJQXS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:18 -0400
Received: by mail-oi0-f65.google.com with SMTP id g204so13131273oib.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:18 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 03/14] rtlwifi: btcoex: 21a 1ant: coex table setting for new fw
Date: Mon, 10 Apr 2017 11:22:59 -0500
Message-Id: <20170410162310.7515-4-Larry.Finger@lwfinger.net> (sfid-20170410_182325_318795_3D80D74A)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For newer fw, the coex table setting needs to be modified to operate
correctly.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c        | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 65c455bfd8fb..3a117eaf1b21 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -806,24 +806,24 @@ static void btc8821a1ant_coex_table_with_type(struct btc_coexist *btcoexist,
 					0x5a5a5a5a, 0xffffff, 0x3);
 		break;
 	case 3:
-		btc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0x5a5a5a5a,
 					0xaaaaaaaa, 0xffffff, 0x3);
 		break;
 	case 4:
-		btc8821a1ant_coex_table(btcoexist, force_exec, 0xffffffff,
-					0xffffffff, 0xffffff, 0x3);
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					0x5a5a5a5a, 0xffffff, 0x3);
 		break;
 	case 5:
-		btc8821a1ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
-					0x5fff5fff, 0xffffff, 0x3);
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0x5a5a5a5a,
+					0xaaaa5a5a, 0xffffff, 0x3);
 		break;
 	case 6:
-		btc8821a1ant_coex_table(btcoexist, force_exec, 0x55ff55ff,
-					0x5a5a5a5a, 0xffffff, 0x3);
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					0xaaaa5a5a, 0xffffff, 0x3);
 		break;
 	case 7:
-		btc8821a1ant_coex_table(btcoexist, force_exec, 0x5afa5afa,
-					0x5afa5afa, 0xffffff, 0x3);
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0xaaaaaaaa,
+					0xaaaaaaaa, 0xffffff, 0x3);
 		break;
 	default:
 		break;
-- 
2.12.0
