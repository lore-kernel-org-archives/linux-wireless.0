Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39558 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750940AbeDMMoV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:44:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:46 +0300
Message-Id: <20180413124256.21769-16-luca@coelho.fi> (sfid-20180413_144425_115908_CEA05AB4)
In-Reply-To: <20180413124256.21769-1-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
Subject: [PATCH 15/25] iwlwifi: mvm: use shorter queues for mgmt and auxilary queues
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In 22000 devices, aka gen2, the TFS is 256 bytes.
In order to save memory, use shorter TX queue for aux and
mgmt queues, since there isn't much traffic on them.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c  | 9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h b/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
index 1f45b2ce5295..6ac240b6eace 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
@@ -132,6 +132,7 @@ enum iwl_tx_queue_cfg_actions {
 };
 
 #define IWL_DEFAULT_QUEUE_SIZE 256
+#define IWL_MGMT_QUEUE_SIZE 16
 /**
  * struct iwl_tx_queue_cfg_cmd - txq hw scheduler config command
  * @sta_id: station id
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index f21257dc298b..0ec22f4ddd8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -728,13 +728,14 @@ int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm, int mac80211_queue,
 		.sta_id = sta_id,
 		.tid = tid,
 	};
-	int queue;
+	int queue, size = IWL_DEFAULT_QUEUE_SIZE;
 
-	if (cmd.tid == IWL_MAX_TID_COUNT)
+	if (cmd.tid == IWL_MAX_TID_COUNT) {
 		cmd.tid = IWL_MGMT_TID;
+		size = IWL_MGMT_QUEUE_SIZE;
+	}
 	queue = iwl_trans_txq_alloc(mvm->trans, (void *)&cmd,
-				    SCD_QUEUE_CFG, IWL_DEFAULT_QUEUE_SIZE,
-				    timeout);
+				    SCD_QUEUE_CFG, size, timeout);
 
 	if (queue < 0) {
 		IWL_DEBUG_TX_QUEUES(mvm,
-- 
2.16.3
