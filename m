Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63455 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbaA2TIm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 14:08:42 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0MZfZi-1VqNxW3gNi-00LY4s for
 <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 20:08:41 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 12/13] ath9k_htc: remove useless memcpy
Date: Wed, 29 Jan 2014 20:07:03 +0100
Message-Id: <1391022424-21087-11-git-send-email-linux@rempel-privat.de> (sfid-20140129_200844_749133_E57C959B)
In-Reply-To: <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
 <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

after switch to common fucntions we do not need this memcpy any more.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index c4368c4..17e4d83 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -994,8 +994,6 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	ath9k_htc_err_stat_rx(priv, rxstatus);
 
 	/* Get the RX status information */
-	memcpy(&rxbuf->rxstatus, rxstatus, HTC_RX_FRAME_HEADER_SIZE);
-	skb_pull(skb, HTC_RX_FRAME_HEADER_SIZE);
 
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
 
@@ -1004,7 +1002,11 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		ath_err(common, "rx_stats allocation filed!\n");
 		goto err_nofree;
 	}
-	rx_status_htc_to_ath(rx_stats, &rxbuf->rxstatus);
+	/* Copy everything from ath_htc_rx_status (HTC_RX_FRAME_HEADER).
+	 * After this, we can drop this part of skb. */
+	rx_status_htc_to_ath(rx_stats, rxstatus);
+	rx_status->mactime = be64_to_cpu(rxstatus->rs_tstamp);
+	skb_pull(skb, HTC_RX_FRAME_HEADER_SIZE);
 
 	/*
 	 * everything but the rate is checked here, the rate check is done
@@ -1024,8 +1026,6 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	rx_stats->is_mybeacon = ath_is_mybeacon(common, hdr);
 	ath9k_cmn_process_rssi(common, hw, rx_stats, rx_status);
 
-	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
-
 	rx_status->band = ah->curchan->chan->band;
 	rx_status->freq = ah->curchan->chan->center_freq;
 	rx_status->antenna = rx_stats->rs_antenna;
-- 
1.8.5.3

