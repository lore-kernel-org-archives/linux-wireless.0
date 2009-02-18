Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbZBRXuY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:50:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 8/8] iwlwifi: dma mapping read and write changes
Date: Wed, 18 Feb 2009 15:54:33 -0800
Message-Id: <1235001273-7808-9-git-send-email-reinette.chatre@intel.com> (sfid-20090219_005041_661908_7F446201)
In-Reply-To: <1235001273-7808-8-git-send-email-reinette.chatre@intel.com>
References: <>
 <1235001273-7808-1-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-2-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-3-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-4-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-5-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-6-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-7-git-send-email-reinette.chatre@intel.com>
 <1235001273-7808-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fenghua Yu <fenghua.yu@intel.com>

When iwlwifi runs on IOMMU, IOMMU generates a lot of PTE write faults
because PTE write bit is not set on some of PTE's. This is because iwlwifi
driver calls DMA mapping with PCI_DMA_TODEVICE which is read only in mapping
PTE. But iwlwifi device actually writes to the mapped page to update its contents.
This issue is not exposed in swiotlb. But VT-d hardware can capture this fault and
stop the fault transaction.

The iwl TX command contains a scratch field that is updated by uCode to
indicate retry counts. For 5000 series the patch is required also for
regular frames, but this patch does not differenciate.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

This patch was posted on lkml: http://lkml.org/lkml/2009/2/11/306

 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c  |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3c053ea..7046ea7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -444,7 +444,7 @@ void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		pci_unmap_single(dev,
 				pci_unmap_addr(&txq->cmd[index]->meta, mapping),
 				pci_unmap_len(&txq->cmd[index]->meta, len),
-				PCI_DMA_TODEVICE);
+				PCI_DMA_BIDIRECTIONAL);
 
 	/* Unmap chunks, if any. */
 	for (i = 1; i < num_tbs; i++) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index ae04c20..dff60fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -819,7 +819,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	 * within command buffer array. */
 	txcmd_phys = pci_map_single(priv->pci_dev,
 				    out_cmd, sizeof(struct iwl_cmd),
-				    PCI_DMA_TODEVICE);
+				    PCI_DMA_BIDIRECTIONAL);
 	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
 	pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iwl_cmd));
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
@@ -968,7 +968,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
 
 	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
-				   len, PCI_DMA_TODEVICE);
+				   len, PCI_DMA_BIDIRECTIONAL);
 	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
 	pci_unmap_len_set(&out_cmd->meta, len, len);
 	phys_addr += offsetof(struct iwl_cmd, hdr);
@@ -1068,7 +1068,7 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id,
 	pci_unmap_single(priv->pci_dev,
 		pci_unmap_addr(&txq->cmd[cmd_idx]->meta, mapping),
 		pci_unmap_len(&txq->cmd[cmd_idx]->meta, len),
-		PCI_DMA_TODEVICE);
+		PCI_DMA_BIDIRECTIONAL);
 
 	for (idx = iwl_queue_inc_wrap(idx, q->n_bd); q->read_ptr != idx;
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
-- 
1.5.4.3

