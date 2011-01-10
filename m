Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47696 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656Ab1AJMkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 07:40:15 -0500
Date: Mon, 10 Jan 2011 14:40:03 +0200
From: Jouni Malinen <j@w1.fi>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Implement rx copy-break.
Message-ID: <20110110124003.GA18713@jm.kir.nu>
References: <1294500800-29191-1-git-send-email-greearb@candelatech.com>
 <4D290307.4080807@candelatech.com>
 <20110109181303.GA12562@jm.kir.nu>
 <201101092114.55534.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201101092114.55534.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 09, 2011 at 09:14:53PM +0100, Christian Lamparter wrote:
> On Sunday 09 January 2011 19:13:04 Jouni Malinen wrote:
> > For the order-1 allocation issues, it would be interesting to see if
> > someone could take a look at using paged skbs or multiple RX descriptors
> > with shorter skbs (and copying only for the case where a long frame is
> > received so that only the A-MSDU RX case would suffer from extra
> > copying).
> 
> Well, here's a shot at paged rx. It'll only work when PAGE_SIZE > buf_size
> (which will be true for most system, I guess)

Thanks!

For the multiple RX descriptors (fragmented buffer for DMA) part, here's
a very preliminary patch to show how it could be done in ath9k for
anyone who might want to experiment more in this area. This version is
obviously only helping with large allocations (it uses half the buffer
size). The extra copying is there for large A-MSDU case. Though, I did
add some concept code to use skb frag_list to allow such a frame be
delivered to mac80211 without needing any extra allocation/copying. That
is commented out for now, if mac80211 can be made to handle A-MSDU RX
processing with fragmented data (which should be relatively simple
change, I'd hope), there should be no need for doing the extra copy in
ath9k. (And likewise, I was too lazy to handle the EDMA case for now..)

The version here is limited to at maximum two fragments. If desired,
this could be further extended to handle multiple fragments to get the
default RX skb allocation shorter than 2k (i.e., to cover the normal
1500 MTU). I'm not sure whether that would result in noticeable benefit,
but it could help in saving some memory when there are multiple skbs
queued in various places in the networking stack. Likewise, the maximum
A-MSDU receive length could be extended with this approach without
having to use even longer individual buffers for RX.

---
 drivers/net/wireless/ath/ath9k/hw.h   |    2 
 drivers/net/wireless/ath/ath9k/main.c |    5 +
 drivers/net/wireless/ath/ath9k/recv.c |  102 +++++++++++++++++++++++++++++-----
 3 files changed, 95 insertions(+), 14 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/hw.h	2011-01-10 13:03:16.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/hw.h	2011-01-10 13:15:39.000000000 +0200
@@ -852,6 +852,8 @@ struct ath_hw {
 
 	/* Enterprise mode cap */
 	u32 ent_mode;
+
+	struct sk_buff *rx_frag;
 };
 
 static inline struct ath_common *ath9k_hw_common(struct ath_hw *ah)
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2011-01-10 13:14:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2011-01-10 13:15:05.000000000 +0200
@@ -1320,6 +1320,11 @@ static void ath9k_stop(struct ieee80211_
 	} else
 		sc->rx.rxlink = NULL;
 
+	if (ah->rx_frag) {
+		dev_kfree_skb_any(ah->rx_frag);
+		ah->rx_frag = NULL;
+	}
+
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(ah);
 	ath9k_hw_configpcipowersave(ah, 1, 1);
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/recv.c	2011-01-10 12:24:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/recv.c	2011-01-10 14:29:29.000000000 +0200
@@ -324,8 +324,19 @@ int ath_rx_init(struct ath_softc *sc, in
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		return ath_rx_edma_init(sc, nbufs);
 	} else {
-		common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
+		/*
+		 * Use a buffer that allows a full frame to be received in at
+		 * most two buffers with scattering DMA. This is needed for
+		 * A-MSDU; other cases will fit in a single buffer. This will
+		 * allow the skbs to fit in a single page to avoid issues with
+		 * higher order allocation.
+		 */
+		common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN / 2,
 				min(common->cachelsz, (u16)64));
+#if 0 /* TESTING - force two fragments even without A-MSDU */
+		common->rx_bufsize = roundup(2800 / 2,
+				min(common->cachelsz, (u16)64));
+#endif
 
 		ath_dbg(common, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
 			common->cachelsz, common->rx_bufsize);
@@ -863,16 +874,6 @@ static bool ath9k_rx_accept(struct ath_c
 		return false;
 
 	/*
-	 * rs_more indicates chained descriptors which can be used
-	 * to link buffers together for a sort of scatter-gather
-	 * operation.
-	 * reject the frame, we don't support scatter-gather yet and
-	 * the frame is probably corrupt anyway
-	 */
-	if (rx_stats->rs_more)
-		return false;
-
-	/*
 	 * The rx_stats->rs_status will not be set until the end of the
 	 * chained descriptors so it can be ignored if rs_more is set. The
 	 * rs_more will be false at the last element of the chained
@@ -1022,6 +1023,9 @@ static int ath9k_rx_skb_preprocess(struc
 	if (!ath9k_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error))
 		return -EINVAL;
 
+	if (rx_stats->rs_more)
+		return 0; /* Only use data from the last fragment */
+
 	ath9k_process_rssi(common, hw, hdr, rx_stats);
 
 	if (ath9k_process_rate(common, hw, rx_stats, rx_status))
@@ -1674,7 +1678,16 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		if (!skb)
 			continue;
 
-		hdr = (struct ieee80211_hdr *) (skb->data + rx_status_len);
+		/*
+		 * Take frame header from the first fragment and RX status from
+		 * the last one.
+		 */
+		if (ah->rx_frag)
+			hdr = (struct ieee80211_hdr *)
+				(ah->rx_frag->data + rx_status_len);
+		else
+			hdr = (struct ieee80211_hdr *)
+				(skb->data + rx_status_len);
 		rxs =  IEEE80211_SKB_RXCB(skb);
 
 		hw = ath_get_virt_hw(sc, hdr);
@@ -1718,12 +1731,14 @@ int ath_rx_tasklet(struct ath_softc *sc,
 				 common->rx_bufsize,
 				 dma_type);
 
+		/* FIX: for fragmented frames, only one rx_status_len */
 		skb_put(skb, rs.rs_datalen + ah->caps.rx_status_len);
 		if (ah->caps.rx_status_len)
 			skb_pull(skb, ah->caps.rx_status_len);
 
-		ath9k_rx_skb_postprocess(common, skb, &rs,
-					 rxs, decrypt_error);
+		if (!ah->rx_frag && !rs.rs_more)
+			ath9k_rx_skb_postprocess(common, skb, &rs,
+						 rxs, decrypt_error);
 
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;
@@ -1740,6 +1755,65 @@ int ath_rx_tasklet(struct ath_softc *sc,
 			break;
 		}
 
+		if (rs.rs_more) {
+			/*
+			 * rs_more indicates chained descriptors which can be
+			 * used to link buffers together for a sort of
+			 * scatter-gather operation.
+			 */
+			if (ah->rx_frag) {
+				printk(KERN_DEBUG "%s:dropped prev rx_frag\n",
+				       __func__);
+				dev_kfree_skb_any(ah->rx_frag);
+			}
+			ah->rx_frag = skb;
+			goto requeue;
+		}
+		if (ah->rx_frag) {
+#if 1
+			struct sk_buff *nskb;
+			/*
+			 * This is the final fragment of the frame - merge with
+			 * previously received data.
+			 */
+			nskb = skb_copy_expand(ah->rx_frag, 0, skb->len,
+					       GFP_ATOMIC);
+			dev_kfree_skb_any(ah->rx_frag);
+			ah->rx_frag = NULL;
+			if (nskb == NULL) {
+				dev_kfree_skb_any(skb);
+				goto requeue;
+			}
+			skb_copy_from_linear_data(skb, skb_put(nskb, skb->len),
+						  skb->len);
+			/* Take RX status for the last fragment */
+			memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
+			dev_kfree_skb_any(skb);
+			skb = nskb;
+#else
+			/*
+			 * TODO: This should really be optimized by using
+			 * skb frag_list etc. to avoid new allocation and
+			 * copying of data here. The fragmentation case will
+			 * only happen when receiving A-MSDU aggregates and
+			 * mac80211 will end up re-allocating and splitting
+			 * those anyway. Once mac80211 is able to do this based
+			 * on multiple fragments, alloc+copy code above can
+			 * be replaced with something like following.
+			 */
+			/* Take RX status for the last fragment */
+			memcpy(ah->rx_frag->cb, skb->cb, sizeof(skb->cb));
+			/* Link the fragments together using frag_list */
+			skb_frag_list_init(ah->rx_frag);
+			skb_frag_add_head(ah->rx_frag, skb);
+			skb = ah->rx_frag;
+			ah->rx_frag = NULL;
+#endif
+			rxs = IEEE80211_SKB_RXCB(skb);
+			ath9k_rx_skb_postprocess(common, skb, &rs,
+						 rxs, decrypt_error);
+		}
+
 		/*
 		 * change the default rx antenna if rx diversity chooses the
 		 * other antenna 3 times in a row.

-- 
Jouni Malinen                                            PGP id EFC895FA
