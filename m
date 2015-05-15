Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35422 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934194AbbEOVdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 17:33:17 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Shao Fu <shaofu@realtek.com>,
	netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3/5] rtlwifi: rtl8192ee: Apply the regulatory changes to driver
Date: Fri, 15 May 2015 16:33:01 -0500
Message-Id: <1431725583-7324-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150515_233329_123099_7292A0E1)
In-Reply-To: <1431725583-7324-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1431725583-7324-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shao Fu <shaofu@realtek.com>

The driver was setting a channel plan for the world. Now it reads it fromi
EEPROM.

In addition, a typo was fixed.

Signed-off-by: Shao Fu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192ee/hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
index da0a612..0705e7e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
@@ -2194,8 +2194,8 @@ static void _rtl92ee_read_adapter_info(struct ieee80211_hw *hw)
 		 "dev_addr: %pM\n", rtlefuse->dev_addr);
 	/*channel plan */
 	rtlefuse->eeprom_channelplan = *(u8 *)&hwinfo[EEPROM_CHANNELPLAN];
-	/* set channel paln to world wide 13 */
-	rtlefuse->channel_plan = COUNTRY_CODE_WORLD_WIDE_13;
+	/* set channel plan from efuse */
+	rtlefuse->channel_plan = rtlefuse->eeprom_channelplan;
 	/*tx power*/
 	_rtl92ee_read_txpower_info_from_hwpg(hw, rtlefuse->autoload_failflag,
 					     hwinfo);
-- 
2.1.4

