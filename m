Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42031 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaLBSSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:18:43 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so21845689wiw.16
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:18:42 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/26] iwlwifi: pcie: support more monitor types dumping
Date: Tue,  2 Dec 2014 20:11:16 +0200
Message-Id: <1417543877-24193-25-git-send-email-egrumbach@gmail.com> (sfid-20141202_191847_278642_DBDFC719)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Until this patch, dumping the monitor data could be done only
for PCIe external (DRAM) mode in 7000 HW family. This patch
allows to pull the monitor data also on other families, and
also to pull the monitor data if an internal buffer is used.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 102 +++++++++++++++++++++++-------
 1 file changed, 79 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 71d466c..5d79a1f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2065,6 +2065,7 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 	struct iwl_fw_error_dump_txcmd *txcmd;
 	struct iwl_trans_dump_data *dump_data;
 	u32 len;
+	u32 monitor_len;
 	int i, ptr;
 
 	/* transport dump header */
@@ -2091,9 +2092,30 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 	len += sizeof(*data) + (FH_MEM_UPPER_BOUND - FH_MEM_LOWER_BOUND);
 
 	/* FW monitor */
-	if (trans_pcie->fw_mon_page)
+	if (trans_pcie->fw_mon_page) {
 		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_fw_mon) +
-			trans_pcie->fw_mon_size;
+		       trans_pcie->fw_mon_size;
+		monitor_len = trans_pcie->fw_mon_size;
+	} else if (trans->dbg_dest_tlv) {
+		u32 base, end;
+
+		base = le32_to_cpu(trans->dbg_dest_tlv->base_reg);
+		end = le32_to_cpu(trans->dbg_dest_tlv->end_reg);
+
+		base = iwl_read_prph(trans, base) <<
+		       trans->dbg_dest_tlv->base_shift;
+		end = iwl_read_prph(trans, end) <<
+		      trans->dbg_dest_tlv->end_shift;
+
+		/* Make "end" point to the actual end */
+		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+			end += (1 << trans->dbg_dest_tlv->end_shift);
+		monitor_len = end - base;
+		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_fw_mon) +
+		       monitor_len;
+	} else {
+		monitor_len = 0;
+	}
 
 	dump_data = vzalloc(len);
 	if (!dump_data)
@@ -2133,34 +2155,68 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 	len += iwl_trans_pcie_fh_regs_dump(trans, &data);
 	/* data is already pointing to the next section */
 
-	if (trans_pcie->fw_mon_page) {
+	if ((trans_pcie->fw_mon_page &&
+	     trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) ||
+	    trans->dbg_dest_tlv) {
 		struct iwl_fw_error_dump_fw_mon *fw_mon_data;
+		u32 base, write_ptr, wrap_cnt;
+
+		/* If there was a dest TLV - use the values from there */
+		if (trans->dbg_dest_tlv) {
+			write_ptr =
+				le32_to_cpu(trans->dbg_dest_tlv->write_ptr_reg);
+			wrap_cnt = le32_to_cpu(trans->dbg_dest_tlv->wrap_count);
+			base = le32_to_cpu(trans->dbg_dest_tlv->base_reg);
+		} else {
+			base = MON_BUFF_BASE_ADDR;
+			write_ptr = MON_BUFF_WRPTR;
+			wrap_cnt = MON_BUFF_CYCLE_CNT;
+		}
 
 		data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_FW_MONITOR);
-		data->len = cpu_to_le32(trans_pcie->fw_mon_size +
-					sizeof(*fw_mon_data));
 		fw_mon_data = (void *)data->data;
 		fw_mon_data->fw_mon_wr_ptr =
-			cpu_to_le32(iwl_read_prph(trans, MON_BUFF_WRPTR));
+			cpu_to_le32(iwl_read_prph(trans, write_ptr));
 		fw_mon_data->fw_mon_cycle_cnt =
-			cpu_to_le32(iwl_read_prph(trans, MON_BUFF_CYCLE_CNT));
+			cpu_to_le32(iwl_read_prph(trans, wrap_cnt));
 		fw_mon_data->fw_mon_base_ptr =
-			cpu_to_le32(iwl_read_prph(trans, MON_BUFF_BASE_ADDR));
-
-		/*
-		 * The firmware is now asserted, it won't write anything to
-		 * the buffer. CPU can take ownership to fetch the data.
-		 * The buffer will be handed back to the device before the
-		 * firmware will be restarted.
-		 */
-		dma_sync_single_for_cpu(trans->dev, trans_pcie->fw_mon_phys,
-					trans_pcie->fw_mon_size,
-					DMA_FROM_DEVICE);
-		memcpy(fw_mon_data->data, page_address(trans_pcie->fw_mon_page),
-		       trans_pcie->fw_mon_size);
-
-		len += sizeof(*data) + sizeof(*fw_mon_data) +
-			trans_pcie->fw_mon_size;
+			cpu_to_le32(iwl_read_prph(trans, base));
+
+		len += sizeof(*data) + sizeof(*fw_mon_data);
+		if (trans_pcie->fw_mon_page) {
+			data->len = cpu_to_le32(trans_pcie->fw_mon_size +
+						sizeof(*fw_mon_data));
+
+			/*
+			 * The firmware is now asserted, it won't write anything
+			 * to the buffer. CPU can take ownership to fetch the
+			 * data. The buffer will be handed back to the device
+			 * before the firmware will be restarted.
+			 */
+			dma_sync_single_for_cpu(trans->dev,
+						trans_pcie->fw_mon_phys,
+						trans_pcie->fw_mon_size,
+						DMA_FROM_DEVICE);
+			memcpy(fw_mon_data->data,
+			       page_address(trans_pcie->fw_mon_page),
+			       trans_pcie->fw_mon_size);
+
+			len += trans_pcie->fw_mon_size;
+		} else {
+			/* If we are here then the buffer is internal */
+
+			/*
+			 * Update pointers to reflect actual values after
+			 * shifting
+			 */
+			base = iwl_read_prph(trans, base) <<
+			       trans->dbg_dest_tlv->base_shift;
+			iwl_trans_read_mem(trans, base, fw_mon_data->data,
+					   monitor_len / sizeof(u32));
+			data->len = cpu_to_le32(sizeof(*fw_mon_data) +
+						monitor_len);
+			len += monitor_len;
+		}
 	}
 
 	dump_data->len = len;
-- 
1.9.1

