Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab1KRIV1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:27 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LRoF026105
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:27 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 18/77] iwlegacy: s/iwl_rx_packet/iwl_rx_pkt/
Date: Fri, 18 Nov 2011 09:21:40 +0100
Message-Id: <1321604559-10707-18-git-send-email-sgruszka@redhat.com> (sfid-20111118_092134_558342_728A0CCC)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945.c     |   14 +++++++-------
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-rx.c  |    6 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c  |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c     |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-4965.h     |    2 +-
 drivers/net/wireless/iwlegacy/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlegacy/iwl-core.c     |    8 ++++----
 drivers/net/wireless/iwlegacy/iwl-core.h     |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-dev.h      |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-hcmd.c     |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-rx.c       |    2 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c     |   12 ++++++------
 drivers/net/wireless/iwlegacy/iwl-sta.c      |   12 ++++++------
 drivers/net/wireless/iwlegacy/iwl-tx.c       |    2 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c |   14 +++++++-------
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    8 ++++----
 17 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index 78e81b6..98c74e0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -304,7 +304,7 @@ static void il3945_tx_queue_reclaim(struct il_priv *il,
 static void il3945_rx_reply_tx(struct il_priv *il,
 				struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
@@ -398,7 +398,7 @@ static void il3945_accumulative_statistics(struct il_priv *il,
 void il3945_hw_rx_statistics(struct il_priv *il,
 		struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 
 	D_RX("Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(struct il3945_notif_statistics),
@@ -413,7 +413,7 @@ void il3945_hw_rx_statistics(struct il_priv *il,
 void il3945_reply_statistics(struct il_priv *il,
 			      struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	__le32 *flag = (__le32 *)&pkt->u.raw;
 
 	if (le32_to_cpu(*flag) & UCODE_STATISTICS_CLEAR_MSK) {
@@ -459,7 +459,7 @@ static void il3945_pass_packet_to_mac80211(struct il_priv *il,
 				   struct il_rx_mem_buffer *rxb,
 				   struct ieee80211_rx_status *stats)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)IL_RX_DATA(pkt);
 	struct il3945_rx_frame_hdr *rx_hdr = IL_RX_HDR(pkt);
 	struct il3945_rx_frame_end *rx_end = IL_RX_END(pkt);
@@ -510,7 +510,7 @@ static void il3945_rx_reply_rx(struct il_priv *il,
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status;
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il3945_rx_frame_stats *rx_stats = IL_RX_STATS(pkt);
 	struct il3945_rx_frame_hdr *rx_hdr = IL_RX_HDR(pkt);
 	struct il3945_rx_frame_end *rx_end = IL_RX_END(pkt);
@@ -1654,7 +1654,7 @@ static int il3945_send_rxon_assoc(struct il_priv *il,
 				   struct il_rxon_context *ctx)
 {
 	int rc = 0;
-	struct il_rx_packet *pkt;
+	struct il_rx_pkt *pkt;
 	struct il3945_rxon_assoc_cmd rxon_assoc;
 	struct il_host_cmd cmd = {
 		.id = REPLY_RXON_ASSOC,
@@ -1683,7 +1683,7 @@ static int il3945_send_rxon_assoc(struct il_priv *il,
 	if (rc)
 		return rc;
 
-	pkt = (struct il_rx_packet *)cmd.reply_page;
+	pkt = (struct il_rx_pkt *)cmd.reply_page;
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
 		IL_ERR("Bad return from REPLY_RXON_ASSOC command\n");
 		rc = -EIO;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index 964d9bb..da4ea24 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -570,7 +570,7 @@ void il4965_rx_reply_rx(struct il_priv *il,
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status;
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_rx_phy_res *phy_res;
 	__le32 rx_pkt_status;
 	struct il_rx_mpdu_res_start *amsdu;
@@ -688,7 +688,7 @@ void il4965_rx_reply_rx(struct il_priv *il,
 void il4965_rx_reply_rx_phy(struct il_priv *il,
 			    struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	il->_4965.last_phy_res_valid = true;
 	memcpy(&il->_4965.last_phy_res, pkt->u.raw,
 	       sizeof(struct il_rx_phy_res));
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rx.c b/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
index 2181ec0..95b7b13 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
@@ -45,7 +45,7 @@ void il4965_rx_missed_beacon_notif(struct il_priv *il,
 				struct il_rx_mem_buffer *rxb)
 
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_missed_beacon_notif *missed_beacon;
 
 	missed_beacon = &pkt->u.missed_beacon;
@@ -155,7 +155,7 @@ void il4965_rx_statistics(struct il_priv *il,
 			      struct il_rx_mem_buffer *rxb)
 {
 	int change;
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 
 	D_RX(
 		     "Statistics notification received (%d vs %d).\n",
@@ -198,7 +198,7 @@ void il4965_rx_statistics(struct il_priv *il,
 void il4965_reply_statistics(struct il_priv *il,
 			      struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 
 	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATISTICS_CLEAR_MSK) {
 #ifdef CONFIG_IWLEGACY_DEBUGFS
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index 5f6a4ba..cbc6feb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -1248,7 +1248,7 @@ void il4965_hwrate_to_tx_control(struct il_priv *il, u32 rate_n_flags,
 void il4965_rx_reply_compressed_ba(struct il_priv *il,
 					   struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
 	struct il_tx_queue *txq = NULL;
 	struct il_ht_agg *agg;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index f345171..4917b0d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1774,7 +1774,7 @@ static int il4965_get_ra_sta_id(struct il_priv *il, struct ieee80211_hdr *hdr)
 static void il4965_rx_reply_tx(struct il_priv *il,
 				struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
@@ -1877,7 +1877,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 static void il4965_rx_beacon_notif(struct il_priv *il,
 				    struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il4965_beacon_notif *beacon = (void *)pkt->u.raw;
 	u8 rate __maybe_unused =
 		il4965_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.h b/drivers/net/wireless/iwlegacy/iwl-4965.h
index 0b92c28..4427462 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.h
@@ -173,7 +173,7 @@ u8 il4965_toggle_tx_ant(struct il_priv *il, u8 ant_idx, u8 valid);
 void il4965_rx_missed_beacon_notif(struct il_priv *il,
 				struct il_rx_mem_buffer *rxb);
 bool il4965_good_plcp_health(struct il_priv *il,
-			  struct il_rx_packet *pkt);
+			  struct il_rx_pkt *pkt);
 void il4965_rx_statistics(struct il_priv *il,
 		       struct il_rx_mem_buffer *rxb);
 void il4965_reply_statistics(struct il_priv *il,
diff --git a/drivers/net/wireless/iwlegacy/iwl-commands.h b/drivers/net/wireless/iwlegacy/iwl-commands.h
index 61acafb..d9873cb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-commands.h
+++ b/drivers/net/wireless/iwlegacy/iwl-commands.h
@@ -3360,7 +3360,7 @@ struct il_led_cmd {
  *
  *****************************************************************************/
 
-struct il_rx_packet {
+struct il_rx_pkt {
 	/*
 	 * The first 4 bytes of the RX frame header contain both the RX frame
 	 * size and some flags.
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 395918e..e9ca265 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -865,7 +865,7 @@ EXPORT_SYMBOL(il_chswitch_done);
 
 void il_rx_csa(struct il_priv *il, struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_csa_notification *csa = &(pkt->u.csa_notif);
 
 	struct il_rxon_context *ctx = &il->contexts[IL_RXON_CTX_BSS];
@@ -1209,7 +1209,7 @@ void il_rx_pm_sleep_notif(struct il_priv *il,
 			   struct il_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	D_RX("sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
@@ -1220,7 +1220,7 @@ EXPORT_SYMBOL(il_rx_pm_sleep_notif);
 void il_rx_pm_debug_statistics_notif(struct il_priv *il,
 				      struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 	D_RADIO("Dumping %d bytes of unhandled "
 			"notification for %s:\n", len,
@@ -1232,7 +1232,7 @@ EXPORT_SYMBOL(il_rx_pm_debug_statistics_notif);
 void il_rx_reply_error(struct il_priv *il,
 			struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 
 	IL_ERR("Error Reply type 0x%08X cmd %s (0x%02X) "
 		"seq 0x%04X ser 0x%08X\n",
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index 487cebf..f805ccf 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -391,7 +391,7 @@ void il_tx_cmd_complete(struct il_priv *il,
 void il_rx_spectrum_measure_notif(struct il_priv *il,
 					  struct il_rx_mem_buffer *rxb);
 void il_recover_from_statistics(struct il_priv *il,
-				struct il_rx_packet *pkt);
+				struct il_rx_pkt *pkt);
 void il_chswitch_done(struct il_priv *il, bool is_success);
 void il_rx_csa(struct il_priv *il, struct il_rx_mem_buffer *rxb);
 
@@ -472,7 +472,7 @@ int il_send_cmd_pdu_async(struct il_priv *il, u8 id, u16 len,
 			   const void *data,
 			   void (*callback)(struct il_priv *il,
 					    struct il_device_cmd *cmd,
-					    struct il_rx_packet *pkt));
+					    struct il_rx_pkt *pkt));
 
 int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd);
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index 0aa4a12..4c7ccd5 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -108,7 +108,7 @@ struct il_cmd_meta {
 	 */
 	void (*callback)(struct il_priv *il,
 			 struct il_device_cmd *cmd,
-			 struct il_rx_packet *pkt);
+			 struct il_rx_pkt *pkt);
 
 	/* The CMD_SIZE_HUGE flag bit indicates that the command
 	 * structure is stored at the end of the shared queue memory. */
@@ -323,7 +323,7 @@ struct il_host_cmd {
 	unsigned long reply_page;
 	void (*callback)(struct il_priv *il,
 			 struct il_device_cmd *cmd,
-			 struct il_rx_packet *pkt);
+			 struct il_rx_pkt *pkt);
 	u32 flags;
 	u16 len;
 	u8 id;
diff --git a/drivers/net/wireless/iwlegacy/iwl-hcmd.c b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
index 6ccd37f..e63777b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
@@ -92,7 +92,7 @@ EXPORT_SYMBOL(il_get_cmd_string);
 
 static void il_generic_cmd_callback(struct il_priv *il,
 				     struct il_device_cmd *cmd,
-				     struct il_rx_packet *pkt)
+				     struct il_rx_pkt *pkt)
 {
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
 		IL_ERR("Bad return from %s (0x%08X)\n",
@@ -255,7 +255,7 @@ int il_send_cmd_pdu_async(struct il_priv *il,
 			   u8 id, u16 len, const void *data,
 			   void (*callback)(struct il_priv *il,
 					    struct il_device_cmd *cmd,
-					    struct il_rx_packet *pkt))
+					    struct il_rx_pkt *pkt))
 {
 	struct il_host_cmd cmd = {
 		.id = id,
diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
index b2ec2a2..746b5a7 100644
--- a/drivers/net/wireless/iwlegacy/iwl-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
@@ -213,7 +213,7 @@ EXPORT_SYMBOL(il_rx_queue_alloc);
 void il_rx_spectrum_measure_notif(struct il_priv *il,
 					  struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
 	if (!report->state) {
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index e4e5fbb..96c90e7 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -57,7 +57,7 @@
 static int il_send_scan_abort(struct il_priv *il)
 {
 	int ret;
-	struct il_rx_packet *pkt;
+	struct il_rx_pkt *pkt;
 	struct il_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
 		.flags = CMD_WANT_SKB,
@@ -77,7 +77,7 @@ static int il_send_scan_abort(struct il_priv *il)
 	if (ret)
 		return ret;
 
-	pkt = (struct il_rx_packet *)cmd.reply_page;
+	pkt = (struct il_rx_pkt *)cmd.reply_page;
 	if (pkt->u.status != CAN_ABORT_STATUS) {
 		/* The scan abort will return 1 for success or
 		 * 2 for "failure".  A failure condition can be
@@ -186,7 +186,7 @@ static void il_rx_reply_scan(struct il_priv *il,
 			      struct il_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_scanreq_notification *notif =
 	    (struct il_scanreq_notification *)pkt->u.raw;
 
@@ -198,7 +198,7 @@ static void il_rx_reply_scan(struct il_priv *il,
 static void il_rx_scan_start_notif(struct il_priv *il,
 				    struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_scanstart_notification *notif =
 	    (struct il_scanstart_notification *)pkt->u.raw;
 	il->scan_start_tsf = le32_to_cpu(notif->tsf_low);
@@ -217,7 +217,7 @@ static void il_rx_scan_results_notif(struct il_priv *il,
 				      struct il_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_scanresults_notification *notif =
 	    (struct il_scanresults_notification *)pkt->u.raw;
 
@@ -240,7 +240,7 @@ static void il_rx_scan_complete_notif(struct il_priv *il,
 {
 
 #ifdef CONFIG_IWLEGACY_DEBUG
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 #endif
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-sta.c b/drivers/net/wireless/iwlegacy/iwl-sta.c
index 68c43b0..3c354a8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-sta.c
@@ -59,7 +59,7 @@ static void il_sta_ucode_activate(struct il_priv *il, u8 sta_id)
 
 static int il_process_add_sta_resp(struct il_priv *il,
 				    struct il_addsta_cmd *addsta,
-				    struct il_rx_packet *pkt,
+				    struct il_rx_pkt *pkt,
 				    bool sync)
 {
 	u8 sta_id = addsta->sta.sta_id;
@@ -126,7 +126,7 @@ static int il_process_add_sta_resp(struct il_priv *il,
 
 static void il_add_sta_callback(struct il_priv *il,
 				 struct il_device_cmd *cmd,
-				 struct il_rx_packet *pkt)
+				 struct il_rx_pkt *pkt)
 {
 	struct il_addsta_cmd *addsta =
 		(struct il_addsta_cmd *)cmd->cmd.payload;
@@ -138,7 +138,7 @@ static void il_add_sta_callback(struct il_priv *il,
 int il_send_add_sta(struct il_priv *il,
 		     struct il_addsta_cmd *sta, u8 flags)
 {
-	struct il_rx_packet *pkt = NULL;
+	struct il_rx_pkt *pkt = NULL;
 	int ret = 0;
 	u8 data[sizeof(*sta)];
 	struct il_host_cmd cmd = {
@@ -165,7 +165,7 @@ int il_send_add_sta(struct il_priv *il,
 		return ret;
 
 	if (ret == 0) {
-		pkt = (struct il_rx_packet *)cmd.reply_page;
+		pkt = (struct il_rx_pkt *)cmd.reply_page;
 		ret = il_process_add_sta_resp(il, sta, pkt, true);
 	}
 	il_free_pages(il, cmd.reply_page);
@@ -414,7 +414,7 @@ static int il_send_remove_station(struct il_priv *il,
 				   const u8 *addr, int sta_id,
 				   bool temporary)
 {
-	struct il_rx_packet *pkt;
+	struct il_rx_pkt *pkt;
 	int ret;
 
 	unsigned long flags_spin;
@@ -438,7 +438,7 @@ static int il_send_remove_station(struct il_priv *il,
 	if (ret)
 		return ret;
 
-	pkt = (struct il_rx_packet *)cmd.reply_page;
+	pkt = (struct il_rx_pkt *)cmd.reply_page;
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
 		IL_ERR("Bad return from REPLY_REMOVE_STA (0x%08X)\n",
 			  pkt->hdr.flags);
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index 5312059..0e900a4 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -595,7 +595,7 @@ static void il_hcmd_queue_reclaim(struct il_priv *il, int txq_id,
 void
 il_tx_cmd_complete(struct il_priv *il, struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 2d1f22a..216c86f 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -671,7 +671,7 @@ static int il3945_get_measurement(struct il_priv *il,
 			       u8 type)
 {
 	struct il_spectrum_cmd spectrum;
-	struct il_rx_packet *pkt;
+	struct il_rx_pkt *pkt;
 	struct il_host_cmd cmd = {
 		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
 		.data = (void *)&spectrum,
@@ -716,7 +716,7 @@ static int il3945_get_measurement(struct il_priv *il,
 	if (rc)
 		return rc;
 
-	pkt = (struct il_rx_packet *)cmd.reply_page;
+	pkt = (struct il_rx_pkt *)cmd.reply_page;
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
 		IL_ERR("Bad return from REPLY_RX_ON_ASSOC command\n");
 		rc = -EIO;
@@ -747,7 +747,7 @@ static int il3945_get_measurement(struct il_priv *il,
 static void il3945_rx_reply_alive(struct il_priv *il,
 			       struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_alive_resp *palive;
 	struct delayed_work *pwork;
 
@@ -784,7 +784,7 @@ static void il3945_rx_reply_add_sta(struct il_priv *il,
 				 struct il_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLEGACY_DEBUG
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 #endif
 
 	D_RX("Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);
@@ -793,7 +793,7 @@ static void il3945_rx_reply_add_sta(struct il_priv *il,
 static void il3945_rx_beacon_notif(struct il_priv *il,
 				struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il3945_beacon_notif *beacon = &(pkt->u.beacon_status);
 #ifdef CONFIG_IWLEGACY_DEBUG
 	u8 rate = beacon->beacon_notify_hdr.rate;
@@ -816,7 +816,7 @@ static void il3945_rx_beacon_notif(struct il_priv *il,
 static void il3945_rx_card_state_notif(struct il_priv *il,
 				    struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = il->status;
 
@@ -1202,7 +1202,7 @@ int il3945_calc_db_from_ratio(int sig_ratio)
 static void il3945_rx_handle(struct il_priv *il)
 {
 	struct il_rx_mem_buffer *rxb;
-	struct il_rx_packet *pkt;
+	struct il_rx_pkt *pkt;
 	struct il_rx_queue *rxq = &il->rxq;
 	u32 r, i;
 	int reclaim;
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index ddf4200..d5f9180 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -430,7 +430,7 @@ int il4965_hw_tx_queue_init(struct il_priv *il,
 static void il4965_rx_reply_alive(struct il_priv *il,
 				struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_alive_resp *palive;
 	struct delayed_work *pwork;
 
@@ -490,7 +490,7 @@ static void il4965_bg_statistics_periodic(unsigned long data)
 static void il4965_rx_beacon_notif(struct il_priv *il,
 				struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il4965_beacon_notif *beacon =
 		(struct il4965_beacon_notif *)pkt->u.raw;
 #ifdef CONFIG_IWLEGACY_DEBUG
@@ -532,7 +532,7 @@ static void il4965_perform_ct_kill_task(struct il_priv *il)
 static void il4965_rx_card_state_notif(struct il_priv *il,
 				    struct il_rx_mem_buffer *rxb)
 {
-	struct il_rx_packet *pkt = rxb_addr(rxb);
+	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = il->status;
 
@@ -634,7 +634,7 @@ static void il4965_setup_rx_handlers(struct il_priv *il)
 void il4965_rx_handle(struct il_priv *il)
 {
 	struct il_rx_mem_buffer *rxb;
-	struct il_rx_packet *pkt;
+	struct il_rx_pkt *pkt;
 	struct il_rx_queue *rxq = &il->rxq;
 	u32 r, i;
 	int reclaim;
-- 
1.7.1

