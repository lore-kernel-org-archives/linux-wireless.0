Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34221 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbdDCBOh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Apr 2017 21:14:37 -0400
Received: by mail-oi0-f65.google.com with SMTP id s11so1229046oie.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Apr 2017 18:14:36 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 06/12] rtlwifi: btcoex: 23b 2ant: less sensitive to tx rate penalty
Date: Sun,  2 Apr 2017 20:14:16 -0500
Message-Id: <20170403011428.6156-6-Larry.Finger@lwfinger.net> (sfid-20170403_031501_758959_402DAD9E)
In-Reply-To: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
References: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

modify h2c parameter so that the rate suffers less penalty from retry

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - No changes.
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 16759b028dff..ebf989fa3a16 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -754,9 +754,9 @@ static void btc8723b_set_penalty_txrate(struct btc_coexist *btcoexist,
 		h2c_parameter[1] |= BIT0;
 		/* normal rate except MCS7/6/5, OFDM54/48/36 */
 		h2c_parameter[2] = 0x00;
-		h2c_parameter[3] = 0xf7; /* MCS7 or OFDM54 */
-		h2c_parameter[4] = 0xf8; /* MCS6 or OFDM48 */
-		h2c_parameter[5] = 0xf9; /* MCS5 or OFDM36 */
+		h2c_parameter[3] = 0xf4; /* MCS7 or OFDM54 */
+		h2c_parameter[4] = 0xf5; /* MCS6 or OFDM48 */
+		h2c_parameter[5] = 0xf6; /* MCS5 or OFDM36 */
 	}
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-- 
2.12.0
