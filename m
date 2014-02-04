Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:56248 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbaBDJ2d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 04:28:33 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0LuxG5-1VBC1x0J6X-0108sb for
 <linux-wireless@vger.kernel.org>; Tue, 04 Feb 2014 10:28:32 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 05/13] ath9k_htc: add rx header converter to make it usable by ath9k
Date: Tue,  4 Feb 2014 10:27:42 +0100
Message-Id: <1391506070-8636-6-git-send-email-linux@rempel-privat.de> (sfid-20140204_102836_478361_1A4A62B5)
In-Reply-To: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
References: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 37 ++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 12e0f32..a3f2201 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -966,6 +966,39 @@ static void ath9k_process_rate(struct ieee80211_hw *hw,
 
 }
 
+static inline void convert_htc_flag(struct ath_rx_status *rx_stats,
+				   struct ath_htc_rx_status *rxstatus)
+{
+	rx_stats->flag = 0;
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
+	convert_htc_flag(rx_stats, rxstatus);
+}
+
 static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 			     struct ath9k_htc_rxbuf *rxbuf,
 			     struct ieee80211_rx_status *rx_status)
@@ -976,6 +1009,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct sk_buff *skb = rxbuf->skb;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath_htc_rx_status *rxstatus;
+	struct ath_rx_status rx_stats;
 	int hdrlen, padsize;
 	int last_rssi = ATH_RSSI_DUMMY_MARKER;
 	__le16 fc;
@@ -1014,6 +1048,8 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
 
+	rx_status_htc_to_ath(&rx_stats, &rxbuf->rxstatus);
+
 	if (rxbuf->rxstatus.rs_status != 0) {
 		if (rxbuf->rxstatus.rs_status & ATH9K_RXERR_CRC)
 			rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
@@ -1095,7 +1131,6 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	rx_status->flag |= RX_FLAG_MACTIME_END;
 
 	return true;
-
 rx_next:
 	return false;
 }
-- 
1.9.rc1

