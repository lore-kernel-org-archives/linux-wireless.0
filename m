Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40562 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752465AbcEJUHr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:07:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:00 +0300
Message-Id: <1462910797-20303-4-git-send-email-luca@coelho.fi> (sfid-20160510_220749_446556_2FBBF1B5)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 04/41] iwlwifi: mvm: implement driver RX queues sync command
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

mac80211 will call the driver whenever there is a race between
RSS queues and control path that requires a processing of all
pending frames in RSS queues.
Implement that by utilizing the internal notification mechanism:
queue a message to all queues. When the message is received on
a queue it decrements the atomic counter. This guarantees that
all pending frames in the RX queue were processed since the message
is in order inside the queue.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 43 ++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  7 ++++
 5 files changed, 58 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index 4c086d0..ade170b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -437,9 +437,11 @@ struct iwl_rxq_sync_notification {
 /**
 * Internal message identifier
 *
+* @IWL_MVM_RXQ_SYNC: sync RSS queues
 * @IWL_MVM_RXQ_NOTIF_DEL_BA: notify RSS queues of delBA
 */
 enum iwl_mvm_rxq_notif_type {
+	IWL_MVM_RXQ_SYNC,
 	IWL_MVM_RXQ_NOTIF_DEL_BA,
 };
 
@@ -448,10 +450,12 @@ enum iwl_mvm_rxq_notif_type {
 * in &iwl_rxq_sync_cmd. Should be DWORD aligned.
 *
 * @type: value from &iwl_mvm_rxq_notif_type
+* @cookie: internal cookie to identify old notifications
 * @data: payload
 */
 struct iwl_mvm_internal_rxq_notif {
 	u32 type;
+	u32 cookie;
 	u8 data[];
 } __packed;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5ace468..d6ad77a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4037,6 +4037,47 @@ static void iwl_mvm_mac_event_callback(struct ieee80211_hw *hw,
 	}
 }
 
+static void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm)
+{
+	struct iwl_mvm_internal_rxq_notif data = {
+		.type = IWL_MVM_RXQ_SYNC,
+		.cookie = mvm->queue_sync_cookie,
+	};
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(notif_waitq);
+	u32 qmask = BIT(mvm->trans->num_rx_queues) - 1;
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (!iwl_mvm_has_new_rx_api(mvm))
+		return;
+
+	atomic_set(&mvm->queue_sync_counter, mvm->trans->num_rx_queues);
+
+	ret = iwl_mvm_notify_rx_queue(mvm, qmask, (u8 *)&data, sizeof(data));
+	if (ret) {
+		IWL_ERR(mvm, "Failed to trigger RX queues sync (%d)\n", ret);
+		goto out;
+	}
+	ret = wait_event_timeout(notif_waitq,
+				 atomic_read(&mvm->queue_sync_counter) == 0,
+				 HZ);
+	WARN_ON_ONCE(!ret);
+
+out:
+	atomic_set(&mvm->queue_sync_counter, 0);
+	mvm->queue_sync_cookie++;
+}
+
+static void iwl_mvm_sync_rx_queues(struct ieee80211_hw *hw)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	mutex_lock(&mvm->mutex);
+	iwl_mvm_sync_rx_queues_internal(mvm);
+	mutex_unlock(&mvm->mutex);
+}
+
 const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
 	.ampdu_action = iwl_mvm_mac_ampdu_action,
@@ -4093,6 +4134,8 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 
 	.event_callback = iwl_mvm_mac_event_callback,
 
+	.sync_rx_queues = iwl_mvm_sync_rx_queues,
+
 	CFG80211_TESTMODE_CMD(iwl_mvm_mac_testmode_cmd)
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 85800ba..c7c8a62 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -633,6 +633,8 @@ struct iwl_mvm {
 
 	unsigned long status;
 
+	u32 queue_sync_cookie;
+	atomic_t queue_sync_counter;
 	/*
 	 * for beacon filtering -
 	 * currently only one interface can be supported
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 8bfb8e0..7c6a598 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -586,6 +586,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	skb_queue_head_init(&mvm->d0i3_tx);
 	init_waitqueue_head(&mvm->d0i3_exit_waitq);
 
+	atomic_set(&mvm->queue_sync_counter, 0);
+
 	SET_IEEE80211_DEV(mvm->hw, mvm->trans->dev);
 
 	/*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 651604d..b4d9c42 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -406,6 +406,13 @@ void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	internal_notif = (void *)notif->payload;
 
 	switch (internal_notif->type) {
+	case IWL_MVM_RXQ_SYNC:
+		if (mvm->queue_sync_cookie == internal_notif->cookie)
+			atomic_dec(&mvm->queue_sync_counter);
+		else
+			WARN_ONCE(1,
+				  "Received expired RX queue sync message\n");
+		break;
 	case IWL_MVM_RXQ_NOTIF_DEL_BA:
 		/* TODO */
 		break;
-- 
2.8.1

