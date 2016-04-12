Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11129 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167AbcDLIQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 04:16:58 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/4] iwlwifi: 8000: fix MODULE_FIRMWARE input
Date: Tue, 12 Apr 2016 11:16:50 +0300
Message-Id: <1460449011-8417-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160412_101713_149179_79A4EA02)
In-Reply-To: <1460448889.2630.12.camel@intel.com>
References: <1460448889.2630.12.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The firwmare name for 8000 is iwlwifi-8000C. The C is
appended based on a value read from a register. This
allows to load different firwmare versions based on
the hardware step during development. Now that the
hardware development is completed, we can hard code
the 'C' and along the way, fix the input to
MODULE_FIRMWARE.

This fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=116041

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  | 13 -------------
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index 97be104..cf48122 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -93,7 +93,7 @@
 #define IWL8260_SMEM_OFFSET		0x400000
 #define IWL8260_SMEM_LEN		0x68000
 
-#define IWL8000_FW_PRE "iwlwifi-8000"
+#define IWL8000_FW_PRE "iwlwifi-8000C"
 #define IWL8000_MODULE_FIRMWARE(api) \
 	IWL8000_FW_PRE "-" __stringify(api) ".ucode"
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 33d0d51..9e45bf9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -238,19 +238,6 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 	snprintf(drv->firmware_name, sizeof(drv->firmware_name), "%s%s.ucode",
 		 name_pre, tag);
 
-	/*
-	 * Starting 8000B - FW name format has changed. This overwrites the
-	 * previous name and uses the new format.
-	 */
-	if (drv->trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
-		char rev_step = 'A' + CSR_HW_REV_STEP(drv->trans->hw_rev);
-
-		if (rev_step != 'A')
-			snprintf(drv->firmware_name,
-				 sizeof(drv->firmware_name), "%s%c-%s.ucode",
-				 name_pre, rev_step, tag);
-	}
-
 	IWL_DEBUG_INFO(drv, "attempting to load firmware %s'%s'\n",
 		       (drv->fw_index == UCODE_EXPERIMENTAL_INDEX)
 				? "EXPERIMENTAL " : "",
-- 
2.5.0

