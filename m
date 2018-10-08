Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F72BC64EB8
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE5312087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE5312087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbeJHP2j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:39 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56406 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbeJHP2j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:39 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9Qjh-0003w6-Av; Mon, 08 Oct 2018 11:17:53 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:31 +0300
Message-Id: <20181008081735.3401-15-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/18] iwlwifi: mvm: remove RECONFIGURING queue state
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We set the queue to this state, only to pretty much immediately
move it out of it again. However, we can't even hit any of the
code that checks if the queue is reconfiguring, because all of
this happens under mvm->mutex and we hold the all the way from
marking the queue as RECONFIGURING to marking it as READY again.

Additionally, the queue that became RECONFIGURING would've been
in SHARED state before, and it can safely stay in that state. In
case of errors, it previously would have stayed in RECONFIGURING
which it could never have left again.

Remove the state entirely and just track the queues that need to
be reconfigured in a separate, local, bitmap.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  5 ---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 36 ++++++++------------
 2 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 7074fd1f8ce7..8cbd9468aa8b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -760,10 +760,6 @@ iwl_mvm_baid_data_from_reorder_buf(struct iwl_mvm_reorder_buffer *buf)
  *	it. In this state, when a new queue is needed to be allocated but no
  *	such free queue exists, an inactive queue might be freed and given to
  *	the new RA/TID.
- * @IWL_MVM_QUEUE_RECONFIGURING: queue is being reconfigured
- *	This is the state of a queue that has had traffic pass through it, but
- *	needs to be reconfigured for some reason, e.g. the queue needs to
- *	become unshared and aggregations re-enabled on.
  */
 enum iwl_mvm_queue_status {
 	IWL_MVM_QUEUE_FREE,
@@ -771,7 +767,6 @@ enum iwl_mvm_queue_status {
 	IWL_MVM_QUEUE_READY,
 	IWL_MVM_QUEUE_SHARED,
 	IWL_MVM_QUEUE_INACTIVE,
-	IWL_MVM_QUEUE_RECONFIGURING,
 };
 
 #define IWL_MVM_DQA_QUEUE_TIMEOUT	(5 * HZ)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 8a0cf736122a..b30980c34fd0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -606,7 +606,13 @@ static int iwl_mvm_get_shared_queue(struct iwl_mvm *mvm,
 	u8 ac_to_queue[IEEE80211_NUM_ACS];
 	int i;
 
+	/*
+	 * This protects us against grabbing a queue that's being reconfigured
+	 * by the inactivity checker.
+	 */
+	lockdep_assert_held(&mvm->mutex);
 	lockdep_assert_held(&mvm->queue_info_lock);
+
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return -EINVAL;
 
@@ -619,11 +625,6 @@ static int iwl_mvm_get_shared_queue(struct iwl_mvm *mvm,
 		    i != IWL_MVM_DQA_BSS_CLIENT_QUEUE)
 			continue;
 
-		/* Don't try and take queues being reconfigured */
-		if (mvm->queue_info[queue].status ==
-		    IWL_MVM_QUEUE_RECONFIGURING)
-			continue;
-
 		ac_to_queue[mvm->queue_info[i].mac80211_ac] = i;
 	}
 
@@ -664,14 +665,6 @@ static int iwl_mvm_get_shared_queue(struct iwl_mvm *mvm,
 		return -ENOSPC;
 	}
 
-	/* Make sure the queue isn't in the middle of being reconfigured */
-	if (mvm->queue_info[queue].status == IWL_MVM_QUEUE_RECONFIGURING) {
-		IWL_ERR(mvm,
-			"TXQ %d is in the middle of re-config - try again\n",
-			queue);
-		return -EBUSY;
-	}
-
 	return queue;
 }
 
@@ -1278,7 +1271,8 @@ static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
  */
 static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 					 struct iwl_mvm_sta *mvmsta, int queue,
-					 unsigned long tid_bitmap)
+					 unsigned long tid_bitmap,
+					 unsigned long *unshare_queues)
 {
 	int tid;
 
@@ -1345,19 +1339,17 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	/* If the queue is marked as shared - "unshare" it */
 	if (hweight16(mvm->queue_info[queue].tid_bitmap) == 1 &&
 	    mvm->queue_info[queue].status == IWL_MVM_QUEUE_SHARED) {
-		mvm->queue_info[queue].status = IWL_MVM_QUEUE_RECONFIGURING;
 		IWL_DEBUG_TX_QUEUES(mvm, "Marking Q:%d for reconfig\n",
 				    queue);
+		set_bit(queue, unshare_queues);
 	}
 }
 
 static void iwl_mvm_reconfigure_queue(struct iwl_mvm *mvm, int queue)
 {
-	bool reconfig;
 	bool change_owner;
 
 	spin_lock_bh(&mvm->queue_info_lock);
-	reconfig = mvm->queue_info[queue].status == IWL_MVM_QUEUE_RECONFIGURING;
 
 	/*
 	 * We need to take into account a situation in which a TXQ was
@@ -1372,15 +1364,14 @@ static void iwl_mvm_reconfigure_queue(struct iwl_mvm *mvm, int queue)
 		       (mvm->queue_info[queue].status == IWL_MVM_QUEUE_SHARED);
 	spin_unlock_bh(&mvm->queue_info_lock);
 
-	if (reconfig)
-		iwl_mvm_unshare_queue(mvm, queue);
-	else if (change_owner)
+	if (change_owner)
 		iwl_mvm_change_queue_owner(mvm, queue);
 }
 
 static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 {
 	unsigned long now = jiffies;
+	unsigned long unshare_queues = 0;
 	int i;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1456,7 +1447,8 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 		spin_lock(&mvmsta->lock);
 		spin_lock(&mvm->queue_info_lock);
 		iwl_mvm_remove_inactive_tids(mvm, mvmsta, i,
-					     inactive_tid_bitmap);
+					     inactive_tid_bitmap,
+					     &unshare_queues);
 		/* only unlock sta lock - we still need the queue info lock */
 		spin_unlock(&mvmsta->lock);
 	}
@@ -1465,6 +1457,8 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 	spin_unlock_bh(&mvm->queue_info_lock);
 
 	/* Reconfigure queues requiring reconfiguation */
+	for_each_set_bit(i, &unshare_queues, IWL_MAX_HW_QUEUES)
+		iwl_mvm_unshare_queue(mvm, i);
 	for (i = 0; i < ARRAY_SIZE(mvm->queue_info); i++)
 		iwl_mvm_reconfigure_queue(mvm, i);
 }
-- 
2.19.0

