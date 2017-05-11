Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:32889 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756748AbdEKXZG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 19:25:06 -0400
Received: by mail-oi0-f67.google.com with SMTP id h4so6463076oib.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 16:25:06 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 10/10] rtlwifi: btcoex: 21a 1ant: re-init coex after wifi leaves IPS
Date: Thu, 11 May 2017 18:24:38 -0500
Message-Id: <20170511232438.23159-11-Larry.Finger@lwfinger.net> (sfid-20170512_012522_587184_CA863224)
In-Reply-To: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
References: <20170511232438.23159-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Before entering IPS, set the PTA control to default value and re-init it
after it leaves IPS to avoid running some redundant code in
run_coexist_mechanism.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index ab6530cfb653..84cc0bcc5f80 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2473,7 +2473,7 @@ void ex_btc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 		btc8821a1ant_set_ant_path(btcoexist,
 					  BTC_ANT_PATH_BT, false, true);
 		/* set PTA control */
-		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
 		btc8821a1ant_coex_table_with_type(btcoexist,
 						  NORMAL_EXEC, 0);
 	} else if (BTC_IPS_LEAVE == type) {
@@ -2481,7 +2481,9 @@ void ex_btc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 			 "[BTCoex], IPS LEAVE notify\n");
 		coex_sta->under_ips = false;
 
-		btc8821a1ant_run_coexist_mechanism(btcoexist);
+		btc8821a1ant_init_hw_config(btcoexist, false, false);
+		btc8821a1ant_init_coex_dm(btcoexist);
+		btc8821a1ant_query_bt_info(btcoexist);
 	}
 }
 
-- 
2.12.2
