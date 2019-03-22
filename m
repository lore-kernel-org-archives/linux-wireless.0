Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125F0C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E08D9218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfCVN7X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:59:23 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46120 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727874AbfCVN7V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 09:59:21 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khb-0000bK-5D; Fri, 22 Mar 2019 15:59:19 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:47 +0200
Message-Id: <20190322135903.10631-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/24] iwlwifi: dbg_ini: add registers addresses in fifo dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add to the fifo dump the registers addresses.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 46 +++++++++++++------
 .../wireless/intel/iwlwifi/fw/error-dump.h    | 15 +++++-
 2 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index a014fb729f48..a1d6765498a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1224,10 +1224,11 @@ static int iwl_dump_ini_txf_iter(struct iwl_fw_runtime *fwrt,
 {
 	struct iwl_fw_ini_fifo_error_dump_range *range = range_ptr;
 	struct iwl_ini_txf_iter_data *iter;
+	struct iwl_fw_ini_error_dump_register *reg_dump = (void *)range->data;
 	u32 offs = le32_to_cpu(reg->offset), addr;
 	u32 registers_size =
-		le32_to_cpu(reg->fifos.num_of_registers) * sizeof(__le32);
-	__le32 *val = range->data;
+		le32_to_cpu(reg->fifos.num_of_registers) * sizeof(*reg_dump);
+	__le32 *data;
 	unsigned long flags;
 	int i;
 
@@ -1245,11 +1246,18 @@ static int iwl_dump_ini_txf_iter(struct iwl_fw_runtime *fwrt,
 
 	iwl_write_prph_no_grab(fwrt->trans, TXF_LARC_NUM + offs, iter->fifo);
 
-	/* read txf registers */
+	/*
+	 * read txf registers. for each register, write to the dump the
+	 * register address and its value
+	 */
 	for (i = 0; i < le32_to_cpu(reg->fifos.num_of_registers); i++) {
 		addr = le32_to_cpu(reg->start_addr[i]) + offs;
 
-		*val++ = cpu_to_le32(iwl_read_prph_no_grab(fwrt->trans, addr));
+		reg_dump->addr = cpu_to_le32(addr);
+		reg_dump->data = cpu_to_le32(iwl_read_prph_no_grab(fwrt->trans,
+								   addr));
+
+		reg_dump++;
 	}
 
 	if (reg->fifos.header_only) {
@@ -1266,8 +1274,9 @@ static int iwl_dump_ini_txf_iter(struct iwl_fw_runtime *fwrt,
 
 	/* Read FIFO */
 	addr = TXF_READ_MODIFY_DATA + offs;
-	for (i = 0; i < iter->fifo_size; i += sizeof(__le32))
-		*val++ = cpu_to_le32(iwl_read_prph_no_grab(fwrt->trans, addr));
+	data = (void *)reg_dump;
+	for (i = 0; i < iter->fifo_size; i += sizeof(*data))
+		*data++ = cpu_to_le32(iwl_read_prph_no_grab(fwrt->trans, addr));
 
 out:
 	iwl_trans_release_nic_access(fwrt->trans, &flags);
@@ -1323,10 +1332,11 @@ static int iwl_dump_ini_rxf_iter(struct iwl_fw_runtime *fwrt,
 {
 	struct iwl_fw_ini_fifo_error_dump_range *range = range_ptr;
 	struct iwl_ini_rxf_data rxf_data;
+	struct iwl_fw_ini_error_dump_register *reg_dump = (void *)range->data;
 	u32 offs = le32_to_cpu(reg->offset), addr;
 	u32 registers_size =
-		le32_to_cpu(reg->fifos.num_of_registers) * sizeof(__le32);
-	__le32 *val = range->data;
+		le32_to_cpu(reg->fifos.num_of_registers) * sizeof(*reg_dump);
+	__le32 *data;
 	unsigned long flags;
 	int i;
 
@@ -1343,11 +1353,18 @@ static int iwl_dump_ini_rxf_iter(struct iwl_fw_runtime *fwrt,
 	range->num_of_registers = reg->fifos.num_of_registers;
 	range->range_data_size = cpu_to_le32(rxf_data.size + registers_size);
 
-	/* read rxf registers */
+	/*
+	 * read rxf registers. for each register, write to the dump the
+	 * register address and its value
+	 */
 	for (i = 0; i < le32_to_cpu(reg->fifos.num_of_registers); i++) {
 		addr = le32_to_cpu(reg->start_addr[i]) + offs;
 
-		*val++ = cpu_to_le32(iwl_read_prph_no_grab(fwrt->trans, addr));
+		reg_dump->addr = cpu_to_le32(addr);
+		reg_dump->data = cpu_to_le32(iwl_read_prph_no_grab(fwrt->trans,
+								   addr));
+
+		reg_dump++;
 	}
 
 	if (reg->fifos.header_only) {
@@ -1365,8 +1382,9 @@ static int iwl_dump_ini_rxf_iter(struct iwl_fw_runtime *fwrt,
 
 	/* Read FIFO */
 	addr =  RXF_FIFO_RD_FENCE_INC + offs;
-	for (i = 0; i < rxf_data.size; i += sizeof(__le32))
-		*val++ = cpu_to_le32(iwl_read_prph_no_grab(fwrt->trans, addr));
+	data = (void *)reg_dump;
+	for (i = 0; i < rxf_data.size; i += sizeof(*data))
+		*data++ = cpu_to_le32(iwl_read_prph_no_grab(fwrt->trans, addr));
 
 out:
 	iwl_trans_release_nic_access(fwrt->trans, &flags);
@@ -1525,7 +1543,7 @@ static u32 iwl_dump_ini_txf_get_size(struct iwl_fw_runtime *fwrt,
 	void *fifo_iter = fwrt->dump.fifo_iter;
 	u32 size = 0;
 	u32 fifo_hdr = sizeof(struct iwl_fw_ini_fifo_error_dump_range) +
-		le32_to_cpu(reg->fifos.num_of_registers) * sizeof(__le32);
+		le32_to_cpu(reg->fifos.num_of_registers) * sizeof(__le32) * 2;
 
 	fwrt->dump.fifo_iter = &iter;
 	while (iwl_ini_txf_iter(fwrt, reg)) {
@@ -1548,7 +1566,7 @@ static u32 iwl_dump_ini_rxf_get_size(struct iwl_fw_runtime *fwrt,
 	struct iwl_ini_rxf_data rx_data;
 	u32 size = sizeof(struct iwl_fw_ini_fifo_error_dump) +
 		sizeof(struct iwl_fw_ini_fifo_error_dump_range) +
-		le32_to_cpu(reg->fifos.num_of_registers) * sizeof(__le32);
+		le32_to_cpu(reg->fifos.num_of_registers) * sizeof(__le32) * 2;
 
 	if (reg->fifos.header_only)
 		return size;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index ac2589bfedb2..d6c67960dccd 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -323,13 +323,24 @@ struct iwl_fw_ini_error_dump {
 /* This bit is used to differentiate between lmac and umac rxf */
 #define IWL_RXF_UMAC_BIT BIT(31)
 
+/**
+ * struct iwl_fw_ini_error_dump_register - ini register dump
+ * @addr: address of the register
+ * @data: data of the register
+ */
+struct iwl_fw_ini_error_dump_register {
+	__le32 addr;
+	__le32 data;
+} __packed;
+
 /**
  * struct iwl_fw_ini_fifo_error_dump_range - ini fifo range dump
  * @fifo_num: the fifo num. In case of rxf and umac rxf, set BIT(31) to
  *	distinguish between lmac and umac
  * @num_of_registers: num of registers to dump, dword size each
- * @range_data_size: the size of the registers and fifo data
- * @data: fifo data
+ * @range_data_size: the size of the data
+ * @data: consist of
+ *	num_of_registers * (register address + register value) + fifo data
  */
 struct iwl_fw_ini_fifo_error_dump_range {
 	__le32 fifo_num;
-- 
2.20.1

