Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:41071 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3KRRLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:11:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: [PATCH 05/12 NEXT] rtlwifi: rtl8192c: Add new definitions in the dm_common header
Date: Mon, 18 Nov 2013 11:11:29 -0600
Message-Id: <1384794696-20314-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20131118_181210_529069_89A35688)
In-Reply-To: <1384794696-20314-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1384794696-20314-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes in the gain-control mechanism will require some changes in the header.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
index 518e208..4f232a0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
@@ -91,6 +91,17 @@
 #define TX_POWER_NEAR_FIELD_THRESH_LVL2		74
 #define TX_POWER_NEAR_FIELD_THRESH_LVL1		67
 
+#define DYNAMIC_FUNC_DISABLE			0x0
+#define DYNAMIC_FUNC_DIG			BIT(0)
+#define DYNAMIC_FUNC_HP				BIT(1)
+#define DYNAMIC_FUNC_SS				BIT(2) /*Tx Power Tracking*/
+#define DYNAMIC_FUNC_BT				BIT(3)
+#define DYNAMIC_FUNC_ANT_DIV			BIT(4)
+
+#define	RSSI_CCK				0
+#define	RSSI_OFDM				1
+#define	RSSI_DEFAULT				2
+
 struct swat_t {
 	u8 failure_cnt;
 	u8 try_flag;
@@ -167,5 +178,8 @@ void rtl92c_phy_lc_calibrate(struct ieee80211_hw *hw);
 void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool recovery);
 void rtl92c_dm_dynamic_txpower(struct ieee80211_hw *hw);
 void rtl92c_dm_bt_coexist(struct ieee80211_hw *hw);
+void dm_savepowerindex(struct ieee80211_hw *hw);
+void dm_writepowerindex(struct ieee80211_hw *hw, u8 value);
+void dm_restorepowerindex(struct ieee80211_hw *hw);
 
 #endif
-- 
1.8.4

