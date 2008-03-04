Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:50748 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764898AbYCDP0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 10:26:34 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: drivers/net/wireless/b43legacy/ on mips
Date: Tue, 4 Mar 2008 16:26:03 +0100
Cc: linux-wireless@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
References: <20080303233651.82c592a4.akpm@linux-foundation.org>
In-Reply-To: <20080303233651.82c592a4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803041626.03830.mb@bu3sch.de> (sfid-20080304_152659_908676_825BFBF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 March 2008 08:36:51 Andrew Morton wrote:
> 
> ERROR: "__ucmpdi2" [drivers/net/wireless/b43legacy/b43legacy.ko] undefined!
> ERROR: "__ucmpdi2" [drivers/net/wireless/b43/b43.ko] undefined!
> 
> int b43legacy_dma_init(struct b43legacy_wldev *dev)
> {
>         struct b43legacy_dma *dma = &dev->dma;
>         struct b43legacy_dmaring *ring;
>         int err;
>         u64 dmamask;
>         enum b43legacy_dmatype type;
> 
>         dmamask = supported_dma_mask(dev);
>         switch (dmamask) {
>         default:
>                 B43legacy_WARN_ON(1);
>         case DMA_30BIT_MASK:
>                 type = B43legacy_DMA_30BIT;
>                 break;
>         case DMA_32BIT_MASK:
>                 type = B43legacy_DMA_32BIT;
>                 break;
>         case DMA_64BIT_MASK:
>                 type = B43legacy_DMA_64BIT;
>                 break;
>         }
> 
> because some versions of gcc emit a __ucmpdi2 call for switch statements. 
> It might be fixable by switching to an open-coded if/compare/else sequence.

I guess that's only done for a 64bit data type, right?

> Or maybe my mips compiler (gcc-3.4.5) is just too old..

Well yeah. b43 uses exactly the same code and we use that in openwrt
on the bcm47xx mips platform with some 4.x compiler.

Can we switch off the generation of the __ucmpdi2 call somehow?
Or can we insert an implementation for it? Probably #ifdefed by the
compiler version.

-- 
Greetings Michael.
