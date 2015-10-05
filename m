Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57080 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751311AbbJEOhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 10:37:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Moshe Harel <moshe.harel@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:33 +0300
Message-Id: <1444055820-27506-2-git-send-email-luca@coelho.fi> (sfid-20151005_163715_392117_644F6CFF)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 02/29] iwlwifi: nvm: force 1x1 antenna in Series 8000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Moshe Harel <moshe.harel@intel.com>

This is a workaround to an OTP bug. In Series 8000 1x1, the OTP
0xA052 defines 2x2 antenna configuration. This workaround overrides
the decision based on HW id and MIMO disabled bit which is correct
in the OTP and set to disabled.

Signed-off-by: Moshe Harel <moshe.harel@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 15 ++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h |  2 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c       |  3 ++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 3b8e85e..d829849 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -580,13 +580,15 @@ static void iwl_set_hw_address_family_8000(struct device *dev,
 	IWL_ERR_DEV(dev, "mac address is not found\n");
 }
 
+#define IWL_4165_DEVICE_ID 0x5501
+
 struct iwl_nvm_data *
 iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, const __le16 *phy_sku,
 		   u8 tx_chains, u8 rx_chains, bool lar_fw_supported,
-		   u32 mac_addr0, u32 mac_addr1)
+		   u32 mac_addr0, u32 mac_addr1, u32 hw_id)
 {
 	struct iwl_nvm_data *data;
 	u32 sku;
@@ -625,6 +627,17 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 				    (sku & NVM_SKU_CAP_11AC_ENABLE);
 	data->sku_cap_mimo_disabled = sku & NVM_SKU_CAP_MIMO_DISABLE;
 
+	/*
+	 * OTP 0x52 bug work around
+	 * define antenna 1x1 according to MIMO disabled
+	 */
+	if (hw_id == IWL_4165_DEVICE_ID && data->sku_cap_mimo_disabled) {
+		data->valid_tx_ant = ANT_B;
+		data->valid_rx_ant = ANT_B;
+		tx_chains = ANT_B;
+		rx_chains = ANT_B;
+	}
+
 	data->n_hw_addrs = iwl_get_n_hw_addrs(cfg, nvm_sw);
 
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
index 822ba52..9f44d81 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
@@ -79,7 +79,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, const __le16 *phy_sku,
 		   u8 tx_chains, u8 rx_chains, bool lar_fw_supported,
-		   u32 mac_addr0, u32 mac_addr1);
+		   u32 mac_addr0, u32 mac_addr1, u32 hw_id);
 
 /**
  * iwl_parse_mcc_info - parse MCC (mobile country code) info coming from FW
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 328187d..0b3ffd5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -316,7 +316,8 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	return iwl_parse_nvm_data(mvm->trans->dev, mvm->cfg, hw, sw, calib,
 				  regulatory, mac_override, phy_sku,
 				  mvm->fw->valid_tx_ant, mvm->fw->valid_rx_ant,
-				  lar_enabled, mac_addr0, mac_addr1);
+				  lar_enabled, mac_addr0, mac_addr1,
+				  mvm->trans->hw_id);
 }
 
 #define MAX_NVM_FILE_LEN	16384
-- 
2.5.3

