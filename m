Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E35C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80BFF20855
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730755AbfA3Lzv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:55:51 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52750 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727878AbfA3Lzu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:55:50 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooT5-0003x8-Sj; Wed, 30 Jan 2019 13:55:49 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:16 +0200
Message-Id: <20190130115528.19922-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/17] iwlwifi: fix bad dma handling in page_mem dumping flow
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Prior to gen2 we allocate the paging memory via alloc_pages
which requires passing ownership on the memory between the
cpu and the device using dma_sync_single_for_cpu and
dma_sync_single_for_device.

Add missing dma_sync_single_for_device in iwl_dump_paging
after copying the memory.

since gen2, we allocate the paging memory using dma_alloc_coherent
which does not need passing ownership between the cpu and device.

Remove unneeded call to dma_sync_single_for_cpu in
iwl_trans_pcie_dump_data prior to copying the memory.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: 5538409ba393 ("iwlwifi: pcie: support page dumping in wrt in gen2")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c     | 3 +++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 35c2b1a23d10..d16a8a4f0c3f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -815,6 +815,9 @@ static void iwl_dump_paging(struct iwl_fw_runtime *fwrt,
 					DMA_BIDIRECTIONAL);
 		memcpy(paging->data, page_address(pages),
 		       PAGING_BLOCK_SIZE);
+		dma_sync_single_for_device(fwrt->trans->dev, addr,
+					   PAGING_BLOCK_SIZE,
+					   DMA_BIDIRECTIONAL);
 		(*data) = iwl_fw_error_next_data(*data);
 	}
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index f74281508197..f26664b0f0f8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3277,16 +3277,12 @@ static struct iwl_trans_dump_data
 	if (trans->cfg->gen2 && dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING)) {
 		for (i = 0; i < trans_pcie->init_dram.paging_cnt; i++) {
 			struct iwl_fw_error_dump_paging *paging;
-			dma_addr_t addr =
-				trans_pcie->init_dram.paging[i].physical;
 			u32 page_len = trans_pcie->init_dram.paging[i].size;
 
 			data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PAGING);
 			data->len = cpu_to_le32(sizeof(*paging) + page_len);
 			paging = (void *)data->data;
 			paging->index = cpu_to_le32(i);
-			dma_sync_single_for_cpu(trans->dev, addr, page_len,
-						DMA_BIDIRECTIONAL);
 			memcpy(paging->data,
 			       trans_pcie->init_dram.paging[i].block, page_len);
 			data = iwl_fw_error_next_data(data);
-- 
2.20.1

