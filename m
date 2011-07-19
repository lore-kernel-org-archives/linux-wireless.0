Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:63574 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1GSWWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 18:22:30 -0400
Received: by fxd18 with SMTP id 18so591510fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 15:22:29 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: disable parity check on BCMA devices
Date: Wed, 20 Jul 2011 01:01:13 +0200
Message-Id: <1311116473-3850-1-git-send-email-zajec5@gmail.com> (sfid-20110720_002233_892593_AED848B3)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Analyze of MMIO dumps from BCM43224, BCM43225, BCM4313 and BCM4331 has
shown that wl disables parity check for all that cards. This is required
for receiving any packets from the hardware.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This patch requires:
[PATCH 3/3] b43: bcma: get DMA translation bits
---
 drivers/net/wireless/b43/b43.h |    1 +
 drivers/net/wireless/b43/dma.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 8cf0459..c818b0b 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -594,6 +594,7 @@ struct b43_dma {
 	struct b43_dmaring *rx_ring;
 
 	u32 translation; /* Routing bits */
+	bool parity; /* Check for parity */
 };
 
 struct b43_pio_txqueue;
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 0a5004b..755bd39 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -659,6 +659,7 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 	u32 value;
 	u32 addrext;
 	u32 trans = ring->dev->dma.translation;
+	bool parity = ring->dev->dma.parity;
 
 	if (ring->tx) {
 		if (ring->type == B43_DMA_64BIT) {
@@ -669,6 +670,8 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			value = B43_DMA64_TXENABLE;
 			value |= (addrext << B43_DMA64_TXADDREXT_SHIFT)
 			    & B43_DMA64_TXADDREXT_MASK;
+			if (!parity)
+				value |= B43_DMA64_TXPARITYDISABLE;
 			b43_dma_write(ring, B43_DMA64_TXCTL, value);
 			b43_dma_write(ring, B43_DMA64_TXRINGLO,
 				      (ringbase & 0xFFFFFFFF));
@@ -684,6 +687,8 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			value = B43_DMA32_TXENABLE;
 			value |= (addrext << B43_DMA32_TXADDREXT_SHIFT)
 			    & B43_DMA32_TXADDREXT_MASK;
+			if (!parity)
+				value |= B43_DMA32_TXPARITYDISABLE;
 			b43_dma_write(ring, B43_DMA32_TXCTL, value);
 			b43_dma_write(ring, B43_DMA32_TXRING,
 				      (ringbase & ~SSB_DMA_TRANSLATION_MASK)
@@ -702,6 +707,8 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			value |= B43_DMA64_RXENABLE;
 			value |= (addrext << B43_DMA64_RXADDREXT_SHIFT)
 			    & B43_DMA64_RXADDREXT_MASK;
+			if (!parity)
+				value |= B43_DMA64_RXPARITYDISABLE;
 			b43_dma_write(ring, B43_DMA64_RXCTL, value);
 			b43_dma_write(ring, B43_DMA64_RXRINGLO,
 				      (ringbase & 0xFFFFFFFF));
@@ -720,6 +727,8 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			value |= B43_DMA32_RXENABLE;
 			value |= (addrext << B43_DMA32_RXADDREXT_SHIFT)
 			    & B43_DMA32_RXADDREXT_MASK;
+			if (!parity)
+				value |= B43_DMA32_RXPARITYDISABLE;
 			b43_dma_write(ring, B43_DMA32_RXCTL, value);
 			b43_dma_write(ring, B43_DMA32_RXRING,
 				      (ringbase & ~SSB_DMA_TRANSLATION_MASK)
@@ -1075,6 +1084,11 @@ int b43_dma_init(struct b43_wldev *dev)
 #endif
 	}
 
+	dma->parity = true;
+	/* TODO: find out which SSB devices need disabling parity */
+	if (dev->dev->bus_type == B43_BUS_BCMA)
+		dma->parity = false;
+
 	err = -ENOMEM;
 	/* setup TX DMA channels. */
 	dma->tx_ring_AC_BK = b43_setup_dmaring(dev, 0, 1, type);
-- 
1.7.3.4

