Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbcCBH5t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:49 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 43/43] iwlwifi: mvm: support sw queue start/stop from mvm
Date: Wed,  2 Mar 2016 09:56:44 +0200
Message-Id: <1456905404-14435-43-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085953_349975_33525782)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Add a wrapper function to allow stopping SW queues from MVM
as well.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  4 +++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 38 ++++++++++++++++++----------
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 7ea2baa..f9019c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1556,6 +1556,10 @@ static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 	iwl_trans_stop_device(mvm->trans);
 }
 
+/* Stop/start all mac queues in a given bitmap */
+void iwl_mvm_start_mac_queues(struct iwl_mvm *mvm, unsigned long mq);
+void iwl_mvm_stop_mac_queues(struct iwl_mvm *mvm, unsigned long mq);
+
 /* Thermal management and CT-kill */
 void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff);
 void iwl_mvm_tt_temp_changed(struct iwl_mvm *mvm, u32 temp);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 3760a09..e6d0adc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -897,24 +897,17 @@ static void iwl_mvm_rx_mq(struct iwl_op_mode *op_mode,
 		iwl_mvm_rx_common(mvm, rxb, pkt);
 }
 
-static void iwl_mvm_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
+void iwl_mvm_stop_mac_queues(struct iwl_mvm *mvm, unsigned long mq)
 {
-	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
-	unsigned long mq;
 	int q;
 
-	spin_lock_bh(&mvm->queue_info_lock);
-	mq = mvm->queue_info[queue].hw_queue_to_mac80211;
-	spin_unlock_bh(&mvm->queue_info_lock);
-
 	if (WARN_ON_ONCE(!mq))
 		return;
 
 	for_each_set_bit(q, &mq, IEEE80211_MAX_QUEUES) {
 		if (atomic_inc_return(&mvm->mac80211_queue_stop_count[q]) > 1) {
 			IWL_DEBUG_TX_QUEUES(mvm,
-					    "queue %d (mac80211 %d) already stopped\n",
-					    queue, q);
+					    "mac80211 %d already stopped\n", q);
 			continue;
 		}
 
@@ -934,24 +927,29 @@ static void iwl_mvm_async_cb(struct iwl_op_mode *op_mode,
 	iwl_trans_block_txq_ptrs(mvm->trans, false);
 }
 
-static void iwl_mvm_wake_sw_queue(struct iwl_op_mode *op_mode, int queue)
+static void iwl_mvm_stop_sw_queue(struct iwl_op_mode *op_mode, int hw_queue)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	unsigned long mq;
-	int q;
 
 	spin_lock_bh(&mvm->queue_info_lock);
-	mq = mvm->queue_info[queue].hw_queue_to_mac80211;
+	mq = mvm->queue_info[hw_queue].hw_queue_to_mac80211;
 	spin_unlock_bh(&mvm->queue_info_lock);
 
+	iwl_mvm_stop_mac_queues(mvm, mq);
+}
+
+void iwl_mvm_start_mac_queues(struct iwl_mvm *mvm, unsigned long mq)
+{
+	int q;
+
 	if (WARN_ON_ONCE(!mq))
 		return;
 
 	for_each_set_bit(q, &mq, IEEE80211_MAX_QUEUES) {
 		if (atomic_dec_return(&mvm->mac80211_queue_stop_count[q]) > 0) {
 			IWL_DEBUG_TX_QUEUES(mvm,
-					    "queue %d (mac80211 %d) still stopped\n",
-					    queue, q);
+					    "mac80211 %d still stopped\n", q);
 			continue;
 		}
 
@@ -959,6 +957,18 @@ static void iwl_mvm_wake_sw_queue(struct iwl_op_mode *op_mode, int queue)
 	}
 }
 
+static void iwl_mvm_wake_sw_queue(struct iwl_op_mode *op_mode, int hw_queue)
+{
+	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
+	unsigned long mq;
+
+	spin_lock_bh(&mvm->queue_info_lock);
+	mq = mvm->queue_info[hw_queue].hw_queue_to_mac80211;
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	iwl_mvm_start_mac_queues(mvm, mq);
+}
+
 void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state)
 {
 	if (state)
-- 
2.5.0

