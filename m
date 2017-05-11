Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36575 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756715AbdEKXZA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 19:25:00 -0400
Received: by mail-oi0-f68.google.com with SMTP id w138so6428771oiw.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 16:25:00 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 03/10] rtlwifi: btcoex: 21a 1ant: shorten wifi slot when connected scan
Date: Thu, 11 May 2017 18:24:31 -0500
Message-Id: <20170511232438.23159-4-Larry.Finger@lwfinger.net> (sfid-20170512_012530_756804_729E2507)
In-Reply-To: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
References: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

If the wifi is scanning when connected, it is better if the slot
is shortened and the priority is increased. Otherwise bt a2dp may have
low quality.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 55cde3d85abd..13d8ac23b17a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1730,23 +1730,23 @@ void btc8821a1ant_action_wifi_connected_scan(struct btc_coexist *btcoexist)
 
 	/* tdma and coex table */
 	if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
-		if (bt_link_info->a2dp_exist && bt_link_info->pan_exist) {
-			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+		if (bt_link_info->a2dp_exist) {
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
 			btc8821a1ant_coex_table_with_type(btcoexist,
 							  NORMAL_EXEC, 1);
 		} else {
-		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
-		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
-	}
-	} else if ((BT_8821A_1ANT_BT_STATUS_SCO_BUSY ==
-		    coex_dm->bt_status) ||
-		   (BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY ==
-		    coex_dm->bt_status)) {
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 4);
+		}
+	} else if ((coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_SCO_BUSY) ||
+		   (coex_dm->bt_status ==
+		    BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY)) {
 		btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
 			BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SCAN);
 	} else {
-		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
-		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 	}
 }
 
-- 
2.12.2
