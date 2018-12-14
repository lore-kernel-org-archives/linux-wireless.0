Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8571AC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E003D208C1
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbeLNU3z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:29:55 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41946 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730713AbeLNU3y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:29:54 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5o-0002RG-R0; Fri, 14 Dec 2018 22:29:53 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:30 +0200
Message-Id: <20181214202945.32375-4-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/18] iwlwifi: mvm: remove pointless NULL assignment
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Assigning mvmsta to be NULL when we are about to exit the
function is pointless. Remove it. Move the variable declaration
to the scope it is used.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 7a9ec6810395..2738cd307765 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1472,7 +1472,6 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		iwl_mvm_get_agg_status(mvm, tx_resp);
 	u32 status = le16_to_cpu(agg_status->status);
 	u16 ssn = iwl_mvm_get_scd_ssn(mvm, tx_resp);
-	struct iwl_mvm_sta *mvmsta;
 	struct sk_buff_head skbs;
 	u8 skb_freed = 0;
 	u8 lq_color;
@@ -1620,7 +1619,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		goto out;
 
 	if (!IS_ERR(sta)) {
-		mvmsta = iwl_mvm_sta_from_mac80211(sta);
+		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
 		iwl_mvm_tx_airtime(mvm, mvmsta,
 				   le16_to_cpu(tx_resp->wireless_media_time));
@@ -1683,10 +1682,7 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			mvmsta->next_status_eosp = false;
 			ieee80211_sta_eosp(sta);
 		}
-	} else {
-		mvmsta = NULL;
 	}
-
 out:
 	rcu_read_unlock();
 }
-- 
2.19.2

