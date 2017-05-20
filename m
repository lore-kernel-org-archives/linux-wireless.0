Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34016 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932292AbdETPtU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 May 2017 11:49:20 -0400
Received: by mail-oi0-f67.google.com with SMTP id w10so16697639oif.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 May 2017 08:49:20 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 09/10] rtlwifi: btcoex: 23b 1ant: fine tune for bt_sco_hid busy
Date: Sat, 20 May 2017 10:49:06 -0500
Message-Id: <20170520154907.15590-10-Larry.Finger@lwfinger.net> (sfid-20170520_174940_839554_21357713)
In-Reply-To: <20170520154907.15590-1-Larry.Finger@lwfinger.net>
References: <20170520154907.15590-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Fine tune the parameters in case of act_bt_sco_hid_only_busy.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index d938c8a4b180..5d780d8d7bbf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1843,7 +1843,7 @@ static void btc8723b1ant_act_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
 	/* tdma and coex table */
 	if (bt_link_info->sco_exist) {
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
-		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 5);
 	} else {
 		/* HID */
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 6);
-- 
2.12.0
