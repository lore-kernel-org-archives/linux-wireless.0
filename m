Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34863C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 07:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F387214AE
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 07:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfCLHNS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 03:13:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbfCLHNS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 03:13:18 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4259A308125D;
        Tue, 12 Mar 2019 07:13:18 +0000 (UTC)
Received: from localhost (ovpn-204-138.brq.redhat.com [10.40.204.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 770EC60A9A;
        Tue, 12 Mar 2019 07:13:15 +0000 (UTC)
Date:   Tue, 12 Mar 2019 08:13:14 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Rosen Penev <rosenp@gmail.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, jan.viktorin@gmail.com
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
Message-ID: <20190312071314.GB2483@redhat.com>
References: <20190226103450.GA2989@redhat.com>
 <20190226104413.GH20740@8bytes.org>
 <20190226112407.GB2989@redhat.com>
 <20190228090411.GA24938@redhat.com>
 <20190228104223.GA2749@redhat.com>
 <20190228121948.GD6072@redhat.com>
 <20190228134029.GC1594@8bytes.org>
 <20190304071037.GA2787@redhat.com>
 <CAKxU2N-k-9DCYBv6W3CohL963dr3AeY3VHyt8FrUuo=BfacDsw@mail.gmail.com>
 <20190311084319.GA3310@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311084319.GA3310@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 12 Mar 2019 07:13:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 11, 2019 at 09:43:19AM +0100, Stanislaw Gruszka wrote:
> > > However after fixing that mt76usb still did not work. To make things
> > > work we had to change rx frag size from 2048 to PAGE_SIZE and change
> > > virt_to_head_page() to virt_to_page() when setting SG's.
> >
> > > I think I understand why first change was needed. If we do 2 separate
> > > dma maps of 2 different buffers in single page i.e (PAGE + off=0
> > > and PAGE + off=2048) it causes problem. So either map_sg() return
> > > error which mt76usb does not handle correctly or there is issue
> > > in AMD IOMMU because two dma maps use the same page.
> 
> Any comment on that? Is fine or not to do 2 or more dma mappings
> within the same single page on AMD IOMMU? If not, is there any
> mechanism for drivers to find out about this limitation to prevent
> to prepare wrong SG buffers?

FTR: it was confirmed by Jan (bug reporter) the 2 or more dma mappings
within single page works with AMD IOMMU. Most likely it was needed
previously to workaround this sg->offset problem until proper fix to
AMD IOMMU was applied.

Stanislaw 
