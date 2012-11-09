Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37704 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab2KIRGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 12:06:13 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so2295900eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2012 09:06:12 -0800 (PST)
From: Bernhard Urban <lewurm@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	c_manoha@qca.qualcomm.com, Sujith.Manoharan@atheros.com,
	linville@tuxdriver.com
Cc: markus@indoo.rs, lewurm@gmail.com
Subject: [PATCH] ath9k_htc: update RSSI values only when the device is associated
Date: Fri,  9 Nov 2012 18:09:26 +0100
Message-Id: <1352480966-17462-1-git-send-email-lewurm@gmail.com> (sfid-20121109_180617_690815_9769C15B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add an if-guard, otherwise iw(8) reports weird signal strengths.

The behaviour was fine before this commit:
7c277349ecbd66e19fad3d949fa6ef6c131a3b62
This patch is therefore a partially revert of it.

Tested with "TP-Link TL-WN722N"

Thanks to indoo.rs http://indoo.rs/ for sponsoring

Reported-by: Markus Krainz <markus@indoo.rs>
Tested-by: Markus Krainz <markus@indoo.rs>
Signed-off-by: Bernhard Urban <lewurm@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   27 ++++++++++++++-----------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 47e61d0..d0d329c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1060,22 +1060,25 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	ath9k_process_rate(hw, rx_status, rxbuf->rxstatus.rs_rate,
 			   rxbuf->rxstatus.rs_flags);
 
-	if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
-	    !rxbuf->rxstatus.rs_moreaggr)
-		ATH_RSSI_LPF(priv->rx.last_rssi,
-			     rxbuf->rxstatus.rs_rssi);
+	if (priv->num_sta_assoc_vif != 0) {
+		if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
+		    !rxbuf->rxstatus.rs_moreaggr)
+			ATH_RSSI_LPF(priv->rx.last_rssi,
+				     rxbuf->rxstatus.rs_rssi);
 
-	last_rssi = priv->rx.last_rssi;
+		last_rssi = priv->rx.last_rssi;
 
-	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-		rxbuf->rxstatus.rs_rssi = ATH_EP_RND(last_rssi,
-						     ATH_RSSI_EP_MULTIPLIER);
+		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER)) {
+			s8 rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
+			rxbuf->rxstatus.rs_rssi = rssi;
+		}
 
-	if (rxbuf->rxstatus.rs_rssi < 0)
-		rxbuf->rxstatus.rs_rssi = 0;
+		if (rxbuf->rxstatus.rs_rssi < 0)
+			rxbuf->rxstatus.rs_rssi = 0;
 
-	if (ieee80211_is_beacon(fc))
-		priv->ah->stats.avgbrssi = rxbuf->rxstatus.rs_rssi;
+		if (ieee80211_is_beacon(fc))
+			priv->ah->stats.avgbrssi = rxbuf->rxstatus.rs_rssi;
+	}
 
 	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
-- 
1.7.9.5

