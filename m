Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38598 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729568AbeG0OKm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 10:10:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 27 Jul 2018 15:48:27 +0300
Message-Id: <20180727124838.25910-6-luca@coelho.fi> (sfid-20180727_144858_465423_5674A20C)
In-Reply-To: <20180727124838.25910-1-luca@coelho.fi>
References: <20180727124838.25910-1-luca@coelho.fi>
Subject: [PATCH 05/16] iwlwifi: pcie: move rxb retrieval to a helper function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This makes code less indented and more readable.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 75 +++++++++++---------
 1 file changed, 42 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 284946653e27..59bedb461a8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1332,6 +1332,45 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		iwl_pcie_rx_reuse_rbd(trans, rxb, rxq, emergency);
 }
 
+static struct iwl_rx_mem_buffer *iwl_pcie_get_rxb(struct iwl_trans *trans,
+						  struct iwl_rxq *rxq, int i)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_rx_mem_buffer *rxb;
+	u16 vid;
+
+	if (!trans->cfg->mq_rx_supported) {
+		rxb = rxq->queue[i];
+		rxq->queue[i] = NULL;
+		return rxb;
+	}
+
+	/* used_bd is a 32/16 bit but only 12 are used to retrieve the vid */
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
+		vid = le16_to_cpu(rxq->cd[i].rbid) & 0x0FFF;
+	else
+		vid = le32_to_cpu(rxq->bd_32[i]) & 0x0FFF;
+
+	if (!vid || vid > ARRAY_SIZE(trans_pcie->global_table))
+		goto out_err;
+
+	rxb = trans_pcie->global_table[vid - 1];
+	if (rxb->invalid)
+		goto out_err;
+
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
+		rxb->size = le32_to_cpu(rxq->cd[i].size) & IWL_RX_CD_SIZE;
+
+	rxb->invalid = true;
+
+	return rxb;
+
+out_err:
+	WARN(1, "Invalid rxb from HW %u\n", (u32)vid);
+	iwl_force_nmi(trans);
+	return NULL;
+}
+
 /*
  * iwl_pcie_rx_handle - Main entry function for receiving responses from fw
  */
@@ -1362,39 +1401,9 @@ static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 		if (unlikely(rxq->used_count == rxq->queue_size / 2))
 			emergency = true;
 
-		if (trans->cfg->mq_rx_supported) {
-			u16 vid;
-			/*
-			 * used_bd is a 32/16 bit but only 12 are used
-			 * to retrieve the vid
-			 */
-			if (trans->cfg->device_family >=
-			    IWL_DEVICE_FAMILY_22560)
-				vid = le16_to_cpu(rxq->cd[i].rbid) & 0x0FFF;
-			else
-				vid = le32_to_cpu(rxq->bd_32[i]) & 0x0FFF;
-
-			if (WARN(!vid ||
-				 vid > ARRAY_SIZE(trans_pcie->global_table),
-				 "Invalid rxb index from HW %u\n", (u32)vid)) {
-				iwl_force_nmi(trans);
-				goto out;
-			}
-			rxb = trans_pcie->global_table[vid - 1];
-			if (WARN(rxb->invalid,
-				 "Invalid rxb from HW %u\n", (u32)vid)) {
-				iwl_force_nmi(trans);
-				goto out;
-			}
-			if (trans->cfg->device_family >=
-			    IWL_DEVICE_FAMILY_22560)
-				rxb->size = le32_to_cpu(rxq->cd[i].size) &
-					IWL_RX_CD_SIZE;
-			rxb->invalid = true;
-		} else {
-			rxb = rxq->queue[i];
-			rxq->queue[i] = NULL;
-		}
+		rxb = iwl_pcie_get_rxb(trans, rxq, i);
+		if (!rxb)
+			goto out;
 
 		IWL_DEBUG_RX(trans, "Q %d: HW = %d, SW = %d\n", rxq->id, r, i);
 		iwl_pcie_rx_handle_rb(trans, rxq, rxb, emergency);
-- 
2.18.0
