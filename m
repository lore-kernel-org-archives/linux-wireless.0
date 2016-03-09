Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933642AbcCIRqW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:22 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/21] iwlwifi: add support for getting HW address from CSR
Date: Wed,  9 Mar 2016 19:45:43 +0200
Message-Id: <1457545550-30677-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_185950_501586_77E334DF)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

>From 9000 family on, we need to get HW address from host
CSR registers.
OEM can override it by fusing the override registers - read
those first, and if those are 0 - read the OTP registers instead.

In addition - bail out if no valid mac address is present. Make
it shared for all NICs.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c      |  3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  2 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       | 10 +++
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 75 ++++++++++++++++------
 4 files changed, 68 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index 8e32a57..318b1dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -140,7 +140,8 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.thermal_params = &iwl9000_tt_params,				\
 	.apmg_not_supported = true,					\
 	.mq_rx_supported = true,					\
-	.vht_mu_mimo_supported = true
+	.vht_mu_mimo_supported = true,					\
+	.mac_addr_from_csr = true
 
 const struct iwl_cfg iwl9260_2ac_cfg = {
 		.name = "Intel(R) Dual Band Wireless AC 9260",
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 4f2b57e..3e4d346 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -297,6 +297,7 @@ struct iwl_pwr_tx_backoff {
  * @host_interrupt_operation_mode: device needs host interrupt operation
  *	mode set
  * @nvm_hw_section_num: the ID of the HW NVM section
+ * @mac_addr_from_csr: read HW address from CSR registers
  * @features: hw features, any combination of feature_whitelist
  * @pwr_tx_backoffs: translation table between power limits and backoffs
  * @max_rx_agg_size: max RX aggregation size of the ADDBA request/response
@@ -345,6 +346,7 @@ struct iwl_cfg {
 	const bool host_interrupt_operation_mode;
 	bool high_temp;
 	u8   nvm_hw_section_num;
+	bool mac_addr_from_csr;
 	bool lp_xtal_workaround;
 	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
 	bool no_power_up_nic_in_init;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index a79c4f6..b978f6c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -598,4 +598,14 @@ enum msix_hw_int_causes {
 #define MSIX_AUTO_CLEAR_CAUSE			0
 #define MSIX_NON_AUTO_CLEAR_CAUSE		BIT(7)
 
+/*****************************************************************************
+ *                     HW address related registers                          *
+ *****************************************************************************/
+
+#define CSR_ADDR_BASE			(0x380)
+#define CSR_MAC_ADDR0_OTP		(CSR_ADDR_BASE)
+#define CSR_MAC_ADDR1_OTP		(CSR_ADDR_BASE + 4)
+#define CSR_MAC_ADDR0_STRAP		(CSR_ADDR_BASE + 8)
+#define CSR_MAC_ADDR1_STRAP		(CSR_ADDR_BASE + 0xC)
+
 #endif /* !__iwl_csr_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 5e6b90d..93a6895 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -71,6 +71,8 @@
 #include "iwl-modparams.h"
 #include "iwl-nvm-parse.h"
 #include "iwl-prph.h"
+#include "iwl-io.h"
+#include "iwl-csr.h"
 
 /* NVM offsets (in words) definitions */
 enum wkp_nvm_offsets {
@@ -524,6 +526,36 @@ static void iwl_set_radio_cfg(const struct iwl_cfg *cfg,
 	data->valid_rx_ant = NVM_RF_CFG_RX_ANT_MSK_FAMILY_8000(radio_cfg);
 }
 
+static void iwl_flip_hw_address(__le32 mac_addr0, __le32 mac_addr1, u8 *dest)
+{
+	const u8 *hw_addr;
+
+	hw_addr = (const u8 *)&mac_addr0;
+	dest[0] = hw_addr[3];
+	dest[1] = hw_addr[2];
+	dest[2] = hw_addr[1];
+	dest[3] = hw_addr[0];
+
+	hw_addr = (const u8 *)&mac_addr1;
+	dest[4] = hw_addr[1];
+	dest[5] = hw_addr[0];
+}
+
+static void iwl_set_hw_address_from_csr(struct iwl_trans *trans,
+					struct iwl_nvm_data *data)
+{
+	__le32 mac_addr0 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR0_STRAP));
+	__le32 mac_addr1 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR1_STRAP));
+
+	/* If OEM did not fuse address - get it from OTP */
+	if (!mac_addr0 && !mac_addr1) {
+		mac_addr0 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR0_OTP));
+		mac_addr1 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR1_OTP));
+	}
+
+	iwl_flip_hw_address(mac_addr0, mac_addr1, data->hw_addr);
+}
+
 static void iwl_set_hw_address_family_8000(struct iwl_trans *trans,
 					   const struct iwl_cfg *cfg,
 					   struct iwl_nvm_data *data,
@@ -564,21 +596,8 @@ static void iwl_set_hw_address_family_8000(struct iwl_trans *trans,
 						WFMP_MAC_ADDR_0));
 		__le32 mac_addr1 = cpu_to_le32(iwl_trans_read_prph(trans,
 						WFMP_MAC_ADDR_1));
-		/* read the MAC address from HW resisters */
-		hw_addr = (const u8 *)&mac_addr0;
-		data->hw_addr[0] = hw_addr[3];
-		data->hw_addr[1] = hw_addr[2];
-		data->hw_addr[2] = hw_addr[1];
-		data->hw_addr[3] = hw_addr[0];
-
-		hw_addr = (const u8 *)&mac_addr1;
-		data->hw_addr[4] = hw_addr[1];
-		data->hw_addr[5] = hw_addr[0];
-
-		if (!is_valid_ether_addr(data->hw_addr))
-			IWL_ERR(trans,
-				"mac address (%pM) from hw section is not valid\n",
-				data->hw_addr);
+
+		iwl_flip_hw_address(mac_addr0, mac_addr1, data->hw_addr);
 
 		return;
 	}
@@ -586,12 +605,14 @@ static void iwl_set_hw_address_family_8000(struct iwl_trans *trans,
 	IWL_ERR(trans, "mac address is not found\n");
 }
 
-static void iwl_set_hw_address(struct iwl_trans *trans,
-			       const struct iwl_cfg *cfg,
-			       struct iwl_nvm_data *data, const __le16 *nvm_hw,
-			       const __le16 *mac_override)
+static int iwl_set_hw_address(struct iwl_trans *trans,
+			      const struct iwl_cfg *cfg,
+			      struct iwl_nvm_data *data, const __le16 *nvm_hw,
+			      const __le16 *mac_override)
 {
-	if (cfg->device_family != IWL_DEVICE_FAMILY_8000) {
+	if (cfg->mac_addr_from_csr) {
+		iwl_set_hw_address_from_csr(trans, data);
+	} else if (cfg->device_family != IWL_DEVICE_FAMILY_8000) {
 		const u8 *hw_addr = (const u8 *)(nvm_hw + HW_ADDR);
 
 		/* The byte order is little endian 16 bit, meaning 214365 */
@@ -605,6 +626,13 @@ static void iwl_set_hw_address(struct iwl_trans *trans,
 		iwl_set_hw_address_family_8000(trans, cfg, data,
 					       mac_override, nvm_hw);
 	}
+
+	if (!is_valid_ether_addr(data->hw_addr)) {
+		IWL_ERR(trans, "no valid mac address was found\n");
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 struct iwl_nvm_data *
@@ -680,7 +708,12 @@ iwl_parse_nvm_data(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		ch_section = regulatory;
 	}
 
-	iwl_set_hw_address(trans, cfg, data, nvm_hw, mac_override);
+	/* If no valid mac address was found - bail out */
+	if (iwl_set_hw_address(trans, cfg, data, nvm_hw, mac_override)) {
+		kfree(data);
+		return NULL;
+	}
+
 	iwl_init_sbands(dev, cfg, data, ch_section, tx_chains, rx_chains,
 			lar_fw_supported && lar_enabled);
 	data->calib_version = 255;
-- 
2.5.0

