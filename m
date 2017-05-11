Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34501 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756738AbdEKXZE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 19:25:04 -0400
Received: by mail-oi0-f68.google.com with SMTP id w10so6440927oif.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 16:25:03 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 07/10] rtlwifi: btcoex: 21a 1ant: normal mode for retry limit when connected
Date: Thu, 11 May 2017 18:24:35 -0500
Message-Id: <20170511232438.23159-8-Larry.Finger@lwfinger.net> (sfid-20170512_012522_827240_F0AB5F70)
In-Reply-To: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
References: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When wifi is connected, use normal mode to set retry limit.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 834cf08103b2..3d77d6bb48b1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2028,11 +2028,11 @@ static void btc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 			    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 				btc8821a1ant_limited_tx(btcoexist,
 							NORMAL_EXEC, 1, 1,
-							1, 1);
+							0, 1);
 			} else {
 				btc8821a1ant_limited_tx(btcoexist,
 							NORMAL_EXEC, 1, 1,
-							1, 1);
+							0, 1);
 			}
 		} else {
 			btc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC,
-- 
2.12.2
