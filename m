Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11374 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbbLAJ7K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:10 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Moshe Harel <moshe.harel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/41] iwlwifi: nvm: fix up phy section when reading it
Date: Tue,  1 Dec 2015 11:58:27 +0200
Message-Id: <1448963947-24302-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105915_675170_2F836B27)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is a workaround to an OTP bug. In Series 8000 1x1, the OTP
0xA052 defines 2x2 antenna configuration. This workaround overrides
the decision based on HW id and on MIMO disabled bit which is
correct in the OTP and set to disabled. This fixes the previous
workaround "force 1x1 antenna in Series 8000".

Signed-off-by: Moshe Harel <moshe.harel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 15 +-----------
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       | 27 +++++++++++++++++++---
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index d829849..3b8e85e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -580,15 +580,13 @@ static void iwl_set_hw_address_family_8000(struct device *dev,
 	IWL_ERR_DEV(dev, "mac address is not found\n");
 }
 
-#define IWL_4165_DEVICE_ID 0x5501
-
 struct iwl_nvm_data *
 iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, const __le16 *phy_sku,
 		   u8 tx_chains, u8 rx_chains, bool lar_fw_supported,
-		   u32 mac_addr0, u32 mac_addr1, u32 hw_id)
+		   u32 mac_addr0, u32 mac_addr1)
 {
 	struct iwl_nvm_data *data;
 	u32 sku;
@@ -627,17 +625,6 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 				    (sku & NVM_SKU_CAP_11AC_ENABLE);
 	data->sku_cap_mimo_disabled = sku & NVM_SKU_CAP_MIMO_DISABLE;
 
-	/*
-	 * OTP 0x52 bug work around
-	 * define antenna 1x1 according to MIMO disabled
-	 */
-	if (hw_id == IWL_4165_DEVICE_ID && data->sku_cap_mimo_disabled) {
-		data->valid_tx_ant = ANT_B;
-		data->valid_rx_ant = ANT_B;
-		tx_chains = ANT_B;
-		rx_chains = ANT_B;
-	}
-
 	data->n_hw_addrs = iwl_get_n_hw_addrs(cfg, nvm_sw);
 
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000) {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
index 9f44d81..822ba52 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
@@ -79,7 +79,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_calib, const __le16 *regulatory,
 		   const __le16 *mac_override, const __le16 *phy_sku,
 		   u8 tx_chains, u8 rx_chains, bool lar_fw_supported,
-		   u32 mac_addr0, u32 mac_addr1, u32 hw_id);
+		   u32 mac_addr0, u32 mac_addr1);
 
 /**
  * iwl_parse_mcc_info - parse MCC (mobile country code) info coming from FW
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 2ee0f6f..1edcfcc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -210,6 +210,19 @@ static int iwl_nvm_write_section(struct iwl_mvm *mvm, u16 section,
 	return 0;
 }
 
+static void iwl_mvm_nvm_fixups(struct iwl_mvm *mvm, unsigned int section,
+			       u8 *data, unsigned int len)
+{
+#define IWL_4165_DEVICE_ID	0x5501
+#define NVM_SKU_CAP_MIMO_DISABLE BIT(5)
+
+	if (section == NVM_SECTION_TYPE_PHY_SKU &&
+	    mvm->trans->hw_id == IWL_4165_DEVICE_ID && data && len >= 5 &&
+	    (data[4] & NVM_SKU_CAP_MIMO_DISABLE))
+		/* OTP 0x52 bug work around: it's a 1x1 device */
+		data[3] = ANT_B | (ANT_B << 4);
+}
+
 /*
  * Reads an NVM section completely.
  * NICs prior to 7000 family doesn't have a real NVM, but just read
@@ -250,6 +263,8 @@ static int iwl_nvm_read_section(struct iwl_mvm *mvm, u16 section,
 		offset += ret;
 	}
 
+	iwl_mvm_nvm_fixups(mvm, section, data, offset);
+
 	IWL_DEBUG_EEPROM(mvm->trans->dev,
 			 "NVM section %d read completed\n", section);
 	return offset;
@@ -316,8 +331,7 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 	return iwl_parse_nvm_data(mvm->trans->dev, mvm->cfg, hw, sw, calib,
 				  regulatory, mac_override, phy_sku,
 				  mvm->fw->valid_tx_ant, mvm->fw->valid_rx_ant,
-				  lar_enabled, mac_addr0, mac_addr1,
-				  mvm->trans->hw_id);
+				  lar_enabled, mac_addr0, mac_addr1);
 }
 
 #define MAX_NVM_FILE_LEN	16384
@@ -353,7 +367,8 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 		__le16 word2;
 		u8 data[];
 	} *file_sec;
-	const u8 *eof, *temp;
+	const u8 *eof;
+	u8 *temp;
 	int max_section_size;
 	const __le32 *dword_buff;
 
@@ -483,6 +498,9 @@ static int iwl_mvm_read_external_nvm(struct iwl_mvm *mvm)
 			ret = -ENOMEM;
 			break;
 		}
+
+		iwl_mvm_nvm_fixups(mvm, section_id, temp, section_size);
+
 		kfree(mvm->nvm_sections[section_id].data);
 		mvm->nvm_sections[section_id].data = temp;
 		mvm->nvm_sections[section_id].length = section_size;
@@ -548,6 +566,9 @@ int iwl_nvm_init(struct iwl_mvm *mvm, bool read_nvm_from_nic)
 				ret = -ENOMEM;
 				break;
 			}
+
+			iwl_mvm_nvm_fixups(mvm, section, temp, ret);
+
 			mvm->nvm_sections[section].data = temp;
 			mvm->nvm_sections[section].length = ret;
 
-- 
2.5.0

