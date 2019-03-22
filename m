Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4AC3C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E9AC218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfCVN7W (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:59:22 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46128 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727487AbfCVN7V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 09:59:21 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khc-0000bK-17; Fri, 22 Mar 2019 15:59:20 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:48 +0200
Message-Id: <20190322135903.10631-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/24] iwlwifi: mvm: IBSS: use BE FIFO for multicast
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Back in commit 4d339989acd7 ("iwlwifi: mvm: support ibss in dqa mode")
we changed queue selection for IBSS to be:

    if (ieee80211_is_probe_resp(fc) || ieee80211_is_auth(fc) ||
        ieee80211_is_deauth(fc))
            return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
    if (info->hw_queue == info->control.vif->cab_queue)
            return info->hw_queue;
    return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;

Clearly, the thought at the time must've been that mac80211 will
select the hw_queue as the cab_queue, so that we'll return and use
that, where we store the multicast queue for IBSS. This, however,
isn't true because mac80211 doesn't implement powersave for IBSS
and thus selects the normal IBSS interface AC queue (best effort).

This therefore always used the probe response queue, which maps to
the BE FIFO.

In commit cfbc6c4c5b91 ("iwlwifi: mvm: support mac80211 TXQs model")
we rethought this code, and as a consequence now started mapping the
multicast traffic to the multicast hardware queue since we no longer
relied on mac80211 selecting the queue, doing it ourselves instead.
This queue is mapped to the MCAST FIFO. however, this isn't actually
enabled/controlled by the firmware in IBSS mode because we don't
implement powersave, and frames from this queue can never go out in
this case.

Therefore, we got queue hang reports such as
https://bugzilla.kernel.org/show_bug.cgi?id=201707

Fix this by mapping the multicast queue to the BE FIFO in IBSS so
that all the frames can go out.

Fixes: cfbc6c4c5b91 ("iwlwifi: mvm: support mac80211 TXQs model")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 498c315291cf..47eddd6456ab 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2275,7 +2275,8 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	static const u8 _maddr[] = {0x03, 0x00, 0x00, 0x00, 0x00, 0x00};
 	const u8 *maddr = _maddr;
 	struct iwl_trans_txq_scd_cfg cfg = {
-		.fifo = IWL_MVM_TX_FIFO_MCAST,
+		.fifo = vif->type == NL80211_IFTYPE_AP ?
+			IWL_MVM_TX_FIFO_MCAST : IWL_MVM_TX_FIFO_BE,
 		.sta_id = msta->sta_id,
 		.tid = 0,
 		.aggregate = false,
-- 
2.20.1

