Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34825 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932433AbdDQALc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:32 -0400
Received: by mail-oi0-f67.google.com with SMTP id a21so8760632oic.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:31 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 16/27] rtlwifi: btcoex: 23b 1ant: fine tune connect notify
Date: Sun, 16 Apr 2017 19:11:00 -0500
Message-Id: <20170417001111.29384-17-Larry.Finger@lwfinger.net> (sfid-20170417_021142_346857_2D45D21F)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

When association starts, force antenna setup for no scan result issue.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c         | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index e37fd63c5ebe..e91d8ef58231 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2711,13 +2711,28 @@ void ex_halbtc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 	bool wifi_connected = false, bt_hs_on = false;
 	u32 wifi_link_status = 0;
 	u32 num_of_wifi_link = 0;
-	bool bt_ctrl_agg_buf_size = false;
+	bool bt_ctrl_agg_buf_size = false, under_4way = false;
 	u8 agg_buf_size = 5;
 
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
+			   &under_4way);
+
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
 	    coex_sta->bt_disabled)
 		return;
 
+	if (type == BTC_ASSOCIATE_START) {
+		/* Force antenna setup for no scan result issue */
+		halbtc8723b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
+		halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
+					     FORCE_EXEC, false, false);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CONNECT START notify\n");
+	} else {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CONNECT FINISH notify\n");
+	}
+
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
 			   &wifi_link_status);
 	num_of_wifi_link = wifi_link_status>>16;
-- 
2.12.0
