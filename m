Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37784 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601AbZC3KF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:05:56 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:05:55 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.39039.925882.550406@gargle.gargle.HOWL> (sfid-20090330_120558_056201_969FF799)
Date: Mon, 30 Mar 2009 15:31:35 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 06/17] ath9k: Avoid unneeded casts
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the void pointer to struct sk_buff and access
bf_mpdu directly, removing all casts in the process.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |    2 +-
 drivers/net/wireless/ath9k/beacon.c |   10 +++++-----
 drivers/net/wireless/ath9k/xmit.c   |   10 +++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 954b76d..3b8a8a7 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -134,7 +134,7 @@ struct ath_buf {
 	struct ath_buf *bf_lastbf;	/* last buf of this unit (a frame or
 					   an aggregate) */
 	struct ath_buf *bf_next;	/* next subframe in the aggregate */
-	void *bf_mpdu;			/* enclosing frame structure */
+	struct sk_buff *bf_mpdu;	/* enclosing frame structure */
 	struct ath_desc *bf_desc;	/* virtual addr of desc */
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 5b2752b..eb4759f 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -59,7 +59,7 @@ static int ath_beaconq_config(struct ath_softc *sc)
 static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 			     struct ath_buf *bf)
 {
-	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
+	struct sk_buff *skb = bf->bf_mpdu;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_desc *ds;
 	struct ath9k_11n_rate_series series[4];
@@ -138,7 +138,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 	/* Release the old beacon first */
 
 	bf = avp->av_bcbuf;
-	skb = (struct sk_buff *)bf->bf_mpdu;
+	skb = bf->bf_mpdu;
 	if (skb) {
 		dma_unmap_single(sc->dev, bf->bf_dmacontext,
 				 skb->len, DMA_TO_DEVICE);
@@ -226,7 +226,7 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc,
 		return;
 
 	bf = avp->av_bcbuf;
-	skb = (struct sk_buff *) bf->bf_mpdu;
+	skb = bf->bf_mpdu;
 
 	ath_beacon_setup(sc, avp, bf);
 
@@ -299,7 +299,7 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 	/* release the previous beacon frame, if it already exists. */
 	bf = avp->av_bcbuf;
 	if (bf->bf_mpdu != NULL) {
-		skb = (struct sk_buff *)bf->bf_mpdu;
+		skb = bf->bf_mpdu;
 		dma_unmap_single(sc->dev, bf->bf_dmacontext,
 				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
@@ -371,7 +371,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 
 		bf = avp->av_bcbuf;
 		if (bf->bf_mpdu != NULL) {
-			struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
+			struct sk_buff *skb = bf->bf_mpdu;
 			dma_unmap_single(sc->dev, bf->bf_dmacontext,
 					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 689bdbf..87bbeaa 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -283,7 +283,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
 	bool rc_update = true;
 
-	skb = (struct sk_buff *)bf->bf_mpdu;
+	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
 
 	rcu_read_lock();
@@ -444,7 +444,7 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	u16 aggr_limit, legacy = 0, maxampdu;
 	int i;
 
-	skb = (struct sk_buff *)bf->bf_mpdu;
+	skb = bf->bf_mpdu;
 	tx_info = IEEE80211_SKB_CB(skb);
 	rates = tx_info->control.rates;
 	tx_info_priv = (struct ath_tx_info_priv *)tx_info->rate_driver_data[0];
@@ -1452,7 +1452,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 
 	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 
-	skb = (struct sk_buff *)bf->bf_mpdu;
+	skb = bf->bf_mpdu;
 	tx_info = IEEE80211_SKB_CB(skb);
 	rates = tx_info->control.rates;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -1586,7 +1586,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			     struct ath_tx_control *txctl)
 {
-	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
+	struct sk_buff *skb = bf->bf_mpdu;
 	struct ieee80211_tx_info *tx_info =  IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath_node *an = NULL;
@@ -1860,7 +1860,7 @@ static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
 static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds,
 			     int nbad, int txok, bool update_rc)
 {
-	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
+	struct sk_buff *skb = bf->bf_mpdu;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
-- 
1.6.2.1

