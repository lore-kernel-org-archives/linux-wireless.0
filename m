Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55806 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932338AbcISHaj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:30:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:04 +0300
Message-Id: <20160919073028.22065-1-luca@coelho.fi> (sfid-20160919_093043_336514_6AD970ED)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 01/25] iwlwifi: mvm: remove variable shadowing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Variable "ac" defined twice. Fix that.

Fixes: commit 93f436e2c7fe ("iwlwifi: mvm: set sta_id in SCD_QUEUE_CONFIG cmd")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 216aa54..d3a0378 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -745,14 +745,14 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 			.scd_queue = queue,
 			.action = SCD_CFG_DISABLE_QUEUE,
 		};
-		u8 ac;
+		u8 txq_curr_ac;
 
 		disable_agg_tids = iwl_mvm_remove_sta_queue_marking(mvm, queue);
 
 		spin_lock_bh(&mvm->queue_info_lock);
-		ac = mvm->queue_info[queue].mac80211_ac;
+		txq_curr_ac = mvm->queue_info[queue].mac80211_ac;
 		cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
-		cmd.tx_fifo = iwl_mvm_ac_to_tx_fifo[ac];
+		cmd.tx_fifo = iwl_mvm_ac_to_tx_fifo[txq_curr_ac];
 		cmd.tid = mvm->queue_info[queue].txq_tid;
 		spin_unlock_bh(&mvm->queue_info_lock);
 
-- 
2.9.3
