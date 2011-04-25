Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671Ab1DYRxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:53:41 -0400
Date: Mon, 25 Apr 2011 12:52:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/18] rtlwifi: Change base routines for addition of
 rtl8192se and rtl8192de
Message-ID: <4db5b4f6.87VpjywxNBQZf8sj%Larry.Finger@lwfinger.net> (sfid-20110425_195351_724473_78B924C6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Change base routines for addition of RTL8192SE and RTL8192DE code.

Additional files are modified to allow compilation.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 base.c          |  727 ++++++++++++++++++++++++++++++++++++++++++++++----------
 base.h          |   61 ++++
 pci.c           |    2 
 ps.c            |    8 
 ps.h            |    7 
 rtl8192ce/trx.c |    2 
 rtl8192cu/trx.c |    2 
 usb.c           |    2 
 usb.h           |    2 
 wifi.h          |    5 
 10 files changed, 677 insertions(+), 141 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -50,8 +50,9 @@
  *3) functions called by core.c
  *4) wq & timer callback functions
  *5) frame process functions
- *6) sysfs functions
- *7) ...
+ *6) IOT functions
+ *7) sysfs functions
+ *8) ...
  */
 
 /*********************************************************
@@ -59,7 +60,7 @@
  * mac80211 init functions
  *
  *********************************************************/
-static struct ieee80211_channel rtl_channeltable[] = {
+static struct ieee80211_channel rtl_channeltable_2g[] = {
 	{.center_freq = 2412, .hw_value = 1,},
 	{.center_freq = 2417, .hw_value = 2,},
 	{.center_freq = 2422, .hw_value = 3,},
@@ -76,7 +77,34 @@ static struct ieee80211_channel rtl_chan
 	{.center_freq = 2484, .hw_value = 14,},
 };
 
-static struct ieee80211_rate rtl_ratetable[] = {
+static struct ieee80211_channel rtl_channeltable_5g[] = {
+	{.center_freq = 5180, .hw_value = 36,},
+	{.center_freq = 5200, .hw_value = 40,},
+	{.center_freq = 5220, .hw_value = 44,},
+	{.center_freq = 5240, .hw_value = 48,},
+	{.center_freq = 5260, .hw_value = 52,},
+	{.center_freq = 5280, .hw_value = 56,},
+	{.center_freq = 5300, .hw_value = 60,},
+	{.center_freq = 5320, .hw_value = 64,},
+	{.center_freq = 5500, .hw_value = 100,},
+	{.center_freq = 5520, .hw_value = 104,},
+	{.center_freq = 5540, .hw_value = 108,},
+	{.center_freq = 5560, .hw_value = 112,},
+	{.center_freq = 5580, .hw_value = 116,},
+	{.center_freq = 5600, .hw_value = 120,},
+	{.center_freq = 5620, .hw_value = 124,},
+	{.center_freq = 5640, .hw_value = 128,},
+	{.center_freq = 5660, .hw_value = 132,},
+	{.center_freq = 5680, .hw_value = 136,},
+	{.center_freq = 5700, .hw_value = 140,},
+	{.center_freq = 5745, .hw_value = 149,},
+	{.center_freq = 5765, .hw_value = 153,},
+	{.center_freq = 5785, .hw_value = 157,},
+	{.center_freq = 5805, .hw_value = 161,},
+	{.center_freq = 5825, .hw_value = 165,},
+};
+
+static struct ieee80211_rate rtl_ratetable_2g[] = {
 	{.bitrate = 10, .hw_value = 0x00,},
 	{.bitrate = 20, .hw_value = 0x01,},
 	{.bitrate = 55, .hw_value = 0x02,},
@@ -91,18 +119,57 @@ static struct ieee80211_rate rtl_ratetab
 	{.bitrate = 540, .hw_value = 0x0b,},
 };
 
+static struct ieee80211_rate rtl_ratetable_5g[] = {
+	{.bitrate = 60, .hw_value = 0x04,},
+	{.bitrate = 90, .hw_value = 0x05,},
+	{.bitrate = 120, .hw_value = 0x06,},
+	{.bitrate = 180, .hw_value = 0x07,},
+	{.bitrate = 240, .hw_value = 0x08,},
+	{.bitrate = 360, .hw_value = 0x09,},
+	{.bitrate = 480, .hw_value = 0x0a,},
+	{.bitrate = 540, .hw_value = 0x0b,},
+};
+
 static const struct ieee80211_supported_band rtl_band_2ghz = {
 	.band = IEEE80211_BAND_2GHZ,
 
-	.channels = rtl_channeltable,
-	.n_channels = ARRAY_SIZE(rtl_channeltable),
+	.channels = rtl_channeltable_2g,
+	.n_channels = ARRAY_SIZE(rtl_channeltable_2g),
 
-	.bitrates = rtl_ratetable,
-	.n_bitrates = ARRAY_SIZE(rtl_ratetable),
+	.bitrates = rtl_ratetable_2g,
+	.n_bitrates = ARRAY_SIZE(rtl_ratetable_2g),
 
 	.ht_cap = {0},
 };
 
+static struct ieee80211_supported_band rtl_band_5ghz = {
+	.band = IEEE80211_BAND_5GHZ,
+
+	.channels = rtl_channeltable_5g,
+	.n_channels = ARRAY_SIZE(rtl_channeltable_5g),
+
+	.bitrates = rtl_ratetable_5g,
+	.n_bitrates = ARRAY_SIZE(rtl_ratetable_5g),
+
+	.ht_cap = {0},
+};
+
+static const u8 tid_to_ac[] = {
+	2, /* IEEE80211_AC_BE */
+	3, /* IEEE80211_AC_BK */
+	3, /* IEEE80211_AC_BK */
+	2, /* IEEE80211_AC_BE */
+	1, /* IEEE80211_AC_VI */
+	1, /* IEEE80211_AC_VI */
+	0, /* IEEE80211_AC_VO */
+	0, /* IEEE80211_AC_VO */
+};
+
+u8 rtl_tid_to_ac(struct ieee80211_hw *hw, u8 tid)
+{
+	return tid_to_ac[tid];
+}
+
 static void _rtl_init_hw_ht_capab(struct ieee80211_hw *hw,
 				  struct ieee80211_sta_ht_cap *ht_cap)
 {
@@ -115,6 +182,9 @@ static void _rtl_init_hw_ht_capab(struct
 	    IEEE80211_HT_CAP_SGI_20 |
 	    IEEE80211_HT_CAP_DSSSCCK40 | IEEE80211_HT_CAP_MAX_AMSDU;
 
+	if (rtlpriv->rtlhal.disable_amsdu_8k)
+		ht_cap->cap &= ~IEEE80211_HT_CAP_MAX_AMSDU;
+
 	/*
 	 *Maximum length of AMPDU that the STA can receive.
 	 *Length = 2 ^ (13 + max_ampdu_length_exp) - 1 (octets)
@@ -159,37 +229,99 @@ static void _rtl_init_hw_ht_capab(struct
 
 static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	struct rtl_mac *rtlmac = rtl_mac(rtl_priv(hw));
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct ieee80211_supported_band *sband;
 
-	/* <1> use  mac->bands as mem for hw->wiphy->bands */
-	sband = &(rtlmac->bands[IEEE80211_BAND_2GHZ]);
 
-	/*
-	 * <2> set hw->wiphy->bands[IEEE80211_BAND_2GHZ]
-	 * to default value(1T1R)
-	 */
-	memcpy(&(rtlmac->bands[IEEE80211_BAND_2GHZ]), &rtl_band_2ghz,
-	       sizeof(struct ieee80211_supported_band));
+	if (rtlhal->macphymode == SINGLEMAC_SINGLEPHY && rtlhal->bandset ==
+	    BAND_ON_BOTH) {
+		/* 1: 2.4 G bands */
+		/* <1> use  mac->bands as mem for hw->wiphy->bands */
+		sband = &(rtlmac->bands[IEEE80211_BAND_2GHZ]);
+
+		/* <2> set hw->wiphy->bands[IEEE80211_BAND_2GHZ]
+		 * to default value(1T1R) */
+		memcpy(&(rtlmac->bands[IEEE80211_BAND_2GHZ]), &rtl_band_2ghz,
+				sizeof(struct ieee80211_supported_band));
+
+		/* <3> init ht cap base on ant_num */
+		_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
+
+		/* <4> set mac->sband to wiphy->sband */
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+
+		/* 2: 5 G bands */
+		/* <1> use  mac->bands as mem for hw->wiphy->bands */
+		sband = &(rtlmac->bands[IEEE80211_BAND_5GHZ]);
+
+		/* <2> set hw->wiphy->bands[IEEE80211_BAND_5GHZ]
+		 * to default value(1T1R) */
+		memcpy(&(rtlmac->bands[IEEE80211_BAND_5GHZ]), &rtl_band_5ghz,
+				sizeof(struct ieee80211_supported_band));
 
-	/* <3> init ht cap base on ant_num */
-	_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
+		/* <3> init ht cap base on ant_num */
+		_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
 
-	/* <4> set mac->sband to wiphy->sband */
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+		/* <4> set mac->sband to wiphy->sband */
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
+	} else {
+		if (rtlhal->current_bandtype == BAND_ON_2_4G) {
+			/* <1> use  mac->bands as mem for hw->wiphy->bands */
+			sband = &(rtlmac->bands[IEEE80211_BAND_2GHZ]);
+
+			/* <2> set hw->wiphy->bands[IEEE80211_BAND_2GHZ]
+			 * to default value(1T1R) */
+			memcpy(&(rtlmac->bands[IEEE80211_BAND_2GHZ]),
+				 &rtl_band_2ghz,
+				 sizeof(struct ieee80211_supported_band));
+
+			/* <3> init ht cap base on ant_num */
+			_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
+
+			/* <4> set mac->sband to wiphy->sband */
+			hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+		} else if (rtlhal->current_bandtype == BAND_ON_5G) {
+			/* <1> use  mac->bands as mem for hw->wiphy->bands */
+			sband = &(rtlmac->bands[IEEE80211_BAND_5GHZ]);
+
+			/* <2> set hw->wiphy->bands[IEEE80211_BAND_5GHZ]
+			 * to default value(1T1R) */
+			memcpy(&(rtlmac->bands[IEEE80211_BAND_5GHZ]),
+				 &rtl_band_5ghz,
+				 sizeof(struct ieee80211_supported_band));
 
+			/* <3> init ht cap base on ant_num */
+			_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
+
+			/* <4> set mac->sband to wiphy->sband */
+			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
+		} else {
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
+				 ("Err BAND %d\n",
+				 rtlhal->current_bandtype));
+		}
+	}
 	/* <5> set hw caps */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_RX_INCLUDES_FCS |
-	    IEEE80211_HW_BEACON_FILTER | IEEE80211_HW_AMPDU_AGGREGATION | /*PS*/
-	    /*IEEE80211_HW_SUPPORTS_PS | */
-	    /*IEEE80211_HW_PS_NULLFUNC_STACK | */
-	    /*IEEE80211_HW_SUPPORTS_DYNAMIC_PS | */
+	    IEEE80211_HW_BEACON_FILTER |
+	    IEEE80211_HW_AMPDU_AGGREGATION |
 	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | 0;
 
+	/* swlps or hwlps has been set in diff chip in init_sw_vars */
+	if (rtlpriv->psc.swctrl_lps)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
+			IEEE80211_HW_PS_NULLFUNC_STACK |
+			/* IEEE80211_HW_SUPPORTS_DYNAMIC_PS | */
+			0;
+
 	hw->wiphy->interface_modes =
-	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
+	    BIT(NL80211_IFTYPE_AP) |
+	    BIT(NL80211_IFTYPE_STATION) |
+	    BIT(NL80211_IFTYPE_ADHOC);
 
 	hw->wiphy->rts_threshold = 2347;
 
@@ -199,9 +331,10 @@ static void _rtl_init_mac80211(struct ie
 	/* TODO: Correct this value for our hw */
 	/* TODO: define these hard code value */
 	hw->channel_change_time = 100;
-	hw->max_listen_interval = 5;
+	hw->max_listen_interval = 10;
 	hw->max_rate_tries = 4;
 	/* hw->max_rates = 1; */
+	hw->sta_data_size = sizeof(struct rtl_sta_info);
 
 	/* <6> mac address */
 	if (is_valid_ether_addr(rtlefuse->dev_addr)) {
@@ -230,6 +363,10 @@ static void _rtl_init_deferred_work(stru
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
 			  (void *)rtl_ips_nic_off_wq_callback);
+	INIT_DELAYED_WORK(&rtlpriv->works.ps_work,
+			  (void *)rtl_swlps_wq_callback);
+	INIT_DELAYED_WORK(&rtlpriv->works.ps_rfon_wq,
+			  (void *)rtl_swlps_rfon_wq_callback);
 
 }
 
@@ -241,6 +378,8 @@ void rtl_deinit_deferred_work(struct iee
 
 	cancel_delayed_work(&rtlpriv->works.watchdog_wq);
 	cancel_delayed_work(&rtlpriv->works.ips_nic_off_wq);
+	cancel_delayed_work(&rtlpriv->works.ps_work);
+	cancel_delayed_work(&rtlpriv->works.ps_rfon_wq);
 }
 
 void rtl_init_rfkill(struct ieee80211_hw *hw)
@@ -310,6 +449,8 @@ int rtl_init_core(struct ieee80211_hw *h
 	spin_lock_init(&rtlpriv->locks.rf_ps_lock);
 	spin_lock_init(&rtlpriv->locks.rf_lock);
 	spin_lock_init(&rtlpriv->locks.lps_lock);
+	spin_lock_init(&rtlpriv->locks.waitq_lock);
+	spin_lock_init(&rtlpriv->locks.cck_and_rw_pagea_lock);
 
 	rtlmac->link_state = MAC80211_NOLINK;
 
@@ -329,12 +470,6 @@ void rtl_init_rx_config(struct ieee80211
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
 	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RCR, (u8 *) (&mac->rx_conf));
-	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_MGT_FILTER,
-				      (u8 *) (&mac->rx_mgt_filter));
-	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_CTRL_FILTER,
-				      (u8 *) (&mac->rx_ctrl_filter));
-	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_DATA_FILTER,
-				      (u8 *) (&mac->rx_data_filter));
 }
 
 /*********************************************************
@@ -361,28 +496,40 @@ static void _rtl_qurey_shortpreamble_mod
 }
 
 static void _rtl_query_shortgi(struct ieee80211_hw *hw,
+			       struct ieee80211_sta *sta,
 			       struct rtl_tcb_desc *tcb_desc,
 			       struct ieee80211_tx_info *info)
 {
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	u8 rate_flag = info->control.rates[0].flags;
-
+	u8 sgi_40 = 0, sgi_20 = 0, bw_40 = 0;
 	tcb_desc->use_shortgi = false;
 
-	if (!mac->ht_enable)
+	if (sta == NULL)
 		return;
 
-	if (!mac->sgi_40 && !mac->sgi_20)
+	sgi_40 = sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40;
+	sgi_20 = sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20;
+
+	if (!(sta->ht_cap.ht_supported))
 		return;
 
-	if ((mac->bw_40 == true) && mac->sgi_40)
+	if (!sgi_40 && !sgi_20)
+		return;
+
+	if (mac->opmode == NL80211_IFTYPE_STATION)
+		bw_40 = mac->bw_40;
+	else if (mac->opmode == NL80211_IFTYPE_AP ||
+		mac->opmode == NL80211_IFTYPE_ADHOC)
+		bw_40 = sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+
+	if ((bw_40 == true) && sgi_40)
 		tcb_desc->use_shortgi = true;
-	else if ((mac->bw_40 == false) && mac->sgi_20)
+	else if ((bw_40 == false) && sgi_20)
 		tcb_desc->use_shortgi = true;
 
 	if (!(rate_flag & IEEE80211_TX_RC_SHORT_GI))
 		tcb_desc->use_shortgi = false;
-
 }
 
 static void _rtl_query_protection_mode(struct ieee80211_hw *hw,
@@ -410,19 +557,25 @@ static void _rtl_query_protection_mode(s
 		tcb_desc->rts_enable = true;
 		tcb_desc->rts_rate = rtlpriv->cfg->maps[RTL_RC_OFDM_RATE24M];
 	}
-
 }
 
 static void _rtl_txrate_selectmode(struct ieee80211_hw *hw,
+				   struct ieee80211_sta *sta,
 				   struct rtl_tcb_desc *tcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_sta_info *sta_entry = NULL;
+	u8 ratr_index = 7;
 
+	if (sta) {
+		sta_entry = (struct rtl_sta_info *) sta->drv_priv;
+		ratr_index = sta_entry->ratr_index;
+	}
 	if (!tcb_desc->disable_ratefallback || !tcb_desc->use_driver_rate) {
-		if (mac->opmode == NL80211_IFTYPE_STATION)
+		if (mac->opmode == NL80211_IFTYPE_STATION) {
 			tcb_desc->ratr_index = 0;
-		else if (mac->opmode == NL80211_IFTYPE_ADHOC) {
+		} else if (mac->opmode == NL80211_IFTYPE_ADHOC) {
 			if (tcb_desc->multicast || tcb_desc->broadcast) {
 				tcb_desc->hw_rate =
 				    rtlpriv->cfg->maps[RTL_RC_CCK_RATE2M];
@@ -430,36 +583,61 @@ static void _rtl_txrate_selectmode(struc
 			} else {
 				/* TODO */
 			}
+			tcb_desc->ratr_index = ratr_index;
+		} else if (mac->opmode == NL80211_IFTYPE_AP) {
+			tcb_desc->ratr_index = ratr_index;
 		}
 	}
 
 	if (rtlpriv->dm.useramask) {
-		/* TODO adhoc and station handled differently in the future */
-		tcb_desc->mac_id = 0;
-
-		if ((mac->mode == WIRELESS_MODE_N_24G) ||
-		    (mac->mode == WIRELESS_MODE_N_5G)) {
-			tcb_desc->ratr_index = RATR_INX_WIRELESS_NGB;
-		} else if (mac->mode & WIRELESS_MODE_G) {
-			tcb_desc->ratr_index = RATR_INX_WIRELESS_GB;
-		} else if (mac->mode & WIRELESS_MODE_B) {
-			tcb_desc->ratr_index = RATR_INX_WIRELESS_B;
+		/* TODO we will differentiate adhoc and station futrue  */
+		if (mac->opmode == NL80211_IFTYPE_STATION) {
+			tcb_desc->mac_id = 0;
+
+			if (mac->mode == WIRELESS_MODE_N_24G)
+				tcb_desc->ratr_index = RATR_INX_WIRELESS_NGB;
+			else if (mac->mode == WIRELESS_MODE_N_5G)
+				tcb_desc->ratr_index = RATR_INX_WIRELESS_NG;
+			else if (mac->mode & WIRELESS_MODE_G)
+				tcb_desc->ratr_index = RATR_INX_WIRELESS_GB;
+			else if (mac->mode & WIRELESS_MODE_B)
+				tcb_desc->ratr_index = RATR_INX_WIRELESS_B;
+			else if (mac->mode & WIRELESS_MODE_A)
+				tcb_desc->ratr_index = RATR_INX_WIRELESS_G;
+		} else if (mac->opmode == NL80211_IFTYPE_AP ||
+			mac->opmode == NL80211_IFTYPE_ADHOC) {
+			if (NULL != sta) {
+				if (sta->aid > 0)
+					tcb_desc->mac_id = sta->aid + 1;
+				else
+					tcb_desc->mac_id = 1;
+			} else {
+				tcb_desc->mac_id = 0;
+			}
 		}
 	}
 
 }
 
 static void _rtl_query_bandwidth_mode(struct ieee80211_hw *hw,
+				      struct ieee80211_sta *sta,
 				      struct rtl_tcb_desc *tcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
 	tcb_desc->packet_bw = false;
-
-	if (!mac->bw_40 || !mac->ht_enable)
+	if (!sta)
 		return;
-
+	if (mac->opmode == NL80211_IFTYPE_AP ||
+	    mac->opmode == NL80211_IFTYPE_ADHOC) {
+		if (!(sta->ht_cap.ht_supported) ||
+		    !(sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
+			return;
+	} else if (mac->opmode == NL80211_IFTYPE_STATION) {
+		if (!mac->bw_40 || !(sta->ht_cap.ht_supported))
+			return;
+	}
 	if (tcb_desc->multicast || tcb_desc->broadcast)
 		return;
 
@@ -486,22 +664,21 @@ static u8 _rtl_get_highest_n_rate(struct
 
 void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 		      struct ieee80211_tx_info *info,
+		      struct ieee80211_sta *sta,
 		      struct sk_buff *skb, struct rtl_tcb_desc *tcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *rtlmac = rtl_mac(rtl_priv(hw));
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
+	struct ieee80211_hdr *hdr = rtl_get_hdr(skb);
 	struct ieee80211_rate *txrate;
 	__le16 fc = hdr->frame_control;
 
-	memset(tcb_desc, 0, sizeof(struct rtl_tcb_desc));
+	txrate = ieee80211_get_tx_rate(hw, info);
+	tcb_desc->hw_rate = txrate->hw_value;
 
 	if (ieee80211_is_data(fc)) {
-		txrate = ieee80211_get_tx_rate(hw, info);
-		tcb_desc->hw_rate = txrate->hw_value;
-
 		/*
-		 *we set data rate RTL_RC_CCK_RATE1M
+		 *we set data rate INX 0
 		 *in rtl_rc.c   if skb is special data or
 		 *mgt which need low data rate.
 		 */
@@ -510,12 +687,11 @@ void rtl_get_tcb_desc(struct ieee80211_h
 		 *So tcb_desc->hw_rate is just used for
 		 *special data and mgt frames
 		 */
-		if (tcb_desc->hw_rate < rtlpriv->cfg->maps[RTL_RC_CCK_RATE11M]) {
+		if (info->control.rates[0].idx == 0 &&
+				ieee80211_is_nullfunc(fc)) {
 			tcb_desc->use_driver_rate = true;
-			tcb_desc->ratr_index = 7;
+			tcb_desc->ratr_index = RATR_INX_WIRELESS_MC;
 
-			tcb_desc->hw_rate =
-			    rtlpriv->cfg->maps[RTL_RC_CCK_RATE1M];
 			tcb_desc->disable_ratefallback = 1;
 		} else {
 			/*
@@ -525,7 +701,7 @@ void rtl_get_tcb_desc(struct ieee80211_h
 			 *and N rate will all be controlled by FW
 			 *when tcb_desc->use_driver_rate = false
 			 */
-			if (rtlmac->ht_enable) {
+			if (sta && (sta->ht_cap.ht_supported)) {
 				tcb_desc->hw_rate = _rtl_get_highest_n_rate(hw);
 			} else {
 				if (rtlmac->mode == WIRELESS_MODE_B) {
@@ -543,43 +719,25 @@ void rtl_get_tcb_desc(struct ieee80211_h
 		else if (is_broadcast_ether_addr(ieee80211_get_DA(hdr)))
 			tcb_desc->broadcast = 1;
 
-		_rtl_txrate_selectmode(hw, tcb_desc);
-		_rtl_query_bandwidth_mode(hw, tcb_desc);
+		_rtl_txrate_selectmode(hw, sta, tcb_desc);
+		_rtl_query_bandwidth_mode(hw, sta, tcb_desc);
 		_rtl_qurey_shortpreamble_mode(hw, tcb_desc, info);
-		_rtl_query_shortgi(hw, tcb_desc, info);
+		_rtl_query_shortgi(hw, sta, tcb_desc, info);
 		_rtl_query_protection_mode(hw, tcb_desc, info);
 	} else {
 		tcb_desc->use_driver_rate = true;
-		tcb_desc->ratr_index = 7;
+		tcb_desc->ratr_index = RATR_INX_WIRELESS_MC;
 		tcb_desc->disable_ratefallback = 1;
 		tcb_desc->mac_id = 0;
-
-		tcb_desc->hw_rate = rtlpriv->cfg->maps[RTL_RC_CCK_RATE1M];
+		tcb_desc->packet_bw = false;
 	}
 }
 EXPORT_SYMBOL(rtl_get_tcb_desc);
 
-bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	__le16 fc = hdr->frame_control;
-
-	if (ieee80211_is_auth(fc)) {
-		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, ("MAC80211_LINKING\n"));
-		rtl_ips_nic_on(hw);
-
-		mac->link_state = MAC80211_LINKING;
-	}
-
-	return true;
-}
-
 bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 {
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
+	struct ieee80211_hdr *hdr = rtl_get_hdr(skb);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	__le16 fc = hdr->frame_control;
 	u8 *act = (u8 *) (((u8 *) skb->data + MAC80211_3ADDR_LEN));
@@ -624,9 +782,8 @@ bool rtl_action_proc(struct ieee80211_hw
 u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	__le16 fc = hdr->frame_control;
+	__le16 fc = rtl_get_fc(skb);
 	u16 ether_type;
 	u8 mac_hdr_len = ieee80211_get_hdrlen_from_skb(skb);
 	const struct iphdr *ip;
@@ -634,12 +791,11 @@ u8 rtl_is_special_data(struct ieee80211_
 	if (!ieee80211_is_data(fc))
 		return false;
 
-	if (ieee80211_is_nullfunc(fc))
-		return true;
 
 	ip = (struct iphdr *)((u8 *) skb->data + mac_hdr_len +
 			      SNAP_SIZE + PROTOC_TYPE_SIZE);
 	ether_type = *(u16 *) ((u8 *) skb->data + mac_hdr_len + SNAP_SIZE);
+	ether_type = ntohs(ether_type);
 
 	if (ETH_P_IP == ether_type) {
 		if (IPPROTO_UDP == ip->protocol) {
@@ -696,61 +852,92 @@ u8 rtl_is_special_data(struct ieee80211_
  * functions called by core.c
  *
  *********************************************************/
-int rtl_tx_agg_start(struct ieee80211_hw *hw, const u8 *ra, u16 tid, u16 *ssn)
+int rtl_tx_agg_start(struct ieee80211_hw *hw,
+		struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_tid_data *tid_data;
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_sta_info *sta_entry = NULL;
 
-	RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG,
-		 ("on ra = %pM tid = %d\n", ra, tid));
+	if (sta == NULL)
+		return -EINVAL;
 
 	if (unlikely(tid >= MAX_TID_COUNT))
 		return -EINVAL;
 
-	if (mac->tids[tid].agg.agg_state != RTL_AGG_OFF) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-			 ("Start AGG when state is not RTL_AGG_OFF !\n"));
+	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
+	if (!sta_entry)
 		return -ENXIO;
-	}
-
-	tid_data = &mac->tids[tid];
-	*ssn = SEQ_TO_SN(tid_data->seq_number);
+	tid_data = &sta_entry->tids[tid];
 
 	RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG,
-		 ("HW queue is empty tid:%d\n", tid));
-	tid_data->agg.agg_state = RTL_AGG_ON;
+		 ("on ra = %pM tid = %d seq:%d\n", sta->addr, tid,
+		 tid_data->seq_number));
+
+	*ssn = tid_data->seq_number;
+	tid_data->agg.agg_state = RTL_AGG_START;
 
-	ieee80211_start_tx_ba_cb_irqsafe(mac->vif, ra, tid);
+	ieee80211_start_tx_ba_cb_irqsafe(mac->vif, sta->addr, tid);
 
 	return 0;
 }
 
-int rtl_tx_agg_stop(struct ieee80211_hw *hw, const u8 * ra, u16 tid)
+int rtl_tx_agg_stop(struct ieee80211_hw *hw,
+		struct ieee80211_sta *sta, u16 tid)
 {
-	int ssn = -1;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_tid_data *tid_data;
+	struct rtl_sta_info *sta_entry = NULL;
 
-	if (!ra) {
+	if (sta == NULL)
+		return -EINVAL;
+
+	if (!sta->addr) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("ra = NULL\n"));
 		return -EINVAL;
 	}
 
+	RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG,
+		 ("on ra = %pM tid = %d\n", sta->addr, tid));
+
 	if (unlikely(tid >= MAX_TID_COUNT))
 		return -EINVAL;
 
-	if (mac->tids[tid].agg.agg_state != RTL_AGG_ON)
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-			 ("Stopping AGG while state not ON or starting\n"));
+	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
+	tid_data = &sta_entry->tids[tid];
+	sta_entry->tids[tid].agg.agg_state = RTL_AGG_STOP;
 
-	tid_data = &mac->tids[tid];
-	ssn = (tid_data->seq_number & IEEE80211_SCTL_SEQ) >> 4;
+	ieee80211_stop_tx_ba_cb_irqsafe(mac->vif, sta->addr, tid);
 
-	mac->tids[tid].agg.agg_state = RTL_AGG_OFF;
+	return 0;
+}
 
-	ieee80211_stop_tx_ba_cb_irqsafe(mac->vif, ra, tid);
+int rtl_tx_agg_oper(struct ieee80211_hw *hw,
+		struct ieee80211_sta *sta, u16 tid)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_tid_data *tid_data;
+	struct rtl_sta_info *sta_entry = NULL;
+
+	if (sta == NULL)
+		return -EINVAL;
+
+	if (!sta->addr) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("ra = NULL\n"));
+		return -EINVAL;
+	}
+
+	RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG,
+		 ("on ra = %pM tid = %d\n", sta->addr, tid));
+
+	if (unlikely(tid >= MAX_TID_COUNT))
+		return -EINVAL;
+
+	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
+	tid_data = &sta_entry->tids[tid];
+	sta_entry->tids[tid].agg.agg_state = RTL_AGG_OPERATIONAL;
 
 	return 0;
 }
@@ -769,18 +956,16 @@ void rtl_watchdog_wq_callback(void *data
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-
 	bool busytraffic = false;
 	bool higher_busytraffic = false;
 	bool higher_busyrxtraffic = false;
-	bool higher_busytxtraffic = false;
-
-	u8 idx = 0;
+	u8 idx, tid;
 	u32 rx_cnt_inp4eriod = 0;
 	u32 tx_cnt_inp4eriod = 0;
 	u32 aver_rx_cnt_inperiod = 0;
 	u32 aver_tx_cnt_inperiod = 0;
-
+	u32 aver_tidtx_inperiod[MAX_TID_COUNT] = {0};
+	u32 tidtx_inp4eriod[MAX_TID_COUNT] = {0};
 	bool enter_ps = false;
 
 	if (is_hal_stop(rtlhal))
@@ -794,9 +979,6 @@ void rtl_watchdog_wq_callback(void *data
 		mac->cnt_after_linked = 0;
 	}
 
-	/* <2> DM */
-	rtlpriv->cfg->ops->dm_watchdog(hw);
-
 	/*
 	 *<3> to check if traffic busy, if
 	 * busytraffic we don't change channel
@@ -835,8 +1017,27 @@ void rtl_watchdog_wq_callback(void *data
 			/* Extremely high Rx data. */
 			if (aver_rx_cnt_inperiod > 5000)
 				higher_busyrxtraffic = true;
+		}
+
+		/* check every tid's tx traffic */
+		for (tid = 0; tid <= 7; tid++) {
+			for (idx = 0; idx <= 2; idx++)
+				rtlpriv->link_info.tidtx_in4period[tid][idx] =
+				  rtlpriv->link_info.tidtx_in4period[tid]
+				  [idx + 1];
+			rtlpriv->link_info.tidtx_in4period[tid][3] =
+				rtlpriv->link_info.tidtx_inperiod[tid];
+
+			for (idx = 0; idx <= 3; idx++)
+				tidtx_inp4eriod[tid] +=
+				  rtlpriv->link_info.tidtx_in4period[tid][idx];
+			aver_tidtx_inperiod[tid] = tidtx_inp4eriod[tid] / 4;
+			if (aver_tidtx_inperiod[tid] > 5000)
+				rtlpriv->link_info.higher_busytxtraffic[tid] =
+						   true;
 			else
-				higher_busytxtraffic = false;
+				rtlpriv->link_info.higher_busytxtraffic[tid] =
+						   false;
 		}
 
 		if (((rtlpriv->link_info.num_rx_inperiod +
@@ -855,11 +1056,15 @@ void rtl_watchdog_wq_callback(void *data
 
 	rtlpriv->link_info.num_rx_inperiod = 0;
 	rtlpriv->link_info.num_tx_inperiod = 0;
+	for (tid = 0; tid <= 7; tid++)
+		rtlpriv->link_info.tidtx_inperiod[tid] = 0;
 
 	rtlpriv->link_info.busytraffic = busytraffic;
 	rtlpriv->link_info.higher_busytraffic = higher_busytraffic;
 	rtlpriv->link_info.higher_busyrxtraffic = higher_busyrxtraffic;
 
+	/* <3> DM */
+	rtlpriv->cfg->ops->dm_watchdog(hw);
 }
 
 void rtl_watch_dog_timer_callback(unsigned long data)
@@ -876,6 +1081,274 @@ void rtl_watch_dog_timer_callback(unsign
 
 /*********************************************************
  *
+ * frame process functions
+ *
+ *********************************************************/
+u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie)
+{
+	struct ieee80211_mgmt *mgmt = (void *)data;
+	u8 *pos, *end;
+
+	pos = (u8 *)mgmt->u.beacon.variable;
+	end = data + len;
+	while (pos < end) {
+		if (pos + 2 + pos[1] > end)
+			return NULL;
+
+		if (pos[0] == ie)
+			return pos;
+
+		pos += 2 + pos[1];
+	}
+	return NULL;
+}
+
+/* when we use 2 rx ants we send IEEE80211_SMPS_OFF */
+/* when we use 1 rx ant we send IEEE80211_SMPS_STATIC */
+struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
+		enum ieee80211_smps_mode smps, u8 *da, u8 *bssid)
+{
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *action_frame;
+
+	/* 27 = header + category + action + smps mode */
+	skb = dev_alloc_skb(27 + hw->extra_tx_headroom);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, hw->extra_tx_headroom);
+	action_frame = (void *)skb_put(skb, 27);
+	memset(action_frame, 0, 27);
+	memcpy(action_frame->da, da, ETH_ALEN);
+	memcpy(action_frame->sa, rtlefuse->dev_addr, ETH_ALEN);
+	memcpy(action_frame->bssid, bssid, ETH_ALEN);
+	action_frame->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						  IEEE80211_STYPE_ACTION);
+	action_frame->u.action.category = WLAN_CATEGORY_HT;
+	action_frame->u.action.u.ht_smps.action = WLAN_HT_ACTION_SMPS;
+	switch (smps) {
+	case IEEE80211_SMPS_AUTOMATIC:/* 0 */
+	case IEEE80211_SMPS_NUM_MODES:/* 4 */
+		WARN_ON(1);
+	case IEEE80211_SMPS_OFF:/* 1 */ /*MIMO_PS_NOLIMIT*/
+		action_frame->u.action.u.ht_smps.smps_control =
+				WLAN_HT_SMPS_CONTROL_DISABLED;/* 0 */
+		break;
+	case IEEE80211_SMPS_STATIC:/* 2 */ /*MIMO_PS_STATIC*/
+		action_frame->u.action.u.ht_smps.smps_control =
+				WLAN_HT_SMPS_CONTROL_STATIC;/* 1 */
+		break;
+	case IEEE80211_SMPS_DYNAMIC:/* 3 */ /*MIMO_PS_DYNAMIC*/
+		action_frame->u.action.u.ht_smps.smps_control =
+				WLAN_HT_SMPS_CONTROL_DYNAMIC;/* 3 */
+		break;
+	}
+
+	return skb;
+}
+
+int rtl_send_smps_action(struct ieee80211_hw *hw,
+		struct ieee80211_sta *sta, u8 *da, u8 *bssid,
+		enum ieee80211_smps_mode smps)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct sk_buff *skb = rtl_make_smps_action(hw, smps, da, bssid);
+	struct rtl_tcb_desc tcb_desc;
+	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
+
+	if (rtlpriv->mac80211.act_scanning)
+		goto err_free;
+
+	if (!sta)
+		goto err_free;
+
+	if (unlikely(is_hal_stop(rtlhal) || ppsc->rfpwr_state != ERFON))
+		goto err_free;
+
+	if (!test_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status))
+		goto err_free;
+
+	/* this is a type = mgmt * stype = action frame */
+	if (skb) {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+		struct rtl_sta_info *sta_entry =
+			(struct rtl_sta_info *) sta->drv_priv;
+		sta_entry->mimo_ps = smps;
+		rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
+
+		info->control.rates[0].idx = 0;
+		info->control.sta = sta;
+		info->band = hw->conf.channel->band;
+#if 0
+		rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
+#else
+		rtlpriv->intf_ops->adapter_tx(hw, skb);
+#endif
+	}
+	return 1;
+
+err_free:
+	return 0;
+}
+
+/*********************************************************
+ *
+ * IOT functions
+ *
+ *********************************************************/
+static bool rtl_chk_vendor_ouisub(struct ieee80211_hw *hw,
+		struct octet_string vendor_ie)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	bool matched = false;
+	static u8 athcap_1[] = { 0x00, 0x03, 0x7F };
+	static u8 athcap_2[] = { 0x00, 0x13, 0x74 };
+	static u8 broadcap_1[] = { 0x00, 0x10, 0x18 };
+	static u8 broadcap_2[] = { 0x00, 0x0a, 0xf7 };
+	static u8 broadcap_3[] = { 0x00, 0x05, 0xb5 };
+	static u8 racap[] = { 0x00, 0x0c, 0x43 };
+	static u8 ciscocap[] = { 0x00, 0x40, 0x96 };
+	static u8 marvcap[] = { 0x00, 0x50, 0x43 };
+
+	if (memcmp(vendor_ie.octet, athcap_1, 3) == 0 ||
+		memcmp(vendor_ie.octet, athcap_2, 3) == 0) {
+		rtlpriv->mac80211.vendor = PEER_ATH;
+		matched = true;
+	} else if (memcmp(vendor_ie.octet, broadcap_1, 3) == 0 ||
+		memcmp(vendor_ie.octet, broadcap_2, 3) == 0 ||
+		memcmp(vendor_ie.octet, broadcap_3, 3) == 0) {
+		rtlpriv->mac80211.vendor = PEER_BROAD;
+		matched = true;
+	} else if (memcmp(vendor_ie.octet, racap, 3) == 0) {
+		rtlpriv->mac80211.vendor = PEER_RAL;
+		matched = true;
+	} else if (memcmp(vendor_ie.octet, ciscocap, 3) == 0) {
+		rtlpriv->mac80211.vendor = PEER_CISCO;
+		matched = true;
+	} else if (memcmp(vendor_ie.octet, marvcap, 3) == 0) {
+		rtlpriv->mac80211.vendor = PEER_MARV;
+		matched = true;
+	}
+
+	return matched;
+}
+
+bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
+		unsigned int len)
+{
+	struct ieee80211_mgmt *mgmt = (void *)data;
+	struct octet_string vendor_ie;
+	u8 *pos, *end;
+
+	pos = (u8 *)mgmt->u.beacon.variable;
+	end = data + len;
+	while (pos < end) {
+		if (pos[0] == 221) {
+			vendor_ie.length = pos[1];
+			vendor_ie.octet = &pos[2];
+			if (rtl_chk_vendor_ouisub(hw, vendor_ie))
+				return true;
+		}
+
+		if (pos + 2 + pos[1] > end)
+			return false;
+
+		pos += 2 + pos[1];
+	}
+	return false;
+}
+
+void rtl_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct ieee80211_hdr *hdr = (void *)data;
+	u32 vendor = PEER_UNKNOWN;
+
+	static u8 ap3_1[3] = { 0x00, 0x14, 0xbf };
+	static u8 ap3_2[3] = { 0x00, 0x1a, 0x70 };
+	static u8 ap3_3[3] = { 0x00, 0x1d, 0x7e };
+	static u8 ap4_1[3] = { 0x00, 0x90, 0xcc };
+	static u8 ap4_2[3] = { 0x00, 0x0e, 0x2e };
+	static u8 ap4_3[3] = { 0x00, 0x18, 0x02 };
+	static u8 ap4_4[3] = { 0x00, 0x17, 0x3f };
+	static u8 ap4_5[3] = { 0x00, 0x1c, 0xdf };
+	static u8 ap5_1[3] = { 0x00, 0x1c, 0xf0 };
+	static u8 ap5_2[3] = { 0x00, 0x21, 0x91 };
+	static u8 ap5_3[3] = { 0x00, 0x24, 0x01 };
+	static u8 ap5_4[3] = { 0x00, 0x15, 0xe9 };
+	static u8 ap5_5[3] = { 0x00, 0x17, 0x9A };
+	static u8 ap5_6[3] = { 0x00, 0x18, 0xE7 };
+	static u8 ap6_1[3] = { 0x00, 0x17, 0x94 };
+	static u8 ap7_1[3] = { 0x00, 0x14, 0xa4 };
+
+	if (mac->opmode != NL80211_IFTYPE_STATION)
+		return;
+
+	if (mac->link_state == MAC80211_NOLINK) {
+		mac->vendor = PEER_UNKNOWN;
+		return;
+	}
+
+	if (mac->cnt_after_linked > 2)
+		return;
+
+	/* check if this really is a beacon */
+	if (!ieee80211_is_beacon(hdr->frame_control))
+		return;
+
+	/* min. beacon length + FCS_LEN */
+	if (len <= 40 + FCS_LEN)
+		return;
+
+	/* and only beacons from the associated BSSID, please */
+	if (compare_ether_addr(hdr->addr3, rtlpriv->mac80211.bssid))
+		return;
+
+	if (rtl_find_221_ie(hw, data, len))
+		vendor = mac->vendor;
+
+	if ((memcmp(mac->bssid, ap5_1, 3) == 0) ||
+		(memcmp(mac->bssid, ap5_2, 3) == 0) ||
+		(memcmp(mac->bssid, ap5_3, 3) == 0) ||
+		(memcmp(mac->bssid, ap5_4, 3) == 0) ||
+		(memcmp(mac->bssid, ap5_5, 3) == 0) ||
+		(memcmp(mac->bssid, ap5_6, 3) == 0) ||
+		vendor == PEER_ATH) {
+		vendor = PEER_ATH;
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>ath find\n"));
+	} else if ((memcmp(mac->bssid, ap4_4, 3) == 0) ||
+		(memcmp(mac->bssid, ap4_5, 3) == 0) ||
+		(memcmp(mac->bssid, ap4_1, 3) == 0) ||
+		(memcmp(mac->bssid, ap4_2, 3) == 0) ||
+		(memcmp(mac->bssid, ap4_3, 3) == 0) ||
+		vendor == PEER_RAL) {
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>ral findn\n"));
+		vendor = PEER_RAL;
+	} else if (memcmp(mac->bssid, ap6_1, 3) == 0 ||
+		vendor == PEER_CISCO) {
+		vendor = PEER_CISCO;
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>cisco find\n"));
+	} else if ((memcmp(mac->bssid, ap3_1, 3) == 0) ||
+		(memcmp(mac->bssid, ap3_2, 3) == 0) ||
+		(memcmp(mac->bssid, ap3_3, 3) == 0) ||
+		vendor == PEER_BROAD) {
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>broad find\n"));
+		vendor = PEER_BROAD;
+	} else if (memcmp(mac->bssid, ap7_1, 3) == 0 ||
+		vendor == PEER_MARV) {
+		vendor = PEER_MARV;
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("=>marv find\n"));
+	}
+
+	mac->vendor = vendor;
+}
+
+/*********************************************************
+ *
  * sysfs functions
  *
  *********************************************************/
@@ -941,14 +1414,16 @@ static int __init rtl_core_module_init(v
 	if (rtl_rate_control_register())
 		printk(KERN_ERR "rtlwifi: Unable to register rtl_rc,"
 		       "use default RC !!\n");
+
 	return 0;
 }
 
 static void __exit rtl_core_module_exit(void)
 {
-	 /*RC*/
+	/*RC*/
 	rtl_rate_control_unregister();
 }
 
 module_init(rtl_core_module_init);
 module_exit(rtl_core_module_exit);
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/base.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.h
@@ -24,13 +24,26 @@
  * Hsinchu 300, Taiwan.
  *
  * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #ifndef __RTL_BASE_H__
 #define __RTL_BASE_H__
 
+enum ap_peer {
+	PEER_UNKNOWN = 0,
+	PEER_RTL = 1,
+	PEER_RTL_92SE = 2,
+	PEER_BROAD = 3,
+	PEER_RAL = 4,
+	PEER_ATH = 5,
+	PEER_CISCO = 6,
+	PEER_MARV = 7,
+	PEER_AIRGO = 9,
+	PEER_MAX = 10,
+} ;
+
 #define RTL_DUMMY_OFFSET	0
-#define RTL_RX_DESC_SIZE	24
 #define RTL_DUMMY_UNIT		8
 #define RTL_TX_DUMMY_SIZE	(RTL_DUMMY_OFFSET * RTL_DUMMY_UNIT)
 #define RTL_TX_DESC_SIZE	32
@@ -53,6 +66,14 @@
 #define FRAME_OFFSET_SEQUENCE		22
 #define FRAME_OFFSET_ADDRESS4		24
 
+#define SET_80211_HDR_FRAME_CONTROL(_hdr, _val)		\
+	WRITEEF2BYTE(_hdr, _val)
+#define SET_80211_HDR_TYPE_AND_SUBTYPE(_hdr, _val)	\
+	WRITEEF1BYTE(_hdr, _val)
+#define SET_80211_HDR_PWR_MGNT(_hdr, _val)		\
+	SET_BITS_TO_LE_2BYTE(_hdr, 12, 1, _val)
+#define SET_80211_HDR_TO_DS(_hdr, _val)			\
+	SET_BITS_TO_LE_2BYTE(_hdr, 8, 1, _val)
 
 #define SET_80211_PS_POLL_AID(_hdr, _val)		\
 	(*(u16 *)((u8 *)(_hdr) + 2) = le16_to_cpu(_val))
@@ -64,11 +85,27 @@
 #define SET_80211_HDR_DURATION(_hdr, _val)	\
 	(*(u16 *)((u8 *)(_hdr) + FRAME_OFFSET_DURATION) = le16_to_cpu(_val))
 #define SET_80211_HDR_ADDRESS1(_hdr, _val)	\
-	memcpy((u8 *)(_hdr)+FRAME_OFFSET_ADDRESS1, (u8*)(_val), ETH_ALEN)
+	CP_MACADDR((u8 *)(_hdr)+FRAME_OFFSET_ADDRESS1, (u8 *)(_val))
 #define SET_80211_HDR_ADDRESS2(_hdr, _val)	\
-	memcpy((u8 *)(_hdr) + FRAME_OFFSET_ADDRESS2, (u8 *)(_val), ETH_ALEN)
+	CP_MACADDR((u8 *)(_hdr)+FRAME_OFFSET_ADDRESS2, (u8 *)(_val))
 #define SET_80211_HDR_ADDRESS3(_hdr, _val)	\
-	memcpy((u8 *)(_hdr)+FRAME_OFFSET_ADDRESS3, (u8 *)(_val), ETH_ALEN)
+	CP_MACADDR((u8 *)(_hdr)+FRAME_OFFSET_ADDRESS3, (u8 *)(_val))
+#define SET_80211_HDR_FRAGMENT_SEQUENCE(_hdr, _val)  \
+	WRITEEF2BYTE((u8 *)(_hdr)+FRAME_OFFSET_SEQUENCE, _val)
+
+#define SET_BEACON_PROBE_RSP_TIME_STAMP_LOW(__phdr, __val)	\
+	WRITEEF4BYTE(((u8 *)(__phdr)) + 24, __val)
+#define SET_BEACON_PROBE_RSP_TIME_STAMP_HIGH(__phdr, __val) \
+	WRITEEF4BYTE(((u8 *)(__phdr)) + 28, __val)
+#define SET_BEACON_PROBE_RSP_BEACON_INTERVAL(__phdr, __val) \
+	WRITEEF2BYTE(((u8 *)(__phdr)) + 32, __val)
+#define GET_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr)		\
+	READEF2BYTE(((u8 *)(__phdr)) + 34)
+#define SET_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr, __val) \
+	WRITEEF2BYTE(((u8 *)(__phdr)) + 34, __val)
+#define MASK_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr, __val) \
+	SET_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr, \
+	(GET_BEACON_PROBE_RSP_CAPABILITY_INFO(__phdr) & (~(__val))))
 
 int rtl_init_core(struct ieee80211_hw *hw);
 void rtl_deinit_core(struct ieee80211_hw *hw);
@@ -80,18 +117,28 @@ void rtl_watch_dog_timer_callback(unsign
 void rtl_deinit_deferred_work(struct ieee80211_hw *hw);
 
 bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx);
-bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb);
 u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx);
 
 void rtl_watch_dog_timer_callback(unsigned long data);
-int rtl_tx_agg_start(struct ieee80211_hw *hw, const u8 *ra,
+int rtl_tx_agg_start(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		     u16 tid, u16 *ssn);
-int rtl_tx_agg_stop(struct ieee80211_hw *hw, const u8 *ra, u16 tid);
+int rtl_tx_agg_stop(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+		    u16 tid);
+int rtl_tx_agg_oper(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+		    u16 tid);
 void rtl_watchdog_wq_callback(void *data);
 
 void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 		      struct ieee80211_tx_info *info,
+		      struct ieee80211_sta *sta,
 		      struct sk_buff *skb, struct rtl_tcb_desc *tcb_desc);
 
+int rtl_send_smps_action(struct ieee80211_hw *hw,
+		struct ieee80211_sta *sta, u8 *da, u8 *bssid,
+		enum ieee80211_smps_mode smps);
+u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie);
+void rtl_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len);
+u8 rtl_tid_to_ac(struct ieee80211_hw *hw, u8 tid);
 extern struct attribute_group rtl_attribute_group;
 #endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.h
@@ -40,4 +40,11 @@ void rtl_ips_nic_on(struct ieee80211_hw
 void rtl_ips_nic_off_wq_callback(void *data);
 void rtl_lps_enter(struct ieee80211_hw *hw);
 void rtl_lps_leave(struct ieee80211_hw *hw);
+
+void rtl_swlps_beacon(struct ieee80211_hw *hw, void *data, unsigned int len);
+void rtl_swlps_wq_callback(void *data);
+void rtl_swlps_rfon_wq_callback(void *data);
+void rtl_swlps_rf_awake(struct ieee80211_hw *hw);
+void rtl_swlps_rf_sleep(struct ieee80211_hw *hw);
+
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -1242,8 +1242,6 @@ static int rtl_pci_tx(struct ieee80211_h
 	u8 own;
 	u8 temp_one = 1;
 
-	if (ieee80211_is_mgmt(fc))
-		rtl_tx_mgmt_proc(hw, skb);
 	rtl_action_proc(hw, skb, true);
 
 	queue_index = skb_get_queue_mapping(skb);
Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.c
@@ -416,6 +416,14 @@ static void rtl_lps_set_psmode(struct ie
 	}
 }
 
+void rtl_swlps_rfon_wq_callback(void *data)
+{
+}
+
+void rtl_swlps_wq_callback(void *data)
+{
+}
+
 /*Enter the leisure power save mode.*/
 void rtl_lps_enter(struct ieee80211_hw *hw)
 {
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -754,7 +754,7 @@ void rtl92ce_tx_fill_desc(struct ieee802
 
 	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
 
-	rtl_get_tcb_desc(hw, info, skb, &tcb_desc);
+	rtl_get_tcb_desc(hw, info, sta, skb, &tcb_desc);
 
 	CLEAR_PCI_TX_DESC_CONTENT(pdesc, sizeof(struct tx_desc_92c));
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -517,7 +517,7 @@ void rtl92cu_tx_fill_desc(struct ieee802
 	u8 *txdesc;
 
 	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
-	rtl_get_tcb_desc(hw, info, skb, &tcb_desc);
+	rtl_get_tcb_desc(hw, info, sta, skb, &tcb_desc);
 	txdesc = (u8 *)skb_push(skb, RTL_TX_HEADER_SIZE);
 	memset(txdesc, 0, RTL_TX_HEADER_SIZE);
 	SET_TX_DESC_PKT_SIZE(txdesc, pktlen);
Index: wireless-testing/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/usb.c
@@ -860,8 +860,6 @@ static void _rtl_usb_tx_preprocess(struc
 	u8 tid = 0;
 	u16 seq_number = 0;
 
-	if (ieee80211_is_mgmt(fc))
-		rtl_tx_mgmt_proc(hw, skb);
 	rtl_action_proc(hw, skb, true);
 	if (is_multicast_ether_addr(pda_addr))
 		rtlpriv->stats.txbytesmulticast += skb->len;
Index: wireless-testing/drivers/net/wireless/rtlwifi/usb.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/usb.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/usb.h
@@ -31,6 +31,8 @@
 #include <linux/usb.h>
 #include <linux/skbuff.h>
 
+#define RTL_RX_DESC_SIZE		24
+
 #define RTL_USB_DEVICE(vend, prod, cfg) \
 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE, \
 	.idVendor = (vend), \
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -1370,10 +1370,11 @@ struct rtl_hal_ops {
 				       u32 add_msr, u32 rm_msr);
 	void (*get_hw_reg) (struct ieee80211_hw *hw, u8 variable, u8 *val);
 	void (*set_hw_reg) (struct ieee80211_hw *hw, u8 variable, u8 *val);
-#if 0	/* temporary */
+#if 1	/* temporary */
 	void (*update_rate_tbl) (struct ieee80211_hw *hw,
 			      struct ieee80211_sta *sta, u8 rssi_level);
-#else
+#endif
+#if 1	/* temporary */
 	void (*update_rate_table) (struct ieee80211_hw *hw);
 #endif
 	void (*update_rate_mask) (struct ieee80211_hw *hw, u8 rssi_level);
