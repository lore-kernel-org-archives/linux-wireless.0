Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:33358 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbeB0B5s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 20:57:48 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <colin.king@canonical.com>, <Larry.Finger@lwfinger.net>,
        <yhchuang@realtek.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] rtlwifi: btcoex: fix argument typo of if-statement found by Coccinelle
Date: Tue, 27 Feb 2018 09:57:24 +0800
Message-ID: <20180227015724.4782-1-pkshih@realtek.com> (sfid-20180227_025752_595241_750E5B0F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

This was detected with static analysis using Coccinelle:

./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c:1107:5-18:
duplicated argument to && or ||

Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index fd3b1fb35dff..05beb16f0a0a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1104,7 +1104,7 @@ static void halbtc8723b1ant_ps_tdma(struct btc_coexist *btcoexist,
 	}
 
 	if ((type == 1) || (type == 2) || (type == 9) || (type == 11) ||
-	    (type == 101) || (type == 102) || (type == 109) || (type == 101)) {
+	    (type == 101) || (type == 102) || (type == 109) || (type == 111)) {
 		if (!coex_sta->force_lps_on) {
 			/* Native power save TDMA, only for A2DP-only case
 			 * 1/2/9/11 while wifi noisy threshold > 30
-- 
2.15.1
