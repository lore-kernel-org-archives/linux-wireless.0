Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86D3C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5CF620830
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfDCJXP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 05:23:15 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49800 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725935AbfDCJXO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 05:23:14 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hBc6T-0007aR-4A; Wed, 03 Apr 2019 12:22:41 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  3 Apr 2019 12:22:23 +0300
Message-Id: <20190403092224.815-13-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190403092224.815-1-luca@coelho.fi>
References: <20190403092224.815-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/13] iwlwifi: mvm: Change an 'else if' into an 'else' in iwl_mvm_send_add_bcast_sta
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

When building with -Wsometimes-uninitialized, Clang warns:

drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2114:12: warning: variable
'queue' is used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]

Clang can't evaluate at this point that WARN(1, ...) always returns true
because __ret_warn_on is defined as !!(condition), which isn't
immediately evaluated as 1. Change this branch to else so that it's
clear to Clang that we intend to bail out here.

Link: https://github.com/ClangBuiltLinux/linux/issues/399
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
[added a few more braces]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 3673959df5c1..90ba34bb6bc2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2108,12 +2108,14 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	if (!iwl_mvm_has_new_tx_api(mvm)) {
 		if (vif->type == NL80211_IFTYPE_AP ||
-		    vif->type == NL80211_IFTYPE_ADHOC)
+		    vif->type == NL80211_IFTYPE_ADHOC) {
 			queue = mvm->probe_queue;
-		else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
+		} else if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 			queue = mvm->p2p_dev_queue;
-		else if (WARN(1, "Missing required TXQ for adding bcast STA\n"))
+		} else {
+			WARN(1, "Missing required TXQ for adding bcast STA\n");
 			return -EINVAL;
+		}
 
 		bsta->tfd_queue_msk |= BIT(queue);
 
-- 
2.20.1

