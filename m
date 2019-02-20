Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D5DC10F01
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7264206DD
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfBTMEP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:04:15 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34540 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727458AbfBTMEO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:04:14 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gwQbj-000411-Jn; Wed, 20 Feb 2019 14:04:12 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 20 Feb 2019 14:03:58 +0200
Message-Id: <20190220120400.8814-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190220120400.8814-1-luca@coelho.fi>
References: <20190220120400.8814-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 6/8] iwlwifi: dbg_ini: implement Rx fifos dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Implement Rx fifos dump in the new dump mechanism.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 133 +++++++++++++++++-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |   3 +
 2 files changed, 134 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 744d831b4dbb..f119c49cd39c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1279,6 +1279,105 @@ static int iwl_dump_ini_txf_iter(struct iwl_fw_runtime *fwrt,
 	return sizeof(*range) + le32_to_cpu(range->range_data_size);
 }
 
+struct iwl_ini_rxf_data {
+	u32 fifo_num;
+	u32 size;
+	u32 offset;
+};
+
+static void iwl_ini_get_rxf_data(struct iwl_fw_runtime *fwrt,
+				 struct iwl_fw_ini_region_cfg *reg,
+				 struct iwl_ini_rxf_data *data)
+{
+	u32 fid1 = le32_to_cpu(reg->fifos.fid1);
+	u32 fid2 = le32_to_cpu(reg->fifos.fid2);
+	u32 fifo_idx;
+
+	if (!data)
+		return;
+
+	memset(data, 0, sizeof(*data));
+
+	if (WARN_ON_ONCE((fid1 && fid2) || (!fid1 && !fid2)))
+		return;
+
+	fifo_idx = ffs(fid1) - 1;
+	if (fid1 && !WARN_ON_ONCE((~BIT(fifo_idx) & fid1) ||
+				  fifo_idx >= MAX_NUM_LMAC)) {
+		data->size = fwrt->smem_cfg.lmac[fifo_idx].rxfifo1_size;
+		data->fifo_num = fifo_idx;
+		return;
+	}
+
+	fifo_idx = ffs(fid2) - 1;
+	if (fid2 && !WARN_ON_ONCE(fifo_idx != 0)) {
+		data->size = fwrt->smem_cfg.rxfifo2_size;
+		data->offset = RXF_DIFF_FROM_PREV;
+		/* use bit 31 to distinguish between umac and lmac rxf while
+		 * parsing the dump
+		 */
+		data->fifo_num = fifo_idx | IWL_RXF_UMAC_BIT;
+		return;
+	}
+}
+
+static int iwl_dump_ini_rxf_iter(struct iwl_fw_runtime *fwrt,
+				 struct iwl_fw_ini_region_cfg *reg,
+				 void *range_ptr, int idx)
+{
+	struct iwl_fw_ini_fifo_error_dump_range *range = range_ptr;
+	struct iwl_ini_rxf_data rxf_data;
+	u32 offs = le32_to_cpu(reg->offset), addr;
+	u32 registers_size =
+		le32_to_cpu(reg->fifos.num_of_registers) * sizeof(__le32);
+	__le32 *val = range->data;
+	unsigned long flags;
+	int i;
+
+	iwl_ini_get_rxf_data(fwrt, reg, &rxf_data);
+	if (!rxf_data.size)
+		return -EIO;
+
+	if (!iwl_trans_grab_nic_access(fwrt->trans, &flags))
+		return -EBUSY;
+
+	offs += rxf_data.offset;
+
+	range->fifo_num = cpu_to_le32(rxf_data.fifo_num);
+	range->num_of_registers = reg->fifos.num_of_registers;
+	range->range_data_size = cpu_to_le32(rxf_data.size + registers_size);
+
+	/* read rxf registers */
+	for (i = 0; i < le32_to_cpu(reg->fifos.num_of_registers); i++) {
+		addr = le32_to_cpu(reg->start_addr[i]) + offs;
+
+		*val++ = cpu_to_le32(iwl_read_prph_no_grab(fwrt->trans, addr));
+	}
+
+	if (reg->fifos.header_only) {
+		range->range_data_size = cpu_to_le32(registers_size);
+		goto out;
+	}
+
+	/* Lock fence */
+	iwl_write_prph_no_grab(fwrt->trans, RXF_SET_FENCE_MODE + offs, 0x1);
+	/* Set fence pointer to the same place like WR pointer */
+	iwl_write_prph_no_grab(fwrt->trans, RXF_LD_WR2FENCE + offs, 0x1);
+	/* Set fence offset */
+	iwl_write_prph_no_grab(fwrt->trans, RXF_LD_FENCE_OFFSET_ADDR + offs,
+			       0x0);
+
+	/* Read FIFO */
+	addr =  RXF_FIFO_RD_FENCE_INC + offs;
+	for (i = 0; i < rxf_data.size; i += sizeof(__le32))
+		*val++ = cpu_to_le32(iwl_read_prph_no_grab(fwrt->trans, addr));
+
+out:
+	iwl_trans_release_nic_access(fwrt->trans, &flags);
+
+	return sizeof(*range) + le32_to_cpu(range->range_data_size);
+}
+
 static void *iwl_dump_ini_mem_fill_header(struct iwl_fw_runtime *fwrt,
 					  struct iwl_fw_ini_region_cfg *reg,
 					  void *data)
@@ -1362,6 +1461,15 @@ static u32 iwl_dump_ini_txf_ranges(struct iwl_fw_runtime *fwrt,
 	return num_of_fifos;
 }
 
+static u32 iwl_dump_ini_rxf_ranges(struct iwl_fw_runtime *fwrt,
+				   struct iwl_fw_ini_region_cfg *reg)
+{
+	/* Each Rx fifo needs a different offset and therefore, it's
+	 * region can contain only one fifo, i.e. 1 memory range.
+	 */
+	return 1;
+}
+
 static u32 iwl_dump_ini_mem_get_size(struct iwl_fw_runtime *fwrt,
 				     struct iwl_fw_ini_region_cfg *reg)
 {
@@ -1433,6 +1541,23 @@ static u32 iwl_dump_ini_txf_get_size(struct iwl_fw_runtime *fwrt,
 	return size;
 }
 
+static u32 iwl_dump_ini_rxf_get_size(struct iwl_fw_runtime *fwrt,
+				     struct iwl_fw_ini_region_cfg *reg)
+{
+	struct iwl_ini_rxf_data rx_data;
+	u32 size = sizeof(struct iwl_fw_ini_fifo_error_dump) +
+		sizeof(struct iwl_fw_ini_fifo_error_dump_range) +
+		le32_to_cpu(reg->fifos.num_of_registers) * sizeof(__le32);
+
+	if (reg->fifos.header_only)
+		return size;
+
+	iwl_ini_get_rxf_data(fwrt, reg, &rx_data);
+	size += rx_data.size;
+
+	return size;
+}
+
 /**
  * struct iwl_dump_ini_mem_ops - ini memory dump operations
  * @get_num_of_ranges: returns the number of memory ranges in the region.
@@ -1539,7 +1664,7 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			size += hdr_len + iwl_dump_ini_txf_get_size(fwrt, reg);
 			break;
 		case IWL_FW_INI_REGION_RXF:
-			size += iwl_fw_rxf_len(fwrt, &fwrt->smem_cfg);
+			size += hdr_len + iwl_dump_ini_rxf_get_size(fwrt, reg);
 			break;
 		case IWL_FW_INI_REGION_PAGING: {
 			size += hdr_len;
@@ -1644,7 +1769,11 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 			break;
 		}
 		case IWL_FW_INI_REGION_RXF:
-			iwl_fw_dump_rxf(fwrt, data);
+			ops.get_num_of_ranges = iwl_dump_ini_rxf_ranges;
+			ops.get_size = iwl_dump_ini_rxf_get_size;
+			ops.fill_mem_hdr = iwl_dump_ini_fifo_fill_header;
+			ops.fill_range = iwl_dump_ini_rxf_iter;
+			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_CSR:
 			ops.get_num_of_ranges =	iwl_dump_ini_mem_ranges;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index 2cc4f13d0abb..9b5077bd46c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -308,6 +308,9 @@ struct iwl_fw_ini_error_dump {
 	struct iwl_fw_ini_error_dump_range ranges[];
 } __packed;
 
+/* This bit is used to differentiate between lmac and umac rxf */
+#define IWL_RXF_UMAC_BIT BIT(31)
+
 /**
  * struct iwl_fw_ini_fifo_error_dump_range - ini fifo range dump
  * @fifo_num: the fifo num. In case of rxf and umac rxf, set BIT(31) to
-- 
2.20.1

