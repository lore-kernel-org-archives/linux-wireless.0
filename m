Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbYEECYL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:11 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 06/25] iwlwifi: remove 4965 from rx_packet
Date: Mon,  5 May 2008 10:22:33 +0800
Message-Id: <1209954172-3092-7-git-send-email-yi.zhu@intel.com> (sfid-20080505_042355_358396_DBF93C06)
In-Reply-To: <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes 4965 mark from rx_packet.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   16 ++++----
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   56 +++++++++++++-------------
 4 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index efe4793..f437326 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2519,7 +2519,7 @@ static void iwl4965_rx_calc_noise(struct iwl_priv *priv)
 void iwl4965_hw_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	int change;
 	s32 temp;
 
@@ -2807,7 +2807,7 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 				       struct iwl_rx_mem_buffer *rxb,
 				       struct ieee80211_rx_status *stats)
 {
-	struct iwl4965_rx_packet *pkt = (struct iwl4965_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_rx_phy_res *rx_start = (include_phy) ?
 	    (struct iwl4965_rx_phy_res *)&(pkt->u.raw[0]) : NULL;
 	struct ieee80211_hdr *hdr;
@@ -2964,7 +2964,7 @@ static void iwl4965_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
  *        proper operation with 4965.
  */
 static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
-		      struct iwl4965_rx_packet *pkt,
+		      struct iwl_rx_packet *pkt,
 		      struct ieee80211_hdr *header, int group100)
 {
 	u32 to_us;
@@ -3098,7 +3098,7 @@ static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 }
 #else
 static inline void iwl4965_dbg_report_frame(struct iwl_priv *priv,
-					    struct iwl4965_rx_packet *pkt,
+					    struct iwl_rx_packet *pkt,
 					    struct ieee80211_hdr *header,
 					    int group100)
 {
@@ -3114,7 +3114,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 {
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status;
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	/* Use phy data (Rx signal strength, etc.) contained within
 	 *   this rx packet for legacy frames,
 	 *   or phy data cached from REPLY_RX_PHY_CMD for HT frames. */
@@ -3281,7 +3281,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 static void iwl4965_rx_reply_rx_phy(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	priv->last_phy_res[0] = 1;
 	memcpy(&priv->last_phy_res[1], &(pkt->u.raw[0]),
 	       sizeof(struct iwl4965_rx_phy_res));
@@ -3291,7 +3291,7 @@ static void iwl4965_rx_missed_beacon_notif(struct iwl_priv *priv,
 
 {
 #ifdef CONFIG_IWL4965_RUN_TIME_CALIB
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_missed_beacon_notif *missed_beacon;
 
 	missed_beacon = &pkt->u.missed_beacon;
@@ -3498,7 +3498,7 @@ static inline int iwl4965_queue_dec_wrap(int index, int n_bd)
 static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 					   struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
 	int index;
 	struct iwl4965_tx_queue *txq = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 5afa7b7..e5449b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2731,7 +2731,7 @@ struct iwl4965_led_cmd {
  *
  *****************************************************************************/
 
-struct iwl4965_rx_packet {
+struct iwl_rx_packet {
 	__le32 len;
 	struct iwl_cmd_header hdr;
 	union {
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index acb5a8a..0412adf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -101,7 +101,7 @@ EXPORT_SYMBOL(get_cmd_string);
 static int iwl_generic_cmd_callback(struct iwl_priv *priv,
 				    struct iwl_cmd *cmd, struct sk_buff *skb)
 {
-	struct iwl4965_rx_packet *pkt = NULL;
+	struct iwl_rx_packet *pkt = NULL;
 
 	if (!skb) {
 		IWL_ERROR("Error: Response NULL in %s.\n",
@@ -109,7 +109,7 @@ static int iwl_generic_cmd_callback(struct iwl_priv *priv,
 		return 1;
 	}
 
-	pkt = (struct iwl4965_rx_packet *)skb->data;
+	pkt = (struct iwl_rx_packet *)skb->data;
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERROR("Bad return from %s (0x%08X)\n",
 			get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index c23a123..661adf6 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -902,8 +902,8 @@ static int iwl4965_send_bt_config(struct iwl_priv *priv)
 
 static int iwl4965_send_scan_abort(struct iwl_priv *priv)
 {
-	int rc = 0;
-	struct iwl4965_rx_packet *res;
+	int ret = 0;
+	struct iwl_rx_packet *res;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
 		.meta.flags = CMD_WANT_SKB,
@@ -917,13 +917,13 @@ static int iwl4965_send_scan_abort(struct iwl_priv *priv)
 		return 0;
 	}
 
-	rc = iwl_send_cmd_sync(priv, &cmd);
-	if (rc) {
+	ret = iwl_send_cmd_sync(priv, &cmd);
+	if (ret) {
 		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		return rc;
+		return ret;
 	}
 
-	res = (struct iwl4965_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->u.status != CAN_ABORT_STATUS) {
 		/* The scan abort will return 1 for success or
 		 * 2 for "failure".  A failure condition can be
@@ -938,7 +938,7 @@ static int iwl4965_send_scan_abort(struct iwl_priv *priv)
 
 	dev_kfree_skb_any(cmd.meta.u.skb);
 
-	return rc;
+	return ret;
 }
 
 /*
@@ -966,7 +966,7 @@ static int iwl4965_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_fla
 int iwl4965_send_add_station(struct iwl_priv *priv,
 			 struct iwl4965_addsta_cmd *sta, u8 flags)
 {
-	struct iwl4965_rx_packet *res = NULL;
+	struct iwl_rx_packet *res = NULL;
 	int rc = 0;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_ADD_STA,
@@ -983,7 +983,7 @@ int iwl4965_send_add_station(struct iwl_priv *priv,
 	if (rc || (flags & CMD_ASYNC))
 		return rc;
 
-	res = (struct iwl4965_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
 			  res->hdr.flags);
@@ -2441,7 +2441,7 @@ static int iwl4965_get_measurement(struct iwl_priv *priv,
 			       u8 type)
 {
 	struct iwl4965_spectrum_cmd spectrum;
-	struct iwl4965_rx_packet *res;
+	struct iwl_rx_packet *res;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
 		.data = (void *)&spectrum,
@@ -2486,7 +2486,7 @@ static int iwl4965_get_measurement(struct iwl_priv *priv,
 	if (rc)
 		return rc;
 
-	res = (struct iwl4965_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERROR("Bad return from REPLY_RX_ON_ASSOC command\n");
 		rc = -EIO;
@@ -2744,7 +2744,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
@@ -2852,7 +2852,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 static void iwl4965_rx_reply_alive(struct iwl_priv *priv,
 				   struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_alive_resp *palive;
 	struct delayed_work *pwork;
 
@@ -2888,7 +2888,7 @@ static void iwl4965_rx_reply_alive(struct iwl_priv *priv,
 static void iwl4965_rx_reply_add_sta(struct iwl_priv *priv,
 				     struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
 	IWL_DEBUG_RX("Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);
 	return;
@@ -2897,7 +2897,7 @@ static void iwl4965_rx_reply_add_sta(struct iwl_priv *priv,
 static void iwl4965_rx_reply_error(struct iwl_priv *priv,
 				   struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
 	IWL_ERROR("Error Reply type 0x%08X cmd %s (0x%02X) "
 		"seq 0x%04X ser 0x%08X\n",
@@ -2912,7 +2912,7 @@ static void iwl4965_rx_reply_error(struct iwl_priv *priv,
 
 static void iwl4965_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_rxon_cmd *rxon = (void *)&priv->active_rxon;
 	struct iwl4965_csa_notification *csa = &(pkt->u.csa_notif);
 	IWL_DEBUG_11H("CSA notif: channel %d, status %d\n",
@@ -2925,7 +2925,7 @@ static void iwl4965_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
 	if (!report->state) {
@@ -2943,7 +2943,7 @@ static void iwl4965_rx_pm_sleep_notif(struct iwl_priv *priv,
 				      struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
@@ -2953,7 +2953,7 @@ static void iwl4965_rx_pm_sleep_notif(struct iwl_priv *priv,
 static void iwl4965_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 					     struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	IWL_DEBUG_RADIO("Dumping %d bytes of unhandled "
 			"notification for %s:\n",
 			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
@@ -2989,7 +2989,7 @@ static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_beacon_notif *beacon = &(pkt->u.beacon_status);
 	u8 rate = iwl4965_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
 
@@ -3012,7 +3012,7 @@ static void iwl4965_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_scanreq_notification *notif =
 	    (struct iwl4965_scanreq_notification *)pkt->u.raw;
 
@@ -3024,7 +3024,7 @@ static void iwl4965_rx_reply_scan(struct iwl_priv *priv,
 static void iwl4965_rx_scan_start_notif(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_scanstart_notification *notif =
 	    (struct iwl4965_scanstart_notification *)pkt->u.raw;
 	priv->scan_start_tsf = le32_to_cpu(notif->tsf_low);
@@ -3041,7 +3041,7 @@ static void iwl4965_rx_scan_start_notif(struct iwl_priv *priv,
 static void iwl4965_rx_scan_results_notif(struct iwl_priv *priv,
 				      struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_scanresults_notification *notif =
 	    (struct iwl4965_scanresults_notification *)pkt->u.raw;
 
@@ -3066,7 +3066,7 @@ static void iwl4965_rx_scan_results_notif(struct iwl_priv *priv,
 static void iwl4965_rx_scan_complete_notif(struct iwl_priv *priv,
 				       struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 
 	IWL_DEBUG_SCAN("Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
@@ -3124,7 +3124,7 @@ reschedule:
 static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = priv->status;
 
@@ -3244,7 +3244,7 @@ static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
 static void iwl4965_tx_cmd_complete(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb)
 {
-	struct iwl4965_rx_packet *pkt = (struct iwl4965_rx_packet *)rxb->skb->data;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
@@ -3299,7 +3299,7 @@ static void __iwl_rx_replenish(struct iwl_priv *priv)
 void iwl_rx_handle(struct iwl_priv *priv)
 {
 	struct iwl_rx_mem_buffer *rxb;
-	struct iwl4965_rx_packet *pkt;
+	struct iwl_rx_packet *pkt;
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	u32 r, i;
 	int reclaim;
@@ -3332,7 +3332,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->dma_addr,
 					    priv->hw_params.rx_buf_size,
 					    PCI_DMA_FROMDEVICE);
-		pkt = (struct iwl4965_rx_packet *)rxb->skb->data;
+		pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
 		/* Reclaim a command buffer only if this packet is a response
 		 *   to a (driver-originated) command.
-- 
1.5.3.6

