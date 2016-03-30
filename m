Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53438 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbcC3OGZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:25 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/43] iwlwifi: mvm: move cmd queue to be #0 in dqa mode
Date: Wed, 30 Mar 2016 17:05:07 +0300
Message-Id: <1459346715-7954-35-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_161040_832823_1A5BF5F0)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Change the CMD queue to be queue #0 (rather than queue #9)
when working in DQA mode.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 8 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 5 ++++-
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index b38cb03..60eed84 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -89,6 +89,7 @@ enum {
 /*
  * DQA queue numbers
  *
+ * @IWL_MVM_DQA_CMD_QUEUE: a queue reserved for sending HCMDs to the FW
  * @IWL_MVM_DQA_GCAST_QUEUE: a queue reserved for P2P GO/SoftAP GCAST frames
  * @IWL_MVM_DQA_BSS_CLIENT_QUEUE: a queue reserved for BSS activity, to ensure
  *	that we are never left without the possibility to connect to an AP.
@@ -103,6 +104,7 @@ enum {
  * @IWL_MVM_DQA_MAX_DATA_QUEUE: last TXQ in pool for DATA frames
  */
 enum iwl_mvm_dqa_txq {
+	IWL_MVM_DQA_CMD_QUEUE = 0,
 	IWL_MVM_DQA_GCAST_QUEUE = 3,
 	IWL_MVM_DQA_BSS_CLIENT_QUEUE = 4,
 	IWL_MVM_DQA_MIN_MGMT_QUEUE = 5,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 2dc97a1..6ad5c60 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -652,7 +652,10 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	 */
 
 	memset(&mvm->queue_info, 0, sizeof(mvm->queue_info));
-	mvm->queue_info[IWL_MVM_CMD_QUEUE].hw_queue_refcount = 1;
+	if (iwl_mvm_is_dqa_supported(mvm))
+		mvm->queue_info[IWL_MVM_DQA_CMD_QUEUE].hw_queue_refcount = 1;
+	else
+		mvm->queue_info[IWL_MVM_CMD_QUEUE].hw_queue_refcount = 1;
 
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
 		atomic_set(&mvm->mac80211_queue_stop_count[i], 0);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 43fd857..5f95056 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -252,10 +252,14 @@ unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
 		.exclude_vif = exclude_vif,
 		.used_hw_queues =
 			BIT(IWL_MVM_OFFCHANNEL_QUEUE) |
-			BIT(mvm->aux_queue) |
-			BIT(IWL_MVM_CMD_QUEUE),
+			BIT(mvm->aux_queue),
 	};
 
+	if (iwl_mvm_is_dqa_supported(mvm))
+		data.used_hw_queues |= BIT(IWL_MVM_DQA_CMD_QUEUE);
+	else
+		data.used_hw_queues |= BIT(IWL_MVM_CMD_QUEUE);
+
 	lockdep_assert_held(&mvm->mutex);
 
 	/* mark all VIF used hw queues */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index e36bcad..cb00926 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -619,7 +619,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	trans_cfg.command_groups = iwl_mvm_groups;
 	trans_cfg.command_groups_size = ARRAY_SIZE(iwl_mvm_groups);
 
-	trans_cfg.cmd_queue = IWL_MVM_CMD_QUEUE;
+	if (iwl_mvm_is_dqa_supported(mvm))
+		trans_cfg.cmd_queue = IWL_MVM_DQA_CMD_QUEUE;
+	else
+		trans_cfg.cmd_queue = IWL_MVM_CMD_QUEUE;
 	trans_cfg.cmd_fifo = IWL_MVM_TX_FIFO_CMD;
 	trans_cfg.scd_set_active = true;
 
-- 
2.5.0

