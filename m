Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab1B1Nds (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 08:33:48 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 4/5] iwlwifi: move check health code into iwl-rx.c
Date: Mon, 28 Feb 2011 14:33:16 +0100
Message-Id: <1298899997-2372-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1298899997-2372-1-git-send-email-sgruszka@redhat.com>
References: <1298899997-2372-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove check_plcp_health and check_ack_health ops methods, they are
unneeded after iwlegacy driver split. Merge check health code into to
iwl-rx.c and make functions static.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    2 -
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    2 -
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    4 -
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    4 -
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c |   87 ---------------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   67 +------------
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    4 -
 drivers/net/wireless/iwlwifi/iwl-core.h   |    7 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c     |  162 +++++++++++++++++++++++++++--
 9 files changed, 156 insertions(+), 183 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index ba78bc8..e8e1c2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -232,8 +232,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.bt_stats_read = iwl_ucode_bt_stats_read,
 		.reply_tx_error = iwl_reply_tx_error_read,
 	},
-	.check_plcp_health = iwl_good_plcp_health,
-	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 	.tt_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 30483e2..894cb24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -315,8 +315,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 		.bt_stats_read = iwl_ucode_bt_stats_read,
 		.reply_tx_error = iwl_reply_tx_error_read,
 	},
-	.check_plcp_health = iwl_good_plcp_health,
-	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 	.tt_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 537fb8c..3ea31b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -402,8 +402,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.bt_stats_read = iwl_ucode_bt_stats_read,
 		.reply_tx_error = iwl_reply_tx_error_read,
 	},
-	.check_plcp_health = iwl_good_plcp_health,
-	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 	.tt_ops = {
@@ -471,8 +469,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.bt_stats_read = iwl_ucode_bt_stats_read,
 		.reply_tx_error = iwl_reply_tx_error_read,
 	},
-	.check_plcp_health = iwl_good_plcp_health,
-	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 	.tt_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f6493f7..a745b01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -343,8 +343,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.bt_stats_read = iwl_ucode_bt_stats_read,
 		.reply_tx_error = iwl_reply_tx_error_read,
 	},
-	.check_plcp_health = iwl_good_plcp_health,
-	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 	.tt_ops = {
@@ -415,8 +413,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 		.bt_stats_read = iwl_ucode_bt_stats_read,
 		.reply_tx_error = iwl_reply_tx_error_read,
 	},
-	.check_plcp_health = iwl_good_plcp_health,
-	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 	.tt_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index b192ca8..7a89a55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -169,93 +169,6 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 
 #define REG_RECALIB_PERIOD (60)
 
-/**
- * iwl_good_plcp_health - checks for plcp error.
- *
- * When the plcp error is exceeding the thresholds, reset the radio
- * to improve the throughput.
- */
-bool iwl_good_plcp_health(struct iwl_priv *priv,
-				struct iwl_rx_packet *pkt)
-{
-	bool rc = true;
-	int combined_plcp_delta;
-	unsigned int plcp_msec;
-	unsigned long plcp_received_jiffies;
-
-	if (priv->cfg->base_params->plcp_delta_threshold ==
-	    IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE) {
-		IWL_DEBUG_RADIO(priv, "plcp_err check disabled\n");
-		return rc;
-	}
-
-	/*
-	 * check for plcp_err and trigger radio reset if it exceeds
-	 * the plcp error threshold plcp_delta.
-	 */
-	plcp_received_jiffies = jiffies;
-	plcp_msec = jiffies_to_msecs((long) plcp_received_jiffies -
-					(long) priv->plcp_jiffies);
-	priv->plcp_jiffies = plcp_received_jiffies;
-	/*
-	 * check to make sure plcp_msec is not 0 to prevent division
-	 * by zero.
-	 */
-	if (plcp_msec) {
-		struct statistics_rx_phy *ofdm;
-		struct statistics_rx_ht_phy *ofdm_ht;
-
-		if (iwl_bt_statistics(priv)) {
-			ofdm = &pkt->u.stats_bt.rx.ofdm;
-			ofdm_ht = &pkt->u.stats_bt.rx.ofdm_ht;
-			combined_plcp_delta =
-			   (le32_to_cpu(ofdm->plcp_err) -
-			   le32_to_cpu(priv->_agn.statistics_bt.
-				       rx.ofdm.plcp_err)) +
-			   (le32_to_cpu(ofdm_ht->plcp_err) -
-			   le32_to_cpu(priv->_agn.statistics_bt.
-				       rx.ofdm_ht.plcp_err));
-		} else {
-			ofdm = &pkt->u.stats.rx.ofdm;
-			ofdm_ht = &pkt->u.stats.rx.ofdm_ht;
-			combined_plcp_delta =
-			    (le32_to_cpu(ofdm->plcp_err) -
-			    le32_to_cpu(priv->_agn.statistics.
-					rx.ofdm.plcp_err)) +
-			    (le32_to_cpu(ofdm_ht->plcp_err) -
-			    le32_to_cpu(priv->_agn.statistics.
-					rx.ofdm_ht.plcp_err));
-		}
-
-		if ((combined_plcp_delta > 0) &&
-		    ((combined_plcp_delta * 100) / plcp_msec) >
-			priv->cfg->base_params->plcp_delta_threshold) {
-			/*
-			 * if plcp_err exceed the threshold,
-			 * the following data is printed in csv format:
-			 *    Text: plcp_err exceeded %d,
-			 *    Received ofdm.plcp_err,
-			 *    Current ofdm.plcp_err,
-			 *    Received ofdm_ht.plcp_err,
-			 *    Current ofdm_ht.plcp_err,
-			 *    combined_plcp_delta,
-			 *    plcp_msec
-			 */
-			IWL_DEBUG_RADIO(priv, "plcp_err exceeded %u, "
-				"%u, %u, %u, %u, %d, %u mSecs\n",
-				priv->cfg->base_params->plcp_delta_threshold,
-				le32_to_cpu(ofdm->plcp_err),
-				le32_to_cpu(ofdm->plcp_err),
-				le32_to_cpu(ofdm_ht->plcp_err),
-				le32_to_cpu(ofdm_ht->plcp_err),
-				combined_plcp_delta, plcp_msec);
-
-			rc = false;
-		}
-	}
-	return rc;
-}
-
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4792418..24deffe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1413,72 +1413,6 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		iwl_enable_rfkill_int(priv);
 }
 
-/* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */
-#define ACK_CNT_RATIO (50)
-#define BA_TIMEOUT_CNT (5)
-#define BA_TIMEOUT_MAX (16)
-
-/**
- * iwl_good_ack_health - checks for ACK count ratios, BA timeout retries.
- *
- * When the ACK count ratio is low and aggregated BA timeout retries exceeding
- * the BA_TIMEOUT_MAX, reload firmware and bring system back to normal
- * operation state.
- */
-bool iwl_good_ack_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
-{
-	int actual_delta, expected_delta, ba_timeout_delta;
-	struct statistics_tx *cur, *old;
-
-	if (priv->_agn.agg_tids_count)
-		return true;
-
-	if (iwl_bt_statistics(priv)) {
-		cur = &pkt->u.stats_bt.tx;
-		old = &priv->_agn.statistics_bt.tx;
-	} else {
-		cur = &pkt->u.stats.tx;
-		old = &priv->_agn.statistics.tx;
-	}
-
-	actual_delta = le32_to_cpu(cur->actual_ack_cnt) -
-		       le32_to_cpu(old->actual_ack_cnt);
-	expected_delta = le32_to_cpu(cur->expected_ack_cnt) -
-			 le32_to_cpu(old->expected_ack_cnt);
-
-	/* Values should not be negative, but we do not trust the firmware */
-	if (actual_delta <= 0 || expected_delta <= 0)
-		return true;
-
-	ba_timeout_delta = le32_to_cpu(cur->agg.ba_timeout) -
-			   le32_to_cpu(old->agg.ba_timeout);
-
-	if ((actual_delta * 100 / expected_delta) < ACK_CNT_RATIO &&
-	    ba_timeout_delta > BA_TIMEOUT_CNT) {
-		IWL_DEBUG_RADIO(priv, "deltas: actual %d expected %d ba_timeout %d\n",
-				actual_delta, expected_delta, ba_timeout_delta);
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-		/*
-		 * This is ifdef'ed on DEBUGFS because otherwise the
-		 * statistics aren't available. If DEBUGFS is set but
-		 * DEBUG is not, these will just compile out.
-		 */
-		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta %d\n",
-				priv->_agn.delta_statistics.tx.rx_detected_cnt);
-		IWL_DEBUG_RADIO(priv,
-				"ack_or_ba_timeout_collision delta %d\n",
-				priv->_agn.delta_statistics.tx.ack_or_ba_timeout_collision);
-#endif
-
-		if (ba_timeout_delta >= BA_TIMEOUT_MAX)
-			return false;
-	}
-
-	return true;
-}
-
-
 /*****************************************************************************
  *
  * sysfs attributes
@@ -4791,3 +4725,4 @@ MODULE_PARM_DESC(plcp_check, "Check plcp health (default: 1 [enabled])");
 
 module_param_named(ack_check, iwlagn_mod_params.ack_check, bool, S_IRUGO);
 MODULE_PARM_DESC(ack_check, "Check ack health (default: 0 [disabled])");
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 88c7210..b5a169b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -121,8 +121,6 @@ void iwl_disable_ict(struct iwl_priv *priv);
 int iwl_alloc_isr_ict(struct iwl_priv *priv);
 void iwl_free_isr_ict(struct iwl_priv *priv);
 irqreturn_t iwl_isr_ict(int irq, void *data);
-bool iwl_good_ack_health(struct iwl_priv *priv,
-			 struct iwl_rx_packet *pkt);
 
 /* tx queue */
 void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
@@ -248,8 +246,6 @@ u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx, u8 valid);
 /* rx */
 void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb);
-bool iwl_good_plcp_health(struct iwl_priv *priv,
-			  struct iwl_rx_packet *pkt);
 void iwl_rx_statistics(struct iwl_priv *priv,
 		       struct iwl_rx_mem_buffer *rxb);
 void iwl_reply_statistics(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index fac3a6c..22dc435 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -210,12 +210,7 @@ struct iwl_lib_ops {
 
 	/* temperature */
 	struct iwl_temp_ops temp_ops;
-	/* check for plcp health */
-	bool (*check_plcp_health)(struct iwl_priv *priv,
-					struct iwl_rx_packet *pkt);
-	/* check for ack health */
-	bool (*check_ack_health)(struct iwl_priv *priv,
-					struct iwl_rx_packet *pkt);
+
 	int (*txfifo_flush)(struct iwl_priv *priv, u16 flush_control);
 	void (*dev_txfifo_flush)(struct iwl_priv *priv, u16 flush_control);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index fd84d53..feee761 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -227,8 +227,158 @@ void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 	priv->measurement_status |= MEASUREMENT_READY;
 }
 
-void iwl_recover_from_statistics(struct iwl_priv *priv,
-				struct iwl_rx_packet *pkt)
+/* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */
+#define ACK_CNT_RATIO (50)
+#define BA_TIMEOUT_CNT (5)
+#define BA_TIMEOUT_MAX (16)
+
+/**
+ * iwl_good_ack_health - checks for ACK count ratios, BA timeout retries.
+ *
+ * When the ACK count ratio is low and aggregated BA timeout retries exceeding
+ * the BA_TIMEOUT_MAX, reload firmware and bring system back to normal
+ * operation state.
+ */
+static bool iwl_good_ack_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
+{
+	int actual_delta, expected_delta, ba_timeout_delta;
+	struct statistics_tx *cur, *old;
+
+	if (priv->_agn.agg_tids_count)
+		return true;
+
+	if (iwl_bt_statistics(priv)) {
+		cur = &pkt->u.stats_bt.tx;
+		old = &priv->_agn.statistics_bt.tx;
+	} else {
+		cur = &pkt->u.stats.tx;
+		old = &priv->_agn.statistics.tx;
+	}
+
+	actual_delta = le32_to_cpu(cur->actual_ack_cnt) -
+		       le32_to_cpu(old->actual_ack_cnt);
+	expected_delta = le32_to_cpu(cur->expected_ack_cnt) -
+			 le32_to_cpu(old->expected_ack_cnt);
+
+	/* Values should not be negative, but we do not trust the firmware */
+	if (actual_delta <= 0 || expected_delta <= 0)
+		return true;
+
+	ba_timeout_delta = le32_to_cpu(cur->agg.ba_timeout) -
+			   le32_to_cpu(old->agg.ba_timeout);
+
+	if ((actual_delta * 100 / expected_delta) < ACK_CNT_RATIO &&
+	    ba_timeout_delta > BA_TIMEOUT_CNT) {
+		IWL_DEBUG_RADIO(priv, "deltas: actual %d expected %d ba_timeout %d\n",
+				actual_delta, expected_delta, ba_timeout_delta);
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+		/*
+		 * This is ifdef'ed on DEBUGFS because otherwise the
+		 * statistics aren't available. If DEBUGFS is set but
+		 * DEBUG is not, these will just compile out.
+		 */
+		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta %d\n",
+				priv->_agn.delta_statistics.tx.rx_detected_cnt);
+		IWL_DEBUG_RADIO(priv,
+				"ack_or_ba_timeout_collision delta %d\n",
+				priv->_agn.delta_statistics.tx.ack_or_ba_timeout_collision);
+#endif
+
+		if (ba_timeout_delta >= BA_TIMEOUT_MAX)
+			return false;
+	}
+
+	return true;
+}
+
+/**
+ * iwl_good_plcp_health - checks for plcp error.
+ *
+ * When the plcp error is exceeding the thresholds, reset the radio
+ * to improve the throughput.
+ */
+static bool iwl_good_plcp_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
+{
+	bool rc = true;
+	int combined_plcp_delta;
+	unsigned int plcp_msec;
+	unsigned long plcp_received_jiffies;
+
+	if (priv->cfg->base_params->plcp_delta_threshold ==
+	    IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE) {
+		IWL_DEBUG_RADIO(priv, "plcp_err check disabled\n");
+		return rc;
+	}
+
+	/*
+	 * check for plcp_err and trigger radio reset if it exceeds
+	 * the plcp error threshold plcp_delta.
+	 */
+	plcp_received_jiffies = jiffies;
+	plcp_msec = jiffies_to_msecs((long) plcp_received_jiffies -
+					(long) priv->plcp_jiffies);
+	priv->plcp_jiffies = plcp_received_jiffies;
+	/*
+	 * check to make sure plcp_msec is not 0 to prevent division
+	 * by zero.
+	 */
+	if (plcp_msec) {
+		struct statistics_rx_phy *ofdm;
+		struct statistics_rx_ht_phy *ofdm_ht;
+
+		if (iwl_bt_statistics(priv)) {
+			ofdm = &pkt->u.stats_bt.rx.ofdm;
+			ofdm_ht = &pkt->u.stats_bt.rx.ofdm_ht;
+			combined_plcp_delta =
+			   (le32_to_cpu(ofdm->plcp_err) -
+			   le32_to_cpu(priv->_agn.statistics_bt.
+				       rx.ofdm.plcp_err)) +
+			   (le32_to_cpu(ofdm_ht->plcp_err) -
+			   le32_to_cpu(priv->_agn.statistics_bt.
+				       rx.ofdm_ht.plcp_err));
+		} else {
+			ofdm = &pkt->u.stats.rx.ofdm;
+			ofdm_ht = &pkt->u.stats.rx.ofdm_ht;
+			combined_plcp_delta =
+			    (le32_to_cpu(ofdm->plcp_err) -
+			    le32_to_cpu(priv->_agn.statistics.
+					rx.ofdm.plcp_err)) +
+			    (le32_to_cpu(ofdm_ht->plcp_err) -
+			    le32_to_cpu(priv->_agn.statistics.
+					rx.ofdm_ht.plcp_err));
+		}
+
+		if ((combined_plcp_delta > 0) &&
+		    ((combined_plcp_delta * 100) / plcp_msec) >
+			priv->cfg->base_params->plcp_delta_threshold) {
+			/*
+			 * if plcp_err exceed the threshold,
+			 * the following data is printed in csv format:
+			 *    Text: plcp_err exceeded %d,
+			 *    Received ofdm.plcp_err,
+			 *    Current ofdm.plcp_err,
+			 *    Received ofdm_ht.plcp_err,
+			 *    Current ofdm_ht.plcp_err,
+			 *    combined_plcp_delta,
+			 *    plcp_msec
+			 */
+			IWL_DEBUG_RADIO(priv, "plcp_err exceeded %u, "
+				"%u, %u, %u, %u, %d, %u mSecs\n",
+				priv->cfg->base_params->plcp_delta_threshold,
+				le32_to_cpu(ofdm->plcp_err),
+				le32_to_cpu(ofdm->plcp_err),
+				le32_to_cpu(ofdm_ht->plcp_err),
+				le32_to_cpu(ofdm_ht->plcp_err),
+				combined_plcp_delta, plcp_msec);
+
+			rc = false;
+		}
+	}
+	return rc;
+}
+
+void iwl_recover_from_statistics(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
 {
 	const struct iwl_mod_params *mod_params = priv->cfg->mod_params;
 
@@ -236,17 +386,13 @@ void iwl_recover_from_statistics(struct iwl_priv *priv,
 	    !iwl_is_any_associated(priv))
 		return;
 
-	if (mod_params->ack_check &&
-	    priv->cfg->ops->lib->check_ack_health &&
-	    !priv->cfg->ops->lib->check_ack_health(priv, pkt)) {
+	if (mod_params->ack_check && !iwl_good_ack_health(priv, pkt)) {
 		IWL_ERR(priv, "low ack count detected, restart firmware\n");
 		if (!iwl_force_reset(priv, IWL_FW_RESET, false))
 			return;
 	}
 
-	if (mod_params->plcp_check &&
-	    priv->cfg->ops->lib->check_plcp_health &&
-	    !priv->cfg->ops->lib->check_plcp_health(priv, pkt))
+	if (mod_params->plcp_check && !iwl_good_plcp_health(priv, pkt))
 		iwl_force_reset(priv, IWL_RF_RESET, false);
 }
 
-- 
1.7.1

