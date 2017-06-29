Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36230 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751941AbdF2Saj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:30:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 21:30:16 +0300
Message-Id: <20170629183027.15408-5-luca@coelho.fi> (sfid-20170629_203049_473137_7240839B)
In-Reply-To: <20170629183027.15408-1-luca@coelho.fi>
References: <20170629183027.15408-1-luca@coelho.fi>
Subject: [PATCH 04/15] iwlwifi: mvm: fix mac80211 queue tracking
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the driver, we track which hardware queue is associated with
which mac80211 "hw_queue", in order to be able to stop and wake
it. When moving these bitmaps out of the queue_info structures,
the type of the bitmap was erroneously changed from u32 to u8,
presumably in order to save memory.

Turns out that u32 isn't needed, because the highest queue we
can ever tell mac80211 is always < 16, but a u16 definitely is
needed, queues >=8 do happen.

While at it, throw a BUILD_BUG_ON() into the place where we set
the limit (mvm->first_agg_queue) and a warning when it actually
gets put into the bitmap.

The consequence of this bug is that full HW queues associated
with such a too-high mac80211 number never stop higher layer
queues when full, and thus would simply drop all packets that
couldn't be enqueued to the hardware queue.

Fixes: 34e10860ae8d ("iwlwifi: mvm: remove references to queue_info in new TX path")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h   | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c   | 4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 8 +++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 0f0cd6c9ce8b..6b8f7817391d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -789,7 +789,7 @@ struct iwl_mvm {
 		u64 on_time_scan;
 	} radio_stats, accu_radio_stats;
 
-	u8 hw_queue_to_mac80211[IWL_MAX_TVQM_QUEUES];
+	u16 hw_queue_to_mac80211[IWL_MAX_TVQM_QUEUES];
 
 	struct {
 		u8 hw_queue_refcount;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 32233cba6786..1799a3d367f9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -602,9 +602,13 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		if (mvm->cfg->base_params->num_of_queues == 16) {
 			mvm->aux_queue = 11;
 			mvm->first_agg_queue = 12;
+			BUILD_BUG_ON(BITS_PER_BYTE *
+				     sizeof(mvm->hw_queue_to_mac80211[0]) < 12);
 		} else {
 			mvm->aux_queue = 15;
 			mvm->first_agg_queue = 16;
+			BUILD_BUG_ON(BITS_PER_BYTE *
+				     sizeof(mvm->hw_queue_to_mac80211[0]) < 16);
 		}
 	} else {
 		mvm->aux_queue = IWL_MVM_DQA_AUX_QUEUE;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 0093e78dd571..bd2596fdafda 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -698,7 +698,13 @@ static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
 	if (mvm->queue_info[queue].hw_queue_refcount > 0)
 		enable_queue = false;
 
-	mvm->hw_queue_to_mac80211[queue] |= BIT(mac80211_queue);
+	if (mac80211_queue != IEEE80211_INVAL_HW_QUEUE) {
+		WARN(mac80211_queue >=
+		     BITS_PER_BYTE * sizeof(mvm->hw_queue_to_mac80211[0]),
+		     "cannot track mac80211 queue %d (queue %d, sta %d, tid %d)\n",
+		     mac80211_queue, queue, sta_id, tid);
+		mvm->hw_queue_to_mac80211[queue] |= BIT(mac80211_queue);
+	}
 
 	mvm->queue_info[queue].hw_queue_refcount++;
 	mvm->queue_info[queue].tid_bitmap |= BIT(tid);
-- 
2.11.0
