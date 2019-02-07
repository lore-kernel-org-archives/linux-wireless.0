Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6C5C282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A77B2173B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfBGWgs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:36:48 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56648 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726758AbfBGWgr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 17:36:47 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grsHk-0002II-G8; Fri, 08 Feb 2019 00:36:44 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 00:36:15 +0200
Message-Id: <20190207223622.9642-11-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207223622.9642-1-luca@coelho.fi>
References: <20190207223622.9642-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/17] iwlwifi: mvm: clean up NO_PSDU case
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We now no longer have any special code in
iwl_mvm_pass_packet_to_mac80211(), so don't
need to pass NO_PSDU packets through it.
Stop doing so and clean up the code there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 957d99932e8b..557a0b5a08ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -258,10 +258,7 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 					    struct ieee80211_sta *sta,
 					    bool csi)
 {
-	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
-
-	if (!(rx_status->flag & RX_FLAG_NO_PSDU) &&
-	    iwl_mvm_check_pn(mvm, skb, queue, sta))
+	if (iwl_mvm_check_pn(mvm, skb, queue, sta))
 		kfree_skb(skb);
 	else
 		ieee80211_rx_napi(mvm->hw, sta, skb, napi);
@@ -1800,7 +1797,7 @@ void iwl_mvm_rx_monitor_ndp(struct iwl_mvm *mvm, struct napi_struct *napi,
 		rx_status->rate_idx = rate;
 	}
 
-	iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta, false);
+	ieee80211_rx_napi(mvm->hw, sta, skb, napi);
 out:
 	rcu_read_unlock();
 }
-- 
2.20.1

