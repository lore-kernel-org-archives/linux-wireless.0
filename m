Return-Path: <SRS0=CMgv=ZM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5AEC432C0
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Nov 2019 10:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 415352243E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Nov 2019 10:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfKTK1D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Nov 2019 05:27:03 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:58552 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727399AbfKTK1C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Nov 2019 05:27:02 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iXNCO-0001kS-0B; Wed, 20 Nov 2019 12:27:00 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 20 Nov 2019 12:26:44 +0200
Message-Id: <20191120102650.514376-7-luca@coelho.fi>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191120102650.514376-1-luca@coelho.fi>
References: <20191120102650.514376-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/12] iwlwifi: pcie: rx: use rxq queue_size instead of constant
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This is a little less efficient now as it's known to be a
multiqueue device in this function, but a future patch will
have to use a variable here anyway, so use rxq->queue_size
now instead to make it clearer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 7f9cc4c84c18..a4d325fcf94a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -322,7 +322,7 @@ static void iwl_pcie_rxmq_restock(struct iwl_trans *trans,
 		WARN_ON(rxb->page_dma & DMA_BIT_MASK(12));
 		/* Point to Rx buffer via next RBD in circular buffer */
 		iwl_pcie_restock_bd(trans, rxq, rxb);
-		rxq->write = (rxq->write + 1) & MQ_RX_TABLE_MASK;
+		rxq->write = (rxq->write + 1) & (rxq->queue_size - 1);
 		rxq->free_count--;
 	}
 	spin_unlock(&rxq->lock);
-- 
2.24.0

