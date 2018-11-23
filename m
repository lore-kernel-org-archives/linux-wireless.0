Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C04C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C6A020820
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:27:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C6A020820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503811AbeKWWLJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:11:09 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38378 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2503793AbeKWWLJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:11:09 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bg-0008GU-Oi; Fri, 23 Nov 2018 13:26:45 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:26 +0200
Message-Id: <20181123112631.29360-11-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/15] iwlwifi: pcie: fix erroneous print
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

When removing the driver, the following flow can happen:
1. host command is in progress, for example at index 68.
2. RX interrupt is received with the response.
3. Before it is processed, the remove flow kicks in, and
   calls iwl_pcie_txq_unmap. The function cleans all DMA,
   and promotes the read pointer to 69.
4. RX thread proceeds with the processing, and is calling
   iwl_pcie_cmdq_reclaim, which will print this error:
   iwl_pcie_cmdq_reclaim: Read index for DMA queue txq id (0),
   index 4 is out of range [0-256] 69 69.

Detect this situation, and avoid the print. Change it to
warning while at it, to make such issues more noticeable
in the future.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 87b7225fe289..3d53842ee60e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1245,11 +1245,11 @@ void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 
 	if (idx >= trans->cfg->base_params->max_tfd_queue_size ||
 	    (!iwl_queue_used(txq, idx))) {
-		IWL_ERR(trans,
-			"%s: Read index for DMA queue txq id (%d), index %d is out of range [0-%d] %d %d.\n",
-			__func__, txq_id, idx,
-			trans->cfg->base_params->max_tfd_queue_size,
-			txq->write_ptr, txq->read_ptr);
+		WARN_ONCE(test_bit(txq_id, trans_pcie->queue_used),
+			  "%s: Read index for DMA queue txq id (%d), index %d is out of range [0-%d] %d %d.\n",
+			  __func__, txq_id, idx,
+			  trans->cfg->base_params->max_tfd_queue_size,
+			  txq->write_ptr, txq->read_ptr);
 		return;
 	}
 
-- 
2.19.1

