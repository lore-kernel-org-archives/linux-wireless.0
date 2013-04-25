Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:33050 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712Ab3DYXIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 19:08:55 -0400
Received: by mail-oa0-f52.google.com with SMTP id n12so3455663oag.11
        for <linux-wireless@vger.kernel.org>; Thu, 25 Apr 2013 16:08:55 -0700 (PDT)
Message-ID: <5179B785.7050704@lwfinger.net> (sfid-20130426_010900_104576_70EC5380)
Date: Thu, 25 Apr 2013 18:08:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Stahn <michael.stahn.42@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: Realtek 8192CU not working
References: <CALvqYaTZrtSsP9GQzH4B988KjPg+LRCcyREKZ1zkjoaEDKPHNA@mail.gmail.com> <CALvqYaTSYR43rS-pptFKCfsgvsatrUSz4v+AFBPQ0UrHC4WkXA@mail.gmail.com> <5177F100.1070803@lwfinger.net> <CALvqYaQt+nL-PxSeEUNpsG9SWV+--S64ksr1UR+8TPg5dVPKXA@mail.gmail.com> <51780C92.4000208@lwfinger.net> <CALvqYaRrjMtPE72PGR-Zzuj11CL=E6+ruC+E1wGPO3m5wgdOhg@mail.gmail.com> <CALvqYaT==e4U43dxtyX55A9CNgWh9apHMrj89=bBybutyJOoiw@mail.gmail.com> <51781976.3000601@lwfinger.net> <CALvqYaQTQ5=ER=F1-bxnJQKkFjrg6UH+1JWLexUPVZ3cFBG5UQ@mail.gmail.com> <51786303.3070107@lwfinger.net> <CALvqYaQ_z7w6yLeNb=Q7Sm=Et3Rxj+TP6vi=KcyhDpT4AmY4kA@mail.gmail.com>
In-Reply-To: <CALvqYaQ_z7w6yLeNb=Q7Sm=Et3Rxj+TP6vi=KcyhDpT4AmY4kA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030901000806060207080107"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030901000806060207080107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/24/2013 06:08 PM, Michael Stahn wrote:
> This kind of error doesn't seem to show up on the USB 2.0 interface. I
> just configured the AP for WPA+TKIP but no change. Now the Adapter
> won't connect anymore even I reload the module..pretty random error.
> I'll try some other ideas in the next days...

I found some problems today. With the attached patched, my device connects to 
WEP, WPA and WPA2 networks.

Larry



--------------030901000806060207080107
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_fix_WPA_WEP"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192cu_fix_WPA_WEP"

Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -289,14 +289,30 @@ void rtl92c_set_key(struct ieee80211_hw
 				macaddr = cam_const_broad;
 				entry_id = key_index;
 			} else {
+				if (mac->opmode == NL80211_IFTYPE_AP ||
+				    mac->opmode == NL80211_IFTYPE_MESH_POINT) {
+					entry_id = rtl_cam_get_free_entry(hw,
+								 p_macaddr);
+					if (entry_id >=  TOTAL_CAM_ENTRY) {
+						RT_TRACE(rtlpriv, COMP_SEC,
+							 DBG_EMERG,
+							 "Can not find free hw security cam entry\n");
+						return;
+					}
+				} else {
+					entry_id = CAM_PAIRWISE_KEY_POSITION;
+				}
+
 				key_index = PAIRWISE_KEYIDX;
-				entry_id = CAM_PAIRWISE_KEY_POSITION;
 				is_pairwise = true;
 			}
 		}
 		if (rtlpriv->sec.key_len[key_index] == 0) {
 			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
 				 "delete one entry\n");
+			if (mac->opmode == NL80211_IFTYPE_AP ||
+			    mac->opmode == NL80211_IFTYPE_MESH_POINT)
+				rtl_cam_del_entry(hw, p_macaddr);
 			rtl_cam_delete_one_entry(hw, p_macaddr, entry_id);
 		} else {
 			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -896,7 +896,7 @@ void rtl92cu_enable_hw_security_config(s
 	u8 sec_reg_value = 0x0;
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 		 "PairwiseEncAlgorithm = %d GroupEncAlgorithm = %d\n",
 		 rtlpriv->sec.pairwise_enc_algorithm,
 		 rtlpriv->sec.group_enc_algorithm);
@@ -913,7 +913,7 @@ void rtl92cu_enable_hw_security_config(s
 	if (IS_NORMAL_CHIP(rtlhal->version))
 		sec_reg_value |= (SCR_RXBCUSEDK | SCR_TXBCUSEDK);
 	rtl_write_byte(rtlpriv, REG_CR + 1, 0x02);
-	RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD, "The SECR-value %x\n",
+	RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, "The SECR-value %x\n",
 		 sec_reg_value);
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_WPA_CONFIG, &sec_reg_value);
 }
@@ -1973,26 +1973,35 @@ void rtl92cu_set_hw_reg(struct ieee80211
 	}
 }
 
-void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw,
-				   struct ieee80211_sta *sta,
-				   u8 rssi_level)
+static void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw,
+					  struct ieee80211_sta *sta)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	u32 ratr_value = (u32) mac->basic_rates;
-	u8 *mcsrate = mac->mcs;
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u32 ratr_value;
 	u8 ratr_index = 0;
 	u8 nmode = mac->ht_enable;
-	u8 mimo_ps = 1;
-	u16 shortgi_rate = 0;
-	u32 tmp_ratr_value = 0;
+	u8 mimo_ps = IEEE80211_SMPS_OFF;
+	u16 shortgi_rate;
+	u32 tmp_ratr_value;
 	u8 curtxbw_40mhz = mac->bw_40;
-	u8 curshortgi_40mhz = mac->sgi_40;
-	u8 curshortgi_20mhz = mac->sgi_20;
+	u8 curshortgi_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
+			       1 : 0;
+	u8 curshortgi_20mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
+			       1 : 0;
 	enum wireless_mode wirelessmode = mac->mode;
 
-	ratr_value |= ((*(u16 *) (mcsrate))) << 12;
+	if (rtlhal->current_bandtype == BAND_ON_5G)
+		ratr_value = sta->supp_rates[1] << 4;
+	else
+		ratr_value = sta->supp_rates[0];
+	if (mac->opmode == NL80211_IFTYPE_ADHOC)
+		ratr_value = 0xfff;
+
+	ratr_value |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
+			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
 	case WIRELESS_MODE_B:
 		if (ratr_value & 0x0000000c)
@@ -2006,7 +2015,7 @@ void rtl92cu_update_hal_rate_table(struc
 	case WIRELESS_MODE_N_24G:
 	case WIRELESS_MODE_N_5G:
 		nmode = 1;
-		if (mimo_ps == 0) {
+		if (mimo_ps == IEEE80211_SMPS_STATIC) {
 			ratr_value &= 0x0007F005;
 		} else {
 			u32 ratr_mask;
@@ -2016,8 +2025,7 @@ void rtl92cu_update_hal_rate_table(struc
 				ratr_mask = 0x000ff005;
 			else
 				ratr_mask = 0x0f0ff005;
-			if (curtxbw_40mhz)
-				ratr_mask |= 0x00000010;
+
 			ratr_value &= ratr_mask;
 		}
 		break;
@@ -2026,41 +2034,74 @@ void rtl92cu_update_hal_rate_table(struc
 			ratr_value &= 0x000ff0ff;
 		else
 			ratr_value &= 0x0f0ff0ff;
+
 		break;
 	}
+
 	ratr_value &= 0x0FFFFFFF;
-	if (nmode && ((curtxbw_40mhz && curshortgi_40mhz) ||
-	    (!curtxbw_40mhz && curshortgi_20mhz))) {
+
+	if (nmode && ((curtxbw_40mhz &&
+			 curshortgi_40mhz) || (!curtxbw_40mhz &&
+					       curshortgi_20mhz))) {
+
 		ratr_value |= 0x10000000;
 		tmp_ratr_value = (ratr_value >> 12);
+
 		for (shortgi_rate = 15; shortgi_rate > 0; shortgi_rate--) {
 			if ((1 << shortgi_rate) & tmp_ratr_value)
 				break;
 		}
+
 		shortgi_rate = (shortgi_rate << 12) | (shortgi_rate << 8) |
-			       (shortgi_rate << 4) | (shortgi_rate);
+		    (shortgi_rate << 4) | (shortgi_rate);
 	}
+
 	rtl_write_dword(rtlpriv, REG_ARFR0 + ratr_index * 4, ratr_value);
+
+	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG, "%x\n",
+		 rtl_read_dword(rtlpriv, REG_ARFR0));
 }
 
-void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw, u8 rssi_level)
+static void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw,
+					 struct ieee80211_sta *sta,
+					 u8 rssi_level)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	u32 ratr_bitmap = (u32) mac->basic_rates;
-	u8 *p_mcsrate = mac->mcs;
-	u8 ratr_index = 0;
-	u8 curtxbw_40mhz = mac->bw_40;
-	u8 curshortgi_40mhz = mac->sgi_40;
-	u8 curshortgi_20mhz = mac->sgi_20;
-	enum wireless_mode wirelessmode = mac->mode;
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_sta_info *sta_entry = NULL;
+	u32 ratr_bitmap;
+	u8 ratr_index;
+	u8 curtxbw_40mhz = (sta->bandwidth >= IEEE80211_STA_RX_BW_40) ? 1 : 0;
+	u8 curshortgi_40mhz = curtxbw_40mhz &&
+			      (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
+				1 : 0;
+	u8 curshortgi_20mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
+				1 : 0;
+	enum wireless_mode wirelessmode = 0;
 	bool shortgi = false;
 	u8 rate_mask[5];
 	u8 macid = 0;
-	u8 mimops = 1;
+	u8 mimo_ps = IEEE80211_SMPS_OFF;
 
-	ratr_bitmap |= (p_mcsrate[1] << 20) | (p_mcsrate[0] << 12);
+	sta_entry = (struct rtl_sta_info *) sta->drv_priv;
+	wirelessmode = sta_entry->wireless_mode;
+	if (mac->opmode == NL80211_IFTYPE_STATION ||
+	    mac->opmode == NL80211_IFTYPE_MESH_POINT)
+		curtxbw_40mhz = mac->bw_40;
+	else if (mac->opmode == NL80211_IFTYPE_AP ||
+		mac->opmode == NL80211_IFTYPE_ADHOC)
+		macid = sta->aid + 1;
+
+	if (rtlhal->current_bandtype == BAND_ON_5G)
+		ratr_bitmap = sta->supp_rates[1] << 4;
+	else
+		ratr_bitmap = sta->supp_rates[0];
+	if (mac->opmode == NL80211_IFTYPE_ADHOC)
+		ratr_bitmap = 0xfff;
+	ratr_bitmap |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
+			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
 	case WIRELESS_MODE_B:
 		ratr_index = RATR_INX_WIRELESS_B;
@@ -2071,6 +2112,7 @@ void rtl92cu_update_hal_rate_mask(struct
 		break;
 	case WIRELESS_MODE_G:
 		ratr_index = RATR_INX_WIRELESS_GB;
+
 		if (rssi_level == 1)
 			ratr_bitmap &= 0x00000f00;
 		else if (rssi_level == 2)
@@ -2085,7 +2127,8 @@ void rtl92cu_update_hal_rate_mask(struct
 	case WIRELESS_MODE_N_24G:
 	case WIRELESS_MODE_N_5G:
 		ratr_index = RATR_INX_WIRELESS_NGB;
-		if (mimops == 0) {
+
+		if (mimo_ps == IEEE80211_SMPS_STATIC) {
 			if (rssi_level == 1)
 				ratr_bitmap &= 0x00070000;
 			else if (rssi_level == 2)
@@ -2128,8 +2171,10 @@ void rtl92cu_update_hal_rate_mask(struct
 				}
 			}
 		}
+
 		if ((curtxbw_40mhz && curshortgi_40mhz) ||
 		    (!curtxbw_40mhz && curshortgi_20mhz)) {
+
 			if (macid == 0)
 				shortgi = true;
 			else if (macid == 1)
@@ -2138,21 +2183,39 @@ void rtl92cu_update_hal_rate_mask(struct
 		break;
 	default:
 		ratr_index = RATR_INX_WIRELESS_NGB;
+
 		if (rtlphy->rf_type == RF_1T2R)
 			ratr_bitmap &= 0x000ff0ff;
 		else
 			ratr_bitmap &= 0x0f0ff0ff;
 		break;
 	}
-	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG, "ratr_bitmap :%x\n",
-		 ratr_bitmap);
-	*(u32 *)&rate_mask = ((ratr_bitmap & 0x0fffffff) |
-				      ratr_index << 28);
+	sta_entry->ratr_index = ratr_index;
+
+	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
+		 "ratr_bitmap :%x\n", ratr_bitmap);
+	*(u32 *)&rate_mask = (ratr_bitmap & 0x0fffffff) |
+				     (ratr_index << 28);
 	rate_mask[4] = macid | (shortgi ? 0x20 : 0x00) | 0x80;
 	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
 		 "Rate_index:%x, ratr_val:%x, %5phC\n",
 		 ratr_index, ratr_bitmap, rate_mask);
 	rtl92c_fill_h2c_cmd(hw, H2C_RA_MASK, 5, rate_mask);
+
+	if (macid != 0)
+		sta_entry->ratr_index = ratr_index;
+}
+
+void rtl92cu_update_hal_rate_tbl(struct ieee80211_hw *hw,
+				 struct ieee80211_sta *sta,
+				 u8 rssi_level)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (rtlpriv->dm.useramask)
+		rtl92cu_update_hal_rate_mask(hw, sta, rssi_level);
+	else
+		rtl92cu_update_hal_rate_table(hw, sta);
 }
 
 void rtl92cu_update_channel_access_setting(struct ieee80211_hw *hw)
Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
@@ -98,10 +98,6 @@ void rtl92cu_update_interrupt_mask(struc
 				   u32 add_msr, u32 rm_msr);
 void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
-void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw,
-				   struct ieee80211_sta *sta,
-				   u8 rssi_level);
-void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw, u8 rssi_level);
 
 void rtl92cu_update_channel_access_setting(struct ieee80211_hw *hw);
 bool rtl92cu_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid);
Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -106,8 +106,7 @@ static struct rtl_hal_ops rtl8192cu_hal_
 	.update_interrupt_mask = rtl92cu_update_interrupt_mask,
 	.get_hw_reg = rtl92cu_get_hw_reg,
 	.set_hw_reg = rtl92cu_set_hw_reg,
-	.update_rate_tbl = rtl92cu_update_hal_rate_table,
-	.update_rate_mask = rtl92cu_update_hal_rate_mask,
+	.update_rate_tbl = rtl92cu_update_hal_rate_tbl,
 	.fill_tx_desc = rtl92cu_tx_fill_desc,
 	.fill_fake_txdesc = rtl92cu_fill_fake_txdesc,
 	.fill_tx_cmddesc = rtl92cu_tx_fill_cmddesc,
Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
@@ -49,5 +49,8 @@ bool rtl92cu_phy_set_rf_power_state(stru
 u32 rtl92cu_phy_query_rf_reg(struct ieee80211_hw *hw,
 			    enum radio_path rfpath, u32 regaddr, u32 bitmask);
 void rtl92cu_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
+void rtl92cu_update_hal_rate_tbl(struct ieee80211_hw *hw,
+				 struct ieee80211_sta *sta,
+				 u8 rssi_level);
 
 #endif

--------------030901000806060207080107--
