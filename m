Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18162 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763695AbXHHHie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:38:34 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 26/28] iwlwifi: Enhance ISR/RX/CMD debug messages
Date: Wed,  8 Aug 2007 15:33:43 +0800
Message-Id: <11865584861970-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584841976-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
 <11865584631842-git-send-email-yi.zhu@intel.com>
 <11865584661209-git-send-email-yi.zhu@intel.com>
 <11865584683474-git-send-email-yi.zhu@intel.com>
 <1186558470949-git-send-email-yi.zhu@intel.com>
 <11865584733882-git-send-email-yi.zhu@intel.com>
 <11865584754153-git-send-email-yi.zhu@intel.com>
 <11865584771950-git-send-email-yi.zhu@intel.com>
 <1186558479530-git-send-email-yi.zhu@intel.com>
 <11865584823402-git-send-email-yi.zhu@intel.com>
 <11865584841976-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

This patch enhances ISR/RX/CMD debug messages and make sure
all commands are in get_cmd_string(). It also removes 2 unused
commands and enhance comments.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c     |   84 +++++++++++++++++++++++-----------
 drivers/net/wireless/iwl-commands.h |    5 +--
 2 files changed, 58 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index a6cac9c..ad7e67c 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -593,41 +593,61 @@ static inline int iwl_is_ready_rf(struct iwl_priv *priv)
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
 
@@ -4647,8 +4667,8 @@ int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm)
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
@@ -4662,6 +4682,10 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 	r = iwl_hw_get_rx_read(priv);
 	i = rxq->read;
 
+	/* Rx interrupt, but nothing sent from uCode */
+	if (i == r)
+		IWL_DEBUG(IWL_DL_RX | IWL_DL_ISR, "r = %d, i = %d\n", r, i);
+
 	while (i != r) {
 		rxb = rxq->queue[i];
 
@@ -4677,7 +4701,12 @@ static void iwl_rx_handle(struct iwl_priv *priv)
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
@@ -4690,21 +4719,22 @@ static void iwl_rx_handle(struct iwl_priv *priv)
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
diff --git a/drivers/net/wireless/iwl-commands.h b/drivers/net/wireless/iwl-commands.h
index 1d2c091..eecb6f6 100644
--- a/drivers/net/wireless/iwl-commands.h
+++ b/drivers/net/wireless/iwl-commands.h
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
-- 
1.5.2
