Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56010 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932428AbcISHcR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:32:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:20 +0300
Message-Id: <20160919073028.22065-17-luca@coelho.fi> (sfid-20160919_093220_391632_EB4CFC0C)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 17/25] iwlwifi: mvm: disable P2P queue on mac context release
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

AP queue is properly released, but P2P queue isn't.

Fixes: commit 4c965139a3cd ("iwlwifi: mvm: support p2p device frames tx on dqa queue #2")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 69c42ce..d742d27 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -539,6 +539,11 @@ void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 			iwl_mvm_disable_txq(mvm, IWL_MVM_OFFCHANNEL_QUEUE,
 					    IWL_MVM_OFFCHANNEL_QUEUE,
 					    IWL_MAX_TID_COUNT, 0);
+		else
+			iwl_mvm_disable_txq(mvm,
+					    IWL_MVM_DQA_P2P_DEVICE_QUEUE,
+					    vif->hw_queue[0], IWL_MAX_TID_COUNT,
+					    0);
 
 		break;
 	case NL80211_IFTYPE_AP:
-- 
2.9.3
