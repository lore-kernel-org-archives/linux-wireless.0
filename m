Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38590 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730709AbeG0OKl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 10:10:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 27 Jul 2018 15:48:26 +0300
Message-Id: <20180727124838.25910-5-luca@coelho.fi> (sfid-20180727_144857_903764_6FCBE6B7)
In-Reply-To: <20180727124838.25910-1-luca@coelho.fi>
References: <20180727124838.25910-1-luca@coelho.fi>
Subject: [PATCH 04/16] iwlwifi: pcie: unionize used bd and completion descriptor
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This allows less "dummy" declarations and casting.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/pcie/internal.h    |  6 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 32 +++++--------------
 2 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 90e8a47c8bda..f6726ccef819 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -235,7 +235,11 @@ struct iwl_rxq {
 	int id;
 	void *bd;
 	dma_addr_t bd_dma;
-	void *used_bd;
+	union {
+		void *used_bd;
+		__le32 *bd_32;
+		struct iwl_rx_completion_desc *cd;
+	};
 	dma_addr_t used_bd_dma;
 	__le16 *tr_tail;
 	dma_addr_t tr_tail_dma;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 78e7e2d5d290..284946653e27 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -649,7 +649,6 @@ static void iwl_pcie_free_rxq_dma(struct iwl_trans *trans,
 				  struct iwl_rxq *rxq)
 {
 	struct device *dev = trans->dev;
-	struct iwl_rx_completion_desc *rx_cd;
 	bool use_rx_td = (trans->cfg->device_family >=
 			  IWL_DEVICE_FAMILY_22560);
 	int free_size = iwl_pcie_free_bd_size(trans, use_rx_td);
@@ -671,7 +670,7 @@ static void iwl_pcie_free_rxq_dma(struct iwl_trans *trans,
 
 	if (rxq->used_bd)
 		dma_free_coherent(trans->dev,
-				  (use_rx_td ? sizeof(*rx_cd) :
+				  (use_rx_td ? sizeof(*rxq->cd) :
 				   sizeof(__le32)) * rxq->queue_size,
 				  rxq->used_bd, rxq->used_bd_dma);
 	rxq->used_bd_dma = 0;
@@ -698,7 +697,6 @@ static int iwl_pcie_alloc_rxq_dma(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct device *dev = trans->dev;
-	struct iwl_rx_completion_desc *rx_cd;
 	int i;
 	int free_size;
 	bool use_rx_td = (trans->cfg->device_family >=
@@ -725,7 +723,7 @@ static int iwl_pcie_alloc_rxq_dma(struct iwl_trans *trans,
 	if (trans->cfg->mq_rx_supported) {
 		rxq->used_bd = dma_zalloc_coherent(dev,
 						   (use_rx_td ?
-						   sizeof(*rx_cd) :
+						   sizeof(*rxq->cd) :
 						   sizeof(__le32)) *
 						   rxq->queue_size,
 						   &rxq->used_bd_dma,
@@ -1371,18 +1369,10 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 			 * to retrieve the vid
 			 */
 			if (trans->cfg->device_family >=
-			    IWL_DEVICE_FAMILY_22560) {
-				struct iwl_rx_completion_desc *rx_cd =
-					&((struct iwl_rx_completion_desc *)
-					  rxq->used_bd)[i];
-
-				vid = le16_to_cpu(rx_cd->rbid) & 0x0FFF;
-			} else {
-				__le32 *used =
-					&((__le32 *)rxq->used_bd)[i];
-
-				vid = le32_to_cpu(*used) & 0x0FFF;
-			}
+			    IWL_DEVICE_FAMILY_22560)
+				vid = le16_to_cpu(rxq->cd[i].rbid) & 0x0FFF;
+			else
+				vid = le32_to_cpu(rxq->bd_32[i]) & 0x0FFF;
 
 			if (WARN(!vid ||
 				 vid > ARRAY_SIZE(trans_pcie->global_table),
@@ -1397,15 +1387,9 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 				goto out;
 			}
 			if (trans->cfg->device_family >=
-			    IWL_DEVICE_FAMILY_22560) {
-				struct iwl_rx_completion_desc *rx_cd =
-					&((struct iwl_rx_completion_desc *)
-					  rxq->used_bd)[i];
-
-				rxb->size = le32_to_cpu(rx_cd->size) &
+			    IWL_DEVICE_FAMILY_22560)
+				rxb->size = le32_to_cpu(rxq->cd[i].size) &
 					IWL_RX_CD_SIZE;
-			}
-
 			rxb->invalid = true;
 		} else {
 			rxb = rxq->queue[i];
-- 
2.18.0
