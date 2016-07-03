Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60798 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752850AbcGCTtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:49:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:43 +0300
Message-Id: <1467575332-32112-4-git-send-email-luca@coelho.fi> (sfid-20160703_214922_788631_4CBD91F8)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 04/13] iwlwifi: rename CAPA_P2P_STANDALONE_UAPSD to CAPA_P2P_SCM_UAPSD
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Ucode capability bit 26 indicates support for UAPSD on P2P interface
even with a simultaneous BSS station interface, as long as both
interfaces are in the same binding. Change the name of the
capability bit to reflect that.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h  | 5 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/power.c    | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 843232b..3f5029e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -299,7 +299,8 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_DC2DC_SUPPORT: supports DC2DC Command
  * @IWL_UCODE_TLV_CAPA_CSUM_SUPPORT: supports TCP Checksum Offload
  * @IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS: support radio and beacon statistics
- * @IWL_UCODE_TLV_CAPA_P2P_STANDALONE_UAPSD: support p2p standalone U-APSD
+ * @IWL_UCODE_TLV_CAPA_P2P_SCM_UAPSD: supports U-APSD on p2p interface when it
+ *	is standalone or with a BSS station interface in the same binding.
  * @IWL_UCODE_TLV_CAPA_BT_COEX_PLCR: enabled BT Coex packet level co-running
  * @IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC: ucode supports LAR updates with different
  *	sources for the MCC. This TLV bit is a future replacement to
@@ -345,7 +346,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_DC2DC_CONFIG_SUPPORT		= (__force iwl_ucode_tlv_capa_t)19,
 	IWL_UCODE_TLV_CAPA_CSUM_SUPPORT			= (__force iwl_ucode_tlv_capa_t)21,
 	IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS		= (__force iwl_ucode_tlv_capa_t)22,
-	IWL_UCODE_TLV_CAPA_P2P_STANDALONE_UAPSD		= (__force iwl_ucode_tlv_capa_t)26,
+	IWL_UCODE_TLV_CAPA_P2P_SCM_UAPSD		= (__force iwl_ucode_tlv_capa_t)26,
 	IWL_UCODE_TLV_CAPA_BT_COEX_PLCR			= (__force iwl_ucode_tlv_capa_t)28,
 	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= (__force iwl_ucode_tlv_capa_t)29,
 	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= (__force iwl_ucode_tlv_capa_t)30,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index e5f267b..b7014bc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2360,7 +2360,7 @@ static void iwl_mvm_check_uapsd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT))
 		return;
 
-	if (vif->p2p && !iwl_mvm_is_p2p_standalone_uapsd_supported(mvm)) {
+	if (vif->p2p && !iwl_mvm_is_p2p_scm_uapsd_supported(mvm)) {
 		vif->driver_flags &= ~IEEE80211_VIF_SUPPORTS_UAPSD;
 		return;
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ffbd41d..4843e02 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1158,10 +1158,10 @@ static inline bool iwl_mvm_is_mplut_supported(struct iwl_mvm *mvm)
 }
 
 static inline
-bool iwl_mvm_is_p2p_standalone_uapsd_supported(struct iwl_mvm *mvm)
+bool iwl_mvm_is_p2p_scm_uapsd_supported(struct iwl_mvm *mvm)
 {
 	return fw_has_capa(&mvm->fw->ucode_capa,
-			   IWL_UCODE_TLV_CAPA_P2P_STANDALONE_UAPSD) &&
+			   IWL_UCODE_TLV_CAPA_P2P_SCM_UAPSD) &&
 		!(iwlwifi_mod_params.uapsd_disable &
 		  IWL_DISABLE_UAPSD_P2P_CLIENT);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index 7b1f6ad..ff85865 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -308,7 +308,7 @@ static bool iwl_mvm_power_allow_uapsd(struct iwl_mvm *mvm,
 		/* Allow U-APSD only if p2p is stand alone */
 		bool is_p2p_standalone = true;
 
-		if (!iwl_mvm_is_p2p_standalone_uapsd_supported(mvm))
+		if (!iwl_mvm_is_p2p_scm_uapsd_supported(mvm))
 			return false;
 
 		ieee80211_iterate_active_interfaces_atomic(mvm->hw,
-- 
2.8.1

