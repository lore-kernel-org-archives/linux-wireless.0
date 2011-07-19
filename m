Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:33942 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab1GSVdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 17:33:53 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so542082fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 14:33:53 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Pavel Roskin <proski@gnu.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: bcma: get DMA translation bits
Date: Wed, 20 Jul 2011 00:12:22 +0200
Message-Id: <1311113542-2540-4-git-send-email-zajec5@gmail.com> (sfid-20110719_233405_741151_1F6AD98E)
In-Reply-To: <1311113542-2540-1-git-send-email-zajec5@gmail.com>
References: <1311113542-2540-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some missing defines by the way.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/dma.c |    5 +++++
 drivers/net/wireless/b43/dma.h |    4 ++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 530a153..0a5004b 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1057,6 +1057,11 @@ int b43_dma_init(struct b43_wldev *dev)
 		return err;
 
 	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		dma->translation = bcma_core_dma_translation(dev->dev->bdev);
+		break;
+#endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		dma->translation = ssb_dma_translation(dev->dev->sdev);
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

