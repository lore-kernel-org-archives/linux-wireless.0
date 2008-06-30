Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19551 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbYF3J1H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:07 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 09/33] iwlwifi: move RX handlers to iwl-rx.c
Date: Mon, 30 Jun 2008 17:23:09 +0800
Message-Id: <1214817813-17639-10-git-send-email-yi.zhu@intel.com> (sfid-20080630_112715_788455_2B8C2B95)
In-Reply-To: <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch moves RX handlers to iwl-rx.c

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  703 +----------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    7 -
 drivers/net/wireless/iwlwifi/iwl-rx.c       |  853 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  152 +-----
 5 files changed, 861 insertions(+), 860 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1688803..d8e6d2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1929,707 +1929,6 @@ static void iwl4965_temperature_calib(struct iwl_priv *priv,
 		queue_work(priv->workqueue, &priv->txpower_work);
 }
 
-static void iwl4965_add_radiotap(struct iwl_priv *priv,
-				 struct sk_buff *skb,
-				 struct iwl4965_rx_phy_res *rx_start,
-				 struct ieee80211_rx_status *stats,
-				 u32 ampdu_status)
-{
-	s8 signal = stats->signal;
-	s8 noise = 0;
-	int rate = stats->rate_idx;
-	u64 tsf = stats->mactime;
-	__le16 antenna;
-	__le16 phy_flags_hw = rx_start->phy_flags;
-	struct iwl4965_rt_rx_hdr {
-		struct ieee80211_radiotap_header rt_hdr;
-		__le64 rt_tsf;		/* TSF */
-		u8 rt_flags;		/* radiotap packet flags */
-		u8 rt_rate;		/* rate in 500kb/s */
-		__le16 rt_channelMHz;	/* channel in MHz */
-		__le16 rt_chbitmask;	/* channel bitfield */
-		s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
-		s8 rt_dbmnoise;
-		u8 rt_antenna;		/* antenna number */
-	} __attribute__ ((packed)) *iwl4965_rt;
-
-	/* TODO: We won't have enough headroom for HT frames. Fix it later. */
-	if (skb_headroom(skb) < sizeof(*iwl4965_rt)) {
-		if (net_ratelimit())
-			printk(KERN_ERR "not enough headroom [%d] for "
-			       "radiotap head [%zd]\n",
-			       skb_headroom(skb), sizeof(*iwl4965_rt));
-		return;
-	}
-
-	/* put radiotap header in front of 802.11 header and data */
-	iwl4965_rt = (void *)skb_push(skb, sizeof(*iwl4965_rt));
-
-	/* initialise radiotap header */
-	iwl4965_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
-	iwl4965_rt->rt_hdr.it_pad = 0;
-
-	/* total header + data */
-	put_unaligned(cpu_to_le16(sizeof(*iwl4965_rt)),
-		      &iwl4965_rt->rt_hdr.it_len);
-
-	/* Indicate all the fields we add to the radiotap header */
-	put_unaligned(cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
-				  (1 << IEEE80211_RADIOTAP_FLAGS) |
-				  (1 << IEEE80211_RADIOTAP_RATE) |
-				  (1 << IEEE80211_RADIOTAP_CHANNEL) |
-				  (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
-				  (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
-				  (1 << IEEE80211_RADIOTAP_ANTENNA)),
-		      &iwl4965_rt->rt_hdr.it_present);
-
-	/* Zero the flags, we'll add to them as we go */
-	iwl4965_rt->rt_flags = 0;
-
-	put_unaligned(cpu_to_le64(tsf), &iwl4965_rt->rt_tsf);
-
-	iwl4965_rt->rt_dbmsignal = signal;
-	iwl4965_rt->rt_dbmnoise = noise;
-
-	/* Convert the channel frequency and set the flags */
-	put_unaligned(cpu_to_le16(stats->freq), &iwl4965_rt->rt_channelMHz);
-	if (!(phy_flags_hw & RX_RES_PHY_FLAGS_BAND_24_MSK))
-		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
-					  IEEE80211_CHAN_5GHZ),
-			      &iwl4965_rt->rt_chbitmask);
-	else if (phy_flags_hw & RX_RES_PHY_FLAGS_MOD_CCK_MSK)
-		put_unaligned(cpu_to_le16(IEEE80211_CHAN_CCK |
-					  IEEE80211_CHAN_2GHZ),
-			      &iwl4965_rt->rt_chbitmask);
-	else	/* 802.11g */
-		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
-					  IEEE80211_CHAN_2GHZ),
-			      &iwl4965_rt->rt_chbitmask);
-
-	if (rate == -1)
-		iwl4965_rt->rt_rate = 0;
-	else
-		iwl4965_rt->rt_rate = iwl_rates[rate].ieee;
-
-	/*
-	 * "antenna number"
-	 *
-	 * It seems that the antenna field in the phy flags value
-	 * is actually a bitfield. This is undefined by radiotap,
-	 * it wants an actual antenna number but I always get "7"
-	 * for most legacy frames I receive indicating that the
-	 * same frame was received on all three RX chains.
-	 *
-	 * I think this field should be removed in favour of a
-	 * new 802.11n radiotap field "RX chains" that is defined
-	 * as a bitmask.
-	 */
-	antenna = phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK;
-	iwl4965_rt->rt_antenna = le16_to_cpu(antenna) >> 4;
-
-	/* set the preamble flag if appropriate */
-	if (phy_flags_hw & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
-		iwl4965_rt->rt_flags |= IEEE80211_RADIOTAP_F_SHORTPRE;
-
-	stats->flag |= RX_FLAG_RADIOTAP;
-}
-
-static void iwl_update_rx_stats(struct iwl_priv *priv, u16 fc, u16 len)
-{
-	/* 0 - mgmt, 1 - cnt, 2 - data */
-	int idx = (fc & IEEE80211_FCTL_FTYPE) >> 2;
-	priv->rx_stats[idx].cnt++;
-	priv->rx_stats[idx].bytes += len;
-}
-
-/*
- * returns non-zero if packet should be dropped
- */
-static int iwl4965_set_decrypted_flag(struct iwl_priv *priv,
-				      struct ieee80211_hdr *hdr,
-				      u32 decrypt_res,
-				      struct ieee80211_rx_status *stats)
-{
-	u16 fc = le16_to_cpu(hdr->frame_control);
-
-	if (priv->active_rxon.filter_flags & RXON_FILTER_DIS_DECRYPT_MSK)
-		return 0;
-
-	if (!(fc & IEEE80211_FCTL_PROTECTED))
-		return 0;
-
-	IWL_DEBUG_RX("decrypt_res:0x%x\n", decrypt_res);
-	switch (decrypt_res & RX_RES_STATUS_SEC_TYPE_MSK) {
-	case RX_RES_STATUS_SEC_TYPE_TKIP:
-		/* The uCode has got a bad phase 1 Key, pushes the packet.
-		 * Decryption will be done in SW. */
-		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
-		    RX_RES_STATUS_BAD_KEY_TTAK)
-			break;
-
-	case RX_RES_STATUS_SEC_TYPE_WEP:
-		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
-		    RX_RES_STATUS_BAD_ICV_MIC) {
-			/* bad ICV, the packet is destroyed since the
-			 * decryption is inplace, drop it */
-			IWL_DEBUG_RX("Packet destroyed\n");
-			return -1;
-		}
-	case RX_RES_STATUS_SEC_TYPE_CCMP:
-		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
-		    RX_RES_STATUS_DECRYPT_OK) {
-			IWL_DEBUG_RX("hw decrypt successfully!!!\n");
-			stats->flag |= RX_FLAG_DECRYPTED;
-		}
-		break;
-
-	default:
-		break;
-	}
-	return 0;
-}
-
-static u32 iwl4965_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
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
-	IWL_DEBUG_RX("decrypt_in:0x%x  decrypt_out = 0x%x\n",
-					decrypt_in, decrypt_out);
-
-	return decrypt_out;
-}
-
-static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
-				       int include_phy,
-				       struct iwl_rx_mem_buffer *rxb,
-				       struct ieee80211_rx_status *stats)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_rx_phy_res *rx_start = (include_phy) ?
-	    (struct iwl4965_rx_phy_res *)&(pkt->u.raw[0]) : NULL;
-	struct ieee80211_hdr *hdr;
-	u16 len;
-	__le32 *rx_end;
-	unsigned int skblen;
-	u32 ampdu_status;
-	u32 ampdu_status_legacy;
-
-	if (!include_phy && priv->last_phy_res[0])
-		rx_start = (struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
-
-	if (!rx_start) {
-		IWL_ERROR("MPDU frame without a PHY data\n");
-		return;
-	}
-	if (include_phy) {
-		hdr = (struct ieee80211_hdr *)((u8 *) & rx_start[1] +
-					       rx_start->cfg_phy_cnt);
-
-		len = le16_to_cpu(rx_start->byte_count);
-
-		rx_end = (__le32 *) ((u8 *) & pkt->u.raw[0] +
-				  sizeof(struct iwl4965_rx_phy_res) +
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
-	/* In monitor mode allow 802.11 ACk frames (10 bytes) */
-	if (len > priv->hw_params.max_pkt_size ||
-	    len < ((priv->iw_mode == IEEE80211_IF_TYPE_MNTR) ? 10 : 16)) {
-		IWL_WARNING("byte count out of range [16,4K] : %d\n", len);
-		return;
-	}
-
-	ampdu_status = le32_to_cpu(*rx_end);
-	skblen = ((u8 *) rx_end - (u8 *) & pkt->u.raw[0]) + sizeof(u32);
-
-	if (!include_phy) {
-		/* New status scheme, need to translate */
-		ampdu_status_legacy = ampdu_status;
-		ampdu_status = iwl4965_translate_rx_status(priv, ampdu_status);
-	}
-
-	/* start from MAC */
-	skb_reserve(rxb->skb, (void *)hdr - (void *)pkt);
-	skb_put(rxb->skb, len);	/* end where data ends */
-
-	/* We only process data packets if the interface is open */
-	if (unlikely(!priv->is_open)) {
-		IWL_DEBUG_DROP_LIMIT
-		    ("Dropping packet while interface is not open.\n");
-		return;
-	}
-
-	stats->flag = 0;
-	hdr = (struct ieee80211_hdr *)rxb->skb->data;
-
-	/*  in case of HW accelerated crypto and bad decryption, drop */
-	if (!priv->hw_params.sw_crypto &&
-	    iwl4965_set_decrypted_flag(priv, hdr, ampdu_status, stats))
-		return;
-
-	if (priv->add_radiotap)
-		iwl4965_add_radiotap(priv, rxb->skb, rx_start, stats, ampdu_status);
-
-	iwl_update_rx_stats(priv, le16_to_cpu(hdr->frame_control), len);
-	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
-	priv->alloc_rxb_skb--;
-	rxb->skb = NULL;
-}
-
-/* Calc max signal level (dBm) among 3 possible receivers */
-static int iwl4965_calc_rssi(struct iwl_priv *priv,
-			     struct iwl4965_rx_phy_res *rx_resp)
-{
-	/* data from PHY/DSP regarding signal strength, etc.,
-	 *   contents are always there, not configurable by host.  */
-	struct iwl4965_rx_non_cfg_phy *ncphy =
-	    (struct iwl4965_rx_non_cfg_phy *)rx_resp->non_cfg_phy;
-	u32 agc = (le16_to_cpu(ncphy->agc_info) & IWL_AGC_DB_MASK)
-			>> IWL_AGC_DB_POS;
-
-	u32 valid_antennae =
-	    (le16_to_cpu(rx_resp->phy_flags) & RX_PHY_FLAGS_ANTENNAE_MASK)
-			>> RX_PHY_FLAGS_ANTENNAE_OFFSET;
-	u8 max_rssi = 0;
-	u32 i;
-
-	/* Find max rssi among 3 possible receivers.
-	 * These values are measured by the digital signal processor (DSP).
-	 * They should stay fairly constant even as the signal strength varies,
-	 *   if the radio's automatic gain control (AGC) is working right.
-	 * AGC value (see below) will provide the "interesting" info. */
-	for (i = 0; i < 3; i++)
-		if (valid_antennae & (1 << i))
-			max_rssi = max(ncphy->rssi_info[i << 1], max_rssi);
-
-	IWL_DEBUG_STATS("Rssi In A %d B %d C %d Max %d AGC dB %d\n",
-		ncphy->rssi_info[0], ncphy->rssi_info[2], ncphy->rssi_info[4],
-		max_rssi, agc);
-
-	/* dBm = max_rssi dB - agc dB - constant.
-	 * Higher AGC (higher radio gain) means lower signal. */
-	return (max_rssi - agc - IWL_RSSI_OFFSET);
-}
-
-static void iwl4965_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].sta.station_flags &= ~STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
-	priv->stations[sta_id].sta.sta.modify_mask = 0;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-}
-
-static void iwl4965_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
-{
-	/* FIXME: need locking over ps_status ??? */
-	u8 sta_id = iwl_find_station(priv, addr);
-
-	if (sta_id != IWL_INVALID_STATION) {
-		u8 sta_awake = priv->stations[sta_id].
-				ps_status == STA_PS_STATUS_WAKE;
-
-		if (sta_awake && ps_bit)
-			priv->stations[sta_id].ps_status = STA_PS_STATUS_SLEEP;
-		else if (!sta_awake && !ps_bit) {
-			iwl4965_sta_modify_ps_wake(priv, sta_id);
-			priv->stations[sta_id].ps_status = STA_PS_STATUS_WAKE;
-		}
-	}
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-
-/**
- * iwl4965_dbg_report_frame - dump frame to syslog during debug sessions
- *
- * You may hack this function to show different aspects of received frames,
- * including selective frame dumps.
- * group100 parameter selects whether to show 1 out of 100 good frames.
- *
- * TODO:  This was originally written for 3945, need to audit for
- *        proper operation with 4965.
- */
-static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
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
-	if (likely(!(priv->debug_level & IWL_DL_RX)))
-		return;
-
-	/* MAC header */
-	fc = header->frame_control;
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
-		rate_idx = iwl_hwrate_to_plcp_idx(rate_sym);
-		if (unlikely(rate_idx == -1))
-			bitrate = 0;
-		else
-			bitrate = iwl_rates[rate_idx].ieee / 2;
-
-		/* print frame summary.
-		 * MAC addresses show just the last byte (for brevity),
-		 *    but you can hack it to show more, if you'd like to. */
-		if (dataframe)
-			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
-				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
-				     title, le16_to_cpu(fc), header->addr1[5],
-				     length, rssi, channel, bitrate);
-		else {
-			/* src/dst addresses assume managed mode */
-			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, "
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
-#else
-static inline void iwl4965_dbg_report_frame(struct iwl_priv *priv,
-					    struct iwl_rx_packet *pkt,
-					    struct ieee80211_hdr *header,
-					    int group100)
-{
-}
-#endif
-
-
-
-/* Called for REPLY_RX (legacy ABG frames), or
- * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
-void iwl4965_rx_reply_rx(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
-{
-	struct ieee80211_hdr *header;
-	struct ieee80211_rx_status rx_status;
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	/* Use phy data (Rx signal strength, etc.) contained within
-	 *   this rx packet for legacy frames,
-	 *   or phy data cached from REPLY_RX_PHY_CMD for HT frames. */
-	int include_phy = (pkt->hdr.cmd == REPLY_RX);
-	struct iwl4965_rx_phy_res *rx_start = (include_phy) ?
-		(struct iwl4965_rx_phy_res *)&(pkt->u.raw[0]) :
-		(struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
-	__le32 *rx_end;
-	unsigned int len = 0;
-	u16 fc;
-	u8 network_packet;
-
-	rx_status.mactime = le64_to_cpu(rx_start->timestamp);
-	rx_status.freq =
-		ieee80211_channel_to_frequency(le16_to_cpu(rx_start->channel));
-	rx_status.band = (rx_start->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
-				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
-	rx_status.rate_idx =
-		iwl_hwrate_to_plcp_idx(le32_to_cpu(rx_start->rate_n_flags));
-	if (rx_status.band == IEEE80211_BAND_5GHZ)
-		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
-
-	rx_status.antenna = 0;
-	rx_status.flag = 0;
-
-	if ((unlikely(rx_start->cfg_phy_cnt > 20))) {
-		IWL_DEBUG_DROP("dsp size out of range [0,20]: %d/n",
-				rx_start->cfg_phy_cnt);
-		return;
-	}
-
-	if (!include_phy) {
-		if (priv->last_phy_res[0])
-			rx_start = (struct iwl4965_rx_phy_res *)
-				&priv->last_phy_res[1];
-		else
-			rx_start = NULL;
-	}
-
-	if (!rx_start) {
-		IWL_ERROR("MPDU frame without a PHY data\n");
-		return;
-	}
-
-	if (include_phy) {
-		header = (struct ieee80211_hdr *)((u8 *) & rx_start[1]
-						  + rx_start->cfg_phy_cnt);
-
-		len = le16_to_cpu(rx_start->byte_count);
-		rx_end = (__le32 *)(pkt->u.raw + rx_start->cfg_phy_cnt +
-				  sizeof(struct iwl4965_rx_phy_res) + len);
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
-		IWL_DEBUG_RX("Bad CRC or FIFO: 0x%08X.\n",
-				le32_to_cpu(*rx_end));
-		return;
-	}
-
-	priv->ucode_beacon_time = le32_to_cpu(rx_start->beacon_time_stamp);
-
-	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
-	rx_status.signal = iwl4965_calc_rssi(priv, rx_start);
-
-	/* Meaningful noise values are available only from beacon statistics,
-	 *   which are gathered only when associated, and indicate noise
-	 *   only for the associated network channel ...
-	 * Ignore these noise values while scanning (other channels) */
-	if (iwl_is_associated(priv) &&
-	    !test_bit(STATUS_SCANNING, &priv->status)) {
-		rx_status.noise = priv->last_rx_noise;
-		rx_status.qual = iwl4965_calc_sig_qual(rx_status.signal,
-							 rx_status.noise);
-	} else {
-		rx_status.noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
-		rx_status.qual = iwl4965_calc_sig_qual(rx_status.signal, 0);
-	}
-
-	/* Reset beacon noise level if not associated. */
-	if (!iwl_is_associated(priv))
-		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
-
-	/* Set "1" to report good data frames in groups of 100 */
-	/* FIXME: need to optimze the call: */
-	iwl4965_dbg_report_frame(priv, pkt, header, 1);
-
-	IWL_DEBUG_STATS_LIMIT("Rssi %d, noise %d, qual %d, TSF %llu\n",
-			      rx_status.signal, rx_status.noise, rx_status.signal,
-			      (unsigned long long)rx_status.mactime);
-
-
-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		iwl4965_handle_data_packet(priv, 1, include_phy,
-						 rxb, &rx_status);
-		return;
-	}
-
-	network_packet = iwl4965_is_network_packet(priv, header);
-	if (network_packet) {
-		priv->last_rx_rssi = rx_status.signal;
-		priv->last_beacon_time =  priv->ucode_beacon_time;
-		priv->last_tsf = le64_to_cpu(rx_start->timestamp);
-	}
-
-	fc = le16_to_cpu(header->frame_control);
-	switch (fc & IEEE80211_FCTL_FTYPE) {
-	case IEEE80211_FTYPE_MGMT:
-		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
-			iwl4965_update_ps_mode(priv, fc  & IEEE80211_FCTL_PM,
-						header->addr2);
-		iwl4965_handle_data_packet(priv, 0, include_phy, rxb, &rx_status);
-		break;
-
-	case IEEE80211_FTYPE_CTL:
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_BACK_REQ:
-			IWL_DEBUG_HT("IEEE80211_STYPE_BACK_REQ arrived\n");
-			iwl4965_handle_data_packet(priv, 0, include_phy,
-						rxb, &rx_status);
-			break;
-		default:
-			break;
-		}
-		break;
-
-	case IEEE80211_FTYPE_DATA: {
-		DECLARE_MAC_BUF(mac1);
-		DECLARE_MAC_BUF(mac2);
-		DECLARE_MAC_BUF(mac3);
-
-		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
-			iwl4965_update_ps_mode(priv, fc  & IEEE80211_FCTL_PM,
-						header->addr2);
-
-		if (unlikely(!network_packet))
-			IWL_DEBUG_DROP("Dropping (non network): "
-				       "%s, %s, %s\n",
-				       print_mac(mac1, header->addr1),
-				       print_mac(mac2, header->addr2),
-				       print_mac(mac3, header->addr3));
-		else if (unlikely(iwl4965_is_duplicate_packet(priv, header)))
-			IWL_DEBUG_DROP("Dropping (dup): %s, %s, %s\n",
-				       print_mac(mac1, header->addr1),
-				       print_mac(mac2, header->addr2),
-				       print_mac(mac3, header->addr3));
-		else
-			iwl4965_handle_data_packet(priv, 1, include_phy, rxb,
-						   &rx_status);
-		break;
-	}
-	default:
-		break;
-
-	}
-}
-
 /**
  * iwl4965_tx_status_reply_compressed_ba - Update tx status from block-ack
  *
@@ -3253,7 +2552,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 static void iwl4965_rx_handler_setup(struct iwl_priv *priv)
 {
 	/* Legacy Rx frames */
-	priv->rx_handlers[REPLY_RX] = iwl4965_rx_reply_rx;
+	priv->rx_handlers[REPLY_RX] = iwl_rx_reply_rx;
 	/* Tx response */
 	priv->rx_handlers[REPLY_TX] = iwl4965_rx_reply_tx;
 	/* block ack */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 0cff64d..0d8cc8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -372,7 +372,11 @@ extern void iwl_rf_kill_ct_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags);
 extern int iwl_verify_ucode(struct iwl_priv *priv);
 extern int iwl_send_lq_cmd(struct iwl_priv *priv,
-		    struct iwl_link_quality_cmd *lq, u8 flags);
+		struct iwl_link_quality_cmd *lq, u8 flags);
+extern void iwl_rx_reply_rx(struct iwl_priv *priv,
+		struct iwl_rx_mem_buffer *rxb);
+extern void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
+				    struct iwl_rx_mem_buffer *rxb);
 
 static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fd008ab..8017e57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -591,11 +591,6 @@ extern int iwl_send_add_sta(struct iwl_priv *priv,
 			    struct iwl_addsta_cmd *sta, u8 flags);
 u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr, int is_ap,
 			 u8 flags, struct ieee80211_ht_info *ht_info);
-extern int iwl4965_is_network_packet(struct iwl_priv *priv,
-				 struct ieee80211_hdr *header);
-extern int iwl4965_is_duplicate_packet(struct iwl_priv *priv,
-				       struct ieee80211_hdr *header);
-extern int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm);
 extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,
 					const u8 *dest, int left);
@@ -625,8 +620,6 @@ extern void iwl_txq_ctx_stop(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl_frame *frame, u8 rate);
 extern void iwl4965_disable_events(struct iwl_priv *priv);
-extern void iwl4965_rx_reply_rx(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb);
 
 extern int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel);
 extern int iwl_queue_space(const struct iwl_queue *q);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b3ca137..e0d3e2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -27,6 +27,7 @@
  *
  *****************************************************************************/
 
+#include <linux/etherdevice.h>
 #include <net/mac80211.h>
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -541,3 +542,855 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 		priv->cfg->ops->lib->temperature(priv, &pkt->u.stats);
 }
 EXPORT_SYMBOL(iwl_rx_statistics);
+
+#define PERFECT_RSSI (-20) /* dBm */
+#define WORST_RSSI (-95)   /* dBm */
+#define RSSI_RANGE (PERFECT_RSSI - WORST_RSSI)
+
+/* Calculate an indication of rx signal quality (a percentage, not dBm!).
+ * See http://www.ces.clemson.edu/linux/signal_quality.shtml for info
+ *   about formulas used below. */
+static int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm)
+{
+	int sig_qual;
+	int degradation = PERFECT_RSSI - rssi_dbm;
+
+	/* If we get a noise measurement, use signal-to-noise ratio (SNR)
+	 * as indicator; formula is (signal dbm - noise dbm).
+	 * SNR at or above 40 is a great signal (100%).
+	 * Below that, scale to fit SNR of 0 - 40 dB within 0 - 100% indicator.
+	 * Weakest usable signal is usually 10 - 15 dB SNR. */
+	if (noise_dbm) {
+		if (rssi_dbm - noise_dbm >= 40)
+			return 100;
+		else if (rssi_dbm < noise_dbm)
+			return 0;
+		sig_qual = ((rssi_dbm - noise_dbm) * 5) / 2;
+
+	/* Else use just the signal level.
+	 * This formula is a least squares fit of data points collected and
+	 *   compared with a reference system that had a percentage (%) display
+	 *   for signal quality. */
+	} else
+		sig_qual = (100 * (RSSI_RANGE * RSSI_RANGE) - degradation *
+			    (15 * RSSI_RANGE + 62 * degradation)) /
+			   (RSSI_RANGE * RSSI_RANGE);
+
+	if (sig_qual > 100)
+		sig_qual = 100;
+	else if (sig_qual < 1)
+		sig_qual = 0;
+
+	return sig_qual;
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+
+/**
+ * iwl_dbg_report_frame - dump frame to syslog during debug sessions
+ *
+ * You may hack this function to show different aspects of received frames,
+ * including selective frame dumps.
+ * group100 parameter selects whether to show 1 out of 100 good frames.
+ *
+ * TODO:  This was originally written for 3945, need to audit for
+ *        proper operation with 4965.
+ */
+static void iwl_dbg_report_frame(struct iwl_priv *priv,
+		      struct iwl_rx_packet *pkt,
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
+	if (likely(!(priv->debug_level & IWL_DL_RX)))
+		return;
+
+	/* MAC header */
+	fc = header->frame_control;
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
+		rate_idx = iwl_hwrate_to_plcp_idx(rate_sym);
+		if (unlikely(rate_idx == -1))
+			bitrate = 0;
+		else
+			bitrate = iwl_rates[rate_idx].ieee / 2;
+
+		/* print frame summary.
+		 * MAC addresses show just the last byte (for brevity),
+		 *    but you can hack it to show more, if you'd like to. */
+		if (dataframe)
+			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
+				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
+				     title, le16_to_cpu(fc), header->addr1[5],
+				     length, rssi, channel, bitrate);
+		else {
+			/* src/dst addresses assume managed mode */
+			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, "
+				     "src=0x%02x, rssi=%u, tim=%lu usec, "
+				     "phy=0x%02x, chnl=%d\n",
+				     title, le16_to_cpu(fc), header->addr1[5],
+				     header->addr3[5], rssi,
+				     tsf_low - priv->scan_start_tsf,
+				     phy_flags, channel);
+		}
+	}
+	if (print_dump)
+		iwl_print_hex_dump(priv, IWL_DL_RX, data, length);
+}
+#else
+static inline void iwl_dbg_report_frame(struct iwl_priv *priv,
+					    struct iwl_rx_packet *pkt,
+					    struct ieee80211_hdr *header,
+					    int group100)
+{
+}
+#endif
+
+static void iwl_add_radiotap(struct iwl_priv *priv,
+				 struct sk_buff *skb,
+				 struct iwl4965_rx_phy_res *rx_start,
+				 struct ieee80211_rx_status *stats,
+				 u32 ampdu_status)
+{
+	s8 signal = stats->signal;
+	s8 noise = 0;
+	int rate = stats->rate_idx;
+	u64 tsf = stats->mactime;
+	__le16 antenna;
+	__le16 phy_flags_hw = rx_start->phy_flags;
+	struct iwl4965_rt_rx_hdr {
+		struct ieee80211_radiotap_header rt_hdr;
+		__le64 rt_tsf;		/* TSF */
+		u8 rt_flags;		/* radiotap packet flags */
+		u8 rt_rate;		/* rate in 500kb/s */
+		__le16 rt_channelMHz;	/* channel in MHz */
+		__le16 rt_chbitmask;	/* channel bitfield */
+		s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
+		s8 rt_dbmnoise;
+		u8 rt_antenna;		/* antenna number */
+	} __attribute__ ((packed)) *iwl4965_rt;
+
+	/* TODO: We won't have enough headroom for HT frames. Fix it later. */
+	if (skb_headroom(skb) < sizeof(*iwl4965_rt)) {
+		if (net_ratelimit())
+			printk(KERN_ERR "not enough headroom [%d] for "
+			       "radiotap head [%zd]\n",
+			       skb_headroom(skb), sizeof(*iwl4965_rt));
+		return;
+	}
+
+	/* put radiotap header in front of 802.11 header and data */
+	iwl4965_rt = (void *)skb_push(skb, sizeof(*iwl4965_rt));
+
+	/* initialise radiotap header */
+	iwl4965_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
+	iwl4965_rt->rt_hdr.it_pad = 0;
+
+	/* total header + data */
+	put_unaligned(cpu_to_le16(sizeof(*iwl4965_rt)),
+		      &iwl4965_rt->rt_hdr.it_len);
+
+	/* Indicate all the fields we add to the radiotap header */
+	put_unaligned(cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
+				  (1 << IEEE80211_RADIOTAP_FLAGS) |
+				  (1 << IEEE80211_RADIOTAP_RATE) |
+				  (1 << IEEE80211_RADIOTAP_CHANNEL) |
+				  (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
+				  (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
+				  (1 << IEEE80211_RADIOTAP_ANTENNA)),
+		      &iwl4965_rt->rt_hdr.it_present);
+
+	/* Zero the flags, we'll add to them as we go */
+	iwl4965_rt->rt_flags = 0;
+
+	put_unaligned(cpu_to_le64(tsf), &iwl4965_rt->rt_tsf);
+
+	iwl4965_rt->rt_dbmsignal = signal;
+	iwl4965_rt->rt_dbmnoise = noise;
+
+	/* Convert the channel frequency and set the flags */
+	put_unaligned(cpu_to_le16(stats->freq), &iwl4965_rt->rt_channelMHz);
+	if (!(phy_flags_hw & RX_RES_PHY_FLAGS_BAND_24_MSK))
+		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
+					  IEEE80211_CHAN_5GHZ),
+			      &iwl4965_rt->rt_chbitmask);
+	else if (phy_flags_hw & RX_RES_PHY_FLAGS_MOD_CCK_MSK)
+		put_unaligned(cpu_to_le16(IEEE80211_CHAN_CCK |
+					  IEEE80211_CHAN_2GHZ),
+			      &iwl4965_rt->rt_chbitmask);
+	else	/* 802.11g */
+		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
+					  IEEE80211_CHAN_2GHZ),
+			      &iwl4965_rt->rt_chbitmask);
+
+	if (rate == -1)
+		iwl4965_rt->rt_rate = 0;
+	else
+		iwl4965_rt->rt_rate = iwl_rates[rate].ieee;
+
+	/*
+	 * "antenna number"
+	 *
+	 * It seems that the antenna field in the phy flags value
+	 * is actually a bitfield. This is undefined by radiotap,
+	 * it wants an actual antenna number but I always get "7"
+	 * for most legacy frames I receive indicating that the
+	 * same frame was received on all three RX chains.
+	 *
+	 * I think this field should be removed in favour of a
+	 * new 802.11n radiotap field "RX chains" that is defined
+	 * as a bitmask.
+	 */
+	antenna = phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK;
+	iwl4965_rt->rt_antenna = le16_to_cpu(antenna) >> 4;
+
+	/* set the preamble flag if appropriate */
+	if (phy_flags_hw & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
+		iwl4965_rt->rt_flags |= IEEE80211_RADIOTAP_F_SHORTPRE;
+
+	stats->flag |= RX_FLAG_RADIOTAP;
+}
+
+static void iwl_update_rx_stats(struct iwl_priv *priv, u16 fc, u16 len)
+{
+	/* 0 - mgmt, 1 - cnt, 2 - data */
+	int idx = (fc & IEEE80211_FCTL_FTYPE) >> 2;
+	priv->rx_stats[idx].cnt++;
+	priv->rx_stats[idx].bytes += len;
+}
+
+/*
+ * returns non-zero if packet should be dropped
+ */
+static int iwl_set_decrypted_flag(struct iwl_priv *priv,
+				      struct ieee80211_hdr *hdr,
+				      u32 decrypt_res,
+				      struct ieee80211_rx_status *stats)
+{
+	u16 fc = le16_to_cpu(hdr->frame_control);
+
+	if (priv->active_rxon.filter_flags & RXON_FILTER_DIS_DECRYPT_MSK)
+		return 0;
+
+	if (!(fc & IEEE80211_FCTL_PROTECTED))
+		return 0;
+
+	IWL_DEBUG_RX("decrypt_res:0x%x\n", decrypt_res);
+	switch (decrypt_res & RX_RES_STATUS_SEC_TYPE_MSK) {
+	case RX_RES_STATUS_SEC_TYPE_TKIP:
+		/* The uCode has got a bad phase 1 Key, pushes the packet.
+		 * Decryption will be done in SW. */
+		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
+		    RX_RES_STATUS_BAD_KEY_TTAK)
+			break;
+
+	case RX_RES_STATUS_SEC_TYPE_WEP:
+		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
+		    RX_RES_STATUS_BAD_ICV_MIC) {
+			/* bad ICV, the packet is destroyed since the
+			 * decryption is inplace, drop it */
+			IWL_DEBUG_RX("Packet destroyed\n");
+			return -1;
+		}
+	case RX_RES_STATUS_SEC_TYPE_CCMP:
+		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
+		    RX_RES_STATUS_DECRYPT_OK) {
+			IWL_DEBUG_RX("hw decrypt successfully!!!\n");
+			stats->flag |= RX_FLAG_DECRYPTED;
+		}
+		break;
+
+	default:
+		break;
+	}
+	return 0;
+}
+
+static u32 iwl_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
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
+	IWL_DEBUG_RX("decrypt_in:0x%x  decrypt_out = 0x%x\n",
+					decrypt_in, decrypt_out);
+
+	return decrypt_out;
+}
+
+static void iwl_handle_data_packet(struct iwl_priv *priv, int is_data,
+				       int include_phy,
+				       struct iwl_rx_mem_buffer *rxb,
+				       struct ieee80211_rx_status *stats)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl4965_rx_phy_res *rx_start = (include_phy) ?
+	    (struct iwl4965_rx_phy_res *)&(pkt->u.raw[0]) : NULL;
+	struct ieee80211_hdr *hdr;
+	u16 len;
+	__le32 *rx_end;
+	unsigned int skblen;
+	u32 ampdu_status;
+	u32 ampdu_status_legacy;
+
+	if (!include_phy && priv->last_phy_res[0])
+		rx_start = (struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
+
+	if (!rx_start) {
+		IWL_ERROR("MPDU frame without a PHY data\n");
+		return;
+	}
+	if (include_phy) {
+		hdr = (struct ieee80211_hdr *)((u8 *) &rx_start[1] +
+					       rx_start->cfg_phy_cnt);
+
+		len = le16_to_cpu(rx_start->byte_count);
+
+		rx_end = (__le32 *) ((u8 *) &pkt->u.raw[0] +
+				  sizeof(struct iwl4965_rx_phy_res) +
+				  rx_start->cfg_phy_cnt + len);
+
+	} else {
+		struct iwl4965_rx_mpdu_res_start *amsdu =
+		    (struct iwl4965_rx_mpdu_res_start *)pkt->u.raw;
+
+		hdr = (struct ieee80211_hdr *)(pkt->u.raw +
+			       sizeof(struct iwl4965_rx_mpdu_res_start));
+		len =  le16_to_cpu(amsdu->byte_count);
+		rx_start->byte_count = amsdu->byte_count;
+		rx_end = (__le32 *) (((u8 *) hdr) + len);
+	}
+	/* In monitor mode allow 802.11 ACk frames (10 bytes) */
+	if (len > priv->hw_params.max_pkt_size ||
+	    len < ((priv->iw_mode == IEEE80211_IF_TYPE_MNTR) ? 10 : 16)) {
+		IWL_WARNING("byte count out of range [16,4K] : %d\n", len);
+		return;
+	}
+
+	ampdu_status = le32_to_cpu(*rx_end);
+	skblen = ((u8 *) rx_end - (u8 *) &pkt->u.raw[0]) + sizeof(u32);
+
+	if (!include_phy) {
+		/* New status scheme, need to translate */
+		ampdu_status_legacy = ampdu_status;
+		ampdu_status = iwl_translate_rx_status(priv, ampdu_status);
+	}
+
+	/* start from MAC */
+	skb_reserve(rxb->skb, (void *)hdr - (void *)pkt);
+	skb_put(rxb->skb, len);	/* end where data ends */
+
+	/* We only process data packets if the interface is open */
+	if (unlikely(!priv->is_open)) {
+		IWL_DEBUG_DROP_LIMIT
+		    ("Dropping packet while interface is not open.\n");
+		return;
+	}
+
+	stats->flag = 0;
+	hdr = (struct ieee80211_hdr *)rxb->skb->data;
+
+	/*  in case of HW accelerated crypto and bad decryption, drop */
+	if (!priv->hw_params.sw_crypto &&
+	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
+		return;
+
+	if (priv->add_radiotap)
+		iwl_add_radiotap(priv, rxb->skb, rx_start, stats, ampdu_status);
+
+	iwl_update_rx_stats(priv, le16_to_cpu(hdr->frame_control), len);
+	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
+	priv->alloc_rxb_skb--;
+	rxb->skb = NULL;
+}
+
+/* Calc max signal level (dBm) among 3 possible receivers */
+static int iwl_calc_rssi(struct iwl_priv *priv,
+			     struct iwl4965_rx_phy_res *rx_resp)
+{
+	/* data from PHY/DSP regarding signal strength, etc.,
+	 *   contents are always there, not configurable by host.  */
+	struct iwl4965_rx_non_cfg_phy *ncphy =
+	    (struct iwl4965_rx_non_cfg_phy *)rx_resp->non_cfg_phy;
+	u32 agc = (le16_to_cpu(ncphy->agc_info) & IWL_AGC_DB_MASK)
+			>> IWL_AGC_DB_POS;
+
+	u32 valid_antennae =
+	    (le16_to_cpu(rx_resp->phy_flags) & RX_PHY_FLAGS_ANTENNAE_MASK)
+			>> RX_PHY_FLAGS_ANTENNAE_OFFSET;
+	u8 max_rssi = 0;
+	u32 i;
+
+	/* Find max rssi among 3 possible receivers.
+	 * These values are measured by the digital signal processor (DSP).
+	 * They should stay fairly constant even as the signal strength varies,
+	 *   if the radio's automatic gain control (AGC) is working right.
+	 * AGC value (see below) will provide the "interesting" info. */
+	for (i = 0; i < 3; i++)
+		if (valid_antennae & (1 << i))
+			max_rssi = max(ncphy->rssi_info[i << 1], max_rssi);
+
+	IWL_DEBUG_STATS("Rssi In A %d B %d C %d Max %d AGC dB %d\n",
+		ncphy->rssi_info[0], ncphy->rssi_info[2], ncphy->rssi_info[4],
+		max_rssi, agc);
+
+	/* dBm = max_rssi dB - agc dB - constant.
+	 * Higher AGC (higher radio gain) means lower signal. */
+	return max_rssi - agc - IWL_RSSI_OFFSET;
+}
+
+static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].sta.station_flags &= ~STA_FLG_PWR_SAVE_MSK;
+	priv->stations[sta_id].sta.station_flags_msk = STA_FLG_PWR_SAVE_MSK;
+	priv->stations[sta_id].sta.sta.modify_mask = 0;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+}
+
+static void iwl_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
+{
+	/* FIXME: need locking over ps_status ??? */
+	u8 sta_id = iwl_find_station(priv, addr);
+
+	if (sta_id != IWL_INVALID_STATION) {
+		u8 sta_awake = priv->stations[sta_id].
+				ps_status == STA_PS_STATUS_WAKE;
+
+		if (sta_awake && ps_bit)
+			priv->stations[sta_id].ps_status = STA_PS_STATUS_SLEEP;
+		else if (!sta_awake && !ps_bit) {
+			iwl_sta_modify_ps_wake(priv, sta_id);
+			priv->stations[sta_id].ps_status = STA_PS_STATUS_WAKE;
+		}
+	}
+}
+
+#define IWL_PACKET_RETRY_TIME HZ
+
+static int iwl_is_duplicate_packet(struct iwl_priv *priv,
+		struct ieee80211_hdr *header)
+{
+	u16 sc = le16_to_cpu(header->seq_ctrl);
+	u16 seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
+	u16 frag = sc & IEEE80211_SCTL_FRAG;
+	u16 *last_seq, *last_frag;
+	unsigned long *last_time;
+
+	switch (priv->iw_mode) {
+	case IEEE80211_IF_TYPE_IBSS:{
+		struct list_head *p;
+		struct iwl4965_ibss_seq *entry = NULL;
+		u8 *mac = header->addr2;
+		int index = mac[5] & (IWL_IBSS_MAC_HASH_SIZE - 1);
+
+		__list_for_each(p, &priv->ibss_mac_hash[index]) {
+			entry = list_entry(p, struct iwl4965_ibss_seq, list);
+			if (!compare_ether_addr(entry->mac, mac))
+				break;
+		}
+		if (p == &priv->ibss_mac_hash[index]) {
+			entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+			if (!entry) {
+				IWL_ERROR("Cannot malloc new mac entry\n");
+				return 0;
+			}
+			memcpy(entry->mac, mac, ETH_ALEN);
+			entry->seq_num = seq;
+			entry->frag_num = frag;
+			entry->packet_time = jiffies;
+			list_add(&entry->list, &priv->ibss_mac_hash[index]);
+			return 0;
+		}
+		last_seq = &entry->seq_num;
+		last_frag = &entry->frag_num;
+		last_time = &entry->packet_time;
+		break;
+	}
+	case IEEE80211_IF_TYPE_STA:
+		last_seq = &priv->last_seq_num;
+		last_frag = &priv->last_frag_num;
+		last_time = &priv->last_packet_time;
+		break;
+	default:
+		return 0;
+	}
+	if ((*last_seq == seq) &&
+	    time_after(*last_time + IWL_PACKET_RETRY_TIME, jiffies)) {
+		if (*last_frag == frag)
+			goto drop;
+		if (*last_frag + 1 != frag)
+			/* out-of-order fragment */
+			goto drop;
+	} else
+		*last_seq = seq;
+
+	*last_frag = frag;
+	*last_time = jiffies;
+	return 0;
+
+ drop:
+	return 1;
+}
+
+static int iwl_is_network_packet(struct iwl_priv *priv,
+		struct ieee80211_hdr *header)
+{
+	/* Filter incoming packets to determine if they are targeted toward
+	 * this network, discarding packets coming from ourselves */
+	switch (priv->iw_mode) {
+	case IEEE80211_IF_TYPE_IBSS: /* Header: Dest. | Source    | BSSID */
+		/* packets from our adapter are dropped (echo) */
+		if (!compare_ether_addr(header->addr2, priv->mac_addr))
+			return 0;
+		/* {broad,multi}cast packets to our IBSS go through */
+		if (is_multicast_ether_addr(header->addr1))
+			return !compare_ether_addr(header->addr3, priv->bssid);
+		/* packets to our adapter go through */
+		return !compare_ether_addr(header->addr1, priv->mac_addr);
+	case IEEE80211_IF_TYPE_STA: /* Header: Dest. | AP{BSSID} | Source */
+		/* packets from our adapter are dropped (echo) */
+		if (!compare_ether_addr(header->addr3, priv->mac_addr))
+			return 0;
+		/* {broad,multi}cast packets to our BSS go through */
+		if (is_multicast_ether_addr(header->addr1))
+			return !compare_ether_addr(header->addr2, priv->bssid);
+		/* packets to our adapter go through */
+		return !compare_ether_addr(header->addr1, priv->mac_addr);
+	default:
+		break;
+	}
+
+	return 1;
+}
+
+/* Called for REPLY_RX (legacy ABG frames), or
+ * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
+void iwl_rx_reply_rx(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb)
+{
+	struct ieee80211_hdr *header;
+	struct ieee80211_rx_status rx_status;
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	/* Use phy data (Rx signal strength, etc.) contained within
+	 *   this rx packet for legacy frames,
+	 *   or phy data cached from REPLY_RX_PHY_CMD for HT frames. */
+	int include_phy = (pkt->hdr.cmd == REPLY_RX);
+	struct iwl4965_rx_phy_res *rx_start = (include_phy) ?
+		(struct iwl4965_rx_phy_res *)&(pkt->u.raw[0]) :
+		(struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
+	__le32 *rx_end;
+	unsigned int len = 0;
+	u16 fc;
+	u8 network_packet;
+
+	rx_status.mactime = le64_to_cpu(rx_start->timestamp);
+	rx_status.freq =
+		ieee80211_channel_to_frequency(le16_to_cpu(rx_start->channel));
+	rx_status.band = (rx_start->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
+				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+	rx_status.rate_idx =
+		iwl_hwrate_to_plcp_idx(le32_to_cpu(rx_start->rate_n_flags));
+	if (rx_status.band == IEEE80211_BAND_5GHZ)
+		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
+
+	rx_status.antenna = 0;
+	rx_status.flag = 0;
+
+	if ((unlikely(rx_start->cfg_phy_cnt > 20))) {
+		IWL_DEBUG_DROP("dsp size out of range [0,20]: %d/n",
+				rx_start->cfg_phy_cnt);
+		return;
+	}
+
+	if (!include_phy) {
+		if (priv->last_phy_res[0])
+			rx_start = (struct iwl4965_rx_phy_res *)
+				&priv->last_phy_res[1];
+		else
+			rx_start = NULL;
+	}
+
+	if (!rx_start) {
+		IWL_ERROR("MPDU frame without a PHY data\n");
+		return;
+	}
+
+	if (include_phy) {
+		header = (struct ieee80211_hdr *)((u8 *) &rx_start[1]
+						  + rx_start->cfg_phy_cnt);
+
+		len = le16_to_cpu(rx_start->byte_count);
+		rx_end = (__le32 *)(pkt->u.raw + rx_start->cfg_phy_cnt +
+				  sizeof(struct iwl4965_rx_phy_res) + len);
+	} else {
+		struct iwl4965_rx_mpdu_res_start *amsdu =
+			(struct iwl4965_rx_mpdu_res_start *)pkt->u.raw;
+
+		header = (void *)(pkt->u.raw +
+			sizeof(struct iwl4965_rx_mpdu_res_start));
+		len = le16_to_cpu(amsdu->byte_count);
+		rx_end = (__le32 *) (pkt->u.raw +
+			sizeof(struct iwl4965_rx_mpdu_res_start) + len);
+	}
+
+	if (!(*rx_end & RX_RES_STATUS_NO_CRC32_ERROR) ||
+	    !(*rx_end & RX_RES_STATUS_NO_RXE_OVERFLOW)) {
+		IWL_DEBUG_RX("Bad CRC or FIFO: 0x%08X.\n",
+				le32_to_cpu(*rx_end));
+		return;
+	}
+
+	priv->ucode_beacon_time = le32_to_cpu(rx_start->beacon_time_stamp);
+
+	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
+	rx_status.signal = iwl_calc_rssi(priv, rx_start);
+
+	/* Meaningful noise values are available only from beacon statistics,
+	 *   which are gathered only when associated, and indicate noise
+	 *   only for the associated network channel ...
+	 * Ignore these noise values while scanning (other channels) */
+	if (iwl_is_associated(priv) &&
+	    !test_bit(STATUS_SCANNING, &priv->status)) {
+		rx_status.noise = priv->last_rx_noise;
+		rx_status.qual = iwl_calc_sig_qual(rx_status.signal,
+							 rx_status.noise);
+	} else {
+		rx_status.noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
+		rx_status.qual = iwl_calc_sig_qual(rx_status.signal, 0);
+	}
+
+	/* Reset beacon noise level if not associated. */
+	if (!iwl_is_associated(priv))
+		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
+
+	/* Set "1" to report good data frames in groups of 100 */
+	/* FIXME: need to optimze the call: */
+	iwl_dbg_report_frame(priv, pkt, header, 1);
+
+	IWL_DEBUG_STATS_LIMIT("Rssi %d, noise %d, qual %d, TSF %llu\n",
+		rx_status.signal, rx_status.noise, rx_status.signal,
+		(unsigned long long)rx_status.mactime);
+
+
+	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
+		iwl_handle_data_packet(priv, 1, include_phy,
+						 rxb, &rx_status);
+		return;
+	}
+
+	network_packet = iwl_is_network_packet(priv, header);
+	if (network_packet) {
+		priv->last_rx_rssi = rx_status.signal;
+		priv->last_beacon_time =  priv->ucode_beacon_time;
+		priv->last_tsf = le64_to_cpu(rx_start->timestamp);
+	}
+
+	fc = le16_to_cpu(header->frame_control);
+	switch (fc & IEEE80211_FCTL_FTYPE) {
+	case IEEE80211_FTYPE_MGMT:
+		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
+			iwl_update_ps_mode(priv, fc  & IEEE80211_FCTL_PM,
+						header->addr2);
+		iwl_handle_data_packet(priv, 0, include_phy, rxb, &rx_status);
+		break;
+
+	case IEEE80211_FTYPE_CTL:
+		switch (fc & IEEE80211_FCTL_STYPE) {
+		case IEEE80211_STYPE_BACK_REQ:
+			IWL_DEBUG_HT("IEEE80211_STYPE_BACK_REQ arrived\n");
+			iwl_handle_data_packet(priv, 0, include_phy,
+						rxb, &rx_status);
+			break;
+		default:
+			break;
+		}
+		break;
+
+	case IEEE80211_FTYPE_DATA: {
+		DECLARE_MAC_BUF(mac1);
+		DECLARE_MAC_BUF(mac2);
+		DECLARE_MAC_BUF(mac3);
+
+		if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
+			iwl_update_ps_mode(priv, fc  & IEEE80211_FCTL_PM,
+						header->addr2);
+
+		if (unlikely(!network_packet))
+			IWL_DEBUG_DROP("Dropping (non network): "
+				       "%s, %s, %s\n",
+				       print_mac(mac1, header->addr1),
+				       print_mac(mac2, header->addr2),
+				       print_mac(mac3, header->addr3));
+		else if (unlikely(iwl_is_duplicate_packet(priv, header)))
+			IWL_DEBUG_DROP("Dropping (dup): %s, %s, %s\n",
+				       print_mac(mac1, header->addr1),
+				       print_mac(mac2, header->addr2),
+				       print_mac(mac3, header->addr3));
+		else
+			iwl_handle_data_packet(priv, 1, include_phy, rxb,
+						   &rx_status);
+		break;
+	}
+	default:
+		break;
+
+	}
+}
+EXPORT_SYMBOL(iwl_rx_reply_rx);
+
+/* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
+ * This will be used later in iwl_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
+void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
+				    struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	priv->last_phy_res[0] = 1;
+	memcpy(&priv->last_phy_res[1], &(pkt->u.raw[0]),
+	       sizeof(struct iwl4965_rx_phy_res));
+}
+EXPORT_SYMBOL(iwl_rx_reply_rx_phy);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index a607b39..499705f 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -613,36 +613,6 @@ static void iwl4965_activate_qos(struct iwl_priv *priv, u8 force)
 	}
 }
 
-int iwl4965_is_network_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
-{
-	/* Filter incoming packets to determine if they are targeted toward
-	 * this network, discarding packets coming from ourselves */
-	switch (priv->iw_mode) {
-	case IEEE80211_IF_TYPE_IBSS: /* Header: Dest. | Source    | BSSID */
-		/* packets from our adapter are dropped (echo) */
-		if (!compare_ether_addr(header->addr2, priv->mac_addr))
-			return 0;
-		/* {broad,multi}cast packets to our IBSS go through */
-		if (is_multicast_ether_addr(header->addr1))
-			return !compare_ether_addr(header->addr3, priv->bssid);
-		/* packets to our adapter go through */
-		return !compare_ether_addr(header->addr1, priv->mac_addr);
-	case IEEE80211_IF_TYPE_STA: /* Header: Dest. | AP{BSSID} | Source */
-		/* packets from our adapter are dropped (echo) */
-		if (!compare_ether_addr(header->addr3, priv->mac_addr))
-			return 0;
-		/* {broad,multi}cast packets to our BSS go through */
-		if (is_multicast_ether_addr(header->addr1))
-			return !compare_ether_addr(header->addr2, priv->bssid);
-		/* packets to our adapter go through */
-		return !compare_ether_addr(header->addr1, priv->mac_addr);
-	default:
-		break;
-	}
-
-	return 1;
-}
-
 static void iwl4965_sequence_reset(struct iwl_priv *priv)
 {
 	/* Reset ieee stats */
@@ -906,72 +876,6 @@ static void iwl4965_set_rate(struct iwl_priv *priv)
 		   (IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
 }
 
-#define IWL_PACKET_RETRY_TIME HZ
-
-int iwl4965_is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr *header)
-{
-	u16 sc = le16_to_cpu(header->seq_ctrl);
-	u16 seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
-	u16 frag = sc & IEEE80211_SCTL_FRAG;
-	u16 *last_seq, *last_frag;
-	unsigned long *last_time;
-
-	switch (priv->iw_mode) {
-	case IEEE80211_IF_TYPE_IBSS:{
-		struct list_head *p;
-		struct iwl4965_ibss_seq *entry = NULL;
-		u8 *mac = header->addr2;
-		int index = mac[5] & (IWL_IBSS_MAC_HASH_SIZE - 1);
-
-		__list_for_each(p, &priv->ibss_mac_hash[index]) {
-			entry = list_entry(p, struct iwl4965_ibss_seq, list);
-			if (!compare_ether_addr(entry->mac, mac))
-				break;
-		}
-		if (p == &priv->ibss_mac_hash[index]) {
-			entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
-			if (!entry) {
-				IWL_ERROR("Cannot malloc new mac entry\n");
-				return 0;
-			}
-			memcpy(entry->mac, mac, ETH_ALEN);
-			entry->seq_num = seq;
-			entry->frag_num = frag;
-			entry->packet_time = jiffies;
-			list_add(&entry->list, &priv->ibss_mac_hash[index]);
-			return 0;
-		}
-		last_seq = &entry->seq_num;
-		last_frag = &entry->frag_num;
-		last_time = &entry->packet_time;
-		break;
-	}
-	case IEEE80211_IF_TYPE_STA:
-		last_seq = &priv->last_seq_num;
-		last_frag = &priv->last_frag_num;
-		last_time = &priv->last_packet_time;
-		break;
-	default:
-		return 0;
-	}
-	if ((*last_seq == seq) &&
-	    time_after(*last_time + IWL_PACKET_RETRY_TIME, jiffies)) {
-		if (*last_frag == frag)
-			goto drop;
-		if (*last_frag + 1 != frag)
-			/* out-of-order fragment */
-			goto drop;
-	} else
-		*last_seq = seq;
-
-	*last_frag = frag;
-	*last_time = jiffies;
-	return 0;
-
- drop:
-	return 1;
-}
-
 #ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 
 #include "iwl-spectrum.h"
@@ -1350,17 +1254,6 @@ static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
 		wake_up_interruptible(&priv->wait_command_queue);
 }
 
-/* Cache phy data (Rx signal strength, etc) for HT frame (REPLY_RX_PHY_CMD).
- * This will be used later in iwl4965_rx_reply_rx() for REPLY_RX_MPDU_CMD. */
-static void iwl4965_rx_reply_rx_phy(struct iwl_priv *priv,
-				    struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	priv->last_phy_res[0] = 1;
-	memcpy(&priv->last_phy_res[1], &(pkt->u.raw[0]),
-	       sizeof(struct iwl4965_rx_phy_res));
-}
-
 /**
  * iwl4965_setup_rx_handlers - Initialize Rx handler callbacks
  *
@@ -1398,8 +1291,8 @@ static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[MISSED_BEACONS_NOTIFICATION] =
 	    iwl_rx_missed_beacon_notif;
 	/* Rx handlers */
-	priv->rx_handlers[REPLY_RX_PHY_CMD] = iwl4965_rx_reply_rx_phy;
-	priv->rx_handlers[REPLY_RX_MPDU_CMD] = iwl4965_rx_reply_rx;
+	priv->rx_handlers[REPLY_RX_PHY_CMD] = iwl_rx_reply_rx_phy;
+	priv->rx_handlers[REPLY_RX_MPDU_CMD] = iwl_rx_reply_rx;
 	/* Set up hardware specific Rx handlers */
 	priv->cfg->ops->lib->rx_handler_setup(priv);
 }
@@ -1530,47 +1423,6 @@ void iwl_rx_handle(struct iwl_priv *priv)
 	iwl_rx_queue_restock(priv);
 }
 
-#define PERFECT_RSSI (-20) /* dBm */
-#define WORST_RSSI (-95)   /* dBm */
-#define RSSI_RANGE (PERFECT_RSSI - WORST_RSSI)
-
-/* Calculate an indication of rx signal quality (a percentage, not dBm!).
- * See http://www.ces.clemson.edu/linux/signal_quality.shtml for info
- *   about formulas used below. */
-int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm)
-{
-	int sig_qual;
-	int degradation = PERFECT_RSSI - rssi_dbm;
-
-	/* If we get a noise measurement, use signal-to-noise ratio (SNR)
-	 * as indicator; formula is (signal dbm - noise dbm).
-	 * SNR at or above 40 is a great signal (100%).
-	 * Below that, scale to fit SNR of 0 - 40 dB within 0 - 100% indicator.
-	 * Weakest usable signal is usually 10 - 15 dB SNR. */
-	if (noise_dbm) {
-		if (rssi_dbm - noise_dbm >= 40)
-			return 100;
-		else if (rssi_dbm < noise_dbm)
-			return 0;
-		sig_qual = ((rssi_dbm - noise_dbm) * 5) / 2;
-
-	/* Else use just the signal level.
-	 * This formula is a least squares fit of data points collected and
-	 *   compared with a reference system that had a percentage (%) display
-	 *   for signal quality. */
-	} else
-		sig_qual = (100 * (RSSI_RANGE * RSSI_RANGE) - degradation *
-			    (15 * RSSI_RANGE + 62 * degradation)) /
-			   (RSSI_RANGE * RSSI_RANGE);
-
-	if (sig_qual > 100)
-		sig_qual = 100;
-	else if (sig_qual < 1)
-		sig_qual = 0;
-
-	return sig_qual;
-}
-
 #ifdef CONFIG_IWLWIFI_DEBUG
 static void iwl4965_print_rx_config_cmd(struct iwl_priv *priv)
 {
-- 
1.5.3.6

