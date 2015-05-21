Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5409 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422755AbbEUTxO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 15:53:14 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/10] iwlwifi: mvm: forbid MIMO on devices that don't support it
Date: Thu, 21 May 2015 22:53:01 +0300
Message-Id: <1432237990-5890-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150521_215323_508932_66F4A919)
In-Reply-To: <1432237819.26813.4.camel@intel.com>
References: <1432237819.26813.4.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are devices that forbid MIMO by the mean of the NVM.
Detect thoses devices and forbid MIMO otherwise the firmware
would crash. STBC is still allowed on these devices.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |  5 +++++
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h |  3 +++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    | 19 +++++++++++++------
 drivers/net/wireless/iwlwifi/mvm/rs.c           |  3 +++
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index 41ff85d..21302b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -748,6 +750,9 @@ void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 		return;
 	}
 
+	if (data->sku_cap_mimo_disabled)
+		rx_chains = 1;
+
 	ht_info->ht_supported = true;
 	ht_info->cap = IEEE80211_HT_CAP_DSSSCCK40;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
index 5234a0b..750c8c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -84,6 +86,7 @@ struct iwl_nvm_data {
 	bool sku_cap_11ac_enable;
 	bool sku_cap_amt_enable;
 	bool sku_cap_ipan_enable;
+	bool sku_cap_mimo_disabled;
 
 	u16 radio_cfg_type;
 	u8 radio_cfg_step;
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 83903a5..cf86f3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -116,10 +116,11 @@ enum family_8000_nvm_offsets {
 
 /* SKU Capabilities (actual values from NVM definition) */
 enum nvm_sku_bits {
-	NVM_SKU_CAP_BAND_24GHZ	= BIT(0),
-	NVM_SKU_CAP_BAND_52GHZ	= BIT(1),
-	NVM_SKU_CAP_11N_ENABLE	= BIT(2),
-	NVM_SKU_CAP_11AC_ENABLE	= BIT(3),
+	NVM_SKU_CAP_BAND_24GHZ		= BIT(0),
+	NVM_SKU_CAP_BAND_52GHZ		= BIT(1),
+	NVM_SKU_CAP_11N_ENABLE		= BIT(2),
+	NVM_SKU_CAP_11AC_ENABLE		= BIT(3),
+	NVM_SKU_CAP_MIMO_DISABLE	= BIT(5),
 };
 
 /*
@@ -368,6 +369,11 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 	if (cfg->ht_params->ldpc)
 		vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC;
 
+	if (data->sku_cap_mimo_disabled) {
+		num_rx_ants = 1;
+		num_tx_ants = 1;
+	}
+
 	if (num_tx_ants > 1)
 		vht_cap->cap |= IEEE80211_VHT_CAP_TXSTBC;
 	else
@@ -610,6 +616,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		data->sku_cap_11n_enable = false;
 	data->sku_cap_11ac_enable = data->sku_cap_11n_enable &&
 				    (sku & NVM_SKU_CAP_11AC_ENABLE);
+	data->sku_cap_mimo_disabled = sku & NVM_SKU_CAP_MIMO_DISABLE;
 
 	data->n_hw_addrs = iwl_get_n_hw_addrs(cfg, nvm_sw);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index f9928f2..33cd68a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -180,6 +180,9 @@ static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	if (iwl_mvm_vif_low_latency(mvmvif) && mvmsta->vif->p2p)
 		return false;
 
+	if (mvm->nvm_data->sku_cap_mimo_disabled)
+		return false;
+
 	return true;
 }
 
-- 
2.1.4

