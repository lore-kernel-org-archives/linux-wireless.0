Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35082 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbbEOVdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 17:33:21 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Shao Fu <shaofu@realtek.com>,
	netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4/5] rtlwifi: rtl8723be: Update driver for regulatory changes
Date: Fri, 15 May 2015 16:33:02 -0500
Message-Id: <1431725583-7324-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150515_233331_455465_6C9306E5)
In-Reply-To: <1431725583-7324-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1431725583-7324-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shao Fu <shaofu@realtek.com>

The driver is converted to use the channel plan in the EEPROM.

Signed-off-by: Shao Fu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
index b681af3..e0f679b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
@@ -2139,8 +2139,8 @@ static void _rtl8723be_read_adapter_info(struct ieee80211_hw *hw,
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 		 "EEPROM Customer ID: 0x%2x\n", rtlefuse->eeprom_oemid);
 
-	/* set channel plan to world wide 13 */
-	rtlefuse->channel_plan = COUNTRY_CODE_WORLD_WIDE_13;
+	/* set channel plan from efuse */
+	rtlefuse->channel_plan = rtlefuse->eeprom_channelplan;
 
 	if (rtlhal->oem_id == RT_CID_DEFAULT) {
 		/* Does this one have a Toshiba SMID from group 1? */
-- 
2.1.4

