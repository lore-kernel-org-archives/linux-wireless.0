Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34023 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754953AbdDOUcS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:18 -0400
Received: by mail-oi0-f67.google.com with SMTP id t14so12826120oif.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:18 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>
Subject: [PATCH 13/14] rtlwifi: btcoex: 21a 2ant: just return when wifi is under ips
Date: Sat, 15 Apr 2017 15:31:59 -0500
Message-Id: <20170415203200.22979-14-Larry.Finger@lwfinger.net> (sfid-20170415_223232_537677_5290FD04)
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

If wifi is in power saving mode, do nothing.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
  ---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 6 ++++++
 1 file changed, 6 insertions(+)
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 22cb8aa8208d..0aa36247e402 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3483,6 +3483,12 @@ static void btc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		return;
 	}
 
+	if (coex_sta->under_ips) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], wifi is under IPS !!!\n");
+		return;
+	}
+
 	algorithm = btc8821a2ant_action_algorithm(btcoexist);
 	if (coex_sta->c2h_bt_inquiry_page &&
 	    (BT_8821A_2ANT_COEX_ALGO_PANHS != algorithm)) {
-- 
2.12.0
