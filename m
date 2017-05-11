Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35437 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934314AbdEKTBc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 15:01:32 -0400
Received: by mail-oi0-f66.google.com with SMTP id m17so5519976oik.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 12:01:32 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v3 06/10] rtlwifi: btcoex: 21a 2ant: run mechanism if status changes or auto adjust is set
Date: Thu, 11 May 2017 14:01:15 -0500
Message-Id: <20170511190119.23426-7-Larry.Finger@lwfinger.net> (sfid-20170511_210153_998492_00F381E6)
In-Reply-To: <20170511190119.23426-1-Larry.Finger@lwfinger.net>
References: <20170511190119.23426-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

The driver will periodically ask the coex, and the coex only runs the
mechanism when the status was changed or the auto adjust is set.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - resubmit after removal of BT_AUTO_REPORT_XXXX symbols.
v3 - remove one additional usage of BT_AUTO_REPORT_XXXX
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c         | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index ca7649dca352..0d97e214ee10 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3485,14 +3485,14 @@ static void btc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	if (btc8821a2ant_is_common_action(btcoexist)) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Action 2-Ant common\n");
-		coex_dm->reset_tdma_adjust = true;
+		coex_dm->auto_tdma_adjust = true;
 	} else {
 		if (coex_dm->cur_algorithm != coex_dm->pre_algorithm) {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], pre_algorithm = %d, cur_algorithm = %d\n",
 				    coex_dm->pre_algorithm,
 				    coex_dm->cur_algorithm);
-			coex_dm->reset_tdma_adjust = true;
+			coex_dm->auto_tdma_adjust = false;
 		}
 		switch (coex_dm->cur_algorithm) {
 		case BT_8821A_2ANT_COEX_ALGO_SCO:
@@ -4200,7 +4200,14 @@ void ex_btc8821a2ant_periodical(struct btc_coexist *btcoexist)
 			 "[BTCoex], ****************************************************************\n");
 	}
 
-	btc8821a2ant_query_bt_info(btcoexist);
-	btc8821a2ant_monitor_bt_ctr(btcoexist);
-	btc8821a2ant_monitor_wifi_ctr(btcoexist);
+	if (btcoexist->auto_report_2ant) {
+		btc8821a2ant_query_bt_info(btcoexist);
+	} else {
+		btc8821a2ant_monitor_bt_ctr(btcoexist);
+		btc8821a2ant_monitor_wifi_ctr(btcoexist);
+
+		if (btc8821a2ant_is_wifi_status_changed(btcoexist) ||
+		    coex_dm->auto_tdma_adjust)
+			btc8821a2ant_run_coexist_mechanism(btcoexist);
+	}
 }
-- 
2.12.0
