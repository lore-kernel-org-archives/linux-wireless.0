Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50050 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427Ab3HNPtg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 11:49:36 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] ath9k: Handle invalid RSSI
Date: Wed, 14 Aug 2013 21:15:54 +0530
Message-Id: <1376495157-18983-1-git-send-email-sujith@msujith.org> (sfid-20130814_174945_365052_941B6199)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The combined RSSI can be invalid which is indicated by
the value -128. Use RX_FLAG_NO_SIGNAL_VAL for such cases.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 49 +++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 3b47198..6ad7d61 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -885,29 +885,49 @@ static int ath9k_process_rate(struct ath_common *common,
 
 static void ath9k_process_rssi(struct ath_common *common,
 			       struct ieee80211_hw *hw,
-			       struct ath_rx_status *rx_stats)
+			       struct ath_rx_status *rx_stats,
+			       struct ieee80211_rx_status *rxs)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = common->ah;
 	int last_rssi;
 	int rssi = rx_stats->rs_rssi;
 
-	if (!rx_stats->is_mybeacon ||
-	    ((ah->opmode != NL80211_IFTYPE_STATION) &&
-	     (ah->opmode != NL80211_IFTYPE_ADHOC)))
+	/*
+	 * RSSI is not available for subframes in an A-MPDU.
+	 */
+	if (rx_stats->rs_moreaggr) {
+		rxs->flag |= RX_FLAG_NO_SIGNAL_VAL;
+		return;
+	}
+
+	/*
+	 * Check if the RSSI for the last subframe in an A-MPDU
+	 * or an unaggregated frame is valid.
+	 */
+	if (rx_stats->rs_rssi == ATH9K_RSSI_BAD) {
+		rxs->flag |= RX_FLAG_NO_SIGNAL_VAL;
 		return;
+	}
 
-	if (rx_stats->rs_rssi != ATH9K_RSSI_BAD && !rx_stats->rs_moreaggr)
+	/*
+	 * Update Beacon RSSI, this is used by ANI.
+	 */
+	if (rx_stats->is_mybeacon &&
+	    ((ah->opmode == NL80211_IFTYPE_STATION) ||
+	     (ah->opmode == NL80211_IFTYPE_ADHOC))) {
 		ATH_RSSI_LPF(sc->last_rssi, rx_stats->rs_rssi);
+		last_rssi = sc->last_rssi;
+
+		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
+			rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
+		if (rssi < 0)
+			rssi = 0;
 
-	last_rssi = sc->last_rssi;
-	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-		rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
-	if (rssi < 0)
-		rssi = 0;
+		ah->stats.avgbrssi = rssi;
+	}
 
-	/* Update Beacon RSSI, this is used by ANI. */
-	ah->stats.avgbrssi = rssi;
+	rxs->signal = ah->noise + rx_stats->rs_rssi;
 }
 
 static void ath9k_process_tsf(struct ath_rx_status *rs,
@@ -1149,15 +1169,12 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		goto exit;
 	}
 
-	ath9k_process_rssi(common, hw, rx_stats);
+	ath9k_process_rssi(common, hw, rx_stats, rx_status);
 
 	rx_status->band = hw->conf.chandef.chan->band;
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
-	rx_status->signal = ah->noise + rx_stats->rs_rssi;
 	rx_status->antenna = rx_stats->rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_END;
-	if (rx_stats->rs_moreaggr)
-		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	if (ieee80211_is_data_present(hdr->frame_control) &&
-- 
1.8.3.4

