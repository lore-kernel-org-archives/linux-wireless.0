Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33137 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754240AbcIEVeP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 17:34:15 -0400
MIME-Version: 1.0
In-Reply-To: <1458207563-3453369-1-git-send-email-arnd@arndb.de>
References: <1458207563-3453369-1-git-send-email-arnd@arndb.de>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 5 Sep 2016 23:34:14 +0200
Message-ID: <CACna6rza3U+X=cNXqvjB8fe1s+hP234cu405m3ObJBB=wQUcOQ@mail.gmail.com> (sfid-20160905_233422_014031_F10C6ECA)
Subject: Re: [PATCH v2] bcma: use of_dma_configure() to set initial dma mask
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 March 2016 at 10:39, Arnd Bergmann <arnd@arndb.de> wrote:
> While fixing another bug, I noticed that bcma manually sets up
> a dma_mask pointer for its child devices. We have a generic
> helper for that now, which should be able to cope better with
> any variations that might be needed to deal with cache coherency,
> unusual DMA address offsets, iommus, or limited DMA masks, none
> of which are currently handled here.
>
> This changes the core to use the of_dma_configure(), like
> we do for platform devices that are probed directly from
> DT.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I applied this patch and tested on BCM47081 based device. I still got
bgmac working which surely uses DMA. There is only 1 ARM wireless SoC
using bcma (BCM47198) but its WiFi core isn't supported by b43.

Any tips what else to test? SPI core/driver doesn't use DMA. Maybe
NAND core does, but we don't use it.

--=20
Rafa=C5=82
