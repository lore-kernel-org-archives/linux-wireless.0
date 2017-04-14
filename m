Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:10633 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754058AbdDNJEq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:04:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:01:57 +0300
Message-Id: <20170414090210.31397-14-luca@coelho.fi> (sfid-20170414_110512_924294_5FFA9F0F)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 13/26] iwlwifi: mvm: support moving to mgmt tid
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For a000 FW moved to 15 as management TID.
The change for us is fairly local - translate old TID to 15
when enabling and disabling a queue, and make sure to cover
it also on TX responses.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c    | 9 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 4 ++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 723402ee7be2..c87a58ee012a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -397,6 +397,7 @@ static inline void iwl_free_rxb(struct iwl_rx_cmd_buffer *r)
  */
 #define IWL_MAX_HW_QUEUES		32
 #define IWL_MAX_TID_COUNT	8
+#define IWL_MGMT_TID		15
 #define IWL_FRAME_LIMIT	64
 #define IWL_MAX_RX_HW_QUEUES	16
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 876e58905cd8..2436253d936c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1422,7 +1422,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	if (!IS_ERR(sta)) {
 		mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
-		if (tid != IWL_TID_NON_QOS) {
+		if (tid != IWL_TID_NON_QOS && tid != IWL_MGMT_TID) {
 			struct iwl_mvm_tid_data *tid_data =
 				&mvmsta->tid_data[tid];
 			bool send_eosp_ndp = false;
@@ -1764,8 +1764,11 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		 * This will go together with SN and AddBA offload and cannot
 		 * be handled properly for now.
 		 */
-		WARN_ON(le16_to_cpu(ba_res->tfd_cnt) != 1);
-		iwl_mvm_tx_reclaim(mvm, sta_id, ba_res->ra_tid[0].tid,
+		WARN_ON(le16_to_cpu(ba_res->ra_tid_cnt) != 1);
+		tid = ba_res->ra_tid[0].tid;
+		if (tid == IWL_MGMT_TID)
+			tid = IWL_MAX_TID_COUNT;
+		iwl_mvm_tx_reclaim(mvm, sta_id, tid,
 				   (int)ba_res->tfd[0].q_num,
 				   le16_to_cpu(ba_res->tfd[0].tfd_index),
 				   &ba_info, le32_to_cpu(ba_res->tx_rate));
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 74f62851f653..70ec048ac152 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -714,6 +714,8 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 		};
 
 		if (iwl_mvm_has_new_tx_api(mvm)) {
+			if (cmd.tid == IWL_MAX_TID_COUNT)
+				cmd.tid = IWL_MGMT_TID;
 			iwl_trans_txq_alloc(mvm->trans, (void *)&cmd,
 					    SCD_QUEUE_CFG, wdg_timeout);
 			return;
@@ -810,6 +812,8 @@ int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		iwl_trans_txq_free(mvm->trans, queue);
+		if (cmd.tid == IWL_MAX_TID_COUNT)
+			cmd.tid = IWL_MGMT_TID;
 		ret = iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, flags,
 					   sizeof(cmd), &cmd);
 	} else {
-- 
2.11.0
