Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44621 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746AbaJ2LvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:17 -0400
Received: by mail-wg0-f49.google.com with SMTP id x13so3083127wgg.8
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:16 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/25] iwlwifi: always run the secured flow for family 8000
Date: Wed, 29 Oct 2014 13:50:33 +0200
Message-Id: <1414583446-11032-12-git-send-email-egrumbach@gmail.com> (sfid-20141029_125201_576090_03F4820C)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

In the new format the "CSS section" has the same TLV type
as the "mem section". So we need to run the secured flow
for all the 8000 products.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-config.h | 10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-drv.c    |  3 ---
 drivers/net/wireless/iwlwifi/iwl-fw.h     |  1 -
 drivers/net/wireless/iwlwifi/pcie/trans.c | 10 ++++------
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 76d363d..f8aa9cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -87,6 +87,16 @@ enum iwl_device_family {
 	IWL_DEVICE_FAMILY_8000,
 };
 
+static inline bool iwl_has_secure_boot(u32 hw_rev,
+				       enum iwl_device_family family)
+{
+	/* return 1 only for family 8000 B0 */
+	if ((family == IWL_DEVICE_FAMILY_8000) && (hw_rev & 0xC))
+		return 1;
+
+	return 0;
+}
+
 /*
  * LED mode
  *    IWL_LED_DEFAULT:  use device default
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 0f1084f..d9fa8e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -807,19 +807,16 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_REGULAR,
 					    tlv_len);
 			drv->fw.mvm_fw = true;
-			drv->fw.img[IWL_UCODE_REGULAR].is_secure = true;
 			break;
 		case IWL_UCODE_TLV_SECURE_SEC_INIT:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_INIT,
 					    tlv_len);
 			drv->fw.mvm_fw = true;
-			drv->fw.img[IWL_UCODE_INIT].is_secure = true;
 			break;
 		case IWL_UCODE_TLV_SECURE_SEC_WOWLAN:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_WOWLAN,
 					    tlv_len);
 			drv->fw.mvm_fw = true;
-			drv->fw.img[IWL_UCODE_WOWLAN].is_secure = true;
 			break;
 		case IWL_UCODE_TLV_NUM_OF_CPU:
 			if (tlv_len != sizeof(u32))
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 4f6e668..6f7ae5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -227,7 +227,6 @@ struct fw_desc {
 
 struct fw_img {
 	struct fw_desc sec[IWL_UCODE_SECTION_MAX];
-	bool is_secure;
 	bool is_dual_cpus;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index aea0fe9..8027138 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -747,14 +747,11 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 	int first_ucode_section;
 
 	IWL_DEBUG_FW(trans,
-		     "working with %s image\n",
-		     image->is_secure ? "Secured" : "Non Secured");
-	IWL_DEBUG_FW(trans,
 		     "working with %s CPU\n",
 		     image->is_dual_cpus ? "Dual" : "Single");
 
 	/* configure the ucode to be ready to get the secured image */
-	if (image->is_secure) {
+	if (iwl_has_secure_boot(trans->hw_rev, trans->cfg->device_family)) {
 		/* set secure boot inspector addresses */
 		iwl_write_prph(trans,
 			       LMPM_SECURE_INSPECTOR_CODE_ADDR,
@@ -790,7 +787,8 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 			       LMPM_SECURE_CPU2_HDR_MEM_SPACE);
 
 		/* load to FW the binary sections of CPU2 */
-		if (image->is_secure)
+		if (iwl_has_secure_boot(trans->hw_rev,
+					trans->cfg->device_family))
 			ret = iwl_pcie_load_cpu_secured_sections(
 							trans, image, 2,
 							&first_ucode_section);
@@ -821,7 +819,7 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 	else
 		iwl_write32(trans, CSR_RESET, 0);
 
-	if (image->is_secure) {
+	if (iwl_has_secure_boot(trans->hw_rev, trans->cfg->device_family)) {
 		/* wait for image verification to complete  */
 		ret = iwl_poll_prph_bit(trans,
 					LMPM_SECURE_BOOT_CPU1_STATUS_ADDR,
-- 
1.9.1

