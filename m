Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60582 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751239AbdFBJfg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 05:35:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 12:35:07 +0300
Message-Id: <20170602093516.16369-2-luca@coelho.fi> (sfid-20170602_113540_246332_4CD9F098)
In-Reply-To: <20170602093516.16369-1-luca@coelho.fi>
References: <20170602093516.16369-1-luca@coelho.fi>
Subject: [PATCH 01/10] iwlwifi: mvm: rs: start using LQ command color
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

Up until now, the driver was comparing the rate reported by the FW and
the rate of the latest LQ command to avoid processing data belonging
to the old LQ command. Recently, FW changed the meaning of the initial
rate field in tx response and it holds the actual rate (which is not
necessarily the initial rate of LQ's rate table). Use instead LQ cmd
color to be able to filter out tx responses/BA notifications which
where sent during earlier LQ commands' time frame.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h |  5 +++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 46 ++++++----------------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        | 15 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 12 +++++-
 6 files changed, 47 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h
index 1b7d265ffb0a..a10c6aae9ab9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h
@@ -307,6 +307,11 @@ enum {
 /* Bit 1-3: LQ command color. Used to match responses to LQ commands */
 #define LQ_FLAG_COLOR_POS               1
 #define LQ_FLAG_COLOR_MSK               (7 << LQ_FLAG_COLOR_POS)
+#define LQ_FLAG_COLOR_GET(_f)		(((_f) & LQ_FLAG_COLOR_MSK) >>\
+					 LQ_FLAG_COLOR_POS)
+#define LQ_FLAGS_COLOR_INC(_c)		((((_c) + 1) << LQ_FLAG_COLOR_POS) &\
+					 LQ_FLAG_COLOR_MSK)
+#define LQ_FLAG_COLOR_SET(_f, _c)	((_c) | ((_f) & ~LQ_FLAG_COLOR_MSK))
 
 /* Bit 4-5: Tx RTS BW Signalling
  * (0) No RTS BW signalling
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index 81b98915b1a4..1360ebfdc51b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -519,8 +519,11 @@ struct agg_tx_status {
  * bit-7 invalid rate indication
  */
 #define TX_RES_INIT_RATE_INDEX_MSK 0x0f
+#define TX_RES_RATE_TABLE_COLOR_POS 4
 #define TX_RES_RATE_TABLE_COLOR_MSK 0x70
 #define TX_RES_INV_RATE_INDEX_MSK 0x80
+#define TX_RES_RATE_TABLE_COL_GET(_f) (((_f) & TX_RES_RATE_TABLE_COLOR_MSK) >>\
+				       TX_RES_RATE_TABLE_COLOR_POS)
 
 #define IWL_MVM_TX_RES_GET_TID(_ra_tid) ((_ra_tid) & 0x0f)
 #define IWL_MVM_TX_RES_GET_RA(_ra_tid) ((_ra_tid) >> 4)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 7788eefcd2bd..aa785cf3cf68 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -2,7 +2,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -1083,34 +1083,6 @@ static void rs_get_lower_rate_down_column(struct iwl_lq_sta *lq_sta,
 		rs_get_lower_rate_in_column(lq_sta, rate);
 }
 
-/* Check if both rates are identical
- * allow_ant_mismatch enables matching a SISO rate on ANT_A or ANT_B
- * with a rate indicating STBC/BFER and ANT_AB.
- */
-static inline bool rs_rate_equal(struct rs_rate *a,
-				 struct rs_rate *b,
-				 bool allow_ant_mismatch)
-
-{
-	bool ant_match = (a->ant == b->ant) && (a->stbc == b->stbc) &&
-		(a->bfer == b->bfer);
-
-	if (allow_ant_mismatch) {
-		if (a->stbc || a->bfer) {
-			WARN_ONCE(a->ant != ANT_AB, "stbc %d bfer %d ant %d",
-				  a->stbc, a->bfer, a->ant);
-			ant_match |= (b->ant == ANT_A || b->ant == ANT_B);
-		} else if (b->stbc || b->bfer) {
-			WARN_ONCE(b->ant != ANT_AB, "stbc %d bfer %d ant %d",
-				  b->stbc, b->bfer, b->ant);
-			ant_match |= (a->ant == ANT_A || a->ant == ANT_B);
-		}
-	}
-
-	return (a->type == b->type) && (a->bw == b->bw) && (a->sgi == b->sgi) &&
-		(a->ldpc == b->ldpc) && (a->index == b->index) && ant_match;
-}
-
 /* Check if both rates share the same column */
 static inline bool rs_rate_column_match(struct rs_rate *a,
 					struct rs_rate *b)
@@ -1182,12 +1154,12 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	u32 lq_hwrate;
 	struct rs_rate lq_rate, tx_resp_rate;
 	struct iwl_scale_tbl_info *curr_tbl, *other_tbl, *tmp_tbl;
-	u8 reduced_txp = (uintptr_t)info->status.status_driver_data[0];
+	u32 tlc_info = (uintptr_t)info->status.status_driver_data[0];
+	u8 reduced_txp = tlc_info & RS_DRV_DATA_TXP_MSK;
+	u8 lq_color = RS_DRV_DATA_LQ_COLOR_GET(tlc_info);
 	u32 tx_resp_hwrate = (uintptr_t)info->status.status_driver_data[1];
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_lq_sta *lq_sta = &mvmsta->lq_sta;
-	bool allow_ant_mismatch = fw_has_api(&mvm->fw->ucode_capa,
-					     IWL_UCODE_TLV_API_LQ_SS_PARAMS);
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
 	if (!lq_sta) {
@@ -1262,10 +1234,10 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	rs_rate_from_ucode_rate(lq_hwrate, info->band, &lq_rate);
 
 	/* Here we actually compare this rate to the latest LQ command */
-	if (!rs_rate_equal(&tx_resp_rate, &lq_rate, allow_ant_mismatch)) {
+	if (lq_color != LQ_FLAG_COLOR_GET(table->flags)) {
 		IWL_DEBUG_RATE(mvm,
-			       "initial tx resp rate 0x%x does not match 0x%x\n",
-			       tx_resp_hwrate, lq_hwrate);
+			       "tx resp color 0x%x does not match 0x%x\n",
+			       lq_color, LQ_FLAG_COLOR_GET(table->flags));
 
 		/*
 		 * Since rates mis-match, the last LQ command may have failed.
@@ -3326,6 +3298,7 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 	u8 valid_tx_ant = 0;
 	struct iwl_lq_cmd *lq_cmd = &lq_sta->lq;
 	bool toggle_ant = false;
+	u32 color;
 
 	memcpy(&rate, initial_rate, sizeof(rate));
 
@@ -3380,6 +3353,9 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 				 num_rates, num_retries, valid_tx_ant,
 				 toggle_ant);
 
+	/* update the color of the LQ command (as a counter at bits 1-3) */
+	color = LQ_FLAGS_COLOR_INC(LQ_FLAG_COLOR_GET(lq_cmd->flags));
+	lq_cmd->flags = LQ_FLAG_COLOR_SET(lq_cmd->flags, color);
 }
 
 struct rs_bfer_active_iter_data {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index ee207f2c0a90..3abde1cb0303 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -2,6 +2,7 @@
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -357,6 +358,20 @@ struct iwl_lq_sta {
 	} pers;
 };
 
+/* ieee80211_tx_info's status_driver_data[0] is packed with lq color and txp
+ * Note, it's iwlmvm <-> mac80211 interface.
+ * bits 0-7: reduced tx power
+ * bits 8-10: LQ command's color
+ */
+#define RS_DRV_DATA_TXP_MSK 0xff
+#define RS_DRV_DATA_LQ_COLOR_POS 8
+#define RS_DRV_DATA_LQ_COLOR_MSK (7 << RS_DRV_DATA_LQ_COLOR_POS)
+#define RS_DRV_DATA_LQ_COLOR_GET(_f) (((_f) & RS_DRV_DATA_LQ_COLOR_MSK) >>\
+				      RS_DRV_DATA_LQ_COLOR_POS)
+#define RS_DRV_DATA_PACK(_c, _p) ((void *)(uintptr_t)\
+				  (((uintptr_t)_p) |\
+				   ((_c) << RS_DRV_DATA_LQ_COLOR_POS)))
+
 /* Initialize station's rate scaling information after adding station */
 void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  enum nl80211_band band, bool init);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 2716cb5483bf..ad62b67dceb2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -313,6 +313,7 @@ enum iwl_mvm_agg_state {
  *	This is basically (last acked packet++).
  * @rate_n_flags: Rate at which Tx was attempted. Holds the data between the
  *	Tx response (TX_CMD), and the block ack notification (COMPRESSED_BA).
+ * @lq_color: the color of the LQ command as it appears in tx response.
  * @amsdu_in_ampdu_allowed: true if A-MSDU in A-MPDU is allowed.
  * @state: state of the BA agreement establishment / tear down.
  * @txq_id: Tx queue used by the BA session / DQA
@@ -331,6 +332,7 @@ struct iwl_mvm_tid_data {
 	u16 next_reclaimed;
 	/* The rest is Tx AGG related */
 	u32 rate_n_flags;
+	u8 lq_color;
 	bool amsdu_in_ampdu_allowed;
 	enum iwl_mvm_agg_state state;
 	u16 txq_id;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index bcaceb64a6e8..f21901cd4a4f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1323,6 +1323,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 	struct iwl_mvm_sta *mvmsta;
 	struct sk_buff_head skbs;
 	u8 skb_freed = 0;
+	u8 lq_color;
 	u16 next_reclaimed, seq_ctl;
 	bool is_ndp = false;
 
@@ -1405,8 +1406,9 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		info->status.tx_time =
 			le16_to_cpu(tx_resp->wireless_media_time);
 		BUILD_BUG_ON(ARRAY_SIZE(info->status.status_driver_data) < 1);
+		lq_color = TX_RES_RATE_TABLE_COL_GET(tx_resp->tlc_info);
 		info->status.status_driver_data[0] =
-				(void *)(uintptr_t)tx_resp->reduced_tpc;
+			RS_DRV_DATA_PACK(lq_color, tx_resp->reduced_tpc);
 
 		ieee80211_tx_status(mvm->hw, skb);
 	}
@@ -1638,6 +1640,9 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 			le32_to_cpu(tx_resp->initial_rate);
 		mvmsta->tid_data[tid].tx_time =
 			le16_to_cpu(tx_resp->wireless_media_time);
+		mvmsta->tid_data[tid].lq_color =
+			(tx_resp->tlc_info & TX_RES_RATE_TABLE_COLOR_MSK) >>
+			TX_RES_RATE_TABLE_COLOR_POS;
 	}
 
 	rcu_read_unlock();
@@ -1707,6 +1712,11 @@ static void iwl_mvm_tx_reclaim(struct iwl_mvm *mvm, int sta_id, int tid,
 	iwl_mvm_check_ratid_empty(mvm, sta, tid);
 
 	freed = 0;
+
+	/* pack lq color from tid_data along the reduced txp */
+	ba_info->status.status_driver_data[0] =
+		RS_DRV_DATA_PACK(tid_data->lq_color,
+				 ba_info->status.status_driver_data[0]);
 	ba_info->status.status_driver_data[1] = (void *)(uintptr_t)rate;
 
 	skb_queue_walk(&reclaimed_skbs, skb) {
-- 
2.11.0
