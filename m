Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02839C77B73
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Apr 2023 12:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjDPMsL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Apr 2023 08:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjDPMsK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2023 08:48:10 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D988B30ED
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2023 05:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681649289; x=1713185289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CQC52OM/e18+hTX7adsfQYfb2ZIBhQx5WfJ62JFKtlM=;
  b=MI+cBgeOdeB49dlqH+pGdyK+uA7GnjX9vGlIrtp2A/HoMboCS7OHlSXi
   e1372R6OOM3zKqyfBU9IVIygnRkunfreR55em6L2+p9RydECRNAUO+K2j
   Wya0ja8IPawsokG3R/o/+nrLlbBem04rHgzL0JlQT93xwTuQIR/zDiUBt
   8pCQ4gFUdQ2dCH6OYIsZPrW8YL1gopKJ2DsAeMR8wKId9c4t3r5T+9r+X
   RHhTgdmUzvKMsOCRaaen9EojvtN0jpzQmxm1CCFWXs9USR6xRCOB+2S/j
   oq7jxWsfJiMoxdEJ/y5rKo1uvs2nmRYWSXPaKaoU5o4GCYVbcDgI6Op0m
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="333520563"
X-IronPort-AV: E=Sophos;i="5.99,202,1677571200"; 
   d="scan'208";a="333520563"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2023 05:48:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="640670434"
X-IronPort-AV: E=Sophos;i="5.99,202,1677571200"; 
   d="scan'208";a="640670434"
Received: from lavnon-mobl.ger.corp.intel.com (HELO ggreenma-mobl2.lan) ([10.214.215.99])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2023 05:48:08 -0700
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 08/15] wifi: iwlwifi: mvm: use correct sta mask to remove queue
Date:   Sun, 16 Apr 2023 15:47:32 +0300
Message-Id: <20230416154301.01cdd2153418.I176d54f2d869f51b3707d056adb96455cf885f93@changeid>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230416124739.1260800-1-gregory.greenman@intel.com>
References: <20230416124739.1260800-1-gregory.greenman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When we remove a queue we need to use the currently active
firmware stations in the mask, not the deflink one. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
index c5d25772159b..819e05a6f651 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
@@ -299,7 +299,7 @@ int iwl_mvm_mld_add_aux_sta(struct iwl_mvm *mvm, u32 lmac_id)
 				       IWL_MAX_TID_COUNT, NULL);
 }
 
-static int iwl_mvm_mld_disable_txq(struct iwl_mvm *mvm, int sta_id,
+static int iwl_mvm_mld_disable_txq(struct iwl_mvm *mvm, u32 sta_mask,
 				   u16 *queueptr, u8 tid)
 {
 	int queue = *queueptr;
@@ -314,7 +314,7 @@ static int iwl_mvm_mld_disable_txq(struct iwl_mvm *mvm, int sta_id,
 		struct iwl_scd_queue_cfg_cmd remove_cmd = {
 			.operation = cpu_to_le32(IWL_SCD_QUEUE_REMOVE),
 			.u.remove.tid = cpu_to_le32(tid),
-			.u.remove.sta_mask = cpu_to_le32(BIT(sta_id)),
+			.u.remove.sta_mask = cpu_to_le32(sta_mask),
 		};
 
 		ret = iwl_mvm_send_cmd_pdu(mvm, cmd_id, 0,
@@ -344,7 +344,7 @@ static int iwl_mvm_mld_rm_int_sta(struct iwl_mvm *mvm,
 	if (flush)
 		iwl_mvm_flush_sta(mvm, int_sta, true);
 
-	iwl_mvm_mld_disable_txq(mvm, int_sta->sta_id, queuptr, tid);
+	iwl_mvm_mld_disable_txq(mvm, BIT(int_sta->sta_id), queuptr, tid);
 
 	ret = iwl_mvm_mld_rm_sta_from_fw(mvm, int_sta->sta_id);
 	if (ret)
@@ -760,6 +760,7 @@ static void iwl_mvm_mld_disable_sta_queues(struct iwl_mvm *mvm,
 					   struct ieee80211_sta *sta)
 {
 	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+	u32 sta_mask = iwl_mvm_sta_fw_id_mask(mvm, sta, -1);
 	int i;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -768,7 +769,7 @@ static void iwl_mvm_mld_disable_sta_queues(struct iwl_mvm *mvm,
 		if (mvm_sta->tid_data[i].txq_id == IWL_MVM_INVALID_QUEUE)
 			continue;
 
-		iwl_mvm_mld_disable_txq(mvm, mvm_sta->deflink.sta_id,
+		iwl_mvm_mld_disable_txq(mvm, sta_mask,
 					&mvm_sta->tid_data[i].txq_id, i);
 		mvm_sta->tid_data[i].txq_id = IWL_MVM_INVALID_QUEUE;
 	}
-- 
2.38.1

