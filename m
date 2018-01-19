Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:39537 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754090AbeASGqY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 01:46:24 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/10] rtlwifi: 8822be has to report vht capability to mac80211
Date: Fri, 19 Jan 2018 14:45:49 +0800
Message-ID: <20180119064551.10084-9-pkshih@realtek.com> (sfid-20180119_074642_857951_618AA778)
In-Reply-To: <20180119064551.10084-1-pkshih@realtek.com>
References: <20180119064551.10084-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

8822be is 2x2 11ac wifi chip, so report VHT capability to mac80211.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index c8ebf738cb2b..7fa435e95c0e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -244,7 +244,8 @@ static void _rtl_init_hw_vht_capab(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE) {
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE ||
+	    rtlhal->hw_type == HARDWARE_TYPE_RTL8822BE) {
 		u16 mcs_map;
 
 		vht_cap->vht_supported = true;
-- 
2.15.1
