Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:7737 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751352AbYJXGsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 02:48:41 -0400
From: Reinette Chatre <reinette.chatre@linux.intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/10] iwlwifi: parametrize eeprom versions
Date: Thu, 23 Oct 2008 23:48:51 -0700
Message-Id: <1224830938-1577-4-git-send-email-reinette.chatre@linux.intel.com> (sfid-20081024_084854_268424_4AF28E97)
In-Reply-To: <1224830938-1577-3-git-send-email-reinette.chatre@linux.intel.com>
References: <>
 <1224830938-1577-1-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-2-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-3-git-send-email-reinette.chatre@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch uses new parameters eeprom_ver and eeprom_calib_ver
to support additional HW.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c   |   26 +++++---------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c   |   29 +++++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   18 +++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    5 ++++-
 5 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 741b425..f53cd2b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -318,27 +318,9 @@ static int is_fat_channel(__le32 rxon_flags)
 /*
  * EEPROM handlers
  */
-
-static int iwl4965_eeprom_check_version(struct iwl_priv *priv)
+static u16 iwl4965_eeprom_calib_version(struct iwl_priv *priv)
 {
-	u16 eeprom_ver;
-	u16 calib_ver;
-
-	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
-
-	calib_ver = iwl_eeprom_query16(priv, EEPROM_4965_CALIB_VERSION_OFFSET);
-
-	if (eeprom_ver < EEPROM_4965_EEPROM_VERSION ||
-	    calib_ver < EEPROM_4965_TX_POWER_VERSION)
-		goto err;
-
-	return 0;
-err:
-	IWL_ERROR("Unsuported EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
-		  eeprom_ver, EEPROM_4965_EEPROM_VERSION,
-		  calib_ver, EEPROM_4965_TX_POWER_VERSION);
-	return -EINVAL;
-
+	return iwl_eeprom_query16(priv, EEPROM_4965_CALIB_VERSION_OFFSET);
 }
 
 /*
@@ -2355,7 +2337,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.check_version = iwl4965_eeprom_check_version,
+		.calib_version = iwl4965_eeprom_calib_version,
 		.query_addr = iwlcore_eeprom_query_addr,
 	},
 	.send_tx_power	= iwl4965_send_tx_power,
@@ -2374,6 +2356,8 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.fw_name = "iwlwifi-4965" IWL4965_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.eeprom_size = IWL4965_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_4965_TX_POWER_VERSION,
 	.ops = &iwl4965_ops,
 	.mod_params = &iwl4965_mod_params,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a368854..cdf328b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -293,30 +293,17 @@ static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
 	return (address & ADDRESS_MSK) + (offset << 1);
 }
 
-static int iwl5000_eeprom_check_version(struct iwl_priv *priv)
+static u16 iwl5000_eeprom_calib_version(struct iwl_priv *priv)
 {
-	u16 eeprom_ver;
 	struct iwl_eeprom_calib_hdr {
 		u8 version;
 		u8 pa_type;
 		u16 voltage;
 	} *hdr;
 
-	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
-
 	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
 							EEPROM_5000_CALIB_ALL);
-
-	if (eeprom_ver < EEPROM_5000_EEPROM_VERSION ||
-	    hdr->version < EEPROM_5000_TX_POWER_VERSION)
-		goto err;
-
-	return 0;
-err:
-	IWL_ERROR("Unsuported EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
-		  eeprom_ver, EEPROM_5000_EEPROM_VERSION,
-		  hdr->version, EEPROM_5000_TX_POWER_VERSION);
-	return -EINVAL;
+	return hdr->version;
 
 }
 
@@ -1510,7 +1497,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.check_version	= iwl5000_eeprom_check_version,
+		.calib_version	= iwl5000_eeprom_calib_version,
 		.query_addr = iwl5000_eeprom_query_addr,
 	},
 };
@@ -1537,6 +1524,8 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 };
 
@@ -1546,6 +1535,8 @@ struct iwl_cfg iwl5100_bg_cfg = {
 	.sku = IWL_SKU_G,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 };
 
@@ -1555,6 +1546,8 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 };
 
@@ -1564,6 +1557,8 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 };
 
@@ -1573,6 +1568,8 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a2d8afe..fb95c6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -173,6 +173,8 @@ struct iwl_cfg {
 	const char *fw_name;
 	unsigned int sku;
 	int eeprom_size;
+	u16  eeprom_ver;
+	u16  eeprom_calib_ver;
 	const struct iwl_ops *ops;
 	const struct iwl_mod_params *mod_params;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 3715575..5160b4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -279,7 +279,23 @@ EXPORT_SYMBOL(iwl_eeprom_free);
 
 int iwl_eeprom_check_version(struct iwl_priv *priv)
 {
-	return priv->cfg->ops->lib->eeprom_ops.check_version(priv);
+	u16 eeprom_ver;
+	u16 calib_ver;
+
+	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
+	calib_ver = priv->cfg->ops->lib->eeprom_ops.calib_version(priv);
+
+	if (eeprom_ver < priv->cfg->eeprom_ver ||
+	    calib_ver < priv->cfg->eeprom_calib_ver)
+		goto err;
+
+	return 0;
+err:
+	IWL_ERROR("Unsuported EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
+		  eeprom_ver, priv->cfg->eeprom_ver,
+		  calib_ver,  priv->cfg->eeprom_calib_ver);
+	return -EINVAL;
+
 }
 EXPORT_SYMBOL(iwl_eeprom_check_version);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index d3a2a5b..997f23c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -174,6 +174,9 @@ struct iwl_eeprom_channel {
 #define EEPROM_5000_REG_BAND_52_FAT_CHANNELS  ((0x92)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 22  bytes */
 
+/* 5050 Specific */
+#define EEPROM_5050_TX_POWER_VERSION    (4)
+#define EEPROM_5050_EEPROM_VERSION	(0x21E)
 
 /* 2.4 GHz */
 extern const u8 iwl_eeprom_band_1[14];
@@ -371,7 +374,7 @@ struct iwl_eeprom_ops {
 	int (*verify_signature) (struct iwl_priv *priv);
 	int (*acquire_semaphore) (struct iwl_priv *priv);
 	void (*release_semaphore) (struct iwl_priv *priv);
-	int (*check_version) (struct iwl_priv *priv);
+	u16 (*calib_version) (struct iwl_priv *priv);
 	const u8* (*query_addr) (const struct iwl_priv *priv, size_t offset);
 };
 
-- 
1.5.4.3

