Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36010 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751560AbdF1UPk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:15:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:20 +0300
Message-Id: <20170628201330.9432-22-luca@coelho.fi> (sfid-20170628_221557_222988_63BC5A34)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 21/31] iwlwifi: mvm: support multi tid ba notif
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When receiving a BA_NOTIF on new TX API, it can
contain BAs for several TIDs. Go over them and
reclaim TX for every TID.

Note that although the small API change, the API
version still isn't bumped forward, as this NIC
isn't still officially released.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 28 ++++++++++------------
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index 9d2a991221cf..97d7eed32622 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -668,13 +668,15 @@ struct iwl_mvm_ba_notif {
  * @q_num: TFD queue number
  * @tfd_index: Index of first un-acked frame in the  TFD queue
  * @scd_queue: For debug only - the physical queue the TFD queue is bound to
+ * @tid: TID of the queue (0-7)
  * @reserved: reserved for alignment
  */
 struct iwl_mvm_compressed_ba_tfd {
 	__le16 q_num;
 	__le16 tfd_index;
 	u8 scd_queue;
-	u8 reserved[3];
+	u8 tid;
+	u8 reserved[2];
 } __packed; /* COMPRESSED_BA_TFD_API_S_VER_1 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index c89bb453c496..627befb0d8d1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1813,6 +1813,7 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		struct iwl_mvm_compressed_ba_notif *ba_res =
 			(void *)pkt->data;
+		int i;
 
 		sta_id = ba_res->sta_id;
 		ba_info.status.ampdu_ack_len = (u8)le16_to_cpu(ba_res->done);
@@ -1825,22 +1826,17 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		if (!le16_to_cpu(ba_res->tfd_cnt))
 			goto out;
 
-		/*
-		 * TODO:
-		 * When supporting multi TID aggregations - we need to move
-		 * next_reclaimed to be per TXQ and not per TID or handle it
-		 * in a different way.
-		 * This will go together with SN and AddBA offload and cannot
-		 * be handled properly for now.
-		 */
-		WARN_ON(le16_to_cpu(ba_res->ra_tid_cnt) != 1);
-		tid = ba_res->ra_tid[0].tid;
-		if (tid == IWL_MGMT_TID)
-			tid = IWL_MAX_TID_COUNT;
-		iwl_mvm_tx_reclaim(mvm, sta_id, tid,
-				   (int)(le16_to_cpu(ba_res->tfd[0].q_num)),
-				   le16_to_cpu(ba_res->tfd[0].tfd_index),
-				   &ba_info, le32_to_cpu(ba_res->tx_rate));
+		/* Free per TID */
+		for (i = 0; i < le16_to_cpu(ba_res->tfd_cnt); i++) {
+			struct iwl_mvm_compressed_ba_tfd *ba_tfd =
+				&ba_res->tfd[i];
+
+			iwl_mvm_tx_reclaim(mvm, sta_id, ba_tfd->tid,
+					   (int)(le16_to_cpu(ba_tfd->q_num)),
+					   le16_to_cpu(ba_tfd->tfd_index),
+					   &ba_info,
+					   le32_to_cpu(ba_res->tx_rate));
+		}
 
 out:
 		IWL_DEBUG_TX_REPLY(mvm,
-- 
2.11.0
