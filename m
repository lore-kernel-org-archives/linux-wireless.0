Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41160 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758167AbcH3Ljb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 07:39:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 30 Aug 2016 14:38:51 +0300
Message-Id: <1472557142-14782-5-git-send-email-luca@coelho.fi> (sfid-20160830_133942_868809_1EE2FF8C)
In-Reply-To: <1472557142-14782-1-git-send-email-luca@coelho.fi>
References: <1472556999.27868.86.camel@coelho.fi>
 <1472557142-14782-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 05/16] iwlwifi: mvm: keep track of tid associated with each queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When sending the SCD_QUEUE_CONFIG command, the queue is
associated to a specific TID. If later there is a need to
use this TID on a different queue instead, it first needs to
be unassociated from the first queue.

Keep track for every queue what TID is associated with it.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h   | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c   | 7 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 3 +++
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ee5a9ad..1806495 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -772,6 +772,7 @@ struct iwl_mvm {
 		u8 ra_sta_id; /* The RA this queue is mapped to, if exists */
 		bool reserved; /* Is this the TXQ reserved for a STA */
 		u8 mac80211_ac; /* The mac80211 AC this queue is mapped to */
+		u8 txq_tid; /* The TID "owner" of this queue*/
 		u16 tid_bitmap; /* Bitmap of the TIDs mapped to this queue */
 		/* Timestamp for inactivation per TID of this queue */
 		unsigned long last_frame_time[IWL_MAX_TID_COUNT + 1];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 1f235e8..730ba78 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -562,6 +562,7 @@ int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 
 	cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
 	cmd.tx_fifo = iwl_mvm_ac_to_tx_fifo[mvm->queue_info[queue].mac80211_ac];
+	cmd.tid = mvm->queue_info[queue].txq_tid;
 	mq = mvm->queue_info[queue].hw_queue_to_mac80211;
 	shared_queue = (mvm->queue_info[queue].hw_queue_refcount > 1);
 	spin_unlock_bh(&mvm->queue_info_lock);
@@ -591,6 +592,11 @@ int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 			     cmd.sta_id, tid, LINK_QUAL_AGG_FRAME_LIMIT_DEF,
 			     ssn, wdg_timeout);
 
+	/* Update the TID "owner" of the queue */
+	spin_lock_bh(&mvm->queue_info_lock);
+	mvm->queue_info[queue].txq_tid = tid;
+	spin_unlock_bh(&mvm->queue_info_lock);
+
 	/* TODO: Work-around SCD bug when moving back by multiples of 0x40 */
 
 	/* Redirect to lower AC */
@@ -749,6 +755,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		ac = mvm->queue_info[queue].mac80211_ac;
 		cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
 		cmd.tx_fifo = iwl_mvm_ac_to_tx_fifo[ac];
+		cmd.tid = mvm->queue_info[queue].txq_tid;
 		spin_unlock_bh(&mvm->queue_info_lock);
 
 		/* Disable the queue */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index dae64a6..423efab 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -669,6 +669,8 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 				tid_to_mac80211_ac[cfg->tid];
 		else
 			mvm->queue_info[queue].mac80211_ac = IEEE80211_AC_VO;
+
+		mvm->queue_info[queue].txq_tid = cfg->tid;
 	}
 
 	IWL_DEBUG_TX_QUEUES(mvm,
@@ -761,6 +763,7 @@ void iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 	}
 
 	cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
+	cmd.tid = mvm->queue_info[queue].txq_tid;
 
 	/* Make sure queue info is correct even though we overwrite it */
 	WARN(mvm->queue_info[queue].hw_queue_refcount ||
-- 
2.8.1
