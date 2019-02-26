Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5167AC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 10:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 295E02146F
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 10:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfBZKe4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 05:34:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfBZKe4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 05:34:56 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E9E8670D6C;
        Tue, 26 Feb 2019 10:34:55 +0000 (UTC)
Received: from localhost (unknown [10.40.205.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E5125D6AA;
        Tue, 26 Feb 2019 10:34:52 +0000 (UTC)
Date:   Tue, 26 Feb 2019 11:34:51 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Rosen Penev <rosenp@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
Message-ID: <20190226103450.GA2989@redhat.com>
References: <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com>
 <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
 <1547404075.1582.0@smtp.gmail.com>
 <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
 <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
 <20190114091841.GA23045@localhost.localdomain>
 <CAKxU2N8ioMszBCyQcH7CVhgBdW4aj7yZ+kYQe14DCV5OSAnxrg@mail.gmail.com>
 <20190115090400.GA2267@localhost.localdomain>
 <20190218143742.GA11872@redhat.com>
 <20190226100535.GA20740@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226100535.GA20740@8bytes.org>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 26 Feb 2019 10:34:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 26, 2019 at 11:05:36AM +0100, Joerg Roedel wrote:
> On Mon, Feb 18, 2019 at 03:37:48PM +0100, Stanislaw Gruszka wrote:
> > 0001-mt76x02u-use-usb_bulk_msg-to-upload-firmware.patch
> > 0002-mt76usb-do-not-use-compound-head-page-for-SG-I-O.patch
> > 
> > Or problem can be solved by just one of it (either first or second).
> > 
> > Additionally I'm not 100% sure if
> > 
> > 0002-mt76usb-do-not-use-compound-head-page-for-SG-I-O.patch
> > 
> > is correct. So perhaps some IOMMU maintainer could look at it.
> 
> The patch looks good, but I don't understand why it is needed. The AMD
> IOMMU driver should handle sg->offset > PAGE_SIZE just fine. Can you
> verify that this is the problem? I will look into that again if it turns
> out there is bug in the IOMMU driver.

I'm try to get that information from bug reporter, but I can't get it so
far.

If sg->offset > PAGE_SIZE is fine then most likely we have problem with
alignment. We use page_frag_alloc() in mt76usb for buffer allocation
in scheme like this

page_frag_alloc(max_payload);	// something like 14434
page_frag_alloc(1024);
page_frag_alloc(2048)
page_frag_alloc(2048)
page_frag_alloc(2048)
...

page_frag_alloc works smart and fast way internally by allocating
fragments just but changing internal offset:

        offset = nc->offset - fragsz;
        if (unlikely(offset < 0)) {
                page = virt_to_page(nc->va);
	.
	.
	.

        }

        nc->offset = offset;
	return nc->va + offset;

but unlike other allocators like kmalloc that make effort to provide
ARCH_DMA_MINALIGN buffers, it does not care about alignment. Above
scheme of allocation in mt76usb breaks it. 

Note hat issue is with dma_map_sg(), switching to dma_map_single()
by using urb->transfer_buffer instead of urb->sg make things work
on AMD IOMMU.

Stanislaw

