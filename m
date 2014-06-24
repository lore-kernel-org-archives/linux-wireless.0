Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53360 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbaFXTwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:49 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so6520536wib.5
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:48 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/27] iwlwifi: mvm: fix bug in set_hw_address function
Date: Tue, 24 Jun 2014 22:52:08 +0300
Message-Id: <1403639541-4621-14-git-send-email-egrumbach@gmail.com> (sfid-20140624_215253_300938_B06252CB)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Don't use nvm_hw pointer if it is NULL. Print an error
message if the MAC address isn't valid.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 34 ++++++++++++++++++----------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 0e3322a..f0ae038 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -476,7 +476,8 @@ static void iwl_set_hw_address(const struct iwl_cfg *cfg,
 	data->hw_addr[5] = hw_addr[4];
 }
 
-static void iwl_set_hw_address_family_8000(const struct iwl_cfg *cfg,
+static void iwl_set_hw_address_family_8000(struct device *dev,
+					   const struct iwl_cfg *cfg,
 					   struct iwl_nvm_data *data,
 					   const __le16 *mac_override,
 					   const __le16 *nvm_hw)
@@ -495,20 +496,28 @@ static void iwl_set_hw_address_family_8000(const struct iwl_cfg *cfg,
 		data->hw_addr[4] = hw_addr[5];
 		data->hw_addr[5] = hw_addr[4];
 
-		if (is_valid_ether_addr(hw_addr))
+		if (is_valid_ether_addr(data->hw_addr))
 			return;
+
+		IWL_ERR_DEV(dev,
+			    "mac address from nvm override section is not valid\n");
 	}
 
-	/* take the MAC address from the OTP */
-	hw_addr = (const u8 *)(nvm_hw + HW_ADDR0_FAMILY_8000);
-	data->hw_addr[0] = hw_addr[3];
-	data->hw_addr[1] = hw_addr[2];
-	data->hw_addr[2] = hw_addr[1];
-	data->hw_addr[3] = hw_addr[0];
+	if (nvm_hw) {
+		/* take the MAC address from the OTP */
+		hw_addr = (const u8 *)(nvm_hw + HW_ADDR0_FAMILY_8000);
+		data->hw_addr[0] = hw_addr[3];
+		data->hw_addr[1] = hw_addr[2];
+		data->hw_addr[2] = hw_addr[1];
+		data->hw_addr[3] = hw_addr[0];
+
+		hw_addr = (const u8 *)(nvm_hw + HW_ADDR1_FAMILY_8000);
+		data->hw_addr[4] = hw_addr[1];
+		data->hw_addr[5] = hw_addr[0];
+		return;
+	}
 
-	hw_addr = (const u8 *)(nvm_hw + HW_ADDR1_FAMILY_8000);
-	data->hw_addr[4] = hw_addr[1];
-	data->hw_addr[5] = hw_addr[0];
+	IWL_ERR_DEV(dev, "mac address is not found\n");
 }
 
 struct iwl_nvm_data *
@@ -570,7 +579,8 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 				rx_chains);
 	} else {
 		/* MAC address in family 8000 */
-		iwl_set_hw_address_family_8000(cfg, data, mac_override, nvm_hw);
+		iwl_set_hw_address_family_8000(dev, cfg, data, mac_override,
+					       nvm_hw);
 
 		iwl_init_sbands(dev, cfg, data, regulatory,
 				sku & NVM_SKU_CAP_11AC_ENABLE, tx_chains,
-- 
1.8.3.2

