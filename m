Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:59002 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab1KPKJw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 05:09:52 -0500
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, shafi.wireless@gmail.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: trivial: reorder rx_tasklet processing
Date: Wed, 16 Nov 2011 11:09:44 +0100
Message-Id: <1321438184-8439-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20111116_110956_861875_B77788A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DFS events are reported as PHY errors and need to be processed
with a correct timestamp set before ath9k_skb_preprocess() is
called and the frame is possibly dropped.

This patch puts the rxs->mactime calculation before the skb
is preprocessed to prepare for DFS event reporting.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 67b862c..4c8e296 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1838,11 +1838,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (sc->sc_flags & SC_OP_RXFLUSH)
 			goto requeue_drop_frag;
 
-		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
-						 rxs, &decrypt_error);
-		if (retval)
-			goto requeue_drop_frag;
-
 		rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
 		if (rs.rs_tstamp > tsf_lower &&
 		    unlikely(rs.rs_tstamp - tsf_lower > 0x10000000))
@@ -1852,6 +1847,11 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
+		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
+						 rxs, &decrypt_error);
+		if (retval)
+			goto requeue_drop_frag;
+
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
 		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
-- 
1.7.4.1

