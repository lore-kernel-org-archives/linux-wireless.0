Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7751C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A9502080F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730849AbeLNUa4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:30:56 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42106 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730787AbeLNUa4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:30:56 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5v-0002RG-1S; Fri, 14 Dec 2018 22:29:59 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:38 +0200
Message-Id: <20181214202945.32375-12-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/18] iwlwifi: mvm: clean up SSN incrementation
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Sometimes, due to SCD bug, we need to start the queue with an
higher SSN. The queue allocation function currently increments
the SSN in the packet itself, but it is pointless, since this
value is overridden later by iwl_mvm_tx_mpdu with the value
from mvmsta->tid_data[tid].seq_number. Updating tid data is
sufficient.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index e82194836f03..e28009832da0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1254,6 +1254,7 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 
 	spin_lock_bh(&mvmsta->lock);
 	tfd_queue_mask = mvmsta->tfd_queue_msk;
+	ssn = IEEE80211_SEQ_TO_SN(mvmsta->tid_data[tid].seq_number);
 	spin_unlock_bh(&mvmsta->lock);
 
 	/*
@@ -1340,13 +1341,8 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 		}
 	}
 
-	ssn = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
 	inc_ssn = iwl_mvm_enable_txq(mvm, queue, mac_queue,
 				     ssn, &cfg, wdg_timeout);
-	if (inc_ssn) {
-		ssn = (ssn + 1) & IEEE80211_SCTL_SEQ;
-		le16_add_cpu(&hdr->seq_ctrl, 0x10);
-	}
 
 	/*
 	 * Mark queue as shared in transport if shared
@@ -1363,8 +1359,10 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	 * this ra/tid in our Tx path since we stop the Qdisc when we
 	 * need to allocate a new TFD queue.
 	 */
-	if (inc_ssn)
+	if (inc_ssn) {
 		mvmsta->tid_data[tid].seq_number += 0x10;
+		ssn = (ssn + 1) & IEEE80211_SCTL_SEQ;
+	}
 	mvmsta->tid_data[tid].txq_id = queue;
 	mvmsta->tfd_queue_msk |= BIT(queue);
 	queue_state = mvmsta->tid_data[tid].state;
-- 
2.19.2

