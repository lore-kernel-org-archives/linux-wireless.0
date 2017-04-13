Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35847 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755362AbdDMSHc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:32 -0400
Received: by mail-oi0-f65.google.com with SMTP id b187so13577215oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:32 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 18/19] rtlwifi: btcoex: 21a 2ant: fix invalid argument passed
Date: Thu, 13 Apr 2017 13:07:09 -0500
Message-Id: <20170413180710.19953-19-Larry.Finger@lwfinger.net> (sfid-20170413_202544_456679_EC731AA5)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

The dac swing level should be an unsigned 32-bit value rather than
boolean.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index f640f6079f9a..3bdf691c9d08 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -1090,7 +1090,7 @@ static void btc8821a2ant_sw_mechanism2(struct btc_coexist *btcoexist,
 				       bool sw_dac_swing, u32 dac_swing_lvl)
 {
 	btc8821a2ant_dac_swing(btcoexist, NORMAL_EXEC, sw_dac_swing,
-			       sw_dac_swing);
+			       dac_swing_lvl);
 }
 
 static void btc8821a2ant_set_ant_path(struct btc_coexist *btcoexist,
-- 
2.12.0
