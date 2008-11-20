Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11979 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbYKTGOo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 01:14:44 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 22:14:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>, <zenczykowski@gmail.com>,
	<Bennyam.Malavazi@atheros.com>
Subject: [RFC 2/2] ath9k: correct expected max RX buffer size
Date: Wed, 19 Nov 2008 22:14:40 -0800
Message-ID: <1227161680-23229-3-git-send-email-lrodriguez@atheros.com> (sfid-20081120_071456_446791_5F05B3E8)
In-Reply-To: <1227161680-23229-2-git-send-email-lrodriguez@atheros.com>
References: <1227161680-23229-1-git-send-email-lrodriguez@atheros.com>
 <1227161680-23229-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should only tell the hardware its capable of DMA'ing
to us only what we asked dev_alloc_skb(). Prior to this
it is possible a large RX'd frame could have corrupted
DMA data but for us but we were saved only because we
were previously also pci_map_single()'ing the same large
value. The issue prior to this though was we were unmapping
a smaller amount which the prior DMA patch fixed.

Note that we dev_alloc_skb() a cache line size - 1 too
but this is just to help us offset the skb->data *if and only if*
needed. Even in that case we should still *only* allow the
hardware to DMA to us a buffer of size sc->sc_rxbufsize.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/recv.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 4355c16..0cd2a91 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -41,9 +41,11 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 	ASSERT(skb != NULL);
 	ds->ds_vdata = skb->data;
 
-	/* setup rx descriptors */
+	/* setup rx descriptors. The sc_rxbufsize here tells the harware
+	 * how much data it can DMA to us and that we are prepared
+	 * to process */
 	ath9k_hw_setuprxdesc(ah, ds,
-			     skb_tailroom(skb), /* buffer size */
+			     sc->sc_rxbufsize,
 			     0);
 
 	if (sc->sc_rxlink == NULL)
@@ -66,6 +68,13 @@ static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc, u32 len)
 	 * in rx'd frames.
 	 */
 
+	/* Note: the kernel can allocate a value greater than
+	 * what we ask it to give us. We really only need 4 KB as that
+	 * is this hardware supports and in fact we need at least 3849
+	 * as that is the MAX AMSDU size this hardware supports.
+	 * Unfortunately this means we may get 8 KB here from the
+	 * kernel... and that is actually what is observed on some
+	 * systems :( */
 	skb = dev_alloc_skb(len + sc->sc_cachelsz - 1);
 	if (skb != NULL) {
 		off = ((unsigned long) skb->data) % sc->sc_cachelsz;
-- 
1.5.6.rc2.15.g457bb.dirty

