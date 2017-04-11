Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50642 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752700AbdDKMi5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:38:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:42 +0300
Message-Id: <20170411123742.12214-26-luca@coelho.fi> (sfid-20170411_144105_045328_F90E0380)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 25/25] iwlwifi: mvm: separate queue mapping from queue enablement
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

As preparation for a000 different queue management, separate
mapping of queues from actual enablement.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 34 ++++++++++++++++----------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index dedea96a8e0f..8f199ff9be87 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright (C) 2015 Intel Deutschland GmbH
+ * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -644,20 +645,19 @@ int iwl_mvm_reconfig_scd(struct iwl_mvm *mvm, int queue, int fifo, int sta_id,
 	return ret;
 }
 
-void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
-			u16 ssn, const struct iwl_trans_txq_scd_cfg *cfg,
-			unsigned int wdg_timeout)
+static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
+				       int mac80211_queue, u8 sta_id, u8 tid)
 {
 	bool enable_queue = true;
 
 	spin_lock_bh(&mvm->queue_info_lock);
 
 	/* Make sure this TID isn't already enabled */
-	if (mvm->queue_info[queue].tid_bitmap & BIT(cfg->tid)) {
+	if (mvm->queue_info[queue].tid_bitmap & BIT(tid)) {
 		spin_unlock_bh(&mvm->queue_info_lock);
 		IWL_ERR(mvm, "Trying to enable TXQ %d with existing TID %d\n",
-			queue, cfg->tid);
-		return;
+			queue, tid);
+		return false;
 	}
 
 	/* Update mappings and refcounts */
@@ -666,17 +666,17 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 
 	mvm->queue_info[queue].hw_queue_to_mac80211 |= BIT(mac80211_queue);
 	mvm->queue_info[queue].hw_queue_refcount++;
-	mvm->queue_info[queue].tid_bitmap |= BIT(cfg->tid);
-	mvm->queue_info[queue].ra_sta_id = cfg->sta_id;
+	mvm->queue_info[queue].tid_bitmap |= BIT(tid);
+	mvm->queue_info[queue].ra_sta_id = sta_id;
 
 	if (enable_queue) {
-		if (cfg->tid != IWL_MAX_TID_COUNT)
+		if (tid != IWL_MAX_TID_COUNT)
 			mvm->queue_info[queue].mac80211_ac =
-				tid_to_mac80211_ac[cfg->tid];
+				tid_to_mac80211_ac[tid];
 		else
 			mvm->queue_info[queue].mac80211_ac = IEEE80211_AC_VO;
 
-		mvm->queue_info[queue].txq_tid = cfg->tid;
+		mvm->queue_info[queue].txq_tid = tid;
 	}
 
 	IWL_DEBUG_TX_QUEUES(mvm,
@@ -686,8 +686,16 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 
 	spin_unlock_bh(&mvm->queue_info_lock);
 
+	return enable_queue;
+}
+
+void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
+			u16 ssn, const struct iwl_trans_txq_scd_cfg *cfg,
+			unsigned int wdg_timeout)
+{
 	/* Send the enabling command if we need to */
-	if (enable_queue) {
+	if (iwl_mvm_update_txq_mapping(mvm, queue, mac80211_queue,
+				       cfg->sta_id, cfg->tid)) {
 		struct iwl_scd_txq_cfg_cmd cmd = {
 			.scd_queue = queue,
 			.action = SCD_CFG_ENABLE_QUEUE,
-- 
2.11.0
