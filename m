Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54326 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954311AbdDYUaH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:30:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:43 +0300
Message-Id: <20170425202243.7844-26-luca@coelho.fi> (sfid-20170425_223011_414216_056204DB)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 25/25] iwlwifi: adjust NVM parsing APIs for new a000 method
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In a000 devices we will get all nvm data from the firmware,
and can save most of the parsing.
Export two APIs that op mode will still use.
Adjust API of init_sbands to be independent of NVM file structure
so it can be used by op mode as well.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 32 +++++++++-------------
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h | 16 ++++++++++-
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 3bd6fc1b76d4..721ae6bef5da 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,6 +34,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -438,25 +439,16 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 	vht_cap->vht_mcs.tx_mcs_map = vht_cap->vht_mcs.rx_mcs_map;
 }
 
-static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
-			    struct iwl_nvm_data *data,
-			    const __le16 *ch_section,
-			    u8 tx_chains, u8 rx_chains, bool lar_supported)
+void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
+		     struct iwl_nvm_data *data, const __le16 *nvm_ch_flags,
+		     u8 tx_chains, u8 rx_chains, bool lar_supported)
 {
 	int n_channels;
 	int n_used = 0;
 	struct ieee80211_supported_band *sband;
 
-	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
-		n_channels = iwl_init_channel_map(
-				dev, cfg, data,
-				&ch_section[NVM_CHANNELS], lar_supported);
-	else
-		n_channels = iwl_init_channel_map(
-				dev, cfg, data,
-				&ch_section[NVM_CHANNELS_FAMILY_8000],
-				lar_supported);
-
+	n_channels = iwl_init_channel_map(dev, cfg, data, nvm_ch_flags,
+					  lar_supported);
 	sband = &data->bands[NL80211_BAND_2GHZ];
 	sband->band = NL80211_BAND_2GHZ;
 	sband->bitrates = &iwl_cfg80211_rates[RATES_24_OFFS];
@@ -482,6 +474,7 @@ static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
 		IWL_ERR_DEV(dev, "NVM: used only %d of %d channels\n",
 			    n_used, n_channels);
 }
+IWL_EXPORT_SYMBOL(iwl_init_sbands);
 
 static int iwl_get_sku(const struct iwl_cfg *cfg, const __le16 *nvm_sw,
 		       const __le16 *phy_sku)
@@ -559,8 +552,8 @@ static void iwl_flip_hw_address(__le32 mac_addr0, __le32 mac_addr1, u8 *dest)
 	dest[5] = hw_addr[0];
 }
 
-static void iwl_set_hw_address_from_csr(struct iwl_trans *trans,
-					struct iwl_nvm_data *data)
+void iwl_set_hw_address_from_csr(struct iwl_trans *trans,
+				 struct iwl_nvm_data *data)
 {
 	__le32 mac_addr0 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR0_STRAP));
 	__le32 mac_addr1 = cpu_to_le32(iwl_read32(trans, CSR_MAC_ADDR1_STRAP));
@@ -578,6 +571,7 @@ static void iwl_set_hw_address_from_csr(struct iwl_trans *trans,
 
 	iwl_flip_hw_address(mac_addr0, mac_addr1, data->hw_addr);
 }
+IWL_EXPORT_SYMBOL(iwl_set_hw_address_from_csr);
 
 static void iwl_set_hw_address_family_8000(struct iwl_trans *trans,
 					   const struct iwl_cfg *cfg,
@@ -718,7 +712,7 @@ iwl_parse_nvm_data(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		data->xtal_calib[0] = *(nvm_calib + XTAL_CALIB);
 		data->xtal_calib[1] = *(nvm_calib + XTAL_CALIB + 1);
 		lar_enabled = true;
-		ch_section = nvm_sw;
+		ch_section = &nvm_sw[NVM_CHANNELS];
 	} else {
 		u16 lar_offset = data->nvm_version < 0xE39 ?
 				 NVM_LAR_OFFSET_FAMILY_8000_OLD :
@@ -728,7 +722,7 @@ iwl_parse_nvm_data(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		data->lar_enabled = !!(lar_config &
 				       NVM_LAR_ENABLED_FAMILY_8000);
 		lar_enabled = data->lar_enabled;
-		ch_section = regulatory;
+		ch_section = &regulatory[NVM_CHANNELS_FAMILY_8000];
 	}
 
 	/* If no valid mac address was found - bail out */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
index 7249e5b403f4..3fd6506a02ab 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2015 Intel Corporation. All rights reserved.
- * Copyright(c) 2016        Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -82,6 +83,19 @@ iwl_parse_nvm_data(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		   u8 tx_chains, u8 rx_chains, bool lar_fw_supported);
 
 /**
+ * iwl_set_hw_address_from_csr - sets HW address for 9000 devices and on
+ */
+void iwl_set_hw_address_from_csr(struct iwl_trans *trans,
+				 struct iwl_nvm_data *data);
+
+/**
+ * iwl_init_sbands - parse and set all channel profiles
+ */
+void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
+		     struct iwl_nvm_data *data, const __le16 *nvm_ch_flags,
+		     u8 tx_chains, u8 rx_chains, bool lar_supported);
+
+/**
  * iwl_parse_mcc_info - parse MCC (mobile country code) info coming from FW
  *
  * This function parses the regulatory channel data received as a
-- 
2.11.0
