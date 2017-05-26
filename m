Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35505 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1948600AbdEZSl7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 14:41:59 -0400
Received: by mail-oi0-f68.google.com with SMTP id v80so2985956oie.2
        for <linux-wireless@vger.kernel.org>; Fri, 26 May 2017 11:41:59 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>,
        Steven Ting <steventing@realtek.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH v2 4/7] rtlwifi: btcoex: Remove duplicate test in if statement
Date: Fri, 26 May 2017 13:41:44 -0500
Message-Id: <20170526184147.31239-5-Larry.Finger@lwfinger.net> (sfid-20170526_204334_077474_EA4D7C32)
In-Reply-To: <20170526184147.31239-1-Larry.Finger@lwfinger.net>
References: <20170526184147.31239-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kbuild test robot <lkp@intel.com> reported a duplicate test for
value 101 in a complicated if statement. The extra test is removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: kbuild test robot <lkp@intel.com>
---
v2 - Moved original change to patch #1 and replaced it with fix to if statement
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 03998d2e9eb8..de536b184571 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1110,7 +1110,7 @@ static void halbtc8723b1ant_ps_tdma(struct btc_coexist *btcoexist,
 	}
 
 	if ((type == 1) || (type == 2) || (type == 9) || (type == 11) ||
-	    (type == 101) || (type == 102) || (type == 109) || (type == 101)) {
+	    (type == 101) || (type == 102) || (type == 109)) {
 		if (!coex_sta->force_lps_on) {
 			/* Native power save TDMA, only for A2DP-only case
 			 * 1/2/9/11 while wifi noisy threshold > 30
-- 
2.12.0
