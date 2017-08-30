Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.50.84]:26981 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751656AbdH3OF3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 10:05:29 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id C2C473011
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 08:42:25 -0500 (CDT)
Date: Wed, 30 Aug 2017 08:42:23 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] rtlwifi: btcoex: 23b 1ant: fix duplicated code for different
 branches
Message-ID: <20170830134223.GA13596@embeddedgus> (sfid-20170830_160538_292499_0ACD1286)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor code in order to avoid identical code for different branches.

This issue was detected with the help of Coccinelle.

Addresses-Coverity-ID: 1226788
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
This issue was reported by Coverity and it was tested by compilation only.
I'm suspicious this may be a copy/paste error. Please, verify.

 .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c   | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index c044252..960ce80f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -2260,14 +2260,8 @@ static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 
 		if (iot_peer != BTC_IOT_PEER_CISCO &&
 		    iot_peer != BTC_IOT_PEER_BROADCOM) {
-			if (bt_link_info->sco_exist)
-				halbtc8723b1ant_limited_rx(btcoexist,
-							   NORMAL_EXEC, false,
-							   false, 0x5);
-			else
-				halbtc8723b1ant_limited_rx(btcoexist,
-							   NORMAL_EXEC, false,
-							   false, 0x5);
+			halbtc8723b1ant_limited_rx(btcoexist, NORMAL_EXEC,
+						   false, false, 0x5);
 		} else {
 			if (bt_link_info->sco_exist) {
 				halbtc8723b1ant_limited_rx(btcoexist,
-- 
2.5.0
