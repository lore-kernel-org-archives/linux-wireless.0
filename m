Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32773 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932072AbdDDQub (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:31 -0400
Received: by mail-oi0-f65.google.com with SMTP id f193so25704197oib.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:31 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 08/13] rtlwifi: btcoex: 23b 2ant: workaround for bt a2dp and hid
Date: Tue,  4 Apr 2017 11:50:01 -0500
Message-Id: <20170404165006.14329-9-Larry.Finger@lwfinger.net> (sfid-20170404_185036_181038_7FACDE12)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For a2dp and hid, we need extra process to avoid voice degradation

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 8b2bef8..8098676 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1035,6 +1035,8 @@ static void btc8723b2ant_set_fw_ps_tdma(struct btc_coexist *btcoexist, u8 byte1,
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[5];
+	if ((coex_sta->a2dp_exist) && (coex_sta->hid_exist))
+		byte5 = byte5 | 0x1;
 
 	h2c_parameter[0] = byte1;
 	h2c_parameter[1] = byte2;
-- 
2.10.2
