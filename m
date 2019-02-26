Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60BAC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 10:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E7E62173C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 10:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfBZKoQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 05:44:16 -0500
Received: from 8bytes.org ([81.169.241.247]:41412 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbfBZKoQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 05:44:16 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B3D6841A; Tue, 26 Feb 2019 11:44:14 +0100 (CET)
Date:   Tue, 26 Feb 2019 11:44:13 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Rosen Penev <rosenp@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Samuel Sieb <samuel@sieb.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: MT76x2U crashes XHCI driver on AMD Ryzen system
Message-ID: <20190226104413.GH20740@8bytes.org>
References: <CAJ0CqmUgPWNJtCW4Q__sOtB8w-YtwW+uZy7crxMNrmSgQ6OFyA@mail.gmail.com>
 <1547404075.1582.0@smtp.gmail.com>
 <CAJ0CqmU7k5i26g7dGPxNdts7Gm67W6qNsr4vYuW05ugsEF1ohw@mail.gmail.com>
 <CAKxU2N-+CTaRdJMFVRdozJ5TTpN+_4thiDRBJBFq8gGtuRVYvA@mail.gmail.com>
 <20190114091841.GA23045@localhost.localdomain>
 <CAKxU2N8ioMszBCyQcH7CVhgBdW4aj7yZ+kYQe14DCV5OSAnxrg@mail.gmail.com>
 <20190115090400.GA2267@localhost.localdomain>
 <20190218143742.GA11872@redhat.com>
 <20190226100535.GA20740@8bytes.org>
 <20190226103450.GA2989@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226103450.GA2989@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 26, 2019 at 11:34:51AM +0100, Stanislaw Gruszka wrote:
> On Tue, Feb 26, 2019 at 11:05:36AM +0100, Joerg Roedel wrote:
> If sg->offset > PAGE_SIZE is fine then most likely we have problem with
> alignment.

The map_sg implementation in the AMD IOMMU driver uses sg_phys() which
handles the sg->page + sg->offset calculation fine.

> Note hat issue is with dma_map_sg(), switching to dma_map_single()
> by using urb->transfer_buffer instead of urb->sg make things work
> on AMD IOMMU.

On the other hand this points to a bug in the driver, I'll look further
if I can spot something there.

Regards,

	Joerg
