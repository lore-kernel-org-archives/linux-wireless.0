Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60582 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764173AbXHFVUB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 17:20:01 -0400
From: Ben Cahill <ben_m_cahill@linux.intel.com>
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Cc: Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 1/1]iwlwifi: Recognize MAC_CLK_ACTV interrupts
Date: Mon,  6 Aug 2007 14:03:41 -0700
Message-Id: <11864342213534-git-send-email-ben_m_cahill@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Recognize MAC_CLK_ACTV interrupts

Streamline missing hardware detection in ISR

Enhance ISR/RX/CMD debug messages

Make sure all commands are in get_cmd_string(), remove 2 unused cmds

Enhance comments

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
---
 origin/iwl-base.c     |   92 +++++++++++++++++++++++++++++++++---------------
 origin/iwl-commands.h |    5 +--
 origin/iwl-hw.h       |    1 +
 3 files changed, 65 insertions(+), 33 deletions(-)

diff --git a/origin/iwl-base.c b/origin/iwl-base.c
index 8863953..d47509e 100644
--- a/origin/iwl-base.c
+++ b/origin/iwl-base.c
@@ -514,41 +514,61 @@ static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 static const char *get_cmd_string(u8 cmd)
 {
 	switch (cmd) {
-		IWL_CMD(SCAN_START_NOTIFICATION);
-		IWL_CMD(SCAN_RESULTS_NOTIFICATION);
-		IWL_CMD(SCAN_COMPLETE_NOTIFICATION);
-		IWL_CMD(STATISTICS_NOTIFICATION);
 		IWL_CMD(REPLY_ALIVE);
 		IWL_CMD(REPLY_ERROR);
-		IWL_CMD(REPLY_RXON_ASSOC);
 		IWL_CMD(REPLY_RXON);
+		IWL_CMD(REPLY_RXON_ASSOC);
 		IWL_CMD(REPLY_QOS_PARAM);
 		IWL_CMD(REPLY_RXON_TIMING);
 		IWL_CMD(REPLY_ADD_STA);
+#if IWL == 3945
+		IWL_CMD(REPLY_REMOVE_STA);
+		IWL_CMD(REPLY_REMOVE_ALL_STA);
+		IWL_CMD(REPLY_3945_RX);
+#endif
 		IWL_CMD(REPLY_TX);
 		IWL_CMD(REPLY_BCON);
+#if IWL == 4965
+		IWL_CMD(REPLY_SHUTDOWN);
+#endif
 		IWL_CMD(REPLY_RATE_SCALE);
 		IWL_CMD(REPLY_LEDS_CMD);
+		IWL_CMD(REPLY_TX_LINK_QUALITY_CMD);
+		IWL_CMD(RADAR_NOTIFICATION);
+		IWL_CMD(REPLY_QUIET_CMD);
+		IWL_CMD(REPLY_CHANNEL_SWITCH);
+		IWL_CMD(CHANNEL_SWITCH_NOTIFICATION);
+		IWL_CMD(REPLY_SPECTRUM_MEASUREMENT_CMD);
+		IWL_CMD(SPECTRUM_MEASURE_NOTIFICATION);
+		IWL_CMD(POWER_TABLE_CMD);
+		IWL_CMD(PM_SLEEP_NOTIFICATION);
+		IWL_CMD(PM_DEBUG_STATISTIC_NOTIFIC);
+		IWL_CMD(REPLY_SCAN_CMD);
 		IWL_CMD(REPLY_SCAN_ABORT_CMD);
+		IWL_CMD(SCAN_START_NOTIFICATION);
+		IWL_CMD(SCAN_RESULTS_NOTIFICATION);
+		IWL_CMD(SCAN_COMPLETE_NOTIFICATION);
+		IWL_CMD(BEACON_NOTIFICATION);
 		IWL_CMD(REPLY_TX_BEACON);
-		IWL_CMD(REPLY_BT_CONFIG);
-		IWL_CMD(REPLY_SCAN_CMD);
+		IWL_CMD(WHO_IS_AWAKE_NOTIFICATION);
+		IWL_CMD(QUIET_NOTIFICATION);
 		IWL_CMD(REPLY_TX_PWR_TABLE_CMD);
+		IWL_CMD(MEASURE_ABORT_NOTIFICATION);
+		IWL_CMD(REPLY_BT_CONFIG);
 		IWL_CMD(REPLY_STATISTICS_CMD);
+		IWL_CMD(STATISTICS_NOTIFICATION);
 		IWL_CMD(REPLY_CARD_STATE_CMD);
-		IWL_CMD(REPLY_TX_LINK_QUALITY_CMD);
-#if IWL == 3945
-		IWL_CMD(REPLY_3945_RX);
-#elif IWL == 4965
-		IWL_CMD(MISSED_BEACONS_NOTIFICATION_TH_CMD);
+		IWL_CMD(CARD_STATE_NOTIFICATION);
+		IWL_CMD(MISSED_BEACONS_NOTIFICATION);
+#if IWL == 4965
 		IWL_CMD(REPLY_CT_KILL_CONFIG_CMD);
 		IWL_CMD(SENSITIVITY_CMD);
-		IWL_CMD(REPLY_RX_MPDU_CMD);
+		IWL_CMD(REPLY_PHY_CALIBRATION_CMD);
 		IWL_CMD(REPLY_RX_PHY_CMD);
+		IWL_CMD(REPLY_RX_MPDU_CMD);
 		IWL_CMD(REPLY_4965_RX);
+		IWL_CMD(REPLY_COMPRESSED_BA);
 #endif
-	case POWER_TABLE_CMD:
-		return "POWER_TABLE_CMD";
 	default:
 		return "UNKNOWN";
 
@@ -4565,8 +4585,8 @@ int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm)
  * iwl_rx_handle - Main entry function for receiving responses from the uCode
  *
  * Uses the priv->rx_handlers callback function array to invoke
- * the appropriate handlers including command response and 802.11
- * frame availability.
+ * the appropriate handlers, including command responses,
+ * frame-received notifications, and other notifications.
  */
 static void iwl_rx_handle(struct iwl_priv *priv)
 {
@@ -4580,6 +4600,10 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 	r = iwl_hw_get_rx_read(priv);
 	i = rxq->read;
 
+	/* Rx interrupt, but nothing sent from uCode */
+	if (i == r)
+		IWL_DEBUG(IWL_DL_RX | IWL_DL_ISR, "r = %d, i = %d\n", r, i);
+
 	while (i != r) {
 		rxb = rxq->queue[i];
 
@@ -4595,7 +4619,12 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 					    PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
-		/* need to reclaim cmd buffer(s) */
+		/* Reclaim a command buffer only if this packet is a response
+		 *   to a (driver-originated) command.
+		 * If the packet (e.g. Rx frame) originated from uCode,
+		 *   there is no command buffer to reclaim.
+		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
+		 *   but apparently a few don't get set; catch them here. */
 		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
 #if IWL == 4965
 			(pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
@@ -4608,21 +4637,22 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		 *   handle those that need handling via function in
 		 *   rx_handlers table.  See iwl_setup_rx_handlers() */
 		if (priv->rx_handlers[pkt->hdr.cmd]) {
+			IWL_DEBUG(IWL_DL_HOST_COMMAND | IWL_DL_RX | IWL_DL_ISR,
+				"r = %d, i = %d, %s, 0x%02x\n", r, i,
+				get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
-			IWL_DEBUG(IWL_DL_RX | IWL_DL_ISR,
-				"r = %d, i = %d, rx_handler %s\n", r, i,
-				get_cmd_string(pkt->hdr.cmd));
 		} else {
 			/* No handling needed */
-			IWL_DEBUG_HC("UNHANDLED - #0x%02x %s\n",
-				     pkt->hdr.cmd,
-				     get_cmd_string(pkt->hdr.cmd));
+			IWL_DEBUG(IWL_DL_HOST_COMMAND | IWL_DL_RX | IWL_DL_ISR,
+				"r %d i %d No handler needed for %s, 0x%02x\n",
+				r, i, get_cmd_string(pkt->hdr.cmd),
+				pkt->hdr.cmd);
 		}
 
 		if (reclaim) {
-			/* Invoke any callbacks, transfer the skb to
-			 * caller, and fire off the (possibly) blocking
-			 * iwl_send_cmd() via as we reclaim the queue... */
+			/* Invoke any callbacks, transfer the skb to caller,
+			 * and fire off the (possibly) blocking iwl_send_cmd()
+			 * as we reclaim the driver command queue */
 			if (rxb && rxb->skb)
 				iwl_tx_cmd_complete(priv, rxb);
 			else
@@ -5080,6 +5110,11 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		handled |= BIT_INT_SWERROR;
 	}
 
+	if (inta & BIT_INT_MAC_CLK_ACTV) {
+		IWL_DEBUG_ISR("Microcode started or stopped.\n");
+		handled |= BIT_INT_MAC_CLK_ACTV;
+	}
+
 	if (inta & BIT_INT_WAKEUP) {
 		IWL_DEBUG_ISR("Wakeup interrupt\n");
 		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
@@ -5175,8 +5210,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 		goto none;
 	}
 
-	if ((inta == 0xFFFFFFFF) || (inta == 0xa5a5a5a5)
-	    || (inta == 0x5a5a5a5a)) {
+	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
 		/* Hardware disappeared */
 		IWL_WARNING("HARDWARE GONE?? INTA == 0x%080x\n", inta);
 		goto none;
diff --git a/origin/iwl-commands.h b/origin/iwl-commands.h
index 2327ec3..e0b6685 100644
--- a/origin/iwl-commands.h
+++ b/origin/iwl-commands.h
@@ -130,8 +130,6 @@ enum {
 	REPLY_TX_PWR_TABLE_CMD = 0x97,
 	MEASURE_ABORT_NOTIFICATION = 0x99,
 
-	REPLY_CALIBRATION_TUNE = 0x9a,
-
 	/* BT config command */
 	REPLY_BT_CONFIG = 0x9b,
 	REPLY_STATISTICS_CMD = 0x9c,
@@ -143,15 +141,14 @@ enum {
 
 	/* Missed beacons notification */
 	MISSED_BEACONS_NOTIFICATION = 0xa2,
-	MISSED_BEACONS_NOTIFICATION_TH_CMD = 0xa3,
 
 #if IWL == 4965
 	REPLY_CT_KILL_CONFIG_CMD = 0xa4,
 	SENSITIVITY_CMD = 0xa8,
 	REPLY_PHY_CALIBRATION_CMD = 0xb0,
-	REPLY_4965_RX = 0xc3,
 	REPLY_RX_PHY_CMD = 0xc0,
 	REPLY_RX_MPDU_CMD = 0xc1,
+	REPLY_4965_RX = 0xc3,
 	REPLY_COMPRESSED_BA = 0xc5,
 #endif
 	REPLY_MAX = 0xff
diff --git a/origin/iwl-hw.h b/origin/iwl-hw.h
index f371794..7924607 100644
--- a/origin/iwl-hw.h
+++ b/origin/iwl-hw.h
@@ -922,6 +922,7 @@ struct statistics {
 #define CSR_INI_SET_MASK      ( BIT_INT_FH_RX   |  \
 				BIT_INT_ERR     |  \
 				BIT_INT_FH_TX   |  \
+				BIT_INT_MAC_CLK_ACTV | \
 				BIT_INT_SWERROR |  \
 				BIT_INT_RF_KILL |  \
 				BIT_INT_SW_RX   |  \
-- 
1.5.2.2
