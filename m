Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42798 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaEGTxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:53 -0400
Received: by mail-wi0-f174.google.com with SMTP id r20so6410681wiv.13
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:52 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/23] iwlwifi: mvm: select the MAC address according to priority
Date: Wed,  7 May 2014 22:52:50 +0300
Message-Id: <1399492380-12050-13-git-send-email-egrumbach@gmail.com> (sfid-20140507_215414_206820_61511ECA)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

For family 8000 products, the driver should take the MAC
address from the mac_override section and only if this
section is empty it should take it from the HW section.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 46 +++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/nvm.c       |  9 +++++-
 2 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 4049c0d..49963e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -62,6 +62,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/etherdevice.h>
 #include "iwl-drv.h"
 #include "iwl-modparams.h"
 #include "iwl-nvm-parse.h"
@@ -450,13 +451,7 @@ static void iwl_set_hw_address(const struct iwl_cfg *cfg,
 			       struct iwl_nvm_data *data,
 			       const __le16 *nvm_sec)
 {
-	u8 hw_addr[ETH_ALEN];
-
-	if (cfg->device_family != IWL_DEVICE_FAMILY_8000)
-		memcpy(hw_addr, nvm_sec + HW_ADDR, ETH_ALEN);
-	else
-		memcpy(hw_addr, nvm_sec + MAC_ADDRESS_OVERRIDE_FAMILY_8000,
-		       ETH_ALEN);
+	const u8 *hw_addr = (const u8 *)(nvm_sec + HW_ADDR);
 
 	/* The byte order is little endian 16 bit, meaning 214365 */
 	data->hw_addr[0] = hw_addr[1];
@@ -467,6 +462,41 @@ static void iwl_set_hw_address(const struct iwl_cfg *cfg,
 	data->hw_addr[5] = hw_addr[4];
 }
 
+static void iwl_set_hw_address_family_8000(const struct iwl_cfg *cfg,
+					   struct iwl_nvm_data *data,
+					   const __le16 *mac_override,
+					   const __le16 *nvm_hw)
+{
+	const u8 *hw_addr;
+
+	if (mac_override) {
+		hw_addr = (const u8 *)(mac_override +
+				 MAC_ADDRESS_OVERRIDE_FAMILY_8000);
+
+		/* The byte order is little endian 16 bit, meaning 214365 */
+		data->hw_addr[0] = hw_addr[1];
+		data->hw_addr[1] = hw_addr[0];
+		data->hw_addr[2] = hw_addr[3];
+		data->hw_addr[3] = hw_addr[2];
+		data->hw_addr[4] = hw_addr[5];
+		data->hw_addr[5] = hw_addr[4];
+
+		if (is_valid_ether_addr(hw_addr))
+			return;
+	}
+
+	/* take the MAC address from the OTP */
+	hw_addr = (const u8 *)(nvm_hw + HW_ADDR0_FAMILY_8000);
+	data->hw_addr[0] = hw_addr[3];
+	data->hw_addr[1] = hw_addr[2];
+	data->hw_addr[2] = hw_addr[1];
+	data->hw_addr[3] = hw_addr[0];
+
+	hw_addr = (const u8 *)(nvm_hw + HW_ADDR1_FAMILY_8000);
+	data->hw_addr[4] = hw_addr[1];
+	data->hw_addr[5] = hw_addr[0];
+}
+
 struct iwl_nvm_data *
 iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		   const __le16 *nvm_hw, const __le16 *nvm_sw,
@@ -526,7 +556,7 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 				rx_chains);
 	} else {
 		/* MAC address in family 8000 */
-		iwl_set_hw_address(cfg, data, mac_override);
+		iwl_set_hw_address_family_8000(cfg, data, mac_override, nvm_hw);
 
 		iwl_init_sbands(dev, cfg, data, regulatory,
 				sku & NVM_SKU_CAP_11AC_ENABLE, tx_chains,
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 2cb6c29..6d0e659 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -238,13 +238,20 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 			return NULL;
 		}
 	} else {
+		/* SW and REGULATORY sections are mandatory */
 		if (!mvm->nvm_sections[NVM_SECTION_TYPE_SW].data ||
-		    !mvm->nvm_sections[NVM_SECTION_TYPE_MAC_OVERRIDE].data ||
 		    !mvm->nvm_sections[NVM_SECTION_TYPE_REGULATORY].data) {
 			IWL_ERR(mvm,
 				"Can't parse empty family 8000 NVM sections\n");
 			return NULL;
 		}
+		/* MAC_OVERRIDE or at least HW section must exist */
+		if (!mvm->cfg->nvm_hw_section_num &&
+		    !mvm->nvm_sections[NVM_SECTION_TYPE_MAC_OVERRIDE].data) {
+			IWL_ERR(mvm,
+				"Can't parse mac_address, empty sections\n");
+			return NULL;
+		}
 	}
 
 	if (WARN_ON(!mvm->cfg))
-- 
1.8.3.2

