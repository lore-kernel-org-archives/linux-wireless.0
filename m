Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36719 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755362AbdDMSHY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:24 -0400
Received: by mail-oi0-f68.google.com with SMTP id b187so13576352oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:24 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 09/19] rtlwifi: btcoex: 21a 2ant: do not check wifi bandwidth
Date: Thu, 13 Apr 2017 13:07:00 -0500
Message-Id: <20170413180710.19953-10-Larry.Finger@lwfinger.net> (sfid-20170413_202544_152515_FB2AEE7D)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Remove workaround for HT40 issues for RF low pass filter.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c   | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 36e722a33f0f..77916ae3d043 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -958,16 +958,6 @@ static void btc8821a2ant_sw_mechanism1(struct btc_coexist *btcoexist,
 				       bool shrink_rx_lpf, bool low_penalty_ra,
 				       bool limited_dig, bool bt_lna_constrain)
 {
-	u32 wifi_bw;
-
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-
-	if (BTC_WIFI_BW_HT40 != wifi_bw) {
-		/*only shrink RF Rx LPF for HT40*/
-		if (shrink_rx_lpf)
-			shrink_rx_lpf = false;
-	}
-
 	btc8821a2ant_low_penalty_ra(btcoexist, NORMAL_EXEC, low_penalty_ra);
 }
 
-- 
2.12.0
