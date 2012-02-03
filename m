Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab2BCMIa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:08:30 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 25/25] iwlegacy: remove set_hw_params callback
Date: Fri,  3 Feb 2012 13:07:25 +0100
Message-Id: <1328270845-16891-26-git-send-email-sgruszka@redhat.com> (sfid-20120203_130836_585507_A67CD52D)
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not need that callback, settings parameters can be done locally.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   66 +++++++++++++++++++++++---
 drivers/net/wireless/iwlegacy/4965.c     |   76 ------------------------------
 drivers/net/wireless/iwlegacy/common.h   |    2 -
 3 files changed, 59 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 2a52e7b..235812a 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6079,7 +6079,34 @@ il4965_hw_detect(struct il_priv *il)
 	D_INFO("HW Revision ID = 0x%X\n", il->rev_id);
 }
 
-static int
+static struct il_sensitivity_ranges il4965_sensitivity = {
+	.min_nrg_cck = 97,
+	.max_nrg_cck = 0,	/* not used, set to 0 */
+
+	.auto_corr_min_ofdm = 85,
+	.auto_corr_min_ofdm_mrc = 170,
+	.auto_corr_min_ofdm_x1 = 105,
+	.auto_corr_min_ofdm_mrc_x1 = 220,
+
+	.auto_corr_max_ofdm = 120,
+	.auto_corr_max_ofdm_mrc = 210,
+	.auto_corr_max_ofdm_x1 = 140,
+	.auto_corr_max_ofdm_mrc_x1 = 270,
+
+	.auto_corr_min_cck = 125,
+	.auto_corr_max_cck = 200,
+	.auto_corr_min_cck_mrc = 200,
+	.auto_corr_max_cck_mrc = 400,
+
+	.nrg_th_cck = 100,
+	.nrg_th_ofdm = 100,
+
+	.barker_corr_th_min = 190,
+	.barker_corr_th_min_mrc = 390,
+	.nrg_th_cca = 62,
+};
+
+static void
 il4965_set_hw_params(struct il_priv *il)
 {
 	il->hw_params.bcast_id = IL4965_BROADCAST_ID;
@@ -6095,8 +6122,36 @@ il4965_set_hw_params(struct il_priv *il)
 	if (il->cfg->mod_params->disable_11n)
 		il->cfg->sku &= ~IL_SKU_N;
 
-	/* Device-specific setup */
-	return il->ops->lib->set_hw_params(il);
+	if (il->cfg->mod_params->num_of_queues >= IL_MIN_NUM_QUEUES &&
+	    il->cfg->mod_params->num_of_queues <= IL49_NUM_QUEUES)
+		il->cfg->num_of_queues =
+		    il->cfg->mod_params->num_of_queues;
+
+	il->hw_params.max_txq_num = il->cfg->num_of_queues;
+	il->hw_params.dma_chnl_num = FH49_TCSR_CHNL_NUM;
+	il->hw_params.scd_bc_tbls_size =
+	    il->cfg->num_of_queues *
+	    sizeof(struct il4965_scd_bc_tbl);
+
+	il->hw_params.tfd_size = sizeof(struct il_tfd);
+	il->hw_params.max_stations = IL4965_STATION_COUNT;
+	il->hw_params.max_data_size = IL49_RTC_DATA_SIZE;
+	il->hw_params.max_inst_size = IL49_RTC_INST_SIZE;
+	il->hw_params.max_bsm_size = BSM_SRAM_SIZE;
+	il->hw_params.ht40_channel = BIT(IEEE80211_BAND_5GHZ);
+
+	il->hw_params.rx_wrt_ptr_reg = FH49_RSCSR_CHNL0_WPTR;
+
+	il->hw_params.tx_chains_num = il4965_num_of_ant(il->cfg->valid_tx_ant);
+	il->hw_params.rx_chains_num = il4965_num_of_ant(il->cfg->valid_rx_ant);
+	il->hw_params.valid_tx_ant = il->cfg->valid_tx_ant;
+	il->hw_params.valid_rx_ant = il->cfg->valid_rx_ant;
+
+	il->hw_params.ct_kill_threshold =
+	   CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD_LEGACY);
+
+	il->hw_params.sens = &il4965_sensitivity;
+	il->hw_params.beacon_time_tsf_bits = IL4965_EXT_BEACON_TIME_POS;
 }
 
 static int
@@ -6230,10 +6285,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/************************
 	 * 5. Setup HW constants
 	 ************************/
-	if (il4965_set_hw_params(il)) {
-		IL_ERR("failed to set hw parameters\n");
-		goto out_free_eeprom;
-	}
+	il4965_set_hw_params(il);
 
 	/*******************
 	 * 6. Setup il
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 17a6922..79e4e79 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -569,81 +569,6 @@ il4965_chain_noise_reset(struct il_priv *il)
 	}
 }
 
-static struct il_sensitivity_ranges il4965_sensitivity = {
-	.min_nrg_cck = 97,
-	.max_nrg_cck = 0,	/* not used, set to 0 */
-
-	.auto_corr_min_ofdm = 85,
-	.auto_corr_min_ofdm_mrc = 170,
-	.auto_corr_min_ofdm_x1 = 105,
-	.auto_corr_min_ofdm_mrc_x1 = 220,
-
-	.auto_corr_max_ofdm = 120,
-	.auto_corr_max_ofdm_mrc = 210,
-	.auto_corr_max_ofdm_x1 = 140,
-	.auto_corr_max_ofdm_mrc_x1 = 270,
-
-	.auto_corr_min_cck = 125,
-	.auto_corr_max_cck = 200,
-	.auto_corr_min_cck_mrc = 200,
-	.auto_corr_max_cck_mrc = 400,
-
-	.nrg_th_cck = 100,
-	.nrg_th_ofdm = 100,
-
-	.barker_corr_th_min = 190,
-	.barker_corr_th_min_mrc = 390,
-	.nrg_th_cca = 62,
-};
-
-static void
-il4965_set_ct_threshold(struct il_priv *il)
-{
-	/* want Kelvin */
-	il->hw_params.ct_kill_threshold =
-	    CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD_LEGACY);
-}
-
-/**
- * il4965_hw_set_hw_params
- *
- * Called when initializing driver
- */
-static int
-il4965_hw_set_hw_params(struct il_priv *il)
-{
-	if (il->cfg->mod_params->num_of_queues >= IL_MIN_NUM_QUEUES &&
-	    il->cfg->mod_params->num_of_queues <= IL49_NUM_QUEUES)
-		il->cfg->num_of_queues =
-		    il->cfg->mod_params->num_of_queues;
-
-	il->hw_params.max_txq_num = il->cfg->num_of_queues;
-	il->hw_params.dma_chnl_num = FH49_TCSR_CHNL_NUM;
-	il->hw_params.scd_bc_tbls_size =
-	    il->cfg->num_of_queues *
-	    sizeof(struct il4965_scd_bc_tbl);
-	il->hw_params.tfd_size = sizeof(struct il_tfd);
-	il->hw_params.max_stations = IL4965_STATION_COUNT;
-	il->hw_params.max_data_size = IL49_RTC_DATA_SIZE;
-	il->hw_params.max_inst_size = IL49_RTC_INST_SIZE;
-	il->hw_params.max_bsm_size = BSM_SRAM_SIZE;
-	il->hw_params.ht40_channel = BIT(IEEE80211_BAND_5GHZ);
-
-	il->hw_params.rx_wrt_ptr_reg = FH49_RSCSR_CHNL0_WPTR;
-
-	il->hw_params.tx_chains_num = il4965_num_of_ant(il->cfg->valid_tx_ant);
-	il->hw_params.rx_chains_num = il4965_num_of_ant(il->cfg->valid_rx_ant);
-	il->hw_params.valid_tx_ant = il->cfg->valid_tx_ant;
-	il->hw_params.valid_rx_ant = il->cfg->valid_rx_ant;
-
-	il4965_set_ct_threshold(il);
-
-	il->hw_params.sens = &il4965_sensitivity;
-	il->hw_params.beacon_time_tsf_bits = IL4965_EXT_BEACON_TIME_POS;
-
-	return 0;
-}
-
 static s32
 il4965_math_div_round(s32 num, s32 denom, s32 * res)
 {
@@ -2276,7 +2201,6 @@ static struct il_hcmd_utils_ops il4965_hcmd_utils = {
 };
 
 static struct il_lib_ops il4965_lib = {
-	.set_hw_params = il4965_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = il4965_txq_update_byte_cnt_tbl,
 	.txq_attach_buf_to_tfd = il4965_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = il4965_hw_txq_free_tfd,
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 527a1b9..7080956 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1592,8 +1592,6 @@ struct il_temp_ops {
 };
 
 struct il_lib_ops {
-	/* set hw dependent parameters */
-	int (*set_hw_params) (struct il_priv *il);
 	/* Handling TX */
 	void (*txq_update_byte_cnt_tbl) (struct il_priv *il,
 					 struct il_tx_queue *txq,
-- 
1.7.1

