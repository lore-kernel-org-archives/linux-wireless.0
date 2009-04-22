Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZDVPsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 11:48:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1LwegO-0004kX-VY
	for linux-wireless@vger.kernel.org; Wed, 22 Apr 2009 17:48:21 +0200
Message-Id: <20090422154644.236983411@sipsolutions.net> (sfid-20090422_174827_191301_E7E4281F)
References: <20090422154559.528196740@sipsolutions.net>
Date: Wed, 22 Apr 2009 17:46:00 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/2] mac80211: clean up beacon interval settings
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We currently have two beacon interval configuration knobs:
hw.conf.beacon_int and vif.bss_info.beacon_int. This is
rather confusing, even though the former is used when we
beacon ourselves and the latter when we are associated to
an AP.

This just deprecates the hw.conf.beacon_int setting in favour
of always using vif.bss_info.beacon_int. Since it touches all
the beaconing IBSS code anyway, we can also add support for
the cfg80211 IBSS beacon interval configuration easily.

NOTE: The hw.conf.beacon_int setting is retained for now due
      to drivers still using it -- I couldn't untangle all
      drivers, some are updated in this patch.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/ar9170/mac.c       |    6 +++---
 drivers/net/wireless/ath/ar9170/main.c      |    5 ++++-
 drivers/net/wireless/ath/ath5k/base.c       |    5 ++++-
 drivers/net/wireless/ath/ath9k/ath9k.h      |    2 ++
 drivers/net/wireless/ath/ath9k/beacon.c     |    9 +++------
 drivers/net/wireless/ath/ath9k/main.c       |   22 ++++++++++++----------
 drivers/net/wireless/ath/ath9k/xmit.c       |    2 +-
 drivers/net/wireless/b43/main.c             |   12 +++++++-----
 drivers/net/wireless/b43legacy/main.c       |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 +--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 ++---
 drivers/net/wireless/libertas_tf/main.c     |    2 +-
 drivers/net/wireless/mac80211_hwsim.c       |   20 ++++++++++++--------
 include/net/mac80211.h                      |    6 ++++--
 net/mac80211/cfg.c                          |   17 +++++------------
 net/mac80211/ibss.c                         |   25 +++++++++++++++++--------
 net/mac80211/main.c                         |   17 +++++++++++------
 net/mac80211/mlme.c                         |    1 +
 net/mac80211/sta_info.c                     |   12 ++++++------
 net/mac80211/tx.c                           |    2 +-
 21 files changed, 104 insertions(+), 82 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-04-22 14:33:40.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-04-22 15:43:12.000000000 +0200
@@ -149,6 +149,7 @@ struct ieee80211_low_level_stats {
  * @BSS_CHANGED_ERP_SLOT: slot timing changed
  * @BSS_CHANGED_HT: 802.11n parameters changed
  * @BSS_CHANGED_BASIC_RATES: Basic rateset changed
+ * @BSS_CHANGED_BEACON_INT: Beacon interval changed
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -157,6 +158,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_ERP_SLOT		= 1<<3,
 	BSS_CHANGED_HT                  = 1<<4,
 	BSS_CHANGED_BASIC_RATES		= 1<<5,
+	BSS_CHANGED_BEACON_INT		= 1<<6,
 };
 
 /**
@@ -529,7 +531,7 @@ enum ieee80211_conf_flags {
  * enum ieee80211_conf_changed - denotes which configuration changed
  *
  * @IEEE80211_CONF_CHANGE_RADIO_ENABLED: the value of radio_enabled changed
- * @IEEE80211_CONF_CHANGE_BEACON_INTERVAL: the beacon interval changed
+ * @IEEE80211_CONF_CHANGE_BEACON_INTERVAL: DEPRECATED
  * @IEEE80211_CONF_CHANGE_LISTEN_INTERVAL: the listen interval changed
  * @IEEE80211_CONF_CHANGE_RADIOTAP: the radiotap flag changed
  * @IEEE80211_CONF_CHANGE_PS: the PS flag or dynamic PS timeout changed
@@ -554,7 +556,7 @@ enum ieee80211_conf_changed {
  * This struct indicates how the driver shall configure the hardware.
  *
  * @radio_enabled: when zero, driver is required to switch off the radio.
- * @beacon_int: beacon interval (TODO make interface config)
+ * @beacon_int: beacon interval -- deprecated!!
  * @listen_interval: listen interval in units of beacon interval
  * @flags: configuration flags defined above
  * @power_level: requested transmit power (in dBm)
--- wireless-testing.orig/net/mac80211/cfg.c	2009-04-22 14:33:40.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-04-22 15:43:12.000000000 +0200
@@ -451,18 +451,11 @@ static int ieee80211_config_beacon(struc
 	 * This is a kludge. beacon interval should really be part
 	 * of the beacon information.
 	 */
-	if (params->interval && (sdata->local->hw.conf.beacon_int !=
-				 params->interval)) {
-		sdata->local->hw.conf.beacon_int = params->interval;
-		err = ieee80211_hw_config(sdata->local,
-					IEEE80211_CONF_CHANGE_BEACON_INTERVAL);
-		if (err < 0)
-			return err;
-		/*
-		 * We updated some parameter so if below bails out
-		 * it's not an error.
-		 */
-		err = 0;
+	if (params->interval &&
+	    (sdata->vif.bss_conf.beacon_int != params->interval)) {
+		sdata->vif.bss_conf.beacon_int = params->interval;
+		ieee80211_bss_info_change_notify(sdata,
+						 BSS_CHANGED_BEACON_INT);
 	}
 
 	/* Need to have a beacon head if we don't have one yet */
--- wireless-testing.orig/net/mac80211/ibss.c	2009-04-22 14:33:40.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-04-22 14:40:02.000000000 +0200
@@ -73,6 +73,7 @@ static void __ieee80211_sta_join_ibss(st
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
 	struct ieee80211_supported_band *sband;
+	u32 bss_change;
 
 	if (local->ops->reset_tsf) {
 		/* Reset own TSF to allow time synchronization work. */
@@ -92,8 +93,6 @@ static void __ieee80211_sta_join_ibss(st
 
 	memcpy(ifibss->bssid, bssid, ETH_ALEN);
 
-	local->hw.conf.beacon_int = beacon_int >= 10 ? beacon_int : 10;
-
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
 	ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
@@ -101,6 +100,12 @@ static void __ieee80211_sta_join_ibss(st
 	local->oper_channel = chan;
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
+	sdata->vif.bss_conf.beacon_int = beacon_int;
+	bss_change = BSS_CHANGED_BEACON_INT;
+	bss_change |= ieee80211_reset_erp_info(sdata);
+	ieee80211_bss_info_change_notify(sdata, bss_change);
+
 	sband = local->hw.wiphy->bands[chan->band];
 
 	/* Build IBSS probe response */
@@ -111,7 +116,7 @@ static void __ieee80211_sta_join_ibss(st
 	memset(mgmt->da, 0xff, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(mgmt->bssid, ifibss->bssid, ETH_ALEN);
-	mgmt->u.beacon.beacon_int = cpu_to_le16(local->hw.conf.beacon_int);
+	mgmt->u.beacon.beacon_int = cpu_to_le16(beacon_int);
 	mgmt->u.beacon.timestamp = cpu_to_le64(tsf);
 	mgmt->u.beacon.capab_info = cpu_to_le16(capability);
 
@@ -181,8 +186,13 @@ static void __ieee80211_sta_join_ibss(st
 static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_bss *bss)
 {
+	u16 beacon_int = bss->cbss.beacon_interval;
+
+	if (beacon_int < 10)
+		beacon_int = 10;
+
 	__ieee80211_sta_join_ibss(sdata, bss->cbss.bssid,
-				  bss->cbss.beacon_interval,
+				  beacon_int,
 				  bss->cbss.channel,
 				  bss->supp_rates_len, bss->supp_rates,
 				  bss->cbss.capability,
@@ -471,9 +481,6 @@ static void ieee80211_sta_create_ibss(st
 
 	sband = local->hw.wiphy->bands[ifibss->channel->band];
 
-	if (local->hw.conf.beacon_int == 0)
-		local->hw.conf.beacon_int = 100;
-
 	capability = WLAN_CAPABILITY_IBSS;
 
 	if (sdata->default_key)
@@ -487,7 +494,7 @@ static void ieee80211_sta_create_ibss(st
 		*pos++ = (u8) (rate / 5);
 	}
 
-	__ieee80211_sta_join_ibss(sdata, bssid, local->hw.conf.beacon_int,
+	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
 				  ifibss->channel, sband->n_bitrates,
 				  supp_rates, capability, 0);
 }
@@ -836,6 +843,8 @@ int ieee80211_ibss_join(struct ieee80211
 	} else
 		sdata->u.ibss.fixed_bssid = false;
 
+	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
+
 	sdata->u.ibss.channel = params->channel;
 	sdata->u.ibss.fixed_channel = params->channel_fixed;
 
--- wireless-testing.orig/net/mac80211/main.c	2009-04-22 14:33:40.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-04-22 15:43:18.000000000 +0200
@@ -294,9 +294,6 @@ void ieee80211_bss_info_change_notify(st
 {
 	struct ieee80211_local *local = sdata->local;
 
-	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
-		return;
-
 	if (!changed)
 		return;
 
@@ -305,6 +302,17 @@ void ieee80211_bss_info_change_notify(st
 					     &sdata->vif,
 					     &sdata->vif.bss_conf,
 					     changed);
+
+	/*
+	 * DEPRECATED
+	 *
+	 * ~changed is just there to not do this at resume time
+	 */
+	if (changed & BSS_CHANGED_BEACON_INT && ~changed) {
+		local->hw.conf.beacon_int = sdata->vif.bss_conf.beacon_int;
+		ieee80211_hw_config(local,
+				    IEEE80211_CONF_CHANGE_BEACON_INTERVAL);
+	}
 }
 
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
@@ -969,9 +977,6 @@ int ieee80211_register_hw(struct ieee802
 
 	debugfs_hw_add(local);
 
-	if (local->hw.conf.beacon_int < 10)
-		local->hw.conf.beacon_int = 100;
-
 	if (local->hw.max_listen_interval == 0)
 		local->hw.max_listen_interval = 1;
 
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-04-22 14:33:40.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2009-04-22 14:39:33.000000000 +0200
@@ -543,9 +543,8 @@ void sta_info_unlink(struct sta_info **s
 	spin_unlock_irqrestore(&local->sta_lock, flags);
 }
 
-static inline int sta_info_buffer_expired(struct ieee80211_local *local,
-					  struct sta_info *sta,
-					  struct sk_buff *skb)
+static int sta_info_buffer_expired(struct sta_info *sta,
+				   struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info;
 	int timeout;
@@ -556,8 +555,9 @@ static inline int sta_info_buffer_expire
 	info = IEEE80211_SKB_CB(skb);
 
 	/* Timeout: (2 * listen_interval * beacon_int * 1024 / 1000000) sec */
-	timeout = (sta->listen_interval * local->hw.conf.beacon_int * 32 /
-		   15625) * HZ;
+	timeout = (sta->listen_interval *
+		   sta->sdata->vif.bss_conf.beacon_int *
+		   32 / 15625) * HZ;
 	if (timeout < STA_TX_BUFFER_EXPIRE)
 		timeout = STA_TX_BUFFER_EXPIRE;
 	return time_after(jiffies, info->control.jiffies + timeout);
@@ -577,7 +577,7 @@ static void sta_info_cleanup_expire_buff
 	for (;;) {
 		spin_lock_irqsave(&sta->ps_tx_buf.lock, flags);
 		skb = skb_peek(&sta->ps_tx_buf);
-		if (sta_info_buffer_expired(local, sta, skb))
+		if (sta_info_buffer_expired(sta, skb))
 			skb = __skb_dequeue(&sta->ps_tx_buf);
 		else
 			skb = NULL;
--- wireless-testing.orig/net/mac80211/tx.c	2009-04-22 14:33:40.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-04-22 14:39:33.000000000 +0200
@@ -2132,7 +2132,7 @@ struct sk_buff *ieee80211_beacon_get(str
 		memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 		/* BSSID is left zeroed, wildcard value */
 		mgmt->u.beacon.beacon_int =
-			cpu_to_le16(local->hw.conf.beacon_int);
+			cpu_to_le16(sdata->vif.bss_conf.beacon_int);
 		mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
 
 		pos = skb_put(skb, 2);
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-22 14:33:40.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-22 14:39:33.000000000 +0200
@@ -826,6 +826,7 @@ static void ieee80211_set_associated(str
 		sdata->vif.bss_conf.timestamp = bss->cbss.tsf;
 		sdata->vif.bss_conf.dtim_period = bss->dtim_period;
 
+		bss_info_changed |= BSS_CHANGED_BEACON_INT;
 		bss_info_changed |= ieee80211_handle_bss_capability(sdata,
 			bss->cbss.capability, bss->has_erp_value, bss->erp_value);
 
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/mac.c	2009-04-22 14:49:41.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ar9170/mac.c	2009-04-22 14:51:26.000000000 +0200
@@ -316,9 +316,9 @@ int ar9170_set_beacon_timers(struct ar91
 	u32 v = 0;
 	u32 pretbtt = 0;
 
-	v |= ar->hw->conf.beacon_int;
-
 	if (ar->vif) {
+		v |= ar->vif->bss_conf.beacon_int;
+
 		switch (ar->vif->type) {
 		case NL80211_IFTYPE_MESH_POINT:
 		case NL80211_IFTYPE_ADHOC:
@@ -326,7 +326,7 @@ int ar9170_set_beacon_timers(struct ar91
 			break;
 		case NL80211_IFTYPE_AP:
 			v |= BIT(24);
-			pretbtt = (ar->hw->conf.beacon_int - 6) << 16;
+			pretbtt = (ar->vif->bss_conf.beacon_int - 6) << 16;
 			break;
 		default:
 			break;
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2009-04-22 14:47:42.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2009-04-22 14:49:23.000000000 +0200
@@ -1337,7 +1337,7 @@ static int ar9170_op_config(struct ieee8
 			goto out;
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_BEACON_INTERVAL) {
+	if (changed & BSS_CHANGED_BEACON_INT) {
 		err = ar9170_set_beacon_timers(ar);
 		if (err)
 			goto out;
@@ -1499,6 +1499,9 @@ static void ar9170_op_bss_info_changed(s
 #endif /* CONFIG_AR9170_LEDS */
 	}
 
+	if (changed & BSS_CHANGED_BEACON_INT)
+		err = ar9170_set_beacon_timers(ar);
+
 	if (changed & BSS_CHANGED_HT) {
 		/* TODO */
 		err = 0;
--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/base.c	2009-04-22 14:50:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath5k/base.c	2009-04-22 14:52:58.000000000 +0200
@@ -2756,7 +2756,6 @@ ath5k_config(struct ieee80211_hw *hw, u3
 
 	mutex_lock(&sc->lock);
 
-	sc->bintval = conf->beacon_int;
 	sc->power_level = conf->power_level;
 
 	ret = ath5k_chan_set(sc, conf->channel);
@@ -3083,6 +3082,10 @@ static void ath5k_bss_info_changed(struc
 				    u32 changes)
 {
 	struct ath5k_softc *sc = hw->priv;
+
+	if (changes & BSS_CHANGED_BEACON_INT)
+		sc->bintval = bss_conf->beacon_int;
+
 	if (changes & BSS_CHANGED_ASSOC) {
 		mutex_lock(&sc->lock);
 		sc->assoc = bss_conf->assoc;
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-04-22 14:42:28.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-04-22 14:46:59.000000000 +0200
@@ -554,18 +554,13 @@ static int mac80211_hwsim_config(struct 
 	struct mac80211_hwsim_data *data = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 
-	printk(KERN_DEBUG "%s:%s (freq=%d radio_enabled=%d beacon_int=%d)\n",
+	printk(KERN_DEBUG "%s:%s (freq=%d radio_enabled=%d)\n",
 	       wiphy_name(hw->wiphy), __func__,
-	       conf->channel->center_freq, conf->radio_enabled,
-	       conf->beacon_int);
+	       conf->channel->center_freq, conf->radio_enabled);
 
 	data->channel = conf->channel;
 	data->radio_enabled = conf->radio_enabled;
-	data->beacon_int = 1024 * conf->beacon_int / 1000 * HZ / 1000;
-	if (data->beacon_int < 1)
-		data->beacon_int = 1;
-
-	if (!data->started || !data->radio_enabled)
+	if (!data->started || !data->radio_enabled || !data->beacon_int)
 		del_timer(&data->beacon_timer);
 	else
 		mod_timer(&data->beacon_timer, jiffies + data->beacon_int);
@@ -616,6 +611,7 @@ static void mac80211_hwsim_bss_info_chan
 					    u32 changed)
 {
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+	struct mac80211_hwsim_data *data = hw->priv;
 
 	hwsim_check_magic(vif);
 
@@ -629,6 +625,14 @@ static void mac80211_hwsim_bss_info_chan
 		vp->aid = info->aid;
 	}
 
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		printk(KERN_DEBUG "  %s: BCNINT: %d\n",
+		       wiphy_name(hw->wiphy), info->beacon_int);
+		data->beacon_int = 1024 * info->beacon_int / 1000 * HZ / 1000;
+		if (WARN_ON(data->beacon_int))
+			data->beacon_int = 1;
+	}
+
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
 		printk(KERN_DEBUG "  %s: ERP_CTS_PROT: %d\n",
 		       wiphy_name(hw->wiphy), info->use_cts_prot);
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-04-22 14:51:33.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-04-22 14:53:12.000000000 +0200
@@ -3468,11 +3468,6 @@ static int b43_op_config(struct ieee8021
 	if (phy->ops->set_rx_antenna)
 		phy->ops->set_rx_antenna(dev, antenna);
 
-	/* Update templates for AP/mesh mode. */
-	if (b43_is_mode(wl, NL80211_IFTYPE_AP) ||
-	    b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT))
-		b43_set_beacon_int(dev, conf->beacon_int);
-
 	if (!!conf->radio_enabled != phy->radio_on) {
 		if (conf->radio_enabled) {
 			b43_software_rfkill(dev, false);
@@ -3556,6 +3551,13 @@ static void b43_op_bss_info_changed(stru
 		goto out_unlock_mutex;
 	b43_mac_suspend(dev);
 
+	/* Update templates for AP/mesh mode. */
+	if (changed & BSS_CHANGED_BEACON_INT &&
+	    (b43_is_mode(wl, NL80211_IFTYPE_AP) ||
+	     b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT) ||
+	     b43_is_mode(wl, NL80211_IFTYPE_ADHOC)))
+		b43_set_beacon_int(dev, conf->beacon_int);
+
 	if (changed & BSS_CHANGED_BASIC_RATES)
 		b43_update_basic_rates(dev, conf->basic_rates);
 
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/beacon.c	2009-04-22 14:53:56.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/beacon.c	2009-04-22 15:03:50.000000000 +0200
@@ -320,8 +320,7 @@ int ath_beacon_alloc(struct ath_wiphy *a
 		u64 tsfadjust;
 		int intval;
 
-		intval = sc->hw->conf.beacon_int ?
-			sc->hw->conf.beacon_int : ATH_DEFAULT_BINTVAL;
+		intval = sc->beacon_interval ? : ATH_DEFAULT_BINTVAL;
 
 		/*
 		 * Calculate the TSF offset for this beacon slot, i.e., the
@@ -431,8 +430,7 @@ void ath_beacon_tasklet(unsigned long da
 	 * on the tsf to safeguard against missing an swba.
 	 */
 
-	intval = sc->hw->conf.beacon_int ?
-		sc->hw->conf.beacon_int : ATH_DEFAULT_BINTVAL;
+	intval = sc->beacon_interval ? : ATH_DEFAULT_BINTVAL;
 
 	tsf = ath9k_hw_gettsf64(ah);
 	tsftu = TSF_TO_TU(tsf>>32, tsf);
@@ -711,8 +709,7 @@ void ath_beacon_config(struct ath_softc 
 	/* Setup the beacon configuration parameters */
 
 	memset(&conf, 0, sizeof(struct ath_beacon_config));
-	conf.beacon_interval = sc->hw->conf.beacon_int ?
-		sc->hw->conf.beacon_int : ATH_DEFAULT_BINTVAL;
+	conf.beacon_interval = sc->beacon_interval ? : ATH_DEFAULT_BINTVAL;
 	conf.listen_interval = 1;
 	conf.dtim_period = conf.beacon_interval;
 	conf.dtim_count = 1;
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/ath9k.h	2009-04-22 15:01:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/ath9k.h	2009-04-22 15:02:03.000000000 +0200
@@ -589,6 +589,8 @@ struct ath_softc {
 	int led_on_cnt;
 	int led_off_cnt;
 
+	int beacon_interval;
+
 	struct ath_rfkill rf_kill;
 	struct ath_ani ani;
 	struct ath9k_node_stats nodestats;
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-04-22 14:56:31.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-04-22 15:02:37.000000000 +0200
@@ -2301,16 +2301,6 @@ skip_chan_change:
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		sc->config.txpowlimit = 2 * conf->power_level;
 
-	/*
-	 * The HW TSF has to be reset when the beacon interval changes.
-	 * We set the flag here, and ath_beacon_config_ap() would take this
-	 * into account when it gets called through the subsequent
-	 * config_interface() call - with IFCC_BEACON in the changed field.
-	 */
-
-	if (changed & IEEE80211_CONF_CHANGE_BEACON_INTERVAL)
-		sc->sc_flags |= SC_OP_TSF_RESET;
-
 	mutex_unlock(&sc->mutex);
 
 	return 0;
@@ -2578,6 +2568,18 @@ static void ath9k_bss_info_changed(struc
 		ath9k_bss_assoc_info(sc, vif, bss_conf);
 	}
 
+	/*
+	 * The HW TSF has to be reset when the beacon interval changes.
+	 * We set the flag here, and ath_beacon_config_ap() would take this
+	 * into account when it gets called through the subsequent
+	 * config_interface() call - with IFCC_BEACON in the changed field.
+	 */
+
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		sc->sc_flags |= SC_OP_TSF_RESET;
+		sc->beacon_interval = bss_conf->beacon_int;
+	}
+
 	mutex_unlock(&sc->mutex);
 }
 
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/xmit.c	2009-04-22 14:58:06.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c	2009-04-22 15:04:18.000000000 +0200
@@ -971,7 +971,7 @@ int ath_cabq_update(struct ath_softc *sc
 	else if (sc->config.cabqReadytime > ATH9K_READY_TIME_HI_BOUND)
 		sc->config.cabqReadytime = ATH9K_READY_TIME_HI_BOUND;
 
-	qi.tqi_readyTime = (sc->hw->conf.beacon_int *
+	qi.tqi_readyTime = (sc->beacon_interval *
 			    sc->config.cabqReadytime) / 100;
 	ath_txq_update(sc, qnum, &qi);
 
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2009-04-22 15:05:04.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2009-04-22 15:06:55.000000000 +0200
@@ -2721,11 +2721,6 @@ static int b43legacy_op_dev_config(struc
 	/* Antennas for RX and management frame TX. */
 	b43legacy_mgmtframe_txantenna(dev, antenna_tx);
 
-	/* Update templates for AP mode. */
-	if (b43legacy_is_mode(wl, NL80211_IFTYPE_AP))
-		b43legacy_set_beacon_int(dev, conf->beacon_int);
-
-
 	if (!!conf->radio_enabled != phy->radio_on) {
 		if (conf->radio_enabled) {
 			b43legacy_radio_turn_on(dev);
@@ -2827,6 +2822,11 @@ static void b43legacy_op_bss_info_change
 
 	b43legacy_mac_suspend(dev);
 
+	if (changed & BSS_CHANGED_BEACON_INT &&
+	    (b43legacy_is_mode(wl, NL80211_IFTYPE_AP) ||
+	     b43legacy_is_mode(wl, NL80211_IFTYPE_ADHOC)))
+		b43legacy_set_beacon_int(dev, conf->beacon_int);
+
 	if (changed & BSS_CHANGED_BASIC_RATES)
 		b43legacy_update_basic_rates(dev, conf->basic_rates);
 
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-22 15:07:32.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-22 15:08:37.000000000 +0200
@@ -551,7 +551,8 @@ static void iwl3945_setup_rxon_timing(st
 		priv->rxon_timing.atim_window = 0;
 	} else {
 		priv->rxon_timing.beacon_interval =
-			iwl3945_adjust_beacon_interval(conf->beacon_int);
+			iwl3945_adjust_beacon_interval(
+				priv->vif->bss_conf.beacon_int);
 		/* TODO: we need to get atim_window from upper stack
 		 * for now we set to 0 */
 		priv->rxon_timing.atim_window = 0;
@@ -4121,8 +4122,6 @@ static int iwl3945_setup_mac(struct iwl_
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
 
-	hw->conf.beacon_int = 100;
-
 	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
 		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&priv->bands[IEEE80211_BAND_2GHZ];
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-04-22 15:08:46.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-04-22 15:09:11.000000000 +0200
@@ -564,7 +564,8 @@ static void iwl_setup_rxon_timing(struct
 		beacon_int = iwl_adjust_beacon_interval(priv->beacon_int);
 		priv->rxon_timing.atim_window = 0;
 	} else {
-		beacon_int = iwl_adjust_beacon_interval(conf->beacon_int);
+		beacon_int = iwl_adjust_beacon_interval(
+			priv->vif->bss_conf.beacon_int);
 
 		/* TODO: we need to get atim_window from upper stack
 		 * for now we set to 0 */
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-04-22 15:09:51.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-04-22 15:10:08.000000000 +0200
@@ -1309,7 +1309,6 @@ int iwl_setup_mac(struct iwl_priv *priv)
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
 
-	hw->conf.beacon_int = 100;
 	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
 
 	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
@@ -2740,7 +2739,7 @@ void iwl_mac_reset_tsf(struct ieee80211_
 
 	priv->ibss_beacon = NULL;
 
-	priv->beacon_int = priv->hw->conf.beacon_int;
+	priv->beacon_int = priv->vif->bss_conf.beacon_int;
 	priv->timestamp = 0;
 	if ((priv->iw_mode == NL80211_IFTYPE_STATION))
 		priv->beacon_int = 0;
--- wireless-testing.orig/drivers/net/wireless/libertas_tf/main.c	2009-04-22 15:12:04.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas_tf/main.c	2009-04-22 15:12:14.000000000 +0200
@@ -380,7 +380,7 @@ static int lbtf_op_config_interface(stru
 		if (beacon) {
 			lbtf_beacon_set(priv, beacon);
 			kfree_skb(beacon);
-			lbtf_beacon_ctrl(priv, 1, hw->conf.beacon_int);
+			lbtf_beacon_ctrl(priv, 1, vif->bss_conf.beacon_int);
 		}
 		break;
 	default:

-- 

