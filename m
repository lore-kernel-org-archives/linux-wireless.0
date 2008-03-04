Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbYCDHhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 02:37:31 -0500
Date: Mon, 3 Mar 2008 23:36:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Subject: drivers/net/wireless/b43legacy/ on mips
Message-Id: <20080303233651.82c592a4.akpm@linux-foundation.org> (sfid-20080304_073737_102293_6856A900)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


ERROR: "__ucmpdi2" [drivers/net/wireless/b43legacy/b43legacy.ko] undefined!
ERROR: "__ucmpdi2" [drivers/net/wireless/b43/b43.ko] undefined!

int b43legacy_dma_init(struct b43legacy_wldev *dev)
{
        struct b43legacy_dma *dma = &dev->dma;
        struct b43legacy_dmaring *ring;
        int err;
        u64 dmamask;
        enum b43legacy_dmatype type;

        dmamask = supported_dma_mask(dev);
        switch (dmamask) {
        default:
                B43legacy_WARN_ON(1);
        case DMA_30BIT_MASK:
                type = B43legacy_DMA_30BIT;
                break;
        case DMA_32BIT_MASK:
                type = B43legacy_DMA_32BIT;
                break;
        case DMA_64BIT_MASK:
                type = B43legacy_DMA_64BIT;
                break;
        }

because some versions of gcc emit a __ucmpdi2 call for switch statements. 
It might be fixable by switching to an open-coded if/compare/else sequence.

Or maybe my mips compiler (gcc-3.4.5) is just too old..
