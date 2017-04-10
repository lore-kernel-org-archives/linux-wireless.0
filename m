Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35300 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752765AbdDJQX0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:26 -0400
Received: by mail-oi0-f67.google.com with SMTP id g204so13131976oib.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:26 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 12/14] rtlwifi: btcoex: 21a 1ant: monitor bt profiling when scan
Date: Mon, 10 Apr 2017 11:23:08 -0500
Message-Id: <20170410162310.7515-13-Larry.Finger@lwfinger.net> (sfid-20170410_182349_230763_79137F4E)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When wifi is scanning and not connected, set the tdma and coex table
properly to control the priority of the packets to make the wifi bt
coexistence operate smoothly

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 29 ++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 6b08051614eb..eab04c2bdd3d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1481,9 +1481,34 @@ static void btc8821a1ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 static
 void btc8821a1ant_action_wifi_multi_port(struct btc_coexist *btcoexist)
 {
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+
 	btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
-	btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
-	btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+	/* tdma and coex table */
+	if (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_BUSY) {
+		if (bt_link_info->a2dp_exist) {
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 1);
+		} else if (bt_link_info->a2dp_exist &&
+			   bt_link_info->pan_exist) {
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 4);
+		} else {
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 4);
+		}
+	} else if ((coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_SCO_BUSY) ||
+		   (BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY ==
+		    coex_dm->bt_status)) {
+		btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
+				BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SCAN);
+	} else {
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+	}
 }
 
 static
-- 
2.12.0
