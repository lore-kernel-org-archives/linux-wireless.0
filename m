Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36443 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S970096AbdEYRs0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 13:48:26 -0400
Received: by mail-oi0-f66.google.com with SMTP id w138so38629309oiw.3
        for <linux-wireless@vger.kernel.org>; Thu, 25 May 2017 10:48:26 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 7/7] rtlwifi: btcoex: Fix another edit mistake in 21a 1ant
Date: Thu, 25 May 2017 12:48:14 -0500
Message-Id: <20170525174814.25005-8-Larry.Finger@lwfinger.net> (sfid-20170525_194903_571359_3877C368)
In-Reply-To: <20170525174814.25005-1-Larry.Finger@lwfinger.net>
References: <20170525174814.25005-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In routine btc8821a1ant_action_wifi_multi_port(), an edit that removed
several lines was missed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 27 ----------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 30364966b938..6a1d0dece485 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -44,8 +44,6 @@ static struct coex_dm_8821a_1ant glcoex_dm_8821a_1ant;
 static struct coex_dm_8821a_1ant *coex_dm = &glcoex_dm_8821a_1ant;
 static struct coex_sta_8821a_1ant glcoex_sta_8821a_1ant;
 static struct coex_sta_8821a_1ant *coex_sta = &glcoex_sta_8821a_1ant;
-static void btc8821a1ant_act_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
-						  u8 wifi_status);
 
 static const char *const glbt_info_src_8821a_1ant[] = {
 	  "BT Info[wifi fw]",
@@ -1472,35 +1470,10 @@ static void btc8821a1ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 static
 void btc8821a1ant_action_wifi_multi_port(struct btc_coexist *btcoexist)
 {
-	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-
 	btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
-	/* tdma and coex table */
-	if (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_BUSY) {
-		if (bt_link_info->a2dp_exist) {
-			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
-			btc8821a1ant_coex_table_with_type(btcoexist,
-							  NORMAL_EXEC, 1);
-		} else if (bt_link_info->a2dp_exist &&
-			   bt_link_info->pan_exist) {
-			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
-			btc8821a1ant_coex_table_with_type(btcoexist,
-							  NORMAL_EXEC, 4);
-		} else {
-			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
-			btc8821a1ant_coex_table_with_type(btcoexist,
-							  NORMAL_EXEC, 4);
-		}
-	} else if ((coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_SCO_BUSY) ||
-		   (BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY ==
-		    coex_dm->bt_status)) {
-		btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
-				BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SCAN);
-	} else {
 		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
 		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 	}
-}
 
 static
 void btc8821a1ant_action_wifi_not_connected_asso_auth(
-- 
2.12.0
