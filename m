Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4049AC282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F4BD218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfAYUNQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:13:16 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50782 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725778AbfAYUNQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:13:16 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn7qk-00010a-9q; Fri, 25 Jan 2019 22:13:14 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 22:12:52 +0200
Message-Id: <20190125201305.5616-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125201305.5616-1-luca@coelho.fi>
References: <20190125201305.5616-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/17] iwlwifi: pcie: add prints to track virtual ID
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

In case there are bugs in this area, this data can
help with debugging.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 541da1d44762..4ecf87c1cda3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -256,6 +256,9 @@ static void iwl_pcie_restock_bd(struct iwl_trans *trans,
 
 		bd[rxq->write] = cpu_to_le64(rxb->page_dma | rxb->vid);
 	}
+
+	IWL_DEBUG_RX(trans, "Assigned virtual RB ID %u to queue %d index %d\n",
+		     (u32)rxb->vid, rxq->id, rxq->write);
 }
 
 /*
@@ -1342,6 +1345,8 @@ static struct iwl_rx_mem_buffer *iwl_pcie_get_rxb(struct iwl_trans *trans,
 	if (rxb->invalid)
 		goto out_err;
 
+	IWL_DEBUG_RX(trans, "Got virtual RB ID %u\n", (u32)rxb->vid);
+
 	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
 		rxb->size = le32_to_cpu(rxq->cd[i].size) & IWL_RX_CD_SIZE;
 
@@ -1393,11 +1398,12 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 			emergency = true;
 		}
 
+		IWL_DEBUG_RX(trans, "Q %d: HW = %d, SW = %d\n", rxq->id, r, i);
+
 		rxb = iwl_pcie_get_rxb(trans, rxq, i);
 		if (!rxb)
 			goto out;
 
-		IWL_DEBUG_RX(trans, "Q %d: HW = %d, SW = %d\n", rxq->id, r, i);
 		iwl_pcie_rx_handle_rb(trans, rxq, rxb, emergency, i);
 
 		i = (i + 1) & (rxq->queue_size - 1);
-- 
2.20.1

