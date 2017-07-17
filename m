Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34481 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbdGQPKN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 11:10:13 -0400
Received: by mail-oi0-f65.google.com with SMTP id d77so18146833oig.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 08:10:13 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Tsang-Shian Lin <thlin@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 10/11] rtlwifi: Add bw_update parameter for RA mask update.
Date: Mon, 17 Jul 2017 10:09:53 -0500
Message-Id: <20170717150954.1441-11-Larry.Finger@lwfinger.net> (sfid-20170717_171022_628265_371643B4)
In-Reply-To: <20170717150954.1441-1-Larry.Finger@lwfinger.net>
References: <20170717150954.1441-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

- Add new parameter "is_bw_update" to control if current bandwidth setting
  is updated to FW RA.
- After this commit, we keep the same setting as before.
- Later, bandwidth update in watchdog is changed to false for 8822BE.

Signed-off-by: Tsang-Shian Lin <thlin@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - no changes
---
 drivers/net/wireless/realtek/rtlwifi/base.c         | 2 +-
 drivers/net/wireless/realtek/rtlwifi/core.c         | 5 +++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c | 3 ++-
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c | 6 +++---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h | 3 ++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c | 6 +++---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.h | 5 ++---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 6 +++---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c | 6 +++---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h | 3 ++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c | 3 ++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c | 9 +++++----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.h | 3 ++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c | 3 ++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 6 +++---
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c | 7 ++++---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.h | 3 ++-
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c | 3 ++-
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c | 8 ++++----
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.h | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 8 ++++----
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.h | 2 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h         | 3 ++-
 26 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index f6baa2d00c72..c145cfe27216 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2287,7 +2287,7 @@ int rtl_send_smps_action(struct ieee80211_hw *hw,
 		struct rtl_sta_info *sta_entry =
 			(struct rtl_sta_info *) sta->drv_priv;
 		sta_entry->mimo_ps = smps;
-		/* rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0); */
+		/* rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0, true); */
 
 		info->control.rates[0].idx = 0;
 		info->band = hw->conf.chandef.chan->band;
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index c53cbf3d52bd..bb1425c3dc96 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -945,7 +945,7 @@ static int rtl_op_sta_add(struct ieee80211_hw *hw,
 		memcpy(sta_entry->mac_addr, sta->addr, ETH_ALEN);
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 			"Add sta addr is %pM\n", sta->addr);
-		rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
+		rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0, true);
 	}
 
 	return 0;
@@ -1151,7 +1151,8 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 			}
 
 			if (vif->type == NL80211_IFTYPE_STATION)
-				rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
+				rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0,
+								   true);
 			rcu_read_unlock();
 
 			/* to avoid AP Disassociation caused by inactivity */
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
index f936a491371b..207411d1b015 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
@@ -1221,7 +1221,8 @@ static void rtl88e_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
 			sta = rtl_find_sta(hw, mac->bssid);
 			if (sta)
 				rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
-								   p_ra->ratr_state);
+							p_ra->ratr_state,
+								   true);
 			rcu_read_unlock();
 
 			p_ra->pre_ratr_state = p_ra->ratr_state;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 5b939935eb56..6fbf3df4947e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -2077,7 +2077,7 @@ static void rtl88ee_update_hal_rate_table(struct ieee80211_hw *hw,
 }
 
 static void rtl88ee_update_hal_rate_mask(struct ieee80211_hw *hw,
-		struct ieee80211_sta *sta, u8 rssi_level)
+		struct ieee80211_sta *sta, u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -2208,12 +2208,12 @@ static void rtl88ee_update_hal_rate_mask(struct ieee80211_hw *hw,
 }
 
 void rtl88ee_update_hal_rate_tbl(struct ieee80211_hw *hw,
-		struct ieee80211_sta *sta, u8 rssi_level)
+		struct ieee80211_sta *sta, u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	if (rtlpriv->dm.useramask)
-		rtl88ee_update_hal_rate_mask(hw, sta, rssi_level);
+		rtl88ee_update_hal_rate_mask(hw, sta, rssi_level, update_bw);
 	else
 		rtl88ee_update_hal_rate_table(hw, sta);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h
index d38dbca3c19e..719b78a3b7db 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h
@@ -43,7 +43,8 @@ void rtl88ee_update_interrupt_mask(struct ieee80211_hw *hw,
 				   u32 add_msr, u32 rm_msr);
 void rtl88ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl88ee_update_hal_rate_tbl(struct ieee80211_hw *hw,
-				 struct ieee80211_sta *sta, u8 rssi_level);
+				 struct ieee80211_sta *sta, u8 rssi_level,
+				 bool update_bw);
 void rtl88ee_update_channel_access_setting(struct ieee80211_hw *hw);
 bool rtl88ee_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid);
 void rtl88ee_enable_hw_security_config(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index 9956026bae0a..9310fad69cd9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
@@ -1865,7 +1865,7 @@ static void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw,
 }
 
 static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
-		struct ieee80211_sta *sta, u8 rssi_level)
+		struct ieee80211_sta *sta, u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -1995,12 +1995,12 @@ static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
 }
 
 void rtl92ce_update_hal_rate_tbl(struct ieee80211_hw *hw,
-		struct ieee80211_sta *sta, u8 rssi_level)
+		struct ieee80211_sta *sta, u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	if (rtlpriv->dm.useramask)
-		rtl92ce_update_hal_rate_mask(hw, sta, rssi_level);
+		rtl92ce_update_hal_rate_mask(hw, sta, rssi_level, update_bw);
 	else
 		rtl92ce_update_hal_rate_table(hw, sta);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.h
index 877f138a0cb9..7683c5dfe851 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.h
@@ -56,9 +56,8 @@ void rtl92ce_update_interrupt_mask(struct ieee80211_hw *hw,
 				   u32 add_msr, u32 rm_msr);
 void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl92ce_update_hal_rate_tbl(struct ieee80211_hw *hw,
-				 struct ieee80211_sta *sta, u8 rssi_level);
-void rtl92ce_update_hal_rate_tbl(struct ieee80211_hw *hw,
-				 struct ieee80211_sta *sta, u8 rssi_level);
+				 struct ieee80211_sta *sta, u8 rssi_level,
+				 bool update_bw);
 void rtl92ce_update_channel_access_setting(struct ieee80211_hw *hw);
 bool rtl92ce_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid);
 void rtl92ce_enable_hw_security_config(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index f95a64507f17..4155ca9dfd9e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -2011,7 +2011,7 @@ static void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw,
 
 static void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw,
 					 struct ieee80211_sta *sta,
-					 u8 rssi_level)
+					 u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -2158,12 +2158,12 @@ static void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw,
 
 void rtl92cu_update_hal_rate_tbl(struct ieee80211_hw *hw,
 				 struct ieee80211_sta *sta,
-				 u8 rssi_level)
+				 u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	if (rtlpriv->dm.useramask)
-		rtl92cu_update_hal_rate_mask(hw, sta, rssi_level);
+		rtl92cu_update_hal_rate_mask(hw, sta, rssi_level, update_bw);
 	else
 		rtl92cu_update_hal_rate_table(hw, sta);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
index 932f056f7ef8..ebd168400d45 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
@@ -104,6 +104,6 @@ void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw,
 bool rtl92cu_phy_mac_config(struct ieee80211_hw *hw);
 void rtl92cu_update_hal_rate_tbl(struct ieee80211_hw *hw,
 				 struct ieee80211_sta *sta,
-				 u8 rssi_level);
+				 u8 rssi_level, bool update_bw);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
index cf28d25c551f..5a67f85fa165 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
@@ -1897,7 +1897,7 @@ static void rtl92de_update_hal_rate_table(struct ieee80211_hw *hw,
 }
 
 static void rtl92de_update_hal_rate_mask(struct ieee80211_hw *hw,
-		struct ieee80211_sta *sta, u8 rssi_level)
+		struct ieee80211_sta *sta, u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -2033,12 +2033,12 @@ static void rtl92de_update_hal_rate_mask(struct ieee80211_hw *hw,
 }
 
 void rtl92de_update_hal_rate_tbl(struct ieee80211_hw *hw,
-		struct ieee80211_sta *sta, u8 rssi_level)
+		struct ieee80211_sta *sta, u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	if (rtlpriv->dm.useramask)
-		rtl92de_update_hal_rate_mask(hw, sta, rssi_level);
+		rtl92de_update_hal_rate_mask(hw, sta, rssi_level, update_bw);
 	else
 		rtl92de_update_hal_rate_table(hw, sta);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h
index 24b03b9999be..85c565b86ae3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h
@@ -43,7 +43,8 @@ void rtl92de_update_interrupt_mask(struct ieee80211_hw *hw,
 				   u32 add_msr, u32 rm_msr);
 void rtl92de_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl92de_update_hal_rate_tbl(struct ieee80211_hw *hw,
-				 struct ieee80211_sta *sta, u8 rssi_level);
+				 struct ieee80211_sta *sta, u8 rssi_level,
+				 bool update_bw);
 void rtl92de_update_channel_access_setting(struct ieee80211_hw *hw);
 bool rtl92de_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid);
 void rtl92de_enable_hw_security_config(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
index e6b5786c7d4a..faed6e2dedf6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
@@ -1039,7 +1039,8 @@ static void rtl92ee_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
 			sta = rtl_find_sta(hw, mac->bssid);
 			if (sta)
 				rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
-							      p_ra->ratr_state);
+							      p_ra->ratr_state,
+							      true);
 			rcu_read_unlock();
 
 			p_ra->pre_ratr_state = p_ra->ratr_state;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index 6b0d42a93971..6fc3090c4b72 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -2270,7 +2270,7 @@ static u8 _rtl92ee_mrate_idx_to_arfr_id(struct ieee80211_hw *hw, u8 rate_index)
 
 static void rtl92ee_update_hal_rate_mask(struct ieee80211_hw *hw,
 					 struct ieee80211_sta *sta,
-					 u8 rssi_level)
+					 u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
@@ -2389,7 +2389,7 @@ static void rtl92ee_update_hal_rate_mask(struct ieee80211_hw *hw,
 				       (ratr_index << 28);
 	rate_mask[0] = macid;
 	rate_mask[1] = ratr_index | (b_shortgi ? 0x80 : 0x00);
-	rate_mask[2] = curtxbw_40mhz;
+	rate_mask[2] = curtxbw_40mhz | ((!update_bw) << 3);
 	rate_mask[3] = (u8)(ratr_bitmap & 0x000000ff);
 	rate_mask[4] = (u8)((ratr_bitmap & 0x0000ff00) >> 8);
 	rate_mask[5] = (u8)((ratr_bitmap & 0x00ff0000) >> 16);
@@ -2404,12 +2404,13 @@ static void rtl92ee_update_hal_rate_mask(struct ieee80211_hw *hw,
 }
 
 void rtl92ee_update_hal_rate_tbl(struct ieee80211_hw *hw,
-				 struct ieee80211_sta *sta, u8 rssi_level)
+				 struct ieee80211_sta *sta, u8 rssi_level,
+				 bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	if (rtlpriv->dm.useramask)
-		rtl92ee_update_hal_rate_mask(hw, sta, rssi_level);
+		rtl92ee_update_hal_rate_mask(hw, sta, rssi_level, update_bw);
 }
 
 void rtl92ee_update_channel_access_setting(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.h
index 05413f189685..cd6aeb44b996 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.h
@@ -43,7 +43,8 @@ void rtl92ee_update_interrupt_mask(struct ieee80211_hw *hw,
 				   u32 add_msr, u32 rm_msr);
 void rtl92ee_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl92ee_update_hal_rate_tbl(struct ieee80211_hw *hw,
-				 struct ieee80211_sta *sta, u8 rssi_level);
+				 struct ieee80211_sta *sta, u8 rssi_level,
+				 bool update_bw);
 void rtl92ee_update_channel_access_setting(struct ieee80211_hw *hw);
 bool rtl92ee_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid);
 void rtl92ee_enable_hw_security_config(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c
index 2c073a77b194..44f510a94b09 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c
@@ -295,7 +295,8 @@ static void _rtl92s_dm_refresh_rateadaptive_mask(struct ieee80211_hw *hw)
 			sta = rtl_find_sta(hw, mac->bssid);
 			if (sta)
 				rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
-							   ra->ratr_state);
+							   ra->ratr_state,
+							   true);
 			rcu_read_unlock();
 
 			ra->pre_ratr_state = ra->ratr_state;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index ba1bd782238b..66be79ca4247 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -2129,7 +2129,7 @@ static void rtl92se_update_hal_rate_table(struct ieee80211_hw *hw,
 
 static void rtl92se_update_hal_rate_mask(struct ieee80211_hw *hw,
 					 struct ieee80211_sta *sta,
-					 u8 rssi_level)
+					 u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -2288,12 +2288,12 @@ static void rtl92se_update_hal_rate_mask(struct ieee80211_hw *hw,
 }
 
 void rtl92se_update_hal_rate_tbl(struct ieee80211_hw *hw,
-		struct ieee80211_sta *sta, u8 rssi_level)
+		struct ieee80211_sta *sta, u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	if (rtlpriv->dm.useramask)
-		rtl92se_update_hal_rate_mask(hw, sta, rssi_level);
+		rtl92se_update_hal_rate_mask(hw, sta, rssi_level, update_bw);
 	else
 		rtl92se_update_hal_rate_table(hw, sta);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h
index 86bce1be83ce..3c93d30fcae7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h
@@ -59,7 +59,7 @@ void rtl92se_update_interrupt_mask(struct ieee80211_hw *hw,
 void rtl92se_set_hw_reg(struct ieee80211_hw *hw, u8 variable,
 			u8 *val);
 void rtl92se_update_hal_rate_tbl(struct ieee80211_hw *hw,
-		struct ieee80211_sta *sta, u8 rssi_level);
+		struct ieee80211_sta *sta, u8 rssi_level, bool update_bw);
 void rtl92se_update_channel_access_setting(struct ieee80211_hw *hw);
 bool rtl92se_gpio_radio_on_off_checking(struct ieee80211_hw *hw,
 					u8 *valid);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index 5ac7b815648a..4c07f03b4ec1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -1943,7 +1943,7 @@ static void rtl8723e_update_hal_rate_table(struct ieee80211_hw *hw,
 
 static void rtl8723e_update_hal_rate_mask(struct ieee80211_hw *hw,
 					  struct ieee80211_sta *sta,
-					  u8 rssi_level)
+					  u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -2074,12 +2074,13 @@ static void rtl8723e_update_hal_rate_mask(struct ieee80211_hw *hw,
 }
 
 void rtl8723e_update_hal_rate_tbl(struct ieee80211_hw *hw,
-				  struct ieee80211_sta *sta, u8 rssi_level)
+				  struct ieee80211_sta *sta, u8 rssi_level,
+				  bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	if (rtlpriv->dm.useramask)
-		rtl8723e_update_hal_rate_mask(hw, sta, rssi_level);
+		rtl8723e_update_hal_rate_mask(hw, sta, rssi_level, update_bw);
 	else
 		rtl8723e_update_hal_rate_table(hw, sta);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.h
index 32c1ace97c3f..1e7063105c96 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.h
@@ -49,7 +49,8 @@ void rtl8723e_update_interrupt_mask(struct ieee80211_hw *hw,
 				    u32 add_msr, u32 rm_msr);
 void rtl8723e_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl8723e_update_hal_rate_tbl(struct ieee80211_hw *hw,
-				  struct ieee80211_sta *sta, u8 rssi_level);
+				  struct ieee80211_sta *sta, u8 rssi_level,
+				  bool update_bw);
 void rtl8723e_update_channel_access_setting(struct ieee80211_hw *hw);
 bool rtl8723e_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid);
 void rtl8723e_enable_hw_security_config(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
index 131c0d1d633e..24b138c3ae0a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
@@ -988,7 +988,8 @@ static void rtl8723be_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
 			sta = rtl_find_sta(hw, mac->bssid);
 			if (sta)
 				rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
-							   p_ra->ratr_state);
+							   p_ra->ratr_state,
+							   true);
 			rcu_read_unlock();
 
 			p_ra->pre_ratr_state = p_ra->ratr_state;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index f07ab578ef88..7633243319eb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -2328,7 +2328,7 @@ static u8 _rtl8723be_mrate_idx_to_arfr_id(struct ieee80211_hw *hw,
 
 static void rtl8723be_update_hal_rate_mask(struct ieee80211_hw *hw,
 					   struct ieee80211_sta *sta,
-					   u8 rssi_level)
+					   u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -2444,7 +2444,7 @@ static void rtl8723be_update_hal_rate_mask(struct ieee80211_hw *hw,
 	rate_mask[0] = macid;
 	rate_mask[1] = _rtl8723be_mrate_idx_to_arfr_id(hw, ratr_index) |
 						      (shortgi ? 0x80 : 0x00);
-	rate_mask[2] = curtxbw_40mhz;
+	rate_mask[2] = curtxbw_40mhz | ((!update_bw) << 3);
 
 	rate_mask[3] = (u8)(ratr_bitmap & 0x000000ff);
 	rate_mask[4] = (u8)((ratr_bitmap & 0x0000ff00) >> 8);
@@ -2464,11 +2464,11 @@ static void rtl8723be_update_hal_rate_mask(struct ieee80211_hw *hw,
 
 void rtl8723be_update_hal_rate_tbl(struct ieee80211_hw *hw,
 				   struct ieee80211_sta *sta,
-				   u8 rssi_level)
+				   u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	if (rtlpriv->dm.useramask)
-		rtl8723be_update_hal_rate_mask(hw, sta, rssi_level);
+		rtl8723be_update_hal_rate_mask(hw, sta, rssi_level, update_bw);
 }
 
 void rtl8723be_update_channel_access_setting(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.h
index eae863d08de8..54d7afa7297e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.h
@@ -46,7 +46,7 @@ void rtl8723be_update_interrupt_mask(struct ieee80211_hw *hw,
 void rtl8723be_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl8723be_update_hal_rate_tbl(struct ieee80211_hw *hw,
 				   struct ieee80211_sta *sta,
-				   u8 rssi_level);
+				   u8 rssi_level, bool update_bw);
 void rtl8723be_update_channel_access_setting(struct ieee80211_hw *hw);
 bool rtl8723be_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid);
 void rtl8723be_enable_hw_security_config(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index 32900c51f024..b11365a5ee1f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -2592,7 +2592,7 @@ static void rtl8821ae_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
 			sta = rtl_find_sta(hw, mac->bssid);
 			if (sta)
 				rtlpriv->cfg->ops->update_rate_tbl(hw,
-						sta, p_ra->ratr_state);
+						sta, p_ra->ratr_state, true);
 			rcu_read_unlock();
 
 			p_ra->pre_ratr_state = p_ra->ratr_state;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 8bad6d1fb1b7..913b6c2a70b3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -3599,7 +3599,7 @@ static bool _rtl8821ae_get_ra_shortgi(struct ieee80211_hw *hw, struct ieee80211_
 }
 
 static void rtl8821ae_update_hal_rate_mask(struct ieee80211_hw *hw,
-		struct ieee80211_sta *sta, u8 rssi_level)
+		struct ieee80211_sta *sta, u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
@@ -3778,7 +3778,7 @@ static void rtl8821ae_update_hal_rate_mask(struct ieee80211_hw *hw,
 
 	rate_mask[0] = macid;
 	rate_mask[1] = ratr_index | (b_shortgi ? 0x80 : 0x00);
-	rate_mask[2] = rtlphy->current_chan_bw
+	rate_mask[2] = rtlphy->current_chan_bw | ((!update_bw) << 3)
 			   | _rtl8821ae_get_vht_eni(wirelessmode, ratr_bitmap)
 			   | _rtl8821ae_get_ra_ldpc(hw, macid, sta_entry, wirelessmode);
 
@@ -3799,11 +3799,11 @@ static void rtl8821ae_update_hal_rate_mask(struct ieee80211_hw *hw,
 }
 
 void rtl8821ae_update_hal_rate_tbl(struct ieee80211_hw *hw,
-		struct ieee80211_sta *sta, u8 rssi_level)
+		struct ieee80211_sta *sta, u8 rssi_level, bool update_bw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	if (rtlpriv->dm.useramask)
-		rtl8821ae_update_hal_rate_mask(hw, sta, rssi_level);
+		rtl8821ae_update_hal_rate_mask(hw, sta, rssi_level, update_bw);
 	else
 		/*RT_TRACE(rtlpriv, COMP_RATR,DBG_LOUD,
 			   "rtl8821ae_update_hal_rate_tbl() Error! 8821ae FW RA Only\n");*/
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.h
index a3553e3abaa1..50fa9c718189 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.h
@@ -46,7 +46,7 @@ void rtl8821ae_update_interrupt_mask(struct ieee80211_hw *hw,
 void rtl8821ae_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl8821ae_update_hal_rate_tbl(struct ieee80211_hw *hw,
 				   struct ieee80211_sta *sta,
-				   u8 rssi_level);
+				   u8 rssi_level, bool update_bw);
 void rtl8821ae_update_channel_access_setting(struct ieee80211_hw *hw);
 bool rtl8821ae_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid);
 void rtl8821ae_enable_hw_security_config(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 9e1914bf014d..bb29c97a2c1f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2123,7 +2123,8 @@ struct rtl_hal_ops {
 	void (*get_hw_reg) (struct ieee80211_hw *hw, u8 variable, u8 *val);
 	void (*set_hw_reg) (struct ieee80211_hw *hw, u8 variable, u8 *val);
 	void (*update_rate_tbl) (struct ieee80211_hw *hw,
-			      struct ieee80211_sta *sta, u8 rssi_level);
+			      struct ieee80211_sta *sta, u8 rssi_leve,
+			      bool update_bw);
 	void (*pre_fill_tx_bd_desc)(struct ieee80211_hw *hw, u8 *tx_bd_desc,
 				    u8 *desc, u8 queue_index,
 				    struct sk_buff *skb, dma_addr_t addr);
-- 
2.12.3
