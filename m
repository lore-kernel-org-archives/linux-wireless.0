Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab1BHIcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 03:32:12 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/5] iwlwifi: cleanup {iwl,iwl3945}_good_plcp_health
Date: Tue,  8 Feb 2011 09:31:56 +0100
Message-Id: <1297153919-18766-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make plcp health code human readable.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   83 +++++++-----------
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c   |  122 +++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 3 files changed, 80 insertions(+), 126 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 58213e7..f371d42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -411,61 +411,40 @@ static void iwl3945_accumulative_statistics(struct iwl_priv *priv,
 static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
 				struct iwl_rx_packet *pkt)
 {
-	bool rc = true;
-	struct iwl3945_notif_statistics current_stat;
-	int combined_plcp_delta;
-	unsigned int plcp_msec;
-	unsigned long plcp_received_jiffies;
-
-	if (priv->cfg->base_params->plcp_delta_threshold ==
-	    IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE) {
+	__le32 cur_plcp_err, old_plcp_err;
+	unsigned int msecs;
+	unsigned long stamp;
+	int delta;
+	int threshold = priv->cfg->base_params->plcp_delta_threshold;
+
+	if (threshold == IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE) {
 		IWL_DEBUG_RADIO(priv, "plcp_err check disabled\n");
-		return rc;
+		return true;
 	}
-	memcpy(&current_stat, pkt->u.raw, sizeof(struct
-			iwl3945_notif_statistics));
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
-		combined_plcp_delta =
-			(le32_to_cpu(current_stat.rx.ofdm.plcp_err) -
-			le32_to_cpu(priv->_3945.statistics.rx.ofdm.plcp_err));
-
-		if ((combined_plcp_delta > 0) &&
-			((combined_plcp_delta * 100) / plcp_msec) >
-			priv->cfg->base_params->plcp_delta_threshold) {
-			/*
-			 * if plcp_err exceed the threshold, the following
-			 * data is printed in csv format:
-			 *    Text: plcp_err exceeded %d,
-			 *    Received ofdm.plcp_err,
-			 *    Current ofdm.plcp_err,
-			 *    combined_plcp_delta,
-			 *    plcp_msec
-			 */
-			IWL_DEBUG_RADIO(priv, "plcp_err exceeded %u, "
-				"%u, %d, %u mSecs\n",
-				priv->cfg->base_params->plcp_delta_threshold,
-				le32_to_cpu(current_stat.rx.ofdm.plcp_err),
-				combined_plcp_delta, plcp_msec);
-			/*
-			 * Reset the RF radio due to the high plcp
-			 * error rate
-			 */
-			rc = false;
-		}
+
+	stamp = jiffies;
+	msecs = jiffies_to_msecs(stamp - priv->plcp_jiffies);
+	priv->plcp_jiffies = stamp;
+
+	if (msecs == 0)
+		return true;
+
+	old_plcp_err = priv->_3945.statistics.rx.ofdm.plcp_err;
+	cur_plcp_err = pkt->u.stats_39.rx.ofdm.plcp_err;
+
+	delta = le32_to_cpu(cur_plcp_err) - le32_to_cpu(old_plcp_err);
+
+	/* Can be negative if firmware reset statistics */
+	if (delta <= 0)
+		return true;
+
+	if ((delta * 100 / msecs) > threshold) {
+		IWL_DEBUG_RADIO(priv, "plcp health threshold %u delta %d msecs %u\n",
+				threshold, delta, msecs);
+		return false;
 	}
-	return rc;
+
+	return true;
 }
 
 void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index b192ca8..5539fcb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -172,88 +172,62 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 /**
  * iwl_good_plcp_health - checks for plcp error.
  *
- * When the plcp error is exceeding the thresholds, reset the radio
- * to improve the throughput.
+ * When numbers of the plcp errors is exceeding the thresholds,
+ * reset the radio to improve the throughput.
  */
-bool iwl_good_plcp_health(struct iwl_priv *priv,
-				struct iwl_rx_packet *pkt)
+bool iwl_good_plcp_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
 {
-	bool rc = true;
-	int combined_plcp_delta;
-	unsigned int plcp_msec;
-	unsigned long plcp_received_jiffies;
+	unsigned int msecs;
+	unsigned long stamp;
+	int delta;
+	int threshold = priv->cfg->base_params->plcp_delta_threshold;
 
-	if (priv->cfg->base_params->plcp_delta_threshold ==
-	    IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE) {
+	if (threshold == IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE) {
 		IWL_DEBUG_RADIO(priv, "plcp_err check disabled\n");
-		return rc;
+		return true;
 	}
 
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
+	stamp = jiffies;
+	msecs = jiffies_to_msecs(stamp - priv->plcp_jiffies);
+	priv->plcp_jiffies = stamp;
 
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
+	if (msecs == 0)
+		return true;
+
+	if (iwl_bt_statistics(priv)) {
+		struct statistics_rx_bt *cur, *old;
+
+		cur = &pkt->u.stats_bt.rx;
+		old = &priv->_agn.statistics_bt.rx;
+
+		delta = le32_to_cpu(cur->ofdm.plcp_err) -
+			le32_to_cpu(old->ofdm.plcp_err) +
+			le32_to_cpu(cur->ofdm_ht.plcp_err) -
+			le32_to_cpu(old->ofdm_ht.plcp_err);
+	} else {
+		struct statistics_rx *cur, *old;
+
+		cur = &pkt->u.stats.rx;
+		old = &priv->_agn.statistics.rx;
+
+		delta = le32_to_cpu(cur->ofdm.plcp_err) -
+			le32_to_cpu(old->ofdm.plcp_err) +
+			le32_to_cpu(cur->ofdm_ht.plcp_err) -
+			le32_to_cpu(old->ofdm_ht.plcp_err);
 	}
-	return rc;
+
+	/* Can be negative if firmware reset statistics */
+	if (delta <= 0)
+		return true;
+
+	if ((delta * 100 / msecs) > threshold) {
+		IWL_DEBUG_RADIO(priv, "plcp health threshold %u delta %d msecs %u\n",
+				threshold, delta, msecs);
+
+		return false;
+	}
+
+	return true;
 }
 
 void iwl_rx_statistics(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 0a1d4ae..7d6192d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -4348,6 +4348,7 @@ struct iwl_rx_packet {
 		struct iwl3945_rx_frame rx_frame;
 		struct iwl3945_tx_resp tx_resp;
 		struct iwl3945_beacon_notif beacon_status;
+		struct iwl3945_notif_statistics stats_39;
 
 		struct iwl_alive_resp alive_frame;
 		struct iwl_spectrum_notification spectrum_notif;
-- 
1.7.1

