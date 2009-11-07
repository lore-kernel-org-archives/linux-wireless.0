Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56127 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 26/29] ath9k: move RX skb post processing to a helper
Date: Sat,  7 Nov 2009 15:19:03 -0500
Message-Id: <1257625146-17971-27-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a helper for the RX skb post processing,
ath9k_rx_skb_postprocess().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   89 +++++++++++++++++++--------------
 1 files changed, 52 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 3abefb5..8b7489d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -316,6 +316,55 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 	return 0;
 }
 
+static void ath9k_rx_skb_postprocess(struct ath_common *common,
+				     struct sk_buff *skb,
+				     struct ath_rx_status *rx_stats,
+				     struct ieee80211_rx_status *rxs,
+				     bool decrypt_error)
+{
+	struct ath_hw *ah = common->ah;
+	struct ieee80211_hdr *hdr;
+	int hdrlen, padsize;
+	u8 keyix;
+	__le16 fc;
+
+	/* see if any padding is done by the hw and remove it */
+	hdr = (struct ieee80211_hdr *) skb->data;
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	fc = hdr->frame_control;
+
+	/* The MAC header is padded to have 32-bit boundary if the
+	 * packet payload is non-zero. The general calculation for
+	 * padsize would take into account odd header lengths:
+	 * padsize = (4 - hdrlen % 4) % 4; However, since only
+	 * even-length headers are used, padding can only be 0 or 2
+	 * bytes and we can optimize this a bit. In addition, we must
+	 * not try to remove padding from short control frames that do
+	 * not have payload. */
+	padsize = hdrlen & 3;
+	if (padsize && hdrlen >= 24) {
+		memmove(skb->data + padsize, skb->data, hdrlen);
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
 static void ath_opmode_init(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -716,10 +765,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	 */
 	struct ieee80211_hw *hw = NULL;
 	struct ieee80211_hdr *hdr;
-	int hdrlen, padsize, retval;
+	int retval;
 	bool decrypt_error = false;
-	u8 keyix;
-	__le16 fc;
 
 	spin_lock_bh(&sc->rx.rxbuflock);
 
@@ -830,40 +877,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		skb_put(skb, rx_stats->rs_datalen);
 
-		/* see if any padding is done by the hw and remove it */
-		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-		fc = hdr->frame_control;
-
-		/* The MAC header is padded to have 32-bit boundary if the
-		 * packet payload is non-zero. The general calculation for
-		 * padsize would take into account odd header lengths:
-		 * padsize = (4 - hdrlen % 4) % 4; However, since only
-		 * even-length headers are used, padding can only be 0 or 2
-		 * bytes and we can optimize this a bit. In addition, we must
-		 * not try to remove padding from short control frames that do
-		 * not have payload. */
-		padsize = hdrlen & 3;
-		if (padsize && hdrlen >= 24) {
-			memmove(skb->data + padsize, skb->data, hdrlen);
-			skb_pull(skb, padsize);
-		}
-
-		keyix = rx_stats->rs_keyix;
-
-		if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error) {
-			rxs->flag |= RX_FLAG_DECRYPTED;
-		} else if (ieee80211_has_protected(fc)
-			   && !decrypt_error && skb->len >= hdrlen + 4) {
-			keyix = skb->data[hdrlen + 3] >> 6;
-
-			if (test_bit(keyix, common->keymap))
-				rxs->flag |= RX_FLAG_DECRYPTED;
-		}
-		if (ah->sw_mgmt_crypto &&
-		    (rxs->flag & RX_FLAG_DECRYPTED) &&
-		    ieee80211_is_mgmt(fc))
-			/* Use software decrypt for management frames. */
-			rxs->flag &= ~RX_FLAG_DECRYPTED;
+		ath9k_rx_skb_postprocess(common, skb, rx_stats,
+					 rxs, decrypt_error);
 
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;
-- 
1.6.5.2.143.g8cc62

