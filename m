Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51935 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbZDHSVF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:05 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/18] iwl3945: use iwl_bss_info_changed
Date: Wed,  8 Apr 2009 11:26:35 -0700
Message-Id: <1239215212-1657-2-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202115_462885_097C9430)
In-Reply-To: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
References: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 can use iwl_bss_info_changed.
A new lib op is created for post_assoicate to distinguish between
3945 and iwlwifi's post_associate operations.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   50 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  138 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |  136 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    7 ++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  116 +---------------------
 8 files changed, 204 insertions(+), 247 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 2399328..519e892 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1964,6 +1964,50 @@ int iwl3945_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 	return 0;
 }
 
+static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
+{
+	int rc = 0;
+	struct iwl_rx_packet *res = NULL;
+	struct iwl3945_rxon_assoc_cmd rxon_assoc;
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_RXON_ASSOC,
+		.len = sizeof(rxon_assoc),
+		.meta.flags = CMD_WANT_SKB,
+		.data = &rxon_assoc,
+	};
+	const struct iwl_rxon_cmd *rxon1 = &priv->staging_rxon;
+	const struct iwl_rxon_cmd *rxon2 = &priv->active_rxon;
+
+	if ((rxon1->flags == rxon2->flags) &&
+	    (rxon1->filter_flags == rxon2->filter_flags) &&
+	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
+	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
+		IWL_DEBUG_INFO(priv, "Using current RXON_ASSOC.  Not resending.\n");
+		return 0;
+	}
+
+	rxon_assoc.flags = priv->staging_rxon.flags;
+	rxon_assoc.filter_flags = priv->staging_rxon.filter_flags;
+	rxon_assoc.ofdm_basic_rates = priv->staging_rxon.ofdm_basic_rates;
+	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
+	rxon_assoc.reserved = 0;
+
+	rc = iwl_send_cmd_sync(priv, &cmd);
+	if (rc)
+		return rc;
+
+	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
+		IWL_ERR(priv, "Bad return from REPLY_RXON_ASSOC command\n");
+		rc = -EIO;
+	}
+
+	priv->alloc_rxb_skb--;
+	dev_kfree_skb_any(cmd.meta.u.skb);
+
+	return rc;
+}
+
 /* will add 3945 channel switch cmd handling later */
 int iwl3945_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 {
@@ -2729,6 +2773,10 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 	return 0;
 }
 
+static struct iwl_hcmd_ops iwl3945_hcmd = {
+	.rxon_assoc = iwl3945_send_rxon_assoc,
+};
+
 static struct iwl_lib_ops iwl3945_lib = {
 	.txq_attach_buf_to_tfd = iwl3945_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl3945_hw_txq_free_tfd,
@@ -2758,6 +2806,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 	},
 	.send_tx_power	= iwl3945_send_tx_power,
 	.is_valid_rtc_data_addr = iwl3945_hw_valid_rtc_data_addr,
+	.post_associate = iwl3945_post_associate,
 };
 
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
@@ -2767,6 +2816,7 @@ static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 
 static struct iwl_ops iwl3945_ops = {
 	.lib = &iwl3945_lib,
+	.hcmd = &iwl3945_hcmd,
 	.utils = &iwl3945_hcmd_utils,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 29bc0d2..13b191f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -276,7 +276,7 @@ extern void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 				 struct iwl_rx_mem_buffer *rxb);
 extern void iwl3945_disable_events(struct iwl_priv *priv);
 extern int iwl4965_get_temperature(const struct iwl_priv *priv);
-
+extern void iwl3945_post_associate(struct iwl_priv *priv);
 /**
  * iwl3945_hw_find_station - Find station id for a given BSSID
  * @bssid: MAC address of station ID to find
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 847a622..37544af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2324,6 +2324,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.send_tx_power	= iwl4965_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.temperature = iwl4965_temperature_calib,
+	.post_associate = iwl_post_associate,
 };
 
 static struct iwl_ops iwl4965_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e5ca251..837dbad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1527,6 +1527,7 @@ struct iwl_lib_ops iwl5000_lib = {
 		.calib_version	= iwl5000_eeprom_calib_version,
 		.query_addr = iwl5000_eeprom_query_addr,
 	},
+	.post_associate = iwl_post_associate,
 };
 
 struct iwl_ops iwl5000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 51f6a01..2492ec0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -531,76 +531,6 @@ int iwl_hw_tx_queue_init(struct iwl_priv *priv,
  *
  ******************************************************************************/
 
-static void iwl_ht_conf(struct iwl_priv *priv,
-			    struct ieee80211_bss_conf *bss_conf)
-{
-	struct ieee80211_sta_ht_cap *ht_conf;
-	struct iwl_ht_info *iwl_conf = &priv->current_ht_config;
-	struct ieee80211_sta *sta;
-
-	IWL_DEBUG_MAC80211(priv, "enter: \n");
-
-	if (!iwl_conf->is_ht)
-		return;
-
-
-	/*
-	 * It is totally wrong to base global information on something
-	 * that is valid only when associated, alas, this driver works
-	 * that way and I don't know how to fix it.
-	 */
-
-	rcu_read_lock();
-	sta = ieee80211_find_sta(priv->hw, priv->bssid);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-	ht_conf = &sta->ht_cap;
-
-	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_20)
-		iwl_conf->sgf |= HT_SHORT_GI_20MHZ;
-	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_40)
-		iwl_conf->sgf |= HT_SHORT_GI_40MHZ;
-
-	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
-	iwl_conf->max_amsdu_size =
-		!!(ht_conf->cap & IEEE80211_HT_CAP_MAX_AMSDU);
-
-	iwl_conf->supported_chan_width =
-		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
-
-	/*
-	 * XXX: The HT configuration needs to be moved into iwl_mac_config()
-	 *	to be done there correctly.
-	 */
-
-	iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
-	if (conf_is_ht40_minus(&priv->hw->conf))
-		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
-	else if (conf_is_ht40_plus(&priv->hw->conf))
-		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
-
-	/* If no above or below channel supplied disable FAT channel */
-	if (iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_ABOVE &&
-	    iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_BELOW)
-		iwl_conf->supported_chan_width = 0;
-
-	iwl_conf->sm_ps = (u8)((ht_conf->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
-
-	memcpy(&iwl_conf->mcs, &ht_conf->mcs, 16);
-
-	iwl_conf->tx_chan_width = iwl_conf->supported_chan_width != 0;
-	iwl_conf->ht_protection =
-		bss_conf->ht.operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
-	iwl_conf->non_GF_STA_present =
-		!!(bss_conf->ht.operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
-
-	rcu_read_unlock();
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-}
-
 #define MAX_UCODE_BEACON_INTERVAL	4096
 
 static u16 iwl_adjust_beacon_interval(u16 beacon_val)
@@ -1911,7 +1841,7 @@ static void iwl_bg_rx_replenish(struct work_struct *data)
 
 #define IWL_DELAY_NEXT_SCAN (HZ*2)
 
-static void iwl_post_associate(struct iwl_priv *priv)
+void iwl_post_associate(struct iwl_priv *priv)
 {
 	struct ieee80211_conf *conf = NULL;
 	int ret = 0;
@@ -2482,70 +2412,6 @@ static void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 
 }
 
-#define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
-static void iwl_bss_info_changed(struct ieee80211_hw *hw,
-				     struct ieee80211_vif *vif,
-				     struct ieee80211_bss_conf *bss_conf,
-				     u32 changes)
-{
-	struct iwl_priv *priv = hw->priv;
-
-	IWL_DEBUG_MAC80211(priv, "changes = 0x%X\n", changes);
-
-	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
-		IWL_DEBUG_MAC80211(priv, "ERP_PREAMBLE %d\n",
-				   bss_conf->use_short_preamble);
-		if (bss_conf->use_short_preamble)
-			priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
-		else
-			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
-	}
-
-	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
-		IWL_DEBUG_MAC80211(priv, "ERP_CTS %d\n", bss_conf->use_cts_prot);
-		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
-			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
-		else
-			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
-	}
-
-	if (changes & BSS_CHANGED_HT) {
-		iwl_ht_conf(priv, bss_conf);
-		iwl_set_rxon_chain(priv);
-	}
-
-	if (changes & BSS_CHANGED_ASSOC) {
-		IWL_DEBUG_MAC80211(priv, "ASSOC %d\n", bss_conf->assoc);
-		/* This should never happen as this function should
-		 * never be called from interrupt context. */
-		if (WARN_ON_ONCE(in_interrupt()))
-			return;
-		if (bss_conf->assoc) {
-			priv->assoc_id = bss_conf->aid;
-			priv->beacon_int = bss_conf->beacon_int;
-			priv->power_data.dtim_period = bss_conf->dtim_period;
-			priv->timestamp = bss_conf->timestamp;
-			priv->assoc_capability = bss_conf->assoc_capability;
-
-			/* we have just associated, don't start scan too early
-			 * leave time for EAPOL exchange to complete
-			 */
-			priv->next_scan_jiffies = jiffies +
-					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
-			mutex_lock(&priv->mutex);
-			iwl_post_associate(priv);
-			mutex_unlock(&priv->mutex);
-		} else {
-			priv->assoc_id = 0;
-			IWL_DEBUG_MAC80211(priv, "DISASSOC %d\n", bss_conf->assoc);
-		}
-	} else if (changes && iwl_is_associated(priv) && priv->assoc_id) {
-			IWL_DEBUG_MAC80211(priv, "Associated Changes %d\n", changes);
-			iwl_send_rxon_assoc(priv);
-	}
-
-}
-
 static void iwl_mac_update_tkip_key(struct ieee80211_hw *hw,
 			struct ieee80211_key_conf *keyconf, const u8 *addr,
 			u32 iv32, u16 *phase1key)
@@ -2825,7 +2691,7 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	iwl_reset_qos(priv);
 
-	iwl_post_associate(priv);
+	priv->cfg->ops->lib->post_associate(priv);
 
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index cecebe3..a351a38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2156,6 +2156,142 @@ int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	return 0;
 }
 EXPORT_SYMBOL(iwl_mac_conf_tx);
+
+static void iwl_ht_conf(struct iwl_priv *priv,
+			    struct ieee80211_bss_conf *bss_conf)
+{
+	struct ieee80211_sta_ht_cap *ht_conf;
+	struct iwl_ht_info *iwl_conf = &priv->current_ht_config;
+	struct ieee80211_sta *sta;
+
+	IWL_DEBUG_MAC80211(priv, "enter: \n");
+
+	if (!iwl_conf->is_ht)
+		return;
+
+
+	/*
+	 * It is totally wrong to base global information on something
+	 * that is valid only when associated, alas, this driver works
+	 * that way and I don't know how to fix it.
+	 */
+
+	rcu_read_lock();
+	sta = ieee80211_find_sta(priv->hw, priv->bssid);
+	if (!sta) {
+		rcu_read_unlock();
+		return;
+	}
+	ht_conf = &sta->ht_cap;
+
+	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_20)
+		iwl_conf->sgf |= HT_SHORT_GI_20MHZ;
+	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_40)
+		iwl_conf->sgf |= HT_SHORT_GI_40MHZ;
+
+	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
+	iwl_conf->max_amsdu_size =
+		!!(ht_conf->cap & IEEE80211_HT_CAP_MAX_AMSDU);
+
+	iwl_conf->supported_chan_width =
+		!!(ht_conf->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
+
+	/*
+	 * XXX: The HT configuration needs to be moved into iwl_mac_config()
+	 *	to be done there correctly.
+	 */
+
+	iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
+	if (conf_is_ht40_minus(&priv->hw->conf))
+		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_BELOW;
+	else if (conf_is_ht40_plus(&priv->hw->conf))
+		iwl_conf->extension_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
+
+	/* If no above or below channel supplied disable FAT channel */
+	if (iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_ABOVE &&
+	    iwl_conf->extension_chan_offset != IEEE80211_HT_PARAM_CHA_SEC_BELOW)
+		iwl_conf->supported_chan_width = 0;
+
+	iwl_conf->sm_ps = (u8)((ht_conf->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
+
+	memcpy(&iwl_conf->mcs, &ht_conf->mcs, 16);
+
+	iwl_conf->tx_chan_width = iwl_conf->supported_chan_width != 0;
+	iwl_conf->ht_protection =
+		bss_conf->ht.operation_mode & IEEE80211_HT_OP_MODE_PROTECTION;
+	iwl_conf->non_GF_STA_present =
+		!!(bss_conf->ht.operation_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+
+	rcu_read_unlock();
+
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+}
+
+#define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
+void iwl_bss_info_changed(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_bss_conf *bss_conf,
+				     u32 changes)
+{
+	struct iwl_priv *priv = hw->priv;
+
+	IWL_DEBUG_MAC80211(priv, "changes = 0x%X\n", changes);
+
+	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
+		IWL_DEBUG_MAC80211(priv, "ERP_PREAMBLE %d\n",
+				   bss_conf->use_short_preamble);
+		if (bss_conf->use_short_preamble)
+			priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+		else
+			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+	}
+
+	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
+		IWL_DEBUG_MAC80211(priv, "ERP_CTS %d\n", bss_conf->use_cts_prot);
+		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
+			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
+		else
+			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
+	}
+
+	if (changes & BSS_CHANGED_HT) {
+		iwl_ht_conf(priv, bss_conf);
+		iwl_set_rxon_chain(priv);
+	}
+
+	if (changes & BSS_CHANGED_ASSOC) {
+		IWL_DEBUG_MAC80211(priv, "ASSOC %d\n", bss_conf->assoc);
+		/* This should never happen as this function should
+		 * never be called from interrupt context. */
+		if (WARN_ON_ONCE(in_interrupt()))
+			return;
+		if (bss_conf->assoc) {
+			priv->assoc_id = bss_conf->aid;
+			priv->beacon_int = bss_conf->beacon_int;
+			priv->power_data.dtim_period = bss_conf->dtim_period;
+			priv->timestamp = bss_conf->timestamp;
+			priv->assoc_capability = bss_conf->assoc_capability;
+
+			/* we have just associated, don't start scan too early
+			 * leave time for EAPOL exchange to complete
+			 */
+			priv->next_scan_jiffies = jiffies +
+					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
+			mutex_lock(&priv->mutex);
+			priv->cfg->ops->lib->post_associate(priv);
+			mutex_unlock(&priv->mutex);
+		} else {
+			priv->assoc_id = 0;
+			IWL_DEBUG_MAC80211(priv, "DISASSOC %d\n", bss_conf->assoc);
+		}
+	} else if (changes && iwl_is_associated(priv) && priv->assoc_id) {
+			IWL_DEBUG_MAC80211(priv, "Associated Changes %d\n", changes);
+			iwl_send_rxon_assoc(priv);
+	}
+
+}
+EXPORT_SYMBOL(iwl_bss_info_changed);
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d56edcd..4ad8465 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -149,6 +149,8 @@ struct iwl_lib_ops {
 	int (*send_tx_power) (struct iwl_priv *priv);
 	void (*update_chain_flags)(struct iwl_priv *priv);
 	void (*temperature) (struct iwl_priv *priv);
+	void (*post_associate) (struct iwl_priv *priv);
+
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
 };
@@ -251,6 +253,11 @@ int iwl_setup_mac(struct iwl_priv *priv);
 int iwl_set_hw_params(struct iwl_priv *priv);
 int iwl_init_drv(struct iwl_priv *priv);
 void iwl_uninit_drv(struct iwl_priv *priv);
+void iwl_post_associate(struct iwl_priv *priv);
+void iwl_bss_info_changed(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_bss_conf *bss_conf,
+				     u32 changes);
 
 /*****************************************************
  * RX handlers.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index bb3a17c..22cd171 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -233,50 +233,6 @@ u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flag
 
 }
 
-static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
-{
-	int rc = 0;
-	struct iwl_rx_packet *res = NULL;
-	struct iwl3945_rxon_assoc_cmd rxon_assoc;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_RXON_ASSOC,
-		.len = sizeof(rxon_assoc),
-		.meta.flags = CMD_WANT_SKB,
-		.data = &rxon_assoc,
-	};
-	const struct iwl_rxon_cmd *rxon1 = &priv->staging_rxon;
-	const struct iwl_rxon_cmd *rxon2 = &priv->active_rxon;
-
-	if ((rxon1->flags == rxon2->flags) &&
-	    (rxon1->filter_flags == rxon2->filter_flags) &&
-	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
-	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
-		IWL_DEBUG_INFO(priv, "Using current RXON_ASSOC.  Not resending.\n");
-		return 0;
-	}
-
-	rxon_assoc.flags = priv->staging_rxon.flags;
-	rxon_assoc.filter_flags = priv->staging_rxon.filter_flags;
-	rxon_assoc.ofdm_basic_rates = priv->staging_rxon.ofdm_basic_rates;
-	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
-	rxon_assoc.reserved = 0;
-
-	rc = iwl_send_cmd_sync(priv, &cmd);
-	if (rc)
-		return rc;
-
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(priv, "Bad return from REPLY_RXON_ASSOC command\n");
-		rc = -EIO;
-	}
-
-	priv->alloc_rxb_skb--;
-	dev_kfree_skb_any(cmd.meta.u.skb);
-
-	return rc;
-}
-
 /**
  * iwl3945_get_antenna_flags - Get antenna flags for RXON command
  * @priv: eeprom and antenna fields are used to determine antenna flags
@@ -352,7 +308,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	 * iwl3945_rxon_assoc_cmd which is used to reconfigure filter
 	 * and other flags for the current radio configuration. */
 	if (!iwl_full_rxon_required(priv)) {
-		rc = iwl3945_send_rxon_assoc(priv);
+		rc = iwl_send_rxon_assoc(priv);
 		if (rc) {
 			IWL_ERR(priv, "Error setting RXON_ASSOC "
 				  "configuration (%d).\n", rc);
@@ -3450,9 +3406,11 @@ static void iwl3945_bg_rx_replenish(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
+static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed);
+
 #define IWL_DELAY_NEXT_SCAN (HZ*2)
 
-static void iwl3945_post_associate(struct iwl_priv *priv)
+void iwl3945_post_associate(struct iwl_priv *priv)
 {
 	int rc = 0;
 	struct ieee80211_conf *conf = NULL;
@@ -3542,8 +3500,6 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
 }
 
-static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed);
-
 /*****************************************************************************
  *
  * mac80211 entry point functions
@@ -3982,66 +3938,6 @@ static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-#define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
-
-static void iwl3945_bss_info_changed(struct ieee80211_hw *hw,
-				     struct ieee80211_vif *vif,
-				     struct ieee80211_bss_conf *bss_conf,
-				     u32 changes)
-{
-	struct iwl_priv *priv = hw->priv;
-
-	IWL_DEBUG_MAC80211(priv, "changes = 0x%X\n", changes);
-
-	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
-		IWL_DEBUG_MAC80211(priv, "ERP_PREAMBLE %d\n",
-				   bss_conf->use_short_preamble);
-		if (bss_conf->use_short_preamble)
-			priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
-		else
-			priv->staging_rxon.flags &=
-				~RXON_FLG_SHORT_PREAMBLE_MSK;
-	}
-
-	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
-		IWL_DEBUG_MAC80211(priv, "ERP_CTS %d\n",
-				   bss_conf->use_cts_prot);
-		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
-			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
-		else
-			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
-	}
-
-	if (changes & BSS_CHANGED_ASSOC) {
-		IWL_DEBUG_MAC80211(priv, "ASSOC %d\n", bss_conf->assoc);
-		/* This should never happen as this function should
-		 * never be called from interrupt context. */
-		if (WARN_ON_ONCE(in_interrupt()))
-			return;
-		if (bss_conf->assoc) {
-			priv->assoc_id = bss_conf->aid;
-			priv->beacon_int = bss_conf->beacon_int;
-			priv->timestamp = bss_conf->timestamp;
-			priv->assoc_capability = bss_conf->assoc_capability;
-			priv->power_data.dtim_period = bss_conf->dtim_period;
-			priv->next_scan_jiffies = jiffies +
-					IWL_DELAY_NEXT_SCAN_AFTER_ASSOC;
-			mutex_lock(&priv->mutex);
-			iwl3945_post_associate(priv);
-			mutex_unlock(&priv->mutex);
-		} else {
-			priv->assoc_id = 0;
-			IWL_DEBUG_MAC80211(priv,
-					"DISASSOC %d\n", bss_conf->assoc);
-		}
-	} else if (changes && iwl_is_associated(priv) && priv->assoc_id) {
-			IWL_DEBUG_MAC80211(priv,
-					"Associated Changes %d\n", changes);
-			iwl3945_send_rxon_assoc(priv);
-	}
-
-}
-
 static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
@@ -4227,7 +4123,7 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 
 	iwl_reset_qos(priv);
 
-	iwl3945_post_associate(priv);
+	priv->cfg->ops->lib->post_associate(priv);
 
 
 	return 0;
@@ -4765,7 +4661,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 	.get_tx_stats = iwl3945_mac_get_tx_stats,
 	.conf_tx = iwl_mac_conf_tx,
 	.reset_tsf = iwl3945_mac_reset_tsf,
-	.bss_info_changed = iwl3945_bss_info_changed,
+	.bss_info_changed = iwl_bss_info_changed,
 	.hw_scan = iwl_mac_hw_scan
 };
 
-- 
1.5.6.3

