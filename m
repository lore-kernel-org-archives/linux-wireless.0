Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36627 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753141AbdDJQX2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:28 -0400
Received: by mail-oi0-f67.google.com with SMTP id b187so23325750oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:28 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 14/14] rtlwifi: btcoex: 21a 1ant: avoid LPS/IPS mismatch for pnp notify
Date: Mon, 10 Apr 2017 11:23:10 -0500
Message-Id: <20170410162310.7515-15-Larry.Finger@lwfinger.net> (sfid-20170410_182338_330308_2EE0D4BE)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When driver is going to sleep, it does not leave LPS/IPS, thus the
BTCoex may have mismatch when driver wakes up. To avoid that, BTCoex
needs to clear the IPS/LPS state when it receives a pnp notify, then
it can properly set up the hw when driver wakes up.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c  | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 0509ffab9e6f..5e9f3b0f7a25 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2905,11 +2905,18 @@ void ex_btc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 	if (BTC_WIFI_PNP_SLEEP == pnp_state) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Pnp notify to SLEEP\n");
+		/* BT should clear UnderIPS/UnderLPS state to avoid mismatch
+		 * state after wakeup.
+		 */
+		coex_sta->under_ips = false;
+		coex_sta->under_lps = false;
 		btcoexist->stop_coex_dm = true;
-		btc8821a1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
 		btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
 					      0x0, 0x0);
-		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 9);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+		btc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT, false,
+					  true);
 	} else if (BTC_WIFI_PNP_WAKE_UP == pnp_state) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Pnp notify to WAKE UP\n");
-- 
2.12.0
