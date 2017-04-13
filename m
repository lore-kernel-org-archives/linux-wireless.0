Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36678 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755225AbdDMSHW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:22 -0400
Received: by mail-oi0-f65.google.com with SMTP id b187so13576106oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:22 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 07/19] rtlwifi: btcoex: 21a 2ant: suffer less tx penalty from retry
Date: Thu, 13 Apr 2017 13:06:58 -0500
Message-Id: <20170413180710.19953-8-Larry.Finger@lwfinger.net> (sfid-20170413_200802_922880_758C32B3)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Change h2c parameter to decrease tx penalty.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 4abfddcf2d11..1a1e4136d48e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -693,11 +693,11 @@ static void btc8821a2ant_set_sw_penalty_tx_rate_adaptive(
 		/* normal rate except MCS7/6/5, OFDM54/48/36 */
 		h2c_parameter[2] = 0x00;
 		/* MCS7 or OFDM54 */
-		h2c_parameter[3] = 0xf7;
+		h2c_parameter[3] = 0xf5;
 		/* MCS6 or OFDM48 */
-		h2c_parameter[4] = 0xf8;
+		h2c_parameter[4] = 0xa0;
 		/* MCS5 or OFDM36 */
-		h2c_parameter[5] = 0xf9;
+		h2c_parameter[5] = 0xa0;
 	}
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-- 
2.12.0
