Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753Ab1KRIW0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:26 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8MQpP022761
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:26 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 44/77] iwlegacy: s/rx_handler/handler/
Date: Fri, 18 Nov 2011 09:22:06 +0100
Message-Id: <1321604559-10707-44-git-send-email-sgruszka@redhat.com> (sfid-20111118_092244_473415_55804F5C)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c    |   42 ++++++++++++------------
 drivers/net/wireless/iwlegacy/3945.c        |    6 ++--
 drivers/net/wireless/iwlegacy/3945.h        |    2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c    |   48 +++++++++++++-------------
 drivers/net/wireless/iwlegacy/4965.c        |   10 +++---
 drivers/net/wireless/iwlegacy/iwl-core.h    |    2 +-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c |    4 +-
 drivers/net/wireless/iwlegacy/iwl-dev.h     |    4 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c    |    8 ++--
 9 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 65cab84..fa5e038 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -843,7 +843,7 @@ static void il3945_rx_card_state_notif(struct il_priv *il,
 }
 
 /**
- * il3945_setup_rx_handlers - Initialize Rx handler callbacks
+ * il3945_setup_handlers - Initialize Rx handler callbacks
  *
  * Setup the RX handlers for each of the reply types sent from the uCode
  * to the host.
@@ -851,32 +851,32 @@ static void il3945_rx_card_state_notif(struct il_priv *il,
  * This function chains into the hardware specific files for them to setup
  * any hardware specific handlers as well.
  */
-static void il3945_setup_rx_handlers(struct il_priv *il)
+static void il3945_setup_handlers(struct il_priv *il)
 {
-	il->rx_handlers[N_ALIVE] = il3945_rx_reply_alive;
-	il->rx_handlers[C_ADD_STA] = il3945_rx_reply_add_sta;
-	il->rx_handlers[N_ERROR] = il_rx_reply_error;
-	il->rx_handlers[N_CHANNEL_SWITCH] = il_rx_csa;
-	il->rx_handlers[N_SPECTRUM_MEASUREMENT] =
+	il->handlers[N_ALIVE] = il3945_rx_reply_alive;
+	il->handlers[C_ADD_STA] = il3945_rx_reply_add_sta;
+	il->handlers[N_ERROR] = il_rx_reply_error;
+	il->handlers[N_CHANNEL_SWITCH] = il_rx_csa;
+	il->handlers[N_SPECTRUM_MEASUREMENT] =
 			il_rx_spectrum_measure_notif;
-	il->rx_handlers[N_PM_SLEEP] = il_rx_pm_sleep_notif;
-	il->rx_handlers[N_PM_DEBUG_STATS] =
+	il->handlers[N_PM_SLEEP] = il_rx_pm_sleep_notif;
+	il->handlers[N_PM_DEBUG_STATS] =
 	    il_rx_pm_debug_stats_notif;
-	il->rx_handlers[N_BEACON] = il3945_rx_beacon_notif;
+	il->handlers[N_BEACON] = il3945_rx_beacon_notif;
 
 	/*
 	 * The same handler is used for both the REPLY to a discrete
 	 * stats request from the host as well as for the periodic
 	 * stats notifications (after received beacons) from the uCode.
 	 */
-	il->rx_handlers[C_STATS] = il3945_reply_stats;
-	il->rx_handlers[N_STATS] = il3945_hw_rx_stats;
+	il->handlers[C_STATS] = il3945_reply_stats;
+	il->handlers[N_STATS] = il3945_hw_rx_stats;
 
 	il_setup_rx_scan_handlers(il);
-	il->rx_handlers[N_CARD_STATE] = il3945_rx_card_state_notif;
+	il->handlers[N_CARD_STATE] = il3945_rx_card_state_notif;
 
 	/* Set up hardware specific Rx handlers */
-	il3945_hw_rx_handler_setup(il);
+	il3945_hw_handler_setup(il);
 }
 
 /************************** RX-FUNCTIONS ****************************/
@@ -1194,7 +1194,7 @@ int il3945_calc_db_from_ratio(int sig_ratio)
 /**
  * il3945_rx_handle - Main entry function for receiving responses from uCode
  *
- * Uses the il->rx_handlers callback function array to invoke
+ * Uses the il->handlers callback function array to invoke
  * the appropriate handlers, including command responses,
  * frame-received notifications, and other notifications.
  */
@@ -1258,12 +1258,12 @@ static void il3945_rx_handle(struct il_priv *il)
 
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
-		 *   rx_handlers table.  See il3945_setup_rx_handlers() */
-		if (il->rx_handlers[pkt->hdr.cmd]) {
+		 *   handlers table.  See il3945_setup_handlers() */
+		if (il->handlers[pkt->hdr.cmd]) {
 			D_RX("r = %d, i = %d, %s, 0x%02x\n", r, i,
 			il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
-			il->isr_stats.rx_handlers[pkt->hdr.cmd]++;
-			il->rx_handlers[pkt->hdr.cmd] (il, rxb);
+			il->isr_stats.handlers[pkt->hdr.cmd]++;
+			il->handlers[pkt->hdr.cmd] (il, rxb);
 		} else {
 			/* No handling needed */
 			D_RX(
@@ -1275,7 +1275,7 @@ static void il3945_rx_handle(struct il_priv *il)
 		/*
 		 * XXX: After here, we should always check rxb->page
 		 * against NULL before touching it or its virtual
-		 * memory (pkt). Because some rx_handler might have
+		 * memory (pkt). Because some handler might have
 		 * already taken or freed the pages.
 		 */
 
@@ -3807,7 +3807,7 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 			     &il->bands[IEEE80211_BAND_2GHZ].channels[5],
 			     &il->ctx);
 	il3945_setup_deferred_work(il);
-	il3945_setup_rx_handlers(il);
+	il3945_setup_handlers(il);
 	il_power_initialize(il);
 
 	/*********************************
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index ba250f7..94d540c 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -2462,10 +2462,10 @@ unsigned int il3945_hw_get_beacon_cmd(struct il_priv *il,
 	return sizeof(struct il3945_tx_beacon_cmd) + frame_size;
 }
 
-void il3945_hw_rx_handler_setup(struct il_priv *il)
+void il3945_hw_handler_setup(struct il_priv *il)
 {
-	il->rx_handlers[C_TX] = il3945_rx_reply_tx;
-	il->rx_handlers[N_3945_RX] = il3945_rx_reply_rx;
+	il->handlers[C_TX] = il3945_rx_reply_tx;
+	il->handlers[N_3945_RX] = il3945_rx_reply_rx;
 }
 
 void il3945_hw_setup_deferred_work(struct il_priv *il)
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index d65565f..6000aff 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -225,7 +225,7 @@ extern void il3945_dump_nic_error_log(struct il_priv *il);
  * il3945_mac_     <-- mac80211 callback
  *
  ****************************************************************************/
-extern void il3945_hw_rx_handler_setup(struct il_priv *il);
+extern void il3945_hw_handler_setup(struct il_priv *il);
 extern void il3945_hw_setup_deferred_work(struct il_priv *il);
 extern void il3945_hw_cancel_deferred_work(struct il_priv *il);
 extern int il3945_hw_rxq_stop(struct il_priv *il);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 098d863..d82d05f 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -3911,7 +3911,7 @@ static void il4965_rx_card_state_notif(struct il_priv *il,
 }
 
 /**
- * il4965_setup_rx_handlers - Initialize Rx handler callbacks
+ * il4965_setup_handlers - Initialize Rx handler callbacks
  *
  * Setup the RX handlers for each of the reply types sent from the uCode
  * to the host.
@@ -3919,47 +3919,47 @@ static void il4965_rx_card_state_notif(struct il_priv *il,
  * This function chains into the hardware specific files for them to setup
  * any hardware specific handlers as well.
  */
-static void il4965_setup_rx_handlers(struct il_priv *il)
+static void il4965_setup_handlers(struct il_priv *il)
 {
-	il->rx_handlers[N_ALIVE] = il4965_rx_reply_alive;
-	il->rx_handlers[N_ERROR] = il_rx_reply_error;
-	il->rx_handlers[N_CHANNEL_SWITCH] = il_rx_csa;
-	il->rx_handlers[N_SPECTRUM_MEASUREMENT] =
+	il->handlers[N_ALIVE] = il4965_rx_reply_alive;
+	il->handlers[N_ERROR] = il_rx_reply_error;
+	il->handlers[N_CHANNEL_SWITCH] = il_rx_csa;
+	il->handlers[N_SPECTRUM_MEASUREMENT] =
 			il_rx_spectrum_measure_notif;
-	il->rx_handlers[N_PM_SLEEP] = il_rx_pm_sleep_notif;
-	il->rx_handlers[N_PM_DEBUG_STATS] =
+	il->handlers[N_PM_SLEEP] = il_rx_pm_sleep_notif;
+	il->handlers[N_PM_DEBUG_STATS] =
 	    il_rx_pm_debug_stats_notif;
-	il->rx_handlers[N_BEACON] = il4965_rx_beacon_notif;
+	il->handlers[N_BEACON] = il4965_rx_beacon_notif;
 
 	/*
 	 * The same handler is used for both the REPLY to a discrete
 	 * stats request from the host as well as for the periodic
 	 * stats notifications (after received beacons) from the uCode.
 	 */
-	il->rx_handlers[C_STATS] = il4965_reply_stats;
-	il->rx_handlers[N_STATS] = il4965_rx_stats;
+	il->handlers[C_STATS] = il4965_reply_stats;
+	il->handlers[N_STATS] = il4965_rx_stats;
 
 	il_setup_rx_scan_handlers(il);
 
 	/* status change handler */
-	il->rx_handlers[N_CARD_STATE] =
+	il->handlers[N_CARD_STATE] =
 					il4965_rx_card_state_notif;
 
-	il->rx_handlers[N_MISSED_BEACONS] =
+	il->handlers[N_MISSED_BEACONS] =
 	    il4965_rx_missed_beacon_notif;
 	/* Rx handlers */
-	il->rx_handlers[N_RX_PHY] = il4965_rx_reply_rx_phy;
-	il->rx_handlers[N_RX_MPDU] = il4965_rx_reply_rx;
+	il->handlers[N_RX_PHY] = il4965_rx_reply_rx_phy;
+	il->handlers[N_RX_MPDU] = il4965_rx_reply_rx;
 	/* block ack */
-	il->rx_handlers[N_COMPRESSED_BA] = il4965_rx_reply_compressed_ba;
+	il->handlers[N_COMPRESSED_BA] = il4965_rx_reply_compressed_ba;
 	/* Set up hardware specific Rx handlers */
-	il->cfg->ops->lib->rx_handler_setup(il);
+	il->cfg->ops->lib->handler_setup(il);
 }
 
 /**
  * il4965_rx_handle - Main entry function for receiving responses from uCode
  *
- * Uses the il->rx_handlers callback function array to invoke
+ * Uses the il->handlers callback function array to invoke
  * the appropriate handlers, including command responses,
  * frame-received notifications, and other notifications.
  */
@@ -4028,13 +4028,13 @@ void il4965_rx_handle(struct il_priv *il)
 
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
-		 *   rx_handlers table.  See il4965_setup_rx_handlers() */
-		if (il->rx_handlers[pkt->hdr.cmd]) {
+		 *   handlers table.  See il4965_setup_handlers() */
+		if (il->handlers[pkt->hdr.cmd]) {
 			D_RX("r = %d, i = %d, %s, 0x%02x\n", r,
 				i, il_get_cmd_string(pkt->hdr.cmd),
 				pkt->hdr.cmd);
-			il->isr_stats.rx_handlers[pkt->hdr.cmd]++;
-			il->rx_handlers[pkt->hdr.cmd] (il, rxb);
+			il->isr_stats.handlers[pkt->hdr.cmd]++;
+			il->handlers[pkt->hdr.cmd] (il, rxb);
 		} else {
 			/* No handling needed */
 			D_RX(
@@ -4046,7 +4046,7 @@ void il4965_rx_handle(struct il_priv *il)
 		/*
 		 * XXX: After here, we should always check rxb->page
 		 * against NULL before touching it or its virtual
-		 * memory (pkt). Because some rx_handler might have
+		 * memory (pkt). Because some handler might have
 		 * already taken or freed the pages.
 		 */
 
@@ -6358,7 +6358,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	il4965_setup_deferred_work(il);
-	il4965_setup_rx_handlers(il);
+	il4965_setup_handlers(il);
 
 	/*********************************************
 	 * 8. Enable interrupts and read RFKILL state
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 3b101c1..f48cb89 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -2142,13 +2142,13 @@ static void il4965_rx_beacon_notif(struct il_priv *il,
 }
 
 /* Set up 4965-specific Rx frame reply handlers */
-static void il4965_rx_handler_setup(struct il_priv *il)
+static void il4965_handler_setup(struct il_priv *il)
 {
 	/* Legacy Rx frames */
-	il->rx_handlers[N_RX] = il4965_rx_reply_rx;
+	il->handlers[N_RX] = il4965_rx_reply_rx;
 	/* Tx response */
-	il->rx_handlers[C_TX] = il4965_rx_reply_tx;
-	il->rx_handlers[N_BEACON] = il4965_rx_beacon_notif;
+	il->handlers[C_TX] = il4965_rx_reply_tx;
+	il->handlers[N_BEACON] = il4965_rx_beacon_notif;
 }
 
 static struct il_hcmd_ops il4965_hcmd = {
@@ -2316,7 +2316,7 @@ static struct il_lib_ops il4965_lib = {
 	.txq_attach_buf_to_tfd = il4965_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = il4965_hw_txq_free_tfd,
 	.txq_init = il4965_hw_tx_queue_init,
-	.rx_handler_setup = il4965_rx_handler_setup,
+	.handler_setup = il4965_handler_setup,
 	.is_valid_rtc_data_addr = il4965_hw_valid_rtc_data_addr,
 	.init_alive_start = il4965_init_alive_start,
 	.load_ucode = il4965_load_bsm,
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index e275ffc..a3701a6 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -136,7 +136,7 @@ struct il_lib_ops {
 	int (*txq_init)(struct il_priv *il,
 			struct il_tx_queue *txq);
 	/* setup Rx handler */
-	void (*rx_handler_setup)(struct il_priv *il);
+	void (*handler_setup)(struct il_priv *il);
 	/* alive notification after init uCode load */
 	void (*init_alive_start)(struct il_priv *il);
 	/* check validity of rtc data address */
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index 4076b79..3f6b06e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -555,11 +555,11 @@ static ssize_t il_dbgfs_interrupt_read(struct file *file,
 		"Rx command responses:\t\t %u\n",
 		il->isr_stats.rx);
 	for (cnt = 0; cnt < IL_CN_MAX; cnt++) {
-		if (il->isr_stats.rx_handlers[cnt] > 0)
+		if (il->isr_stats.handlers[cnt] > 0)
 			pos += scnprintf(buf + pos, bufsz - pos,
 				"\tRx handler[%36s]:\t\t %u\n",
 				il_get_cmd_string(cnt),
-				il->isr_stats.rx_handlers[cnt]);
+				il->isr_stats.handlers[cnt]);
 	}
 
 	pos += scnprintf(buf + pos, bufsz - pos, "Tx/FH interrupt:\t\t %u\n",
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index 1bc4a71..2ebd807 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -813,7 +813,7 @@ struct isr_stats {
 	u32 ctkill;
 	u32 wakeup;
 	u32 rx;
-	u32 rx_handlers[IL_CN_MAX];
+	u32 handlers[IL_CN_MAX];
 	u32 tx;
 	u32 unhandled;
 };
@@ -968,7 +968,7 @@ struct il_priv {
 	enum ieee80211_band band;
 	int alloc_rxb_page;
 
-	void (*rx_handlers[IL_CN_MAX])(struct il_priv *il,
+	void (*handlers[IL_CN_MAX])(struct il_priv *il,
 				       struct il_rx_buf *rxb);
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index 1f81d56..2bed3ae 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -263,12 +263,12 @@ static void il_rx_scan_complete_notif(struct il_priv *il,
 void il_setup_rx_scan_handlers(struct il_priv *il)
 {
 	/* scan handlers */
-	il->rx_handlers[C_SCAN] = il_rx_reply_scan;
-	il->rx_handlers[N_SCAN_START] =
+	il->handlers[C_SCAN] = il_rx_reply_scan;
+	il->handlers[N_SCAN_START] =
 					il_rx_scan_start_notif;
-	il->rx_handlers[N_SCAN_RESULTS] =
+	il->handlers[N_SCAN_RESULTS] =
 					il_rx_scan_results_notif;
-	il->rx_handlers[N_SCAN_COMPLETE] =
+	il->handlers[N_SCAN_COMPLETE] =
 					il_rx_scan_complete_notif;
 }
 EXPORT_SYMBOL(il_setup_rx_scan_handlers);
-- 
1.7.1

