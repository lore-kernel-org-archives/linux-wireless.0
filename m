Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f196.google.com ([209.85.214.196]:35261 "EHLO
	mail-ob0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031513AbcCQSlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 14:41:22 -0400
Received: by mail-ob0-f196.google.com with SMTP id e7so6741432obv.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 11:41:22 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 8/9] rtlwifi: rtl8723be: Fix Smatch warnings
Date: Thu, 17 Mar 2016 13:41:03 -0500
Message-Id: <1458240064-31422-9-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160317_194132_287191_63844B76)
In-Reply-To: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch reports the following:

  CHECK   drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c:1726 _rtl8723be_phy_path_a_rx_iqk() warn: inconsistent indenting
drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c:2304 _rtl8723be_phy_lc_calibrate() warn: inconsistent indenting
drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c:2609 _rtl8723be_phy_set_rf_power_state() warn: inconsistent indenting
  CHECK   drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c
drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c:306 _rtl8723be_get_txpower_writeval_by_regulatory() warn: inconsistent indenting

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 10 ++++------
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c  |  4 ++--
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index b7b73cb..445f681 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -1723,8 +1723,8 @@ static u8 _rtl8723be_phy_path_a_rx_iqk(struct ieee80211_hw *hw)
 
 	/* Allen 20131125 */
 	tmp = (reg_eac & 0x03FF0000) >> 16;
-		if ((tmp & 0x200) > 0)
-			tmp = 0x400 - tmp;
+	if ((tmp & 0x200) > 0)
+		tmp = 0x400 - tmp;
 	/* if Tx is OK, check whether Rx is OK */
 	if (!(reg_eac & BIT(27)) &&
 	    (((reg_ea4 & 0x03FF0000) >> 16) != 0x132) &&
@@ -2301,8 +2301,7 @@ static void _rtl8723be_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
 	} else {
 		rtl_write_byte(rtlpriv, REG_TXPAUSE, 0x00);
 	}
-RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "\n");
-
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "\n");
 }
 
 static void _rtl8723be_phy_set_rfpath_switch(struct ieee80211_hw *hw,
@@ -2606,8 +2605,7 @@ static bool _rtl8723be_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					 "IPS Set eRf nic enable\n");
 				rtstatus = rtl_ps_enable_nic(hw);
 			} while (!rtstatus && (initializecount < 10));
-				RT_CLEAR_PS_LEVEL(ppsc,
-						  RT_RF_OFF_LEVL_HALT_NIC);
+			RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 				 "Set ERFON sleeped:%d ms\n",
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c
index 5ed4492..97f5a03 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c
@@ -303,8 +303,8 @@ static void _rtl8723be_get_txpower_writeval_by_regulatory(
 					   [chnlgroup][index + (rf ? 8 : 0)] &
 					      (0x7f << (i * 8))) >> (i * 8));
 
-					if (pwr_diff_limit[i] > pwr_diff)
-						pwr_diff_limit[i] = pwr_diff;
+				if (pwr_diff_limit[i] > pwr_diff)
+					pwr_diff_limit[i] = pwr_diff;
 			}
 
 			customer_limit = (pwr_diff_limit[3] << 24) |
-- 
2.1.4

