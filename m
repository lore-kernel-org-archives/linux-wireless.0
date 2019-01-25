Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB0BC282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACF58218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfAYUV7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:21:59 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50912 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725778AbfAYUV6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:21:58 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn7qr-00010a-Iq; Fri, 25 Jan 2019 22:13:21 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 22:13:01 +0200
Message-Id: <20190125201305.5616-14-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125201305.5616-1-luca@coelho.fi>
References: <20190125201305.5616-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/17] iwlwifi: calculate pointers from out_cmd instead of out_cmd->hdr
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

The out_cmd structure starts with a header, so there's no need to use
&out_cmd->hdr, out_cmd alone is enough.  We use this when calculating
other addresses and klocwork gets confused with that because it thinks
we are trying to access hdr (as an array) beyond its size.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 8807ea9d693c..f3d2e8fe920b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -838,14 +838,14 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 
 	/* start the TFD with the minimum copy bytes */
 	tb0_size = min_t(int, copy_size, IWL_FIRST_TB_SIZE);
-	memcpy(&txq->first_tb_bufs[idx], &out_cmd->hdr, tb0_size);
+	memcpy(&txq->first_tb_bufs[idx], out_cmd, tb0_size);
 	iwl_pcie_gen2_set_tb(trans, tfd, iwl_pcie_get_first_tb_dma(txq, idx),
 			     tb0_size);
 
 	/* map first command fragment, if any remains */
 	if (copy_size > tb0_size) {
 		phys_addr = dma_map_single(trans->dev,
-					   ((u8 *)&out_cmd->hdr) + tb0_size,
+					   (u8 *)out_cmd + tb0_size,
 					   copy_size - tb0_size,
 					   DMA_TO_DEVICE);
 		if (dma_mapping_error(trans->dev, phys_addr)) {
-- 
2.20.1

