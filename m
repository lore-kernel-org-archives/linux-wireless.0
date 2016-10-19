Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50192 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S944575AbcJSPST (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:18:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 13:07:48 +0300
Message-Id: <20161019100755.23874-4-luca@coelho.fi> (sfid-20161019_171824_661544_D9672D26)
In-Reply-To: <20161019100755.23874-1-luca@coelho.fi>
References: <20161019100755.23874-1-luca@coelho.fi>
Subject: [PATCH 03/10] iwlwifi: mvm: support MONITOR vif in DQA mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In DQA mode the TXQs are allocated on demand, so make
sure the sniffer STA tfd_queue_msk isn't set.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 6b962d6..9a91203 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -899,9 +899,11 @@ static int iwl_mvm_mac_ctxt_cmd_listener(struct iwl_mvm *mvm,
 
 	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, NULL, action);
 
-	for (i = 0; i < IEEE80211_NUM_ACS; i++)
-		if (vif->hw_queue[i] != IEEE80211_INVAL_HW_QUEUE)
-			tfd_queue_msk |= BIT(vif->hw_queue[i]);
+	if (!iwl_mvm_is_dqa_supported(mvm)) {
+		for (i = 0; i < IEEE80211_NUM_ACS; i++)
+			if (vif->hw_queue[i] != IEEE80211_INVAL_HW_QUEUE)
+				tfd_queue_msk |= BIT(vif->hw_queue[i]);
+	}
 
 	cmd.filter_flags = cpu_to_le32(MAC_FILTER_IN_PROMISC |
 				       MAC_FILTER_IN_CONTROL_AND_MGMT |
-- 
2.9.3
