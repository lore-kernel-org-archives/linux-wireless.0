Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab1GPPcN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/18] iwlagn: another double indirect removed
Date: Sat, 16 Jul 2011 07:56:28 -0700
Message-Id: <1310828199-18000-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173238_809678_CCC95C3E)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another clean up work after driver split

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   18 ++++--------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    7 +------
 2 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f6b309d..5ab7524 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -106,10 +106,8 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
 	}
 	/* do additional nic configuration if needed */
-	if (priv->cfg->nic &&
-		priv->cfg->nic->additional_nic_config) {
-			priv->cfg->nic->additional_nic_config(priv);
-	}
+	if (priv->cfg->additional_nic_config)
+			priv->cfg->additional_nic_config(priv);
 }
 
 static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
@@ -303,14 +301,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 	.temperature = iwlagn_temperature,
 };
 
-static struct iwl_nic_ops iwl6050_nic_ops = {
-	.additional_nic_config = &iwl6050_additional_nic_config,
-};
-
-static struct iwl_nic_ops iwl6150_nic_ops = {
-	.additional_nic_config = &iwl6150_additional_nic_config,
-};
-
 static struct iwl_base_params iwl6000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
@@ -521,7 +511,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.valid_tx_ant = ANT_AB,		/* .cfg overwrite */	\
 	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */	\
 	.lib = &iwl6000_lib,					\
-	.nic = &iwl6050_nic_ops,				\
+	.additional_nic_config = iwl6050_additional_nic_config,	\
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
@@ -545,7 +535,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,			\
 	.ucode_api_min = IWL6050_UCODE_API_MIN,			\
 	.lib = &iwl6000_lib,					\
-	.nic = &iwl6150_nic_ops,				\
+	.additional_nic_config = iwl6150_additional_nic_config,	\
 	.eeprom_ver = EEPROM_6150_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6150_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d6d2760..28c21f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -103,11 +103,6 @@ struct iwl_lib_ops {
 	void (*temperature)(struct iwl_priv *priv);
 };
 
-/* NIC specific ops */
-struct iwl_nic_ops {
-	void (*additional_nic_config)(struct iwl_priv *priv);
-};
-
 struct iwl_mod_params {
 	int sw_crypto;		/* def: 0 = using hardware encryption */
 	int num_of_queues;	/* def: HW dependent */
@@ -243,7 +238,7 @@ struct iwl_cfg {
 	u16  eeprom_ver;
 	u16  eeprom_calib_ver;
 	const struct iwl_lib_ops *lib;
-	const struct iwl_nic_ops *nic;
+	void (*additional_nic_config)(struct iwl_priv *priv);
 	/* params not likely to change within a device family */
 	struct iwl_base_params *base_params;
 	/* params likely to change within a device family */
-- 
1.7.0.4

