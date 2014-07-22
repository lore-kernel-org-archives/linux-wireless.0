Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:46339 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaGVT1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:10 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so114623wes.6
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:06 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Oren Givon <oren.givon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/20] iwlwifi: add max RX aggregation size
Date: Tue, 22 Jul 2014 22:26:33 +0300
Message-Id: <1406057211-31752-2-git-send-email-egrumbach@gmail.com> (sfid-20140722_212715_124077_32C580CF)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

Allow to configure the maximal Rx AMPDU size per device.

Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c   | 4 ++++
 drivers/net/wireless/iwlwifi/iwl-config.h | 2 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c    | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 51486cc..44b19e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -85,6 +85,9 @@
 #define NVM_HW_SECTION_NUM_FAMILY_8000		10
 #define DEFAULT_NVM_FILE_FAMILY_8000		"iwl_nvm_8000.bin"
 
+/* Max SDIO RX aggregation size of the ADDBA request/response */
+#define MAX_RX_AGG_SIZE_8260_SDIO	28
+
 static const struct iwl_base_params iwl8000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_8000,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
@@ -129,6 +132,7 @@ const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.nvm_ver = IWL8000_NVM_VERSION,
 	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.default_nvm_file = DEFAULT_NVM_FILE_FAMILY_8000,
+	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
 };
 
 MODULE_FIRMWARE(IWL8000_MODULE_FIRMWARE(IWL8000_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 034c2fc..8da596d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -240,6 +240,7 @@ struct iwl_pwr_tx_backoff {
  * @d0i3: device uses d0i3 instead of d3
  * @nvm_hw_section_num: the ID of the HW NVM section
  * @pwr_tx_backoffs: translation table between power limits and backoffs
+ * @max_rx_agg_size: max RX aggregation size of the ADDBA request/response
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -276,6 +277,7 @@ struct iwl_cfg {
 	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
 	bool no_power_up_nic_in_init;
 	const char *default_nvm_file;
+	unsigned int max_rx_agg_size;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 7d7b2fb..7f0e9af 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -391,6 +391,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (!hw)
 		return NULL;
 
+	if (cfg->max_rx_agg_size)
+		hw->max_rx_aggregation_subframes = cfg->max_rx_agg_size;
+
 	op_mode = hw->priv;
 	op_mode->ops = &iwl_mvm_ops;
 
-- 
1.8.3.2

