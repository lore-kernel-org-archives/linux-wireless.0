Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:32911 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757002AbdDQAHN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:07:13 -0400
Received: by mail-oi0-f67.google.com with SMTP id a189so578922oib.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:07:13 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 08/13] rtlwifi: btcoex: 21a 1ant: mark packet high priority when scanning
Date: Sun, 16 Apr 2017 19:06:55 -0500
Message-Id: <20170417000700.29057-9-Larry.Finger@lwfinger.net> (sfid-20170417_020727_038577_8B22B710)
In-Reply-To: <20170417000700.29057-1-Larry.Finger@lwfinger.net>
References: <20170417000700.29057-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When the wifi notifies the coexistence it is going to scan, set the coex
table to avoid issues when the scan result is empty.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 5b624e76303d..08bf42e80e83 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2524,6 +2524,19 @@ void ex_btc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 		return;
 	}
 
+	if (type == BTC_SCAN_START) {
+		coex_sta->wifi_is_high_pri_task = true;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN START notify\n");
+
+		/* Force antenna setup for no scan result issue */
+		btc8821a1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
+	} else {
+		coex_sta->wifi_is_high_pri_task = false;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN FINISH notify\n");
+	}
+
 	if (coex_sta->bt_disabled)
 		return;
 
-- 
2.12.0
