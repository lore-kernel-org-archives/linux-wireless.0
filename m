Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6961EC10F10
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44242218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfCVN7R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:59:17 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46078 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727806AbfCVN7R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 09:59:17 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7KhX-0000bK-3k; Fri, 22 Mar 2019 15:59:15 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:43 +0200
Message-Id: <20190322135903.10631-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/24] iwlwifi: dbg_ini: add memory offset to the base address of a memory region
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add the offset to the base address of a memory region to show the actual
addresses being read.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 26 +++++++++------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 4beec863197e..78bca27b7809 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1049,14 +1049,14 @@ static int iwl_dump_ini_prph_iter(struct iwl_fw_runtime *fwrt,
 {
 	struct iwl_fw_ini_error_dump_range *range = range_ptr;
 	__le32 *val = range->data;
-	u32 addr, prph_val, offset = le32_to_cpu(reg->offset);
+	u32 prph_val;
+	u32 addr = le32_to_cpu(reg->start_addr[idx]) + le32_to_cpu(reg->offset);
 	int i;
 
-	range->start_addr = reg->start_addr[idx];
+	range->start_addr = cpu_to_le32(addr);
 	range->range_data_size = reg->internal.range_data_size;
 	for (i = 0; i < le32_to_cpu(reg->internal.range_data_size); i += 4) {
-		addr = le32_to_cpu(range->start_addr) + i;
-		prph_val = iwl_read_prph(fwrt->trans, addr + offset);
+		prph_val = iwl_read_prph(fwrt->trans, addr + i);
 		if (prph_val == 0x5a5a5a5a)
 			return -EBUSY;
 		*val++ = cpu_to_le32(prph_val);
@@ -1071,16 +1071,13 @@ static int iwl_dump_ini_csr_iter(struct iwl_fw_runtime *fwrt,
 {
 	struct iwl_fw_ini_error_dump_range *range = range_ptr;
 	__le32 *val = range->data;
-	u32 addr, offset = le32_to_cpu(reg->offset);
+	u32 addr = le32_to_cpu(reg->start_addr[idx]) + le32_to_cpu(reg->offset);
 	int i;
 
-	range->start_addr = reg->start_addr[idx];
+	range->start_addr = cpu_to_le32(addr);
 	range->range_data_size = reg->internal.range_data_size;
-	for (i = 0; i < le32_to_cpu(reg->internal.range_data_size); i += 4) {
-		addr = le32_to_cpu(range->start_addr) + i;
-		*val++ = cpu_to_le32(iwl_trans_read32(fwrt->trans,
-						      addr + offset));
-	}
+	for (i = 0; i < le32_to_cpu(reg->internal.range_data_size); i += 4)
+		*val++ = cpu_to_le32(iwl_trans_read32(fwrt->trans, addr + i));
 
 	return sizeof(*range) + le32_to_cpu(range->range_data_size);
 }
@@ -1090,12 +1087,11 @@ static int iwl_dump_ini_dev_mem_iter(struct iwl_fw_runtime *fwrt,
 				     void *range_ptr, int idx)
 {
 	struct iwl_fw_ini_error_dump_range *range = range_ptr;
-	u32 addr, offset = le32_to_cpu(reg->offset);
+	u32 addr = le32_to_cpu(reg->start_addr[idx]) + le32_to_cpu(reg->offset);
 
-	range->start_addr = reg->start_addr[idx];
-	addr = le32_to_cpu(range->start_addr);
+	range->start_addr = cpu_to_le32(addr);
 	range->range_data_size = reg->internal.range_data_size;
-	iwl_trans_read_mem_bytes(fwrt->trans, addr + offset, range->data,
+	iwl_trans_read_mem_bytes(fwrt->trans, addr, range->data,
 				 le32_to_cpu(reg->internal.range_data_size));
 
 	return sizeof(*range) + le32_to_cpu(range->range_data_size);
-- 
2.20.1

