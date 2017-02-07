Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36639 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752543AbdBGDa1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 22:30:27 -0500
Received: by mail-oi0-f66.google.com with SMTP id u143so7925996oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2017 19:30:27 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 10/11 V4] rtlwifi: rtl8723be: fix ant_sel code
Date: Mon,  6 Feb 2017 21:30:07 -0600
Message-Id: <20170120212716.29887-11-Larry.Finger@lwfinger.net> (sfid-20170207_043049_958299_CE0744FB)
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

When ant_sel is set, we need to fill single_ant_path to select correct
antenna path.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - no changes
V3 - no changes
V4 - no changes
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 66e9e4a..d2cd411 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -2696,9 +2696,13 @@ void rtl8723be_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
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
