Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50184 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S942575AbcJSPSL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:18:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 13:07:54 +0300
Message-Id: <20161019100755.23874-10-luca@coelho.fi> (sfid-20161019_171817_636749_4DCA582E)
In-Reply-To: <20161019100755.23874-1-luca@coelho.fi>
References: <20161019100755.23874-1-luca@coelho.fi>
Subject: [PATCH 09/10] iwlwifi: mvm: operate in dqa mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Run DQA flows by default, as long as the FW supports it.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 726ba48..cde8c6c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1111,9 +1111,8 @@ static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 
 static inline bool iwl_mvm_is_dqa_supported(struct iwl_mvm *mvm)
 {
-	/* Make sure DQA isn't allowed in driver until feature is complete */
-	return false && fw_has_capa(&mvm->fw->ucode_capa,
-				    IWL_UCODE_TLV_CAPA_DQA_SUPPORT);
+	return fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_DQA_SUPPORT);
 }
 
 static inline bool iwl_mvm_enter_d0i3_on_suspend(struct iwl_mvm *mvm)
-- 
2.9.3
