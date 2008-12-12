Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34428 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYLLGbA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 01:31:00 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 22:31:00 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18754.1119.861929.459623@gargle.gargle.HOWL> (sfid-20081212_073107_704781_0677A7D9)
Date: Fri, 12 Dec 2008 11:57:43 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>, <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Fix HT channel selection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HT management is done differently for AP and STA modes, unify
to just the ->config() callback since HT is fundamentally a
PHY property and cannot be per-BSS.

Rename enum nl80211_sec_chan_offset as nl80211_channel_type to denote
the channel type ( NO_HT, HT20, HT40+, HT40- ).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c      |  124 ++++++++------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.c |   18 ++++--
 drivers/net/wireless/mac80211_hwsim.c  |    6 +-
 include/linux/nl80211.h                |   22 +++---
 include/net/cfg80211.h                 |    2 +-
 include/net/mac80211.h                 |    9 +--
 net/mac80211/cfg.c                     |    4 +-
 net/mac80211/ht.c                      |   35 ++++++---
 net/mac80211/ieee80211_i.h             |    2 +-
 net/mac80211/main.c                    |   27 +++-----
 net/mac80211/mlme.c                    |    1 +
 net/mac80211/util.c                    |    2 +-
 net/wireless/nl80211.c                 |   27 ++++----
 13 files changed, 110 insertions(+), 169 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 92ac980..c39cfeb 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -623,37 +623,40 @@ static int ath_get_channel(struct ath_softc *sc,
 	return -1;
 }
 
-/* ext_chan_offset: (-1, 0, 1) (below, none, above) */
-
 static u32 ath_get_extchanmode(struct ath_softc *sc,
 			       struct ieee80211_channel *chan,
-			       int ext_chan_offset,
-			       enum ath9k_ht_macmode tx_chan_width)
+			       enum nl80211_channel_type channel_type)
 {
 	u32 chanmode = 0;
 
 	switch (chan->band) {
 	case IEEE80211_BAND_2GHZ:
-		if ((ext_chan_offset == 0) &&
-		    (tx_chan_width == ATH9K_HT_MACMODE_20))
+		switch(channel_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
 			chanmode = CHANNEL_G_HT20;
-		if ((ext_chan_offset == 1) &&
-		    (tx_chan_width == ATH9K_HT_MACMODE_2040))
+			break;
+		case NL80211_CHAN_HT40PLUS:
 			chanmode = CHANNEL_G_HT40PLUS;
-		if ((ext_chan_offset == -1) &&
-		    (tx_chan_width == ATH9K_HT_MACMODE_2040))
+			break;
+		case NL80211_CHAN_HT40MINUS:
 			chanmode = CHANNEL_G_HT40MINUS;
+			break;
+		}
 		break;
 	case IEEE80211_BAND_5GHZ:
-		if ((ext_chan_offset == 0) &&
-		    (tx_chan_width == ATH9K_HT_MACMODE_20))
+		switch(channel_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
 			chanmode = CHANNEL_A_HT20;
-		if ((ext_chan_offset == 1) &&
-		    (tx_chan_width == ATH9K_HT_MACMODE_2040))
+			break;
+		case NL80211_CHAN_HT40PLUS:
 			chanmode = CHANNEL_A_HT40PLUS;
-		if ((ext_chan_offset == -1) &&
-		    (tx_chan_width == ATH9K_HT_MACMODE_2040))
+			break;
+		case NL80211_CHAN_HT40MINUS:
 			chanmode = CHANNEL_A_HT40MINUS;
+			break;
+		}
 		break;
 	default:
 		break;
@@ -829,46 +832,17 @@ static void setup_ht_cap(struct ieee80211_sta_ht_cap *ht_info)
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
-		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info ASSOC %d\n", bss_conf->aid);
+		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info ASSOC %d, bssid: %s\n",
+			bss_conf->aid,
+			print_mac(mac, sc->sc_curbssid));
 
 		/* New association, store aid */
 		if (avp->av_opmode == NL80211_IFTYPE_STATION) {
@@ -887,40 +861,6 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
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
@@ -2147,7 +2087,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath_softc *sc = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+	if (changed & (IEEE80211_CONF_CHANGE_CHANNEL |
+		       IEEE80211_CONF_CHANGE_HT)) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos;
 
@@ -2166,25 +2107,23 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			(curchan->band == IEEE80211_BAND_2GHZ) ?
 			CHANNEL_G : CHANNEL_A;
 
-		if ((sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) &&
-		    (conf->ht.enabled)) {
-			sc->tx_chan_width = (!!conf->ht.sec_chan_offset) ?
-				ATH9K_HT_MACMODE_2040 : ATH9K_HT_MACMODE_20;
+		if (conf->ht.enabled) {
+			if (conf->ht.channel_type == NL80211_CHAN_HT40PLUS ||
+			    conf->ht.channel_type == NL80211_CHAN_HT40MINUS)
+				sc->tx_chan_width = ATH9K_HT_MACMODE_2040;
 
 			sc->sc_ah->ah_channels[pos].chanmode =
 				ath_get_extchanmode(sc, curchan,
-						    conf->ht.sec_chan_offset,
-						    sc->tx_chan_width);
+						    conf->ht.channel_type);
 		}
 
 		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0) {
 			DPRINTF(sc, ATH_DBG_FATAL, "Unable to set channel\n");
 			return -EINVAL;
 		}
-	}
 
-	if (changed & IEEE80211_CONF_CHANGE_HT)
 		ath_update_chainmask(sc, conf->ht.enabled);
+	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		sc->sc_config.txpowlimit = 2 * conf->power_level;
@@ -2420,9 +2359,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			sc->sc_flags &= ~SC_OP_PROTECT_ENABLE;
 	}
 
-	if (changed & BSS_CHANGED_HT)
-		ath9k_ht_conf(sc, bss_conf);
-
 	if (changed & BSS_CHANGED_ASSOC) {
 		DPRINTF(sc, ATH_DBG_CONFIG, "BSS Changed ASSOC %d\n",
 			bss_conf->assoc);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 47aecf7..9d50fad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -516,19 +516,27 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	iwl_conf->supported_chan_width =
 		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
 
-	iwl_conf->extension_chan_offset = bss_conf->ht.secondary_channel_offset;
+	/*
+	 * XXX: The HT configuration needs to be moved into iwl_mac_config()
+	 *	to be done there correctly.
+	 */
+
+	iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+	if (priv->hw->conf.ht.channel_type == NL80211_CHAN_HT40MINUS)
+		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+	else if(priv->hw->conf.ht.channel_type == NL80211_CHAN_HT40PLUS)
+		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+
 	/* If no above or below channel supplied disable FAT channel */
 	if (iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_ABOVE &&
-	    iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_BELOW) {
-		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+	    iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_BELOW)
 		iwl_conf->supported_chan_width = 0;
-	}
 
 	iwl_conf->sm_ps = (u8)((ht_conf->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
 
 	memcpy(&iwl_conf->mcs, &ht_conf->mcs, 16);
 
-	iwl_conf->tx_chan_width = bss_conf->ht.width_40_ok;
+	iwl_conf->tx_chan_width = iwl_conf->supported_chan_width != 0;
 	iwl_conf->ht_protection =
 		bss_conf->ht.operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
 	iwl_conf->non_GF_STA_present =
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index af6cd83..e3ee69e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -497,11 +497,9 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_HT) {
-		printk(KERN_DEBUG "  %s: HT: sec_ch_offs=%d width_40_ok=%d "
-		       "op_mode=%d\n",
+		printk(KERN_DEBUG "  %s: HT: op_mode=0x%x\n",
 		       wiphy_name(hw->wiphy),
-		       info->ht.secondary_channel_offset,
-		       info->ht.width_40_ok, info->ht.operation_mode);
+		       info->ht.operation_mode);
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 04d4516..0fc403a 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -201,13 +201,13 @@ enum nl80211_commands {
  * @NL80211_ATTR_WIPHY_NAME: wiphy name (used for renaming)
  * @NL80211_ATTR_WIPHY_TXQ_PARAMS: a nested array of TX queue parameters
  * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz
- * @NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET: included with NL80211_ATTR_WIPHY_FREQ
+ * @NL80211_ATTR_WIPHY_CHANNEL_TYPE: included with NL80211_ATTR_WIPHY_FREQ
  *	if HT20 or HT40 are allowed (i.e., 802.11n disabled if not included):
- *	NL80211_SEC_CHAN_NO_HT = HT not allowed (i.e., same as not including
+ *	NL80211_CHAN_NO_HT = HT not allowed (i.e., same as not including
  *		this attribute)
- *	NL80211_SEC_CHAN_DISABLED = HT20 only
- *	NL80211_SEC_CHAN_BELOW = secondary channel is below the primary channel
- *	NL80211_SEC_CHAN_ABOVE = secondary channel is above the primary channel
+ *	NL80211_CHAN_HT20 = HT20 only
+ *	NL80211_CHAN_HT40MINUS = secondary channel is below the primary channel
+ *	NL80211_CHAN_HT40PLUS = secondary channel is above the primary channel
  *
  * @NL80211_ATTR_IFINDEX: network interface index of the device to operate on
  * @NL80211_ATTR_IFNAME: network interface name
@@ -344,7 +344,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_WIPHY_TXQ_PARAMS,
 	NL80211_ATTR_WIPHY_FREQ,
-	NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET,
+	NL80211_ATTR_WIPHY_CHANNEL_TYPE,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -774,10 +774,10 @@ enum nl80211_txq_q {
 	NL80211_TXQ_Q_BK
 };
 
-enum nl80211_sec_chan_offset {
-	NL80211_SEC_CHAN_NO_HT /* No HT */,
-	NL80211_SEC_CHAN_DISABLED /* HT20 only */,
-	NL80211_SEC_CHAN_BELOW /* HT40- */,
-	NL80211_SEC_CHAN_ABOVE /* HT40+ */
+enum nl80211_channel_type {
+	NL80211_CHAN_NO_HT,
+	NL80211_CHAN_HT20,
+	NL80211_CHAN_HT40MINUS,
+	NL80211_CHAN_HT40PLUS
 };
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a0c0bf1..666c3c9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -523,7 +523,7 @@ struct cfg80211_ops {
 
 	int	(*set_channel)(struct wiphy *wiphy,
 			       struct ieee80211_channel *chan,
-			       enum nl80211_sec_chan_offset);
+			       enum nl80211_channel_type channel_type);
 };
 
 /* temporary wext handlers */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 046ce69..22ae72c 100644
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
+	enum nl80211_channel_type channel_type;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7912eb1..69b114c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1099,12 +1099,12 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 
 static int ieee80211_set_channel(struct wiphy *wiphy,
 				 struct ieee80211_channel *chan,
-				 enum nl80211_sec_chan_offset sec_chan_offset)
+				 enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 
 	local->oper_channel = chan;
-	local->oper_sec_chan_offset = sec_chan_offset;
+	local->oper_channel_type = channel_type;
 
 	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 }
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index ece79ae..55bfe48 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -98,6 +98,7 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_bss_ht_conf ht;
 	u32 changed = 0;
 	bool enable_ht = true, ht_changed;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
@@ -112,24 +113,36 @@ u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	    ieee80211_channel_to_frequency(hti->control_chan))
 		enable_ht = false;
 
-	/*
-	 * XXX: This is totally incorrect when there are multiple virtual
-	 *	interfaces, needs to be fixed later.
-	 */
-	ht_changed = local->hw.conf.ht.enabled != enable_ht;
+	if (enable_ht) {
+		channel_type = NL80211_CHAN_HT20;
+
+		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
+		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
+			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+				channel_type = NL80211_CHAN_HT40PLUS;
+				break;
+			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+				channel_type = NL80211_CHAN_HT40MINUS;
+				break;
+			}
+		}
+	}
+
+	ht_changed = local->hw.conf.ht.enabled != enable_ht ||
+		     channel_type != local->hw.conf.ht.channel_type;
+
+	local->oper_channel_type = channel_type;
 	local->hw.conf.ht.enabled = enable_ht;
+
 	if (ht_changed)
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
 
 	/* disable HT */
 	if (!enable_ht)
 		return 0;
-	ht.secondary_channel_offset =
-		hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
-	ht.width_40_ok =
-		!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
-		(sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
-		(hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY);
+
 	ht.operation_mode = le16_to_cpu(hti->operation_mode);
 
 	/* if bss configuration changed store the new one */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6f59e11..a7dabae 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -625,7 +625,7 @@ struct ieee80211_local {
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
 	struct ieee80211_channel *oper_channel, *scan_channel;
-	enum nl80211_sec_chan_offset oper_sec_chan_offset;
+	enum nl80211_channel_type oper_channel_type;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
 	struct list_head bss_list;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6d87103..a0371ca 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -195,37 +195,30 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 	struct ieee80211_channel *chan;
 	int ret = 0;
 	int power;
-	enum nl80211_sec_chan_offset sec_chan_offset;
+	enum nl80211_channel_type channel_type;
 
 	might_sleep();
 
 	if (local->sw_scanning) {
 		chan = local->scan_channel;
-		sec_chan_offset = NL80211_SEC_CHAN_NO_HT;
+		channel_type = NL80211_CHAN_NO_HT;
 	} else {
 		chan = local->oper_channel;
-		sec_chan_offset = local->oper_sec_chan_offset;
+		channel_type = local->oper_channel_type;
 	}
 
 	if (chan != local->hw.conf.channel ||
-	    sec_chan_offset != local->hw.conf.ht.sec_chan_offset) {
+	    channel_type != local->hw.conf.ht.channel_type) {
 		local->hw.conf.channel = chan;
-		switch (sec_chan_offset) {
-		case NL80211_SEC_CHAN_NO_HT:
+		local->hw.conf.ht.channel_type = channel_type;
+		switch (channel_type) {
+		case NL80211_CHAN_NO_HT:
 			local->hw.conf.ht.enabled = false;
-			local->hw.conf.ht.sec_chan_offset = 0;
 			break;
-		case NL80211_SEC_CHAN_DISABLED:
+		case NL80211_CHAN_HT20:
+		case NL80211_CHAN_HT40MINUS:
+		case NL80211_CHAN_HT40PLUS:
 			local->hw.conf.ht.enabled = true;
-			local->hw.conf.ht.sec_chan_offset = 0;
-			break;
-		case NL80211_SEC_CHAN_BELOW:
-			local->hw.conf.ht.enabled = true;
-			local->hw.conf.ht.sec_chan_offset = -1;
-			break;
-		case NL80211_SEC_CHAN_ABOVE:
-			local->hw.conf.ht.enabled = true;
-			local->hw.conf.ht.sec_chan_offset = 1;
 			break;
 		}
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 98e03e3..9116be0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -864,6 +864,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 
 	local->hw.conf.ht.enabled = false;
+	local->oper_channel_type = NL80211_CHAN_NO_HT;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 505d68f..71a8391 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -641,7 +641,7 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freqMHz)
 		    chan->flags & IEEE80211_CHAN_NO_IBSS)
 			return ret;
 		local->oper_channel = chan;
-		local->oper_sec_chan_offset = NL80211_SEC_CHAN_NO_HT;
+		local->oper_channel_type = NL80211_CHAN_NO_HT;
 
 		if (local->sw_scanning || local->hw_scanning)
 			ret = 0;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4335f76..4c8bfc4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -60,7 +60,7 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 				      .len = BUS_ID_SIZE-1 },
 	[NL80211_ATTR_WIPHY_TXQ_PARAMS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_WIPHY_FREQ] = { .type = NLA_U32 },
-	[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY_CHANNEL_TYPE] = { .type = NLA_U32 },
 
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
@@ -362,8 +362,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		enum nl80211_sec_chan_offset sec_chan_offset =
-			NL80211_SEC_CHAN_NO_HT;
+		enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 		struct ieee80211_channel *chan;
 		struct ieee80211_sta_ht_cap *ht_cap;
 		u32 freq, sec_freq;
@@ -375,13 +374,13 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 
 		result = -EINVAL;
 
-		if (info->attrs[NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]) {
-			sec_chan_offset = nla_get_u32(info->attrs[
-					NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET]);
-			if (sec_chan_offset != NL80211_SEC_CHAN_NO_HT &&
-			    sec_chan_offset != NL80211_SEC_CHAN_DISABLED &&
-			    sec_chan_offset != NL80211_SEC_CHAN_BELOW &&
-			    sec_chan_offset != NL80211_SEC_CHAN_ABOVE)
+		if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+			channel_type = nla_get_u32(info->attrs[
+					   NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+			if (channel_type != NL80211_CHAN_NO_HT &&
+			    channel_type != NL80211_CHAN_HT20 &&
+			    channel_type != NL80211_CHAN_HT40PLUS &&
+			    channel_type != NL80211_CHAN_HT40MINUS)
 				goto bad_res;
 		}
 
@@ -392,9 +391,9 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED)
 			goto bad_res;
 
-		if (sec_chan_offset == NL80211_SEC_CHAN_BELOW)
+		if (channel_type == NL80211_CHAN_HT40MINUS)
 			sec_freq = freq - 20;
-		else if (sec_chan_offset == NL80211_SEC_CHAN_ABOVE)
+		else if (channel_type == NL80211_CHAN_HT40PLUS)
 			sec_freq = freq + 20;
 		else
 			sec_freq = 0;
@@ -402,7 +401,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
 
 		/* no HT capabilities */
-		if (sec_chan_offset != NL80211_SEC_CHAN_NO_HT &&
+		if (channel_type != NL80211_CHAN_NO_HT &&
 		    !ht_cap->ht_supported)
 			goto bad_res;
 
@@ -422,7 +421,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		result = rdev->ops->set_channel(&rdev->wiphy, chan,
-						sec_chan_offset);
+						channel_type);
 		if (result)
 			goto bad_res;
 	}
-- 
1.6.0.3

