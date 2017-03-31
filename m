Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36281 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933548AbdCaQsN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 12:48:13 -0400
Received: by mail-oi0-f68.google.com with SMTP id b187so9912667oif.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Mar 2017 09:48:12 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 08/12] rtlwifi: btcoex: 23b 2ant: coex table fine tune
Date: Fri, 31 Mar 2017 11:47:38 -0500
Message-Id: <20170331164742.22374-9-Larry.Finger@lwfinger.net> (sfid-20170331_184848_496873_F90D62D7)
In-Reply-To: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
References: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

set coex table fine tune, for register settings

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 52 +++++++++++++---------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 65497ab..3bed72e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -915,55 +915,67 @@ static void btc8723b2ant_coex_table_with_type(struct btc_coexist *btcoexist,
 	switch (type) {
 	case 0:
 		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55555555,
-					0x55555555, 0xffff, 0x3);
+					0x55555555, 0xffffff, 0x3);
 		break;
 	case 1:
 		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55555555,
-					0x5afa5afa, 0xffff, 0x3);
+					0x5afa5afa, 0xffffff, 0x3);
 		break;
 	case 2:
-		btc8723b2ant_coex_table(btcoexist, force_exec, 0x5a5a5a5a,
-					0x5a5a5a5a, 0xffff, 0x3);
+		btc8723b2ant_coex_table(btcoexist, force_exec, 0x5ada5ada,
+					0x5ada5ada, 0xffffff, 0x3);
 		break;
 	case 3:
 		btc8723b2ant_coex_table(btcoexist, force_exec, 0xaaaaaaaa,
-					0xaaaaaaaa, 0xffff, 0x3);
+					0xaaaaaaaa, 0xffffff, 0x3);
 		break;
 	case 4:
 		btc8723b2ant_coex_table(btcoexist, force_exec, 0xffffffff,
-					0xffffffff, 0xffff, 0x3);
+					0xffffffff, 0xffffff, 0x3);
 		break;
 	case 5:
 		btc8723b2ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
-					0x5fff5fff, 0xffff, 0x3);
+					0x5fff5fff, 0xffffff, 0x3);
 		break;
 	case 6:
 		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55ff55ff,
-					0x5a5a5a5a, 0xffff, 0x3);
+					0x5a5a5a5a, 0xffffff, 0x3);
 		break;
 	case 7:
-		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55ff55ff,
-					0x5afa5afa, 0xffff, 0x3);
+		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0x5ada5ada, 0xffffff, 0x3);
 		break;
 	case 8:
-		btc8723b2ant_coex_table(btcoexist, force_exec, 0x5aea5aea,
-					0x5aea5aea, 0xffff, 0x3);
+		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0x5ada5ada, 0xffffff, 0x3);
 		break;
 	case 9:
-		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55ff55ff,
-					0x5aea5aea, 0xffff, 0x3);
+		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0x5ada5ada, 0xffffff, 0x3);
 		break;
 	case 10:
-		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55ff55ff,
-					0x5aff5aff, 0xffff, 0x3);
+		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0x5ada5ada, 0xffffff, 0x3);
 		break;
 	case 11:
-		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55ff55ff,
-					0x5a5f5a5f, 0xffff, 0x3);
+		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0x5ada5ada, 0xffffff, 0x3);
 		break;
 	case 12:
-		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55ff55ff,
-					0x5f5f5f5f, 0xffff, 0x3);
+		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 13:
+		btc8723b2ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
+					0xaaaaaaaa, 0xffffff, 0x3);
+		break;
+	case 14:
+		btc8723b2ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
+					0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 15:
+		btc8723b2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0xaaaaaaaa, 0xffffff, 0x3);
 		break;
 	default:
 		break;
-- 
2.10.2
