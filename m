Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:38379 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753987AbdIDRvw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 13:51:52 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>,
        Steven Ting <steventing@realtek.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] rtlwifi: btcoexist: Fix breakage of ant_sel for rtl8723be
Date: Mon,  4 Sep 2017 12:51:33 -0500
Message-Id: <20170904175134.8331-2-Larry.Finger@lwfinger.net> (sfid-20170904_195156_988694_9AED416B)
In-Reply-To: <20170904175134.8331-1-Larry.Finger@lwfinger.net>
References: <20170904175134.8331-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit bcd37f4a0831 ("rtlwifi: btcoex: 23b 2ant: let bt transmit when
hw initialisation done"), there is an additional error when the module
parameter ant_sel is used to select the auxilary antenna. The error is
that the antenna selection is not checked when writing the antenna
selection register.

Fixes: bcd37f4a0831 ("rtlwifi: btcoex: 23b 2ant: let bt transmit when hw initialisation done")
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
Cc: Stable <stable@vger.kernel.org> # 4.12+
---

Kalle,

This material is intended for kernel 4.14.
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 31965f0ef69d..e8f07573aed9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1183,7 +1183,10 @@ static void btc8723b2ant_set_ant_path(struct btc_coexist *btcoexist,
 		}
 
 		/* fixed internal switch S1->WiFi, S0->BT */
-		btcoexist->btc_write_4byte(btcoexist, 0x948, 0x0);
+		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT)
+			btcoexist->btc_write_2byte(btcoexist, 0x948, 0x0);
+		else
+			btcoexist->btc_write_2byte(btcoexist, 0x948, 0x280);
 
 		switch (antpos_type) {
 		case BTC_ANT_WIFI_AT_MAIN:
-- 
2.12.3
