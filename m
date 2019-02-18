Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DFFFC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 17:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDD95217F5
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 17:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731830AbfBRRhg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 12:37:36 -0500
Received: from foss.arm.com ([217.140.101.70]:34952 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729728AbfBRRhg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 12:37:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E565D80D;
        Mon, 18 Feb 2019 09:02:22 -0800 (PST)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87C683F675;
        Mon, 18 Feb 2019 09:02:01 -0800 (PST)
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Samuel Sieb <samuel@sieb.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Rosen Penev <rosenp@gmail.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
References: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com>
 <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com>
 <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com>
 <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
 <1547404075.1582.0@smtp.gmail.com>
 <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
 <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
 <20190114091841.GA23045@localhost.localdomain>
 <CAKxU2N8ioMszBCyQcH7CVhgBdW4aj7yZ+kYQe14DCV5OSAnxrg@mail.gmail.com>
 <20190115090400.GA2267@localhost.localdomain>
 <20190218143742.GA11872@redhat.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <2cc5674a-a3a0-d8fe-65f5-4357da9b85d3@arm.com>
Date:   Mon, 18 Feb 2019 17:01:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190218143742.GA11872@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 18/02/2019 14:37, Stanislaw Gruszka wrote:
[...]
> Another issue is that dma_map_sg() & dma_map_page() may require some
> constraints. I'm not sure about that and I want to clarify that with
> CCed mm maintainers. I think DMA drivers may expect sg->offset < PAGE_SIZE
> for both dma_map_sg() and dma_map_page(). Additionally dma_map_page()
> maight expect that offset & length specify buffer within one page.

Luckily, this came up a while back[1] and we seemed to reach a consensus 
that sg->offset >= PAGE_SIZE for dma_map_sg() was weird but valid. IIRC 
it was only the Intel IOMMU code which failed to handle that case 
appropriately (and which I fixed) - the AMD IOMMU code always looked 
like it should be OK, but I'm not sure I've ever seen definitive test 
results (and I don't have hardware to do so myself).

For dma_map_page(), length >= PAGE_SIZE should be perfectly valid and 
handled correctly. The offset >= PAGE_SIZE case is a bit harder to 
justify, but at the same time has less scope for the DMA API backend to 
get it wrong, so either way is likely to be OK in practice (in 
particular the AMD IOMMU code looks like it won't have a problem, since 
its map_page() implementation converts page and offset to a plain 
physical address before doing anything else).

Robin.

[1] 
https://lists.linuxfoundation.org/pipermail/iommu/2017-September/024148.html
