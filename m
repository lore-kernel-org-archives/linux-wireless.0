Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34395 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934661AbbEOVdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 17:33:22 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Shao Fu <shaofu@realtek.com>,
	netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/5] rtlwifi: rtl8821ae: Fix problem with regulatory information
Date: Fri, 15 May 2015 16:33:03 -0500
Message-Id: <1431725583-7324-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150515_233346_600271_879E267E)
In-Reply-To: <1431725583-7324-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1431725583-7324-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shao Fu <shaofu@realtek.com>

The driver was not setting a channel plan. Now it gets it from EEPROM.

Signed-off-by: Shao Fu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
index 8704eee..450bd4d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
@@ -3232,8 +3232,8 @@ static void _rtl8821ae_read_adapter_info(struct ieee80211_hw *hw, bool b_pseudo_
 	if (rtlefuse->eeprom_channelplan == 0xff)
 		rtlefuse->eeprom_channelplan = 0x7F;
 
-	/* set channel paln to world wide 13 */
-	/* rtlefuse->channel_plan = (u8)rtlefuse->eeprom_channelplan; */
+	/* set channel plan from efuse */
+	rtlefuse->channel_plan = rtlefuse->eeprom_channelplan;
 
 	/*parse xtal*/
 	rtlefuse->crystalcap = hwinfo[EEPROM_XTAL_8821AE];
-- 
2.1.4

