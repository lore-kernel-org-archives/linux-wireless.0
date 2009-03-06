Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37039 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZCFFyf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 00:54:35 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 21:54:34 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 1/4] ath9k: Get rid of unnecessary ATOMIC memory alloc during init time
Date: Fri, 6 Mar 2009 11:24:08 +0530
Message-ID: <1236318851-7500-2-git-send-email-senthilkumar@atheros.com> (sfid-20090306_065436_693071_C28E0808)
In-Reply-To: <1236318851-7500-1-git-send-email-senthilkumar@atheros.com>
References: <1236318851-7500-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can sleep for memory during init time and so allocating rx buffers,
descriptro buffers with GFP_KERNEL should help us to get rid of transient
alloc fails.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    5 ++---
 drivers/net/wireless/ath9k/recv.c |    8 ++++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index bb30ccc..4bc43db 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1804,7 +1804,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 
 	/* allocate descriptors */
 	dd->dd_desc = dma_alloc_coherent(sc->dev, dd->dd_desc_len,
-					 &dd->dd_desc_paddr, GFP_ATOMIC);
+					 &dd->dd_desc_paddr, GFP_KERNEL);
 	if (dd->dd_desc == NULL) {
 		error = -ENOMEM;
 		goto fail;
@@ -1816,12 +1816,11 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 
 	/* allocate buffers */
 	bsize = sizeof(struct ath_buf) * nbuf;
-	bf = kmalloc(bsize, GFP_KERNEL);
+	bf = kzalloc(bsize, GFP_KERNEL);
 	if (bf == NULL) {
 		error = -ENOMEM;
 		goto fail2;
 	}
-	memset(bf, 0, bsize);
 	dd->dd_bufptr = bf;
 
 	INIT_LIST_HEAD(head);
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 3df5c78..9439cb3 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -100,7 +100,7 @@ static u64 ath_extend_tsf(struct ath_softc *sc, u32 rstamp)
 	return (tsf & ~0x7fff) | rstamp;
 }
 
-static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc, u32 len)
+static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc, u32 len, gfp_t gfp_mask)
 {
 	struct sk_buff *skb;
 	u32 off;
@@ -118,7 +118,7 @@ static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc, u32 len)
 	 * Unfortunately this means we may get 8 KB here from the
 	 * kernel... and that is actually what is observed on some
 	 * systems :( */
-	skb = dev_alloc_skb(len + sc->cachelsz - 1);
+	skb = __dev_alloc_skb(len + sc->cachelsz - 1, gfp_mask);
 	if (skb != NULL) {
 		off = ((unsigned long) skb->data) % sc->cachelsz;
 		if (off != 0)
@@ -306,7 +306,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 		}
 
 		list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-			skb = ath_rxbuf_alloc(sc, sc->rx.bufsize);
+			skb = ath_rxbuf_alloc(sc, sc->rx.bufsize, GFP_KERNEL);
 			if (skb == NULL) {
 				error = -ENOMEM;
 				break;
@@ -580,7 +580,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
-		requeue_skb = ath_rxbuf_alloc(sc, sc->rx.bufsize);
+		requeue_skb = ath_rxbuf_alloc(sc, sc->rx.bufsize, GFP_ATOMIC);
 
 		/* If there is no memory we ignore the current RX'd frame,
 		 * tell hardware it can give us a new frame using the old
-- 
1.6.0.4

