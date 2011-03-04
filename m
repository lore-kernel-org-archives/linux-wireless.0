Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759820Ab1CDQwH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 11:52:07 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/3] iwlwifi: cleanup iwl_good_plcp_health
Date: Fri,  4 Mar 2011 17:51:50 +0100
Message-Id: <1299257511-5241-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
References: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make iwl_good_plcp_health code easiest to read.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-rx.c |  115 +++++++++++++--------------------
 1 files changed, 45 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 8dc1294..a70f1eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -451,82 +451,57 @@ static bool iwl_good_ack_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt
 static bool iwl_good_plcp_health(struct iwl_priv *priv,
 				 struct iwl_rx_packet *pkt)
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
+	/* Can be negative if firmware reseted statistics */
+	if (delta <= 0)
+		return true;
+
+	if ((delta * 100 / msecs) > threshold) {
+		IWL_DEBUG_RADIO(priv,
+				"plcp health threshold %u delta %d msecs %u\n",
+				threshold, delta, msecs);
+		return false;
+	}
+
+	return true;
 }
 
 static void iwl_recover_from_statistics(struct iwl_priv *priv,
-- 
1.7.1

