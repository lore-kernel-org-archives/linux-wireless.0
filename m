Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45786 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932632AbbIUVBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 17:01:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:52 +0300
Message-Id: <1442869141-31637-12-git-send-email-luca@coelho.fi> (sfid-20150921_230146_223402_AF9BB027)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 12/21] iwlwifi: mvm: remove IWL_UCODE_TLV_API_SINGLE_SCAN_EBS TLV flag
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this flag set.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 2 --
 drivers/net/wireless/iwlwifi/mvm/scan.c    | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 7af0ec2..880962e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -248,7 +248,6 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  *	longer than the passive one, which is essential for fragmented scan.
  * @IWL_UCODE_TLV_API_WIFI_MCC_UPDATE: ucode supports MCC updates with source.
  * @IWL_UCODE_TLV_API_WIDE_CMD_HDR: ucode supports wide command header
- * @IWL_UCODE_TLV_API_SINGLE_SCAN_EBS: EBS is supported for single scans too.
  * @IWL_UCODE_TLV_API_ASYNC_DTM: Async temperature notifications are supported.
  * @IWL_UCODE_TLV_API_LQ_SS_PARAMS: Configure STBC/BFER via LQ CMD ss_params
  * @IWL_UCODE_TLV_API_STATS_V10: uCode supports/uses statistics API version 10
@@ -263,7 +262,6 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= (__force iwl_ucode_tlv_api_t)8,
 	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= (__force iwl_ucode_tlv_api_t)9,
 	IWL_UCODE_TLV_API_WIDE_CMD_HDR		= (__force iwl_ucode_tlv_api_t)14,
-	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= (__force iwl_ucode_tlv_api_t)16,
 	IWL_UCODE_TLV_API_ASYNC_DTM		= (__force iwl_ucode_tlv_api_t)17,
 	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= (__force iwl_ucode_tlv_api_t)18,
 	IWL_UCODE_TLV_API_STATS_V10		= (__force iwl_ucode_tlv_api_t)19,
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 56559d4..4a1f9af 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -750,8 +750,6 @@ static inline bool iwl_mvm_scan_use_ebs(struct iwl_mvm *mvm,
 	 */
 	return ((capa->flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT) &&
 		mvm->last_ebs_successful &&
-		(n_iterations > 1 ||
-		 fw_has_api(capa, IWL_UCODE_TLV_API_SINGLE_SCAN_EBS)) &&
 		vif->type != NL80211_IFTYPE_P2P_DEVICE);
 }
 
-- 
2.5.1

