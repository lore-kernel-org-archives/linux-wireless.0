Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:54833 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111Ab2EHCS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 22:18:58 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 4/9] rtlwifi: check for all 8192Sx-family cards for efuse operations
Date: Mon, 7 May 2012 22:18:36 -0400
Message-ID: <1336443521-15299-5-git-send-email-Joshua.Roys@gtri.gatech.edu> (sfid-20120508_041917_712268_E91D7E78)
In-Reply-To: <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
References: <4FA212D9.5020602@gtri.gatech.edu>
 <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
1.7.4.1

