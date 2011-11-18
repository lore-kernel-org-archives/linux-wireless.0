Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab1KRIW3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:29 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8MTaQ015840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:29 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 46/77] iwlegacy: rename other handlers
Date: Fri, 18 Nov 2011 09:22:08 +0100
Message-Id: <1321604559-10707-46-git-send-email-sgruszka@redhat.com> (sfid-20111118_092235_336705_EF53D42A)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |   20 ++++++++++----------
 drivers/net/wireless/iwlegacy/3945.c     |    6 +++---
 drivers/net/wireless/iwlegacy/3945.h     |    4 ++--
 drivers/net/wireless/iwlegacy/4965-mac.c |   30 +++++++++++++++---------------
 drivers/net/wireless/iwlegacy/4965.c     |    4 ++--
 drivers/net/wireless/iwlegacy/4965.h     |    6 +++---
 drivers/net/wireless/iwlegacy/iwl-core.c |   12 ++++++------
 drivers/net/wireless/iwlegacy/iwl-core.h |    8 ++++----
 drivers/net/wireless/iwlegacy/iwl-rx.c   |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-scan.c |   12 ++++++------
 10 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index e9a1e64..e33ebca 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -789,7 +789,7 @@ static void il3945_hdl_add_sta(struct il_priv *il,
 	D_RX("Received C_ADD_STA: 0x%02X\n", pkt->u.status);
 }
 
-static void il3945_rx_beacon_notif(struct il_priv *il,
+static void il3945_hdl_beacon(struct il_priv *il,
 				struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -812,7 +812,7 @@ static void il3945_rx_beacon_notif(struct il_priv *il,
 
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
-static void il3945_rx_card_state_notif(struct il_priv *il,
+static void il3945_hdl_card_state(struct il_priv *il,
 				    struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -856,24 +856,24 @@ static void il3945_setup_handlers(struct il_priv *il)
 	il->handlers[N_ALIVE] = il3945_hdl_alive;
 	il->handlers[C_ADD_STA] = il3945_hdl_add_sta;
 	il->handlers[N_ERROR] = il_hdl_error;
-	il->handlers[N_CHANNEL_SWITCH] = il_rx_csa;
+	il->handlers[N_CHANNEL_SWITCH] = il_hdl_csa;
 	il->handlers[N_SPECTRUM_MEASUREMENT] =
-			il_rx_spectrum_measure_notif;
-	il->handlers[N_PM_SLEEP] = il_rx_pm_sleep_notif;
+			il_hdl_spectrum_measurement;
+	il->handlers[N_PM_SLEEP] = il_hdl_pm_sleep;
 	il->handlers[N_PM_DEBUG_STATS] =
-	    il_rx_pm_debug_stats_notif;
-	il->handlers[N_BEACON] = il3945_rx_beacon_notif;
+	    il_hdl_pm_debug_stats;
+	il->handlers[N_BEACON] = il3945_hdl_beacon;
 
 	/*
 	 * The same handler is used for both the REPLY to a discrete
 	 * stats request from the host as well as for the periodic
 	 * stats notifications (after received beacons) from the uCode.
 	 */
-	il->handlers[C_STATS] = il3945_reply_stats;
-	il->handlers[N_STATS] = il3945_hw_rx_stats;
+	il->handlers[C_STATS] = il3945_hdl_c_stats;
+	il->handlers[N_STATS] = il3945_hdl_stats;
 
 	il_setup_rx_scan_handlers(il);
-	il->handlers[N_CARD_STATE] = il3945_rx_card_state_notif;
+	il->handlers[N_CARD_STATE] = il3945_hdl_card_state;
 
 	/* Set up hardware specific Rx handlers */
 	il3945_hw_handler_setup(il);
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index b45905f..83fe531 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -411,7 +411,7 @@ static void il3945_accumulative_stats(struct il_priv *il,
 }
 #endif
 
-void il3945_hw_rx_stats(struct il_priv *il,
+void il3945_hdl_stats(struct il_priv *il,
 		struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -426,7 +426,7 @@ void il3945_hw_rx_stats(struct il_priv *il,
 	memcpy(&il->_3945.stats, pkt->u.raw, sizeof(il->_3945.stats));
 }
 
-void il3945_reply_stats(struct il_priv *il,
+void il3945_hdl_c_stats(struct il_priv *il,
 			      struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -443,7 +443,7 @@ void il3945_reply_stats(struct il_priv *il,
 #endif
 		D_RX("Statistics have been cleared\n");
 	}
-	il3945_hw_rx_stats(il, rxb);
+	il3945_hdl_stats(il, rxb);
 }
 
 
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index 6000aff..9854cf1 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -253,9 +253,9 @@ void il3945_hw_build_tx_cmd_rate(struct il_priv *il,
 				  int sta_id, int tx_id);
 extern int il3945_hw_reg_send_txpower(struct il_priv *il);
 extern int il3945_hw_reg_set_txpower(struct il_priv *il, s8 power);
-extern void il3945_hw_rx_stats(struct il_priv *il,
+extern void il3945_hdl_stats(struct il_priv *il,
 				 struct il_rx_buf *rxb);
-void il3945_reply_stats(struct il_priv *il,
+void il3945_hdl_c_stats(struct il_priv *il,
 			      struct il_rx_buf *rxb);
 extern void il3945_disable_events(struct il_priv *il);
 extern int il4965_get_temperature(const struct il_priv *il);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 0797c11..2bab0fc 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1242,7 +1242,7 @@ int il4965_dump_fh(struct il_priv *il, char **buf, bool display)
 	}
 	return 0;
 }
-void il4965_rx_missed_beacon_notif(struct il_priv *il,
+void il4965_hdl_missed_beacon(struct il_priv *il,
 				struct il_rx_buf *rxb)
 
 {
@@ -1352,7 +1352,7 @@ static void il4965_accumulative_stats(struct il_priv *il,
 
 #define REG_RECALIB_PERIOD (60)
 
-void il4965_rx_stats(struct il_priv *il,
+void il4965_hdl_stats(struct il_priv *il,
 			      struct il_rx_buf *rxb)
 {
 	int change;
@@ -1396,7 +1396,7 @@ void il4965_rx_stats(struct il_priv *il,
 		il->cfg->ops->lib->temp_ops.temperature(il);
 }
 
-void il4965_reply_stats(struct il_priv *il,
+void il4965_hdl_c_stats(struct il_priv *il,
 			      struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -1412,7 +1412,7 @@ void il4965_reply_stats(struct il_priv *il,
 #endif
 		D_RX("Statistics have been cleared\n");
 	}
-	il4965_rx_stats(il, rxb);
+	il4965_hdl_stats(il, rxb);
 }
 
 
@@ -3819,7 +3819,7 @@ static void il4965_bg_stats_periodic(unsigned long data)
 	il_send_stats_request(il, CMD_ASYNC, false);
 }
 
-static void il4965_rx_beacon_notif(struct il_priv *il,
+static void il4965_hdl_beacon(struct il_priv *il,
 				struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -3861,7 +3861,7 @@ static void il4965_perform_ct_kill_task(struct il_priv *il)
 
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
-static void il4965_rx_card_state_notif(struct il_priv *il,
+static void il4965_hdl_card_state(struct il_priv *il,
 				    struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -3923,30 +3923,30 @@ static void il4965_setup_handlers(struct il_priv *il)
 {
 	il->handlers[N_ALIVE] = il4965_hdl_alive;
 	il->handlers[N_ERROR] = il_hdl_error;
-	il->handlers[N_CHANNEL_SWITCH] = il_rx_csa;
+	il->handlers[N_CHANNEL_SWITCH] = il_hdl_csa;
 	il->handlers[N_SPECTRUM_MEASUREMENT] =
-			il_rx_spectrum_measure_notif;
-	il->handlers[N_PM_SLEEP] = il_rx_pm_sleep_notif;
+			il_hdl_spectrum_measurement;
+	il->handlers[N_PM_SLEEP] = il_hdl_pm_sleep;
 	il->handlers[N_PM_DEBUG_STATS] =
-	    il_rx_pm_debug_stats_notif;
-	il->handlers[N_BEACON] = il4965_rx_beacon_notif;
+	    il_hdl_pm_debug_stats;
+	il->handlers[N_BEACON] = il4965_hdl_beacon;
 
 	/*
 	 * The same handler is used for both the REPLY to a discrete
 	 * stats request from the host as well as for the periodic
 	 * stats notifications (after received beacons) from the uCode.
 	 */
-	il->handlers[C_STATS] = il4965_reply_stats;
-	il->handlers[N_STATS] = il4965_rx_stats;
+	il->handlers[C_STATS] = il4965_hdl_c_stats;
+	il->handlers[N_STATS] = il4965_hdl_stats;
 
 	il_setup_rx_scan_handlers(il);
 
 	/* status change handler */
 	il->handlers[N_CARD_STATE] =
-					il4965_rx_card_state_notif;
+					il4965_hdl_card_state;
 
 	il->handlers[N_MISSED_BEACONS] =
-	    il4965_rx_missed_beacon_notif;
+	    il4965_hdl_missed_beacon;
 	/* Rx handlers */
 	il->handlers[N_RX_PHY] = il4965_hdl_rx_phy;
 	il->handlers[N_RX_MPDU] = il4965_hdl_rx;
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 726fc80..ed2c617 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -2122,7 +2122,7 @@ static void il4965_hdl_tx(struct il_priv *il,
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 }
 
-static void il4965_rx_beacon_notif(struct il_priv *il,
+static void il4965_hdl_beacon(struct il_priv *il,
 				    struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -2148,7 +2148,7 @@ static void il4965_handler_setup(struct il_priv *il)
 	il->handlers[N_RX] = il4965_hdl_rx;
 	/* Tx response */
 	il->handlers[C_TX] = il4965_hdl_tx;
-	il->handlers[N_BEACON] = il4965_rx_beacon_notif;
+	il->handlers[N_BEACON] = il4965_hdl_beacon;
 }
 
 static struct il_hcmd_ops il4965_hcmd = {
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index a8acbbb..5234de7 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -122,13 +122,13 @@ void il4965_tx_queue_set_status(struct il_priv *il,
 u8 il4965_toggle_tx_ant(struct il_priv *il, u8 ant_idx, u8 valid);
 
 /* rx */
-void il4965_rx_missed_beacon_notif(struct il_priv *il,
+void il4965_hdl_missed_beacon(struct il_priv *il,
 				struct il_rx_buf *rxb);
 bool il4965_good_plcp_health(struct il_priv *il,
 			  struct il_rx_pkt *pkt);
-void il4965_rx_stats(struct il_priv *il,
+void il4965_hdl_stats(struct il_priv *il,
 		       struct il_rx_buf *rxb);
-void il4965_reply_stats(struct il_priv *il,
+void il4965_hdl_c_stats(struct il_priv *il,
 			  struct il_rx_buf *rxb);
 
 /* scan */
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index abb8d86..856a321 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -847,7 +847,7 @@ void il_chswitch_done(struct il_priv *il, bool is_success)
 }
 EXPORT_SYMBOL(il_chswitch_done);
 
-void il_rx_csa(struct il_priv *il, struct il_rx_buf *rxb)
+void il_hdl_csa(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_csa_notification *csa = &(pkt->u.csa_notif);
@@ -870,7 +870,7 @@ void il_rx_csa(struct il_priv *il, struct il_rx_buf *rxb)
 		il_chswitch_done(il, false);
 	}
 }
-EXPORT_SYMBOL(il_rx_csa);
+EXPORT_SYMBOL(il_hdl_csa);
 
 #ifdef CONFIG_IWLEGACY_DEBUG
 void il_print_rx_config_cmd(struct il_priv *il,
@@ -1189,7 +1189,7 @@ int il_send_stats_request(struct il_priv *il, u8 flags, bool clear)
 }
 EXPORT_SYMBOL(il_send_stats_request);
 
-void il_rx_pm_sleep_notif(struct il_priv *il,
+void il_hdl_pm_sleep(struct il_priv *il,
 			   struct il_rx_buf *rxb)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
@@ -1199,9 +1199,9 @@ void il_rx_pm_sleep_notif(struct il_priv *il,
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
 #endif
 }
-EXPORT_SYMBOL(il_rx_pm_sleep_notif);
+EXPORT_SYMBOL(il_hdl_pm_sleep);
 
-void il_rx_pm_debug_stats_notif(struct il_priv *il,
+void il_hdl_pm_debug_stats(struct il_priv *il,
 				      struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -1211,7 +1211,7 @@ void il_rx_pm_debug_stats_notif(struct il_priv *il,
 			il_get_cmd_string(pkt->hdr.cmd));
 	il_print_hex_dump(il, IL_DL_RADIO, pkt->u.raw, len);
 }
-EXPORT_SYMBOL(il_rx_pm_debug_stats_notif);
+EXPORT_SYMBOL(il_hdl_pm_debug_stats);
 
 void il_hdl_error(struct il_priv *il,
 			struct il_rx_buf *rxb)
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index 9897dac..5de742c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -369,9 +369,9 @@ static inline void il_update_stats(struct il_priv *il, bool is_tx,
 /*****************************************************
  * RX handlers.
  * **************************************************/
-void il_rx_pm_sleep_notif(struct il_priv *il,
+void il_hdl_pm_sleep(struct il_priv *il,
 			   struct il_rx_buf *rxb);
-void il_rx_pm_debug_stats_notif(struct il_priv *il,
+void il_hdl_pm_debug_stats(struct il_priv *il,
 				      struct il_rx_buf *rxb);
 void il_hdl_error(struct il_priv *il,
 			struct il_rx_buf *rxb);
@@ -388,12 +388,12 @@ int il_rx_queue_space(const struct il_rx_queue *q);
 void il_tx_cmd_complete(struct il_priv *il,
 				struct il_rx_buf *rxb);
 /* Handlers */
-void il_rx_spectrum_measure_notif(struct il_priv *il,
+void il_hdl_spectrum_measurement(struct il_priv *il,
 					  struct il_rx_buf *rxb);
 void il_recover_from_stats(struct il_priv *il,
 				struct il_rx_pkt *pkt);
 void il_chswitch_done(struct il_priv *il, bool is_success);
-void il_rx_csa(struct il_priv *il, struct il_rx_buf *rxb);
+void il_hdl_csa(struct il_priv *il, struct il_rx_buf *rxb);
 
 /* TX helpers */
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
index 76f2361..7a8ae55 100644
--- a/drivers/net/wireless/iwlegacy/iwl-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
@@ -210,7 +210,7 @@ err_bd:
 EXPORT_SYMBOL(il_rx_queue_alloc);
 
 
-void il_rx_spectrum_measure_notif(struct il_priv *il,
+void il_hdl_spectrum_measurement(struct il_priv *il,
 					  struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -225,7 +225,7 @@ void il_rx_spectrum_measure_notif(struct il_priv *il,
 	memcpy(&il->measure_report, report, sizeof(*report));
 	il->measurement_status |= MEASUREMENT_READY;
 }
-EXPORT_SYMBOL(il_rx_spectrum_measure_notif);
+EXPORT_SYMBOL(il_hdl_spectrum_measurement);
 
 /*
  * returns non-zero if packet should be dropped
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index f81db76..aaa589a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -195,7 +195,7 @@ static void il_hdl_scan(struct il_priv *il,
 }
 
 /* Service N_SCAN_START (0x82) */
-static void il_rx_scan_start_notif(struct il_priv *il,
+static void il_hdl_scan_start(struct il_priv *il,
 				    struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -213,7 +213,7 @@ static void il_rx_scan_start_notif(struct il_priv *il,
 }
 
 /* Service N_SCAN_RESULTS (0x83) */
-static void il_rx_scan_results_notif(struct il_priv *il,
+static void il_hdl_scan_results(struct il_priv *il,
 				      struct il_rx_buf *rxb)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
@@ -235,7 +235,7 @@ static void il_rx_scan_results_notif(struct il_priv *il,
 }
 
 /* Service N_SCAN_COMPLETE (0x84) */
-static void il_rx_scan_complete_notif(struct il_priv *il,
+static void il_hdl_scan_complete(struct il_priv *il,
 				       struct il_rx_buf *rxb)
 {
 
@@ -265,11 +265,11 @@ void il_setup_rx_scan_handlers(struct il_priv *il)
 	/* scan handlers */
 	il->handlers[C_SCAN] = il_hdl_scan;
 	il->handlers[N_SCAN_START] =
-					il_rx_scan_start_notif;
+					il_hdl_scan_start;
 	il->handlers[N_SCAN_RESULTS] =
-					il_rx_scan_results_notif;
+					il_hdl_scan_results;
 	il->handlers[N_SCAN_COMPLETE] =
-					il_rx_scan_complete_notif;
+					il_hdl_scan_complete;
 }
 EXPORT_SYMBOL(il_setup_rx_scan_handlers);
 
-- 
1.7.1

