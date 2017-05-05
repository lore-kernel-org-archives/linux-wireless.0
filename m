Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35364 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdEEQR1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 12:17:27 -0400
Received: by mail-io0-f196.google.com with SMTP id v34so2444242iov.2
        for <linux-wireless@vger.kernel.org>; Fri, 05 May 2017 09:17:27 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 07/10] rtlwifi: btcoex: 21a 2ant: init wlan when leave ips
Date: Fri,  5 May 2017 11:17:09 -0500
Message-Id: <20170505161712.8685-8-Larry.Finger@lwfinger.net> (sfid-20170505_181916_615716_99FAC210)
In-Reply-To: <20170505161712.8685-1-Larry.Finger@lwfinger.net>
References: <20170505161712.8685-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

If the wifi is leaving ips, re-init the coex mechanisms, and before it is
going into ips, the bt can just ignore the wifi activities.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - resubmit after removal of BT_AUTO_REPORT_XXXX symbols.
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 56972d36fe84..531598366327 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3899,11 +3899,15 @@ void ex_btc8821a2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 			 "[BTCoex], IPS ENTER notify\n");
 		coex_sta->under_ips = true;
 		btc8821a2ant_wifi_off_hw_cfg(btcoexist);
+		btc8821a2ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
 		btc8821a2ant_coex_all_off(btcoexist);
 	} else if (BTC_IPS_LEAVE == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], IPS LEAVE notify\n");
 		coex_sta->under_ips = false;
+		ex_btc8821a2ant_init_hwconfig(btcoexist);
+		btc8821a2ant_init_coex_dm(btcoexist);
+		btc8821a2ant_query_bt_info(btcoexist);
 	}
 }
 
-- 
2.12.2
