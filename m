Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35246 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbYLGQaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 11:30:55 -0500
Subject: [RFT] mac80211: fix HT channel selection
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Mats Johannesson <spamcan1@abrasax.se>,
	Tomas Winkler <tomasw@gmail.com>
Content-Type: text/plain
Date: Sun, 07 Dec 2008 17:30:46 +0100
Message-Id: <1228667447.22164.46.camel@johannes.berg> (sfid-20081207_173058_913529_9E8EDF1E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HT management is done differently for AP and STA modes, unify
to just the ->config() callback since HT is fundamentally a
PHY property and cannot be per-BSS.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Please test. Mats, this might fix your problem (if it applies on top of
the patch that fixes the panic)

 drivers/net/wireless/ath9k/main.c      |   71 ---------------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.c |   21 ++++++---
 drivers/net/wireless/mac80211_hwsim.c  |    7 ---
 include/net/mac80211.h                 |    5 --
 net/mac80211/ht.c                      |   57 --------------------------
 net/mac80211/ieee80211_i.h             |    3 -
 net/mac80211/mlme.c                    |   67 +++++++++++++++++++++++++++++++
 7 files changed, 85 insertions(+), 146 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-12-07 16:59:20.000000000 +0100
+++ everything/include/net/mac80211.h	2008-12-07 16:59:25.000000000 +0100
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
 
--- everything.orig/net/mac80211/ht.c	2008-12-07 16:59:44.000000000 +0100
+++ everything/net/mac80211/ht.c	2008-12-07 17:07:24.000000000 +0100
@@ -84,63 +84,6 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(s
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
--- everything.orig/net/mac80211/mlme.c	2008-12-07 17:04:34.000000000 +0100
+++ everything/net/mac80211/mlme.c	2008-12-07 17:07:15.000000000 +0100
@@ -864,6 +864,7 @@ static void ieee80211_set_disassoc(struc
 	rcu_read_unlock();
 
 	local->hw.conf.ht.enabled = false;
+	local->hw.conf.ht.sec_chan_offset = 0;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
@@ -1192,6 +1193,72 @@ static void ieee80211_rx_mgmt_disassoc(s
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
+	s8 secchan = 0;
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
+	    !(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+	    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
+	    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
+		switch (hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+			secchan = 1;
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			secchan = -1;
+			break;
+		}
+	}
+
+	ht_changed = local->hw.conf.ht.enabled != enable_ht ||
+		     secchan != local->hw.conf.ht.sec_chan_offset;
+
+	local->hw.conf.ht.sec_chan_offset = secchan;
+	local->hw.conf.ht.enabled = enable_ht;
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
--- everything.orig/net/mac80211/ieee80211_i.h	2008-12-07 17:06:16.000000000 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-12-07 17:06:19.000000000 +0100
@@ -930,9 +930,6 @@ int ieee80211_subif_start_xmit(struct sk
 void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap);
-u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
-			struct ieee80211_ht_info *hti,
-			u16 ap_ht_cap_flags);
 void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn);
 
 void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *da,
--- everything.orig/drivers/net/wireless/mac80211_hwsim.c	2008-12-07 17:10:34.000000000 +0100
+++ everything/drivers/net/wireless/mac80211_hwsim.c	2008-12-07 17:10:48.000000000 +0100
@@ -497,11 +497,8 @@ static void mac80211_hwsim_bss_info_chan
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
--- everything.orig/drivers/net/wireless/ath9k/main.c	2008-12-07 17:12:02.000000000 +0100
+++ everything/drivers/net/wireless/ath9k/main.c	2008-12-07 17:19:14.000000000 +0100
@@ -825,42 +825,11 @@ static void setup_ht_cap(struct ieee8021
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
@@ -883,40 +852,6 @@ static void ath9k_bss_assoc_info(struct 
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
@@ -2151,7 +2086,8 @@ static int ath9k_config(struct ieee80211
 	struct ath_softc *sc = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+	if (changed & (IEEE80211_CONF_CHANGE_CHANNEL |
+		       IEEE80211_CONF_CHANGE_HT)) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos;
 
@@ -2424,9 +2360,6 @@ static void ath9k_bss_info_changed(struc
 			sc->sc_flags &= ~SC_OP_PROTECT_ENABLE;
 	}
 
-	if (changed & BSS_CHANGED_HT)
-		ath9k_ht_conf(sc, bss_conf);
-
 	if (changed & BSS_CHANGED_ASSOC) {
 		DPRINTF(sc, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
 			bss_conf->assoc);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-12-07 17:20:25.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-12-07 17:25:57.000000000 +0100
@@ -516,19 +516,26 @@ static void iwl_ht_conf(struct iwl_priv 
 	iwl_conf->supported_chan_width =
 		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
 
-	iwl_conf->extension_chan_offset = bss_conf->ht.secondary_channel_offset;
-	/* If no above or below channel supplied disable FAT channel */
-	if (iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_ABOVE &&
-	    iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_BELOW) {
-		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
-		iwl_conf->supported_chan_width = 0;
+	/*
+	 * XXX: The HT configuration needs to be moved into iwl_mac_config()
+	 *	to be done there correctly.
+	 */
+
+	iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+	switch (priv->hw->conf.ht.sec_chan_offset) {
+	case -1:
+		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+		break;
+	case 1:
+		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+		break;
 	}
 
 	iwl_conf->sm_ps = (u8)((ht_conf->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
 
 	memcpy(&iwl_conf->mcs, &ht_conf->mcs, 16);
 
-	iwl_conf->tx_chan_width = bss_conf->ht.width_40_ok;
+	iwl_conf->tx_chan_width = iwl_conf->extension_chan_offset != 0;
 	iwl_conf->ht_protection =
 		bss_conf->ht.operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
 	iwl_conf->non_GF_STA_present =


