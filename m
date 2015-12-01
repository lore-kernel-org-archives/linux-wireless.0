Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022AbbLAJ7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:30 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/41] iwlwifi: mvm: remove redundant d0i3 flag from the config struct
Date: Tue,  1 Dec 2015 11:58:41 +0200
Message-Id: <1448963947-24302-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110307_999408_DEB3C129)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The d0i3 flag in the device configuration structure is redundant,
because the same information can be determined by checking the
firmware capability flag.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c   | 1 -
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 2 --
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h    | 9 ++++-----
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index 9bcc0bf..dd22b78 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -154,7 +154,6 @@ static const struct iwl_tt_params iwl8000_tt_params = {
 	.base_params = &iwl8000_base_params,				\
 	.led_mode = IWL_LED_RF_STATE,					\
 	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_8000,		\
-	.d0i3 = true,							\
 	.features = NETIF_F_RXCSUM,					\
 	.non_shared_ant = ANT_A,					\
 	.dccm_offset = IWL8260_DCCM_OFFSET,				\
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 9109708..652cdfe 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -295,7 +295,6 @@ struct iwl_pwr_tx_backoff {
  * @high_temp: Is this NIC is designated to be in high temperature.
  * @host_interrupt_operation_mode: device needs host interrupt operation
  *	mode set
- * @d0i3: device uses d0i3 instead of d3
  * @nvm_hw_section_num: the ID of the HW NVM section
  * @features: hw features, any combination of feature_whitelist
  * @pwr_tx_backoffs: translation table between power limits and backoffs
@@ -342,7 +341,6 @@ struct iwl_cfg {
 	const bool internal_wimax_coex;
 	const bool host_interrupt_operation_mode;
 	bool high_temp;
-	bool d0i3;
 	u8   nvm_hw_section_num;
 	bool lp_xtal_workaround;
 	const struct iwl_pwr_tx_backoff *pwr_tx_backoffs;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 347d953..897d06f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -916,11 +916,10 @@ iwl_mvm_sta_from_staid_protected(struct iwl_mvm *mvm, u8 sta_id)
 
 static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 {
-	return mvm->trans->cfg->d0i3 &&
-	       mvm->trans->d0i3_mode != IWL_D0I3_MODE_OFF &&
-	       !iwlwifi_mod_params.d0i3_disable &&
-	       fw_has_capa(&mvm->fw->ucode_capa,
-			   IWL_UCODE_TLV_CAPA_D0I3_SUPPORT);
+	return mvm->trans->d0i3_mode != IWL_D0I3_MODE_OFF &&
+		!iwlwifi_mod_params.d0i3_disable &&
+		fw_has_capa(&mvm->fw->ucode_capa,
+			    IWL_UCODE_TLV_CAPA_D0I3_SUPPORT);
 }
 
 static inline bool iwl_mvm_is_dqa_supported(struct iwl_mvm *mvm)
-- 
2.5.0

