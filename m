Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:24468 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757742Ab0FPKMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:01 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-086873119
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:11:59 +0900 (JST)
Subject: [PATCH 06/17] ath5k: reset more pointers after we free skbs
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:11:41 +0900
Message-ID: <20100616101140.10067.46133.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After we free skbs for receive or transmit descriptors, make sure we have no
pointers to the now invalid memory address.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Acked-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 6c303d5..5479f85 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -322,6 +322,8 @@ static inline void ath5k_txbuf_free_skb(struct ath5k_softc *sc,
 			PCI_DMA_TODEVICE);
 	dev_kfree_skb_any(bf->skb);
 	bf->skb = NULL;
+	bf->skbaddr = 0;
+	bf->desc->ds_data = 0;
 }
 
 static inline void ath5k_rxbuf_free_skb(struct ath5k_softc *sc,
@@ -337,6 +339,8 @@ static inline void ath5k_rxbuf_free_skb(struct ath5k_softc *sc,
 			PCI_DMA_FROMDEVICE);
 	dev_kfree_skb_any(bf->skb);
 	bf->skb = NULL;
+	bf->skbaddr = 0;
+	bf->desc->ds_data = 0;
 }
 
 
@@ -1455,9 +1459,12 @@ ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
 
 	/* Free memory associated with all descriptors */
 	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
+	sc->desc = NULL;
+	sc->desc_daddr = 0;
 
 	kfree(sc->bufptr);
 	sc->bufptr = NULL;
+	sc->bbuf = NULL;
 }
 
 

