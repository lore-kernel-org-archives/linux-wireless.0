Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33390 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753077AbcGFKoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:06 +0300
Message-Id: <1467801651-1816-11-git-send-email-luca@coelho.fi> (sfid-20160706_124426_600409_83192250)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 11/56] iwlwifi: mvm: update aux queue in dqa mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In DQA mode the AUX queue is mapped elsewhere than in non-
DQA mode. Update the code to reflect this.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c    | 15 +++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c    | 18 ++++++++++++++++--
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index b06380d..a1d3d95 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -90,6 +90,7 @@ enum {
  * DQA queue numbers
  *
  * @IWL_MVM_DQA_CMD_QUEUE: a queue reserved for sending HCMDs to the FW
+ * @IWL_MVM_DQA_AUX_QUEUE: a queue reserved for aux frames
  * @IWL_MVM_DQA_P2P_DEVICE_QUEUE: a queue reserved for P2P device frames
  * @IWL_MVM_DQA_GCAST_QUEUE: a queue reserved for P2P GO/SoftAP GCAST frames
  * @IWL_MVM_DQA_BSS_CLIENT_QUEUE: a queue reserved for BSS activity, to ensure
@@ -108,6 +109,7 @@ enum {
  */
 enum iwl_mvm_dqa_txq {
 	IWL_MVM_DQA_CMD_QUEUE = 0,
+	IWL_MVM_DQA_AUX_QUEUE = 1,
 	IWL_MVM_DQA_P2P_DEVICE_QUEUE = 2,
 	IWL_MVM_DQA_GCAST_QUEUE = 3,
 	IWL_MVM_DQA_BSS_CLIENT_QUEUE = 4,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 063ebbe..a08db00 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -577,18 +577,21 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	mvm->restart_fw = iwlwifi_mod_params.restart_fw ? -1 : 0;
 
-	mvm->aux_queue = 15;
 	if (!iwl_mvm_is_dqa_supported(mvm)) {
-		mvm->first_agg_queue = 16;
 		mvm->last_agg_queue = mvm->cfg->base_params->num_of_queues - 1;
+
+		if (mvm->cfg->base_params->num_of_queues == 16) {
+			mvm->aux_queue = 11;
+			mvm->first_agg_queue = 12;
+		} else {
+			mvm->aux_queue = 15;
+			mvm->first_agg_queue = 16;
+		}
 	} else {
+		mvm->aux_queue = IWL_MVM_DQA_AUX_QUEUE;
 		mvm->first_agg_queue = IWL_MVM_DQA_MIN_DATA_QUEUE;
 		mvm->last_agg_queue = IWL_MVM_DQA_MAX_DATA_QUEUE;
 	}
-	if (mvm->cfg->base_params->num_of_queues == 16) {
-		mvm->aux_queue = 11;
-		mvm->first_agg_queue = 12;
-	}
 	mvm->sf_state = SF_UNINIT;
 	mvm->cur_ucode = IWL_UCODE_INIT;
 	mvm->drop_bcn_ap_mode = true;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 9d4ebc9..cf06817 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1309,8 +1309,9 @@ int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
 	lockdep_assert_held(&mvm->mutex);
 
 	/* Map Aux queue to fifo - needs to happen before adding Aux station */
-	iwl_mvm_enable_ac_txq(mvm, mvm->aux_queue, mvm->aux_queue,
-			      IWL_MVM_TX_FIFO_MCAST, 0, wdg_timeout);
+	if (!iwl_mvm_is_dqa_supported(mvm))
+		iwl_mvm_enable_ac_txq(mvm, mvm->aux_queue, mvm->aux_queue,
+				      IWL_MVM_TX_FIFO_MCAST, 0, wdg_timeout);
 
 	/* Allocate aux station and assign to it the aux queue */
 	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->aux_sta, BIT(mvm->aux_queue),
@@ -1318,6 +1319,19 @@ int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
 	if (ret)
 		return ret;
 
+	if (iwl_mvm_is_dqa_supported(mvm)) {
+		struct iwl_trans_txq_scd_cfg cfg = {
+			.fifo = IWL_MVM_TX_FIFO_MCAST,
+			.sta_id = mvm->aux_sta.sta_id,
+			.tid = IWL_MAX_TID_COUNT,
+			.aggregate = false,
+			.frame_limit = IWL_FRAME_LIMIT,
+		};
+
+		iwl_mvm_enable_txq(mvm, mvm->aux_queue, mvm->aux_queue, 0, &cfg,
+				   wdg_timeout);
+	}
+
 	ret = iwl_mvm_add_int_sta_common(mvm, &mvm->aux_sta, NULL,
 					 MAC_INDEX_AUX, 0);
 
-- 
2.8.1

