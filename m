Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32915 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756963AbdDQAHT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:07:19 -0400
Received: by mail-oi0-f66.google.com with SMTP id a189so578943oib.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:07:14 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 09/13] rtlwifi: btcoex: 21a 1ant: use default value when initiating coex
Date: Sun, 16 Apr 2017 19:06:56 -0500
Message-Id: <20170417000700.29057-10-Larry.Finger@lwfinger.net> (sfid-20170417_020749_914485_61506230)
In-Reply-To: <20170417000700.29057-1-Larry.Finger@lwfinger.net>
References: <20170417000700.29057-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For newer coex mechanism, it is not necessary to set a critical value to
avoid the power on instability, just use default value for PTA.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 08bf42e80e83..6b1ded6a0576 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2096,7 +2096,6 @@ static void btc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
 	 */
 	btc8821a1ant_sw_mechanism(btcoexist, false);
 
-	btc8821a1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
 	btc8821a1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 }
 
-- 
2.12.0
