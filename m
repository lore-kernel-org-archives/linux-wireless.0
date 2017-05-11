Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35165 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756572AbdEKXY7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 19:24:59 -0400
Received: by mail-oi0-f68.google.com with SMTP id m17so6445042oik.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 16:24:59 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 02/10] rtlwifi: btcoex: 21a 1ant: more bt profiling when wifi receives special packet
Date: Thu, 11 May 2017 18:24:30 -0500
Message-Id: <20170511232438.23159-3-Larry.Finger@lwfinger.net> (sfid-20170512_012503_645502_64F29CE8)
In-Reply-To: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
References: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Consider bt profiling is sco or hid to set coex table and tdma.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 31 ++++++++++------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 087e3ffff2f0..55cde3d85abd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1753,29 +1753,26 @@ void btc8821a1ant_action_wifi_connected_scan(struct btc_coexist *btcoexist)
 static void btc8821a1ant_act_wifi_conn_sp_pkt(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	bool hs_connecting = false;
-
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_CONNECTING, &hs_connecting);
 
 	btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
 				      0x0, 0x0);
 
 	/* tdma and coex table */
-	if (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_BUSY) {
-		if (bt_link_info->a2dp_exist && bt_link_info->pan_exist) {
-			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 22);
-			btc8821a1ant_coex_table_with_type(btcoexist,
-							  NORMAL_EXEC, 1);
-		} else {
-			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 20);
-			btc8821a1ant_coex_table_with_type(btcoexist,
-							  NORMAL_EXEC, 1);
-		}
-	} else {
-		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+	if ((bt_link_info->sco_exist) || (bt_link_info->hid_exist) ||
+	    (bt_link_info->a2dp_exist)) {
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
+	}
+
+	if ((bt_link_info->hid_exist) && (bt_link_info->a2dp_exist)) {
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
 		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+	} else if (bt_link_info->pan_exist) {
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
+	} else {
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 	}
 }
 
-- 
2.12.2
