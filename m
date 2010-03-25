Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab0CYUox (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/22] iwlwifi: iwl_good_ack_health() only apply to AGN device
Date: Thu, 25 Mar 2010 13:44:30 -0700
Message-Id: <1269549890-19195-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

iwl_good_ack_health() check for expected and actual ack count which only
apply to aggregation mode. Move the function to iwlagn module.

Reported-by: Chantry Xavier <chantry.xavier@gmail.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   54 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-rx.c  |   55 --------------------------------
 3 files changed, 56 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e69e625..680e897 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1417,6 +1417,60 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		iwl_enable_interrupts(priv);
 }
 
+/* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */
+#define ACK_CNT_RATIO (50)
+#define BA_TIMEOUT_CNT (5)
+#define BA_TIMEOUT_MAX (16)
+
+/**
+ * iwl_good_ack_health - checks for ACK count ratios, BA timeout retries.
+ *
+ * When the ACK count ratio is 0 and aggregated BA timeout retries exceeding
+ * the BA_TIMEOUT_MAX, reload firmware and bring system back to normal
+ * operation state.
+ */
+bool iwl_good_ack_health(struct iwl_priv *priv,
+				struct iwl_rx_packet *pkt)
+{
+	bool rc = true;
+	int actual_ack_cnt_delta, expected_ack_cnt_delta;
+	int ba_timeout_delta;
+
+	actual_ack_cnt_delta =
+		le32_to_cpu(pkt->u.stats.tx.actual_ack_cnt) -
+		le32_to_cpu(priv->statistics.tx.actual_ack_cnt);
+	expected_ack_cnt_delta =
+		le32_to_cpu(pkt->u.stats.tx.expected_ack_cnt) -
+		le32_to_cpu(priv->statistics.tx.expected_ack_cnt);
+	ba_timeout_delta =
+		le32_to_cpu(pkt->u.stats.tx.agg.ba_timeout) -
+		le32_to_cpu(priv->statistics.tx.agg.ba_timeout);
+	if ((priv->_agn.agg_tids_count > 0) &&
+	    (expected_ack_cnt_delta > 0) &&
+	    (((actual_ack_cnt_delta * 100) / expected_ack_cnt_delta)
+		< ACK_CNT_RATIO) &&
+	    (ba_timeout_delta > BA_TIMEOUT_CNT)) {
+		IWL_DEBUG_RADIO(priv, "actual_ack_cnt delta = %d,"
+				" expected_ack_cnt = %d\n",
+				actual_ack_cnt_delta, expected_ack_cnt_delta);
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta = %d\n",
+				priv->delta_statistics.tx.rx_detected_cnt);
+		IWL_DEBUG_RADIO(priv,
+				"ack_or_ba_timeout_collision delta = %d\n",
+				priv->delta_statistics.tx.
+				ack_or_ba_timeout_collision);
+#endif
+		IWL_DEBUG_RADIO(priv, "agg ba_timeout delta = %d\n",
+				ba_timeout_delta);
+		if (!actual_ack_cnt_delta &&
+		    (ba_timeout_delta >= BA_TIMEOUT_MAX))
+			rc = false;
+	}
+	return rc;
+}
+
 
 /******************************************************************************
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 26eeb58..42c291b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -70,5 +70,7 @@ void iwl_disable_ict(struct iwl_priv *priv);
 int iwl_alloc_isr_ict(struct iwl_priv *priv);
 void iwl_free_isr_ict(struct iwl_priv *priv);
 irqreturn_t iwl_isr_ict(int irq, void *data);
+bool iwl_good_ack_health(struct iwl_priv *priv,
+			 struct iwl_rx_packet *pkt);
 
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b6a64d8..de453f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -616,61 +616,6 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 
 #define REG_RECALIB_PERIOD (60)
 
-/* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */
-#define ACK_CNT_RATIO (50)
-#define BA_TIMEOUT_CNT (5)
-#define BA_TIMEOUT_MAX (16)
-
-/**
- * iwl_good_ack_health - checks for ACK count ratios, BA timeout retries.
- *
- * When the ACK count ratio is 0 and aggregated BA timeout retries exceeding
- * the BA_TIMEOUT_MAX, reload firmware and bring system back to normal
- * operation state.
- */
-bool iwl_good_ack_health(struct iwl_priv *priv,
-				struct iwl_rx_packet *pkt)
-{
-	bool rc = true;
-	int actual_ack_cnt_delta, expected_ack_cnt_delta;
-	int ba_timeout_delta;
-
-	actual_ack_cnt_delta =
-		le32_to_cpu(pkt->u.stats.tx.actual_ack_cnt) -
-		le32_to_cpu(priv->statistics.tx.actual_ack_cnt);
-	expected_ack_cnt_delta =
-		le32_to_cpu(pkt->u.stats.tx.expected_ack_cnt) -
-		le32_to_cpu(priv->statistics.tx.expected_ack_cnt);
-	ba_timeout_delta =
-		le32_to_cpu(pkt->u.stats.tx.agg.ba_timeout) -
-		le32_to_cpu(priv->statistics.tx.agg.ba_timeout);
-	if ((priv->_agn.agg_tids_count > 0) &&
-	    (expected_ack_cnt_delta > 0) &&
-	    (((actual_ack_cnt_delta * 100) / expected_ack_cnt_delta)
-		< ACK_CNT_RATIO) &&
-	    (ba_timeout_delta > BA_TIMEOUT_CNT)) {
-		IWL_DEBUG_RADIO(priv, "actual_ack_cnt delta = %d,"
-				" expected_ack_cnt = %d\n",
-				actual_ack_cnt_delta, expected_ack_cnt_delta);
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta = %d\n",
-				priv->delta_statistics.tx.rx_detected_cnt);
-		IWL_DEBUG_RADIO(priv,
-				"ack_or_ba_timeout_collision delta = %d\n",
-				priv->delta_statistics.tx.
-				ack_or_ba_timeout_collision);
-#endif
-		IWL_DEBUG_RADIO(priv, "agg ba_timeout delta = %d\n",
-				ba_timeout_delta);
-		if (!actual_ack_cnt_delta &&
-		    (ba_timeout_delta >= BA_TIMEOUT_MAX))
-			rc = false;
-	}
-	return rc;
-}
-EXPORT_SYMBOL(iwl_good_ack_health);
-
 /**
  * iwl_good_plcp_health - checks for plcp error.
  *
-- 
1.6.3.3

