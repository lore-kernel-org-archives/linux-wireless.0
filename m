Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398E7C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 07:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06F5C20863
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 07:21:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j9QTaHR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfCDHU6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 02:20:58 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45427 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfCDHU6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 02:20:58 -0500
Received: by mail-ot1-f66.google.com with SMTP id i12so3390511otp.12;
        Sun, 03 Mar 2019 23:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PeIiz6xIRQQqvVMsz6L9PKpXIdEI4B6QAI9xHz0szis=;
        b=j9QTaHR6B8UI47ZS0GRMj+cQrZhDP5FhQJAPa5c3Pg2d6G3DkVIXIHmWZ6E1mPqaF9
         O0rfC1D0tcdI7zNPEcd87D7hly9kyqgMxR5kyZx2tJh54DmTc4FylOtG+ivVMeevgN7T
         cRxUZ549LEpXnb9qbJd5efwnGCWViN5dtxcHso8hW8WvxbXw0TLReTPUei3DxNojujMw
         DnLdq8U0gliJBrpgrH12uD9Aj2aXNzBBTDAMvF3jYDjvCK3BiwuZo9zJlNPE3pN9htso
         /L3qmN0TVnh+kel8KoNRtvLZLY4azExcz0ZPikedgMcIt6LgpDbKNxyf6FKJ9HGpOTJc
         0EPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PeIiz6xIRQQqvVMsz6L9PKpXIdEI4B6QAI9xHz0szis=;
        b=Fw2NAsjnLh6lEJzQuDTei7kciRhWoCdlqeBhhQ6L/T5icXSHvmHQ5KfrbwR5/STl6f
         1fqkPxA9U/4diNNz2Lf6RRlYfLMB8MVmt7U/jGjFGPd1e3Q14A1+vi2L9NAQsZYlLYGg
         kncitd8ZAIW8P9AGIgYq6HW41AdmJmmVi1+prJpuMgClKTcRZ0q/qRSXGsMq5QbbuzPX
         ycxM1AlW4Cgcpd631if65Xe4OY/FrVKvBn6cv8fvhv5JzrWosKqqKK51PFh4fJp1a+Ll
         +EmhVpmtt/CvqF9JJhq+zAwlRqMSWME87Mw/k3yBlLjOdTnVhCDsZBKeSZTTbT/Ap+K5
         Rh9w==
X-Gm-Message-State: APjAAAXI7SiqcH1APQs+c5NfIQqNnyJj+Z1FfHaBtj0+K4Lnyw00RIOz
        24qZDw7vu/fLYM2ENdet6hAiQpOfCRuqBn2AXH0EIw==
X-Google-Smtp-Source: APXvYqy/g3aye8RR3liC0QQcq8TdCmGMLnrXWkjgvxcExoUFQ6aeHfEZJq42PgYlLZ37rs3EPtLaLmTc0xVCLk+EN0I=
X-Received: by 2002:a9d:65c1:: with SMTP id z1mr11892189oth.277.1551684057079;
 Sun, 03 Mar 2019 23:20:57 -0800 (PST)
MIME-Version: 1.0
References: <20190115090400.GA2267@localhost.localdomain> <20190218143742.GA11872@redhat.com>
 <20190226100535.GA20740@8bytes.org> <20190226103450.GA2989@redhat.com>
 <20190226104413.GH20740@8bytes.org> <20190226112407.GB2989@redhat.com>
 <20190228090411.GA24938@redhat.com> <20190228104223.GA2749@redhat.com>
 <20190228121948.GD6072@redhat.com> <20190228134029.GC1594@8bytes.org> <20190304071037.GA2787@redhat.com>
In-Reply-To: <20190304071037.GA2787@redhat.com>
From:   Rosen Penev <rosenp@gmail.com>
Date:   Sun, 3 Mar 2019 23:20:45 -0800
Message-ID: <CAKxU2N-k-9DCYBv6W3CohL963dr3AeY3VHyt8FrUuo=BfacDsw@mail.gmail.com>
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Mar 3, 2019 at 11:10 PM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> On Thu, Feb 28, 2019 at 02:40:29PM +0100, Joerg Roedel wrote:
> > On Thu, Feb 28, 2019 at 01:19:48PM +0100, Stanislaw Gruszka wrote:
> > > Nevermind, the patch is wrong, s->dma_address is initalized in sg_num_pages().
> >
> > Yes, it is. In sg_num_pages() the offset into the IOMMU mapping is
> > stored in s->dma_address, taking also the segment boundary mask into
> > account. map_sg() later only adds the base-address to that.
>
> I have some more info about the issues in
> https://bugzilla.kernel.org/show_bug.cgi?id=202673
>
> We have some bugs in mt76. Apparently we should not use
> page_frag_alloc() with size bigger than PAGE_SIZE as page_frag_alloc()
> can fallback to single page allocation. And also we should not make
> sizes unaligned as pointed in commit:
> 3bed3cc4156e ("net: Do not allocate page fragments that are not skb aligned"
As a small and totally unrelated note, page_frag_alloc is only used in
mt76 and the nvme driver ;)
>
> However after fixing that mt76usb still did not work. To make things
> work we had to change rx frag size from 2048 to PAGE_SIZE and change
> virt_to_head_page() to virt_to_page() when setting SG's.
>
> I think I understand why first change was needed. If we do 2 separate
> dma maps of 2 different buffers in single page i.e (PAGE + off=0
> and PAGE + off=2048) it causes problem. So either map_sg() return
> error which mt76usb does not handle correctly or there is issue
> in AMD IOMMU because two dma maps use the same page.
>
> But I don't understand why the second change was needed. Without
> it we have issue with incorrect page->_refcount . It is somehow
> related with AMD IOMMU, because on different platforms we do not
> have such problems.
>
> Joerg, could you look at this ? Thanks.
>
> Stanislaw
