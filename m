Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36218 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752131AbdI2Qol (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 12:44:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph@boehmwalder.at>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 29 Sep 2017 19:44:09 +0300
Message-Id: <20170929164423.23666-5-luca@coelho.fi> (sfid-20170929_200759_228036_3CC52BF1)
In-Reply-To: <20170929164423.23666-1-luca@coelho.fi>
References: <20170929164423.23666-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 04/18] iwlwifi: fix minor code style issues
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christoph Böhmwalder <christoph@boehmwalder.at>

Fixes three trivial issues as reported by checkpatch.pl, namely two
switch/case indentation issues and one alignment issue in a multiline
comment.

Signed-off-by: Christoph Böhmwalder <christoph@boehmwalder.at>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 99676d6c4713..ccdb247d68c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -832,7 +832,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			capa->standard_phy_calibration_size =
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
-		 case IWL_UCODE_TLV_SEC_RT:
+		case IWL_UCODE_TLV_SEC_RT:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_REGULAR,
 					    tlv_len);
 			drv->fw.type = IWL_FW_MVM;
@@ -864,7 +864,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 						FW_PHY_CFG_RX_CHAIN) >>
 						FW_PHY_CFG_RX_CHAIN_POS;
 			break;
-		 case IWL_UCODE_TLV_SECURE_SEC_RT:
+		case IWL_UCODE_TLV_SECURE_SEC_RT:
 			iwl_store_ucode_sec(pieces, tlv_data, IWL_UCODE_REGULAR,
 					    tlv_len);
 			drv->fw.type = IWL_FW_MVM;
@@ -1335,7 +1335,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 
 	/* Runtime instructions and 2 copies of data:
 	 * 1) unmodified from disk
-	 * 2) backup cache for save/restore during power-downs */
+	 * 2) backup cache for save/restore during power-downs
+	 */
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		if (iwl_alloc_ucode(drv, pieces, i))
 			goto out_free_fw;
-- 
2.14.1
