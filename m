Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390A4C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 121BF218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfCVOAM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:00:12 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46242 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727725AbfCVOAM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:00:12 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khi-0000bK-9t; Fri, 22 Mar 2019 15:59:26 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Colin Ian King <colin.king@canonical.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:56 +0200
Message-Id: <20190322135903.10631-18-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 17/24] iwlwifi: mvm: remove buggy and unnecessary hw_queue initialization
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

After converting the driver to TXQs, it no longer has any reason
to initialize vif->hw_queue/vif->cab_queue since it no longer sets
the HW_QUEUE_CONTROL flag. Remove the code that initialized those,
it was broken due to relying on an uninitialized stack value in
used_hw_queues, as Colin reported.

Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 36 ++-----------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index f24d73700ad6..76bf7fbc0446 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -262,9 +262,7 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		.preferred_tsf = NUM_TSF_IDS,
 		.found_vif = false,
 	};
-	u32 ac;
-	int ret, i, queue_limit;
-	unsigned long used_hw_queues;
+	int ret, i;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -341,37 +339,9 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	INIT_LIST_HEAD(&mvmvif->time_event_data.list);
 	mvmvif->time_event_data.id = TE_MAX;
 
-	/* No need to allocate data queues to P2P Device MAC.*/
-	if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
-		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-			vif->hw_queue[ac] = IEEE80211_INVAL_HW_QUEUE;
-
+	/* No need to allocate data queues to P2P Device MAC and NAN.*/
+	if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
 		return 0;
-	}
-
-	/*
-	 * queues in mac80211 almost entirely independent of
-	 * the ones here - no real limit
-	 */
-	queue_limit = IEEE80211_MAX_QUEUES;
-
-	/*
-	 * Find available queues, and allocate them to the ACs. When in
-	 * DQA-mode they aren't really used, and this is done only so the
-	 * mac80211 ieee80211_check_queues() function won't fail
-	 */
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		u8 queue = find_first_zero_bit(&used_hw_queues, queue_limit);
-
-		if (queue >= queue_limit) {
-			IWL_ERR(mvm, "Failed to allocate queue\n");
-			ret = -EIO;
-			goto exit_fail;
-		}
-
-		__set_bit(queue, &used_hw_queues);
-		vif->hw_queue[ac] = queue;
-	}
 
 	/* Allocate the CAB queue for softAP and GO interfaces */
 	if (vif->type == NL80211_IFTYPE_AP ||
-- 
2.20.1

