Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7198C282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4AD82173B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfBGWgn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:36:43 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56606 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726622AbfBGWgn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 17:36:43 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grsHg-0002II-UF; Fri, 08 Feb 2019 00:36:41 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 00:36:12 +0200
Message-Id: <20190207223622.9642-8-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207223622.9642-1-luca@coelho.fi>
References: <20190207223622.9642-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/17] iwlwifi: dbg_ini: implement monitor dram memory dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Implement monitor dram memory dump in the new dump mechanism.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 86 ++++++++++++++++---
 .../wireless/intel/iwlwifi/fw/error-dump.h    | 16 +++-
 2 files changed, 89 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index de6db880d5ce..512af6128fa5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1132,6 +1132,26 @@ static int iwl_dump_ini_paging_iter(struct iwl_fw_runtime *fwrt,
 	return le32_to_cpu(range->range_data_size);
 }
 
+static int
+iwl_dump_ini_mon_dram_iter(struct iwl_fw_runtime *fwrt,
+			   struct iwl_fw_ini_error_dump_range *range,
+			   struct iwl_fw_ini_region_cfg *reg,
+			   int idx)
+{
+	u32 start_addr = iwl_read_prph(fwrt->trans, MON_BUFF_BASE_ADDR_VER2);
+
+	if (start_addr == 0x5a5a5a5a)
+		return -1;
+
+	range->start_addr = cpu_to_le32(start_addr);
+	range->range_data_size = cpu_to_le32(fwrt->trans->fw_mon[idx].size);
+
+	memcpy(range->data, fwrt->trans->fw_mon[idx].block,
+	       fwrt->trans->fw_mon[idx].size);
+
+	return le32_to_cpu(range->range_data_size);
+}
+
 static struct iwl_fw_ini_error_dump_range
 *iwl_dump_ini_mem_fill_header(struct iwl_fw_runtime *fwrt, void *data)
 {
@@ -1140,6 +1160,27 @@ static struct iwl_fw_ini_error_dump_range
 	return dump->ranges;
 }
 
+static struct iwl_fw_ini_error_dump_range
+*iwl_dump_ini_mon_dram_fill_header(struct iwl_fw_runtime *fwrt, void *data)
+{
+	struct iwl_fw_ini_monitor_dram_dump *mon_dump = (void *)data;
+	u32 write_ptr, cycle_cnt;
+	unsigned long flags;
+
+	if (!iwl_trans_grab_nic_access(fwrt->trans, &flags)) {
+		IWL_ERR(fwrt, "Failed to get DRAM monitor header\n");
+		return NULL;
+	}
+	write_ptr = iwl_read_prph_no_grab(fwrt->trans, MON_BUFF_WRPTR_VER2);
+	cycle_cnt = iwl_read_prph_no_grab(fwrt->trans, MON_BUFF_CYCLE_CNT_VER2);
+	iwl_trans_release_nic_access(fwrt->trans, &flags);
+
+	mon_dump->write_ptr = cpu_to_le32(write_ptr);
+	mon_dump->cycle_cnt = cpu_to_le32(cycle_cnt);
+
+	return mon_dump->ranges;
+}
+
 static u32 iwl_dump_ini_mem_get_size(struct iwl_fw_runtime *fwrt,
 				     struct iwl_fw_ini_region_cfg *reg)
 {
@@ -1169,6 +1210,12 @@ static u32 iwl_dump_ini_paging_get_size(struct iwl_fw_runtime *fwrt,
 	return size;
 }
 
+static u32 iwl_dump_ini_mon_dram_get_size(struct iwl_fw_runtime *fwrt,
+					  struct iwl_fw_ini_region_cfg *reg)
+{
+	return fwrt->trans->num_blocks ? fwrt->trans->fw_mon[0].size : 0;
+}
+
 static u32 iwl_dump_ini_mem_ranges(struct iwl_fw_runtime *fwrt,
 				   struct iwl_fw_ini_region_cfg *reg)
 {
@@ -1187,6 +1234,12 @@ static u32 iwl_dump_ini_paging_ranges(struct iwl_fw_runtime *fwrt,
 	return fwrt->num_of_paging_blk;
 }
 
+static u32 iwl_dump_ini_mon_dram_ranges(struct iwl_fw_runtime *fwrt,
+					struct iwl_fw_ini_region_cfg *reg)
+{
+	return 1;
+}
+
 /**
  * struct iwl_dump_ini_mem_ops - ini memory dump operations
  * @get_num_of_ranges: returns the number of memory ranges in the region.
@@ -1312,7 +1365,13 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			break;
 		}
 		case IWL_FW_INI_REGION_DRAM_BUFFER:
-			/* Transport takes care of DRAM dumping */
+			if (!fwrt->trans->num_blocks)
+				break;
+			size += hdr_len +
+				sizeof(struct iwl_fw_ini_monitor_dram_dump) *
+				iwl_dump_ini_mon_dram_ranges(fwrt, reg) +
+				iwl_dump_ini_mon_dram_get_size(fwrt, reg);
+			break;
 		case IWL_FW_INI_REGION_DRAM_IMR:
 			/* Undefined yet */
 		default:
@@ -1324,8 +1383,7 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 
 static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 				    struct iwl_fw_ini_trigger *trigger,
-				    struct iwl_fw_error_dump_data **data,
-				    u32 *dump_mask)
+				    struct iwl_fw_error_dump_data **data)
 {
 	int i, num = le32_to_cpu(trigger->num_regions);
 
@@ -1363,7 +1421,11 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_DRAM_BUFFER:
-			*dump_mask |= BIT(IWL_FW_ERROR_DUMP_FW_MONITOR);
+			ops.get_num_of_ranges = iwl_dump_ini_mon_dram_ranges;
+			ops.get_size = iwl_dump_ini_mon_dram_get_size;
+			ops.fill_mem_hdr = iwl_dump_ini_mon_dram_fill_header;
+			ops.fill_range = iwl_dump_ini_mon_dram_iter;
+			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_PAGING: {
 			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
@@ -1406,8 +1468,7 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 
 static struct iwl_fw_error_dump_file *
 _iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
-		       struct iwl_fw_dump_ptrs *fw_error_dump,
-		       u32 *dump_mask)
+		       struct iwl_fw_dump_ptrs *fw_error_dump)
 {
 	int size, id = le32_to_cpu(fwrt->dump.desc->trig_desc.type);
 	struct iwl_fw_error_dump_data *dump_data;
@@ -1440,11 +1501,10 @@ _iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
 	dump_data = (void *)dump_file->data;
 	dump_file->file_len = cpu_to_le32(size);
 
-	*dump_mask = 0;
 	if (trigger)
-		iwl_fw_ini_dump_trigger(fwrt, trigger, &dump_data, dump_mask);
+		iwl_fw_ini_dump_trigger(fwrt, trigger, &dump_data);
 	if (ext)
-		iwl_fw_ini_dump_trigger(fwrt, ext, &dump_data, dump_mask);
+		iwl_fw_ini_dump_trigger(fwrt, ext, &dump_data);
 
 	return dump_file;
 }
@@ -1470,8 +1530,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 		goto out;
 
 	if (fwrt->trans->ini_valid)
-		dump_file = _iwl_fw_error_ini_dump(fwrt, fw_error_dump,
-						   &dump_mask);
+		dump_file = _iwl_fw_error_ini_dump(fwrt, fw_error_dump);
 	else
 		dump_file = _iwl_fw_error_dump(fwrt, fw_error_dump);
 
@@ -1483,7 +1542,10 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	if (!fwrt->trans->ini_valid && fwrt->dump.monitor_only)
 		dump_mask &= IWL_FW_ERROR_DUMP_FW_MONITOR;
 
-	fw_error_dump->trans_ptr = iwl_trans_dump_data(fwrt->trans, dump_mask);
+	if (!fwrt->trans->ini_valid)
+		fw_error_dump->trans_ptr =
+			iwl_trans_dump_data(fwrt->trans, dump_mask);
+
 	file_len = le32_to_cpu(dump_file->file_len);
 	fw_error_dump->fwrt_len = file_len;
 	if (fw_error_dump->trans_ptr) {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index 42e0c4c93c82..063f2b925808 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -301,7 +301,7 @@ struct iwl_fw_ini_error_dump_header {
 /**
  * struct iwl_fw_ini_error_dump - ini region dump
  * @header: the header of this region
- * @ranges: the memory ranges of this this region
+ * @ranges: the memory ranges of this region
  */
 struct iwl_fw_ini_error_dump {
 	struct iwl_fw_ini_error_dump_header header;
@@ -322,6 +322,20 @@ struct iwl_fw_error_dump_rb {
 	u8 data[];
 };
 
+/**
+ * struct iwl_fw_ini_monitor_dram_dump - ini dram monitor dump
+ * @header - header of the region
+ * @write_ptr - write pointer position in the dram
+ * @cycle_cnt - cycles count
+ * @ranges - the memory ranges of this this region
+ */
+struct iwl_fw_ini_monitor_dram_dump {
+	struct iwl_fw_ini_error_dump_header header;
+	__le32 write_ptr;
+	__le32 cycle_cnt;
+	struct iwl_fw_ini_error_dump_range ranges[];
+} __packed;
+
 /**
  * struct iwl_fw_error_dump_paging - content of the UMAC's image page
  *	block on DRAM
-- 
2.20.1

