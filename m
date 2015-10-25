Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbbJYMBh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:01:37 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/16] iwlwifi: mvm: let any command flag be passed to iwl_mvm_flushtx_path()
Date: Sun, 25 Oct 2015 14:01:08 +0200
Message-Id: <1445774476-24792-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_130140_202482_70ADC27C)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Instead of only allowing the caller to decide whether the CMD_ASYNC
flag is set, let it pass the entire flags bitmask.  This allows more
flexibility and will be needed when we call this function in the
suspend flow (where other flags are needed).

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c    | 2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h        | 2 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c        | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c         | 4 +---
 6 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 9b4fbb8..05928fb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -85,7 +85,7 @@ static ssize_t iwl_dbgfs_tx_flush_write(struct iwl_mvm *mvm, char *buf,
 	IWL_ERR(mvm, "FLUSHING queues: scd_q_msk = 0x%x\n", scd_q_msk);
 
 	mutex_lock(&mvm->mutex);
-	ret =  iwl_mvm_flush_tx_path(mvm, scd_q_msk, true) ? : count;
+	ret =  iwl_mvm_flush_tx_path(mvm, scd_q_msk, 0) ? : count;
 	mutex_unlock(&mvm->mutex);
 
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index aaffb54..adfcce4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1781,7 +1781,7 @@ static void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 		 * Flush them here.
 		 */
 		mutex_lock(&mvm->mutex);
-		iwl_mvm_flush_tx_path(mvm, tfd_msk, true);
+		iwl_mvm_flush_tx_path(mvm, tfd_msk, 0);
 		mutex_unlock(&mvm->mutex);
 
 		/*
@@ -3924,7 +3924,7 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 	}
 
 	if (drop) {
-		if (iwl_mvm_flush_tx_path(mvm, msk, true))
+		if (iwl_mvm_flush_tx_path(mvm, msk, 0))
 			IWL_ERR(mvm, "flush request fail\n");
 		mutex_unlock(&mvm->mutex);
 	} else {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 0d3aff1..4485bdb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1031,7 +1031,7 @@ const char *iwl_mvm_get_tx_fail_reason(u32 status);
 #else
 static inline const char *iwl_mvm_get_tx_fail_reason(u32 status) { return ""; }
 #endif
-int iwl_mvm_flush_tx_path(struct iwl_mvm *mvm, u32 tfd_msk, bool sync);
+int iwl_mvm_flush_tx_path(struct iwl_mvm *mvm, u32 tfd_msk, u32 flags);
 void iwl_mvm_async_handlers_purge(struct iwl_mvm *mvm);
 
 static inline void iwl_mvm_set_tx_cmd_ccmp(struct ieee80211_tx_info *info,
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index a9a3eb6..04d0cb3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -501,7 +501,7 @@ int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		if (ret)
 			return ret;
 		/* flush its queues here since we are freeing mvm_sta */
-		ret = iwl_mvm_flush_tx_path(mvm, mvm_sta->tfd_queue_msk, true);
+		ret = iwl_mvm_flush_tx_path(mvm, mvm_sta->tfd_queue_msk, 0);
 		if (ret)
 			return ret;
 		ret = iwl_trans_wait_tx_queue_empty(mvm->trans,
@@ -1155,7 +1155,7 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	if (old_state >= IWL_AGG_ON) {
 		iwl_mvm_drain_sta(mvm, mvmsta, true);
-		if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), true))
+		if (iwl_mvm_flush_tx_path(mvm, BIT(txq_id), 0))
 			IWL_ERR(mvm, "Couldn't flush the AGG queue\n");
 		iwl_trans_wait_tx_queue_empty(mvm->trans,
 					      mvmsta->tfd_queue_msk);
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index dbd7d54..7530eb2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -129,7 +129,7 @@ void iwl_mvm_roc_done_wk(struct work_struct *wk)
 	 * issue as it will have to complete before the next command is
 	 * executed, and a new time event means a new command.
 	 */
-	iwl_mvm_flush_tx_path(mvm, queues, false);
+	iwl_mvm_flush_tx_path(mvm, queues, CMD_ASYNC);
 }
 
 static void iwl_mvm_roc_finished(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index ff8b9bd..c652a66 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -1099,7 +1099,7 @@ out:
  * 2) flush the Tx path
  * 3) wait for the transport queues to be empty
  */
-int iwl_mvm_flush_tx_path(struct iwl_mvm *mvm, u32 tfd_msk, bool sync)
+int iwl_mvm_flush_tx_path(struct iwl_mvm *mvm, u32 tfd_msk, u32 flags)
 {
 	int ret;
 	struct iwl_tx_path_flush_cmd flush_cmd = {
@@ -1107,8 +1107,6 @@ int iwl_mvm_flush_tx_path(struct iwl_mvm *mvm, u32 tfd_msk, bool sync)
 		.flush_ctl = cpu_to_le16(DUMP_TX_FIFO_FLUSH),
 	};
 
-	u32 flags = sync ? 0 : CMD_ASYNC;
-
 	ret = iwl_mvm_send_cmd_pdu(mvm, TXPATH_FLUSH, flags,
 				   sizeof(flush_cmd), &flush_cmd);
 	if (ret)
-- 
2.1.4

