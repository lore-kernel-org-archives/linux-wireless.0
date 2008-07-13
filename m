Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-80-86-92-145.inaddr.intergenia.de ([80.86.92.145]:41656
	"EHLO home.einfach.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYGMWpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2008 18:45:44 -0400
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH] iwlwifi: use generic mac80211 radiotap headers
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	tomasw@gmail.com, yi.zhu@intel.com
Date: Mon, 14 Jul 2008 00:20:46 +0200
Message-ID: <20080713222046.16802.14490.stgit@void> (sfid-20080714_004611_832782_2438CFFB)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove drivers own implementation of radiotap in favor of the generic one
provided by mac80211.

also remove priv->add_radiotap because it is not used any more.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

 drivers/net/wireless/iwlwifi/iwl-3945.c     |  105 +--------------------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 
 drivers/net/wireless/iwlwifi/iwl-rx.c       |  133 ++++-----------------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 
 5 files changed, 27 insertions(+), 215 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 94e177a..73fc316 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -514,100 +514,6 @@ static inline void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
 }
 #endif
 
-
-static void iwl3945_add_radiotap(struct iwl3945_priv *priv,
-				 struct sk_buff *skb,
-				 struct iwl3945_rx_frame_hdr *rx_hdr,
-				 struct ieee80211_rx_status *stats)
-{
-	/* First cache any information we need before we overwrite
-	 * the information provided in the skb from the hardware */
-	s8 signal = stats->signal;
-	s8 noise = 0;
-	int rate = stats->rate_idx;
-	u64 tsf = stats->mactime;
-	__le16 phy_flags_hw = rx_hdr->phy_flags, antenna;
-
-	struct iwl3945_rt_rx_hdr {
-		struct ieee80211_radiotap_header rt_hdr;
-		__le64 rt_tsf;		/* TSF */
-		u8 rt_flags;		/* radiotap packet flags */
-		u8 rt_rate;		/* rate in 500kb/s */
-		__le16 rt_channelMHz;	/* channel in MHz */
-		__le16 rt_chbitmask;	/* channel bitfield */
-		s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
-		s8 rt_dbmnoise;
-		u8 rt_antenna;		/* antenna number */
-	} __attribute__ ((packed)) *iwl3945_rt;
-
-	if (skb_headroom(skb) < sizeof(*iwl3945_rt)) {
-		if (net_ratelimit())
-			printk(KERN_ERR "not enough headroom [%d] for "
-			       "radiotap head [%zd]\n",
-			       skb_headroom(skb), sizeof(*iwl3945_rt));
-		return;
-	}
-
-	/* put radiotap header in front of 802.11 header and data */
-	iwl3945_rt = (void *)skb_push(skb, sizeof(*iwl3945_rt));
-
-	/* initialise radiotap header */
-	iwl3945_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
-	iwl3945_rt->rt_hdr.it_pad = 0;
-
-	/* total header + data */
-	put_unaligned_le16(sizeof(*iwl3945_rt), &iwl3945_rt->rt_hdr.it_len);
-
-	/* Indicate all the fields we add to the radiotap header */
-	put_unaligned_le32((1 << IEEE80211_RADIOTAP_TSFT) |
-			   (1 << IEEE80211_RADIOTAP_FLAGS) |
-			   (1 << IEEE80211_RADIOTAP_RATE) |
-			   (1 << IEEE80211_RADIOTAP_CHANNEL) |
-			   (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
-			   (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
-			   (1 << IEEE80211_RADIOTAP_ANTENNA),
-			&iwl3945_rt->rt_hdr.it_present);
-
-	/* Zero the flags, we'll add to them as we go */
-	iwl3945_rt->rt_flags = 0;
-
-	put_unaligned_le64(tsf, &iwl3945_rt->rt_tsf);
-
-	iwl3945_rt->rt_dbmsignal = signal;
-	iwl3945_rt->rt_dbmnoise = noise;
-
-	/* Convert the channel frequency and set the flags */
-	put_unaligned_le16(stats->freq, &iwl3945_rt->rt_channelMHz);
-	if (!(phy_flags_hw & RX_RES_PHY_FLAGS_BAND_24_MSK))
-		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ,
-			      &iwl3945_rt->rt_chbitmask);
-	else if (phy_flags_hw & RX_RES_PHY_FLAGS_MOD_CCK_MSK)
-		put_unaligned_le16(IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ,
-			      &iwl3945_rt->rt_chbitmask);
-	else	/* 802.11g */
-		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ,
-			      &iwl3945_rt->rt_chbitmask);
-
-	if (rate == -1)
-		iwl3945_rt->rt_rate = 0;
-	else {
-		if (stats->band == IEEE80211_BAND_5GHZ)
-			rate += IWL_FIRST_OFDM_RATE;
-
-		iwl3945_rt->rt_rate = iwl3945_rates[rate].ieee;
-	}
-
-	/* antenna number */
-	antenna = phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK;
-	iwl3945_rt->rt_antenna = le16_to_cpu(antenna) >> 4;
-
-	/* set the preamble flag if we have it */
-	if (phy_flags_hw & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
-		iwl3945_rt->rt_flags |= IEEE80211_RADIOTAP_F_SHORTPRE;
-
-	stats->flag |= RX_FLAG_RADIOTAP;
-}
-
 static void iwl3945_handle_data_packet(struct iwl3945_priv *priv, int is_data,
 				   struct iwl3945_rx_mem_buffer *rxb,
 				   struct ieee80211_rx_status *stats)
@@ -641,9 +547,6 @@ static void iwl3945_handle_data_packet(struct iwl3945_priv *priv, int is_data,
 		iwl3945_set_decrypted_flag(priv, rxb->skb,
 				       le32_to_cpu(rx_end->status), stats);
 
-	if (priv->add_radiotap)
-		iwl3945_add_radiotap(priv, rxb->skb, rx_hdr, stats);
-
 #ifdef CONFIG_IWL3945_LEDS
 	if (is_data)
 		priv->rxtxpackets += len;
@@ -668,7 +571,6 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	u16 rx_stats_noise_diff = le16_to_cpu(rx_stats->noise_diff);
 	u8 network_packet;
 
-	rx_status.antenna = 0;
 	rx_status.flag = 0;
 	rx_status.mactime = le64_to_cpu(rx_end->timestamp);
 	rx_status.freq =
@@ -680,6 +582,13 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	if (rx_status.band == IEEE80211_BAND_5GHZ)
 		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
 
+	rx_status.antenna = le16_to_cpu(rx_hdr->phy_flags &
+					RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
+
+	/* set the preamble flag if appropriate */
+	if (rx_hdr->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
+		rx_status.flag |= RX_FLAG_SHORTPRE;
+
 	if ((unlikely(rx_stats->phy_count > 20))) {
 		IWL_DEBUG_DROP
 		    ("dsp size out of range [0,20]: "
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 9c0a09e..e6ccd62 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -718,7 +718,6 @@ struct iwl3945_priv {
 
 	enum ieee80211_band band;
 	int alloc_rxb_skb;
-	bool add_radiotap;
 
 	void (*rx_handlers[REPLY_MAX])(struct iwl3945_priv *priv,
 				       struct iwl3945_rx_mem_buffer *rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c8d3d97..ad5ff2a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -843,7 +843,6 @@ struct iwl_priv {
 
 	enum ieee80211_band band;
 	int alloc_rxb_skb;
-	bool add_radiotap;
 
 	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
 				       struct iwl_rx_mem_buffer *rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index d062d4d..01fe77e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -788,115 +788,6 @@ static inline void iwl_dbg_report_frame(struct iwl_priv *priv,
 }
 #endif
 
-static void iwl_add_radiotap(struct iwl_priv *priv,
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
-	else {
-		if (stats->band == IEEE80211_BAND_5GHZ)
-			rate += IWL_FIRST_OFDM_RATE;
-
-		iwl4965_rt->rt_rate = iwl_rates[rate].ieee;
-	}
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
 static void iwl_update_rx_stats(struct iwl_priv *priv, u16 fc, u16 len)
 {
 	/* 0 - mgmt, 1 - cnt, 2 - data */
@@ -1081,9 +972,6 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	    iwl_set_decrypted_flag(priv, hdr, ampdu_status, stats))
 		return;
 
-	if (priv->add_radiotap)
-		iwl_add_radiotap(priv, rxb->skb, rx_start, stats, ampdu_status);
-
 	iwl_update_rx_stats(priv, le16_to_cpu(hdr->frame_control), len);
 	ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
 	priv->alloc_rxb_skb--;
@@ -1205,7 +1093,6 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 	if (rx_status.band == IEEE80211_BAND_5GHZ)
 		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
 
-	rx_status.antenna = 0;
 	rx_status.flag = 0;
 	rx_status.flag |= RX_FLAG_TSFT;
 
@@ -1284,6 +1171,26 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 		rx_status.signal, rx_status.noise, rx_status.signal,
 		(unsigned long long)rx_status.mactime);
 
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
+	rx_status.antenna = le16_to_cpu(rx_start->phy_flags &
+					RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
+
+	/* set the preamble flag if appropriate */
+	if (rx_start->phy_flags & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
+		rx_status.flag |= RX_FLAG_SHORTPRE;
+
 	/* Take shortcut when only in monitor mode */
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
 		iwl_pass_packet_to_mac80211(priv, include_phy,
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7f65d91..48dc938 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2750,8 +2750,6 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel->hw_value);
 
-	priv->add_radiotap = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
-
 	if (conf->radio_enabled && iwl_radio_kill_sw_enable_radio(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF-KILL - waiting for uCode\n");
 		goto out;

