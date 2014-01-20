Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49202 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaATSuh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 13:50:37 -0500
Received: from ultralex.lan ([79.218.100.244]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0LlHsg-1VVhfC11hW-00b3Wd for
 <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 19:50:35 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 5/5] ath9k_htc: rework ath9k_rx_prepare and make use of common funcs
Date: Mon, 20 Jan 2014 19:50:11 +0100
Message-Id: <1390243811-9132-4-git-send-email-linux@rempel-privat.de> (sfid-20140120_195040_063430_7131105E)
In-Reply-To: <1390243811-9132-1-git-send-email-linux@rempel-privat.de>
References: <1390243693-9061-1-git-send-email-linux@rempel-privat.de>
 <1390243811-9132-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 149 ++++++++------------------
 drivers/net/wireless/ath/ath9k/mac.h          |   9 +-
 5 files changed, 50 insertions(+), 111 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 58da346..c75493f 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -275,7 +275,6 @@ struct ath9k_htc_rxbuf {
 };
 
 struct ath9k_htc_rx {
-	int last_rssi; /* FIXME: per-STA */
 	struct list_head rxbuf;
 	spinlock_t rxbuflock;
 };
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index f4e1de2..9db8aef 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -607,6 +607,7 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 
 	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 
+	common->last_rssi = ATH_RSSI_DUMMY_MARKER;
 	priv->ah->opmode = NL80211_IFTYPE_STATION;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 608d739..228549a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1457,6 +1457,7 @@ static void ath9k_htc_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 
 	if ((vif->type == NL80211_IFTYPE_STATION) && bss_conf->assoc) {
 		common->curaid = bss_conf->aid;
+		common->last_rssi = ATH_RSSI_DUMMY_MARKER;
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 12e0f32..53e3903 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -927,43 +927,40 @@ void ath9k_host_rx_init(struct ath9k_htc_priv *priv)
 	ath9k_hw_rxena(priv->ah);
 	ath9k_htc_opmode_init(priv);
 	ath9k_hw_startpcureceive(priv->ah, test_bit(OP_SCANNING, &priv->op_flags));
-	priv->rx.last_rssi = ATH_RSSI_DUMMY_MARKER;
 }
 
-static void ath9k_process_rate(struct ieee80211_hw *hw,
-			       struct ieee80211_rx_status *rxs,
-			       u8 rx_rate, u8 rs_flags)
+static u32 conver_htc_flags(u32 htc_flags)
 {
-	struct ieee80211_supported_band *sband;
-	enum ieee80211_band band;
-	unsigned int i = 0;
-
-	if (rx_rate & 0x80) {
-		/* HT rate */
-		rxs->flag |= RX_FLAG_HT;
-		if (rs_flags & ATH9K_RX_2040)
-			rxs->flag |= RX_FLAG_40MHZ;
-		if (rs_flags & ATH9K_RX_GI)
-			rxs->flag |= RX_FLAG_SHORT_GI;
-		rxs->rate_idx = rx_rate & 0x7f;
-		return;
-	}
-
-	band = hw->conf.chandef.chan->band;
-	sband = hw->wiphy->bands[band];
+	u32 flags;
+	if (htc_flags & ATH9K_RX_2040)
+		flags |= RX_FLAG_40MHZ;
+	if (htc_flags & ATH9K_RX_GI)
+		flags |= RX_FLAG_SHORT_GI;
+	return flags;
+}
 
-	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sband->bitrates[i].hw_value == rx_rate) {
-			rxs->rate_idx = i;
-			return;
-		}
-		if (sband->bitrates[i].hw_value_short == rx_rate) {
-			rxs->rate_idx = i;
-			rxs->flag |= RX_FLAG_SHORTPRE;
-			return;
-		}
-	}
 
+static void rx_status_htc_to_ath(struct ath_rx_status *rx_stats,
+				 struct ath_htc_rx_status *rxstatus)
+{
+	rx_stats->rs_datalen	= rxstatus->rs_datalen;
+	rx_stats->rs_status	= rxstatus->rs_status;
+	rx_stats->rs_phyerr	= rxstatus->rs_phyerr;
+	rx_stats->rs_rssi	= rxstatus->rs_rssi;
+	rx_stats->rs_keyix	= rxstatus->rs_keyix;
+	rx_stats->rs_rate	= rxstatus->rs_rate;
+	rx_stats->rs_antenna	= rxstatus->rs_antenna;
+	rx_stats->rs_more	= rxstatus->rs_more;
+
+	memcpy(rx_stats->rs_rssi_ctl, rxstatus->rs_rssi_ctl,
+		sizeof(rx_stats->rs_rssi_ctl));
+	memcpy(rx_stats->rs_rssi_ext, rxstatus->rs_rssi_ext,
+		sizeof(rx_stats->rs_rssi_ext));
+
+	rx_stats->rs_isaggr	= rxstatus->rs_isaggr;
+	rx_stats->rs_moreaggr	= rxstatus->rs_moreaggr;
+	rx_stats->rs_num_delims	= rxstatus->rs_num_delims;
+	rx_stats->rs_flags	= conver_htc_flags(rxstatus->rs_flags);
 }
 
 static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
@@ -976,8 +973,9 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct sk_buff *skb = rxbuf->skb;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath_htc_rx_status *rxstatus;
+	struct ath_rx_status *rx_stats;
 	int hdrlen, padsize;
-	int last_rssi = ATH_RSSI_DUMMY_MARKER;
+	bool decrypt_error_dummy;
 	__le16 fc;
 
 	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
@@ -1013,85 +1011,28 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	}
 
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
+	rx_status_htc_to_ath(rx_stats, &rxbuf->rxstatus);
 
-	if (rxbuf->rxstatus.rs_status != 0) {
-		if (rxbuf->rxstatus.rs_status & ATH9K_RXERR_CRC)
-			rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-		if (rxbuf->rxstatus.rs_status & ATH9K_RXERR_PHY)
-			goto rx_next;
-
-		if (rxbuf->rxstatus.rs_status & ATH9K_RXERR_DECRYPT) {
-			/* FIXME */
-		} else if (rxbuf->rxstatus.rs_status & ATH9K_RXERR_MIC) {
-			if (ieee80211_is_ctl(fc))
-				/*
-				 * Sometimes, we get invalid
-				 * MIC failures on valid control frames.
-				 * Remove these mic errors.
-				 */
-				rxbuf->rxstatus.rs_status &= ~ATH9K_RXERR_MIC;
-			else
-				rx_status->flag |= RX_FLAG_MMIC_ERROR;
-		}
-
-		/*
-		 * Reject error frames with the exception of
-		 * decryption and MIC failures. For monitor mode,
-		 * we also ignore the CRC error.
-		 */
-		if (priv->ah->opmode == NL80211_IFTYPE_MONITOR) {
-			if (rxbuf->rxstatus.rs_status &
-			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
-			      ATH9K_RXERR_CRC))
-				goto rx_next;
-		} else {
-			if (rxbuf->rxstatus.rs_status &
-			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC)) {
-				goto rx_next;
-			}
-		}
-	}
-
-	if (!(rxbuf->rxstatus.rs_status & ATH9K_RXERR_DECRYPT)) {
-		u8 keyix;
-		keyix = rxbuf->rxstatus.rs_keyix;
-		if (keyix != ATH9K_RXKEYIX_INVALID) {
-			rx_status->flag |= RX_FLAG_DECRYPTED;
-		} else if (ieee80211_has_protected(fc) &&
-			   skb->len >= hdrlen + 4) {
-			keyix = skb->data[hdrlen + 3] >> 6;
-			if (test_bit(keyix, common->keymap))
-				rx_status->flag |= RX_FLAG_DECRYPTED;
-		}
-	}
-
-	ath9k_process_rate(hw, rx_status, rxbuf->rxstatus.rs_rate,
-			   rxbuf->rxstatus.rs_flags);
-
-	if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
-	    !rxbuf->rxstatus.rs_moreaggr)
-		ATH_RSSI_LPF(priv->rx.last_rssi,
-			     rxbuf->rxstatus.rs_rssi);
-
-	last_rssi = priv->rx.last_rssi;
-
-	if (ath_is_mybeacon(common, hdr)) {
-		s8 rssi = rxbuf->rxstatus.rs_rssi;
+	/*
+	 * everything but the rate is checked here, the rate check is done
+	 * separately to avoid doing two lookups for a rate for each frame.
+	 */
+	if (!ath9k_cmn_rx_accept(common, hdr, rx_status, rx_stats,
+			&decrypt_error_dummy, priv->rxfilter))
+		goto rx_next;
 
-		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-			rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
+	rx_stats->is_mybeacon = ath_is_mybeacon(common, hdr);
 
-		if (rssi < 0)
-			rssi = 0;
+	if (ath9k_cmn_process_rate(common, hw, rx_stats, rx_status))
+		goto rx_next;
 
-		priv->ah->stats.avgbrssi = rssi;
-	}
+	ath9k_cmn_process_rssi(common, hw, rx_stats, rx_status);
 
 	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
+
 	rx_status->band = hw->conf.chandef.chan->band;
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
-	rx_status->signal =  rxbuf->rxstatus.rs_rssi + ATH_DEFAULT_NOISE_FLOOR;
-	rx_status->antenna = rxbuf->rxstatus.rs_antenna;
+	rx_status->antenna = rx_stats->rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_END;
 
 	return true;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 1027137..89df634 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -155,12 +155,8 @@ struct ath_htc_rx_status {
 	u8 rs_status;
 	u8 rs_phyerr;
 	int8_t rs_rssi;
-	int8_t rs_rssi_ctl0;
-	int8_t rs_rssi_ctl1;
-	int8_t rs_rssi_ctl2;
-	int8_t rs_rssi_ext0;
-	int8_t rs_rssi_ext1;
-	int8_t rs_rssi_ext2;
+	int8_t rs_rssi_ctl[3];
+	int8_t rs_rssi_ext[3];
 	u8 rs_keyix;
 	u8 rs_rate;
 	u8 rs_antenna;
@@ -170,6 +166,7 @@ struct ath_htc_rx_status {
 	u8 rs_num_delims;
 	u8 rs_flags;
 	u8 rs_dummy;
+	/* FIXME: evm* never used? */
 	__be32 evm0;
 	__be32 evm1;
 	__be32 evm2;
-- 
1.8.5.3

