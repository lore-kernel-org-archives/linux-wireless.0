Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49922 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1GTRI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 13:08:27 -0400
Received: by ewy4 with SMTP id 4so677417ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 10:08:26 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] b43: disable parity check on BCMA devices
Date: Wed, 20 Jul 2011 19:47:07 +0200
Message-Id: <1311184027-3497-1-git-send-email-zajec5@gmail.com> (sfid-20110720_190831_129654_FD7CF4EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Analyze of MMIO dumps from BCM43224, BCM43225, BCM4313 and BCM4331 has
shown that wl disables parity check for all that cards. This is required
for receiving any packets from the hardware.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: drop dependency on other patches, can be applied right away
---
 drivers/net/wireless/b43/b43.h |    1 +
 drivers/net/wireless/b43/dma.c |   14 ++++++++++++++
 drivers/net/wireless/b43/dma.h |    4 ++++
 3 files changed, 19 insertions(+), 0 deletions(-)

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
index 60c6b61..2e072f6 100644
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
@@ -1069,6 +1078,11 @@ int b43_dma_init(struct b43_wldev *dev)
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
diff --git a/drivers/net/wireless/b43/dma.h b/drivers/net/wireless/b43/dma.h
index e8a80a1..cdf8709 100644
--- a/drivers/net/wireless/b43/dma.h
+++ b/drivers/net/wireless/b43/dma.h
@@ -20,6 +20,7 @@
 #define		B43_DMA32_TXSUSPEND			0x00000002
 #define		B43_DMA32_TXLOOPBACK		0x00000004
 #define		B43_DMA32_TXFLUSH			0x00000010
+#define		B43_DMA32_TXPARITYDISABLE		0x00000800
 #define		B43_DMA32_TXADDREXT_MASK		0x00030000
 #define		B43_DMA32_TXADDREXT_SHIFT		16
 #define B43_DMA32_TXRING				0x04
@@ -44,6 +45,7 @@
 #define		B43_DMA32_RXFROFF_MASK		0x000000FE
 #define		B43_DMA32_RXFROFF_SHIFT		1
 #define		B43_DMA32_RXDIRECTFIFO		0x00000100
+#define		B43_DMA32_RXPARITYDISABLE		0x00000800
 #define		B43_DMA32_RXADDREXT_MASK		0x00030000
 #define		B43_DMA32_RXADDREXT_SHIFT		16
 #define B43_DMA32_RXRING				0x14
@@ -84,6 +86,7 @@ struct b43_dmadesc32 {
 #define		B43_DMA64_TXSUSPEND			0x00000002
 #define		B43_DMA64_TXLOOPBACK		0x00000004
 #define		B43_DMA64_TXFLUSH			0x00000010
+#define		B43_DMA64_TXPARITYDISABLE		0x00000800
 #define		B43_DMA64_TXADDREXT_MASK		0x00030000
 #define		B43_DMA64_TXADDREXT_SHIFT		16
 #define B43_DMA64_TXINDEX				0x04
@@ -111,6 +114,7 @@ struct b43_dmadesc32 {
 #define		B43_DMA64_RXFROFF_MASK		0x000000FE
 #define		B43_DMA64_RXFROFF_SHIFT		1
 #define		B43_DMA64_RXDIRECTFIFO		0x00000100
+#define		B43_DMA64_RXPARITYDISABLE		0x00000800
 #define		B43_DMA64_RXADDREXT_MASK		0x00030000
 #define		B43_DMA64_RXADDREXT_SHIFT		16
 #define B43_DMA64_RXINDEX				0x24
-- 
1.7.3.4

