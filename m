Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4259 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZDNCK0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 22:10:26 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] ath9k: fix access to freed memory in ath_rx_tasklet()
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	ath9k-devel@lists.ath9k.org
Date: Mon, 13 Apr 2009 22:10:24 -0400
Message-ID: <20090414021024.10457.67684.stgit@localhost.localdomain> (sfid-20090414_041030_840822_881DBCDF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>

hdr->frame_control points to skb data and should not been used after the
skb has been consumed by __ieee80211_rx().
---

 drivers/net/wireless/ath/ath9k/recv.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 94a3328..b46badd 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -488,6 +488,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	int hdrlen, padsize, retval;
 	bool decrypt_error = false;
 	u8 keyix;
+	__le16 fc;
 
 	spin_lock_bh(&sc->rx.rxbuflock);
 
@@ -601,6 +602,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		/* see if any padding is done by the hw and remove it */
 		hdr = (struct ieee80211_hdr *)skb->data;
 		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+		fc = hdr->frame_control;
 
 		/* The MAC header is padded to have 32-bit boundary if the
 		 * packet payload is non-zero. The general calculation for
@@ -685,7 +687,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			sc->rx.rxotherant = 0;
 		}
 
-		if (ieee80211_is_beacon(hdr->frame_control) &&
+		if (ieee80211_is_beacon(fc) &&
 				(sc->sc_flags & SC_OP_WAIT_FOR_BEACON)) {
 			sc->sc_flags &= ~SC_OP_WAIT_FOR_BEACON;
 			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
