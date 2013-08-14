Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:37634 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759083Ab3HNDpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 23:45:08 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/14] ath9k: Discard invalid frames early
Date: Wed, 14 Aug 2013 09:11:11 +0530
Message-Id: <1376451682-25862-3-git-send-email-sujith@msujith.org> (sfid-20130814_054516_657248_566EC036)
In-Reply-To: <1376451682-25862-1-git-send-email-sujith@msujith.org>
References: <1376451682-25862-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Frames with invalid or zero length can be discarded
early, there is no need to check the crypto bits.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 38 ++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 83b3fc5..f8cc2b3 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -764,7 +764,6 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	bool is_mc, is_valid_tkip, strip_mic, mic_error;
 	struct ath_hw *ah = common->ah;
 	__le16 fc;
-	u8 rx_status_len = ah->caps.rx_status_len;
 
 	fc = hdr->frame_control;
 
@@ -786,21 +785,6 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	    !test_bit(rx_stats->rs_keyix, common->ccmp_keymap))
 		rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
 
-	if (!rx_stats->rs_datalen) {
-		RX_STAT_INC(rx_len_err);
-		return false;
-	}
-
-        /*
-         * rs_status follows rs_datalen so if rs_datalen is too large
-         * we can take a hint that hardware corrupted it, so ignore
-         * those frames.
-         */
-	if (rx_stats->rs_datalen > (common->rx_bufsize - rx_status_len)) {
-		RX_STAT_INC(rx_len_err);
-		return false;
-	}
-
 	/* Only use error bits from the last fragment */
 	if (rx_stats->rs_more)
 		return true;
@@ -949,11 +933,33 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	struct ath_common *common = ath9k_hw_common(ah);
 	bool discard_current = sc->rx.discard_next;
 
+	/*
+	 * Discard corrupt descriptors which are marked in
+	 * ath_get_next_rx_buf().
+	 */
 	sc->rx.discard_next = rx_stats->rs_more;
 	if (discard_current)
 		return -EINVAL;
 
 	/*
+	 * Discard zero-length packets.
+	 */
+	if (!rx_stats->rs_datalen) {
+		RX_STAT_INC(rx_len_err);
+		return -EINVAL;
+	}
+
+        /*
+         * rs_status follows rs_datalen so if rs_datalen is too large
+         * we can take a hint that hardware corrupted it, so ignore
+         * those frames.
+         */
+	if (rx_stats->rs_datalen > (common->rx_bufsize - ah->caps.rx_status_len)) {
+		RX_STAT_INC(rx_len_err);
+		return -EINVAL;
+	}
+
+	/*
 	 * everything but the rate is checked here, the rate check is done
 	 * separately to avoid doing two lookups for a rate for each frame.
 	 */
-- 
1.8.3.4

