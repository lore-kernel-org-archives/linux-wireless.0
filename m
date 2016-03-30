Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53438 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbcC3OGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:24 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/43] iwlwifi: mvm: set sta_id in SCD_QUEUE_CONFIG cmd
Date: Wed, 30 Mar 2016 17:05:05 +0300
Message-Id: <1459346715-7954-33-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160629_380615_15D7DC58)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Set the correct sta_id in the SCD_QUEUE_CONFIG command sent
to the FW when enabling/disabling queues. This is needed in
DQA-mode to allow the FW to associate between queue and STA.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h   | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index a9de2ad..cd5f16e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -665,6 +665,7 @@ struct iwl_mvm {
 		/* Map to HW queue */
 		u32 hw_queue_to_mac80211;
 		u8 hw_queue_refcount;
+		u8 ra_sta_id; /* The RA this queue is mapped to, if exists */
 		/*
 		 * This is to mark that queue is reserved for a STA but not yet
 		 * allocated. This is needed to make sure we have at least one
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 76866b9..486c985 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -608,6 +608,8 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	mvm->queue_info[queue].hw_queue_refcount++;
 	if (mvm->queue_info[queue].hw_queue_refcount > 1)
 		enable_queue = false;
+	else
+		mvm->queue_info[queue].ra_sta_id = cfg->sta_id;
 	mvm->queue_info[queue].tid_bitmap |= BIT(cfg->tid);
 
 	IWL_DEBUG_TX_QUEUES(mvm,
@@ -693,6 +695,8 @@ void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 		return;
 	}
 
+	cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
+
 	/* Make sure queue info is correct even though we overwrite it */
 	WARN(mvm->queue_info[queue].hw_queue_refcount ||
 	     mvm->queue_info[queue].tid_bitmap ||
-- 
2.5.0

