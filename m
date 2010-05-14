Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:10030 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752671Ab0ENHvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 03:51:22 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0526163477
	for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 16:51:19 +0900 (JST)
Subject: [PATCH] ath5k: consistently use rx_bufsize for RX DMA
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com
Date: Fri, 14 May 2010 16:50:56 +0900
Message-ID: <20100514074833.10333.81592.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should use the same buffer size we set up for DMA also in the hardware
descriptor. Previously we used common->rx_bufsize for setting up the DMA
mapping, but skb_tailroom(skb) for the size we tell to the hardware in the
descriptor itself. The problem is that skb_tailroom(skb) can give us a larger
value than the size we set up for DMA before: In my case rx_bufsize is 2528,
and we allocated an skb of 2559 bytes length, including padding for cache
alignment, but sbk_tailroom() was 2592. Just consistently use rx_bufsize for
all RX DMA memory sizes.

Also check the return value of setup function.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

PS: I'm not sure if this is enough to fix bug 15861, but it's definetly one
possibility where the hardware could write out of bounds. But the bug report
looks too similar to the ath9k one, so i suspect a common bug between ath5k and
ath9k. (?)

---
 drivers/net/wireless/ath/ath5k/base.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9f42af7..5f24e4a 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1217,6 +1217,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	struct ath5k_hw *ah = sc->ah;
 	struct sk_buff *skb = bf->skb;
 	struct ath5k_desc *ds;
+	int ret;
 
 	if (!skb) {
 		skb = ath5k_rx_skb_alloc(sc, &bf->skbaddr);
@@ -1243,9 +1244,9 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	ds = bf->desc;
 	ds->ds_link = bf->daddr;	/* link to self */
 	ds->ds_data = bf->skbaddr;
-	ah->ah_setup_rx_desc(ah, ds,
-		skb_tailroom(skb),	/* buffer size */
-		0);
+	ret = ah->ah_setup_rx_desc(ah, ds, ah->common.rx_bufsize, 0);
+	if (ret)
+		return ret;
 
 	if (sc->rxlink != NULL)
 		*sc->rxlink = bf->daddr;

