Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1936C10F02
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 14:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D2D921736
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 14:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387737AbfBROiY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:38:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35612 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388269AbfBROhv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 09:37:51 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 74BB6B0F9A;
        Mon, 18 Feb 2019 14:37:50 +0000 (UTC)
Received: from localhost (unknown [10.40.205.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AECE103BABA;
        Mon, 18 Feb 2019 14:37:49 +0000 (UTC)
Date:   Mon, 18 Feb 2019 15:37:48 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Rosen Penev <rosenp@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
Message-ID: <20190218143742.GA11872@redhat.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115090400.GA2267@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 18 Feb 2019 14:37:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(cc: IOMMU & page_frag_alloc maintainers)

On Tue, Jan 15, 2019 at 10:04:01AM +0100, Lorenzo Bianconi wrote:
> > On Mon, Jan 14, 2019 at 1:18 AM Lorenzo Bianconi
> > <lorenzo.bianconi@redhat.com> wrote:
> > >
> > > > On Sun, Jan 13, 2019 at 11:00 AM Lorenzo Bianconi
> > > > <lorenzo.bianconi@redhat.com> wrote:
> > > > >
> > > > > >
> > > > > >
> > > > > > On Sun, Jan 13, 2019 at 5:33 AM, Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> > > > > >
> > > > > > Direct. No VM used. This is the only peripheral causing this issue.
> > > > > >
> > > > > > Is the device connected to a usb3.0 port? If so, could you please try to connect the dongle to a 2.0 one?
> > > > > >
> > > > > > I tried through a USB 2.0 port. Shouldn't make a difference as they both use the xhci driver.
> > > > > >
> > > > >
> > > > > mt76x2u supports scatter-gather on usb 3.0 (not on 2.0)
> > > > Tried a USB 3 port. Same result.
> > > > >
> > > > > > Could you please double check if IOMMU is enabled?
> > > > > >
> > > > >
> > > > > Have you tried to disable it? Does it make any difference?
> > > > No idea how. UEFI doesn't seem to show anything similar.
> > > >
> > > > Similar bug report: https://bugzilla.kernel.org/show_bug.cgi?id=202241

FWIW: I provided some patches in the bugzilla, which were reported to
solve the problem. But I looking for confirmation if both are needed:

0001-mt76x02u-use-usb_bulk_msg-to-upload-firmware.patch
0002-mt76usb-do-not-use-compound-head-page-for-SG-I-O.patch

Or problem can be solved by just one of it (either first or second).

Additionally I'm not 100% sure if

0002-mt76usb-do-not-use-compound-head-page-for-SG-I-O.patch

is correct. So perhaps some IOMMU maintainer could look at it.

> > > You should be able to disable iommu using GRUB_CMDLINE_LINUX in
> > > /etc/default/grub (I guess setting iommu=off and reinstalling grub)
> > > https://wiki.gentoo.org/wiki/IOMMU_SWIOTLB
> > Yep. Working great now. I wonder what mt76 is doing to cause the crash though...
> 
> Thanks for bisecting the issue. 

Lorenzo, what you mean by 'bisecting' here ? Someone did 'git bisect'
on this issue?

> I think amd iommu does not support well usb scatter-gather
> (used by default in mt76u). I am working on a series in order to add the possibility to
> disable it.

Even if that true that AMD IOMMU does not support 'well' SG (what I think
is not true) disabling SG in mt76 driver is not right solution. Right
solution would be propagate the issue to AMD IOMMU maintainers
(already CCed).

One problem in mt76 is page_frag_alloc() usage with different sizes.
page_frag_alloc() unlike like other allocators do not assure alignment
and relay on callers to provide buffers sizes that are aligned.
Unaligned buffer might then not be appropriate for DMA.

Another issue is that dma_map_sg() & dma_map_page() may require some 
constraints. I'm not sure about that and I want to clarify that with 
CCed mm maintainers. I think DMA drivers may expect sg->offset < PAGE_SIZE
for both dma_map_sg() and dma_map_page(). Additionally dma_map_page()
maight expect that offset & length specify buffer within one page.

Stanislaw
