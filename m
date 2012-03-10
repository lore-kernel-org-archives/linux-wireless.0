Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48736 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab2CJU73 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 15:59:29 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/10] iwlwifi: Add bool mvm_ucode to iwl_fw
Date: Sat, 10 Mar 2012 13:00:15 -0800
Message-Id: <1331413215-10027-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120310_220005_224184_88EC9F5B)
In-Reply-To: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

mvm_ucode is true when mvm TLVs arive.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c |    9 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-fw.h  |    2 ++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 54e0969..6f312c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -636,14 +636,17 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		 case IWL_UCODE_TLV_SEC_RT:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_REGULAR,
 					    tlv_len);
+			drv->fw.mvm_fw = true;
 			break;
 		case IWL_UCODE_TLV_SEC_INIT:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_INIT,
 					    tlv_len);
+			drv->fw.mvm_fw = true;
 			break;
 		case IWL_UCODE_TLV_SEC_WOWLAN:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_WOWLAN,
 					    tlv_len);
+			drv->fw.mvm_fw = true;
 			break;
 		case IWL_UCODE_TLV_DEF_CALIB:
 			if (tlv_len != sizeof(struct iwl_tlv_calib_data))
@@ -870,7 +873,11 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		goto try_again;
 	}
 
-	if (validate_sec_sizes(drv, &pieces, cfg))
+	/*
+	 * In mvm uCode there is no difference between data and instructions
+	 * sections.
+	 */
+	if (!fw->mvm_fw && validate_sec_sizes(drv, &pieces, cfg))
 		goto try_again;
 
 	/* Allocate ucode buffers for card's bus-master loading ... */
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 5d634f3..8e36bdc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -170,6 +170,8 @@ struct iwl_fw {
 
 	u64 default_calib[IWL_UCODE_TYPE_MAX];
 	u32 phy_config;
+
+	bool mvm_fw;
 };
 
 #endif  /* __iwl_fw_h__ */
-- 
1.7.0.4

