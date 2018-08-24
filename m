Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43926 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726572AbeHXOEo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:44 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:17 +0300
Message-Id: <20180824103018.15011-16-luca@coelho.fi> (sfid-20180824_123104_533086_344B8D33)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 15/16] iwlwifi: mvm: activate fragmented EBS in case of fragmented scan
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

In case of fragmented scan on the HB channels, configure EBS to be
fragmented as well.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c    | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index a17c4a79b8d4..310b01e3cce1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -262,6 +262,7 @@ enum iwl_scan_channel_flags {
 	IWL_SCAN_CHANNEL_FLAG_EBS		= BIT(0),
 	IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE	= BIT(1),
 	IWL_SCAN_CHANNEL_FLAG_CACHE_ADD		= BIT(2),
+	IWL_SCAN_CHANNEL_FLAG_EBS_FRAG		= BIT(3),
 };
 
 /* struct iwl_scan_channel_opt - CHANNEL_OPTIMIZATION_API_S
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 003bf0848386..e9048a98e793 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1455,11 +1455,21 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (type == IWL_MVM_SCAN_SCHED || type == IWL_MVM_SCAN_NETDETECT)
 		cmd->flags = cpu_to_le32(IWL_UMAC_SCAN_FLAG_PREEMPTIVE);
 
-	if (iwl_mvm_scan_use_ebs(mvm, vif))
+	if (iwl_mvm_scan_use_ebs(mvm, vif)) {
 		channel_flags = IWL_SCAN_CHANNEL_FLAG_EBS |
 				IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
 				IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
 
+		/* set fragmented ebs for fragmented scan on HB channels */
+		if (iwl_mvm_is_frag_ebs_supported(mvm)) {
+			if (gen_flags &
+			    IWL_UMAC_SCAN_GEN_FLAGS_LMAC2_FRAGMENTED ||
+			    (!iwl_mvm_is_cdb_supported(mvm) &&
+			     gen_flags & IWL_UMAC_SCAN_GEN_FLAGS_FRAGMENTED))
+				channel_flags |= IWL_SCAN_CHANNEL_FLAG_EBS_FRAG;
+		}
+	}
+
 	chan_param->flags = channel_flags;
 	chan_param->count = params->n_channels;
 
-- 
2.18.0
