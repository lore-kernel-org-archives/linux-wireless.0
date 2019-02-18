Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5716BC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 15:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32A13217D9
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 15:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbfBRPP1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 10:15:27 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33779 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730509AbfBRPP1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 10:15:27 -0500
Received: by mail-wm1-f67.google.com with SMTP id h22so9889wmb.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2019 07:15:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UHPpJT5oiNNLod+IJDRGWkaQD0QAk6ppGoNG+v3R+44=;
        b=FXU+LQgpMRqryHceMhyDZc3HrLcfZFNCZnEwwbyy05FV1eLOGyBIyuqXaV5zqzNWef
         RvqFo1qAxx25v+o1UG1hWjwd6HRSBn36GJMuKza9eStjlDqfJ4yxJFXb9VvAyDgWlbp+
         jGJagu3QiQ3znCPeKcbcP9BhvldXDk+QIJZ+DDIdBUuwgKtY7Bs9/oPQE6o35mpvztgX
         LrZRTTc9CJIhkQOxKcPPgNFolNvK1k9QE671iN7CO8lZWhTkif0AgXBGmoK8U+o1AdnV
         k0ARFxjOqm4KKyYCj4RCcU31EJDHZow0GTmvljsT0fwK3F8ur9luR+A5ngXMfz9KqttV
         Ksdw==
X-Gm-Message-State: AHQUAubnHuVn5XY+Rrv870wdRiCn6uN5q10rwNWng214y/bFAaiNtZ9q
        86QMgUICoWdMwLELFD3bhANKew==
X-Google-Smtp-Source: AHgI3Ib0T5ZaxEzdKMFpaqEIMeBm80RzQaKocrsq+3wRzwjmD+fvbRzgpX2QU36WjA8ziBF9TxIaTg==
X-Received: by 2002:a1c:80c4:: with SMTP id b187mr15261442wmd.23.1550502925478;
        Mon, 18 Feb 2019 07:15:25 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id c18sm16373689wre.32.2019.02.18.07.15.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 Feb 2019 07:15:24 -0800 (PST)
Date:   Mon, 18 Feb 2019 16:15:22 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Rosen Penev <rosenp@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
Message-ID: <20190218151521.GB9283@localhost.localdomain>
References: <CAJ0CqmVNF83bWgc+LSQ3_i=zfp-sXC5Nf=nKfqB3SWa8r7sKdQ@mail.gmail.com>
 <83A1D243-9073-48D1-9F26-5A2581DCB829@gmail.com>
 <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
 <1547404075.1582.0@smtp.gmail.com>
 <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
 <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
 <20190114091841.GA23045@localhost.localdomain>
 <CAKxU2N8ioMszBCyQcH7CVhgBdW4aj7yZ+kYQe14DCV5OSAnxrg@mail.gmail.com>
 <20190115090400.GA2267@localhost.localdomain>
 <20190218143742.GA11872@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218143742.GA11872@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> (cc: IOMMU & page_frag_alloc maintainers)
> 
> On Tue, Jan 15, 2019 at 10:04:01AM +0100, Lorenzo Bianconi wrote:
> > > On Mon, Jan 14, 2019 at 1:18 AM Lorenzo Bianconi
> > > <lorenzo.bianconi@redhat.com> wrote:
> > > >
> > > > > On Sun, Jan 13, 2019 at 11:00 AM Lorenzo Bianconi
> > > > > <lorenzo.bianconi@redhat.com> wrote:
> > > > > >
> > > > > > >
> > > > > > >
> > > > > > > On Sun, Jan 13, 2019 at 5:33 AM, Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
> > > > > > >
> > > > > > > Direct. No VM used. This is the only peripheral causing this issue.
> > > > > > >
> > > > > > > Is the device connected to a usb3.0 port? If so, could you please try to connect the dongle to a 2.0 one?
> > > > > > >
> > > > > > > I tried through a USB 2.0 port. Shouldn't make a difference as they both use the xhci driver.
> > > > > > >
> > > > > >
> > > > > > mt76x2u supports scatter-gather on usb 3.0 (not on 2.0)
> > > > > Tried a USB 3 port. Same result.
> > > > > >
> > > > > > > Could you please double check if IOMMU is enabled?
> > > > > > >
> > > > > >
> > > > > > Have you tried to disable it? Does it make any difference?
> > > > > No idea how. UEFI doesn't seem to show anything similar.
> > > > >
> > > > > Similar bug report: https://bugzilla.kernel.org/show_bug.cgi?id=202241
> 
> FWIW: I provided some patches in the bugzilla, which were reported to
> solve the problem. But I looking for confirmation if both are needed:
> 
> 0001-mt76x02u-use-usb_bulk_msg-to-upload-firmware.patch
> 0002-mt76usb-do-not-use-compound-head-page-for-SG-I-O.patch
> 
> Or problem can be solved by just one of it (either first or second).
> 
> Additionally I'm not 100% sure if
> 
> 0002-mt76usb-do-not-use-compound-head-page-for-SG-I-O.patch
> 
> is correct. So perhaps some IOMMU maintainer could look at it.
> 
> > > > You should be able to disable iommu using GRUB_CMDLINE_LINUX in
> > > > /etc/default/grub (I guess setting iommu=off and reinstalling grub)
> > > > https://wiki.gentoo.org/wiki/IOMMU_SWIOTLB
> > > Yep. Working great now. I wonder what mt76 is doing to cause the crash though...
> > 
> > Thanks for bisecting the issue. 
> 
> Lorenzo, what you mean by 'bisecting' here ? Someone did 'git bisect'
> on this issue?
> 

Hi Stanislaw,

I was meaning 'help bisecting' the issue

> > I think amd iommu does not support well usb scatter-gather
> > (used by default in mt76u). I am working on a series in order to add the possibility to
> > disable it.
> 
> Even if that true that AMD IOMMU does not support 'well' SG (what I think
> is not true) disabling SG in mt76 driver is not right solution. Right
> solution would be propagate the issue to AMD IOMMU maintainers
> (already CCed).

I meant that AMD iommu seems to have different constraints respect to Intel
one.

Regards,
Lorenzo

> 
> One problem in mt76 is page_frag_alloc() usage with different sizes.
> page_frag_alloc() unlike like other allocators do not assure alignment
> and relay on callers to provide buffers sizes that are aligned.
> Unaligned buffer might then not be appropriate for DMA.
> 
> Another issue is that dma_map_sg() & dma_map_page() may require some 
> constraints. I'm not sure about that and I want to clarify that with 
> CCed mm maintainers. I think DMA drivers may expect sg->offset < PAGE_SIZE
> for both dma_map_sg() and dma_map_page(). Additionally dma_map_page()
> maight expect that offset & length specify buffer within one page.
> 
> Stanislaw
