Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:53580 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257AbZLKXWu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 18:22:50 -0500
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
To: lrodriguez@atheros.com, jmalinen@atheros.com
Cc: ath9k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] ath9k: Last fix for TX software padding.
Date: Sat, 12 Dec 2009 00:22:35 +0100
Message-Id: <1260573755-4422-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benoit Papillault <benoit.papillault@free.fr>

First, we copy/paste the padding stuff from ath9k_tx to ath_tx_cabq since it
needs to same kind of padding, but for internally generated beacons.
Next, software padding done on TX needs to be removed before calling
ieee80211_tx_status. The code was already there in ath_tx_complete but it
was wrong. Fix it by using ath9k_cmn_padpos. This later code has been
tested by sending packets to a monitor interface and reading packets from the
same interface.

Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2a11cc5..6770620 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1780,7 +1780,8 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	int hdrlen, padsize;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	int padpos, padsize;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_control txctl;
 
@@ -1792,7 +1793,6 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * BSSes.
 	 */
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 			sc->tx.seq_no += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
@@ -1800,9 +1800,9 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 
 	/* Add the padding after the header if this is not already done */
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	if (hdrlen & 3) {
-		padsize = hdrlen % 4;
+	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padsize = padpos & 3;
+	if (padsize && skb->len>padpos) {
 		if (skb_headroom(skb) < padsize) {
 			ath_print(common, ATH_DBG_XMIT,
 				  "TX CABQ padding failed\n");
@@ -1810,7 +1810,7 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 			return;
 		}
 		skb_push(skb, padsize);
-		memmove(skb->data, skb->data + padsize, hdrlen);
+		memmove(skb->data, skb->data + padsize, padpos);
 	}
 
 	txctl.txq = sc->beacon.cabq;
@@ -1838,7 +1838,8 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	int hdrlen, padsize;
+	struct ieee80211_hdr * hdr = (struct ieee80211_hdr *)skb->data;
+	int padpos, padsize;
 
 	ath_print(common, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
 
@@ -1853,14 +1854,14 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	padsize = hdrlen & 3;
-	if (padsize && hdrlen >= 24) {
+	padpos = ath9k_cmn_padpos(hdr->frame_control);
+	padsize = padpos & 3;
+	if (padsize && skb->len>padpos+padsize) {
 		/*
 		 * Remove MAC header padding before giving the frame back to
 		 * mac80211.
 		 */
-		memmove(skb->data + padsize, skb->data, hdrlen);
+		memmove(skb->data + padsize, skb->data, padpos);
 		skb_pull(skb, padsize);
 	}
 
-- 
1.6.5

