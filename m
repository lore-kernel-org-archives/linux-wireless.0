Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40319 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab0EWG6e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 May 2010 02:58:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 22 May 2010 23:58:34 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] ath9k: Fix rx of mcast/bcast frames in PS mode with auto sleep
Date: Sat, 22 May 2010 23:58:13 -0700
Message-ID: <1274597893-21934-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functionality to keep the device awake until it is done with
the rx of any mcast/bcast frames which are pending on AP should
also be added to the hardwares which support auto sleep feature.
This patch fixes frequent failures in ARP resolution when it is
initiated by the other end. Currently auto sleep is enabled only
for ar9003 in ath9k.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ba13913..ca6065b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -19,6 +19,12 @@
 
 #define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
 
+static inline bool ath9k_check_auto_sleep(struct ath_softc *sc)
+{
+	return sc->ps_enabled &&
+	       (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP);
+}
+
 static struct ieee80211_hw * ath_get_virt_hw(struct ath_softc *sc,
 					     struct ieee80211_hdr *hdr)
 {
@@ -616,8 +622,8 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 	hdr = (struct ieee80211_hdr *)skb->data;
 
 	/* Process Beacon and CAB receive in PS state */
-	if ((sc->ps_flags & PS_WAIT_FOR_BEACON) &&
-	    ieee80211_is_beacon(hdr->frame_control))
+	if (((sc->ps_flags & PS_WAIT_FOR_BEACON) || ath9k_check_auto_sleep(sc))
+	    && ieee80211_is_beacon(hdr->frame_control))
 		ath_rx_ps_beacon(sc, skb);
 	else if ((sc->ps_flags & PS_WAIT_FOR_CAB) &&
 		 (ieee80211_is_data(hdr->frame_control) ||
@@ -932,9 +938,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 			sc->rx.rxotherant = 0;
 		}
 
-		if (unlikely(sc->ps_flags & (PS_WAIT_FOR_BEACON |
-					     PS_WAIT_FOR_CAB |
-					     PS_WAIT_FOR_PSPOLL_DATA)))
+		if (unlikely(ath9k_check_auto_sleep(sc) ||
+			     (sc->ps_flags & (PS_WAIT_FOR_BEACON |
+					      PS_WAIT_FOR_CAB |
+					      PS_WAIT_FOR_PSPOLL_DATA))))
 			ath_rx_ps(sc, skb);
 
 		ath_rx_send_to_mac80211(hw, sc, skb, rxs);
-- 
1.7.0.4

