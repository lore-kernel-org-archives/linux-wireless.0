Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42840 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbaBYKYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 05:24:04 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.14 2/2] ath9k: fix invalid descriptor discarding
Date: Mon, 24 Feb 2014 22:26:06 +0100
Message-Id: <1393277166-28356-2-git-send-email-nbd@openwrt.org> (sfid-20140225_112433_943952_694446F1)
In-Reply-To: <1393277166-28356-1-git-send-email-nbd@openwrt.org>
References: <1393277166-28356-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only set sc->rx.discard_next to rx_stats->rs_more when actually
discarding the current descriptor.

Also, fix a detection of broken descriptors:
First the code checks if the current descriptor is not done.
Then it checks if the next descriptor is done.
Add a check that afterwards checks the first descriptor again, because
it might have been completed in the mean time.

This fixes a regression introduced in
commit 723e711356b5a8a95728a890e254e8b0d47b55cf
"ath9k: fix handling of broken descriptors"

Cc: stable@vger.kernel.org
Reported-by: Marco André Dinis <marcoandredinis@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c | 70 +++++++++++++++++------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a0ebdd0..82e340d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -732,11 +732,18 @@ static struct ath_rxbuf *ath_get_next_rx_buf(struct ath_softc *sc,
 			return NULL;
 
 		/*
-		 * mark descriptor as zero-length and set the 'more'
-		 * flag to ensure that both buffers get discarded
+		 * Re-check previous descriptor, in case it has been filled
+		 * in the mean time.
 		 */
-		rs->rs_datalen = 0;
-		rs->rs_more = true;
+		ret = ath9k_hw_rxprocdesc(ah, ds, rs);
+		if (ret == -EINPROGRESS) {
+			/*
+			 * mark descriptor as zero-length and set the 'more'
+			 * flag to ensure that both buffers get discarded
+			 */
+			rs->rs_datalen = 0;
+			rs->rs_more = true;
+		}
 	}
 
 	list_del(&bf->list);
@@ -985,32 +992,32 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_hdr *hdr;
 	bool discard_current = sc->rx.discard_next;
-	int ret = 0;
 
 	/*
 	 * Discard corrupt descriptors which are marked in
 	 * ath_get_next_rx_buf().
 	 */
-	sc->rx.discard_next = rx_stats->rs_more;
 	if (discard_current)
-		return -EINVAL;
+		goto corrupt;
+
+	sc->rx.discard_next = false;
 
 	/*
 	 * Discard zero-length packets.
 	 */
 	if (!rx_stats->rs_datalen) {
 		RX_STAT_INC(rx_len_err);
-		return -EINVAL;
+		goto corrupt;
 	}
 
-        /*
-         * rs_status follows rs_datalen so if rs_datalen is too large
-         * we can take a hint that hardware corrupted it, so ignore
-         * those frames.
-         */
+	/*
+	 * rs_status follows rs_datalen so if rs_datalen is too large
+	 * we can take a hint that hardware corrupted it, so ignore
+	 * those frames.
+	 */
 	if (rx_stats->rs_datalen > (common->rx_bufsize - ah->caps.rx_status_len)) {
 		RX_STAT_INC(rx_len_err);
-		return -EINVAL;
+		goto corrupt;
 	}
 
 	/* Only use status info from the last fragment */
@@ -1024,10 +1031,8 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 * This is different from the other corrupt descriptor
 	 * condition handled above.
 	 */
-	if (rx_stats->rs_status & ATH9K_RXERR_CORRUPT_DESC) {
-		ret = -EINVAL;
-		goto exit;
-	}
+	if (rx_stats->rs_status & ATH9K_RXERR_CORRUPT_DESC)
+		goto corrupt;
 
 	hdr = (struct ieee80211_hdr *) (skb->data + ah->caps.rx_status_len);
 
@@ -1043,18 +1048,15 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		if (ath_process_fft(sc, hdr, rx_stats, rx_status->mactime))
 			RX_STAT_INC(rx_spectral);
 
-		ret = -EINVAL;
-		goto exit;
+		return -EINVAL;
 	}
 
 	/*
 	 * everything but the rate is checked here, the rate check is done
 	 * separately to avoid doing two lookups for a rate for each frame.
 	 */
-	if (!ath9k_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error)) {
-		ret = -EINVAL;
-		goto exit;
-	}
+	if (!ath9k_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error))
+		return -EINVAL;
 
 	if (ath_is_mybeacon(common, hdr)) {
 		RX_STAT_INC(rx_beacons);
@@ -1064,15 +1066,11 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	/*
 	 * This shouldn't happen, but have a safety check anyway.
 	 */
-	if (WARN_ON(!ah->curchan)) {
-		ret = -EINVAL;
-		goto exit;
-	}
+	if (WARN_ON(!ah->curchan))
+		return -EINVAL;
 
-	if (ath9k_process_rate(common, hw, rx_stats, rx_status)) {
-		ret =-EINVAL;
-		goto exit;
-	}
+	if (ath9k_process_rate(common, hw, rx_stats, rx_status))
+		return -EINVAL;
 
 	ath9k_process_rssi(common, hw, rx_stats, rx_status);
 
@@ -1087,9 +1085,11 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		sc->rx.num_pkts++;
 #endif
 
-exit:
-	sc->rx.discard_next = false;
-	return ret;
+	return 0;
+
+corrupt:
+	sc->rx.discard_next = rx_stats->rs_more;
+	return -EINVAL;
 }
 
 static void ath9k_rx_skb_postprocess(struct ath_common *common,
-- 
1.8.3.4 (Apple Git-47)

