Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50162 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S943313AbcJSOz1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 10:55:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 10:27:24 +0300
Message-Id: <20161019072726.22018-6-luca@coelho.fi> (sfid-20161019_165552_847920_D420070A)
In-Reply-To: <20161019072726.22018-1-luca@coelho.fi>
References: <20161019072726.22018-1-luca@coelho.fi>
Subject: [PATCH 5/7] iwlwifi: mvm: wake the wait queue when the RX sync counter is zero
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When we sync the RX queues the driver waits to receive echo
notification on all the RX queues.
The wait queue is set with timeout until all queues have received
the notification.
However, iwl_mvm_rx_queue_notif() never woke up the wait queue,
with the result of the counter value being checked only when the
timeout expired.
This may cause a latency of up to 1 second.

Fixes: 0636b938214c ("iwlwifi: mvm: implement driver RX queues sync command")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 3 ++-
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 318efd8..1db1dc1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4121,7 +4121,6 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 				     struct iwl_mvm_internal_rxq_notif *notif,
 				     u32 size)
 {
-	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(notif_waitq);
 	u32 qmask = BIT(mvm->trans->num_rx_queues) - 1;
 	int ret;
 
@@ -4143,7 +4142,7 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 	}
 
 	if (notif->sync)
-		ret = wait_event_timeout(notif_waitq,
+		ret = wait_event_timeout(mvm->rx_sync_waitq,
 					 atomic_read(&mvm->queue_sync_counter) == 0,
 					 HZ);
 	WARN_ON_ONCE(!ret);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index d17cbf6..c60703e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -937,6 +937,7 @@ struct iwl_mvm {
 	/* sync d0i3_tx queue and IWL_MVM_STATUS_IN_D0I3 status flag */
 	spinlock_t d0i3_tx_lock;
 	wait_queue_head_t d0i3_exit_waitq;
+	wait_queue_head_t rx_sync_waitq;
 
 	/* BT-Coex */
 	struct iwl_bt_coex_profile_notif last_bt_notif;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 05fe6dd..4d35deb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -619,6 +619,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	spin_lock_init(&mvm->refs_lock);
 	skb_queue_head_init(&mvm->d0i3_tx);
 	init_waitqueue_head(&mvm->d0i3_exit_waitq);
+	init_waitqueue_head(&mvm->rx_sync_waitq);
 
 	atomic_set(&mvm->queue_sync_counter, 0);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index a57c6ef..6c802ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -547,7 +547,8 @@ void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 				  "Received expired RX queue sync message\n");
 			return;
 		}
-		atomic_dec(&mvm->queue_sync_counter);
+		if (!atomic_dec_return(&mvm->queue_sync_counter))
+			wake_up(&mvm->rx_sync_waitq);
 	}
 
 	switch (internal_notif->type) {
-- 
2.9.3
