Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F09CC4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 12:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD97218E2
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 12:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387802AbfCVMrx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:47:53 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46016 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387597AbfCVMrv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 08:47:51 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7JaP-0000ZZ-PR; Fri, 22 Mar 2019 14:47:50 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 14:47:42 +0200
Message-Id: <20190322124744.17924-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322124744.17924-1-luca@coelho.fi>
References: <20190322124744.17924-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 1/3] iwlwifi: mvm: avoid possible deadlock in TX path
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

iwl_mvm_tx_mpdu() may run from iwl_mvm_add_new_dqa_stream_wk(), where
soft-IRQs aren't disabled. In this case, it may hold the station lock
and be interrupted by a soft-IRQ that also wants to acquire said lock,
leading to a deadlock.

Fix it by disabling soft-IRQs in iwl_mvm_add_new_dqa_stream_wk().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index db26f0041a81..98d123dd7177 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1399,7 +1399,9 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 
 		iwl_mvm_sta_alloc_queue(mvm, txq->sta, txq->ac, tid);
 		list_del_init(&mvmtxq->list);
+		local_bh_disable();
 		iwl_mvm_mac_itxq_xmit(mvm->hw, txq);
+		local_bh_enable();
 	}
 
 	mutex_unlock(&mvm->mutex);
-- 
2.20.1

