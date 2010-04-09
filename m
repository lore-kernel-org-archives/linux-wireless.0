Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17339 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab0DIUJm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/12] iwlwifi: update tx command response status
Date: Fri,  9 Apr 2010 13:09:25 -0700
Message-Id: <1270843769-30017-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
References: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Update to include additional tx command response status for "_agn"
devices.

The following status indicate the transmission was postponed:
  TX_STATUS_POSTPONE_DELAY
  TX_STATUS_POSTPONE_FEW_BYTES
  TX_STATUS_POSTPONE_BT_PRIO
  TX_STATUS_POSTPONE_QUIET_PERIOD
  TX_STATUS_POSTPONE_CALC_TTAK

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   11 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   24 ++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |   79 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   41 ++++++++------
 6 files changed, 108 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7424586..ae5efc3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -191,12 +191,12 @@ static int iwl3945_hwrate_to_plcp_idx(u8 plcp)
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-#define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
+#define TX_STATUS_ENTRY(x) case TX_3945_STATUS_FAIL_ ## x: return #x
 
 static const char *iwl3945_get_tx_fail_reason(u32 status)
 {
 	switch (status & TX_STATUS_MSK) {
-	case TX_STATUS_SUCCESS:
+	case TX_3945_STATUS_SUCCESS:
 		return "SUCCESS";
 		TX_STATUS_ENTRY(SHORT_LIMIT);
 		TX_STATUS_ENTRY(LONG_LIMIT);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 0164c3f..c710b26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2049,8 +2049,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 	iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
 
-	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
-		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
+	iwl_check_abort_status(priv, tx_resp->frame_count, status);
 }
 
 static int iwl4965_calc_rssi(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 7f27a94..384b45c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -161,6 +161,14 @@ static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 	return 0;
 }
 
+void iwl_check_abort_status(struct iwl_priv *priv,
+			    u8 frame_count, u32 status)
+{
+	if (frame_count == 1 && status == TX_STATUS_FAIL_RFKILL_FLUSH) {
+		IWL_ERR(priv, "TODO: Implement Tx flush command!!!\n");
+	}
+}
+
 static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
@@ -246,8 +254,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 
 	iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
 
-	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
-		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
+	iwl_check_abort_status(priv, tx_resp->frame_count, status);
 }
 
 void iwlagn_rx_handler_setup(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5ad1405..608060a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -105,6 +105,8 @@ void iwlagn_init_alive_start(struct iwl_priv *priv);
 int iwlagn_alive_notify(struct iwl_priv *priv);
 
 /* lib */
+void iwl_check_abort_status(struct iwl_priv *priv,
+			    u8 frame_count, u32 status);
 void iwlagn_rx_handler_setup(struct iwl_priv *priv);
 void iwlagn_setup_deferred_work(struct iwl_priv *priv);
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
@@ -146,4 +148,26 @@ void iwlagn_hw_txq_ctx_free(struct iwl_priv *priv);
 int iwlagn_txq_ctx_reset(struct iwl_priv *priv);
 void iwlagn_txq_ctx_stop(struct iwl_priv *priv);
 
+static inline u32 iwl_tx_status_to_mac80211(u32 status)
+{
+	status &= TX_STATUS_MSK;
+
+	switch (status) {
+	case TX_STATUS_SUCCESS:
+	case TX_STATUS_DIRECT_DONE:
+		return IEEE80211_TX_STAT_ACK;
+	case TX_STATUS_FAIL_DEST_PS:
+		return IEEE80211_TX_STAT_TX_FILTERED;
+	default:
+		return 0;
+	}
+}
+
+static inline bool iwl_is_tx_success(u32 status)
+{
+	status &= TX_STATUS_MSK;
+	return (status == TX_STATUS_SUCCESS) ||
+	       (status == TX_STATUS_DIRECT_DONE);
+}
+
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 74d6887..82a9378 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1662,7 +1662,7 @@ struct iwl_tx_cmd {
 	struct ieee80211_hdr hdr[0];
 } __attribute__ ((packed));
 
-/* TX command response is sent after *all* transmission attempts.
+/* TX command response is sent after *3945* transmission attempts.
  *
  * NOTES:
  *
@@ -1690,24 +1690,65 @@ struct iwl_tx_cmd {
  * control line.  Receiving is still allowed in this case.
  */
 enum {
+	TX_3945_STATUS_SUCCESS = 0x01,
+	TX_3945_STATUS_DIRECT_DONE = 0x02,
+	TX_3945_STATUS_FAIL_SHORT_LIMIT = 0x82,
+	TX_3945_STATUS_FAIL_LONG_LIMIT = 0x83,
+	TX_3945_STATUS_FAIL_FIFO_UNDERRUN = 0x84,
+	TX_3945_STATUS_FAIL_MGMNT_ABORT = 0x85,
+	TX_3945_STATUS_FAIL_NEXT_FRAG = 0x86,
+	TX_3945_STATUS_FAIL_LIFE_EXPIRE = 0x87,
+	TX_3945_STATUS_FAIL_DEST_PS = 0x88,
+	TX_3945_STATUS_FAIL_ABORTED = 0x89,
+	TX_3945_STATUS_FAIL_BT_RETRY = 0x8a,
+	TX_3945_STATUS_FAIL_STA_INVALID = 0x8b,
+	TX_3945_STATUS_FAIL_FRAG_DROPPED = 0x8c,
+	TX_3945_STATUS_FAIL_TID_DISABLE = 0x8d,
+	TX_3945_STATUS_FAIL_FRAME_FLUSHED = 0x8e,
+	TX_3945_STATUS_FAIL_INSUFFICIENT_CF_POLL = 0x8f,
+	TX_3945_STATUS_FAIL_TX_LOCKED = 0x90,
+	TX_3945_STATUS_FAIL_NO_BEACON_ON_RADAR = 0x91,
+};
+
+/*
+ * TX command response is sent after *agn* transmission attempts.
+ *
+ * both postpone and abort status are expected behavior from uCode. there is
+ * no special operation required from driver; except for RFKILL_FLUSH,
+ * which required tx flush host command to flush all the tx frames in queues
+ */
+enum {
 	TX_STATUS_SUCCESS = 0x01,
 	TX_STATUS_DIRECT_DONE = 0x02,
+	/* postpone TX */
+	TX_STATUS_POSTPONE_DELAY = 0x40,
+	TX_STATUS_POSTPONE_FEW_BYTES = 0x41,
+	TX_STATUS_POSTPONE_BT_PRIO = 0x42,
+	TX_STATUS_POSTPONE_QUIET_PERIOD = 0x43,
+	TX_STATUS_POSTPONE_CALC_TTAK = 0x44,
+	/* abort TX */
+	TX_STATUS_FAIL_INTERNAL_CROSSED_RETRY = 0x81,
 	TX_STATUS_FAIL_SHORT_LIMIT = 0x82,
 	TX_STATUS_FAIL_LONG_LIMIT = 0x83,
 	TX_STATUS_FAIL_FIFO_UNDERRUN = 0x84,
-	TX_STATUS_FAIL_MGMNT_ABORT = 0x85,
-	TX_STATUS_FAIL_NEXT_FRAG = 0x86,
+	TX_STATUS_FAIL_DRAIN_FLOW = 0x85,
+	TX_STATUS_FAIL_RFKILL_FLUSH = 0x86,
 	TX_STATUS_FAIL_LIFE_EXPIRE = 0x87,
 	TX_STATUS_FAIL_DEST_PS = 0x88,
-	TX_STATUS_FAIL_ABORTED = 0x89,
+	TX_STATUS_FAIL_HOST_ABORTED = 0x89,
 	TX_STATUS_FAIL_BT_RETRY = 0x8a,
 	TX_STATUS_FAIL_STA_INVALID = 0x8b,
 	TX_STATUS_FAIL_FRAG_DROPPED = 0x8c,
 	TX_STATUS_FAIL_TID_DISABLE = 0x8d,
-	TX_STATUS_FAIL_FRAME_FLUSHED = 0x8e,
+	TX_STATUS_FAIL_FIFO_FLUSHED = 0x8e,
 	TX_STATUS_FAIL_INSUFFICIENT_CF_POLL = 0x8f,
-	TX_STATUS_FAIL_TX_LOCKED = 0x90,
-	TX_STATUS_FAIL_NO_BEACON_ON_RADAR = 0x91,
+	/* uCode drop due to FW drop request */
+	TX_STATUS_FAIL_FW_DROP = 0x90,
+	/*
+	 * uCode drop due to station color mismatch
+	 * between tx command and station table
+	 */
+	TX_STATUS_FAIL_STA_COLOR_MISMATCH_DROP = 0x91,
 };
 
 #define	TX_PACKET_MODE_REGULAR		0x0000
@@ -1729,30 +1770,6 @@ enum {
 	TX_ABORT_REQUIRED_MSK = 0x80000000,	/* bits 31:31 */
 };
 
-static inline u32 iwl_tx_status_to_mac80211(u32 status)
-{
-	status &= TX_STATUS_MSK;
-
-	switch (status) {
-	case TX_STATUS_SUCCESS:
-	case TX_STATUS_DIRECT_DONE:
-		return IEEE80211_TX_STAT_ACK;
-	case TX_STATUS_FAIL_DEST_PS:
-		return IEEE80211_TX_STAT_TX_FILTERED;
-	default:
-		return 0;
-	}
-}
-
-static inline bool iwl_is_tx_success(u32 status)
-{
-	status &= TX_STATUS_MSK;
-	return (status == TX_STATUS_SUCCESS) ||
-	       (status == TX_STATUS_DIRECT_DONE);
-}
-
-
-
 /* *******************************
  * TX aggregation status
  ******************************* */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index a631afe..aea6a2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -629,29 +629,36 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 EXPORT_SYMBOL(iwl_tx_cmd_complete);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-#define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
+#define TX_STATUS_FAIL(x) case TX_STATUS_FAIL_ ## x: return #x
+#define TX_STATUS_POSTPONE(x) case TX_STATUS_POSTPONE_ ## x: return #x
 
 const char *iwl_get_tx_fail_reason(u32 status)
 {
 	switch (status & TX_STATUS_MSK) {
 	case TX_STATUS_SUCCESS:
 		return "SUCCESS";
-		TX_STATUS_ENTRY(SHORT_LIMIT);
-		TX_STATUS_ENTRY(LONG_LIMIT);
-		TX_STATUS_ENTRY(FIFO_UNDERRUN);
-		TX_STATUS_ENTRY(MGMNT_ABORT);
-		TX_STATUS_ENTRY(NEXT_FRAG);
-		TX_STATUS_ENTRY(LIFE_EXPIRE);
-		TX_STATUS_ENTRY(DEST_PS);
-		TX_STATUS_ENTRY(ABORTED);
-		TX_STATUS_ENTRY(BT_RETRY);
-		TX_STATUS_ENTRY(STA_INVALID);
-		TX_STATUS_ENTRY(FRAG_DROPPED);
-		TX_STATUS_ENTRY(TID_DISABLE);
-		TX_STATUS_ENTRY(FRAME_FLUSHED);
-		TX_STATUS_ENTRY(INSUFFICIENT_CF_POLL);
-		TX_STATUS_ENTRY(TX_LOCKED);
-		TX_STATUS_ENTRY(NO_BEACON_ON_RADAR);
+		TX_STATUS_POSTPONE(DELAY);
+		TX_STATUS_POSTPONE(FEW_BYTES);
+		TX_STATUS_POSTPONE(BT_PRIO);
+		TX_STATUS_POSTPONE(QUIET_PERIOD);
+		TX_STATUS_POSTPONE(CALC_TTAK);
+		TX_STATUS_FAIL(INTERNAL_CROSSED_RETRY);
+		TX_STATUS_FAIL(SHORT_LIMIT);
+		TX_STATUS_FAIL(LONG_LIMIT);
+		TX_STATUS_FAIL(FIFO_UNDERRUN);
+		TX_STATUS_FAIL(DRAIN_FLOW);
+		TX_STATUS_FAIL(RFKILL_FLUSH);
+		TX_STATUS_FAIL(LIFE_EXPIRE);
+		TX_STATUS_FAIL(DEST_PS);
+		TX_STATUS_FAIL(HOST_ABORTED);
+		TX_STATUS_FAIL(BT_RETRY);
+		TX_STATUS_FAIL(STA_INVALID);
+		TX_STATUS_FAIL(FRAG_DROPPED);
+		TX_STATUS_FAIL(TID_DISABLE);
+		TX_STATUS_FAIL(FIFO_FLUSHED);
+		TX_STATUS_FAIL(INSUFFICIENT_CF_POLL);
+		TX_STATUS_FAIL(FW_DROP);
+		TX_STATUS_FAIL(STA_COLOR_MISMATCH_DROP);
 	}
 
 	return "UNKNOWN";
-- 
1.6.3.3

