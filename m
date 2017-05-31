Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50703 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdEaLPI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 07:15:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: go back to using dma_alloc_coherent() for firmware scratch memory.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170501214327.5621-1-adrian@freebsd.org>
References: <20170501214327.5621-1-adrian@freebsd.org>
To: Adrian Chadd <adrian@freebsd.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Adrian Chadd" <adrian@FreeBSD.org>
Message-ID: <3f92c875c8fa4c66a3e32d88947c18b7@euamsexm01a.eu.qualcomm.com> (sfid-20170531_131511_520925_54F51313)
Date: Wed, 31 May 2017 13:15:00 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd <adrian@freebsd.org> wrote:

> This reverts commit b057886524be ("ath10k: do not use coherent memory for
> allocated device memory chunks") in 2015 which converted this allocation from
> dma_map_coherent() to kzalloc() / dma_map_single().
> 
> The current problem manifests when using later model NICs with larger
> (>700KiB) scratch spaces in memory.  Although the kzalloc call
> succeeds, the software IOMMU TLB code (via dma_map_single()) panics
> because it can't find 700KiB of linear physmem bounce buffers for DMA.
> Now, this is a bit of a silly failure mode for the dma map API,
> but it's what we currently have to play with.
> 
> In these cases, doing kzalloc() works fine, but the dma_map_single()
> call fails.
> 
> After chatting with Linus briefly about this, it indeed should be
> using dma_alloc_coherent() for doing larger device memory allocation
> that requires some kind of physical address mapping.
> 
> You're not supposed to be using kzalloc and dma_map_* calls for
> large memory regions, and I'm guessing not for long-held mappings
> either.  Typically dma mappings should be temporary for DMA,
> not long held like these.
> 
> Now, since hopefully the major annoying underlying problem has also been
> addressed (ie, ath10k is no longer tears down all of these allocations
> and reallocates them every time the vdevs are brought down) fragmentation
> should stop being such a touchy issue.  If it is though, using
> dma_alloc_coherent() use gets us access to the CMB APIs too relatively
> easily and ideally we would be allocating memory early in boot for
> exactly these reasons.
> 
> Signed-off-by: Adrian Chadd <adrian@FreeBSD.org>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

79e68821582d ath10k: go back to using dma_alloc_coherent() for firmware scratch memory

-- 
https://patchwork.kernel.org/patch/9707059/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
