Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50891 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbaBDJ2x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 04:28:53 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0Meg8W-1VqsV13Y3k-00OGsy for
 <linux-wireless@vger.kernel.org>; Tue, 04 Feb 2014 10:28:52 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 11/13] ath9k_htc: use ath9k_cmn_rx_skb_postprocess
Date: Tue,  4 Feb 2014 10:27:48 +0100
Message-Id: <1391506070-8636-12-git-send-email-linux@rempel-privat.de> (sfid-20140204_103006_627402_698889B5)
In-Reply-To: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
References: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 28 +++------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index e36bf61..c30af6d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -974,9 +974,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct ath_hw *ah = common->ah;
 	struct ath_htc_rx_status *rxstatus;
 	struct ath_rx_status rx_stats;
-	int hdrlen, padsize;
 	bool decrypt_error;
-	__le16 fc;
 
 	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
 		ath_err(common, "Corrupted RX frame, dropping (len: %d)\n",
@@ -1000,16 +998,6 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	memcpy(&rxbuf->rxstatus, rxstatus, HTC_RX_FRAME_HEADER_SIZE);
 	skb_pull(skb, HTC_RX_FRAME_HEADER_SIZE);
 
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-
-	padsize = hdrlen & 3;
-	if (padsize && skb->len >= hdrlen+padsize+FCS_LEN) {
-		memmove(skb->data + padsize, skb->data, hdrlen);
-		skb_pull(skb, padsize);
-	}
-
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
 
 	rx_status_htc_to_ath(&rx_stats, &rxbuf->rxstatus);
@@ -1018,23 +1006,13 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	 * everything but the rate is checked here, the rate check is done
 	 * separately to avoid doing two lookups for a rate for each frame.
 	 */
+	hdr = (struct ieee80211_hdr *)skb->data;
 	if (!ath9k_cmn_rx_accept(common, hdr, rx_status, &rx_stats,
 			&decrypt_error, priv->rxfilter))
 		goto rx_next;
 
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
+	ath9k_cmn_rx_skb_postprocess(common, skb, &rx_stats,
+				     rx_status, decrypt_error);
 
 	if (ath9k_cmn_process_rate(common, hw, &rx_stats, rx_status))
 		goto rx_next;
-- 
1.9.rc1

