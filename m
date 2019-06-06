Return-Path: <SRS0=9AY8=UF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B72C28D19
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Jun 2019 06:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44B1020673
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Jun 2019 06:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfFFGkn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Jun 2019 02:40:43 -0400
Received: from verein.lst.de ([213.95.11.211]:47405 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFGkn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jun 2019 02:40:43 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id CEE9668B05; Thu,  6 Jun 2019 08:40:15 +0200 (CEST)
Date:   Thu, 6 Jun 2019 08:40:15 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Aaro Koskinen <aaro.koskinen@iki.fi>,
        Christoph Hellwig <hch@lst.de>,
        Christian Zigotzky <chzigotzky@xenosoft.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [BISECTED REGRESSION] b43legacy broken on G4 PowerBook
Message-ID: <20190606064015.GC27033@lst.de>
References: <20190605225059.GA9953@darkstar.musicnaut.iki.fi> <35b3f09b-b371-e2cc-4436-120c67e2f1fb@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35b3f09b-b371-e2cc-4436-120c67e2f1fb@lwfinger.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jun 05, 2019 at 10:06:18PM -0500, Larry Finger wrote:
> First of all, you have my sympathy for the laborious bisection on a 
> PowerBook G4. I have done several myself. Thank you.
>
> I confirm your results.
>
> The ppc code has a maximum DMA size of 31 bits, thus a 32-bit request will 
> fail. Why the 30-bit fallback fails in b43legacy fails while it works in 
> b43 is a mystery.
>
> Although dma_nommu_dma_supported() may be "largely identical" to 
> dma_direct_supported(), they obviously differ. Routine 
> dma_nommu_dma_supported() returns 1 for 32-bit systems, but I do not know 
> what dma_direct_supported() returns.
>
> I am trying to find a patch.

	if (IS_ENABLED(CONFIG_ZONE_DMA))
		min_mask = DMA_BIT_MASK(ARCH_ZONE_DMA_BITS);
	else
		min_mask = DMA_BIT_MASK(32);

	min_mask = min_t(u64, min_mask, (max_pfn - 1) << PAGE_SHIFT);
	return mask >= __phys_to_dma(dev, min_mask);

So the smaller or:

 (1) 32-bit
 (2) ARCH_ZONE_DMA_BITS
 (3) the actual amount of memory in the system

modolo any DMA offsets that come into play.

No offsets should exists on pmac, and ARCH_ZONE_DMA_BITS is 31 on
powerpc.  So unless the system has 1GB or less memory it will probably
return false for b43, because it can't actually guarantee reliable
allocation.  It will work fine on x86 with the smaller ZONE_DMA.
