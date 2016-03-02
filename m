Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1927 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbcCBH6N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:58:13 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Golan Ben-Ami <golan.ben.ami@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/43] iwlwifi: support ucode with d0 unified image - regular and usniffer
Date: Wed,  2 Mar 2016 09:56:37 +0200
Message-Id: <1456905404-14435-36-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085950_481601_F9D9E21B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

Till today, the ucode consisted of two d0 images - regular,
in which the usniffer wasn't enabled, and usniffer, in which the
usniffer logs were enabled.
Lately, the two images were unified, so there is only one d0 image,
in which the usniffer logs are enabled.

Add new TLV capability for supporting the consolidated images
(set 2, bit 13).

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c     | 3 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c      | 4 +++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index ab4c2a0..ee4ffa5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1033,7 +1033,8 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		}
 	}
 
-	if (usniffer_req && !*usniffer_images) {
+	if (!fw_has_capa(capa, IWL_UCODE_TLV_CAPA_USNIFFER_UNIFIED) &&
+	    usniffer_req && !*usniffer_images) {
 		IWL_ERR(drv,
 			"user selected to work with usniffer but usniffer image isn't available in ucode package\n");
 		return -EINVAL;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 63dc109..5f69bf5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -322,6 +322,8 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_TEMP_THS_REPORT_SUPPORT: supports temperature
  *	thresholds reporting
  * @IWL_UCODE_TLV_CAPA_CTDP_SUPPORT: supports cTDP command
+ * @IWL_UCODE_TLV_CAPA_USNIFFER_UNIFIED: supports usniffer enabled in
+ *	regular image.
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -358,6 +360,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_CT_KILL_BY_FW		= (__force iwl_ucode_tlv_capa_t)74,
 	IWL_UCODE_TLV_CAPA_TEMP_THS_REPORT_SUPPORT	= (__force iwl_ucode_tlv_capa_t)75,
 	IWL_UCODE_TLV_CAPA_CTDP_SUPPORT			= (__force iwl_ucode_tlv_capa_t)76,
+	IWL_UCODE_TLV_CAPA_USNIFFER_UNIFIED		= (__force iwl_ucode_tlv_capa_t)77,
 
 	NUM_IWL_UCODE_TLV_CAPA
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 05475a2..f075c36 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -537,7 +537,9 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	struct iwl_sf_region st_fwrd_space;
 
 	if (ucode_type == IWL_UCODE_REGULAR &&
-	    iwl_fw_dbg_conf_usniffer(mvm->fw, FW_DBG_START_FROM_ALIVE))
+	    iwl_fw_dbg_conf_usniffer(mvm->fw, FW_DBG_START_FROM_ALIVE) &&
+	    !(fw_has_capa(&mvm->fw->ucode_capa,
+			  IWL_UCODE_TLV_CAPA_USNIFFER_UNIFIED)))
 		fw = iwl_get_ucode_image(mvm, IWL_UCODE_REGULAR_USNIFFER);
 	else
 		fw = iwl_get_ucode_image(mvm, ucode_type);
-- 
2.5.0

