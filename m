Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59286 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751356AbdFEUmi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:42:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Beni Lev <beni.lev@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:00 +0300
Message-Id: <20170605204218.30151-8-luca@coelho.fi> (sfid-20170605_224250_944572_C155C992)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 07/25] iwlwifi: mvm: add TLV for NAN API differentiation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

Due to NAN FW API change, add TLV in order to distiguish between the
2 API versions

Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index c178c8f32466..52616f3c0184 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -244,6 +244,7 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_TKIP_MIC_KEYS: This ucode supports version 2 of
  *	ADD_MODIFY_STA_KEY_API_S_VER_2.
  * @IWL_UCODE_TLV_API_STA_TYPE: This ucode supports station type assignement.
+ * @IWL_UCODE_TLV_API_NAN2_VER2: This ucode supports NAN API version 2
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -255,6 +256,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_SCAN_TSF_REPORT	= (__force iwl_ucode_tlv_api_t)28,
 	IWL_UCODE_TLV_API_TKIP_MIC_KEYS		= (__force iwl_ucode_tlv_api_t)29,
 	IWL_UCODE_TLV_API_STA_TYPE		= (__force iwl_ucode_tlv_api_t)30,
+	IWL_UCODE_TLV_API_NAN2_VER2		= (__force iwl_ucode_tlv_api_t)31,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
-- 
2.11.0
