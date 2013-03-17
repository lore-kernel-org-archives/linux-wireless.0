Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lerya.net ([213.251.186.118]:47042 "EHLO mx.lerya.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab3CQOMI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 10:12:08 -0400
Date: Sun, 17 Mar 2013 15:12:02 +0100
From: Vincent Brillault <gentoo@lerya.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
Message-ID: <20130317141201.GA2557@Fea.lerya.net> (sfid-20130317_151218_158180_C558F306)
References: <20130307192920.GB8668@Fea.lerya.net>
 <20130308215833.GA2829@Fea.lerya.net>
 <513A960B.2020304@lwfinger.net>
 <20130309113222.GA3009@Fea.lerya.net>
 <513B7E58.9000505@lwfinger.net>
 <20130311183825.GG3009@Fea.lerya.net>
 <20130313080048.GB3484@Fea.lerya.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
In-Reply-To: <20130313080048.GB3484@Fea.lerya.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi again,

I've made more debugging on my system. I joined to this mail the
modification I've made on my checkout of the wireless-testing git (added
a certain number of 'printk') and the output of: module load, interface
start on a gentoo system (association through wpa_supplicant) and module
unload.

The most interesing lines are, in my opinion, l82-84:
get_highest_rix called, rtlmac->opmode = 2, rtlmac->mode = 0
get_highest_rix called, sta not null, mode 4
BAND_ON_2_4G, mode 0, rf_type == RF_2T2R: 15

First, we are in opmode 2, NL80211_IFTYPE_STATION, which seems normal.
At the same time 'sta' is not NULL. From reading this part of the code,
it seems not to be correct with the opmode, as 'sta' is only read if the
opmode is 1, 3 or 7.

Then, as rtlmac->mode is 0, wireless_mode is set to 0, which is
'WIRELESS_MODE_UNKNOWN' and does not really seems to be right. As a
result, 15 is return as the max rate idx, which will directly cause the
overflow warning at line 89 (the max is 12).

I don't know the code well enough to understand why 'sta' is not null
will it contains the correct mode. I'll try to read more code but though
that you might be interested by this.

Thanks in advance,
Vincent Brillault

--HlL+5n6rz5pIUxbD
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="wireless-testing-rtlwifi-debug.patch"

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index d3ce9fb..b70e6c2 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -156,6 +156,8 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	int err = 0;
 
+	printk(KERN_WARNING "rtl_op_add_interface called, vif type: %i\n", vif->type);
+
 	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
 
 	if (mac->vif) {
@@ -169,6 +171,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 	mutex_lock(&rtlpriv->locks.conf_mutex);
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
+		printk(KERN_WARNING "rtl_op_add_interface called: Station\n");
 		if (mac->beacon_enabled == 1) {
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 "NL80211_IFTYPE_STATION\n");
@@ -179,6 +182,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 		}
 		break;
 	case NL80211_IFTYPE_ADHOC:
+		printk(KERN_WARNING "rtl_op_add_interface called: adhoc\n");
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 			 "NL80211_IFTYPE_ADHOC\n");
 
@@ -193,6 +197,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 
 		break;
 	case NL80211_IFTYPE_AP:
+		printk(KERN_WARNING "rtl_op_add_interface called: ap\n");
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 			 "NL80211_IFTYPE_AP\n");
 
@@ -584,6 +589,8 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct ieee80211_sta *sta = NULL;
 
+	printk(KERN_WARNING "rtl_op_bss_info_changed called: %u\n", changed);
+
 	mutex_lock(&rtlpriv->locks.conf_mutex);
 	if ((vif->type == NL80211_IFTYPE_ADHOC) ||
 	    (vif->type == NL80211_IFTYPE_AP) ||
@@ -725,6 +732,8 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BSSID) {
 		u32 basic_rates;
 
+		printk(KERN_WARNING "rtl_op_bss_info_changed : changed & BSS_CHANGED_BSSID (old mode = %i)\n", mac->mode);
+
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BSSID,
 					      (u8 *) bss_conf->bssid);
 
@@ -738,6 +747,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 		rcu_read_lock();
 		sta = get_sta(hw, vif, bss_conf->bssid);
 		if (!sta) {
+			printk(KERN_WARNING "!get_sta(hw, vif, bss_conf->bssid): get out\n");
 			rcu_read_unlock();
 			goto out;
 		}
@@ -758,6 +768,8 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 				mac->mode = WIRELESS_MODE_N_5G;
 		}
 
+		printk(KERN_WARNING "new mode: %i\n", mac->mode);
+
 		/* just station need it, because ibss & ap mode will
 		 * set in sta_add, and will be NULL here */
 		if (mac->opmode == NL80211_IFTYPE_STATION) {
diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index f9f059d..028e834 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -47,6 +47,11 @@ static u8 _rtl_rc_get_highest_rix(struct rtl_priv *rtlpriv,
 	struct rtl_sta_info *sta_entry = NULL;
 	u8 wireless_mode = 0;
 
+	printk(KERN_WARNING "get_highest_rix called, rtlmac->opmode = %i, rtlmac->mode = %i\n", rtlmac->opmode, rtlmac->mode);
+	if (sta) {
+		printk(KERN_WARNING "get_highest_rix called, sta not null, mode %i\n", ((struct rtl_sta_info *) sta->drv_priv)->wireless_mode);
+	}
+
 	/*
 	 *this rate is no use for true rate, firmware
 	 *will control rate at all it just used for
@@ -73,23 +78,32 @@ static u8 _rtl_rc_get_highest_rix(struct rtl_priv *rtlpriv,
 	} else {
 		if (rtlhal->current_bandtype == BAND_ON_2_4G) {
 			if (wireless_mode == WIRELESS_MODE_B) {
+				printk(KERN_WARNING "BAND_ON_2_4G WIRELESS_MODE_B: %i\n", B_MODE_MAX_RIX);
 				return B_MODE_MAX_RIX;
 			} else if (wireless_mode == WIRELESS_MODE_G) {
+				printk(KERN_WARNING "BAND_ON_2_4G WIRELESS_MODE_G: %i\n", G_MODE_MAX_RIX);
 				return G_MODE_MAX_RIX;
 			} else {
-				if (get_rf_type(rtlphy) != RF_2T2R)
+				if (get_rf_type(rtlphy) != RF_2T2R) {
+					printk(KERN_WARNING "BAND_ON_2_4G, mode %i, rf_type != RF_2T2R: %i\n", wireless_mode, N_MODE_MCS7_RIX);
 					return N_MODE_MCS7_RIX;
-				else
+				} else {
+					printk(KERN_WARNING "BAND_ON_2_4G, mode %i, rf_type == RF_2T2R: %i\n", wireless_mode, N_MODE_MCS15_RIX);
 					return N_MODE_MCS15_RIX;
+				}
 			}
 		} else {
 			if (wireless_mode == WIRELESS_MODE_A) {
+				printk(KERN_WARNING "! BAND_ON_2_4G WIRELESS_MODE_A \n");
 				return A_MODE_MAX_RIX;
 			} else {
-				if (get_rf_type(rtlphy) != RF_2T2R)
+				if (get_rf_type(rtlphy) != RF_2T2R) {
+					printk(KERN_WARNING "! BAND_ON_2_4G, mode %i, rf_type != RF_2T2R: %i\n", wireless_mode, N_MODE_MCS7_RIX);
 					return N_MODE_MCS7_RIX;
-				else
+				} else {
+					printk(KERN_WARNING "! BAND_ON_2_4G, mode %i, rf_type != RF_2T2R: %i\n", wireless_mode, N_MODE_MCS15_RIX);
 					return N_MODE_MCS15_RIX;
+				}
 			}
 		}
 	}
@@ -150,10 +164,12 @@ static void rtl_get_rate(void *ppriv, struct ieee80211_sta *sta,
 				try_per_rate, rix, 1, not_data);
 
 	if (!not_data) {
-		for (i = 1; i < 4; i++)
+		for (i = 1; i < 4; i++) {
 			_rtl_rc_rate_set_series(rtlpriv, sta, &rates[i],
 						txrc, i, (rix - i), 1,
 						not_data);
+			printk(KERN_WARNING "rtlwifi/rc.c l154, %i after _rtl_rc_rate_set_series: %i\n", i, rates[i].idx);
+		}
 	}
 }
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cdd7cea..8b3309d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1595,7 +1595,9 @@ static inline struct ieee80211_rate *
 ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
 		      const struct ieee80211_tx_info *c)
 {
-	if (WARN_ON_ONCE(c->control.rates[0].idx < 0))
+	if (WARN_ONCE(c->control.rates[0].idx < 0,
+			"Negative control rate id: %i\n",
+			c->control.rates[0].idx))
 		return NULL;
 	return &hw->wiphy->bands[c->band]->bitrates[c->control.rates[0].idx];
 }
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index dd88381..73577da 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -454,6 +454,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 
 	ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
 
+	printk(KERN_WARNING "rate.c l 457, after get_rates, rates[0].idx: %i\n", info->control.rates[0].idx);
 	/*
 	 * Try to enforce the rateidx mask the user wanted. skip this if the
 	 * default mask (allow all rates) is used to save some processing for
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8914d2d..f8d45d1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -52,7 +52,9 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 		return 0;
 
 	/* uh huh? */
-	if (WARN_ON_ONCE(info->control.rates[0].idx < 0))
+	if (WARN_ONCE(info->control.rates[0].idx < 0,
+			"Negative control rate idx: %i\n",
+			info->control.rates[0].idx))
 		return 0;
 
 	sband = local->hw.wiphy->bands[info->band];
@@ -767,8 +769,11 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 				IEEE80211_TX_RC_USE_RTS_CTS;
 
 		/* RC is busted */
-		if (WARN_ON_ONCE(info->control.rates[i].idx >=
-				 sband->n_bitrates)) {
+		if (WARN_ONCE(info->control.rates[i].idx >=
+				sband->n_bitrates,
+				"Control rate overflow: %i >= %i\n",
+				info->control.rates[i].idx,
+				sband->n_bitrates)) {
 			info->control.rates[i].idx = -1;
 			continue;
 		}

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wireless-testing-rtlwifi-debug.log"

Mar 17 14:16:14 localhost kernel: [ 4773.377767] rtl8192ce 0000:03:00.0: PCI->APIC IRQ transform: INT A -> IRQ 19
Mar 17 14:16:14 localhost kernel: [ 4773.377858] rtl8192ce:_rtl92ce_read_chip_version():<0-0> Chip Version ID: B_CHIP_92C
Mar 17 14:16:14 localhost kernel: [ 4773.379898] cfg80211: World regulatory domain updated:
Mar 17 14:16:14 localhost kernel: [ 4773.379903] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar 17 14:16:14 localhost kernel: [ 4773.379907] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.379911] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.379914] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.379918] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.379921] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388156] cfg80211: Updating information on frequency 2412 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388160] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388163] cfg80211: Updating information on frequency 2417 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388166] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388169] cfg80211: Updating information on frequency 2422 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388173] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388175] cfg80211: Updating information on frequency 2427 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388179] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388181] cfg80211: Updating information on frequency 2432 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388185] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388188] cfg80211: Updating information on frequency 2437 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388191] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388194] cfg80211: Updating information on frequency 2442 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388197] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388200] cfg80211: Updating information on frequency 2447 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388203] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388206] cfg80211: Updating information on frequency 2452 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388209] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388212] cfg80211: Updating information on frequency 2457 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388215] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388218] cfg80211: Updating information on frequency 2462 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388221] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388224] cfg80211: Updating information on frequency 2467 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388228] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388231] cfg80211: Updating information on frequency 2472 MHz with regulatory rule:
Mar 17 14:16:14 localhost kernel: [ 4773.388234] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Mar 17 14:16:14 localhost kernel: [ 4773.388237] cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits it
Mar 17 14:16:14 localhost kernel: [ 4773.388462] rtl8192ce: Using firmware rtlwifi/rtl8192cfw.bin
Mar 17 14:16:14 localhost kernel: [ 4773.388550] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
Mar 17 14:16:14 localhost kernel: [ 4773.388610] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
Mar 17 14:16:14 localhost kernel: [ 4773.388903] rtlwifi: wireless switch is on
Mar 17 14:16:15 localhost kernel: [ 4773.884841] rtl_op_add_interface called, vif type: 2
Mar 17 14:16:15 localhost kernel: [ 4773.884841] rtl_op_add_interface called: Station
Mar 17 14:16:15 localhost kernel: [ 4773.884841] rtl_op_bss_info_changed called: 14
Mar 17 14:16:15 localhost kernel: [ 4773.884974] rtl_op_bss_info_changed called: 8192
Mar 17 14:16:15 localhost kernel: [ 4773.895512] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Mar 17 14:16:15 localhost kernel: [ 4774.143059] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:15 localhost kernel: [ 4774.213039] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:15 localhost kernel: [ 4774.283020] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:15 localhost kernel: [ 4774.353001] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:15 localhost kernel: [ 4774.422985] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:15 localhost kernel: [ 4774.492964] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:16 localhost kernel: [ 4774.562945] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:16 localhost kernel: [ 4774.632928] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:16 localhost kernel: [ 4774.702909] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:16 localhost kernel: [ 4774.772890] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:16 localhost kernel: [ 4774.842872] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:16 localhost kernel: [ 4774.912853] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:16 localhost kernel: [ 4774.982835] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:16 localhost kernel: [ 4774.987847] cfg80211: Found new beacon on frequency: 2472 MHz (Ch 13) on phy0
Mar 17 14:16:16 localhost kernel: [ 4775.013087] wlan0: authenticate with 00:21:1e:4d:57:60
Mar 17 14:16:16 localhost kernel: [ 4775.013087] wlan0: Allocated STA 00:21:1e:4d:57:60
Mar 17 14:16:16 localhost kernel: [ 4775.033084] rtl_op_bss_info_changed called: 262144
Mar 17 14:16:16 localhost kernel: [ 4775.033084] rtl_op_bss_info_changed called: 16384
Mar 17 14:16:16 localhost kernel: [ 4775.033337] rtl_op_bss_info_changed called: 224
Mar 17 14:16:16 localhost kernel: [ 4775.033337] rtl_op_bss_info_changed : changed & BSS_CHANGED_BSSID (old mode = 0)
Mar 17 14:16:16 localhost kernel: [ 4775.033852] !get_sta(hw, vif, bss_conf->bssid): get out
Mar 17 14:16:16 localhost kernel: [ 4775.034814] wlan0: Inserted STA 00:21:1e:4d:57:60
Mar 17 14:16:16 localhost kernel: [ 4775.034814] wlan0: send auth to 00:21:1e:4d:57:60 (try 1/3)
Mar 17 14:16:16 localhost kernel: [ 4775.034814] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:16 localhost kernel: [ 4775.036844] wlan0: authenticated
Mar 17 14:16:16 localhost kernel: [ 4775.036848] wlan0: moving STA 00:21:1e:4d:57:60 to state 2
Mar 17 14:16:16 localhost kernel: [ 4775.036868] rtl8192ce 0000:03:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
Mar 17 14:16:16 localhost kernel: [ 4775.036872] rtl8192ce 0000:03:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
Mar 17 14:16:16 localhost kernel: [ 4775.038819] wlan0: associate with 00:21:1e:4d:57:60 (try 1/3)
Mar 17 14:16:16 localhost kernel: [ 4775.038828] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:16 localhost kernel: [ 4775.040840] wlan0: RX AssocResp from 00:21:1e:4d:57:60 (capab=0x451 status=0 aid=4)
Mar 17 14:16:16 localhost kernel: [ 4775.040846] wlan0: moving STA 00:21:1e:4d:57:60 to state 3
Mar 17 14:16:16 localhost kernel: [ 4775.040865] wlan0: moving STA 00:21:1e:4d:57:60 to state 4
Mar 17 14:16:16 localhost kernel: [ 4775.040875] rtl_op_bss_info_changed called: 1056779
Mar 17 14:16:16 localhost kernel: [ 4775.041875] wlan0: associated
Mar 17 14:16:16 localhost kernel: [ 4775.041888] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Mar 17 14:16:16 localhost kernel: [ 4775.043838] get_highest_rix called, rtlmac->opmode = 2, rtlmac->mode = 0
Mar 17 14:16:16 localhost kernel: [ 4775.044104] get_highest_rix called, sta not null, mode 4
Mar 17 14:16:16 localhost kernel: [ 4775.044365] BAND_ON_2_4G, mode 0, rf_type == RF_2T2R: 15
Mar 17 14:16:16 localhost kernel: [ 4775.044624] rtlwifi/rc.c l154, 1 after _rtl_rc_rate_set_series: 14
Mar 17 14:16:16 localhost kernel: [ 4775.044813] rtlwifi/rc.c l154, 2 after _rtl_rc_rate_set_series: 13
Mar 17 14:16:16 localhost kernel: [ 4775.045081] rtlwifi/rc.c l154, 3 after _rtl_rc_rate_set_series: 12
Mar 17 14:16:16 localhost kernel: [ 4775.045082] rate.c l 457, after get_rates, rates[0].idx: 15
Mar 17 14:16:16 localhost kernel: [ 4775.045084] ------------[ cut here ]------------
Mar 17 14:16:16 localhost kernel: [ 4775.045120] WARNING: at net/mac80211/tx.c:776 ieee80211_tx_h_rate_ctrl+0x3ad/0x496 [mac80211]()
Mar 17 14:16:16 localhost kernel: [ 4775.045124] Hardware name: To Be Filled By O.E.M.
Mar 17 14:16:16 localhost kernel: [ 4775.045125] Control rate overflow: 15 >= 12
Mar 17 14:16:16 localhost kernel: [ 4775.045132] Modules linked in: rtl8192ce rtlwifi rtl8192c_common mac80211 cfg80211 i2c_i801 coretemp [last unloaded: cfg80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045136] Pid: 29773, comm: wpa_supplicant Tainted: G        W    3.9.0-rc2+ #14
Mar 17 14:16:16 localhost kernel: [ 4775.045137] Call Trace:
Mar 17 14:16:16 localhost kernel: [ 4775.045145]  [<c10280f1>] warn_slowpath_common+0x63/0x7a
Mar 17 14:16:16 localhost kernel: [ 4775.045177]  [<fa686bf7>] ? ieee80211_tx_h_rate_ctrl+0x3ad/0x496 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045180]  [<c102816c>] warn_slowpath_fmt+0x26/0x2a
Mar 17 14:16:16 localhost kernel: [ 4775.045211]  [<fa686bf7>] ieee80211_tx_h_rate_ctrl+0x3ad/0x496 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045244]  [<fa6875d8>] invoke_tx_handlers+0x5e/0xf3 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045276]  [<fa6877f6>] ieee80211_tx+0x7a/0xa3 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045308]  [<fa687d33>] ieee80211_xmit+0xb7/0xc0 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045340]  [<fa688895>] ieee80211_subif_start_xmit+0x921/0x93c [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045345]  [<c12c2a22>] ? netif_skb_features+0x9d/0xa7
Mar 17 14:16:16 localhost kernel: [ 4775.045348]  [<c12c702c>] dev_hard_start_xmit+0x27f/0x3a0
Mar 17 14:16:16 localhost kernel: [ 4775.045374]  [<fa672785>] ? sta_info_get+0x2f/0x41 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045378]  [<c12da2e3>] sch_direct_xmit+0x4e/0x103
Mar 17 14:16:16 localhost kernel: [ 4775.045381]  [<c12c72c1>] dev_queue_xmit+0x174/0x2d5
Mar 17 14:16:16 localhost kernel: [ 4775.045385]  [<c1367b92>] packet_sendmsg+0x8fa/0x957
Mar 17 14:16:16 localhost kernel: [ 4775.045389]  [<c12d9728>] ? eth_rebuild_header+0x53/0x53
Mar 17 14:16:16 localhost kernel: [ 4775.045393]  [<c104b3a1>] ? __update_tg_runnable_avg+0x1e/0x41
Mar 17 14:16:16 localhost kernel: [ 4775.045398]  [<c12b77b1>] sock_sendmsg+0x6a/0x85
Mar 17 14:16:16 localhost kernel: [ 4775.045402]  [<c12b6761>] ? copy_from_user+0x8/0xa
Mar 17 14:16:16 localhost kernel: [ 4775.045405]  [<c12b7bc9>] ? move_addr_to_kernel+0x36/0x4e
Mar 17 14:16:16 localhost kernel: [ 4775.045407]  [<c12b8266>] sys_sendto+0xb1/0xcd
Mar 17 14:16:16 localhost kernel: [ 4775.045411]  [<c104473d>] ? __wake_up_common+0x33/0x5b
Mar 17 14:16:16 localhost kernel: [ 4775.045413]  [<c104554e>] ? __wake_up+0x32/0x3b
Mar 17 14:16:16 localhost kernel: [ 4775.045418]  [<c1075c1f>] ? rcu_report_qs_rnp+0xd4/0xdd
Mar 17 14:16:16 localhost kernel: [ 4775.045421]  [<c12b8905>] sys_socketcall+0x105/0x1b9
Mar 17 14:16:16 localhost kernel: [ 4775.045424]  [<c1389fba>] sysenter_do_call+0x12/0x22
Mar 17 14:16:16 localhost kernel: [ 4775.045426] ---[ end trace a47a4b440a33a79e ]---
Mar 17 14:16:16 localhost kernel: [ 4775.045428] ------------[ cut here ]------------
Mar 17 14:16:16 localhost kernel: [ 4775.045459] WARNING: at net/mac80211/tx.c:57 ieee80211_tx_h_calculate_duration+0x8d/0x251 [mac80211]()
Mar 17 14:16:16 localhost kernel: [ 4775.045460] Hardware name: To Be Filled By O.E.M.
Mar 17 14:16:16 localhost kernel: [ 4775.045461] Negative control rate idx: -1
Mar 17 14:16:16 localhost kernel: [ 4775.045466] Modules linked in: rtl8192ce rtlwifi rtl8192c_common mac80211 cfg80211 i2c_i801 coretemp [last unloaded: cfg80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045469] Pid: 29773, comm: wpa_supplicant Tainted: G        W    3.9.0-rc2+ #14
Mar 17 14:16:16 localhost kernel: [ 4775.045469] Call Trace:
Mar 17 14:16:16 localhost kernel: [ 4775.045473]  [<c10280f1>] warn_slowpath_common+0x63/0x7a
Mar 17 14:16:16 localhost kernel: [ 4775.045504]  [<fa6a9a94>] ? ieee80211_tx_h_calculate_duration+0x8d/0x251 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045507]  [<c102816c>] warn_slowpath_fmt+0x26/0x2a
Mar 17 14:16:16 localhost kernel: [ 4775.045538]  [<fa6a9a94>] ieee80211_tx_h_calculate_duration+0x8d/0x251 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045570]  [<fa68763d>] invoke_tx_handlers+0xc3/0xf3 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045601]  [<fa6877f6>] ieee80211_tx+0x7a/0xa3 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045633]  [<fa687d33>] ieee80211_xmit+0xb7/0xc0 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045665]  [<fa688895>] ieee80211_subif_start_xmit+0x921/0x93c [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045669]  [<c12c2a22>] ? netif_skb_features+0x9d/0xa7
Mar 17 14:16:16 localhost kernel: [ 4775.045672]  [<c12c702c>] dev_hard_start_xmit+0x27f/0x3a0
Mar 17 14:16:16 localhost kernel: [ 4775.045697]  [<fa672785>] ? sta_info_get+0x2f/0x41 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045700]  [<c12da2e3>] sch_direct_xmit+0x4e/0x103
Mar 17 14:16:16 localhost kernel: [ 4775.045703]  [<c12c72c1>] dev_queue_xmit+0x174/0x2d5
Mar 17 14:16:16 localhost kernel: [ 4775.045706]  [<c1367b92>] packet_sendmsg+0x8fa/0x957
Mar 17 14:16:16 localhost kernel: [ 4775.045710]  [<c12d9728>] ? eth_rebuild_header+0x53/0x53
Mar 17 14:16:16 localhost kernel: [ 4775.045713]  [<c104b3a1>] ? __update_tg_runnable_avg+0x1e/0x41
Mar 17 14:16:16 localhost kernel: [ 4775.045716]  [<c12b77b1>] sock_sendmsg+0x6a/0x85
Mar 17 14:16:16 localhost kernel: [ 4775.045720]  [<c12b6761>] ? copy_from_user+0x8/0xa
Mar 17 14:16:16 localhost kernel: [ 4775.045723]  [<c12b7bc9>] ? move_addr_to_kernel+0x36/0x4e
Mar 17 14:16:16 localhost kernel: [ 4775.045725]  [<c12b8266>] sys_sendto+0xb1/0xcd
Mar 17 14:16:16 localhost kernel: [ 4775.045728]  [<c104473d>] ? __wake_up_common+0x33/0x5b
Mar 17 14:16:16 localhost kernel: [ 4775.045813]  [<c104554e>] ? __wake_up+0x32/0x3b
Mar 17 14:16:16 localhost kernel: [ 4775.045816]  [<c1075c1f>] ? rcu_report_qs_rnp+0xd4/0xdd
Mar 17 14:16:16 localhost kernel: [ 4775.045819]  [<c12b8905>] sys_socketcall+0x105/0x1b9
Mar 17 14:16:16 localhost kernel: [ 4775.045822]  [<c1389fba>] sysenter_do_call+0x12/0x22
Mar 17 14:16:16 localhost kernel: [ 4775.045823] ---[ end trace a47a4b440a33a79f ]---
Mar 17 14:16:16 localhost kernel: [ 4775.045827] ------------[ cut here ]------------
Mar 17 14:16:16 localhost kernel: [ 4775.045835] WARNING: at include/net/mac80211.h:1600 rtl_get_tcb_desc+0x5a/0x38b [rtlwifi]()
Mar 17 14:16:16 localhost kernel: [ 4775.045835] Hardware name: To Be Filled By O.E.M.
Mar 17 14:16:16 localhost kernel: [ 4775.045836] Negative control rate id: -1
Mar 17 14:16:16 localhost kernel: [ 4775.045842] Modules linked in: rtl8192ce rtlwifi rtl8192c_common mac80211 cfg80211 i2c_i801 coretemp [last unloaded: cfg80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045844] Pid: 29773, comm: wpa_supplicant Tainted: G        W    3.9.0-rc2+ #14
Mar 17 14:16:16 localhost kernel: [ 4775.045844] Call Trace:
Mar 17 14:16:16 localhost kernel: [ 4775.045848]  [<c10280f1>] warn_slowpath_common+0x63/0x7a
Mar 17 14:16:16 localhost kernel: [ 4775.045854]  [<fa7203e0>] ? rtl_get_tcb_desc+0x5a/0x38b [rtlwifi]
Mar 17 14:16:16 localhost kernel: [ 4775.045857]  [<c102816c>] warn_slowpath_fmt+0x26/0x2a
Mar 17 14:16:16 localhost kernel: [ 4775.045863]  [<fa7203e0>] rtl_get_tcb_desc+0x5a/0x38b [rtlwifi]
Mar 17 14:16:16 localhost kernel: [ 4775.045869]  [<fa752b3b>] rtl92ce_tx_fill_desc+0x15f/0x594 [rtl8192ce]
Mar 17 14:16:16 localhost kernel: [ 4775.045878]  [<fa7279e0>] rtl_pci_tx+0x221/0x2f1 [rtlwifi]
Mar 17 14:16:16 localhost kernel: [ 4775.045886]  [<fa7241e3>] rtl_op_tx+0x70/0x83 [rtlwifi]
Mar 17 14:16:16 localhost kernel: [ 4775.045918]  [<fa6871fd>] __ieee80211_tx+0x22f/0x2c5 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045950]  [<fa687811>] ieee80211_tx+0x95/0xa3 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.045982]  [<fa687d33>] ieee80211_xmit+0xb7/0xc0 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.046014]  [<fa688895>] ieee80211_subif_start_xmit+0x921/0x93c [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.046018]  [<c12c2a22>] ? netif_skb_features+0x9d/0xa7
Mar 17 14:16:16 localhost kernel: [ 4775.046021]  [<c12c702c>] dev_hard_start_xmit+0x27f/0x3a0
Mar 17 14:16:16 localhost kernel: [ 4775.046046]  [<fa672785>] ? sta_info_get+0x2f/0x41 [mac80211]
Mar 17 14:16:16 localhost kernel: [ 4775.046049]  [<c12da2e3>] sch_direct_xmit+0x4e/0x103
Mar 17 14:16:16 localhost kernel: [ 4775.046052]  [<c12c72c1>] dev_queue_xmit+0x174/0x2d5
Mar 17 14:16:16 localhost kernel: [ 4775.046055]  [<c1367b92>] packet_sendmsg+0x8fa/0x957
Mar 17 14:16:16 localhost kernel: [ 4775.046058]  [<c12d9728>] ? eth_rebuild_header+0x53/0x53
Mar 17 14:16:16 localhost kernel: [ 4775.046062]  [<c104b3a1>] ? __update_tg_runnable_avg+0x1e/0x41
Mar 17 14:16:16 localhost kernel: [ 4775.046065]  [<c12b77b1>] sock_sendmsg+0x6a/0x85
Mar 17 14:16:16 localhost kernel: [ 4775.046069]  [<c12b6761>] ? copy_from_user+0x8/0xa
Mar 17 14:16:16 localhost kernel: [ 4775.046072]  [<c12b7bc9>] ? move_addr_to_kernel+0x36/0x4e
Mar 17 14:16:16 localhost kernel: [ 4775.046074]  [<c12b8266>] sys_sendto+0xb1/0xcd
Mar 17 14:16:16 localhost kernel: [ 4775.046077]  [<c104473d>] ? __wake_up_common+0x33/0x5b
Mar 17 14:16:16 localhost kernel: [ 4775.046079]  [<c104554e>] ? __wake_up+0x32/0x3b
Mar 17 14:16:16 localhost kernel: [ 4775.046082]  [<c1075c1f>] ? rcu_report_qs_rnp+0xd4/0xdd
Mar 17 14:16:16 localhost kernel: [ 4775.046085]  [<c12b8905>] sys_socketcall+0x105/0x1b9
Mar 17 14:16:16 localhost kernel: [ 4775.046088]  [<c1389fba>] sysenter_do_call+0x12/0x22
Mar 17 14:16:16 localhost kernel: [ 4775.046090] ---[ end trace a47a4b440a33a7a0 ]---
Mar 17 14:16:16 localhost kernel: [ 4775.053601] get_highest_rix called, rtlmac->opmode = 2, rtlmac->mode = 0
Mar 17 14:16:16 localhost kernel: [ 4775.053601] get_highest_rix called, sta not null, mode 4
Mar 17 14:16:16 localhost kernel: [ 4775.053601] BAND_ON_2_4G, mode 0, rf_type == RF_2T2R: 15
Mar 17 14:16:16 localhost kernel: [ 4775.053601] rtlwifi/rc.c l154, 1 after _rtl_rc_rate_set_series: 14
Mar 17 14:16:16 localhost kernel: [ 4775.053601] rtlwifi/rc.c l154, 2 after _rtl_rc_rate_set_series: 13
Mar 17 14:16:16 localhost kernel: [ 4775.053601] rtlwifi/rc.c l154, 3 after _rtl_rc_rate_set_series: 12
Mar 17 14:16:16 localhost kernel: [ 4775.053601] rate.c l 457, after get_rates, rates[0].idx: 15
Mar 17 14:16:16 localhost kernel: [ 4775.428746] get_highest_rix called, rtlmac->opmode = 2, rtlmac->mode = 0
Mar 17 14:16:16 localhost kernel: [ 4775.429016] get_highest_rix called, sta not null, mode 4
Mar 17 14:16:16 localhost kernel: [ 4775.429276] BAND_ON_2_4G, mode 0, rf_type == RF_2T2R: 15
Mar 17 14:16:16 localhost kernel: [ 4775.429536] rtlwifi/rc.c l154, 1 after _rtl_rc_rate_set_series: 14
Mar 17 14:16:16 localhost kernel: [ 4775.429716] rtlwifi/rc.c l154, 2 after _rtl_rc_rate_set_series: 13
Mar 17 14:16:16 localhost kernel: [ 4775.429980] rtlwifi/rc.c l154, 3 after _rtl_rc_rate_set_series: 12
Mar 17 14:16:16 localhost kernel: [ 4775.429981] rate.c l 457, after get_rates, rates[0].idx: 15
Mar 17 14:16:17 localhost kernel: [ 4775.631698] get_highest_rix called, rtlmac->opmode = 2, rtlmac->mode = 0
Mar 17 14:16:17 localhost kernel: [ 4775.631972] get_highest_rix called, sta not null, mode 4
Mar 17 14:16:17 localhost kernel: [ 4775.631973] BAND_ON_2_4G, mode 0, rf_type == RF_2T2R: 15
Mar 17 14:16:17 localhost kernel: [ 4775.631975] rtlwifi/rc.c l154, 1 after _rtl_rc_rate_set_series: 14
Mar 17 14:16:17 localhost kernel: [ 4775.631976] rtlwifi/rc.c l154, 2 after _rtl_rc_rate_set_series: 13
Mar 17 14:16:17 localhost kernel: [ 4775.631977] rtlwifi/rc.c l154, 3 after _rtl_rc_rate_set_series: 12
Mar 17 14:16:17 localhost kernel: [ 4775.631978] rate.c l 457, after get_rates, rates[0].idx: 15
Mar 17 14:16:18 localhost kernel: [ 4776.765384] get_highest_rix called, rtlmac->opmode = 2, rtlmac->mode = 0
Mar 17 14:16:18 localhost kernel: [ 4776.765653] get_highest_rix called, sta not null, mode 4
Mar 17 14:16:18 localhost kernel: [ 4776.765915] BAND_ON_2_4G, mode 0, rf_type == RF_2T2R: 15
Mar 17 14:16:18 localhost kernel: [ 4776.766176] rtlwifi/rc.c l154, 1 after _rtl_rc_rate_set_series: 14
Mar 17 14:16:18 localhost kernel: [ 4776.766358] rtlwifi/rc.c l154, 2 after _rtl_rc_rate_set_series: 13
Mar 17 14:16:18 localhost kernel: [ 4776.766630] rtlwifi/rc.c l154, 3 after _rtl_rc_rate_set_series: 12
Mar 17 14:16:18 localhost kernel: [ 4776.766631] rate.c l 457, after get_rates, rates[0].idx: 15
Mar 17 14:16:19 localhost kernel: [ 4778.352965] get_highest_rix called, rtlmac->opmode = 2, rtlmac->mode = 0
Mar 17 14:16:19 localhost kernel: [ 4778.353235] get_highest_rix called, sta not null, mode 4
Mar 17 14:16:19 localhost kernel: [ 4778.353496] BAND_ON_2_4G, mode 0, rf_type == RF_2T2R: 15
Mar 17 14:16:19 localhost kernel: [ 4778.353757] rtlwifi/rc.c l154, 1 after _rtl_rc_rate_set_series: 14
Mar 17 14:16:19 localhost kernel: [ 4778.353938] rtlwifi/rc.c l154, 2 after _rtl_rc_rate_set_series: 13
Mar 17 14:16:19 localhost kernel: [ 4778.354211] rtlwifi/rc.c l154, 3 after _rtl_rc_rate_set_series: 12
Mar 17 14:16:19 localhost kernel: [ 4778.354212] rate.c l 457, after get_rates, rates[0].idx: 15
Mar 17 14:16:21 localhost kernel: [ 4780.359550] rtl_op_bss_info_changed called: 4096
Mar 17 14:16:22 localhost kernel: [ 4780.544435] get_highest_rix called, rtlmac->opmode = 2, rtlmac->mode = 0
Mar 17 14:16:22 localhost kernel: [ 4780.544712] get_highest_rix called, sta not null, mode 4
Mar 17 14:16:22 localhost kernel: [ 4780.544980] BAND_ON_2_4G, mode 0, rf_type == RF_2T2R: 15
Mar 17 14:16:22 localhost kernel: [ 4780.545248] rtlwifi/rc.c l154, 1 after _rtl_rc_rate_set_series: 14
Mar 17 14:16:22 localhost kernel: [ 4780.545864] rtlwifi/rc.c l154, 2 after _rtl_rc_rate_set_series: 13
Mar 17 14:16:22 localhost kernel: [ 4780.546367] rtlwifi/rc.c l154, 3 after _rtl_rc_rate_set_series: 12
Mar 17 14:16:22 localhost kernel: [ 4780.546367] rate.c l 457, after get_rates, rates[0].idx: 15
Mar 17 14:16:22 localhost kernel: [ 4781.333404] rtl_op_bss_info_changed called: 4096
Mar 17 14:16:25 localhost kernel: [ 4783.563371] wlan0: deauthenticating from 00:21:1e:4d:57:60 by local choice (reason=3)
Mar 17 14:16:25 localhost kernel: [ 4783.563371] rate.c l 457, after get_rates, rates[0].idx: 0
Mar 17 14:16:25 localhost kernel: [ 4783.584807] wlan0: moving STA 00:21:1e:4d:57:60 to state 3
Mar 17 14:16:25 localhost kernel: [ 4783.584807] wlan0: moving STA 00:21:1e:4d:57:60 to state 2
Mar 17 14:16:25 localhost kernel: [ 4783.584807] wlan0: moving STA 00:21:1e:4d:57:60 to state 1
Mar 17 14:16:25 localhost kernel: [ 4783.584807] wlan0: Removed STA 00:21:1e:4d:57:60
Mar 17 14:16:25 localhost kernel: [ 4783.584807] rtl_op_bss_info_changed called: 8351
Mar 17 14:16:25 localhost kernel: [ 4783.584892] rtl_op_bss_info_changed : changed & BSS_CHANGED_BSSID (old mode = 0)
Mar 17 14:16:25 localhost kernel: [ 4783.585433] !get_sta(hw, vif, bss_conf->bssid): get out
Mar 17 14:16:25 localhost kernel: [ 4783.585565] rtl_op_bss_info_changed called: 16384
Mar 17 14:16:25 localhost kernel: [ 4783.586568] cfg80211: All devices are disconnected, going to restore regulatory settings
Mar 17 14:16:25 localhost kernel: [ 4783.586568] cfg80211: Restoring regulatory settings
Mar 17 14:16:25 localhost kernel: [ 4783.586568] cfg80211: Kicking the queue
Mar 17 14:16:25 localhost kernel: [ 4783.586568] cfg80211: Calling CRDA to update world regulatory domain
Mar 17 14:16:25 localhost kernel: [ 4783.590044] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
Mar 17 14:16:25 localhost kernel: [ 4783.590049] cfg80211: World regulatory domain updated:
Mar 17 14:16:25 localhost kernel: [ 4783.590052] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar 17 14:16:25 localhost kernel: [ 4783.590056] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 17 14:16:25 localhost kernel: [ 4783.590059] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar 17 14:16:25 localhost kernel: [ 4783.590063] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Mar 17 14:16:25 localhost kernel: [ 4783.590066] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 17 14:16:25 localhost kernel: [ 4783.590070] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Mar 17 14:16:25 localhost kernel: [ 4783.590692] wlan0: Destroyed STA 00:21:1e:4d:57:60

--HlL+5n6rz5pIUxbD--
