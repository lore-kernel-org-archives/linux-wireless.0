Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45783 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932229AbbIUVBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 17:01:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:53 +0300
Message-Id: <1442869141-31637-13-git-send-email-luca@coelho.fi> (sfid-20150921_230144_158333_D018EF21)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 13/21] iwlwifi: mvm: remove IWL_UCODE_TLV_API_ASYNC_DTM TLV flag
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This flag is set in all supported firmwares.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h | 2 --
 drivers/net/wireless/iwlwifi/mvm/rx.c      | 6 ------
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 880962e..104468b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -248,7 +248,6 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  *	longer than the passive one, which is essential for fragmented scan.
  * @IWL_UCODE_TLV_API_WIFI_MCC_UPDATE: ucode supports MCC updates with source.
  * @IWL_UCODE_TLV_API_WIDE_CMD_HDR: ucode supports wide command header
- * @IWL_UCODE_TLV_API_ASYNC_DTM: Async temperature notifications are supported.
  * @IWL_UCODE_TLV_API_LQ_SS_PARAMS: Configure STBC/BFER via LQ CMD ss_params
  * @IWL_UCODE_TLV_API_STATS_V10: uCode supports/uses statistics API version 10
  * @IWL_UCODE_TLV_API_NEW_VERSION: new versioning format
@@ -262,7 +261,6 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_FRAGMENTED_SCAN	= (__force iwl_ucode_tlv_api_t)8,
 	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= (__force iwl_ucode_tlv_api_t)9,
 	IWL_UCODE_TLV_API_WIDE_CMD_HDR		= (__force iwl_ucode_tlv_api_t)14,
-	IWL_UCODE_TLV_API_ASYNC_DTM		= (__force iwl_ucode_tlv_api_t)17,
 	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= (__force iwl_ucode_tlv_api_t)18,
 	IWL_UCODE_TLV_API_STATS_V10		= (__force iwl_ucode_tlv_api_t)19,
 	IWL_UCODE_TLV_API_NEW_VERSION		= (__force iwl_ucode_tlv_api_t)20,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 2ad814d..b620142 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -621,12 +621,6 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 
 	iwl_mvm_rx_stats_check_trigger(mvm, pkt);
 
-	/* Only handle rx statistics temperature changes if async temp
-	 * notifications are not supported
-	 */
-	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_ASYNC_DTM))
-		iwl_mvm_tt_temp_changed(mvm, temperature);
-
 	ieee80211_iterate_active_interfaces(mvm->hw,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_stat_iterator,
-- 
2.5.1

