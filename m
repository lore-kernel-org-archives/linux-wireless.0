Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26171 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab0ESAbF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 20:31:05 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 17:31:05 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix rx of mcast/bcast frames in PS mode with auto sleep
Date: Tue, 18 May 2010 17:31:02 -0700
Message-ID: <1274229062-10412-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f0f5f5e..146e79d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -18,6 +18,9 @@
 #include "ar9003_mac.h"
 
 #define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
+#define ATH9K_CHECK_AUTO_SLEEP(__sc) \
+	(__sc->ps_enabled && \
+	(__sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
 
 static struct ieee80211_hw * ath_get_virt_hw(struct ath_softc *sc,
 					     struct ieee80211_hdr *hdr)
@@ -616,8 +619,8 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 	hdr = (struct ieee80211_hdr *)skb->data;
 
 	/* Process Beacon and CAB receive in PS state */
-	if ((sc->ps_flags & PS_WAIT_FOR_BEACON) &&
-	    ieee80211_is_beacon(hdr->frame_control))
+	if (((sc->ps_flags & PS_WAIT_FOR_BEACON) || ATH9K_CHECK_AUTO_SLEEP(sc))
+	    && ieee80211_is_beacon(hdr->frame_control))
 		ath_rx_ps_beacon(sc, skb);
 	else if ((sc->ps_flags & PS_WAIT_FOR_CAB) &&
 		 (ieee80211_is_data(hdr->frame_control) ||
@@ -945,9 +948,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			sc->rx.rxotherant = 0;
 		}
 
-		if (unlikely(sc->ps_flags & (PS_WAIT_FOR_BEACON |
-					     PS_WAIT_FOR_CAB |
-					     PS_WAIT_FOR_PSPOLL_DATA)))
+		if (unlikely(ATH9K_CHECK_AUTO_SLEEP(sc) ||
+			     (sc->ps_flags & (PS_WAIT_FOR_BEACON |
+					      PS_WAIT_FOR_CAB |
+					      PS_WAIT_FOR_PSPOLL_DATA))))
 			ath_rx_ps(sc, skb);
 
 		ath_rx_send_to_mac80211(hw, sc, skb, rxs);
-- 
1.7.0.4

