Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42424 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752610AbdHESrx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 14:47:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 21:47:43 +0300
Message-Id: <20170805184743.23650-4-luca@coelho.fi> (sfid-20170805_205040_636501_CD35B875)
In-Reply-To: <20170805184743.23650-1-luca@coelho.fi>
References: <20170805184743.23650-1-luca@coelho.fi>
Subject: [PATCH 3/3] iwlwifi: mvm: don't WARN when a legit race happens in A-MPDU
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we start an Rx A-MPDU session, we first get the AddBA
request, then we send an ADD_STA command to the firmware
that will reply with a BAID which is a hardware resource
that tracks the BA session.
This BAID will appear on each and every frame that we get
from the firwmare until the A-MPDU session is torn down.
In the Rx path, we look at this BAID to manage the
reordering buffer.

This flow is inherently racy since the hardware will start
to put the BAID in the frames it receives even if the
firmware hasn't sent the response to the ADD_STA command.
This basically means that the driver can get frames with
a valid BAID that it doesn't know yet.
When that happens, the driver used to WARN.
Fix this by simply not WARN in this case. When the driver
will know abou the BAID, it will initialise the relevant
states and the next frame with a valid BAID will refresh
them.

Fixes: b915c10174fb ("iwlwifi: mvm: add reorder buffer per queue")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index f3e608196369..71c8b800ffa9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -636,9 +636,9 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 
 	baid_data = rcu_dereference(mvm->baid_map[baid]);
 	if (!baid_data) {
-		WARN(!(reorder & IWL_RX_MPDU_REORDER_BA_OLD_SN),
-		     "Received baid %d, but no data exists for this BAID\n",
-		     baid);
+		IWL_DEBUG_RX(mvm,
+			     "Got valid BAID but no baid allocated, bypass the re-ordering buffer. Baid %d reorder 0x%x\n",
+			      baid, reorder);
 		return false;
 	}
 
@@ -759,7 +759,9 @@ static void iwl_mvm_agg_rx_received(struct iwl_mvm *mvm,
 
 	data = rcu_dereference(mvm->baid_map[baid]);
 	if (!data) {
-		WARN_ON(!(reorder_data & IWL_RX_MPDU_REORDER_BA_OLD_SN));
+		IWL_DEBUG_RX(mvm,
+			     "Got valid BAID but no baid allocated, bypass the re-ordering buffer. Baid %d reorder 0x%x\n",
+			      baid, reorder_data);
 		goto out;
 	}
 
-- 
2.13.2
