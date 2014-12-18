Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36414 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaLRJGC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:06:02 -0500
Received: by mail-ob0-f171.google.com with SMTP id uz6so2366029obc.2
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:06:01 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 05/16] rtlwifi: rtl8192ce: Update rate setting routines
Date: Thu, 18 Dec 2014 03:05:29 -0600
Message-Id: <1418893540-19944-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100720_938313_9E9D7D3B)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These changes were found in the latest vendor driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c | 107 ++++++++++++----------------
 1 file changed, 44 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 2ee778a..303b299 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1168,7 +1168,6 @@ static int _rtl92ce_set_media_status(struct ieee80211_hw *hw,
 	switch (type) {
 	case NL80211_IFTYPE_UNSPECIFIED:
 		mode = MSR_NOLINK;
-		ledaction = LED_CTL_LINK;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 "Set Network type to NO LINK!\n");
 		break;
@@ -1184,7 +1183,8 @@ static int _rtl92ce_set_media_status(struct ieee80211_hw *hw,
 			 "Set Network type to STA!\n");
 		break;
 	case NL80211_IFTYPE_AP:
-		bt_msr |= MSR_AP;
+		mode = MSR_AP;
+		ledaction = LED_CTL_LINK;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 "Set Network type to AP!\n");
 		break;
@@ -1222,7 +1222,7 @@ static int _rtl92ce_set_media_status(struct ieee80211_hw *hw,
 			 "Set HW_VAR_MEDIA_STATUS: No such media status(%x).\n",
 			 mode);
 	}
-	rtl_write_byte(rtlpriv, (MSR), bt_msr | mode);
+	rtl_write_byte(rtlpriv, MSR, bt_msr | mode);
 
 	rtlpriv->cfg->ops->led_control(hw, ledaction);
 	if (mode == MSR_AP)
@@ -1849,7 +1849,6 @@ static void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw,
 	u32 ratr_value;
 	u8 ratr_index = 0;
 	u8 nmode = mac->ht_enable;
-	u8 mimo_ps = IEEE80211_SMPS_OFF;
 	u16 shortgi_rate;
 	u32 tmp_ratr_value;
 	u8 curtxbw_40mhz = mac->bw_40;
@@ -1858,6 +1857,7 @@ static void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw,
 	u8 curshortgi_20mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
 			       1 : 0;
 	enum wireless_mode wirelessmode = mac->mode;
+	u32 ratr_mask;
 
 	if (rtlhal->current_bandtype == BAND_ON_5G)
 		ratr_value = sta->supp_rates[1] << 4;
@@ -1881,19 +1881,13 @@ static void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw,
 	case WIRELESS_MODE_N_24G:
 	case WIRELESS_MODE_N_5G:
 		nmode = 1;
-		if (mimo_ps == IEEE80211_SMPS_STATIC) {
-			ratr_value &= 0x0007F005;
-		} else {
-			u32 ratr_mask;
-
-			if (get_rf_type(rtlphy) == RF_1T2R ||
-			    get_rf_type(rtlphy) == RF_1T1R)
-				ratr_mask = 0x000ff005;
-			else
-				ratr_mask = 0x0f0ff005;
+		if (get_rf_type(rtlphy) == RF_1T2R ||
+		    get_rf_type(rtlphy) == RF_1T1R)
+			ratr_mask = 0x000ff005;
+		else
+			ratr_mask = 0x0f0ff005;
 
-			ratr_value &= ratr_mask;
-		}
+		ratr_value &= ratr_mask;
 		break;
 	default:
 		if (rtlphy->rf_type == RF_1T2R)
@@ -1946,17 +1940,16 @@ static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
 	struct rtl_sta_info *sta_entry = NULL;
 	u32 ratr_bitmap;
 	u8 ratr_index;
-	u8 curtxbw_40mhz = (sta->bandwidth >= IEEE80211_STA_RX_BW_40) ? 1 : 0;
-	u8 curshortgi_40mhz = curtxbw_40mhz &&
-			      (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
-				1 : 0;
+	u8 curtxbw_40mhz = (sta->ht_cap.cap &
+			    IEEE80211_HT_CAP_SUP_WIDTH_20_40) ? 1 : 0;
+	u8 curshortgi_40mhz = (sta->ht_cap.cap &
+			       IEEE80211_HT_CAP_SGI_40) ?  1 : 0;
 	u8 curshortgi_20mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
 				1 : 0;
 	enum wireless_mode wirelessmode = 0;
 	bool shortgi = false;
 	u8 rate_mask[5];
 	u8 macid = 0;
-	u8 mimo_ps = IEEE80211_SMPS_OFF;
 
 	sta_entry = (struct rtl_sta_info *) sta->drv_priv;
 	wirelessmode = sta_entry->wireless_mode;
@@ -2001,47 +1994,38 @@ static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
 	case WIRELESS_MODE_N_5G:
 		ratr_index = RATR_INX_WIRELESS_NGB;
 
-		if (mimo_ps == IEEE80211_SMPS_STATIC) {
-			if (rssi_level == 1)
-				ratr_bitmap &= 0x00070000;
-			else if (rssi_level == 2)
-				ratr_bitmap &= 0x0007f000;
-			else
-				ratr_bitmap &= 0x0007f005;
+		if (rtlphy->rf_type == RF_1T2R ||
+		    rtlphy->rf_type == RF_1T1R) {
+			if (curtxbw_40mhz) {
+				if (rssi_level == 1)
+					ratr_bitmap &= 0x000f0000;
+				else if (rssi_level == 2)
+					ratr_bitmap &= 0x000ff000;
+				else
+					ratr_bitmap &= 0x000ff015;
+			} else {
+				if (rssi_level == 1)
+					ratr_bitmap &= 0x000f0000;
+				else if (rssi_level == 2)
+					ratr_bitmap &= 0x000ff000;
+				else
+					ratr_bitmap &= 0x000ff005;
+			}
 		} else {
-			if (rtlphy->rf_type == RF_1T2R ||
-			    rtlphy->rf_type == RF_1T1R) {
-				if (curtxbw_40mhz) {
-					if (rssi_level == 1)
-						ratr_bitmap &= 0x000f0000;
-					else if (rssi_level == 2)
-						ratr_bitmap &= 0x000ff000;
-					else
-						ratr_bitmap &= 0x000ff015;
-				} else {
-					if (rssi_level == 1)
-						ratr_bitmap &= 0x000f0000;
-					else if (rssi_level == 2)
-						ratr_bitmap &= 0x000ff000;
-					else
-						ratr_bitmap &= 0x000ff005;
-				}
+			if (curtxbw_40mhz) {
+				if (rssi_level == 1)
+					ratr_bitmap &= 0x0f0f0000;
+				else if (rssi_level == 2)
+					ratr_bitmap &= 0x0f0ff000;
+				else
+					ratr_bitmap &= 0x0f0ff015;
 			} else {
-				if (curtxbw_40mhz) {
-					if (rssi_level == 1)
-						ratr_bitmap &= 0x0f0f0000;
-					else if (rssi_level == 2)
-						ratr_bitmap &= 0x0f0ff000;
-					else
-						ratr_bitmap &= 0x0f0ff015;
-				} else {
-					if (rssi_level == 1)
-						ratr_bitmap &= 0x0f0f0000;
-					else if (rssi_level == 2)
-						ratr_bitmap &= 0x0f0ff000;
-					else
-						ratr_bitmap &= 0x0f0ff005;
-				}
+				if (rssi_level == 1)
+					ratr_bitmap &= 0x0f0f0000;
+				else if (rssi_level == 2)
+					ratr_bitmap &= 0x0f0ff000;
+				else
+					ratr_bitmap &= 0x0f0ff005;
 			}
 		}
 
@@ -2074,9 +2058,6 @@ static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
 		 "Rate_index:%x, ratr_val:%x, %5phC\n",
 		 ratr_index, ratr_bitmap, rate_mask);
 	rtl92c_fill_h2c_cmd(hw, H2C_RA_MASK, 5, rate_mask);
-
-	if (macid != 0)
-		sta_entry->ratr_index = ratr_index;
 }
 
 void rtl92ce_update_hal_rate_tbl(struct ieee80211_hw *hw,
-- 
2.1.2

