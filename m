Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:37400 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbeIKMbG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 08:31:06 -0400
Message-ID: <1536651177.3224.106.camel@sipsolutions.net> (sfid-20180911_093318_629067_E666D7C1)
Subject: Re: 4.19-rc[23] iwlwifi: BUG in swiotlb
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi@intel.com
Date: Tue, 11 Sep 2018 09:32:57 +0200
In-Reply-To: <0c5e53e5-2afa-8d38-0b48-272c670c4bc5@infradead.org> (sfid-20180911_041837_063528_262C06DC)
References: <0c5e53e5-2afa-8d38-0b48-272c670c4bc5@infradead.org>
         (sfid-20180911_041837_063528_262C06DC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-10 at 19:17 -0700, Randy Dunlap wrote:
> Hi,
> 
> Any ideas?

Hmm. Is this new?

> 2018-09-10T18:47:54.532837-07:00 dragon kernel: [   31.472371] kernel BUG at ../kernel/dma/swiotlb.c:521!

        nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
	[...]
	BUG_ON(!nslots)

> 2018-09-10T18:47:54.613655-07:00 dragon kernel: [   31.490325]  swiotlb_alloc+0x88/0x170
> 2018-09-10T18:47:54.613656-07:00 dragon kernel: [   31.490329]  ? __kmalloc+0x1cc/0x200
> 2018-09-10T18:47:54.613657-07:00 dragon kernel: [   31.491652]  iwl_pcie_txq_alloc+0x1d4/0x3b0 [iwlwifi]

There are two calls to dma_alloc_coherent() here, should those even hit
swiotlb? The sizes of those should be
 * 256 x 128 (32k)
 * 32 x 256 (8k) [TFH, unlikely to be the case here]
 * 256 x 256 (65k) [TFH]
 * 32 x 64 (2k)
 * 256 x 64 (16k)


IO_TLB_SHIFT is 11, so we get 2k alignment, so even the smallest size
(32*64) should result in nslots being 1?

In fact, unless the driver passed *ZERO* as the size, this should never
happen (hence the BUG_ON), since ALIGN() would take care of rounding up
any smaller allocation here.

Presumably you can reproduce this pretty easily (and I don't know what
specific model of NIC you have etc.), so perhaps you can do something
like this?

https://p.sipsolutions.net/aa0dccd7a60fe176.txt

johannes
