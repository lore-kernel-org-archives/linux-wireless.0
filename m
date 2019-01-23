Return-Path: <SRS0=ZHYo=P7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41710C282C0
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 18:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11D1A21855
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 18:00:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i6OyWrR7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfAWSAb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Jan 2019 13:00:31 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33663 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfAWSAa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Jan 2019 13:00:30 -0500
Received: by mail-wm1-f66.google.com with SMTP id r24so475986wmh.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2019 10:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vDX6zL2vUhxtLT7elO/AOSZrPsvnRjw5dlfNFU2rZbA=;
        b=i6OyWrR7XPb1YElk2+NLuECteZa8b5fvAp1dZd1Gxq0LwReA9GaG6GCG1hquwuXuHL
         Qhlqw8IlgbZOqkkh8GfEylv/FyfPvnCdFu68jIXVlmvpGs7vHrDSo0kRBWViBd1NynF7
         H2bGObVOcnVCGt9cev7PdlOmHZ7y9pJx3GWGxYRBwwDNeJkfYl+P2XbyVWvIVCKoYxNf
         bq3v4vW/o62LZ3UvkJpRJoK22pYgnsRW9i5u1ye7mfwVLkfyp9jdFhHLYJX/nuegIsxE
         3inv25YoA4CQC8lNGGGm8Bglz6MrgFEpZhzEzRptwSsnp0DSora+YgC0b8l7hAugIF2t
         bINQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vDX6zL2vUhxtLT7elO/AOSZrPsvnRjw5dlfNFU2rZbA=;
        b=UvnowG2SQfNABts/NcIEdnfYG2nEZWy06b17XoejNSz4J2zNkE1iJ5H7FPN+RqZgfK
         TDqoa9qEOvC7zhO6UEZ4waNSrbd412LsNdPSW5KYIPZjv+ju7DO2V9s52n5gD3TvBs0v
         Df8gSibDKsoydIaxXnMi0ptpXPNimeWt4esscFJfMeQUf7CN5n+ZNx6zWE49dQYfBQkW
         R4Ll0VBA6vJsHJuY5XoO86pweAWsDzGQRqGFr3N4iLeoy5hmdQQonyqByf4riO9ZKY4i
         gTQnedVCwpFmQ7zl+Di9wuvxoNL/crvpJwHWK7zqOIU5S4Q7BF9iaL2sv+msp04YgWmz
         /SFQ==
X-Gm-Message-State: AJcUukfC+1EWblIyLO4HB2Czv9Nu8uHikAZqFQ5HNJCs8p7eLJpIAHHQ
        24to43MxsCApKLG1cS2oZlW9Evh2FLDCaY3AsOk9pw==
X-Google-Smtp-Source: ALg8bN6+rHqRK1SM4rQEj869M8kDriHcwilqE3CypN+wTJsXSVyJN68jWa+8V79xHngf1/1rqdwMhPkdtsUckBKfQJY=
X-Received: by 2002:a1c:d00d:: with SMTP id h13mr3600779wmg.13.1548266427951;
 Wed, 23 Jan 2019 10:00:27 -0800 (PST)
MIME-Version: 1.0
References: <20190121101121.24555-1-zajec5@gmail.com> <20190121144638.GA27203@lst.de>
In-Reply-To: <20190121144638.GA27203@lst.de>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Wed, 23 Jan 2019 19:00:16 +0100
Message-ID: <CACna6ryV4id3wVGAinw8Fw+wuWXcfL_3T5DygoGNsAH_wAyjUg@mail.gmail.com>
Subject: Re: [PATCH wireless-drivers-next] bcma: get SoC device struct & copy
 its DMA params to the subdevices
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 21 Jan 2019 at 15:46, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Jan 21, 2019 at 11:11:21AM +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
> > From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >
> > For bus devices to be fully usable it's required to set their DMA
> > parameters.
> >
> > For years it has been missing and remained unnoticed because of
> > mips_dma_alloc_coherent() silently handling the empty coherent_dma_mask=
.
> > Kernel 4.19 came with a lot of DMA changes and caused a regression on
> > the bcm47xx. Starting with the commit f8c55dc6e828 ("MIPS: use generic
> > dma noncoherent ops for simple noncoherent platforms") DMA coherent
> > allocations just fail. Example:
> > [    1.114914] bgmac_bcma bcma0:2: Allocation of TX ring 0x200 failed
> > [    1.121215] bgmac_bcma bcma0:2: Unable to alloc memory for DMA
> > [    1.127626] bgmac_bcma: probe of bcma0:2 failed with error -12
> > [    1.133838] bgmac_bcma: Broadcom 47xx GBit MAC driver loaded
> >
> > This change fixes above regression in addition to the MIPS bcm47xx
> > commit 321c46b91550 ("MIPS: BCM47XX: Setup struct device for the SoC").
> >
> > It also fixes another *old* GPIO regression caused by a parent pointing
> > to the NULL:
> > [    0.157054] missing gpiochip .dev parent pointer
> > [    0.157287] bcma: bus0: Error registering GPIO driver: -22
> > introduced by the commit 74f4e0cc6108 ("bcma: switch GPIO portions to
> > use GPIOLIB_IRQCHIP").
> >
> > Fixes: f8c55dc6e828 ("MIPS: use generic dma noncoherent ops for simple =
noncoherent platforms")
> > Fixes: 74f4e0cc6108 ("bcma: switch GPIO portions to use GPIOLIB_IRQCHIP=
")
> > Cc: linux-mips@linux-mips.org
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> > ---
> > While this patch is a regression fix, it depends on a change present in
> > the wireless-drivers-next.git:
> > bcma: keep a direct pointer to the struct device
> >
> > That's why I suggest pushing it into the wireless-drivers-next.git and =
I
> > can take care of picking it for the stable@kernel.org later.
> >
> > Another option would be cherry-picking commit 5a1c18b761dd ("bcma: keep
> > a direct pointer to the struct device") to the wireless-drivers.git but
> > I don't think it's a common practice.
> > ---
> >  drivers/bcma/host_soc.c       | 2 ++
> >  drivers/bcma/main.c           | 6 +++++-
> >  include/linux/bcma/bcma_soc.h | 1 +
> >  3 files changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/bcma/host_soc.c b/drivers/bcma/host_soc.c
> > index c8073b509a2b..1fdfb704f22d 100644
> > --- a/drivers/bcma/host_soc.c
> > +++ b/drivers/bcma/host_soc.c
> > @@ -191,6 +191,8 @@ int __init bcma_host_soc_init(struct bcma_soc *soc)
> >       struct bcma_bus *bus =3D &soc->bus;
> >       int err;
> >
> > +     bus->dev =3D soc->dev;
> > +
> >       /* Scan bus and initialize it */
> >       err =3D bcma_bus_early_register(bus);
> >       if (err)
> > diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> > index 6535614a7dc1..433ca5e2ed2c 100644
> > --- a/drivers/bcma/main.c
> > +++ b/drivers/bcma/main.c
> > @@ -236,12 +236,16 @@ EXPORT_SYMBOL(bcma_core_irq);
> >
> >  void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
> >  {
> > +     struct device *dev =3D &core->dev;
> > +
> >       core->dev.release =3D bcma_release_core_dev;
> >       core->dev.bus =3D &bcma_bus_type;
> >       dev_set_name(&core->dev, "bcma%d:%d", bus->num, core->core_index)=
;
> >       core->dev.parent =3D bus->dev;
> > -     if (bus->dev)
> > +     if (bus->dev) {
> >               bcma_of_fill_device(bus->dev, core);
> > +             dma_coerce_mask_and_coherent(dev, bus->dev->coherent_dma_=
mask);
> > +     }
>
> I don't think this does the right thing for bcma devices behind
> PCI/PCIe, as those might need a IOMMU which relies on having a device
> it has properly enumerated to be passed into the DMA API.  In other
> words:  I think you need to change the layering so that the DMA API
> is always called on the underlying PCI/PCIe/platform device, not of
> the child bus.

This is already implemented (we have dma_dev pointer), but it may be
indeed more correct to apply this change for the SoC code only. I'll
send V2.

--=20
Rafa=C5=82
