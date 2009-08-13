Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:11292 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415AbZHMUbS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/13] iwlwifi: refactor packet reception code
Date: Thu, 13 Aug 2009 13:30:56 -0700
Message-Id: <1250195462-15811-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
References: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

This patch fixes a number of issues in iwl_rx_reply_rx and
iwl_pass_packet_to_mac80211.  These issues stem from the complexities of
managing two different types of packet commands for different hardware.

- Unify code handling rx_phy_res in SKB or cached to eliminate redundancy and
remove potential NULL pointer accesses
- Replace magic number with proper constant
- Optimize functions by moving early exit conditions before computation
- Comment code and improve some variable names
- Remove redundant computation in iwl_pass_packet_to_mac80211 by passing in the
correct, already-computed arguments.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-rx.c       |  204 ++++++++++-----------------
 2 files changed, 78 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 68d7719..9398ad7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1156,6 +1156,7 @@ struct iwl_wep_cmd {
 #define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	cpu_to_le16(1 << 2)
 #define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	cpu_to_le16(1 << 3)
 #define RX_RES_PHY_FLAGS_ANTENNA_MSK		cpu_to_le16(0xf0)
+#define RX_RES_PHY_FLAGS_ANTENNA_POS		4
 
 #define RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
 #define RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 43b2fce..092d327 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -853,61 +853,12 @@ static u32 iwl_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
 }
 
 static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
-				       int include_phy,
-				       struct iwl_rx_mem_buffer *rxb,
-				       struct ieee80211_rx_status *stats)
+					struct ieee80211_hdr *hdr,
+					u16 len,
+					u32 ampdu_status,
+					struct iwl_rx_mem_buffer *rxb,
+					struct ieee80211_rx_status *stats)
 {
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl_rx_phy_res *rx_start = (include_phy) ?
-	    (struct iwl_rx_phy_res *)&(pkt->u.raw[0]) : NULL;
-	struct ieee80211_hdr *hdr;
-	u16 len;
-	__le32 *rx_end;
-	unsigned int skblen;
-	u32 ampdu_status;
-	u32 ampdu_status_legacy;
-
-	if (!include_phy && priv->last_phy_res[0])
-		rx_start = (struct iwl_rx_phy_res *)&priv->last_phy_res[1];
-
-	if (!rx_start) {
-		IWL_ERR(priv, "MPDU frame without a PHY data\n");
-		return;
-	}
-	if (include_phy) {
-		hdr = (struct ieee80211_hdr *)((u8 *) &rx_start[1] +
-					       rx_start->cfg_phy_cnt);
-
-		len = le16_to_cpu(rx_start->byte_count);
-
-		rx_end = (__le32 *)((u8 *) &pkt->u.raw[0] +
-				  sizeof(struct iwl_rx_phy_res) +
-				  rx_start->cfg_phy_cnt + len);
-
-	} else {
-		struct iwl4965_rx_mpdu_res_start *amsdu =
-		    (struct iwl4965_rx_mpdu_res_start *)pkt->u.raw;
-
-		hdr = (struct ieee80211_hdr *)(pkt->u.raw +
-			       sizeof(struct iwl4965_rx_mpdu_res_start));
-		len =  le16_to_cpu(amsdu->byte_count);
-		rx_start->byte_count = amsdu->byte_count;
-		rx_end = (__le32 *) (((u8 *) hdr) + len);
-	}
-
-	ampdu_status = le32_to_cpu(*rx_end);
-	skblen = ((u8 *) rx_end - (u8 *) &pkt->u.raw[0]) + sizeof(u32);
-
-	if (!include_phy) {
-		/* New status scheme, need to translate */
-		ampdu_status_legacy = ampdu_status;
-		ampdu_status = iwl_translate_rx_status(priv, ampdu_status);
-	}
-
-	/* start from MAC */
-	skb_reserve(rxb->skb, (void *)hdr - (void *)pkt);
-	skb_put(rxb->skb, len);	/* end where data ends */
-
 	/* We only process data packets if the interface is open */
 	if (unlikely(!priv->is_open)) {
 		IWL_DEBUG_DROP_LIMIT(priv,
@@ -915,13 +866,15 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 		return;
 	}
 
-	hdr = (struct ieee80211_hdr *)rxb->skb->data;
-
-	/*  in case of HW accelerated crypto and bad decryption, drop */
+	/* In case of HW accelerated crypto and bad decryption, drop */
 	if (!priv->cfg->mod_params->sw_crypto &&
 	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
 		return;
 
+	/* Resize SKB from mac header to end of packet */
+	skb_reserve(rxb->skb, (void *)hdr - (void *)rxb->skb->data);
+	skb_put(rxb->skb, len);
+
 	iwl_update_stats(priv, false, hdr->frame_control, len);
 	memcpy(IEEE80211_SKB_RXCB(rxb->skb), stats, sizeof(*stats));
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb);
@@ -955,25 +908,66 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	struct ieee80211_hdr *header;
 	struct ieee80211_rx_status rx_status;
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	/* Use phy data (Rx signal strength, etc.) contained within
-	 *   this rx packet for legacy frames,
-	 *   or phy data cached from REPLY_RX_PHY_CMD for HT frames. */
-	int include_phy = (pkt->hdr.cmd == REPLY_RX);
-	struct iwl_rx_phy_res *rx_start = (include_phy) ?
-		(struct iwl_rx_phy_res *)&(pkt->u.raw[0]) :
-		(struct iwl_rx_phy_res *)&priv->last_phy_res[1];
-	__le32 *rx_end;
-	unsigned int len = 0;
+	struct iwl_rx_phy_res *phy_res;
+	__le32 rx_pkt_status;
+	struct iwl4965_rx_mpdu_res_start *amsdu;
+	u32 len;
+	u32 ampdu_status;
 	u16 fc;
-	u8 network_packet;
 
-	rx_status.mactime = le64_to_cpu(rx_start->timestamp);
+	/**
+	 * REPLY_RX and REPLY_RX_MPDU_CMD are handled differently.
+	 *	REPLY_RX: physical layer info is in this buffer
+	 *	REPLY_RX_MPDU_CMD: physical layer info was sent in separate
+	 *		command and cached in priv->last_phy_res
+	 *
+	 * Here we set up local variables depending on which command is
+	 * received.
+	 */
+	if (pkt->hdr.cmd == REPLY_RX) {
+		phy_res = (struct iwl_rx_phy_res *)pkt->u.raw;
+		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*phy_res)
+				+ phy_res->cfg_phy_cnt);
+
+		len = le16_to_cpu(phy_res->byte_count);
+		rx_pkt_status = *(__le32 *)(pkt->u.raw + sizeof(*phy_res) +
+				phy_res->cfg_phy_cnt + len);
+		ampdu_status = le32_to_cpu(rx_pkt_status);
+	} else {
+		if (!priv->last_phy_res[0]) {
+			IWL_ERR(priv, "MPDU frame without cached PHY data\n");
+			return;
+		}
+		phy_res = (struct iwl_rx_phy_res *)&priv->last_phy_res[1];
+		amsdu = (struct iwl4965_rx_mpdu_res_start *)pkt->u.raw;
+		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*amsdu));
+		len = le16_to_cpu(amsdu->byte_count);
+		rx_pkt_status = *(__le32 *)(pkt->u.raw + sizeof(*amsdu) + len);
+		ampdu_status = iwl_translate_rx_status(priv,
+				le32_to_cpu(rx_pkt_status));
+	}
+
+	if ((unlikely(phy_res->cfg_phy_cnt > 20))) {
+		IWL_DEBUG_DROP(priv, "dsp size out of range [0,20]: %d/n",
+				phy_res->cfg_phy_cnt);
+		return;
+	}
+
+	if (!(rx_pkt_status & RX_RES_STATUS_NO_CRC32_ERROR) ||
+	    !(rx_pkt_status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
+		IWL_DEBUG_RX(priv, "Bad CRC or FIFO: 0x%08X.\n",
+				le32_to_cpu(rx_pkt_status));
+		return;
+	}
+
+	/* rx_status carries information about the packet to mac80211 */
+	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
 	rx_status.freq =
-		ieee80211_channel_to_frequency(le16_to_cpu(rx_start->channel));
-	rx_status.band = (rx_start->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
+		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel));
+	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 	rx_status.rate_idx =
-		iwl_hwrate_to_plcp_idx(le32_to_cpu(rx_start->rate_n_flags));
+		iwl_hwrate_to_plcp_idx(le32_to_cpu(phy_res->rate_n_flags));
 	if (rx_status.band == IEEE80211_BAND_5GHZ)
 		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
 
@@ -983,54 +977,10 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	 * this W/A doesn't propagate it to the mac80211 */
 	/*rx_status.flag |= RX_FLAG_TSFT;*/
 
-	if ((unlikely(rx_start->cfg_phy_cnt > 20))) {
-		IWL_DEBUG_DROP(priv, "dsp size out of range [0,20]: %d/n",
-				rx_start->cfg_phy_cnt);
-		return;
-	}
-
-	if (!include_phy) {
-		if (priv->last_phy_res[0])
-			rx_start = (struct iwl_rx_phy_res *)
-				&priv->last_phy_res[1];
-		else
-			rx_start = NULL;
-	}
-
-	if (!rx_start) {
-		IWL_ERR(priv, "MPDU frame without a PHY data\n");
-		return;
-	}
-
-	if (include_phy) {
-		header = (struct ieee80211_hdr *)((u8 *) &rx_start[1]
-						  + rx_start->cfg_phy_cnt);
-
-		len = le16_to_cpu(rx_start->byte_count);
-		rx_end = (__le32 *)(pkt->u.raw + rx_start->cfg_phy_cnt +
-				  sizeof(struct iwl_rx_phy_res) + len);
-	} else {
-		struct iwl4965_rx_mpdu_res_start *amsdu =
-			(struct iwl4965_rx_mpdu_res_start *)pkt->u.raw;
-
-		header = (void *)(pkt->u.raw +
-			sizeof(struct iwl4965_rx_mpdu_res_start));
-		len = le16_to_cpu(amsdu->byte_count);
-		rx_end = (__le32 *) (pkt->u.raw +
-			sizeof(struct iwl4965_rx_mpdu_res_start) + len);
-	}
-
-	if (!(*rx_end & RX_RES_STATUS_NO_CRC32_ERROR) ||
-	    !(*rx_end & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
-		IWL_DEBUG_RX(priv, "Bad CRC or FIFO: 0x%08X.\n",
-				le32_to_cpu(*rx_end));
-		return;
-	}
-
-	priv->ucode_beacon_time = le32_to_cpu(rx_start->beacon_time_stamp);
+	priv->ucode_beacon_time = le32_to_cpu(phy_res->beacon_time_stamp);
 
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
-	rx_status.signal = iwl_calc_rssi(priv, rx_start);
+	rx_status.signal = iwl_calc_rssi(priv, phy_res);
 
 	/* Meaningful noise values are available only from beacon statistics,
 	 *   which are gathered only when associated, and indicate noise
@@ -1050,10 +1000,10 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	if (!iwl_is_associated(priv))
 		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
 
-	/* Set "1" to report good data frames in groups of 100 */
 #ifdef CONFIG_IWLWIFI_DEBUG
+	/* Set "1" to report good data frames in groups of 100 */
 	if (unlikely(iwl_get_debug_level(priv) & IWL_DL_RX))
-		iwl_dbg_report_frame(priv, rx_start, len, header, 1);
+		iwl_dbg_report_frame(priv, phy_res, len, header, 1);
 #endif
 	iwl_dbg_log_rx_data_frame(priv, len, header);
 	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, noise %d, qual %d, TSF %llu\n",
@@ -1073,18 +1023,18 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	 * new 802.11n radiotap field "RX chains" that is defined
 	 * as a bitmask.
 	 */
-	rx_status.antenna = le16_to_cpu(rx_start->phy_flags &
-					RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
+	rx_status.antenna =
+		le16_to_cpu(phy_res->phy_flags & RX_RES_PHY_FLAGS_ANTENNA_MSK)
+		>> RX_RES_PHY_FLAGS_ANTENNA_POS;
 
 	/* set the preamble flag if appropriate */
-	if (rx_start->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
+	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
 		rx_status.flag |= RX_FLAG_SHORTPRE;
 
-	network_packet = iwl_is_network_packet(priv, header);
-	if (network_packet) {
+	if (iwl_is_network_packet(priv, header)) {
 		priv->last_rx_rssi = rx_status.signal;
 		priv->last_beacon_time =  priv->ucode_beacon_time;
-		priv->last_tsf = le64_to_cpu(rx_start->timestamp);
+		priv->last_tsf = le64_to_cpu(phy_res->timestamp);
 	}
 
 	fc = le16_to_cpu(header->frame_control);
@@ -1096,8 +1046,8 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 						header->addr2);
 		/* fall through */
 	default:
-			iwl_pass_packet_to_mac80211(priv, include_phy, rxb,
-				   &rx_status);
+		iwl_pass_packet_to_mac80211(priv, header, len, ampdu_status,
+				rxb, &rx_status);
 		break;
 
 	}
-- 
1.5.6.3

