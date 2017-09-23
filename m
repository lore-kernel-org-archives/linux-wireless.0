Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.linuxprofi.at ([93.83.54.199]:40780 "EHLO
        zimbra.linuxprofi.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbdIWKhK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Sep 2017 06:37:10 -0400
From: =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph@boehmwalder.at>
To: johannes.berg@intel.com
Cc: emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vget.kenrel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph@boehmwalder.at>
Subject: [PATCH] wireless: iwlwifi: fix minor code style issues
Date: Sat, 23 Sep 2017 12:31:12 +0200
Message-Id: <20170923103112.1311-1-christoph@boehmwalder.at> (sfid-20170923_123729_976958_53DB0B0F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes three trivial issues as reported by checkpatch.pl, namely two
switch/case indentation issues and one alignment issue in a multiline comment.

Signed-off-by: Christoph Böhmwalder <christoph@boehmwalder.at>
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
2.13.5
