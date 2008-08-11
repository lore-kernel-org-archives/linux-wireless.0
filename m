Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:39713 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbYHKLDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 07:03:42 -0400
Message-Id: <20080811110257.864227088@localhost> (sfid-20080811_130345_312033_F8209100)
References: <20080811110146.877112595@localhost>
Date: Mon, 11 Aug 2008 14:01:50 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] ath9k: Assign seq# when mac80211 requests this
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use TX control flag IEEE80211_TX_CTL_ASSIGN_SEQ as a request to update
the seq# for the frames. This will likely require some further cleanup
to get seq# correctly for Beacons vs. other frames and also potentially
for multiple BSSes. Anyway, this is better than ending up sending out
most frames with seq# 0.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/drivers/net/wireless/ath9k/beacon.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/beacon.c
+++ wireless-testing/drivers/net/wireless/ath9k/beacon.c
@@ -209,6 +209,7 @@ static struct ath_buf *ath_beacon_genera
 	int is_beacon_dtim = 0;
 	struct ath_txq *cabq;
 	struct ath_txq *mcastq;
+	struct ieee80211_tx_info *info;
 	avp = sc->sc_vaps[if_id];
 
 	mcastq = &avp->av_mcastq;
@@ -233,6 +234,17 @@ static struct ath_buf *ath_beacon_genera
 	bf->bf_mpdu = skb;
 	if (skb == NULL)
 		return NULL;
+	info = IEEE80211_SKB_CB(skb);
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		/*
+		 * TODO: make sure the seq# gets assigned properly (vs. other
+		 * TX frames)
+		 */
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+		sc->seq_no += 0x10;
+		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(sc->seq_no);
+	}
 	bf->bf_buf_addr = bf->bf_dmacontext =
 		pci_map_single(sc->pdev, skb->data,
 			       skb_end_pointer(skb) - skb->head,
Index: wireless-testing/drivers/net/wireless/ath9k/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c
+++ wireless-testing/drivers/net/wireless/ath9k/main.c
@@ -368,6 +368,20 @@ static int ath9k_tx(struct ieee80211_hw 
 {
 	struct ath_softc *sc = hw->priv;
 	int hdrlen, padsize;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	/*
+	 * As a temporary workaround, assign seq# here; this will likely need
+	 * to be cleaned up to work better with Beacon transmission and virtual
+	 * BSSes.
+	 */
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+			sc->seq_no += 0x10;
+		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(sc->seq_no);
+	}
 
 	/* Add the padding after the header if this is not already done */
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
Index: wireless-testing/drivers/net/wireless/ath9k/core.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/core.h
+++ wireless-testing/drivers/net/wireless/ath9k/core.h
@@ -965,6 +965,7 @@ struct ath_softc {
 	u32 sc_txqsetup;
 	u32 sc_txintrperiod;	/* tx interrupt batching */
 	int sc_haltype2q[ATH9K_WME_AC_VO+1]; /* HAL WME	AC -> h/w qnum */
+	u16 seq_no; /* TX sequence number */
 
 	/* Beacon */
 	struct ath9k_tx_queue_info sc_beacon_qi;

--

-- 
Jouni Malinen                                            PGP id EFC895FA
