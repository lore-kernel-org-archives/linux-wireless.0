Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:39531 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbeBVU3N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 15:29:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl8723be: Fix loss of signal
Date: Thu, 22 Feb 2018 14:28:59 -0600
Message-Id: <20180222202859.16679-1-Larry.Finger@lwfinger.net> (sfid-20180222_212917_364017_C098290E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit c713fb071edc ("rtlwifi: rtl8821ae: Fix connection lost problem
correctly") a problem in rtl8821ae that caused loss of signal was fixed.
That same problem has now been reported for rtl8723be. Accordingly,
the ASPM L1 latency has been increased from 0 to 7 to fix the instability.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
Kalle,

This patch should be sent to 4.16.

Thanks,
Larry
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index f9ccd13c79f9..e7bbbc95cdb1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -1125,7 +1125,8 @@ static void _rtl8723be_enable_aspm_back_door(struct ieee80211_hw *hw)
 
 	/* Configuration Space offset 0x70f BIT7 is used to control L0S */
 	tmp8 = _rtl8723be_dbi_read(rtlpriv, 0x70f);
-	_rtl8723be_dbi_write(rtlpriv, 0x70f, tmp8 | BIT(7));
+	_rtl8723be_dbi_write(rtlpriv, 0x70f, tmp8 | BIT(7) |
+			     ASPM_L1_LATENCY << 3);
 
 	/* Configuration Space offset 0x719 Bit3 is for L1
 	 * BIT4 is for clock request
-- 
2.16.2
