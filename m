Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:35945 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966640AbcCQSlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 14:41:18 -0400
Received: by mail-ob0-f193.google.com with SMTP id cf7so6685186obc.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 11:41:17 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3/9] rtlwifi: rtl8188ee: Fix Smatch warnings
Date: Thu, 17 Mar 2016 13:40:58 -0500
Message-Id: <1458240064-31422-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160317_194121_773561_FC61D24B)
In-Reply-To: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch reports the following:

  CHECK   drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c:1140 rtl88e_dm_check_txpower_tracking() warn: inconsistent indenting
  CHECK   drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c:1906 _rtl88e_phy_lc_calibrate() warn: inconsistent indenting

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c  | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
index ce4da9d..db9a782 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
@@ -1137,7 +1137,7 @@ void rtl88e_dm_check_txpower_tracking(struct ieee80211_hw *hw)
 	} else {
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 			 "Schedule TxPowerTracking !!\n");
-				dm_txpower_track_cb_therm(hw);
+		dm_txpower_track_cb_therm(hw);
 		rtlpriv->dm.tm_trigger = 0;
 	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
index a2bb02c..416a9ba 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -1903,8 +1903,7 @@ static void _rtl88e_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
 	} else {
 		rtl_write_byte(rtlpriv, REG_TXPAUSE, 0x00);
 	}
-RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "\n");
-
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "\n");
 }
 
 static void _rtl88e_phy_set_rfpath_switch(struct ieee80211_hw *hw,
-- 
2.1.4

