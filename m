Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56117 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Subject: [PATCH 03/29] ath9k: simpify RX by calling ath_get_virt_hw() once
Date: Sat,  7 Nov 2009 15:18:40 -0500
Message-Id: <1257625146-17971-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_get_virt_hw() is required on RX to determine for which virtual
wiphy an skb came in for. Instead of searching for the hw twice do
it only once.

Cc: Jouni.Malinen <Jouni.Malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 355dd18..c910c10 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -105,23 +105,21 @@ static u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp)
  * up the frame up to let mac80211 handle the actual error case, be it no
  * decryption key or real decryption error. This let us keep statistics there.
  */
-static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
+static int ath_rx_prepare(struct ieee80211_hw *hw,
+			  struct sk_buff *skb, struct ath_desc *ds,
 			  struct ieee80211_rx_status *rx_status, bool *decrypt_error,
 			  struct ath_softc *sc)
 {
 	struct ieee80211_hdr *hdr;
 	u8 ratecode;
 	__le16 fc;
-	struct ieee80211_hw *hw;
 	struct ieee80211_sta *sta;
 	struct ath_node *an;
 	int last_rssi = ATH_RSSI_DUMMY_MARKER;
 
-
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
-	hw = ath_get_virt_hw(sc, hdr);
 
 	if (ds->ds_rxstat.rs_more) {
 		/*
@@ -616,7 +614,8 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 	}
 }
 
-static void ath_rx_send_to_mac80211(struct ath_softc *sc, struct sk_buff *skb,
+static void ath_rx_send_to_mac80211(struct ieee80211_hw *hw,
+				    struct ath_softc *sc, struct sk_buff *skb,
 				    struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_hdr *hdr;
@@ -648,7 +647,7 @@ static void ath_rx_send_to_mac80211(struct ath_softc *sc, struct sk_buff *skb,
 	} else {
 		/* Deliver unicast frames based on receiver address */
 		memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));
-		ieee80211_rx(ath_get_virt_hw(sc, hdr), skb);
+		ieee80211_rx(hw, skb);
 	}
 }
 
@@ -664,6 +663,12 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 	struct ieee80211_rx_status rx_status;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	/*
+	 * The hw can techncically differ from common->hw when using ath9k
+	 * virtual wiphy so to account for that we iterate over the active
+	 * wiphys and find the appropriate wiphy and therefore hw.
+	 */
+	struct ieee80211_hw *hw = NULL;
 	struct ieee80211_hdr *hdr;
 	int hdrlen, padsize, retval;
 	bool decrypt_error = false;
@@ -743,6 +748,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 				sc->rx.bufsize,
 				DMA_FROM_DEVICE);
 
+		hdr = (struct ieee80211_hdr *) skb->data;
+		hw = ath_get_virt_hw(sc, hdr);
+
 		/*
 		 * If we're asked to flush receive queue, directly
 		 * chain it back at the queue without processing it.
@@ -757,7 +765,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		if (sc->rx.bufsize < ds->ds_rxstat.rs_datalen)
 			goto requeue;
 
-		if (!ath_rx_prepare(skb, ds, &rx_status, &decrypt_error, sc))
+		if (!ath_rx_prepare(hw, skb, ds,
+				    &rx_status, &decrypt_error, sc))
 			goto requeue;
 
 		/* Ensure we always have an skb to requeue once we are done
@@ -779,7 +788,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		skb_put(skb, ds->ds_rxstat.rs_datalen);
 
 		/* see if any padding is done by the hw and remove it */
-		hdr = (struct ieee80211_hdr *)skb->data;
 		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 		fc = hdr->frame_control;
 
@@ -826,7 +834,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			bf->bf_mpdu = NULL;
 			ath_print(common, ATH_DBG_FATAL,
 				  "dma_mapping_error() on RX\n");
-			ath_rx_send_to_mac80211(sc, skb, &rx_status);
+			ath_rx_send_to_mac80211(hw, sc, skb, &rx_status);
 			break;
 		}
 		bf->bf_dmacontext = bf->bf_buf_addr;
@@ -847,7 +855,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 					     SC_OP_WAIT_FOR_PSPOLL_DATA)))
 			ath_rx_ps(sc, skb);
 
-		ath_rx_send_to_mac80211(sc, skb, &rx_status);
+		ath_rx_send_to_mac80211(hw, sc, skb, &rx_status);
 
 requeue:
 		list_move_tail(&bf->list, &sc->rx.rxbuf);
-- 
1.6.5.2.143.g8cc62

