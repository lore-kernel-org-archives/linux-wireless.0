Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:19651 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757107AbXJOMah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 08:30:37 -0400
From: bruno randolf <bruno@thinktube.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: atheros hardware needs header padding
Date: Mon, 15 Oct 2007 21:30:38 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200710121946.30024.bruno@thinktube.com> <200710151634.33480.bruno@thinktube.com> <1192437116.3349.5.camel@johannes.berg>
In-Reply-To: <1192437116.3349.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710152130.38532.bruno@thinktube.com> (sfid-20071015_133041_396232_481C0256)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ok then, lets do it in the driver...

Author: Bruno Randolf <bruno@thinktube.com>
Date:   Mon Oct 15 19:46:59 2007 +0900

handle padding between header and data

Atheros hardware requires the header to be padded to 4 byte (32 bit)
boundaries. It expects the payload data to start at multiples of 4 byte for TX
frames and will add the padding for received frames. For most headers there is
no need for padding, since they are multiples of 4 already - except QoS and 4
address headers.

Changes-licensed-under: 3-clause-BSD
Signed-off-by: Bruno Randolf <bruno@thinktube.com>


diff --git a/drivers/net/wireless/ath5k/base.c 
b/drivers/net/wireless/ath5k/base.c
index 0997577..0a7cb41 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -375,6 +375,8 @@ static void ath_tasklet_rx(unsigned long data)
 	u16 len;
 	u8 stat;
 	int ret;
+	int hdrlen;
+	int pad;
 
 	spin_lock(&sc->rxbuflock);
 	do {
@@ -449,13 +451,20 @@ accept:
 				PCI_DMA_FROMDEVICE);
 		bf->skb = NULL;
 
-		if (unlikely((ieee80211_get_hdrlen_from_skb(skb) & 3) &&
-					net_ratelimit()))
-			printk(KERN_DEBUG "rx len is not %%4: %u\n",
-					ieee80211_get_hdrlen_from_skb(skb));
-
 		skb_put(skb, len);
 
+		/*
+		 * the hardware adds a padding to 4 byte boundaries between
+		 * the header and the payload data if the header length is
+		 * not multiples of 4 - remove it
+		 */
+		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+		if (hdrlen & 3) {
+			pad = hdrlen % 4;
+			memmove(skb->data + pad, skb->data, hdrlen);
+			skb_pull(skb, pad);
+		}
+
 		if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
 			rxs.mactime = ath_extend_tsf(sc->ah,
 					ds->ds_rxstat.rs_tstamp);
@@ -1153,7 +1162,7 @@ static int ath_tx_bf(struct ath_softc *sc, struct 
ath_buf *bf,
 	struct ath_txq *txq = sc->txq;
 	struct ath_desc *ds = bf->desc;
 	struct sk_buff *skb = bf->skb;
-	unsigned int hdrpad, pktlen, flags, keyidx = AR5K_TXKEYIX_INVALID;
+	unsigned int pktlen, flags, keyidx = AR5K_TXKEYIX_INVALID;
 	int ret;
 
 	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
@@ -1165,12 +1174,7 @@ static int ath_tx_bf(struct ath_softc *sc, struct 
ath_buf *bf,
 	if (ctl->flags & IEEE80211_TXCTL_NO_ACK)
 		flags |= AR5K_TXDESC_NOACK;
 
-	if ((ieee80211_get_hdrlen_from_skb(skb) & 3) && net_ratelimit())
-		printk(KERN_DEBUG "tx len is not %%4: %u\n",
-				ieee80211_get_hdrlen_from_skb(skb));
-
-	hdrpad = 0;
-	pktlen = skb->len - hdrpad + FCS_LEN;
+	pktlen = skb->len + FCS_LEN;
 
 	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)) {
 		keyidx = ctl->key_idx;
@@ -1214,12 +1218,32 @@ static int ath_tx(struct ieee80211_hw *hw, struct 
sk_buff *skb,
 	struct ath_softc *sc = hw->priv;
 	struct ath_buf *bf;
 	unsigned long flags;
+	int hdrlen;
+	int pad;
 
 	ath_dump_skb(skb, "t");
 
 	if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
 		DPRINTF(sc, ATH_DEBUG_XMIT, "tx in monitor (scan?)\n");
 
+	/*
+	 * the hardware expects the header padded to 4 byte boundaries
+	 * if this is not the case we add the padding after the header
+	 */
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	if (hdrlen & 3) {
+		pad = hdrlen % 4;
+		if (skb_headroom(skb) < pad) {
+			if (net_ratelimit())
+				printk(KERN_ERR "ath: tx hdrlen not %%4: %d "
+					"not enough headroom to pad %d\n",
+					hdrlen, pad);
+			return -1;
+		}
+		skb_push(skb, pad);
+		memmove(skb->data, skb->data+pad, hdrlen);
+	}
+
 	sc->led_txrate = ctl->tx_rate;
 
 	spin_lock_irqsave(&sc->txbuflock, flags);
