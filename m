Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47700 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753797AbdETFhD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 May 2017 01:37:03 -0400
Date: Sat, 20 May 2017 08:33:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] rtlwifi: btcoex: 23b 1ant: fix
 halbtc8723b1ant_action_wifi_only()
Message-ID: <20170520053343.gwdinyn447bwpia2@mwanda> (sfid-20170520_073710_971987_55D677F7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The parameters are in the wrong order when we call
halbtc8723b1ant_set_ant_path() so it's equivalent of calling:

	halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_WIFI, false, true);

Fixes: f66509e3d7c2 ("rtlwifi: btcoex: Remove 23b 1ant configuration parameter")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index f3704d7db4d5..2a7a6ec525a2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1429,7 +1429,7 @@ static void halbtc8723b1ant_action_wifi_only(struct btc_coexist *btcoexist)
 {
 	halbtc8723b1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 	halbtc8723b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
-	halbtc8723b1ant_set_ant_path(btcoexist, false, false, BTC_ANT_PATH_PTA);
+	halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA, false, false);
 }
 
 /* check if BT is disabled */
