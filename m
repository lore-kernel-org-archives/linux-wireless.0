Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46854 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbZHLQ5E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 12:57:04 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 09:57:06 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<ath5k-devel@lists.ath5k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/3] ath5k: use common ath.ko ath_rxbuf_alloc()
Date: Wed, 12 Aug 2009 09:57:00 -0700
Message-ID: <1250096221-11000-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
References: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that its shared we can remove ath5k's own implementation.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   21 +++++++--------------
 drivers/net/wireless/ath/ath5k/base.h |    3 ++-
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index acbcfc2..63c2b57 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -544,7 +544,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	__set_bit(ATH_STAT_INVALID, sc->status);
 
 	sc->iobase = mem; /* So we can unmap it on detach */
-	sc->cachelsz = csz * sizeof(u32); /* convert to bytes */
+	sc->common.cachelsz = csz * sizeof(u32); /* convert to bytes */
 	sc->opmode = NL80211_IFTYPE_STATION;
 	sc->bintval = 1000;
 	mutex_init(&sc->lock);
@@ -1151,27 +1151,20 @@ static
 struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
 {
 	struct sk_buff *skb;
-	unsigned int off;
 
 	/*
 	 * Allocate buffer with headroom_needed space for the
 	 * fake physical layer header at the start.
 	 */
-	skb = dev_alloc_skb(sc->rxbufsize + sc->cachelsz - 1);
+	skb = ath_rxbuf_alloc(&sc->common,
+			      sc->rxbufsize + sc->common.cachelsz - 1,
+			      GFP_ATOMIC);
 
 	if (!skb) {
 		ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
-				sc->rxbufsize + sc->cachelsz - 1);
+				sc->rxbufsize + sc->common.cachelsz - 1);
 		return NULL;
 	}
-	/*
-	 * Cache-line-align.  This is important (for the
-	 * 5210 at least) as not doing so causes bogus data
-	 * in rx'd frames.
-	 */
-	off = ((unsigned long)skb->data) % sc->cachelsz;
-	if (off != 0)
-		skb_reserve(skb, sc->cachelsz - off);
 
 	*skb_addr = pci_map_single(sc->pdev,
 		skb->data, sc->rxbufsize, PCI_DMA_FROMDEVICE);
@@ -1613,10 +1606,10 @@ ath5k_rx_start(struct ath5k_softc *sc)
 	struct ath5k_buf *bf;
 	int ret;
 
-	sc->rxbufsize = roundup(IEEE80211_MAX_LEN, sc->cachelsz);
+	sc->rxbufsize = roundup(IEEE80211_MAX_LEN, sc->common.cachelsz);
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rxbufsize %u\n",
-		sc->cachelsz, sc->rxbufsize);
+		sc->common.cachelsz, sc->rxbufsize);
 
 	spin_lock_bh(&sc->rxbuflock);
 	sc->rxlink = NULL;
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 667bd9d..25a72a8 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -50,6 +50,7 @@
 
 #include "ath5k.h"
 #include "debug.h"
+#include "../ath.h"
 
 #define	ATH_RXBUF	40		/* number of RX buffers */
 #define	ATH_TXBUF	200		/* number of TX buffers */
@@ -112,6 +113,7 @@ struct ath5k_rfkill {
  * associated with an instance of a device */
 struct ath5k_softc {
 	struct pci_dev		*pdev;		/* for dma mapping */
+	struct ath_common	common;
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
 	struct ieee80211_tx_queue_stats tx_stats[AR5K_NUM_TX_QUEUES];
@@ -134,7 +136,6 @@ struct ath5k_softc {
 	struct ath5k_desc	*desc;		/* TX/RX descriptors */
 	dma_addr_t		desc_daddr;	/* DMA (physical) address */
 	size_t			desc_len;	/* size of TX/RX descriptors */
-	u16			cachelsz;	/* cache line size */
 
 	DECLARE_BITMAP(status, 5);
 #define ATH_STAT_INVALID	0		/* disable hardware accesses */
-- 
1.6.3.3

