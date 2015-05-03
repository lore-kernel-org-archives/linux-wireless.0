Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbbECTcf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/42] iwlwifi: pcie: support marbh fw dbg mode
Date: Sun,  3 May 2015 22:31:24 +0300
Message-Id: <1430681513-7838-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213418_030349_D3C22617)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

This adds support for configuring and retrieving the FW
monitor in MARBH mode.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h   |  3 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c | 49 ++++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 88a57e6..5af1c77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -348,6 +348,9 @@ enum secure_load_status_reg {
 #define MON_BUFF_WRPTR			(0xa03c44)
 #define MON_BUFF_CYCLE_CNT		(0xa03c48)
 
+#define MON_DMARB_RD_CTL_ADDR		(0xa03c60)
+#define MON_DMARB_RD_DATA_ADDR		(0xa03c5c)
+
 #define DBGC_IN_SAMPLE			(0xa03c00)
 
 /* enable the ID buf for read */
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 47bbf57..d108e5b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -2198,6 +2198,29 @@ static u32 iwl_trans_pcie_fh_regs_dump(struct iwl_trans *trans,
 	return sizeof(**data) + fh_regs_len;
 }
 
+static u32
+iwl_trans_pci_dump_marbh_monitor(struct iwl_trans *trans,
+				 struct iwl_fw_error_dump_fw_mon *fw_mon_data,
+				 u32 monitor_len)
+{
+	u32 buf_size_in_dwords = (monitor_len >> 2);
+	u32 *buffer = (u32 *)fw_mon_data->data;
+	unsigned long flags;
+	u32 i;
+
+	if (!iwl_trans_grab_nic_access(trans, false, &flags))
+		return 0;
+
+	__iwl_write_prph(trans, MON_DMARB_RD_CTL_ADDR, 0x1);
+	for (i = 0; i < buf_size_in_dwords; i++)
+		buffer[i] = __iwl_read_prph(trans, MON_DMARB_RD_DATA_ADDR);
+	__iwl_write_prph(trans, MON_DMARB_RD_CTL_ADDR, 0x0);
+
+	iwl_trans_release_nic_access(trans, &flags);
+
+	return monitor_len;
+}
+
 static
 struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 {
@@ -2250,7 +2273,8 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 		      trans->dbg_dest_tlv->end_shift;
 
 		/* Make "end" point to the actual end */
-		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000 ||
+		    trans->dbg_dest_tlv->monitor_mode == MARBH_MODE)
 			end += (1 << trans->dbg_dest_tlv->end_shift);
 		monitor_len = end - base;
 		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_fw_mon) +
@@ -2326,9 +2350,6 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 
 		len += sizeof(*data) + sizeof(*fw_mon_data);
 		if (trans_pcie->fw_mon_page) {
-			data->len = cpu_to_le32(trans_pcie->fw_mon_size +
-						sizeof(*fw_mon_data));
-
 			/*
 			 * The firmware is now asserted, it won't write anything
 			 * to the buffer. CPU can take ownership to fetch the
@@ -2343,10 +2364,8 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 			       page_address(trans_pcie->fw_mon_page),
 			       trans_pcie->fw_mon_size);
 
-			len += trans_pcie->fw_mon_size;
-		} else {
-			/* If we are here then the buffer is internal */
-
+			monitor_len = trans_pcie->fw_mon_size;
+		} else if (trans->dbg_dest_tlv->monitor_mode == SMEM_MODE) {
 			/*
 			 * Update pointers to reflect actual values after
 			 * shifting
@@ -2355,10 +2374,18 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 			       trans->dbg_dest_tlv->base_shift;
 			iwl_trans_read_mem(trans, base, fw_mon_data->data,
 					   monitor_len / sizeof(u32));
-			data->len = cpu_to_le32(sizeof(*fw_mon_data) +
-						monitor_len);
-			len += monitor_len;
+		} else if (trans->dbg_dest_tlv->monitor_mode == MARBH_MODE) {
+			monitor_len =
+				iwl_trans_pci_dump_marbh_monitor(trans,
+								 fw_mon_data,
+								 monitor_len);
+		} else {
+			/* Didn't match anything - output no monitor data */
+			monitor_len = 0;
 		}
+
+		len += monitor_len;
+		data->len = cpu_to_le32(monitor_len + sizeof(*fw_mon_data));
 	}
 
 	dump_data->len = len;
-- 
2.1.0

