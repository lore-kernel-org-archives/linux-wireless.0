Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:60627 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754086AbcIFJeO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 05:34:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] bcma: use of_dma_configure() to set initial dma mask
Date: Tue, 06 Sep 2016 11:34:26 +0200
Message-ID: <5961451.eLRiX5Tibt@wuerfel> (sfid-20160906_113418_933568_E969B906)
In-Reply-To: <CACna6rza3U+X=cNXqvjB8fe1s+hP234cu405m3ObJBB=wQUcOQ@mail.gmail.com>
References: <1458207563-3453369-1-git-send-email-arnd@arndb.de> <CACna6rza3U+X=cNXqvjB8fe1s+hP234cu405m3ObJBB=wQUcOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, September 5, 2016 11:34:14 PM CEST Rafał Miłecki wrote:
> On 17 March 2016 at 10:39, Arnd Bergmann <arnd@arndb.de> wrote:
> > While fixing another bug, I noticed that bcma manually sets up
> > a dma_mask pointer for its child devices. We have a generic
> > helper for that now, which should be able to cope better with
> > any variations that might be needed to deal with cache coherency,
> > unusual DMA address offsets, iommus, or limited DMA masks, none
> > of which are currently handled here.
> >
> > This changes the core to use the of_dma_configure(), like
> > we do for platform devices that are probed directly from
> > DT.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> I applied this patch and tested on BCM47081 based device. I still got
> bgmac working which surely uses DMA.

Thanks!

> There is only 1 ARM wireless SoC
> using bcma (BCM47198) but its WiFi core isn't supported by b43.
> 
> Any tips what else to test? SPI core/driver doesn't use DMA. Maybe
> NAND core does, but we don't use it.
> 

If there is nothing else using this, then the patch won't cause
a regression ;-)

	Arnd
