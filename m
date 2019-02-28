Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0852C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 10:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7A482183F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 10:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731135AbfB1Kmb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 05:42:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59090 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbfB1Kma (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 05:42:30 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E0EA03175581;
        Thu, 28 Feb 2019 10:42:29 +0000 (UTC)
Received: from localhost (unknown [10.43.2.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B349C61355;
        Thu, 28 Feb 2019 10:42:26 +0000 (UTC)
Date:   Thu, 28 Feb 2019 11:42:24 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Rosen Penev <rosenp@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
Message-ID: <20190228104223.GA2749@redhat.com>
References: <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
 <20190114091841.GA23045@localhost.localdomain>
 <CAKxU2N8ioMszBCyQcH7CVhgBdW4aj7yZ+kYQe14DCV5OSAnxrg@mail.gmail.com>
 <20190115090400.GA2267@localhost.localdomain>
 <20190218143742.GA11872@redhat.com>
 <20190226100535.GA20740@8bytes.org>
 <20190226103450.GA2989@redhat.com>
 <20190226104413.GH20740@8bytes.org>
 <20190226112407.GB2989@redhat.com>
 <20190228090411.GA24938@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228090411.GA24938@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 28 Feb 2019 10:42:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Feb 28, 2019 at 10:04:12AM +0100, Stanislaw Gruszka wrote:
> On Tue, Feb 26, 2019 at 12:24:08PM +0100, Stanislaw Gruszka wrote:
> > On Tue, Feb 26, 2019 at 11:44:13AM +0100, Joerg Roedel wrote:
> > > On Tue, Feb 26, 2019 at 11:34:51AM +0100, Stanislaw Gruszka wrote:
> > > > On Tue, Feb 26, 2019 at 11:05:36AM +0100, Joerg Roedel wrote:
> > > > If sg->offset > PAGE_SIZE is fine then most likely we have problem with
> > > > alignment.
> > > 
> > > The map_sg implementation in the AMD IOMMU driver uses sg_phys() which
> > > handles the sg->page + sg->offset calculation fine.
> > > 
> > > > Note hat issue is with dma_map_sg(), switching to dma_map_single()
> > > > by using urb->transfer_buffer instead of urb->sg make things work
> > > > on AMD IOMMU.
> > > 
> > > On the other hand this points to a bug in the driver, I'll look further
> > > if I can spot something there.
> > 
> > I think so too. And I have done some changes that avoid strange allocation
> > scheme and use usb synchronous messages instead of allocating buffers
> > with unaligned sizes. However things work ok on Intel IOMMU and 
> > there is no documentation what are dma_map_sg() requirement versus
> > dma_map_single() which works. I think there are some unwritten
> > requirements and things can work on some platforms and fails on others
> > (different IOMMUs, no-IOMMU on some ARCHes)  
> 
> For the record: we have another bug report with this issue:
> https://bugzilla.kernel.org/show_bug.cgi?id=202673
> 
> I provided there patch that change alignment for page_frag_alloc() and
> it did not fixed the problem. So this is not alignment issue.
> Now I think it could be page->refcount issue ...

I looked at the map_sg() in amd_iommu.c code and one line looks suspicious
to me, seems we can use not correctly initialized s->dma_address (should be 0,
but I think can be non-zero if SG was reused). The code also seems do
not do correct thing if there is more than one SG with multiple pages
on individual segments. Something like in below patch seems to be more
appropriate to me (not tested nor compiled).

Stanislaw

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 34c9aa76a7bd..9c8887250b82 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2517,6 +2517,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 	prot = dir2prot(direction);
 
 	/* Map all sg entries */
+	npages = 0;
 	for_each_sg(sglist, s, nelems, i) {
 		int j, pages = iommu_num_pages(sg_phys(s), s->length, PAGE_SIZE);
 
@@ -2524,7 +2525,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 			unsigned long bus_addr, phys_addr;
 			int ret;
 
-			bus_addr  = address + s->dma_address + (j << PAGE_SHIFT);
+			bus_addr  = address + ((npages + j) << PAGE_SHIFT);
 			phys_addr = (sg_phys(s) & PAGE_MASK) + (j << PAGE_SHIFT);
 			ret = iommu_map_page(domain, bus_addr, phys_addr, PAGE_SIZE, prot, GFP_ATOMIC);
 			if (ret)
@@ -2532,6 +2533,8 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 
 			mapped_pages += 1;
 		}
+
+		npages += mapped_pages;
 	}
 
 	/* Everything is mapped - write the right values into s->dma_address */


