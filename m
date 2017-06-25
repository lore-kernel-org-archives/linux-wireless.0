Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35062 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751128AbdFYLNk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:13:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:58 +0300
Message-Id: <20170625111158.1792-27-luca@coelho.fi> (sfid-20170625_131343_175143_822267EF)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 26/26] iwlwifi: mvm: support TX on MONITOR iface
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When trying to TX through a monitor interface, the
conditions in iwl_mvm_tx_skb_non_sta() don't match
and the frame tries to go out from an usued TXQ.

Add a check for monitor iface, and use the AUX queue
in such a case.

In non-DQA mode the frame is sent through the
static-allocated queues anyway, so the problem is
in DQA mode only.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 157a75394763..c89bb453c496 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -651,6 +651,9 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 			   info.control.vif->type == NL80211_IFTYPE_STATION &&
 			   queue != mvm->aux_queue) {
 			queue = IWL_MVM_DQA_BSS_CLIENT_QUEUE;
+		} else if (iwl_mvm_is_dqa_supported(mvm) &&
+			   info.control.vif->type == NL80211_IFTYPE_MONITOR) {
+			queue = mvm->aux_queue;
 		}
 	}
 
-- 
2.11.0
