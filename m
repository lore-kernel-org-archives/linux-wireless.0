Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3419 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZDOL6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 07:58:38 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/5] ath5k: use rx hw descriptor pointer for self-linked check
Date: Wed, 15 Apr 2009 07:57:35 -0400
Message-Id: <1239796656-20646-5-git-send-email-me@bobcopeland.com> (sfid-20090415_135842_781984_FF23300D)
In-Reply-To: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
References: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch simplifies the code used to detect when the
self-linked DMA buffer is still in use by hardware, by
checking the hardware's rxdp register instead of looking
at the software buffer list.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   24 ++++--------------------
 drivers/net/wireless/ath/ath5k/base.h |    1 -
 drivers/net/wireless/ath/ath5k/dma.c  |    2 --
 3 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3bde18f..1a6e72f 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1780,7 +1780,7 @@ ath5k_tasklet_rx(unsigned long data)
 	struct sk_buff *skb, *next_skb;
 	dma_addr_t next_skb_addr;
 	struct ath5k_softc *sc = (void *)data;
-	struct ath5k_buf *bf, *bf_last;
+	struct ath5k_buf *bf;
 	struct ath5k_desc *ds;
 	int ret;
 	int hdrlen;
@@ -1791,7 +1791,6 @@ ath5k_tasklet_rx(unsigned long data)
 		ATH5K_WARN(sc, "empty rx buf pool\n");
 		goto unlock;
 	}
-	bf_last = list_entry(sc->rxbuf.prev, struct ath5k_buf, list);
 	do {
 		rxs.flag = 0;
 
@@ -1800,24 +1799,9 @@ ath5k_tasklet_rx(unsigned long data)
 		skb = bf->skb;
 		ds = bf->desc;
 
-		/*
-		 * last buffer must not be freed to ensure proper hardware
-		 * function. When the hardware finishes also a packet next to
-		 * it, we are sure, it doesn't use it anymore and we can go on.
-		 */
-		if (bf_last == bf)
-			bf->flags |= 1;
-		if (bf->flags) {
-			struct ath5k_buf *bf_next = list_entry(bf->list.next,
-					struct ath5k_buf, list);
-			ret = sc->ah->ah_proc_rx_desc(sc->ah, bf_next->desc,
-					&rs);
-			if (ret)
-				break;
-			bf->flags &= ~1;
-			/* skip the overwritten one (even status is martian) */
-			goto next;
-		}
+		/* bail if HW is still using self-linked descriptor */
+		if (ath5k_hw_get_rxdp(sc->ah) == bf->daddr)
+			break;
 
 		ret = sc->ah->ah_proc_rx_desc(sc->ah, ds, &rs);
 		if (unlikely(ret == -EINPROGRESS))
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 8229561..852b2c1 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -56,7 +56,6 @@
 
 struct ath5k_buf {
 	struct list_head	list;
-	unsigned int		flags;	/* rx descriptor flags */
 	struct ath5k_desc	*desc;	/* virtual addr of desc */
 	dma_addr_t		daddr;	/* physical addr of desc */
 	struct sk_buff		*skb;	/* skbuff for buf */
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index b65b4fe..941b511 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -80,8 +80,6 @@ int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
  * ath5k_hw_get_rxdp - Get RX Descriptor's address
  *
  * @ah: The &struct ath5k_hw
- *
- * XXX: Is RXDP read and clear ?
  */
 u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah)
 {
-- 
1.6.0.6


