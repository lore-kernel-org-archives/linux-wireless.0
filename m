Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41174 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754327AbcH3Ljd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 07:39:33 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 14:38:53 +0300
Message-Id: <1472557142-14782-7-git-send-email-luca@coelho.fi> (sfid-20160830_133948_591958_9B4D63BD)
In-Reply-To: <1472557142-14782-1-git-send-email-luca@coelho.fi>
References: <1472556999.27868.86.camel@coelho.fi>
 <1472557142-14782-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 07/16] iwlwifi: mvm: use defines for SCD_CONFIG_CMD enablement
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Due to the addition of another option in the SCD_CONFIG_CMD's
%enable field, change the assignment of this field to use
defines rather than hard-code the value itself.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 12 ++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 13 +++++++------
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index 4144623..6b4c63a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -675,13 +675,21 @@ static inline u32 iwl_mvm_get_scd_ssn(struct iwl_mvm_tx_resp *tx_resp)
 			    tx_resp->frame_count) & 0xfff;
 }
 
+/* Available options for the SCD_QUEUE_CFG HCMD */
+enum iwl_scd_cfg_actions {
+	SCD_CFG_DISABLE_QUEUE		= 0x0,
+	SCD_CFG_ENABLE_QUEUE		= 0x1,
+	SCD_CFG_UPDATE_QUEUE_TID	= 0x2,
+};
+
 /**
  * struct iwl_scd_txq_cfg_cmd - New txq hw scheduler config command
  * @token:
  * @sta_id: station id
  * @tid:
  * @scd_queue: scheduler queue to confiug
- * @enable: 1 queue enable, 0 queue disable
+ * @action: 1 queue enable, 0 queue disable, 2 change txq's tid owner
+ *	Value is one of %iwl_scd_cfg_actions options
  * @aggregate: 1 aggregated queue, 0 otherwise
  * @tx_fifo: %enum iwl_mvm_tx_fifo
  * @window: BA window size
@@ -692,7 +700,7 @@ struct iwl_scd_txq_cfg_cmd {
 	u8 sta_id;
 	u8 tid;
 	u8 scd_queue;
-	u8 enable;
+	u8 action;
 	u8 aggregate;
 	u8 tx_fifo;
 	u8 window;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 1ddcbea..e87473a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -536,7 +536,7 @@ int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 {
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
-		.enable = 0,
+		.action = SCD_CFG_DISABLE_QUEUE,
 	};
 	bool shared_queue;
 	unsigned long mq;
@@ -745,7 +745,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	if (using_inactive_queue) {
 		struct iwl_scd_txq_cfg_cmd cmd = {
 			.scd_queue = queue,
-			.enable = 0,
+			.action = SCD_CFG_DISABLE_QUEUE,
 		};
 		u8 ac;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 423efab..7c138fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -610,7 +610,7 @@ int iwl_mvm_reconfig_scd(struct iwl_mvm *mvm, int queue, int fifo, int sta_id,
 {
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
-		.enable = 1,
+		.action = SCD_CFG_ENABLE_QUEUE,
 		.window = frame_limit,
 		.sta_id = sta_id,
 		.ssn = cpu_to_le16(ssn),
@@ -684,7 +684,7 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	if (enable_queue) {
 		struct iwl_scd_txq_cfg_cmd cmd = {
 			.scd_queue = queue,
-			.enable = 1,
+			.action = SCD_CFG_ENABLE_QUEUE,
 			.window = cfg->frame_limit,
 			.sta_id = cfg->sta_id,
 			.ssn = cpu_to_le16(ssn),
@@ -711,7 +711,7 @@ void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 {
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
-		.enable = 0,
+		.action = SCD_CFG_DISABLE_QUEUE,
 	};
 	bool remove_mac_queue = true;
 	int ret;
@@ -746,8 +746,9 @@ void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 			~BIT(mac80211_queue);
 	mvm->queue_info[queue].hw_queue_refcount--;
 
-	cmd.enable = mvm->queue_info[queue].hw_queue_refcount ? 1 : 0;
-	if (!cmd.enable)
+	cmd.action = mvm->queue_info[queue].hw_queue_refcount ?
+		SCD_CFG_ENABLE_QUEUE : SCD_CFG_DISABLE_QUEUE;
+	if (cmd.action == SCD_CFG_DISABLE_QUEUE)
 		mvm->queue_info[queue].status = IWL_MVM_QUEUE_FREE;
 
 	IWL_DEBUG_TX_QUEUES(mvm,
@@ -757,7 +758,7 @@ void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 			    mvm->queue_info[queue].hw_queue_to_mac80211);
 
 	/* If the queue is still enabled - nothing left to do in this func */
-	if (cmd.enable) {
+	if (cmd.action == SCD_CFG_ENABLE_QUEUE) {
 		spin_unlock_bh(&mvm->queue_info_lock);
 		return;
 	}
-- 
2.8.1
