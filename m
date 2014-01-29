Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49850 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbaA2TID (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 14:08:03 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0MK3bN-1W9Pq02YMv-001Oez for
 <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 20:08:02 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 07/13] ath9k_htc: use ath9k_cmn_process_rate
Date: Wed, 29 Jan 2014 20:06:58 +0100
Message-Id: <1391022424-21087-6-git-send-email-linux@rempel-privat.de> (sfid-20140129_200808_963761_08FDC057)
In-Reply-To: <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
 <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 40 ++-------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 99d5118..de75224 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -929,42 +929,6 @@ void ath9k_host_rx_init(struct ath9k_htc_priv *priv)
 	ath9k_hw_startpcureceive(priv->ah, test_bit(OP_SCANNING, &priv->op_flags));
 }
 
-static void ath9k_process_rate(struct ieee80211_hw *hw,
-			       struct ieee80211_rx_status *rxs,
-			       u8 rx_rate, u8 rs_flags)
-{
-	struct ieee80211_supported_band *sband;
-	enum ieee80211_band band;
-	unsigned int i = 0;
-
-	if (rx_rate & 0x80) {
-		/* HT rate */
-		rxs->flag |= RX_FLAG_HT;
-		if (rs_flags & ATH9K_RX_2040)
-			rxs->flag |= RX_FLAG_40MHZ;
-		if (rs_flags & ATH9K_RX_GI)
-			rxs->flag |= RX_FLAG_SHORT_GI;
-		rxs->rate_idx = rx_rate & 0x7f;
-		return;
-	}
-
-	band = hw->conf.chandef.chan->band;
-	sband = hw->wiphy->bands[band];
-
-	for (i = 0; i < sband->n_bitrates; i++) {
-		if (sband->bitrates[i].hw_value == rx_rate) {
-			rxs->rate_idx = i;
-			return;
-		}
-		if (sband->bitrates[i].hw_value_short == rx_rate) {
-			rxs->rate_idx = i;
-			rxs->flag |= RX_FLAG_SHORTPRE;
-			return;
-		}
-	}
-
-}
-
 static inline void conver_htc_flag(struct ath_rx_status *rx_stats,
 				   struct ath_htc_rx_status *rxstatus)
 {
@@ -1103,9 +1067,9 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		}
 	}
 
-	ath9k_process_rate(hw, rx_status, rxbuf->rxstatus.rs_rate,
-			   rxbuf->rxstatus.rs_flags);
 
+	if (ath9k_cmn_process_rate(common, hw, rx_stats, rx_status))
+		goto rx_next;
 
 	rx_stats->is_mybeacon = ath_is_mybeacon(common, hdr);
 	ath9k_cmn_process_rssi(common, hw, rx_stats, rx_status);
-- 
1.8.5.3

