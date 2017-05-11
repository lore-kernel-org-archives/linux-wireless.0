Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36226 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932948AbdEKTBb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 15:01:31 -0400
Received: by mail-oi0-f67.google.com with SMTP id w138so5501983oiw.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 12:01:31 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v3 05/10] rtlwifi: btcoex: 21a 2ant: add pnp notidy to avoid LPS/IPS mismatch
Date: Thu, 11 May 2017 14:01:14 -0500
Message-Id: <20170511190119.23426-6-Larry.Finger@lwfinger.net> (sfid-20170511_210145_657510_EC8B8343)
In-Reply-To: <20170511190119.23426-1-Larry.Finger@lwfinger.net>
References: <20170511190119.23426-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When driver is going to sleep, it does not leave LPS/IPS, thus the
BTCoex may have mismatch when driver wakes up. To avoid that, BTCoex
needs to clear the IPS/LPS state when it receives a pnp notify, then
it can properly set up the hw when driver wakes up.

Routine ex_btc8821a2ant_pnp_notify() restored.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - resubmit after removal of BT_AUTO_REPORT_XXXX symbols.
v3 - no changes
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c        | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 9aa140a46d46..ca7649dca352 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -4147,6 +4147,24 @@ void ex_btc8821a2ant_halt_notify(struct btc_coexist *btcoexist)
 	ex_btc8821a2ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
 }
 
+void ex_btc8821a2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD, "[BTCoex], Pnp notify\n");
+
+	if (pnp_state == BTC_WIFI_PNP_SLEEP) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Pnp notify to SLEEP\n");
+	} else if (pnp_state == BTC_WIFI_PNP_WAKE_UP) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Pnp notify to WAKE UP\n");
+		ex_btc8821a2ant_init_hwconfig(btcoexist);
+		btc8821a2ant_init_coex_dm(btcoexist);
+		btc8821a2ant_query_bt_info(btcoexist);
+	}
+}
+
 void ex_btc8821a2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-- 
2.12.0
