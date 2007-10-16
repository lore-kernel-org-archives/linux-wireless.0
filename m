Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:27062 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965735AbXJPVi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 17:38:29 -0400
Received: by py-out-1112.google.com with SMTP id u77so3940385pyb
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 14:38:27 -0700 (PDT)
Message-ID: <40f31dec0710161438r163ece70r9db4e6571f4af30@mail.gmail.com> (sfid-20071016_223835_327595_2E281756)
Date: Wed, 17 Oct 2007 00:38:26 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Jiri Slaby" <jirislaby@gmail.com>
Subject: [PATCH 2/4] ath5k: Only one tx descriptor per buffer, no need for ATH_TXDESC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we don't (and probably won't) support fast frames we'll have
only one descriptor for each buffer so there is no need for
ATH_TXDESC.


Changes-licensed-under: 3-clause-BSD

Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
---
diff --git a/drivers/net/wireless/ath5k/base.c
b/drivers/net/wireless/ath5k/base.c
index 6f55011..3a9652b 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2030,7 +2030,7 @@ static int ath_desc_alloc(struct ath_softc *sc,
struct pci_dev *pdev)

        /* allocate descriptors */
        sc->desc_len = sizeof(struct ath_desc) *
-                       (ATH_TXBUF * ATH_TXDESC + ATH_RXBUF + ATH_BCBUF + 1);
+                       (ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
        sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
        if (sc->desc == NULL) {
                dev_err(&pdev->dev, "can't allocate descriptors\n");
@@ -2060,8 +2060,8 @@ static int ath_desc_alloc(struct ath_softc *sc,
struct pci_dev *pdev)

        INIT_LIST_HEAD(&sc->txbuf);
        sc->txbuf_len = ATH_TXBUF;
-       for (i = 0; i < ATH_TXBUF; i++, bf++, ds += ATH_TXDESC,
-                       da += ATH_TXDESC * sizeof(*ds)) {
+       for (i = 0; i < ATH_TXBUF; i++, bf++, ds++,
+                       da += sizeof(*ds)) {
                bf->desc = ds;
                bf->daddr = da;
                list_add_tail(&bf->list, &sc->txbuf);
diff --git a/drivers/net/wireless/ath5k/base.h
b/drivers/net/wireless/ath5k/base.h
index 390d3d7..09e8dbe 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -63,7 +63,6 @@

 #define        ATH_RXBUF       40              /* number of RX buffers */
 #define        ATH_TXBUF       200             /* number of TX buffers */
-#define        ATH_TXDESC      1               /* number of
descriptors per buffer */
 #define ATH_BCBUF      1               /* number of beacon buffers */
 #define        ATH_TXMAXTRY    11              /* max number of
transmit attempts */
 #define        ATH_TXINTR_PERIOD 5             /* max number of
batched tx descriptors */



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
