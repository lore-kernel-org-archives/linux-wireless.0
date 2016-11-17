Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:35785 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933343AbcKQSFj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 13:05:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl8723be: Fix bug in ant_sel code from commit c18d8f509571
Date: Thu, 17 Nov 2016 12:05:33 -0600
Message-Id: <20161117180533.16136-1-Larry.Finger@lwfinger.net> (sfid-20161117_190547_225222_16D04C97)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

In commit c18d8f509571 ("rtlwifi: rtl8723be: Add antenna select module
parameter"), wifi was fixed for those laptops that have only a single
antenna but have an incorrectly coded EEPROM. This error causes the
driver to select the wrong antenna. In that commit, one necessary change
that affects Bluetooth operation was missed.

Fixes: c18d8f509571 ("rtlwifi: rtl8723be: Add antenna select module parameter")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index aba60c3..cb046ec 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -2664,9 +2664,12 @@ void rtl8723be_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
 	}
 
 	/* override ant_num / ant_path */
-	if (mod_params->ant_sel)
+	if (mod_params->ant_sel) {
 		rtlpriv->btcoexist.btc_info.ant_num =
 			(mod_params->ant_sel == 1 ? ANT_X2 : ANT_X1);
+		rtlpriv->btcoexist.btc_info.single_ant_path =
+			(mod_params->ant_sel == 1 ? 0 : 1);
+	}
 }
 
 void rtl8723be_bt_reg_init(struct ieee80211_hw *hw)
-- 
2.10.0
