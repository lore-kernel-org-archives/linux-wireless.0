Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46618 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760169AbYBFAoF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 19:44:05 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: Fix HT compilation breakage caused by cfg80211 API for channels/bitrates patch
Date: Wed,  6 Feb 2008 02:37:18 +0200
Message-Id: <12022582382773-git-send-email-tomas.winkler@intel.com> (sfid-20080206_004415_925398_38E40917)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes compilation breakage caused by 'cfg80211 API for
channels/bitrates' patch.
however it doesn't fix the driver's functional problems caused by that
patch.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   11 ++-
 drivers/net/wireless/iwlwifi/iwl-4965.h     |   18 ++++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   83 ++++++++++-----------------
 4 files changed, 50 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index f018ce4..a8223c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -464,7 +464,7 @@ static void rs_tx_status(void *priv_rate,
 	IWL_DEBUG_RATE("enter\n");
 
 	retries = tx_resp->retry_count;
-
+	/* FIXME : this is wrong */
 	first_index = &sband->bitrates[0] - tx_resp->control.tx_rate;
 	if ((first_index < 0) || (first_index >= IWL_RATE_COUNT)) {
 		IWL_DEBUG_RATE("leave: Rate out of bounds: %d\n", first_index);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 79545d6..b636b06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3459,14 +3459,15 @@ static int parse_elems(u8 *start, size_t len, struct ieee802_11_elems *elems)
 	return 0;
 }
 
-void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info, int mode)
+void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
+			      enum ieee80211_band band)
 {
 	ht_info->cap = 0;
 	memset(ht_info->supp_mcs_set, 0, 16);
 
 	ht_info->ht_supported = 1;
 
-	if (mode == MODE_IEEE80211A) {
+	if (band == IEEE80211_BAND_5GHZ) {
 		ht_info->cap |= (u16)IEEE80211_HT_CAP_SUP_WIDTH;
 		ht_info->cap |= (u16)IEEE80211_HT_CAP_SGI_40;
 		ht_info->supp_mcs_set[4] = 0x01;
@@ -3896,7 +3897,9 @@ static int iwl4965_tx_status_reply_compressed_ba(struct iwl4965_priv *priv,
 	tx_status->flags |= IEEE80211_TX_STATUS_AMPDU;
 	tx_status->ampdu_ack_map = successes;
 	tx_status->ampdu_ack_len = agg->frame_count;
+	/* FIXME Wrong rate
 	tx_status->control.tx_rate = agg->rate_n_flags;
+	*/
 
 	IWL_DEBUG_TX_REPLY("Bitmap %llx\n", bitmap);
 
@@ -4218,7 +4221,7 @@ void iwl4965_add_station(struct iwl4965_priv *priv, const u8 *addr, int is_ap)
 
 static u8 iwl4965_is_channel_extension(struct iwl4965_priv *priv,
 				       enum ieee80211_band band,
-				   u16 channel, u8 extension_chan_offset)
+				       u16 channel, u8 extension_chan_offset)
 {
 	const struct iwl4965_channel_info *ch_info;
 
@@ -4252,7 +4255,7 @@ static u8 iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
 			return 0;
 	}
 
-	return (iwl4965_is_channel_extension(priv, priv->phymode,
+	return (iwl4965_is_channel_extension(priv, priv->band,
 					 iwl_ht_conf->control_channel,
 					 iwl_ht_conf->extension_chan_offset));
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index cb8f7f2..45cf483 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -772,17 +772,21 @@ extern int iwl4965_set_fat_chan_info(struct iwl4965_priv *priv,
 extern void iwl4965_rf_kill_ct_config(struct iwl4965_priv *priv);
 
 #ifdef CONFIG_IWL4965_HT
-extern void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
-					int mode);
-extern void iwl4965_set_rxon_ht(struct iwl4965_priv *priv,
-				struct iwl_ht_info *ht_info);
-extern void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index,
+void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
+			      enum ieee80211_band band);
+void iwl4965_set_rxon_ht(struct iwl4965_priv *priv,
+			 struct iwl_ht_info *ht_info);
+void iwl4965_set_ht_add_station(struct iwl4965_priv *priv, u8 index,
 				struct ieee80211_ht_info *sta_ht_inf);
-extern int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
+int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 				    enum ieee80211_ampdu_mlme_action action,
 				    const u8 *addr, u16 tid, u16 *ssn);
-extern int iwl4965_check_empty_hw_queue(struct iwl4965_priv *priv, int sta_id,
+int iwl4965_check_empty_hw_queue(struct iwl4965_priv *priv, int sta_id,
 					u8 tid, int txq_id);
+#else
+static inline void iwl4965_init_ht_hw_capab(struct ieee80211_ht_info *ht_info,
+					    enum ieee80211_band band) {}
+
 #endif /*CONFIG_IWL4965_HT */
 /* Structures, enum, and defines specific to the 4965 */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 788e176..97d2bbb 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1888,24 +1888,20 @@ static u16 iwl4965_supported_rate_to_ie(u8 *ie, u16 supported_rate,
 	return ret_rates;
 }
 
-#ifdef CONFIG_IWL4965_HT
-void static iwl4965_set_ht_capab(struct ieee80211_hw *hw,
-			     struct ieee80211_ht_cap *ht_cap,
-			     u8 use_current_config);
-#endif
-
 /**
  * iwl4965_fill_probe_req - fill in all required fields and IE for probe request
  */
 static u16 iwl4965_fill_probe_req(struct iwl4965_priv *priv,
-			      struct ieee80211_mgmt *frame,
-			      int left, int is_direct)
+				  enum ieee80211_band band,
+				  struct ieee80211_mgmt *frame,
+				  int left, int is_direct)
 {
 	int len = 0;
 	u8 *pos = NULL;
 	u16 active_rates, ret_rates, cck_rates, active_rate_basic;
 #ifdef CONFIG_IWL4965_HT
-	struct ieee80211_hw_mode *mode;
+	const struct ieee80211_supported_band *sband =
+						iwl4965_get_hw_mode(priv, band);
 #endif /* CONFIG_IWL4965_HT */
 
 	/* Make sure there is enough space for the probe request,
@@ -1990,13 +1986,18 @@ static u16 iwl4965_fill_probe_req(struct iwl4965_priv *priv,
 		len += 2 + *pos;
 
 #ifdef CONFIG_IWL4965_HT
-	mode = priv->hw->conf.mode;
-	if (mode->ht_info.ht_supported) {
+	if (sband && sband->ht_info.ht_supported) {
+		struct ieee80211_ht_cap *ht_cap;
 		pos += (*pos) + 1;
 		*pos++ = WLAN_EID_HT_CAPABILITY;
 		*pos++ = sizeof(struct ieee80211_ht_cap);
-		iwl4965_set_ht_capab(priv->hw,
-				(struct ieee80211_ht_cap *)pos, 0);
+		ht_cap = (struct ieee80211_ht_cap *)pos;
+		ht_cap->cap_info = cpu_to_le16(sband->ht_info.cap);
+		memcpy(ht_cap->supp_mcs_set, sband->ht_info.supp_mcs_set, 16);
+		ht_cap->ampdu_params_info =(sband->ht_info.ampdu_factor &
+					    IEEE80211_HT_CAP_AMPDU_FACTOR) |
+					    ((sband->ht_info.ampdu_density << 2) &
+					    IEEE80211_HT_CAP_AMPDU_DENSITY);
 		len += 2 + sizeof(struct ieee80211_ht_cap);
 	}
 #endif  /*CONFIG_IWL4965_HT */
@@ -3587,8 +3588,9 @@ static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
 		tx_status->control.flags &= ~IEEE80211_TXCTL_AMPDU;
 		tx_status->flags = iwl4965_is_tx_success(status)?
 			IEEE80211_TX_STATUS_ACK : 0;
+		/* FIXME Wrong Rate 
 		tx_status->control.tx_rate =
-				iwl4965_hw_get_rate_n_flags(tx_resp->rate_n_flags);
+				iwl4965_hw_get_rate_n_flags(tx_resp->rate_n_flags); */
 		/* FIXME: code repetition end */
 
 		IWL_DEBUG_TX_REPLY("1 Frame 0x%x failure :%d\n",
@@ -5770,22 +5772,20 @@ static int iwl4965_init_geos(struct iwl4965_priv *priv)
 	}
 
 	/* 5.2GHz channels start after the 2.4GHz channels */
-#ifdef CONFIG_IWL4965_HT
-	iwl4965_init_ht_hw_capab(&modes[A].ht_info, MODE_IEEE80211A);
-#endif
-#ifdef CONFIG_IWL4965_HT
-	iwl4965_init_ht_hw_capab(&modes[G].ht_info, MODE_IEEE80211G);
-#endif
 	band = &priv->bands[IEEE80211_BAND_5GHZ];
 	band->channels = &channels[ARRAY_SIZE(iwl4965_eeprom_band_1)];
 	band->bitrates = &rates[4];
 	band->n_bitrates = 8;	/* just OFDM */
 
+	iwl4965_init_ht_hw_capab(&band->ht_info, IEEE80211_BAND_5GHZ);
+
 	band = &priv->bands[IEEE80211_BAND_2GHZ];
 	band->channels = channels;
 	band->bitrates = rates;
 	band->n_bitrates = 12;	/* OFDM & CCK */
 
+	iwl4965_init_ht_hw_capab(&band->ht_info, IEEE80211_BAND_2GHZ);
+
 	priv->ieee_channels = channels;
 	priv->ieee_rates = rates;
 
@@ -6852,8 +6852,9 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 	int rc = 0;
 	struct iwl4965_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
-	u8 direct_mask;
+	u16 cmd_len;
 	enum ieee80211_band band;
+	u8 direct_mask;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -6962,18 +6963,10 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 	} else
 		direct_mask = 0;
 
-	/* We don't build a direct scan probe request; the uCode will do
-	 * that based on the direct_mask added to each channel entry */
-	scan->tx_cmd.len = cpu_to_le16(
-		iwl4965_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
-			IWL_MAX_SCAN_SIZE - sizeof(*scan), 0));
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
-	/* flags + rate selection */
-
-	scan->tx_cmd.tx_flags |= cpu_to_le32(0x200);
 
 	switch (priv->scan_bands) {
 	case 2:
@@ -6999,6 +6992,13 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 		goto done;
 	}
 
+	/* We don't build a direct scan probe request; the uCode will do
+	 * that based on the direct_mask added to each channel entry */
+	cmd_len = iwl4965_fill_probe_req(priv, band,
+					(struct ieee80211_mgmt *)scan->data,
+					IWL_MAX_SCAN_SIZE - sizeof(*scan), 0);
+
+	scan->tx_cmd.len = cpu_to_le16(cmd_len);
 	/* select Rx chains */
 
 	/* Force use of chains B and C (0x6) for scan Rx.
@@ -7460,10 +7460,10 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	}
 
 #ifdef CONFIG_IWL4965_HT
-	/* if we are switching fron ht to 2.4 clear flags
+	/* if we are switching from ht to 2.4 clear flags
 	 * from any ht related info since 2.4 does not
 	 * support ht */
-	if ((le16_to_cpu(priv->staging_rxon.channel) != conf->channel)
+	if ((le16_to_cpu(priv->staging_rxon.channel) != conf->channel->hw_value)
 #ifdef IEEE80211_CONF_CHANNEL_SWITCH
 	    && !(conf->flags & IEEE80211_CONF_CHANNEL_SWITCH)
 #endif
@@ -8180,27 +8180,6 @@ static int iwl4965_mac_conf_ht(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void iwl4965_set_ht_capab(struct ieee80211_hw *hw,
-			struct ieee80211_ht_cap *ht_cap,
-			u8 use_current_config)
-{
-	struct ieee80211_conf *conf = &hw->conf;
-
-	if (use_current_config) {
-		ht_cap->cap_info = cpu_to_le16(conf->ht_conf.cap);
-		memcpy(ht_cap->supp_mcs_set,
-				conf->ht_conf.supp_mcs_set, 16);
-	} else {
-		ht_cap->cap_info = cpu_to_le16(mode->ht_info.cap);
-		memcpy(ht_cap->supp_mcs_set,
-				mode->ht_info.supp_mcs_set, 16);
-	}
-	ht_cap->ampdu_params_info =
-		(mode->ht_info.ampdu_factor & IEEE80211_HT_CAP_AMPDU_FACTOR) |
-		((mode->ht_info.ampdu_density << 2) &
-					IEEE80211_HT_CAP_AMPDU_DENSITY);
-}
-
 #endif /*CONFIG_IWL4965_HT*/
 
 /*****************************************************************************
-- 
1.5.2.2

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

