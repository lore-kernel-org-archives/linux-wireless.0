Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:56132 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2ECFM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 01:12:27 -0400
Message-ID: <4FA213B9.7020700@gtri.gatech.edu> (sfid-20120503_071229_942202_35CF664A)
Date: Thu, 3 May 2012 01:12:25 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/9] rtlwifi: check for all 8192Sx-family cards for efuse
 operations
References: <4FA212D9.5020602@gtri.gatech.edu>
In-Reply-To: <4FA212D9.5020602@gtri.gatech.edu>
Content-Type: multipart/mixed;
	boundary="------------000802040609060809080107"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------000802040609060809080107
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit



--------------000802040609060809080107
Content-Type: text/x-patch;
	name="0005-rtlwifi-check-for-all-8192Sx-family-cards-for-efuse-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0005-rtlwifi-check-for-all-8192Sx-family-cards-for-efuse-.pa";
	filename*1="tch"

>From faf3570295654de24245fb00f422ed00d0ea6415 Mon Sep 17 00:00:00 2001
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Date: Thu, 3 May 2012 00:15:13 -0400
Subject: [PATCH 5/9] rtlwifi: check for all 8192Sx-family cards for efuse
 operations


Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/efuse.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
index 1f14380..fef3727 100644
--- a/drivers/net/wireless/rtlwifi/efuse.c
+++ b/drivers/net/wireless/rtlwifi/efuse.c
@@ -1102,8 +1102,7 @@ static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 	u8 tempval;
 	u16 tmpV16;
 
-	if (pwrstate && (rtlhal->hw_type !=
-		HARDWARE_TYPE_RTL8192SE)) {
+	if (pwrstate && (!IS_HARDWARE_TYPE_8192S(rtlhal))) {
 		tmpV16 = rtl_read_word(rtlpriv,
 				       rtlpriv->cfg->maps[SYS_ISO_CTRL]);
 		if (!(tmpV16 & rtlpriv->cfg->maps[EFUSE_PWC_EV12V])) {
@@ -1137,7 +1136,7 @@ static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 						rtlpriv->cfg->maps[EFUSE_TEST] +
 						3);
 
-			if (rtlhal->hw_type != HARDWARE_TYPE_RTL8192SE) {
+			if (!IS_HARDWARE_TYPE_8192S(rtlhal)) {
 				tempval &= 0x0F;
 				tempval |= (VOLTAGE_V25 << 4);
 			}
@@ -1147,7 +1146,7 @@ static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 				       (tempval | 0x80));
 		}
 
-		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+		if (IS_HARDWARE_TYPE_8192S(rtlhal)) {
 			rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CLK],
 						0x03);
 		}
@@ -1162,7 +1161,7 @@ static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 				       (tempval & 0x7F));
 		}
 
-		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+		if (IS_HARDWARE_TYPE_8192S(rtlhal)) {
 			rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CLK],
 						0x02);
 		}
-- 
1.7.7.6


--------------000802040609060809080107--
