Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34749 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753188AbdDJQXc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:32 -0400
Received: by mail-oi0-f68.google.com with SMTP id o83so459810oik.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:27 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 08/14] rtlwifi: btcoex: 21a 1ant: action when associating/authenticating
Date: Mon, 10 Apr 2017 11:23:04 -0500
Message-Id: <20170410162310.7515-9-Larry.Finger@lwfinger.net> (sfid-20170410_182341_926463_1B67A9CF)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When wifi is associating or authenticating, set the coex table for wifi
to establish link. These packets should have higher priority.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 33 ++++++++++++++++++++--
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index cadc0f91af41..05e33d38d49c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1486,6 +1486,28 @@ void btc8821a1ant_action_wifi_multi_port(struct btc_coexist *btcoexist)
 	btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 }
 
+static
+void btc8821a1ant_action_wifi_not_connected_asso_auth(
+					struct btc_coexist *btcoexist)
+{
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+
+	btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+				      0x0);
+
+	/* tdma and coex table */
+	if ((bt_link_info->sco_exist) || (bt_link_info->hid_exist)) {
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+	} else if ((bt_link_info->a2dp_exist) || (bt_link_info->pan_exist)) {
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
+	} else {
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+	}
+}
+
 
 static void btc8821a1ant_action_hs(struct btc_coexist *btcoexist)
 {
@@ -1941,10 +1963,15 @@ static void btc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
 
-		if (scan || link || roam)
-			btc8821a1ant_act_wifi_not_conn_scan(btcoexist);
-		else
+		if (scan || link || roam) {
+			if (scan)
+				btc8821a1ant_act_wifi_not_conn_scan(btcoexist);
+			else
+				btc8821a1ant_action_wifi_not_connected_asso_auth(
+					btcoexist);
+		} else {
 			btc8821a1ant_action_wifi_not_connected(btcoexist);
+		}
 	} else {
 		/* wifi LPS/Busy */
 		btc8821a1ant_action_wifi_connected(btcoexist);
-- 
2.12.0
