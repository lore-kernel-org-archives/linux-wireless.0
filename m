Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:18946 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761382AbZJIUWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:22:40 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/17] iwlwifi: dynamic allocate tx queue structure
Date: Fri,  9 Oct 2009 13:20:28 -0700
Message-Id: <1255119634-3060-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Instead of always allocate the max number of tx queue structure,
use dynamic allocation based on the number of queues in device
configuration. With these changes, device does not have to allocate more
memory than the h/w can support.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    4 ++
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   23 +++++++++++----
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   33 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   42 +++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   36 +++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   21 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   12 ++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   22 ++++++++++----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 11 files changed, 144 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 1fc3814..a00f947 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -158,6 +158,8 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
@@ -179,6 +181,8 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 4e15a8e..314cae7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -958,6 +958,11 @@ static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 
 	iwl3945_hw_txq_ctx_free(priv);
 
+	/* allocate tx queue structure */
+	rc = iwl_alloc_txq_mem(priv);
+	if (rc)
+		return rc;
+
 	/* Tx CMD queue */
 	rc = iwl3945_tx_reset(priv);
 	if (rc)
@@ -1170,12 +1175,16 @@ void iwl3945_hw_txq_ctx_free(struct iwl_priv *priv)
 	int txq_id;
 
 	/* Tx queues */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-		if (txq_id == IWL_CMD_QUEUE_NUM)
-			iwl_cmd_queue_free(priv);
-		else
-			iwl_tx_queue_free(priv, txq_id);
+	if (priv->txq)
+		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num;
+		     txq_id++)
+			if (txq_id == IWL_CMD_QUEUE_NUM)
+				iwl_cmd_queue_free(priv);
+			else
+				iwl_tx_queue_free(priv, txq_id);
 
+	/* free tx queue structure */
+	iwl_free_txq_mem(priv);
 }
 
 void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
@@ -2503,7 +2512,7 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	/* Assign number of Usable TX queues */
-	priv->hw_params.max_txq_num = IWL39_NUM_QUEUES;
+	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
 
 	priv->hw_params.tfd_size = sizeof(struct iwl3945_tfd);
 	priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_3K;
@@ -2838,6 +2847,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.eeprom_size = IWL3945_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.ops = &iwl3945_ops,
+	.num_of_queues = IWL39_NUM_QUEUES,
 	.mod_params = &iwl3945_mod_params,
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
@@ -2853,6 +2863,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.eeprom_size = IWL3945_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.ops = &iwl3945_ops,
+	.num_of_queues = IWL39_NUM_QUEUES,
 	.mod_params = &iwl3945_mod_params,
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9668585..c9d9016 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -62,8 +62,6 @@ static int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 
 /* module parameters */
 static struct iwl_mod_params iwl4965_mod_params = {
-	.num_of_queues = IWL49_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL49_NUM_AMPDU_QUEUES,
 	.amsdu_size_8K = 1,
 	.restart_fw = 1,
 	/* the rest are 0 by default */
@@ -698,19 +696,16 @@ static void iwl4965_set_ct_threshold(struct iwl_priv *priv)
  */
 static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 {
+	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
+	    priv->cfg->mod_params->num_of_queues <= IWL49_NUM_QUEUES)
+		priv->cfg->num_of_queues =
+			priv->cfg->mod_params->num_of_queues;
 
-	if ((priv->cfg->mod_params->num_of_queues > IWL49_NUM_QUEUES) ||
-	    (priv->cfg->mod_params->num_of_queues < IWL_MIN_NUM_QUEUES)) {
-		IWL_ERR(priv,
-			"invalid queues_num, should be between %d and %d\n",
-			IWL_MIN_NUM_QUEUES, IWL49_NUM_QUEUES);
-		return -EINVAL;
-	}
-
-	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH49_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
-			IWL49_NUM_QUEUES * sizeof(struct iwl4965_scd_bc_tbl);
+			priv->cfg->num_of_queues *
+			sizeof(struct iwl4965_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWL4965_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL4965_BROADCAST_ID;
@@ -1739,11 +1734,13 @@ static int iwl4965_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 				   u16 ssn_idx, u8 tx_fifo)
 {
 	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES <= txq_id)) {
+	    (IWL49_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
+	     <= txq_id)) {
 		IWL_WARN(priv,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL49_FIRST_AMPDU_QUEUE,
-			IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES - 1);
+			IWL49_FIRST_AMPDU_QUEUE +
+			priv->cfg->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
 
@@ -1804,11 +1801,13 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	u16 ra_tid;
 
 	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES <= txq_id)) {
+	    (IWL49_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
+	     <= txq_id)) {
 		IWL_WARN(priv,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL49_FIRST_AMPDU_QUEUE,
-			IWL49_FIRST_AMPDU_QUEUE + IWL49_NUM_AMPDU_QUEUES - 1);
+			IWL49_FIRST_AMPDU_QUEUE +
+			priv->cfg->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
 
@@ -2286,6 +2285,8 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_4965_TX_POWER_VERSION,
 	.ops = &iwl4965_ops,
+	.num_of_queues = IWL49_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL49_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl4965_mod_params,
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a9d1aa3..ab5b9d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -749,18 +749,16 @@ int iwl5000_alive_notify(struct iwl_priv *priv)
 
 int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	if ((priv->cfg->mod_params->num_of_queues > IWL50_NUM_QUEUES) ||
-	    (priv->cfg->mod_params->num_of_queues < IWL_MIN_NUM_QUEUES)) {
-		IWL_ERR(priv,
-			"invalid queues_num, should be between %d and %d\n",
-			IWL_MIN_NUM_QUEUES, IWL50_NUM_QUEUES);
-		return -EINVAL;
-	}
+	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
+	    priv->cfg->mod_params->num_of_queues <= IWL50_NUM_QUEUES)
+		priv->cfg->num_of_queues =
+			priv->cfg->mod_params->num_of_queues;
 
-	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
-			IWL50_NUM_QUEUES * sizeof(struct iwl5000_scd_bc_tbl);
+			priv->cfg->num_of_queues *
+			sizeof(struct iwl5000_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
@@ -912,11 +910,13 @@ int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	u16 ra_tid;
 
 	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES <= txq_id)) {
+	    (IWL50_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
+	     <= txq_id)) {
 		IWL_WARN(priv,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL50_FIRST_AMPDU_QUEUE,
-			IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES - 1);
+			IWL50_FIRST_AMPDU_QUEUE +
+			priv->cfg->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
 
@@ -970,11 +970,13 @@ int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 				   u16 ssn_idx, u8 tx_fifo)
 {
 	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES <= txq_id)) {
+	    (IWL50_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
+	     <= txq_id)) {
 		IWL_ERR(priv,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL50_FIRST_AMPDU_QUEUE,
-			IWL50_FIRST_AMPDU_QUEUE + IWL50_NUM_AMPDU_QUEUES - 1);
+			IWL50_FIRST_AMPDU_QUEUE +
+			priv->cfg->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
 
@@ -1584,8 +1586,6 @@ static struct iwl_ops iwl5150_ops = {
 };
 
 struct iwl_mod_params iwl50_mod_params = {
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.amsdu_size_8K = 1,
 	.restart_fw = 1,
 	/* the rest are 0 by default */
@@ -1602,6 +1602,8 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
@@ -1621,6 +1623,8 @@ struct iwl_cfg iwl5100_bg_cfg = {
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
@@ -1640,6 +1644,8 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
@@ -1659,6 +1665,8 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
@@ -1678,6 +1686,8 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
@@ -1697,6 +1707,8 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index dda1dd6..bdc1c74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -129,18 +129,16 @@ static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 
 static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	if ((priv->cfg->mod_params->num_of_queues > IWL50_NUM_QUEUES) ||
-	    (priv->cfg->mod_params->num_of_queues < IWL_MIN_NUM_QUEUES)) {
-		IWL_ERR(priv,
-			"invalid queues_num, should be between %d and %d\n",
-			IWL_MIN_NUM_QUEUES, IWL50_NUM_QUEUES);
-		return -EINVAL;
-	}
+	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
+	    priv->cfg->mod_params->num_of_queues <= IWL50_NUM_QUEUES)
+		priv->cfg->num_of_queues =
+			priv->cfg->mod_params->num_of_queues;
 
-	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
-			IWL50_NUM_QUEUES * sizeof(struct iwl5000_scd_bc_tbl);
+			priv->cfg->num_of_queues *
+			sizeof(struct iwl5000_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
@@ -248,6 +246,8 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
@@ -272,6 +272,8 @@ struct iwl_cfg iwl6000h_2abg_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
@@ -295,6 +297,8 @@ struct iwl_cfg iwl6000h_2bg_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
@@ -321,6 +325,8 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
@@ -345,6 +351,8 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
@@ -368,6 +376,8 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
@@ -391,6 +401,8 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
@@ -415,6 +427,8 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
@@ -438,6 +452,8 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
@@ -462,6 +478,8 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index dc7fd87..c40c7e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2826,6 +2826,27 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(iwl_mac_reset_tsf);
 
+int iwl_alloc_txq_mem(struct iwl_priv *priv)
+{
+	if (!priv->txq)
+		priv->txq = kzalloc(
+			sizeof(struct iwl_tx_queue) * priv->cfg->num_of_queues,
+			GFP_KERNEL);
+	if (!priv->txq) {
+		IWL_ERR(priv, "Not enough memory for txq \n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(iwl_alloc_txq_mem);
+
+void iwl_free_txq_mem(struct iwl_priv *priv)
+{
+	kfree(priv->txq);
+	priv->txq = NULL;
+}
+EXPORT_SYMBOL(iwl_free_txq_mem);
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 
 #define IWL_TRAFFIC_DUMP_SIZE	(IWL_TRAFFIC_ENTRY_SIZE * IWL_TRAFFIC_ENTRIES)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 447eb64..3679c2c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -204,7 +204,6 @@ struct iwl_mod_params {
 	int sw_crypto;		/* def: 0 = using hardware encryption */
 	int disable_hw_scan;	/* def: 0 = use h/w scan */
 	int num_of_queues;	/* def: HW dependent */
-	int num_of_ampdu_queues;/* def: HW dependent */
 	int disable_11n;	/* def: 0 = 11n capabilities enabled */
 	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
 	int antenna;  		/* def: 0 = both antennas (use diversity) */
@@ -257,6 +256,8 @@ struct iwl_cfg {
 	int eeprom_size;
 	u16  eeprom_ver;
 	u16  eeprom_calib_ver;
+	int num_of_queues;	/* def: HW dependent */
+	int num_of_ampdu_queues;/* def: HW dependent */
 	const struct iwl_ops *ops;
 	const struct iwl_mod_params *mod_params;
 	u8   valid_tx_ant;
@@ -326,6 +327,8 @@ void iwl_config_ap(struct iwl_priv *priv);
 int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
 			 struct ieee80211_tx_queue_stats *stats);
 void iwl_mac_reset_tsf(struct ieee80211_hw *hw);
+int iwl_alloc_txq_mem(struct iwl_priv *priv);
+void iwl_free_txq_mem(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 void iwl_free_traffic_mem(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index aa62357..028d4bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -884,10 +884,14 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	char *buf;
 	int bufsz = ((IWL_TRAFFIC_ENTRIES * IWL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
-		(IWL_MAX_NUM_QUEUES * 32 * 8) + 400;
+		(priv->cfg->num_of_queues * 32 * 8) + 400;
 	const u8 *ptr;
 	ssize_t ret;
 
+	if (!priv->txq) {
+		IWL_ERR(priv, "txq not ready\n");
+		return -EAGAIN;
+	}
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf) {
 		IWL_ERR(priv, "Can not allocate buffer\n");
@@ -979,8 +983,12 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	int pos = 0;
 	int cnt;
 	int ret;
-	const size_t bufsz = sizeof(char) * 60 * IWL_MAX_NUM_QUEUES;
+	const size_t bufsz = sizeof(char) * 60 * priv->cfg->num_of_queues;
 
+	if (!priv->txq) {
+		IWL_ERR(priv, "txq not ready\n");
+		return -EAGAIN;
+	}
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c1b07e2..6d7c235 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -974,8 +974,6 @@ struct traffic_stats {
 };
 #endif
 
-#define IWL_MAX_NUM_QUEUES	20 /* FIXME: do dynamic allocation */
-
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
@@ -1103,7 +1101,7 @@ struct iwl_priv {
 
 	/* Rx and Tx DMA processing queues */
 	struct iwl_rx_queue rxq;
-	struct iwl_tx_queue txq[IWL_MAX_NUM_QUEUES];
+	struct iwl_tx_queue *txq;
 	unsigned long txq_ctx_active_msk;
 	struct iwl_dma_ptr  kw;	/* keep warm address */
 	struct iwl_dma_ptr  scd_bc_tbls;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index c832ba0..625da63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -405,15 +405,19 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
 	int txq_id;
 
 	/* Tx queues */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-		if (txq_id == IWL_CMD_QUEUE_NUM)
-			iwl_cmd_queue_free(priv);
-		else
-			iwl_tx_queue_free(priv, txq_id);
-
+	if (priv->txq)
+		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num;
+		     txq_id++)
+			if (txq_id == IWL_CMD_QUEUE_NUM)
+				iwl_cmd_queue_free(priv);
+			else
+				iwl_tx_queue_free(priv, txq_id);
 	iwl_free_dma_ptr(priv, &priv->kw);
 
 	iwl_free_dma_ptr(priv, &priv->scd_bc_tbls);
+
+	/* free tx queue structure */
+	iwl_free_txq_mem(priv);
 }
 EXPORT_SYMBOL(iwl_hw_txq_ctx_free);
 
@@ -445,6 +449,12 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 		IWL_ERR(priv, "Keep Warm allocation failed\n");
 		goto error_kw;
 	}
+
+	/* allocate tx queue structure */
+	ret = iwl_alloc_txq_mem(priv);
+	if (ret)
+		goto error;
+
 	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Turn off all Tx DMA fifos */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e0e566c..66da441 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -88,7 +88,6 @@ MODULE_LICENSE("GPL");
 
  /* module parameters */
 struct iwl_mod_params iwl3945_mod_params = {
-	.num_of_queues = IWL39_NUM_QUEUES, /* Not used */
 	.sw_crypto = 1,
 	.restart_fw = 1,
 	/* the rest are 0 by default */
-- 
1.5.6.3

