Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35922 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932246AbdDDQu3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:29 -0400
Received: by mail-oi0-f66.google.com with SMTP id b187so25704664oif.3
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:28 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 06/13] rtlwifi: btcoex: 23b 2ant: add pnp notidy to avoid LPS/IPS mismatch
Date: Tue,  4 Apr 2017 11:49:59 -0500
Message-Id: <20170404165006.14329-7-Larry.Finger@lwfinger.net> (sfid-20170404_185044_277453_7D016A52)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When driver is going to sleep, it does not leave LPS/IPS, thus the
BTCoex may have mismatch when driver wakes up. To avoid that, BTCoex
needs to clear the IPS/LPS state when it receives a pnp notify, then
it can properly set up the hw when driver wakes up.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 8d8425d..735bba9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -3826,6 +3826,33 @@ void ex_btc8723b2ant_halt_notify(struct btc_coexist *btcoexist)
 	ex_btc8723b2ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
 }
 
+void ex_btc8723b2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD, "[BTCoex], Pnp notify\n");
+
+	if (pnp_state == BTC_WIFI_PNP_SLEEP) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Pnp notify to SLEEP\n");
+
+		/* Driver do not leave IPS/LPS when driver is going to sleep, so
+		 * BTCoexistence think wifi is still under IPS/LPS
+		 *
+		 * BT should clear UnderIPS/UnderLPS state to avoid mismatch
+		 * state after wakeup.
+		 */
+		coex_sta->under_ips = false;
+		coex_sta->under_lps = false;
+	} else if (pnp_state == BTC_WIFI_PNP_WAKE_UP) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Pnp notify to WAKE UP\n");
+		ex_btc8723b2ant_init_hwconfig(btcoexist);
+		btc8723b2ant_init_coex_dm(btcoexist);
+		btc8723b2ant_query_bt_info(btcoexist);
+	}
+}
+
 void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-- 
2.10.2
