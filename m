Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:41509 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760682AbZDDAKa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 20:10:30 -0400
Subject: [PATCH] ath9k: fix access to a freed skb in ath_rx_tasklet()
From: Pavel Roskin <proski@gnu.org>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 20:10:26 -0400
Message-Id: <1238803826.30480.7.camel@mj> (sfid-20090404_021039_053215_849974CC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

The patch should be in the stable kernels too.  ath9k actually hangs on
a kernel with SLUB debugging enabled.  hdr->frame_control could be
replaced with fc in more places, but the patch is intentionally kept as
simple as possible.

 drivers/net/wireless/ath9k/recv.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 71cb18d..dd1f301 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -493,6 +493,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	int hdrlen, padsize, retval;
 	bool decrypt_error = false;
 	u8 keyix;
+	__le16 fc;
 
 	spin_lock_bh(&sc->rx.rxbuflock);
 
@@ -606,6 +607,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		/* see if any padding is done by the hw and remove it */
 		hdr = (struct ieee80211_hdr *)skb->data;
 		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+		fc = hdr->frame_control;
 
 		/* The MAC header is padded to have 32-bit boundary if the
 		 * packet payload is non-zero. The general calculation for
@@ -690,7 +692,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			sc->rx.rxotherant = 0;
 		}
 
-		if (ieee80211_is_beacon(hdr->frame_control) &&
+		if (ieee80211_is_beacon(fc) &&
 				(sc->sc_flags & SC_OP_WAIT_FOR_BEACON)) {
 			sc->sc_flags &= ~SC_OP_WAIT_FOR_BEACON;
 			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);

-- 
Regards,
Pavel Roskin
