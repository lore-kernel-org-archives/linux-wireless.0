Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB673C64EB8
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB54A2087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB54A2087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbeJHP2f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:35 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56398 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbeJHP2f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:35 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9Qji-0003w6-3d; Mon, 08 Oct 2018 11:17:54 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:32 +0300
Message-Id: <20181008081735.3401-16-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/18] iwlwifi: mvm: make queue TID change more explicit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Instead of iterating all the queues after having potentially
changed some queue configurations, rechecking if that was done,
mark the ones that do need a TID change explicitly in a bitmap
and use that to send the change to the firmware.

While at it, also rename iwl_mvm_change_queue_owner() to
iwl_mvm_change_queue_tid() since that's more obvious - the
"kind" of owner isn't immediately clear right now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 53 +++++++++-----------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index b30980c34fd0..ec4925c89295 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1141,7 +1141,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	return ret;
 }
 
-static void iwl_mvm_change_queue_owner(struct iwl_mvm *mvm, int queue)
+static void iwl_mvm_change_queue_tid(struct iwl_mvm *mvm, int queue)
 {
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
@@ -1272,7 +1272,8 @@ static void iwl_mvm_unshare_queue(struct iwl_mvm *mvm, int queue)
 static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 					 struct iwl_mvm_sta *mvmsta, int queue,
 					 unsigned long tid_bitmap,
-					 unsigned long *unshare_queues)
+					 unsigned long *unshare_queues,
+					 unsigned long *changetid_queues)
 {
 	int tid;
 
@@ -1311,12 +1312,29 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	 */
 	for_each_set_bit(tid, &tid_bitmap, IWL_MAX_TID_COUNT + 1) {
 		int mac_queue = mvmsta->vif->hw_queue[tid_to_mac80211_ac[tid]];
+		u16 tid_bitmap;
 
 		mvmsta->tid_data[tid].txq_id = IWL_MVM_INVALID_QUEUE;
 		mvm->hw_queue_to_mac80211[queue] &= ~BIT(mac_queue);
 		mvm->queue_info[queue].tid_bitmap &= ~BIT(tid);
 		mvmsta->tid_data[tid].is_tid_active = false;
 
+		tid_bitmap = mvm->queue_info[queue].tid_bitmap;
+
+		/*
+		 * We need to take into account a situation in which a TXQ was
+		 * allocated to TID x, and then turned shared by adding TIDs y
+		 * and z. If TID x becomes inactive and is removed from the TXQ,
+		 * ownership must be given to one of the remaining TIDs.
+		 * This is mainly because if TID x continues - a new queue can't
+		 * be allocated for it as long as it is an owner of another TXQ.
+		 *
+		 * Mark this queue in the right bitmap, we'll send the command
+		 * to the firmware later.
+		 */
+		if (!(tid_bitmap & BIT(mvm->queue_info[queue].txq_tid)))
+			set_bit(queue, changetid_queues);
+
 		IWL_DEBUG_TX_QUEUES(mvm,
 				    "Removing inactive TID %d from shared Q:%d\n",
 				    tid, queue);
@@ -1345,33 +1363,11 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	}
 }
 
-static void iwl_mvm_reconfigure_queue(struct iwl_mvm *mvm, int queue)
-{
-	bool change_owner;
-
-	spin_lock_bh(&mvm->queue_info_lock);
-
-	/*
-	 * We need to take into account a situation in which a TXQ was
-	 * allocated to TID x, and then turned shared by adding TIDs y
-	 * and z. If TID x becomes inactive and is removed from the TXQ,
-	 * ownership must be given to one of the remaining TIDs.
-	 * This is mainly because if TID x continues - a new queue can't
-	 * be allocated for it as long as it is an owner of another TXQ.
-	 */
-	change_owner = !(mvm->queue_info[queue].tid_bitmap &
-			 BIT(mvm->queue_info[queue].txq_tid)) &&
-		       (mvm->queue_info[queue].status == IWL_MVM_QUEUE_SHARED);
-	spin_unlock_bh(&mvm->queue_info_lock);
-
-	if (change_owner)
-		iwl_mvm_change_queue_owner(mvm, queue);
-}
-
 static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 {
 	unsigned long now = jiffies;
 	unsigned long unshare_queues = 0;
+	unsigned long changetid_queues = 0;
 	int i;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1448,7 +1444,8 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 		spin_lock(&mvm->queue_info_lock);
 		iwl_mvm_remove_inactive_tids(mvm, mvmsta, i,
 					     inactive_tid_bitmap,
-					     &unshare_queues);
+					     &unshare_queues,
+					     &changetid_queues);
 		/* only unlock sta lock - we still need the queue info lock */
 		spin_unlock(&mvmsta->lock);
 	}
@@ -1459,8 +1456,8 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 	/* Reconfigure queues requiring reconfiguation */
 	for_each_set_bit(i, &unshare_queues, IWL_MAX_HW_QUEUES)
 		iwl_mvm_unshare_queue(mvm, i);
-	for (i = 0; i < ARRAY_SIZE(mvm->queue_info); i++)
-		iwl_mvm_reconfigure_queue(mvm, i);
+	for_each_set_bit(i, &changetid_queues, IWL_MAX_HW_QUEUES)
+		iwl_mvm_change_queue_tid(mvm, i);
 }
 
 static inline u8 iwl_mvm_tid_to_ac_queue(int tid)
-- 
2.19.0

