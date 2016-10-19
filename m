Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50196 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S944575AbcJSPSW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:18:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 13:07:49 +0300
Message-Id: <20161019100755.23874-5-luca@coelho.fi> (sfid-20161019_171826_578377_E0FFD8AF)
In-Reply-To: <20161019100755.23874-1-luca@coelho.fi>
References: <20161019100755.23874-1-luca@coelho.fi>
Subject: [PATCH 04/10] iwlwifi: mvm: fix dqa deferred frames marking
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When a STA has deferred traffic to TX, an appropriate bit
is turned on in %deferred_tx_frames to indicate deferred
traffic. This marking is never turned off, resulting in
iterating over TIDs with no deferred traffic.

Although this didn't cause any failures/errors/bugs, there
is still no point of iterating over these TIDs when not
needed.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index c9dcb70..5ec1b96 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1015,6 +1015,7 @@ static void iwl_mvm_tx_deferred_stream(struct iwl_mvm *mvm,
 	local_bh_disable();
 	spin_lock(&mvmsta->lock);
 	skb_queue_splice_init(&tid_data->deferred_tx_frames, &deferred_tx);
+	mvmsta->deferred_traffic_tid_map &= ~BIT(tid);
 	spin_unlock(&mvmsta->lock);
 
 	while ((skb = __skb_dequeue(&deferred_tx)))
-- 
2.9.3
