Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22725 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab0CYUo6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/22] iwlwifi: more clean up to move agn only rx functions from iwlcore to iwlagn
Date: Thu, 25 Mar 2010 13:44:42 -0700
Message-Id: <1269549890-19195-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Move more functions only used by agn driver from iwlcore to iwlagn.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |  436 +++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |   26 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    7 +
 drivers/net/wireless/iwlwifi/iwl-core.c    |   45 ---
 drivers/net/wireless/iwlwifi/iwl-core.h    |    7 -
 drivers/net/wireless/iwlwifi/iwl-rx.c      |  411 --------------------------
 8 files changed, 470 insertions(+), 472 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index cee31cd..af48d07 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1881,7 +1881,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 		info->flags |= iwl_tx_status_to_mac80211(status);
-		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
+		iwlagn_hwrate_to_tx_control(priv, rate_n_flags, info);
 		/* FIXME: code repetition end */
 
 		IWL_DEBUG_TX_REPLY(priv, "1 Frame 0x%x failure :%d\n",
@@ -2036,7 +2036,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	} else {
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		info->flags |= iwl_tx_status_to_mac80211(status);
-		iwl_hwrate_to_tx_control(priv,
+		iwlagn_hwrate_to_tx_control(priv,
 					le32_to_cpu(tx_resp->rate_n_flags),
 					info);
 
@@ -2102,7 +2102,7 @@ static int iwl4965_calc_rssi(struct iwl_priv *priv,
 static void iwl4965_rx_handler_setup(struct iwl_priv *priv)
 {
 	/* Legacy Rx frames */
-	priv->rx_handlers[REPLY_RX] = iwl_rx_reply_rx;
+	priv->rx_handlers[REPLY_RX] = iwlagn_rx_reply_rx;
 	/* Tx response */
 	priv->rx_handlers[REPLY_TX] = iwl4965_rx_reply_tx;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3117382..226862d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -26,7 +26,7 @@
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
-
+#include <linux/etherdevice.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -80,7 +80,7 @@ static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 		info->flags |= iwl_tx_status_to_mac80211(status);
-		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
+		iwlagn_hwrate_to_tx_control(priv, rate_n_flags, info);
 
 		/* FIXME: code repetition end */
 
@@ -225,7 +225,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		info->flags |= iwl_tx_status_to_mac80211(status);
-		iwl_hwrate_to_tx_control(priv,
+		iwlagn_hwrate_to_tx_control(priv,
 					le32_to_cpu(tx_resp->rate_n_flags),
 					info);
 
@@ -709,3 +709,433 @@ int iwlagn_rxq_stop(struct iwl_priv *priv)
 
 	return 0;
 }
+
+int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
+{
+	int idx = 0;
+	int band_offset = 0;
+
+	/* HT rate format: mac80211 wants an MCS number, which is just LSB */
+	if (rate_n_flags & RATE_MCS_HT_MSK) {
+		idx = (rate_n_flags & 0xff);
+		return idx;
+	/* Legacy rate format, search for match in table */
+	} else {
+		if (band == IEEE80211_BAND_5GHZ)
+			band_offset = IWL_FIRST_OFDM_RATE;
+		for (idx = band_offset; idx < IWL_RATE_COUNT_LEGACY; idx++)
+			if (iwl_rates[idx].plcp == (rate_n_flags & 0xFF))
+				return idx - band_offset;
+	}
+
+	return -1;
+}
+
+/* Calc max signal level (dBm) among 3 possible receivers */
+static inline int iwlagn_calc_rssi(struct iwl_priv *priv,
+				struct iwl_rx_phy_res *rx_resp)
+{
+	return priv->cfg->ops->utils->calc_rssi(priv, rx_resp);
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+/**
+ * iwlagn_dbg_report_frame - dump frame to syslog during debug sessions
+ *
+ * You may hack this function to show different aspects of received frames,
+ * including selective frame dumps.
+ * group100 parameter selects whether to show 1 out of 100 good data frames.
+ *    All beacon and probe response frames are printed.
+ */
+static void iwlagn_dbg_report_frame(struct iwl_priv *priv,
+		      struct iwl_rx_phy_res *phy_res, u16 length,
+		      struct ieee80211_hdr *header, int group100)
+{
+	u32 to_us;
+	u32 print_summary = 0;
+	u32 print_dump = 0;	/* set to 1 to dump all frames' contents */
+	u32 hundred = 0;
+	u32 dataframe = 0;
+	__le16 fc;
+	u16 seq_ctl;
+	u16 channel;
+	u16 phy_flags;
+	u32 rate_n_flags;
+	u32 tsf_low;
+	int rssi;
+
+	if (likely(!(iwl_get_debug_level(priv) & IWL_DL_RX)))
+		return;
+
+	/* MAC header */
+	fc = header->frame_control;
+	seq_ctl = le16_to_cpu(header->seq_ctrl);
+
+	/* metadata */
+	channel = le16_to_cpu(phy_res->channel);
+	phy_flags = le16_to_cpu(phy_res->phy_flags);
+	rate_n_flags = le32_to_cpu(phy_res->rate_n_flags);
+
+	/* signal statistics */
+	rssi = iwlagn_calc_rssi(priv, phy_res);
+	tsf_low = le64_to_cpu(phy_res->timestamp) & 0x0ffffffff;
+
+	to_us = !compare_ether_addr(header->addr1, priv->mac_addr);
+
+	/* if data frame is to us and all is good,
+	 *   (optionally) print summary for only 1 out of every 100 */
+	if (to_us && (fc & ~cpu_to_le16(IEEE80211_FCTL_PROTECTED)) ==
+	    cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
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
+		else if (ieee80211_has_retry(fc))
+			title = "Retry";
+		else if (ieee80211_is_assoc_resp(fc))
+			title = "AscRsp";
+		else if (ieee80211_is_reassoc_resp(fc))
+			title = "RasRsp";
+		else if (ieee80211_is_probe_resp(fc)) {
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
+		rate_idx = iwl_hwrate_to_plcp_idx(rate_n_flags);
+		if (unlikely((rate_idx < 0) || (rate_idx >= IWL_RATE_COUNT))) {
+			bitrate = 0;
+			WARN_ON_ONCE(1);
+		} else {
+			bitrate = iwl_rates[rate_idx].ieee / 2;
+		}
+
+		/* print frame summary.
+		 * MAC addresses show just the last byte (for brevity),
+		 *    but you can hack it to show more, if you'd like to. */
+		if (dataframe)
+			IWL_DEBUG_RX(priv, "%s: mhd=0x%04x, dst=0x%02x, "
+				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
+				     title, le16_to_cpu(fc), header->addr1[5],
+				     length, rssi, channel, bitrate);
+		else {
+			/* src/dst addresses assume managed mode */
+			IWL_DEBUG_RX(priv, "%s: 0x%04x, dst=0x%02x, src=0x%02x, "
+				     "len=%u, rssi=%d, tim=%lu usec, "
+				     "phy=0x%02x, chnl=%d\n",
+				     title, le16_to_cpu(fc), header->addr1[5],
+				     header->addr3[5], length, rssi,
+				     tsf_low - priv->scan_start_tsf,
+				     phy_flags, channel);
+		}
+	}
+	if (print_dump)
+		iwl_print_hex_dump(priv, IWL_DL_RX, header, length);
+}
+#endif
+
+static u32 iwlagn_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
+{
+	u32 decrypt_out = 0;
+
+	if ((decrypt_in & RX_RES_STATUS_STATION_FOUND) ==
+					RX_RES_STATUS_STATION_FOUND)
+		decrypt_out |= (RX_RES_STATUS_STATION_FOUND |
+				RX_RES_STATUS_NO_STATION_INFO_MISMATCH);
+
+	decrypt_out |= (decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK);
+
+	/* packet was not encrypted */
+	if ((decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) ==
+					RX_RES_STATUS_SEC_TYPE_NONE)
+		return decrypt_out;
+
+	/* packet was encrypted with unknown alg */
+	if ((decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) ==
+					RX_RES_STATUS_SEC_TYPE_ERR)
+		return decrypt_out;
+
+	/* decryption was not done in HW */
+	if ((decrypt_in & RX_MPDU_RES_STATUS_DEC_DONE_MSK) !=
+					RX_MPDU_RES_STATUS_DEC_DONE_MSK)
+		return decrypt_out;
+
+	switch (decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) {
+
+	case RX_RES_STATUS_SEC_TYPE_CCMP:
+		/* alg is CCM: check MIC only */
+		if (!(decrypt_in & RX_MPDU_RES_STATUS_MIC_OK))
+			/* Bad MIC */
+			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
+		else
+			decrypt_out |= RX_RES_STATUS_DECRYPT_OK;
+
+		break;
+
+	case RX_RES_STATUS_SEC_TYPE_TKIP:
+		if (!(decrypt_in & RX_MPDU_RES_STATUS_TTAK_OK)) {
+			/* Bad TTAK */
+			decrypt_out |= RX_RES_STATUS_BAD_KEY_TTAK;
+			break;
+		}
+		/* fall through if TTAK OK */
+	default:
+		if (!(decrypt_in & RX_MPDU_RES_STATUS_ICV_OK))
+			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
+		else
+			decrypt_out |= RX_RES_STATUS_DECRYPT_OK;
+		break;
+	};
+
+	IWL_DEBUG_RX(priv, "decrypt_in:0x%x  decrypt_out = 0x%x\n",
+					decrypt_in, decrypt_out);
+
+	return decrypt_out;
+}
+
+static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
+					struct ieee80211_hdr *hdr,
+					u16 len,
+					u32 ampdu_status,
+					struct iwl_rx_mem_buffer *rxb,
+					struct ieee80211_rx_status *stats)
+{
+	struct sk_buff *skb;
+	int ret = 0;
+	__le16 fc = hdr->frame_control;
+
+	/* We only process data packets if the interface is open */
+	if (unlikely(!priv->is_open)) {
+		IWL_DEBUG_DROP_LIMIT(priv,
+		    "Dropping packet while interface is not open.\n");
+		return;
+	}
+
+	/* In case of HW accelerated crypto and bad decryption, drop */
+	if (!priv->cfg->mod_params->sw_crypto &&
+	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
+		return;
+
+	skb = alloc_skb(IWL_LINK_HDR_MAX * 2, GFP_ATOMIC);
+	if (!skb) {
+		IWL_ERR(priv, "alloc_skb failed\n");
+		return;
+	}
+
+	skb_reserve(skb, IWL_LINK_HDR_MAX);
+	skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb), len);
+
+	/* mac80211 currently doesn't support paged SKB. Convert it to
+	 * linear SKB for management frame and data frame requires
+	 * software decryption or software defragementation. */
+	if (ieee80211_is_mgmt(fc) ||
+	    ieee80211_has_protected(fc) ||
+	    ieee80211_has_morefrags(fc) ||
+	    le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG ||
+	    (ieee80211_is_data_qos(fc) &&
+	     *ieee80211_get_qos_ctl(hdr) &
+	     IEEE80211_QOS_CONTROL_A_MSDU_PRESENT))
+		ret = skb_linearize(skb);
+	else
+		ret = __pskb_pull_tail(skb, min_t(u16, IWL_LINK_HDR_MAX, len)) ?
+			 0 : -ENOMEM;
+
+	if (ret) {
+		kfree_skb(skb);
+		goto out;
+	}
+
+	/*
+	 * XXX: We cannot touch the page and its virtual memory (hdr) after
+	 * here. It might have already been freed by the above skb change.
+	 */
+
+	iwl_update_stats(priv, false, fc, len);
+	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
+
+	ieee80211_rx(priv->hw, skb);
+ out:
+	priv->alloc_rxb_page--;
+	rxb->page = NULL;
+}
+
+/* Called for REPLY_RX (legacy ABG frames), or
+ * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
+void iwlagn_rx_reply_rx(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb)
+{
+	struct ieee80211_hdr *header;
+	struct ieee80211_rx_status rx_status;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_rx_phy_res *phy_res;
+	__le32 rx_pkt_status;
+	struct iwl4965_rx_mpdu_res_start *amsdu;
+	u32 len;
+	u32 ampdu_status;
+	u32 rate_n_flags;
+
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
+		ampdu_status = iwlagn_translate_rx_status(priv,
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
+	/* This will be used in several places later */
+	rate_n_flags = le32_to_cpu(phy_res->rate_n_flags);
+
+	/* rx_status carries information about the packet to mac80211 */
+	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
+	rx_status.freq =
+		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel));
+	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
+				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+	rx_status.rate_idx =
+		iwlagn_hwrate_to_mac80211_idx(rate_n_flags, rx_status.band);
+	rx_status.flag = 0;
+
+	/* TSF isn't reliable. In order to allow smooth user experience,
+	 * this W/A doesn't propagate it to the mac80211 */
+	/*rx_status.flag |= RX_FLAG_TSFT;*/
+
+	priv->ucode_beacon_time = le32_to_cpu(phy_res->beacon_time_stamp);
+
+	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
+	rx_status.signal = iwlagn_calc_rssi(priv, phy_res);
+
+	/* Meaningful noise values are available only from beacon statistics,
+	 *   which are gathered only when associated, and indicate noise
+	 *   only for the associated network channel ...
+	 * Ignore these noise values while scanning (other channels) */
+	if (iwl_is_associated(priv) &&
+	    !test_bit(STATUS_SCANNING, &priv->status)) {
+		rx_status.noise = priv->last_rx_noise;
+	} else {
+		rx_status.noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
+	}
+
+	/* Reset beacon noise level if not associated. */
+	if (!iwl_is_associated(priv))
+		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	/* Set "1" to report good data frames in groups of 100 */
+	if (unlikely(iwl_get_debug_level(priv) & IWL_DL_RX))
+		iwlagn_dbg_report_frame(priv, phy_res, len, header, 1);
+#endif
+	iwl_dbg_log_rx_data_frame(priv, len, header);
+	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, noise %d, TSF %llu\n",
+		rx_status.signal, rx_status.noise,
+		(unsigned long long)rx_status.mactime);
+
+	/*
+	 * "antenna number"
+	 *
+	 * It seems that the antenna field in the phy flags value
+	 * is actually a bit field. This is undefined by radiotap,
+	 * it wants an actual antenna number but I always get "7"
+	 * for most legacy frames I receive indicating that the
+	 * same frame was received on all three RX chains.
+	 *
+	 * I think this field should be removed in favor of a
+	 * new 802.11n radiotap field "RX chains" that is defined
+	 * as a bitmask.
+	 */
+	rx_status.antenna =
+		(le16_to_cpu(phy_res->phy_flags) & RX_RES_PHY_FLAGS_ANTENNA_MSK)
+		>> RX_RES_PHY_FLAGS_ANTENNA_POS;
+
+	/* set the preamble flag if appropriate */
+	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
+		rx_status.flag |= RX_FLAG_SHORTPRE;
+
+	/* Set up the HT phy flags */
+	if (rate_n_flags & RATE_MCS_HT_MSK)
+		rx_status.flag |= RX_FLAG_HT;
+	if (rate_n_flags & RATE_MCS_HT40_MSK)
+		rx_status.flag |= RX_FLAG_40MHZ;
+	if (rate_n_flags & RATE_MCS_SGI_MSK)
+		rx_status.flag |= RX_FLAG_SHORT_GI;
+
+	iwlagn_pass_packet_to_mac80211(priv, header, len, ampdu_status,
+				    rxb, &rx_status);
+}
+
+/* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
+ * This will be used later in iwl_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
+void iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
+				    struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	priv->last_phy_res[0] = 1;
+	memcpy(&priv->last_phy_res[1], &(pkt->u.raw[0]),
+	       sizeof(struct iwl_rx_phy_res));
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 4e4b70d..257e4af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -38,6 +38,7 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
+#include "iwl-agn.h"
 
 /*
  * mac80211 queues, ACs, hardware queues, FIFOs.
@@ -1206,7 +1207,7 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	info->flags |= IEEE80211_TX_STAT_AMPDU;
 	info->status.ampdu_ack_map = successes;
 	info->status.ampdu_ack_len = agg->frame_count;
-	iwl_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
+	iwlagn_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
 
 	IWL_DEBUG_TX_REPLY(priv, "Bitmap %llx\n", (unsigned long long)bitmap);
 
@@ -1214,6 +1215,29 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 }
 
 /**
+ * translate ucode response to mac80211 tx status control values
+ */
+void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
+				  struct ieee80211_tx_info *info)
+{
+	struct ieee80211_tx_rate *r = &info->control.rates[0];
+
+	info->antenna_sel_tx =
+		((rate_n_flags & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS);
+	if (rate_n_flags & RATE_MCS_HT_MSK)
+		r->flags |= IEEE80211_TX_RC_MCS;
+	if (rate_n_flags & RATE_MCS_GF_MSK)
+		r->flags |= IEEE80211_TX_RC_GREEN_FIELD;
+	if (rate_n_flags & RATE_MCS_HT40_MSK)
+		r->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+	if (rate_n_flags & RATE_MCS_DUP_MSK)
+		r->flags |= IEEE80211_TX_RC_DUP_DATA;
+	if (rate_n_flags & RATE_MCS_SGI_MSK)
+		r->flags |= IEEE80211_TX_RC_SHORT_GI;
+	r->idx = iwlagn_hwrate_to_mac80211_idx(rate_n_flags, info->band);
+}
+
+/**
  * iwlagn_rx_reply_compressed_ba - Handler for REPLY_COMPRESSED_BA
  *
  * Handles block-acknowledge notification from device, which reports success
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d9a287b..bc08e9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -884,8 +884,8 @@ static void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[MISSED_BEACONS_NOTIFICATION] =
 	    iwl_rx_missed_beacon_notif;
 	/* Rx handlers */
-	priv->rx_handlers[REPLY_RX_PHY_CMD] = iwl_rx_reply_rx_phy;
-	priv->rx_handlers[REPLY_RX_MPDU_CMD] = iwl_rx_reply_rx;
+	priv->rx_handlers[REPLY_RX_PHY_CMD] = iwlagn_rx_reply_rx_phy;
+	priv->rx_handlers[REPLY_RX_MPDU_CMD] = iwlagn_rx_reply_rx;
 	/* block ack */
 	priv->rx_handlers[REPLY_COMPRESSED_BA] = iwlagn_rx_reply_compressed_ba;
 	/* Set up hardware specific Rx handlers */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 48f7de0..5ad1405 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -124,8 +124,15 @@ void iwlagn_rx_replenish(struct iwl_priv *priv);
 void iwlagn_rx_replenish_now(struct iwl_priv *priv);
 void iwlagn_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwlagn_rxq_stop(struct iwl_priv *priv);
+int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
+void iwlagn_rx_reply_rx(struct iwl_priv *priv,
+		     struct iwl_rx_mem_buffer *rxb);
+void iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
+			 struct iwl_rx_mem_buffer *rxb);
 
 /* tx */
+void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
+			      struct ieee80211_tx_info *info);
 int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
 int iwlagn_tx_agg_start(struct iwl_priv *priv,
 			const u8 *ra, u16 tid, u16 *ssn);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0dc41d8..6fe7853 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -140,30 +140,6 @@ const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
 };
 EXPORT_SYMBOL(iwl_rates);
 
-/**
- * translate ucode response to mac80211 tx status control values
- */
-void iwl_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
-				  struct ieee80211_tx_info *info)
-{
-	struct ieee80211_tx_rate *r = &info->control.rates[0];
-
-	info->antenna_sel_tx =
-		((rate_n_flags & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS);
-	if (rate_n_flags & RATE_MCS_HT_MSK)
-		r->flags |= IEEE80211_TX_RC_MCS;
-	if (rate_n_flags & RATE_MCS_GF_MSK)
-		r->flags |= IEEE80211_TX_RC_GREEN_FIELD;
-	if (rate_n_flags & RATE_MCS_HT40_MSK)
-		r->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
-	if (rate_n_flags & RATE_MCS_DUP_MSK)
-		r->flags |= IEEE80211_TX_RC_DUP_DATA;
-	if (rate_n_flags & RATE_MCS_SGI_MSK)
-		r->flags |= IEEE80211_TX_RC_SHORT_GI;
-	r->idx = iwl_hwrate_to_mac80211_idx(rate_n_flags, info->band);
-}
-EXPORT_SYMBOL(iwl_hwrate_to_tx_control);
-
 int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
 {
 	int idx = 0;
@@ -195,27 +171,6 @@ int iwl_hwrate_to_plcp_idx(u32 rate_n_flags)
 }
 EXPORT_SYMBOL(iwl_hwrate_to_plcp_idx);
 
-int iwl_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
-{
-	int idx = 0;
-	int band_offset = 0;
-
-	/* HT rate format: mac80211 wants an MCS number, which is just LSB */
-	if (rate_n_flags & RATE_MCS_HT_MSK) {
-		idx = (rate_n_flags & 0xff);
-		return idx;
-	/* Legacy rate format, search for match in table */
-	} else {
-		if (band == IEEE80211_BAND_5GHZ)
-			band_offset = IWL_FIRST_OFDM_RATE;
-		for (idx = band_offset; idx < IWL_RATE_COUNT_LEGACY; idx++)
-			if (iwl_rates[idx].plcp == (rate_n_flags & 0xFF))
-				return idx - band_offset;
-	}
-
-	return -1;
-}
-
 u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant)
 {
 	int i;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7c6ac34..22f84f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -467,10 +467,7 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
  * Rate
  ******************************************************************************/
 
-void iwl_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
-			      struct ieee80211_tx_info *info);
 int iwl_hwrate_to_plcp_idx(u32 rate_n_flags);
-int iwl_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
 
 u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv);
 
@@ -670,10 +667,6 @@ extern int iwl_send_statistics_request(struct iwl_priv *priv,
 extern int iwl_verify_ucode(struct iwl_priv *priv);
 extern int iwl_send_lq_cmd(struct iwl_priv *priv,
 		struct iwl_link_quality_cmd *lq, u8 flags, bool init);
-extern void iwl_rx_reply_rx(struct iwl_priv *priv,
-		struct iwl_rx_mem_buffer *rxb);
-extern void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb);
 void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 45230c6..3a43138 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -489,139 +489,6 @@ void iwl_reply_statistics(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_reply_statistics);
 
-/* Calc max signal level (dBm) among 3 possible receivers */
-static inline int iwl_calc_rssi(struct iwl_priv *priv,
-				struct iwl_rx_phy_res *rx_resp)
-{
-	return priv->cfg->ops->utils->calc_rssi(priv, rx_resp);
-}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-/**
- * iwl_dbg_report_frame - dump frame to syslog during debug sessions
- *
- * You may hack this function to show different aspects of received frames,
- * including selective frame dumps.
- * group100 parameter selects whether to show 1 out of 100 good data frames.
- *    All beacon and probe response frames are printed.
- */
-static void iwl_dbg_report_frame(struct iwl_priv *priv,
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
-	rssi = iwl_calc_rssi(priv, phy_res);
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
-				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
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
 /*
  * returns non-zero if packet should be dropped
  */
@@ -669,281 +536,3 @@ int iwl_set_decrypted_flag(struct iwl_priv *priv,
 	return 0;
 }
 EXPORT_SYMBOL(iwl_set_decrypted_flag);
-
-static u32 iwl_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
-{
-	u32 decrypt_out = 0;
-
-	if ((decrypt_in & RX_RES_STATUS_STATION_FOUND) ==
-					RX_RES_STATUS_STATION_FOUND)
-		decrypt_out |= (RX_RES_STATUS_STATION_FOUND |
-				RX_RES_STATUS_NO_STATION_INFO_MISMATCH);
-
-	decrypt_out |= (decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK);
-
-	/* packet was not encrypted */
-	if ((decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) ==
-					RX_RES_STATUS_SEC_TYPE_NONE)
-		return decrypt_out;
-
-	/* packet was encrypted with unknown alg */
-	if ((decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) ==
-					RX_RES_STATUS_SEC_TYPE_ERR)
-		return decrypt_out;
-
-	/* decryption was not done in HW */
-	if ((decrypt_in & RX_MPDU_RES_STATUS_DEC_DONE_MSK) !=
-					RX_MPDU_RES_STATUS_DEC_DONE_MSK)
-		return decrypt_out;
-
-	switch (decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) {
-
-	case RX_RES_STATUS_SEC_TYPE_CCMP:
-		/* alg is CCM: check MIC only */
-		if (!(decrypt_in & RX_MPDU_RES_STATUS_MIC_OK))
-			/* Bad MIC */
-			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
-		else
-			decrypt_out |= RX_RES_STATUS_DECRYPT_OK;
-
-		break;
-
-	case RX_RES_STATUS_SEC_TYPE_TKIP:
-		if (!(decrypt_in & RX_MPDU_RES_STATUS_TTAK_OK)) {
-			/* Bad TTAK */
-			decrypt_out |= RX_RES_STATUS_BAD_KEY_TTAK;
-			break;
-		}
-		/* fall through if TTAK OK */
-	default:
-		if (!(decrypt_in & RX_MPDU_RES_STATUS_ICV_OK))
-			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
-		else
-			decrypt_out |= RX_RES_STATUS_DECRYPT_OK;
-		break;
-	};
-
-	IWL_DEBUG_RX(priv, "decrypt_in:0x%x  decrypt_out = 0x%x\n",
-					decrypt_in, decrypt_out);
-
-	return decrypt_out;
-}
-
-static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
-					struct ieee80211_hdr *hdr,
-					u16 len,
-					u32 ampdu_status,
-					struct iwl_rx_mem_buffer *rxb,
-					struct ieee80211_rx_status *stats)
-{
-	struct sk_buff *skb;
-	int ret = 0;
-	__le16 fc = hdr->frame_control;
-
-	/* We only process data packets if the interface is open */
-	if (unlikely(!priv->is_open)) {
-		IWL_DEBUG_DROP_LIMIT(priv,
-		    "Dropping packet while interface is not open.\n");
-		return;
-	}
-
-	/* In case of HW accelerated crypto and bad decryption, drop */
-	if (!priv->cfg->mod_params->sw_crypto &&
-	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
-		return;
-
-	skb = alloc_skb(IWL_LINK_HDR_MAX * 2, GFP_ATOMIC);
-	if (!skb) {
-		IWL_ERR(priv, "alloc_skb failed\n");
-		return;
-	}
-
-	skb_reserve(skb, IWL_LINK_HDR_MAX);
-	skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb), len);
-
-	/* mac80211 currently doesn't support paged SKB. Convert it to
-	 * linear SKB for management frame and data frame requires
-	 * software decryption or software defragementation. */
-	if (ieee80211_is_mgmt(fc) ||
-	    ieee80211_has_protected(fc) ||
-	    ieee80211_has_morefrags(fc) ||
-	    le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG ||
-	    (ieee80211_is_data_qos(fc) &&
-	     *ieee80211_get_qos_ctl(hdr) &
-	     IEEE80211_QOS_CONTROL_A_MSDU_PRESENT))
-		ret = skb_linearize(skb);
-	else
-		ret = __pskb_pull_tail(skb, min_t(u16, IWL_LINK_HDR_MAX, len)) ?
-			 0 : -ENOMEM;
-
-	if (ret) {
-		kfree_skb(skb);
-		goto out;
-	}
-
-	/*
-	 * XXX: We cannot touch the page and its virtual memory (hdr) after
-	 * here. It might have already been freed by the above skb change.
-	 */
-
-	iwl_update_stats(priv, false, fc, len);
-	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
-
-	ieee80211_rx(priv->hw, skb);
- out:
-	priv->alloc_rxb_page--;
-	rxb->page = NULL;
-}
-
-/* Called for REPLY_RX (legacy ABG frames), or
- * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
-void iwl_rx_reply_rx(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
-{
-	struct ieee80211_hdr *header;
-	struct ieee80211_rx_status rx_status;
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_rx_phy_res *phy_res;
-	__le32 rx_pkt_status;
-	struct iwl4965_rx_mpdu_res_start *amsdu;
-	u32 len;
-	u32 ampdu_status;
-	u32 rate_n_flags;
-
-	/**
-	 * REPLY_RX and REPLY_RX_MPDU_CMD are handled differently.
-	 *	REPLY_RX: physical layer info is in this buffer
-	 *	REPLY_RX_MPDU_CMD: physical layer info was sent in separate
-	 *		command and cached in priv->last_phy_res
-	 *
-	 * Here we set up local variables depending on which command is
-	 * received.
-	 */
-	if (pkt->hdr.cmd == REPLY_RX) {
-		phy_res = (struct iwl_rx_phy_res *)pkt->u.raw;
-		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*phy_res)
-				+ phy_res->cfg_phy_cnt);
-
-		len = le16_to_cpu(phy_res->byte_count);
-		rx_pkt_status = *(__le32 *)(pkt->u.raw + sizeof(*phy_res) +
-				phy_res->cfg_phy_cnt + len);
-		ampdu_status = le32_to_cpu(rx_pkt_status);
-	} else {
-		if (!priv->last_phy_res[0]) {
-			IWL_ERR(priv, "MPDU frame without cached PHY data\n");
-			return;
-		}
-		phy_res = (struct iwl_rx_phy_res *)&priv->last_phy_res[1];
-		amsdu = (struct iwl4965_rx_mpdu_res_start *)pkt->u.raw;
-		header = (struct ieee80211_hdr *)(pkt->u.raw + sizeof(*amsdu));
-		len = le16_to_cpu(amsdu->byte_count);
-		rx_pkt_status = *(__le32 *)(pkt->u.raw + sizeof(*amsdu) + len);
-		ampdu_status = iwl_translate_rx_status(priv,
-				le32_to_cpu(rx_pkt_status));
-	}
-
-	if ((unlikely(phy_res->cfg_phy_cnt > 20))) {
-		IWL_DEBUG_DROP(priv, "dsp size out of range [0,20]: %d/n",
-				phy_res->cfg_phy_cnt);
-		return;
-	}
-
-	if (!(rx_pkt_status & RX_RES_STATUS_NO_CRC32_ERROR) ||
-	    !(rx_pkt_status & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
-		IWL_DEBUG_RX(priv, "Bad CRC or FIFO: 0x%08X.\n",
-				le32_to_cpu(rx_pkt_status));
-		return;
-	}
-
-	/* This will be used in several places later */
-	rate_n_flags = le32_to_cpu(phy_res->rate_n_flags);
-
-	/* rx_status carries information about the packet to mac80211 */
-	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
-	rx_status.freq =
-		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel));
-	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
-				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
-	rx_status.rate_idx =
-		iwl_hwrate_to_mac80211_idx(rate_n_flags, rx_status.band);
-	rx_status.flag = 0;
-
-	/* TSF isn't reliable. In order to allow smooth user experience,
-	 * this W/A doesn't propagate it to the mac80211 */
-	/*rx_status.flag |= RX_FLAG_TSFT;*/
-
-	priv->ucode_beacon_time = le32_to_cpu(phy_res->beacon_time_stamp);
-
-	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
-	rx_status.signal = iwl_calc_rssi(priv, phy_res);
-
-	/* Meaningful noise values are available only from beacon statistics,
-	 *   which are gathered only when associated, and indicate noise
-	 *   only for the associated network channel ...
-	 * Ignore these noise values while scanning (other channels) */
-	if (iwl_is_associated(priv) &&
-	    !test_bit(STATUS_SCANNING, &priv->status)) {
-		rx_status.noise = priv->last_rx_noise;
-	} else {
-		rx_status.noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
-	}
-
-	/* Reset beacon noise level if not associated. */
-	if (!iwl_is_associated(priv))
-		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	/* Set "1" to report good data frames in groups of 100 */
-	if (unlikely(iwl_get_debug_level(priv) & IWL_DL_RX))
-		iwl_dbg_report_frame(priv, phy_res, len, header, 1);
-#endif
-	iwl_dbg_log_rx_data_frame(priv, len, header);
-	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, noise %d, TSF %llu\n",
-		rx_status.signal, rx_status.noise,
-		(unsigned long long)rx_status.mactime);
-
-	/*
-	 * "antenna number"
-	 *
-	 * It seems that the antenna field in the phy flags value
-	 * is actually a bit field. This is undefined by radiotap,
-	 * it wants an actual antenna number but I always get "7"
-	 * for most legacy frames I receive indicating that the
-	 * same frame was received on all three RX chains.
-	 *
-	 * I think this field should be removed in favor of a
-	 * new 802.11n radiotap field "RX chains" that is defined
-	 * as a bitmask.
-	 */
-	rx_status.antenna =
-		(le16_to_cpu(phy_res->phy_flags) & RX_RES_PHY_FLAGS_ANTENNA_MSK)
-		>> RX_RES_PHY_FLAGS_ANTENNA_POS;
-
-	/* set the preamble flag if appropriate */
-	if (phy_res->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
-		rx_status.flag |= RX_FLAG_SHORTPRE;
-
-	/* Set up the HT phy flags */
-	if (rate_n_flags & RATE_MCS_HT_MSK)
-		rx_status.flag |= RX_FLAG_HT;
-	if (rate_n_flags & RATE_MCS_HT40_MSK)
-		rx_status.flag |= RX_FLAG_40MHZ;
-	if (rate_n_flags & RATE_MCS_SGI_MSK)
-		rx_status.flag |= RX_FLAG_SHORT_GI;
-
-	iwl_pass_packet_to_mac80211(priv, header, len, ampdu_status,
-				    rxb, &rx_status);
-}
-EXPORT_SYMBOL(iwl_rx_reply_rx);
-
-/* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
- * This will be used later in iwl_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
-void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	priv->last_phy_res[0] = 1;
-	memcpy(&priv->last_phy_res[1], &(pkt->u.raw[0]),
-	       sizeof(struct iwl_rx_phy_res));
-}
-EXPORT_SYMBOL(iwl_rx_reply_rx_phy);
-- 
1.6.3.3

