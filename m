Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2971 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454Ab1D3Qks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/14] iwlagn: mod param cleanup
Date: Sat, 30 Apr 2011 09:17:35 -0700
Message-Id: <1304180260-13875-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184110_720547_1A8B3489)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

All agn devices use the same module parameter structure.  Delete the
indirection and access the structure diretly.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    8 +++-----
 drivers/net/wireless/iwlwifi/iwl-2000.c     |   10 +++-------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   15 ++++++---------
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   12 +++---------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 --
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    7 +++----
 10 files changed, 27 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index baf8011..d2b1be6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -121,10 +121,10 @@ static struct iwl_sensitivity_ranges iwl1000_sensitivity = {
 
 static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
+	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
+	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
 		priv->cfg->base_params->num_of_queues =
-			priv->cfg->mod_params->num_of_queues;
+			iwlagn_mod_params.num_of_queues;
 
 	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
@@ -249,7 +249,6 @@ static struct iwl_ht_params iwl1000_ht_params = {
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
 	.ops = &iwl1000_ops,					\
-	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl1000_base_params,			\
 	.led_mode = IWL_LED_BLINK
 
@@ -271,7 +270,6 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
 	.ops = &iwl1000_ops,					\
-	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl1000_base_params,			\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.rx_with_siso_diversity = true
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index f90d6af..476150f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -128,10 +128,10 @@ static struct iwl_sensitivity_ranges iwl2000_sensitivity = {
 
 static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
+	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
+	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
 		priv->cfg->base_params->num_of_queues =
-			priv->cfg->mod_params->num_of_queues;
+			iwlagn_mod_params.num_of_queues;
 
 	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
@@ -383,7 +383,6 @@ static struct iwl_bt_params iwl2030_bt_params = {
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.ops = &iwl2000_ops,					\
-	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl2000_base_params,			\
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
@@ -409,7 +408,6 @@ struct iwl_cfg iwl2000_2bg_cfg = {
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.ops = &iwl2030_ops,					\
-	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
 	.need_dc_calib = true,					\
@@ -436,7 +434,6 @@ struct iwl_cfg iwl2030_2bg_cfg = {
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.ops = &iwl105_ops,					\
-	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl2000_base_params,			\
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
@@ -462,7 +459,6 @@ struct iwl_cfg iwl105_bgn_cfg = {
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.ops = &iwl135_ops,					\
-	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
 	.need_dc_calib = true,					\
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 655afc1..969c91a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -165,10 +165,10 @@ static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
 
 static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
+	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
+	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
 		priv->cfg->base_params->num_of_queues =
-			priv->cfg->mod_params->num_of_queues;
+			iwlagn_mod_params.num_of_queues;
 
 	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
@@ -210,10 +210,10 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 {
-	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
+	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
+	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
 		priv->cfg->base_params->num_of_queues =
-			priv->cfg->mod_params->num_of_queues;
+			iwlagn_mod_params.num_of_queues;
 
 	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
@@ -468,7 +468,6 @@ static struct iwl_ht_params iwl5000_ht_params = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,	\
 	.ops = &iwl5000_ops,					\
-	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl5000_base_params,			\
 	.led_mode = IWL_LED_BLINK
 
@@ -512,7 +511,6 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.ops = &iwl5000_ops,
-	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl5000_base_params,
 	.ht_params = &iwl5000_ht_params,
 	.led_mode = IWL_LED_BLINK,
@@ -526,7 +524,6 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,	\
 	.ops = &iwl5150_ops,					\
-	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl5000_base_params,			\
 	.need_dc_calib = true,					\
 	.led_mode = IWL_LED_BLINK,				\
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 905eb57..91edb57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -154,10 +154,10 @@ static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 
 static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
+	if (iwlagn_mod_params.num_of_queues >= IWL_MIN_NUM_QUEUES &&
+	    iwlagn_mod_params.num_of_queues <= IWLAGN_NUM_QUEUES)
 		priv->cfg->base_params->num_of_queues =
-			priv->cfg->mod_params->num_of_queues;
+			iwlagn_mod_params.num_of_queues;
 
 	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
@@ -482,7 +482,6 @@ static struct iwl_bt_params iwl6000_bt_params = {
 	.eeprom_ver = EEPROM_6005_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
 	.ops = &iwl6000_ops,					\
-	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl6000_g2_base_params,			\
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
@@ -511,7 +510,6 @@ struct iwl_cfg iwl6005_2bg_cfg = {
 	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
 	.ops = &iwl6030_ops,					\
-	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl6000_g2_base_params,			\
 	.bt_params = &iwl6000_bt_params,			\
 	.need_dc_calib = true,					\
@@ -593,7 +591,6 @@ struct iwl_cfg iwl130_bg_cfg = {
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,	\
 	.ops = &iwl6000_ops,					\
-	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl6000_base_params,			\
 	.pa_type = IWL_PA_INTERNAL,				\
 	.led_mode = IWL_LED_BLINK
@@ -623,7 +620,6 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.ops = &iwl6050_ops,					\
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,	\
-	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl6050_base_params,			\
 	.need_dc_calib = true,					\
 	.led_mode = IWL_LED_BLINK,				\
@@ -648,7 +644,6 @@ struct iwl_cfg iwl6150_bgn_cfg = {
 	.eeprom_ver = EEPROM_6150_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6150_TX_POWER_VERSION,
 	.ops = &iwl6150_ops,
-	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl6050_base_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
@@ -664,7 +659,6 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.ops = &iwl6000_ops,
-	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl6000_base_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 7fe9e0f..8e79653 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -665,7 +665,7 @@ int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 
 	rb_timeout = RX_RB_TIMEOUT;
 
-	if (priv->cfg->mod_params->amsdu_size_8K)
+	if (iwlagn_mod_params.amsdu_size_8K)
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
 	else
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 178b2b5..0238743 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -372,7 +372,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			return ret;
 	}
 
-	iwl_set_rxon_hwcrypto(priv, ctx, !priv->cfg->mod_params->sw_crypto);
+	iwl_set_rxon_hwcrypto(priv, ctx, !iwlagn_mod_params.sw_crypto);
 
 	IWL_DEBUG_INFO(priv,
 		       "Going to commit RXON\n"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8232245..003d524 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2834,7 +2834,7 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	if (priv->cfg->mod_params->sw_crypto) {
+	if (iwlagn_mod_params.sw_crypto) {
 		IWL_DEBUG_MAC80211(priv, "leave - hwcrypto disabled\n");
 		return -EOPNOTSUPP;
 	}
@@ -3522,14 +3522,14 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 {
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
-	if (priv->cfg->mod_params->amsdu_size_8K)
+	if (iwlagn_mod_params.amsdu_size_8K)
 		priv->hw_params.rx_page_order = get_order(IWL_RX_BUF_SIZE_8K);
 	else
 		priv->hw_params.rx_page_order = get_order(IWL_RX_BUF_SIZE_4K);
 
 	priv->hw_params.max_beacon_itrvl = IWL_MAX_UCODE_BEACON_INTERVAL;
 
-	if (priv->cfg->mod_params->disable_11n)
+	if (iwlagn_mod_params.disable_11n)
 		priv->cfg->sku &= ~IWL_SKU_N;
 
 	/* Device-specific setup */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 66da1de..1b2a7d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -41,6 +41,7 @@
 #include "iwl-power.h"
 #include "iwl-sta.h"
 #include "iwl-helpers.h"
+#include "iwl-agn.h"
 
 
 /*
@@ -94,7 +95,7 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 		max_bit_rate = MAX_BIT_RATE_40_MHZ;
 	}
 
-	if (priv->cfg->mod_params->amsdu_size_8K)
+	if (iwlagn_mod_params.amsdu_size_8K)
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
 	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
@@ -926,7 +927,7 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	}
 
 	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		if (priv->cfg->mod_params->restart_fw) {
+		if (iwlagn_mod_params.restart_fw) {
 			IWL_DEBUG(priv, IWL_DL_FW_ERRORS,
 				  "Restarting adapter due to uCode error.\n");
 			queue_work(priv->workqueue, &priv->restart);
@@ -1747,7 +1748,7 @@ int iwl_force_reset(struct iwl_priv *priv, int mode, bool external)
 		 * detect failure), then fw_restart module parameter
 		 * need to be check before performing firmware reload
 		 */
-		if (!external && !priv->cfg->mod_params->restart_fw) {
+		if (!external && !iwlagn_mod_params.restart_fw) {
 			IWL_DEBUG_INFO(priv, "Cancel firmware reload based on "
 				       "module parameter setting\n");
 			break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4cdb85d..ca6bd07 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -325,8 +325,6 @@ struct iwl_cfg {
 	u16  eeprom_ver;
 	u16  eeprom_calib_ver;
 	const struct iwl_ops *ops;
-	/* module based parameters which can be set from modprobe cmd */
-	const struct iwl_mod_params *mod_params;
 	/* params not likely to change within a device family */
 	struct iwl_base_params *base_params;
 	/* params likely to change within a device family */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index aca9a1d..0053e9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -433,7 +433,6 @@ static void iwl_recover_from_statistics(struct iwl_priv *priv,
 					struct statistics_tx *tx,
 					unsigned long stamp)
 {
-	const struct iwl_mod_params *mod_params = priv->cfg->mod_params;
 	unsigned int msecs;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
@@ -449,13 +448,13 @@ static void iwl_recover_from_statistics(struct iwl_priv *priv,
 	if (msecs < 99)
 		return;
 
-	if (mod_params->ack_check && !iwl_good_ack_health(priv, tx)) {
+	if (iwlagn_mod_params.ack_check && !iwl_good_ack_health(priv, tx)) {
 		IWL_ERR(priv, "low ack count detected, restart firmware\n");
 		if (!iwl_force_reset(priv, IWL_FW_RESET, false))
 			return;
 	}
 
-	if (mod_params->plcp_check &&
+	if (iwlagn_mod_params.plcp_check &&
 	    !iwl_good_plcp_health(priv, cur_ofdm, cur_ofdm_ht, msecs))
 		iwl_force_reset(priv, IWL_RF_RESET, false);
 }
@@ -846,7 +845,7 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	}
 
 	/* In case of HW accelerated crypto and bad decryption, drop */
-	if (!priv->cfg->mod_params->sw_crypto &&
+	if (!iwlagn_mod_params.sw_crypto &&
 	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
 		return;
 
-- 
1.7.0.4

