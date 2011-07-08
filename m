Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab1GHQUi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Fry, Donald H" <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/21] iwlagn: remove the indirection for iwl_apm_init
Date: Fri,  8 Jul 2011 08:46:18 -0700
Message-Id: <1310139989-27661-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182104_757931_749BA465)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fry, Donald H <donald.h.fry@intel.com>

Not needed since the driver split.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    5 +----
 drivers/net/wireless/iwlwifi/iwl-2000.c    |    5 +----
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   10 ++--------
 drivers/net/wireless/iwlwifi/iwl-6000.c    |   10 ++--------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.h    |    9 ++-------
 drivers/net/wireless/iwlwifi/iwl-eeprom.c  |    2 +-
 7 files changed, 11 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 11f10c1..5be2767 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -171,10 +171,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.apm_ops = {
-		.init = iwl_apm_init,
-		.config = iwl1000_nic_config,
-	},
+	.nic_config = iwl1000_nic_config,
 	.eeprom_ops = {
 		.regulatory_bands = {
 			EEPROM_REG_BAND_1_CHANNELS,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 953e967..2580dc3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -171,10 +171,7 @@ static struct iwl_lib_ops iwl2000_lib = {
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.apm_ops = {
-		.init = iwl_apm_init,
-		.config = iwl2000_nic_config,
-	},
+	.nic_config = iwl2000_nic_config,
 	.eeprom_ops = {
 		.regulatory_bands = {
 			EEPROM_REG_BAND_1_CHANNELS,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index f6bc02f..1d9bae3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -324,10 +324,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.set_channel_switch = iwl5000_hw_channel_switch,
-	.apm_ops = {
-		.init = iwl_apm_init,
-		.config = iwl5000_nic_config,
-	},
+	.nic_config = iwl5000_nic_config,
 	.eeprom_ops = {
 		.regulatory_bands = {
 			EEPROM_REG_BAND_1_CHANNELS,
@@ -351,10 +348,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.set_channel_switch = iwl5000_hw_channel_switch,
-	.apm_ops = {
-		.init = iwl_apm_init,
-		.config = iwl5000_nic_config,
-	},
+	.nic_config = iwl5000_nic_config,
 	.eeprom_ops = {
 		.regulatory_bands = {
 			EEPROM_REG_BAND_1_CHANNELS,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 91418fa..73ea73e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -264,10 +264,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.set_channel_switch = iwl6000_hw_channel_switch,
-	.apm_ops = {
-		.init = iwl_apm_init,
-		.config = iwl6000_nic_config,
-	},
+	.nic_config = iwl6000_nic_config,
 	.eeprom_ops = {
 		.regulatory_bands = {
 			EEPROM_REG_BAND_1_CHANNELS,
@@ -293,10 +290,7 @@ static struct iwl_lib_ops iwl6030_lib = {
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.set_channel_switch = iwl6000_hw_channel_switch,
-	.apm_ops = {
-		.init = iwl_apm_init,
-		.config = iwl6000_nic_config,
-	},
+	.nic_config = iwl6000_nic_config,
 	.eeprom_ops = {
 		.regulatory_bands = {
 			EEPROM_REG_BAND_1_CHANNELS,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index c7102bb..f787ef5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -703,7 +703,7 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 
 	/* nic_init */
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->cfg->ops->lib->apm_ops.init(priv);
+	iwl_apm_init(priv);
 
 	/* Set interrupt coalescing calibration timer to default (512 usecs) */
 	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_CALIB_TIMEOUT_DEF);
@@ -712,7 +712,7 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 
 	iwlagn_set_pwr_vmain(priv);
 
-	priv->cfg->ops->lib->apm_ops.config(priv);
+	priv->cfg->ops->lib->nic_config(priv);
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	trans_rx_init(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e1ab1a1..47cfbb9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -96,11 +96,6 @@ struct iwl_hcmd_utils_ops {
 	int (*request_scan)(struct iwl_priv *priv, struct ieee80211_vif *vif);
 };
 
-struct iwl_apm_ops {
-	int (*init)(struct iwl_priv *priv);
-	void (*config)(struct iwl_priv *priv);
-};
-
 struct iwl_temp_ops {
 	void (*temperature)(struct iwl_priv *priv);
 };
@@ -118,8 +113,8 @@ struct iwl_lib_ops {
 	int (*is_valid_rtc_data_addr)(u32 addr);
 	int (*set_channel_switch)(struct iwl_priv *priv,
 				  struct ieee80211_channel_switch *ch_switch);
-	/* power management */
-	struct iwl_apm_ops apm_ops;
+	/* device specific configuration */
+	void (*nic_config)(struct iwl_priv *priv);
 
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 768d0ee..eab2834 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -449,7 +449,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	}
 	e = (__le16 *)priv->eeprom;
 
-	priv->cfg->ops->lib->apm_ops.init(priv);
+	iwl_apm_init(priv);
 
 	ret = iwl_eeprom_verify_signature(priv);
 	if (ret < 0) {
-- 
1.7.0.4

