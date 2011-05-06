Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9464 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab1EFS2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 14:28:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/7] iwlagn: dont update bytecount table for command queue
Date: Fri,  6 May 2011 11:04:38 -0700
Message-Id: <1304705080-29349-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110506_202857_423767_62CB3CFD)
In-Reply-To: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The device doesn't use the bytecount table for the
command queue, only for aggregation queues to make
aggregation decisions. So don't update it for the
command queue (and we even updated it with wrong
values).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   28 +++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-tx.c     |    4 ----
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 494de0e..5445fd6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -112,21 +112,19 @@ void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 
 	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
 
-	if (txq_id != priv->cmd_queue) {
-		sta_id = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
-		sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
-
-		switch (sec_ctl & TX_CMD_SEC_MSK) {
-		case TX_CMD_SEC_CCM:
-			len += CCMP_MIC_LEN;
-			break;
-		case TX_CMD_SEC_TKIP:
-			len += TKIP_ICV_LEN;
-			break;
-		case TX_CMD_SEC_WEP:
-			len += WEP_IV_LEN + WEP_ICV_LEN;
-			break;
-		}
+	sta_id = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
+	sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
+
+	switch (sec_ctl & TX_CMD_SEC_MSK) {
+	case TX_CMD_SEC_CCM:
+		len += CCMP_MIC_LEN;
+		break;
+	case TX_CMD_SEC_TKIP:
+		len += TKIP_ICV_LEN;
+		break;
+	case TX_CMD_SEC_WEP:
+		len += WEP_IV_LEN + WEP_ICV_LEN;
+		break;
 	}
 
 	bc_ent = cpu_to_le16((len & 0xFFF) | (sta_id << 12));
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 517d104..5a7cd17 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -540,10 +540,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 #endif
 	txq->need_update = 1;
 
-	if (priv->cfg->ops->lib->txq_update_byte_cnt_tbl)
-		/* Set up entry in queue's byte count circular buffer */
-		priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq, 0);
-
 	phys_addr = pci_map_single(priv->pci_dev, &out_cmd->hdr,
 				   fix_size, PCI_DMA_BIDIRECTIONAL);
 	dma_unmap_addr_set(out_meta, mapping, phys_addr);
-- 
1.7.0.4

