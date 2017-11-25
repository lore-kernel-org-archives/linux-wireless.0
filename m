Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47376 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751277AbdKYPfc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 10:35:32 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 17:35:07 +0200
Message-Id: <20171125153510.25359-4-luca@coelho.fi> (sfid-20171125_163535_998227_BD945AEC)
In-Reply-To: <20171125153510.25359-1-luca@coelho.fi>
References: <20171125153510.25359-1-luca@coelho.fi>
Subject: [PATCH 3/6] iwlwifi: mvm: fix the TX queue hang timeout for MONITOR vif type
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The MONITOR type is missing in the interface type switch.
Add it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 19c1d1f76e15..03ffd84786ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1172,6 +1172,8 @@ unsigned int iwl_mvm_get_wd_timeout(struct iwl_mvm *mvm,
 		return le32_to_cpu(txq_timer->p2p_go);
 	case NL80211_IFTYPE_P2P_DEVICE:
 		return le32_to_cpu(txq_timer->p2p_device);
+	case NL80211_IFTYPE_MONITOR:
+		return default_timeout;
 	default:
 		WARN_ON(1);
 		return mvm->cfg->base_params->wd_timeout;
-- 
2.15.0
