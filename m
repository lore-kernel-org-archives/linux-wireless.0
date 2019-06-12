Return-Path: <SRS0=e4fn=UL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F09C31E46
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jun 2019 03:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D032620866
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jun 2019 03:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407064AbfFLDdR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Jun 2019 23:33:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:59994 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404347AbfFLDdR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jun 2019 23:33:17 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x5C3WnMD029931;
        Tue, 11 Jun 2019 22:32:50 -0500
Message-ID: <9fc8153bf08d1a5fd166d0cb38585094bffa060b.camel@kernel.crashing.org>
Subject: Re: [BISECTED REGRESSION] b43legacy broken on G4 PowerBook
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Christoph Hellwig <hch@lst.de>
Cc:     Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Zigotzky <chzigotzky@xenosoft.de>,
        linuxppc-dev@lists.ozlabs.org
Date:   Wed, 12 Jun 2019 13:32:49 +1000
In-Reply-To: <7dcf54a9-a7aa-3a4c-8e2d-556be633d6e0@lwfinger.net>
References: <20190605225059.GA9953@darkstar.musicnaut.iki.fi>
         <73da300c-871c-77ac-8a3a-deac226743ef@lwfinger.net>
         <20190607172902.GA8183@lst.de>
         <30000803-3772-3edf-f4a9-55122d504f3f@lwfinger.net>
         <20190610081825.GA16534@lst.de>
         <153c13f5-a829-1eab-a3c5-fecfb84127ff@lwfinger.net>
         <20190611060521.GA19512@lst.de>
         <5aaa600b-5b59-1f68-454f-20403c318f1a@lwfinger.net>
         <0b257651bb7ac4a6f0a8dce5470120b7701720b9.camel@kernel.crashing.org>
         <7dcf54a9-a7aa-3a4c-8e2d-556be633d6e0@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-06-11 at 20:52 -0500, Larry Finger wrote:
> On 6/11/19 5:46 PM, Benjamin Herrenschmidt wrote:
> > On Tue, 2019-06-11 at 17:20 -0500, Larry Finger wrote:
> > > b43-pci-bridge 0001:11:00.0: dma_direct_supported: failed (mask =
> > > 0x3fffffff,
> > > min_mask = 0x5ffff000/0x5ffff000, dma bits = 0x1f
> > 
> > Ugh ? A mask with holes in it ? That's very wrong... That min_mask is
> > bogus.
> 
> I agree, but that is not likely serious as most systems will have enough memory 
> that the max_pfn term will be much larger than the initial min_mask, and 
> min_mask will be unchanged by the min function. 

Well no... it's too much memory that is the problem. If min_mask is
bogus though it will cause problem later too, so one should look into
it.

> In addition, min_mask is not 
> used beyond this routine, and then only to decide if direct dma is supported. 
> The following patch generates masks with no holes, but I cannot see that it is 
> needed.

The right fix is to round up max_pfn to a power of 2, something like

min_mask = min_t(u64, min_mask, (roundup_pow_of_two(max_pfn - 1)) <<
		PAGE_SHIFT) 

> diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
> index 2c2772e9702a..e3edd4f29e80 100644
> --- a/kernel/dma/direct.c
> +++ b/kernel/dma/direct.c
> @@ -384,7 +384,8 @@ int dma_direct_supported(struct device *dev, u64 mask)
>          else
>                  min_mask = DMA_BIT_MASK(32);
> 
> -       min_mask = min_t(u64, min_mask, (max_pfn - 1) << PAGE_SHIFT);
> +       min_mask = min_t(u64, min_mask, ((max_pfn - 1) << PAGE_SHIFT) |
> +                                        DMA_BIT_MASK(PAGE_SHIFT));
> 
>          /*
>           * This check needs to be against the actual bit mask value, so
> 
> 
> Larry

