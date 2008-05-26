Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbYEZOos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 10:44:48 -0400
Subject: [PATCH] ath5k: use IEEE80211_SKB_CB
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 26 May 2008 16:43:39 +0200
Message-Id: <1211813019.4843.9.camel@johannes.berg> (sfid-20080526_164451_160197_857B4CFD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k still uses the "(void*) skb->cb" direct cast, use IEEE80211_SKB_CB
instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath5k/base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- everything.orig/drivers/net/wireless/ath5k/base.c	2008-05-26 09:41:24.000000000 +0200
+++ everything/drivers/net/wireless/ath5k/base.c	2008-05-26 09:41:52.000000000 +0200
@@ -1296,7 +1296,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc
 	struct ath5k_txq *txq = sc->txq;
 	struct ath5k_desc *ds = bf->desc;
 	struct sk_buff *skb = bf->skb;
-	struct ieee80211_tx_info *info = (void*) skb->cb;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	unsigned int pktlen, flags, keyidx = AR5K_TXKEYIX_INVALID;
 	int ret;
 
@@ -1945,7 +1945,7 @@ ath5k_tx_processq(struct ath5k_softc *sc
 		}
 
 		skb = bf->skb;
-		info = (void*) skb->cb;
+		info = IEEE80211_SKB_CB(skb);
 		bf->skb = NULL;
 
 		pci_unmap_single(sc->pdev, bf->skbaddr, skb->len,
@@ -2003,7 +2003,7 @@ static int
 ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 {
 	struct sk_buff *skb = bf->skb;
-	struct	ieee80211_tx_info *info = (void*) skb->cb;
+	struct	ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath5k_hw *ah = sc->ah;
 	struct ath5k_desc *ds;
 	int ret, antenna = 0;
@@ -2625,7 +2625,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_buf *bf;
-	struct ieee80211_tx_info *info = (void*) skb->cb;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	unsigned long flags;
 	int hdrlen;
 	int pad;


