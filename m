Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57473 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab2KQTMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 14:12:43 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so451576eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Nov 2012 11:12:41 -0800 (PST)
Date: Sat, 17 Nov 2012 20:12:44 +0100
From: Bernhard Urban <lewurm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	c_manoha@qca.qualcomm.com, Sujith.Manoharan@atheros.com,
	linville@tuxdriver.com, markus@indoo.rs, m.sujith@gmail.com
Subject: Re: [PATCH] ath9k_htc: update RSSI values only when the device is
 associated
Message-ID: <20121117191244.GA18782@phenom> (sfid-20121117_201258_576010_E6EC5A63)
References: <1352480966-17462-1-git-send-email-lewurm@gmail.com>
 <509E1B47.3050107@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <509E1B47.3050107@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the reviews!


On Sat, Nov 10, 2012 at 9:42 AM, Sujith <m.sujith@gmail.com> wrote:
> Looks good, but a cleaner fix would be to update the RSSI only for
> beacons that are destined for the station.

You mean like in recv.c? There's a `is_mybeacon' field, which is computed in
`ath_rx_tasklet(...)' and used in `ath9k_process_rssi(...)'.

Adding this check to the if-guard changes nothing at the result, so I think
it's fine if you consider it as cleaner. See attached patch.

Btw, could you please elaborate what `is_mybeacon' represents?


On Sat, Nov 10, 2012 at 10:15 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Please check how RSSI is handled in ath9k, and use that as reference.
> The per-packet RSSI should not be set from some internal average, it
> should contain the real RSSI value of the packet. This change disables
> RSSI reporting for anything but station mode, which is not a good idea.

Replacing
	if (priv->num_sta_assoc_vif != 0)
with
	if (priv->ah->opmode == NL80211_IFTYPE_STATION)

works out well (which makes sense to me). However, adding
`&& priv->ah->opmode == NL80211_IFTYPE_ADHOC' (like in ath9k/recv.c) produces
bad results like before.  I don't understand the effect, as my device is always
in "managed mode" according to `iw wlan0 info'. I'm right by assuming "managed
mode" is the same as NL80211_IFTYPE_STATION?

Also, I don't know what you mean with "some internal average". Can you please
elaborate that?


Thanks for your help,
Bernhard


>From fc14c46ce75044485229be5bb12682a8fffcf178 Mon Sep 17 00:00:00 2001
From: Bernhard Urban <lewurm@gmail.com>
Date: Sat, 17 Nov 2012 00:22:16 +0100
Subject: [PATCH] ath9k_htc: update RSSI values only when the device is
 associated

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
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   29 +++++++++++++++----------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 936e920..00ebf1c 100644
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
index 47e61d0..8b4da3d 100644
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
+		!is_zero_ether_addr(common->curbssid) &&
+		ether_addr_equal(hdr->addr3, common->curbssid);
 
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

