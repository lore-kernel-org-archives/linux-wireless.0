Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31962 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbYLHKDy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 05:03:54 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 02:03:54 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18748.61509.403330.286366@gargle.gargle.HOWL> (sfid-20081208_110416_636246_35CE21B9)
Date: Mon, 8 Dec 2008 15:30:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>, <johannes@sipsolutions.net>,
	<tomas.winkler@intel.com>
Subject: [RFC] mac80211: fix HT channel selection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HT management is done differently for AP and STA modes, unify
to just the ->config() callback since HT is fundamentally a
PHY property and cannot be per-BSS.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
v2:
---

Add a new NL80211 attribute to enable/disable HT (NL80211_ATTR_WIPHY_HT).
NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET now has only the secondary channel
offsets.

ieee80211_enable_ht() and ieee8021_hw_config() have been cleaned up a bit to handle the revised
nl80211 attributes. I have tested this with ath9k, works okay in both STA and AP mode.

 drivers/net/wireless/ath9k/main.c      |  108 ++++++-------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.c |   21 +++++--
 drivers/net/wireless/mac80211_hwsim.c  |    7 +--
 include/linux/nl80211.h                |    8 +--
 include/net/cfg80211.h                 |    1 +
 include/net/mac80211.h                 |    9 +---
 net/mac80211/cfg.c                     |    2 +
 net/mac80211/ht.c                      |   57 -----------------
 net/mac80211/ieee80211_i.h             |    4 +-
 net/mac80211/main.c                    |   26 ++------
 net/mac80211/mlme.c                    |   68 ++++++++++++++++++++-
 net/mac80211/util.c                    |    3 +-
 net/wireless/nl80211.c                 |   14 +++--
 13 files changed, 131 insertions(+), 197 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 9939749..0a646e9 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -622,8 +622,6 @@ static int ath_get_channel(struct ath_softc *sc,
 	return -1;
 }
 
-/* ext_chan_offset: (-1, 0, 1) (below, none, above) */
-
 static u32 ath_get_extchanmode(struct ath_softc *sc,
 			       struct ieee80211_channel *chan,
 			       int ext_chan_offset,
@@ -633,24 +631,24 @@ static u32 ath_get_extchanmode(struct ath_softc *sc,
 
 	switch (chan->band) {
 	case IEEE80211_BAND_2GHZ:
-		if ((ext_chan_offset == 0) &&
+		if ((ext_chan_offset == NL80211_SEC_CHAN_DISABLED) &&
 		    (tx_chan_width == ATH9K_HT_MACMODE_20))
 			chanmode = CHANNEL_G_HT20;
-		if ((ext_chan_offset == 1) &&
+		if ((ext_chan_offset == NL80211_SEC_CHAN_ABOVE) &&
 		    (tx_chan_width == ATH9K_HT_MACMODE_2040))
 			chanmode = CHANNEL_G_HT40PLUS;
-		if ((ext_chan_offset == -1) &&
+		if ((ext_chan_offset == NL80211_SEC_CHAN_BELOW) &&
 		    (tx_chan_width == ATH9K_HT_MACMODE_2040))
 			chanmode = CHANNEL_G_HT40MINUS;
 		break;
 	case IEEE80211_BAND_5GHZ:
-		if ((ext_chan_offset == 0) &&
+		if ((ext_chan_offset == NL80211_SEC_CHAN_DISABLED) &&
 		    (tx_chan_width == ATH9K_HT_MACMODE_20))
 			chanmode = CHANNEL_A_HT20;
-		if ((ext_chan_offset == 1) &&
+		if ((ext_chan_offset == NL80211_SEC_CHAN_ABOVE) &&
 		    (tx_chan_width == ATH9K_HT_MACMODE_2040))
 			chanmode = CHANNEL_A_HT40PLUS;
-		if ((ext_chan_offset == -1) &&
+		if ((ext_chan_offset == NL80211_SEC_CHAN_BELOW) &&
 		    (tx_chan_width == ATH9K_HT_MACMODE_2040))
 			chanmode = CHANNEL_A_HT40MINUS;
 		break;
@@ -828,42 +826,11 @@ static void setup_ht_cap(struct ieee80211_sta_ht_cap *ht_info)
 	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 }
 
-static void ath9k_ht_conf(struct ath_softc *sc,
-			  struct ieee80211_bss_conf *bss_conf)
-{
-	if (sc->hw->conf.ht.enabled) {
-		if (bss_conf->ht.width_40_ok)
-			sc->tx_chan_width = ATH9K_HT_MACMODE_2040;
-		else
-			sc->tx_chan_width = ATH9K_HT_MACMODE_20;
-
-		ath9k_hw_set11nmac2040(sc->sc_ah, sc->tx_chan_width);
-
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"BSS Changed HT, chanwidth: %d\n", sc->tx_chan_width);
-	}
-}
-
-static inline int ath_sec_offset(u8 ext_offset)
-{
-	if (ext_offset == IEEE80211_HT_PARAM_CHA_SEC_NONE)
-		return 0;
-	else if (ext_offset == IEEE80211_HT_PARAM_CHA_SEC_ABOVE)
-		return 1;
-	else if (ext_offset == IEEE80211_HT_PARAM_CHA_SEC_BELOW)
-		return -1;
-
-	return 0;
-}
-
 static void ath9k_bss_assoc_info(struct ath_softc *sc,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *bss_conf)
 {
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_channel *curchan = hw->conf.channel;
 	struct ath_vap *avp = (void *)vif->drv_priv;
-	int pos;
 	DECLARE_MAC_BUF(mac);
 
 	if (bss_conf->assoc) {
@@ -886,40 +853,6 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		sc->sc_halstats.ns_avgtxrssi = ATH_RSSI_DUMMY_MARKER;
 		sc->sc_halstats.ns_avgtxrate = ATH_RATE_DUMMY_MARKER;
 
-		/* Update chainmask */
-		ath_update_chainmask(sc, hw->conf.ht.enabled);
-
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"bssid %s aid 0x%x\n",
-			print_mac(mac, sc->sc_curbssid), sc->sc_curaid);
-
-		pos = ath_get_channel(sc, curchan);
-		if (pos == -1) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"Invalid channel: %d\n", curchan->center_freq);
-			return;
-		}
-
-		if (hw->conf.ht.enabled) {
-			int offset =
-				ath_sec_offset(bss_conf->ht.secondary_channel_offset);
-			sc->tx_chan_width = (bss_conf->ht.width_40_ok) ?
-				ATH9K_HT_MACMODE_2040 : ATH9K_HT_MACMODE_20;
-
-			sc->sc_ah->ah_channels[pos].chanmode =
-				ath_get_extchanmode(sc, curchan,
-						    offset, sc->tx_chan_width);
-		} else {
-			sc->sc_ah->ah_channels[pos].chanmode =
-				(curchan->band == IEEE80211_BAND_2GHZ) ?
-				CHANNEL_G : CHANNEL_A;
-		}
-
-		/* set h/w channel */
-		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0)
-			DPRINTF(sc, ATH_DBG_FATAL, "Unable to set channel: %d\n",
-				curchan->center_freq);
-
 		/* Start ANI */
 		mod_timer(&sc->sc_ani.timer,
 			jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
@@ -2146,13 +2079,16 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath_softc *sc = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+	if (changed & (IEEE80211_CONF_CHANGE_CHANNEL |
+		       IEEE80211_CONF_CHANGE_HT)) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos;
 
 		DPRINTF(sc, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
 
+		ath_update_chainmask(sc, conf->ht.enabled);
+
 		pos = ath_get_channel(sc, curchan);
 		if (pos == -1) {
 			DPRINTF(sc, ATH_DBG_FATAL, "Invalid channel: %d\n",
@@ -2160,21 +2096,25 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			return -EINVAL;
 		}
 
-		sc->tx_chan_width = ATH9K_HT_MACMODE_20;
+		switch(conf->ht.sec_chan_offset) {
+		case NL80211_SEC_CHAN_ABOVE:
+		case NL80211_SEC_CHAN_BELOW:
+			sc->tx_chan_width = ATH9K_HT_MACMODE_2040;
+			break;
+		case NL80211_SEC_CHAN_DISABLED:
+			sc->tx_chan_width = ATH9K_HT_MACMODE_20;
+			break;
+		}
+
 		sc->sc_ah->ah_channels[pos].chanmode =
 			(curchan->band == IEEE80211_BAND_2GHZ) ?
 			CHANNEL_G : CHANNEL_A;
 
-		if ((sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) &&
-		    (conf->ht.enabled)) {
-			sc->tx_chan_width = (!!conf->ht.sec_chan_offset) ?
-				ATH9K_HT_MACMODE_2040 : ATH9K_HT_MACMODE_20;
-
+		if(conf->ht.enabled)
 			sc->sc_ah->ah_channels[pos].chanmode =
 				ath_get_extchanmode(sc, curchan,
 						    conf->ht.sec_chan_offset,
 						    sc->tx_chan_width);
-		}
 
 		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0) {
 			DPRINTF(sc, ATH_DBG_FATAL, "Unable to set channel\n");
@@ -2182,9 +2122,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_HT)
-		ath_update_chainmask(sc, conf->ht.enabled);
-
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		sc->sc_config.txpowlimit = 2 * conf->power_level;
 
@@ -2419,9 +2356,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			sc->sc_flags &= ~SC_OP_PROTECT_ENABLE;
 	}
 
-	if (changed & BSS_CHANGED_HT)
-		ath9k_ht_conf(sc, bss_conf);
-
 	if (changed & BSS_CHANGED_ASSOC) {
 		DPRINTF(sc, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
 			bss_conf->assoc);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index fc4e7e4..28668e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -516,19 +516,28 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	iwl_conf->supported_chan_width =
 		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
 
-	iwl_conf->extension_chan_offset = bss_conf->ht.secondary_channel_offset;
-	/* If no above or below channel supplied disable FAT channel */
-	if (iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_ABOVE &&
-	    iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_BELOW) {
+	/*
+	 * XXX: The HT configuration needs to be moved into iwl_mac_config()
+	 *	to be done there correctly.
+	 */
+	switch (priv->hw->conf.ht.sec_chan_offset) {
+	case NL80211_SEC_CHAN_BELOW:
+		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+		break;
+	case NL80211_SEC_CHAN_ABOVE:
+		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+		break;
+	case NL80211_SEC_CHAN_DISABLED:
 		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
-		iwl_conf->supported_chan_width = 0;
+		break;
 	}
 
 	iwl_conf->sm_ps = (u8)((ht_conf->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
 
 	memcpy(&iwl_conf->mcs, &ht_conf->mcs, 16);
 
-	iwl_conf->tx_chan_width = bss_conf->ht.width_40_ok;
+	iwl_conf->tx_chan_width =
+		iwl_conf->extension_chan_offset != NL80211_SEC_CHAN_DISABLED;
 	iwl_conf->ht_protection =
 		bss_conf->ht.operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
 	iwl_conf->non_GF_STA_present =
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index f43da1c..d6d01cd 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -497,11 +497,8 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_HT) {
-		printk(KERN_DEBUG "  %s: HT: sec_ch_offs=%d width_40_ok=%d "
-		       "op_mode=%d\n",
-		       wiphy_name(hw->wiphy),
-		       info->ht.secondary_channel_offset,
-		       info->ht.width_40_ok, info->ht.operation_mode);
+		printk(KERN_DEBUG "  %s: HT: op_mode=%d\n",
+		       wiphy_name(hw->wiphy), info->ht.operation_mode);
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 04d4516..c074e04 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -202,13 +202,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_WIPHY_TXQ_PARAMS: a nested array of TX queue parameters
  * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz
  * @NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET: included with NL80211_ATTR_WIPHY_FREQ
- *	if HT20 or HT40 are allowed (i.e., 802.11n disabled if not included):
- *	NL80211_SEC_CHAN_NO_HT = HT not allowed (i.e., same as not including
- *		this attribute)
  *	NL80211_SEC_CHAN_DISABLED = HT20 only
  *	NL80211_SEC_CHAN_BELOW = secondary channel is below the primary channel
  *	NL80211_SEC_CHAN_ABOVE = secondary channel is above the primary channel
- *
+ * @NL80211_ATTR_WIPHY_HT: included with NL80211_ATTR_WIPHY_FREQ,
+ *	specifies whether HT is enabled for the channel
  * @NL80211_ATTR_IFINDEX: network interface index of the device to operate on
  * @NL80211_ATTR_IFNAME: network interface name
  * @NL80211_ATTR_IFTYPE: type of virtual interface, see &enum nl80211_iftype
@@ -345,6 +343,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_TXQ_PARAMS,
 	NL80211_ATTR_WIPHY_FREQ,
 	NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET,
+	NL80211_ATTR_WIPHY_HT,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -775,7 +774,6 @@ enum nl80211_txq_q {
 };
 
 enum nl80211_sec_chan_offset {
-	NL80211_SEC_CHAN_NO_HT /* No HT */,
 	NL80211_SEC_CHAN_DISABLED /* HT20 only */,
 	NL80211_SEC_CHAN_BELOW /* HT40- */,
 	NL80211_SEC_CHAN_ABOVE /* HT40+ */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a0c0bf1..775819b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -523,6 +523,7 @@ struct cfg80211_ops {
 
 	int	(*set_channel)(struct wiphy *wiphy,
 			       struct ieee80211_channel *chan,
+			       bool enable_ht,
 			       enum nl80211_sec_chan_offset);
 };
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e84c922..23914a5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -165,14 +165,9 @@ enum ieee80211_bss_change {
 
 /**
  * struct ieee80211_bss_ht_conf - BSS's changing HT configuration
- * @secondary_channel_offset: secondary channel offset, uses
- *	%IEEE80211_HT_PARAM_CHA_SEC_ values
- * @width_40_ok: indicates that 40 MHz bandwidth may be used for TX
  * @operation_mode: HT operation mode (like in &struct ieee80211_ht_info)
  */
 struct ieee80211_bss_ht_conf {
-	u8 secondary_channel_offset;
-	bool width_40_ok;
 	u16 operation_mode;
 };
 
@@ -508,9 +503,7 @@ static inline int __deprecated __IEEE80211_CONF_SHORT_SLOT_TIME(void)
 
 struct ieee80211_ht_conf {
 	bool enabled;
-	int sec_chan_offset; /* 0 = HT40 disabled; -1 = HT40 enabled, secondary
-			      * channel below primary; 1 = HT40 enabled,
-			      * secondary channel above primary */
+	enum nl80211_sec_chan_offset sec_chan_offset;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7a7a6c1..0a5b24b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1097,11 +1097,13 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 
 static int ieee80211_set_channel(struct wiphy *wiphy,
 				 struct ieee80211_channel *chan,
+				 bool enable_ht,
 				 enum nl80211_sec_chan_offset sec_chan_offset)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 
 	local->oper_channel = chan;
+	local->oper_ht = enable_ht;
 	local->oper_sec_chan_offset = sec_chan_offset;
 
 	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index ece79ae..76616fe 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -84,63 +84,6 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 		ht_cap->mcs.rx_mask[32/8] |= 1;
 }
 
-/*
- * ieee80211_enable_ht should be called only after the operating band
- * has been determined as ht configuration depends on the hw's
- * HT abilities for a specific band.
- */
-u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
-			struct ieee80211_ht_info *hti,
-			u16 ap_ht_cap_flags)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_bss_ht_conf ht;
-	u32 changed = 0;
-	bool enable_ht = true, ht_changed;
-
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	memset(&ht, 0, sizeof(ht));
-
-	/* HT is not supported */
-	if (!sband->ht_cap.ht_supported)
-		enable_ht = false;
-
-	/* check that channel matches the right operating channel */
-	if (local->hw.conf.channel->center_freq !=
-	    ieee80211_channel_to_frequency(hti->control_chan))
-		enable_ht = false;
-
-	/*
-	 * XXX: This is totally incorrect when there are multiple virtual
-	 *	interfaces, needs to be fixed later.
-	 */
-	ht_changed = local->hw.conf.ht.enabled != enable_ht;
-	local->hw.conf.ht.enabled = enable_ht;
-	if (ht_changed)
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
-
-	/* disable HT */
-	if (!enable_ht)
-		return 0;
-	ht.secondary_channel_offset =
-		hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
-	ht.width_40_ok =
-		!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
-		(sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
-		(hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY);
-	ht.operation_mode = le16_to_cpu(hti->operation_mode);
-
-	/* if bss configuration changed store the new one */
-	if (memcmp(&sdata->vif.bss_conf.ht, &ht, sizeof(ht))) {
-		changed |= BSS_CHANGED_HT;
-		sdata->vif.bss_conf.ht = ht;
-	}
-
-	return changed;
-}
-
 static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 					 const u8 *da, u16 tid,
 					 u8 dialog_token, u16 start_seq_num,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 527205f..e43391a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -626,6 +626,7 @@ struct ieee80211_local {
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
 	struct ieee80211_channel *oper_channel, *scan_channel;
+	bool oper_ht;
 	enum nl80211_sec_chan_offset oper_sec_chan_offset;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
@@ -929,9 +930,6 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap);
-u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
-			struct ieee80211_ht_info *hti,
-			u16 ap_ht_cap_flags);
 void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn);
 
 void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *da,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 29c3ecf..57bad73 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -195,39 +195,27 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 	struct ieee80211_channel *chan;
 	int ret = 0;
 	int power;
+	bool enable_ht;
 	enum nl80211_sec_chan_offset sec_chan_offset;
 
 	might_sleep();
 
 	if (local->sw_scanning) {
 		chan = local->scan_channel;
-		sec_chan_offset = NL80211_SEC_CHAN_NO_HT;
+		enable_ht = false;
+		sec_chan_offset = NL80211_SEC_CHAN_DISABLED;
 	} else {
 		chan = local->oper_channel;
+		enable_ht = local->oper_ht;
 		sec_chan_offset = local->oper_sec_chan_offset;
 	}
 
 	if (chan != local->hw.conf.channel ||
+	    enable_ht != local->hw.conf.ht.enabled ||
 	    sec_chan_offset != local->hw.conf.ht.sec_chan_offset) {
 		local->hw.conf.channel = chan;
-		switch (sec_chan_offset) {
-		case NL80211_SEC_CHAN_NO_HT:
-			local->hw.conf.ht.enabled = false;
-			local->hw.conf.ht.sec_chan_offset = 0;
-			break;
-		case NL80211_SEC_CHAN_DISABLED:
-			local->hw.conf.ht.enabled = true;
-			local->hw.conf.ht.sec_chan_offset = 0;
-			break;
-		case NL80211_SEC_CHAN_BELOW:
-			local->hw.conf.ht.enabled = true;
-			local->hw.conf.ht.sec_chan_offset = -1;
-			break;
-		case NL80211_SEC_CHAN_ABOVE:
-			local->hw.conf.ht.enabled = true;
-			local->hw.conf.ht.sec_chan_offset = 1;
-			break;
-		}
+		local->hw.conf.ht.sec_chan_offset = sec_chan_offset;
+		local->hw.conf.ht.enabled = enable_ht;
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 07b0cc3..43fb2f8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -863,7 +863,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_unlock();
 
-	local->hw.conf.ht.enabled = false;
+	local->oper_ht = false;
+	local->oper_sec_chan_offset = NL80211_SEC_CHAN_DISABLED;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
@@ -1192,6 +1193,71 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_set_disassoc(sdata, ifsta, false, false, reason_code);
 }
 
+/*
+ * ieee80211_enable_ht should be called only after the operating band
+ * has been determined as ht configuration depends on the hw's
+ * HT abilities for a specific band.
+ */
+static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
+			       struct ieee80211_ht_info *hti,
+			       u16 ap_ht_cap_flags)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_bss_ht_conf ht;
+	u32 changed = 0;
+	bool enable_ht = true, ht_changed;
+	s8 secchan = NL80211_SEC_CHAN_DISABLED;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	memset(&ht, 0, sizeof(ht));
+
+	/* HT is not supported */
+	if (!sband->ht_cap.ht_supported)
+		enable_ht = false;
+
+	/* check that channel matches the right operating channel */
+	if (local->hw.conf.channel->center_freq !=
+	    ieee80211_channel_to_frequency(hti->control_chan))
+		enable_ht = false;
+
+	if (enable_ht &&
+	    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
+	    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
+		switch (hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+			secchan = NL80211_SEC_CHAN_ABOVE;
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			secchan = NL80211_SEC_CHAN_BELOW;
+			break;
+		}
+	}
+
+	ht_changed = local->hw.conf.ht.enabled != enable_ht ||
+		     secchan != local->hw.conf.ht.sec_chan_offset;
+
+	local->oper_sec_chan_offset = secchan;
+	local->oper_ht = enable_ht;
+
+	if (ht_changed)
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
+
+	/* disable HT */
+	if (!enable_ht)
+		return 0;
+
+	ht.operation_mode = le16_to_cpu(hti->operation_mode);
+
+	/* if bss configuration changed store the new one */
+	if (memcmp(&sdata->vif.bss_conf.ht, &ht, sizeof(ht))) {
+		changed |= BSS_CHANGED_HT;
+		sdata->vif.bss_conf.ht = ht;
+	}
+
+	return changed;
+}
 
 static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_if_sta *ifsta,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 505d68f..c7beb7a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -641,7 +641,8 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freqMHz)
 		    chan->flags & IEEE80211_CHAN_NO_IBSS)
 			return ret;
 		local->oper_channel = chan;
-		local->oper_sec_chan_offset = NL80211_SEC_CHAN_NO_HT;
+		local->oper_ht = false;
+		local->oper_sec_chan_offset = NL80211_SEC_CHAN_DISABLED;
 
 		if (local->sw_scanning || local->hw_scanning)
 			ret = 0;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9caee60..f17b4aa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -60,6 +60,7 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 				      .len = BUS_ID_SIZE-1 },
 	[NL80211_ATTR_WIPHY_TXQ_PARAMS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_WIPHY_FREQ] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY_HT] = { .type = NLA_U8 },
 	[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET] = { .type = NLA_U32 },
 
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
@@ -363,21 +364,24 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
 		enum nl80211_sec_chan_offset sec_chan_offset =
-			NL80211_SEC_CHAN_NO_HT;
+			NL80211_SEC_CHAN_DISABLED;
 		struct ieee80211_channel *chan;
 		u32 freq, sec_freq;
+		bool enable_ht = false;
 
 		if (!rdev->ops->set_channel) {
 			result = -EOPNOTSUPP;
 			goto bad_res;
 		}
 
-		if (info->attrs[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]) {
+		if (info->attrs[NL80211_ATTR_WIPHY_HT])
+			enable_ht = nla_get_u8(info->attrs[NL80211_ATTR_WIPHY_HT]);
+
+		if (enable_ht && info->attrs[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]) {
 			sec_chan_offset = nla_get_u32(
 				info->attrs[
 					NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]);
-			if (sec_chan_offset != NL80211_SEC_CHAN_NO_HT &&
-			    sec_chan_offset != NL80211_SEC_CHAN_DISABLED &&
+			if (sec_chan_offset != NL80211_SEC_CHAN_DISABLED &&
 			    sec_chan_offset != NL80211_SEC_CHAN_BELOW &&
 			    sec_chan_offset != NL80211_SEC_CHAN_ABOVE) {
 				result = -EINVAL;
@@ -409,7 +413,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			}
 		}
 
-		result = rdev->ops->set_channel(&rdev->wiphy, chan,
+		result = rdev->ops->set_channel(&rdev->wiphy, chan, enable_ht,
 						sec_chan_offset);
 		if (result)
 			goto bad_res;
-- 
1.6.0.3

