Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40946 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752235AbdG1OZ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:25:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        "Zamir, Roee" <roee.zamir@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:30 +0300
Message-Id: <20170728142337.19183-18-luca@coelho.fi> (sfid-20170728_162610_843524_3F2DD617)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 17/24] iwlwifi: mvm: add compile-time option to disable EBS
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Zamir, Roee" <roee.zamir@intel.com>

For testing purposes, we may want to disable EBS scans at compile time.

Signed-off-by: Roee Zamir <roee.zamir@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index 21845034d80d..a922a351c916 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -140,5 +140,6 @@
 #define IWL_MVM_RS_TPC_SR_FORCE_INCREASE	75	/* percent */
 #define IWL_MVM_RS_TPC_SR_NO_INCREASE		85	/* percent */
 #define IWL_MVM_RS_TPC_TX_POWER_STEP		3
+#define IWL_MVM_ENABLE_EBS			1
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index cb44e4114655..50983615dce6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -743,7 +743,7 @@ static inline bool iwl_mvm_scan_use_ebs(struct iwl_mvm *mvm,
 	 *	4. it's not a p2p find operation.
 	 */
 	return ((capa->flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT) &&
-		mvm->last_ebs_successful &&
+		mvm->last_ebs_successful && IWL_MVM_ENABLE_EBS &&
 		vif->type != NL80211_IFTYPE_P2P_DEVICE);
 }
 
-- 
2.13.2
