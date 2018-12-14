Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EFCC43612
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 166C22080F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbeLNUaC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:30:02 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42000 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730871AbeLNU37 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:29:59 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5t-0002RG-K4; Fri, 14 Dec 2018 22:29:58 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:36 +0200
Message-Id: <20181214202945.32375-10-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/18] iwlwifi: mvm: take station lock later in the code
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

There is no need to lock mvm station for transport reclaim.
Move the locking down, after the reclaim.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 4ebfd41dadc9..995fe2a6abbb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1817,8 +1817,6 @@ static void iwl_mvm_tx_reclaim(struct iwl_mvm *mvm, int sta_id, int tid,
 		return;
 	}
 
-	spin_lock_bh(&mvmsta->lock);
-
 	__skb_queue_head_init(&reclaimed_skbs);
 
 	/*
@@ -1828,6 +1826,8 @@ static void iwl_mvm_tx_reclaim(struct iwl_mvm *mvm, int sta_id, int tid,
 	 */
 	iwl_trans_reclaim(mvm->trans, txq, index, &reclaimed_skbs);
 
+	spin_lock_bh(&mvmsta->lock);
+
 	tid_data->next_reclaimed = index;
 
 	iwl_mvm_check_ratid_empty(mvm, sta, tid);
-- 
2.19.2

