Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57074 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbaA2TIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 14:08:09 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0MNO33-1WAVEH2SVt-006sqP for
 <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 20:08:08 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 08/13] ath9k_htc: use ath9k_cmn_rx_accept
Date: Wed, 29 Jan 2014 20:06:59 +0100
Message-Id: <1391022424-21087-7-git-send-email-linux@rempel-privat.de> (sfid-20140129_200813_421036_CEECB99D)
In-Reply-To: <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
 <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 45 +++++----------------------
 1 file changed, 8 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index de75224..e55659b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -973,6 +973,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct ath_htc_rx_status *rxstatus;
 	struct ath_rx_status *rx_stats;
 	int hdrlen, padsize;
+	bool decrypt_error;
 	__le16 fc;
 
 	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
@@ -1016,43 +1017,13 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	}
 	rx_status_htc_to_ath(rx_stats, &rxbuf->rxstatus);
 
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
+	/*
+	 * everything but the rate is checked here, the rate check is done
+	 * separately to avoid doing two lookups for a rate for each frame.
+	 */
+	if (!ath9k_cmn_rx_accept(common, hdr, rx_status, rx_stats,
+			&decrypt_error, priv->rxfilter))
+		goto rx_next;
 
 	if (!(rxbuf->rxstatus.rs_status & ATH9K_RXERR_DECRYPT)) {
 		u8 keyix;
-- 
1.8.5.3

