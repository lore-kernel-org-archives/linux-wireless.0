Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:32991 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbdEEQR0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 12:17:26 -0400
Received: by mail-io0-f195.google.com with SMTP id l196so2457741ioe.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 May 2017 09:17:26 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 06/10] rtlwifi: btcoex: 21a 2ant: run mechanism if status changes or auto adjust is set
Date: Fri,  5 May 2017 11:17:08 -0500
Message-Id: <20170505161712.8685-7-Larry.Finger@lwfinger.net> (sfid-20170505_181916_091364_3D8285B9)
In-Reply-To: <20170505161712.8685-1-Larry.Finger@lwfinger.net>
References: <20170505161712.8685-1-Larry.Finger@lwfinger.net>
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
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c  | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index ca7649dca352..56972d36fe84 100644
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
 
+#ifdef BT_AUTO_REPORT_ONLY_8821A_2ANT
 	btc8821a2ant_query_bt_info(btcoexist);
+#else
 	btc8821a2ant_monitor_bt_ctr(btcoexist);
 	btc8821a2ant_monitor_wifi_ctr(btcoexist);
+
+	if (btc8821a2ant_is_wifi_status_changed(btcoexist) ||
+	    coex_dm->auto_tdma_adjust)
+		btc8821a2ant_run_coexist_mechanism(btcoexist);
+#endif
 }
-- 
2.12.2
