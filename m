Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34365 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3HACaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 22:30:19 -0400
Received: by mail-pa0-f49.google.com with SMTP id bi5so1564724pad.8
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 19:30:18 -0700 (PDT)
From: Mark Schulte <schultetwin@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	Mark Schulte <schultetwin@gmail.com>
Subject: [PATCH v3] rtlwifi: rtl8192cu: fix function declaration header
Date: Wed, 31 Jul 2013 19:30:14 -0700
Message-Id: <1375324214-24271-1-git-send-email-schultetwin@gmail.com> (sfid-20130801_043022_093148_10025C67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move rtl92cu_update_hal_rate_tbl declaration to hw.h to correspond with function
definition in hw.c.
Fixes sparse warning in hw.c warning: symbol 'rtl92cu_update_hal_rate_tbl' was
not declared.

Signed-off-by: Mark Schulte <schultetwin@gmail.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.h | 3 +++
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.h | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
index 8e3ec1e..0f7812e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
@@ -109,5 +109,8 @@ void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
 void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw,
 			 u8 element_id, u32 cmd_len, u8 *p_cmdbuffer);
 bool rtl92cu_phy_mac_config(struct ieee80211_hw *hw);
+void rtl92cu_update_hal_rate_tbl(struct ieee80211_hw *hw,
+				 struct ieee80211_sta *sta,
+				 u8 rssi_level);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
index 262e1e4..a1310ab 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
@@ -49,8 +49,5 @@ bool rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
 u32 rtl92cu_phy_query_rf_reg(struct ieee80211_hw *hw,
 			    enum radio_path rfpath, u32 regaddr, u32 bitmask);
 void rtl92cu_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
-void rtl92cu_update_hal_rate_tbl(struct ieee80211_hw *hw,
-				 struct ieee80211_sta *sta,
-				 u8 rssi_level);
 
 #endif
-- 
1.8.3.3

