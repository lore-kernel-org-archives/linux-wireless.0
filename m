Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab0JGXIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/22] iwlwifi: move tx fail code to agn
Date: Thu,  7 Oct 2010 16:07:47 -0700
Message-Id: <1286492881-15743-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code to print out TX failure reasons is
AGN specific, so it can be in the AGN module.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   40 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    3 --
 drivers/net/wireless/iwlwifi/iwl-tx.c     |   38 ---------------------------
 4 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 77753b7..db57aea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1391,3 +1391,43 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+const char *iwl_get_tx_fail_reason(u32 status)
+{
+#define TX_STATUS_FAIL(x) case TX_STATUS_FAIL_ ## x: return #x
+#define TX_STATUS_POSTPONE(x) case TX_STATUS_POSTPONE_ ## x: return #x
+
+	switch (status & TX_STATUS_MSK) {
+	case TX_STATUS_SUCCESS:
+		return "SUCCESS";
+	TX_STATUS_POSTPONE(DELAY);
+	TX_STATUS_POSTPONE(FEW_BYTES);
+	TX_STATUS_POSTPONE(BT_PRIO);
+	TX_STATUS_POSTPONE(QUIET_PERIOD);
+	TX_STATUS_POSTPONE(CALC_TTAK);
+	TX_STATUS_FAIL(INTERNAL_CROSSED_RETRY);
+	TX_STATUS_FAIL(SHORT_LIMIT);
+	TX_STATUS_FAIL(LONG_LIMIT);
+	TX_STATUS_FAIL(FIFO_UNDERRUN);
+	TX_STATUS_FAIL(DRAIN_FLOW);
+	TX_STATUS_FAIL(RFKILL_FLUSH);
+	TX_STATUS_FAIL(LIFE_EXPIRE);
+	TX_STATUS_FAIL(DEST_PS);
+	TX_STATUS_FAIL(HOST_ABORTED);
+	TX_STATUS_FAIL(BT_RETRY);
+	TX_STATUS_FAIL(STA_INVALID);
+	TX_STATUS_FAIL(FRAG_DROPPED);
+	TX_STATUS_FAIL(TID_DISABLE);
+	TX_STATUS_FAIL(FIFO_FLUSHED);
+	TX_STATUS_FAIL(INSUFFICIENT_CF_POLL);
+	TX_STATUS_FAIL(PASSIVE_NO_RX);
+	TX_STATUS_FAIL(NO_BEACON_ON_RADAR);
+	}
+
+	return "UNKNOWN";
+
+#undef TX_STATUS_FAIL
+#undef TX_STATUS_POSTPONE
+}
+#endif /* CONFIG_IWLWIFI_DEBUG */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 632ea4b..d6645ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -248,8 +248,10 @@ void iwlagn_bt_setup_deferred_work(struct iwl_priv *priv);
 void iwlagn_bt_cancel_deferred_work(struct iwl_priv *priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
+const char *iwl_get_tx_fail_reason(u32 status);
 const char *iwl_get_agg_tx_fail_reason(u16 status);
 #else
+static inline const char *iwl_get_tx_fail_reason(u32 status) { return ""; }
 static inline const char *iwl_get_agg_tx_fail_reason(u16 status) { return ""; }
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 90a37a9..2b04714 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1566,7 +1566,6 @@ static inline void iwl_txq_ctx_deactivate(struct iwl_priv *priv, int txq_id)
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-const char *iwl_get_tx_fail_reason(u32 status);
 /*
  * iwl_get_debug_level: Return active debug level for device
  *
@@ -1582,8 +1581,6 @@ static inline u32 iwl_get_debug_level(struct iwl_priv *priv)
 		return iwl_debug_level;
 }
 #else
-static inline const char *iwl_get_tx_fail_reason(u32 status) { return ""; }
-
 static inline u32 iwl_get_debug_level(struct iwl_priv *priv)
 {
 	return iwl_debug_level;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 3290b15..7261ee4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -636,41 +636,3 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	meta->flags = 0;
 }
 EXPORT_SYMBOL(iwl_tx_cmd_complete);
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-#define TX_STATUS_FAIL(x) case TX_STATUS_FAIL_ ## x: return #x
-#define TX_STATUS_POSTPONE(x) case TX_STATUS_POSTPONE_ ## x: return #x
-
-const char *iwl_get_tx_fail_reason(u32 status)
-{
-	switch (status & TX_STATUS_MSK) {
-	case TX_STATUS_SUCCESS:
-		return "SUCCESS";
-		TX_STATUS_POSTPONE(DELAY);
-		TX_STATUS_POSTPONE(FEW_BYTES);
-		TX_STATUS_POSTPONE(BT_PRIO);
-		TX_STATUS_POSTPONE(QUIET_PERIOD);
-		TX_STATUS_POSTPONE(CALC_TTAK);
-		TX_STATUS_FAIL(INTERNAL_CROSSED_RETRY);
-		TX_STATUS_FAIL(SHORT_LIMIT);
-		TX_STATUS_FAIL(LONG_LIMIT);
-		TX_STATUS_FAIL(FIFO_UNDERRUN);
-		TX_STATUS_FAIL(DRAIN_FLOW);
-		TX_STATUS_FAIL(RFKILL_FLUSH);
-		TX_STATUS_FAIL(LIFE_EXPIRE);
-		TX_STATUS_FAIL(DEST_PS);
-		TX_STATUS_FAIL(HOST_ABORTED);
-		TX_STATUS_FAIL(BT_RETRY);
-		TX_STATUS_FAIL(STA_INVALID);
-		TX_STATUS_FAIL(FRAG_DROPPED);
-		TX_STATUS_FAIL(TID_DISABLE);
-		TX_STATUS_FAIL(FIFO_FLUSHED);
-		TX_STATUS_FAIL(INSUFFICIENT_CF_POLL);
-		TX_STATUS_FAIL(PASSIVE_NO_RX);
-		TX_STATUS_FAIL(NO_BEACON_ON_RADAR);
-	}
-
-	return "UNKNOWN";
-}
-EXPORT_SYMBOL(iwl_get_tx_fail_reason);
-#endif /* CONFIG_IWLWIFI_DEBUG */
-- 
1.7.0.4

