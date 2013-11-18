Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61959 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3KRRL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:11:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: [PATCH 09/12 NEXT] rtlwifi: rtl8192cu: Update the power index registers
Date: Mon, 18 Nov 2013 11:11:33 -0600
Message-Id: <1384794696-20314-10-git-send-email-Larry.Finger@lwfinger.net> (sfid-20131118_181305_350407_1DA57814)
In-Reply-To: <1384794696-20314-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1384794696-20314-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses the newly introduced power index register routines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c | 6 ++++++
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.h | 3 +++
 2 files changed, 9 insertions(+)

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
@@ -101,6 +101,15 @@ void rtl92cu_dm_dynamic_txpower(struct i
 			 "PHY_SetTxPowerLevel8192S() Channel = %d\n",
 			 rtlphy->current_channel);
 		rtl92c_phy_set_txpower_level(hw, rtlphy->current_channel);
+		if (rtlpriv->dm.dynamic_txhighpower_lvl ==
+		    TXHIGHPWRLEVEL_NORMAL)
+			dm_restorepowerindex(hw);
+		else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
+			 TXHIGHPWRLEVEL_LEVEL1)
+			dm_writepowerindex(hw, 0x14);
+		else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
+			 TXHIGHPWRLEVEL_LEVEL2)
+			dm_writepowerindex(hw, 0x10);
 	}
 
 	rtlpriv->dm.last_dtp_lvl = rtlpriv->dm.dynamic_txhighpower_lvl;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
@@ -30,3 +30,6 @@
 #include "../rtl8192ce/dm.h"
 
 void rtl92cu_dm_dynamic_txpower(struct ieee80211_hw *hw);
+void dm_savepowerindex(struct ieee80211_hw *hw);
+void dm_writepowerindex(struct ieee80211_hw *hw, u8 value);
+void dm_restorepowerindex(struct ieee80211_hw *hw);
