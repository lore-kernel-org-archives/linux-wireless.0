Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev2day.de ([83.169.2.241]:55687 "EHLO dev2day.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab0HBUV6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 16:21:58 -0400
Message-ID: <4C57278E.1030601@dev2day.de>
Date: Mon, 02 Aug 2010 22:16:14 +0200
From: Jan Friedrich <jft@dev2day.de>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [Patch] ath9k: fix erased ieee80211_rx_status.mactime
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch addresses the erasure of ieee80211_rx_status.mactime.

After the mactime is set in "ath_rx_tasklet" it is immediately nulled in
"ath9k_rx_skb_preprocess".

Signed-off-by: Jan Friedrich <jft@dev2day.de>
---
 drivers/net/wireless/ath/ath9k/recv.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c
b/drivers/net/wireless/ath/ath9k/recv.c
index da0cfe9..ae4bd30 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1140,6 +1140,11 @@ int ath_rx_tasklet(struct ath_softc *sc, int
flush, bool hp)
 		if (flush)
 			goto requeue;

+		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
+						 rxs, &decrypt_error);
+		if (retval)
+			goto requeue;
+			
 		rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
 		if (rs.rs_tstamp > tsf_lower &&
 		    unlikely(rs.rs_tstamp - tsf_lower > 0x10000000))
@@ -1149,11 +1154,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int
flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;

-		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
-						 rxs, &decrypt_error);
-		if (retval)
-			goto requeue;
-
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
 		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
