Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36384 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754981AbdDOUcT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:19 -0400
Received: by mail-oi0-f65.google.com with SMTP id b187so22211095oif.3
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:19 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>
Subject: [PATCH 14/14] rtlwifi: btcoex: 21a 2ant: wifi is linking action
Date: Sat, 15 Apr 2017 15:32:00 -0500
Message-Id: <20170415203200.22979-15-Larry.Finger@lwfinger.net> (sfid-20170415_223237_659936_E044A665)
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When wifi is under scanning/linking/roaming, do not run the reset of the
coex mechanism because these activities are important for wifi, just run
the linking process and return.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 0aa36247e402..841b4a83ab70 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3467,6 +3467,7 @@ static void btc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	u32 num_of_wifi_link = 0;
 	u32 wifi_link_status = 0;
 	bool miracast_plus_bt = false;
+	bool scan = false, link = false, roam = false;
 
 	if (btcoexist->manual_control) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -3498,6 +3499,17 @@ static void btc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		return;
 	}
 
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
+
+	if (scan || link || roam) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], WiFi is under Link Process !!\n");
+		btc8821a2ant_action_wifi_link_process(btcoexist);
+		return;
+	}
+
 	/* for P2P */
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
 			   &wifi_link_status);
-- 
2.12.0
