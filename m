Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E111EC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 11:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA21E21902
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 11:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfBSLI5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 06:08:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44036 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbfBSLI5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 06:08:57 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2023AD885;
        Tue, 19 Feb 2019 11:08:56 +0000 (UTC)
Received: from localhost (unknown [10.43.2.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18DFB60BE8;
        Tue, 19 Feb 2019 11:08:53 +0000 (UTC)
Date:   Tue, 19 Feb 2019 12:08:52 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Samuel Sieb <samuel@sieb.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Rosen Penev <rosenp@gmail.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
Message-ID: <20190219110851.GA23223@redhat.com>
References: <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com>
 <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
 <1547404075.1582.0@smtp.gmail.com>
 <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
 <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
 <20190114091841.GA23045@localhost.localdomain>
 <CAKxU2N8ioMszBCyQcH7CVhgBdW4aj7yZ+kYQe14DCV5OSAnxrg@mail.gmail.com>
 <20190115090400.GA2267@localhost.localdomain>
 <20190218143742.GA11872@redhat.com>
 <2cc5674a-a3a0-d8fe-65f5-4357da9b85d3@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cc5674a-a3a0-d8fe-65f5-4357da9b85d3@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 19 Feb 2019 11:08:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 18, 2019 at 05:01:59PM +0000, Robin Murphy wrote:
> On 18/02/2019 14:37, Stanislaw Gruszka wrote:
> [...]
> >Another issue is that dma_map_sg() & dma_map_page() may require some
> >constraints. I'm not sure about that and I want to clarify that with
> >CCed mm maintainers. I think DMA drivers may expect sg->offset < PAGE_SIZE
> >for both dma_map_sg() and dma_map_page(). Additionally dma_map_page()
> >maight expect that offset & length specify buffer within one page.
> 
> Luckily, this came up a while back[1] and we seemed to reach a
> consensus that sg->offset >= PAGE_SIZE for dma_map_sg() was weird
> but valid. IIRC it was only the Intel IOMMU code which failed to
> handle that case appropriately (and which I fixed) - the AMD IOMMU
> code always looked like it should be OK, but I'm not sure I've ever
> seen definitive test results (and I don't have hardware to do so
> myself).

Funny that we have problems on AMD IOMMU and not with Intel IOMMU.

> For dma_map_page(), length >= PAGE_SIZE should be perfectly valid
> and handled correctly. The offset >= PAGE_SIZE case is a bit harder
> to justify, but at the same time has less scope for the DMA API
> backend to get it wrong, so either way is likely to be OK in
> practice (in particular the AMD IOMMU code looks like it won't have
> a problem, since its map_page() implementation converts page and
> offset to a plain physical address before doing anything else).

Thanks for clarify this. So my patch which do:

-		page = virt_to_head_page(data);
+		page = virt_to_page(data);
 		offset = data - page_address(page);
 		sg_set_page(&urb->sg[i], page, sglen, offset);

should not be necessary as IOMMU driver do exactly the same internally.

Are there any alignment requirement for offset for dma_map_{page,sg} ?
It will work with let say sg->offset=113 or we have make sure it is
aligned to some boundary. If so, what boundary ?

Stanislaw
