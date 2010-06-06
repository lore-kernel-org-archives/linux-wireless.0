Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab0FFG4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/23] iwlwifi: remove debug frame dumping
Date: Sat,  5 Jun 2010 23:56:21 -0700
Message-Id: <1275807398-18184-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This can now be much better achieved using
tracing and post-processing of the trace,
rather than doing the processing in place
in the driver, so remove a lot of code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c    |  154 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |  131 -----------------------
 2 files changed, 0 insertions(+), 285 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7d7e37e..7a34ef6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -494,158 +494,6 @@ void iwl3945_reply_statistics(struct iwl_priv *priv,
  * Misc. internal state and helper functions
  *
  ******************************************************************************/
-#ifdef CONFIG_IWLWIFI_DEBUG
-
-/**
- * iwl3945_report_frame - dump frame to syslog during debug sessions
- *
- * You may hack this function to show different aspects of received frames,
- * including selective frame dumps.
- * group100 parameter selects whether to show 1 out of 100 good frames.
- */
-static void _iwl3945_dbg_report_frame(struct iwl_priv *priv,
-		      struct iwl_rx_packet *pkt,
-		      struct ieee80211_hdr *header, int group100)
-{
-	u32 to_us;
-	u32 print_summary = 0;
-	u32 print_dump = 0;	/* set to 1 to dump all frames' contents */
-	u32 hundred = 0;
-	u32 dataframe = 0;
-	__le16 fc;
-	u16 seq_ctl;
-	u16 channel;
-	u16 phy_flags;
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
-	fc = header->frame_control;
-	seq_ctl = le16_to_cpu(header->seq_ctrl);
-
-	/* metadata */
-	channel = le16_to_cpu(rx_hdr->channel);
-	phy_flags = le16_to_cpu(rx_hdr->phy_flags);
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
-	if (to_us && (fc & ~cpu_to_le16(IEEE80211_FCTL_PROTECTED)) ==
-	    cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
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
-		int rate;
-
-		if (hundred)
-			title = "100Frames";
-		else if (ieee80211_has_retry(fc))
-			title = "Retry";
-		else if (ieee80211_is_assoc_resp(fc))
-			title = "AscRsp";
-		else if (ieee80211_is_reassoc_resp(fc))
-			title = "RasRsp";
-		else if (ieee80211_is_probe_resp(fc)) {
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
-		rate = iwl3945_hwrate_to_plcp_idx(rx_hdr->rate);
-		if (rate == -1)
-			rate = 0;
-		else
-			rate = iwl3945_rates[rate].ieee / 2;
-
-		/* print frame summary.
-		 * MAC addresses show just the last byte (for brevity),
-		 *    but you can hack it to show more, if you'd like to. */
-		if (dataframe)
-			IWL_DEBUG_RX(priv, "%s: mhd=0x%04x, dst=0x%02x, "
-				     "len=%u, rssi=%d, chnl=%d, rate=%d,\n",
-				     title, le16_to_cpu(fc), header->addr1[5],
-				     length, rssi, channel, rate);
-		else {
-			/* src/dst addresses assume managed mode */
-			IWL_DEBUG_RX(priv, "%s: 0x%04x, dst=0x%02x, "
-				     "src=0x%02x, rssi=%u, tim=%lu usec, "
-				     "phy=0x%02x, chnl=%d\n",
-				     title, le16_to_cpu(fc), header->addr1[5],
-				     header->addr3[5], rssi,
-				     tsf_low - priv->scan_start_tsf,
-				     phy_flags, channel);
-		}
-	}
-	if (print_dump)
-		iwl_print_hex_dump(priv, IWL_DL_RX, data, length);
-}
-
-static void iwl3945_dbg_report_frame(struct iwl_priv *priv,
-		      struct iwl_rx_packet *pkt,
-		      struct ieee80211_hdr *header, int group100)
-{
-	if (iwl_get_debug_level(priv) & IWL_DL_RX)
-		_iwl3945_dbg_report_frame(priv, pkt, header, group100);
-}
-
-#else
-static inline void iwl3945_dbg_report_frame(struct iwl_priv *priv,
-		      struct iwl_rx_packet *pkt,
-		      struct ieee80211_hdr *header, int group100)
-{
-}
-#endif
 
 /* This is necessary only for a number of statistics, see the caller. */
 static int iwl3945_is_network_packet(struct iwl_priv *priv,
@@ -777,8 +625,6 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 			      rx_status.signal, rx_status.signal,
 			      rx_status.rate_idx);
 
-	/* Set "1" to report good data frames in groups of 100 */
-	iwl3945_dbg_report_frame(priv, pkt, header, 1);
 	iwl_dbg_log_rx_data_frame(priv, le16_to_cpu(rx_hdr->len), header);
 
 	if (network_packet) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 42e6219..848cb3b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -758,132 +758,6 @@ static inline int iwlagn_calc_rssi(struct iwl_priv *priv,
 	return priv->cfg->ops->utils->calc_rssi(priv, rx_resp);
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-/**
- * iwlagn_dbg_report_frame - dump frame to syslog during debug sessions
- *
- * You may hack this function to show different aspects of received frames,
- * including selective frame dumps.
- * group100 parameter selects whether to show 1 out of 100 good data frames.
- *    All beacon and probe response frames are printed.
- */
-static void iwlagn_dbg_report_frame(struct iwl_priv *priv,
-		      struct iwl_rx_phy_res *phy_res, u16 length,
-		      struct ieee80211_hdr *header, int group100)
-{
-	u32 to_us;
-	u32 print_summary = 0;
-	u32 print_dump = 0;	/* set to 1 to dump all frames' contents */
-	u32 hundred = 0;
-	u32 dataframe = 0;
-	__le16 fc;
-	u16 seq_ctl;
-	u16 channel;
-	u16 phy_flags;
-	u32 rate_n_flags;
-	u32 tsf_low;
-	int rssi;
-
-	if (likely(!(iwl_get_debug_level(priv) & IWL_DL_RX)))
-		return;
-
-	/* MAC header */
-	fc = header->frame_control;
-	seq_ctl = le16_to_cpu(header->seq_ctrl);
-
-	/* metadata */
-	channel = le16_to_cpu(phy_res->channel);
-	phy_flags = le16_to_cpu(phy_res->phy_flags);
-	rate_n_flags = le32_to_cpu(phy_res->rate_n_flags);
-
-	/* signal statistics */
-	rssi = iwlagn_calc_rssi(priv, phy_res);
-	tsf_low = le64_to_cpu(phy_res->timestamp) & 0x0ffffffff;
-
-	to_us = !compare_ether_addr(header->addr1, priv->mac_addr);
-
-	/* if data frame is to us and all is good,
-	 *   (optionally) print summary for only 1 out of every 100 */
-	if (to_us && (fc & ~cpu_to_le16(IEEE80211_FCTL_PROTECTED)) ==
-	    cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
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
-		int rate_idx;
-		u32 bitrate;
-
-		if (hundred)
-			title = "100Frames";
-		else if (ieee80211_has_retry(fc))
-			title = "Retry";
-		else if (ieee80211_is_assoc_resp(fc))
-			title = "AscRsp";
-		else if (ieee80211_is_reassoc_resp(fc))
-			title = "RasRsp";
-		else if (ieee80211_is_probe_resp(fc)) {
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
-		rate_idx = iwl_hwrate_to_plcp_idx(rate_n_flags);
-		if (unlikely((rate_idx < 0) || (rate_idx >= IWL_RATE_COUNT))) {
-			bitrate = 0;
-			WARN_ON_ONCE(1);
-		} else {
-			bitrate = iwl_rates[rate_idx].ieee / 2;
-		}
-
-		/* print frame summary.
-		 * MAC addresses show just the last byte (for brevity),
-		 *    but you can hack it to show more, if you'd like to. */
-		if (dataframe)
-			IWL_DEBUG_RX(priv, "%s: mhd=0x%04x, dst=0x%02x, "
-				     "len=%u, rssi=%d, chnl=%d, rate=%u,\n",
-				     title, le16_to_cpu(fc), header->addr1[5],
-				     length, rssi, channel, bitrate);
-		else {
-			/* src/dst addresses assume managed mode */
-			IWL_DEBUG_RX(priv, "%s: 0x%04x, dst=0x%02x, src=0x%02x, "
-				     "len=%u, rssi=%d, tim=%lu usec, "
-				     "phy=0x%02x, chnl=%d\n",
-				     title, le16_to_cpu(fc), header->addr1[5],
-				     header->addr3[5], length, rssi,
-				     tsf_low - priv->scan_start_tsf,
-				     phy_flags, channel);
-		}
-	}
-	if (print_dump)
-		iwl_print_hex_dump(priv, IWL_DL_RX, header, length);
-}
-#endif
-
 static u32 iwlagn_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
 {
 	u32 decrypt_out = 0;
@@ -1063,11 +937,6 @@ void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
 	rx_status.signal = iwlagn_calc_rssi(priv, phy_res);
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-	/* Set "1" to report good data frames in groups of 100 */
-	if (unlikely(iwl_get_debug_level(priv) & IWL_DL_RX))
-		iwlagn_dbg_report_frame(priv, phy_res, len, header, 1);
-#endif
 	iwl_dbg_log_rx_data_frame(priv, len, header);
 	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, TSF %llu\n",
 		rx_status.signal, (unsigned long long)rx_status.mactime);
-- 
1.7.0.4

