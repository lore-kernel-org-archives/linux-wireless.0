Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11809 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965143AbcAZKVx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 05:21:53 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/5] iwlwifi: mvm: rs: fix TPC statistics handling
Date: Tue, 26 Jan 2016 12:21:38 +0200
Message-Id: <1453803698-20550-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160126_112202_481032_C4575E54)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9D452F@hasmsx109.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9D452F@hasmsx109.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

FW behaviour changed and now updates driver about the used TPC
reduction in the following cases:
1. In tx response, which is used mostly for a single frame case
2. In BA notification

When tx aggregation fails with the initial rate, FW will send
to the driver BA notification and will try to transmit with the
next rate, but this time without tx power reduction. Thus, in case
of a failure with the initial rate, driver will get two BA notifications,
the first one with reduced tx power as in the LQ command and the second
one with 0 power reduction.

This patch adapts the TPC statistics according to the description above:
1. Use BA notifications instead of Tx response
2. For TPC only, drop the optimization which considers empty BA as one
MPDU. The reason is that with TPC we want to recover very quickly from
a bad power reduction and, therefore we'd like the success ratio to get
an immediate hit when failing to get a BA, so we'd switch back to a
lower or zero power reduction

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 74 ++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  5 +-
 3 files changed, 56 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index 0036d18..ba3f0bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -510,6 +510,9 @@ struct iwl_mvm_tx_resp {
  * @scd_ssn: the index of the last contiguously sent packet
  * @txed: number of Txed frames in this batch
  * @txed_2_done: number of Acked frames in this batch
+ * @reduced_txp: power reduced according to TPC. This is the actual value and
+ *	not a copy from the LQ command. Thus, if not the first rate was used
+ *	for Tx-ing then this value will be set to 0 by FW.
  */
 struct iwl_mvm_ba_notif {
 	__le32 sta_addr_lo32;
@@ -524,7 +527,8 @@ struct iwl_mvm_ba_notif {
 	__le16 scd_ssn;
 	u8 txed;
 	u8 txed_2_done;
-	__le16 reserved1;
+	u8 reduced_txp;
+	u8 reserved1;
 } __packed;
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 7bb6fd0..94caa88 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -2,6 +2,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -724,14 +725,28 @@ static int _rs_collect_tx_data(struct iwl_mvm *mvm,
 	return 0;
 }
 
-static int rs_collect_tx_data(struct iwl_mvm *mvm,
-			      struct iwl_lq_sta *lq_sta,
-			      struct iwl_scale_tbl_info *tbl,
-			      int scale_index, int attempts, int successes,
-			      u8 reduced_txp)
+static int rs_collect_tpc_data(struct iwl_mvm *mvm,
+			       struct iwl_lq_sta *lq_sta,
+			       struct iwl_scale_tbl_info *tbl,
+			       int scale_index, int attempts, int successes,
+			       u8 reduced_txp)
+{
+	struct iwl_rate_scale_data *window = NULL;
+
+	if (WARN_ON_ONCE(reduced_txp > TPC_MAX_REDUCTION))
+		return -EINVAL;
+
+	window = &tbl->tpc_win[reduced_txp];
+	return  _rs_collect_tx_data(mvm, tbl, scale_index, attempts, successes,
+				    window);
+}
+
+static int rs_collect_tlc_data(struct iwl_mvm *mvm,
+			       struct iwl_lq_sta *lq_sta,
+			       struct iwl_scale_tbl_info *tbl,
+			       int scale_index, int attempts, int successes)
 {
 	struct iwl_rate_scale_data *window = NULL;
-	int ret;
 
 	if (scale_index < 0 || scale_index >= IWL_RATE_COUNT)
 		return -EINVAL;
@@ -745,16 +760,6 @@ static int rs_collect_tx_data(struct iwl_mvm *mvm,
 
 	/* Select window for current tx bit rate */
 	window = &(tbl->win[scale_index]);
-
-	ret = _rs_collect_tx_data(mvm, tbl, scale_index, attempts, successes,
-				  window);
-	if (ret)
-		return ret;
-
-	if (WARN_ON_ONCE(reduced_txp > TPC_MAX_REDUCTION))
-		return -EINVAL;
-
-	window = &tbl->tpc_win[reduced_txp];
 	return _rs_collect_tx_data(mvm, tbl, scale_index, attempts, successes,
 				   window);
 }
@@ -1301,17 +1306,30 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	 * first index into rate scale table.
 	 */
 	if (info->flags & IEEE80211_TX_STAT_AMPDU) {
-		/* ampdu_ack_len = 0 marks no BA was received. In this case
-		 * treat it as a single frame loss as we don't want the success
-		 * ratio to dip too quickly because a BA wasn't received
+		rs_collect_tpc_data(mvm, lq_sta, curr_tbl, lq_rate.index,
+				    info->status.ampdu_len,
+				    info->status.ampdu_ack_len,
+				    reduced_txp);
+
+		/* ampdu_ack_len = 0 marks no BA was received. For TLC, treat
+		 * it as a single frame loss as we don't want the success ratio
+		 * to dip too quickly because a BA wasn't received.
+		 * For TPC, there's no need for this optimisation since we want
+		 * to recover very quickly from a bad power reduction and,
+		 * therefore we'd like the success ratio to get an immediate hit
+		 * when failing to get a BA, so we'd switch back to a lower or
+		 * zero power reduction. When FW transmits agg with a rate
+		 * different from the initial rate, it will not use reduced txp
+		 * and will send BA notification twice (one empty with reduced
+		 * txp equal to the value from LQ and one with reduced txp 0).
+		 * We need to update counters for each txp level accordingly.
 		 */
 		if (info->status.ampdu_ack_len == 0)
 			info->status.ampdu_len = 1;
 
-		rs_collect_tx_data(mvm, lq_sta, curr_tbl, lq_rate.index,
-				   info->status.ampdu_len,
-				   info->status.ampdu_ack_len,
-				   reduced_txp);
+		rs_collect_tlc_data(mvm, lq_sta, curr_tbl, lq_rate.index,
+				    info->status.ampdu_len,
+				    info->status.ampdu_ack_len);
 
 		/* Update success/fail counts if not searching for new mode */
 		if (lq_sta->rs_state == RS_STATE_STAY_IN_COLUMN) {
@@ -1344,9 +1362,13 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			else
 				continue;
 
-			rs_collect_tx_data(mvm, lq_sta, tmp_tbl, lq_rate.index,
-					   1, i < retries ? 0 : legacy_success,
-					   reduced_txp);
+			rs_collect_tpc_data(mvm, lq_sta, tmp_tbl,
+					    lq_rate.index, 1,
+					    i < retries ? 0 : legacy_success,
+					    reduced_txp);
+			rs_collect_tlc_data(mvm, lq_sta, tmp_tbl,
+					    lq_rate.index, 1,
+					    i < retries ? 0 : legacy_success);
 		}
 
 		/* Update success/fail counts if not searching for new mode */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 8bf48a7..0914ec2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1029,7 +1029,6 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 		mvmsta->tid_data[tid].rate_n_flags =
 			le32_to_cpu(tx_resp->initial_rate);
-		mvmsta->tid_data[tid].reduced_tpc = tx_resp->reduced_tpc;
 		mvmsta->tid_data[tid].tx_time =
 			le16_to_cpu(tx_resp->wireless_media_time);
 	}
@@ -1060,7 +1059,7 @@ static void iwl_mvm_tx_info_from_ba_notif(struct ieee80211_tx_info *info,
 	/* TODO: not accounted if the whole A-MPDU failed */
 	info->status.tx_time = tid_data->tx_time;
 	info->status.status_driver_data[0] =
-		(void *)(uintptr_t)tid_data->reduced_tpc;
+		(void *)(uintptr_t)ba_notif->reduced_txp;
 	info->status.status_driver_data[1] =
 		(void *)(uintptr_t)tid_data->rate_n_flags;
 }
@@ -1133,6 +1132,8 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 			   scd_flow, ba_resp_scd_ssn, ba_notif->txed,
 			   ba_notif->txed_2_done);
 
+	IWL_DEBUG_TX_REPLY(mvm, "reduced txp from ba notif %d\n",
+			   ba_notif->reduced_txp);
 	tid_data->next_reclaimed = ba_resp_scd_ssn;
 
 	iwl_mvm_check_ratid_empty(mvm, sta, tid);
-- 
2.5.0

