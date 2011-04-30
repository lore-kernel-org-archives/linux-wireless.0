Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62414 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493Ab1D3Qku (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/14] iwlagn: semaphore and calib cleanup
Date: Sat, 30 Apr 2011 09:17:36 -0700
Message-Id: <1304180260-13875-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184110_182315_6BA06F59)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

All agn devices use the same eeprom semaphore and calib version routines.
Delete the indirection and move the semaphore routines to where they are
used and make static.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c       |    3 --
 drivers/net/wireless/iwlwifi/iwl-2000.c       |    3 --
 drivers/net/wireless/iwlwifi/iwl-5000.c       |    6 ---
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   10 +-----
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   41 +-----------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h        |    2 -
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |   43 +++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |    3 --
 8 files changed, 44 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index d2b1be6..4767edf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -197,9 +197,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 			EEPROM_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
-		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
-		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 	},
 	.temp_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 476150f..80137ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -280,9 +280,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
-		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
-		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.calib_version  = iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 969c91a..cc25351 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -366,9 +366,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 			EEPROM_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
-		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 	},
 	.temp_ops = {
@@ -413,9 +410,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 			EEPROM_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
-		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 	},
 	.temp_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 91edb57..f9ef227 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -80,7 +80,7 @@ static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 static void iwl6050_additional_nic_config(struct iwl_priv *priv)
 {
 	/* Indicate calibration version to uCode. */
-	if (priv->cfg->ops->lib->eeprom_ops.calib_version(priv) >= 6)
+	if (iwlagn_eeprom_calib_version(priv) >= 6)
 		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 }
@@ -88,7 +88,7 @@ static void iwl6050_additional_nic_config(struct iwl_priv *priv)
 static void iwl6150_additional_nic_config(struct iwl_priv *priv)
 {
 	/* Indicate calibration version to uCode. */
-	if (priv->cfg->ops->lib->eeprom_ops.calib_version(priv) >= 6)
+	if (iwlagn_eeprom_calib_version(priv) >= 6)
 		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 	iwl_set_bit(priv, CSR_GP_DRIVER_REG,
@@ -305,9 +305,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
-		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
@@ -354,9 +351,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
-		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.calib_version	= iwlagn_eeprom_calib_version,
 		.query_addr = iwlagn_eeprom_query_addr,
 		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
 	},
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 3bcaa10..2ef9448 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -81,52 +81,13 @@
  *
 ******************************************************************************/
 
-/*
- * The device's EEPROM semaphore prevents conflicts between driver and uCode
- * when accessing the EEPROM; each access is a series of pulses to/from the
- * EEPROM chip, not a single event, so even reads could conflict if they
- * weren't arbitrated by the semaphore.
- */
-int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv)
-{
-	u16 count;
-	int ret;
-
-	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
-		/* Request semaphore */
-		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
-
-		/* See if we got it */
-		ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
-				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
-				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
-				EEPROM_SEM_TIMEOUT);
-		if (ret >= 0) {
-			IWL_DEBUG_EEPROM(priv,
-				"Acquired semaphore after %d tries.\n",
-				count+1);
-			return ret;
-		}
-	}
-
-	return ret;
-}
-
-void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv)
-{
-	iwl_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
-		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
-
-}
-
 int iwl_eeprom_check_version(struct iwl_priv *priv)
 {
 	u16 eeprom_ver;
 	u16 calib_ver;
 
 	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
-	calib_ver = priv->cfg->ops->lib->eeprom_ops.calib_version(priv);
+	calib_ver = iwlagn_eeprom_calib_version(priv);
 
 	if (eeprom_ver < priv->cfg->eeprom_ver ||
 	    calib_ver < priv->cfg->eeprom_calib_ver)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 9d644d4..b477336 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -327,8 +327,6 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 /* eeprom */
 void iwlcore_eeprom_enhanced_txpower(struct iwl_priv *priv);
 void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac);
-int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv);
-void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv);
 
 /* notification wait support */
 void __acquires(wait_entry)
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 1e1a2d8..c839796 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -142,6 +142,45 @@ static const u8 iwl_eeprom_band_7[] = {       /* 5.2 ht40 channel */
  *
 ******************************************************************************/
 
+/*
+ * The device's EEPROM semaphore prevents conflicts between driver and uCode
+ * when accessing the EEPROM; each access is a series of pulses to/from the
+ * EEPROM chip, not a single event, so even reads could conflict if they
+ * weren't arbitrated by the semaphore.
+ */
+static int iwl_eeprom_acquire_semaphore(struct iwl_priv *priv)
+{
+	u16 count;
+	int ret;
+
+	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
+		/* Request semaphore */
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
+
+		/* See if we got it */
+		ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
+				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
+				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
+				EEPROM_SEM_TIMEOUT);
+		if (ret >= 0) {
+			IWL_DEBUG_EEPROM(priv,
+				"Acquired semaphore after %d tries.\n",
+				count+1);
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+static void iwl_eeprom_release_semaphore(struct iwl_priv *priv)
+{
+	iwl_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
+		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
+
+}
+
 static int iwl_eeprom_verify_signature(struct iwl_priv *priv)
 {
 	u32 gp = iwl_read32(priv, CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
@@ -421,7 +460,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	}
 
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
-	ret = priv->cfg->ops->lib->eeprom_ops.acquire_semaphore(priv);
+	ret = iwl_eeprom_acquire_semaphore(priv);
 	if (ret < 0) {
 		IWL_ERR(priv, "Failed to acquire EEPROM semaphore.\n");
 		ret = -ENOENT;
@@ -488,7 +527,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 
 	ret = 0;
 done:
-	priv->cfg->ops->lib->eeprom_ops.release_semaphore(priv);
+	iwl_eeprom_release_semaphore(priv);
 
 err:
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 9ce0525..c960c6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -294,9 +294,6 @@ extern const u8 iwl_eeprom_band_1[14];
 
 struct iwl_eeprom_ops {
 	const u32 regulatory_bands[7];
-	int (*acquire_semaphore) (struct iwl_priv *priv);
-	void (*release_semaphore) (struct iwl_priv *priv);
-	u16 (*calib_version) (struct iwl_priv *priv);
 	const u8* (*query_addr) (const struct iwl_priv *priv, size_t offset);
 	void (*update_enhanced_txpower) (struct iwl_priv *priv);
 };
-- 
1.7.0.4

