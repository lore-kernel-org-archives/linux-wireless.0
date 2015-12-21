Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:46048 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbbLUUv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Golan Ben-Ami <golan.ben.ami@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/45] iwlwifi: expose fw usniffer mode to more utilities
Date: Mon, 21 Dec 2015 22:50:21 +0200
Message-Id: <1450731046-2796-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215143_944624_6E6618C0)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

Today, in order to configure fw in usniffer mode, the ucode
must have the corresponding tlv, which is revealed to the driver
while parsing the ucode.

Expose the mode of the usniffer to other utilities in the driver
(other than the ucode parser) by passing back a pointer to the value.
This can be very useful for allowing configuring the fw dbg data
using an external configuration file, because this configuration
depends on the fw usniffer mode.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 16756f0..47a83ab 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -594,7 +594,8 @@ static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
 static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				const struct firmware *ucode_raw,
 				struct iwl_firmware_pieces *pieces,
-				struct iwl_ucode_capabilities *capa)
+				struct iwl_ucode_capabilities *capa,
+				bool *usniffer_images)
 {
 	struct iwl_tlv_ucode_header *ucode = (void *)ucode_raw->data;
 	struct iwl_ucode_tlv *tlv;
@@ -607,7 +608,6 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	char buildstr[25];
 	u32 build, paging_mem_size;
 	int num_of_cpus;
-	bool usniffer_images = false;
 	bool usniffer_req = false;
 	bool gscan_capa = false;
 
@@ -980,7 +980,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			break;
 			}
 		case IWL_UCODE_TLV_SEC_RT_USNIFFER:
-			usniffer_images = true;
+			*usniffer_images = true;
 			iwl_store_ucode_sec(pieces, tlv_data,
 					    IWL_UCODE_REGULAR_USNIFFER,
 					    tlv_len);
@@ -1031,7 +1031,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		}
 	}
 
-	if (usniffer_req && !usniffer_images) {
+	if (usniffer_req && !*usniffer_images) {
 		IWL_ERR(drv,
 			"user selected to work with usniffer but usniffer image isn't available in ucode package\n");
 		return -EINVAL;
@@ -1192,6 +1192,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	u32 api_ver;
 	int i;
 	bool load_module = false;
+	bool usniffer_images = false;
 
 	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
 	fw->ucode_capa.standard_phy_calibration_size =
@@ -1229,7 +1230,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		err = iwl_parse_v1_v2_firmware(drv, ucode_raw, pieces);
 	else
 		err = iwl_parse_tlv_firmware(drv, ucode_raw, pieces,
-					     &fw->ucode_capa);
+					     &fw->ucode_capa, &usniffer_images);
 
 	if (err)
 		goto try_again;
-- 
2.5.0

