Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40880 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843AbcEJUbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:31:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:10 +0300
Message-Id: <1462910797-20303-14-git-send-email-luca@coelho.fi> (sfid-20160510_223112_503783_BA847C20)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 14/41] iwlwifi: mvm: add a flag to disable checksum
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Add a constant to allow disabling checksum. This will enable easier
debugging in early phases.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index b96b1c6..4eeb6b7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -109,6 +109,7 @@
 #define IWL_MVM_RS_80_20_FAR_RANGE_TWEAK	1
 #define IWL_MVM_TOF_IS_RESPONDER		0
 #define IWL_MVM_SW_TX_CSUM_OFFLOAD		0
+#define IWL_MVM_HW_CSUM_DISABLE			0
 #define IWL_MVM_COLLECT_FW_ERR_DUMP		1
 #define IWL_MVM_RS_NUM_TRY_BEFORE_ANT_TOGGLE    1
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE      2
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 6eaf21a..72c0467 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1127,7 +1127,8 @@ static inline bool iwl_mvm_bt_is_rrc_supported(struct iwl_mvm *mvm)
 static inline bool iwl_mvm_is_csum_supported(struct iwl_mvm *mvm)
 {
 	return fw_has_capa(&mvm->fw->ucode_capa,
-			   IWL_UCODE_TLV_CAPA_CSUM_SUPPORT);
+			   IWL_UCODE_TLV_CAPA_CSUM_SUPPORT) &&
+               !IWL_MVM_HW_CSUM_DISABLE;
 }
 
 static inline bool iwl_mvm_is_mplut_supported(struct iwl_mvm *mvm)
-- 
2.8.1

