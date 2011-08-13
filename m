Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1HMQ57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:57:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/13] iwlagn: move context init after firmware loading
Date: Sat, 13 Aug 2011 09:18:01 -0700
Message-Id: <1313252287-22858-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_191257_330571_9D5E6B6F)
In-Reply-To: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The availability of contexts depends on the
firmware capabilities. Currently only the
presence of the second context depends on it,
but soon P2P support will also be different.
Move the context initialisation code to the
firmware-dependent setup before registering
with mac80211 to make it easier to handle.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |  181 ++++++++++++++++----------------
 1 files changed, 89 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 871d880..8819fc9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -614,6 +614,85 @@ static int iwl_alloc_fw_desc(struct iwl_priv *priv, struct fw_desc *desc,
 	return 0;
 }
 
+static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
+{
+	static const u8 iwlagn_bss_ac_to_fifo[] = {
+		IWL_TX_FIFO_VO,
+		IWL_TX_FIFO_VI,
+		IWL_TX_FIFO_BE,
+		IWL_TX_FIFO_BK,
+	};
+	static const u8 iwlagn_bss_ac_to_queue[] = {
+		0, 1, 2, 3,
+	};
+	static const u8 iwlagn_pan_ac_to_fifo[] = {
+		IWL_TX_FIFO_VO_IPAN,
+		IWL_TX_FIFO_VI_IPAN,
+		IWL_TX_FIFO_BE_IPAN,
+		IWL_TX_FIFO_BK_IPAN,
+	};
+	static const u8 iwlagn_pan_ac_to_queue[] = {
+		7, 6, 5, 4,
+	};
+	int i;
+
+	/*
+	 * The default context is always valid,
+	 * the PAN context depends on uCode.
+	 */
+	priv->valid_contexts = BIT(IWL_RXON_CTX_BSS);
+	if (ucode_flags & IWL_UCODE_TLV_FLAGS_PAN)
+		priv->valid_contexts |= BIT(IWL_RXON_CTX_PAN);
+
+	for (i = 0; i < NUM_IWL_RXON_CTX; i++)
+		priv->contexts[i].ctxid = i;
+
+	priv->contexts[IWL_RXON_CTX_BSS].always_active = true;
+	priv->contexts[IWL_RXON_CTX_BSS].is_active = true;
+	priv->contexts[IWL_RXON_CTX_BSS].rxon_cmd = REPLY_RXON;
+	priv->contexts[IWL_RXON_CTX_BSS].rxon_timing_cmd = REPLY_RXON_TIMING;
+	priv->contexts[IWL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
+	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
+	priv->contexts[IWL_RXON_CTX_BSS].ap_sta_id = IWL_AP_ID;
+	priv->contexts[IWL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
+	priv->contexts[IWL_RXON_CTX_BSS].ac_to_fifo = iwlagn_bss_ac_to_fifo;
+	priv->contexts[IWL_RXON_CTX_BSS].ac_to_queue = iwlagn_bss_ac_to_queue;
+	priv->contexts[IWL_RXON_CTX_BSS].exclusive_interface_modes =
+		BIT(NL80211_IFTYPE_ADHOC);
+	priv->contexts[IWL_RXON_CTX_BSS].interface_modes =
+		BIT(NL80211_IFTYPE_STATION);
+	priv->contexts[IWL_RXON_CTX_BSS].ap_devtype = RXON_DEV_TYPE_AP;
+	priv->contexts[IWL_RXON_CTX_BSS].ibss_devtype = RXON_DEV_TYPE_IBSS;
+	priv->contexts[IWL_RXON_CTX_BSS].station_devtype = RXON_DEV_TYPE_ESS;
+	priv->contexts[IWL_RXON_CTX_BSS].unused_devtype = RXON_DEV_TYPE_ESS;
+
+	priv->contexts[IWL_RXON_CTX_PAN].rxon_cmd = REPLY_WIPAN_RXON;
+	priv->contexts[IWL_RXON_CTX_PAN].rxon_timing_cmd =
+		REPLY_WIPAN_RXON_TIMING;
+	priv->contexts[IWL_RXON_CTX_PAN].rxon_assoc_cmd =
+		REPLY_WIPAN_RXON_ASSOC;
+	priv->contexts[IWL_RXON_CTX_PAN].qos_cmd = REPLY_WIPAN_QOS_PARAM;
+	priv->contexts[IWL_RXON_CTX_PAN].ap_sta_id = IWL_AP_ID_PAN;
+	priv->contexts[IWL_RXON_CTX_PAN].wep_key_cmd = REPLY_WIPAN_WEPKEY;
+	priv->contexts[IWL_RXON_CTX_PAN].bcast_sta_id = IWLAGN_PAN_BCAST_ID;
+	priv->contexts[IWL_RXON_CTX_PAN].station_flags = STA_FLG_PAN_STATION;
+	priv->contexts[IWL_RXON_CTX_PAN].ac_to_fifo = iwlagn_pan_ac_to_fifo;
+	priv->contexts[IWL_RXON_CTX_PAN].ac_to_queue = iwlagn_pan_ac_to_queue;
+	priv->contexts[IWL_RXON_CTX_PAN].mcast_queue = IWL_IPAN_MCAST_QUEUE;
+	priv->contexts[IWL_RXON_CTX_PAN].interface_modes =
+		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP);
+#ifdef CONFIG_IWL_P2P
+	priv->contexts[IWL_RXON_CTX_PAN].interface_modes |=
+		BIT(NL80211_IFTYPE_P2P_CLIENT) | BIT(NL80211_IFTYPE_P2P_GO);
+#endif
+	priv->contexts[IWL_RXON_CTX_PAN].ap_devtype = RXON_DEV_TYPE_CP;
+	priv->contexts[IWL_RXON_CTX_PAN].station_devtype = RXON_DEV_TYPE_2STA;
+	priv->contexts[IWL_RXON_CTX_PAN].unused_devtype = RXON_DEV_TYPE_P2P;
+
+	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
+}
+
+
 struct iwlagn_ucode_capabilities {
 	u32 max_probe_length;
 	u32 standard_phy_calibration_size;
@@ -1153,17 +1232,16 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	priv->new_scan_threshold_behaviour =
 		!!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
 
-	if ((priv->cfg->sku & EEPROM_SKU_CAP_IPAN_ENABLE) &&
-	    (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN)) {
-		priv->valid_contexts |= BIT(IWL_RXON_CTX_PAN);
-		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
-	} else
-		priv->sta_key_max_num = STA_KEY_MAX_NUM;
+	if (!(priv->cfg->sku & EEPROM_SKU_CAP_IPAN_ENABLE))
+		ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
 
-	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
+	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
+		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
 		priv->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
-	else
+	} else {
+		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 		priv->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
+	}
 
 	/*
 	 * figure out the offset of chain noise reset and gain commands
@@ -1179,6 +1257,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	priv->phy_calib_chain_noise_gain_cmd =
 		ucode_capa.standard_phy_calibration_size + 1;
 
+	/* initialize all valid contexts */
+	iwl_init_context(priv, ucode_capa.flags);
+
 	/**************************************************
 	 * This is still part of probe() in a sense...
 	 *
@@ -3591,28 +3672,6 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 	return priv->cfg->lib->set_hw_params(priv);
 }
 
-static const u8 iwlagn_bss_ac_to_fifo[] = {
-	IWL_TX_FIFO_VO,
-	IWL_TX_FIFO_VI,
-	IWL_TX_FIFO_BE,
-	IWL_TX_FIFO_BK,
-};
-
-static const u8 iwlagn_bss_ac_to_queue[] = {
-	0, 1, 2, 3,
-};
-
-static const u8 iwlagn_pan_ac_to_fifo[] = {
-	IWL_TX_FIFO_VO_IPAN,
-	IWL_TX_FIFO_VI_IPAN,
-	IWL_TX_FIFO_BE_IPAN,
-	IWL_TX_FIFO_BK_IPAN,
-};
-
-static const u8 iwlagn_pan_ac_to_queue[] = {
-	7, 6, 5, 4,
-};
-
 /* This function both allocates and initializes hw and priv. */
 static struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg)
 {
@@ -3635,65 +3694,6 @@ out:
 	return hw;
 }
 
-static void iwl_init_context(struct iwl_priv *priv)
-{
-	int i;
-
-	/*
-	 * The default context is always valid,
-	 * more may be discovered when firmware
-	 * is loaded.
-	 */
-	priv->valid_contexts = BIT(IWL_RXON_CTX_BSS);
-
-	for (i = 0; i < NUM_IWL_RXON_CTX; i++)
-		priv->contexts[i].ctxid = i;
-
-	priv->contexts[IWL_RXON_CTX_BSS].always_active = true;
-	priv->contexts[IWL_RXON_CTX_BSS].is_active = true;
-	priv->contexts[IWL_RXON_CTX_BSS].rxon_cmd = REPLY_RXON;
-	priv->contexts[IWL_RXON_CTX_BSS].rxon_timing_cmd = REPLY_RXON_TIMING;
-	priv->contexts[IWL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
-	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
-	priv->contexts[IWL_RXON_CTX_BSS].ap_sta_id = IWL_AP_ID;
-	priv->contexts[IWL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
-	priv->contexts[IWL_RXON_CTX_BSS].ac_to_fifo = iwlagn_bss_ac_to_fifo;
-	priv->contexts[IWL_RXON_CTX_BSS].ac_to_queue = iwlagn_bss_ac_to_queue;
-	priv->contexts[IWL_RXON_CTX_BSS].exclusive_interface_modes =
-		BIT(NL80211_IFTYPE_ADHOC);
-	priv->contexts[IWL_RXON_CTX_BSS].interface_modes =
-		BIT(NL80211_IFTYPE_STATION);
-	priv->contexts[IWL_RXON_CTX_BSS].ap_devtype = RXON_DEV_TYPE_AP;
-	priv->contexts[IWL_RXON_CTX_BSS].ibss_devtype = RXON_DEV_TYPE_IBSS;
-	priv->contexts[IWL_RXON_CTX_BSS].station_devtype = RXON_DEV_TYPE_ESS;
-	priv->contexts[IWL_RXON_CTX_BSS].unused_devtype = RXON_DEV_TYPE_ESS;
-
-	priv->contexts[IWL_RXON_CTX_PAN].rxon_cmd = REPLY_WIPAN_RXON;
-	priv->contexts[IWL_RXON_CTX_PAN].rxon_timing_cmd =
-		REPLY_WIPAN_RXON_TIMING;
-	priv->contexts[IWL_RXON_CTX_PAN].rxon_assoc_cmd =
-		REPLY_WIPAN_RXON_ASSOC;
-	priv->contexts[IWL_RXON_CTX_PAN].qos_cmd = REPLY_WIPAN_QOS_PARAM;
-	priv->contexts[IWL_RXON_CTX_PAN].ap_sta_id = IWL_AP_ID_PAN;
-	priv->contexts[IWL_RXON_CTX_PAN].wep_key_cmd = REPLY_WIPAN_WEPKEY;
-	priv->contexts[IWL_RXON_CTX_PAN].bcast_sta_id = IWLAGN_PAN_BCAST_ID;
-	priv->contexts[IWL_RXON_CTX_PAN].station_flags = STA_FLG_PAN_STATION;
-	priv->contexts[IWL_RXON_CTX_PAN].ac_to_fifo = iwlagn_pan_ac_to_fifo;
-	priv->contexts[IWL_RXON_CTX_PAN].ac_to_queue = iwlagn_pan_ac_to_queue;
-	priv->contexts[IWL_RXON_CTX_PAN].mcast_queue = IWL_IPAN_MCAST_QUEUE;
-	priv->contexts[IWL_RXON_CTX_PAN].interface_modes =
-		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP);
-#ifdef CONFIG_IWL_P2P
-	priv->contexts[IWL_RXON_CTX_PAN].interface_modes |=
-		BIT(NL80211_IFTYPE_P2P_CLIENT) | BIT(NL80211_IFTYPE_P2P_GO);
-#endif
-	priv->contexts[IWL_RXON_CTX_PAN].ap_devtype = RXON_DEV_TYPE_CP;
-	priv->contexts[IWL_RXON_CTX_PAN].station_devtype = RXON_DEV_TYPE_2STA;
-	priv->contexts[IWL_RXON_CTX_PAN].unused_devtype = RXON_DEV_TYPE_P2P;
-
-	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
-}
-
 int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 {
 	int err = 0;
@@ -3796,9 +3796,6 @@ int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 		priv->hw->wiphy->n_addresses++;
 	}
 
-	/* initialize all valid contexts */
-	iwl_init_context(priv);
-
 	/************************
 	 * 5. Setup HW constants
 	 ************************/
-- 
1.7.0.4

