Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17575 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab0FFG4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/23] iwlwifi: support channel switch offload in driver
Date: Sat,  5 Jun 2010 23:56:25 -0700
Message-Id: <1275807398-18184-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Support channel switch in driver as a separated mac80211 callback
function instead of part of mac_config callback; by moving to this
approach, uCode can have more control of channel switch timing.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   52 ++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   52 ++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   53 ++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   95 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c |   48 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-core.h |    8 ++-
 6 files changed, 257 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index fe7aa73..1e4f1bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1445,7 +1445,8 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
 	return ret;
 }
 
-static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
+static int iwl4965_hw_channel_switch(struct iwl_priv *priv,
+				     struct ieee80211_channel_switch *ch_switch)
 {
 	int rc;
 	u8 band = 0;
@@ -1453,11 +1454,14 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 	u8 ctrl_chan_high = 0;
 	struct iwl4965_channel_switch_cmd cmd;
 	const struct iwl_channel_info *ch_info;
-
+	u32 switch_time_in_usec, ucode_switch_time;
+	u16 ch;
+	u32 tsf_low;
+	u8 switch_count;
+	u16 beacon_interval = le16_to_cpu(priv->rxon_timing.beacon_interval);
+	struct ieee80211_vif *vif = priv->vif;
 	band = priv->band == IEEE80211_BAND_2GHZ;
 
-	ch_info = iwl_get_channel_info(priv, priv->band, channel);
-
 	is_ht40 = is_ht40_channel(priv->staging_rxon.flags);
 
 	if (is_ht40 &&
@@ -1466,26 +1470,56 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 
 	cmd.band = band;
 	cmd.expect_beacon = 0;
-	cmd.channel = cpu_to_le16(channel);
+	ch = ieee80211_frequency_to_channel(ch_switch->channel->center_freq);
+	cmd.channel = cpu_to_le16(ch);
 	cmd.rxon_flags = priv->staging_rxon.flags;
 	cmd.rxon_filter_flags = priv->staging_rxon.filter_flags;
-	cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
+	switch_count = ch_switch->count;
+	tsf_low = ch_switch->timestamp & 0x0ffffffff;
+	/*
+	 * calculate the ucode channel switch time
+	 * adding TSF as one of the factor for when to switch
+	 */
+	if ((priv->ucode_beacon_time > tsf_low) && beacon_interval) {
+		if (switch_count > ((priv->ucode_beacon_time - tsf_low) /
+		    beacon_interval)) {
+			switch_count -= (priv->ucode_beacon_time -
+				tsf_low) / beacon_interval;
+		} else
+			switch_count = 0;
+	}
+	if (switch_count <= 1)
+		cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
+	else {
+		switch_time_in_usec =
+			vif->bss_conf.beacon_int * switch_count * TIME_UNIT;
+		ucode_switch_time = iwl_usecs_to_beacons(priv,
+							 switch_time_in_usec,
+							 beacon_interval);
+		cmd.switch_time = iwl_add_beacon_time(priv,
+						      priv->ucode_beacon_time,
+						      ucode_switch_time,
+						      beacon_interval);
+	}
+	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
+		      cmd.switch_time);
+	ch_info = iwl_get_channel_info(priv, priv->band, ch);
 	if (ch_info)
 		cmd.expect_beacon = is_channel_radar(ch_info);
 	else {
 		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
-			priv->active_rxon.channel, channel);
+			priv->active_rxon.channel, ch);
 		return -EFAULT;
 	}
 
-	rc = iwl4965_fill_txpower_tbl(priv, band, channel, is_ht40,
+	rc = iwl4965_fill_txpower_tbl(priv, band, ch, is_ht40,
 				      ctrl_chan_high, &cmd.tx_power);
 	if (rc) {
 		IWL_DEBUG_11H(priv, "error:%d  fill txpower_tbl\n", rc);
 		return rc;
 	}
 
-	priv->switch_rxon.channel = cpu_to_le16(channel);
+	priv->switch_rxon.channel = cmd.channel;
 	priv->switch_rxon.switch_in_progress = true;
 
 	return iwl_send_cmd_pdu(priv, REPLY_CHANNEL_SWITCH, sizeof(cmd), &cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c320d41..19bb5b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -271,10 +271,17 @@ static void iwl5150_temperature(struct iwl_priv *priv)
 	iwl_tt_handler(priv);
 }
 
-static int iwl5000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
+static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
+				     struct ieee80211_channel_switch *ch_switch)
 {
 	struct iwl5000_channel_switch_cmd cmd;
 	const struct iwl_channel_info *ch_info;
+	u32 switch_time_in_usec, ucode_switch_time;
+	u16 ch;
+	u32 tsf_low;
+	u8 switch_count;
+	u16 beacon_interval = le16_to_cpu(priv->rxon_timing.beacon_interval);
+	struct ieee80211_vif *vif = priv->vif;
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
 		.len = sizeof(cmd),
@@ -282,22 +289,51 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 		.data = &cmd,
 	};
 
-	IWL_DEBUG_11H(priv, "channel switch from %d to %d\n",
-		priv->active_rxon.channel, channel);
 	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
-	cmd.channel = cpu_to_le16(channel);
+	ch = ieee80211_frequency_to_channel(ch_switch->channel->center_freq);
+	IWL_DEBUG_11H(priv, "channel switch from %d to %d\n",
+		priv->active_rxon.channel, ch);
+	cmd.channel = cpu_to_le16(ch);
 	cmd.rxon_flags = priv->staging_rxon.flags;
 	cmd.rxon_filter_flags = priv->staging_rxon.filter_flags;
-	cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
-	ch_info = iwl_get_channel_info(priv, priv->band, channel);
+	switch_count = ch_switch->count;
+	tsf_low = ch_switch->timestamp & 0x0ffffffff;
+	/*
+	 * calculate the ucode channel switch time
+	 * adding TSF as one of the factor for when to switch
+	 */
+	if ((priv->ucode_beacon_time > tsf_low) && beacon_interval) {
+		if (switch_count > ((priv->ucode_beacon_time - tsf_low) /
+		    beacon_interval)) {
+			switch_count -= (priv->ucode_beacon_time -
+				tsf_low) / beacon_interval;
+		} else
+			switch_count = 0;
+	}
+	if (switch_count <= 1)
+		cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
+	else {
+		switch_time_in_usec =
+			vif->bss_conf.beacon_int * switch_count * TIME_UNIT;
+		ucode_switch_time = iwl_usecs_to_beacons(priv,
+							 switch_time_in_usec,
+							 beacon_interval);
+		cmd.switch_time = iwl_add_beacon_time(priv,
+						      priv->ucode_beacon_time,
+						      ucode_switch_time,
+						      beacon_interval);
+	}
+	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
+		      cmd.switch_time);
+	ch_info = iwl_get_channel_info(priv, priv->band, ch);
 	if (ch_info)
 		cmd.expect_beacon = is_channel_radar(ch_info);
 	else {
 		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
-			priv->active_rxon.channel, channel);
+			priv->active_rxon.channel, ch);
 		return -EFAULT;
 	}
-	priv->switch_rxon.channel = cpu_to_le16(channel);
+	priv->switch_rxon.channel = cmd.channel;
 	priv->switch_rxon.switch_in_progress = true;
 
 	return iwl_send_cmd_sync(priv, &hcmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 5f6dbd9..0775145 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -239,10 +239,17 @@ static int iwl6050_hw_set_hw_params(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl6000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
+static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
+				     struct ieee80211_channel_switch *ch_switch)
 {
 	struct iwl6000_channel_switch_cmd cmd;
 	const struct iwl_channel_info *ch_info;
+	u32 switch_time_in_usec, ucode_switch_time;
+	u16 ch;
+	u32 tsf_low;
+	u8 switch_count;
+	u16 beacon_interval = le16_to_cpu(priv->rxon_timing.beacon_interval);
+	struct ieee80211_vif *vif = priv->vif;
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
 		.len = sizeof(cmd),
@@ -250,23 +257,51 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 		.data = &cmd,
 	};
 
-	IWL_DEBUG_11H(priv, "channel switch from %d to %d\n",
-		priv->active_rxon.channel, channel);
-
 	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
-	cmd.channel = cpu_to_le16(channel);
+	ch = ieee80211_frequency_to_channel(ch_switch->channel->center_freq);
+	IWL_DEBUG_11H(priv, "channel switch from %u to %u\n",
+		      priv->active_rxon.channel, ch);
+	cmd.channel = cpu_to_le16(ch);
 	cmd.rxon_flags = priv->staging_rxon.flags;
 	cmd.rxon_filter_flags = priv->staging_rxon.filter_flags;
-	cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
-	ch_info = iwl_get_channel_info(priv, priv->band, channel);
+	switch_count = ch_switch->count;
+	tsf_low = ch_switch->timestamp & 0x0ffffffff;
+	/*
+	 * calculate the ucode channel switch time
+	 * adding TSF as one of the factor for when to switch
+	 */
+	if ((priv->ucode_beacon_time > tsf_low) && beacon_interval) {
+		if (switch_count > ((priv->ucode_beacon_time - tsf_low) /
+		    beacon_interval)) {
+			switch_count -= (priv->ucode_beacon_time -
+				tsf_low) / beacon_interval;
+		} else
+			switch_count = 0;
+	}
+	if (switch_count <= 1)
+		cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
+	else {
+		switch_time_in_usec =
+			vif->bss_conf.beacon_int * switch_count * TIME_UNIT;
+		ucode_switch_time = iwl_usecs_to_beacons(priv,
+							 switch_time_in_usec,
+							 beacon_interval);
+		cmd.switch_time = iwl_add_beacon_time(priv,
+						      priv->ucode_beacon_time,
+						      ucode_switch_time,
+						      beacon_interval);
+	}
+	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
+		      cmd.switch_time);
+	ch_info = iwl_get_channel_info(priv, priv->band, ch);
 	if (ch_info)
 		cmd.expect_beacon = is_channel_radar(ch_info);
 	else {
 		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
-			priv->active_rxon.channel, channel);
+			priv->active_rxon.channel, ch);
 		return -EFAULT;
 	}
-	priv->switch_rxon.channel = cpu_to_le16(channel);
+	priv->switch_rxon.channel = cmd.channel;
 	priv->switch_rxon.switch_in_progress = true;
 
 	return iwl_send_cmd_sync(priv, &hcmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 021b014..9c85e1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -120,7 +120,7 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 	    (priv->switch_rxon.channel != priv->staging_rxon.channel)) {
 		IWL_DEBUG_11H(priv, "abort channel switch on %d\n",
 		      le16_to_cpu(priv->switch_rxon.channel));
-		priv->switch_rxon.switch_in_progress = false;
+		iwl_chswitch_done(priv, false);
 	}
 
 	/* If we don't need to send a full RXON, we can use
@@ -3325,6 +3325,98 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static void iwl_mac_channel_switch(struct ieee80211_hw *hw,
+				   struct ieee80211_channel_switch *ch_switch)
+{
+	struct iwl_priv *priv = hw->priv;
+	const struct iwl_channel_info *ch_info;
+	struct ieee80211_conf *conf = &hw->conf;
+	struct iwl_ht_config *ht_conf = &priv->current_ht_config;
+	u16 ch;
+	unsigned long flags = 0;
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	if (iwl_is_rfkill(priv))
+		goto out_exit;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    test_bit(STATUS_SCANNING, &priv->status))
+		goto out_exit;
+
+	if (!iwl_is_associated(priv))
+		goto out_exit;
+
+	/* channel switch in progress */
+	if (priv->switch_rxon.switch_in_progress == true)
+		goto out_exit;
+
+	mutex_lock(&priv->mutex);
+	if (priv->cfg->ops->lib->set_channel_switch) {
+
+		ch = ieee80211_frequency_to_channel(
+			ch_switch->channel->center_freq);
+		if (le16_to_cpu(priv->active_rxon.channel) != ch) {
+			ch_info = iwl_get_channel_info(priv,
+						       conf->channel->band,
+						       ch);
+			if (!is_channel_valid(ch_info)) {
+				IWL_DEBUG_MAC80211(priv, "invalid channel\n");
+				goto out;
+			}
+			spin_lock_irqsave(&priv->lock, flags);
+
+			priv->current_ht_config.smps = conf->smps_mode;
+
+			/* Configure HT40 channels */
+			ht_conf->is_ht = conf_is_ht(conf);
+			if (ht_conf->is_ht) {
+				if (conf_is_ht40_minus(conf)) {
+					ht_conf->extension_chan_offset =
+						IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+					ht_conf->is_40mhz = true;
+				} else if (conf_is_ht40_plus(conf)) {
+					ht_conf->extension_chan_offset =
+						IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+					ht_conf->is_40mhz = true;
+				} else {
+					ht_conf->extension_chan_offset =
+						IEEE80211_HT_PARAM_CHA_SEC_NONE;
+					ht_conf->is_40mhz = false;
+				}
+			} else
+				ht_conf->is_40mhz = false;
+
+			/* if we are switching from ht to 2.4 clear flags
+			 * from any ht related info since 2.4 does not
+			 * support ht */
+			if ((le16_to_cpu(priv->staging_rxon.channel) != ch))
+				priv->staging_rxon.flags = 0;
+
+			iwl_set_rxon_channel(priv, conf->channel);
+			iwl_set_rxon_ht(priv, ht_conf);
+			iwl_set_flags_for_band(priv, conf->channel->band,
+					       priv->vif);
+			spin_unlock_irqrestore(&priv->lock, flags);
+
+			iwl_set_rate(priv);
+			/*
+			 * at this point, staging_rxon has the
+			 * configuration for channel switch
+			 */
+			if (priv->cfg->ops->lib->set_channel_switch(priv,
+								    ch_switch))
+				priv->switch_rxon.switch_in_progress = false;
+		}
+	}
+out:
+	mutex_unlock(&priv->mutex);
+out_exit:
+	if (!priv->switch_rxon.switch_in_progress)
+		ieee80211_chswitch_done(priv->vif, false);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+}
+
 /*****************************************************************************
  *
  * sysfs attributes
@@ -3646,6 +3738,7 @@ static struct ieee80211_ops iwl_hw_ops = {
 	.sta_notify = iwl_mac_sta_notify,
 	.sta_add = iwlagn_mac_sta_add,
 	.sta_remove = iwl_mac_sta_remove,
+	.channel_switch = iwl_mac_channel_switch,
 };
 
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b05b813..718ffa3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -893,9 +893,9 @@ int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch)
 }
 EXPORT_SYMBOL(iwl_set_rxon_channel);
 
-static void iwl_set_flags_for_band(struct iwl_priv *priv,
-				   enum ieee80211_band band,
-				   struct ieee80211_vif *vif)
+void iwl_set_flags_for_band(struct iwl_priv *priv,
+			    enum ieee80211_band band,
+			    struct ieee80211_vif *vif)
 {
 	if (band == IEEE80211_BAND_5GHZ) {
 		priv->staging_rxon.flags &=
@@ -914,6 +914,7 @@ static void iwl_set_flags_for_band(struct iwl_priv *priv,
 		priv->staging_rxon.flags &= ~RXON_FLG_CCK_MSK;
 	}
 }
+EXPORT_SYMBOL(iwl_set_flags_for_band);
 
 /*
  * initialize rxon structure with default values from eeprom
@@ -989,7 +990,7 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_connection_init_rx_config);
 
-static void iwl_set_rate(struct iwl_priv *priv)
+void iwl_set_rate(struct iwl_priv *priv)
 {
 	const struct ieee80211_supported_band *hw = NULL;
 	struct ieee80211_rate *rate;
@@ -1017,6 +1018,21 @@ static void iwl_set_rate(struct iwl_priv *priv)
 	priv->staging_rxon.ofdm_basic_rates =
 	   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
 }
+EXPORT_SYMBOL(iwl_set_rate);
+
+void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	if (priv->switch_rxon.switch_in_progress) {
+		ieee80211_chswitch_done(priv->vif, is_success);
+		mutex_lock(&priv->mutex);
+		priv->switch_rxon.switch_in_progress = false;
+		mutex_unlock(&priv->mutex);
+	}
+}
+EXPORT_SYMBOL(iwl_chswitch_done);
 
 void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
@@ -1031,11 +1047,12 @@ void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 			priv->staging_rxon.channel = csa->channel;
 			IWL_DEBUG_11H(priv, "CSA notif: channel %d\n",
 			      le16_to_cpu(csa->channel));
-		} else
+			iwl_chswitch_done(priv, true);
+		} else {
 			IWL_ERR(priv, "CSA notif (fail) : channel %d\n",
 			      le16_to_cpu(csa->channel));
-
-		priv->switch_rxon.switch_in_progress = false;
+			iwl_chswitch_done(priv, false);
+		}
 	}
 }
 EXPORT_SYMBOL(iwl_rx_csa);
@@ -2044,22 +2061,7 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 		iwl_set_flags_for_band(priv, conf->channel->band, priv->vif);
 		spin_unlock_irqrestore(&priv->lock, flags);
-		if (iwl_is_associated(priv) &&
-		    (le16_to_cpu(priv->active_rxon.channel) != ch) &&
-		    priv->cfg->ops->lib->set_channel_switch) {
-			iwl_set_rate(priv);
-			/*
-			 * at this point, staging_rxon has the
-			 * configuration for channel switch
-			 */
-			ret = priv->cfg->ops->lib->set_channel_switch(priv,
-				ch);
-			if (!ret) {
-				iwl_print_rx_config_cmd(priv);
-				goto out;
-			}
-			priv->switch_rxon.switch_in_progress = false;
-		}
+
  set_ch_out:
 		/* The list of supported rates and rate mask can be different
 		 * for each band; since the band may have changed, reset
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 48d96fd..9fe08ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -175,7 +175,8 @@ struct iwl_lib_ops {
 	void (*dump_nic_error_log)(struct iwl_priv *priv);
 	void (*dump_csr)(struct iwl_priv *priv);
 	int (*dump_fh)(struct iwl_priv *priv, char **buf, bool display);
-	int (*set_channel_switch)(struct iwl_priv *priv, u16 channel);
+	int (*set_channel_switch)(struct iwl_priv *priv,
+				  struct ieee80211_channel_switch *ch_switch);
 	/* power management */
 	struct iwl_apm_ops apm_ops;
 
@@ -345,11 +346,15 @@ int iwl_check_rxon_cmd(struct iwl_priv *priv);
 int iwl_full_rxon_required(struct iwl_priv *priv);
 void iwl_set_rxon_chain(struct iwl_priv *priv);
 int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch);
+void iwl_set_flags_for_band(struct iwl_priv *priv,
+			    enum ieee80211_band band,
+			    struct ieee80211_vif *vif);
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf);
 u8 iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			 struct ieee80211_sta_ht_cap *sta_ht_inf);
 void iwl_connection_init_rx_config(struct iwl_priv *priv,
 				   struct ieee80211_vif *vif);
+void iwl_set_rate(struct iwl_priv *priv);
 int iwl_set_decrypted_flag(struct iwl_priv *priv,
 			   struct ieee80211_hdr *hdr,
 			   u32 decrypt_res,
@@ -461,6 +466,7 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb);
 void iwl_reply_statistics(struct iwl_priv *priv,
 			  struct iwl_rx_mem_buffer *rxb);
+void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
 void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 
 /* TX helpers */
-- 
1.7.0.4

