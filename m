Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FA5C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D16B1218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfCVN7n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:59:43 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46186 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727693AbfCVN7m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 09:59:42 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khc-0000bK-PS; Fri, 22 Mar 2019 15:59:21 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:49 +0200
Message-Id: <20190322135903.10631-11-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/24] iwlwifi: dbg_ini: change memory range base address to u64
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

AX210 devices will use u64 for the base address to the DRAM monitor
buffer. To support this, change the structure for all device families
so both address sizes fit.

Also move range_data_size to the top of the struct to ease the parsing
of the memory range.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 12 ++++++------
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index a1d6765498a8..1b6a850940cf 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1053,7 +1053,7 @@ static int iwl_dump_ini_prph_iter(struct iwl_fw_runtime *fwrt,
 	u32 addr = le32_to_cpu(reg->start_addr[idx]) + le32_to_cpu(reg->offset);
 	int i;
 
-	range->start_addr = cpu_to_le32(addr);
+	range->start_addr = cpu_to_le64(addr);
 	range->range_data_size = reg->internal.range_data_size;
 	for (i = 0; i < le32_to_cpu(reg->internal.range_data_size); i += 4) {
 		prph_val = iwl_read_prph(fwrt->trans, addr + i);
@@ -1074,7 +1074,7 @@ static int iwl_dump_ini_csr_iter(struct iwl_fw_runtime *fwrt,
 	u32 addr = le32_to_cpu(reg->start_addr[idx]) + le32_to_cpu(reg->offset);
 	int i;
 
-	range->start_addr = cpu_to_le32(addr);
+	range->start_addr = cpu_to_le64(addr);
 	range->range_data_size = reg->internal.range_data_size;
 	for (i = 0; i < le32_to_cpu(reg->internal.range_data_size); i += 4)
 		*val++ = cpu_to_le32(iwl_trans_read32(fwrt->trans, addr + i));
@@ -1089,7 +1089,7 @@ static int iwl_dump_ini_dev_mem_iter(struct iwl_fw_runtime *fwrt,
 	struct iwl_fw_ini_error_dump_range *range = range_ptr;
 	u32 addr = le32_to_cpu(reg->start_addr[idx]) + le32_to_cpu(reg->offset);
 
-	range->start_addr = cpu_to_le32(addr);
+	range->start_addr = cpu_to_le64(addr);
 	range->range_data_size = reg->internal.range_data_size;
 	iwl_trans_read_mem_bytes(fwrt->trans, addr, range->data,
 				 le32_to_cpu(reg->internal.range_data_size));
@@ -1105,7 +1105,7 @@ iwl_dump_ini_paging_gen2_iter(struct iwl_fw_runtime *fwrt,
 	struct iwl_fw_ini_error_dump_range *range = range_ptr;
 	u32 page_size = fwrt->trans->init_dram.paging[idx].size;
 
-	range->start_addr = cpu_to_le32(idx);
+	range->start_addr = cpu_to_le64(idx);
 	range->range_data_size = cpu_to_le32(page_size);
 	memcpy(range->data, fwrt->trans->init_dram.paging[idx].block,
 	       page_size);
@@ -1125,7 +1125,7 @@ static int iwl_dump_ini_paging_iter(struct iwl_fw_runtime *fwrt,
 	dma_addr_t addr = fwrt->fw_paging_db[idx].fw_paging_phys;
 	u32 page_size = fwrt->fw_paging_db[idx].fw_paging_size;
 
-	range->start_addr = cpu_to_le32(idx);
+	range->start_addr = cpu_to_le64(idx);
 	range->range_data_size = cpu_to_le32(page_size);
 	dma_sync_single_for_cpu(fwrt->trans->dev, addr,	page_size,
 				DMA_BIDIRECTIONAL);
@@ -1148,7 +1148,7 @@ iwl_dump_ini_mon_dram_iter(struct iwl_fw_runtime *fwrt,
 	if (start_addr == 0x5a5a5a5a)
 		return -EBUSY;
 
-	range->start_addr = cpu_to_le32(start_addr);
+	range->start_addr = cpu_to_le64(start_addr);
 	range->range_data_size = cpu_to_le32(fwrt->trans->fw_mon[idx].size);
 
 	memcpy(range->data, fwrt->trans->fw_mon[idx].block,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index d6c67960dccd..0df72a99bf05 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -284,13 +284,13 @@ struct iwl_fw_error_dump_mem {
 
 /**
  * struct iwl_fw_ini_error_dump_range - range of memory
- * @start_addr: the start address of this range
  * @range_data_size: the size of this range, in bytes
+ * @start_addr: the start address of this range
  * @data: the actual memory
  */
 struct iwl_fw_ini_error_dump_range {
-	__le32 start_addr;
 	__le32 range_data_size;
+	__le64 start_addr;
 	__le32 data[];
 } __packed;
 
-- 
2.20.1

