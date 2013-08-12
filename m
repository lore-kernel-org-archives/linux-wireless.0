Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:39772 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab3HLJpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 05:45:43 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 14/15] ath9k: Fix error condition for corrupt descriptors
Date: Mon, 12 Aug 2013 15:11:41 +0530
Message-Id: <1376300502-2741-15-git-send-email-sujith@msujith.org> (sfid-20130812_120909_317348_DA17BF5F)
In-Reply-To: <1376300502-2741-1-git-send-email-sujith@msujith.org>
References: <1376300502-2741-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

In case a descriptor has the "done" bit clear and the
next descriptor has it set, we drop both of them. If
the packet that is received after these two packets
is dropped for some reason, "discard_next" will not cleared.
Fix this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0965bf6..a00e1b6 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1068,6 +1068,7 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_hdr *hdr;
 	bool discard_current = sc->rx.discard_next;
+	int ret = 0;
 
 	/*
 	 * Discard corrupt descriptors which are marked in
@@ -1106,8 +1107,10 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 * This is different from the other corrupt descriptor
 	 * condition handled above.
 	 */
-	if (rx_stats->rs_status & ATH9K_RXERR_CORRUPT_DESC)
-		return -EINVAL;
+	if (rx_stats->rs_status & ATH9K_RXERR_CORRUPT_DESC) {
+		ret = -EINVAL;
+		goto exit;
+	}
 
 	hdr = (struct ieee80211_hdr *) (skb->data + ah->caps.rx_status_len);
 
@@ -1123,18 +1126,23 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		if (ath_process_fft(sc, hdr, rx_stats, rx_status->mactime))
 			RX_STAT_INC(rx_spectral);
 
-		return -EINVAL;
+		ret = -EINVAL;
+		goto exit;
 	}
 
 	/*
 	 * everything but the rate is checked here, the rate check is done
 	 * separately to avoid doing two lookups for a rate for each frame.
 	 */
-	if (!ath9k_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error))
-		return -EINVAL;
+	if (!ath9k_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error)) {
+		ret = -EINVAL;
+		goto exit;
+	}
 
-	if (ath9k_process_rate(common, hw, rx_stats, rx_status))
-		return -EINVAL;
+	if (ath9k_process_rate(common, hw, rx_stats, rx_status)) {
+		ret = -EINVAL;
+		goto exit;
+	}
 
 	rx_stats->is_mybeacon = ath9k_is_mybeacon(sc, hdr);
 	if (rx_stats->is_mybeacon) {
@@ -1152,15 +1160,15 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	if (rx_stats->rs_moreaggr)
 		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
-	sc->rx.discard_next = false;
-
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	if (ieee80211_is_data_present(hdr->frame_control) &&
 	    !ieee80211_is_qos_nullfunc(hdr->frame_control))
 		sc->rx.num_pkts++;
 #endif
 
-	return 0;
+exit:
+	sc->rx.discard_next = false;
+	return ret;
 }
 
 static void ath9k_rx_skb_postprocess(struct ath_common *common,
-- 
1.8.3.4

