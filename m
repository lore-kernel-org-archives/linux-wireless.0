Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E3D9C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E659B21850
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732056AbfB1JEU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 04:04:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732054AbfB1JET (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 04:04:19 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 334BA8AE40;
        Thu, 28 Feb 2019 09:04:19 +0000 (UTC)
Received: from localhost (unknown [10.40.205.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 389B161355;
        Thu, 28 Feb 2019 09:04:13 +0000 (UTC)
Date:   Thu, 28 Feb 2019 10:04:12 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Rosen Penev <rosenp@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
Message-ID: <20190228090411.GA24938@redhat.com>
References: <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
 <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
 <20190114091841.GA23045@localhost.localdomain>
 <CAKxU2N8ioMszBCyQcH7CVhgBdW4aj7yZ+kYQe14DCV5OSAnxrg@mail.gmail.com>
 <20190115090400.GA2267@localhost.localdomain>
 <20190218143742.GA11872@redhat.com>
 <20190226100535.GA20740@8bytes.org>
 <20190226103450.GA2989@redhat.com>
 <20190226104413.GH20740@8bytes.org>
 <20190226112407.GB2989@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226112407.GB2989@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 28 Feb 2019 09:04:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 26, 2019 at 12:24:08PM +0100, Stanislaw Gruszka wrote:
> On Tue, Feb 26, 2019 at 11:44:13AM +0100, Joerg Roedel wrote:
> > On Tue, Feb 26, 2019 at 11:34:51AM +0100, Stanislaw Gruszka wrote:
> > > On Tue, Feb 26, 2019 at 11:05:36AM +0100, Joerg Roedel wrote:
> > > If sg->offset > PAGE_SIZE is fine then most likely we have problem with
> > > alignment.
> > 
> > The map_sg implementation in the AMD IOMMU driver uses sg_phys() which
> > handles the sg->page + sg->offset calculation fine.
> > 
> > > Note hat issue is with dma_map_sg(), switching to dma_map_single()
> > > by using urb->transfer_buffer instead of urb->sg make things work
> > > on AMD IOMMU.
> > 
> > On the other hand this points to a bug in the driver, I'll look further
> > if I can spot something there.
> 
> I think so too. And I have done some changes that avoid strange allocation
> scheme and use usb synchronous messages instead of allocating buffers
> with unaligned sizes. However things work ok on Intel IOMMU and 
> there is no documentation what are dma_map_sg() requirement versus
> dma_map_single() which works. I think there are some unwritten
> requirements and things can work on some platforms and fails on others
> (different IOMMUs, no-IOMMU on some ARCHes)  

For the record: we have another bug report with this issue:
https://bugzilla.kernel.org/show_bug.cgi?id=202673

I provided there patch that change alignment for page_frag_alloc() and
it did not fixed the problem. So this is not alignment issue.
Now I think it could be page->refcount issue ...

Stanislaw
