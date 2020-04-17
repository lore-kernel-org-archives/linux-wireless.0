Return-Path: <SRS0=s1dN=6B=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8948DC2BB55
	for <linux-wireless@archiver.kernel.org>; Fri, 17 Apr 2020 07:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72FF1206A2
	for <linux-wireless@archiver.kernel.org>; Fri, 17 Apr 2020 07:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgDQHIa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 Apr 2020 03:08:30 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56402 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728470AbgDQHI3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Apr 2020 03:08:29 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jPL6x-000KNJ-9r; Fri, 17 Apr 2020 10:08:27 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 17 Apr 2020 10:08:14 +0300
Message-Id: <iwlwifi.20200417100405.9d862ed72535.I9e27ccc3ee3c8855fc13682592b571581925dfbd@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200417070814.2044774-1-luca@coelho.fi>
References: <20200417070814.2044774-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 v5.7 6/6] iwlwifi: mvm: fix inactive TID removal return value usage
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The function iwl_mvm_remove_inactive_tids() returns bool, so we
should just check "if (ret)", not "if (ret >= 0)" (which would
do nothing useful here). We obviously therefore cannot use the
return value of the function for the free_queue, we need to use
the queue (i) we're currently dealing with instead.

Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 251d6fbb1da5..56ae72debb96 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1169,9 +1169,9 @@ static int iwl_mvm_inactivity_check(struct iwl_mvm *mvm, u8 alloc_for_sta)
 						   inactive_tid_bitmap,
 						   &unshare_queues,
 						   &changetid_queues);
-		if (ret >= 0 && free_queue < 0) {
+		if (ret && free_queue < 0) {
 			queue_owner = sta;
-			free_queue = ret;
+			free_queue = i;
 		}
 		/* only unlock sta lock - we still need the queue info lock */
 		spin_unlock_bh(&mvmsta->lock);
-- 
2.25.1

