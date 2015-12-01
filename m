Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbbLAJ7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:36 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/41] iwlwifi: mvm: drop low_latency_agg_frame_cnt_limit
Date: Tue,  1 Dec 2015 11:58:45 +0200
Message-Id: <1448963947-24302-19-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105947_608820_7AB1F7D7)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

This was an old workaround for solving latency issues with
certain Miracast adapters like ActionTec. However this isn't
needed anymore and furthermore it hurts throughput in other
use cases.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 4 ----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     | 2 --
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c     | 1 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c      | 8 +-------
 4 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 82a61f6..48d5ee1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1491,10 +1491,6 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 		goto err;
 #endif
 
-	if (!debugfs_create_u8("low_latency_agg_frame_limit", S_IRUSR | S_IWUSR,
-			       mvm->debugfs_dir,
-			       &mvm->low_latency_agg_frame_limit))
-		goto err;
 	if (!debugfs_create_u8("ps_disabled", S_IRUSR,
 			       mvm->debugfs_dir, &mvm->ps_disabled))
 		goto err;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ff32f36..f28e050 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -813,8 +813,6 @@ struct iwl_mvm {
 	bool lar_regdom_set;
 	enum iwl_mcc_source mcc_src;
 
-	u8 low_latency_agg_frame_limit;
-
 	/* TDLS channel switch data */
 	struct {
 		struct delayed_work dwork;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 9264928..e9b400c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -452,7 +452,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		mvm->first_agg_queue = 12;
 	}
 	mvm->sf_state = SF_UNINIT;
-	mvm->low_latency_agg_frame_limit = 6;
 	mvm->cur_ucode = IWL_UCODE_INIT;
 
 	mutex_init(&mvm->mutex);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index d1ad103..37c2db1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -3454,15 +3454,9 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 	 * Tx Fifo so that it can start a transaction in the same TxOP. This
 	 * basically allows the firmware to send bursts.
 	 */
-	if (iwl_mvm_vif_low_latency(mvmvif)) {
+	if (iwl_mvm_vif_low_latency(mvmvif))
 		lq_cmd->agg_frame_cnt_limit--;
 
-		if (mvm->low_latency_agg_frame_limit)
-			lq_cmd->agg_frame_cnt_limit =
-				min(lq_cmd->agg_frame_cnt_limit,
-				    mvm->low_latency_agg_frame_limit);
-	}
-
 	if (mvmsta->vif->p2p)
 		lq_cmd->flags |= LQ_FLAG_USE_RTS_MSK;
 
-- 
2.5.0

