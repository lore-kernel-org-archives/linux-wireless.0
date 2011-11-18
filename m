Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760Ab1KRIW2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:28 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8MRCl022771
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:28 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 45/77] iwlegacy: s/rx_reply/hdl/
Date: Fri, 18 Nov 2011 09:22:07 +0100
Message-Id: <1321604559-10707-45-git-send-email-sgruszka@redhat.com> (sfid-20111118_092238_663576_1E7B8290)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |   10 +++++-----
 drivers/net/wireless/iwlegacy/3945.c     |   10 +++++-----
 drivers/net/wireless/iwlegacy/4965-mac.c |   22 +++++++++++-----------
 drivers/net/wireless/iwlegacy/4965.c     |    8 ++++----
 drivers/net/wireless/iwlegacy/4965.h     |    6 +++---
 drivers/net/wireless/iwlegacy/iwl-core.c |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-core.h |    2 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c |    4 ++--
 8 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index fa5e038..e9a1e64 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -743,7 +743,7 @@ static int il3945_get_measurement(struct il_priv *il,
 	return rc;
 }
 
-static void il3945_rx_reply_alive(struct il_priv *il,
+static void il3945_hdl_alive(struct il_priv *il,
 			       struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -779,7 +779,7 @@ static void il3945_rx_reply_alive(struct il_priv *il,
 		IL_WARN("uCode did not respond OK.\n");
 }
 
-static void il3945_rx_reply_add_sta(struct il_priv *il,
+static void il3945_hdl_add_sta(struct il_priv *il,
 				 struct il_rx_buf *rxb)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
@@ -853,9 +853,9 @@ static void il3945_rx_card_state_notif(struct il_priv *il,
  */
 static void il3945_setup_handlers(struct il_priv *il)
 {
-	il->handlers[N_ALIVE] = il3945_rx_reply_alive;
-	il->handlers[C_ADD_STA] = il3945_rx_reply_add_sta;
-	il->handlers[N_ERROR] = il_rx_reply_error;
+	il->handlers[N_ALIVE] = il3945_hdl_alive;
+	il->handlers[C_ADD_STA] = il3945_hdl_add_sta;
+	il->handlers[N_ERROR] = il_hdl_error;
 	il->handlers[N_CHANNEL_SWITCH] = il_rx_csa;
 	il->handlers[N_SPECTRUM_MEASUREMENT] =
 			il_rx_spectrum_measure_notif;
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 94d540c..b45905f 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -315,9 +315,9 @@ static void il3945_tx_queue_reclaim(struct il_priv *il,
 }
 
 /**
- * il3945_rx_reply_tx - Handle Tx response
+ * il3945_hdl_tx - Handle Tx response
  */
-static void il3945_rx_reply_tx(struct il_priv *il,
+static void il3945_hdl_tx(struct il_priv *il,
 				struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -521,7 +521,7 @@ static void il3945_pass_packet_to_mac80211(struct il_priv *il,
 
 #define IL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 
-static void il3945_rx_reply_rx(struct il_priv *il,
+static void il3945_hdl_rx(struct il_priv *il,
 				struct il_rx_buf *rxb)
 {
 	struct ieee80211_hdr *header;
@@ -2464,8 +2464,8 @@ unsigned int il3945_hw_get_beacon_cmd(struct il_priv *il,
 
 void il3945_hw_handler_setup(struct il_priv *il)
 {
-	il->handlers[C_TX] = il3945_rx_reply_tx;
-	il->handlers[N_3945_RX] = il3945_rx_reply_rx;
+	il->handlers[C_TX] = il3945_hdl_tx;
+	il->handlers[N_3945_RX] = il3945_hdl_rx;
 }
 
 void il3945_hw_setup_deferred_work(struct il_priv *il)
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index d82d05f..0797c11 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -610,7 +610,7 @@ static void il4965_pass_packet_to_mac80211(struct il_priv *il,
 
 /* Called for N_RX (legacy ABG frames), or
  * N_RX_MPDU (HT high-throughput N frames). */
-void il4965_rx_reply_rx(struct il_priv *il,
+void il4965_hdl_rx(struct il_priv *il,
 				struct il_rx_buf *rxb)
 {
 	struct ieee80211_hdr *header;
@@ -729,8 +729,8 @@ void il4965_rx_reply_rx(struct il_priv *il,
 }
 
 /* Cache phy data (Rx signal strength, etc) for HT frame (N_RX_PHY).
- * This will be used later in il_rx_reply_rx() for N_RX_MPDU. */
-void il4965_rx_reply_rx_phy(struct il_priv *il,
+ * This will be used later in il_hdl_rx() for N_RX_MPDU. */
+void il4965_hdl_rx_phy(struct il_priv *il,
 			    struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -2616,12 +2616,12 @@ void il4965_hwrate_to_tx_control(struct il_priv *il, u32 rate_n_flags,
 }
 
 /**
- * il4965_rx_reply_compressed_ba - Handler for N_COMPRESSED_BA
+ * il4965_hdl_compressed_ba - Handler for N_COMPRESSED_BA
  *
  * Handles block-acknowledge notification from device, which reports success
  * of frames sent via aggregation.
  */
-void il4965_rx_reply_compressed_ba(struct il_priv *il,
+void il4965_hdl_compressed_ba(struct il_priv *il,
 					   struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -3759,7 +3759,7 @@ int il4965_hw_tx_queue_init(struct il_priv *il,
  * Generic RX handler implementations
  *
  ******************************************************************************/
-static void il4965_rx_reply_alive(struct il_priv *il,
+static void il4965_hdl_alive(struct il_priv *il,
 				struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -3921,8 +3921,8 @@ static void il4965_rx_card_state_notif(struct il_priv *il,
  */
 static void il4965_setup_handlers(struct il_priv *il)
 {
-	il->handlers[N_ALIVE] = il4965_rx_reply_alive;
-	il->handlers[N_ERROR] = il_rx_reply_error;
+	il->handlers[N_ALIVE] = il4965_hdl_alive;
+	il->handlers[N_ERROR] = il_hdl_error;
 	il->handlers[N_CHANNEL_SWITCH] = il_rx_csa;
 	il->handlers[N_SPECTRUM_MEASUREMENT] =
 			il_rx_spectrum_measure_notif;
@@ -3948,10 +3948,10 @@ static void il4965_setup_handlers(struct il_priv *il)
 	il->handlers[N_MISSED_BEACONS] =
 	    il4965_rx_missed_beacon_notif;
 	/* Rx handlers */
-	il->handlers[N_RX_PHY] = il4965_rx_reply_rx_phy;
-	il->handlers[N_RX_MPDU] = il4965_rx_reply_rx;
+	il->handlers[N_RX_PHY] = il4965_hdl_rx_phy;
+	il->handlers[N_RX_MPDU] = il4965_hdl_rx;
 	/* block ack */
-	il->handlers[N_COMPRESSED_BA] = il4965_rx_reply_compressed_ba;
+	il->handlers[N_COMPRESSED_BA] = il4965_hdl_compressed_ba;
 	/* Set up hardware specific Rx handlers */
 	il->cfg->ops->lib->handler_setup(il);
 }
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index f48cb89..726fc80 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -2017,9 +2017,9 @@ static int il4965_get_ra_sta_id(struct il_priv *il, struct ieee80211_hdr *hdr)
 }
 
 /**
- * il4965_rx_reply_tx - Handle standard (non-aggregation) Tx response
+ * il4965_hdl_tx - Handle standard (non-aggregation) Tx response
  */
-static void il4965_rx_reply_tx(struct il_priv *il,
+static void il4965_hdl_tx(struct il_priv *il,
 				struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -2145,9 +2145,9 @@ static void il4965_rx_beacon_notif(struct il_priv *il,
 static void il4965_handler_setup(struct il_priv *il)
 {
 	/* Legacy Rx frames */
-	il->handlers[N_RX] = il4965_rx_reply_rx;
+	il->handlers[N_RX] = il4965_hdl_rx;
 	/* Tx response */
-	il->handlers[C_TX] = il4965_rx_reply_tx;
+	il->handlers[C_TX] = il4965_hdl_tx;
 	il->handlers[N_BEACON] = il4965_rx_beacon_notif;
 }
 
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 94cf7e7..a8acbbb 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -73,9 +73,9 @@ void il4965_rx_replenish_now(struct il_priv *il);
 void il4965_rx_queue_free(struct il_priv *il, struct il_rx_queue *rxq);
 int il4965_rxq_stop(struct il_priv *il);
 int il4965_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
-void il4965_rx_reply_rx(struct il_priv *il,
+void il4965_hdl_rx(struct il_priv *il,
 		     struct il_rx_buf *rxb);
-void il4965_rx_reply_rx_phy(struct il_priv *il,
+void il4965_hdl_rx_phy(struct il_priv *il,
 			 struct il_rx_buf *rxb);
 void il4965_rx_handle(struct il_priv *il);
 
@@ -95,7 +95,7 @@ int il4965_tx_agg_stop(struct il_priv *il, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid);
 int il4965_txq_check_empty(struct il_priv *il,
 			   int sta_id, u8 tid, int txq_id);
-void il4965_rx_reply_compressed_ba(struct il_priv *il,
+void il4965_hdl_compressed_ba(struct il_priv *il,
 				struct il_rx_buf *rxb);
 int il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx);
 void il4965_hw_txq_ctx_free(struct il_priv *il);
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index baed3dc..abb8d86 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -1213,7 +1213,7 @@ void il_rx_pm_debug_stats_notif(struct il_priv *il,
 }
 EXPORT_SYMBOL(il_rx_pm_debug_stats_notif);
 
-void il_rx_reply_error(struct il_priv *il,
+void il_hdl_error(struct il_priv *il,
 			struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -1226,7 +1226,7 @@ void il_rx_reply_error(struct il_priv *il,
 		le16_to_cpu(pkt->u.err_resp.bad_cmd_seq_num),
 		le32_to_cpu(pkt->u.err_resp.error_info));
 }
-EXPORT_SYMBOL(il_rx_reply_error);
+EXPORT_SYMBOL(il_hdl_error);
 
 void il_clear_isr_stats(struct il_priv *il)
 {
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index a3701a6..9897dac 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -373,7 +373,7 @@ void il_rx_pm_sleep_notif(struct il_priv *il,
 			   struct il_rx_buf *rxb);
 void il_rx_pm_debug_stats_notif(struct il_priv *il,
 				      struct il_rx_buf *rxb);
-void il_rx_reply_error(struct il_priv *il,
+void il_hdl_error(struct il_priv *il,
 			struct il_rx_buf *rxb);
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index 2bed3ae..f81db76 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -182,7 +182,7 @@ int il_scan_cancel_timeout(struct il_priv *il, unsigned long ms)
 EXPORT_SYMBOL(il_scan_cancel_timeout);
 
 /* Service response to C_SCAN (0x80) */
-static void il_rx_reply_scan(struct il_priv *il,
+static void il_hdl_scan(struct il_priv *il,
 			      struct il_rx_buf *rxb)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
@@ -263,7 +263,7 @@ static void il_rx_scan_complete_notif(struct il_priv *il,
 void il_setup_rx_scan_handlers(struct il_priv *il)
 {
 	/* scan handlers */
-	il->handlers[C_SCAN] = il_rx_reply_scan;
+	il->handlers[C_SCAN] = il_hdl_scan;
 	il->handlers[N_SCAN_START] =
 					il_rx_scan_start_notif;
 	il->handlers[N_SCAN_RESULTS] =
-- 
1.7.1

