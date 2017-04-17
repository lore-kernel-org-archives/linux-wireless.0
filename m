Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34266 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932328AbdDQALd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:33 -0400
Received: by mail-oi0-f65.google.com with SMTP id t14so15969373oif.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:32 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 17/27] rtlwifi: btcoex: 23b 1ant: Revise media status notify to fix no scan result issue
Date: Sun, 16 Apr 2017 19:11:01 -0500
Message-Id: <20170417001111.29384-18-Larry.Finger@lwfinger.net> (sfid-20170417_021216_855664_E7FC477B)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Force antenna setup for no scan result issue

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 39 ++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index e91d8ef58231..dddc19054e37 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2778,18 +2778,53 @@ void ex_halbtc8723b1ant_media_status_notify(struct btc_coexist *btcoexist,
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_central_chnl;
+	bool wifi_under_b_mode = false;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
 	    coex_sta->bt_disabled)
 		return;
 
-	if (BTC_MEDIA_CONNECT == type)
+	if (type == BTC_MEDIA_CONNECT) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], MEDIA connect notify\n");
-	else
+		/* Force antenna setup for no scan result issue */
+		halbtc8723b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
+		halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
+					     FORCE_EXEC, false, false);
+		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_B_MODE,
+				   &wifi_under_b_mode);
+
+		/* Set CCK Tx/Rx high Pri except 11b mode */
+		if (wifi_under_b_mode) {
+			btcoexist->btc_write_1byte(btcoexist, 0x6cd,
+						   0x00); /* CCK Tx */
+			btcoexist->btc_write_1byte(btcoexist, 0x6cf,
+						   0x00); /* CCK Rx */
+		} else {
+			btcoexist->btc_write_1byte(btcoexist, 0x6cd,
+						   0x00); /* CCK Tx */
+			btcoexist->btc_write_1byte(btcoexist, 0x6cf,
+						   0x10); /* CCK Rx */
+		}
+
+		coex_dm->backup_arfr_cnt1 =
+			btcoexist->btc_read_4byte(btcoexist, 0x430);
+		coex_dm->backup_arfr_cnt2 =
+			btcoexist->btc_read_4byte(btcoexist, 0x434);
+		coex_dm->backup_retry_limit =
+			btcoexist->btc_read_2byte(btcoexist, 0x42a);
+		coex_dm->backup_ampdu_max_time =
+			btcoexist->btc_read_1byte(btcoexist, 0x456);
+	} else {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], MEDIA disconnect notify\n");
 
+		btcoexist->btc_write_1byte(btcoexist, 0x6cd, 0x0); /* CCK Tx */
+		btcoexist->btc_write_1byte(btcoexist, 0x6cf, 0x0); /* CCK Rx */
+
+		coex_sta->cck_ever_lock = false;
+	}
+
 	/* only 2.4G we need to inform bt the chnl mask */
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_CENTRAL_CHNL,
 			   &wifi_central_chnl);
-- 
2.12.0
