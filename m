Return-Path: <SRS0=IBNP=X5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A77C4360C
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 13:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F0B215EA
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 13:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388321AbfJDNOZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:14:25 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46572 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388297AbfJDNOY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Oct 2019 09:14:24 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iGNPa-0000l2-Dn; Fri, 04 Oct 2019 16:14:22 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri,  4 Oct 2019 16:14:10 +0300
Message-Id: <20191004131414.27372-5-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191004131414.27372-1-luca@coelho.fi>
References: <20191004131414.27372-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 4/8] iwlwifi: mvm: fix race in sync rx queue notification
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

Consider the following flow:
 1. Driver starts to sync the rx queues due to a delba.
    mvm->queue_sync_cookie=1.
    This rx-queues-sync is synchronous, so it doesn't increment the
    cookie until all rx queues handle the notification from FW.
 2. During this time, driver starts to sync rx queues due to nssn sync
    required.
    The cookie's value is still 1, but it doesn't matter since this
    rx-queue-sync is non-synchronous so in the notification handler the
    cookie is ignored.
    What _does_ matter is that this flow increments the cookie to 2
    immediately.
    Remember though that the FW won't start servicing this command until
    it's done with the previous one.
 3. FW is still handling the first command, so it sends a notification
    with internal_notif->sync=1, and internal_notif->cookie=0, which
    triggers a WARN_ONCE.

The solution for this race is to only use the mvm->queue_sync_cookie in
case of a synchronous sync-rx-queues. This way in step 2 the cookie's
value won't change so we avoid the WARN.

The commit in the "fixes" field is the first commit to introduce
non-synchronous sending of this command to FW.

Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index cd1b10042fbf..d31f96c3f925 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4881,11 +4881,11 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 	if (!iwl_mvm_has_new_rx_api(mvm))
 		return;
 
-	notif->cookie = mvm->queue_sync_cookie;
-
-	if (notif->sync)
+	if (notif->sync) {
+		notif->cookie = mvm->queue_sync_cookie;
 		atomic_set(&mvm->queue_sync_counter,
 			   mvm->trans->num_rx_queues);
+	}
 
 	ret = iwl_mvm_notify_rx_queue(mvm, qmask, (u8 *)notif,
 				      size, !notif->sync);
@@ -4905,7 +4905,8 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 
 out:
 	atomic_set(&mvm->queue_sync_counter, 0);
-	mvm->queue_sync_cookie++;
+	if (notif->sync)
+		mvm->queue_sync_cookie++;
 }
 
 static void iwl_mvm_sync_rx_queues(struct ieee80211_hw *hw)
-- 
2.23.0

