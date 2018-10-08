Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7E0C65BD1
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DEB32087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DEB32087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbeJHP2t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:49 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56422 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbeJHP2t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:49 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9Qjf-0003w6-KF; Mon, 08 Oct 2018 11:17:52 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:29 +0300
Message-Id: <20181008081735.3401-13-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/18] iwlwifi: mvm: move queue reconfiguration into new function
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If TVQM is used we skip over this, move the code into a new
function to get rid of the label.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 64 ++++++++++----------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 5b6ec7de8043..a36a631cdfa6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1351,6 +1351,33 @@ static void iwl_mvm_remove_inactive_tids(struct iwl_mvm *mvm,
 	}
 }
 
+static void iwl_mvm_reconfigure_queue(struct iwl_mvm *mvm, int queue)
+{
+	bool reconfig;
+	bool change_owner;
+
+	spin_lock_bh(&mvm->queue_info_lock);
+	reconfig = mvm->queue_info[queue].status == IWL_MVM_QUEUE_RECONFIGURING;
+
+	/*
+	 * We need to take into account a situation in which a TXQ was
+	 * allocated to TID x, and then turned shared by adding TIDs y
+	 * and z. If TID x becomes inactive and is removed from the TXQ,
+	 * ownership must be given to one of the remaining TIDs.
+	 * This is mainly because if TID x continues - a new queue can't
+	 * be allocated for it as long as it is an owner of another TXQ.
+	 */
+	change_owner = !(mvm->queue_info[queue].tid_bitmap &
+			 BIT(mvm->queue_info[queue].txq_tid)) &&
+		       (mvm->queue_info[queue].status == IWL_MVM_QUEUE_SHARED);
+	spin_unlock_bh(&mvm->queue_info_lock);
+
+	if (reconfig)
+		iwl_mvm_unshare_queue(mvm, queue);
+	else if (change_owner)
+		iwl_mvm_change_queue_owner(mvm, queue);
+}
+
 static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 {
 	unsigned long now = jiffies;
@@ -1504,7 +1531,7 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 	struct ieee80211_sta *sta;
 	struct iwl_mvm_sta *mvmsta;
 	unsigned long deferred_tid_traffic;
-	int queue, sta_id, tid;
+	int sta_id, tid;
 
 	/* Check inactivity of queues */
 	iwl_mvm_inactivity_check(mvm);
@@ -1512,39 +1539,14 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 	mutex_lock(&mvm->mutex);
 
 	/* No queue reconfiguration in TVQM mode */
-	if (iwl_mvm_has_new_tx_api(mvm))
-		goto alloc_queues;
-
-	/* Reconfigure queues requiring reconfiguation */
-	for (queue = 0; queue < ARRAY_SIZE(mvm->queue_info); queue++) {
-		bool reconfig;
-		bool change_owner;
-
-		spin_lock_bh(&mvm->queue_info_lock);
-		reconfig = (mvm->queue_info[queue].status ==
-			    IWL_MVM_QUEUE_RECONFIGURING);
-
-		/*
-		 * We need to take into account a situation in which a TXQ was
-		 * allocated to TID x, and then turned shared by adding TIDs y
-		 * and z. If TID x becomes inactive and is removed from the TXQ,
-		 * ownership must be given to one of the remaining TIDs.
-		 * This is mainly because if TID x continues - a new queue can't
-		 * be allocated for it as long as it is an owner of another TXQ.
-		 */
-		change_owner = !(mvm->queue_info[queue].tid_bitmap &
-				 BIT(mvm->queue_info[queue].txq_tid)) &&
-			       (mvm->queue_info[queue].status ==
-				IWL_MVM_QUEUE_SHARED);
-		spin_unlock_bh(&mvm->queue_info_lock);
+	if (!iwl_mvm_has_new_tx_api(mvm)) {
+		int queue;
 
-		if (reconfig)
-			iwl_mvm_unshare_queue(mvm, queue);
-		else if (change_owner)
-			iwl_mvm_change_queue_owner(mvm, queue);
+		/* Reconfigure queues requiring reconfiguation */
+		for (queue = 0; queue < ARRAY_SIZE(mvm->queue_info); queue++)
+			iwl_mvm_reconfigure_queue(mvm, queue);
 	}
 
-alloc_queues:
 	/* Go over all stations with deferred traffic */
 	for_each_set_bit(sta_id, mvm->sta_deferred_frames,
 			 IWL_MVM_STATION_COUNT) {
-- 
2.19.0

