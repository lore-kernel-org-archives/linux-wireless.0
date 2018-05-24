Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway20.websitewelcome.com ([192.185.59.4]:34984 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S971112AbeEXTnX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 15:43:23 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id BEA66400DFBCB
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2018 13:54:56 -0500 (CDT)
Date: Thu, 24 May 2018 13:54:50 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] rtlwifi: remove duplicate code
Message-ID: <20180524185450.GA2875@embeddedor.com> (sfid-20180524_214548_554287_14512447)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove and refactor some code in order to avoid having identical code
for different branches.

Notice that the logic has been there since 2014.

Addresses-Coverity-ID: 1426199 ("Identical code for different branches")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 23 ++++------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 279fe01..df3facc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -2876,25 +2876,10 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
 
 	/* sw mechanism */
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, true, true,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, true, true,
-						  false, false);
-		}
-	} else {
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism(btcoexist, false, true,
-						  false, false);
-		} else {
-			btc8723b2ant_sw_mechanism(btcoexist, false, true,
-						  false, false);
-		}
-	}
+	if (wifi_bw == BTC_WIFI_BW_HT40)
+		btc8723b2ant_sw_mechanism(btcoexist, true, true, false, false);
+	else
+		btc8723b2ant_sw_mechanism(btcoexist, false, true, false, false);
 }
 
 /* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
-- 
2.7.4
