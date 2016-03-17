Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:35234 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966939AbcCQSlR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 14:41:17 -0400
Received: by mail-ob0-f193.google.com with SMTP id e7so6741213obv.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 11:41:16 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/9] rtlwifi: btcoexist: Fix Smatch warning
Date: Thu, 17 Mar 2016 13:40:57 -0500
Message-Id: <1458240064-31422-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160317_194123_681733_A1612969)
In-Reply-To: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch reports the following:

  CHECK   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3078 btc8723b2ant_run_coexist_mechanism() warn: inconsistent indenting

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 77cbd10..205f78b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -3075,7 +3075,7 @@ static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 				  "[BTCoex], Action 2-Ant, "
 				  "algorithm = HS mode.\n");
 			btc8723b2ant_action_pan_hs(btcoexist);
-				break;
+			break;
 		case BT_8723B_2ANT_COEX_ALGO_PANEDR_A2DP:
 			BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE,
 				  "[BTCoex], Action 2-Ant, "
-- 
2.1.4

