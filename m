Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D606C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87E112080F
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 20:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbeLNUai (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 15:30:38 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42066 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730713AbeLNUai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 15:30:38 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=localhost.localdomain)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXu5u-0002RG-BB; Fri, 14 Dec 2018 22:29:58 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 22:29:37 +0200
Message-Id: <20181214202945.32375-11-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214202945.32375-1-luca@coelho.fi>
References: <20181214202945.32375-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/18] iwlwifi: pcie: lock txq a bit later in reclaim code
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

In reclaim code, we don't need to take the queue lock for
waking the queue. The code section is executed only when
the tx path is stopped, and since the reclaim path is not
executed in parallel to itself, no one can update the queue
pointers, and accessing them is safe without a lock.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 3d53842ee60e..ee990a7a5411 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1160,10 +1160,11 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 			 */
 			iwl_trans_tx(trans, skb, dev_cmd_ptr, txq_id);
 		}
-		spin_lock_bh(&txq->lock);
 
 		if (iwl_queue_space(trans, txq) > txq->low_mark)
 			iwl_wake_queue(trans, txq);
+
+		spin_lock_bh(&txq->lock);
 	}
 
 	if (txq->read_ptr == txq->write_ptr) {
-- 
2.19.2

