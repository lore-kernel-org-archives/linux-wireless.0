Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47318 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754480AbcJZIJ4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 04:09:56 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org, linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 26 Oct 2016 11:09:47 +0300
Message-Id: <20161026080947.11647-1-luca@coelho.fi> (sfid-20161026_101001_639047_A79C17AD)
In-Reply-To: <20161019100755.23874-10-luca@coelho.fi>
References: <20161019100755.23874-10-luca@coelho.fi>
Subject: [PATCH v2] iwlwifi: mvm: enable dynamic queue allocation mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

New firmwares support dynamic queue allocation (DQA), which enables
on-demand allocation of queues per RA/TID, instead of allocating them
statically per vif.  This allows an AP to send, for instance, BE
traffic to STA2 even if it also needs to send traffic to a sleeping
STA1, without being blocked by the sleeping station.

The implementation in the driver is now ready, so we can enable this
feature by default when running firmwares that support it.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
[reworded the commit message]
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
