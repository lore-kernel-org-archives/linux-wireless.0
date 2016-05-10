Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40572 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752162AbcEJUID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:08:03 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:01 +0300
Message-Id: <1462910797-20303-5-git-send-email-luca@coelho.fi> (sfid-20160510_220806_937403_985C62B2)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 05/41] iwlwifi: mvm: change RX sync notification to be an attribute and not a type
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently the sync notification is a type of notification. However, it
is better fitted as an attribute of a notification, since there might
be another message in the payload (delba for instance) that should be
sent while control path is waiting for all queues to process.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h |  9 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 30 ++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 15 ++++++-----
 4 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index ade170b..1ca8e49 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -437,24 +437,27 @@ struct iwl_rxq_sync_notification {
 /**
 * Internal message identifier
 *
-* @IWL_MVM_RXQ_SYNC: sync RSS queues
+* @IWL_MVM_RXQ_EMPTY: empty sync notification
 * @IWL_MVM_RXQ_NOTIF_DEL_BA: notify RSS queues of delBA
 */
 enum iwl_mvm_rxq_notif_type {
-	IWL_MVM_RXQ_SYNC,
+	IWL_MVM_RXQ_EMPTY,
 	IWL_MVM_RXQ_NOTIF_DEL_BA,
 };
 
 /**
 * struct iwl_mvm_internal_rxq_notif - Internal representation of the data sent
 * in &iwl_rxq_sync_cmd. Should be DWORD aligned.
+* FW is agnostic to the payload, so there are no endianity requirements.
 *
 * @type: value from &iwl_mvm_rxq_notif_type
+* @sync: ctrl path is waiting for all notifications to be received
 * @cookie: internal cookie to identify old notifications
 * @data: payload
 */
 struct iwl_mvm_internal_rxq_notif {
-	u32 type;
+	u16 type;
+	u16 sync;
 	u32 cookie;
 	u8 data[];
 } __packed;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d6ad77a..f746ff6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4037,12 +4037,10 @@ static void iwl_mvm_mac_event_callback(struct ieee80211_hw *hw,
 	}
 }
 
-static void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm)
+void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
+				     struct iwl_mvm_internal_rxq_notif *notif,
+				     u32 size)
 {
-	struct iwl_mvm_internal_rxq_notif data = {
-		.type = IWL_MVM_RXQ_SYNC,
-		.cookie = mvm->queue_sync_cookie,
-	};
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(notif_waitq);
 	u32 qmask = BIT(mvm->trans->num_rx_queues) - 1;
 	int ret;
@@ -4052,16 +4050,22 @@ static void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm)
 	if (!iwl_mvm_has_new_rx_api(mvm))
 		return;
 
-	atomic_set(&mvm->queue_sync_counter, mvm->trans->num_rx_queues);
+	notif->cookie = mvm->queue_sync_cookie;
+
+	if (notif->sync)
+		atomic_set(&mvm->queue_sync_counter,
+			   mvm->trans->num_rx_queues);
 
-	ret = iwl_mvm_notify_rx_queue(mvm, qmask, (u8 *)&data, sizeof(data));
+	ret = iwl_mvm_notify_rx_queue(mvm, qmask, (u8 *)notif, size);
 	if (ret) {
 		IWL_ERR(mvm, "Failed to trigger RX queues sync (%d)\n", ret);
 		goto out;
 	}
-	ret = wait_event_timeout(notif_waitq,
-				 atomic_read(&mvm->queue_sync_counter) == 0,
-				 HZ);
+
+	if (notif->sync)
+		ret = wait_event_timeout(notif_waitq,
+					 atomic_read(&mvm->queue_sync_counter) == 0,
+					 HZ);
 	WARN_ON_ONCE(!ret);
 
 out:
@@ -4072,9 +4076,13 @@ out:
 static void iwl_mvm_sync_rx_queues(struct ieee80211_hw *hw)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_internal_rxq_notif data = {
+		.type = IWL_MVM_RXQ_EMPTY,
+		.sync = 1,
+	};
 
 	mutex_lock(&mvm->mutex);
-	iwl_mvm_sync_rx_queues_internal(mvm);
+	iwl_mvm_sync_rx_queues_internal(mvm, &data, sizeof(data));
 	mutex_unlock(&mvm->mutex);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index c7c8a62..14b5f6a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1630,6 +1630,9 @@ void iwl_mvm_tdls_cancel_channel_switch(struct ieee80211_hw *hw,
 void iwl_mvm_rx_tdls_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_tdls_ch_switch_work(struct work_struct *work);
 
+void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
+				     struct iwl_mvm_internal_rxq_notif *notif,
+				     u32 size);
 struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm);
 
 void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index b4d9c42..306dd9b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -405,16 +405,19 @@ void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	notif = (void *)pkt->data;
 	internal_notif = (void *)notif->payload;
 
-	switch (internal_notif->type) {
-	case IWL_MVM_RXQ_SYNC:
-		if (mvm->queue_sync_cookie == internal_notif->cookie)
-			atomic_dec(&mvm->queue_sync_counter);
-		else
+	if (internal_notif->sync) {
+		if (mvm->queue_sync_cookie != internal_notif->cookie) {
 			WARN_ONCE(1,
 				  "Received expired RX queue sync message\n");
+			return;
+		}
+		atomic_dec(&mvm->queue_sync_counter);
+	}
+
+	switch (internal_notif->type) {
+	case IWL_MVM_RXQ_EMPTY:
 		break;
 	case IWL_MVM_RXQ_NOTIF_DEL_BA:
-		/* TODO */
 		break;
 	default:
 		WARN_ONCE(1, "Invalid identifier %d", internal_notif->type);
-- 
2.8.1

