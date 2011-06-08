Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab1FHN2q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 09:28:46 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/6] iwlegacy: remove recover from statistics
Date: Wed,  8 Jun 2011 15:28:25 +0200
Message-Id: <1307539709-11320-2-git-send-email-sgruszka@redhat.com> (sfid-20110608_152849_228009_C43D6738)
In-Reply-To: <1307539709-11320-1-git-send-email-sgruszka@redhat.com>
References: <1307539709-11320-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recover from statistics code was added during 6xxx devices development,
I don't think is needed on old devices. Also it is suspicious to cause
random, unreproducible microcode errors and hangs. So remove it.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945.c    |    1 -
 drivers/net/wireless/iwlegacy/iwl-4965-rx.c |   78 +--------------------------
 drivers/net/wireless/iwlegacy/iwl-4965.c    |    1 -
 drivers/net/wireless/iwlegacy/iwl-core.h    |    3 -
 drivers/net/wireless/iwlegacy/iwl-rx.c      |   21 -------
 5 files changed, 1 insertions(+), 103 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index d096dc2..5e99584 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -408,7 +408,6 @@ void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
 	iwl3945_accumulative_statistics(priv, (__le32 *)&pkt->u.raw);
 #endif
-	iwl_legacy_recover_from_statistics(priv, pkt);
 
 	memcpy(&priv->_3945.statistics, pkt->u.raw, sizeof(priv->_3945.statistics));
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rx.c b/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
index b9fa2f6..2b144bb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
@@ -151,81 +151,6 @@ static void iwl4965_accumulative_statistics(struct iwl_priv *priv,
 
 #define REG_RECALIB_PERIOD (60)
 
-/**
- * iwl4965_good_plcp_health - checks for plcp error.
- *
- * When the plcp error is exceeding the thresholds, reset the radio
- * to improve the throughput.
- */
-bool iwl4965_good_plcp_health(struct iwl_priv *priv,
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
-		ofdm = &pkt->u.stats.rx.ofdm;
-		ofdm_ht = &pkt->u.stats.rx.ofdm_ht;
-		combined_plcp_delta =
-		    (le32_to_cpu(ofdm->plcp_err) -
-		    le32_to_cpu(priv->_4965.statistics.
-				rx.ofdm.plcp_err)) +
-		    (le32_to_cpu(ofdm_ht->plcp_err) -
-		    le32_to_cpu(priv->_4965.statistics.
-				rx.ofdm_ht.plcp_err));
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
 void iwl4965_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
@@ -248,8 +173,7 @@ void iwl4965_rx_statistics(struct iwl_priv *priv,
 	iwl4965_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
 #endif
 
-	iwl_legacy_recover_from_statistics(priv, pkt);
-
+	/* TODO: reading some of statistics is unneeded */
 	memcpy(&priv->_4965.statistics, &pkt->u.stats,
 		sizeof(priv->_4965.statistics));
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 9cf96cb..f59f588 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -2100,7 +2100,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.tx_stats_read = iwl4965_ucode_tx_stats_read,
 		.general_stats_read = iwl4965_ucode_general_stats_read,
 	},
-	.check_plcp_health = iwl4965_good_plcp_health,
 };
 
 static const struct iwl_legacy_ops iwl4965_legacy_ops = {
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index c5fbda0..a821bdb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -161,9 +161,6 @@ struct iwl_lib_ops {
 
 	/* temperature */
 	struct iwl_temp_ops temp_ops;
-	/* check for plcp health */
-	bool (*check_plcp_health)(struct iwl_priv *priv,
-					struct iwl_rx_packet *pkt);
 
 	struct iwl_debugfs_ops debugfs_ops;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
index 654cf23..9b5d0ab 100644
--- a/drivers/net/wireless/iwlegacy/iwl-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
@@ -227,27 +227,6 @@ void iwl_legacy_rx_spectrum_measure_notif(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_legacy_rx_spectrum_measure_notif);
 
-void iwl_legacy_recover_from_statistics(struct iwl_priv *priv,
-				struct iwl_rx_packet *pkt)
-{
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-	if (iwl_legacy_is_any_associated(priv)) {
-		if (priv->cfg->ops->lib->check_plcp_health) {
-			if (!priv->cfg->ops->lib->check_plcp_health(
-			    priv, pkt)) {
-				/*
-				 * high plcp error detected
-				 * reset Radio
-				 */
-				iwl_legacy_force_reset(priv,
-							IWL_RF_RESET, false);
-			}
-		}
-	}
-}
-EXPORT_SYMBOL(iwl_legacy_recover_from_statistics);
-
 /*
  * returns non-zero if packet should be dropped
  */
-- 
1.7.1

