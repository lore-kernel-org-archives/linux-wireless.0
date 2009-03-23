Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbZCWWY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 18:24:27 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ath9k: fix dma mapping leak of rx buffer upon rmmod
Date: Mon, 23 Mar 2009 18:24:23 -0400
Message-Id: <1237847063-30083-1-git-send-email-lrodriguez@atheros.com> (sfid-20090323_232430_743987_5B16A9FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were claiming DMA buffers on the RX tasklet but never
upon a simple module removal.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/recv.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 917bac7..71cb18d 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -344,8 +344,13 @@ void ath_rx_cleanup(struct ath_softc *sc)
 
 	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
 		skb = bf->bf_mpdu;
-		if (skb)
+		if (skb) {
+			dma_unmap_single(sc->dev,
+					 bf->bf_buf_addr,
+					 sc->rx.bufsize,
+					 DMA_FROM_DEVICE);
 			dev_kfree_skb(skb);
+		}
 	}
 
 	if (sc->rx.rxdma.dd_desc_len != 0)
-- 
1.5.6.4

