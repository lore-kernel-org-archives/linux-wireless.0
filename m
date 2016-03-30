Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:7889 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbcC3OGL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:11 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/43] iwlwifi: mvm: update GSCAN capabilities
Date: Wed, 30 Mar 2016 17:04:54 +0300
Message-Id: <1459346715-7954-22-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160619_824254_0BF26DB0)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Gscan capabilities were updated with new capabilities supported
by the device. Update GSCAN capabilities TLV.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 9c2a2fd..7cd17f0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1060,11 +1060,18 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		return -EINVAL;
 	}
 
-	if (WARN(fw_has_capa(capa, IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT) &&
-		 !gscan_capa,
-		 "GSCAN is supported but capabilities TLV is unavailable\n"))
+	/*
+	 * If ucode advertises that it supports GSCAN but GSCAN
+	 * capabilities TLV is not present, or if it has an old format,
+	 * warn and continue without GSCAN.
+	 */
+	if (fw_has_capa(capa, IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT) &&
+	    !gscan_capa) {
+		IWL_DEBUG_INFO(drv,
+			       "GSCAN is supported but capabilities TLV is unavailable\n");
 		__clear_bit((__force long)IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT,
 			    capa->_capa);
+	}
 
 	return 0;
 
-- 
2.5.0

