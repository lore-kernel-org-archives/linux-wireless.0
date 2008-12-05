Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49805 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657AbYLEP5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 10:57:44 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Halperin, Daniel C" <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/6] iwlwifi: implement iwl_debug_report_frame for iwlagn
Date: Fri,  5 Dec 2008 07:58:36 -0800
Message-Id: <1228492721-27381-2-git-send-email-reinette.chatre@intel.com> (sfid-20081205_165752_185299_FAD44853)
In-Reply-To: <1228492721-27381-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228492721-27381-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Halperin, Daniel C <daniel.c.halperin@intel.com>

The old version of this code was copied from 3945 and never updated. This patch
cleans up structs that do not apply and accounts for other changes from
3945->iwlagn (e.g., PHY info can come in a separate cmd response from the
ucode.)

Signed-off-by: Daniel Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   42 -------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    9 ---
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   85 ++++++++++-----------------
 3 files changed, 31 insertions(+), 105 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 528bcab..45656f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1023,25 +1023,6 @@ struct iwl_wep_cmd {
  *
  *****************************************************************************/
 
-struct iwl4965_rx_frame_stats {
-	u8 phy_count;
-	u8 id;
-	u8 rssi;
-	u8 agc;
-	__le16 sig_avg;
-	__le16 noise_diff;
-	u8 payload[0];
-} __attribute__ ((packed));
-
-struct iwl4965_rx_frame_hdr {
-	__le16 channel;
-	__le16 phy_flags;
-	u8 reserved1;
-	u8 rate;
-	__le16 len;
-	u8 payload[0];
-} __attribute__ ((packed));
-
 #define RX_RES_STATUS_NO_CRC32_ERROR	cpu_to_le32(1 << 0)
 #define RX_RES_STATUS_NO_RXE_OVERFLOW	cpu_to_le32(1 << 1)
 
@@ -1072,26 +1053,6 @@ struct iwl4965_rx_frame_hdr {
 #define RX_MPDU_RES_STATUS_TTAK_OK	(1 << 7)
 #define RX_MPDU_RES_STATUS_DEC_DONE_MSK	(0x800)
 
-struct iwl4965_rx_frame_end {
-	__le32 status;
-	__le64 timestamp;
-	__le32 beacon_timestamp;
-} __attribute__ ((packed));
-
-/*
- * REPLY_3945_RX = 0x1b (response only, not a command)
- *
- * NOTE:  DO NOT dereference from casts to this structure
- * It is provided only for calculating minimum data set size.
- * The actual offsets of the hdr and end are dynamic based on
- * stats.phy_count
- */
-struct iwl4965_rx_frame {
-	struct iwl4965_rx_frame_stats stats;
-	struct iwl4965_rx_frame_hdr hdr;
-	struct iwl4965_rx_frame_end end;
-} __attribute__ ((packed));
-
 /* Fixed (non-configurable) rx data from phy */
 
 #define IWL49_RX_RES_PHY_CNT 14
@@ -3049,7 +3010,6 @@ struct iwl_rx_packet {
 	struct iwl_cmd_header hdr;
 	union {
 		struct iwl_alive_resp alive_frame;
-		struct iwl4965_rx_frame rx_frame;
 		struct iwl4965_tx_resp tx_resp;
 		struct iwl4965_spectrum_notification spectrum_notif;
 		struct iwl4965_csa_notification csa_notif;
@@ -3068,8 +3028,6 @@ struct iwl_rx_packet {
 	} u;
 } __attribute__ ((packed));
 
-#define IWL_RX_FRAME_SIZE        (4 + sizeof(struct iwl4965_rx_frame))
-
 int iwl_agn_check_rxon_cmd(struct iwl_rxon_cmd *rxon);
 
 #endif				/* __iwl_commands_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a19fbb5..9d678d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -553,15 +553,6 @@ struct iwl_hw_params {
 #define HT_SHORT_GI_40MHZ	(1 << 1)
 
 
-#define IWL_RX_HDR(x) ((struct iwl4965_rx_frame_hdr *)(\
-		       x->u.rx_frame.stats.payload + \
-		       x->u.rx_frame.stats.phy_count))
-#define IWL_RX_END(x) ((struct iwl4965_rx_frame_end *)(\
-		       IWL_RX_HDR(x)->payload + \
-		       le16_to_cpu(IWL_RX_HDR(x)->len)))
-#define IWL_RX_STATS(x) (&x->u.rx_frame.stats)
-#define IWL_RX_DATA(x) (IWL_RX_HDR(x)->payload)
-
 /******************************************************************************
  *
  * Functions implemented in core module which are forward declared here
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 8d2b73e..6dd16c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -622,20 +622,24 @@ static int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm)
 	return sig_qual;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
+/* Calc max signal level (dBm) among 3 possible receivers */
+static inline int iwl_calc_rssi(struct iwl_priv *priv,
+				struct iwl_rx_phy_res *rx_resp)
+{
+	return priv->cfg->ops->utils->calc_rssi(priv, rx_resp);
+}
 
+#ifdef CONFIG_IWLWIFI_DEBUG
 /**
  * iwl_dbg_report_frame - dump frame to syslog during debug sessions
  *
  * You may hack this function to show different aspects of received frames,
  * including selective frame dumps.
- * group100 parameter selects whether to show 1 out of 100 good frames.
- *
- * TODO:  This was originally written for 3945, need to audit for
- *        proper operation with 4965.
+ * group100 parameter selects whether to show 1 out of 100 good data frames.
+ *    All beacon and probe response frames are printed.
  */
 static void iwl_dbg_report_frame(struct iwl_priv *priv,
-		      struct iwl_rx_packet *pkt,
+		      struct iwl_rx_phy_res *phy_res, u16 length,
 		      struct ieee80211_hdr *header, int group100)
 {
 	u32 to_us;
@@ -647,20 +651,9 @@ static void iwl_dbg_report_frame(struct iwl_priv *priv,
 	u16 seq_ctl;
 	u16 channel;
 	u16 phy_flags;
-	int rate_sym;
-	u16 length;
-	u16 status;
-	u16 bcn_tmr;
+	u32 rate_n_flags;
 	u32 tsf_low;
-	u64 tsf;
-	u8 rssi;
-	u8 agc;
-	u16 sig_avg;
-	u16 noise_diff;
-	struct iwl4965_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
-	struct iwl4965_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
-	struct iwl4965_rx_frame_end *rx_end = IWL_RX_END(pkt);
-	u8 *data = IWL_RX_DATA(pkt);
+	int rssi;
 
 	if (likely(!(priv->debug_level & IWL_DL_RX)))
 		return;
@@ -670,22 +663,13 @@ static void iwl_dbg_report_frame(struct iwl_priv *priv,
 	seq_ctl = le16_to_cpu(header->seq_ctrl);
 
 	/* metadata */
-	channel = le16_to_cpu(rx_hdr->channel);
-	phy_flags = le16_to_cpu(rx_hdr->phy_flags);
-	rate_sym = rx_hdr->rate;
-	length = le16_to_cpu(rx_hdr->len);
-
-	/* end-of-frame status and timestamp */
-	status = le32_to_cpu(rx_end->status);
-	bcn_tmr = le32_to_cpu(rx_end->beacon_timestamp);
-	tsf_low = le64_to_cpu(rx_end->timestamp) & 0x0ffffffff;
-	tsf = le64_to_cpu(rx_end->timestamp);
+	channel = le16_to_cpu(phy_res->channel);
+	phy_flags = le16_to_cpu(phy_res->phy_flags);
+	rate_n_flags = le32_to_cpu(phy_res->rate_n_flags);
 
 	/* signal statistics */
-	rssi = rx_stats->rssi;
-	agc = rx_stats->agc;
-	sig_avg = le16_to_cpu(rx_stats->sig_avg);
-	noise_diff = le16_to_cpu(rx_stats->noise_diff);
+	rssi = iwl_calc_rssi(priv, phy_res);
+	tsf_low = le64_to_cpu(phy_res->timestamp) & 0x0ffffffff;
 
 	to_us = !compare_ether_addr(header->addr1, priv->mac_addr);
 
@@ -739,11 +723,13 @@ static void iwl_dbg_report_frame(struct iwl_priv *priv,
 		else
 			title = "Frame";
 
-		rate_idx = iwl_hwrate_to_plcp_idx(rate_sym);
-		if (unlikely(rate_idx == -1))
+		rate_idx = iwl_hwrate_to_plcp_idx(rate_n_flags);
+		if (unlikely((rate_idx < 0) || (rate_idx >= IWL_RATE_COUNT))) {
 			bitrate = 0;
-		else
+			WARN_ON_ONCE(1);
+		} else {
 			bitrate = iwl_rates[rate_idx].ieee / 2;
+		}
 
 		/* print frame summary.
 		 * MAC addresses show just the last byte (for brevity),
@@ -755,23 +741,22 @@ static void iwl_dbg_report_frame(struct iwl_priv *priv,
 				     length, rssi, channel, bitrate);
 		else {
 			/* src/dst addresses assume managed mode */
-			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, "
-				     "src=0x%02x, rssi=%u, tim=%lu usec, "
+			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, src=0x%02x, "
+				     "len=%u, rssi=%d, tim=%lu usec, "
 				     "phy=0x%02x, chnl=%d\n",
 				     title, le16_to_cpu(fc), header->addr1[5],
-				     header->addr3[5], rssi,
+				     header->addr3[5], length, rssi,
 				     tsf_low - priv->scan_start_tsf,
 				     phy_flags, channel);
 		}
 	}
 	if (print_dump)
-		iwl_print_hex_dump(priv, IWL_DL_RX, data, length);
+		iwl_print_hex_dump(priv, IWL_DL_RX, header, length);
 }
 #else
-static inline void iwl_dbg_report_frame(struct iwl_priv *priv,
-					    struct iwl_rx_packet *pkt,
-					    struct ieee80211_hdr *header,
-					    int group100)
+static void iwl_dbg_report_frame(struct iwl_priv *priv,
+		      struct iwl_rx_phy_res *phy_res, u16 length,
+		      struct ieee80211_hdr *header, int group100)
 {
 }
 #endif
@@ -966,14 +951,6 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	rxb->skb = NULL;
 }
 
-/* Calc max signal level (dBm) among 3 possible receivers */
-static inline int iwl_calc_rssi(struct iwl_priv *priv,
-				struct iwl_rx_phy_res *rx_resp)
-{
-	return priv->cfg->ops->utils->calc_rssi(priv, rx_resp);
-}
-
-
 /* This is necessary only for a number of statistics, see the caller. */
 static int iwl_is_network_packet(struct iwl_priv *priv,
 		struct ieee80211_hdr *header)
@@ -1096,8 +1073,8 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
 
 	/* Set "1" to report good data frames in groups of 100 */
-	/* FIXME: need to optimize the call: */
-	iwl_dbg_report_frame(priv, pkt, header, 1);
+	if (unlikely(priv->debug_level & IWL_DL_RX))
+		iwl_dbg_report_frame(priv, rx_start, len, header, 1);
 
 	IWL_DEBUG_STATS_LIMIT("Rssi %d, noise %d, qual %d, TSF %llu\n",
 		rx_status.signal, rx_status.noise, rx_status.signal,
-- 
1.5.4.3

