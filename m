Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab0JGXIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/22] iwlwifi: remove verify_signature eeprom operation
Date: Thu,  7 Oct 2010 16:07:45 -0700
Message-Id: <1286492881-15743-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All drivers share the same implementation, so
there's no need to call this via a function
pointer nor to export it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    2 --
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    5 ++---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    1 -
 7 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 134f545..8c2db55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -209,7 +209,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 			EEPROM_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
 		.calib_version	= iwlagn_eeprom_calib_version,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index ef67087..a7dbb28 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2686,7 +2686,6 @@ static struct iwl_lib_ops iwl3945_lib = {
 			EEPROM_REGULATORY_BAND_NO_HT40,
 			EEPROM_REGULATORY_BAND_NO_HT40,
 		},
-		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwl3945_eeprom_acquire_semaphore,
 		.release_semaphore = iwl3945_eeprom_release_semaphore,
 		.query_addr = iwlcore_eeprom_query_addr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 20626c9..08d2dbc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2280,7 +2280,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 			EEPROM_4965_REGULATORY_BAND_24_HT40_CHANNELS,
 			EEPROM_4965_REGULATORY_BAND_52_HT40_CHANNELS
 		},
-		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
 		.calib_version = iwl4965_eeprom_calib_version,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1b25ad6..ddbbb93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -384,7 +384,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 			EEPROM_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
 		.calib_version	= iwlagn_eeprom_calib_version,
@@ -456,7 +455,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 			EEPROM_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
 		.calib_version	= iwlagn_eeprom_calib_version,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 6261aec..198cd8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -323,7 +323,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
 		.calib_version	= iwlagn_eeprom_calib_version,
@@ -398,7 +397,6 @@ static struct iwl_lib_ops iwl6000g2b_lib = {
 			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
 			EEPROM_REG_BAND_52_HT40_CHANNELS
 		},
-		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
 		.calib_version	= iwlagn_eeprom_calib_version,
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 88f4a80..bd51b06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -214,7 +214,7 @@ static const struct iwl_txpwr_section enhinfo[] = {
  *
 ******************************************************************************/
 
-int iwlcore_eeprom_verify_signature(struct iwl_priv *priv)
+static int iwl_eeprom_verify_signature(struct iwl_priv *priv)
 {
 	u32 gp = iwl_read32(priv, CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
 	int ret = 0;
@@ -246,7 +246,6 @@ int iwlcore_eeprom_verify_signature(struct iwl_priv *priv)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(iwlcore_eeprom_verify_signature);
 
 static void iwl_set_otp_access(struct iwl_priv *priv, enum iwl_access_mode mode)
 {
@@ -523,7 +522,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 
 	priv->cfg->ops->lib->apm_ops.init(priv);
 
-	ret = priv->cfg->ops->lib->eeprom_ops.verify_signature(priv);
+	ret = iwl_eeprom_verify_signature(priv);
 	if (ret < 0) {
 		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
 		ret = -ENOENT;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index a4772af..2ae0a11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -493,7 +493,6 @@ struct iwl_eeprom_calib_info {
 
 struct iwl_eeprom_ops {
 	const u32 regulatory_bands[7];
-	int (*verify_signature) (struct iwl_priv *priv);
 	int (*acquire_semaphore) (struct iwl_priv *priv);
 	void (*release_semaphore) (struct iwl_priv *priv);
 	u16 (*calib_version) (struct iwl_priv *priv);
-- 
1.7.0.4

