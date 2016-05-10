Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40552 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752446AbcEJUHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:07:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:05:59 +0300
Message-Id: <1462910797-20303-3-git-send-email-luca@coelho.fi> (sfid-20160510_220737_005373_366CFC1D)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 03/41] iwlwifi: Edit the 8265 SDIO ID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mordechai Goodstein <mordechay.goodstein@intel.com>

Add new 8265 series SDIO ID.

Signed-off-by: Mordechai Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c   | 14 ++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index 2d20556..d6bff16 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -237,6 +237,20 @@ const struct iwl_cfg iwl8260_2ac_sdio_cfg = {
 	.max_vht_ampdu_exponent = MAX_VHT_AMPDU_EXPONENT_8260_SDIO,
 };
 
+const struct iwl_cfg iwl8265_2ac_sdio_cfg = {
+	.name = "Intel(R) Dual Band Wireless-AC 8265",
+	.fw_name_pre = IWL8265_FW_PRE,
+	IWL_DEVICE_8265,
+	.ht_params = &iwl8000_ht_params,
+	.nvm_ver = IWL8000_NVM_VERSION,
+	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
+	.max_rx_agg_size = MAX_RX_AGG_SIZE_8260_SDIO,
+	.max_tx_agg_size = MAX_TX_AGG_SIZE_8260_SDIO,
+	.disable_dummy_notification = true,
+	.max_ht_ampdu_exponent  = MAX_HT_AMPDU_EXPONENT_8260_SDIO,
+	.max_vht_ampdu_exponent = MAX_VHT_AMPDU_EXPONENT_8260_SDIO,
+};
+
 const struct iwl_cfg iwl4165_2ac_sdio_cfg = {
 	.name = "Intel(R) Dual Band Wireless-AC 4165",
 	.fw_name_pre = IWL8000_FW_PRE,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 7206798..95558e3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -437,6 +437,7 @@ extern const struct iwl_cfg iwl8260_2ac_cfg;
 extern const struct iwl_cfg iwl8265_2ac_cfg;
 extern const struct iwl_cfg iwl4165_2ac_cfg;
 extern const struct iwl_cfg iwl8260_2ac_sdio_cfg;
+extern const struct iwl_cfg iwl8265_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl4165_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl9560_2ac_cfg;
 extern const struct iwl_cfg iwl5165_2ac_cfg;
-- 
2.8.1

