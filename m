Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59451 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbaBDJ21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 04:28:27 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0LptId-1VYnB01gvf-00ffeJ for
 <linux-wireless@vger.kernel.org>; Tue, 04 Feb 2014 10:28:25 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 04/13] ath9k: move ath9k_rx_accept to common.c
Date: Tue,  4 Feb 2014 10:27:41 +0100
Message-Id: <1391506070-8636-5-git-send-email-linux@rempel-privat.de> (sfid-20140204_102830_365578_54E5046C)
In-Reply-To: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
References: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we can reuse it on ath9k_htc

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/common.c | 88 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common.h |  6 +++
 drivers/net/wireless/ath/ath9k/recv.c   | 88 +--------------------------------
 3 files changed, 95 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 120fd46..5c0d949 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -27,6 +27,94 @@ MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Shared library for Atheros wireless 802.11n LAN cards.");
 MODULE_LICENSE("Dual BSD/GPL");
 
+/* Assumes you've already done the endian to CPU conversion */
+bool ath9k_cmn_rx_accept(struct ath_common *common,
+			 struct ieee80211_hdr *hdr,
+			 struct ieee80211_rx_status *rxs,
+			 struct ath_rx_status *rx_stats,
+			 bool *decrypt_error,
+			 unsigned int rxfilter)
+{
+	struct ath_hw *ah = common->ah;
+	bool is_mc, is_valid_tkip, strip_mic, mic_error;
+	__le16 fc;
+
+	fc = hdr->frame_control;
+
+	is_mc = !!is_multicast_ether_addr(hdr->addr1);
+	is_valid_tkip = rx_stats->rs_keyix != ATH9K_RXKEYIX_INVALID &&
+		test_bit(rx_stats->rs_keyix, common->tkip_keymap);
+	strip_mic = is_valid_tkip && ieee80211_is_data(fc) &&
+		ieee80211_has_protected(fc) &&
+		!(rx_stats->rs_status &
+		(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC |
+		 ATH9K_RXERR_KEYMISS));
+
+	/*
+	 * Key miss events are only relevant for pairwise keys where the
+	 * descriptor does contain a valid key index. This has been observed
+	 * mostly with CCMP encryption.
+	 */
+	if (rx_stats->rs_keyix == ATH9K_RXKEYIX_INVALID ||
+	    !test_bit(rx_stats->rs_keyix, common->ccmp_keymap))
+		rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
+
+	mic_error = is_valid_tkip && !ieee80211_is_ctl(fc) &&
+		!ieee80211_has_morefrags(fc) &&
+		!(le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG) &&
+		(rx_stats->rs_status & ATH9K_RXERR_MIC);
+
+	/*
+	 * The rx_stats->rs_status will not be set until the end of the
+	 * chained descriptors so it can be ignored if rs_more is set. The
+	 * rs_more will be false at the last element of the chained
+	 * descriptors.
+	 */
+	if (rx_stats->rs_status != 0) {
+		u8 status_mask;
+
+		if (rx_stats->rs_status & ATH9K_RXERR_CRC) {
+			rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
+			mic_error = false;
+		}
+
+		if ((rx_stats->rs_status & ATH9K_RXERR_DECRYPT) ||
+		    (!is_mc && (rx_stats->rs_status & ATH9K_RXERR_KEYMISS))) {
+			*decrypt_error = true;
+			mic_error = false;
+		}
+
+
+		/*
+		 * Reject error frames with the exception of
+		 * decryption and MIC failures. For monitor mode,
+		 * we also ignore the CRC error.
+		 */
+		status_mask = ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
+			      ATH9K_RXERR_KEYMISS;
+
+		if (ah->is_monitoring && (rxfilter & FIF_FCSFAIL))
+			status_mask |= ATH9K_RXERR_CRC;
+
+		if (rx_stats->rs_status & ~status_mask)
+			return false;
+	}
+
+	/*
+	 * For unicast frames the MIC error bit can have false positives,
+	 * so all MIC error reports need to be validated in software.
+	 * False negatives are not common, so skip software verification
+	 * if the hardware considers the MIC valid.
+	 */
+	if (strip_mic)
+		rxs->flag |= RX_FLAG_MMIC_STRIPPED;
+	else if (is_mc && mic_error)
+		rxs->flag |= RX_FLAG_MMIC_ERROR;
+
+	return true;
+}
+EXPORT_SYMBOL(ath9k_cmn_rx_accept);
+
 int ath9k_cmn_process_rate(struct ath_common *common,
 			   struct ieee80211_hw *hw,
 			   struct ath_rx_status *rx_stats,
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 729482f..c59d3f5 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -42,6 +42,12 @@
 #define ATH_EP_RND(x, mul) 						\
 	(((x) + ((mul)/2)) / (mul))
 
+bool ath9k_cmn_rx_accept(struct ath_common *common,
+			 struct ieee80211_hdr *hdr,
+			 struct ieee80211_rx_status *rxs,
+			 struct ath_rx_status *rx_stats,
+			 bool *decrypt_error,
+			 unsigned int rxfilter);
 int ath9k_cmn_process_rate(struct ath_common *common,
 			   struct ieee80211_hw *hw,
 			   struct ath_rx_status *rx_stats,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ab6a86c..4dedbc2 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -755,92 +755,6 @@ static struct ath_rxbuf *ath_get_next_rx_buf(struct ath_softc *sc,
 	return bf;
 }
 
-/* Assumes you've already done the endian to CPU conversion */
-static bool ath9k_rx_accept(struct ath_common *common,
-			    struct ieee80211_hdr *hdr,
-			    struct ieee80211_rx_status *rxs,
-			    struct ath_rx_status *rx_stats,
-			    bool *decrypt_error)
-{
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
-	bool is_mc, is_valid_tkip, strip_mic, mic_error;
-	struct ath_hw *ah = common->ah;
-	__le16 fc;
-
-	fc = hdr->frame_control;
-
-	is_mc = !!is_multicast_ether_addr(hdr->addr1);
-	is_valid_tkip = rx_stats->rs_keyix != ATH9K_RXKEYIX_INVALID &&
-		test_bit(rx_stats->rs_keyix, common->tkip_keymap);
-	strip_mic = is_valid_tkip && ieee80211_is_data(fc) &&
-		ieee80211_has_protected(fc) &&
-		!(rx_stats->rs_status &
-		(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC |
-		 ATH9K_RXERR_KEYMISS));
-
-	/*
-	 * Key miss events are only relevant for pairwise keys where the
-	 * descriptor does contain a valid key index. This has been observed
-	 * mostly with CCMP encryption.
-	 */
-	if (rx_stats->rs_keyix == ATH9K_RXKEYIX_INVALID ||
-	    !test_bit(rx_stats->rs_keyix, common->ccmp_keymap))
-		rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
-
-	mic_error = is_valid_tkip && !ieee80211_is_ctl(fc) &&
-		!ieee80211_has_morefrags(fc) &&
-		!(le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG) &&
-		(rx_stats->rs_status & ATH9K_RXERR_MIC);
-
-	/*
-	 * The rx_stats->rs_status will not be set until the end of the
-	 * chained descriptors so it can be ignored if rs_more is set. The
-	 * rs_more will be false at the last element of the chained
-	 * descriptors.
-	 */
-	if (rx_stats->rs_status != 0) {
-		u8 status_mask;
-
-		if (rx_stats->rs_status & ATH9K_RXERR_CRC) {
-			rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
-			mic_error = false;
-		}
-
-		if ((rx_stats->rs_status & ATH9K_RXERR_DECRYPT) ||
-		    (!is_mc && (rx_stats->rs_status & ATH9K_RXERR_KEYMISS))) {
-			*decrypt_error = true;
-			mic_error = false;
-		}
-
-		/*
-		 * Reject error frames with the exception of
-		 * decryption and MIC failures. For monitor mode,
-		 * we also ignore the CRC error.
-		 */
-		status_mask = ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
-			      ATH9K_RXERR_KEYMISS;
-
-		if (ah->is_monitoring && (sc->rx.rxfilter & FIF_FCSFAIL))
-			status_mask |= ATH9K_RXERR_CRC;
-
-		if (rx_stats->rs_status & ~status_mask)
-			return false;
-	}
-
-	/*
-	 * For unicast frames the MIC error bit can have false positives,
-	 * so all MIC error reports need to be validated in software.
-	 * False negatives are not common, so skip software verification
-	 * if the hardware considers the MIC valid.
-	 */
-	if (strip_mic)
-		rxs->flag |= RX_FLAG_MMIC_STRIPPED;
-	else if (is_mc && mic_error)
-		rxs->flag |= RX_FLAG_MMIC_ERROR;
-
-	return true;
-}
-
 static void ath9k_process_tsf(struct ath_rx_status *rs,
 			      struct ieee80211_rx_status *rxs,
 			      u64 tsf)
@@ -939,7 +853,7 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 * everything but the rate is checked here, the rate check is done
 	 * separately to avoid doing two lookups for a rate for each frame.
 	 */
-	if (!ath9k_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error)) {
+	if (!ath9k_cmn_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error, sc->rx.rxfilter)) {
 		ret = -EINVAL;
 		goto exit;
 	}
-- 
1.9.rc1

