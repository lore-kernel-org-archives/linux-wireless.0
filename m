Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37855 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab0CAJRp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 04:17:45 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 01:17:45 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19339.35503.744916.194777@gargle.gargle.HOWL>
Date: Mon, 1 Mar 2010 15:06:47 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/7] ath9k: Move RX processing to driver
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX processing is fairly different between ath9k and ath9k_htc.
Since ath9k_htc has its own code dealing with RX, move the
recv management code to ath9k.

Though, a couple of routines can still be shared.
This would be fixed in subsequent patches.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/common.c |  259 -------------------------------
 drivers/net/wireless/ath/ath9k/common.h |   15 --
 drivers/net/wireless/ath/ath9k/main.c   |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c   |  248 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/xmit.c   |    6 +-
 5 files changed, 248 insertions(+), 282 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 4d775ae..2a3f835 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -27,265 +27,6 @@ MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Shared library for Atheros wireless 802.11n LAN cards.");
 MODULE_LICENSE("Dual BSD/GPL");
 
-/* Common RX processing */
-
-/* Assumes you've already done the endian to CPU conversion */
-static bool ath9k_rx_accept(struct ath_common *common,
-			    struct sk_buff *skb,
-			    struct ieee80211_rx_status *rxs,
-			    struct ath_rx_status *rx_stats,
-			    bool *decrypt_error)
-{
-	struct ath_hw *ah = common->ah;
-	struct ieee80211_hdr *hdr;
-	__le16 fc;
-
-	hdr = (struct ieee80211_hdr *) skb->data;
-	fc = hdr->frame_control;
-
-	if (!rx_stats->rs_datalen)
-		return false;
-        /*
-         * rs_status follows rs_datalen so if rs_datalen is too large
-         * we can take a hint that hardware corrupted it, so ignore
-         * those frames.
-         */
-	if (rx_stats->rs_datalen > common->rx_bufsize)
-		return false;
-
-	/*
-	 * rs_more indicates chained descriptors which can be used
-	 * to link buffers together for a sort of scatter-gather
-	 * operation.
-	 *
-	 * The rx_stats->rs_status will not be set until the end of the
-	 * chained descriptors so it can be ignored if rs_more is set. The
-	 * rs_more will be false at the last element of the chained
-	 * descriptors.
-	 */
-	if (!rx_stats->rs_more && rx_stats->rs_status != 0) {
-		if (rx_stats->rs_status & ATH9K_RXERR_CRC)
-			rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
-		if (rx_stats->rs_status & ATH9K_RXERR_PHY)
-			return false;
-
-		if (rx_stats->rs_status & ATH9K_RXERR_DECRYPT) {
-			*decrypt_error = true;
-		} else if (rx_stats->rs_status & ATH9K_RXERR_MIC) {
-			if (ieee80211_is_ctl(fc))
-				/*
-				 * Sometimes, we get invalid
-				 * MIC failures on valid control frames.
-				 * Remove these mic errors.
-				 */
-				rx_stats->rs_status &= ~ATH9K_RXERR_MIC;
-			else
-				rxs->flag |= RX_FLAG_MMIC_ERROR;
-		}
-		/*
-		 * Reject error frames with the exception of
-		 * decryption and MIC failures. For monitor mode,
-		 * we also ignore the CRC error.
-		 */
-		if (ah->opmode == NL80211_IFTYPE_MONITOR) {
-			if (rx_stats->rs_status &
-			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
-			      ATH9K_RXERR_CRC))
-				return false;
-		} else {
-			if (rx_stats->rs_status &
-			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC)) {
-				return false;
-			}
-		}
-	}
-	return true;
-}
-
-static u8 ath9k_process_rate(struct ath_common *common,
-			     struct ieee80211_hw *hw,
-			     struct ath_rx_status *rx_stats,
-			     struct ieee80211_rx_status *rxs,
-			     struct sk_buff *skb)
-{
-	struct ieee80211_supported_band *sband;
-	enum ieee80211_band band;
-	unsigned int i = 0;
-
-	band = hw->conf.channel->band;
-	sband = hw->wiphy->bands[band];
-
-	if (rx_stats->rs_rate & 0x80) {
-		/* HT rate */
-		rxs->flag |= RX_FLAG_HT;
-		if (rx_stats->rs_flags & ATH9K_RX_2040)
-			rxs->flag |= RX_FLAG_40MHZ;
-		if (rx_stats->rs_flags & ATH9K_RX_GI)
-			rxs->flag |= RX_FLAG_SHORT_GI;
-		return rx_stats->rs_rate & 0x7f;
-	}
-
-	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sband->bitrates[i].hw_value == rx_stats->rs_rate)
-			return i;
-		if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
-			rxs->flag |= RX_FLAG_SHORTPRE;
-			return i;
-		}
-	}
-
-	/* No valid hardware bitrate found -- we should not get here */
-	ath_print(common, ATH_DBG_XMIT, "unsupported hw bitrate detected "
-		  "0x%02x using 1 Mbit\n", rx_stats->rs_rate);
-	if ((common->debug_mask & ATH_DBG_XMIT))
-		print_hex_dump_bytes("", DUMP_PREFIX_NONE, skb->data, skb->len);
-
-        return 0;
-}
-
-static void ath9k_process_rssi(struct ath_common *common,
-			       struct ieee80211_hw *hw,
-			       struct sk_buff *skb,
-			       struct ath_rx_status *rx_stats)
-{
-	struct ath_hw *ah = common->ah;
-	struct ieee80211_sta *sta;
-	struct ieee80211_hdr *hdr;
-	struct ath_node *an;
-	int last_rssi = ATH_RSSI_DUMMY_MARKER;
-	__le16 fc;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-
-	rcu_read_lock();
-	/*
-	 * XXX: use ieee80211_find_sta! This requires quite a bit of work
-	 * under the current ath9k virtual wiphy implementation as we have
-	 * no way of tying a vif to wiphy. Typically vifs are attached to
-	 * at least one sdata of a wiphy on mac80211 but with ath9k virtual
-	 * wiphy you'd have to iterate over every wiphy and each sdata.
-	 */
-	sta = ieee80211_find_sta_by_hw(hw, hdr->addr2);
-	if (sta) {
-		an = (struct ath_node *) sta->drv_priv;
-		if (rx_stats->rs_rssi != ATH9K_RSSI_BAD &&
-		   !rx_stats->rs_moreaggr)
-			ATH_RSSI_LPF(an->last_rssi, rx_stats->rs_rssi);
-		last_rssi = an->last_rssi;
-	}
-	rcu_read_unlock();
-
-	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-		rx_stats->rs_rssi = ATH_EP_RND(last_rssi,
-					      ATH_RSSI_EP_MULTIPLIER);
-	if (rx_stats->rs_rssi < 0)
-		rx_stats->rs_rssi = 0;
-
-	/* Update Beacon RSSI, this is used by ANI. */
-	if (ieee80211_is_beacon(fc))
-		ah->stats.avgbrssi = rx_stats->rs_rssi;
-}
-
-/*
- * For Decrypt or Demic errors, we only mark packet status here and always push
- * up the frame up to let mac80211 handle the actual error case, be it no
- * decryption key or real decryption error. This let us keep statistics there.
- */
-int ath9k_cmn_rx_skb_preprocess(struct ath_common *common,
-				struct ieee80211_hw *hw,
-				struct sk_buff *skb,
-				struct ath_rx_status *rx_stats,
-				struct ieee80211_rx_status *rx_status,
-				bool *decrypt_error)
-{
-	struct ath_hw *ah = common->ah;
-
-	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
-	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
-		return -EINVAL;
-
-	ath9k_process_rssi(common, hw, skb, rx_stats);
-
-	rx_status->rate_idx = ath9k_process_rate(common, hw,
-						 rx_stats, rx_status, skb);
-	rx_status->mactime = ath9k_hw_extend_tsf(ah, rx_stats->rs_tstamp);
-	rx_status->band = hw->conf.channel->band;
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->noise = common->ani.noise_floor;
-	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
-	rx_status->antenna = rx_stats->rs_antenna;
-	rx_status->flag |= RX_FLAG_TSFT;
-
-	return 0;
-}
-EXPORT_SYMBOL(ath9k_cmn_rx_skb_preprocess);
-
-void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
-				  struct sk_buff *skb,
-				  struct ath_rx_status *rx_stats,
-				  struct ieee80211_rx_status *rxs,
-				  bool decrypt_error)
-{
-	struct ath_hw *ah = common->ah;
-	struct ieee80211_hdr *hdr;
-	int hdrlen, padpos, padsize;
-	u8 keyix;
-	__le16 fc;
-
-	/* see if any padding is done by the hw and remove it */
-	hdr = (struct ieee80211_hdr *) skb->data;
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	fc = hdr->frame_control;
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
-
-	/* The MAC header is padded to have 32-bit boundary if the
-	 * packet payload is non-zero. The general calculation for
-	 * padsize would take into account odd header lengths:
-	 * padsize = (4 - padpos % 4) % 4; However, since only
-	 * even-length headers are used, padding can only be 0 or 2
-	 * bytes and we can optimize this a bit. In addition, we must
-	 * not try to remove padding from short control frames that do
-	 * not have payload. */
-	padsize = padpos & 3;
-	if (padsize && skb->len>=padpos+padsize+FCS_LEN) {
-		memmove(skb->data + padsize, skb->data, padpos);
-		skb_pull(skb, padsize);
-	}
-
-	keyix = rx_stats->rs_keyix;
-
-	if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error) {
-		rxs->flag |= RX_FLAG_DECRYPTED;
-	} else if (ieee80211_has_protected(fc)
-		   && !decrypt_error && skb->len >= hdrlen + 4) {
-		keyix = skb->data[hdrlen + 3] >> 6;
-
-		if (test_bit(keyix, common->keymap))
-			rxs->flag |= RX_FLAG_DECRYPTED;
-	}
-	if (ah->sw_mgmt_crypto &&
-	    (rxs->flag & RX_FLAG_DECRYPTED) &&
-	    ieee80211_is_mgmt(fc))
-		/* Use software decrypt for management frames. */
-		rxs->flag &= ~RX_FLAG_DECRYPTED;
-}
-EXPORT_SYMBOL(ath9k_cmn_rx_skb_postprocess);
-
-int ath9k_cmn_padpos(__le16 frame_control)
-{
-	int padpos = 24;
-	if (ieee80211_has_a4(frame_control)) {
-		padpos += ETH_ALEN;
-	}
-	if (ieee80211_is_data_qos(frame_control)) {
-		padpos += IEEE80211_QOS_CTL_LEN;
-	}
-
-	return padpos;
-}
-EXPORT_SYMBOL(ath9k_cmn_padpos);
-
 static int __init ath9k_cmn_init(void)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 042999c..475fb14 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -110,18 +110,3 @@ struct ath_node {
 	u8 mpdudensity;
 	int last_rssi;
 };
-
-int ath9k_cmn_rx_skb_preprocess(struct ath_common *common,
-				struct ieee80211_hw *hw,
-				struct sk_buff *skb,
-				struct ath_rx_status *rx_stats,
-				struct ieee80211_rx_status *rx_status,
-				bool *decrypt_error);
-
-void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
-				  struct sk_buff *skb,
-				  struct ath_rx_status *rx_stats,
-				  struct ieee80211_rx_status *rxs,
-				  bool decrypt_error);
-
-int ath9k_cmn_padpos(__le16 frame_control);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 050baf2..9253b79 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1208,7 +1208,7 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	}
 
 	/* Add the padding after the header if this is not already done */
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padpos = ath9k_padpos(hdr->frame_control);
 	padsize = padpos & 3;
 	if (padsize && skb->len>padpos) {
 		if (skb_headroom(skb) < padsize)
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 1ca42e5..a6d347f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -469,6 +469,246 @@ static void ath_rx_send_to_mac80211(struct ieee80211_hw *hw,
 		ieee80211_rx(hw, skb);
 }
 
+static u8 ath9k_processrate(struct ath_common *common,
+			    struct ieee80211_hw *hw,
+			    struct ath_rx_status *rx_stats,
+			    struct ieee80211_rx_status *rxs,
+			    struct sk_buff *skb)
+{
+	struct ieee80211_supported_band *sband;
+	enum ieee80211_band band;
+	unsigned int i = 0;
+
+	band = hw->conf.channel->band;
+	sband = hw->wiphy->bands[band];
+
+	if (rx_stats->rs_rate & 0x80) {
+		/* HT rate */
+		rxs->flag |= RX_FLAG_HT;
+		if (rx_stats->rs_flags & ATH9K_RX_2040)
+			rxs->flag |= RX_FLAG_40MHZ;
+		if (rx_stats->rs_flags & ATH9K_RX_GI)
+			rxs->flag |= RX_FLAG_SHORT_GI;
+		return rx_stats->rs_rate & 0x7f;
+	}
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if (sband->bitrates[i].hw_value == rx_stats->rs_rate)
+			return i;
+		if (sband->bitrates[i].hw_value_short == rx_stats->rs_rate) {
+			rxs->flag |= RX_FLAG_SHORTPRE;
+			return i;
+		}
+	}
+
+	/* No valid hardware bitrate found -- we should not get here */
+	ath_print(common, ATH_DBG_XMIT, "unsupported hw bitrate detected "
+		  "0x%02x using 1 Mbit\n", rx_stats->rs_rate);
+	if ((common->debug_mask & ATH_DBG_XMIT))
+		print_hex_dump_bytes("", DUMP_PREFIX_NONE, skb->data, skb->len);
+
+        return 0;
+}
+
+static void ath9k_process_rssi(struct ath_common *common,
+			       struct ieee80211_hw *hw,
+			       struct sk_buff *skb,
+			       struct ath_rx_status *rx_stats)
+{
+	struct ath_hw *ah = common->ah;
+	struct ieee80211_sta *sta;
+	struct ieee80211_hdr *hdr;
+	struct ath_node *an;
+	int last_rssi = ATH_RSSI_DUMMY_MARKER;
+	__le16 fc;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+
+	rcu_read_lock();
+	/*
+	 * XXX: use ieee80211_find_sta! This requires quite a bit of work
+	 * under the current ath9k virtual wiphy implementation as we have
+	 * no way of tying a vif to wiphy. Typically vifs are attached to
+	 * at least one sdata of a wiphy on mac80211 but with ath9k virtual
+	 * wiphy you'd have to iterate over every wiphy and each sdata.
+	 */
+	sta = ieee80211_find_sta_by_hw(hw, hdr->addr2);
+	if (sta) {
+		an = (struct ath_node *) sta->drv_priv;
+		if (rx_stats->rs_rssi != ATH9K_RSSI_BAD &&
+		   !rx_stats->rs_moreaggr)
+			ATH_RSSI_LPF(an->last_rssi, rx_stats->rs_rssi);
+		last_rssi = an->last_rssi;
+	}
+	rcu_read_unlock();
+
+	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
+		rx_stats->rs_rssi = ATH_EP_RND(last_rssi,
+					      ATH_RSSI_EP_MULTIPLIER);
+	if (rx_stats->rs_rssi < 0)
+		rx_stats->rs_rssi = 0;
+
+	/* Update Beacon RSSI, this is used by ANI. */
+	if (ieee80211_is_beacon(fc))
+		ah->stats.avgbrssi = rx_stats->rs_rssi;
+}
+
+static bool ath9k_rx_accept(struct ath_common *common,
+			    struct sk_buff *skb,
+			    struct ieee80211_rx_status *rxs,
+			    struct ath_rx_status *rx_stats,
+			    bool *decrypt_error)
+{
+	struct ath_hw *ah = common->ah;
+	struct ieee80211_hdr *hdr;
+	__le16 fc;
+
+	hdr = (struct ieee80211_hdr *) skb->data;
+	fc = hdr->frame_control;
+
+	if (!rx_stats->rs_datalen)
+		return false;
+        /*
+         * rs_status follows rs_datalen so if rs_datalen is too large
+         * we can take a hint that hardware corrupted it, so ignore
+         * those frames.
+         */
+	if (rx_stats->rs_datalen > common->rx_bufsize)
+		return false;
+
+	/*
+	 * rs_more indicates chained descriptors which can be used
+	 * to link buffers together for a sort of scatter-gather
+	 * operation.
+	 *
+	 * The rx_stats->rs_status will not be set until the end of the
+	 * chained descriptors so it can be ignored if rs_more is set. The
+	 * rs_more will be false at the last element of the chained
+	 * descriptors.
+	 */
+	if (!rx_stats->rs_more && rx_stats->rs_status != 0) {
+		if (rx_stats->rs_status & ATH9K_RXERR_CRC)
+			rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
+		if (rx_stats->rs_status & ATH9K_RXERR_PHY)
+			return false;
+
+		if (rx_stats->rs_status & ATH9K_RXERR_DECRYPT) {
+			*decrypt_error = true;
+		} else if (rx_stats->rs_status & ATH9K_RXERR_MIC) {
+			if (ieee80211_is_ctl(fc))
+				/*
+				 * Sometimes, we get invalid
+				 * MIC failures on valid control frames.
+				 * Remove these mic errors.
+				 */
+				rx_stats->rs_status &= ~ATH9K_RXERR_MIC;
+			else
+				rxs->flag |= RX_FLAG_MMIC_ERROR;
+		}
+		/*
+		 * Reject error frames with the exception of
+		 * decryption and MIC failures. For monitor mode,
+		 * we also ignore the CRC error.
+		 */
+		if (ah->opmode == NL80211_IFTYPE_MONITOR) {
+			if (rx_stats->rs_status &
+			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
+			      ATH9K_RXERR_CRC))
+				return false;
+		} else {
+			if (rx_stats->rs_status &
+			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC)) {
+				return false;
+			}
+		}
+	}
+	return true;
+}
+
+/*
+ * For Decrypt or Demic errors, we only mark packet status here and always push
+ * up the frame up to let mac80211 handle the actual error case, be it no
+ * decryption key or real decryption error. This let us keep statistics there.
+ */
+static int ath9k_rx_skb_preprocess(struct ath_common *common,
+				   struct ieee80211_hw *hw,
+				   struct sk_buff *skb,
+				   struct ath_rx_status *rx_stats,
+				   struct ieee80211_rx_status *rx_status,
+				   bool *decrypt_error)
+{
+	struct ath_hw *ah = common->ah;
+
+	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
+	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
+		return -EINVAL;
+
+	ath9k_process_rssi(common, hw, skb, rx_stats);
+
+	rx_status->rate_idx = ath9k_processrate(common, hw,
+						rx_stats, rx_status, skb);
+	rx_status->mactime = ath9k_hw_extend_tsf(ah, rx_stats->rs_tstamp);
+	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.channel->center_freq;
+	rx_status->noise = common->ani.noise_floor;
+	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
+	rx_status->antenna = rx_stats->rs_antenna;
+	rx_status->flag |= RX_FLAG_TSFT;
+
+	return 0;
+}
+
+static void ath9k_rx_skb_postprocess(struct ath_common *common,
+				     struct sk_buff *skb,
+				     struct ath_rx_status *rx_stats,
+				     struct ieee80211_rx_status *rxs,
+				     bool decrypt_error)
+{
+	struct ath_hw *ah = common->ah;
+	struct ieee80211_hdr *hdr;
+	int hdrlen, padpos, padsize;
+	u8 keyix;
+	__le16 fc;
+
+	/* see if any padding is done by the hw and remove it */
+	hdr = (struct ieee80211_hdr *) skb->data;
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	fc = hdr->frame_control;
+	padpos = ath9k_padpos(hdr->frame_control);
+
+	/* The MAC header is padded to have 32-bit boundary if the
+	 * packet payload is non-zero. The general calculation for
+	 * padsize would take into account odd header lengths:
+	 * padsize = (4 - padpos % 4) % 4; However, since only
+	 * even-length headers are used, padding can only be 0 or 2
+	 * bytes and we can optimize this a bit. In addition, we must
+	 * not try to remove padding from short control frames that do
+	 * not have payload. */
+	padsize = padpos & 3;
+	if (padsize && skb->len>=padpos+padsize+FCS_LEN) {
+		memmove(skb->data + padsize, skb->data, padpos);
+		skb_pull(skb, padsize);
+	}
+
+	keyix = rx_stats->rs_keyix;
+
+	if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error) {
+		rxs->flag |= RX_FLAG_DECRYPTED;
+	} else if (ieee80211_has_protected(fc)
+		   && !decrypt_error && skb->len >= hdrlen + 4) {
+		keyix = skb->data[hdrlen + 3] >> 6;
+
+		if (test_bit(keyix, common->keymap))
+			rxs->flag |= RX_FLAG_DECRYPTED;
+	}
+	if (ah->sw_mgmt_crypto &&
+	    (rxs->flag & RX_FLAG_DECRYPTED) &&
+	    ieee80211_is_mgmt(fc))
+		/* Use software decrypt for management frames. */
+		rxs->flag &= ~RX_FLAG_DECRYPTED;
+}
+
 int ath_rx_tasklet(struct ath_softc *sc, int flush)
 {
 #define PA2DESC(_sc, _pa)                                               \
@@ -580,8 +820,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		if (flush)
 			goto requeue;
 
-		retval = ath9k_cmn_rx_skb_preprocess(common, hw, skb, rx_stats,
-						     rxs, &decrypt_error);
+		retval = ath9k_rx_skb_preprocess(common, hw, skb, rx_stats,
+						 rxs, &decrypt_error);
 		if (retval)
 			goto requeue;
 
@@ -603,8 +843,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		skb_put(skb, rx_stats->rs_datalen);
 
-		ath9k_cmn_rx_skb_postprocess(common, skb, rx_stats,
-					     rxs, decrypt_error);
+		ath9k_rx_skb_postprocess(common, skb, rx_stats,
+					 rxs, decrypt_error);
 
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 47294f9..fc0b92c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1604,7 +1604,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 	bf->aphy = aphy;
 	bf->bf_frmlen = skb->len + FCS_LEN;
 	/* Remove the padding size from bf_frmlen, if any */
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padpos = ath9k_padpos(hdr->frame_control);
 	padsize = padpos & 3;
 	if (padsize && skb->len>padpos+padsize) {
 		bf->bf_frmlen -= padsize;
@@ -1788,7 +1788,7 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 
 	/* Add the padding after the header if this is not already done */
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padpos = ath9k_padpos(hdr->frame_control);
 	padsize = padpos & 3;
 	if (padsize && skb->len>padpos) {
 		if (skb_headroom(skb) < padsize) {
@@ -1842,7 +1842,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padpos = ath9k_padpos(hdr->frame_control);
 	padsize = padpos & 3;
 	if (padsize && skb->len>padpos+padsize) {
 		/*
-- 
1.7.0.1

