Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31149 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab1JJPQ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/34] iwlagn: eliminate bus pointer from iwl_priv structure
Date: Mon, 10 Oct 2011 07:26:56 -0700
Message-Id: <1318256839-31837-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171732_610255_07DC8831)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

A pointer to the bus structure is still in iwl_priv.  Finish
cleanup and remove it.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   17 ++++++++---------
 drivers/net/wireless/iwlwifi/iwl-core.c    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    3 ---
 drivers/net/wireless/iwlwifi/iwl-led.c     |    3 +--
 drivers/net/wireless/iwlwifi/iwl-power.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c |    4 ++--
 6 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 74ac478..90ca2d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -463,7 +463,7 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 static void iwl_free_fw_desc(struct iwl_priv *priv, struct fw_desc *desc)
 {
 	if (desc->v_addr)
-		dma_free_coherent(priv->bus->dev, desc->len,
+		dma_free_coherent(bus(priv)->dev, desc->len,
 				  desc->v_addr, desc->p_addr);
 	desc->v_addr = NULL;
 	desc->len = 0;
@@ -490,7 +490,7 @@ static int iwl_alloc_fw_desc(struct iwl_priv *priv, struct fw_desc *desc,
 		return -EINVAL;
 	}
 
-	desc->v_addr = dma_alloc_coherent(priv->bus->dev, len,
+	desc->v_addr = dma_alloc_coherent(bus(priv)->dev, len,
 					  &desc->p_addr, GFP_KERNEL);
 	if (!desc->v_addr)
 		return -ENOMEM;
@@ -602,7 +602,7 @@ static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 		       priv->firmware_name);
 
 	return request_firmware_nowait(THIS_MODULE, 1, priv->firmware_name,
-				       priv->bus->dev,
+				       bus(priv)->dev,
 				       GFP_KERNEL, priv, iwl_ucode_callback);
 }
 
@@ -1161,7 +1161,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	iwl_dealloc_ucode(priv);
  out_unbind:
 	complete(&priv->firmware_loading_complete);
-	device_release_driver(priv->bus->dev);
+	device_release_driver(bus(priv)->dev);
 	release_firmware(ucode_raw);
 }
 
@@ -1701,7 +1701,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
-	if (priv->ucode_wowlan.code.len && device_can_wakeup(priv->bus->dev)) {
+	if (priv->ucode_wowlan.code.len && device_can_wakeup(bus(priv)->dev)) {
 		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
 					  WIPHY_WOWLAN_DISCONNECT |
 					  WIPHY_WOWLAN_EAP_IDENTITY_REQ |
@@ -2188,7 +2188,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	if (ret)
 		goto error;
 
-	device_set_wakeup_enable(priv->bus->dev, true);
+	device_set_wakeup_enable(bus(priv)->dev, true);
 
 	/* Now let the ucode operate on its own */
 	iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_SET,
@@ -2251,7 +2251,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 	priv->shrd->wowlan = false;
 
-	device_set_wakeup_enable(priv->bus->dev, false);
+	device_set_wakeup_enable(bus(priv)->dev, false);
 
 	iwlagn_prepare_restart(priv);
 
@@ -3193,7 +3193,6 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	}
 
 	priv = hw->priv;
-	priv->bus = bus;
 	priv->shrd = &priv->_shrd;
 	bus->shrd = priv->shrd;
 	priv->shrd->bus = bus;
@@ -3207,7 +3206,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 
 	/* At this point both hw and priv are allocated. */
 
-	SET_IEEE80211_DEV(hw, priv->bus->dev);
+	SET_IEEE80211_DEV(hw, bus(priv)->dev);
 
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
 	priv->cfg = cfg;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2cc6399..132fbfc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -211,7 +211,7 @@ int iwl_init_geos(struct iwl_priv *priv)
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
 	     priv->cfg->sku & EEPROM_SKU_CAP_BAND_52GHZ) {
 		char buf[32];
-		bus_get_hw_id(priv->bus, buf, sizeof(buf));
+		bus_get_hw_id(bus(priv), buf, sizeof(buf));
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
 			"Please send your %s to maintainer.\n", buf);
 		priv->cfg->sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
@@ -979,7 +979,7 @@ int iwl_apm_init(struct iwl_priv *priv)
 	iwl_set_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
 				    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
 
-	bus_apm_config(priv->bus);
+	bus_apm_config(bus(priv));
 
 	/* Configure analog phase-lock-loop before activating to D0A */
 	if (priv->cfg->base_params->pll_cfg_val)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 257aa9a..6c00a44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -894,9 +894,6 @@ struct iwl_priv {
 	u8 scan_tx_ant[IEEE80211_NUM_BANDS];
 	u8 mgmt_tx_ant;
 
-	/*TODO: remove these pointers - use bus(priv) instead */
-	struct iwl_bus *bus;	/* bus specific data */
-
 	/* max number of station keys */
 	u8 sta_key_max_num;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index f149165..eb54173 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -202,8 +202,7 @@ void iwl_leds_init(struct iwl_priv *priv)
 		break;
 	}
 
-	ret = led_classdev_register(priv->bus->dev,
-				    &priv->led);
+	ret = led_classdev_register(bus(priv)->dev, &priv->led);
 	if (ret) {
 		kfree(priv->led.name);
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 62cd781..4eaab20 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -436,7 +436,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 /* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
-	priv->power_data.bus_pm = bus_get_pm_support(priv->bus);
+	priv->power_data.bus_pm = bus_get_pm_support(bus(priv));
 
 	priv->power_data.debug_sleep_level_override = -1;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 3335d31..1d1622d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -184,7 +184,7 @@ static void iwl_trace_cleanup(struct iwl_priv *priv)
 	if (priv->testmode_trace.trace_enabled) {
 		if (priv->testmode_trace.cpu_addr &&
 		    priv->testmode_trace.dma_addr)
-			dma_free_coherent(priv->bus->dev,
+			dma_free_coherent(bus(priv)->dev,
 					priv->testmode_trace.total_size,
 					priv->testmode_trace.cpu_addr,
 					priv->testmode_trace.dma_addr);
@@ -484,7 +484,7 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 	struct iwl_priv *priv = hw->priv;
 	struct sk_buff *skb;
 	int status = 0;
-	struct device *dev = priv->bus->dev;
+	struct device *dev = bus(priv)->dev;
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
-- 
1.7.0.4

