Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28518 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320AbcAaLGy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:54 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/31] iwlwifi: treat iwl_parse_nvm_data() MAC addr as little endian
Date: Sun, 31 Jan 2016 13:06:18 +0200
Message-Id: <1454238386-27032-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_123653_953800_E996F9CD)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The MAC address parameters passed to iwl_parse_nvm_data() are passed on
to iwl_set_hw_address_family_8000() which treats them as little endian.
Annotate them as such, and add the missing byte-swapping in mvm.

While at it, add the MAC address to the error to make debugging issues
with it easier.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 7 ++++---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       | 8 +++++---
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 7b89bfc..50f4cc6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -539,7 +539,7 @@ static void iwl_set_hw_address_family_8000(struct device *dev,
 					   struct iwl_nvm_data *data,
 					   const __le16 *mac_override,
 					   const __le16 *nvm_hw,
-					   u32 mac_addr0, u32 mac_addr1)
+					   __le32 mac_addr0, __le32 mac_addr1)
 {
 	const u8 *hw_addr;
 
@@ -583,7 +583,8 @@ static void iwl_set_hw_address_family_8000(struct device *dev,
 
 		if (!is_valid_ether_addr(data->hw_addr))
 			IWL_ERR_DEV(dev,
-				    "mac address from hw section is not valid\n");
+				    "mac address (%pM) from hw section is not valid\n",
+				    data->hw_addr);
 
 		return;
 	}
@@ -597,7 +598,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, const __le16 *phy_sku,
 		   u8 tx_chains, u8 rx_chains, bool lar_fw_supported,
-		   u32 mac_addr0, u32 mac_addr1)
+		   __le32 mac_addr0, __le32 mac_addr1)
 {
 	struct iwl_nvm_data *data;
 	u32 sku;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
index 92466ee..4e8e0dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
@@ -79,7 +79,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, const __le16 *phy_sku,
 		   u8 tx_chains, u8 rx_chains, bool lar_fw_supported,
-		   u32 mac_addr0, u32 mac_addr1);
+		   __le32 mac_addr0, __le32 mac_addr1);
 
 /**
  * iwl_parse_mcc_info - parse MCC (mobile country code) info coming from FW
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 7a3da2d..c446e0d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -300,7 +300,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	struct iwl_nvm_section *sections = mvm->nvm_sections;
 	const __le16 *hw, *sw, *calib, *regulatory, *mac_override, *phy_sku;
 	bool lar_enabled;
-	u32 mac_addr0, mac_addr1;
+	__le32 mac_addr0, mac_addr1;
 
 	/* Checking for required sections */
 	if (mvm->trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
@@ -337,8 +337,10 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 		return NULL;
 
 	/* read the mac address from WFMP registers */
-	mac_addr0 = iwl_trans_read_prph(mvm->trans, WFMP_MAC_ADDR_0);
-	mac_addr1 = iwl_trans_read_prph(mvm->trans, WFMP_MAC_ADDR_1);
+	mac_addr0 = cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+						    WFMP_MAC_ADDR_0));
+	mac_addr1 = cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+						    WFMP_MAC_ADDR_1));
 
 	hw = (const __le16 *)sections[mvm->cfg->nvm_hw_section_num].data;
 	sw = (const __le16 *)sections[NVM_SECTION_TYPE_SW].data;
-- 
2.5.0

