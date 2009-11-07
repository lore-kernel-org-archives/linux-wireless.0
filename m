Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 12/29] ath9k: use the ieee80211_hw to get to an sband on ath_rx_prepare()
Date: Sat,  7 Nov 2009 15:18:49 -0500
Message-Id: <1257625146-17971-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to use the private driver structure to get to an sband.
This will make it easier to share this code with ath9k_htc.

With the sc gone we can now just pass the common structure to
ath_rx_prepare().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   39 +++++++++++++++++----------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 403debb..fa78914 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -91,18 +91,19 @@ static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
  * up the frame up to let mac80211 handle the actual error case, be it no
  * decryption key or real decryption error. This let us keep statistics there.
  */
-static int ath_rx_prepare(struct ieee80211_hw *hw,
+static int ath_rx_prepare(struct ath_common *common,
+			  struct ieee80211_hw *hw,
 			  struct sk_buff *skb, struct ath_rx_status *rx_stats,
-			  struct ieee80211_rx_status *rx_status, bool *decrypt_error,
-			  struct ath_softc *sc)
+			  struct ieee80211_rx_status *rx_status,
+			  bool *decrypt_error)
 {
+	struct ath_hw *ah = common->ah;
 	struct ieee80211_hdr *hdr;
 	u8 ratecode;
 	__le16 fc;
 	struct ieee80211_sta *sta;
 	struct ath_node *an;
 	int last_rssi = ATH_RSSI_DUMMY_MARKER;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
@@ -115,7 +116,7 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 		 * discard the frame. Enable this if you want to see
 		 * error frames in Monitor mode.
 		 */
-		if (sc->sc_ah->opmode != NL80211_IFTYPE_MONITOR)
+		if (ah->opmode != NL80211_IFTYPE_MONITOR)
 			goto rx_next;
 	} else if (rx_stats->rs_status != 0) {
 		if (rx_stats->rs_status & ATH9K_RXERR_CRC)
@@ -141,7 +142,7 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 		 * decryption and MIC failures. For monitor mode,
 		 * we also ignore the CRC error.
 		 */
-		if (sc->sc_ah->opmode == NL80211_IFTYPE_MONITOR) {
+		if (ah->opmode == NL80211_IFTYPE_MONITOR) {
 			if (rx_stats->rs_status &
 			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
 			      ATH9K_RXERR_CRC))
@@ -165,20 +166,20 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 			rx_status->flag |= RX_FLAG_SHORT_GI;
 		rx_status->rate_idx = ratecode & 0x7f;
 	} else {
-		int i = 0, cur_band, n_rates;
+		struct ieee80211_supported_band *sband;
+		unsigned int i = 0;
+		enum ieee80211_band band;
 
-		cur_band = hw->conf.channel->band;
-		n_rates = sc->sbands[cur_band].n_bitrates;
+		band = hw->conf.channel->band;
+		sband = hw->wiphy->bands[band];
 
-		for (i = 0; i < n_rates; i++) {
-			if (sc->sbands[cur_band].bitrates[i].hw_value ==
-			    ratecode) {
+		for (i = 0; i < sband->n_bitrates; i++) {
+			if (sband->bitrates[i].hw_value == rx_stats->rs_rate) {
 				rx_status->rate_idx = i;
 				break;
 			}
-
-			if (sc->sbands[cur_band].bitrates[i].hw_value_short ==
-			    ratecode) {
+			if (sband->bitrates[i].hw_value_short ==
+			    rx_stats->rs_rate) {
 				rx_status->rate_idx = i;
 				rx_status->flag |= RX_FLAG_SHORTPRE;
 				break;
@@ -208,9 +209,9 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 
 	/* Update Beacon RSSI, this is used by ANI. */
 	if (ieee80211_is_beacon(fc))
-		sc->sc_ah->stats.avgbrssi = rx_stats->rs_rssi;
+		ah->stats.avgbrssi = rx_stats->rs_rssi;
 
-	rx_status->mactime = ath9k_hw_extend_tsf(sc->sc_ah, rx_stats->rs_tstamp);
+	rx_status->mactime = ath9k_hw_extend_tsf(ah, rx_stats->rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->noise = common->ani.noise_floor;
@@ -754,8 +755,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		if (sc->rx.bufsize < rx_stats->rs_datalen)
 			goto requeue;
 
-		if (!ath_rx_prepare(hw, skb, rx_stats,
-				    &rx_status, &decrypt_error, sc))
+		if (!ath_rx_prepare(common, hw, skb, rx_stats,
+				    &rx_status, &decrypt_error))
 			goto requeue;
 
 		/* Ensure we always have an skb to requeue once we are done
-- 
1.6.5.2.143.g8cc62

