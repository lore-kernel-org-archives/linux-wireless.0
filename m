Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55416 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbZENSao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 14:30:44 -0400
Message-Id: <20090514183039.967226506@atheros.com>
References: <20090514182845.684003914@atheros.com>
Date: Thu, 14 May 2009 21:28:47 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 2/4] ath9k: Clean up RX processing a bit
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes use of the local fc variable in bit more places and uses a
common helper macro. The part of RX process that delivers skb's to
mac80211 is moved to a separate function in preparation for future
changes that will need to do this from two places. The modifications
here should not result in any functional changes.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/recv.c |   60 +++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 26 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/recv.c	2009-05-14 21:12:18.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/recv.c	2009-05-14 21:12:22.000000000 +0300
@@ -473,6 +473,37 @@ void ath_flushrecv(struct ath_softc *sc)
 	spin_unlock_bh(&sc->rx.rxflushlock);
 }
 
+static void ath_rx_send_to_mac80211(struct ath_softc *sc, struct sk_buff *skb,
+				    struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_hdr *hdr;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+
+	/* Send the frame to mac80211 */
+	if (is_multicast_ether_addr(hdr->addr1)) {
+		int i;
+		/*
+		 * Deliver broadcast/multicast frames to all suitable
+		 * virtual wiphys.
+		 */
+		/* TODO: filter based on channel configuration */
+		for (i = 0; i < sc->num_sec_wiphy; i++) {
+			struct ath_wiphy *aphy = sc->sec_wiphy[i];
+			struct sk_buff *nskb;
+			if (aphy == NULL)
+				continue;
+			nskb = skb_copy(skb, GFP_ATOMIC);
+			if (nskb)
+				__ieee80211_rx(aphy->hw, nskb, rx_status);
+		}
+		__ieee80211_rx(sc->hw, skb, rx_status);
+	} else {
+		/* Deliver unicast frames based on receiver address */
+		__ieee80211_rx(ath_get_virt_hw(sc, hdr), skb, rx_status);
+	}
+}
+
 int ath_rx_tasklet(struct ath_softc *sc, int flush)
 {
 #define PA2DESC(_sc, _pa)                                               \
@@ -622,7 +653,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 
 		if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error) {
 			rx_status.flag |= RX_FLAG_DECRYPTED;
-		} else if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_PROTECTED)
+		} else if (ieee80211_has_protected(fc)
 			   && !decrypt_error && skb->len >= hdrlen + 4) {
 			keyix = skb->data[hdrlen + 3] >> 6;
 
@@ -631,35 +662,12 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		}
 		if (ah->sw_mgmt_crypto &&
 		    (rx_status.flag & RX_FLAG_DECRYPTED) &&
-		    ieee80211_is_mgmt(hdr->frame_control)) {
+		    ieee80211_is_mgmt(fc)) {
 			/* Use software decrypt for management frames. */
 			rx_status.flag &= ~RX_FLAG_DECRYPTED;
 		}
 
-		/* Send the frame to mac80211 */
-		if (is_multicast_ether_addr(hdr->addr1)) {
-			int i;
-			/*
-			 * Deliver broadcast/multicast frames to all suitable
-			 * virtual wiphys.
-			 */
-			/* TODO: filter based on channel configuration */
-			for (i = 0; i < sc->num_sec_wiphy; i++) {
-				struct ath_wiphy *aphy = sc->sec_wiphy[i];
-				struct sk_buff *nskb;
-				if (aphy == NULL)
-					continue;
-				nskb = skb_copy(skb, GFP_ATOMIC);
-				if (nskb)
-					__ieee80211_rx(aphy->hw, nskb,
-						       &rx_status);
-			}
-			__ieee80211_rx(sc->hw, skb, &rx_status);
-		} else {
-			/* Deliver unicast frames based on receiver address */
-			__ieee80211_rx(ath_get_virt_hw(sc, hdr), skb,
-				       &rx_status);
-		}
+		ath_rx_send_to_mac80211(sc, skb, &rx_status);
 
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
