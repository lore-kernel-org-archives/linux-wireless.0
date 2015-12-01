Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbbLAJ7n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:43 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/41] iwlwifi: mvm: remove unnecessary check in iwl_mvm_is_d0i3_supported()
Date: Tue,  1 Dec 2015 11:58:49 +0200
Message-Id: <1448963947-24302-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105953_438136_D7800161)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The d0i3_mode element is never set to IWL_D0I3_OFF, so it's not
necessary to check it in iwl_mvm_is_d0i3_supported().

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 91c7480..013b379 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -913,8 +913,7 @@ iwl_mvm_sta_from_staid_protected(struct iwl_mvm *mvm, u8 sta_id)
 
 static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 {
-	return mvm->trans->d0i3_mode != IWL_D0I3_MODE_OFF &&
-		!iwlwifi_mod_params.d0i3_disable &&
+	return !iwlwifi_mod_params.d0i3_disable &&
 		fw_has_capa(&mvm->fw->ucode_capa,
 			    IWL_UCODE_TLV_CAPA_D0I3_SUPPORT);
 }
-- 
2.5.0

