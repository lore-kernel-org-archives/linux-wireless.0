Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031480Ab2CFWnj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:39 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 27/33] iwlwifi: move packet to transport
Date: Tue,  6 Mar 2012 13:31:02 -0800
Message-Id: <1331069468-11074-28-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234359_456751_96171ADB)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The base packet structure will (hopefully) be
the same for all transports, but what is in it
differs. Remove the union of all the possible
contents and move the packet itself into the
transport header file. This requires changing
all users of the union to just use pkt->data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c     |   50 ++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c    |    8 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h   |   84 -------------------------
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h |    3 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c       |   21 +++---
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   56 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-ucode.c      |    4 +-
 9 files changed, 103 insertions(+), 129 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index dec2693..b2ee1f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -710,7 +710,7 @@ int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 				  struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_bt_coex_profile_notif *coex = &pkt->u.bt_coex_profile_notif;
+	struct iwl_bt_coex_profile_notif *coex = (void *)pkt->data;
 	struct iwl_bt_uart_msg *uart_msg = &coex->last_bt_uart_msg;
 
 	if (priv->bt_enable_flag == IWLAGN_BT_FLAG_COEX_MODE_DISABLED) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 08de306..521c820 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -135,14 +135,15 @@ static int iwlagn_rx_reply_error(struct iwl_priv *priv,
 			       struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_error_resp *err_resp = (void *)pkt->data;
 
 	IWL_ERR(priv, "Error Reply type 0x%08X cmd %s (0x%02X) "
 		"seq 0x%04X ser 0x%08X\n",
-		le32_to_cpu(pkt->u.err_resp.error_type),
-		get_cmd_string(pkt->u.err_resp.cmd_id),
-		pkt->u.err_resp.cmd_id,
-		le16_to_cpu(pkt->u.err_resp.bad_cmd_seq_num),
-		le32_to_cpu(pkt->u.err_resp.error_info));
+		le32_to_cpu(err_resp->error_type),
+		get_cmd_string(err_resp->cmd_id),
+		err_resp->cmd_id,
+		le16_to_cpu(err_resp->bad_cmd_seq_num),
+		le32_to_cpu(err_resp->error_info));
 	return 0;
 }
 
@@ -150,7 +151,7 @@ static int iwlagn_rx_csa(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
+	struct iwl_csa_notification *csa = (void *)pkt->data;
 	/*
 	 * MULTI-FIXME
 	 * See iwlagn_mac_channel_switch.
@@ -181,7 +182,7 @@ static int iwlagn_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
+	struct iwl_spectrum_notification *report = (void *)pkt->data;
 
 	if (!report->state) {
 		IWL_DEBUG_11H(priv,
@@ -200,7 +201,7 @@ static int iwlagn_rx_pm_sleep_notif(struct iwl_priv *priv,
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
+	struct iwl_sleep_notification *sleep = (void *)pkt->data;
 	IWL_DEBUG_RX(priv, "sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
 #endif
@@ -217,7 +218,7 @@ static int iwlagn_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 	IWL_DEBUG_RADIO(priv, "Dumping %d bytes of unhandled "
 			"notification for %s:\n", len,
 			get_cmd_string(pkt->hdr.cmd));
-	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->u.raw, len);
+	iwl_print_hex_dump(priv, IWL_DL_RADIO, pkt->data, len);
 	return 0;
 }
 
@@ -226,7 +227,7 @@ static int iwlagn_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwlagn_beacon_notif *beacon = (void *)pkt->u.raw;
+	struct iwlagn_beacon_notif *beacon = (void *)pkt->data;
 #ifdef CONFIG_IWLWIFI_DEBUG
 	u16 status = le16_to_cpu(beacon->beacon_notify_hdr.status.status);
 	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
@@ -515,7 +516,7 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 
 	if (len == sizeof(struct iwl_bt_notif_statistics)) {
 		struct iwl_bt_notif_statistics *stats;
-		stats = &pkt->u.stats_bt;
+		stats = (void *)&pkt->data;
 		flag = &stats->flag;
 		common = &stats->general.common;
 		rx_non_phy = &stats->rx.general.common;
@@ -533,7 +534,7 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 #endif
 	} else if (len == sizeof(struct iwl_notif_statistics)) {
 		struct iwl_notif_statistics *stats;
-		stats = &pkt->u.stats;
+		stats = (void *)&pkt->data;
 		flag = &stats->flag;
 		common = &stats->general.common;
 		rx_non_phy = &stats->rx.general;
@@ -601,8 +602,9 @@ static int iwlagn_rx_reply_statistics(struct iwl_priv *priv,
 				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_notif_statistics *stats = (void *)pkt->data;
 
-	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATISTICS_CLEAR_MSK) {
+	if (le32_to_cpu(stats->flag) & UCODE_STATISTICS_CLEAR_MSK) {
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		memset(&priv->accum_stats, 0,
 			sizeof(priv->accum_stats));
@@ -624,7 +626,8 @@ static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
 				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
+	struct iwl_card_state_notif *card_state_notif = (void *)pkt->data;
+	u32 flags = le32_to_cpu(card_state_notif->flags);
 	unsigned long status = priv->shrd->status;
 
 	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s CT:%s\n",
@@ -678,9 +681,8 @@ static int iwlagn_rx_missed_beacon_notif(struct iwl_priv *priv,
 
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_missed_beacon_notif *missed_beacon;
+	struct iwl_missed_beacon_notif *missed_beacon = (void *)pkt->data;
 
-	missed_beacon = &pkt->u.missed_beacon;
 	if (le32_to_cpu(missed_beacon->consecutive_missed_beacons) >
 	    priv->missed_beacon_threshold) {
 		IWL_DEBUG_CALIB(priv,
@@ -704,7 +706,7 @@ static int iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
 	priv->last_phy_res_valid = true;
-	memcpy(&priv->last_phy_res, pkt->u.raw,
+	memcpy(&priv->last_phy_res, pkt->data,
 	       sizeof(struct iwl_rx_phy_res));
 	return 0;
 }
@@ -949,12 +951,12 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	 * received.
 	 */
 	if (pkt->hdr.cmd == REPLY_RX) {
-		phy_res = (struct iwl_rx_phy_res *)pkt->u.raw;
-		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*phy_res)
+		phy_res = (struct iwl_rx_phy_res *)pkt->data;
+		header = (struct ieee80211_hdr *)(pkt->data + sizeof(*phy_res)
 				+ phy_res->cfg_phy_cnt);
 
 		len = le16_to_cpu(phy_res->byte_count);
-		rx_pkt_status = *(__le32 *)(pkt->u.raw + sizeof(*phy_res) +
+		rx_pkt_status = *(__le32 *)(pkt->data + sizeof(*phy_res) +
 				phy_res->cfg_phy_cnt + len);
 		ampdu_status = le32_to_cpu(rx_pkt_status);
 	} else {
@@ -963,10 +965,10 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 			return 0;
 		}
 		phy_res = &priv->last_phy_res;
-		amsdu = (struct iwl_rx_mpdu_res_start *)pkt->u.raw;
-		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*amsdu));
+		amsdu = (struct iwl_rx_mpdu_res_start *)pkt->data;
+		header = (struct ieee80211_hdr *)(pkt->data + sizeof(*amsdu));
 		len = le16_to_cpu(amsdu->byte_count);
-		rx_pkt_status = *(__le32 *)(pkt->u.raw + sizeof(*amsdu) + len);
+		rx_pkt_status = *(__le32 *)(pkt->data + sizeof(*amsdu) + len);
 		ampdu_status = iwlagn_translate_rx_status(priv,
 						le32_to_cpu(rx_pkt_status));
 	}
@@ -1051,7 +1053,7 @@ static int iwlagn_rx_noa_notification(struct iwl_priv *priv,
 {
 	struct iwl_wipan_noa_data *new_data, *old_data;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_wipan_noa_notification *noa_notif = (void *)pkt->u.raw;
+	struct iwl_wipan_noa_notification *noa_notif = (void *)pkt->data;
 
 	/* no condition -- we're in softirq */
 	old_data = rcu_dereference_protected(priv->noa_data, true);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 14fbdec..cb6c230 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -64,6 +64,7 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 				    struct iwl_addsta_cmd *addsta,
 				    struct iwl_rx_packet *pkt)
 {
+	struct iwl_add_sta_resp *add_sta_resp = (void *)pkt->data;
 	u8 sta_id = addsta->sta.sta_id;
 	int ret = -EIO;
 
@@ -78,7 +79,7 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 
 	spin_lock(&priv->sta_lock);
 
-	switch (pkt->u.add_sta.status) {
+	switch (add_sta_resp->status) {
 	case ADD_STA_SUCCESS_MSK:
 		IWL_DEBUG_INFO(priv, "REPLY_ADD_STA PASSED\n");
 		ret = iwl_sta_ucode_activate(priv, sta_id);
@@ -97,7 +98,7 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 		break;
 	default:
 		IWL_DEBUG_ASSOC(priv, "Received REPLY_ADD_STA:(0x%08X)\n",
-				pkt->u.add_sta.status);
+				add_sta_resp->status);
 		break;
 	}
 
@@ -460,7 +461,8 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 	}
 
 	if (!ret) {
-		switch (pkt->u.rem_sta.status) {
+		struct iwl_rem_sta_resp *rem_sta_resp = (void *)pkt->data;
+		switch (rem_sta_resp->status) {
 		case REM_STA_SUCCESS_MSK:
 			if (!temporary) {
 				spin_lock_bh(&priv->sta_lock);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 5734dbf..e707e99 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -983,7 +983,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int cmd_index __maybe_unused = SEQ_TO_INDEX(sequence);
-	struct iwlagn_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
+	struct iwlagn_tx_resp *tx_resp = (void *)pkt->data;
 	struct ieee80211_hdr *hdr;
 	u32 status = le16_to_cpu(tx_resp->status.status);
 	u16 ssn = iwlagn_get_scd_ssn(tx_resp);
@@ -1111,7 +1111,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 				   struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
+	struct iwl_compressed_ba_resp *ba_resp = (void *)pkt->data;
 	struct iwl_ht_agg *agg;
 	struct sk_buff_head reclaimed_skbs;
 	struct ieee80211_tx_info *info;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index aa89930..70ba962 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -206,48 +206,6 @@ enum {
 /* iwl_cmd_header flags value */
 #define IWL_CMD_FAILED_MSK 0x40
 
-#define SEQ_TO_QUEUE(s)	(((s) >> 8) & 0x1f)
-#define QUEUE_TO_SEQ(q)	(((q) & 0x1f) << 8)
-#define SEQ_TO_INDEX(s)	((s) & 0xff)
-#define INDEX_TO_SEQ(i)	((i) & 0xff)
-#define SEQ_RX_FRAME	cpu_to_le16(0x8000)
-
-/**
- * struct iwl_cmd_header
- *
- * This header format appears in the beginning of each command sent from the
- * driver, and each response/notification received from uCode.
- */
-struct iwl_cmd_header {
-	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
-	u8 flags;	/* 0:5 reserved, 6 abort, 7 internal */
-	/*
-	 * The driver sets up the sequence number to values of its choosing.
-	 * uCode does not use this value, but passes it back to the driver
-	 * when sending the response to each driver-originated command, so
-	 * the driver can match the response to the command.  Since the values
-	 * don't get used by uCode, the driver may set up an arbitrary format.
-	 *
-	 * There is one exception:  uCode sets bit 15 when it originates
-	 * the response/notification, i.e. when the response/notification
-	 * is not a direct response to a command sent by the driver.  For
-	 * example, uCode issues REPLY_RX when it sends a received frame
-	 * to the driver; it is not a direct response to any driver command.
-	 *
-	 * The Linux driver uses the following format:
-	 *
-	 *  0:7		tfd index - position within TX queue
-	 *  8:12	TX queue id
-	 *  13:14	reserved
-	 *  15		unsolicited RX or uCode-originated notification
-	 */
-	__le16 sequence;
-
-	/* command or response/notification data follows immediately */
-	u8 data[0];
-} __packed;
-
-
 /**
  * iwlagn rate_n_flags bit fields
  *
@@ -3893,48 +3851,6 @@ struct iwlagn_wowlan_kek_kck_material_cmd {
 	__le64	replay_ctr;
 } __packed;
 
-/******************************************************************************
- * (13)
- * Union of all expected notifications/responses:
- *
- *****************************************************************************/
-#define FH_RSCSR_FRAME_SIZE_MSK	(0x00003FFF)	/* bits 0-13 */
-
-struct iwl_rx_packet {
-	/*
-	 * The first 4 bytes of the RX frame header contain both the RX frame
-	 * size and some flags.
-	 * Bit fields:
-	 * 31:    flag flush RB request
-	 * 30:    flag ignore TC (terminal counter) request
-	 * 29:    flag fast IRQ request
-	 * 28-14: Reserved
-	 * 13-00: RX frame size
-	 */
-	__le32 len_n_flags;
-	struct iwl_cmd_header hdr;
-	union {
-		struct iwl_alive_resp alive_frame;
-		struct iwl_spectrum_notification spectrum_notif;
-		struct iwl_csa_notification csa_notif;
-		struct iwl_error_resp err_resp;
-		struct iwl_card_state_notif card_state_notif;
-		struct iwl_add_sta_resp add_sta;
-		struct iwl_rem_sta_resp rem_sta;
-		struct iwl_sleep_notification sleep_notif;
-		struct iwl_spectrum_resp spectrum;
-		struct iwl_notif_statistics stats;
-		struct iwl_bt_notif_statistics stats_bt;
-		struct iwl_compressed_ba_resp compressed_ba;
-		struct iwl_missed_beacon_notif missed_beacon;
-		struct iwl_coex_medium_notification coex_medium_notif;
-		struct iwl_coex_event_resp coex_event;
-		struct iwl_bt_coex_profile_notif bt_coex_profile_notif;
-		__le32 status;
-		u8 raw[0];
-	} u;
-} __packed;
-
 int iwl_agn_check_rxon_cmd(struct iwl_priv *priv);
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-notif-wait.h b/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
index 419f1ad..5e8af95 100644
--- a/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
+++ b/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
@@ -64,8 +64,7 @@
 
 #include <linux/wait.h>
 
-/* TODO: remove later */
-#include "iwl-commands.h"
+#include "iwl-trans.h"
 
 struct iwl_notif_wait_data {
 	struct list_head notif_waits;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 6cf2cb3..91a1457 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -57,11 +57,11 @@
 static int iwl_send_scan_abort(struct iwl_priv *priv)
 {
 	int ret;
-	struct iwl_rx_packet *pkt;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
 		.flags = CMD_SYNC | CMD_WANT_SKB,
 	};
+	__le32 *status;
 
 	/* Exit instantly with error when device is not ready
 	 * to receive scan abort command or it does not perform
@@ -76,15 +76,16 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	if (ret)
 		return ret;
 
-	pkt = cmd.resp_pkt;
-	if (pkt->u.status != CAN_ABORT_STATUS) {
+	status = (void *)cmd.resp_pkt->data;
+	if (*status != CAN_ABORT_STATUS) {
 		/* The scan abort will return 1 for success or
 		 * 2 for "failure".  A failure condition can be
 		 * due to simply not being in an active scan which
 		 * can occur if we send the scan abort before we
 		 * the microcode has notified us that a scan is
 		 * completed. */
-		IWL_DEBUG_SCAN(priv, "SCAN_ABORT ret %d.\n", pkt->u.status);
+		IWL_DEBUG_SCAN(priv, "SCAN_ABORT ret %d.\n",
+			       le32_to_cpu(*status));
 		ret = -EIO;
 	}
 
@@ -265,8 +266,7 @@ static int iwl_rx_reply_scan(struct iwl_priv *priv,
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_scanreq_notification *notif =
-	    (struct iwl_scanreq_notification *)pkt->u.raw;
+	struct iwl_scanreq_notification *notif = (void *)pkt->data;
 
 	IWL_DEBUG_SCAN(priv, "Scan request status = 0x%x\n", notif->status);
 #endif
@@ -279,8 +279,8 @@ static int iwl_rx_scan_start_notif(struct iwl_priv *priv,
 				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_scanstart_notification *notif =
-	    (struct iwl_scanstart_notification *)pkt->u.raw;
+	struct iwl_scanstart_notification *notif = (void *)pkt->data;
+
 	priv->scan_start_tsf = le32_to_cpu(notif->tsf_low);
 	IWL_DEBUG_SCAN(priv, "Scan start: "
 		       "%d [802.11%s] "
@@ -307,8 +307,7 @@ static int iwl_rx_scan_results_notif(struct iwl_priv *priv,
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_scanresults_notification *notif =
-	    (struct iwl_scanresults_notification *)pkt->u.raw;
+	struct iwl_scanresults_notification *notif = (void *)pkt->data;
 
 	IWL_DEBUG_SCAN(priv, "Scan ch.res: "
 		       "%d [802.11%s] "
@@ -332,7 +331,7 @@ static int iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 				       struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
+	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->data;
 
 	IWL_DEBUG_SCAN(priv, "Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
 		       scan_notif->scanned_channels,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index a4a9efc..15bb208 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -122,6 +122,62 @@ struct dentry;
 #define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
 #define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
 #define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
+#define SEQ_TO_QUEUE(s)	(((s) >> 8) & 0x1f)
+#define QUEUE_TO_SEQ(q)	(((q) & 0x1f) << 8)
+#define SEQ_TO_INDEX(s)	((s) & 0xff)
+#define INDEX_TO_SEQ(i)	((i) & 0xff)
+#define SEQ_RX_FRAME	cpu_to_le16(0x8000)
+
+/**
+ * struct iwl_cmd_header
+ *
+ * This header format appears in the beginning of each command sent from the
+ * driver, and each response/notification received from uCode.
+ */
+struct iwl_cmd_header {
+	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
+	u8 flags;	/* 0:5 reserved, 6 abort, 7 internal */
+	/*
+	 * The driver sets up the sequence number to values of its choosing.
+	 * uCode does not use this value, but passes it back to the driver
+	 * when sending the response to each driver-originated command, so
+	 * the driver can match the response to the command.  Since the values
+	 * don't get used by uCode, the driver may set up an arbitrary format.
+	 *
+	 * There is one exception:  uCode sets bit 15 when it originates
+	 * the response/notification, i.e. when the response/notification
+	 * is not a direct response to a command sent by the driver.  For
+	 * example, uCode issues REPLY_RX when it sends a received frame
+	 * to the driver; it is not a direct response to any driver command.
+	 *
+	 * The Linux driver uses the following format:
+	 *
+	 *  0:7		tfd index - position within TX queue
+	 *  8:12	TX queue id
+	 *  13:14	reserved
+	 *  15		unsolicited RX or uCode-originated notification
+	 */
+	__le16 sequence;
+} __packed;
+
+
+#define FH_RSCSR_FRAME_SIZE_MSK		0x00003FFF	/* bits 0-13 */
+
+struct iwl_rx_packet {
+	/*
+	 * The first 4 bytes of the RX frame header contain both the RX frame
+	 * size and some flags.
+	 * Bit fields:
+	 * 31:    flag flush RB request
+	 * 30:    flag ignore TC (terminal counter) request
+	 * 29:    flag fast IRQ request
+	 * 28-14: Reserved
+	 * 13-00: RX frame size
+	 */
+	__le32 len_n_flags;
+	struct iwl_cmd_header hdr;
+	u8 data[];
+} __packed;
 
 /**
  * enum CMD_MODE - how to send the host commands ?
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 4d34327..8267dbe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -186,7 +186,7 @@ int iwlagn_rx_calib_result(struct iwl_priv *priv,
 			    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_calib_hdr *hdr = (struct iwl_calib_hdr *)pkt->u.raw;
+	struct iwl_calib_hdr *hdr = (struct iwl_calib_hdr *)pkt->data;
 	int len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 
 	/* reduce the size of the length field itself */
@@ -442,7 +442,7 @@ static void iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 	struct iwl_alive_data *alive_data = data;
 	struct iwl_alive_resp *palive;
 
-	palive = &pkt->u.alive_frame;
+	palive = (void *)pkt->data;
 
 	IWL_DEBUG_FW(priv, "Alive ucode status 0x%08X revision "
 		       "0x%01X 0x%01X\n",
-- 
1.7.0.4

