Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab1A2SMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jan 2011 13:12:44 -0500
Received: by iyj18 with SMTP id 18so3580400iyj.19
        for <linux-wireless@vger.kernel.org>; Sat, 29 Jan 2011 10:12:42 -0800 (PST)
From: Larry.Finger@lwfinger.net
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	zhaoming_li <chaoming_li@realsil.com.cn>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi: rtl8192ce: Modify core for inclusion of additional drivers
Date: Sat, 29 Jan 2011 12:12:41 -0600
Message-Id: <1296324761-14158-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: zhaoming_li <chaoming_li@realsil.com.cn>

Driver rtlwifi was designed to provide a common core for several drivers.
Three of these are now nearing completion. These changes revise the core
to handle them, and revise rtl8192ce to work with those changes.

Signed-off-by: zhaoming_li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.39 material.

Unfortunately, this is a much larger patch than I would like, but the
changes are substantial. I tried to keep any white-space changes to a
minimum. My attempts to split the patch into separate pieces resulted
in compilation errors, which would break bisection.

FYI, the new drivers in the pipeline are (1) rtl8192cu for the RTL8192CU
USB device, (2) rtl8192se for the RTL8191SE PCIe device, and (3) rtl8192de
for the RTL8192DE PCIe device. The USB driver is ready to go now. Code
for the others is merged and should be ready in the next week.

Larry
---

 drivers/net/wireless/rtlwifi/base.c          |  438 ++++++++++++---
 drivers/net/wireless/rtlwifi/base.h          |   20 +
 drivers/net/wireless/rtlwifi/cam.c           |   43 +-
 drivers/net/wireless/rtlwifi/cam.h           |    2 +
 drivers/net/wireless/rtlwifi/core.c          |  192 ++++--
 drivers/net/wireless/rtlwifi/core.h          |    1 +
 drivers/net/wireless/rtlwifi/debug.c         |  833 +++++++++++++++++++++++++-
 drivers/net/wireless/rtlwifi/debug.h         |   33 +-
 drivers/net/wireless/rtlwifi/efuse.c         |   88 ++-
 drivers/net/wireless/rtlwifi/efuse.h         |   19 +-
 drivers/net/wireless/rtlwifi/pci.c           |  526 +++++++++++------
 drivers/net/wireless/rtlwifi/pci.h           |   22 +-
 drivers/net/wireless/rtlwifi/ps.c            |  248 +++++++-
 drivers/net/wireless/rtlwifi/ps.h            |   10 +
 drivers/net/wireless/rtlwifi/rc.c            |   45 +-
 drivers/net/wireless/rtlwifi/rc.h            |    8 +
 drivers/net/wireless/rtlwifi/regd.c          |  103 +++-
 drivers/net/wireless/rtlwifi/regd.h          |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.c  |  378 +++++++++++-
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h  |   25 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/fw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |  357 ++++++++---
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h  |   12 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/led.c |    2 -
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c |   59 +--
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.h |   73 +--
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |   99 +++-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.h  |    3 +
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |   75 ++--
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h |    3 +-
 drivers/net/wireless/rtlwifi/wifi.h          |  487 +++++++++++++--
 31 files changed, 3415 insertions(+), 793 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index cf0b73e..4f0c7d0 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
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
@@ -76,7 +77,34 @@ static struct ieee80211_channel rtl_channeltable[] = {
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
@@ -91,14 +119,37 @@ static struct ieee80211_rate rtl_ratetable[] = {
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
+
+	.ht_cap = {0},
+};
+
+static struct ieee80211_supported_band rtl_band_5ghz = {
+	.band = IEEE80211_BAND_5GHZ,
+
+	.channels = rtl_channeltable_5g,
+	.n_channels = ARRAY_SIZE(rtl_channeltable_5g),
+
+	.bitrates = rtl_ratetable_5g,
+	.n_bitrates = ARRAY_SIZE(rtl_ratetable_5g),
 
 	.ht_cap = {0},
 };
@@ -115,6 +166,9 @@ static void _rtl_init_hw_ht_capab(struct ieee80211_hw *hw,
 	    IEEE80211_HT_CAP_SGI_20 |
 	    IEEE80211_HT_CAP_DSSSCCK40 | IEEE80211_HT_CAP_MAX_AMSDU;
 
+	if (rtlpriv->rtlhal.disable_amsdu_8k)
+		ht_cap->cap &= ~IEEE80211_HT_CAP_MAX_AMSDU;
+
 	/*
 	 *Maximum length of AMPDU that the STA can receive.
 	 *Length = 2 ^ (13 + max_ampdu_length_exp) - 1 (octets)
@@ -159,35 +213,94 @@ static void _rtl_init_hw_ht_capab(struct ieee80211_hw *hw,
 
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
+	if (rtlhal->macphymode == SINGLEMAC_SINGLEPHY &&
+	    rtlhal->bandset == BAND_ON_BOTH) {
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
 
-	/* <3> init ht cap base on ant_num */
-	_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
+		/* 2: 5 G bands */
+		/* <1> use  mac->bands as mem for hw->wiphy->bands */
+		sband = &(rtlmac->bands[IEEE80211_BAND_5GHZ]);
 
-	/* <4> set mac->sband to wiphy->sband */
-	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
+		/* <2> set hw->wiphy->bands[IEEE80211_BAND_5GHZ]
+		 * to default value(1T1R) */
+		memcpy(&(rtlmac->bands[IEEE80211_BAND_5GHZ]), &rtl_band_5ghz,
+				sizeof(struct ieee80211_supported_band));
 
+		/* <3> init ht cap base on ant_num */
+		_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
+
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
+			       &rtl_band_2ghz,
+			       sizeof(struct ieee80211_supported_band));
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
+			       &rtl_band_5ghz,
+			       sizeof(struct ieee80211_supported_band));
+
+			/* <3> init ht cap base on ant_num */
+			_rtl_init_hw_ht_capab(hw, &sband->ht_cap);
+
+			/* <4> set mac->sband to wiphy->sband */
+			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
+		} else {
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
+				 ("Err BAND %d\n", rtlhal->current_bandtype));
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
+	if (rtlpriv->psc.b_swctrl_lps)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
+			IEEE80211_HW_PS_NULLFUNC_STACK |
+			/* IEEE80211_HW_SUPPORTS_DYNAMIC_PS | */
+			0;
+
 	hw->wiphy->interface_modes =
 	    BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
 
@@ -199,7 +312,7 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	/* TODO: Correct this value for our hw */
 	/* TODO: define these hard code value */
 	hw->channel_change_time = 100;
-	hw->max_listen_interval = 5;
+	hw->max_listen_interval = 10;
 	hw->max_rate_tries = 4;
 	/* hw->max_rates = 1; */
 
@@ -230,6 +343,10 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
 			  (void *)rtl_ips_nic_off_wq_callback);
+	INIT_DELAYED_WORK(&rtlpriv->works.ps_work,
+			  (void *)rtl_swlps_wq_callback);
+	INIT_DELAYED_WORK(&rtlpriv->works.ps_rfon_wq,
+			  (void *)rtl_swlps_rfon_wq_callback);
 
 }
 
@@ -241,6 +358,8 @@ void rtl_deinit_deferred_work(struct ieee80211_hw *hw)
 
 	cancel_delayed_work(&rtlpriv->works.watchdog_wq);
 	cancel_delayed_work(&rtlpriv->works.ips_nic_off_wq);
+	cancel_delayed_work(&rtlpriv->works.ps_work);
+	cancel_delayed_work(&rtlpriv->works.ps_rfon_wq);
 }
 
 void rtl_init_rfkill(struct ieee80211_hw *hw)
@@ -251,15 +370,18 @@ void rtl_init_rfkill(struct ieee80211_hw *hw)
 	bool blocked;
 	u8 valid = 0;
 
-	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
+	/*1. set init state to on */
+	rtlpriv->rfkill.rfkill_state = 1;
+	wiphy_rfkill_set_hw_state(hw->wiphy, 0);
 
-	/*set init state to that of switch */
-	rtlpriv->rfkill.rfkill_state = radio_state;
-	printk(KERN_INFO "rtlwifi: wireless switch is %s\n",
-	       rtlpriv->rfkill.rfkill_state ? "on" : "off");
+	/*2. check gpio for rf state */
+	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
 
+	/*3. if valid, change state based on gpio */
 	if (valid) {
 		rtlpriv->rfkill.rfkill_state = radio_state;
+		printk(KERN_INFO "rtlwifi: wireless switch is %s\n",
+		       rtlpriv->rfkill.rfkill_state ? "on" : "off");
 
 		blocked = (rtlpriv->rfkill.rfkill_state == 1) ? 0 : 1;
 		wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
@@ -283,13 +405,7 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	rtlmac->hw = hw;
 
 	/* <2> rate control register */
-	if (rtl_rate_control_register()) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("rtl: Unable to register rtl_rc,"
-			  "use default RC !!\n"));
-	} else {
-		hw->rate_control_algorithm = "rtl_rc";
-	}
+	hw->rate_control_algorithm = "rtl_rc";
 
 	/*
 	 * <3> init CRDA must come after init
@@ -314,6 +430,9 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	spin_lock_init(&rtlpriv->locks.rf_ps_lock);
 	spin_lock_init(&rtlpriv->locks.rf_lock);
 	spin_lock_init(&rtlpriv->locks.lps_lock);
+	spin_lock_init(&rtlpriv->locks.waitq_lock);
+	spin_lock_init(&rtlpriv->locks.cck_and_rw_pagea_lock);
+	spin_lock_init(&rtlpriv->locks.tx_urb_lock);
 
 	rtlmac->link_state = MAC80211_NOLINK;
 
@@ -325,8 +444,6 @@ int rtl_init_core(struct ieee80211_hw *hw)
 
 void rtl_deinit_core(struct ieee80211_hw *hw)
 {
-	 /*RC*/
-	rtl_rate_control_unregister();
 }
 
 void rtl_init_rx_config(struct ieee80211_hw *hw)
@@ -335,12 +452,6 @@ void rtl_init_rx_config(struct ieee80211_hw *hw)
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
@@ -416,7 +527,6 @@ static void _rtl_query_protection_mode(struct ieee80211_hw *hw,
 		tcb_desc->b_rts_enable = true;
 		tcb_desc->rts_rate = rtlpriv->cfg->maps[RTL_RC_OFDM_RATE24M];
 	}
-
 }
 
 static void _rtl_txrate_selectmode(struct ieee80211_hw *hw,
@@ -443,14 +553,16 @@ static void _rtl_txrate_selectmode(struct ieee80211_hw *hw,
 		/* TODO we will differentiate adhoc and station futrue  */
 		tcb_desc->mac_id = 0;
 
-		if ((mac->mode == WIRELESS_MODE_N_24G) ||
-		    (mac->mode == WIRELESS_MODE_N_5G)) {
+		if (mac->mode == WIRELESS_MODE_N_24G)
 			tcb_desc->ratr_index = RATR_INX_WIRELESS_NGB;
-		} else if (mac->mode & WIRELESS_MODE_G) {
+		else if (mac->mode == WIRELESS_MODE_N_5G)
+			tcb_desc->ratr_index = RATR_INX_WIRELESS_NG;
+		else if (mac->mode & WIRELESS_MODE_G)
 			tcb_desc->ratr_index = RATR_INX_WIRELESS_GB;
-		} else if (mac->mode & WIRELESS_MODE_B) {
+		else if (mac->mode & WIRELESS_MODE_B)
 			tcb_desc->ratr_index = RATR_INX_WIRELESS_B;
-		}
+		else if (mac->mode & WIRELESS_MODE_A)
+			tcb_desc->ratr_index = RATR_INX_WIRELESS_G;
 	}
 
 }
@@ -500,14 +612,12 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 	struct ieee80211_rate *txrate;
 	u16 fc = le16_to_cpu(hdr->frame_control);
 
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
@@ -516,12 +626,10 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 		 *So tcb_desc->hw_rate is just used for
 		 *special data and mgt frames
 		 */
-		if (tcb_desc->hw_rate < rtlpriv->cfg->maps[RTL_RC_CCK_RATE11M]) {
+		if (info->control.rates[0].idx == 0) {
 			tcb_desc->use_driver_rate = true;
-			tcb_desc->ratr_index = 7;
+			tcb_desc->ratr_index = RATR_INX_WIRELESS_MC;
 
-			tcb_desc->hw_rate =
-			    rtlpriv->cfg->maps[RTL_RC_CCK_RATE1M];
 			tcb_desc->disable_ratefallback = 1;
 		} else {
 			/*
@@ -536,10 +644,12 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 			} else {
 				if (rtlmac->mode == WIRELESS_MODE_B) {
 					tcb_desc->hw_rate =
-					   rtlpriv->cfg->maps[RTL_RC_CCK_RATE11M];
+					   rtlpriv->cfg->maps
+					   [RTL_RC_CCK_RATE11M];
 				} else {
 					tcb_desc->hw_rate =
-					   rtlpriv->cfg->maps[RTL_RC_OFDM_RATE54M];
+					   rtlpriv->cfg->maps
+					   [RTL_RC_OFDM_RATE54M];
 				}
 			}
 		}
@@ -556,11 +666,10 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 		_rtl_query_protection_mode(hw, tcb_desc, info);
 	} else {
 		tcb_desc->use_driver_rate = true;
-		tcb_desc->ratr_index = 7;
+		tcb_desc->ratr_index = RATR_INX_WIRELESS_MC;
 		tcb_desc->disable_ratefallback = 1;
 		tcb_desc->mac_id = 0;
-
-		tcb_desc->hw_rate = rtlpriv->cfg->maps[RTL_RC_CCK_RATE1M];
+		tcb_desc->b_packet_bw = false;
 	}
 }
 EXPORT_SYMBOL(rtl_get_tcb_desc);
@@ -577,6 +686,9 @@ bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb)
 		rtl_ips_nic_on(hw);
 
 		mac->link_state = MAC80211_LINKING;
+		/* Dul mac */
+		rtlpriv->phy.b_need_iqk = true;
+
 	}
 
 	return true;
@@ -801,9 +913,6 @@ void rtl_watchdog_wq_callback(void *data)
 		mac->cnt_after_linked = 0;
 	}
 
-	/* <2> DM */
-	rtlpriv->cfg->ops->dm_watchdog(hw);
-
 	/*
 	 *<3> to check if traffic busy, if
 	 * busytraffic we don't change channel
@@ -836,7 +945,7 @@ void rtl_watchdog_wq_callback(void *data)
 
 		/* Higher Tx/Rx data. */
 		if (aver_rx_cnt_inperiod > 4000 ||
-		    aver_tx_cnt_inperiod > 4000) {
+			aver_tx_cnt_inperiod > 4000) {
 			b_higher_busytraffic = true;
 
 			/* Extremely high Rx data. */
@@ -867,6 +976,8 @@ void rtl_watchdog_wq_callback(void *data)
 	rtlpriv->link_info.b_higher_busytraffic = b_higher_busytraffic;
 	rtlpriv->link_info.b_higher_busyrxtraffic = b_higher_busyrxtraffic;
 
+	/* <3> DM */
+	rtlpriv->cfg->ops->dm_watchdog(hw);
 }
 
 void rtl_watch_dog_timer_callback(unsigned long data)
@@ -883,6 +994,180 @@ void rtl_watch_dog_timer_callback(unsigned long data)
 
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
+static bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
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
@@ -910,7 +1195,7 @@ static ssize_t rtl_store_debug_level(struct device *d,
 	} else {
 		rtlpriv->dbg.global_debuglevel = val;
 		printk(KERN_DEBUG "debuglevel:%x\n",
-		       rtlpriv->dbg.global_debuglevel);
+			rtlpriv->dbg.global_debuglevel);
 	}
 
 	return strnlen(buf, count);
@@ -945,12 +1230,25 @@ MODULE_DESCRIPTION("Realtek 802.11n PCI wireless core");
 
 static int __init rtl_core_module_init(void)
 {
+	if (rtl_rate_control_register())
+		printk(KERN_DEBUG "rtl: Unable to register rtl_rc,"
+			  "use default RC !!\n");
+
+	/* add proc for debug */
+	rtl_proc_add_topdir();
+
 	return 0;
 }
 
 static void __exit rtl_core_module_exit(void)
 {
+	/*RC*/
+	rtl_rate_control_unregister();
+
+	/* add proc for debug */
+	rtl_proc_remove_topdir();
 }
 
 module_init(rtl_core_module_init);
 module_exit(rtl_core_module_exit);
+
diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index 3de5a14..ea51372 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -24,16 +24,32 @@
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
+#define RTL_RX_DESC_SIZE	24
 #define RTL_DUMMY_UNIT		8
 #define RTL_TX_DUMMY_SIZE	(RTL_DUMMY_OFFSET * RTL_DUMMY_UNIT)
 #define RTL_TX_DESC_SIZE	32
 #define RTL_TX_HEADER_SIZE	(RTL_TX_DESC_SIZE + RTL_TX_DUMMY_SIZE)
+#define RX_DRV_INFO_SIZE_UNIT	8
 
 #define HT_AMSDU_SIZE_4K	3839
 #define HT_AMSDU_SIZE_8K	7935
@@ -116,5 +132,9 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 		      struct ieee80211_tx_info *info,
 		      struct sk_buff *skb, struct rtl_tcb_desc *tcb_desc);
 
+u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie);
+void rtl_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len);
+
 extern struct attribute_group rtl_attribute_group;
 #endif
+
diff --git a/drivers/net/wireless/rtlwifi/cam.c b/drivers/net/wireless/rtlwifi/cam.c
index 52c9c13..f423b25 100644
--- a/drivers/net/wireless/rtlwifi/cam.c
+++ b/drivers/net/wireless/rtlwifi/cam.c
@@ -23,6 +23,8 @@
  * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
  * Hsinchu 300, Taiwan.
  *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #include "wifi.h"
@@ -49,7 +51,7 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 	u32 target_content = 0;
 	u8 entry_i;
 
-	RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+	RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
 		 ("key_cont_128:\n %x:%x:%x:%x:%x:%x\n",
 		  key_cont_128[0], key_cont_128[1],
 		  key_cont_128[2], key_cont_128[3],
@@ -68,15 +70,13 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 			rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM],
 					target_command);
 
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("rtl_cam_program_entry(): "
-				  "WRITE %x: %x\n",
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 ("WRITE %x: %x\n",
 				  rtlpriv->cfg->maps[WCAMI], target_content));
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
 				 ("The Key ID is %d\n", entry_no));
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("rtl_cam_program_entry(): "
-				  "WRITE %x: %x\n",
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 ("WRITE %x: %x\n",
 				  rtlpriv->cfg->maps[RWCAM], target_command));
 
 		} else if (entry_i == 1) {
@@ -91,12 +91,10 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 			rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM],
 					target_command);
 
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("rtl_cam_program_entry(): WRITE A4: %x\n",
-				  target_content));
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("rtl_cam_program_entry(): WRITE A0: %x\n",
-				  target_command));
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 ("WRITE A4: %x\n", target_content));
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 ("WRITE A0: %x\n", target_command));
 
 		} else {
 
@@ -113,16 +111,14 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 					target_command);
 			udelay(100);
 
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("rtl_cam_program_entry(): WRITE A4: %x\n",
-				  target_content));
-			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("rtl_cam_program_entry(): WRITE A0: %x\n",
-				  target_command));
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 ("WRITE A4: %x\n", target_content));
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
+				 ("WRITE A0: %x\n", target_command));
 		}
 	}
 
-	RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+	RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
 		 ("after set key, usconfig:%x\n", us_config));
 }
 
@@ -145,11 +141,10 @@ u8 rtl_cam_add_one_entry(struct ieee80211_hw *hw, u8 *mac_addr,
 		return 0;
 	}
 
-	if (ul_default_key == 1) {
+	if (ul_default_key == 1)
 		us_config = CFG_VALID | ((u16) (ul_enc_alg) << 2);
-	} else {
+	else
 		us_config = CFG_VALID | ((ul_enc_alg) << 2) | ul_key_id;
-	}
 
 	rtl_cam_program_entry(hw, ul_entry_idx, mac_addr,
 			      (u8 *) key_content, us_config);
diff --git a/drivers/net/wireless/rtlwifi/cam.h b/drivers/net/wireless/rtlwifi/cam.h
index dd82f05..6b4d1ca 100644
--- a/drivers/net/wireless/rtlwifi/cam.h
+++ b/drivers/net/wireless/rtlwifi/cam.h
@@ -23,6 +23,8 @@
  * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
  * Hsinchu 300, Taiwan.
  *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #ifndef __RTL_CAM_H_
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 25d2d66..f597933 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -24,6 +24,7 @@
  * Hsinchu 300, Taiwan.
  *
  * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #include "wifi.h"
@@ -48,6 +49,7 @@ static int rtl_op_start(struct ieee80211_hw *hw)
 	if (err)
 		goto out;
 	rtl_watch_dog_timer_callback((unsigned long)hw);
+
 out:
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
 	return err;
@@ -72,6 +74,7 @@ static void rtl_op_stop(struct ieee80211_hw *hw)
 
 	mac->link_state = MAC80211_NOLINK;
 	memset(mac->bssid, 0, 6);
+	mac->vendor = PEER_UNKNOWN;
 
 	/*reset sec info */
 	rtl_cam_reset_sec_info(hw);
@@ -87,6 +90,8 @@ static int rtl_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_tcb_desc tcb_desc;
+	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 
 	if (unlikely(is_hal_stop(rtlhal) || ppsc->rfpwr_state != ERFON))
 		goto err_free;
@@ -94,8 +99,8 @@ static int rtl_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (!test_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status))
 		goto err_free;
 
-
-	rtlpriv->intf_ops->adapter_tx(hw, skb);
+	if (!rtlpriv->intf_ops->waitq_insert(hw, skb))
+		rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
 
 	return NETDEV_TX_OK;
 
@@ -137,6 +142,10 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 
 		mac->link_state = MAC80211_LINKED;
 		rtlpriv->cfg->ops->set_bcn_reg(hw);
+		mac->basic_rates = 0xfff;
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
+				(u8 *) (&mac->basic_rates));
+
 		break;
 	case NL80211_IFTYPE_AP:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
@@ -187,6 +196,7 @@ static void rtl_op_remove_interface(struct ieee80211_hw *hw,
 	mac->vif = NULL;
 	mac->link_state = MAC80211_NOLINK;
 	memset(mac->bssid, 0, 6);
+	mac->vendor = PEER_UNKNOWN;
 	mac->opmode = NL80211_IFTYPE_UNSPECIFIED;
 	rtlpriv->cfg->ops->set_network_type(hw, mac->opmode);
 
@@ -203,7 +213,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 
 	mutex_lock(&rtlpriv->locks.conf_mutex);
-	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {	/*BIT(2)*/
+	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {	/* BIT(2) */
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 			 ("IEEE80211_CONF_CHANGE_LISTEN_INTERVAL\n"));
 	}
@@ -225,10 +235,25 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	/*For LPS */
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
-		if (conf->flags & IEEE80211_CONF_PS)
-			rtl_lps_enter(hw);
-		else
-			rtl_lps_leave(hw);
+		cancel_delayed_work(&rtlpriv->works.ps_work);
+		cancel_delayed_work(&rtlpriv->works.ps_rfon_wq);
+		if (conf->flags & IEEE80211_CONF_PS) {
+			rtlpriv->psc.sw_ps_enabled = true;
+			/* sleep here is must, or we may recv the beacon and
+			 * cause mac80211 into wrong ps state, this will cause
+			 * power save nullfunc send fail, and further cause
+			 * pkt loss, So sleep must quickly but not immediatly
+			 * because that will cause nullfunc send by mac80211
+			 * fail, and cause pkt loss, we have tested that 5mA
+			 * is worked very well */
+			if (!rtlpriv->psc.multi_buffered)
+				queue_delayed_work(rtlpriv->works.rtl_wq,
+						   &rtlpriv->works.ps_work,
+						   MSECS(5));
+		} else {
+			rtl_swlps_rf_awake(hw);
+			rtlpriv->psc.sw_ps_enabled = false;
+		}
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
@@ -238,8 +263,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		mac->retry_long = hw->conf.long_frame_max_tx_count;
 		mac->retry_short = hw->conf.long_frame_max_tx_count;
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
-					      (u8 *) (&hw->conf.
-						      long_frame_max_tx_count));
+				(u8 *) (&hw->conf.long_frame_max_tx_count));
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
@@ -260,15 +284,14 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		case NL80211_CHAN_NO_HT:
 			/* SC */
 			mac->cur_40_prime_sc =
-			    PRIME_CHNL_OFFSET_DONT_CARE;
+				PRIME_CHNL_OFFSET_DONT_CARE;
 			rtlphy->current_chan_bw = HT_CHANNEL_WIDTH_20;
 			mac->bw_40 = false;
 			break;
 		case NL80211_CHAN_HT40MINUS:
 			/* SC */
 			mac->cur_40_prime_sc = PRIME_CHNL_OFFSET_UPPER;
-			rtlphy->current_chan_bw =
-			    HT_CHANNEL_WIDTH_20_40;
+			rtlphy->current_chan_bw = HT_CHANNEL_WIDTH_20_40;
 			mac->bw_40 = true;
 
 			/*wide channel */
@@ -278,8 +301,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		case NL80211_CHAN_HT40PLUS:
 			/* SC */
 			mac->cur_40_prime_sc = PRIME_CHNL_OFFSET_LOWER;
-			rtlphy->current_chan_bw =
-			    HT_CHANNEL_WIDTH_20_40;
+			rtlphy->current_chan_bw = HT_CHANNEL_WIDTH_20_40;
 			mac->bw_40 = true;
 
 			/*wide channel */
@@ -289,7 +311,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		default:
 			mac->bw_40 = false;
 			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 ("switch case not processed\n"));
+					("switch case not processed\n"));
 			break;
 		}
 
@@ -297,10 +319,10 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 			wide_chan = 1;
 		rtlphy->current_channel = wide_chan;
 
-		rtlpriv->cfg->ops->set_channel_access(hw);
 		rtlpriv->cfg->ops->switch_channel(hw);
+		rtlpriv->cfg->ops->set_channel_access(hw);
 		rtlpriv->cfg->ops->set_bw_mode(hw,
-					       hw->conf.channel_type);
+			hw->conf.channel_type);
 	}
 
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
@@ -316,7 +338,7 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
 	*new_flags &= RTL_SUPPORTED_FILTERS;
-	if (!changed_flags)
+	if (0 == changed_flags)
 		return;
 
 	/*TODO: we disable broadcase now, so enable here */
@@ -346,27 +368,25 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		/*
-		 *TODO: BIT(5) is probe response BIT(8) is beacon
-		 *TODO: Use define for BIT(5) and BIT(8)
-		 */
+	/* if ssid not set to hw don't check bssid
+	 * here just used for linked scanning, & linked
+	 * and nolink check bssid is set in set network_type */
+	if ((changed_flags & FIF_BCN_PRBRESP_PROMISC) &&
+		(mac->link_state >= MAC80211_LINKED)) {
 		if (*new_flags & FIF_BCN_PRBRESP_PROMISC)
-			mac->rx_mgt_filter |= (BIT(5) | BIT(8));
+			rtlpriv->cfg->ops->set_chk_bssid(hw, false);
 		else
-			mac->rx_mgt_filter &= ~(BIT(5) | BIT(8));
+			rtlpriv->cfg->ops->set_chk_bssid(hw, true);
 	}
 
 	if (changed_flags & FIF_CONTROL) {
 		if (*new_flags & FIF_CONTROL) {
 			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_ACF];
-			mac->rx_ctrl_filter |= RTL_SUPPORTED_CTRL_FILTER;
 
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 ("Enable receive control frame.\n"));
 		} else {
 			mac->rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_ACF];
-			mac->rx_ctrl_filter &= ~RTL_SUPPORTED_CTRL_FILTER;
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 ("Disable receive control frame.\n"));
 		}
@@ -383,12 +403,6 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 				 ("Disable receive other BSS's frame.\n"));
 		}
 	}
-
-	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *) (&mac->rx_conf));
-	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_MGT_FILTER,
-				      (u8 *) (&mac->rx_mgt_filter));
-	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_CTRL_FILTER,
-				      (u8 *) (&mac->rx_ctrl_filter));
 }
 
 static int _rtl_get_hal_qnum(u16 queue)
@@ -447,6 +461,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 			     struct ieee80211_bss_conf *bss_conf, u32 changed)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 
@@ -495,6 +510,16 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 	/*TODO: reference to enum ieee80211_bss_change */
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
+			/* we should reset all sec info & cam
+			 * before set cam after linked, we should not
+			 * reset in disassoc, that will cause tkip->wep
+			 * fail because some flag will be wrong */
+			/* reset sec info */
+			rtl_cam_reset_sec_info(hw);
+			/* reset cam to fix wep fail issue
+			 * when change from wpa to wep */
+			rtl_cam_reset_all_entry(hw);
+
 			mac->link_state = MAC80211_LINKED;
 			mac->cnt_after_linked = 0;
 			mac->assoc_id = bss_conf->aid;
@@ -508,9 +533,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 
 			mac->link_state = MAC80211_NOLINK;
 			memset(mac->bssid, 0, 6);
-
-			/* reset sec info */
-			rtl_cam_reset_sec_info(hw);
+			mac->vendor = PEER_UNKNOWN;
 
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 				 ("BSS_CHANGED_UN_ASSOC\n"));
@@ -584,6 +607,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 			 (MAC_FMT "\n", MAC_ARG(bss_conf->bssid)));
 
+		mac->vendor = PEER_UNKNOWN;
 		memcpy(mac->bssid, bss_conf->bssid, 6);
 		if (is_valid_ether_addr(bss_conf->bssid)) {
 			switch (vif->type) {
@@ -601,25 +625,39 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 				break;
 			}
 			rtlpriv->cfg->ops->set_network_type(hw, vif->type);
-		} else
+		} else {
 			rtlpriv->cfg->ops->set_network_type(hw,
 					NL80211_IFTYPE_UNSPECIFIED);
+		}
 
 		memset(mac->mcs, 0, 16);
 		mac->ht_enable = false;
 		mac->sgi_40 = false;
 		mac->sgi_20 = false;
-
-		if (!bss_conf->use_short_slot)
-			mac->mode = WIRELESS_MODE_B;
-		else
+		if (vif->type == NL80211_IFTYPE_ADHOC) {
 			mac->mode = WIRELESS_MODE_G;
+			if (rtlpriv->dm.b_useramask)
+				rtlpriv->cfg->ops->update_rate_mask(hw, 0);
+			else
+				rtlpriv->cfg->ops->update_rate_table(hw);
+		} else {
+			if (!bss_conf->use_short_slot)
+				mac->mode = WIRELESS_MODE_B;
+			else
+				mac->mode = WIRELESS_MODE_G;
+		}
+
+		if (rtlhal->current_bandtype == BAND_ON_5G)
+			mac->mode = WIRELESS_MODE_A;
 
 		sta = ieee80211_find_sta(mac->vif, mac->bssid);
 
 		if (sta) {
 			if (sta->ht_cap.ht_supported) {
-				mac->mode = WIRELESS_MODE_N_24G;
+				if (rtlhal->current_bandtype == BAND_ON_2_4G)
+					mac->mode = WIRELESS_MODE_N_24G;
+				else
+					mac->mode = WIRELESS_MODE_N_5G;
 				mac->ht_enable = true;
 			}
 
@@ -642,11 +680,10 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 
 				/*
 				 * for cisco 1252 bw20 it's wrong
-				 * if (ht_cap &
-				 *     IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
-				 *	mac->bw_40 = true;
-				 * }
-				 */
+				* if(ht_cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40){
+				*	mac->bw_40 = true;
+				* }
+				* */
 			}
 		}
 
@@ -656,6 +693,9 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (changed & BSS_CHANGED_BASIC_RATES) {
 			if (mac->mode == WIRELESS_MODE_B)
 				basic_rates = bss_conf->basic_rates | 0x00f;
+			else if (mac->mode == WIRELESS_MODE_G ||
+				 mac->mode == WIRELESS_MODE_N_24G)
+				basic_rates = bss_conf->basic_rates | 0xfff;
 			else
 				basic_rates = bss_conf->basic_rates | 0xff0;
 
@@ -693,7 +733,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 				u8 mstatus = RT_MEDIA_DISCONNECT;
 				rtlpriv->cfg->ops->set_hw_reg(hw,
 						      HW_VAR_H2C_FW_JOINBSSRPT,
-						      (u8 *)(&mstatus));
+						      (u8 *) (&mstatus));
 				ppsc->report_linked = false;
 			}
 		}
@@ -716,7 +756,7 @@ static void rtl_op_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	u8 bibss = (mac->opmode == NL80211_IFTYPE_ADHOC) ? 1 : 0;;
+	u8 bibss = (mac->opmode == NL80211_IFTYPE_ADHOC) ? 1 : 0;
 
 	mac->tsf = tsf;
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_CORRECT_TSF, (u8 *) (&bibss));
@@ -749,7 +789,7 @@ static int rtl_op_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       enum ieee80211_ampdu_mlme_action action,
 			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			       u8 buf_size)
+			       u8 buf_siz)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
@@ -796,8 +836,12 @@ static void rtl_op_sw_scan_start(struct ieee80211_hw *hw)
 	if (mac->link_state == MAC80211_LINKED) {
 		rtl_lps_leave(hw);
 		mac->link_state = MAC80211_LINKED_SCANNING;
-	} else
+	} else {
 		rtl_ips_nic_on(hw);
+	}
+
+	/* Dul mac */
+	rtlpriv->rtlhal.b_load_imrandiqk_setting_for2g = false;
 
 	rtlpriv->cfg->ops->led_control(hw, LED_CTL_SITE_SURVEY);
 	rtlpriv->cfg->ops->scan_operation_backup(hw, SCAN_OPT_BACKUP);
@@ -809,9 +853,10 @@ static void rtl_op_sw_scan_complete(struct ieee80211_hw *hw)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
 	RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("\n"));
-
-	rtlpriv->cfg->ops->scan_operation_backup(hw, SCAN_OPT_RESTORE);
 	mac->act_scanning = false;
+	/* Dul mac */
+	rtlpriv->rtlhal.b_load_imrandiqk_setting_for2g = false;
+
 	if (mac->link_state == MAC80211_LINKED_SCANNING) {
 		mac->link_state = MAC80211_LINKED;
 
@@ -825,6 +870,7 @@ static void rtl_op_sw_scan_complete(struct ieee80211_hw *hw)
 
 	}
 
+	rtlpriv->cfg->ops->scan_operation_backup(hw, SCAN_OPT_RESTORE);
 }
 
 static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
@@ -855,41 +901,51 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	rtl_ips_nic_on(hw);
 	mutex_lock(&rtlpriv->locks.conf_mutex);
 	/* <1> get encryption alg */
+
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 		key_type = WEP40_ENCRYPTION;
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, ("alg:WEP40\n"));
-		rtlpriv->sec.use_defaultkey = true;
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
-		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-			 ("alg:WEP104\n"));
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, ("alg:WEP104\n"));
 		key_type = WEP104_ENCRYPTION;
-		rtlpriv->sec.use_defaultkey = true;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		key_type = TKIP_ENCRYPTION;
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, ("alg:TKIP\n"));
-		if (mac->opmode == NL80211_IFTYPE_ADHOC)
-			rtlpriv->sec.use_defaultkey = true;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key_type = AESCCMP_ENCRYPTION;
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, ("alg:CCMP\n"));
-		if (mac->opmode == NL80211_IFTYPE_ADHOC)
-			rtlpriv->sec.use_defaultkey = true;
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("alg_err:%x!!!!:\n", key->cipher));
 		goto out_unlock;
 	}
+	if (key_type == WEP40_ENCRYPTION ||
+			key_type == WEP104_ENCRYPTION ||
+			mac->opmode == NL80211_IFTYPE_ADHOC)
+		rtlpriv->sec.use_defaultkey = true;
+
 	/* <2> get key_idx */
 	key_idx = (u8) (key->keyidx);
 	if (key_idx > 3)
 		goto out_unlock;
 	/* <3> if pairwise key enable_hw_sec */
 	group_key = !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE);
+
+	/* wep always be group key, but there are two conditions:
+	 * 1) wep only: is just for wep enc, in this condition
+	 * rtlpriv->sec.pairwise_enc_algorithm == NO_ENCRYPTION
+	 * will be true & enable_hw_sec will be set when wep
+	 * ke setting.
+	 * 2) wep(group) + AES(pairwise): some AP like cisco
+	 * may use it, in this condition enable_hw_sec will not
+	 * be set when wep key setting */
+	/* we must reset sec_info after lingked before set key,
+	 * or some flag will be wrong*/
 	if ((!group_key) || (mac->opmode == NL80211_IFTYPE_ADHOC) ||
 	    rtlpriv->sec.pairwise_enc_algorithm == NO_ENCRYPTION) {
 		if (rtlpriv->sec.pairwise_enc_algorithm == NO_ENCRYPTION &&
@@ -897,6 +953,9 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		     key_type == WEP104_ENCRYPTION))
 			wep_only = true;
 		rtlpriv->sec.pairwise_enc_algorithm = key_type;
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+			 ("set enable_hw_sec, key_type:%x(OPEN:0 WEP40:1 "
+			 "TKIP:2 AES:4 WEP104:5)\n", key_type));
 		rtlpriv->cfg->ops->enable_hw_sec(hw);
 	}
 	/* <4> set key based on cmd */
@@ -929,6 +988,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			if (!sta) {
 				RT_ASSERT(false, ("pairwise key withnot"
 						  "mac_addr\n"));
+
 				err = -EOPNOTSUPP;
 				goto out_unlock;
 			}
@@ -983,6 +1043,7 @@ static void rtl_op_rfkill_poll(struct ieee80211_hw *hw)
 	bool radio_state;
 	bool blocked;
 	u8 valid = 0;
+	static bool init;
 
 	if (!test_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status))
 		return;
@@ -992,13 +1053,13 @@ static void rtl_op_rfkill_poll(struct ieee80211_hw *hw)
 	/*if Radio On return true here */
 	radio_state = rtlpriv->cfg->ops->radio_onoff_checking(hw, &valid);
 
-	if (valid) {
+	if (valid || !init) {
+		init = true;
 		if (unlikely(radio_state != rtlpriv->rfkill.rfkill_state)) {
 			rtlpriv->rfkill.rfkill_state = radio_state;
 
-			RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
-				 (KERN_INFO "wireless radio switch turned %s\n",
-				  radio_state ? "on" : "off"));
+			printk(KERN_INFO "rtlwifi: wireless radio switch turned %s\n",
+				  radio_state ? "on" : "off");
 
 			blocked = (rtlpriv->rfkill.rfkill_state == 1) ? 0 : 1;
 			wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
@@ -1028,3 +1089,4 @@ const struct ieee80211_ops rtl_ops = {
 	.sw_scan_complete = rtl_op_sw_scan_complete,
 	.rfkill_poll = rtl_op_rfkill_poll,
 };
+
diff --git a/drivers/net/wireless/rtlwifi/core.h b/drivers/net/wireless/rtlwifi/core.h
index 0ef31c3..4b247db 100644
--- a/drivers/net/wireless/rtlwifi/core.h
+++ b/drivers/net/wireless/rtlwifi/core.h
@@ -24,6 +24,7 @@
  * Hsinchu 300, Taiwan.
  *
  * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #ifndef __RTL_CORE_H__
diff --git a/drivers/net/wireless/rtlwifi/debug.c b/drivers/net/wireless/rtlwifi/debug.c
index 5fa7385..395a8e2 100644
--- a/drivers/net/wireless/rtlwifi/debug.c
+++ b/drivers/net/wireless/rtlwifi/debug.c
@@ -24,9 +24,11 @@
  * Hsinchu 300, Taiwan.
  *
  * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #include "wifi.h"
+#include "cam.h"
 
 void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
 {
@@ -36,15 +38,834 @@ void rtl_dbgp_flag_init(struct ieee80211_hw *hw)
 	rtlpriv->dbg.global_debuglevel = DBG_EMERG;
 
 	rtlpriv->dbg.global_debugcomponents =
-	    COMP_ERR | COMP_FW | COMP_INIT | COMP_RECV | COMP_SEND |
-	    COMP_MLME | COMP_SCAN | COMP_INTR | COMP_LED | COMP_SEC |
-	    COMP_BEACON | COMP_RATE | COMP_RXDESC | COMP_DIG | COMP_TXAGC |
-	    COMP_POWER | COMP_POWER_TRACKING | COMP_BB_POWERSAVING | COMP_SWAS |
-	    COMP_RF | COMP_TURBO | COMP_RATR | COMP_CMD |
-	    COMP_EFUSE | COMP_QOS | COMP_MAC80211 | COMP_REGD | COMP_CHAN;
+	    COMP_ERR |
+	    COMP_FW |
+	    COMP_INIT |
+	    COMP_RECV |
+	    COMP_SEND |
+	    COMP_MLME |
+	    COMP_SCAN |
+	    COMP_INTR |
+	    COMP_LED |
+	    COMP_SEC |
+	    COMP_BEACON |
+	    COMP_RATE |
+	    COMP_RXDESC |
+	    COMP_DIG |
+	    COMP_TXAGC |
+	    /*COMP_POWER | */
+	    COMP_POWER_TRACKING |
+	    COMP_BB_POWERSAVING |
+	    COMP_SWAS |
+	    COMP_RF |
+	    COMP_TURBO |
+	    COMP_RATR |
+	    COMP_CMD |
+	    COMP_EFUSE | COMP_QOS | COMP_MAC80211 | COMP_REGD | COMP_CHAN | 0;
 
 	for (i = 0; i < DBGP_TYPE_MAX; i++)
 		rtlpriv->dbg.dbgp_type[i] = 0;
 
 	/*Init Debug flag enable condition */
 }
+
+static struct proc_dir_entry *proc_topdir;
+
+static int rtl_proc_get_mac_0(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x000;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+
+static int rtl_proc_get_mac_1(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x100;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+static int rtl_proc_get_mac_2(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x200;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+
+static int rtl_proc_get_mac_3(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x300;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+
+static int rtl_proc_get_mac_4(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x400;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+
+static int rtl_proc_get_mac_5(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x500;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+
+static int rtl_proc_get_mac_6(char *page, char **start,
+			      off_t offset, int count,
+			      int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x600;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+static int rtl_proc_get_mac_7(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x700;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; i++, n += 4)
+			len += snprintf(page + len, count - len,
+					"%8.8x    ",
+					rtl_read_dword(rtlpriv, (page0 | n)));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+
+static int rtl_proc_get_bb_8(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x800;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+
+}
+static int rtl_proc_get_bb_9(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0x900;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						       0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_bb_a(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0xa00;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_bb_b(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0xb00;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+static int rtl_proc_get_bb_c(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0xc00;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+static int rtl_proc_get_bb_d(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0xd00;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_bb_e(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0xe00;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_bb_f(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n, page0;
+	int max = 0xff;
+	page0 = 0xf00;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ",
+				n + page0);
+		for (i = 0; i < 4 && n <= max; n += 4, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_bbreg(hw, (page0 | n),
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_reg_rf_a(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n;
+	int max = 0x40;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ", n);
+		for (i = 0; i < 4 && n <= max; n += 1, i++)
+			len += snprintf(page + len, count - len,
+				"%8.8x     ",
+				rtl_get_rfreg(hw, RF90_PATH_A, n,
+					      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_reg_rf_b(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	int len = 0;
+	int i, n;
+	int max = 0x40;
+
+	for (n = 0; n <= max; ) {
+		len += snprintf(page + len, count - len, "\n%#8.8x  ", n);
+		for (i = 0; i < 4 && n <= max; n += 1, i++)
+			len += snprintf(page + len, count - len,
+					"%8.8x     ",
+					rtl_get_rfreg(hw, RF90_PATH_B, n,
+						      0xffffffff));
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_cam_register_1(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 target_cmd = 0;
+	u32 target_val = 0;
+	u8 entry_i = 0;
+	u32 ulstatus;
+	int len = 0;
+	int i = 100, j = 0;
+
+	/* This dump the current register page */
+	len += snprintf(page + len, count - len,
+		"\n################# SECURITY CAM (0-10) ################\n ");
+
+	for (j = 0; j < 11; j++) {
+		len += snprintf(page + len, count - len, "\nD:  %2x > ", j);
+		for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
+			/* polling bit, and No Write enable, and address  */
+			target_cmd = entry_i + CAM_CONTENT_COUNT * j;
+			target_cmd = target_cmd | BIT(31);
+
+			/* Check polling bit is clear */
+			while ((i--) >= 0) {
+				ulstatus = rtl_read_dword(rtlpriv,
+						rtlpriv->cfg->maps[RWCAM]);
+				if (ulstatus & BIT(31))
+					continue;
+				else
+					break;
+			}
+
+			rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM],
+					target_cmd);
+			target_val = rtl_read_dword(rtlpriv,
+					rtlpriv->cfg->maps[RCAMO]);
+			len += snprintf(page + len, count - len, "%8.8x ",
+					target_val);
+		}
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_cam_register_2(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 target_cmd = 0;
+	u32 target_val = 0;
+	u8 entry_i = 0;
+	u32 ulstatus;
+	int len = 0;
+	int i = 100, j = 0;
+
+	/* This dump the current register page */
+	len += snprintf(page + len, count - len,
+		"\n################# SECURITY CAM (11-21) ###############\n ");
+
+	for (j = 11; j < 22; j++) {
+		len += snprintf(page + len, count - len, "\nD:  %2x > ", j);
+		for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
+			target_cmd = entry_i + CAM_CONTENT_COUNT * j;
+			target_cmd = target_cmd | BIT(31);
+
+			while ((i--) >= 0) {
+				ulstatus = rtl_read_dword(rtlpriv,
+						 rtlpriv->cfg->maps[RWCAM]);
+				if (ulstatus & BIT(31))
+					continue;
+				else
+					break;
+			}
+
+			rtl_write_dword(rtlpriv,
+					rtlpriv->cfg->maps[RWCAM], target_cmd);
+			target_val = rtl_read_dword(rtlpriv,
+					rtlpriv->cfg->maps[RCAMO]);
+			len += snprintf(page + len, count - len, "%8.8x ",
+					target_val);
+		}
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+static int rtl_proc_get_cam_register_3(char *page, char **start,
+		off_t offset, int count, int *eof, void *data)
+{
+	struct ieee80211_hw *hw = data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 target_cmd = 0;
+	u32 target_val = 0;
+	u8 entry_i = 0;
+	u32 ulstatus;
+	int len = 0;
+	int i = 100, j = 0;
+
+	/* This dump the current register page */
+	len += snprintf(page + len, count - len,
+		"\n################## SECURITY CAM (22-31) ##############\n ");
+
+	for (j = 22; j < TOTAL_CAM_ENTRY; j++) {
+		len += snprintf(page + len, count - len, "\nD:  %2x > ", j);
+		for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
+			target_cmd = entry_i+CAM_CONTENT_COUNT*j;
+			target_cmd = target_cmd | BIT(31);
+
+			while ((i--) >= 0) {
+				ulstatus = rtl_read_dword(rtlpriv,
+						rtlpriv->cfg->maps[RWCAM]);
+				if (ulstatus & BIT(31))
+					continue;
+				else
+					break;
+			}
+
+			rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM],
+					target_cmd);
+			target_val = rtl_read_dword(rtlpriv,
+						    rtlpriv->cfg->maps[RCAMO]);
+			len += snprintf(page + len, count - len,
+					"%8.8x ", target_val);
+		}
+	}
+
+	len += snprintf(page + len, count - len, "\n");
+	*eof = 1;
+	return len;
+}
+
+void rtl_proc_add_one(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct proc_dir_entry *entry;
+
+	snprintf(rtlpriv->dbg.proc_name, 18, "%x-%x-%x-%x-%x-%x",
+		rtlefuse->dev_addr[0], rtlefuse->dev_addr[1],
+		rtlefuse->dev_addr[2], rtlefuse->dev_addr[3],
+		rtlefuse->dev_addr[4], rtlefuse->dev_addr[5]);
+
+	rtlpriv->dbg.proc_dir = create_proc_entry(rtlpriv->dbg.proc_name,
+		S_IFDIR | S_IRUGO | S_IXUGO, proc_topdir);
+	if (!rtlpriv->dbg.proc_dir) {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, ("Unable to init "
+			"/proc/net/%s/%s\n", rtlpriv->cfg->name,
+			rtlpriv->dbg.proc_name));
+		return;
+	}
+
+	entry = create_proc_read_entry("mac-0", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_0, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-0\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-1", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_1, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-1\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-2", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_2, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-2\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-3", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_3, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-3\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-4", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_4, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-4\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-5", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_5, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-5\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-6", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_6, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-6\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("mac-7", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_mac_7, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/mac-7\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-8", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_bb_8, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-8\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-9", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir,
+				  rtl_proc_get_bb_9, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-9\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-a", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir, rtl_proc_get_bb_a, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-a\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-b", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir, rtl_proc_get_bb_b, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-b\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-c", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir, rtl_proc_get_bb_c, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-c\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-d", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir, rtl_proc_get_bb_d, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-d\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-e", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir, rtl_proc_get_bb_e, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-e\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("bb-f", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir, rtl_proc_get_bb_f, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/bb-f\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("rf-a", S_IFREG | S_IRUGO,
+				  rtlpriv->dbg.proc_dir,
+				  rtl_proc_get_reg_rf_a, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/rf-a\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("rf-b", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_reg_rf_b, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/rf-b\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("cam-1", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_cam_register_1, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/cam-1\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("cam-2", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_cam_register_2, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/cam-2\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+
+	entry = create_proc_read_entry("cam-3", S_IFREG | S_IRUGO,
+				   rtlpriv->dbg.proc_dir,
+				   rtl_proc_get_cam_register_3, hw);
+	if (!entry)
+		RT_TRACE(rtlpriv, COMP_INIT, COMP_ERR, ("Unable to initialize "
+		      "/proc/net/%s/%s/cam-3\n",
+		      rtlpriv->cfg->name, rtlpriv->dbg.proc_name));
+}
+
+void rtl_proc_remove_one(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (rtlpriv->dbg.proc_dir) {
+		remove_proc_entry("mac-0", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-1", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-2", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-3", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-4", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-5", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-6", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("mac-7", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-8", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-9", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-a", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-b", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-c", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-d", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-e", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("bb-f", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("rf-a", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("rf-b", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("cam-1", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("cam-2", rtlpriv->dbg.proc_dir);
+		remove_proc_entry("cam-3", rtlpriv->dbg.proc_dir);
+
+		remove_proc_entry(rtlpriv->dbg.proc_name, proc_topdir);
+
+		rtlpriv->dbg.proc_dir = NULL;
+	}
+}
+
+void rtl_proc_add_topdir(void)
+{
+		proc_topdir = create_proc_entry("rtlwifi",
+			S_IFDIR, init_net.proc_net);
+}
+
+void rtl_proc_remove_topdir(void)
+{
+	if (proc_topdir)
+		remove_proc_entry("rtlwifi", init_net.proc_net);
+}
+
diff --git a/drivers/net/wireless/rtlwifi/debug.h b/drivers/net/wireless/rtlwifi/debug.h
index 08bdec2..f21336d 100644
--- a/drivers/net/wireless/rtlwifi/debug.h
+++ b/drivers/net/wireless/rtlwifi/debug.h
@@ -24,6 +24,7 @@
  * Hsinchu 300, Taiwan.
  *
  * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #ifndef __RTL_DEBUG_H__
@@ -168,10 +169,12 @@ enum dbgp_flag_e {
 	do { \
 		if (unlikely(((comp) & rtlpriv->dbg.global_debugcomponents) && \
 			((level) <= rtlpriv->dbg.global_debuglevel))) {\
-			printk(KERN_DEBUG "%s:%s():<%lx-%x> ", KBUILD_MODNAME, \
-			__func__, in_interrupt(), in_atomic());	\
-			printk fmt;				\
-		} \
+			printk(KERN_DEBUG "%s-%d:%s():<%lx-%x> ",	\
+			KBUILD_MODNAME, \
+			rtlpriv->rtlhal.interfaceindex, __func__, \
+			in_interrupt(), in_atomic());	\
+			printk fmt;			\
+		}					\
 	} while (0);
 
 #define RTPRINT(rtlpriv, dbgtype, dbgflag, printstr)	\
@@ -186,19 +189,20 @@ enum dbgp_flag_e {
 		_hexdatalen) \
 	do {\
 		if (unlikely(((_comp) & rtlpriv->dbg.global_debugcomponents) &&\
-			(_level <= rtlpriv->dbg.global_debuglevel)))	{ \
-			int __i;					\
-			u8*	ptr = (u8 *)_hexdata;			\
+			(_level <= rtlpriv->dbg.global_debuglevel)))	{      \
+			int __i;					       \
+			u8 *ptr = (u8 *)_hexdata;			       \
 			printk(KERN_DEBUG "%s: ", KBUILD_MODNAME);	\
-			printk("In process \"%s\" (pid %i):", current->comm,\
+			printk(KERN_DEBUG "In process \"%s\" (pid %i):",\
+					current->comm, \
 					current->pid); \
 			printk(_titlestring);		\
 			for (__i = 0; __i < (int)_hexdatalen; __i++) {	\
-				printk("%02X%s", ptr[__i], (((__i + 1) % 4)\
-							== 0) ? "  " : " ");\
+				printk(KERN_DEBUG "%02X%s", ptr[__i],	\
+				(((__i + 1) % 4) == 0) ? "  " : " ");	\
 				if (((__i + 1) % 16) == 0)		\
-					printk("\n");			\
-			}				\
+					printk(KERN_DEBUG "\n");	\
+			}						\
 			printk(KERN_DEBUG "\n");			\
 		} \
 	} while (0);
@@ -209,4 +213,9 @@ enum dbgp_flag_e {
 	((u8 *)(x))[3], ((u8 *)(x))[4], ((u8 *)(x))[5]
 
 void rtl_dbgp_flag_init(struct ieee80211_hw *hw);
+void rtl_proc_add_one(struct ieee80211_hw *hw);
+void rtl_proc_remove_one(struct ieee80211_hw *hw);
+void rtl_proc_add_topdir(void);
+void rtl_proc_remove_topdir(void);
 #endif
+
diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
index 62876cd..e48626e 100644
--- a/drivers/net/wireless/rtlwifi/efuse.c
+++ b/drivers/net/wireless/rtlwifi/efuse.c
@@ -52,8 +52,6 @@ static const struct efuse_map RTL8712_SDIO_EFUSE_TABLE[] = {
 	{11, 0, 0, 28}
 };
 
-static void read_efuse_byte(struct ieee80211_hw *hw, u16 _offset,
-					u8 *pbuf);
 static void efuse_shadow_read_1byte(struct ieee80211_hw *hw, u16 offset,
 				    u8 *value);
 static void efuse_shadow_read_2byte(struct ieee80211_hw *hw, u16 offset,
@@ -115,8 +113,10 @@ u8 efuse_read_1byte(struct ieee80211_hw *hw, u16 address)
 	u8 bytetemp;
 	u8 temp;
 	u32 k = 0;
+	const u32 efuse_real_content_len =
+		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
 
-	if (address < EFUSE_REAL_CONTENT_LEN) {
+	if (address < efuse_real_content_len) {
 		temp = address & 0xFF;
 		rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL] + 1,
 			       temp);
@@ -158,11 +158,13 @@ void efuse_write_1byte(struct ieee80211_hw *hw, u16 address, u8 value)
 	u8 bytetemp;
 	u8 temp;
 	u32 k = 0;
+	const u32 efuse_real_content_len =
+		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
 
 	RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
 		 ("Addr=%x Data =%x\n", address, value));
 
-	if (address < EFUSE_REAL_CONTENT_LEN) {
+	if (address < efuse_real_content_len) {
 		rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CTRL], value);
 
 		temp = address & 0xFF;
@@ -198,7 +200,7 @@ void efuse_write_1byte(struct ieee80211_hw *hw, u16 address, u8 value)
 
 }
 
-static void read_efuse_byte(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf)
+void read_efuse_byte(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 value32;
@@ -233,24 +235,28 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	u8 efuse_tbl[EFUSE_MAP_LEN];
+	u8 efuse_tbl[rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]];
 	u8 rtemp8[1];
 	u16 efuse_addr = 0;
 	u8 offset, wren;
 	u16 i;
 	u16 j;
-	u16 efuse_word[EFUSE_MAX_SECTION][EFUSE_MAX_WORD_UNIT];
+	const u16 efuse_max_section =
+		rtlpriv->cfg->maps[EFUSE_MAX_SECTION_MAP];
+	const u32 efuse_real_content_len =
+		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
+	u16 efuse_word[efuse_max_section][EFUSE_MAX_WORD_UNIT];
 	u16 efuse_utilized = 0;
 	u8 efuse_usage;
 
-	if ((_offset + _size_byte) > EFUSE_MAP_LEN) {
+	if ((_offset + _size_byte) > rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]) {
 		RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
 			 ("read_efuse(): Invalid offset(%#x) with read "
 			  "bytes(%#x)!!\n", _offset, _size_byte));
 		return;
 	}
 
-	for (i = 0; i < EFUSE_MAX_SECTION; i++)
+	for (i = 0; i < efuse_max_section; i++)
 		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++)
 			efuse_word[i][j] = 0xFFFF;
 
@@ -262,10 +268,10 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 		efuse_addr++;
 	}
 
-	while ((*rtemp8 != 0xFF) && (efuse_addr < EFUSE_REAL_CONTENT_LEN)) {
+	while ((*rtemp8 != 0xFF) && (efuse_addr < efuse_real_content_len)) {
 		offset = ((*rtemp8 >> 4) & 0x0f);
 
-		if (offset < EFUSE_MAX_SECTION) {
+		if (offset < efuse_max_section) {
 			wren = (*rtemp8 & 0x0f);
 			RTPRINT(rtlpriv, FEEPROM, EFUSE_READ_ALL,
 				("offset-%d Worden=%x\n", offset, wren));
@@ -281,7 +287,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 					efuse_utilized++;
 					efuse_word[offset][i] = (*rtemp8 & 0xff);
 
-					if (efuse_addr >= EFUSE_REAL_CONTENT_LEN)
+					if (efuse_addr >= efuse_real_content_len)
 						break;
 
 					RTPRINT(rtlpriv, FEEPROM,
@@ -294,7 +300,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 					efuse_word[offset][i] |=
 					    (((u16)*rtemp8 << 8) & 0xff00);
 
-					if (efuse_addr >= EFUSE_REAL_CONTENT_LEN)
+					if (efuse_addr >= efuse_real_content_len)
 						break;
 				}
 
@@ -305,13 +311,13 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 		RTPRINT(rtlpriv, FEEPROM, EFUSE_READ_ALL,
 			("Addr=%d\n", efuse_addr));
 		read_efuse_byte(hw, efuse_addr, rtemp8);
-		if (*rtemp8 != 0xFF && (efuse_addr < 512)) {
+		if (*rtemp8 != 0xFF && (efuse_addr < efuse_real_content_len)) {
 			efuse_utilized++;
 			efuse_addr++;
 		}
 	}
 
-	for (i = 0; i < EFUSE_MAX_SECTION; i++) {
+	for (i = 0; i < efuse_max_section; i++) {
 		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++) {
 			efuse_tbl[(i * 8) + (j * 2)] =
 			    (efuse_word[i][j] & 0xff);
@@ -324,7 +330,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 		pbuf[i] = efuse_tbl[_offset + i];
 
 	rtlefuse->efuse_usedbytes = efuse_utilized;
-	efuse_usage = (u8)((efuse_utilized * 100) / EFUSE_REAL_CONTENT_LEN);
+	efuse_usage = (u8) ((efuse_utilized * 100) / efuse_real_content_len);
 	rtlefuse->efuse_usedpercentage = efuse_usage;
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_EFUSE_BYTES,
 				      (u8 *)&efuse_utilized);
@@ -478,15 +484,15 @@ void rtl_efuse_shadow_map_update(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 
-	if (rtlefuse->autoload_failflag == true) {
-		memset((void *)(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0]), 128,
-		       0xFF);
-	} else
+	if (rtlefuse->autoload_failflag == true)
+		memset((void *)(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0]),
+			rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE], 0xFF);
+	else
 		efuse_read_all_map(hw, &rtlefuse->efuse_map[EFUSE_INIT_MAP][0]);
 
 	memcpy((void *)&rtlefuse->efuse_map[EFUSE_MODIFY_MAP][0],
-	       (void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
-	       rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
+			(void *)&rtlefuse->efuse_map[EFUSE_INIT_MAP][0],
+			rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
 
 }
 EXPORT_SYMBOL(rtl_efuse_shadow_map_update);
@@ -634,10 +640,11 @@ static int efuse_one_byte_write(struct ieee80211_hw *hw, u16 addr, u8 data)
 	return bresult;
 }
 
-static void efuse_read_all_map(struct ieee80211_hw *hw, u8 * efuse)
+static void efuse_read_all_map(struct ieee80211_hw *hw, u8 *efuse)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	efuse_power_switch(hw, false, true);
-	read_efuse(hw, 0, 128, efuse);
+	read_efuse(hw, 0, rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE], efuse);
 	efuse_power_switch(hw, false, false);
 }
 
@@ -686,7 +693,7 @@ static int efuse_pg_packet_read(struct ieee80211_hw *hw, u8 offset, u8 *data)
 
 	u8 efuse_data, word_cnts = 0;
 	u16 efuse_addr = 0;
-	u8 hworden;
+	u8 hworden = 0;
 	u8 tmpdata[8];
 
 	if (data == NULL)
@@ -749,9 +756,8 @@ static void efuse_write_data_case1(struct ieee80211_hw *hw, u16 *efuse_addr,
 		*write_state = PG_STATE_HEADER;
 	} else {
 		for (tmpindex = 0; tmpindex < (tmp_word_cnts * 2); tmpindex++) {
-			u16 address = *efuse_addr + 1 + tmpindex;
-			if (efuse_one_byte_read(hw, address,
-			     &efuse_data) && (efuse_data != 0xFF))
+			if (efuse_one_byte_read(hw,	(*efuse_addr + 1 + tmpindex),
+				&efuse_data) && (efuse_data != 0xFF))
 				bdataempty = false;
 		}
 
@@ -847,9 +853,9 @@ static void efuse_write_data_case2(struct ieee80211_hw *hw, u16 *efuse_addr,
 	efuse_one_byte_write(hw, *efuse_addr, pg_header);
 	efuse_one_byte_read(hw, *efuse_addr, &tmp_header);
 
-	if (tmp_header == pg_header)
+	if (tmp_header == pg_header) {
 		*write_state = PG_STATE_DATA;
-	else if (tmp_header == 0xFF) {
+	} else if (tmp_header == 0xFF) {
 		*write_state = PG_STATE_HEADER;
 		*repeat_times += 1;
 		if (*repeat_times > EFUSE_REPEAT_THRESHOLD_) {
@@ -1076,10 +1082,12 @@ static u8 efuse_word_enable_data_write(struct ieee80211_hw *hw,
 static void efuse_power_switch(struct ieee80211_hw *hw, u8 bwrite, u8 pwrstate)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u8 tempval;
 	u16 tmpV16;
 
-	if (pwrstate == true) {
+	if (pwrstate == true && (rtlhal->hw_type !=
+		HARDWARE_TYPE_RTL8192SE)) {
 		tmpV16 = rtl_read_word(rtlpriv,
 				       rtlpriv->cfg->maps[SYS_ISO_CTRL]);
 		if (!(tmpV16 & rtlpriv->cfg->maps[EFUSE_PWC_EV12V])) {
@@ -1112,13 +1120,22 @@ static void efuse_power_switch(struct ieee80211_hw *hw, u8 bwrite, u8 pwrstate)
 			tempval = rtl_read_byte(rtlpriv,
 						rtlpriv->cfg->maps[EFUSE_TEST] +
 						3);
-			tempval &= 0x0F;
-			tempval |= (VOLTAGE_V25 << 4);
+
+			if (rtlhal->hw_type != HARDWARE_TYPE_RTL8192SE) {
+				tempval &= 0x0F;
+				tempval |= (VOLTAGE_V25 << 4);
+			}
+
 			rtl_write_byte(rtlpriv,
 				       rtlpriv->cfg->maps[EFUSE_TEST] + 3,
 				       (tempval | 0x80));
 		}
 
+		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+			rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CLK],
+						0x03);
+		}
+
 	} else {
 		if (bwrite == true) {
 			tempval = rtl_read_byte(rtlpriv,
@@ -1129,6 +1146,11 @@ static void efuse_power_switch(struct ieee80211_hw *hw, u8 bwrite, u8 pwrstate)
 				       (tempval & 0x7F));
 		}
 
+		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+			rtl_write_byte(rtlpriv, rtlpriv->cfg->maps[EFUSE_CLK],
+						0x02);
+		}
+
 	}
 
 }
diff --git a/drivers/net/wireless/rtlwifi/efuse.h b/drivers/net/wireless/rtlwifi/efuse.h
index 2d39a4d..57a12ad 100644
--- a/drivers/net/wireless/rtlwifi/efuse.h
+++ b/drivers/net/wireless/rtlwifi/efuse.h
@@ -30,10 +30,15 @@
 #ifndef __RTL_EFUSE_H_
 #define __RTL_EFUSE_H_
 
-#define EFUSE_REAL_CONTENT_LEN		512
-#define EFUSE_MAP_LEN			128
-#define EFUSE_MAX_SECTION		16
+#define EFUSE_IC_ID_OFFSET		506
+
+/*
+#define EFUSE_MAP_LEN				128
+#define EFUSE_IC_ID_OFFSET		506
+*/
+
 #define EFUSE_MAX_WORD_UNIT		4
+#define EFUSE_REAL_CONTENT_LEN		512
 
 #define EFUSE_INIT_MAP			0
 #define EFUSE_MODIFY_MAP		1
@@ -45,13 +50,14 @@
 #define PG_STATE_WORD_3			0x10
 #define PG_STATE_DATA			0x20
 
-#define PG_SWBYTE_H			0x01
-#define PG_SWBYTE_L			0x02
+#define PG_SWBYTE_H				0x01
+#define PG_SWBYTE_L				0x02
 
 #define _POWERON_DELAY_
 #define _PRE_EXECUTE_READ_CMD_
 
-#define EFUSE_REPEAT_THRESHOLD_		3
+#define EFUSE_REPEAT_THRESHOLD_	3
+#define EFUSE_ERROE_HANDLE		1
 
 struct efuse_map {
 	u8 offset;
@@ -103,6 +109,7 @@ struct efuse_priv {
 	u8 tx_power_g[14];
 };
 
+extern void read_efuse_byte(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf);
 extern void efuse_initialize(struct ieee80211_hw *hw);
 extern u8 efuse_read_1byte(struct ieee80211_hw *hw, u16 address);
 extern void efuse_write_1byte(struct ieee80211_hw *hw, u16 address, u8 value);
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 1758d44..2a68284 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -32,6 +32,7 @@
 #include "pci.h"
 #include "base.h"
 #include "ps.h"
+#include "efuse.h"
 
 static const u16 pcibridge_vendors[PCI_BRIDGE_VENDOR_MAX] = {
 	INTEL_VENDOR_ID,
@@ -48,6 +49,7 @@ static void _rtl_pci_update_default_setting(struct ieee80211_hw *hw)
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	u8 pcibridge_vendor = pcipriv->ndis_adapter.pcibridge_vendor;
+	u8 init_aspm;
 
 	ppsc->reg_rfps_level = 0;
 	ppsc->b_support_aspm = 0;
@@ -145,6 +147,13 @@ static void _rtl_pci_update_default_setting(struct ieee80211_hw *hw)
 			 ("switch case not process\n"));
 		break;
 	}
+
+	/* toshiba aspm issue, toshiba will set aspm selfly
+	 * so we should not set aspm in driver */
+	pci_read_config_byte(rtlpci->pdev, 0x80, &init_aspm);
+	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8192SE &&
+		init_aspm == 0x43)
+		ppsc->b_support_aspm = false;
 }
 
 static bool _rtl_pci_platform_switch_device_pci_aspm(
@@ -152,9 +161,11 @@ static bool _rtl_pci_platform_switch_device_pci_aspm(
 			u8 value)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	bool bresult = false;
 
-	value |= 0x40;
+	if (rtlhal->hw_type != HARDWARE_TYPE_RTL8192SE)
+		value |= 0x40;
 
 	pci_write_config_byte(rtlpci->pdev, 0x80, value);
 
@@ -165,14 +176,15 @@ static bool _rtl_pci_platform_switch_device_pci_aspm(
 static bool _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u8 value)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	u8 buffer;
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	bool bresult = false;
 
-	buffer = value;
-
 	pci_write_config_byte(rtlpci->pdev, 0x81, value);
 	bresult = true;
 
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE)
+		udelay(100);
+
 	return bresult;
 }
 
@@ -192,6 +204,9 @@ static void rtl_pci_disable_aspm(struct ieee80211_hw *hw)
 				pcibridge_linkctrlreg;
 	u16 aspmlevel = 0;
 
+	if (!ppsc->b_support_aspm)
+		return;
+
 	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_UNKNOWN) {
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_TRACE,
 			 ("PCI(Bridge) UNKNOWN.\n"));
@@ -249,6 +264,9 @@ static void rtl_pci_enable_aspm(struct ieee80211_hw *hw)
 	u8 u_pcibridge_aspmsetting;
 	u8 u_device_aspmsetting;
 
+	if (!ppsc->b_support_aspm)
+		return;
+
 	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_UNKNOWN) {
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_TRACE,
 			 ("PCI(Bridge) UNKNOWN.\n"));
@@ -293,7 +311,7 @@ static void rtl_pci_enable_aspm(struct ieee80211_hw *hw)
 					     RT_RF_OFF_LEVL_CLK_REQ) ? 1 : 0);
 		RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_CLK_REQ);
 	}
-	udelay(200);
+	udelay(100);
 }
 
 static bool rtl_pci_get_amd_l1_patch(struct ieee80211_hw *hw)
@@ -330,13 +348,13 @@ static void rtl_pci_get_linkcontrol_field(struct ieee80211_hw *hw)
 	u8 capabilityoffset = pcipriv->ndis_adapter.pcibridge_pciehdr_offset;
 	u32 pcicfg_addrport = pcipriv->ndis_adapter.pcicfg_addrport;
 	u8 linkctrl_reg;
-	u8 num4bBytes;
+	u8 num4bbytes;
 
-	num4bBytes = (capabilityoffset + 0x10) / 4;
+	num4bbytes = (capabilityoffset + 0x10) / 4;
 
 	/*Read  Link Control Register */
 	rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
-				     pcicfg_addrport + (num4bBytes << 2));
+				     pcicfg_addrport + (num4bbytes << 2));
 	rtl_pci_raw_read_port_uchar(PCI_CONF_DATA, &linkctrl_reg);
 
 	pcipriv->ndis_adapter.pcibridge_linkctrlreg = linkctrl_reg;
@@ -369,7 +387,7 @@ static void rtl_pci_parse_configuration(struct pci_dev *pdev,
 	pci_write_config_byte(pdev, 0x70f, tmp);
 }
 
-static void _rtl_pci_initialize_adapter_common(struct ieee80211_hw *hw)
+static void rtl_pci_init_aspm(struct ieee80211_hw *hw)
 {
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 
@@ -383,52 +401,6 @@ static void _rtl_pci_initialize_adapter_common(struct ieee80211_hw *hw)
 
 }
 
-static void rtl_pci_init_aspm(struct ieee80211_hw *hw)
-{
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-
-	/*close ASPM for AMD defaultly */
-	rtlpci->const_amdpci_aspm = 0;
-
-	/*
-	 * ASPM PS mode.
-	 * 0 - Disable ASPM,
-	 * 1 - Enable ASPM without Clock Req,
-	 * 2 - Enable ASPM with Clock Req,
-	 * 3 - Alwyas Enable ASPM with Clock Req,
-	 * 4 - Always Enable ASPM without Clock Req.
-	 * set defult to RTL8192CE:3 RTL8192E:2
-	 * */
-	rtlpci->const_pci_aspm = 3;
-
-	/*Setting for PCI-E device */
-	rtlpci->const_devicepci_aspm_setting = 0x03;
-
-	/*Setting for PCI-E bridge */
-	rtlpci->const_hostpci_aspm_setting = 0x02;
-
-	/*
-	 * In Hw/Sw Radio Off situation.
-	 * 0 - Default,
-	 * 1 - From ASPM setting without low Mac Pwr,
-	 * 2 - From ASPM setting with low Mac Pwr,
-	 * 3 - Bus D3
-	 * set default to RTL8192CE:0 RTL8192SE:2
-	 */
-	rtlpci->const_hwsw_rfoff_d3 = 0;
-
-	/*
-	 * This setting works for those device with
-	 * backdoor ASPM setting such as EPHY setting.
-	 * 0 - Not support ASPM,
-	 * 1 - Support ASPM,
-	 * 2 - According to chipset.
-	 */
-	rtlpci->const_support_pciaspm = 1;
-
-	_rtl_pci_initialize_adapter_common(hw);
-}
-
 static void _rtl_pci_io_handler_init(struct device *dev,
 				     struct ieee80211_hw *hw)
 {
@@ -450,6 +422,120 @@ static void _rtl_pci_io_handler_release(struct ieee80211_hw *hw)
 {
 }
 
+static bool _rtl_update_earlymode_info(struct ieee80211_hw *hw,
+				       struct sk_buff *skb,
+				       struct rtl_tcb_desc *tcb_desc)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	enum rt_enc_alg pairwise_enc = rtlpriv->sec.pairwise_enc_algorithm;
+	u8 additionlen = 0;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	struct sk_buff *next_skb;
+	unsigned int queue_index = skb_get_queue_mapping(skb);
+	u8 *da = ieee80211_get_DA(hdr);
+
+	if (rtlpriv->rtlhal.hw_type != HARDWARE_TYPE_RTL8192DE)
+		return false;
+
+	switch (pairwise_enc) {
+	case NO_ENCRYPTION:
+		additionlen = 4;
+		break;
+
+	case WEP40_ENCRYPTION:
+	case WEP104_ENCRYPTION:
+		additionlen = 8;
+		break;
+
+	case TKIP_ENCRYPTION:
+		additionlen = 16;
+		break;
+
+	case AESCCMP_ENCRYPTION:
+		additionlen = 12;
+		break;
+
+	default:
+		break;
+	}
+
+	/* Some macaddr can't do early mode. */
+	if (is_multicast_ether_addr(da) || is_broadcast_ether_addr(da) ||
+		!ieee80211_is_data_qos(fc))
+		return false;
+
+	/* The most skb num is 6 */
+	tcb_desc->empkt_num = 0;
+	skb_queue_walk(&mac->skb_waitq[queue_index], next_skb) {
+		hdr = (struct ieee80211_hdr *)(next_skb->data);
+
+		/* rdg is not used now */
+		if (memcmp(ieee80211_get_DA(hdr), da, ETH_ALEN) == 0 &&
+			(queue_index == skb_get_queue_mapping(next_skb))) {
+			tcb_desc->empkt_len[tcb_desc->empkt_num] =
+				next_skb->len + additionlen;
+			tcb_desc->empkt_num++;
+		}
+
+		if (skb_queue_is_last(&mac->skb_waitq[queue_index], next_skb))
+			break;
+
+		if (tcb_desc->empkt_num >= 5)
+			break;
+	}
+
+	return true;
+}
+
+/* just for early mode now */
+static void _rtl_pci_tx_chk_waitq(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	int queue_idx;
+	struct sk_buff *skb = NULL;
+	struct ieee80211_hdr *hdr = NULL;
+	struct ieee80211_tx_info *info = NULL;
+	u8 *qc = NULL;
+	u8 tid = 0;
+	struct rtl_tcb_desc tcb_desc;
+	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
+
+	if (!rtlpriv->rtlhal.b_earlymode_eanble)
+		return;
+
+	if (rtlpriv->rtlhal.hw_type != HARDWARE_TYPE_RTL8192DE)
+		return;
+
+	for (queue_idx = 0; queue_idx < RTL_PCI_MAX_TX_QUEUE_COUNT;
+	     queue_idx++) {
+		if (queue_idx >= BEACON_QUEUE)
+			break;
+
+		while (!skb_queue_empty(&mac->skb_waitq[queue_idx]) &&
+				!mac->act_scanning &&
+				rtlpriv->psc.rfpwr_state == ERFON) {
+			tcb_desc.empkt_num = 0;
+			memset(tcb_desc.empkt_len, 0, 20);
+
+			skb = skb_dequeue(&mac->skb_waitq[queue_idx]);
+			info = IEEE80211_SKB_CB(skb);
+			hdr = (struct ieee80211_hdr *)(skb->data);
+			qc = ieee80211_get_qos_ctl(hdr);
+			tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+
+			if (mac->tids[tid].agg.agg_state == RTL_AGG_ON &&
+					info->flags & IEEE80211_TX_CTL_AMPDU)
+				_rtl_update_earlymode_info(hw, skb, &tcb_desc);
+
+			rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
+		}
+	}
+}
+
+
 static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -461,6 +547,8 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
 		struct sk_buff *skb;
 		struct ieee80211_tx_info *info;
+		struct ieee80211_hdr *hdr;
+		u16 fc;
 
 		u8 own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) entry, true,
 							  HW_DESC_OWN);
@@ -481,6 +569,10 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 						      HW_DESC_TXBUFF_ADDR)),
 				 skb->len, PCI_DMA_TODEVICE);
 
+		/* remove early mode header */
+		if (rtlpriv->rtlhal.b_earlymode_eanble)
+			skb_pull(skb, EM_HDR_LEN);
+
 		RT_TRACE(rtlpriv, (COMP_INTR | COMP_SEND), DBG_TRACE,
 			 ("new ring->idx:%d, "
 			  "free: skb_queue_len:%d, free: seq:%x\n",
@@ -488,6 +580,24 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 			  skb_queue_len(&ring->queue),
 			  *(u16 *) (skb->data + 22)));
 
+		if (prio == TXCMD_QUEUE) {
+			dev_kfree_skb(skb);
+			goto tx_status_ok;
+
+		}
+
+		/* for sw LPS, just after NULL skb send out, we can
+		 * sure AP kown we are sleeped, our we should not let
+		 * rf to sleep*/
+		hdr = (struct ieee80211_hdr *)(skb->data);
+		fc = le16_to_cpu(hdr->frame_control);
+		if (ieee80211_is_nullfunc(fc)) {
+			if (ieee80211_has_pm(fc))
+				rtlpriv->psc.state_inap = 1;
+			else
+				rtlpriv->psc.state_inap = 0;
+		}
+
 		info = IEEE80211_SKB_CB(skb);
 		ieee80211_tx_info_clear_status(info);
 
@@ -510,7 +620,7 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 					skb_get_queue_mapping
 					(skb));
 		}
-
+tx_status_ok:
 		skb = NULL;
 	}
 
@@ -585,20 +695,18 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			hdr = (struct ieee80211_hdr *)(skb->data);
 			fc = le16_to_cpu(hdr->frame_control);
 
-			if (!stats.b_crc) {
+			if (!stats.b_crc || !stats.b_hwerror) {
 				memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
 				       sizeof(rx_status));
 
-				if (is_broadcast_ether_addr(hdr->addr1))
+				if (is_broadcast_ether_addr(hdr->addr1)) {
 					;/*TODO*/
-				else {
-					if (is_multicast_ether_addr(hdr->addr1))
-						;/*TODO*/
-					else {
-						unicast = true;
-						rtlpriv->stats.rxbytesunicast +=
-						    skb->len;
-					}
+				} else if (is_multicast_ether_addr(hdr->addr1)) {
+					;/*TODO*/
+				} else {
+					unicast = true;
+					rtlpriv->stats.rxbytesunicast +=
+					    skb->len;
 				}
 
 				rtl_is_special_data(hw, skb, false);
@@ -612,8 +720,14 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 						    num_rx_inperiod++;
 				}
 
-				if (unlikely(!rtl_action_proc(hw, skb,
-				    false))) {
+				/* for sw lps */
+				rtl_swlps_beacon(hw,
+						 (void *)skb->data, skb->len);
+
+				rtl_recognize_peer(hw,
+						   (void *)skb->data, skb->len);
+
+				if (unlikely(!rtl_action_proc(hw, skb, false))) {
 					dev_kfree_skb_any(skb);
 				} else {
 					struct sk_buff *uskb = NULL;
@@ -690,80 +804,12 @@ done:
 
 }
 
-void _rtl_pci_tx_interrupt(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	int prio;
-
-	for (prio = 0; prio < RTL_PCI_MAX_TX_QUEUE_COUNT; prio++) {
-		struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[prio];
-
-		while (skb_queue_len(&ring->queue)) {
-			struct rtl_tx_desc *entry = &ring->desc[ring->idx];
-			struct sk_buff *skb;
-			struct ieee80211_tx_info *info;
-			u8 own;
-
-			/*
-			 *beacon packet will only use the first
-			 *descriptor defautly, and the own may not
-			 *be cleared by the hardware, and
-			 *beacon will free in prepare beacon
-			 */
-			if (prio == BEACON_QUEUE || prio == TXCMD_QUEUE ||
-			    prio == HCCA_QUEUE)
-				break;
-
-			own = (u8)rtlpriv->cfg->ops->get_desc((u8 *)entry,
-							       true,
-							       HW_DESC_OWN);
-
-			if (own)
-				break;
-
-			skb = __skb_dequeue(&ring->queue);
-			pci_unmap_single(rtlpci->pdev,
-					 le32_to_cpu(rtlpriv->cfg->ops->
-						     get_desc((u8 *) entry,
-						     true,
-						     HW_DESC_TXBUFF_ADDR)),
-					 skb->len, PCI_DMA_TODEVICE);
-
-			ring->idx = (ring->idx + 1) % ring->entries;
-
-			info = IEEE80211_SKB_CB(skb);
-			ieee80211_tx_info_clear_status(info);
-
-			info->flags |= IEEE80211_TX_STAT_ACK;
-			/*info->status.rates[0].count = 1; */
-
-			ieee80211_tx_status_irqsafe(hw, skb);
-
-			if ((ring->entries - skb_queue_len(&ring->queue))
-			    == 2 && prio != BEACON_QUEUE) {
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-					 ("more desc left, wake "
-					  "skb_queue@%d,ring->idx = %d,"
-					  "skb_queue_len = 0x%d\n",
-					  prio, ring->idx,
-					  skb_queue_len(&ring->queue)));
-
-				ieee80211_wake_queue(hw,
-						     skb_get_queue_mapping
-						     (skb));
-			}
-
-			skb = NULL;
-		}
-	}
-}
-
 static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 {
 	struct ieee80211_hw *hw = dev_id;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	unsigned long flags;
 	u32 inta = 0;
 	u32 intb = 0;
@@ -850,23 +896,36 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 		_rtl_pci_tx_isr(hw, VO_QUEUE);
 	}
 
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+		if (inta & rtlpriv->cfg->maps[RTL_IMR_COMDOK]) {
+			rtlpriv->link_info.num_tx_inperiod++;
+
+			RT_TRACE(rtlpriv, COMP_INTR, DBG_TRACE,
+					("CMD TX OK interrupt!\n"));
+			_rtl_pci_tx_isr(hw, TXCMD_QUEUE);
+		}
+	}
+
 	/*<2> Rx related */
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_ROK]) {
 		RT_TRACE(rtlpriv, COMP_INTR, DBG_TRACE, ("Rx ok interrupt!\n"));
-		tasklet_schedule(&rtlpriv->works.irq_tasklet);
+		_rtl_pci_rx_interrupt(hw);
 	}
 
 	if (unlikely(inta & rtlpriv->cfg->maps[RTL_IMR_RDU])) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 ("rx descriptor unavailable!\n"));
-		tasklet_schedule(&rtlpriv->works.irq_tasklet);
+		_rtl_pci_rx_interrupt(hw);
 	}
 
 	if (unlikely(inta & rtlpriv->cfg->maps[RTL_IMR_RXFOVW])) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING, ("rx overflow !\n"));
-		tasklet_schedule(&rtlpriv->works.irq_tasklet);
+		_rtl_pci_rx_interrupt(hw);
 	}
 
+	if (rtlpriv->rtlhal.b_earlymode_eanble)
+		tasklet_schedule(&rtlpriv->works.irq_tasklet);
+
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
 	return IRQ_HANDLED;
 
@@ -877,7 +936,7 @@ done:
 
 static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
 {
-	_rtl_pci_rx_interrupt(hw);
+	_rtl_pci_tx_chk_waitq(hw);
 }
 
 static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
@@ -890,9 +949,11 @@ static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
 	struct ieee80211_tx_info *info = NULL;
 	struct sk_buff *pskb = NULL;
 	struct rtl_tx_desc *pdesc = NULL;
+	struct rtl_tcb_desc tcb_desc;
 	unsigned int queue_index;
 	u8 temp_one = 1;
 
+	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 	ring = &rtlpci->tx_ring[BEACON_QUEUE];
 	pskb = __skb_dequeue(&ring->queue);
 	if (pskb)
@@ -909,11 +970,11 @@ static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
 
 	pdesc = &ring->desc[0];
 	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *) pdesc,
-					info, pskb, queue_index);
+		info, pskb, queue_index, &tcb_desc);
 
 	__skb_queue_tail(&ring->queue, pskb);
 
-	rtlpriv->cfg->ops->set_desc((u8 *) pdesc, true, HW_DESC_OWN,
+	rtlpriv->cfg->ops->set_desc((u8 *)pdesc, true, HW_DESC_OWN,
 				    (u8 *)&temp_one);
 
 	return;
@@ -951,7 +1012,6 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 
 	rtlpci->up_first_time = true;
 	rtlpci->being_init_adapter = false;
@@ -959,31 +1019,20 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 	rtlhal->hw = hw;
 	rtlpci->pdev = pdev;
 
-	ppsc->b_inactiveps = false;
-	ppsc->b_leisure_ps = true;
-	ppsc->b_fwctrl_lps = true;
-	ppsc->b_reg_fwctrl_lps = 3;
-	ppsc->reg_max_lps_awakeintvl = 5;
-
-	if (ppsc->b_reg_fwctrl_lps == 1)
-		ppsc->fwctrl_psmode = FW_PS_MIN_MODE;
-	else if (ppsc->b_reg_fwctrl_lps == 2)
-		ppsc->fwctrl_psmode = FW_PS_MAX_MODE;
-	else if (ppsc->b_reg_fwctrl_lps == 3)
-		ppsc->fwctrl_psmode = FW_PS_DTIM_MODE;
-
 	/*Tx/Rx related var */
 	_rtl_pci_init_trx_var(hw);
 
-	 /*IBSS*/ mac->beacon_interval = 100;
+	/*IBSS*/ mac->beacon_interval = 100;
 
-	 /*AMPDU*/ mac->min_space_cfg = 0;
+	/*AMPDU*/
+	mac->min_space_cfg = 0;
 	mac->max_mss_density = 0;
 	/*set sane AMPDU defaults */
 	mac->current_ampdu_density = 7;
 	mac->current_ampdu_factor = 3;
 
-	 /*QOS*/ rtlpci->acm_method = eAcmWay2_SW;
+	/*QOS*/
+	rtlpci->acm_method = eAcmWay2_SW;
 
 	/*task */
 	tasklet_init(&rtlpriv->works.irq_tasklet,
@@ -1273,9 +1322,10 @@ int rtl_pci_reset_trx_ring(struct ieee80211_hw *hw)
 	return 0;
 }
 
-unsigned int _rtl_mac_to_hwqueue(u16 fc,
+static unsigned int _rtl_mac_to_hwqueue(struct ieee80211_hw *hw, u16 fc,
 		unsigned int mac80211_queue_index)
 {
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	unsigned int hw_queue_index;
 
 	if (unlikely(ieee80211_is_beacon(fc))) {
@@ -1288,6 +1338,13 @@ unsigned int _rtl_mac_to_hwqueue(u16 fc,
 		goto out;
 	}
 
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+		if (ieee80211_is_nullfunc(fc)) {
+			hw_queue_index = HIGH_QUEUE;
+			goto out;
+		}
+	}
+
 	switch (mac80211_queue_index) {
 	case 0:
 		hw_queue_index = VO_QUEUE;
@@ -1296,7 +1353,7 @@ unsigned int _rtl_mac_to_hwqueue(u16 fc,
 		hw_queue_index = VI_QUEUE;
 		break;
 	case 2:
-		hw_queue_index = BE_QUEUE;;
+		hw_queue_index = BE_QUEUE;
 		break;
 	case 3:
 		hw_queue_index = BK_QUEUE;
@@ -1312,7 +1369,49 @@ out:
 	return hw_queue_index;
 }
 
-int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static bool rtl_pci_tx_chk_waitq_insert(struct ieee80211_hw *hw,
+					struct sk_buff *skb)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	unsigned int queue_index = skb_get_queue_mapping(skb);
+	unsigned int hw_queue = _rtl_mac_to_hwqueue(hw, fc, queue_index);
+	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[hw_queue];
+	u8 *qc = ieee80211_get_qos_ctl(hdr);
+	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+
+	if (!rtlhal->b_earlymode_eanble)
+		return 0;
+
+	if (!ieee80211_is_data_qos(fc))
+		return 0;
+
+	if (mac->tids[tid].agg.agg_state != RTL_AGG_ON)
+		return 0;
+
+	RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, ("===insert to skb_waitq "
+		 "for early mode desc_used_num[%d]:%d\n", queue_index,
+		 skb_queue_len(&ring->queue)));
+	if (skb_queue_len(&ring->queue) > mac->earlymode_threshold ||
+		!skb_queue_empty(&mac->skb_waitq[queue_index])) {
+		skb_queue_tail(&mac->skb_waitq[queue_index], skb);
+
+		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, ("insert to skb_waitq "
+			 "for early mode desc_used_num[%d]:%d\n",
+			  queue_index, skb_queue_len(&ring->queue)));
+
+		return 1;
+	}
+
+	return 0;
+}
+
+static int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+		struct rtl_tcb_desc *ptcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
@@ -1335,10 +1434,17 @@ int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	if (ieee80211_is_mgmt(fc))
 		rtl_tx_mgmt_proc(hw, skb);
+
+	if (rtlpriv->psc.sw_ps_enabled) {
+		if (ieee80211_is_data(fc) && !ieee80211_is_nullfunc(fc) &&
+			!ieee80211_has_pm(fc))
+			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+	}
+
 	rtl_action_proc(hw, skb, true);
 
 	queue_index = skb_get_queue_mapping(skb);
-	hw_queue = _rtl_mac_to_hwqueue(fc, queue_index);
+	hw_queue = _rtl_mac_to_hwqueue(hw, fc, queue_index);
 
 	if (is_multicast_ether_addr(pda_addr))
 		rtlpriv->stats.txbytesmulticast += skb->len;
@@ -1371,13 +1477,6 @@ int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		return skb->len;
 	}
 
-	/*
-	 *if(ieee80211_is_nullfunc(fc)) {
-	 *      spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
-	 *      return 1;
-	 *}
-	 */
-
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
@@ -1396,8 +1495,8 @@ int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (ieee80211_is_data(fc))
 		rtlpriv->cfg->ops->led_control(hw, LED_CTL_TX);
 
-	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *) pdesc,
-					info, skb, hw_queue);
+	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *)pdesc,
+			info, skb, hw_queue, ptcb_desc);
 
 	__skb_queue_tail(&ring->queue, skb);
 
@@ -1419,7 +1518,7 @@ int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 			  hw_queue, ring->idx, idx,
 			  skb_queue_len(&ring->queue)));
 
-		ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
+		ieee80211_stop_queue(hw, queue_index);
 	}
 
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
@@ -1429,7 +1528,7 @@ int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return 0;
 }
 
-void rtl_pci_deinit(struct ieee80211_hw *hw)
+static void rtl_pci_deinit(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -1444,7 +1543,7 @@ void rtl_pci_deinit(struct ieee80211_hw *hw)
 
 }
 
-int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
+static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int err;
@@ -1461,7 +1560,7 @@ int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
 	return 1;
 }
 
-int rtl_pci_start(struct ieee80211_hw *hw)
+static int rtl_pci_start(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -1496,7 +1595,7 @@ int rtl_pci_start(struct ieee80211_hw *hw)
 	return 0;
 }
 
-void rtl_pci_stop(struct ieee80211_hw *hw)
+static void rtl_pci_stop(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -1593,6 +1692,12 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 			 ("8192C PCI-E is found - "
 			  "vid/did=%x/%x\n", venderid, deviceid));
+	} else if (deviceid == RTL_PCI_8192DE_DID ||
+		   deviceid == RTL_PCI_8192DE_DID2) {
+		rtlhal->hw_type = HARDWARE_TYPE_RTL8192DE;
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+			 ("8192D PCI-E is found - "
+			  "vid/did=%x/%x\n", venderid, deviceid));
 	} else {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 ("Err: Unknown device -"
@@ -1601,6 +1706,25 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 		rtlhal->hw_type = RTL_DEFAULT_HARDWARE_TYPE;
 	}
 
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192DE) {
+		if (revisionid == 0 || revisionid == 1) {
+			if (revisionid == 0) {
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+					 ("Find 92DE MAC0.\n"));
+				rtlhal->interfaceindex = 0;
+			} else if (revisionid == 1) {
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+					 ("Find 92DE MAC1.\n"));
+					 rtlhal->interfaceindex = 1;
+			}
+		} else {
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+				 ("Unknown device - "
+				 "VendorID/DeviceID=%x/%x, Revision=%x\n",
+				 venderid, deviceid, revisionid));
+			rtlhal->interfaceindex = 0;
+		}
+	}
 	/*find bus info */
 	pcipriv->ndis_adapter.busnumber = pdev->bus->number;
 	pcipriv->ndis_adapter.devnumber = PCI_SLOT(pdev->devfn);
@@ -1626,12 +1750,12 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 		    PCI_SLOT(bridge_pdev->devfn);
 		pcipriv->ndis_adapter.pcibridge_funcnum =
 		    PCI_FUNC(bridge_pdev->devfn);
-		pcipriv->ndis_adapter.pcibridge_pciehdr_offset =
-		    pci_pcie_cap(bridge_pdev);
 		pcipriv->ndis_adapter.pcicfg_addrport =
 		    (pcipriv->ndis_adapter.pcibridge_busnum << 16) |
 		    (pcipriv->ndis_adapter.pcibridge_devnum << 11) |
 		    (pcipriv->ndis_adapter.pcibridge_funcnum << 8) | (1 << 31);
+		pcipriv->ndis_adapter.pcibridge_pciehdr_offset =
+		    pci_pcie_cap(bridge_pdev);
 		pcipriv->ndis_adapter.num4bytes =
 		    (pcipriv->ndis_adapter.pcibridge_pciehdr_offset + 0x10) / 4;
 
@@ -1714,6 +1838,11 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 	pcipriv = (void *)rtlpriv->priv;
 	pcipriv->dev.pdev = pdev;
 
+	/* init cfg & intf_ops */
+	rtlpriv->rtlhal.interface = INTF_PCI;
+	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_data);
+	rtlpriv->intf_ops = &rtl_pci_ops;
+
 	/*
 	 *init dbgp flags before all
 	 *other functions, because we will
@@ -1731,13 +1860,14 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 		return err;
 	}
 
-	pmem_start = pci_resource_start(pdev, 2);
-	pmem_len = pci_resource_len(pdev, 2);
-	pmem_flags = pci_resource_flags(pdev, 2);
+	pmem_start = pci_resource_start(pdev, rtlpriv->cfg->bar_id);
+	pmem_len = pci_resource_len(pdev, rtlpriv->cfg->bar_id);
+	pmem_flags = pci_resource_flags(pdev, rtlpriv->cfg->bar_id);
 
 	/*shared mem start */
 	rtlpriv->io.pci_mem_start =
-			(unsigned long)pci_iomap(pdev, 2, pmem_len);
+			(unsigned long)pci_iomap(pdev,
+			rtlpriv->cfg->bar_id, pmem_len);
 	if (rtlpriv->io.pci_mem_start == 0) {
 		RT_ASSERT(false, ("Can't map PCI mem\n"));
 		goto fail2;
@@ -1756,11 +1886,6 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 	pci_write_config_byte(pdev, 0x04, 0x06);
 	pci_write_config_byte(pdev, 0x04, 0x07);
 
-	/* init cfg & intf_ops */
-	rtlpriv->rtlhal.interface = INTF_PCI;
-	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_data);
-	rtlpriv->intf_ops = &rtl_pci_ops;
-
 	/* find adapter */
 	_rtl_pci_find_adapter(pdev, hw);
 
@@ -1812,6 +1937,8 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 			 ("failed to create sysfs device attributes\n"));
 		goto fail3;
 	}
+	/* add for prov */
+	rtl_proc_add_one(hw);
 
 	/*init rfkill */
 	rtl_init_rfkill(hw);
@@ -1864,6 +1991,9 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 
 	sysfs_remove_group(&pdev->dev.kobj, &rtl_attribute_group);
 
+	/* add for prov */
+	rtl_proc_remove_one(hw);
+
 	/*ieee80211_unregister_hw will call ops_stop */
 	if (rtlmac->mac80211_registered == 1) {
 		ieee80211_unregister_hw(hw);
@@ -1878,7 +2008,6 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 
 	rtl_pci_deinit(hw);
 	rtl_deinit_core(hw);
-	rtlpriv->cfg->ops->deinit_sw_leds(hw);
 	_rtl_pci_io_handler_release(hw);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 
@@ -1893,6 +2022,9 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 	}
 
 	pci_disable_device(pdev);
+
+	rtl_pci_disable_aspm(hw);
+
 	pci_set_drvdata(pdev, NULL);
 
 	ieee80211_free_hw(hw);
@@ -1916,10 +2048,15 @@ no need to call hw_disable here.
 ****************************************/
 int rtl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtlpriv->cfg->ops->hw_suspend(hw);
+	rtl_deinit_rfkill(hw);
+
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
-
 	return 0;
 }
 EXPORT_SYMBOL(rtl_pci_suspend);
@@ -1927,6 +2064,8 @@ EXPORT_SYMBOL(rtl_pci_suspend);
 int rtl_pci_resume(struct pci_dev *pdev)
 {
 	int ret;
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	pci_set_power_state(pdev, PCI_D0);
 	ret = pci_enable_device(pdev);
@@ -1937,16 +2076,21 @@ int rtl_pci_resume(struct pci_dev *pdev)
 
 	pci_restore_state(pdev);
 
+	rtlpriv->cfg->ops->hw_resume(hw);
+	rtl_init_rfkill(hw);
 	return 0;
 }
 EXPORT_SYMBOL(rtl_pci_resume);
 
 struct rtl_intf_ops rtl_pci_ops = {
+	.read_efuse_byte = read_efuse_byte,
 	.adapter_start = rtl_pci_start,
 	.adapter_stop = rtl_pci_stop,
 	.adapter_tx = rtl_pci_tx,
 	.reset_trx_ring = rtl_pci_reset_trx_ring,
+	.waitq_insert = rtl_pci_tx_chk_waitq_insert,
 
 	.disable_aspm = rtl_pci_disable_aspm,
 	.enable_aspm = rtl_pci_enable_aspm,
 };
+
diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index d36a669..e823c6b 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -102,8 +102,8 @@
 #define RTL_PCI_8191CE_DID	0x8177	/*8192ce */
 #define RTL_PCI_8188CE_DID	0x8176	/*8192ce */
 #define RTL_PCI_8192CU_DID	0x8191	/*8192ce */
-#define RTL_PCI_8192DE_DID	0x092D	/*8192ce */
-#define RTL_PCI_8192DU_DID	0x092D	/*8192ce */
+#define RTL_PCI_8192DE_DID	0x8193	/*8192de */
+#define RTL_PCI_8192DE_DID2	0x002B	/*92DE	 */
 
 /*8192 support 16 pages of IO registers*/
 #define RTL_MEM_MAPPED_IO_RANGE_8190PCI		0x1000
@@ -122,13 +122,18 @@
 
 enum pci_bridge_vendor {
 	PCI_BRIDGE_VENDOR_INTEL = 0x0,	/*0b'0000,0001 */
-	PCI_BRIDGE_VENDOR_ATI,		/*0b'0000,0010*/
-	PCI_BRIDGE_VENDOR_AMD,		/*0b'0000,0100*/
-	PCI_BRIDGE_VENDOR_SIS,		/*0b'0000,1000*/
-	PCI_BRIDGE_VENDOR_UNKNOWN,	/*0b'0100,0000*/
+	PCI_BRIDGE_VENDOR_ATI,			/*0b'0000,0010*/
+	PCI_BRIDGE_VENDOR_AMD,			/*0b'0000,0100*/
+	PCI_BRIDGE_VENDOR_SIS,			/*0b'0000,1000*/
+	PCI_BRIDGE_VENDOR_UNKNOWN,		/*0b'0100,0000*/
 	PCI_BRIDGE_VENDOR_MAX,
 };
 
+struct rtl_pci_capabilities_header {
+	u8 capability_id;
+	u8 next;
+};
+
 struct rtl_rx_desc {
 	u32 dword[8];
 } __packed;
@@ -161,6 +166,7 @@ struct rtl_pci {
 
 	bool driver_is_goingto_unload;
 	bool up_first_time;
+	bool bfirst_init;
 	bool being_init_adapter;
 	bool irq_enabled;
 
@@ -197,6 +203,9 @@ struct rtl_pci {
 
 	/*QOS & EDCA */
 	enum acm_method acm_method;
+
+	u16 shortretry_limit;
+	u16 longretry_limit;
 };
 
 struct mp_adapter {
@@ -227,6 +236,7 @@ struct rtl_pci_priv {
 	struct rtl_pci dev;
 	struct mp_adapter ndis_adapter;
 	struct rtl_led_ctl ledctl;
+	struct bt_coexist_info bt_coexist;
 };
 
 #define rtl_pcipriv(hw)		(((struct rtl_pci_priv *)(rtl_priv(hw))->priv))
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index d2326c1..3a1d8c4 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -195,10 +195,10 @@ static void _rtl_ps_inactive_ps(struct ieee80211_hw *hw)
 
 	if (ppsc->inactive_pwrstate == ERFON && rtlhal->interface == INTF_PCI) {
 		if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&
-		    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM) &&
+		    RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM) &&
 		    rtlhal->interface == INTF_PCI) {
 			rtlpriv->intf_ops->disable_aspm(hw);
-			RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
+			RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 		}
 	}
 
@@ -207,9 +207,10 @@ static void _rtl_ps_inactive_ps(struct ieee80211_hw *hw)
 
 	if (ppsc->inactive_pwrstate == ERFOFF &&
 	    rtlhal->interface == INTF_PCI) {
-		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) {
+		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
+			!RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
 			rtlpriv->intf_ops->enable_aspm(hw);
-			RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
+			RT_SET_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 		}
 	}
 
@@ -233,6 +234,9 @@ void rtl_ips_nic_off_wq_callback(void *data)
 		return;
 	}
 
+	if (mac->link_state > MAC80211_NOLINK)
+		return;
+
 	if (is_hal_stop(rtlhal))
 		return;
 
@@ -300,7 +304,11 @@ void rtl_ips_nic_on(struct ieee80211_hw *hw)
 			ppsc->inactive_pwrstate = ERFON;
 			ppsc->b_in_powersavemode = false;
 
+			/* _rtl_ps_inactive will call routines that sleep.
+			 * restore interrupts first */
+			spin_unlock_irqrestore(&rtlpriv->locks.ips_lock, flags);
 			_rtl_ps_inactive_ps(hw);
+			return;
 		}
 	}
 
@@ -370,8 +378,7 @@ static void rtl_lps_set_psmode(struct ieee80211_hw *hw, u8 rt_psmode)
 	 *   mode and set RPWM to turn RF on.
 	 */
 
-	if ((ppsc->b_fwctrl_lps) && (ppsc->b_leisure_ps) &&
-	     ppsc->report_linked) {
+	if ((ppsc->b_fwctrl_lps) && ppsc->report_linked) {
 		bool b_fw_current_inps;
 		if (ppsc->dot11_psmode == EACTIVE) {
 			RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
@@ -425,7 +432,7 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	unsigned long flag;
 
-	if (!(ppsc->b_fwctrl_lps && ppsc->b_leisure_ps))
+	if (!ppsc->b_fwctrl_lps)
 		return;
 
 	if (rtlpriv->sec.being_setkey)
@@ -446,17 +453,16 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 
 	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
 
-	if (ppsc->b_leisure_ps) {
-		/* Idle for a while if we connect to AP a while ago. */
-		if (mac->cnt_after_linked >= 2) {
-			if (ppsc->dot11_psmode == EACTIVE) {
-				RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+	/* Idle for a while if we connect to AP a while ago. */
+	if (mac->cnt_after_linked >= 2) {
+		if (ppsc->dot11_psmode == EACTIVE) {
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
 					("Enter 802.11 power save mode...\n"));
 
-				rtl_lps_set_psmode(hw, EAUTOPS);
-			}
+			rtl_lps_set_psmode(hw, EAUTOPS);
 		}
 	}
+
 	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 }
 
@@ -470,17 +476,17 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 
 	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
 
-	if (ppsc->b_fwctrl_lps && ppsc->b_leisure_ps) {
+	if (ppsc->b_fwctrl_lps) {
 		if (ppsc->dot11_psmode != EACTIVE) {
 
 			/*FIX ME */
 			rtlpriv->cfg->ops->enable_interrupt(hw);
 
 			if (ppsc->reg_rfps_level & RT_RF_LPS_LEVEL_ASPM &&
-			    RT_IN_PS_LEVEL(ppsc, RT_RF_LPS_LEVEL_ASPM) &&
+			    RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM) &&
 			    rtlhal->interface == INTF_PCI) {
 				rtlpriv->intf_ops->disable_aspm(hw);
-				RT_CLEAR_PS_LEVEL(ppsc, RT_RF_LPS_LEVEL_ASPM);
+				RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 			}
 
 			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
@@ -491,3 +497,211 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 	}
 	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 }
+
+/* For sw LPS*/
+void rtl_swlps_beacon(struct ieee80211_hw *hw, void *data, unsigned int len)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ieee80211_hdr *hdr = (void *) data;
+	struct ieee80211_tim_ie *tim_ie;
+	u8 *tim;
+	u8 tim_len;
+	bool u_buffed;
+	bool m_buffed;
+
+	if (!rtlpriv->psc.b_swctrl_lps)
+		return;
+
+	if (rtlpriv->mac80211.link_state != MAC80211_LINKED)
+		return;
+
+	if (!rtlpriv->psc.sw_ps_enabled)
+		return;
+
+	if (rtlpriv->psc.b_fwctrl_lps)
+		return;
+
+	if (likely(!(hw->conf.flags & IEEE80211_CONF_PS)))
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
+	rtlpriv->psc.last_beacon = jiffies;
+
+	tim = rtl_find_ie(data, len - FCS_LEN, WLAN_EID_TIM);
+	if (!tim)
+		return;
+
+	if (tim[1] < sizeof(*tim_ie))
+		return;
+
+	tim_len = tim[1];
+	tim_ie = (struct ieee80211_tim_ie *) &tim[2];
+
+	if (!WARN_ON_ONCE(!hw->conf.ps_dtim_period))
+		rtlpriv->psc.dtim_counter = tim_ie->dtim_count;
+
+	/* Check whenever the PHY can be turned off again. */
+
+	/* 1. What about buffered unicast traffic for our AID? */
+	u_buffed = ieee80211_check_tim(tim_ie, tim_len,
+				       rtlpriv->mac80211.assoc_id);
+
+	/* 2. Maybe the AP wants to send multicast/broadcast data? */
+	m_buffed = tim_ie->bitmap_ctrl & 0x01;
+	rtlpriv->psc.multi_buffered = m_buffed;
+
+	/* unicast will process by mac80211 through
+	 * set ~IEEE80211_CONF_PS, So we just check
+	 * multicast frames here */
+	if (!m_buffed) {/*&&) {// !rtlpriv->psc.tx_doing) { */
+		/* back to low-power land. and delay is
+		 * prevent null power save frame tx fail */
+		queue_delayed_work(rtlpriv->works.rtl_wq,
+				&rtlpriv->works.ps_work, MSECS(5));
+	} else {
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG, ("u_bufferd: %x, "
+				"m_buffered: %x\n", u_buffed, m_buffed));
+	}
+}
+
+void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	unsigned long flag;
+
+	if (!rtlpriv->psc.b_swctrl_lps)
+		return;
+	if (mac->link_state != MAC80211_LINKED)
+		return;
+
+	if (ppsc->reg_rfps_level & RT_RF_LPS_LEVEL_ASPM &&
+		RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
+		rtlpriv->intf_ops->disable_aspm(hw);
+		RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
+	}
+
+	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS, false);
+	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+}
+
+void rtl_swlps_rfon_wq_callback(void *data)
+{
+	struct rtl_works *rtlworks =
+	    container_of_dwork_rtl(data, struct rtl_works, ps_rfon_wq);
+	struct ieee80211_hw *hw = rtlworks->hw;
+
+	rtl_swlps_rf_awake(hw);
+}
+
+void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	unsigned long flag;
+	u8 sleep_intv;
+
+	if (!rtlpriv->psc.sw_ps_enabled)
+		return;
+
+	if ((rtlpriv->sec.being_setkey) ||
+	    (mac->opmode == NL80211_IFTYPE_ADHOC))
+		return;
+
+	/*sleep after linked 10s, to let DHCP and 4-way handshake ok enough!! */
+	if ((mac->link_state != MAC80211_LINKED) || (mac->cnt_after_linked < 5))
+		return;
+
+	if (rtlpriv->link_info.b_busytraffic)
+		return;
+
+	spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
+	if (rtlpriv->psc.rfchange_inprogress) {
+		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+		return;
+	}
+	spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
+
+	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS, false);
+	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
+
+	if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
+		!RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
+		rtlpriv->intf_ops->enable_aspm(hw);
+		RT_SET_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
+	}
+
+	/* here is power save alg, when this beacon is DTIM
+	 * we will set sleep time to dtim_period * n;
+	 * when this beacon is not DTIM, we will set sleep
+	 * time to sleep_intv = rtlpriv->psc.dtim_counter or
+	 * MAX_SW_LPS_SLEEP_INTV(default set to 5) */
+
+	if (rtlpriv->psc.dtim_counter == 0) {
+		if (hw->conf.ps_dtim_period == 1)
+			sleep_intv = hw->conf.ps_dtim_period * 2;
+		else
+			sleep_intv = hw->conf.ps_dtim_period;
+	} else {
+		sleep_intv = rtlpriv->psc.dtim_counter;
+	}
+
+	if (sleep_intv > MAX_SW_LPS_SLEEP_INTV)
+		sleep_intv = MAX_SW_LPS_SLEEP_INTV;
+
+	/* this print should always be dtim_conter = 0 &
+	 * sleep  = dtim_period, that meaons, we should
+	 * awake before every dtim */
+	RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG,
+		 ("dtim_counter:%x will sleep :%d"
+		 " beacon_intv\n", rtlpriv->psc.dtim_counter, sleep_intv));
+
+	/* we tested that 40ms is enough for sw & hw sw delay */
+	queue_delayed_work(rtlpriv->works.rtl_wq, &rtlpriv->works.ps_rfon_wq,
+			MSECS(sleep_intv * mac->vif->bss_conf.beacon_int - 40));
+}
+
+
+void rtl_swlps_wq_callback(void *data)
+{
+	struct rtl_works *rtlworks = container_of_dwork_rtl(data,
+					 struct rtl_works,
+					 ps_work);
+	struct ieee80211_hw *hw = rtlworks->hw;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	bool ps = false;
+
+	ps = (hw->conf.flags & IEEE80211_CONF_PS);
+
+	/* we can sleep after ps null send ok */
+	if (rtlpriv->psc.state_inap) {
+		rtl_swlps_rf_sleep(hw);
+
+		if (rtlpriv->psc.state && !ps) {
+			rtlpriv->psc.sleep_ms = jiffies_to_msecs(jiffies -
+					rtlpriv->psc.last_action);
+		}
+
+		if (ps)
+			rtlpriv->psc.last_slept = jiffies;
+
+		rtlpriv->psc.last_action = jiffies;
+		rtlpriv->psc.state = ps;
+	}
+}
+
diff --git a/drivers/net/wireless/rtlwifi/ps.h b/drivers/net/wireless/rtlwifi/ps.h
index ae56da8..c738ceb 100644
--- a/drivers/net/wireless/rtlwifi/ps.h
+++ b/drivers/net/wireless/rtlwifi/ps.h
@@ -30,6 +30,8 @@
 #ifndef __REALTEK_RTL_PCI_PS_H__
 #define __REALTEK_RTL_PCI_PS_H__
 
+#define MAX_SW_LPS_SLEEP_INTV	5
+
 bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 			 enum rf_pwrstate state_toset, u32 changesource,
 			 bool protect_or_not);
@@ -40,4 +42,12 @@ void rtl_ips_nic_on(struct ieee80211_hw *hw);
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
+
diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index 9163410..5fe7687 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -35,20 +35,15 @@
  *Finds the highest rate index we can use
  *if skb is special data like DHCP/EAPOL, we set should
  *it to lowest rate CCK_1M, otherwise we set rate to
- *CCK11M or OFDM_54M based on wireless mode.
+ *highest rate based on wireless mode used for iwconfig
+ *show Tx rate.
  */
 static u8 _rtl_rc_get_highest_rix(struct rtl_priv *rtlpriv,
 				  struct sk_buff *skb, bool not_data)
 {
 	struct rtl_mac *rtlmac = rtl_mac(rtlpriv);
-
-	/*
-	 *mgt use 1M, although we have check it
-	 *before this function use rate_control_send_low,
-	 *we still check it here
-	 */
-	if (not_data)
-		return rtlpriv->cfg->maps[RTL_RC_CCK_RATE1M];
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 
 	/*
 	 *this rate is no use for true rate, firmware
@@ -57,13 +52,31 @@ static u8 _rtl_rc_get_highest_rix(struct rtl_priv *rtlpriv,
 	 *2.in rtl_get_tcb_desc when we check rate is
 	 *      1M we will not use FW rate but user rate.
 	 */
-	if (rtl_is_special_data(rtlpriv->mac80211.hw, skb, true)) {
-		return rtlpriv->cfg->maps[RTL_RC_CCK_RATE1M];
+	if (rtl_is_special_data(rtlpriv->mac80211.hw, skb, true) ||
+			not_data) {
+		return 0;
 	} else {
-		if (rtlmac->mode == WIRELESS_MODE_B)
-			return rtlpriv->cfg->maps[RTL_RC_CCK_RATE11M];
-		else
-			return rtlpriv->cfg->maps[RTL_RC_OFDM_RATE54M];
+		if (rtlhal->current_bandtype == BAND_ON_2_4G) {
+			if (rtlmac->mode == WIRELESS_MODE_B) {
+				return B_MODE_MAX_RIX;
+			} else if (rtlmac->mode == WIRELESS_MODE_G) {
+				return G_MODE_MAX_RIX;
+			} else {
+				if (get_rf_type(rtlphy) != RF_2T2R)
+					return N_MODE_MCS7_RIX;
+				else
+					return N_MODE_MCS15_RIX;
+			}
+		} else {
+			if (rtlmac->mode == WIRELESS_MODE_A) {
+				return A_MODE_MAX_RIX;
+			} else {
+				if (get_rf_type(rtlphy) != RF_2T2R)
+					return N_MODE_MCS7_RIX;
+				else
+					return N_MODE_MCS15_RIX;
+			}
+		}
 	}
 }
 
@@ -76,7 +89,7 @@ static void _rtl_rc_rate_set_series(struct rtl_priv *rtlpriv,
 	struct rtl_mac *mac = rtl_mac(rtlpriv);
 
 	rate->count = tries;
-	rate->idx = (rix > 0x2) ? rix : 0x2;
+	rate->idx = rix >= 0x00 ? rix : 0x00;
 
 	if (!not_data) {
 		if (txrc->short_preamble)
diff --git a/drivers/net/wireless/rtlwifi/rc.h b/drivers/net/wireless/rtlwifi/rc.h
index b4667c0..8fccc55 100644
--- a/drivers/net/wireless/rtlwifi/rc.h
+++ b/drivers/net/wireless/rtlwifi/rc.h
@@ -30,6 +30,14 @@
 #ifndef __RTL_RC_H__
 #define __RTL_RC_H__
 
+#define B_MODE_MAX_RIX 3
+#define G_MODE_MAX_RIX 11
+#define A_MODE_MAX_RIX 7
+
+/* in mac80211 mcs0-mcs15 is idx0-idx15*/
+#define N_MODE_MCS7_RIX 7
+#define N_MODE_MCS15_RIX 15
+
 struct rtl_rate_priv {
 	u8 cur_ratetab_idx;
 	u8 ht_cap;
diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
index 3336ca9..aebdf2c 100644
--- a/drivers/net/wireless/rtlwifi/regd.c
+++ b/drivers/net/wireless/rtlwifi/regd.c
@@ -66,31 +66,83 @@ static struct country_code_to_enum_rd allCountries[] = {
 	NL80211_RRF_PASSIVE_SCAN | \
 	NL80211_RRF_NO_OFDM)
 
+/* 5G chan 36 - chan 64*/
+#define RTL819x_5GHZ_5150_5350	\
+	REG_RULE(5150-10, 5350+10, 40, 0, 30, \
+	NL80211_RRF_PASSIVE_SCAN | \
+	NL80211_RRF_NO_IBSS)
+
+/* 5G chan 100 - chan 165*/
+#define RTL819x_5GHZ_5470_5850	\
+	REG_RULE(5470-10, 5850+10, 40, 0, 30, \
+	NL80211_RRF_PASSIVE_SCAN | \
+	NL80211_RRF_NO_IBSS)
+
+/* 5G chan 149 - chan 165*/
+#define RTL819x_5GHZ_5725_5850	\
+	REG_RULE(5725-10, 5850+10, 40, 0, 30, \
+	NL80211_RRF_PASSIVE_SCAN | \
+	NL80211_RRF_NO_IBSS)
+
+#define RTL819x_5GHZ_ALL	\
+	(RTL819x_5GHZ_5150_5350, RTL819x_5GHZ_5470_5850)
+
 static const struct ieee80211_regdomain rtl_regdom_11 = {
 	.n_reg_rules = 1,
 	.alpha2 = "99",
 	.reg_rules = {
 		      RTL819x_2GHZ_CH01_11,
-	}
+		      }
+};
+
+static const struct ieee80211_regdomain rtl_regdom_12_13 = {
+	.n_reg_rules = 2,
+	.alpha2 = "99",
+	.reg_rules = {
+		      RTL819x_2GHZ_CH01_11,
+			  RTL819x_2GHZ_CH12_13,
+		      }
 };
 
-static const struct ieee80211_regdomain rtl_regdom_global = {
+static const struct ieee80211_regdomain rtl_regdom_no_midband = {
 	.n_reg_rules = 3,
 	.alpha2 = "99",
 	.reg_rules = {
 		      RTL819x_2GHZ_CH01_11,
-		      RTL819x_2GHZ_CH12_13,
-		      RTL819x_2GHZ_CH14,
-	}
+			  RTL819x_5GHZ_5150_5350,
+			  RTL819x_5GHZ_5725_5850,
+		      }
 };
 
-static const struct ieee80211_regdomain rtl_regdom_world = {
-	.n_reg_rules = 2,
+static const struct ieee80211_regdomain rtl_regdom_60_64 = {
+	.n_reg_rules = 3,
 	.alpha2 = "99",
 	.reg_rules = {
 		      RTL819x_2GHZ_CH01_11,
-		      RTL819x_2GHZ_CH12_13,
-	}
+			  RTL819x_2GHZ_CH12_13,
+			  RTL819x_5GHZ_5725_5850,
+		      }
+};
+
+static const struct ieee80211_regdomain rtl_regdom_14_60_64 = {
+	.n_reg_rules = 4,
+	.alpha2 = "99",
+	.reg_rules = {
+		      RTL819x_2GHZ_CH01_11,
+			  RTL819x_2GHZ_CH12_13,
+			  RTL819x_2GHZ_CH14,
+			  RTL819x_5GHZ_5725_5850,
+		      }
+};
+
+static const struct ieee80211_regdomain rtl_regdom_14 = {
+	.n_reg_rules = 3,
+	.alpha2 = "99",
+	.reg_rules = {
+		      RTL819x_2GHZ_CH01_11,
+			  RTL819x_2GHZ_CH12_13,
+			  RTL819x_2GHZ_CH14,
+		      }
 };
 
 static bool _rtl_is_radar_freq(u16 center_freq)
@@ -138,14 +190,14 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 
 				if (!(reg_rule->flags & NL80211_RRF_NO_IBSS))
 					ch->flags &= ~IEEE80211_CHAN_NO_IBSS;
-				if (!(reg_rule->
-				     flags & NL80211_RRF_PASSIVE_SCAN))
+				if (!(reg_rule->flags &
+				      NL80211_RRF_PASSIVE_SCAN))
 					ch->flags &=
 					    ~IEEE80211_CHAN_PASSIVE_SCAN;
 			} else {
 				if (ch->beacon_found)
 					ch->flags &= ~(IEEE80211_CHAN_NO_IBSS |
-						  IEEE80211_CHAN_PASSIVE_SCAN);
+						   IEEE80211_CHAN_PASSIVE_SCAN);
 			}
 		}
 	}
@@ -162,6 +214,8 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	u32 bandwidth = 0;
 	int r;
 
+	if (!wiphy->bands[IEEE80211_BAND_2GHZ])
+		return;
 	sband = wiphy->bands[IEEE80211_BAND_2GHZ];
 
 	/*
@@ -288,29 +342,30 @@ static int _rtl_reg_notifier_apply(struct wiphy *wiphy,
 }
 
 static const struct ieee80211_regdomain *_rtl_regdomain_select(
-					       struct rtl_regulatory *reg)
+				       struct rtl_regulatory *reg)
 {
 	switch (reg->country_code) {
 	case COUNTRY_CODE_FCC:
+		return &rtl_regdom_no_midband;
 	case COUNTRY_CODE_IC:
 		return &rtl_regdom_11;
 	case COUNTRY_CODE_ETSI:
+	case COUNTRY_CODE_TELEC_NETGEAR:
+		return &rtl_regdom_60_64;
 	case COUNTRY_CODE_SPAIN:
 	case COUNTRY_CODE_FRANCE:
 	case COUNTRY_CODE_ISRAEL:
-	case COUNTRY_CODE_TELEC_NETGEAR:
-		return &rtl_regdom_world;
+	case COUNTRY_CODE_WORLD_WIDE_13:
+		return &rtl_regdom_12_13;
 	case COUNTRY_CODE_MKK:
 	case COUNTRY_CODE_MKK1:
 	case COUNTRY_CODE_TELEC:
 	case COUNTRY_CODE_MIC:
-		return &rtl_regdom_global;
+		return &rtl_regdom_14_60_64;
 	case COUNTRY_CODE_GLOBAL_DOMAIN:
-		return &rtl_regdom_global;
-	case COUNTRY_CODE_WORLD_WIDE_13:
-		return &rtl_regdom_world;
+		return &rtl_regdom_14;
 	default:
-		return &rtl_regdom_world;
+		return &rtl_regdom_no_midband;
 	}
 }
 
@@ -355,8 +410,8 @@ int rtl_regd_init(struct ieee80211_hw *hw,
 	if (wiphy == NULL || &rtlpriv->regd == NULL)
 		return -EINVAL;
 
-	/* force the channel plan to world wide 13 */
-	rtlpriv->regd.country_code = COUNTRY_CODE_WORLD_WIDE_13;
+	/* init country_code from efuse channel plan */
+	rtlpriv->regd.country_code = rtlpriv->efuse.channel_plan;
 
 	RT_TRACE(rtlpriv, COMP_REGD, DBG_TRACE,
 		 (KERN_DEBUG "rtl: EEPROM regdomain: 0x%0x\n",
@@ -373,8 +428,8 @@ int rtl_regd_init(struct ieee80211_hw *hw,
 	country = _rtl_regd_find_country(rtlpriv->regd.country_code);
 
 	if (country) {
-		rtlpriv->regd.alpha2[0] = country->isoName[0];
-		rtlpriv->regd.alpha2[1] = country->isoName[1];
+		rtlpriv->regd.alpha2[0] = country->iso_name[0];
+		rtlpriv->regd.alpha2[1] = country->iso_name[1];
 	} else {
 		rtlpriv->regd.alpha2[0] = '0';
 		rtlpriv->regd.alpha2[1] = '0';
diff --git a/drivers/net/wireless/rtlwifi/regd.h b/drivers/net/wireless/rtlwifi/regd.h
index 4cdbc4a..d231189 100644
--- a/drivers/net/wireless/rtlwifi/regd.h
+++ b/drivers/net/wireless/rtlwifi/regd.h
@@ -32,7 +32,7 @@
 
 struct country_code_to_enum_rd {
 	u16 countrycode;
-	const char *isoName;
+	const char *iso_name;
 };
 
 enum country_code_type_t {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
index 62e7c64..cf4d8d9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
@@ -29,6 +29,7 @@
 
 #include "../wifi.h"
 #include "../base.h"
+#include "../pci.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
@@ -644,23 +645,42 @@ void rtl92c_dm_init_edca_turbo(struct ieee80211_hw *hw)
 static void rtl92c_dm_check_edca_turbo(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+
 	static u64 last_txok_cnt;
 	static u64 last_rxok_cnt;
-	u64 cur_txok_cnt;
-	u64 cur_rxok_cnt;
+	static u32 last_bt_edca_ul;
+	static u32 last_bt_edca_dl;
+	u64 cur_txok_cnt = 0;
+	u64 cur_rxok_cnt = 0;
 	u32 edca_be_ul = 0x5ea42b;
 	u32 edca_be_dl = 0x5ea42b;
+	bool b_bt_change_edca = false;
 
-	if (mac->opmode == NL80211_IFTYPE_ADHOC)
-		goto dm_checkedcaturbo_exit;
+	if ((last_bt_edca_ul != rtlpcipriv->bt_coexist.bt_edca_ul) ||
+	    (last_bt_edca_dl != rtlpcipriv->bt_coexist.bt_edca_dl)) {
+		rtlpriv->dm.bcurrent_turbo_edca = false;
+		last_bt_edca_ul = rtlpcipriv->bt_coexist.bt_edca_ul;
+		last_bt_edca_dl = rtlpcipriv->bt_coexist.bt_edca_dl;
+	}
+
+	if (rtlpcipriv->bt_coexist.bt_edca_ul != 0) {
+		edca_be_ul = rtlpcipriv->bt_coexist.bt_edca_ul;
+		b_bt_change_edca = true;
+	}
+
+	if (rtlpcipriv->bt_coexist.bt_edca_dl != 0) {
+		edca_be_ul = rtlpcipriv->bt_coexist.bt_edca_dl;
+		b_bt_change_edca = true;
+	}
 
 	if (mac->link_state != MAC80211_LINKED) {
 		rtlpriv->dm.bcurrent_turbo_edca = false;
 		return;
 	}
 
-	if (!mac->ht_enable) {	/*FIX MERGE */
+	if ((!mac->ht_enable) && (!rtlpcipriv->bt_coexist.bt_coexistence)) {
 		if (!(edca_be_ul & 0xffff0000))
 			edca_be_ul |= 0x005e0000;
 
@@ -668,10 +688,12 @@ static void rtl92c_dm_check_edca_turbo(struct ieee80211_hw *hw)
 			edca_be_dl |= 0x005e0000;
 	}
 
-	if ((!rtlpriv->dm.bis_any_nonbepkts) &&
-	    (!rtlpriv->dm.b_disable_framebursting)) {
+	if ((b_bt_change_edca) || ((!rtlpriv->dm.bis_any_nonbepkts) &&
+	     (!rtlpriv->dm.b_disable_framebursting))) {
+
 		cur_txok_cnt = rtlpriv->stats.txbytesunicast - last_txok_cnt;
 		cur_rxok_cnt = rtlpriv->stats.rxbytesunicast - last_rxok_cnt;
+
 		if (cur_rxok_cnt > 4 * cur_txok_cnt) {
 			if (!rtlpriv->dm.bis_cur_rdlstate ||
 			    !rtlpriv->dm.bcurrent_turbo_edca) {
@@ -700,7 +722,6 @@ static void rtl92c_dm_check_edca_turbo(struct ieee80211_hw *hw)
 		}
 	}
 
-dm_checkedcaturbo_exit:
 	rtlpriv->dm.bis_any_nonbepkts = false;
 	last_txok_cnt = rtlpriv->stats.txbytesunicast;
 	last_rxok_cnt = rtlpriv->stats.rxbytesunicast;
@@ -715,14 +736,14 @@ static void rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 thermalvalue, delta, delta_lck, delta_iqk;
 	long ele_a, ele_d, temp_cck, val_x, value32;
-	long val_y, ele_c;
-	u8 ofdm_index[2], cck_index, ofdm_index_old[2], cck_index_old;
+	long val_y, ele_c = 0;
+	u8 ofdm_index[2], cck_index, ofdm_index_old[2], cck_index_old = 0;
 	int i;
 	bool is2t = IS_92C_SERIAL(rtlhal->version);
 	u8 txpwr_level[2] = {0, 0};
 	u8 ofdm_min_index = 6, rf;
 
-	rtlpriv->dm.btxpower_trackingInit = true;
+	rtlpriv->dm.btxpower_trackinginit = true;
 	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 		 ("rtl92c_dm_txpower_tracking_callback_thermalmeter\n"));
 
@@ -767,11 +788,11 @@ static void rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
 					ofdm_index_old[1] = (u8) i;
 
 					RT_TRACE(rtlpriv, COMP_POWER_TRACKING,
-					   DBG_LOUD,
-					   ("Initial pathB ele_d reg0x%x = "
-					   "0x%lx, ofdm_index=0x%x\n",
-					   ROFDM0_XBTXIQIMBALANCE, ele_d,
-					   ofdm_index_old[1]));
+						 DBG_LOUD,
+						 ("Initial pathB ele_d reg0x%x = "
+						  "0x%lx, ofdm_index=0x%x\n",
+						  ROFDM0_XBTXIQIMBALANCE, ele_d,
+						  ofdm_index_old[1]));
 					break;
 				}
 			}
@@ -838,12 +859,12 @@ static void rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
 		    (rtlpriv->dm.thermalvalue_iqk - thermalvalue);
 
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-			("Readback Thermal Meter = 0x%x pre thermal meter 0x%x "
-			 "eeprom_thermalmeter 0x%x delta 0x%x "
-			 "delta_lck 0x%x delta_iqk 0x%x\n",
-			 thermalvalue, rtlpriv->dm.thermalvalue,
-			 rtlefuse->eeprom_thermalmeter, delta, delta_lck,
-			 delta_iqk));
+			 ("Readback Thermal Meter = 0x%x pre thermal meter 0x%x "
+			  "eeprom_thermalmeter 0x%x delta 0x%x "
+			  "delta_lck 0x%x delta_iqk 0x%x\n",
+			  thermalvalue, rtlpriv->dm.thermalvalue,
+			  rtlefuse->eeprom_thermalmeter, delta, delta_lck,
+			  delta_iqk));
 
 		if (delta_lck > 1) {
 			rtlpriv->dm.thermalvalue_lck = thermalvalue;
@@ -1138,12 +1159,12 @@ static void rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
 }
 
 static void rtl92c_dm_initialize_txpower_tracking_thermalmeter(
-						struct ieee80211_hw *hw)
+				struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	rtlpriv->dm.btxpower_tracking = true;
-	rtlpriv->dm.btxpower_trackingInit = false;
+	rtlpriv->dm.btxpower_trackinginit = false;
 
 	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 		 ("pMgntInfo->btxpower_tracking = %d\n",
@@ -1281,6 +1302,7 @@ static void rtl92c_dm_init_dynamic_bb_powersaving(struct ieee80211_hw *hw)
 	dm_pstable.rssi_val_min = 0;
 }
 
+#if 0
 static void rtl92c_dm_1r_cca(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -1325,6 +1347,7 @@ static void rtl92c_dm_1r_cca(struct ieee80211_hw *hw)
 					       (dm_pstable.cur_ccasate ==
 						0) ? "1RCCA" : "2RCCA"));
 }
+#endif
 
 void rtl92c_dm_rf_saving(struct ieee80211_hw *hw, u8 bforce_in_normal)
 {
@@ -1430,7 +1453,9 @@ static void rtl92c_dm_dynamic_bb_powersaving(struct ieee80211_hw *hw)
 	}
 
 	if (IS_92C_SERIAL(rtlhal->version))
-		rtl92c_dm_1r_cca(hw);
+		;/* rtl92c_dm_1r_cca(hw); */
+	else
+		rtl92c_dm_rf_saving(hw, false);
 }
 
 void rtl92c_dm_init(struct ieee80211_hw *hw)
@@ -1468,6 +1493,309 @@ void rtl92c_dm_watchdog(struct ieee80211_hw *hw)
 		rtl92c_dm_dynamic_txpower(hw);
 		rtl92c_dm_check_txpower_tracking(hw);
 		rtl92c_dm_refresh_rate_adaptive_mask(hw);
+		rtl92c_dm_bt_coexist(hw);
 		rtl92c_dm_check_edca_turbo(hw);
 	}
 }
+
+static bool rtl92c_bt_state_change(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+	u32 polling, ratio_tx, ratio_pri;
+	u32 bt_tx, bt_pri;
+	u8 bt_state;
+	u8 cur_service_type;
+
+	if (rtlpriv->mac80211.link_state < MAC80211_LINKED)
+		return false;
+
+	bt_state = rtl_read_byte(rtlpriv, 0x4fd);
+	bt_tx = rtl_read_dword(rtlpriv, 0x488);
+	bt_tx = bt_tx & 0x00ffffff;
+	bt_pri = rtl_read_dword(rtlpriv, 0x48c);
+	bt_pri = bt_pri & 0x00ffffff;
+	polling = rtl_read_dword(rtlpriv, 0x490);
+
+	if (bt_tx == 0xffffffff && bt_pri == 0xffffffff &&
+	    polling == 0xffffffff && bt_state == 0xff)
+		return false;
+
+	bt_state &= BIT_OFFSET_LEN_MASK_32(0, 1);
+	if (bt_state != rtlpcipriv->bt_coexist.bt_cur_state) {
+		rtlpcipriv->bt_coexist.bt_cur_state = bt_state;
+
+		if (rtlpcipriv->bt_coexist.b_reg_bt_sco == 3) {
+			rtlpcipriv->bt_coexist.bt_service = BT_IDLE;
+
+			bt_state = bt_state |
+				   ((rtlpcipriv->bt_coexist.bt_ant_isolation == 1) ?
+				   0 : BIT_OFFSET_LEN_MASK_32(1, 1)) |
+				   BIT_OFFSET_LEN_MASK_32(2, 1);
+			rtl_write_byte(rtlpriv, 0x4fd, bt_state);
+		}
+		return true;
+	}
+
+	ratio_tx = bt_tx * 1000 / polling;
+	ratio_pri = bt_pri * 1000 / polling;
+	rtlpcipriv->bt_coexist.ratio_tx = ratio_tx;
+	rtlpcipriv->bt_coexist.ratio_pri = ratio_pri;
+
+	if (bt_state && rtlpcipriv->bt_coexist.b_reg_bt_sco == 3) {
+
+		if ((ratio_tx < 30)  && (ratio_pri < 30))
+			cur_service_type = BT_IDLE;
+		else if ((ratio_pri > 110) && (ratio_pri < 250))
+			cur_service_type = BT_SCO;
+		else if ((ratio_tx >= 200) && (ratio_pri >= 200))
+			cur_service_type = BT_BUSY;
+		else if ((ratio_tx >= 350) && (ratio_tx < 500))
+			cur_service_type = BT_OTHERBUSY;
+		else if (ratio_tx >= 500)
+			cur_service_type = BT_PAN;
+		else
+			cur_service_type = BT_OTHER_ACTION;
+
+		if (cur_service_type != rtlpcipriv->bt_coexist.bt_service) {
+			rtlpcipriv->bt_coexist.bt_service = cur_service_type;
+			bt_state = bt_state |
+				((rtlpcipriv->bt_coexist.bt_ant_isolation == 1) ?
+				0 : BIT_OFFSET_LEN_MASK_32(1, 1)) |
+				((rtlpcipriv->bt_coexist.bt_service != BT_IDLE) ?
+				0 : BIT_OFFSET_LEN_MASK_32(2, 1));
+
+			/* Add interrupt migration when bt is not in idel state (no traffic). */
+			if (rtlpcipriv->bt_coexist.bt_service != BT_IDLE) {
+				rtl_write_word(rtlpriv, 0x504, 0x0ccc);
+				rtl_write_byte(rtlpriv, 0x506, 0x54);
+				rtl_write_byte(rtlpriv, 0x507, 0x54);
+			} else {
+				rtl_write_byte(rtlpriv, 0x506, 0x00);
+				rtl_write_byte(rtlpriv, 0x507, 0x00);
+			}
+
+			rtl_write_byte(rtlpriv, 0x4fd, bt_state);
+			return true;
+		}
+	}
+
+	return false;
+
+}
+
+static bool rtl92c_bt_wifi_connect_change(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	static bool b_media_connect;
+
+	if (rtlpriv->mac80211.link_state < MAC80211_LINKED) {
+		b_media_connect = false;
+	} else {
+		if (!b_media_connect) {
+			b_media_connect = true;
+			return true;
+		}
+		b_media_connect = true;
+	}
+
+	return false;
+}
+
+#define BT_RSSI_STATE_NORMAL_POWER	BIT_OFFSET_LEN_MASK_32(0, 1)
+#define BT_RSSI_STATE_AMDPU_OFF		BIT_OFFSET_LEN_MASK_32(1, 1)
+#define BT_RSSI_STATE_SPECIAL_LOW	BIT_OFFSET_LEN_MASK_32(2, 1)
+#define BT_RSSI_STATE_BG_EDCA_LOW	BIT_OFFSET_LEN_MASK_32(3, 1)
+#define BT_RSSI_STATE_TXPOWER_LOW	BIT_OFFSET_LEN_MASK_32(4, 1)
+
+#define GET_UNDECORATED_AVERAGE_RSSI(_priv)	\
+	(((struct rtl_priv *)(_priv))->mac80211.opmode ==	\
+	NL80211_IFTYPE_ADHOC) ?	(((struct rtl_priv *)		\
+	(_priv))->dm.entry_min_undecoratedsmoothed_pwdb) :	\
+	(((struct rtl_priv *)(_priv))->dm.undecorated_smoothed_pwdb)
+
+static u8 rtl92c_bt_rssi_state_change(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+	long undecorated_smoothed_pwdb;
+	u8 curr_bt_rssi_state = 0x00;
+
+	if (rtlpriv->mac80211.link_state == MAC80211_LINKED) {
+		undecorated_smoothed_pwdb = GET_UNDECORATED_AVERAGE_RSSI(rtlpriv);
+	} else {
+		if (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb == 0)
+			undecorated_smoothed_pwdb = 100;
+		else
+			undecorated_smoothed_pwdb =
+				rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
+	}
+
+	/* Check RSSI to determine HighPower/NormalPower state for BT coexistence. */
+	if (undecorated_smoothed_pwdb >= 67)
+		curr_bt_rssi_state &= (~BT_RSSI_STATE_NORMAL_POWER);
+	else if (undecorated_smoothed_pwdb < 62)
+		curr_bt_rssi_state |= BT_RSSI_STATE_NORMAL_POWER;
+
+	/* Check RSSI to determine AMPDU setting for BT coexistence. */
+	if (undecorated_smoothed_pwdb >= 40)
+		curr_bt_rssi_state &= (~BT_RSSI_STATE_AMDPU_OFF);
+	else if (undecorated_smoothed_pwdb <= 32)
+		curr_bt_rssi_state |= BT_RSSI_STATE_AMDPU_OFF;
+
+	/* Marked RSSI state. It will be used to determine BT coexistence setting later. */
+	if (undecorated_smoothed_pwdb < 35)
+		curr_bt_rssi_state |=  BT_RSSI_STATE_SPECIAL_LOW;
+	else
+		curr_bt_rssi_state &= (~BT_RSSI_STATE_SPECIAL_LOW);
+
+	/* Set Tx Power according to BT status. */
+	if (undecorated_smoothed_pwdb >= 30)
+		curr_bt_rssi_state |=  BT_RSSI_STATE_TXPOWER_LOW;
+	else if (undecorated_smoothed_pwdb < 25)
+		curr_bt_rssi_state &= (~BT_RSSI_STATE_TXPOWER_LOW);
+
+	/* Check BT state related to BT_Idle in B/G mode. */
+	if (undecorated_smoothed_pwdb < 15)
+		curr_bt_rssi_state |=  BT_RSSI_STATE_BG_EDCA_LOW;
+	else
+		curr_bt_rssi_state &= (~BT_RSSI_STATE_BG_EDCA_LOW);
+
+	if (curr_bt_rssi_state != rtlpcipriv->bt_coexist.bt_rssi_state) {
+		rtlpcipriv->bt_coexist.bt_rssi_state = curr_bt_rssi_state;
+		return true;
+	} else {
+		return false;
+	}
+}
+
+
+void rtl92c_dm_bt_coexist(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+	bool b_wifi_connect_change;
+	bool b_bt_state_change;
+	bool b_rssi_state_change;
+
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	    (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4)) {
+
+		b_wifi_connect_change = rtl92c_bt_wifi_connect_change(hw);
+		b_bt_state_change = rtl92c_bt_state_change(hw);
+		b_rssi_state_change = rtl92c_bt_rssi_state_change(hw);
+
+		if (b_wifi_connect_change || b_bt_state_change || b_rssi_state_change) {
+			if (rtlpcipriv->bt_coexist.bt_cur_state) {
+				if (rtlpcipriv->bt_coexist.bt_ant_isolation) {
+					/* Only enable HW BT coexist when BT in "Busy" state. */
+					if (rtlpriv->mac80211.vendor == PEER_CISCO &&
+					    rtlpcipriv->bt_coexist.bt_service == BT_OTHER_ACTION) {
+						rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
+					} else {
+						if ((rtlpcipriv->bt_coexist.bt_service == BT_BUSY) &&
+						    (rtlpcipriv->bt_coexist.bt_rssi_state &
+						     BT_RSSI_STATE_NORMAL_POWER)) {
+							rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
+						} else if ((rtlpcipriv->bt_coexist.bt_service ==
+								BT_OTHER_ACTION) && (rtlpriv->mac80211.mode <
+								WIRELESS_MODE_N_24G) &&
+								(rtlpcipriv->bt_coexist.bt_rssi_state &
+								BT_RSSI_STATE_SPECIAL_LOW)) {
+							rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
+						} else if (rtlpcipriv->bt_coexist.bt_service == BT_PAN) {
+							rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0x00);
+						} else {
+							rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0x00);
+						}
+					}
+
+					if (rtlpcipriv->bt_coexist.bt_service == BT_PAN)
+						rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x10100);
+					else
+						rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x0);
+
+					if (rtlpcipriv->bt_coexist.bt_rssi_state &
+						BT_RSSI_STATE_NORMAL_POWER) {
+						if (rtlpcipriv->bt_coexist.bt_service == BT_OTHERBUSY) {
+							rtlpcipriv->bt_coexist.bt_edca_ul = 0x5ea72b;
+							rtlpcipriv->bt_coexist.bt_edca_dl = 0x5ea72b;
+						} else if (rtlpcipriv->bt_coexist.bt_service == BT_BUSY) {
+							rtlpcipriv->bt_coexist.bt_edca_ul = 0x5eb82f;
+							rtlpcipriv->bt_coexist.bt_edca_dl = 0x5eb82f;
+						} else if (rtlpcipriv->bt_coexist.bt_service == BT_SCO) {
+							if (rtlpcipriv->bt_coexist.ratio_tx > 160) {
+								rtlpcipriv->bt_coexist.bt_edca_ul = 0x5ea72f;
+								rtlpcipriv->bt_coexist.bt_edca_dl = 0x5ea72f;
+							} else {
+								rtlpcipriv->bt_coexist.bt_edca_ul = 0x5ea32b;
+								rtlpcipriv->bt_coexist.bt_edca_dl = 0x5ea42b;
+							}
+						} else {
+							rtlpcipriv->bt_coexist.bt_edca_ul = 0;
+							rtlpcipriv->bt_coexist.bt_edca_dl = 0;
+						}
+
+						if ((rtlpcipriv->bt_coexist.bt_service != BT_IDLE) &&
+							(rtlpriv->mac80211.mode == WIRELESS_MODE_G ||
+							(rtlpriv->mac80211.mode == (WIRELESS_MODE_G |
+							WIRELESS_MODE_B))) &&
+							(rtlpcipriv->bt_coexist.bt_rssi_state &
+							BT_RSSI_STATE_BG_EDCA_LOW)) {
+							rtlpcipriv->bt_coexist.bt_edca_ul = 0x5eb82b;
+							rtlpcipriv->bt_coexist.bt_edca_dl = 0x5eb82b;
+						}
+					} else {
+						rtlpcipriv->bt_coexist.bt_edca_ul = 0;
+						rtlpcipriv->bt_coexist.bt_edca_dl = 0;
+					}
+
+					if (rtlpcipriv->bt_coexist.bt_service !=
+					    BT_IDLE) {
+						rtl92c_phy_set_rf_reg(hw,
+							  RF90_PATH_A, 0x1e,
+							  0xf0, 0xf);
+					} else {
+						rtl92c_phy_set_rf_reg(hw,
+							 RF90_PATH_A, 0x1e,
+							 0xf0,
+							 rtlpcipriv->bt_coexist.
+							 bt_rfreg_origin_1e);
+					}
+
+					if (!rtlpriv->dm.bdynamic_txpower_enable) {
+						if (rtlpcipriv->bt_coexist.bt_service != BT_IDLE) {
+							if (rtlpcipriv->bt_coexist.bt_rssi_state &
+								BT_RSSI_STATE_TXPOWER_LOW) {
+								rtlpriv->dm.dynamic_txhighpower_lvl =
+											TXHIGHPWRLEVEL_BT2;
+							} else {
+								rtlpriv->dm.dynamic_txhighpower_lvl =
+											TXHIGHPWRLEVEL_BT1;
+							}
+						} else {
+							rtlpriv->dm.dynamic_txhighpower_lvl =
+									TXHIGHPWRLEVEL_NORMAL;
+						}
+						rtl92c_phy_set_txpower_level(hw,
+							rtlpriv->phy.
+							current_channel);
+					}
+				}
+			} else {
+				rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0x00);
+				rtl92c_phy_set_rf_reg(hw, RF90_PATH_A,
+					 0x1e, 0xf0,
+					 rtlpcipriv->bt_coexist.
+					 bt_rfreg_origin_1e);
+
+				rtlpcipriv->bt_coexist.bt_edca_ul = 0;
+				rtlpcipriv->bt_coexist.bt_edca_dl = 0;
+			}
+		}
+	}
+}
+
+
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
index 463439e..c6a7ba5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
@@ -31,25 +31,25 @@
 #define __RTL92C_DM_H__
 
 #define HAL_DM_DIG_DISABLE			BIT(0)
-#define HAL_DM_HIPWR_DISABLE			BIT(1)
+#define HAL_DM_HIPWR_DISABLE		BIT(1)
 
 #define OFDM_TABLE_LENGTH			37
 #define CCK_TABLE_LENGTH			33
 
-#define OFDM_TABLE_SIZE				37
+#define OFDM_TABLE_SIZE			37
 #define CCK_TABLE_SIZE				33
 
-#define BW_AUTO_SWITCH_HIGH_LOW			25
-#define BW_AUTO_SWITCH_LOW_HIGH			30
+#define BW_AUTO_SWITCH_HIGH_LOW		25
+#define BW_AUTO_SWITCH_LOW_HIGH		30
 
 #define DM_DIG_THRESH_HIGH			40
 #define DM_DIG_THRESH_LOW			35
 
-#define DM_FALSEALARM_THRESH_LOW		400
-#define DM_FALSEALARM_THRESH_HIGH		1000
+#define DM_FALSEALARM_THRESH_LOW	400
+#define DM_FALSEALARM_THRESH_HIGH	1000
 
-#define DM_DIG_MAX				0x3e
-#define DM_DIG_MIN				0x1e
+#define DM_DIG_MAX					0x3e
+#define DM_DIG_MIN					0x1e
 
 #define DM_DIG_FA_UPPER				0x32
 #define DM_DIG_FA_LOWER				0x20
@@ -59,10 +59,10 @@
 
 #define DM_DIG_BACKOFF_MAX			12
 #define DM_DIG_BACKOFF_MIN			-4
-#define DM_DIG_BACKOFF_DEFAULT			10
+#define DM_DIG_BACKOFF_DEFAULT		10
 
-#define RXPATHSELECTION_SS_TH_lOW		30
-#define RXPATHSELECTION_DIFF_TH			18
+#define RXPATHSELECTION_SS_TH_lOW	30
+#define RXPATHSELECTION_DIFF_TH		18
 
 #define DM_RATR_STA_INIT			0
 #define DM_RATR_STA_HIGH			1
@@ -192,5 +192,6 @@ void rtl92c_dm_init_edca_turbo(struct ieee80211_hw *hw);
 void rtl92c_dm_check_txpower_tracking(struct ieee80211_hw *hw);
 void rtl92c_dm_init_rate_adaptive_mask(struct ieee80211_hw *hw);
 void rtl92c_dm_rf_saving(struct ieee80211_hw *hw, u8 bforce_in_normal);
-
+void rtl92c_dm_bt_coexist(struct ieee80211_hw *hw);
 #endif
+
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
index 11dd22b..657a9d6 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
@@ -305,7 +305,7 @@ static void _rtl92c_fill_h2c_command(struct ieee80211_hw *hw,
 	u16 box_reg, box_extreg;
 	u8 u1b_tmp;
 	bool isfw_read = false;
-	u8 buf_index;
+	u8 buf_index = 0;
 	bool bwrite_sucess = false;
 	u8 wait_h2c_limmit = 100;
 	u8 wait_writeh2c_limmit = 100;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 1c41a0c..f086e6b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -30,6 +30,7 @@
 #include "../wifi.h"
 #include "../efuse.h"
 #include "../base.h"
+#include "../regd.h"
 #include "../cam.h"
 #include "../ps.h"
 #include "../pci.h"
@@ -127,26 +128,17 @@ void rtl92ce_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		*((bool *) (val)) = ppsc->b_fw_current_inpsmode;
 		break;
 	case HW_VAR_CORRECT_TSF:{
-		u64 tsf;
-		u32 *ptsf_low = (u32 *)&tsf;
-		u32 *ptsf_high = ((u32 *)&tsf) + 1;
+			u64 tsf;
+			u32 *ptsf_low = (u32 *)&tsf;
+			u32 *ptsf_high = ((u32 *)&tsf) + 1;
 
-		*ptsf_high = rtl_read_dword(rtlpriv, (REG_TSFTR + 4));
-		*ptsf_low = rtl_read_dword(rtlpriv, REG_TSFTR);
+			*ptsf_high = rtl_read_dword(rtlpriv, (REG_TSFTR + 4));
+			*ptsf_low = rtl_read_dword(rtlpriv, REG_TSFTR);
 
-		*((u64 *) (val)) = tsf;
+			*((u64 *) (val)) = tsf;
 
-		break;
+			break;
 		}
-	case HW_VAR_MGT_FILTER:
-		*((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP0);
-		break;
-	case HW_VAR_CTRL_FILTER:
-		*((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP1);
-		break;
-	case HW_VAR_DATA_FILTER:
-		*((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP2);
-		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("switch case not process\n"));
@@ -157,6 +149,7 @@ void rtl92ce_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -278,12 +271,18 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		}
 	case HW_VAR_AMPDU_FACTOR:{
 			u8 regtoset_normal[4] = { 0x41, 0xa8, 0x72, 0xb9 };
+			u8 regtoset_bt[4] = {0x31, 0x74, 0x42, 0x97};
 
 			u8 factor_toset;
 			u8 *p_regtoset = NULL;
 			u8 index = 0;
 
-			p_regtoset = regtoset_normal;
+			if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+			    (rtlpcipriv->bt_coexist.bt_coexist_type ==
+			    BT_CSR_BC4))
+				p_regtoset = regtoset_bt;
+			else
+				p_regtoset = regtoset_normal;
 
 			factor_toset = *((u8 *) val);
 			if (factor_toset <= 3) {
@@ -320,6 +319,8 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 			u8 e_aci = *((u8 *) val);
 			u32 u4b_ac_param = 0;
 
+			rtl92c_dm_init_edca_turbo(hw);
+
 			u4b_ac_param |= (u32) mac->ac[e_aci].aifs;
 			u4b_ac_param |= ((u32) mac->ac[e_aci].cw_min
 					 & 0xF) << AC_PARAM_ECW_MIN_OFFSET;
@@ -338,8 +339,8 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 						u4b_ac_param);
 				break;
 			case AC0_BE:
-				rtl_write_dword(rtlpriv, REG_EDCA_BE_PARAM,
-						u4b_ac_param);
+				/*rtl_write_dword(rtlpriv, REG_EDCA_BE_PARAM, */
+				/*		u4b_ac_param); */
 				break;
 			case AC2_VI:
 				rtl_write_dword(rtlpriv, REG_EDCA_VI_PARAM,
@@ -525,9 +526,6 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	case HW_VAR_CORRECT_TSF:{
 			u8 btype_ibss = ((u8 *) (val))[0];
 
-			/*btype_ibss = (mac->opmode == NL80211_IFTYPE_ADHOC) ?
-					1 : 0;*/
-
 			if (btype_ibss == true)
 				_rtl92ce_stop_tx_beacon(hw);
 
@@ -546,15 +544,6 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 			break;
 
 		}
-	case HW_VAR_MGT_FILTER:
-		rtl_write_word(rtlpriv, REG_RXFLTMAP0, *(u16 *) val);
-		break;
-	case HW_VAR_CTRL_FILTER:
-		rtl_write_word(rtlpriv, REG_RXFLTMAP1, *(u16 *) val);
-		break;
-	case HW_VAR_DATA_FILTER:
-		rtl_write_word(rtlpriv, REG_RXFLTMAP2, *(u16 *) val);
-		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("switch case "
 							"not process\n"));
@@ -678,12 +667,12 @@ static void _rtl92ce_gen_refresh_led_state(struct ieee80211_hw *hw)
 		rtl92ce_sw_led_on(hw, pLed0);
 	else
 		rtl92ce_sw_led_off(hw, pLed0);
-
 }
 
 static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
@@ -692,9 +681,24 @@ static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
 	u16 retry;
 
 	rtl_write_byte(rtlpriv, REG_RSV_CTRL, 0x00);
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4)) {
+		u32 value32;
+		value32 = rtl_read_dword(rtlpriv, REG_APS_FSMCO);
+		value32 |= (SOP_ABG | SOP_AMB | XOP_BTCK);
+		rtl_write_dword(rtlpriv, REG_APS_FSMCO, value32);
+	}
 	rtl_write_byte(rtlpriv, REG_SPS0_CTRL, 0x2b);
 	rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL, 0x0F);
 
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4)) {
+		u32 u4b_tmp = rtl_read_dword(rtlpriv, REG_AFE_XTAL_CTRL);
+
+		u4b_tmp &= (~0x00024800);
+		rtl_write_dword(rtlpriv, REG_AFE_XTAL_CTRL, u4b_tmp);
+	}
+
 	bytetmp = rtl_read_byte(rtlpriv, REG_APS_FSMCO + 1) | BIT(0);
 	udelay(2);
 
@@ -725,10 +729,16 @@ static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL + 1, 0x82);
 	udelay(2);
 
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4)) {
+		bytetmp = rtl_read_byte(rtlpriv, REG_AFE_XTAL_CTRL+2) & 0xfd;
+		rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL+2, bytetmp);
+	}
+
 	rtl_write_word(rtlpriv, REG_CR, 0x2ff);
 
 	if (_rtl92ce_llt_table_init(hw) == false)
-		return false;;
+		return false;
 
 	rtl_write_dword(rtlpriv, REG_HISR, 0xffffffff);
 	rtl_write_byte(rtlpriv, REG_HISRE, 0xff);
@@ -785,13 +795,14 @@ static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
 
 	rtl_write_dword(rtlpriv, REG_MCUTST_1, 0x0);
 
-	return true;;
+	return true;
 }
 
 static void _rtl92ce_hw_configure(struct ieee80211_hw *hw)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	u8 reg_bw_opmode;
 	u32 reg_ratr, reg_prsr;
 
@@ -823,7 +834,11 @@ static void _rtl92ce_hw_configure(struct ieee80211_hw *hw)
 	rtl_write_dword(rtlpriv, REG_RARFRC, 0x01000000);
 	rtl_write_dword(rtlpriv, REG_RARFRC + 4, 0x07060504);
 
-	rtl_write_dword(rtlpriv, REG_AGGLEN_LMT, 0xb972a841);
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	    (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4))
+		rtl_write_dword(rtlpriv, REG_AGGLEN_LMT, 0x97427431);
+	else
+		rtl_write_dword(rtlpriv, REG_AGGLEN_LMT, 0xb972a841);
 
 	rtl_write_byte(rtlpriv, REG_ATIMWND, 0x2);
 
@@ -839,11 +854,20 @@ static void _rtl92ce_hw_configure(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_PIFS, 0x1C);
 	rtl_write_byte(rtlpriv, REG_AGGR_BREAK_TIME, 0x16);
 
-	rtl_write_word(rtlpriv, REG_NAV_PROT_LEN, 0x0020);
-
-	rtl_write_word(rtlpriv, REG_NAV_PROT_LEN, 0x0020);
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	    (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4)) {
+		rtl_write_word(rtlpriv, REG_NAV_PROT_LEN, 0x0020);
+		rtl_write_word(rtlpriv, REG_PROT_MODE_CTRL, 0x0402);
+	} else {
+		rtl_write_word(rtlpriv, REG_NAV_PROT_LEN, 0x0020);
+		rtl_write_word(rtlpriv, REG_NAV_PROT_LEN, 0x0020);
+	}
 
-	rtl_write_dword(rtlpriv, REG_FAST_EDCA_CTRL, 0x086666);
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4))
+		rtl_write_dword(rtlpriv, REG_FAST_EDCA_CTRL, 0x03086666);
+	else
+		rtl_write_dword(rtlpriv, REG_FAST_EDCA_CTRL, 0x086666);
 
 	rtl_write_byte(rtlpriv, REG_ACKTO, 0x40);
 
@@ -961,15 +985,20 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 	_rtl92ce_hw_configure(hw);
 	rtl_cam_reset_all_entry(hw);
 	rtl92ce_enable_hw_security_config(hw);
+
 	ppsc->rfpwr_state = ERFON;
+
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_ETHER_ADDR, mac->mac_addr);
 	_rtl92ce_enable_aspm_back_door(hw);
 	rtlpriv->intf_ops->enable_aspm(hw);
+
+	rtl8192ce_bt_hw_init(hw);
+
 	if (ppsc->rfpwr_state == ERFON) {
 		rtl92c_phy_set_rfpath_switch(hw, 1);
-		if (iqk_initialized)
+		if (iqk_initialized) {
 			rtl92c_phy_iq_calibrate(hw, true);
-		else {
+		} else {
 			rtl92c_phy_iq_calibrate(hw, false);
 			iqk_initialized = true;
 		}
@@ -998,6 +1027,7 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 		rtl_write_byte(rtlpriv, 0x16, tmp_u1b | 0x90);
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, ("under 1.5V\n"));
 	}
+	rtlpriv->cfg->ops->led_control(hw, LED_CTL_POWER_ON);
 	rtl92c_dm_init(hw);
 	rtlpci->being_init_adapter = false;
 	return err;
@@ -1127,45 +1157,44 @@ static int _rtl92ce_set_media_status(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void _rtl92ce_set_check_bssid(struct ieee80211_hw *hw,
-				     enum nl80211_iftype type)
+void rtl92ce_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
-	u8 filterout_non_associated_bssid = false;
 
-	switch (type) {
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_STATION:
-		filterout_non_associated_bssid = true;
-		break;
-	case NL80211_IFTYPE_UNSPECIFIED:
-	case NL80211_IFTYPE_AP:
-	default:
-		break;
-	}
+	if (rtlpriv->psc.rfpwr_state != ERFON)
+		return;
 
-	if (filterout_non_associated_bssid == true) {
+	if (check_bssid == true) {
 		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
 					      (u8 *) (&reg_rcr));
 		_rtl92ce_set_bcn_ctrl_reg(hw, 0, BIT(4));
-	} else if (filterout_non_associated_bssid == false) {
+	} else if (check_bssid == false) {
 		reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
 		_rtl92ce_set_bcn_ctrl_reg(hw, BIT(4), 0);
 		rtlpriv->cfg->ops->set_hw_reg(hw,
-					      HW_VAR_RCR, (u8 *) (&reg_rcr));
+			HW_VAR_RCR, (u8 *) (&reg_rcr));
 	}
+
 }
 
 int rtl92ce_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	if (_rtl92ce_set_media_status(hw, type))
 		return -EOPNOTSUPP;
-	_rtl92ce_set_check_bssid(hw, type);
+
+	if (rtlpriv->mac80211.link_state == MAC80211_LINKED)
+		rtl92ce_set_check_bssid(hw, true);
+	else
+		rtl92ce_set_check_bssid(hw, false);
+
 	return 0;
 }
 
+/* don't set REG_EDCA_BE_PARAM here because mac80211 will send pkt when scan */
 void rtl92ce_set_qos(struct ieee80211_hw *hw, int aci)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -1190,7 +1219,7 @@ void rtl92ce_set_qos(struct ieee80211_hw *hw, int aci)
 		rtl_write_dword(rtlpriv, REG_EDCA_BK_PARAM, u4b_ac_param);
 		break;
 	case AC0_BE:
-		rtl_write_dword(rtlpriv, REG_EDCA_BE_PARAM, u4b_ac_param);
+		/* rtl_write_dword(rtlpriv, REG_EDCA_BE_PARAM, u4b_ac_param); */
 		break;
 	case AC2_VI:
 		rtl_write_dword(rtlpriv, REG_EDCA_VI_PARAM, u4b_ac_param);
@@ -1227,8 +1256,10 @@ void rtl92ce_disable_interrupt(struct ieee80211_hw *hw)
 static void _rtl92ce_poweroff_adapter(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u8 u1b_tmp;
+	u32 u4b_tmp;
 
 	rtlpriv->intf_ops->enable_aspm(hw);
 	rtl_write_byte(rtlpriv, REG_TXPAUSE, 0xFF);
@@ -1243,13 +1274,27 @@ static void _rtl92ce_poweroff_adapter(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_MCUFWDL, 0x00);
 	rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x00000000);
 	u1b_tmp = rtl_read_byte(rtlpriv, REG_GPIO_PIN_CTRL);
-	rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x00FF0000 |
-			(u1b_tmp << 8));
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	     ((rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4) ||
+	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC8)))
+		rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x00F30000 |
+				(u1b_tmp << 8));
+	else
+		rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x00FF0000 |
+				(u1b_tmp << 8));
 	rtl_write_word(rtlpriv, REG_GPIO_IO_SEL, 0x0790);
 	rtl_write_word(rtlpriv, REG_LEDCFG0, 0x8080);
 	rtl_write_byte(rtlpriv, REG_AFE_PLL_CTRL, 0x80);
 	rtl_write_byte(rtlpriv, REG_SPS0_CTRL, 0x23);
-	rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL, 0x0e);
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4)) {
+		u4b_tmp = rtl_read_dword(rtlpriv, REG_AFE_XTAL_CTRL);
+		u4b_tmp |= 0x03824800;
+		rtl_write_dword(rtlpriv, REG_AFE_XTAL_CTRL, u4b_tmp);
+	} else {
+		rtl_write_dword(rtlpriv, REG_AFE_XTAL_CTRL, 0x0e);
+	}
+
 	rtl_write_byte(rtlpriv, REG_RSV_CTRL, 0x0e);
 	rtl_write_byte(rtlpriv, REG_APS_FSMCO + 1, 0x10);
 }
@@ -1623,6 +1668,10 @@ static void _rtl92ce_read_adapter_info(struct ieee80211_hw *hw)
 					     rtlefuse->autoload_failflag,
 					     hwinfo);
 
+	rtl8192ce_read_bt_coexist_info_from_hwpg(hw,
+						 rtlefuse->autoload_failflag,
+						 hwinfo);
+
 	rtlefuse->eeprom_channelplan = *(u8 *)&hwinfo[EEPROM_CHANNELPLAN];
 	rtlefuse->eeprom_version = *(u16 *)&hwinfo[EEPROM_VERSION];
 	rtlefuse->b_txpwr_fromeprom = true;
@@ -1631,6 +1680,9 @@ static void _rtl92ce_read_adapter_info(struct ieee80211_hw *hw)
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 		 ("EEPROM Customer ID: 0x%2x\n", rtlefuse->eeprom_oemid));
 
+	/* set channel paln to world wide 13 */
+	rtlefuse->channel_plan = COUNTRY_CODE_WORLD_WIDE_13;
+
 	if (rtlhal->oem_id == RT_CID_DEFAULT) {
 		switch (rtlefuse->eeprom_oemid) {
 		case EEPROM_CID_DEFAULT:
@@ -1714,13 +1766,13 @@ void rtl92ce_read_eeprom_info(struct ieee80211_hw *hw)
 	} else {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("Autoload ERR!!\n"));
 	}
-
 	_rtl92ce_hal_customized_behavior(hw);
 }
 
 void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
@@ -1774,7 +1826,15 @@ void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw)
 		break;
 	}
 
-	ratr_value &= 0x0FFFFFFF;
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4) &&
+	     (rtlpcipriv->bt_coexist.bt_cur_state) &&
+	     (rtlpcipriv->bt_coexist.bt_ant_isolation) &&
+	     ((rtlpcipriv->bt_coexist.bt_service == BT_SCO) ||
+	     (rtlpcipriv->bt_coexist.bt_service == BT_BUSY)))
+		ratr_value &= 0x0fffcfc0;
+	else
+		ratr_value &= 0x0FFFFFFF;
 
 	if (b_nmode && ((b_curtxbw_40mhz &&
 			 b_curshortgi_40mhz) || (!b_curtxbw_40mhz &&
@@ -1933,7 +1993,7 @@ void rtl92ce_update_channel_access_setting(struct ieee80211_hw *hw)
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_SIFS, (u8 *)&sifs_timer);
 }
 
-bool rtl92ce_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid)
+bool rtl92ce_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
@@ -1943,7 +2003,7 @@ bool rtl92ce_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid)
 	bool b_actuallyset = false;
 	unsigned long flag;
 
-	if ((rtlpci->up_first_time == 1) || (rtlpci->being_init_adapter))
+	if (rtlpci->being_init_adapter)
 		return false;
 
 	if (ppsc->b_swrf_processing)
@@ -1960,14 +2020,8 @@ bool rtl92ce_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid)
 
 	cur_rfstate = ppsc->rfpwr_state;
 
-	if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&
-	    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM)) {
-		rtlpriv->intf_ops->disable_aspm(hw);
-		RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
-	}
-
 	rtl_write_byte(rtlpriv, REG_MAC_PINMUX_CFG, rtl_read_byte(rtlpriv,
-		       REG_MAC_PINMUX_CFG)&~(BIT(3)));
+				REG_MAC_PINMUX_CFG)&(~(BIT(3))));
 
 	u1tmp = rtl_read_byte(rtlpriv, REG_GPIO_IO_SEL);
 	e_rfpowerstate_toset = (u1tmp & BIT(3)) ? ERFON : ERFOFF;
@@ -1990,38 +2044,13 @@ bool rtl92ce_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid)
 	}
 
 	if (b_actuallyset) {
-		if (e_rfpowerstate_toset == ERFON) {
-			if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&
-			    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM)) {
-				rtlpriv->intf_ops->disable_aspm(hw);
-				RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
-			}
-		}
-
 		spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
 		ppsc->rfchange_inprogress = false;
 		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
-
-		if (e_rfpowerstate_toset == ERFOFF) {
-			if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) {
-				rtlpriv->intf_ops->enable_aspm(hw);
-				RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
-			}
-		}
-
-	} else if (e_rfpowerstate_toset == ERFOFF || cur_rfstate == ERFOFF) {
+	} else {
 		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_HALT_NIC)
 			RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 
-		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) {
-			rtlpriv->intf_ops->enable_aspm(hw);
-			RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
-		}
-
-		spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
-		ppsc->rfchange_inprogress = false;
-		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
-	} else {
 		spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
 		ppsc->rfchange_inprogress = false;
 		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
@@ -2160,3 +2189,133 @@ void rtl92ce_set_key(struct ieee80211_hw *hw, u32 key_index,
 		}
 	}
 }
+
+static void rtl8192ce_bt_var_init(struct ieee80211_hw *hw)
+{
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+	rtlpcipriv->bt_coexist.bt_coexistence =
+				rtlpcipriv->bt_coexist.eeprom_bt_coexist;
+	rtlpcipriv->bt_coexist.bt_ant_num =
+				rtlpcipriv->bt_coexist.eeprom_bt_ant_num;
+	rtlpcipriv->bt_coexist.bt_coexist_type =
+				rtlpcipriv->bt_coexist.eeprom_bt_type;
+
+	if (rtlpcipriv->bt_coexist.b_reg_bt_iso == 2)
+		rtlpcipriv->bt_coexist.bt_ant_isolation =
+				rtlpcipriv->bt_coexist.eeprom_bt_ant_isolation;
+	else
+		rtlpcipriv->bt_coexist.bt_ant_isolation =
+				rtlpcipriv->bt_coexist.b_reg_bt_iso;
+
+	rtlpcipriv->bt_coexist.bt_radio_shared_type =
+				rtlpcipriv->bt_coexist.eeprom_bt_radio_shared;
+
+	if (rtlpcipriv->bt_coexist.bt_coexistence) {
+
+		if (rtlpcipriv->bt_coexist.b_reg_bt_sco == 1)
+			rtlpcipriv->bt_coexist.bt_service = BT_OTHER_ACTION;
+		else if (rtlpcipriv->bt_coexist.b_reg_bt_sco == 2)
+			rtlpcipriv->bt_coexist.bt_service = BT_SCO;
+		else if (rtlpcipriv->bt_coexist.b_reg_bt_sco == 4)
+			rtlpcipriv->bt_coexist.bt_service = BT_BUSY;
+		else if (rtlpcipriv->bt_coexist.b_reg_bt_sco == 5)
+			rtlpcipriv->bt_coexist.bt_service = BT_OTHERBUSY;
+		else
+			rtlpcipriv->bt_coexist.bt_service = BT_IDLE;
+
+		rtlpcipriv->bt_coexist.bt_edca_ul = 0;
+		rtlpcipriv->bt_coexist.bt_edca_dl = 0;
+		rtlpcipriv->bt_coexist.bt_rssi_state = 0xff;
+	}
+}
+
+void rtl8192ce_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
+					      bool auto_load_fail, u8 *hwinfo)
+{
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+	u8 value;
+
+	if (!auto_load_fail) {
+		rtlpcipriv->bt_coexist.eeprom_bt_coexist =
+						((hwinfo[RF_OPTION1] &
+						 0xe0) >> 5);
+		value = hwinfo[RF_OPTION4];
+		rtlpcipriv->bt_coexist.eeprom_bt_type = ((value & 0xe) >> 1);
+		rtlpcipriv->bt_coexist.eeprom_bt_ant_num = (value & 0x1);
+		rtlpcipriv->bt_coexist.eeprom_bt_ant_isolation =
+							 ((value & 0x10) >> 4);
+		rtlpcipriv->bt_coexist.eeprom_bt_radio_shared =
+							 ((value & 0x20) >> 5);
+	} else {
+		rtlpcipriv->bt_coexist.eeprom_bt_coexist = 0;
+		rtlpcipriv->bt_coexist.eeprom_bt_type = BT_2WIRE;
+		rtlpcipriv->bt_coexist.eeprom_bt_ant_num = ANT_X2;
+		rtlpcipriv->bt_coexist.eeprom_bt_ant_isolation = 0;
+		rtlpcipriv->bt_coexist.eeprom_bt_radio_shared = BT_RADIO_SHARED;
+	}
+
+	rtl8192ce_bt_var_init(hw);
+}
+
+void rtl8192ce_bt_reg_init(struct ieee80211_hw *hw)
+{
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+	/* 0:Low, 1:High, 2:From Efuse. */
+	rtlpcipriv->bt_coexist.b_reg_bt_iso = 2;
+	/* 0:Idle, 1:None-SCO, 2:SCO, 3:From Counter. */
+	rtlpcipriv->bt_coexist.b_reg_bt_sco = 3;
+	/* 0:Disable BT control A-MPDU, 1:Enable BT control A-MPDU. */
+	rtlpcipriv->bt_coexist.b_reg_bt_sco = 0;
+}
+
+
+void rtl8192ce_bt_hw_init(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+	u8 u1_tmp;
+
+	if (rtlpcipriv->bt_coexist.bt_coexistence &&
+	    ((rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4) ||
+	      rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC8)) {
+
+		if (rtlpcipriv->bt_coexist.bt_ant_isolation)
+			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
+
+		u1_tmp = rtl_read_byte(rtlpriv, 0x4fd) &
+				       BIT_OFFSET_LEN_MASK_32(0, 1);
+		u1_tmp = u1_tmp |
+			 ((rtlpcipriv->bt_coexist.bt_ant_isolation == 1) ?
+			 0 : BIT_OFFSET_LEN_MASK_32(1, 1)) |
+			 ((rtlpcipriv->bt_coexist.bt_service == BT_SCO) ?
+			 0 : BIT_OFFSET_LEN_MASK_32(2, 1));
+		rtl_write_byte(rtlpriv, 0x4fd, u1_tmp);
+
+		rtl_write_dword(rtlpriv, REG_BT_COEX_TABLE+4, 0xaaaa9aaa);
+		rtl_write_dword(rtlpriv, REG_BT_COEX_TABLE+8, 0xffbd0040);
+		rtl_write_dword(rtlpriv, REG_BT_COEX_TABLE+0xc, 0x40000010);
+
+		/* Config to 1T1R. */
+		if (rtlphy->rf_type == RF_1T1R) {
+			u1_tmp = rtl_read_byte(rtlpriv, ROFDM0_TRXPATHENABLE);
+			u1_tmp &= ~(BIT_OFFSET_LEN_MASK_32(1, 1));
+			rtl_write_byte(rtlpriv, ROFDM0_TRXPATHENABLE, u1_tmp);
+
+			u1_tmp = rtl_read_byte(rtlpriv, ROFDM1_TRXPATHENABLE);
+			u1_tmp &= ~(BIT_OFFSET_LEN_MASK_32(1, 1));
+			rtl_write_byte(rtlpriv, ROFDM1_TRXPATHENABLE, u1_tmp);
+		}
+	}
+}
+
+void rtl92ce_suspend(struct ieee80211_hw *hw)
+{
+}
+
+void rtl92ce_resume(struct ieee80211_hw *hw)
+{
+}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
index 305c819..c6cec83 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
@@ -33,17 +33,18 @@
 void rtl92ce_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl92ce_read_eeprom_info(struct ieee80211_hw *hw);
 void rtl92ce_interrupt_recognized(struct ieee80211_hw *hw,
-				  u32 *p_inta, u32 *p_intb);
+			u32 *p_inta, u32 *p_intb);
 int rtl92ce_hw_init(struct ieee80211_hw *hw);
 void rtl92ce_card_disable(struct ieee80211_hw *hw);
 void rtl92ce_enable_interrupt(struct ieee80211_hw *hw);
 void rtl92ce_disable_interrupt(struct ieee80211_hw *hw);
 int rtl92ce_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type);
+void rtl92ce_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid);
 void rtl92ce_set_qos(struct ieee80211_hw *hw, int aci);
 void rtl92ce_set_beacon_related_registers(struct ieee80211_hw *hw);
 void rtl92ce_set_beacon_interval(struct ieee80211_hw *hw);
 void rtl92ce_update_interrupt_mask(struct ieee80211_hw *hw,
-				   u32 add_msr, u32 rm_msr);
+			u32 add_msr, u32 rm_msr);
 void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw);
 void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw, u8 rssi_level);
@@ -54,4 +55,11 @@ void rtl92ce_set_key(struct ieee80211_hw *hw, u32 key_index,
 		     u8 *p_macaddr, bool is_group, u8 enc_algo,
 		     bool is_wepkey, bool clear_all);
 
+void rtl8192ce_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
+			bool autoload_fail, u8 *hwinfo);
+void rtl8192ce_bt_reg_init(struct ieee80211_hw *hw);
+void rtl8192ce_bt_hw_init(struct ieee80211_hw *hw);
+void rtl92ce_suspend(struct ieee80211_hw *hw);
+void rtl92ce_resume(struct ieee80211_hw *hw);
 #endif
+
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/led.c b/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
index 78a0569..57b4d7c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
@@ -44,7 +44,6 @@ void rtl92ce_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 
 	switch (pled->ledpin) {
 	case LED_PIN_GPIO0:
-		break;
 	case LED_PIN_LED0:
 		rtl_write_byte(rtlpriv,
 			       REG_LEDCFG2, (ledcfg & 0xf0) | BIT(5) | BIT(6));
@@ -73,7 +72,6 @@ void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 
 	switch (pled->ledpin) {
 	case LED_PIN_GPIO0:
-		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
 		if (pcipriv->ledctl.bled_opendrain == true)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
index 4504411..b5d04fa 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -65,11 +65,12 @@ static bool _rtl92c_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 static u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
 				       enum wireless_mode wirelessmode,
 				       long power_indbm);
-static bool _rtl92c_phy_config_rf_external_pa(struct ieee80211_hw *hw,
-					      enum radio_path rfpath);
 static long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
 					 enum wireless_mode wirelessmode,
 					 u8 txpwridx);
+static void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw);
+static void rtl92c_phy_set_io(struct ieee80211_hw *hw);
+
 u32 rtl92c_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -408,10 +409,6 @@ static bool _rtl92c_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
 	return true;
 }
 
-void rtl92c_phy_config_bb_external_pa(struct ieee80211_hw *hw)
-{
-}
-
 static bool _rtl92c_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 						  u8 configtype)
 {
@@ -456,7 +453,6 @@ static bool _rtl92c_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 				  phy_regarray_table[i],
 				  phy_regarray_table[i + 1]));
 		}
-		rtl92c_phy_config_bb_external_pa(hw);
 	} else if (configtype == BASEBAND_CONFIG_AGC_TAB) {
 		for (i = 0; i < agctab_arraylen; i = i + 2) {
 			rtl_set_bbreg(hw, agctab_array_table[i], MASKDWORD,
@@ -679,12 +675,6 @@ static bool _rtl92c_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 	return true;
 }
 
-static bool _rtl92c_phy_config_rf_external_pa(struct ieee80211_hw *hw,
-					      enum radio_path rfpath)
-{
-	return true;
-}
-
 bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					  enum radio_path rfpath)
 {
@@ -740,7 +730,6 @@ bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 				udelay(1);
 			}
 		}
-		_rtl92c_phy_config_rf_external_pa(hw, rfpath);
 		break;
 	case RF90_PATH_B:
 		for (i = 0; i < radiob_arraylen; i = i + 2) {
@@ -1028,10 +1017,6 @@ bool rtl92c_phy_update_txpower_dbm(struct ieee80211_hw *hw, long power_indbm)
 	return true;
 }
 
-void rtl92c_phy_set_beacon_hw_reg(struct ieee80211_hw *hw, u16 beaconinterval)
-{
-}
-
 static u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
 				       enum wireless_mode wirelessmode,
 				       long power_indbm)
@@ -1129,8 +1114,10 @@ void rtl92c_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 		  rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20 ?
 		  "20MHz" : "40MHz"))
 
-	    if (is_hal_stop(rtlhal))
+	if (is_hal_stop(rtlhal)) {
+		rtlphy->set_bwmode_inprogress = false;
 		return;
+	}
 
 	reg_bw_opmode = rtl_read_byte(rtlpriv, REG_BWOPMODE);
 	reg_prsr_rsc = rtl_read_byte(rtlpriv, REG_RRSR + 2);
@@ -1194,9 +1181,9 @@ void rtl92c_phy_set_bw_mode(struct ieee80211_hw *hw,
 	if (rtlphy->set_bwmode_inprogress)
 		return;
 	rtlphy->set_bwmode_inprogress = true;
-	if ((!is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw)))
+	if ((!is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw))) {
 		rtl92c_phy_set_bw_mode_callback(hw);
-	else {
+	} else {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 ("FALSE driver sleep or unload\n"));
 		rtlphy->set_bwmode_inprogress = false;
@@ -1225,8 +1212,9 @@ void rtl92c_phy_sw_chnl_callback(struct ieee80211_hw *hw)
 				mdelay(delay);
 			else
 				continue;
-		} else
+		} else {
 			rtlphy->sw_chnl_inprogress = false;
+		}
 		break;
 	} while (true);
 	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, ("<==\n"));
@@ -1390,11 +1378,6 @@ static bool _rtl92c_phy_set_sw_chnl_cmdarray(struct swchnlcmd *cmdtable,
 	return true;
 }
 
-bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw, u32 rfpath)
-{
-	return true;
-}
-
 static u8 _rtl92c_phy_path_a_iqk(struct ieee80211_hw *hw, bool config_pathb)
 {
 	u32 reg_eac, reg_e94, reg_e9c, reg_ea4;
@@ -1472,9 +1455,9 @@ static void _rtl92c_phy_path_a_fill_iqk_matrix(struct ieee80211_hw *hw,
 	u32 oldval_0, x, tx0_a, reg;
 	long y, tx0_c;
 
-	if (final_candidate == 0xFF)
+	if (final_candidate == 0xFF) {
 		return;
-	else if (b_iqk_ok) {
+	} else if (b_iqk_ok) {
 		oldval_0 = (rtl_get_bbreg(hw, ROFDM0_XATXIQIMBALANCE,
 					  MASKDWORD) >> 22) & 0x3FF;
 		x = result[final_candidate][0];
@@ -1512,9 +1495,9 @@ static void _rtl92c_phy_path_b_fill_iqk_matrix(struct ieee80211_hw *hw,
 	u32 oldval_1, x, tx1_a, reg;
 	long y, tx1_c;
 
-	if (final_candidate == 0xFF)
+	if (final_candidate == 0xFF) {
 		return;
-	else if (b_iqk_ok) {
+	} else if (b_iqk_ok) {
 		oldval_1 = (rtl_get_bbreg(hw, ROFDM0_XBTXIQIMBALANCE,
 					  MASKDWORD) >> 22) & 0x3FF;
 		x = result[final_candidate][4];
@@ -1609,9 +1592,9 @@ static void _rtl92c_phy_mac_setting_calibration(struct ieee80211_hw *hw,
 						u32 *macreg, u32 *macbackup)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 i;
+	u32 i = 0;
 
-	rtl_write_byte(rtlpriv, macreg[0], 0x3F);
+	rtl_write_byte(rtlpriv, macreg[i], 0x3F);
 
 	for (i = 1; i < (IQK_MAC_REG_NUM - 1); i++)
 		rtl_write_byte(rtlpriv, macreg[i],
@@ -1928,7 +1911,7 @@ static void _rtl92c_phy_ap_calibrate(struct ieee80211_hw *hw,
 		0x04db25a4, 0x0b1b25a4
 	};
 
-	u32 apk_offset[PATH_NUM] = { 0xb68, 0xb6c };
+	const u32 apk_offset[PATH_NUM] = { 0xb68, 0xb6c };
 
 	u32 apk_normal_offset[PATH_NUM] = { 0xb28, 0xb98 };
 
@@ -1957,13 +1940,15 @@ static void _rtl92c_phy_ap_calibrate(struct ieee80211_hw *hw,
 		0x00050006
 	};
 
-	const u32 apk_result[PATH_NUM][APK_BB_REG_NUM];
+	u32 apk_result[PATH_NUM][APK_BB_REG_NUM];
 
 	long bb_offset, delta_v, delta_offset;
 
 	if (!is2t)
 		pathbound = 1;
 
+	return;
+
 	for (index = 0; index < PATH_NUM; index++) {
 		apk_offset[index] = apk_normal_offset[index];
 		apk_value[index] = apk_normal_value[index];
@@ -2455,7 +2440,7 @@ bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype)
 	return true;
 }
 
-void rtl92c_phy_set_io(struct ieee80211_hw *hw)
+static void rtl92c_phy_set_io(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -2484,7 +2469,7 @@ void rtl92c_phy_set_io(struct ieee80211_hw *hw)
 		 ("<---(%#x)\n", rtlphy->current_io_type));
 }
 
-void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw)
+static void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
index ca4daee..c370be7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
@@ -30,56 +30,55 @@
 #ifndef __RTL92C_PHY_H__
 #define __RTL92C_PHY_H__
 
-#define MAX_PRECMD_CNT			16
+#define MAX_PRECMD_CNT				16
 #define MAX_RFDEPENDCMD_CNT		16
 #define MAX_POSTCMD_CNT			16
 
 #define MAX_DOZE_WAITING_TIMES_9x	64
 
-#define RT_CANNOT_IO(hw)		false
+#define RT_CANNOT_IO(hw)			false
 #define HIGHPOWER_RADIOA_ARRAYLEN	22
 
-#define MAX_TOLERANCE			5
-#define	IQK_DELAY_TIME			1
+#define IQK_ADDA_REG_NUM			16
+#define MAX_TOLERANCE				5
+#define	IQK_DELAY_TIME				1
 
-#define	APK_BB_REG_NUM			5
-#define	APK_AFE_REG_NUM			16
-#define	APK_CURVE_REG_NUM		4
-#define	PATH_NUM			2
+#define	APK_BB_REG_NUM				5
+#define	APK_AFE_REG_NUM				16
+#define	APK_CURVE_REG_NUM			4
+#define	PATH_NUM					2
 
-#define LOOP_LIMIT			5
-#define MAX_STALL_TIME			50
+#define LOOP_LIMIT					5
+#define MAX_STALL_TIME				50
 #define AntennaDiversityValue		0x80
 #define MAX_TXPWR_IDX_NMODE_92S		63
-#define Reset_Cnt_Limit			3
+#define Reset_Cnt_Limit				3
 
-#define IQK_ADDA_REG_NUM		16
-#define IQK_MAC_REG_NUM			4
+#define IQK_ADDA_REG_NUM			16
+#define IQK_MAC_REG_NUM				4
 
-#define RF90_PATH_MAX			2
-#define CHANNEL_MAX_NUMBER		14
-#define CHANNEL_GROUP_MAX		3
+#define IQK_DELAY_TIME				1
 
-#define CT_OFFSET_MAC_ADDR		0X16
+#define RF90_PATH_MAX				2
 
-#define CT_OFFSET_CCK_TX_PWR_IDX	0x5A
-#define CT_OFFSET_HT401S_TX_PWR_IDX	0x60
-#define CT_OFFSET_HT402S_TX_PWR_IDX_DIF	0x66
-#define CT_OFFSET_HT20_TX_PWR_IDX_DIFF	0x69
-#define CT_OFFSET_OFDM_TX_PWR_IDX_DIFF	0x6C
+#define CT_OFFSET_MAC_ADDR			0X16
 
-#define CT_OFFSET_HT40_MAX_PWR_OFFSET	0x6F
-#define CT_OFFSET_HT20_MAX_PWR_OFFSET	0x72
+#define CT_OFFSET_CCK_TX_PWR_IDX			0x5A
+#define CT_OFFSET_HT401S_TX_PWR_IDX			0x60
+#define CT_OFFSET_HT402S_TX_PWR_IDX_DIFF	0x66
+#define CT_OFFSET_HT20_TX_PWR_IDX_DIFF		0x69
+#define CT_OFFSET_OFDM_TX_PWR_IDX_DIFF		0x6C
 
-#define CT_OFFSET_CHANNEL_PLAH		0x75
-#define CT_OFFSET_THERMAL_METER		0x78
-#define CT_OFFSET_RF_OPTION		0x79
-#define CT_OFFSET_VERSION		0x7E
-#define CT_OFFSET_CUSTOMER_ID		0x7F
+#define CT_OFFSET_HT40_MAX_PWR_OFFSET		0x6F
+#define CT_OFFSET_HT20_MAX_PWR_OFFSET		0x72
 
-#define RTL92C_MAX_PATH_NUM		2
-#define CHANNEL_MAX_NUMBER		14
-#define CHANNEL_GROUP_MAX		3
+#define CT_OFFSET_CHANNEL_PLAH				0x75
+#define CT_OFFSET_THERMAL_METER				0x78
+#define CT_OFFSET_RF_OPTION					0x79
+#define CT_OFFSET_VERSION					0x7E
+#define CT_OFFSET_CUSTOMER_ID				0x7F
+
+#define RTL92C_MAX_PATH_NUM					2
 
 enum swchnlcmd_id {
 	CMDID_END,
@@ -217,21 +216,13 @@ extern void rtl92c_phy_set_bw_mode(struct ieee80211_hw *hw,
 extern void rtl92c_phy_sw_chnl_callback(struct ieee80211_hw *hw);
 extern u8 rtl92c_phy_sw_chnl(struct ieee80211_hw *hw);
 extern void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery);
-extern void rtl92c_phy_set_beacon_hw_reg(struct ieee80211_hw *hw,
-					 u16 beaconinterval);
 void rtl92c_phy_ap_calibrate(struct ieee80211_hw *hw, char delta);
 void rtl92c_phy_lc_calibrate(struct ieee80211_hw *hw);
 void rtl92c_phy_set_rfpath_switch(struct ieee80211_hw *hw, bool bmain);
 bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					  enum radio_path rfpath);
-extern bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw,
-					      u32 rfpath);
 bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
 extern bool rtl92c_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  enum rf_pwrstate rfpwr_state);
-void rtl92c_phy_config_bb_external_pa(struct ieee80211_hw *hw);
-void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw);
-bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
-void rtl92c_phy_set_io(struct ieee80211_hw *hw);
-
 #endif
+
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index b366e88..4250ada 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -32,6 +32,7 @@
 #include "../wifi.h"
 #include "../core.h"
 #include "../pci.h"
+#include "../efuse.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
@@ -41,10 +42,58 @@
 #include "trx.h"
 #include "led.h"
 
+static void rtl92c_init_aspm_vars(struct ieee80211_hw *hw)
+{
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+
+	/*close ASPM for AMD defaultly */
+	rtlpci->const_amdpci_aspm = 0;
+
+	/*
+	 * ASPM PS mode.
+	 * 0 - Disable ASPM,
+	 * 1 - Enable ASPM without Clock Req,
+	 * 2 - Enable ASPM with Clock Req,
+	 * 3 - Alwyas Enable ASPM with Clock Req,
+	 * 4 - Always Enable ASPM without Clock Req.
+	 * set defult to RTL8192CE:3 RTL8192E:2
+	 * */
+	rtlpci->const_pci_aspm = 3;
+
+	/*Setting for PCI-E device */
+	rtlpci->const_devicepci_aspm_setting = 0x03;
+
+	/*Setting for PCI-E bridge */
+	rtlpci->const_hostpci_aspm_setting = 0x02;
+
+	/*
+	 * In Hw/Sw Radio Off situation.
+	 * 0 - Default,
+	 * 1 - From ASPM setting without low Mac Pwr,
+	 * 2 - From ASPM setting with low Mac Pwr,
+	 * 3 - Bus D3
+	 * set default to RTL8192CE:0 RTL8192SE:2
+	 */
+	rtlpci->const_hwsw_rfoff_d3 = 0;
+
+	/*
+	 * This setting works for those device with
+	 * backdoor ASPM setting such as EPHY setting.
+	 * 0 - Not support ASPM,
+	 * 1 - Support ASPM,
+	 * 2 - According to chipset.
+	 */
+	rtlpci->const_support_pciaspm = 1;
+}
+
 int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 {
+	int err = 0;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	const struct firmware *firmware;
+
+	rtl8192ce_bt_reg_init(hw);
 
 	rtlpriv->dm.b_dm_initialgain_enable = 1;
 	rtlpriv->dm.dm_flag = 0;
@@ -52,6 +101,11 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpriv->dm.thermalvalue = 0;
 	rtlpci->transmit_config = CFENDFORM | BIT(12) | BIT(13);
 
+	/* compatible 5G band 88ce just 2.4G band & smsp */
+	rtlpriv->rtlhal.current_bandtype = BAND_ON_2_4G;
+	rtlpriv->rtlhal.bandset = BAND_ON_2_4G;
+	rtlpriv->rtlhal.macphymode = SINGLEMAC_SINGLEPHY;
+
 	rtlpci->receive_config = (RCR_APPFCS |
 				  RCR_AMF |
 				  RCR_ADF |
@@ -75,6 +129,24 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 
 	rtlpci->irq_mask[1] = (u32) (IMR_CPWM | IMR_C2HCMD | 0);
 
+	/* for LPS & IPS */
+	rtlpriv->psc.b_inactiveps = true;
+	rtlpriv->psc.b_swctrl_lps = false;
+	rtlpriv->psc.b_fwctrl_lps = true;
+	rtlpriv->psc.b_reg_fwctrl_lps = 3;
+	rtlpriv->psc.reg_max_lps_awakeintvl = 5;
+	/* for ASPM, you can close aspm through
+	 * set const_support_pciaspm = 0 */
+	rtl92c_init_aspm_vars(hw);
+
+	if (rtlpriv->psc.b_reg_fwctrl_lps == 1)
+		rtlpriv->psc.fwctrl_psmode = FW_PS_MIN_MODE;
+	else if (rtlpriv->psc.b_reg_fwctrl_lps == 2)
+		rtlpriv->psc.fwctrl_psmode = FW_PS_MAX_MODE;
+	else if (rtlpriv->psc.b_reg_fwctrl_lps == 3)
+		rtlpriv->psc.fwctrl_psmode = FW_PS_DTIM_MODE;
+
+	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = (u8 *) vmalloc(0x4000);
 	if (!rtlpriv->rtlhal.pfirmware) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
@@ -82,7 +154,25 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 		return 1;
 	}
 
-	return 0;
+	/* request fw */
+	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
+			rtlpriv->io.dev);
+	if (err) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("Failed to request firmware!\n"));
+		return 1;
+	}
+	if (firmware->size > 0x4000) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("Firmware is too big!\n"));
+		release_firmware(firmware);
+		return 1;
+	}
+	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
+	rtlpriv->rtlhal.fwsize = firmware->size;
+	release_firmware(firmware);
+
+	return err;
 }
 
 void rtl92c_deinit_sw_vars(struct ieee80211_hw *hw)
@@ -102,9 +192,12 @@ static struct rtl_hal_ops rtl8192ce_hal_ops = {
 	.interrupt_recognized = rtl92ce_interrupt_recognized,
 	.hw_init = rtl92ce_hw_init,
 	.hw_disable = rtl92ce_card_disable,
+	.hw_suspend = rtl92ce_suspend,
+	.hw_resume = rtl92ce_resume,
 	.enable_interrupt = rtl92ce_enable_interrupt,
 	.disable_interrupt = rtl92ce_disable_interrupt,
 	.set_network_type = rtl92ce_set_network_type,
+	.set_chk_bssid = rtl92ce_set_check_bssid,
 	.set_qos = rtl92ce_set_qos,
 	.set_bcn_reg = rtl92ce_set_beacon_related_registers,
 	.set_bcn_intv = rtl92ce_set_beacon_interval,
@@ -130,7 +223,6 @@ static struct rtl_hal_ops rtl8192ce_hal_ops = {
 	.enable_hw_sec = rtl92ce_enable_hw_security_config,
 	.set_key = rtl92ce_set_key,
 	.init_sw_leds = rtl92ce_init_sw_leds,
-	.deinit_sw_leds = rtl92ce_deinit_sw_leds,
 	.get_bbreg = rtl92c_phy_query_bb_reg,
 	.set_bbreg = rtl92c_phy_set_bb_reg,
 	.get_rfreg = rtl92c_phy_query_rf_reg,
@@ -142,6 +234,7 @@ static struct rtl_mod_params rtl92ce_mod_params = {
 };
 
 static struct rtl_hal_cfg rtl92ce_hal_cfg = {
+	.bar_id = 2,
 	.name = "rtl92c_pci",
 	.fw_name = "rtlwifi/rtl8192cfw.bin",
 	.ops = &rtl8192ce_hal_ops,
@@ -165,6 +258,8 @@ static struct rtl_hal_cfg rtl92ce_hal_cfg = {
 	.maps[EFUSE_LOADER_CLK_EN] = LOADER_CLK_EN,
 	.maps[EFUSE_ANA8M] = EFUSE_ANA8M,
 	.maps[EFUSE_HWSET_MAX_SIZE] = HWSET_MAX_SIZE,
+	.maps[EFUSE_MAX_SECTION_MAP] = EFUSE_MAX_SECTION,
+	.maps[EFUSE_REAL_CONTENT_SIZE] = EFUSE_REAL_CONTENT_LEN,
 
 	.maps[RWCAM] = REG_CAMCMD,
 	.maps[WCAMI] = REG_CAMWRITE,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
index de1198c..251283b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
@@ -30,8 +30,11 @@
 #ifndef __RTL92CE_SW_H__
 #define __RTL92CE_SW_H__
 
+#define EFUSE_MAX_SECTION	16
+
 int rtl92c_init_sw_vars(struct ieee80211_hw *hw);
 void rtl92c_deinit_sw_vars(struct ieee80211_hw *hw);
 void rtl92c_init_var_map(struct ieee80211_hw *hw);
 
 #endif
+
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index bf5852f..89fbe4f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -252,9 +252,10 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct phy_sts_cck_8192s_t *cck_buf;
 	s8 rx_pwr_all, rx_pwr[4];
-	u8 rf_rx_num, evm, pwdb_all;
+	u8 rf_rx_num = 0, evm, pwdb_all;
 	u8 i, max_spatial_stream;
-	u32 rssi, total_rssi;
+	u32 rssi, total_rssi = 0;
+	bool b_in_powersavemode = false;
 	bool is_cck_rate;
 
 	is_cck_rate = RX_HAL_IS_CCK_RATE(pdesc);
@@ -270,9 +271,13 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 		u8 report, cck_highpwr;
 		cck_buf = (struct phy_sts_cck_8192s_t *)p_drvinfo;
 
-		cck_highpwr = (u8) rtl_get_bbreg(hw,
-					 RFPGA0_XA_HSSIPARAMETER2,
-					 BIT(9));
+		if (!b_in_powersavemode)
+			cck_highpwr = (u8)rtl_get_bbreg(hw,
+						 RFPGA0_XA_HSSIPARAMETER2,
+						 BIT(9));
+		else
+			cck_highpwr = false;
+
 		if (!cck_highpwr) {
 			u8 cck_agc_rpt = cck_buf->cck_agc_rpt;
 			report = cck_buf->cck_agc_rpt & 0xc0;
@@ -424,10 +429,6 @@ static void _rtl92ce_process_ui_rssi(struct ieee80211_hw *hw,
 	if (!pstats->b_is_cck && pstats->b_packet_toself) {
 		for (rfpath = RF90_PATH_A; rfpath < rtlphy->num_total_rfpath;
 		     rfpath++) {
-
-			if (!rtl8192_phy_check_is_legal_rfpath(hw, rfpath))
-				continue;
-
 			if (rtlpriv->stats.rx_rssi_percentage[rfpath] == 0) {
 				rtlpriv->stats.rx_rssi_percentage[rfpath] =
 				    pstats->rx_mimo_signalstrength[rfpath];
@@ -721,7 +722,8 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			  struct ieee80211_tx_info *info, struct sk_buff *skb,
-			  unsigned int queue_index)
+			  unsigned int queue_index,
+			  struct rtl_tcb_desc *ptcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
@@ -732,12 +734,10 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 	struct ieee80211_sta *sta = ieee80211_find_sta(mac->vif, mac->bssid);
 
 	u8 *pdesc = (u8 *) pdesc_tx;
-	struct rtl_tcb_desc tcb_desc;
 	u8 *qc = ieee80211_get_qos_ctl(hdr);
 	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 	u16 seq_number;
 	u16 fc = le16_to_cpu(hdr->frame_control);
-	u8 rate_flag = info->control.rates[0].flags;
 
 	enum rtl_desc_qsel fw_qsel =
 	    _rtl92ce_map_hwqueue_to_fwqueue(le16_to_cpu(hdr->frame_control),
@@ -755,16 +755,16 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 
 	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
 
-	rtl_get_tcb_desc(hw, info, skb, &tcb_desc);
+	rtl_get_tcb_desc(hw, info, skb, ptcb_desc);
 
 	CLEAR_PCI_TX_DESC_CONTENT(pdesc, sizeof(struct tx_desc_92c));
 
 	if (b_firstseg) {
 		SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
 
-		SET_TX_DESC_TX_RATE(pdesc, tcb_desc.hw_rate);
+		SET_TX_DESC_TX_RATE(pdesc, ptcb_desc->hw_rate);
 
-		if (tcb_desc.use_shortgi || tcb_desc.use_shortpreamble)
+		if (ptcb_desc->use_shortgi || ptcb_desc->use_shortpreamble)
 			SET_TX_DESC_DATA_SHORTGI(pdesc, 1);
 
 		if (mac->tids[tid].agg.agg_state == RTL_AGG_ON &&
@@ -774,34 +774,32 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 		}
 		SET_TX_DESC_SEQ(pdesc, seq_number);
 
-		SET_TX_DESC_RTS_ENABLE(pdesc, ((tcb_desc.b_rts_enable &&
-						!tcb_desc.
+		SET_TX_DESC_RTS_ENABLE(pdesc, ((ptcb_desc->b_rts_enable &&
+						!ptcb_desc->
 						b_cts_enable) ? 1 : 0));
 		SET_TX_DESC_HW_RTS_ENABLE(pdesc,
-					  ((tcb_desc.b_rts_enable
-					    || tcb_desc.b_cts_enable) ? 1 : 0));
-		SET_TX_DESC_CTS2SELF(pdesc, ((tcb_desc.b_cts_enable) ? 1 : 0));
-		SET_TX_DESC_RTS_STBC(pdesc, ((tcb_desc.b_rts_stbc) ? 1 : 0));
+					  ((ptcb_desc->b_rts_enable
+					  || ptcb_desc->b_cts_enable) ? 1 : 0));
+		SET_TX_DESC_CTS2SELF(pdesc,
+				     ((ptcb_desc->b_cts_enable) ? 1 : 0));
+		SET_TX_DESC_RTS_STBC(pdesc, ((ptcb_desc->b_rts_stbc) ? 1 : 0));
 
-		SET_TX_DESC_RTS_RATE(pdesc, tcb_desc.rts_rate);
+		SET_TX_DESC_RTS_RATE(pdesc, ptcb_desc->rts_rate);
 		SET_TX_DESC_RTS_BW(pdesc, 0);
-		SET_TX_DESC_RTS_SC(pdesc, tcb_desc.rts_sc);
+		SET_TX_DESC_RTS_SC(pdesc, ptcb_desc->rts_sc);
 		SET_TX_DESC_RTS_SHORT(pdesc,
-				      ((tcb_desc.rts_rate <= DESC92C_RATE54M) ?
-				      (tcb_desc.b_rts_use_shortpreamble ? 1 : 0)
-				      : (tcb_desc.b_rts_use_shortgi ? 1 : 0)));
+				   ((ptcb_desc->rts_rate <= DESC92C_RATE54M) ?
+				   (ptcb_desc->b_rts_use_shortpreamble ? 1 : 0)
+				   : (ptcb_desc->b_rts_use_shortgi ? 1 : 0)));
 
 		if (mac->bw_40) {
-			if (tcb_desc.b_packet_bw) {
+			if (ptcb_desc->b_packet_bw) {
 				SET_TX_DESC_DATA_BW(pdesc, 1);
 				SET_TX_DESC_TX_SUB_CARRIER(pdesc, 3);
 			} else {
 				SET_TX_DESC_DATA_BW(pdesc, 0);
-
-				if (rate_flag & IEEE80211_TX_RC_DUP_DATA) {
-					SET_TX_DESC_TX_SUB_CARRIER(pdesc,
-							mac->cur_40_prime_sc);
-				}
+				SET_TX_DESC_TX_SUB_CARRIER(pdesc,
+							 mac->cur_40_prime_sc);
 			}
 		} else {
 			SET_TX_DESC_DATA_BW(pdesc, 0);
@@ -842,7 +840,7 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_DATA_RATE_FB_LIMIT(pdesc, 0x1F);
 		SET_TX_DESC_RTS_RATE_FB_LIMIT(pdesc, 0xF);
 		SET_TX_DESC_DISABLE_FB(pdesc, 0);
-		SET_TX_DESC_USE_RATE(pdesc, tcb_desc.use_driver_rate ? 1 : 0);
+		SET_TX_DESC_USE_RATE(pdesc, ptcb_desc->use_driver_rate ? 1 : 0);
 
 		if (ieee80211_is_data_qos(fc)) {
 			if (mac->rdg_en) {
@@ -862,15 +860,14 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
 
 	if (rtlpriv->dm.b_useramask) {
-		SET_TX_DESC_RATE_ID(pdesc, tcb_desc.ratr_index);
-		SET_TX_DESC_MACID(pdesc, tcb_desc.mac_id);
+		SET_TX_DESC_RATE_ID(pdesc, ptcb_desc->ratr_index);
+		SET_TX_DESC_MACID(pdesc, ptcb_desc->mac_id);
 	} else {
-		SET_TX_DESC_RATE_ID(pdesc, 0xC + tcb_desc.ratr_index);
-		SET_TX_DESC_MACID(pdesc, tcb_desc.ratr_index);
+		SET_TX_DESC_RATE_ID(pdesc, 0xC + ptcb_desc->ratr_index);
+		SET_TX_DESC_MACID(pdesc, ptcb_desc->ratr_index);
 	}
 
-	if ((!ieee80211_is_data_qos(fc)) && ppsc->b_leisure_ps &&
-	    ppsc->b_fwctrl_lps) {
+	if ((!ieee80211_is_data_qos(fc)) && ppsc->b_fwctrl_lps) {
 		SET_TX_DESC_HWSEQ_EN(pdesc, 1);
 		SET_TX_DESC_PKT_ID(pdesc, 8);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
index 53d0e0a..f4596dc 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
@@ -700,7 +700,8 @@ struct rx_desc_92c {
 void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr,
 			  u8 *pdesc, struct ieee80211_tx_info *info,
-			  struct sk_buff *skb, unsigned int qsel);
+			  struct sk_buff *skb, unsigned int qsel,
+			  struct rtl_tcb_desc *ptcb_desc);
 bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 			   struct rtl_stats *stats,
 			   struct ieee80211_rx_status *rx_status,
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index d44d796..75dad5c 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -34,6 +34,7 @@
 #include <linux/firmware.h>
 #include <linux/version.h>
 #include <linux/etherdevice.h>
+#include <linux/usb.h>
 #include <net/mac80211.h>
 #include "debug.h"
 
@@ -75,13 +76,26 @@
 #define ETH_P_PAE		0x888E	/*Port Access Entity (IEEE 802.1X) */
 #define ETH_P_IP		0x0800	/*Internet Protocol packet */
 #define ETH_P_ARP		0x0806	/*Address Resolution packet */
-#define SNAP_SIZE		6
-#define PROTOC_TYPE_SIZE	2
+#define SNAP_SIZE			6
+#define PROTOC_TYPE_SIZE		2
 
 /*related with 802.11 frame*/
-#define MAC80211_3ADDR_LEN			24
-#define MAC80211_4ADDR_LEN			30
-
+#define MAC80211_3ADDR_LEN		24
+#define MAC80211_4ADDR_LEN		30
+
+#define CHANNEL_MAX_NUMBER	(14 + 24 + 21)	/* 14 is the max channel no */
+#define CHANNEL_GROUP_MAX	(3 + 9)	/*  ch1~3, 4~9, 10~14 = three groups */
+#define MAX_PG_GROUP			13
+#define	CHANNEL_GROUP_MAX_2G		3
+#define	CHANNEL_GROUP_IDX_5GL		3
+#define	CHANNEL_GROUP_IDX_5GM		6
+#define	CHANNEL_GROUP_IDX_5GH		9
+#define	CHANNEL_GROUP_MAX_5G		9
+#define CHANNEL_MAX_NUMBER_2G		14
+#define AVG_THERMAL_NUM			8
+
+/* for early mode */
+#define EM_HDR_LEN				8
 enum intf_type {
 	INTF_PCI = 0,
 	INTF_USB = 1,
@@ -113,11 +127,38 @@ enum hardware_type {
 	HARDWARE_TYPE_RTL8192CU,
 	HARDWARE_TYPE_RTL8192DE,
 	HARDWARE_TYPE_RTL8192DU,
+	HARDWARE_TYPE_RTL8723E,
+	HARDWARE_TYPE_RTL8723U,
 
-	/*keep it last*/
+	/* keep it last */
 	HARDWARE_TYPE_NUM
 };
 
+#define IS_HARDWARE_TYPE_8192SU(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192SU)
+#define IS_HARDWARE_TYPE_8192SE(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE)
+#define IS_HARDWARE_TYPE_8192CE(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192CE)
+#define IS_HARDWARE_TYPE_8192CU(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192CU)
+#define IS_HARDWARE_TYPE_8192DE(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192DE)
+#define IS_HARDWARE_TYPE_8192DU(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192DU)
+#define IS_HARDWARE_TYPE_8723E(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8723E)
+#define IS_HARDWARE_TYPE_8723U(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8723U)
+#define	IS_HARDWARE_TYPE_8192S(rtlhal)			\
+(IS_HARDWARE_TYPE_8192SE(rtlhal) || IS_HARDWARE_TYPE_8192SU(rtlhal))
+#define	IS_HARDWARE_TYPE_8192C(rtlhal)			\
+(IS_HARDWARE_TYPE_8192CE(rtlhal) || IS_HARDWARE_TYPE_8192CU(rtlhal))
+#define	IS_HARDWARE_TYPE_8192D(rtlhal)			\
+(IS_HARDWARE_TYPE_8192DE(rtlhal) || IS_HARDWARE_TYPE_8192DU(rtlhal))
+#define	IS_HARDWARE_TYPE_8723(rtlhal)			\
+(IS_HARDWARE_TYPE_8723E(rtlhal) || IS_HARDWARE_TYPE_8723U(rtlhal))
+
 enum scan_operation_backup_opt {
 	SCAN_OPT_BACKUP = 0,
 	SCAN_OPT_RESTORE,
@@ -315,6 +356,7 @@ enum rf_type {
 	RF_1T1R = 0,
 	RF_1T2R = 1,
 	RF_2T2R = 2,
+	RF_2T2R_GREEN = 3,
 };
 
 enum ht_channel_width {
@@ -359,6 +401,8 @@ enum rtl_var_map {
 	EFUSE_LOADER_CLK_EN,
 	EFUSE_ANA8M,
 	EFUSE_HWSET_MAX_SIZE,
+	EFUSE_MAX_SECTION_MAP,
+	EFUSE_REAL_CONTENT_SIZE,
 
 	/*CAM map */
 	RWCAM,
@@ -397,6 +441,7 @@ enum rtl_var_map {
 	RTL_IMR_ATIMEND,	/*For 92C,ATIM Window End Interrupt */
 	RTL_IMR_BDOK,		/*Beacon Queue DMA OK Interrup */
 	RTL_IMR_HIGHDOK,	/*High Queue DMA OK Interrupt */
+	RTL_IMR_COMDOK,		/*Command Queue DMA OK Interrupt*/
 	RTL_IMR_TBDOK,		/*Transmit Beacon OK interrup */
 	RTL_IMR_MGNTDOK,	/*Management Queue DMA OK Interrupt */
 	RTL_IMR_TBDER,		/*For 92C,Transmit Beacon Error Interrupt */
@@ -481,6 +526,19 @@ enum acm_method {
 	eAcmWay2_SW = 2,
 };
 
+enum macphy_mode {
+	SINGLEMAC_SINGLEPHY = 0,
+	DUALMAC_DUALPHY,
+	DUALMAC_SINGLEPHY,
+};
+
+enum band_type {
+	BAND_ON_2_4G = 0,
+	BAND_ON_5G,
+	BAND_ON_BOTH,
+	BANDMAX
+};
+
 /*aci/aifsn Field.
 Ref: WMM spec 2.2.2: WME Parameter Element, p.12.*/
 union aci_aifsn {
@@ -505,6 +563,17 @@ enum wireless_mode {
 	WIRELESS_MODE_N_5G = 0x20
 };
 
+#define IS_WIRELESS_MODE_A(wirelessmode)	\
+	(wirelessmode == WIRELESS_MODE_A)
+#define IS_WIRELESS_MODE_B(wirelessmode)	\
+	(wirelessmode == WIRELESS_MODE_B)
+#define IS_WIRELESS_MODE_G(wirelessmode)	\
+	(wirelessmode == WIRELESS_MODE_G)
+#define IS_WIRELESS_MODE_N_24G(wirelessmode)	\
+	(wirelessmode == WIRELESS_MODE_N_24G)
+#define IS_WIRELESS_MODE_N_5G(wirelessmode)	\
+	(wirelessmode == WIRELESS_MODE_N_5G)
+
 enum ratr_table_mode {
 	RATR_INX_WIRELESS_NGB = 0,
 	RATR_INX_WIRELESS_NG = 1,
@@ -603,6 +672,8 @@ struct false_alarm_statistics {
 	u32 cnt_rate_illegal;
 	u32 cnt_crc8_fail;
 	u32 cnt_mcs_fail;
+	u32 cnt_fast_fsync_fail;
+	u32 cnt_sb_search_fail;
 	u32 cnt_ofdm_fail;
 	u32 cnt_cck_fail;
 	u32 cnt_all;
@@ -690,6 +761,32 @@ struct rtl_rfkill {
 	bool rfkill_state;	/*0 is off, 1 is on */
 };
 
+#define IQK_MATRIX_REG_NUM	8
+#define IQK_MATRIX_SETTINGS_NUM	(1 + 24 + 21)
+struct iqk_matrix_regs {
+	bool b_iqk_done;
+	long value[1][IQK_MATRIX_REG_NUM];
+};
+
+struct phy_parameters {
+	u16 length;
+	u32 *pdata;
+};
+
+enum hw_param_tab_index {
+	PHY_REG_2T,
+	PHY_REG_1T,
+	PHY_REG_PG,
+	RADIOA_2T,
+	RADIOB_2T,
+	RADIOA_1T,
+	RADIOB_1T,
+	MAC_REG,
+	AGCTAB_2T,
+	AGCTAB_1T,
+	MAX_TAB
+};
+
 struct rtl_phy {
 	struct bb_reg_def phyreg_def[4];	/*Radio A/B/C/D */
 	struct init_gain initgain_backup;
@@ -705,8 +802,9 @@ struct rtl_phy {
 	u8 current_channel;
 	u8 h2c_box_num;
 	u8 set_io_inprogress;
+	u8 lck_inprogress;
 
-	/*record for power tracking*/
+	/* record for power tracking */
 	s32 reg_e94;
 	s32 reg_e9c;
 	s32 reg_ea4;
@@ -723,26 +821,33 @@ struct rtl_phy {
 	u32 iqk_mac_backup[IQK_MAC_REG_NUM];
 	u32 iqk_bb_backup[10];
 
+	/* Dul mac */
+	bool b_need_iqk;
+	struct iqk_matrix_regs iqk_matrix_regsetting[IQK_MATRIX_SETTINGS_NUM];
+
 	bool b_rfpi_enable;
 
 	u8 pwrgroup_cnt;
 	u8 bcck_high_power;
-	/* 3 groups of pwr diff by rates*/
-	u32 mcs_txpwrlevel_origoffset[4][16];
+	/* 3 gropus of pwr diff by rates */
+	u32 mcs_txpwrlevel_origoffset[MAX_PG_GROUP][16];
 	u8 default_initialgain[4];
 
-	/*the current Tx power level*/
+	/* the current Tx power level */
 	u8 cur_cck_txpwridx;
 	u8 cur_ofdm24g_txpwridx;
 
 	u32 rfreg_chnlval[2];
 	bool b_apk_done;
+	u32 reg_rf3c[2];	/* pathA / pathB  */
 
-	/*fsync*/
+	/* bfsync */
 	u8 framesync;
 	u32 framesync_c34;
 
 	u8 num_total_rfpath;
+	struct phy_parameters hwparam_tables[MAX_TAB];
+	u16 rf_pathmap;
 };
 
 #define MAX_TID_COUNT				9
@@ -768,6 +873,7 @@ struct rtl_tid_data {
 struct rtl_priv;
 struct rtl_io {
 	struct device *dev;
+	struct mutex bb_mutex;
 
 	/*PCI MEM map */
 	unsigned long pci_mem_end;	/*shared mem end        */
@@ -779,11 +885,14 @@ struct rtl_io {
 	void (*write8_async) (struct rtl_priv *rtlpriv, u32 addr, u8 val);
 	void (*write16_async) (struct rtl_priv *rtlpriv, u32 addr, u16 val);
 	void (*write32_async) (struct rtl_priv *rtlpriv, u32 addr, u32 val);
-
-	 u8(*read8_sync) (struct rtl_priv *rtlpriv, u32 addr);
-	 u16(*read16_sync) (struct rtl_priv *rtlpriv, u32 addr);
-	 u32(*read32_sync) (struct rtl_priv *rtlpriv, u32 addr);
-
+	int (*writeN_async) (struct rtl_priv *rtlpriv, u32 addr, u16 len,
+			     u8 *pdata);
+
+	u8(*read8_sync) (struct rtl_priv *rtlpriv, u32 addr);
+	u16(*read16_sync) (struct rtl_priv *rtlpriv, u32 addr);
+	u32(*read32_sync) (struct rtl_priv *rtlpriv, u32 addr);
+	int (*readN_sync) (struct rtl_priv *rtlpriv, u32 addr, u16 len,
+			    u8 *pdata);
 };
 
 struct rtl_mac {
@@ -815,16 +924,24 @@ struct rtl_mac {
 	bool act_scanning;
 	u8 cnt_after_linked;
 
-	 /*RDG*/ bool rdg_en;
+	/* early mode */
+	/* skb wait queue */
+	struct sk_buff_head skb_waitq[MAX_TID_COUNT];
+	u8 earlymode_threshold;
+
+	/*RDG*/
+	bool rdg_en;
 
-	 /*AP*/ u8 bssid[6];
-	u8 mcs[16];	/*16 bytes mcs for HT rates.*/
-	u32 basic_rates; /*b/g rates*/
+	/*AP*/
+	u8 bssid[6];
+	u32 vendor;
+	u8 mcs[16];	/* 16 bytes mcs for HT rates. */
+	u32 basic_rates; /* b/g rates */
 	u8 ht_enable;
 	u8 sgi_40;
 	u8 sgi_20;
 	u8 bw_40;
-	u8 mode;		/*wireless mode*/
+	u8 mode;		/* wireless mode */
 	u8 slot_time;
 	u8 short_preamble;
 	u8 use_cts_protect;
@@ -835,9 +952,11 @@ struct rtl_mac {
 	u8 retry_long;
 	u16 assoc_id;
 
-	 /*IBSS*/ int beacon_interval;
+	/*IBSS*/
+	int beacon_interval;
 
-	 /*AMPDU*/ u8 min_space_cfg;	/*For Min spacing configurations */
+	/*AMPDU*/
+	u8 min_space_cfg;	/*For Min spacing configurations */
 	u8 max_mss_density;
 	u8 current_ampdu_factor;
 	u8 current_ampdu_density;
@@ -852,17 +971,54 @@ struct rtl_hal {
 
 	enum intf_type interface;
 	u16 hw_type;		/*92c or 92d or 92s and so on */
+	u8 ic_class;
 	u8 oem_id;
-	u8 version;		/*version of chip */
+	u32 version;		/*version of chip */
 	u8 state;		/*stop 0, start 1 */
 
 	/*firmware */
+	u32 fwsize;
 	u8 *pfirmware;
+	u16 fw_version;
+	u16 fw_subversion;
 	bool b_h2c_setinprogress;
 	u8 last_hmeboxnum;
 	bool bfw_ready;
 	/*Reserve page start offset except beacon in TxQ. */
 	u8 fw_rsvdpage_startoffset;
+	u8 h2c_txcmd_seq;
+
+	/* FW Cmd IO related */
+	u16 fwcmd_iomap;
+	u32 fwcmd_ioparam;
+	bool set_fwcmd_inprogress;
+	u8 current_fwcmd_io;
+
+	/**/
+	bool driver_going2unload;
+
+	/*AMPDU init min space*/
+	u8 minspace_cfg;	/*For Min spacing configurations */
+
+	/* Dul mac */
+	enum macphy_mode macphymode;
+	enum band_type current_bandtype;	/* 0:2.4G, 1:5G */
+	enum band_type current_bandtypebackup;
+	enum band_type bandset;
+	/* dual MAC 0--Mac0 1--Mac1 */
+	u32 interfaceindex;
+	/* just for DulMac S3S4 */
+	u8 macphyctl_reg;
+	bool b_earlymode_eanble;
+	/* Dul mac*/
+	bool during_mac0init_radiob;
+	bool during_mac1init_radioa;
+	bool reloadtxpowerindex;
+	/* True if IMR or IQK  have done
+	for 2.4G in scan progress */
+	bool b_load_imrandiqk_setting_for2g;
+
+	bool disable_amsdu_8k;
 };
 
 struct rtl_security {
@@ -896,39 +1052,52 @@ struct rtl_dm {
 	bool bcurrent_turbo_edca;
 	bool bis_any_nonbepkts;	/*out dm */
 	bool bis_cur_rdlstate;
-	bool btxpower_trackingInit;
+	bool btxpower_trackinginit;
 	bool b_disable_framebursting;
 	bool b_cck_inch14;
 	bool btxpower_tracking;
 	bool b_useramask;
 	bool brfpath_rxenable[4];
+	bool binform_fw_driverctrldm;
+	bool bcurrent_mrc_switch;
+	u8 txpowercount;
 
+	u8 thermalvalue_rxgain;
 	u8 thermalvalue_iqk;
 	u8 thermalvalue_lck;
 	u8 thermalvalue;
 	u8 last_dtp_lvl;
+	u8 thermalvalue_avg[AVG_THERMAL_NUM];
+	u8 thermalvalue_avg_index;
+	bool bdone_txpower;
 	u8 dynamic_txhighpower_lvl;	/*Tx high power level */
-	u8 dm_flag;	/*Indicate if each dynamic mechanism's status. */
+	u8 dm_flag;		/*Indicate each dynamic mechanism's status. */
 	u8 dm_type;
 	u8 txpower_track_control;
-
+	bool binterrupt_migration;
+	bool bdisable_tx_int;
 	char ofdm_index[2];
 	char cck_index;
+	u8 power_index_backup[6];
 };
 
-#define	EFUSE_MAX_LOGICAL_SIZE			 128
+#define	EFUSE_MAX_LOGICAL_SIZE		256
 
 struct rtl_efuse {
 	bool bautoLoad_ok;
 	bool bootfromefuse;
 	u16 max_physical_size;
-	u8 contents[EFUSE_MAX_LOGICAL_SIZE];
 
 	u8 efuse_map[2][EFUSE_MAX_LOGICAL_SIZE];
 	u16 efuse_usedbytes;
 	u8 efuse_usedpercentage;
+#ifdef EFUSE_REPG_WORKAROUND
+	bool efuse_re_pg_sec1flag;
+	u8 efuse_re_pg_data[8];
+#endif
 
 	u8 autoload_failflag;
+	u8 autoload_status;
 
 	short epromtype;
 	u16 eeprom_vid;
@@ -938,47 +1107,67 @@ struct rtl_efuse {
 	u8 eeprom_oemid;
 	u16 eeprom_channelplan;
 	u8 eeprom_version;
+	u8 board_type;
+	u8 external_pa;
 
 	u8 dev_addr[6];
 
 	bool b_txpwr_fromeprom;
+	u8 eeprom_crystalcap;
 	u8 eeprom_tssi[2];
-	u8 eeprom_pwrlimit_ht20[3];
-	u8 eeprom_pwrlimit_ht40[3];
-	u8 eeprom_chnlarea_txpwr_cck[2][3];
-	u8 eeprom_chnlarea_txpwr_ht40_1s[2][3];
-	u8 eeprom_chnlarea_txpwr_ht40_2sdiif[2][3];
-	u8 txpwrlevel_cck[2][14];
-	u8 txpwrlevel_ht40_1s[2][14];	/*For HT 40MHZ pwr */
-	u8 txpwrlevel_ht40_2s[2][14];	/*For HT 40MHZ pwr */
+	u8 eeprom_tssi_5g[3][2]; /* for 5GL/5GM/5GH band. */
+	u8 eeprom_pwrlimit_ht20[CHANNEL_GROUP_MAX];
+	u8 eeprom_pwrlimit_ht40[CHANNEL_GROUP_MAX];
+	u8 eeprom_chnlarea_txpwr_cck[2][CHANNEL_GROUP_MAX_2G];
+	u8 eeprom_chnlarea_txpwr_ht40_1s[2][CHANNEL_GROUP_MAX];
+	u8 eeprom_chnlarea_txpwr_ht40_2sdiif[2][CHANNEL_GROUP_MAX];
+	u8 txpwrlevel_cck[2][CHANNEL_MAX_NUMBER_2G];
+	u8 txpwrlevel_ht40_1s[2][CHANNEL_MAX_NUMBER];	/*For HT 40MHZ pwr */
+	u8 txpwrlevel_ht40_2s[2][CHANNEL_MAX_NUMBER];	/*For HT 40MHZ pwr */
+
+	u8 internal_pa_5g[2];	/* pathA / pathB */
+	u8 eeprom_c9;
+	u8 eeprom_cc;
 
 	/*For power group */
-	u8 pwrgroup_ht20[2][14];
-	u8 pwrgroup_ht40[2][14];
-
-	char txpwr_ht20diff[2][14];	/*HT 20<->40 Pwr diff */
-	u8 txpwr_legacyhtdiff[2][14];	/*For HT<->legacy pwr diff */
+	u8 eeprom_pwrgroup[2][3];
+	u8 pwrgroup_ht20[2][CHANNEL_MAX_NUMBER];
+	u8 pwrgroup_ht40[2][CHANNEL_MAX_NUMBER];
+
+	char txpwr_ht20diff[2][CHANNEL_MAX_NUMBER]; /*HT 20<->40 Pwr diff */
+	/*For HT<->legacy pwr diff*/
+	u8 txpwr_legacyhtdiff[2][CHANNEL_MAX_NUMBER];
+	u8 txpwr_safetyflag;			/* Band edge enable flag */
+	u16 eeprom_txpowerdiff;
+	u8 legacy_httxpowerdiff;	/* Legacy to HT rate power diff */
+	u8 antenna_txpwdiff[3];
 
 	u8 eeprom_regulatory;
 	u8 eeprom_thermalmeter;
-	/*ThermalMeter, index 0 for RFIC0, and 1 for RFIC1 */
-	u8 thermalmeter[2];
+	u8 thermalmeter[2]; /*ThermalMeter, index 0 for RFIC0, 1 for RFIC1 */
+	u16 tssi_13dbm;
+	u8 crystalcap;		/* CrystalCap. */
+	u8 delta_iqk;
+	u8 delta_lck;
 
 	u8 legacy_ht_txpowerdiff;	/*Legacy to HT rate power diff */
 	bool b_apk_thermalmeterignore;
+
+	bool b1x1_recvcombine;
+	bool b1ss_support;
+
+	/*channel plan */
+	u8 channel_plan;
 };
 
 struct rtl_ps_ctl {
+	bool pwrdomain_protect;
 	bool set_rfpowerstate_inprogress;
 	bool b_in_powersavemode;
 	bool rfchange_inprogress;
 	bool b_swrf_processing;
 	bool b_hwradiooff;
 
-	u32 last_sleep_jiffies;
-	u32 last_awake_jiffies;
-	u32 last_delaylps_stamp_jiffies;
-
 	/*
 	 * just for PCIE ASPM
 	 * If it supports ASPM, Offset[560h] = 0x40,
@@ -989,6 +1178,7 @@ struct rtl_ps_ctl {
 
 	/*for LPS */
 	enum rt_psmode dot11_psmode;	/*Power save mode configured. */
+	bool b_swctrl_lps;
 	bool b_leisure_ps;
 	bool b_fwctrl_lps;
 	u8 fwctrl_psmode;
@@ -1011,8 +1201,26 @@ struct rtl_ps_ctl {
 	/*just for PCIE ASPM */
 	u8 const_amdpci_aspm;
 
+	bool b_pwrdown_mode;
+
 	enum rf_pwrstate inactive_pwrstate;
 	enum rf_pwrstate rfpwr_state;	/*cur power state */
+
+	/* for SW LPS*/
+	bool sw_ps_enabled;
+	bool state;
+	bool state_inap;
+	bool multi_buffered;
+	u16 nullfunc_seq;
+	unsigned int dtim_counter;
+	unsigned int sleep_ms;
+	unsigned long last_sleep_jiffies;
+	unsigned long last_awake_jiffies;
+	unsigned long last_delaylps_stamp_jiffies;
+	unsigned long last_dtim;
+	unsigned long last_beacon;
+	unsigned long last_action;
+	unsigned long last_slept;
 };
 
 struct rtl_stats {
@@ -1051,6 +1259,7 @@ struct rtl_stats {
 	u8 rx_drvinfo_size;
 	u8 rx_bufshift;
 	bool b_isampdu;
+	bool b_isfirst_ampdu;
 	bool rx_is40Mhzpacket;
 	u32 rx_pwdb_all;
 	u8 rx_mimo_signalstrength[4];	/*in 0~100 index */
@@ -1096,20 +1305,34 @@ struct rtl_tcb_desc {
 	u8 ratr_index;
 	u8 mac_id;
 	u8 hw_rate;
+
+	u8 b_last_inipkt:1;
+	u8 b_cmd_or_init:1;
+	u8 queue_index;
+
+	/* early mode */
+	u8 empkt_num;
+	/* The max value by HW */
+	u32 empkt_len[5];
 };
 
 struct rtl_hal_ops {
 	int (*init_sw_vars) (struct ieee80211_hw *hw);
 	void (*deinit_sw_vars) (struct ieee80211_hw *hw);
+	void (*read_chip_version)(struct ieee80211_hw *hw);
 	void (*read_eeprom_info) (struct ieee80211_hw *hw);
 	void (*interrupt_recognized) (struct ieee80211_hw *hw,
 				      u32 *p_inta, u32 *p_intb);
 	int (*hw_init) (struct ieee80211_hw *hw);
 	void (*hw_disable) (struct ieee80211_hw *hw);
+	void (*hw_suspend) (struct ieee80211_hw *hw);
+	void (*hw_resume) (struct ieee80211_hw *hw);
 	void (*enable_interrupt) (struct ieee80211_hw *hw);
 	void (*disable_interrupt) (struct ieee80211_hw *hw);
 	int (*set_network_type) (struct ieee80211_hw *hw,
 				 enum nl80211_iftype type);
+	void (*set_chk_bssid)(struct ieee80211_hw *hw,
+				bool check_bssid);
 	void (*set_bw_mode) (struct ieee80211_hw *hw,
 			     enum nl80211_channel_type ch_type);
 	 u8(*switch_channel) (struct ieee80211_hw *hw);
@@ -1125,24 +1348,28 @@ struct rtl_hal_ops {
 	void (*fill_tx_desc) (struct ieee80211_hw *hw,
 			      struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			      struct ieee80211_tx_info *info,
-			      struct sk_buff *skb, unsigned int queue_index);
+			      struct sk_buff *skb, unsigned int queue_index,
+			      struct rtl_tcb_desc *ptcb_desc);
+	void (*fill_fake_txdesc) (struct ieee80211_hw *hw, u8 * pDesc,
+				  u32 buffer_len, bool bIsPsPoll);
 	void (*fill_tx_cmddesc) (struct ieee80211_hw *hw, u8 *pdesc,
 				 bool b_firstseg, bool b_lastseg,
 				 struct sk_buff *skb);
-	 bool(*query_rx_desc) (struct ieee80211_hw *hw,
+	bool (*cmd_send_packet)(struct ieee80211_hw *hw, struct sk_buff *skb);
+	bool (*query_rx_desc) (struct ieee80211_hw *hw,
 			       struct rtl_stats *stats,
 			       struct ieee80211_rx_status *rx_status,
 			       u8 *pdesc, struct sk_buff *skb);
 	void (*set_channel_access) (struct ieee80211_hw *hw);
-	 bool(*radio_onoff_checking) (struct ieee80211_hw *hw, u8 *valid);
+	bool (*radio_onoff_checking) (struct ieee80211_hw *hw, u8 *valid);
 	void (*dm_watchdog) (struct ieee80211_hw *hw);
 	void (*scan_operation_backup) (struct ieee80211_hw *hw, u8 operation);
-	 bool(*set_rf_power_state) (struct ieee80211_hw *hw,
+	bool (*set_rf_power_state) (struct ieee80211_hw *hw,
 				    enum rf_pwrstate rfpwr_state);
 	void (*led_control) (struct ieee80211_hw *hw,
 			     enum led_ctl_mode ledaction);
 	void (*set_desc) (u8 *pdesc, bool istx, u8 desc_name, u8 *val);
-	 u32(*get_desc) (u8 *pdesc, bool istx, u8 desc_name);
+	u32 (*get_desc) (u8 *pdesc, bool istx, u8 desc_name);
 	void (*tx_polling) (struct ieee80211_hw *hw, unsigned int hw_queue);
 	void (*enable_hw_sec) (struct ieee80211_hw *hw);
 	void (*set_key) (struct ieee80211_hw *hw, u32 key_index,
@@ -1150,10 +1377,10 @@ struct rtl_hal_ops {
 			 bool is_wepkey, bool clear_all);
 	void (*init_sw_leds) (struct ieee80211_hw *hw);
 	void (*deinit_sw_leds) (struct ieee80211_hw *hw);
-	 u32(*get_bbreg) (struct ieee80211_hw *hw, u32 regaddr, u32 bitmask);
+	u32 (*get_bbreg) (struct ieee80211_hw *hw, u32 regaddr, u32 bitmask);
 	void (*set_bbreg) (struct ieee80211_hw *hw, u32 regaddr, u32 bitmask,
 			   u32 data);
-	 u32(*get_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
+	u32 (*get_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
 			  u32 regaddr, u32 bitmask);
 	void (*set_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
 			   u32 regaddr, u32 bitmask, u32 data);
@@ -1161,11 +1388,14 @@ struct rtl_hal_ops {
 
 struct rtl_intf_ops {
 	/*com */
+	void (*read_efuse_byte)(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf);
 	int (*adapter_start) (struct ieee80211_hw *hw);
 	void (*adapter_stop) (struct ieee80211_hw *hw);
 
-	int (*adapter_tx) (struct ieee80211_hw *hw, struct sk_buff *skb);
+	int (*adapter_tx) (struct ieee80211_hw *hw, struct sk_buff *skb,
+			struct rtl_tcb_desc *ptcb_desc);
 	int (*reset_trx_ring) (struct ieee80211_hw *hw);
+	bool (*waitq_insert) (struct ieee80211_hw *hw, struct sk_buff *skb);
 
 	/*pci */
 	void (*disable_aspm) (struct ieee80211_hw *hw);
@@ -1179,11 +1409,36 @@ struct rtl_mod_params {
 	int sw_crypto;
 };
 
+struct rtl_hal_usbint_cfg {
+	/* data - rx */
+	u32 in_ep_num;
+	u32 rx_urb_num;
+	u32 rx_max_size;
+
+	/* op - rx */
+	void (*usb_rx_hdl)(struct ieee80211_hw *, struct sk_buff *);
+	void (*usb_rx_segregate_hdl)(struct ieee80211_hw *, struct sk_buff *,
+				     struct sk_buff_head *);
+
+	/* tx */
+	void (*usb_tx_cleanup)(struct ieee80211_hw *, struct sk_buff *);
+	int (*usb_tx_post_hdl)(struct ieee80211_hw *, struct urb *,
+			       struct sk_buff *);
+	struct sk_buff *(*usb_tx_aggregate_hdl)(struct ieee80211_hw *,
+						struct sk_buff_head *);
+
+	/* endpoint mapping */
+	int (*usb_endpoint_mapping)(struct ieee80211_hw *hw);
+	u16 (*usb_mq_to_hwq)(u16 fc, u16 mac80211_queue_index);
+};
+
 struct rtl_hal_cfg {
+	u8 bar_id;
 	char *name;
 	char *fw_name;
 	struct rtl_hal_ops *ops;
 	struct rtl_mod_params *mod_params;
+	struct rtl_hal_usbint_cfg *usb_interface_cfg;
 
 	/*this map used for some registers or vars
 	   defined int HAL but used in MAIN */
@@ -1202,6 +1457,11 @@ struct rtl_locks {
 	spinlock_t rf_ps_lock;
 	spinlock_t rf_lock;
 	spinlock_t lps_lock;
+	spinlock_t waitq_lock;
+	spinlock_t tx_urb_lock;
+
+	/*Dul mac*/
+	spinlock_t cck_and_rw_pagea_lock;
 };
 
 struct rtl_works {
@@ -1218,12 +1478,20 @@ struct rtl_works {
 	struct workqueue_struct *rtl_wq;
 	struct delayed_work watchdog_wq;
 	struct delayed_work ips_nic_off_wq;
+
+	/* For SW LPS */
+	struct delayed_work ps_work;
+	struct delayed_work ps_rfon_wq;
 };
 
 struct rtl_debug {
 	u32 dbgp_type[DBGP_TYPE_MAX];
 	u32 global_debuglevel;
 	u64 global_debugcomponents;
+
+	/* add for proc debug */
+	struct proc_dir_entry *proc_dir;
+	char proc_name[20];
 };
 
 struct rtl_priv {
@@ -1274,6 +1542,91 @@ struct rtl_priv {
 #define rtl_efuse(rtlpriv)	(&((rtlpriv)->efuse))
 #define rtl_psc(rtlpriv)	(&((rtlpriv)->psc))
 
+
+/***************************************
+    Bluetooth Co-existance Related
+****************************************/
+
+enum bt_ant_num {
+	ANT_X2 = 0,
+	ANT_X1 = 1,
+};
+
+enum bt_co_type {
+	BT_2WIRE = 0,
+	BT_ISSC_3WIRE = 1,
+	BT_ACCEL = 2,
+	BT_CSR_BC4 = 3,
+	BT_CSR_BC8 = 4,
+	BT_RTL8756 = 5,
+};
+
+enum bt_cur_state {
+	BT_OFF = 0,
+	BT_ON = 1,
+};
+
+enum bt_service_type {
+	BT_SCO = 0,
+	BT_A2DP = 1,
+	BT_HID = 2,
+	BT_HID_IDLE = 3,
+	BT_SCAN = 4,
+	BT_IDLE = 5,
+	BT_OTHER_ACTION = 6,
+	BT_BUSY = 7,
+	BT_OTHERBUSY = 8,
+	BT_PAN = 9,
+};
+
+enum bt_radio_shared {
+	BT_RADIO_SHARED = 0,
+	BT_RADIO_INDIVIDUAL = 1,
+};
+
+struct bt_coexist_info {
+
+	/* EEPROM BT info. */
+	u8 eeprom_bt_coexist;
+	u8 eeprom_bt_type;
+	u8 eeprom_bt_ant_num;
+	u8 eeprom_bt_ant_isolation;
+	u8 eeprom_bt_radio_shared;
+
+	u8 bt_coexistence;
+	u8 bt_ant_num;
+	u8 bt_coexist_type;
+	u8 bt_state;
+	u8 bt_cur_state;	/* 0:on, 1:off */
+	u8 bt_ant_isolation;	/* 0:good, 1:bad */
+	u8 bt_pape_ctrl;	/* 0:SW, 1:SW/HW dynamic */
+	u8 bt_service;
+	u8 bt_radio_shared_type;
+	u8 bt_rfreg_origin_1e;
+	u8 bt_rfreg_origin_1f;
+	u8 bt_rssi_state;
+	u32 ratio_tx;
+	u32 ratio_pri;
+	u32 bt_edca_ul;
+	u32 bt_edca_dl;
+
+	bool b_init_set;
+	bool b_bt_busy_traffic;
+	bool b_bt_traffic_mode_set;
+	bool b_bt_non_traffic_mode_set;
+
+	bool b_fw_coexist_all_off;
+	bool b_sw_coexist_all_off;
+	u32 current_state;
+	u32 previous_state;
+	u8 bt_pre_rssi_state;
+
+	u8 b_reg_bt_iso;
+	u8 b_reg_bt_sco;
+
+};
+
+
 /****************************************
 	mem access macro define start
 	Call endian free function when
@@ -1396,10 +1749,15 @@ Set subfield of little-endian 4-byte value to specified value.	*/
 		((((u8)__val) & BIT_LEN_MASK_8(__bitlen)) << (__bitoffset)) \
 	);
 
+#define	N_BYTE_ALIGMENT(__value, __aligment) ((__aligment == 1) ? \
+	(__value) : (((__value + __aligment - 1) / __aligment) * __aligment))
+
 /****************************************
 	mem access macro define end
 ****************************************/
 
+#define byte(x, n) ((x >> (8 * n)) & 0xff)
+
 #define packet_get_type(_packet) (EF1BYTE((_packet).octet[0]) & 0xFC)
 #define RTL_WATCH_DOG_TIME	2000
 #define MSECS(t)		msecs_to_jiffies(t)
@@ -1420,6 +1778,8 @@ Set subfield of little-endian 4-byte value to specified value.	*/
 #define	RT_RF_OFF_LEVL_FW_32K		BIT(5)	/*FW in 32k */
 /*Always enable ASPM and Clock Req in initialization.*/
 #define	RT_RF_PS_LEVEL_ALWAYS_ASPM	BIT(6)
+/* no matter RFOFF or SLEEP we set PS_ASPM_LEVL*/
+#define	RT_PS_LEVEL_ASPM		BIT(7)
 /*When LPS is on, disable 2R if no packet is received or transmittd.*/
 #define	RT_RF_LPS_DISALBE_2R		BIT(30)
 #define	RT_RF_LPS_LEVEL_ASPM		BIT(31)	/*LPS with ASPM */
@@ -1434,13 +1794,17 @@ Set subfield of little-endian 4-byte value to specified value.	*/
 	container_of(container_of(x, struct delayed_work, work), y, z)
 
 #define FILL_OCTET_STRING(_os, _octet, _len)	\
-		(_os).octet = (u8 *)(_octet);		\
-		(_os).length = (_len);
+	do {					\
+		(_os). octet = (u8 *)(_octet);		\
+		(_os). length = (_len);		\
+	} while (0);
 
 #define CP_MACADDR(des, src)	\
-	((des)[0] = (src)[0], (des)[1] = (src)[1],\
-	(des)[2] = (src)[2], (des)[3] = (src)[3],\
-	(des)[4] = (src)[4], (des)[5] = (src)[5])
+	(			\
+		((des)[0] = (src)[0], (des)[1] = (src)[1],\
+		(des)[2] = (src)[2], (des)[3] = (src)[3],\
+		(des)[4] = (src)[4], (des)[5] = (src)[5]) \
+	)
 
 static inline u8 rtl_read_byte(struct rtl_priv *rtlpriv, u32 addr)
 {
@@ -1530,3 +1894,4 @@ static inline u8 get_rf_type(struct rtl_phy *rtlphy)
 }
 
 #endif
+
-- 
1.7.1

