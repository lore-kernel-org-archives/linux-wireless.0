Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11129 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932204AbcDLIQ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 04:16:56 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/4] iwlwifi: mvm: avoid to WARN about gscan capabilities
Date: Tue, 12 Apr 2016 11:16:49 +0300
Message-Id: <1460449011-8417-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160412_101703_719324_D5938C1E)
In-Reply-To: <1460448889.2630.12.camel@intel.com>
References: <1460448889.2630.12.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Gscan capabilities were updated with new capabilities supported
by the device. Update GSCAN capabilities TLV and avoid to WARN
if the firmware does not have the new capabilities.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index f899666..33d0d51 100644
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

