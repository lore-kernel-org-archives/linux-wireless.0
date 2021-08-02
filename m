Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B34C4338F
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 14:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF73F60F41
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Aug 2021 14:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbhHBO25 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Aug 2021 10:28:57 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:50972 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234313AbhHBO25 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Aug 2021 10:28:57 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1mAYvo-001xts-Ka; Mon, 02 Aug 2021 17:28:42 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Mon,  2 Aug 2021 17:28:29 +0300
Message-Id: <iwlwifi.20210802172232.3939f7c5c43a.I1d5cb5262e31a000023d79acbb897b8db50adf0d@changeid>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802142829.109448-1-luca@coelho.fi>
References: <20210802142829.109448-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/12] iwlwifi: mvm: treat MMPDUs in iwl_mvm_mac_tx() as bcast
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There's no need for all the complicated conditions here, any
bufferable MMPDUs or MMPDUs for client interfaces are already
coming through the TXQ interface, not iwl_mvm_mac_tx().

Simplify the logic.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index f38d2476d5a3..c60c0b49d7f7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -762,11 +762,11 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 	    !test_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status))
 		goto drop;
 
-	/* treat non-bufferable MMPDUs on AP interfaces as broadcast */
-	if ((info->control.vif->type == NL80211_IFTYPE_AP ||
-	     info->control.vif->type == NL80211_IFTYPE_ADHOC) &&
-	    ieee80211_is_mgmt(hdr->frame_control) &&
-	    !ieee80211_is_bufferable_mmpdu(hdr->frame_control))
+	/*
+	 * bufferable MMPDUs or MMPDUs on STA interfaces come via TXQs
+	 * so we treat the others as broadcast
+	 */
+	if (ieee80211_is_mgmt(hdr->frame_control))
 		sta = NULL;
 
 	/* If there is no sta, and it's not offchannel - send through AP */
-- 
2.32.0

