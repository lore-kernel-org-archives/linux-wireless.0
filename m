Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DAA7C433C1
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Mar 2021 09:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32E10619BB
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Mar 2021 09:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhCaJPE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Mar 2021 05:15:04 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:43730 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234675AbhCaJO4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Mar 2021 05:14:56 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1lRWw9-00087q-AM; Wed, 31 Mar 2021 12:14:54 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 31 Mar 2021 12:14:41 +0300
Message-Id: <iwlwifi.20210331121101.d11c9bcdb4aa.I0772171dbaec87433a11513e9586d98b5d920b5f@changeid>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210331091452.543321-1-luca@coelho.fi>
References: <20210331091452.543321-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/12] iwlwifi: mvm: write queue_sync_state only for sync
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We use mvm->queue_sync_state to wait for synchronous queue sync
messages, but if an async one happens inbetween we shouldn't
clear mvm->queue_sync_state after sending the async one, that
can run concurrently (at least from the CPU POV) with another
synchronous queue sync.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 9ed6e2783cc4..fbd37a19b6e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -5177,9 +5177,10 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 	}
 
 out:
-	mvm->queue_sync_state = 0;
-	if (notif->sync)
+	if (notif->sync) {
+		mvm->queue_sync_state = 0;
 		mvm->queue_sync_cookie++;
+	}
 }
 
 static void iwl_mvm_sync_rx_queues(struct ieee80211_hw *hw)
-- 
2.31.0

