Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845AbaCEMLX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:11:23 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: [RFC/RFT 8/9] iwlegacy: treat RX notify specially
Date: Wed,  5 Mar 2014 13:13:33 +0100
Message-Id: <1394021614-11514-9-git-send-email-sgruszka@redhat.com> (sfid-20140305_131129_395140_ADBE3D5C)
In-Reply-To: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
References: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX data is the only notify where we pass RX page to upper layers and
need to allocate new one. Hence treat it specially. This patch also
change argument of all other handlers. This make them simpler a bit
and allow me to verify that we do not free RX page on them.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c | 37 ++++++++----------
 drivers/net/wireless/iwlegacy/3945.c     | 17 +++------
 drivers/net/wireless/iwlegacy/3945.h     |  5 ++-
 drivers/net/wireless/iwlegacy/4965-mac.c | 65 +++++++++++++++-----------------
 drivers/net/wireless/iwlegacy/common.c   | 34 ++++++-----------
 drivers/net/wireless/iwlegacy/common.h   | 14 +++----
 6 files changed, 72 insertions(+), 100 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index f7a58f5..de531e7 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -744,9 +744,8 @@ out:
 }
 
 static void
-il3945_hdl_alive(struct il_priv *il, struct il_rx_buf *rxb)
+il3945_hdl_alive(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_alive_resp *palive;
 	struct delayed_work *pwork;
 
@@ -777,19 +776,14 @@ il3945_hdl_alive(struct il_priv *il, struct il_rx_buf *rxb)
 }
 
 static void
-il3945_hdl_add_sta(struct il_priv *il, struct il_rx_buf *rxb)
+il3945_hdl_add_sta(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-#ifdef CONFIG_IWLEGACY_DEBUG
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
-#endif
-
 	D_RX("Received C_ADD_STA: 0x%02X\n", pkt->u.status);
 }
 
 static void
-il3945_hdl_beacon(struct il_priv *il, struct il_rx_buf *rxb)
+il3945_hdl_beacon(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il3945_beacon_notif *beacon = &(pkt->u.beacon_status);
 #ifdef CONFIG_IWLEGACY_DEBUG
 	u8 rate = beacon->beacon_notify_hdr.rate;
@@ -808,9 +802,8 @@ il3945_hdl_beacon(struct il_priv *il, struct il_rx_buf *rxb)
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
 static void
-il3945_hdl_card_state(struct il_priv *il, struct il_rx_buf *rxb)
+il3945_hdl_card_state(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = il->status;
 
@@ -1234,8 +1227,6 @@ il3945_rx_handle(struct il_priv *il)
 		D_RX("r = %d, i = %d\n", r, i);
 
 	while (i != r) {
-		int len;
-
 		rxb = rxq->queue[i];
 
 		/* If an RXB doesn't have a Rx queue slot associated with it,
@@ -1250,19 +1241,21 @@ il3945_rx_handle(struct il_priv *il)
 			       PCI_DMA_FROMDEVICE);
 		pkt = rxb_addr(rxb);
 
-		len = le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK;
-		len += sizeof(u32);	/* account for status word */
-
 		reclaim = il_need_reclaim(il, pkt);
 
-		/* Based on type of command response or notification,
-		 *   handle those that need handling via function in
-		 *   handlers table.  See il3945_setup_handlers() */
-		if (il->handlers[pkt->hdr.cmd]) {
+		if (pkt->hdr.cmd == N_3945_RX) {
+			D_RX("r = %d, i = %d, %s, 0x%02x\n", r, i,
+			     il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
+			il3945_data_rx(il, rxb);
+		} else if (il->handlers[pkt->hdr.cmd]) {
+			/* Based on type of command response or notification,
+			 * handle those that need handling via function in
+			 * handlers table. See il3945_setup_handlers()
+			 */
 			D_RX("r = %d, i = %d, %s, 0x%02x\n", r, i,
 			     il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			il->isr_stats.handlers[pkt->hdr.cmd]++;
-			il->handlers[pkt->hdr.cmd] (il, rxb);
+			il->handlers[pkt->hdr.cmd] (il, pkt);
 		} else {
 			/* No handling needed */
 			D_RX("r %d i %d No handler needed for %s, 0x%02x\n", r,
@@ -1281,7 +1274,7 @@ il3945_rx_handle(struct il_priv *il)
 			 * and fire off the (possibly) blocking il_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb->page)
-				il_tx_cmd_complete(il, rxb);
+				il_tx_cmd_complete(il, pkt);
 			else
 				IL_WARN("Claim null rxb?\n");
 		}
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 5c1a1cb..80a2c6c 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -310,9 +310,8 @@ il3945_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx)
  * il3945_hdl_tx - Handle Tx response
  */
 static void
-il3945_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
+il3945_hdl_tx(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int idx = SEQ_TO_IDX(sequence);
@@ -416,10 +415,8 @@ il3945_accumulative_stats(struct il_priv *il, __le32 * stats)
 #endif
 
 void
-il3945_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb)
+il3945_hdl_stats(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
-
 	D_RX("Statistics notification received (%d vs %d).\n",
 	     (int)sizeof(struct il3945_notif_stats),
 	     le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK);
@@ -431,9 +428,8 @@ il3945_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb)
 }
 
 void
-il3945_hdl_c_stats(struct il_priv *il, struct il_rx_buf *rxb)
+il3945_hdl_c_stats(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	__le32 *flag = (__le32 *) &pkt->u.raw;
 
 	if (le32_to_cpu(*flag) & UCODE_STATS_CLEAR_MSK) {
@@ -447,7 +443,7 @@ il3945_hdl_c_stats(struct il_priv *il, struct il_rx_buf *rxb)
 #endif
 		D_RX("Statistics have been cleared\n");
 	}
-	il3945_hdl_stats(il, rxb);
+	il3945_hdl_stats(il, pkt);
 }
 
 /******************************************************************************
@@ -536,8 +532,8 @@ il3945_pass_packet_to_mac80211(struct il_priv *il, struct il_rx_buf *rxb,
 
 #define IL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 
-static void
-il3945_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
+void
+il3945_data_rx(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status = {};
@@ -2467,7 +2463,6 @@ void
 il3945_hw_handler_setup(struct il_priv *il)
 {
 	il->handlers[C_TX] = il3945_hdl_tx;
-	il->handlers[N_3945_RX] = il3945_hdl_rx;
 }
 
 void
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index 00030d4..d4380fa 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -236,14 +236,15 @@ void il3945_hw_build_tx_cmd_rate(struct il_priv *il, struct il_device_cmd *cmd,
 				 struct ieee80211_hdr *hdr, int sta_id);
 int il3945_hw_reg_send_txpower(struct il_priv *il);
 int il3945_hw_reg_set_txpower(struct il_priv *il, s8 power);
-void il3945_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb);
-void il3945_hdl_c_stats(struct il_priv *il, struct il_rx_buf *rxb);
+void il3945_hdl_stats(struct il_priv *il, struct il_rx_pkt *pkt);
+void il3945_hdl_c_stats(struct il_priv *il, struct il_rx_pkt *pkt);
 void il3945_disable_events(struct il_priv *il);
 int il4965_get_temperature(const struct il_priv *il);
 void il3945_post_associate(struct il_priv *il);
 void il3945_config_ap(struct il_priv *il);
 
 int il3945_commit_rxon(struct il_priv *il);
+void il3945_data_rx(struct il_priv *il, struct il_rx_buf *rxb);
 
 /**
  * il3945_hw_find_station - Find station id for a given BSSID
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 888ad5c..8677652 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -620,10 +620,17 @@ il4965_pass_packet_to_mac80211(struct il_priv *il, struct ieee80211_hdr *hdr,
 	ieee80211_rx(il->hw, skb);
 }
 
+
+static inline bool
+il4965_is_data_rx(struct il_rx_pkt *pkt)
+{
+	return pkt->hdr.cmd == N_RX || pkt->hdr.cmd == N_RX_MPDU;
+}
+
 /* Called for N_RX (legacy ABG frames), or
  * N_RX_MPDU (HT high-throughput N frames). */
 static void
-il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
+il4965_data_rx(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status = {};
@@ -755,9 +762,8 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 /* Cache phy data (Rx signal strength, etc) for HT frame (N_RX_PHY).
  * This will be used later in il_hdl_rx() for N_RX_MPDU. */
 static void
-il4965_hdl_rx_phy(struct il_priv *il, struct il_rx_buf *rxb)
+il4965_hdl_rx_phy(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	il->_4965.last_phy_res_valid = true;
 	il->_4965.ampdu_ref++;
 	memcpy(&il->_4965.last_phy_res, pkt->u.raw,
@@ -1261,9 +1267,8 @@ il4965_dump_fh(struct il_priv *il, char **buf, bool display)
 }
 
 static void
-il4965_hdl_missed_beacon(struct il_priv *il, struct il_rx_buf *rxb)
+il4965_hdl_missed_beacon(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_missed_beacon_notif *missed_beacon;
 
 	missed_beacon = &pkt->u.missed_beacon;
@@ -1368,11 +1373,10 @@ il4965_accumulative_stats(struct il_priv *il, __le32 * stats)
 #endif
 
 static void
-il4965_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb)
+il4965_hdl_stats(struct il_priv *il, struct il_rx_pkt *pkt)
 {
 	const int recalib_seconds = 60;
 	bool change;
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 
 	D_RX("Statistics notification received (%d vs %d).\n",
 	     (int)sizeof(struct il_notif_stats),
@@ -1410,10 +1414,8 @@ il4965_hdl_stats(struct il_priv *il, struct il_rx_buf *rxb)
 }
 
 static void
-il4965_hdl_c_stats(struct il_priv *il, struct il_rx_buf *rxb)
+il4965_hdl_c_stats(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
-
 	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATS_CLEAR_MSK) {
 #ifdef CONFIG_IWLEGACY_DEBUGFS
 		memset(&il->_4965.accum_stats, 0,
@@ -1424,7 +1426,7 @@ il4965_hdl_c_stats(struct il_priv *il, struct il_rx_buf *rxb)
 #endif
 		D_RX("Statistics have been cleared\n");
 	}
-	il4965_hdl_stats(il, rxb);
+	il4965_hdl_stats(il, pkt);
 }
 
 
@@ -2773,9 +2775,8 @@ il4965_tx_status_reply_tx(struct il_priv *il, struct il_ht_agg *agg,
  * il4965_hdl_tx - Handle standard (non-aggregation) Tx response
  */
 static void
-il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
+il4965_hdl_tx(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int idx = SEQ_TO_IDX(sequence);
@@ -2920,9 +2921,8 @@ il4965_hwrate_to_tx_control(struct il_priv *il, u32 rate_n_flags,
  * of frames sent via aggregation.
  */
 static void
-il4965_hdl_compressed_ba(struct il_priv *il, struct il_rx_buf *rxb)
+il4965_hdl_compressed_ba(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
 	struct il_tx_queue *txq = NULL;
 	struct il_ht_agg *agg;
@@ -4030,9 +4030,8 @@ il4965_hw_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq)
  *
  ******************************************************************************/
 static void
-il4965_hdl_alive(struct il_priv *il, struct il_rx_buf *rxb)
+il4965_hdl_alive(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_alive_resp *palive;
 	struct delayed_work *pwork;
 
@@ -4087,9 +4086,8 @@ il4965_bg_stats_periodic(unsigned long data)
 }
 
 static void
-il4965_hdl_beacon(struct il_priv *il, struct il_rx_buf *rxb)
+il4965_hdl_beacon(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il4965_beacon_notif *beacon =
 	    (struct il4965_beacon_notif *)pkt->u.raw;
 #ifdef CONFIG_IWLEGACY_DEBUG
@@ -4127,9 +4125,8 @@ il4965_perform_ct_kill_task(struct il_priv *il)
 /* Handle notification from uCode that card's power state is changing
  * due to software, hardware, or critical temperature RFKILL */
 static void
-il4965_hdl_card_state(struct il_priv *il, struct il_rx_buf *rxb)
+il4965_hdl_card_state(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = il->status;
 
@@ -4208,8 +4205,6 @@ il4965_setup_handlers(struct il_priv *il)
 	il->handlers[N_MISSED_BEACONS] = il4965_hdl_missed_beacon;
 	/* Rx handlers */
 	il->handlers[N_RX_PHY] = il4965_hdl_rx_phy;
-	il->handlers[N_RX_MPDU] = il4965_hdl_rx;
-	il->handlers[N_RX] = il4965_hdl_rx;
 	/* block ack */
 	il->handlers[N_COMPRESSED_BA] = il4965_hdl_compressed_ba;
 	/* Tx response */
@@ -4230,7 +4225,7 @@ il4965_rx_handle(struct il_priv *il)
 	struct il_rx_pkt *pkt;
 	struct il_rx_queue *rxq = &il->rxq;
 	u32 r, i;
-	int reclaim;
+	bool reclaim;
 	unsigned long flags;
 	u8 fill_rx = 0;
 	u32 count = 8;
@@ -4254,8 +4249,6 @@ il4965_rx_handle(struct il_priv *il)
 		fill_rx = 1;
 
 	while (i != r) {
-		int len;
-
 		rxb = rxq->queue[i];
 
 		/* If an RXB doesn't have a Rx queue slot associated with it,
@@ -4270,19 +4263,21 @@ il4965_rx_handle(struct il_priv *il)
 			       PCI_DMA_FROMDEVICE);
 		pkt = rxb_addr(rxb);
 
-		len = le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK;
-		len += sizeof(u32);	/* account for status word */
-
 		reclaim = il_need_reclaim(il, pkt);
 
-		/* Based on type of command response or notification,
-		 *   handle those that need handling via function in
-		 *   handlers table.  See il4965_setup_handlers() */
-		if (il->handlers[pkt->hdr.cmd]) {
+		if (il4965_is_data_rx(pkt)) {
+			D_RX("r = %d, i = %d, %s, 0x%02x\n", r, i,
+			     il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
+			il4965_data_rx(il, rxb);
+		} else if (il->handlers[pkt->hdr.cmd]) {
+			/* Based on type of command response or notification,
+			 * handle those that need handling via function in
+			 * handlers table. See il4965_setup_handlers()
+			 */
 			D_RX("r = %d, i = %d, %s, 0x%02x\n", r, i,
 			     il_get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			il->isr_stats.handlers[pkt->hdr.cmd]++;
-			il->handlers[pkt->hdr.cmd] (il, rxb);
+			il->handlers[pkt->hdr.cmd] (il, pkt);
 		} else {
 			/* No handling needed */
 			D_RX("r %d i %d No handler needed for %s, 0x%02x\n", r,
@@ -4301,7 +4296,7 @@ il4965_rx_handle(struct il_priv *il)
 			 * and fire off the (possibly) blocking il_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb->page)
-				il_tx_cmd_complete(il, rxb);
+				il_tx_cmd_complete(il, pkt);
 			else
 				IL_WARN("Claim null rxb?\n");
 		}
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index f938641..30bac85 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1390,10 +1390,9 @@ EXPORT_SYMBOL(il_scan_cancel_timeout);
 
 /* Service response to C_SCAN (0x80) */
 static void
-il_hdl_scan(struct il_priv *il, struct il_rx_buf *rxb)
+il_hdl_scan(struct il_priv *il, struct il_rx_pkt *pkt)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_scanreq_notification *notif =
 	    (struct il_scanreq_notification *)pkt->u.raw;
 
@@ -1403,9 +1402,8 @@ il_hdl_scan(struct il_priv *il, struct il_rx_buf *rxb)
 
 /* Service N_SCAN_START (0x82) */
 static void
-il_hdl_scan_start(struct il_priv *il, struct il_rx_buf *rxb)
+il_hdl_scan_start(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_scanstart_notification *notif =
 	    (struct il_scanstart_notification *)pkt->u.raw;
 	il->scan_start_tsf = le32_to_cpu(notif->tsf_low);
@@ -1417,10 +1415,9 @@ il_hdl_scan_start(struct il_priv *il, struct il_rx_buf *rxb)
 
 /* Service N_SCAN_RESULTS (0x83) */
 static void
-il_hdl_scan_results(struct il_priv *il, struct il_rx_buf *rxb)
+il_hdl_scan_results(struct il_priv *il, struct il_rx_pkt *pkt)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_scanresults_notification *notif =
 	    (struct il_scanresults_notification *)pkt->u.raw;
 
@@ -1434,17 +1431,15 @@ il_hdl_scan_results(struct il_priv *il, struct il_rx_buf *rxb)
 
 /* Service N_SCAN_COMPLETE (0x84) */
 static void
-il_hdl_scan_complete(struct il_priv *il, struct il_rx_buf *rxb)
+il_hdl_scan_complete(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-
 #ifdef CONFIG_IWLEGACY_DEBUG
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
-#endif
 
 	D_SCAN("Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
 	       scan_notif->scanned_channels, scan_notif->tsf_low,
 	       scan_notif->tsf_high, scan_notif->status);
+#endif
 
 	/* The HW is no longer scanning */
 	clear_bit(S_SCAN_HW, &il->status);
@@ -2643,9 +2638,8 @@ err_bd:
 EXPORT_SYMBOL(il_rx_queue_alloc);
 
 void
-il_hdl_spectrum_measurement(struct il_priv *il, struct il_rx_buf *rxb)
+il_hdl_spectrum_measurement(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
 	if (!report->state) {
@@ -3274,9 +3268,8 @@ il_hcmd_queue_reclaim(struct il_priv *il, int txq_id, int idx, int cmd_idx)
  * if the callback returns 1
  */
 void
-il_tx_cmd_complete(struct il_priv *il, struct il_rx_buf *rxb)
+il_tx_cmd_complete(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int idx = SEQ_TO_IDX(sequence);
@@ -4101,9 +4094,8 @@ il_chswitch_done(struct il_priv *il, bool is_success)
 EXPORT_SYMBOL(il_chswitch_done);
 
 void
-il_hdl_csa(struct il_priv *il, struct il_rx_buf *rxb)
+il_hdl_csa(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_csa_notification *csa = &(pkt->u.csa_notif);
 	struct il_rxon_cmd *rxon = (void *)&il->active;
 
@@ -4442,10 +4434,9 @@ il_send_stats_request(struct il_priv *il, u8 flags, bool clear)
 EXPORT_SYMBOL(il_send_stats_request);
 
 void
-il_hdl_pm_sleep(struct il_priv *il, struct il_rx_buf *rxb)
+il_hdl_pm_sleep(struct il_priv *il, struct il_rx_pkt *pkt)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	D_RX("sleep mode: %d, src: %d\n",
 	     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
@@ -4454,9 +4445,8 @@ il_hdl_pm_sleep(struct il_priv *il, struct il_rx_buf *rxb)
 EXPORT_SYMBOL(il_hdl_pm_sleep);
 
 void
-il_hdl_pm_debug_stats(struct il_priv *il, struct il_rx_buf *rxb)
+il_hdl_pm_debug_stats(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u32 len = le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK;
 	D_RADIO("Dumping %d bytes of unhandled notification for %s:\n", len,
 		il_get_cmd_string(pkt->hdr.cmd));
@@ -4465,10 +4455,8 @@ il_hdl_pm_debug_stats(struct il_priv *il, struct il_rx_buf *rxb)
 EXPORT_SYMBOL(il_hdl_pm_debug_stats);
 
 void
-il_hdl_error(struct il_priv *il, struct il_rx_buf *rxb)
+il_hdl_error(struct il_priv *il, struct il_rx_pkt *pkt)
 {
-	struct il_rx_pkt *pkt = rxb_addr(rxb);
-
 	IL_ERR("Error Reply type 0x%08X cmd %s (0x%02X) "
 	       "seq 0x%04X ser 0x%08X\n",
 	       le32_to_cpu(pkt->u.err_resp.error_type),
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 41996e9..7cf76c9 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1145,7 +1145,7 @@ struct il_priv {
 	int alloc_rxb_page;
 
 	void (*handlers[IL_CN_MAX]) (struct il_priv *il,
-				     struct il_rx_buf *rxb);
+				     struct il_rx_pkt *pkt);
 
 	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
@@ -1739,10 +1739,10 @@ il_update_stats(struct il_priv *il, bool is_tx, __le16 fc, u16 len)
 /*****************************************************
  * Handlers
  ***************************************************/
-void il_hdl_pm_sleep(struct il_priv *il, struct il_rx_buf *rxb);
-void il_hdl_pm_debug_stats(struct il_priv *il, struct il_rx_buf *rxb);
-void il_hdl_error(struct il_priv *il, struct il_rx_buf *rxb);
-void il_hdl_csa(struct il_priv *il, struct il_rx_buf *rxb);
+void il_hdl_pm_sleep(struct il_priv *il, struct il_rx_pkt *pkt);
+void il_hdl_pm_debug_stats(struct il_priv *il, struct il_rx_pkt *pkt);
+void il_hdl_error(struct il_priv *il, struct il_rx_pkt *pkt);
+void il_hdl_csa(struct il_priv *il, struct il_rx_pkt *pkt);
 
 /*****************************************************
 * RX
@@ -1752,9 +1752,9 @@ void il_cmd_queue_free(struct il_priv *il);
 int il_rx_queue_alloc(struct il_priv *il);
 void il_rx_queue_update_write_ptr(struct il_priv *il, struct il_rx_queue *q);
 int il_rx_queue_space(const struct il_rx_queue *q);
-void il_tx_cmd_complete(struct il_priv *il, struct il_rx_buf *rxb);
+void il_tx_cmd_complete(struct il_priv *il, struct il_rx_pkt *pkt);
 
-void il_hdl_spectrum_measurement(struct il_priv *il, struct il_rx_buf *rxb);
+void il_hdl_spectrum_measurement(struct il_priv *il, struct il_rx_pkt *pkt);
 void il_recover_from_stats(struct il_priv *il, struct il_rx_pkt *pkt);
 void il_chswitch_done(struct il_priv *il, bool is_success);
 
-- 
1.7.11.7

