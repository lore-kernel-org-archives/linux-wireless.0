Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45596 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbYCNRsp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2008 13:48:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5/5] iwlwifi: Probe Flow - Extracting hw and priv init
Date: Fri, 14 Mar 2008 10:38:49 -0700
Message-Id: <1205516329-22172-6-git-send-email-reinette.chatre@intel.com> (sfid-20080314_175001_560935_4DE32AC1)
In-Reply-To: <1205516329-22172-5-git-send-email-reinette.chatre@intel.com>
References: <1205516329-22172-1-git-send-email-reinette.chatre@intel.com>
 <1205516329-22172-2-git-send-email-reinette.chatre@intel.com>
 <1205516329-22172-3-git-send-email-reinette.chatre@intel.com>
 <1205516329-22172-4-git-send-email-reinette.chatre@intel.com>
 <1205516329-22172-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

1. Extracting hw and priv initialization from probe function.
2. Moving some initialization functions to core module.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  144 +++++---
 drivers/net/wireless/iwlwifi/iwl-4965.h     |   27 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |  178 ++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |   10 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |  356 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    8 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  577 +-------------------------
 7 files changed, 677 insertions(+), 623 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f015780..03c032e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -105,6 +105,90 @@ static const u16 default_tid_to_tx_fifo[] = {
 
 #endif	/*CONFIG_IWL4965_HT */
 
+static int iwl4965_init_drv(struct iwl_priv *priv)
+{
+	int ret;
+	int i;
+
+	priv->antenna = (enum iwl4965_antenna)iwl4965_mod_params.antenna;
+	priv->retry_rate = 1;
+	priv->ibss_beacon = NULL;
+
+	spin_lock_init(&priv->lock);
+	spin_lock_init(&priv->power_data.lock);
+	spin_lock_init(&priv->sta_lock);
+	spin_lock_init(&priv->hcmd_lock);
+	spin_lock_init(&priv->lq_mngr.lock);
+
+	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++)
+		INIT_LIST_HEAD(&priv->ibss_mac_hash[i]);
+
+	INIT_LIST_HEAD(&priv->free_frames);
+
+	mutex_init(&priv->mutex);
+
+	/* Clear the driver's (not device's) station table */
+	iwlcore_clear_stations_table(priv);
+
+	priv->data_retry_limit = -1;
+	priv->ieee_channels = NULL;
+	priv->ieee_rates = NULL;
+	priv->band = IEEE80211_BAND_2GHZ;
+
+	priv->iw_mode = IEEE80211_IF_TYPE_STA;
+
+	priv->use_ant_b_for_management_frame = 1; /* start with ant B */
+	priv->valid_antenna = 0x7;	/* assume all 3 connected */
+	priv->ps_mode = IWL_MIMO_PS_NONE;
+
+	/* Choose which receivers/antennas to use */
+	iwl4965_set_rxon_chain(priv);
+
+	iwlcore_reset_qos(priv);
+
+	priv->qos_data.qos_active = 0;
+	priv->qos_data.qos_cap.val = 0;
+
+	iwlcore_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
+
+	priv->rates_mask = IWL_RATES_MASK;
+	/* If power management is turned on, default to AC mode */
+	priv->power_mode = IWL_POWER_AC;
+	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
+
+	ret = iwl_init_channel_map(priv);
+	if (ret) {
+		IWL_ERROR("initializing regulatory failed: %d\n", ret);
+		goto err;
+	}
+
+	ret = iwl4965_init_geos(priv);
+	if (ret) {
+		IWL_ERROR("initializing geos failed: %d\n", ret);
+		goto err_free_channel_map;
+	}
+
+	iwl4965_rate_control_register(priv->hw);
+	ret = ieee80211_register_hw(priv->hw);
+	if (ret) {
+		IWL_ERROR("Failed to register network device (error %d)\n",
+				ret);
+		goto err_free_geos;
+	}
+
+	priv->hw->conf.beacon_int = 100;
+	priv->mac80211_registered = 1;
+
+	return 0;
+
+err_free_geos:
+	iwl4965_free_geos(priv);
+err_free_channel_map:
+	iwl_free_channel_map(priv);
+err:
+	return ret;
+}
+
 static int is_fat_channel(__le32 rxon_flags)
 {
 	return (rxon_flags & RXON_FLG_CHANNEL_MODE_PURE_40_MSK) ||
@@ -391,55 +475,6 @@ static int iwl4965_kw_alloc(struct iwl_priv *priv)
 	return 0;
 }
 
-#define CHECK_AND_PRINT(x) ((eeprom_ch->flags & EEPROM_CHANNEL_##x) \
-			    ? # x " " : "")
-
-/**
- * iwl4965_set_fat_chan_info - Copy fat channel info into driver's priv.
- *
- * Does not set up a command, or touch hardware.
- */
-int iwl4965_set_fat_chan_info(struct iwl_priv *priv,
-			      enum ieee80211_band band, u16 channel,
-			      const struct iwl4965_eeprom_channel *eeprom_ch,
-			      u8 fat_extension_channel)
-{
-	struct iwl4965_channel_info *ch_info;
-
-	ch_info = (struct iwl4965_channel_info *)
-			iwl4965_get_channel_info(priv, band, channel);
-
-	if (!is_channel_valid(ch_info))
-		return -1;
-
-	IWL_DEBUG_INFO("FAT Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x"
-			" %ddBm): Ad-Hoc %ssupported\n",
-			ch_info->channel,
-			is_channel_a_band(ch_info) ?
-			"5.2" : "2.4",
-			CHECK_AND_PRINT(IBSS),
-			CHECK_AND_PRINT(ACTIVE),
-			CHECK_AND_PRINT(RADAR),
-			CHECK_AND_PRINT(WIDE),
-			CHECK_AND_PRINT(NARROW),
-			CHECK_AND_PRINT(DFS),
-			eeprom_ch->flags,
-			eeprom_ch->max_power_avg,
-			((eeprom_ch->flags & EEPROM_CHANNEL_IBSS)
-			 && !(eeprom_ch->flags & EEPROM_CHANNEL_RADAR)) ?
-			"" : "not ");
-
-	ch_info->fat_eeprom = *eeprom_ch;
-	ch_info->fat_max_power_avg = eeprom_ch->max_power_avg;
-	ch_info->fat_curr_txpow = eeprom_ch->max_power_avg;
-	ch_info->fat_min_power = 0;
-	ch_info->fat_scan_power = eeprom_ch->max_power_avg;
-	ch_info->fat_flags = eeprom_ch->flags;
-	ch_info->fat_extension_channel = fat_extension_channel;
-
-	return 0;
-}
-
 /**
  * iwl4965_kw_free - Free the "keep warm" buffer
  */
@@ -2015,11 +2050,11 @@ static s32 iwl4965_get_voltage_compensation(s32 eeprom_voltage,
 	return comp;
 }
 
-static const struct iwl4965_channel_info *
+static const struct iwl_channel_info *
 iwl4965_get_channel_txpower_info(struct iwl_priv *priv,
 				 enum ieee80211_band band, u16 channel)
 {
-	const struct iwl4965_channel_info *ch_info;
+	const struct iwl_channel_info *ch_info;
 
 	ch_info = iwl4965_get_channel_info(priv, band, channel);
 
@@ -2438,7 +2473,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	s32 txatten_grp = CALIB_CH_GROUP_MAX;
 	int i;
 	int c;
-	const struct iwl4965_channel_info *ch_info = NULL;
+	const struct iwl_channel_info *ch_info = NULL;
 	struct iwl4965_eeprom_calib_ch_info ch_eeprom_info;
 	const struct iwl4965_eeprom_calib_measure *measurement;
 	s16 voltage;
@@ -2725,7 +2760,7 @@ int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 	u8 is_fat = 0;
 	u8 ctrl_chan_high = 0;
 	struct iwl4965_channel_switch_cmd cmd = { 0 };
-	const struct iwl4965_channel_info *ch_info;
+	const struct iwl_channel_info *ch_info;
 
 	band = priv->band == IEEE80211_BAND_2GHZ;
 
@@ -4537,7 +4572,7 @@ static u8 iwl4965_is_channel_extension(struct iwl_priv *priv,
 				       enum ieee80211_band band,
 				       u16 channel, u8 extension_chan_offset)
 {
-	const struct iwl4965_channel_info *ch_info;
+	const struct iwl_channel_info *ch_info;
 
 	ch_info = iwl4965_get_channel_info(priv, band, channel);
 	if (!is_channel_valid(ch_info))
@@ -4914,6 +4949,7 @@ void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv)
 }
 
 static struct iwl_lib_ops iwl4965_lib = {
+	.init_drv = iwl4965_init_drv,
 	.eeprom_ops = {
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 1480e1b..7baed4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -197,7 +197,7 @@ enum {
  */
 #define IWL4965_MAX_RATE (33)
 
-struct iwl4965_channel_info {
+struct iwl_channel_info {
 	struct iwl4965_channel_tgd_info tgd;
 	struct iwl4965_channel_tgh_info tgh;
 	struct iwl4965_eeprom_channel eeprom;	  /* EEPROM regulatory limit */
@@ -669,6 +669,8 @@ extern void iwl4965_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *sk
 				   u32 decrypt_res,
 				   struct ieee80211_rx_status *stats);
 extern __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr);
+int iwl4965_init_geos(struct iwl_priv *priv);
+void iwl4965_free_geos(struct iwl_priv *priv);
 
 extern const u8 iwl4965_broadcast_addr[ETH_ALEN];
 
@@ -755,11 +757,6 @@ extern void iwl4965_update_rate_scaling(struct iwl_priv *priv, u8 mode);
 extern void iwl4965_chain_noise_reset(struct iwl_priv *priv);
 extern void iwl4965_init_sensitivity(struct iwl_priv *priv, u8 flags,
 				     u8 force);
-extern int iwl4965_set_fat_chan_info(struct iwl_priv *priv,
-				enum ieee80211_band band,
-				u16 channel,
-				const struct iwl4965_eeprom_channel *eeprom_ch,
-				u8 fat_extension_channel);
 extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
 extern void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv,
 					 u32 rate_n_flags,
@@ -995,7 +992,7 @@ struct iwl_priv {
 
 	/* we allocate array of iwl4965_channel_info for NIC's valid channels.
 	 *    Access via channel # using indirect index array */
-	struct iwl4965_channel_info *channel_info;	/* channel info array */
+	struct iwl_channel_info *channel_info;	/* channel info array */
 	u8 channel_count;	/* # of channels */
 
 	/* each calibration channel group in the EEPROM has a derived
@@ -1229,44 +1226,44 @@ static inline int iwl4965_is_associated(struct iwl_priv *priv)
 	return (priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
 }
 
-static inline int is_channel_valid(const struct iwl4965_channel_info *ch_info)
+static inline int is_channel_valid(const struct iwl_channel_info *ch_info)
 {
 	if (ch_info == NULL)
 		return 0;
 	return (ch_info->flags & EEPROM_CHANNEL_VALID) ? 1 : 0;
 }
 
-static inline int is_channel_narrow(const struct iwl4965_channel_info *ch_info)
+static inline int is_channel_narrow(const struct iwl_channel_info *ch_info)
 {
 	return (ch_info->flags & EEPROM_CHANNEL_NARROW) ? 1 : 0;
 }
 
-static inline int is_channel_radar(const struct iwl4965_channel_info *ch_info)
+static inline int is_channel_radar(const struct iwl_channel_info *ch_info)
 {
 	return (ch_info->flags & EEPROM_CHANNEL_RADAR) ? 1 : 0;
 }
 
-static inline u8 is_channel_a_band(const struct iwl4965_channel_info *ch_info)
+static inline u8 is_channel_a_band(const struct iwl_channel_info *ch_info)
 {
 	return ch_info->band == IEEE80211_BAND_5GHZ;
 }
 
-static inline u8 is_channel_bg_band(const struct iwl4965_channel_info *ch_info)
+static inline u8 is_channel_bg_band(const struct iwl_channel_info *ch_info)
 {
 	return ch_info->band == IEEE80211_BAND_2GHZ;
 }
 
-static inline int is_channel_passive(const struct iwl4965_channel_info *ch)
+static inline int is_channel_passive(const struct iwl_channel_info *ch)
 {
 	return (!(ch->flags & EEPROM_CHANNEL_ACTIVE)) ? 1 : 0;
 }
 
-static inline int is_channel_ibss(const struct iwl4965_channel_info *ch)
+static inline int is_channel_ibss(const struct iwl_channel_info *ch)
 {
 	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
 }
 
-extern const struct iwl4965_channel_info *iwl4965_get_channel_info(
+extern const struct iwl_channel_info *iwl4965_get_channel_info(
 	const struct iwl_priv *priv, enum ieee80211_band band, u16 channel);
 
 /* Requires full declaration of iwl_priv before including */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 244318a..0e9c3b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -71,3 +71,181 @@ out:
 }
 EXPORT_SYMBOL(iwl_alloc_all);
 
+/**
+ * iwlcore_clear_stations_table - Clear the driver's station table
+ *
+ * NOTE:  This does not clear or otherwise alter the device's station table.
+ */
+void iwlcore_clear_stations_table(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	priv->num_stations = 0;
+	memset(priv->stations, 0, sizeof(priv->stations));
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+}
+EXPORT_SYMBOL(iwlcore_clear_stations_table);
+
+void iwlcore_reset_qos(struct iwl_priv *priv)
+{
+	u16 cw_min = 15;
+	u16 cw_max = 1023;
+	u8 aifs = 2;
+	u8 is_legacy = 0;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->qos_data.qos_active = 0;
+
+	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS) {
+		if (priv->qos_data.qos_enable)
+			priv->qos_data.qos_active = 1;
+		if (!(priv->active_rate & 0xfff0)) {
+			cw_min = 31;
+			is_legacy = 1;
+		}
+	} else if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
+		if (priv->qos_data.qos_enable)
+			priv->qos_data.qos_active = 1;
+	} else if (!(priv->staging_rxon.flags & RXON_FLG_SHORT_SLOT_MSK)) {
+		cw_min = 31;
+		is_legacy = 1;
+	}
+
+	if (priv->qos_data.qos_active)
+		aifs = 3;
+
+	priv->qos_data.def_qos_parm.ac[0].cw_min = cpu_to_le16(cw_min);
+	priv->qos_data.def_qos_parm.ac[0].cw_max = cpu_to_le16(cw_max);
+	priv->qos_data.def_qos_parm.ac[0].aifsn = aifs;
+	priv->qos_data.def_qos_parm.ac[0].edca_txop = 0;
+	priv->qos_data.def_qos_parm.ac[0].reserved1 = 0;
+
+	if (priv->qos_data.qos_active) {
+		i = 1;
+		priv->qos_data.def_qos_parm.ac[i].cw_min = cpu_to_le16(cw_min);
+		priv->qos_data.def_qos_parm.ac[i].cw_max = cpu_to_le16(cw_max);
+		priv->qos_data.def_qos_parm.ac[i].aifsn = 7;
+		priv->qos_data.def_qos_parm.ac[i].edca_txop = 0;
+		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
+
+		i = 2;
+		priv->qos_data.def_qos_parm.ac[i].cw_min =
+			cpu_to_le16((cw_min + 1) / 2 - 1);
+		priv->qos_data.def_qos_parm.ac[i].cw_max =
+			cpu_to_le16(cw_max);
+		priv->qos_data.def_qos_parm.ac[i].aifsn = 2;
+		if (is_legacy)
+			priv->qos_data.def_qos_parm.ac[i].edca_txop =
+				cpu_to_le16(6016);
+		else
+			priv->qos_data.def_qos_parm.ac[i].edca_txop =
+				cpu_to_le16(3008);
+		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
+
+		i = 3;
+		priv->qos_data.def_qos_parm.ac[i].cw_min =
+			cpu_to_le16((cw_min + 1) / 4 - 1);
+		priv->qos_data.def_qos_parm.ac[i].cw_max =
+			cpu_to_le16((cw_max + 1) / 2 - 1);
+		priv->qos_data.def_qos_parm.ac[i].aifsn = 2;
+		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
+		if (is_legacy)
+			priv->qos_data.def_qos_parm.ac[i].edca_txop =
+				cpu_to_le16(3264);
+		else
+			priv->qos_data.def_qos_parm.ac[i].edca_txop =
+				cpu_to_le16(1504);
+	} else {
+		for (i = 1; i < 4; i++) {
+			priv->qos_data.def_qos_parm.ac[i].cw_min =
+				cpu_to_le16(cw_min);
+			priv->qos_data.def_qos_parm.ac[i].cw_max =
+				cpu_to_le16(cw_max);
+			priv->qos_data.def_qos_parm.ac[i].aifsn = aifs;
+			priv->qos_data.def_qos_parm.ac[i].edca_txop = 0;
+			priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
+		}
+	}
+	IWL_DEBUG_QOS("set QoS to default \n");
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+EXPORT_SYMBOL(iwlcore_reset_qos);
+
+/**
+ * iwlcore_set_rxon_channel - Set the phymode and channel values in staging RXON
+ * @phymode: MODE_IEEE80211A sets to 5.2GHz; all else set to 2.4GHz
+ * @channel: Any channel valid for the requested phymode
+
+ * In addition to setting the staging RXON, priv->phymode is also set.
+ *
+ * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
+ * in the staging RXON flag structure based on the phymode
+ */
+int iwlcore_set_rxon_channel(struct iwl_priv *priv,
+				enum ieee80211_band band,
+				u16 channel)
+{
+	if (!iwl4965_get_channel_info(priv, band, channel)) {
+		IWL_DEBUG_INFO("Could not set channel to %d [%d]\n",
+			       channel, band);
+		return -EINVAL;
+	}
+
+	if ((le16_to_cpu(priv->staging_rxon.channel) == channel) &&
+	    (priv->band == band))
+		return 0;
+
+	priv->staging_rxon.channel = cpu_to_le16(channel);
+	if (band == IEEE80211_BAND_5GHZ)
+		priv->staging_rxon.flags &= ~RXON_FLG_BAND_24G_MSK;
+	else
+		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
+
+	priv->band = band;
+
+	IWL_DEBUG_INFO("Staging channel set to %d [%d]\n", channel, band);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwlcore_set_rxon_channel);
+
+static void iwlcore_init_hw(struct iwl_priv *priv)
+{
+	struct ieee80211_hw *hw = priv->hw;
+	hw->rate_control_algorithm = "iwl-4965-rs";
+
+	/* Tell mac80211 and its clients (e.g. Wireless Extensions)
+	 *	 the range of signal quality values that we'll provide.
+	 * Negative values for level/noise indicate that we'll provide dBm.
+	 * For WE, at least, non-0 values here *enable* display of values
+	 *	 in app (iwconfig). */
+	hw->max_rssi = -20; /* signal level, negative indicates dBm */
+	hw->max_noise = -20;	/* noise level, negative indicates dBm */
+	hw->max_signal = 100;	/* link quality indication (%) */
+
+	/* Tell mac80211 our Tx characteristics */
+	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
+
+	/* Default value; 4 EDCA QOS priorities */
+	hw->queues = 4;
+#ifdef CONFIG_IWL4965_HT
+	/* Enhanced value; more queues, to support 11n aggregation */
+	hw->queues = 16;
+#endif /* CONFIG_IWL4965_HT */
+}
+
+int iwl_setup(struct iwl_priv *priv)
+{
+	int ret = 0;
+	iwlcore_init_hw(priv);
+	ret = priv->cfg->ops->lib->init_drv(priv);
+	return ret;
+}
+EXPORT_SYMBOL(iwl_setup);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 33bef1f..4dde4d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -76,6 +76,8 @@
 #define IWL_SKU_N       0x8
 
 struct iwl_lib_ops {
+	/* iwlwifi driver (priv) init */
+	int (*init_drv)(struct iwl_priv *priv);
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
 };
@@ -110,4 +112,12 @@ struct iwl_cfg {
 struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 		struct ieee80211_ops *hw_ops);
 
+void iwlcore_clear_stations_table(struct iwl_priv *priv);
+void iwlcore_reset_qos(struct iwl_priv *priv);
+int iwlcore_set_rxon_channel(struct iwl_priv *priv,
+				enum ieee80211_band band,
+				u16 channel);
+
+int iwl_setup(struct iwl_priv *priv);
+
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index ccacd48..32ebec3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -75,6 +75,67 @@
 #include "iwl-eeprom.h"
 #include "iwl-4965-io.h"
 
+/************************** EEPROM BANDS ****************************
+ *
+ * The iwl_eeprom_band definitions below provide the mapping from the
+ * EEPROM contents to the specific channel number supported for each
+ * band.
+ *
+ * For example, iwl_priv->eeprom.band_3_channels[4] from the band_3
+ * definition below maps to physical channel 42 in the 5.2GHz spectrum.
+ * The specific geography and calibration information for that channel
+ * is contained in the eeprom map itself.
+ *
+ * During init, we copy the eeprom information and channel map
+ * information into priv->channel_info_24/52 and priv->channel_map_24/52
+ *
+ * channel_map_24/52 provides the index in the channel_info array for a
+ * given channel.  We have to have two separate maps as there is channel
+ * overlap with the 2.4GHz and 5.2GHz spectrum as seen in band_1 and
+ * band_2
+ *
+ * A value of 0xff stored in the channel_map indicates that the channel
+ * is not supported by the hardware at all.
+ *
+ * A value of 0xfe in the channel_map indicates that the channel is not
+ * valid for Tx with the current hardware.  This means that
+ * while the system can tune and receive on a given channel, it may not
+ * be able to associate or transmit any frames on that
+ * channel.  There is no corresponding channel information for that
+ * entry.
+ *
+ *********************************************************************/
+
+/* 2.4 GHz */
+const u8 iwl_eeprom_band_1[14] = {
+	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
+};
+
+/* 5.2 GHz bands */
+static const u8 iwl_eeprom_band_2[] = {	/* 4915-5080MHz */
+	183, 184, 185, 187, 188, 189, 192, 196, 7, 8, 11, 12, 16
+};
+
+static const u8 iwl_eeprom_band_3[] = {	/* 5170-5320MHz */
+	34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
+};
+
+static const u8 iwl_eeprom_band_4[] = {	/* 5500-5700MHz */
+	100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
+};
+
+static const u8 iwl_eeprom_band_5[] = {	/* 5725-5825MHz */
+	145, 149, 153, 157, 161, 165
+};
+
+static const u8 iwl_eeprom_band_6[] = {       /* 2.4 FAT channel */
+	1, 2, 3, 4, 5, 6, 7
+};
+
+static const u8 iwl_eeprom_band_7[] = {       /* 5.2 FAT channel */
+	36, 44, 52, 60, 100, 108, 116, 124, 132, 149, 157
+};
+
 /******************************************************************************
  *
  * EEPROM related functions
@@ -203,3 +264,298 @@ void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac)
 }
 EXPORT_SYMBOL(iwl_eeprom_get_mac);
 
+static void iwl_init_band_reference(const struct iwl_priv *priv,
+				    int band,
+				    int *eeprom_ch_count,
+				    const struct iwl4965_eeprom_channel
+				    **eeprom_ch_info,
+				    const u8 **eeprom_ch_index)
+{
+	switch (band) {
+	case 1:		/* 2.4GHz band */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_1);
+		*eeprom_ch_info = priv->eeprom.band_1_channels;
+		*eeprom_ch_index = iwl_eeprom_band_1;
+		break;
+	case 2:		/* 4.9GHz band */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_2);
+		*eeprom_ch_info = priv->eeprom.band_2_channels;
+		*eeprom_ch_index = iwl_eeprom_band_2;
+		break;
+	case 3:		/* 5.2GHz band */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_3);
+		*eeprom_ch_info = priv->eeprom.band_3_channels;
+		*eeprom_ch_index = iwl_eeprom_band_3;
+		break;
+	case 4:		/* 5.5GHz band */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_4);
+		*eeprom_ch_info = priv->eeprom.band_4_channels;
+		*eeprom_ch_index = iwl_eeprom_band_4;
+		break;
+	case 5:		/* 5.7GHz band */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_5);
+		*eeprom_ch_info = priv->eeprom.band_5_channels;
+		*eeprom_ch_index = iwl_eeprom_band_5;
+		break;
+	case 6:		/* 2.4GHz FAT channels */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_6);
+		*eeprom_ch_info = priv->eeprom.band_24_channels;
+		*eeprom_ch_index = iwl_eeprom_band_6;
+		break;
+	case 7:		/* 5 GHz FAT channels */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_7);
+		*eeprom_ch_info = priv->eeprom.band_52_channels;
+		*eeprom_ch_index = iwl_eeprom_band_7;
+		break;
+	default:
+		BUG();
+		return;
+	}
+}
+
+#define CHECK_AND_PRINT(x) ((eeprom_ch->flags & EEPROM_CHANNEL_##x) \
+			    ? # x " " : "")
+
+/**
+ * iwl4965_set_fat_chan_info - Copy fat channel info into driver's priv.
+ *
+ * Does not set up a command, or touch hardware.
+ */
+static int iwl4965_set_fat_chan_info(struct iwl_priv *priv,
+			      enum ieee80211_band band, u16 channel,
+			      const struct iwl4965_eeprom_channel *eeprom_ch,
+			      u8 fat_extension_channel)
+{
+	struct iwl_channel_info *ch_info;
+
+	ch_info = (struct iwl_channel_info *)
+			iwl4965_get_channel_info(priv, band, channel);
+
+	if (!is_channel_valid(ch_info))
+		return -1;
+
+	IWL_DEBUG_INFO("FAT Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x"
+			" %ddBm): Ad-Hoc %ssupported\n",
+			ch_info->channel,
+			is_channel_a_band(ch_info) ?
+			"5.2" : "2.4",
+			CHECK_AND_PRINT(IBSS),
+			CHECK_AND_PRINT(ACTIVE),
+			CHECK_AND_PRINT(RADAR),
+			CHECK_AND_PRINT(WIDE),
+			CHECK_AND_PRINT(NARROW),
+			CHECK_AND_PRINT(DFS),
+			eeprom_ch->flags,
+			eeprom_ch->max_power_avg,
+			((eeprom_ch->flags & EEPROM_CHANNEL_IBSS)
+			 && !(eeprom_ch->flags & EEPROM_CHANNEL_RADAR)) ?
+			"" : "not ");
+
+	ch_info->fat_eeprom = *eeprom_ch;
+	ch_info->fat_max_power_avg = eeprom_ch->max_power_avg;
+	ch_info->fat_curr_txpow = eeprom_ch->max_power_avg;
+	ch_info->fat_min_power = 0;
+	ch_info->fat_scan_power = eeprom_ch->max_power_avg;
+	ch_info->fat_flags = eeprom_ch->flags;
+	ch_info->fat_extension_channel = fat_extension_channel;
+
+	return 0;
+}
+
+#define CHECK_AND_PRINT_I(x) ((eeprom_ch_info[ch].flags & EEPROM_CHANNEL_##x) \
+			    ? # x " " : "")
+
+/**
+ * iwl_init_channel_map - Set up driver's info for all possible channels
+ */
+int iwl_init_channel_map(struct iwl_priv *priv)
+{
+	int eeprom_ch_count = 0;
+	const u8 *eeprom_ch_index = NULL;
+	const struct iwl4965_eeprom_channel *eeprom_ch_info = NULL;
+	int band, ch;
+	struct iwl_channel_info *ch_info;
+
+	if (priv->channel_count) {
+		IWL_DEBUG_INFO("Channel map already initialized.\n");
+		return 0;
+	}
+
+	if (priv->eeprom.version < 0x2f) {
+		IWL_WARNING("Unsupported EEPROM version: 0x%04X\n",
+			    priv->eeprom.version);
+		return -EINVAL;
+	}
+
+	IWL_DEBUG_INFO("Initializing regulatory info from EEPROM\n");
+
+	priv->channel_count =
+	    ARRAY_SIZE(iwl_eeprom_band_1) +
+	    ARRAY_SIZE(iwl_eeprom_band_2) +
+	    ARRAY_SIZE(iwl_eeprom_band_3) +
+	    ARRAY_SIZE(iwl_eeprom_band_4) +
+	    ARRAY_SIZE(iwl_eeprom_band_5);
+
+	IWL_DEBUG_INFO("Parsing data for %d channels.\n", priv->channel_count);
+
+	priv->channel_info = kzalloc(sizeof(struct iwl_channel_info) *
+				     priv->channel_count, GFP_KERNEL);
+	if (!priv->channel_info) {
+		IWL_ERROR("Could not allocate channel_info\n");
+		priv->channel_count = 0;
+		return -ENOMEM;
+	}
+
+	ch_info = priv->channel_info;
+
+	/* Loop through the 5 EEPROM bands adding them in order to the
+	 * channel map we maintain (that contains additional information than
+	 * what just in the EEPROM) */
+	for (band = 1; band <= 5; band++) {
+
+		iwl_init_band_reference(priv, band, &eeprom_ch_count,
+					&eeprom_ch_info, &eeprom_ch_index);
+
+		/* Loop through each band adding each of the channels */
+		for (ch = 0; ch < eeprom_ch_count; ch++) {
+			ch_info->channel = eeprom_ch_index[ch];
+			ch_info->band = (band == 1) ? IEEE80211_BAND_2GHZ :
+			    IEEE80211_BAND_5GHZ;
+
+			/* permanently store EEPROM's channel regulatory flags
+			 *   and max power in channel info database. */
+			ch_info->eeprom = eeprom_ch_info[ch];
+
+			/* Copy the run-time flags so they are there even on
+			 * invalid channels */
+			ch_info->flags = eeprom_ch_info[ch].flags;
+
+			if (!(is_channel_valid(ch_info))) {
+				IWL_DEBUG_INFO("Ch. %d Flags %x [%sGHz] - "
+					       "No traffic\n",
+					       ch_info->channel,
+					       ch_info->flags,
+					       is_channel_a_band(ch_info) ?
+					       "5.2" : "2.4");
+				ch_info++;
+				continue;
+			}
+
+			/* Initialize regulatory-based run-time data */
+			ch_info->max_power_avg = ch_info->curr_txpow =
+			    eeprom_ch_info[ch].max_power_avg;
+			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
+			ch_info->min_power = 0;
+
+			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s%s(0x%02x"
+				       " %ddBm): Ad-Hoc %ssupported\n",
+				       ch_info->channel,
+				       is_channel_a_band(ch_info) ?
+				       "5.2" : "2.4",
+				       CHECK_AND_PRINT_I(VALID),
+				       CHECK_AND_PRINT_I(IBSS),
+				       CHECK_AND_PRINT_I(ACTIVE),
+				       CHECK_AND_PRINT_I(RADAR),
+				       CHECK_AND_PRINT_I(WIDE),
+				       CHECK_AND_PRINT_I(NARROW),
+				       CHECK_AND_PRINT_I(DFS),
+				       eeprom_ch_info[ch].flags,
+				       eeprom_ch_info[ch].max_power_avg,
+				       ((eeprom_ch_info[ch].
+					 flags & EEPROM_CHANNEL_IBSS)
+					&& !(eeprom_ch_info[ch].
+					     flags & EEPROM_CHANNEL_RADAR))
+				       ? "" : "not ");
+
+			/* Set the user_txpower_limit to the highest power
+			 * supported by any channel */
+			if (eeprom_ch_info[ch].max_power_avg >
+			    priv->user_txpower_limit)
+				priv->user_txpower_limit =
+				    eeprom_ch_info[ch].max_power_avg;
+
+			ch_info++;
+		}
+	}
+
+	/* Two additional EEPROM bands for 2.4 and 5 GHz FAT channels */
+	for (band = 6; band <= 7; band++) {
+		enum ieee80211_band ieeeband;
+		u8 fat_extension_chan;
+
+		iwl_init_band_reference(priv, band, &eeprom_ch_count,
+					&eeprom_ch_info, &eeprom_ch_index);
+
+		/* EEPROM band 6 is 2.4, band 7 is 5 GHz */
+		ieeeband =
+			(band == 6) ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+
+		/* Loop through each band adding each of the channels */
+		for (ch = 0; ch < eeprom_ch_count; ch++) {
+
+			if ((band == 6) &&
+			    ((eeprom_ch_index[ch] == 5) ||
+			    (eeprom_ch_index[ch] == 6) ||
+			    (eeprom_ch_index[ch] == 7)))
+			       fat_extension_chan = HT_IE_EXT_CHANNEL_MAX;
+			else
+				fat_extension_chan = HT_IE_EXT_CHANNEL_ABOVE;
+
+			/* Set up driver's info for lower half */
+			iwl4965_set_fat_chan_info(priv, ieeeband,
+						  eeprom_ch_index[ch],
+						  &(eeprom_ch_info[ch]),
+						  fat_extension_chan);
+
+			/* Set up driver's info for upper half */
+			iwl4965_set_fat_chan_info(priv, ieeeband,
+						  (eeprom_ch_index[ch] + 4),
+						  &(eeprom_ch_info[ch]),
+						  HT_IE_EXT_CHANNEL_BELOW);
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_init_channel_map);
+
+/*
+ * iwl_free_channel_map - undo allocations in iwl4965_init_channel_map
+ */
+void iwl_free_channel_map(struct iwl_priv *priv)
+{
+	kfree(priv->channel_info);
+	priv->channel_count = 0;
+}
+EXPORT_SYMBOL(iwl_free_channel_map);
+
+/**
+ * iwl_get_channel_info - Find driver's private channel info
+ *
+ * Based on band and channel number.
+ */
+const struct iwl_channel_info *iwl4965_get_channel_info(
+		const struct iwl_priv *priv,
+		enum ieee80211_band band, u16 channel)
+{
+	int i;
+
+	switch (band) {
+	case IEEE80211_BAND_5GHZ:
+		for (i = 14; i < priv->channel_count; i++) {
+			if (priv->channel_info[i].channel == channel)
+				return &priv->channel_info[i];
+		}
+		break;
+	case IEEE80211_BAND_2GHZ:
+		if (channel >= 1 && channel <= 14)
+			return &priv->channel_info[channel - 1];
+		break;
+	default:
+		BUG();
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(iwl4965_get_channel_info);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 404c700..8a58394 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -137,6 +137,8 @@ struct iwl4965_eeprom_channel {
  * Look for this in calib_version member of struct iwl4965_eeprom. */
 #define EEPROM_TX_POWER_VERSION_NEW    (5)
 
+/* 2.4 GHz */
+extern const u8 iwl_eeprom_band_1[14];
 
 /*
  * 4965 factory calibration data for one txpower level, on one channel,
@@ -364,4 +366,10 @@ int iwlcore_eeprom_verify_signature(struct iwl_priv *priv);
 int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv);
 void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv);
 
+int iwl_init_channel_map(struct iwl_priv *priv);
+void iwl_free_channel_map(struct iwl_priv *priv);
+const struct iwl_channel_info *iwl4965_get_channel_info(
+		const struct iwl_priv *priv,
+		enum ieee80211_band band, u16 channel);
+
 #endif  /* __iwl_eeprom_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 4d95ea5..64595ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -431,23 +431,6 @@ out:
 #endif
 
 /**
- * iwl4965_clear_stations_table - Clear the driver's station table
- *
- * NOTE:  This does not clear or otherwise alter the device's station table.
- */
-static void iwl4965_clear_stations_table(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	priv->num_stations = 0;
-	memset(priv->stations, 0, sizeof(priv->stations));
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-}
-
-/**
  * iwl4965_add_station_flags - Add station to tables in driver and device
  */
 u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
@@ -892,43 +875,6 @@ static int iwl4965_rxon_add_station(struct iwl_priv *priv,
 }
 
 /**
- * iwl4965_set_rxon_channel - Set the phymode and channel values in staging RXON
- * @phymode: MODE_IEEE80211A sets to 5.2GHz; all else set to 2.4GHz
- * @channel: Any channel valid for the requested phymode
-
- * In addition to setting the staging RXON, priv->phymode is also set.
- *
- * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
- * in the staging RXON flag structure based on the phymode
- */
-static int iwl4965_set_rxon_channel(struct iwl_priv *priv,
-				    enum ieee80211_band band,
-				 u16 channel)
-{
-	if (!iwl4965_get_channel_info(priv, band, channel)) {
-		IWL_DEBUG_INFO("Could not set channel to %d [%d]\n",
-			       channel, band);
-		return -EINVAL;
-	}
-
-	if ((le16_to_cpu(priv->staging_rxon.channel) == channel) &&
-	    (priv->band == band))
-		return 0;
-
-	priv->staging_rxon.channel = cpu_to_le16(channel);
-	if (band == IEEE80211_BAND_5GHZ)
-		priv->staging_rxon.flags &= ~RXON_FLG_BAND_24G_MSK;
-	else
-		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
-
-	priv->band = band;
-
-	IWL_DEBUG_INFO("Staging channel set to %d [%d]\n", channel, band);
-
-	return 0;
-}
-
-/**
  * iwl4965_check_rxon_cmd - validate RXON structure is valid
  *
  * NOTE:  This is really only useful during development and can eventually
@@ -1198,7 +1144,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		return rc;
 	}
 
-	iwl4965_clear_stations_table(priv);
+	iwlcore_clear_stations_table(priv);
 
 #ifdef CONFIG_IWL4965_SENSITIVITY
 	if (!priv->error_recovering)
@@ -1845,93 +1791,6 @@ static int iwl4965_send_qos_params_command(struct iwl_priv *priv,
 				sizeof(struct iwl4965_qosparam_cmd), qos);
 }
 
-static void iwl4965_reset_qos(struct iwl_priv *priv)
-{
-	u16 cw_min = 15;
-	u16 cw_max = 1023;
-	u8 aifs = 2;
-	u8 is_legacy = 0;
-	unsigned long flags;
-	int i;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->qos_data.qos_active = 0;
-
-	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS) {
-		if (priv->qos_data.qos_enable)
-			priv->qos_data.qos_active = 1;
-		if (!(priv->active_rate & 0xfff0)) {
-			cw_min = 31;
-			is_legacy = 1;
-		}
-	} else if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
-		if (priv->qos_data.qos_enable)
-			priv->qos_data.qos_active = 1;
-	} else if (!(priv->staging_rxon.flags & RXON_FLG_SHORT_SLOT_MSK)) {
-		cw_min = 31;
-		is_legacy = 1;
-	}
-
-	if (priv->qos_data.qos_active)
-		aifs = 3;
-
-	priv->qos_data.def_qos_parm.ac[0].cw_min = cpu_to_le16(cw_min);
-	priv->qos_data.def_qos_parm.ac[0].cw_max = cpu_to_le16(cw_max);
-	priv->qos_data.def_qos_parm.ac[0].aifsn = aifs;
-	priv->qos_data.def_qos_parm.ac[0].edca_txop = 0;
-	priv->qos_data.def_qos_parm.ac[0].reserved1 = 0;
-
-	if (priv->qos_data.qos_active) {
-		i = 1;
-		priv->qos_data.def_qos_parm.ac[i].cw_min = cpu_to_le16(cw_min);
-		priv->qos_data.def_qos_parm.ac[i].cw_max = cpu_to_le16(cw_max);
-		priv->qos_data.def_qos_parm.ac[i].aifsn = 7;
-		priv->qos_data.def_qos_parm.ac[i].edca_txop = 0;
-		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
-
-		i = 2;
-		priv->qos_data.def_qos_parm.ac[i].cw_min =
-			cpu_to_le16((cw_min + 1) / 2 - 1);
-		priv->qos_data.def_qos_parm.ac[i].cw_max =
-			cpu_to_le16(cw_max);
-		priv->qos_data.def_qos_parm.ac[i].aifsn = 2;
-		if (is_legacy)
-			priv->qos_data.def_qos_parm.ac[i].edca_txop =
-				cpu_to_le16(6016);
-		else
-			priv->qos_data.def_qos_parm.ac[i].edca_txop =
-				cpu_to_le16(3008);
-		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
-
-		i = 3;
-		priv->qos_data.def_qos_parm.ac[i].cw_min =
-			cpu_to_le16((cw_min + 1) / 4 - 1);
-		priv->qos_data.def_qos_parm.ac[i].cw_max =
-			cpu_to_le16((cw_max + 1) / 2 - 1);
-		priv->qos_data.def_qos_parm.ac[i].aifsn = 2;
-		priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
-		if (is_legacy)
-			priv->qos_data.def_qos_parm.ac[i].edca_txop =
-				cpu_to_le16(3264);
-		else
-			priv->qos_data.def_qos_parm.ac[i].edca_txop =
-				cpu_to_le16(1504);
-	} else {
-		for (i = 1; i < 4; i++) {
-			priv->qos_data.def_qos_parm.ac[i].cw_min =
-				cpu_to_le16(cw_min);
-			priv->qos_data.def_qos_parm.ac[i].cw_max =
-				cpu_to_le16(cw_max);
-			priv->qos_data.def_qos_parm.ac[i].aifsn = aifs;
-			priv->qos_data.def_qos_parm.ac[i].edca_txop = 0;
-			priv->qos_data.def_qos_parm.ac[i].reserved1 = 0;
-		}
-	}
-	IWL_DEBUG_QOS("set QoS to default \n");
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
 static void iwl4965_activate_qos(struct iwl_priv *priv, u8 force)
 {
 	unsigned long flags;
@@ -2406,7 +2265,7 @@ static void iwl4965_set_flags_for_phymode(struct iwl_priv *priv,
  */
 static void iwl4965_connection_init_rx_config(struct iwl_priv *priv)
 {
-	const struct iwl4965_channel_info *ch_info;
+	const struct iwl_channel_info *ch_info;
 
 	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
 
@@ -2479,7 +2338,7 @@ static void iwl4965_connection_init_rx_config(struct iwl_priv *priv)
 static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 {
 	if (mode == IEEE80211_IF_TYPE_IBSS) {
-		const struct iwl4965_channel_info *ch_info;
+		const struct iwl_channel_info *ch_info;
 
 		ch_info = iwl4965_get_channel_info(priv,
 			priv->band,
@@ -2497,7 +2356,7 @@ static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 	iwl4965_connection_init_rx_config(priv);
 	memcpy(priv->staging_rxon.node_addr, priv->mac_addr, ETH_ALEN);
 
-	iwl4965_clear_stations_table(priv);
+	iwlcore_clear_stations_table(priv);
 
 	/* dont commit rxon if rf-kill is on*/
 	if (!iwl4965_is_ready_rf(priv))
@@ -5101,308 +4960,6 @@ static irqreturn_t iwl4965_isr(int irq, void *data)
 	return IRQ_NONE;
 }
 
-/************************** EEPROM BANDS ****************************
- *
- * The iwl4965_eeprom_band definitions below provide the mapping from the
- * EEPROM contents to the specific channel number supported for each
- * band.
- *
- * For example, iwl_priv->eeprom.band_3_channels[4] from the band_3
- * definition below maps to physical channel 42 in the 5.2GHz spectrum.
- * The specific geography and calibration information for that channel
- * is contained in the eeprom map itself.
- *
- * During init, we copy the eeprom information and channel map
- * information into priv->channel_info_24/52 and priv->channel_map_24/52
- *
- * channel_map_24/52 provides the index in the channel_info array for a
- * given channel.  We have to have two separate maps as there is channel
- * overlap with the 2.4GHz and 5.2GHz spectrum as seen in band_1 and
- * band_2
- *
- * A value of 0xff stored in the channel_map indicates that the channel
- * is not supported by the hardware at all.
- *
- * A value of 0xfe in the channel_map indicates that the channel is not
- * valid for Tx with the current hardware.  This means that
- * while the system can tune and receive on a given channel, it may not
- * be able to associate or transmit any frames on that
- * channel.  There is no corresponding channel information for that
- * entry.
- *
- *********************************************************************/
-
-/* 2.4 GHz */
-static const u8 iwl4965_eeprom_band_1[14] = {
-	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
-};
-
-/* 5.2 GHz bands */
-static const u8 iwl4965_eeprom_band_2[] = {	/* 4915-5080MHz */
-	183, 184, 185, 187, 188, 189, 192, 196, 7, 8, 11, 12, 16
-};
-
-static const u8 iwl4965_eeprom_band_3[] = {	/* 5170-5320MHz */
-	34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
-};
-
-static const u8 iwl4965_eeprom_band_4[] = {	/* 5500-5700MHz */
-	100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
-};
-
-static const u8 iwl4965_eeprom_band_5[] = {	/* 5725-5825MHz */
-	145, 149, 153, 157, 161, 165
-};
-
-static u8 iwl4965_eeprom_band_6[] = {       /* 2.4 FAT channel */
-	1, 2, 3, 4, 5, 6, 7
-};
-
-static u8 iwl4965_eeprom_band_7[] = {       /* 5.2 FAT channel */
-	36, 44, 52, 60, 100, 108, 116, 124, 132, 149, 157
-};
-
-static void iwl4965_init_band_reference(const struct iwl_priv *priv,
-				    int band,
-				    int *eeprom_ch_count,
-				    const struct iwl4965_eeprom_channel
-				    **eeprom_ch_info,
-				    const u8 **eeprom_ch_index)
-{
-	switch (band) {
-	case 1:		/* 2.4GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl4965_eeprom_band_1);
-		*eeprom_ch_info = priv->eeprom.band_1_channels;
-		*eeprom_ch_index = iwl4965_eeprom_band_1;
-		break;
-	case 2:		/* 4.9GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl4965_eeprom_band_2);
-		*eeprom_ch_info = priv->eeprom.band_2_channels;
-		*eeprom_ch_index = iwl4965_eeprom_band_2;
-		break;
-	case 3:		/* 5.2GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl4965_eeprom_band_3);
-		*eeprom_ch_info = priv->eeprom.band_3_channels;
-		*eeprom_ch_index = iwl4965_eeprom_band_3;
-		break;
-	case 4:		/* 5.5GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl4965_eeprom_band_4);
-		*eeprom_ch_info = priv->eeprom.band_4_channels;
-		*eeprom_ch_index = iwl4965_eeprom_band_4;
-		break;
-	case 5:		/* 5.7GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl4965_eeprom_band_5);
-		*eeprom_ch_info = priv->eeprom.band_5_channels;
-		*eeprom_ch_index = iwl4965_eeprom_band_5;
-		break;
-	case 6:		/* 2.4GHz FAT channels */
-		*eeprom_ch_count = ARRAY_SIZE(iwl4965_eeprom_band_6);
-		*eeprom_ch_info = priv->eeprom.band_24_channels;
-		*eeprom_ch_index = iwl4965_eeprom_band_6;
-		break;
-	case 7:		/* 5 GHz FAT channels */
-		*eeprom_ch_count = ARRAY_SIZE(iwl4965_eeprom_band_7);
-		*eeprom_ch_info = priv->eeprom.band_52_channels;
-		*eeprom_ch_index = iwl4965_eeprom_band_7;
-		break;
-	default:
-		BUG();
-		return;
-	}
-}
-
-/**
- * iwl4965_get_channel_info - Find driver's private channel info
- *
- * Based on band and channel number.
- */
-const struct iwl4965_channel_info *iwl4965_get_channel_info(const struct iwl_priv *priv,
-						    enum ieee80211_band band, u16 channel)
-{
-	int i;
-
-	switch (band) {
-	case IEEE80211_BAND_5GHZ:
-		for (i = 14; i < priv->channel_count; i++) {
-			if (priv->channel_info[i].channel == channel)
-				return &priv->channel_info[i];
-		}
-		break;
-	case IEEE80211_BAND_2GHZ:
-		if (channel >= 1 && channel <= 14)
-			return &priv->channel_info[channel - 1];
-		break;
-	default:
-		BUG();
-	}
-
-	return NULL;
-}
-
-#define CHECK_AND_PRINT(x) ((eeprom_ch_info[ch].flags & EEPROM_CHANNEL_##x) \
-			    ? # x " " : "")
-
-/**
- * iwl4965_init_channel_map - Set up driver's info for all possible channels
- */
-static int iwl4965_init_channel_map(struct iwl_priv *priv)
-{
-	int eeprom_ch_count = 0;
-	const u8 *eeprom_ch_index = NULL;
-	const struct iwl4965_eeprom_channel *eeprom_ch_info = NULL;
-	int band, ch;
-	struct iwl4965_channel_info *ch_info;
-
-	if (priv->channel_count) {
-		IWL_DEBUG_INFO("Channel map already initialized.\n");
-		return 0;
-	}
-
-	if (priv->eeprom.version < 0x2f) {
-		IWL_WARNING("Unsupported EEPROM version: 0x%04X\n",
-			    priv->eeprom.version);
-		return -EINVAL;
-	}
-
-	IWL_DEBUG_INFO("Initializing regulatory info from EEPROM\n");
-
-	priv->channel_count =
-	    ARRAY_SIZE(iwl4965_eeprom_band_1) +
-	    ARRAY_SIZE(iwl4965_eeprom_band_2) +
-	    ARRAY_SIZE(iwl4965_eeprom_band_3) +
-	    ARRAY_SIZE(iwl4965_eeprom_band_4) +
-	    ARRAY_SIZE(iwl4965_eeprom_band_5);
-
-	IWL_DEBUG_INFO("Parsing data for %d channels.\n", priv->channel_count);
-
-	priv->channel_info = kzalloc(sizeof(struct iwl4965_channel_info) *
-				     priv->channel_count, GFP_KERNEL);
-	if (!priv->channel_info) {
-		IWL_ERROR("Could not allocate channel_info\n");
-		priv->channel_count = 0;
-		return -ENOMEM;
-	}
-
-	ch_info = priv->channel_info;
-
-	/* Loop through the 5 EEPROM bands adding them in order to the
-	 * channel map we maintain (that contains additional information than
-	 * what just in the EEPROM) */
-	for (band = 1; band <= 5; band++) {
-
-		iwl4965_init_band_reference(priv, band, &eeprom_ch_count,
-					&eeprom_ch_info, &eeprom_ch_index);
-
-		/* Loop through each band adding each of the channels */
-		for (ch = 0; ch < eeprom_ch_count; ch++) {
-			ch_info->channel = eeprom_ch_index[ch];
-			ch_info->band = (band == 1) ? IEEE80211_BAND_2GHZ :
-			    IEEE80211_BAND_5GHZ;
-
-			/* permanently store EEPROM's channel regulatory flags
-			 *   and max power in channel info database. */
-			ch_info->eeprom = eeprom_ch_info[ch];
-
-			/* Copy the run-time flags so they are there even on
-			 * invalid channels */
-			ch_info->flags = eeprom_ch_info[ch].flags;
-
-			if (!(is_channel_valid(ch_info))) {
-				IWL_DEBUG_INFO("Ch. %d Flags %x [%sGHz] - "
-					       "No traffic\n",
-					       ch_info->channel,
-					       ch_info->flags,
-					       is_channel_a_band(ch_info) ?
-					       "5.2" : "2.4");
-				ch_info++;
-				continue;
-			}
-
-			/* Initialize regulatory-based run-time data */
-			ch_info->max_power_avg = ch_info->curr_txpow =
-			    eeprom_ch_info[ch].max_power_avg;
-			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
-			ch_info->min_power = 0;
-
-			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s%s(0x%02x"
-				       " %ddBm): Ad-Hoc %ssupported\n",
-				       ch_info->channel,
-				       is_channel_a_band(ch_info) ?
-				       "5.2" : "2.4",
-				       CHECK_AND_PRINT(VALID),
-				       CHECK_AND_PRINT(IBSS),
-				       CHECK_AND_PRINT(ACTIVE),
-				       CHECK_AND_PRINT(RADAR),
-				       CHECK_AND_PRINT(WIDE),
-				       CHECK_AND_PRINT(NARROW),
-				       CHECK_AND_PRINT(DFS),
-				       eeprom_ch_info[ch].flags,
-				       eeprom_ch_info[ch].max_power_avg,
-				       ((eeprom_ch_info[ch].
-					 flags & EEPROM_CHANNEL_IBSS)
-					&& !(eeprom_ch_info[ch].
-					     flags & EEPROM_CHANNEL_RADAR))
-				       ? "" : "not ");
-
-			/* Set the user_txpower_limit to the highest power
-			 * supported by any channel */
-			if (eeprom_ch_info[ch].max_power_avg >
-			    priv->user_txpower_limit)
-				priv->user_txpower_limit =
-				    eeprom_ch_info[ch].max_power_avg;
-
-			ch_info++;
-		}
-	}
-
-	/* Two additional EEPROM bands for 2.4 and 5 GHz FAT channels */
-	for (band = 6; band <= 7; band++) {
-		enum ieee80211_band ieeeband;
-		u8 fat_extension_chan;
-
-		iwl4965_init_band_reference(priv, band, &eeprom_ch_count,
-					&eeprom_ch_info, &eeprom_ch_index);
-
-		/* EEPROM band 6 is 2.4, band 7 is 5 GHz */
-		ieeeband = (band == 6) ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
-
-		/* Loop through each band adding each of the channels */
-		for (ch = 0; ch < eeprom_ch_count; ch++) {
-
-			if ((band == 6) &&
-			    ((eeprom_ch_index[ch] == 5) ||
-			    (eeprom_ch_index[ch] == 6) ||
-			    (eeprom_ch_index[ch] == 7)))
-			       fat_extension_chan = HT_IE_EXT_CHANNEL_MAX;
-			else
-				fat_extension_chan = HT_IE_EXT_CHANNEL_ABOVE;
-
-			/* Set up driver's info for lower half */
-			iwl4965_set_fat_chan_info(priv, ieeeband,
-						  eeprom_ch_index[ch],
-						  &(eeprom_ch_info[ch]),
-						  fat_extension_chan);
-
-			/* Set up driver's info for upper half */
-			iwl4965_set_fat_chan_info(priv, ieeeband,
-						  (eeprom_ch_index[ch] + 4),
-						  &(eeprom_ch_info[ch]),
-						  HT_IE_EXT_CHANNEL_BELOW);
-		}
-	}
-
-	return 0;
-}
-
-/*
- * iwl4965_free_channel_map - undo allocations in iwl4965_init_channel_map
- */
-static void iwl4965_free_channel_map(struct iwl_priv *priv)
-{
-	kfree(priv->channel_info);
-	priv->channel_count = 0;
-}
-
 /* For active scan, listen ACTIVE_DWELL_TIME (msec) on each channel after
  * sending probe req.  This should be set long enough to hear probe responses
  * from more than one AP.  */
@@ -5466,7 +5023,7 @@ static int iwl4965_get_channels_for_scan(struct iwl_priv *priv,
 {
 	const struct ieee80211_channel *channels = NULL;
 	const struct ieee80211_supported_band *sband;
-	const struct iwl4965_channel_info *ch_info;
+	const struct iwl_channel_info *ch_info;
 	u16 passive_dwell = 0;
 	u16 active_dwell = 0;
 	int added, i;
@@ -5570,9 +5127,9 @@ static void iwl4965_init_hw_rates(struct iwl_priv *priv,
 /**
  * iwl4965_init_geos - Initialize mac80211's geo/channel info based from eeprom
  */
-static int iwl4965_init_geos(struct iwl_priv *priv)
+int iwl4965_init_geos(struct iwl_priv *priv)
 {
-	struct iwl4965_channel_info *ch;
+	struct iwl_channel_info *ch;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *channels;
 	struct ieee80211_channel *geo_ch;
@@ -5600,7 +5157,7 @@ static int iwl4965_init_geos(struct iwl_priv *priv)
 
 	/* 5.2GHz channels start after the 2.4GHz channels */
 	sband = &priv->bands[IEEE80211_BAND_5GHZ];
-	sband->channels = &channels[ARRAY_SIZE(iwl4965_eeprom_band_1)];
+	sband->channels = &channels[ARRAY_SIZE(iwl_eeprom_band_1)];
 	/* just OFDM */
 	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
 	sband->n_bitrates = IWL_RATE_COUNT - IWL_FIRST_OFDM_RATE;
@@ -5692,7 +5249,7 @@ static int iwl4965_init_geos(struct iwl_priv *priv)
 /*
  * iwl4965_free_geos - undo allocations in iwl4965_init_geos
  */
-static void iwl4965_free_geos(struct iwl_priv *priv)
+void iwl4965_free_geos(struct iwl_priv *priv)
 {
 	kfree(priv->ieee_channels);
 	kfree(priv->ieee_rates);
@@ -6335,7 +5892,7 @@ static void iwl4965_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	iwl4965_clear_stations_table(priv);
+	iwlcore_clear_stations_table(priv);
 
 	rc = iwl4965_alive_notify(priv);
 	if (rc) {
@@ -6412,7 +5969,7 @@ static void __iwl4965_down(struct iwl_priv *priv)
 	if (!exit_pending)
 		set_bit(STATUS_EXIT_PENDING, &priv->status);
 
-	iwl4965_clear_stations_table(priv);
+	iwlcore_clear_stations_table(priv);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
@@ -6567,7 +6124,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
-		iwl4965_clear_stations_table(priv);
+		iwlcore_clear_stations_table(priv);
 
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
@@ -7013,7 +6570,7 @@ static void iwl4965_bg_post_associate(struct work_struct *data)
 	case IEEE80211_IF_TYPE_IBSS:
 
 		/* clear out the station table */
-		iwl4965_clear_stations_table(priv);
+		iwlcore_clear_stations_table(priv);
 
 		iwl4965_rxon_add_station(priv, iwl4965_broadcast_addr, 0);
 		iwl4965_rxon_add_station(priv, priv->bssid, 0);
@@ -7271,7 +6828,7 @@ static int iwl4965_mac_add_interface(struct ieee80211_hw *hw,
 static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
 	struct iwl_priv *priv = hw->priv;
-	const struct iwl4965_channel_info *ch_info;
+	const struct iwl_channel_info *ch_info;
 	unsigned long flags;
 	int ret = 0;
 
@@ -7317,7 +6874,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 		priv->staging_rxon.flags = 0;
 #endif /* CONFIG_IWL4965_HT */
 
-	iwl4965_set_rxon_channel(priv, conf->channel->band,
+	iwlcore_set_rxon_channel(priv, conf->channel->band,
 		ieee80211_frequency_to_channel(conf->channel->center_freq));
 
 	iwl4965_set_flags_for_phymode(priv, conf->channel->band);
@@ -7840,7 +7397,7 @@ static void iwl4965_mac_reset_tsf(struct ieee80211_hw *hw)
 	spin_unlock_irqrestore(&priv->lock, flags);
 #endif /* CONFIG_IWL4965_HT */
 
-	iwl4965_reset_qos(priv);
+	iwlcore_reset_qos(priv);
 
 	cancel_delayed_work(&priv->post_associate);
 
@@ -7929,7 +7486,7 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 	IWL_DEBUG_MAC80211("leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	iwl4965_reset_qos(priv);
+	iwlcore_reset_qos(priv);
 
 	queue_work(priv->workqueue, &priv->post_associate.work);
 
@@ -8621,7 +8178,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
-	int i;
 	DECLARE_MAC_BUF(mac);
 
 	/************************
@@ -8738,93 +8294,10 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * 6. Setup hw/priv
 	 *******************/
 
-	/* Tell mac80211 and its clients (e.g. Wireless Extensions)
-	 *   the range of signal quality values that we'll provide.
-	 * Negative values for level/noise indicate that we'll provide dBm.
-	 * For WE, at least, non-0 values here *enable* display of values
-	 *   in app (iwconfig). */
-	hw->max_rssi = -20;	/* signal level, negative indicates dBm */
-	hw->max_noise = -20;	/* noise level, negative indicates dBm */
-	hw->max_signal = 100;	/* link quality indication (%) */
-
-	/* Tell mac80211 our Tx characteristics */
-	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
-
-	/* Default value; 4 EDCA QOS priorities */
-	hw->queues = 4;
-#ifdef CONFIG_IWL4965_HT
-	/* Enhanced value; more queues, to support 11n aggregation */
-	hw->queues = 16;
-#endif /* CONFIG_IWL4965_HT */
-
-	hw->rate_control_algorithm = "iwl-4965-rs";
-	priv->antenna = (enum iwl4965_antenna)iwl4965_mod_params.antenna;
-	priv->retry_rate = 1;
-	priv->ibss_beacon = NULL;
-
-	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->power_data.lock);
-	spin_lock_init(&priv->sta_lock);
-	spin_lock_init(&priv->hcmd_lock);
-	spin_lock_init(&priv->lq_mngr.lock);
-
-	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++)
-		INIT_LIST_HEAD(&priv->ibss_mac_hash[i]);
-
-	INIT_LIST_HEAD(&priv->free_frames);
-
-	mutex_init(&priv->mutex);
-
-	/* Clear the driver's (not device's) station table */
-	iwl4965_clear_stations_table(priv);
-
-	priv->data_retry_limit = -1;
-	priv->ieee_channels = NULL;
-	priv->ieee_rates = NULL;
-	priv->band = IEEE80211_BAND_2GHZ;
-
-	priv->iw_mode = IEEE80211_IF_TYPE_STA;
-
-	priv->use_ant_b_for_management_frame = 1; /* start with ant B */
-	priv->valid_antenna = 0x7;	/* assume all 3 connected */
-	priv->ps_mode = IWL_MIMO_PS_NONE;
-
-	/* Choose which receivers/antennas to use */
-	iwl4965_set_rxon_chain(priv);
-
-	iwl4965_reset_qos(priv);
-
-	priv->qos_data.qos_active = 0;
-	priv->qos_data.qos_cap.val = 0;
-
-	iwl4965_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
-
-	priv->rates_mask = IWL_RATES_MASK;
-	/* If power management is turned on, default to AC mode */
-	priv->power_mode = IWL_POWER_AC;
-	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
-
-	err = iwl4965_init_channel_map(priv);
-	if (err) {
-		IWL_ERROR("initializing regulatory failed: %d\n", err);
+	err = iwl_setup(priv);
+	if (err)
 		goto out_unset_hw_settings;
-	}
-
-	err = iwl4965_init_geos(priv);
-	if (err) {
-		IWL_ERROR("initializing geos failed: %d\n", err);
-		goto out_free_channel_map;
-	}
-
-	iwl4965_rate_control_register(priv->hw);
-	err = ieee80211_register_hw(priv->hw);
-	if (err) {
-		IWL_ERROR("Failed to register network device (error %d)\n", err);
-		goto out_free_geos;
-	}
-
-	priv->hw->conf.beacon_int = 100;
-	priv->mac80211_registered = 1;
+	/* At this point both hw and priv are initialized. */
 
 	/**********************************
 	 * 7. Initialize module parameters
@@ -8847,7 +8320,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = sysfs_create_group(&pdev->dev.kobj, &iwl4965_attribute_group);
 	if (err) {
 		IWL_ERROR("failed to create sysfs device attributes\n");
-		goto out_free_geos;
+		goto out_unset_hw_settings;
 	}
 
 	err = iwl_dbgfs_register(priv, DRV_NAME);
@@ -8869,10 +8342,6 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
  out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
- out_free_geos:
-	iwl4965_free_geos(priv);
- out_free_channel_map:
-	iwl4965_free_channel_map(priv);
  out_unset_hw_settings:
 	iwl4965_unset_hw_setting(priv);
  out_iounmap:
@@ -8921,7 +8390,7 @@ static void iwl4965_pci_remove(struct pci_dev *pdev)
 	iwl4965_hw_txq_ctx_free(priv);
 
 	iwl4965_unset_hw_setting(priv);
-	iwl4965_clear_stations_table(priv);
+	iwlcore_clear_stations_table(priv);
 
 	if (priv->mac80211_registered) {
 		ieee80211_unregister_hw(priv->hw);
@@ -8942,7 +8411,7 @@ static void iwl4965_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 
-	iwl4965_free_channel_map(priv);
+	iwl_free_channel_map(priv);
 	iwl4965_free_geos(priv);
 
 	if (priv->ibss_beacon)
-- 
1.5.3.4

