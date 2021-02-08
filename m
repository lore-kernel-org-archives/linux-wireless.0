Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8120FC433E6
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Feb 2021 12:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BD7964E7D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Feb 2021 12:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhBHMoH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Feb 2021 07:44:07 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:44382 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232495AbhBHMls (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Feb 2021 07:41:48 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l95qK-0047MN-Hf; Mon, 08 Feb 2021 14:40:40 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon,  8 Feb 2021 14:40:29 +0200
Message-Id: <iwlwifi.20210208143712.90b5bf785362.I904f269858b3123b7d6532f049c7f92b63fb8807@changeid>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208124034.1933780-1-luca@coelho.fi>
References: <20210208124034.1933780-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/12] iwlwifi: mvm: enhance a print in CSA flows
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Add the count and the mode to the modify CSA flow.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ec43601d410a..fdf7df6e336b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4671,7 +4671,8 @@ static void iwl_mvm_channel_switch_rx_beacon(struct ieee80211_hw *hw,
 	if (mvmvif->csa_failed)
 		goto out_unlock;
 
-	IWL_DEBUG_MAC80211(mvm, "Modify CSA on mac %d\n", mvmvif->id);
+	IWL_DEBUG_MAC80211(mvm, "Modify CSA on mac %d count = %d mode = %d\n",
+			   mvmvif->id, chsw->count, chsw->block_tx);
 	WARN_ON(iwl_mvm_send_cmd_pdu(mvm,
 				     WIDE_ID(MAC_CONF_GROUP,
 					     CHANNEL_SWITCH_TIME_EVENT_CMD),
-- 
2.30.0

