Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52912 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755624AbdDRWWx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:22:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:14 +0300
Message-Id: <20170418221729.28372-11-luca@coelho.fi> (sfid-20170419_002256_848028_D0910F0B)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 10/25] iwlwifi: mvm: ignore BAID for SN smaller than SSN
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When we get SN that is smaller than SSN of the aggregation,
we shouldn't apply any reordering on them.
Further more, HW NSSN will be zeroed, which can cause us
to make some invalid decisions.
Detect the situation and invalidate the BAID.

Fixes: b915c10174fb ("iwlwifi: mvm: add reorder buffer per queue")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 30 +++++++++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |  1 +
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index a22fe45eecc4..32e62175cbd5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -626,6 +626,7 @@ struct iwl_mvm_shared_mem_cfg {
  * @reorder_timer: timer for frames are in the reorder buffer. For AMSDU
  *	it is the time of last received sub-frame
  * @removed: prevent timer re-arming
+ * @valid: reordering is valid for this queue
  * @lock: protect reorder buffer internal state
  * @mvm: mvm pointer, needed for frame timer context
  */
@@ -641,6 +642,7 @@ struct iwl_mvm_reorder_buffer {
 	unsigned long reorder_time[IEEE80211_MAX_AMPDU_BUF];
 	struct timer_list reorder_timer;
 	bool removed;
+	bool valid;
 	spinlock_t lock;
 	struct iwl_mvm *mvm;
 } ____cacheline_aligned_in_smp;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index c99775039f59..8601d25407b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -636,9 +636,13 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 		return false;
 
 	baid_data = rcu_dereference(mvm->baid_map[baid]);
-	if (WARN(!baid_data,
-		 "Received baid %d, but no data exists for this BAID\n", baid))
+	if (!baid_data) {
+		WARN(!(reorder & IWL_RX_MPDU_REORDER_BA_OLD_SN),
+		     "Received baid %d, but no data exists for this BAID\n",
+		     baid);
 		return false;
+	}
+
 	if (WARN(tid != baid_data->tid || mvm_sta->sta_id != baid_data->sta_id,
 		 "baid 0x%x is mapped to sta:%d tid:%d, but was received for sta:%d tid:%d\n",
 		 baid, baid_data->sta_id, baid_data->tid, mvm_sta->sta_id,
@@ -653,6 +657,14 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 
 	spin_lock_bh(&buffer->lock);
 
+	if (!buffer->valid) {
+		if (reorder & IWL_RX_MPDU_REORDER_BA_OLD_SN) {
+			spin_unlock_bh(&buffer->lock);
+			return false;
+		}
+		buffer->valid = true;
+	}
+
 	if (ieee80211_is_back_req(hdr->frame_control)) {
 		iwl_mvm_release_frames(mvm, sta, napi, buffer, nssn);
 		goto drop;
@@ -737,7 +749,8 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	return true;
 }
 
-static void iwl_mvm_agg_rx_received(struct iwl_mvm *mvm, u8 baid)
+static void iwl_mvm_agg_rx_received(struct iwl_mvm *mvm,
+				    u32 reorder_data, u8 baid)
 {
 	unsigned long now = jiffies;
 	unsigned long timeout;
@@ -746,8 +759,10 @@ static void iwl_mvm_agg_rx_received(struct iwl_mvm *mvm, u8 baid)
 	rcu_read_lock();
 
 	data = rcu_dereference(mvm->baid_map[baid]);
-	if (WARN_ON(!data))
+	if (!data) {
+		WARN_ON(!(reorder_data & IWL_RX_MPDU_REORDER_BA_OLD_SN));
 		goto out;
+	}
 
 	if (!data->timeout)
 		goto out;
@@ -925,8 +940,11 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 				mac_addr[i] = hdr->addr3[ETH_ALEN - i - 1];
 			ether_addr_copy(hdr->addr3, mac_addr);
 		}
-		if (baid != IWL_RX_REORDER_DATA_INVALID_BAID)
-			iwl_mvm_agg_rx_received(mvm, baid);
+		if (baid != IWL_RX_REORDER_DATA_INVALID_BAID) {
+			u32 reorder_data = le32_to_cpu(desc->reorder_data);
+
+			iwl_mvm_agg_rx_received(mvm, reorder_data, baid);
+		}
 	}
 
 	/* Set up the HT phy flags */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index a58f0cb291bd..65706ddb979b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2225,6 +2225,7 @@ static void iwl_mvm_init_reorder_buffer(struct iwl_mvm *mvm,
 		reorder_buf->mvm = mvm;
 		reorder_buf->queue = i;
 		reorder_buf->sta_id = sta_id;
+		reorder_buf->valid = false;
 		for (j = 0; j < reorder_buf->buf_size; j++)
 			__skb_queue_head_init(&reorder_buf->entries[j]);
 	}
-- 
2.11.0
