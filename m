Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52864 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936082Ab0B0VoZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 16:44:25 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal DMA errors
Date: Sat, 27 Feb 2010 22:43:26 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <201002271836.04673.mb@bu3sch.de> <alpine.LFD.2.00.1002271301430.4513@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002271301430.4513@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002272243.27845.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 27 February 2010 22:08:03 Linus Torvalds wrote:
> No difference. 

Thanks. What about this? (Remove old patch first).


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2010-02-27 17:16:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2010-02-27 22:40:40.000000000 +0100
@@ -39,6 +39,10 @@
 #define B43_MMIO_DMA4_IRQ_MASK		0x44
 #define B43_MMIO_DMA5_REASON		0x48
 #define B43_MMIO_DMA5_IRQ_MASK		0x4C
+#define B43_MMIO_DMA6_REASON		0x50
+#define B43_MMIO_DMA6_IRQ_MASK		0x54
+#define B43_MMIO_DMA7_REASON		0x58
+#define B43_MMIO_DMA7_IRQ_MASK		0x5C
 #define B43_MMIO_MACCTL			0x120	/* MAC control */
 #define B43_MMIO_MACCMD			0x124	/* MAC command */
 #define B43_MMIO_GEN_IRQ_REASON		0x128
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2010-02-27 17:16:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2010-02-27 22:42:27.000000000 +0100
@@ -2880,6 +2880,10 @@ static int b43_chip_init(struct b43_wlde
 	b43_write32(dev, B43_MMIO_DMA3_IRQ_MASK, 0x0001DC00);
 	b43_write32(dev, B43_MMIO_DMA4_IRQ_MASK, 0x0000DC00);
 	b43_write32(dev, B43_MMIO_DMA5_IRQ_MASK, 0x0000DC00);
+	b43_write32(dev, B43_MMIO_DMA6_IRQ_MASK, 0);
+	b43_write32(dev, B43_MMIO_DMA6_REASON, 0);
+	b43_write32(dev, B43_MMIO_DMA7_IRQ_MASK, 0);
+	b43_write32(dev, B43_MMIO_DMA7_REASON, 0);
 
 	value32 = ssb_read32(dev->dev, SSB_TMSLOW);
 	value32 |= 0x00100000;


-- 
Greetings, Michael.
