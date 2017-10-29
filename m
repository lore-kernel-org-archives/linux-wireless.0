Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42384 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750848AbdJ2M2x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 08:28:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 14:28:10 +0200
Message-Id: <20171029122816.8802-12-luca@coelho.fi> (sfid-20171029_132856_708859_FCE1DCF1)
In-Reply-To: <20171029122816.8802-1-luca@coelho.fi>
References: <20171029122816.8802-1-luca@coelho.fi>
Subject: [PATCH 11/17] iwlwifi: mvm: add missing implementation of flush for a000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In the mac flush flow, we should flush all existing queues.
Since FW API for a000 devices is flush per RA-TID, simply
flush all stations with all tids.
>From FW perspective, asking to flush a TID that doesn't have
a queue is valid, so we can just set all bits in the TID mask.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 941dbdebe143..ae2eb0c8cbeb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4004,19 +4004,12 @@ static void iwl_mvm_flush_no_vif(struct iwl_mvm *mvm, u32 queues, bool drop)
 {
 	int i;
 
-	if (drop) {
-		if (iwl_mvm_has_new_tx_api(mvm))
-			/* TODO new tx api */
-			WARN_ONCE(1,
-				  "Need to implement flush TX queue\n");
-		else
+	if (!iwl_mvm_has_new_tx_api(mvm)) {
+		if (drop)
 			iwl_mvm_flush_tx_path(mvm,
 				iwl_mvm_flushable_queues(mvm) & queues, 0);
-		return;
-	}
-
-	if (!iwl_mvm_has_new_tx_api(mvm)) {
-		iwl_trans_wait_tx_queues_empty(mvm->trans, queues);
+		else
+			iwl_trans_wait_tx_queues_empty(mvm->trans, queues);
 		return;
 	}
 
@@ -4029,8 +4022,11 @@ static void iwl_mvm_flush_no_vif(struct iwl_mvm *mvm, u32 queues, bool drop)
 		if (IS_ERR_OR_NULL(sta))
 			continue;
 
-		iwl_mvm_wait_sta_queues_empty(mvm,
-					      iwl_mvm_sta_from_mac80211(sta));
+		if (drop)
+			iwl_mvm_flush_sta_tids(mvm, i, 0xFF, 0);
+		else
+			iwl_mvm_wait_sta_queues_empty(mvm,
+					iwl_mvm_sta_from_mac80211(sta));
 	}
 	mutex_unlock(&mvm->mutex);
 }
-- 
2.14.2
