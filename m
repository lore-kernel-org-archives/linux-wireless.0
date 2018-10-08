Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8A3C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B9682087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B9682087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbeJHP2p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:45 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56414 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbeJHP2p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:45 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9Qjg-0003w6-JF; Mon, 08 Oct 2018 11:17:53 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:30 +0300
Message-Id: <20181008081735.3401-14-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/18] iwlwifi: mvm: reconfigure queues during inactivity check
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We currently reconfigure the queues after the inactivity check,
but only in one of the two callers. This might leave queues in
a state where the TID owner is wrong, if called when reserving
a queue for a new station.

Clean this up and do the reconfiguration inside the inactivity
check function. This requires changing the locking, but one of
the two places already holds the mvm mutex and the other easily
can.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index a36a631cdfa6..8a0cf736122a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1383,6 +1383,8 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 	unsigned long now = jiffies;
 	int i;
 
+	lockdep_assert_held(&mvm->mutex);
+
 	if (iwl_mvm_has_new_tx_api(mvm))
 		return;
 
@@ -1461,6 +1463,10 @@ static void iwl_mvm_inactivity_check(struct iwl_mvm *mvm)
 
 	rcu_read_unlock();
 	spin_unlock_bh(&mvm->queue_info_lock);
+
+	/* Reconfigure queues requiring reconfiguation */
+	for (i = 0; i < ARRAY_SIZE(mvm->queue_info); i++)
+		iwl_mvm_reconfigure_queue(mvm, i);
 }
 
 static inline u8 iwl_mvm_tid_to_ac_queue(int tid)
@@ -1533,19 +1539,9 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 	unsigned long deferred_tid_traffic;
 	int sta_id, tid;
 
-	/* Check inactivity of queues */
-	iwl_mvm_inactivity_check(mvm);
-
 	mutex_lock(&mvm->mutex);
 
-	/* No queue reconfiguration in TVQM mode */
-	if (!iwl_mvm_has_new_tx_api(mvm)) {
-		int queue;
-
-		/* Reconfigure queues requiring reconfiguation */
-		for (queue = 0; queue < ARRAY_SIZE(mvm->queue_info); queue++)
-			iwl_mvm_reconfigure_queue(mvm, queue);
-	}
+	iwl_mvm_inactivity_check(mvm);
 
 	/* Go over all stations with deferred traffic */
 	for_each_set_bit(sta_id, mvm->sta_deferred_frames,
-- 
2.19.0

