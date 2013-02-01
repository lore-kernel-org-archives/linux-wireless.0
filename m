Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56300 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3BAMpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 07:45:46 -0500
Received: by mail-ee0-f50.google.com with SMTP id e51so2087618eek.37
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2013 04:45:45 -0800 (PST)
From: Bernhard Urban <lewurm@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	c_manoha@qca.qualcomm.com, Sujith.Manoharan@atheros.com,
	linville@tuxdriver.com, m.sujith@gmail.com, nbd@openwrt.org,
	shafi.wireless@gmail.com
Cc: markus@indoo.rs, lewurm@gmail.com
Subject: [PATCH] ath9k_htc: update RSSI values only when the device is associated
Date: Fri,  1 Feb 2013 13:50:12 +0100
Message-Id: <1359723012-9488-1-git-send-email-lewurm@gmail.com> (sfid-20130201_134554_177451_D6A22342)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add an if-guard, otherwise iw(8) reports weird signal strengths.

The behaviour was fine before this commit:
	7c277349ecbd66e19fad3d949fa6ef6c131a3b62
Therefore, this patch is a partially revert of it.

In my testsetup, I have two access points:
  00:12:XX  within one meter physically range
  c0:c1:XX  ~15m, two (thin) walls

	w/o patch:
	  00:12:XX  -82.00 dBm
	  c0:c1:XX  -84.00 dBm

	with patch:
	  00:12:XX  -45.00 dBm
	  c0:c1:XX  -63.00 dBm

Tested with "TP-Link TL-WN722N"

Reported-by: Markus Krainz <markus@indoo.rs>
Tested-by: Markus Krainz <markus@indoo.rs>
Signed-off-by: Bernhard Urban <lewurm@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   29 +++++++++++++++----------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index b30596f..602e19b 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -22,6 +22,7 @@
 #include <linux/firmware.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <net/mac80211.h>
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 06cdcb7..a38435a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -969,6 +969,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	int hdrlen, padpos, padsize;
 	int last_rssi = ATH_RSSI_DUMMY_MARKER;
 	__le16 fc;
+	u8 is_mybeacon;
 
 	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
 		ath_err(common, "Corrupted RX frame, dropping (len: %d)\n",
@@ -1060,22 +1061,28 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	ath9k_process_rate(hw, rx_status, rxbuf->rxstatus.rs_rate,
 			   rxbuf->rxstatus.rs_flags);
 
-	if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
-	    !rxbuf->rxstatus.rs_moreaggr)
-		ATH_RSSI_LPF(priv->rx.last_rssi,
-			     rxbuf->rxstatus.rs_rssi);
+	is_mybeacon = ieee80211_is_beacon(fc) &&
+				  !is_zero_ether_addr(common->curbssid) &&
+				  ether_addr_equal(hdr->addr3, common->curbssid);
 
-	last_rssi = priv->rx.last_rssi;
+	if (is_mybeacon && priv->ah->opmode == NL80211_IFTYPE_STATION) {
+		if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
+		    !rxbuf->rxstatus.rs_moreaggr)
+			ATH_RSSI_LPF(priv->rx.last_rssi,
+				     rxbuf->rxstatus.rs_rssi);
 
-	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-		rxbuf->rxstatus.rs_rssi = ATH_EP_RND(last_rssi,
-						     ATH_RSSI_EP_MULTIPLIER);
+		last_rssi = priv->rx.last_rssi;
 
-	if (rxbuf->rxstatus.rs_rssi < 0)
-		rxbuf->rxstatus.rs_rssi = 0;
+		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER)) {
+			s8 rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
+			rxbuf->rxstatus.rs_rssi = rssi;
+		}
+
+		if (rxbuf->rxstatus.rs_rssi < 0)
+			rxbuf->rxstatus.rs_rssi = 0;
 
-	if (ieee80211_is_beacon(fc))
 		priv->ah->stats.avgbrssi = rxbuf->rxstatus.rs_rssi;
+	}
 
 	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
-- 
1.7.9.5

