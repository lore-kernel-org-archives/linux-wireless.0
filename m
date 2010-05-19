Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:7293 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752708Ab0ESBQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:16:49 -0400
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0432871807
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:16:47 +0900 (JST)
Subject: [PATCH 2] ath5k: consistently use rx_bufsize for RX DMA
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:15:35 +0900
Message-ID: <20100519011535.20577.69254.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should use the same buffer size we set up for DMA also in the hardware
descriptor. Previously we used common->rx_bufsize for setting up the DMA
mapping, but used skb_tailroom(skb) for the size we tell to the hardware in the
descriptor itself. The problem is that skb_tailroom(skb) can give us a larger
value than the size we set up for DMA before. This allows the hardware to write
into memory locations not set up for DMA. In practice this should rarely happen
because all packets should be smaller than the maximum 802.11 packet size.

On the tested platform rx_bufsize is 2528, and we allocated an skb of 2559
bytes length (including padding for cache alignment) but sbk_tailroom() was
2592. Just consistently use rx_bufsize for all RX DMA memory sizes.

Also use the return value of the descriptor setup function.

TEST

Cc: stable@kernel.org
Signed-off-by: Bruno Randolf <br1@einfach.org>
Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9c27623..fbd5fc7 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1214,6 +1214,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	struct ath5k_hw *ah = sc->ah;
 	struct sk_buff *skb = bf->skb;
 	struct ath5k_desc *ds;
+	int ret;
 
 	if (!skb) {
 		skb = ath5k_rx_skb_alloc(sc, &bf->skbaddr);
@@ -1240,9 +1241,9 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
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

