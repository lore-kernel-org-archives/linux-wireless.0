Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25570C64EB8
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E08EE2087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E08EE2087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbeJHP2b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:31 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56390 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbeJHP2b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:31 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9Qje-0003w6-0n; Mon, 08 Oct 2018 11:17:50 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:27 +0300
Message-Id: <20181008081735.3401-11-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/18] iwlwifi: mvm: remove per-queue hw refcount
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There's no need to have a hw refcount if we just mark the
command queue with a (fake) TID; at that point, the refcount
becomes equivalent to the hweight() of the TID bitmap.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  9 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 41 +++++++++----------
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  2 +-
 4 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index c5df73231ba3..dade206d5511 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -364,7 +364,14 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	 */
 
 	memset(&mvm->queue_info, 0, sizeof(mvm->queue_info));
-	mvm->queue_info[IWL_MVM_DQA_CMD_QUEUE].hw_queue_refcount = 1;
+	/*
+	 * Set a 'fake' TID for the command queue, since we use the
+	 * hweight() of the tid_bitmap as a refcount now. Not that
+	 * we ever even consider the command queue as one we might
+	 * want to reuse, but be safe nevertheless.
+	 */
+	mvm->queue_info[IWL_MVM_DQA_CMD_QUEUE].tid_bitmap =
+		BIT(IWL_MAX_TID_COUNT + 2);
 
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
 		atomic_set(&mvm->mac80211_queue_stop_count[i], 0);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index f5a532dc712d..7074fd1f8ce7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -789,7 +789,6 @@ struct iwl_mvm_geo_profile {
 };
 
 struct iwl_mvm_dqa_txq_info {
-	u8 hw_queue_refcount;
 	u8 ra_sta_id; /* The RA this queue is mapped to, if exists */
 	bool reserved; /* Is this the TXQ reserved for a STA */
 	u8 mac80211_ac; /* The mac80211 AC this queue is mapped to */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index fd33b8d148b3..ce03f9750c3a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -387,7 +387,7 @@ static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue,
 
 	spin_lock_bh(&mvm->queue_info_lock);
 
-	if (WARN_ON(mvm->queue_info[queue].hw_queue_refcount == 0)) {
+	if (WARN_ON(mvm->queue_info[queue].tid_bitmap == 0)) {
 		spin_unlock_bh(&mvm->queue_info_lock);
 		return 0;
 	}
@@ -413,17 +413,16 @@ static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue,
 	if (remove_mac_queue)
 		mvm->hw_queue_to_mac80211[queue] &=
 			~BIT(mac80211_queue);
-	mvm->queue_info[queue].hw_queue_refcount--;
 
-	cmd.action = mvm->queue_info[queue].hw_queue_refcount ?
+	cmd.action = mvm->queue_info[queue].tid_bitmap ?
 		SCD_CFG_ENABLE_QUEUE : SCD_CFG_DISABLE_QUEUE;
 	if (cmd.action == SCD_CFG_DISABLE_QUEUE)
 		mvm->queue_info[queue].status = IWL_MVM_QUEUE_FREE;
 
 	IWL_DEBUG_TX_QUEUES(mvm,
-			    "Disabling TXQ #%d refcount=%d (mac80211 map:0x%x)\n",
+			    "Disabling TXQ #%d tids=0x%x (mac80211 map:0x%x)\n",
 			    queue,
-			    mvm->queue_info[queue].hw_queue_refcount,
+			    mvm->queue_info[queue].tid_bitmap,
 			    mvm->hw_queue_to_mac80211[queue]);
 
 	/* If the queue is still enabled - nothing left to do in this func */
@@ -436,16 +435,13 @@ static int iwl_mvm_disable_txq(struct iwl_mvm *mvm, int queue,
 	cmd.tid = mvm->queue_info[queue].txq_tid;
 
 	/* Make sure queue info is correct even though we overwrite it */
-	WARN(mvm->queue_info[queue].hw_queue_refcount ||
-	     mvm->queue_info[queue].tid_bitmap ||
-	     mvm->hw_queue_to_mac80211[queue],
-	     "TXQ #%d info out-of-sync - refcount=%d, mac map=0x%x, tid=0x%x\n",
-	     queue, mvm->queue_info[queue].hw_queue_refcount,
+	WARN(mvm->queue_info[queue].tid_bitmap ||
 	     mvm->hw_queue_to_mac80211[queue],
+	     "TXQ #%d info out-of-sync - mac map=0x%x, tids=0x%x\n",
+	     queue, mvm->hw_queue_to_mac80211[queue],
 	     mvm->queue_info[queue].tid_bitmap);
 
 	/* If we are here - the queue is freed and we can zero out these vals */
-	mvm->queue_info[queue].hw_queue_refcount = 0;
 	mvm->queue_info[queue].tid_bitmap = 0;
 	mvm->hw_queue_to_mac80211[queue] = 0;
 
@@ -722,7 +718,7 @@ int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
 	cmd.tx_fifo = iwl_mvm_ac_to_tx_fifo[mvm->queue_info[queue].mac80211_ac];
 	cmd.tid = mvm->queue_info[queue].txq_tid;
 	mq = mvm->hw_queue_to_mac80211[queue];
-	shared_queue = (mvm->queue_info[queue].hw_queue_refcount > 1);
+	shared_queue = hweight16(mvm->queue_info[queue].tid_bitmap) > 1;
 	spin_unlock_bh(&mvm->queue_info_lock);
 
 	IWL_DEBUG_TX_QUEUES(mvm, "Redirecting TXQ #%d to FIFO #%d\n",
@@ -793,7 +789,7 @@ static int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 sta_id,
 
 	/* Start by looking for a free queue */
 	for (i = minq; i <= maxq; i++)
-		if (mvm->queue_info[i].hw_queue_refcount == 0 &&
+		if (mvm->queue_info[i].tid_bitmap == 0 &&
 		    mvm->queue_info[i].status == IWL_MVM_QUEUE_FREE)
 			return i;
 
@@ -877,7 +873,7 @@ static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
 	}
 
 	/* Update mappings and refcounts */
-	if (mvm->queue_info[queue].hw_queue_refcount > 0)
+	if (mvm->queue_info[queue].tid_bitmap)
 		enable_queue = false;
 
 	if (mac80211_queue != IEEE80211_INVAL_HW_QUEUE) {
@@ -888,7 +884,6 @@ static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
 		mvm->hw_queue_to_mac80211[queue] |= BIT(mac80211_queue);
 	}
 
-	mvm->queue_info[queue].hw_queue_refcount++;
 	mvm->queue_info[queue].tid_bitmap |= BIT(tid);
 	mvm->queue_info[queue].ra_sta_id = sta_id;
 
@@ -903,8 +898,8 @@ static bool iwl_mvm_update_txq_mapping(struct iwl_mvm *mvm, int queue,
 	}
 
 	IWL_DEBUG_TX_QUEUES(mvm,
-			    "Enabling TXQ #%d refcount=%d (mac80211 map:0x%x)\n",
-			    queue, mvm->queue_info[queue].hw_queue_refcount,
+			    "Enabling TXQ #%d tids=0x%x (mac80211 map:0x%x)\n",
+			    queue, mvm->queue_info[queue].tid_bitmap,
 			    mvm->hw_queue_to_mac80211[queue]);
 
 	spin_unlock_bh(&mvm->queue_info_lock);
@@ -1325,7 +1320,6 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 
 		mvmsta->tid_data[tid].txq_id = IWL_MVM_INVALID_QUEUE;
 		mvm->hw_queue_to_mac80211[queue] &= ~BIT(mac_queue);
-		mvm->queue_info[queue].hw_queue_refcount--;
 		mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
 		mvmsta->tid_data[tid].is_tid_active = false;
 
@@ -1349,7 +1343,7 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	}
 
 	/* If the queue is marked as shared - "unshare" it */
-	if (mvm->queue_info[queue].hw_queue_refcount == 1 &&
+	if (hweight16(mvm->queue_info[queue].tid_bitmap) == 1 &&
 	    mvm->queue_info[queue].status == IWL_MVM_QUEUE_SHARED) {
 		mvm->queue_info[queue].status = IWL_MVM_QUEUE_RECONFIGURING;
 		IWL_DEBUG_TX_QUEUES(mvm, "Marking Q:%d for reconfig\n",
@@ -1367,9 +1361,12 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 		return;
 
 	spin_lock_bh(&mvm->queue_info_lock);
-	for (i = 0; i < IWL_MAX_HW_QUEUES; i++)
-		if (mvm->queue_info[i].hw_queue_refcount > 0)
+	/* skip the CMD queue */
+	BUILD_BUG_ON(IWL_MVM_DQA_CMD_QUEUE != 0);
+	for (i = 1; i < IWL_MAX_HW_QUEUES; i++) {
+		if (mvm->queue_info[i].tid_bitmap)
 			timeout_queues_map |= BIT(i);
+	}
 	spin_unlock_bh(&mvm->queue_info_lock);
 
 	rcu_read_lock();
@@ -1592,7 +1589,7 @@ static int iwl_mvm_reserve_sta_stream(struct iwl_mvm *mvm,
 
 	/* Make sure we have free resources for this STA */
 	if (vif_type == NL80211_IFTYPE_STATION && !sta->tdls &&
-	    !mvm->queue_info[IWL_MVM_DQA_BSS_CLIENT_QUEUE].hw_queue_refcount &&
+	    !mvm->queue_info[IWL_MVM_DQA_BSS_CLIENT_QUEUE].tid_bitmap &&
 	    (mvm->queue_info[IWL_MVM_DQA_BSS_CLIENT_QUEUE].status ==
 	     IWL_MVM_QUEUE_FREE))
 		queue = IWL_MVM_DQA_BSS_CLIENT_QUEUE;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index dec097b72300..818e1180bbdd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -619,7 +619,7 @@ int iwl_mvm_reconfig_scd(struct iwl_mvm *mvm, int queue, int fifo, int sta_id,
 		return -EINVAL;
 
 	spin_lock_bh(&mvm->queue_info_lock);
-	if (WARN(mvm->queue_info[queue].hw_queue_refcount == 0,
+	if (WARN(mvm->queue_info[queue].tid_bitmap == 0,
 		 "Trying to reconfig unallocated queue %d\n", queue)) {
 		spin_unlock_bh(&mvm->queue_info_lock);
 		return -ENXIO;
-- 
2.19.0

