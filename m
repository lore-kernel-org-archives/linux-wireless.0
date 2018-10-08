Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5DBC64EB8
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F35F52087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F35F52087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbeJHP2x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:53 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56430 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbeJHP2x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:53 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9Qje-0003w6-RD; Mon, 08 Oct 2018 11:17:51 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:28 +0300
Message-Id: <20181008081735.3401-12-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/18] iwlwifi: mvm: clean up iteration in iwl_mvm_inactivity_check()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There's no need to build a bitmap first and then iterate,
just do the iteration with the right locking directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 32 +++++++++-----------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index ce03f9750c3a..5b6ec7de8043 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1353,7 +1353,6 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 
 static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 {
-	unsigned long timeout_queues_map = 0;
 	unsigned long now = jiffies;
 	int i;
 
@@ -1361,22 +1360,18 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 		return;
 
 	spin_lock_bh(&mvm->queue_info_lock);
-	/* skip the CMD queue */
-	BUILD_BUG_ON(IWL_MVM_DQA_CMD_QUEUE != 0);
-	for (i = 1; i < IWL_MAX_HW_QUEUES; i++) {
-		if (mvm->queue_info[i].tid_bitmap)
-			timeout_queues_map |= BIT(i);
-	}
-	spin_unlock_bh(&mvm->queue_info_lock);
 
 	rcu_read_lock();
 
+	/* we skip the CMD queue below by starting at 1 */
+	BUILD_BUG_ON(IWL_MVM_DQA_CMD_QUEUE != 0);
+
 	/*
 	 * If a queue times out - mark it as INACTIVE (don't remove right away
 	 * if we don't have to.) This is an optimization in case traffic comes
 	 * later, and we don't HAVE to use a currently-inactive queue
 	 */
-	for_each_set_bit(i, &timeout_queues_map, IWL_MAX_HW_QUEUES) {
+	for (i = 1; i < IWL_MAX_HW_QUEUES; i++) {
 		struct ieee80211_sta *sta;
 		struct iwl_mvm_sta *mvmsta;
 		u8 sta_id;
@@ -1384,15 +1379,14 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 		unsigned long inactive_tid_bitmap = 0;
 		unsigned long queue_tid_bitmap;
 
-		spin_lock_bh(&mvm->queue_info_lock);
 		queue_tid_bitmap = mvm->queue_info[i].tid_bitmap;
+		if (!queue_tid_bitmap)
+			continue;
 
 		/* If TXQ isn't in active use anyway - nothing to do here... */
 		if (mvm->queue_info[i].status != IWL_MVM_QUEUE_READY &&
-		    mvm->queue_info[i].status != IWL_MVM_QUEUE_SHARED) {
-			spin_unlock_bh(&mvm->queue_info_lock);
+		    mvm->queue_info[i].status != IWL_MVM_QUEUE_SHARED)
 			continue;
-		}
 
 		/* Check to see if there are inactive TIDs on this queue */
 		for_each_set_bit(tid, &queue_tid_bitmap,
@@ -1403,7 +1397,6 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 
 			inactive_tid_bitmap |= BIT(tid);
 		}
-		spin_unlock_bh(&mvm->queue_info_lock);
 
 		/* If all TIDs are active - finish check on this queue */
 		if (!inactive_tid_bitmap)
@@ -1427,15 +1420,20 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 
 		mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
-		spin_lock_bh(&mvmsta->lock);
+		/* this isn't so nice, but works OK due to the way we loop */
+		spin_unlock(&mvm->queue_info_lock);
+
+		/* and we need this locking order */
+		spin_lock(&mvmsta->lock);
 		spin_lock(&mvm->queue_info_lock);
 		iwl_mvm_remove_inactive_tids(mvm, mvmsta, i,
 					     inactive_tid_bitmap);
-		spin_unlock(&mvm->queue_info_lock);
-		spin_unlock_bh(&mvmsta->lock);
+		/* only unlock sta lock - we still need the queue info lock */
+		spin_unlock(&mvmsta->lock);
 	}
 
 	rcu_read_unlock();
+	spin_unlock_bh(&mvm->queue_info_lock);
 }
 
 static inline u8 iwl_mvm_tid_to_ac_queue(int tid)
-- 
2.19.0

