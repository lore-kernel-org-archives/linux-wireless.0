Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63072 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1AIUPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 15:15:15 -0500
Received: by fxm20 with SMTP id 20so18286204fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 Jan 2011 12:15:13 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] ath9k:  Implement rx copy-break.
Date: Sun, 9 Jan 2011 21:14:53 +0100
Cc: Ben Greear <greearb@candelatech.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
References: <1294500800-29191-1-git-send-email-greearb@candelatech.com> <4D290307.4080807@candelatech.com> <20110109181303.GA12562@jm.kir.nu>
In-Reply-To: <20110109181303.GA12562@jm.kir.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101092114.55534.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 09 January 2011 19:13:04 Jouni Malinen wrote:
> On Sat, Jan 08, 2011 at 04:36:23PM -0800, Ben Greear wrote:
> > On 01/08/2011 04:20 PM, Felix Fietkau wrote:
> > >On 2011-01-08 8:33 AM, greearb@candelatech.com wrote:
> > >>From: Ben Greear<greearb@candelatech.com>
> > >>This saves us constantly allocating large, multi-page
> > >>skbs. It should fix the order-1 allocation errors reported,
> > >>and in a 60-vif scenario, this significantly decreases CPU
> > >>utilization, and latency, and increases bandwidth.
> 
> As far as CPU use is concerned, 60 VIF scenario should not be the one to
> use for checking what is most efficient.. This really needs to be tested
> on something that uses a single VIF on an embedded (low-power CPU)..
> 
> For the order-1 allocation issues, it would be interesting to see if
> someone could take a look at using paged skbs or multiple RX descriptors
> with shorter skbs (and copying only for the case where a long frame is
> received so that only the A-MSDU RX case would suffer from extra
> copying).

Well, here's a shot at paged rx. It'll only work when PAGE_SIZE > buf_size
(which will be true for most system, I guess)

No idea how to handle EDMA... In fact I don't have any ath9k* solution
at the moment to test ;), so you better backup your data! 
---
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3681caf5..b113f44 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -227,6 +227,7 @@ struct ath_buf {
 					   an aggregate) */
 	struct ath_buf *bf_next;	/* next subframe in the aggregate */
 	struct sk_buff *bf_mpdu;	/* enclosing frame structure */
+	struct page *page;
 	void *bf_desc;			/* virtual addr of desc */
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;	/* physical addr of data buffer, for DMA */
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b2497b8..acdf6ae 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -313,10 +313,13 @@ static void ath_edma_stop_recv(struct ath_softc *sc)
 int ath_rx_init(struct ath_softc *sc, int nbufs)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct sk_buff *skb;
+	struct page *page;
 	struct ath_buf *bf;
 	int error = 0;
 
+	if (WARN_ON(common->rx_bufsize > PAGE_SIZE))
+		return -EIO;
+
 	spin_lock_init(&sc->sc_pcu_lock);
 	sc->sc_flags &= ~SC_OP_RXFLUSH;
 	spin_lock_init(&sc->rx.rxbuflock);
@@ -342,27 +345,26 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 		}
 
 		list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-			skb = ath_rxbuf_alloc(common, common->rx_bufsize,
-					      GFP_KERNEL);
-			if (skb == NULL) {
+			page = alloc_pages(GFP_KERNEL | __GFP_ZERO, 0);
+			if (page == NULL) {
 				error = -ENOMEM;
 				goto err;
 			}
 
-			bf->bf_mpdu = skb;
-			bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
-					common->rx_bufsize,
-					DMA_FROM_DEVICE);
+			bf->bf_mpdu = NULL;
+			bf->bf_buf_addr = dma_map_page(sc->dev, page, 0,
+						       PAGE_SIZE,
+						       DMA_FROM_DEVICE);
 			if (unlikely(dma_mapping_error(sc->dev,
 							bf->bf_buf_addr))) {
-				dev_kfree_skb_any(skb);
-				bf->bf_mpdu = NULL;
+				__free_pages(page, 0);
 				bf->bf_buf_addr = 0;
 				ath_err(common,
 					"dma_mapping_error() on RX init\n");
 				error = -ENOMEM;
 				goto err;
 			}
+			bf->page = page;
 		}
 		sc->rx.rxlink = NULL;
 	}
@@ -378,7 +380,7 @@ void ath_rx_cleanup(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct sk_buff *skb;
+	struct page *page;
 	struct ath_buf *bf;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
@@ -386,14 +388,15 @@ void ath_rx_cleanup(struct ath_softc *sc)
 		return;
 	} else {
 		list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-			skb = bf->bf_mpdu;
-			if (skb) {
-				dma_unmap_single(sc->dev, bf->bf_buf_addr,
-						common->rx_bufsize,
-						DMA_FROM_DEVICE);
-				dev_kfree_skb(skb);
+			page = bf->page;
+			bf->page = NULL;
+
+			if (page) {
+				dma_unmap_page(sc->dev, bf->bf_buf_addr,
+					       PAGE_SIZE,
+					       DMA_FROM_DEVICE);
+				__free_pages(page, 0);
 				bf->bf_buf_addr = 0;
-				bf->bf_mpdu = NULL;
 			}
 		}
 
@@ -663,12 +666,10 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 }
 
 static void ath_rx_send_to_mac80211(struct ieee80211_hw *hw,
-				    struct ath_softc *sc, struct sk_buff *skb)
+				    struct ath_softc *sc,
+				    struct sk_buff *skb,
+				    struct ieee80211_hdr *hdr)
 {
-	struct ieee80211_hdr *hdr;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-
 	/* Send the frame to mac80211 */
 	if (is_multicast_ether_addr(hdr->addr1)) {
 		int i;
@@ -1037,21 +1038,20 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 }
 
 static void ath9k_rx_skb_postprocess(struct ath_common *common,
-				     struct sk_buff *skb,
+				     struct ieee80211_hdr *hdr,
+				     size_t *len,
 				     struct ath_rx_status *rx_stats,
 				     struct ieee80211_rx_status *rxs,
 				     bool decrypt_error)
 {
 	struct ath_hw *ah = common->ah;
-	struct ieee80211_hdr *hdr;
 	int hdrlen, padpos, padsize;
 	u8 keyix;
 	__le16 fc;
 
 	/* see if any padding is done by the hw and remove it */
-	hdr = (struct ieee80211_hdr *) skb->data;
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	fc = hdr->frame_control;
+	hdrlen = *len >= 2 ? ieee80211_hdrlen(fc) : 0;
 	padpos = ath9k_cmn_padpos(hdr->frame_control);
 
 	/* The MAC header is padded to have 32-bit boundary if the
@@ -1063,9 +1063,9 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 	 * not try to remove padding from short control frames that do
 	 * not have payload. */
 	padsize = padpos & 3;
-	if (padsize && skb->len>=padpos+padsize+FCS_LEN) {
-		memmove(skb->data + padsize, skb->data, padpos);
-		skb_pull(skb, padsize);
+	if (padsize && *len >= padpos + padsize + FCS_LEN) {
+		memmove(hdr + padsize, hdr, padpos);
+		*len -= padsize;
 	}
 
 	keyix = rx_stats->rs_keyix;
@@ -1074,8 +1074,10 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 	    ieee80211_has_protected(fc)) {
 		rxs->flag |= RX_FLAG_DECRYPTED;
 	} else if (ieee80211_has_protected(fc)
-		   && !decrypt_error && skb->len >= hdrlen + 4) {
-		keyix = skb->data[hdrlen + 3] >> 6;
+		   && !decrypt_error && *len >= hdrlen + 4) {
+		u8 *data = (u8 *)hdr;
+
+		keyix = data[hdrlen + 3] >> 6;
 
 		if (test_bit(keyix, common->keymap))
 			rxs->flag |= RX_FLAG_DECRYPTED;
@@ -1623,7 +1625,8 @@ div_comb_done:
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 {
 	struct ath_buf *bf;
-	struct sk_buff *skb = NULL, *requeue_skb;
+	struct sk_buff *skb = NULL;
+	struct page *requeue_page;
 	struct ieee80211_rx_status *rxs;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1634,6 +1637,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	 */
 	struct ieee80211_hw *hw = NULL;
 	struct ieee80211_hdr *hdr;
+	size_t data_len;
 	int retval;
 	bool decrypt_error = false;
 	struct ath_rx_status rs;
@@ -1670,9 +1674,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (!bf)
 			break;
 
-		skb = bf->bf_mpdu;
+		skb = dev_alloc_skb(128);
 		if (!skb)
-			continue;
+			goto requeue;
 
 		hdr = (struct ieee80211_hdr *) (skb->data + rx_status_len);
 		rxs =  IEEE80211_SKB_RXCB(skb);
@@ -1704,41 +1708,40 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
-		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
+		requeue_page = alloc_pages(GFP_ATOMIC, 0);
 
 		/* If there is no memory we ignore the current RX'd frame,
 		 * tell hardware it can give us a new frame using the old
 		 * skb and put it at the tail of the sc->rx.rxbuf list for
 		 * processing. */
-		if (!requeue_skb)
+		if (!requeue_page) {
+			dev_kfree_skb_any(skb);
 			goto requeue;
+		}
 
 		/* Unmap the frame */
-		dma_unmap_single(sc->dev, bf->bf_buf_addr,
-				 common->rx_bufsize,
-				 dma_type);
+		dma_unmap_page(sc->dev, bf->bf_buf_addr, PAGE_SIZE, dma_type);
 
-		skb_put(skb, rs.rs_datalen + ah->caps.rx_status_len);
-		if (ah->caps.rx_status_len)
-			skb_pull(skb, ah->caps.rx_status_len);
+		data_len = rs.rs_datalen;
+		ath9k_rx_skb_postprocess(common, page_address(bf->page),
+					 &data_len, &rs, rxs, decrypt_error);
 
-		ath9k_rx_skb_postprocess(common, skb, &rs,
-					 rxs, decrypt_error);
+		skb_add_rx_frag(skb, 0, bf->page, ah->caps.rx_status_len,
+				data_len);
 
 		/* We will now give hardware our shiny new allocated skb */
-		bf->bf_mpdu = requeue_skb;
-		bf->bf_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
-						 common->rx_bufsize,
-						 dma_type);
+		bf->bf_buf_addr = dma_map_page(sc->dev, requeue_page, 0,
+					       PAGE_SIZE, dma_type);
 		if (unlikely(dma_mapping_error(sc->dev,
 			  bf->bf_buf_addr))) {
-			dev_kfree_skb_any(requeue_skb);
-			bf->bf_mpdu = NULL;
+			__free_pages(requeue_page, 0);
 			bf->bf_buf_addr = 0;
 			ath_err(common, "dma_mapping_error() on RX\n");
-			ath_rx_send_to_mac80211(hw, sc, skb);
+			ath_rx_send_to_mac80211(hw, sc, skb,
+						page_address(bf->page));
 			break;
 		}
+		bf->page = requeue_page;
 
 		/*
 		 * change the default rx antenna if rx diversity chooses the
@@ -1763,7 +1766,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
 			ath_ant_comb_scan(sc, &rs);
 
-		ath_rx_send_to_mac80211(hw, sc, skb);
+		ath_rx_send_to_mac80211(hw, sc, skb, page_address(bf->page));
 
 requeue:
 		if (edma) {

