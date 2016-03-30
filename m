Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:60163 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbcC3OGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:24 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/43] iwlwifi: mvm: allocate dedicated queue for cab in dqa mode
Date: Wed, 30 Mar 2016 17:05:06 +0300
Message-Id: <1459346715-7954-34-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160629_962460_9DCD6DB6)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In DQA mode, allocate a dedicated queue (#3) for content
after beacon (AKA "CaB").

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 18 ++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 9652687..b38cb03 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -89,6 +89,7 @@ enum {
 /*
  * DQA queue numbers
  *
+ * @IWL_MVM_DQA_GCAST_QUEUE: a queue reserved for P2P GO/SoftAP GCAST frames
  * @IWL_MVM_DQA_BSS_CLIENT_QUEUE: a queue reserved for BSS activity, to ensure
  *	that we are never left without the possibility to connect to an AP.
  * @IWL_MVM_DQA_MIN_MGMT_QUEUE: first TXQ in pool for MGMT and non-QOS frames.
@@ -102,6 +103,7 @@ enum {
  * @IWL_MVM_DQA_MAX_DATA_QUEUE: last TXQ in pool for DATA frames
  */
 enum iwl_mvm_dqa_txq {
+	IWL_MVM_DQA_GCAST_QUEUE = 3,
 	IWL_MVM_DQA_BSS_CLIENT_QUEUE = 4,
 	IWL_MVM_DQA_MIN_MGMT_QUEUE = 5,
 	IWL_MVM_DQA_MAX_MGMT_QUEUE = 8,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index c02c105..43fd857 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -447,13 +447,19 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 
 	/* Allocate the CAB queue for softAP and GO interfaces */
 	if (vif->type == NL80211_IFTYPE_AP) {
-		u8 queue = find_first_zero_bit(&used_hw_queues,
-					       mvm->first_agg_queue);
+		u8 queue;
 
-		if (queue >= mvm->first_agg_queue) {
-			IWL_ERR(mvm, "Failed to allocate cab queue\n");
-			ret = -EIO;
-			goto exit_fail;
+		if (!iwl_mvm_is_dqa_supported(mvm)) {
+			queue = find_first_zero_bit(&used_hw_queues,
+						    mvm->first_agg_queue);
+
+			if (queue >= mvm->first_agg_queue) {
+				IWL_ERR(mvm, "Failed to allocate cab queue\n");
+				ret = -EIO;
+				goto exit_fail;
+			}
+		} else {
+			queue = IWL_MVM_DQA_GCAST_QUEUE;
 		}
 
 		vif->cab_queue = queue;
-- 
2.5.0

