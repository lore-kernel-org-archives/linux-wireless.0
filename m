Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:60379 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1LZR2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 12:28:12 -0500
Date: Mon, 26 Dec 2011 18:28:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] b43: fix regression in PIO case
In-Reply-To: <alpine.DEB.2.00.1112261608140.12108@axis700.grange>
Message-ID: <alpine.DEB.2.00.1112261824000.12108@axis700.grange> (sfid-20111226_182832_116580_A34B9A86)
References: <alpine.DEB.2.00.1112261608140.12108@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the regression, introduced by

commit 17030f48e31adde5b043741c91ba143f5f7db0fd
From: Rafa³ Mi³ecki <zajec5@gmail.com>
Date: Thu, 11 Aug 2011 17:16:27 +0200
Subject: [PATCH] b43: support new RX header, noticed to be used in 598.314+ fw

in PIO case.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index ce8a4bd..b64b64c 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -617,9 +617,19 @@ static bool pio_rx_frame(struct b43_pio_rxqueue *q)
 	const char *err_msg = NULL;
 	struct b43_rxhdr_fw4 *rxhdr =
 		(struct b43_rxhdr_fw4 *)wl->pio_scratchspace;
+	size_t rxhdr_size = sizeof(*rxhdr);
 
 	BUILD_BUG_ON(sizeof(wl->pio_scratchspace) < sizeof(*rxhdr));
-	memset(rxhdr, 0, sizeof(*rxhdr));
+	switch (dev->fw.hdr_format) {
+	case B43_FW_HDR_410:
+	case B43_FW_HDR_351:
+		rxhdr_size -= sizeof(rxhdr->format_598) -
+			sizeof(rxhdr->format_351);
+		break;
+	case B43_FW_HDR_598:
+		break;
+	}
+	memset(rxhdr, 0, rxhdr_size);
 
 	/* Check if we have data and wait for it to get ready. */
 	if (q->rev >= 8) {
@@ -657,11 +667,11 @@ data_ready:
 
 	/* Get the preamble (RX header) */
 	if (q->rev >= 8) {
-		b43_block_read(dev, rxhdr, sizeof(*rxhdr),
+		b43_block_read(dev, rxhdr, rxhdr_size,
 			       q->mmio_base + B43_PIO8_RXDATA,
 			       sizeof(u32));
 	} else {
-		b43_block_read(dev, rxhdr, sizeof(*rxhdr),
+		b43_block_read(dev, rxhdr, rxhdr_size,
 			       q->mmio_base + B43_PIO_RXDATA,
 			       sizeof(u16));
 	}
