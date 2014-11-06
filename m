Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58185 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaKFHyk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:40 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 20/21] ath9k_htc: process rx spectral packets
Date: Thu,  6 Nov 2014 08:53:37 +0100
Message-Id: <1415260418-14321-21-git-send-email-linux@rempel-privat.de> (sfid-20141106_085501_908729_2B17869D)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use code provided by Ashish Patro <patro@cs.wisc.edu>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 2622002..a0f58e2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1012,6 +1012,20 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	 * separately to avoid doing two lookups for a rate for each frame.
 	 */
 	hdr = (struct ieee80211_hdr *)skb->data;
+
+	/*
+	 * Process PHY errors and return so that the packet
+	 * can be dropped.
+	 */
+	if (rx_stats.rs_status & ATH9K_RXERR_PHY) {
+		/* TODO: Not using DFS processing now. */
+		if (ath_cmn_process_fft(&priv->spec_priv, hdr,
+				    &rx_stats, rx_status->mactime)) {
+			/* TODO: Code to collect spectral scan statistics */
+		}
+		goto rx_next;
+	}
+
 	if (!ath9k_cmn_rx_accept(common, hdr, rx_status, &rx_stats,
 			&decrypt_error, priv->rxfilter))
 		goto rx_next;
-- 
1.9.1

