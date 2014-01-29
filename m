Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62455 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbaA2THs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 14:07:48 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0LbxQO-1VRrks2nvY-00jI4C for
 <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 20:07:46 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 05/13] ath9k_htc: add rx header converter to make it usable by ath9k
Date: Wed, 29 Jan 2014 20:06:56 +0100
Message-Id: <1391022424-21087-4-git-send-email-linux@rempel-privat.de> (sfid-20140129_200801_348663_965F7EE0)
In-Reply-To: <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
 <1391022424-21087-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 43 +++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 12e0f32..8a63f67 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -966,6 +966,38 @@ static void ath9k_process_rate(struct ieee80211_hw *hw,
 
 }
 
+static inline void conver_htc_flag(struct ath_rx_status *rx_stats,
+				   struct ath_htc_rx_status *rxstatus)
+{
+	if (rxstatus->rs_flags & ATH9K_RX_2040)
+		rx_stats->flag |= RX_FLAG_40MHZ;
+	if (rxstatus->rs_flags & ATH9K_RX_GI)
+		rx_stats->flag |= RX_FLAG_SHORT_GI;
+}
+
+static void rx_status_htc_to_ath(struct ath_rx_status *rx_stats,
+				 struct ath_htc_rx_status *rxstatus)
+{
+	rx_stats->rs_datalen	= rxstatus->rs_datalen;
+	rx_stats->rs_status	= rxstatus->rs_status;
+	rx_stats->rs_phyerr	= rxstatus->rs_phyerr;
+	rx_stats->rs_rssi	= rxstatus->rs_rssi;
+	rx_stats->rs_keyix	= rxstatus->rs_keyix;
+	rx_stats->rs_rate	= rxstatus->rs_rate;
+	rx_stats->rs_antenna	= rxstatus->rs_antenna;
+	rx_stats->rs_more	= rxstatus->rs_more;
+
+	memcpy(rx_stats->rs_rssi_ctl, rxstatus->rs_rssi_ctl,
+		sizeof(rx_stats->rs_rssi_ctl));
+	memcpy(rx_stats->rs_rssi_ext, rxstatus->rs_rssi_ext,
+		sizeof(rx_stats->rs_rssi_ext));
+
+	rx_stats->rs_isaggr	= rxstatus->rs_isaggr;
+	rx_stats->rs_moreaggr	= rxstatus->rs_moreaggr;
+	rx_stats->rs_num_delims	= rxstatus->rs_num_delims;
+	conver_htc_flag(rx_stats, rxstatus);
+}
+
 static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 			     struct ath9k_htc_rxbuf *rxbuf,
 			     struct ieee80211_rx_status *rx_status)
@@ -976,6 +1008,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct sk_buff *skb = rxbuf->skb;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath_htc_rx_status *rxstatus;
+	struct ath_rx_status *rx_stats;
 	int hdrlen, padsize;
 	int last_rssi = ATH_RSSI_DUMMY_MARKER;
 	__le16 fc;
@@ -1014,6 +1047,13 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
 
+	rx_stats = kzalloc(sizeof(struct ath_rx_status), GFP_KERNEL);
+	if (unlikely(rx_stats == NULL)) {
+		ath_err(common, "rx_stats allocation filed!\n");
+		goto err_nofree;
+	}
+	rx_status_htc_to_ath(rx_stats, &rxbuf->rxstatus);
+
 	if (rxbuf->rxstatus.rs_status != 0) {
 		if (rxbuf->rxstatus.rs_status & ATH9K_RXERR_CRC)
 			rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
@@ -1094,9 +1134,12 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	rx_status->antenna = rxbuf->rxstatus.rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_END;
 
+	kfree(rx_stats);
 	return true;
 
 rx_next:
+	kfree(rx_stats);
+err_nofree:
 	return false;
 }
 
-- 
1.8.5.3

