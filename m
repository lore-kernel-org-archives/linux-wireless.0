Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZKGUTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:08 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 18/29] ath9k: avoid the copy skb->cb on every RX'd skb
Date: Sat,  7 Nov 2009 15:18:55 -0500
Message-Id: <1257625146-17971-19-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The skb->cb (control buffer, 48 bytes) is available to the skb
upon skb allocation. You can fill it up imediately after skb
allocation. ath9k was copying onto the skb->cb the data from the
processed skb for mac80211 from a stack struct ieee80211_rx_status
structure. This is unnecessary, instead use the skb->cb for the
rx status immediately after the skb becomes available and DMA
synched.

Additionally, avoid the copy of the skb->cb also for virtual wiphys
as skb_copy() will copy over the skb->cb for us as well.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   38 +++++++++++++-------------------
 1 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 4c4c22f..0793614 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -283,8 +283,6 @@ static int ath_rx_prepare(struct ath_common *common,
 {
 	struct ath_hw *ah = common->ah;
 
-	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
-
 	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
 		goto rx_next;
 
@@ -654,7 +652,7 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 
 static void ath_rx_send_to_mac80211(struct ieee80211_hw *hw,
 				    struct ath_softc *sc, struct sk_buff *skb,
-				    struct ieee80211_rx_status *rx_status)
+				    struct ieee80211_rx_status *rxs)
 {
 	struct ieee80211_hdr *hdr;
 
@@ -674,19 +672,14 @@ static void ath_rx_send_to_mac80211(struct ieee80211_hw *hw,
 			if (aphy == NULL)
 				continue;
 			nskb = skb_copy(skb, GFP_ATOMIC);
-			if (nskb) {
-				memcpy(IEEE80211_SKB_RXCB(nskb), rx_status,
-					sizeof(*rx_status));
-				ieee80211_rx(aphy->hw, nskb);
-			}
+			if (!nskb)
+				continue;
+			ieee80211_rx(aphy->hw, nskb);
 		}
-		memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));
 		ieee80211_rx(sc->hw, skb);
-	} else {
+	} else
 		/* Deliver unicast frames based on receiver address */
-		memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));
 		ieee80211_rx(hw, skb);
-	}
 }
 
 int ath_rx_tasklet(struct ath_softc *sc, int flush)
@@ -699,7 +692,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	struct ath_desc *ds;
 	struct ath_rx_status *rx_stats;
 	struct sk_buff *skb = NULL, *requeue_skb;
-	struct ieee80211_rx_status rx_status;
+	struct ieee80211_rx_status *rxs;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	/*
@@ -788,6 +781,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 				DMA_FROM_DEVICE);
 
 		hdr = (struct ieee80211_hdr *) skb->data;
+		rxs =  IEEE80211_SKB_RXCB(skb);
+
 		hw = ath_get_virt_hw(sc, hdr);
 		rx_stats = &ds->ds_rxstat;
 
@@ -806,7 +801,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			goto requeue;
 
 		if (!ath_rx_prepare(common, hw, skb, rx_stats,
-				    &rx_status, &decrypt_error))
+				    rxs, &decrypt_error))
 			goto requeue;
 
 		/* Ensure we always have an skb to requeue once we are done
@@ -848,20 +843,19 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		keyix = rx_stats->rs_keyix;
 
 		if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error) {
-			rx_status.flag |= RX_FLAG_DECRYPTED;
+			rxs->flag |= RX_FLAG_DECRYPTED;
 		} else if (ieee80211_has_protected(fc)
 			   && !decrypt_error && skb->len >= hdrlen + 4) {
 			keyix = skb->data[hdrlen + 3] >> 6;
 
 			if (test_bit(keyix, sc->keymap))
-				rx_status.flag |= RX_FLAG_DECRYPTED;
+				rxs->flag |= RX_FLAG_DECRYPTED;
 		}
 		if (ah->sw_mgmt_crypto &&
-		    (rx_status.flag & RX_FLAG_DECRYPTED) &&
-		    ieee80211_is_mgmt(fc)) {
+		    (rxs->flag & RX_FLAG_DECRYPTED) &&
+		    ieee80211_is_mgmt(fc))
 			/* Use software decrypt for management frames. */
-			rx_status.flag &= ~RX_FLAG_DECRYPTED;
-		}
+			rxs->flag &= ~RX_FLAG_DECRYPTED;
 
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;
@@ -874,7 +868,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			bf->bf_mpdu = NULL;
 			ath_print(common, ATH_DBG_FATAL,
 				  "dma_mapping_error() on RX\n");
-			ath_rx_send_to_mac80211(hw, sc, skb, &rx_status);
+			ath_rx_send_to_mac80211(hw, sc, skb, rxs);
 			break;
 		}
 		bf->bf_dmacontext = bf->bf_buf_addr;
@@ -895,7 +889,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 					     SC_OP_WAIT_FOR_PSPOLL_DATA)))
 			ath_rx_ps(sc, skb);
 
-		ath_rx_send_to_mac80211(hw, sc, skb, &rx_status);
+		ath_rx_send_to_mac80211(hw, sc, skb, rxs);
 
 requeue:
 		list_move_tail(&bf->list, &sc->rx.rxbuf);
-- 
1.6.5.2.143.g8cc62

