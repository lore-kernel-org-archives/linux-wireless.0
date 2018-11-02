Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9669CC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69E9620657
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69E9620657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbeKBUPS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 16:15:18 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:34078 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726528AbeKBUPS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 16:15:18 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gIXJK-0007MW-Dg; Fri, 02 Nov 2018 13:08:18 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  2 Nov 2018 13:08:00 +0200
Message-Id: <20181102110800.29817-16-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102110800.29817-1-luca@coelho.fi>
References: <20181102110800.29817-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/15] iwlwifi: fw: use helper to determine whether to dump paging
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Logic is there twice, and we'll need a third place
soon for ini dumping. In addition move the dumping
to a function, also to enable reuse.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 57 +++++++++++----------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h |  8 +++
 2 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index aebdf433b409..58a980070445 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -639,6 +639,32 @@ static int iwl_fw_fifo_len(struct iwl_fw_runtime *fwrt,
 	return fifo_len;
 }
 
+static void iwl_dump_paging(struct iwl_fw_runtime *fwrt,
+			    struct iwl_fw_error_dump_data **data)
+{
+	int i;
+
+	IWL_DEBUG_INFO(fwrt, "WRT paging dump\n");
+	for (i = 1; i < fwrt->num_of_paging_blk + 1; i++) {
+		struct iwl_fw_error_dump_paging *paging;
+		struct page *pages =
+			fwrt->fw_paging_db[i].fw_paging_block;
+		dma_addr_t addr = fwrt->fw_paging_db[i].fw_paging_phys;
+
+		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PAGING);
+		(*data)->len = cpu_to_le32(sizeof(*paging) +
+					     PAGING_BLOCK_SIZE);
+		paging =  (void *)(*data)->data;
+		paging->index = cpu_to_le32(i);
+		dma_sync_single_for_cpu(fwrt->trans->dev, addr,
+					PAGING_BLOCK_SIZE,
+					DMA_BIDIRECTIONAL);
+		memcpy(paging->data, page_address(pages),
+		       PAGING_BLOCK_SIZE);
+		(*data) = iwl_fw_error_next_data(*data);
+	}
+}
+
 static struct iwl_fw_error_dump_file *
 _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 		   struct iwl_fw_dump_ptrs *fw_error_dump)
@@ -707,10 +733,7 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	}
 
 	/* Make room for fw's virtual image pages, if it exists */
-	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_PAGING) &&
-	    !fwrt->trans->cfg->gen2 &&
-	    fwrt->fw->img[fwrt->cur_fw_img].paging_mem_size &&
-	    fwrt->fw_paging_db[0].fw_paging_block)
+	if (iwl_fw_dbg_is_paging_enabled(fwrt))
 		file_len += fwrt->num_of_paging_blk *
 			(sizeof(*dump_data) +
 			 sizeof(struct iwl_fw_error_dump_paging) +
@@ -860,30 +883,8 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	}
 
 	/* Dump fw's virtual image */
-	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_PAGING) &&
-	    !fwrt->trans->cfg->gen2 &&
-	    fwrt->fw->img[fwrt->cur_fw_img].paging_mem_size &&
-	    fwrt->fw_paging_db[0].fw_paging_block) {
-		IWL_DEBUG_INFO(fwrt, "WRT paging dump\n");
-		for (i = 1; i < fwrt->num_of_paging_blk + 1; i++) {
-			struct iwl_fw_error_dump_paging *paging;
-			struct page *pages =
-				fwrt->fw_paging_db[i].fw_paging_block;
-			dma_addr_t addr = fwrt->fw_paging_db[i].fw_paging_phys;
-
-			dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PAGING);
-			dump_data->len = cpu_to_le32(sizeof(*paging) +
-						     PAGING_BLOCK_SIZE);
-			paging = (void *)dump_data->data;
-			paging->index = cpu_to_le32(i);
-			dma_sync_single_for_cpu(fwrt->trans->dev, addr,
-						PAGING_BLOCK_SIZE,
-						DMA_BIDIRECTIONAL);
-			memcpy(paging->data, page_address(pages),
-			       PAGING_BLOCK_SIZE);
-			dump_data = iwl_fw_error_next_data(dump_data);
-		}
-	}
+	if (iwl_fw_dbg_is_paging_enabled(fwrt))
+		iwl_dump_paging(fwrt, &dump_data);
 
 	if (prph_len) {
 		iwl_dump_prph(fwrt->trans, &dump_data,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 0d5169c4cf51..4a5fa05c7ac2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -322,6 +322,14 @@ static inline bool iwl_fw_dbg_is_d3_debug_enabled(struct iwl_fw_runtime *fwrt)
 		iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_D3_DEBUG_DATA);
 }
 
+static inline bool iwl_fw_dbg_is_paging_enabled(struct iwl_fw_runtime *fwrt)
+{
+	return iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_PAGING) &&
+		!fwrt->trans->cfg->gen2 &&
+		fwrt->fw->img[fwrt->cur_fw_img].paging_mem_size &&
+		fwrt->fw_paging_db[0].fw_paging_block;
+}
+
 void iwl_fw_dbg_read_d3_debug_data(struct iwl_fw_runtime *fwrt);
 
 static inline void iwl_fw_flush_dump(struct iwl_fw_runtime *fwrt)
-- 
2.19.1

