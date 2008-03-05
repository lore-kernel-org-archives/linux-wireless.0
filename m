Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13185 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808AbYCECKP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 21:10:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 03/11] iwlwifi: Fix 52 rate report in rx status
Date: Tue,  4 Mar 2008 18:09:24 -0800
Message-Id: <1204682972-26004-4-git-send-email-reinette.chatre@intel.com> (sfid-20080305_022354_275459_61433430)
In-Reply-To: <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes reporting rate in RX packets in 52 band.
The rate was updated from CCK rate index instead of OFDM rate 6M
Most of the patch is collateral clean up

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-debug.h |   17 ++-
 drivers/net/wireless/iwlwifi/iwl-3945.c       |  231 +++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-3945.h       |   20 --
 drivers/net/wireless/iwlwifi/iwl-4965-debug.h |   16 ++
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c    |    6 +-
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c       |  250 +++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-4965.h       |   10 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |  182 ------------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c   |  181 ------------------
 10 files changed, 449 insertions(+), 466 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h b/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
index f853c6b..28ecfe8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
@@ -40,6 +40,15 @@ do { if (iwl3945_debug_level & (level)) \
 do { if ((iwl3945_debug_level & (level)) && net_ratelimit()) \
   printk(KERN_ERR DRV_NAME": %c %s " fmt, \
 	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+
+static inline void iwl3945_print_hex_dump(int level, void *p, u32 len)
+{
+	if (!(iwl3945_debug_level & level))
+		return;
+
+	print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET, 16, 1,
+			p, len, 1);
+}
 #else
 static inline void IWL_DEBUG(int level, const char *fmt, ...)
 {
@@ -47,7 +56,12 @@ static inline void IWL_DEBUG(int level, const char *fmt, ...)
 static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
 {
 }
-#endif				/* CONFIG_IWL3945_DEBUG */
+static inline void iwl3945_print_hex_dump(int level, void *p, u32 len)
+{
+}
+#endif	/* CONFIG_IWL3945_DEBUG */
+
+
 
 /*
  * To use the debug system;
@@ -143,6 +157,7 @@ static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
 	IWL_DEBUG_LIMIT(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
 #define IWL_DEBUG_HT(f, a...) IWL_DEBUG(IWL_DL_HT, f, ## a)
 #define IWL_DEBUG_STATS(f, a...) IWL_DEBUG(IWL_DL_STATS, f, ## a)
+#define IWL_DEBUG_STATS_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_STATS, f, ## a)
 #define IWL_DEBUG_TX_REPLY(f, a...) IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
 #define IWL_DEBUG_QOS(f, a...)   IWL_DEBUG(IWL_DL_QOS, f, ## a)
 #define IWL_DEBUG_RADIO(f, a...)  IWL_DEBUG(IWL_DL_RADIO, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 82d2827..63e832c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -183,6 +183,16 @@ void iwl3945_disable_events(struct iwl3945_priv *priv)
 
 }
 
+static int iwl3945_hwrate_to_plcp_idx(u8 plcp)
+{
+	int idx;
+
+	for (idx = 0; idx < IWL_RATE_COUNT; idx++)
+		if (iwl3945_rates[idx].plcp == plcp)
+			return idx;
+	return -1;
+}
+
 /**
  * iwl3945_get_antenna_flags - Get antenna flags for RXON command
  * @priv: eeprom and antenna fields are used to determine antenna flags
@@ -238,6 +248,156 @@ void iwl3945_hw_rx_statistics(struct iwl3945_priv *priv, struct iwl3945_rx_mem_b
 	priv->last_statistics_time = jiffies;
 }
 
+/******************************************************************************
+ *
+ * Misc. internal state and helper functions
+ *
+ ******************************************************************************/
+#ifdef CONFIG_IWL3945_DEBUG
+
+/**
+ * iwl3945_report_frame - dump frame to syslog during debug sessions
+ *
+ * You may hack this function to show different aspects of received frames,
+ * including selective frame dumps.
+ * group100 parameter selects whether to show 1 out of 100 good frames.
+ */
+static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
+		      struct iwl3945_rx_packet *pkt,
+		      struct ieee80211_hdr *header, int group100)
+{
+	u32 to_us;
+	u32 print_summary = 0;
+	u32 print_dump = 0;	/* set to 1 to dump all frames' contents */
+	u32 hundred = 0;
+	u32 dataframe = 0;
+	u16 fc;
+	u16 seq_ctl;
+	u16 channel;
+	u16 phy_flags;
+	u16 length;
+	u16 status;
+	u16 bcn_tmr;
+	u32 tsf_low;
+	u64 tsf;
+	u8 rssi;
+	u8 agc;
+	u16 sig_avg;
+	u16 noise_diff;
+	struct iwl3945_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
+	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
+	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
+	u8 *data = IWL_RX_DATA(pkt);
+
+	/* MAC header */
+	fc = le16_to_cpu(header->frame_control);
+	seq_ctl = le16_to_cpu(header->seq_ctrl);
+
+	/* metadata */
+	channel = le16_to_cpu(rx_hdr->channel);
+	phy_flags = le16_to_cpu(rx_hdr->phy_flags);
+	length = le16_to_cpu(rx_hdr->len);
+
+	/* end-of-frame status and timestamp */
+	status = le32_to_cpu(rx_end->status);
+	bcn_tmr = le32_to_cpu(rx_end->beacon_timestamp);
+	tsf_low = le64_to_cpu(rx_end->timestamp) & 0x0ffffffff;
+	tsf = le64_to_cpu(rx_end->timestamp);
+
+	/* signal statistics */
+	rssi = rx_stats->rssi;
+	agc = rx_stats->agc;
+	sig_avg = le16_to_cpu(rx_stats->sig_avg);
+	noise_diff = le16_to_cpu(rx_stats->noise_diff);
+
+	to_us = !compare_ether_addr(header->addr1, priv->mac_addr);
+
+	/* if data frame is to us and all is good,
+	 *   (optionally) print summary for only 1 out of every 100 */
+	if (to_us && (fc & ~IEEE80211_FCTL_PROTECTED) ==
+	    (IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
+		dataframe = 1;
+		if (!group100)
+			print_summary = 1;	/* print each frame */
+		else if (priv->framecnt_to_us < 100) {
+			priv->framecnt_to_us++;
+			print_summary = 0;
+		} else {
+			priv->framecnt_to_us = 0;
+			print_summary = 1;
+			hundred = 1;
+		}
+	} else {
+		/* print summary for all other frames */
+		print_summary = 1;
+	}
+
+	if (print_summary) {
+		char *title;
+		u32 rate;
+
+		if (hundred)
+			title = "100Frames";
+		else if (fc & IEEE80211_FCTL_RETRY)
+			title = "Retry";
+		else if (ieee80211_is_assoc_response(fc))
+			title = "AscRsp";
+		else if (ieee80211_is_reassoc_response(fc))
+			title = "RasRsp";
+		else if (ieee80211_is_probe_response(fc)) {
+			title = "PrbRsp";
+			print_dump = 1;	/* dump frame contents */
+		} else if (ieee80211_is_beacon(fc)) {
+			title = "Beacon";
+			print_dump = 1;	/* dump frame contents */
+		} else if (ieee80211_is_atim(fc))
+			title = "ATIM";
+		else if (ieee80211_is_auth(fc))
+			title = "Auth";
+		else if (ieee80211_is_deauth(fc))
+			title = "DeAuth";
+		else if (ieee80211_is_disassoc(fc))
+			title = "DisAssoc";
+		else
+			title = "Frame";
+
+		rate = iwl3945_hwrate_to_plcp_idx(rx_hdr->rate);
+		if (rate == -1)
+			rate = 0;
+		else
+			rate = iwl3945_rates[rate].ieee / 2;
+
+		/* print frame summary.
+		 * MAC addresses show just the last byte (for brevity),
+		 *    but you can hack it to show more, if you'd like to. */
+		if (dataframe)
+			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
+				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
+				     title, fc, header->addr1[5],
+				     length, rssi, channel, rate);
+		else {
+			/* src/dst addresses assume managed mode */
+			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, "
+				     "src=0x%02x, rssi=%u, tim=%lu usec, "
+				     "phy=0x%02x, chnl=%d\n",
+				     title, fc, header->addr1[5],
+				     header->addr3[5], rssi,
+				     tsf_low - priv->scan_start_tsf,
+				     phy_flags, channel);
+		}
+	}
+	if (print_dump)
+		iwl3945_print_hex_dump(IWL_DL_RX, data, length);
+}
+#else
+static inline void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
+		      struct iwl3945_rx_packet *pkt,
+		      struct ieee80211_hdr *header, int group100)
+{
+}
+#endif
+
+
 static void iwl3945_add_radiotap(struct iwl3945_priv *priv,
 				 struct sk_buff *skb,
 				 struct iwl3945_rx_frame_hdr *rx_hdr,
@@ -376,24 +536,28 @@ static void iwl3945_handle_data_packet(struct iwl3945_priv *priv, int is_data,
 static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 				struct iwl3945_rx_mem_buffer *rxb)
 {
+	struct ieee80211_hdr *header;
+	struct ieee80211_rx_status rx_status;
 	struct iwl3945_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl3945_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
 	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
 	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
-	struct ieee80211_hdr *header;
+	int snr;
 	u16 rx_stats_sig_avg = le16_to_cpu(rx_stats->sig_avg);
 	u16 rx_stats_noise_diff = le16_to_cpu(rx_stats->noise_diff);
-	struct ieee80211_rx_status stats = {
-		.mactime = le64_to_cpu(rx_end->timestamp),
-		.freq = ieee80211chan2mhz(le16_to_cpu(rx_hdr->channel)),
-		.band = (rx_hdr->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
-		IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ,
-		.antenna = 0,
-		.rate_idx = iwl3945_rate_index_from_plcp(rx_hdr->rate),
-		.flag = 0,
-	};
 	u8 network_packet;
-	int snr;
+
+	rx_status.antenna = 0;
+	rx_status.flag = 0;
+	rx_status.mactime = le64_to_cpu(rx_end->timestamp);
+	rx_status.freq = ieee80211chan2mhz(le16_to_cpu(rx_hdr->channel));
+	rx_status.band = (rx_hdr->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
+				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+
+	rx_status.rate_idx = iwl3945_hwrate_to_plcp_idx(rx_hdr->rate);
+
+	if (rx_status.band == IEEE80211_BAND_5GHZ)
+		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
 
 	if ((unlikely(rx_stats->phy_count > 20))) {
 		IWL_DEBUG_DROP
@@ -409,12 +573,12 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	}
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		iwl3945_handle_data_packet(priv, 1, rxb, &stats);
+		iwl3945_handle_data_packet(priv, 1, rxb, &rx_status);
 		return;
 	}
 
 	/* Convert 3945's rssi indicator to dBm */
-	stats.ssi = rx_stats->rssi - IWL_RSSI_OFFSET;
+	rx_status.ssi = rx_stats->rssi - IWL_RSSI_OFFSET;
 
 	/* Set default noise value to -127 */
 	if (priv->last_rx_noise == 0)
@@ -430,50 +594,47 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	 *   signal-to-noise ratio (SNR) is (sig_avg / noise_diff).
 	 * Convert linear SNR to dB SNR, then subtract that from rssi dBm
 	 *   to obtain noise level in dBm.
-	 * Calculate stats.signal (quality indicator in %) based on SNR. */
+	 * Calculate rx_status.signal (quality indicator in %) based on SNR. */
 	if (rx_stats_noise_diff) {
 		snr = rx_stats_sig_avg / rx_stats_noise_diff;
-		stats.noise = stats.ssi - iwl3945_calc_db_from_ratio(snr);
-		stats.signal = iwl3945_calc_sig_qual(stats.ssi, stats.noise);
+		rx_status.noise = rx_status.ssi -
+					iwl3945_calc_db_from_ratio(snr);
+		rx_status.signal = iwl3945_calc_sig_qual(rx_status.ssi,
+							 rx_status.noise);
 
 	/* If noise info not available, calculate signal quality indicator (%)
 	 *   using just the dBm signal level. */
 	} else {
-		stats.noise = priv->last_rx_noise;
-		stats.signal = iwl3945_calc_sig_qual(stats.ssi, 0);
+		rx_status.noise = priv->last_rx_noise;
+		rx_status.signal = iwl3945_calc_sig_qual(rx_status.ssi, 0);
 	}
 
 
 	IWL_DEBUG_STATS("Rssi %d noise %d qual %d sig_avg %d noise_diff %d\n",
-			stats.ssi, stats.noise, stats.signal,
+			rx_status.ssi, rx_status.noise, rx_status.signal,
 			rx_stats_sig_avg, rx_stats_noise_diff);
 
-	/* can be covered by iwl3945_report_frame() in most cases */
-/*      IWL_DEBUG_RX("RX status: 0x%08X\n", rx_end->status); */
-
 	header = (struct ieee80211_hdr *)IWL_RX_DATA(pkt);
 
 	network_packet = iwl3945_is_network_packet(priv, header);
 
-#ifdef CONFIG_IWL3945_DEBUG
-	if (iwl3945_debug_level & IWL_DL_STATS && net_ratelimit())
-		IWL_DEBUG_STATS
-		    ("[%c] %d RSSI: %d Signal: %u, Noise: %u, Rate: %u\n",
-		     network_packet ? '*' : ' ',
-		     le16_to_cpu(rx_hdr->channel),
-		     stats.ssi, stats.ssi,
-		     stats.ssi, stats.rate_idx);
+	IWL_DEBUG_STATS_LIMIT("[%c] %d RSSI:%d Signal:%u, Noise:%u, Rate:%u\n",
+			      network_packet ? '*' : ' ',
+			      le16_to_cpu(rx_hdr->channel),
+			      rx_status.ssi, rx_status.ssi,
+			      rx_status.ssi, rx_status.rate_idx);
 
+#ifdef CONFIG_IWL3945_DEBUG
 	if (iwl3945_debug_level & (IWL_DL_RX))
 		/* Set "1" to report good data frames in groups of 100 */
-		iwl3945_report_frame(priv, pkt, header, 1);
+		iwl3945_dbg_report_frame(priv, pkt, header, 1);
 #endif
 
 	if (network_packet) {
 		priv->last_beacon_time = le32_to_cpu(rx_end->beacon_timestamp);
 		priv->last_tsf = le64_to_cpu(rx_end->timestamp);
-		priv->last_rx_rssi = stats.ssi;
-		priv->last_rx_noise = stats.noise;
+		priv->last_rx_rssi = rx_status.ssi;
+		priv->last_rx_noise = rx_status.noise;
 	}
 
 	switch (le16_to_cpu(header->frame_control) & IEEE80211_FCTL_FTYPE) {
@@ -560,7 +721,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 			}
 		}
 
-		iwl3945_handle_data_packet(priv, 0, rxb, &stats);
+		iwl3945_handle_data_packet(priv, 0, rxb, &rx_status);
 		break;
 
 	case IEEE80211_FTYPE_CTL:
@@ -577,7 +738,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 				       print_mac(mac2, header->addr2),
 				       print_mac(mac3, header->addr3));
 		else
-			iwl3945_handle_data_packet(priv, 1, rxb, &stats);
+			iwl3945_handle_data_packet(priv, 1, rxb, &rx_status);
 		break;
 	}
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index d36ae00..d281e42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -558,16 +558,6 @@ extern int iwl3945_is_network_packet(struct iwl3945_priv *priv,
 				 struct ieee80211_hdr *header);
 extern int iwl3945_power_init_handle(struct iwl3945_priv *priv);
 extern int iwl3945_eeprom_init(struct iwl3945_priv *priv);
-#ifdef CONFIG_IWL3945_DEBUG
-extern void iwl3945_report_frame(struct iwl3945_priv *priv,
-			     struct iwl3945_rx_packet *pkt,
-			     struct ieee80211_hdr *header, int group100);
-#else
-static inline void iwl3945_report_frame(struct iwl3945_priv *priv,
-				    struct iwl3945_rx_packet *pkt,
-				    struct ieee80211_hdr *header,
-				    int group100) {}
-#endif
 extern void iwl3945_handle_data_packet_monitor(struct iwl3945_priv *priv,
 					   struct iwl3945_rx_mem_buffer *rxb,
 					   void *data, short len,
@@ -949,16 +939,6 @@ static inline int is_channel_ibss(const struct iwl3945_channel_info *ch)
 	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
 }
 
-static inline int iwl3945_rate_index_from_plcp(int plcp)
-{
-	int i;
-
-	for (i = 0; i < IWL_RATE_COUNT; i++)
-		if (iwl3945_rates[i].plcp == plcp)
-			return i;
-	return -1;
-}
-
 extern const struct iwl3945_channel_info *iwl3945_get_channel_info(
 	const struct iwl3945_priv *priv, enum ieee80211_band band, u16 channel);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-debug.h b/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
index 36696bb..baf07c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
@@ -40,15 +40,30 @@ do { if (iwl4965_debug_level & (level)) \
 do { if ((iwl4965_debug_level & (level)) && net_ratelimit()) \
   printk(KERN_ERR DRV_NAME": %c %s " fmt, \
 	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+
+static inline void iwl4965_print_hex_dump(int level, void *p, u32 len)
+{
+	if (!(iwl4965_debug_level & level))
+		return;
+
+	print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET, 16, 1,
+			p, len, 1);
+}
 #else
+
 static inline void IWL_DEBUG(int level, const char *fmt, ...)
 {
 }
 static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
 {
 }
+static inline void iwl4965_print_hex_dump(int level, void *p, u32 len)
+{
+}
 #endif				/* CONFIG_IWL4965_DEBUG */
 
+
+
 /*
  * To use the debug system;
  *
@@ -143,6 +158,7 @@ static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
 	IWL_DEBUG_LIMIT(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
 #define IWL_DEBUG_HT(f, a...) IWL_DEBUG(IWL_DL_HT, f, ## a)
 #define IWL_DEBUG_STATS(f, a...) IWL_DEBUG(IWL_DL_STATS, f, ## a)
+#define IWL_DEBUG_STATS_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_STATS, f, ## a)
 #define IWL_DEBUG_TX_REPLY(f, a...) IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
 #define IWL_DEBUG_QOS(f, a...)   IWL_DEBUG(IWL_DL_QOS, f, ## a)
 #define IWL_DEBUG_RADIO(f, a...)  IWL_DEBUG(IWL_DL_RADIO, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 46d85fd..cf7b569 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -570,7 +570,7 @@ static int rs_get_tbl_info_from_mcs(const struct iwl4965_rate *mcs_rate,
 	int index;
 	u32 ant_msk;
 
-	index = iwl4965_rate_index_from_plcp(mcs_rate->rate_n_flags);
+	index = iwl4965_hwrate_to_plcp_idx(mcs_rate->rate_n_flags);
 
 	if (index  == IWL_RATE_INVALID) {
 		*rate_idx = -1;
@@ -1921,7 +1921,7 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 			tbl = &(lq_sta->lq_info[active_tbl]);
 
 			/* Revert to "active" rate and throughput info */
-			index = iwl4965_rate_index_from_plcp(
+			index = iwl4965_hwrate_to_plcp_idx(
 				tbl->current_rate.rate_n_flags);
 			current_tpt = lq_sta->last_tpt;
 
@@ -2077,7 +2077,7 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 				rs_rate_scale_clear_window(&(tbl->win[i]));
 
 			/* Use new "search" start rate */
-			index = iwl4965_rate_index_from_plcp(
+			index = iwl4965_hwrate_to_plcp_idx(
 					tbl->current_rate.rate_n_flags);
 
 			IWL_DEBUG_HT("Switch current  mcs: %X index: %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
index 13b6c72..911f213 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
@@ -259,7 +259,7 @@ static inline u8 iwl4965_get_prev_ieee_rate(u8 rate_index)
 	return rate;
 }
 
-extern int iwl4965_rate_index_from_plcp(int plcp);
+extern int iwl4965_hwrate_to_plcp_idx(u32 rate_n_flags);
 
 /**
  * iwl4965_fill_rs_info - Fill an output text buffer with the rate representation
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a9c30bc..8b9c419 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -122,6 +122,35 @@ static u8 is_single_stream(struct iwl4965_priv *priv)
 	return 0;
 }
 
+int iwl4965_hwrate_to_plcp_idx(u32 rate_n_flags)
+{
+	int idx = 0;
+
+	/* 4965 HT rate format */
+	if (rate_n_flags & RATE_MCS_HT_MSK) {
+		idx = (rate_n_flags & 0xff);
+
+		if (idx >= IWL_RATE_MIMO_6M_PLCP)
+			idx = idx - IWL_RATE_MIMO_6M_PLCP;
+
+		idx += IWL_FIRST_OFDM_RATE;
+		/* skip 9M not supported in ht*/
+		if (idx >= IWL_RATE_9M_INDEX)
+			idx += 1;
+		if ((idx >= IWL_FIRST_OFDM_RATE) && (idx <= IWL_LAST_OFDM_RATE))
+			return idx;
+
+	/* 4965 legacy rate format, search for match in table */
+	} else {
+		for (idx = 0; idx < ARRAY_SIZE(iwl4965_rates); idx++)
+			if (iwl4965_rates[idx].plcp == (rate_n_flags & 0xFF))
+				return idx;
+	}
+
+	return -1;
+}
+
+
 /*
  * Determine how many receiver/antenna chains to use.
  * More provides better reception via diversity.  Fewer saves power.
@@ -3523,6 +3552,160 @@ static void iwl4965_update_ps_mode(struct iwl4965_priv *priv, u16 ps_bit, u8 *ad
 		}
 	}
 }
+#ifdef CONFIG_IWL4965_DEBUG
+
+/**
+ * iwl4965_dbg_report_frame - dump frame to syslog during debug sessions
+ *
+ * You may hack this function to show different aspects of received frames,
+ * including selective frame dumps.
+ * group100 parameter selects whether to show 1 out of 100 good frames.
+ *
+ * TODO:  This was originally written for 3945, need to audit for
+ *        proper operation with 4965.
+ */
+static void iwl4965_dbg_report_frame(struct iwl4965_priv *priv,
+		      struct iwl4965_rx_packet *pkt,
+		      struct ieee80211_hdr *header, int group100)
+{
+	u32 to_us;
+	u32 print_summary = 0;
+	u32 print_dump = 0;	/* set to 1 to dump all frames' contents */
+	u32 hundred = 0;
+	u32 dataframe = 0;
+	u16 fc;
+	u16 seq_ctl;
+	u16 channel;
+	u16 phy_flags;
+	int rate_sym;
+	u16 length;
+	u16 status;
+	u16 bcn_tmr;
+	u32 tsf_low;
+	u64 tsf;
+	u8 rssi;
+	u8 agc;
+	u16 sig_avg;
+	u16 noise_diff;
+	struct iwl4965_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
+	struct iwl4965_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
+	struct iwl4965_rx_frame_end *rx_end = IWL_RX_END(pkt);
+	u8 *data = IWL_RX_DATA(pkt);
+
+	if (likely(!(iwl4965_debug_level & IWL_DL_RX)))
+		return;
+
+	/* MAC header */
+	fc = le16_to_cpu(header->frame_control);
+	seq_ctl = le16_to_cpu(header->seq_ctrl);
+
+	/* metadata */
+	channel = le16_to_cpu(rx_hdr->channel);
+	phy_flags = le16_to_cpu(rx_hdr->phy_flags);
+	rate_sym = rx_hdr->rate;
+	length = le16_to_cpu(rx_hdr->len);
+
+	/* end-of-frame status and timestamp */
+	status = le32_to_cpu(rx_end->status);
+	bcn_tmr = le32_to_cpu(rx_end->beacon_timestamp);
+	tsf_low = le64_to_cpu(rx_end->timestamp) & 0x0ffffffff;
+	tsf = le64_to_cpu(rx_end->timestamp);
+
+	/* signal statistics */
+	rssi = rx_stats->rssi;
+	agc = rx_stats->agc;
+	sig_avg = le16_to_cpu(rx_stats->sig_avg);
+	noise_diff = le16_to_cpu(rx_stats->noise_diff);
+
+	to_us = !compare_ether_addr(header->addr1, priv->mac_addr);
+
+	/* if data frame is to us and all is good,
+	 *   (optionally) print summary for only 1 out of every 100 */
+	if (to_us && (fc & ~IEEE80211_FCTL_PROTECTED) ==
+	    (IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
+		dataframe = 1;
+		if (!group100)
+			print_summary = 1;	/* print each frame */
+		else if (priv->framecnt_to_us < 100) {
+			priv->framecnt_to_us++;
+			print_summary = 0;
+		} else {
+			priv->framecnt_to_us = 0;
+			print_summary = 1;
+			hundred = 1;
+		}
+	} else {
+		/* print summary for all other frames */
+		print_summary = 1;
+	}
+
+	if (print_summary) {
+		char *title;
+		int rate_idx;
+		u32 bitrate;
+
+		if (hundred)
+			title = "100Frames";
+		else if (fc & IEEE80211_FCTL_RETRY)
+			title = "Retry";
+		else if (ieee80211_is_assoc_response(fc))
+			title = "AscRsp";
+		else if (ieee80211_is_reassoc_response(fc))
+			title = "RasRsp";
+		else if (ieee80211_is_probe_response(fc)) {
+			title = "PrbRsp";
+			print_dump = 1;	/* dump frame contents */
+		} else if (ieee80211_is_beacon(fc)) {
+			title = "Beacon";
+			print_dump = 1;	/* dump frame contents */
+		} else if (ieee80211_is_atim(fc))
+			title = "ATIM";
+		else if (ieee80211_is_auth(fc))
+			title = "Auth";
+		else if (ieee80211_is_deauth(fc))
+			title = "DeAuth";
+		else if (ieee80211_is_disassoc(fc))
+			title = "DisAssoc";
+		else
+			title = "Frame";
+
+		rate_idx = iwl4965_hwrate_to_plcp_idx(rate_sym);
+		if (unlikely(rate_idx == -1))
+			bitrate = 0;
+		else
+			bitrate = iwl4965_rates[rate_idx].ieee / 2;
+
+		/* print frame summary.
+		 * MAC addresses show just the last byte (for brevity),
+		 *    but you can hack it to show more, if you'd like to. */
+		if (dataframe)
+			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
+				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
+				     title, fc, header->addr1[5],
+				     length, rssi, channel, bitrate);
+		else {
+			/* src/dst addresses assume managed mode */
+			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, "
+				     "src=0x%02x, rssi=%u, tim=%lu usec, "
+				     "phy=0x%02x, chnl=%d\n",
+				     title, fc, header->addr1[5],
+				     header->addr3[5], rssi,
+				     tsf_low - priv->scan_start_tsf,
+				     phy_flags, channel);
+		}
+	}
+	if (print_dump)
+		iwl4965_print_hex_dump(IWL_DL_RX, data, length);
+}
+#else
+static inline void iwl4965_dbg_report_frame(struct iwl4965_priv *priv,
+					    struct iwl4965_rx_packet *pkt,
+					    struct ieee80211_hdr *header,
+					    int group100)
+{
+}
+#endif
+
 
 #define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 
@@ -3531,6 +3714,8 @@ static void iwl4965_update_ps_mode(struct iwl4965_priv *priv, u16 ps_bit, u8 *ad
 static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
 				struct iwl4965_rx_mem_buffer *rxb)
 {
+	struct ieee80211_hdr *header;
+	struct ieee80211_rx_status rx_status;
 	struct iwl4965_rx_packet *pkt = (void *)rxb->skb->data;
 	/* Use phy data (Rx signal strength, etc.) contained within
 	 *   this rx packet for legacy frames,
@@ -3541,27 +3726,29 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
 		(struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
 	__le32 *rx_end;
 	unsigned int len = 0;
-	struct ieee80211_hdr *header;
 	u16 fc;
-	struct ieee80211_rx_status stats = {
-		.mactime = le64_to_cpu(rx_start->timestamp),
-		.freq = ieee80211chan2mhz(le16_to_cpu(rx_start->channel)),
-		.band =
-			(rx_start->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
-			IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ,
-		.antenna = 0,
-		.rate_idx = iwl4965_rate_index_from_plcp(
-				le32_to_cpu(rx_start->rate_n_flags)),
-		.flag = 0,
-	};
 	u8 network_packet;
 
+	rx_status.mactime = le64_to_cpu(rx_start->timestamp);
+	rx_status.freq = ieee80211chan2mhz(le16_to_cpu(rx_start->channel));
+	rx_status.band = (rx_start->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
+				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+	rx_status.rate_idx = iwl4965_hwrate_to_plcp_idx(
+					le32_to_cpu(rx_start->rate_n_flags));
+
+	if (rx_status.band == IEEE80211_BAND_5GHZ)
+		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
+
+	rx_status.antenna = 0;
+	rx_status.flag = 0;
+
 	if ((unlikely(rx_start->cfg_phy_cnt > 20))) {
 		IWL_DEBUG_DROP
 			("dsp size out of range [0,20]: "
 			 "%d/n", rx_start->cfg_phy_cnt);
 		return;
 	}
+
 	if (!include_phy) {
 		if (priv->last_phy_res[0])
 			rx_start = (struct iwl4965_rx_phy_res *)
@@ -3580,7 +3767,7 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
 						  + rx_start->cfg_phy_cnt);
 
 		len = le16_to_cpu(rx_start->byte_count);
-		rx_end = (__le32 *) (pkt->u.raw + rx_start->cfg_phy_cnt +
+		rx_end = (__le32 *)(pkt->u.raw + rx_start->cfg_phy_cnt +
 				  sizeof(struct iwl4965_rx_phy_res) + len);
 	} else {
 		struct iwl4965_rx_mpdu_res_start *amsdu =
@@ -3603,7 +3790,7 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
 	priv->ucode_beacon_time = le32_to_cpu(rx_start->beacon_time_stamp);
 
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
-	stats.ssi = iwl4965_calc_rssi(rx_start);
+	rx_status.ssi = iwl4965_calc_rssi(rx_start);
 
 	/* Meaningful noise values are available only from beacon statistics,
 	 *   which are gathered only when associated, and indicate noise
@@ -3611,32 +3798,29 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
 	 * Ignore these noise values while scanning (other channels) */
 	if (iwl4965_is_associated(priv) &&
 	    !test_bit(STATUS_SCANNING, &priv->status)) {
-		stats.noise = priv->last_rx_noise;
-		stats.signal = iwl4965_calc_sig_qual(stats.ssi, stats.noise);
+		rx_status.noise = priv->last_rx_noise;
+		rx_status.signal = iwl4965_calc_sig_qual(rx_status.ssi,
+							 rx_status.noise);
 	} else {
-		stats.noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
-		stats.signal = iwl4965_calc_sig_qual(stats.ssi, 0);
+		rx_status.noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
+		rx_status.signal = iwl4965_calc_sig_qual(rx_status.ssi, 0);
 	}
 
 	/* Reset beacon noise level if not associated. */
 	if (!iwl4965_is_associated(priv))
 		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
 
-#ifdef CONFIG_IWL4965_DEBUG
-	/* TODO:  Parts of iwl4965_report_frame are broken for 4965 */
-	if (iwl4965_debug_level & (IWL_DL_RX))
-		/* Set "1" to report good data frames in groups of 100 */
-		iwl4965_report_frame(priv, pkt, header, 1);
-
-	if (iwl4965_debug_level & (IWL_DL_RX | IWL_DL_STATS))
-	IWL_DEBUG_RX("Rssi %d, noise %d, qual %d, TSF %lu\n",
-		stats.ssi, stats.noise, stats.signal,
-		 (long unsigned int)le64_to_cpu(rx_start->timestamp));
-#endif
+	/* Set "1" to report good data frames in groups of 100 */
+	/* FIXME: need to optimze the call: */
+	iwl4965_dbg_report_frame(priv, pkt, header, 1);
+
+	IWL_DEBUG_STATS_LIMIT("Rssi %d, noise %d, qual %d, TSF %llu\n",
+			      rx_status.ssi, rx_status.noise, rx_status.signal,
+			      rx_status.mactime);
 
 	network_packet = iwl4965_is_network_packet(priv, header);
 	if (network_packet) {
-		priv->last_rx_rssi = stats.ssi;
+		priv->last_rx_rssi = rx_status.ssi;
 		priv->last_beacon_time =  priv->ucode_beacon_time;
 		priv->last_tsf = le64_to_cpu(rx_start->timestamp);
 	}
@@ -3739,7 +3923,7 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
 				return;
 			}
 		}
-		iwl4965_handle_data_packet(priv, 0, include_phy, rxb, &stats);
+		iwl4965_handle_data_packet(priv, 0, include_phy, rxb, &rx_status);
 		break;
 
 	case IEEE80211_FTYPE_CTL:
@@ -3748,7 +3932,7 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
 		case IEEE80211_STYPE_BACK_REQ:
 			IWL_DEBUG_HT("IEEE80211_STYPE_BACK_REQ arrived\n");
 			iwl4965_handle_data_packet(priv, 0, include_phy,
-						rxb, &stats);
+						rxb, &rx_status);
 			break;
 		default:
 			break;
@@ -3778,7 +3962,7 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
 				       print_mac(mac3, header->addr3));
 		else
 			iwl4965_handle_data_packet(priv, 1, include_phy, rxb,
-						   &stats);
+						   &rx_status);
 		break;
 	}
 	default:
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index cc0745b..4b3def3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -633,16 +633,6 @@ extern int iwl4965_is_network_packet(struct iwl4965_priv *priv,
 				 struct ieee80211_hdr *header);
 extern int iwl4965_power_init_handle(struct iwl4965_priv *priv);
 extern int iwl4965_eeprom_init(struct iwl4965_priv *priv);
-#ifdef CONFIG_IWL4965_DEBUG
-extern void iwl4965_report_frame(struct iwl4965_priv *priv,
-			     struct iwl4965_rx_packet *pkt,
-			     struct ieee80211_hdr *header, int group100);
-#else
-static inline void iwl4965_report_frame(struct iwl4965_priv *priv,
-				    struct iwl4965_rx_packet *pkt,
-				    struct ieee80211_hdr *header,
-				    int group100) {}
-#endif
 extern void iwl4965_handle_data_packet_monitor(struct iwl4965_priv *priv,
 					   struct iwl4965_rx_mem_buffer *rxb,
 					   void *data, short len,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0cafbd4..7a72048 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -162,17 +162,6 @@ static const char *iwl3945_escape_essid(const char *essid, u8 essid_len)
 	return escaped;
 }
 
-static void iwl3945_print_hex_dump(int level, void *p, u32 len)
-{
-#ifdef CONFIG_IWL3945_DEBUG
-	if (!(iwl3945_debug_level & level))
-		return;
-
-	print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET, 16, 1,
-			p, len, 1);
-#endif
-}
-
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
  * DMA services
  *
@@ -1630,151 +1619,6 @@ int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 	return 0;
 }
 
-/******************************************************************************
- *
- * Misc. internal state and helper functions
- *
- ******************************************************************************/
-#ifdef CONFIG_IWL3945_DEBUG
-
-/**
- * iwl3945_report_frame - dump frame to syslog during debug sessions
- *
- * You may hack this function to show different aspects of received frames,
- * including selective frame dumps.
- * group100 parameter selects whether to show 1 out of 100 good frames.
- */
-void iwl3945_report_frame(struct iwl3945_priv *priv,
-		      struct iwl3945_rx_packet *pkt,
-		      struct ieee80211_hdr *header, int group100)
-{
-	u32 to_us;
-	u32 print_summary = 0;
-	u32 print_dump = 0;	/* set to 1 to dump all frames' contents */
-	u32 hundred = 0;
-	u32 dataframe = 0;
-	u16 fc;
-	u16 seq_ctl;
-	u16 channel;
-	u16 phy_flags;
-	int rate_sym;
-	u16 length;
-	u16 status;
-	u16 bcn_tmr;
-	u32 tsf_low;
-	u64 tsf;
-	u8 rssi;
-	u8 agc;
-	u16 sig_avg;
-	u16 noise_diff;
-	struct iwl3945_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
-	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
-	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
-	u8 *data = IWL_RX_DATA(pkt);
-
-	/* MAC header */
-	fc = le16_to_cpu(header->frame_control);
-	seq_ctl = le16_to_cpu(header->seq_ctrl);
-
-	/* metadata */
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
-
-	/* signal statistics */
-	rssi = rx_stats->rssi;
-	agc = rx_stats->agc;
-	sig_avg = le16_to_cpu(rx_stats->sig_avg);
-	noise_diff = le16_to_cpu(rx_stats->noise_diff);
-
-	to_us = !compare_ether_addr(header->addr1, priv->mac_addr);
-
-	/* if data frame is to us and all is good,
-	 *   (optionally) print summary for only 1 out of every 100 */
-	if (to_us && (fc & ~IEEE80211_FCTL_PROTECTED) ==
-	    (IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
-		dataframe = 1;
-		if (!group100)
-			print_summary = 1;	/* print each frame */
-		else if (priv->framecnt_to_us < 100) {
-			priv->framecnt_to_us++;
-			print_summary = 0;
-		} else {
-			priv->framecnt_to_us = 0;
-			print_summary = 1;
-			hundred = 1;
-		}
-	} else {
-		/* print summary for all other frames */
-		print_summary = 1;
-	}
-
-	if (print_summary) {
-		char *title;
-		u32 rate;
-
-		if (hundred)
-			title = "100Frames";
-		else if (fc & IEEE80211_FCTL_RETRY)
-			title = "Retry";
-		else if (ieee80211_is_assoc_response(fc))
-			title = "AscRsp";
-		else if (ieee80211_is_reassoc_response(fc))
-			title = "RasRsp";
-		else if (ieee80211_is_probe_response(fc)) {
-			title = "PrbRsp";
-			print_dump = 1;	/* dump frame contents */
-		} else if (ieee80211_is_beacon(fc)) {
-			title = "Beacon";
-			print_dump = 1;	/* dump frame contents */
-		} else if (ieee80211_is_atim(fc))
-			title = "ATIM";
-		else if (ieee80211_is_auth(fc))
-			title = "Auth";
-		else if (ieee80211_is_deauth(fc))
-			title = "DeAuth";
-		else if (ieee80211_is_disassoc(fc))
-			title = "DisAssoc";
-		else
-			title = "Frame";
-
-		rate = iwl3945_rate_index_from_plcp(rate_sym);
-		if (rate == -1)
-			rate = 0;
-		else
-			rate = iwl3945_rates[rate].ieee / 2;
-
-		/* print frame summary.
-		 * MAC addresses show just the last byte (for brevity),
-		 *    but you can hack it to show more, if you'd like to. */
-		if (dataframe)
-			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
-				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
-				     title, fc, header->addr1[5],
-				     length, rssi, channel, rate);
-		else {
-			/* src/dst addresses assume managed mode */
-			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, "
-				     "src=0x%02x, rssi=%u, tim=%lu usec, "
-				     "phy=0x%02x, chnl=%d\n",
-				     title, fc, header->addr1[5],
-				     header->addr3[5], rssi,
-				     tsf_low - priv->scan_start_tsf,
-				     phy_flags, channel);
-		}
-	}
-	if (print_dump)
-		iwl3945_print_hex_dump(IWL_DL_RX, data, length);
-}
-#endif
-
 static void iwl3945_unset_hw_setting(struct iwl3945_priv *priv)
 {
 	if (priv->hw_setting.shared_virt)
@@ -7895,31 +7739,6 @@ static DEVICE_ATTR(measurement, S_IRUSR | S_IWUSR,
 		   show_measurement, store_measurement);
 #endif /* CONFIG_IWL3945_SPECTRUM_MEASUREMENT */
 
-static ssize_t show_rate(struct device *d,
-			 struct device_attribute *attr, char *buf)
-{
-	struct iwl3945_priv *priv = dev_get_drvdata(d);
-	unsigned long flags;
-	int i;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	if (priv->iw_mode == IEEE80211_IF_TYPE_STA)
-		i = priv->stations[IWL_AP_ID].current_rate.s.rate;
-	else
-		i = priv->stations[IWL_STA_ID].current_rate.s.rate;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	i = iwl3945_rate_index_from_plcp(i);
-	if (i == -1)
-		return sprintf(buf, "0\n");
-
-	return sprintf(buf, "%d%s\n",
-		       (iwl3945_rates[i].ieee >> 1),
-		       (iwl3945_rates[i].ieee & 0x1) ? ".5" : "");
-}
-
-static DEVICE_ATTR(rate, S_IRUSR, show_rate, NULL);
-
 static ssize_t store_retry_rate(struct device *d,
 				struct device_attribute *attr,
 				const char *buf, size_t count)
@@ -8210,7 +8029,6 @@ static struct attribute *iwl3945_sysfs_entries[] = {
 	&dev_attr_measurement.attr,
 #endif
 	&dev_attr_power_level.attr,
-	&dev_attr_rate.attr,
 	&dev_attr_retry_rate.attr,
 	&dev_attr_rf_kill.attr,
 	&dev_attr_rs_window.attr,
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 46a43ff..2ed6937 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -161,17 +161,6 @@ static const char *iwl4965_escape_essid(const char *essid, u8 essid_len)
 	return escaped;
 }
 
-static void iwl4965_print_hex_dump(int level, void *p, u32 len)
-{
-#ifdef CONFIG_IWL4965_DEBUG
-	if (!(iwl4965_debug_level & level))
-		return;
-
-	print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET, 16, 1,
-			p, len, 1);
-#endif
-}
-
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
  * DMA services
  *
@@ -1551,34 +1540,6 @@ unsigned int iwl4965_fill_beacon_frame(struct iwl4965_priv *priv,
 	return priv->ibss_beacon->len;
 }
 
-int iwl4965_rate_index_from_plcp(int plcp)
-{
-	int i = 0;
-
-	/* 4965 HT rate format */
-	if (plcp & RATE_MCS_HT_MSK) {
-		i = (plcp & 0xff);
-
-		if (i >= IWL_RATE_MIMO_6M_PLCP)
-			i = i - IWL_RATE_MIMO_6M_PLCP;
-
-		i += IWL_FIRST_OFDM_RATE;
-		/* skip 9M not supported in ht*/
-		if (i >= IWL_RATE_9M_INDEX)
-			i += 1;
-		if ((i >= IWL_FIRST_OFDM_RATE) &&
-		    (i <= IWL_LAST_OFDM_RATE))
-			return i;
-
-	/* 4965 legacy rate format, search for match in table */
-	} else {
-		for (i = 0; i < ARRAY_SIZE(iwl4965_rates); i++)
-			if (iwl4965_rates[i].plcp == (plcp &0xFF))
-				return i;
-	}
-	return -1;
-}
-
 static u8 iwl4965_rate_get_lowest_plcp(int rate_mask)
 {
 	u8 i;
@@ -1712,148 +1673,6 @@ done:
  * Misc. internal state and helper functions
  *
  ******************************************************************************/
-#ifdef CONFIG_IWL4965_DEBUG
-
-/**
- * iwl4965_report_frame - dump frame to syslog during debug sessions
- *
- * You may hack this function to show different aspects of received frames,
- * including selective frame dumps.
- * group100 parameter selects whether to show 1 out of 100 good frames.
- *
- * TODO:  This was originally written for 3945, need to audit for
- *        proper operation with 4965.
- */
-void iwl4965_report_frame(struct iwl4965_priv *priv,
-		      struct iwl4965_rx_packet *pkt,
-		      struct ieee80211_hdr *header, int group100)
-{
-	u32 to_us;
-	u32 print_summary = 0;
-	u32 print_dump = 0;	/* set to 1 to dump all frames' contents */
-	u32 hundred = 0;
-	u32 dataframe = 0;
-	u16 fc;
-	u16 seq_ctl;
-	u16 channel;
-	u16 phy_flags;
-	int rate_sym;
-	u16 length;
-	u16 status;
-	u16 bcn_tmr;
-	u32 tsf_low;
-	u64 tsf;
-	u8 rssi;
-	u8 agc;
-	u16 sig_avg;
-	u16 noise_diff;
-	struct iwl4965_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
-	struct iwl4965_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
-	struct iwl4965_rx_frame_end *rx_end = IWL_RX_END(pkt);
-	u8 *data = IWL_RX_DATA(pkt);
-
-	/* MAC header */
-	fc = le16_to_cpu(header->frame_control);
-	seq_ctl = le16_to_cpu(header->seq_ctrl);
-
-	/* metadata */
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
-
-	/* signal statistics */
-	rssi = rx_stats->rssi;
-	agc = rx_stats->agc;
-	sig_avg = le16_to_cpu(rx_stats->sig_avg);
-	noise_diff = le16_to_cpu(rx_stats->noise_diff);
-
-	to_us = !compare_ether_addr(header->addr1, priv->mac_addr);
-
-	/* if data frame is to us and all is good,
-	 *   (optionally) print summary for only 1 out of every 100 */
-	if (to_us && (fc & ~IEEE80211_FCTL_PROTECTED) ==
-	    (IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
-		dataframe = 1;
-		if (!group100)
-			print_summary = 1;	/* print each frame */
-		else if (priv->framecnt_to_us < 100) {
-			priv->framecnt_to_us++;
-			print_summary = 0;
-		} else {
-			priv->framecnt_to_us = 0;
-			print_summary = 1;
-			hundred = 1;
-		}
-	} else {
-		/* print summary for all other frames */
-		print_summary = 1;
-	}
-
-	if (print_summary) {
-		char *title;
-		u32 rate;
-
-		if (hundred)
-			title = "100Frames";
-		else if (fc & IEEE80211_FCTL_RETRY)
-			title = "Retry";
-		else if (ieee80211_is_assoc_response(fc))
-			title = "AscRsp";
-		else if (ieee80211_is_reassoc_response(fc))
-			title = "RasRsp";
-		else if (ieee80211_is_probe_response(fc)) {
-			title = "PrbRsp";
-			print_dump = 1;	/* dump frame contents */
-		} else if (ieee80211_is_beacon(fc)) {
-			title = "Beacon";
-			print_dump = 1;	/* dump frame contents */
-		} else if (ieee80211_is_atim(fc))
-			title = "ATIM";
-		else if (ieee80211_is_auth(fc))
-			title = "Auth";
-		else if (ieee80211_is_deauth(fc))
-			title = "DeAuth";
-		else if (ieee80211_is_disassoc(fc))
-			title = "DisAssoc";
-		else
-			title = "Frame";
-
-		rate = iwl4965_rate_index_from_plcp(rate_sym);
-		if (rate == -1)
-			rate = 0;
-		else
-			rate = iwl4965_rates[rate].ieee / 2;
-
-		/* print frame summary.
-		 * MAC addresses show just the last byte (for brevity),
-		 *    but you can hack it to show more, if you'd like to. */
-		if (dataframe)
-			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
-				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
-				     title, fc, header->addr1[5],
-				     length, rssi, channel, rate);
-		else {
-			/* src/dst addresses assume managed mode */
-			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, "
-				     "src=0x%02x, rssi=%u, tim=%lu usec, "
-				     "phy=0x%02x, chnl=%d\n",
-				     title, fc, header->addr1[5],
-				     header->addr3[5], rssi,
-				     tsf_low - priv->scan_start_tsf,
-				     phy_flags, channel);
-		}
-	}
-	if (print_dump)
-		iwl4965_print_hex_dump(IWL_DL_RX, data, length);
-}
-#endif
 
 static void iwl4965_unset_hw_setting(struct iwl4965_priv *priv)
 {
-- 
1.5.3.4

