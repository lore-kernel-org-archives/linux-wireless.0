Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab1BHIcN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 03:32:13 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/5] iwlwifi: cleanup iwl_good_ack_health
Date: Tue,  8 Feb 2011 09:31:57 +0100
Message-Id: <1297153919-18766-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make ack health code easies to read. Compared to previous
code, we do not print debug messages when expected_ack_cnt_delta == 0
and also do check against negative deltas.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   69 ++++++++++++++++----------------
 1 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a5daf64..8c4ca39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1407,34 +1407,37 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 /**
  * iwl_good_ack_health - checks for ACK count ratios, BA timeout retries.
  *
- * When the ACK count ratio is 0 and aggregated BA timeout retries exceeding
+ * When the ACK count ratio is low and aggregated BA timeout retries exceeding
  * the BA_TIMEOUT_MAX, reload firmware and bring system back to normal
  * operation state.
  */
-bool iwl_good_ack_health(struct iwl_priv *priv,
-				struct iwl_rx_packet *pkt)
+bool iwl_good_ack_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
 {
-	bool rc = true;
-	int actual_ack_cnt_delta, expected_ack_cnt_delta;
-	int ba_timeout_delta;
-
-	actual_ack_cnt_delta =
-		le32_to_cpu(pkt->u.stats.tx.actual_ack_cnt) -
-		le32_to_cpu(priv->_agn.statistics.tx.actual_ack_cnt);
-	expected_ack_cnt_delta =
-		le32_to_cpu(pkt->u.stats.tx.expected_ack_cnt) -
-		le32_to_cpu(priv->_agn.statistics.tx.expected_ack_cnt);
-	ba_timeout_delta =
-		le32_to_cpu(pkt->u.stats.tx.agg.ba_timeout) -
-		le32_to_cpu(priv->_agn.statistics.tx.agg.ba_timeout);
-	if ((priv->_agn.agg_tids_count > 0) &&
-	    (expected_ack_cnt_delta > 0) &&
-	    (((actual_ack_cnt_delta * 100) / expected_ack_cnt_delta)
-		< ACK_CNT_RATIO) &&
-	    (ba_timeout_delta > BA_TIMEOUT_CNT)) {
-		IWL_DEBUG_RADIO(priv, "actual_ack_cnt delta = %d,"
-				" expected_ack_cnt = %d\n",
-				actual_ack_cnt_delta, expected_ack_cnt_delta);
+	int actual_delta, expected_delta, ba_timeout_delta;
+	struct statistics_tx *cur, *old;
+
+	if (priv->_agn.agg_tids_count)
+		return true;
+
+	cur = &pkt->u.stats.tx;
+	old = &priv->_agn.statistics.tx;
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
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		/*
@@ -1442,20 +1445,18 @@ bool iwl_good_ack_health(struct iwl_priv *priv,
 		 * statistics aren't available. If DEBUGFS is set but
 		 * DEBUG is not, these will just compile out.
 		 */
-		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta = %d\n",
+		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta %d\n",
 				priv->_agn.delta_statistics.tx.rx_detected_cnt);
 		IWL_DEBUG_RADIO(priv,
-				"ack_or_ba_timeout_collision delta = %d\n",
-				priv->_agn.delta_statistics.tx.
-				ack_or_ba_timeout_collision);
+				"ack_or_ba_timeout_collision delta %d\n",
+				priv->_agn.delta_statistics.tx.ack_or_ba_timeout_collision);
 #endif
-		IWL_DEBUG_RADIO(priv, "agg ba_timeout delta = %d\n",
-				ba_timeout_delta);
-		if (!actual_ack_cnt_delta &&
-		    (ba_timeout_delta >= BA_TIMEOUT_MAX))
-			rc = false;
+
+		if (ba_timeout_delta >= BA_TIMEOUT_MAX)
+			return false;
 	}
-	return rc;
+
+	return true;
 }
 
 
-- 
1.7.1

