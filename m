Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60836 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751164AbdFBL05 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:26:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:47 +0300
Message-Id: <20170602112553.2466-20-luca@coelho.fi> (sfid-20170602_132701_217316_845A593E)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 19/25] iwlwifi: pcie: support page dumping in wrt in gen2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In gen2, page dumping needs to be done in the trans
layer, as it is the one with access to the paging
pointers.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 29 +++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 70acf850a9f1..85f44d8f1c41 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2754,6 +2754,13 @@ static struct iwl_trans_dump_data
 				  (PAGE_SIZE << trans_pcie->rx_page_order));
 	}
 
+	/* Paged memory for gen2 HW */
+	if (trans->cfg->gen2)
+		for (i = 0; i < trans_pcie->init_dram.paging_cnt; i++)
+			len += sizeof(*data) +
+			       sizeof(struct iwl_fw_error_dump_paging) +
+			       trans_pcie->init_dram.paging[i].size;
+
 	dump_data = vzalloc(len);
 	if (!dump_data)
 		return NULL;
@@ -2793,6 +2800,28 @@ static struct iwl_trans_dump_data
 	if (dump_rbs)
 		len += iwl_trans_pcie_dump_rbs(trans, &data, num_rbs);
 
+	/* Paged memory for gen2 HW */
+	if (trans->cfg->gen2) {
+		for (i = 0; i < trans_pcie->init_dram.paging_cnt; i++) {
+			struct iwl_fw_error_dump_paging *paging;
+			dma_addr_t addr =
+				trans_pcie->init_dram.paging[i].physical;
+			u32 page_len = trans_pcie->init_dram.paging[i].size;
+
+			data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PAGING);
+			data->len = cpu_to_le32(sizeof(*paging) + page_len);
+			paging = (void *)data->data;
+			paging->index = cpu_to_le32(i);
+			dma_sync_single_for_cpu(trans->dev, addr, page_len,
+						DMA_BIDIRECTIONAL);
+			memcpy(paging->data,
+			       trans_pcie->init_dram.paging[i].block, page_len);
+			data = iwl_fw_error_next_data(data);
+
+			len += sizeof(*data) + sizeof(*paging) + page_len;
+		}
+	}
+
 	len += iwl_trans_pcie_dump_monitor(trans, &data, monitor_len);
 
 	dump_data->len = len;
-- 
2.11.0
