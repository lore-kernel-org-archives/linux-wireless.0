Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18869 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbZAHSSX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:18:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/11] iwl3945: kill iwl3945_rx_queue_restock
Date: Thu,  8 Jan 2009 10:19:53 -0800
Message-Id: <1231438802-10991-3-git-send-email-reinette.chatre@intel.com> (sfid-20090108_191837_117952_DB3E90FE)
In-Reply-To: <1231438802-10991-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1231438802-10991-1-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch kills iwl3945_rx_queue_restock function on prise of new
hw_params.rx_wrt_ptr_reg which holds per NIC RX write pointer register.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 ++-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 -
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   14 ++++----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   50 +-------------------------
 7 files changed, 18 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 502df73..6f27f18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1219,7 +1219,7 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 
 	/* Look at using this instead:
 	rxq->need_update = 1;
-	iwl3945_rx_queue_update_write_ptr(priv, rxq);
+	iwl_rx_queue_update_write_ptr(priv, rxq);
 	*/
 
 	rc = iwl_grab_nic_access(priv);
@@ -2493,6 +2493,8 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_stations = IWL3945_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL3945_BROADCAST_ID;
 
+	priv->hw_params.rx_wrt_ptr_reg = FH39_RSCSR_CHNL0_WPTR;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index c5f5481..3041616 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -225,8 +225,6 @@ extern int __must_check iwl3945_send_cmd(struct iwl_priv *priv,
 					 struct iwl_host_cmd *cmd);
 extern unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,int left);
-extern int iwl3945_rx_queue_update_write_ptr(struct iwl_priv *priv,
-					 struct iwl_rx_queue *q);
 extern int iwl3945_send_statistics_request(struct iwl_priv *priv);
 extern void iwl3945_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
 				   u32 decrypt_res,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e68d587..57efd48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -822,6 +822,8 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_bsm_size = BSM_SRAM_SIZE;
 	priv->hw_params.fat_channel = BIT(IEEE80211_BAND_5GHZ);
 
+	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
+
 	priv->hw_params.tx_chains_num = 2;
 	priv->hw_params.rx_chains_num = 2;
 	priv->hw_params.valid_tx_ant = ANT_A | ANT_B;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 76d86fe..d20d2ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -844,6 +844,8 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_bsm_size = 0;
 	priv->hw_params.fat_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
+	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
+
 	priv->hw_params.sens = &iwl5000_sensitivity;
 
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a092401..fbc4822 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -563,6 +563,7 @@ struct iwl_sensitivity_ranges {
  * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
  * @max_rxq_log: Log-base-2 of max_rxq_size
  * @rx_buf_size: Rx buffer size
+ * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
  * @max_stations:
  * @bcast_sta_id:
  * @fat_channel: is 40MHz width possible in band 2.4
@@ -584,6 +585,7 @@ struct iwl_hw_params {
 	u16 max_rxq_size;
 	u16 max_rxq_log;
 	u32 rx_buf_size;
+	u32 rx_wrt_ptr_reg;
 	u32 max_pkt_size;
 	u8  max_stations;
 	u8  bcast_sta_id;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index bc3febe..60be47f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -125,9 +125,10 @@ EXPORT_SYMBOL(iwl_rx_queue_space);
  */
 int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
 {
-	u32 reg = 0;
-	int ret = 0;
 	unsigned long flags;
+	u32 rx_wrt_ptr_reg = priv->hw_params.rx_wrt_ptr_reg;
+	u32 reg;
+	int ret = 0;
 
 	spin_lock_irqsave(&q->lock, flags);
 
@@ -149,15 +150,14 @@ int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
 			goto exit_unlock;
 
 		/* Device expects a multiple of 8 */
-		iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
-				     q->write & ~0x7);
+		iwl_write_direct32(priv, rx_wrt_ptr_reg, q->write & ~0x7);
 		iwl_release_nic_access(priv);
 
 	/* Else device is assumed to be awake */
-	} else
+	} else {
 		/* Device expects a multiple of 8 */
-		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
-
+		iwl_write32(priv, rx_wrt_ptr_reg, q->write & ~0x7);
+	}
 
 	q->need_update = 0;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5999f45..c39b6d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3225,52 +3225,6 @@ static int iwl3945_rx_queue_space(const struct iwl_rx_queue *q)
 }
 
 /**
- * iwl3945_rx_queue_update_write_ptr - Update the write pointer for the RX queue
- */
-int iwl3945_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q)
-{
-	u32 reg = 0;
-	int rc = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&q->lock, flags);
-
-	if (q->need_update == 0)
-		goto exit_unlock;
-
-	/* If power-saving is in use, make sure device is awake */
-	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
-		reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
-
-		if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
-			iwl_set_bit(priv, CSR_GP_CNTRL,
-				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-			goto exit_unlock;
-		}
-
-		rc = iwl_grab_nic_access(priv);
-		if (rc)
-			goto exit_unlock;
-
-		/* Device expects a multiple of 8 */
-		iwl_write_direct32(priv, FH39_RSCSR_CHNL0_WPTR,
-				     q->write & ~0x7);
-		iwl_release_nic_access(priv);
-
-	/* Else device is assumed to be awake */
-	} else
-		/* Device expects a multiple of 8 */
-		iwl_write32(priv, FH39_RSCSR_CHNL0_WPTR, q->write & ~0x7);
-
-
-	q->need_update = 0;
-
- exit_unlock:
-	spin_unlock_irqrestore(&q->lock, flags);
-	return rc;
-}
-
-/**
  * iwl3945_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
  */
 static inline __le32 iwl3945_dma_addr2rbd_ptr(struct iwl_priv *priv,
@@ -3326,7 +3280,7 @@ static int iwl3945_rx_queue_restock(struct iwl_priv *priv)
 		spin_lock_irqsave(&rxq->lock, flags);
 		rxq->need_update = 1;
 		spin_unlock_irqrestore(&rxq->lock, flags);
-		rc = iwl3945_rx_queue_update_write_ptr(priv, rxq);
+		rc = iwl_rx_queue_update_write_ptr(priv, rxq);
 		if (rc)
 			return rc;
 	}
@@ -4017,7 +3971,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	/* uCode wakes up after power-down sleep */
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR("Wakeup interrupt\n");
-		iwl3945_rx_queue_update_write_ptr(priv, &priv->rxq);
+		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
 		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[0]);
 		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[1]);
 		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[2]);
-- 
1.5.4.3

