Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYLBUNP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/11] iwlwifi: fix DMA channel number in iwl_txq_ctx_stop
Date: Tue,  2 Dec 2008 12:14:04 -0800
Message-Id: <1228248847-10424-9-git-send-email-reinette.chatre@intel.com> (sfid-20081202_213859_822569_33835A05)
In-Reply-To: <1228248847-10424-8-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-4-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-5-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-6-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-7-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

The patch fixes the misuse of DMA channel number by Tx queue number in
iwl_tx_ctx_stop().

The problem was originally reported by Wu Fengguang who complains
iwlagn driver takes too long time when issuing `ifconfig wlan0 down`.
The patch now decreases the interface bring down time from 2 seconds
to 0.8 second.

This fixes bugs:
http://bugzilla.kernel.org/show_bug.cgi?id=11956
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1790

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-tx.c   |   11 +++++------
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f90c9e9..93d3df8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -816,6 +816,7 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.dma_chnl_num = FH49_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
 			IWL49_NUM_QUEUES * sizeof(struct iwl4965_scd_bc_tbl);
 	priv->hw_params.max_stations = IWL4965_STATION_COUNT;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b6c57cb..f7a8df8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -827,6 +827,7 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
 			IWL50_NUM_QUEUES * sizeof(struct iwl5000_scd_bc_tbl);
 	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 846b8b0..5f6805b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -508,6 +508,7 @@ struct iwl_sensitivity_ranges {
 /**
  * struct iwl_hw_params
  * @max_txq_num: Max # Tx queues supported
+ * @dma_chnl_num: Number of Tx DMA/FIFO channels
  * @scd_bc_tbls_size: size of scheduler byte count tables
  * @tx/rx_chains_num: Number of TX/RX chains
  * @valid_tx/rx_ant: usable antennas
@@ -525,7 +526,8 @@ struct iwl_sensitivity_ranges {
  * @struct iwl_sensitivity_ranges: range of sensitivity values
  */
 struct iwl_hw_params {
-	u16 max_txq_num;
+	u8 max_txq_num;
+	u8 dma_chnl_num;
 	u16 scd_bc_tbls_size;
 	u8  tx_chains_num;
 	u8  rx_chains_num;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 9e638c2..6614e67 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -611,7 +611,7 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
  */
 void iwl_txq_ctx_stop(struct iwl_priv *priv)
 {
-	int txq_id;
+	int ch;
 	unsigned long flags;
 
 	/* Turn off all Tx DMA fifos */
@@ -624,12 +624,11 @@ void iwl_txq_ctx_stop(struct iwl_priv *priv)
 	priv->cfg->ops->lib->txq_set_sched(priv, 0);
 
 	/* Stop each Tx DMA channel, and wait for it to be idle */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
-		iwl_write_direct32(priv,
-				   FH_TCSR_CHNL_TX_CONFIG_REG(txq_id), 0x0);
+	for (ch = 0; ch < priv->hw_params.dma_chnl_num; ch++) {
+		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
 		iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS_REG,
-				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE
-				    (txq_id), 200);
+				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
+				    200);
 	}
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.5.4.3

