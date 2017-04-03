Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32791 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752306AbdDCSl7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 14:41:59 -0400
Received: by mail-oi0-f66.google.com with SMTP id f193so21147336oib.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 11:41:59 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v3 09/12] rtlwifi: btcoex: 23b 2ant: remove redundant bt stack report
Date: Mon,  3 Apr 2017 13:41:39 -0500
Message-Id: <20170403184147.18409-9-Larry.Finger@lwfinger.net> (sfid-20170403_204220_590596_4590EBF5)
In-Reply-To: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
References: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

New ICs have hardware mailbox to deliver bt information instead of doing
it by driver itself, so remove them.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - No changes.
v3 - No changes.
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c        | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 4139ddf6022b..e72baa00b42f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -399,11 +399,9 @@ static bool btc8723b2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
-	/*struct btc_stack_info *stack_info = &btcoexist->stack_info;*/
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 
-#if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 1) /* profile from bt patch */
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
 	bt_link_info->bt_link_exist = coex_sta->bt_link_exist;
@@ -417,21 +415,7 @@ static void btc8723b2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 		bt_link_info->pan_exist = true;
 		bt_link_info->bt_link_exist = true;
 	}
-#else	/* profile from bt stack */
-	bt_link_info->bt_link_exist = stack_info->bt_link_exist;
-	bt_link_info->sco_exist = stack_info->sco_exist;
-	bt_link_info->a2dp_exist = stack_info->a2dp_exist;
-	bt_link_info->pan_exist = stack_info->pan_exist;
-	bt_link_info->hid_exist = stack_info->hid_exist;
-
-	/*for win-8 stack HID report error*/
-	if (!stack_info->hid_exist)
-		stack_info->hid_exist = coex_sta->hid_exist;
-	/*sync  BTInfo with BT firmware and stack*/
-	/* when stack HID report error, here we use the info from bt fw.*/
-	if (!stack_info->bt_link_exist)
-		stack_info->bt_link_exist = coex_sta->bt_link_exist;
-#endif
+
 	/* check if Sco only */
 	if (bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
 	    !bt_link_info->pan_exist && !bt_link_info->hid_exist)
-- 
2.12.0
