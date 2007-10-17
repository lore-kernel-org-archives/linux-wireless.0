Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.ics.forth.gr ([139.91.1.2]:38138 "EHLO
	mailgate.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbXJQWVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 18:21:13 -0400
Message-ID: <61462.77.49.14.172.1192655832.squirrel@webmail.ics.forth.gr> (sfid-20071017_232116_898301_F215CC5A)
Date: Thu, 18 Oct 2007 00:17:12 +0300 (EEST)
Subject: RE: [PATCH 2/4] ath5k: Only one tx descriptor per buffer,
      no need for ATH_TXDESC
From: mick@ics.forth.gr
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

diff --git a/drivers/net/wireless/ath5k/base.c
b/drivers/net/wireless/ath5k/base.c
index 6f55011..3a9652b 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2030,7 +2030,7 @@ static int ath_desc_alloc(struct ath_softc *sc,
struct pci_dev *pdev)

 	/* allocate descriptors */
 	sc->desc_len = sizeof(struct ath_desc) *
-			(ATH_TXBUF * ATH_TXDESC + ATH_RXBUF + ATH_BCBUF + 1);
+			(ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
 	sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
 	if (sc->desc == NULL) {
 		dev_err(&pdev->dev, "can't allocate descriptors\n");
@@ -2060,8 +2060,8 @@ static int ath_desc_alloc(struct ath_softc *sc,
struct pci_dev *pdev)

 	INIT_LIST_HEAD(&sc->txbuf);
 	sc->txbuf_len = ATH_TXBUF;
-	for (i = 0; i < ATH_TXBUF; i++, bf++, ds += ATH_TXDESC,
-			da += ATH_TXDESC * sizeof(*ds)) {
+	for (i = 0; i < ATH_TXBUF; i++, bf++, ds++,
+			da += sizeof(*ds)) {
 		bf->desc = ds;
 		bf->daddr = da;
 		list_add_tail(&bf->list, &sc->txbuf);
diff --git a/drivers/net/wireless/ath5k/base.h
b/drivers/net/wireless/ath5k/base.h
index 390d3d7..09e8dbe 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -63,7 +63,6 @@

 #define	ATH_RXBUF	40		/* number of RX buffers */
 #define	ATH_TXBUF	200		/* number of TX buffers */
-#define	ATH_TXDESC	1		/* number of descriptors per buffer */
 #define ATH_BCBUF	1		/* number of beacon buffers */
 #define	ATH_TXMAXTRY	11		/* max number of transmit attempts */
 #define	ATH_TXINTR_PERIOD 5		/* max number of batched tx descriptors */



