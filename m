Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34402 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbcLBBs6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:58 -0500
Received: by mail-oi0-f67.google.com with SMTP id m75so25565151oig.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:57 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 13/14] rtlwifi: rtl8723be: fix ant_sel code
Date: Thu,  1 Dec 2016 19:48:32 -0600
Message-Id: <20161202014833.6856-14-Larry.Finger@lwfinger.net> (sfid-20161202_024905_031886_21338EC9)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

When ant_sel is set, we need to fill single_ant_path to select correct
antenna path.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index c2cd99f..00473a6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -2700,9 +2700,13 @@ void rtl8723be_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
 	}
 
 	/* override ant_num / ant_path */
-	if (mod_params->ant_sel)
+	if (mod_params->ant_sel) {
 		rtlpriv->btcoexist.btc_info.ant_num =
 			(mod_params->ant_sel == 1 ? ANT_X2 : ANT_X1);
+
+		rtlpriv->btcoexist.btc_info.single_ant_path =
+			(mod_params->ant_sel == 1 ? 0 : 1);
+	}
 }
 
 void rtl8723be_bt_reg_init(struct ieee80211_hw *hw)
-- 
2.10.2
