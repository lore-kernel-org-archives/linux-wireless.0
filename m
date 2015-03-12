Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbbCLNGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:02 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/49] iwlwifi: use correct NVM offset for LAR enable for new NVMs
Date: Thu, 12 Mar 2015 15:04:14 +0200
Message-Id: <1426165474-25586-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143418_787353_2E74C04A)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

New NVM versions in LnP platforms have the lar_enable bits in a different
offset.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 54e447b..b372105 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -110,7 +110,8 @@ enum family_8000_nvm_offsets {
 
 	/* NVM REGULATORY -Section offset (in words) definitions */
 	NVM_CHANNELS_FAMILY_8000 = 0,
-	NVM_LAR_OFFSET_FAMILY_8000 = 0x4C7,
+	NVM_LAR_OFFSET_FAMILY_8000_OLD = 0x4C7,
+	NVM_LAR_OFFSET_FAMILY_8000 = 0x507,
 	NVM_LAR_ENABLED_FAMILY_8000 = 0x7,
 
 	/* NVM calibration section offset (in words) definitions */
@@ -656,8 +657,11 @@ iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
 		iwl_init_sbands(dev, cfg, data, nvm_sw,
 				tx_chains, rx_chains, lar_fw_supported);
 	} else {
-		lar_config = le16_to_cpup(regulatory +
-					  NVM_LAR_OFFSET_FAMILY_8000);
+		u16 lar_offset = data->nvm_version < 0xE39 ?
+				 NVM_LAR_OFFSET_FAMILY_8000_OLD :
+				 NVM_LAR_OFFSET_FAMILY_8000;
+
+		lar_config = le16_to_cpup(regulatory + lar_offset);
 		data->lar_enabled = !!(lar_config &
 				       NVM_LAR_ENABLED_FAMILY_8000);
 
-- 
1.9.1

