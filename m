Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53934 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1760936AbdJRGck (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 02:32:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: sara.sharon@intel.com, linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 18 Oct 2017 09:31:12 +0300
Message-Id: <20171018063112.934-1-luca@coelho.fi> (sfid-20171018_083247_769718_0E5A36AA)
In-Reply-To: <20171013132502.10473-8-luca@coelho.fi>
References: <20171013132502.10473-8-luca@coelho.fi>
Subject: [PATCH v2 7/9] iwlwifi: mvm: add missing lq_color
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In the compressed BA notif, the driver didn't parse out
the LQ color, so statistics for the rates tried were
always thrown out. Add it so it gets correctly used.

While at it, fix the name of the relevant field in the
struct.

Fixes: c46e7724bfe9 ("iwlwifi: mvm: support new BA notification response")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---

In v2: a fix by Sari to properly initialize the tid_data lq_color
       field to avoid a double usage of the rate scaling macro.

drivers/net/wireless/intel/iwlwifi/fw/api/tx.h |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c    | 10 ++++++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index 14ad9fb895f9..f5d5ba7e37ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -710,7 +710,7 @@ enum iwl_mvm_ba_resp_flags {
  * @reduced_txp: power reduced according to TPC. This is the actual value and
  *	not a copy from the LQ command. Thus, if not the first rate was used
  *	for Tx-ing then this value will be set to 0 by FW.
- * @initial_rate: TLC rate info, initial rate index, TLC table color
+ * @tlc_rate_info: TLC rate info, initial rate index, TLC table color
  * @retry_cnt: retry count
  * @query_byte_cnt: SCD query byte count
  * @query_frame_cnt: SCD query frame count
@@ -730,7 +730,7 @@ struct iwl_mvm_compressed_ba_notif {
 	__le32 flags;
 	u8 sta_id;
 	u8 reduced_txp;
-	u8 initial_rate;
+	u8 tlc_rate_info;
 	u8 retry_cnt;
 	__le32 query_byte_cnt;
 	__le16 query_frame_cnt;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 172b5e63d3fb..35f455ede173 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1746,6 +1746,7 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		struct iwl_mvm_compressed_ba_notif *ba_res =
 			(void *)pkt->data;
+		u8 lq_color = TX_RES_RATE_TABLE_COL_GET(ba_res->tlc_rate_info);
 		int i;
 
 		sta_id = ba_res->sta_id;
@@ -1759,11 +1760,18 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		if (!le16_to_cpu(ba_res->tfd_cnt))
 			goto out;
 
+		rcu_read_lock();
+
+		mvmsta = iwl_mvm_sta_from_staid_rcu(mvm, sta_id);
+		if (!mvmsta)
+			goto out_unlock;
+
 		/* Free per TID */
 		for (i = 0; i < le16_to_cpu(ba_res->tfd_cnt); i++) {
 			struct iwl_mvm_compressed_ba_tfd *ba_tfd =
 				&ba_res->tfd[i];
 
+			mvmsta->tid_data[i].lq_color = lq_color;
 			iwl_mvm_tx_reclaim(mvm, sta_id, ba_tfd->tid,
 					   (int)(le16_to_cpu(ba_tfd->q_num)),
 					   le16_to_cpu(ba_tfd->tfd_index),
@@ -1771,6 +1779,8 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 					   le32_to_cpu(ba_res->tx_rate));
 		}
 
+out_unlock:
+		rcu_read_unlock();
 out:
 		IWL_DEBUG_TX_REPLY(mvm,
 				   "BA_NOTIFICATION Received from sta_id = %d, flags %x, sent:%d, acked:%d\n",
-- 
2.14.2
