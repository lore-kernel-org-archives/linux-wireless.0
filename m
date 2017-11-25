Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47476 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751842AbdKYQez (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 11:34:55 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 18:34:39 +0200
Message-Id: <20171125163444.24258-7-luca@coelho.fi> (sfid-20171125_173519_290648_A6CCE57A)
In-Reply-To: <20171125163444.24258-1-luca@coelho.fi>
References: <20171125163444.24258-1-luca@coelho.fi>
Subject: [PATCH 06/11] iwlwifi: print the version number of the firmware in hex
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Starting from a version 35, the minor version should be
printed in hexa.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 4b224d7d967c..de8f6ae2f51b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -919,9 +919,14 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			minor = le32_to_cpup(ptr++);
 			local_comp = le32_to_cpup(ptr);
 
-			snprintf(drv->fw.fw_version,
-				 sizeof(drv->fw.fw_version), "%u.%u.%u",
-				 major, minor, local_comp);
+			if (major >= 35)
+				snprintf(drv->fw.fw_version,
+					 sizeof(drv->fw.fw_version),
+					"%u.%08x.%u", major, minor, local_comp);
+			else
+				snprintf(drv->fw.fw_version,
+					 sizeof(drv->fw.fw_version),
+					"%u.%u.%u", major, minor, local_comp);
 			break;
 			}
 		case IWL_UCODE_TLV_FW_DBG_DEST: {
-- 
2.15.0
